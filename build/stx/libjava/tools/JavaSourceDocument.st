"{ Package: 'stx:libjava/tools' }"

Object subclass:#JavaSourceDocument
	instanceVariableNames:'javaClass sourceText sourceTree sourceTreeIndex sourceLineEnds
		sourceTreeLock'
	classVariableNames:'Cache CacheSize Job'
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!

!JavaSourceDocument class methodsFor:'documentation'!

documentation
"
    JavaSourceDocument object keeps various useful information about one source 
    file. In particular, it keeps parse tree and pre-highlighted source.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaSourceDocument class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    CacheSize := 25.
    Cache := OrderedCollection new: CacheSize * 2 "To avoid excessive shifting...".
    Job := BackgroundQueueProcessingJob named: 'java parsing job' on:[:block | block value ].

    "Modified: / 06-09-2013 / 17:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument class methodsFor:'instance creation'!

for: aJavaClass
    ^self new javaClass: aJavaClass.

    "Created: / 30-08-2013 / 01:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument class methodsFor:'accessing'!

cachedDocumentFor: aJavaClass
    "Returns a cached document for given class or nil if no cached 
     document is found."

    Cache withIndexDo:[:document :index|
        document javaClass == aJavaClass ifTrue:[
            "/ Move that document towards the end so it'll be less likely
            "/ to be removed
            index < Cache size ifTrue:[
                Cache swap: index with: index + 1.                
            ].
            ^ document.
        ]
    ].
    ^ nil

    "Created: / 30-08-2013 / 01:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cachedDocumentFor: aJavaClass put: aJavaSourceDocument
    "Stores given source document in the cache"

    self assert: aJavaSourceDocument javaClass == aJavaClass.
    Cache size = CacheSize ifTrue:[
        Cache removeFirst.
    ].
    Cache addLast: aJavaSourceDocument

    "Created: / 30-08-2013 / 01:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument methodsFor:'accessing'!

javaClass
    ^ javaClass
!

javaClass:aJavaClass    
    aJavaClass == javaClass ifTrue:[
        ^ self
    ].
    self assert: javaClass isNil message: 'javaClass already set'.
    self assert: aJavaClass isJavaClass message: 'aJavaClass not a Java class'.

    javaClass := aJavaClass.
    self initializeSourceTree.

    "Modified: / 21-09-2013 / 04:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceLineToOffset: lineNr
    lineNr == 1 ifTrue:[ ^ 1 ].
    ^  (sourceLineEnds at: lineNr - 1) + 1.

    "Created: / 08-09-2013 / 10:52:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceOffsetToLine: offset

    |low    "{ Class: SmallInteger}"
     high   "{ Class: SmallInteger}"
     middle "{ Class: SmallInteger}"
     element|

    "
     we can of course use a binary search - since the elements are sorted
    "
    low := 1.
    high := sourceLineEnds size.
    [low > high] whileFalse:[
        middle := (low + high) // 2.
        element := sourceLineEnds at:middle.
        element < offset ifTrue:[
            "middleelement is smaller than object"
            low := middle + 1
        ] ifFalse:[
            high := middle - 1
        ]
    ].
    ^ low

    "Created: / 10-09-2013 / 03:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceText
    ^ sourceText
!

sourceText:aText
    sourceText := aText.
!

sourceTree
    "Return source tree for my class's compilation unit (i.e., CompilationUnitDeclaration)"
    sourceTree isNil ifTrue:[
        sourceTreeLock notNil ifTrue:[
            sourceTreeLock wait.
        ].
    ].
    ^ sourceTree

    "Modified: / 06-09-2013 / 22:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 13-09-2013 / 04:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceTreeForClass
    "Returns a root node (i.e., instance of TypeDeclaration) for my javaClass"

    ^ self sourceTreeForClass: javaClass.

    "Created: / 13-09-2013 / 04:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2013 / 11:08:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceTreeForClass: aJavaClass
    "Returns a root node (i.e., instance of TypeDeclaration) for my javaClass"

    | enclosingClass enclosingClassNode nm |

    enclosingClass := aJavaClass enclosingClass.
    ^ enclosingClass notNil ifTrue:[
        nm := aJavaClass binaryName copyFrom: enclosingClass binaryName size + 2.
        (nm conform: [:c|c isDigit]) ifTrue:[
            "/ Could only by anonymous class created in static initializer
            self error: 'Should not happen'
        ] ifFalse:[
            enclosingClassNode := self sourceTreeForClass: enclosingClass.
            enclosingClassNode memberTypes detect: [:type | type name = nm ] ifNone:[self error:'No member type'].
        ]
    ] ifFalse:[
        nm := aJavaClass lastName.
        sourceTree types detect: [:type | type name = nm] ifNone:[self error:'No type'].
    ].

    "Created: / 13-09-2013 / 11:06:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2013 / 16:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceTreeIndex
    ^ sourceTreeIndex
