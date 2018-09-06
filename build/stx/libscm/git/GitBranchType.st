"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitBranchType
	instanceVariableNames:''
	classVariableNames:'BRANCH_LOCAL BRANCH_REMOTE'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitBranchType class methodsFor:'initialization'!

initialize

    BRANCH_LOCAL := 1.
    BRANCH_REMOTE := 2.
! !

!GitBranchType class methodsFor:'constants'!

BRANCH_LOCAL

    ^BRANCH_LOCAL
!

BRANCH_REMOTE

    ^BRANCH_REMOTE
! !

!GitBranchType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitBranchType initialize!
