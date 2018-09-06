"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCompElemConstructor
	instanceVariableNames:'qname expr contentExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCompElemConstructor methodsFor:'accessing'!

contentExpr
    ^ contentExpr

    "Created: / 01-07-2006 / 11:39:12 / ked"
!

contentExpr:something
    contentExpr := something.

    "Created: / 01-07-2006 / 11:39:12 / ked"
!

expr
    ^ expr

    "Created: / 01-07-2006 / 11:39:12 / ked"
!

expr:something
    expr := something.

    "Created: / 01-07-2006 / 11:39:12 / ked"
!

qname
    ^ qname

    "Created: / 01-07-2006 / 11:39:12 / ked"
!

qname:something
    qname := something.

    "Created: / 01-07-2006 / 11:39:12 / ked"
! !

!AstCompElemConstructor methodsFor:'testing'!

isAstCompElemConstructor
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstCompElemConstructor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstCompElemConstructor:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstCompElemConstructor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
