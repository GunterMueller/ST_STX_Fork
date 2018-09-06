"
 COPYRIGHT (c) 2015 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

SmalltalkChunkFileSourceWriter subclass:#VSEFileSourceWriter
	instanceVariableNames:'classNameTranslations skipVersionMethods'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

Object subclass:#VSESourceRewriter
	instanceVariableNames:'source method methodClass classNamesToRewrite'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VSEFileSourceWriter
!

!VSEFileSourceWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by eXept Software AG
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
    fileout in a format which can be read by visualAge.
    For transporting software.
"
!

examples
"
                                                        [exBegin]
    |s|

    s := 'test.st' asFilename writeStream.
    [
        VSEChunkFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ]
                                                        [exEnd]

                                                        [exBegin]
    |s|

    s := '' writeStream.
    [
        VSEChunkFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ].
    s contents
                                                        [exEnd]
"
! !

!VSEFileSourceWriter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!VSEFileSourceWriter class methodsFor:'api'!

fileOutPackage:currentProject on:aStream
    self new fileOutPackage:currentProject on:aStream
! !

!VSEFileSourceWriter class methodsFor:'class access'!

vseSourceRewriter
    ^ VSESourceRewriter
! !

!VSEFileSourceWriter class methodsFor:'defaults'!

defaultClassNameTranslations
    "for extensions"

    ^ Dictionary new
        at:#SequenceableCollection put:#IndexedCollection;
        at:#CharacterArray put:#String;
        at:#Unicode16String put:#DoubleByteString;
        at:#UnicodeString put:#DoubleByteString;
        at:#Timestamp put:#TimeStamp;
        at:#ProtoObject put:#Object;
        yourself

    "
     self defaultClassNameTranslations
    "
!

extensionClassesSkipped
    "for classes that do not exist in VSE"

    ^ Set new
        add:Filename;
        yourself

    "
     self extensionClassesSkipped
    "
! !

!VSEFileSourceWriter methodsFor:'accessing'!

skipVersionMethods:aBoolean
    skipVersionMethods := aBoolean.
! !

!VSEFileSourceWriter methodsFor:'initialization'!

initialize
    classNameTranslations := self class defaultClassNameTranslations.
    skipVersionMethods := true.
! !

!VSEFileSourceWriter methodsFor:'utilities'!

ensureNoUnicodeInClass:aClass
    "/ check if we need UTF8 encoding
    aClass withAllPrivateClasses do:[:cls |
         cls instAndClassMethods contains:[:m |
            self ensureNoUnicodeInMethod:m
         ]
    ].
!

ensureNoUnicodeInMethod:aMethod
    |src|

    src := aMethod source.
    src isNil ifTrue:[
        self error:'missing source in ',aMethod whoString
    ].
    src asSingleByteStringIfPossible isWideString ifTrue:[
        self error:(aMethod whoString , ' contains unicode strings or character contants. Cannot be exported to VSE')
    ].
!

extensionMethodsFor:packageID
    |methodsToFileOut|

    methodsToFileOut := OrderedCollection new.
    Smalltalk allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            |mPckg|

            mPckg := mthd package.
            (mPckg = packageID and:[mPckg ~= eachClass package]) ifTrue:[
                (self class extensionClassesSkipped includes:eachClass) ifTrue:[
                    Transcript showCR:'skipped extension: ',mthd whoString.
                ] ifFalse:[
                    methodsToFileOut add:mthd.
                ]
            ]
        ]
    ].
    ^ methodsToFileOut
!

rewrittenClassNameOf:aClass
    |stxName vseName idx|

    stxName := aClass name.
    vseName := classNameTranslations at:stxName ifAbsent:[stxName].
    
    (vseName includesString:'::') ifTrue:[
        idx := vseName indexOfSubCollection:'::'.
        ^ (vseName copyTo:idx-1) , VSESourceRewriter nameSpaceSeparatorReplacement , (vseName copyFrom:idx+2)
    ].
    ^ vseName    
! !

!VSEFileSourceWriter::VSESourceRewriter class methodsFor:'defaults'!

nameSpaceSeparatorReplacement
    ^ '__'
! !

!VSEFileSourceWriter::VSESourceRewriter class methodsFor:'translation'!

rewriteMethod:method 
    ^ self new rewriteMethod:method 
! !

!VSEFileSourceWriter::VSESourceRewriter methodsFor:'accessing'!

classNamesToRewrite:something
    classNamesToRewrite := something.
!

method
    ^ method
!

method:something
    method := something.
!

methodClass
    ^ methodClass
!

methodClass:something
    methodClass := something.
!

source
    ^ source
!

source:something
    source := something.
! !

