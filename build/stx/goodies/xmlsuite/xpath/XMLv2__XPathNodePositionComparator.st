"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathNodePositionComparator
	instanceVariableNames:'documentAdaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathNodePositionComparator methodsFor:'accessing'!

documentAdaptor:anXPathDocumentAdaptor
    documentAdaptor := anXPathDocumentAdaptor.

    "Created: / 13-10-2006 / 19:52:50 / janfrog"
! !

!XPathNodePositionComparator methodsFor:'block mimicry'!

numArgs

    ^2

    "Created: / 13-10-2006 / 19:54:38 / janfrog"
! !

!XPathNodePositionComparator methodsFor:'evaluation'!

value: a value: b

    | aPos bPos |

    aPos := documentAdaptor xpathPositionVectorOf: a.
    bPos := documentAdaptor xpathPositionVectorOf: b.

    1 to: (aPos elementPosition size min:bPos elementPosition size) do:
        [:i|
        (aPos elementPosition at:i) < (bPos elementPosition at:i) ifTrue:[^true].
        (aPos elementPosition at:i) > (bPos elementPosition at:i) ifTrue:[^false]].

    (aPos elementPosition size) < (bPos elementPosition size) ifTrue:[^true].
    (aPos elementPosition size) > (bPos elementPosition size) ifTrue:[^false].

    1 to: (aPos attributePosition size min:bPos attributePosition size) do:
        [:i|
        (aPos attributePosition at:i) < (bPos attributePosition at:i) ifTrue:[^true].
        (aPos attributePosition at:i) > (bPos attributePosition at:i) ifTrue:[^false]].

    (aPos attributePosition size) < (bPos attributePosition size) ifTrue:[^true].
    (aPos attributePosition size) > (bPos attributePosition size) ifTrue:[^false].

    ^false

    "Created: / 13-10-2006 / 19:50:59 / janfrog"
! !

!XPathNodePositionComparator class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathNodePositionComparator.st,v 1.1 2006-10-14 05:41:53 vranyj1 Exp $'
! !
