"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCTool subclass:#MCSaveVersionDialog
	instanceVariableNames:'name message'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCSaveVersionDialog methodsFor:'as yet unclassified'!

accept
	self answer:
		(Array
			with: (self findTextMorph: #versionName) text asString
			with: (self findTextMorph: #logMessage) text asString)
	
!

buttonSpecs
	^ #((Accept accept 'accept version name and log message')
		(Cancel cancel 'cancel saving version')
		) 
!

cancel
	self answer: nil
!

defaultExtent 
	^ 400@300
!

defaultLabel
	^ 'Edit Version Name and Message:'
!

logMessage
	^ message ifNil: ['empty log message']
!

logMessage: aString
	message _ aString.
	self changed: #logMessage
!

versionName
	^ name
!

versionName: aString
	name _ aString.
	self changed: #versionName
!

widgetSpecs
	^ #(	
		((textMorph: versionName) (0 0 1 0) (0 0 0 30))
		((textMorph: logMessage) (0 0 1 1) (0 30 0 -30))
		((buttonRow) (0 1 1 1) (0 -30 0 0))
		)
! !

!MCSaveVersionDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSaveVersionDialog.st,v 1.2 2012-09-11 21:14:47 cg Exp $'
! !

