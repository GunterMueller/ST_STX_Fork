"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#MSReadProxy
	instanceVariableNames:'objectSet realObject'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSReadProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSReadProxy methodsFor:'As yet unclassified'!

basicRealObject



	^realObject
!

class



	^self realObject class
!

doesNotUnderstand: aMessage

	"Read in and become my real object.  Reimplemented by my subclasses."



	^self realObject

		perform: aMessage selector

		withArguments: aMessage arguments.
!

getRealObject

	"This is common code used my subimplementers."



	realObject == nil

		ifTrue: [realObject := #error].
!

inspect



	self realObject inspect.
!

isMSProxy

	"Answer true."



	^true
!

isMSReadProxy

	"Answer true"



	^true
!

objectSet



	^objectSet
!

objectSet: anMSObjectSet



	objectSet := anMSObjectSet
!

printString



	^'a MSReadProxy{', self basicRealObject printString, '}'
!

realObject



	realObject == #error

		ifTrue: [^#ThereWasAProblemInstantiatingThisObject].

	self realObjectIsInstantiated

		ifFalse: [self getRealObject].

	^realObject
!

realObjectIsInstantiated



	^realObject ~~ nil
!

vmInterrupt: aSymbol

	"Private - Process virtual machine interrupt.  This method is called

	by the virtual machine.  It is entered with interrupts disabled.  The

	interrupt handler should enable interrupts at the appropriate time."

	"This method needed for Visual Smalltalk"



    Process perform: aSymbol.

    ^self
!

vmInterrupt: anInteger with: anObject

	"See comment on Object instance method.

	This method needed by Dolphin."



	Processor vmInterrupt: anInteger with: anObject.

	^self.  
! !

!MSReadProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSReadProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
