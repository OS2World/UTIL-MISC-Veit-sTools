This package provides a very simply way to have translated strings in a
compiled pascal program. tested with Virtual Pascal and Borland Pascal 7.

Idea: the application does not use strings, it uses pointers to strings.
During application startup, there is code that evalutes countrycode
and SET LANG= environment variable an chooses from prepares strings to
have the strings that the application uses point to the correct strings.

Usually, the strings and the startup code are compiled into the application.
In this solution, a prepare step processes the strings and outputs include
file that has the strings and pointer definitions.


Included sample files
---------------------

test_ein.pas - prepares the strings.
               compile&run this to produce/refresh the include files
               test$$$.001 and test$$$.002.

test_aus.pas - test 'application'
               it imports from test_auu (all the strings and startup calls)
               and spr2_aus.pas (string format function)

test_auu.pas - includes the include files test$$$.001 and test$$$.002
               that have the pointers and the prepared strings.
               the startup code of this unit calls the spr2_aus unit code
               to set the pointers to the strings.


Codepage translation
--------------------

It is assumed that the strings have correct codepage for the target language.
In case of Linux, is is assumed that the source string codepage is IBM 850,
and the string setup code will silently, automatically translate to ISO-8859-1
'ISO Latin'.


