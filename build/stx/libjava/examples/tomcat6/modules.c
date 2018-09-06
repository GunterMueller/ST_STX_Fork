/* $Header: /cvs/stx/stx/libjava/examples/tomcat6/modules.c,v 1.5 2015-03-20 12:08:03 vrany Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libjava_examples_tomcat6.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _ApacheTomcat6_Init();
extern void _stx_137libjava_137examples_137tomcat6_Init();


static vf modules[] = {
    _ApacheTomcat6_Init,
_stx_137libjava_137examples_137tomcat6_Init,

    (vf)0
};

vf *__modules__ = modules;