!VSEFileSourceWriter::VSESourceRewriter methodsFor:'translation'!

checkForOldStyleAssignments
    "check for underscore as assignment token; VSE does not handle those"

    |parser|

    "/ all references to namespace variables
    parser := Parser new.
    parser foldConstants:false.
    parser parserFlags 
        allowOldStyleAssignment:true;
        warnOldStyleAssignment:true.

    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:false.

    parser didWarnAboutOldStyleAssignment ifTrue:[
        self error:'OldStyle assignment. Please rewrite "_" assignments to ":=" in ',method whoString
    ].
    parser didWarnAboutSqueakExtensions ifTrue:[
        self error:'Squeak sytax. Please rewrite "{..}" to "Array with:" in ',method whoString
    ].
!

checkForUnimplementedMessages
    "a naive search for messages which are known to be not implemented,
     and which should be replaced by other messages"

    |parser|

    "/ all references to namespace variables
    parser := Parser new.
    parser foldConstants:false.
    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:true.

    (parser messagesSent includesAny: #( 
            'answer:do:' 
            'ignoreIn:'
            'codePoint'
            'conform:'
            'contains:'
            "/ '->'
    )) ifTrue:[
        self error:('please rewrite ',method whoString,' (unimplemented messages). Or proceed') mayProceed:true
    ].
!

doRewrite
    self checkForOldStyleAssignments.
    self checkForUnimplementedMessages.

    self rewriteEOLComments.
    self rewriteAnnotationsToComments.
    "/ self rewriteGlobalsWithNamespace.
    self rewriteClassReferences.    
    self rewriteExceptionHandlers.    
    self rewriteOtherMessages.
    self rewriteThisContext.
    ^ source.
!

rewriteAnnotationsToComments
    |parser annots|

    parser := Parser new.
    parser foldConstants:false.
    parser saveComments:true.
    parser parseMethod:source in:methodClass ignoreErrors:true ignoreWarnings:true.

    (annots := parser annotationInfo) isEmptyOrNil ifTrue:[^ self].

    Transcript showCR:('- comment out %1 annotations {%1}' bindWith:annots size with:method whoString).

    annots := annots copy sort:[:a :b | a endPosition < b endPosition].
"/ methodClass == SOAP::XeComponent class ifTrue:[self halt].
    "/ last one first, so we don't have to care for changed positions due to insertions
    annots reverseDo:[:annot |
        source := (source copyTo:annot startPosition-1)
                  , '"' , (source copyFrom:annot startPosition to:annot endPosition)
                  , '"' , (source copyFrom:annot endPosition+1).
    ].
!

rewriteClassReferences
    |parser globalsToRename symbolsToRename replacer newSource tree|

    "/ all references to namespace variables
    parser := Parser new.
    parser foldConstants:false.
    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:false.

    globalsToRename := Dictionary new.
    symbolsToRename := Dictionary new.

    parser usedGlobals do:[:eachGlobal |
        |idx nsName clsName|

        (eachGlobal includes:$:) ifTrue:[
            idx := eachGlobal indexOfSubCollection:'::'.   
            nsName := eachGlobal copyTo:idx-1.
            clsName := eachGlobal copyFrom:idx+2.
            globalsToRename at:eachGlobal put:(nsName,(self class nameSpaceSeparatorReplacement),clsName).

            nsName = methodClass nameSpace name ifTrue:[
                globalsToRename at:clsName put:(nsName,(self class nameSpaceSeparatorReplacement),clsName).
            ]
        ] ifFalse:[
            (classNamesToRewrite includesKey:eachGlobal) ifTrue:[
                globalsToRename at:eachGlobal put:(classNamesToRewrite at:eachGlobal).
            ].
        ].
    ].
    parser usedSymbols do:[:eachSymbol |
        |idx nsName clsName|

        (eachSymbol includesString:'::') ifTrue:[
            idx := eachSymbol indexOfSubCollection:'::'.   
            nsName := eachSymbol copyTo:idx-1.
            clsName := eachSymbol copyFrom:idx+2.
            (nsName notEmpty 
                and:[ clsName notEmpty
                and:[ nsName knownAsSymbol
                and:[ (Smalltalk classNamed:nsName) isNameSpace ]]])
            ifTrue:[
                symbolsToRename at:eachSymbol put:(nsName,(self class nameSpaceSeparatorReplacement),clsName) asSymbol.
            ].
        ] ifFalse:[
            (methodClass nameSpace includesKey:eachSymbol asSymbol) ifTrue:[
                symbolsToRename at:eachSymbol put:(methodClass nameSpace name,(self class nameSpaceSeparatorReplacement),eachSymbol) asSymbol.
            ] ifFalse:[
                (classNamesToRewrite includesKey:eachSymbol) ifTrue:[
                    self breakPoint:#cg.
                    globalsToRename at:eachSymbol put:(classNamesToRewrite at:eachSymbol).
                ].
            ].
        ]
    ].
    (globalsToRename isEmpty and:[symbolsToRename isEmpty]) ifTrue:[^ self ].

    Transcript showCR:('- rewrite refs to %1 globals and %2 literal symbols {%3}' 
                                bindWith:globalsToRename size 
                                with:symbolsToRename size
                                with:method whoString).

    replacer := ParseTreeSourceRewriter new.
    replacer alwaysPerformAllSearches:true.

    globalsToRename keysAndValuesDo:[:oldName :newName |
        replacer replaceVariable: oldName with: newName.
    ].
    symbolsToRename keysAndValuesDo:[:oldName :newName |
        replacer replaceLiteral: oldName with: newName.
    ].
    tree := RBParser 
                parseMethod:source
                onError:[:aString :pos | self halt. ^self]. 

    replacer executeTree: tree.
    newSource := replacer executeReplacementsInSource:source.
    "/ self halt.

    "/ to verify, check parsability    
    RBParser 
        parseMethod:newSource
        onError:[:aString :pos | self halt.].           

    source := newSource.
