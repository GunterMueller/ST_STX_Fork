"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitOdbBackendStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitOdbBackendStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^40
! !

!GitOdbBackendStructure methodsFor:'accessing'!

exists
    "Returns (pointer-to ;; Line: 3164
)"

    ^self pointerAt:1 + 28
!

exists: value

    self pointerAt:1 + 28 put:value
!

foreach
    "Returns (pointer-to ;; Line: 3176
)"

    ^self pointerAt:1 + 32
!

foreach: value

    self pointerAt:1 + 32 put:value
!

free
    "Returns (pointer-to ;; Line: 3182
)"

    ^self pointerAt:1 + 36
!

free: value

    self pointerAt:1 + 36 put:value
!

odb
    "Returns (pointer-to ;; Line: 317
;; Class: GitOdbHandle
)"

    ^self pointerAt:1 + 0
!

odb: value

    self pointerAt:1 + 0 put:value
!

read
    "Returns (pointer-to ;; Line: 3109
)"

    ^self pointerAt:1 + 4
!

read: value

    self pointerAt:1 + 4 put:value
!

readHeader
    "Returns (pointer-to ;; Line: 3130
)"

    ^self pointerAt:1 + 12
!

readHeader: value

    self pointerAt:1 + 12 put:value
!

readPrefix
    "Returns (pointer-to ;; Line: 3121
)"

    ^self pointerAt:1 + 8
!

readPrefix: value

    self pointerAt:1 + 8 put:value
!

readstream
    "Returns (pointer-to ;; Line: 3157
)"

    ^self pointerAt:1 + 24
!

readstream: value

    self pointerAt:1 + 24 put:value
!

write
    "Returns (pointer-to ;; Line: 3140
)"

    ^self pointerAt:1 + 16
!

write: value

    self pointerAt:1 + 16 put:value
!

writestream
    "Returns (pointer-to ;; Line: 3149
)"

    ^self pointerAt:1 + 20
!

writestream: value

    self pointerAt:1 + 20 put:value
! !

!GitOdbBackendStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
