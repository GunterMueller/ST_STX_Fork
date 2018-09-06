"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

JavaAbstractSourceHighlighter subclass:#JavaSyntaxHighlighter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!

Object subclass:#Indexer
	instanceVariableNames:'index types fields locals'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaSyntaxHighlighter
!

Object subclass:#Marker
	instanceVariableNames:'highlighter'
	classVariableNames:'MARK_KEYWORD MARK_NUMBER MARK_STRING MARK_CHARACTER MARK_COMMENT
		MARK_JAVADOC MARK_KEYWORD_FLOW MARK_SELECTOR MARK_FIELD
		MARK_FIELD_ASSIGNED MARK_LOCAL MARK_CLASS'
	poolDictionaries:''
	privateIn:JavaSyntaxHighlighter
!

!JavaSyntaxHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"
    A syntax highligter for Java. Unlike JavaLexicalHighlighter,
    this one does full parsing (using eclipse compiler) so it is
    slower (expecially when classes are not loader).

    To avoid this initial lag, which is very annoying from UX point
    of view, it temporarily bails out to lexical highlighting.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaSyntaxHighlighter class methodsFor:'formatting'!

formatClassDefinition: code line: line number: lineNr in: cls

    ^self new formatClassDefinition: code line: line number: lineNr in: cls

    "Created: / 12-08-2014 / 13:35:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter methodsFor:'formatting'!

formatClassDefinition:source in:class
    | marker cacheIt document sourceUnit parser tree resolve loader |

    "Optimization - if full class source is to be formatted,
     consult cache - when browsing the code or debugging, very 
     often same same source is to be highlighted"

    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].
    (JavaVM booted not or: [self doLexicalHighlightingOnly]) ifTrue:[
        ^ self format: source string.
    ].

    cacheIt := class notNil and: [class isBehavior and:[class theNonMetaclass isJavaClass]].
    cacheIt ifTrue:[
        document := JavaSourceDocument cachedDocumentFor: class theNonMetaclass.
        document notNil ifTrue:[
            (document sourceText notNil and:[document sourceText string = source]) ifTrue:[
                (sourceIndex notNil and:[document sourceTreeIndex notNil]) ifTrue:[
                     sourceIndex addAll: document sourceTreeIndex.
                     sourceIndex tree:  document sourceTreeIndex tree.
                     sourceIndex source: document sourceText.
                ].
                ^ document sourceText copy.
            ].
        ] ifFalse:[
            document := JavaSourceDocument for: class theNonMetaclass.
            (sourceIndex isNil and:[SmallSense::ParseTreeIndex notNil]) ifTrue:[
                 sourceIndex := SmallSense::ParseTreeIndex new.
            ].
            JavaSourceDocument cachedDocumentFor: class theNonMetaclass put: document.  
            ^ self format: source.
        ].
    ].
    marker := Marker new.
    marker highlighter: self.

    sourceText := source isText 
                    ifTrue:[source copy] 
                    ifFalse:[source asText].



    sourceUnit := (Java classForName:'stx.libjava.tools.Source') new.
    sourceUnit setContents: source string.
    parser := (Java classForName:'stx.libjava.tools.text.Highlighter') new.
    parser setMarker: marker.
    (sourceIndex notNil and:[sourceIndex isKindOf: SmallSense::ParseTreeIndex]) ifTrue:[
        | indexer |

        indexer := Indexer new.
        indexer index: sourceIndex.
        parser setIndexer: indexer.
    ].

    "/ Following is support JImport expecco plugin. For classes loaded by
    "/ JImport plugin, do not resolve classes. The LookupEnvironment cannot
    "/ find them as they are not installed in class registry...
    resolve := class notNil and:[class isJavaClass and:[ (loader := class theNonMetaclass classLoader) isNil or:[loader isJavaObject] ] ].

    tree := parser parse: sourceUnit diet: false resolve: resolve.
    (sourceIndex notNil and:[sourceIndex isKindOf: SmallSense::ParseTreeIndex]) ifTrue:[
        sourceIndex tree: tree. 
        sourceIndex source: sourceText.
    ].

    ^ cacheIt ifTrue:[
        document sourceText: sourceText.
        document sourceTreeIndex: sourceIndex.
        sourceText copy
    ] ifFalse:[
        sourceText
    ]

    "Created: / 04-08-2011 / 23:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:19:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition: code line: line number: lineNr in: cls
    ^ JavaLexicalHighlighter formatClassDefinition: code line: line number: lineNr in: cls

    "Created: / 12-08-2014 / 13:35:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: prefs
    preferences := prefs.
    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].

    JavaMethod showFullSource ifTrue:[
        ^self formatClassDefinition: source in: class
    ].   

    sourceText := source asText.

    self doLexicalHighlightingOnly ifTrue:[
        sourceText := self format: source
    ] ifFalse:[
        | document type parser marker nodes debug |

        JavaVM booted ifFalse:[JavaVM boot].
        document := JavaSourceDocument cachedDocumentFor: class theNonMetaclass.
        document isNil ifTrue:[
            document := JavaSourceDocument for: class theNonMetaclass.
            JavaSourceDocument cachedDocumentFor: class theNonMetaclass put: document.  
        ].


        document resolve.
        type := document sourceTreeForClass: class theNonMetaclass.
        marker := Marker new.
        marker highlighter: self. 
        JavaCompiler synchronized:[
            parser := (Java classForName:'stx.libjava.tools.text.Highlighter') new.
        ].
        parser setMarker: marker.

        debug :=  false.
        nodes := parser parseClassBodyDeclarations: source string unit: document sourceTree copy type: type copy resolve: debug.
        debug ifTrue:[
            nodes inspect.
        ]
    ].
    ^ sourceText

    "Created: / 04-08-2011 / 23:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:19:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences

    ^ JavaLexicalHighlighter formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences

    "Created: / 25-06-2014 / 12:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter methodsFor:'formatting-private'!

