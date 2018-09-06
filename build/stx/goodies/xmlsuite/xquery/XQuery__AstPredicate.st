"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstPredicate
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstPredicate methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 18-03-2006 / 21:18:35 / ked"
!

expr:something
    expr := something.

    "Created: / 18-03-2006 / 21:18:35 / ked"
! !

!AstPredicate methodsFor:'testing'!

isAstPredicate
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstPredicate methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstPredicate:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstPredicate class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
