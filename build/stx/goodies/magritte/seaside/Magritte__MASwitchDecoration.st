"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAContainerDecoration subclass:#MASwitchDecoration
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Decorations'
!

MASwitchDecoration comment:'I turn the owning component read-only and add an edit button. Clicking that button allows one to toggle between view and edit-mode.'
!


!MASwitchDecoration methodsFor:'accessing'!

buttons
	^ self component isReadonly
		ifTrue: [ Array with: #edit -> 'Edit' ]
		ifFalse: [ Array with: #save -> 'Save' with: #cancel -> 'Cancel' ]
! !

!MASwitchDecoration methodsFor:'processing'!

handleAnswer: anObject continueWith: aBlock
	self component readonly: true.
	super handleAnswer: anObject continueWith: aBlock
! !

!MASwitchDecoration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MASwitchDecoration.st,v 1.2 2009-08-14 20:28:35 cg Exp $'
! !
