/*
 * demonstration of a c-function module
 * with automatic initialization.
 *
 * compile it with:
 *      cc o demoCLib3.so -shared demo3.c
 * or simply:
 *      make demoCLib3
 *
 * in Smalltalk, load it with:
 *      handle := ObjectFileLoader loadDynamicObject:'demoCLib3.o'
 *
 * its init-function will automatically be called (returning failure here)
 */
#include <stdio.h>

#ifdef __win32__
# define DLLEXPORT __declspec(dllexport)
#else
# define DLLEXPORT /* nothing */
#endif

DLLEXPORT void
demo3_function1() {
    printf("here is demo3_function1\n");
}

DLLEXPORT int
__demoCLib3__Init() {
    printf("this is demo3's init function\n");
    return -1;   /* >= 0 means: OK */
}

DLLEXPORT void
__demoCLib3__deInit() {
    printf("this is demo3's deinit function\n");
}

