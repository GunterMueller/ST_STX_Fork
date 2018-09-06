"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#XSString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSString class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'string'

    "Created: / 28-04-2005 / 14:00:20 / janfrog"
! !

!XSString methodsFor:'instance creation'!

createObjectFromString:aString 
    ^aString

    "Created: / 02-05-2005 / 10:38:06 / janfrog"
    "Modified: / 16-05-2005 / 14:21:05 / masca"
!

createStringFromObject:anObject 
    ^ anObject

    "Created: / 02-05-2005 / 10:38:21 / janfrog"
    "Modified: / 16-05-2005 / 14:21:08 / masca"
! !

!XSString methodsFor:'queries'!

acceptsEmptyStringAsContent
    ^true

    "Created: / 14-06-2005 / 12:17:04 / masca"
! !

!XSString class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSString.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
