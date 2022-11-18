structure TTY = Posix.TTY
structure FS = Posix.FileSys

fun setErase ch =
let
    val fd = FS.wordToFD 0w0
    val attr = TTY.TC.getattr fd
    val new_attr = TTY.termios {
        iflag = TTY.getiflag attr,
        oflag = TTY.getoflag attr,
        cflag = TTY.getcflag attr,
        lflag = TTY.getlflag attr,
        cc = TTY.V.update(TTY.getcc attr, [(TTY.V.erase, ch)]),
        ispeed = TTY.CF.getispeed attr,
        ospeed = TTY.CF.getospeed attr
    }
in
    TTY.TC.setattr(fd, TTY.TC.sanow, new_attr)
end
