#include "z3Checker.h"
#include <iostream>

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Plan validity checking through Z3 solver.            */
/********************************************************/

bool Z3Checker::checkPlan(Plan* p, bool optimizeMakespan, TControVarValues* cvarValues)
{
    z3::set_param("parallel.enable", true);
    //std::cout << (optimizeMakespan ? "o" : ".");
    this->optimizeMakespan = optimizeMakespan;
    bool valid = false;
    planComponents.calculate(p);
    //for (int i = 0; i < planComponents.size(); i++)
    //    std::cout << i << ": " << planComponents.get(i)->action->name << std::endl;
    try {
        context c;
        this->cont = &c;
        for (TStep s = 0; s < planComponents.size(); s++) {
            defineVariables(planComponents.get(s), s);
        }
        if (optimizeMakespan) 
            optimizer = new optimize(c);
        else checker = new solver(c);
        for (TStep s = 0; s < planComponents.size(); s++) {
            defineConstraints(planComponents.get(s), s);
        }
        TStep lastStep = planComponents.size() - 1;
        if (optimizeMakespan) {
            optimizer->minimize(getPointVar(stepToEndPoint(lastStep)));
            valid = optimizer->check() == sat;
            //showModel(optimizer->get_model());
            if (valid) updatePlan(p, optimizer->get_model(), cvarValues);
        }
        else {
            valid = checker->check() == sat;
            //showModel(checker->get_model());
            if (valid) updatePlan(p, checker->get_model(), cvarValues);
        }
        if (optimizeMakespan) delete optimizer;
        else delete checker;
        stepVars.clear();
        Z3_finalize_memory();
    }
    catch (exception& ex) {
        std::cout << "unexpected error: " << ex << "\n";
    }
    //std::cout << (valid ? "v" : "x") << std::endl;
    return valid;
}

void Z3Checker::defineVariables(Plan* p, TStep s)
{
    char varName[10];
    this->stepVars.emplace_back(s, p);
    Z3StepVariables& vars = this->stepVars.back();
    sprintf_s(varName, 10, "d%d", s);
    vars.times.push_back(cont->int_const(varName));       // Duration
    sprintf_s(varName, 10, "t%d", stepToStartPoint(s));
    vars.times.push_back(cont->int_const(varName));       // Start time
    sprintf_s(varName, 10, "t%d", stepToEndPoint(s));
    vars.times.push_back(cont->int_const(varName));       // End time
    if (p->cvarValues != nullptr) {
        for (int cv = 0; cv < p->cvarValues->size(); cv++) {
            sprintf_s(varName, 10, "c%ds%d", cv, s);    // Control var
            vars.controlVars.push_back(cont->int_const(varName));
        }
    }
    if (p->startPoint.numVarValues != nullptr) {
        for (TFluentInterval& i : *(p->startPoint.numVarValues)) {
            sprintf_s(varName, 10, "f%dt%d", i.numVar, stepToStartPoint(s));    // Fluent
            vars.startFluentIndex[i.numVar] = (int)vars.fluents.size();
            vars.fluents.push_back(cont->int_const(varName));
        }
    }
    if (p->endPoint.numVarValues != nullptr) {
        for (TFluentInterval& i : *(p->endPoint.numVarValues)) {
            sprintf_s(varName, 10, "f%dt%d", i.numVar, stepToEndPoint(s));    // Fluent
            vars.endFluentIndex[i.numVar] = (int)vars.fluents.size();
            vars.fluents.push_back(cont->int_const(varName));
        }
    }
}

void Z3Checker::defineConstraints(Plan* p, TStep s)
{
    SASAction* a = p->action;
    TTimePoint start = stepToStartPoint(s), end = stepToEndPoint(s);
    for (SASNumericCondition& c : a->startNumCond) {    // Fluents and control vars. conditions
        defineNumericContraint(c, start);
    }
    for (SASNumericCondition& c : a->overNumCond) {
        defineNumericContraint(c, start);
        defineNumericContraint(c, end);
    }
    for (SASNumericCondition& c : a->endNumCond) {
        defineNumericContraint(c, end);
    }
    for (SASNumericEffect& e : a->startNumEff) {
        defineNumericEffect(e, start);
    }
    for (SASNumericEffect& e : a->endNumEff) {
        defineNumericEffect(e, end);
    }
    if (a->isTIL) add(getPointVar(start) == 0);
    else if (s == 0) add(getPointVar(0) == -1);
    for (SASDurationCondition& d : a->duration.conditions) {    // Action duration
        defineDurationConstraint(d, s);
        add(getPointVar(end) == getPointVar(start) + getDurationVar(s));
    }
    for (TOrdering o : p->orderings) {      // Orderings
        TTimePoint tp1 = firstPoint(o), tp2 = secondPoint(o);
        if (tp1 + 1 != tp2 || (tp1 & 1) == 1)
            add(getPointVar(tp1) < getPointVar(tp2));
    }
}

