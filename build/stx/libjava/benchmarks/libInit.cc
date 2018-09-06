/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjava_benchmarks.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjava_benchmarks_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjava_benchmarks_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _JavaBenchmark_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaBenchmarkClassLoader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaBenchmarkClassReader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaBenchmarkMisc_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaBenchmarkRunner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libjava_137benchmarks_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _stx_137libjava_137benchmarks_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libstx_libjava_benchmarks_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_benchmarks__DFN", _libstx_libjava_benchmarks_InitDefinition, "stx:libjava/benchmarks");
    _stx_137libjava_137benchmarks_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libjava_benchmarks_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_benchmarks", _libstx_libjava_benchmarks_Init, "stx:libjava/benchmarks");
    _JavaBenchmark_Init(pass,__pRT__,snd);
    _JavaBenchmarkClassLoader_Init(pass,__pRT__,snd);
    _JavaBenchmarkClassReader_Init(pass,__pRT__,snd);
    _JavaBenchmarkMisc_Init(pass,__pRT__,snd);
    _JavaBenchmarkRunner_Init(pass,__pRT__,snd);
    _stx_137libjava_137benchmarks_Init(pass,__pRT__,snd);

    _stx_137libjava_137benchmarks_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
