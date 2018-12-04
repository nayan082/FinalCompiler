/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
	int dummy=3,di,dj;
	int forswitchcase=5,c=1,f=0;
	int forifelse = 1,flagforstrd=0,flagforvald=0,forifelseinner = 1;
	int fvalue,flagforval=0,flagforstr=0,priorityval=0,prioritystr=0,priority=0;
	int switchstack[100], check[100],check2[100],checkstr[100],ll=0,l=0,flag=1,val,i,j,count=0;
	char switchstackstr[100][100],finsidestr[100];

	extern char str[100];
	extern char multichar[100][100];
	int m=0,flagformulti=0,indx=0,t=1,single=0,multi=0;
	extern int cnt;
	//extern char *yytext;
	//extern int yyleng;
	
	void strclean(){
		for(i=0;str[i]!='\0';i++)str[i]='\0';
	}
	
	void clearmultichar(int cnt)
	{
		for(di=0; multichar[cnt-1][di]!='\0'; di++) multichar[cnt-1][di] = '\0';
	}
	
	void redeclarecheck(int cnt)
	{
		for(i=0; i<cnt-1; i++)  //when cnt > 1
		{	
			if(!strcmp(multichar[cnt-1],multichar[i]))
			{
				printf("variable '%s' is Redeclared\n",multichar[i]);
				t=0;
				clearmultichar(cnt);
				cnt--;
			}
		}
	}
	
	int undeclaredcheck(int c)
	{	
		flagformulti=0;
		//printf("Start Undeclared Func\n");
		for(i=0; i<c-1; i++)
		{
			//printf("%s\n",multichar[i]);
			if(!strcmp(multichar[c-1],multichar[i]))
			{
				//printf("%s\n",multichar[c-1]);
				flagformulti = 1;
			}
		}
		//printf("flagformulti = %d\n",flagformulti);
		if(!flagformulti)
		{
			printf("variable '%s' is Undeclared\n",multichar[c-1]);
			
			clearmultichar(c);
			c=c-1;
			//printf("inside %d\n",c);
			
			return 1;
		}
		
		return 0;
	}
	
	void printfunc(int flagforstr,int flagforval,int prioritystr,int priorityval){
		if(flagforstr && flagforval && prioritystr < priorityval)
		{
			printf("Prininting statement : %s\n",finsidestr);
			printf("Prininting value     : %c = %d\n",fvalue+'a',sym[fvalue]);
		}
		else if(flagforstr && flagforval && prioritystr > priorityval)
		{
			printf("Prininting value     : %c = %d\n",fvalue+'a',sym[fvalue]);
			printf("Prininting statement : %s\n",finsidestr);
		}
		else{
			if(flagforval)printf("Prininting value     : %c = %d\n",fvalue+'a',sym[fvalue]);
			if(flagforstr)printf("Prininting statement : %s\n",finsidestr);
		}
	}
	
	void printfunc2(int flagforstr,int flagforval,int prioritystr,int priorityval){
		if(flagforstr && flagforval && prioritystr < priorityval)
		{
			printf("Prininting statement : %s\n",finsidestr);
			printf("Prininting value     : %s = %d\n",multichar[checkindex(cnt)],multichar[checkindex(cnt)][99]);
		}
		else if(flagforstr && flagforval && prioritystr > priorityval)
		{
			printf("Prininting value     : %s = %d\n",multichar[checkindex(cnt)],multichar[checkindex(cnt)][99]);
			printf("Prininting statement : %s\n",finsidestr);
		}
		else{
			if(flagforval)printf("Prininting value     : %s = %d\n",multichar[checkindex(cnt)],multichar[checkindex(cnt)][99]);
			if(flagforstr)printf("Prininting statement : %s\n",finsidestr);
		}
	}
	
	int checkindex(int cnt){
		for(i=0; i<cnt-1; i++)
		{	
			if(!strcmp(multichar[cnt-1],multichar[i]))
			{
				return i;
			}
		}
	}
	
%}

/* BISON Declarations */

