"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#ProcessingInstruction
	instanceVariableNames:'target data'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!ProcessingInstruction methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    target := target copy.
    data := data copy

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
! !

!ProcessingInstruction methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

isDefaultNamespace:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

lookupNamespaceURI:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeName

    ^self target

    "Created: / 17-06-2005 / 11:34:47 / janfrog"
!

nodeType

    ^Node PROCESSING_INSTRUCTION_NODE

    "Created: / 17-06-2005 / 11:45:22 / janfrog"
!

nodeValue

    ^self data

    "Created: / 17-06-2005 / 11:36:27 / janfrog"
!

nodeValue:value

    ^self data:value

    "Created: / 17-06-2005 / 12:08:44 / janfrog"
!

normalize
    "Nothing to do"

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
    "Modified: / 28-12-2005 / 16:49:23 / janfrog"
! !

!ProcessingInstruction methodsFor:'accessing'!

data
    ^ data

    "Created: / 04-08-2005 / 13:31:49 / janfrog"
!

data:something
    data := something.

    "Created: / 04-08-2005 / 13:31:49 / janfrog"
!

target
    ^ target

    "Created: / 04-08-2005 / 13:31:49 / janfrog"
!

target:something
    target := something.

    "Created: / 04-08-2005 / 13:31:49 / janfrog"
! !

!ProcessingInstruction methodsFor:'testing'!

isProcessingInstruction
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!ProcessingInstruction methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitProcessingInstruction:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!ProcessingInstruction class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__ProcessingInstruction.st,v 1.3 2005-12-28 16:14:40 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
