"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstPredefinedEntityRef
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstPredefinedEntityRef methodsFor:'accessing'!

content
    ^ content

    "Created: / 01-07-2006 / 12:10:44 / ked"
!

content:something
    content := something.

    "Created: / 01-07-2006 / 12:10:44 / ked"
! !

!AstPredefinedEntityRef methodsFor:'testing'!

isAstPredefinedEntityRef
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstPredefinedEntityRef methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstPredefinedEntityRef:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstPredefinedEntityRef class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
