use "posix-unix.sml"; (* for openInFD and openOutFD *)

structure P = Posix.Process
structure SS = Substring
structure FS = Posix.FileSys
structure PIO = Posix.IO
structure PROC = Posix.ProcEnv

fun executeInEnv(cmd: string, argv: string list, env: string list)
: ('a, 'b) Unix.proc =
let
    val p1: {infd: PIO.file_desc, outfd: PIO.file_desc} = PIO.pipe()
    val p2: {infd: PIO.file_desc, outfd: PIO.file_desc} = PIO.pipe()

    fun closep(): unit = (
        PIO.close(#outfd p1);
        PIO.close(#infd  p1);
        PIO.close(#outfd p2);
        PIO.close(#infd  p2)
    )

    val base: string = SS.string(SS.taker(fn c => c <> #"/") (SS.full cmd))

    fun startChild(): P.pid =
        case P.fork() of
            SOME pid => pid (* parent *)
        |   NONE =>
            let
                val oldin : PIO.file_desc = #infd p1
                val newin : PIO.file_desc = FS.wordToFD 0w0
                val oldout: PIO.file_desc = #outfd p2
                val newout: PIO.file_desc = FS.wordToFD 0w1
            in
                PIO.close (#outfd p1);
                PIO.close (#infd p2);

                if oldin = newin then ()            (* file_desc is an eqtype *)
                else (
                    PIO.dup2 { old = oldin, new = newin };
                    PIO.close oldin
                );

                if (oldout = newout) then ()
                else (
                    PIO.dup2 { old = oldout, new = newout };
                    PIO.close oldout
                );

                P.exece(cmd, base :: argv, env)
            end

    val _: unit = TextIO.flushOut TextIO.stdOut
    val pid: PIO.pid = (startChild ()) handle ex => (closep(); raise ex)

    val ins : TextIO.instream  = openInFD (base^"_exec_in" , #infd  p2)
    val outs: TextIO.outstream = openOutFD(base^"_exec_out", #outfd p1)
in
    (* close the child-side fds *)
    PIO.close(#outfd p2);
    PIO.close(#infd  p1);

    (* set the fds close on exec *)
    PIO.setfd(#infd  p2, PIO.FD.flags [PIO.FD.cloexec]);
    PIO.setfd(#outfd p1, PIO.FD.flags [PIO.FD.cloexec]);

    (* this one does not work. I don't know how to make it work. *)
    PROC {
        pid = pid,
        ins = ins,
        outs = outs
    }
end
