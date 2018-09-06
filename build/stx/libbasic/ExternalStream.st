"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ReadWriteStream subclass:#ExternalStream
	instanceVariableNames:'handleType handle mode buffered binary eolMode hitEOF didWrite
		lastErrorNumber readAhead'
	classVariableNames:'Lobby LastErrorNumber InvalidReadSignal InvalidWriteSignal
		InvalidModeSignal OpenErrorSignal StreamNotOpenSignal
		InvalidOperationSignal DefaultEOLMode ReadMode ReadWriteMode
		WriteMode AppendMode CreateReadWriteMode StreamIOErrorSignal
		FileOpenTrace MaxNonTenurableExecutors'
	poolDictionaries:''
	category:'Streams-External'
!

!ExternalStream primitiveDefinitions!
%{
#undef fwrite

#include "stxOSDefs.h"

#include <stdio.h>
#define _STDIO_H_INCLUDED_

#include <stdlib.h>

#ifndef NO_FCNTL_H
# include <fcntl.h>
# define _FCNTL_H_INCLUDED_
#endif

#include <errno.h>
#define _ERRNO_H_INCLUDED_

#ifdef LINUX
  /* use inline string macros */
# define __STRINGDEFS__
# include <linuxIntern.h>
#endif

#ifndef WIN32
# include <sys/ioctl.h>
# include <unistd.h>
#endif

#if !defined(MSDOS_LIKE) && !defined(__openVMS__)
# include <termios.h>
#endif

#ifdef hpux
# define fileno(f)      ((f->__fileH << 8) | (f->__fileL))
#endif

#ifndef SEEK_SET
# define SEEK_SET 0
#endif
#ifndef SEEK_CUR
# define SEEK_CUR 1
#endif
#ifndef SEEK_END
# define SEEK_END 2
#endif

#if defined(__VMS__) || defined(__sparc__) || defined(__win32__)
# define CLEAR_ERRNO            __threadErrno = 0;
#else
# define CLEAR_ERRNO            /* nothing */
#endif

#ifdef LATER
# define __isFilePointer(x)      (__Class(x) == ExternalStream__FilePointer)
# define __CHANGECLASS(o, x)     (__qClass(o) = (x), o)
# define __MKFILEPOINTER(f)      __CHANGECLASS(__MKEXTERNALADDRESS(f), ExternalStream__FilePointer)
#else
# define __MKFILEPOINTER(f)      __MKEXTERNALADDRESS(f)
#endif

#ifdef __win32__
# define NO_STDIO

# undef __HANDLE_INTERRUPTS__
# define __HANDLE_INTERRUPTS__    /* nothing */

# undef __BEGIN_INTERRUPTABLE__
# define __BEGIN_INTERRUPTABLE__  /* nothing */

# undef __END_INTERRUPTABLE__
# define __END_INTERRUPTABLE__    /* nothing */
#endif

# ifdef __i386__
#  define _X86_
# endif

#ifdef __win32__
# undef INT
# undef UINT
# undef Array
# undef Number
# undef Method
# undef Point
# undef Rectangle
# undef Block
# undef Time
# undef Date
# undef Delay
# undef Set
# undef Signal
# undef Context
# undef Message
# undef Process
# undef Processor
# undef String
# undef Character

# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
//# define NOOPENFILE
# define NOSOUND
# define NOWH
//# define NOCOMM
# define NOKANJI
# define NOCRYPT
//# define NOMCX
# define WIN32_LEAN_AND_MEAN

# include <windows.h>
# include <winsock2.h>

# ifdef __DEF_Array
#  define Array __DEF_Array
# endif
# ifdef __DEF_Number
#  define Number __DEF_Number
# endif
# ifdef __DEF_Method
#  define Method __DEF_Method
# endif
# ifdef __DEF_Point
#  define Point __DEF_Point
# endif
# ifdef __DEF_Block
#  define Block __DEF_Block
# endif
# ifdef __DEF_Time
#  define Time __DEF_Time
# endif
# ifdef __DEF_Date
#  define Date __DEF_Date
# endif
# ifdef __DEF_Set
#  define Set __DEF_Set
# endif
# ifdef __DEF_Signal
#  define Signal __DEF_Signal
# endif
# ifdef __DEF_Delay
#  define Delay __DEF_Delay
# endif
# ifdef __DEF_Context
#  define Context __DEF_Context
# endif
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  define Processor __DEF_Processor
# endif
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  define Character __DEF_Character
# endif

# define INT    STX_INT
# define UINT   STX_UINT
# ifndef off_t
#  define off_t  long
# endif
#endif /* __win32__ */

#ifndef NO_STDIO /* use STDIO */
# define STDIO_NEEDS_FSEEK
# define FILEPOINTER            FILE *
# define READ(f, cp, n)         read(f, cp, n)
# define WRITE(f, cp, n)        write(f, cp, n)
# define FFLUSH(fp)             fflush(fp)
# define FILENO(f)              fileno(f)
#endif /* use STDIO */

#ifdef DEBUGGING
  extern char *__survStartPtr, *__survEndPtr;
# define DEBUGBUFFER(buf)  \
    if (((char *)(buf) >= __survStartPtr) \
     && ((char *)(buf) < __survEndPtr)) { \
        __fatal0("read into survivor\n"); \
    }

#else
# define DEBUGBUFFER(buf) /* nothing */
#endif

/*
 * stdio library requires an fseek before reading whenever a file
 * is open for read/write and the last operation was a write.
 * (also vice-versa).
 * All code should use the following macro before doing reads:
 */
#ifdef STDIO_NEEDS_FSEEK
# define OPT_FSEEK(f, pos, whence)      fseek(f, pos, whence)
#else
# define OPT_FSEEK(f, pos, whence)      /* nothing */
#endif

#ifdef __win32__
#  define READ(ret, f, cp, n, handleType) { \
        if (handleType == @symbol(socketHandle)) { \
          (ret) = __STX_WSA_NOINT_CALL4("recv", recv, (f), (cp), (n), 0); \
        } else { \
          HANDLE h = _get_osfhandle(fileno(f)); \
          if (handleType == @symbol(socketFilePointer)) { \
            (ret) = __STX_WSA_NOINT_CALL4("recv", recv, h, (cp), (n), 0);\
          } else { \
            int __res; \
            (ret) = __STX_API_NOINT_CALL5("ReadFile", ReadFile, h, (cp), (n), &__res, 0);\
            (ret) = (ret) > 0 ? __res : (__threadErrno == __WIN32_ERR(ERROR_BROKEN_PIPE) ? 0 : -1); \
          } \
        } \
      }

#  define WRITE(ret, f, cp, n, handleType) { \
        if (handleType == @symbol(socketHandle)) { \
          (ret) = __STX_WSA_NOINT_CALL4("send", send, (f), (cp), (n), 0); \
        } else {\
          HANDLE h = _get_osfhandle(fileno(f)); \
          if (handleType == @symbol(socketFilePointer)) { \
            (ret) = __STX_WSA_NOINT_CALL4("send", send, h, (cp), (n), 0);\
          } else {\
            int __res; \
            (ret) = __STX_API_NOINT_CALL5("WriteFile", WriteFile, h, (cp), (n), &__res, 0);\
            (ret) = (ret) ? __res : -1; \
          } \
        } \
      }

# define FFLUSH(fp)             fflush(fp)
# undef STDIO_NEEDS_FSEEK
# define FILEPOINTER            FILE *
# define FILENO(f)              fileno(f)

# define __READING__(f)                          \
    if ((__INST(didWrite) != false)              \
     && (__INST(mode) == @symbol(readwrite))) {  \
        __INST(didWrite) = false;                \
        OPT_FSEEK(f, 0L, SEEK_CUR); /* needed in stdio */  \
    }

# define __WRITING__(f)                          \
    if ((__INST(didWrite) != true)               \
     && (__INST(mode) == @symbol(readwrite))) {  \
        __INST(didWrite) = true;                 \
        OPT_FSEEK(f, 0L, SEEK_CUR); /* needed in stdio */  \
    }

# define __UNGETC__(c, f, isBuffered)                   \
    if (isBuffered) {                                   \
        ungetc((c), (f));                               \
    } else {                                            \
      __INST(readAhead) = __mkSmallInteger((c));        \
    }

# define __READBYTE__(ret, f, buf, isBuffered, handleType) \
    if (isBuffered) {                                   \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) >= 0) {                           \
                *(buf) = (ret);                         \
                (ret) = 1;                              \
            } else if (ferror(f)) {                     \
                if (__threadErrno == EINTR) {           \
                    clearerr(f);                        \
                    continue;                           \
                }                                       \
            } else {                                    \
                (ret) = 0;                              \
            }                                           \
            break;                                      \
        }                                               \
    } else {                                            \
        OBJ rA = __INST(readAhead);                     \
        if (rA != nil) {                                \
            *(buf) = (char)__intVal(rA);                \
            __INST(readAhead) = nil;                    \
            (ret) = 1;                                  \
        } else {                                        \
            for (;;) {                                  \
                CLEAR_ERRNO;                            \
                READ((ret), f, buf, 1, handleType);       \
                if ((ret) >= 0 || __threadErrno != EINTR) \
                    break;                              \
            }                                           \
        }                                               \
    }

  /*
   * read_bytes into a c-buffer
   * (which may NOT move)
   */
