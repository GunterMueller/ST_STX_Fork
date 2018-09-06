"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#ContentModel
	instanceVariableNames:'rootNode initialTransitions'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!ContentModel class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 30-04-2005 / 14:36:27 / janfrog"
! !

!ContentModel methodsFor:'accessing'!

patterns

    ^self rootNode patterns

    "Created: / 30-04-2005 / 13:49:16 / janfrog"
!

rootNode
    ^ rootNode

    "Created: / 30-04-2005 / 13:49:20 / janfrog"
!

rootNode:aContentModelNode 
    "GroupNode for elements, PatternNode for attributes"

    rootNode := aContentModelNode.

    "Created: / 30-04-2005 / 13:49:20 / janfrog"
! !

!ContentModel methodsFor:'initialization'!

initialize

    initialTransitions := Set new.
    rootNode := GroupNode new

    "Created: / 30-04-2005 / 14:36:58 / janfrog"
! !

!ContentModel methodsFor:'printing'!

printOn:aStream

    self rootNode printOn:aStream

    "Created: / 30-04-2005 / 15:05:46 / janfrog"
! !

!ContentModel class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ContentModel.st,v 1.1.1.1 2005-11-01 22:07:12 vranyj1 Exp $'
! !
