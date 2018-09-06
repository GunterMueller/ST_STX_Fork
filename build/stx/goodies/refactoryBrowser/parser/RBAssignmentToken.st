"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBToken subclass:#RBAssignmentToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBAssignmentToken methodsFor:'private'!

length
	^2
! !

!RBAssignmentToken methodsFor:'testing'!

isAssignment
	^true
!

isOldStyleAssignment
        ^false
!

value
        ^ ':='

    "Created: / 08-06-2010 / 13:17:08 / cg"
! !

!RBAssignmentToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBAssignmentToken.st,v 1.9 2014-12-08 17:42:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBAssignmentToken.st,v 1.9 2014-12-08 17:42:41 cg Exp $'
! !

