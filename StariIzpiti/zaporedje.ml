let rec zaporedje1 a b f n =
  match n with
  | 0 -> a
  | 1 -> b
  | n -> f (zaporedje1 a b f (n-2)) (zaporedje1 a b f (n-1))
;;


let zaporedje a b f n =
  let x2 = ref(a) in
  let x1 = ref(b) in
  let i = ref(2) in
  
  while (!i <= n) do
    let xn = (f !x2 !x1) in
    x2 := !x1 ;
    x1 := xn ;
    i := !i + 1
  done ;
    !x1
;;