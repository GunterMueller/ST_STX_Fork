"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

Refactoring subclass:#MethodRefactoring
	instanceVariableNames:'class source'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!MethodRefactoring methodsFor:'accessing'!

source
    "return the value of the instance variable 'source' (automatically generated)"

    ^ source

    "Created: / 6.2.2000 / 17:13:32 / cg"
!

source:something
    "set the value of the instance variable 'source' (automatically generated)"

    source := something.

    "Created: / 6.2.2000 / 17:13:32 / cg"
! !

!MethodRefactoring methodsFor:'private'!

buildSelectorString: aSelector 
	aSelector numArgs = 0 ifTrue: [^aSelector].
	^self buildSelectorString: aSelector
		withPermuteMap: (1 to: aSelector numArgs)
!

buildSelectorString: aSelector withPermuteMap: anIntegerCollection 
        | stream keywords |
        aSelector numArgs == 0 ifTrue: [^aSelector asString].
        stream := WriteStream on:''.
        keywords := aSelector keywords.
        keywords with: anIntegerCollection
                do: 
                        [:each :i | 
                        stream
                                nextPutAll: each;
                                nextPutAll: ' ``@arg';
                                nextPutAll: i printString;
                                nextPut: $ ].
        ^stream contents
! !

!MethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

