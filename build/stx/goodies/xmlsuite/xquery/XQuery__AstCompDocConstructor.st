"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCompDocConstructor
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCompDocConstructor methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 01-07-2006 / 11:36:51 / ked"
!

expr:something
    expr := something.

    "Created: / 01-07-2006 / 11:36:51 / ked"
! !

!AstCompDocConstructor methodsFor:'testing'!

isAstCompDocConstructor
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstCompDocConstructor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstCompDocConstructor:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstCompDocConstructor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
