"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Array variableSubclass:#ImmutableArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ImmutableArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    By default, array literals in smalltalk are mutable objects. That
    may lead to some subtle (and hard to find errors), if some method passes
    a literal array constant as argument to someone else, who changes the
    array using at:put: like messages. Since the array object is kept in
    the first methods literals, the array constant has now been changed without
    having the method's sourcecode reflect this. Thus, the method will
    behave differently from what its source may make you think.

    To help finding this kind of 'feature/bug', the compiler can be
    configured to create instances of this ImmutableArray instead of Arrays
    for array literals. Instances of ImmutableArray catch storing accesses and
    enter the debugger. Although useful, this feature is disabled by default
    for compatibility to other smalltalk implementations.
    (Also, if turned on, this makes inspecting array literals entered in
     a workspace somewhat strange: you cannot modify it any longer).

    Turn the ImmutableArray feature on by setting the Parsers class variable
    'ArraysAreImmutable' to true or use the new launchers settings menu.

    This class should be used only by the compiler.

    ATTENTION:
        there may be still code around which checks for explicit class being Array
        (both in Smalltalk and in primitive code). All code like foo 'class == Array'
        or '__isArray' will not work with ImmutableArrays; consider using '__isArrayLike'.
        A somewhat better approach would be to either add a flag to the object (mutability)
        and check this dynamically (expensive) or to place immutable objects into a readonly
        memory segment (the good solution). We will eventually implement the second in the future...

    [see also:]
        ImmutableString
        ImmutableByteArray
        Parser Scanner

    [author:]
        Claus Gittinger
"
! !

!ImmutableArray class methodsFor:'queries'!

mutableClass
    "answer an equivalent mustable class"

    ^ Array
! !

!ImmutableArray class methodsFor:'testing'!

hasImmutableInstances
    ^ true
! !

!ImmutableArray methodsFor:'accessing'!

at:index put:value
    "Trigger an error if an immutable array is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger."

    self noModificationError.
    ^ super at:index put:value

    "Modified: / 3.8.1998 / 14:45:23 / cg"
!

basicAt:index put:value
    "Trigger an error if an immutable array is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger."

    self noModificationError.
    ^ super basicAt:index put:value

    "Modified: / 3.8.1998 / 14:45:30 / cg"
! !

!ImmutableArray methodsFor:'converting'!

asArray
    "return the receiver as an array. I am already.
     Use asNewArray, or asMutableCollection if you need a copy for modification"

    ^ self 
!

asImmutableArray
    ^ self
!

asMutableCollection
    "return a writable copy of myself"

    ^ self copy changeClassTo:Array
!

asNewArray
    "return the receiver as an unique new array."

    ^ self copy
!

beImmutable
    "that's what I am"

    ^ self
!

beMutable
    "you never go back"

    ^ self shouldNotImplement
! !

!ImmutableArray methodsFor:'copying'!

postCopy
    "when copied, make it me a real (mutable) Array"

    self changeClassTo:Array.
!

postDeepCopy
    "when copied, make it me a real (mutable) Array"

    self changeClassTo:Array.
!

shallowCopy
    "when copying, return a real (mutable) Array"

    |sz|

    sz := self size.
    ^ (Array new:sz) replaceFrom:1 to:sz with:self startingAt:1

    "
     #(1 2 3 4) asImmutableArray shallowCopy
    "
! !

!ImmutableArray methodsFor:'private'!

species
    "Copies should be mutable"

    ^ Array
!

speciesForCopy
    "Copies should be mutable"

    ^ Array
! !

!ImmutableArray methodsFor:'queries'!

isImmutable
    ^ true
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    "yes, I must be"
    ^ true

! !

!ImmutableArray methodsFor:'specials'!

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
!

grow:newSize
    "trigger an error if I should change my size"

    self noModificationError.
    ^ super grow:newSize
! !

!ImmutableArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

