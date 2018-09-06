/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser__DFN", _libstx_goodies_petitparser_InitDefinition, "stx:goodies/petitparser");
_stx_137goodies_137petitparser_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser", _libstx_goodies_petitparser_Init, "stx:goodies/petitparser");
_PPCharSetPredicate_Init(pass,__pRT__,snd);
_PPContext_Init(pass,__pRT__,snd);
_PPContextMemento_Init(pass,__pRT__,snd);
_PPFailure_Init(pass,__pRT__,snd);
_PPMemento_Init(pass,__pRT__,snd);
_PPParser_Init(pass,__pRT__,snd);
_PPStream_Init(pass,__pRT__,snd);
_PPToken_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_Init(pass,__pRT__,snd);
_PPDelegateParser_Init(pass,__pRT__,snd);
_PPEndOfFileParser_Init(pass,__pRT__,snd);
_PPEndOfLineParser_Init(pass,__pRT__,snd);
_PPEpsilonParser_Init(pass,__pRT__,snd);
_PPFailingParser_Init(pass,__pRT__,snd);
_PPListParser_Init(pass,__pRT__,snd);
_PPLiteralParser_Init(pass,__pRT__,snd);
_PPPluggableParser_Init(pass,__pRT__,snd);
_PPPredicateParser_Init(pass,__pRT__,snd);
_PPStartOfLine_Init(pass,__pRT__,snd);
_PPStartOfLineParser_Init(pass,__pRT__,snd);
_PPStartOfLogicalLineParser_Init(pass,__pRT__,snd);
_PPStartOfWordParser_Init(pass,__pRT__,snd);
_PPUnresolvedParser_Init(pass,__pRT__,snd);
_PPActionParser_Init(pass,__pRT__,snd);
_PPAndParser_Init(pass,__pRT__,snd);
_PPChoiceParser_Init(pass,__pRT__,snd);
_PPCompositeParser_Init(pass,__pRT__,snd);
_PPConditionalParser_Init(pass,__pRT__,snd);
_PPEndOfInputParser_Init(pass,__pRT__,snd);
_PPExpressionParser_Init(pass,__pRT__,snd);
_PPFlattenParser_Init(pass,__pRT__,snd);
_PPLiteralObjectParser_Init(pass,__pRT__,snd);
_PPLiteralSequenceParser_Init(pass,__pRT__,snd);
_PPMemoizedParser_Init(pass,__pRT__,snd);
_PPNotParser_Init(pass,__pRT__,snd);
_PPOptionalParser_Init(pass,__pRT__,snd);
_PPPredicateObjectParser_Init(pass,__pRT__,snd);
_PPPredicateSequenceParser_Init(pass,__pRT__,snd);
_PPRepeatingParser_Init(pass,__pRT__,snd);
_PPSequenceParser_Init(pass,__pRT__,snd);
_PPTrimmingParser_Init(pass,__pRT__,snd);
_PPLimitedChoiceParser_Init(pass,__pRT__,snd);
_PPLimitedRepeatingParser_Init(pass,__pRT__,snd);
_PPPossessiveRepeatingParser_Init(pass,__pRT__,snd);
_PPTokenParser_Init(pass,__pRT__,snd);
_PPWrappingParser_Init(pass,__pRT__,snd);
_PPGreedyRepeatingParser_Init(pass,__pRT__,snd);
_PPLazyRepeatingParser_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
