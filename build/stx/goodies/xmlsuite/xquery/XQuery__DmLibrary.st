"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

SmalltalkFunctionLibrary subclass:#DmLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!DmLibrary class methodsFor:'function library API'!

namespaceURI
    "Superclass XQuery::FunctionLibrary class says that I am responsible to implement this method"

    ^'http://www.w3.org/TR/xpath-datamodel'.

    "Modified: / 19-04-2009 / 19:16:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DmLibrary methodsFor:'dm:*'!

nodeKindInContext: context withParameters: parameters forInterpreter: interpreter
    self assert: parameters size = 1.

    ^XQuerySequence withText: (parameters first first item dmNodeKind).

    "Created: / 19-04-2009 / 18:53:06 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DmLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^'dm'

    "Modified: / 19-04-2009 / 18:46:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

functionLocalNames
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^#(
        attributes
        #'base-uri'
        children
        document-uri
        is-id
        is-idrefs
        namespace-nodes
        namespace-bindings
        nilled
        #'node-kind'
        node-name
        parent
        string-value
        type-name
        typed-value
        unparsed-entity-public-id
        unparsed-entitysystem-id
    )

    "Modified: / 19-04-2009 / 18:54:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DmLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
