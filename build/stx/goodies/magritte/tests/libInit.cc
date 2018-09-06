/*
 * $Header: /cvs/stx/stx/goodies/magritte/tests/libInit.cc,v 1.2 2014-09-23 20:31:52 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_magritte_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_magritte_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_magritte_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_magritte_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_magritte_tests__DFN", _libstx_goodies_magritte_tests_InitDefinition, "stx:goodies/magritte/tests");
_stx_137goodies_137magritte_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_magritte_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_magritte_tests", _libstx_goodies_magritte_tests_Init, "stx:goodies/magritte/tests");
_Magritte__MAAccessorMock_Init(pass,__pRT__,snd);
_Magritte__MAAdaptiveModelTest_Init(pass,__pRT__,snd);
_Magritte__MAConditionTest_Init(pass,__pRT__,snd);
_Magritte__MADescriptionBuilderTest_Init(pass,__pRT__,snd);
_Magritte__MADynamicObjectTest_Init(pass,__pRT__,snd);
_Magritte__MAExtensionsTest_Init(pass,__pRT__,snd);
_Magritte__MAFileModelTest_Init(pass,__pRT__,snd);
_Magritte__MAMockAddress_Init(pass,__pRT__,snd);
_Magritte__MAObjectTest_Init(pass,__pRT__,snd);
_Magritte__MATableModelTest_Init(pass,__pRT__,snd);
_stx_137goodies_137magritte_137tests_Init(pass,__pRT__,snd);
_Magritte__MAAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MADescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAExternalFileModelTest_Init(pass,__pRT__,snd);
_Magritte__MAMementoTest_Init(pass,__pRT__,snd);
_Magritte__MAMemoryFileModelTest_Init(pass,__pRT__,snd);
_Magritte__MACachedMementoTest_Init(pass,__pRT__,snd);
_Magritte__MAContainerTest_Init(pass,__pRT__,snd);
_Magritte__MADelegatorAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MADictionaryAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MAElementDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAIdentityAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MANullAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MAPluggableAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MASelectorAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MAStraitMementoTest_Init(pass,__pRT__,snd);
_Magritte__MAVariableAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MABooleanDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAChainAccessorTest_Init(pass,__pRT__,snd);
_Magritte__MACheckedMementoTest_Init(pass,__pRT__,snd);
_Magritte__MAClassDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAColorDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAFileDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAMagnitudeDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAPriorityContainerTest_Init(pass,__pRT__,snd);
_Magritte__MAReferenceDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAStringDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MADateDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MADurationDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAMemoDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MANumberDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAOptionDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAPasswordDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MARelationDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MASymbolDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MATableDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MATimeDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MATimeStampDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MATokenDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAMultipleOptionDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MASingleOptionDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAToManyRelationDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAToOneRelationDescriptionTest_Init(pass,__pRT__,snd);
_Magritte__MAToManyScalarRelationDescriptionTest_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
