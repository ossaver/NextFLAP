#include "utils.h"
#include <ctype.h>
#include <string.h>

/********************************************************/
/* Oscar Sapena Vercher - DSIC - UPV                    */
/* April 2022                                           */
/********************************************************/
/* Constants and utilities.								*/
/********************************************************/

bool USE_USEFUL_ACTIONS = false;

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
