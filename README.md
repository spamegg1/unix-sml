# UNIX System Programming with Standard ML

## Getting Standard ML

### Basic installation on Linux, MacOS, Windows

```bash
sudo apt install smlnj # On Debian/Ubuntu and derivatives
sudo pacman -S smlnj   # On Arch and derivatives 
```

On Debian/Ubuntu, this will install the language in `/usr/lib/smlnj`. 

[Mac OS installer download link](http://smlnj.cs.uchicago.edu/dist/working/2022.1/smlnj-amd64-2022.1.pkg)

[Windows installer download link](http://smlnj.cs.uchicago.edu/dist/working/110.99.3/smlnj-110.99.3.msi)

### Libraries

You can also get all kinds of extra `sml` libraries and tools:

```bash
sudo apt install ml-yacc ml-lex ml-lpt libckit-smlnj libcml-smlnj libcmlutil-smlnj libexene-smlnj libmlnlffi-smlnj libmlrisctools-smlnj libpgraphutil-smlnj libsml-dev smlnj-doc
```

As a shortcut to install all available `smlnj` packages, you can use:

```bash
sudo apt install smlnj* *smlnj
```

### The REPL

The REPL is quite difficult to use because it does not support cycling through the history of commands with Up/Down arrow keys, or navigating left/right on the line of input with Left/Right arrow keys. To fix these issues, you should install `rlwrap`:

```bash
sudo apt install rlwrap # Debian/Ubuntu
sudo dnf install rlwrap # Fedora
sudo pacman -S rlwrap   # Arch
brew install rlwrap     # MacOS users can get it on Homebrew: https://brew.sh
```

(Windows users are screwed. [`rlwrap`](https://github.com/hanslub42/rlwrap) is not easily available as far as I know. I looked at [Chocolatey](https://chocolatey.org/), [Scoop](https://scoop.sh/), [Ninite](https://ninite.com/) and [Winget](https://winget.run/); none of them have it. You'd have to compile from source, which I don't expect to be easy on Windows.)

Now you should make an alias in your `~/.bash_aliases` file:

```bash
alias sml='rlwrap sml'
```

This applies to other ML implementations too (mentioned below):

```bash
alias poly='rlwrap poly'
alias ocaml='rlwrap ocaml'
alias alice='rlwrap alice'
alias mosml='rlwrap mosml'
alias smlsharp='rlwrap smlsharp'
```

### Other systems and ML's

#### Fedora

Fedora repositories do not have `smlnj`. You will have to [install](https://www.smlnj.org/dist/working/2021.1/install.html) from [source](http://smlnj.cs.uchicago.edu/dist/working/2021.1/config.tgz). 

#### Adventures in ML Wonderland

Even more adventurous options below!

#### Poly/ML

There is [Poly/ML](https://www.polyml.org/index.html) on [Fedora](https://packages.fedoraproject.org/pkgs/polyml/polyml/), Debian and Arch: 

```bash
sudo apt install polyml # Debian/Ubuntu
sudo dnf install polyml # Fedora
sudo pacman -S polyml   # Arch
```

but it does not come with the SML/NJ libraries the book uses. You'll have to compile/install them from [source](https://github.com/eldesh/smlnjlib-polyml). Not easy. [Has](https://github.com/eldesh/mllex-polyml) [dependencies](https://github.com/eldesh/mlyacc-polyml) that have [build issues](https://github.com/eldesh/mlyacc-polyml/issues/3). Then you should be good.

With Poly/ML you can fire up a REPL just like `sml`, but with the `poly` command instead. Normal `sml` syntax works, like `use "myfile.sml";`. You can use [the `polyc` command](https://www.polyml.org/FAQ.html#standalone) to create executables, but you need to install the development libraries (`libpolyml-dev` package on Ubuntu). I was able to compile a hello world program to an executable successfully. Not sure how it works when the SML/NJ library is involved.

#### MLton

[MLton](http://mlton.org/) (available on [Fedora](https://packages.fedoraproject.org/pkgs/mlton/mlton/) and Arch, not on Debian/Ubuntu): 

```bash
sudo dnf install mlton # Fedora
sudo pacman -S mlton   # Arch
```

I was able to compile and install from [source](https://github.com/MLton/mlton) on Ubuntu, with

```bash
sudo make
sudo make install
```

and it was installed under `/usr/local/lib/mlton` and it really does have ([a port of](http://mlton.org/SMLNJLibrary)) the [SML/NJ library](https://www.smlnj.org/doc/smlnj-lib/index.html) under `/usr/local/lib/mlton/sml/smlnj-lib`. I was able to compile a hello world program, but running it does not print anything. Don't know why.

MLton is all about compile-optimizing the whole program, so it does not have a convenient REPL. This is a huge downside for going through the book. But you can make executables with it. There is also support for SML/NJ's Compilation Manager in [MLton](http://mlton.org/CompilationManager) (it has to port `.cm` files to its own format first). It has the `SMLofNJ` structure with the `exportFn` function we'll use below. So if you don't mind the absence of a REPL and you're OK with the "edit/compile/edit/compile" cycle way of doing things, then it might work for you.

#### OCaml

Of course there is also [OCaml](https://www.ocaml.org/) but it's an entirely different language at this point (take a look into `/usr/lib/ocaml` and compare it to `/usr/lib/smlnj/lib`). It's available on Debian, Fedora and Arch:

```bash
sudo apt install ocaml # Debian/Ubuntu
sudo dnf install ocaml # Fedora
sudo pacman -S ocaml   # Arch
```

It would be interesting to do this book with OCaml, but it would be a lot of work, more of an "adaptation" of this book rather than simply going through it. However you might find that many things are much easier to do with OCaml, since it's an industrial language and probably has better support for a lot of things out of the box. There are WAY MORE library packages on Ubuntu for `ocaml` than `sml`.

#### SML# (SMLsharp)

Available only on Debian/Ubuntu (not on Fedora or Arch):

```bash
sudo apt install smlsharp
```

This gets me the latest version 4.0.0.

I couldn't get it to work, it wants LLVM version 13, even though I have 14. After manually installing LLVM 13 and also `libmassivethreads-dev` at least it works. 

I stand corrected: [it is available on other systems](https://github.com/smlsharp/repos): CentOS, Fedora, MacOS via [Homebrew](https://brew.sh), and Windows (via WSL2, like Ubuntu).

```bash
brew tap smlsharp/smlsharp # for Mac OS, but should
brew install smlsharp      # also work on any Linux
```
One very interesting aspect of SML# is ["record polymorphism"](https://smlsharp.github.io/en/about/features/) which was mentioned as a hypothetical type system feature in some of the exam questions in [Programming Languages Part A](https://www.coursera.org/learn/programming-languages) course on Coursera.

Does that look like a REPL? 

```sml
 ➜ smlsharp
SML# unknown for x86_64-pc-linux-gnu with LLVM 13.0.1
# "hello world";
val it = "hello world" : string
# 5+9;
val it = 14 : int
#
```
Very nice (needs the `rlwrap` treatment). But I could not compile a hello world program. It said `unbound variable: print`! Can you believe it? Looks like I have to do something similar to SML/NJ's `.cm` files. I need a `hello.smi` that says `_require "basis.smi"`.

Nope, still no:

```bash
 ➜ smlsharp hello.sml -o hello
command failed at status 256: gcc -Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -flto=auto -Wl,-z,relro -Wl,-z,now /usr/lib/smlsharp/runtime/main.o /tmp/tmp.2q9kvI/000009.o /tmp/tmp.2q9kvI/000013.a /usr/lib/smlsharp/runtime/libsmlsharp.a -lrt -ldl -lm -lgmp -lmyth -lpthread  -o hello
lto1: fatal error: bytecode stream in file ‘/usr/lib/smlsharp/runtime/main.o’ generated with LTO version 11.2 instead of the expected 11.3
compilation terminated.
lto-wrapper: fatal error: gcc returned 1 exit status
compilation terminated.
/usr/bin/ld: error: lto-wrapper failed
collect2: error: ld returned 1 exit status
```

There must be a way to turn off "link time optimization" in `gcc` by default. Anyway, moving on...

#### Moscow ML

I was able to find and install a [`.deb` file](https://ppa.launchpadcontent.net/kflarsen/mosml/ubuntu/pool/main/m/mosml/mosml_2.10.2-0ubuntu0_amd64.deb) from January 2021, even though the [PPA repository](https://launchpad.net/~kflarsen/+archive/ubuntu/mosml) does not support Ubuntu 22.04. That was relatively easy. Not available on Fedora or Arch. You'd have to install from [source](https://github.com/kfl/mosml).

It has a REPL! (You should do the `rlwrap` trick with this one too.) Nice.

```sml
➜ mosml
Moscow ML version 2.10
Enter `quit();' to quit.
- 2+2;
> val it = 4 : int
- List.map (fn x => x*x) [1,2,3];        
> val it = [1, 4, 9] : int list
- quit();
```

#### MLkit

Another compiler and toolkit (no REPL). Extremely easy to install on Linux and MacOS. [Get the binary release](https://github.com/melsman/mlkit/releases/tag/v4.7.2), unzip, do `sudo make install`. It just copies the binaries to your `/usr/local/bin/mlkit` directory.

#### AliceML

Quite difficult to install. Has to be compiled [from source](https://github.com/aliceml/aliceml). The instructions *almost* worked... compilation failed after 12 minutes. It seems to fail regarding [Gecode](https://www.gecode.org/). But it seems to have built most of the binaries already, just not all of them. *Edit:* the developer [responded within hours](https://github.com/aliceml/aliceml/issues/22) and fixed the issue.

Is that a REPL? We use the `alice` command (once again, it needs the `rlwrap` treatment):

```sml
 ➜ alice
Alice 1.4 ("Kraftwerk 'Equaliser' Album") mastered 2022/11/15
### loaded signature from x-alice:/lib/system/Print
### loaded signature from x-alice:/lib/tools/Inspector
### loaded signature from x-alice:/lib/distribution/Remote
- 2+2;
val it : int = 4
- List.map (fn x => x*x) [1, 2, 3];
val it : int list = [1, 4, 9]
- 
That's all, said Humpty Dumpty. Good-bye.
```

Very funny :laughing: Reference to Kraftwerk is also super cool. However we probably cannot use it for this book due to [its known limitations](https://www.ps.uni-saarland.de/alice/manual/limitations.html) which include the `OS.FileSys, OS.IO, Unix` and `StreamIO` structures and functors heavily used by the book.

#### Standard ML Package Manager

What? [That's awesome!](https://github.com/diku-dk/smlpkg) So I can just install libraries easy peasy? Extremely easy to install on Linux and MacOS: [Get the binary release](https://github.com/diku-dk/smlpkg/releases/tag/v0.1.5), unzip, then `sudo make install` and it just copies the binary to `/usr/local/bin`.

Okay, there are 19 packages listed, I'm gonna install all of them! See what happens! Looking at one of them:

> This library is set up to work well with the SML package manager [smlpkg](https://github.com/diku-dk/smlpkg).  To use the package, in the root of your project directory, execute the command:
>
> ```bash
> $ smlpkg add github.com/diku-dk/sml-aplparse
> ```

Ah, OK, I get it now. It's not "global" installation. Project-based instead. That's fine and still useful. Maybe I'll turn this repository into a package and release it at some point!

#### What I have

I have successfully installed: `smlnj, poly, ocaml, mlton, mlkit, smlsharp, smlpkg, alice` on Ubuntu, but I'll stick to SML/NJ.

#### Parts that might not work

The parts of the book that are SML/NJ specific might not work on other ML implementations. The Compilation Manager (and the `.cm` files) to create executables, for example. As I mentioned above, you can try to use alternate methods (such as `polyc` or `mlton` or `smlsharp`) but you'll have to figure out those on your own. I think Poly/ML is the most promising alternative but you have to get over the hurdles of installing the SML/NJ library. Poly/ML site says that it supports 100% of Standard ML as defined in the 1997 definition. Huh... turns out SML/NJ [deviates from the definition](http://mlton.org/SMLNJDeviations) but Poly/ML and MLton do not. Interesting! So much for "Standard" ML :laughing: But some of the deviations actually make sense and seem useful. 

## Changes since 2001

Since the book is 22 years old (now in 2023), the Compilation Manager (`CM` from now on) of Standard ML (`sml` from now on) has changed quite a bit.

The reference you need is the revised [Compilation Manager book](https://www.smlnj.org/doc/CM/new.pdf). It says the new `CM` is in effect since version 110.20, and I'm using `sml` version 110.79 on Ubuntu 22.04.

You'll see some of the changes required below, as I go through the book.

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

It's working properly! :confetti_ball: :tada: :partying_face:

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
fun show_stuff(files: string list, width: string, height: string): unit = (
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
        !opt_tbl is: [...]: list           *)
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

    fun show_stuff(files: string list, width: string, height: string): unit = (
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
    handle Usage msg => (
        toErr msg;
        toErr "\n";
        usage();
        toErr "\n";
        OS.Process.failure
    )

    val _ = SMLofNJ.exportFn("getopt3", main)
end
```

(One thing to note is that, `TextIO.output` is actually "inherited" from  `StreamIO` structure.)

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

Yep, for some reason he keeps using names that clash with SML/NJ library, such as `Option`. I'm changing it to `Common` instead.

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

#### The value restriction: a fun digression

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
val y: List[Nothing] = List() // not generalized, inferred to Nothing instead
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

Anyway... interesting things happening in the functional world over the last 20 years huh? **Digression over.**

But now that weird little side thing that was mentioned in the course becomes clearer, because that course used no imperative programming, and now we're doing a lot of imperative programming in the book. ***We have to always instantiate `ref` types to some concrete type.***

### General

Some stuff from the [General structure](https://smlfamily.github.io/Basis/general.html) mentioned here. `exnName` and `exnMessage`, `!` for dereferencing and `:=` for assignment, `o` for function composition, and the `before` function, which I didn't know about!

The `Fatal` and `InternalError` exceptions the author mentions are not found anywhere in the `sml` library. So I manually defined them in the big code example:

```sml
exception Fatal
exception InternalError of string
```

I had to supply a lot of other stuff too:

```sml
fun process(args: string list): unit = () (* dummy, for demonstration *)
fun toErr(msg: string): unit = TextIO.output(TextIO.stdErr, msg)
fun f(): unit = () (* dummy *)
```

Just keep in mind, to make the code type-check and compile, you have to provide missing stuff yourself.

### Option

Not much here: `valOf, isSome`. There is one interesting thing: the mention of *equality types.*

We cannot compare an optional function value to, say, `NONE` by using plain equality `=`:

```sml
- val z = SOME (fn x => x);
val z = SOME fn : ('a -> 'a) option
- z = NONE;
stdIn:25.1-25.9 Error: operator and operand
don’t agree [equality type required]
    operator domain: ''Z * ''Z
    operand:         ('Y -> 'Y) option * 'X option
in expression:
z = NONE
- Option.isSome z;
val it = true : bool
```

Notice `equality type required`. What's an equality type? It's similar to how you can use typeclass derivation like `deriving Eq` in Haskell or `derives CanEqual` in Scala 3. In `sml` we do this by using double single-quotes before a type annotation like `''a`.  It still doesn't help us with the above problem though. We could define instead:

```sml
val z: (''a -> ''a) option = SOME(fn x => x);
```

but `NONE` itself is `'X option`, which is not an equality type; so we cannot change that!

### Bool

Not much here, just `Bool.toString` and `Bool.fromString`.

### Text

Lots of stuff here. Many structures: [`String`](https://smlfamily.github.io/Basis/string.html), [`Char`](https://smlfamily.github.io/Basis/char.html) [`Text`](https://smlfamily.github.io/Basis/text.html), [`Substring`](https://smlfamily.github.io/Basis/substring.html) [`StringCvt`](https://smlfamily.github.io/Basis/string-cvt.html) and so on. Interesting bits about performance. It seems that `Substring.all` that is mentioned in the book has been renamed to `Substring.full` in my version of `sml`.

Now we get to the good hard stuff: streams. We'll be processing text data in the form of streams, and use transformer functions (a bit reminiscent of monad transformers from Haskell). Character streams can come from a `string` via `StringCvt.scanString` or from a file via `TextIO.scanStream`. The code is quite complicated.

The author uses a multi-line string literal that I haven't seen before in `sml`: 

```sml
val text = "\
            \ 123 true 23.4        \n\
            \ -1 false -1.3e3      \n\
            \"
```

and the VS Code plug-in cannot do syntax coloring correctly. The rest of the code that comes after this string gets recognized as a string (probably a bug in the plug-in, with the regular expressions that define its comments?). But the code type-checks fine. You can run it, to see that it's correctly reporting the `int`, the `bool` and the `real` inside the text:

```sml
main("", []);
123 true 23.4
val it = 0 : OS.Process.status
- 
```

I reported it to the [extension developer](https://github.com/vrjuliao/sml-vscode-extension/issues/18).

#### Bytes

Not much here. [Some conversion functions.](https://smlfamily.github.io/Basis/byte.html) Will be used for reading from, and writing to, TCP/IP sockets.

### Integer

Interesting bit about `sml`'s garbage collector and the weird 31-bit integers. LSB (least significant bit) is used by the GB to tell whether it's a pointer or not. So `int` is actually 31-bit. Some useful conversion functions `toInt, fromInt, toString, fromString, toLarge, fromLarge` etc. 

And typical arithmetical operators. Note that `sml` does not auto-convert `int`s to `float`s when you are doing division. The `/` is reserved for `real`s whereas for `int`s you have to use the `div` operator. I'm familiar with this from Haskell. Implicit conversions can break the type-system, so it's a reasonable trade-off and only a small inconvenience.

```sml
- 5/2;
stdIn:11.1-11.4 Error: operator and operand don't agree [overload conflict]
  operator domain: real * real
  operand:         [int ty] * [int ty]
  in expression:
    5 / 2
- 5 div 2;
val it = 2 : int
- 
```

Hey, we can use hexadecimal with `x` in `sml`! Who knew? Also `word` and hexadecimal `word` with the `w`:

```sml
- val i: int = 0x123;
val i = 291 : int
- val j: word = 0w12345;
val j = 0wx3039 : word
- val k: word = 0wx12345;
val k = 0wx12345 : word
- 
```

VS Code plug-in again fails to correctly syntax-color these. [Reported!](https://github.com/vrjuliao/sml-vscode-extension/issues/17)

### Real

In `sml` the `real` type is not an equality type! So we cannot use the usual `=` or `<>` for comparing `real`s. The documentation has [some explanation about this](https://smlfamily.github.io/Basis/real.html#Real:STR:SPEC):

> Deciding if `real` should be an equality type, and if so,  what should equality mean, was also problematic. IEEE specifies that the sign of zeros be ignored in comparisons, and that equality evaluate to  false if either argument is `NaN`. These constraints are disturbing to the SML programmer. The former implies that `0 = ~0` is true while `r/0 = r/~0` is false. The latter implies such anomalies as `r = r` is false, or that, for a ref cell `rr`, we could have `rr = rr` but not have `!rr = !rr`. We accepted the unsigned comparison of zeros, but felt that the  reflexive property of equality, structural equality, and the equivalence of `<>` and `not o =` ought to be preserved. Additional complications led to the decision to not have `real` be an equality type.

The good news is that we can use `Real.==` and `Real.!=`; moreover the top-level `<, >, <=, >=` are still available.

### List

Just normal list stuff. The `@` operator concatenates two lists, but it has to copy the first argument, so it's not efficient:

```sml
- [1,2] @ [3,4];
val it = [1,2,3,4] : int list
```

The `cons` operator `::` is efficient (but it only adds 1 element to the left of the list). There are some useful functions that the book recommends:

```sml
val revAppend : 'a list * 'a list -> 'a list
val app : ('a -> unit) -> 'a list -> unit
val tabulate : int * (int -> 'a) -> 'a list
```

The [`ListPair` structure](https://smlfamily.github.io/Basis/list-pair.html) is super useful, I used it a lot in my [pattern matching exercise in Programming Languages Part A](https://github.com/spamegg1/reviews/blob/master/courses/ProgLangA/week4/hw3/).

### Array and Vector

Not much to say here. There are specialized types such as `CharArray` and `CharVector`.

### Portable IO API

This is the most interesting part. Lots of `IO` interfaces here: `PRIM_IO, OS_PRIM_IO, TEXT_IO, BIN_IO, TEST_STREAM_IO, IMPERATIVE_IO, STREAM_IO` with various relationships between them. And these are *just the signatures.* There are way more *structures:* `BinPrimIO, TextPrimIO, PosixBinPrimIO, Posix.IO, PosixText.IO, PosixTextPrimIO,...` The list goes on.

The documentation calls `StreamIO` a FUNCTOR. Now we're talking. A functor is not a monad but close enough.

The book says: 

> Input streams are handled in a lazy functional manner. This means that streams are read from only upon demand (as you would expect) and the read returns a stream updated at a new position. So you can read from the same stream value multiple times and it always returns the same data from the same position. Output streams are imperative. Each write will append new data to the output stream.

I bet this will bite us in the ass somewhere down the line, requiring a workaround. Otherwise very useful.

As it became a theme already, the code examples have a lot of missing stuff, undefined functions which lead to `unbound variable or constructor` errors in `sml`, so they have to be supplied by hand.

On page 87 there is code with a `let` block that's empty (also `count` is missing):

```sml
fun main(arg0: string, argv: string list): OS.Process.status =
let
    (* there is nothing here *)
in
    case argv of
        [] => count TextIO.stdIn ""
    |   (file :: _) =>
        let
            val strm = TextIO.openIn file
        in
            (count strm file) handle x => (TextIO.closeIn strm; raise x);
            TextIO.closeIn strm
        end;
    OS.Process.success
end
```

This looks strange but it is equivalent to putting parentheses around the `case` block. If we want to do a bunch of side effects followed by a return value, like:

```sml
a();
b();
c();
OS.Process.success
```

then we can either use the "empty let block" approach like above, or put parentheses around it. For example:

```sml
fun main(arg0: string, argv: string list): OS.Process.status = (
    a();
    b();
    c();
    OS.Process.success
)
```

Otherwise it won't type-check. Also, if we want the block to be followed by a `handle` block, we need the parentheses (or a `let-in-end` block).

The `count` function is shown later in the book. Now we can add it above `main`. There must have been another change in the language API (or another typo in the book), because on page 89 this part:

```sml
case TextIO.inputLine strm of
    "" => (nchars, nwords, nlines)
```

 gives an error:

```sml
Error: case object and rules don't agree [tycon mismatch]
  rule domain: string
  object: string option
  in expression:
    (case (TextIO.inputLine strm)
      of "" => (nchars,nwords,nlines)
       | line => let val <pat> = <exp> in read (<exp>,<exp>,<exp>) end)
```

So `TextIO.inputLine strm` returns an `option` in the current `sml`. We can fix the issue like so:

```sml
case TextIO.inputLine strm of
            NONE => (nchars, nwords, nlines) (* no lines left in file *)
        |   SOME(line) => ...
```

and everything type-checks! :white_check_mark:

I don't like the book's style of nesting functions, so I take them out (and pass the parameters of the top-function). I also remove the author's paranoid redundant parentheses everywhere. This is much nicer:

```sml
fun read(strm: TextIO.instream)(nchars: int, nwords: int, nlines: int)
: int * int * int =
    (* This ensures the line ends with a \n unless we are at eof. *)
    case TextIO.inputLine strm of
        NONE => (nchars, nwords, nlines)
    |   SOME(line) =>
        let
            val words = String.tokens Char.isSpace line
        in
            read strm (nchars + size line, nwords + length words, nlines + 1)
        end

fun count(strm: TextIO.instream)(file: string): unit =
let
    val (nchars, nwords, nlines) = read strm (0, 0, 0)
in
    print(concat[
        Int.toString nlines, " ",
        Int.toString nwords, " ",
        Int.toString nchars, " ",
        file,
        "\n"
    ])
end
```

We can load it up on the REPL and use it. It reports the correct number of lines, words, characters:

```sml
use "portable-io.sml";
[opening portable-io.sml]
val toErr = fn : string -> unit
val read = fn : TextIO.instream -> int * int * int -> int * int * int
val count = fn : TextIO.instream -> string -> unit
val main = fn : string * string list -> OS.Process.status
val it = () : unit
main("", ["int.sml"]);
4 20 87 int.sml
val it = 0 : OS.Process.status
```

Again, if we wanted, we could write a `.cm` file and build it with `ml-build` and launch it with a script, so we'd have our own version of Unix utility `wc` written in `sml`! Neat. It's possible the author is implicitly assuming that we are doing that. I'll make the executables when we get to the more serious stuff.

### Portable OS API

Another very important part of the library! We have `OS.FileSys, OS.Path, OS.Process` (which we've been using a lot already), the [Time and Date stuff](https://smlfamily.github.io/Basis/time.html) and finally the operating-system-dependent [`Unix` structure](https://smlfamily.github.io/Basis/unix.html).

We have another long code example with things that need to be fixed. At the bottom of page 91

```sml
case FS.readDir strm of
    "" => rev files (* done *)
    | f =>
```

we have a problem similar to the above; these cases need to be `NONE` and `SOME(...)`. (So in this case [`FS.readDir`](https://smlfamily.github.io/Basis/os-file-sys.html#SIG:OS_FILE_SYS.readDir:VAL) has changed.)

There are many nested functions calling each other, and recursion, here, not to mention the total lack of type signatures to figure things out, it was tough taking them out and making it still work. The author really has a messy C-ish style.

Anyway, it all type-checks and compiles! Now for the big showdown:

```sml
use "filesys.sml";
[opening filesys.sml]
structure FS : OS_FILE_SYS
structure OP : OS_PATH
val toErr = fn : string -> unit
exception Error of string
val open_dir = fn : string -> ?.OS_FileSys.dirstream
val get_files = fn
  : string -> ?.OS_FileSys.dirstream -> string list -> string list
val show_wx = fn : string -> unit
val scan_dir = fn : string -> unit
val main = fn : string * string list -> OS.Process.status
val it = () : unit
main("", []);
val it = 0 : OS.Process.status
```

Oh no... it's supposed to print the files in the current directory. Well that fizzled out quickly didn't it? The author says:

> The `show_wx` function prints the file name if it is writable and executable.

Turns out none of the files satisfy this check (here `FS` is short for `OS.FileSys`):

```sml
if FS.access(file, [FS.A_WRITE, FS.A_EXEC]) then ...
```

Let's take a look at the "access mode" things:

```sml
datatype access_mode = A_READ | A_WRITE | A_EXEC
```

So I'll just change the code to use `FS.A_READ` only:

```sml
- main("", []);
./text.sml
./filesys.sml
./general.sml
./option.sml
./bool.sml
./portable-io.sml
./int.sml
val it = 0 : OS.Process.status
- 
```

YAY! :confetti_ball: :tada: :partying_face: It also works in nested directories, prints all the files with their paths.

### POSIX API

Lots and lots of stuff here! There are so many structures, types and functions it's dizzying: `Posix.FileSys, Posix.SysDB, Posix.ProcEnv`, and we are also using `SysWord, Date, Position, StringCvt`. 

#### Posix.FileSys

We can change file permissions with `Posix.FileSys.chmod`. The [`Posix.FileSys` signature](https://smlfamily.github.io/Basis/posix-file-sys.html) has weird sub-structure names, like `S` or `O` or `ST`. 

There is code for a `stat` function that is a simplified version of the Unix `stat` utility. Again, missing code and functions are introduced later. I am seeing the use of `local` for the first time in `sml` here (here `FS` is `Posix.FileSys`):

```sml
local
    val type_preds: ((stat -> bool) * string) list = [
        (FS.ST.isDir, "Directory"),
        (FS.ST.isChr, "Char Device"),
        (FS.ST.isBlk, "Block Device"),
        (FS.ST.isReg, "Regular File"),
        (FS.ST.isFIFO, "FIFO"),
        (FS.ST.isLink, "Symbolic Link"),
        (FS.ST.isSock, "Socket")
    ]
in
    fun filetypeToString(st: stat) =
    let
        val pred = List.find (fn (pr, _) => pr st) type_preds
    in
        case pred of
            SOME (_, name) => name
        |   NONE => "Unknown"
    end
end
```

The book says:

> I’ve put the list of predicates within a local block so that it is private to `filetypeToString` without being inside it. This way the list isn’t built every time that the function is called, which is wasteful. This doesn’t matter on this small program but it very well might in other programs.

That's useful! This is used many times later.

On page 101 there is a typo `pun` which should be `fun`. Maybe it's a pun intended?

Lots of helper functions for `stat`. The code as presented in the book type-checks, but it's impossible to understand what's happening. To add my type annotations and make it all type-check, I had to track down a lot of types:

```sml
Posix.FileSys.S.flags (* an alias for mode *)
Posix.FileSys.S.mode 
Posix.FileSys.ST.stat
Posix.FileSys.uid
Posix.FileSys.gid
Posix.ProcEnv.uid
Posix.ProcEnv.gid
Posix.SysDB.uid
Posix.SysDB.gid
```

The code is displayed first, and all these structures are explained in later sections, so it's quite confusing.

Well, it *does* work:

```sml
main("", ["myfile"]);
File: myfile
Size: 123
Type: Regular File
Mode: 644/rw-r--r--
Uid: 1000/spam
Gid: 1000/spam
Device: 3,1
Inode: 1838772
Links: 1
Access: Wed Nov 16 23:47:57 2022
Modify: Thu Nov 17 13:34:51 2022
Change: Thu Nov 17 13:34:51 2022
val it = 0 : OS.Process.status
```

:confetti_ball::tada: :partying_face: 

#### Posix.IO

Now we get to the more monadic stuff.

It looks like `PosixTextPrimIO` and `PosixBinPrimIO` do not exist anymore, they were ["lifted" to `Posix.IO`](https://smlnj.sourceforge.net/NEWS/110.46-README.html) instead. Apparently this happened in 2004! So here are the changes:

| Old (book, 2001)           | New (2004-now)         |
| -------------------------- | ---------------------- |
| `PosixBinPrimIO.mkReader`  | `PosixIO.mkBinReader`  |
| `PosixBinPrimIO.mkWriter`  | `PosixIO.mkBinWriter`  |
| `PosixTextPrimIO.mkWriter` | `PosixIO.mkTextReader` |
| `PosixTextPrimIO.mkWriter` | `PosixIO.mkTextWriter` |

Very sensible. If we make these changes, the code on page 102 type-checks. 

The top part on page 103 still does not work. This code is supposed to be directly taken from the `Unix` structure; the code must have changed a lot since then, since I could not find it in the source code or the documentation. The `openOutFD` and `openInFD` functions don't exist anymore; they were probably renamed to `openOut` and `openIn`.

`TextIO.StreamIO.mkInstream` does not accept `NONE` as its second argument, though. The type-checker wants a `TextIO.StreamIO.vector` which, in this case, [is a `string`!](https://smlfamily.github.io/Basis/stream-io.html#SIG:STREAM_IO.vector:TY) The correct version is now

```sml
fun openInFD(name: string, fd: Posix.IO.file_desc): TextIO.instream =
    TextIO.mkInstream(
        TextIO.StreamIO.mkInstream(fdReader(name, fd), "")
    )
```

Next we see the code for [`Unix.executeInEnv`](https://smlfamily.github.io/Basis/unix.html#SIG:UNIX.executeInEnv:VAL). I'm guessing this is also too old and must have changed since 2001. It's quite long, 1.5 pages! A few typos again on page 104 (a parenthesis that gets opened after `startChild` but never gets closed). `Substring.all` needs to be changed to `Substring.full` again (happened before). 

There is surprisingly little explanation for this long code. Again the structures that are used are explained in *later sections.* I have to figure out where `protect` is coming from in

```sml
fun startChild () =
(
    case protect P.fork() of
        SOME pid => pid      (* parent *)
```

because the compiler cannot find it. `protect` does not exist anywhere in the documentation. It must have been removed or renamed to something else. `Posix.Process.fork()` already returns a `pid option` so I'm just gonna remove `protect` here.

At the end of the code, in the returned value, there is a reference to `PROC`:

```sml
PROC {
    pid = pid,
    ins = ins,
    outs = outs
}
```

but I have no idea what it is. I thought it's a reference to an earlier alias `structure PROC = Posix.ProcEnv` but I cannot find anything [in that structure](https://smlfamily.github.io/Basis/posix-proc-env.html) that fits. `executeInEnv` is supposed to return a `('a, 'b) proc` type, which I don't know how to create. There were big overhauls to the `Unix` structure in 2004. Can't figure it out, moving on. *It's a mystery!* 

#### Posix.Process, Posix.ProcEnv, Posix.SysDB

These are used above in `Posix.FileSys` and `Posix.IO`, here only given a single paragraph.

#### Posix.TTY

The author uses shorthands without telling: `TTY` refers to `Posix.TTY`. The code example here gives a lot of `unbound variable` errors:

```sml
posix-tty.sml:7.16-7.27 Error: unbound variable or constructor: getattr in path TTY.getattr
posix-tty.sml:15.18-15.31 Error: unbound variable or constructor: getospeed in path TTY.getospeed
posix-tty.sml:14.18-14.31 Error: unbound variable or constructor: getispeed in path TTY.getispeed
posix-tty.sml:18.5-18.16 Error: unbound variable or constructor: setattr in path TTY.setattr
```

Some of these functions are inside substructures of [`Posix.TTY`](https://smlfamily.github.io/Basis/posix-tty.html) named `TC` and `CF`. So the API must have changed. The author was aware of this back in 2001:

> Note that at the time of writing this, the Basis library documentation for `Posix.TTY` doesn’t match SML/NJ version 110.0.7. In version 110.0.7 there is no internal structure called `Posix.TTY.CF`. Its contents appear directly in `Posix.TTY`. Similarly these functions which should be in the `Posix.TTY.TC` structure appear directly in `Posix.TTY: getattr, setattr, sendbreak, drain, flush`, and `flow`.

## Chapter 4: The SML/NJ Extensions

So here we are finally! I'd like to know if it's possible to use these in Poly/ML or MLton. I'll give it a try at least on the `poly` REPL later.

### The Unsafe API

### Signals

### The SMLofNJ API

### The Socket API

## Chapter 5: The Utility Libraries

### Data Structures

### Algorithms

### Regular Expressions

### Other Utilities

## Chapter 6: Concurrency

### Continuations

### Coroutines

### The Concurrent ML Model

### A Counter Object

### Some Tips on Using CML

### Getting the Counter's Value

### Getting the Value Through an Event

### Getting the Value with a Time-Out

### More on Time-Outs

### Semaphores

### Semaphores via Synchronous Variables

## Chapter 7: Under the Hood

### Memory Management

#### Garbage Collection Basics

#### Multi-Generational GC

#### Run-Time Arguments for the GC

#### Heap Object Layout

### Performance

#### Basic SML/NJ Performance

### Memory Performance

#### CML Channel Communication and Scheduling

#### Spawning Threads for Time-outs

#### Behaviour of Timeout Events

## Chapter 8: The Swerve Web Server

### Introduction

### The HTTP Protocol

### The Resource Store

### Server Configuration

### The Architecture of the Server

### Building and Testing the Server

## Chapter 9: The Swerve Detailed Design

### Introduction

### The Organization of the Code

### The Main Layer

### The Server Layer

### The Store Layer

### The IETF Layer

### The Config Layer

### The Common Layer

## Chapter 10: Conclusion

The author gives quite the praise to FP (functional programming):

>Functional languages certainly scale to the size of real-world projects by nature. The productivity improvement from a functional language allows a programmer to tackle much larger projects. I estimate at least a 10 to 1 improvement in productivity over the C language just from a reduction in the number of lines of code needed. There is a large productivity boost from the absence of memory management bugs and the like that plague C programs. Further the strong static type system often means that sizable pieces of SML code just works first time.

These are very obvious points, but I didn't expect a [lifelong C programmer](http://www.anthony-shipman.id.au/resume/resume.html) from the old days to say this. The author is surely open-minded and objective about it! In fact he was open-minded all the way back in 2000 when FP wasn't even known all that much (now it's getting a lot more popular). Usually old-school C programmers don't like FP.

> ...SML/NJ does perform well. Without much trouble it achieved around 2/3 the speed of Apache, which is written in C. Anecdotal evidence has it that C++ is about 1/2 the speed of C. ...This suggests that SML/NJ can certainly compete with C++ or Java.

Wow. I wonder how much things improved since 2001. Those other languages must have improved quite a lot too. MLton is definitely the fastest ML out there.

> The big impediment to wider use of SML in the real-world is support for features such as databases, graphics, encryption, native languages (Unicode), true concurrency etc.

Valid points. SMLsharp [focuses](https://smlsharp.github.io/en/about/features/) on the databases part, especially SQL; and the concurrency part. Poly/ML addresses [concurrency](https://www.polyml.org/documentation/Reference/Thread.xml). [AliceML](https://www.ps.uni-saarland.de/alice/) addresses SQL and GTK, and addresses concurrency with futures and laziness. There are also `sml` to `js` converters in many ML implementations, such as [MLkit](https://github.com/melsman/mlkit#smltojs---the-javascript-backend). As for encryption and Unicode, there are [Unicode](https://github.com/diku-dk/sml-unicode) and [SHA-256](https://github.com/diku-dk/sml-sha256) packages available through [`smlpkg`](https://github.com/diku-dk/smlpkg).

> The standard basis library is looking rather dated. It hasn’t progressed in years. A future release of SML/NJ will include a native C-language interface.

Is this true in 2023? I think this is referring to the "Foreign Function Interface". Yes, it exists [now](https://www.smlnj.org/doc/SMLNJ-C/index.html). There is a library package `libmlnlffi-smlnj` ([No Longer Foreign Function Interface](http://www.jeffvaughan.net/docs/nlffi.pdf)) on Ubuntu, which installs under `/usr/lib/smlnj/lib/c` and a lot of documentation under `/usr/share/doc/libmlnlffi-smlnj`, and a binary executable `ml-nlffigen` that generates glue code between C and `sml`:

```bash
 ➜ ccat /usr/share/doc/libmlnlffi-smlnj/README
This is the ML-NLFFI Library, the core of a new foreign-function
interface for SML/NJ.

Library $c/c.cm provides:

  - an encoding of the C type system in ML
  - dynamic linking (an interface to dlopen/dlsym)
  - ML/C string conversion routines

  This is the (only) library to be used by user code.

Library $c/c-int.cm (subdirectory "internals"):

  - implements all of $c/c.cm
  - implements low-level hooks to be used by ml-nlffigen-generated code

Library $c/memory.cm (subdirectory "memory"):

  - encapsulates low-level details related to raw memory access

  User code should NOT directly refer to this library.
```

Similar FFIs are also available in [Poly/ML](https://www.polyml.org/documentation/Reference/Foreign.xml) and [MLton](http://mlton.org/ForeignFunctionInterface). SML# [seems to have one too.](https://smlsharp.github.io/en/about/features/) So does [Moscow ML](https://mosml.org/). So does [MLkit](https://elsman.com/mlkit/). Very nice.

> ...Personally I consider Concurrent ML to be a "killer" feature of SML/NJ. ...It’s a shame that CML is not built-in to SML/NJ instead of being an add-on.

[It is now!](https://www.smlnj.org/doc/FAQ/install.html#what) 

> **What does the SML/NJ system consist of?** 
>
> SML/NJ 110 provides a native code compiler that can be used interactively and can also build stand-alone applications, along with a programming environment made up of various tools (CM, ML-Lex, ML-Yacc, CML, eXene, etc.), and a collection of libraries (smlnj-lib).

It comes bundled with the standard `smlnj` installation. It's under `/usr/lib/smlnj/lib/cml` and `/usr/lib/smlnj/lib/cml-lib`. If it's missing, it can be installed through the `libcml-smlnj` package (at least on Ubuntu).

Anyway.. the author's points are all addressed by the industrial-strength OCaml (or Scala, or Haskell...) Functional languages have come a long way!

> The OCaml system[OCaml] is an implementation of a language in the ML family. The language is different from Standard ML and a bit on the experimental side for my taste. However it has recently seen much active
> development in the area of infrastructure...

Yep, that was 2000-2001. Now OCaml is full-blown in 2023. Especially [on the OCaml home page](https://ocaml.org):

> OCaml 5.0 is beta! OCaml 5.0 is the next  major release of OCaml, which comes with support for shared-memory parallelism through domains and direct-style concurrency through algebraic effects!

Finally:

> The bottom line is: yes you can nowadays develop real-world applications in functional languages, getting leverage off of their special features such as greater productivity and reliability. Try it out!

Thank you sir! Hats off to you for trying this 22 years ago. What an absolute madlad.