%token NUM AA FOR VAR VAR1 COLON BREAK DEFAULT CASE THEN IF ELSE ELSEIF SWITCH VOIDMAIN INT STR FLOAT CHAR LP RP LB RB CM SM PR PLUS MINUS MULT DIV ASSIGN GT LT GE LE EE
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left VAR

	
/* Simple grammar rules */

%%

program		: VOIDMAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
			;

cstatement	: /* empty */
			| cstatement statement
			| cstatement cdeclaration
			| cstatement structure
			;
	
cdeclaration: TYPE varlist SM			{ printf("valid declaration\n\n"); }
			;
			
TYPE 		: INT | FLOAT | CHAR ;
				
varlist 	: vassign CM varlist | vassign ;
			
vassign		: VAR					{
										if(store[$1] == 1) printf("variable '%c' Redeclared!!!\n",$1+'a');
										else
										{
											store[$1]=1;
											printf("%c (declaration)\n",$1+'a');
										}	
									}
									
			| VAR1					{	
										int v = 1;
										for(i=0; i<cnt-1; i++)
										{	
											if(!strcmp(multichar[cnt-1],multichar[i]))
											{
												printf("variable '%s' is Redeclared\n",multichar[i]);
												clearmultichar(cnt);
												cnt--;
												v=0;
											}
										}
										if(v)printf("%s (declaration)\n",multichar[cnt-1]);
									}
									
			| VAR1 ASSIGN NUM 		{
										t=1;
										redeclarecheck(cnt);
				
										if(t){
											char c = (char) $3;
											multichar[cnt-1][99]=c;
											int i = (int) c;
											//printf("if c = %c\n",c);
											
											//printf("%d\n",$3);
											printf("%s = %d (declaration && assignment)\n",multichar[cnt-1],multichar[cnt-1][99]);
										}
									}						
									
									
			| VAR ASSIGN NUM 		{ 	
										if(store[$1] == 1) printf("variable '%c' Redeclared\n",$1+'a');
										else store[$1]=1;
										sym[$1] = $3; 
										//printf("%d\n",$1);
										//if(store[$1]!=1)printf("'%c' is undeclared",$1+'a');
										printf("%c = %d (declaration && assignment)\n",$1+'a',$3);
									}
			;
			
