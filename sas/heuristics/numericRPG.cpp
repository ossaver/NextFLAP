#include "numericRPG.h"
#include <iostream>
using namespace std;

//#define NUMRPG_DEBUG

NumericRPG::NumericRPG(TState* fs, std::vector<SASAction*>* tilActions, SASTask* task)
{
	this->task = task;
	initialize();
	createFirstFluentLevel(fs, tilActions);
	createFirstActionLevel();
	expand();
}

void NumericRPG::initialize()
{
	int numVars = task->variables.size();
	int numValues = task->values.size();
	int numNumVars = task->numVariables.size();
	literalLevel.resize(numVars);
	for (int i = 0; i < numVars; i++) {
		literalLevel[i].resize(numValues, MAX_INT32);
	}
	actionLevel.resize(task->actions.size());
	numVarProducers.resize(numNumVars);
	numVarValue.resize(numNumVars);
	for (SASAction& a : task->goals)
		remainingGoals.push_back(&a);
	goalLevel.resize(task->goals.size(), MAX_INT32);
}

void NumericRPG::createFirstFluentLevel(TState* fs, std::vector<SASAction*>* tilActions)
{
#ifdef NUMRPG_DEBUG
	cout << "L0" << endl;
#endif
	// Propositional values
	for (unsigned int i = 0; i < fs->numSASVars; i++) {
		TValue v = fs->state[i];
		literalLevel[i][v] = 0;
#ifdef NUMRPG_DEBUG
		cout << "* " << task->variables[i].name << "=" << task->values[v].name << endl;
#endif
	}
	// Numeric values
	for (unsigned int i = 0; i < fs->numNumVars; i++) {
		numVarValue[i].minValue = fs->minState[i];
		numVarValue[i].maxValue = fs->maxState[i];
#ifdef NUMRPG_DEBUG
		cout << "* " << task->numVariables[i].name << "=" << fs->numState[i] << endl;
#endif
	}
	// TIL
	if (tilActions != nullptr) {
		for (SASAction* a : *tilActions) {
			for (SASCondition& c : a->endEff) {
				literalLevel[c.var][c.value] = 0;
			}
			for (SASNumericEffect& e : a->endNumEff) {
				updateNumericValueInterval(e, a);
			}
		}
	}
}

int NumericRPG::updateNumericValueInterval(SASNumericEffect& e, SASAction* a)
{
	int var = e.var;
	a->calc.reset();
	float minValue = evaluateMinValue(&e.exp, a);
	float maxValue = evaluateMaxValue(&e.exp, a);
	switch (e.op) {
	case '=':
		if (updateNumericValueInterval(var, minValue, maxValue))
			return var;
		break;
	case '+':
		if (updateNumericValueInterval(var, numVarValue[var].minValue + minValue, numVarValue[var].maxValue + maxValue))
			return var;
		break;
	case '-':
		if (updateNumericValueInterval(var, numVarValue[var].minValue - maxValue, numVarValue[var].maxValue - minValue))
			return var;
		break;
	case '*':
		if (updateNumericValueInterval(var, numVarValue[var].minValue * minValue, numVarValue[var].maxValue * maxValue))
			return var;
		break;
	case '/':
		if (updateNumericValueInterval(var, numVarValue[var].minValue / maxValue, numVarValue[var].maxValue / minValue))
			return var;
		break;
	}
	return -1;
}

bool NumericRPG::updateNumericValueInterval(int var, float minValue, float maxValue)
{
	bool updated = false;
	if (minValue < numVarValue[var].minValue) {
		numVarValue[var].minValue = minValue;
		updated = true;
	}
	if (maxValue > numVarValue[var].maxValue) {
		numVarValue[var].maxValue = maxValue;
		updated = true;
	}
	return updated;
}

