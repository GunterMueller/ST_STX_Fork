"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#NamePattern
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

NamePattern comment:'This class represents a content constraint in an element type declaration such that the declaration includes the names of the element types that may appear as children in the element''s content

Instance Variables:
	name    <XML.NodeTag>'
!


!NamePattern class methodsFor:'instance creation'!

named: aName

	^self new named: aName
! !

!NamePattern methodsFor:'accessing'!

description

	^name printString
!

name

	^name
! !

!NamePattern methodsFor:'initialization'!

named: aName

	name := aName
! !

!NamePattern methodsFor:'testing'!

matches: aNode
        "trying a simple solution: while validating, we only compare the tag type and prefix.
          this works unless the prefix is reused for different namespaces"
        ^(aNode isElement and:[name isLikeForValidation: aNode tag])
! !

!NamePattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NamePattern.st,v 1.8 2005-05-11 09:28:42 cg Exp $'


! !
