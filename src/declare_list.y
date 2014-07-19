%{
	#include <stdio.h>
	int yylex();
	int yyparse();
	FILE *yyin;
	FILE *yyout;
	int lines;
%}

%union {
	int val;
	float f;
	char *text;
};

%token <text> T_STRING
%token <text> T_RET
%token <text> T_NAMESPACE
%token <text> T_NS_SEPARATOR
%token <text> T_ARRAY
%token <text> T_CLASS
%token <text> T_CLASS_C
%token <text> T_TRAIT_C
%token <text> T_FUNC_C
%token <text> T_METHOD_C
%token <text> T_LINE
%token <text> T_FILE
%token <text> T_DIR
%token <text> T_NS_C
%token <text> T_LNUMBER
%token <text> T_DNUMBER
%token <text> T_CONSTANT_ENCAPSED_STRING
%token <text> T_START_HEREDOC
%token <text> T_END_HEREDOC
%token <text> T_ENCAPSED_AND_WHITESPACE
%token <text> T_DTWO_POINTS
%token <text> T_SL
%token <text> T_SR
%token <text> T_LOGICAL_OR
%token <text> T_LOGICAL_XOR
%token <text> T_LOGICAL_AND
%token <text> T_BOOLEAN_OR
%token <text> T_BOOLEAN_AND
%token <text> T_IS_EQUAL
%token <text> T_IS_NOT_EQUAL
%token <text> T_IS_IDENTICAL
%token <text> T_IS_NOT_IDENTICAL
%token <text> T_IS_SMALLER_OR_EQUAL
%token <text> T_IS_GREATER_OR_EQUAL
%token <text> T_STATIC
%token <text> T_DOUBLE_ARROW
%token <text> T_POW

%type <text> static_scalar
%type <text> common_scalar

%start declare_list

%%

declare_list:
		T_STRING '=' static_scalar { printf("%s ", $3); }
	|	declare_list ',' T_STRING '=' static_scalar { printf("%s ", $3); }
;


static_scalar:
		common_scalar { }
	|	static_class_name_scalar { }
	|	namespace_name  { }
	|	T_NAMESPACE T_NS_SEPARATOR namespace_name { }
	|	T_NS_SEPARATOR namespace_name { }
	|	T_ARRAY '(' static_array_pair_list ')' { }
	|	'[' static_array_pair_list ']' { }
	|	static_class_constant { }
	|	T_CLASS_C { }
	|	static_operation { }
;


common_scalar:
		T_LNUMBER  { }
	|	T_DNUMBER  { }
	|	T_CONSTANT_ENCAPSED_STRING { }
	|	T_LINE  { }
	|	T_FILE  { }
	|	T_DIR    { }
	|	T_TRAIT_C { }
	|	T_METHOD_C { }
	|	T_FUNC_C { }
	|	T_NS_C { }
	|	T_START_HEREDOC T_ENCAPSED_AND_WHITESPACE T_END_HEREDOC { }
	|	T_START_HEREDOC T_END_HEREDOC { }
;
static_class_name_scalar:
	class_name T_DTWO_POINTS { }
;
namespace_name:
		T_STRING { }
	|	namespace_name T_NS_SEPARATOR T_STRING { }
;
static_array_pair_list:
		/* empty */ { }
	|	non_empty_static_array_pair_list possible_comma { }
;
static_class_constant:
		class_name T_DTWO_POINTS T_STRING { }
;
static_operation:
		static_scalar '[' static_scalar ']' { }
	|	static_scalar '+' static_scalar { }
	|	static_scalar '-' static_scalar { }
	|	static_scalar '*' static_scalar { }
	|	static_scalar T_POW static_scalar { }
	|	static_scalar '/' static_scalar { }
	|	static_scalar '%' static_scalar { }
	|	'!' static_scalar { }
	|	'~' static_scalar { }
	|	static_scalar '|' static_scalar { }
	|	static_scalar '&' static_scalar { }
	|	static_scalar '^' static_scalar { }
	|	static_scalar T_SL static_scalar { }
	|	static_scalar T_SR static_scalar { }
	|	static_scalar '.' static_scalar { }
	|	static_scalar T_LOGICAL_XOR static_scalar { }
	|	static_scalar T_LOGICAL_AND static_scalar { }
	|	static_scalar T_LOGICAL_OR static_scalar { }
	|	static_scalar T_BOOLEAN_AND static_scalar { }
	|	static_scalar T_BOOLEAN_OR static_scalar { }
	|	static_scalar T_IS_IDENTICAL static_scalar { }
	|	static_scalar T_IS_NOT_IDENTICAL static_scalar { }
	|	static_scalar T_IS_EQUAL static_scalar { }
	|	static_scalar T_IS_NOT_EQUAL static_scalar { }
	|	static_scalar '<' static_scalar { }
	|	static_scalar '>' static_scalar { }
	|	static_scalar T_IS_SMALLER_OR_EQUAL static_scalar { }
	|	static_scalar T_IS_GREATER_OR_EQUAL static_scalar { }
	|	static_scalar '?' ':' static_scalar { }
	|	static_scalar '?' static_scalar ':' static_scalar { }
	|	'+' static_scalar { }
	|	'-' static_scalar { }
	|	'(' static_scalar ')' { }
;


class_name:
		T_STATIC { }
	|	namespace_name { }
	|	T_NAMESPACE T_NS_SEPARATOR namespace_name { }
	|	T_NS_SEPARATOR namespace_name { }
;
namespace_name:
		T_STRING { }
	|	namespace_name T_NS_SEPARATOR T_STRING { }
;
non_empty_static_array_pair_list:
		non_empty_static_array_pair_list ',' static_scalar T_DOUBLE_ARROW static_scalar { }
	|	non_empty_static_array_pair_list ',' static_scalar { }
	|	static_scalar T_DOUBLE_ARROW static_scalar { }
	|	static_scalar { }
;
possible_comma:
		/* empty */ { }
	|	',' { }
;

%%

int yyerror(char *s) {
	printf("Error: %s en línea %d\n", s, lines);
	return 0;
}

int yywrap() {
	return 1;
}



