/*
 * Copyright (c) 2017-2018 Jan Vrany
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
#if defined(LINUX) || defined (FREEBSD)
# define USE_POSIX_API
#elif defined(_WIN32) || defined(_WIN64)
# define USE_WIN32_API
#else
# error "Not (yet) supported host platform"
#endif

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <signal.h>

#ifdef USE_POSIX_API
# include <sys/types.h>
# include <unistd.h>
#endif

#ifdef USE_WIN32_API
# include <windows.h>
#endif

#ifdef LINUX
# include <execinfo.h>
#endif

#define __IN_VM__

#include "stc.h"
#include "debug.h"

/*
 * Following extern declarations should be included from `runtime.h`
 * but this file is not distributed in binary distribution hence
 * following declarations. Too bad. I'm sorry.
 */
extern char __stopOnSIGABRT__;
extern char __catchingExit__;

static
void stxDebugSIGABRTHandler(int signo) {
    fprintf(stderr, "VM [error]: got SIGABRT\n\n");
    if (__stopOnSIGABRT__) {
        stxDebugWaitForDebugger();
    } else {
        stxDebugCrashReportPrint();
        /*
         * On Windows, `abort()` terminates the process by calling
         * `_exit()`. However, `_exit()` is intercepted and ignored
         * when `__catchingExit__` is 1 (a safety measure to prevent
         * bad libraries to call `exit()`). Therefore, to make sure the
         * process would terminate (which it should, according to
         * C99 specification of `abort()`), we need to clear the
         * flag. Sigh.
         */
#if defined(_WIN32) || defined(_WIN64)
        __catchingExit__ = 0;
#endif
    }
}


void stxDebugInit(void) {
    static _Bool called = 0;
    assert(called == 0 && "stxDebugInit() called twice");
    called = 1;
    /*
     * Install default handler for SIGABRT
     */
#ifdef USE_POSIX_API
    {
        struct sigaction action;

        memset(&action, 0, sizeof(action));
        action.sa_handler = stxDebugSIGABRTHandler;
        sigaction(SIGABRT, &action, NULL);
    }
#endif
#ifdef USE_WIN32_API
    signal(SIGABRT, stxDebugSIGABRTHandler);
#endif
}

void stxDebugWaitForDebugger(void) {
#ifdef USE_POSIX_API
    pid_t pid = getpid();
    fprintf(stderr, "error occured (see above), waiting for debugger to attach\n"
                    "\n"
                    "to terminate:\n"
                    "\n"
                    "    kill -SIGKILL %d\n"
                    "\n"
                    "to resume execution:\n"
                    "\n"
                    "    kill -SIGCONT %d\n"
                    "\n"
                    "to attach a debugger:\n"
                    "\n"
                    "    gdb attach %d\n"
                    "\n",
                    pid, pid, pid);
    fflush(stderr);    
    kill(pid, SIGSTOP);
#endif
#ifdef USE_WIN32_API
    static const int secsToWait = 30*60 /*30 mins */;
    DWORD pid = GetCurrentProcessId();
    fprintf(stderr, "error occured (see above), waiting 30 mins for debugger to attach\n"
                    "\n"
                    "to terminate:\n"
                    "\n"
                    "    taskkill /F /PID %lu\n"
                    "\n"
                    "to attach a debugger:\n"
                    "\n"
                    "    gdb attach %lu\n"
                    "\n",
                    pid, pid);
    fflush(stderr);
    {
        int i = 0;
        while (! IsDebuggerPresent() && (i < secsToWait)) {
            Sleep(5000/*5 secs*/);
            i += 5;
        }
    }
    if (! IsDebuggerPresent() ) {
        fprintf(stderr, "debugger did not attach in 30mins, terminating()\n");
        fflush(stderr);
        exit(0);
    }
#endif
}


void stxDebugCrashReportPrint(void) {
    __printStack(NULL);
#ifdef LINUX
#define max_frames 100
    {
        int num_frames = 0;
        void* frames[max_frames];
        fprintf(stderr,"\n\nVM [info]: machine backtrace:\n");
        num_frames = backtrace(frames, max_frames);
        backtrace_symbols_fd(frames, num_frames, STDERR_FILENO);
    }
#endif
}
