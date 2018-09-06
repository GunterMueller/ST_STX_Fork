"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstElementNameOrWildcard
	instanceVariableNames:'elementName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstElementNameOrWildcard methodsFor:'accessing'!

elementName
    ^ elementName

    "Created: / 21-11-2006 / 22:00:13 / ked"
!

elementName:something
    elementName := something.

    "Created: / 21-11-2006 / 22:00:13 / ked"
! !

!AstElementNameOrWildcard methodsFor:'testing'!

isAstElementNameOrWildcard
    ^ true

    "Created: / 21-11-2006 / 22:00:25 / ked"
! !

!AstElementNameOrWildcard methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstElementNameOrWildcard:self

    "Created: / 21-11-2006 / 22:00:20 / ked"
! !

!AstElementNameOrWildcard class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