# define __READBYTES__(ret, f, buf, cnt, isBuffered, handleType)    \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (__threadErrno == EINTR) {       \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__offs++] = (ret);                    \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int __offs = 0;                                 \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__offs] = __intVal(rA);           \
                __INST(readAhead) = nil;                \
                (ret) = 1;                              \
            } else {                                    \
                CLEAR_ERRNO;                            \
                READ((ret), f, (buf)+__offs, (cnt)-__offs, handleType); \
                if ((ret) <= 0) {                       \
                    if ((ret) < 0 && __threadErrno == EINTR) {  \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }

# define __READAVAILBYTES__(ret, f, buf, cnt, isBuffered, handleType) \
  {                                                     \
    int __offs = 0;                                     \
    int oldFlags;                                       \
                                                        \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (__threadErrno == EINTR) {       \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__offs++] = (ret);                    \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__offs] = __intVal(rA);           \
                __INST(readAhead) = nil;                \
                (ret) = 1;                              \
                __offs ++;                              \
                continue;                               \
            }                                           \
            CLEAR_ERRNO;                                \
            {                                           \
              int res = -1, ok = 0;                     \
              SOCKET sock = 0;                          \
              if ((handleType == @symbol(socketFilePointer) && ((ok = ioctlsocket(sock = (SOCKET)_get_osfhandle(fileno(f)),FIONREAD,&res) == 0), 1)) \
                  || (handleType == @symbol(socketHandle) && ((ok = ioctlsocket(sock = (SOCKET)(f), FIONREAD, &res) == 0), 1)) \
                  || (handleType == @symbol(pipeFilePointer) && ((ok = PeekNamedPipe((HANDLE)_get_osfhandle(fileno(f)),0, 0,0,&res,0)), 1))) { \
                   if (!ok) {                                                               \
                        __threadErrno = sock ? WSAGetLastError() : __WIN32_ERR(GetLastError()); \
                        (ret) = __threadErrno == __WIN32_ERR(ERROR_BROKEN_PIPE) ? 0 : -1;   \
                        break;                                                              \
                   }                                \
                  if (res > 0) {                        \
                      if (res > ((cnt)-__offs))         \
                          res = (cnt)-__offs;           \
                      READ((ret), f, (buf)+__offs, res, handleType); \
                  } else {                              \
                      if (sock && send(sock, NULL, 0, 0) == SOCKET_ERROR) {     \
                        (ret) = -1; __threadErrno = WSAGetLastError();          \
                      } else {                          \
                        (ret) = 0;                      \
                      }                                 \
                      break;                            \
                  }                                     \
              } else {                                  \
                  READ((ret), f, (buf)+__offs, (cnt)-__offs, handleType); \
              }                                         \
            }                                           \
            if ((ret) <= 0) {                           \
                if ((ret) < 0 && __threadErrno == EINTR)\
                    continue;                           \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

# define IO_BUFFER_SIZE        (8*1024)

# define __READBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType) \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (__threadErrno == EINTR) {       \
                        clearerr(f);                    \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__ooffs+__offs] = (ret);              \
            __offs++;                                   \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        while (__offs < (cnt)) {                        \
            char __buf[IO_BUFFER_SIZE];                 \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__ooffs+__offs] = __intVal(rA);   \
                __INST(readAhead) = nil;                \
                (ret) = 1;                              \
            } else {                                    \
                int l;                                  \
                CLEAR_ERRNO;                            \
                l = (cnt)-__offs;                       \
                if ( l > IO_BUFFER_SIZE)                \
                  l = IO_BUFFER_SIZE;                   \
                READ((ret),f, __buf, l, handleType);    \
                if ((ret) <= 0) {                       \
                    if ((ret) < 0 && __threadErrno == EINTR) {  \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
            }                                           \
            if ((ret) > 0 ) {                           \
                /* refetch */                               \
                buf = (char *)(obj);                        \
                memcpy((buf)+__ooffs+__offs,__buf,(ret));   \
                __offs += (ret);                            \
            } else {                                        \
                (ret) = 0;                                  \
            }                                               \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

# define __READAVAILBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType) \
  {                                                  \
    int __ooffs = obj_offs;                          \
    int __offs = 0;                                  \
    char *buf = (char *)(obj);                       \
                                                     \
    (ret) = 0;                                       \
    if (isBuffered) {                                \
        while (__offs < (cnt)) {                     \
            CLEAR_ERRNO;                             \
            (ret) = getc(f);                         \
            if ((ret) < 0) {                         \
                if (ferror(f)) {                     \
                    if (__threadErrno == EINTR) {    \
                        clearerr(f);                 \
                        /* refetch */                \
                        buf = (char *)(obj);         \
                        continue;                    \
                    }                                \
                } else {                             \
                    (ret) = 0;                       \
                }                                    \
                break;                               \
            }                                        \
            (buf)[__ooffs+__offs] = (ret);           \
            __offs++;                                \
        }                                            \
        if (__offs > 0)                              \
            (ret) = __offs;                          \
    } else {                                         \
        while (__offs < (cnt)) {                     \
            char __buf[IO_BUFFER_SIZE];              \
            OBJ rA = __INST(readAhead);              \
            if (rA != nil) {                         \
                (buf)[__ooffs+__offs] = __intVal(rA);\
                __INST(readAhead) = nil;             \
                (ret) = 1;                           \
                __offs++;                            \
                continue;                            \
            }                                        \
            {                                        \
                int res = -1, ok = 0;                \
                SOCKET sock = 0;                     \
                int l = (cnt)-__offs;                \
                CLEAR_ERRNO;                         \
                if (l > IO_BUFFER_SIZE) l = IO_BUFFER_SIZE;              \
                if ((handleType == @symbol(socketFilePointer) && ((ok = ioctlsocket(sock = (SOCKET)_get_osfhandle(fileno(f)),FIONREAD,&res) == 0), 1)) \
                    || (handleType == @symbol(socketHandle) && ((ok = ioctlsocket(sock = (SOCKET)(f), FIONREAD, &res) == 0), 1)) \
                    || (handleType == @symbol(pipeFilePointer) && ((ok = PeekNamedPipe((HANDLE)_get_osfhandle(fileno(f)),0, 0,0,&res,0)), 1))) { \
                   if (!ok) {                                                               \
                        __threadErrno = sock ? WSAGetLastError() : __WIN32_ERR(GetLastError()); \
                        (ret) = __threadErrno == __WIN32_ERR(ERROR_BROKEN_PIPE) ? 0 : -1;   \
                        break;                                                              \
                   }                                \
                   if (res > 0) {                   \
                        if (res > l) res = l;       \
                        READ((ret), f, __buf, res, handleType); \
                   } else {                              \
                       if (sock && send(sock, NULL, 0, 0) == SOCKET_ERROR) {     \
                         (ret) = -1; __threadErrno = WSAGetLastError();          \
                       } else {                          \
                         (ret) = 0;                      \
                       }                                 \
                       break;                            \
                   }                                     \
                } else {                                  \
                    READ((ret), f, __buf, l, handleType); \
                }                                     \
                if ((ret) <= 0) {                     \
                    if ((ret) < 0 && __threadErrno == EINTR) \
                        continue;                       \
                    break;                              \
                }                                       \
            }                                           \
            if ((ret) > 0) {                            \
                buf = (char *)(obj);                    \
                memcpy((buf)+__ooffs+__offs, __buf, (ret)); \
                __offs += (ret);                        \
            } else {                                    \
                (ret) = 0;                              \
            }                                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

# define __WRITEBYTE__(ret, f, buf, isBuffered, handleType)         \
    if (isBuffered) {                                   \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            ret = putc(*(buf), f);                      \
            if ((ret) >= 0) {                           \
                (ret) = 1;                              \
            } else if (ferror(f)) {                     \
                if (__threadErrno == EINTR) {           \
                    clearerr(f);                        \
                    continue;                           \
                }                                       \
            } else                                      \
                (ret) = 0;                              \
            break;                                      \
        }                                               \
    } else {                                            \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            WRITE(ret,f, buf, 1, handleType);           \
            if ((ret) >= 0 || __threadErrno != EINTR)   \
                break;                                  \
        }                                               \
   }

# define __WRITEBYTES__(ret, f, buf, cnt, isBuffered, handleType)   \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = fwrite((buf)+__offs, 1, (cnt)-__offs, f);\
            if ((ret) <= 0) {                           \
                if (ferror(f)) {                        \
                    if (__threadErrno == EINTR) {       \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                    break;                              \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            WRITE((ret),f, (buf)+__offs, (cnt)-__offs, handleType);   \
            if ((ret) <= 0) {                           \
                if ((ret) < 0 && __threadErrno == EINTR) { \
                    continue;                           \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }

# define __WRITEBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType) \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            ret = fwrite((buf)+__ooffs+__offs, 1, (cnt)-__offs, f); \
            if ((ret) <= 0) {                           \
                if (ferror(f)) {                        \
                    if (__threadErrno == EINTR) {       \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                    break;                              \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        while (__offs < (cnt)) {                        \
            char __buf[IO_BUFFER_SIZE];                 \
            int l;                                      \
            CLEAR_ERRNO;                                \
            l = (cnt)-__offs;                           \
            if ( l > IO_BUFFER_SIZE)                    \
              l = IO_BUFFER_SIZE;                       \
            /* refetch */                               \
            buf = (char *)(obj);                        \
            memcpy(__buf,(buf)+__ooffs+__offs,l);       \
            WRITE(ret,f, __buf, l, handleType);         \
            if ((ret) <= 0) {                           \
                if ((ret) < 0 && __threadErrno == EINTR) { \
                    continue;                           \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

#else /* ! __win32__ */
/* ========================   UNIX / LINUX ====================================================== */
typedef int SOCKET;

# define __READING__(f)                          \
    if ((__INST(didWrite) != false)              \
     && (__INST(mode) == @symbol(readwrite))) {  \
        __INST(didWrite) = false;                \
        OPT_FSEEK(f, 0L, SEEK_CUR); /* needed in stdio */  \
    }

# define __WRITING__(f)                          \
    if ((__INST(didWrite) != true)               \
     && (__INST(mode) == @symbol(readwrite))) {  \
        __INST(didWrite) = true;                 \
        OPT_FSEEK(f, 0L, SEEK_CUR); /* needed in stdio */  \
    }


# ifdef NO_STDIO
#  define __UNGETC__(c, f, isBuffered)                  \
    __INST(readAhead) = __mkSmallInteger((c));
# else /* use STDIO */
#  define __UNGETC__(c, f, isBuffered)                  \
    if (isBuffered) {                                   \
        ungetc((c), (f));                               \
    } else {                                            \
        __INST(readAhead) = __mkSmallInteger((c));          \
    }
# endif /* use STDIO */

# ifdef NO_STDIO
#  define __READBYTE__(ret, f, buf, isBuffered, handleType)         \
    {                                                   \
        OBJ rA = __INST(readAhead);                     \
        if (rA != nil) {                                \
            *(buf) = __intVal(rA);                      \
            DEBUGBUFFER(buf);                           \
            __INST(readAhead) = nil;                    \
            (ret) = 1;                                  \
        } else {                                        \
            for (;;) {                                  \
                CLEAR_ERRNO;                            \
                (ret) = READ(f, buf, 1, handleType);    \
                DEBUGBUFFER(buf);                       \
                if ((ret) >= 0) break;                  \
                if (errno != EINTR) {                   \
                    break;                              \
                }                                       \
                __HANDLE_INTERRUPTS__;                  \
            }                                           \
        }                                               \
    }
# else /* use STDIO */
#  define __READBYTE__(ret, f, buf, isBuffered, handleType)         \
    if (isBuffered) {                                   \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) >= 0) {                           \
                DEBUGBUFFER(buf);                       \
                *(buf) = (ret);                         \
                (ret) = 1;                              \
            } else if (ferror(f)) {                     \
                if (errno == EINTR) {                   \
                    __HANDLE_INTERRUPTS__;              \
                    clearerr(f);                        \
                    continue;                           \
                }                                       \
            } else                                      \
                (ret) = 0;                              \
            break;                                      \
        }                                               \
    } else {                                            \
        OBJ rA = __INST(readAhead);                     \
        if (rA != nil) {                                \
            *(buf) = __intVal(rA);                      \
            DEBUGBUFFER(buf);                           \
            __INST(readAhead) = nil;                    \
            (ret) = 1;                                  \
        } else {                                        \
            for (;;) {                                  \
                CLEAR_ERRNO;                            \
                (ret) = read(fileno(f), buf, 1);        \
                DEBUGBUFFER(buf);                       \
                if ((ret) >= 0) break;                  \
                if (errno != EINTR) {                   \
                    break;                              \
                }                                       \
                __HANDLE_INTERRUPTS__;                  \
            }                                           \
        }                                               \
   }
# endif /* use STDIO */

/*
 * read_bytes into a c-buffer
 * (which may NOT move)
 */
# ifdef NO_STDIO
#  define __READBYTES__(ret, f, buf, cnt, isBuffered, handleType)   \
    {                                                   \
        int __offs = 0, __cnt;                          \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__offs] = __intVal(rA);           \
                DEBUGBUFFER(buf);                       \
                __INST(readAhead) = nil;                \
                __offs++;                               \
            } else {                                    \
                CLEAR_ERRNO;                            \
                __cnt = READ(f, (buf)+__offs, (cnt)-__offs, handleType); \
                DEBUGBUFFER(buf);                       \
                if (__cnt <= 0) {                       \
                    if (__cnt < 0 && errno == EINTR) {  \
                        __HANDLE_INTERRUPTS__;          \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
                __offs += __cnt;                        \
            }                                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }
# else /* use STDIO */
#  define __READBYTES__(ret, f, buf, cnt, isBuffered, handleType)     \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        __HANDLE_INTERRUPTS__;          \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            DEBUGBUFFER(buf);                           \
            (buf)[__offs++] = (ret);                    \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int __offs = 0, __cnt;                          \
        int fd = fileno(f);                             \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                DEBUGBUFFER(buf);                       \
                (buf)[__offs] = __intVal(rA);           \
                __INST(readAhead) = nil;                \
                __offs++;                               \
            } else {                                    \
                CLEAR_ERRNO;                            \
                __cnt = read(fd, (buf)+__offs, (cnt)-__offs);  \
                DEBUGBUFFER(buf);                       \
                if (__cnt <= 0) {                       \
                    if (__cnt < 0 && errno == EINTR) {  \
                        __HANDLE_INTERRUPTS__;          \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
                __offs += __cnt;                        \
            }                                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }


/*
 * FNDELAY and O_NDELAY is deprecated, O_NONBLOCK is used in POSIX, XPG, etc...
 */

#  if defined(F_GETFL) && defined(F_SETFL) && (defined(O_NONBLOCK) || defined(O_NDELAY) || defined(FNDELAY))
#   define SETFLAGS(fd, flags) \
        fcntl(fd, F_SETFL, flags)

#   if defined(O_NONBLOCK)
#    define __STX_NONBLOCK_FLAG O_NONBLOCK
#   else
#    if defined(O_NDELAY)
#     define __STX_NONBLOCK_FLAG O_NDELAY
#    else
#     define __STX_NONBLOCK_FLAG FNDELAY
#    endif
#   endif

#   define SETNONBLOCKING(fd, oldFlags) \
        { \
            int flags = fcntl(fd, F_GETFL, 0); \
            if (flags >= 0) { \
                fcntl(fd, F_SETFL, flags | __STX_NONBLOCK_FLAG); \
            } \
            oldFlags = flags; \
        }
#  else
#   define SETFLAGS(fd, flags) /* nothing */
#   define SETNONBLOCKING(fd, oldFlags) /* nothing */
#  endif

#  define __READAVAILBYTES__(ret, f, buf, cnt, isBuffered, handleType) \
  {                                                     \
    int __offs = 0, __cnt;                              \
    int oldFlags;                                       \
                                                        \
    (ret) = 0;                                          \
    SETNONBLOCKING(fileno(f), oldFlags);                \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        (ret) = 0;                      \
                        clearerr(f);                    \
                        break;                          \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__offs++] = (ret);                    \
            DEBUGBUFFER(buf);                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int fd = fileno(f);                             \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__offs] = __intVal(rA);           \
                DEBUGBUFFER(buf);                       \
                __INST(readAhead) = nil;                \
                __offs++;                               \
                continue;                               \
            }                                           \
            CLEAR_ERRNO;                                \
            __cnt = read(fd, (buf)+__offs, (cnt)-__offs); \
            DEBUGBUFFER(buf);                           \
            if (__cnt > 0) {                            \
                __offs += __cnt;                        \
            }                                           \
            break;                                      \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
    SETFLAGS(fileno(f), oldFlags);                      \
  }

# endif /* use STDIO */

/*
 * read_bytes into an object
 * (which may be moved by GC)
 */
# ifdef NO_STDIO
#  define __READBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType)     \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    int __cnt;                                          \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    {                                                   \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__ooffs+__offs] = __intVal(rA);   \
                DEBUGBUFFER(buf);                       \
                __INST(readAhead) = nil;                \
                __offs++;                               \
            } else {                                    \
                CLEAR_ERRNO;                            \
                __cnt = READ(f, (buf)+__ooffs+__offs, (cnt)-__offs, handleType); \
                DEBUGBUFFER(buf);                       \
                if (__cnt <= 0) {                       \
                    if (__cnt < 0 && errno == EINTR) {  \
                        __HANDLE_INTERRUPTS__;          \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
                __offs += __cnt;                        \
            }                                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

# else /* use STDIO */

#  define __READBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType)     \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    int __cnt;                                          \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        __HANDLE_INTERRUPTS__;          \
                        clearerr(f);                    \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        DEBUGBUFFER(buf);               \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__ooffs+__offs] = (ret);              \
            DEBUGBUFFER(buf);                           \
            __offs++;                                   \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int fd = fileno(f);                             \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__ooffs+__offs] = __intVal(rA);   \
                DEBUGBUFFER(buf);                       \
                __INST(readAhead) = nil;                \
                __offs++;                               \
            } else {                                    \
                CLEAR_ERRNO;                            \
                __cnt = read(fd, (buf)+__ooffs+__offs, (cnt)-__offs); \
                DEBUGBUFFER(buf);                       \
                if (__cnt <= 0) {                       \
                    if (__cnt < 0 && errno == EINTR) {  \
                        __HANDLE_INTERRUPTS__;          \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        continue;                       \
                    }                                   \
                    break;                              \
                }                                       \
                __offs += __cnt;                        \
            }                                           \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }

# define __READAVAILBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType)     \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    int __cnt;                                          \
    char *buf = (char *)(obj);                          \
    int oldFlags;                                       \
                                                        \
    (ret) = 0;                                          \
    SETNONBLOCKING(fileno(f), oldFlags);                \
                                                        \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = getc(f);                            \
            if ((ret) < 0) {                            \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        clearerr(f);                    \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        (ret) = 0;                      \
                        break;                          \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            (buf)[__ooffs+__offs] = (ret);              \
            DEBUGBUFFER(buf);                           \
            __offs++;                                   \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int fd = fileno(f);                             \
                                                        \
        while (__offs < (cnt)) {                        \
            OBJ rA = __INST(readAhead);                 \
            if (rA != nil) {                            \
                (buf)[__ooffs+__offs] = __intVal(rA);   \
                DEBUGBUFFER(buf);                       \
                __INST(readAhead) = nil;                \
                __offs++;                               \
                continue;                               \
            }                                           \
            CLEAR_ERRNO;                                \
            __cnt = read(fd, (buf)+__ooffs+__offs, (cnt)-__offs); \
            DEBUGBUFFER(buf);                           \
            if (__cnt > 0) {                            \
                __offs += __cnt;                        \
            }                                           \
            break;                                      \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
    SETFLAGS(fileno(f), oldFlags);                      \
  }


# endif /* use STDIO */

# ifdef NO_STDIO
#  define __WRITEBYTE__(ret, f, buf, isBuffered, handleType)          \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            (ret) = WRITE(f, buf, 1, handleType);       \
            if ((ret) >= 0) break;                      \
            if (errno != EINTR) {                       \
                break;                                  \
            }                                           \
            __HANDLE_INTERRUPTS__;                      \
        }
# else /* use STDIO */
#  define __WRITEBYTE__(ret, f, buf, isBuffered, handleType)        \
    if (isBuffered) {                                   \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            ret = putc(*(buf), f);                      \
            if ((ret) >= 0) {                           \
                (ret) = 1;                              \
            } else if (ferror(f)) {                     \
                /* SOLARIS/SPARC (2.6) generates spurious errors with errno = 0 */ \
                if (errno == EINTR || errno == 0) {     \
                    __HANDLE_INTERRUPTS__;              \
                    clearerr(f);                        \
                    continue;                           \
                }                                       \
            } else                                      \
                (ret) = 0;                              \
            break;                                      \
        }                                               \
    } else {                                            \
        for (;;) {                                      \
            CLEAR_ERRNO;                                \
            (ret) = write(fileno(f), buf, 1);           \
            if ((ret) >= 0) break;                      \
            if (errno != EINTR) {                       \
                break;                                  \
            }                                           \
            __HANDLE_INTERRUPTS__;                      \
        }                                               \
   }
# endif /* use STDIO */

/*
 * write_bytes from a c-buffer
 * (which may NOT move)
 */
# ifdef NO_STDIO
#  define __WRITEBYTES__(ret, f, buf, cnt, isBuffered, handleType)    \
    (ret) = 0;                                          \
    {                                                   \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            ret = WRITE(f, (buf)+__offs, (cnt)-__offs, handleType); \
            if (ret <= 0) {                             \
                if (ret < 0 && errno == EINTR) {        \
                    __HANDLE_INTERRUPTS__;              \
                    continue;                           \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }
# else /* use STDIO */
#  define __WRITEBYTES__(ret, f, buf, cnt, isBuffered, handleType)    \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = fwrite((buf)+__offs, 1, (cnt)-__offs, f);\
            if ((ret) <= 0) {                            \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        __HANDLE_INTERRUPTS__;          \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    } else {                                            \
        int __offs = 0;                                 \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = write(fileno(f), (buf)+__offs, (cnt)-__offs);\
            if ((ret) <= 0) {                           \
                if ((ret) < 0) {                        \
                    if (errno == EINTR) {               \
                        __HANDLE_INTERRUPTS__;          \
                        continue;                       \
                    }                                   \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
   }
# endif /* use STDIO */

/*
 * write_bytes from an object
 * (which may be moved around by GC)
 */
# ifdef NO_STDIO
#  define __WRITEBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType)            \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    {                                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            ret = WRITE(f, (buf)+__ooffs+__offs, (cnt)-__offs, handleType); \
            if (ret <= 0) {                             \
                if (ret < 0 && errno == EINTR) {        \
                    __HANDLE_INTERRUPTS__;              \
                    /* refetch */                       \
                    buf = (char *)(obj);                \
                    continue;                           \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
        if (__offs > 0)                                 \
            (ret) = __offs;                             \
    }                                                   \
  }
# else /* use STDIO */
#  define __WRITEBYTES_OBJ__(ret, f, obj, obj_offs, cnt, isBuffered, handleType)            \
  {                                                     \
    int __ooffs = obj_offs;                             \
    int __offs = 0;                                     \
    char *buf = (char *)(obj);                          \
                                                        \
    (ret) = 0;                                          \
    if (isBuffered) {                                   \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = fwrite((buf)+__ooffs+__offs, 1, (cnt)-__offs, f);  \
            if ((ret) <= 0) {                           \
                if (ferror(f)) {                        \
                    if (errno == EINTR) {               \
                        __HANDLE_INTERRUPTS__;          \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        clearerr(f);                    \
                        continue;                       \
                    }                                   \
                    break;                              \
                } else {                                \
                    (ret) = 0;                          \
                }                                       \
            }                                           \
            __offs += (ret);                            \
        }                                               \
    } else {                                            \
        while (__offs < (cnt)) {                        \
            CLEAR_ERRNO;                                \
            (ret) = write(fileno(f), (buf)+__ooffs+__offs, (cnt)-__offs); \
            if ((ret) <= 0) {                           \
                if ((ret) < 0) {                        \
                    if (errno == EINTR){                \
                        __HANDLE_INTERRUPTS__;          \
                        /* refetch */                   \
                        buf = (char *)(obj);            \
                        continue;                       \
                    }                                   \
                }                                       \
                break;                                  \
            }                                           \
            __offs += (ret);                            \
        }                                               \
    }                                                   \
    if (__offs > 0)                                     \
        (ret) = __offs;                                 \
  }
# endif /* use STDIO */
#endif /* unix */
%}
! !

!ExternalStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    ExternalStream defines protocol common to Streams which have a file-descriptor and
    represent some file or communicationChannel of the underlying OperatingSystem.
    ExternalStream is abstract; concrete classes are FileStream, PipeStream etc.

    ExternalStreams can be in two modes: text- (the default) and binary-mode.
    In text-mode, the elements read/written are characters;
    while in binary-mode the basic elements are bytes which read/write as SmallIntegers
    in the range 0..255.

    Also, the stream can be either in buffered or unbuffered mode. In buffered mode,
    data is not written until either a cr is written (in text mode) or a synchronizeOutput
    is sent (in both modes).

    The underlying OperatingSystem streams may either be closed explicitely (sending a close)
    or just forgotten - in this case, the garbage collector will eventually collect the
    object AND a close will be performed automatically (but you will NOT know when this
    happens - so it is recommended, that you close your files when no longer needed).
    Closing is also suggested, since if smalltalk is finished (be it by purpose, or due to
    some crash) the data will not be in the file, if unclosed.
    All streams understand the close message, so it never hurts to use it (it is defined as
    a noop in one of the superclasses).

    Most of the methods found here redefine inherited methods for better performance,
    since I/O from/to files should be fast.

    Recovering a snapshot:
      not all streams can be restored to the state they had before - see the implementation of
      reOpen in subclasses for more information.
      For streams sitting on some communication channel (i.e. Pipes and Sockets) you should
      reestablish the stream upon image restart (make someone dependent on ObjectMemory).
      FileStreams are reopened and positioned to their offset they had at snapshot time.
      This may fail, if the file was removed or renamed - or lead to confusion
      if the contents changed in the meantime.
      Therefore, it is a good idea to reopen files and check for these things at restart time.

    [Instance variables:]

        handleType      <Symbol>        desribes what handle is:
                                            win32: #fileHandle, #socketHandle,
                                                   #filePointer, #socketFilePointer, #pipeFilePointer
                                            unix: #filePointer, #socketFilePointer, #pipeFilePointer
                                        needed for win32, which uses different APIs for the different handles (sigh)
        handle          <Integer>       used to be always a filePointer somehow mapped to an integer (FILE* - not the fd);
                                        now, either a filePointer or a handle (win32)
        mode            <Symbol>        #readwrite, #readonly or #writeonly
        buffered        <Boolean>       true, if buffered (i.e. collects characters - does
                                        not output immediately)
        binary          <Boolean>       true if in binary mode (reads bytes instead of chars)
        eolMode         <Symbol>        one of nil, #nl, #cr or #crlf.
                                        determines how lines should be terminated.
                                        nil -> newLine (as in Unix);
                                        #crlf -> with cr-lf (as in MSDOS)
                                        #cr -> with cr (as in VMS)
        hitEOF          <Boolean>       true, if EOF was reached

        lastErrorNumber <Integer>       the value of errno (only valid right after the error -
                                        updated with next i/o operation)

    [Class variables:]
        Lobby           <Registry>      keeps track of used ext-streams (to free up FILE*'s)

        StreamErrorSignal       <Signal> parent of all stream errors (see Stream class)
        InvalidReadSignal       <Signal> raised on read from writeonly stream
        InvalidWriteSignal      <Signal> raised on write to readonly stream
        InvalidModeSignal       <Signal> raised on text I/O with binary-stream
                                         or binary I/O with text-stream
        OpenErrorSignal         <Signal> raised if open fails
        StreamNotOpenSignal     <Signal> raised on I/O with non-open stream

    Additional notes:
      This class is implemented using the underlying stdio-c library package, which
      has both advantages and disadvantages: since it is portable (posix defined), porting
      ST/X to non-Unix machines is simplified. The disadvantage is that the stdio library
      has big problems handling unbounded Streams, since the EOF handling in stdio is
      not prepared for data to arrive after EOF has been reached - time will show, if we need
      a complete rewrite for UnboundedStream ...

      Also, depending on the system, the stdio library behaves infriendly when signals
      occur while reading (for example, timer interrupts) - on real unixes (i.e. BSD) the signal
      is handled transparently - on SYS5.3 (i.e. non unixes :-) the read operation returns
      an error and errno is set to EINTR.
      That's what the ugly code around all getc-calls is for ...
      Since things get more and more ugly - we will rewrite ExternalStream
      completely, to NOT use any stdio stuff (and do its buffering itself).

      Notice that typical stdio's use a single errno global variable to return an error code,
      this was bad design in the stdio lib (right from the very beginning), since it's much
      harder to deal with this in the presence of lightweight processes, where errno gets
      overwritten by an I/O operation done in another thread. (stdio should have been written
      to return errno as a negative number ...).
      To deal with this, the scheduler treats errno like a per-thread private variable,
      and saves/restores the errno setting when switching to another thread.
      (Notice that some thread packages do this also, but ST/X's thread implementation
      does not depend on those, but instead uses a portable private package).

      Finally, if an stdio-stream is open for both reading and writing, we have to call
      fseek whenever we are about to read after write and vice versa.
      Two macros (__READING__ and __WRITING__) have been defined to be used before every
      fread/fgetc and fwrite/putc respectively.

    [author:]
        Claus Gittinger
        Stefan Vogel (many, many fixes ...)

    [see also:]
        FileStream Socket PipeStream
        Filename OperatingSystem
"
!

examples
"
    open a file, read the contents and display it in a textView:
									[exBegin]
	|topView scrollPane textView fileStream text|

	topView := StandardSystemView new.
	topView label:'contents of Makefile'.

	scrollPane := HVScrollableView in:topView.
	scrollPane origin:0.0@0.0 corner:1.0@1.0.

	textView := EditTextView new.
	scrollPane scrolledView:textView.

	fileStream := 'Makefile' asFilename readStream.
	text := fileStream upToEnd.
	fileStream close.

	textView contents:text.

	topView open.
									[exEnd]


    Notice, all of the above can also be done (simply) as:
									[exBegin]
	EditTextView openOn:'Makefile'
									[exEnd]
"
! !

!ExternalStream class methodsFor:'initialization'!

closeFiles
    "close all files.
     To be called on exit of Smalltalk."

    Lobby do:[:eachFileStream |
	eachFileStream close
    ].
!

initDefaultEOLMode
    OperatingSystem isUNIXlike ifTrue:[
	"/ unix EOL conventions
	DefaultEOLMode := #nl
    ] ifFalse:[
	OperatingSystem isVMSlike ifTrue:[
	    "/ vms EOL conventions
	    DefaultEOLMode := #cr
	] ifFalse:[
	    "/ msdos EOL conventions
	    "/ msdos uses #crlf.
	    "/ the following breaks all programs, which do not explicitly
	    "/ change th eolMode when writing/reading binary files (zip reader)
	    "/ MUST change all classes before doing the following.
	    "/ Anyway: for backward compatibility (swisscom), it is left in this
	    "/ mode (for a while, I hope).
	    DefaultEOLMode := #crlf.

	    "/ DefaultEOLMode := #nl
	]
    ]
!

initModeStrings
    "initialize modeStrings which are passed down to the underlying
     fopen/fdopen functions."

    OperatingSystem isMSDOSlike ifTrue:[
	ReadMode := 'rb'.
	ReadWriteMode := 'rb+'.
	WriteMode := 'wb'.
	AppendMode := 'ab+'.
	CreateReadWriteMode := 'wb+'.
    ] ifFalse:[
	ReadMode := 'r'.
	ReadWriteMode := 'r+'.
	WriteMode := 'w'.
	AppendMode := 'a+'.
	CreateReadWriteMode := 'w+'.
    ]
!

initialize
    OpenErrorSignal isNil ifTrue:[
	OpenErrorSignal := OpenError.
	OpenErrorSignal notifierString:'open error'.

	InvalidReadSignal := InvalidReadError.
	InvalidReadSignal notifierString:'stream does not support reading'.

	InvalidWriteSignal := InvalidWriteError.
	InvalidWriteSignal notifierString:'stream does not support writing'.

	InvalidModeSignal := InvalidModeError.
	InvalidModeSignal notifierString:'binary/text mode mismatch'.

	InvalidOperationSignal := InvalidOperationError.
	InvalidOperationSignal notifierString:'unsupported file operation'.

	StreamNotOpenSignal := StreamNotOpenError.
	StreamNotOpenSignal notifierString:'stream is not open'.

	StreamIOErrorSignal := StreamIOError.
	StreamIOErrorSignal notifierString:'I/O error'.

	"/ self patchByteOrderOptimizedMethods
    ].

    Lobby isNil ifTrue:[
	Lobby := Registry new.

	"want to get informed when returning from snapshot"
	ObjectMemory addDependent:self
    ].
    DefaultEOLMode isNil ifTrue:[
	self initDefaultEOLMode.
    ].
    ReadMode isNil ifTrue:[
	self initModeStrings.
    ].

    "limit the amount of newspace to be used for non-tenurable executors to 5%"
    "/ MaxNonTenurableExecutors := ObjectMemory newSpaceSize // (Socket sizeOfInst:0) // 20.
    "/ cg: changed because Socket is not in libbasic. Thus, standalone (libbasic only)
    "/ programs would fail to start.
    MaxNonTenurableExecutors := (ObjectMemory newSpaceSize // 20 min:2000).

    "Modified: / 21.5.1998 / 16:33:53 / cg"
!

patchByteOrderOptimizedMethods
    "EXPERIMENTAL (not yet done by default):
     change the underlying implementation of
	nextPutInt16MSB / nextPutInt16LSB
	nextPutInt32MSB / nextPutInt32LSB
     to the corresponding NATIVE methods."

    |native16 native32|

    native16 := self compiledMethodAt:#nextPutInt16NATIVE:.
    native32 := self compiledMethodAt:#nextPutInt32NATIVE:.

    UninterpretedBytes isBigEndian ifTrue:[
	(self compiledMethodAt:#nextPutInt16MSB:) code:(native16 code).
	(self compiledMethodAt:#nextPutInt32MSB:) code:(native32 code).
    ] ifFalse:[
	(self compiledMethodAt:#nextPutInt16LSB:) code:(native16 code).
	(self compiledMethodAt:#nextPutInt32LSB:) code:(native32 code).
    ].
!

reOpenFiles
    "reopen all files (if possible) after a snapShot load.
     This is invoked via the #earlyRestart change notification."

    Lobby do:[:eachFileStream |
	eachFileStream reOpen
    ].
!

update:something with:aParameter from:changedObject
    "have to reopen files when returning from snapshot"

    something == #earlyRestart ifTrue:[
	self reOpenFiles.
	self initDefaultEOLMode
    ]

    "Created: 15.6.1996 / 15:19:59 / cg"
! !

!ExternalStream class methodsFor:'instance creation'!

forFileDescriptor:aFileDescriptor mode:modeSymbol
    "given a fileDescriptor, create an ExternalStream object
     to operate on this fd.
     The modeSymbol-argument is #readonly, #readwrite, ....
     This may be used to wrap fd's as returned by user
     primitive code, or to wrap pipe-fds into externalStreams."

    ^ self forFileDescriptor:aFileDescriptor mode:modeSymbol buffered:true handleType:nil

    "
     the example below will probably fail (15 is a random FD):

     |s|

     s := ExternalStream forFileDescriptor:15 mode:'r'.
     s next.
    "

    "Created: 29.2.1996 / 18:05:00 / cg"
    "Modified: 29.2.1996 / 18:17:07 / cg"
!

forFileDescriptor:aFileDescriptor mode:modeSymbol buffered:buffered handleType:handleTypeSymbol
    "given a fileDescriptor, create an ExternalStream object
     to operate on this fd.
     The modeSymbol-argument is #readonly, #readwrite, ....
     This may be used to wrap fd's as returned by user
     primitive code, or to wrap pipe-fds into externalStreams."

    ^ self new
        buffered:buffered;
        connectTo:aFileDescriptor withMode:modeSymbol handleType:handleTypeSymbol.

    "
     the example below will probably fail (15 is a random FD):

     |s|

     s := ExternalStream forFileDescriptor:15 mode:#readonly buffered:false handleType:#filePointer.
     s next.
    "

    "Created: 29.2.1996 / 18:05:00 / cg"
    "Modified: 29.2.1996 / 18:17:07 / cg"
!

forReadWriteToFileDescriptor:aFileDescriptor
    "given a fileDescriptor, create an ExternalStream object
     to read/write from/to this fd. This may be used to wrap fd's
     as returned by user primitive code, or to wrap pipe-
     filedescriptors into externalStreams."

    ^ self forFileDescriptor:aFileDescriptor mode:#readWrite

    "
     the example below will probably fail (15 is a random FD):

     |s|

     s := ExternalStream forReadWriteToFileDescriptor:15.
     s next.
    "

    "Created: 29.2.1996 / 18:15:08 / cg"
    "Modified: 29.2.1996 / 18:16:25 / cg"
!

forReadingFromFileDescriptor:aFileDescriptor
    "given a fileDescriptor, create an ExternalStream object
     to read from this fd. This may be used to wrap fd's
     as returned by user primitive code, or to wrap pipe-
     filedescriptors into externalStreams."

    ^ self forFileDescriptor:aFileDescriptor mode:#readonly

    "
     the example below will probably fail (15 is a random FD):

     |s|

     s := ExternalStream forReadingFromFileDescriptor:15.
     s next.
    "

    "
     |pipe readFd writeFd rs ws|

     'create OS pipe ...'.

     pipe := OperatingSystem makePipe.
     readFd := pipe at:1.
     writeFd := pipe at:2.

     'connect Smalltalk streams ...'.

     rs := ExternalStream forReadingFromFileDescriptor:readFd.
     ws := ExternalStream forWritingToFileDescriptor:writeFd.

     'read ...'.
     [
	 1 to:10 do:[:i |
	     Transcript showCR:rs nextLine
	 ].
	 rs close.
     ] forkAt:7.

     'write ...'.
     [
	 1 to:10 do:[:i |
	     ws nextPutAll:'hello world '; nextPutAll:i printString; cr
	 ].
	 ws close.
     ] fork.

    "

    "Created: 29.2.1996 / 18:14:24 / cg"
    "Modified: 29.2.1996 / 18:25:02 / cg"
!

forWritingToFileDescriptor:aFileDescriptor
    "given a fileDescriptor, create an ExternalStream object
     to write to this fd. This may be used to wrap fd's
     as returned by user primitive code, or to wrap pipe-
     filedescriptors into externalStreams."

    ^ self forFileDescriptor:aFileDescriptor mode:#writeonly

    "
     the example below will probably fail (15 is a random FD):

     |s|

     s := ExternalStream forWritingToFileDescriptor:15.
     s binary.
     s nextPut:1.
    "

    "Created: 29.2.1996 / 18:14:43 / cg"
    "Modified: 29.2.1996 / 18:15:54 / cg"
!

new
    "re-enable new - disabled in Stream superclass"

    ^ self basicNew initialize.
! !

!ExternalStream class methodsFor:'Signal constants'!

inaccessibleSignal
    "ST-80 compatibility: return openErrorSignal"

    ^ self openErrorSignal

    "Created: 2.7.1996 / 12:27:16 / stefan"
!

invalidModeSignal
    "return the signal raised when doing text-I/O with a binary stream
     or binary-I/O with a text stream"

    ^ InvalidModeError
!

invalidOperationSignal
    "return the signal raised when an unsupported or invalid
     I/O operation is attempted"

    ^ InvalidOperationError
!

invalidReadSignal
    "return the signal raised when reading from writeonly streams"

    ^ InvalidReadError
!

invalidWriteSignal
    "return the signal raised when writing to readonly streams"

    ^ InvalidWriteError
!

openErrorSignal
    "return the signal raised when a file open failed"

    ^ OpenErrorSignal
!

streamIOErrorSignal
    "return the signal raised when an I/O error occurs.
     (for example, a device-IO-error, or reading an NFS-dir,
     which is no longer available and has been mounted soft)"

    ^ StreamIOError

    "Created: / 21.5.1998 / 16:32:55 / cg"
!

streamNotOpenSignal
    "return the signal raised on I/O with closed streams"

    ^ StreamNotOpenError
! !

!ExternalStream class methodsFor:'error handling'!

errorReporter
    "I know about error codes"

    ^ self
!

lastErrorNumber
    "return the errno of the last error"

    ^ LastErrorNumber

    "
     ExternalStream lastErrorNumber
    "
!

lastErrorString
    "return a message string describing the last error"

    ^ OperatingSystem errorTextForNumber:LastErrorNumber

    "
     ExternalStream lastErrorString
    "
!

reportOn:anErrorSymbolOrNumber
    "an error occurred.
     Report it via an Exception"

    anErrorSymbolOrNumber isInteger ifTrue:[
        StreamError
            raiseRequestWith:anErrorSymbolOrNumber
            errorString:(' - os error:' , (OperatingSystem errorTextForNumber:anErrorSymbolOrNumber))
    ].
    (self respondsTo:anErrorSymbolOrNumber) ifTrue:[
        self perform:anErrorSymbolOrNumber
    ] ifFalse:[
        StreamError
            raiseRequestWith:anErrorSymbolOrNumber
            errorString:(' - ' , anErrorSymbolOrNumber printString)
    ].
    ^ false
! !

!ExternalStream class methodsFor:'finalization'!

finalizationLobby
    "answer the registry used for finalization.
     ExternalStreams have their own Registry"

    ^ Lobby
! !

!ExternalStream class methodsFor:'obsolete'!

makePTYPair
    "obsolete since 12-07-2003"
    <resource:#obsolete>

    self obsoleteMethodWarning:'use NonPositionableExternalStream makePTYPair'.

    ^ NonPositionableExternalStream makePTYPair.
!

makePipe
    "obsolete since 12-07-2003"
    <resource:#obsolete>

    self obsoleteMethodWarning:'use NonPositionableExternalStream makePipe'.

    ^ NonPositionableExternalStream makePipe.
! !

!ExternalStream class methodsFor:'testing'!

isAbstract
    ^ self == ExternalStream
! !

!ExternalStream methodsFor:'Compatibility-Dolphin'!

beText
    self text
! !

!ExternalStream methodsFor:'Compatibility-Squeak'!

nextInto:aByteArrayOrString
    "read elements into the argument, whose size determines the amount
     of bytes to read. If not enough elements could be read, return
     a copy of the argument; otherwise, return the filled argument."

    |n nWanted|

    nWanted := aByteArrayOrString byteSize.
    n := self nextAvailableBytes:nWanted into:aByteArrayOrString startingAt:1.
    n == nWanted ifTrue:[^ aByteArrayOrString].
    ^ aByteArrayOrString copyTo:n

!

readInto:aContainer startingAt:index count:nElements
    "same as #nextBytes:into:startingAt: for ByteArrays;
     for LongArrays, nelements longs are read.
     Squeak compatibility."

    |elementSize n|

    elementSize := aContainer class elementByteSize.
    n := self nextBytes:nElements*elementSize into:aContainer startingAt:(index-1)*elementSize+1.
    ^ n // elementSize

    "Modified: / 14-01-2012 / 19:00:35 / cg"
!

readOnly
    "Squeak compatibility: make the stream readOnly"

    mode := #readonly

    "Modified: 20.10.1997 / 19:23:04 / cg"
    "Created: 20.10.1997 / 19:23:19 / cg"
! !

!ExternalStream methodsFor:'Signal constants'!

invalidReadSignal
    ^ self class invalidReadSignal

    "Created: / 3.12.1998 / 15:12:06 / cg"
!

invalidWriteSignal
    ^ self class invalidWriteSignal

    "Created: / 3.12.1998 / 15:12:10 / cg"
! !

!ExternalStream methodsFor:'accessing'!

binary
    "switch to binary mode - default is text"

    binary := true
!

buffered:aBoolean
    "turn buffering on or off - default is on"

    buffered := aBoolean
!

contents
    "return the contents of the file from the current position up-to
     the end. If the stream is in binary mode, a ByteArray containing
     the byte values is returned.
     In text-mode, a collection of strings, each representing one line,
     is returned."

    |text|

    binary ifTrue:[
        ^ self upToEnd.
    ].

    "/ text mode
    text := StringCollection new.
    [self atEnd] whileFalse:[
        |line|

        line := self nextLine.
        line isNil ifTrue:[
            ^ text
        ].
        text add:line
    ].
    ^ text
!

contentsAsString
    "to compensate for the bad naming, use this to make things explicit.
     See also #contents, which returns the lines as stringCollection for textFiles."

    ^ self upToEnd
!

contentsOfEntireFile
    "ST-80 compatibility: return contents as a String (or byteArray, if in binary mode).
     See also #contents, which returns the lines as stringCollection for text files."

    ^ self upToEnd

    "Modified: / 3.7.1996 / 13:22:16 / stefan"
    "Modified: / 27.11.1998 / 16:29:43 / cg"
!

contentsSpecies
    "return the kind of object to be returned by sub-collection builders
     (such as upTo)"

    binary ifTrue:[
        ^ ByteArray
    ].
    ^ String
!

eolMode
    "return how end-of-line (EOL) is to be marked.
     Returns one one of:
        #crlf         -> add a CR-NL, as in MSDOS
        #cr           -> add a CR, as in VMS
        #nl           -> add a NL, as in Unix
        #eot          -> add an EOT (= 0x04, as used in some modems/protocols)
        #etx          -> add an ETX (= 0x03, as used in some modems/protocols)
        #nl           -> add a NL, as in Unix
        nil           -> transparent
    "

    ^ eolMode

    "Modified (comment): / 06-12-2016 / 14:26:24 / cg"
!

eolMode:aSymbolOrNil
    "specify how end-of-line (EOL) is to be marked.
     The argument may be one of:
        #crlf         -> add a CR-NL, as in MSDOS
        #cr           -> add a CR, as in VMS
        #nl           -> add a NL, as in Unix
        #eot          -> add an EOT (= 0x04, as used in some modems/protocols)
        #etx          -> add an ETX (= 0x03, as used in some modems/protocols)
        anyOther      -> like #nl
    "

    aSymbolOrNil == #crnl ifTrue:[
        eolMode := #crlf
    ] ifFalse:[
        aSymbolOrNil == #lf ifTrue:[
            eolMode := #nl
        ] ifFalse:[
            eolMode := aSymbolOrNil
        ]
    ].

    "Modified (comment): / 06-12-2016 / 14:26:37 / cg"
!

fileDescriptor
    "return the fileDescriptor of the receiver -
     notice: this one returns the underlying OSs fileDescriptor -
     this may not be available on all platforms (i.e. non unix systems)."

%{
    OBJ _handle  = __INST(handle);

    if (_handle != nil) {
        if ((__INST(handleType) == @symbol(fileHandle))
         || (__INST(handleType) == @symbol(socketHandle))) {
            RETURN (_handle);
        } else if ((__INST(handleType) == nil)
                     || (__INST(handleType) == @symbol(filePointer))
                     || (__INST(handleType) == @symbol(socketFilePointer))
                     || (__INST(handleType) == @symbol(pipeFilePointer))) {
            RETURN ( __MKINT(fileno(__FILEVal(_handle))));
        }
    }
%}.
    handle isNil ifTrue:[^ self errorNotOpen].
    ^ self fileDescriptorOfFile:handle
!

fileDescriptorOfFile:handle
    "for migration to rel5 only:
     return the fileDescriptor of the argument handle -
     notice: this one returns the underlying OSs fileDescriptor -
     this may not be available on all platforms (i.e. non unix systems)."

%{
#ifdef __SCHTEAM__
    return context._RETURN(handle);
#endif
%}.
    self primitiveFailed
!

fileHandle
    "return the fileHandle of the receiver.
     Under unix, this is the fileDescriptor; under windows, this is the Handle."

%{
    OBJ _handle  = __INST(handle);

    if (_handle != nil) {
        if ((__INST(handleType) == @symbol(fileHandle))
         || (__INST(handleType) == @symbol(socketHandle))) {
            RETURN (_handle);
        }
        if (__INST(handleType) == @symbol(pipeFilePointer)) {
            RETURN (__MKINT(fileno(__FILEVal(_handle))));
        }
        if ((__INST(handleType) == nil)
         || (__INST(handleType) == @symbol(filePointer))
         || (__INST(handleType) == @symbol(socketFilePointer))
         || (__INST(handleType) == @symbol(pipeFilePointer))) {
#ifdef __win32__
            RETURN(__MKEXTERNALADDRESS(_get_osfhandle(fileno(__FILEVal(_handle)))));
#else
            RETURN (__MKINT(fileno(__FILEVal(_handle))));
#endif
        }
    }
%}.
    ^ handle
!

filePointer
    "return the filePointer of the receiver -
     notice: for portability stdio is used; this means you will get
     a FILE * - not a fileDescriptor.
     (what you really get is a corresponding integer).
     You cannot do much with the returned value
     - except passing it to a primitive, for example."

    (handleType isNil or:[handleType == #filePointer]) ifTrue:[
	^ handle
    ].
    ^ self error:'not a FILE*'
!

handle
    ^ handle
!

handleType
    ^ handleType
!

lineEndCRLF
    eolMode := #crlf
!

lineEndLF
    eolMode := #nl
!

lineEndTransparent
    eolMode := #nl
!

pathName
    "answer the pathName of the stream.
     Only FileStreams know the pathName, so we return an empty string here"

    ^ ''
!

readonly
    "set access mode to readonly"

    mode := #readonly
!

readwrite
    "set access mode to readwrite"

    mode := #readwrite
!

text
    "switch to text mode - default is text"

    binary := false
!

useCRLF:aBoolean
    <resource: #obsolete>
    "turn on or off CRLF sending (instead of LF only) - default is off.
     This method is provided for backward compatibility - see #eolMode:
     which offers another choice."

    aBoolean ifTrue:[
	eolMode := #crlf
    ] ifFalse:[
	eolMode := #nl
    ].
!

writeonly
    "set access mode to writeonly"

    mode := #writeonly
! !

!ExternalStream methodsFor:'closing'!

abortAndClose
    "close the stream - added for protocol compatibility with Socket and PipeStream.
     see comment there"

    self close.

    "Modified: 30.8.1996 / 00:39:21 / cg"
!

close
    "Close the stream.
     No error if the stream is not open."

    self isOpen ifTrue:[
        self unregisterForFinalization.
        self isOpen ifTrue:[
            self closeFile.
        ].
    ].
!

shutDown
    "close the stream - added for protocol compatibility with Socket.
     see comment there"

    self close.

    "Modified: 30.8.1996 / 00:39:21 / cg"
! !

!ExternalStream methodsFor:'copying'!

copy
    "answer a copy of myself.
     Have to dup the filedescriptor"

    |copy|

    copy := super copy.
    copy dupFd.
    copy registerForFinalization.
    ^ copy

    "
       |stream1 stream2|

       stream1 := Filename newTemporary writeStream.
       stream2 := stream1 copy.

       stream1 inspect.
       stream2 inspect.
    "
! !

!ExternalStream methodsFor:'error handling'!

argumentMustBeCharacter
    "report an error, that the argument must be a character in 0..FF"

    "{ Pragma: +optSpace }"

    ArgumentError raiseErrorString:' - argument must be a single byte character'
!

argumentMustBeInteger
    "report an error, that the argument must be an integer"

    "{ Pragma: +optSpace }"

    ArgumentError raiseErrorString:' - argument must be an integer'
!

argumentMustBeString
    "report an error, that the argument must be a string"

    "{ Pragma: +optSpace }"

    ArgumentError raiseErrorString:' - argument must be a string'
!

errorAlreadyOpen
    "{ Pragma: +optSpace }"

    "report an error, that the stream is already opened"

    ^ OpenError
	raiseRequestWith:self
	errorString:' - stream is already open'

    "
      self new errorAlreadyOpen
    "

    "Modified: / 8.5.1999 / 20:12:30 / cg"
!

errorBinary
    "{ Pragma: +optSpace }"

    "report an error, that the stream is in binary mode"

    ^ InvalidModeError
	raiseRequestWith:self
	errorString:(self class name , ' is in binary mode')
	"/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:43 / cg"
!

errorNotBinary
    "{ Pragma: +optSpace }"

    "report an error, that the stream is not in binary mode"

    ^ InvalidModeError
	raiseRequestWith:self
	errorString:(self class name , ' is not in binary mode')
	"/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:40 / cg"
!

errorNotBuffered
    "{ Pragma: +optSpace }"

    "report an error, that the stream is not in buffered mode"

    ^ StreamError
	raiseRequestWith:self
	errorString:(self class name , ' is unbuffered - operation not allowed')
	"/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:36 / cg"
!

errorReadOnly
    "{ Pragma: +optSpace }"

    "report an error, that the stream is a readOnly stream"

    ^ InvalidWriteSignal raiseRequestWith:self "/ in:thisContext sender

    "Modified: / 30.7.1999 / 17:08:19 / cg"
!

errorReporter
    "ST-80 mimicry."

    ^ self class
!

errorUnsupportedOperation
    "{ Pragma: +optSpace }"

    "report an error, that some unsupported operation was attempted"

    ^ InvalidOperationError raiseRequestWith:self  "/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:24 / cg"
!

errorWriteOnly
    "{ Pragma: +optSpace }"

    "report an error, that the stream is a writeOnly stream"

    ^ InvalidReadError raiseRequestWith:self  "/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:20 / cg"
!

ioError
    "report an error, that some I/O error occurred.
     (for example, a device-IO-error, or reading an NFS-dir,
     which is no longer available and has been mounted soft)"

    "{ Pragma: +optSpace }"

    self ioError:lastErrorNumber

    "Modified: / 8.5.1999 / 20:12:16 / cg"
!

ioError:errorNumber
    "report an error, that some I/O error occurred.
     (for example, a device-IO-error, or reading an NFS-dir,
     which is no longer available and has been mounted soft)"

    "{ Pragma: +optSpace }"

    ^ StreamIOError newException
        errorCode:errorNumber;
        osErrorHolder:(OperatingSystem errorHolderForNumber:errorNumber);
        parameter:self;
        raiseRequest

    "Modified: / 8.5.1999 / 20:12:16 / cg"
!

lastErrorNumber
    "return the last error"

    ^ lastErrorNumber
!

lastErrorString
    "return a message string describing the last error"

    (lastErrorNumber isNil or:[lastErrorNumber == 0]) ifTrue:[
	^ 'I/O error'
    ].
    ^ OperatingSystem errorTextForNumber:lastErrorNumber
!

lastErrorSymbol
    "return an error symbol describing the last error"

    ^ OperatingSystem errorSymbolForNumber:lastErrorNumber
!

openError
    "report an error, that the open failed"

    "{ Pragma: +optSpace }"

    ^ self openError:lastErrorNumber.
!

openError:errorNumber
    "report an error, that the open failed"

    "{ Pragma: +optSpace }"

    |exClass errorHolder|

    errorHolder := OperatingSystem errorHolderForNumber:errorNumber.

    exClass := (errorHolder errorCategory == #nonexistentSignal)
        ifTrue:[ FileDoesNotExistException ]
        ifFalse:[ OpenError ].

    ^ exClass newException
        errorCode:errorNumber;
        osErrorHolder:errorHolder;
        "/ cg: initialized lazily - see OpenError>>#description
        "/ errorString:(' : ' , errorHolder errorString);
        parameter:self;
        raiseRequest
        "/ in:thisContext sender

    "Modified: / 09-09-2011 / 07:22:49 / cg"
!

readError
    "report an error, that some read error occurred"

    "{ Pragma: +optSpace }"

    ^ self readError:lastErrorNumber
!

readError:errorNumber
    "report an error, that some read error occurred"

    "{ Pragma: +optSpace }"

    ^ ReadError newException
        errorCode:errorNumber;
        osErrorHolder:(OperatingSystem errorHolderForNumber:errorNumber);
        parameter:self;
        raiseRequest
!

writeError
    "report an error, that some write error occurred"

    "{ Pragma: +optSpace }"

    ^ self writeError:lastErrorNumber
!

writeError:errorNumber
    "report an error, that some write error occurred"

    "{ Pragma: +optSpace }"

    ^ WriteError newException
        errorCode:errorNumber;
        osErrorHolder:(OperatingSystem errorHolderForNumber:errorNumber);
        parameter:self;
        raiseRequest
! !

!ExternalStream methodsFor:'finalization'!

executor
    "return a copy for finalization-registration;
     since all we need at finalization time is the fileDescriptor,
     a cheaper copy is possible."

    ^ self class basicNew setAccessor:handleType to:handle
!

finalize
    "some Stream has been collected - close the file if not already done"

    self closeFile
!

reRegisterForFinalization
    Lobby registerChange:self.
!

registerForFinalization

    "keep myself in newSpace, so it will be finalized early"
    Lobby size < MaxNonTenurableExecutors ifTrue:[
	ObjectMemory preventTenureOf:self.
    ].
    Lobby register:self.
!

unregisterForFinalization
    Lobby unregister:self.
     "probably the object will be collected soon..."
    ObjectMemory allowTenureOf:self
! !

!ExternalStream methodsFor:'initialization'!

initialize
    position := 0.
    binary := false.
    buffered := true.
    self initializeEOLMode.
    hitEOF := false.
!

initializeEOLMode
    eolMode := DefaultEOLMode.
! !

!ExternalStream methodsFor:'line reading/writing'!

nextLine
    "read the next line (characters up to newline).
     Return a string containing those characters excluding the newline.
     If the previous-to-last character is a cr, this is also removed,
     so it's possible to read alien (i.e. ms-dos) text as well.
     The line must be shorter than 32K characters - otherwise an error is signalled."

    |line error|

%{  /* STACK:100000 */

    FILEPOINTER f;
    int len, ret;
    char buffer[32*1024];
    char *rslt, *nextPtr, *limit;
    int fd, ch;
    int _buffered;
    OBJ fp;
    int lineTooLong = 0;
    int cutOff = 0;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
            && (__INST(binary) != true)
        ) {
            f = __FILEVal(fp);
            buffer[0] = '\0';

            _buffered = (__INST(buffered) == true);
            if (_buffered) {
                __READING__(f);
            }

            rslt = nextPtr = buffer;
            limit = buffer + sizeof(buffer) - 2;

            for (;;) {
                __READBYTE__(ret, f, nextPtr, _buffered, __INST(handleType));
                if (ret <= 0) {
                    if (nextPtr == buffer)
                        rslt = NULL;
                    if (ret == 0) {
                        __INST(hitEOF) = true;
                        break;
                    } else {
                        error = __mkSmallInteger(__threadErrno);
                        goto err;
                    }
                }

                if (*nextPtr == '\n') {
                    cutOff = 1;
                    *nextPtr = '\0';
                    break;
                }
                if (*nextPtr == '\r') {
                    char peekChar;

                    /*
                     * peek ahead for a newLine ...
                     */
                    __READBYTE__(ret, f, &peekChar, _buffered, __INST(handleType));
                    if (ret <= 0) {
                        cutOff = 1;
                        *nextPtr = '\0';
                        if (ret == 0) {
                            __INST(hitEOF) = true;
                            break;
                        }
                        error = __mkSmallInteger(__threadErrno);
                        goto err;
                    }

                    if (peekChar == '\n') {
                        cutOff = 2;
                        *nextPtr = '\0';
                        break;
                    }

                    __UNGETC__(peekChar, f, _buffered);

                    cutOff = 1;
                    *nextPtr = '\0';
                    break;
                }

                nextPtr++;
                if (nextPtr >= limit) {
                    *nextPtr = '\0';
                    lineTooLong = 1;
                    // signalled below anyway; so no need to print on stderr
#if 0                    
                    if (@global(InfoPrinting) == true) {
                        fprintf(stderr, "ExtStream [warning]: line truncated in nextLine\n");
                    }
#endif
                    break;
                }
            }

            if (rslt != NULL) {
                len = nextPtr-buffer;

                if (__isSmallInteger(__INST(position))) {
                    INT np = __intVal(__INST(position)) + len + cutOff;
                    OBJ t;

                    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
                } else {
                    __INST(position) = nil; /* i.e. do not know */
                }
                /* remove any EOL character */
                if (len != 0) {
                    if (buffer[len-1] == '\n') {
                        buffer[--len] = '\0';
                    }
                    if ((len != 0) && (buffer[len-1] == '\r')) {
                        buffer[--len] = '\0';
                    }
                }
                line = __MKSTRING_L(buffer, len);
                if (! lineTooLong) {
                    RETURN ( line );
                }
            }
        }
    }
err: ;
%}.
    line notNil ifTrue:[
        "/ the line as read is longer than 32k characters (boy - what a line)
        "/ The exception could be handled by reading more and returning the
        "/ concatenation in your exception handler (the receiver and the partial
        "/ line are passed as parameter)

        LineTooLongErrorSignal isHandled ifTrue:[
            ^ LineTooLongErrorSignal
                raiseRequestWith:(Array with:self with:line)
                     errorString:('line too long read error')
        ].
        'ExternalStream [warning]: line truncated in nextLine' infoPrintCR.
        ^ line , self nextLine
    ].

    hitEOF ifTrue:[^ self pastEndRead].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    binary ifTrue:[^ self errorBinary].
    ^ super nextLine
!

nextPutLine:aString
    "write the characters in aString and append an end-of-Line marker
     (LF, CR or CRLF - depending in the setting of eolMode)"

    |error|
%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(readonly))
	    && (__INST(binary) != true)
	    && __isStringLike(aString)
	) {
	    int _buffered = (__INST(buffered) == true);
	    int len = __stringSize(aString);
	    int cnt, len1;
	    FILEPOINTER f = __FILEVal(fp);
	    char *cp;
	    int o_offs;

	    if (_buffered) {
		__WRITING__(f)
	    }
#if defined(WIN32) && !defined(__MINGW__)
	    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
		cnt = __win32_fwrite(__stringVal(aString), 1, len, f);
	    } else
#endif
	    {
		o_offs = (char *)__stringVal(aString)-(char *)aString;
		__WRITEBYTES_OBJ__(cnt, f, aString, o_offs, len, _buffered, __INST(handleType));
	    }
	    if (cnt == len) {
		OBJ mode = __INST(eolMode);

		len1 = len;

		if (mode == @symbol(cr)) {
		    cp = "\r"; len = 1;
		} else if (mode == @symbol(crlf)) {
		    cp = "\r\n"; len = 2;
		} else if (mode == @symbol(eot)) {
		    cp = "\004"; len = 1;
		} else if (mode == @symbol(etx)) {
		    cp = "\003"; len = 1;
		} else {
		    cp = "\n"; len = 1;
		}
#if defined(WIN32) && !defined(__MINGW__)
		if ((f == __win32_stdout()) || (f == __win32_stderr())) {
		    cnt = __win32_fwrite(cp, 1, len, f);
		} else
#endif
		{
		    __WRITEBYTES__(cnt, f, cp, len, _buffered, __INST(handleType));
		}
		if (cnt > 0) {
		    if (__isSmallInteger(__INST(position))) {
			INT np = __intVal(__INST(position)) + cnt;
			OBJ t;

			t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		    } else {
			__INST(position) = nil; /* i.e. do not know */
		    }
		    RETURN ( self );
		}
	    }
	    error = __mkSmallInteger(__threadErrno);
	}
    }
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ self
    ].
    super nextPutLine:aString.
!

nextPutLinesFrom:aStream upToLineStartingWith:aStringOrNil
    "read from aStream up to and including a line starting with aStringOrNil
     and append all lines to self.
     Can be used to copy/create large files or copy from a pipe/socket.

     If aStringOrNil is nil or not matched, copy proceeds to the end."

    |line|

    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	line isNil ifTrue:[
	    ^ self.
	].
	self nextPutLine:line.
	(aStringOrNil notNil and:[line startsWith:aStringOrNil]) ifTrue:[
	    ^ self
	]
    ].
!

peekForLineStartingWith:aString
    "read ahead for next line starting with aString;
     return the line-string if found, or nil if EOF is encountered.
     If matched, do not advance position beyond that line
     i.e. nextLine will read the matched line.
     If not matched, reposition to original position for further reading."

    |firstPos lastPos line|

    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    handle isNil ifTrue:[^ self errorNotOpen].
    binary ifTrue:[^ self errorBinary].
    buffered ifFalse:[^ self errorNotBuffered].

    firstPos := self position.
    [self atEnd] whileFalse:[
	lastPos := self position.
	line := self nextLine.
	line isNil ifTrue:[
	    self position:firstPos.
	    ^ nil
	].
	(line startsWith:aString) ifTrue:[
	    self position:lastPos.
	    ^ line
	]
    ].
    self position:firstPos.
    ^ nil
!

peekForLineStartingWithAny:aCollectionOfStrings
    "read ahead for next line starting with any of aCollectionOfStrings;
     return the index in aCollection if found, nil otherwise..
     If no match, do not change position; otherwise advance right before the
     matched line so that nextLine will return this line."

    |line startPos linePos index|

    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    handle isNil ifTrue:[^ self errorNotOpen].
    binary ifTrue:[^ self errorBinary].

    startPos := self position.
    [self atEnd] whileFalse:[
	linePos := self position.
	line := self nextLine.
	line notNil ifTrue:[
	    index := 1.
	    aCollectionOfStrings do:[:prefix |
		(line startsWith:prefix) ifTrue:[
		    self position:linePos.
		    ^ index
		].
		index := index + 1
	    ]
	]
    ].
    self position:startPos.
    ^ nil
! !

!ExternalStream methodsFor:'misc functions'!

async:aBoolean
    "set/clear the async attribute - if set, the availability of data on
     the receiver will trigger an ioInterrupt.
     If cleared (which is the default) no special notification is made.
     Notice:
	not every OS supports this
	- check with OS>>supportsIOInterrupts before using"

    |fd|

    handle isNil ifTrue:[^ self errorNotOpen].

    OperatingSystem supportsIOInterrupts ifFalse:[
	^ self errorUnsupportedOperation
    ].

    fd := self fileDescriptor.
    aBoolean ifTrue:[
	^ OperatingSystem enableIOInterruptsOn:fd
    ].
    ^ OperatingSystem disableIOInterruptsOn:fd

    "Modified: 11.1.1997 / 17:50:21 / cg"
!

blocking:aBoolean
    "set/clear the blocking attribute - if set (which is the default)
     a read (using next) on the receiver will block until data is available.
     If cleared, a read operation will immediately return with a value of
     nil.
     Turning off blocking is useful when reading from PipeStreams
     or Sockets, and the amount of data to be read is not known
     in advance. However, the data must then be read using #nextBytes:
     methods, in order to avoid other (pastEndRead) exceptions."

    handle isNil ifTrue:[^ self errorNotOpen].
    ^ OperatingSystem setBlocking:aBoolean on:self fileDescriptor.

    "Modified: / 11.1.1997 / 17:48:01 / cg"
    "Modified: / 15.1.1998 / 11:49:48 / stefan"
!

copyToEndFrom:inStream
    "read from inStream, and write all data up to the end to the receiver.
     Return the number of bytes which have been transferred.
     Same functionality as copyToEnd:, but reversed arg and receiver
     (useful in a cascade message of the writeStream)"

    |bufferSize|

    OperatingSystem isMSDOSlike ifTrue:[
	"/ mhmh - NT hangs, when copying bigger blocks to a network drive - why ?
	bufferSize := 1 * 1024.
    ] ifFalse:[
	bufferSize := 8 * 1024.
    ].

    ^ inStream copyToEndInto:self bufferSize:bufferSize

    "
     |in out|

     in := 'Makefile' asFilename readStream.
     out := Stdout.
     in copyToEndInto:out.
     in close.
    "
!

copyToEndInto:outStream
    "copy the data into another stream."

    |bufferSize|

    (self isFileStream and:[outStream isFileStream]) ifTrue:[
	bufferSize := 8192 * 8.     "/ 64k buffer size
    ] ifFalse:[
	OperatingSystem isMSDOSlike ifTrue:[
	    "/ mhmh - NT hangs, when copying bigger blocks to a network drive - why ?
	    bufferSize := 1 * 1024.
	] ifFalse:[
	    bufferSize := 8 * 1024.
	].
    ].
    ^ self copyToEndInto:outStream bufferSize:bufferSize

    "
     |in out|

     in := 'Makefile' asFilename readStream.
     out := Stdout.
     in copyToEndInto:out.
     in close.
    "
!

ioctl:ioctlNumber
    "to provide a simple ioctl facility - an ioctl is performed
     on the underlying file; no arguments are passed."

    ^ self ioctl:ioctlNumber with:nil
!

ioctl:ioctlNumber with:arg
    "to provide a simple ioctl facility - an ioctl is performed
     on the underlying file; the argument is passed as argument.
     This is not used by ST/X, but provided for special situations
     - for example, to control proprietrary I/O devices.

     Since the type of the argument depends on the ioctl being
     performed, different arg types are allowed here.
     If the argument is nil, an ioctl without argument is performed.
     If the argument is an integral number, it's directly passed;
     if it's a kind of ByteArray (ByteArray, String or Structure),
     or external data (ExternalBytes or ExternalAddress),
     a pointer to the data is passed.
     This allows performing most ioctls
     - however, it might be tricky to setup the buffer.
     Be careful in what you pass - ST/X cannot validate its correctness."

    |error|

%{
#if !defined(MSDOS_LIKE) && !defined(__openVMS__)
    int fd;
    int ret;
    unsigned int ioNum;
    INT ioArg;
    OBJ fp = __INST(handle);

    if (fp == nil)
	goto out;

    if (!__isInteger(ioctlNumber)
	 || (!__isInteger(arg)
	     && (arg != nil)
	     && !__isBytes(arg)
	     && !__isExternalBytesLike(arg)
	     && !__isExternalAddress(arg))) {
	error = @symbol(badArgument);
	goto out;
    }

    if (__INST(handleType) == @symbol(socketHandle)) {
	fd = (int)((SOCKET)(__FILEVal(fp)));
    } else
	if ((__INST(handleType) == nil)
	 || (__INST(handleType) == @symbol(filePointer))
	 || (__INST(handleType) == @symbol(socketFilePointer))
	 || (__INST(handleType) == @symbol(pipeFilePointer))) {
	fd = fileno(__FILEVal(fp));
    } else {
	error = @symbol(badHandleType);
	goto out;
    }

    ioNum = __unsignedLongIntVal(ioctlNumber);

    __BEGIN_INTERRUPTABLE__
    do {
	__threadErrno = 0;
	if (arg == nil) {
	    ioArg = 0;
	} else if (__isSmallInteger(arg)) {
	    ioArg = __intVal(arg);
	} else if (__isInteger(arg)) {
	    ioArg = __unsignedLongIntVal(arg);
	} else if (__isExternalBytesLike(arg)) {
	    ioArg = (INT)(__externalBytesAddress(arg));
	} else if (__isExternalAddress(arg)) {
	    ioArg = (INT)(__externalAddressVal(arg));
	} else {
	    ioArg = (INT)(__ByteArrayInstPtr(arg)->ba_element);
	}
	ret = ioctl(fd, ioNum, ioArg);
    } while (ret < 0 && __threadErrno == EINTR);
    __END_INTERRUPTABLE__

    if (ret >= 0) {
	RETURN ( __mkSmallInteger(ret) );
    }
    error = __mkSmallInteger(__threadErrno);
#endif

out:;
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	^ self ioError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].

    "/ the system does not support ioctl (MSDOS or VMS)
    ^ self errorUnsupportedOperation
!

reset
    "set the read position to the beginning of the collection"

    self position:0
!

setToEnd
    "redefined since it must be implemented differently"

    ^ self subclassResponsibility
!

sync
    "make sure, that the OS writes cached data to the disk"

    |error|

    self flush.

%{
#if !defined(__openVMS__)
    int fd;
    int ret;
    OBJ fp = __INST(handle);

    if (fp == nil)
	goto out;

    if (__INST(handleType) == @symbol(socketHandle)) {
	// syncing a socket to disk ?
	error = @symbol(badHandleType);
	goto out;
	// fd = __FILEVal(fp);
    } else
	if ((__INST(handleType) == nil)
	       || (__INST(handleType) == @symbol(filePointer))
	       || (__INST(handleType) == @symbol(socketFilePointer))
	       || (__INST(handleType) == @symbol(pipeFilePointer))) {
	fd = fileno(__FILEVal(fp));
    } else {
	error = @symbol(badHandleType);
	goto out;
    }

#ifdef __win32__
     __threadErrno = 0;
     ret = __STX_API_NOINT_CALL1( "FlushFileBuffers", FlushFileBuffers, _get_osfhandle(fd));
     if (ret) {
	 RETURN (self);
     }
#else
     __BEGIN_INTERRUPTABLE__
     do {
	 ret = fsync(fd);
     } while ((ret < 0) && (__threadErrno == EINTR));
     __END_INTERRUPTABLE__

     if (ret >= 0) {
	 RETURN (self);
     }
#endif /* ! __win32__ */
     error = __mkSmallInteger(__threadErrno);
#endif /* ! __openVMS__ */
out:;
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self ioError:error.
	^ self.
    ].
    handle isNil ifTrue:[self errorNotOpen].

    "
	|f|
	f := 'x' asFilename writeStream.
	f nextPutAll:'hallo'; sync; syncData; close
    "
!

syncData
    "make sure, that the OS writes cached data to the disk.
     In this case, metadata is only written, if it is
     required to read the file's data (so metadata will not be written,
     if only access/modification time has changed)."
    |error|

    self flush.

%{
#if !defined(__openVMS__)
    int fd;
    int ret;
    OBJ fp = __INST(handle);

    if (fp == nil)
	goto out;

    if (__INST(handleType) == @symbol(socketHandle)) {
	// syncing a socket to disk ?
	error = @symbol(badHandleType);
	goto out;
	// fd = __FILEVal(fp);
    } else
	if ((__INST(handleType) == nil)
	       || (__INST(handleType) == @symbol(filePointer))
	       || (__INST(handleType) == @symbol(socketFilePointer))
	       || (__INST(handleType) == @symbol(pipeFilePointer))) {
	fd = fileno(__FILEVal(fp));
    } else {
	error = @symbol(badHandleType);
	goto out;
    }

#ifdef __win32__
     __threadErrno = 0;
     ret = __STX_API_NOINT_CALL1( "FlushFileBuffers", FlushFileBuffers, _get_osfhandle(fd));
     if (ret) {
	 RETURN (self);
     }
#else
     __BEGIN_INTERRUPTABLE__
     do {
	 ret = fdatasync(fd);
     } while ((ret < 0) && (__threadErrno == EINTR));
     __END_INTERRUPTABLE__

     if (ret >= 0) {
	 RETURN (self);
     }
#endif /* ! __win32__ */
     error = __mkSmallInteger(__threadErrno);
#endif /* ! __openVMS__ */
out:;
%}.

    error notNil ifTrue:[
	lastErrorNumber := error.
	self ioError:error.
	^ self.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].

    "if notdef HAS_DATASYNC, fall back"
    self sync.

    "
	|f|
	f := 'x' asFilename writeStream.
	f nextPutAll:'hallo'; sync; syncData; close
    "
!

tcgetattr
    "unix only:
     provide the information of a tcgetattr call as a dictionary.
     This provides terminal setting values of a tty or pty.
     Used by terminal emulators.
     On non-unix systems, an unsupported operation error is raised"

    |error ret
     iflags "/ input flags
     ignbrk brkint ignpar parmrk inpck istrip inlcr igncr
     icrnl iuclc ixon ixoff ixany imaxbel iutf8
     oflags "/ output flags
     opost onlcr ocrnl olcuc onocr onlret oxtabs onoteot
     cflags "/ control flags
     csize cstopb cread parenb parodd hupcl clocal
     lflags "/ local flags
     echoke echoe echok echo echonl echoprt echoctl
     isig icanon altwerase iexten extproc tostop
     |

%{
#if !defined(MSDOS_LIKE) && !defined(__openVMS__)
    int fd;
    int _ret;
    OBJ fp = __INST(handle);
    struct termios t;
    int sz;

    if (fp == nil)
	goto out;

    if (__INST(handleType) == @symbol(socketHandle)) {
	// cg: termina attributes of a socket?
	error = @symbol(badHandleType);
	goto out;
	// fd = __FILEVal(fp);
    } else
	if ((__INST(handleType) == nil)
	 || (__INST(handleType) == @symbol(filePointer))
	 || (__INST(handleType) == @symbol(socketFilePointer))
	 || (__INST(handleType) == @symbol(pipeFilePointer))) {
	fd = fileno(__FILEVal(fp));
    } else {
	error = @symbol(badHandleType);
	goto out;
    }

    __BEGIN_INTERRUPTABLE__
    do {
	__threadErrno = 0;
	_ret = tcgetattr(fd, &t);
    } while (_ret < 0 && __threadErrno == EINTR);
    __END_INTERRUPTABLE__

    if (_ret < 0) {
	error = __mkSmallInteger(__threadErrno);
    }
    ignbrk = t.c_iflag & IGNBRK ? true : false;
    brkint = t.c_iflag & BRKINT ? true : false;
    ignpar = t.c_iflag & IGNPAR ? true : false;
    parmrk = t.c_iflag & PARMRK ? true : false;
    inpck = t.c_iflag & INPCK ? true : false;
    istrip = t.c_iflag & ISTRIP ? true : false;
    inlcr = t.c_iflag & INLCR ? true : false;
    ixon = t.c_iflag & IXON ? true : false;
    ixoff = t.c_iflag & IXOFF ? true : false;
    ixany = t.c_iflag & IXANY ? true : false;
# ifdef IMAXBEL
    imaxbel = t.c_iflag & IMAXBEL ? true : false;
# endif
# ifdef IUCLC
    iuclc = t.c_iflag & IUCLC ? true : false;
# endif

    opost = t.c_oflag & OPOST ? true : false;
    onlcr = t.c_oflag & ONLCR ? true : false;
# ifdef OXTABS
    oxtabs = t.c_oflag & OXTABS ? true : false;
# endif
# ifdef ONOTEOT
    onoteot = t.c_oflag & ONOTEOT ? true : false;
# endif
    ocrnl = t.c_oflag & OCRNL ? true : false;
# ifdef OLCUC
    olcuc = t.c_oflag & OLCUC ? true : false;
# endif
    onocr = t.c_oflag & ONOCR ? true : false;
    onlret = t.c_oflag & ONLRET ? true : false;

    sz = t.c_cflag & CSIZE;
    switch (sz) {
	case CS5:
	    csize = @symbol(cs5);
	    break;
	case CS6:
	    csize = @symbol(cs6);
	    break;
	case CS7:
	    csize = @symbol(cs7);
	    break;
	case CS8:
	    csize = @symbol(cs8);
	    break;
    }
    cstopb = t.c_cflag & CSTOPB ? true : false;
    cread = t.c_cflag & CREAD ? true : false;
    parenb = t.c_cflag & PARENB ? true : false;
    parodd = t.c_cflag & PARODD ? true : false;
    hupcl = t.c_cflag & HUPCL ? true : false;
    clocal = t.c_cflag & CLOCAL ? true : false;

    echoke = t.c_lflag & ECHOKE ? true : false;
    echoe = t.c_lflag & ECHOE ? true : false;
    echo = t.c_lflag & ECHO ? true : false;
    echonl = t.c_lflag & ECHONL ? true : false;
    echoctl = t.c_lflag & ECHOCTL ? true : false;
    isig = t.c_lflag & ISIG ? true : false;
    icanon = t.c_lflag & ICANON ? true : false;
# ifdef ALTWERASE
    altwerase = t.c_lflag & ALTWERASE ? true : false;
# endif
# ifdef IEXTEN
    iexten = t.c_lflag & IEXTEN ? true : false;
# endif
# ifdef EXTPROC
    extproc = t.c_lflag & EXTPROC ? true : false;
# endif
# ifdef TOSTOP
    tostop = t.c_lflag & TOSTOP ? true : false;
# endif

#else
    error = @symbol(unsupportedOperation);
#endif

out:;
%}.
    error notNil ifTrue:[
	error == #unsupportedOperation ifTrue:[
	    "/ the system does not support tcgetattr
	    ^ self errorUnsupportedOperation
	].
	lastErrorNumber := error.
	^ self ioError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].

    "/ construct a dictionary...
    ret := Dictionary new.
    ret at:#iflags put:(iflags := Dictionary new).
    ret at:#oflags put:(oflags := Dictionary new).
    ret at:#cflags put:(cflags := Dictionary new).
    ret at:#lflags put:(lflags := Dictionary new).
    iflags at:#ignbrk put:ignbrk.
    iflags at:#brkint put:brkint.
    iflags at:#ignpar put:ignpar.
    iflags at:#parmrk put:parmrk.
    iflags at:#inpck put:inpck.
    iflags at:#istrip put:istrip.
    iflags at:#inlcr put:inlcr.
    iflags at:#igncr put:igncr.
    iflags at:#icrnl put:icrnl.
    iflags at:#uiclc put:iuclc.
    iflags at:#ixon put:ixon.
    iflags at:#ixoff put:ixoff.
    iflags at:#ixany put:ixany.
    iflags at:#imaxbel put:imaxbel.
    iflags at:#iutf8 put:iutf8.

    oflags at:#opost put:opost.
    oflags at:#onlcr put:onlcr.
    oflags at:#oxtabs put:oxtabs.
    oflags at:#onoteot put:onoteot.

    cflags at:#csize put:csize.
    cflags at:#cstopb put:cstopb.
    cflags at:#cread put:cread.
    cflags at:#parenb put:parenb.
    cflags at:#parodd put:parodd.
    cflags at:#hupcl put:hupcl.
    cflags at:#clocal put:clocal.

    lflags at:#echoke put:echoke.
    lflags at:#echoe put:echoe.
    lflags at:#echok put:echok.
    lflags at:#echo put:echo.
    lflags at:#echonl put:echonl.
    lflags at:#echoprt put:echoprt.
    lflags at:#echoctl put:echoctl.
    lflags at:#isig put:isig.
    lflags at:#icanon put:icanon.
    lflags at:#altwerase put:altwerase.
    lflags at:#iexten put:iexten.
    lflags at:#extproc put:extproc.
    lflags at:#tostop put:tostop.
    ^ ret
