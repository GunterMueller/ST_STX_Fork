"{ Package: 'stx:libcomp' }"!

!Object methodsFor:'user interaction & notifications'!

notifyTodo:msg position:position
         className:className selector:selector
         severity:severityOrSeveritySymbol priority:priorityOrPrioritySymbol
         equalityParameter:equalityParameter checkAction:checkAction

    "this is a message from the compiler system, to allow for a hook to remember
     things to do. Can aslo used by other subsystems to add entries to the toDoList"

    (Tools::CompilerWarningToDoListEntry notNil
    and:[Tools::CompilerWarningToDoListEntry isLoaded]) ifFalse:[^ self ].

    Tools::CompilerWarningToDoListEntry
        notifyTodo:msg position:position
        className:className selector:selector
        severity:severityOrSeveritySymbol priority:priorityOrPrioritySymbol
        equalityParameter:equalityParameter checkAction:checkAction

    "Modified: / 15-03-2007 / 20:29:23 / cg"
! !

!stx_libcomp class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
