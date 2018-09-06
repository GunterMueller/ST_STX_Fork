# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_parser.
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
MODULE_DIR=goodies/refactoryBrowser/parser
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
STCLOCALOPTIMIZATIONS=+optspace3 -inlinenot


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
	RBComment \
	RBParser \
	RBProgramNode \
	RBProgramNodeVisitor \
	RBScanner \
	RBSmallDictionary \
	RBStringReplacement \
	RBToken \
	stx_goodies_refactoryBrowser_parser \
	ParseTreeSearcher \
	RBAssignmentToken \
	RBEndOfFileToken \
	RBFormatter \
	RBMethodNode \
	RBOptimizedToken \
	RBPluggableProgramNodeVisitor \
	RBPragmaNode \
	RBSequenceNode \
	RBStatementNode \
	RBValueToken \
	ParseTreeRewriter \
	RBBinarySelectorToken \
	RBIdentifierToken \
	RBKeywordToken \
	RBLiteralToken \
	RBMetaMethodNode \
	RBOldStyleAssignmentToken \
	RBPatternBlockToken \
	RBPatternMethodNode \
	RBReturnNode \
	RBSTXPrimitiveCCodeNode \
	RBSTXPrimitiveCodeToken \
	RBSpecialCharacterToken \
	RBValueNode \
	ParseTreeSourceRewriter \
	RBArrayNode \
	RBAssignmentNode \
	RBBlockNode \
	RBCascadeNode \
	RBLiteralByteArrayToken \
	RBLiteralNode \
	RBLiteralNumberToken \
	RBMessageNode \
	RBOptimizedNode \
	RBPatternLiteralToken \
	RBSTXPrimitiveValueCCodeNode \
	RBVariableNode \
	RBLiteralArrayNode \
	RBLiteralValueNode \
	RBMetaMessageNode \
	RBMetaVariableNode \
	RBPatternBlockNode \
	RBPatternMessageNode \
	RBPatternVariableNode \




COMMON_OBJS= \
    $(OUTDIR_SLASH)RBComment.$(O) \
    $(OUTDIR_SLASH)RBParser.$(O) \
    $(OUTDIR_SLASH)RBProgramNode.$(O) \
    $(OUTDIR_SLASH)RBProgramNodeVisitor.$(O) \
    $(OUTDIR_SLASH)RBScanner.$(O) \
    $(OUTDIR_SLASH)RBSmallDictionary.$(O) \
    $(OUTDIR_SLASH)RBStringReplacement.$(O) \
    $(OUTDIR_SLASH)RBToken.$(O) \
    $(OUTDIR_SLASH)stx_goodies_refactoryBrowser_parser.$(O) \
    $(OUTDIR_SLASH)ParseTreeSearcher.$(O) \
    $(OUTDIR_SLASH)RBAssignmentToken.$(O) \
    $(OUTDIR_SLASH)RBEndOfFileToken.$(O) \
    $(OUTDIR_SLASH)RBFormatter.$(O) \
    $(OUTDIR_SLASH)RBMethodNode.$(O) \
    $(OUTDIR_SLASH)RBOptimizedToken.$(O) \
    $(OUTDIR_SLASH)RBPluggableProgramNodeVisitor.$(O) \
    $(OUTDIR_SLASH)RBPragmaNode.$(O) \
    $(OUTDIR_SLASH)RBSequenceNode.$(O) \
    $(OUTDIR_SLASH)RBStatementNode.$(O) \
    $(OUTDIR_SLASH)RBValueToken.$(O) \
    $(OUTDIR_SLASH)ParseTreeRewriter.$(O) \
    $(OUTDIR_SLASH)RBBinarySelectorToken.$(O) \
    $(OUTDIR_SLASH)RBIdentifierToken.$(O) \
    $(OUTDIR_SLASH)RBKeywordToken.$(O) \
    $(OUTDIR_SLASH)RBLiteralToken.$(O) \
    $(OUTDIR_SLASH)RBMetaMethodNode.$(O) \
    $(OUTDIR_SLASH)RBOldStyleAssignmentToken.$(O) \
    $(OUTDIR_SLASH)RBPatternBlockToken.$(O) \
    $(OUTDIR_SLASH)RBPatternMethodNode.$(O) \
    $(OUTDIR_SLASH)RBReturnNode.$(O) \
    $(OUTDIR_SLASH)RBSTXPrimitiveCCodeNode.$(O) \
    $(OUTDIR_SLASH)RBSTXPrimitiveCodeToken.$(O) \
    $(OUTDIR_SLASH)RBSpecialCharacterToken.$(O) \
    $(OUTDIR_SLASH)RBValueNode.$(O) \
    $(OUTDIR_SLASH)ParseTreeSourceRewriter.$(O) \
    $(OUTDIR_SLASH)RBArrayNode.$(O) \
    $(OUTDIR_SLASH)RBAssignmentNode.$(O) \
    $(OUTDIR_SLASH)RBBlockNode.$(O) \
    $(OUTDIR_SLASH)RBCascadeNode.$(O) \
    $(OUTDIR_SLASH)RBLiteralByteArrayToken.$(O) \
    $(OUTDIR_SLASH)RBLiteralNode.$(O) \
    $(OUTDIR_SLASH)RBLiteralNumberToken.$(O) \
    $(OUTDIR_SLASH)RBMessageNode.$(O) \
    $(OUTDIR_SLASH)RBOptimizedNode.$(O) \
    $(OUTDIR_SLASH)RBPatternLiteralToken.$(O) \
    $(OUTDIR_SLASH)RBSTXPrimitiveValueCCodeNode.$(O) \
    $(OUTDIR_SLASH)RBVariableNode.$(O) \
    $(OUTDIR_SLASH)RBLiteralArrayNode.$(O) \
    $(OUTDIR_SLASH)RBLiteralValueNode.$(O) \
    $(OUTDIR_SLASH)RBMetaMessageNode.$(O) \
    $(OUTDIR_SLASH)RBMetaVariableNode.$(O) \
    $(OUTDIR_SLASH)RBPatternBlockNode.$(O) \
    $(OUTDIR_SLASH)RBPatternMessageNode.$(O) \
    $(OUTDIR_SLASH)RBPatternVariableNode.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



