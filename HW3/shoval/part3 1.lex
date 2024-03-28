%{
/* Definition Section */
#include <stdio.h>
#include <stdlib.h>
#include "part3_helpers.hpp"
#include "part3.tab.hpp"
#define LEX_ERR 1
%}

%option yylineno
%option noyywrap
%option outfile="part3.cpp"

/* regular definitions */
digit		[0-9]
letter		[a-zA-Z]
whitespace  "\t"|"\n"|"\r\n"|" "



comment      (#[^\r?\n]*)
marks        [(){},;:]
str          \"(\\t|\\n|\\\"|[^\\"\n])*\"
id 	     	 {letter}({letter}|{digit}|_)*
integernum   {digit}+
realnum      {digit}+(\.{digit}+)
relop	     (==|<>|<=?|>=?)
addop	     [+-]
mulop 	     [*/]
assign 	     [=]
and 	     (&&)
or           (\|\|)
not          [!]
ws           {whitespace}+

%%

int {
	return tk_int;
}
	
float {
	return tk_float;
}

void {
	return tk_void;
}

write {
	return tk_write;
}

read {
	return tk_read;
}

optional {
	return tk_optional;
}

while {
	return tk_while;
}

do {
	return tk_do;
}

if {
	return tk_if;
}

then {
	return tk_then;
}

else {
	return tk_else;
}

return {
	return tk_return;
}
	
{comment}    ;

{marks} {
	yylval.name = strdup(yytext);
	return yytext[0];
}
	
{id} {
	yylval.name = strdup(yytext);
	return tk_id;
}

{integernum} {
	yylval.name = strdup(yytext);
	return tk_integernum;
}

{realnum} {
	yylval.name = strdup(yytext);
	return tk_realnum;
}

{str} {
	char *c = yytext;
	c[yyleng-1] = 0;
	c++;
	yylval.name = strdup(c);
	return tk_str;
}

{relop} {
	yylval.name = strdup(yytext);
	return tk_relop;
}
	
{addop} {
	yylval.name = strdup(yytext);
	return tk_addop;
}

{mulop} {
	yylval.name = strdup(yytext);
	return tk_mulop;
}

{assign} {
	return tk_assign;
}

{and} {
	return tk_and;
}

{or} {
	return tk_or;
}

{not} {
	return tk_not;
}

{ws}	     ;

.            {
		cerr << "Lexical error: '" << yytext << "' in line number " << yylineno << endl;
		exit(LEX_ERR);
}

%%
