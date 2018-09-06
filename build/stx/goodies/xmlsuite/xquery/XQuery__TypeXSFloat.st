"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSFloat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSFloat methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:float'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSFloat methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ (FloatFormatter withValue: value) toCanonicalLexicalForm.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:18:26 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSFloat methodsFor:'type value - testing'!

checkLexicalForm: form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ 
    (form conform: [:character | 
        ('[0-9.e+]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ]) 
    or:
    [
        (form = 'INF') or: [form = '-INF'] or: [form = 'NaN'].
    ]

    "Created: / 15-10-2009 / 20:28:06 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 18:00:53 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSFloat class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
