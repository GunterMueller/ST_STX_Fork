"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MARangeComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MARangeComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MARangeComponent methodsFor:'accessing'!

labelId
	^ self id
!

value
	^ ((super value ifNil: [ 0 ]) - self min) * 100 / self range
!

value: aNumber
	super value: (aNumber ifNotNil: [ aNumber * self range / 100 + self min ])
! !

!MARangeComponent methodsFor:'accessing-dynamic'!

max
	^ self description max ifNil: [ 100 ]
!

min
	^ self description min ifNil: [ -100 ]
!

range
	^ self max - self min
! !

!MARangeComponent methodsFor:'private'!

updateScript
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'document.getElementById('; print: self id , 'v';
			nextPutAll: ').innerHTML = document.getElementById('; print: self id;
			nextPutAll: ').value * ('; print: self range;
			nextPutAll: ') / 100 + ('; print: self min;
			nextPutAll: ');' ]
! !

!MARangeComponent methodsFor:'rendering'!

renderEditorOn: html
	html rangeInput
		id: self id;
		onInput: self updateScript;
		min: 0; "default"
		max: 100; "default"
		on: #string of: self.
	html span id: self id , 'v'.
	html script: self updateScript
! !

!MARangeComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MARangeComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MARangeComponent.st,v 1.2 2009-08-14 20:26:08 cg Exp $'
! !
