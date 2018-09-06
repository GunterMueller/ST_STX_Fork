"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitRemoteCallbacksStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitRemoteCallbacksStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^16
! !

!GitRemoteCallbacksStructure methodsFor:'accessing'!

completion
    "Returns (pointer-to ;; Line: 3643
)"

    ^self pointerAt:1 + 4
!

completion: value

    self pointerAt:1 + 4 put:value
!

data
    "Returns (pointer-to void)"

    ^self pointerAt:1 + 12
!

data: value

    self pointerAt:1 + 12 put:value
!

progress
    "Returns (pointer-to ;; Line: 3636
)"

    ^self pointerAt:1 + 0
!

progress: value

    self pointerAt:1 + 0 put:value
!

updateTips
    "Returns (pointer-to ;; Line: 3652
)"

    ^self pointerAt:1 + 8
!

updateTips: value

    self pointerAt:1 + 8 put:value
! !

!GitRemoteCallbacksStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
