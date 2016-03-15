/* sharelock holmes stats list */


%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <vector>
using std::cout;
using std::endl;
using std::vector;
using std::string;

typedef vector<string> strings;
typedef struct { string name; bool is_string; strings sfields; vector<double> dfields; } col_t;

bool debugging = true;
int row = 0, col = 0;
vector<col_t> columns;
//strings field_names;
//vector<bool> field_is_string;

// put token
void cell(bool is_quoted) 
{ 
	if(row==0) {col_t c; c.name = yytext ; columns.push_back(c); return; }

	col_t &c = columns[col];
	if(row==1) {c.is_string = is_quoted; }
		
	if(!is_quoted) cout << "un" ;
	cout << "quoted cell: <" << yytext << ">" << endl; 
}

%}

%option noyywrap

%%


",\r"|"\r"	{ puts("EOR"); row++; col = 0 ; }

TODO MUST account for empty field

","  { puts("FS"); col++ ; }

\"([^\\\"]|\\.)*\"  { cell(true);}

[^,\r]+          { cell(false) ; }


%%

//extern "C"
int main_lex()
{
	yyin = fopen("/home/mcarter/cubie/home/mcarter/data/StatsList.csv", "r");
	yylex();

	if(debugging) {
		cout << "Fields are:" << endl;
		for(auto &c: columns) {
			cout << c.name << "\t" << c.is_string << endl ;
		}
	}
	return EXIT_SUCCESS;
}

