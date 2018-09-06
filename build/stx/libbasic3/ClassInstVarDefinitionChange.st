"
 COPYRIGHT (c) 1999 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

ClassChange subclass:#ClassInstVarDefinitionChange
	instanceVariableNames:'classInstVarNames'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassInstVarDefinitionChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

! !

!ClassInstVarDefinitionChange methodsFor:'accessing'!

classInstVarNames
    ^ classInstVarNames
!

classInstVarNames:something
    classInstVarNames := something.
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"
    | class |

    class := self changeClass.
    class isNil ifTrue:[^ ChangeDeltaInformation added ].
    class isLoaded ifFalse:[^ ChangeDeltaInformation different ].
    class instanceVariableNames = classInstVarNames ifTrue:[ ^ ChangeDeltaInformation identical ].
    ^ ChangeDeltaInformation different

    "Created: / 25-04-2015 / 22:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInstVarDefinitionChange methodsFor:'comparing'!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    changeB isClassInstVarDefinitionChange ifFalse:[^ false].   

    ^ className = changeB className

!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    (self isForSameAs:changeB) ifFalse:[^ false].
    ^ self sameSourceAs:changeB


! !

!ClassInstVarDefinitionChange methodsFor:'printing & storing'!

printOn:aStream
    "/ aStream nextPutAll:className; nextPutAll:' instanceVariableNames:'
    aStream nextPutAll:source string


! !

!ClassInstVarDefinitionChange methodsFor:'testing'!

isClassInstVarDefinitionChange
    ^ true


! !

!ClassInstVarDefinitionChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitClassInstVarDefinitionChange:self.

    "Created: / 25-11-2011 / 17:13:30 / cg"
! !

!ClassInstVarDefinitionChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassInstVarDefinitionChange.st,v 1.10 2014-12-29 20:35:51 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

