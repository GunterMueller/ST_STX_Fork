"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#Entity
	instanceVariableNames:'inputEncoding notationName publicId systemId xmlEncoding
		xmlVersion'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Entity methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postAdoptedBy:aDocument 

    self errorNotSupported

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:arg1 deep:arg2 
    "Nothing to do"

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
! !

!Entity methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

inputEncoding
    ^ inputEncoding

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
!

isDefaultNamespace:ns

    ^"unknown"false

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

lookupNamespaceURI:ns

    ^"unknown"false

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeName
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeType

    ^Node ENTITY_NODE

    "Created: / 17-06-2005 / 11:44:33 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

notationName
    ^ notationName

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
!

parentNode

    ^self domError:'Entity has no parent' code:#NOT_SUPPORTED_ERR

    "Created: / 17-06-2005 / 12:04:52 / janfrog"
!

publicId
    ^ publicId

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
!

systemId
    ^ systemId

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
!

xmlEncoding
    ^ xmlEncoding

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
!

xmlVersion
    ^ xmlVersion

    "Created: / 24-12-2005 / 10:34:51 / janfrog"
! !

!Entity methodsFor:'initialization'!

setNotationName: aString

    notationName := aString

    "Created: / 24-12-2005 / 10:35:14 / janfrog"
! !

!Entity methodsFor:'testing'!

isEntity
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!Entity methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitEntity:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Entity class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Entity.st,v 1.2 2005-12-25 10:52:23 vranyj1 Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

