"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#DocumentType
	instanceVariableNames:'name entities notations publicId systemId internalSubset'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!DocumentType methodsFor:'DOM3 helpers'!

computeLookupPrefix:prefix

    ^"unknown"false

    "Created: / 18-06-2005 / 21:16:49 / janfrog"
!

postAdoptedBy:aDocument 

    ^self errorNotSupported

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:arg1 deep:arg2 
    self errorNotSupported

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 21:16:49 / janfrog"
! !

!DocumentType methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 21:16:48 / janfrog"
!

entities
    ^ entities

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
!

internalSubset
    ^ internalSubset

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
!

name
    ^ name

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
!

nodeName

    ^self name

    "Created: / 17-06-2005 / 11:34:16 / janfrog"
!

nodeType

    ^Node DOCUMENT_TYPE_NODE

    "Created: / 17-06-2005 / 11:44:16 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 19-06-2005 / 13:31:19 / janfrog"
!

notations
    ^ notations

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
!

publicId
    ^ publicId

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
!

systemId
    ^ systemId

    "Created: / 24-12-2005 / 10:42:56 / janfrog"
! !

!DocumentType methodsFor:'initialization'!

setName: aString

    name := aString

    "Created: / 24-12-2005 / 10:43:35 / janfrog"
!

setPublicId: aString

    publicId := aString

    "Created: / 24-12-2005 / 10:43:22 / janfrog"
!

setSystemId: aString

    systemId := aString

    "Created: / 24-12-2005 / 10:43:28 / janfrog"
! !

!DocumentType methodsFor:'testing'!

isDocumentType
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!DocumentType methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitDocumentType:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!DocumentType class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DocumentType.st,v 1.2 2005-12-25 10:52:39 vranyj1 Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

