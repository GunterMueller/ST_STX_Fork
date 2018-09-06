# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_smaCC.
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
MODULE_DIR=goodies/smaCC
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
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	SmaCC::SmaCCAction \
	SmaCC::SmaCCCompilationNotification \
	SmaCC::SmaCCEdge \
	SmaCC::SmaCCGrammar \
	SmaCC::SmaCCGrammarCompiler \
	SmaCC::SmaCCItemSet \
	SmaCC::SmaCCLR1Item \
	SmaCC::SmaCCLineNumberStream \
	SmaCC::SmaCCNode \
	SmaCC::SmaCCParser \
	SmaCC::SmaCCParserError \
	SmaCC::SmaCCParserGenerator \
	SmaCC::SmaCCRHS \
	SmaCC::SmaCCRegularExpressionNode \
	SmaCC::SmaCCScanner \
	SmaCC::SmaCCScannerCompiler \
	SmaCC::SmaCCSymbol \
	SmaCC::SmaCCSymbolSet \
	SmaCC::SmaCCToken \
	stx_goodies_smaCC \
	SmaCC::SmaCCAcceptAction \
	SmaCC::SmaCCAdvancedParser \
	SmaCC::SmaCCAdvancedScanner \
	SmaCC::SmaCCCharacterRENode \
	SmaCC::SmaCCGrammarParser \
	SmaCC::SmaCCGrammarScanner \
	SmaCC::SmaCCNonTerminalSymbol \
	SmaCC::SmaCCOrRENode \
	SmaCC::SmaCCReduceAction \
	SmaCC::SmaCCRejectAction \
	SmaCC::SmaCCRepeatingRENode \
	SmaCC::SmaCCScannerParser \
	SmaCC::SmaCCScannerScanner \
	SmaCC::SmaCCSequenceRENode \
	SmaCC::SmaCCShiftAction \
	SmaCC::SmaCCTerminalSymbol \
	SmaCC::SmaCCStartingSymbol \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SmaCC__SmaCCAction.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCCompilationNotification.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCEdge.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCGrammar.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCGrammarCompiler.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCItemSet.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCLR1Item.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCLineNumberStream.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCNode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCParser.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCParserError.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCParserGenerator.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCRHS.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCRegularExpressionNode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCScanner.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCScannerCompiler.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCSymbol.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCSymbolSet.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCToken.$(O) \
    $(OUTDIR_SLASH)stx_goodies_smaCC.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCAcceptAction.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCAdvancedParser.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCAdvancedScanner.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCCharacterRENode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCGrammarParser.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCGrammarScanner.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCNonTerminalSymbol.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCOrRENode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCReduceAction.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCRejectAction.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCRepeatingRENode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCScannerParser.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCScannerScanner.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCSequenceRENode.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCShiftAction.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCTerminalSymbol.$(O) \
    $(OUTDIR_SLASH)SmaCC__SmaCCStartingSymbol.$(O) \



