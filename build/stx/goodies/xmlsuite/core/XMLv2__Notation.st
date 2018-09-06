"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#Notation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Notation methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postAdoptedBy:aDocument 

    ^self errorNotSupported

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

!Notation methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
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

    ^Node NOTATION_NODE

    "Created: / 17-06-2005 / 11:45:06 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

parentNode

    ^self domError:'Notation has no parent' code:#NOT_SUPPORTED_ERR

    "Created: / 17-06-2005 / 12:05:00 / janfrog"
! !

!Notation methodsFor:'testing'!

isNotation
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!Notation methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitNotation:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Notation class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Notation.st,v 1.2 2005-12-25 10:55:40 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
