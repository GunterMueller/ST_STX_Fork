"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Document subclass:#DocumentFragment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

DocumentFragment comment:'DocumentFragment is a subclass of Document which can be used to model documents which do not correctly conform to the XML standard. Such fragments may contain text that is not contained within any element, or may contain more than one element at the top level.

At present it is not possible to represent a Document fragment that contains the start tag but not the end tag of an element, or contains the end tag but not the start tag.
'
!


!DocumentFragment methodsFor:'accessing'!

addNode: aNode

	nodes add: aNode.
	aNode parent: self.
	aNode isElement
		ifTrue: [root == nil
			ifTrue: [root := aNode]]
! !

!DocumentFragment methodsFor:'enumerating'!

saxDo: aDriver

	aDriver startDocumentFragment.
	self dtd == nil ifFalse: [self dtd saxDo: aDriver].
	1 to: self children size do: [:i |
		(self children at: i) saxDo: aDriver].
	aDriver endDocumentFragment
! !

!DocumentFragment methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitDocumentFragment:self
! !

!DocumentFragment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/DocumentFragment.st,v 1.2 2003-08-22 11:48:58 james Exp $'
! !