float NumericRPG::evaluateMinValue(SASNumericExpression* e, SASAction* a)
{
	switch (e->type) {
	case 'N': return e->value;
	case 'V': return numVarValue[e->var].minValue;
	case '+': return evaluateMinValue(&(e->terms[0]), a) + evaluateMinValue(&(e->terms[1]), a);
	case '-': return evaluateMinValue(&(e->terms[0]), a) - evaluateMaxValue(&(e->terms[1]), a);
	case '*': {
		float min1 = evaluateMinValue(&(e->terms[0]), a), min2 = evaluateMinValue(&(e->terms[1]), a);
		if (min1 >= 0 && min2 >= 0) return min1 * min2;
		float max1 = evaluateMaxValue(&(e->terms[0]), a);
		if (min1 >= 0) return max1 * min2;
		float max2 = evaluateMaxValue(&(e->terms[1]), a);
		if (max1 <= 0 && max2 <= 0) return max1 * max2;
		if (max1 <= 0 && min2 >= 0) return min1 * max2;
		if (max2 <= 0) return max1 * min2;
		return std::min(min1 * max2, max1 * min2);
	}
	case '/': {
		float min1 = evaluateMinValue(&(e->terms[0]), a), min2 = evaluateMinValue(&(e->terms[1]), a),
			max2 = evaluateMaxValue(&(e->terms[1]), a);
		if (min1 >= 0 && min2 >= 0) return min1 / max2;
		float max1 = evaluateMaxValue(&(e->terms[0]), a);
		if (min1 >= 0) {
			if (max2 >= 0) return max1 / min2;
			return max1 / max2;
		}
		if (min2 >= 0) return min1 / min2;
		if (max1 <= 0) {
			if (max2 >= 0) return min1 / max2;
			return max1 / min2;
		}
		if (max2 <= 0) return max1 / max2;
		return std::min(min1 / max2, max1 / min2);
	}
	case 'C': return evaluateMinControlVarValue(e->var, a);
	case 'D': return evaluateMinDuration(a);
	}
	return -FLOAT_INFINITY;
}

float NumericRPG::evaluateMaxValue(SASNumericExpression* e, SASAction* a)
{
	switch (e->type) {
	case 'N': return e->value;
	case 'V': return numVarValue[e->var].maxValue;
	case '+': return evaluateMaxValue(&(e->terms[0]), a) + evaluateMaxValue(&(e->terms[1]), a);
	case '-': return evaluateMaxValue(&(e->terms[0]), a) - evaluateMinValue(&(e->terms[1]), a);
	case '*': {
		float min1 = evaluateMinValue(&(e->terms[0]), a), max2 = evaluateMaxValue(&(e->terms[1]), a),
			max1 = evaluateMaxValue(&(e->terms[0]), a);
		if (min1 >= 0 && max2 >= 0) return max1 * max2;
		float min2 = evaluateMinValue(&(e->terms[1]), a);
		if (min1 <= 0 && max2 <= 0) return min1 * min2;
		if (min1 >= 0) return min1 * max2;
		if (max1 >= 0 && min2 >= 0) return max1 * max2;
		if (max1 <= 0 && min2 >= 0) return max1 * min2;
		if (max1 <= 0) return min1 * min2;
		return std::max(min1 * min2, max1 * max2);
	}
	case '/': {
		float min1 = evaluateMinValue(&(e->terms[0]), a);
		if (min1 >= 0) {
			float max1 = evaluateMaxValue(&(e->terms[0]), a), min2 = evaluateMinValue(&(e->terms[1]), a);
			if (min2 >= 0) return max1 / min2;
			float max2 = evaluateMaxValue(&(e->terms[1]), a);
			if (max2 >= 0) return max1 / max2;
			return min1 / min2;
		}
		float max1 = evaluateMaxValue(&(e->terms[0]), a);
		if (max1 <= 0) {
			float max2 = evaluateMaxValue(&(e->terms[1]), a);
			if (max2 <= 0) return min1 / max2;
			float min2 = evaluateMinValue(&(e->terms[1]), a);
			if (min2 <= 0) return min1 / min2;
			return max1 / max2;
		}
		float min2 = evaluateMinValue(&(e->terms[1]), a);
		if (min2 >= 0) return  max1 / min2;
		float max2 = evaluateMaxValue(&(e->terms[1]), a);
		if (max2 <= 0) return min1 / max2;
		return std::max(min1 / min2, max1 / max2);
	}
	case 'C': return evaluateMaxControlVarValue(e->var, a);
	case 'D': return evaluateMaxDuration(a);
	}
	return FLOAT_INFINITY;
}

