variables([a,b,c,d,e,f]).

learn_rules( [ ] , _ , _ , _ , [ ] ) .
learn_rules(PosExamples, NegExamples, Conseq, VarsIndex, [Rule | RestRules]) :-
learn_one_rule( PosExamples, NegExamples,
rule(Conseq, [ ]), VarsIndex, Rule ) ,
remove( PosExamples, Rule, RestPosExamples),
learn_rules(RestPosExamples, NegExamples, Conseq, VarsIndex, RestRules).

learn_one_rule( _ , [ ] , Rule, _ , Rule).

learn_one_rule( PosExamples, NegExamples, PartialRule, LastUsed, Rule ) :-
new_partial_rule( PosExamples, NegExamples, PartialRule, LastUsed,
NewPartialRule, NewLastUsed) ,
filter( PosExamples, NewPartialRule, PosExamples1),
filter( NegExamples, NewPartialRule, NegExamples1),
learn_one_rule( PosExamples1, NegExamples1, NewPartialRule,
NewLastUsed, Rule ).

new_partial_rule( PosExamples, NegExamples, PartialRule, LastUsed,
BestRule, RetLastUsed) :-
findall(NewRuleDescr,
scored_rule( PosExamples, NegExamples, PartialRule,
LastUsed, NewRuleDescr) ,
Rules),
choose_best( Rules, BestRule, RetLastUsed).

scored_rule( PosExamples, NegExamples, PartialRule, LastUsed,
rule_descr(CandPartialRule, Score, RetLastUsed) ) :-
candidate_rule(PartialRule, PosExamples, NegExamples, LastUsed,
CandPartialRule, RetLastUsed) ,
filter( PosExamples, CandPartialRule, PosExamples1),
filter( NegExamples, CandPartialRule, NegExamples1),
length( PosExamples1, NPos),
length(NegExamples1, NNeg),
NPos > 0,
Score is NPos - NNeg.

candidate_rule(rule(Conseq, Anteced), PosExamples, NegExamples, LastUsed,
rule(Conseq, [Expr|Anteced]), RetLastUsed) :-
build_expr(LastUsed, Expr, RetLastUsed),
suitable(rule(Conseq, [Expr|Anteced]), NegExamples).

build_expr(LastUsed,Expr,RetLastUsed) :-
predicate(Pred, N),
build_arg_list(N, vars(LastUsed, LastUsed), false, ArgList, RetLastUsed),
Expr =.. [Pred|ArgList] .

%argument niespe³niony - dodaj wczeœniej u¿yt¹ zmienn¹
build_arg_list(1, vars(LastUsed, LastLocal), false, [Arg], LastLocal) :-
variables(Vars),
X is LastUsed+1,
random(0,X,Rand),
nth0(Rand,Vars,Arg).

%warunek spe³niony - dodaj argument normalnie
build_arg_list(1, vars(LastUsed, LastLocal), true, [Arg], RetLastUsed) :-
insert_arg(LastUsed, LastLocal, true, Arg, RetLastUsed, FlagOut).

build_arg_list(N, vars(LastUsed, LastLocal), Flag, [Arg|Args], RetLastUsed) :-
insert_arg(LastUsed, LastLocal, Flag, Arg, RetLastLocal, FlagOut),
M is N-1,
build_arg_list(M, vars(LastUsed, RetLastLocal), FlagOut, Args, RetLastUsed).

%dodaj u¿yt¹ wczeœniej zmienn¹
insert_arg(LastUsed, LastLocal, FlagIn, Arg, RetLastLocal, FlagOut) :-
variables(Vars),
X is LastLocal+1,
nth0(X,Vars,_),
random(0,X,Rand),
nth0(Rand,Vars,Arg),
RetLastLocal = LastLocal,
(Rand =< LastUsed -> FlagOut = true ; FlagOut = FlagIn).

%dodaj now¹ zmienn¹
insert_arg(LastUsed, LastLocal, FlagIn, Arg, RetLastLocal, FlagIn) :-
variables(Vars),
RetLastLocal is LastLocal+1,
nth0(RetLastLocal,Vars,Arg).

%pobiera od u¿ytkownika i dodaje do Vars
insert_arg(LastUsed, LastLocal, FlagIn, Arg, RetLastLocal, FlagIn) :-
variables(Vars),
length(Vars, VarsLen),
LastLocal>=VarsLen,
read(Arg),
RetLastLocal is LastLocal+1.

filter( Examples, Rule, Examples1) :-
findall( Example,
(member1(Example, Examples), covers(Rule, Example)),
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
