fun uppercase(s: string): string = String.map Char.toUpper s

(*  Apply HTML quoting. *)
fun quoteHTML(v: string): string =
let
    fun quote(#"\"": char): string = "&quot;"
    |   quote #"&" = "&amp;"
    |   quote #"<" = "&lt;"
    |   quote c = str c
in
    String.translate quote v
end

(*  Break a string into words at white space. *)
fun split(s: string): string list = String.tokens Char.isSpace s

fun skipWhiteSpace(s: string): string =
    Substring.string(Substring.dropl Char.isSpace (Substring.full s))

fun countLines(s: string): int = Substring.foldl
    (fn (ch, n) => if ch = #"\n" then n + 1 else n) 1 (Substring.full s)

fun ibr(reader: 'a -> (char * 'a) option)(char_strm: 'a)
: ((int * bool * real) * 'a) option =
let
    (* Read all characters to the end of the
    string or a newline. This returns the
    line and the rest of the stream. *)
    fun get_line(charStrm: 'a)(rev_line: char list): 'a * string =
        case reader charStrm of
            NONE => (charStrm, implode(rev rev_line))     (* ran out of chars *)
        |   SOME (c, rest) =>
                if c = #"\n" then
                    (rest, implode(rev rev_line))
                else
                    get_line rest (c :: rev_line)

    val (strm_out, line) = get_line char_strm []
    val l1: substring = Substring.full line
    val (i: int, l2: substring) = valOf(Int.scan StringCvt.DEC Substring.getc l1)
    val (b: bool, l3: substring) = valOf(Bool.scan Substring.getc l2)
    val (r: real, l4: substring) = valOf(Real.scan Substring.getc l3)
in
    SOME((i, b, r), strm_out)
end
handle Option => NONE (* valOf can give Option exception. Readers return NONE *)


fun main(arg0: string, argv: string list): OS.Process.status =
let
    val text = "\
                \ 123 true 23.4        \n\
                \ -1 false -1.3e3      \n\
                \"
in
    case StringCvt.scanString ibr text of
        NONE => print "ibr failed\n"
    |   SOME (i, b, r) => print(concat[
            Int.toString i, " ",
            Bool.toString b, " ",
            Real.toString r, "\n"
        ]);
    OS.Process.success
end
