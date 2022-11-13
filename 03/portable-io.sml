fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)

fun read(strm: TextIO.instream)(nchars: int, nwords: int, nlines: int)
: int * int * int =
    (* This ensures the line ends with a \n unless we are at eof. *)
    case TextIO.inputLine strm of
        NONE => (nchars, nwords, nlines)
    |   SOME(line) =>
        let
            val words = String.tokens Char.isSpace line
        in
            read strm (nchars + size line, nwords + length words, nlines + 1)
        end

fun count(strm: TextIO.instream)(file: string): unit =
let
    val (nchars, nwords, nlines) = read strm (0, 0, 0)
in
    print(concat[
        Int.toString nlines, " ",
        Int.toString nwords, " ",
        Int.toString nchars, " ",
        file,
        "\n"
    ])
end

fun main(arg0: string, argv: string list): OS.Process.status =
let
in
    case argv of
        [] => count TextIO.stdIn ""
    |   (file :: _) =>
        let
            val strm = TextIO.openIn file
        in
            (count strm file) handle x => (TextIO.closeIn strm; raise x);
            TextIO.closeIn strm
        end;
    OS.Process.success
end
handle
    IO.Io {name, function, cause} =>
    (
        toErr(concat["IO Error: ", name,", ", exnMessage cause, "\n"]);
        OS.Process.failure
    )
|   ex =>
    (
        toErr(concat["Uncaught exception: ", exnMessage ex, "\n"]);
        OS.Process.failure
    )
