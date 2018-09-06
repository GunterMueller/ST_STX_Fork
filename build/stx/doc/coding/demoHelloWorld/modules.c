/* $Header: /cvs/stx/stx/doc/coding/demoHelloWorld/modules.c,v 1.1 2016-10-11 00:09:27 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_doc_coding_demoHelloWorld.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _HelloWorld_Init();
extern void _stx_137doc_137coding_137demoHelloWorld_Init();


static vf modules[] = {
    _HelloWorld_Init,
_stx_137doc_137coding_137demoHelloWorld_Init,

    (vf)0
};

vf *__modules__ = modules;
