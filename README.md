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

```ocaml
group is
    hw.sml
```

to:

```ocaml
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

```ocaml
and word_count text = (* "and" should be "fun" instead *)
```

The same typo is repeated on page 46.

### The `getopt` programs

#### Mostly functional: `getopt1.sml`

The `and` typos keep on happening so many times on page 51, I'm beginning to think they are not typos, but are meant to be placed inside a bigger wrapper function for mutual recursion? Anyway, I had to change them all to `fun`.

There is a `polyEqual` warning here at `n = name`:

```ocaml
fun find_option opts name : (string option) option =
    case List.find (fn (n, v) => n = name) opts of
        NONE => NONE
    |   SOME (n, v) => SOME v
```

Well we can't have that.

It can be fixed by adding a type annotation to `n` like this: `fn (n: string, v) => ...`

The book very stubbornly refuses to put any type annotations anywhere, so I'm going around and placing them myself. I think type annotations are especially useful in these complicated imperative programs, to understand what's happening. The book explains in long prose what the code does, but the code itself does not make it very clear to me.

The `polyEqual` warning can also be avoided by providing a type annotation for `name` instead:

```ocaml
fun find_option(opts: Option list)(name: string): (string option) option =
```

