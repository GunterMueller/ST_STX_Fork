"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

DOMImplementation subclass:#XMLSuiteDOM3Implementation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3-Implementation'
!


!XMLSuiteDOM3Implementation methodsFor:'DOM3 interface'!

createDocumentNS:ns qualifiedName:qName doctype:doctype
    "Superclass says that I am responsible to implement this method"

    | doc |
    doc := self createDocument.

    (ns isNil and:[qName isNil and:[doctype isNil]])
        ifFalse:[doc appendChild:(doc createElement:qName ns:ns)].
    ^doc

    "Created: / 11-08-2005 / 16:30:33 / janfrog"
    "Modified: / 28-12-2005 / 16:18:05 / janfrog"
!

createDocumentType:name publicId:publicId systemId:systemId
    "Superclass says that I am responsible to implement this method"

    ^DocumentType new
        setName: name;
        setPublicId: publicId;
        setSystemId: systemId;
        yourself

    "Created: / 24-12-2005 / 10:41:36 / janfrog"
!

getFeature:feature version:version

    self see:'No features implementation yet'.
    ^nil

    "Created: / 19-06-2005 / 15:31:46 / janfrog"
!

hasFeature:feature version:version

    self featureArray pairsDo:[:f :v|
        ((f sameAs: feature) 
            and:[version isNil or:[self isVersionLesserOrEquals: version then: v]])
                ifTrue:[^true]].
    ^false

    "Created: / 19-06-2005 / 15:29:24 / janfrog"
! !

!XMLSuiteDOM3Implementation methodsFor:'accessing'!

featureArray

    ^#(('XML' '3.0') ('Core' '3.0') ('+XML' '3.0') ('+Core' '3.0'))

    "Created: / 19-06-2005 / 15:31:46 / janfrog"
!

saxContentHandlerClass
    "Superclass says that I am responsible to implement this method"

    ^DOM3Builder

    "Created: / 04-08-2005 / 12:54:26 / janfrog"
! !

!XMLSuiteDOM3Implementation methodsFor:'instance creation'!

createDocument
    "Superclass says that I am responsible to implement this method"

    ^Document new

    "Created: / 11-08-2005 / 16:35:55 / janfrog"
    "Modified: / 11-08-2005 / 22:32:10 / janfrog"
!

createDocumentFragment
    "Superclass says that I am responsible to implement this method"

    ^DocumentFragment new setParentNode: self createDocument

    "Created: / 10-12-2006 / 20:35:36 / janfrog"
    "Modified: / 12-04-2007 / 12:08:54 / janfrog"
! !

!XMLSuiteDOM3Implementation methodsFor:'utilities'!

isVersionLesserOrEquals: version1 then: version2

^ ((version1 at: 1) asInteger) <= ((version2 at: 1) asInteger).
! !

!XMLSuiteDOM3Implementation class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLSuiteDOM3Implementation.st,v 1.8 2007-04-12 11:40:04 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
