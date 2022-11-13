val z = SOME (fn x => x) (* val z = SOME fn : (’a -> ’a) option *)
(*
- z = NONE;
stdIn:25.1-25.9 Error: operator and operand
don’t agree [equality type required]
operator domain: ”Z * ”Z
operand:
(’Y -> ’Y) option * ’X option
in expression:
z = NONE
*)
val x = isSome z (* true : bool *)
