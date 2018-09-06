/* $Header: /cvs/stx/stx/libjava/startup/modules.c,v 1.6 2015-03-20 13:29:45 vrany Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libjava_startup.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _JavaStartup_Init();
extern void _stx_137libjava_137startup_Init();


static vf modules[] = {
    _JavaStartup_Init,
_stx_137libjava_137startup_Init,

    (vf)0
};

vf *__modules__ = modules;
