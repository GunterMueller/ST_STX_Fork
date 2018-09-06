"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstContextItemExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstContextItemExpr methodsFor:'testing'!

isAstContextItemExpr
    ^ true

    "Created: / 07-11-2006 / 22:03:57 / ked"
! !

!AstContextItemExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstContextItemExpr:self

    "Created: / 07-11-2006 / 22:04:03 / ked"
! !

!AstContextItemExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
