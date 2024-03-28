#ifndef _PART3_HELPERS_HPP_
#define _PART3_HELPERS_HPP_

#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

typedef enum {int_t = 1, float_t = 2, void_t = 0} Type;

map<string, Function> functions_map;
static map<string, Symbol> symbol_map;
static int current_depth = 0;
static vector<Symbol> function_params_symbols;


typedef struct { // yylval - token attributes
	string name; 
	Type type;
	vector<Type> required_params_types;
	vector<Type> optional_params_types;
	vector<Type> call_params_types;
	int val;
} yystype;

class Function {
	public:
		Type return_type;
		string name;
		vector<Symbol> params_symbols;
		vector<Type> required_params_types; // The types of the required parameters of the function
		vector<Type> optional_params_types; // List of all the addresses in .rsk file where the function is being called
		bool implemented;
		int start_address; // line number
		vector<int> calling_addresses;  // List of lines where we call the function
};

class Symbol {
	public:
		Type type;
		string name;
		int depth;
};

#define YYSTYPE yystype // yylval - token attributes

#endif