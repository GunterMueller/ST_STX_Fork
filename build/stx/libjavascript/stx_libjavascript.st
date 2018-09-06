"
 COPYRIGHT (c) 2006 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libjavascript
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libjavascript class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by Claus Gittinger / eXept Software AG
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

    This library contains a JavaSript Parser/Compiler, generating Smalltalk bytecode.
    It is integrated into the browser, and allows programming in a JavaScript-like
    language in a similar fashion to Smalltalk. 
    (i.e. incremental compilation, debugging, changing code in the debugger etc)

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libjavascript class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:libbasic2'    "Random - referenced by Math class>>randomInteger:_: "
        #'stx:libview'    "Color - referenced by JavaScriptSyntaxHighlighter>>markSelector:from:to:receiverNode:numArgs: "
        #'stx:libview2'    "ApplicationModel - referenced by JavaScriptCodeGeneratorTool>>anyApplicationClassInProjectOf:"
        #'stx:libwidg'    "Workspace - referenced by JavaScriptEnvironment>>doesNotUnderstand:"
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeSearcher - referenced by JavaScriptCodeGeneratorTool>>codeFor_shouldImplementFor:inClass:"
        #'stx:goodies/webServer'    "HTTPService - referenced by JavaScriptCodeGeneratorTool>>createDocumentationMethodFor:"
    )

    "Modified: / 05-07-2018 / 11:46:12 / Stefan Vogel"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "AbstractSourceFileWriter - superclass of JavaScriptSourceFileWriter"
        #'stx:libbasic3'    "HTMLDocGenerator - superclass of HTMLDocGeneratorForJavaScript"
        #'stx:libcomp'    "AssignmentNode - superclass of JavaScriptParser::JavaScriptAssignmentNode"
        #'stx:libtool'    "CodeGeneratorTool - superclass of JavaScriptCodeGeneratorTool"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libjavascript class methodsFor:'description - compilation'!

additionalDefinitions_nt_dot_mak
    ^ '
# see stdHeader_nt for LIBJAVASCRIPT_BASE
LIB_BASE_LD_ARG=-b:$(LIBJAVASCRIPT_BASE)
'
! !

