"
 COPYRIGHT (c) 2000 eXept Software AG
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

Object subclass:#SourceCodeManagerUtilities
	instanceVariableNames:'manager resources confirmNewFiles'
	classVariableNames:'LastSourceLogMessage LastModule LastPackage YesToAllQuery
		YesToAllNotification LastSourceLogMessages DefaultUtilities
		LastTag'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!SourceCodeManagerUtilities class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 eXept Software AG
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
    utility code which is useful at more than one place
    (extracted from the browser)

    [author:]
        Claus Gittinger (cg@exept)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!SourceCodeManagerUtilities class methodsFor:'instance creation'!

forManager: aSourceCodeManager

    ^self new setManager: aSourceCodeManager

    "Created: / 10-10-2011 / 11:45:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    self == SourceCodeManagerUtilities ifTrue:[ 
        self abstractClassInstantiationError
    ].
    ^ self basicNew initialize.

    "Modified: / 25-07-2012 / 17:10:55 / cg"
! !

!SourceCodeManagerUtilities class methodsFor:'Signal constants'!

yesToAllNotification
    YesToAllNotification isNil ifTrue:[
        YesToAllNotification := QuerySignal new.
    ].
    ^ YesToAllNotification
!

yesToAllQuery
    YesToAllQuery isNil ifTrue:[
        YesToAllQuery := QuerySignal new.
    ].
    ^ YesToAllQuery
! !

!SourceCodeManagerUtilities class methodsFor:'accessing'!

default

    DefaultUtilities isNil ifTrue:[DefaultUtilities := SourceCodeManagerUtilitiesForContainerBasedManagers new].
    ^ DefaultUtilities

    "Created: / 10-10-2011 / 11:28:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 20:31:52 / cg"
!

lastModule
    "return the value of the static variable 'LastModule' (automatically generated)"

    ^ LastModule
!

lastModule:something
    "set the value of the static variable 'LastModule' (automatically generated)"

    LastModule := something.
!

lastPackage
    "return the value of the static variable 'LastPackage' (automatically generated)"

    ^ LastPackage
!

lastPackage:something
    "set the value of the static variable 'LastPackage' (automatically generated)"

    LastPackage := something.
! !

!SourceCodeManagerUtilities class methodsFor:'error handling'!

doesNotUnderstand: aMessage

    (self default respondsTo: aMessage selector) ifTrue:[
        "Bad, method moved to instance side but not forwarded"
        self breakPoint: #jv.
        self breakPoint: #cg.

        ^aMessage sendTo: self default
    ] ifFalse:[
        ^super doesNotUnderstand: aMessage
    ]

    "Created: / 10-10-2011 / 14:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerUtilities class methodsFor:'private-migration'!

compileForwarders

    "Utility method"

    "
        SourceCodeManagerUtilities compileForwarders.
    "

    self methodsDo:[:m|
        | sel |
        sel := m selector.
        ((self class includesSelector: sel) and: [(self class >> sel) source = m source]) ifTrue:[
            | source header |

            header := m source asStringCollection first.
            source := '%1

    <resource: #obsolete>

    self obsoleteMethodWarning: ''Please use instance protocol (SourceCodeManagerUtilities default doSomething)''.

    ^self default %1' bindWith: header with: header.

            self halt: 'Inspect source'.
            self class compile: source classified: m category.    
        ].
            
    ]

    "Created: / 11-10-2011 / 10:55:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerUtilities class methodsFor:'resources'!

resourcePackage
    ^ #'stx:libtool'
! !

!SourceCodeManagerUtilities class methodsFor:'utilities'!

classIsNotYetInRepository:aClass withManager:mgr

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default classIsNotYetInRepository:aClass withManager:mgr
!

nameOfExtensionsContainer

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default nameOfExtensionsContainer
!

setPackageOfAllMethodsIn:aClass to:aPackage

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default setPackageOfAllMethodsIn:aClass to:aPackage

    "Modified: / 10-10-2011 / 14:00:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setPackageOfAllMethodsInChangeSet:aChangeSet to:aPackage

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default setPackageOfAllMethodsInChangeSet:aChangeSet to:aPackage

    "Created: / 10-10-2011 / 14:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCodeManagerFor:aClass
    |mgr assumption|

    mgr := aClass theNonMetaclass sourceCodeManager.
    mgr isNil ifTrue:[
        SourceCodeManager isNil ifTrue:[
            "/ self warn:'SourceCodeManagement is disabled or not configured.\\Please setup in the Launcher.' withCRs.
            ^ nil.
        ].
        assumption := AbstractSourceCodeManager defaultManager ? CVSSourceCodeManager.
        assumption notNil ifTrue:[
            (self confirm:('Class does not seem to provide a valid sourceCodeManager.\\Assume %1 ?' bindWith:assumption managerTypeName) withCRs) ifFalse:[
                ^ nil
            ].
            mgr := assumption.
        ].
    ].
    ^ mgr
!

sourceCodeOfClass:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default sourceCodeOfClass:aClass
!

versionString:a isLessThan:b

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default versionString:a isLessThan:b
! !

!SourceCodeManagerUtilities class methodsFor:'utilities-cvs'!

changeSetForExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision usingManager:aSourceCodeManager

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default changeSetForExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision usingManager:aSourceCodeManager

    "Created: / 29-12-2011 / 14:28:08 / cg"
!

changeSetForExtensionMethodsForPackage:packageToCheckOut revision:revisionOrNil orAskForRevision:askForRevision usingManager:aSourceCodeManager

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default 
        changeSetForExtensionMethodsForPackage:packageToCheckOut 
        revision:revisionOrNil 
        orAskForRevision:askForRevision 
        usingManager:aSourceCodeManager

    "Created: / 29-12-2011 / 14:28:14 / cg"
!

checkForExistingModule:module directory:directory container:containerFileName usingManager:mgr allowCreate:allowCreate

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkForExistingModule:module directory:directory container:containerFileName usingManager:mgr allowCreate:allowCreate

    "Created: / 29-12-2011 / 14:30:37 / cg"
!

checkForExistingModule:module directory:directory usingManager:mgr allowCreate:allowCreate

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkForExistingModule:module directory:directory usingManager:mgr allowCreate:allowCreate

    "Created: / 29-12-2011 / 14:29:02 / cg"
!

checkForExistingModule:module usingManager:mgr allowCreate:allowCreate

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkForExistingModule:module usingManager:mgr allowCreate:allowCreate

    "Created: / 29-12-2011 / 14:30:00 / cg"
!

checkinClass:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClass:aClass
!

checkinClass:aClass withInfo:aLogInfoOrNil

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClass:aClass withInfo:aLogInfoOrNil
!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass
!

checkinClasses:aCollectionOfClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClasses:aCollectionOfClass
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrNil

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrNil
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringNil withCheck:doCheckClasses

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringNil withCheck:doCheckClasses
!

checkinExtensionMethods:aCollectionOfMethods forPackage:aPackageID withInfo:aLogInfoOrStringOrNil

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkinExtensionMethods:aCollectionOfMethods forPackage:aPackageID withInfo:aLogInfoOrStringOrNil
!

checkoutClass:aClass askForMerge:askForMerge

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkoutClass:aClass askForMerge:askForMerge
!

checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge
!

checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge askForConfirmation:askForConfirmation

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge askForConfirmation:askForConfirmation
!

checkoutExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision askForMerge:askForMerge usingManager:aSourceCodeManager

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkoutExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision askForMerge:askForMerge usingManager:aSourceCodeManager

    "Created: / 29-12-2011 / 14:34:24 / cg"
!

compareClassWithRepository:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default compareClassWithRepository:aClass
!

compareClassWithRepository:aClass askForRevision:askForRevision

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default compareClassWithRepository:aClass askForRevision:askForRevision
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:false
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly
!

compareProjectWithRepository:aProject

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default compareProjectWithRepository:aProject
!

createSourceContainerForClass:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default createSourceContainerForClass:aClass
!

defineSourceContainerForClass:aClass title:title text:boxText createDirectories:createDirs createContainer:createContainer

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default defineSourceContainerForClass:aClass title:title text:boxText createDirectories:createDirs createContainer:createContainer
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:false
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default 
        diffSetOfProject:aProject 
        againstRepositoryVersionFrom:aDateOrNilForNewest 
        extensionsOnly:extensionsOnly
!

ensureCorrectVersionMethodsInClass:aClass usingManager:aManager

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default ensureCorrectVersionMethodsInClass:aClass usingManager:aManager

    "Created: / 29-12-2011 / 14:33:37 / cg"
!

getLogMessageForClassCheckinTakingDefaultsFromPreviousLogInfo:aLogInfoOrNil forClass:aClass valuesInto:aBlock

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default getLogMessageForClassCheckinTakingDefaultsFromPreviousLogInfo:aLogInfoOrNil forClass:aClass valuesInto:aBlock
!

removeSourceContainerForClass:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default removeSourceContainerForClass:aClass
!

removeSourceContainerForClass:aClass confirm:doConfirm warn:doWarn

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default removeSourceContainerForClass:aClass confirm:doConfirm warn:doWarn
!

repositoryLogOf:aClass onto:aStream

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default repositoryLogOf:aClass onto:aStream
!

repositoryLogOf:aClass short:shortOrNot onto:aStream

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default repositoryLogOf:aClass short:shortOrNot onto:aStream
!

tagClass:aClass as:tag

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default tagClass:aClass as:tag
!

tagClasses:aCollectionOfClasses as:tag

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default tagClasses:aCollectionOfClasses as:tag
!

tagPath:aPath as:tag usingManager:aManager

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default tagPath:aPath as:tag usingManager:aManager

    "Created: / 29-12-2011 / 14:31:43 / cg"
! !

!SourceCodeManagerUtilities class methodsFor:'utilities-cvs-helpers'!

getMethodVersionsOfClass:aClass selector:selector numberOfRevisions:numberOfRevisionsOrNil

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default getMethodVersionsOfClass:aClass selector:selector numberOfRevisions:numberOfRevisionsOrNil
! !

!SourceCodeManagerUtilities class methodsFor:'utilities-cvs-user interaction'!

askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName
!

askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName forNewContainer:forNewContainer

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName forNewContainer:forNewContainer
!

askForExistingRevision:boxText title:title class:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default askForExistingRevision:boxText title:title class:aClass
!

askForExistingRevision:boxText title:title class:clsOrNil manager:aSourceCodeManager module:module package:directory fileName:fileName

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default askForExistingRevision:boxText title:title class:clsOrNil manager:aSourceCodeManager module:module package:directory fileName:fileName
!

checkAndWarnAboutBadMessagesInClass:aClass checkAgainHolder:checkAgainHolder

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default checkAndWarnAboutBadMessagesInClass:aClass checkAgainHolder:checkAgainHolder
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil
    ^self default 
        getCheckinInfoFor:aClassNameOrPackageNameString     
        initialAnswer:initialAnswerOrNil

    "Modified: / 12-03-2012 / 12:56:45 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil withQuickOption:withQuickOption
    ^self default 
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswerOrNil 
        withQuickOption:withQuickOption

    "Modified: / 12-03-2012 / 12:56:50 / cg"
!

goodInitialLogMessageForCheckinClassOfClass:aClass

    <resource: #obsolete>

    self obsoleteMethodWarning: 'Please use instance protocol (SourceCodeManagerUtilities default doSomething)'.

    ^self default goodInitialLogMessageForCheckinClassOfClass:aClass
! !

!SourceCodeManagerUtilities class methodsFor:'utilities-encoding'!

guessEncodingOfFile:aFilename

    <resource: #obsolete>

    self obsoleteMethodWarning:'ask CharacterEncoder'.
    ^ CharacterEncoder guessEncodingOfFile:aFilename
!

guessEncodingOfStream:aStream

    <resource: #obsolete>

    self obsoleteMethodWarning:'ask CharacterEncoder'.
    ^ CharacterEncoder guessEncodingOfStream:aStream
! !

!SourceCodeManagerUtilities methodsFor:'accessing'!

confirmNewFiles:aBoolean
    "if true, ask if new files are about to be added to the repo"

    confirmNewFiles := aBoolean.

    "Modified (comment): / 24-07-2012 / 18:18:34 / cg"
!

lastSourceLogMessageHeadlines
    LastSourceLogMessage isNil ifTrue:[
        LastSourceLogMessages := OrderedCollection new.
    ].
    ^ LastSourceLogMessages 
        collect:[:msg |
            msg withoutLeadingSeparators asCollectionOfLines first , '...'
        ]

    "Created: / 12-03-2012 / 12:34:35 / cg"
!

yesToAllNotification

    ^self class yesToAllNotification

    "Created: / 11-10-2011 / 12:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

yesToAllQuery

    ^self class yesToAllQuery

    "Created: / 11-10-2011 / 12:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerUtilities methodsFor:'error handling'!

doesNotUnderstand: aMessage

    (self class respondsTo: aMessage selector) ifTrue:[
        "Bad, method is not moved the the instance side"
        self breakPoint: #jv.
        self breakPoint: #cg.

        ^aMessage sendTo: self class
    ] ifFalse:[
        ^super doesNotUnderstand: aMessage
    ]

    "Created: / 10-10-2011 / 14:02:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerUtilities methodsFor:'initialization'!

initialize
    confirmNewFiles := true.
    resources := self class classResources.

    "Modified: / 13-10-2011 / 11:03:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2012 / 18:17:57 / cg"
!

setManager: aSourceCodeManager

    manager := aSourceCodeManager.
    manager isContainerBased ifFalse:[
        confirmNewFiles isNil "not yet set by user" ifTrue:[
            confirmNewFiles := false.
        ]
    ].

    "Created: / 10-10-2011 / 11:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2012 / 08:35:35 / cg"
! !

!SourceCodeManagerUtilities methodsFor:'utilities'!

