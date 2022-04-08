#include "scheduler.h"

Scheduler::Scheduler(TTimePoint lastTimePoint, std::vector< std::vector<unsigned int> >* matrix, unsigned int iteration) {
	this->lastTimePoint = lastTimePoint;
	this->matrix = matrix;
	this->iteration = iteration;
}

void Scheduler::topologicalOrder(std::vector<TTimePoint>* linearOrder) {
	unsigned int size = lastTimePoint + 1;
	linearOrder->resize(size, 0);
	std::vector<bool> visited(size, false);
	topologicalOrder(1, linearOrder, lastTimePoint, &visited);
}

unsigned int Scheduler::topologicalOrder(TTimePoint orig, std::vector<TTimePoint>* linearOrder, unsigned int pos,
	std::vector<bool>* visited) {
	(*visited)[orig] = true;
	for (unsigned int i = 2; i <= linearOrder->size(); i++) {
		if (existOrder(orig, i)) {
			if (!((*visited)[i])) {
				// cout << orig << " -> " << i << endl;
				pos = topologicalOrder(i, linearOrder, pos, visited);
			}
		}
	}
	(*linearOrder)[pos--] = orig;
	return pos;
}