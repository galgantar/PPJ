(* Pomožni tip, funkcija in signatura za lepše primerjanje. *)
type order = Less | Equal | Greater

let ocaml_cmp x y =
  let c = Stdlib.compare x y in
  if c < 0 then Less
  else if c > 0 then Greater
  else Equal

module type ORDERED =
  sig
    type t
    val cmp : t -> t -> order
  end

(* Specifikacija podatkovnega tipa množica. *)
module type SET =
  sig
    type element
    val cmp : element -> element -> order
    type set
    val empty : set
    val member : element -> set -> bool
    val add : element -> set -> set
    val remove : element -> set -> set
    val to_list : set -> element list
    val fold : ('a -> element -> 'a) -> 'a -> set -> 'a
  end

(* NASA KODA BEGIN*)

(* uporabljamo SET *)
module IntListSet : SET with type element = int =
struct
  type element = int
  let cmp : element -> element -> order = ocaml_cmp
  type set = element list
  let empty = []
  
  (* let member el s = List.mem() *)
  let rec member el s = 
      match s with
      | [] -> false
      | x::xs -> 
        match cmp el x with
        | Equal -> true
        | _ -> member el xs
  
  let add el s = if member el s then s else el::s

  let rec remove el s =
    match s with
    | [] -> []
    | x::xs ->
      match cmp el x with
      | Equal -> xs
      | _ -> x :: remove el xs

  let to_list s = s

  (* fold f y [x1,...,xn] nardi f(f(f y x0) x1) ... recimo sesteje, zmnozi karkoli *)
  let rec fold (f :'a -> element -> 'a) (y: 'a) (s : set) = 
    match s with
    | [] -> y
    | [x] -> f y x                (*tega ne bi rabil*)
    | x::xs -> fold f (f y x) xs

end

(* za comparable tipe smo definirali signaturo ORDERED *)


(* NASA KODA END *)

(* NASA KODA BEGIN *)

module ListSet(M: ORDERED) : SET with type element = M.t =
struct
  type element = M.t
  let cmp = M.cmp
  type set = element list
  let empty = []
  
  (* let member el s = List.mem() *)
  let rec member el s = 
      match s with
      | [] -> false
      | x::xs -> 
        match cmp el x with
        | Equal -> true
        | _ -> member el xs
  
  let add el s = if member el s then s else el::s

  let rec remove el s =
    match s with
    | [] -> []
    | x::xs ->
      match cmp el x with
      | Equal -> xs
      | _ -> x :: remove el xs

  let to_list s = s

  (* fold f y [x1,...,xn] nardi f(f(f y x0) x1) ... recimo sesteje, zmnozi karkoli *)
  let rec fold (f :'a -> element -> 'a) (y: 'a) (s : set) = 
    match s with
    | [] -> y
    | [x] -> f y x                (*tega ne bi rabil*)
    | x::xs -> fold f (f y x) xs

end

(* NASA KODA END *)

(* V oklepajih napisemo, da morejo biti elementi tipa ordered - podobno kot templeati v C++ *)
(* FUNKTOR: sprejme modul in vrne modul, zraven pa specificiramo, kako more vhodni modul zgledu (more bit ORDERED) *)
module AVLSet(M : ORDERED) : SET with type element = M.t =
  struct
    type element = M.t
    let cmp = M.cmp

    type set = Empty | Node of element * int * set * set

    let empty = Empty

    let height = function
      | Empty -> 0
      | Node (_, h, _, _) -> h

    let leaf v = Node (v, 1, Empty, Empty)

    let node (v, l, r) = Node (v, 1 + max (height l) (height r), l, r)

    let rec member x = function
      | Empty -> false
      | Node (y, _, l, r) ->
         begin
           match cmp x y with
           | Equal -> true
           | Less -> member x l
           | Greater -> member x r
         end

    let rec to_list = function
      | Empty -> []
      | Node (x, _, l, r) -> to_list l @ [x] @ to_list r

    let rotateLeft = function
      | Node (x, _, a, Node (y, _, b, c)) -> node (y, node (x, a, b), c)
      | t -> t

    (* alternativni zapis s case *)
    let rotateRight = function
      | Node (y, _, Node (x, _, a, b), c) -> node (x, a, node (y, b, c))
      | t -> t

    let imbalance = function
      | Empty -> 0
      | Node (_, _, l, r) -> height l - height r

    let balance = function
      | Empty -> Empty
      | Node (x, _, l, r) as t ->
         begin
           match imbalance t with
           | 2 ->
              (match imbalance l with
               | -1 -> rotateRight (node (x, rotateLeft l, r))
               | _ -> rotateRight t)
           | -2 ->
              (match imbalance r with
               | 1 -> rotateLeft (node (x, l, rotateRight r))
               | _ -> rotateLeft t)
           | _ -> t
         end

    let rec add x = function
      | Empty -> leaf x
      | Node (y, _, l, r) as t ->
         begin
           match cmp x y with
           | Equal -> t
           | Less -> balance (node (y, add x l, r))
           | Greater -> balance (node (y, l, add x r))
         end

    let rec remove x = function
      | Empty -> Empty
      | Node (y, _, l, r) ->
         let rec removeSuccessor = function
           | Empty -> assert false
           | Node (x, _, Empty, r) -> (r, x)
           | Node (x, _, l, r) ->
              let (l', y) = removeSuccessor l in
              (balance (node (x, l', r)), y)
         in
         match cmp x y with
         | Less -> balance (node (y, remove x l, r))
         | Greater -> balance (node (y, l, remove x r))
         | Equal ->
            begin match (l, r) with
            | (_, Empty) -> l
            | (Empty, _) -> r
            | _ ->
               let (r', y') = removeSuccessor r in
               balance (node (y', l, r'))
            end

    let rec fold f x = function
      | Empty -> x
      | Node (y, _, l, r) -> fold f (f (fold f x l) y) r

  end

(* KAKO UPORABLJAT TO *)
module SL = ListSet (struct type t = int let cmp = ocaml_cmp end)
module SA = AVLSet (struct type t = int let cmp = ocaml_cmp end)

let rec build_list n = 
  if n = 0 then
    SL.empty
  else
    SL.add n (build_list (n-1))

let rec build_avl n =
  if n = 0 then
    SA.empty
  else
    SA.add n (build_avl (n-1))


module SetOps(S : SET) =
struct
    let union a b = S.fold (fun s x -> S.add x s) a b
    let filter p a = S.fold(fun s x -> if p x then S.add x s else s) S.empty a
    let intersection a b = filter (fun x -> S.member x a) b
end