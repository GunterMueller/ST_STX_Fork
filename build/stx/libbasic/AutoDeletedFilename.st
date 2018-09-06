"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Filename subclass:#AutoDeletedFilename
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	category:'System-Support'
!

!AutoDeletedFilename class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    Used with temporary files - these will automatically delete themself,
    when no longer referenced (i.e. when finalized)
    
    See -> Filename asAutoDeletedFilename

    [author:]
        cg - original code
        sv - fixed and enhanced
"
!

examples
"
    the following file will be automatically deleted after some time:
                                                    [exBegin]
    |f p|

    f := AutoDeletedFilename newTemporary.
    f writeStream
        nextPutLine:'hello';
        close.
    p := f pathName.
    Transcript showCR:p.
    f := f asAutoDeletedFilename.
    self assert:(p asFilename exists).
    ObjectMemory collectGarbage.
    Delay waitForSeconds:2.
    self assert:(p asFilename exists).
    f := nil.
    ObjectMemory collectGarbage.
    Delay waitForSeconds:2.
    self assert:(p asFilename exists not).
                                                    [exEnd]


    you can also delete it manually:
                                                    [exBegin]
    |f p|

    f := Filename newTemporary.
    f writeStream
        nextPutLine:'hello';
        close.
    p := f pathName.
    Transcript showCR:p.
    f := f asAutoDeletedFilename.
    self assert:(p asFilename exists).
    ObjectMemory collectGarbage.
    Delay waitForSeconds:2.
    self assert:(p asFilename exists).
    f remove.
    f := nil.
    ObjectMemory collectGarbage.
    Delay waitForSeconds:2.
    self assert:(p asFilename exists not).
                                                    [exEnd]
"
! !

!AutoDeletedFilename class methodsFor:'initialization'!

initialize
    Lobby isNil ifTrue:[
        Lobby := Registry new.
    ].
    Smalltalk addDependent:self.    "inform me when smalltalk exits"
! !

!AutoDeletedFilename class methodsFor:'change and update'!

update:anAspect with:aParameter from:changedObject
    "when Smalltalk exits, remove all auto deleted files"

    anAspect == #aboutToQuit ifTrue:[
        |currentFilename|
        "do it with timeout in case of a non-responding remote file server"
        ([
            Lobby do:[:each|
                currentFilename := each.
                each basicFinalize
            ].
        ] valueWithTimeout:1 minutes) isNil ifTrue:[
            'AutoDeletedFilename: timed out while removing: ' errorPrint. currentFilename errorPrintCR.
        ].
    ].
    super update:anAspect with:aParameter from:changedObject
! !

!AutoDeletedFilename methodsFor:'accessing'!

keep
    "do not delete the file on finalization"

    self unregisterForFinalization
!

setName:aString
    super setName:aString.
    self registerForFinalization    
! !

!AutoDeletedFilename methodsFor:'copying'!

shallowCopy
    "when copying, return a real filename
     (to avoid mutiple removals)"

    ^ self species named:nameString

    "
        'blaFaselQall.mist' asFilename asAutoDeletedFilename copy
    "
! !

!AutoDeletedFilename methodsFor:'finalization'!

basicFinalize
    |linkInfo|

    linkInfo := self linkInfo.
    linkInfo notNil ifTrue:[
        linkInfo isDirectory ifTrue:[
            super recursiveRemove
        ] ifFalse:[
            super removeFile.
        ].
    ].
!

executor
    ^ self class basicNew nameString:nameString
!

finalizationLobby
    "answer the registry used for finalization.
     we have our own Lobby."

    ^ Lobby
!

finalize
    "/ do this in a forked process to avoid blocking
    "/ in case of an autodeleted remote file of a broken connection
    [
        "/ with timeout to avoid waiting forever
        [
            self basicFinalize.
        ] valueWithTimeout:1 minutes.
    ] fork.
! !

!AutoDeletedFilename methodsFor:'queries'!

species
    "filenames derived from me should not be autodeleted themself"

    ^ Filename concreteClass.
! !

!AutoDeletedFilename methodsFor:'removing'!

recursiveRemove
    super recursiveRemove.
    self unregisterForFinalization
!

remove
    super remove.
    self unregisterForFinalization
!

removeDirectory
    super removeDirectory.
    self unregisterForFinalization
!

removeFile
    super removeFile.
    self unregisterForFinalization
! !

!AutoDeletedFilename class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


AutoDeletedFilename initialize!
