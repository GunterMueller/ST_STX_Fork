# $Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/Make.spec,v 1.3 2013-01-30 11:19:20 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_dolphinHTTP at 2011-10-04 18:45:59.261.
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
MODULE_DIR=goodies/communication/dolphinHTTP
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -H.         : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
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
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	SWSU \
	SZReadWriteSocketStream \
	SptCredentials \
	SptHTTPAuthorizationDialog \
	SptHTTPChallenge \
	SptHTTPConfiguration \
	SptHTTPConnection \
	SptHTTPCookie \
	SptHTTPCookieJar \
	SptHTTPEntity \
	SptHTTPError \
	SptHTTPHostCache \
	SptHTTPNotAuthorized \
	SptHTTPProgressAbstract \
	SptHTTPProxySettings \
	SptHTTPRequest \
	SptHTTPResponse \
	SptHTTPSessionState \
	SptHTTPStatus \
	SptHTTPUrl \
	SptHTTPUser \
	stx_goodies_communication_dolphinHTTP \
	SptBasicCredentials \
	SptHTTPClientError \
	SptHTTPProgress \
	SptHTTPProgressDev \
	SptHTTPSConnection \
	SptHTTPServerError \
	SptHTTPTestProgress \
	SptHTTPTranscriptProgress \
	SptHTTPTriggerProgress \
	SptHTTPValueProgress \
	SZLoggingSocketStream \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SWSU.$(O) \
    $(OUTDIR_SLASH)SZReadWriteSocketStream.$(O) \
    $(OUTDIR_SLASH)SptCredentials.$(O) \
    $(OUTDIR_SLASH)SptHTTPAuthorizationDialog.$(O) \
    $(OUTDIR_SLASH)SptHTTPChallenge.$(O) \
    $(OUTDIR_SLASH)SptHTTPConfiguration.$(O) \
    $(OUTDIR_SLASH)SptHTTPConnection.$(O) \
    $(OUTDIR_SLASH)SptHTTPCookie.$(O) \
    $(OUTDIR_SLASH)SptHTTPCookieJar.$(O) \
    $(OUTDIR_SLASH)SptHTTPEntity.$(O) \
    $(OUTDIR_SLASH)SptHTTPError.$(O) \
    $(OUTDIR_SLASH)SptHTTPHostCache.$(O) \
    $(OUTDIR_SLASH)SptHTTPNotAuthorized.$(O) \
    $(OUTDIR_SLASH)SptHTTPProgressAbstract.$(O) \
    $(OUTDIR_SLASH)SptHTTPProxySettings.$(O) \
    $(OUTDIR_SLASH)SptHTTPRequest.$(O) \
    $(OUTDIR_SLASH)SptHTTPResponse.$(O) \
    $(OUTDIR_SLASH)SptHTTPSessionState.$(O) \
    $(OUTDIR_SLASH)SptHTTPStatus.$(O) \
    $(OUTDIR_SLASH)SptHTTPUrl.$(O) \
    $(OUTDIR_SLASH)SptHTTPUser.$(O) \
    $(OUTDIR_SLASH)stx_goodies_communication_dolphinHTTP.$(O) \
    $(OUTDIR_SLASH)SptBasicCredentials.$(O) \
    $(OUTDIR_SLASH)SptHTTPClientError.$(O) \
    $(OUTDIR_SLASH)SptHTTPProgress.$(O) \
    $(OUTDIR_SLASH)SptHTTPProgressDev.$(O) \
    $(OUTDIR_SLASH)SptHTTPSConnection.$(O) \
    $(OUTDIR_SLASH)SptHTTPServerError.$(O) \
    $(OUTDIR_SLASH)SptHTTPTestProgress.$(O) \
    $(OUTDIR_SLASH)SptHTTPTranscriptProgress.$(O) \
    $(OUTDIR_SLASH)SptHTTPTriggerProgress.$(O) \
    $(OUTDIR_SLASH)SptHTTPValueProgress.$(O) \
    $(OUTDIR_SLASH)SZLoggingSocketStream.$(O) \



