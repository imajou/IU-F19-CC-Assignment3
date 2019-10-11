%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;

    #define YYDEBUG 1

    void yyerror(const char* s);
%}

%debug

%union {
    char* string;
}

// Identifiers & numbers
%token <string> IDENTIFIER
%token NUMBER

// Keywords
%token IMPORT
%token CLASS
%token EXTENDS
%token PRIVATE
%token PUBLIC
%token STATIC
%token VOID
%token IF
%token ELSE
%token WHILE
%token LOOP
%token RETURN
%token PRINT
%token NIL
%token NEW
%token INT
%token REAL
// Delimiters

%token LBRACE      //  {
%token RBRACE      //  }
%token LPAREN      //  (
%token RPAREN      //  )
%token LBRACKET    //  [
%token RBRACKET    //  ]
%token COMMA       //  ,
%token DOT         //  .
%token SEMICOLON   //  ;

// Operator signs
%token ASSIGN      //  =
%token LESS        //  <
%token GREATER     //  >
%token EQUAL       //  ==
%token NOT_EQUAL   //  !=
%token PLUS        //  +
%token MINUS       //  -
%token MULTIPLY    //  *
%token DIVIDE      //  /

%start CompilationUnit

%%
CompilationUnit
       : Imports ClassDeclarations { printf("CompilationUnit\n"); }
       ;

Imports
       :  /* empty */
       | Import Imports { printf("Imports\n"); }
       ;

Import
       : IMPORT IDENTIFIER SEMICOLON { printf("Import\n"); }
       ;

ClassDeclarations
       : /* empty */
       | ClassDeclaration ClassDeclarations { printf("ClassDeclarations\n"); }
       ;

ClassDeclaration
       :        CLASS CompoundName Extension SEMICOLON ClassBody { printf("ClassDeclaration\n"); }
       | PUBLIC CLASS CompoundName Extension SEMICOLON ClassBody { printf("ClassDeclaration(PUBLIC)\n"); }
       ;

Extension
       : /* empty */
       | EXTENDS IDENTIFIER { printf("Extension\n"); }
       ;

ClassBody
       : LBRACE              RBRACE { printf("ClassBody(EMPTY)\n"); }
       | LBRACE ClassMembers RBRACE { printf("ClassBody\n"); }
       ;

ClassMembers
       :              ClassMember { printf("ClassMember\n"); }
       | ClassMembers ClassMember
       ;

ClassMember
       : FieldDeclaration   { printf("FieldDeclaration\n"); }
       | MethodDeclaration  { printf("MethodDeclaration\n"); }
       ;

FieldDeclaration
       : Visibility Staticness Type IDENTIFIER SEMICOLON { printf("FieldDeclaration\n"); }
       ;

Visibility
       : /* empty */
       | PRIVATE    { printf("Visibility(PRIVATE)\n"); }
       | PUBLIC     { printf("Visibility(PUBLIC)\n"); }
       ;

Staticness
       : /* empty */
       | STATIC { printf("Staticness\n"); }
       ;

MethodDeclaration
       : Visibility Staticness MethodType IDENTIFIER Parameters Body { printf("MethodDeclaration\n"); }
       ;

Parameters
       : LPAREN               RPAREN { printf("Parameters(EMPTY)\n"); }
       | LPAREN ParameterList RPAREN { printf("Parameters\n"); }
       ;

ParameterList
       :                     Parameter { printf("ParameterList\n"); }
       | ParameterList COMMA Parameter
       ;

Parameter
       : Type IDENTIFIER { printf("Parameter\n"); }
       ;

MethodType
       : Type { printf("MethodType\n"); }
       | VOID { printf("MethodType(VOID)\n"); }
       ;

Body
       : LBRACE LocalDeclarations Statements RBRACE { printf("Body\n"); }
       ;

LocalDeclarations
       :                   LocalDeclaration { printf("LocalDeclarations\n"); }
       | LocalDeclarations LocalDeclaration
       ;

LocalDeclaration
       : Type IDENTIFIER SEMICOLON { printf("LocalDeclaration\n"); }
       ;

Statements
       :            Statement { printf("Statements\n"); }
       | Statements Statement
       ;

Statement
       : Assignment         { printf("Statement(Assignment)\n"); }
       | IfStatement        { printf("Statement(IfStatement)\n"); }
       | WhileStatement     { printf("Statement(WhileStatement)\n"); }
       | ReturnStatement    { printf("Statement(ReturnStatement)\n"); }
       | CallStatement      { printf("Statement(CallStatement)\n"); }
       | PrintStatement     { printf("Statement(PrintStatement)\n"); }
       | Block              { printf("Statement(Block)\n"); }
       ;

Assignment
       : LeftPart ASSIGN Expression SEMICOLON { printf("Assignment\n"); }
       ;

LeftPart
       : CompoundName                               { printf("LeftPart\n"); }
       | CompoundName LBRACKET Expression RBRACKET  { printf("LeftPart\n"); }
       ;

CompoundName
       :                  IDENTIFIER { printf("CompoundName\n"); }
       | CompoundName DOT IDENTIFIER
       ;

IfStatement
       : IF LPAREN Relation RPAREN Statement                { printf("IfStatement\n"); }
       | IF LPAREN Relation RPAREN Statement ELSE Statement { printf("IfStatement(ELSE)\n"); }
       ;

WhileStatement
       : WHILE Relation LOOP Statement SEMICOLON { printf("WhileStatement\n"); }
       ;

ReturnStatement
       : RETURN            SEMICOLON { printf("ReturnStatement\n"); }
       | RETURN Expression SEMICOLON { printf("ReturnStatement(Expression)\n"); }
       ;

CallStatement
       : CompoundName LPAREN              RPAREN SEMICOLON { printf("CallStatement\n"); }
       | CompoundName LPAREN ArgumentList RPAREN SEMICOLON { printf("CallStatement(ArgumentList)\n"); }
       ;

ArgumentList
       :                    Expression { printf("ArgumentList\n"); }
       | ArgumentList COMMA Expression
       ;

PrintStatement
       : PRINT Expression SEMICOLON { printf("PrintStatement\n"); }
       ;

Block
       : LBRACE            RBRACE { printf("Block(EMPTY)\n"); }
       | LBRACE Statements RBRACE { printf("Block\n"); }
       ;

Relation
       : Expression { printf("Relation(SINGLE)\n"); }
       | Expression RelationalOperator Expression { printf("Relation\n"); }
       ;

RelationalOperator
       : LESS       { printf("RelationalOperator(LESS)\n"); }
       | GREATER    { printf("RelationalOperator(GREATER)\n"); }
       | EQUAL      { printf("RelationalOperator(EQUAL)\n"); }
       | NOT_EQUAL  { printf("RelationalOperator(NOT_EQUAL)\n"); }
       ;

Expression
       :         Term Terms { printf("Expression\n"); }
       | AddSign Term Terms { printf("Expression(AddSign)\n"); }
       ;

AddSign
       : PLUS   { printf("AddSign(PLUS)\n"); }
       | MINUS  { printf("AddSign(MINUS)\n"); }
       ;

Terms
       : /* empty */        { printf("Terms(EMPTY)\n"); }
       | AddSign Term Terms { printf("Terms\n"); }
       ;

Term
       : Factor Factors { printf("Term\n"); }
       ;

Factors
       : /* empty */                { printf("Factors(EMPTY)\n"); }
       | MultSign Factor Factors    { printf("Factors\n"); }
       ;

MultSign
       : MULTIPLY   { printf("MultSign(MULTIPLY)\n"); }
       | DIVIDE     { printf("MultSign(DIVIDE)\n"); }
       ;

Factor
       : NUMBER         { printf("Factor(NUMBER)\n"); }
       | LeftPart       { printf("Factor(LeftPart)\n"); }
       | NIL            { printf("Factor(NIL)\n"); }
       | NEW NewType    { printf("Factor(DAMN)\n"); }
       | NEW NewType LBRACKET Expression RBRACKET { printf("Factor(GODDAMN)\n"); }
       ;

NewType
       : INT        { printf("NewType(INT)\n"); }
       | REAL       { printf("NewType(REAL)\n"); }
       | IDENTIFIER { printf("NewType(IDENTIFIER)\n"); }
       ;

Type
       : INT        ArrayTail { printf("Type(INT)\n"); }
       | REAL       ArrayTail { printf("Type(REAL)\n"); }
       | IDENTIFIER ArrayTail { printf("Type(IDENTIFIER)\n"); }
       ;

ArrayTail
       : /* empty */        { printf("ArrayTail(EMPTY)\n"); }
       | LBRACKET RBRACKET  { printf("ArrayTail\n"); }
       ;

%%

int main() {
    yyin = fopen("program.toy", "r" );
    yyparse();
    return 0;
}

void yyerror(char const *s)
{
	fflush(stdout);
	printf("%s\n", s);
}
