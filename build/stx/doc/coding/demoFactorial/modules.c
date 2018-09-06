/* $Header: /cvs/stx/stx/doc/coding/demoFactorial/modules.c,v 1.8 2016-10-10 23:35:24 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_doc_coding_demoFactorial.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _FactorialProgram_Init();
extern void _stx_137doc_137coding_137demoFactorial_Init();


static vf modules[] = {
    _FactorialProgram_Init,
_stx_137doc_137coding_137demoFactorial_Init,

    (vf)0
};

vf *__modules__ = modules;
