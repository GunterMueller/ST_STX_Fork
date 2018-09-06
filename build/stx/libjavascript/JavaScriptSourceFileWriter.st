"
 COPYRIGHT (c) 2004 by eXept Software AG
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

AbstractSourceFileWriter subclass:#JavaScriptSourceFileWriter
	instanceVariableNames:'classBeingSaved'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

!JavaScriptSourceFileWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptSourceFileWriter class methodsFor:'utilities - source code'!

methodTemplate
    |s|

    s := TextStream on:''.

    s emphasis:(UserPreferences current commentEmphasisAndColor).
    s nextPutAll:
'//
// comment stating purpose of this method
//'.
    s emphasis:nil.
    s nextPutAll:
'
function name ( arg1 , ... )
{
    var temp1, ...  ;

    statement;
    statement;
}
'.

    s cr.
    s emphasis:(UserPreferences current commentEmphasisAndColor).
    s nextPutAll:
'// change the above template into real code;
// remove this comment.
// Then `accept'' either via the menu
// or via the keyboard (usually CMD-A).

// You do not need this template; you can also
// select any existing methods code, change it,
// and finally `accept''. The method will then be
// installed under the selector as defined in the
// actual text - no matter which method is selected
// in the browser, or where the original text came from.

// Or clear this text, type in the method from scratch
// and install it with `accept''.
'.

    ^ s contents
!

versionMethodTemplateForCVS
    "careful to avoid expansion by cvs here!!"

    ^ ('function version() {\    return ("$' , 'Header$");\}') withCRs

    "Created: / 21-08-2012 / 11:52:59 / cg"
! !

!JavaScriptSourceFileWriter methodsFor:'fileout'!

