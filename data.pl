variables([a,b,c,d,e,f,g,h]).
:- dynamic variables/1 .

known_fact(matka(grazyna,seba)).
known_fact(brat(seba,karyna)).
known_fact(brat(karyna,seba)).
known_fact(matka(grazyna,karyna)).

predicate(matka, 2).
predicate(brat, 2).







