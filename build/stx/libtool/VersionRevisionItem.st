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

AbstractRevisionItem subclass:#VersionRevisionItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!VersionRevisionItem class methodsFor:'documentation'!

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

!VersionRevisionItem methodsFor:'accessing'!

revisionString
    "return the value of the instance variable 'revision' (automatically generated)"

    ^ revision at:#revision



!

sourceStream
"
<return: Stream>
"
    |theClass|

    theClass := self parent myClass.
    ^theClass sourceCodeManager getSourceStreamFor:theClass revision:self revisionString
! !

!VersionRevisionItem methodsFor:'protocol'!

icon

    ^self isLoadedRevision
        ifTrue: [#loadedRevision]
        ifFalse:[#unloadedRevision].


! !

!VersionRevisionItem methodsFor:'testing'!

hasSourceStream
"
has the receiver a source stream? Used for testing tree items.

<return: Boolean>
"
    ^true



!

isLoadedRevision
"
the receiver represents the actual revision of a class, when the revision string fits
and the class is not changed. In that case a current version of the class exisits.

<return: Boolean>
"
    ^((self parent myClass revision = self revisionString) and:[self parent isMyClassChanged not])


! !

!VersionRevisionItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/VersionRevisionItem.st,v 1.6 2000/02/18 14:08:03 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

