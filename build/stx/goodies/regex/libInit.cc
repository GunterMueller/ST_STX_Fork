/*
 * $Header: /cvs/stx/stx/goodies/regex/libInit.cc,v 1.14 2013-03-01 19:00:58 stefan Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_regex.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_regex_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_regex_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_regex_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_regex__DFN", _libstx_goodies_regex_InitDefinition, "stx:goodies/regex");
_stx_137goodies_137regex_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_regex_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_regex", _libstx_goodies_regex_Init, "stx:goodies/regex");
_Regex__RxCharSetParser_Init(pass,__pRT__,snd);
_Regex__RxMatchOptimizer_Init(pass,__pRT__,snd);
_Regex__RxMatcher_Init(pass,__pRT__,snd);
_Regex__RxParser_Init(pass,__pRT__,snd);
_Regex__RxmLink_Init(pass,__pRT__,snd);
_Regex__RxmTerminator_Init(pass,__pRT__,snd);
_Regex__RxsNode_Init(pass,__pRT__,snd);
_stx_137goodies_137regex_Init(pass,__pRT__,snd);
_Regex__RxmBranch_Init(pass,__pRT__,snd);
_Regex__RxmMarker_Init(pass,__pRT__,snd);
_Regex__RxmPredicate_Init(pass,__pRT__,snd);
_Regex__RxmRepetition_Init(pass,__pRT__,snd);
_Regex__RxmSpecial_Init(pass,__pRT__,snd);
_Regex__RxmSubstring_Init(pass,__pRT__,snd);
_Regex__RxsBranch_Init(pass,__pRT__,snd);
_Regex__RxsCharClass_Init(pass,__pRT__,snd);
_Regex__RxsCharSet_Init(pass,__pRT__,snd);
_Regex__RxsCharacter_Init(pass,__pRT__,snd);
_Regex__RxsContextCondition_Init(pass,__pRT__,snd);
_Regex__RxsEpsilon_Init(pass,__pRT__,snd);
_Regex__RxsMessagePredicate_Init(pass,__pRT__,snd);
_Regex__RxsPiece_Init(pass,__pRT__,snd);
_Regex__RxsPredicate_Init(pass,__pRT__,snd);
_Regex__RxsRange_Init(pass,__pRT__,snd);
_Regex__RxsRegex_Init(pass,__pRT__,snd);
_Regex__RxsSpecial_Init(pass,__pRT__,snd);

_stx_137goodies_137regex_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
