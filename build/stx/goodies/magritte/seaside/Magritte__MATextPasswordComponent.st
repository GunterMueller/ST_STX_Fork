"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MATextPasswordComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MATextPasswordComponent comment:'Password seaside component, I display stars ''*'' instead of the text typed by the user. My description is MAPasswordDescription.'
!


!MATextPasswordComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATextPasswordComponent methodsFor:'accessing'!

string
	^ self description obfuscated: super string
!

string: aString
	(self description isObfuscated: aString)
		ifFalse: [ super string: aString ]
! !

!MATextPasswordComponent methodsFor:'rendering'!

renderEditorOn: html
	html passwordInput
		id: self labelId;
		on: #string of: self
! !

!MATextPasswordComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MATextPasswordComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATextPasswordComponent.st,v 1.2 2009-08-14 20:26:49 cg Exp $'
! !
