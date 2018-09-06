/*
 * Copyright (c) 2017 Jan Vrany
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
 * Implementation note: `stxHostMemMap()` / `stxHostMemUnmap()` provide
 * an interface to reserve a memory region but not commiting it. This is
 * used for reserving (huge) memory region for an oldspace (which as of now
 * has to be continguous).
 *
 * In Windows, this feature is directly provided by `VirtualAlloc()` /
 * `VirtualFree()`. Nice, but turned down by the fact that with couple
 * .DLLs loaded the space get's so fragmented (presumably) that reserving
 * as much (or, as few) as 512MB on 32bit system would fail. Sad.

 * On POSIX system memory reservation is emulated by `mmap()` with `PROT_NONE`.
 * and memory commit is done by `mprotect()`ing the previously reserved memory
 * with desired access. Similarly, decommiting the memory (but keeping it
 * reserved!) is emulated by `madvise(...MADV_FREE...)` followed by `mprotect()`
 * with `PROT_NONE`.
 * This appears to work OK on modern UNIX systems because overcommiting. The
 * system does not allocate physical memory / swap space until the page is
 * actually written to. So far this works, time will show...
 */

#include <assert.h>
#include "hmm.h"

#if defined(LINUX) || defined (FREEBSD)
# define USE_POSIX_API
#elif defined(_WIN32) || defined(_WIN64)
# define USE_WIN32_API
#else
  /*
   * Note to Claus: Support for VMS and macOS has been dropped
   * at this point.
   *
   * As for VMS: VMS is hardly used anymore, but in an unlikely case
   * somene needs Smalltalk/X running on VMS, one can easily restore the
   * old code. Smalltalk/X won't compile nor run on VMS just-like-that
   * anyway.
   *
   * As for macOS: This is indeed desirable. I'll add as soon as I get
   * access macOS machine  Until then...well, you're on your own. Sorry.
   * Won't be so hard to fix this code.
   */
# error "Not (yet) supported host platform"
#endif

#if defined(USE_POSIX_API)
# include <errno.h>
# include <unistd.h>
# include <sys/mman.h>
# if !defined(MAP_ANONYMOUS) && !defined(MAP_ANON)
   /*
    * Note to Claus: Support for systems without MAP_ANON has been dropped
    * in order to simplify the code.
    *
    * According to documentation for HP-UX 11i (2007), HP-UX supports MAP_ANON
    * Actually, it seems that HP-UX supports it from mid 90's. being the first
    * with MAP_ANON.
    *
    * If there'll ever be a need to run on a system with no MAP_ANON, it's
    * easy to modify code here to map /dev/zero. I can hardly imagine someone
    * in need of new Smalltalk/X running on UNIX system with no MAP_ANNON and
    * no /dev/zero. But in the unlikely case, I'll be more than happy to fix
    * the code to run on such a system given that I'm provided an access to it.
    *
    * To my knowledge, there were systems already phasing out in early 90's
    * with no mmap() at all - IIRC Ultrix, maybe OSF/1. I dont believe they're
    * still in service these days, so I don't care anymore.
    * But even if they're, one can make it kind-of-working by emulating mmap()
    * with malloc() / brk().
    */
#  error "MAP_ANONYMOUS unsupported on this platform. Please report to developers."
# endif
#endif

#if defined(USE_WIN32_API)
# include <windows.h>
#endif

#ifdef USE_WIN32_API
static inline DWORD _stxHostMemProtectionFlagsToNative(stx_hostmm_protection prot) {
    DWORD native_prot = 0;
    if (prot == (MemProtRead | MemProtWrite)) {
        native_prot = PAGE_READWRITE;
    } else if (prot == (MemProtRead | MemProtWrite | MemProtExec)) {
        native_prot = PAGE_EXECUTE_READWRITE;
    } else if (prot == MemProtNone) {
        native_prot = PAGE_NOACCESS;
    } else {
        assert(0 && "Given memory protection flags not supported by host MM");
    }
    return native_prot;
}

