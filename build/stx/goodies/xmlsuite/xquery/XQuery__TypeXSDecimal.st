"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSDecimal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSDecimal methodsFor:'accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:decimal'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSDecimal methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
"/    ^ value asString.
"/    ^ value storeString
    ^ (DecimalFormatter withValue: value) toCanonicalLexicalForm.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:18:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDecimal methodsFor:'type value - testing'!

checkLexicalForm: form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ form conform: [:character | 
        ('[0-9.+]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ].

    "Created: / 15-10-2009 / 16:55:26 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 18:41:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSDecimal class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
