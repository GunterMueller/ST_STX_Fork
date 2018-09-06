#include <stdio.h>
#include <errno.h>


#ifndef ORIGINAL_UNSECURE_READ

# include <compat.h>

# undef read
# undef write

int
__secureRead(fd, n, buff) 
    char *buff;
{
    int ret;

    do {
        ret = read(fd, n, buff);
    } while((ret < 0) && (errno == EINTR));
    return ret;
}

int
__secureWrite(fd, n, buff)
    char *buff;
{
    int ret;

    do {
        ret = write(fd, n, buff);
    } while((ret < 0) && (errno == EINTR));
    return ret;
}

#endif /* not ORIGINAL */

