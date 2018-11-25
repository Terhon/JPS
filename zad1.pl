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

% rule(P, [Q1, Q2, ... Qn]) - budowana regu�a
% variables ( <lista symboli>) - zmienne wyra�e� predykatowych Qx

% ostatni krok rekurencji - nie ma argument�w do z��czenia, zwr�� list�
% wej�ciow�
match_arg_lists([], [], BindingsIn, BindingsOut) :-
BindingsOut = BindingsIn.

%zwr�� w BindingsOut list� zwi�za� binding(zmienna, warto��)
%Arg1|RestList1 - lista zmiennych jakiego� Qx, np. Q1(X, Y)
%Arg2|RestList2 - lista warto�ci z jakiego� faktu, np.
%brat(Alfred, Alojzy)
%spr�buj stworzy� list� [binding(X, Alfred), binding(Y, Alojzy)]
match_arg_lists([Arg1|RestList1],[Arg2|RestList2], BindingsIn, BindingsOut) :-
%spr�buj po��czy� pierwsz� zmienn� i pierwsz� warto��
match_args(Arg1, Arg2, BindingsIn, BindingsOut1),
print(BindingsOut1),
%wykonaj procedur� dla reszty listy
match_arg_lists(RestList1, RestList2, BindingsOut1, BindingsOut).

% Sprawdza dopasowanie pary argument�w
% --
% zmiennej z wyra�enia predykatowego z poprzednika regu�y i
% symbolu z faktu operacyjnego. W przypadku powodzenia jako wynik zwraca
% uzupe�nion� list� zwi�za� zmiennych.
% Arg1 - zmienna wyra�enia Qx, np. Q1(X, Y)
% Arg2 - symbol faktu operacyjnego - warto�� wzi�ta z faktu, np. warto��
% 'Alfred' wzi�ta z faktu brat(Alfred, Alojzy)
% procedura pr�buje zostawi� w BindingsOut po��czenie BindingsIn z
% binding(X, 'Alfred')

match_args(Arg1, Arg2, BindingsIn, BindingsOut) :-
% sprawd�, czy w BindingsIn wartosc Alfrednie jest po��czone z innym
% symbolem, ni� X i dane przypisanie juz nie istnieje
not(( member(binding(Arg1, Arg), BindingsIn), Arg \= Arg2)),
not(( member(binding(Arg1, Arg2), BindingsIn))),
% dodaj nowy binding
append(BindingsIn, binding(Arg1, Arg2), BindingsOut).



















