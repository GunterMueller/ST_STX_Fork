"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSNilValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSNilValue class methodsFor:'As yet unclassified'!

Comment



	^'Instances of this class replace nil values when creating indexes.'
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSNilValue methodsFor:'As yet unclassified'!

< anObject



	^(self >= anObject) not
!

<= anObject



	^true
!

= anObject

        

	^self class == anObject class
!

> anObject



    ^(self <= anObject) not
!

>= anObject



    ^self = anObject
!

compareGreaterThan: anInteger
	"Needed by VisualAge Smalltalk only (as far as I know)."

	^false.
!

greaterThanInteger: anInteger

	"Needed by Dolphin, but kept in MinneStore package because of cyclical prerequisites."



	^false.
!

isMSNilValue



	^true
!

lessFromInteger: aInteger
	"Needed by VW 
	GG PATCH
	Is less? Oh yes I hope but is right?....."
	^false
! !

!MSNilValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSNilValue.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