! !

!ExternalStream methodsFor:'non homogenous reading'!

next:count into:aCollection startingAt:start
    "return the next count bytes or characters from the stream."

    |readCount|

    readCount := self nextBytes:count into:aCollection startingAt:start.
    readCount = count ifTrue:[
        ^ aCollection.
    ].
    ^ aCollection copyFrom:1 to:start+readCount-1.
!

nextAvailable:count
    "return the next count elements of the stream as aCollection.
     If the stream reaches the end before count elements have been read,
     return what is available. (i.e. a shorter collection).
     The type of collection is specified in #contentsSpecies."

    |buffer n|

    buffer := self contentsSpecies uninitializedNew:count.
    n := self nextAvailableBytes:count into:buffer startingAt:1.
    n == 0 ifTrue:[
        binary ifTrue:[
            ^ #[]
        ].
        ^ ''
    ].

    n ~~ count ifTrue:[
        ^ buffer copyTo:n
    ].
    ^ buffer.

    "
     (ReadStream on:#(1 2 3 4 5)) nextAvailable:3
     (ReadStream on:#(1 2 3 4 5)) nextAvailable:10
     (ReadStream on:'hello') nextAvailable:3
     (ReadStream on:'hello') nextAvailable:10
    "

    "Modified: / 16.6.1998 / 15:52:41 / cg"
!

nextAvailable:count into:aCollection startingAt:pos
    "return the next count elements of the stream into aCollection at position pos."

    ^ self nextAvailableBytes:count into:aCollection startingAt:pos.
!

nextAvailableBytes:count into:anObject startingAt:start
    "read the next count bytes into an object and return the number of
     bytes read or the number of bytes read, if EOF is encountered before,
     or no more bytes are available for reading (from the pipe/socket).

     If the receiver is some socket/pipe-like stream, an exception
     is raised if the connection is broken.

     Notice, that in contrast to other methods,
     this does NOT return nil on EOF, but the actual count.
     Thus allowing read of partial blocks.

     The object must have non-pointer indexed instvars
     (i.e. it must be a ByteArray, String, Float- or DoubleArray).
     If anObject is a string or byteArray and reused, this provides the
     fastest possible physical I/O (since no new objects are allocated).

     Use with care - non object oriented I/O.
     Warning: in general, you cannot use this method to pass data from other
     architectures since it does not care for byte order or float representation."

    |error|

%{
    FILEPOINTER f;
    int cnt, offs, ret, _buffered;
    int objSize, nInstBytes;
    char *cp;
    char *extPtr;
    OBJ fp;
    int o_offs;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
            && __bothSmallInteger(count, start)
        ) {
            f = __FILEVal(fp);

            cnt = __intVal(count);
            offs = __intVal(start) - 1;

            if (__isExternalBytesLike(anObject)) {
                OBJ sz;

                nInstBytes = 0;
                extPtr = (char *)(__externalBytesAddress(anObject));
                if (extPtr == NULL) goto bad;
                sz = __externalBytesSize(anObject);
                if (__isSmallInteger(sz)) {
                    objSize = __intVal(sz);
                } else {
                    objSize = 0; /* unknown */
                }
            } else {
                OBJ oClass = __Class(anObject);
                int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

                nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);

                switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
                    case BYTEARRAY:
                    case WORDARRAY:
                    case LONGARRAY:
                    case SWORDARRAY:
                    case SLONGARRAY:
                    case FLOATARRAY:
                        break;
                    case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
                        nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
                        break;
                    case LONGLONGARRAY:
                    case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
                        nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
                        break;
                    default:
                        goto bad;
                }
                extPtr = (char *)0;
                objSize = __Size(anObject) - nInstBytes;
            }

            if ((offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs))) {
                _buffered = (__INST(buffered) == true);
                if (_buffered) {
                    __READING__(f);
                }

                if (extPtr) {
                    __READAVAILBYTES__(ret, f, extPtr+offs, cnt, _buffered, __INST(handleType));
                } else {
                    /*
                     * on interrupt, anObject may be moved to another location.
                     * So we pass (char *)__InstPtr(anObject) + nInstBytes + offs to the macro __READ_BYTES__,
                     * to get a new address.
                     */
                    offs += nInstBytes;
                    __READAVAILBYTES_OBJ__(ret, f, anObject, offs, cnt, _buffered, __INST(handleType));
                }
                /* 0 is NOT an EOF condition here ... */
                if (ret >= 0) {
                    if (__isSmallInteger(__INST(position))) {
                        INT np = __intVal(__INST(position)) + ret;
                        OBJ t;

                        t = __MKINT(np); __INST(position) = t; __STORE(self, t);
                    } else {
                        __INST(position) = nil; /* i.e. do not know */
                    }
                    RETURN (__mkSmallInteger(ret));
                }
                __INST(position) = nil;
                error = __mkSmallInteger(__threadErrno);
            }
        }
    }