!stx_libjavascript class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        HTMLDocGeneratorForJavaScript
        JavaScriptClass
        JavaScriptClassNode
        JavaScriptCodeGeneratorTool
        JavaScriptCompletionEngine
        JavaScriptConstantNode
        JavaScriptEnvironment
        JavaScriptFunction
        JavaScriptFunctionNode
        JavaScriptMetaclass
        JavaScriptObject
        JavaScriptParseNodeVisitor
        JavaScriptScanner
        JavaScriptSimulatedBrowserEnvironment
        JavaScriptSourceFileWriter
        JavaScriptSourceReader
        JavaScriptVariable
        JavaScriptVariableNode
        Math
        STXJavaScriptLanguage
        #'stx_libjavascript'
        JavaScriptFunctionWithBreakpoints
        JavaScriptInnerFunctionNode
        JavaScriptParseNodeValidator
        JavaScriptParser
        JavaScriptCompiler
        JavaScriptCompletionParser
        JavaScriptSyntaxHighlighter
        JavaScriptCompilerWithBreakpointSupport
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        AbstractTime getHours
        AbstractTime getMinutes
        AbstractTime #'js_add:'
        AbstractTime #'js_addFromTime:'
        AbstractTime #'js_getMilliseconds'
        AbstractTime #'js_getSeconds'
        ArithmeticValue #'js_add:'
        ArithmeticValue #'js_addFromNumber:'
        ArithmeticValue #'js_addFromTime:'
        Behavior #'js_new'
        Behavior #'js_new:'
        Block typeof
        Boolean #'js_asBoolean'
        Boolean typeof
        CharacterArray charAt0:
        CharacterArray charAt1:
        CharacterArray charCodeAt0:
        CharacterArray charCodeAt1:
        CharacterArray indexOf0:
        CharacterArray indexOf1:
        CharacterArray #'js_add:'
        CharacterArray #'js_addFromNumber:'
        CharacterArray #'js_addFromString:'
        CharacterArray #'js_addFromTime:'
        CharacterArray #'js_indexOf:'
        CharacterArray #'js_indexOf:_:'
        CharacterArray #'js_lastIndexOf:'
        CharacterArray #'js_lastIndexOf:_:'
        CharacterArray #'js_split:'
        CharacterArray lastIndexOf0:
        CharacterArray lastIndexOf1:
        CharacterArray quote
        CharacterArray substr0:
        CharacterArray #'substr0:_:'
        CharacterArray substr1:
        CharacterArray #'substr1:_:'
        CharacterArray substring0:
        CharacterArray #'substring0:_:'
        CharacterArray substring1:
        CharacterArray #'substring1:_:'
        CharacterArray toLowerCase
        CharacterArray toUpperCase
        CharacterArray trim
        CharacterArray trimLeft
        CharacterArray trimRight
        CharacterArray typeof
        Collection forEach:
        Collection length
        False #'js_not'
        Integer #'js_asBoolean'
        Integer #'js_not'
        Number toExponential:
        Number #'toExponential:_:'
        Number toFixed:
        Number typeof
        Object #'js_addFromString:'
        Object #'js_asBoolean'
        Object #'js_at:'
        Object #'js_at:put:'
        Object #'js_length'
        Object #'js_new'
        Object #'js_new:'
        Object typeof
        ParseNode isBreakStatement
        SequenceableCollection concat:
        SequenceableCollection doesNotUnderstand:
        SequenceableCollection every:
        SequenceableCollection filter:
        SequenceableCollection indexOf0:
        SequenceableCollection indexOf1:
        SequenceableCollection join:
        SequenceableCollection #'js_add:'
        SequenceableCollection #'js_concat'
        SequenceableCollection #'js_concat:'
        SequenceableCollection #'js_concat:_:'
        SequenceableCollection #'js_concat:_:_:'
        SequenceableCollection #'js_concat:_:_:_:'
        SequenceableCollection #'js_concat:_:_:_:_:'
        SequenceableCollection #'js_concat:_:_:_:_:_:'
        SequenceableCollection #'js_indexOf:'
        SequenceableCollection #'js_indexOf:_:'
        SequenceableCollection #'js_lastIndexOf:'
        SequenceableCollection #'js_lastIndexOf:_:'
        SequenceableCollection #'js_map:'
        SequenceableCollection lastIndexOf0:
        SequenceableCollection lastIndexOf1:
        SequenceableCollection pop
        SequenceableCollection push:
        SequenceableCollection reduce0:
        SequenceableCollection #'reduce0:_:'
        SequenceableCollection reduce1:
        SequenceableCollection #'reduce1:_:'
        SequenceableCollection shift
        SequenceableCollection #'slice0:_:'
        SequenceableCollection #'slice1:_:'
        SequenceableCollection some:
        SequenceableCollection unshift:
        Signal #'js_add:'
        SignalSet #'js_add:'
        Stream log:
        Stream #'show:_:'
        Stream #'show:_:_:'
        Stream #'show:_:_:_:'
        Stream #'show:_:_:_:_:'
        Stream #'show:_:_:_:_:_:'
        Stream #'show:_:_:_:_:_:_:'
        Stream #'showCR:_:'
        Stream #'showCR:_:_:'
        Stream #'showCR:_:_:_:'
        Stream #'showCR:_:_:_:_:'
        Stream #'showCR:_:_:_:_:_:'
        Stream #'showCR:_:_:_:_:_:_:'
        Timestamp getDate
        Timestamp getDay
        Timestamp getFullYear
        Timestamp getMonth
        True #'js_not'
        UndefinedObject typeof
        'Collection class' #'with:_:'
        'Collection class' #'with:_:_:'
        'Collection class' #'with:_:_:_:'
        'Collection class' #'with:_:_:_:_:'
        'Collection class' #'with:_:_:_:_:_:'
        'Collection class' #'with:_:_:_:_:_:_:'
        'Collection class' #'with:_:_:_:_:_:_:_:'
        'Date class' #'js_new:'
        'Date class' now
        'GenericException class' #'js_add:'
        'GenericException class' #'js_new:'
        'Number class' #'MAX_VALUE'
        'Number class' #'MIN_VALUE'
        'Number class' #'NEGATIVE_INFINITY'
        'Number class' NaN
        'Number class' #'POSITIVE_INFINITY'
        'Number class' #'js_new:'
        'String class' fromCharCode:
    )
! !

!stx_libjavascript class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:09 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X JavaScript Bytecode Compiler'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 2012\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:18:42 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libjavascript class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/stx_libjavascript.st,v 1.63 2018-08-31 10:00:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/stx_libjavascript.st,v 1.63 2018-08-31 10:00:59 cg Exp $'
! !

