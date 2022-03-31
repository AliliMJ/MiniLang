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
     left_ar = 258,
     right_ar = 259,
     fw_slash = 260,
     excl = 261,
     col = 262,
     left_par = 263,
     right_par = 264,
     left_bracket = 265,
     right_bracket = 266,
     bar = 267,
     eq = 268,
     semi_col = 269,
     plus = 270,
     dash = 271,
     asterisk = 272,
     comma = 273,
     t_int = 274,
     t_float = 275,
     t_boolean = 276,
     t_char = 277,
     t_string = 278,
     _true = 279,
     _false = 280,
     string = 281,
     docprogram = 282,
     as = 283,
     array = 284,
     sub = 285,
     body = 286,
     variable = 287,
     _const = 288,
     aff = 289,
     _input = 290,
     _output = 291,
     and = 292,
     or = 293,
     not = 294,
     sup = 295,
     inf = 296,
     supe = 297,
     infe = 298,
     ega = 299,
     dif = 300,
     _if = 301,
     _then = 302,
     _else = 303,
     _do = 304,
     _while = 305,
     _for = 306,
     _until = 307,
     idf = 308
   };
#endif
/* Tokens.  */
#define left_ar 258
#define right_ar 259
#define fw_slash 260
#define excl 261
#define col 262
#define left_par 263
#define right_par 264
#define left_bracket 265
#define right_bracket 266
#define bar 267
#define eq 268
#define semi_col 269
#define plus 270
#define dash 271
#define asterisk 272
#define comma 273
#define t_int 274
#define t_float 275
#define t_boolean 276
#define t_char 277
#define t_string 278
#define _true 279
#define _false 280
#define string 281
#define docprogram 282
#define as 283
#define array 284
#define sub 285
#define body 286
#define variable 287
#define _const 288
#define aff 289
#define _input 290
#define _output 291
#define and 292
#define or 293
#define not 294
#define sup 295
#define inf 296
#define supe 297
#define infe 298
#define ega 299
#define dif 300
#define _if 301
#define _then 302
#define _else 303
#define _do 304
#define _while 305
#define _for 306
#define _until 307
#define idf 308




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