bad: ;
%}.
    hitEOF ifTrue:[^ 0].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    "
     count not integer or arg not bit-like (String, ByteArray etc)
    "
    ^ self primitiveFailed
!

nextByte
    "read the next byte and return it as an Integer; return nil on error.
     This is allowed in both text and binary modes, always returning the
     bytes binary value as an integer in 0..255."

    |error|
%{
#ifdef __SCHTEAM__
    STObject handle = self.instVarAt(I_handle);

    if (handle != STObject.Nil) {
	STObject next;

	next = handle.nextByte();
	if (next != STObject.EOF) {
	    self.instVarAt_put(I_position, STObject.Nil);
	    return __c__._RETURN( next );
	}
	self.instVarAt_put(I_hitEOF, STObject.True);
    }
#else
    FILEPOINTER f;
    unsigned char byte;
    int ret, _buffered;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(writeonly))) {
	    f = __FILEVal(fp);

	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTE__(ret, f, &byte, _buffered, __INST(handleType));
	    if (ret > 0) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 1;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN (__mkSmallInteger(byte));
	    }

	    if (ret == 0) {
		__INST(hitEOF) = true;
	    } else /* ret < 0 */ {
		__INST(position) = nil;
		error = __mkSmallInteger(__threadErrno);
	    }
	}
    }
