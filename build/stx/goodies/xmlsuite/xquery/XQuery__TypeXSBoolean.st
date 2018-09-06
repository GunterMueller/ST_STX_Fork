"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TypeXSAnyAtomicType subclass:#TypeXSBoolean
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeXSBoolean methodsFor:'type value - accessing'!

typeName
    "Superclass says that I am responsible to implement this method"

    ^'xs:boolean'

    "Created: / 05-12-2007 / 20:52:53 / janfrog"
! !

!TypeXSBoolean methodsFor:'type value - converting'!

toCanonicalLexicalForm:value
    ^ value asString.

    "Modified: / 24-10-2009 / 20:21:19 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSBoolean methodsFor:'type value - testing'!

checkLexicalForm:form
    ^ (form = 'true') or: [ form = 'false'] or: [ form = '0'] or: [ form = '1']

    "Created: / 15-10-2009 / 17:36:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 14:29:07 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeXSBoolean class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
