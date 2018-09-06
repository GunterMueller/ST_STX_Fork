"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

SAXError subclass:#DOMException
	instanceVariableNames:'code'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Exceptions'
!


!DOMException class methodsFor:'error codes'!

DOMSTRING_SIZE_ERR
    "If the specified range of text does not fit into a DOMString."

    ^2

    "Created: / 08-05-2005 / 18:12:21 / janfrog"
!

HIERARCHY_REQUEST_ERR
    "If any Node is inserted somewhere it doesn't belong."

    ^3

    "Created: / 08-05-2005 / 18:12:46 / janfrog"
!

INDEX_SIZE_ERR
    "If index or size is negative, or greater than the allowed value."

    ^1

    "Created: / 08-05-2005 / 18:11:53 / janfrog"
!

INUSE_ATTRIBUTE_ERR
    "If an attempt is made to add an attribute that is already in use elsewhere."

    ^10

    "Created: / 08-05-2005 / 18:14:24 / janfrog"
!

INVALID_ACCESS_ERR
    "If a parameter or an operation is not supported by the underlying object."

    ^15

    "Created: / 08-05-2005 / 18:16:14 / janfrog"
!

INVALID_CHARACTER_ERR
    "If an invalid or illegal character is specified, such as in an XML name."

    ^5

    "Created: / 08-05-2005 / 18:13:07 / janfrog"
!

INVALID_MODIFICATION_ERR
    "If an attempt is made to modify the type of the underlying object."

    ^13

    "Created: / 08-05-2005 / 18:15:16 / janfrog"
!

INVALID_STATE_ERR
    "If an attempt is made to use an object that is not, or is no longer, usable."

    ^11

    "Created: / 08-05-2005 / 18:14:48 / janfrog"
!

NAMESPACE_ERR
    "If an attempt is made to create or change an object in a way which is incorrect
    with regard to namespaces."

    ^14

    "Created: / 08-05-2005 / 18:15:29 / janfrog"
!

NOT_FOUND_ERR
    "If an attempt is made to reference a Node in a context where it does not exist."

    ^8

    "Created: / 08-05-2005 / 18:13:48 / janfrog"
!

NOT_SUPPORTED_ERR
    "If the implementation does not support the requested type of object or operation."

    ^9

    "Created: / 08-05-2005 / 18:14:10 / janfrog"
!

NO_DATA_ALLOWED_ERR
    "If data is specified for a Node which does not support data."

    ^6

    "Created: / 08-05-2005 / 18:13:22 / janfrog"
!

NO_MODIFICATION_ALLOWED_ERR
    "If an attempt is made to modify an object where modifications are not allowed."

    ^7

    "Created: / 08-05-2005 / 18:13:31 / janfrog"
!

SYNTAX_ERR
    "If an invalid or illegal string is specified."

    ^12

    "Created: / 08-05-2005 / 18:14:57 / janfrog"
!

TYPE_MISMATCH
    "If the type of an object is incompatible with the expected type of the parameter
    associated to the object."

    ^17

    "Created: / 08-05-2005 / 18:16:46 / janfrog"
!

VALIDATION_ERR
    "If a call to a method such as insertBefore or removeChild would make the Node invalid
    with respect to 'partial validity', this exception would be raised and the operation would
    not be done. This code is used in [DOM Level 3 Validation]. Refer to this specification
    for further information."

    ^16

    "Created: / 08-05-2005 / 18:16:26 / janfrog"
!

WRONG_DOCUMENT_ERR
    "If a Node is used in a different document than the one that created it (that doesn't
    support it)."

    ^4

    "Created: / 08-05-2005 / 18:12:56 / janfrog"
! !

!DOMException class methodsFor:'raising'!

raiseErrorString:aString withCode:anIntegerOrSymbol

    | code |
    code := anIntegerOrSymbol isInteger 
                ifTrue:[anIntegerOrSymbol]
                ifFalse:[self perform:anIntegerOrSymbol].

    ^self new
        errorString:aString;
        code:code;
        raise.

    "Created: / 08-05-2005 / 18:19:19 / janfrog"
! !

!DOMException methodsFor:'accessing'!

code
    ^code

    "Created: / 17-06-2005 / 12:02:25 / janfrog"
!

code:anIntegerOrSymbol

    code := anIntegerOrSymbol isSymbol
                ifTrue:[self class perform:anIntegerOrSymbol]
                ifFalse:[anIntegerOrSymbol]

    "Created: / 17-06-2005 / 12:03:15 / janfrog"
! !

!DOMException class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMException.st,v 1.2 2006-12-07 08:17:06 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
