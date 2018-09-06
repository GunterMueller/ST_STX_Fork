"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSAnyURI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSAnyURI methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:anyURI'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
    "Modified: / 22-09-2009 / 14:58:31 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSAnyURI methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value asString.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSAnyURI methodsFor:'type value - testing'!

checkLexicalForm:form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ form conform: [:character | 
        ('[a-zA-Z0-9:./~%]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ].

    "Modified: / 17-11-2009 / 16:52:03 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSAnyURI class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
