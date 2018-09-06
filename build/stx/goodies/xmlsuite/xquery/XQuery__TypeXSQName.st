"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSQName
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSQName methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:QName'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSQName methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value asString.

    "Created: / 24-10-2009 / 20:01:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSQName methodsFor:'type value - testing'!

checkLexicalForm:form
    " ONLY HOTFIX - I have no regex to implement this"
    ^ (form conform: [:character | 
        ('[a-zA-Z0-9:./~%]' match: character asString ignoreCase: true)
        or: [character asString = '-'].
    ]) and: [ form size > 0].

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:19:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSQName class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
