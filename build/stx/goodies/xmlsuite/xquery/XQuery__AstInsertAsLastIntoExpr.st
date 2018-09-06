"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstInsertExpr subclass:#AstInsertAsLastIntoExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertAsLastIntoExpr methodsFor:'testing'!

isAstInsertAsLastIntoExpr

        ^ true
!

isAstInsertIntoAsLastExpr

        ^ true
! !

!AstInsertAsLastIntoExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertAsLastIntoExpr:self
! !

!AstInsertAsLastIntoExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
