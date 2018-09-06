"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XPathKindTest subclass:#XPathElementTest
	instanceVariableNames:'elementName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathElementTest methodsFor:'accessing'!

elementName
    ^ elementName

    "Created: / 28-02-2009 / 18:58:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

elementName:something
    elementName := something.

    "Created: / 28-02-2009 / 18:58:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

elementNameAsString
 ^ elementName elementName content.

    "Created: / 28-02-2009 / 19:12:13 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XPathElementTest methodsFor:'printing'!

printOn: stream

    stream nextPutAll:'element('.
    elementName ifNotNil:[stream nextPutAll: self elementNameAsString].
    stream nextPut:$)

    "Created: / 15-11-2007 / 22:02:22 / janfrog"
    "Modified: / 28-02-2009 / 19:14:43 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XPathElementTest methodsFor:'testing'!

isXPathElementTest
    ^ true

    "Created: / 21-11-2007 / 11:07:13 / janfrog"
! !

!XPathElementTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathElementTest:self

    "Created: / 17-11-2007 / 15:31:52 / janfrog"
! !

!XPathElementTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
