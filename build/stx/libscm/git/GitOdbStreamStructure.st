"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitOdbStreamStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitOdbStreamStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^24
! !

!GitOdbStreamStructure methodsFor:'accessing'!

backend
    "Returns (pointer-to ;; Line: 3196
;; Class: GitOdbBackendStructure
)"

    ^self pointerAt:1 + 0
!

backend: value

    self pointerAt:1 + 0 put:value
!

finalizeWrite
    "Returns (pointer-to ;; Line: 1542
)"

    ^self pointerAt:1 + 16
!

finalizeWrite: value

    self pointerAt:1 + 16 put:value
!

free
    "Returns (pointer-to ;; Line: 1548
)"

    ^self pointerAt:1 + 20
!

free: value

    self pointerAt:1 + 20 put:value
!

mode
    "Returns int32"

    ^self longAt:1 + 4
!

mode: value

    self longAt:1 + 4 put:value
!

read
    "Returns (pointer-to ;; Line: 1527
)"

    ^self pointerAt:1 + 8
!

read: value

    self pointerAt:1 + 8 put:value
!

write
    "Returns (pointer-to ;; Line: 1535
)"

    ^self pointerAt:1 + 12
!

write: value

    self pointerAt:1 + 12 put:value
! !

!GitOdbStreamStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