structure  	: IF VAR operator NUM THEN COLON LB finsidelist RB	{	
																	if(store[$2]!=1)printf("Undeclared character : %c\n",$2+'a');
																	else{			
																		printf("\nIf Block\n");
																		if( sym[$2] > $4)
																		{
																			printf("Condition True!\n");
																			
																			if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																			if(multi)printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																			
																			forifelse = 0;
																		}
																		else
																		{
																			printf("Your 'IF' condition is false!\n");
																			forifelse = 1;
																		}
																		single=multi=0;
																	}
																}
			| ELSEIF VAR operator NUM THEN COLON LB finsidelist RB	{	
																	if(store[$2]!=1)printf("Undeclared character : %c\n",$2+'a');
																	else if(forifelse){			
																		printf("\nElse-if Block\n");
																		if( sym[$2] > $4)
																		{
																			printf("Condition True!\n");
																			
																			if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																			if(multi)printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																			
																			forifelse = 0;
																		}
																		else
																		{
																			printf("Your 'IF' condition is false!\n");
																			forifelse = 1;
																		}
																		single=multi=0;
																	}
																}
																
			| IF VAR1 operator NUM THEN COLON LB finsidelist RB {
																	
																	if(undeclaredcheck(cnt)==0){																				
																		if( !f && multi )indx = checkindex(cnt-1);           
																		else if ( !f && single ) indx = checkindex(cnt);
																		else if ( f && single ) indx = checkindex(cnt-1);    //jodi nested hoy 
																		else if ( f && multi ) indx = checkindex(cnt-2);     // jodi nested hoy
																
																		printf("\nIf Block\n");
																		//printf("f = %d, single = %d, multi = %d\n",f,single,multi);
																	
																		if( multichar[indx][99] > $4 && f ==0 )
																		{
																			printf("Single : 'IF' condition (%s=%d > %d) is True, c= %d!\n",multichar[indx],multichar[indx][99],$4,c);
																	
																			if(f == 0){
																				if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																				if(multi)
																				{
																					printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																					
																					printf("Deleting %s\n",multichar[cnt-1]); 
																					clearmultichar(cnt);
																					cnt--;
																				}
																				single = multi = 0;
																				forifelse = 0;
																			}
																		}
																		else if ( multichar[indx][99] <= $4 && f == 0 )
																		{
																			printf("Single : 'IF' condition (%s=%d > %d)  is false!\n",multichar[indx],multichar[indx][99],$4);
																			forifelse = 1;
																		}
																		
																		if( multichar[indx][99] > $4 && f != 0 )
																		{
																			printf("Outer : 'IF' condition (%s=%d > %d) is True, c=%d\n",multichar[indx],multichar[indx][99],$4,c);
																		
																			if(f == 1){
																				if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																				if(multi)
																				{
																					printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																					
																					printf("Deleting %s\n",multichar[cnt-1]); 
																					clearmultichar(cnt);
																					cnt--;
																				}
																				
																				forifelse = 0;
																			}
																			else if ( f == 2 ){
																				if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																				if(multi)
																				{
																					printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																					
																				}
																			}
																		}
																		else if ( multichar[indx][99] <= $4 && f != 0 )
																		{
																			printf("Outer : 'IF' condition (%s=%d > %d)  is false!\n",multichar[indx],multichar[indx][99],$4);
																			forifelse = 1;
																			
																			if(multi)
																			{
																				printf("Deleting %s\n",multichar[cnt-1]); 
																				clearmultichar(cnt);
																				cnt--;
																			}
																		}
																		printf("Deleting %s\n",multichar[cnt-1]);
																		clearmultichar(cnt);
																		cnt--;
																	}
																}
															
			| ELSE LB finsidelist RB 	{ 	printf("\nOuter Else Block\n");
											if(forifelse)
											{
												printfunc(flagforstr,flagforval,prioritystr,priorityval);
											}
										}
										
			| FOR LP VAR ASSIGN NUM CM VAR LE NUM CM VAR AA RP LB finsidelist RB 	{   
																						printf("\nFor Loop!!\n");
																						if(store[$3]!=1)
																						{
																							printf("Undeclared variable : %c\n",$3+'a');
																						}
																						
																						else
																						{
																							for( sym[$3]=$5; sym[$3] <= $9; sym[$3]++)
																							{
																								if(single)printfunc(flagforstr,flagforval,prioritystr,priorityval);
																								if(multi)printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																							}
																						}
																						flagforstr=flagforval=0;
																						single=multi=0;
																					}
																					
			| FOR LP VAR1 ASSIGN NUM CM VAR1 LE NUM CM VAR1 AA RP LB finsidelist RB {
																						//for(i=0;i<cnt;i++)printf("multi=%d ---> %s\n",i,multichar[i]);
																						
																						//printf("%d\n",cnt);
																						if(undeclaredcheck(cnt)==0){
																							//printf("%s \n",multichar[cnt-1]);
																							
																							indx = checkindex(cnt);
																							printf("\nFor Loop(multi)!!\n");
																							int temp = multichar[indx][99];
																							//printf("%s = %d\n",multichar[indx],indx);
																							for( temp=$5; temp<=$9; temp++)
																							{
																								multichar[indx][99]=temp;
																								if(multi)printfunc2(flagforstr,flagforval,prioritystr,priorityval);
																								else printfunc(flagforstr,flagforval,prioritystr,priorityval);
																								
																							}
																							flagforstr=flagforval=0;
																						}
																						//printf("%d\n",cnt);
																						
																						//printf(" %s -----------> m=%d\n",multichar[cnt-1],cnt-1);
																						clearmultichar(cnt-1);
																						//printf(" %s -----------> m=%d\n",multichar[cnt-2],cnt-2);
																						clearmultichar(cnt-2);
																						cnt = cnt - 3;
																						
																						//printf(" %s -----------> m=%d\n",multichar[cnt],cnt);
																						
																						
																						//for(i=0;i<cnt;i++)printf("multi=%d =====> %s\n",i,multichar[i]);
																						
																						single=multi=0;
																						//printf(" %s -------------> multi=%d\n",multichar[cnt],cnt);
																						f=0;
																					}
			
			| SWITCH LP VAR RP LB sblock RB 		{ 
														printf("\nSwitch case\n"); 
														forswitchcase=sym[$3]; 
														//printf("%d",forswitchcase);
														if(flagforval)
															for( i=0; i<l; i++){
																if(check[i]==forswitchcase){
																	printf("value of %c = %d\n",switchstack[check[i]]+'a',sym[switchstack[check[i]]]);
																	flag=0;
																	break;
																}
															}
														l=0;
														if(flagforstr)
															for( i=0; i<ll; i++){
																if(checkstr[i]==forswitchcase){
																	printf("Your statement is = %s\n",switchstackstr[checkstr[i]]);
																	flag=0;
																	break;
																}
															}
														
														if(flag&&flagforstrd)printf("Default: Your statement = %s\n",switchstackstr[ll]);
														if(flag&&flagforvald)printf("Default: value of %c = %d\n",val+'a',sym[val]);
														ll=0;
													}
			| SWITCH LP VAR1 RP LB sblock RB 		{ 
														printf("\nSwitch case\n"); 
														indx = checkindex(cnt);
														
														//printf("%d %d %d %d\n",flagforval,flagforstr,flagforvald,flagforstrd);
														
														if(flagforval)
															for( i=0; i<l; i++){
																//printf("%d %d\n",check[i],multichar[indx][99]);
																if(check[i]==multichar[indx][99]){
																	printf("value of %c = %d\n",switchstack[check[i]]+'a',sym[switchstack[check[i]]]);
																	flag=0;
																	break;
																}
															}
														l=0;
														if(flagforstr)
															for( i=0; i<ll; i++){
																//printf("%d %d\n",checkstr[i],multichar[indx][99]);
																if(checkstr[i]==multichar[indx][99]){
																	printf("Your statement is = %s\n",switchstackstr[checkstr[i]]);
																	flag=0;
																	break;
																}
															}
														
														if(flag&&flagforstrd)printf("Default: Your statement = %s\n",switchstackstr[ll]);
														if(flag&&flagforvald)printf("Default: value of %c = %d\n",val+'a',sym[val]);
														ll=0;
													}
			
			;
		
			
