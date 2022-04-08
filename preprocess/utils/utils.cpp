#include "utils.h"
#include <ctype.h>
#include <string.h>

// Compare two strings
bool compareStr(char* s1, const char* s2) {
	unsigned int l = (unsigned int)strlen(s1);
	if (l != strlen(s2))
		return false;
	for (unsigned int i = 0; i < l; i++)
		if (tolower(s1[i]) != s2[i])
			return false;
	return true;
}
