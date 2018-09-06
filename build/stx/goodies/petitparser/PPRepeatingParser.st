"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPRepeatingParser
	instanceVariableNames:'min max'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPRepeatingParser class methodsFor:'instance creation'!

on: aParser
	^ (super on: aParser) setMin: 0 max: SmallInteger maxVal
!

on: aParser max: aMaxInteger
	^ (self on: aParser) setMin: 0 max: aMaxInteger
!

on: aParser min: aMinInteger
	^ (self on: aParser) setMin: aMinInteger max: SmallInteger maxVal 
!

on: aParser min: aMinInteger max: aMaxInteger
	^ (self on: aParser) setMin: aMinInteger max: aMaxInteger
! !





!PPRepeatingParser methodsFor:'accessing'!

max
	"Answer the maximum number of repetitions."

	^ max
!

min
	"Answer the minimum number of repetitions."
	
	^ min
! !

!PPRepeatingParser methodsFor:'initialization'!

initialize
	super initialize.
	self setMin: 0; setMax: SmallInteger maxVal
!

setMax: anInteger
	max := anInteger
!

setMin: anInteger
	min := anInteger
!

setMin: aMinInteger max: aMaxInteger
	min := aMinInteger.
	max := aMaxInteger
! !

!PPRepeatingParser methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' ['; print: min; nextPutAll: ', '; nextPutAll: (max = SmallInteger maxVal
		ifTrue: [ '*' ] ifFalse: [ max printString ]); nextPut: $]
! !

!PPRepeatingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPRepeatingParser.st,v 1.4 2014-03-04 14:33:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPRepeatingParser.st,v 1.4 2014-03-04 14:33:24 cg Exp $'
!

version_SVN
    ^ '$Id: PPRepeatingParser.st,v 1.4 2014-03-04 14:33:24 cg Exp $'
! !

