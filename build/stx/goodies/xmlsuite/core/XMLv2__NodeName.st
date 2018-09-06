"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#NodeName
	instanceVariableNames:'ns localName prefix'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Support'
!


!NodeName class methodsFor:'instance creation'!

fromCincomNodeTag: aNodeTag

    ^self new
        ns: aNodeTag namespace;
        prefix: aNodeTag qualifier;
        localName: aNodeTag type

    "Created: / 21-12-2005 / 17:34:45 / janfrog"
!

fromString: aString

    | idx prefix localName |
    idx := aString lastIndexOf: $: .
    idx isZero 
        ifFalse:
            [prefix := aString copyTo: idx - 1. 
            localName := aString copyFrom: idx + 1]
        ifTrue:
            [localName := aString].

    ^self new
        prefix: prefix;
        localName: localName;
        yourself

    "Created: / 08-10-2006 / 15:11:24 / janfrog"
!

fromString: aString andPrefixToNamespaceURIMapping: aDictionary

    ^self fromString: aString andPrefixToNamespaceURIMapping: aDictionary defaultNS:''

    "Created: / 24-12-2006 / 16:06:02 / janfrog"
    "Modified: / 28-12-2006 / 12:37:48 / janfrog"
!

fromString: aString andPrefixToNamespaceURIMapping: aDictionary defaultNS: default

    | nodeName|
    nodeName := self fromString: aString.
    nodeName ns:
        (aDictionary 
            at:nodeName prefix 
            ifAbsent:[
                nodeName prefix isNilOrEmptyCollection 
                    ifTrue:[default]
                    ifFalse:[self error:'Prefix ',nodeName prefix printString,' not defined']]).
    ^nodeName

    "Created: / 28-12-2006 / 12:37:27 / janfrog"
! !

!NodeName methodsFor:'accessing'!

localName
    ^ localName

    "Created: / 28-06-2005 / 23:33:12 / janfrog"
!

localName:aString

    localName := aString

    "Created: / 28-06-2005 / 23:33:40 / janfrog"
!

ns
    ^ ns

    "Created: / 16-04-2005 / 12:56:07 / janfrog"
!

ns:something
    ns := something.

    "Created: / 16-04-2005 / 12:56:07 / janfrog"
!

prefix
    ^ prefix ? ''

    "Created: / 28-06-2005 / 23:36:16 / janfrog"
    "Modified: / 10-04-2007 / 11:56:14 / janfrog"
!

prefix:aString
    prefix := aString.

    "Created: / 28-06-2005 / 23:36:22 / janfrog"
!

qualifiedName

    localName isEmptyOrNil ifTrue:[ 
        ^DOMException 
            raiseErrorString:'node name has no localName'
            withCode:#SYNTAX_ERR
    ].
            

    ^prefix isNilOrEmptyCollection 
        ifTrue:[localName]
        ifFalse:[prefix , ':' , localName]

    "Created: / 16-04-2005 / 13:04:14 / janfrog"
    "Modified: / 28-06-2005 / 23:38:48 / janfrog"
!

qualifiedName:qualifiedName

    | colonIndex |
    colonIndex := qualifiedName lastIndexOf:$:.
    ((colonIndex = 1) or:[colonIndex = qualifiedName size]) ifTrue:[
        DOMException 
            raiseErrorString:('Invalid qualified name: ',qualifiedName)
            withCode:#SYNTAX_ERR
    ].

    colonIndex isZero ifTrue:[
        localName := qualifiedName
    ] ifFalse:[
        prefix := qualifiedName copyTo:colonIndex - 1.
        localName := qualifiedName copyFrom:colonIndex + 1.
    ]

    "Created: / 28-06-2005 / 22:51:01 / janfrog"
! !

!NodeName methodsFor:'converting'!

asString

    ^self qualifiedName

    "Created: / 22-04-2005 / 21:59:25 / janfrog"
! !

!NodeName methodsFor:'printing'!

printOn:aStream

    aStream 
        nextPut:${;
        nextPutAll:self qualifiedName;
        nextPut:$}

    "Created: / 16-04-2005 / 22:00:02 / janfrog"
! !

!NodeName class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NodeName.st,v 1.5 2007-04-10 13:36:06 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
