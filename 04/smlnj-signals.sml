structure S = Signals
structure C = SMLofNJ.Cont

val sighup: S.signal = valOf(S.fromString "HUP")

val signals: S.signal list = S.listSignals()
val signal_names: string list = List.map S.toString signals
fun show_signals(): unit = app (fn s => print(concat[s, "\n"])) signal_names

(*  I get these signals available on my system (Ubuntu 22.04):
    HUP
    INT
    QUIT
    USR1
    USR2
    PIPE
    ALRM
    TERM
    CHLD
    CONT
    TSTP
    TTIN
    TTOU
    URG
    VTALRM
    WINCH
    IO
    GC
*)

fun interrupt_handler(signal: S.signal, n: int, cont: 'a C.cont): 'a C.cont = (
    print "interrupt\n";
    cont
)

fun loop(): unit = (Signals.pause(); loop())

fun main(arg0: string, argv: string list): OS.Process.status = (
    S.setHandler(S.sigINT, S.HANDLER interrupt_handler);
    loop();
    OS.Process.success
)
