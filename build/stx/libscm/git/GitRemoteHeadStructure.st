"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitRemoteHeadStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitRemoteHeadStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^48
! !

!GitRemoteHeadStructure methodsFor:'accessing'!

local
    "Returns int32"

    ^self longAt:1 + 0
!

local: value

    self longAt:1 + 0 put:value
!

loid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 21
!

loid: value

    self at:1 + 21 put:value
!

name
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 44
!

name: value

    self pointerAt:1 + 44 put:value
!

oid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 1
!

oid: value

    self at:1 + 1 put:value
! !

!GitRemoteHeadStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