#endif /* not SCHTEAM */
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    error notNil ifTrue:[
	lastErrorNumber := error.
	^ self readError:error
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    ^ self errorWriteOnly
!

nextBytes:count into:anObject startingAt:start
    "read the next count bytes into an object and return the number of
     bytes read or the number of bytes read, if EOF is encountered before.
     If the receiver is some socket/pipe-like stream, an exception
     is raised if the connection is broken.

     Warning: if used with a pipe/socket, this blocks until the requested number
     of bytes have been read. See #nextAvailableBytes:into:startingAt:
     to only read whats there.

     Notice, that in contrast to other methods,
     this does NOT return nil on EOF, but the actual count.
     Thus allowing read of partial blocks.

     The object must have non-pointer indexed instvars
     (i.e. it must be a ByteArray, String, Float- or DoubleArray),
     or an externalBytes object (with known size).
     If anObject is a string or byteArray and reused, this provides the
     fastest possible physical I/O (since no new objects are allocated).

     Use with care - non object oriented I/O.
     Warning: in general, you cannot use this method to pass data from other
     architectures (unless you prepared the buffer with care),
     since it does not care for byte order or float representation."

    |error|
%{
    FILEPOINTER f;
    int cnt, offs, ret, _buffered;
    int objSize, nInstBytes;
    char *extPtr;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
            && __bothSmallInteger(count, start)
        ) {
            f = __FILEVal(fp);

            cnt = __intVal(count);
            offs = __intVal(start) - 1;

            if (__isExternalBytesLike(anObject)) {
                OBJ sz;

                nInstBytes = 0;
                extPtr = (char *)(__externalBytesAddress(anObject));
                if (extPtr == NULL) goto bad;
                sz = __externalBytesSize(anObject);
                if (__isSmallInteger(sz)) {
                    objSize = __intVal(sz);
                } else {
                    objSize = 0; /* unknown */
                }
            } else {
                OBJ oClass = __Class(anObject);
                int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

                nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
                switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
                    case BYTEARRAY:
                    case WORDARRAY:
                    case LONGARRAY:
                    case SWORDARRAY:
                    case SLONGARRAY:
                    case FLOATARRAY:
                        break;
                    case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
                        nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
                        break;
                    case LONGLONGARRAY:
                    case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
                        nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
                        break;
                    default:
                        goto bad;
                }
                extPtr = (char *)0;
                objSize = __Size(anObject) - nInstBytes;
            }
            if ((offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs))) {
                _buffered = (__INST(buffered) == true);
                if (_buffered) {
                    __READING__(f);
                }

                if (extPtr) {
                    __READBYTES__(ret, f, extPtr+offs, cnt, _buffered, __INST(handleType));
                } else {
                    /*
                     * on interrupt, anObject may be moved to another location.
                     * So we pass anObject, and the offset to the __READBYTES_OBJ__ macro.
                     */
                    offs += nInstBytes;
                    __READBYTES_OBJ__(ret, f, anObject, offs, cnt, _buffered, __INST(handleType));
                }

                if (ret > 0) {
                    if (__isSmallInteger(__INST(position))) {
                        INT np = __intVal(__INST(position)) + ret;
                        OBJ t = __MKINT(np); __INST(position) = t; __STORE(self, t);
                    } else {
                        __INST(position) = nil; /* i.e. do not know */
                    }
                    RETURN (__mkSmallInteger(ret));
                }
                if (ret == 0) {
                    __INST(hitEOF) = true;
                } else /* ret < 0 */ {
                    __INST(position) = nil;
                    error = __mkSmallInteger(__threadErrno);
                }
            }
        }
    }
bad: ;
%}.
    hitEOF ifTrue:[^ 0].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    "
     count not integer or arg not bit-like (String, ByteArray etc)
    "
    ^ self primitiveFailed
!

nextInt16MSB:msbFlag
    "Read two bytes and return the value as a 16-bit signed Integer.
     If msbFlag is true, value is read with most-significant byte first,
     otherwise least-significant byte comes first.
     A nil is returned if EOF is reached (also when EOF is hit after the first byte).
     Works in both binary and text modes."

    |error|
%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(writeonly))
	) {
	    FILEPOINTER f;
	    int ret, _buffered;
	    short value;
	    union {
		unsigned char buffer[2];
		short shortVal;
	    } u;

	    f = __FILEVal(fp);
	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTES__(ret, f, u.buffer, 2, _buffered, __INST(handleType));

	    if (ret == 2) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 2;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		if (msbFlag == true) {
#if defined(__MSBFIRST__)
		    value = u.shortVal;
#else
		    value = ((u.buffer[0] & 0xFF) << 8) | (u.buffer[1] & 0xFF);
#endif
		} else {
#if defined(__LSBFIRST__)
		    value = u.shortVal;
#else
		    value = ((u.buffer[1] & 0xFF) << 8) | (u.buffer[0] & 0xFF);
#endif
		}
		RETURN (__mkSmallInteger(value));
	    }

	    if (ret < 0) {
		__INST(position) = nil; /* i.e. do not know */
		error = __mkSmallInteger(__threadErrno);
	    } else /* ret == 0 */ {
		__INST(hitEOF) = true;
	    }
	}
    }
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    lastErrorNumber := error.
    ^ self readError:error.
!

nextInt32MSB:msbFlag
    "Read four bytes and return the value as a 32-bit signed Integer,
     which may be a LargeInteger.
     If msbFlag is true, value is read with most-significant byte first,
     otherwise least-significant byte comes first.
     A nil is returned, if EOF is hit before all 4 bytes have been read.
     Works in both binary and text modes."

    |error|
%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(writeonly))
	) {
	    FILEPOINTER f;
	    int ret, _buffered;
	    int value;
	    union {
		unsigned char buffer[4];
		int intVal;
	    } u;

	    f = __FILEVal(fp);
	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTES__(ret, f, u.buffer, 4, _buffered, __INST(handleType));

	    if (ret == 4) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 4;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		if (msbFlag == true) {
#if defined(__MSBFIRST__)
		    value = u.intVal;
#else
		    value = (u.buffer[0] & 0xFF);
		    value = (value << 8) | (u.buffer[1] & 0xFF);
		    value = (value << 8) | (u.buffer[2] & 0xFF);
		    value = (value << 8) | (u.buffer[3] & 0xFF);
#endif
		} else {
#if defined(__LSBFIRST__)
		    value = u.intVal;
#else
		    value = (u.buffer[3] & 0xFF);
		    value = (value << 8) | (u.buffer[2] & 0xFF);
		    value = (value << 8) | (u.buffer[1] & 0xFF);
		    value = (value << 8) | (u.buffer[0] & 0xFF);
#endif
		}
#if __POINTER_SIZE__ == 8
		RETURN ( __mkSmallInteger(value));
#else
		RETURN ( __MKINT(value) );
#endif
	    }

	    if (ret < 0) {
		__INST(position) = nil;
		error = __mkSmallInteger(__threadErrno);
	    } else /* ret == 0 */ {
		__INST(hitEOF) = true;
	    }
	}
    }
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    lastErrorNumber := error.
    ^ self readError:error.
!

nextUnsignedInt16MSB:msbFlag
    "Read two bytes and return the value as a 16-bit unsigned Integer.
     If msbFlag is true, value is read with most-significant byte first,
     otherwise least-significant byte comes first.
     A nil is returned if EOF is reached (also when EOF is hit after the first byte).
     Works in both binary and text modes."

    |error|
%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(writeonly))
	) {
	    FILEPOINTER f;
	    int ret, _buffered;
	    unsigned int value;
	    union {
		unsigned char buffer[2];
		unsigned short shortVal;
	    } u;

	    f = __FILEVal(fp);
	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTES__(ret, f, u.buffer, 2, _buffered, __INST(handleType));

	    if (ret == 2) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 2;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		if (msbFlag == true) {
#if defined(__MSBFIRST__)
		    value = u.shortVal;
#else
		    value = (u.buffer[0] << 8) | u.buffer[1];
#endif
		} else {
#if defined(__LSBFIRST__)
		    value = u.shortVal;
#else
		    value = (u.buffer[1] << 8) | u.buffer[0];
#endif
		}
		RETURN (__mkSmallInteger(value));
	    }

	    if (ret < 0) {
		__INST(position) = nil; /* i.e. do not know */
		error = __mkSmallInteger(__threadErrno);
	    } else /* ret == 0 */ {
		__INST(hitEOF) = true;
	    }
	}
    }
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    lastErrorNumber := error.
    ^ self readError:error.
!

nextUnsignedInt32MSB:msbFlag
    "Read four bytes and return the value as a 32-bit unsigned Integer, which may be
     a LargeInteger.
     If msbFlag is true, value is read with most-significant byte first, otherwise
     least-significant byte comes first.
     A nil is returned, if endOfFile occurs before all 4 bytes have been read.
     Works in both binary and text modes."

    |error|
