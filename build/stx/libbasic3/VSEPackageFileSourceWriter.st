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

VSEFileSourceWriter subclass:#VSEPackageFileSourceWriter
	instanceVariableNames:'projectDefinitionClass classesToBeInitialized'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!VSEPackageFileSourceWriter class methodsFor:'documentation'!

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
        VSEPackageFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ]
                                                        [exEnd]

                                                        [exBegin]
    |s|

    s := '' writeStream.
    [
        VSEPackageFileSourceWriter new
            fileOut:OrderedCollection on:s
    ] ensure:[
        s close
    ].
    s contents
                                                        [exEnd]
"
! !

!VSEPackageFileSourceWriter methodsFor:'source writing'!

fileOut:aClass on:aStream withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    |commentOrDocumentation skipDocumentationMethod hasInitialize|

    hasInitialize := false.
    skipDocumentationMethod := false.

    aStream nextPutAll:'Class '.
    aStream nextPutAll:(self rewrittenClassNameOf:aClass).
    aStream space.
    aClass superclass isNil ifTrue:[
        self error:'unimplemented: nil superclass'.
    ].
    aStream nextPutAll:(self rewrittenClassNameOf:aClass superclass).
    aStream nextPutLine:'!!'.

    (commentOrDocumentation := aClass comment) isEmptyOrNil ifTrue:[
        (commentOrDocumentation := aClass commentOrDocumentationString) notEmptyOrNil ifTrue:[
            skipDocumentationMethod := true
        ].
    ].
    commentOrDocumentation notEmptyOrNil ifTrue:[
        self putEntry:'Property' value:'Comment' on:aStream.
        self putEntry:'' value:commentOrDocumentation on:aStream.
    ].

    aClass isVariable ifTrue:[
        aClass isPointers ifTrue:[
            aStream nextPutLine:'IndexableObject!!'.
        ] ifFalse:[
            self error:'unimplemented: non-pointer indexable'.
        ]
    ] ifFalse:[
        aStream nextPutLine:'NonIndexable!!'.
    ].
    aClass instanceVariableNames do:[:v |
        aStream nextPutLine:'InstanceVariable ',v,'!!'.
    ].
    aClass classVariableNames do:[:v |
        aStream nextPutLine:'ClassVariable ',v,'!!'.
    ].
    aClass class instanceVariableNames do:[:v |
        aStream nextPutLine:'ClassInstanceVariable ',v,'!!'.
    ].
    aClass realSharedPoolNames do:[:nm |      
        aStream nextPutLine:'Pool ',nm,'!!'.
    ].

    aClass methodDictionary keys asNewOrderedCollection sort do:[:sel |
        self fileOutMethod:(aClass methodDictionary at:sel) isExtension:false on:aStream.
    ].
    aClass class methodDictionary keys asNewOrderedCollection sort do:[:sel |
        (skipDocumentationMethod and:[sel == #documentation]) ifTrue:[
            "/ skip method
        ] ifFalse:[
            (skipVersionMethods and:[sel == #version or:[sel startsWith:'version_']]) ifTrue:[
                "/ skip method
            ] ifFalse:[
                sel == #initialize ifTrue:[
                    hasInitialize := true.
                ].
                self fileOutMethod:(aClass class methodDictionary at:sel) isExtension:false on:aStream.
            ].
        ].
    ].

    hasInitialize ifTrue:[
        |initializerCode|

        initializerCode := (self rewrittenClassNameOf:aClass), ' initialize.'.
        self putEntry:'Initialization' value:initializerCode on:aStream.
    ].

    self putEntry:'EndClass' value:nil on:aStream.
!

fileOutMethod:aMethod isExtension:isExtension on:aStream
    |sel mclass isMeta rewriteQuery originalSource possiblyRewrittenSource
     date time user whatVersion methodVersionString info sourceCodeManager|

    sel := aMethod selector.
    mclass := aMethod mclass.
    isMeta := mclass isMetaclass.

    isExtension ifTrue:[
        "/ skip - leads to trouble
        ((sel == #date) and:[mclass == Timestamp]) ifTrue:[
            Transcript showCR:'- skip TimeStamp >> date'.
            ^ self.
        ].
    ].

    projectDefinitionClass isNil ifTrue:[
        "/ 02/03/15 04:26:18 PM by unknown
        date := Date today.
        time := Time now.
        user := OperatingSystem getFullUserName.
        whatVersion := 'time exported'.
    ] ifFalse:[
        sourceCodeManager := projectDefinitionClass sourceCodeManager.
        isExtension ifTrue:[
            info := projectDefinitionClass extensionsRevisionInfoForManager:sourceCodeManager.
        ] ifFalse:[
            info := mclass theNonMetaclass revisionInfoOfManager:sourceCodeManager.
        ].
        date := Date readFrom:(info date).
        time := Time readFrom:(info time).
        user := info user.
        whatVersion := 'cvs version ',(info revision).
    ].
    methodVersionString := '%1 %2 by %3 (%4)'
                                bindWith:(date printStringFormat:'%m/%d/%Y')
                                with:(time printStringFormat:'%u:%m:%s %A')
                                with:user  
                                with:whatVersion.   

    originalSource := aMethod source.
    rewriteQuery := AbstractSourceFileWriter methodSourceRewriteQuery new.
    rewriteQuery method:aMethod source:originalSource.
    possiblyRewrittenSource := (rewriteQuery query) ? originalSource.

    isExtension ifTrue:[
        "/ hack for LPReal -> move to Float, unles defined there.
        mclass theNonMetaclass == LimitedPrecisionReal ifTrue:[
            (Float implements:sel) ifTrue:[
                self halt:'method skipped'.
                ^ self.
            ].
            "/ self halt:'save for Float instead of LPReal'.
            mclass := mclass isMeta ifTrue:[Float class] ifFalse:[Float].
            Transcript showCR:'- moved extension method from LimitedPrecisionReal to Float'.
        ].
        aStream nextPutAll:'MethodDefinition ',(self rewrittenClassNameOf:mclass theNonMetaclass).
    ] ifFalse:[
        aStream nextPutAll:'Method'.   
    ].
    isMeta ifTrue:[
        aStream nextPutLine:' class ',sel,'!!'.
    ] ifFalse:[
        aStream nextPutLine:' instance ',sel,'!!'.
    ].

    aStream space.
    self putString:possiblyRewrittenSource on:aStream.
    aStream nextPutLine:'!!'.
    self putEntry:'Property' value:'.Version' on:aStream.
    self putEntry:'' value:methodVersionString on:aStream.
    self putEntry:'Property' value:'Categories' on:aStream.
    self putEntry:'' value:aMethod category on:aStream.
!

fileOutPackage:packageID on:aStream
    |classesToFileout methodsToFileOut rewriter|

    projectDefinitionClass := packageID asPackageId projectDefinitionClass.
    classesToBeInitialized := OrderedCollection new.

    aStream lineEndCRLF.

    "/ make sure that everything is loaded.
    projectDefinitionClass notNil ifTrue:[
        projectDefinitionClass autoload.
        projectDefinitionClass ensureFullyLoaded.
        classesToFileout := Smalltalk allClassesInPackage:packageID.
    ] ifFalse:[
        classesToFileout := Smalltalk allClassesInPackage:packageID.
        classesToFileout := classesToFileout collect:[:each | each autoload].
    ].

    classesToFileout := classesToFileout reject:[:cls | cls isSubclassOf: ProjectDefinition ].
    classesToFileout topologicalSort:[:a :b | b isSubclassOf:a].

    classesToFileout do:[:cls | 
        cls isPrivate ifTrue:[
            self error:'Cannot file out private class: ',cls name.
        ].
    ].

    rewriter := self class vseSourceRewriter new.
    rewriter classNamesToRewrite:classNameTranslations.

    methodsToFileOut := self extensionMethodsFor:packageID.

    self activityNotification:'checking for unportable unicode...'.
    classesToFileout do:[:eachClass |
        self ensureNoUnicodeInClass:eachClass
    ].
    methodsToFileOut do:[:eachClass |
        self ensureNoUnicodeInMethod:eachClass
    ].

    self writeHeaderOn:aStream.

    AbstractSourceFileWriter methodSourceRewriteQuery handle:[:rewriteQuery |
        |method source|

        method := rewriteQuery method.
        source := rewriteQuery source.
        source := rewriter rewriteMethod:method.
        rewriteQuery proceedWith:source.
    ] do:[
        classesToFileout do:[:eachClass |
            self activityNotification:'exporting ',eachClass name,'...'.
            self fileOut:eachClass on:aStream.
        ].

        "/ fileout extensions
        self activityNotification:'exporting extensions...'.
        methodsToFileOut do:[:eachMethod |
            self fileOutMethod:eachMethod isExtension:true on:aStream.
            aStream cr.
        ].
    ].

    self activityNotification:'done.'.
!

putEntry:key value:value on:aStream
    key notNil ifTrue:[
        aStream nextPutAll:key.
    ].
    value notNil ifTrue:[
        aStream space.    
        self putString:value on:aStream
    ].
    aStream nextPutLine:'!!'.
!

putString:aString on:aStream
    "as the string is written (and should be counted) with cr-lf,
     count the returns and the size compute number"

    |numCRs|

    numCRs := aString occurrencesOf:Character cr.

    aStream nextPutAll:'<S'.
    aStream nextPutAll:(aString size + numCRs) asString.
    aStream nextPutAll:'>'.
    aStream nextPutAll:aString.
!

writeHeaderOn:aStream
    |releaseNr revisionNr author vsePackageName packageComment|

    releaseNr := 1.
    revisionNr := 1.
    author := OperatingSystem getFullUserName.

    projectDefinitionClass notNil ifTrue:[
        vsePackageName := projectDefinitionClass perform:#vsePackageName ifNotUnderstood:nil.
    ].
    vsePackageName isNil ifTrue:[
        |action optionLabels options|

        projectDefinitionClass notNil ifTrue:[
            optionLabels := #('Cancel' 'No, Browse' 'Yes').
            options := #(#abort #browse #yes)
        ] ifFalse:[
            optionLabels := #('Cancel' 'Yes').
            options := #(#abort #yes)
        ].
        action := OptionBox
                          request:(Dialog resources stringWithCRs:'No vsePackageName defined in ProjectDefinition.\\Proceed (using ST/X package name)?')
                          label:'VSE Package Export'
                          image:(WarningBox iconBitmap)
                          buttonLabels:(Dialog resources array:optionLabels)
                          values:options
                          default:(projectDefinitionClass isNil ifTrue:#abort ifFalse:#browse)
                          onCancel:#abort.
        action == #abort ifTrue:[
            AbortOperationRequest raise
        ].
        action == #browse ifTrue:[
            UserPreferences browserClass openInClass:projectDefinitionClass theMetaclass.
            AbortOperationRequest raise
        ].
    ].

    projectDefinitionClass notNil ifTrue:[
        releaseNr := projectDefinitionClass perform:#vseReleaseNr ifNotUnderstood:nil.
        releaseNr isNil ifTrue:[
            releaseNr := projectDefinitionClass revisionInfo majorVersion 
        ].
        revisionNr := projectDefinitionClass perform:#vseRevisionNr ifNotUnderstood:nil. 
        revisionNr isNil ifTrue:[
            revisionNr := projectDefinitionClass revisionInfo minorVersion 
        ].
        author := projectDefinitionClass perform:#vseAuthor ifNotUnderstood:nil.
        author isNil ifTrue:[
            author := projectDefinitionClass revisionInfo author 
        ].
        packageComment := projectDefinitionClass commentOrDocumentationString.
    ].

    self putEntry:'Header' value:nil on:aStream.
    self putEntry:'Type ' value:'Package' on:aStream.
    self putEntry:'Format ' value:'ExtendedFileOut' on:aStream.
    self putEntry:'Version ' value:'1.0' on:aStream.
    self putEntry:'EndHeader' value:nil on:aStream.

    self putEntry:'Package ' value:(vsePackageName ? (projectDefinitionClass package) ? 'unnamed') on:aStream.
    self putEntry:'Property' value:'Release' on:aStream.
    self putEntry:nil value:(releaseNr asString) on:aStream.
    self putEntry:'Property' value:'RevisionNumber' on:aStream.
    self putEntry:nil value:(revisionNr asString) on:aStream.
    self putEntry:'Property' value:'Author' on:aStream.
    self putEntry:nil value:author on:aStream.
    packageComment notEmptyOrNil ifTrue:[
        self putEntry:'Property' value:'Comment' on:aStream.
        self putEntry:nil value:packageComment on:aStream.
    ].
! !

!VSEPackageFileSourceWriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

