fun fdReader(name: string, fd: Posix.IO.file_desc): TextPrimIO.reader =
    Posix.IO.mkTextReader {
        initBlkMode = true,
        name = name,
        fd = fd
    }

fun openInFD(name: string, fd: Posix.IO.file_desc): TextIO.instream =
    TextIO.mkInstream(
        TextIO.StreamIO.mkInstream(fdReader(name, fd), "")
    )

fun fdWriter(name: string, fd: Posix.IO.file_desc): TextPrimIO.writer =
    Posix.IO.mkTextWriter {
        appendMode = false,
        initBlkMode = true,
        name = name,
        chunkSize = 4096,
        fd = fd
    }

fun openOutFD(name: string, fd: Posix.IO.file_desc): TextIO.outstream =
    TextIO.mkOutstream(
        TextIO.StreamIO.mkOutstream(fdWriter(name, fd), IO.BLOCK_BUF)
    )
