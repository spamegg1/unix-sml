fun main(arg0, argv) =
let
    fun sort() =
    let
        val gen = Rand.mkRandom 0w123
        val data = List.tabulate(100000, (fn _ => gen()))
        val sorted = ListMergeSort.sort (op >) data
    in
        ()
    end
in
    SMLofNJ.Internals.GC.messages true;
    (* Compiler.Profile.setTimingMode true; *)
    sort();
    (* Compiler.Profile.setTimingMode false; *)
    (* Compiler.Profile.report TextIO.stdOut; *)
    OS.Process.success
end
