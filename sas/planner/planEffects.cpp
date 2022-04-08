#include "planEffects.h"
#include <iostream>

using namespace std;

/********************************************************/
/* CLASS: PlanEffect                                    */
/********************************************************/

void PlanEffect::add(TTimePoint time, unsigned int iteration) {
	if (this->iteration != iteration) {		// Delete data from previous iterations
		timePoints.clear();
		this->iteration = iteration;
	}
	timePoints.push_back(time);
}


/********************************************************/
/* CLASS: VarChange                                    */
/********************************************************/

void VarChange::add(TValue v, TTimePoint time, unsigned int iteration) {
	if (this->iteration != iteration) {		// Delete data from previous iterations
		values.clear();
		timePoints.clear();
		this->iteration = iteration;
	}
	values.push_back(v);
	timePoints.push_back(time);
}


/********************************************************/
/* CLASS: PlanEffects                                   */
/********************************************************/

PlanEffects::PlanEffects(SASTask* task)
{
	this->task = task;
	int numVariables = (int)task->variables.size();
	int numValues = (int)task->values.size();
	planEffects = new PlanEffect * [numVariables];
	for (int i = 0; i < numVariables; i++) {
		planEffects[i] = new PlanEffect[numValues];
	}
	varChanges = new VarChange[numVariables];
	int numNumVariables = (int)task->numVariables.size();
	this->iteration = 0;
}

PlanEffects::~PlanEffects()
{
	delete[] varChanges;
	unsigned int numVariables = (unsigned int)task->variables.size();
	for (unsigned int i = 0; i < numVariables; i++) {
		delete[] planEffects[i];
	}
	delete[] planEffects;
}

void PlanEffects::setCurrentIteration(unsigned int currentIteration, PlanComponents* planComponents)
{
	this->iteration = currentIteration;
	this->planComponents = planComponents;
	this->numStates.clear();
}

void PlanEffects::addEffect(SASCondition& eff, TTimePoint timePoint)
{
	TVariable var = eff.var;
	TValue value = eff.value;
	planEffects[var][value].add(timePoint, iteration);
	varChanges[var].add(value, timePoint, iteration);
	//cout << task->variables[var].name << "=" << task->values[value].name << " [" << timePoint << "]" << endl;
}

void PlanEffects::addNumEffect(TFluentInterval& eff, TTimePoint timePoint)
{
	NumVarChange* state;
	if (this->numStates.empty() || this->numStates.back().timepoint != timePoint) { // Add new timepoint
		this->numStates.emplace_back();
		state = &this->numStates.back();
		state->timepoint = timePoint;
		state->values.resize(task->numVariables.size(), nullptr);
	}
	else {
		state = &this->numStates.back();
	}
	state->values[eff.numVar] = &(eff.interval);
	//cout << task->numVariables[eff.numVar].name << " = (" << eff.interval.minValue <<
	//	", " << eff.interval.maxValue << ") [" << timePoint << "]" << endl;
}

TFloatValue PlanEffects::getMinValue(const SASNumericExpression* term, int stateIndex, std::vector<SASControlVar>* cvs)
{
	TFloatValue v1, v2;
	switch (term->type) {
	case 'N':	// GE_NUMBER
		return term->value;
	case 'V':	// GE_VAR
		return getNumVarMinValue(term->var, stateIndex);
	case 'D':	// GE_DURATION
		return EPSILON;
		//AQUI: La duracion es la de la accion : puede calcularse en función de las condiciones de la duracion
		//return getMinActionDuration(numStates[stateIndex].timepoint);
	case 'C':	// GE_CONTROL_VAR
		return cvs->at(term->var).minValue;
		//return getMinControlVarValue(numStates[stateIndex].timepoint, term->var);
	case '+':	// GE_SUM
		v1 = getMinValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMinValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 + v2;
	case '-':	// GE_SUB
		v1 = getMinValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMaxValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 - v2;
	case '/':	// GE_DIV
		v1 = getMinValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMaxValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 / v2;
	case '*':	// GE_MUL
		v1 = getMinValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMinValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 * v2;
	//case '#':	// GE_SHARP_T
	default:
		return FLOAT_UNKNOWN;
	}
}

TFloatValue PlanEffects::getMaxValue(const SASNumericExpression* term, int stateIndex, std::vector<SASControlVar>* cvs)
{
	TFloatValue v1, v2;
	switch (term->type) {
	case 'N':	// GE_NUMBER
		return term->value;
	case 'V':	// GE_VAR
		return getNumVarMaxValue(term->var, stateIndex);
	case 'D':	// GE_DURATION
		return FLOAT_INFINITY;
		//AQUI: La duracion es la de la accion: puede calcularse en función de las condiciones de la duracion
		//return getMaxActionDuration(numStates[stateIndex].timepoint);
	case 'C':	// GE_CONTROL_VAR
		//return getMaxControlVarValue(numStates[stateIndex].timepoint, term->var);
		return cvs->at(term->var).maxValue;
	case '+':	// GE_SUM
		v1 = getMaxValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMaxValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 + v2;
	case '-':	// GE_SUB
		v1 = getMaxValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMinValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 - v2;
	case '/':	// GE_DIV
		v1 = getMaxValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMinValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 / v2;
	case '*':	// GE_MUL
		v1 = getMaxValue(&(term->terms.at(0)), stateIndex, cvs);
		if (v1 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		v2 = getMaxValue(&(term->terms.at(1)), stateIndex, cvs);
		if (v2 == FLOAT_UNKNOWN) return FLOAT_UNKNOWN;
		return v1 * v2;
		//case '#':	// GE_SHARP_T
	default:
		return FLOAT_UNKNOWN;
	}
}

TFloatValue PlanEffects::getNumVarMinValue(TVariable var, int stateIndex)
{
	if (numStates[stateIndex].values[var] != nullptr)
		return numStates[stateIndex].values[var]->minValue;
	while (stateIndex > 0) {
		stateIndex--;
		if (numStates[stateIndex].values[var] != nullptr)
			return numStates[stateIndex].values[var]->minValue;
	}
	return FLOAT_UNKNOWN;
}

TFloatValue PlanEffects::getMinActionDuration(TTimePoint timepoint)
{
	TStep step = timePointToStep(timepoint);
	Plan* plan = planComponents->get(step);
	return plan->actionDuration.minValue;
}

TFloatValue PlanEffects::getMinControlVarValue(TTimePoint timepoint, TVariable var)
{
	TStep step = timePointToStep(timepoint);
	Plan* plan = planComponents->get(step);
	return plan->cvarValues->at(var).minValue;
}

TFloatValue PlanEffects::getNumVarMaxValue(TVariable var, int stateIndex)
{
	if (numStates[stateIndex].values[var] != nullptr)
		return numStates[stateIndex].values[var]->maxValue;
	while (stateIndex > 0) {
		stateIndex--;
		if (numStates[stateIndex].values[var] != nullptr)
			return numStates[stateIndex].values[var]->maxValue;
	}
	return FLOAT_UNKNOWN;
}

TFloatValue PlanEffects::getMaxActionDuration(TTimePoint timepoint)
{
	TStep step = timePointToStep(timepoint);
	Plan* plan = planComponents->get(step);
	return plan->actionDuration.maxValue;
}

TFloatValue PlanEffects::getMaxControlVarValue(TTimePoint timepoint, TVariable var)
{
	TStep step = timePointToStep(timepoint);
	Plan* plan = planComponents->get(step);
	return plan->cvarValues->at(var).maxValue;
}
