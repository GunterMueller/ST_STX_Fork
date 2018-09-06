/*
 * $Header: /cvs/stx/stx/goodies/magritte/libInit.cc,v 1.3 2014-09-23 20:24:27 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_magritte.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_magritte_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_magritte_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_magritte_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_magritte__DFN", _libstx_goodies_magritte_InitDefinition, "stx:goodies/magritte");
_stx_137goodies_137magritte_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_magritte_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_magritte", _libstx_goodies_magritte_Init, "stx:goodies/magritte");
_Magritte__MAAdaptiveModel_Init(pass,__pRT__,snd);
_Magritte__MACompatibility_Init(pass,__pRT__,snd);
_Magritte__MADescriptionBuilder_Init(pass,__pRT__,snd);
_Magritte__MAError_Init(pass,__pRT__,snd);
_Magritte__MAFileModel_Init(pass,__pRT__,snd);
_Magritte__MAObject_Init(pass,__pRT__,snd);
_Magritte__MAProxyObject_Init(pass,__pRT__,snd);
_Magritte__MASortBlock_Init(pass,__pRT__,snd);
_Magritte__MATableModel_Init(pass,__pRT__,snd);
_Magritte__MAValueHolder_Init(pass,__pRT__,snd);
_Magritte__MAVisitor_Init(pass,__pRT__,snd);
_stx_137goodies_137magritte_Init(pass,__pRT__,snd);
_Magritte__MAAccessor_Init(pass,__pRT__,snd);
_Magritte__MACondition_Init(pass,__pRT__,snd);
_Magritte__MADescription_Init(pass,__pRT__,snd);
_Magritte__MADescriptionHolder_Init(pass,__pRT__,snd);
_Magritte__MADynamicObject_Init(pass,__pRT__,snd);
_Magritte__MAExternalFileModel_Init(pass,__pRT__,snd);
_Magritte__MAGraphVisitor_Init(pass,__pRT__,snd);
_Magritte__MAMemento_Init(pass,__pRT__,snd);
_Magritte__MAMemoryFileModel_Init(pass,__pRT__,snd);
_Magritte__MANamedBuilder_Init(pass,__pRT__,snd);
_Magritte__MAPropertyError_Init(pass,__pRT__,snd);
_Magritte__MAReadError_Init(pass,__pRT__,snd);
_Magritte__MAStreamingVisitor_Init(pass,__pRT__,snd);
_Magritte__MAValidationError_Init(pass,__pRT__,snd);
_Magritte__MAWriteError_Init(pass,__pRT__,snd);
_Magritte__MACachedMemento_Init(pass,__pRT__,snd);
_Magritte__MAConditionError_Init(pass,__pRT__,snd);
_Magritte__MAConflictError_Init(pass,__pRT__,snd);
_Magritte__MAConjunctiveCondition_Init(pass,__pRT__,snd);
_Magritte__MAContainer_Init(pass,__pRT__,snd);
_Magritte__MADelegatorAccessor_Init(pass,__pRT__,snd);
_Magritte__MADictionaryAccessor_Init(pass,__pRT__,snd);
_Magritte__MAElementDescription_Init(pass,__pRT__,snd);
_Magritte__MAIdentityAccessor_Init(pass,__pRT__,snd);
_Magritte__MAKindError_Init(pass,__pRT__,snd);
_Magritte__MAMultipleErrors_Init(pass,__pRT__,snd);
_Magritte__MANegationCondition_Init(pass,__pRT__,snd);
_Magritte__MANullAccessor_Init(pass,__pRT__,snd);
_Magritte__MAPluggableAccessor_Init(pass,__pRT__,snd);
_Magritte__MAPluggableCondition_Init(pass,__pRT__,snd);
_Magritte__MARangeError_Init(pass,__pRT__,snd);
_Magritte__MAReader_Init(pass,__pRT__,snd);
_Magritte__MARequiredError_Init(pass,__pRT__,snd);
_Magritte__MASelectorAccessor_Init(pass,__pRT__,snd);
_Magritte__MAStraitMemento_Init(pass,__pRT__,snd);
_Magritte__MAValidatorVisitor_Init(pass,__pRT__,snd);
_Magritte__MAVariableAccessor_Init(pass,__pRT__,snd);
_Magritte__MAWriter_Init(pass,__pRT__,snd);
_Magritte__MABooleanDescription_Init(pass,__pRT__,snd);
_Magritte__MAChainAccessor_Init(pass,__pRT__,snd);
_Magritte__MACheckedMemento_Init(pass,__pRT__,snd);
_Magritte__MAClassDescription_Init(pass,__pRT__,snd);
_Magritte__MAColorDescription_Init(pass,__pRT__,snd);
_Magritte__MAFileDescription_Init(pass,__pRT__,snd);
_Magritte__MAMagnitudeDescription_Init(pass,__pRT__,snd);
_Magritte__MAPriorityContainer_Init(pass,__pRT__,snd);
_Magritte__MAReferenceDescription_Init(pass,__pRT__,snd);
_Magritte__MAStringDescription_Init(pass,__pRT__,snd);
_Magritte__MAStringReader_Init(pass,__pRT__,snd);
_Magritte__MAStringWriter_Init(pass,__pRT__,snd);
_Magritte__MADateDescription_Init(pass,__pRT__,snd);
_Magritte__MADurationDescription_Init(pass,__pRT__,snd);
_Magritte__MAMemoDescription_Init(pass,__pRT__,snd);
_Magritte__MANumberDescription_Init(pass,__pRT__,snd);
_Magritte__MAOptionDescription_Init(pass,__pRT__,snd);
_Magritte__MAPasswordDescription_Init(pass,__pRT__,snd);
_Magritte__MARelationDescription_Init(pass,__pRT__,snd);
_Magritte__MASymbolDescription_Init(pass,__pRT__,snd);
_Magritte__MATableDescription_Init(pass,__pRT__,snd);
_Magritte__MATimeDescription_Init(pass,__pRT__,snd);
_Magritte__MATimeStampDescription_Init(pass,__pRT__,snd);
_Magritte__MATokenDescription_Init(pass,__pRT__,snd);
_Magritte__MAMultipleOptionDescription_Init(pass,__pRT__,snd);
_Magritte__MASingleOptionDescription_Init(pass,__pRT__,snd);
_Magritte__MAToManyRelationDescription_Init(pass,__pRT__,snd);
_Magritte__MAToOneRelationDescription_Init(pass,__pRT__,snd);
_Magritte__MAToManyScalarRelationDescription_Init(pass,__pRT__,snd);

_stx_137goodies_137magritte_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
