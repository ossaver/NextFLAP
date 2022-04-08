/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* March 2016                                           */
/********************************************************/
/* POP plan      										*/
/********************************************************/

#include <iostream>
#include "plan.h"
using namespace std;

/********************************************************/
/* CLASS: Plan                                          */
/********************************************************/

Plan::Plan(SASAction* action, Plan* parentPlan, TPlanId idPlan) {
	this->parentPlan = parentPlan;
	this->action = action;
	this->childPlans = nullptr;
	this->id = idPlan;
	this->cvarValues = nullptr;
	this->planUpdates = nullptr;
	this->fixedInit = false;
	if (parentPlan != nullptr) this->g = parentPlan->g + 1;
	else this->g = 0;
	this->h = (int)MAX_UINT16;
	//this->hLand = 0;
	this->repeatedState = false;
	this->fs = nullptr;
	z3Checked = false;
	invalid = false;
}

Plan::~Plan()
{
	if (fs != nullptr) delete fs;
}

void Plan::addFluentIntervals(PlanPoint& pp, std::vector<SASNumericEffect>& eff)
{
	if (eff.size() > 0) {
		pp.numVarValues = new std::vector<TFluentInterval>();
		for (int i = 0; i < eff.size(); i++) {
			SASNumericEffect* ne = &(eff[i]);
			pp.numVarValues->emplace_back(ne->var, ne->exp.value, ne->exp.value);
		}
	}
}

void Plan::setDuration(TFloatValue min, TFloatValue max) {
	this->actionDuration.minValue = min;
	this->actionDuration.maxValue = max;
}

void Plan::setTime(TTime init,  TTime end, bool fixed) {
	this->startPoint.setInitialTime(init);
	this->fixedInit = fixed;
	this->endPoint.setInitialTime(end);
}

// Compares this plan with the given one. Returns a negative number if this is better, 
// 0 if both are equally good or a positive number if p is better
int Plan::compare(Plan* p)
{
	int v1 = g + 2 * h;
	int v2 = p->g + 2 * p->h;
	if (v1 < v2) return -1;
	if (v1 > v2) return 1;
	//if (hLand < p->hLand) return -1;
	//if (hLand > p->hLand) return 1;
	return 0;
}

bool Plan::isRoot()
{
	return parentPlan == nullptr || this->action->isTIL;
}

void Plan::addFluentIntervals()
{
	addFluentIntervals(this->startPoint, this->action->startNumEff);
	addFluentIntervals(this->endPoint, this->action->endNumEff);
}

void Plan::addChildren(std::vector<Plan*>& suc)
{
	childPlans = new std::vector<Plan*>(suc);
}

void Plan::addPlanUpdate(TTimePoint tp, TFloatValue time)
{
	if (planUpdates == nullptr)
		planUpdates = new std::vector<TPlanUpdate>();
	planUpdates->emplace_back(tp, time);
}

int Plan::getCheckDistance()
{
	if (z3Checked || parentPlan == nullptr) return 0;
	return 1 + parentPlan->getCheckDistance();
}


/********************************************************/
/* CLASS: CausalLink                                    */
/********************************************************/

/*
CausalLink::CausalLink() {
}

CausalLink::CausalLink(TVariable var, TValue v, TTimePoint p1, TTimePoint p2) {
	varValue = (((TVarValue) v) << 16) + var;
	ordering = (((TOrdering) p2) << 16) + p1;
}

CausalLink::CausalLink(TVarValue vv, TTimePoint p1, TTimePoint p2) {
	varValue = vv;
	ordering = (((TOrdering) p2) << 16) + p1;
}
*/

