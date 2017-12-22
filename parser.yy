%skeleton "lalr1.cc"
%require "3.0"

%defines
%define parser_class_name { Parser }
%define api.value.type variant
%define parse.assert

%locations

%code requires{
    class Scanner;
    class Driver;
}

%parse-param { Scanner &scanner }
%parse-param { Driver &driver }

%code{
    #include <iostream>
    
    #include "scanner.hh"
    #include "driver.hh"
    #include "hierarchie.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  ENDF 0 "end of file"
%token <int>            NUM

%token                  ET
%token                  OU
%token                  EQ
%token                  GE
%token                  DIFF
%token                  LE
%token					INC
%token					DEC
%token					PRINT

%token					CREA
%token	<std::string>	IDENT
%token					IF
%token					ELSE
%token					WHILE
%token					FOR
%token					FONCTION
%token	<std::string>	CHAINE

%type   <int>         expression
%type   <std::string>   instruction
%type   <std::string>   blocinstructions
%type	<std::string>	instructionassignation	
%type	<std::string>	instructioncontrole
%type	<int>		instructionincrementation
				
%left			'<' '>' EQ LE GE OU ET DIFF
%left                   '+' '-'
%left                   '*' '/'
%left			'%'

%right			ELSE ')' //le dernier caractère avant le else est la parenthèse, donc voila :)

%right			'!'

%precedence             NEG

%precedence		INC
%precedence		DEC

%%

program:
    | fonctions {
        std::cout << "Fin du fichier\n";
    }

fonctions:
	FONCTION IDENT '(' parametres ')' blocinstructions	{
		std::cout << "Création de fonction trouvée" << std::endl;
	}
	| fonctions FONCTION IDENT '(' parametres ')' blocinstructions	{
		std::cout << "Suite de créations de  fonctions trouvées" << std::endl;
	}
	
parametres:
		{
		std::cout << "Pas de paramètres" << std::endl;
	}
	| expression	{
		std::cout << "Un paramètre" << std::endl;
	}
	| expression ',' parametres {
		std::cout << "Plusieurs paramètres" << std::endl;
	
	}

blocinstructions:
	instruction {
		std::cout << "Instruction seule" << std::endl;
	}
	| '{' instructions '}' {
		std::cout << "Bloc d'instructions" << std::endl;
	}

instructions:
     instructions instruction {
        //std::cout << $3 << std::endl;
        std::cout << "Instructions suivie de instruction" << std::endl;
    }
    | instruction {
    	//std::cout << $1 << std::endl;
    	std::cout << "Instruction" << std::endl;
    }



instruction:
	instructionassignation ';' {
		std::cout << "Assignation trouvée" << std::endl;
	}
	| instructioncontrole{
		std::cout << "Contrôle trouvé" << std::endl;
	}
	| instructionincrementation ';'{
		std::cout << "Incrementation trouvée" << std::endl;
	}
	| expression ';' {
		//on prendra la valeur de retour"
		std::cout << "expression trouvée" << std::endl;
	}
	| ';'	{
		std::cout << "Instruction vide" << std::endl;
	}
	| PRINT	'(' instructionincrementation ')' ';' {
		//std::cout << "Print d'une instruction trouvé" << std::endl;
		std::cout << $3 << std::endl;
	}
	| PRINT	'(' expression ')' ';' {
		//std::cout << "Print d'une expression trouvé" << std::endl;
		std::cout << $3 << std::endl;
	}
	
	

instructionassignation:
	//var x = 0
	CREA IDENT '=' expression 	{	//OK MAIS IL FAUT OBLIGER L'INITIALISATION	==> A REVOIR
		driver.setSuperInt($2, $4);
        $$ = $2;	
		//std::cout << "Valeur de " << $2 << ": " << $4 << std::endl;
	}
	//var x;
	| CREA IDENT 	{	
		$$ = $2;	//on renvoie l'identifiant non initialisé (mais en fait non on le met a 0)
		
	}
	//x=0;
	| IDENT '=' expression 	{	//A REVOIR
		std::cout << "Ident = expression" << std::endl;
		if (!driver.present($1))	
		{
 		    driver.setSuperInt($1, $3);
			$$ = $1;
		}
		else
		{
		    throw DriverError("La variable n'a pas été initialisée");
		}
	}
	
	
instructionincrementation:
	//x++;
	IDENT INC 	%prec INC{	
		//std::cout << "Ident ++" << std::endl;
		//$$ = driver.getSuperInt($1);
		//driver.setSuperInt($1, driver.getSuperInt($1)+1);
		
		//on doit créer une incrementation (donc appel au constructeur)
		//qui ne sera appelé qu'ensuite
	}
	//x--;
	| IDENT DEC 	%prec DEC{
		//std::cout << "Ident --" << std::endl;
		//$$ = driver.getSuperInt($1);
		//driver.setSuperInt($1, driver.getSuperInt($1)-1);
		
	}
	//++x;
	| INC IDENT 	{
		//std::cout << "++Ident" << std::endl;
		//driver.setSuperInt($2, driver.getSuperInt($2)+1);
		//$$ = driver.getSuperInt($2);
	}
	//--X;
	| DEC IDENT	{
		//std::cout << "--Ident" << std::endl;
		//driver.setSuperInt($2, driver.getSuperInt($2)-1);
		//$$ = driver.getSuperInt($2);
	}
	
instructioncontrole:
	// if (condition) code else code		AIDE
	IF '(' expression ')' blocinstructions ELSE blocinstructions {
		std::cout << "If Then Else" << std::endl;
		
		
		
	}
	// if (condition) code
	| IF '(' expression ')' blocinstructions {		//AIDE
		std::cout << "If Then" << std::endl;
		
		
		
	}		
	// while (condition) blocinstruction
	| WHILE '(' expression ')' blocinstructions {	//AIDE
		std::cout << "While" << std::endl;
		
		
	}
	// for (init, condition, inc) code
	| FOR '(' instructionassignation ';' expression ';' instructionassignation  ')' blocinstructions {
		std::cout << "For init;expr;i++" << std::endl;
	}

	
	
expression:
      NUM        {		//OK
        // std::cout << "Num. trouvé: ";
        $$ = $1;
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | IDENT	{		//OK
	  //std::cout << "Identifiant" << std::endl;
		$$ = driver.getSuperInt($1);
		
    }  
	| IDENT '(' parametres ')' {
		//std::cout << "Fonction appelée trouvée" << std::endl;
	}
    | '(' expression ')' {	//OK
		$$ = $2;
        //std::cout << "Parenthèsage trouvé: (";
		//std::cout << $$;
		//std::cout << ")" << std::endl;
    }
    | '-' expression %prec NEG {	//OK
        $$ = -$2;
       // std::cout << "Négation trouvée: ";
		//std::cout << $$;
		//std::cout << std::endl;
    }
    | expression '+' expression {	//OK
        //std::cout << "Somme trouvée: ";
        $$ = $1 + $3;
        //std::cout << $$;
        //std::cout << std::endl;
    }
    | expression '-' expression {	//OK
        // std::cout << "Soustraction trouvée: ";
        $$ = $1 - $3;
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression '*' expression {	//OK
        // std::cout << "Multiplication trouvée: ";
        $$ = $1 * $3;
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression '/' expression {	//OK
         // std::cout << "Division trouvée: ";
         $$ = $1 / $3;
         // std::cout << $$;
         // std::cout << std::endl;
    }
    | expression '%' expression {	//OK
        // std::cout << "Modulo trouvé: ";
        $$ = $1 % $3;
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression '<' expression {	//OK
        // std::cout << "Inf. strict trouvé: ";
        $$ = $1 < $3;	//1 si vrai
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression '>' expression {	//OK
        //std::cout << "Sup. strict trouvé: ";
        $$ = $1>$3; //1 si vrai
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | '!' expression {		//OK
        // std::cout << "Différence trouvée: ";
       	$$ = !$2; //retourne l'inverse
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression ET expression {	//OK
        // std::cout << "Expression ET trouvée: ";
        if (($1==1) && ($3==1)) //1 si vrai deux vrai, faux sinon
        	{$$ = 1;}
        else
        	{$$ = 0;}
		// std::cout << $$;
		//std::cout << std::endl;
    }
    | expression OU expression {	//OK
        // std::cout << "Expression OU trouvée: ";
        if ($1||$3) //1 si vrai un ou deux vrai, faux sinon
        	{$$ = 1;}
        else
        	{$$ = 0;}
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression EQ expression {	//OK
        // std::cout << "Test d'égalité trouvé: ";
        $$ = ($1==$3); //1 si vrai
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression GE expression {	//OK
        // std::cout << "Sup. ou égal trouvé: ";
        $$ = ($1>=$3); //1 si vrai
        // std::cout << $$;
        // std::cout << std::endl;
    }
    | expression LE expression {	//OK
        // std::cout << "Inf. ou égal trouvé: ";  
        $$ = ($1<=$3); //1 si vrai 
        // std::cout << $$;
        // std::cout << std::endl;     
    }
    | expression DIFF expression {	//OK
        // std::cout << "Test différence trouvé: "; 
        $$ = ($1!=$3); //1 si vrai 
        // std::cout << $$;
        // std::cout << std::endl;     
    }
   
    
%%

void yy::Parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
