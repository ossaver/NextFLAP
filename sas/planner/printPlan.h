#ifndef PRINT_PLAN_H
#define PRINT_PLAN_H

#include "plan.h"
#include "z3Checker.h"

class PrintPlan {
public:
	static void print(Plan* p, TControVarValues* cvarValues = nullptr);
	static float getMakespan(Plan* p);
};

#endif // !PRINT_PLAN_H
