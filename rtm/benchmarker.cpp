#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>

std::string exec(char* cmd) {
	FILE* pipe = popen(cmd, "r");
	if (!pipe)
		return "ERROR";
	char buffer[128];
	std::string result = "";
	while (!feof(pipe)) {
		if (fgets(buffer, 128, pipe) != NULL)
			result += buffer;
	}
	pclose(pipe);
	return result;
}

int main(int argc, char *argv[]) {
	const char* program = "./clocktime/clocktime_rate_busy";
//	const char *identifier[] = { "-l", "-r" };
//	int *values[2];
//	values[0][0] = 100000;
//	int repeats[] = { 1, 10, 100, 1000, 10000, 20000, 30000, 40000, 50000,
//			60000, 70000, 80000, 90000, 100000 };
//	values[1] = repeats;
//
//	for (int v = 0; v < 2; v++) {
//		for (int i = 0; i < sizeof(values[v] / sizeof(values[v][0])); i++) {
//
//		}
//	}
	char* cmd = "./clocktime/clocktime_rate_busy -l 1000 -r 1000";
	std::string result = exec(cmd);
	printf("Result: %s\n", result.c_str());
}
