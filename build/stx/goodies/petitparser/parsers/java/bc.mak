# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_parsers_java.
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
TOP=..\..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_petitparser_parsers_java
MODULE_PATH=goodies\petitparser\parsers\java
RESFILES=java.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\petitparser\tests -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\.. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\tests & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PJASTNode.$(O) PJASTNode.$(H): PJASTNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJASTNodeVisitor.$(O) PJASTNodeVisitor.$(H): PJASTNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaLexicon.$(O) PPJavaLexicon.$(H): PPJavaLexicon.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaToken.$(O) PPJavaToken.$(H): PPJavaToken.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPToken.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaTokenParser.$(O) PPJavaTokenParser.$(H): PPJavaTokenParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFlattenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTokenParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaWhitespaceParser.$(O) PPJavaWhitespaceParser.$(H): PPJavaWhitespaceParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_parsers_java.$(O) stx_goodies_petitparser_parsers_java.$(H): stx_goodies_petitparser_parsers_java.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)PJBlockNode.$(O) PJBlockNode.$(H): PJBlockNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJBodyDeclarationNode.$(O) PJBodyDeclarationNode.$(H): PJBodyDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJCompilationUnitNode.$(O) PJCompilationUnitNode.$(H): PJCompilationUnitNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJExpressionNode.$(O) PJExpressionNode.$(H): PJExpressionNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJImportDeclarationNode.$(O) PJImportDeclarationNode.$(H): PJImportDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJModifierNode.$(O) PJModifierNode.$(H): PJModifierNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJPackageDeclarationNode.$(O) PJPackageDeclarationNode.$(H): PJPackageDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJParameterDeclaratorNode.$(O) PJParameterDeclaratorNode.$(H): PJParameterDeclaratorNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJStatementNode.$(O) PJStatementNode.$(H): PJStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJSyntaxNode.$(O) PJSyntaxNode.$(H): PJSyntaxNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJTypeNode.$(O) PJTypeNode.$(H): PJTypeNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJVariableDeclaratorNode.$(O) PJVariableDeclaratorNode.$(H): PJVariableDeclaratorNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaSyntax.$(O) PPJavaSyntax.$(H): PPJavaSyntax.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PPJavaLexicon.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJAbstractTypeDeclarationNode.$(O) PJAbstractTypeDeclarationNode.$(H): PJAbstractTypeDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBodyDeclarationNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJAnnotationNode.$(O) PJAnnotationNode.$(H): PJAnnotationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJArrayTypeNode.$(O) PJArrayTypeNode.$(H): PJArrayTypeNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJTypeNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJBehaviouralNode.$(O) PJBehaviouralNode.$(H): PJBehaviouralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBodyDeclarationNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJBooleanLiteralNode.$(O) PJBooleanLiteralNode.$(H): PJBooleanLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJCharacterLiteralNode.$(O) PJCharacterLiteralNode.$(H): PJCharacterLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJCommentsNode.$(O) PJCommentsNode.$(H): PJCommentsNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJSyntaxNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJExpressionStatementNode.$(O) PJExpressionStatementNode.$(H): PJExpressionStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJFloatLiteralNode.$(O) PJFloatLiteralNode.$(H): PJFloatLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJIdentifierNode.$(O) PJIdentifierNode.$(H): PJIdentifierNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJIfStatementNode.$(O) PJIfStatementNode.$(H): PJIfStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJInfixOperationNode.$(O) PJInfixOperationNode.$(H): PJInfixOperationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJIntegerLiteralNode.$(O) PJIntegerLiteralNode.$(H): PJIntegerLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJLocalVariableDeclarationStatementNode.$(O) PJLocalVariableDeclarationStatementNode.$(H): PJLocalVariableDeclarationStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJNameNode.$(O) PJNameNode.$(H): PJNameNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJNullLiteralNode.$(O) PJNullLiteralNode.$(H): PJNullLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJPrimitiveTypeNode.$(O) PJPrimitiveTypeNode.$(H): PJPrimitiveTypeNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJTypeNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJReturnStatementNode.$(O) PJReturnStatementNode.$(H): PJReturnStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJSeparatorNode.$(O) PJSeparatorNode.$(H): PJSeparatorNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJStringLiteralNode.$(O) PJStringLiteralNode.$(H): PJStringLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJWhileStatementNode.$(O) PJWhileStatementNode.$(H): PJWhileStatementNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJStatementNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPJavaParser.$(O) PPJavaParser.$(H): PPJavaParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PPJavaLexicon.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PPJavaSyntax.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJConstructorDeclarationNode.$(O) PJConstructorDeclarationNode.$(H): PJConstructorDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBehaviouralNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBodyDeclarationNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJEndOfLineCommentsNode.$(O) PJEndOfLineCommentsNode.$(H): PJEndOfLineCommentsNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJCommentsNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJSyntaxNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJMethodDeclarationNode.$(O) PJMethodDeclarationNode.$(H): PJMethodDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBehaviouralNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBodyDeclarationNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJQualifiedNameNode.$(O) PJQualifiedNameNode.$(H): PJQualifiedNameNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJNameNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJSimpleNameNode.$(O) PJSimpleNameNode.$(H): PJSimpleNameNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJExpressionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJNameNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJTraditionalCommentsNode.$(O) PJTraditionalCommentsNode.$(H): PJTraditionalCommentsNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJCommentsNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJSyntaxNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PJTypeDeclarationNode.$(O) PJTypeDeclarationNode.$(H): PJTypeDeclarationNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJASTNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJAbstractTypeDeclarationNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PJBodyDeclarationNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_parsers_java.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
