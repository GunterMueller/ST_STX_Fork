"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

DOMImplementation subclass:#CincomImplementation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3-Implementation'
!


!CincomImplementation methodsFor:'DOM3 interface'!

createDocumentNS:ns qualifiedName:qName doctype:documentType
    "Superclass says that I am responsible to implement this method"

    | prefix localName colonIndex |
    (colonIndex := qName lastIndexOf:$:) isZero ifTrue:[
        prefix := ''.
        localName := qName
    ] ifFalse:[
        prefix := qName copyTo:colonIndex - 1.
        localName := qName copyFrom:colonIndex - 1.
    ].

    ^self createDocument
        addNode:(XML::Element tag:(XML::NodeTag new qualifier:prefix ns:ns type:localName))

    "Created: / 11-08-2005 / 16:30:33 / janfrog"
    "Modified: / 11-08-2005 / 22:32:10 / janfrog"
!

createDocumentType:arg1 publicId:arg2 systemId:arg3 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 24-12-2005 / 10:41:19 / janfrog"
!

getFeature:feature version:version

    ^nil "no features"

    "Created: / 19-06-2005 / 15:35:43 / janfrog"
! !

!CincomImplementation methodsFor:'accessing'!

featureArray

    ^#(
        ('XML' '1.0')
    )

    "Modified: / 04-08-2005 / 11:56:56 / janfrog"
!

saxContentHandlerClass

    ^DOMBuilder

    "Created: / 04-08-2005 / 12:53:53 / janfrog"
! !

!CincomImplementation methodsFor:'instance creation'!

createDocument
    "Superclass says that I am responsible to implement this method"

    ^XML::Document new

    "Created: / 11-08-2005 / 16:35:55 / janfrog"
    "Modified: / 11-08-2005 / 22:32:10 / janfrog"
! !

!CincomImplementation class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__CincomImplementation.st,v 1.2 2005-12-25 10:55:33 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

