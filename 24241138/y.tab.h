/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IF = 258,
     ELSE = 259,
     FOR = 260,
     WHILE = 261,
     PRINTLN = 262,
     RETURN = 263,
     INT = 264,
     FLOAT = 265,
     VOID = 266,
     ID = 267,
     CONST_INT = 268,
     CONST_FLOAT = 269,
     ADDOP = 270,
     MULOP = 271,
     ASSIGNOP = 272,
     RELOP = 273,
     LOGICOP = 274,
     SEMICOLON = 275,
     COMMA = 276,
     LPAREN = 277,
     RPAREN = 278,
     LCURL = 279,
     RCURL = 280
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define FOR 260
#define WHILE 261
#define PRINTLN 262
#define RETURN 263
#define INT 264
#define FLOAT 265
#define VOID 266
#define ID 267
#define CONST_INT 268
#define CONST_FLOAT 269
#define ADDOP 270
#define MULOP 271
#define ASSIGNOP 272
#define RELOP 273
#define LOGICOP 274
#define SEMICOLON 275
#define COMMA 276
#define LPAREN 277
#define RPAREN 278
#define LCURL 279
#define RCURL 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

