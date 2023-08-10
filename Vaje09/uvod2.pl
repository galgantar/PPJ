%%% KAKO "ČISTO" FUNKCIJO PREDSTAVIMO Z RELACIJO oz. PREDIKATOM?

% 1! = 1
% 2! = 2
% 3! = 6
% 4! = 24
% 5! = 120
% 6! = 720
% 7! = 5040
% 8! = 40320
% 9! = 362880
% 10! = 3628800
% 11! = 39916800
% 12! = 479001600
% 13! = 6227020800
% 14! = 87178291200
% 15! = 1307674368000
% 16! = 20922789888000

% let factorial = function
%     | 0 -> 1
%     | 1 -> 1
%     | 2 -> 2
%     | 3 -> 6
%     | 4 -> 24
%     | 5 -> 120
%     | 6 -> 720
%     | 7 -> 5040
%     | 8 -> 40320
%     | 9 -> 362880
%     | 10 -> 3628800
%     | 11 -> 39916800
%     | 12 -> 479001600
%     | 13 -> 6227020800
%     | 14 -> 87178291200
%     | 15 -> 1307674368000
%     | 16 -> 20922789888000
%     | _ -> failwith "ne znam"

% predikat factorial(X, Y) definiran prek "dejstev" o funkciji fakulteta
% (pravila oz. dejstva o na novo definiranem predikatu se morajo v Prolog
% programskih datotekah nahajati na enem mestu!)
factorial(0, 1).
factorial(1, 1).
factorial(2, 2).
factorial(3, 6).
factorial(4, 24).
factorial(5, 120).
factorial(6, 720).
factorial(7, 5040).
factorial(8, 40320).
factorial(9, 362880).
factorial(10, 3628800).
factorial(11, 39916800).
factorial(12, 479001600).
factorial(13, 6227020800).
factorial(14, 87178291200).
factorial(15, 1307674368000).
factorial(16, 20922789888000).


% Kako "poličemo" `factorial`?
% - predikat `factorial` lahko uporabljamo pri sestavljanju novih predikatov: uporabljamo ga kot "pravilo"
% - predikat `factorial` uporabimo pri poizvedbah
%     ?- factorial(4, 120).
%     ?- factorial(X, 120).
%     ?- factorial(X, 1200).
%     ?- factorial(X, 1).
%     ?- factorial(10, Y).
%     ?- factorial(3, Y), factorial(Y, Z).

% RAZLIKE MED IMENI Z MALO IN VELIKO ZACETNICO V PROLOGU.
% V OCamlu je uporaba velike začetnice omejena: uporabljamo jo lahko le za poimenovanje konstruktorjev, modulov (in se nekaterih drugih stvari).
% V Prologu je uporaba velike začetnice rezerviranja za poimenovanje Spremenljivk!
% "Konstruktorje" imena predikatov in drugih dodatkov v prologu pišemo z malo začetnico.


% binomski simbol (n \choose k) = n! / ((n-k)! * k!) - število kombinacij
choose(N, K, Result) :-
    factorial(N, Nf),
    factorial(K, Kf),
    Dif is N-K,
    factorial(Dif, Diff),
    Result is Nf / Kf / Diff.

% ?- choose(5, 2, Result).
% ?- choose(5, K, 10).


% OCaml: let product (a, b, c) = a * b * c
% Prolog:
product(A, B, C, Result) :- Result is A * B * C.


%%% IZ OCAML SEZNAMOV V "cons/nil" SEZNAME V PROLOG SEZNAME

% V OCamlu lahko seznam s tremi elementi (1,2,3) "naredimo" takole:
% (::) (1, (::) (2, (::) (3, []))) -> 1 :: 2 :: 3 :: [] -> [1;2;3]

% Na predavanjih ste sezname v prologu definirali s konstruktorjema `cons` (analog (::) v OCamlu) in `nil` (analog [] v OCamlu):
% cons(1, cons(2, cons(3, nil)))
% Če se v spremenljivki `Seznam` imamo shranjen tak seznam se lahko do prvega elementa "dokopamo" prek *združevanja*:
% ?- Seznam = cons(1, cons(2, cons(3, nil))), Seznam = cons(PrviElement, PreostaliDelSeznama).

% V swi-prologu integrirani seznami uporabljajo namesto `cons` `'[|]'` in namesto `nil` `[]`.
% Primeri (medsebojno ekvivalenti):
% '[|]'(1, '[|]'(2, '[|]'(3, [])))
% [1|[2|[3|[]]]]
% [1,2,3]

% Izvedi naslednje poizvedbe:
% ?- '[|]'(1, '[|]'(2, '[|]'(3, []))) = '[|]'(Head, Tail). % seznami v swi-prolog
% ?- [1|[2|[3|[]]]] = [Head | Tail]. % sintaktični sladkorček 1
% ?- [1,2,3] = [Head | Tail]. % sintaktični sladkorček 2

% A lahko pretvorimo "sezname s predavanj v integrirane sezname v Prologu"?
% Seveda, predikat list_from_cons/2 ima ravno to funkcionalnost.
list_from_cons(nil, []).
list_from_cons(cons(Head, Tail), [Head | Tail1]) :-
    list_from_cons(Tail, Tail1).

% OCaml: let rec nth_element = function (0, h::_) -> h | (n, _::t) when n > 0 -> nth_element (n-1, t)
nth_element(N, List, Element) :-
    N = 0, List = [H|_], Element = H;
    N > 0, List = [_|T], nth_element(N1, T, Element), N1 is N-1.

% zgornje lahko zapisemo na lepsi nacin
% nth_element(0, [H|_], H).
% nth_element(N, [_|T], Element) :-
%     N > 0, nth_element(N1, T, Element), N1 is N-1.

% Kaj so pomanjkljivosti zgornje rešitve?


% MALO ZA SALO, MALO ZA RES

% Kakšno funkcionalnost imajo naslednji predikati?
enaka(X, X).
prvi(X, [X|_]).
drugi(X, [_,X|_]).
ne_velja() :- false.
velja() :- true. % velja. <- krajši zapis
logicni_ali(X, Y):- X ; Y.
logicni_in(X, Y):- X, Y.



% true/0 je integriran predikat, ki ne sprejme nobenega argumenta true() :)
% ?- help(ime_predikata/ariteta) vrne pomoč za integriran predikat
% =/2 in ,/2 ter ;/2 so tudi predikati (ampak jih ponavadi uporabljamo v infiksni obliki).

% Argumentiraj rezultate naslednji poizvedb
% 
% ?- member(X, [true, false]), X; false.
% ?- =(,,,).