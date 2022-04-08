#ifndef PLANNER_SETTING_H
#define PLANNER_SETTING_H

#include "../sas/sasTask.h"
#include "state.h"
#include "plan.h"
#include "planner.h"
#include <time.h>

class PlannerSetting {
private:
	SASTask* task;
	clock_t initialTime;
	bool generateTrace;
	Plan* initialPlan;
	std::vector<SASAction*> tilActions;
	bool forceAtEndConditions;
	bool filterRepeatedStates;
	TState* initialState;
	Planner* planner;

	void createInitialPlan();
	SASAction* createInitialAction();
	SASAction* createFictitiousAction(float actionDuration, std::vector<unsigned int>& varList,
		float timePoint, std::string name, bool isTIL);
	Plan* createTILactions(Plan* parentPlan);
	bool checkForceAtEndConditions();	// Check if it's required to leave at-end conditions not supported for some actions
	bool checkRepeatedStates();

	/*
	
	void checkPlannerType();
	*/
public:
	PlannerSetting(SASTask* sTask, bool generateTrace);
	Plan* plan(float bestMakespan);
};

#endif
