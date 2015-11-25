# Compiler-with-HashTable

/*************************************
/***************************/	
Code was tested in bingsuns.
/***************************/

/***************************/
	Execution guidlines 

/***************************/
	1) make the file using "make" command , makefile has the capability to clean the code as well using ("make clean" command).
	2) executable is created with the name "./calc"

/*******************************/
	How code works
/*******************************/

Symbol table is implemented using a struct and symbol table is size of 1000 symbol elements, ranging from 0 to 999.

typedef struct symbols{
	char *id;
	float value;
	int type;
}symbols;

These are the function implmented to identify tokens;

int get_type(char *id); //  get the type  whether int or float 
float get_value( char *id); //  get the value of ID 
int add_symbol_val( char *id, float value , int type); //  adding the value of ID 
void add_symbol(char *id, int type ); //  adding the ID 
int find_symbol(char *s); // finding the ID from the symbol table

/***************/
Special note :
/***************/

1) This code is able to detect same ID declaration for different variable types (eg: int and float), when it detects it reports 

" ID element already exist" error and exit the program. 

2) This  code successfully passing all the test cases with the corresponding outputs as mention the in the assignment document	

Project contains :
	calc.l
	calc.y
	symbols.h
	makefile
	Readme
