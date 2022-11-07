#include <ctype.h> // for isspace

int
word_count(const char* text)
{
    int count = 0;
    char c;
out:
    c = *text++;
    if (!c) goto eod;
    if (!isspace(c)) goto in;
    goto out;

in:
    c = *text++;
    if (!c)
    {
        count++;
        goto eod;
    }
    if (isspace(c))
    {
        count++;
        goto in;
    }
    goto in;

eod:
    return count;
}

// just to make it compile.
int main(int argc, char *argv[])
{
    return 0;
}