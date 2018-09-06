"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#jv_libgdbs
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!jv_libgdbs class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!jv_libgdbs class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:goodies/announcements'    "Announcement - superclass of GDBAsyncEvent"
        #'stx:goodies/magritte'    "Magritte::MAAccessor - superclass of GDBMAPropertyAccessor"
        #'stx:libbasic'    "ArrayedCollection - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libbasic2'    "CacheDictionary - referenced by GDBInstructionsAndSourceLine class>>initialize"
        #'stx:libtool'    "Tools::Inspector2Tab - referenced by GDBBreakpoint>>inspector2TabCondition"
        #'stx:libview2'    "ApplicationModel - referenced by GDBEventSubscription class>>blockFor:withSelector:"
        #'stx:libwidg'    "EditTextView - referenced by GDBBreakpoint>>inspector2TabCondition"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!jv_libgdbs class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        GDBArchitecture
        GDBCommand
        GDBCommandStatus
        GDBDebugFlags
        GDBError
        GDBEvent
        GDBEventSet
        GDBEventSubscription
        GDBFeatures
        GDBInstructionDissection
        GDBInternalPipeStream
        GDBMAByteArrayDescription
        GDBMAContainer
        GDBMADescriptionSwitch
        GDBMAPropertyAccessor
        GDBMIPrinter
        GDBMITrace
        GDBObject
        GDBOutputFormat
        GDBOutputFormats
        GDBPTY
        GDBProcess
        GDBStopReasons
        GDBThreadGroupType
        GDBThreadState
        GDBTransientDataHolder
        #'jv_libgdbs'
        #'GDBArch_unknown'
        #'GDBArch_x86'
        GDBAsyncEvent
        GDBCLICommand
        GDBCommandEvent
        GDBCommandFailedError
        GDBCommandResult
        GDBCommandResultEvent
        GDBConnection
        GDBDebugger
        GDBDebuggerObject
        GDBInternalEvent
        GDBInvalidObjectError
        GDBMICommand
        GDBMIParser
        GDBMITracer
        GDBMemoryDump
        GDBMemoryDumpRow
        GDBStreamOutputEvent
        GDBThreadGroupTypeProcess
        GDBThreadInfo
        GDBThreadStateRunning
        GDBThreadStateStopped
        GDBThreadStateTerminated
        GDBThreadStateUnknown
        GDBUnixProcess
        GDBUnsupportedFeatureError
        GDBWindowsProcess
        GDBBreakpoint
        GDBConsoleOutputEvent
        GDBEventSetEvent
        GDBExecutionEvent
        GDBExitEvent
        GDBFrame
        GDBInstruction
        GDBInstructionsAndSourceLine
        GDBLogOutputEvent
        #'GDBMI_ada_task_info'
        #'GDBMI_add_inferior'
        #'GDBMI_break_after'
        #'GDBMI_break_commands'
        #'GDBMI_break_condition'
        #'GDBMI_break_delete'
        #'GDBMI_break_disable'
        #'GDBMI_break_enable'
        #'GDBMI_break_info'
        #'GDBMI_break_insert'
        #'GDBMI_break_list'
        #'GDBMI_break_passcount'
        #'GDBMI_break_watch'
        #'GDBMI_catch_assert'
        #'GDBMI_catch_exception'
        #'GDBMI_catch_load'
        #'GDBMI_catch_unload'
        #'GDBMI_data_disassemble'
        #'GDBMI_data_evaluate_expression'
        #'GDBMI_data_list_changed_registers'
        #'GDBMI_data_list_register_names'
        #'GDBMI_data_list_register_values'
        #'GDBMI_data_read_memory'
        #'GDBMI_data_read_memory_bytes'
        #'GDBMI_data_write_memory'
        #'GDBMI_data_write_memory_bytes'
        #'GDBMI_data_write_register_values'
        #'GDBMI_dprintf_insert'
        #'GDBMI_enable_frame_filters'
        #'GDBMI_enable_pretty_printing'
        #'GDBMI_enable_timings'
        #'GDBMI_environment_cd'
        #'GDBMI_environment_directory'
        #'GDBMI_environment_path'
        #'GDBMI_environment_pwd'
        #'GDBMI_exec_arguments'
        #'GDBMI_exec_continue'
        #'GDBMI_exec_finish'
        #'GDBMI_exec_interrupt'
        #'GDBMI_exec_jump'
        #'GDBMI_exec_next'
        #'GDBMI_exec_next_instruction'
        #'GDBMI_exec_return'
        #'GDBMI_exec_run'
        #'GDBMI_exec_step'
        #'GDBMI_exec_step_instruction'
        #'GDBMI_exec_until'
        #'GDBMI_file_exec_and_symbols'
        #'GDBMI_file_exec_file'
        #'GDBMI_file_list_exec_source_file'
        #'GDBMI_file_list_exec_source_files'
        #'GDBMI_file_symbol_file'
        #'GDBMI_gdb_exit'
        #'GDBMI_gdb_set'
        #'GDBMI_gdb_show'
        #'GDBMI_gdb_version'
        #'GDBMI_inferior_tty_set'
        #'GDBMI_inferior_tty_show'
        #'GDBMI_info_ada_exceptions'
        #'GDBMI_info_gdb_mi_command'
        #'GDBMI_info_os'
        #'GDBMI_interpreter_exec'
        #'GDBMI_list_features'
        #'GDBMI_list_target_features'
        #'GDBMI_list_thread_groups'
        #'GDBMI_remove_inferior'
        #'GDBMI_stack_info_depth'
        #'GDBMI_stack_info_frame'
        #'GDBMI_stack_list_arguments'
        #'GDBMI_stack_list_frames'
        #'GDBMI_stack_list_locals'
        #'GDBMI_stack_list_variables'
        #'GDBMI_stack_select_frame'
        #'GDBMI_symbol_list_lines'
        #'GDBMI_target_attach'
        #'GDBMI_target_detach'
        #'GDBMI_target_disconnect'
        #'GDBMI_target_download'
        #'GDBMI_target_file_delete'
        #'GDBMI_target_file_get'
        #'GDBMI_target_file_put'
        #'GDBMI_target_select'
        #'GDBMI_thread_info'
        #'GDBMI_thread_list_ids'
        #'GDBMI_thread_select'
        #'GDBMI_trace_define_variable'
        #'GDBMI_trace_find'
        #'GDBMI_trace_frame_collected'
        #'GDBMI_trace_list_variables'
        #'GDBMI_trace_save'
        #'GDBMI_trace_start'
        #'GDBMI_trace_status'
        #'GDBMI_trace_stop'
        #'GDBMI_var_assign'
        #'GDBMI_var_create'
        #'GDBMI_var_delete'
        #'GDBMI_var_evaluate_expression'
        #'GDBMI_var_info_expression'
        #'GDBMI_var_info_num_children'
        #'GDBMI_var_info_path_expression'
        #'GDBMI_var_info_type'
        #'GDBMI_var_list_children'
        #'GDBMI_var_set_format'
        #'GDBMI_var_set_frozen'
        #'GDBMI_var_set_update_range'
        #'GDBMI_var_set_visualizer'
        #'GDBMI_var_show_attributes'
        #'GDBMI_var_show_format'
        #'GDBMI_var_update'
        GDBNotificationEvent
        GDBSelectedFrameChangedEvent
        GDBStatusEvent
        GDBTargetOutputEvent
        GDBThread
        GDBThreadGroup
        GDBTransientObject
        GDBVariable
        GDBVariableObject
        GDBVariableObjectChange
        GDBVariableObjectExecutor
        GDBBreakpointDeletedEvent
        GDBBreakpointEvent
        GDBCmdParamChangedEvent
        GDBEventSetProcessingFinished
        GDBEventSetProcessingStarted
        GDBLibraryLoadedEvent
        GDBLibraryUnloadedEvent
        GDBRunningEvent
        GDBStoppedEvent
        GDBThreadEvent
        GDBThreadGroupEvent
        GDBThreadSelectedEvent
        GDBBreakpointCreatedEvent
        GDBBreakpointModifiedEvent
        GDBThreadCreatedEvent
        GDBThreadExitedEvent
        GDBThreadGroupAddedEvent
        GDBThreadGroupExitedEvent
        GDBThreadGroupStartedEvent
        (GDBMITraceViewer autoload)
        (GDBSimulatorResource autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        #'Magritte::MABooleanDescription' parseUsingGDBMIParser:
        #'Magritte::MADescription' parseUsingGDBMIParser:
        #'Magritte::MANumberDescription' parseUsingGDBMIParser:
        #'Magritte::MAStringDescription' parseUsingGDBMIParser:
        #'Magritte::MAToManyRelationDescription' parseUsingGDBMIParser:
        #'Magritte::MASingleOptionDescription' parseUsingGDBMIParser:
        #'Magritte::MAToManyRelationDescription' allowOmmitedBrackets
        #'Magritte::MAToManyRelationDescription' allowOmmitedBrackets:
        'Magritte::MAToManyRelationDescription class' defaultAllowOmmitedBrackets
        SubscriptionCollection value:
        Filename cygName
        'Filename class' cygNamed:
        ByteArray pythonOn:
        ByteArray pythonString
        #'Magritte::MADescription' parseUsingGDBMIParser:taggedAs:
    )
! !

!jv_libgdbs class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Jan Vrany'

    "Modified: / 23-11-2017 / 22:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'GNU Debugger Interface Library'

    "Modified: / 23-11-2017 / 22:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright (C) Jan Vrany 2015-now'

    "Modified (format): / 23-11-2017 / 22:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ self description

    "Modified: / 23-11-2017 / 22:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_libgdbs class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

