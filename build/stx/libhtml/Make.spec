# $Header: /cvs/stx/stx/libhtml/Make.spec,v 1.17 2014-07-08 22:49:10 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libhtml.
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
MODULE_DIR=libhtml
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
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
	DidYouKnowTipViewer \
	HTMLDocument \
	HTMLDocumentFrame \
	HTMLDocumentInterpreter \
	HTMLDocumentViewerApplication \
	HTMLElement \
	HTMLFontStyle \
	HTMLPageStyle \
	HTMLParser \
	HTMLScriptEnvironment \
	HTMLTableCol \
	HTMLTableRow \
	HTMLView \
	URL \
	stx_libhtml \
	HTMLDocumentPainter \
	HTMLDocumentView \
	HTMLMarkup \
	HTMLText \
	HTMLAnchor \
	HTMLBullet \
	HTMLCRMarkupText \
	HTMLForm \
	HTMLList \
	HTMLMarkupText \
	HTMLScript \
	HTMLStyle \
	HTMLTable \
	HTMLWidget \
	HTMLApplet \
	HTMLImage \




COMMON_OBJS= \
    $(OUTDIR_SLASH)DidYouKnowTipViewer.$(O) \
    $(OUTDIR_SLASH)HTMLDocument.$(O) \
    $(OUTDIR_SLASH)HTMLDocumentFrame.$(O) \
    $(OUTDIR_SLASH)HTMLDocumentInterpreter.$(O) \
    $(OUTDIR_SLASH)HTMLDocumentViewerApplication.$(O) \
    $(OUTDIR_SLASH)HTMLElement.$(O) \
    $(OUTDIR_SLASH)HTMLFontStyle.$(O) \
    $(OUTDIR_SLASH)HTMLPageStyle.$(O) \
    $(OUTDIR_SLASH)HTMLParser.$(O) \
    $(OUTDIR_SLASH)HTMLScriptEnvironment.$(O) \
    $(OUTDIR_SLASH)HTMLTableCol.$(O) \
    $(OUTDIR_SLASH)HTMLTableRow.$(O) \
    $(OUTDIR_SLASH)HTMLView.$(O) \
    $(OUTDIR_SLASH)URL.$(O) \
    $(OUTDIR_SLASH)stx_libhtml.$(O) \
    $(OUTDIR_SLASH)HTMLDocumentPainter.$(O) \
    $(OUTDIR_SLASH)HTMLDocumentView.$(O) \
    $(OUTDIR_SLASH)HTMLMarkup.$(O) \
    $(OUTDIR_SLASH)HTMLText.$(O) \
    $(OUTDIR_SLASH)HTMLAnchor.$(O) \
    $(OUTDIR_SLASH)HTMLBullet.$(O) \
    $(OUTDIR_SLASH)HTMLCRMarkupText.$(O) \
    $(OUTDIR_SLASH)HTMLForm.$(O) \
    $(OUTDIR_SLASH)HTMLList.$(O) \
    $(OUTDIR_SLASH)HTMLMarkupText.$(O) \
    $(OUTDIR_SLASH)HTMLScript.$(O) \
    $(OUTDIR_SLASH)HTMLStyle.$(O) \
    $(OUTDIR_SLASH)HTMLTable.$(O) \
    $(OUTDIR_SLASH)HTMLWidget.$(O) \
    $(OUTDIR_SLASH)HTMLApplet.$(O) \
    $(OUTDIR_SLASH)HTMLImage.$(O) \



