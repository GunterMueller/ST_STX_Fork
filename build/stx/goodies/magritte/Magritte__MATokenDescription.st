"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAReferenceDescription subclass:#MATokenDescription
	instanceVariableNames:'separators'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MATokenDescription comment:'I am a description of tokens all described by the referenced description, possible values are instances of ==SequenceableCollection==.'
!



!MATokenDescription class methodsFor:'accessing'!

label
	^ 'Token'
! !

!MATokenDescription class methodsFor:'accessing-defaults'!

defaultSeparators
	^ ' ,;' , String crlf , String tab
! !

!MATokenDescription class methodsFor:'accessing-description'!

descriptionSeparators
	^ MAStringDescription new
		accessor: #separators;
		label: 'Separators';
		priority: 250;
		yourself
! !

!MATokenDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATokenDescription methodsFor:'accessing'!

separators
	^ separators ifNil: [ separators := self class defaultSeparators ]
!

separators: aString
	"A string with the separator characters to split tokens, the first character is used as a default for printing."

	separators := aString
! !

!MATokenDescription methodsFor:'accessing-dynamic'!

kind
	^ Array
! !

!MATokenDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitTokenDescription: self
! !

!MATokenDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MATokenDescription.st,v 1.2 2009-08-14 20:08:10 cg Exp $'
! !
