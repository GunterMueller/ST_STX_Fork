/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_compiler_benchmarks.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_compiler_benchmarks_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_compiler_benchmarks_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_compiler_benchmarks_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler_benchmarks__DFN", _libstx_goodies_petitparser_compiler_benchmarks_InitDefinition, "stx:goodies/petitparser/compiler/benchmarks");
_stx_137goodies_137petitparser_137compiler_137benchmarks_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_compiler_benchmarks_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler_benchmarks", _libstx_goodies_petitparser_compiler_benchmarks_Init, "stx:goodies/petitparser/compiler/benchmarks");
_PPCBenchmark_Init(pass,__pRT__,snd);
_PPCLRPParser_137johanfabry_13739_Init(pass,__pRT__,snd);
_PPCSmalltalkNoopParser_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137compiler_137benchmarks_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
