"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstInsertExpr subclass:#AstInsertIntoExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertIntoExpr methodsFor:'testing'!

isAstInsertIntoExpr

        ^ true
! !

!AstInsertIntoExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertIntoExpr:self
! !

!AstInsertIntoExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
