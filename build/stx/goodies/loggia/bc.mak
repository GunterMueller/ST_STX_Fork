# $Header: /cvs/stx/stx/goodies/loggia/bc.mak,v 1.8 2016-12-05 11:54:32 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_loggia.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_loggia
MODULE_PATH=goodies\loggia
RESFILES=stx_goodies_loggiaWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\communication -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libboss -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libboss & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Loggia__AbstractUI.$(O) Loggia__AbstractUI.$(C) Loggia__AbstractUI.$(H): Loggia__AbstractUI.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogLevels.$(O) Loggia__LogLevels.$(C) Loggia__LogLevels.$(H): Loggia__LogLevels.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogOriginatorProxy.$(O) Loggia__LogOriginatorProxy.$(C) Loggia__LogOriginatorProxy.$(H): Loggia__LogOriginatorProxy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogTransport.$(O) Loggia__LogTransport.$(C) Loggia__LogTransport.$(H): Loggia__LogTransport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LoggiaSettingsApplication.$(O) Loggia__LoggiaSettingsApplication.$(C) Loggia__LoggiaSettingsApplication.$(H): Loggia__LoggiaSettingsApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_loggia.$(O) stx_goodies_loggia.$(C) stx_goodies_loggia.$(H): stx_goodies_loggia.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Loggia__BOSSFileTransportUI.$(O) Loggia__BOSSFileTransportUI.$(C) Loggia__BOSSFileTransportUI.$(H): Loggia__BOSSFileTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__CustomBlockTransport.$(O) Loggia__CustomBlockTransport.$(C) Loggia__CustomBlockTransport.$(H): Loggia__CustomBlockTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__CustomBlockTransportUI.$(O) Loggia__CustomBlockTransportUI.$(C) Loggia__CustomBlockTransportUI.$(H): Loggia__CustomBlockTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__DirectoryTransport.$(O) Loggia__DirectoryTransport.$(C) Loggia__DirectoryTransport.$(H): Loggia__DirectoryTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__DirectoryTransportUI.$(O) Loggia__DirectoryTransportUI.$(C) Loggia__DirectoryTransportUI.$(H): Loggia__DirectoryTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__FacilitiesUI.$(O) Loggia__FacilitiesUI.$(C) Loggia__FacilitiesUI.$(H): Loggia__FacilitiesUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__FileTransport.$(O) Loggia__FileTransport.$(C) Loggia__FileTransport.$(H): Loggia__FileTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__HaltingTransport.$(O) Loggia__HaltingTransport.$(C) Loggia__HaltingTransport.$(H): Loggia__HaltingTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__InMemoryTransport.$(O) Loggia__InMemoryTransport.$(C) Loggia__InMemoryTransport.$(H): Loggia__InMemoryTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__InMemoryTransportUI.$(O) Loggia__InMemoryTransportUI.$(C) Loggia__InMemoryTransportUI.$(H): Loggia__InMemoryTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogFacility.$(O) Loggia__LogFacility.$(C) Loggia__LogFacility.$(H): Loggia__LogFacility.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogLevels.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogLevel.$(O) Loggia__LogLevel.$(C) Loggia__LogLevel.$(H): Loggia__LogLevel.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogLevels.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogMessage.$(O) Loggia__LogMessage.$(C) Loggia__LogMessage.$(H): Loggia__LogMessage.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogLevels.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogMessagesBrowserUI.$(O) Loggia__LogMessagesBrowserUI.$(C) Loggia__LogMessagesBrowserUI.$(H): Loggia__LogMessagesBrowserUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__Logger.$(O) Loggia__Logger.$(C) Loggia__Logger.$(H): Loggia__Logger.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogLevels.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LoggiaUI.$(O) Loggia__LoggiaUI.$(C) Loggia__LoggiaUI.$(H): Loggia__LoggiaUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__MailTransport.$(O) Loggia__MailTransport.$(C) Loggia__MailTransport.$(H): Loggia__MailTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__MailTransportUI.$(O) Loggia__MailTransportUI.$(C) Loggia__MailTransportUI.$(H): Loggia__MailTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__MultiplexTransport.$(O) Loggia__MultiplexTransport.$(C) Loggia__MultiplexTransport.$(H): Loggia__MultiplexTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__MultiplexTransportUI.$(O) Loggia__MultiplexTransportUI.$(C) Loggia__MultiplexTransportUI.$(H): Loggia__MultiplexTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__NullTransport.$(O) Loggia__NullTransport.$(C) Loggia__NullTransport.$(H): Loggia__NullTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__PlainFileTransportUI.$(O) Loggia__PlainFileTransportUI.$(C) Loggia__PlainFileTransportUI.$(H): Loggia__PlainFileTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__SMSTransport.$(O) Loggia__SMSTransport.$(C) Loggia__SMSTransport.$(H): Loggia__SMSTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__SyslogTransport.$(O) Loggia__SyslogTransport.$(C) Loggia__SyslogTransport.$(H): Loggia__SyslogTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__SyslogTransportUI.$(O) Loggia__SyslogTransportUI.$(C) Loggia__SyslogTransportUI.$(H): Loggia__SyslogTransportUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Loggia__TranscriptTransport.$(O) Loggia__TranscriptTransport.$(C) Loggia__TranscriptTransport.$(H): Loggia__TranscriptTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__TransportsUI.$(O) Loggia__TransportsUI.$(C) Loggia__TransportsUI.$(H): Loggia__TransportsUI.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__AbstractUI.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)Loggia__BOSSFileTransport.$(O) Loggia__BOSSFileTransport.$(C) Loggia__BOSSFileTransport.$(H): Loggia__BOSSFileTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__FileTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libboss\BinaryIOManager.$(H) $(INCLUDE_TOP)\stx\libboss\BinaryOutputManager.$(H) $(STCHDR)
$(OUTDIR)Loggia__PlainFileTransport.$(O) Loggia__PlainFileTransport.$(C) Loggia__PlainFileTransport.$(H): Loggia__PlainFileTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__FileTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__CSVTransport.$(O) Loggia__CSVTransport.$(C) Loggia__CSVTransport.$(H): Loggia__CSVTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__FileTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__PlainFileTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Loggia__LogFileTransport.$(O) Loggia__LogFileTransport.$(C) Loggia__LogFileTransport.$(H): Loggia__LogFileTransport.st $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__FileTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__LogTransport.$(H) $(INCLUDE_TOP)\stx\goodies\loggia\Loggia__PlainFileTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
