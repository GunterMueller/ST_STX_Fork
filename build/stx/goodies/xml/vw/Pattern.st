"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#Pattern
	instanceVariableNames:'followSet'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

Pattern comment:'The element structure of an XML document may, for validation purposes, be constrained using element type and attribute-list declarations. An element type declaration constrains the element''s content by constraining which element types can appear as children of the element.The constraint includes a content model, a simple grammar or pattern governing the allowed types of child elements and the order in which they are allowed to appear. These content models are represented by this XML.Pattern class and it''s subclasses.

Constraint rules or patterns may be complex (ComplexPattern and it''s subclasses) or simple (ConcretePattern and it''s subclasses).
 
Subclasses must implement the following messages:
	coercing
		alternateHeads
		pushDownFollowSet
	testing
		isSimple

Instance Variables:
	followSet       <Collection>  the follow set defines which other patterns may follow this one. By means of #alternateHeads and #pushDownFollowSet, we can reduce a ComplexPattern into a graph of ConcretePatterns, always starting with an InitialPattern and terminating in a TerminalPattern.
'
!


!Pattern class methodsFor:'instance creation'!

new

	^super new initialize
! !

!Pattern methodsFor:'coercing'!

addFollow: aNode

	followSet add: aNode
!

addFollows: aList

	followSet addAll: aList
!

alternateHeads

	^self subclassResponsibility
!

followSet

	^followSet
!

normalize

	| list done t r result |
	list := OrderedCollection
			with: (result := InitialPattern new addFollow: self)
			with: self
			with: TerminalPattern new.
	self addFollow: list last.
	done := OrderedCollection new.
	[list isEmpty]
		whileFalse:
			[t := list removeFirst.
			r := t pushDownFollowSet.
			r == nil
				ifTrue: [done add: t]
				ifFalse: [list addAll: r]].
	list := done.
	done := OrderedCollection new.
	[list isEmpty]
		whileFalse:
			[t := list removeFirst.
			t normalizeFollowSet
				ifTrue: [done add: t]
				ifFalse: [list add: t]].
	done do: [:p |
		p isSimple ifFalse: [self error: 'Incomplete translation'].
		p followSet do: [:p1 |
			p1 isSimple ifFalse: [self error: 'Incomplete translation']]].
	^result
!

normalizeFollowSet

	| changed oldFollow newFollow |
	oldFollow := IdentitySet withAll: followSet.
	newFollow := IdentitySet new.
	oldFollow do: [:pat |
		newFollow addAll: pat alternateHeads].
	changed := newFollow size ~= oldFollow size or: [(newFollow - oldFollow) size > 0].
	followSet := newFollow asOrderedCollection.
	^changed not
!

pushDownFollowSet

	^self subclassResponsibility
! !

!Pattern methodsFor:'initialization'!

initialize

	followSet := OrderedCollection new: 2
! !

!Pattern methodsFor:'printing'!

description

    ^ self className
!

printOn: aStream

	aStream nextPutAll: self description
! !

!Pattern methodsFor:'testing'!

isEmptyPattern
    ^ false
!

isListPattern
    ^ false
!

isModifiedPattern
    "answer true, if this is a pattern followed by a modifier ('*', '+' or '?')"

    ^ false
!

isOptionalPattern
    ^ false
!

isPCDATAPattern
    ^ false
!

isSimple

	^self subclassResponsibility
! !

!Pattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Pattern.st,v 1.11 2008-09-26 10:58:32 stefan Exp $'


! !
