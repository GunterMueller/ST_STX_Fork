"
 COPYRIGHT (c) 2004 by eXept Software AG
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

Object subclass:#SharedPool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!SharedPool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    A shared pool represents a set of bindings which are accessible to all classes
    which import the pool in its 'pool dictionaries'.
    SharedPool is NOT a dictionary but rather a name space.
    Bindings are represented by 'class variables' - as long as we have no better way to represent
    them at least. This is done to make stc happy (or at least, to not be forced to adapt it
    to any new semantics).
"
! !

!SharedPool class methodsFor:'Compatibility-Squeak'!

bindingOf: varName
    "Answer the binding of some variable resolved in the scope of the receiver"

    | aSymbol binding |

    "/ self shouldImplement.       "not yet finished"
    aSymbol := varName asSymbol.

    "First look in classVar dictionary."
    binding := self classPool bindingOf: aSymbol.
    binding notNil ifTrue:[^binding].

    "Next look in shared pools."
    self sharedPools do:[:pool |
        binding := pool bindingOf: aSymbol.
        binding notNil ifTrue:[^binding].
    ].

    "subclassing and environment are not preserved"
    ^nil

    "Modified: / 12-09-2011 / 09:40:36 / cg"
!

bindingsDo: aBlock
    self classVarNames do:[:eachKey |
        aBlock value:(eachKey -> (self classVarAt:eachKey))
    ].

    "Modified: / 12-09-2011 / 09:42:00 / cg"
! !

!SharedPool class methodsFor:'Compatibility-V''Age'!

declareConstant:constantName value:value
    self == SharedPool ifTrue:[ self error ].

    (self classVarNames includes:constantName) ifFalse:[
        self addClassVarName:constantName
    ].

    self classVarAt:constantName put:value.
!

declareVariable:varName
    self == SharedPool ifTrue:[ self error ].

    (self classVarNames includes:varName) ifFalse:[
        self addClassVarName:varName
    ].

    "Created: / 07-02-2012 / 15:57:35 / cg"
! !


!SharedPool class methodsFor:'code generation'!

initializeFrom:aDictionary
    "given a dictionary, generate my classvars and the init code"

    |sortedNames code|

    sortedNames := aDictionary keys asSortedCollection.
    self addClassVarNames:sortedNames.

    code := String streamContents:[:s |
        s nextPutLine:'initialize'.
        sortedNames do:[:k |
            |v|

            v := aDictionary at:k.
            s nextPutLine:('    %1 := %2.' bindWith:k with:v storeString).
        ].
    ].
    self class compile:code classified:'initialization'

    "
     OLEStatusCodeConstants initializeFrom:aDictionary
    "

    "Created: / 21-12-2010 / 17:58:25 / cg"
    "Modified: / 15-01-2011 / 14:20:58 / cg"
! !

!SharedPool class methodsFor:'dictionary protocol'!

associationsDo:aBlock
    "enumerate all keys (= pool var names) with their value"

    ^ self keys do:[:key | aBlock value:(Association key:key value:(self at:key))]
!

do:aBlock
    "enumerate all values"

    ^ self keys do:[:key | aBlock value:(self at:key)]

    "Created: / 06-03-2012 / 17:07:54 / cg"
!

includesKey:aSymbol
    ^ self keys includes:aSymbol

    "
     OpenGLConstants includesKey:#GL3Bytes
    "
!

keyAtValue:value ifAbsent:exceptionValue
    self keysDo:[:k |
        (self at:k) == value ifTrue:[ ^ k ].
    ].
    ^ exceptionValue value

    "Created: / 08-09-2011 / 05:51:10 / cg"
!

keys
    "retrieve all keys (= pool var names)"

    ^ self classVarNames

    "
     OpenGLConstants keys
    "

    "Modified (comment): / 06-03-2012 / 17:09:11 / cg"
!

keysAndValuesDo:aBlock
    "enumerate all keys (= pool var names) with their value"

    self keys do:[:key | aBlock value:key value:(self at:key)]

    "Created: / 06-03-2012 / 17:07:41 / cg"
!

keysDo:aBlock
    "enumerate all keys (= pool var names)"

    self keys do:aBlock

    "Modified (comment): / 06-03-2012 / 17:08:54 / cg"
! !


!SharedPool class methodsFor:'name lookup'!

at:name
    "retrieve a pool variable by name"

    ^ self at:name ifAbsent:[self errorKeyNotFound:name]
!

at:name ifAbsent:aBlock
    "retrieve a pool variable by name"

    (self includesKey:name) ifFalse:[^ aBlock value].
    ^ self classVarAt:name
!

at:name put:aValue
    "set a pool variable by name"

    ^ self classVarAt:name put:aValue

    "Created: / 08-09-2011 / 05:48:16 / cg"
!

classBindingOf: varName
    "For initialization messages grant the regular scope"

    self shouldImplement.       "not yet finished"
    ^ super bindingOf: varName
! !

!SharedPool class methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    "return a printed represenation - here, a reminder is appended,
     that this is not a regular class"

    self == NameSpace ifTrue:[
        super displayOn:aGCOrStream.
    ] ifFalse:[
        aGCOrStream 
            nextPutAll:self name;
            nextPutAll:' (* SharedPool *)'.
    ].
! !

!SharedPool class methodsFor:'queries'!

isSharedPool
    ^ self ~~ SharedPool
! !

!SharedPool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

