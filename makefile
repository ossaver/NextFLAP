CC = g++

CFLAGS = -c -Wall -std=c++20 -O3 -Wextra -pedantic -Iz3/include/
LFLAGS = -L/usr/lib/x86_64-linux-gnu -lm '-Wl,-rpath,$$ORIGIN'
OBJS = nextflap.o parser.o syntaxAnalyzer.o parsedTask.o preprocess.o preprocessedTask.o grounder.o groundedTask.o evaluator.o hFF.o hLand.o landmarks.o numericRPG.o rpg.o temporalRPG.o intervalCalculations.o linearizer.o plan.o planBuilder.o planComponents.o planEffects.o planner.o plannerSetting.o printPlan.o selector.o state.o successors.o z3Checker.o mutexGraph.o sasTask.o sasTranslator.o utils.o 

all: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) z3/lib/libz3.so -o nextflap
	
nextflap.o:
	$(CC) $(CFLAGS) nextflap.cpp

parser.o:
	$(CC) $(CFLAGS) parser/parser.cpp

syntaxAnalyzer.o:
	$(CC) $(CFLAGS) parser/syntaxAnalyzer.cpp

parsedTask.o:
	$(CC) $(CFLAGS) parser/parsedTask.cpp
	
preprocess.o:
	$(CC) $(CFLAGS) preprocess/preprocess.cpp
	
preprocessedTask.o:
	$(CC) $(CFLAGS) preprocess/preprocessedTask.cpp

grounder.o:
	$(CC) $(CFLAGS) grounder/grounder.cpp

groundedTask.o:
	$(CC) $(CFLAGS) grounder/groundedTask.cpp

evaluator.o:
	$(CC) $(CFLAGS) heuristics/evaluator.cpp

hFF.o:
	$(CC) $(CFLAGS) heuristics/hFF.cpp

hLand.o:
	$(CC) $(CFLAGS) heuristics/hLand.cpp

landmarks.o:
	$(CC) $(CFLAGS) heuristics/landmarks.cpp

numericRPG.o:
	$(CC) $(CFLAGS) heuristics/numericRPG.cpp

rpg.o:
	$(CC) $(CFLAGS) heuristics/rpg.cpp

temporalRPG.o:
	$(CC) $(CFLAGS) heuristics/temporalRPG.cpp

intervalCalculations.o:
	$(CC) $(CFLAGS) planner/intervalCalculations.cpp

linearizer.o:
	$(CC) $(CFLAGS) planner/linearizer.cpp

plan.o:
	$(CC) $(CFLAGS) planner/plan.cpp

planBuilder.o:
	$(CC) $(CFLAGS) planner/planBuilder.cpp

planComponents.o:
	$(CC) $(CFLAGS) planner/planComponents.cpp

planEffects.o:
	$(CC) $(CFLAGS) planner/planEffects.cpp

planner.o:
	$(CC) $(CFLAGS) planner/planner.cpp

plannerSetting.o:
	$(CC) $(CFLAGS) planner/plannerSetting.cpp

printPlan.o:
	$(CC) $(CFLAGS) planner/printPlan.cpp

selector.o:
	$(CC) $(CFLAGS) planner/selector.cpp

state.o:
	$(CC) $(CFLAGS) planner/state.cpp

successors.o:
	$(CC) $(CFLAGS) planner/successors.cpp

z3Checker.o:
	$(CC) $(CFLAGS) planner/z3Checker.cpp

mutexGraph.o:
	$(CC) $(CFLAGS) sas/mutexGraph.cpp

sasTask.o:
	$(CC) $(CFLAGS) sas/sasTask.cpp

sasTranslator.o:
	$(CC) $(CFLAGS) sas/sasTranslator.cpp

utils.o:
	$(CC) $(CFLAGS) utils/utils.cpp

clean:
	rm -f *.o
	rm -f nextflap

