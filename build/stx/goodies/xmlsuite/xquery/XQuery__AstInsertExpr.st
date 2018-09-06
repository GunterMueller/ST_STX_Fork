"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstInsertExpr
	instanceVariableNames:'targetExpr sourceExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertExpr methodsFor:'accessing'!

sourceExpr
    ^ sourceExpr
!

sourceExpr:something
    sourceExpr := something.
!

targetExpr
    ^ targetExpr
!

targetExpr:something
    targetExpr := something.
! !

!AstInsertExpr methodsFor:'testing'!

isUpdatingExpression

^true

    "Created: / 21-11-2007 / 14:18:34 / janfrog"
! !

!AstInsertExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
