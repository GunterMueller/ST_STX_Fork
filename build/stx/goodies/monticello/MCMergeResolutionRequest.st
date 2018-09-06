"{ Package: 'stx:goodies/monticello' }"

Notification subclass:#MCMergeResolutionRequest
	instanceVariableNames:'merger'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCMergeResolutionRequest methodsFor:'as yet unclassified'!

defaultAction
	^ (MCMergeBrowser new
		merger: merger;
		label: messageText) showModally
!

merger
	^ merger
!

merger: aMerger
	merger _ aMerger
! !

!MCMergeResolutionRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMergeResolutionRequest.st,v 1.2 2012-09-11 21:12:59 cg Exp $'
! !
