"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstEnclosedExpr
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstEnclosedExpr methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 06-11-2006 / 22:40:14 / ked"
!

expr:something
    expr := something.

    "Created: / 06-11-2006 / 22:40:14 / ked"
! !

!AstEnclosedExpr methodsFor:'testing'!

isAstEnclosedExpr
    ^ true

    "Created: / 06-11-2006 / 22:41:13 / ked"
! !

!AstEnclosedExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstEnclosedExpr:self

    "Created: / 06-11-2006 / 22:40:40 / ked"
! !

!AstEnclosedExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
