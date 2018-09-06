"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPProgressDev subclass:#SptHTTPTestProgress
	instanceVariableNames:'sentMessages'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPTestProgress methodsFor:'public'!

doesNotUnderstand: aMessage
	sentMessages add: aMessage
!

initialize
	super initialize.
	sentMessages := OrderedCollection new
!

sentMessages
	^sentMessages
! !

!SptHTTPTestProgress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTestProgress.st,v 1.1 2011-09-23 13:41:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTestProgress.st,v 1.1 2011-09-23 13:41:56 cg Exp $'
! !