%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(writeonly))
	) {
	    FILEPOINTER f;
	    int ret, _buffered;
	    unsigned INT value;
	    union {
		unsigned char buffer[4];
		unsigned int intVal;
	    } u;

	    f = __FILEVal(fp);
	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTES__(ret, f, u.buffer, 4, _buffered, __INST(handleType));

	    if (ret == 4) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 4;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		if (msbFlag == true) {
#if defined(__MSBFIRST__)
		    value = u.intVal;
#else
		    value = u.buffer[0];
		    value = (value << 8) | u.buffer[1];
		    value = (value << 8) | u.buffer[2];
		    value = (value << 8) | u.buffer[3];
#endif
		} else {
#if defined(__LSBFIRST__)
		    value = u.intVal;
#else
		    value = u.buffer[3];
		    value = (value << 8) | u.buffer[2];
		    value = (value << 8) | u.buffer[1];
		    value = (value << 8) | u.buffer[0];
#endif
		}
#if __POINTER_SIZE__ == 8
		value &= 0xFFFFFFFF;
		RETURN (__mkSmallInteger(value));
#else
		if (value <= _MAX_INT) {
		    RETURN (__mkSmallInteger(value));
		}
		RETURN (__MKULARGEINT(value) );
#endif
	    }

	    if (ret < 0) {
		__INST(position) = nil; /* i.e. do not know */
		error = __mkSmallInteger(__threadErrno);
	    } else /* ret == 0 */ {
		__INST(hitEOF) = true;
	    }
	}
    }
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    lastErrorNumber := error.
    ^ self readError:error.
!

nextWord
    <resource: #obsolete>
    "in text-mode:
         read the alphaNumeric next word (i.e. up to non letter-or-digit).
         return a string containing those characters.
     in binary-mode:
         read two bytes (msb-first) and return the value as a 16-bit
         unsigned Integer (for compatibility with other smalltalks)"

    binary ifTrue:[
        self obsoleteMethodWarning:'use #nextUnsignedInt16MSB:true'.
        ^ self nextUnsignedInt16MSB:true
    ].
    self obsoleteMethodWarning:'use #nextAlphaNumericWord'.
    ^ self nextAlphaNumericWord
! !

!ExternalStream methodsFor:'non homogenous writing'!

nextPutByte:aByteValue
    "write a byte.
     Works in both binary and text modes."

    |error|

%{
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(readonly))
	 && __isSmallInteger(aByteValue)

	) {
	    int _buffered = (__INST(buffered) == true);
	    FILEPOINTER f = __FILEVal(fp);
	    char c = __intVal(aByteValue);
	    int cnt;

	    if (_buffered) {
		__WRITING__(f)
	    }
#if defined(WIN32) && !defined(__MINGW__)
	    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
		cnt = __win32_fwrite(&c, 1, 1, f);
	    } else
#endif
	    {
		__WRITEBYTE__(cnt, f, &c, _buffered, __INST(handleType));
	    }
	    if (cnt == 1) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 1;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN (self);
	    }
	    if (cnt < 0) {
		__INST(position) = nil; /* i.e. do not know */
	    }
	    error = __mkSmallInteger(__threadErrno);
	}
    }
%}.
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    lastErrorNumber := error.
    self writeError:error.
!

nextPutInt16:anIntegerOrCharacter MSB:msbFlag
    "Write the argument, anIntegerOrCharacter as a short (two bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Notice that integers in the range -16r8000 to +16rFFFF can be written
     (i.e. both signed and unsigned int32 values can be written.
     Works in both binary and text modes."

    |error|
%{
    int num;
    union {
	char bytes[2];
	short shortVal;
    } u;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(readonly))
	) {
	    FILEPOINTER f = __FILEVal(fp);
	    int _buffered = (__INST(buffered) == true);
	    int cnt;

	    if (__isSmallInteger(anIntegerOrCharacter)) {
		num = __intVal(anIntegerOrCharacter);
	    } else if (__isCharacter(anIntegerOrCharacter)) {
		num = __smallIntegerVal(__characterVal(anIntegerOrCharacter));
	    } else
		goto out;

	    if (msbFlag == true) {
#if defined(__MSBFIRST__)
		u.shortVal = num;
#else
		u.bytes[0] = (num >> 8) & 0xFF;
		u.bytes[1] = num & 0xFF;
#endif
	    } else {
#if defined(__LSBFIRST__)
		u.shortVal = num;
#else
		u.bytes[1] = (num >> 8) & 0xFF;
		u.bytes[0] = num & 0xFF;
#endif
	    }

	    if (_buffered) {
		__WRITING__(f)
	    }
	    __WRITEBYTES__(cnt, f, u.bytes, 2, _buffered, __INST(handleType));

	    if (cnt == 2) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 2;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN ( self );
	    }
	    __INST(position) = nil; /* i.e. do not know */
	    error = __mkSmallInteger(__threadErrno);
	}
    }
out:;
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ self
    ].
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    self argumentMustBeInteger
!

nextPutInt16LSB:anIntegerOrCharacter
    "do not remove.
     See #patchByteOrderOptimizedMethods"

    self nextPutInt16:anIntegerOrCharacter MSB:false
!

nextPutInt16MSB:anIntegerOrCharacter
    "do not remove.
     See #patchByteOrderOptimizedMethods"

    self nextPutInt16:anIntegerOrCharacter MSB:true
!

nextPutInt16NATIVE:anIntegerOrCharacter
    "Write the argument, anIntegerOrCharacter as a short (two bytes) in native byte order.
     This is the CPU-specific byte order (LSB on x86, MSB on sparc, VAX and possibly on ARM).
     Notice that integers in the range -16r8000 to +16rFFFF can be written
     (i.e. both signed and unsigned int32 values can be written.
     Works in both binary and text modes."

    |error|
%{
    int num;
    union {
	char bytes[2];
	short shortVal;
    } u;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(readonly))
	) {
	    FILEPOINTER f = __FILEVal(fp);
	    int _buffered = (__INST(buffered) == true);
	    int cnt;

	    if (__isSmallInteger(anIntegerOrCharacter)) {
		num = __intVal(anIntegerOrCharacter);
	    } else if (__isCharacter(anIntegerOrCharacter)) {
		num = __smallIntegerVal(__characterVal(anIntegerOrCharacter));
	    } else
		goto out;

	    u.shortVal = num;

	    if (_buffered) {
		__WRITING__(f)
	    }
	    __WRITEBYTES__(cnt, f, u.bytes, 2, _buffered, __INST(handleType));

	    if (cnt == 2) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 2;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN ( self );
	    }
	    __INST(position) = nil; /* i.e. do not know */
	    error = __mkSmallInteger(__threadErrno);
	}
    }
out:;
%}.
    self nextPutInt16:anIntegerOrCharacter MSB:(UninterpretedBytes isBigEndian).
!

nextPutInt32:aNumber MSB:msbFlag
    "Write the argument, aNumber as a long (four bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Notice that integers in the range -16r80000000 to +16rFFFFFFFF can be written
     (i.e. both signed and unsigned int32 values can be written.
     Works in both binary and text modes."

    |error|

%{
    int num;
    union {
	char bytes[4];
	int intVal;
    } u;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if (__isSmallInteger(aNumber)) {
	num = __intVal(aNumber);
    } else {
#if __POINTER_SIZE__ == 8
	// always more than 4-bytes
	goto badArg;
#else
	num = __longIntVal(aNumber);
	if (num == 0) {
	    num = __signedLongIntVal(aNumber);
	    if (num == 0) {
		/* bad arg or out-of-range integer
		 * (handled by the fallBack code)
		 */
		goto badArg;
	    }
	}
#endif
    }

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(readonly))
	) {
	    int _buffered = (__INST(buffered) == true);
	    FILEPOINTER f = __FILEVal(fp);
	    int cnt;

	    if (msbFlag == true) {
#if defined(__MSBFIRST__)
		u.intVal = num;
#else
		u.bytes[0] = (num >> 24) & 0xFF;
		u.bytes[1] = (num >> 16) & 0xFF;
		u.bytes[2] = (num >> 8) & 0xFF;
		u.bytes[3] = num & 0xFF;
#endif
	    } else {
#if defined(__LSBFIRST__)
		u.intVal = num;
#else
		u.bytes[3] = (num >> 24) & 0xFF;
		u.bytes[2] = (num >> 16) & 0xFF;
		u.bytes[1] = (num >> 8) & 0xFF;
		u.bytes[0] = num & 0xFF;
#endif
	    }

	    if (_buffered) {
		__WRITING__(f)
	    }
	    __WRITEBYTES__(cnt, f, u.bytes, 4, _buffered, __INST(handleType));

	    if (cnt == 4) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 4;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN ( self );
	    }
	    __INST(position) = nil; /* i.e. do not know */
	    error = __mkSmallInteger(__threadErrno);
	}
    }
badArg: ;
%}.
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ self
    ].

    aNumber isInteger ifTrue:[
	^ super nextPutInt32:aNumber MSB:msbFlag
    ].
    self argumentMustBeInteger
!

nextPutInt32LSB:anIntegerOrCharacter
    "do not remove.
     See #patchByteOrderOptimizedMethods"

    self nextPutInt32:anIntegerOrCharacter MSB:false
!

nextPutInt32MSB:anIntegerOrCharacter
    "do not remove.
     See #patchByteOrderOptimizedMethods"

    self nextPutInt32:anIntegerOrCharacter MSB:true
!

nextPutInt32NATIVE:anInteger
    "Write the argument, anInteger as a long (four bytes) in native byte order.
     This is the CPU-specific byte order (LSB on x86, MSB on sparc, VAX and possibly on ARM).
     Notice that integers in the range -16r80000000 to +16rFFFFFFFF can be written
     (i.e. both signed and unsigned int32 values can be written.
     Works in both binary and text modes.
     Notice: this message should not be sent explicitly by ANY program.
	     the following implementation replaces the code of either nextPutInt32MSB or LSB
	     dynamically (see #initialize on the class side)"

    |error|

%{
    int num;
    union {
	char bytes[4];
	int intVal;
    } u;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if (__isSmallInteger(anInteger)) {
	num = __intVal(anInteger);
    } else {
#if __POINTER_SIZE__ == 8
	// always more than 4-bytes
	goto badArg;
#else
	num = __longIntVal(anInteger);
	if (num == 0) {
	    num = __signedLongIntVal(anInteger);
	    if (num == 0) {
		/* bad arg or out-of-range integer
		 * (handled by the fallBack code)
		 */
		goto badArg;
	    }
	}
#endif
    }

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	 && (__INST(mode) != @symbol(readonly))
	) {
	    int _buffered = (__INST(buffered) == true);
	    FILEPOINTER f = __FILEVal(fp);
	    int cnt;

	    u.intVal = num;
	    if (_buffered) {
		__WRITING__(f)
	    }
	    __WRITEBYTES__(cnt, f, u.bytes, 4, _buffered, __INST(handleType));

	    if (cnt == 4) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + 4;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN ( self );
	    }
	    __INST(position) = nil; /* i.e. do not know */
	    error = __mkSmallInteger(__threadErrno);
	}
    }
badArg: ;
%}.
    self nextPutInt32:anInteger MSB:(UninterpretedBytes isBigEndian)
!

nextPutUtf16:aCharacter
    "append my UTF-16 MSB representation to the argument, aStream.
     UTF-16 can encode only characters with code points between 0 to 16r10FFFF."

    self nextPutUtf16Bytes:aCharacter MSB:true

    "
        (FileStream newTemporary
            nextPutUtf16:$B;
            nextPutUtf16:$;
            nextPutUtf16:(Character codePoint:16r10CCCC);
            reset;
            binary;
            contents)
    "
!

nextPutUtf16:aCharacter MSB:msbFlag
    "append my UTF-16 MSB representation to the argument, aStream.
     UTF-16 can encode only characters with code points between 0 to 16r10FFFF."

    self nextPutUtf16Bytes:aCharacter MSB:msbFlag
! !

!ExternalStream methodsFor:'positioning'!

position
    self subclassResponsibility
!

position:index0Based
    self subclassResponsibility
! !

!ExternalStream methodsFor:'printing & storing'!

printOn:aStream
    aStream
	nextPutAll:self className;
	nextPutAll:'(handle:('.
    handle printOn:aStream.
    aStream nextPutAll:'))'
! !

!ExternalStream methodsFor:'private'!

clearEOF
    hitEOF := false
!

closeFile
    "low level close - may be redefined in subclasses
     Don't send this message, send #close instead"

    |fp error|

    handle isNil ifTrue:[
        ^ self.
    ].
    fp := handle.
    "/ (didWrite==true and:[binary ~~ true and:[eolMode = #crlf]]) ifTrue: [ self breakPoint:#sr ].

%{
    int rslt;

    if (__INST(handleType) == @symbol(socketHandle)) {
        SOCKET sock = (SOCKET)(__FILEVal(fp));

        if (@global(FileOpenTrace) == true) {
            fprintf(stderr, "close socket [ExternalStream] %"_lx_"\n", (INT)sock);
        }

        // whether the close() will be successful or not - the handle is invalid now!
        __INST(handle) = nil;
        do {
#ifdef __win32__
            rslt = __STX_WSA_NOINT_CALL1("closesocket", closesocket, sock);
#else
            rslt = close(sock);
#endif
        } while((rslt < 0) && (__threadErrno == EINTR));
    } else if ((__INST(handleType) == nil)
               || (__INST(handleType) == @symbol(filePointer))
               || (__INST(handleType) == @symbol(socketFilePointer))
               || (__INST(handleType) == @symbol(pipeFilePointer)))
    {
        FILEPOINTER f = __FILEVal(fp);

        if (@global(FileOpenTrace) == true) {
            fprintf(stderr, "fclose [ExternalStream] %"_lx_"\n", (INT)f);
        }
        // whether the close() will be successful or not - the handle is invalid now!
        __INST(handle) = nil;

#ifdef __win32__
        if (__INST(mode) != @symbol(readonly) && __INST(buffered) != false) {
            // do a fflush() first, so that fclose() doesn't block
            // we suspect, that EINTR causes problems in fclose()
            do {
                __threadErrno = 0;
                rslt = __STX_C_CALL1("fflush", fflush, f);
            } while((rslt < 0) && (__threadErrno == EINTR));
        }
        do {
            __threadErrno = 0;
            rslt = __STX_C_NOINT_CALL1("fclose", fclose, f);
        } while((rslt < 0) && (__threadErrno == EINTR));
#else
        // cg: the pre Nov2014 code always did the fclose interruptable;
        // I am not sure, if fclose is actually prepared to do this;
        // at least when only reading, this should not block, and we
        // should be able to do it without being interruptable.
        // Must watch this - if it leads to blockings, change and think about it.
        if (__INST(mode) == @symbol(readonly)) {
            rslt = fclose(f);
        } else {
            __BEGIN_INTERRUPTABLE__
            rslt = fclose(f);
            __END_INTERRUPTABLE__
        }
#endif
    } else {
        error = @symbol(badHandleType);
        goto out;
    }

    if (rslt < 0) {
        error = __mkSmallInteger(__threadErrno);
        goto out;
    }
    RETURN (self);

out:;
%}.

    error notNil ifTrue:[
        error isInteger ifTrue:[
            lastErrorNumber := error.
            mode == #readonly ifTrue:[
                self ioError:error.
            ] ifFalse:[
                self writeError:error.
            ].
            ^ self.
        ].
        self primitiveFailed:error.
        ^ self.
    ].

    "/ fallback for rel5

    fp := handle.
    fp notNil ifTrue:[
        handle := nil.
        self closeFile:fp
    ]
!

closeFile:handle
    "for rel5 only"

    self primitiveFailed
!

connectTo:aFileDescriptor withMode:modeSymbol handleType:handleTypeSymbol
    "connect a fileDescriptor; openmode is the string defining the way to open.
     This can be used to connect an externally provided fileDescriptor (from
     primitive code) or a pipeFileDescriptor (as returned by makePipe) to
     a Stream object.
     The openMode ('r', 'w' etc.) must match the mode in which
     the fileDescriptor was originally opened (otherwise i/o errors will be reported later)."

    |error openmode|

    handle notNil ifTrue:[^ self errorAlreadyOpen].
    mode := modeSymbol.
    openmode := self fopenMode.
%{
    FILEPOINTER f = 0;
    OBJ fp;
    FILE *fdopen();
    int fd = -2;

    if (__isStringLike(openmode)) {
#ifdef __win32__
        __stxWrapApiEnterCritical();
#endif
        if (__isSmallInteger(aFileDescriptor)) {
            fd = __intVal(aFileDescriptor);
        }
#ifdef __win32__
        else if (__isExternalAddressLike(aFileDescriptor)) {
            fd = _open_osfhandle((long)__externalAddressVal(aFileDescriptor), O_BINARY);
            if (fd < 0) {
                if (__threadErrno == 0) {
                    // no more file descriptors
                    __threadErrno = EMFILE;
                }
                error = __mkSmallInteger(__threadErrno);
                __stxWrapApiLeaveCritical();
                goto out;
            }
        }
#endif
        f = (FILEPOINTER) fdopen(fd, (char *)__stringVal(openmode));
#ifdef __win32__
        __stxWrapApiLeaveCritical();
#endif
        if (f == NULL) {
            error =__mkSmallInteger(__threadErrno);
        } else {
            if (@global(FileOpenTrace) == true) {
                fprintf(stderr, "fdopen [ExternalStream] %"_ld_" (%"_lx_") -> %"_lx_"\n", (INT)fd, (INT)fd, (INT)f);
            }

            fp = __MKFILEPOINTER(f); __INST(handle) = fp; __STORE(self, fp);
        }
    }
out:;
%}.
    error notNil ifTrue:[
        "
         the open failed for some reason ...
        "
        OperatingSystem closeFd:aFileDescriptor.
        lastErrorNumber := error.
        position := nil.
        ^ self openError:error
    ].

    position := 0.
    buffered isNil ifTrue:[
        buffered := true.       "default is buffered"
    ].
    handleType := handleTypeSymbol.
    self registerForFinalization.
!

dupFd
    "duplicate my file descriptor"

    |fd dupFd|

    fd := self fileHandle.
    fd isNil ifTrue:[   
        ^ self errorNotOpen.
    ].
    dupFd := OperatingSystem dup:fd.
    self setFileHandle:dupFd mode:self fopenMode.
!

fopenMode
   "answer the mode for fopen.
    Only used internally"

   mode == #readonly ifTrue:[
	^ ReadMode
   ].
   mode == #writeonly ifTrue:[
	^ WriteMode
   ].
   mode == #readWrite ifTrue:[
	^ ReadWriteMode
   ].
   mode == #append ifTrue:[
	^ AppendMode
   ].
   ^ ReadWriteMode
!

open:aPath withMode:openModeString
    "low level open; opens the file/device and sets the handle instance
     variable. Careful: this does not care for any other state."

    |ok error|

    ok := false.
%{
    FILE *f;
    OBJ fp;

    if (__isStringLike(aPath) && __isStringLike(openModeString)) {
#ifdef __win32__
# if 1
       f = fopen((char *) __stringVal(aPath), (char *) __stringVal(openModeString));
# else
	__BEGIN_INTERRUPTABLE__
	do {
	    f = fopen((char *) __stringVal(aPath), (char *) __stringVal(openModeString));
	} while ((f == NULL) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__
# endif
#else /* UNIX */
	__BEGIN_INTERRUPTABLE__
	do {
	    f = fopen((char *) __stringVal(aPath), (char *) __stringVal(openModeString));
	} while ((f == NULL) && (__threadErrno == EINTR));
	__END_INTERRUPTABLE__
#endif /* UNIX */
	if (f == NULL) {
	    error = __mkSmallInteger(__threadErrno);
	} else {
	    if (@global(FileOpenTrace) == true) {
		fprintf(stderr, "fopen %s [ExternalStream] -> %"_lx_"\n", __stringVal(aPath), (INT)f);
	    }
	    fp = __MKFILEPOINTER(f); __INST(handle) = fp; __STORE(self, fp);
	    __INST(handleType) = @symbol(filePointer);
	    ok = true;
	}
    }
%}.
    ok ifTrue:[
	position := 0.
	self registerForFinalization.
	^ self.
    ].
    error notNil ifTrue:[
	"
	 the open failed for some reason ...
	"
	lastErrorNumber := error.
	self openError:error.
    ].
    self primitiveFailed.
!

reOpen
    "USERS WILL NEVER INVOKE THIS METHOD
     sent after snapin to reopen streams.
     cannot reopen here since I am abstract and have no device knowledge"

    self class name errorPrint. ' [warning]: automatic reOpen not supported - stream closed' errorPrintCR.
    handle := nil.
    self unregisterForFinalization.

    "Modified: 10.1.1997 / 17:50:44 / cg"
!

setAccessor:what to:something
    "set the filePointer/fileHandle to the given one;
     low level private & friend interface; may also be used to connect to some
     externally provided handle."

    handle := something.
    handleType := what.
!

setFileHandle:something
    "set the fileHandle to the given one;
     low level private & friend interface; may also be used to connect to some
     externally provided file handle."

    self setAccessor:#fileHandle to:something
!

setFileHandle:anIntegerOrExternalAddress mode:openMode
    "set the handle based upon a given fileHandle -
     notice: this one is based on the underlying OSs fileDescriptor -
     this is a fileDescriptor (Integer) on Unix and Windows, or an Handle (ExternalAddres) on Windows only.
     It may not be available on all platforms."

%{
    FILEPOINTER f;
    OBJ fp;
    FILE *fdopen();
    int fd;

    if (!__isStringLike(openMode))
	goto err;

#ifdef __win32__
    __stxWrapApiEnterCritical();
    if (__isExternalAddressLike(anIntegerOrExternalAddress) ) {
	HANDLE __fileHandle = (HANDLE)__externalAddressVal(anIntegerOrExternalAddress);
	fd = _open_osfhandle((long)__fileHandle, O_BINARY);      /* should we handle readonly, append or text mode? */
	if (fd < 0) {
	    __stxWrapApiLeaveCritical();
	    CloseHandle(__fileHandle);
	    goto err;
	}
    } else
#endif
    if (__isSmallInteger(anIntegerOrExternalAddress)) {
	fd = __smallIntegerVal(anIntegerOrExternalAddress);
    } else {
#ifdef __win32__
	__stxWrapApiLeaveCritical();
#endif
	goto err;
    }
    f = fdopen(fd, __stringVal(openMode));
#ifdef __win32__
    __stxWrapApiLeaveCritical();
#endif
    if (f != NULL) {
	if (@global(FileOpenTrace) == true) {
	    fprintf(stderr, "fdopen [ExternalStream] %d -> %"_lx_"\n", fd, (INT)f);
	}
	fp = __MKFILEPOINTER(f); __INST(handle) = fp; __STORE(self, fp);
	__INST(handleType) = @symbol(filePointer);
	RETURN (self);
    }
err:;
%}.
    ^ self primitiveFailed
!

setFilePointer:something
    "set the filePointer to the given one;
     low level private & friend interface; may also be used to connect to some
     externally provided file."

    self setAccessor:#filePointer to:something
!

setLastError:aNumber
    lastErrorNumber := aNumber
!

setSocketHandle:something
    "set the socketHandle to the given one;
     low level private & friend interface; may also be used to connect to some
     externally provided socket handle."

    self setAccessor:#socketHandle to:something
! !

!ExternalStream methodsFor:'queries'!

nextError
    "return the error by trying to read something.
     Should only be used, when we know, that a read operation
     will return an error (otherwise a character may be lost).
     Return an integer (error number), 0 (EOF) or nil (no error)"

%{ /*NOCONTEXT*/
    FILEPOINTER f;
    int ret, _buffered;
    OBJ fp;
    unsigned char ch;

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(writeonly))
	) {
	    f = __FILEVal(fp);

	    _buffered = (__INST(buffered) == true);
	    if (_buffered) {
		__READING__(f)
	    }
	    __READBYTE__(ret, f, &ch, _buffered, __INST(handleType));

	    if (ret > 0) {
		RETURN(nil)
	    }
	    if (ret < 0) {
		RETURN(__mkSmallInteger(__threadErrno));
	    } else /* ret == 0 */ {
		RETURN(__mkSmallInteger(0)); /* EOF */
	    }
	}
    }
