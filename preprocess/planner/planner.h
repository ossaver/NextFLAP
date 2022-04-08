#ifndef PLANNER_H
#define PLANNER_H

#include "../sas/sasTask.h"
#include "state.h"
#include "plan.h"
#include "successors.h"
#include "selector.h"

class Planner {
private:
	SASTask* task;
	Plan* initialPlan;
	TState* initialState;
	bool forceAtEndConditions;
	bool filterRepeatedStates;
	bool generateTrace;
	Planner* parentPlanner;
	unsigned int expandedNodes;
	Successors* successors;
	std::vector<SASAction*>* tilActions;
	float initialH;
	Plan* solution;
	std::vector<Plan*> sucPlans;
	SearchQueue* selector;
	clock_t startTime;
	float bestMakespan;
	int bestNumSteps;

	//bool* actionsToCkeck;

	bool emptySearchSpace();
	void searchStep();
	void expandBasePlan(Plan* base);
	void addSuccessors(Plan* base);
	bool checkPlan(Plan* p);
	void markAsInvalid(Plan* p);
	void markChildrenAsInvalid(Plan* p);

public:
	Planner(SASTask* task, Plan* initialPlan, TState* initialState, bool forceAtEndConditions,
		bool filterRepeatedStates, bool generateTrace, std::vector<SASAction*>* tilActions);
	Plan* plan(float bestMakespan);
	void clearSolution();
};

#endif