finsidelist : | fstructure finsidelist 
			| finsidelist finside		
			;
			
fstructure :  IF VAR operator NUM THEN COLON LB finsidelist RB  {
																	
																}
			
			| IF VAR1 operator NUM THEN COLON LB finsidelist RB  {
																	if(single) indx = checkindex(cnt);
																	else indx = checkindex(cnt-1);
																	
																	if( multichar[indx][99] > $4 && f == 0 )
																	{
																		printf("Inner: 'IF' condition (%s=%d > %d) is True, c=%d\n",multichar[indx],multichar[indx][99],$4,c);
																		f=1;
																		forifelseinner = 0;
																	}
																	else{
																		
																		printf("Inner: 'IF' condition (%s=%d > %d) is False, c=%d\n",multichar[indx],multichar[indx][99],$4,c);
																		forifelseinner = 1;
																		if(multi)
																		{
																			printf("Deleting %s\n",multichar[cnt-1]); 
																			clearmultichar(cnt);
																			cnt--;
																		}
																	}
																 }
			| ELSE LB finsidelist RB 	{ 	printf("\nInner Else Block\n");
											if(forifelseinner)
											{
												//printfunc(flagforstr,flagforval,prioritystr,priorityval);
												f=2;
											}
											else{
												if(multi)
												{
													printf("Deleting %s\n",multichar[cnt-1]); 
													clearmultichar(cnt);
													cnt--;
												}
											}
										}
										
			
			;

finside		: PR VAR SM								{ 	
														fvalue=$2; 
														flagforval=1;
														priorityval=++priority;
														single=1;
													}
			| PR VAR1 SM 							{ 	
														//printf("This var = %s\n",multichar[cnt-1]);
														undeclaredcheck(cnt);
														
														fvalue = multichar[checkindex(cnt)][99];
														//printf("%s = %d\n",multichar[checkindex(cnt)],fvalue);
														
														flagforval=1;
														priorityval=++priority;
														multi=1;
														
													}
													
			| PR  STR  SM 							{
														//printf("This is string\n");
														flagforstr=1;
														for(i=0;str[i]!='\0';i++)finsidestr[i]=str[i];
														prioritystr=++priority;
														strclean();
													}
			;			
			
