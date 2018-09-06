"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#CanonicalLexicalFormConverter
	instanceVariableNames:'convertBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!CanonicalLexicalFormConverter methodsFor:'accessing'!

convertBlock
    ^ convertBlock
!

convertBlock:something
    convertBlock := something.
! !

!CanonicalLexicalFormConverter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
