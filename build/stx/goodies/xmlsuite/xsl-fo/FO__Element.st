"{ Package: 'stx:goodies/xmlsuite/xsl-fo' }"

"{ NameSpace: FO }"

XMLv2::Element subclass:#Element
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'FO'
!


!Element class methodsFor:'accessing'!

allElementClasses

    ^self allSubclasses select:[:e|e isAbstract not]

    "Created: / 07-04-2007 / 09:55:56 / janfrog"
!

isAbstract

    ^self == FO::Element

    "Created: / 07-04-2007 / 09:54:32 / janfrog"
!

localName

    ^self subclassResponsibility

    "Created: / 07-04-2007 / 09:54:14 / janfrog"
! !

!Element methodsFor:'DOM3 interface - extensions'!

appendBlock

    | block |

    self appendChild:(block := self ownerDocument createElement: 'block' ns: self namespaceURI).
    ^block

    "Created: / 09-04-2007 / 10:42:41 / janfrog"
!

appendText: aString

    ^self appendChild:(self ownerDocument createTextNode: aString)

    "Created: / 07-04-2007 / 10:02:47 / janfrog"
! !

!Element methodsFor:'accessing - properties'!

getCompositeProperty:localName ifAbsent: aBlock

    ^((self getProperty: localName ifAbsent:[^aBlock value])
        tokensBasedOn:Character space) reject:[:e|e isEmpty]

    "Created: / 07-04-2007 / 16:42:30 / janfrog"
!

getDimensionProperty:localName ifAbsent: aBlock

    ^(Unit fromString: (self getStringProperty: localName ifAbsent:[^aBlock value]))
        inPixels value

    "Created: / 07-04-2007 / 16:18:53 / janfrog"
    "Modified: / 07-04-2007 / 23:03:16 / janfrog"
!

getFirstCompositeProperty:localName ifAbsent: aBlock

    ^(self getCompositeProperty: localName ifAbsent: aBlock) first

    "Created: / 07-04-2007 / 16:55:00 / janfrog"
!

getIntegerProperty:localName ifAbsent: aBlock

    ^(self getProperty: localName ifAbsent:[^aBlock value])
        asInteger

    "Created: / 07-04-2007 / 10:50:52 / janfrog"
!

getProperty:localName ifAbsent: aBlock

    ^(attributes getValueByURI:self namespaceURI localName:localName)
        ifNil:aBlock

    "Created: / 07-04-2007 / 10:48:43 / janfrog"
!

getSecondCompositeProperty:localName ifAbsent: aBlock

    ^(self getCompositeProperty: localName ifAbsent: aBlock) second

    "Created: / 07-04-2007 / 16:55:06 / janfrog"
!

getStringProperty:localName ifAbsent: aBlock

    ^self getProperty: localName ifAbsent:aBlock

    "Created: / 07-04-2007 / 10:52:08 / janfrog"
!

getThirdCompositeProperty:localName ifAbsent: aBlock

    ^(self getCompositeProperty: localName ifAbsent: aBlock) third

    "Created: / 07-04-2007 / 16:55:15 / janfrog"
! !

!Element methodsFor:'children'!

foChildNodes

    ^self childNodes select:[:child|child isKindOf:FO::Element]

    "Created: / 07-04-2007 / 15:18:06 / janfrog"
! !

!Element methodsFor:'children hooks'!

onInsertChild: childNode before: refNode

    self ownerDocument 
            changed:#hierarchy
            with: childNode
            "/from: self

    "Created: / 07-04-2007 / 11:12:09 / janfrog"
! !

!Element methodsFor:'rendering'!

acceptRenderer: aRenderer

    ^self subclassResponsibility

    "Created: / 07-04-2007 / 10:33:13 / janfrog"
! !

!Element methodsFor:'testing'!

isBlockLike

    ^false

    "Created: / 07-04-2007 / 14:29:54 / janfrog"
! !

!Element class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xsl-fo/FO__Element.st,v 1.1 2007-04-13 15:39:25 vranyj1 Exp $'
! !
