/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjava_experiments.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjava_experiments_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjava_experiments_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _JavaByteCodeInterpreter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaMethodWrapperCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NoReflectionObject_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PersonSample_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SampleHandler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SetSample_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libjava_137experiments_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaByteCodeSteppableInterpreter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_libjava_experiments_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_experiments__DFN", _libstx_libjava_experiments_InitDefinition, "stx:libjava/experiments");
    _stx_137libjava_137experiments_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libjava_experiments_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_experiments", _libstx_libjava_experiments_Init, "stx:libjava/experiments");
    _JavaByteCodeInterpreter_Init(pass,__pRT__,snd);
    _JavaMethodWrapperCompiler_Init(pass,__pRT__,snd);
    _NoReflectionObject_Init(pass,__pRT__,snd);
    _PersonSample_Init(pass,__pRT__,snd);
    _SampleHandler_Init(pass,__pRT__,snd);
    _SetSample_Init(pass,__pRT__,snd);
    _stx_137libjava_137experiments_Init(pass,__pRT__,snd);
    _JavaByteCodeSteppableInterpreter_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
