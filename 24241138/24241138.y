%{
#include "symbol_info.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
extern FILE *yyin;

ofstream outlog;
int lines;

void yyerror(char *s) {
    fprintf(stderr, "Error at line %d: %s\n", lines, s);
    outlog << "Error at line " << lines << ": " << s << endl;
    exit(1);
}
%}

%token IF FOR DO INT FLOAT VOID SWITCH DEFAULT GOTO ELSE WHILE BREAK CHAR DOUBLE RETURN CASE CONTINUE PRINTF ADDOP MULOP INCOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA COLON SEMICOLON CONST_INT CONST_FLOAT ID

%start start

%%

start : program
    {
        outlog << "At line no: " << lines << " Matched rule: start : program\n\n";
    }
    ;

program : program unit
    {
        outlog << "At line no: " << lines << " Matched rule: program : program unit\n\n";
        $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "program");
    }
    | unit
    {
        outlog << "At line no: " << lines << " Matched rule: program : unit\n\n";
        $$ = new symbol_info($1->getname() + "\n", "program");
    }
    ;

unit : var_declaration { $$ = $1; }
     | func_definition { $$ = $1; }
     ;

var_declaration : type_specifier declaration_list SEMICOLON
    {
        outlog << "At line no: " << lines << " Matched rule: var_declaration : type_specifier declaration_list SEMICOLON\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + ";", "var_decl");
    }
    ;

type_specifier : INT    { $$ = new symbol_info("int", "type_specifier"); }
               | FLOAT  { $$ = new symbol_info("float", "type_specifier"); }
               | VOID   { $$ = new symbol_info("void", "type_specifier"); }
               | CHAR   { $$ = new symbol_info("char", "type_specifier"); }
               | DOUBLE { $$ = new symbol_info("double", "type_specifier"); }
               ;

declaration_list : declaration_list COMMA ID
    {
        $$ = new symbol_info($1->getname() + ", " + $3->getname(), "declaration_list");
    }
    | ID { $$ = $1; }
    ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
    {
        outlog << "At line no: " << lines << " Matched rule: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + "(" + $4->getname() + ")\n" + $6->getname(), "func_def");
    }
    | type_specifier ID LPAREN RPAREN compound_statement
    {
        outlog << "At line no: " << lines << " Matched rule: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n";
        $$ = new symbol_info($1->getname() + " " + $2->getname() + "()\n" + $5->getname(), "func_def");
    }
    ;

parameter_list : parameter_list COMMA type_specifier ID
    {
        $$ = new symbol_info($1->getname() + ", " + $3->getname() + " " + $4->getname(), "parameter_list");
    }
    | type_specifier ID
    {
        $$ = new symbol_info($1->getname() + " " + $2->getname(), "parameter_list");
    }
    ;

compound_statement : LCURL statements RCURL
    {
        $$ = new symbol_info("{\n" + $2->getname() + "\n}", "compound_statement");
    }
    | LCURL RCURL
    {
        $$ = new symbol_info("{}", "compound_statement");
    }
    ;

statements : statements statement
    {
        $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "statements");
    }
    | statement { $$ = $1; }
    ;

statement : var_declaration { $$ = $1; }
          | expression_statement { $$ = $1; }
          | compound_statement { $$ = $1; }
          | FOR LPAREN expression_statement expression_statement expression RPAREN statement
          {
              outlog << "At line no: " << lines << " Matched rule: statement : FOR (...) statement\n\n";
              $$ = new symbol_info("for(" + $3->getname() + $4->getname() + $5->getname() + ")\n" + $7->getname(), "for_stmt");
          }
          | IF LPAREN expression RPAREN statement
          {
              $$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname(), "if_stmt");
          }
          | IF LPAREN expression RPAREN statement ELSE statement
          {
              $$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname() + " else\n" + $7->getname(), "if_else_stmt");
          }
          | WHILE LPAREN expression RPAREN statement
          {
              $$ = new symbol_info("while(" + $3->getname() + ")\n" + $5->getname(), "while_stmt");
          }
          | PRINTF LPAREN ID RPAREN SEMICOLON
          {
              $$ = new symbol_info("printf(" + $3->getname() + ");", "printf_stmt");
          }
          | RETURN expression SEMICOLON
          {
              $$ = new symbol_info("return " + $2->getname() + ";", "return_stmt");
          }
          | CONTINUE SEMICOLON
          {
              $$ = new symbol_info("continue;", "continue_stmt");
          }
          | BREAK SEMICOLON
          {
              $$ = new symbol_info("break;", "break_stmt");
          }
          | GOTO ID SEMICOLON
          {
              $$ = new symbol_info("goto " + $2->getname() + ";", "goto_stmt");
          }
          ;

