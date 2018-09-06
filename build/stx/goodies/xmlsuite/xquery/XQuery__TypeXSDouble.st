"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSDouble
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSDouble methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:double'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSDouble methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ (FloatFormatter withValue: value) toCanonicalLexicalForm.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:18:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDouble methodsFor:'type value - testing'!

checkLexicalForm: form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ 
    (form trim conform: [:character | 
        ('[0-9.e+]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ]) 
    or:
    [
        (form = 'INF') or: [form = '-INF'] or: [form = 'NaN'].
    ]

    "Created: / 15-10-2009 / 16:55:26 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:35:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDouble class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
