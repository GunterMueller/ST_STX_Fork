"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitSubmoduleUpdateType
	instanceVariableNames:''
	classVariableNames:'SUBMODULE_UPDATE_DEFAULT SUBMODULE_UPDATE_CHECKOUT
		SUBMODULE_UPDATE_REBASE SUBMODULE_UPDATE_MERGE
		SUBMODULE_UPDATE_NONE'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitSubmoduleUpdateType class methodsFor:'initialization'!

initialize

    SUBMODULE_UPDATE_DEFAULT := -1.
    SUBMODULE_UPDATE_CHECKOUT := 0.
    SUBMODULE_UPDATE_REBASE := 1.
    SUBMODULE_UPDATE_MERGE := 2.
    SUBMODULE_UPDATE_NONE := 3.
! !

!GitSubmoduleUpdateType class methodsFor:'constants'!

SUBMODULE_UPDATE_CHECKOUT

    ^SUBMODULE_UPDATE_CHECKOUT
!

SUBMODULE_UPDATE_DEFAULT

    ^SUBMODULE_UPDATE_DEFAULT
!

SUBMODULE_UPDATE_MERGE

    ^SUBMODULE_UPDATE_MERGE
!

SUBMODULE_UPDATE_NONE

    ^SUBMODULE_UPDATE_NONE
!

SUBMODULE_UPDATE_REBASE

    ^SUBMODULE_UPDATE_REBASE
! !

!GitSubmoduleUpdateType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitSubmoduleUpdateType initialize!
