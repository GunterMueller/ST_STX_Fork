"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractRevisionItem subclass:#SourceRevisionItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!SourceRevisionItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    This is not yet finished (work in progress) - do not use.

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"

! !

!SourceRevisionItem methodsFor:'accessing'!

sourceStream
"
<return: ReadStream>
"                     
    ^self parent myClass currentSourceStream readStream
! !

!SourceRevisionItem methodsFor:'protocol'!

icon

    ^#loadedRevision

!

revisionString
    "return the value of the instance variable 'revision' (automatically generated)"

    ^ revision isNil
        ifTrue: ['no revision']
        ifFalse:['current (based on:',(revision at:#revision),')']

! !

!SourceRevisionItem methodsFor:'testing'!

basedOnActualRevision
"
returns if the changes of the class are based on the actual revision of the class

<return: Boolean>
"
     revision ifNil:[^true].
     ^parent newestRevision = (revision at:#revision)
!

hasSourceStream
"
has the receiver a source stream? Used for testing tree items.

<return: Boolean>
"
    ^true


!

isLoadedRevision
"
the receiver is always the actual revision of a class, hence isloadedRevision
must be true.

<return: Boolean>
"

    ^true


!

isSourceRevisionItem
"
Used for testing tree items. The receiver is a source revision item.

<return: Boolean>
"

    ^true

! !

!SourceRevisionItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/SourceRevisionItem.st,v 1.6 2000/02/18 14:08:16 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

