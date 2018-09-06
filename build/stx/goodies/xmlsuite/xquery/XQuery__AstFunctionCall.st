"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFunctionCall
	instanceVariableNames:'qname functionParametersList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFunctionCall methodsFor:'accessing'!

functionParametersList
    ^ functionParametersList

    "Created: / 11-11-2006 / 18:52:10 / ked"
!

functionParametersList:something
    functionParametersList := something.

    "Created: / 11-11-2006 / 18:52:10 / ked"
!

qname
    ^ qname

    "Created: / 11-11-2006 / 18:10:38 / ked"
!

qname:something
    qname := something.

    "Created: / 11-11-2006 / 18:10:38 / ked"
! !

!AstFunctionCall methodsFor:'testing'!

isAstFunctionCall
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstFunctionCall methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFunctionCall:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstFunctionCall class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
