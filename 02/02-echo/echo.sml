structure Main =
struct
    fun main(arg0: string, argv: string list): OS.Process.status =
    (
        case argv of
            [] => ()
        |   first :: rest =>
            (
                print first;
                app (fn arg => (print " "; print arg)) rest;
                print "\n"
            );
            OS.Process.success
    )

    val _ = SMLofNJ.exportFn("echo", main)
end
