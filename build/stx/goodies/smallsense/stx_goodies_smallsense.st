"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_smallsense
	instanceVariableNames:''
	classVariableNames:'Swizzled'
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_smallsense class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    Package documentation:

    Jan Vrany's productivity tools for the Smalltalk code editor.
    Includes different code completion engine, bracket insertion and other enhancements.
"
! !

!stx_goodies_smallsense class methodsFor:'accessing - tests'!

excludedFromTestSuite
    "List of testcases and/or tests excluded from testsuite.
     Entries maybe ClassName or #(ClassName testName)
    "
    ^ #(
        #'SmallSense::BaseTestClass'
        #'SmallSense::TestCase'
        #'SmallSense::FinderTests'
        #'SmallSense::RecognizerTests'
        #'SmallSense::SmalltalkParserTests'
    )

    "Created: / 23-05-2014 / 12:49:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

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
        #'stx:goodies/refactoryBrowser/helpers'    "BrowserEnvironment - superclass of SmallSense::SmalltalkUnacceptedMethodEnvironment"
        #'stx:goodies/refactoryBrowser/lint'    "RBBasicLintRule - extended"
        #'stx:goodies/refactoryBrowser/parser'    "RBBlockNode - extended"
        #'stx:goodies/regex'    "Regex::RxCharSetParser - superclass of SmallSense::TokenPatternParser::TokenSpecParser"
        #'stx:libbasic'    "Collection - extended"
        #'stx:libcomp'    "AbstractSyntaxHighlighter - superclass of SmallSense::SmalltalkParser"
        #'stx:libhtml'    "HTMLDocumentFrame - extended"
        #'stx:libtool'    "AbstractSettingsApplication - superclass of SmallSense::SettingsAppl"
        #'stx:libview'    "DisplaySurface - extended"
        #'stx:libview2'    "ApplicationModel - extended"
        #'stx:libwidg'    "DialogBox - extended"
        #'stx:libwidg2'    "AbstractHierarchicalItem - superclass of SmallSense::ClassPO"
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
        #'stx:goodies/refactoryBrowser/changes'    "CompositeRefactoryChange - referenced by Tools::NewSystemBrowser>>stx_goodies_smallsense_categoryMenuRename"
        #'stx:libbasic2'    "BackgroundJob - referenced by SmallSense::AbstractListDialog>>initialize"
        #'stx:libbasic3'    "ChangeSet - referenced by RBContainsSmalltalkXEOLCommentRule>>fixes:"
        #'stx:libjava'    "Java - referenced by SmallSense::JavaCompletionEngine>>complete"
        #'stx:libjava/tools'    "GroovyScanner - referenced by SmallSense::GroovyCompletionEngineSimple>>scannerClass"
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

