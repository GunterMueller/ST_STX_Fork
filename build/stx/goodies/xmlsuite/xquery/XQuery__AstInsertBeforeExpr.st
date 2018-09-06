"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstInsertExpr subclass:#AstInsertBeforeExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertBeforeExpr methodsFor:'testing'!

isAstInsertBeforeExpr

        ^ true
! !

!AstInsertBeforeExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertBeforeExpr:self
! !

!AstInsertBeforeExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
