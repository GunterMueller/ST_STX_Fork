"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MAUndefinedComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAUndefinedComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAUndefinedComponent methodsFor:'rendering'!

renderContentOn: html
	html span
		id: self labelId;
		style: 'color: red;';
		with: 'Undefined Component'
! !

!MAUndefinedComponent methodsFor:'testing'!

hasLabelId
	^ true
! !

!MAUndefinedComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAUndefinedComponent.st,v 1.2 2009-08-14 20:27:12 cg Exp $'
! !
