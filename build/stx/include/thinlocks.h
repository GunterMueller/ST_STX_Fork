/*
 * Copyright (c) 2016-2017 Jan Vrany
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

/**
 * This file contain an implementation of thinlocks [1] in Smalltalk/X.
 *
 * A lockword layout (encoded as SmallInteger):
 *
 *   31                                 0
 *    TTTTTTTT TTTTTTTT TTTTCCCC CCCCCCC1
 *
 * where:
 *    * bits marked by 'T' denote Process ID
 *    * bits marked by 'C' denote nested lock count - 1
 *
 * The lowest bit is always one (it's the SmallInteger tag) On a 64bit
 * architecture, high 32bits are always zero.
 *
 * When inclusing this header, you MUST include `stc.h` first. When included
 * in stx:librun (i.e, Smalltalk/X VM code), you MUST also include 'runtime.h'
 * before.
 *
 * [1]: David F. Bacon, Ravi Konuru, Chet Murthy, Mauricio Serrano:
 *      Thin locks: featherweight synchronization for Java, ACM SIGPLAN 1998
 */

#ifndef __THINLOCKS_H__
#define __THINLOCKS_H__

#define STX_LOCKWORD_PID_SHIFT    12
#define STX_LOCKWORD_CNT_SHIFT    1
#define STX_LOCKWORD_PID_MASK     (__llu__(0xFFFFF001))
#define STX_LOCKWORD_CNT_MASK     (__llu__(0xFFFFFFFF) & ~STX_LOCKWORD_PID_MASK)
#define STX_LOCKWORD_UNLOCKED     (__llu__(1))
#define STX_LOCKWORD_LOCKED_ONCE  (__activeProcessIdtl)
#define STX_LOCKWORD_LOCKED_TWICE (__activeProcessIdtl+2)


/*
 * Some sanity checks
 */
#ifndef MAX_PROCESS_ID
# error "OOPS, MAX_PROCESS_ID not defined!"
#else
# if MAX_PROCESS_ID > (STX_LOCKWORD_PID_MASK >> STX_LOCKWORD_PID_SHIFT)
#  error "MAX_PROCESS_ID cannot fit into lockword PID field. Adjust MAX_PROCESS_ID in stcIntern.h or STX_LOCKWORD_PID_MASK/STX_LOCKWORD_PID_SHIFT in thinlocks.h"
# endif
#endif

typedef enum {
    StxThinlockSuccess = 1,
    StxThinlockFailure = 0
} stx_thinlock_status;

#define INV_COUNT (~((unsigned INT)0))

#if defined(__GNUC__)  || defined(__clang__)
static inline int stxAtomicCompareAndSwap(unsigned INT *ptr, unsigned INT expected, unsigned INT desired) {
    /*
     * Note that we're using __ATOMIC_RELAXED, this MUST be changed once
     * (if ever) we move to native threads.
     */
    return __atomic_compare_exchange_n(ptr, &expected, desired, 0, __ATOMIC_RELAXED, __ATOMIC_RELAXED);
}
#else
# error "No implementation of `stxAtomicCompareAndSwap()` provided for used C compiler"
#endif

/*
 * Return (smalltalk) process id of given `lockword` or `INV_PROCESS_ID`
 * if either:
 *
 *   * no process is owning the lock or
 *   * `lockword` is invalid (i.e, not an valid SmallInteger object)
 *
 */
static inline unsigned INT stxLockwordGetPid(unsigned INT lockword) {
    if ((__isSmallInteger((OBJ)lockword)) && (lockword != STX_LOCKWORD_UNLOCKED)) {
        return lockword >> STX_LOCKWORD_PID_SHIFT;
    } else {
        return INV_PROCESS_ID;
    }
}

/*
 * Return lock count (nesting depth) of given `lockword` or `INV_COUNT` if
 * `lockword` is invalid (.e., not an valid SmallInteger object).
 */
static inline unsigned INT stxLockwordGetCnt(unsigned INT lockword) {
    if (__isSmallInteger((OBJ)lockword)) {
        return ((lockword & STX_LOCKWORD_CNT_MASK) >> STX_LOCKWORD_CNT_SHIFT) + 1;
    } else {
        return INV_COUNT;
    }
}

/*
 * Attempt to lock given thinlock
 *
 *  * Upon success, returns `StxThinlockSuccess` and updates
 *    the lock (atomically)
 *
 *  * Upon failure, returns `StxThinlockFailure` and leaves
 *    lockword intact. Caller has to handle this case.
 *
 * A thinlock may fail to lock because:
 *
 *   * there's a contention
 *   * lockword is actually a refence to a fatlock
 *   * max nesting limit for thinlock has been reached
 */
static inline stx_thinlock_status stxThinLock(unsigned INT* lockword) {
    /*
     * Most common case: lock is not locked at all
     */
    if (stxAtomicCompareAndSwap(lockword, STX_LOCKWORD_UNLOCKED, STX_LOCKWORD_LOCKED_ONCE)) {
        return StxThinlockSuccess;
    }
    /*
     * Second most common case: lock is locked by the current thread
     * (once)
     */
    if (stxAtomicCompareAndSwap(lockword, STX_LOCKWORD_LOCKED_ONCE, STX_LOCKWORD_LOCKED_TWICE)) {
        return StxThinlockSuccess;
    }

    /*
     * Less common case: lock is owned by an active thread multiple times
     * (i.e., nested locking)
     */
    {
        unsigned INT expected = *lockword;
        if ((expected & STX_LOCKWORD_PID_MASK) == __activeProcessIdtl) {
            if ((expected & STX_LOCKWORD_CNT_MASK) != STX_LOCKWORD_CNT_MASK) {
                if (stxAtomicCompareAndSwap(lockword, expected, expected + 2)) {
                   return StxThinlockSuccess;
                }
            }
        }
    }
    /*
     * Cannot lock...
     */
    return StxThinlockFailure;
}

/*
 * Attempt to unlock given thinlock
 *
 *  * Upon success, returns `StxThinlockSuccess` and updates
 *    the lock (atomically)
 *
 *  * Upon failure, returns `StxThinlockFailure` and leaves
 *    lockword intact. Caller has to handle this case.
 *
 * A thinlock may fail to unlock because:
 *
 *   * there's a contention
 *   * lockword is actually a reference to a fatlock
 */
static inline stx_thinlock_status stxThinUnlock(unsigned INT* lockword) {
    /*
     * Most common case: lock is locked by an active thread,
     * no nesting.
     */
    if (stxAtomicCompareAndSwap(lockword, STX_LOCKWORD_LOCKED_ONCE, STX_LOCKWORD_UNLOCKED)) {
        return StxThinlockSuccess;
    }
    /*
     * Lesscommon case: lock is owned by an active process
     * multiple times (i.e., nested locking)
     */
    {
        unsigned INT expected = *lockword;
        if ((expected & STX_LOCKWORD_PID_MASK) == __activeProcessIdtl) {
            if ((expected & STX_LOCKWORD_CNT_MASK) != STX_LOCKWORD_CNT_MASK) {
                if (stxAtomicCompareAndSwap(lockword, expected, expected - 2)) {
                   return StxThinlockSuccess;
                }
            }
        }
    }    /*
     * Cannot unlock...
     */
    return StxThinlockFailure;
}

#endif /* __THINLOCKS_H__ */
