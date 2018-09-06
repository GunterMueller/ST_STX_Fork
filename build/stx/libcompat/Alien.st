"{ Package: 'stx:libcompat' }"

ExternalBytes subclass:#Alien
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!


!Alien class methodsFor:'instance creation'!

atAddress: pointer "<Integer>" "^<Alien>"
    "N.B.  This method assumes one is creating a pointer to already initialized data, 
     hence initiaize is not sent.
     (Perhaps some alternative, eg. initializePointer, should be sent?"

    ^ (self address:pointer size:self dataSize negated)

    "Created: / 15-09-2011 / 10:14:36 / cg"
!

dataSize "^<Integer>"
    "Answer the number of bytes required to represent an instance of the receiver.
    This excludes the size word's own bytes and is just the size of the data."

    ^self subclassResponsibility

    "Created: / 15-09-2011 / 10:14:50 / cg"
! !

!Alien class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Alien.st,v 1.1 2011-09-15 13:03:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Alien.st,v 1.1 2011-09-15 13:03:42 cg Exp $'
! !
