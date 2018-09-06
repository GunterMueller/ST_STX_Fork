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

VSEFileSourceWriter subclass:#VSEChunkFileSourceWriter
	instanceVariableNames:'rememberedInitializers'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!VSEChunkFileSourceWriter class methodsFor:'documentation'!

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

!VSEChunkFileSourceWriter methodsFor:'source writing'!

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
                aStream nextPutAll:(self rewrittenClassNameOf:aClass theNonMetaclass).
                aClass isMetaclass ifTrue:[ aStream nextPutAll:' class' ].
                aStream nextPutAll:' methodsFor: '.
                aStream nextPutAll:'''',aCategory,''''.

"/                privacy ~~ #public ifTrue:[
"/                    aStream nextPutAll:' privateMethods'.
"/                ] ifFalse:[
"/                    aStream nextPutAll:' publicMethods'.
"/                ].
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

fileOutClassCommentOf:aNonMetaClass on:aStream
    "append an expression on aStream, which defines my comment"

    |comment s|

^ self.
    (comment := aNonMetaClass comment) isEmptyOrNil ifTrue:[^ self].

    aStream nextPutAll:(self rewrittenClassNameOf:aNonMetaClass).
    aStream nextPutAll:' comment:'.
    s := comment copyReplaceAll:$' with:$" "storeString" .
    aStream nextPutAllAsChunk:s.
    aStream nextPutChunkSeparator.
    aStream cr.
    aStream cr.
!

fileOutClassInstVarDefinitionOf:aNonMetaClass on:aStream
    (self rewrittenClassNameOf:aNonMetaClass) printOn:aStream.
    aStream nextPutAll:' class instanceVariableNames:'''.
    aNonMetaClass class printInstVarNamesOn:aStream indent:8.
    aStream nextPutAll:''''.

    aStream nextPutChunkSeparator. 
    aStream cr; cr
!

fileOutDefinitionOf:aClass on:aStream
    "append an expression on aStream, which defines myself."

    |s owner superclass|

    owner := aClass owningClass.
    owner notNil ifTrue:[ self error:' cannot fileout private classes (yet)' ].

    "take care of nil-superclass"
    superclass := aClass superclass.
    superclass isNil ifTrue:[
        s := 'nil'
    ] ifFalse:[
        s := (self rewrittenClassNameOf:superclass).
    ].

    aStream nextPutAll:s.   "/ superclass
    aStream space.
    aClass basicFileOutInstvarTypeKeywordOn:aStream.

    aStream nextPut:$#.
    aStream nextPutAll:(self rewrittenClassNameOf:aClass).

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
!

fileOutDefinitionOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma
    "append an expression on aStream, which defines myself."

    self fileOutDefinitionOf:aNonMetaClass on:aStream
!

fileOutPackage:packageID on:aStream
    |classesToFileout rewriter|

    aStream lineEndCRLF.

    classesToFileout := Smalltalk allClassesInPackage:packageID.
    classesToFileout := classesToFileout reject:[:cls | cls isSubclassOf: ProjectDefinition ].
    classesToFileout topologicalSort:[:a :b | b isSubclassOf:a].

    classesToFileout do:[:cls | 
        cls isPrivate ifTrue:[
            self error:'Cannot file out private class: ',cls name.
        ].
    ].

    rewriter := self class vseSourceRewriter new.
    rewriter classNamesToRewrite:classNameTranslations.

    AbstractSourceFileWriter methodSourceRewriteQuery handle:[:rewriteQuery |
        |method source|

        method := rewriteQuery method.
        source := rewriteQuery source.
        source := rewriter rewriteMethod:method.
        rewriteQuery proceedWith:source.
    ] do:[
        |first|

        first := true.

        classesToFileout do:[:eachClass |
            self activityNotification:'writing ',eachClass name,'...'.
            self 
                fileOut:eachClass on:aStream 
                withTimeStamp:first withInitialize:true 
                withDefinition:true 
                methodFilter:nil encoder:nil.

            (eachClass theMetaclass implements:#initialize) ifTrue:[
                aStream nextPutChunkSeparator.
                aStream nextPutAll:(self rewrittenClassNameOf:eachClass theNonMetaclass).
                aStream nextPutAll:' class methodsFor: ''initialization'''.
                aStream nextPutChunkSeparator; cr; cr.

                aStream nextPutLine:(self rewrittenClassNameOf:eachClass theNonMetaclass),'Initialization'.
                aStream nextPutLine:'    self initialize'.
                aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr.
            ].
            first := false.
        ].

        "/ fileout extensions
        self activityNotification:'writing extensions...'.
        Smalltalk allClassesDo:[:eachClass |
            (classesToFileout includes:eachClass) ifFalse:[
                eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                    |skip mPckg targetClass|

                    skip := false.
                    mPckg := mthd package.
                    (mPckg = packageID and:[mPckg ~= eachClass package]) ifTrue:[
                        targetClass := mthd mclass.
                        "/ hack for LPReal -> move to Float, unles defined there.
                        targetClass == LimitedPrecisionReal ifTrue:[
                            (Float implements:mthd selector) ifTrue:[
                                skip := true.
                            ] ifFalse:[
                                "/ self halt:'save for Float instead of LPReal'.
                                targetClass := Float.
                                Transcript showCR:'- moved extension method from LimitedPrecisionReal to Float'.
                            ].
                        ].
                        "/ skip - leads to trouble
                        ((sel == #date) and:[targetClass == Timestamp]) ifTrue:[
                            Transcript showCR:'- skip TimeStamp >> date'.
                            skip := true.
                        ].

                        skip ifFalse:[
                            aStream nextPutChunkSeparator.
                            aStream nextPutAll:(self rewrittenClassNameOf:targetClass theNonMetaclass).
                            mthd mclass isMetaclass ifTrue:[ aStream nextPutAll:' class' ].
                            aStream nextPutAll:' methodsFor: '.
                            aStream nextPutAll:'''',mthd category,''''.

                            aStream nextPutChunkSeparator; cr; cr.
                            self fileOutMethod:mthd on:aStream.
                            aStream space; nextPutChunkSeparator; cr; cr.
                        ]
                    ]
                ]
            ].
        ].
    ].

    "/ add initializers at the end
    rememberedInitializers notEmptyOrNil ifTrue:[
        aStream cr.
        rememberedInitializers do:[:eachClass |
            aStream nextPutAll:(self rewrittenClassNameOf:eachClass); space.
            aStream nextPutAll:(self rewrittenClassNameOf:eachClass).
            aStream nextPutAll:'Initialization'.
            aStream nextPutChunkSeparator.
            aStream cr.
        ].
    ].
    self activityNotification:'done.'.
!

generateCallToInitializerFor:aClass on:aStream
    "here, the initializers are collected and generated alltogether at the end"

    rememberedInitializers isNil ifTrue:[
        rememberedInitializers := OrderedCollection new.
    ].
    (rememberedInitializers includes:aClass) ifFalse:[
        rememberedInitializers add:aClass.
    ]
! !

!VSEChunkFileSourceWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/VSEChunkFileSourceWriter.st,v 1.18 2015-02-13 02:02:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/VSEChunkFileSourceWriter.st,v 1.18 2015-02-13 02:02:27 cg Exp $'
! !

