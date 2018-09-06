"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSUntypedAtomic
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSUntypedAtomic methodsFor:'accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:untypedAtomic'

    "Created: / 27-06-2009 / 18:48:40 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSUntypedAtomic methodsFor:'converting'!

toCanonicalLexicalForm:value
    ^ value asString.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSUntypedAtomic methodsFor:'testing'!

checkLexicalForm:form
    ^ true.

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-10-2009 / 19:51:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSUntypedAtomic class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
