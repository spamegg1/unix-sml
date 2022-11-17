structure FS = Posix.FileSys
exception Error of string
fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)

(* SysWord.fmt: StringCvt.radix -> Word32.word -> string *)
fun wordToDec(w: Word32.word) = SysWord.fmt StringCvt.DEC w

(* example of setting file permissions to 0444 *)
(* FS.chmod("myfile", FS.S.flags [FS.S.irusr, FS.S.irgrp, FS.S.iroth]); *)

local (*  This makes type_preds private to filetypeToString *)
    val type_preds: ((FS.ST.stat -> bool) * string) list = [
        (FS.ST.isDir,  "Directory"),
        (FS.ST.isChr,  "Char Device"),
        (FS.ST.isBlk,  "Block Device"),
        (FS.ST.isReg,  "Regular File"),
        (FS.ST.isFIFO, "FIFO"),
        (FS.ST.isLink, "Symbolic Link"),
        (FS.ST.isSock, "Socket")
    ]
in
    fun filetypeToString(st: FS.ST.stat): string =
        case List.find (fn (pr, _) => pr st) type_preds of
            SOME (_, name) => name
        |   NONE => "Unknown"
end

local
    fun test(flag: FS.S.flags)(ch: char)(mode: FS.S.mode): char =
        if FS.S.anySet(FS.S.flags [flag], mode) then ch else #"-"

    fun test2 flag1 ch1 flag2 ch2 mode =
        if      FS.S.anySet(FS.S.flags [flag1], mode) then ch1
        else if FS.S.anySet(FS.S.flags [flag2], mode) then ch2
        else #"-"

    val flags: (FS.S.mode -> char) list = [
        test  FS.S.irusr #"r",
        test  FS.S.iwusr #"w",
        test2 FS.S.isuid #"s" FS.S.ixusr #"x",
        test  FS.S.irgrp #"r",
        test  FS.S.iwgrp #"w",
        test2 FS.S.isgid #"s" FS.S.ixusr #"x",
        test  FS.S.iroth #"r",
        test  FS.S.iwoth #"w",
        test  FS.S.ixoth #"x"
    ]
in
    fun modeToString(mode: FS.S.mode): string =
    let
        fun foldFun(func: FS.S.mode -> char, rslt: char list): char list =
            (func mode) :: rslt
        val chars: char list = foldl foldFun [] flags
    in
        implode(rev chars)
    end
end

local
    structure PROC = Posix.ProcEnv
    structure DB = Posix.SysDB
in
    fun uidToInt(uid: PROC.uid): string = wordToDec(PROC.uidToWord uid)
    fun gidToInt(gid: PROC.gid): string = wordToDec(PROC.gidToWord gid)
    fun uidToName(uid: DB.uid) : string =
        (DB.Passwd.name(DB.getpwuid uid)) handle _ => "unknown"
    fun gidToName(gid: DB.gid) : string =
        (DB.Group.name(DB.getgrgid gid))  handle _ => "unknown"
end

fun devToString(dev: FS.dev): string =
let
    val word: SysWord.word = FS.devToWord dev
    val w1  : SysWord.word = SysWord.andb(SysWord.>>(word, 0w8), 0wxff)
    val w2  : SysWord.word = SysWord.andb(word, 0wxff)
in
    concat[wordToDec w1, ",", wordToDec w2]
end


fun stat(file: string): unit =
let
    val st: FS.ST.stat = (FS.stat file)
        handle OS.SysErr(msg, _) => raise Error(concat[file, ": ", msg, "\n"])
    val mode: FS.S.mode = FS.ST.mode st
    val uid : FS.uid    = FS.ST.uid st
    val gid : FS.gid    = FS.ST.gid st
    val pc: string list -> unit = print o concat      (* just an abbreviation *)
in
    pc ["File: ", file, "\n"];
    pc ["Size: ", Position.toString(FS.ST.size st), "\n"];
    pc ["Type: ", filetypeToString st, "\n"];
    pc ["Mode: ", SysWord.fmt StringCvt.OCT (FS.S.toWord mode), "/",
        modeToString mode, "\n"];
    pc ["Uid: ", uidToInt uid, "/", uidToName uid, "\n"];
    pc ["Gid: ", gidToInt gid, "/", gidToName gid, "\n"];
    pc ["Device: ", devToString(FS.ST.dev st), "\n"];
    pc ["Inode: ", wordToDec(FS.inoToWord(FS.ST.ino st)), "\n"];
    pc ["Links: ", Int.toString(FS.ST.nlink st), "\n"];
    pc ["Access: ", Date.toString(Date.fromTimeLocal(FS.ST.atime st)), "\n"];
    pc ["Modify: ", Date.toString(Date.fromTimeLocal(FS.ST.mtime st)), "\n"];
    pc ["Change: ", Date.toString(Date.fromTimeLocal(FS.ST.ctime st)), "\n"];
    ()
end

fun main(arg0: string, argv: string list): OS.Process.status = (
    case argv of
        [file] => (stat file; OS.Process.success)
    |   _      => (toErr "Usage: statx filename\n"; OS.Process.failure)
)
handle
    OS.SysErr (msg, _) => (
        toErr(concat["Error: ", msg, "\n"]);
        OS.Process.failure
    )
|   Error msg => (toErr msg; OS.Process.failure)
|   ex => (
        toErr(concat["Uncaught exception: ", exnMessage ex,"\n"]);
        OS.Process.failure
    )
