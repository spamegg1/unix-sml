structure Common =
struct

    (* A hash table with string keys. *)
    structure STRT_key =
    struct
        type hash_key = string
        val hashVal = HashString.hashString
        fun sameKey (s1: hash_key, s2: hash_key) = (s1 = s2)
    end

    structure STRT = HashTableFn(STRT_key)
    exception NotFound
    (* now we can create a string-keyed hash table like this:
        type OptionTable = string STRT.hash_table
        val option_tbl: OptionTable = STRT.mkTable(101, NotFound)
    *)
end

signature GLOBAL =
sig
    type Option = string option

    (* Add an option to the table silently overriding an existing entry. *)
    val addOption: (string * Option) -> unit

    (* Test if an option is in the table. *)
    val hasOption: string -> bool

    (* Get the value of an option if it exists. *)
    val getOption: string -> Option option
end

structure Global: GLOBAL =
struct
    open Common

    (* The option table. *)
    type Option = string option
    type OptionTable = Option STRT.hash_table

    val option_tbl: OptionTable = STRT.mkTable(20, NotFound)
    fun addOption arg = STRT.insert option_tbl arg
    fun hasOption name = STRT.find option_tbl name <> NONE
    fun getOption name = STRT.find option_tbl name

end


structure Main =
struct

    (* This exception will bomb with a usage message. *)
    exception Usage of string

    fun parse_cmdline(argv: string list): string list = let
        fun loop ([]: string list): string list = []          (* no more args *)
        |   loop ("-h" :: rest)       = add ("help", NONE) rest
        |   loop ("-v" :: rest)       = add ("verbose", NONE) rest
        |   loop ("-verbose" :: rest) = add ("verbose", NONE) rest
        |   loop ("-width"   :: rest) = get_value "width" rest
        |   loop ("-height"  :: rest) = get_value "height" rest
        |   loop (arg :: rest)        =
            if String.sub(arg, 0) = #"-" then
                raise Usage (concat["The option ", arg, " is unrecognised."])
            else arg :: rest                              (* the final result *)

        and get_value(name: string)([]: string list): string list =
            raise Usage (concat ["The value for the option ", name, " is missing."])
        |   get_value name (v :: rest) = add (name, SOME v) rest

        and add(pair: string * string option)(rest: string list): string list =
        (
            Global.addOption pair;
            loop rest
        )

        in
            loop argv
        end

    fun require_option(name: string)(and_value: bool): string =
        case Global.getOption name of
            NONE => raise Usage(concat["The option '", name,"' is missing."])
        |   SOME NONE =>                            (* found but has no value *)
            if and_value then
                raise Usage(concat["The option '",name,"' is missing a value."])
            else ""
        |   SOME (SOME v) => v                       (* found and has a value *)


    fun main(arg0: string, argv: string list): OS.Process.status = let
        val files = parse_cmdline argv
        val width : string = require_option "width" true
        val height: string = require_option "height" true

        fun show_stuff(): unit =
        (
            print "The files are";
            app (fn f => (print " "; print f)) files;
            print ".\n";

            if Global.hasOption "verbose" then
                print(concat[
                    "The width is ", width, ".\n",
                    "The height is ", height, ".\n"
                ])
            else ()
        )
        in
            if Global.hasOption "help" then
                print "some helpful blurb\n"
            else
                show_stuff();

            OS.Process.success
        end
        handle Usage msg =>
        (
            TextIO.output(TextIO.stdErr, concat[msg,
                "\nUsage: [-h] [-v|-verbose] [-width width]",
                " [-height height] files\n"
            ]);
            OS.Process.failure
        )

    val _ = SMLofNJ.exportFn("getopt2", main)
end
