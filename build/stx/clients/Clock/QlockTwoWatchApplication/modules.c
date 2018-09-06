/* $Header: /cvs/stx/stx/clients/Clock/QlockTwoWatchApplication/modules.c,v 1.19 2016-04-04 20:31:48 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_clients_Clock_QlockTwoWatchApplication.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _QlockTwoWatch_Init();
extern void _QlockTwoWatchStartup_Init();
extern void _stx_137clients_137Clock_137QlockTwoWatchApplication_Init();


static vf modules[] = {
    _QlockTwoWatch_Init,
_QlockTwoWatchStartup_Init,
_stx_137clients_137Clock_137QlockTwoWatchApplication_Init,

    (vf)0
};

vf *__modules__ = modules;