sblock 		: caselist | caselist defaultstm ;

caselist	: casestm | casestm caselist ;

casestm		: CASE NUM COLON PR VAR SM BREAK SM		{ 	
														printf("Case \n");
														switchstack[$2]=$5;
														check[l]=$2;
														//printf("%d %d\n",$2,$5);
														l++;
														//priorityval = ++priority;
														flagforval = 1;
													}
													
			| CASE NUM COLON PR  STR  SM BREAK SM	{
														
														printf("Case \n");
														//printf("string\n");
														//printf("%s\n",str);
														checkstr[ll]=$2;
														for(i=0;str[i]!='\0';i++){
															switchstackstr[checkstr[ll]][i]=str[i];
															//printf("%c = %d \n",str[i],str[i]);
														}
														//printf("%d %s\n",checkstr[ll],switchstackstr[checkstr[ll]]);
														ll++;
														//prioritystr == ++priority;
														flagforstr = 1;
														strclean();
													}
			;
			
defaultstm	: DEFAULT COLON PR VAR SM 				{
														printf("Default \n");
														val=$4;
														flagforvald=1;
													}
			| DEFAULT COLON PR  STR   SM 			{
														
														printf("Default\n");
														flagforstrd=1;
										
														for(i=0;str[i]!='\0';i++)
														{	
															switchstackstr[ll][i]=str[i];
															printf("%c ",switchstackstr[ll][i]);
														}
														printf("%s\n",switchstackstr[ll]);
														strclean();
													}	
			;
			
operator	: GT | LT | EE | LE | GE ;
			

			
statement	: SM
			| expr SM 				{ printf("\nvalue of expression: %d\n", $1); }
			| VAR ASSIGN expr SM 	{
										sym[$1] = $3; 
										//printf("%d\n",$1);
										if(store[$1]!=1)printf("'%c' is Undeclared\n",$1+'a');
										else 
											printf("%c = %d (assignment)\n",$1+'a',$3);
									}
			| VAR1 ASSIGN expr SM 	{
										flagformulti = 0;
										undeclaredcheck(cnt);
										
										for(i=0;i<cnt-1;i++)
										{
											//printf("%s\n",multichar[i]);
											if(!strcmp(multichar[cnt-1],multichar[i]))
											{
												multichar[i][99] =(char)$3;
												printf("%s = %d (assignment)\n",multichar[i],multichar[i][99]);
												
												clearmultichar(cnt);
												cnt--;
											}
										}
										
									}
			| printlist
			;
			
printlist 	: printone | printone printlist;

printone	: PR STR SM 			{
										printf("Prininting statement : %s\n",str);
										strclean();
									}
			| PR VAR SM				{			
										printf("Prininting value : %c = %d\n",$1+'a',sym[$1]);
									}
			| PR VAR1 SM 			{
										indx = checkindex(cnt);
										printf("Prininting value : %s = %d\n",multichar[indx],multichar[indx][99]);
									}
			;
	
expr 		: VAR					{ $$ = sym[$1]; } 
			| VAR1 					{ $$ = multichar[checkindex(cnt)][99];clearmultichar(cnt);cnt--; }
			| expr PLUS term		{ $$ = $1 + $3; }
			| expr MINUS term		{ $$ = $1 - $3; }
										
			| term
			 ;
			 
term 		:
			 term MULT factor		{ $$ = $1 * $3; }
			| term DIV factor		{ 
										if($3) 
										{
												$$ = $1 / $3;
										}
										else
										{
											$$ = 0;
											printf("\ndivision by zero\t");
										}
									}
			| factor 
			
			;
			
factor 		: digit					{ $$ = $1; }
			| LP expr RP				{ $$ = $2; }
			;
			
digit 		: NUM	    			{ $$ = $1; }
			;
			
			
%%

int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

