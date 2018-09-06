"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#SchemaRegistry
	instanceVariableNames:'schemas'
	classVariableNames:'SoleInstance'
	poolDictionaries:''
	category:'Relax NG-Registry'
!


!SchemaRegistry class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 07-06-2005 / 11:49:30 / masca"
! !

!SchemaRegistry class methodsFor:'accessing'!

default

    SoleInstance ifNil:[SoleInstance := self new].
    ^SoleInstance

    "
        SoleInstance := nil.
    "

    "Created: / 07-06-2005 / 13:55:30 / masca"
! !

!SchemaRegistry class methodsFor:'schemas'!

schemaAt:anURI


    ^self default schemaAt:anURI

    "Created: / 07-06-2005 / 13:57:19 / masca"
!

schemaFromURI:anURI

    <resource:#obsolete>

    self obsoleteMethodWarning:'Obsolete. Use #schemaAt:anURI'.    
    ^self schemaAt:anURI

    "Created: / 13-05-2005 / 09:45:45 / masca"
    "Modified: / 07-06-2005 / 13:57:05 / masca"
! !

!SchemaRegistry methodsFor:'accessing'!

schemaAt:anURI

    | schema |
    schema := schemas at:anURI ifAbsentPut:[self parseSchemaAt:anURI].
    schema anySourceModified ifTrue:[
        schema := self parseSchemaAt:anURI.
        schemas at:anURI put:schema.
    ].
    ^schema

    "Created: / 07-06-2005 / 13:59:34 / masca"
! !

!SchemaRegistry methodsFor:'initialization'!

initialize

    schemas := Dictionary new

    "Created: / 07-06-2005 / 13:53:01 / masca"
!

reinitialize

    schemas := Dictionary new

    "Created: / 07-06-2005 / 14:03:41 / masca"
! !

!SchemaRegistry methodsFor:'private'!

parseSchemaAt:anURI

    Transcript showCR:'[RNG::SchemaRegistry] - parsing schema: ',anURI printString.
    ^Schema fromURI:anURI

    "Created: / 07-06-2005 / 14:05:54 / masca"
! !

!SchemaRegistry class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__SchemaRegistry.st,v 1.1.1.1 2005-11-01 22:07:15 vranyj1 Exp $'
! !