expr& Z3Checker::getDurationVar(TStep s)
{
    return stepVars[s].times[0];
}

expr& Z3Checker::getPointVar(TTimePoint tp)
{
    return stepVars[timePointToStep(tp)].times[1 + (tp & 1)]; // 1 -> start, 2 -> end
}

expr& Z3Checker::getControlVar(int var, TStep s)
{
    return stepVars[s].controlVars[var];
}

expr& Z3Checker::getProductorVar(TVariable var, TTimePoint tp)
{
    TStep s = timePointToStep(tp);
    Plan* p = planComponents.get(s);
    if ((tp & 1) == 1) { // End point
        for (TNumericCausalLink& cl : p->endPoint.numCausalLinks) {
            if (cl.var == var) {
                return getFluent(cl.var, cl.timePoint);
            }
        }
    }
    for (TNumericCausalLink& cl : p->startPoint.numCausalLinks) {
        if (cl.var == var) {
            return getFluent(cl.var, cl.timePoint);
        }
    }
    for (TNumericCausalLink& cl : p->endPoint.numCausalLinks) {
        if (cl.var == var) {
            return getFluent(cl.var, cl.timePoint);
        }
    }
    std::cout << "Error: numeric causal link not defined for fluent " << var << " in timepoint " << tp 
        << "(action " << p->action->name << ")" << std::endl;
    exit(0);
    return getFluent(0, 0); // For avoiding warnings
}

expr& Z3Checker::getFluent(TVariable var, TTimePoint tp)
{
    Z3StepVariables& vars = stepVars[timePointToStep(tp)];
    int index = (tp & 1) == 0 ? vars.startFluentIndex[var] : vars.endFluentIndex[var];
    return vars.fluents[index];
}

expr Z3Checker::getNumericExpression(SASNumericExpression& e, TTimePoint tp, bool keepValue)
{
    switch (e.type) {
    case 'N':   // GE_NUMBER
        return keepValue ? cont->int_val((int)e.value) : cont->int_val(intVal(e.value));
    case 'V':   // GE_VAR
        return getProductorVar(e.var, tp);
    case '+':
        return getNumericExpression(e.terms[0], tp, false) + getNumericExpression(e.terms[1], tp, false);
    case '-':
        return getNumericExpression(e.terms[0], tp, false) - getNumericExpression(e.terms[1], tp, false);
    case '/':
        return getNumericExpression(e.terms[0], tp, true) / getNumericExpression(e.terms[1], tp, true);
    case '*':
        return getNumericExpression(e.terms[0], tp, true) * getNumericExpression(e.terms[1], tp, true);
    case 'D': // GE_DURATION
        return getDurationVar(timePointToStep(tp));
    case 'C': // GE_CONTROL_VAR
        return getControlVar(e.var, timePointToStep(tp));
    }
    std::cout << "Error: wrong numeric expression" << std::endl;
    exit(0);
    return cont->int_val(0); // To avoid warnings
}

void Z3Checker::add(expr const& e)
{
    //std::cout << "Constraint: " << e.to_string() << std::endl;
    if (optimizeMakespan) optimizer->add(e);
    else checker->add(e);
}

void Z3Checker::defineNumericContraint(SASNumericCondition& prec, TTimePoint tp)
{
    switch (prec.comp) {
    case '=':
        add(getNumericExpression(prec.terms[0], tp, false) == getNumericExpression(prec.terms[1], tp, false));
        break;
    case '<':
        add(getNumericExpression(prec.terms[0], tp, false) < getNumericExpression(prec.terms[1], tp, false));
        break;
    case 'L':
        add(getNumericExpression(prec.terms[0], tp, false) <= getNumericExpression(prec.terms[1], tp, false));
        break;
    case '>':
        add(getNumericExpression(prec.terms[0], tp, false) > getNumericExpression(prec.terms[1], tp, false));
        break;
    case 'G':
        add(getNumericExpression(prec.terms[0], tp, false) >= getNumericExpression(prec.terms[1], tp, false));
        break;
    case 'N':
        add(getNumericExpression(prec.terms[0], tp, false) != getNumericExpression(prec.terms[1], tp, false));
        break;
    }
}

