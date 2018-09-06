"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

OtherChange subclass:#InfoChange
	instanceVariableNames:'data'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!InfoChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    InfoChanges represent individual 'info records' written
    in system changefile, such as 'snapshot was written'
    'class/package was checked in' etc.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !


!InfoChange class methodsFor:'instance creation'!

type: type data: data timestamp: timestamp

    ^self new
        type: type;
        data: data; 
        timeStamp: timestamp

    "Created: / 18-05-2012 / 16:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!InfoChange methodsFor:'accessing'!

data
    ^ data
!

data:something
    data := something.
! !


!InfoChange methodsFor:'applying'!

apply
    "Intentionally left blank"

    "Created: / 18-05-2012 / 17:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!InfoChange methodsFor:'printing & storing'!

printOn:aStream

    type = 'snapshot' ifTrue:[
        aStream nextPutAll:'---- snapshot '; space; nextPutAll: data.
        timeOfChangeIfKnown notNil ifTrue:[ timeOfChangeIfKnown printOn: aStream ].
        aStream nextPutAll:' ---- '.
        ^self
    ].
    type = 'start' ifTrue:[
        aStream nextPutAll:'System start'.
        ^self
    ].
    type = 'rake' ifTrue:[
        aStream nextPutAll:'rake'; space; nextPutAll: data.
        ^self
    ].

    "/ default
    aStream nextPutAll:'---- '; nextPutAll:type; space; nextPutAll: data.

    "Created: / 18-05-2012 / 17:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!InfoChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/InfoChange.st,v 1.2 2013-04-02 19:20:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/InfoChange.st,v 1.2 2013-04-02 19:20:25 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id:: InfoChange.st 1942 2012-07-27 14:53:23Z vranyj1                                                                        §'
! !

