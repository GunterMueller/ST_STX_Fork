# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: jv_libgdbs.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=jv
MODULE_DIR=libgdbs
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	GDBArchitecture \
	GDBCommand \
	GDBCommandStatus \
	GDBDebugFlags \
	GDBError \
	GDBEvent \
	GDBEventSet \
	GDBEventSubscription \
	GDBFeatures \
	GDBInstructionDissection \
	GDBInternalPipeStream \
	GDBMAByteArrayDescription \
	GDBMAContainer \
	GDBMADescriptionSwitch \
	GDBMAPropertyAccessor \
	GDBMIPrinter \
	GDBMITrace \
	GDBObject \
	GDBOutputFormat \
	GDBOutputFormats \
	GDBPTY \
	GDBProcess \
	GDBStopReasons \
	GDBThreadGroupType \
	GDBThreadState \
	GDBTransientDataHolder \
	jv_libgdbs \
	GDBArch_unknown \
	GDBArch_x86 \
	GDBAsyncEvent \
	GDBCLICommand \
	GDBCommandEvent \
	GDBCommandFailedError \
	GDBCommandResult \
	GDBCommandResultEvent \
	GDBConnection \
	GDBDebugger \
	GDBDebuggerObject \
	GDBInternalEvent \
	GDBInvalidObjectError \
	GDBMICommand \
	GDBMIParser \
	GDBMITracer \
	GDBMemoryDump \
	GDBMemoryDumpRow \
	GDBStreamOutputEvent \
	GDBThreadGroupTypeProcess \
	GDBThreadInfo \
	GDBThreadStateRunning \
	GDBThreadStateStopped \
	GDBThreadStateTerminated \
	GDBThreadStateUnknown \
	GDBUnixProcess \
	GDBUnsupportedFeatureError \
	GDBWindowsProcess \
	GDBBreakpoint \
	GDBConsoleOutputEvent \
	GDBEventSetEvent \
	GDBExecutionEvent \
	GDBExitEvent \
	GDBFrame \
	GDBInstruction \
	GDBInstructionsAndSourceLine \
	GDBLogOutputEvent \
	GDBMI_ada_task_info \
	GDBMI_add_inferior \
	GDBMI_break_after \
	GDBMI_break_commands \
	GDBMI_break_condition \
	GDBMI_break_delete \
	GDBMI_break_disable \
	GDBMI_break_enable \
	GDBMI_break_info \
	GDBMI_break_insert \
	GDBMI_break_list \
	GDBMI_break_passcount \
	GDBMI_break_watch \
	GDBMI_catch_assert \
	GDBMI_catch_exception \
	GDBMI_catch_load \
	GDBMI_catch_unload \
	GDBMI_data_disassemble \
	GDBMI_data_evaluate_expression \
	GDBMI_data_list_changed_registers \
	GDBMI_data_list_register_names \
	GDBMI_data_list_register_values \
	GDBMI_data_read_memory \
	GDBMI_data_read_memory_bytes \
	GDBMI_data_write_memory \
	GDBMI_data_write_memory_bytes \
	GDBMI_data_write_register_values \
	GDBMI_dprintf_insert \
	GDBMI_enable_frame_filters \
	GDBMI_enable_pretty_printing \
	GDBMI_enable_timings \
	GDBMI_environment_cd \
	GDBMI_environment_directory \
	GDBMI_environment_path \
	GDBMI_environment_pwd \
	GDBMI_exec_arguments \
	GDBMI_exec_continue \
	GDBMI_exec_finish \
	GDBMI_exec_interrupt \
	GDBMI_exec_jump \
	GDBMI_exec_next \
	GDBMI_exec_next_instruction \
	GDBMI_exec_return \
	GDBMI_exec_run \
	GDBMI_exec_step \
	GDBMI_exec_step_instruction \
	GDBMI_exec_until \
	GDBMI_file_exec_and_symbols \
	GDBMI_file_exec_file \
	GDBMI_file_list_exec_source_file \
	GDBMI_file_list_exec_source_files \
	GDBMI_file_symbol_file \
	GDBMI_gdb_exit \
	GDBMI_gdb_set \
	GDBMI_gdb_show \
	GDBMI_gdb_version \
	GDBMI_inferior_tty_set \
	GDBMI_inferior_tty_show \
	GDBMI_info_ada_exceptions \
	GDBMI_info_gdb_mi_command \
	GDBMI_info_os \
	GDBMI_interpreter_exec \
	GDBMI_list_features \
	GDBMI_list_target_features \
	GDBMI_list_thread_groups \
	GDBMI_remove_inferior \
	GDBMI_stack_info_depth \
	GDBMI_stack_info_frame \
	GDBMI_stack_list_arguments \
	GDBMI_stack_list_frames \
	GDBMI_stack_list_locals \
	GDBMI_stack_list_variables \
	GDBMI_stack_select_frame \
	GDBMI_symbol_list_lines \
	GDBMI_target_attach \
	GDBMI_target_detach \
	GDBMI_target_disconnect \
	GDBMI_target_download \
	GDBMI_target_file_delete \
	GDBMI_target_file_get \
	GDBMI_target_file_put \
	GDBMI_target_select \
	GDBMI_thread_info \
	GDBMI_thread_list_ids \
	GDBMI_thread_select \
	GDBMI_trace_define_variable \
	GDBMI_trace_find \
	GDBMI_trace_frame_collected \
	GDBMI_trace_list_variables \
	GDBMI_trace_save \
	GDBMI_trace_start \
	GDBMI_trace_status \
	GDBMI_trace_stop \
	GDBMI_var_assign \
	GDBMI_var_create \
	GDBMI_var_delete \
	GDBMI_var_evaluate_expression \
	GDBMI_var_info_expression \
	GDBMI_var_info_num_children \
	GDBMI_var_info_path_expression \
	GDBMI_var_info_type \
	GDBMI_var_list_children \
	GDBMI_var_set_format \
	GDBMI_var_set_frozen \
	GDBMI_var_set_update_range \
	GDBMI_var_set_visualizer \
	GDBMI_var_show_attributes \
	GDBMI_var_show_format \
	GDBMI_var_update \
	GDBNotificationEvent \
	GDBSelectedFrameChangedEvent \
	GDBStatusEvent \
	GDBTargetOutputEvent \
	GDBThread \
	GDBThreadGroup \
	GDBTransientObject \
	GDBVariable \
	GDBVariableObject \
	GDBVariableObjectChange \
	GDBVariableObjectExecutor \
	GDBBreakpointDeletedEvent \
	GDBBreakpointEvent \
	GDBCmdParamChangedEvent \
	GDBEventSetProcessingFinished \
	GDBEventSetProcessingStarted \
	GDBLibraryLoadedEvent \
	GDBLibraryUnloadedEvent \
	GDBRunningEvent \
	GDBStoppedEvent \
	GDBThreadEvent \
	GDBThreadGroupEvent \
	GDBThreadSelectedEvent \
	GDBBreakpointCreatedEvent \
	GDBBreakpointModifiedEvent \
	GDBThreadCreatedEvent \
	GDBThreadExitedEvent \
	GDBThreadGroupAddedEvent \
	GDBThreadGroupExitedEvent \
	GDBThreadGroupStartedEvent \




