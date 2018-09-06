"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstBooleanLiteral
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstBooleanLiteral class methodsFor:'instance creation'!

falseLiteral

    ^self new content: false

    "Created: / 28-03-2007 / 20:28:08 / janfrog"
!

trueLiteral

    ^self new content: true

    "Created: / 28-03-2007 / 20:27:49 / janfrog"
! !

!AstBooleanLiteral methodsFor:'accessing'!

content
    ^ content

    "Created: / 28-03-2007 / 17:34:42 / janfrog"
!

content:something
    content := something.

    "Created: / 28-03-2007 / 17:34:42 / janfrog"
! !

!AstBooleanLiteral methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstBooleanLiteral:self

    "Created: / 28-03-2007 / 17:34:52 / janfrog"
! !

!AstBooleanLiteral class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
