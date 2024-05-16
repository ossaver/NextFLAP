#include <iostream>
#include <iomanip>
#include <string>
#include "printPlan.h"
#include "planComponents.h"
#include "linearizer.h"

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Class to plan printing on screen.                    */
/********************************************************/

using namespace std;

std::string PrintPlan::actionName(SASAction* a)
{
	return a->name;
}

void PrintPlan::print(Plan* p, TControVarValues* cvarValues)
{
	PlanComponents planComponents;
	planComponents.calculate(p);
	Linearizer linearizer;
	linearizer.linearize(planComponents);
	float makespan = 0;
	for (TTimePoint tp : linearizer.linearOrder) {
		Plan* pc = planComponents.get(timePointToStep(tp));
		if ((tp & 1) == 0 && !pc->isRoot() && !pc->action->isGoal) {
			float duration = round3d(pc->endPoint.updatedTime) - round3d(pc->startPoint.updatedTime);
			cout << fixed << setprecision(3) << round3d(pc->startPoint.updatedTime - 0.001) << ": ("
				<< actionName(pc->action) << ") [" << fixed << setprecision(3) << round3d(duration)
				<< "]" << endl;
			if (cvarValues != nullptr && !pc->action->controlVars.empty()) {
				std::vector<float> values = cvarValues->at(timePointToStep(tp));
				for (int i = 0; i < values.size(); i++) {
					cout << "\t; Control parameter: " << pc->action->controlVars[i].name
						<< " = " << fixed << setprecision(3) << values[i] << endl;
				}
			}
			if (pc->endPoint.updatedTime > makespan)
				makespan = pc->endPoint.updatedTime;
		}
	}
	//cout << ";Makespan: " << fixed << setprecision(3) << makespan << endl;
	cout << ";Makespan: " << (int) (1000 * makespan - 1) << endl;
}

float PrintPlan::getMakespan(Plan* p)
{
	PlanComponents planComponents;
	planComponents.calculate(p);
	Linearizer linearizer;
	linearizer.linearize(planComponents);
	float makespan = 0;
	for (TTimePoint tp : linearizer.linearOrder) {
		Plan* pc = planComponents.get(timePointToStep(tp));
		if ((tp & 1) == 0 && !pc->isRoot() && !pc->action->isGoal && pc->endPoint.updatedTime > makespan)
			makespan = pc->endPoint.updatedTime;
	}
	return makespan;
}

void PrintPlan::rawPrint(Plan* p, SASTask* task)
{
	std::vector<Plan*> planComponents;
	Plan* current = p;
	while (current != nullptr) {
		planComponents.insert(planComponents.begin(), current);
		current = current->parentPlan;
	}
	for (int step = 0; step < planComponents.size(); step++) {
		p = planComponents[step];
		cout << "Plan component " << step << endl;
		cout << "  (" << stepToStartPoint(step) << ") " << p->action->name << " (" << stepToEndPoint(step) << ")" << endl;
		for (TOrdering o : p->orderings)
			cout << "  " << firstPoint(o) << " -> " << secondPoint(o) << endl;
		for (TCausalLink cl : p->startPoint.causalLinks) cout << "  " << cl.timePoint << " --> start, " <<
			task->variables[task->getVariableIndex(cl.varVal)].name << "=" << task->values[task->getValueIndex(cl.varVal)].name << endl;
		for (TNumericCausalLink cl : p->startPoint.numCausalLinks)
			cout << "  " << cl.timePoint << " --> start, " << task->numVariables[cl.var].name << endl;
		for (TCausalLink cl : p->endPoint.causalLinks) cout << "  " << cl.timePoint << " --> end, " <<
			task->variables[task->getVariableIndex(cl.varVal)].name << "=" << task->values[task->getValueIndex(cl.varVal)].name << endl;
		for (TNumericCausalLink cl : p->endPoint.numCausalLinks)
			cout << "  " << cl.timePoint << " --> end, " << task->numVariables[cl.var].name << endl;
	}
}
