"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Pattern subclass:#ConcretePattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

ConcretePattern comment:'This class is the superclass to what are considered ''simple'' patterns or constraint rules in the element content declarations. These are pattern elements that cannot be decomposed into other pattern elements. As seen from the class hiererarchy, instances of simple patterns include AnyPattern, EmptyPattern, InitialPattern, NamePattern, PCDATAPattern and TerminalPattern.

Subclasses must implement the following messages:
	testing
		matches:
'
!


!ConcretePattern methodsFor:'accessing'!

followSetDescription

    | s |
    s := (String new: 32) writeStream.
    s nextPut: $(.
    followSet do: [:n | s nextPutAll: n name type]
            separatedBy: [s space].
    s nextPut: $).
    ^s contents
! !

!ConcretePattern methodsFor:'coercing'!

alternateHeads

	^Array with: self
!

pushDownFollowSet

	^nil
! !

!ConcretePattern methodsFor:'testing'!

canTerminate

	^followSet contains: [:p | p isTerminator]
!

couldBeText

	^false
!

isSimple

	^true
!

isTerminator

	^false
!

matches: aNode

	self subclassResponsibility
! !

!ConcretePattern methodsFor:'validation'!

validate: node

	| couldBeText |
	couldBeText := false.
	self followSet do: [:i |
		i couldBeText
			ifTrue: [couldBeText := true].
		(i matches: node)
			ifTrue: [^i]].
	couldBeText
		ifFalse: [node isBlankText ifTrue: [^self]].
	^nil
! !

!ConcretePattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ConcretePattern.st,v 1.8 2008-03-08 11:00:52 cg Exp $'


! !
