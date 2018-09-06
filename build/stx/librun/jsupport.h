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

/**
 * This file contains helper routines required by Smalltalk/X Java runtime
 * (STX:LIBJAVA)
 */

#ifndef __JSUPPORT_H
#define __JSUPPORT_H


#include <stc.h>
#include <thinlocks.h>

static inline unsigned INT* stxGetLockwordPtr(OBJ o) {
    return (unsigned INT*)(&(o->i_instvars));
}

static inline void stxJ_MONITORENTER(OBJ o) {
#ifdef THINLOCKING
    if ( stxThinLock( stxGetLockwordPtr(o) ) == StxThinlockSuccess ) {
        return;
    }
#endif
    {
        static struct inlineCache ilc_MONITORENTER = __ILC1(0);
        static OBJ                sym_MONITORENTER = (OBJ)0;
        if (sym_MONITORENTER == (OBJ)0) {
            sym_MONITORENTER = __MKSYMBOL("_MONITORENTER:", (OBJ*)0);
            __ADD_REFCELL(&sym_MONITORENTER);
        }
        (*ilc_MONITORENTER.ilc_func)(JavaVM, sym_MONITORENTER, nil, &ilc_MONITORENTER, o);
    }
}

static inline void stxJ_MONITOREXIT(OBJ o) {
#ifdef THINLOCKING
    if ( stxThinUnlock( stxGetLockwordPtr(o) ) == StxThinlockSuccess ) {
        return;
    }
#endif
    {
        static struct inlineCache ilc_MONITOREXIT = __ILC1(0);
        static OBJ                sym_MONITOREXIT = (OBJ)0;
        if (sym_MONITOREXIT == (OBJ)0) {
            sym_MONITOREXIT = __MKSYMBOL("_MONITOREXIT:", (OBJ*)0);
            __ADD_REFCELL(&sym_MONITOREXIT);
        }
        (*ilc_MONITOREXIT.ilc_func)(JavaVM, sym_MONITOREXIT, nil, &ilc_MONITOREXIT, o);
    }
}

void stxJ_throwOutOfMemoryError(char *message);

#endif //__JSUPPORT_H


