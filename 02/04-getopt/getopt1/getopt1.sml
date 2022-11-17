(*  The options will be returned as a list of pairs
    of name and value. We need to use an option type for
    the value so that we can distinguish between a missing
    value and an empty value.
*)
type Option = string * string option

(*  The result from the command line parsing will
    be a list of file names and a set of options.
*)
type CmdLine = (Option list) * (string list)

(*  This exception will bomb with a usage message. *)
exception Usage of string

fun parse_cmdline(argv: string list): CmdLine = let
    fun loop ([]: string list)(opts: Option list): CmdLine = (opts, []) (* no more args *)
    |   loop ("-h" :: rest)       opts = loop rest (("help", NONE) :: opts)
    |   loop ("-v" :: rest)       opts = loop rest (("verbose", NONE) :: opts)
    |   loop ("-verbose" :: rest) opts = loop rest (("verbose", NONE) :: opts)
    |   loop ("-width"   :: rest) opts = get_value "width" rest opts
    |   loop ("-height"  :: rest) opts = get_value "height" rest opts
    |   loop (arg :: rest)        opts =
        if String.sub(arg, 0) = #"-" then
            raise Usage (concat["The option ", arg, " is unrecognised."])
        else (opts, arg :: rest)                          (* the final result *)

    and get_value(name: string)([]: string list)(opts: Option list): CmdLine =
        raise Usage (concat ["The value for the option ", name, " is missing."])
    |   get_value name (v :: rest) opts = loop rest ((name, SOME v) :: opts)

    in
        loop argv []
    end

fun find_option(opts: Option list)(name: string): (string option) option =
    case List.find (fn (n, v) => n = name) opts of
        NONE => NONE
    |   SOME (n, v) => SOME v

fun has_option(opts: Option list)(name: string): bool =
    (find_option opts name) <> NONE

fun require_option(opts: Option list)(name: string)(and_value: bool): string =
    case find_option opts name of
        NONE => raise Usage (concat["The option '", name,"' is missing."])
    |   SOME NONE =>                                (* found but has no value *)
        if and_value then
            raise Usage (concat["The option '", name, "' is missing a value."])
        else ""
    |   SOME (SOME v) => v                           (* found and has a value *)


fun main(arg0: string, argv: string list): OS.Process.status =
let
    val (opts, files) = parse_cmdline argv
    val width : string = require_option opts "width" true
    val height: string = require_option opts "height" true

    fun show_stuff(): unit = (
        print "The files are";
        app (fn f => (print " "; print f)) files;
        print ".\n";
        if has_option opts "verbose" then
            print(concat[
                "The width is ", width, ".\n","The height is ", height, ".\n"
            ])
        else ()
    )
in
    if has_option opts "help" then
        print "some helpful blurb\n"
    else
        show_stuff();

    OS.Process.success
end
handle Usage msg => (
    TextIO.output(TextIO.stdErr, concat[
        msg, "\nUsage: [-h] [-v|-verbose] [-width width]",
        " [-height height] files\n"
    ]);
    OS.Process.failure
)
