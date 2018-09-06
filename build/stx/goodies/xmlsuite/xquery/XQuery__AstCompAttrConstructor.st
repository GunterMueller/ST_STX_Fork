"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCompAttrConstructor
	instanceVariableNames:'qname expr contentExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCompAttrConstructor methodsFor:'accessing'!

contentExpr
    ^ contentExpr

    "Created: / 01-07-2006 / 11:50:02 / ked"
!

contentExpr:something
    contentExpr := something.

    "Created: / 01-07-2006 / 11:50:02 / ked"
!

expr
    ^ expr

    "Created: / 01-07-2006 / 11:50:02 / ked"
!

expr:something
    expr := something.

    "Created: / 01-07-2006 / 11:50:02 / ked"
!

qname
    ^ qname

    "Created: / 01-07-2006 / 11:50:02 / ked"
!

qname:something
    qname := something.

    "Created: / 01-07-2006 / 11:50:02 / ked"
! !

!AstCompAttrConstructor methodsFor:'testing'!

isAstCompAttrConstructor
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstCompAttrConstructor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstCompAttrConstructor:self

    "Created: / 06-07-2006 / 19:12:08 / ked"
! !

!AstCompAttrConstructor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
