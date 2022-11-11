val success = OS.Process.success
val failure = OS.Process.failure
val status = OS.Process.status

exception Fatal
exception InternalError of string

fun process(args: string list): unit = () (* dummy, for demonstration *)
fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)
fun f(): unit = () (* dummy *)

fun run(args: string list): status =
    let
        val _: int = 0 (* this is just dummy *)
    in
        process args;
        print "starting f\n";
        f() before print "done f\n";
        success
    end
    handle
        IO.Io {name, function, cause} =>
        (
            toErr(concat[
                "IO Error ", name," ", function, " ", exnMessage cause, "\n"
            ]);
            failure
        )
    |   Fatal => (toErr "Aborting\n"; failure)
    |   InternalError msg =>
        (
            toErr(concat["Internal error, ", msg, "\n"]);
            failure
        )
    |   ex => (* misc exception *)
        (
            toErr(concat["Uncaught exception: ", exnMessage ex,"\n"]);
            failure
        )
