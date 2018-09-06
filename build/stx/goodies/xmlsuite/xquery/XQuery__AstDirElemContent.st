"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDirElemContent
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDirElemContent methodsFor:'accessing'!

content
    ^ content

    "Created: / 30-06-2006 / 20:29:40 / ked"
!

content:something
    content := something.

    "Created: / 30-06-2006 / 20:29:40 / ked"
! !

!AstDirElemContent methodsFor:'testing'!

isAstDirElemContent
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstDirElemContent methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDirElemContent:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstDirElemContent class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
