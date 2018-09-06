"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#SWEnvironment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!SWEnvironment class methodsFor:'accessing'!

spIconNamed: aString
	^self swIconNamed: aString

!

spImageNamed: aString
	^self xeImageNamed: aString

!

splashCHMTopic: aString
	self sprayCHMTopic: aString

!

sprayCHMTopic: aString
	HTMLHelpLibrary default htmlHelpUrl:  (self localFileSpecFor: self sprayDocPath , 'SprayB2.chm') , '::' , aString
	


!

xeIconNamed: aString
	^self swIconNamed: aString

! !

!SWEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SWEnvironment.st,v 1.1 2002-11-18 20:15:00 cg Exp $'
! !
