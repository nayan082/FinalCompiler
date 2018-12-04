/* C Declarations */


s_char [a-z]
c_char [A-Z]
digit [0-9]
sp [" "]
operator [!+|*|/|=|;|:|-]

vint "_int"
vstring "_string"
vfloat "_float"
vchar "_char"
void "_void"

iff "_if"
elsee "_else"
elsif "_elsif"

whilee "_while"
forr "_for"
switch "_switch"
case "_case"
default "_default"

/**** operator ***/

gt "_gt"
lt "_lt"
assign "_eq"
ge "_ge"
le "_le"
ee "_ee"

print "_pr"
thenn "_then"
lcb "_lcb"
rcb "_rcb"
main "_main"
lp "_lp"
rp "_rp"

break "_break"

add "_add"
sub "_sub"
mult "_mult"
div "_div"

ae "_ae"
se "_se"
me "_me"
de "_de"
ne "_ne"

aa "_aa"
ss "_ss"

andd "_and"
orr "_or"
nott "_not"


%{
	#include<stdio.h>
	#include<string.h>
	#include "task.tab.h"
	#include<stdlib.h>
	extern int yylval;
	char str[100];
	char multichar[100][100];
	int i,cnt=0;
%}

/*-------------------------------------RE and Action------------------------------------------------*/

%%

{vint}		{ return INT; }
{vfloat}	{ return FLOAT; }
{vchar}		{ return CHAR; }

{digit}+	{ 
				yylval = atoi(yytext);
				return NUM;
			}
		

{lp}		{ return LP; }
{rp}		{ return RP; }
{lcb}		{ return LB; }
{rcb}		{ return RB; }
","			{ return CM; }
";"			{ return SM; }
":"			{ return COLON; }
{thenn}		{ return THEN; }

{add}		{ return PLUS; }
{sub}		{ return MINUS; }
{mult}		{ return MULT; }
{div}		{ return DIV; }
{assign}	{ return ASSIGN;  }
{gt}		{ return GT; }
{lt}		{ return LT; }
{ge}		{ return GE; }
{le}		{ return LE; }
{ee}		{ return EE; }
{aa}		{ return AA; }
{forr}		{ return FOR; }
{print}		{ return PR; }
{switch} 	{ return SWITCH; }
{case}		{ return CASE; }
{default} 	{ return DEFAULT; }
{break}		{ return BREAK; }

"\""[a-zA-Z]([ a-z]+|[A-Z]+|[!]+)+"\"" {
				//printf("%s\n",yytext);
				for(i=0;i<yyleng-2;i++) str[i] = yytext[i+1];

				//printf("str %s =  %d\n",str,STR);
				return STR;
			}

[a-z]		{
				yylval = *yytext - 'a';
				//printf("yylval = %d\n",yylval);
				return	VAR;
			}

[a-z][a-z]+ {
				//yylval = atoi(yytext);
				//printf("%s = %d\n",yytext,yylval);
				//for(i=0;i<yyleng;i++) multichar[cnt][i] = yytext[i];
				strcpy(multichar[cnt],yytext);
				//printf("cnt = %d str=%s %s\n",cnt,multichar[cnt],yytext);
				cnt++;

				return VAR1;
			}			

{iff}		{ return IF;		}
{elsif}     { return ELSEIF;	}
{elsee}		{ return ELSE;		}

{void}{sp}{main}	{ return VOIDMAIN; }

[ \t\n]*	;

"//"(.)*"\n" { printf("This is a comment\n");}

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	printf("\n*****************This is My Compiler..!!********************\n\n");
	yyin = freopen("a.txt","r",stdin);
	//yyout = freopen("out.txt","w",stdout);
	yyparse();
}