float NumericRPG::evaluateMinControlVarValue(int cvar, SASAction* a)
{
	if (a->calc.cvarEvaluated[cvar])
		return a->calc.cvarValues[cvar].minValue;
	evaluateControlVarValue(cvar, a);
	return a->calc.cvarValues[cvar].minValue;
}

float NumericRPG::evaluateMaxControlVarValue(int cvar, SASAction* a)
{
	if (a->calc.cvarEvaluated[cvar])
		return a->calc.cvarValues[cvar].maxValue;
	evaluateControlVarValue(cvar, a);
	return a->calc.cvarValues[cvar].maxValue;
}

void NumericRPG::evaluateControlVarValue(int cvar, SASAction* a)
{
	float minValue = a->controlVars[cvar].minValue, maxValue = a->controlVars[cvar].maxValue;
	for (SASNumericCondition& c : a->startNumCond) {
		if (c.terms[0].type == 'C' && c.terms[0].var == cvar && c.comp != 'N') {
			float rightValue = 0;
			switch (c.comp) {
			case '=':
				minValue = evaluateMinValue(&(c.terms[1]), a);
				maxValue = evaluateMaxValue(&(c.terms[1]), a);
				break;
			case '<':
				rightValue = -EPSILON;
			case 'L':
				rightValue += evaluateMaxValue(&(c.terms[1]), a);
				if (maxValue > rightValue) maxValue = rightValue;
				break;
			case '>':
				rightValue = EPSILON;
			case 'G':
				rightValue += evaluateMinValue(&(c.terms[1]), a);
				if (minValue < rightValue) minValue = rightValue;
				break;
			}
		}
	}
	a->calc.cvarValues[cvar].minValue = minValue;
	a->calc.cvarValues[cvar].maxValue = maxValue;
	a->calc.cvarEvaluated[cvar] = true;
}

float NumericRPG::evaluateMinDuration(SASAction* a)
{
	if (a->duration.constantDuration)
		return a->duration.minDuration;
	if (a->calc.durationEvaluated)
		return a->calc.minDuration;
	evaluateDuration(a);
	return a->calc.minDuration;
}

float NumericRPG::evaluateMaxDuration(SASAction* a)
{
	if (a->duration.constantDuration)
		return a->duration.maxDuration;
	if (a->calc.durationEvaluated)
		return a->calc.maxDuration;
	evaluateDuration(a);
	return a->calc.maxDuration;
}

void NumericRPG::evaluateDuration(SASAction* a)
{
	float minValue = a->duration.minDuration, maxValue = a->duration.maxDuration;
	for (SASDurationCondition& dc : a->duration.conditions) {
		float rightValue = 0;
		switch (dc.comp) {
		case '=': 
			minValue = evaluateMinValue(&(dc.exp), a);
			maxValue = evaluateMaxValue(&(dc.exp), a);
			break;
		case '<':
			rightValue = -EPSILON;
		case 'L':
			rightValue += evaluateMaxValue(&(dc.exp), a);
			if (maxValue > rightValue) maxValue = rightValue;
			break;
		case '>':
			rightValue = EPSILON;
		case 'G':
			rightValue += evaluateMinValue(&(dc.exp), a);
			if (minValue < rightValue) minValue = rightValue;
			break;
		}
	}
	a->calc.minDuration = minValue;
	a->calc.maxDuration = maxValue;
	a->calc.durationEvaluated = true;
}

void NumericRPG::createFirstActionLevel()
{
#ifdef NUMRPG_DEBUG
	cout << "A0" << endl;
#endif
	int i = 0;
	while (i < remainingGoals.size()) {
		SASAction* a = remainingGoals[i];
		if (isApplicable(a, 0)) {
#ifdef NUMRPG_DEBUG
			cout << a->name << endl;
#endif
			programActionEffects(a, 1);
			goalLevel[a->index] = 0;
			remainingGoals.erase(remainingGoals.begin() + i);
		}
		else i++;
	}
	for (SASAction& a : task->actions) {
		if (isApplicable(&a, 0)) {
#ifdef NUMRPG_DEBUG
			cout << a.name << endl;
#endif
			programActionEffects(&a, 1);
			actionLevel[a.index].push_back(0);
		}
	}
}

