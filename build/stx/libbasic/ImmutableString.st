"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
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

String variableByteSubclass:#ImmutableString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ImmutableString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    By default, string literals in smalltalk are mutable objects. That
    may lead to some subtle (and hard to find errors), if some method passes
    a string constant as argument to someone else, who changes the
    string using at:put: like messages. Since the string object is kept in
    the first methods literals, the string constant has now been changed without
    having the method's sourcecode reflect this. Thus, the method will
    behave differently from what its source may make you think.

    To help finding this kind of 'feature/bug', the compiler can be
    configured to create instances of this ImmutableString instead of Strings
    for literals. Instances of ImmutableString catch storing accesses and
    enter the debugger. Although useful, this feature is disabled by default
    for compatibility to other smalltalk implementations.
    (Also, if turned on, this makes inspecting string literals entered in
     a workspace somewhat strange: you cannot modify it any longer).

    Turn the ImmutableString feature on by setting the Parsers class variable
    'StringsAreImmutable' to true or use the new launchers settings menu.

    This class should be used only by the compiler.

    ATTENTION:
        there may be still code around which checks for explicit class being String
        (both in Smalltalk and in primitive code). All code like foo 'class == String'
        or '__isString()' will not work with ImmutableStrings. Use '__isStringLike()' instead.
        A somewhat better approach would be to either add a flag to the object (mutability)
        and check this dynamically (expensive) or to place immutable objects into a readonly
        memory segment (the good solution). We will eventually implement the second in the future...

    [see also:]
        ImmutableArray
        Parser Scanner

    [author:]
        Claus Gittinger
"
! !

!ImmutableString class methodsFor:'queries'!

mutableClass
    "answer an equivalent mustable class"

    ^ String
! !

!ImmutableString class methodsFor:'testing'!

hasImmutableInstances
    ^ true
! !

!ImmutableString methodsFor:'accessing'!

at:index put:value
    "Trigger an error if an immutable string is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger."

    self noModificationError.
    ^ super at:index put:value

    "Created: / 3.8.1998 / 14:45:14 / cg"
!

basicAt:index put:value
    "Trigger an error if an immutable string is stored into.
     The store will be performed (for compatibility reasons) if you continue
     in the debugger."

    self noModificationError.
    ^ super basicAt:index put:value
! !

!ImmutableString methodsFor:'converting'!

asImmutableString
    ^ self
!

asMutableCollection
    "return a writable copy of myself"

    ^ self copy changeClassTo:String
!

beImmutable
    "that's what I am"

    ^ self
!

beMutable
    "you never go back"

    ^ self shouldNotImplement
! !

!ImmutableString methodsFor:'copying'!

copy
    "return a copy of the receiver"

    ^ self copyFrom:1

    "
        'abcd' asImmutableString copy
    "
!

deepCopy
    "when copying, return a real (mutable) String"

    (self class == ImmutableString) ifTrue:[
        ^ self copyFrom:1
    ].
    ^ super deepCopy

    "
     'hello world' asImmutableString deepCopy
    "
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of the receiver - reimplemented to be a bit faster"

    "
     could be an instance of a subclass which needs deepCopy
     of its named instvars ...
    "
    (self class == ImmutableString) ifTrue:[
        ^ self copyFrom:1
    ].
    ^ super deepCopyUsing:aDictionary postCopySelector:postCopySelector

    "
     'hello world' asImmutableString deepCopyUsing:nil postCopySelector:nil
    "
!

postCopy
    "when copied, make me a real (mutable) String"

    self changeClassTo:String.

    "Created: / 3.8.1998 / 14:46:45 / cg"
!

postDeepCopy
    "when copied, make it me a real (mutable) String"

    self changeClassTo:String.

    "
     'foobar' asImmutableString copy          class
     'foobar' asImmutableString shallowCopy   class
     'foobar' asImmutableString deepCopy      class
    "
!

shallowCopy
    "when copying, return a real (mutable) String"

    (self class == ImmutableString) ifTrue:[
        ^ self copyFrom:1
    ].
    ^ super shallowCopy

    "
     'hello world' asImmutableString shallowCopy
    "

    "Created: / 3.8.1998 / 14:47:00 / cg"
!

simpleDeepCopy
    "when copying, return a real (mutable) String"

    (self class == ImmutableString) ifTrue:[
        ^ self copyFrom:1
    ].
    ^ super simpleDeepCopy

    "
     'hello world' asImmutableString simpleDeepCopy
    "
! !

!ImmutableString methodsFor:'private'!

species
    "Copies should be mutable"

    ^ String

    "Created: / 3.8.1998 / 14:47:58 / cg"
!

speciesForCopy
    "Copies should be mutable"

    ^ String

    "Created: / 3.8.1998 / 14:47:58 / cg"
! !

!ImmutableString methodsFor:'queries'!

isImmutable
    ^ true
! !

!ImmutableString methodsFor:'specials'!

become:anotherObject
    "trigger an error if I should become something else
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super become:anotherObject

    "Created: / 3.8.1998 / 14:48:29 / cg"
!

becomeNil
    "trigger an error if I should become nil
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super becomeNil

    "Created: / 3.8.1998 / 14:48:37 / cg"
!

becomeSameAs:anotherObject
    "trigger an error if I should become something else
     (this would be an even more tricky manipulation)"

    self noModificationError.
    ^ super becomeSameAs:anotherObject
! !

!ImmutableString class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

