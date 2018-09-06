"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitCvarType
	instanceVariableNames:''
	classVariableNames:'CVAR_FALSE CVAR_TRUE CVAR_INT32 CVAR_STRING'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitCvarType class methodsFor:'initialization'!

initialize

    CVAR_FALSE := 0.
    CVAR_TRUE := 1.
    CVAR_INT32 := 2.
    CVAR_STRING := 3.
! !

!GitCvarType class methodsFor:'constants'!

CVAR_FALSE

    ^CVAR_FALSE
!

CVAR_INT32

    ^CVAR_INT32
!

CVAR_STRING

    ^CVAR_STRING
!

CVAR_TRUE

    ^CVAR_TRUE
! !

!GitCvarType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitCvarType initialize!
