"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDirAttributeList
	instanceVariableNames:'qname attributes dirAttributeList dirAttributeValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDirAttributeList methodsFor:'accessing'!

dirAttributeList
    ^ dirAttributeList

    "Created: / 30-06-2006 / 18:37:48 / ked"
!

dirAttributeList:something
    dirAttributeList := something.

    "Created: / 30-06-2006 / 18:37:48 / ked"
!

dirAttributeValue
    ^ dirAttributeValue

    "Created: / 30-06-2006 / 18:37:48 / ked"
!

dirAttributeValue:something
    dirAttributeValue := something.

    "Created: / 30-06-2006 / 18:37:48 / ked"
!

qname
    ^ qname

    "Created: / 30-06-2006 / 18:37:48 / ked"
!

qname:something
    qname := something.

    "Created: / 30-06-2006 / 18:37:48 / ked"
! !

!AstDirAttributeList methodsFor:'testing'!

isAstDirAttributeList
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstDirAttributeList methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDirAttributeList:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstDirAttributeList class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
