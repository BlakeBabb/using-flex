/////////////////////////////////////////////////
// prologue
/////////////////////////////////////////////////

// C code that is copied verbatim to the top of the scanner C code
%{
#include <stdio.h>

// prototype for functions at epilogue
void foo();
%}

// set directives to control the scanner

// provides access to line number
%option yylineno
// set to single file mode
%option noyywrap

/////////////////////////////////////////////////
// syntax
/////////////////////////////////////////////////

// rules for defining syntax
// two parts:
//   rule for finding a lexene
//   action associated with rule (C code)
// precidence is ordered from first to last
%%

// just match the character 'c'
c { /* action associated with 'c' */ }

// matches 'cat'
cat { /* action for 'cat' */ }

// matches 'cat' or 'dog', concatination has higher precidence
cat|dog {
    foo();

    // 'yytext' refers to the string matched
    printf("Recognized: %s\n", yytext);
}

// matches c, any number of a's, and t
ca*t {
    // 'yyleng' refers to the size of the matched string
    printf("Captured %d characters\n", yyleng);
}

// matches c, one or more a's, and t
ca+t { /* action */ }

// matches 'cat' or 'ct'
ca?t { /* action */ }

// matches c and t around any character
c.t { /* action */ }

// matches c and t around any number of any character (same or different)
c.*t { /* action */ }

// matches newline
\n { }

// matches tab
\t { }

// matches '.'
\. { }

// a character class is a set of characters between square braces
// matches 'c', 'a' or 't'
[cat] { }

// matches any lowercase character
[a-z] { }

// matches any uppercase character
[A-Z] { }

// matches any digit
[0-9] { }

// matches any alphanumeric character
[a-zA-Z0-9] { }

// any character except 'c', 'a' or 't'
// (^ inside [])
[^cat] { }

// any number of alphanumeric characters
[a-zA-Z0-9]* { }

// 'cat' only at the beginning of a line
// (^ outside [])
^cat { }

// 'cat' only at the end of a line
// the \n after will not be considered part of the lexene
// works with unix and windows line endings
cat$ { }

// matches '.^$?'
".^$?" { }

// any number of 'cat'
(cat)* { }

// action at end of file
<<EOF>> {
    // required if we capture <<EOF>>
    yyterminate();
}

// handle invalid characters
// lowest precidence
. {
    // 'yylineno' represents the line number of the string, if enabled
    fprintf(stderr, "Invalid character on line %d: %s\n", yylineno, yytext);

    // terminates the scanner
    yyterminate();
}

%%

/////////////////////////////////////////////////
// epilogue
/////////////////////////////////////////////////
// this is copied to the bottom of the scanner specification
// C code is the only thing that can be put here, so %{%} not necessary

// this allows us to directly execute the file
int main() {
    // invoke scanner
    // processed from stdin
    yylex();
}

void foo() {
    printf("bar\n");
}
