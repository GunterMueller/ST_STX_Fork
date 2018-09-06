"{ Package: 'stx:goodies/monticello' }"

Notification subclass:#MCVersionNameAndMessageRequest
	instanceVariableNames:'suggestion'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCVersionNameAndMessageRequest methodsFor:'as yet unclassified'!

defaultAction
	^ MCSaveVersionDialog new
		versionName: suggestion;
		showModally
!

suggestedName
	^ suggestion
!

suggestedName: aString
	suggestion _ aString
! !

!MCVersionNameAndMessageRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionNameAndMessageRequest.st,v 1.2 2012-09-11 21:15:35 cg Exp $'
! !
