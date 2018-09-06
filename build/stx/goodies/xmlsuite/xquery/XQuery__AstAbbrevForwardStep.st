"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAbbrevForwardStep
	instanceVariableNames:'stepType nodeTest'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAbbrevForwardStep methodsFor:'accessing'!

nodeTest
    ^ nodeTest

    "Created: / 08-10-2006 / 17:01:11 / ked"
    "Modified: / 21-03-2007 / 18:57:53 / janfrog"
!

nodeTest:something
    nodeTest := something.

    "Created: / 08-10-2006 / 17:01:11 / ked"
!

stepType
    ^ stepType ? #attribute

    "Created: / 08-10-2006 / 17:01:11 / ked"
    "Modified: / 21-03-2007 / 18:58:20 / janfrog"
!

stepType:something
    stepType := something.

    "Created: / 08-10-2006 / 17:01:11 / ked"
! !

!AstAbbrevForwardStep methodsFor:'parse tree helpers'!

childNodes

    ^Array 
        with: stepType
        with: nodeTest

    "Created: / 21-03-2007 / 17:48:57 / janfrog"
! !

!AstAbbrevForwardStep methodsFor:'testing'!

isAstAbbrevForwardStep
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstAbbrevForwardStep methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAbbrevForwardStep:self

    "Created: / 08-10-2006 / 17:03:54 / ked"
! !

!AstAbbrevForwardStep class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
