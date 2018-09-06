"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAStringDescription subclass:#MAMemoDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAMemoDescription comment:'I am a description of multiline strings, possible values are instances of ==String==. My visual representation could be a text-area field.'
!




!MAMemoDescription class methodsFor:'accessing'!

label
	^ 'Memo'
! !

!MAMemoDescription class methodsFor:'accessing-defaults'!

defaultLineCount
	^ 3
! !

!MAMemoDescription class methodsFor:'accessing-description'!

descriptionLineCount
	^ MANumberDescription new
		accessor: #lineCount;
		label: 'Number of Lines';
		priority: 400;
		default: self defaultLineCount;
		beInteger;
		min: 1;
		yourself
! !

!MAMemoDescription methodsFor:'accessing-properties'!

lineCount
	^ self propertyAt: #lineCount ifAbsent: [ self class defaultLineCount ]
!

lineCount: anInteger
	self propertyAt: #lineCount put: anInteger
! !

!MAMemoDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitMemoDescription: self
! !

!MAMemoDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMemoDescription.st,v 1.4 2009-08-14 20:08:49 cg Exp $'
! !