format: source
    ^ JavaLexicalHighlighter new format: source

    "Created: / 25-06-2014 / 11:56:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter methodsFor:'queries'!

doLexicalHighlightingOnly
    "/ For now, in debugger always use lexical highlighting. Makes highlighter debugging easier"

    | process wgroups |

    process := Processor activeProcess.
    wgroups := WindowGroup scheduledWindowGroups.
    [ process notNil ] whileTrue:[
        | groups wg application |
        groups := wgroups select:[:wg | wg process == process ].
        groups notEmpty ifTrue:[
            wg := groups detect:[:wg | wg isModal] ifNone:nil.
            wg isNil ifTrue:[
                wg := groups anElement
            ].
            (wg mainView class == DebugView) ifTrue:[ ^ true ].
            (wg mainView notNil and:[(application := wg mainView application) notNil]) ifTrue:[
                application class == (Smalltalk at: #'JDI::DebuggerApplication') ifTrue:[ ^ true ].
                application class == Tools::NewSystemBrowser ifTrue:[ ^ false ].
            ]
        ].
        process := process parentProcess.                    
    ].
    ^ false 

    "Created: / 09-09-2013 / 02:25:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2014 / 13:32:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter::Indexer class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    self lookupObject: JavaLookup instance.


    "/ please change as required (and remove this comment)

    "Modified: / 17-09-2013 / 01:33:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter::Indexer methodsFor:'accessing'!

index
    ^ index
!

index:aParseTreeIndex
    index := aParseTreeIndex.
    types := Dictionary new.
    fields := Dictionary new.
    locals := Dictionary new.

    "Modified: / 24-09-2013 / 02:32:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter::Indexer methodsFor:'indexing'!

add: node from: start to: stop
    | element |

    index add: (element := index newElementFor: node).
    element start: start + 1; stop: stop + 1.
    ^ element

    "Created: / 01-10-2013 / 10:30:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addFieldDeclaration: node from: start to: stop
    | element binding fname previous |

    element := self add: node from: start to: stop.
    binding := node binding.
    binding notNil ifTrue:[
        fname := (binding declaringClass compoundName asStringWith:$/) , '.' , binding name.
        previous := fields at: fname ifAbsent: nil.
        previous notNil ifTrue:[
            previous next: element.
        ].
        fields at: fname put: element.
    ].

    "Created: / 01-10-2013 / 10:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 17:18:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addLocalDeclaration: node from: start to: stop
    | element fname previous |

    element := self add: node from: start to: stop.
    fname := node name.
    previous := locals at: fname ifAbsent: nil.
    previous notNil ifTrue:[
        previous next: element.
    ].
    locals at: fname put: element.

    "Created: / 01-10-2013 / 11:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMessageSend: node from: start to: stop
    self add: node from: start to: stop

    "Created: / 01-10-2013 / 10:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addTypeReference: node from: start to: stop
    | element tname previous |

    element := self add: node from: start to: stop.
    tname := node getTypeName asStringWith: $/.
    previous := types at: tname ifAbsent: nil.
    previous notNil ifTrue:[
        previous next: element.
    ].
    types at: tname put: element.

    "Created: / 01-10-2013 / 10:33:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addVariableReference: node from: start to: stop
    | element binding name previous |

    element := self add: node from: start to: stop.
    binding := node binding.
    binding isNil ifTrue:[ ^ self ].
    "/ ProblemBinding, treat is as a local
    binding problemId ~~ 0 ifTrue:[
        name := binding name.
        previous := locals at: name ifAbsent: nil.
        previous notNil ifTrue:[
            previous next: element.
        ].
        locals at: name put: element.  
        ^ self.              
    ].
    (binding kind bitAnd: 2r100) == 2r100 "TYPE" ifTrue:[
        name := binding compoundName asStringWith: $/.
        previous := types at: name ifAbsent: nil.
        previous notNil ifTrue:[
            previous next: element.
        ].
        types at: name put: element.   
        ^ self.
    ].

    binding kind == 2r001 "FIELD" ifTrue:[
        binding declaringClass isNil ifTrue:[
            name := '???.' , binding name
        ] ifFalse:[
            name := (binding declaringClass compoundName asStringWith:$/) , '.' , binding name.
        ].
        previous := fields at: name ifAbsent: nil.
        previous notNil ifTrue:[
            previous next: element.
        ].
        fields at: name put: element.  
        ^ self.
    ].

    binding kind == 2r010 "LOCAL" ifTrue:[
        name := binding name.
        previous := locals at: name ifAbsent: nil.
        previous notNil ifTrue:[
            previous next: element.
        ].
        locals at: name put: element.  
        ^ self.   
    ].

    self error: 'Should not happen'

    "Created: / 01-10-2013 / 10:33:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2013 / 21:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodEnter: node
    locals := Dictionary new

    "Created: / 01-10-2013 / 10:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodLeave: node

    "Created: / 01-10-2013 / 10:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter::Marker class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "
    !!!! IMPORTANT !!!!!!
    When changing / adding constants, make sure they
    are in sync with those defined in Smaltalk
    stx.libjava.tools.source.JavaSourceMarker !!!!!!
    "

    self lookupObject: JavaLookup instance.
    
    MARK_KEYWORD        := 1.
    MARK_NUMBER         := 2.
    MARK_STRING         := 3.
    MARK_CHARACTER      := 4.
    MARK_COMMENT        := 5.
    MARK_JAVADOC        := 6.
    MARK_KEYWORD_FLOW   := 7.
    MARK_SELECTOR       := 8.
    MARK_FIELD          := 9.
    MARK_FIELD_ASSIGNED := 10.
    MARK_LOCAL          := 11.
    MARK_CLASS          := 12.

    "Modified: / 11-09-2013 / 01:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter::Marker methodsFor:'accessing'!

highlighter:aJavaSourceHighlighter
    highlighter := aJavaSourceHighlighter.
! !

!JavaSyntaxHighlighter::Marker methodsFor:'syntax detection'!

mark: kind from:pos1 to:pos2

    kind == MARK_KEYWORD        ifTrue:[ ^ highlighter markKeywordFrom: pos1 + 1 to: pos2 + 1].
    kind == MARK_KEYWORD_FLOW   ifTrue:[ ^ highlighter markKeywordFlowFrom: pos1 + 1 to: pos2 + 1 ].

    kind == MARK_NUMBER         ifTrue:[ ^ highlighter markConstantFrom: pos1 + 1 to: pos2 + 1 ].
    kind == MARK_STRING         ifTrue:[ ^ highlighter markConstantFrom: pos1 + 1 to: pos2 + 1 ].
    kind == MARK_CHARACTER      ifTrue:[ ^ highlighter markConstantFrom: pos1 + 1 to: pos2 + 1 ].

    kind == MARK_COMMENT        ifTrue:[ ^ highlighter markCommentFrom: pos1 + 1 to: pos2 + 1 ].
    kind == MARK_JAVADOC        ifTrue:[ ^ highlighter markCommentFrom: pos1 + 1 to: pos2 + 1 ].

    kind == MARK_SELECTOR      ifTrue:[ ^ highlighter markSelectorFrom: pos1 + 1 to: pos2 + 1 ].

    "Created: / 05-09-2013 / 03:03:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2013 / 01:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSyntaxHighlighter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaSyntaxHighlighter.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaSyntaxHighlighter::Indexer initialize!
JavaSyntaxHighlighter::Marker initialize!
