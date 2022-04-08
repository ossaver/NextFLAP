#ifndef SCHEDULER_H
#define SCHEDULER_H

#include "../utils/utils.h"
#include <vector>

class Scheduler {
private:
	std::vector< std::vector<unsigned int> >* matrix;
	TTimePoint lastTimePoint;
	unsigned int iteration;

	inline bool existOrder(TTimePoint t1, TTimePoint t2) { return (*matrix)[t1][t2] == iteration; }
	unsigned int topologicalOrder(TTimePoint orig, std::vector<TTimePoint>* linearOrder, unsigned int pos, 
		std::vector<bool>* visited);

public:
	Scheduler(TTimePoint lastTimePoint, std::vector< std::vector<unsigned int> >* matrix, unsigned int iteration);
	void topologicalOrder(std::vector<TTimePoint>* linearOrder);
};

#endif
