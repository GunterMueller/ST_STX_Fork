"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#XPathAxis
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
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

version_SVN
    ^ '$Id$'
! !
