"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

OrderedCollection subclass:#NodeList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!NodeList methodsFor:'DOM3 interface'!

item:index

    ^self at:index + 1

    "Created: / 08-05-2005 / 18:34:14 / janfrog"
    "Modified: / 23-12-2005 / 20:37:17 / janfrog"
!

length

    ^self size

    "Created: / 08-05-2005 / 18:34:21 / janfrog"
! !

!NodeList methodsFor:'accessing'!

nodeWithLocalName:localName 

    ^self nodeWithLocalName:localName ifAbsent:[nil]

    "Created: / 16-06-2005 / 15:56:06 / janfrog"
!

nodeWithLocalName:localName ifAbsent:aBlock 
    |candidates|

    candidates := self nodesWithLocalName:localName.
    candidates size > 1 ifTrue:[^ self error:'Multiple nodes with localName ' , localName].
    candidates size < 1 ifTrue:[^ aBlock value].
    ^ candidates first

    "Created: / 16-06-2005 / 15:57:28 / janfrog"
!

nodesWithLocalName:localName 

    ^self select:[:node|node localName = localName]

    "Created: / 16-06-2005 / 15:51:19 / janfrog"
!

nodesWithQName:qName 

    ^self select:[:node|node qualifiedName = qName]

    "Created: / 15-07-2010 / 12:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodesWithQName:qName on: nodeStream 

    ^self nodesWithQName:qName on: nodeStream recursively: false

    "Created: / 15-07-2010 / 13:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodesWithQName:qName on: nodeStream recursively: recursively 

    ^self do:
        [:node| 
        node qualifiedName = qName 
            ifTrue:[nodeStream nextPut: node].
        recursively 
            ifTrue:[node childNodes 
                        nodesWithQName:qName on: nodeStream 
                        recursively: recursively]]

    "Created: / 15-07-2010 / 13:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodesWithQName:qName recursively: recursively

    ^NodeList streamContents:
        [:nodeStream|
        self nodesWithQName:qName on: nodeStream recursively: recursively].

    "Created: / 15-07-2010 / 13:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodesWithURI:uri localName:localName 
    ^self 
        detect:[:attr | ((attr ns = uri) and:[ attr localName = localName ]) ]
        ifNone:[ nil ]

    "Created: / 16-06-2005 / 15:53:47 / janfrog"
    "Modified: / 17-06-2005 / 09:51:19 / masca"
    "Modified: / 23-12-2005 / 15:24:10 / janfrog"
!

nodesWithURI:uri localName:localName ifNone:aBlock 
    ^self 
        detect:[:attr | ((attr tag namespace = uri) and:[ attr tag type = localName ]) ]
        ifNone:aBlock

    "Created: / 16-06-2005 / 15:55:31 / janfrog"
    "Modified: / 17-06-2005 / 09:51:25 / masca"
! !

!NodeList methodsFor:'adding & removing'!

insert:new after:ref

    "Inserts new right after ref element. If ref is nil or is not in
    myself, add to the end (append)"

    | idx |

    idx := self identityIndexOf:ref.
    idx == 0 
        ifTrue:[self addLast:new]
        ifFalse:[self add:new afterIndex:idx]

    "Created: / 18-06-2005 / 21:55:12 / janfrog"
!

insert:new before:ref

    "Inserts new right after ref element. If ref is nil or is not in
    myself, add to the end (append)"

    | idx |

    idx := self identityIndexOf:ref.
    idx == 0 
        ifTrue:[self addLast:new]
        ifFalse:[self add:new beforeIndex:idx]

    "Created: / 18-06-2005 / 21:55:12 / janfrog"
! !

!NodeList methodsFor:'xpath'!

/ aString

    ^NodeList streamContents:
        [:nodeStream|
        self do:
            [:node|node childNodes nodesWithQName: aString on: nodeStream]].

    "Created: / 15-07-2010 / 12:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

// aString

    ^NodeList streamContents:
        [:nodeStream|
        self do:
            [:node|
            node childNodes 
                nodesWithQName: aString on: nodeStream
                recursively: true]].

    "Created: / 15-07-2010 / 13:47:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

@ aString

    self size == 0 ifTrue:[^nil].
    (self size ~= 1 or: [self first isElement not]) 
        ifTrue:[self error:'Node list doesn''t contain single element node'].

    ^self first @ aString

    "Created: / 15-07-2010 / 13:18:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NodeList class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NodeList.st,v 1.2 2005-12-25 10:54:59 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
