%{
#include <stdio.h>
#include <string.h>
#include "part3_helpers.hpp"
#include "part3.hpp"
#include "part3.tab.hpp"

// void print_str(char *);
void print_err(char *);

%}

%option yylineno noyywrap
%option outfile="part3-lex.cpp"
/*%option debug*/

letter_ ([A-Za-z_])
letter ([A-Za-z])
digit ([0-9])
relop ((==)|(<>)|<|(<=)|>|(>=))
addop (\+|-)
mulop (\*|\/)
assign (=)
and (&&)
or (\|\|)
not (!)
sign (\(|\)|\{|\}|\,|\;|\:)
whitespace ([\t\n (\r\n)])
str \"(\\t|\\n|\\\"|[^\\"\n])*\"


id ({letter})({letter_}|{digit})*
integernum ({digit}+)
realnum {digit}+\.{digit}+


%%

int {
    // yylval = makeNode("int", NULL, NULL);
    yylval.name = yytext;
    return int_token;
}

float {
    // yylval = makeNode("float", NULL, NULL);
    yylval.name = yytext;
    return float_token;
}

void {
    // yylval = makeNode("void", NULL, NULL);
    yylval.name = yytext;
    return void_token;
}

write {
    // yylval = makeNode("write", NULL, NULL);
    return write_token;
}

read {
    // yylval = makeNode("read", NULL, NULL);
    return read_token;
}

optional {
    // yylval = makeNode("optional", NULL, NULL);
    return optional_token;
}

while {
    // yylval = makeNode("while", NULL, NULL);
    return while_token;
}

do {
    // yylval = makeNode("do", NULL, NULL);
    return do_token;
}

if {
    // yylval = makeNode("if", NULL, NULL);
    return if_token;
}

then {
    // yylval = makeNode("then", NULL, NULL);
    return then_token;
}

else {
    // yylval = makeNode("else", NULL, NULL);
    return else_token;
}

return {
    // yylval = makeNode("return", NULL, NULL);
    return return_token;
}

{integernum} {
    // yylval = makeNode("integernum", yytext, NULL);
    // yylval.name = yytext;
    yylval.val = atoi(yytext);
    return integernum_token;
}
{realnum} {
    // yylval = makeNode("realnum", yytext, NULL);
    yylval.name = yytext;
    return realnum_token;
}
{id} {
    // yylval = makeNode("id", yytext, NULL);
    yylval.name = yytext;
    return id_token;
}
{relop} {
    // yylval = makeNode("relop", yytext, NULL);
    yylval.name = yytext;
    return relop_token;
}
{addop} {
    // yylval = makeNode("addop", yytext, NULL);
    yylval.name = yytext;
    return addop_token;
}
{mulop} {
    // yylval = makeNode("mulop", yytext, NULL);
    yylval.name = yytext;
    return mulop_token;
}
{assign} {
    // yylval = makeNode("assign", yytext, NULL);
    return assign_token;
}
{and} {
    // yylval = makeNode("and", yytext, NULL);
    return and_token;
}
{or} {
    // yylval = makeNode("or", yytext, NULL);
    return or_token;
}
{not} {
    // yylval = makeNode("not", yytext, NULL);
    return not_token;
}
{sign} {
    // yylval = makeNode(yytext, NULL, NULL);
    yylval.name = yytext;
	return yytext[0];
}

{whitespace}	; /* Ignore */

{str} {
    char* str = yytext;  // Get the string from yytext
    str[yyleng-1] = 0;   // Null-terminate the string
    str++;               // Move the pointer to the next character (skipping the opening quote)
    // yylval = makeNode("str", str, NULL);  // Create a node with the string
    yylval.name = str;
    return str_token;          // Return the token type for a string
}

#.*      /* Ignore comments (anything after # until the end of the line) */
. print_err(yytext);

%%

void print_err(char *err)
{
    printf("Lexical error: '%s' in line number %d\n", err, yylineno);
    exit(1);
}