static inline DWORD _stxHostMemFlagsToNative(stx_hostmm_flags flags) {
    DWORD native_type = 0;
    if (flags & MemFlagReserve) native_type |= MEM_RESERVE;
    if (flags & MemFlagCommit)  native_type |= MEM_COMMIT;
    return native_type;
}
#endif

static inline int _stxHostMemAdviseDontNeed(void *addr, size_t length) {
#ifdef USE_POSIX_API
    int retval = -1;
# ifdef MADV_FREE
    retval = madvise(addr, length, MADV_FREE);
#  ifdef LINUX
    /*
     * The trouble with MADV_FREE on Linux is that it's supported
     * by kernels 4.5 and newer. On older kernels it's not supported,
     * but we don't know what kernel version we're running on.
     *
     * So, if madvise fails on Linux, retry with POSIXly MADV_DONTNEED.
     */
    if (retval == -1 && errno == EINVAL) {
        retval = madvise(addr, length, MADV_DONTNEED);
    }
#  endif // LINUX
# else // MADV_FREE
    /*
     * No MADV_FREE, so fall back to MADV_DONTNEED. I'm not sure it helps
     * much, though.
     */
    retval = madvise(addr, length, MADV_DONTNEED);
# endif // MADV_FREE
    return retval == 0 ? 1 : 0;
#endif
#ifdef USE_WIN32_API
    void* retval;
    retval = VirtualAlloc(addr, length, MEM_RESET, PAGE_NOACCESS);
    return retval == NULL ? 0 : 1;
#endif
    return 1;
}

static inline int _stxHostMemAdviseAccessSequentially(void *addr, size_t length) {
#ifdef USE_POSIX_API
    return madvise(addr, length, MADV_SEQUENTIAL) == 0 ? 1 : 0;
#endif
    return 1;
}

static inline int _stxHostMemAdviseAccessRandomly(void *addr, size_t length) {
#ifdef USE_POSIX_API
    return madvise(addr, length, MADV_RANDOM) == 0 ? 1 : 0;
#endif
    return 1;
}

static inline int _stxHostMemAdviseWillNeed(void *addr, size_t length) {
#ifdef USE_POSIX_API
    return madvise(addr, length, MADV_WILLNEED) == 0 ? 1 : 0;
#endif
    return 1;
}

int stxHostMemPageSize() {
    static int pagesize = -1;
    if (pagesize == -1) {
#ifdef USE_POSIX_API
        pagesize = (int)sysconf(_SC_PAGESIZE);
        if (pagesize == -1) {
            return 0;
        }
#endif
#ifdef USE_WIN32_API
        SYSTEM_INFO info;
        GetSystemInfo(&info);
        pagesize = (int)info.dwPageSize;
#endif
    }
    return pagesize;
}

