"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataTypeLibrary subclass:#XSDataTypeLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSDataTypeLibrary methodsFor:'accessing'!

dataTypeClasses

    "to be removed in final version"
    ^self defaultDataTypeClasses

    "Created: / 12-05-2005 / 11:34:40 / masca"
!

defaultDataTypeClasses

    ^Set new
        add:XSBoolean;
        add:XSString;
        add:XSInteger;
        add:XSKey;
        add:XSKeyRef;
        add:XSToken;
        add:XSDateTime;

        yourself.

    "Created: / 28-04-2005 / 13:55:51 / janfrog"
    "Modified: / 29-04-2005 / 15:11:10 / janfrog"
    "Modified: / 13-05-2005 / 13:48:47 / masca"
!

namespace
    "Superclass says that I am responsible to implement this method"

    ^'http://www.w3.org/2001/XMLSchema-datatypes'

    "Created: / 28-04-2005 / 14:04:21 / janfrog"
! !

!XSDataTypeLibrary class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSDataTypeLibrary.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