%}.
!

numAvailable
    <resource: #obsolete>
    ^ self numAvailableForRead
! !

!ExternalStream methodsFor:'reading'!

next
    "return the next element; advance read position.
     In binary mode, an integer is returned, otherwise a character.
     If there are no more elements, either an exception is thrown or nil is returned
     - see #pastEndRead."

    |c error|
%{
#ifdef __SCHTEAM__
    STObject handle = self.instVarAt(I_handle);

    if (handle != STObject.Nil) {
        STObject next;

        if (self.instVarAt(I_binary) == STObject.True) {
            next = handle.nextByte();
        } else {
            next = handle.nextChar();
        }
        if (next != STObject.EOF) {
            self.instVarAt_put(I_position, STObject.Nil);
            return __c__._RETURN( next );
        }
        self.instVarAt_put(I_hitEOF, STObject.True);
    }
#else
    FILEPOINTER f;
    int ret, _buffered;
    OBJ pos, fp;
    unsigned char ch;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
        ) {
            f = __FILEVal(fp);

            _buffered = (__INST(buffered) == true);
            if (_buffered) {
                __READING__(f)
            }
            __READBYTE__(ret, f, &ch, _buffered, __INST(handleType));

            if (ret > 0) {
                pos = __INST(position);
                if (__isSmallInteger(pos)) {
                    OBJ t;

                    t = __MKINT(__intVal(pos) + 1); __INST(position) = t; __STORE(self, t);
                } else {
                    __INST(position) = nil; /* i.e. do not know */
                }
                if (__INST(binary) == true) {
                    RETURN ( __mkSmallInteger(ch) );
                }
                RETURN ( __MKCHARACTER(ch) );
            }

            __INST(position) = nil;
            if (ret < 0) {
                error = __mkSmallInteger(__threadErrno);
            } else /* ret == 0 */ {
                __INST(hitEOF) = true;
            }
        }
    }
#endif /* not SCHTEAM */
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].

    readAhead notNil ifTrue:[
        c := readAhead.
        readAhead := nil.
        ^ c.
    ].

    "unknown handleType - future"
    c := self nextByteFromFile:handle.
    c isNil ifTrue:[
        ^ self pastEndRead.
    ].
    binary ifTrue:[
        ^ c
    ].
    ^ Character value:c
!

next:count
    "return the next count elements of the stream as a collection.
     Redefined to return a String or ByteArray instead of the default: Array."

    |coll nRead|

    coll := self contentsSpecies uninitializedNew:count.
    nRead := self nextBytes:count into:coll startingAt:1.

    nRead ~~ count ifTrue:[
        "/ for readStream protocol compatibility,
        "/ we must raise an exception here.
        ^ self pastEndRead
    ].
    ^ coll

    "Modified: 11.1.1997 / 17:44:17 / cg"
!

nextOrNil
    "return the next element; advance read position.
     In binary mode, an integer is returned, otherwise a character.
     If there are no more elements, nil is returned.
     This is #atEnd and #next in a single operation - to speed up some code"

    |c error|
%{
    FILEPOINTER f;
    int ret, _buffered;
    OBJ pos, fp;
    unsigned char ch;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
        ) {
            f = __FILEVal(fp);

            _buffered = (__INST(buffered) == true);
            if (_buffered) {
                __READING__(f)
            }
            __READBYTE__(ret, f, &ch, _buffered, __INST(handleType));

            if (ret > 0) {
                pos = __INST(position);
                if (__isSmallInteger(pos)) {
                    OBJ t;

                    t = __MKINT(__intVal(pos) + 1); __INST(position) = t; __STORE(self, t);
                } else {
                    __INST(position) = nil; /* i.e. do not know */
                }
                if (__INST(binary) == true) {
                    RETURN ( __mkSmallInteger(ch) );
                }
                RETURN ( __MKCHARACTER(ch) );
            }

            __INST(position) = nil;
            if (ret < 0) {
                error = __mkSmallInteger(__threadErrno);
            } else /* ret == 0 */ {
                __INST(hitEOF) = true;
            }
        }
    }
%}.
    hitEOF ifTrue:[^ nil].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].

    readAhead notNil ifTrue:[
        c := readAhead.
        readAhead := nil.
        ^ c.
    ].

    "unknown handleType - future"
    c := self nextByteFromFile:handle.
    c isNil ifTrue:[
        ^ nil.
    ].
    binary == true ifTrue:[
        ^ c
    ].
    ^ Character value:c
!

peek
    "return the element to be read next without advancing read position.
     In binary mode, an integer is returned, otherwise a character.
     If there are no more elements, either an exception is thrown or nil is returned
     - see #pastEndRead."

    |error|
%{
    FILEPOINTER f;
    unsigned char c;
    int ret, _buffered;
    OBJ fp;
    OBJ ra;

    if ((ra = __INST(readAhead)) != nil) {
        if (__INST(binary) == true) {
            RETURN ( ra );
        }
        c = __intVal(ra);
        RETURN ( __MKCHARACTER(c) );
    }

    __INST(lastErrorNumber) = nil;

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
        ) {
            f = __FILEVal(fp);
            _buffered = (__INST(buffered) == true);
            if (_buffered) {
                __READING__(f)
            }
            __READBYTE__(ret, f, &c, _buffered, __INST(handleType));

            if (ret > 0) {
                __UNGETC__(c, f, _buffered);

                if (__INST(binary) == true) {
                    RETURN ( __mkSmallInteger(c) );
                }
                RETURN ( __MKCHARACTER(c) );
            }
            if (ret < 0) {
                error = __mkSmallInteger(__threadErrno);
            } else /* ret == 0 */ {
                __INST(hitEOF) = true;
            }
        }
    }
%}.
    hitEOF ifTrue:[^ self pastEndRead].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].

    readAhead isNil ifTrue:[
        readAhead := self nextOrNil.
        readAhead isNil ifTrue:[
            ^ self pastEndRead.
        ].
    ].
    ^ readAhead
!

peekOrNil
    "return the element to be read next without advancing read position.
     In binary mode, an integer is returned, otherwise a character.
     If there are no more elements, nil is returned.
     Same as #atEnd and #peek in a single operation - speeding up some code"

    |error|
%{
    FILEPOINTER f;
    unsigned char c;
    int ret, _buffered;
    OBJ fp;
    OBJ ra;

    if ((ra = __INST(readAhead)) != nil) {
        if (__INST(binary) == true) {
            RETURN ( ra );
        }
        c = __intVal(ra);
        RETURN ( __MKCHARACTER(c) );
    }

    __INST(lastErrorNumber) = nil;

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if (((fp = __INST(handle)) != nil)
            && (__INST(mode) != @symbol(writeonly))
        ) {
            f = __FILEVal(fp);
            _buffered = (__INST(buffered) == true);
            if (_buffered) {
                __READING__(f)
            }
            __READBYTE__(ret, f, &c, _buffered, __INST(handleType));

            if (ret > 0) {
                __UNGETC__(c, f, _buffered);

                if (__INST(binary) == true) {
                    RETURN ( __mkSmallInteger(c) );
                }
                RETURN ( __MKCHARACTER(c) );
            }
            if (ret < 0) {
                error = __mkSmallInteger(__threadErrno);
            } else /* ret == 0 */ {
                __INST(hitEOF) = true;
            }
        }
    }
%}.
    hitEOF ifTrue:[^ nil].
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self readError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].

    readAhead isNil ifTrue:[
        readAhead := self nextOrNil.
    ].
    ^ readAhead
!

upToEnd
    "return a collection of the elements up-to the end.
     Return an empty collection, if the stream-end is already at the end."

    |chunkSize chunks sizes byteCount data offset|

    "adding to a ByteArray produces quadratic time-space
     behavior - therefore we allocate chunks, and concatenate them
     at the end."

    chunkSize := 4096.
    byteCount := 0.
    [self atEnd] whileFalse:[
        |chunk cnt|

        chunk := self contentsSpecies uninitializedNew:chunkSize.
        cnt := self nextBytes:chunkSize into:chunk startingAt:1.
        cnt ~~ 0 ifTrue:[
            chunks isNil ifTrue:[
                (cnt < chunkSize and:[self atEnd]) ifTrue:[
                    "all data is in a single chunk, so we are done"
                    ^ chunk copyFrom:1 to:cnt.
                ].
                chunks := OrderedCollection new.
                sizes := OrderedCollection new.
            ].
            chunks add:chunk.
            sizes add:cnt.
            byteCount := byteCount + cnt
        ]
    ].

    "now, create one big array"
    data := self contentsSpecies uninitializedNew:byteCount.
    offset := 1.
    1 to:chunks size do:[:index |
        |chunk cnt|

        chunk := chunks at:index.
        cnt := sizes at:index.
        data replaceFrom:offset to:(offset + cnt - 1) with:chunk startingAt:1.
        offset := offset + cnt
    ].
    ^ data


    "
     '/dev/null' asFilename readStream upToEnd
     '/proc/self/stat' asFilename readStream upToEnd

     self assert:('smalltalk.rc' asFilename readStream upToEnd size)
                  =  ('smalltalk.rc' asFilename readStream size)
    "
! !

!ExternalStream methodsFor:'rel5 protocol'!

atEndFile:handle
    "for migration to rel5 only"

    self primitiveFailed
!

nextByteFromFile:handle
    "for migration to rel5 only"

    self primitiveFailed
!

nextPutByte:aByte toFile:handle
    "for migration to rel5 only"

    self primitiveFailed
! !

!ExternalStream methodsFor:'testing'!

atEnd
    "return true, if position is at end.
     If a stream is at the end, the next read operation
     would return or raise an exception immediately without waiting.
     If a stream is not at the end, this may be a blocking operation
     (see NonPositionableExternalStream)"

%{
    OBJ fp, lim;
    char c;

    if (__INST(hitEOF) == true) {
        RETURN (true);
    }
    lim = __INST(readLimit);
    if (lim != nil && __signedLongIntVal(__INST(position)) >= __signedLongIntVal(lim)) {
        RETURN (true);
    }

    __INST(lastErrorNumber) = nil;

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        if ((fp = __INST(handle)) != nil) {
            int _buffered = (__INST(buffered) == true);
            int ret;
            FILEPOINTER f = __FILEVal(fp);

            if (_buffered) {
                __READING__(f);
            } else if (__INST(readAhead) != nil) {
                RETURN (false);
            }

            /*
             * read ahead ...
             */
            do {
#ifdef __win32__
                __READBYTE__(ret, f, &c, _buffered, __INST(handleType));
#else /* not __win32__ */
                __BEGIN_INTERRUPTABLE__
                __READBYTE__(ret, f, &c, _buffered, __INST(handleType));
                __END_INTERRUPTABLE__
#endif /* not __win32__ */
            } while ((ret < 0) && (__threadErrno == EINTR));
            if (ret > 0) {
                __UNGETC__(c&0xff, f, _buffered);
                RETURN (false);
            }
            if (ret == 0) {
                __INST(hitEOF) = true;
                RETURN (true);
            }
            /* ret < 0 -> error */
            __INST(lastErrorNumber) = __mkSmallInteger(__threadErrno);
        }
        // we do not raise an error here - the next read operation will raise the error.
        RETURN(false);
    }
%}.

    "/ we come here if the handle type is unknown 
    "/ migration support
    ^ self atEndFile:handle

    "Modified: / 30.10.1998 / 20:16:06 / cg"
!

canReadWithoutBlocking
    "return true, if any data is available for reading (i.e.
     a read operation will not block the smalltalk process), false otherwise.
     We know, that error conditions do not block, so return true for errors."

    ^ readAhead notNil
        or:[handle isNil
        or:[mode == #writeonly
        or:[OperatingSystem readCheck:self fileHandle]]]

    "
     |pipe|

     pipe := PipeStream readingFrom:'(sleep 10; echo hello)'.
     pipe canReadWithoutBlocking ifTrue:[
         Transcript showCR:'data available'
     ] ifFalse:[
         Transcript showCR:'no data available'
     ].
     pipe close
    "

    "Modified: 25.9.1997 / 13:08:45 / stefan"
!

canWriteWithoutBlocking
    "return true, if data can be written into the stream
     (i.e. a write operation will not block the smalltalk process).
     We know, that error conditions do not block, so return true for errors."

    ^ handle isNil
        or:[mode == #readonly
        or:[OperatingSystem writeCheck:self fileHandle]]
!

gotErrorOrEOF
    "answer true, if amn error or eof has been occurred on the stream"

    ^ hitEOF or:[lastErrorNumber notNil]
!

isBinary
    "return true, if the stream is in binary (as opposed to text-) mode.
     The default when created is false."

    ^ binary
!

isBlocking
    "return true, if O_NONBLOCK is NOT set in the fileDescriptor (probably UNIX specific)"

    handle isNil ifTrue:[^ self errorNotOpen].
    ^ OperatingSystem isBlockingOn:self fileDescriptor
!

isExternalStream
    "return true, if the receiver is some kind of externalStream;
     true is returned here - the method redefined from Object."

    ^ true
!

isOpen
    "return true, if this stream is open"

    ^ handle notNil
!

isReadable
    "return true, if this stream can be read from"

    ^ mode ~~ #writeonly
!

isWritable
    "return true, if this stream can be written to"

    ^ mode ~~ #readonly
! !

!ExternalStream methodsFor:'waiting for I/O'!

canBeSelected
    "return true, if this stream can be selected upon"

    ^ OperatingSystem supportsSelect
!

numAvailableForRead
    "answer the number of bytes available for reading"

    |available|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].
    mode == #writeonly ifTrue:[
        ^ self errorWriteOnly
    ].
    available := OperatingSystem numAvailableForReadOn:self fileHandle.
    readAhead notNil ifTrue:[
        available := available + 1
    ].
    ^ available.

    "
        '/etc/hosts' asFilename readStream numAvailableForRead
    "
!

