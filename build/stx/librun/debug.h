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
 * This file contains a platform abstraction for verious debugging routines
 */

#ifndef __DEBUG_H
#define __DEBUG_H
/**
 * Initializes debug support. To be called during early VM initialization
 * and only once.
 */
void stxDebugInit(void);

/**
 * Suspend a Smalltalk/X process and wait for debugger to attach. Print
 * instructions how to attach a debugger. Once debugger is attached, the
 * Smalltalk process is at his mercy.
 *
 * Jan's personal (ego boosting) note: this is probably the sigle greatest
 * invention of mine ever. This simple trick saved me so much time, I always
 * run the Smalltalk/X with `--stopOnSEGV` & `--stopOnInternalError` so I can
 * analyze a crash. I'm so proud of it.
 */
void stxDebugWaitForDebugger(void);

/**
 * Print a human readable crash report to stderr. The contents of the report
 * is platform-specific.
 */
void stxDebugCrashReportPrint(void);

#endif//__DEBUG_H
