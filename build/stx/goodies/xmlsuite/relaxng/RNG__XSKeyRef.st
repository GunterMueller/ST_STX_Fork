"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

XSString subclass:#XSKeyRef
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSKeyRef class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'IDREF'

    "Created: / 29-04-2005 / 12:07:04 / janfrog"
    "Modified: / 13-05-2005 / 16:03:48 / masca"
! !

!XSKeyRef methodsFor:'queries'!

acceptsEmptyStringAsContent
    ^false

    "Created: / 14-06-2005 / 12:17:26 / masca"
! !

!XSKeyRef methodsFor:'testing'!

isKeyRef

    ^true

    "Created: / 29-04-2005 / 12:19:22 / janfrog"
! !

!XSKeyRef class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSKeyRef.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
