"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

SingletonObject subclass:#TerminatorNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!TerminatorNode methodsFor:'accessing'!

next
    ^self

    "Created: / 30-04-2005 / 14:09:31 / janfrog"
!

parent

    ^self shouldNotImplement

    "Created: / 30-04-2005 / 14:09:43 / janfrog"
!

prev
    ^self

    "Created: / 30-04-2005 / 14:09:28 / janfrog"
! !

!TerminatorNode methodsFor:'automaton support'!

patternsThatCanBeFirst

    ^#()

    "Created: / 30-04-2005 / 21:01:27 / janfrog"
!

patternsThatCanBeLast

    ^#()

    "Created: / 30-04-2005 / 21:01:20 / janfrog"
! !

!TerminatorNode methodsFor:'testing'!

isPatternNode
    ^false

    "Created: / 30-04-2005 / 13:50:42 / janfrog"
!

isTerminatorNode

    ^true

    "Created: / 30-04-2005 / 13:46:46 / janfrog"
! !

!TerminatorNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__TerminatorNode.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
