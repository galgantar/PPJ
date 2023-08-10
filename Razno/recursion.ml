type 'a tree = Leaf of 'a | Node of 'a tree * 'a tree


let drevo:int tree =
Node(
  Node(
    Node(
      Leaf(10),
      Leaf(12)
    ),
    Leaf(0)
  ),
  Leaf(-12)
);;



let vecjiNic: (int -> bool) =
  fun x -> x <= 0
;;


let rec count p t =
  match t with
  | Node(l, r) -> count p l + count p r
  | Leaf(a) -> if (p a) then 1 else 0
;;

(* print_int (count vecjiNic drevo);; *)


let vsota n =
  let i = ref 1 in
  let s = ref 0 in
  while (!i <= n) do
    s := !s + !i;
    i := !i + 1;
  done;
  !s
;;

let vsota2 n = 
  let rec loop i s =
    if i > n then
      s
    else
      loop (i + 1) (s + i)
    in
      loop 1 0
;;

let rec fib n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib(n - 2) + fib (n - 1)
;;


let power3plus1 b =
  match b with
  | 0 -> 2
  | b -> 3 * (power3plus1 b - 1) - 2
;;