classIsNotYetInRepository:aClass withManager:mgr
    |info|

    info := mgr sourceInfoOfClass:aClass.

    ^ (info isNil 
    or:[(info at:#fileName ifAbsent:nil) isNil
    or:[(info at:#module ifAbsent:nil) isNil
    or:[(info at:#directory ifAbsent:nil) isNil]]])

    "Created: / 25-10-2006 / 09:43:00 / cg"
!

defaultManager
    ^ manager

    "Created: / 22-12-2011 / 10:59:28 / cg"
!

nameOfExtensionsContainer
    ^ 'extensions.st'
!

setPackageOfAllMethodsIn:aClass to:aPackage
    "make all methods belong to the classes project"

    |anyChange anyChangeHere|

    anyChange := false.
    aClass withAllPrivateClassesDo:[:eachClass |
        anyChangeHere := false.
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | 
            mthd package ~= aPackage ifTrue:[
                mthd setPackage:aPackage.
                anyChangeHere := true.
            ].
        ].
        anyChangeHere ifTrue:[
            eachClass changed:#projectOrganization
        ].
        anyChangeHere ifTrue:[anyChange := true].
    ].
    anyChange ifTrue:[
       Smalltalk changed:#projectOrganization
    ].
    ^ anyChange
!

setPackageOfAllMethodsInChangeSet:aChangeSet to:aPackage
    "make all methods belong to the classes project"

    aChangeSet do:[:eachChange |
        eachChange isMethodCodeChange ifTrue:[
            eachChange changeMethod package ~= aPackage ifTrue:[
                Transcript showCR:'change package of ',eachChange changeMethod whoString.
                eachChange changeMethod setPackage:aPackage.        
            ]
        ]
    ].
!

sourceCodeForExtensions:aCollectionOfMethods package:aPackageID forManager:scmManagerOrNil
    |s methodsSortedByName defClass|

    s := CharacterWriteStream on:(String new:1000).

    s nextPutAll:'"{ Package: '''.
    s nextPutAll:aPackageID asString.
    s nextPutAll:''' }"'; nextPutChunkSeparator; cr; cr.

    "/ don't write a timestamp. Otherwise we would always generate a new version, even if nothing changed
    "/ s nextPutAll:(Smalltalk timeStamp).
    "/ s nextPutChunkSeparator. 
    "/ s cr; cr.

    "/ sort them by name (to avoid conflicts due to SCM merge)
    methodsSortedByName := aCollectionOfMethods asOrderedCollection.
    methodsSortedByName sort:[:a :b |
                                |clsA clsB|

                                clsA := a mclass name.
                                clsB := b mclass name.
                                clsA < clsB ifTrue:[
                                    true
                                ] ifFalse:[
                                    clsA > clsB ifTrue:[
                                        false
                                    ] ifFalse:[
                                        a selector < b selector
                                    ]
                                ]
                              ].
    methodsSortedByName do:[:aMethod |
        aMethod mclass fileOutMethod:aMethod on:s.
        s cr.
    ].

    scmManagerOrNil notNil ifTrue:[
        defClass := ProjectDefinition definitionClassForPackage:aPackageID.
        defClass notNil ifTrue:[
            "/ make sure, an extensionVersion_XXX method is included...
            "/ (notice: no need to support a secondary backward compatible non-manager related version method here)
            (methodsSortedByName contains:[:aMethod | aMethod selector == scmManagerOrNil nameOfVersionMethodForExtensions]) ifFalse:[
                s nextPutLine:('!!%1 class methodsFor:''documentation''!!' bindWith:defClass name).
                s cr.
                s nextChunkPut:
                    (scmManagerOrNil versionMethodTemplateForSmalltalkFor:(scmManagerOrNil nameOfVersionMethodForExtensions)).
                s space; nextPutChunkSeparator; cr.
            ].
        ].
    ].

    ^ s contents.

    "Created: / 25-07-2012 / 18:38:05 / cg"
!

sourceCodeManagerFor:aClass
    manager notNil ifTrue:[^ manager].
    ^ self class sourceCodeManagerFor:aClass.    
!

sourceCodeOfClass:aClass
    |stream src|

    stream := '' writeStream.
    Method flushSourceStreamCache.
    aClass fileOutOn:stream withTimeStamp:false.
    src := stream contents asString.
    stream close.
    ^ src
!

validateConsistencyOfPackage:aPackage
    ^ self validateConsistencyOfPackage:aPackage doClasses:true  doExtensions:true
!

validateConsistencyOfPackage:aPackage doClasses:doClasses doExtensions:doExtensions
    |checker report msg answer dialog problems numProblems|

    "/ also done by ProjectChecker...
    "/ defClass := aPackage asPackageId projectDefinitionClass.
    "/ defClass validateDescription.

    checker := ProjectChecker new.
    checker checkExtensionsOnly:(doClasses not and:[ doExtensions ]).
    report := checker check: aPackage.
    (report notNil and:[(problems := report problems) notEmptyOrNil]) ifTrue:[
        numProblems := problems size.
        numProblems == 1 ifTrue:[
            msg := 'The ProblemChecker found the following error/inconsistency:\\    %2\\Need more detail or help for repair?'
        ] ifFalse:[
            msg := 'The ProblemChecker found %1 errors/inconsistencies.\\Browse them for detail or repair?'
        ].
        answer := Dialog confirmWithCancel:(msg bindWith:numProblems 
                                                with:problems first label) withCRs.
        answer isNil ifTrue:[
            "/ cancel
            AbortOperationRequest raiseRequest
        ].
        answer == true ifTrue:[
            dialog := Tools::ProjectCheckerBrowser new.
            dialog
                projectChecker: (ProjectChecker forPackage: aPackage);
                problemList:problems;
                showCancel:true;
                openModal.

            dialog accepted ifFalse:[
                AbortOperationRequest raiseRequest
            ].
        ].
    ].
!

versionString:a isLessThan:b
    "compare two strings of the form: a.b.c..."

    |i1 i2 a1 b1 rest1 rest2|

    i1 := a indexOf:$. .
    i2 := b indexOf:$. .
    i1 == 0 ifTrue:[
        i1 := a size + 1.
    ].
    i2 == 0 ifTrue:[
        i2 := b size + 1.
    ].

    a1 := Integer readFrom:(a copyTo:i1-1).
    b1 := Integer readFrom:(b copyTo:i2-1).
    a1 < b1 ifTrue:[^ true].
    a1 > b1 ifTrue:[^ false].
    rest1 := (a copyFrom:i1+1).
    rest2 := (b copyFrom:i2+1).
    rest1 isEmpty ifTrue:[
        ^ rest2 notEmpty
    ].
    rest2 isEmpty ifTrue:[
        ^ false
    ].
    ^ self versionString:rest1 isLessThan:rest2

    "
     self assert:(self versionString:'12.34.66' isLessThan:'12.35.66').
     self assert:(self versionString:'12.34.66' isLessThan:'12.35.67').
     self assert:(self versionString:'11.34.66' isLessThan:'12.34.67').
     self assert:(self versionString:'11.35.66' isLessThan:'12.34.67').
     self assert:(self versionString:'13.35.66' isLessThan:'12.34.67') not.
     self assert:(self versionString:'13.35.66' isLessThan:'13.34.67') not.
     self assert:(self versionString:'13.35.66' isLessThan:'13.35.67').
     self assert:(self versionString:'13.35.66' isLessThan:'13.35.65') not.
     self assert:(self versionString:'13.35.66.1' isLessThan:'13.35.66') not.
     self assert:(self versionString:'13.35.66' isLessThan:'13.35.66.1').
     self assert:(self versionString:'13.35.66.2' isLessThan:'13.35.66.1') not.
     self assert:(self versionString:'13.35.66.1' isLessThan:'13.35.66.2').
    "

    "Modified: / 17-02-2011 / 10:20:14 / cg"
! !

!SourceCodeManagerUtilities methodsFor:'utilities-cvs'!

changeSetForExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision usingManager:aSourceCodeManager
    "check-out an extension container from the source repository, and return the methods there as a change set.
     If askForRevision is false, check-out the newest version.
     Return a changeSet or nil (if any error occurred)"

    ^ self
        changeSetForExtensionMethodsForPackage:packageToCheckOut 
        revision:nil orAskForRevision:askForRevision 
        usingManager:aSourceCodeManager

    "Created: / 29-12-2011 / 14:26:01 / cg"
!

changeSetForExtensionMethodsForPackage:packageToCheckOut revision:revisionOrNil orAskForRevision:askForRevision usingManager:aSourceCodeManager
    "check-out an extension container from the source repository, and return the methods there as a change set.
     If askForRevision is false, check-out the newest version.
     Return a changeSet or nil (if any error occurred)"

    |directory module file aStream sourceToLoad rev msg newestRev |

    directory := packageToCheckOut asPackageId directory.
    module := packageToCheckOut asPackageId module.
    file := self nameOfExtensionsContainer.

    "/
    "/ ask for revision
    "/
    (rev := revisionOrNil) isNil ifTrue:[
        newestRev := aSourceCodeManager newestRevisionInFile:file directory:directory module:module.
        askForRevision ifFalse:[
            rev := newestRev ? ''
        ] ifTrue:[
            msg := resources string:'CheckOut which revision of extensions for ''%1'': (empty for newest)' with:packageToCheckOut allBold.
            newestRev notNil ifTrue:[
                msg := msg , '\' , (resources string:'Newest in repository is %1.' with:newestRev)
            ].

            rev := self
                    askForExistingRevision:msg 
                    title:'CheckOut from repository' 
                    class:nil 
                    manager:aSourceCodeManager 
                    module:module package:directory fileName:file.

            rev isNil ifTrue:[
                ^ nil   "/ canceled
            ].
        ].
    ].
    rev withoutSpaces isEmpty ifTrue:[
        rev := #newest.
        msg := 'extracting newest %1 (' , (newestRev ? '???') , ')'.
    ] ifFalse:[
        msg := 'extracting previous %1'.
    ].
    aStream := aSourceCodeManager  
        streamForClass:nil
        fileName:file 
        revision:rev 
        directory:directory 
        module:module
        cache:true.

    aStream isNil ifTrue:[
        self warn:(resources string:'Could not extract "extensions.st" for %1 from repository' with:packageToCheckOut allBold).
        ^ nil
    ].
    aStream class readErrorSignal handle:[:ex |
        self warn:('read error while reading extracted source\\' , ex description) withCRs.
        aStream close.
        ^ nil
    ] do:[
        sourceToLoad := aStream contents asString.
    ].
    aStream close.
    ^ ChangeSet fromStream:(sourceToLoad readStream).

    "Created: / 29-12-2011 / 14:27:00 / cg"
!

checkForExistingModule:module directory:directory container:containerFileName usingManager:mgr allowCreate:allowCreate
    |moduleName directoryName containerName|

    moduleName := module allBold.
    directoryName := directory allBold.
    containerName := containerFileName allBold.

    "/
    "/ check for the container
    "/
    (mgr checkForExistingContainer:containerFileName inModule:module directory:directory) ifFalse:[
        allowCreate ifFalse:[
            self warn:(resources string:'A container for ''%1'' does not exist in ''%2:%3''' 
                                   with:containerName with:moduleName with:directoryName) withCRs.
            ^ false
        ].
        (Dialog 
            confirm:(resources string:'''%1'' is a new container (in ''%2:%3'').\\Create it ?' 
                                 with:containerName with:moduleName with:directoryName) withCRs
            noLabel:'Cancel') 
        ifFalse:[
            ^ false.
        ].
        (mgr createContainerForText:'' inModule:module package:directory container:containerFileName) ifFalse:[
            self warn:(resources string:'Cannot create new container: ''%1'' (in ''%2:%3'')' 
                                 with:containerName with:moduleName with:directoryName).
            ^ false.
        ]
    ].
    ^ true.

    "Modified: / 13-09-2006 / 18:24:57 / cg"
    "Created: / 29-12-2011 / 14:35:36 / cg"
!

checkForExistingModule:module directory:directory usingManager:mgr allowCreate:allowCreate
    |moduleNameBold directoryNameBold|

    moduleNameBold := module allBold.
    directoryNameBold := directory allBold.

    "/
    "/ check for the directory
    "/
    (mgr checkForExistingModule:module directory:directory) ifFalse:[
        allowCreate ifFalse:[
            self warn:(resources string:'A directory for ''%1'' does not exist in module ''%2''' 
                                   with:directoryNameBold with:moduleNameBold) withCRs.
            ^ false
        ].
        (Dialog 
            confirm:(resources stringWithCRs:'''%1'' is a new directory in module ''%2''.\\Create it in %3?' 
                                with:directoryNameBold 
                                with:moduleNameBold
                                with:mgr managerTypeName)
            noLabel:'Cancel') 
        ifFalse:[
            ^ false.
        ].
        (mgr createModule:module directory:directory) ifFalse:[
            self warn:(resources stringWithCRs:'Cannot create new directory: ''%1'' in module ''%2'' in %3' 
                                 with:directoryNameBold 
                                 with:moduleNameBold
                                 with:mgr managerTypeName).
            ^ false.
        ]
    ].
    ^ true.

    "Modified: / 21-12-2011 / 18:46:11 / cg"
    "Created: / 29-12-2011 / 14:35:20 / cg"
!

checkForExistingModule:module usingManager:mgr allowCreate:allowCreate
    |moduleName answer|

    (mgr checkForExistingModule:module) ifFalse:[
        moduleName := module allBold.

        allowCreate ifFalse:[
            self warn:(resources stringWithCRs:'A module named ''%1'' does not exist in the repository' 
                                  with:moduleName) .
            ^ false
        ].
        AbortAllOperationWantedQuery query ifTrue:[
            answer := Dialog 
                confirmWithCancel:(resources stringWithCRs:'''%1'' is a new module.\\create it ?' with:moduleName)
                labels:(resources array:#('Cancel All' 'Cancel' 'Yes' )).
            answer isNil ifTrue:[ AbortAllOperationRequest raise ].
        ] ifFalse:[
            answer := Dialog 
                confirm:(resources stringWithCRs:'''%1'' is a new module in %2.\\create it ?' with:moduleName with:mgr managerTypeName) 
                noLabel:'Cancel'
        ].
        answer ifFalse:[ ^ false].

        (mgr createModule:module) ifFalse:[
            self warn:(resources stringWithCRs:'Cannot create new module: ''%1'' in %2' with:moduleName with:mgr managerTypeName) .
            ^ false.
        ]
    ].
    ^ true.

    "Modified: / 21-12-2011 / 18:42:03 / cg"
    "Created: / 29-12-2011 / 14:35:06 / cg"
!

checkOutPackages: packages askForRevision: askForRevision
    "Updates code of given packages (loaded in the image) to a specific revision.
     If `askForRevision` is true, then user is asked to specify to which revision to
     update. If `askForRevision` is false, then packages are updated to a 'newest'
     revision. 

     NOTE: Definition of `newest` revision may vary. For SCMs which allows for multiple
     heads, it is not clear which one it is. In that case, even if `askForRevision` is
     false, this method may result in user interation, asking user to select which of the
     newest she wants.

     NOTE: Naming is bit confusing, it should be something like #updatePackages:ask...
     but to keep this in line with other methods, we use #checkOutPackages"

    ^ self subclassResponsibility.

    "Created: / 01-04-2014 / 21:50:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkinClass:aClass
    "check a class into the source repository.
     Asks interactively for a log-message."

    ^ self checkinClass:aClass withInfo:nil
!

checkinClass:aClass withInfo:aLogInfoOrNil
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for a log-message."

    ^ self checkinClass:aClass withInfo:aLogInfoOrNil withCheck:true
!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

    ^ self 
        checkinClass:aClass 
        withInfo:aLogInfoOrNil 
        withCheck:doCheckClass 
        usingManager:(self sourceCodeManagerFor:aClass)

    "Modified: / 21-12-2011 / 18:19:55 / cg"
!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClassHolder usingManager:managerOrNil
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

    ^ self
        checkinClass:aClass 
        withInfo:aLogInfoOrNil withCheck:doCheckClassHolder 
        usingManager:managerOrNil 
        confirmNewContainer:confirmNewFiles
!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClassHolder usingManager:managerOrNil confirmNewContainer:confirmNewContainer
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

    |logMessage checkinInfo mgr pri|

    aClass isLoaded ifFalse:[
        self information:(resources string:'Cannot checkin unloaded classes (%1)' with:aClass name).
        ^ false.
    ].

    mgr := managerOrNil.
    mgr isNil ifTrue:[
        mgr := self sourceCodeManagerFor:aClass.
        mgr isNil ifTrue:[
            ^ false
        ]
    ].

    self ensureCorrectVersionMethodsInClass:aClass usingManager:mgr.
    mgr supportsCheckinLogMessages ifTrue:[
        (self 
            getLogMessageForClassCheckinTakingDefaultsFromPreviousLogInfo:aLogInfoOrNil 
            forClass:aClass
            valuesInto:[:logMessageRet :checkinInfoRet |
                logMessage := logMessageRet.
                checkinInfo := checkinInfoRet.
            ]
        ) ifFalse:[^ false].
    ].

    (self classIsNotYetInRepository:aClass withManager:mgr) ifTrue:[
        (self createSourceContainerForClass:aClass usingManager:mgr confirmNewContainer:confirmNewContainer) ifFalse:[
"/            self warn:'did not create a container for ''' , aClass name , ''''.
            ^ false
        ].
        ^ true.
    ].

    self activityNotification:(resources string:'checking in %1' with:aClass name).
    pri := Processor activePriority.
    Processor activeProcess withPriority:pri-1 to:pri
    do:[
        |revision aborted freshCreated|

        freshCreated := false.
        revision := aClass revision.
        revision isNil ifTrue:[ 
            mgr isContainerBased ifTrue:[
                "/ mhmh - check if it has a container.
                (mgr checkForExistingContainerForClass:aClass) ifFalse:[
                    (self createSourceContainerForClass:aClass usingManager:mgr confirmNewContainer:confirmNewContainer) ifFalse:[
                        self warn:'Did not create/change repository container for ''' , aClass name allBold , ''''.
                        ^ false.
                    ].
                    freshCreated := true.
                ]
            ]
        ].

        doCheckClassHolder value ifTrue:[
            "/ check if the class contains halts, error-sends etc.
            (self checkAndWarnAboutBadMessagesInClass:aClass checkAgainHolder:doCheckClassHolder) ifFalse:[
                ^ false
            ].
        ].

        freshCreated ifFalse:[
            aborted := false.
            AbortOperationRequest handle:[:ex |
                aborted := true.
                ex return.
            ] do:[
                |checkinState cause|
                checkinState := false.
                cause := ''.
                [
                    checkinState := mgr checkinClass:aClass logMessage:logMessage
                ] on:SourceCodeManagerError do:[:ex| 
                    cause := ex description.
                    "/ ex proceed.
                ].

                checkinState ifFalse:[
                    Transcript showCR:'checkin of ''' , aClass name , ''' failed - ', cause.
                    self warn:(resources stringWithCRs:'Checkin of "%1" failed\\' with:aClass name allBold),cause.
                    AbortOperationRequest raise.
                    "/ ^ false.
                ].
                checkinInfo notNil ifTrue:[
                    checkinInfo isStable ifTrue:[
                        "set stable tag for class that has been checked in"
                        self tagClass:aClass as:#stable.
                    ].
                    checkinInfo tagIt ifTrue:[
                        "set any additional tags for the class that has been checked in"
                        (checkinInfo tag asCollectionOfSubstringsSeparatedByAny:',;') do:[:eachTag |
                            self tagClass:aClass as:eachTag withoutSeparators.
                        ].
                    ].
                    CVSSourceCodeManager recentTag:checkinInfo tag.
                ].
            ].
            aborted ifTrue:[
                Transcript showCR:'Checkin of ''' , aClass name , ''' aborted'.

                AbortAllOperationWantedQuery query ifTrue:[
                    (Dialog 
                        confirm:(resources stringWithCRs:'Checkin of "%1" aborted.\\Cancel all ?' with:aClass name)
                        default:false)
                    ifTrue:[
                        AbortAllOperationRequest raise.
                    ]
                ].
                ^ false.
            ].
        ].
    ].
    ^ true

    "Created: / 21-12-2011 / 18:19:14 / cg"
!

checkinClasses:aCollectionOfClass
    "check a collection of classes into the source repository.
     Asks interactively for log-message."

    ^ self checkinClasses:aCollectionOfClass withInfo:nil
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrNil
    "check a bunch of classes into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message."

    |checkClassWhenCheckingInHolder|

    checkClassWhenCheckingInHolder := ValueHolder with:(UserPreferences current at:#checkClassesWhenCheckingIn ifAbsent:true).
    checkClassWhenCheckingInHolder 
        onChangeEvaluate:[ UserPreferences current at:#checkClassesWhenCheckingIn put:checkClassWhenCheckingInHolder value ].

    ^ self
        checkinClasses:aCollectionOfClasses 
        withInfo:aLogInfoOrNil 
        withCheck:checkClassWhenCheckingInHolder
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringNil withCheck:doCheckClassesHolder
    "check a bunch of classes into the source repository.
     If the argument, aLogInfoOrStringNil isNil, ask interactively for log-message."

    self checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringNil withCheck:doCheckClassesHolder usingManager:nil

    "Modified: / 21-12-2011 / 18:24:47 / cg"
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringOrNil withCheck:doCheckClassesHolder usingManager:aManagerOrNil
    "check a bunch of classes into the source repository.
     If the argument, aLogInfoOrStringOrNil isNil, ask interactively for log-message."

    ^ self
        checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringOrNil withCheck:doCheckClassesHolder 
        usingManager:aManagerOrNil 
        confirmNewContainer:confirmNewFiles
!

checkinClasses:aCollectionOfClasses withInfo:aLogInfoOrStringOrNil withCheck:doCheckClassesHolder 
    usingManager:aManagerOrNil confirmNewContainer:confirmNewContainer
    "check a bunch of classes into the source repository.
     If the argument, aLogInfoOrStringOrNil isNil, ask interactively for log-message."

    |classes allClasses checkinInfoOrString yesOrNoToAll unchangedClasses|

    "/ ignore private classes
    classes := aCollectionOfClasses select:[:aClass | aClass owningClass isNil].
    classes isEmpty ifTrue:[
        self information:'Only private classes given - nothing checked in.'.
        ^ self
    ].
    classes := classes select:[:aClass | aClass isLoaded].
    classes isEmpty ifTrue:[
        self information:'Only unloaded classes given - nothing checked in.'.
        ^ self
    ].

    classes size == 1 ifTrue:[
        self 
            checkinClass:classes first 
            withInfo:aLogInfoOrStringOrNil withCheck:doCheckClassesHolder 
            usingManager:aManagerOrNil
            confirmNewContainer:confirmNewContainer.
        ^ self
    ].

    "ask once, for all classes"
    aLogInfoOrStringOrNil isNil ifTrue:[
        checkinInfoOrString := self 
                        getCheckinInfoFor:(resources string:'%1 classes to checkin' with:aCollectionOfClasses size)
                        initialAnswer:nil
                        withQuickOption:true.
        checkinInfoOrString isNil ifTrue:[^ self].
    ] ifFalse:[
        checkinInfoOrString := aLogInfoOrStringOrNil.
    ].

    allClasses := classes.    
    (checkinInfoOrString isString not and:[checkinInfoOrString quickCheckIn]) ifTrue:[
        "/ not only the one's in the changeSet;
        "/ also those which have not been checked in before.
        classes := classes select:[:each | each hasUnsavedChanges or:[ (each revisionOfManager:aManagerOrNil) isNil ]].
        classes isEmpty ifTrue:[ Dialog information:'no changes to checkin (quickCheckIn)' ]
    ].

    "abortAll is handled, and also asked for here!!"
    AbortAllOperationRequest handleAndAnswerQueryIn:[
        classes notEmpty ifTrue:[
            self yesToAllNotification handle:[:ex |
                yesOrNoToAll := ex parameter.
                ex proceed
            ] do:[
                self yesToAllQuery handle:[:ex |
                    ex proceedWith:yesOrNoToAll
                ] do:[
                    classes do:[:aClass |
                        self activityNotification:(resources string:'checking in %1' with:aClass name).
                        "/ ca does not want boxes to pop up all over ...
                        UserInformation handle:[:ex |
                            Transcript showCR:ex description.
                            ex proceed.
                        ] do:[
                            AbortOperationRequest catch:[
                                self 
                                    checkinClass:aClass 
                                    withInfo:checkinInfoOrString 
                                    withCheck:doCheckClassesHolder
                                    usingManager:aManagerOrNil
                                    confirmNewContainer:confirmNewContainer
                            ]
                        ].
                    ].
                ]
            ].
        ].

        (checkinInfoOrString isString not and:[ (checkinInfoOrString isStable or:[checkinInfoOrString tagIt]) ])
        ifTrue:[
            "/mhmh - but tag should be set on all (even unchanged ones)
            "/ the other onces have already been tagged
            unchangedClasses := allClasses reject:[:eachClass | (classes includes:eachClass)].

            "mhmh - could still have to tag them"
            checkinInfoOrString isStable ifTrue:[
                unchangedClasses do:[:eachClass |
                    self tagClass:eachClass as:#stable.
                ].
            ].
            checkinInfoOrString tagIt ifTrue:[
                unchangedClasses do:[:eachClass |
                    self tagClass:eachClass as:(checkinInfoOrString tag).
                ].
            ].
        ].
    ].

    "Created: / 21-12-2011 / 18:24:25 / cg"
!

checkoutClass:aClass askForMerge:askForMerge
    "check-out a class from the source repository."

    self
        checkoutClass:aClass 
        askForRevision:true
        askForMerge:askForMerge
!

checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge
    "check-out a class from the source repository.
     If askForRevision is false, check-out the newest version."

    self
        checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge 
        askForConfirmation:true
!

checkoutClass:aClass askForRevision:askForRevision askForMerge:askForMerge askForConfirmation:askForConfirmation
    "check-out a class from the source repository.
     If askForRevision is false, check-out the newest version."

    |mgr sourceInfo
     currentClass inChangeSet
     aStream sourceToLoad currentSource rev revString
     nm msg rev2 newestRev
     containerModule containerPackage containerFile rslt
     pkg listHere listRep diffSet 
     changed onlyHere onlyInRep answer labels values singleChangeSelector
     changedClasses default versionMethodsHere versionMethodsRep changedClassDefinitions
     wasInChangeSetBefore|

    aClass isNil ifTrue:[self error:'nil class'].

    currentClass := aClass theNonMetaclass.

    nm := currentClass name.
    mgr := self sourceCodeManagerFor:currentClass.
    mgr isNil ifTrue:[
        ^ self
    ].

    sourceInfo := mgr sourceInfoOfClass:currentClass.
    sourceInfo notNil ifTrue:[
        currentClass package ~= PackageId noProjectID ifTrue:[
            containerPackage := mgr directoryFromSourceInfo:sourceInfo.
            containerModule := mgr moduleFromSourceInfo:sourceInfo.
        ].
        containerFile := mgr containerFromSourceInfo:sourceInfo.
    ].

    currentClass isLoaded ifTrue:[
        rev := currentClass binaryRevision.
        rev2 := currentClass revision.
        rev isNil ifTrue:[
            rev := rev2
        ].
        rev isNil ifTrue:[
            pkg := currentClass package.
            (pkg notNil and:[pkg ~= PackageId noProjectID]) ifTrue:[
                containerModule := pkg upTo:$:.
                containerPackage := pkg copyFrom:(containerModule size + 2).
            ].
            containerModule size == 0 ifTrue:[
                containerModule := (self class lastModule ) ? Project current repositoryModule.
            ].
            containerPackage size == 0 ifTrue:[
                containerPackage := (self class lastPackage ) ? Project current package.
            ].
            answer := self confirmWithCancel:(resources 
                                                string:'The class %3 seems to have no (valid) repository information.\\I assume you want to check it out from: %1/%2.' 
                                                with:containerModule allBold 
                                                with:containerPackage allBold
                                                with:currentClass name allBold) withCRs.
            answer isNil ifTrue:[^ self "cancelled"].
            answer ifFalse:[
                rslt := self
                    askForContainer:(resources string:'The class seems to have no repository information.\\Do you want to checkOut from an existing containers contents ?')
                    title:'Container to load from' note:nil 
                    initialModule:containerModule 
                    initialPackage:containerPackage 
                    initialFileName:(currentClass nameWithoutPrefix , '.st')
                    forNewContainer:false.

                rslt isNil ifTrue:[
                    "/ canel
                    ^ self
                ].
                containerModule := "lastModule :=" rslt at:#module.
                containerPackage := "lastPackage :=" rslt at:#package.
                containerFile := rslt at:#fileName.
            ].

"/            rslt := self
"/                askForContainer:(resources string:'The class seems to have no (valid) repository information.\\Do you want to check it out from an existing container ?')
"/                title:'Container to checkOut' note:nil 
"/                initialModule:containerModule 
"/                initialPackage:containerPackage
"/                initialFileName:(currentClass name , '.st').
"/                forNewContainer:false.
"/            rslt isNil ifTrue:[^ self].
            "/ self warn:(resources string:'Class %1 seems to be not yet in the repository' with:currentClass name allBold).
            "/ ^ self
        ].
    ].

    containerFile isNil ifTrue:[
        containerFile := currentClass classFilename.
    ].

    "/
    "/ class in repository - ask for revision
    "/
    containerModule isNil ifTrue:[
        containerModule := Dialog request:(resources 
                                        stringWithCRs:'Missing Module Information for CheckOut of "%1".\\Module:'
                                        with:aClass name allBold).
        containerModule isEmptyOrNil ifTrue:[^ self].
    ].
    containerPackage isNil ifTrue:[
        containerPackage := Dialog request:(resources 
                                        stringWithCRs:'Missing Package Information for CheckOut of "%1".\\Package:'
                                        with:aClass name allBold).
        containerPackage isEmptyOrNil ifTrue:[^ self].
    ].

    newestRev := mgr newestRevisionInFile:containerFile directory:containerPackage module:containerModule.
    askForRevision ifFalse:[
        rev := newestRev ? ''
    ] ifTrue:[
        msg := resources string:'CheckOut which revision of ''%1'': (empty for newest)' with:nm allBold.
        rev notNil ifTrue:[
            msg := msg , '\\' , (resources string:'Current ''%1'' is based upon rev %2.'
                                           with:nm allBold with:rev).
            (rev2 notNil and:[rev2 ~= rev]) ifTrue:[
                msg := msg , '\' , (resources string:'And has been checked into the repository as %1.' with:rev2)
            ]
        ].
        newestRev notNil ifTrue:[
            msg := msg , '\' , (resources string:'Newest in repository is %1.' with:newestRev)
        ].

        rev := self
                    askForExistingRevision:msg 
                    title:'CheckOut from repository' 
                    class:currentClass.
        rev isNil ifTrue:[
            ^ self   "/ canceled
        ].
    ].

    rev withoutSpaces isEmpty ifTrue:[
        msg := 'extracting newest %1 (' , (newestRev ? '???') , ')'.
        "/ aStream := mgr getMostRecentSourceStreamForClassNamed:nm.
        aStream := mgr getSourceStreamFor:currentClass revision:newestRev.
        revString := '(newest: ' , (newestRev ? '???') , ')'.
    ] ifFalse:[
        msg := 'extracting previous %1'.
"/        aStream := mgr getSourceStreamFor:currentClass revision:rev.
"/        revString := rev
        aStream := mgr  
            streamForClass:currentClass
            fileName:containerFile 
            revision:rev 
            directory:containerPackage 
            module:containerModule
            cache:true.
    ].

    aStream isNil ifTrue:[
        self warn:(resources string:'Could not extract source of %1 from repository' with:aClass name allBold).
        ^ self
    ].
    aStream class readErrorSignal handle:[:ex |
        self warn:('Read error while reading extracted source\\' , ex description) withCRs.
        aStream close.
        ^ self
    ] do:[
        sourceToLoad := aStream contents asString.
    ].
    aStream close.

    wasInChangeSetBefore := ChangeSet current includesChangeForClassOrMetaclass:currentClass.

    currentClass isLoaded ifFalse:[
        rev = newestRev ifTrue:[
            currentClass autoload.
        ] ifFalse:[
            sourceToLoad readStream fileIn.
        ].
        wasInChangeSetBefore ifFalse:[
            ChangeSet current condenseChangesForClass:currentClass.
        ].
        ^ self.
    ].

    inChangeSet := aClass hasUnsavedChanges.

    Error handle:[:ex |
        (Dialog 
            confirm:(resources 
                        stringWithCRs:'An error:\    %1\was encountered while generating the current source of the class %2.\This might be due to some missing or corrupted source file.\You may proceed, but no information about the differences between your current version and the repositories version can be shown.\\Continue ?'
                        with:ex description 
                        with:currentClass name allBold) 
            noLabel:'Cancel') 
        ifFalse:[
            AbortOperationRequest raise
        ].
        sourceToLoad readStream fileIn.
        ^ self.
    ] do:[
        self activityNotification:'generating current source...'.

        currentSource := self sourceCodeOfClass:currentClass.

        self activityNotification:'comparing...'.

        sourceToLoad = currentSource ifTrue:[
            "/ make all methods belong to the classes project
            self setPackageOfAllMethodsIn:aClass to:aClass package.
            inChangeSet ifTrue:[
                rev = newestRev ifTrue:[
                    (askForConfirmation not
                    or:[ wasInChangeSetBefore not
                    or:[ self confirm:(resources 
                                    stringWithCRs:'%1 is up-to-date.\\Remove entries for %1 from changeSet ?'
                                    with:aClass name)]]) 
                    ifTrue:[
                        ChangeSet current condenseChangesForClass:aClass.
                    ].
                ].
            ].
            self activityNotification:'... nothing changed in repository'.
            ^ self.
        ].

        self activityNotification:'generating diffSet...'.
        listHere := ChangeSet fromStream:(currentSource readStream).
    ].

    listRep := ChangeSet fromStream:(sourceToLoad readStream).

    Error handle:[:ex |
        (Dialog 
            confirm:(resources 
                        stringWithCRs:'An error:\    %1\was encountered while trying to figure out what has changed.\This might be due to some missing or corrupted source file.\If you proceed, the old code will be loaded over the existing code without further checks (fileIn).\\Continue ?'
                        with:ex description
                    ) 
            noLabel:'Cancel') 
        ifFalse:[
            ^ self
        ].
        sourceToLoad readStream fileIn.
        ^ self.
    ] do:[
        versionMethodsHere := listHere select:[:change | (change isMethodChange 
                                               and:[((self sourceCodeManagerFor:aClass) "AbstractSourceCodeManager" isVersionMethodSelector:change selector)
                                               and:[change changeClass isMeta]])].

        versionMethodsRep := listRep select:[:change | (change isMethodChange 
                                               and:[((self sourceCodeManagerFor:aClass) "AbstractSourceCodeManager" isVersionMethodSelector:change selector)
                                               and:[change changeClass isMeta]])].

        "/ compare all but the version methods
        listHere := listHere reject:[:change | (change isMethodChange 
                                               and:[(AbstractSourceCodeManager isVersionMethodSelector:change selector)
                                               and:[change changeClass isMeta]])].
        listRep := listRep reject:[:change | (change isMethodChange 
                                               and:[(AbstractSourceCodeManager isVersionMethodSelector:change selector)
                                               and:[change changeClass isMeta]])].

        diffSet := listHere diffSetsAgainst:listRep.
        changed := diffSet changed.
        onlyHere := diffSet onlyInReceiver.

        "/ reject extensions
        onlyHere := onlyHere reject:[:eachDiff|  
                        |method methodsPackage|

                        eachDiff isMethodChange  
                        and:[ eachDiff changeClass notNil
                        and:[ (method := (eachDiff changeClass compiledMethodAt:eachDiff selector)) notNil 
                        and:[ (methodsPackage := method package) ~= containerPackage
                        and:[ methodsPackage ~= PackageId noProjectID  ]]]]
                    ]. 

        onlyInRep := diffSet onlyInArg.

        changedClassDefinitions := changed select:[:eachChangePair | eachChangePair first isClassDefinitionChange]. 
        changed := changed reject:[:eachChangePair | eachChangePair first isClassDefinitionChange]. 
        changed := changed reject:[:eachChangePair | eachChangePair first isClassCommentChange]. 

        labels := #('Cancel' 'Merge' 'Load'). 
        values := #(nil #merge #load). 
        default := askForRevision 
                        ifTrue:[3. "i.e. load"]
                        ifFalse:[2. "i.e. merge"].

        msg := 'About to load ''%4''.\\'.
        onlyInRep size > 0 ifTrue:[
            msg := msg , 'The repositories version contains %1 method(s) which are not in your current class.\'.
        ].
        onlyHere size > 0 ifTrue:[
            msg := msg , (onlyInRep size > 0 ifTrue:['And there '] ifFalse:['There ']).
            msg := msg , 'are %2 methods in your current class, which are not in the repository.\'.
        ].
        changed size > 0 ifTrue:[
            changed size == 1 ifTrue:[
                msg := msg , 'The ''%6''-method is different (present in both).\\'.
                singleChangeSelector := changed first first selector allBold
            ] ifFalse:[
                msg := msg , '%3 methods are different (present in both).\\'.
            ]
        ].
        changedClassDefinitions size > 0 ifTrue:[
            msg := msg , (changedClassDefinitions size == 1 
                            ifTrue:['The class definition is different.\\'] 
                            ifFalse:['%5 class definitions are different.\\'])
        ].

        onlyHere isEmpty ifTrue:[
            onlyInRep isEmpty ifTrue:[
                (changed isEmpty and:[changedClassDefinitions isEmpty]) ifTrue:[
                    versionMethodsRep notEmpty ifTrue:[
                        (self confirm:(resources string:'Only version methods are different in %1.\\Update the version-IDs ?' with:aClass name allBold) withCRs) ifTrue:[
                            versionMethodsRep do:[:each | each apply].
                        ]
                    ].
                    "/ make all those methods belong to the classes project
                    "/ no - that is wrong !! self setPackageOfAllMethodsIn:aClass to:aClass package.
                    self setPackageOfAllMethodsInChangeSet:listRep to:aClass package.
                    self activityNotification:'Only version methods are different in the repository'.
                    ^ self
                ].
                inChangeSet ifTrue:[
                    msg := msg , '\Attention:\Load will undo your changes made to ''%4'' (if any were made).'.
                ].
                labels := #('Cancel' 'Load'). 
                values := #(nil #load). 
                default := askForRevision 
                                ifTrue:[2. "i.e. load"]
                                ifFalse:[1. "i.e. cancel"].
                default := 2. 
            ] ifFalse:[
                changed isEmpty ifTrue:[
                    msg := msg , '\Attention:\Load will load methods which are not present in ''%4''.'.
                    labels := #('Cancel' 'Load'). 
                    values := #(nil #load). 
                    default := askForRevision 
                                    ifTrue:[2. "i.e. load"]
                                    ifFalse:[1. "i.e. cancel"].
                    default := 2. 
                ] ifFalse:[
                    inChangeSet ifTrue:[
                        msg := msg , '\Attention:\Load will undo your changes made to ''%4'' (if any were made);'.
                    ].
                    msg := msg , '\Merge will only load methods which are not present in ''%4'' (i.e. undo removals but preserve changes).'.
                ].
            ]
        ] ifFalse:[
            onlyInRep isEmpty ifTrue:[
                inChangeSet ifTrue:[
                    msg := msg , '\Attention:\Load will undo your changes made to ''%4'' (if any were made),'.
                    msg := msg , '\and remove added methods which are not present in the repository version.'.
                ].
                labels := #('Cancel' 'Load'). 
                values := #(nil #load). 
                default := askForRevision 
                                ifTrue:[2. "i.e. load"]
                                ifFalse:[1. "i.e. cancel"].
                default := 2. 
            ] ifFalse:[
                inChangeSet ifTrue:[
                    msg := msg , '\Attention:\Load will undo your changes made to ''%4'' (if any were made);'.
                    msg := msg , '\Merge will only load methods which are not present in ''%4'' (i.e. undo removals but preserve changes).'.
                ]
            ]
        ].

        msg := msg bindWith:onlyInRep size printString 
                   with:onlyHere size printString 
                   with:changed size printString
                   with:aClass name allBold
                   with:changedClassDefinitions size printString
                   with:singleChangeSelector.

        askForConfirmation ifFalse:[
            answer := #load           
        ] ifTrue:[
            answer := (Dialog confirmWithCancel:msg withCRs
                   labels:(resources array:labels)
                   values:values 
                   default:default).
            answer isNil ifTrue:[
                self activityNotification:'...cancelled'.
                ^ self
            ].
        ].
        self activityNotification:'updating...'.
        changedClasses := IdentitySet new.

        answer == #load ifTrue:[
            "when loading, remove all the methods which are no longer in classes with a changed
             class definition. So we avoid possible compile errors of old methods, which will go away"
            onlyHere do:[:eachChange |   
                "remove this change (method not present in repository version)"
                |cClass|
                eachChange isMethodChange ifTrue:[
                    cClass := eachChange changeClass.
                    cClass notNil ifTrue:[ 
                       cClass basicRemoveSelector:eachChange selector 
                    ].
                ]
            ].

            changedClassDefinitions do:[:eachChangeArr | 
                |cHere eachChangedClass| 
                cHere := eachChangeArr at:1.
                eachChangedClass := cHere changeClass.
                eachChangedClass notNil ifTrue:[
                    changedClasses add:eachChangedClass.
                    eachChangedClass := eachChangedClass theNonMetaclass.

                    "remove changed methods now, but keep the changes (to be applied later)"
                    changed do:[:eachChangeArr|
                        |eachChange eachClass|

                        eachChange := eachChangeArr first.
                        eachChange isMethodChange ifTrue:[
                            eachClass := eachChange changeClass.
                            eachClass theNonMetaclass == eachChangedClass ifTrue:[
                                eachClass basicRemoveSelector:eachChange selector.
                            ].
                        ].
                    ].
                ]
            ].

           "apply class definition changes (use the repository version)"
           changedClassDefinitions do:[:eachChangeArr |    
                |cRep| 
                cRep := eachChangeArr at:2.
                cRep apply.
            ].
        ].

        onlyInRep do:[:eachChange |
            |changeClass|

            "apply this change (method only present in rep-version)"
             eachChange apply.
             eachChange isMethodChange ifTrue:[
                 changeClass := eachChange changeClass.
                 changeClass notNil ifTrue:[
                     eachChange changeMethod setPackage:(changeClass package).
                     changedClasses add:changeClass.
                 ]
             ]
        ]
    .
        answer == #load ifTrue:[
            changed do:[:eachChangeArr | "apply this change (go to rep-version)"
                 |cHere cRep| 
                 cHere := eachChangeArr at:1.
                 cRep := eachChangeArr at:2.
                 cRep apply.
                 cRep isMethodChange ifTrue:[
                     cRep changeMethod setPackage:(cRep changeClass package).
                     changedClasses add:cRep changeClass.
                 ]
            ].

            versionMethodsRep size >= 1 ifTrue:[
                versionMethodsRep last apply.
            ] ifFalse:[
                self error:'missing version method in repository' mayProceed:true.
            ].
            "/ make all those methods belong to the classes project
            "/ no - that is wrong !! self setPackageOfAllMethodsIn:aClass to:aClass package.
            self setPackageOfAllMethodsInChangeSet:listRep to:aClass package.
        ].

        answer == #load ifTrue:[
            inChangeSet := aClass hasUnsavedChanges.
            inChangeSet ifTrue:[
                rev = newestRev ifTrue:[
                    (wasInChangeSetBefore not
                     or:[ self confirm:(resources 
                                    stringWithCRs:'%1 is now up-to-date.\\Remove entries for %1 from changeSet ?'
                                    with:aClass name)]) 
                    ifTrue:[
                        ChangeSet current condenseChangesForClass:aClass.
                    ].
                ].
            ].
        ].

        changedClasses do:[:eachClass |
             eachClass changed:#projectOrganization.
        ].
        Smalltalk changed:#projectOrganization.
        self activityNotification:'... done'.
    ].

    "Modified: / 07-02-2001 / 18:18:32 / ps"
    "Modified: / 22-07-2013 / 13:17:32 / cg"
!

checkoutExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision askForMerge:askForMerge usingManager:aSourceCodeManager
    "check-out a class from the source repository.
     If askForRevision is false, check-out the newest version."

    |inChangeSet extensionMethods msg
     listHere listRep diffSet 
     changed onlyHere onlyInRep answer labels values singleChangeSelector
     changedClasses default |

    listRep := self changeSetForExtensionMethodsForPackage:packageToCheckOut askForRevision:askForRevision usingManager:aSourceCodeManager.
    listRep isNil ifTrue:[ ^self ].

    self activityNotification:'generating diffSet...'.

    extensionMethods := OrderedCollection new.
    Smalltalk allClassesDo:[:aClass | |owner classPackage|
        "/ individual methods ...
        aClass isMeta ifFalse:[
            (aClass package ~= packageToCheckOut) ifTrue:[
                aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                    "/ methods in this project ...
                    (mthd package = packageToCheckOut) ifTrue:[
                        "/ ... whose class is not in the ckechIn-set
                        extensionMethods add:mthd
                    ]
                ].
            ].
        ].
    ].
    listHere := ChangeSet forExistingMethods:extensionMethods.

    inChangeSet := listRep contains:[:someChange |
                            |cClass cSel|

                            someChange isMethodChange ifTrue:[
                                cClass := someChange changeClass.
                                cSel := someChange selector.
                                ChangeSet current includesChangeForClass:cClass selector:cSel
                            ]
                    ].

    diffSet := listHere diffSetsAgainst:listRep.
    changed := diffSet changed.
    onlyHere := diffSet onlyInReceiver.
    onlyInRep := diffSet onlyInArg.

    labels := #('Cancel' 'Merge' 'Load'). 
    values := #(nil #merge #load). 
    default := askForRevision 
                    ifTrue:[3. "i.e. load"]
                    ifFalse:[2. "i.e. merge"].

    msg := 'About to load extensions for ''%5''.\\'.
    onlyInRep size > 0 ifTrue:[
        msg := msg , 'The repositories version contains %1 extension method(s) which are not in your current image.\'.
    ].
    onlyHere size > 0 ifTrue:[
        onlyInRep size > 0 ifTrue:[
            msg := msg , 'And there '.
        ] ifFalse:[
            msg := msg , 'There '.
        ].
        msg := msg , 'are %2 extension methods in your current image, which are not in the repository.\'.
    ].
    changed size > 0 ifTrue:[
        changed size == 1 ifTrue:[
            msg := msg , 'The ''%5''-method is different (present in both).\\'.
            singleChangeSelector := changed first first selector allBold
        ] ifFalse:[
            msg := msg , '%3 methods are different (present in both).\\'.
        ]
    ].

    onlyHere isEmpty ifTrue:[
        onlyInRep isEmpty ifTrue:[
            (changed isEmpty) ifTrue:[
                listRep do:[:eachChange |
                    eachChange changeMethod setPackage:packageToCheckOut.
                ].
                ^ self
            ].
            inChangeSet ifTrue:[
                msg := msg , '\Attention:\Load may undo any changes made to on of the extension methods (if any were made).'.
            ].
            labels := #('Cancel' 'Load'). 
            values := #(nil #load). 
            default := askForRevision 
                            ifTrue:[2. "i.e. load"]
                            ifFalse:[1. "i.e. cancel"].
        ] ifFalse:[
            changed isEmpty ifTrue:[
                msg := msg , '\Attention:\Load will load methods which are not present in the image.'.
                labels := #('Cancel' 'Load'). 
                values := #(nil #load). 
                default := askForRevision 
                                ifTrue:[2. "i.e. load"]
                                ifFalse:[1. "i.e. cancel"].
            ] ifFalse:[
                inChangeSet ifTrue:[
                    msg := msg , '\Attention:\Load will undo your changes made to the image (if any were made);'.
                ].
                msg := msg , '\Merge will only load methods which are not present in the image (i.e. undo removals but preserve changes).'.
            ].
        ]
    ] ifFalse:[
        onlyInRep isEmpty ifTrue:[
            inChangeSet ifTrue:[
                msg := msg , '\Attention:\Load will undo your changes made to the image (if any were made),'.
                msg := msg , '\and remove added methods which are not present in the repository version.'.
            ].
            labels := #('Cancel' 'Load'). 
            values := #(nil #load). 
            default := askForRevision 
                            ifTrue:[2. "i.e. load"]
                            ifFalse:[1. "i.e. cancel"].
        ] ifFalse:[
            inChangeSet ifTrue:[
                msg := msg , '\Attention:\Load will undo your changes made to the image (if any were made);'.
                msg := msg , '\Merge will only load methods which are not present in the image (i.e. undo removals but preserve changes).'.
            ]
        ]
    ].

    msg := msg bindWith:onlyInRep size printString 
               with:onlyHere size printString 
               with:changed size printString
               with:singleChangeSelector
               with:packageToCheckOut allBold.

    answer := (Dialog confirmWithCancel:msg withCRs
           labels:(resources array:labels)
           values:values 
           default:default).
    answer isNil ifTrue:[^ self].

    self activityNotification:'updating...'.
    changedClasses := IdentitySet new.

"/    Class withoutUpdatingChangesDo:[
        onlyInRep do:[:eachChange | "apply this change (method only present in rep-version)"
                                     Class withoutUpdatingChangeSetDo:[ eachChange apply ].

                                     eachChange changeMethod setPackage:packageToCheckOut.
                                     changedClasses add:eachChange changeClass.   
                     ].
        answer == #load ifTrue:[
            onlyHere do:[:eachChange |   "remove this change (method not present in rep-version)"
                                         |cClass cSel|

                                         cClass := eachChange changeClass.
                                         cSel := eachChange selector.
                                         Class withoutUpdatingChangeSetDo:[ cClass removeSelector:cSel ].
                        ].
            changed do:[:eachChangeArr | "apply this change (go to rep-version)"
                                         |cHere cRep| 
                                         cHere := eachChangeArr at:1.
                                         cRep := eachChangeArr at:2.
                                         Class withoutUpdatingChangeSetDo:[ cRep apply ].

                                         cRep changeMethod setPackage:packageToCheckOut.
                                         changedClasses add:cRep changeClass.
                       ].
        ].
"/    ].
    changedClasses do:[:eachClass |
         eachClass changed:#projectOrganization.
    ].
    Smalltalk changed:#projectOrganization.

    "Modified: / 07-02-2001 / 18:18:32 / ps"
    "Created: / 29-12-2011 / 14:34:12 / cg"
!

compareClassWithRepository:aClass
    "open a diff-textView comparing the current (in-image) version
     against its orgiginal version found in the repository."

    self compareClassWithRepository:aClass askForRevision:true

    "
      self compareClassWithRepository:Array
    "
!

compareClassWithRepository:aClass askForRevision:askForRevision
    "open a diff-textView comparing the current (in-image) version
     against the newest or an asked-for version found in the repository."

    |classToCompare brwsr comparedSource currentSource rev revString thisRevString 
     scmManager revisionInClass versionsAreTheSame revInfo revAuthor revDate revLabel |

    classToCompare := aClass theNonMetaclass.

    comparedSource := self 
                        fetchSourceOf:classToCompare askForRevision:askForRevision 
                        into:[:revStringArg :revisionInClassArg :scmManagerArg| 
                            revString := revStringArg.
                            revisionInClass := revisionInClassArg.
                            scmManager := scmManagerArg.
                        ].
    comparedSource isNil ifTrue:[
        ^ self
    ].

"/    classToCompare := aClass theNonMetaclass.
"/
"/    nm := classToCompare name.
"/    (mgr := manager) isNil ifTrue:[
"/        mgr := self sourceCodeManagerFor:classToCompare.
"/        mgr isNil ifTrue:[
"/            self error:'oops - no sourcecode manager' mayProceed:true.
"/            ^ self
"/        ].
"/    ].
"/
"/    rev := classToCompare revisionInfoOfManager:mgr.
"/"/    rev := classToCompare binaryRevision.
"/    revisionInClass := classToCompare revisionOfManager:mgr.
"/    rev isNil ifTrue:[
"/        rev := revisionInClass
"/    ].
"/    rev isNil ifTrue:[
"/        (Dialog confirm:'Class seems to be not yet in the repository (or classes revision info is missing or corrupted)\\Proceed ?' withCRs)
"/        ifFalse:[
"/            ^ self
"/        ]
"/    ].
"/
"/    "/
"/    "/ class in repository - ask for revision
"/    "/
"/    SourceCodeManagerError handle:[:ex |
"/        Dialog warn:(resources 
"/                                stringWithCRs:'Could not fetch revision info of "%1".\\Please check your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
"/                                with:classToCompare name
"/                                with:classToCompare sourceCodeManager managerTypeName
"/                                with:classToCompare package).
"/        ^ self.
"/    ] do:[
"/        newestRev := mgr newestRevisionOf:classToCompare.
"/    ].
"/    askForRevision ifTrue:[
"/        msg := resources string:'Compare to revision: (empty for newest)'.
"/        rev notNil ifTrue:[
"/            msg := msg , '\\' , (resources string:'Current %1 is based upon rev %2.'
"/                                           with:nm allBold with:rev).
"/            (revisionInClass notNil and:[revisionInClass ~= rev]) ifTrue:[
"/                msg := msg , '\' , (resources string:'And has been checked into the repository as %1.'
"/                                               with:revisionInClass)
"/            ]
"/        ].
"/        newestRev notNil ifTrue:[
"/            msg := msg , '\' , (resources string:'Newest in repository is %1.'
"/                                           with:newestRev)
"/        ].
"/
"/        rev := self
"/                    askForExistingRevision:msg 
"/                    title:'Compare with repository' 
"/                    class:classToCompare.
"/    ] ifFalse:[
"/        rev := newestRev.
"/    ].
"/
"/    rev isNil ifTrue:[
"/        mgr = classToCompare sourceCodeManager ifTrue:[
"/            msg := 'Could not figure out the newest revision of "%1".\\Please check if this class is really contained in that repository,\and also your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
"/        ] ifFalse:[
"/            msg := 'Could not figure out the newest revision of "%1".\\Notice that the class is actually maintained by %4, not %2.\Please check if this class is really in the %2 repository,\and also your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
"/        ].
"/        Dialog warn:(resources 
"/                                stringWithCRs:msg
"/                                with:classToCompare name
"/                                with:mgr managerTypeName
"/                                with:classToCompare package
"/                                with:(classToCompare sourceCodeManager managerTypeName)).
"/        ^ self.
"/        
"/    ].
"/    rev withoutSpaces isEmpty ifTrue:[
"/        msg := 'extracting newest %1 (' , (newestRev ? '???') , ')'.
"/        "/ aStream := mgr getMostRecentSourceStreamForClassNamed:nm.
"/        aStream := mgr getSourceStreamFor:classToCompare revision:newestRev.
"/        revString := '(newest: ' , (newestRev ? '???') , ')'.
"/    ] ifFalse:[
"/        msg := 'extracting previous %1'.
"/        aStream := mgr getSourceStreamFor:classToCompare revision:rev.
"/        revString := rev
"/    ].
"/
"/    aStream isNil ifTrue:[
"/        self warn:'Could not extract source from repository (check repository settings / network)'.
"/        ^ self
"/    ].
"/    aStream class readErrorSignal handle:[:ex |
"/        self warn:('Read error while reading extracted source\\' , ex description) withCRs.
"/        aStream close.
"/        ^ self
"/    ] do:[
"/        comparedSource := aStream contents asString.
"/    ].
"/    aStream close.

    self activityNotification:'generating current source...'.

    currentSource := self sourceCodeOfClass:classToCompare.

    self activityNotification:'comparing...'.

    versionsAreTheSame := false.
    "/ a quick smoke test, if code is exactly the same
    comparedSource = currentSource ifTrue:[
        versionsAreTheSame := true.
    ] ifFalse:[
        "/ this branch generates chunks and compares individual methods.
        "/ this is a litle more expensive, but will deal with reordered methods in the source,
        "/ additional whitespace, empty lines etc.

        thisRevString := revisionInClass ? 'no revision'.

        revString = '(newest)' ifTrue:[
            |newestRev|

            (newestRev := scmManager newestRevisionOf:classToCompare) notNil ifTrue:[
                revString := '(newest is ' , newestRev , ')'.
                rev := newestRev.
            ]
        ] ifFalse:[
            rev := revString
        ].

        revLabel := revString.

        rev notNil ifTrue:[
            revInfo := scmManager revisionLogOf:classToCompare fromRevision:rev toRevision:rev.
            revInfo notNil ifTrue:[
                revInfo := (revInfo at:#revisions) first.
                revAuthor := revInfo at:#author ifAbsent:[nil].
                revDate := revInfo at:#date ifAbsent:[nil].
                revDate isString ifTrue:[
                    revDate := Timestamp readFrom:revDate onError:nil.
                ].
                revLabel := revString , ' ('.
                revDate notNil ifTrue:[
                    revLabel := revLabel , revDate asDate printString.
                ].
                revLabel := revLabel , ' by ', revAuthor.
                revLabel := revLabel , ')'.
            ].
        ].

        self activityNotification:'comparing...'.

        ChangeSet invalidChangeChunkError handle:[:ex |
            |answer|

            answer := Dialog 
                        confirm:(resources 
                            stringWithCRs:'An invalid change chunk was encountered when reading the source of %1.\This may be due to a currupted source file (or source file was modified/updated in the meantime, without recompilation).\\Proceed in debugger?'
                            with:aClass)
                        yesLabel:(resources string:'Debug')
                        noLabel:(resources string:'Cancel')
                        initialAnswer:false.
            answer ifTrue:[ex reject].
            AbortOperationRequest raise.
        ] do:[
            brwsr := (UserPreferences versionDiffViewerClass)
                  openOnClass:classToCompare
                  labelA:('Repository: ' , revLabel)
                  sourceA:comparedSource
                  labelB:('Current: (based on: ' , thisRevString , ')')
                  sourceB:currentSource
                  title:('Comparing ' , classToCompare name)
                  ifSame:[versionsAreTheSame := true].
        ].
        versionsAreTheSame ifFalse:[
            brwsr classChangeSet 
                classBeingCompared:classToCompare;
                versionA:revString;
                versionB:thisRevString , 'mod'.
        ].
    ].

    versionsAreTheSame ifTrue:[
        (classToCompare hasUnsavedChanges) ifTrue:[
            (self confirm:(resources 
                            stringWithCRs:'Versions of %1 are identical.\\Remove entries from changeSet ?'
                            with:classToCompare name allBold)) ifTrue:[
                ChangeSet current condenseChangesForClass:classToCompare.
            ].
        ] ifFalse:[
            self information:'Versions are identical.'.
            ChangeSet current unrememberChangedClasses.
        ].
        revisionInClass isNil ifTrue:[
            (Dialog confirm:'Update (Fix) the classes Revision Info ?' withCRs)
            ifTrue:[
                |newString root|

                newString := scmManager updatedRevisionStringOf:aClass forRevision:rev with:aClass revisionString.
                newString isNil ifTrue:[
                    root := scmManager getCVSROOTForModule:(aClass package upTo:$:).
                    root := scmManager repositoryTopDirectoryFromCVSRoot:root.
                    newString := '$', 'Header: ',(root copyReplaceAll: $: with:$/ ),'/'
                                 ,(Smalltalk fileNameForClass:aClass),'.st,v ',rev,' '
                                 ,(Date today printStringFormat:'%y-%m-%d'),' '
                                 ,(Time now printStringFormat:'%h:%m:%s'),' '
                                 ,'+0000 '
                                 ,(OperatingSystem getLoginName),' Exp $'.
                ].
                scmManager updateVersionMethodOf:aClass for:newString.
            ]
        ].
    ].

    "
      self compareClassWithRepository:Array
    "

    "Modified: / 24-07-2012 / 18:11:27 / cg"
!

comparePackages:packages askForRevision:askForRevision 
    "Compares code of given packages (loaded in the image) against a specific revision
     and opens a diff browser on differences.

     If `askForRevision` is true, then user is asked to specify to which revision to
     update. If `askForRevision` is false, then packages are updated to a 'newest'
     revision. 

     NOTE: Definition of `newest` revision may vary. For SCMs which allows for multiple
     heads, it is not clear which one it is. In that case, even if `askForRevision` is
     false, this method may result in user interation, asking user to select which of the
     newest she wants."

    ^ self subclassResponsibility.

    "Created: / 04-04-2014 / 15:23:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest
    ^ self compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:false
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly
    |diffSet|

    diffSet := self diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly.
    VersionDiffBrowser 
        openOnDiffSet:diffSet 
        labelA:'Repository' 
        labelB:'Image' 
        title:('Differences of %1' bindWith:aProject)
        ignoreExtensions:true
        ignoreVersionMethods:true.

    "Modified: / 12-09-2011 / 11:56:01 / cg"
!

compareProject:aProject withRepositoryVersionTaggedAs:aSymbolicName
    |diffSet|

    diffSet := self diffSetOfProject:aProject againstRepositoryVersionTaggedAs:aSymbolicName.

    VersionDiffBrowser 
        openOnDiffSet:diffSet 
        labelA:'Repository ("',(aSymbolicName?'newest'),'")' 
        labelB:'Image' 
        title:('Differences of %1' bindWith:aProject)
        ignoreExtensions:true
        ignoreVersionMethods:true.

    "Modified: / 12-09-2011 / 11:56:01 / cg"
!

compareProject:aProject withRepositoryVersionTaggedAs:aTag extensionsOnly:extensionsOnly
    |diffSet|

    diffSet := self diffSetOfProject:aProject againstRepositoryVersionTaggedAs:aTag extensionsOnly:extensionsOnly.
    VersionDiffBrowser 
        openOnDiffSet:diffSet 
        labelA:'Repository' 
        labelB:'Image' 
        title:('Differences of %1' bindWith:aProject)
        ignoreExtensions:true
        ignoreVersionMethods:true.

    "Created: / 12-11-2016 / 03:39:48 / cg"
!

compareProjectWithRepository:aProject
    ^ self compareProject:aProject withRepositoryVersionFrom:nil
!

createSourceContainerForClass:aClass
    "let user specify the source-repository values for aClass.
     Return false, if failed."

    ^ self 
        createSourceContainerForClass:aClass
        usingManager:(self sourceCodeManagerFor:aClass).

    "Modified: / 21-12-2011 / 18:31:49 / cg"
!

createSourceContainerForClass:aClass usingManager:aManager
    "let user specify the source-repository values for aClass.
     Return false, if failed."

    ^ self
        createSourceContainerForClass:aClass usingManager:aManager
        confirmNewContainer:confirmNewFiles   
!

createSourceContainerForClass:aClass usingManager:aManager confirmNewContainer:confirmNewContainer
    "let user specify the source-repository values for aClass.
     Return false, if failed."

    aManager isNil ifTrue:[^ false].

    ^ self 
        defineSourceContainerForClass:aClass
        usingManager:aManager
        title:(resources string:'Repository information for %1' with:aClass name)
        text:(resources string:'Create new %1-repository container for ''%2''' 
                            with:aManager managerTypeName
                            with:aClass name allBold)
        createDirectories:true
        createContainer:true
        confirmNewContainer:confirmNewContainer.

    "Created: / 21-12-2011 / 18:31:23 / cg"
!

defineSourceContainerForClass:aClass title:title text:boxText createDirectories:createDirs createContainer:createContainer
    "let user specify the source-repository values for aClass"

    ^ self
        defineSourceContainerForClass:aClass 
        usingManager:(self sourceCodeManagerFor:aClass)
        title:title 
        text:boxText 
        createDirectories:createDirs 
        createContainer:createContainer

    "Modified: / 21-12-2011 / 18:34:44 / cg"
!

defineSourceContainerForClass:aClass usingManager:mgr title:title text:boxText createDirectories:createDirs createContainer:createContainer
    "let user specify the source-repository values for aClass"

    ^ self
        defineSourceContainerForClass:aClass usingManager:mgr title:title text:boxText 
        createDirectories:createDirs createContainer:createContainer
        confirmNewContainer:confirmNewFiles
!

defineSourceContainerForClass:aClass usingManager:mgr title:title text:boxText 
    createDirectories:createDirs createContainer:createContainer
    confirmNewContainer:confirmNewContainer
    "let user specify the source-repository values for aClass"

    |className
     "oldModule oldPackage" oldFileName
     module directory fileName nameSpace nameSpacePrefix
     info project nm creatingNew msg 
     answer doCheckinWithoutAsking forceCheckIn rslt note
     requiredPackage classPackage|

    mgr isNil ifTrue:[^  false].

    aClass isLoaded ifFalse:[
        self warn:(resources string:'Please load the %1-class first' with:aClass name).
        ^ false.
    ].

    className := aClass name.
    classPackage := aClass package.
    classPackage ~= PackageId noProjectID ifTrue:[
        module := classPackage asPackageId module.
        directory := classPackage asPackageId directory.
    ] ifFalse:[
        "/
        "/ defaults, if nothing at all is known
        "/
        (module := LastModule) isNil ifTrue:[
            module := (UserPreferences current usersModuleName "OperatingSystem getLoginName").
        ].
        (directory := LastPackage) isNil ifTrue:[
            directory := 'private'.
        ]. 
    ].

    "/
    "/ try to extract some useful defaults from the current project
    "/
    (Project notNil and:[(project := Project current) notNil]) ifTrue:[
        directory isNil ifTrue:[
            (nm := project repositoryDirectory) isNil ifTrue:[
                nm := project name
            ].
            directory := nm.
        ].
        module isNil ifTrue:[
            (nm := project repositoryModule) notNil ifTrue:[
                module := nm
            ]
        ].
    ].

    "/
    "/ ask the sourceCodeManager if it knows anything about that class
    "/ if so, take that as a default.
    "/
    info := mgr sourceInfoOfClass:aClass.
    info notNil ifTrue:[
        true "module ~= LastModule" ifTrue:[
            (info includesKey:#module) ifTrue:[
                module := (info at:#module).
            ].
        ].
"/        true "package ~= LastPackage" ifTrue:[
"/            (info includesKey:#directory) ifTrue:[
"/                package := (info at:#directory).
"/            ].
"/        ].
        fileName := mgr containerFromSourceInfo:info.
        fileName isNil ifTrue:[ fileName := aClass classFilename ].
        (nameSpace := aClass nameSpace) ~~ Smalltalk ifTrue:[
            nameSpacePrefix := nameSpace name , '::'.
            fileName := fileName withoutPrefix:nameSpacePrefix.
        ].
"/        (info includesKey:#fileName) ifTrue:[
"/            fileName := (info at:#fileName).
"/        ] ifFalse:[
"/            (info includesKey:#expectedFileName) ifTrue:[
"/                fileName := (info at:#expectedFileName).
"/            ] ifFalse:[
"/                (info includesKey:#classFileNameBase) ifTrue:[
"/                    fileName := (info at:#classFileNameBase) , '.st'.
"/                ]
"/            ]
"/        ]
    ].
    directory isNil ifTrue:[
        Dialog information:('Using %1 as last package-folder' bindWith:LastPackage).
        directory := LastPackage.
    ].

    fileName isNil ifTrue:[
        fileName := (Smalltalk fileNameForClass:aClass) , '.st'.
    ].

    OperatingSystem isMSDOSlike ifTrue:[
        module replaceAll:$\ with:$/.
        directory replaceAll:$\ with:$/.
    ].

    "/
    "/ check for conflicts (i.e. if such a container already exists) ...
    "/
    doCheckinWithoutAsking := false.
"/false ifTrue:[
"/    (mgr checkForExistingContainer:fileName inModule:module directory:directory) ifTrue:[
"/        answer := Dialog confirmWithCancel:(resources 
"/                            string:'About to change the source container.
"/
"/Notice: there is a container for %1 in:
"/
"/    %2 / %3 / %4
"/
"/Do you want to change it or check right into that container ?'
"/                            with:className
"/                            with:module
"/                            with:directory
"/                            with:fileName)
"/                labels:(resources array:#('Cancel' 'Check in' 'Change')).
"/        answer isNil ifTrue:[AbortOperationRequest raise].
"/        answer ifTrue:[
"/            doCheckinWithoutAsking := false.
"/            oldModule := module.
"/            oldPackage := directory.
"/            oldFileName := fileName
"/        ] ifFalse:[
"/            doCheckinWithoutAsking := true.
"/            creatingNew := false.
"/        ].
"/    ].
"/].
    mgr isContainerBased ifTrue:[
        doCheckinWithoutAsking ifFalse:[
            "/
            "/ open a dialog for this
            "/
            (mgr checkForExistingContainer:fileName inModule:module directory:directory) ifFalse:[
                note := 'Notice: class seems to have no container yet.'.
                creatingNew := true.
            ] ifTrue:[
                creatingNew := false.
            ].
            confirmNewContainer ifTrue:[
                rslt := self 
                            askForContainer:boxText title:title note:note
                            initialModule:module initialPackage:directory initialFileName:fileName
                            forNewContainer:true.        

                rslt isNil ifTrue:[
                    ^ false
                ].

                module := rslt at:#module.
                directory := rslt at:#package.
                fileName := rslt at:#fileName.
                (module isEmptyOrNil or:[fileName isEmptyOrNil]) ifTrue:[
                    ^ false
                ].
                (directory isEmptyOrNil) ifTrue:[
                    "/ only one special case allowed - the module-folder description itself.
                    aClass name = module ifFalse:[^ false].
                ]
            ]
        ].
        (fileName endsWith:',v') ifTrue:[
            fileName := fileName copyButLast:2
        ].
        (fileName endsWith:'.st') ifFalse:[
            fileName := fileName , '.st'
        ].

    ].

    "/ we require the packageID to be <module>:<container-dir>
    "/ check for this ...

    requiredPackage := ((module ? '') , ':' , (directory ? '')) asSymbol.
    requiredPackage ~= aClass package ifTrue:[
"/        doCheckinWithoutAsking ifFalse:[
"/            (self confirm:'Change the classes packageID to: ''', requiredPackage , ''' ?')
"/            ifFalse:[
"/                ^ false
"/            ]
"/        ].
        aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:requiredPackage].
        aClass package:requiredPackage.
    ].

    info := aClass revisionInfo.
    info notNil ifTrue:[
        (info repositoryPathName isNil) ifTrue:[
            info := nil
        ].
"/        (info includesKey:#repositoryPathName) ifFalse:[
"/            info := nil
"/        ]
    ].

    info isNil ifTrue:[
        true "doCheckinWithoutAsking" ifFalse:[
            answer := Dialog 
                 confirmWithCancel:(resources string:'%1 does not have any (usable) revision info (#version method)\\Shall I create one ?' with:className) withCRs
                 labels:(resources array:#( 'Cancel' 'No' 'Yes')).
            answer isNil ifTrue:[^ false].
        ] ifTrue:[
            answer := true.
        ].
        answer ifTrue:[
            mgr
                updateVersionMethodOf:aClass 
                for:(mgr initialRevisionStringFor:aClass 
                         inModule:module 
                         directory:directory 
                         container:fileName).
        ].
    ].

    (self checkForExistingModule:module usingManager:mgr allowCreate:(createDirs or:[creatingNew]))
        ifFalse:[^ false].
    LastModule := module.

    (self checkForExistingModule:module directory:directory usingManager:mgr allowCreate:(createDirs or:[creatingNew]))
        ifFalse:[^ false].
    LastPackage := directory.

    "/
    "/ check for the container itself
    "/
    (mgr isContainerBased not
    or:[ mgr checkForExistingContainer:fileName inModule:module directory:directory ]) ifTrue:[
"/            (oldModule notNil
"/            and:[(oldModule ~= module)
"/                 or:[oldPackage ~= package
"/                 or:[oldFileName ~= fileName]]])
"/            ifFalse:[
"/                self warn:(resources string:'no change').
"/                ^ false.
"/            ].

        mgr isContainerBased ifTrue:[
            creatingNew ifTrue:[
                self warn:(resources string:'Container for %1 already exists in %2/%3.' with:fileName with:module with:directory) withCRs.
            ].

            doCheckinWithoutAsking ifFalse:[
                (Dialog 
                    confirm:(resources string:'check %1 into the existing container

    %2 / %3 / %4  ?'
                                    with:className
                                    with:module 
                                    with:directory 
                                    with:fileName) withCRs
                    noLabel:'Cancel') 
                ifFalse:[
                    ^ false.
                ].  
            ].  
        ].

        mgr 
            updateVersionMethodOf:aClass 
            for:('$' , 'Header' , '$'). "/ concatenated to avoid RCS-expansion

        oldFileName notNil ifTrue:[
            msg := ('forced checkin / source container change from ' , oldFileName).
        ] ifFalse:[
            msg := 'defined source container'
        ].

        (forceCheckIn := doCheckinWithoutAsking) ifFalse:[
            (mgr
                checkinClass:aClass 
                fileName:fileName 
                directory:directory 
                module:module 
                logMessage:msg)
            ifFalse:[
                doCheckinWithoutAsking ifFalse:[
                    (Dialog 
                        confirm:'No easy merge seems possible; force checkin (no merge) ?'
                        noLabel:'Cancel') 
                    ifFalse:[
                        ^ false.
                    ].
                ].
                forceCheckIn := true.
            ]
        ].
        forceCheckIn ifTrue:[
            (mgr
                checkinClass:aClass 
                fileName:fileName 
                directory:directory 
                module:module 
                logMessage:msg
                force:true)
            ifFalse:[
                self warn:(resources string:'Failed to check into existing container.').
                ^ false.
            ].
        ].
        ^ true
    ] ifFalse:[
        (createContainer or:[creatingNew]) ifFalse:[
            (Dialog
                 confirm:(resources string:'No container exists for %1 in %2/%3\\create ?' 
                                      with:fileName with:module with:directory) withCRs
                 noLabel:'Cancel') ifFalse:[
                ^ false
            ]
        ]
    ].

    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:requiredPackage].
    aClass package:requiredPackage.

    [ mgr
        createContainerFor:aClass
        inModule:module
        package:directory
        container:fileName
    ] whileFalse:[
        (Dialog confirm:(resources stringWithCRs:'Failed to create container.\(fix your setup then retry, or cancel)\\Retry?') yesLabel:'Retry') ifFalse:[
            ^ false.
        ].
    ].
    ^ true

    "Created: / 21-12-2011 / 18:34:02 / cg"
    "Modified: / 30-04-2016 / 11:58:11 / cg"
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest
    ^ self diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:false
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly
    ^ self
        diffSetOfProject:aProject 
        againstRepositoryVersionFrom:aDateOrNilForNewest
        orTag:nil
        extensionsOnly:extensionsOnly
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest orTag:aTagOrNil
    "return a diffset against either the newest (head), or the version at a particular date,
     or a the version with a particular tag."

    ^ self
        diffSetOfProject:aProject 
        againstRepositoryVersionFrom:aDateOrNilForNewest 
        orTag:aTagOrNil 
        extensionsOnly:false

    "Modified: / 01-11-2010 / 21:02:52 / cg"
!

diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest orTag:aTagOrNil extensionsOnly:extensionsOnly
    "return a diffset against either the newest (head), or the version at a particular date,
     or a the version with a particular tag."

    |classesInImage filesInImage module directory perProjectInfo 
     classesNotInRepository filesNotInImage classesDeletedInRepository
     classesModifiedInImage classesNotReallyModified classesReallyModified classesNewerInRepository 
     classesAddedInImage extensionMethods extensionsInImage extensionsInRepository extensionDiffs
     box doCleanup diffSet def autoloadedFilesNotInImage 
     autoloadedClassesInImage autoloadedFilesInImage versionMethodsAndDoitsRejected|

    module := aProject asPackageId module.
    directory := aProject asPackageId directory.

    (aDateOrNilForNewest isNil and:[ aTagOrNil notNil ]) ifTrue:[
        perProjectInfo := SourceCodeManager revisionsInModule:module directory:directory taggedAs:aTagOrNil.
    ] ifFalse:[
        perProjectInfo := SourceCodeManager revisionsInModule:module directory:directory fromDate:aDateOrNilForNewest.
    ].
    perProjectInfo := perProjectInfo ? #().
    perProjectInfo := perProjectInfo select:[:info | info key asFilename hasSuffix:'st'].
    perProjectInfo := Dictionary withAssociations:perProjectInfo.

    "/ to ignore version_xxx methods
    versionMethodsAndDoitsRejected := 
        [:aChangeSet | 
            aChangeSet reject:[:chg | 
                false "chg isMethodChangeForVersionMethod" 
                or:[false "chg isMethodChangeForExtensionsVersionMethod"
                or:[chg isDoIt]]]
        ].

    classesInImage := Smalltalk allClassesInPackage:aProject.
    autoloadedClassesInImage := classesInImage reject:[:cls | cls isLoaded].
    classesInImage := classesInImage select:[:cls | cls isLoaded and:[cls isPrivate not]].
    filesInImage := classesInImage collect:[:cls | cls classBaseFilename] as:Set.
    autoloadedFilesInImage := autoloadedClassesInImage collect:[:cls | cls classBaseFilename] as:Set.
    "/ any differences ?
    classesNotInRepository := classesInImage reject:[:cls | (perProjectInfo includesKey:cls classBaseFilename)].
    classesDeletedInRepository := classesInImage select:[:cls | (perProjectInfo at:cls classBaseFilename ifAbsent:nil) == #deleted].
    perProjectInfo := perProjectInfo reject:[:v | v == #deleted].
    filesNotInImage := perProjectInfo keys reject:[:file | (filesInImage includes:file)].
    filesNotInImage := filesNotInImage reject:[:file | (autoloadedFilesInImage includes:file)].
    filesNotInImage remove:'extensions.st' ifAbsent:[].

    "/ if comparing against the newest, only look for chaged stuff
    classesModifiedInImage := classesInImage select:[:cls | ChangeSet current includesChangeForClassOrMetaclass:cls].
    classesModifiedInImage := classesModifiedInImage \ classesNotInRepository.

    classesNewerInRepository := classesInImage 
                                    select:[:cls | 
                                        |v clsRevision|

                                        v := (perProjectInfo at:cls classBaseFilename ifAbsent:nil).
                                        v notNil 
                                            and:[ cls isLoaded 
                                            and:[ (clsRevision := cls revision) notNil 
                                            and:[ v > clsRevision ]]]
                                    ].

    "/ stupid: as we do not have any revision information for extensions (sigh);
    "/ we must checkout and look at the extension.st contents, to see if it has changed.

    extensionMethods := Smalltalk allExtensionsForPackage:aProject.
    extensionsInImage := ChangeSet forExistingMethods:extensionMethods.

    [
        |s extensionsRevision|

        extensionsRevision := perProjectInfo at:'extensions.st' ifAbsent:#newest.
        [
            s := SourceCodeManager
                    streamForClass:nil fileName:'extensions.st' revision:extensionsRevision 
                    directory:directory module:module cache:true.
            s notNil ifTrue:[
                extensionsInRepository := ChangeSet fromStream:s.
            ].
        ] ensure:[
            s notNil ifTrue:[s close]
        ].
        extensionsInRepository isNil ifTrue:[extensionsInRepository := ChangeSet new].

        "/ ignore package doIts and all extensionVersion_xxx methods
        extensionsInRepository := versionMethodsAndDoitsRejected value:extensionsInRepository.
    ] value.
    extensionDiffs := extensionsInRepository diffSetsAgainst:extensionsInImage.
    extensionsOnly ifTrue:[
        ^ extensionDiffs
    ].
    
    diffSet := extensionDiffs copy.

    (aDateOrNilForNewest isNil and:[aTagOrNil isNil]) ifTrue:[
        "/ we could do the same as below for each class.
        "/ however - as we do have change-info and revision info, we can avoid checking out
        "/ for all classes which are not changed and which have the same version info.
        classesModifiedInImage notEmpty ifTrue:[
            classesReallyModified :=
                classesModifiedInImage select:[:eachChangedClass |
                    |currentVersion repositoryVersion s stFile diffs|

                    stFile := eachChangedClass classBaseFilename.
                    [    
                        s := SourceCodeManager
                                streamForClass:nil fileName:stFile revision:#newest 
                                directory:directory module:module cache:true.
                        s notNil ifTrue:[
                            repositoryVersion := ChangeSet fromStream:s.
                        ].
                    ] ensure:[
                        s notNil ifTrue:[s close].
                    ].
                    repositoryVersion isNil ifTrue:[ repositoryVersion := ChangeSet new ].
                    repositoryVersion := versionMethodsAndDoitsRejected value:repositoryVersion.

                    currentVersion := ChangeSet forExistingClass:eachChangedClass withExtensions:false withLooseMethods:true.
                    currentVersion := versionMethodsAndDoitsRejected value:currentVersion.
                    diffs := repositoryVersion diffSetsAgainst:currentVersion .
                    diffSet addDiffSet:diffs.
                    diffs notEmpty
                ].

            classesNotReallyModified := classesModifiedInImage \ classesReallyModified.
        ].
    ] ifFalse:[
        classesReallyModified :=
            classesInImage select:[:eachClass |
                |currentVersion repositoryVersion s stFile stRevision diffs|

                stFile := eachClass classBaseFilename.
                stRevision := perProjectInfo at:stFile ifAbsent:nil.
                stRevision notNil ifTrue:[
                    [
                        s := SourceCodeManager
                                streamForClass:nil fileName:stFile revision:stRevision 
                                directory:directory module:module cache:true.
                        s notNil ifTrue:[
                            repositoryVersion := ChangeSet fromStream:s.
                        ].
                    ] ensure:[
                        s notNil ifTrue:[s close].
                    ].
                ].
                repositoryVersion isNil ifTrue:[
                    repositoryVersion := ChangeSet new.
                ].
                repositoryVersion := versionMethodsAndDoitsRejected value:repositoryVersion.

                currentVersion := ChangeSet forExistingClass:eachClass withExtensions:false withLooseMethods:true.
                currentVersion := versionMethodsAndDoitsRejected value:currentVersion.
                diffs := repositoryVersion diffSetsAgainst:currentVersion .
                diffSet addDiffSet:diffs.
                diffs notEmpty
            ].
    ].

    filesNotInImage notEmpty ifTrue:[
        "/ first, check if these are autoloaded classes which have NOT been installed
        "/ (for example, due to a --quick argument during startup)
        autoloadedFilesNotInImage := OrderedCollection new.

        def := ProjectDefinition definitionClassForPackage:aProject createIfAbsent:false projectType:nil.
        def notNil ifTrue:[
            def classNamesAndAttributesDo:[:eachClassname :eachAttributes | 
                |cls eachFileName isAutoload|

                cls := Smalltalk classNamed:eachClassname.
                cls isNil ifTrue:[
                    isAutoload := eachAttributes includes:#autoload.
                    isAutoload ifTrue:[
                        eachFileName := Smalltalk fileNameForClass:eachClassname.
                        autoloadedFilesNotInImage add:(eachFileName , '.st')
                    ]
                ]
            ].
        ].

        (filesNotInImage \ autoloadedFilesNotInImage) do:[:eachSTFile |
            |s chgSet classDefinitions|

            [
                s := SourceCodeManager
                        streamForClass:nil fileName:eachSTFile revision:#newest directory:directory module:module cache:true.
                s isNil ifTrue:[
                    chgSet := ChangeSet new
                ] ifFalse:[
                    chgSet := ChangeSet fromStream:s.
                ]
            ] ensure:[
                s notNil ifTrue:[s close].
            ].
            chgSet := versionMethodsAndDoitsRejected value:chgSet.
            diffSet onlyInReceiver addAll:chgSet
        ].
    ].

    classesNewerInRepository notEmpty ifTrue:[
        classesNewerInRepository do:[:eachClass|
            |s diffs repositoryVersion currentVersion|

            [
                s := SourceCodeManager
                        streamForClass:eachClass fileName:nil revision:#newest directory:directory module:module cache:true.
                repositoryVersion := ChangeSet fromStream:s.
            ] ensure:[
                s notNil ifTrue:[s close].
            ].

            currentVersion := ChangeSet forExistingClass:eachClass withExtensions:false withLooseMethods:true.
            currentVersion := versionMethodsAndDoitsRejected value:currentVersion.
            diffs := repositoryVersion diffSetsAgainst:currentVersion .
            diffSet addDiffSet:diffs.
        ].
    ].

    classesDeletedInRepository notEmpty ifTrue:[
"/ self halt.
    ].
    classesNotInRepository notEmpty ifTrue:[
        "/ if there are no changeSet entries for those classes, they seem to be
        "/ no longer in the repository (possibly moved ?)
        "/ If there are entries, these might have been added in the image and need a check-in

        classesAddedInImage := classesNotInRepository \ classesDeletedInRepository.
        classesAddedInImage do:[:eachAddedClass |
            |currentVersion|

            currentVersion := ChangeSet forExistingClass:eachAddedClass withExtensions:false withLooseMethods:true.
            currentVersion := versionMethodsAndDoitsRejected value:currentVersion.
            diffSet onlyInArg addAll:currentVersion.
        ].
    ].

    diffSet isEmpty ifTrue:[
        "/ Dialog information:(resources string:'%1 is up-to-date.' with:eachProject allBold).
        Transcript showCR:('%1 is up-to-date.' bindWith:aProject allBold).
        (ChangeSet current includesChangeForPackage:aProject) ifTrue:[
            (Dialog confirm:('%1 is up-to-date.\\Cleanup ChangeSet ?' bindWith:aProject allBold) withCRs) ifTrue:[
                ChangeSet current condenseChangesForPackage:aProject.
            ].
        ].
        ^ diffSet.
    ].

    diffSet sortByClassName.
    
    "/ as a side-effect, if we find that some classes are modified but the same as in the repository,
    "/ give user a chance to cleanup the changeSet here.
    aDateOrNilForNewest isNil ifTrue:[
        classesNotReallyModified notEmptyOrNil ifTrue:[
            doCleanup := false.
            box := Dialog
                forRequestText:(resources 
                                    stringWithCRs:'The following classes from %1 are equal to the repository version.\\Remove entries from the changeSet?'
                                    with:aProject allBold) 
                editViewClass:ListView
                lines:10 columns:20 
                initialAnswer:nil 
                setupWith:
                   [:v :d | 
                            |removeButton|

                            v list:classesNotReallyModified.
                            removeButton := Button label:(resources string:'Cleanup ChangeSet').
                            removeButton action:[ doCleanup := true. box okPressed. ].
                            d addButton:removeButton after:(d okButton).
                            d okButton label:(resources string:'Continue').
                            d okButton isReturnButton:false.
                            removeButton isReturnButton:true.
                   ].
            box open.
            box accepted ifTrue:[
                doCleanup ifTrue:[
                    classesNotReallyModified do:[:class |
                        ChangeSet current condenseChangesForClass:class.
                    ]
                ].
            ]
        ].
    ].
    ^ diffSet

    "Modified: / 01-11-2010 / 21:02:52 / cg"
!

diffSetOfProject:aProject againstRepositoryVersionTaggedAs:symbolicName
    ^ self
        diffSetOfProject:aProject 
        againstRepositoryVersionFrom:nil
        orTag:symbolicName
!

diffSetOfProject:aProject againstRepositoryVersionTaggedAs:aTag extensionsOnly:extensionsOnly
    ^ self
        diffSetOfProject:aProject 
        againstRepositoryVersionFrom:nil
        orTag:aTag
        extensionsOnly:extensionsOnly

    "Created: / 12-11-2016 / 03:41:23 / cg"
!

ensureCorrectVersionMethodsInClass:aClass usingManager:aManager
    |theMetaclass versionMthd src newSrc versionMethodName oldVersionMethodName|

    theMetaclass := aClass theMetaclass.
    versionMethodName := aManager nameOfVersionMethodInClasses.
    oldVersionMethodName := aClass nameOfOldVersionMethod.

    (theMetaclass includesSelector:versionMethodName) ifTrue:[
"/        (theMetaclass includesSelector:oldVersionMethodName) ifTrue:[
"/            theMetaclass removeSelector:oldVersionMethodName.   
"/        ].
        "/ ensure that my version method is parsable (contains $'s)
        versionMthd := theMetaclass compiledMethodAt:versionMethodName.
        versionMthd notNil ifTrue:[
            src := versionMthd source.
            src notNil ifTrue:[
                newSrc := aManager ensureDollarsInVersionMethod:src.
                newSrc ~= src ifTrue:[
                    theMetaclass compile:newSrc categorized:#documentation.
                ]
            ].
        ].
    ] ifFalse:[
        (theMetaclass includesSelector:oldVersionMethodName) ifTrue:[
            "/ but make sure, it is a version method for this sourcecodemanager...
            (theMetaclass methodDictionary keys count:[:sel | sel startsWith:'version']) size == 1 ifTrue:[
                versionMthd := theMetaclass compiledMethodAt:oldVersionMethodName.
                versionMthd notNil ifTrue:[
                    src := versionMthd source.
                    (src startsWith:oldVersionMethodName) ifTrue:[
                        newSrc := versionMethodName , (src copyFrom:(oldVersionMethodName size + 1))
                    ].
                    theMetaclass compile:newSrc categorized:#documentation.
                ]
            ]
        ].
    ].

    "Modified: / 20-08-2011 / 14:40:27 / cg"
    "Created: / 29-12-2011 / 14:33:46 / cg"
!

fetchSourceOf:aClass askForRevision:askForRevision into:aBlockToReturnMultipleValues
    "fetch the source of either the newest version or the revision being asked for,
     or nil, if there are any problems.
     Helper method"

    |classToCompare aStream comparedSource rev revString mgr
     nm msg revisionInClass newestRev|

    classToCompare := aClass theNonMetaclass.

    nm := classToCompare name.
    (mgr := manager) isNil ifTrue:[
        mgr := self sourceCodeManagerFor:classToCompare.
        mgr isNil ifTrue:[
            self error:'oops - no sourcecode manager' mayProceed:true.
            ^ nil
        ].
    ].

    rev := classToCompare revisionInfoOfManager:mgr.
"/    rev := classToCompare binaryRevision.
    revisionInClass := classToCompare revisionOfManager:mgr.
    rev isNil ifTrue:[
        rev := revisionInClass
    ].
    rev isNil ifTrue:[
        (Dialog confirm:'Class seems to be not yet in the repository (or classes revision info is missing or corrupted)\\Proceed ?' withCRs)
        ifFalse:[
            ^ nil
        ]
    ].

    "/
    "/ class in repository - ask for revision
    "/
    SourceCodeManagerError handle:[:ex |
        Dialog warn:(resources 
                                stringWithCRs:'Could not fetch revision info of "%1".\\Please check your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
                                with:classToCompare name
                                with:classToCompare sourceCodeManager managerTypeName
                                with:classToCompare package).
        ^ nil.
    ] do:[
        newestRev := mgr newestRevisionOf:classToCompare.
    ].

    askForRevision ifTrue:[
        msg := resources string:'Compare to revision: (empty for newest)'.
        rev notNil ifTrue:[
            msg := msg , '\\' , (resources string:'Current %1 is based upon rev %2.'
                                           with:nm allBold with:rev).
            (revisionInClass notNil and:[revisionInClass ~= rev]) ifTrue:[
                msg := msg , '\' , (resources string:'And has been checked into the repository as %1.'
                                               with:revisionInClass)
            ]
        ].
        newestRev notNil ifTrue:[
            msg := msg , '\' , (resources string:'Newest in repository is %1.'
                                           with:newestRev)
        ].

        rev := self
                    askForExistingRevision:msg 
                    title:'Compare with repository' 
                    class:classToCompare.
    ] ifFalse:[
        rev := newestRev.
    ].

    rev isNil ifTrue:[
        mgr = classToCompare sourceCodeManager ifTrue:[
            msg := 'Could not figure out the newest revision of "%1".\\Please check if this class is really contained in that repository,\and also your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
        ] ifFalse:[
            msg := 'Could not figure out the newest revision of "%1".\\Notice that the class is actually maintained by %4, not %2.\Please check if this class is really in the %2 repository,\and also your sourcecode manager settings of %2 for package: "%3".\(and possibly the network for reachability of the repository)'
        ].
        Dialog warn:(resources 
                                stringWithCRs:msg
                                with:classToCompare name
                                with:mgr managerTypeName
                                with:classToCompare package
                                with:(classToCompare sourceCodeManager managerTypeName)).
        ^ nil.
    ].

    rev withoutSpaces isEmpty ifTrue:[
        msg := 'extracting newest %1 (' , (newestRev ? '???') , ')'.
        "/ aStream := mgr getMostRecentSourceStreamForClassNamed:nm.
        aStream := mgr getSourceStreamFor:classToCompare revision:newestRev.
        revString := '(newest: ' , (newestRev ? '???') , ')'.
    ] ifFalse:[
        msg := 'extracting previous %1'.
        aStream := mgr getSourceStreamFor:classToCompare revision:rev.
        revString := rev
    ].

    aStream isNil ifTrue:[
        self warn:'Could not extract source from repository (check repository settings / network)'.
        ^ nil
    ].
    aStream class readErrorSignal handle:[:ex |
        self warn:('Read error while reading extracted source\\' , ex description) withCRs.
        aStream close.
        ^ nil
    ] do:[
        comparedSource := aStream contents asString.
    ].

    aStream close.

    aBlockToReturnMultipleValues 
        value:revString 
        value:revisionInClass
        value:mgr. 
    ^ comparedSource

    "
      self compareClassWithRepository:Array
    "

    "Modified: / 24-07-2012 / 18:11:27 / cg"
!

getLogMessageForClassCheckinTakingDefaultsFromPreviousLogInfo:aLogInfoOrNil forClass:aClass valuesInto:aBlock
    "open a dialog, asking for commit/checkin log info.
     Returns 2 values: a log message and additional checkinInfo (containing things like
     markAsStable, etc,)"

    |initialLogMessage checkinInfo reasonLine logMessage|
    
    "/ heuristics for a useful initial log message...
    aLogInfoOrNil isNil ifTrue:[
        initialLogMessage := (self goodInitialLogMessageForCheckinClassOfClass:aClass) ? ''.
        "/ initial checkin ?
        (aClass package isNil or:[(aClass revisionOfManager:manager) "revision" isNil]) ifTrue:[ 
            initialLogMessage := 'initial checkin\\' withCRs , initialLogMessage
        ].
        aClass isProjectDefinition ifTrue:[
            checkinInfo := self 
                            getCheckinInfoFor:aClass name 
                            initialAnswer:initialLogMessage
                            withQuickOption:false
                            withValidateConsistencyOption:true
        ] ifFalse:[
            checkinInfo := self 
                            getCheckinInfoFor:aClass name 
                            initialAnswer:initialLogMessage.
        ].
        checkinInfo isNil ifTrue:[^ false].

        (aClass isProjectDefinition and:[checkinInfo validateConsistency]) ifTrue:[
            self validateConsistencyOfPackage:aClass package doClasses:false doExtensions:false.
        ].

        logMessage := checkinInfo logMessage.

        reasonLine := '#OTHER'. 
        checkinInfo checkinReason == Tools::CheckinInfoDialog reasonBugfix ifTrue:[
            reasonLine := '#BUGFIX' 
        ] ifFalse:[ 
            checkinInfo checkinReason == Tools::CheckinInfoDialog reasonFeature ifTrue:[
                reasonLine := '#FEATURE' 
            ] ifFalse:[ 
                checkinInfo checkinReason == Tools::CheckinInfoDialog reasonRefactoring ifTrue:[
                    reasonLine := '#REFACTORING' 
                ] ifFalse:[ 
                    checkinInfo checkinReason == Tools::CheckinInfoDialog reasonDocumentation ifTrue:[
                        reasonLine := '#DOCUMENTATION' 
                    ] ifFalse:[ 
                        checkinInfo checkinReason == Tools::CheckinInfoDialog reasonUIEnhancement ifTrue:[
                            reasonLine := '#UI_ENHANCEMENT' 
                        ] ifFalse:[ 
                            checkinInfo checkinReason == Tools::CheckinInfoDialog reasonQuality ifTrue:[
                                reasonLine := '#QUALITY' 
                            ] ifFalse:[ 
                                checkinInfo checkinReason == Tools::CheckinInfoDialog reasonTuning ifTrue:[
                                    reasonLine := '#TUNING' 
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ] ifFalse:[
        aLogInfoOrNil isString ifTrue:[
            "soon obsolete..."    
            logMessage := aLogInfoOrNil
        ] ifFalse:[ 
            checkinInfo := aLogInfoOrNil.
            logMessage := checkinInfo logMessage.
        ].
    ].
    logMessage notNil ifTrue:[  
        logMessage := logMessage asSingleByteStringReplaceInvalidWith:$?
    ].
    reasonLine isNil ifTrue:[
        reasonLine := '#OTHER'. 
    ].
    logMessage := reasonLine , ' by ',OperatingSystem getLoginName,'\' withCRs 
                  , (logMessage ? '').
    aBlock value:logMessage value:checkinInfo.
    ^ true

    "Modified: / 31-03-2016 / 17:58:11 / cg"
!

removeSourceContainerForClass:aClass
    "show container & let user confirm twice."

    ^ self removeSourceContainerForClass:aClass confirm:true warn:true
!

removeSourceContainerForClass:aClass confirm:doConfirm warn:doWarn
    "show container & optionally let user confirm twice."

    |info mgr|

    aClass isLoaded ifFalse:[
        doWarn ifTrue:[
            self warn:(resources string:'Please load the class first.').
        ].
        ^ false.
    ].

    "/
    "/ ask the sourceCodeManager if it knows anything about that class
    "/ if so, take that as a default.
    "/
    mgr := self sourceCodeManagerFor:aClass.
    mgr isNil ifTrue:[
        ^ false
    ].

    info := mgr sourceInfoOfClass:aClass.
    ^ self removeSourceContainerForClass:aClass usingSourceInfo:info confirm:doConfirm warn:doWarn

    "Modified: / 16-07-2013 / 19:46:50 / cg"
!

removeSourceContainerForClass:aClass usingSourceInfo:info confirm:doConfirm warn:doWarn
    "show container & optionally let user confirm twice."

    |module directory fileName mgr|

    aClass isLoaded ifFalse:[
        doWarn ifTrue:[
            self warn:(resources string:'Please load the class first.').
        ].
        ^ false.
    ].

    "/
    "/ ask the sourceCodeManager if it knows anything about that class
    "/ if so, take that as a default.
    "/
    mgr := self sourceCodeManagerFor:aClass.
    mgr isNil ifTrue:[
        ^ false
    ].

    info notNil ifTrue:[
        (info includesKey:#module) ifTrue:[
            module := (info at:#module).
        ].
        (info includesKey:#directory) ifTrue:[
            directory := (info at:#directory).
        ].
        fileName := mgr containerFromSourceInfo:info.
    ].

    module isNil ifTrue:[
        doWarn ifTrue:[
            self warn:(resources stringWithCRs:'classes module is unknown.\\It seems to not have a container.') .
        ].
        ^ false.
    ].
    directory isNil ifTrue:[
        doWarn ifTrue:[
            self warn:(resources stringWithCRs:'classes package is unknown.\\It seems to not have a container.') .
        ].
        ^ false.
    ].
    fileName isNil ifTrue:[
        doWarn ifTrue:[
            self warn:(resources stringWithCRs:'classes container fileName is unknown.\\It seems to not have a container.') .
        ].
        ^ false.
    ].

    OperatingSystem isMSDOSlike ifTrue:[
        "cvs expects unix-filenames"
        module := module asUnixFilenameString.
        directory := directory asUnixFilenameString.
    ].
    (mgr checkForExistingContainer:fileName inModule:module directory:directory) ifFalse:[
        doWarn ifTrue:[
            self warn:(resources stringWithCRs:'Class had no source container (or SCM access is broken).') .
        ].
        ^ false.
    ].

    doConfirm ifTrue:[
        (Dialog
            choose:(resources 
                        stringWithCRs:'Please confirm removal of the container for %1:

container:    %2 / %3 / %4

Really remove ?' 
                        with:aClass name 
                        with:module 
                        with:directory 
                        with:fileName) 
            labels:(Array 
                        with:(resources string:'No') 
                        with:(resources string:'Remove'))
            values:#(false true)
            default:false) ifFalse:[
            ^ false.
        ].
    ].

    (mgr removeContainer:fileName inModule:module directory:directory) 
    ifFalse:[
        doWarn ifTrue:[
            self warn:(resources string:'failed to remove container.').
        ].
        ^ true.
    ].
    ^ false

    "Modified: / 16-07-2013 / 19:46:50 / cg"
!

repositoryLogOf:aClass onto:aStream
    self repositoryLogOf:aClass short:false onto:aStream
!

repositoryLogOf:aClass short:shortOrNot onto:aStream
    |info rv mgr info2 module fn msg s|

    info := aClass revisionInfo.

    rv := aClass binaryRevision.
    rv notNil ifTrue:[
        aStream nextPutLine:'**** Loaded classes binary information ****'; cr.
        aStream nextPutLine:'  Binary based upon : ' , rv.
        aStream cr.
    ].

    "/ old
"/    info isNil ifTrue:[
"/        aStream nextPutLine:'No revision info found'.
"/        aClass isLoaded ifFalse:[
"/            aStream cr; nextPutAll:'This is an autoloaded class - you may see more after it is loaded.'
"/        ] ifTrue:[
"/            fn := aClass classFilename.
"/            aClass wasAutoloaded ifTrue:[
"/                msg := 'This class was autoloaded.'.
"/                msg := msg , ' (from ''' , fn , ''')'.
"/            ] ifFalse:[
"/                msg := 'This class was loaded from ''' , fn , '''.'
"/            ].
"/            msg notNil ifTrue:[
"/                aStream cr; nextPutAll:msg.
"/            ]
"/        ].
"/        ^ self
"/    ]

    info isNil ifTrue:[
        aClass isLoaded ifFalse:[
            aStream nextPutLine:'This is an autoloaded class - you may see more after it is loaded.'
        ] ifTrue:[
            fn := aClass classFilename.
            aClass wasAutoloaded ifTrue:[
                msg := 'This class was autoloaded.'.
                msg := msg , ' (from ''' , fn , ''')'.
            ] ifFalse:[
                msg := 'This class was loaded from ''' , fn , '''.'
            ].
            msg notNil ifTrue:[
                aStream nextPutLine:msg.
            ]
        ].
        aStream cr.
    ] ifFalse:[
        (info revision notNil) ifFalse:[
            aStream nextPutLine:'WARNING:'; cr.
            aStream nextPutLine:'  The class seems not to be loaded from the repository.'.
            aStream nextPutLine:'  Check carefully before checking anything in.'.
            aStream nextPutLine:'  (i.e. compare with repository for renamed class(es), same-name but unrelated etc.)'.
            aStream cr.
        ].

        aStream nextPutLine:'**** Classes source information ****'; cr.
        s := info repositoryPathName.
        s notNil ifTrue:[
            aStream nextPutLine:'  Source repository : ' , s
        ].
        aStream nextPutLine:('  Filename ........ : %1' bindWith: (info fileName ? '?')).
        info symbolicVersionName ~= info revision ifTrue:[
            aStream nextPutLine:('  Symbolic Version  : %1' bindWith: (info symbolicVersionName ? '?')).
        ].
        aStream nextPutLine:('  Revision ........ : %1' bindWith: (info revision ? '?')).
        aStream nextPutLine:('  Checkin date .... : %1 %2 %3' bindWith: (info date  ? '?') 
                                                              with:(info time ? '?') 
                                                              with:(info timezone ? '')).
        aStream nextPutLine:('  Checkin user .... : %1' bindWith: (info user ? '?')).
    ].

    (info2 := aClass packageSourceCodeInfo) notNil ifTrue:[
        aStream nextPutLine:'  Repository: ..... : ' , (info2 at:#module ifAbsent:'?').
        aStream nextPutLine:'  Directory: ...... : ' , (info2 at:#directory ifAbsent:'?').
    ].
    info notNil ifTrue:[
        aStream nextPutLine:'  Container ....... : ' , (info repositoryPathName ? '?').
    ].
    aStream cr.
    mgr := self sourceCodeManagerFor:aClass.
    mgr notNil ifTrue:[
        aStream nextPutLine:'**** Repository information ****'; cr.

        module := nil.
        info2 notNil ifTrue:[
            module := info2 at:#module ifAbsent:nil.
        ].
        module notNil ifTrue:[
            aStream nextPutLine:('  Repository URL ......: %1' bindWith: 
                                ((mgr repositoryNameForPackage:aClass package) ifNil:[mgr repositoryName , ' (default)']) asString).
        ].
        mgr writeRevisionLogOf:aClass short:shortOrNot to:aStream.
    ]

    "Modified: / 12-10-2011 / 18:06:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2012 / 13:50:59 / cg"
!

tagClass:aClass as:tag
    |mgr|

    mgr := self sourceCodeManagerFor:aClass.
    mgr
        setSymbolicName:tag 
        revision:nil 
        overWrite:true 
        class:aClass.

    "Modified: / 12-09-2006 / 13:03:59 / cg"
!

tagClasses:aCollectionOfClasses as:tag
    ^ self tagClasses:aCollectionOfClasses as:tag revision:nil

    "Created: / 12-09-2006 / 13:04:29 / cg"
!

tagClasses:aCollectionOfClasses as:tag revision:revision
    |classesPerManager|

    classesPerManager := Dictionary new.
    aCollectionOfClasses 
        do:[:eachClass | 
            |manager|

            manager := self sourceCodeManagerFor:eachClass.
            (classesPerManager at:manager ifAbsentPut:[Set new]) add:eachClass
        ].

    classesPerManager keysAndValuesDo:[:manager :classesPerManager|
        manager
            setSymbolicName:tag 
            revision:revision 
            overWrite:true 
            classes:classesPerManager.
    ].
    ^ true
!

tagPackage: package as:tag

    self tagClasses:(Smalltalk allClassesInPackage:package) as:tag.

    "Created: / 12-09-2006 / 13:04:29 / cg"
    "Created: / 15-10-2011 / 22:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagPath:aPath as:tag usingManager:aManager
    aManager 
        setSymbolicName:tag 
        revision:nil 
        overWrite:true 
        path:aPath.

    "Modified: / 12-09-2006 / 12:04:44 / cg"
    "Created: / 29-12-2011 / 14:32:38 / cg"
! !

!SourceCodeManagerUtilities methodsFor:'utilities-cvs-helpers'!

getMethodVersionsOfClass:aClass selector:selector numberOfRevisions:numberOfRevisionsOrNil
    "check-out all previous versions of aClass and retrieve the history of selector.
     Return a dictionary associating revision with a changeList entries for that method.
     Unfinished - need a GUI for that."

    |mgr theClass revisionLog revisions items s entriesPerRevision previousVersion|

    theClass := aClass theNonMetaclass.

    mgr := self sourceCodeManagerFor:theClass.
    mgr isNil ifTrue:[
        self error:'no sourceCodeManager'.
    ].

    revisionLog := mgr
                        revisionLogOf:theClass
                        numberOfRevisions:numberOfRevisionsOrNil.

    revisions := revisionLog at:#revisions.
    items := revisions collect:[:each | |rev date who|
                                    rev := each at:#revision.
                                    date := each at:#date.
                                    who := each at:#author.
                                    rev allBold , ' [' , date , ' by ' , who , ']'
                               ].

    revisions := revisions collect:[:each | each at:#revision].
    revisions addFirst:#current.
    entriesPerRevision := Dictionary new.

    previousVersion := nil.
    revisions reverseDo:[:eachRevision |
        |srcStream entries thisVersion|

        eachRevision == #current ifTrue:[
            s := '' writeStream.
            theClass fileOutOn:s withTimeStamp:false.
            srcStream := s contents readStream.
        ] ifFalse:[
            self activityNotification:('checking out revision ' , eachRevision , '...').
            srcStream := mgr getSourceStreamFor:theClass revision:eachRevision.
        ].

        entries := ChangeSet fromStream:srcStream.
        srcStream close.

        "/ remove all definitions       
        entries := entries select:[:each | each isMethodChange].
        "/ remove all methods which are for other selectors      
        entries := entries select:[:each | each selector == selector].
        "/ remove all methods which are for private subclasses      
        entries := entries select:[:each | each className = aClass name].

        entries size == 1 ifTrue:[
            "/ the method is there
            thisVersion := entries first.
            (previousVersion notNil and:[previousVersion sameAs:thisVersion]) ifTrue:[
                "/ no change
            ] ifFalse:[
                entriesPerRevision at:eachRevision put:thisVersion.
            ].
        ] ifFalse:[
            "/ the method is not there
        ].
        previousVersion := thisVersion.
    ].
    self error:'unfinished code'.

    "
     self getMethodVersionsOfClass:MenuPanel selector:#'helpTextForItem:' numberOfRevisions:20
     self getMethodVersionsOfClass:NewLauncher class selector:#'menu' numberOfRevisions:20
    "
! !

!SourceCodeManagerUtilities methodsFor:'utilities-cvs-user interaction'!

askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName
    "open a dialog asking for a source container;
     return a dictionary containing module, package and filename,
     or nil if canceled."

    ^ self
        askForContainer:boxText title:title note:notice 
        initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName 
        forNewContainer:true
!

askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName forNewContainer:forNewContainer
    "open a dialog asking for a source container;
     return a dictionary containing module, package and filename,
     or nil if canceled."

    |box y component answer
     moduleHolder packageHolder fileNameHolder
     module package fileName 
     allPackageIDs knownContainers knownPackages packageUpdater
     packageBoxComponent fileNameBoxComponent fileNameUpdater|

    allPackageIDs := Smalltalk allPackageIDs.

    knownContainers := allPackageIDs collect:[:package | (package upTo:$:)] as:Set.

    knownContainers := knownContainers asOrderedCollection reject:[:module | module isBlank].
    knownContainers sort.

    packageUpdater := [
        |theModulePrefix|

        theModulePrefix := moduleHolder value , ':'.

        Cursor wait showWhile:[
            knownPackages := 
                allPackageIDs
                    select:[:package | (package startsWith:theModulePrefix)]
                    thenCollect:[:package | |idx|
                        idx := package indexOf:$:.
                        (package copyFrom:idx + 1)].

            knownPackages := knownPackages asSet asOrderedCollection.
            knownPackages := knownPackages reject:[:package | package isBlank].
            knownPackages sort.
            packageBoxComponent list:knownPackages.
        ].
    ].

    fileNameUpdater := [
        |module package files|

        Cursor read showWhile:[
            module := moduleHolder value ? (PackageId noProjectID).
            package := packageHolder value ? (PackageId noProjectID).

            files := SourceCodeManager getExistingContainersInModule:module directory:package.
            files := files asOrderedCollection.
            files := files select:[:eachFile | eachFile asFilename hasSuffix:'st'].
            files sort.
            fileNameBoxComponent list:files.
        ].
    ].

    moduleHolder := initialModule asValue.
    packageHolder := initialPackage asValue.
    fileNameHolder := initialFileName asValue.

    "/
    "/ open a dialog for this
    "/
    box := DialogBox new.
    box label:title.

    component := box addTextLabel:boxText withCRs adjust:#left.
    component borderWidth:0.
    box addVerticalSpace.
    box addVerticalSpace.

    y := box yPosition.
    component := box addTextLabel:(resources string:'Module:') adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addComboBoxOn:moduleHolder tabable:true.
    component list:knownContainers.

"/    component := box addInputFieldOn:moduleHolder tabable:true.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:(resources string:'Package:') adjust:#right.
    component width:0.4.
    box yPosition:y.
    packageBoxComponent := component := box addComboBoxOn:packageHolder tabable:true.
"/    component := box addInputFieldOn:packageHolder tabable:true.
    component width:0.6; left:0.4; "immediateAccept:true; "acceptOnLeave:true; cursorMovementWhenUpdating:#beginOfLine.
    packageUpdater value.
    moduleHolder onChangeEvaluate:packageUpdater.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:(resources string:'Filename:') adjust:#right.
    component width:0.4.
    box yPosition:y.

    forNewContainer ifTrue:[
        component := box addInputFieldOn:fileNameHolder tabable:true.
        component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
    ] ifFalse:[
        fileNameBoxComponent := component := box addComboBoxOn:fileNameHolder tabable:true.
        component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        fileNameUpdater value.
        packageHolder onChangeEvaluate:fileNameUpdater.
    ].

    box addVerticalSpace.

    notice notNil ifTrue:[
        component := box addTextLabel:notice adjust:#left.
        component borderWidth:0.
    ].

    box addVerticalSpace.
    box addAbortAndOkButtons.

    (YesToAllNotification notNil and:[YesToAllNotification isHandled]) ifTrue:[
        component := Button label:(resources string:'Yes to All').
        component action:[
                            YesToAllNotification queryWith:true.
                            box doAccept.
                            box okPressed.
                         ].
        box addButton:component.
    ].
    (AbortAllSignal isHandled) ifTrue:[
        component := Button label:(resources string:'Cancel All').
        component action:[
                            box hide.
                            AbortAllSignal raiseSignal.
                         ].
        box addButton:component before:nil.
    ].

    (YesToAllQuery notNil and:[YesToAllQuery isHandled]) ifTrue:[
        answer := YesToAllQuery query.
    ].

    answer isNil ifTrue:[
        box showAtPointer.
        answer := box accepted
    ].

    box destroy.
    answer ifFalse:[
        ^ nil
    ].

    module := moduleHolder value withoutSpaces.
    package := packageHolder value withoutSpaces.
    fileName := fileNameHolder value withoutSpaces.
    ^ Dictionary new
        at:#module put:module;
        at:#package put:package;
        at:#fileName put:fileName;
        yourself

    "
     self 
        askForContainer:'enter container' title:'container' note:'some note'
        initialModule:'foo' initialPackage:'bar' initialFileName:'baz'        
    "

    "Modified: / 29-08-2013 / 12:26:04 / cg"
!

askForExistingRevision:boxText title:title class:aClass
    "open a dialog asking for a containers revision;
     return a revision number, or nil if canceled."

    |mgr sourceInfo module package fileName|

    mgr := self sourceCodeManagerFor:aClass.
    sourceInfo := mgr sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[^ nil].

    package := mgr directoryFromSourceInfo:sourceInfo.
    module := mgr moduleFromSourceInfo:sourceInfo.  
    fileName := mgr containerFromSourceInfo:sourceInfo.
    ^ self
        askForExistingRevision:boxText 
        title:title 
        class:aClass 
        manager:mgr 
        module:module package:package 
        fileName:fileName

    "
     SourceCodeManagerUtilities
        askForRevisionToCompare:'enter revision'
        title:'revision'
        class:Array
    "

    "Modified: / 12-09-2006 / 14:17:04 / cg"
!

askForExistingRevision:boxText title:title class:clsOrNil manager:aSourceCodeManager module:module package:directory fileName:fileName
    "open a dialog asking for a containers revision;
     return a revision number, or nil if canceled."

    |partialLog revisions items newestRev
     box y component revisionHolder symbolicNames stableRevision releasedRevision
     tagHolder tagList lockChange|

    partialLog := aSourceCodeManager
        revisionLogOf:clsOrNil
        numberOfRevisions:20
        fileName:fileName
        directory:directory 
        module:module.

    partialLog notNil ifTrue:[
        newestRev := partialLog at:#newestRevision.
        revisions := partialLog at:#revisions.
        symbolicNames := partialLog at:#symbolicNames ifAbsent:[].
        symbolicNames notNil ifTrue:[
            stableRevision := symbolicNames at:'stable' ifAbsent:[].
            releasedRevision := symbolicNames at:'released' ifAbsent:[].
            tagList := ((symbolicNames associations sort:[:a :b | a key < b key "self versionString:(a value) isLessThan:(b value)"])
                         collect:[:assoc | assoc key]) reverse.
            tagList remove:'stable' ifAbsent:[].
            tagList notEmpty ifTrue:[tagList addFirst:'-'].
            tagList addFirst:'stable'.
            LastTag notNil ifTrue:[
                tagList addFirst:LastTag.
            ].    
        ].

        "/ fill in timestamps
        revisions do:[:each |
            |dateOrDateString timeOrTimeString timestampString timestamp|

            dateOrDateString := each at:#date ifAbsent:nil.
            timeOrTimeString := each at:#time ifAbsent:nil.
            dateOrDateString notNil ifTrue:[
                dateOrDateString isString ifTrue:[
                    timestamp := Timestamp readFrom:dateOrDateString onError:nil.
                    timestamp notNil ifTrue:[
                        each at:#timestamp put:timestamp.
                        each at:#day put:timestamp asDate.
                    ].
                ] ifFalse:[
                    timeOrTimeString isString ifTrue:[
                    self halt.
    
                    ] ifFalse:[
                        (dateOrDateString notNil and:[timeOrTimeString notNil]) ifTrue:[
                            timestamp := Timestamp fromDate:dateOrDateString andTime:timeOrTimeString.
                            each at:#timestamp put:timestamp.
                        ] ifFalse:[
                            self halt
                        ]    
                    ]
                ].    
            ].
        ].

        items := revisions 
                    collectWithIndex:[:each :idx| 
                        |rev timestamp date time dateAndTimeString who flag 
                         prevInfo prevDate nextInfo nextDate dateDifferentToPrev dateDifferentToNext|

                        rev := each at:#revision.

                        timestamp := each at:#timestamp.
                        timestamp notNil ifTrue:[
                            date := each at:#day.
                            date = Date today ifTrue:[
                                dateAndTimeString := timestamp asTime printString.
                            ] ifFalse:[
                                "/ if date is different to both previous AND next,
                                "/ only show the date
                                dateDifferentToPrev := dateDifferentToNext := false.
                                (idx > 1) ifTrue:[
                                    prevInfo := revisions at:idx-1.
                                    prevDate := prevInfo at:#day ifAbsent:nil.
                                    dateDifferentToPrev := (prevDate notNil and:[prevDate ~= date]).
                                ].
                                (idx < revisions size) ifTrue:[
                                    nextInfo := revisions at:idx+1.
                                    nextDate := nextInfo at:#day ifAbsent:nil.
                                    dateDifferentToNext := (nextDate notNil and:[nextDate ~= date]).
                                ].
                                (dateDifferentToPrev and:[dateDifferentToPrev]) ifTrue:[
                                    dateAndTimeString := date printString.
                                ] ifFalse:[
                                    dateAndTimeString := date printString,' ',(timestamp asTime printString).
                                ]
                            ].
                        ] ifFalse:[
                            dateAndTimeString := (each at:#date ifAbsent:nil) ? '(unknown time)'.
                        ].
                        who := (each at:#author ifAbsent:nil) ? '?'.
                        rev = stableRevision ifTrue:[
                            flag := ' Stable' allBold.
                        ] ifFalse:[rev = releasedRevision ifTrue:[
                            flag := ' Released' allBold.
                        ] ifFalse:[
                            flag := ''
                        ]].
                        '%1%2 [%3 by %4]' bindWith:rev allBold with:flag with:dateAndTimeString with:who 
                   ].

        revisions := revisions collect:[:each | each at:#revision].
    ] ifFalse:[
        newestRev := aSourceCodeManager newestRevisionInFile:fileName directory:directory module:module.
        revisions := items := nil.

        newestRev isNil ifTrue:[
            (aSourceCodeManager checkForExistingContainer:fileName inModule:module directory:directory)
            ifFalse:[
                self warn:'Could not find/access the container for ',fileName,' in the repository.
This could be due to:
    - invalid/wrong CVS-Root setting
    - missing CVS access rights
        (no access / not logged in)
    - changed CVSRoot after compilation
        (i.e. wrong CVS-path in classes version method)
'.
                ^ nil
            ]
        ]
    ].

    lockChange := false.
    revisionHolder := newestRev asValue.
    revisionHolder onChangeEvaluate:[
        "/ cut off everything after revision
        |s first words tag|

        s := revisionHolder value.
        words := s asCollectionOfWords.
        words size > 0 ifTrue:[
            first := words first string.
            first ~= s ifTrue:[
                revisionHolder value:first
            ]
        ].
        lockChange ifFalse:[
            tagHolder value:''
        ].
    ].

    tagHolder := '' asValue.
    tagHolder 
        onChangeEvaluate:[
            |tag rev|

            (tag := tagHolder value) notEmptyOrNil ifTrue:[
                "/ LastTag := tag.
                rev := symbolicNames at:tag.
                rev ~= revisionHolder value ifTrue:[
                    lockChange := true.
                    revisionHolder value:rev.
                    lockChange := false.
                ].
            ]
        ].

    "/
    "/ open a dialog for this
    "/
    box := DialogBox new.
    box label:title.

    component := box addTextLabel:boxText withCRs adjust:#left.
    component borderWidth:0.
    box addVerticalSpace.
    box addVerticalSpace.

    y := box yPosition.
    component := box addTextLabel:(resources string:'Revision:') adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addComboBoxOn:revisionHolder tabable:true.
    component list:items.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    y := box yPosition.
    component := box addTextLabel:(resources string:'or Tag:') adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addComboListOn:tagHolder tabable:true.
    component list:tagList.
    component width:0.6; left:0.4.
    tagList isNil ifTrue:[
        component disable
    ].

    box addVerticalSpace.

    box addAbortAndOkButtons.

    AbortAllOperationWantedQuery query ifTrue:[
        (box addAbortButtonLabelled:'Cancel all') action:[AbortAllSignal raise].
    ].
    LastTag notEmptyOrNil ifTrue:[
        (symbolicNames notNil and:[symbolicNames includesKey:LastTag]) ifTrue:[
            tagHolder value:LastTag.
        ].
    ].
    
    box showAtPointer.

    box accepted ifFalse:[
        box destroy.
        ^ nil
    ].
    box destroy.

    LastTag := tagHolder value.
    
    "/ it is not a good idea to return the tag-name here,
    "/ because it may get cached later when the source is fetched,
    "/ and the tag could move to another version (making the cached file invalid)
    "/ without me knowing about that fact.
    "/ Therefore, we should return the real revision number.

    "/ ouch: however, checkout of a branch seems to not work the same way
    "/ so we DO return the tag, but suppress caching it. sigh.
    ^ (tagHolder value notEmptyOrNil ifTrue:[tagHolder] ifFalse:[revisionHolder]) value withoutSpaces.
    "/ ^ revisionHolder value withoutSpaces.

    "
     SourceCodeManagerUtilities
        askForRevisionToCompare:'enter revision'
        title:'revision'
        class:nil
        manager:SourceCodeManager 
        module:'stx'
        directory:'libbasic'
        fileName:'Array.st'
    "

    "Modified: / 30-04-2016 / 14:32:17 / cg"
!

checkAndWarnAboutBadMessagesInClass:aClass checkAgainHolder:checkAgainHolder
    "check if a class contains message-sends to:
        #halt , #halt:
        #error
        #todo , #todo:
        (and maybe more in the future)

     Only checks in non-extension methods - as this is only called when checking "

    |badStuff whatIsBad msg answer labels values defaultAnswer dontShowAgain
     methodsWithBadStuff|

    badStuff := #(
        ( halt         'send of #halt (use for debugging only) - better use #error:''some message'' or #breakPoint:')
        ( halt:        'send of #halt: (use for debugging only) - better use #error: or #breakPoint:')
        ( error        'send of #error without descriptive message - better use #error:''some message''' )
        ( todo         'send of #todo - unfinished code present?' )
        ( todo:        'send of #todo:- unfinished code present?' )
    ).

    methodsWithBadStuff := Set new.
    whatIsBad := Set new.
    aClass theNonMetaclass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
        |setOfLiterals setOfSentMessages|

        mthd isExtension ifFalse:[
            setOfLiterals := mthd literals.  "/ try without parsing first.
            (badStuff contains:[:eachEntry | setOfLiterals includes:eachEntry first]) ifTrue:[
                setOfSentMessages := mthd messagesSent.
                badStuff do:[:eachEntry | 
                    (setOfSentMessages includes:eachEntry first) ifTrue:[
                        whatIsBad add:eachEntry second.
                        methodsWithBadStuff add:mthd.
                    ]
                ].
            ].
        ].
    ].
    whatIsBad isEmpty ifTrue:[^ true].

    (YesToAllQuery notNil and:[YesToAllQuery isHandled]) ifTrue:[
        answer := YesToAllQuery query.
        answer notNil ifTrue:[ ^ answer ].
    ].

    msg := resources string:'%1 contains the following (considered bad style) message sends:' with:aClass name.
    msg := msg , '\\'.
    whatIsBad do:[:each |
        msg := msg , '   ' , each , '\'
    ].
    msg := msg , '\'.
    methodsWithBadStuff size == 1 ifTrue:[
        msg := msg , (resources string:'In %1.' 
                        with:methodsWithBadStuff anElement whoString allBold).
    ] ifFalse:[
        msg := msg , (resources string:'In %1 and %2 other methods.' 
                        with:methodsWithBadStuff anElement whoString allBold 
                        with:methodsWithBadStuff size-1).
    ].
    msg := msg , '\\' , (resources string:'Do you really want to checkIn the %1 class ?' with:aClass name).

    (YesToAllNotification notNil and:[YesToAllNotification isHandled]) ifTrue:[
        labels := #('Cancel All' 'Cancel' 'No to All' 'No' 'No, Browse' 'Yes to All' 'Yes') "#('Yes' 'Yes to All' 'No' 'No to All' 'Cancel')".
        values := #(#cancelAll nil #noToAll #noBrowse false #yesToAll true) "#(true #yesToAll false #noToAll nil)".
        defaultAnswer := #yesToAll.
    ] ifFalse:[
        labels := #('No' 'No, Browse' 'Yes').
        values := #(false #noBrowse true).
        defaultAnswer := true.
    ].

"/        AbortAllOperationRequest isHandled ifTrue:[
"/            labels := #('Cancel All') , labels.
"/            values := #(#cancelAll) , values.
"/        ].

    Dialog modifyingBoxWith:[:box |
        checkAgainHolder isValueModel ifTrue:[
            dontShowAgain := checkAgainHolder value not asValue.
            box addCheckBoxAtBottom:(resources string:'Do not show this Dialog again (reenable in Launcher).')
                on:dontShowAgain.
        ].
    ] do:[
        answer := OptionBox 
                      request:msg withCRs
                      label:(resources string:'Really CheckIn ?')
                      image:(InfoBox iconBitmap)
                      buttonLabels:(Dialog classResources array:labels)
                      values:values
                      default:defaultAnswer
                      onCancel:nil.
    ].
    answer isNil ifTrue:[
        AbortOperationRequest raise.
    ].

    dontShowAgain notNil ifTrue:[
        checkAgainHolder value:dontShowAgain value not 
    ].

    answer == #noBrowse ifTrue:[
        UserPreferences browserClass browseMethods:methodsWithBadStuff title:'Methods with Bad Stuff'.
        self yesToAllNotification queryWith:false.
        ^ false
    ].
    answer == #cancelAll ifTrue:[
        AbortOperationRequest raise.
    ].
    answer == #yesToAll ifTrue:[
        YesToAllNotification queryWith:true.
        ^ true
    ].
    answer == #noToAll ifTrue:[
        YesToAllNotification queryWith:false.
        ^ false
    ].
    ^ answer

    "
     self checkAndWarnAboutBadMessagesInClass:(SourceCodeManagerUtilities)  
    "

    "Modified: / 28-02-2012 / 10:41:38 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil
    "ask for a log message for checking in a class (plus checkinQuick state info),
     and other info (mark as stable, for example).
     Return the info-object (actually: the dialog) or nil if aborted."

    ^ self
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswerOrNil
        withQuickOption:false

    "
     SourceCodeManagerUtilities getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 06-07-2010 / 11:22:15 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil withQuickOption:withQuickOption
    "ask for a log message for checking in a class (plus checkinQuick state info),
     and other info (mark as stable, for example).
     Return the info-object (actually: the dialog) or nil if aborted."

    ^  self 
        getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil 
        withQuickOption:withQuickOption
        withValidateConsistencyOption:false

    "
     SourceCodeManagerUtilities default getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 12-03-2012 / 13:12:40 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil withQuickOption:withQuickOption withValidateConsistencyOption:withValidateConsistencyOption
    "ask for a log message for checking in a class (plus checkinQuick state info),
     and other info (mark as stable, for example).
     Return the info-object (actually: the dialog) or nil if aborted."

    |logMsg infoDialog|

    infoDialog := Tools::CheckinInfoDialog 
                    getCheckinInfoFor:aClassNameOrPackageNameString 
                    initialAnswer:(initialAnswerOrNil ? LastSourceLogMessage)
                    withQuickOption:withQuickOption
                    logHistory:(LastSourceLogMessages ? #())
                    withValidateConsistencyOption:withValidateConsistencyOption.

    infoDialog notNil ifTrue:[
        logMsg := infoDialog logMessage.
        logMsg notEmptyOrNil ifTrue:[
            LastSourceLogMessage := logMsg.
            LastSourceLogMessages isNil ifTrue:[
                LastSourceLogMessages := OrderedCollection new.
            ].
            LastSourceLogMessages remove:logMsg ifAbsent:[].
            LastSourceLogMessages addFirst:logMsg.
            LastSourceLogMessages size > 10 ifTrue:[
                LastSourceLogMessages removeLast
            ].
        ].
    ].
    ^ infoDialog

    "
     SourceCodeManagerUtilities default getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 12-03-2012 / 13:12:40 / cg"
!

goodInitialLogMessageForCheckinClassOfClass:aClass
    "figure out, if there were any non-comment changes. 
     Provide a reasonable initial log message (I am tired of typing in 'comment only').
     This is a q&d hack - not complete and not correct (for example, it will generate a method change
     info line, even if the selector was removed afterwards).
     So check the outcome."

    |selectorsInChangeSet newSelectors modifiedSelectors
     className metaClassName classChanges changesForThisClass definitionChangesForThisClass methodChangesForThisClass 
     allMethodChangesForThisClass modifiedMethodsForThisClass newMethodsForThisClass removedMethodsForThisClass
     initialLogStream printSelectors selectorsWithCommentOrFormattingChangeOnly
     selectorsWithVariableChangeOnly newSelectorsRemoved
     removedSelectors categoryChanges categoryChangeSelectors additionalInfoPerChangedSelector|

    "/ a helper function
    printSelectors := 
        [:what :selectors :more |
            |sel moreInfo|

            selectors remove:nil ifAbsent:[].
            initialLogStream nextPutAll:(what,':').
            selectors size < 15 ifTrue:[
                selectors size == 1 ifTrue:[
                    sel := selectors first.
                    initialLogStream nextPutAll: ' #'; nextPutAll:sel.
                    more ifTrue:[
                        (moreInfo := additionalInfoPerChangedSelector at:sel ifAbsent:nil) notNil ifTrue:[
                            initialLogStream space; nextPutAll:moreInfo.
                        ]
                    ].
                    initialLogStream cr.
                ] ifFalse:[
                    initialLogStream cr.
                    selectors asSortedCollection do:[:sel | 
                        initialLogStream tab; nextPutAll:'#'; nextPutAll:sel. 
                        more ifTrue:[
                            (moreInfo := additionalInfoPerChangedSelector at:sel ifAbsent:nil) notNil ifTrue:[
                                initialLogStream space; nextPutAll:moreInfo.
                            ].
                        ].
                        initialLogStream cr
                    ].
                ].
            ] ifFalse:[
                initialLogStream 
                    print: (selectors size); nextPutAll: ' methods'; cr.
            ].
        ].

    classChanges := ChangeSet current select:[:aChange | aChange isClassChange].
    className := aClass theNonMetaclass name.
    metaClassName := aClass theMetaclass name.

    changesForThisClass := classChanges 
                                select:[:aChange | aChange className = className
                                                   or:[aChange className = metaClassName ]].

    additionalInfoPerChangedSelector := Dictionary new.
    definitionChangesForThisClass := changesForThisClass reject:[:aChange | aChange isMethodChange].
    categoryChanges := changesForThisClass select:[:aChange | aChange isMethodCategoryChange]. 
    categoryChangeSelectors := categoryChanges collect:[:aChange | aChange changeSelector] as:Set.
    allMethodChangesForThisClass := changesForThisClass select:[:aChange | aChange isMethodCodeChange].
    selectorsInChangeSet := allMethodChangesForThisClass collect:[:aChange | aChange changeSelector] as:Set.
    methodChangesForThisClass := selectorsInChangeSet collect:[:eachSelector |
                                        allMethodChangesForThisClass detectLast:[:change | change changeSelector = eachSelector]] as:OrderedCollection.
                                            
    modifiedMethodsForThisClass := methodChangesForThisClass 
                                select:[:aChange | aChange previousVersion notNil].
    modifiedSelectors := modifiedMethodsForThisClass collect:[:aChange | aChange changeSelector] as:Set.

    newMethodsForThisClass := allMethodChangesForThisClass 
                                select:[:aChange | aChange previousVersion isNil].
    newSelectors := newMethodsForThisClass collect:[:aChange | aChange changeSelector] as:Set.
    
    removedMethodsForThisClass := changesForThisClass 
                                select:[:aChange | aChange isMethodRemoveChange and:[ aChange changeMethod isNil ]].
    removedSelectors := removedMethodsForThisClass collect:[:aChange | aChange changeSelector] as:Set.

    "/ get rid of category changes for new and removed methods
    categoryChanges := categoryChanges reject:[:chg |
                            |methodWithChangedCat|

                            (methodWithChangedCat := chg changeMethod) isNil
                            or:[ newMethodsForThisClass contains:[:newChg | newChg changeMethod = methodWithChangedCat]]].

    initialLogStream := '' writeStream.
    initialLogStream nextPutLine:'class: ', aClass name.

    "/ definition?
    "/ suppress definition-message if initial checkin
    (aClass package isNil or:[aClass revision isNil]) ifFalse:[ 
        definitionChangesForThisClass notEmpty ifTrue:[
            "/ self halt.
            initialLogStream nextPutLine:'class definition'.
        ].
    ].

    "/ added selectors?
    newSelectorsRemoved := newSelectors select:[:sel | removedSelectors includes:sel].

    newSelectors removeAllFoundIn:removedSelectors.
    newSelectors notEmpty ifTrue:[
        printSelectors value:'added' value:newSelectors value:false.
    ].
    modifiedSelectors removeAllFoundIn:newSelectors.
    categoryChangeSelectors removeAllFoundIn:newSelectors.

    "/ removed selectors?
    removedSelectors removeAllFoundIn:newSelectorsRemoved.
    removedSelectors notEmpty ifTrue:[
        printSelectors value:'removed' value:removedSelectors value:false.
    ].
    modifiedSelectors removeAllFoundIn:removedSelectors.
    categoryChangeSelectors removeAllFoundIn:removedSelectors.

    "/ modifications?
    modifiedSelectors notEmpty ifTrue:[
        selectorsWithCommentOrFormattingChangeOnly := Set new.
        selectorsWithVariableChangeOnly := Set new.

        "/ check for format/comment change
        RBParser notNil ifTrue:[
            modifiedSelectors do:[:eachSelector |
                |oldest newest oldMethod newMethod oldTree newTree 
                 variableMapping selectorMapping unchangedVariables unchangedSelectors|

                (newSelectors includes:eachSelector) ifFalse:[
                    oldest := allMethodChangesForThisClass detect:[:change | change changeSelector = eachSelector].
                    newest := allMethodChangesForThisClass detectLast:[:change | change changeSelector = eachSelector].

                    oldest := oldest previousVersion notNil ifTrue:[oldest previousVersion] ifFalse:[oldest].

                    oldTree := RBParser parseMethod:oldest source onError:[:aString :pos | nil].
                    newTree := RBParser parseMethod:newest source onError:[:aString :pos | nil].

                    (oldTree notNil and:[newTree notNil]) ifTrue:[
                        variableMapping := Dictionary new.
                        (oldTree "semanticallyEqualTo:" equalTo:newTree withMapping: variableMapping) ifTrue:[
                            unchangedVariables := variableMapping keys select:[:k | (variableMapping at:k) = k].
                            variableMapping removeAllKeys:unchangedVariables.

                            (variableMapping at:'self' ifAbsent:'self') = 'self' ifTrue:[
                                ((variableMapping associations count:[:assoc | assoc key ~= assoc value]) == 0) ifTrue:[
                                    selectorsWithCommentOrFormattingChangeOnly add:eachSelector.
                                ] ifFalse:[
                                    "/ check, if a global has changed (aka sends to another global)
                                    ((variableMapping keys contains:[:var | var first isUppercase])
                                    or:[ (variableMapping values contains:[:var | var first isUppercase]) ]) ifFalse:[
                                        selectorsWithVariableChangeOnly add:eachSelector.
                                    ].
                                ].
                            ].
                        ] ifFalse:[
                            selectorMapping := Dictionary new.
                            (oldTree equalTo:newTree withSelectorMapping: selectorMapping) ifTrue:[
                                unchangedSelectors := selectorMapping keys select:[:k | (selectorMapping at:k) = k].
                                selectorMapping removeAllKeys:unchangedSelectors.
                                (selectorMapping notEmpty and:[selectorMapping size <= 2]) ifTrue:[
                                    additionalInfoPerChangedSelector at:eachSelector put:(
                                        String streamContents:[:s |
                                            |first|
                        
                                            s nextPutAll:'('.
                                            first := true.
                                            selectorMapping keysAndValuesDo:[:selOld :selNew | 
                                                first ifFalse:[s nextPutAll:', '].
                                                s print:('send #',selNew,' instead of #',selOld).
                                                first := false.
                                            ].
                                            s nextPutAll:')'.
                                        ]).
                                ]
                            ]
                        ].
                    ].
                ]
            ].
        ].

        modifiedSelectors removeAllFoundIn:selectorsWithCommentOrFormattingChangeOnly.
        modifiedSelectors removeAllFoundIn:selectorsWithVariableChangeOnly.

        (selectorsWithCommentOrFormattingChangeOnly notEmpty) ifTrue:[
            printSelectors value:'comment/format in' value:selectorsWithCommentOrFormattingChangeOnly value:false.
        ].
        (selectorsWithVariableChangeOnly notEmpty) ifTrue:[
            printSelectors value:'variable renamed in' value:selectorsWithVariableChangeOnly value:false.
        ].
        (modifiedSelectors notEmpty) ifTrue:[
            printSelectors value:'changed' value:modifiedSelectors value:true.
        ].
    ].
    categoryChanges notEmpty ifTrue:[
        printSelectors value:'category of' value:categoryChangeSelectors value:false.
    ].
    ^ initialLogStream contents

    "Modified: / 26-09-2012 / 18:31:38 / cg"
!

revisionForSymbolicName:tag class:cls fileName:classFileName directory:packageDir module:moduleDir manager:aSourceCodeManager
    "given a tag, return the corresponding revision"

    |partialLog symbolicNames|

    partialLog := aSourceCodeManager
        revisionLogOf:cls
        numberOfRevisions:20
        fileName:classFileName
        directory:packageDir 
        module:moduleDir.

    partialLog notNil ifTrue:[
        symbolicNames := partialLog at:#symbolicNames ifAbsent:[].
        symbolicNames notNil ifTrue:[
            ^ symbolicNames at:tag ifAbsent:nil
        ].
    ].
    ^ nil
! !

!SourceCodeManagerUtilities methodsFor:'utilities-encoding'!

guessEncodingOfFile:aFilename
    "look for a string
        encoding #name
     or:
        encoding: name
     within the given buffer 
     (which is usually the first few bytes of a textFile).
     If that's not found, use heuristics (in CharacterArray) to guess."

    <resource: #obsolete>

    self obsoleteMethodWarning:'ask CharacterEncoder'.
    ^ CharacterEncoder guessEncodingOfFile:aFilename

    "
     SourceCodeManagerUtilities guessEncodingOfFile:'../../libview2/resources/ApplicationModel_de.rs' asFilename
     SourceCodeManagerUtilities guessEncodingOfFile:'../../libview2/resources/ApplicationModel_ru.rs' asFilename
    "

    "Modified (comment): / 14-01-2012 / 20:54:35 / cg"
!

guessEncodingOfStream:aStream
    "look for a string of the form
            encoding #name
     or:
            encoding: name
     in the first few bytes of aStream."

    <resource: #obsolete>

    self obsoleteMethodWarning:'ask CharacterEncoder'.
    ^ CharacterEncoder guessEncodingOfStream:aStream
! !

!SourceCodeManagerUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