expression_statement : SEMICOLON { $$ = new symbol_info(";", "expr_stmt_empty"); }
                     | expression SEMICOLON { $$ = new symbol_info($1->getname() + ";", "expr_stmt"); }
                     ;

expression : logic_expression { $$ = $1; }
           | variable ASSIGNOP logic_expression
           {
               $$ = new symbol_info($1->getname() + " = " + $3->getname(), "assignment_expr");
           }
           ;

variable : ID { $$ = $1; }
         | ID LTHIRD expression RTHIRD
         {
             $$ = new symbol_info($1->getname() + "[" + $3->getname() + "]", "array_access");
         }
         ;

logic_expression : rel_expression { $$ = $1; }
                 | rel_expression LOGICOP rel_expression
                 {
                     $$ = new symbol_info($1->getname() + " " + $2->getname() + " " + $3->getname(), "logic_expr");
                 }
                 ;

rel_expression : simple_expression { $$ = $1; }
               | simple_expression RELOP simple_expression
               {
                   $$ = new symbol_info($1->getname() + " " + $2->getname() + " " + $3->getname(), "rel_expr");
               }
               ;

simple_expression : term { $$ = $1; }
                  | simple_expression ADDOP term
                  {
                      $$ = new symbol_info($1->getname() + " " + $2->getname() + " " + $3->getname(), "simple_expr");
                  }
                  ;

term : unary_expression { $$ = $1; }
     | term MULOP unary_expression
     {
         $$ = new symbol_info($1->getname() + " " + $2->getname() + " " + $3->getname(), "term_expr");
     }
     ;

unary_expression : ADDOP unary_expression
    {
        $$ = new symbol_info($1->getname() + $2->getname(), "unary_expr");
    }
    | NOT unary_expression
    {
        $$ = new symbol_info("!" + $2->getname(), "not_expr");
    }
    | INCOP variable
    {
        $$ = new symbol_info("++" + $2->getname(), "inc_expr");
    }
    | factor { $$ = $1; }
    ;

factor : variable { $$ = $1; }
       | ID LPAREN RPAREN
       {
           $$ = new symbol_info($1->getname() + "()", "func_call");
       }
       | ID LPAREN expression RPAREN
       {
           $$ = new symbol_info($1->getname() + "(" + $3->getname() + ")", "func_call");
       }
       | CONST_INT { $$ = $1; }
       | CONST_FLOAT { $$ = $1; }
       | LPAREN expression RPAREN
       {
           $$ = new symbol_info("(" + $2->getname() + ")", "paren_expr");
       }
       ;

%%

int main(int argc, char *argv[])
{
    if (argc != 2) {
        cout << "Usage: ./parser <input-file>\n";
        return 1;
    }

    yyin = fopen(argv[1], "r");
    outlog.open("my_log.txt", ios::trunc);

    if (!yyin) {
        cerr << "Error: Cannot open input file '" << argv[1] << "'.\n";
        return 1;
    }

    lines = 1;

    cout << "Parsing started for file: " << argv[1] << endl;
    outlog << "Parsing started for file: " << argv[1] << endl << endl;

    yyparse();

    cout << "\nParsing finished successfully!" << endl;
    outlog << "\nParsing finished successfully!" << endl;
    outlog << "Total lines processed: " << lines << endl;

    outlog.close();
    fclose(yyin);

    return 0;
}
