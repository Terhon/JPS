variables([a,b,c,d,e,f,g,h]).
:- dynamic variables/1 .


%pierwsze drzewo

known_fact(brat(jan, karol)).
known_fact(brat(karol, jan)).

known_fact(siostra(maria, anna)).
known_fact(siostra(anna, maria)).

known_fact(siostra(anna, artur)).
known_fact(brat(artur, anna)).
known_fact(brat(artur, maria)).
known_fact(siostra(maria, artur)).

known_fact(maz(karol, maria)).
known_fact(zona(maria, karol)).

known_fact(szwagier(jan, maria)).
known_fact(szwagier(karol, anna)).
known_fact(szwagier(karol, artur)).
known_fact(szwagier(artur, karol)).
known_fact(szwagier(jan, artur)).
known_fact(szwagier(artur, jan)).

predicate(szwagier, 2).
predicate(maz, 2).
predicate(zona, 2).
predicate(siostra, 2).
predicate(brat, 2).








