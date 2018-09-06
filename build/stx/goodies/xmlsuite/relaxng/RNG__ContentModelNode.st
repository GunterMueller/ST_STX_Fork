"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#ContentModelNode
	instanceVariableNames:'prev next parent firstChild inDefine'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!ContentModelNode class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 30-04-2005 / 14:25:05 / janfrog"
! !

!ContentModelNode methodsFor:'accessing'!

addChild:aContentModelNode

    | lastChild |
    self checkForCorrectNesting:aContentModelNode.
    firstChild isTerminatorNode ifTrue:[
        firstChild := aContentModelNode parent:self
    ] ifFalse:[
        lastChild := self lastChild.
        lastChild next:aContentModelNode.
        aContentModelNode prev:lastChild; parent:self.

    ]

    "Created: / 30-04-2005 / 14:11:14 / janfrog"
    "Modified: / 14-05-2005 / 20:15:23 / janfrog"
!

children

    | currentNode children |
    currentNode := self firstChild.
    children := OrderedCollection new.
    [ currentNode isTerminatorNode ] whileFalse:[
        children addLast:currentNode.
        currentNode := currentNode next.
    ].
    ^children

    "Created: / 30-04-2005 / 13:56:30 / janfrog"
!

childrenDo:aBlock

    ^self children do:aBlock

    "Created: / 02-05-2005 / 16:50:13 / janfrog"
!

firstChild
    ^ firstChild

    "Created: / 30-04-2005 / 13:56:34 / janfrog"
!

firstChild:aContentModelNode
    firstChild := aContentModelNode.

    "Created: / 30-04-2005 / 13:56:34 / janfrog"
!

inDefine
    ^ inDefine

    "Created: / 12-05-2005 / 12:09:40 / masca"
!

inDefine:aBoolean
    inDefine := aBoolean.

    "Created: / 12-05-2005 / 12:09:40 / masca"
!

lastChild

    | lastChild |
    lastChild := self firstChild.
    [ lastChild next isTerminatorNode ] whileFalse:[
        lastChild := lastChild next
    ].
    ^lastChild

    "Created: / 30-04-2005 / 14:09:17 / janfrog"
!

next
    ^ self inDefine 
        ifTrue:[self parent next]
        ifFalse:[next]

    "Created: / 30-04-2005 / 14:11:32 / janfrog"
    "Modified: / 12-05-2005 / 12:13:59 / masca"
!

next:aContentModelNode
    next := aContentModelNode.

    "Created: / 30-04-2005 / 14:11:32 / janfrog"
!

parent
    ^ parent

    "Created: / 30-04-2005 / 14:09:51 / janfrog"
!

parent:aContentModelNode
    parent := aContentModelNode.

    "Created: / 30-04-2005 / 14:09:51 / janfrog"
!

patterns

    ^self children 
        inject:Set new
        into:[:patterns :contentModelNode|
            patterns addAll:contentModelNode patterns
        ]

    "Created: / 30-04-2005 / 13:52:38 / janfrog"
!

prev
    ^ self inDefine 
        ifTrue:[self parent prev]
        ifFalse:[prev]

    "Created: / 30-04-2005 / 14:11:32 / janfrog"
    "Modified: / 12-05-2005 / 12:14:07 / masca"
!

prev:aContentModelNode
    prev := aContentModelNode.

    "Created: / 30-04-2005 / 14:11:32 / janfrog"
! !

!ContentModelNode methodsFor:'automaton support'!

generateTransitionsIn:aContentModelAutomaton

    self children do:[:child|child generateTransitionsIn:aContentModelAutomaton]

    "Created: / 30-04-2005 / 21:11:36 / janfrog"
!

patternsThatCanBeFirst

    ^self subclassResponsibility

    "Created: / 30-04-2005 / 21:03:43 / janfrog"
!

patternsThatCanBeLast

    ^self subclassResponsibility

    "Created: / 30-04-2005 / 21:03:48 / janfrog"
!

patternsThatCanBeNext

    ^self next patternsThatCanBeFirst

    "Created: / 30-04-2005 / 21:09:21 / janfrog"
! !

!ContentModelNode methodsFor:'checking'!

checkContents

    "Created: / 30-04-2005 / 14:56:05 / janfrog"
!

checkForCorrectNesting:aContentModelNode "child"

    (self possibleChildNodeClasses 
       includes:aContentModelNode class)
            ifFalse:[self invalidContentError:'Improper nesting']

    "Created: / 14-05-2005 / 20:20:23 / janfrog"
!

possibleChildNodeClasses

    ^(ContentModelNode allSubclasses)
        add:RefNode;
        yourself

    "Created: / 14-05-2005 / 20:21:11 / janfrog"
    "Modified: / 16-05-2005 / 09:22:12 / masca"
! !

!ContentModelNode methodsFor:'error reporting'!

invalidContentError:aString

    ^SchemaParsingError raiseErrorString:aString

    "Created: / 14-05-2005 / 20:29:38 / janfrog"
! !

!ContentModelNode methodsFor:'initialization'!

initialize

    prev := next := firstChild := TerminatorNode default .
    inDefine := false.

    "Created: / 30-04-2005 / 14:25:36 / janfrog"
    "Modified: / 12-05-2005 / 12:13:34 / masca"
!

postParseFor:aSchema
    "Sent right after content was parsed. aSchema is schema
     for which I'm for. Usefull mainly for PatternNode"

    "Nothing to do"

    "Created: / 30-04-2005 / 19:09:12 / janfrog"
! !

!ContentModelNode methodsFor:'printing'!

groupModifierCharacter

    "Answers character used as group modifier"

    ^self subclassResponsibility

    "Created: / 30-04-2005 / 18:53:46 / janfrog"
!

printChildrenOn:aStream 
    self firstChild isTerminatorNode ifTrue:[
        ^aStream nextPut:$e.
    ].
    self children 
        do:[:childNode | childNode printOn:aStream ]
        separatedBy:[
            aStream
                nextPut:$,;
                space
        ]

    "Created: / 30-04-2005 / 17:14:53 / janfrog"
!

printOn:aStream 

            aStream nextPut:$(.
            self printChildrenOn:aStream.
            aStream nextPut:$).
   aStream nextPut:self groupModifierCharacter

    "Created: / 30-04-2005 / 17:47:39 / janfrog"
    "Modified: / 30-04-2005 / 19:03:15 / janfrog"
! !

!ContentModelNode methodsFor:'testing'!

canBeEmpty

    ^self isEmpty or:[
        self children allSatisfy:[:child|child canBeEmpty]
    ]

    "Created: / 02-05-2005 / 12:03:01 / janfrog"
!

isChoiceNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isEmpty

    ^firstChild isTerminatorNode

    "Created: / 30-04-2005 / 14:56:32 / janfrog"
!

isEmptyNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isGroupNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isOneOrMoreNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isOptionalNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
!

isPatternNode
    ^ false

    "Modified: / 14-05-2005 / 20:47:45 / janfrog"
!

isRefNode

    ^false

    "Created: / 16-05-2005 / 09:25:32 / masca"
!

isRepeatingNode

    ^false

    "Created: / 14-05-2005 / 21:29:59 / janfrog"
!

isTerminatorNode

    ^false

    "Created: / 30-04-2005 / 13:46:36 / janfrog"
!

isZeroOrMoreNode
    ^ false

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!ContentModelNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ContentModelNode.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