bool NumericRPG::isApplicable(SASAction* a, int level)
{
	for (SASCondition& c : a->startCond) {
		if (literalLevel[c.var][c.value] > level)
			return false;
	}
	for (SASCondition& c : a->overCond) {
		if (literalLevel[c.var][c.value] > level)
			return false;
	}
	for (SASCondition& c : a->endCond) {
		if (literalLevel[c.var][c.value] > level)
			return false;
	}
	a->calc.reset();
	for (SASNumericCondition& c : a->startNumCond) {
		if (!holdsCondition(&c, a))
			return false;
	}
	for (SASNumericCondition& c : a->overNumCond) {
		if (!holdsCondition(&c, a))
			return false;
	}
	for (SASNumericCondition& c : a->endNumCond) {
		if (!holdsCondition(&c, a))
			return false;
	}
	return true;
}

bool NumericRPG::holdsCondition(SASNumericCondition* c, SASAction* a)
{
	float min1, max1, min2, max2;
	switch (c->comp) {
	case '=': // [2, 4] = [3, 5] -> [max(2, 3), min(4, 5)] = [3, 4] -> Ok si intervalo no vacío
		min1 = evaluateMinValue(&(c->terms.at(0)), a);
		max1 = evaluateMaxValue(&(c->terms.at(0)), a);
		min2 = evaluateMinValue(&(c->terms.at(1)), a);
		max2 = evaluateMaxValue(&(c->terms.at(1)), a);
		return std::max(min1, min2) <= std::min(max1, max2);
	case '<': // [a, b] < [c, d] -> a < d
		min1 = evaluateMinValue(&(c->terms.at(0)), a);
		max2 = evaluateMaxValue(&(c->terms.at(1)), a);
		return min1 < max2;
	case 'L': // [a, b] <= [c, d] -> a <= d
		min1 = evaluateMinValue(&(c->terms.at(0)), a);
		max2 = evaluateMaxValue(&(c->terms.at(1)), a);
		return min1 <= max2;
	case '>': // [a, b] > [c, d] -> b > c
		max1 = evaluateMaxValue(&(c->terms.at(0)), a);
		min2 = evaluateMinValue(&(c->terms.at(1)), a);
		return max1 > min2;
	case 'G': // [a, b] > [c, d] -> b >= c
		max1 = evaluateMaxValue(&(c->terms.at(0)), a);
		min2 = evaluateMinValue(&(c->terms.at(1)), a);
		return max1 >= min2;
	case 'N':	// [a, b] != [c, d] -> !(a == b == c == d)
		min1 = evaluateMinValue(&(c->terms.at(0)), a);
		max1 = evaluateMaxValue(&(c->terms.at(0)), a);
		if (min1 != max1) return true;
		min2 = evaluateMinValue(&(c->terms.at(1)), a);
		if (min2 != min1) return true;
		max2 = evaluateMaxValue(&(c->terms.at(1)), a);
		return max2 != min1;
	}
	return false;
}

void NumericRPG::programActionEffects(SASAction* a, int level)
{
	for (SASCondition& c : a->startEff) {
		if (literalLevel[c.var][c.value] > level) {
			literalLevel[c.var][c.value] = level;
			nextLevel.emplace_back(c.var, c.value, a);
#ifdef NUMRPG_DEBUG
			cout << "\tEffect: " << task->variables[c.var].name << "=" << task->values[c.value].name << endl;
#endif
		}
	}
	for (SASCondition& c : a->endEff) {
		if (literalLevel[c.var][c.value] > level) {
			literalLevel[c.var][c.value] = level;
			nextLevel.emplace_back(c.var, c.value, a);
#ifdef NUMRPG_DEBUG
			cout << "\tEffect: " << task->variables[c.var].name << "=" << task->values[c.value].name << endl;
#endif
		}
	}
	for (SASNumericEffect& e : a->startNumEff) {
		programNumericEffect(&e, a, level);
	}
	for (SASNumericEffect& e : a->endNumEff) {
		programNumericEffect(&e, a, level);
	}
}

