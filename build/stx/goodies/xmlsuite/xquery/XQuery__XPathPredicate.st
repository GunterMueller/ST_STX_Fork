"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#XPathPredicate
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST-XPath'
!


!XPathPredicate methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 17-11-2007 / 09:12:10 / janfrog"
!

expr:anASTNode
    expr := anASTNode.

    "Created: / 17-11-2007 / 09:12:10 / janfrog"
! !

!XPathPredicate methodsFor:'printing'!

printOn: stream

    stream 
        nextPut:$[.
    expr ifNotNil:[
        stream nextPutAll:'...'].

    stream
        nextPut:$]

    "Created: / 15-11-2007 / 23:22:38 / janfrog"
    "Modified: / 17-11-2007 / 09:13:28 / janfrog"
! !

!XPathPredicate methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitXPathPredicate:self

    "Created: / 17-11-2007 / 15:24:14 / janfrog"
! !

!XPathPredicate class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
