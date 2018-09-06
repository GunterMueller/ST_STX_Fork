"
 COPYRIGHT (c) 1988 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Boolean subclass:#False
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Objects'
!

!False class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    False has only one instance, false, representing logical falsehood.

    Some methods are implemented here and in True, instead of the common
    superclass Boolean. This has the advantage that no truth-value checks
    are needed, but instead the truth check is done in the method lookup.
    However, remember that some messages to booleans are inline coded in
    the compilers (both interpreted and machine code). Therefore redefinition
    of some methods here will not have any effect on compiled code.
    (redefining ifTrue: to something else will probably crash the smalltalk
     world anyway ...)

    [see also:]
        True

    [author:]
        Claus Gittinger
"
! !



!False methodsFor:'conditional evaluation'!

and:aBlock
    "evaluate aBlock if the receiver is true.
     (since the receiver is known to be false here, always return false here).
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ self
!

and:block1 and:block2
    "evaluate block1 if the receiver is true; if that also returns true, evaluate block2.
     (since the receiver is known to be false here, always return false here).
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ self
!

and:block1 and:block2 and:block3
    "return false"

    ^ self
!

and:block1 and:block2 and:block3 and:block4
    "return false"

    ^ self
!

ifFalse:aBlock
    "If the receiver is false, return the value of evaluating aBlock; nil otherwise.
     Since the receiver is definitely false here, unconditionally return the blocks value.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ aBlock value
!

ifFalse:falseBlock ifTrue:trueBlock
    "return the value of evaluating falseBlock (since the receiver is false)
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ falseBlock value
!

ifTrue:aBlock
    "If the receiver is true, return the value of evaluating aBlock; nil otherwise.
     Since the receiver is definitely false here, unconditionally return nil value.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ nil
!

ifTrue:trueBlock ifFalse:falseBlock
    "return the value of evaluating falseBlock (since the receiver is false)
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ falseBlock value
!

or:aBlock
    "evaluate aBlock if the receiver is false.
     (since the receiver is false return the value of evaluating aBlock).
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ aBlock value
!

or:block1 or:block2
    block1 value ifTrue:[^ true].
    ^ block2 value
!

or:block1 or:block2 or:block3
    block1 value ifTrue:[^ true].
    block2 value ifTrue:[^ true].
    ^ block3 value
!

or:block1 or:block2 or:block3 or:block4
    block1 value ifTrue:[^ true].
    block2 value ifTrue:[^ true].
    block3 value ifTrue:[^ true].
    ^ block4 value
! !

!False methodsFor:'converting'!

asInteger
    "false->0; true->1"

    ^ 0
!

asNumber
    "false->0; true->1"

    ^ 0
! !

!False methodsFor:'logical operations'!

& aBoolean
    "return true, if both the receiver and the argument are true
     (since the receiver is false, return false)
     Notice: 
         as this is a binary message, the argument is always evaluated. 
         It might be better to use and:[...], which does not evaluate
         the argument if the receiver is already false."

    ^ false
!

eqv:aBoolean
    "return true, if the receiver and the argument are the same truth value
     (since the receiver is false, return true if the argument is also false)"

    ^ aBoolean not
!

implies:aBoolean
   "return true if receiver => argument"

    ^ true
!

not
    "return true, if the receiver is false, false otherwise
     (since the receiver is false, return true).
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ true
!

xor:aBoolean
    "return true, if the receiver and the argument are different truth values
     (since the receiver is false, return true, if the armument is not false)"

    ^ aBoolean
!

| aBoolean
    "return true, if either the receiver or the argument is true
     (since the receiver is false, return the argument).
     Notice: 
         as this is a binary message, the argument is always evaluated. 
         It might be better to use or:[...], which does not evaluate
         the argument if the receiver is already true."

    ^ aBoolean
! !

!False methodsFor:'printing & storing'!

printString
    "return character sequence representing the receiver"

    ^ 'false'
! !

!False class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