!

rewriteEOLComments
    |tree parser eolComments xlatedComment newSource|

    parser := Parser new.
    parser foldConstants:false.
    parser saveComments:true.
    parser parseMethod:source in:methodClass ignoreErrors:true ignoreWarnings:true.

    tree := parser tree.
    eolComments := parser comments select:[:each | each isEndOfLineComment].
    eolComments notEmpty ifTrue:[
        Transcript showCR:('- rewrite %1 EOL comments {%2}' bindWith:eolComments size with:method whoString).

        "/ start with the last (so I don't have to update the positions)
        eolComments sort:[:a :b | a startPosition < b startPosition].

        eolComments reverseDo:[:each |
            (source at:each endPosition) = $" ifTrue:[
                "/ nothing to do...
            ] ifFalse:[
                xlatedComment := source copyFrom:(each startPosition+2) to:each endPosition.
                (xlatedComment includes:$") ifTrue:[
                    "/ self halt.
                    xlatedComment := xlatedComment copyReplaceAll:$" with:$'.
                ].
                newSource := source copyTo:(each startPosition-1).
                newSource := newSource,'"',xlatedComment,'"'.
                newSource := newSource,(source copyFrom:(each endPosition + 1)).
                source := newSource.
            ].
        ].

        "/ to verify, check parsability    
        RBParser 
            parseMethod:source
            onError:[:aString :pos | self halt.].           
    ].
!

rewriteExceptionHandlers
    |parser replacer newSource tree|

    parser := Parser new. 
    parser foldConstants:false.
    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:false.

    (parser messagesSent includesAny: #( 'answer:do:' 'ignoreIn:' )) ifTrue:[
        self halt
    ].

    replacer := ParseTreeSourceRewriter new.
    replacer alwaysPerformAllSearches:true.

    replacer
        replace:'``@expr subclassesDo: ``@block '
            "->"
           with: ' ``@expr subclasses do: ``@block ';

        replace: ' [| `@temps | ``@.Statements. ] valueNowOrOnUnwindDo: ``@block'
            "->"
           with: ' [| `@temps | ``@.Statements. ] ensure: ``@block';

        replace: ' [| `@temps | ``@.Statements. ] valueOnUnwindDo: ``@block'
            "->"
           with: ' [| `@temps | ``@.Statements. ] ifCurtailed: ``@block';

        replace:' ``@err handle: ``@handler do: ``@expr'
            "->"
           with: ' ``@expr on: ``@err do: ``@handler'.

    tree := RBParser 
        parseMethod:source
        onError:[:aString :pos | self halt. ^ self].

"/((method selector == #'stackTraceFrom:')
"/and:[ methodClass == SOAP::SoPortableUtil class ]) ifTrue:[self halt].

    (replacer executeTree: tree) ifTrue:[
        newSource := replacer executeReplacementsInSource:source copy.
        (newSource ~= source) ifTrue:[
            Transcript showCR:('- rewrote exception handler(s) (%1)' bindWith:method whoString).
            "/ self halt.

            "/ to verify, check parsability    
            RBParser 
                parseMethod:newSource
                onError:[:aString :pos | self halt.].           

            source := newSource.
        ].
    ].
!

