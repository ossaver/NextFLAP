#ifndef PLANNER_PARAMETERS_H
#define PLANNER_PARAMETERS_H

#include <time.h>

struct PlannerParameters {
	float total_time;
	char* domainFileName;
	char* problemFileName;
	char* outputFileName;
	bool generateGroundedDomain;
	bool keepStaticData;
	bool noSAS;
	bool generateMutexFile;
	bool generateTrace;
	int numSolutions;
	clock_t startTime;
	PlannerParameters() :
		total_time(0), domainFileName(nullptr), problemFileName(nullptr), outputFileName(
			nullptr), generateGroundedDomain(false), keepStaticData(
				false), noSAS(false), generateMutexFile(false), generateTrace(
					false), numSolutions(1), startTime(clock()) {
	}
};

#endif
