learn(Conseq):-
create_obj_list(L1),

generate_examples(Conseq, L1, PosExamples, NegExamples),
learn_rules(2,PosExamples, NegExamples, Conseq, 0, Rules),
nl, write(Conseq), write(' :- '), nl,
writelist(Rules), nl.

learn(Conseq, Rules):-
Conseq=..[F|_],
create_obj_list(Objs),
generate_examples(F, Objs, Pos, Neg),
learn_rules(2,Pos,Neg,Conseq,1, Rules).

generate_examples(Conseq, L1, PosExamples, NegExamples):-
generate_examples(Conseq, L1, L1, L1, PosExamples, NegExamples).

generate_examples(_, _,[],_,[],[]).

generate_examples(Conseq, [],[_|L2],LM, PosExamples, NegExamples):-
generate_examples(Conseq, LM,L2,LM,PosExamples,NegExamples).

generate_examples(Conseq, [E1|L1],[E2|L2],LM,[Pos|PosExamples],NegExamples):-
known_fact(F),F=..[Conseq|[E1|[E2|[]]]],!,
Pos=..[pos|[E1|[E2|[]]]],
generate_examples(Conseq, L1,[E2|L2],LM,PosExamples,NegExamples).

generate_examples(Conseq, [E1|L1],[E2|L2],LM,PosExamples,[Neg|NegExamples]):-
Neg=..[neg|[E1|[E2|[]]]],
generate_examples(Conseq, L1,[E2|L2],LM,PosExamples,NegExamples).

learn_rules(_, [ ] , _ , _ , _ , [ ] ) .
learn_rules(MaxLen,PosExamples, NegExamples, Conseq, VarsIndex, [Rule | RestRules]) :-
learn_one_rule( PosExamples, NegExamples,
rule(Conseq, [ ]), VarsIndex, Rule ) ,
Rule = rule(Conseq, Antec),
length(Antec, X),print(X),nl,
X < MaxLen,
remove( PosExamples, Rule, RestPosExamples),
learn_rules(MaxLen,RestPosExamples, NegExamples, Conseq, VarsIndex, RestRules).

learn_rules(MaxLen,PosExamples, NegExamples, Conseq, VarsIndex, Rules) :-
X = MaxLen + 1,
X < 4,
learn_rules(X,PosExamples, NegExamples, Conseq, VarsIndex, Rules).


learn_one_rule( _ , [ ] , Rule, _ , Rule).

learn_one_rule( PosExamples, NegExamples, PartialRule, LastUsed, Rule ) :-
new_partial_rule(PosExamples, NegExamples, PartialRule, LastUsed,
NewPartialRule, NewLastUsed) ,print(PartialRule),nl,
filter( PosExamples, NewPartialRule, PosExamples1),
filter( NegExamples, NewPartialRule, NegExamples1),
learn_one_rule( PosExamples1, NegExamples1, NewPartialRule,
NewLastUsed, Rule ),
print(Rule),nl.

new_partial_rule(PosExamples, NegExamples, PartialRule, LastUsed,
BestRule, RetLastUsed) :-
findall(NewRuleDescr,
scored_rule(PosExamples, NegExamples, PartialRule,
LastUsed, NewRuleDescr) ,
Rules),
sorting(Rules, Sorted),
choose_rule(10, Sorted, BestRule, RetLastUsed).

choose_rule(N, [rule_descr(rule(C,A), _, RetLastUsed)|Rules], rule(C,A), RetLastUsed).

choose_rule(N, [_|Rules], BestRule, RetLastUsed):-
M = N - 1,
M > 0,
choose_rule(M, Rules, BestRule, RetLastUsed).

sorting([A|Rest], Sorted) :-
sorting(Rest, SortedTail),
insert(A, SortedTail, Sorted).

sorting([], []).

insert(rule_descr(PartRuleA, ScoreA, RetLastUsedA), [rule_descr(PartRuleB, ScoreB, RetLastUsedB)|C], [rule_descr(PartRuleB, ScoreB, RetLastUsedB)|D]) :-
ScoreA < ScoreB, !,
insert(rule_descr(PartRuleA, ScoreA, RetLastUsedA), C, D).


insert(A, C, [A|C]).


scored_rule(PosExamples, NegExamples, PartialRule, LastUsed,
rule_descr(CandPartialRule, Score, RetLastUsed) ) :-
candidate_rule(PartialRule, PosExamples, NegExamples, LastUsed,
CandPartialRule, RetLastUsed) ,
CandPartialRule = rule(Conseq,[Anteced|_]),
Conseq \= Anteced,
filter( PosExamples, CandPartialRule, PosExamples1),
filter( NegExamples, CandPartialRule, NegExamples1),
length( PosExamples1, NPos),
length( NegExamples1, NNeg),
NPos > 0,
Score is 2*NPos - NNeg.

candidate_rule(rule(Conseq, Anteced), PosExamples, NegExamples, LastUsed,
rule(Conseq, [Expr|Anteced]), RetLastUsed) :-
build_expr(LastUsed, Expr, RetLastUsed),
suitable(rule(Conseq, [Expr|Anteced]), NegExamples).

suitable(rule(Conseq, Anteced),[NegExample|_]):-
not(covers(rule(Conseq, Anteced), NegExample)).

suitable(Rule, [_|NegExamples]):-
suitable(Rule, NegExamples).

create_obj_list(ObjSet) :-
       findall(Objs,
              (  known_fact(Pred),
                 Pred =.. [_ | Objs]
              ),
              OutObjList),
       unfold_obj_list(OutObjList, [], ObjList),
       sort(ObjList,ObjSet).

