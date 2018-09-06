"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#LexicalFormChecker
	instanceVariableNames:'checkBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!LexicalFormChecker methodsFor:'accessing'!

checkBlock
    ^ checkBlock
!

checkBlock:something
    checkBlock := something.
! !

!LexicalFormChecker methodsFor:'testing'!

checkLexicalForm: form
    ^ self checkBlock value: form.

    "Created: / 06-11-2009 / 14:05:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!LexicalFormChecker class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
