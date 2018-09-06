"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

CharacterData subclass:#Comment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Comment methodsFor:'DOM3 helpers'!

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

!Comment methodsFor:'DOM3 interface'!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

isDefaultNamespace:arg 
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

    ^'#comment'

    "Created: / 17-06-2005 / 11:29:38 / janfrog"
!

nodeType

    ^Node COMMENT_NODE

    "Created: / 17-06-2005 / 11:43:46 / janfrog"
!

nodeValue

    ^self data

    "Created: / 29-09-2006 / 08:35:08 / janfrog"
!

normalize


    "Nothing to do for now"

    "Modified: / 23-12-2005 / 20:54:55 / janfrog"
! !

!Comment methodsFor:'testing'!

isComment
    ^ true

    "Created: / 05-08-2005 / 14:28:08 / janfrog"
!

isIgnorableText

    ^true

    "Created: / 07-04-2007 / 15:30:21 / janfrog"
! !

!Comment methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitComment:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Comment class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Comment.st,v 1.5 2007-04-13 15:35:31 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
