/*
 * demonstration of a c-function module
 *
 * compile it with:
 *      cc o demoCLib1.so -shared demo1.c
 * or simply:
 *      make demoCLib1
 *
 * in Smalltalk, load it with:
 *      handle := ObjectFileLoader loadDynamicObject:'demoCLib1.so'
 *
 * see example code in the CModules class.
 *
 * details:
 * get function handles:
 *
 *      f1 := handle getFunction:'demo1_function1'.
 *      f2 := handle getFunction:'demo1_function2'.
 *      f3 := handle getFunction:'demo1_function3'.
 *      f4 := handle getFunction:'demo1_function4'.
 *      f5 := handle getFunction:'demo1_function5'.
 *
 *
 * call a function:
 *
 *      f1 call.
 *
 *
 * call a function with an argument:
 *
 *      f2 callWith:999.
 *
 *
 * call a function which returns something:
 * (f3 and f5 return a string):
 *
 *      |bytes|
 *
 *      bytes := ExternalBytes address:(f3 callWith:'hello world')
 *   (be careful, the string is void when the module is unloaded;
 *    therefore, it should be immediately extracted and converted to
 *    a smalltalk object:
 *      s := bytes stringAt:1
 *   )
 *
 *
 * call a function with double-argument, which returns something:
 * (f4 expects a double and returns a double):
 *
 *      f4 callWithDouble:(Float pi) returnsDouble:true
 *
 *
 * finally, unload the library:
 *      ObjectFileLoader unloadDynamicObject:handle
 */
#include <stdio.h>

#ifdef __win32__
# define DLLEXPORT __declspec(dllexport)
#else
# define DLLEXPORT /* nothing */
#endif

DLLEXPORT void
demo1_function1() {
    printf("here is demo1_function1\n");
}

DLLEXPORT int
demo1_function2(int i) {
    printf("here is demo1_function2 i:%d\n", i);
    return i * 2;
}

DLLEXPORT char *
demo1_function3(char *s)
{
    printf("here is demo1_function3 s:%s\n", s);
    return "a string from C";
}

DLLEXPORT double
demo1_function4(double d)
{
    printf("here is demo1_function4 arg=%lf; returning 100.0\n", d);
    return 100.0;
}

DLLEXPORT char *
demo1_function5(double f)
{
    static char buffer[128];

    printf("here is demo1_function5 arg=%lf; returning string\n", f);
    sprintf(buffer, "%f", f);
    return buffer;
}

DLLEXPORT float
demo1_function6(double f1, double f2)
{
    printf("here is demo1_function6 args=%lf, %lf; returning float %f\n", f1, f2, f1+f2);
    return f1+f2;
}

DLLEXPORT double
demo1_function7(double f1, double f2)
{
    printf("here is demo1_function7 args=%lf, %lf; returning double %f\n", f1, f2, f1+f2);
    return f1+f2;
}

struct testStruct {
    int i1;
    int i2;
    int i3;
    int i4;
    int i5;
};

DLLEXPORT int
demo1_function8(struct testStruct s1, int i2)
{
    printf("here is demo1_function8 args=struct{%d, %d, %d, %d, %d}, %d; returning int %d\n",
		s1.i1, s1.i2, s1.i3, s1.i4, s1.i5,
		i2, s1.i1+s1.i5+i2);
    return s1.i1+s1.i5+i2;
}

void
call_demo1_function8() {
    struct testStruct s;
    s.i1 = 1;
    s.i2 = 2;
    s.i3 = 3;
    s.i4 = 4;
    s.i5 = 5;
    demo1_function8(s, 99);
}

DLLEXPORT struct testStruct
demo1_function9(int i1, int i2, int i3, int i4, int i5)
{
    struct testStruct ret;

    printf("here is demo1_function9 args=%d, %d, %d, %d, %d; returning struct\n",
		i1, i2, i3, i4, i5);
    ret.i1 = i1 * 2;
    ret.i2 = i2 * 3;
    ret.i3 = i3 * 4;
    ret.i4 = i4 * 5;
    ret.i5 = i5 * 6;
    return ret;
}

