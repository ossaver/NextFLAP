#include "planner.h"
#include <iostream>
#include "z3Checker.h"

using namespace std;

bool Planner::emptySearchSpace()
{
	return selector->size() == 0;
}

Planner::Planner(SASTask* task, Plan* initialPlan, TState* initialState, bool forceAtEndConditions,
	bool filterRepeatedStates, bool generateTrace, std::vector<SASAction*>* tilActions)
{
	startTime = clock();
	this->task = task;
	this->initialPlan = initialPlan;
	this->initialState = initialState;
	this->forceAtEndConditions = forceAtEndConditions;
	this->filterRepeatedStates = filterRepeatedStates;
	cout << "Filter repeated states: " << filterRepeatedStates << endl;
	this->parentPlanner = parentPlanner;
	this->expandedNodes = 0;
	this->generateTrace = generateTrace;
	this->tilActions = tilActions;
	successors = new Successors(initialState, task, forceAtEndConditions, filterRepeatedStates, tilActions);
	this->initialH = FLOAT_INFINITY;
	this->solution = nullptr;
	selector = new SearchQueue();
	successors->evaluator.calculateFrontierState(this->initialPlan);
	selector->add(this->initialPlan);
	/*actionsToCkeck = new bool[task->actions.size()];
	for (int i = 0; i < task->actions.size(); i++)
		actionsToCkeck[i] = false;*/
}

Plan* Planner::plan(float bestMakespan)
{
	clock_t t = clock();
	this->bestMakespan = bestMakespan;
	while (solution == nullptr && this->selector->size() > 0) {
		searchStep();
		if (toSeconds(t) >= 600)
			break;
	}
	return solution;
}

void Planner::clearSolution()
{
	solution = nullptr;
	successors->solution = nullptr;
}

bool Planner::checkPlan(Plan* p) {
	Z3Checker checker;
	p->z3Checked = true;
	bool valid = checker.checkPlan(p, false);
	return valid;
}

void Planner::markAsInvalid(Plan* p)
{
	markChildrenAsInvalid(p);
	Plan* parent = p->parentPlan;
	if (parent != nullptr && !parent->isRoot() && !parent->z3Checked) {
		if (!checkPlan(parent)) {
			markAsInvalid(parent);
		}
		else {
			//cout << "Invalid: " << p->action->name << endl;
			//actionsToCkeck[p->action->index] = true;
		}
	}
}

void Planner::markChildrenAsInvalid(Plan* p) {
	if (p->childPlans != nullptr) {
		for (Plan* child : *(p->childPlans)) {
			child->invalid = true;
			markChildrenAsInvalid(child);
		}
	}
}

void Planner::searchStep() {
	Plan* base = selector->poll();
	if (!base->invalid && !successors->repeatedState(base)) {
		if (base->action->startNumCond.size() > 0 || base->action->overNumCond.size() > 0 || base->action->endNumCond.size() > 0) {
			//int checkDistance = base->getCheckDistance();
			//if (checkDistance > 0) {
			if (base->h <= 1) {
				if (!checkPlan(base)) {
					markAsInvalid(base);
					return;
				}
			}
		}
		//successors->evaluator.evaluate(base);
		cout << "Base plan: " << base->id << ", " << base->action->name << "(G = " << base->g << ", H=" << base->h << ")" << endl;
		//if (base->id != 0 && base->id != 2 && base->id != 4) return;
		expandBasePlan(base);
		addSuccessors(base);
	}
}

void Planner::expandBasePlan(Plan* base)
{
	if (base->expanded()) return;
	successors->computeSuccessors(base, &sucPlans, bestMakespan);
	++expandedNodes;
	if (successors->solution != nullptr) {
		if (checkPlan(successors->solution)) {
			solution = successors->solution;
		}
		else {
			markAsInvalid(successors->solution);
			successors->solution = nullptr;
		}
	}
}

void Planner::addSuccessors(Plan* base)
{
	base->addChildren(sucPlans);
	for (Plan* p : sucPlans) {
		selector->add(p);
	}
}
