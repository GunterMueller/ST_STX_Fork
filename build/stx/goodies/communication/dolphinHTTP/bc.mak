# $Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/bc.mak,v 1.3 2013-05-28 10:23:22 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_dolphinHTTP at 2011-10-04 18:45:59.832.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains make rules for the win32 platform (using borland-bcc or visual-c).
# It shares common definitions with the unix-make in Make.spec.
# The nt.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#    this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#    this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_communication_dolphinHTTP
RESFILES=dolphinHTTP.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcompat -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libboss & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\librun & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "





# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SWSU.$(O) SWSU.$(H): SWSU.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SZReadWriteSocketStream.$(O) SZReadWriteSocketStream.$(H): SZReadWriteSocketStream.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptCredentials.$(O) SptCredentials.$(H): SptCredentials.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPAuthorizationDialog.$(O) SptHTTPAuthorizationDialog.$(H): SptHTTPAuthorizationDialog.st $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPChallenge.$(O) SptHTTPChallenge.$(H): SptHTTPChallenge.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPConfiguration.$(O) SptHTTPConfiguration.$(H): SptHTTPConfiguration.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPConnection.$(O) SptHTTPConnection.$(H): SptHTTPConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPCookie.$(O) SptHTTPCookie.$(H): SptHTTPCookie.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPCookieJar.$(O) SptHTTPCookieJar.$(H): SptHTTPCookieJar.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPEntity.$(O) SptHTTPEntity.$(H): SptHTTPEntity.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPError.$(O) SptHTTPError.$(H): SptHTTPError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPHostCache.$(O) SptHTTPHostCache.$(H): SptHTTPHostCache.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPNotAuthorized.$(O) SptHTTPNotAuthorized.$(H): SptHTTPNotAuthorized.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPProgressAbstract.$(O) SptHTTPProgressAbstract.$(H): SptHTTPProgressAbstract.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPProxySettings.$(O) SptHTTPProxySettings.$(H): SptHTTPProxySettings.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPRequest.$(O) SptHTTPRequest.$(H): SptHTTPRequest.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPResponse.$(O) SptHTTPResponse.$(H): SptHTTPResponse.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPSessionState.$(O) SptHTTPSessionState.$(H): SptHTTPSessionState.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPStatus.$(O) SptHTTPStatus.$(H): SptHTTPStatus.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPUrl.$(O) SptHTTPUrl.$(H): SptHTTPUrl.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPUser.$(O) SptHTTPUser.$(H): SptHTTPUser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_dolphinHTTP.$(O) stx_goodies_communication_dolphinHTTP.$(H): stx_goodies_communication_dolphinHTTP.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SZLoggingSocketStream.$(O) SZLoggingSocketStream.$(H): SZLoggingSocketStream.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SZReadWriteSocketStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptBasicCredentials.$(O) SptBasicCredentials.$(H): SptBasicCredentials.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptCredentials.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPClientError.$(O) SptHTTPClientError.$(H): SptHTTPClientError.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPProgress.$(O) SptHTTPProgress.$(H): SptHTTPProgress.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPProgressDev.$(O) SptHTTPProgressDev.$(H): SptHTTPProgressDev.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPSConnection.$(O) SptHTTPSConnection.$(H): SptHTTPSConnection.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPConnection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPServerError.$(O) SptHTTPServerError.$(H): SptHTTPServerError.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPTestProgress.$(O) SptHTTPTestProgress.$(H): SptHTTPTestProgress.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressDev.$(H) $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPTranscriptProgress.$(O) SptHTTPTranscriptProgress.$(H): SptHTTPTranscriptProgress.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressDev.$(H) $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPTriggerProgress.$(O) SptHTTPTriggerProgress.$(H): SptHTTPTriggerProgress.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgress.$(H) $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SptHTTPValueProgress.$(O) SptHTTPValueProgress.$(H): SptHTTPValueProgress.st $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgress.$(H) $(INCLUDE_TOP)\stx\goodies\communication\dolphinHTTP\SptHTTPProgressAbstract.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
