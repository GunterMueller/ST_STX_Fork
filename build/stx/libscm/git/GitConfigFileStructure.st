"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitConfigFileStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitConfigFileStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^36
! !

!GitConfigFileStructure methodsFor:'accessing'!

cfg
    "Returns (pointer-to ;; Line: 1113
;; Class: GitConfigHandle
)"

    ^self pointerAt:1 + 0
!

cfg: value

    self pointerAt:1 + 0 put:value
!

del
    "Returns (pointer-to ;; Line: 851
)"

    ^self pointerAt:1 + 24
!

del: value

    self pointerAt:1 + 24 put:value
!

foreach
    "Returns (pointer-to ;; Line: 865
)"

    ^self pointerAt:1 + 28
!

foreach: value

    self pointerAt:1 + 28 put:value
!

free
    "Returns (pointer-to ;; Line: 871
)"

    ^self pointerAt:1 + 32
!

free: value

    self pointerAt:1 + 32 put:value
!

get
    "Returns (pointer-to ;; Line: 813
)"

    ^self pointerAt:1 + 8
!

get: value

    self pointerAt:1 + 8 put:value
!

getMultivar
    "Returns (pointer-to ;; Line: 827
)"

    ^self pointerAt:1 + 12
!

getMultivar: value

    self pointerAt:1 + 12 put:value
!

open
    "Returns (pointer-to ;; Line: 805
)"

    ^self pointerAt:1 + 4
!

open: value

    self pointerAt:1 + 4 put:value
!

set
    "Returns (pointer-to ;; Line: 835
)"

    ^self pointerAt:1 + 16
!

set: value

    self pointerAt:1 + 16 put:value
!

setMultivar
    "Returns (pointer-to ;; Line: 844
)"

    ^self pointerAt:1 + 20
!

setMultivar: value

    self pointerAt:1 + 20 put:value
! !

!GitConfigFileStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
