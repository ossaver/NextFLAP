#ifndef PLANNER_PARAMETERS_H
#define PLANNER_PARAMETERS_H

#include <time.h>

struct PlannerParameters {
	float total_time;
	char* domainFileName;
	char* problemFileName;
	bool generateGroundedDomain;
	bool keepStaticData;
	bool noSAS;
	bool generateMutexFile;
	clock_t startTime;
	PlannerParameters() :
		total_time(0), domainFileName(nullptr), problemFileName(nullptr), generateGroundedDomain(false), 
		keepStaticData(false), noSAS(false), generateMutexFile(false), startTime(clock()) {
	}
};

#endif
