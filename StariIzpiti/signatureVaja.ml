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
  val init : int -> int
end


module Vector : ORDERED with type t = int =
struct
  type t = int
  let cmp = ocaml_cmp
  let init x = x + 10;
end



let v = Vector.init 10;;

print_int v


let rec remove s a = 
  match s with
  | [] -> []
  | x::xs -> 
    if x = a then
      xs
    else 
      x::(remove xs a)


let rec fold s f acc =
  match s with 
  | [] -> acc
  | x::xs -> f x (fold xs f acc)


let s = [1;2;3;4;5]


(* SIGNATURE: *)
(* za signaturo - module type, za uporabo - module *)
(* ne mores uprablat funkcij, ki niso v signaturi z Vector.neki *)
