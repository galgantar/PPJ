type korak = Dol | Gor | Levo | Desno;;

let premik (x, y) smer =
  match smer with
  | Dol -> (x, y - 1)
  | Gor -> (x, y + 1)
  | Levo -> (x - 1, y)
  | Desno -> (x + 1, y)
;;


let rec isElement a sez =
  match sez with
  | [] -> false
  | x::xs ->
      if a = x then
        true
      else
        isElement a xs
;;


let rec varnaPot mine zac kon koraki =
  match koraki with
  | [] -> isElement zac mine and zac = kon
  | x::xs -> 
    if isElement zac mine then
      false
    else
      varnaPot mine (premik zac x) kon xs
;;

