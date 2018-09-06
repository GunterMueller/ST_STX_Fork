"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

ClassPrimitiveChange subclass:#ClassPrimitiveDefinitionsChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassPrimitiveDefinitionsChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    instances represent a classes primitive definition-changes. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!ClassPrimitiveDefinitionsChange methodsFor:'applying'!

privateApply
    "apply the change"

    self changeClass primitiveDefinitions:(self source)

    "Created: / 28-06-2011 / 22:59:17 / cg"
! !

!ClassPrimitiveDefinitionsChange methodsFor:'comparing'!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    changeB isPrimitiveDefinitionsChange ifFalse:[^ false].   

    ^ className = changeB className


! !

!ClassPrimitiveDefinitionsChange methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:className; nextPutAll:' primitiveDefinitions:'
! !

!ClassPrimitiveDefinitionsChange methodsFor:'testing'!

isPrimitiveDefinitionsChange
    ^ true


! !

!ClassPrimitiveDefinitionsChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassPrimitiveDefinitionsChange.st,v 1.12 2014-02-19 13:05:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassPrimitiveDefinitionsChange.st,v 1.12 2014-02-19 13:05:29 cg Exp $'
! !