fileOut:aClass on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move.
     todo: code duplication with SmalltalkChunkSourceFileWriter - please refactor"

    |meta nonMeta outStream copyrightMethod copyrightText comment collectionOfCategories 
     versionMethods extensionVersionMethods classesImplementingInitialize
     allMetaClassSelectors versionSelectors extensionVersionSelectors
     allVersionMethods|

    self todo:'code duplication with SmalltalkChunkSourceFileWriter - please refactor'.

    nonMeta := aClass theNonMetaclass.
    meta := nonMeta class.

    encoderOrNil isNil ifTrue:[
        outStream := outStreamArg.
    ] ifFalse:[
        outStream := EncodedStream stream:outStreamArg encoder:encoderOrNil.
        outStream nextPutAll:'// Encoding: ' , encoderOrNil nameOfEncoding; cr; cr.
    ].

    (copyrightMethod := meta compiledMethodAt:#copyright) notNil ifTrue:[
        "
         get the copyright methods source,
         and insert at beginning.
        "
        copyrightText := copyrightMethod source.
        copyrightText isNil ifTrue:[
            "
             no source available - trigger an error
            "
            ClassDescription fileOutErrorSignal
                raiseRequestWith:nonMeta
                errorString:('no source for class ' , nonMeta name , ' available. Cannot fileOut').
            ^ self
        ].
        "
         strip off the selector-line
        "
        copyrightText := copyrightText asCollectionOfLines asStringCollection.
        copyrightText := copyrightText copyFrom:2 to:(copyrightText size).
        copyrightText := copyrightText asString.
        outStream nextPutAll:copyrightText.
        outStream cr.
    ].

    stampIt ifTrue:[
        "/
        "/ first, a timestamp
        "/
        outStream nextPutAll:'// '.
        outStream nextPutAll:(Smalltalk timeStamp).
        outStream cr; cr.
    ].

    withDefinition ifTrue:[
        "/
        "/ then the definition(s)
        "/
        self fileOutAllDefinitionsOf:nonMeta on:outStream.
        "/
        "/ a comment - if any
        "/
        (comment := nonMeta comment) notNil ifTrue:[
            outStream nextPutLine:'// '.
            comment asCollectionOfLines do:[:eachLine |
                outStream nextPutAll:'// '.
                outStream nextPutLine:eachLine.
            ].
            outStream nextPutLine:'// '.
        ].
    ].

    "/
    "/ methods from all categories in metaclass (i.e. class methods)
    "/ EXCEPT: the version method is placed at the very end, to
    "/         avoid sourcePosition-shifts when checked out later.
    "/         (RCS expands this string, so its size is not constant)
    "/
    collectionOfCategories := meta categories asSortedCollection.

    allMetaClassSelectors := meta methodDictionary keys.
    versionSelectors := allMetaClassSelectors select:[:selector | AbstractSourceCodeManager isVersionMethodSelector:selector ].
    versionMethods := versionSelectors collect:[:eachSelector | meta methodDictionary at:eachSelector].
    extensionVersionSelectors := allMetaClassSelectors select:[:selector | AbstractSourceCodeManager isExtensionsVersionMethodSelector:selector ]. 
    extensionVersionMethods := extensionVersionSelectors collect:[:eachSelector | meta methodDictionary at:eachSelector].
    allVersionMethods := Set new addAll:versionMethods; addAll:extensionVersionMethods; yourself.

    collectionOfCategories notNil ifTrue:[
        "/
        "/ documentation first (if any), but not the version method
        "/
        (collectionOfCategories includes:'documentation') ifTrue:[
            self fileOutCategory:'documentation' of:meta except:allVersionMethods only:nil methodFilter:methodFilter on:outStream.
        ].

        "/
        "/ initialization next (if any)
        "/
        (collectionOfCategories includes:'initialization') ifTrue:[
            self fileOutCategory:'initialization' of:meta methodFilter:methodFilter on:outStream.
        ].

        "/
        "/ instance creation next (if any)
        "/
        (collectionOfCategories includes:'instance creation') ifTrue:[
            self fileOutCategory:'instance creation' of:meta methodFilter:methodFilter on:outStream.
        ].
        collectionOfCategories do:[:aCategory |
            ((aCategory ~= 'documentation')
            and:[(aCategory ~= 'initialization')
            and:[aCategory ~= 'instance creation']]) ifTrue:[
                self fileOutCategory:aCategory of:meta methodFilter:methodFilter on:outStream.
            ]
        ]
    ].

    "/
    "/ methods from all categories
    "/
    collectionOfCategories := nonMeta categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:nonMeta methodFilter:methodFilter on:outStream.
        ]
    ].

    "/
    "/ any private classes' methods
    "/
    nonMeta privateClassesSorted do:[:eachPrivateClass |
        self fileOutAllMethodsOf:eachPrivateClass on:outStream methodFilter:methodFilter
    ].


    "/
    "/ finally, the previously skipped version method (but not the extensionsVersion methods!!)
    "/
    versionMethods notEmpty ifTrue:[
        self fileOutCategory:'documentation' of:meta except:nil only:versionMethods methodFilter:methodFilter on:outStream.
    ].

    initIt ifTrue:[
        "/
        "/ optionally an initialize message
        "/
        classesImplementingInitialize := OrderedCollection new.

        (meta includesSelector:#initialize) ifTrue:[
            classesImplementingInitialize add:nonMeta
        ].
        nonMeta privateClassesSorted do:[:aPrivateClass |
            (aPrivateClass theMetaclass includesSelector:#initialize) ifTrue:[
                classesImplementingInitialize add:aPrivateClass
            ]
        ].
        classesImplementingInitialize size ~~ 0 ifTrue:[
            classesImplementingInitialize topologicalSort:[:a :b | b isSubclassOf:a].
            classesImplementingInitialize do:[:eachClass |
                outStream nextPutLine:'// #initialize: '.
                outStream nextPutAll:'// '. eachClass printClassNameOn:outStream. 
                outStream nextPutLine:'.initialize()'.
            ].
        ].
    ]
!