!

sourceTreeIndex:aParseTreeIndex
    sourceTreeIndex := aParseTreeIndex.
!

sourceTreeOrNilIfParsing
    sourceTree isNil ifTrue:[
        sourceTreeLock notNil ifTrue:[
            ^ nil
        ].
    ].
    ^ sourceTree

    "Created: / 12-09-2013 / 21:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument methodsFor:'debugging'!

inspector2TabParseTreeInspector
    (Smalltalk at:#'SmallSense::ParseNodeInspector') notNil ifTrue:[
        | source |

        source := sourceText notNil ifTrue:[sourceText] ifFalse:[javaClass source].
        ^ Tools::Inspector2Tab new
            label: 'Parse tree';
            priority: 50;
            application: ((Smalltalk at:#'SmallSense::ParseNodeInspector') new
                            node: self sourceTree source: source);
            yourself
    ].
    ^ nil

    "Created: / 19-09-2013 / 18:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 00:58:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2Tabs
    ^ super inspector2Tabs , #(inspector2TabParseTreeInspector)

    "Created: / 19-09-2013 / 18:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument methodsFor:'initialization-private'!

initializeSourceRefsInMethods
    | enclosingMethod typeNode selectorToMethodNodeMap |

    enclosingMethod := javaClass enclosingMethod.
    (enclosingMethod isNil and:[javaClass isAnonymous]) ifTrue:[
        enclosingMethod := javaClass topEnclosingClass compiledMethodAt: #'<clinit>()V'. 
    ].
    enclosingMethod notNil ifTrue:[
        javaClass methodDictionary  keysAndValuesDo: [:selector :method | 
            "/ ensure class is parsed...
            enclosingMethod sourceDocument sourceTree.
            enclosingMethod getSource notNil ifTrue:[
                method setSource: (enclosingMethod getSource).
            ].
        ].
        ^ self
    ].

    "
    SmallSense::ParseNodeInspector openOnNode: typeNode source: javaClass source
    "


    typeNode := self sourceTreeForClass.
    selectorToMethodNodeMap := Dictionary new.
    (typeNode methods ? #()) do:[:method |
        | name descriptor selector |

        name := method selector.
        selector := name = '<clinit>' 
                        ifTrue:[#'<clinit>()V']
                        ifFalse:[(method isConstructor ifTrue:['<init>'] ifFalse:[method selector]) , method binding signature].
        selectorToMethodNodeMap at: selector put: method.
    ].
    javaClass methodDictionary keysAndValuesDo: [:selector :method | 
        | descriptor  methodName  methodNodes  methodNode  source |

        (method isJavaMethod and:[method isSynthetic not]) ifTrue:[
            methodNode := selectorToMethodNodeMap 
                            at: selector 
                            ifAbsent:[ self error: 'Cannot find method node for selector ' , selector ].

            source := JavaSourceRef new.
            source offset: methodNode declarationSourceStart.
            source length: methodNode declarationSourceEnd - methodNode declarationSourceStart + 1.
            source line0: (self sourceOffsetToLine: methodNode declarationSourceStart).
            source lineH: (self sourceOffsetToLine: methodNode sourceStart).
            method setSource: source.
        ].
    ]

    "Created: / 07-09-2013 / 01:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-10-2013 / 09:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSourceTree
    | task |

    sourceTreeLock := Semaphore new.
    "Job add:"
    task := [
        [
            | source  unit  parser |

            source := javaClass theNonMetaclass source.
            source notNil ifTrue: [
                JavaVM booted ifFalse:[JavaVM boot].
                unit := (Java classForName: 'stx.libjava.tools.Source') new.
                unit setContents: source.
                JavaCompiler synchronized:[
                    parser := (Java classForName: 'stx.libjava.tools.parser.Parser') 
                            new.
                ].
                sourceTree := parser parse: unit diet: true"JavaMethod showFullSource not" resolve: true.
                sourceLineEnds := parser scanner getLineEnds.
                self initializeSourceRefsInMethods.
            ].
        ] ensure: [
            sourceTreeLock signal.
            sourceTreeLock := nil.
        ]
    ] newProcess.
    task name: 'Parse task for ', javaClass binaryName.
    task resume.

    "Created: / 06-09-2013 / 17:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2013 / 23:04:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    javaClass printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 12-09-2013 / 01:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument methodsFor:'resolving'!

resolve
    | resolver |

    self sourceTree. "/Ensure source is parsed.
    sourceTree scope isNil ifTrue:[
        resolver := (Java classForName: 'stx.libjava.tools.environment.Resolver') new.
        resolver resolve: sourceTree.
    ].

    "Created: / 12-09-2013 / 22:43:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2013 / 02:19:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceDocument class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaSourceDocument.st,v 1.3 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


JavaSourceDocument initialize!
