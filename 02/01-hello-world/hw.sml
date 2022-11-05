structure Main =
struct

    fun main(arg0: string, argv: string list): OS.Process.status =
    (
        print "Hello world\n";
        OS.Process.success
    )

    val _: unit = SMLofNJ.exportFn("hw", main)

end
