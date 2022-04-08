#include "evaluator.h"
#include <iostream>
#include <assert.h>
#include <time.h>
#include "numericRPG.h"
using namespace std;

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Plan heuristic evaluator                             */
/********************************************************/

/********************************************************/
/* CLASS: Evaluator                                     */
/********************************************************/

// Evaluates a plan. Its heuristic value is stored in the plan (p->h)
void Evaluator::evaluate(Plan* p) {
	int limit = p->parentPlan->h;
	NumericRPG rpg(p->fs, tilActions, task, limit);
	p->h = rpg.evaluate();
}

// Evaluates the initial plan. Its heuristic value is stored in the plan (p->h)
void Evaluator::evaluateInitialPlan(Plan* p)
{
	int numActions = (int)task->actions.size(), limit = 100;
	usefulActions = new bool[numActions];
	for (int i = 0; i < numActions; i++) usefulActions[i] = false;
	NumericRPG rpg(p->fs, tilActions, task, limit);
	p->h = rpg.evaluateInitialPlan(usefulActions);
}

// Calculates the frontier state of a given plan. It also computes the number of useful actions included in the plan
void Evaluator::calculateFrontierState(TState* fs, Plan* currentPlan)
{
	std::unordered_set<int> visitedActions;
	pq.clear();
	for (unsigned int i = 1; i < planComponents.size(); i++) {
		Plan* p = planComponents.get(i);
		pq.add(new ScheduledPoint(stepToStartPoint(i), p->startPoint.updatedTime, p));
		pq.add(new ScheduledPoint(stepToEndPoint(i), p->endPoint.updatedTime, p));
		if (!p->action->isTIL && !p->action->isGoal) {
			int index = p->action->index;
			if (visitedActions.find(index) == visitedActions.end()) {
				visitedActions.insert(index);
				if (usefulActions[index])
					currentPlan->numUsefulActions++;
			}
		}
	}
	while (pq.size() > 0) {
		ScheduledPoint* p = (ScheduledPoint*)pq.poll();
		SASAction* a = p->plan->action;
		bool atStart = (p->p & 1) == 0;
		std::vector<SASCondition>* eff = atStart ? &a->startEff : &a->endEff;
		std::vector<TFluentInterval>* numEff = atStart ? p->plan->startPoint.numVarValues : p->plan->endPoint.numVarValues;
		delete p;
		for (SASCondition& c : *eff) {
			fs->state[c.var] = c.value;
		}
		if (numEff != nullptr) {
			for (TFluentInterval& f : *numEff) {
				fs->minState[f.numVar] = f.interval.minValue;
				fs->maxState[f.numVar] = f.interval.maxValue;
			}
		}
	}
}

// Destroyer
Evaluator::~Evaluator()
{
	delete[] usefulActions;
}

// Evaluator initialization
void Evaluator::initialize(TState* state, SASTask* task, std::vector<SASAction*>* a, bool forceAtEndConditions) {
	this->task = task;
	tilActions = a;
}

// Calculates the frontier state of a given plan. This state is stored in the plan (p->fs)
void Evaluator::calculateFrontierState(Plan* p)
{
	p->numUsefulActions = 0;
	planComponents.calculate(p);
	p->fs = new TState(task);			// Make a copy of the initial state
	calculateFrontierState(p->fs, p);
}
