"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSString methodsFor:'accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:string'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSString methodsFor:'converting'!

toCanonicalLexicalForm:value
    ^ value.

    "Modified: / 24-10-2009 / 20:20:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSString methodsFor:'testing'!

checkLexicalForm:form

    ^ true.

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 15:16:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSString class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
