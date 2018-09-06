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

Boolean subclass:#True
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Objects'
!

!True class methodsFor:'documentation'!

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
    True has only one instance, true, representing logical truth.

    Some methods are implemented here and in False, instead of the common
    superclass Boolean. This has the advantage that no truth-value checks
    are needed, but instead the truth check is done in the method lookup.
    However, remember that some messages to booleans are inline coded in
    the compilers (both interpreted and machine code). Therefore redefinition
    of some methods here will not have any effect on compiled code.
    (redefining ifTrue: to something else will probably crash the smalltalk
     world anyway ...)

    [see also:]
        False

    [author:]
        Claus Gittinger
"
! !



!True methodsFor:'conditional evaluation'!

and:aBlock
    "evaluate aBlock if the receiver is true.
     since the receiver is known to be true,
     return the value of evaluating the block.
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ aBlock value
!

and:block1 and:block2
    "evaluate block1 if the receiver is true, 
     if that is also true, return the result from block2."

    block1 value ifFalse: [^ false].
    ^ block2 value

    "Modified: / 20-08-2011 / 16:31:27 / cg"
!

and:block1 and:block2 and:block3
    "evaluate block1 if the receiver is true, 
     if that is also true, evaluate block2.
     if that is also true, return the result from block3."

    block1 value ifFalse:[^ false].
    block2 value ifFalse:[^ false].
    ^ block3 value
!

and:block1 and:block2 and:block3 and:block4
    "evaluate block1 if the receiver is true, 
     if that is also true, evaluate block2.
     if that is also true, evaluate block3.
     if that is also true, return the result from block4."

    block1 value ifFalse:[^ false].
    block2 value ifFalse:[^ false].
    block3 value ifFalse:[^ false].
    ^ block4 value
!

ifFalse:aBlock
    "If the receiver is false, return the value of evaluating aBlock; nil otherwise.
     Since the receiver is definitely true here, unconditionally return nil value.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ nil
!

ifFalse:falseBlock ifTrue:trueBlock
    "return the value of evaluating trueBlock (since the receiver is true)
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ trueBlock value
!

ifTrue:aBlock
    "If the receiver is true, return the value of evaluating aBlock; nil otherwise.
     Since the receiver is definitely true here, unconditionally return the blocks value.
     Notice:
        This method is open coded (inlined) by the compiler(s)
        - redefining it may not work as expected."

    ^ aBlock value
!

ifTrue:trueBlock ifFalse:falseBlock
    "return the value of evaluating trueBlock (since the receiver is true)
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ trueBlock value
!

or:aBlock
    "evaluate aBlock if the receiver is false.
     since the receiver is known to be true simply return true.
     Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ self
!

or:block1 or:block2
    ^ self
!

or:block1 or:block2 or:block3
    ^ self
!

or:block1 or:block2 or:block3 or:block4
    ^ self
! !

!True methodsFor:'converting'!

asInteger
    "false->0; true->1"

    ^ 1
!

asNumber
    "false->0; true->1"

    ^ 1
! !

!True methodsFor:'logical operations'!

& aBoolean
   "return true if both the receiver and the argument are true
    (since the receiver is true, return the argument, aBoolen)
     Notice: 
         as this is a binary message, the argument is always evaluated. 
         It might be better to use and:[...], which does not evaluate
         the argument if the receiver is already false."

    ^ aBoolean
!

eqv:aBoolean
   "return true if both the receiver and the argument are the same truth value
    (since the receiver is true, return true if the argument is also)"

    ^ aBoolean
!

implies:aBoolean
   "return true if receiver => argument"

    ^ aBoolean
!

not
   "return true if the receiver is false, false otherwise
    (since the receiver is true, return false).
    Notice:
	This method is open coded (inlined) by the compiler(s)
	- redefining it may not work as expected."

    ^ false
!

xor:aBoolean
   "return true if the receiver and the argument are different truth values
    (since the receiver is true, return true, if the argument is not)"

    ^ aBoolean not
!

| aBoolean
    "return true if either the receiver or the argument are true
     (since the receiver is true, return true).
     Notice: 
         as this is a binary message, the argument is always evaluated. 
         It might be better to use or:[...], which does not evaluate
         the argument if the receiver is already true."

    ^ true
! !

!True methodsFor:'printing & storing'!

printString
    "return character sequence representing the receiver"

    ^ 'true'
! !

!True class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

