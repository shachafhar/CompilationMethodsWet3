#ifndef PART3_HELPERS_HPP
#define PART3_HELPERS_HPP

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <string>
#include <map>

using namespace std;

typedef enum {t_int = 1, t_float = 2, t_void = 0} Type;

// for backpatching - merge lists
template <typename T>
static vector<T> merge(const vector<T>& lst1, const vector<T>& lst2) {
            vector<T> result;
            result.reserve(lst1.size() + lst2.size()); // Reserve space for merged list

            // Copy elements from lst1
            copy(lst1.begin(), lst1.end(), back_inserter(result));

            // Copy elements from lst2
            copy(lst2.begin(), lst2.end(), back_inserter(result));

            return result;
        }

// Token definition
typedef struct 
{
	// Name of the id token
	string name;
	// Type of the token
	Type type;
	// The line number of the token in the .rsk file
	int quad;
	// Lists for backpatching
	vector<int> nextList; 
	vector<int> trueList;
	vector<int> falseList;
	// List of the required parameters types
	vector<Type> req_params_type_lst;
	// List of the optional parameters types
	vector<Type> opt_params_type_lst;
	// Token's register
	int reg;
	// List of the parameters registers
	vector<Type> params_regs_lst;
	// Memory offset
	int mem_offset;
} yystype;

// Symbol definition
typedef struct 
{
	map<int,Type> type; // Holds the type according to scope level
	int max_level; // Most inner scope where the symbol is defined in
	map<int,int> offset; // Holds the offset of the symbol according to scope level
	
} Symbol;

// Buffer definition
class Buffer
{
	vector<string> code;
	
	public:
		// Buffer Constructor
		Buffer()
		{
			code.clear();
		}
		
		// Print a command to the buffer
		void emit(const string& command)
		{
			code.push_back(command);
		}
		
		// Print a command to the start of the buffer
		void emit_front(const string& command)
		{
			code.insert(code.begin(), command);
		}
		
		// Return the next line in the buffer
		int next_quad()
		{
			return code.size() + 1;
		}
		
		// Backpatch the "holes" of the addresses in the list with the given "address"
		void backpatch(vector<int> list, int address)
		{
			for(unsigned i = 0; i < list.size(); i++)
			{
				code[list[i] - 1] += to_string(address); //TODO: Check if a space is needed
			}
		}
		
		// Print the code in the buffer
		string print_code()
		{
			string output = "";
			for (int i = 0; i < code.size(); i++) {
				output += code[i] + "\n";
			}
			return output;
		}	
}

// Function definition
typedef struct 
{
	bool is_defined; // Is implemented
	int start_addr;
	vector<Type> req_params_type; // List of the required function parameters types
	vector<Type> opt_params_type; // List of the optional function parameters types
	Type return_type;
	vector<int> call_addrs; // List of the function calling addresses
	
} Function;

// Globals 
static map<string,Symbol> symbol_table;
static map<string,Function> function_table;
static Buffer *buffer;
static Buffer code_buffer;
static int int_regs_num = 3; // Number of used registers for int vars in function
static int float_regs_num = 3; // Number of used registers for float vars in function
static int curr_mem_offset = 0; // Current memory offset to store the code
static int prev_mem_offset = 0; // Previous memory offset that the code was stored in
static int return_type; // The return type of current function
static int curr_scope_level = 0;
static vector<string> curr_func_params;
static vector<string> temp_func_params;
//TODO: check if optional params vector is needed

#define YYSTYPE yystype

#endif //PART3_HELPERS_HPP
