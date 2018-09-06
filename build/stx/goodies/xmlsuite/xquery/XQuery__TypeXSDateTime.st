"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSDateTime
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSDateTime methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:dateTime'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
    "Modified: / 16-11-2009 / 22:13:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDateTime methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value printStringFormat: '%(year)-%(month)-%(day)T%h:%m:%s'.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 19:18:58 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDateTime methodsFor:'type value - testing'!

checkLexicalForm:form
    "TODO: use regex while available"

    [form asDate]
    on: Exception
    do: [ ^ false ].

    ^ true.

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 18:57:31 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDateTime class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
