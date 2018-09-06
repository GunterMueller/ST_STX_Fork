"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

OrderedCollection subclass:#XPathExpression
	instanceVariableNames:'absolute parent startPosition stopPosition line'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathExpression methodsFor:'accessing'!

absolute
    ^ absolute

    "Created: / 16-11-2007 / 08:35:44 / janfrog"
!

absolute:aBoolean
    absolute := aBoolean.

    "Created: / 16-11-2007 / 08:35:44 / janfrog"
!

line
    ^ line

    "Created: / 01-12-2008 / 16:00:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

line:anInteger
    line := anInteger.

    "Created: / 01-12-2008 / 16:00:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nodeTypeIcon

    ^nil

    "Created: / 17-11-2007 / 14:48:55 / janfrog"
!

nodeTypeName

    ^'XPathExpression'

    "Created: / 17-11-2007 / 14:48:46 / janfrog"
!

parent
    ^ parent

    "Created: / 22-11-2008 / 08:11:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parent:something
    parent := something.

    "Created: / 22-11-2008 / 08:11:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

source

    ^parent 
        ifNil:[nil]
        ifNotNil:[parent source]

    "Created: / 22-11-2008 / 08:11:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

startPosition
    ^ startPosition

    "Created: / 17-11-2007 / 14:41:21 / janfrog"
!

startPosition:anInteger
    startPosition := anInteger.

    "Created: / 17-11-2007 / 14:41:21 / janfrog"
!

stopPosition
    ^ stopPosition

    "Created: / 17-11-2007 / 14:41:21 / janfrog"
!

stopPosition:anInteger
    stopPosition := anInteger.

    "Created: / 17-11-2007 / 14:41:21 / janfrog"
! !


!XPathExpression methodsFor:'debugging'!

childrenDictionary

    | childrenDictionary |
    childrenDictionary := OrderedDictionary new.
    self keysAndValuesDo:
        [:index :locationStep|
        childrenDictionary
            at:'[',index printString,']'
            put: locationStep].
    ^childrenDictionary

    "Created: / 17-11-2007 / 14:42:08 / janfrog"
! !

!XPathExpression methodsFor:'printing'!

displayString

    ^self printString

    "Created: / 15-11-2007 / 22:57:51 / janfrog"
!

printOn: stream

    self 
        do:[:locationStep|locationStep printOn: stream]
        separatedBy:[stream nextPut:$/]

    "Created: / 15-11-2007 / 22:10:10 / janfrog"
! !

!XPathExpression methodsFor:'testing'!

isAbsolute

    ^absolute

    "Created: / 16-11-2007 / 08:36:08 / janfrog"
!

isPerseusASTNode

    ^true

    "Created: / 17-11-2007 / 14:41:48 / janfrog"
! !

!XPathExpression methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathExpression:self

    "Created: / 17-11-2007 / 15:10:43 / janfrog"
! !

!XPathExpression class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathExpression.st,v 1.2 2007-11-18 08:54:48 vranyj1 Exp $'
! !
