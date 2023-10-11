program_eval(t_program(P),X, Y, Z):-eval_prog(P,[(x,X), (y,Y)],Result),lookup(z, Result, Z).
eval_prog(t_block(X,Y),Env,NewEnv):-eval_decl(X,Env,Env1),eval_cmd(Y,Env1,NewEnv).

% evaluator for declaration
eval_decl(t_declaration(X,Y),Env,NewEnv):-eval_decl1(X,Env,Env1),eval_decl(Y,Env1,NewEnv).
eval_decl(t_declarationbeta(X),Env,NewEnv):-eval_decl1(X,Env,NewEnv).
eval_decl1(t_constantdeclaration(t_identifier(Id),Exr),Env,[(Id,Exr)|Env]).

% evaluator for identifier declaration
eval_decl1(t_identifierdeclaration(t_integer(_),t_identifier(Id)),Env,NewEnv):-Id \= x, Id\=y, NewEnv = [(Id,0)|Env];Id = x, NewEnv = Env;Id = y, NewEnv = Env.
eval_decl1(t_identifierdeclaration(t_string(_),t_identifier(Id)),Env,NewEnv):-Id \= x, Id\=y, NewEnv = [(Id,"null")|Env];Id = x, NewEnv = Env;Id = y, NewEnv = Env.
eval_decl1(t_identifierdeclaration(t_float(_),t_identifier(Id)),Env,NewEnv):-Id \= x, Id\=y, NewEnv = [(Id,0.0)|Env];Id = x, NewEnv = Env;Id = y, NewEnv = Env.
eval_decl1(t_identifierdeclaration(t_bool(_),t_identifier(Id)),Env,NewEnv):-Id \= x, Id\=y, NewEnv = [(Id,false)|Env];Id = x, NewEnv = Env;Id = y, NewEnv = Env.

% evaluator for declaring command block
eval_cmd(t_command(X,Y),Env,NewEnv):-eval_cmd1(X,Env,Env1),eval_cmd(Y,Env1,NewEnv).
eval_cmd(t_commandbeta(X),Env,NewEnv):-eval_cmd1(X,Env,NewEnv).

% evaluator for ternary operator
eval_cmd1(t_ternary(X,Y,_Z),Env,NewEnv):- eval_bool(X,Env,Env1,true),eval_cmd(Y,Env1,NewEnv).
eval_cmd1(t_ternary(X,_Y,Z),Env,NewEnv):- eval_bool(X,Env,Env1,false),eval_cmd(Z,Env1,NewEnv).

% evaluator for while
eval_cmd1(t_while(B,X),Env,NewEnv):-eval_bool(B,Env,Env1,true),eval_cmd(X,Env1,TempEnv),eval_cmd1(t_while(B,X),TempEnv,NewEnv).
eval_cmd1(t_while(B,_X),Env,NewEnv):-eval_bool(B,Env,NewEnv,false).
eval_cmd1(t_assignmentcommand(t_identifier(X),Exr),Env,NEnv):-expr_eval(Exr,Env,Env1, Val), update(X,Val,Env1,NEnv).

% evaluator for ifelse
eval_cmd1(t_ifelse(B,X,_Y),Env,NewEnv):-eval_bool(B,Env,Env1,true),eval_cmd(X,Env1,NewEnv).
eval_cmd1(t_ifelse(B,_X,Y),Env,NewEnv):-eval_bool(B,Env,Env1,false),eval_cmd(Y,Env1,NewEnv).
eval_cmd1(t_block(X),Env,NewEnv):-eval_prog(X,Env,NewEnv).
eval_cmd1(t_print(X),Env,Env):- expr_eval(X,Env,Env,Val),write("The Value of Variable is "),write(Val),nl.

