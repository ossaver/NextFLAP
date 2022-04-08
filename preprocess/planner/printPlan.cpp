#include <iostream>
#include <iomanip>
#include "printPlan.h"
#include "planComponents.h"
#include "linearizer.h"
using namespace std;

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
			float duration = pc->endPoint.updatedTime - pc->startPoint.updatedTime;
			cout << fixed << setprecision(3) << pc->startPoint.updatedTime << ": "
				 << pc->action->name << " [" << fixed << setprecision(3) << duration
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
	cout << "; Makespan: " << fixed << setprecision(3) << makespan << endl;
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
