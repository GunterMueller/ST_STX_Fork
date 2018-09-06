"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#DerivedAtomicType
	instanceVariableNames:'typeName lexicalFormChecker canonicalLexicalFormConverter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!DerivedAtomicType methodsFor:'accessing'!

canonicalLexicalFormConverter
    canonicalLexicalFormConverter ifNil:
    [
        canonicalLexicalFormConverter := self supertype.
    ].

    ^ canonicalLexicalFormConverter

    "Created: / 06-11-2009 / 14:10:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

canonicalLexicalFormConverter:something
    canonicalLexicalFormConverter := something.
!

lexicalFormChecker
    lexicalFormChecker ifNil:
    [
        lexicalFormChecker := self supertype.
    ].

    ^ lexicalFormChecker

    "Modified: / 06-11-2009 / 14:04:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

lexicalFormChecker:something
    lexicalFormChecker := something.
! !

!DerivedAtomicType methodsFor:'converting'!

asString
    ^ self typeName.

    "Created: / 25-07-2009 / 18:21:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DerivedAtomicType methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: self typeName

    "Created: / 05-12-2007 / 20:51:23 / janfrog"
! !

!DerivedAtomicType methodsFor:'type value - accessing'!

localName

    ^ self qName localName.

    "Created: / 28-10-2009 / 11:56:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

qName

    ^ QName withQNameString: self typeName.

    "Created: / 28-10-2009 / 11:56:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

subtypes
    ^ TypeFactory current subtypesOf: self typeName.

    "Created: / 05-11-2009 / 22:53:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

supertype
    ^ TypeFactory current supertypeOf: self.

    "Created: / 05-11-2009 / 22:53:59 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 08-11-2009 / 14:53:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

typeName
    ^ typeName

    "Created: / 05-12-2007 / 20:50:11 / janfrog"
    "Modified: / 06-11-2009 / 11:26:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

typeName:something
    typeName := something.
! !

!DerivedAtomicType methodsFor:'type value - converting'!

toCanonicalLexicalForm: value
    ^ self canonicalLexicalFormConverter toCanonicalLexicalForm: value.

    "Created: / 06-11-2009 / 14:08:37 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 20:08:22 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DerivedAtomicType methodsFor:'type value - testing'!

checkLexicalForm: form
    ^ self lexicalFormChecker checkLexicalForm: form.

    "Created: / 06-11-2009 / 13:45:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isDerived
    ^ true

    "Created: / 07-11-2009 / 16:20:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isNumeric
    ^ TypeFactory current isNumeric: self.

    "Created: / 07-11-2009 / 23:36:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isPrimitive
    ^ false

    "Created: / 07-11-2009 / 16:20:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isXMLType
    ^ true

    "Created: / 05-11-2009 / 21:54:24 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DerivedAtomicType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
