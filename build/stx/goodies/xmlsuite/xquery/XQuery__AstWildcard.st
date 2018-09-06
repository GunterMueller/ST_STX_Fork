"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstWildcard
	instanceVariableNames:'ncName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstWildcard methodsFor:'accessing'!

ncName
    ^ ncName

    "Created: / 18-03-2006 / 21:06:49 / ked"
!

ncName:something
    ncName := something.

    "Created: / 18-03-2006 / 21:06:49 / ked"
! !

!AstWildcard methodsFor:'testing'!

isAstWildcard
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstWildcard methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstWildcard:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstWildcard class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
