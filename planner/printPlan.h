#ifndef PRINT_PLAN_H
#define PRINT_PLAN_H

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Class to plan printing on screen.                    */
/********************************************************/

#include "plan.h"
#include "z3Checker.h"

class PrintPlan {
public:
	static std::string actionName(SASAction* a);
	static void print(Plan* p, TControVarValues* cvarValues = nullptr);
	static float getMakespan(Plan* p);
	static void rawPrint(Plan* p, SASTask* task);
};

#endif // !PRINT_PLAN_H
