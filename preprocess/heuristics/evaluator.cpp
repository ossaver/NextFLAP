#include "evaluator.h"
#include <iostream>
#include <assert.h>
#include <time.h>
#include "numericRPG.h"
using namespace std;

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* May 2017                                             */
/********************************************************/
/* Plan heuristic evaluator                             */
/********************************************************/

/********************************************************/
/* CLASS: Evaluator                                     */
/********************************************************/

void Evaluator::evaluate(Plan* p) {
	//	initializeOpenNodes();
	NumericRPG rpg(p->fs, tilActions, task);
	p->h = rpg.evaluate();

	//exit(0);
	// p->hLand = landmarks.countUncheckedNodes();
	//RPG rpg(&state, task, forceAtEndConditions, tilActions);
	//p->h = rpg.evaluate(task->hasPermanentMutexAction());
}

void Evaluator::calculateFrontierState(TState* fs)
{
	pq.clear();
	for (unsigned int i = 1; i < planComponents.size(); i++) {
		Plan* p = planComponents.get(i);
		pq.add(new ScheduledPoint(stepToStartPoint(i), p->startPoint.updatedTime, p));
		pq.add(new ScheduledPoint(stepToEndPoint(i), p->endPoint.updatedTime, p));
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

			/*
			int i = 0;
			while (i < openNodes.size()) {
				LandmarkCheck* l = openNodes[i];
				//cout << "Landmark " << l->toString(task, false) << endl;
				if (l->goOn(&state)) {	// The landmark holds in the state and we can progress
					l->check();
					openNodes.erase(openNodes.begin() + i); // Remove node from the open nodes list
					for (unsigned int k = 0; k < l->numNext(); k++) { // Go to the adjacent nodes
						LandmarkCheck* al = l->getNext(k);
						if (!al->isChecked() && !findOpenNode(al)) {
							openNodes.push_back(al); // Non-visited node -> append to open nodes
						}
					}
				}
				else {
					i++;
				}
			}
			*/
	}
}

/*
void Evaluator::initializeOpenNodes()
{
	landmarks.uncheckNodes();
	landmarks.copyRootNodes(&openNodes);
}

bool Evaluator::findOpenNode(LandmarkCheck* l)
{
	for (unsigned int i = 0; i < openNodes.size(); i++) {
		if (openNodes[i] == l) return true;
	}
	return false;
}
*/

void Evaluator::initialize(TState* state, SASTask* task, std::vector<SASAction*>* a, bool forceAtEndConditions) {
	this->task = task;
	tilActions = a;
	// this->forceAtEndConditions = forceAtEndConditions;
	// if (state == nullptr) landmarks.initialize(task, a);
	// else landmarks.initialize(state, task, a);
}

void Evaluator::calculateFrontierState(Plan* p)
{
	planComponents.calculate(p);
	p->fs = new TState(task);			// Make a copy of the initial state
	calculateFrontierState(p->fs);
}

/*
bool Evaluator::informativeLandmarks() {
	return landmarks.getNumInformativeNodes() > 0;
}
*/