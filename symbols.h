#ifndef SYMBOLS
#define SYMBOLS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct symbols{
	char *id;
	float value;
	int type;
}symbols;

symbols table[1000];


#endif
