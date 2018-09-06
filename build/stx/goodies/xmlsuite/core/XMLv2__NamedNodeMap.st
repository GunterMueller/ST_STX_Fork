"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

NodeList subclass:#NamedNodeMap
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!NamedNodeMap methodsFor:'DOM3 interface'!

getNamedItem:name

    ^self 
        detect:[:i| name = i localName "defined in Node"]
        ifNone:[nil]

    "Created: / 11-05-2005 / 19:18:32 / janfrog"
!

getNamedItem:name ns:ns

    ^self 
        detect:[:i| (name = i localName) "defined in Node"
                        and:[ns = i namespaceURI]] "defined in Node"
        ifNone:[nil]

    "Created: / 11-05-2005 / 19:24:18 / janfrog"
!

removeNamedItem:name

    | oldItem |
    oldItem := self getNamedItem:name.
    oldItem ifNotNil:[
        self remove:oldItem
    ]

    "Created: / 11-05-2005 / 19:22:34 / janfrog"
!

removeNamedItem:name ns:ns

    | oldItem |
    oldItem := self getNamedItem:name ns:ns.
    oldItem ifNotNil:[
        self remove:oldItem
    ]

    "Created: / 11-05-2005 / 19:22:57 / janfrog"
!

setNamedItem:node

    | oldItem |
    oldItem := self getNamedItem:node localName.
    oldItem ifNotNil:[
        self at:(self identityIndexOf:oldItem) put:node
    ] ifNil:[
        self add:node
    ]

    "Created: / 11-05-2005 / 19:21:34 / janfrog"
!

setNamedItem:node ns:ns

    | oldItem |
    oldItem := self getNamedItem:node localName ns:node namespaceURI.
    oldItem ifNotNil:[
        self at:(self identityIndexOf:oldItem) put:node
    ] ifNil:[
        self add:node
    ]

    "Created: / 11-05-2005 / 19:23:34 / janfrog"
! !

!NamedNodeMap methodsFor:'DOM3 interface - extensions'!

getQualifiedNamedItem:name

    ^self 
        detect:[:i| (name = i qualifiedName) ] "defined in Node"
        ifNone:[nil]

    "Created: / 25-10-2005 / 17:07:06 / janfrog"
! !

!NamedNodeMap methodsFor:'comparing'!

= anotherNamedNodeMap
    ^ super = anotherNamedNodeMap.

    "| s a |
    s := self. reject: [:x| x = nil].
    a := anotherNamedNodeMap. reject: [:x | x = nil] "
    "Simple but not effective"
    "^anotherNamedNodeMap isCollection
        and:[s contentsArray = a contentsArray]"

    "Created: / 18-06-2005 / 19:59:07 / janfrog"
    "Modified: / 10-10-2006 / 15:10:14 / janfrog"
!

hash

    ^self inject:97 into:[:hash :node|hash bitXor:node hash]

    "Created: / 18-06-2005 / 19:58:05 / janfrog"
! !

!NamedNodeMap class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NamedNodeMap.st,v 1.3 2007-01-10 17:47:03 stillj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
