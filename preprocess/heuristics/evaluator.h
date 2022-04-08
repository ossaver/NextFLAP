#ifndef EVALUATOR_H
#define EVALUATOR_H

#include <deque>
#include "../utils/utils.h"
#include "../sas/sasTask.h"
#include "../planner/plan.h"
#include "../planner/state.h"
#include "../planner/linearizer.h"
#include "../planner/planComponents.h"
//#include "hLand.h"

class ScheduledPoint : public PriorityQueueItem {
public:
	TTimePoint p;
	float time;
	Plan* plan;

	ScheduledPoint(TTimePoint tp, float t, Plan* pl) {
		p = tp;
		time = t;
		plan = pl;
	}
	virtual inline int compare(PriorityQueueItem* other) {
		double otherTime = ((ScheduledPoint*)other)->time;
		if (time < otherTime) return -1;
		else if (time > otherTime) return 1;
		else return 0;
	}
};

class Evaluator {
private:
	SASTask* task;
	std::vector<SASAction*>* tilActions;
	PlanComponents planComponents;
	PriorityQueue pq;

	//LandmarkHeuristic landmarks;
	//bool forceAtEndConditions;
	//std::vector<LandmarkCheck*> openNodes;				// For hLand calculation

	//void initializeOpenNodes();
	//bool findOpenNode(LandmarkCheck* l);
	void calculateFrontierState(TState* fs);

public:
	void initialize(TState* state, SASTask* task, std::vector<SASAction*>* a, bool forceAtEndConditions);
	void calculateFrontierState(Plan* p);
	void evaluate(Plan* p);
	// inline LandmarkHeuristic* getLandmarkHeuristic() { return &landmarks; }
	// bool informativeLandmarks();
	std::vector<SASAction*>* getTILActions() { return tilActions; }
};

#endif