% evaluator for  for
eval_cmd1(t_for(t_identifier(X), Y, Z), Env, NewEnv) :- expr_eval(t_identifier(X),Env,Env,Val),update(X, Val, Env, TempEnv),expr_eval(Y, TempEnv,NewTempEnv, Result), eval_cmd1(t_for_eval(X, Result, Z), NewTempEnv, NewEnv).
eval_cmd1(t_for_eval(X, Y, Z), Env, NewEnv) :- lookup(X, Env, Result), Result < Y, eval_cmd(Z, Env, TempEnv), Iteration is Result + 1,update(X, Iteration, TempEnv, NewTempEnv), eval_cmd1(t_for_eval(X, Y, Z), NewTempEnv, NewEnv).
eval_cmd1(t_for_eval(X, Y, _Z), Env, Env) :- lookup(X, Env, Result), Result >= Y.

% evaluator for boolean expressions.
eval_bool(t_true(true),_Env,_NEnv,true).
eval_bool(t_false(false),_Env,_NEnv,false).

% evaluator for greater than
eval_bool(t_equality(X,Y),Env,NewEnv,Val):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),expr_equal(Val1,Val2,Val).
eval_bool(t_greaterthan(X,Y),Env,NewEnv,true):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 > Val2.
eval_bool(t_greaterthan(X,Y),Env,NewEnv,false):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 =< Val2.

% evaluator for greater than equal
eval_bool(t_greaterthanequal(X,Y),Env,NewEnv,true):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 >= Val2.
eval_bool(t_greaterthanequal(X,Y),Env,NewEnv,false):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 < Val2.

% evaluator for less than equal
eval_bool(t_lessthanequal(X,Y),Env,NewEnv,false):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 =< Val2.
eval_bool(t_lessthanequal(X,Y),Env,NewEnv,false):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 > Val2.

% evaluator for less than

eval_bool(t_lessthan(X,Y),Env,NewEnv,true):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 < Val2.
eval_bool(t_lessthan(X,Y),Env,NewEnv,false):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val1 >= Val2.
% evaluator for boolean true false
eval_bool(t_notboolean(B),Env,NewEnv,Val):-eval_bool(B,Env,NewEnv,Val1),expr_not(Val1,Val).
expr_not(true,false).
expr_not(false,true).

% evaluator for equals
expr_equal(Val1,Val2,true):- Val1 = Val2.
expr_equal(Val1,Val2,false):- Val1 \= Val2.
expr_eval(t_assignment(t_identifier(Id),Exr),Env,NewEnv,Val):-expr_eval(Exr,Env,Env1,Val),update(Id,Val,Env1,NewEnv).
expr_eval(t_assignment(X),Env,NewEnv,Val):-expr_eval(X,Env,NewEnv,Val).

% evaluator for addition
expr_eval(t_add(X,t_plus(_),Y),Env,NewEnv, Val):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val is Val1+Val2.

% evaluator for substraction
expr_eval(t_minus(X,t_minus(_),Y),Env,NewEnv,Val):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val is Val1-Val2.

% evaluator for multiplication
expr_eval(t_multiply(X,t_mul(_),Y),Env,NewEnv,Val):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val is Val1*Val2.

% evaluator for division
expr_eval(t_divide(X,t_div(_),Y),Env,NewEnv,Val):-expr_eval(X,Env,Env1,Val1),expr_eval(Y,Env1,NewEnv,Val2),Val is Val1/Val2.

% evaluator for paranthesis expression
expr_eval(t_bracket(X),Env,NewEnv,Val):-expr_eval(X,Env,NewEnv,Val).
expr_eval(t_identifier(X),Env,Env,Value):-lookup(X, Env, Value).
expr_eval(t_datatype(X),Env,Env,Value) :- lookup(X, Env, Value).
expr_eval(t_digit(X),Env,Env,X).



% lookup predicate that will look for the value associated with identifier name
lookup(_,[],0).
lookup(Ident,[(Ident, Val)|_],Val).
lookup(Ident,[(Vari,_Val)|Ta1],Val) :- Ident \= Vari, lookup(Ident,Ta1,Val).


% update predicate that will update the latest value for the variable 
update(Id,Val,[],[(Id,Val)]).
update(Id,Val,[(Id,_)|Ta1],[(Id,Val)|Ta1]).
update(Id,Val,[(Vari,V1)|Ta1],[(Vari,V1)|T1]) :- Vari\=Id, update(Id,Val,Ta1,T1).
