"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

SchemaParser subclass:#SchemaIncludeParser
	instanceVariableNames:'parentParser parsingStart'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG'
!


!SchemaIncludeParser class methodsFor:'instance creation'!

for:aSchemaParser

    ^self new parentParser:aSchemaParser

    "Created: / 03-05-2005 / 10:59:25 / janfrog"
! !

!SchemaIncludeParser methodsFor:'SAX2 interface'!

endDocument
    "nothing to do"

    "Created: / 03-05-2005 / 10:53:10 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix

    self class rngNamespace = namespace ifFalse:[^self].
    localName = 'start' ifTrue:
        [parsingStart := false].
    parsingStart ifTrue:[^self].

    super endElement:localName namespace:namespace prefix:prefix

    "Created: / 03-05-2005 / 10:56:30 / janfrog"
    "Modified: / 12-05-2005 / 15:23:05 / masca"
!

setDocumentLocator:locator

    self schema addSource:locator getSystemId.

    "Created: / 07-06-2005 / 11:32:59 / masca"
!

startDocument
    "nothing to do"

    parsingStart := false.

    "Created: / 03-05-2005 / 10:53:03 / janfrog"
    "Modified: / 12-05-2005 / 15:22:06 / masca"
!

startElement:localName namespace:namespace prefix:prefix attributes:anAttributes

    self class rngNamespace = namespace ifFalse:[^self].
    localName = 'start' ifTrue:
        [parsingStart := true].
    parsingStart ifTrue:[^self].

    ^super startElement:localName namespace:namespace prefix:prefix attributes:anAttributes

    "Created: / 03-05-2005 / 10:53:54 / janfrog"
    "Modified: / 12-05-2005 / 15:22:36 / masca"
! !

!SchemaIncludeParser methodsFor:'accessing'!

parentParser
    ^ parentParser

    "Created: / 03-05-2005 / 10:48:33 / janfrog"
!

parentParser:aSchemaParser
    parentParser := aSchemaParser.

    "Created: / 03-05-2005 / 10:48:33 / janfrog"
!

refs
    ^self parentParser refs

    "Created: / 12-05-2005 / 11:51:09 / masca"
!

schema

    ^parentParser schema

    "Created: / 03-05-2005 / 10:48:54 / janfrog"
! !

!SchemaIncludeParser methodsFor:'initialization'!

initialize

        nodeStack := Stack new .
        (nsStack := Stack new) push:''.

    "Created: / 07-06-2005 / 11:34:31 / masca"
! !

!SchemaIncludeParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__SchemaIncludeParser.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !
