structure FS = OS.FileSys
structure OP = OS.Path
fun toErr(msg: string) = TextIO.output(TextIO.stdErr, msg)
exception Error of string

fun open_dir(dir: string): FS.dirstream = FS.openDir dir
    handle OS.SysErr (msg, _) =>
        raise Error (concat["Cannot open directory ", dir, ": ", msg, "\n"])

fun get_files(dir: string)(strm: FS.dirstream)(files: string list): string list =
    case FS.readDir strm of
        NONE => rev files                                             (* done *)
    |   SOME(f) =>
        let
            val file: string = OP.joinDirFile {dir = dir, file = f}
        in
            if FS.isLink file then                  (* ignore symbolic links? *)
                get_files dir strm files
            else
                get_files dir strm (file :: files)
        end

fun show_wx(file: string): unit =
    (* if FS.access(file, [FS.A_WRITE, FS.A_EXEC]) then *)
    if FS.access(file, [FS.A_READ]) then
    (
        print file;
        print "\n"
    )
    else ()

fun scan_dir(dir: string): unit =
let
    (* val _ = print(concat["scan_dir ", dir, "\n"]) *)
    val strm: FS.dirstream = open_dir dir
    val files: string list = get_files dir strm []
    val _: unit = FS.closeDir strm

    fun scan_subdir(file: string): unit =
        if FS.isDir file then scan_dir file else ()
in
    app show_wx files;
    app scan_subdir files
end

fun main(arg0: string, argv: string list): OS.Process.status =
let
in
    case argv of
        [] => scan_dir OP.currentArc
    |   (file :: _) => scan_dir file;

    OS.Process.success
end
handle
    OS.SysErr (msg, _) =>
    (
        toErr(concat["System Error: ", msg, "\n"]);
        OS.Process.failure
    )
|   Error msg => (toErr msg; OS.Process.failure)
|   x =>
    (
        toErr(concat["Uncaught exception: ", exnMessage x,"\n"]);
        OS.Process.failure
    )
