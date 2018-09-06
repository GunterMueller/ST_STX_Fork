"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitCvarMapStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitCvarMapStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^12
! !

!GitCvarMapStructure methodsFor:'accessing'!

cvarType
    "Returns ;; Line: 2882
;; Class: GitCvarType
(enum git_cvar_t
	(value (GIT_CVAR_FALSE) 0)
	(value (GIT_CVAR_TRUE) 1)
	(value (GIT_CVAR_INT32) 2)
	(value (GIT_CVAR_STRING) 3) )"

    ^self doubleWordAt:1 + 0
!

cvarType: value

    self doubleWordAt:1 + 0 put:value
!

mapValue
    "Returns int32"

    ^self longAt:1 + 8
!

mapValue: value

    self longAt:1 + 8 put:value
!

strMatch
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 4
!

strMatch: value

    self pointerAt:1 + 4 put:value
! !

!GitCvarMapStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