rewriteGlobalsWithNamespace
    "obsolete old version - now done in rewriteClassReferences"

    |parser namesToRewrite|

    namesToRewrite := OrderedCollection new.

    parser := Parser new.
    parser foldConstants:false.
    parser saveComments:true.
    parser parseMethod:source in:methodClass ignoreErrors:true ignoreWarnings:true.
    parser tree isNil ifTrue:[ ^ self ].

    parser tree variableNodesDo:[:each |
        |nameInSource|

        each isGlobalVariable ifTrue:[
            (each name includes:$:) ifTrue:[
                nameInSource := source copyFrom:each startPosition to:each endPosition.
                (nameInSource includes:$:) ifTrue:[
                    namesToRewrite add:each.
                ].
            ].
        ].
    ].

    namesToRewrite notEmpty ifTrue:[
        Transcript showCR:('- rewrite %1 refs to globals in namespaces {%2}' bindWith:namesToRewrite size with:method whoString).
    ].

    "/ start with the last (so I don't have to update the positions)
    namesToRewrite sort:[:a :b | a position < b position].
    namesToRewrite reverseDo:[:each |
        |idx nameInSource ns nm|

        nameInSource := source copyFrom:each startPosition to:each endPosition.
        idx := nameInSource indexOf:$:.
        ns := nameInSource copyTo:idx-1.
        idx := nameInSource indexOf:$: startingAt:idx+1.
        nm := nameInSource copyFrom:idx+1.
        (ns = methodClass nameSpace name) ifFalse:[
            Transcript show:'reference to other namespace'.
        ] ifTrue:[
            source := (source copyTo:(each startPosition-1)),nm,(source copyFrom:(each endPosition + 1))
        ].
    ].

    "/ to verify, check parsability    
    RBParser 
        parseMethod:source
        onError:[:aString :pos | self halt.].           
!

rewriteMethod:methodArg 
    method := methodArg.
    source := method source.
    methodClass := method mclass.
    ^ self doRewrite.
!

rewriteOtherMessages
    |parser replacer replaces newSource tree origSource|

    parser := Parser new. 
    parser foldConstants:false.
    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:false.

    (parser messagesSent includesAny: #( 'showCR:' 'lf' 'return' )) ifTrue:[
        self halt
    ].

    replaces := {
                '(Transcript showCR: ``@string)'        ->  '(Transcript show: ``@string; cr) ' .
                '(Character return codePoint)'          ->  '(13)' .
                '(Character lf codePoint)'              ->  '(10)' .
                '(Character return)'                    ->  '(Character value:13)' .
                '(Character lf)'                        ->  '(Character value:10)' .
                }.
    "/ must do each separately, otherwise rewriter gets confused
    origSource := source.
    replaces do:[:each |
        replacer := ParseTreeSourceRewriter new.
        replacer alwaysPerformAllSearches:true.

        replacer replace:each key with:each value.

        tree := RBParser 
            parseMethod:source
            onError:[:aString :pos | self halt. ^ self].

        (replacer executeTree: tree) ifTrue:[
            newSource := replacer executeReplacementsInSource:source copy.
            (newSource ~= source) ifTrue:[
                Transcript showCR:('- rewrote showCR(s) (%1)' bindWith:method whoString).
                "/ self halt.

                "/ to verify, check parsability    
                RBParser 
                    parseMethod:newSource
                    onError:[:aString :pos | self halt.].           

                source := newSource.
            ].
        ].
    ].
!

rewriteThisContext

    |parser replacer newSource tree|

    (source includesString:'thisContext') ifFalse:[
        ^ self
    ].

    "/ self halt.

    parser := Parser new. 
    parser foldConstants:false.
    parser
        parseMethod:source 
        in:methodClass
        ignoreErrors:false
        ignoreWarnings:false.

    replacer := ParseTreeSourceRewriter new.
    replacer alwaysPerformAllSearches:true.

    replacer
        replace:'thisContext'
                "->"
        with:   'nil "thisContext replaced by nil"'
        keepComments:true.

    tree := RBParser 
        parseMethod:source
        onError:[:aString :pos | self halt:'parse error - please check'. ^ self].

"/((method selector == #'stackTraceFrom:')
"/and:[ methodClass == SOAP::SoPortableUtil class ]) ifTrue:[self halt].

    (replacer executeTree: tree) ifTrue:[
        newSource := replacer executeReplacementsInSource:source copy.
        (newSource ~= source) ifTrue:[
            Transcript showCR:('- rewrote thisContext (%1)' bindWith:method whoString).
            "/ self halt.

            "/ to verify, check parsability    
            RBParser 
                parseMethod:newSource
                onError:[:aString :pos | self halt:'rewrite error - please check'].           

            source := newSource.
        ].
    ].
! !

!VSEFileSourceWriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

