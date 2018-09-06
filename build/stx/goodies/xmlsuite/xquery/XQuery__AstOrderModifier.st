"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOrderModifier
	instanceVariableNames:'ascDesc greatestLeast'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOrderModifier methodsFor:'accessing'!

ascDesc
    ^ ascDesc

    "Created: / 17-03-2006 / 16:05:38 / ked"
!

ascDesc:something
    ascDesc := something.

    "Created: / 17-03-2006 / 16:05:38 / ked"
!

greatestLeast
    ^ greatestLeast

    "Created: / 13-09-2006 / 22:38:52 / ked"
!

greatestLeast:something
    greatestLeast := something.

    "Created: / 13-09-2006 / 22:38:52 / ked"
! !

!AstOrderModifier methodsFor:'testing'!

isAstOrderModifier
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstOrderModifier methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstOrderModifier:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstOrderModifier class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
