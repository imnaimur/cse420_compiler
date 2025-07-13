%{
#include "symbol_info.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
extern FILE *yyin;

ofstream outlog;
int lines;
%}

%token IF ELSE FOR WHILE PRINTLN RETURN INT FLOAT VOID ID CONST_INT CONST_FLOAT ADDOP MULOP ASSIGNOP RELOP LOGICOP SEMICOLON COMMA LPAREN RPAREN LCURL RCURL

%%

start : program
    {
        outlog << "At line no: " << lines << " start : program\n\n";
    }
    ;

program : program unit
    {
        outlog << "At line no: " << lines << " program : program unit\n\n";
        outlog << $1->getname() + "\n" + $2->getname() << "\n\n";
        $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "program");
    }
    | unit
    {
        outlog << "At line no: " << lines << " program : unit\n\n";
        $$ = $1;
    }
    ;

unit : var_declaration
    | func_definition
    ;

var_declaration : type_specifier declaration_list SEMICOLON
    {
        outlog << "At line no: " << lines << " var_declaration : type_specifier declaration_list SEMICOLON\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + ";", "var_decl");
    }
    ;

type_specifier : INT
    {
        $$ = new symbol_info("int", "type");
    }
    | FLOAT
    {
        $$ = new symbol_info("float", "type");
    }
    | VOID
    {
        $$ = new symbol_info("void", "type");
    }
    ;

declaration_list : declaration_list COMMA ID
    {
        $$ = new symbol_info($1->getname() + "," + $3->getname(), "decl_list");
    }
    | ID
    {
        $$ = $1;
    }
    ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
    {
        outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + "(" + $4->getname() + ")\n" + $6->getname(), "func_def");
    }
    | type_specifier ID LPAREN RPAREN compound_statement
    {
        outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + "()\n" + $5->getname(), "func_def");
    }
    ;

parameter_list : parameter_list COMMA type_specifier ID
    {
        $$ = new symbol_info($1->getname() + "," + $3->getname() + " " + $4->getname(), "param_list");
    }
    | type_specifier ID
    {
        $$ = new symbol_info($1->getname() + " " + $2->getname(), "param_list");
    }
    ;

compound_statement : LCURL statements RCURL
    {
        $$ = new symbol_info("{" + $2->getname() + "}", "compound_stmt");
    }
    | LCURL RCURL
    {
        $$ = new symbol_info("{}", "compound_stmt");
    }
    ;

statements : statements statement
    {
        $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "stmts");
    }
    | statement
    {
        $$ = $1;
    }
    ;

statement : var_declaration
    | expression_statement
    | compound_statement
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
        outlog << "At line no: " << lines << " statement : FOR (...) statement\n\n";
        $$ = new symbol_info("for(...)\n" + $7->getname(), "stmt");
    }
    | IF LPAREN expression RPAREN statement
    {
        $$ = new symbol_info("if(...)\n" + $5->getname(), "stmt");
    }
    | IF LPAREN expression RPAREN statement ELSE statement
    {
        $$ = new symbol_info("if(...)\n" + $5->getname() + " else\n" + $7->getname(), "stmt");
    }
    | WHILE LPAREN expression RPAREN statement
    {
        $$ = new symbol_info("while(...)\n" + $5->getname(), "stmt");
    }
    | PRINTLN LPAREN ID RPAREN SEMICOLON
    {
        $$ = new symbol_info("println(" + $3->getname() + ");", "stmt");
    }
    | RETURN expression SEMICOLON
    {
        $$ = new symbol_info("return " + $2->getname() + ";", "stmt");
    }
    ;

expression_statement : SEMICOLON
    {
        $$ = new symbol_info(";", "expr_stmt");
    }
    | expression SEMICOLON
    {
        $$ = new symbol_info($1->getname() + ";", "expr_stmt");
    }
    ;

expression : logic_expression
    | variable ASSIGNOP logic_expression
    {
        $$ = new symbol_info($1->getname() + "=" + $3->getname(), "expr");
    }
    ;

variable : ID
    {
        $$ = $1;
    }
    ;

logic_expression : rel_expression
    | rel_expression LOGICOP rel_expression
    {
        $$ = new symbol_info($1->getname() + " && " + $3->getname(), "logic_expr");
    }
    ;

rel_expression : simple_expression
    | simple_expression RELOP simple_expression
    {
        $$ = new symbol_info($1->getname() + " <relop> " + $3->getname(), "rel_expr");
    }
    ;

simple_expression : term
    | simple_expression ADDOP term
    {
        $$ = new symbol_info($1->getname() + "+" + $3->getname(), "simple_expr");
    }
    ;

term : term MULOP unary_expression
    {
        $$ = new symbol_info($1->getname() + "*" + $3->getname(), "term");
    }
    | unary_expression
    {
        $$ = $1;
    }
    ;

unary_expression : ADDOP unary_expression
    {
        $$ = new symbol_info("+" + $2->getname(), "unary_expr");
    }
    | factor
    {
        $$ = $1;
    }
    ;

factor : variable
    | CONST_INT
    {
        $$ = $1;
    }
    | CONST_FLOAT
    {
        $$ = $1;
    }
    | LPAREN expression RPAREN
    {
        $$ = new symbol_info("(" + $2->getname() + ")", "factor");
    }
    ;

%%

int main(int argc, char *argv[])
{
    if(argc != 2)
    {
        cout << "Usage: ./parser <input-file>\n";
        return 1;
    }

    yyin = fopen(argv[1], "r");
    outlog.open("my_log.txt", ios::trunc);

    if(!yyin)
    {
        cerr << "Cannot open input file." << endl;
        return 1;
    }

    lines = 1;
    yyparse();

    outlog << "Total lines: " << lines << endl;
    outlog.close();
    fclose(yyin);

    return 0;
}
