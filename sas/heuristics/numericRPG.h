#ifndef NUMERIC_RPG_H
#define NUMERIC_RPG_H

#include <vector>
#include <unordered_set>
#include "../utils/priorityQueue.h"
#include "../sas/sasTask.h"
#include "../planner/state.h"

class NumericRPGEffect {
public:
	bool numeric;		// Variable is propositional or numeric
	TVariable var;		// Variable or numeric variable, depending on the previous field
	TValue value;		// Value reached for the propositional variable
	float minValue;		// Minimum numeric value reached, if it is a numeric variable
	float maxValue;		// Maximum numeric value reached, if it is a numeric variable
	SASAction* a;		// Productor action

	NumericRPGEffect(TVariable v, TValue val, SASAction* a) {
		numeric = false;
		var = v;
		value = val;
		this->a = a;
	}
	NumericRPGEffect(TVariable v, float min, float max, SASAction* a) {
		numeric = true;
		var = v;
		minValue = min;
		maxValue = max;
		this->a = a;
	}
};

class NumericRPGCondition : public PriorityQueueItem {
public:
	char type;	// 'V': sas variable, '-': numeric var (minimum value required), '+': numeric var (maximum value required)
	TVariable var;
	TValue value;
	int level;

	NumericRPGCondition(SASCondition* c, int l) {
		type = 'V';
		var = c->var;
		value = c->value;
		level = l;
	}
	NumericRPGCondition(TVariable v, bool maxRequired, int l) {
		type = maxRequired ? '+' : '-';
		var = v;
		level = l;
	}
	inline int compare(PriorityQueueItem* other) {
		return ((NumericRPGCondition*)other)->level - level;
	}
	virtual ~NumericRPGCondition() { }
};

class NumericRPGproducers {
public:
	SASAction* minProducer;
	float minValue;
	SASAction* maxProducer;
	float maxValue;

	NumericRPGproducers() { minProducer = maxProducer = nullptr; }
};

class NumericRPG {
private:
	SASTask* task;
	std::vector<SASAction*> remainingGoals;
	std::vector< std::vector<NumericRPGproducers> > numVarProducers; // For each numeric variable, the actions that updated its value interval
	std::vector<TInterval> numVarValue;					   // Last value interval for each variable
	std::vector< std::vector<int> > actionLevel;		   // Levels where the action appears
	std::vector< std::vector<int> > literalLevel;		   // Level of each pair (variable, value)
	std::vector<NumericRPGEffect> nextLevel;
	std::vector<TVarValue> reachedValues;
	std::unordered_set<TVariable> reachedNumValues;
	std::vector<int> goalLevel;
	PriorityQueue openConditions;

	void initialize();
	void createFirstFluentLevel(TState* fs, std::vector<SASAction*>* tilActions);
	int updateNumericValueInterval(SASNumericEffect& e, SASAction* a);   // Return the numeric variable modified (or -1 if the interval has not been updated)
	bool updateNumericValueInterval(int var, float minValue, float maxValue);
	float evaluateMinValue(SASNumericExpression* e, SASAction* a);
	float evaluateMaxValue(SASNumericExpression* e, SASAction* a);
	float evaluateMinControlVarValue(int cvar, SASAction* a);
	float evaluateMaxControlVarValue(int cvar, SASAction* a);
	void evaluateControlVarValue(int cvar, SASAction* a);
	float evaluateMinDuration(SASAction* a);
	float evaluateMaxDuration(SASAction* a);
	void evaluateDuration(SASAction* a);
	void createFirstActionLevel();
	bool isApplicable(SASAction* a, int level);
	bool holdsCondition(SASNumericCondition* c, SASAction* a);
	void programActionEffects(SASAction* a, int level);
	void programNumericEffect(SASNumericEffect* e, SASAction* a, int level);
	void expand();
	bool updateNumericValues(int level);
	void checkAction(SASAction* a, int level);
	bool checkGoal(SASAction* a, int level);
	void addSubgoals(SASAction* a, int level);
	void addSubgoal(SASCondition* c);
	void addSubgoal(SASAction* a, SASNumericCondition* c, int level, std::vector<NumericRPGCondition*>* numCond);
	SASAction* searchBestAction(TVariable v, TValue value, int level, int* actionLevel);
	int findLevel(int actionIndex, int maxLevel);
	int findMinNumVarLevel(TVariable v, int maxLevel);
	int findMaxNumVarLevel(TVariable v, int maxLevel);
	void addMinValueSubgoal(SASAction* a, SASNumericExpression* e, int level, std::vector<NumericRPGCondition*>* numCond);
	void addMaxValueSubgoal(SASAction* a, SASNumericExpression* e, int level, std::vector<NumericRPGCondition*>* numCond);
	void addNumericSubgoal(TVariable v, int level, bool max, std::vector<NumericRPGCondition*>* numCond);

public:
	NumericRPG(TState* fs, std::vector<SASAction*>* tilActions, SASTask* task);
	int evaluate();
};

#endif // !NUMERIC_RPG_H
