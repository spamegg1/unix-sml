signature UNSAFE_MONO_VECTOR =
sig
    type vector
    type elem
    val sub   : vector * int -> elem
    val update: vector * int * elem -> unit
    val create: int -> vector
end

signature UNSAFE_MONO_ARRAY =
sig
    type array
    type elem
    val sub   : array * int -> elem
    val update: array * int * elem -> unit
    val create: int -> array
end

signature UNSAFE_VECTOR =
sig
    val sub   : 'a vector * int -> 'a
    val create: int * 'a list -> 'a vector
end

signature UNSAFE_ARRAY =
sig
    val sub   : 'a array * int -> 'a
    val update: 'a array * int * 'a -> unit
    val create: int * 'a -> 'a array
end
