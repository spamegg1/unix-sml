use "posix-unix.sml"; (* for openInFD and openOutFD *)

structure P = Posix.Process
structure SS = Substring
structure FS = Posix.FileSys
structure PIO = Posix.IO
structure PROC = Posix.ProcEnv

(* 2005 version
datatype 'a stream =
    UNOPENED of PIO.file_desc
|   OPENED of { stream: 'a, close: unit -> unit }

datatype proc_status = DEAD of OS.Process.status | ALIVE of P.pid

datatype ('a, 'b) proc = PROC of {
    base: string,
    instream: 'a stream ref,
    outstream: 'b stream ref,
    status: proc_status ref
}
*)

(* version I invented, guessing the 2001 version. At least it type-checks! *)
datatype ('a, 'b) proc = PROC of {
    pid: P.pid,
    ins: 'a,
    outs: 'b
}

fun protect(f: 'a -> 'b)(x: 'a): 'b =
let
    val _ = Signals.maskSignals Signals.MASKALL
    val y = (f x) handle ex => (
        Signals.unmaskSignals Signals.MASKALL;
        raise ex
    )
in
    Signals.unmaskSignals Signals.MASKALL;
    y
end

fun executeInEnv(cmd: string, argv: string list, env: string list)
: (TextIO.instream, TextIO.outstream) proc =
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
        case protect P.fork() of
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

                (* file_desc is an eqtype but still gives polyEqual warning *)
                if oldin = newin then ()
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

    PROC {
        pid = pid,
        ins = ins,
        outs = outs
    }
end
