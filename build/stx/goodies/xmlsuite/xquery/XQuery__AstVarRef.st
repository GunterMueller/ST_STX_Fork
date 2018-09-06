"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstVarRef
	instanceVariableNames:'varName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstVarRef methodsFor:'accessing'!

varName
    ^ varName

    "Created: / 18-03-2006 / 21:21:15 / ked"
!

varName:something
    varName := something.

    "Created: / 18-03-2006 / 21:21:15 / ked"
! !

!AstVarRef methodsFor:'testing'!

isAstVarRef
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstVarRef methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstVarRef:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstVarRef class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
