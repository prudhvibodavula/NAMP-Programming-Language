program(t_program(T)) --> block(T).
block(t_block(X,Y)) --> ['{'],declaration(X), [;], command(Y), ['}'].

% Parse tree node for declaration
declaration(t_declaration(X,Y)) -->declarationbeta(X),[;],declaration(Y).
declaration(t_declarationbeta(X)) --> declarationbeta(X).
declarationbeta(t_constantdeclaration(X,Y)) --> [const], il(X) ,[=] ,number(Y).
declarationbeta(t_identifierdeclaration(X,Y)) --> dataType(X), il(Y).

%parse tree node for data type
dataType(t_integer(interger)) --> [integer].
dataType(t_float(float)) --> [float].
dataType(t_bool(bool)) --> [bool].
dataType(t_string(string)) --> [string].

%parse tree node for command block iterative statements like if,while,for,else.
command(t_command(X,Y))--> commandbeta(X),[;],command(Y).
command(t_commandbeta(X))-->commandbeta(X).
commandbeta(t_assignmentcommand(X,Y)) --> il(X), [=],arithmectiexpression(Y).
commandbeta(t_ifelse(X,Y,Z)) --> [if],booleanexpression(X),[:],command(Y),[else],[:], command(Z).
commandbeta(t_while(X,Y)) --> [while],booleanexpression(X),command(Y),[wend].
commandbeta(t_for(X, Y, Z)) --> [for], il(X), [in], [range], ['('], arithmectiexpression(Y), [')'], command(Z),[fend].
commandbeta(t_ternary(X,Y,Z)) --> booleanexpression(X), [?], command(Y), [:], command(Z).
commandbeta(t_print(X)) --> [show], il(X).
commandbeta(X) --> block(X).


%parse tree node for boolean expressions
booleanexpression(t_true(true)) --> [true].
booleanexpression(t_false(false)) --> [false].
booleanexpression(t_equality(X,Y)) --> arithmectiexpression(X),[==],arithmectiexpression(Y).
booleanexpression(t_lessthan(X,Y)) --> arithmectiexpression(X),[<],arithmectiexpression(Y).
booleanexpression(t_greaterthan(X,Y)) --> arithmectiexpression(X),[>],arithmectiexpression(Y).
booleanexpression(t_lessthanequal(X,Y)) --> arithmectiexpression(X),[<=],arithmectiexpression(Y).
booleanexpression(t_greaterthanequal(X,Y)) --> arithmectiexpression(X),[>=],arithmectiexpression(Y).
booleanexpression(t_notboolean(X)) --> [not],booleanexpression(X).


%parse tree node for arithmetic expression addition.
arithmectiexpression(t_add(X,Y,Z)) --> term(X), plus(Y) ,arithmectiexpression(Z).
arithmectiexpression(t_add(X,Y,Z)) --> term(X), plus(Y), arithmectiexpression(Z).

%parse tree node for arithmetic expression substraction.
arithmectiexpression(t_minus(X,Y,Z)) --> term(X), minus(Y),arithmectiexpression(Z).
arithmectiexpression(t_minus(X,Y,Z)) --> term(X), minus(Y),arithmectiexpression(Z).

%parse tree node for arithmetic expression multiplication.
arithmectiexpression(t_multiply(X,Y,Z)) --> term(X), mul(Y), arithmectiexpression(Z).
arithmectiexpression(t_multiply(X,Y,Z)) --> term(X), mul(Y), arithmectiexpression(Z).

%parse tree node for arithmetic expression division.
arithmectiexpression(t_divide(X,Y,Z)) --> term(X), div(Y), arithmectiexpression(Z).
arithmectiexpression(t_divide(X,Y,Z)) --> term(X), div(Y), arithmectiexpression(Z).
arithmectiexpression(t_bracket(X,Y,Z)) --> openbrace(X), arithmectiexpression(Y), closedbrace(Z).
arithmectiexpression(t_assignment(X,Y)) --> il(X) , [=], arithmectiexpression(Y).

arithmectiexpression(X) --> il(X).
arithmectiexpression(X) --> number(X).



number(X) --> digit(X).


plus(t_plus(+)) --> [+].
minus(t_minus(-)) --> [-].
mul(t_mul(*)) --> [*].
div(t_div(/)) --> [/].



openbrace('(') --> ['('].
closedbrace(')') --> [')'].



term(X)-->fact(X).
fact(X)-->il(X).
fact(X)-->digit(X).

il(t_identifier(X))--> [X], {atom(X)}.

digit(t_digit(N))--> [N], {number(N)}.