readWaitWithTimeoutMs:timeoutOrNil
    "suspend the current process, until the receiver
     becomes ready for reading or a timeout (in milliseconds) expired.
     If data is already available, return immediate.
     Return true if a timeout occurred (i.e. false, if data is available).
     The other threads are not affected by the wait."

    |fd inputSema hasTimedout wasBlocked|

    readAhead notNil ifTrue:[^ false].

    handle isNil ifTrue:[^ self errorNotOpen].
    mode == #writeonly ifTrue:[^ self errorWriteOnly].

    fd := self fileHandle.
    (OperatingSystem readCheck:fd) ifTrue:[^ false].

    "cannot do a readWait (which means possible suspend),
     if the processor is not yet initialized; i.e. if a read is attempted
     during early startup.
     This may happen, for example, if a MiniDebugger is entered, before
     process scheduling has been setup.
     In this case, all I/O operations here will be blocking."

    Smalltalk isInitialized ifFalse:[ ^ false ].

    wasBlocked := OperatingSystem blockInterrupts.
    inputSema := Semaphore new name:'readWait'.
    [
        timeoutOrNil notNil ifTrue:[
            Processor signal:inputSema afterMilliseconds:timeoutOrNil.
        ].
        Processor signal:inputSema onInput:fd.
        Processor activeProcess state:#ioWait.
        inputSema wait.
        hasTimedout := timeoutOrNil notNil and:[(OperatingSystem readCheck:fd) not].
    ] ifCurtailed:[
        Processor disableSemaphore:inputSema.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeoutOrNil notNil ifTrue:[
        Processor disableSemaphore:inputSema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ hasTimedout
!

readWriteWaitWithTimeoutMs:timeout
    "suspend the current process, until the receiver
     becomes ready for reading or writing or a timeout (in milliseconds) expired.
     Return true if a timeout occurred (i.e. false, if data is available).
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    |fd sema hasTimedout wasBlocked|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].

    fd := self fileHandle.
    (OperatingSystem readWriteCheck:fd) ifTrue:[^ false].

    wasBlocked := OperatingSystem blockInterrupts.
    sema := Semaphore new name:'readWriteWait'.
    [
        timeout notNil ifTrue:[
            Processor signal:sema afterMilliseconds:timeout
        ].
        Processor signal:sema onOutput:fd.
        Processor signal:sema onInput:fd.
        Processor activeProcess state:#ioWait.
        sema wait.
        hasTimedout := timeout notNil and:[(OperatingSystem readWriteCheck:fd) not].
    ] ifCurtailed:[
        Processor disableSemaphore:sema.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeout notNil ifTrue:[
        Processor disableSemaphore:sema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ hasTimedout
!

writeExceptionWaitWithTimeoutMs:timeout
    "suspend the current process, until the receiver
     becomes ready for reading or writing or a timeout (in milliseconds) expired.
     Return true if a timeout occurred (i.e. false, if data is available).
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    |fd sema hasTimedout wasBlocked|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].

    fd := self fileHandle.
    (OperatingSystem writeExceptionCheck:fd) ifTrue:[^ false].

    wasBlocked := OperatingSystem blockInterrupts.
    sema := Semaphore new name:'writeExceptionWait'.
    [
        timeout notNil ifTrue:[
            Processor signal:sema afterMilliseconds:timeout
        ].
        Processor signal:sema onOutput:fd.
        Processor signal:sema onException:fd.
        Processor activeProcess state:#ioWait.
        sema wait.
        hasTimedout := timeout notNil and:[(OperatingSystem readWriteCheck:fd) not].
    ] ifCurtailed:[
        Processor disableSemaphore:sema.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeout notNil ifTrue:[
        Processor disableSemaphore:sema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ hasTimedout
!

writeWaitWithTimeoutMs:timeout
    "suspend the current process, until the receiver
     becomes ready for writing or a timeout (in milliseconds) expired.
     Return true if a timeout occurred (i.e. false, if data is available).
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    |fd outputSema hasTimedout wasBlocked|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].
    mode == #readonly ifTrue:[
        ^ self errorReadOnly
    ].

    fd := self fileHandle.
    (OperatingSystem writeCheck:fd) ifTrue:[^ false].

    wasBlocked := OperatingSystem blockInterrupts.
    outputSema := Semaphore new name:'writeWait'.
    [
        timeout notNil ifTrue:[
            Processor signal:outputSema afterMilliseconds:timeout
        ].
        Processor signal:outputSema onOutput:fd.
        Processor activeProcess state:#ioWait.
        outputSema wait.
        hasTimedout := timeout notNil and:[(OperatingSystem writeCheck:fd) not].
    ] ifCurtailed:[
        Processor disableSemaphore:outputSema.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    timeout notNil ifTrue:[
        Processor disableSemaphore:outputSema.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ hasTimedout
! !

!ExternalStream methodsFor:'writing'!

cr
    "append an end-of-line character (or CRLF if in crlf mode).
     reimplemented for speed"

%{
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        OBJ fp;

        __INST(lastErrorNumber) = nil;
        if (((fp = __INST(handle)) != nil)
         && (__INST(mode) != @symbol(readonly))
         && (__INST(binary) != true)
        ) {
            FILEPOINTER f = __FILEVal(fp);
            int _buffered = (__INST(buffered) == true);
            int len, cnt;
            char *cp;

            if (_buffered) {
                __WRITING__(f)
            }
            {
                OBJ mode = __INST(eolMode);

                if (mode == @symbol(cr)) {
                    cp = "\r"; len = 1;
                } else if (mode == @symbol(crlf)) {
                    cp = "\r\n"; len = 2;
                } else if (mode == @symbol(eot)) {
                    cp = "\004"; len = 1;
                } else if (mode == @symbol(etx)) {
                    cp = "\003"; len = 1;
                } else {
                    cp = "\n"; len = 1;
                }
            }
#if defined(WIN32) && !defined(__MINGW__)
            if ((f == __win32_stdout()) || (f == __win32_stderr())) {
                cnt = __win32_fwrite(cp, 1, len, f);
            } else
#endif
            {
                __WRITEBYTES__(cnt, f, cp, len, _buffered, __INST(handleType));
            }
            if (cnt == len) {
                if (__isSmallInteger(__INST(position))) {
                    INT np = __intVal(__INST(position)) + len;
                    OBJ t;

                    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
                } else {
                    __INST(position) = nil; /* i.e: don't know */
                }
                RETURN ( self );
            }
            __INST(lastErrorNumber) = __mkSmallInteger(__threadErrno);
        }
    }
%}.
    lastErrorNumber notNil ifTrue:[self writeError. ^ self].
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    binary ifTrue:[self errorBinary. ^ self].

    (eolMode == #cr) ifTrue:[
        self nextPut:(Character return).
        ^ self
    ].
    (eolMode == #crlf) ifTrue:[
        self nextPut:(Character return).
    ].
    self nextPut:(Character nl).
    ^ self
!

flush
    "write all buffered data - ignored if unbuffered"

%{
    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	OBJ fp;
	int _buffered = (__INST(buffered) == true);

	if ((fp = __INST(handle)) != nil) {
	    if (__INST(mode) != @symbol(readonly)) {
		if (_buffered) {
		    FILEPOINTER f = __FILEVal(fp);
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			__win32_fflush(f);
		    } else {
			int rslt;

			do {
			    __threadErrno = 0;
			    rslt = __STX_C_CALL1("fflush", fflush, f);
			} while((rslt < 0) && (__threadErrno == EINTR));
		    }
#else /* ! __win32__ */
		    __BEGIN_INTERRUPTABLE__
		    FFLUSH(f);
		    __END_INTERRUPTABLE__
#endif /* ! __win32__ */
		}
	    }
	}
    }
%}
!

nextPut:aCharacter
    "write the argument, aCharacter - return nil if failed, self if ok.
     Only single-byte characters are currently supported"

    |error|
%{
#ifdef __SCHTEAM__
    STObject handle = self.instVarAt(I_handle);

    if ((handle != STObject.Nil)
     && (aCharacter.isSTCharacter())) {
        handle.writeChar( aCharacter );
        self.instVarAt_put(I_position, STObject.Nil);
        return __c__._RETURN_self();
    }
#else
    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
        OBJ fp;

        if (((fp = __INST(handle)) != nil)
         && (__INST(mode) != @symbol(readonly))
        ) {
            FILEPOINTER f = __FILEVal(fp);
            int _buffered = (__INST(buffered) == true);
            int cnt;
            char buff[2];
            int nBytes = 1;

            if (__INST(binary) != true) {
                if (__isCharacter(aCharacter)) {
                    unsigned int codePoint = __intVal(__characterVal(aCharacter));
                    if (codePoint <= 0xFF) {
                        unsigned char c = codePoint;
                        buff[0] = c; nBytes = 1;

                        if (c == '\n') {
                            OBJ mode = __INST(eolMode);
                            if (mode == @symbol(nl)) {
                                // no EOL translation
                            } else if (mode == nil) {
                                // no EOL translation
                            } else if (mode == @symbol(cr)) {
                                buff[0] = '\r';
                            } else if (mode == @symbol(eot)) {
                                buff[0] = '\004';
                            } else if (mode == @symbol(etx)) {
                                buff[0] = '\003';
                            } else if (mode == @symbol(crlf)) {
                                buff[0] = '\r';
                                buff[1] = '\n';
                                nBytes = 2;
                            }
                        }
    doWrite:
                        if (! f) {
                            fprintf(stderr, "oops - fileHandle is NULL in nextPut:\n");
                            __INST(handle) = nil;
                            goto out;
                        }

                        if (_buffered) {
                            __WRITING__(f)
                        }
#if defined(WIN32) && !defined(__MINGW__)
                        if ((f == __win32_stdout()) || (f == __win32_stderr())) {
                            cnt = __win32_fwrite(buff, 1, nBytes, f);
                        } else
# endif
                        {
                            __WRITEBYTES__(cnt, f, buff, nBytes, _buffered, __INST(handleType));
                        }
                        if (cnt == nBytes) {
                            if (__isSmallInteger(__INST(position))) {
                                INT np = __intVal(__INST(position)) + nBytes;
                                OBJ t;

                                t = __MKINT(np); __INST(position) = t; __STORE(self, t);
                            } else {
                                __INST(position) = nil; /* i.e. do not know */
                            }
                            RETURN ( self );
                        }
                        error = __mkSmallInteger(__threadErrno);
                    }
                }
            } else {
                if (__isSmallInteger(aCharacter)) {
                    unsigned char c = __intVal(aCharacter);
                    buff[0] = c; nBytes = 1;
                    goto doWrite;
                }
            }
        }
    }
out: ;
#endif /* not SCHTEAM */
%}.
    error notNil ifTrue:[
        lastErrorNumber := error.
        self writeError:error.
        ^ self
    ].
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    binary == true ifTrue:[
        aCharacter isInteger ifFalse:[
            self argumentMustBeInteger.
            ^ self.
        ].
    ] ifFalse:[
        (aCharacter isCharacter not
         or:[aCharacter codePoint > 16rFF]) ifTrue:[
            self argumentMustBeCharacter.
            ^ self.
        ].
    ].
    "/ migration support
    self
        nextPutByte:aCharacter asInteger
        toFile:handle
!

nextPutAll:aCollection
    "write all elements of the argument, aCollection.
     Reimplemented for speed when writing strings or byteArrays.
     For others, falls back to general method in superclass."

    |error|
%{
#ifdef __SCHTEAM__
    STObject handle = self.instVarAt(I_handle);

    if ((handle != STObject.Nil)
     && (aCollection.isSTString())) {
	handle.writeCharacters( aCollection.asSTString().characters );
	self.instVarAt_put(I_position, STObject.Nil);
	return __c__._RETURN_self();
    }
#else

    __INST(lastErrorNumber) = nil;

    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	OBJ fp;

	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(readonly))
	) {
	    INT len, cnt;
	    INT o_offs;
	    FILEPOINTER f = __FILEVal(fp);
	    int _buffered = (__INST(buffered) == true);

	    if (! f) {
		fprintf(stderr, "oops - fileHandle is NULL in nextPutAll:\n");
		__INST(handle) = nil;
		goto out;
	    }
	    if (_buffered) {
		__WRITING__(f)
	    }

	    if (__isStringLike(aCollection)) {
		OBJ mode = __INST(eolMode);
		char *stringP = __stringVal(aCollection);
		len = __stringSize(aCollection);

		if (__INST(binary) != true
		    && ((mode == @symbol(cr))
			|| (mode == @symbol(etx))
			|| (mode == @symbol(eot))
			|| (mode == @symbol(crlf)))
		    && memchr(stringP, '\n', len) != NULL)
		{
		    // there is a '\n' to be translated, replace it into a buffer

		    char *end;
		    char sep[2];
		    int sepLen = 1;
		    int bufLen;
		    char *buf, *endBuf, *sp, *dp;

		    sep[0] = '\n';
		    if (mode == @symbol(crlf)) {
			 sep[0] = '\r'; sep[1] = '\n'; sepLen = 2;
		    } else if (mode == @symbol(cr)) {
			 sep[0] = '\r';
		    } else if (mode == @symbol(eot)) {
			 sep[0] = '\004';
		    } else if (mode == @symbol(etx)) {
			 sep[0] = '\003';
		    }

		    // estimate size of buffer - assume every 4th char is a separator
		    bufLen = (sepLen == 1) ? len : (len + ((len/4) + 1) * sepLen);
		    buf = (char *)malloc(bufLen);
		    if (buf == NULL) {
			error = __mkSmallInteger(ENOMEM);
			goto out;
		    }

		    endBuf = buf + bufLen;
		    end = stringP + len;
		    for (sp = stringP, dp = buf; sp < end; sp++) {
			char c;

			if ((dp+sepLen) >= endBuf) {
			    char *newBuf;

			    bufLen = bufLen * 2;
			    newBuf = (char *)realloc(buf, bufLen);
			    if (newBuf == NULL) {
				free(buf);
				error = __mkSmallInteger(ENOMEM);
				goto out;
			    }
			    endBuf = newBuf + bufLen;
			    dp = newBuf + (dp-buf);
			    buf = newBuf;
			}

			if ((c = *sp) != '\n') {
			    *dp++ = c;
			} else {
			    *dp++ = sep[0];
			    if (sepLen == 2) {
				*dp++ = sep[1];
			    };
			}
		    }

		    len = dp - buf;
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(buf, 1, len, f);
		    } else
# endif
		    {
			__WRITEBYTES__(cnt, f, buf, len, _buffered, __INST(handleType));
		    }
		    free(buf);
		} else  {  // No EOL conversion needed
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(stringP, 1, len, f);
		    } else
# endif
		    {
			o_offs = stringP - (char *)__InstPtr(aCollection);
			__WRITEBYTES_OBJ__(cnt, f, aCollection, o_offs, len, _buffered, __INST(handleType));
		    }
		}
	    } else {   // Not a String
		if (__INST(binary) == true) {
		    INT offs;

		    if (__isByteArrayLike(aCollection)) {
			offs = 0;
			len = __byteArraySize(aCollection);
		    } else if (__isBytes(aCollection)) {
			offs = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aCollection))->c_ninstvars));
			len = __byteArraySize(aCollection) - offs;
		    } else
			goto out;
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(__stringVal(aCollection), 1, len, f);
		    } else
# endif
		    {
			o_offs = (char *)(__ByteArrayInstPtr(aCollection)->ba_element) - (char *)__InstPtr(aCollection);
			o_offs += offs;
			__WRITEBYTES_OBJ__(cnt, f, aCollection, o_offs, len, _buffered, __INST(handleType));
		    }
		} else  // Not binary mode
		    goto out;
	    }

	    // Now check for errors
	    if (cnt == len) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + len;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN (self);
	    }
	    fprintf(stderr, "cnt=%"_ld_" len=%"_ld_"\n", (INT)cnt, (INT)len);
	    error = __mkSmallInteger(__threadErrno);
	}
    }
out: ;
#endif /* not SCHTEAM */
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ self
    ].
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].

    ^ super nextPutAll:aCollection
!

nextPutAll:initialWriteCount from:buffer startingAt:initialOffset
    "redefined, to wait until stream is writable, to avoid blocking in a write.
     I don't know how to write non-bytes to an external stream, but let superclass handle this."

    buffer isByteCollection ifTrue:[
        ^ self nextPutBytes:initialWriteCount from:buffer startingAt:initialOffset.
    ].

    ^ super nextPutAll:initialWriteCount from:buffer startingAt:initialOffset
!

nextPutAll:aCollection startingAt:start to:stop
    "write a range of elements of the argument, aCollection.
     Reimplemented for speed when writing strings or byteArrays.
     For others, falls back to general method in superclass."

     |error|

%{
    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	OBJ fp = __INST(handle);

	if ((fp != nil)
	 && (__INST(mode) != @symbol(readonly))
	 && __bothSmallInteger(start, stop)
	) {
	    int _buffered = (__INST(buffered) == true);
	    FILEPOINTER f = __FILEVal(fp);
	    int offs, len, cnt;
	    int iStart = __intVal(start);
	    int iStop = __intVal(stop);
	    int o_offs;

	    if (_buffered ) {
		__WRITING__(f)
	    }

	    if ((iStart < 1) || (iStop < iStart)) {
		RETURN(self);
	    }
	    if (__isStringLike(aCollection)) {
		char *stringP;
		OBJ mode = __INST(eolMode);

		len = __stringSize(aCollection);
		if (iStop > len) {
		    RETURN(self);
		}
		if (iStop > len)
		    iStop = len;
		len = iStop - iStart + 1;
		stringP = __stringVal(aCollection) + iStart - 1;

		if (__INST(binary) != true
		    && ((mode == @symbol(cr))
			|| (mode == @symbol(etx))
			|| (mode == @symbol(eot))
			|| (mode == @symbol(crlf)))
		    && memchr(stringP, '\n', len) != NULL)
		{
		    // see if there is a \n which needs to be translated, replace it

		    char *end = stringP + len;
		    char sep[2];
		    int sepLen = 1;
		    int bufLen;
		    char *buf, *endBuf, *sp, *dp;

		    sep[0] = '\n';
		    if (mode == @symbol(crlf)) {
			 sep[0] = '\r'; sep[1] = '\n'; sepLen = 2;
		    } else if (mode == @symbol(cr)) {
			 sep[0] = '\r';
		    } else if (mode == @symbol(eot)) {
			 sep[0] = '\004';
		    } else if (mode == @symbol(etx)) {
			 sep[0] = '\003';
		    }

		    // estimate size of buffer - assume every 4th char is a separator
		    bufLen = (sepLen == 1) ? len : (len + ((len/4) + 1) * sepLen);
		    buf = (char *)malloc(bufLen);
		    if (buf == NULL) {
			error = __mkSmallInteger(ENOMEM);
			goto out;
		    }

		    endBuf = buf + bufLen;

		    for (sp = stringP, dp = buf; sp < end; sp++) {
			char c;

			if ((dp+sepLen) >= endBuf) {
			    char *newBuf;

			    bufLen = bufLen * 2;
			    newBuf = (char *)realloc(buf, bufLen);
			    if (newBuf == NULL) {
				free(buf);
				error = __mkSmallInteger(ENOMEM);
				goto out;
			    }
			    endBuf = newBuf + bufLen;
			    dp = newBuf + (dp-buf);
			    buf = newBuf;
			}

			if ((c = *sp) == '\n') {
			    *dp++ = sep[0];
			    if (sepLen == 2) {
				*dp++ = sep[1];
			    };
			} else {
			    *dp++ = c;
			}
		    }

		    len = dp - buf;
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(buf, 1, len, f);
		    } else
#endif
		    {
			__WRITEBYTES__(cnt, f, buf, len, _buffered, __INST(handleType));
		    }
		    free(buf);
		} else  {  // No EOL conversion needed
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(stringP, 1, len, f);
		    } else
#endif
		    {
			o_offs = (char *)__stringVal(aCollection)-(char *)__InstPtr(aCollection);
			__WRITEBYTES_OBJ__(cnt, f, aCollection, o_offs+iStart-1, len, _buffered, __INST(handleType));
		    }
		}
	    } else {  // Not a string
		if (__INST(binary) == true) {
		    int offs;

		    if (__isByteArrayLike(aCollection)) {
			offs = 0;
			len = __byteArraySize(aCollection);
		    } else if (__isBytes(aCollection)) {
			offs = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aCollection))->c_ninstvars));
			len = __byteArraySize(aCollection) - offs;
		    } else
			goto out;

		    if (iStop > len) {
			RETURN(self);
		    }
		    if (iStop > len)
			iStop = len;
		    len = iStop - iStart + 1;
		    offs += iStart - 1;
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(__stringVal(aCollection)+iStart-1, 1, len, f);
		    } else
#endif
		    {
			o_offs = (char *)(__ByteArrayInstPtr(aCollection)->ba_element)-(char *)__InstPtr(aCollection);
			__WRITEBYTES_OBJ__(cnt, f,  aCollection, o_offs+offs, len, _buffered, __INST(handleType));
		    }
		} else
		    goto out;
	    }
	    if (cnt == len) {
		if (__isSmallInteger(__INST(position))) {
		    INT np = __intVal(__INST(position)) + len;
		    OBJ t;

		    t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		} else {
		    __INST(position) = nil; /* i.e. do not know */
		}
		RETURN (self);
	    }
	    error = __mkSmallInteger(__threadErrno);
	}
    }
out: ;
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ self
    ].
    ^ super nextPutAll:aCollection startingAt:start to:stop
!

nextPutAllUnicode:aString
    "normal streams can not handle multi-byte characters, so convert them to utf8.
     This is needed, so that you can do ('something' asUnicode16String errorPrintCR)"

    aString do:[:eachCharacter|
	self nextPutUtf8:eachCharacter.
    ].

    "
	'Bnnigheim' asUnicode16String errorPrintCR
    "
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start.
     return the number of bytes written - which could be 0.
     The object must have non-pointer indexed instvars
     (i.e. be a ByteArray, String, Float- or DoubleArray),
     or an externalBytes object (with known size).

     Use with care - non object oriented i/o.
     Warning:
	in general, you cannot use this method to pass non-byte data to other
	architectures (unless you prepared the buffer with care),
	since it does not care for byte order or float representation."

    |error|

%{
#ifdef __SCHTEAM__
    byte[] bytes;
    STObject handle = self.instVarAt(I_handle);

    if (anObject.isSTString()) {
	char[] chars = anObject.asSTString().characters;
	handle.writeCharacters(chars, start.intValue()-1, count.intValue());
	self.instVarAt_put(I_position, STObject.Nil);
	return context._RETURN(count);
    }
    if (anObject.isSymbol()) {
	java.lang.String chars = anObject.asSTSymbol().characters;
	handle.writeString(chars, start.intValue()-1, count.intValue());
	self.instVarAt_put(I_position, STObject.Nil);
	return context._RETURN(count);
    }
#else
    int ret;
    int objSize, nInstBytes;
    char *extPtr;
    OBJ fp;

    __INST(lastErrorNumber) = nil;
    if ((__INST(handleType) == nil)
     || (__INST(handleType) == @symbol(filePointer))
     || (__INST(handleType) == @symbol(socketFilePointer))
     || (__INST(handleType) == @symbol(socketHandle))
     || (__INST(handleType) == @symbol(pipeFilePointer))) {
	if (((fp = __INST(handle)) != nil)
	    && (__INST(mode) != @symbol(readonly))
	    && __bothSmallInteger(count, start)
	) {
	    int _buffered = (__INST(buffered) == true);
	    FILEPOINTER f = __FILEVal(fp);
	    int len = __intVal(count);
	    int offs = __intVal(start) - 1;

	    if (__isExternalBytesLike(anObject)) {
		OBJ sz;

		nInstBytes = 0;
		extPtr = (char *)__externalBytesAddress(anObject);
		if (extPtr == NULL) goto bad;
		sz = __externalBytesSize(anObject);
		if (__isSmallInteger(sz)) {
		    objSize = __intVal(sz);
		} else {
		    objSize = 0; /* unknown */
		}
	    } else {
		OBJ oClass = __Class(anObject);
		int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

		nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
		switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
		    case BYTEARRAY:
		    case WORDARRAY:
		    case LONGARRAY:
		    case SWORDARRAY:
		    case SLONGARRAY:
		    case FLOATARRAY:
			break;
		    case DOUBLEARRAY:
# ifdef __NEED_DOUBLE_ALIGN
			nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
# endif
			break;
		    case LONGLONGARRAY:
		    case SLONGLONGARRAY:
# ifdef __NEED_LONGLONG_ALIGN
			nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
# endif
			break;
		    default:
			goto bad;
		}
		extPtr = (char *)0;
		objSize = __Size(anObject) - nInstBytes;
	    }
	    if ( (offs >= 0) && (len >= 0) && (objSize >= (len + offs)) ) {
		int cnt;

		if (_buffered) {
		    __WRITING__(f)
		}

		if (extPtr) {
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite(extPtr+offs, 1, len, f);
		    } else
# endif
		    {
			__WRITEBYTES__(cnt, f, extPtr+offs, len, _buffered, __INST(handleType));
		    }
		} else {
		    /*
		     * on interrupt, anObject may be moved to another location.
		     * So we pass anObject, and the offset to the __WRITEBYTES_OBJ__ macro.
		     */
		    offs += nInstBytes;
#if defined(WIN32) && !defined(__MINGW__)
		    if ((f == __win32_stdout()) || (f == __win32_stderr())) {
			cnt = __win32_fwrite((char *)anObject+offs, 1, len, f);
		    } else
# endif
		    {
			 __WRITEBYTES_OBJ__(cnt, f, anObject, offs, len, _buffered, __INST(handleType));
		    }
		}

		if (cnt >= 0) {
		    if (__isSmallInteger(__INST(position))) {
			INT np = __intVal(__INST(position)) + cnt;
			OBJ t;

			t = __MKINT(np); __INST(position) = t; __STORE(self, t);
		    } else {
			__INST(position) = nil; /* i.e. do not know */
		    }
		    RETURN ( __mkSmallInteger(cnt) );
		} else /* cnt < 0 */ {
		    if (
# ifdef EWOULDBLOCK
			(__threadErrno == EWOULDBLOCK) ||
# endif
			(__threadErrno == EAGAIN)
		    ) {
			RETURN ( __mkSmallInteger(0) );
		    }
		    __INST(position) = nil; /* i.e. do not know */
		    error = __mkSmallInteger(__threadErrno);
		}
	    }
	}
    }
bad: ;
#endif /* not SCHTEAM */
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self writeError:error.
	^ 0
    ].
    handle isNil ifTrue:[self errorNotOpen. ^ 0].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ 0].
    self primitiveFailed.
    ^ 0.
!

nextPutUnicode:aCharacter
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    self nextPutUtf8:aCharacter.
! !

!ExternalStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ExternalStream initialize!
