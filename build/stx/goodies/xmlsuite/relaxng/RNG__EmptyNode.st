"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

ContentModelNode subclass:#EmptyNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!EmptyNode methodsFor:'accessing'!

addChild:node

    ^self shouldNotImplement

    "Created: / 02-05-2005 / 11:44:16 / janfrog"
!

children

    ^#()

    "Created: / 02-05-2005 / 11:44:31 / janfrog"
! !

!EmptyNode methodsFor:'automaton support'!

patternsThatCanBeFirst
    "Superclass says that I am responsible to implement this method"

    ^#()

    "Created: / 02-05-2005 / 11:42:21 / janfrog"
!

patternsThatCanBeLast
    "Superclass says that I am responsible to implement this method"

    ^#()

    "Created: / 02-05-2005 / 11:42:21 / janfrog"
! !

!EmptyNode methodsFor:'printing'!

groupModifierCharacter
    "Superclass says that I am responsible to implement this method"

    ^Character space

    "Created: / 02-05-2005 / 11:42:21 / janfrog"
!

printOn:aStream

    aStream nextPutAll:'e'

    "Created: / 02-05-2005 / 11:43:35 / janfrog"
! !

!EmptyNode methodsFor:'testing'!

canBeEmpty
    ^true

    "Created: / 02-05-2005 / 12:03:59 / janfrog"
!

isEmptyNode
    ^ true

    "Created: / 14-05-2005 / 20:47:45 / janfrog"
! !

!EmptyNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitEmptyNode:self

    "Created: / 02-05-2005 / 16:38:45 / janfrog"
! !

!EmptyNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__EmptyNode.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
