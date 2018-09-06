Object subclass:#StrikeFont
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!


!StrikeFont class methodsFor:'instance creation'!

familyName:familyName size:size
    "/ mimicri

    ^ View defaultFont onDevice:Screen current
    "/ ^ (Font family:'Courier' size:size) onDevice:Screen current
! !

!StrikeFont class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_StrikeFont.st,v 1.1 1999-11-13 11:17:21 cg Exp $'
! !
