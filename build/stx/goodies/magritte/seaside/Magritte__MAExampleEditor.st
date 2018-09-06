"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

WAComponent subclass:#MAExampleEditor
	instanceVariableNames:'description report'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Examples'
!


!MAExampleEditor class methodsFor:'instance-creation'!

description: aDescription
	^ self new
		description: aDescription;
		yourself
! !

!MAExampleEditor methodsFor:'accessing'!

children
	^ Array with: self report
!

description
	^ description ifNil: [ description := self defaultDescription ]
!

description: aDescription
	description := aDescription
!

report
	^ report ifNil: [ report := self buildReport ]
! !

!MAExampleEditor methodsFor:'accessing-configuration'!

defaultDescription
	self subclassResponsibility
! !

!MAExampleEditor methodsFor:'actions'!

cancel
	self answer: nil
!

edit
	self call: (self
		buildEditorFor: description
		titled: 'Edit Container')
!

preview
	self subclassResponsibility
!

refresh
	self report rows: self description children
!

save
	self answer: self description
! !

!MAExampleEditor methodsFor:'actions-items'!

moveDown: aDescription
	self description moveDown: aDescription.
	self refresh
!

moveUp: aDescription
	self description moveUp: aDescription.
	self refresh
! !

!MAExampleEditor methodsFor:'private'!

buildEditorFor: anObject titled: aString
	^ anObject asComponent
		addValidatedForm;
		addMessage: aString;
		yourself
!

buildReport
	self subclassResponsibility
! !

!MAExampleEditor methodsFor:'rendering'!

renderButtonsOn: html
	html submitButton on: #edit of: self.
	html submitButton on: #preview of: self
!

renderChildrenOn: html
	html render: self children
!

renderContentOn: html
	html form: [
		self renderChildrenOn: html. "One of the children supplies input for the form"
		self renderButtonsOn: html ]
! !

!MAExampleEditor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAExampleEditor.st,v 1.2 2009-08-14 20:29:29 cg Exp $'
! !
