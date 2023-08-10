(* Povzeto po https://learnxinyminutes.com/docs/ocaml/ *)
(* 1.
   Tako delamo komentarje,
   ki so lahko več vrstic
   (* in lahko jih gnezdimo. *)
*)

(* 2. 
   programske datoteke sestavlja zaporedje [fraz],
   ki jih v interpreterju ločujemo z [;;] (v programskih datotekah pa jih skoraj vedno izpuščamo)
   Faze so lahko vezave spremenljivk, deklaracije funkcij, izrazi, ... (več v naslednjih tednih)
*)

let spremenljivka = "nekaj lepega" ;;
let funkcija = fun x -> "jaz sem anonimna funkcija" ;;
let succ x = x + 1 ;;
1 + succ 1 ;;

(* 3.
   Programov ne bomo prevajali, le interpretirali:
   $ rlwrap ocaml -init <ime programske datoteke>.ml
   $ utop -init <ime programske datoteke>.ml
   utop # #use "<ime programske datoteke>.ml" ;;
*)


(* 4.
   Pri vezavi spremenljivk in deklaraciji funkcij uporabljamo [let] frazo
   let <ime spremenljivke> = <izraz>
   let <ime spremenljivke> : <tip spremenljivke> = <izraz>
   let <ime funkcije> <argument 1> <argument 2> ... = <izraz>
   let <ime funkcije> (<arg 1> : <tip arg 1>) (<arg 2> : <tip arg 2>) ... : <tip vrednosti, ki jo funkcija vrača> = <izraz>
*)

let x = 10 ;;
(* ime lahko vsebuje znak ['], ponavadi ga uporabljamo
   za poimenovanje začasnih spremenljivk *)
let x' = x * 2 ;; 

(* 5.
   V večini primerov je eksplicitno določanje tipov odveč,
   saj OCaml zna sam "sklepati na tip" (angl. type inference).
   Tipe podajamo, ko se želimo izogniti dvoumnim deklaracijam
   (mogoče bo kakšen primer pokazan na predavanjih).
*)
let succ_int (x : int) : int = x + 1 ;;

(* 6.
   Pri deklaraciji rekurzivnih funkcij moramo uporabiti rezervirano
   besedo [rec]. Anonimne funkcije ne morajo biti rekurzivne.
*)
let rec fakulteta n =
   if n = 0 then 1
   else n * fakulteta (n-1)
;;
let rec fakulteta' = fun n ->
   if n = 0 then 1
   else n * fakulteta' (n-1)
;;

(* 7.
   Pri funkcijskih aplikacijah oklepajev nimamo (enako kot v lambda računu).
   ... razen, če je argument izraz.
   Opomba: aplikacije so levo asociativne in imajo najvišjo prioriteto. 
*)
let fakulteta_5 = fakulteta 5 ;;
let fakulteta_4 = fakulteta (5-1) ;;
let ff_3_plus_1 = fakulteta (fakulteta 3) + 1 ;; (* 6! + 1 *)


(* 8.
   Vsaka funkcija lahko sprejme natanko en argument!
   V primeru, ko argumenta ne rabimo, uporabimo argument tipa [unit].
   Obstaja samo ena vrednost tega tipa, tj. [()].
*)
let pozdrav () = print_endline "Pozdravljen, svet!" ;;

(* primer klica take funkcije. *)
pozdrav () ;;

(* Funkcije, ki "sprejmejo" dva argumenta so še vedno funkcije,
ki sprejmejo en argument. Spodje deklaracije so ekvivalentne. *)
let cudna_vsota x y = x + y ;; (* cudna_vsota je tipa int -> int -> int *)
let cudna_vsota' x = fun y -> x + y ;;
let cudna_vsota'' = fun x -> fun y -> x + y ;;
let cudna_vsota''' = fun x y -> x + y ;;

(* 9.
   Rezultat delnih aplikacij so funkcije
*)
let pristej_10 = cudna_vsota 10 ;; (* pristej_10 je tipa int -> int *)
pristej_10 100 ;; (* se izračuna v 110 *)
let pristej_10' x = cudna_vsota 10 x ;;

(* 10.
   Zaporedje izrazov pišemo tako:
   (<izraz 1> ; <izraz 2> ; ... ; <zadnji izraz>)
   Rezultat takega izraz je izračunan <zadnji izraz>.
   Preostali izrazi ponavadi imajo stranske učinke.
   Primer uporabe (funkcija za razhroščevanje):
*)
let izpisi_in_vrni x =
    print_endline (string_of_int x);
    x
;;


(* 11.
   V OCamlu vsaka funkcija mora vrniti neko vrednost.
   Ko nimamo ničesar za vrnit (glavna funkcionalnost funkcije je stranski učinek),
   vrnemo vrednost tipa unit tj. [()].
   Primer:
      Funkcija [print_endline] je tipa [string -> unit].
      Njen stranski učinek pa je izpis na standardni izhod.
*)


(* 12.
   Do sedaj smo bile vse spremenljivke vezane v "globalno" okolje.
   Lokalno okolje/vezave lahko ustvarimo na slednji način:
   
   let <ime lokalne spremenljivke, recimo x> = <poljuben izraz> in
      <izraz, ki uporabi [x] ali pa ne>
*)

let obseg_zemlje =
   let pi = 3.14159265 in
   let polmer_zemlje = 6371.0 in 
   2.0 *. pi *. polmer_zemlje
;;


(* 13. Nekaj (infiksnih) operatorje *)
(* Operatorji so funkcije *)

let vsota = (+) ;; (* int -> int -> int *)

(+) 3 4 ;; (* enako kot 3 + 4 *)

12 + 3 ;; (* celoštevilsko seštevanje *)
12.0 +. 3.0 ;; (* seštevanje v plavajoči vejici *)

12 / 3 ;; (* celoštevilsko deljenje *)
12.0 /. 3.0 ;; (* deljenje v plavajoči vejici *)
5 mod 2 ;; (* ostanek pri deljenju *)


- 3 ;; (* operator za negacijo [-] deluje za cela števila, *) 
- 4.5 ;; (* kot tudi za števila v plavajoči vejici *)

~- 3 ;; (* celoštevilska negacija *)
~-. 3.4 ;; (* negacija v plavajoči vejici *)

(* 14.
   Lahko definiraš svoje operatorje
*)
let (--) a b = Int.abs(a - b) ;; (* razdalja *)
let (~/) x = 1.0 /. x ;; (* inverz *)
~/4.0 ;; (* = 0.25 *)


(* 15.
   Že-implementirani (lastni) podatkovni tipi
*)
(* Seznami: Implementacija v ozadju [type 'a list = (::) of 'a * 'a list] *)
let seznam = [1; 2; 3] ;;
let seznam' = 1 :: 2 :: 3 :: [] ;;

(* terke - produkt tipov *)
let par_stevil = 3, 4 ;; (* tipa int * int *)
let trojica = (1, "dva", [3.0; 4.0]) ;; (* tipa int * string * float list *)

[(1, 2)] = [1, 2] ;; (* tipa bool *)

(* drugi element seznama *)
List.nth seznam 1 ;;

(* prvi element seznama *)
List.hd seznam ;;

(* "rep" seznama *)
List.tl seznam ;;

(* Funkcije višjega-reda za delo z seznami: map, filter, fold_left, ... *)
List.map (fun x -> x * 2) [1; 2; 3] ;;
List.filter (fun x -> x mod 2 = 0) [1; 2; 3; 4] ;;

(* "dodajanje" na začetek seznama z uporabo konstruktorja [(::)] *)
1 :: [2; 3] ;; (* Gives [1; 2; 3] *)


(* Nizi: prek uporabe dvojnih narekovajev *)
let niz = "Pozdravljeni, svet" ;;

(* zlaganje nizov z uporab operatorja [(^)] *)
let some_str = "Pozdravljeni" ^ ", svet"  ;;


(* 16.
   Lastni podatkovni tipi
*)

(* sinonimi za podatkovni tip *)
type celoStevilo = int ;;
type parStevil = int * int ;;

(* vsota podatkovnih tipov *)
type programskiJezik = OCaml | C | Haskell | Java ;;
let jezik = OCaml ;;  (* tipa programskiJezik *)

(* konstruktorji lahko imajo argumente *)
type stevilo = PlusNeskocno | MinusNeskocno | Realno of float ;;
let r0 = Realno (-3.4) ;; (* tipa stevilo *)

(* tip, ki predstavlja mešanico celih in stevil v plavajoči vejici *)
type number = Int of int | Float of float ;;

(* tip za točko v ravnini *)
type tocka = Tocka of float * float;;
let t0 = Tocka (2.0, 3.0) ;;

(* Parametrizacija tipov, induktivni in koinduktivni tipi → predavanja *)


(* 17.
   Osnovno ujemanje vzorcev

   match <izraz> with
   | <vzorec 1> -> <izraz>
   | <vzorec 2> -> <izraz> 
   | ... 
*)

(* ujemanje vrednosti *)

let je_nic x =
   match x with
   | 0 -> true
   | _ -> false  (* vzorec [_] predstavlja "wildcard" *)
;;

(* za funckije (ki so v zgornji obliki) obstaja sintaktičen sladkorček *)
let je_nic = function
   | 0 -> true
   | _ -> false
;;

(* uporaba "stražarjev pri ujemanju vzorcev" *)
let abs x =
   match x with
   | x when x < 0 -> -x
   | _ -> x
;;


(* konstruktorji in ujemanje vzorcev *)

(* type tocka = Tocka of float * float *)
let vsota_tock t0 t1 =
   match t0, t1 with
   | Tocka (x0, y0), Tocka (x1, y1) -> Tocka (x0 +. x1, y0 +. y1)
;;

let vsota_tock' (Tocka (x0, y0)) (Tocka (x1, y1)) =
   Tocka (x0 +. x1, y0 +. y1)
;;

(* type number = Int of int | Float of float *)

let mesana_vsota x y =
match x, y with
| Int a, Int b -> Int (a + b)
| Float a, Float b -> Float (a +. b)
| (Float a, Int b | Int b, Float a) ->
   Float (a +. float_of_int b)
;;