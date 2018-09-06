/*
 * DO NOT EDIT 
 * automagically generated from Make.proto (by make libInit.cc)
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>
#define INIT_TEXT_SECT /* as nothing */
#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#else /* not WIN32 */
# if defined(__GNUC__) && !defined(NO_SECTION_ATTRIBUTES)
#  if (__GNUC__  == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ > 2
#   undef INIT_TEXT_SECT
#   define INIT_TEXT_SECT __attribute__((section(".stxitext")))
#  endif
# endif /* not GNUC */
#endif /* not WIN32 */
#ifdef INIT_TEXT_SECT
DLL_EXPORT extern void _libstx_goodies_libdbase_Init() INIT_TEXT_SECT;
#endif
void _libstx_goodies_libdbase_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_libdbase", _libstx_goodies_libdbase_Init, "stx:goodies/libdbase");
_DBFile_Init(pass,__pRT__,snd);
_PersistencyManager_Init(pass,__pRT__,snd);
_stx_137goodies_137libdbase_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
