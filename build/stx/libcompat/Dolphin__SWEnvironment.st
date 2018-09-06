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
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SWEnvironment.st,v 1.2 2011-10-01 11:10:49 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__SWEnvironment.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
