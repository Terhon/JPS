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

%drugie drzewo

known_fact(maz(michal, magda)).
known_fact(zona(magda, michal)).

known_fact(siostra(magda, lukasz)).
known_fact(brat(lukasz, magda)).

known_fact(maz(lukasz, marta)).
known_fact(zona(marta, lukasz)).

known_fact(siostra(marta, kinga)).
known_fact(siostra(kinga, marta)).

known_fact(maz(marcin, kinga)).
known_fact(zona(kinga, marcin)).

known_fact(szwagier(michal, lukasz)).
known_fact(szwagier(lukasz, michal)).
known_fact(szwagier(marcin, marta)).

%trzecie drzewo

known_fact(brat(wojciech, krystyna)).
known_fact(siostra(krystyna, wojciech)).

known_fact(zona(karolina, wojciech)).
known_fact(maz(wojciech, karolina)).

known_fact(zona(krystyna, adam)).
known_fact(maz(adam, krystyna)).

known_fact(siostra(ewa, krystyna)).
known_fact(siostra(krystyna, ewa)).

known_fact(brat(wojciech, ewa)).
known_fact(siostra(ewa, wojciech)).

known_fact(brat(adam, danuta)).
known_fact(siostra(danuta, adam)).

known_fact(zona(danuta, slawomir)).
known_fact(maz(slawomir, danuta)).

known_fact(szwagier(wojciech, adam)).
known_fact(szwagier(adam, wojciech)).

known_fact(szwagier(adam, ewa)).

known_fact(szwagier(adam, slawomir)).
known_fact(szwagier(slawomir, adam)).




%czwarte

known_fact(maz(dariusz, hanna)).
known_fact(zona(hanna, dariusz)).

known_fact(brat(dariusz, krzysztof)).
known_fact(brat(krzysztof, dariusz)).

known_fact(szwagier(krzysztof, hanna)).

%piate

known_fact(maz(kamil, babina)).
known_fact(zona(balbina, kamil)).

%szoste

known_fact(maz(grzegorz, katarzyna)).
known_fact(zona(katarzyna, grzegorz)).

known_fact(siostra(zyta, grzegorz)).
known_fact(brat(grzegorz, zyta)).

known_fact(siostra(adelajda, grzegorz)).
known_fact(brat(grzegorz, adelajda)).

%siodme

known_fact(siostra(aniela, antoni)).
known_fact(brat(antoni, aniela)).

known_fact(brat(antoni, august)).
known_fact(brat(august, antoni)).

known_fact(brat(feliks, antoni)).
known_fact(brat(antoni, feliks)).


predicate(szwagier, 2).
predicate(malzonek, 2).
predicate(brat, 2).






