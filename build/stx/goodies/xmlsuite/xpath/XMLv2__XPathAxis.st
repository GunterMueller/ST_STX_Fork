"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathASTNode subclass:#XPathAxis
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Axes'
!


!XPathAxis class methodsFor:'instance creation'!

getAxisOfType:anAxisTypeSymbol 
    (anAxisTypeSymbol = 'child::') ifTrue:[
        ^ XPathAxisChild new
    ].
    (anAxisTypeSymbol = 'descendant::') ifTrue:[
        ^ XPathAxisDescendant new
    ].
    (anAxisTypeSymbol = 'descendant-or-self::') ifTrue:[
        ^ XPathAxisDescendantOrSelf new
    ].
    (anAxisTypeSymbol = 'parent::') ifTrue:[
        ^ XPathAxisParent new
    ].
    (anAxisTypeSymbol = 'self::') ifTrue:[
        ^ XPathAxisSelf new
    ].
    (anAxisTypeSymbol = '@') ifTrue:[
        ^ XPathAxisAttribute new
    ].
! !

!XPathAxis methodsFor:'queries'!

principalNodeType
        ^ #element.
! !

!XPathAxis methodsFor:'testing'!

isXPathAxisAncestor
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisAncestorOrSelf
    ^ false

    "Created: / 16-11-2007 / 09:26:02 / janfrog"
!

isXPathAxisAttribute
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisChild
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisDescendant
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisDescendantOrSelf
    ^ false

    "Created: / 16-11-2007 / 09:26:11 / janfrog"
!

isXPathAxisFollowing
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisFollowingSibling
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisParent
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisPreceding
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisPrecedingSibling
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
!

isXPathAxisSelf
    ^ false

    "Created: / 16-11-2007 / 09:25:08 / janfrog"
! !

!XPathAxis class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathAxis.st,v 1.3 2007-11-16 09:25:59 vranyj1 Exp $'
! !
