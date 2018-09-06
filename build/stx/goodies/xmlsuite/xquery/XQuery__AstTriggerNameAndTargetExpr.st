"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstTriggerNameAndTargetExpr
	instanceVariableNames:'name targetExpr beforeAfterExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstTriggerNameAndTargetExpr methodsFor:'accessing'!

beforeAfterExpr
    ^ beforeAfterExpr
!

beforeAfterExpr:something
    beforeAfterExpr := something.
!

name
    ^ name
!

name:something
    name := something.
!

targetExpr
    ^ targetExpr
!

targetExpr:something
    targetExpr := something.
! !

!AstTriggerNameAndTargetExpr methodsFor:'testing'!

isAstTriggerNameAndTargetExpr
    ^ true
! !

!AstTriggerNameAndTargetExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstTriggerNameAndTargetExpr:self
! !

!AstTriggerNameAndTargetExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
