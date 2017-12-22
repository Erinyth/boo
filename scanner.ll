%{

#include "scanner.hh"
#include <cstdlib>

#define YY_NO_UNISTD_H

using token = yy::Parser::token;

#undef  YY_DECL
#define YY_DECL int Scanner::yylex( yy::Parser::semantic_type * const lval, yy::Parser::location_type *loc )

/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

%}

%option c++
%option yyclass="Scanner"
%option noyywrap

%%

%{
    yylval = lval;
%}


"+" 	return '+';
"-" 	return '-';
"*" 	return '*';
"/" 	return '/';
"%" 	return '%';
"(" 	return '(';
")" 	return ')';
";" 	return ';';
"," 	return ',';
"++" 	return token::INC;
"--"	return token::DEC;

var 	return token::CREA;
"||" 	return token::OU;
"==" 	return token::EQ;
"!=" 	return token::DIFF;
">=" 	return token::GE;
"<=" 	return token::LE;
"&&"	return token::ET;
"!" 	return '!';
"="	return '=';
">" 	return '>';
"<" 	return '<';
"{" 	return '{';
"}" 	return '}';

"if" 	return token::IF;
"else"	return token::ELSE;
"while"	return token::WHILE;
"for"	return token::FOR;
"print"	return token::PRINT;
"fun"	return token::FONCTION;

[0-9]+      {
    yylval->build<int>(std::atoi(yytext));
    return token::NUM;
}



[a-zA-Z][a-zA-Z0-9_]*	{
	yylval->build<std::string>(yytext);
	return token::IDENT;
}



"\n"          {
    loc->lines();
}






.           {}

%%
