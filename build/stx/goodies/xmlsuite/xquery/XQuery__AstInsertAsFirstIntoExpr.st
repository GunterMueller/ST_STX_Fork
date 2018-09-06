"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstInsertExpr subclass:#AstInsertAsFirstIntoExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertAsFirstIntoExpr methodsFor:'testing'!

isAstInsertAsFirstIntoExpr

        ^ true
!

isAstInsertIntoAsFirstExpr

        ^ true
! !

!AstInsertAsFirstIntoExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertAsFirstIntoExpr:self
! !

!AstInsertAsFirstIntoExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
