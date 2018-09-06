/* $Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/modules.c,v 1.1 2012-10-02 11:43:27 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_goodies_demos_jh_math_fractalApplication.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _Demos__FractalApplication_Init();
extern void _Demos__FractalView_Init();
extern void _Demos__MandelbrotSet_Init();
extern void _Demos__SuperFormula_Init();
extern void _Demos__SuperFormulaApplication_Init();
extern void _stx_137goodies_137demos_137jh_137math_137fractalApplication_Init();
extern void _Demos__JuliaSet_Init();


static vf modules[] = {
    _Demos__FractalApplication_Init,
_Demos__FractalView_Init,
_Demos__MandelbrotSet_Init,
_Demos__SuperFormula_Init,
_Demos__SuperFormulaApplication_Init,
_stx_137goodies_137demos_137jh_137math_137fractalApplication_Init,
_Demos__JuliaSet_Init,

    (vf)0
};

vf *__modules__ = modules;
