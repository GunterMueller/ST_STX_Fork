"
 COPYRIGHT (c) 1989 by Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libcomp
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libcomp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Package documentation:

    This library contains the Smalltalk parser and bytecode compiler,
    and related support classes (AST representation).

    This compiler is used when code is changed within the running IDE or application,
    and when source code is loaded (fileIn).
    It generates bytecode methods, which are (typically) further translated to machine code by the VM,
    when first executed 
    (although for some architectures, no JITTER is available, and the bytecode will be interpreted, 
     which is of course much slower).
     
    This is not to be confused with the stc-compiler, which generates plain machine code, 
    which is packaged into compiled class libraries and runs with very good performance. 
    Usually, end user applications are deployed as stc-compiled binary code. 
    And only patches or dynamically generated code uses bytecode methods.
    Therefore, the speed of the bytecode interpreter is usually not at all relevant to a deployed app's 
    overall speed (and also not to the ST/X IDE itself, as it also consists of precompiled machine code).

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libcomp class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'exept:ctypes'
        #'stx:libbasic2'    "Text - referenced by Parser>>selectorCheck:for:positions: "
        #'stx:libtool'    "Tools::ToDoListBrowser - referenced by Parser>>selectorCheck:for:positions: "
        #'stx:libview'    "Color - referenced by SyntaxHighlighter>>markParenthesisAt: "
        #'stx:libview2'    "ValueHolder - referenced by Parser>>addDoItTemporary: "
        #'stx:libwidg'    "Workspace - referenced by Parser>>primary_identifier "
        #'stx:libwidg2'    "TextBox - referenced by WarningCompilationErrorHandler>>error:position:to:from: "
        #'stx:goodies/sunit'
        #'stx:goodies/refactoryBrowser/lint'    "RBReadBeforeWrittenTester - referenced by Parser class>>checkMethod:in:ignoreErrors:ignoreWarnings:"
        #'stx:goodies/refactoryBrowser/parser'    "RBAssignmentNode - referenced by Explainer class>>addTypesAssignedToLocal:inTree:to:"
        #'stx:goodies/refactoryBrowser/refactoring'    "RenameTemporaryRefactoring - referenced by Parser::CorrectByInteractiveRename>>fixFrom:to:for:"
        #'stx:libbasic3'    "AbstractSourceCodeManager - referenced by Explainer class>>methodSpecialInfoFor:"
        #'stx:libtool2'    "MethodFinderWindow - referenced by Explainer class>>actionToOpenMethodFinderFor:"
    )

    "Modified: / 16-06-2011 / 15:33:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "CompiledCode - superclass of InstrumentedMethod"
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

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_libcomp class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBCOMP_BASE
LIB_BASE=$(LIBCOMP_BASE)
'
!

stcOptimizationOptions
    ^ '+optinline +optinline2 +inlinenew'

    "Created: / 23-08-2006 / 11:27:31 / cg"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libcomp class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        Breakpoint
        BreakpointDescription
        BreakpointQuery
        CompilationErrorHandler
        CompilationErrorHandlerQuery
        DoNotShowCompilerWarningAgainActionQuery
        DoNotShowCompilerWarningAgainForThisMethodActionQuery
        DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery
        InstrumentationContext
        InstrumentationInfo
        InstrumentedMethod
        LazyMethod
        ObjectFileHandle
        ObjectFileLoader
        ParseError
        ParseNode
        ParseNodeVisitor
        ParseWarning
        ParserFlags
        ProgramNodeBuilder
        ProgramNodeEnumerator
        STCCompilerInterface
        Scanner
        SourceFileLoader
        Structure
        UndefinedVariable
        UndefinedVariableNotification
        Variable
        #'stx_libcomp'
        AssignmentNode
        BlockNode
        BreakpointNode
        CompilationError
        EvalScriptingErrorHandler
        MessageNode
        MethodNode
        ParseErrorNode
        Parser
        PluggableParseNodeVisitor
        PrimaryNode
        ProgramNode
        SelectorNode
        StatementNode
        TextCollectingCompilationErrorHandler
        UndefinedSuperclassError
        UndefinedVariableError
        WarningCompilationErrorHandler
        AbstractSyntaxHighlighter
        BinaryNode
        BreakpointAnalyzer
        ByteCodeCompiler
        CascadeNode
        ConstantNode
        Explainer
        PrimitiveNode
        ReturnNode
        SelfNode
        UnaryNode
        VariableNode
        ByteCodeCompilerWithBreakpointSupport
        CodeCoverageHighlighter
        Decompiler
        ECompletionConstantNode
        InstrumentingCompiler
        SuperNode
        SyntaxHighlighter
        (ParseNodeValidator autoload)
        (Switch autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Object notifyTodo:position:className:selector:severity:priority:equalityParameter:checkAction:
    )
!

xclassNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        Breakpoint
        CompilationErrorHandler
        DoNotShowCompilerWarningAgainActionQuery
        InstrumentedMethod
        LazyMethod
        ObjectFileHandle
        ObjectFileLoader
        ParseNode
        ParserFlags
        ProgramNodeBuilder
        ProgramNodeEnumerator
        STCCompilerInterface
        Scanner
        SourceFileLoader
        Structure
        Switch
        UndefinedVariable
        Variable
        #'stx_libcomp'
        AssignmentNode
        BlockNode
        BreakpointNode
        MessageNode
        Parser
        PrimaryNode
        ProgramNode
        StatementNode
        TextCollectingCompilationErrorHandler
        WarningCompilationErrorHandler
        AbstractSyntaxHighlighter
        BinaryNode
        ByteCodeCompiler
        CascadeNode
        ConstantNode
        Explainer
        ParseErrorNode
        PrimitiveNode
        ReturnNode
        SelfNode
        UnaryNode
        VariableNode
        ByteCodeCompilerWithBreakpointSupport
        CodeCoverageHighlighter
        Decompiler
        ECompletionConstantNode
        InstrumentationInfo
        InstrumentationContext
        InstrumentingCompiler
        SuperNode
        SyntaxHighlighter
        BreakpointDescription
        (ParseNodeValidator autoload)
        (ParseNodeVisitor autoload)
        (MethodNode autoload)
    )

    "Created: / 06-12-2011 / 21:14:23 / cg"
! !

!stx_libcomp class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:29 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Bytecode Compiler'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:17:52 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libcomp class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'exportiert'"$"
! !

!stx_libcomp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id $'
! !