void NumericRPG::programNumericEffect(SASNumericEffect* e, SASAction* a, int level)
{
	int var = e->var;
	float minValue = evaluateMinValue(&e->exp, a), currentMin = numVarValue[var].minValue, min;
	float maxValue = evaluateMaxValue(&e->exp, a), currentMax = numVarValue[var].maxValue, max;
	switch (e->op) {
	case '=':
		min = minValue;
		max = maxValue;
		break;
	case '+':
		min = currentMin + minValue;
		max = currentMax + maxValue;
		break;
	case '-':
		min = currentMin - maxValue;
		max = currentMax - minValue;
		break;
	case '*':
		min = currentMin * minValue;
		max = currentMax * maxValue;
		break;
	case '/':
		min = currentMin / maxValue;
		max = currentMax / minValue;
		break;
	}
	if (min < currentMin || max > currentMax) {
		min = std::min(min, currentMin);
		max = std::max(max, currentMax);
		nextLevel.emplace_back(var, min, max, a);
#ifdef NUMRPG_DEBUG
		cout << "\tEffect: " << task->numVariables[var].name << "=[" << min << ", " << max << "]" << endl;
#endif
	}
}

void NumericRPG::expand()
{
	int currentLevel = 0;
	std::unordered_set<int> checkedActions;
	while (remainingGoals.size() > 0 && nextLevel.size() > 0) {
		currentLevel++;
#ifdef NUMRPG_DEBUG
		cout << "L" << currentLevel << endl;
#endif
		if (!updateNumericValues(currentLevel))		// Update numeric values
			break;									// Unreachable goals
		int i = 0;
		while (i < remainingGoals.size()) {
			if (checkGoal(remainingGoals[i], currentLevel)) { // Goal achieved
				remainingGoals.erase(remainingGoals.begin() + i);
			}
			else i++;
		}
		if (remainingGoals.empty()) break;
		for (TVarValue vv : reachedValues) {	// Add actions that require this proposition
			for (SASAction* a : task->requirers[task->getVariableIndex(vv)][task->getValueIndex(vv)]) {
				if (checkedActions.find(a->index) == checkedActions.end()) {
					checkAction(a, currentLevel);
					checkedActions.insert(a->index);
				}
			}
		}
		for (const TVariable& v : reachedNumValues) { // Add actions that need this numeric value
			for (SASAction* a : task->numRequirers[v]) {
				if (checkedActions.find(a->index) == checkedActions.end()) {
					checkAction(a, currentLevel);
					checkedActions.insert(a->index);
				}
			}
		}
		checkedActions.clear();
	}
}

bool NumericRPG::updateNumericValues(int level)
{
	bool onlyNumericVariables = true;
	reachedValues.clear();
	reachedNumValues.clear();
	for (NumericRPGEffect& c : nextLevel)
	{
		if (c.numeric) {
			bool changeMin = c.minValue < numVarValue[c.var].minValue;
			bool changeMax = c.maxValue > numVarValue[c.var].maxValue;
			if (changeMin || changeMax) {
				numVarProducers[c.var].resize(level);
				NumericRPGproducers& prod = numVarProducers[c.var][level - 1];
				reachedNumValues.insert(c.var);
				if (changeMin) {
					numVarValue[c.var].minValue = c.minValue;
					prod.minProducer = c.a;
					prod.minValue = c.minValue;
				}
				if (changeMax) {
					numVarValue[c.var].maxValue = c.maxValue;
					prod.maxProducer = c.a;
					prod.maxValue = c.maxValue;
				}
			}
		}
		else {
			onlyNumericVariables = false;
			reachedValues.push_back(task->getVariableValueCode(c.var, c.value));
		}
	}
	nextLevel.clear();
	if (onlyNumericVariables) {	// Only numeric changes -> check if there are still unreached actions that need them 
		for (TVariable v : reachedNumValues) {
			for (SASAction* a : task->numRequirers[v]) {
				if (actionLevel[a->index].empty())
					return true;
			}
			for (SASAction* g : task->numGoalRequirers[v]) {
				if (goalLevel[g->index] == MAX_INT32)
					return true;
			}
		}
		return false;	// Stop expansion -> all the actions that require these variables are already in the RPG
	}
	else return true;
}

void NumericRPG::checkAction(SASAction* a, int level)
{
	if (actionLevel[a->index].size() > 0 && a->endNumEff.empty() && a->startNumEff.empty())
		return;	// Action already in the RPG without numeric effects
	if (!isApplicable(a, level))
		return;	// Action not applicable
#ifdef NUMRPG_DEBUG
	cout << "Checking " << a->name << endl;
#endif
	programActionEffects(a, level + 1);
	if (nextLevel.size() > 0 && nextLevel.back().a == a) { // Action generates new values
		actionLevel[a->index].push_back(level);			   // Action added to the current level
#ifdef NUMRPG_DEBUG
		cout << "\tAction added to level" << endl;
#endif
	}
	else if (actionLevel[a->index].empty() && a->endNumEff.empty() && a->startNumEff.empty()) { 
		// Action does not produces new values, but appears the first time and has no numeric effects ->
		// add to the RPG not to check it again
		actionLevel[a->index].push_back(level);			   // Action added to the current level
#ifdef NUMRPG_DEBUG
		cout << "\tAction added to level" << endl;
#endif
	}
}

bool NumericRPG::checkGoal(SASAction* a, int level)
{
	if (!isApplicable(a, level))
		return false;	// Action not applicable
#ifdef NUMRPG_DEBUG
	cout << "Goal " << a->index << " achieved" << endl;
#endif
	goalLevel[a->index] = level;
	return true;
}

int NumericRPG::evaluate()
{
	if (remainingGoals.size() > 0) return MAX_UINT16;
	int h = 0, level;
	for (SASAction& g : task->goals) {
		addSubgoals(&g, goalLevel[g.index]);
	}
	SASAction* a;
	while (openConditions.size() > 0) {
		NumericRPGCondition* c = (NumericRPGCondition*)openConditions.poll();
		if (c->type == 'V') {
			a = searchBestAction(c->var, c->value, c->level, &level);
		}
		else {
			level = c->level; 
			NumericRPGproducers& prod = numVarProducers[c->var][c->level];
			a = c->type == '+' ? prod.maxProducer : prod.minProducer;
		}
		if (a != nullptr) {
			h++;
			addSubgoals(a, level);
			actionLevel[a->index].clear();
			actionLevel[a->index].push_back(0);	// Not to repeat actions
		}
		delete c;
	}
#ifdef NUMRPG_DEBUG
	cout << "H = " << h << endl;
#endif
	return h;
}

void NumericRPG::addSubgoals(SASAction* a, int level)
{
#ifdef NUMRPG_DEBUG
	cout << "Adding subgoals of action " << a->name << endl;
#endif
	for (SASCondition& c : a->startCond)
		addSubgoal(&c);
	for (SASCondition& c : a->overCond)
		addSubgoal(&c);
	for (SASCondition& c : a->endCond)
		addSubgoal(&c);
	std::vector<NumericRPGCondition*> numCond;
	for (SASNumericCondition& c: a->startNumCond)
		addSubgoal(a, &c, level, &numCond);
	for (SASNumericCondition& c : a->overNumCond)
		addSubgoal(a, &c, level, &numCond);
	for (SASNumericCondition& c : a->endNumCond)
		addSubgoal(a, &c, level, &numCond);
	for (NumericRPGCondition* c : numCond) {
		openConditions.add(c);
#ifdef NUMRPG_DEBUG
		cout << "* Level " << (c->level + 1) << ": " << task->numVariables[c->var].name << " (" << c->type << ")" << endl;
#endif
	}
}

void NumericRPG::addSubgoal(SASCondition* c)
{
	int level = literalLevel[c->var][c->value];
	if (level > 0) {	// Not solved yet
		literalLevel[c->var][c->value] = 0;		// Not to repeat it again
		openConditions.add(new NumericRPGCondition(c, level));
#ifdef NUMRPG_DEBUG
		cout << "* Level " << level << ": " << task->variables[c->var].name << "=" << task->values[c->value].name << endl;
#endif
	}
}

