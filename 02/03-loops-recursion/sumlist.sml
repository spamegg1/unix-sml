fun sumlist(the_list: int list): int =
    case the_list of
        [] => 0
    |   v :: rest => v + sumlist rest

fun sumlist1([]: int list): int = 0
|   sumlist1 (v :: rest) = v + sumlist rest

(* tail recursion *)
fun sumlist2(the_list: int list): int =
    let
        fun loop([]: int list)(sum: int): int = sum
        |   loop (v :: rest) sum = loop rest (sum + v)
    in
        loop the_list 0
    end

(* using fold *)
fun sumlist3(the_list: int list): int =
    List.foldl (fn (v, sum) => v + sum) 0 the_list

fun sumlist4(the_list: int list): int = foldl (op +) 0 the_list

val sumlist5: int list -> int = foldl (op +) 0

val accumlist: int -> int list -> int = foldl (op +)
val sumlist6: int list -> int = accumlist 0
