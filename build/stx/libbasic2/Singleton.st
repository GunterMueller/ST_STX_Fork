"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#Singleton
	instanceVariableNames:''
	classVariableNames:'Lock'
	poolDictionaries:''
	category:'System-Support'
!

Singleton class instanceVariableNames:'theOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!Singleton class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Subclasses of Singleton have only a single instance.
    The instance creation methods ensure that there is only one instance.

    Singletons that would have inherited from Object could inherit from
    Singleton. For Singletons that do not inherit from Object, 
    you have to copy the Singleton's code to your class.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [class instance variables:]
        theOnlyInstance     Object          The only instance of this class

    [class variables:]
        Lock                RecursionLock   A global lock to protect agains races during instance creation
"
! !

!Singleton class methodsFor:'initialization'!

initialize
    Lock := RecursionLock new name:#Singleton
! !

!Singleton class methodsFor:'instance creation'!

basicNew
    "allocate a singleton in a thread-safe way.
     Do lazy locking here"
    
    theOnlyInstance isNil ifTrue:[
        Lock critical:[
            theOnlyInstance isNil ifTrue:[
                theOnlyInstance := super basicNew.
            ].
        ]
    ].
    ^ theOnlyInstance.
!

basicNew:anInteger
    "allocate a singleton in a thread-safe way.
     Do lazy locking here"
    
    theOnlyInstance isNil ifTrue:[
        Lock critical:[
            theOnlyInstance isNil ifTrue:[
                theOnlyInstance := super basicNew:anInteger.
            ].
        ]
    ].
    ^ theOnlyInstance.
! !

!Singleton class methodsFor:'accessing'!

singletonLock
    "can be used by other classes that are not subclasses of Singleton"

    ^ Lock
!

theOnlyInstance
    ^ theOnlyInstance
! !

!Singleton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Singleton.st,v 1.3 2008-01-22 22:31:57 cg Exp $'
! !

Singleton initialize!
