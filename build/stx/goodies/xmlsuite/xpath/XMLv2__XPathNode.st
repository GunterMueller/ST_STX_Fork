"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathNode
	instanceVariableNames:'adaptorData adaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!

Object subclass:#XPathNodePosition
	instanceVariableNames:'tagPosition attributePosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XPathNode
!


!XPathNode methodsFor:'accessing'!

adaptor:something
    adaptor := something.
!

adaptorData
    ^ adaptorData
!

adaptorData:something
    adaptorData := something.
!

principalNodeType
    ^ adaptor principalNodeTypeOfNode: self.
! !

!XPathNode methodsFor:'node operations'!

documentPositionVector
    ^ adaptor documentPositionVectorOfNode:self.
!

identityHash
    ^ adaptor identityHashOfNode:self.
!

name
    ^ adaptor nameOfNode:self.
!

parent
    ^ adaptor parentOfNode:self.
!

position
    ^ adaptor positionOfNode:self.
!

subnodes
    ^ adaptor subnodesOfNode:self withType:#node.
!

subnodesOfType:aType
    ^ adaptor subnodesOfNode:self withType:aType.
!

text
    ^ adaptor textOfNode:self.
!

value
    ^ adaptor valueOfNode:self.
! !

!XPathNode methodsFor:'printing'!

printOn:aStream 
    ^ adaptorData printOn:aStream.
! !

!XPathNode methodsFor:'type'!

isAttribute
   ^ adaptor isNodeAttribute:self.
!

isComment
   ^ adaptor isNodeComment:self.
!

isDocument
   ^ adaptor isNodeDocument:self.
!

isElement
   ^ adaptor isNodeElement:self.
!

isText
   ^ adaptor isNodeText:self.
! !

!XPathNode::XPathNodePosition class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!XPathNode::XPathNodePosition methodsFor:'accessing'!

attributePosition
    ^ attributePosition
!

attributePosition:something
    attributePosition := something.
!

tagPosition
    ^ tagPosition
!

tagPosition:something
    tagPosition := something.
! !

!XPathNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathNode.st,v 1.1 2006-09-28 16:15:17 vranyj1 Exp $'
! !
