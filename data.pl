variables([a,b,c,d,e,f,g,h]).
:- dynamic variables/1 .

known_fact(malzonek(jan,maria)).
known_fact(malzonek(maria,jan)).
known_fact(brat(jan,zdzich)).
known_fact(brat(zdzich,jan)).
known_fact(brat(icek,maria)).
known_fact(brat(tobiasz,maria)).
known_fact(szwagier(icek,jan)).
known_fact(szwagier(tobiasz,jan)).
known_fact(szwagier(zdzich,maria)).


predicate(szwagier, 2).
predicate(malzonek, 2).
predicate(brat, 2).






