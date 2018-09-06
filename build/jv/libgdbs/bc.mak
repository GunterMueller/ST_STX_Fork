# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: jv_libgdbs.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\stx
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libjv_libgdbs
MODULE_PATH=libgdbs
RESFILES=jv_libgdbsWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\announcements -I$(INCLUDE_TOP)\stx\goodies\magritte -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\stx\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\goodies\announcements & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\goodies\magritte & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)GDBArchitecture.$(O) GDBArchitecture.$(C) GDBArchitecture.$(H): GDBArchitecture.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommand.$(O) GDBCommand.$(C) GDBCommand.$(H): GDBCommand.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommandStatus.$(O) GDBCommandStatus.$(C) GDBCommandStatus.$(H): GDBCommandStatus.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)GDBDebugFlags.$(O) GDBDebugFlags.$(C) GDBDebugFlags.$(H): GDBDebugFlags.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)GDBError.$(O) GDBError.$(C) GDBError.$(H): GDBError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBEvent.$(O) GDBEvent.$(C) GDBEvent.$(H): GDBEvent.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBEventSet.$(O) GDBEventSet.$(C) GDBEventSet.$(H): GDBEventSet.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)GDBEventSubscription.$(O) GDBEventSubscription.$(C) GDBEventSubscription.$(H): GDBEventSubscription.st $(INCLUDE_TOP)\stx\goodies\announcements\StrongSubscription.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Subscription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBFeatures.$(O) GDBFeatures.$(C) GDBFeatures.$(H): GDBFeatures.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)GDBInstructionDissection.$(O) GDBInstructionDissection.$(C) GDBInstructionDissection.$(H): GDBInstructionDissection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBInternalPipeStream.$(O) GDBInternalPipeStream.$(C) GDBInternalPipeStream.$(H): GDBInternalPipeStream.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)GDBMAByteArrayDescription.$(O) GDBMAByteArrayDescription.$(C) GDBMAByteArrayDescription.$(H): GDBMAByteArrayDescription.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMAContainer.$(O) GDBMAContainer.$(C) GDBMAContainer.$(H): GDBMAContainer.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAContainer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMADescriptionSwitch.$(O) GDBMADescriptionSwitch.$(C) GDBMADescriptionSwitch.$(H): GDBMADescriptionSwitch.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMAPropertyAccessor.$(O) GDBMAPropertyAccessor.$(C) GDBMAPropertyAccessor.$(H): GDBMAPropertyAccessor.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAAccessor.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMIPrinter.$(O) GDBMIPrinter.$(C) GDBMIPrinter.$(H): GDBMIPrinter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMITrace.$(O) GDBMITrace.$(C) GDBMITrace.$(H): GDBMITrace.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)GDBObject.$(O) GDBObject.$(C) GDBObject.$(H): GDBObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBOutputFormat.$(O) GDBOutputFormat.$(C) GDBOutputFormat.$(H): GDBOutputFormat.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBOutputFormats.$(O) GDBOutputFormats.$(C) GDBOutputFormats.$(H): GDBOutputFormats.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)GDBPTY.$(O) GDBPTY.$(C) GDBPTY.$(H): GDBPTY.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\TTYConstants.$(H) $(STCHDR)
$(OUTDIR)GDBProcess.$(O) GDBProcess.$(C) GDBProcess.$(H): GDBProcess.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBStopReasons.$(O) GDBStopReasons.$(C) GDBStopReasons.$(H): GDBStopReasons.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupType.$(O) GDBThreadGroupType.$(C) GDBThreadGroupType.$(H): GDBThreadGroupType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadState.$(O) GDBThreadState.$(C) GDBThreadState.$(H): GDBThreadState.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBTransientDataHolder.$(O) GDBTransientDataHolder.$(C) GDBTransientDataHolder.$(H): GDBTransientDataHolder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)jv_libgdbs.$(O) jv_libgdbs.$(C) jv_libgdbs.$(H): jv_libgdbs.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)GDBArch_unknown.$(O) GDBArch_unknown.$(C) GDBArch_unknown.$(H): GDBArch_unknown.st $(INCLUDE_TOP)\jv\libgdbs\GDBArchitecture.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBArch_x86.$(O) GDBArch_x86.$(C) GDBArch_x86.$(H): GDBArch_x86.st $(INCLUDE_TOP)\jv\libgdbs\GDBArchitecture.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBAsyncEvent.$(O) GDBAsyncEvent.$(C) GDBAsyncEvent.$(H): GDBAsyncEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCLICommand.$(O) GDBCLICommand.$(C) GDBCLICommand.$(H): GDBCLICommand.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommandEvent.$(O) GDBCommandEvent.$(C) GDBCommandEvent.$(H): GDBCommandEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommandFailedError.$(O) GDBCommandFailedError.$(C) GDBCommandFailedError.$(H): GDBCommandFailedError.st $(INCLUDE_TOP)\jv\libgdbs\GDBError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommandResult.$(O) GDBCommandResult.$(C) GDBCommandResult.$(H): GDBCommandResult.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommandStatus.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCommandResultEvent.$(O) GDBCommandResultEvent.$(C) GDBCommandResultEvent.$(H): GDBCommandResultEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBConnection.$(O) GDBConnection.$(C) GDBConnection.$(H): GDBConnection.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebugFlags.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBDebugger.$(O) GDBDebugger.$(C) GDBDebugger.$(H): GDBDebugger.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommandStatus.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBFeatures.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBDebuggerObject.$(O) GDBDebuggerObject.$(C) GDBDebuggerObject.$(H): GDBDebuggerObject.st $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBInternalEvent.$(O) GDBInternalEvent.$(C) GDBInternalEvent.$(H): GDBInternalEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBInvalidObjectError.$(O) GDBInvalidObjectError.$(C) GDBInvalidObjectError.$(H): GDBInvalidObjectError.st $(INCLUDE_TOP)\jv\libgdbs\GDBError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMICommand.$(O) GDBMICommand.$(C) GDBMICommand.$(H): GDBMICommand.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMIParser.$(O) GDBMIParser.$(C) GDBMIParser.$(H): GDBMIParser.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommandStatus.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMITracer.$(O) GDBMITracer.$(C) GDBMITracer.$(H): GDBMITracer.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebugFlags.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMemoryDump.$(O) GDBMemoryDump.$(C) GDBMemoryDump.$(H): GDBMemoryDump.st $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMemoryDumpRow.$(O) GDBMemoryDumpRow.$(C) GDBMemoryDumpRow.$(H): GDBMemoryDumpRow.st $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBStreamOutputEvent.$(O) GDBStreamOutputEvent.$(C) GDBStreamOutputEvent.$(H): GDBStreamOutputEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupTypeProcess.$(O) GDBThreadGroupTypeProcess.$(C) GDBThreadGroupTypeProcess.$(H): GDBThreadGroupTypeProcess.st $(INCLUDE_TOP)\jv\libgdbs\GDBThreadGroupType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadInfo.$(O) GDBThreadInfo.$(C) GDBThreadInfo.$(H): GDBThreadInfo.st $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadStateRunning.$(O) GDBThreadStateRunning.$(C) GDBThreadStateRunning.$(H): GDBThreadStateRunning.st $(INCLUDE_TOP)\jv\libgdbs\GDBThreadState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadStateStopped.$(O) GDBThreadStateStopped.$(C) GDBThreadStateStopped.$(H): GDBThreadStateStopped.st $(INCLUDE_TOP)\jv\libgdbs\GDBThreadState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadStateTerminated.$(O) GDBThreadStateTerminated.$(C) GDBThreadStateTerminated.$(H): GDBThreadStateTerminated.st $(INCLUDE_TOP)\jv\libgdbs\GDBThreadState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadStateUnknown.$(O) GDBThreadStateUnknown.$(C) GDBThreadStateUnknown.$(H): GDBThreadStateUnknown.st $(INCLUDE_TOP)\jv\libgdbs\GDBThreadState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBUnixProcess.$(O) GDBUnixProcess.$(C) GDBUnixProcess.$(H): GDBUnixProcess.st $(INCLUDE_TOP)\jv\libgdbs\GDBProcess.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBUnsupportedFeatureError.$(O) GDBUnsupportedFeatureError.$(C) GDBUnsupportedFeatureError.$(H): GDBUnsupportedFeatureError.st $(INCLUDE_TOP)\jv\libgdbs\GDBError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBWindowsProcess.$(O) GDBWindowsProcess.$(C) GDBWindowsProcess.$(H): GDBWindowsProcess.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebugFlags.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBProcess.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBBreakpoint.$(O) GDBBreakpoint.$(C) GDBBreakpoint.$(H): GDBBreakpoint.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBConsoleOutputEvent.$(O) GDBConsoleOutputEvent.$(C) GDBConsoleOutputEvent.$(H): GDBConsoleOutputEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBStreamOutputEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBEventSetEvent.$(O) GDBEventSetEvent.$(C) GDBEventSetEvent.$(H): GDBEventSetEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBInternalEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBExecutionEvent.$(O) GDBExecutionEvent.$(C) GDBExecutionEvent.$(H): GDBExecutionEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBExitEvent.$(O) GDBExitEvent.$(C) GDBExitEvent.$(H): GDBExitEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBInternalEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBFrame.$(O) GDBFrame.$(C) GDBFrame.$(H): GDBFrame.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBInstruction.$(O) GDBInstruction.$(C) GDBInstruction.$(H): GDBInstruction.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBInstructionsAndSourceLine.$(O) GDBInstructionsAndSourceLine.$(C) GDBInstructionsAndSourceLine.$(H): GDBInstructionsAndSourceLine.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBLogOutputEvent.$(O) GDBLogOutputEvent.$(C) GDBLogOutputEvent.$(H): GDBLogOutputEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBStreamOutputEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_ada_task_info.$(O) GDBMI_ada_task_info.$(C) GDBMI_ada_task_info.$(H): GDBMI_ada_task_info.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_add_inferior.$(O) GDBMI_add_inferior.$(C) GDBMI_add_inferior.$(H): GDBMI_add_inferior.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_after.$(O) GDBMI_break_after.$(C) GDBMI_break_after.$(H): GDBMI_break_after.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_commands.$(O) GDBMI_break_commands.$(C) GDBMI_break_commands.$(H): GDBMI_break_commands.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_condition.$(O) GDBMI_break_condition.$(C) GDBMI_break_condition.$(H): GDBMI_break_condition.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_delete.$(O) GDBMI_break_delete.$(C) GDBMI_break_delete.$(H): GDBMI_break_delete.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_disable.$(O) GDBMI_break_disable.$(C) GDBMI_break_disable.$(H): GDBMI_break_disable.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_enable.$(O) GDBMI_break_enable.$(C) GDBMI_break_enable.$(H): GDBMI_break_enable.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_info.$(O) GDBMI_break_info.$(C) GDBMI_break_info.$(H): GDBMI_break_info.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_insert.$(O) GDBMI_break_insert.$(C) GDBMI_break_insert.$(H): GDBMI_break_insert.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_list.$(O) GDBMI_break_list.$(C) GDBMI_break_list.$(H): GDBMI_break_list.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_passcount.$(O) GDBMI_break_passcount.$(C) GDBMI_break_passcount.$(H): GDBMI_break_passcount.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_break_watch.$(O) GDBMI_break_watch.$(C) GDBMI_break_watch.$(H): GDBMI_break_watch.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_catch_assert.$(O) GDBMI_catch_assert.$(C) GDBMI_catch_assert.$(H): GDBMI_catch_assert.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_catch_exception.$(O) GDBMI_catch_exception.$(C) GDBMI_catch_exception.$(H): GDBMI_catch_exception.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_catch_load.$(O) GDBMI_catch_load.$(C) GDBMI_catch_load.$(H): GDBMI_catch_load.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_catch_unload.$(O) GDBMI_catch_unload.$(C) GDBMI_catch_unload.$(H): GDBMI_catch_unload.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_disassemble.$(O) GDBMI_data_disassemble.$(C) GDBMI_data_disassemble.$(H): GDBMI_data_disassemble.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_evaluate_expression.$(O) GDBMI_data_evaluate_expression.$(C) GDBMI_data_evaluate_expression.$(H): GDBMI_data_evaluate_expression.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_list_changed_registers.$(O) GDBMI_data_list_changed_registers.$(C) GDBMI_data_list_changed_registers.$(H): GDBMI_data_list_changed_registers.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_list_register_names.$(O) GDBMI_data_list_register_names.$(C) GDBMI_data_list_register_names.$(H): GDBMI_data_list_register_names.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_list_register_values.$(O) GDBMI_data_list_register_values.$(C) GDBMI_data_list_register_values.$(H): GDBMI_data_list_register_values.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_read_memory.$(O) GDBMI_data_read_memory.$(C) GDBMI_data_read_memory.$(H): GDBMI_data_read_memory.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_read_memory_bytes.$(O) GDBMI_data_read_memory_bytes.$(C) GDBMI_data_read_memory_bytes.$(H): GDBMI_data_read_memory_bytes.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_write_memory.$(O) GDBMI_data_write_memory.$(C) GDBMI_data_write_memory.$(H): GDBMI_data_write_memory.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_write_memory_bytes.$(O) GDBMI_data_write_memory_bytes.$(C) GDBMI_data_write_memory_bytes.$(H): GDBMI_data_write_memory_bytes.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_data_write_register_values.$(O) GDBMI_data_write_register_values.$(C) GDBMI_data_write_register_values.$(H): GDBMI_data_write_register_values.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_dprintf_insert.$(O) GDBMI_dprintf_insert.$(C) GDBMI_dprintf_insert.$(H): GDBMI_dprintf_insert.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_enable_frame_filters.$(O) GDBMI_enable_frame_filters.$(C) GDBMI_enable_frame_filters.$(H): GDBMI_enable_frame_filters.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_enable_pretty_printing.$(O) GDBMI_enable_pretty_printing.$(C) GDBMI_enable_pretty_printing.$(H): GDBMI_enable_pretty_printing.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_enable_timings.$(O) GDBMI_enable_timings.$(C) GDBMI_enable_timings.$(H): GDBMI_enable_timings.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_environment_cd.$(O) GDBMI_environment_cd.$(C) GDBMI_environment_cd.$(H): GDBMI_environment_cd.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_environment_directory.$(O) GDBMI_environment_directory.$(C) GDBMI_environment_directory.$(H): GDBMI_environment_directory.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_environment_path.$(O) GDBMI_environment_path.$(C) GDBMI_environment_path.$(H): GDBMI_environment_path.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_environment_pwd.$(O) GDBMI_environment_pwd.$(C) GDBMI_environment_pwd.$(H): GDBMI_environment_pwd.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_arguments.$(O) GDBMI_exec_arguments.$(C) GDBMI_exec_arguments.$(H): GDBMI_exec_arguments.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_continue.$(O) GDBMI_exec_continue.$(C) GDBMI_exec_continue.$(H): GDBMI_exec_continue.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_finish.$(O) GDBMI_exec_finish.$(C) GDBMI_exec_finish.$(H): GDBMI_exec_finish.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_interrupt.$(O) GDBMI_exec_interrupt.$(C) GDBMI_exec_interrupt.$(H): GDBMI_exec_interrupt.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_jump.$(O) GDBMI_exec_jump.$(C) GDBMI_exec_jump.$(H): GDBMI_exec_jump.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_next.$(O) GDBMI_exec_next.$(C) GDBMI_exec_next.$(H): GDBMI_exec_next.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_next_instruction.$(O) GDBMI_exec_next_instruction.$(C) GDBMI_exec_next_instruction.$(H): GDBMI_exec_next_instruction.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_return.$(O) GDBMI_exec_return.$(C) GDBMI_exec_return.$(H): GDBMI_exec_return.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_run.$(O) GDBMI_exec_run.$(C) GDBMI_exec_run.$(H): GDBMI_exec_run.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_step.$(O) GDBMI_exec_step.$(C) GDBMI_exec_step.$(H): GDBMI_exec_step.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_step_instruction.$(O) GDBMI_exec_step_instruction.$(C) GDBMI_exec_step_instruction.$(H): GDBMI_exec_step_instruction.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_exec_until.$(O) GDBMI_exec_until.$(C) GDBMI_exec_until.$(H): GDBMI_exec_until.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_file_exec_and_symbols.$(O) GDBMI_file_exec_and_symbols.$(C) GDBMI_file_exec_and_symbols.$(H): GDBMI_file_exec_and_symbols.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_file_exec_file.$(O) GDBMI_file_exec_file.$(C) GDBMI_file_exec_file.$(H): GDBMI_file_exec_file.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_file_list_exec_source_file.$(O) GDBMI_file_list_exec_source_file.$(C) GDBMI_file_list_exec_source_file.$(H): GDBMI_file_list_exec_source_file.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_file_list_exec_source_files.$(O) GDBMI_file_list_exec_source_files.$(C) GDBMI_file_list_exec_source_files.$(H): GDBMI_file_list_exec_source_files.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_file_symbol_file.$(O) GDBMI_file_symbol_file.$(C) GDBMI_file_symbol_file.$(H): GDBMI_file_symbol_file.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_gdb_exit.$(O) GDBMI_gdb_exit.$(C) GDBMI_gdb_exit.$(H): GDBMI_gdb_exit.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_gdb_set.$(O) GDBMI_gdb_set.$(C) GDBMI_gdb_set.$(H): GDBMI_gdb_set.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_gdb_show.$(O) GDBMI_gdb_show.$(C) GDBMI_gdb_show.$(H): GDBMI_gdb_show.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_gdb_version.$(O) GDBMI_gdb_version.$(C) GDBMI_gdb_version.$(H): GDBMI_gdb_version.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_inferior_tty_set.$(O) GDBMI_inferior_tty_set.$(C) GDBMI_inferior_tty_set.$(H): GDBMI_inferior_tty_set.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_inferior_tty_show.$(O) GDBMI_inferior_tty_show.$(C) GDBMI_inferior_tty_show.$(H): GDBMI_inferior_tty_show.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_info_ada_exceptions.$(O) GDBMI_info_ada_exceptions.$(C) GDBMI_info_ada_exceptions.$(H): GDBMI_info_ada_exceptions.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_info_gdb_mi_command.$(O) GDBMI_info_gdb_mi_command.$(C) GDBMI_info_gdb_mi_command.$(H): GDBMI_info_gdb_mi_command.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_info_os.$(O) GDBMI_info_os.$(C) GDBMI_info_os.$(H): GDBMI_info_os.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_interpreter_exec.$(O) GDBMI_interpreter_exec.$(C) GDBMI_interpreter_exec.$(H): GDBMI_interpreter_exec.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_list_features.$(O) GDBMI_list_features.$(C) GDBMI_list_features.$(H): GDBMI_list_features.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_list_target_features.$(O) GDBMI_list_target_features.$(C) GDBMI_list_target_features.$(H): GDBMI_list_target_features.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_list_thread_groups.$(O) GDBMI_list_thread_groups.$(C) GDBMI_list_thread_groups.$(H): GDBMI_list_thread_groups.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_remove_inferior.$(O) GDBMI_remove_inferior.$(C) GDBMI_remove_inferior.$(H): GDBMI_remove_inferior.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_info_depth.$(O) GDBMI_stack_info_depth.$(C) GDBMI_stack_info_depth.$(H): GDBMI_stack_info_depth.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_info_frame.$(O) GDBMI_stack_info_frame.$(C) GDBMI_stack_info_frame.$(H): GDBMI_stack_info_frame.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_list_arguments.$(O) GDBMI_stack_list_arguments.$(C) GDBMI_stack_list_arguments.$(H): GDBMI_stack_list_arguments.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_list_frames.$(O) GDBMI_stack_list_frames.$(C) GDBMI_stack_list_frames.$(H): GDBMI_stack_list_frames.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_list_locals.$(O) GDBMI_stack_list_locals.$(C) GDBMI_stack_list_locals.$(H): GDBMI_stack_list_locals.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_list_variables.$(O) GDBMI_stack_list_variables.$(C) GDBMI_stack_list_variables.$(H): GDBMI_stack_list_variables.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_stack_select_frame.$(O) GDBMI_stack_select_frame.$(C) GDBMI_stack_select_frame.$(H): GDBMI_stack_select_frame.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_symbol_list_lines.$(O) GDBMI_symbol_list_lines.$(C) GDBMI_symbol_list_lines.$(H): GDBMI_symbol_list_lines.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_attach.$(O) GDBMI_target_attach.$(C) GDBMI_target_attach.$(H): GDBMI_target_attach.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_detach.$(O) GDBMI_target_detach.$(C) GDBMI_target_detach.$(H): GDBMI_target_detach.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_disconnect.$(O) GDBMI_target_disconnect.$(C) GDBMI_target_disconnect.$(H): GDBMI_target_disconnect.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_download.$(O) GDBMI_target_download.$(C) GDBMI_target_download.$(H): GDBMI_target_download.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_file_delete.$(O) GDBMI_target_file_delete.$(C) GDBMI_target_file_delete.$(H): GDBMI_target_file_delete.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_file_get.$(O) GDBMI_target_file_get.$(C) GDBMI_target_file_get.$(H): GDBMI_target_file_get.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_file_put.$(O) GDBMI_target_file_put.$(C) GDBMI_target_file_put.$(H): GDBMI_target_file_put.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_target_select.$(O) GDBMI_target_select.$(C) GDBMI_target_select.$(H): GDBMI_target_select.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_thread_info.$(O) GDBMI_thread_info.$(C) GDBMI_thread_info.$(H): GDBMI_thread_info.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_thread_list_ids.$(O) GDBMI_thread_list_ids.$(C) GDBMI_thread_list_ids.$(H): GDBMI_thread_list_ids.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_thread_select.$(O) GDBMI_thread_select.$(C) GDBMI_thread_select.$(H): GDBMI_thread_select.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_define_variable.$(O) GDBMI_trace_define_variable.$(C) GDBMI_trace_define_variable.$(H): GDBMI_trace_define_variable.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_find.$(O) GDBMI_trace_find.$(C) GDBMI_trace_find.$(H): GDBMI_trace_find.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_frame_collected.$(O) GDBMI_trace_frame_collected.$(C) GDBMI_trace_frame_collected.$(H): GDBMI_trace_frame_collected.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_list_variables.$(O) GDBMI_trace_list_variables.$(C) GDBMI_trace_list_variables.$(H): GDBMI_trace_list_variables.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_save.$(O) GDBMI_trace_save.$(C) GDBMI_trace_save.$(H): GDBMI_trace_save.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_start.$(O) GDBMI_trace_start.$(C) GDBMI_trace_start.$(H): GDBMI_trace_start.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_status.$(O) GDBMI_trace_status.$(C) GDBMI_trace_status.$(H): GDBMI_trace_status.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_trace_stop.$(O) GDBMI_trace_stop.$(C) GDBMI_trace_stop.$(H): GDBMI_trace_stop.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_assign.$(O) GDBMI_var_assign.$(C) GDBMI_var_assign.$(H): GDBMI_var_assign.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_create.$(O) GDBMI_var_create.$(C) GDBMI_var_create.$(H): GDBMI_var_create.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_delete.$(O) GDBMI_var_delete.$(C) GDBMI_var_delete.$(H): GDBMI_var_delete.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_evaluate_expression.$(O) GDBMI_var_evaluate_expression.$(C) GDBMI_var_evaluate_expression.$(H): GDBMI_var_evaluate_expression.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_info_expression.$(O) GDBMI_var_info_expression.$(C) GDBMI_var_info_expression.$(H): GDBMI_var_info_expression.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_info_num_children.$(O) GDBMI_var_info_num_children.$(C) GDBMI_var_info_num_children.$(H): GDBMI_var_info_num_children.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_info_path_expression.$(O) GDBMI_var_info_path_expression.$(C) GDBMI_var_info_path_expression.$(H): GDBMI_var_info_path_expression.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_info_type.$(O) GDBMI_var_info_type.$(C) GDBMI_var_info_type.$(H): GDBMI_var_info_type.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_list_children.$(O) GDBMI_var_list_children.$(C) GDBMI_var_list_children.$(H): GDBMI_var_list_children.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_set_format.$(O) GDBMI_var_set_format.$(C) GDBMI_var_set_format.$(H): GDBMI_var_set_format.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_set_frozen.$(O) GDBMI_var_set_frozen.$(C) GDBMI_var_set_frozen.$(H): GDBMI_var_set_frozen.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_set_update_range.$(O) GDBMI_var_set_update_range.$(C) GDBMI_var_set_update_range.$(H): GDBMI_var_set_update_range.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_set_visualizer.$(O) GDBMI_var_set_visualizer.$(C) GDBMI_var_set_visualizer.$(H): GDBMI_var_set_visualizer.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_show_attributes.$(O) GDBMI_var_show_attributes.$(C) GDBMI_var_show_attributes.$(H): GDBMI_var_show_attributes.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_show_format.$(O) GDBMI_var_show_format.$(C) GDBMI_var_show_format.$(H): GDBMI_var_show_format.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBMI_var_update.$(O) GDBMI_var_update.$(C) GDBMI_var_update.$(H): GDBMI_var_update.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommand.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBMICommand.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBNotificationEvent.$(O) GDBNotificationEvent.$(C) GDBNotificationEvent.$(H): GDBNotificationEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBSelectedFrameChangedEvent.$(O) GDBSelectedFrameChangedEvent.$(C) GDBSelectedFrameChangedEvent.$(H): GDBSelectedFrameChangedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBInternalEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBStatusEvent.$(O) GDBStatusEvent.$(C) GDBStatusEvent.$(H): GDBStatusEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBTargetOutputEvent.$(O) GDBTargetOutputEvent.$(C) GDBTargetOutputEvent.$(H): GDBTargetOutputEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBStreamOutputEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThread.$(O) GDBThread.$(C) GDBThread.$(H): GDBThread.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroup.$(O) GDBThreadGroup.$(C) GDBThreadGroup.$(H): GDBThreadGroup.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommandStatus.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBTransientObject.$(O) GDBTransientObject.$(C) GDBTransientObject.$(H): GDBTransientObject.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBVariable.$(O) GDBVariable.$(C) GDBVariable.$(H): GDBVariable.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBVariableObject.$(O) GDBVariableObject.$(C) GDBVariableObject.$(H): GDBVariableObject.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBVariableObjectChange.$(O) GDBVariableObjectChange.$(C) GDBVariableObjectChange.$(H): GDBVariableObjectChange.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBVariableObjectExecutor.$(O) GDBVariableObjectExecutor.$(C) GDBVariableObjectExecutor.$(H): GDBVariableObjectExecutor.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBBreakpointDeletedEvent.$(O) GDBBreakpointDeletedEvent.$(C) GDBBreakpointDeletedEvent.$(H): GDBBreakpointDeletedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBBreakpointEvent.$(O) GDBBreakpointEvent.$(C) GDBBreakpointEvent.$(H): GDBBreakpointEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBCmdParamChangedEvent.$(O) GDBCmdParamChangedEvent.$(C) GDBCmdParamChangedEvent.$(H): GDBCmdParamChangedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBEventSetProcessingFinished.$(O) GDBEventSetProcessingFinished.$(C) GDBEventSetProcessingFinished.$(H): GDBEventSetProcessingFinished.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEventSetEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBInternalEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBEventSetProcessingStarted.$(O) GDBEventSetProcessingStarted.$(C) GDBEventSetProcessingStarted.$(H): GDBEventSetProcessingStarted.st $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEventSetEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBInternalEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBLibraryLoadedEvent.$(O) GDBLibraryLoadedEvent.$(C) GDBLibraryLoadedEvent.$(H): GDBLibraryLoadedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBLibraryUnloadedEvent.$(O) GDBLibraryUnloadedEvent.$(C) GDBLibraryUnloadedEvent.$(H): GDBLibraryUnloadedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBRunningEvent.$(O) GDBRunningEvent.$(C) GDBRunningEvent.$(H): GDBRunningEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBExecutionEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBStoppedEvent.$(O) GDBStoppedEvent.$(C) GDBStoppedEvent.$(H): GDBStoppedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBExecutionEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadEvent.$(O) GDBThreadEvent.$(C) GDBThreadEvent.$(H): GDBThreadEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupEvent.$(O) GDBThreadGroupEvent.$(C) GDBThreadGroupEvent.$(H): GDBThreadGroupEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadSelectedEvent.$(O) GDBThreadSelectedEvent.$(C) GDBThreadSelectedEvent.$(H): GDBThreadSelectedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBBreakpointCreatedEvent.$(O) GDBBreakpointCreatedEvent.$(C) GDBBreakpointCreatedEvent.$(H): GDBBreakpointCreatedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBBreakpointEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBBreakpointModifiedEvent.$(O) GDBBreakpointModifiedEvent.$(C) GDBBreakpointModifiedEvent.$(H): GDBBreakpointModifiedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBBreakpointEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadCreatedEvent.$(O) GDBThreadCreatedEvent.$(C) GDBThreadCreatedEvent.$(H): GDBThreadCreatedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBThreadEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadExitedEvent.$(O) GDBThreadExitedEvent.$(C) GDBThreadExitedEvent.$(H): GDBThreadExitedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBThreadEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupAddedEvent.$(O) GDBThreadGroupAddedEvent.$(C) GDBThreadGroupAddedEvent.$(H): GDBThreadGroupAddedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBThreadGroupEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupExitedEvent.$(O) GDBThreadGroupExitedEvent.$(C) GDBThreadGroupExitedEvent.$(H): GDBThreadGroupExitedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBThreadGroupEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GDBThreadGroupStartedEvent.$(O) GDBThreadGroupStartedEvent.$(C) GDBThreadGroupStartedEvent.$(H): GDBThreadGroupStartedEvent.st $(INCLUDE_TOP)\jv\libgdbs\GDBAsyncEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBNotificationEvent.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBThreadGroupEvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\announcements\SubscriptionCollection.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MABooleanDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MANumberDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MARelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MASingleOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAToManyRelationDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Filename.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)jv_libgdbs.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
