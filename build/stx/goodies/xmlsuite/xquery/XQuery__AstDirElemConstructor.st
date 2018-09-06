"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDirElemConstructor
	instanceVariableNames:'dirAttributeList dirElemContent qName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDirElemConstructor methodsFor:'accessing'!

dirAttributeList
    dirAttributeList isNil ifTrue: [
        dirAttributeList := OrderedCollection new.
    ].
    ^ dirAttributeList

    "Created: / 30-06-2006 / 17:49:12 / ked"
    "Modified: / 25-07-2009 / 23:40:39 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dirAttributeList:something
    dirAttributeList := something.

    "Created: / 30-06-2006 / 17:49:12 / ked"
!

dirElemContent
    dirElemContent isNil ifTrue: [
        dirElemContent := OrderedCollection new.
    ].
    ^ dirElemContent

    "Created: / 30-06-2006 / 17:49:12 / ked"
    "Modified: / 25-07-2009 / 23:40:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dirElemContent:something
    dirElemContent := something.

    "Created: / 30-06-2006 / 17:49:12 / ked"
!

qName
    ^ qName

    "Created: / 25-07-2009 / 23:37:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

qName:something
    qName := something.

    "Created: / 25-07-2009 / 23:37:09 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstDirElemConstructor methodsFor:'testing'!

isAstDirElemConstructor
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstDirElemConstructor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDirElemConstructor:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstDirElemConstructor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