void NumericRPG::addSubgoal(SASAction* a, SASNumericCondition* c, int level, std::vector<NumericRPGCondition*>* numCond)
{
	switch (c->comp) {
	case '>': // >
	case 'G': // x >= y
		addMaxValueSubgoal(a, &(c->terms.at(0)), level, numCond);
		addMinValueSubgoal(a, &(c->terms.at(1)), level, numCond);
		break;
	case '<':
	case 'L':
		addMinValueSubgoal(a, &(c->terms.at(0)), level, numCond);
		addMaxValueSubgoal(a, &(c->terms.at(1)), level, numCond);
		break;
	default:
		addMinValueSubgoal(a, &(c->terms.at(0)), level, numCond);
		addMaxValueSubgoal(a, &(c->terms.at(0)), level, numCond);
		addMinValueSubgoal(a, &(c->terms.at(1)), level, numCond);
		addMaxValueSubgoal(a, &(c->terms.at(1)), level, numCond);
	}
}

void NumericRPG::addMaxValueSubgoal(SASAction* a, SASNumericExpression* e, int level, std::vector<NumericRPGCondition*>* numCond)
{
	if (e->type == 'V') {
		int varLevel = findMaxNumVarLevel(e->var, level);
		if (varLevel > 0) {
			addNumericSubgoal(e->var, true, varLevel, numCond);
		}
	}
	else {
		for (SASNumericExpression& t : e->terms) {
			addMaxValueSubgoal(a, &t, level, numCond);
		}
	}
}

void NumericRPG::addMinValueSubgoal(SASAction* a, SASNumericExpression* e, int level, std::vector<NumericRPGCondition*>* numCond)
{
	if (e->type == 'V') {
		int varLevel = findMinNumVarLevel(e->var, level);
		if (varLevel > 0) {
			addNumericSubgoal(e->var, false, varLevel, numCond);
		}
	}
	else {
		for (SASNumericExpression& t : e->terms) {
			addMaxValueSubgoal(a, &t, level, numCond);
		}
	}
}

void NumericRPG::addNumericSubgoal(TVariable v, int level, bool max, std::vector<NumericRPGCondition*>* numCond) {
	for (NumericRPGCondition* c : *numCond) {
		if (c->var == v && max == (c->type == '+'))
			return;
	}
	numCond->push_back(new NumericRPGCondition(v, max, level));
}

SASAction* NumericRPG::searchBestAction(TVariable v, TValue value, int level, int* actionLevel)
{
	SASAction* best = nullptr;
	for (SASAction* a : task->producers[v][value]) {
		int prodActionLevel = findLevel(a->index, level);
		if (prodActionLevel != -1) {
			if (prodActionLevel == 0) {
				*actionLevel = 0;
				return a;
			}
			else if (best == nullptr || prodActionLevel < *actionLevel) {
				best = a;
				*actionLevel = prodActionLevel;
			}
		}
	}
	return best;
}

int NumericRPG::findMinNumVarLevel(TVariable v, int maxLevel)
{
	std::vector<NumericRPGproducers>& prod = numVarProducers[v];
	int level = maxLevel;
	if (prod.size() < level) level = (int)prod.size();
	for (int i = level - 1; i >= 0; i--) {
		if (prod[i].minProducer != nullptr)
			return i;
	}
	return -1;
}

int NumericRPG::findMaxNumVarLevel(TVariable v, int maxLevel)
{
	std::vector<NumericRPGproducers>& prod = numVarProducers[v];
	int level = maxLevel;
	if (prod.size() < level) level = (int)prod.size();
	for (int i = level - 1; i >= 0; i--) {
		if (prod[i].maxProducer != nullptr)
			return i;
	}
	return -1;
}

int NumericRPG::findLevel(int actionIndex, int maxLevel)
{
	std::vector<int>& levels = actionLevel[actionIndex];
	for (int i = (int)levels.size() - 1; i >= 0; i--)
	{ 
		if (levels[i] < maxLevel)
			return levels[i];
	}
	return -1;
}
