# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_parser.
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
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIB_RB_PARSER_BASE
LIB_BASE=$(LIB_RB_PARSER_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_refactoryBrowser_parser
MODULE_PATH=goodies\refactoryBrowser\parser
RESFILES=parser.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RBComment.$(O) RBComment.$(C) RBComment.$(H): RBComment.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBParser.$(O) RBParser.$(C) RBParser.$(H): RBParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBProgramNode.$(O) RBProgramNode.$(C) RBProgramNode.$(H): RBProgramNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBProgramNodeVisitor.$(O) RBProgramNodeVisitor.$(C) RBProgramNodeVisitor.$(H): RBProgramNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBScanner.$(O) RBScanner.$(C) RBScanner.$(H): RBScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)RBSmallDictionary.$(O) RBSmallDictionary.$(C) RBSmallDictionary.$(H): RBSmallDictionary.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\KeyedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBStringReplacement.$(O) RBStringReplacement.$(C) RBStringReplacement.$(H): RBStringReplacement.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBToken.$(O) RBToken.$(C) RBToken.$(H): RBToken.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_parser.$(O) stx_goodies_refactoryBrowser_parser.$(C) stx_goodies_refactoryBrowser_parser.$(H): stx_goodies_refactoryBrowser_parser.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ParseTreeSearcher.$(O) ParseTreeSearcher.$(C) ParseTreeSearcher.$(H): ParseTreeSearcher.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBAssignmentToken.$(O) RBAssignmentToken.$(C) RBAssignmentToken.$(H): RBAssignmentToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBEndOfFileToken.$(O) RBEndOfFileToken.$(C) RBEndOfFileToken.$(H): RBEndOfFileToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBFormatter.$(O) RBFormatter.$(C) RBFormatter.$(H): RBFormatter.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethodNode.$(O) RBMethodNode.$(C) RBMethodNode.$(H): RBMethodNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBOptimizedToken.$(O) RBOptimizedToken.$(C) RBOptimizedToken.$(H): RBOptimizedToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPluggableProgramNodeVisitor.$(O) RBPluggableProgramNodeVisitor.$(C) RBPluggableProgramNodeVisitor.$(H): RBPluggableProgramNodeVisitor.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPragmaNode.$(O) RBPragmaNode.$(C) RBPragmaNode.$(H): RBPragmaNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSequenceNode.$(O) RBSequenceNode.$(C) RBSequenceNode.$(H): RBSequenceNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBStatementNode.$(O) RBStatementNode.$(C) RBStatementNode.$(H): RBStatementNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBValueToken.$(O) RBValueToken.$(C) RBValueToken.$(H): RBValueToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseTreeRewriter.$(O) ParseTreeRewriter.$(C) ParseTreeRewriter.$(H): ParseTreeRewriter.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeSearcher.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBBinarySelectorToken.$(O) RBBinarySelectorToken.$(C) RBBinarySelectorToken.$(H): RBBinarySelectorToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBIdentifierToken.$(O) RBIdentifierToken.$(C) RBIdentifierToken.$(H): RBIdentifierToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBKeywordToken.$(O) RBKeywordToken.$(C) RBKeywordToken.$(H): RBKeywordToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralToken.$(O) RBLiteralToken.$(C) RBLiteralToken.$(H): RBLiteralToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMetaMethodNode.$(O) RBMetaMethodNode.$(C) RBMetaMethodNode.$(H): RBMetaMethodNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBMethodNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBOldStyleAssignmentToken.$(O) RBOldStyleAssignmentToken.$(C) RBOldStyleAssignmentToken.$(H): RBOldStyleAssignmentToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBAssignmentToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternBlockToken.$(O) RBPatternBlockToken.$(C) RBPatternBlockToken.$(H): RBPatternBlockToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternMethodNode.$(O) RBPatternMethodNode.$(C) RBPatternMethodNode.$(H): RBPatternMethodNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBMethodNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBReturnNode.$(O) RBReturnNode.$(C) RBReturnNode.$(H): RBReturnNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSTXPrimitiveCCodeNode.$(O) RBSTXPrimitiveCCodeNode.$(C) RBSTXPrimitiveCCodeNode.$(H): RBSTXPrimitiveCCodeNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSTXPrimitiveCodeToken.$(O) RBSTXPrimitiveCodeToken.$(C) RBSTXPrimitiveCodeToken.$(H): RBSTXPrimitiveCodeToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSpecialCharacterToken.$(O) RBSpecialCharacterToken.$(C) RBSpecialCharacterToken.$(H): RBSpecialCharacterToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseTreeSourceRewriter.$(O) ParseTreeSourceRewriter.$(C) ParseTreeSourceRewriter.$(H): ParseTreeSourceRewriter.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeRewriter.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\ParseTreeSearcher.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBArrayNode.$(O) RBArrayNode.$(C) RBArrayNode.$(H): RBArrayNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBAssignmentNode.$(O) RBAssignmentNode.$(C) RBAssignmentNode.$(H): RBAssignmentNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBBlockNode.$(O) RBBlockNode.$(C) RBBlockNode.$(H): RBBlockNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBCascadeNode.$(O) RBCascadeNode.$(C) RBCascadeNode.$(H): RBCascadeNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralByteArrayToken.$(O) RBLiteralByteArrayToken.$(C) RBLiteralByteArrayToken.$(H): RBLiteralByteArrayToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralNode.$(O) RBLiteralNode.$(C) RBLiteralNode.$(H): RBLiteralNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralNumberToken.$(O) RBLiteralNumberToken.$(C) RBLiteralNumberToken.$(H): RBLiteralNumberToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMessageNode.$(O) RBMessageNode.$(C) RBMessageNode.$(H): RBMessageNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBOptimizedNode.$(O) RBOptimizedNode.$(C) RBOptimizedNode.$(H): RBOptimizedNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternLiteralToken.$(O) RBPatternLiteralToken.$(C) RBPatternLiteralToken.$(H): RBPatternLiteralToken.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBToken.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBSTXPrimitiveValueCCodeNode.$(O) RBSTXPrimitiveValueCCodeNode.$(C) RBSTXPrimitiveValueCCodeNode.$(H): RBSTXPrimitiveValueCCodeNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBVariableNode.$(O) RBVariableNode.$(C) RBVariableNode.$(H): RBVariableNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralArrayNode.$(O) RBLiteralArrayNode.$(C) RBLiteralArrayNode.$(H): RBLiteralArrayNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBLiteralValueNode.$(O) RBLiteralValueNode.$(C) RBLiteralValueNode.$(H): RBLiteralValueNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMetaMessageNode.$(O) RBMetaMessageNode.$(C) RBMetaMessageNode.$(H): RBMetaMessageNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBMessageNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMetaVariableNode.$(O) RBMetaVariableNode.$(C) RBMetaVariableNode.$(H): RBMetaVariableNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBVariableNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternBlockNode.$(O) RBPatternBlockNode.$(C) RBPatternBlockNode.$(H): RBPatternBlockNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBBlockNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternMessageNode.$(O) RBPatternMessageNode.$(C) RBPatternMessageNode.$(H): RBPatternMessageNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBMessageNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBPatternVariableNode.$(O) RBPatternVariableNode.$(C) RBPatternVariableNode.$(H): RBPatternVariableNode.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBVariableNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Block.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_refactoryBrowser_parser.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
