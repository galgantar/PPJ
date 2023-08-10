(* INDUKTIVNI TIPI *)

type avltree =
  | Empty
  | Node of int * int * avltree * avltree (* Vsebina + visina drevesa *)

(*  
    5
   / \
  3   8
 / \
1   4
*)

let t = 
  Node (5, 3,
    Node (3, 2,
      Node (1, 1, Empty, Empty),
      Node (3, 1, Empty, Empty)),
    Node (8, 1, Empty, Empty))

let height t = 
  match t with
  | Empty -> 0
  | Node (_, h, _, _) -> h

let leaf x = Node (x, 1, Empty, Empty);;

let node (x, l, r) = 
  Node (x, 1 + max (height l)(height r), l, r)

let t' = 
  node (5,
    node(3,leaf 1, leaf 4),
    leaf 8)

let rec toList t =
  match t with
  | Empty -> []
  | Node (x, _, l, r) -> toList l @ x :: toList r (* :: doda en element na zacetek seznama *)

(*
če je t prazno drevo, se x ne pojavi;
če je t vozlišče z vsebino y in poddrevesoma l ter r:
če je x = y, se x pojavi;
če je x < y, iščemo v poddrevesu l;
če je x > y, iščemo v poddrevesu r.   
*)
type order = Less | Equal | Greater

let cmp x y =
  match compare x y with
  | 0 -> Equal
  | r when r < 0 -> Less
  | _ -> Greater

let rec search x t =
  match t with
  | Empty -> false
  | Node (y, _, l, r) -> match cmp x y with 
    | Equal -> true
    | Less -> search x l
    | Greater -> search x r

let imbalance t =
  match t with
  | Empty -> 0
  | Node (_, _, l, r) -> height l - height r

let rotateLeft t = 
  match t with
  | Node (x, _, a, Node(y, _, b, c)) ->
    node (y, node(x, a, b), c)
  | _ -> t (* ce slucajno nima vseh a b c oz je kksn Empty *)

let rotateRight t = 
  match t with
  | Node (y, _, Node(x, _, a, b), c) ->
    node(x, a, node(y, b, c))
  | _ -> t

let balance t = 
  match t with
  | Empty -> Empty
  | Node (x, _, l, r) ->
    match imbalance t with
    | (-1) | 0 | 1 -> t 
    | 2 -> (
      match imbalance l with
      | 1 | 0 -> rotateRight t (* leva visi v levo ali je balancirano *)
      | (-1) -> rotateRight (node(x, rotateLeft l, r)) (* se otroka zarotiramo, da je zih levi otrok na levo bl obtezen*)
      | _ -> failwith "se ne da"
    )
    | (-2) -> (
      match imbalance l with
      | (-1) | 0 -> rotateLeft t (* leva visi v levo ali je balancirano *)
      | 1 -> rotateLeft (node(x, l, rotateRight r))
      | _ -> failwith "se ne da"
    )
    | _ -> failwith "originalno drevo ni blo avl"

(* let add t x =
  match t with
  | Empty -> node(x, 1, Empty, Empty)
  | Node (y, _, l, r) ->  *)