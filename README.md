# UNIX System Programming with Standard ML

## Getting Standard ML

On Debian/Ubuntu and derivatives: `sudo apt install smlnj`

This will install the language in `/usr/lib/smlnj`.

## Changes since 2001

Since the book is 21 years old (now in 2022), the Compilation Manager (`CM` from now on) of Standard ML (`sml` from now on) has changed quite a bit.

The reference you need is the revised [Compilation Manager book](https://www.smlnj.org/doc/CM/new.pdf). It says the new `CM` is in effect since version 110.20, and I'm using `sml` version 110.79 on Ubuntu 22.04.

## Chapter 2: Hello World

### Hello world program: `hw.sml` and `hw.cm`

On page 30, I had to change the `hw.cm` file from:

```sml
group is
    hw.sml
```

to:

```sml
group is
    hw.sml
    $/basis.cm
```

otherwise the library structures `SMLofNJ` and `OS.Process` would not be loaded.

On page 31 for the run script, I had to change the `smlbin` directory from:

```bash
smlbin=/src/smlnj/current/bin
```

to:

```bash
smlbin=/usr/lib/smlnj/bin
```

Also, the command to compile is also different. The book says to use:

```bash
> CM_ROOT=hw.cm sml
Standard ML of New Jersey, Version 110.0.7, September 28, 2000
- CM.make();
```

but this doesn't work. Instead I used:

```bash
> sml
Standard ML of New Jersey v110.79 [built: Sat Oct 26 12:27:04 2019]
- CM.make "hw.cm";
```

Alternatively, the `CM` book showed me an even simpler way to do the same thing, by using the binary executable command `ml-build` provided by the SML/NJ installation:

```bash
ml-build hw.cm Main.main hw
```

To run the run-script the book says:

```bash
> hw
hello world
```

but I had to use:

```bash
> ./hw
Hello world
```

### The `echo` program

Similar changes as the `hw.sml` and `hw.cm` above.

### Finite State Machine for counting words

The `C` code has a semicolon missing on page 44, at:

```c
if (!c)
{
    count++ // semicolon missing here!
    goto eod;
}
```

The `sml` code has a typo too (or maybe the language changed since then?), on page 45, right at the start:

```sml
and word_count text = (* "and" should be "fun" instead *)
```

The same typo is repeated on page 46.

### The `getopt` programs

#### Mostly functional: `getopt1.sml`

The `and` typos keep on happening so many times on page 51, I'm beginning to think they are not typos, but are meant to be placed inside a bigger wrapper function for mutual recursion? Anyway, I had to change them all to `fun`.

There is a `polyEqual` warning here at `n = name`:

```sml
fun find_option opts name : (string option) option =
    case List.find (fn (n, v) => n = name) opts of
        NONE => NONE
    |   SOME (n, v) => SOME v
```

Well we can't have that.

It can be fixed by adding a type annotation to `n` like this: `fn (n: string, v) => ...`

The book very stubbornly refuses to put any type annotations anywhere, so I'm going around and placing them myself. I think type annotations are especially useful in these complicated imperative programs, to understand what's happening. The book explains in long prose what the code does, but the code itself does not make it very clear to me.

The `polyEqual` warning can also be avoided by providing a type annotation for `name` instead:

```sml
fun find_option(opts: Option list)(name: string): (string option) option =
```

#### Using a hash table

Another `polyEqual` warning on page 55:

```sml
structure STRT_key =
struct
    type hash_key = string
    val hashVal = HashString.hashString
    fun sameKey (s1, s2) = (s1 = s2) (* here! *)
end
```

Again let's provide type annotations to avoid it:

```sml
structure STRT_key =
struct
    type hash_key = string
    val hashVal = HashString.hashString
    fun sameKey (s1: hash_key, s2: hash_key) = (s1 = s2)
end
```

Interestingly I cannot find the structures and signatures the author is talking about in the [SML manpages](https://smlfamily.github.io/Basis/manpages.html). Specifically the `signature HASH_KEY`, `signature MONO_HASH_TABLE` and `functor HashTableFn`. The author says to see Chapter 5 for what he calls "SML Utility libraries". In chapter 5 he says these libraries are under-documented. Considering the book was written in 2001 and the manpages seem to be from 2000, this seems accurate. They *are* under-documented. As in, they don't exist in the manpages. But, the code loads into `sml` just fine, so they *do* exist in my SML installation... *somewhere*.

So I followed what the author says to look into the SML installation. I looked into the folder `/usr/lib/smlnj/lib/`. There are many folders here that could hold the files `hash-table-fn.sml` and `hash-string.sml` he's talking about. These files simply don't exist, so they were either renamed, or moved into another file. Here are some candidates:

```bash
/usr/lib/smlnj/lib/smlnj/smlnj-lib/.cm/x86-unix/smlnj-lib.cm
/usr/lib/smlnj/lib/SMLNJ-LIB/Util/.cm/x86-unix/smlnj-lib.cm
```

Let's consult the `CM` book again. Second-to-last chapter, "Available libraries" says:

| name             | description                            | installed | loaded |
| ---------------- | -------------------------------------- | --------- | ------ |
| `$/smlnj-lib.cm` | SML/NJ general-purpose utility library | always    | auto   |

So my suspicion is that the hash stuff is inside this.

***Mystery solved!*** I was looking at the wrong manpages. `sml` has *two* websites for documentation: one [old](https://www.smlnj.org/doc/) and one [new](https://smlfamily.github.io/Basis/manpages.html). The old website often links to the new website, but for *some libraries* the new documentation is missing. So I was able to find all of `signature MONO_HASH_TABLE`, `structure HashString`, `signature HASH_KEY` and `functor HashTableFn` [here](https://www.smlnj.org/doc/smlnj-lib/Util/smlnj-lib.html). Apparently this `smlnj-lib` stuff "contains library and utility functions that are not part of the standard Standard." So there is an SML Basis Library, and there is an SML/NJ Library (which comes pre-installed with SML/NJ and MLton).

It's actually documented well and properly.

At this point the author says: "The type constraint on the table value settles the type of the table
immediately to save the compiler and the reader having to figure it out." :laughing: Could have used that earlier! But I get it.

#### `getopt` with a hash table: `getopt2.sml`

I cannot figure out the return types of the functions in `getopt2.sml`, specifically the helpers inside `parse_cmdline`. I'll have to come back to that. (Turns out it's just `string list`.)

Again I have to change the `.cm` file. The book says:

```sml
group is
    getopt2.sml
    /src/smlnj/current/lib/smlnj-lib.cm
```

but I have to do:

```sml
group is
    getopt2.sml

    $/basis.cm
    $/smlnj-lib.cm
```

Now `sml` and then `CM.make "getopt2.cm";` work perfectly (the book doesn't do this):

```bash
> sml
Standard ML of New Jersey v110.79 [built: Sat Oct 26 12:27:04 2019]
CM.make "getopt2.cm";
[autoloading]
[library $smlnj/cm/cm.cm is stable]
[library $smlnj/internal/cm-sig-lib.cm is stable]
[library $/pgraph.cm is stable]
[library $smlnj/internal/srcpath-lib.cm is stable]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
[scanning getopt2.cm]
[parsing (getopt2.cm):getopt2.sml]
[creating directory .cm/SKEL]
[library $SMLNJ-LIB/Util/smlnj-lib.cm is stable]
[compiling (getopt2.cm):getopt2.sml]
[creating directory .cm/GUID]
[creating directory .cm/x86-unix]
[code: 7434, data: 814, env: 1306 bytes]
```

Notice `[library $SMLNJ-LIB/Util/smlnj-lib.cm is stable]` so that's where it was.

Once again, alternatively I could use

```bash
ml-build getopt2.cm Main.main getopt2
```

So we got our executable. We'll write another launch script like before (the book does not). We can reuse the script for `echo`. Literally copy-paste it into a file named `getopt2`. Now we can run it:

```bash
./getopt2 -h -v -width 10
The option 'height' is missing.
Usage: [-h] [-v|-verbose] [-width width] [-height height] files

./getopt2 -h -v -width 10 -height 10
some helpful blurb

./getopt2 -v -width 10 -height 10 hello
The files are hello.
The width is 10.
The height is 10.
```

It's working properly.

#### The Deluxe `getopt`: `getopt3.sml`

Now we are using the `GetOpt` structure from the SML/NJ Utility Library: https://www.smlnj.org/doc/smlnj-lib/Util/str-GetOpt.html

> The `GetOpt` structure provides command-line argument processing similar to the GNU **getopt** library.

Code on page 63 starts with a structure that's supposed to conform to the `OPTION` signature:

```sml
structure Option: OPTION = 
struct
    structure G = GetOpt (* alias *)

    (* This represents an option found on the command line. *)
    datatype Option = Verbose | Help | Width of string | Height of string
    ...
```

This doesn't make sense: why should this `Option` above have things like `SOME` or `NONE` or `map` or `isSome` or `valOf`?

This requires implementing all the functions in the `OPTION` signature, and the book does not do that; so `sml` rightfully gives close to 20 errors like this:

```bash
...
getopt3.sml:1.2-23.4 Error: unmatched value specification: getOpt
getopt3.sml:1.2-23.4 Error: unmatched value specification: isSome
getopt3.sml:1.2-23.4 Error: unmatched value specification: valOf
...
```

As far as I can tell, this is a straight-up error in the book. So I had to remove the `OPTION` declaration there:

```sml
structure Option = (* removed : OPTION here *)
struct
    ...
```

The code on page 64 starts by opening a list with `[` but the list is never closed with `]`:

```sml
val options: (Option G.opt_descr) list = [
    {
    	short = "v", long = ["verbose"],
    	desc = NoArg Verbose,
    	help = "Select verbose output"
    },
    {
    	short = "", long = ["width"],
    	desc = ReqArg Width "width",
    	help = "The width in pixels"
    },
(* no closing brackets ] *)
```

Another typo? The author says: *"Here is my code for **part** of the option description list."* So I think we're supposed to write the rest? So I have to write entries for `height`, `help`. I think.

```sml
val options: (Option G.opt_descr) list = [
    {
        short = "v", long = ["verbose"],
        desc = NoArg Verbose,
        help = "Select verbose output"
    },
    {
        short = "", long = ["width"],
        desc = ReqArg Width "width",
        help = "The width in pixels"
    },
    {
        short = "", long = ["height"],
        desc = ReqArg Height "height",
        help = "The height in pixels"
    },
    {
        short = "h", long = ["help"],
        desc = NoArg Help,
        help = "Some helpful blurb"
    },
]
```

Also from the indentation used in the book it's not clear if all of these are still inside the `structure Option`, I have to assume they are. 

On page 66 in the `fun getWidth()` function, there is a closed parenthesis at the end, but it's not opened anywhere. The function body has a `let` block, so it should end with `end` but it ends with `)` instead:

```sml
fun getWidth(): string option =
    let
        val opt_width = List.find (fn Width _ => true | _ => false) (!opt_tbl)
    in
        case opt_width of
            NONE => NONE
        |   SOME(Width w) => SOME w
        |   _ => raise Fail "Option,getWidth"
    ) (* <- this should be "end" instead *)
```

On page 67 the dereference operator `!` is explained. Here is an example from the REPL:

```sml
val z: int list ref = ref [1, 2, 3];
val z = ref [1,2,3] : int list ref
z := [4]; (* mutation! *)
val it = () : unit
z;
val it = ref [4] : int list ref (* mutated value *)
!z;
val it = [4] : int list
```

So `!` gets rid of the `ref`.

Now I'm definitely lost. The `require_option` function uses the `Usage` exception that was defined in `getopt1.sml` and `getopt2.sml` but not in `getopt3.sml`. So I think the intention is that I am really supposed to keep up with what's going on and fill in the blanks by myself; just following the code fragments in the book is not enough. I go back to `getopt2.sml` and copy the exception definition.

Wait, now that I looked back on `getopt2.sml` I noticed that this code was inside `structure Main`. So... where should I end `structure Option`? The code in the book never closed that structure, so I assumed all the code so far should go into it.

Normally `parse_cmdline` was inside `structure Main` but `parseCmdLine` mutates the options table `opt_tbl` which, I think, should be inside the `structure Option`. What should I do? On page 67 the `main` function uses `Option.parseCmdLine` which means `main` is outside `structure Option`; so I think I just separate `main` into the `Main` structure and that's it. 

I am going to make a change, and move `fun show_stuff()` outside of `fun main`. This requires passing the `files, width` and `height` as parameters to `show_stuff()`:

```sml
fun show_stuff(files: string list, width: string, height: string): unit =
(
    print "The files are";
    app (fn f => (print " "; print f)) files;
    print ".\n";

    if hasVerbose() then
        print(concat[
            "The width is ", width, ".\n",
            "The height is ", height, ".\n"
        ])
    else ()
)
```

Ugh... there are a lot more unexplained things. For example `Option.getHeight` is missing. The author never wrote it. We'll just copy/paste `getWidth` and slightly change it I guess:

```sml
fun getHeight(): string option =
    let
        val opt_height = List.find (fn Height _ => true | _ => false) (!opt_tbl)
    in
        case opt_height of
            NONE => NONE
        |   SOME(Height h) => SOME h
        |   _ => raise Fail "Option,getHeight"
    end
```

I'm *NOT* having fun so far. We also need to change usages of `require_option` to `Option.require_option`, `Usage` to `Option.Usage`... or we could just `open Option` at the beginning of `structure Main` and be done with it!

There is one more undefined function in the code named `Option.usage()` and I don't know what it's supposed to do. I guess it displays the usage message in case the user inputs the wrong syntax. Let's go back to the beginning of the subsection where the author showed us the GNU default usage message:

```bash
Usage: getopt
  -v -verbose		Select verbose output
  -width=width		The width in pixels
  -height=height	The height in pixels
  -h -help			Show this message.
```

I think `Option.usage()` is supposed to return this as a `string` to be passed to `Option.toErr` as the `msg` parameter. OK! First approach:

```sml
fun usage(): string =
    concat[
        "Usage: getOpt\n",
        "-v -verbose\tSelect verbose output\n",
        "-width=width\tThe width in pixels\n",
        "-height=height\tThe height in pixels\n",
        "-h -help\tShow this message.\n"
    ]
```

The [GetOpt manpage](https://www.smlnj.org/doc/smlnj-lib/Util/str-GetOpt.html) has a really nice example with a much better approach to this `usage` by using the built-in `usageInfo` function; it's wrapped in a `usage()` function that actually *prints* directly; and it actually uses the text messages we put inside the `options` list, instead of my manual typing above. That's much better: just copy-paste it from the manpage, and slightly change it.

```sml
fun usage () = print (G.usageInfo{header = "usage:", options = options})
```

See, if the book explained all this, it would have been nice. Oh well. At least I'm having *a little bit* of fun and feeling smart.

I ended up putting this inside `structure Main` instead. Oh and I also changed the name of the structure from `Option` to `Common` like before (see further below for the reason). The overall result ended up quite different than the book. Well, there is no way for me to know that actually! Because a lot of the code is missing! So I think it ended up quite different than *what was probably intended:*

```sml
structure Common =
struct
    structure G = GetOpt (* alias *)

    exception Usage of string

    (* This represents an option found on the command line. *)
    datatype Option = Verbose | Help | Width of string | Height of string

    fun NoArg(opt: Option): Option G.arg_descr =
        G.NoArg (fn () => opt)

    fun ReqArg(opt: string -> Option)(descr: string): Option G.arg_descr =
        G.ReqArg (opt, descr)

    val options: (Option G.opt_descr) list = [
        {
            short = "v", long = ["verbose"],
            desc = NoArg Verbose,
            help = "Select verbose output"
        },
        {
            short = "", long = ["width"],
            desc = ReqArg Width "width",
            help = "The width in pixels"
        },
        {
            short = "", long = ["height"],
            desc = ReqArg Height "height",
            help = "The height in pixels"
        },
        {
            short = "h", long = ["help"],
            desc = NoArg Help,
            help = "Some helpful blurb"
        }
    ]

    fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)

    val opt_tbl: (Option list) ref = ref [] (* mutable reference *)

    fun parseCmdLine(argv: string list): string list =
        let
            val (opts, files) = G.getOpt {
                argOrder = G.RequireOrder,
                options = options,
                errFn = toErr
            } argv
        in
            opt_tbl := opts; (* mutation! now opt_tbl is: ref opts *)
            files
        end

    (* The ! operator is dereference, like * in C. It gets rid of "ref".
        opt_tbl is: ref [...]: list ref
        !opt_tbl is: [...]: list
    *)
    fun hasVerbose(): bool = List.exists (fn opt => opt = Verbose) (!opt_tbl)

    fun hasHelp(): bool = List.exists (fn opt => opt = Help) (!opt_tbl)

    fun getWidth(): string option =
    let
        val opt_width = List.find (fn Width _ => true | _ => false) (!opt_tbl)
    in
        case opt_width of
            NONE => NONE
        |   SOME(Width w) => SOME w
        |   _ => raise Fail "Option,getWidth"
    end

    fun getHeight(): string option =
    let
        val opt_height = List.find (fn Height _ => true | _ => false) (!opt_tbl)
    in
        case opt_height of
            NONE => NONE
        |   SOME(Height h) => SOME h
        |   _ => raise Fail "Option,getHeight"
    end

    fun require_option(func: unit -> string option)(name: string): string =
        case func() of
            NONE => raise Usage (concat["The option '", name, "' is missing."])
        |   SOME v => v
end


structure Main =
struct
    open Common
    
    fun usage () = print (G.usageInfo{header = "usage:", options = options})

    fun show_stuff(files: string list, width: string, height: string): unit =
    (
        print "The files are";
        app (fn f => (print " "; print f)) files;
        print ".\n";

        if hasVerbose() then
            print(concat[
                "The width is ", width, ".\n",
                "The height is ", height, ".\n"
            ])
        else ()
    )

    fun main(arg0: string, argv: string list): OS.Process.status =
    let
        val files = parseCmdLine argv
        val width = require_option getWidth "width"
        val height = require_option getHeight "height"
    in
        if hasHelp() then
            usage()
        else
            show_stuff(files, width, height);
            OS.Process.success
    end
    handle Usage msg =>
    (
        toErr msg;
        toErr "\n";
        usage();
        toErr "\n";
        OS.Process.failure
    )

    val _ = SMLofNJ.exportFn("getopt3", main)
end
```

There are no more explanations on what to do; so I have to create the `getopt3.cm` file and the `getopt3` launch script myself. Copy-pasting the `.cm` file (change `getopt2.sml` to `getopt3.sml`) and the script for`getopt2` works. Don't forget to `chmod +x getopt3` the script.

Remember we will be using the neat convenient shortcut:

```bash
ml-build getopt3.cm Main.main getopt3
```

Ah here we go... the author's weird module naming bites us in the ass:

```bash
[scanning (52181-export.cm):getopt3.cm]
52181-export.cm:1.45-1.55 Error: structure Option imported from $SMLNJ-BASIS/(basis.cm):basis-common.cm@310798(option.sml) and also from (52181-export.cm):(getopt3.cm):getopt3.sml
[parsing (52181-export.cm):52181-export.sml]
Compilation failed.
```

Yep, for some reason he keeps using names that clash with SML/NJ library, such as `Option`. I'm just changing it to `Common` instead.

Finally it's working, I can't believe it:

```bash
./getopt3 --help
The option 'width' is missing.
usage:
  -v  --verbose        Select verbose output
      --width=width    The width in pixels
      --height=height  The height in pixels
  -h  --help           Some helpful blurb
./getopt3 -v --width=1 --height=1 file1 file2 file3
The files are file1 file2 file3.
The width is 1.
The height is 1.
```

Overall opinion of the `getopt` section: the `GetOpt` library seems nice, would be nicer to stick to it even closer; and I don't get the point of the mutable reference that holds the options in a list. Other than the side effects like printing, imperative programming here seems unnecessary. So I think it's done just for the sake of demonstration. In the book's defense, we first did it with minimal imperativity / library usage in `getopt1.sml` so that's fair.

## Chapter 3: The Basis Library

### Preliminaries

#### The value restriction

Interesting: the book says

> The value polymorphism restriction is not something you will likely encounter. For the purposes of this book it mainly requires you to ensure that imperative variables using the `ref` type are restricted to contain a specific declared type.

Why is this interesting? I took [Programming Languages Part A](https://www.coursera.org/learn/programming-languages) by Dan Grossman from U. of Washington, on Coursera, to learn SML. This was mentioned mostly as an optional thing: "value restriction":

```sml
sml
Standard ML of New Jersey v110.79 [built: Sat Oct 26 12:27:04 2019]
val x = ref [];
stdIn:1.6-1.16 Warning: type vars not generalized because of
   value restriction are instantiated to dummy types (X1,X2,...)
val x = ref [] : ?.X1 list ref
- 
```

Here's what the course said:

> As described so far in this section, the ML type system is unsound, meaning that it would accept programs that when run could have values of the wrong types, such as putting an int where we expect a string. The  problem results from a combination of polymorphic types and mutable references, and the fix is a special  restriction to the type system called the value restriction. This is an example program that demonstrates the problem:
```sml
val r = ref NONE
(* ’a option ref *)
val _ = r := SOME "hi" (* instantiate ’a with string *)
val i = 1 + valOf(!r) (* instantiate ’a with int *)
```
> Straightforward use of the rules for type checking/inference would accept this program even though we should not – we end up trying to add `1` to `"hi"`. Yet everything seems to type-check given the types for the functions/operators `ref (’a -> ’a ref)`, `:= (’a ref * ’a -> unit)`, and `! (’a ref -> ’a)`. To restore soundness, we need a stricter type system that does not let this program type-check. The choice ML made is to prevent the first line from having a polymorphic type. Therefore, the second and third lines will not type-check because they will not be able to instantiate an `’a` with `string` or `int`.

Why is this called *value* restriction? Because it prevents values from being polymorphic. As a result, some `fun`s that can be written as `val`s get ruled out by this. The course said:

> Once you have learned currying and partial application, you might try to use it to create a *polymorphic
> function*. Unfortunately, certain uses, such as these, do not work in ML:

```sml
val mapSome = List.map SOME (* not OK *)
```

> Given what we have learned so far, there is no reason why this should not work, especially since all these
> functions do work:

```sml
fun mapSome xs = List.map SOME xs       (* OK *)
val mapSome = fn xs => List.map SOME xs (* OK *)
```

These ruled-out "function-values" are called *polymorphic functions types*, and interestingly, [they have been only recently added to Scala 3](https://docs.scala-lang.org/scala3/reference/new-types/polymorphic-function-types.html):

> A polymorphic function type is a function type which accepts type parameters. For example:

```scala
// A polymorphic method:
def foo[A](xs: List[A]): List[A] = xs.reverse

// A polymorphic function value:
val bar: [A] => List[A] => List[A]
//       ^^^^^^^^^^^^^^^^^^^^^^^^^
//       a polymorphic function type
       = [A] => (xs: List[A]) => foo[A](xs)
```

Does this mean Scala's type system is unsound now because of this? ([Probably not, at least in theory.](https://www.semanticscholar.org/paper/Type-soundness-for-dependent-object-types-(DOT)-Rompf-Amin/bcb109f4b7ba02a4172c012a39a578135d612cc8) Implementation is a different matter though.) The unsoundness comes when polymorphic values mix with mutation (`var` in Scala). 

However, Scala requires these polymorphic types to be *function types*; trying to replicate the above `sml` issue does not work. Here I'm trying to create a reference (`var`) to an optional value with a type parameter in it, and setting it to `None` initially (so it leaves the possibility of being `Option[String]` as well as `Option[Int]`):

```scala
scala> var spam: [T] => Option[T] = [T] => None
-- Error: ------------------------------------------------------------------------------------------------------------
1 |var spam: [T] => Option[T] = [T] => None
  |              ^
  |              Implementation restriction: polymorphic function types must have a value parameter
-- Error: ------------------------------------------------------------------------------------------------------------
1 |var spam: [T] => Option[T] = [T] => None
  |                                 ^
  |                           Implementation restriction: polymorphic function literals must have a value parameter
```

Yep, so that's ruled out already. Even if we *could* do this, we'd still have to instantiate the type parameter `T` with `Int` and `String` separately, so the situation where we're trying to add `1` to `"hi"` would not type-check. Moreover, Scala does not generalize type variables like `sml` does, instead it infers them to the "bottom type" `Nothing`:

```sml
 ➜ sml
Standard ML of New Jersey v110.79 [built: Sat Oct 26 12:27:04 2019]
val x = [];
val x = [] : 'a list (* left generalized as long as it's not a ref *)
```

```scala
scala> val y = List()
val y: List[Nothing] = List()
```

Even if we made `y` into a `var` and then tried to reassign an integer list to it, Scala won't allow it:

```scala
scala> var y = List()
var y: List[Nothing] = List()
scala> y = List(1)
-- [E007] Type Mismatch Error: ---------------------------------------------------------------------------------------
1 |y = List(1)
  |         ^
  |         Found:    (1 : Int)
  |         Required: Nothing
  |
  | longer explanation available when compiling with `-explain`
1 error found
```

The `sml` equivalent of this happens only for the `ref` types:

```sml
val y = ref [];
stdIn:2.5-2.15 Warning: type vars not generalized because of
   value restriction are instantiated to dummy types (X1,X2,...)
val y = ref [] : ?.X1 list ref
y := [1];
stdIn:3.1-3.9 Error: operator and operand don't agree [overload conflict]
  operator domain: ?.X1 list ref * ?.X1 list
  operand:         ?.X1 list ref * [int ty] list
  in expression:
    y := 1 :: nil
```

Scala requires concrete type variables to be provided for values. We cannot leave them generalized (because Scala has subtyping which `sml` does not, so Scala has to worry about [variance](https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science))):

```scala
scala> val z = List[T]()
-- [E006] Not Found Error: -------------------------------------------------------------------------------------------
1 |val z = List[T]()
  |             ^
  |             Not found: type T
  |
  | longer explanation available when compiling with `-explain`
1 error found
```

This is a general rule not limited to references (`var`). So I tried my best to break the Scala type system, but I cannot find any problem.

Anyway... interesting things happening in the functional world over the last 20 years huh?

But now that weird little side thing that was mentioned in the course becomes clearer, because that course used no imperative programming, and now we're doing a lot of imperative programming in the book. ***We have to always instantiate `ref` types to some concrete type.***

### General

### Option

### Bool

### Text

#### Byte

### Integer

### Real

### List

### Array and Vector

### Portable IO API

### POSIX API