!stx_goodies_smallsense class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SmallSense::AbstractDIalog'
        #'SmallSense::AbstractSearchProcessor'
        #'SmallSense::CodeHighlightingService'
        #'SmallSense::CodeNavigationService'
        #'SmallSense::CompletionContext'
        #'SmallSense::CompletionController'
        #'SmallSense::CompletionEngine'
        #'SmallSense::CompletionResult'
        #'SmallSense::CompletionView'
        #'SmallSense::CriticsWindow'
        #'SmallSense::EditService'
        #'SmallSense::EditSupport'
        #'SmallSense::Info'
        #'SmallSense::Manager'
        #'SmallSense::NavigatorStep'
        #'SmallSense::PO'
        #'SmallSense::ParseTreeIndex'
        #'SmallSense::ParseTreeIndexEntry'
        #'SmallSense::ParseTreeInspector'
        #'SmallSense::SelectorNode'
        #'SmallSense::SettingsAppl'
        #'SmallSense::SmalltalkChecker'
        #'SmallSense::SmalltalkInferencerParameters'
        #'SmallSense::SmalltalkLintService'
        #'SmallSense::SmalltalkParseNodeVisitor'
        #'SmallSense::SmalltalkParser'
        #'SmallSense::SmalltalkQuickFixer'
        #'SmallSense::SmalltalkSyntaxHighlighter'
        #'SmallSense::SmalltalkUnacceptedMethodEnvironment'
        #'SmallSense::TokenPatternMatcher'
        #'SmallSense::TokenPatternParser'
        #'SmallSense::TokenPatternToken'
        #'SmallSense::TokenPatternTokenSet'
        #'SmallSense::TokenStream'
        #'SmallSense::Type'
        #'SmallSense::TypeHolder'
        #'stx_goodies_smallsense'
        #'SmallSense::AbstractJavaCompletionEngine'
        #'SmallSense::AbstractListDialog'
        #'SmallSense::ClassInfo'
        #'SmallSense::ClassPO'
        #'SmallSense::ClassSearchProcessor'
        #'SmallSense::ClassType'
        #'SmallSense::CompositeProcessor'
        #'SmallSense::ConstantPO'
        #'SmallSense::GenericEditSupport'
        #'SmallSense::ImplementorSearchProcessor'
        #'SmallSense::JavaEditSupport'
        #'SmallSense::JavaImportPO'
        #'SmallSense::MethodBindingPO'
        #'SmallSense::MethodInfo'
        #'SmallSense::MethodPO'
        #'SmallSense::PackagePO'
        #'SmallSense::PluggablePO'
        #'SmallSense::PluggableSearchProcessor'
        #'SmallSense::SmalltalkCompletionEngine'
        #'SmallSense::SmalltalkEditSupport'
        #'SmallSense::SmalltalkInferencer'
        #'SmallSense::SmalltalkParseNodeFinder'
        #'SmallSense::SnippetPO'
        #'SmallSense::UnionType'
        #'SmallSense::UnknownType'
        #'SmallSense::VariableBindingPO'
        #'SmallSense::VariablePO'
        #'SmallSense::AbstractJavaCompletionEngineSimple'
        #'SmallSense::AbstractSearchDialog'
        #'SmallSense::AbstractSelectDialog'
        #'SmallSense::GroovyEditSupport'
        #'SmallSense::JavaCompletionEngine'
        #'SmallSense::JavaConstructorPO'
        #'SmallSense::MethodKeywordRestPO'
        #'SmallSense::CetegoryOrProtocolSelectDialog'
        #'SmallSense::ClassSearchDialog'
        #'SmallSense::JavaCompletionEngineSimple'
        #'SmallSense::MethodSearchDialog'
        #'SmallSense::Navigator'
        #'SmallSense::PackageSelectDialog'
        #'SmallSense::CategorySelectDialog'
        #'SmallSense::GroovyCompletionEngineSimple'
        #'SmallSense::ProtocolSelectDialog'
        (#'SmallSense::AbstractJavaCompletionEngineTests' autoload)
        (#'SmallSense::AbstractTestCase' autoload)
        (#'SmallSense::BaseTestClass' autoload)
        (#'SmallSense::CompletionEngineTests' autoload)
        (#'SmallSense::EditSupportTests' autoload)
        (#'SmallSense::FinderTests' autoload)
        (#'SmallSense::GroovyCompletionEngineSimpleTests' autoload)
        (#'SmallSense::JavaCompletionEngineEnvironmentResource' autoload)
        (#'SmallSense::JavaCompletionEngineTests' autoload)
        (#'SmallSense::JavaEditSupportTests' autoload)
        (#'SmallSense::RecognizerTests' autoload)
        (#'SmallSense::SmalltalkCompletionEngineTests' autoload)
        (#'SmallSense::SmalltalkEditSupportTests' autoload)
        (#'SmallSense::SmalltalkInferencerTests' autoload)
        (#'SmallSense::SmalltalkParserTests' autoload)
        (#'SmallSense::TestCase' autoload)
        (#'SmallSense::TokenPatternMatcherTests' autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        ParseNode isSelector
        AssignmentNode childNamesAndValuesDo:
        AssignmentNode inferedType
        AssignmentNode inferedType:
        MessageNode childNamesAndValuesDo:
        ParseErrorNode childNamesAndValuesDo:
        ParseNode childNamesAndValuesDo:
        ParseNode inferedType
        ParseNode inferedType:
        PrimaryNode childNamesAndValuesDo:
        StatementNode childNamesAndValuesDo:
        StatementNode inferedType
        StatementNode inferedType:
        UserPreferences smallSenseEnabled
        UserPreferences smallSenseEnabled:
        VariableNode isGlobalOrPrivateClass
        'ConfigurableFeatures class' hasSmallSenseEnabled
        UserPreferences smallSenseBackgroundLintEnabled
        UserPreferences smallSenseBackgroundLintEnabled:
        RBLintRule fixes:
        RBTransformationRule fixes:
        UserPreferences smallSenseBackgroundTypingEnabled
        UserPreferences smallSenseBackgroundTypingEnabled:
        HTMLDocumentView doQuickFix:
        'Tools::CodeHighlightingService class' new
        BlockNode childNamesAndValuesDo:
        'Tools::CodeNavigationService class' new
        ParseNode navigateToUsing:
        MessageNode navigateToUsing:
        VariableNode navigateToUsing:
        EditTextView autoIndent
        #'Tools::NewSystemBrowser' #'searchCompletionBlock_SmallSense'
        #'Tools::NewSystemBrowser' smallSenseSearchCompletion:
        #'Tools::NewSystemBrowser' smallSenseSearchCompletionBlock
        #'Tools::NewSystemBrowser' smallSenseSearchCompletionEntryForClass:showPrefix:
        #'Tools::NewSystemBrowser' smallSenseSearchCompletionNewForClass:
        PrimitiveNode inferedType
        UserPreferences smallSenseCompleteIfUnambiguous
        UserPreferences smallSenseCompleteIfUnambiguous:
        UserPreferences smallSenseCompletionEnabled
        UserPreferences smallSenseCompletionEnabled:
        ReturnNode childNamesAndValuesDo:
        'Tools::NewSystemBrowser class' #'stx_goodies_smallsense_askForClassToSearch:single:msgTail:resources:filter:forBrowser:thenDo:'
        UserPreferences smallSenseNewDialogsEnabled
        UserPreferences smallSenseNewDialogsEnabled:
        UserPreferences smallSenseSmalltalkIndentOnPasteEnabled
        UserPreferences smallSenseSmalltalkIndentOnPasteEnabled:
        EditTextViewCompletionSupport isCompletionViewShown
        #'Tools::NavigationState' #'stx_goodies_smallsense_selectedClasses'
        Method inspector2TabSTXParseTreeInspector
        ParseNode inspector2TabSTXParseTreeInspector
        Parser inspector2TabSTXParseTreeInspector
        Method inspector2TabRBParseTreeInspector
        RBBlockNode childNamesAndValuesDo:
        RBMethodNode childNamesAndValuesDo:
        RBProgramNode childNamesAndValuesDo:
        RBProgramNode endPosition
        RBProgramNode startPosition
        RBContainsSmalltalkXEOLCommentRule fixes:
        'DialogBox class' #'stx_goodies_smallsense_requestProject:from:initialAnswer:suggestions:'
        'Tools::CodeCompletionService class' new
        #'Tools::LintService' buttonPress:x:y:in:
        #'Tools::LintService' showInfoWindowForLine:
        InspectorView preRealize
        #'Tools::NewSystemBrowser' #'stx_goodies_smallsense_askForMethodCategory:title:okLabel:list:recentList:initialAnswer:'
        #'Tools::NewSystemBrowser' searchMenuOpenNavigatorOnDeclarations
        DebugView processShortcut:
        #'Tools::Inspector2' processShortcut:
        WorkspaceApplication processShortcut:
        #'Tools::NewSystemBrowser' processShortcut:
        UserPreferences smallSenseSmalltalkIterationVariableNameMaxLength
        UserPreferences smallSenseSmalltalkIterationVariableNameMaxLength:
        UserPreferences smallSenseSmalltalkIterationVariableNamePrefixWithEach
        UserPreferences smallSenseSmalltalkIterationVariableNamePrefixWithEach:
        UserPreferences smallSenseElectricEditSupportEnabled
        UserPreferences smallSenseElectricEditSupportEnabled:
        #'Tools::NewSystemBrowser' #'stx_goodies_smallsense_categoryMenuRename'
        RBMethod inspector2TabRBParseTreeInspector
        RBMethodNode inspector2TabRBParseTreeInspector
    )
! !

!stx_goodies_smallsense class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Vrany'

    "Modified: / 17-07-2014 / 22:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X IDE Productivity Tool'

    "Modified: / 17-07-2014 / 23:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2013-2014'

    "Modified: / 17-07-2014 / 22:57:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'SmallSense'

    "Modified: / 17-07-2014 / 23:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "

    ^ '$URL: https://vranyj1@swing.fit.cvut.cz/svn/stx/libtool/branches/jv/smallsense/stx_goodies_smallsense.st $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'7962            '"$"
! !

!stx_goodies_smallsense class methodsFor:'swizzling'!

swizzle
    "Swizzle all methods annotated as <swizzle:>"


    Swizzled == true ifTrue:[ ^ self ].
    ParserFlags initialize.
    self extensionMethods do:[:m |
        [
            self swizzle: m.
        ] on: Error do:[:ex |
            Logger error: 'Cannot swizzle %1: %2' with: m selector with: ex description.
            Debugger enter.
        ].
    ].
    Swizzled := true.


    "
    stx_goodies_smallsense swizzle
    Swizzled := false.

    self extensionMethods select:[:m | m notNil and:[ (m annotationAt: #swizzle:) notNil or:[(m annotationAt: #swizzle:checksum:) notNil ] ] ]
    "

    "Created: / 19-08-2013 / 14:54:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 23:36:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

swizzle: method
    "Swizzle the method if it is annotated by <swizzle:> annotation"

    | annotation |


    annotation := method annotationAt: #swizzle:.
    annotation notNil ifTrue:[
    	self swizzle: method as: (annotation argumentAt: 1).
        ^ self
    ].
    annotation := method annotationAt: #swizzle:checksum:.
    annotation notNil ifTrue:[
        self swizzle: method as: (annotation argumentAt: 1) checksum: (annotation argumentAt: 2)
    ].

    "Created: / 19-08-2013 / 14:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2014 / 00:23:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

swizzle: swizzlingMethod as: selector
    "Given an extension method, swizzle it into method's class
     under given selector."

    ^ self swizzle: swizzlingMethod as: selector checksum: nil

    "Created: / 19-08-2013 / 14:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2014 / 00:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

swizzle: swizzlingMethod as: selector checksum: expectedSHA
    "Given an extension method, swizzle it into method's class
     under given selector.

     If `expectedSHA` is not nil, compare SHA1 hashes of swizzledMethod
     source and issue a warning when checksum does not match - which
     means somebody changed that method meanwhile and we should
     validate/update swizzlling method"

    | cls shadowedMethod shadowedMethodSHA shadowedMethodProjectDefinition shadowedMethodCopy swizzledForwarderMethodSource swizzledForwarderMethod |

    cls := swizzlingMethod mclass.
    shadowedMethod := cls compiledMethodAt: selector.
    shadowedMethod isNil ifTrue:[
        "/ Oops, method gone?
        self breakPoint: #jv.
        ^ self.
    ].

    self assert: swizzlingMethod numArgs == shadowedMethod numArgs.
    self assert: (swizzlingMethod selector startsWith: self name , '_').

    expectedSHA notNil ifTrue:[
        | src |

        src := shadowedMethod source.
        src notNil ifTrue:[
            shadowedMethodSHA := SHA1Stream new nextPutAll: src; hashValue.
            shadowedMethodSHA = expectedSHA ifFalse:[
                Logger error: 'Overwritten method checksum for: %1 does not match %2' with: shadowedMethod selector with: expectedSHA
            ].
        ].
    ].

    "/ Save shadowedMethod to project...
    shadowedMethodProjectDefinition := ProjectDefinition definitionClassForPackage: shadowedMethod package.
    shadowedMethodProjectDefinition rememberOverwrittenMethod:shadowedMethod inClass: shadowedMethod mclass.


    swizzledForwarderMethodSource := String streamContents:[ :s |
    	| selector keywords |

    	selector := shadowedMethod selector.
    	selector numArgs > 0 ifTrue:[
    	    keywords := selector keywords.
            keywords withIndexDo:[ :keyword :index |
                s nextPutAll: keyword; space; nextPutAll: 'arg'; nextPutAll: index printString; space.
            ].
    	] ifFalse:[
    	    s nextPutAll: selector; cr.
    	].

        s cr.
        s nextPutLine: '    "This method has been swizled by SmallSense, forwarding to SmallSense implementation"'.
        s nextPutAll:  '    ^ self '; nextPutAll: self name; nextPut: $_.
        selector numArgs > 0 ifTrue:[
            keywords withIndexDo:[ :keyword :index |
                s nextPutAll: keyword; space; nextPutAll: 'arg'; nextPutAll: index printString; space
            ].
    	] ifFalse:[
    	    s nextPutAll: selector.
    	].
    	s cr.

    ].

    "/ Stdout nextPutAll: '>>>'; nextPutLine: selector.
    "/ Stdout nextPutLine: '----'.
    "/ Stdout nextPutLine: swizzledForwarderMethodSource.
    "/ Stdout nextPutLine: '----'.


    shadowedMethodCopy := shadowedMethod copy.
    shadowedMethodCopy setPackage: #__swizzled__.
    shadowedMethodCopy setCategory: shadowedMethod category.
    shadowedMethodCopy source: ((shadowedMethod package copyReplaceAll: $: with: $_) replaceAll: $/ with: $_) , '_' , shadowedMethod source.
    shadowedMethod mclass
        basicAddSelector: (((shadowedMethod package copyReplaceAll: $: with: $_) replaceAll: $/ with: $_) , '_' , shadowedMethod selector) asSymbol
        withMethod: shadowedMethodCopy.


    "/ Install the swizzled method
    "/ Stdout nextPutLine: '^^^ Compiling'.
    swizzledForwarderMethod := ByteCodeCompiler compile: swizzledForwarderMethodSource forClass: cls install: false.
    swizzledForwarderMethod category: shadowedMethod category.
    swizzledForwarderMethod package: shadowedMethodCopy package.
    cls basicAddSelector:selector withMethod:swizzledForwarderMethod.

    "/ Stdout nextPutLine: '^^^ Compiled'.

    "Created: / 10-05-2014 / 00:23:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2014 / 15:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

swizzled
    "Return true, if methods has been swizled"

    ^ Swizzled == true

    "Created: / 12-01-2015 / 06:53:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/smallsense/stx_goodies_smallsense.st,v 1.2 2015-02-03 22:23:33 cg Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/smallsense/stx_goodies_smallsense.st, Version: 1.0, User: cg, Time: 2015-02-03T23:23:58.941+01$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: stx_goodies_smallsense.st,v 1.2 2015-02-03 22:23:33 cg Exp $'
! !

