variables([a,b,c,d,e,f]).
:- dynamic variables/1 .

known_fact(matka(M,A)).
known_fact(brat(A,B)).

predicate(matka, 2).
predicate(brat, 2).







