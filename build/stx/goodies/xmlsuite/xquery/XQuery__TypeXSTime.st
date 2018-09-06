"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSTime
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSTime methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:time'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
    "Modified: / 22-09-2009 / 15:08:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSTime methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value printStringFormat: '%h:%m:%s'

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 19:31:59 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSTime methodsFor:'type value - testing'!

checkLexicalForm:form
    "TODO: use regex while available"

    [Time readFrom: form]
    on: Exception
    do: [ ^ false ].

    ^ true.

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 19:29:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSTime class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
