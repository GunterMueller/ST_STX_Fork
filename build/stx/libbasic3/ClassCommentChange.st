"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

ClassChange subclass:#ClassCommentChange
	instanceVariableNames:'comment'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassCommentChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    instances represent class comment-changes. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!ClassCommentChange methodsFor:'accessing'!

className:clsName comment:aCommentString
    className := clsName.
    comment := aCommentString

    "Created: / 16.2.1998 / 14:16:45 / cg"
!

comment
    ^ comment
!

comment:aCommentString
    comment := aCommentString

    "Created: / 16.2.1998 / 14:16:45 / cg"
! !

!ClassCommentChange methodsFor:'comparing'!

isConflict
    "true if this change is different than what is already in the image
     (i.e. it overwrites some existing code)"

    |cls|

    ^ (cls := self changeClass) notNil
    and:[ cls comment ~= self comment ]
!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    changeB isClassCommentChange ifFalse:[^ false].   
    ^ className = changeB className


!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    (self isForSameAs:changeB) ifFalse:[^ false].
    ^ comment = changeB comment

    "Modified: / 06-10-2006 / 14:06:02 / cg"
!

source
    "synthesize the changes source"

    ^ String streamContents: [:s |
            self printOn:s.
            comment storeOn:s.
        ]
! !

!ClassCommentChange methodsFor:'converting'!

asAntiChange

    ^self copy comment:''

    "Created: / 26-11-2009 / 16:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassCommentChange methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

"/    |ns|
"/
"/    ns := self nameSpaceName.
"/    ns notNil ifTrue:[
"/        aStream nextPutAll:ns; nextPutAll:'::'
"/    ].
    aStream 
        nextPutAll:self className; 
        nextPutAll:' comment:'
!

printWithoutClassNameOn:aStream
    (className endsWith:' class') ifTrue:[
        aStream nextPutAll:'class '
    ].
    aStream nextPutAll:'comment:'
! !

!ClassCommentChange methodsFor:'testing'!

isClassCommentChange
    ^ true


! !

!ClassCommentChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitClassCommentChange:self.

    "Created: / 25-11-2011 / 17:13:02 / cg"
! !

!ClassCommentChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

