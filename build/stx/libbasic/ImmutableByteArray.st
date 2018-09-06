"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by eXept Software AG
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

ByteArray variableByteSubclass:#ImmutableByteArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ImmutableByteArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    By default, byte array literals in smalltalk are mutable objects. That
    may lead to some subtle (and hard to find errors), if some method passes
    a literal byte-array object as argument to someone else, who changes the
    bytearray using at:put: like messages. Since the bytearray object is kept in
    the first methods literals, the bytearray constant has now been changed without
    having the method's sourcecode reflect this. Thus, the method will
    behave differently from what its source may make you think.

    To help finding this kind of 'feature/bug', the compiler can be
    configured to create instances of this ImmutableByteArray instead of ByteArrays
    for literals. Instances of ImmutableByteArray catch storing accesses and
    enter the debugger. Although useful, this feature is disabled by default
    for compatibility to other smalltalk implementations.
    (Also, if turned on, this makes inspecting bytearray literals entered in
     a workspace somewhat strange: you cannot modify it any longer).

    Turn the ImmutableArray feature on, by setting the Parser's class variable
    'ArraysAreImmutable' to true or use the new launchers settings menu.

    This class should be used only by the compiler.

    ATTENTION:
        there may be still code around which checks for explicit class being ByteArray
        (both in Smalltalk and in primitive code). All code like foo 'class == ByteArray'
        or '__isByteArray()' will not work with ImmutableByteArrays - consider using '__isByteArrayLike()'.
        A somewhat better approach would be to either add a flag to the object (mutability)
        and check this dynamically (expensive) or to place immutable objects into a readonly
        memory segment (the good solution). We will eventually implement the second in the future...

    [see also:]
        ImmutableString
        ImmutableArray
        Parser Scanner

    [author:]
        Claus Gittinger
"
! !

!ImmutableByteArray class methodsFor:'queries'!

mutableClass
    "answer an equivalent mustable class"

    ^ ByteArray
! !

!ImmutableByteArray class methodsFor:'testing'!

hasImmutableInstances
    ^ true
! !

!ImmutableByteArray methodsFor:'accessing'!

at:index put:value
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super at:index put:value
!

basicAt:index put:value
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super basicAt:index put:value
!

byteAt:index put:value
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super byteAt:index put:value
!

unsignedInt16At:index put:anInteger
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt16At:index put:anInteger
!

unsignedInt16At:index put:anInteger MSB:msb
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt16At:index put:anInteger MSB:msb
!

unsignedInt32At:index put:anInteger
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt32At:index put:anInteger
!

unsignedInt32At:index put:anInteger MSB:msb
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt32At:index put:anInteger MSB:msb
!

unsignedInt64At:index put:anInteger
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt64At:index put:anInteger
!

unsignedInt64At:index put:anInteger MSB:msb
    "Trigger an error if an immutable bytearray is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger (or proceed in an exception handler)."

    self noModificationError.
    ^ super unsignedInt64At:index put:anInteger MSB:msb
! !

!ImmutableByteArray methodsFor:'converting'!

asByteArray
    "return the receiver as a (mutable) byteArray"

    ^ self shallowCopy

    "
     #[1 2 3 4] asImmutableByteArray asByteArray
    "
!

asImmutableByteArray
    "that's what I am-"

    ^ self
!

asMutableCollection
    "return a writable copy of myself"

    ^ self shallowCopy
!

beImmutable
    "that's what I am"

    ^ self
!

beMutable
    "you never go back"

    ^ self shouldNotImplement
!

beUnsigned
    "that's what I am-"

    ^ self.

    "
        #[1 2 3 128 255] asImmutableByteArray beUnsigned
    "
! !

!ImmutableByteArray methodsFor:'copying'!

postCopy
    "when copied, make me a real (mutable) ByteArray"

    self changeClassTo:ByteArray.
!

postDeepCopy
    "when copied, make me a real (mutable) ByteArray"

    self changeClassTo:ByteArray.

    "
     #[1 2 3 4] asImmutableByteArray copy          class
     #[1 2 3 4] asImmutableByteArray shallowCopy   class
     #[1 2 3 4] asImmutableByteArray deepCopy      class
    "
!

shallowCopy
    "when copying, return a real (mutable) ByteArray"

    |sz|

    sz := self size.
    ^ (ByteArray new:sz) replaceBytesFrom:1 to:sz with:self startingAt:1

    "
     #[1 2 3 4] asImmutableByteArray shallowCopy
    "
! !

!ImmutableByteArray methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        self storeOn:aGCOrStream.
        aGCOrStream nextPutAll:'"immutable"'.
        ^ self.
    ].
    super displayOn:aGCOrStream.
! !

!ImmutableByteArray methodsFor:'private'!

species
    "Copies should be mutable"

    ^ ByteArray
!

speciesForCopy
    "Copies should be mutable"

    ^ ByteArray
! !

!ImmutableByteArray methodsFor:'queries'!

isImmutable
    ^ true
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    "yes, I must be"
    ^ true

! !

!ImmutableByteArray methodsFor:'specials'!

become:anotherObject
    "trigger an error if I should become something else
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super become:anotherObject
!

becomeNil
    "trigger an error if I should become nil
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super becomeNil
!

becomeSameAs:anotherObject
    "trigger an error if I should become something else
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super becomeSameAs:anotherObject
! !

!ImmutableByteArray class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

