variables([a,b,c]).
:- dynamic variables/1 .

known_fact(matka(grazyna,seba)).
known_fact(brat(seba,karyna)).
known_fact(matka(grazyna,karyna)).

predicate(matka, 2).
predicate(brat, 2).







