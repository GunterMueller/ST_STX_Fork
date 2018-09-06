"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSDate
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSDate methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:date'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
    "Modified: / 16-11-2009 / 22:13:28 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDate methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value printStringFormat: '%(year)-%(month)-%(day)'

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 22:16:57 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDate methodsFor:'type value - testing'!

checkLexicalForm:form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ form conform: [:character | 
        ('[0-9:Z]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ].

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 14:26:53 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDate class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
