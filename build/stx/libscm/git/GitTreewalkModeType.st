"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitTreewalkModeType
	instanceVariableNames:''
	classVariableNames:'TREEWALK_PRE TREEWALK_POST'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitTreewalkModeType class methodsFor:'initialization'!

initialize

    TREEWALK_PRE := 0.
    TREEWALK_POST := 1.
! !

!GitTreewalkModeType class methodsFor:'constants'!

TREEWALK_POST

    ^TREEWALK_POST
!

TREEWALK_PRE

    ^TREEWALK_PRE
! !

!GitTreewalkModeType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitTreewalkModeType initialize!
