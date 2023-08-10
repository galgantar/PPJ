module type STACK = 
sig
  type element
  type stack
  val empty: stack
  val push: element -> stack -> stack
  val pop: stack -> element option * stack
end


module ListStack(M : sig type t end) : STACK =
struct
  type element = M.t
  type stack = element list
  let empty = []
  let push x s = x::s
  let pop = function [] -> None, [] | x::s -> Some x, s
end