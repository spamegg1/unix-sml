structure Common =
struct
    structure G = GetOpt (* alias *)

    exception Usage of string

    (* This represents an option found on the command line. *)
    datatype Option = Verbose | Help | Width of string | Height of string

    fun NoArg(opt: Option): Option G.arg_descr =
        G.NoArg (fn () => opt)

    fun ReqArg(opt: string -> Option)(descr: string): Option G.arg_descr =
        G.ReqArg (opt, descr)

    val options: (Option G.opt_descr) list = [
        {
            short = "v", long = ["verbose"],
            desc = NoArg Verbose,
            help = "Select verbose output"
        },
        {
            short = "", long = ["width"],
            desc = ReqArg Width "width",
            help = "The width in pixels"
        },
        {
            short = "", long = ["height"],
            desc = ReqArg Height "height",
            help = "The height in pixels"
        },
        {
            short = "h", long = ["help"],
            desc = NoArg Help,
            help = "Some helpful blurb"
        }
    ]

    fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)

    val opt_tbl: (Option list) ref = ref [] (* mutable reference *)

    fun parseCmdLine(argv: string list): string list =
        let
            val (opts, files) = G.getOpt {
                argOrder = G.RequireOrder,
                options = options,
                errFn = toErr
            } argv
        in
            opt_tbl := opts; (* mutation! now opt_tbl is: ref opts *)
            files
        end

    (* The ! operator is dereference, like * in C. It gets rid of "ref".
        opt_tbl is: ref [...]: list ref
        !opt_tbl is: [...]: list
    *)
    fun hasVerbose(): bool = List.exists (fn opt => opt = Verbose) (!opt_tbl)

    fun hasHelp(): bool = List.exists (fn opt => opt = Help) (!opt_tbl)

    fun getWidth(): string option =
    let
        val opt_width = List.find (fn Width _ => true | _ => false) (!opt_tbl)
    in
        case opt_width of
            NONE => NONE
        |   SOME(Width w) => SOME w
        |   _ => raise Fail "Option,getWidth"
    end

    fun getHeight(): string option =
    let
        val opt_height = List.find (fn Height _ => true | _ => false) (!opt_tbl)
    in
        case opt_height of
            NONE => NONE
        |   SOME(Height h) => SOME h
        |   _ => raise Fail "Option,getHeight"
    end

    fun require_option(func: unit -> string option)(name: string): string =
        case func() of
            NONE => raise Usage (concat["The option '", name, "' is missing."])
        |   SOME v => v
end


structure Main =
struct
    open Common

    fun usage(): string =
        concat[
            "Usage: getOpt\n",
            "-v -verbose\tSelect verbose output\n",
            "-width=width\tThe width in pixels\n",
            "-height=height\tThe height in pixels\n",
            "-h -help\tShow this message.\n"
        ]

    fun show_stuff(files: string list, width: string, height: string): unit =
    (
        print "The files are";
        app (fn f => (print " "; print f)) files;
        print ".\n";

        if hasVerbose() then
            print(concat[
                "The width is ", width, ".\n",
                "The height is ", height, ".\n"
            ])
        else ()
    )

    fun main(arg0: string, argv: string list): OS.Process.status =
    let
        val files = parseCmdLine argv
        val width = require_option getWidth "width"
        val height = require_option getHeight "height"
    in
        if hasHelp() then
            print(usage())
        else
            show_stuff(files, width, height);
            OS.Process.success
    end
    handle Usage msg =>
    (
        toErr msg;
        toErr "\n";
        toErr(usage());
        toErr "\n";
        OS.Process.failure
    )

    val _ = SMLofNJ.exportFn("getopt3", main)
end
