/* $Header: /cvs/stx/stx/libdb/libodbc/applications/modules.c,v 1.2 2007-02-08 16:11:58 stefan Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libdb_libodbc_applications.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _SQL__AdaptableApplicationModel_Init();
extern void _SQL__GetConnectionInformation_Init();
extern void _stx_137libdb_137libodbc_137applications_Init();
extern void _SQL__ODBCResultTable_Init();
extern void _SQL__ODBCResultTableTab_Init();
extern void _SQL__ODBCSQLScratchpad_Init();
extern void _SQL__ODBCScratchpad_Init();
extern void _SQL__ODBCScratchpadTab_Init();


static vf modules[] = {
    _SQL__AdaptableApplicationModel_Init,
_SQL__GetConnectionInformation_Init,
_stx_137libdb_137libodbc_137applications_Init,
_SQL__ODBCResultTable_Init,
_SQL__ODBCResultTableTab_Init,
_SQL__ODBCSQLScratchpad_Init,
_SQL__ODBCScratchpad_Init,
_SQL__ODBCScratchpadTab_Init,

    (vf)0
};

vf *__modules__ = modules;
