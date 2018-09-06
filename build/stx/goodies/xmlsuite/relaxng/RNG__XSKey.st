"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

XSString subclass:#XSKey
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSKey class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'ID'

    "Created: / 29-04-2005 / 12:07:04 / janfrog"
    "Modified: / 13-05-2005 / 16:03:43 / masca"
! !

!XSKey methodsFor:'queries'!

acceptsEmptyStringAsContent
    ^false

    "Created: / 14-06-2005 / 12:17:12 / masca"
! !

!XSKey methodsFor:'testing'!

isKey

    ^true

    "Created: / 29-04-2005 / 12:19:14 / janfrog"
! !

!XSKey class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSKey.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
