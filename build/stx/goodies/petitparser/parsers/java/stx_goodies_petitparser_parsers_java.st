"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser_parsers_java
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser_parsers_java class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitJava-JanKurs.160
    Author: JanKurs
    Time: 19-12-2014, 01:00:18.354 PM
    UUID: 1cb1b46d-8c68-4751-9720-f0dd742f3e16
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-04-2015 / 13:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitJava'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-04-2015 / 13:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser_parsers_java class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/petitparser'    "PPCompositeParser - superclass of PPJavaLexicon"
        #'stx:goodies/petitparser/tests'    "PPAbstractParserTest - superclass of PPJavaLexiconTest"
        #'stx:goodies/sunit'    "TestAsserter - superclass of PPJavaLexiconTest"
        #'stx:libbasic'    "ArithmeticValue - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
    )
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ super stcOptimizationOptions , ' -inlinenot'

    "Created: / 13-04-2015 / 14:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_petitparser_parsers_java class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PJASTNode
        PJASTNodeVisitor
        PPJavaLexicon
        (PPJavaLexiconTest autoload)
        PPJavaToken
        PPJavaTokenParser
        PPJavaWhitespaceParser
        #'stx_goodies_petitparser_parsers_java'
        PJBlockNode
        PJBodyDeclarationNode
        PJCompilationUnitNode
        PJExpressionNode
        PJImportDeclarationNode
        PJModifierNode
        PJPackageDeclarationNode
        PJParameterDeclaratorNode
        PJStatementNode
        PJSyntaxNode
        PJTypeNode
        PJVariableDeclaratorNode
        PPJavaSyntax
        PJAbstractTypeDeclarationNode
        PJAnnotationNode
        PJArrayTypeNode
        PJBehaviouralNode
        PJBooleanLiteralNode
        PJCharacterLiteralNode
        PJCommentsNode
        PJExpressionStatementNode
        PJFloatLiteralNode
        PJIdentifierNode
        PJIfStatementNode
        PJInfixOperationNode
        PJIntegerLiteralNode
        PJLocalVariableDeclarationStatementNode
        PJNameNode
        PJNullLiteralNode
        PJPrimitiveTypeNode
        PJReturnStatementNode
        PJSeparatorNode
        PJStringLiteralNode
        PJWhileStatementNode
        PPJavaParser
        PJConstructorDeclarationNode
        PJEndOfLineCommentsNode
        PJMethodDeclarationNode
        PJQualifiedNameNode
        PJSimpleNameNode
        PJTraditionalCommentsNode
        PJTypeDeclarationNode
        (PPJavaParserTest autoload)
        (PPJavaSyntaxTest autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        PPParser javaToken
        'Integer class' readFromJavaString:
    )
! !

!stx_goodies_petitparser_parsers_java class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info"

    ^ 'Copyright Claus Gittinger 1988-2015\nCopyright eXept Software AG 1998-2015'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dlls file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_petitparser_parsers_java class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

