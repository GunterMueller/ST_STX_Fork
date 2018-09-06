"
 COPYRIGHT (c) 2002 by eXept Software AG
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

ClassChange subclass:#ClassCategoryChange
	instanceVariableNames:'category'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassCategoryChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    A changed class category
"
! !

!ClassCategoryChange methodsFor:'accessing'!

category
    ^ category
!

category:aCategory
    category := aCategory
!

className:clsName category:aCategoryString
    className := clsName.
    category := aCategoryString
! !

!ClassCategoryChange methodsFor:'comparing'!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    changeB isClassCategoryChange ifFalse:[^ false].   
    ^ className = changeB className
!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    changeB isClassCategoryChange ifFalse:[^ false].
    className = changeB className ifFalse:[^ false].
    ^ category = changeB category 
!

source
    "synthesize the changes source"

    ^ className , ' category: ' , category storeString
! !

!ClassCategoryChange methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream 
        nextPutAll:className; 
        nextPutAll:' category:';
        nextPutAll:(category storeString)
!

printWithoutClassNameOn:aStream
    (className endsWith:' class') ifTrue:[
        aStream nextPutAll:'class '
    ].
    aStream nextPutAll:'category:'.
    aStream nextPutAll:category storeString
! !

!ClassCategoryChange methodsFor:'testing'!

isClassCategoryChange
    ^ true
! !

!ClassCategoryChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitClassCategoryChange:self.

    "Created: / 25-11-2011 / 17:12:41 / cg"
! !

!ClassCategoryChange class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

