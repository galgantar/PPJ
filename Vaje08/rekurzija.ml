let r = ref 5;;

let vsota_lihih_42 = 
  let v = ref 0 in
  let i = ref 0 in
  while !i < 42 do
    v := !v + (2 * !i + 1) ;
    i := !i + 1
  done ;
  !v

let vsota1 n =
  let v = ref 0 in
  let i = ref 0 in
  while !i <= n do
    v := !v + !i ;
    i := !i + 1
  done ;
  !v

let rec vsota2 n = 
  if n > 0 then
    vsota2(n - 1) + n
  else 0

let vsota3 n = (* z akumulatorji (i, s) predelamo vsoto2 v repno rekurzijo, ce bi mel zanke bi rabl mutacije - tiste ref *)
  let rec loop i s = 
    if i > n then
      s
    else
      loop (i + 1) (s + i)
  in
    loop 1 0

let fib n = 
  if n = 0 then (* if expression, isto kot ternary operator v Javi*)
    0 
  else
    let a = ref 0 in
    let b = ref 1 in
    let c = ref 1 in
    while !c <= n do
      let temp = !b in
      b := !a + !b ;
      a := temp ;
      c := !c + 1
    done ;
    !b

let rec fib' n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | x -> fib' (x - 1) + fib'(x - 2)


  let vsota_lihih2 n =
    let rec vsota v i =
      if i < n then
        vsota (v + (2 * i + 1)) (i + 1)
      else
        v
    in
    vsota 0 0