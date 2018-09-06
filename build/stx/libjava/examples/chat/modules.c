/* $Header: /cvs/stx/stx/libjava/examples/chat/modules.c,v 1.2 2015-03-20 12:08:02 vrany Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libjava_examples_chat.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _Chat_Init();
extern void _ChatStart_Init();
extern void _ChatWindow_Init();
extern void _stx_137libjava_137examples_137chat_Init();


static vf modules[] = {
    _Chat_Init,
_ChatStart_Init,
_ChatWindow_Init,
_stx_137libjava_137examples_137chat_Init,

    (vf)0
};

vf *__modules__ = modules;
