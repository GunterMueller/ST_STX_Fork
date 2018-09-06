"
 COPYRIGHT (c) 2012 by eXept Software AG
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

SmalltalkChunkFileSourceWriter subclass:#VisualAgeChunkFileSourceWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!VisualAgeChunkFileSourceWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
        VisualAgeChunkFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ]
                                                        [exEnd]

                                                        [exBegin]
    |s|

    s := '' writeStream.
    [
        VisualAgeChunkFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ].
    s contents
                                                        [exEnd]
"
! !

!VisualAgeChunkFileSourceWriter methodsFor:'source writing'!

fileOutCategory:aCategory of:aClass except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    |sortedSelectors first prevPrivacy privacy interestingMethods|

    interestingMethods := OrderedCollection new.
    aClass methodsDo:[:aMethod |
        |wanted|

        (methodsAlreadySaved includes:aMethod) ifFalse:[
            (aCategory = aMethod category) ifTrue:[
                (methodFilter isNil or:[methodFilter value:aMethod]) ifTrue:[
                    skippedMethods notNil ifTrue:[
                        wanted := (skippedMethods includesIdentical:aMethod) not
                    ] ifFalse:[
                        wanted := savedMethods isNil or:[ savedMethods includesIdentical:aMethod ].
                    ].
                    wanted ifTrue:[
                        aMethod selector isSymbol ifTrue:[
                            interestingMethods add:aMethod
                        ] ifFalse:[
                            Transcript showCR:'skipping non-symbol method ', aMethod selector printString.
                        ].
                    ].
                ]
            ]
        ]
    ].
    interestingMethods notEmpty ifTrue:[
        first := true.
        prevPrivacy := nil.

        "/
        "/ sort by selector
        "/
        sortedSelectors := interestingMethods collect:[:m | aClass selectorAtMethod:m].
        sortedSelectors sortWith:interestingMethods.

        interestingMethods do:[:eachMethod |
            privacy := eachMethod privacy.

            first ifFalse:[
                privacy ~~ prevPrivacy ifTrue:[
                    first := true.
                    aStream space.
                    aStream nextPutChunkSeparator.
                ].
                aStream cr; cr
            ].

            first ifTrue:[
                aStream nextPutChunkSeparator.
                aClass printClassNameOn:aStream.
                privacy ~~ #public ifTrue:[
                    aStream nextPutAll:' privateMethods'.
                ] ifFalse:[
                    aStream nextPutAll:' publicMethods'.
                ].
                aStream nextPutChunkSeparator; cr; cr.
                first := false.
            ].
            self fileOutMethod:eachMethod on:aStream.
            methodsAlreadySaved add:eachMethod.

            prevPrivacy := privacy.
        ].
        aStream space.
        aStream nextPutChunkSeparator.
        aStream cr
    ].
    aStream cr
!

fileOutDefinitionOf:aClass on:aStream
    "append an expression on aStream, which defines myself."

    |s owner ns superclass nm|

    owner := aClass owningClass.
    ns := aClass topNameSpace.

    "take care of nil-superclass"
    superclass := aClass superclass.
    superclass isNil ifTrue:[
        s := 'nil'
    ] ifFalse:[
        s := superclass nameWithNameSpacePrefix.
    ].

    aStream nextPutAll:s.   "/ superclass
    aStream space.
    aClass basicFileOutInstvarTypeKeywordOn:aStream.

    nm := aClass nameWithoutPrefix.
    aStream nextPut:$#.
    aStream nextPutAll:nm.

    aStream crtab.
    aStream nextPutAll:'instanceVariableNames:'''.
    aClass printInstVarNamesOn:aStream indent:16.
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'classVariableNames:'''.
    aClass printClassVarNamesOn:aStream indent:16.
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'poolDictionaries:'''.
    aClass printSharedPoolNamesOn:aStream indent:16.
    aStream nextPutAll:''''.

    aStream cr.
! !

!VisualAgeChunkFileSourceWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/VisualAgeChunkFileSourceWriter.st,v 1.2 2013-06-23 22:22:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/VisualAgeChunkFileSourceWriter.st,v 1.2 2013-06-23 22:22:38 cg Exp $'
! !

