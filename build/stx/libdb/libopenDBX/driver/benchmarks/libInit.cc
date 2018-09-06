/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/libInit.cc,v 1.1 2013-04-15 13:13:27 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver_benchmarks.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_benchmarks_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_benchmarks_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_driver_benchmarks_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_benchmarks__DFN", _libstx_libdb_libopenDBX_driver_benchmarks_InitDefinition, "stx:libdb/libopenDBX/driver/benchmarks");
_stx_137libdb_137libopenDBX_137driver_137benchmarks_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_driver_benchmarks_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_benchmarks", _libstx_libdb_libopenDBX_driver_benchmarks_Init, "stx:libdb/libopenDBX/driver/benchmarks");
_DBXBenchmark_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137driver_137benchmarks_Init(pass,__pRT__,snd);
_DBXBigBenchmarks_Init(pass,__pRT__,snd);
_DBXMultipleForksBenchmarks_Init(pass,__pRT__,snd);
_DBXTinyBenchmarks_Init(pass,__pRT__,snd);
_MysqlBigBenchmarks_Init(pass,__pRT__,snd);
_MysqlTinyBenchmarks_Init(pass,__pRT__,snd);
_PGBigBenchmarks_Init(pass,__pRT__,snd);
_PGTinyBenchmarks_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
