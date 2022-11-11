fun word_count(text: string) =
    let
        fun out_state([]: char list)(count: int): int = count
        |   out_state (c :: rest) count =
            if Char.isSpace c then
                out_state rest count
            else
                in_state rest count

    and in_state([]: char list)(count: int): int = count + 1
    |   in_state (c :: rest) count =
        if Char.isSpace c then
            out_state rest (count + 1)
        else
            in_state rest count
    in
        out_state (explode text) 0
    end

fun word_count2(text: string): int =
    let
        datatype State = In | Out

        fun loop(Out: State)([]: char list)(count: int): int = count
        |   loop Out (c :: rest) count =
            if Char.isSpace c then
                loop Out rest count
            else
                loop In rest count

        |   loop In [] count = count + 1
        |   loop In (c :: rest) count =
            if Char.isSpace c then
                loop Out rest (count + 1)
            else
                loop In rest count
    in
        loop Out (explode text) 0
    end

fun word_count3(text: string): int = length(String.tokens Char.isSpace text)

(* run it with: main("", []) *)
fun main(arg0: string, argv: string list): OS.Process.status =
    let
        val cnt: int = word_count "the quick brown fox";
    in
        print(concat["Count = ", Int.toString cnt, "\n"]);
        OS.Process.success
end
