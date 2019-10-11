%option noyywrap

%{
    #include <string.h>
    #include "toy_parser.h"

    int parseIdentifierOrKeyword(char*);
    int parseInteger(char*);
    int parseReal(char*);
%}

digit		[0-9]
letter		[A-Za-z]

%%

[ \n\t]+						        { /* ignore */ }
{digit}+						        { return parseInteger(yytext); }
{digit}+"."{digit}*(E[+-]?{digit}+)?	{ return parseReal(yytext); }
{letter}({digit}|{letter})*		        { return parseIdentifierOrKeyword(yytext); }

"{"								{ return LBRACE; }
"}"								{ return RBRACE; }
"("								{ return LPAREN; }
")"								{ return RPAREN; }
"["								{ return LBRACKET; }
"]"								{ return RBRACKET; }
"."								{ return DOT; }
","								{ return COMMA; }
";"								{ return SEMICOLON; }

"="								{ return ASSIGN; }

">"								{ return GREATER; }
"<"								{ return LESS; }
"=="							{ return EQUAL; }
"!="							{ return NOT_EQUAL; }

"+"								{ return PLUS; }
"-"							    { return MINUS; }
"*"								{ return MULTIPLY; }
"/"							    { return DIVIDE; }



%%

struct Keyword {
    int token;
    char* name;
};

struct Keyword keywords[] = {
    {IMPORT, "IMPORT"},
    {CLASS, "CLASS"},
    {EXTENDS, "EXTENDS"},
    {PRIVATE, "PRIVATE"},
    {PUBLIC, "PUBLIC"},
    {STATIC, "STATIC"},
    {VOID, "VOID"},
    {IF, "IF"},
    {ELSE, "ELSE"},
    {WHILE, "WHILE"},
    {LOOP, "LOOP"},
    {RETURN, "RETURN"},
    {PRINT, "PRINT"},
    {NIL, "NULL"},
    {INT, "INT"},
    {REAL, "REAL"}
};


int parseIdentifierOrKeyword(char* parsed_string) {
    int keywords_num = sizeof(keywords) / sizeof(struct Keyword);
    for (int i = 0; i < keywords_num; i++) {
        if (strcmp(parsed_string, keywords[i].name) == 0) {
            return keywords[i].token;
        }
    }

    yylval.string = (char *)malloc(strlen(parsed_string));
    strcpy(yylval.string, parsed_string);
    return IDENTIFIER;
}

int parseInteger(char* s) {
    return INT;
}

int parseReal(char* s) {
    return REAL;
}

