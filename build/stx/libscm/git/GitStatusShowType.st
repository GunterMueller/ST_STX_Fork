"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitStatusShowType
	instanceVariableNames:''
	classVariableNames:'STATUS_SHOW_INDEX_AND_WORKDIR STATUS_SHOW_INDEX_ONLY
		STATUS_SHOW_WORKDIR_ONLY STATUS_SHOW_INDEX_THEN_WORKDIR'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitStatusShowType class methodsFor:'initialization'!

initialize

    STATUS_SHOW_INDEX_AND_WORKDIR := 0.
    STATUS_SHOW_INDEX_ONLY := 1.
    STATUS_SHOW_WORKDIR_ONLY := 2.
    STATUS_SHOW_INDEX_THEN_WORKDIR := 3.
! !

!GitStatusShowType class methodsFor:'constants'!

STATUS_SHOW_INDEX_AND_WORKDIR

    ^STATUS_SHOW_INDEX_AND_WORKDIR
!

STATUS_SHOW_INDEX_ONLY

    ^STATUS_SHOW_INDEX_ONLY
!

STATUS_SHOW_INDEX_THEN_WORKDIR

    ^STATUS_SHOW_INDEX_THEN_WORKDIR
!

STATUS_SHOW_WORKDIR_ONLY

    ^STATUS_SHOW_WORKDIR_ONLY
! !

!GitStatusShowType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitStatusShowType initialize!
