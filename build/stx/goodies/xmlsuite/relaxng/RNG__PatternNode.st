"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#PatternNode
	instanceVariableNames:'pattern'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!PatternNode class methodsFor:'instance creation'!

for:aPattern

    ^self new pattern:aPattern

    "Created: / 30-04-2005 / 17:28:22 / janfrog"
! !

!PatternNode methodsFor:'accessing'!

pattern
    ^ pattern

    "Created: / 30-04-2005 / 14:35:09 / janfrog"
!

pattern:aPattern

    pattern := aPattern.
    pattern node:self.

    "Created: / 30-04-2005 / 17:28:43 / janfrog"
!

pcDataContentPattern

    | children |    
    ((children := self children) size = 1 
        and:[children first pattern isPCDataPattern])
        ifTrue:[^children first pattern]
        ifFalse:[self error:'Not a #pcdata content']

    "Created: / 02-05-2005 / 17:29:03 / janfrog"
! !

!PatternNode methodsFor:'automaton support'!

contentModelFinalPatterns

    "Answers set of patterns, that may be last in my
     content model"

    ^self lastChild patternsThatCanBeLast

    "Created: / 30-04-2005 / 21:00:57 / janfrog"
!

contentModelInitialPatterns

    "Answers set of patterns, that may be first in my
     content model"

    ^self firstChild patternsThatCanBeFirst

    "Created: / 30-04-2005 / 21:00:30 / janfrog"
!

patternsThatCanBeFirst
    ^Set with:self pattern

    "Created: / 30-04-2005 / 21:02:00 / janfrog"
!

patternsThatCanBeLast

    ^Set with:self pattern

    "Created: / 30-04-2005 / 21:01:45 / janfrog"
! !

!PatternNode methodsFor:'checking'!

checkContents

    self pattern isForAttribute
        ifTrue:[
            ((self children size ~= 1) or:[self firstChild isPatternNode not])
                ifTrue:[self invalidContentError:'Only one #pcdata pattern allowed for attributes'].
    ]

    "Created: / 14-05-2005 / 20:29:02 / janfrog"
!

possibleChildNodeClasses

    self pattern isForAttribute ifTrue:[
        ^Set with:PatternNode].

    self pattern isListPattern ifTrue:[

        self firstChild isPatternNode 
            ifTrue:[^Set with:PatternNode].
        self firstChild isTerminatorNode
            ifTrue:[^Set
                        with:PatternNode
                        with:OneOrMoreNode 
                        with:ZeroOrMoreNode].
        ^#()
    ].

    ^super possibleChildNodeClasses

    "Modified: / 14-05-2005 / 21:08:49 / janfrog"
! !

!PatternNode methodsFor:'copying'!

postCopy

    pattern := pattern copy.
    pattern node:self.

    "Created: / 13-05-2005 / 15:36:48 / masca"
! !

!PatternNode methodsFor:'initialization'!

postParseFor:aSchema

    self pattern postParseFor:aSchema.

    "Modified: / 14-05-2005 / 21:20:05 / janfrog"
! !

!PatternNode methodsFor:'printing'!

printOn:aStream

    aStream nextPutAll:self pattern nameForPrint.

    "Created: / 30-04-2005 / 15:04:53 / janfrog"
    "Modified: / 30-04-2005 / 19:14:16 / janfrog"
! !

!PatternNode methodsFor:'testing'!

isPatternNode
    ^ true

    "Modified: / 14-05-2005 / 20:47:45 / janfrog"
!

isPatternNodeForComplexType

    ^self pattern isComplexTypePattern

    "Created: / 14-05-2005 / 20:49:27 / janfrog"
    "Modified: / 16-05-2005 / 09:31:17 / masca"
!

isPatternNodeForList

    ^self pattern isListPattern

    "Created: / 14-05-2005 / 20:48:59 / janfrog"
    "Modified: / 16-05-2005 / 09:31:23 / masca"
!

isPatternNodeForPCData

    ^self pattern isPCDataPattern

    "Created: / 14-05-2005 / 20:49:14 / janfrog"
    "Modified: / 16-05-2005 / 09:31:27 / masca"
! !

!PatternNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitPatternNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!PatternNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__PatternNode.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !
