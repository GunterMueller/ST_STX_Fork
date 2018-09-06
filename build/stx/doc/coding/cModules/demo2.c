/*
 * demonstration of a c-function module
 * with automatic initialization.
 *
 * compile it with:
 *      cc o demoCLib2.so -shared demo2.c
 * or simply:
 *      make demoCLib2
 *
 * in Smalltalk, load it with:
 *      handle := ObjectFileLoader loadDynamicObject:'demoCLib2.o'
 *
 * its init-function will automatically be called (returning success here)
 */
#include <stdio.h>

#ifdef __win32__
# define DLLEXPORT __declspec(dllexport)
#else
# define DLLEXPORT /* nothing */
#endif

DLLEXPORT void
demo2_function1() {
    printf("here is demo2_function1\n");
}

DLLEXPORT int
__demoCLib2__Init() {
    printf("this is demo2's init function\n");
    return 1;   /* >= 0 means: OK */
}

DLLEXPORT void
__demoCLib2__deInit() {
    printf("this is demo2's deinit function\n");
}