/********************************************************/
/* CLASS: TOpenCond                                     */
/********************************************************/
/*
TOpenCond::TOpenCond(TStep s, uint16_t c) {
	step = s;
	condNumber = c;
}

Plan::Plan(SASAction* action, Plan* parentPlan, float fixedEnd, uint32_t idPlan) {
	this->parentPlan = parentPlan;
	this->action = action;
	this->fixedEnd = fixedEnd;
	childPlans = nullptr;
	id = idPlan;
	openCond = nullptr;
	h = hAux = FLOAT_INFINITY;
	hLand = MAX_UINT16;
	gc = 0;
	g = parentPlan == nullptr ? 0 : parentPlan->g + 1;
	repeatedState = false;
	unsatisfiedNumericConditions = false;
}

// Compares this plan with the given one. Returns a negative number if this is better, 0 if both are equally good or a positive number if p is better
int Plan::compare(Plan* p, int queue) {
	float v1 = 0, v2 = 0;
	switch (queue & SEARCH_MASK_PLATEAU) {
	case SEARCH_G_HFF:
		v1 = g + h;
		v2 = p->g + p->h;
		break;
	case SEARCH_G_2HFF:
		v1 = g + 2*h;
		v2 = p->g + 2*p->h;
		break;
	case SEARCH_HFF:
		v1 = h;
		v2 = p->h;
		break;
	case SEARCH_G_3HFF:
		v1 = g + 3*h;
		v2 = p->g + 3*p->h;
		break;
	case SEARCH_G_HLAND_HFF:
		v1 = g + h + hLand;
		v2 = p->g + p->h + p->hLand;
		break;
	case SEARCH_G:
		v1 = g;
		v2 = p->g;
		break;
	case SEARCH_G_HLAND:
		v1 = g + hLand;
		v2 = p->g + p->hLand;
		break;
	case SEARCH_G_3HLAND:
		v1 = g + 3*hLand;
		v2 = p->g + 3*p->hLand;
		break;
	case SEARCH_HLAND:
		v1 = hLand;
		v2 = p->hLand;
		break;
	case SEARCH_G_2HAUX:
		v1 = g + 3*hAux;
		v2 = p->g + 3*p->hAux;
		break;
	default:
		cout << "Error" << endl;
		exit(0);
	}
	if (unsatisfiedNumericConditions) v1++;
	if (p->unsatisfiedNumericConditions) v2++;
	if (v1 == v2) {
		//if (useful && !(p->useful)) return -1;
		//if (p->useful && !useful) return 1;
		if (queue < SEARCH_MASK_PLATEAU)
			return ((int) g) - ((int) p->g);
		else {
			v1 = gc;
			v2 = p->gc;
		}
	}
	if (v1 < v2) return -1;
	if (v1 > v2) return 1;
	return 0;
}

float Plan::getH(int queue) {
	switch (queue & SEARCH_MASK_PLATEAU) {
	case SEARCH_G_HFF:
	case SEARCH_G_2HFF:
	case SEARCH_HFF:
	case SEARCH_G_3HFF:
	case SEARCH_G:
	case SEARCH_G_HLAND_HFF:
		return h;
	case SEARCH_G_HLAND:
	case SEARCH_G_3HLAND:
	case SEARCH_HLAND:
		return hLand;
	case SEARCH_G_2HAUX:
		return hAux;
	default:
		return 0;
	}
}

// Returns a string representation of this plan
string Plan::toString() {
	string s = parentPlan != nullptr ? parentPlan->toString() : "";
	if (action != nullptr) s += "+ [" + to_string(gc) + "] Action: " + action->name + "\n";
	for (unsigned int i = 0; i < causalLinks.size(); i++)
		s += "  * " + to_string(causalLinks[i].firstPoint()) + " ---> " + to_string(causalLinks[i].secondPoint()) + "\n";
	for (unsigned int i = 0; i < orderings.size(); i++)
		s += "  * " + to_string(firstPoint(orderings[i])) + " -> " + to_string(secondPoint(orderings[i])) + "\n";
	return s;
}

// Destructor
Plan::~Plan() {
	clearChildren();
	if (openCond != nullptr) {
		delete openCond;
		openCond = nullptr;
	}
}

// Adds the children of a plan
void Plan::addChildren(vector<Plan*> &suc) {
	childPlans = new vector<Plan*>(suc);
}

// Removes the child plans. Call only if all the child plans have been expanded
void Plan::clearChildren() {
	if (childPlans != nullptr) {
		delete childPlans;
		childPlans = nullptr;
	}
}

void Plan::addOpenCondition(uint16_t condNumber, uint16_t stepNumber) {
	if (openCond == nullptr) {
		openCond = new std::vector<TOpenCond>();
	}
	openCond->emplace_back(stepNumber, condNumber);
}
*/

void PlanPoint::addCausalLink(TTimePoint timePoint, TVarValue varVal)
{
	for (TCausalLink& cl : causalLinks)
		if (cl.varVal == varVal)
			return; // Repeated causal link
	causalLinks.emplace_back(timePoint, varVal);
}

void PlanPoint::addNumericCausalLink(TTimePoint timePoint, TVarValue var)
{
	for (TNumericCausalLink& cl : numCausalLinks)
		if (cl.var == var)
			return; // Repeated causal link
	numCausalLinks.emplace_back(timePoint, var);
}

void PlanPoint::addNumericValue(TVariable v, TFloatValue min, TFloatValue max)
{
	if (numVarValues == nullptr)
		numVarValues = new std::vector<TFluentInterval>();
	numVarValues->emplace_back(v, min, max);
}
