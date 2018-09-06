"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#UIManager
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

UIManager class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!UIManager class methodsFor:'documentation'!

documentation
"
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.

"
! !

!UIManager class methodsFor:'instance creation'!

default
    ^ self theOneAndOnlyInstance.

    "Created: / 26-08-2018 / 16:49:24 / Claus Gittinger"
!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

new
    "returns a singleton"

    ^ self theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.
! !

!UIManager methodsFor:'mimicri'!

informUserDuring:aBlock 
    ^ Dialog informUser:'Please wait' during:aBlock

    "Created: / 26-08-2018 / 16:50:20 / Claus Gittinger"
! !

!UIManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/UIManager.st,v 1.1 2018-08-26 17:19:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/UIManager.st,v 1.1 2018-08-26 17:19:28 cg Exp $'
! !