void Z3Checker::defineDurationConstraint(SASDurationCondition& d, TStep s)
{
    TTimePoint tp = d.time != 'E' ? stepToStartPoint(s) : stepToEndPoint(s);
    switch (d.comp) {
    case '=':
        add(getDurationVar(s) == getNumericExpression(d.exp, tp, false));
        break;
    case '<':
        add(getDurationVar(s) < getNumericExpression(d.exp, tp, false));
        break;
    case 'L':
        add(getDurationVar(s) <= getNumericExpression(d.exp, tp, false));
        break;
    case '>':
        add(getDurationVar(s) > getNumericExpression(d.exp, tp, false));
        break;
    case 'G':
        add(getDurationVar(s) >= getNumericExpression(d.exp, tp, false));
        break;
    case 'N':
        add(getDurationVar(s) != getNumericExpression(d.exp, tp, false));
        break;
    }
}

void Z3Checker::defineNumericEffect(SASNumericEffect& e, TTimePoint tp)
{
    switch (e.op) {
    case '=': 
        add(getFluent(e.var, tp) == getNumericExpression(e.exp, tp, false));
        break;
    case '+':
        add(getFluent(e.var, tp) == getProductorVar(e.var, tp) + getNumericExpression(e.exp, tp, false));
        break;
    case '-':
        add(getFluent(e.var, tp) == getProductorVar(e.var, tp) - getNumericExpression(e.exp, tp, false));
        break;
    case '*':
        add(getFluent(e.var, tp) == getProductorVar(e.var, tp) * getNumericExpression(e.exp, tp, false));
        break;
    case '/':
        add(getFluent(e.var, tp) == getProductorVar(e.var, tp) / getNumericExpression(e.exp, tp, false));
        break;
    }
}

void Z3Checker::showModel(model m)
{
    for (unsigned i = 0; i < m.size(); i++) {
        func_decl v = m[i];
        assert(v.arity() == 0);
        std::cout << v.name() << " = " << m.get_const_interp(v) << "\n";
    }
}

void Z3Checker::updatePlan(Plan* p, model m, TControVarValues* cvarValues)
{
    TTimePoint tp = 0;
    for (TStep s = 0; s < planComponents.size(); s++) {
        TTimePoint startPoint = stepToStartPoint(s), endPoint = startPoint + 1;
        TFloatValue startTime = (TFloatValue)m.eval(getPointVar(tp++)).as_double() / 1000.0f;
        TFloatValue endTime = (TFloatValue)m.eval(getPointVar(tp++)).as_double() / 1000.0f;
        //std::cout << "Time point " << stepToStartPoint(s) << ": " << startTime << std::endl;
        //std::cout << "Time point " << stepToEndPoint(s) << ": " << endTime << std::endl;
        Plan* pc = planComponents.get(s);
        if (cvarValues != nullptr && pc->cvarValues != nullptr) {
            std::vector<float> valuesList;
            for (int cv = 0; cv < pc->action->controlVars.size(); cv++)
                valuesList.push_back(m.eval(getControlVar(cv, s)).as_double() / 1000.0f);
            (*cvarValues)[s] = valuesList;
        }
        if (p == pc) {
            p->setTime(startTime, endTime, p->fixedInit);
        }
        else {
            if (abs(startTime - pc->startPoint.updatedTime) > EPSILON) {
                //std::cout << "Time point " << startPoint << ": " << startTime << std::endl;
                p->addPlanUpdate(startPoint, startTime);
            }
            if (abs(endTime - pc->endPoint.updatedTime) > EPSILON) {
                //std::cout << "Time point " << endPoint << ": " << endTime << std::endl;
                p->addPlanUpdate(endPoint, endTime);
            }
        }
        //updateFluentValues(pc->startPoint.numVarValues, startPoint, m);
        //updateFluentValues(pc->startPoint.numVarValues, endPoint, m);
    }
    //showModel(checker->get_model());
}

void Z3Checker::updateFluentValues(std::vector<TFluentInterval>* numValues, TTimePoint tp, model& m)
{
    if (numValues == nullptr) return;
    for (int i = 0; i < numValues->size(); i++) {
        TFluentInterval* f = &(numValues->at(i));
        TFloatValue value = (TFloatValue)m.eval(getFluent(f->numVar, tp)).as_double() / 1000.0f;
        f->interval.minValue = f->interval.maxValue = value;
    }
}
