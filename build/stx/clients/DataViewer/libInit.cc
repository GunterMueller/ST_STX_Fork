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
DLL_EXPORT extern void _DataViewer_Init() INIT_TEXT_SECT;
#endif
void _DataViewer_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("DataViewer", _DataViewer_Init, "stx:clients/DataViewer");
_TDV__TDVObject_Init(pass,__pRT__,snd);
_TDV__NormalVectorUtilities_Init(pass,__pRT__,snd);
_TDV__TextUtilities_Init(pass,__pRT__,snd);
_TDV__AbstractComponent_Init(pass,__pRT__,snd);
_TDV__DrawableComponent_Init(pass,__pRT__,snd);
_TDV__SeparatorPlane_Init(pass,__pRT__,snd);
_TDV__PlaneStandard_Init(pass,__pRT__,snd);
_TDV__Data_Init(pass,__pRT__,snd);
_TDV__MatrixData_Init(pass,__pRT__,snd);
_TDV__LabelForAxis_Init(pass,__pRT__,snd);
_TDV__FrameStandard_Init(pass,__pRT__,snd);
_TDV__DrawWithVertexArray_Init(pass,__pRT__,snd);
_TDV__DisplayListUtilities_Init(pass,__pRT__,snd);
_TDV__DataRenderer_Init(pass,__pRT__,snd);
_TDV__DataRenderer3D_Init(pass,__pRT__,snd);
_TDV__AxisStandard_Init(pass,__pRT__,snd);
_TDV__ApplicationMatrix3D_Init(pass,__pRT__,snd);
_TDV__DataViewer_Init(pass,__pRT__,snd);
_TDV__DataViewer3D_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
