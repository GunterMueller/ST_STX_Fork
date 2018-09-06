"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#TextDataType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Data Type Library'
!

TextDataType class instanceVariableNames:'soleInstance'

"
 No other class instance variables are inherited by this class.
"
!


!TextDataType class methodsFor:'accessing'!

default

    soleInstance ifNil:[soleInstance := self new].
    ^soleInstance

    "Created: / 02-05-2005 / 11:21:47 / janfrog"
!

typename
    "Superclass says that I am responsible to implement this method"

    ^'text'

    "Created: / 02-05-2005 / 11:20:59 / janfrog"
! !

!TextDataType methodsFor:'instance creation'!

createObjectFromString:arg 

    ^arg

    "Created: / 02-05-2005 / 11:20:59 / janfrog"
!

createStringFromObject:arg 

    ^arg

    "Created: / 02-05-2005 / 11:20:59 / janfrog"
! !

!TextDataType methodsFor:'queries'!

acceptsEmptyStringAsContent
    ^true

    "Created: / 14-06-2005 / 12:16:52 / masca"
! !

!TextDataType class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__TextDataType.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
