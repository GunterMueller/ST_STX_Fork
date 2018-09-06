"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFunctionParametersList
	instanceVariableNames:'exprSingle functionParametersList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFunctionParametersList methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 11-11-2006 / 18:51:18 / ked"
!

exprSingle:something
    exprSingle := something.

    "Created: / 11-11-2006 / 18:51:18 / ked"
!

functionParametersList
    ^ functionParametersList

    "Created: / 11-11-2006 / 18:51:18 / ked"
!

functionParametersList:something
    functionParametersList := something.

    "Created: / 11-11-2006 / 18:51:18 / ked"
! !

!AstFunctionParametersList methodsFor:'testing'!

isAstFunctionParametersList
    ^ true

    "Created: / 11-11-2006 / 18:51:39 / ked"
! !

!AstFunctionParametersList methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFunctionParametersList:self

    "Created: / 11-11-2006 / 18:51:30 / ked"
! !

!AstFunctionParametersList class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
