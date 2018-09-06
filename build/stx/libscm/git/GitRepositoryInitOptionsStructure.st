"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitRepositoryInitOptionsStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitRepositoryInitOptionsStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^28
! !

!GitRepositoryInitOptionsStructure methodsFor:'accessing'!

description
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 12
!

description: value

    self pointerAt:1 + 12 put:value
!

flags
    "Returns unsigned 
		int32"

    ^self longAt:1 + 0
!

flags: value

    self longAt:1 + 0 put:value
!

initialHead
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 20
!

initialHead: value

    self pointerAt:1 + 20 put:value
!

mode
    "Returns unsigned 
		int32"

    ^self longAt:1 + 4
!

mode: value

    self longAt:1 + 4 put:value
!

originUrl
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 24
!

originUrl: value

    self pointerAt:1 + 24 put:value
!

templatePath
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 16
!

templatePath: value

    self pointerAt:1 + 16 put:value
!

workdirPath
    "Returns (pointer-to const 
		char)"

    ^self pointerAt:1 + 8
!

workdirPath: value

    self pointerAt:1 + 8 put:value
! !

!GitRepositoryInitOptionsStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
