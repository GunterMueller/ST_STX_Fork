"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

NamedNodeMap subclass:#Attributes
	instanceVariableNames:'ownerElement'
	classVariableNames:'EmptyAttributes'
	poolDictionaries:''
	category:'XML Suite-SAX2'
!


!Attributes class methodsFor:'instance creation'!

empty

    "EmptyAttributes ifNil:[EmptyAttributes := self new].
    ^EmptyAttributes"
    ^self new:0

    "Created: / 16-04-2005 / 20:12:53 / janfrog"
    "Modified: / 12-04-2007 / 10:45:31 / janfrog"
! !

!Attributes methodsFor:'SAX2 interface'!

getIndexByQualifiedName:qName

    self keysAndValuesDo:[:index :attribute |
        attribute qualifiedName = qName ifTrue:[^index]
    ].
    ^-1 "Should return 0?"

    "Created: / 16-04-2005 / 20:15:45 / janfrog"
    "Modified: / 11-05-2005 / 19:35:10 / janfrog"
!

getIndexByURI:uri localName:localName

    self keysAndValuesDo:[:index :attr |
        ((attr ns = uri) and:[attr name = localName]) ifTrue:[^index]
    ].
    ^-1 "Should return 0?"

    "Created: / 16-04-2005 / 20:17:54 / janfrog"
    "Modified: / 11-05-2005 / 19:35:40 / janfrog"
!

getLength

    ^self size

    "Created: / 16-04-2005 / 20:18:26 / janfrog"
    "Modified: / 11-05-2005 / 19:37:25 / janfrog"
!

getLocalName:index

    ^(self at:index) name

    "Created: / 16-04-2005 / 20:19:28 / janfrog"
    "Modified: / 11-05-2005 / 19:37:31 / janfrog"
!

getQName:index

    ^(self at:index) qualifiedName

    "Created: / 16-04-2005 / 20:19:41 / janfrog"
    "Modified: / 11-05-2005 / 19:37:39 / janfrog"
!

getTypeByIndex:index

    ^'NMToken'

    "Created: / 16-04-2005 / 20:20:46 / janfrog"
!

getTypeByQualifiedName:qName

    ^'NMToken'

    "Created: / 16-04-2005 / 20:21:02 / janfrog"
!

getTypeByURI:uri localName:localName

    ^'NMToken'

    "Created: / 16-04-2005 / 20:21:17 / janfrog"
!

getURI:index

    (self at:index) ns

    "Created: / 16-04-2005 / 20:22:49 / janfrog"
    "Modified: / 11-05-2005 / 19:38:05 / janfrog"
!

getValueByIndex:index

    (self at:index) value

    "Created: / 16-04-2005 / 20:23:15 / janfrog"
    "Modified: / 11-05-2005 / 19:38:13 / janfrog"
!

getValueByQualifiedName:qName

    self do:[:att | att qualifiedName = qName ifTrue:[^att value]].
    ^nil

    "Created: / 16-04-2005 / 20:24:19 / janfrog"
    "Modified: / 11-05-2005 / 19:38:21 / janfrog"
!

getValueByURI:uri localName:localName 
    |attr|

    ^ (attr := self nodesWithURI:uri localName:localName) 
        ifNotNil:[ attr value ]

    "Created: / 16-04-2005 / 20:24:57 / janfrog"
    "Modified: / 16-06-2005 / 15:53:47 / janfrog"
! !

!Attributes methodsFor:'SAX2 interface - extensions'!

getValueByLocalName:localName 
    |attr|

    ^ (attr := self nodesWithLocalName:localName) ifNotNil:[ attr value ]

    "Created: / 16-06-2005 / 14:02:58 / janfrog"
    "Modified: / 16-06-2005 / 15:54:32 / janfrog"
! !

!Attributes methodsFor:'accessing'!

at: indexOrString

    | node |

    ^indexOrString isInteger 
        ifTrue:
            [super at: indexOrString]
        ifFalse:
            [node := self nodeWithLocalName:indexOrString ifAbsent:[^self subscriptBoundsError:indexOrString].
            node value]

    "Created: / 28-04-2011 / 12:25:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: indexOrString ifAbsent: block

    | node |

    ^indexOrString isInteger 
        ifTrue:
            [super at: indexOrString ifAbsent: block]
        ifFalse:
            [node := self nodeWithLocalName:indexOrString ifAbsent:[^block value].
            node value]

    "Created: / 28-04-2011 / 12:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicAt: index put: anAttr

    "Quite dirty hack"

    | oldElement |
    self ensureIsAttrOrNil: anAttr.
    oldElement := self basicAt: index.
    self ensureIsAttrOrNil: oldElement.
    oldElement ifNotNil:[oldElement setOwnerElement: nil].
    anAttr setOwnerElement: ownerElement.
    ^super basicAt: index put: anAttr

    "Created: / 12-11-2007 / 18:15:10 / janfrog"
!

ownerElement
    ^ ownerElement

    "Created: / 12-11-2007 / 18:14:52 / janfrog"
! !

!Attributes methodsFor:'adding & removing'!

addAttribute: localName namespace: ns qname: qname value: value

    self add:
        (Attr new
            qualifiedName: qname;
            ns: ns;
            value: value)

    "Created: / 06-04-2009 / 13:48:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Attributes methodsFor:'error handling'!

ensureIsAttrOrNil: anAttrOrNil

    anAttrOrNil ifNil:[^self].
    (anAttrOrNil isKindOf: Attr) ifFalse:
        [self error:'Not an instance of XMLv2::Attr: ', anAttrOrNil printString].

    "Created: / 12-11-2007 / 18:35:02 / janfrog"
! !

!Attributes methodsFor:'initialization'!

setOwnerElement: anElementOrNil

    ownerElement := anElementOrNil .
    self do:[:attr|attr setOwnerElement: anElementOrNil].

    "Created: / 12-11-2007 / 18:40:18 / janfrog"
! !

!Attributes class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Attributes.st,v 1.4 2007-11-12 20:23:36 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
