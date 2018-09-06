"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponentDecoration subclass:#MAValidationDecoration
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Decorations'
!

MAValidationDecoration comment:'I am a normally invisible component. I show a list of validation errors in case the owner component fails to validate.'
!


!MAValidationDecoration methodsFor:'accessing'!

errors
	^ self component errors
! !

!MAValidationDecoration methodsFor:'rendering'!

renderContentOn: html
	self errors isEmpty
		ifFalse: [ self renderErrorsOn: html ].
	self renderOwnerOn: html
!

renderErrorsOn: html
	html unorderedList
		class: 'errors';
		list: self errors;
		with: nil
! !

!MAValidationDecoration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAValidationDecoration.st,v 1.2 2009-08-14 20:28:41 cg Exp $'
! !
