"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstMainModule
	instanceVariableNames:'prolog queryBody source'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstMainModule methodsFor:'accessing'!

prolog
    ^ prolog

    "Created: / 24-12-2006 / 14:55:53 / janfrog"
!

prolog:anAstProlog
    prolog := anAstProlog.

    "Created: / 24-12-2006 / 14:55:54 / janfrog"
!

queryBody
    ^ queryBody

    "Created: / 24-12-2006 / 14:55:54 / janfrog"
!

queryBody:anAstExpr
    queryBody := anAstExpr.

    "Created: / 24-12-2006 / 14:55:54 / janfrog"
!

source
    ^ source

    "Created: / 12-04-2007 / 11:17:11 / janfrog"
!

source:sourceObject

    "sourceObject should be anything what undestands
     asString and returns appropriate string form of
     module source"
    
    source := sourceObject.

    "Created: / 12-04-2007 / 11:17:11 / janfrog"
!

sourceString
    ^ self source contents

    "Created: / 12-04-2007 / 11:18:19 / janfrog"
    "Modified: / 04-05-2010 / 18:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AstMainModule methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstMainModule:self

    "Created: / 24-12-2006 / 14:56:26 / janfrog"
! !

!AstMainModule class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
