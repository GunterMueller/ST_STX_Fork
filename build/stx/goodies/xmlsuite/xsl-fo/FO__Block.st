"{ Package: 'stx:goodies/xmlsuite/xsl-fo' }"

"{ NameSpace: FO }"

ContainerElement subclass:#Block
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'FO'
!


!Block class methodsFor:'accessing'!

localName
    "Superclass says that I am responsible to implement this method"

    ^'block'

    "Created: / 07-04-2007 / 10:00:10 / janfrog"
! !

!Block methodsFor:'accessing - dimensions'!

preferredContentHeight

    ^self isTextOnlyBlock 
            ifTrue:
                [self preferredTextHeight]
            ifFalse:
                [super preferredContentHeight]

    "Created: / 07-04-2007 / 15:37:11 / janfrog"
!

preferredContentWidth

    ^self isTextOnlyBlock 
            ifTrue:
                [self preferredTextWidth]
            ifFalse:
                [super preferredContentWidth]

    "Created: / 07-04-2007 / 15:36:42 / janfrog"
!

preferredTextHeight

    ^self fontLineSkipPx

    "Created: / 07-04-2007 / 15:37:32 / janfrog"
!

preferredTextWidth

    ^self font widthOf:self textContent

    "Created: / 07-04-2007 / 15:37:52 / janfrog"
! !

!Block methodsFor:'accessing - font'!

font

    ^Font 
        family:self fontFamily
        face:'medium' 
        style:'roman' 
        size:self fontSize
        encoding:#'iso10646-1'

    "Created: / 07-04-2007 / 10:26:36 / janfrog"
!

fontFamily

    ^self getStringProperty: 'font-family' ifAbsent:['helvetica']

    "Created: / 07-04-2007 / 10:52:15 / janfrog"
!

fontLineSkipPx

    ^(self fontSize * 1.2) rounded

    "Created: / 07-04-2007 / 11:00:29 / janfrog"
    "Modified: / 08-04-2007 / 09:26:12 / janfrog"
!

fontSize

    ^self getIntegerProperty: 'font-size' ifAbsent:[12]

    "Created: / 07-04-2007 / 10:51:14 / janfrog"
! !

!Block methodsFor:'layout computation'!

layoutChildren

    self isContainerBlock ifTrue:[super layoutChildren]

    "Created: / 07-04-2007 / 23:15:21 / janfrog"
! !

!Block methodsFor:'rendering'!

acceptRenderer: aRenderer

    aRenderer renderBlock: self

    "Created: / 07-04-2007 / 10:33:46 / janfrog"
! !

!Block methodsFor:'testing'!

isContainerBlock

    ^self childNodes allSatisfy: 
        [:child|child isElement or:[child isIgnorableText]]

    "Created: / 07-04-2007 / 15:24:52 / janfrog"
!

isTextOnlyBlock

    ^self childNodes allSatisfy: [:child|child isElement not]

    "Created: / 07-04-2007 / 15:24:30 / janfrog"
! !

!Block class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xsl-fo/FO__Block.st,v 1.1 2007-04-13 15:40:23 vranyj1 Exp $'
! !
