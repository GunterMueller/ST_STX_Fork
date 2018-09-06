"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBAssignmentToken subclass:#RBOldStyleAssignmentToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBOldStyleAssignmentToken methodsFor:'private'!

length
    ^ 1
! !

!RBOldStyleAssignmentToken methodsFor:'testing'!

isOldStyleAssignment
        ^true
! !

!RBOldStyleAssignmentToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBOldStyleAssignmentToken.st,v 1.2 2014-12-31 16:44:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBOldStyleAssignmentToken.st,v 1.2 2014-12-31 16:44:19 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

