"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MATextInputComponent subclass:#MADateInputComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MADateInputComponent methodsFor:'actions'!

choose
	| calendar |
	calendar := WAMiniCalendar new.
	calendar
		date: ((self value notNil
			and: [ self description isSatisfiedBy: self value ])
				ifFalse: [ Date current ]
				ifTrue: [ self value ]);
		selectBlock: [ :value | calendar answer: value ];
		canSelectBlock: [ :value | self description isSatisfiedBy: value ].
	self chooser: calendar
!

today
	| calendar |
	calendar := WAMiniCalendar new.
	calendar
		date: ((self value notNil
			and: [ self description isSatisfiedBy: self value ])
				ifFalse: [ Date current ]
				ifTrue: [ self value ]);
		selectBlock: [ :value | calendar answer: value ];
		canSelectBlock: [ :value | self description isSatisfiedBy: value ].
	self chooser: calendar
! !

!MADateInputComponent methodsFor:'rendering'!

renderButtonOn: html
	html submitButton on: #choose of: self
! !

!MADateInputComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADateInputComponent.st,v 1.2 2009-08-14 20:25:56 cg Exp $'
! !
