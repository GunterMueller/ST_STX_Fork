"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCompTextConstructor
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCompTextConstructor methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 01-07-2006 / 12:06:22 / ked"
!

expr:something
    expr := something.

    "Created: / 01-07-2006 / 12:06:22 / ked"
! !

!AstCompTextConstructor methodsFor:'testing'!

isAstCompTextConstructor
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstCompTextConstructor methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstCompTextConstructor:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstCompTextConstructor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
