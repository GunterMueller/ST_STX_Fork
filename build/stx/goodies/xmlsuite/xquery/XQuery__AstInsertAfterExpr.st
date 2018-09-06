"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstInsertExpr subclass:#AstInsertAfterExpr
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertAfterExpr methodsFor:'testing'!

isAstInsertAfterExpr

        ^ true
! !

!AstInsertAfterExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertAfterExpr:self
! !

!AstInsertAfterExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
