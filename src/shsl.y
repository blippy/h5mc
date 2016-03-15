
%{
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>

#include "common.h"

using std::string;
using std::vector;
using std::cout;
using std::endl;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);

bool debug_parser = false;

void ywrite(const char *type, string &val)
{
	if(debug_parser) { cout << type << ": <" << val << ">" << endl; }
}

#define YWRITE(X,Y)  if(debug_parser) cout << X << ": <" << Y << ">" << endl
#define XYWRITE(X,Y) ; 
//#define YYSTYPE int 
//YYSTYPE yylval;

//#define yystype string

strings row;
strmat rows;

void add_cell(string s)
{
	row.push_back(s);
}

void add_row()
{
	//for(auto c: row) { cout << c << endl; }
	rows.push_back(row);
	row.clear();
}



%}

%union { char *str; }


%token FS
%token RS
%token <str> QSTR
%token <str>  USTR

%%

rows:
    row			
    | rows row

row: cells RS { XYWRITE("EOR!", "");  add_row() ; }
	
cells:
    cell
    | cells FS cell 

cell:
    %empty	{XYWRITE("EMPTY", "");  add_cell(""); }
    | QSTR	{XYWRITE("QSTR", $1);  add_cell($1); }
    | USTR	{XYWRITE("USTR", $1); add_cell($1); }



%%

strmat bison_main()
{
        yyin = fopen("/home/mcarter/cubie/home/mcarter/data/StatsList.csv", "r");
        yyparse();
	return rows;
}

int ymain()
{
	debug_parser = true;
	yyin = fopen("/home/mcarter/cubie/home/mcarter/data/StatsList.csv", "r");
	yyparse();

	if(debug_parser) {
		for(auto r:rows) {
			for(auto c: r) { cout << "  " << c << endl; }
			cout << "END-OF-ROW" << endl ; 
		}
	}
}


void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}


