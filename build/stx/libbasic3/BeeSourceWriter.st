"
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

SmalltalkChunkFileSourceWriter subclass:#BeeSourceWriter
	instanceVariableNames:'timestamp'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!BeeSourceWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BeeSourceWriter class methodsFor:'simple API'!

fileOut:aClass on:aStream
    self fileOut:aClass on:aStream withTimeStamp:false
        withInitialize:true withDefinition:true
        methodFilter:nil encoder:nil

    "Created: / 14-04-2015 / 13:12:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeSourceWriter methodsFor:'source writing'!

fileOut:aClass on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    timestamp := Timestamp now printStringIso8601.
    super fileOut:aClass on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil

    "Created: / 14-04-2015 / 12:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 15:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllDefinitionsOf:aNonMetaClass on:aStream
    self fileOutAllDefinitionsOf:aNonMetaClass on:aStream withNameSpace: false.

    "Created: / 07-09-2016 / 15:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllDefinitionsOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma
    "append expressions on aStream, which defines myself and all of my private classes."


    self fileOutDefinitionOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma.

    "/ self fileOutDefinitionOf:aNonMetaClass on:aStream.
    "/ aStream nextPutChunkSeparator. 
    aStream cr.

    "/
    "/ optional classInstanceVariables
    "/
    aNonMetaClass class instanceVariableString isBlank ifFalse:[
        self fileOutClassInstVarDefinitionOf:aNonMetaClass on:aStream
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc 
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:false do:[
        Class forceNoNameSpaceQuerySignal answer:true do:[
            aNonMetaClass privateClassesSorted do:[:aClass |
                 self fileOutAllDefinitionsOf:aClass on:aStream withNameSpace: false
            ]
        ]
    ].

    "Created: / 14-04-2015 / 13:02:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutCategory:aCategory of:aClass except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    |sortedSelectors interestingMethods prjDef|

    interestingMethods := OrderedCollection new.
    aClass methodsDo:[:each |
        | wanted method shadowed |

        method := each.
        (methodsAlreadySaved includes:method) ifFalse:[
            (aCategory = method category) ifTrue:[
                wanted := methodFilter isNil or:[methodFilter value:method].
                wanted ifFalse:[ 
                    "/ care for methods which have been shadowed by an extension from another package!!
                    "/ The problem is that we cannot easily introspect the filter, so we cannot know
                    "/ if the filter is for package or not. In most (all?) cases it is as this method
                    "/ is mostly used by source code management, so if the filter filters method out,
                    "/ try afain for possibly shadowed method.
                    methodFilter notNil ifTrue:[ 
                        shadowed := method shadowedMethod.
                        shadowed notNil ifTrue:[ 
                            wanted := methodFilter value: shadowed.
                        ].
                    ].
                ].
                wanted ifTrue:[
                    skippedMethods notNil ifTrue:[
                        wanted := (skippedMethods includesIdentical:method) not
                    ] ifFalse:[
                        wanted := savedMethods isNil or:[ savedMethods includesIdentical:method ].
                    ].
                    wanted ifTrue:[
                        (method selector isSymbol) ifTrue:[
                            interestingMethods add:method
                        ] ifFalse:[
                            Transcript showCR:'skipping non-symbol method ', method selector printString.
                        ].
                    ].
                ]
            ]
        ]
    ].

    interestingMethods notEmpty ifTrue:[
        "/
        "/ sort by selector
        "/
        sortedSelectors := interestingMethods collect:[:m | aClass selectorAtMethod:m].
        sortedSelectors sortWith:interestingMethods.

        generatingSourceForOriginal == true ifTrue:[
            "/ care for methods which have been shadowed by an extension from another package!!
            (prjDef := aClass theNonMetaclass projectDefinitionClass) notNil ifTrue:[
                prjDef hasSavedOverwrittenMethods ifTrue:[
                    interestingMethods := interestingMethods collect:[:m |
                                                |originalOrNil|
                                                
                                                (m package ~~ aClass package) ifTrue:[ 
                                                    originalOrNil := prjDef savedOverwrittenMethodForClass:aClass selector:m selector.
                                                    originalOrNil notNil ifTrue:[ 
                                                        1.
                                                        self breakPoint:#cg 
                                                    ].
                                                ].
                                                originalOrNil ? m
                                          ].
                ]
            ].
        ].

        interestingMethods do:[:eachMethod |
            self fileOutMethod:eachMethod on:aStream.
            methodsAlreadySaved add:eachMethod.
        ].
    ].

    "Created: / 14-04-2015 / 13:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-04-2015 / 14:31:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutDefinitionOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma
    | revinfo |

    revinfo := aNonMetaClass revisionInfo.
    aStream nextPutAll: '!!ClassDefinition timeStamp:'; nextPutAll: timestamp storeString; nextPutAll: ' author: '; nextPutAll: revinfo author asString storeString; nextPutAll:' className: '; nextPutAll: aNonMetaClass name asString storeString; nextPutAll: '!!'.
    aStream cr; cr.       
    aNonMetaClass basicFileOutDefinitionOn:aStream withNameSpace: false withPackage: false.
    aStream nextPut: $!!; cr.

    "Created: / 14-04-2015 / 12:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 15:21:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethod:aMethod on:aStream
    "file a single method onto aStream."

    |source possiblyRewrittenSource rewriteQuery|

    source := aMethod source asSingleByteStringIfPossible.
    source isNil ifTrue:[
        Class fileOutErrorSignal 
            raiseRequestWith:aMethod mclass
            errorString:' - no source for method: ', (aMethod displayString)
    ] ifFalse:[
        "/ hook to allow for just-in-time rewriting of a method's sourceCode while filing out
        "/ used when saving version_XXX methods in a non-XXX sourceCodeManager
        "/ (i.e. to rewrite all non-CVS version methods while saving into a CVS repository)
        "/ this is required because we cannot save an SVN version method (dollar-ID-...-dollar) into a
        "/ CVS repository without loosing the original string with the next checkout, because it also gets  
        "/ expanded by CVS. The same is true vice-versa for CVS-Ids, which get clobbered by SVN.
        "/ also used, when generating sourcecode for another Smalltalk system (VSE fileout)

        rewriteQuery := AbstractSourceFileWriter methodSourceRewriteQuery new.
        rewriteQuery method:aMethod source:source.
        possiblyRewrittenSource := (rewriteQuery query) ? source.

        aStream nextPutAll: '!!MethodDefinition timeStamp:'; nextPutAll: timestamp storeString; 
                nextPutAll: ' author: ';    nextPutAll: 'Unknown' storeString;
                nextPutAll: ' className: '; nextPutAll: aMethod mclass name storeString; 
                nextPutAll: ' selector: ';  nextPutAll: aMethod selector storeString; 
                nextPutAll: ' category: ';  nextPutAll: aMethod category storeString; 
                nextPutAll: '!!'.
        aStream cr.
        aStream nextChunkPut:possiblyRewrittenSource.
        aStream cr.
    ].

    "Created: / 14-04-2015 / 12:41:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-04-2015 / 14:48:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethods: methods on: stream

    methods do:[:method| 
        self fileOutMethod: method on: stream.
    ]

    "Created: / 14-04-2015 / 12:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateHeaderWithCopyrightOn:outStream

    "/ No copyrights in Bee sources

    "Created: / 07-09-2016 / 15:37:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

