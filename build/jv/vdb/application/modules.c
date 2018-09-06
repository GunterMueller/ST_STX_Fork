/* $Header$
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: jv_vdb_application.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _VDBStartup_Init();
extern void _jv_137vdb_137application_Init();


static vf modules[] = {
    _VDBStartup_Init,
_jv_137vdb_137application_Init,

    (vf)0
};

vf *__modules__ = modules;
