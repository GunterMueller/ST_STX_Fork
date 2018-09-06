"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitSubmoduleIgnoreType
	instanceVariableNames:''
	classVariableNames:'SUBMODULE_IGNORE_DEFAULT SUBMODULE_IGNORE_NONE
		SUBMODULE_IGNORE_UNTRACKED SUBMODULE_IGNORE_DIRTY
		SUBMODULE_IGNORE_ALL'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitSubmoduleIgnoreType class methodsFor:'initialization'!

initialize

    SUBMODULE_IGNORE_DEFAULT := -1.
    SUBMODULE_IGNORE_NONE := 0.
    SUBMODULE_IGNORE_UNTRACKED := 1.
    SUBMODULE_IGNORE_DIRTY := 2.
    SUBMODULE_IGNORE_ALL := 3.
! !

!GitSubmoduleIgnoreType class methodsFor:'constants'!

SUBMODULE_IGNORE_ALL

    ^SUBMODULE_IGNORE_ALL
!

SUBMODULE_IGNORE_DEFAULT

    ^SUBMODULE_IGNORE_DEFAULT
!

SUBMODULE_IGNORE_DIRTY

    ^SUBMODULE_IGNORE_DIRTY
!

SUBMODULE_IGNORE_NONE

    ^SUBMODULE_IGNORE_NONE
!

SUBMODULE_IGNORE_UNTRACKED

    ^SUBMODULE_IGNORE_UNTRACKED
! !

!GitSubmoduleIgnoreType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitSubmoduleIgnoreType initialize!
