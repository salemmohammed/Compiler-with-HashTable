%{
#include "symbols.h"
int no = 0;
extern yylineno;

int find_symbol(char *s)
{
	int i ;
	
	if(no == 0)
	{
		
		return -1;
	}
	else
	{	for(i = 0 ; i < no; i++)
		{
			
			if(strcmp(s,table[i].id) == 0) // if found
			{
				
				return i;
			}
	
		}
		if(i == no)
		{
			
			return -1; // if not found 
		}		
	
	}

}


void add_symbol(char *id, int type )
{
	
	
	int result = find_symbol( id );
	if(no == 0 )
	{
		
		table[no].id = strdup(id);
		table[no].type = type;		
		no++;
		
	}
	else
	{
		
		if(result == -1)
		{
			table[no].id = strdup(id);
			table[no].type = type;
			no++;
			
		}
		else{
			printf("%s element already exist\n",id);
			exit(-1);
		}
	
	}
}

int add_symbol_val( char *id, float value , int type)
{
	
	int i = find_symbol(id );
	
	if(i < 0)
	{
		
		return -3; // prob type 4 - variable is not defined to add value 
	}
	else if(table[i].type != type)
	{
		
		return -2; // prob type 12 different types of values 
	}
	else
	{
		table[i].value = value;
		
		return 1; // successfull add 
	}

}


float get_value( char *id)
{
	int i = find_symbol(id);
	if(i  < 0)
	{	
		return -1;
		
	}	
	else
	{
		
		return (table[i].value);
	}

}


int get_type(char *id)
{
	int i = find_symbol(id);
	if(i  < 0)
	{	
		return -1;
		
	}	
	else
	{
		
		return table[i].type;
	}

}


%}

%token TOK_SEMICOLON TOK_ADD  TOK_MUL TOK_PRINTVAR TOK_MAIN TOK_OBRACE TOK_CBRACE TOK_INT TOK_EQUAL TOK_FL TOK_VARIABLE TOK_NUM TOK_FLOAT	

	
%union{

        char *str;
        int intval;
        float floatval;

        struct Info
        {
		char *id;
		int ival;
		float fval; 
		int type;
        
        } info; 
}


%left TOK_ADD 
%left TOK_MUL 
%type <intval>  TOK_NUM
%type <floatval> TOK_FLOAT	
%type <str> TOK_VARIABLE 
%type <info> expr
%start prog
%%

prog:										
	|TOK_MAIN TOK_OBRACE stmts TOK_CBRACE		
;

stmts:	
	| stmt TOK_SEMICOLON stmts 

;
stmt:
	TOK_INT TOK_VARIABLE  				{	add_symbol($2,0);}
	|TOK_FL TOK_VARIABLE 				{	add_symbol($2,1);} 
	| TOK_VARIABLE TOK_EQUAL expr 			{	
								int res = find_symbol($1);
								if(res == -1 )
								{
								 
								fprintf(stdout, "Line %d: %s is used but is not declared \n",yylineno,$1); exit(1);
								
								}
							
								if(get_type($1) == 0 && $<info.type>3 == 0)
								{	
									
									add_symbol_val($1,$<info.ival>3,0);	
									
								}
								else if(get_type($1) == 1 && $<info.type>3 == 1)
								{	
									add_symbol_val($1,$<info.fval>3,1);	
								}
								else if(get_type($1)!= $<info.type>3)
								{	
									fprintf(stdout, "Line %d: type error \n",yylineno); exit(1);
								}
										

									
							}
	
	| TOK_PRINTVAR TOK_VARIABLE   	      			{
					
									if(get_type($2) == 0)
									{	int val1 = get_value($2);	
										fprintf(stdout, "%d\n", val1);
									
									}
									else if(get_type($2) == 1)							
									{	float val2 = get_value($2);	
										fprintf(stdout, "%0.2f\n", val2);
									
									}							
							}
;

	

expr:	TOK_NUM						{$<info.ival>$ = $1; $<info.type>$ = 0;}
	| TOK_FLOAT					{$<info.fval>$ = $1; $<info.type>$ = 1;}
	| TOK_VARIABLE 			 		{		
								int res = get_type($1);

								if( get_type($1) == 0 )								
								{ 	int val1 = get_value($1);
									$<info.ival>$ = val1;
									$<info.type>$ = 0;
									
								}
								else if(get_type($1) == 1) 
								{ 	float val2 = get_value($1);
									$<info.type>$ = 1;
									$<info.fval>$ = val2;

								}

								
								
							}
	| expr TOK_MUL expr				{
		if($<info.type>1 != $<info.type>3){fprintf(stdout, "Line %d: type error \n",yylineno); exit(1);}
		else if($<info.type>1 == 0 && $<info.type>3 ==0){$<info.type>$ =0; $<info.ival>$ = $<info.ival>1 *  $<info.ival>3; 
		
		}
		else if($<info.type>1 == 1 && $<info.type>3 ==1){$<info.type>$ =1; $<info.fval>$ = $<info.fval>1 *  $<info.fval>3; 
		
		}
		
	 						 }
	| expr TOK_ADD expr				 {
		if($<info.type>1 != $<info.type>3){fprintf(stdout, "Line %d: type error \n",yylineno); exit(1);}
		else if($<info.type>1 == 0 && $<info.type>3 ==0){$<info.type>$ =0; $<info.ival>$ = $<info.ival>1 +  $<info.ival>3; 
		
		}
		else if($<info.type>1 == 1 && $<info.type>3 ==1){$<info.type>$ =1; $<info.fval>$ = $<info.fval>1 +  $<info.fval>3; 
		
		}
		
	 						 }
					 			
	
;

	
%%

int yyerror(char *s)
{
	extern yylineno;
	fprintf(stdout,"Parsing error :Line %d \n",yylineno);
	exit(-1);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
