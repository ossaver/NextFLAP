#include "utils/utils.h"
#include "parser/parsedTask.h"
#include "preprocess/preprocess.h"
#include "grounder/grounder.h"
#include "sas/sasTranslator.h"
#include "planner/plannerSetting.h"
#include "planner/z3Checker.h"
#include "planner/printPlan.h"
#include "parser/parser.h"

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Main method: parses the command-line arguments and   */
/* launches the planner.                                */
/********************************************************/

#define OPTIMIZE_MAKESPAN true

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

// Prints the command-line arguments of the planner
void printUsage() {
    cout << "Usage: NextFLAP <domain_file> <problem_file> [-ground] [-static] [-mutex]" << endl;
    cout << " -ground: generates the GroundedDomain.pddl and GroundedProblem.pddl files." << endl;
    cout << " -static: keeps the static data in the planning task." << endl;
    cout << " -nsas: does not make translation to SAS (finite-domain variables)." << endl;
    cout << " -mutex: generates the mutex.txt file with the list of static mutex facts." << endl;
}

// Parses the domain and problem files
ParsedTask* parseStage(PlannerParameters* parameters) {
    clock_t t = clock();
    Parser parser;
    ParsedTask* parsedTask = parser.parseDomain(parameters->domainFileName);
    parser.parseProblem(parameters->problemFileName);
    float time = toSeconds(t);
    parameters->total_time += time;
    cout << ";Parsing time: " << time << endl;
    return parsedTask;
}

// Preprocesses the parsed task
PreprocessedTask* preprocessStage(ParsedTask* parsedTask, PlannerParameters* parameters) {
    clock_t t = clock();
    Preprocess preprocess;
    PreprocessedTask* prepTask = preprocess.preprocessTask(parsedTask);
    float time = toSeconds(t);
    parameters->total_time += time;
    //cout << prepTask->toString() << endl;
    cout << ";Preprocessing time: " << time << endl;
    return prepTask;
}

// Grounder stage of the preprocessed task
GroundedTask* groundingStage(PreprocessedTask* prepTask,
    PlannerParameters* parameters) {
    clock_t t = clock();
    Grounder grounder;
    GroundedTask* gTask = grounder.groundTask(prepTask, parameters->keepStaticData);
    float time = toSeconds(t);
    parameters->total_time += time;
    //cout << gTask->toString() << endl;
    cout << ";Grounding time: " << time << endl;
    if (parameters->generateGroundedDomain) {
        cout << ";" << gTask->actions.size() << " grounded actions" << endl;
        gTask->writePDDLDomain();
        gTask->writePDDLProblem();
    }
    return gTask;
}

// SAS translation stage
SASTask* sasTranslationStage(GroundedTask* gTask, PlannerParameters* parameters) {
    clock_t t = clock();
    SASTranslator translator;
    SASTask* sasTask = translator.translate(gTask, parameters->noSAS,
        parameters->generateMutexFile, parameters->keepStaticData);
    float time = toSeconds(t);
    parameters->total_time += time;
    cout << ";SAS translation time: " << time << endl;
    //cout << sasTask->toString() << endl;
    /*for (SASAction& a : sasTask->actions) {
        cout << sasTask->toStringAction(a) << endl;
    }*/
    return sasTask;
}

// Sequential calls to the preprocess stages
SASTask* doPreprocess(PlannerParameters* parameters) {
    parameters->total_time = 0;
    SASTask* sTask = nullptr;
    ParsedTask* parsedTask = parseStage(parameters);
    if (parsedTask != nullptr) {
        //cout << parsedTask->toString() << endl;
        PreprocessedTask* prepTask = preprocessStage(parsedTask, parameters);
        if (prepTask != nullptr) {
            GroundedTask* gTask = groundingStage(prepTask, parameters);
            if (gTask != nullptr) {
                //cout << gTask->toString() << endl;
                sTask = sasTranslationStage(gTask, parameters);
                delete gTask;
            }
            delete prepTask;
        }
        delete parsedTask;
    }
    return sTask;
}

// Sequential calls to the main planning stages
void startPlanning(PlannerParameters* parameters) {
    SASTask* sTask = doPreprocess(parameters);
    if (sTask == nullptr)
        return;
    clock_t t = clock();
    PlannerSetting planner(sTask);
    Plan* solution;
    float bestMakespan = FLOAT_INFINITY;
    int bestNumSteps = MAX_UINT16;
    do {
        solution = planner.plan(bestMakespan, t);
        float time = toSeconds(t);
        if (solution != nullptr) {
            //cout << ";Checking solution" << endl;
            Z3Checker checker;
            TControVarValues cvarValues;
            float solutionMakespan;

            if (checker.checkPlan(solution, OPTIMIZE_MAKESPAN, &cvarValues)) {
                solutionMakespan = PrintPlan::getMakespan(solution);
                if (solutionMakespan < bestMakespan ||
                    (abs(solutionMakespan - bestMakespan) < EPSILON && solution->g < bestNumSteps)) {
                    PrintPlan::print(solution, &cvarValues);
                    bestMakespan = solutionMakespan;
                    bestNumSteps = solution->g;
                    cout << ";Solution found in " << time << endl;
                }
            }
        }
    } while (solution != nullptr);
}

// Main method
int main(int argc, char* argv[]) {
    PlannerParameters parameters;
    if (argc < 3) {
        printUsage();
    }
    else {
        int param = 1;
        while (param < argc) {
            if (argv[param][0] != '-') {
                if (parameters.domainFileName == nullptr)
                    parameters.domainFileName = argv[param];
                else if (parameters.problemFileName == nullptr)
                    parameters.problemFileName = argv[param];
                else {
                    parameters.domainFileName = nullptr;
                    break;
                }
            }
            else {
                if (compareStr(argv[param], "-ground"))
                    parameters.generateGroundedDomain = true;
                else if (compareStr(argv[param], "-static"))
                    parameters.keepStaticData = true;
                else if (compareStr(argv[param], "-nsas"))
                    parameters.noSAS = true;
                else if (compareStr(argv[param], "-mutex"))
                    parameters.generateMutexFile = true;
                else {
                    parameters.domainFileName = nullptr;
                    break;
                }
            }
            param++;
        }
        if (parameters.domainFileName == nullptr || parameters.problemFileName == nullptr) {
            printUsage();
        }
        else {
            startPlanning(&parameters);
        }
    }

    return 0;
}