unfold_obj_list([], List, List).

unfold_obj_list([FirstList | RestListOfLists], List, NewList) :-
conc(FirstList, List, NewList1),
unfold_obj_list(RestListOfLists, NewList1, NewList).


conc([ ], L2 , L2 ).
conc([X1|R1 ], L2, [X1|RN ]) :-
conc(R1, L2, RN).

build_expr(LastUsed,Expr,RetLastUsed) :-
predicate(Pred, N),
build_arg_list(N, vars(LastUsed, LastUsed), false, ArgList, RetLastUsed),
Expr =.. [Pred|ArgList] .

%argument niespe�niony - dodaj wcze�niej u�yt� zmienn�
build_arg_list(1, vars(LastUsed, LastLocal), false, [Arg], LastLocal) :-
insert_arg(LastUsed, LastLocal, false, Arg, LastLocal, true).

%warunek spe�niony - dodaj argument normalnie
build_arg_list(1, vars(LastUsed, LastLocal), true, [Arg], RetLastUsed) :-
insert_arg(LastUsed, LastLocal, true, Arg, RetLastUsed, FlagOut).

build_arg_list(N, vars(LastUsed, LastLocal), Flag, [Arg|Args], RetLastUsed) :-
N>=1,
insert_arg(LastUsed, LastLocal, Flag, Arg, RetLastLocal, FlagOut),
M is N-1,
build_arg_list(M, vars(LastUsed, RetLastLocal), FlagOut, Args, RetLastUsed).

%dodaj zmienn� u�yt� we wcze�niejszych wyra�eniach
insert_arg(LastUsed, LastLocal, FlagIn, Arg, LastLocal, true) :-
variables(Vars),
gen(0,LastUsed,Gen),
nth0(Gen,Vars,Arg).

%dodaj zmienn� u�yt� wcze�niej w tym wyra�eniu
insert_arg(LastUsed, LastLocal, FlagIn, Arg, LastLocal, FlagIn) :-
LastUsed\=LastLocal,
variables(Vars),
AfterLastUsed is LastUsed+1,
gen(AfterLastUsed,LastLocal,Gen),
nth0(Gen,Vars,Arg).

%dodaje now� zmienn�
insert_arg(LastUsed, LastLocal, FlagIn, Arg, NewLastLocal, FlagIn) :-
NewLastLocal is LastLocal+1,
get_var(NewLastLocal, Arg).

gen(Min,Max,Min):-
Min=<Max.

gen(Min,Max,Result):-
Min=<Max,
X is Min+1,
gen(X,Max,Result).

%pobierz now� zmienn� z tablicy
get_var(Pos, Arg) :-
variables(Vars),
nth0(Pos,Vars,Arg),
!.

%pobierz now� zmienn� od u�ytkownika
get_var(Pos, Arg) :-
retract(variables(Vars)),
read(Arg),
append_tail(Arg, Vars, NewVars),
assert(variables(NewVars)).

append_tail(X, [], [X]).

append_tail(X, [A|Y], [A|Z]) :-
append_tail(X, Y, Z).

remove([], _, []).

remove([Example|Examples], Rule, Examples1) :-
covers(Rule, Example), !,
remove(Examples, Rule, Examples1).

remove([Example|Examples], Rule, [Example|Examples1]) :-
remove(Examples, Rule, Examples1).


filter( Examples, Rule, Examples1) :-
findall( Example,
(member(Example, Examples), covers(Rule, Example)),
Examples1).

covers(rule(Conseq, Anteced), Example) :-
match_conseq(Conseq, Example, Bindings),
match_anteced(Anteced, Bindings, _ ).

match_conseq(Conseq, Example, BindingsOut) :-
Conseq =.. [_|ArgList1],
Example =.. [_|ArgList2],
match_arg_lists(ArgList1,ArgList2,[],BindingsOut).

match_anteced([ ], Bindings, Bindings).

match_anteced([A|RestAnteced], BindingsIn, BindingsOut) :-
match_expr(A, BindingsIn, Bindings1),
match_anteced(RestAnteced, Bindings1, BindingsOut).

match_expr(Expr,BindingsIn,BindingsOut) :-
known_fact(Fact),
functor(Expr,Functor,N),
functor(Fact,Functor,N),
Expr =.. [_|ArgList1],
Fact =.. [_|ArgList2],
match_arg_lists(ArgList1,ArgList2,BindingsIn,BindingsOut) .

match_arg_lists([], [], BindingsIn, BindingsIn).

match_arg_lists([Arg1|RestList1],[Arg2|RestList2], BindingsIn, BindingsOut) :-
match_args(Arg1, Arg2, BindingsIn, BindingsOut1),
match_arg_lists(RestList1, RestList2, BindingsOut1, BindingsOut).

%nie ma powiazania, wiec dodaj
match_args(Arg1, Arg2, [], [bind(Arg1,Arg2)]).

%istnieje juz powiazanie
match_args(Arg1, Arg2, [bind(Arg1,Arg2)|BindingsInRest], [bind(Arg1,Arg2)|BindingsInRest]).

%jak nie ma sprzecznosci to idz dalej
match_args(Arg1, Arg2, [bind(Arg3,Arg4)|BindingsInRest], [bind(Arg3,Arg4)|BindingsOut]) :-
Arg1\=Arg3,
Arg2\=Arg4,
match_args(Arg1, Arg2, BindingsInRest, BindingsOut).

writelist( []).

writelist( [X | L])  :-
   tab( 2), write( X), nl,
   writelist( L).
