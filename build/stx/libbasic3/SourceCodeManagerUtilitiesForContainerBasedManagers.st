"
 COPYRIGHT (c) 2012 eXept Software AG
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

SourceCodeManagerUtilities subclass:#SourceCodeManagerUtilitiesForContainerBasedManagers
	instanceVariableNames:''
	classVariableNames:'LastComparedTag'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!SourceCodeManagerUtilitiesForContainerBasedManagers class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SourceCodeManagerUtilitiesForContainerBasedManagers methodsFor:'utilities-cvs'!

checkinBuildSupportFilesForPackage:packageID withInfo:checkinInfo
    |anyFailure module directory mgr defClass|

    mgr := self sourceCodeManagerFor: packageID. 
    defClass := ProjectDefinition definitionClassForPackage: packageID.

    "/ already done elsewhere now
    "/ defClass validateDescription.

    anyFailure := false.

    module := packageID asPackageId module.
    directory := packageID asPackageId directory.

    self activityNotification:(resources string:'Checking in build-support files...').
    (mgr checkForExistingModule:module directory:directory) ifFalse:[
        mgr createModule:module directory:directory
    ].

    defClass forEachFileNameAndGeneratedContentsDo:[:fileName :fileContents |
        |realFileName realDirectory|

        "/ care for subdirectories
        (fileName includes:$/) ifTrue:[
            realDirectory := (directory asFilename construct:(fileName asFilename directoryName)) name.
            realFileName := fileName asFilename baseName.
        ] ifFalse:[
            realDirectory := directory.
            realFileName := fileName.
        ].
        realDirectory := realDirectory replaceAll:$\ with:$/.

        self activityNotification:(resources string:'Checking in %1...' with:realFileName).

        UserInformation
            handle:[:ex | Transcript showCR:ex description ]
            do:[
                (mgr isContainerBased
                 and:[(mgr checkForExistingContainer:realFileName inModule:module directory:realDirectory) not]
                ) ifTrue:[
                    realDirectory ~= directory ifTrue:[
                        (mgr checkForExistingModule:module directory:realDirectory) ifFalse:[
                            mgr createModule:module directory:realDirectory
                        ].
                    ].
                    [:exit |
                        |answer|

                        (mgr
                            createContainerForText:fileContents
                            inModule:module
                            package:realDirectory
                            container:realFileName) ifTrue:[ exit value:nil ].

                        answer := Dialog 
                            confirmWithCancel:(resources
                                    stringWithCRs:'Cannot create new container: ''%3'' (in %1:%2).\\Retry?'
                                    with:module
                                    with:realDirectory
                                    with:realFileName).

                         answer == nil ifTrue:[
                            AbortOperationRequest raise
                        ].
                        answer == false ifTrue:[ exit value:nil ].
                    ] loopWithExit.
                ] ifFalse:[
                    (mgr
                        checkin:realFileName
                        text:fileContents
                        directory:realDirectory
                        module:module
                        logMessage:checkinInfo logMessage
                        force:false
                    ) ifTrue:[
                        checkinInfo isStable ifTrue:[
                            self tagPath:(module, '/', realDirectory, '/', realFileName) as:#stable usingManager:mgr.
                        ].
                        checkinInfo tagIt ifTrue:[
                            self tagPath:(module, '/', realDirectory, '/', realFileName) as:checkinInfo tag usingManager:mgr.
                        ].
                    ] ifFalse:[
                        Transcript showCR:'checkin of ' , realFileName , ' failed'.
                        anyFailure := true.
                    ].
                ].
            ].
    ].

    defClass instAndClassMethodsDo:[:m | m package:defClass package].
    [
        self
            checkinClasses:(Array with:defClass)
            withInfo:checkinInfo
            withCheck:false
            usingManager:nil
            confirmNewContainer:false.
    ] ifCurtailed:[
        self activityNotification:'Checkin of build-support files aborted - see Transcript'.
    ].
    
    anyFailure ifTrue:[
        self warn:'Checkin failed - see Transcript.'.
        self activityNotification:'Checkin of build-support files failed - see Transcript.'.
    ] ifFalse:[
        self activityNotification:'Build-support files checked into the repository.'.
    ].

    "Created: / 09-08-2006 / 18:59:42 / fm"
    "Modified: / 12-10-2011 / 11:36:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2012 / 14:27:30 / cg"
    "Modified (format): / 25-07-2012 / 22:25:48 / cg"
