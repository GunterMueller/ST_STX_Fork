"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ComplexPattern subclass:#ModifiedPattern
	instanceVariableNames:'node modification'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

ModifiedPattern comment:'XML element content declarations can have certain optional characters following an element
name or pattern. These characters govern whether the element or the content particle may occur
one or more (+), zero or more (*), or zero or one (?) times in the element content. This class
represents these patterns or rules

Instance Variables:
	node    <XML.Pattern>
	modification    <Character> Optional character denoting content element occurances
'
!


!ModifiedPattern class methodsFor:'instance creation'!

on: aNode type: t

	^self new on: aNode type: t
! !

!ModifiedPattern methodsFor:'accessing'!

name
    ^ node name
!

node
    ^ node
! !

!ModifiedPattern methodsFor:'coercing'!

alternateHeads

        ^(modification == $* or: [modification == $?])
                ifTrue: [followSet copyWith: node]
                ifFalse: [Array with: node]
!

pushDownFollowSet

        (modification == $+ or: [modification == $*])
                ifTrue: [node addFollow: self].
        node addFollows: followSet.
        ^Array with: node
! !

!ModifiedPattern methodsFor:'initialization'!

on: aNode type: t

	node := aNode.
	modification := t.
! !

!ModifiedPattern methodsFor:'queries'!

maxOccurs
    ^ (modification == $*) ifTrue:[1] ifFalse:[nil "unlimited"]
!

minOccurs
    ^ (modification == $? or:[modification == $*]) ifTrue:[0] ifFalse:[1]
! !

!ModifiedPattern methodsFor:'testing'!

isListPattern
    ^ modification == $* or:[modification == $+]
!

isModifiedPattern
    ^ true
!

isOptionalPattern
    ^ modification == $?
! !

!ModifiedPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ModifiedPattern.st,v 1.11 2015-02-13 21:54:06 cg Exp $'


! !

