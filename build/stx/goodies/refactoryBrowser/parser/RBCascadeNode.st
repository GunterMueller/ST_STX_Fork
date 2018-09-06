"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBCascadeNode
	instanceVariableNames:'messages semicolons'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBCascadeNode comment:'BRCascadeNode is an AST node for cascaded messages (e.g., "self print1 ; print2").

Instance Variables:
	messages        <SequenceableCollection of: BRMessageNode>      the messages 
	semicolons      <SequenceableCollection of: Integer>    positions of the ; between messages

'
!


!RBCascadeNode class methodsFor:'instance creation'!

messages: messageNodes 
	^self new messages: messageNodes
!

messages: messageNodes semicolons: integerCollection 
	^self new messages: messageNodes semicolons: integerCollection
! !

!RBCascadeNode methodsFor:'accessing'!

children
	^self messages
!

messages
	^messages
!

messages: messageNodeCollection 
	messages := messageNodeCollection.
	messages do: [:each | each parent: self]
!

precedence
	^4
!

receiver
    ^ self messages first receiver

    "Created: / 07-10-2014 / 23:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

semicolons
    ^ semicolons
!

startWithoutParentheses
	^messages first start
!

stopWithoutParentheses
	^messages last stop
! !

!RBCascadeNode methodsFor:'comparing'!

= anObject 
	|m1 m2|

	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self messages size = anObject messages size ifFalse: [^false].
	1 to: self messages size
		do: [:i | m1 := (self messages at: i).
			  m2 := (anObject messages at: i).
			  m1 = m2 ifFalse: [^false]].
	^true
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        self messages size == anObject messages size ifFalse: [^false].
        1 to: self messages size
                do: 
                        [:i | 
                        ((self messages at: i) equalTo: (anObject messages at: i)
                                withMapping: aDictionary) ifFalse: [^false]].
        ^true
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        self messages size == anObject messages size ifFalse: [^false].
        1 to: self messages size
                do: 
                        [:i | 
                        ((self messages at: i) equalTo: (anObject messages at: i)
                                withSelectorMapping: aDictionary) ifFalse: [^false]].
        ^true
!

hash
	^self messages hash
!

semanticallyEqualTo: anObject withMapping: aDictionary 
    "return true, if I am semantically equal to another node, with a given variable name mapping.
     Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

    |myMessages otherMessages|

    self class = anObject class ifFalse: [^false].
    myMessages := self messages.
    otherMessages := anObject messages.
    myMessages size == otherMessages size ifFalse: [^false].

    myMessages with:otherMessages do:[:eachMyMessage :eachOtherMessage | 
        (eachMyMessage semanticallyEqualTo: eachOtherMessage withMapping: aDictionary) ifFalse: [^false]
    ].
    ^true
! !

!RBCascadeNode methodsFor:'copying'!

postCopy
        super postCopy.
        self messages: (messages collect: [:each | each copy])

    "Modified: / 18-06-2015 / 20:37:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBCascadeNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes"

    messages do:[:each | each variableNodesDo:aBlock].
! !

!RBCascadeNode methodsFor:'initialize-release'!

messages: messageNodes semicolons: integerCollection 
	self messages: messageNodes.
	semicolons := integerCollection
! !

!RBCascadeNode methodsFor:'matching'!

copyInContext: aDictionary 
	^(self class new) messages: (self copyList: messages inContext: aDictionary);
		yourself
!

match: aNode inContext: aDictionary 
	aNode class == self class ifFalse: [^false].
	^self matchList: messages
		against: aNode messages
		inContext: aDictionary
! !

!RBCascadeNode methodsFor:'querying'!

bestNodeFor: anInterval 
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	messages 
		reverseDo: [:each | (each containedBy: anInterval) ifTrue: [^each]].
	selectedChildren := (messages 
				collect: [:each | each bestNodeFor: anInterval]) 
					reject: [:each | each isNil].
	^selectedChildren detect: [:each | true] ifNone: [nil]
!

firstLineNumber
    ^ messages first firstLineNumber.
!

lastLineNumber
    ^ messages last lastLineNumber.
!

whichNodeIsContainedBy: anInterval 
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	messages 
		reverseDo: [:each | (each containedBy: anInterval) ifTrue: [^each]].
	selectedChildren := (messages 
				collect: [:each | each whichNodeIsContainedBy: anInterval]) 
					reject: [:each | each isNil].
	^selectedChildren detect: [:each | true] ifNone: [nil]
! !

!RBCascadeNode methodsFor:'replacing'!

replaceNode: aNode withNode: anotherNode 
	self messages: (messages 
				collect: [:each | each == aNode ifTrue: [anotherNode] ifFalse: [each]])
! !

!RBCascadeNode methodsFor:'testing'!

directlyUses: aNode 
	^messages last = aNode and: [self isDirectlyUsed]
!

isCascade
	^true
!

uses: aNode 
	^messages last = aNode and: [self isUsed]
! !

!RBCascadeNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptCascadeNode: self
! !

!RBCascadeNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

