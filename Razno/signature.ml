module type CHANNEL =
   sig
     type t
     val init : unit -> t
     val write : t -> string -> unit
     val read : t -> string
end

module A: CHANNEL =
struct
  type t = int
  let init () = 1
  let write a s = print_int a
  let read a = "hej"
end


module type BOVINE =
sig
  type t
  val cow : t
  val equal : t -> t -> bool
  val to_string : t -> string
end


module Cow : BOVINE = 
struct
  type t = int
  let cow = 1
  let equal a b = true
  let to_string b = "hej"
end