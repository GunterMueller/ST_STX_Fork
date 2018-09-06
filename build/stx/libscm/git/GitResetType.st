"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitResetType
	instanceVariableNames:''
	classVariableNames:'RESET_SOFT RESET_MIXED'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitResetType class methodsFor:'initialization'!

initialize

    RESET_SOFT := 1.
    RESET_MIXED := 2.
! !

!GitResetType class methodsFor:'constants'!

RESET_MIXED

    ^RESET_MIXED
!

RESET_SOFT

    ^RESET_SOFT
! !

!GitResetType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitResetType initialize!
