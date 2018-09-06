# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_parsers_java.
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
MODULE_DIR=goodies/petitparser/parsers/java
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
	PJASTNode \
	PJASTNodeVisitor \
	PPJavaLexicon \
	PPJavaToken \
	PPJavaTokenParser \
	PPJavaWhitespaceParser \
	stx_goodies_petitparser_parsers_java \
	PJBlockNode \
	PJBodyDeclarationNode \
	PJCompilationUnitNode \
	PJExpressionNode \
	PJImportDeclarationNode \
	PJModifierNode \
	PJPackageDeclarationNode \
	PJParameterDeclaratorNode \
	PJStatementNode \
	PJSyntaxNode \
	PJTypeNode \
	PJVariableDeclaratorNode \
	PPJavaSyntax \
	PJAbstractTypeDeclarationNode \
	PJAnnotationNode \
	PJArrayTypeNode \
	PJBehaviouralNode \
	PJBooleanLiteralNode \
	PJCharacterLiteralNode \
	PJCommentsNode \
	PJExpressionStatementNode \
	PJFloatLiteralNode \
	PJIdentifierNode \
	PJIfStatementNode \
	PJInfixOperationNode \
	PJIntegerLiteralNode \
	PJLocalVariableDeclarationStatementNode \
	PJNameNode \
	PJNullLiteralNode \
	PJPrimitiveTypeNode \
	PJReturnStatementNode \
	PJSeparatorNode \
	PJStringLiteralNode \
	PJWhileStatementNode \
	PPJavaParser \
	PJConstructorDeclarationNode \
	PJEndOfLineCommentsNode \
	PJMethodDeclarationNode \
	PJQualifiedNameNode \
	PJSimpleNameNode \
	PJTraditionalCommentsNode \
	PJTypeDeclarationNode \




COMMON_OBJS= \
    $(OUTDIR_SLASH)PJASTNode.$(O) \
    $(OUTDIR_SLASH)PJASTNodeVisitor.$(O) \
    $(OUTDIR_SLASH)PPJavaLexicon.$(O) \
    $(OUTDIR_SLASH)PPJavaToken.$(O) \
    $(OUTDIR_SLASH)PPJavaTokenParser.$(O) \
    $(OUTDIR_SLASH)PPJavaWhitespaceParser.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser_parsers_java.$(O) \
    $(OUTDIR_SLASH)PJBlockNode.$(O) \
    $(OUTDIR_SLASH)PJBodyDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJCompilationUnitNode.$(O) \
    $(OUTDIR_SLASH)PJExpressionNode.$(O) \
    $(OUTDIR_SLASH)PJImportDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJModifierNode.$(O) \
    $(OUTDIR_SLASH)PJPackageDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJParameterDeclaratorNode.$(O) \
    $(OUTDIR_SLASH)PJStatementNode.$(O) \
    $(OUTDIR_SLASH)PJSyntaxNode.$(O) \
    $(OUTDIR_SLASH)PJTypeNode.$(O) \
    $(OUTDIR_SLASH)PJVariableDeclaratorNode.$(O) \
    $(OUTDIR_SLASH)PPJavaSyntax.$(O) \
    $(OUTDIR_SLASH)PJAbstractTypeDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJAnnotationNode.$(O) \
    $(OUTDIR_SLASH)PJArrayTypeNode.$(O) \
    $(OUTDIR_SLASH)PJBehaviouralNode.$(O) \
    $(OUTDIR_SLASH)PJBooleanLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJCharacterLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJCommentsNode.$(O) \
    $(OUTDIR_SLASH)PJExpressionStatementNode.$(O) \
    $(OUTDIR_SLASH)PJFloatLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJIdentifierNode.$(O) \
    $(OUTDIR_SLASH)PJIfStatementNode.$(O) \
    $(OUTDIR_SLASH)PJInfixOperationNode.$(O) \
    $(OUTDIR_SLASH)PJIntegerLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJLocalVariableDeclarationStatementNode.$(O) \
    $(OUTDIR_SLASH)PJNameNode.$(O) \
    $(OUTDIR_SLASH)PJNullLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJPrimitiveTypeNode.$(O) \
    $(OUTDIR_SLASH)PJReturnStatementNode.$(O) \
    $(OUTDIR_SLASH)PJSeparatorNode.$(O) \
    $(OUTDIR_SLASH)PJStringLiteralNode.$(O) \
    $(OUTDIR_SLASH)PJWhileStatementNode.$(O) \
    $(OUTDIR_SLASH)PPJavaParser.$(O) \
    $(OUTDIR_SLASH)PJConstructorDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJEndOfLineCommentsNode.$(O) \
    $(OUTDIR_SLASH)PJMethodDeclarationNode.$(O) \
    $(OUTDIR_SLASH)PJQualifiedNameNode.$(O) \
    $(OUTDIR_SLASH)PJSimpleNameNode.$(O) \
    $(OUTDIR_SLASH)PJTraditionalCommentsNode.$(O) \
    $(OUTDIR_SLASH)PJTypeDeclarationNode.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



