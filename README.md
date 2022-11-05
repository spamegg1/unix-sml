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
./hw
Hello world
```

### The `echo` program

Similar changes as the `hw.sml` and `hw.cm` above.
