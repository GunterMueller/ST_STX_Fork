"{ Package: 'stx:goodies/smaCC' }"

LibraryDefinition subclass:#stx_goodies_smaCC
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_smaCC class methodsFor:'description'!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "PeekableStream - superclass of SmaCC::SmaCCLineNumberStream "
        #'stx:libview2'    "Model - superclass of SmaCC::SmaCCParserGenerator "
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:goodies/refactoryBrowser/changes'    "RefactoryChangeManager - referenced by SmaCC::SmaCCGrammarCompiler>>compileChanges "
        #'stx:goodies/refactoryBrowser/helpers'    "RBClass - referenced by SmaCC::SmaCCParserGenerator>>highlighterClass "
        #'stx:goodies/refactoryBrowser/parser'    "RBVariableNode - referenced by SmaCC::SmaCCRHS>>compileSourceFor:in: "
        #'stx:goodies/sunit'
        #'stx:libbasic'    "Object - superclass of SmaCC::SmaCCScannerCompiler "
        #'stx:libbasic2'    "Text - referenced by SmaCC::SmaCCParserGenerator>>compile: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by SmaCC::SmaCCParserGenerator>>openDocumentation "
        #'stx:libview2'    "ApplicationModel - superclass of SmaCC::SmaCCParserGenerator "
        #'stx:libwidg2'    "TabItem - referenced by SmaCC::SmaCCParserGenerator class>>tabList "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:goodies/refactoryBrowser/changes'    "RefactoryChangeManager - referenced by SmaCC::SmaCCParserGenerator>>compileHighlighter "
        #'stx:goodies/refactoryBrowser/helpers'    "RBNamespace - referenced by SmaCC::SmaCCParserGenerator>>highlighterClass "
        #'stx:goodies/refactoryBrowser/parser'    "RBVariableNode - referenced by SmaCC::SmaCCRHS>>compileSourceFor:in: "
        #'stx:libbasic2'    "Text - referenced by SmaCC::SmaCCParserGenerator>>compile: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by SmaCC::SmaCCParserGenerator>>openDocumentation "
        #'stx:libwidg2'    "TabItem - referenced by SmaCC::SmaCCParserGenerator class>>tabList "
    )
! !

!stx_goodies_smaCC class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (#'SmaCC::CParser' autoload)
        (#'SmaCC::CScanner' autoload)
        (#'SmaCC::JavaParser' autoload)
        (#'SmaCC::JavaScanner' autoload)
        (#'SmaCC::LineNumberStreamTest' autoload)
        #'SmaCC::SmaCCAction'
        #'SmaCC::SmaCCCompilationNotification'
        #'SmaCC::SmaCCEdge'
        #'SmaCC::SmaCCGrammar'
        #'SmaCC::SmaCCGrammarCompiler'
        #'SmaCC::SmaCCItemSet'
        #'SmaCC::SmaCCLR1Item'
        #'SmaCC::SmaCCLineNumberStream'
        #'SmaCC::SmaCCNode'
        #'SmaCC::SmaCCParser'
        #'SmaCC::SmaCCParserError'
        #'SmaCC::SmaCCParserGenerator'
        #'SmaCC::SmaCCRHS'
        #'SmaCC::SmaCCRegularExpressionNode'
        #'SmaCC::SmaCCScanner'
        #'SmaCC::SmaCCScannerCompiler'
        #'SmaCC::SmaCCSymbol'
        #'SmaCC::SmaCCSymbolSet'
        #'SmaCC::SmaCCToken'
        (#'SmaCC::StParser' autoload)
        (#'SmaCC::StScanner' autoload)
        #'stx_goodies_smaCC'
        (#'SmaCC::ParserGeneratorTest' autoload)
        #'SmaCC::SmaCCAcceptAction'
        #'SmaCC::SmaCCAdvancedParser'
        #'SmaCC::SmaCCAdvancedScanner'
        #'SmaCC::SmaCCCharacterRENode'
        #'SmaCC::SmaCCGrammarParser'
        #'SmaCC::SmaCCGrammarScanner'
        #'SmaCC::SmaCCNonTerminalSymbol'
        #'SmaCC::SmaCCOrRENode'
        #'SmaCC::SmaCCReduceAction'
        #'SmaCC::SmaCCRejectAction'
        #'SmaCC::SmaCCRepeatingRENode'
        #'SmaCC::SmaCCScannerParser'
        #'SmaCC::SmaCCScannerScanner'
        #'SmaCC::SmaCCSequenceRENode'
        #'SmaCC::SmaCCShiftAction'
        #'SmaCC::SmaCCTerminalSymbol'
        #'SmaCC::SmaCCStartingSymbol'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_smaCC class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2008\nCopyright eXept Software AG 1998-2008'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_smaCC class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'23M'"$"
! !

!stx_goodies_smaCC class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !

