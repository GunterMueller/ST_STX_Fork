"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstProlog
	instanceVariableNames:'declarations'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstProlog methodsFor:'accessing'!

declarations
    ^ declarations

    "Created: / 24-12-2006 / 15:01:51 / janfrog"
!

declarations:aCollection
    declarations := aCollection.

    "Created: / 24-12-2006 / 15:01:51 / janfrog"
! !

!AstProlog methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstProlog:self

    "Created: / 24-12-2006 / 15:06:03 / janfrog"
! !

!AstProlog class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
