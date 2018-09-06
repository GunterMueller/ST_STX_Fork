/*
 * DO NOT EDIT 
 * automatically generated from Make.proto (by make libInit.cc)
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
DLL_EXPORT extern void _PingPong_Init() INIT_TEXT_SECT;
#endif
void _PingPong_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("PingPong", _PingPong_Init, "stx:clients/PingPong");
_Games__PingPongObject_Init(pass,__pRT__,snd);
_Games__PingPongBall_Init(pass,__pRT__,snd);
_Games__PingPongGame_Init(pass,__pRT__,snd);
_Games__PingPongPlayer_Init(pass,__pRT__,snd);
_Games__PingPongComputerPlayer_Init(pass,__pRT__,snd);
_Games__PingPongView_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
