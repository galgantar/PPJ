let zanka s0 p f r =
  let rec loop s =
    if p s then loop (f s) else r s
  in loop s0

(*
s0 - zacetno stanje, p - predikat funckija, ki sprejme stanje in vrne, ali se zanka se more izvajat
r - zracuna rezultat iz zanke, ponavadi identiteta
*)

let vsota4 n = zanka (0, 0) (fun (i, v) -> i <= n) (fun (i, v) -> (i + 1, v + i)) (fun (i, v) -> v)

