type status = {version: string; code: int}

type transferEncoding = Chunked | Compress | Deflate | Gzip | Identity

type date = {weekday: string; day: int; month: string; year: int; timestamp: string; zone: string}

type field = (* To je unija tipov, je lahko kerkoli od teh tipov *)
  | Server of string
  | ContentLength of int 
  | ContentType of string
  | TransferEncoding of transferEncoding
  | Date of date
  | Expires of date
  | LastModified of date
  | Location of string
;;

type response = {status: status; headers: field list; body: string} ;;

let r = {
    status={version="HTTP/1.1"; code=200};
    headers=[
      Server "nginx/1.6.2";
      ContentLength 13;
      Date {weekday="Wed"; day=21; month="Mar"; year=2018; timestamp="07:28:56"; zone="GMT"};
      LastModified {weekday="Wed"; day=21; month="Mar"; year=2018; timestamp="07:28:56"; zone="GMT"};
      TransferEncoding Chunked]; (* let a = [1;2;3] *)
    body="hello world!\n"
} ;;

let string_of_date : date -> string = 
  fun d ->
    d.weekday ^ ", " ^
    string_of_int d.day  ^ " " ^
    d.month ^ " " ^
    string_of_int d.year ^ " " ^
    d.timestamp ^ " " ^
    d.zone
;;

let string_of_status s =
  s.version ^ " " ^
  string_of_int s.code ^ " " ^
  (match s.code with
   | 200 -> "OK"
   | 301 -> "Moved Permanently"
   | _ -> "")
;;

let string_of_transfer_encoding : transferEncoding -> string = 
  fun te ->
     match te with
    | Chunked -> "chunked"
    | Compress -> "compress"
    | Deflate -> "deflate"
    | Gzip -> "gzip"
    | Identity -> "identity"
;;

let string_of_field : field -> string = 
  fun f ->
    match f with 
    | Server s -> "Server: " ^ s
    | ContentLength cl -> "Content-Length: " ^ string_of_int cl
    | ContentType ct -> "Content-Type: " ^ ct
    | TransferEncoding te -> "Transfer-Encoding: " ^ string_of_transfer_encoding te
    | Date d -> "Date: " ^ string_of_date d
    | Expires ex -> "Expires: " ^ string_of_date ex
    | LastModified lm -> "Last-Modified: " ^ string_of_date lm
    | Location loc -> "Location: " ^ loc
;;

let string_of_response r =
  string_of_status r.status ^ 
  "\n" ^ 
  String.concat "\n" (List.map string_of_field r.headers) ^
  "\n" ^
  r.body
;;

print_string (string_of_response r) ;;
