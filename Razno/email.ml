type person = { name: string }

type email = { sender : person; recipients: person list; message:string }

let gal = { name="Gal" }
let vid = { name="Vid" }
let zarja = { name="Zarja" }
let alenka = { name="Alenka" }

let myEmail:email = {
  sender = gal;
  recipients = [vid; zarja; alenka];
  message="Hej vsi"
}

let string_of_email : email -> string =
  fun e ->
    e.sender.name ^ "\n" ^
    String.concat ", " (List.map (fun p -> p.name) e.recipients) ^ "\n" ^
    e.message ^ "\n"
;;

print_string (string_of_email myEmail);;