fileOutAllDefinitionsOf:aClass on:aStream
    "append expressions on aStream, which defines myself and all of my private classes."

    aClass fileOutDefinitionOn:aStream.
    aStream cr; cr.

    "/
    "/ optional classInstanceVariables
    "/
    aClass class instanceVariableString isBlank ifFalse:[
        self breakPoint:#expecco.
        aClass fileOutClassInstVarDefinitionOn:aStream.
        aStream cr; cr
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc 
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:false do:[
        Class forceNoNameSpaceQuerySignal answer:true do:[
            aClass privateClassesSorted do:[:aClass |
                 aClass class fileOutAllDefinitionsOn:aStream
            ]
        ]
    ].

    "Created: / 15-10-1996 / 11:15:19 / cg"
    "Modified: / 19-05-2010 / 16:04:52 / cg"
!

fileOutCategory:aCategory of:aClass except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    |source sortedSelectors first privacy interestingMethods|

    interestingMethods := OrderedCollection new.
    interestingMethods := aClass methodsInCategory:aCategory forWhich:methodFilter.
    interestingMethods := interestingMethods 
            select:[:method |
                |wanted|

                skippedMethods notNil ifTrue:[
                    wanted := (skippedMethods includesIdentical:method) not
                ] ifFalse:[
                    savedMethods notNil ifTrue:[
                        wanted := (savedMethods includesIdentical:method).
                    ] ifFalse:[
                        wanted := true
                    ]
                ].
                wanted 
            ] as:OrderedCollection.

    interestingMethods isEmpty ifTrue:[ ^ self ].
    first := true.
    privacy := nil.

    "/
    "/ sort by selector
    "/
    sortedSelectors := interestingMethods collect:[:m | aClass selectorAtMethod:m].
    sortedSelectors sortWith:interestingMethods.

    interestingMethods do:[:aMethod |
        aStream nextPutLine:'/** category: ', aCategory , ' **/'.
        aStream cr.
        source := aMethod source.
        source isNil ifTrue:[
            Class fileOutErrorSignal 
                raiseRequestWith:aClass
                errorString:' - no source for method: ', (aMethod displayString)
        ] ifFalse:[
            aClass isMetaclass ifTrue:[
                "/ should the method know it???
                (source startsWith:'static ') ifFalse:[
                    aStream nextPutAll:'static '.
                ].
            ].
            aStream nextPutAll:source.
        ].
        aStream cr
    ].
    aStream cr

    "Modified: / 28-08-1995 / 14:30:41 / claus"
    "Modified: / 12-06-1996 / 11:37:33 / stefan"
    "Modified: / 15-11-1996 / 11:32:21 / cg"
    "Created: / 01-04-1997 / 16:04:33 / stefan"
    "Modified: / 28-08-2018 / 12:05:43 / Claus Gittinger"
! !

!JavaScriptSourceFileWriter methodsFor:'source writing'!

fileOutAllMethodsOf:aClass on:aStream methodFilter:methodFilter
    |collectionOfCategories|

    collectionOfCategories := aClass class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:aClass class  methodFilter:methodFilter on:aStream.
        ]
    ].
    collectionOfCategories := aClass categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:aClass methodFilter:methodFilter on:aStream.
        ]
    ].

    aClass privateClassesSorted do:[:aClass |
        self fileOutAllMethodsOf:aClass on:aStream methodFilter:methodFilter
    ].

    "Created: 15.10.1996 / 11:13:00 / cg"
    "Modified: 22.3.1997 / 16:12:17 / cg"
!

fileOutCategory:aCategory of:aClass methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream"

    self fileOutCategory:aCategory of:aClass except:nil only:nil methodFilter:methodFilter on:aStream

    "Created: 1.4.1997 / 16:04:44 / stefan"
!

fileOutCommentEndOn:aStream
    "Writes a comment end mark on aStream."

    "/ intentionally left blank - make each line an EOL-comment instead
!

fileOutCommentLine:aString on:aStream
    "Writes a single line of comment on a comment to a stream."

    aStream 
        nextPutAll:'// ';
        nextPutAll: aString
!

fileOutCommentStartOn:aStream
    "Writes a comment start mark on aStream."

    "/ intentionally left blank - make each line an EOL-comment instead
! !

!JavaScriptSourceFileWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSourceFileWriter.st,v 1.15 2018-08-28 12:19:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSourceFileWriter.st,v 1.15 2018-08-28 12:19:12 cg Exp $'
! !