COMMON_OBJS= \
    $(OUTDIR)GDBArchitecture.$(O) \
    $(OUTDIR)GDBCommand.$(O) \
    $(OUTDIR)GDBCommandStatus.$(O) \
    $(OUTDIR)GDBDebugFlags.$(O) \
    $(OUTDIR)GDBError.$(O) \
    $(OUTDIR)GDBEvent.$(O) \
    $(OUTDIR)GDBEventSet.$(O) \
    $(OUTDIR)GDBEventSubscription.$(O) \
    $(OUTDIR)GDBFeatures.$(O) \
    $(OUTDIR)GDBInstructionDissection.$(O) \
    $(OUTDIR)GDBInternalPipeStream.$(O) \
    $(OUTDIR)GDBMAByteArrayDescription.$(O) \
    $(OUTDIR)GDBMAContainer.$(O) \
    $(OUTDIR)GDBMADescriptionSwitch.$(O) \
    $(OUTDIR)GDBMAPropertyAccessor.$(O) \
    $(OUTDIR)GDBMIPrinter.$(O) \
    $(OUTDIR)GDBMITrace.$(O) \
    $(OUTDIR)GDBObject.$(O) \
    $(OUTDIR)GDBOutputFormat.$(O) \
    $(OUTDIR)GDBOutputFormats.$(O) \
    $(OUTDIR)GDBPTY.$(O) \
    $(OUTDIR)GDBProcess.$(O) \
    $(OUTDIR)GDBStopReasons.$(O) \
    $(OUTDIR)GDBThreadGroupType.$(O) \
    $(OUTDIR)GDBThreadState.$(O) \
    $(OUTDIR)GDBTransientDataHolder.$(O) \
    $(OUTDIR)jv_libgdbs.$(O) \
    $(OUTDIR)GDBArch_unknown.$(O) \
    $(OUTDIR)GDBArch_x86.$(O) \
    $(OUTDIR)GDBAsyncEvent.$(O) \
    $(OUTDIR)GDBCLICommand.$(O) \
    $(OUTDIR)GDBCommandEvent.$(O) \
    $(OUTDIR)GDBCommandFailedError.$(O) \
    $(OUTDIR)GDBCommandResult.$(O) \
    $(OUTDIR)GDBCommandResultEvent.$(O) \
    $(OUTDIR)GDBConnection.$(O) \
    $(OUTDIR)GDBDebugger.$(O) \
    $(OUTDIR)GDBDebuggerObject.$(O) \
    $(OUTDIR)GDBInternalEvent.$(O) \
    $(OUTDIR)GDBInvalidObjectError.$(O) \
    $(OUTDIR)GDBMICommand.$(O) \
    $(OUTDIR)GDBMIParser.$(O) \
    $(OUTDIR)GDBMITracer.$(O) \
    $(OUTDIR)GDBMemoryDump.$(O) \
    $(OUTDIR)GDBMemoryDumpRow.$(O) \
    $(OUTDIR)GDBStreamOutputEvent.$(O) \
    $(OUTDIR)GDBThreadGroupTypeProcess.$(O) \
    $(OUTDIR)GDBThreadInfo.$(O) \
    $(OUTDIR)GDBThreadStateRunning.$(O) \
    $(OUTDIR)GDBThreadStateStopped.$(O) \
    $(OUTDIR)GDBThreadStateTerminated.$(O) \
    $(OUTDIR)GDBThreadStateUnknown.$(O) \
    $(OUTDIR)GDBUnixProcess.$(O) \
    $(OUTDIR)GDBUnsupportedFeatureError.$(O) \
    $(OUTDIR)GDBWindowsProcess.$(O) \
    $(OUTDIR)GDBBreakpoint.$(O) \
    $(OUTDIR)GDBConsoleOutputEvent.$(O) \
    $(OUTDIR)GDBEventSetEvent.$(O) \
    $(OUTDIR)GDBExecutionEvent.$(O) \
    $(OUTDIR)GDBExitEvent.$(O) \
    $(OUTDIR)GDBFrame.$(O) \
    $(OUTDIR)GDBInstruction.$(O) \
    $(OUTDIR)GDBInstructionsAndSourceLine.$(O) \
    $(OUTDIR)GDBLogOutputEvent.$(O) \
    $(OUTDIR)GDBMI_ada_task_info.$(O) \
    $(OUTDIR)GDBMI_add_inferior.$(O) \
    $(OUTDIR)GDBMI_break_after.$(O) \
    $(OUTDIR)GDBMI_break_commands.$(O) \
    $(OUTDIR)GDBMI_break_condition.$(O) \
    $(OUTDIR)GDBMI_break_delete.$(O) \
    $(OUTDIR)GDBMI_break_disable.$(O) \
    $(OUTDIR)GDBMI_break_enable.$(O) \
    $(OUTDIR)GDBMI_break_info.$(O) \
    $(OUTDIR)GDBMI_break_insert.$(O) \
    $(OUTDIR)GDBMI_break_list.$(O) \
    $(OUTDIR)GDBMI_break_passcount.$(O) \
    $(OUTDIR)GDBMI_break_watch.$(O) \
    $(OUTDIR)GDBMI_catch_assert.$(O) \
    $(OUTDIR)GDBMI_catch_exception.$(O) \
    $(OUTDIR)GDBMI_catch_load.$(O) \
    $(OUTDIR)GDBMI_catch_unload.$(O) \
    $(OUTDIR)GDBMI_data_disassemble.$(O) \
    $(OUTDIR)GDBMI_data_evaluate_expression.$(O) \
    $(OUTDIR)GDBMI_data_list_changed_registers.$(O) \
    $(OUTDIR)GDBMI_data_list_register_names.$(O) \
    $(OUTDIR)GDBMI_data_list_register_values.$(O) \
    $(OUTDIR)GDBMI_data_read_memory.$(O) \
    $(OUTDIR)GDBMI_data_read_memory_bytes.$(O) \
    $(OUTDIR)GDBMI_data_write_memory.$(O) \
    $(OUTDIR)GDBMI_data_write_memory_bytes.$(O) \
    $(OUTDIR)GDBMI_data_write_register_values.$(O) \
    $(OUTDIR)GDBMI_dprintf_insert.$(O) \
    $(OUTDIR)GDBMI_enable_frame_filters.$(O) \
    $(OUTDIR)GDBMI_enable_pretty_printing.$(O) \
    $(OUTDIR)GDBMI_enable_timings.$(O) \
    $(OUTDIR)GDBMI_environment_cd.$(O) \
    $(OUTDIR)GDBMI_environment_directory.$(O) \
    $(OUTDIR)GDBMI_environment_path.$(O) \
    $(OUTDIR)GDBMI_environment_pwd.$(O) \
    $(OUTDIR)GDBMI_exec_arguments.$(O) \
    $(OUTDIR)GDBMI_exec_continue.$(O) \
    $(OUTDIR)GDBMI_exec_finish.$(O) \
    $(OUTDIR)GDBMI_exec_interrupt.$(O) \
    $(OUTDIR)GDBMI_exec_jump.$(O) \
    $(OUTDIR)GDBMI_exec_next.$(O) \
    $(OUTDIR)GDBMI_exec_next_instruction.$(O) \
    $(OUTDIR)GDBMI_exec_return.$(O) \
    $(OUTDIR)GDBMI_exec_run.$(O) \
    $(OUTDIR)GDBMI_exec_step.$(O) \
    $(OUTDIR)GDBMI_exec_step_instruction.$(O) \
    $(OUTDIR)GDBMI_exec_until.$(O) \
    $(OUTDIR)GDBMI_file_exec_and_symbols.$(O) \
    $(OUTDIR)GDBMI_file_exec_file.$(O) \
    $(OUTDIR)GDBMI_file_list_exec_source_file.$(O) \
    $(OUTDIR)GDBMI_file_list_exec_source_files.$(O) \
    $(OUTDIR)GDBMI_file_symbol_file.$(O) \
    $(OUTDIR)GDBMI_gdb_exit.$(O) \
    $(OUTDIR)GDBMI_gdb_set.$(O) \
    $(OUTDIR)GDBMI_gdb_show.$(O) \
    $(OUTDIR)GDBMI_gdb_version.$(O) \
    $(OUTDIR)GDBMI_inferior_tty_set.$(O) \
    $(OUTDIR)GDBMI_inferior_tty_show.$(O) \
    $(OUTDIR)GDBMI_info_ada_exceptions.$(O) \
    $(OUTDIR)GDBMI_info_gdb_mi_command.$(O) \
    $(OUTDIR)GDBMI_info_os.$(O) \
    $(OUTDIR)GDBMI_interpreter_exec.$(O) \
    $(OUTDIR)GDBMI_list_features.$(O) \
    $(OUTDIR)GDBMI_list_target_features.$(O) \
    $(OUTDIR)GDBMI_list_thread_groups.$(O) \
    $(OUTDIR)GDBMI_remove_inferior.$(O) \
    $(OUTDIR)GDBMI_stack_info_depth.$(O) \
    $(OUTDIR)GDBMI_stack_info_frame.$(O) \
    $(OUTDIR)GDBMI_stack_list_arguments.$(O) \
    $(OUTDIR)GDBMI_stack_list_frames.$(O) \
    $(OUTDIR)GDBMI_stack_list_locals.$(O) \
    $(OUTDIR)GDBMI_stack_list_variables.$(O) \
    $(OUTDIR)GDBMI_stack_select_frame.$(O) \
    $(OUTDIR)GDBMI_symbol_list_lines.$(O) \
    $(OUTDIR)GDBMI_target_attach.$(O) \
    $(OUTDIR)GDBMI_target_detach.$(O) \
    $(OUTDIR)GDBMI_target_disconnect.$(O) \
    $(OUTDIR)GDBMI_target_download.$(O) \
    $(OUTDIR)GDBMI_target_file_delete.$(O) \
    $(OUTDIR)GDBMI_target_file_get.$(O) \
    $(OUTDIR)GDBMI_target_file_put.$(O) \
    $(OUTDIR)GDBMI_target_select.$(O) \
    $(OUTDIR)GDBMI_thread_info.$(O) \
    $(OUTDIR)GDBMI_thread_list_ids.$(O) \
    $(OUTDIR)GDBMI_thread_select.$(O) \
    $(OUTDIR)GDBMI_trace_define_variable.$(O) \
    $(OUTDIR)GDBMI_trace_find.$(O) \
    $(OUTDIR)GDBMI_trace_frame_collected.$(O) \
    $(OUTDIR)GDBMI_trace_list_variables.$(O) \
    $(OUTDIR)GDBMI_trace_save.$(O) \
    $(OUTDIR)GDBMI_trace_start.$(O) \
    $(OUTDIR)GDBMI_trace_status.$(O) \
    $(OUTDIR)GDBMI_trace_stop.$(O) \
    $(OUTDIR)GDBMI_var_assign.$(O) \
    $(OUTDIR)GDBMI_var_create.$(O) \
    $(OUTDIR)GDBMI_var_delete.$(O) \
    $(OUTDIR)GDBMI_var_evaluate_expression.$(O) \
    $(OUTDIR)GDBMI_var_info_expression.$(O) \
    $(OUTDIR)GDBMI_var_info_num_children.$(O) \
    $(OUTDIR)GDBMI_var_info_path_expression.$(O) \
    $(OUTDIR)GDBMI_var_info_type.$(O) \
    $(OUTDIR)GDBMI_var_list_children.$(O) \
    $(OUTDIR)GDBMI_var_set_format.$(O) \
    $(OUTDIR)GDBMI_var_set_frozen.$(O) \
    $(OUTDIR)GDBMI_var_set_update_range.$(O) \
    $(OUTDIR)GDBMI_var_set_visualizer.$(O) \
    $(OUTDIR)GDBMI_var_show_attributes.$(O) \
    $(OUTDIR)GDBMI_var_show_format.$(O) \
    $(OUTDIR)GDBMI_var_update.$(O) \
    $(OUTDIR)GDBNotificationEvent.$(O) \
    $(OUTDIR)GDBSelectedFrameChangedEvent.$(O) \
    $(OUTDIR)GDBStatusEvent.$(O) \
    $(OUTDIR)GDBTargetOutputEvent.$(O) \
    $(OUTDIR)GDBThread.$(O) \
    $(OUTDIR)GDBThreadGroup.$(O) \
    $(OUTDIR)GDBTransientObject.$(O) \
    $(OUTDIR)GDBVariable.$(O) \
    $(OUTDIR)GDBVariableObject.$(O) \
    $(OUTDIR)GDBVariableObjectChange.$(O) \
    $(OUTDIR)GDBVariableObjectExecutor.$(O) \
    $(OUTDIR)GDBBreakpointDeletedEvent.$(O) \
    $(OUTDIR)GDBBreakpointEvent.$(O) \
    $(OUTDIR)GDBCmdParamChangedEvent.$(O) \
    $(OUTDIR)GDBEventSetProcessingFinished.$(O) \
    $(OUTDIR)GDBEventSetProcessingStarted.$(O) \
    $(OUTDIR)GDBLibraryLoadedEvent.$(O) \
    $(OUTDIR)GDBLibraryUnloadedEvent.$(O) \
    $(OUTDIR)GDBRunningEvent.$(O) \
    $(OUTDIR)GDBStoppedEvent.$(O) \
    $(OUTDIR)GDBThreadEvent.$(O) \
    $(OUTDIR)GDBThreadGroupEvent.$(O) \
    $(OUTDIR)GDBThreadSelectedEvent.$(O) \
    $(OUTDIR)GDBBreakpointCreatedEvent.$(O) \
    $(OUTDIR)GDBBreakpointModifiedEvent.$(O) \
    $(OUTDIR)GDBThreadCreatedEvent.$(O) \
    $(OUTDIR)GDBThreadExitedEvent.$(O) \
    $(OUTDIR)GDBThreadGroupAddedEvent.$(O) \
    $(OUTDIR)GDBThreadGroupExitedEvent.$(O) \
    $(OUTDIR)GDBThreadGroupStartedEvent.$(O) \
    $(OUTDIR)extensions.$(O) \