!

checkinExtensionMethods:aCollectionOfMethods forPackage:aPackageID withInfo:aLogInfoOrStringOrNil
    "checkin a projects extensions into the source repository.
     If the argument, aLogInfoOrStringOrNil isNil, ask interactively for log-message."

    |logMessage checkinInfo mgr pri module directory containerFileName extensionsSource|

    "/ the following is wrong - must ask the projectDefinition !!
    aPackageID asPackageId projectDefinitionClass notNil ifTrue:[
        mgr := self sourceCodeManagerFor:aPackageID asPackageId projectDefinitionClass.
    ] ifFalse:[
        mgr := self sourceCodeManagerFor:aCollectionOfMethods first mclass.
    ].
    mgr isNil ifTrue:[ ^ false ].

    module := aPackageID asPackageId module.
    directory := aPackageID asPackageId directory.
    containerFileName := self nameOfExtensionsContainer.

    aLogInfoOrStringOrNil isNil ifTrue:[
        checkinInfo := self getCheckinInfoFor:containerFileName allBold initialAnswer:nil.
        checkinInfo isNil ifTrue:[^ false].
        logMessage := checkinInfo logMessage.
    ] ifFalse:[
        aLogInfoOrStringOrNil isString ifTrue:[
            logMessage := aLogInfoOrStringOrNil
        ] ifFalse:[
            checkinInfo := aLogInfoOrStringOrNil.
            logMessage := checkinInfo logMessage.
        ].
    ].

    (mgr checkForExistingContainer:containerFileName inModule:module directory:directory) ifFalse:[
        (self checkForExistingModule:module usingManager:mgr allowCreate:true) ifFalse:[^ false].
        LastModule := module.

        (self checkForExistingModule:module directory:directory usingManager:mgr allowCreate:true) ifFalse:[^ false].
        LastPackage := directory.

        (self checkForExistingModule:module directory:directory container:containerFileName usingManager:mgr allowCreate:true) ifFalse:[^ false].
    ].

    self activityNotification:(resources string:'Checking in %1' with:containerFileName).
    pri := Processor activePriority.
    Processor activeProcess 
        withPriority:pri-1 to:pri
        do:[
            extensionsSource := self sourceCodeForExtensions:aCollectionOfMethods package:aPackageID forManager:mgr.
            "Care for non-ASCII/non-ISO-8859 characters in extension methods"
            extensionsSource isWideString ifTrue:[
                extensionsSource := '"{ Encoding: utf8 }"' , Character cr asString , Character cr asString , extensionsSource.                
                extensionsSource := extensionsSource utf8Encoded.
            ].

            UserInformation handle:[:ex |
                Transcript showCR:ex description.
                ex proceed.
            ] do:[
                Transcript showCR:('checking in ',containerFileName,' ...').
                (mgr 
                    checkin:containerFileName
                    text:extensionsSource
                    directory:directory 
                    module:module
                    logMessage:logMessage
                    force:false) 
                ifFalse:[
                    Transcript showCR:'Checkin of ''' , containerFileName , ''' failed'.
                    self warn:'Checkin of ''' , containerFileName allBold , ''' failed'.
                    ^ false.
                ].
                checkinInfo notNil ifTrue:[
                    |path|

                    path := (module, '/', directory, '/', containerFileName).
                    checkinInfo isStable ifTrue:[
                        "set stable tag for class that has been checked in"
                        self tagPath:path as:#stable usingManager:mgr.    
                    ].
                    checkinInfo tagIt ifTrue:[
                        "set an additional tag for class that has been checked in"
                        self tagPath:path as:(checkinInfo tag) usingManager:mgr.    
                    ].
                ].
                mgr postCheckInExtensionsForPackage:aPackageID    
            ].
        ].
    ^ true

    "Modified: / 25-07-2012 / 18:38:40 / cg"
!

checkinPackage:packageToCheckIn classes:doClasses extensions:doExtensions buildSupport:doBuild askForMethodsInOtherPackages:askForMethodsInOtherPackages
    |mgr classesToCheckIn methodsToCheckIn methodsInPrjDef
     methodsInOtherPackages looseMethods otherPackages
     msg classesInChangeSet newClasses checkinInfo originalCheckinInfo classesToTag
     answer|

    mgr := self sourceCodeManagerFor: packageToCheckIn.

    classesToCheckIn := IdentitySet new.
    classesInChangeSet := IdentitySet new.
    methodsToCheckIn := IdentitySet new.
    methodsInOtherPackages := IdentitySet new.
    looseMethods := IdentitySet new.

    "/ collect classes and individual methods...
    (doClasses or:[doExtensions]) ifTrue:[
        Smalltalk allClassesDo:[:aClass | 
            |owner classPackage|

            (owner := aClass owningClass) notNil ifTrue:[
                classPackage := aClass topOwningClass package
            ] ifFalse:[
                classPackage := aClass package
            ].
            (classPackage = packageToCheckIn) ifTrue:[
                classesToCheckIn add:aClass.
            ].

            doExtensions ifTrue:[
                aClass isMeta ifFalse:[
                    "/ ... whose class is not in the checkIn-set
                    (classesToCheckIn includes:aClass) ifFalse:[
                        aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                            "/ methods in this project ...
                            (mthd package = packageToCheckIn) ifTrue:[
                                methodsToCheckIn add:mthd
                            ]
                        ]
                    ].
                ].
            ].
        ].

        "/ cg: O(n^2) algorithm
        "/  classesInChangeSet := classesToCheckIn select:[:cls | cls hasUnsavedChanges].
        "/ replaced by: O(n) algorithm
        classesInChangeSet := ChangeSet current selectClassesForWhichIncludesChangeForClassOrMetaclassOrPrivateClassFrom:classesToCheckIn. 
    ].

    doExtensions ifTrue:[
        methodsToCheckIn notEmpty ifTrue:[
            doClasses ifTrue:[
                msg := '%1 classes (%4 changed) '.
            ] ifFalse:[
                msg := ''.
            ].
            doExtensions ifTrue:[
                doClasses ifTrue:[
                    msg := msg , 'and '.
                ].
                msg := msg , '%2 extensions '.
            ].
            msg := msg , 'of project "%3"'.

            checkinInfo := self
                        getCheckinInfoFor:(msg
                                                    bindWith:classesToCheckIn size
                                                    with:methodsToCheckIn size
                                                    with:packageToCheckIn allBold
                                                    with:classesInChangeSet size)
                        initialAnswer:nil
                        withQuickOption:(classesToCheckIn size > 0)
                        withValidateConsistencyOption:true.
            checkinInfo isNil ifTrue:[
                ^ self.
            ].

            checkinInfo validateConsistency ifTrue:[
                |setInProjectDef setForCheckin onlyInPrjDef onlyForCheckin moreInfo|

                self validateConsistencyOfPackage:packageToCheckIn doClasses:doClasses doExtensions:doExtensions.
                "/ could have changed/recompiled methods...
                "/ mhmh - should we checkin what is specified in the prj-def,
                "/ or what is actually present in the image (in case user did not repair)???
                
                methodsInPrjDef  := packageToCheckIn asPackageId projectDefinitionClass extensionMethods.
                methodsInPrjDef := methodsInPrjDef reject:[:m | m isNil].
                (setInProjectDef := methodsInPrjDef asSet) ~= (setForCheckin := methodsToCheckIn asSet) ifTrue:[
                    onlyInPrjDef := setInProjectDef copy removeAllFoundIn:setForCheckin.
                    onlyForCheckin := setForCheckin copy removeAllFoundIn:setInProjectDef.
                    moreInfo := ''.
                    onlyInPrjDef notEmpty ifTrue:[
                        moreInfo := moreInfo , '\Only in Project: '.
                        moreInfo := moreInfo , (((onlyInPrjDef asOrderedCollection copyTo:(5 min:onlyInPrjDef size))
                                                collect:#whoString) asStringWith:', ').
                        onlyInPrjDef size > 5 ifTrue:[ moreInfo := moreInfo , '...' ].
                    ].
                    onlyForCheckin notEmpty ifTrue:[
                        moreInfo := moreInfo , '\Only in Image: '.
                        moreInfo := moreInfo , (((onlyForCheckin asOrderedCollection copyTo:(5 min:onlyForCheckin size))
                                                collect:#whoString) asStringWith:', ').
                        onlyForCheckin size > 5 ifTrue:[ moreInfo := moreInfo , '...' ].
                    ].
                    moreInfo notEmpty ifTrue:[ (moreInfo := moreInfo , '\') withCRs ].
self halt.
                    answer:= Dialog 
                        confirmWithCancel:('The set of methods in image is different from what is specified in the project definition.\%1\You should probably make sure that all extension methods are all associated to the correct package.\\Check in image methods (%2) or definition methods (%3)?'
                                        bindWith: moreInfo
                                        with: methodsToCheckIn size
                                        with: methodsInPrjDef size) withCRs
                        labels:#('Image Methods' 'Definition Methods' 'Cancel') 
                        values:#(true false nil) 
                        default:nil.

"/                    answer := Dialog 
"/                        confirm:('Set of methods in image is different from what is specified in the project definition.\Check in image methods (%1) or definition methods (%2)?'
"/                                        bindWith: methodsToCheckIn size
"/                                        with: methodsInPrjDef size)
"/                        yesLabel:'Image Methods' 
"/                        noLabel:'Definition Methods'.
                    answer isNil ifTrue:[AbortOperationRequest raise].
                    answer ifFalse:[
                        methodsToCheckIn := methodsInPrjDef.
                    ].
                ].
            ].

            "/ also need the extensionVersion methods in the projectDefinition class,
            "/ which are kept in the extensions container. (the reason is that we need the proper
            "/ CVS id for the extensions container, not for the projDefinition container.
            packageToCheckIn asPackageId projectDefinitionClass theMetaclass selectorsAndMethodsDo:[:sel :mthd |
                (AbstractSourceCodeManager isExtensionsVersionMethodSelector:sel) ifTrue:[
                    methodsToCheckIn add:mthd
                ].
            ].

            (self
                checkinExtensionMethods:methodsToCheckIn
                forPackage:packageToCheckIn
                withInfo:checkinInfo)
            ifFalse:[
                Dialog warn:(resources string:'Could not check in extensions for project %1' with:packageToCheckIn).
                ^ self.
            ]
        ] ifFalse:[
            "/ there may have been extension-methods previously - if so, remove them
            (mgr
                checkForExistingContainer:'extensions.st' inPackage:packageToCheckIn)
            ifTrue:[
"/ self halt.
                (self
                    checkinExtensionMethods:#()
                    forPackage:packageToCheckIn
                    withInfo:'No extensions any more')
                ifFalse:[
                    Dialog warn:(resources string:'Could not check in extensions for project %1' with:packageToCheckIn).
                    ^ self.
                ]
            ]
        ].
    ].

    checkinInfo isNil ifTrue:[
        |infoString|

        doExtensions ifTrue:[
            infoString := '%1 classes (%4 changed) and %2 extensions for project "%3"'.
        ] ifFalse:[doClasses ifTrue:[
            infoString := '%1 classes (%4 changed) for project "%3"'.
        ] ifFalse:[doBuild ifTrue:[
            infoString := 'Build support files for project "%3"'.
        ] ifFalse:[
            infoString := 'I don''t know what I am doing'.
        ]]].

        infoString := infoString
                        bindWith:classesToCheckIn size
                        with:methodsToCheckIn size
                        with:packageToCheckIn allBold
                        with:classesInChangeSet size.
    
        checkinInfo := self
                    getCheckinInfoFor:infoString
                    initialAnswer:nil
                    withQuickOption:(classesToCheckIn size > 0)
                    withValidateConsistencyOption:true.
        checkinInfo isNil ifTrue:[
            ^ self.
        ].
        checkinInfo validateConsistency ifTrue:[
            self validateConsistencyOfPackage:packageToCheckIn doClasses:doClasses doExtensions:doExtensions.
        ].
    ].

    checkinInfo quickCheckIn ifTrue:[
        (checkinInfo isStable or:[checkinInfo tagIt]) ifTrue:[
            classesToTag := classesToCheckIn.
            originalCheckinInfo := checkinInfo.
            checkinInfo := checkinInfo deepCopy.
            checkinInfo isStable:false.
            checkinInfo tag:nil.
        ].
        "/ not only the one's in the changeSet;
        "/ also those which have not been checked in before.
        newClasses := classesToCheckIn select:[:class | (class revisionOfManager:mgr) isNil ].
        classesToCheckIn := Set new 
                                addAll:classesInChangeSet; 
                                addAll:newClasses; 
                                yourself.
    ].

    "/ check if any of the classes contains methods for other packages ...
    classesToCheckIn do:[:eachClass |
        eachClass instAndClassMethodsDo:[:eachMethod |
            |mPgk|

            mPgk := eachMethod package.
            (mPgk = packageToCheckIn) ifFalse:[
                mPgk == PackageId noProjectID ifTrue:[
                    looseMethods add:eachMethod
                ] ifFalse:[
                    methodsInOtherPackages add:eachMethod
                ]
            ]
        ].
    ].

    askForMethodsInOtherPackages ifTrue:[
        methodsInOtherPackages notEmpty ifTrue:[
            |package2|
            
            otherPackages := Set new.
            methodsInOtherPackages do:[:eachMethod | otherPackages add:eachMethod package].

            methodsInOtherPackages size == 1 ifTrue:[
                msg := 'The ''%4'' method in ''%5'' is contained in the ''%2'' package.'.
                msg := msg , '\\This method will remain in its package.'.
            ] ifFalse:[
                otherPackages size == 1 ifTrue:[
                    msg := 'The %1 methods from the %2 package will remain in their package.'
                ] ifFalse:[
                    package2 := otherPackages second allBold.
                    otherPackages size == 2 ifTrue:[
                        msg := 'The %1 methods from %3 other packages (%2, %6) will remain in their packages.'.
                    ] ifFalse:[
                        msg := 'The %1 methods from %3 other packages (%2, %6...) will remain in their packages.'.
                    ].
                ].
                msg := msg , '\\Hint: if these are meant to belong to the %7 package,'.
                msg := msg , '\move them first, then repeat the checkin operation.'.
            ].
            msg := msg withCRs.
            msg := msg bindWith:methodsInOtherPackages size
                           with:otherPackages first allBold
                           with:otherPackages size
                           with:methodsInOtherPackages first selector allBold
                           with:methodsInOtherPackages first mclass name allBold
                           with:package2
                           with:packageToCheckIn.
            (Dialog confirm:msg noLabel:(resources string:'Cancel')) ifFalse:[^ self].
        ].
    ].

    doClasses ifTrue:[
        classesToCheckIn notEmpty ifTrue:[
            looseMethods notEmpty ifTrue:[
                looseMethods size == 1 ifTrue:[
                    msg := 'The ''%2'' method in ''%3'' is unassigned (loose).'.
                    msg := msg , '\\If you proceed, this method will be moved to the ''%4'' package'.
                    msg := msg , '\\Hint: if this is meant to be an extension of another package,'.
                    msg := msg , '\cancel and move it to the appropriate package first.'.
                ] ifFalse:[
                    msg := 'There are %1 unassigned (loose) methods in classes from this project.'.
                    msg := msg , '\\If you proceed, those will be moved to the ''%4'' package ?'.
                    msg := msg , '\\Hint: if these are meant to be extensions of another package,'.
                    msg := msg , '\cancel and move them to the appropriate package first.'.
                ].
                doClasses ifTrue:[
                    msg := msg , '\\If you answer with "No" here, you will be asked for each class individually.'.
                ].
                msg := msg withCRs.
                msg := msg bindWith:looseMethods size
                               with:(looseMethods isEmpty ifTrue:[''] ifFalse:[looseMethods first selector allBold])
                               with:(looseMethods isEmpty ifTrue:[''] ifFalse:[looseMethods first mclass name allBold])
                               with:packageToCheckIn allBold.
                (Dialog confirm:msg noLabel:(resources string:'Cancel')) ifFalse:[^ self].

                looseMethods do:[:mthd |
                    mthd package:packageToCheckIn
                ].
            ].
            self checkinClasses:classesToCheckIn withInfo:checkinInfo.
        ].

        originalCheckinInfo notNil ifTrue:[
            originalCheckinInfo isStable ifTrue:[
                classesToTag do:[:eachClass |
                    self tagClass:eachClass as:#stable
                ].
            ].
            originalCheckinInfo tagIt ifTrue:[
                classesToTag do:[:eachClass |
                    self tagClass:eachClass as:(originalCheckinInfo tag)
                ].
            ].
        ].
    ].

    doBuild ifTrue:[
        self checkinBuildSupportFilesForPackage:packageToCheckIn withInfo:(originalCheckinInfo ? checkinInfo).
    ].

    "Created: / 13-10-2011 / 11:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2012 / 14:05:36 / cg"
!

comparePackages:packages askForRevision:askForRevision
    "Compares code of given packages (loaded in the image) against a specific revision
     and opens a diff browser on differences.
     
     If `askForRevision` is true, then user is asked to specify to which revision to
     update. If `askForRevision` is false, then packages are updated to a 'newest'
     revision.
     
     NOTE: Definition of `newest` revision may vary. For SCMs which allows for multiple
     heads, it is not clear which one it is. In that case, even if `askForRevision` is
     false, this method may result in user interaction, asking user to select which of the
     newest she wants."

    self comparePackages:packages askForRevision:askForRevision extensionsOnly:false

    "Created: / 04-04-2014 / 15:29:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comparePackages:packages askForRevision:askForRevision extensionsOnly:extensionsOnly
    "Compares code of given packages (loaded in the image) against a specific revision
     and opens a diff browser on differences.
     
     If `askForRevision` is true, then user is asked to specify to which revision to
     update. If `askForRevision` is false, then packages are updated to a 'newest'
     revision.
     
     NOTE: Definition of `newest` revision may vary. For SCMs which allows for multiple
     heads, it is not clear which one it is. In that case, even if `askForRevision` is
     false, this method may result in user interaction, asking user to select which of the
     newest she wants."

    |dateFormat string dateOrNil symbolicNameOrNil 
     someDfnClass knownTags includeSubProjectsHolder
     packagesIn packagesCompared|

    packagesIn := packages value.
    
    "/ being lazy, assume tags are persistent across packages (which they are not required to be...)
    someDfnClass := ProjectDefinition definitionClassForPackage:packagesIn first.
    someDfnClass isNil ifTrue:[ someDfnClass := Object projectDefinitionClass ].
    
    knownTags := (manager knownTagsFor:someDfnClass) asOrderedCollection sort.
    
    dateFormat := UserPreferences current dateInputFormat.

    includeSubProjectsHolder := true asValue.
    
    Dialog 
        modifyingBoxWith:[:box |
            box verticalPanel 
                add:(CheckBox label:(resources string:'Include Subprojects')
                              model:includeSubProjectsHolder).
        ]
        do:[
            |suggestion|

            suggestion := LastComparedTag.
            suggestion isNil ifTrue:[ suggestion := Date today printStringFormat:dateFormat ].
            
            string := Dialog
                        request:(resources
                                string:'Compare with version from date (%2) or tag (any other format) (empty for newest):'
                                with:dateFormat)
                        initialAnswer:suggestion
                        list:knownTags.
        ].
        
    string isNil ifTrue:[^ self].
    string notEmpty ifTrue:[
        dateOrNil := Date readFrom:string printFormat:dateFormat onError:nil.
        dateOrNil isNil ifTrue:[
            symbolicNameOrNil := string
        ].
    ].

    LastComparedTag := symbolicNameOrNil.
    
    packagesCompared := packagesIn.
    includeSubProjectsHolder value ifTrue:[
        packagesCompared := Smalltalk allPackageIDs
                        select:[:eachPackage |
                            packagesIn contains:[:p | 
                                eachPackage = p 
                                or:[ (eachPackage startsWith:(p,'-'))
                                or:[ (eachPackage startsWith:(p,':')) ]]
                            ]
                        ]    
    ].
    
    packagesCompared value do:[:eachProject |
        dateOrNil notNil ifTrue:[
            self compareProject:eachProject withRepositoryVersionFrom:dateOrNil extensionsOnly:extensionsOnly
        ] ifFalse:[
            self compareProject:eachProject withRepositoryVersionTaggedAs:symbolicNameOrNil extensionsOnly:extensionsOnly
        ]
    ].


    "Created: / 04-04-2014 / 15:29:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerUtilitiesForContainerBasedManagers class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

