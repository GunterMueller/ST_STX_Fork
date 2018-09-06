"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#PseudoCharacterTable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!


!PseudoCharacterTable methodsFor:'accessing'!

at: index 
	(index >= 1 and: [index <= 32]) ifTrue: [
	    index == 10 ifTrue: [^ 0].
	    index == 11 ifTrue: [^ 0].
	    index == 14 ifTrue: [^ 0].
	    ^ 1
	].
	(index >= 55297 and: [index <= 57344]) ifTrue: [^ 1].
	(index >= 65535 and: [index <= 65536]) ifTrue: [^ 1].
	(index <= 0 or: [index > 65536]) ifTrue: [
	    self error: 'subscript is out of bounds: ' , index printString.
	    ^ -1
	].
	^ 0
!

at: index put: value 
	^ self shouldNotImplement
! !

!PseudoCharacterTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/PseudoCharacterTable.st,v 1.2 2003-04-23 08:44:17 cg Exp $'
! !
