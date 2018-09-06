"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstElementContentChar
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstElementContentChar methodsFor:'accessing'!

content
    ^ content
!

content:something
    content := something.
! !

!AstElementContentChar methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstElementContentChar:self
! !

!AstElementContentChar class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
