#ifndef PLAN_BUILDER_H
#define PLAN_BUILDER_H

#include "../utils/utils.h"
#include "../utils/priorityQueue.h"
#include "../sas/sasTask.h"
#include "planEffects.h"
#include "plan.h"

class PlanBuilderCausalLink {
public:
	TOrdering ordering;					// New orderings (first time point [lower 16 bits] -> second time point [higher 16 bits])
	TVarValue varValue;					// Variable [lower 16 bits] = value (higher 16 bits)
	inline TTimePoint firstPoint() {
		return ordering & 0xFFFF;
	}
	inline TTimePoint secondPoint() {
		return ordering >> 16;
	}
	inline TVariable getVar() {
		return varValue >> 16;
	}
	inline TValue getValue() {
		return varValue & 0xFFFF;
	}
	PlanBuilderCausalLink();
	PlanBuilderCausalLink(TVariable var, TValue v, TTimePoint p1, TTimePoint p2);
	PlanBuilderCausalLink(TVarValue vv, TTimePoint p1, TTimePoint p2);
};

class PBTimepointToDelay : public PriorityQueueItem {
public:
	TTimePoint tp;
	TFloatValue newTime;
	int linearOrderIndex;

	PBTimepointToDelay(TTimePoint p, TFloatValue t, int i) {
		tp = p;
		newTime = t;
		linearOrderIndex = i;
	}
	inline int compare(PriorityQueueItem* other) {
		int res = linearOrderIndex - ((PBTimepointToDelay*)other)->linearOrderIndex;
		if (res == 0) {
			if (newTime < ((PBTimepointToDelay*)other)->newTime) return 1;
			else return -1;
		}
		else return res;
	}
	virtual ~PBTimepointToDelay() { }
};

class PlanBuilder {
private:
	unsigned int iteration;
	std::vector< std::vector<unsigned int> >* matrix;
	std::vector<TTimePoint> prevPoints;	// For internal calculations
	std::vector<TTimePoint> nextPoints;	// For internal calculations
	PlanEffects* planEffects;

	inline bool existOrder(TTimePoint t1, TTimePoint t2) { return (*matrix)[t1][t2] == iteration; }
	inline void setOrder(TTimePoint t1, TTimePoint t2) { (*matrix)[t1][t2] = iteration; }
	inline void clearOrder(TTimePoint t1, TTimePoint t2) { (*matrix)[t1][t2] = 0; }
	void addCausalLinkToPlan(Plan* p, TTimePoint p1, TTimePoint p2, TVarValue varValue);
	void addNumericCausalLinkToPlan(Plan* p, TTimePoint p1, TTimePoint p2, TVariable var);
	void calculateControlVariableIntervals(Plan* p);
	void calculateControlVariableInterval(int cv, SASAction* a, 
		TFloatValue* minValue, TFloatValue* maxValue);
	void evaluateExpression(SASNumericExpression& e, TFloatValue* min, TFloatValue* max,
		std::vector<TInterval>* cvarValues);
	void calculateActionDuration(Plan* p);
	void constrainDuration(SASDurationCondition& dur, std::vector<TInterval>* cvarValues, 
		TFloatValue* minDuration, TFloatValue* maxDuration);
	void setActionStartTime(Plan* p);
	bool checkFollowingSteps(Plan* p, std::vector<TTimePoint>& linearOrder);
	void calculateNumericEffects(Plan* p);
	void getNumVarValue(TVariable v, TFloatValue* minValue, TFloatValue* maxValue, std::vector<TInterval>* cvarValues);
	void updateNumericValue(TFloatValue* min, TFloatValue* max, char op, TFloatValue expMin, TFloatValue expMax);
	bool invalidTILorder(TTimePoint p1, TTimePoint p2);
	void topologicalOrder(std::vector<TTimePoint>* linearOrder);
	unsigned int topologicalOrder(TTimePoint orig, std::vector<TTimePoint>* linearOrder, unsigned int pos,
		std::vector<bool>* visited);
	bool delaySteps(Plan* p, std::vector<TTimePoint>& pointToDelay, std::vector<TFloatValue>& newTime,
		std::vector<TTimePoint>& linearOrder);
	void constrainNumericValues(TVariable v, TFloatValue* minValue, TFloatValue* maxValue, std::vector<TInterval>* cvarValues);
	void constrainNumericValues(SASNumericCondition* c, TVariable v, TFloatValue* minValue, TFloatValue* maxValue, 
		std::vector<TInterval>* cvarValues);

public:
	SASAction* action;					// New action added
	unsigned int currentPrecondition;
	unsigned int currentEffect;
	unsigned int setPrecondition;
	TTimePoint lastTimePoint;
	std::vector<PlanBuilderCausalLink> causalLinks;
	std::vector<unsigned int> numOrderingsAdded;
	std::vector<TOrdering> orderings;
	std::vector<unsigned int> openCond;
	int numSupportState;

	PlanBuilder(SASAction* a, TStep lastStep, std::vector< std::vector<unsigned int> >* matrix,
		int numSupportState, PlanEffects* planEffects);
	bool addLink(SASCondition* c, TTimePoint p1, TTimePoint p2);
	bool addNumLink(TVariable v, TTimePoint p1, TTimePoint p2, SASTask* task);
	bool addOrdering(TTimePoint p1, TTimePoint p2);
	void removeLastLink();
	void removeLastOrdering();
	Plan* generatePlan(Plan* basePlan, TPlanId idPlan);
};

#endif