void* stxHostMemMap(void* addr, size_t length, stx_hostmm_protection prot, stx_hostmm_flags flags, char *name) {
    void *region = MAP_FAILED;
    assert( (!(flags & MemFlagExact) || (addr != NULL)) && "MemFlagExact specified but no addr provided");
    assert( (!(!(flags & MemFlagReserve) && (flags & MemFlagCommit)) || (addr != NULL)) && "MemFlagCommit specified but no addr provided");
#ifdef USE_POSIX_API
    if ( !(flags & MemFlagReserve) && (flags & MemFlagCommit)) {
        /*
         * Request to commit previously reserved memory. See implementation
         * note above for explanation of the mprotect() here.
         */
        if (mprotect(addr, length, prot) == 0) {
            return addr;
        } else {
            return MAP_FAILED;
        }
    }
    if ( (flags & MemFlagReserve) && !(flags & MemFlagCommit)) {
        /*
         * Request to reserve memory but not commiting it. See implementation
         * note above.
         * So, make the memory inaccessible...
         */
        prot = 0;
        /* and fall though to mmap... */
    }
# ifdef LINUX
    if ((flags & MemFlagOldSpace) && !(flags & MemFlagExact)) {
        /*
         * On Linux, try to allocate oldspace at lowest possible address to
         * maximize chance an address space right beyond the oldspace is free
         * (unmapped).
         *
         * See https://swing.fit.cvut.cz/projects/stx-jv/ticket/107
         *     http://duartes.org/gustavo/blog/post/anatomy-of-a-program-in-memory/
         *
         * Leave 32MB space between current program break and oldspace so
         * malloc() may sbrk() a little more if it needs to.
         */
        void* brk = sbrk(0);
        region = mmap(brk + 1024*1024*32, length, prot, MAP_ANONYMOUS | MAP_PRIVATE, 0, (off_t)0);
        if (region != MAP_FAILED) {
            return region;
        }
    }
# endif // LINUX
    region = mmap(addr, length, prot, MAP_ANONYMOUS | MAP_PRIVATE, 0, (off_t)0);
    if (flags & MemFlagExact) {
        if (region != addr) {
            munmap(region, length);
            region = MAP_FAILED;
        }
    }
#endif // USE_POSIX_API
#ifdef USE_WIN32_API
    DWORD native_prot = _stxHostMemProtectionFlagsToNative(prot);
    DWORD native_type = _stxHostMemFlagsToNative(flags);
    region = VirtualAlloc(addr, length, native_type, native_prot);
    if (region == NULL) {
        region = MAP_FAILED;
    } else {
        if ( (flags & MemFlagExact) && (region != addr)) {
            VirtualFree(addr, 0, MEM_RELEASE);
            region = MAP_FAILED;
        }
    }
#endif // USE_WIN32_API
    return region;
}

int stxHostMemUnmap(void* addr, size_t length, stx_hostmm_flags flags) {
    assert ( (flags & (MemFlagDecommit | MemFlagRelease)) && "Neither MemFlagDecommit nor MemFlagRelease specified");
#ifdef USE_POSIX_API
    if (flags & MemFlagRelease) {
        /*
         * Tell the system we won't need the memory anymore and contents
         * can be thrown away
         */
        _stxHostMemAdviseDontNeed(addr, length);
        return (mprotect(addr, length, PROT_NONE) == 0 ? 1 : 0 );
    } else {
        return (munmap(addr, length) == 0 ? 1 : 0 );
    }
#endif // USE_POSIX_API
#ifdef USE_WIN32_API
    if (flags & MemFlagRelease) {
        return ( VirtualFree(addr, 0, MEM_RELEASE) != 0 ? 1 : 0 );
    } else if (flags & MemFlagDecommit) {
        return ( VirtualFree(addr, 0, MEM_DECOMMIT) != 0 ? 1 : 0 );
    }
#endif // USE_WIN32_API
    return 0;
}

int  stxHostMemProtect(void *addr, size_t length, stx_hostmm_protection prot) {
#ifdef USE_POSIX_API
    return ( mprotect(addr, length, prot) == 0 ? 1 : 0 );
#endif // USE_POSIX_API
#ifdef USE_WIN32_API
    DWORD native_prot = _stxHostMemProtectionFlagsToNative(prot);
    DWORD unused;
    return (VirtualProtect(addr, length, native_prot, &unused) != 0 ? 1 : 0 );
#endif // USE_WIN32_API
    return 0;
}

int  stxHostMemAdvise(void *addr, size_t length, stx_hostmm_flags advice) {
    assert( addr != NULL && "`addr` may not be NULL");
    if (advice & MemFlagDontNeed) {
        return _stxHostMemAdviseDontNeed(addr, length);
    } else if (advice & MemFlagWillNeed) {
        if (!_stxHostMemAdviseWillNeed(addr, length)) {
            return 0;
        }
        if (advice & MemFlagAccessSequentially) {
            return _stxHostMemAdviseAccessSequentially(addr, length);
        } else if (advice & MemFlagAccessRandomly) {
            return _stxHostMemAdviseAccessRandomly(addr, length);
        } else {
            return 1;
        }
    } else {
        assert(0 && "Invalid value of `advice`, check documentation for supported values");
        return 0;
    }
}
