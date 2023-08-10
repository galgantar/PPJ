type number = Zero | Succ of number | Pred of number


let rec stopnja n =
  match n with
  | Zero -> 0
  | Pred(a) -> 1 + stopnja(n)
  | Succ(a) -> 1 + stopnja(n)
;;


let rec simp n =
  match n with
  | Zero -> Zero
  
  | Pred(a) -> (
    match simp a with
    | Succ(a) -> a
    | a -> Pred(a)
  )
  
  | Succ(a) -> (
    match simp a with
    | Pred(a) -> a
    | a -> Succ(a)
  )
;;


let a = Succ(Pred(Succ(Zero)));;

simp a;;