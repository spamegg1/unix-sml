structure O = Unsafe.Object

fun obj_size(obj: O.object): int =
    case O.rep obj of
        O.Unboxed    => 1                                   (* inline 31 bits *)
    |   O.Real       => 1 + 2
    |   O.Pair       => tup_size obj
    |   O.Record     => tup_size obj
    |   O.RealArray  => tup_size obj
    |   O.PolyArray  => arr_size obj
    |   O.ByteVector => 1 + ((size(O.toString obj) + 3) div 4)
    |   O.ByteArray  => 1 + ((Array.length(O.toArray obj) + 3) div 4)
    |   _            => 2          (* punt for other objects: Susp or WeakPtr *)

and sz(obj: O.object): int = if O.boxed obj then 1 + (obj_size obj) else 1

and foldFun(obj: O.object, s: int): int = s + sz obj

(*  Count the record plus the size of pointed-to objects in the heap. *)
and tup_size(obj: O.object): int =  List.foldl foldFun 1 (O.toTuple obj)
and arr_size(obj: O.object): int = Array.foldl foldFun 1 (O.toArray obj)

(*  Estimate the size of v in 32-bit words.
    Boxed objects have an extra descriptor word which
    also contains the length for vectors and arrays. *)
fun sizeof(v: 'a): int = obj_size(O.toObject v)

fun show(name: string)(v: 'a): unit = print(concat[
    "Size of ", name, " = ", Int.toString(sizeof v), " 32-bit words\n"
])

(* This is a main function to try it out. *)
fun main(arg0: string, argv: string list): OS.Process.status = (
    show "integer" 3;                                                    (* 1 *)
    show "real"    3.3;                                                  (* 3 *)
    show "string"  "abc";                                                (* 2 *)
    show "pair"    ("abc", 42);                                          (* 5 *)
    show "record"  {a = 1, b = 4.5, c = "fred"};                         (* 9 *)

    OS.Process.success
)