"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#TypeItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!

TypeItem class instanceVariableNames:'theInstance'

"
 No other class instance variables are inherited by this class.
"
!


!TypeItem class methodsFor:'accessing'!

document
    "deprecated"
    self shouldNeverBeSent.
    ^TypeDocument instance

    "Created: / 05-12-2007 / 15:17:08 / janfrog"
    "Modified: / 01-11-2009 / 17:38:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

instance

    theInstance ifNil:[theInstance := self new].
    ^theInstance

    "Created: / 05-12-2007 / 14:48:07 / janfrog"
! !

!TypeItem methodsFor:'converting'!

asString
    ^ self typeName.

    "Created: / 25-07-2009 / 18:21:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeItem methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: self typeName

    "Created: / 05-12-2007 / 20:51:23 / janfrog"
! !

!TypeItem methodsFor:'type value - accessing'!

localName

    ^ self qName localName.

    "Created: / 28-10-2009 / 11:56:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

qName

    ^ QName withQNameString: self typeName.

    "Created: / 28-10-2009 / 11:56:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

subtypes
    ^ TypeFactory current subtypesOf: self.

    "Created: / 05-11-2009 / 22:53:59 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 08-11-2009 / 14:45:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

supertype
    ^ TypeFactory current supertypeOf: self.

    "Created: / 05-11-2009 / 22:53:59 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 08-11-2009 / 14:45:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

typeName

    ^self subclassResponsibility

    "Created: / 05-12-2007 / 20:50:11 / janfrog"
! !

!TypeItem methodsFor:'type value - testing'!

isNumericValue
    ^ TypeFactory current isNumeric: self.

    "Created: / 07-11-2009 / 23:32:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isPrimitive
    ^ false

    "Created: / 21-11-2009 / 18:41:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isXMLType
    ^ true

    "Created: / 05-11-2009 / 21:54:24 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
