"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitDeltaType
	instanceVariableNames:''
	classVariableNames:'DELTA_UNMODIFIED DELTA_ADDED DELTA_DELETED DELTA_MODIFIED
		DELTA_RENAMED DELTA_COPIED DELTA_IGNORED DELTA_UNTRACKED'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitDeltaType class methodsFor:'initialization'!

initialize

    DELTA_UNMODIFIED := 0.
    DELTA_ADDED := 1.
    DELTA_DELETED := 2.
    DELTA_MODIFIED := 3.
    DELTA_RENAMED := 4.
    DELTA_COPIED := 5.
    DELTA_IGNORED := 6.
    DELTA_UNTRACKED := 7.
! !

!GitDeltaType class methodsFor:'constants'!

DELTA_ADDED

    ^DELTA_ADDED
!

DELTA_COPIED

    ^DELTA_COPIED
!

DELTA_DELETED

    ^DELTA_DELETED
!

DELTA_IGNORED

    ^DELTA_IGNORED
!

DELTA_MODIFIED

    ^DELTA_MODIFIED
!

DELTA_RENAMED

    ^DELTA_RENAMED
!

DELTA_UNMODIFIED

    ^DELTA_UNMODIFIED
!

DELTA_UNTRACKED

    ^DELTA_UNTRACKED
! !

!GitDeltaType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitDeltaType initialize!
