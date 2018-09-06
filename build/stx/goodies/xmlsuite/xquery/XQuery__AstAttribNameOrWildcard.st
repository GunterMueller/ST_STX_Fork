"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAttribNameOrWildcard
	instanceVariableNames:'attributeName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAttribNameOrWildcard methodsFor:'accessing'!

attributeName
    ^ attributeName

    "Created: / 21-11-2006 / 21:58:11 / ked"
!

attributeName:something
    attributeName := something.

    "Created: / 21-11-2006 / 21:58:11 / ked"
! !

!AstAttribNameOrWildcard methodsFor:'testing'!

isAstAttribNameOrWildcard
    ^ true

    "Created: / 21-11-2006 / 21:58:21 / ked"
! !

!AstAttribNameOrWildcard methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAttribNameOrWildcard:self

    "Created: / 21-11-2006 / 21:58:27 / ked"
! !

!AstAttribNameOrWildcard class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
