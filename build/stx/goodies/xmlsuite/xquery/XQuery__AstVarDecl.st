"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstVarDecl
	instanceVariableNames:'name type expression'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstVarDecl class methodsFor:'queries'!

externalDeclarationExpression
    ^#external

    "Created: / 18-04-2009 / 12:08:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstVarDecl methodsFor:'accessing'!

expression
    ^ expression
!

expression:something
    expression := something.
!

name
    ^ name
!

name:something
    name := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!AstVarDecl methodsFor:'public'!

expressionIsExternal
    self expression: self class externalDeclarationExpression.

    "Created: / 18-04-2009 / 12:13:56 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstVarDecl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstVarDecl:self
! !

!AstVarDecl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
