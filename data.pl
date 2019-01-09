variables([a,b,c,d,e,f,g,h]).
:- dynamic variables/1 .

known_fact(dziadek(aa,cccc)).
known_fact(ojciec(aa,eee)).
known_fact(ojciec(aa,bbb)).
known_fact(ojciec(bbb,dddd)).

predicate(ojciec, 2).
predicate(dziadek, 2).






