"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Singleton subclass:#DeafObject
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!

DeafObject comment:'DeafObject is a singleton class whose sole instance is deaf to all requests - i.e. it appears to understand all messages, but takes no action except to answer itself. This ensures that the results of all message sends to the DeafObject are also deaf. DeafObject can be useful for avoiding a proliferation of #isNil tests.

N.B. DeafObject cannot be used to substitute for any object which has special significance to either the Compiler or the VM, a good example being <Boolean>s. The following expression will raise a ''Must be boolean'' error because it is not a true message send:

DeafObject current ifTrue: []

Class Variables:
	Current		<DeafObject>. Singleton instance.


'
!

!DeafObject class methodsFor:'documentation'!

documentation
"
    DeafObject is a singleton class whose sole instance is deaf to all requests - 
    i.e. it appears to understand all messages, but takes no action except to answer itself. 
    This ensures that the results of all message sends to the DeafObject are also deaf. 
    DeafObject can be useful for avoiding a proliferation of #isNil tests.

    N.B. DeafObject cannot be used to substitute for any object which has special significance 
    to either the Compiler or the VM, a good example being <Boolean>s. 
    The following expression will raise a 'Must be boolean' error because it is not a true message send:

    DeafObject current ifTrue: []

    Class Variables:
        Current         <DeafObject>. Singleton instance.
"
! !

!DeafObject class methodsFor:'accessing'!

current
        "Answer the singleton <DeafObject>."

    ^ self basicNew

    "Modified: / 23-09-2011 / 22:04:33 / cg"
! !

!DeafObject methodsFor:'comparing'!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent (in whatever respect is appropriate for 
	the class of the receiver). All DeafObjects are considered equal."

	^self class = comparand class
! !

!DeafObject methodsFor:'exceptions'!

doesNotUnderstand: aMessage
	"The receiver is deaf to all requests. Answer self to ensure that
	our answers are also deaf."

	^self
!

mustBeBoolean
	"Private - Sent to the receiver by the VM when an attempt was made to test it
	for its boolean status by a CompiledMethod.
	Note that it is normally necessary for implementors of #mustBeBoolean to return a
	boolean value, or not return at all. If a non-boolean value is returned, then it
	in turn will be sent a #mustBeBoolean message too. This could potentially continue 
	indefinitely, causing an unbreakable loop."

	^true
! !

!DeafObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__DeafObject.st,v 1.3 2014-08-01 12:52:52 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__DeafObject.st,v 1.3 2014-08-01 12:52:52 stefan Exp $'
! !

