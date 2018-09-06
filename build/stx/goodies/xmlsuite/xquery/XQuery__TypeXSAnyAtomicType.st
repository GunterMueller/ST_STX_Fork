"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeItem subclass:#TypeXSAnyAtomicType
	instanceVariableNames:'valueSpace lexicalSpace facets'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSAnyAtomicType methodsFor:'accessing'!

facets
    ^ facets
!

facets:something
    facets := something.
!

lexicalSpace
    ^ lexicalSpace
!

lexicalSpace:something
    lexicalSpace := something.
!

valueSpace
    ^ valueSpace
!

valueSpace:something
    valueSpace := something.
! !

!TypeXSAnyAtomicType methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:anyAtomicType'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSAnyAtomicType methodsFor:'type value - converting'!

toCanonicalLexicalForm: value
    self subclassResponsibility.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSAnyAtomicType methodsFor:'type value - testing'!

checkLexicalForm: form
    self subclassResponsibility.

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isDerived
    ^ false

    "Created: / 07-11-2009 / 16:20:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isPrimitive
    ^ true

    "Created: / 07-11-2009 / 16:19:58 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSAnyAtomicType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
