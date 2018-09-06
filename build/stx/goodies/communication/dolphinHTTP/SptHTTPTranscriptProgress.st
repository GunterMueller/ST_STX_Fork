"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPProgressDev subclass:#SptHTTPTranscriptProgress
	instanceVariableNames:'stream nextProgress'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPTranscriptProgress methodsFor:'public'!

doesNotUnderstand: aMessage
	|c|
	stream
		nextPutAll: 'SptHTTPTranscriptProgress: ' , request hash asString "displayString" , ' '
					, ((c := request connection)
							isNil ifTrue: ['nil']
							ifFalse: [c socket asString "displayString" , c socket hash asString "displayString"])
						, ' ' , aMessage selector printString
					, ' ' , aMessage arguments printString;
		cr.
	nextProgress notNil ifTrue: [aMessage forwardTo: nextProgress]

    "Modified: / 23-09-2011 / 22:17:00 / cg"
!

initialize
	super initialize.
	stream := Transcript
!

nextProgress: anObject
	nextProgress := anObject
!

stream: anObject
	stream := anObject
! !

!SptHTTPTranscriptProgress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTranscriptProgress.st,v 1.3 2011-10-04 12:13:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTranscriptProgress.st,v 1.3 2011-10-04 12:13:01 cg Exp $'
! !
