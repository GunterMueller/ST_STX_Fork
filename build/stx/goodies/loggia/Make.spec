# $Header: /cvs/stx/stx/goodies/loggia/Make.spec,v 1.9 2016-12-05 11:54:28 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_loggia.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=goodies/loggia
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
	Loggia::AbstractUI \
	Loggia::LogLevels \
	Loggia::LogOriginatorProxy \
	Loggia::LogTransport \
	Loggia::LoggiaSettingsApplication \
	stx_goodies_loggia \
	Loggia::BOSSFileTransportUI \
	Loggia::CustomBlockTransport \
	Loggia::CustomBlockTransportUI \
	Loggia::DirectoryTransport \
	Loggia::DirectoryTransportUI \
	Loggia::FacilitiesUI \
	Loggia::FileTransport \
	Loggia::HaltingTransport \
	Loggia::InMemoryTransport \
	Loggia::InMemoryTransportUI \
	Loggia::LogFacility \
	Loggia::LogLevel \
	Loggia::LogMessage \
	Loggia::LogMessagesBrowserUI \
	Loggia::Logger \
	Loggia::LoggiaUI \
	Loggia::MailTransport \
	Loggia::MailTransportUI \
	Loggia::MultiplexTransport \
	Loggia::MultiplexTransportUI \
	Loggia::NullTransport \
	Loggia::PlainFileTransportUI \
	Loggia::SMSTransport \
	Loggia::SyslogTransport \
	Loggia::SyslogTransportUI \
	Loggia::TranscriptTransport \
	Loggia::TransportsUI \
	Loggia::BOSSFileTransport \
	Loggia::PlainFileTransport \
	Loggia::CSVTransport \
	Loggia::LogFileTransport \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Loggia__AbstractUI.$(O) \
    $(OUTDIR_SLASH)Loggia__LogLevels.$(O) \
    $(OUTDIR_SLASH)Loggia__LogOriginatorProxy.$(O) \
    $(OUTDIR_SLASH)Loggia__LogTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__LoggiaSettingsApplication.$(O) \
    $(OUTDIR_SLASH)stx_goodies_loggia.$(O) \
    $(OUTDIR_SLASH)Loggia__BOSSFileTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__CustomBlockTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__CustomBlockTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__DirectoryTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__DirectoryTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__FacilitiesUI.$(O) \
    $(OUTDIR_SLASH)Loggia__FileTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__HaltingTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__InMemoryTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__InMemoryTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__LogFacility.$(O) \
    $(OUTDIR_SLASH)Loggia__LogLevel.$(O) \
    $(OUTDIR_SLASH)Loggia__LogMessage.$(O) \
    $(OUTDIR_SLASH)Loggia__LogMessagesBrowserUI.$(O) \
    $(OUTDIR_SLASH)Loggia__Logger.$(O) \
    $(OUTDIR_SLASH)Loggia__LoggiaUI.$(O) \
    $(OUTDIR_SLASH)Loggia__MailTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__MailTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__MultiplexTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__MultiplexTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__NullTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__PlainFileTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__SMSTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__SyslogTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__SyslogTransportUI.$(O) \
    $(OUTDIR_SLASH)Loggia__TranscriptTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__TransportsUI.$(O) \
    $(OUTDIR_SLASH)Loggia__BOSSFileTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__PlainFileTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__CSVTransport.$(O) \
    $(OUTDIR_SLASH)Loggia__LogFileTransport.$(O) \



