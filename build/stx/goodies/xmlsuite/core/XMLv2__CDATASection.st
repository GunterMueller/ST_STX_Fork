"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

CharacterData subclass:#CDATASection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!CDATASection methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
! !

!CDATASection methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

lookupNamespaceURI:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

nodeName

    ^'#cdata-section'

    "Created: / 17-06-2005 / 11:25:46 / janfrog"
!

nodeType

    ^Node CDATA_SECTION_NODE

    "Created: / 17-06-2005 / 11:43:30 / janfrog"
!

nodeValue

    ^self data

    "Created: / 17-06-2005 / 11:35:59 / janfrog"
!

nodeValue:value

    ^self data:value

    "Created: / 17-06-2005 / 12:07:30 / janfrog"
!

normalize

    "Nothing to do"

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
    "Modified: / 28-12-2005 / 16:18:05 / janfrog"
! !

!CDATASection methodsFor:'testing'!

isCDATASection
    ^ true

    "Created: / 05-08-2005 / 14:28:08 / janfrog"
! !

!CDATASection methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitCDATASection:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!CDATASection class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__CDATASection.st,v 1.4 2007-01-03 19:58:41 stillj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
