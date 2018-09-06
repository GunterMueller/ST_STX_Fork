"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitErrorStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitErrorStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^8
! !

!GitErrorStructure methodsFor:'accessing'!

klass
    "Returns int32"

    ^self longAt:1 + 4
!

klass: value

    self longAt:1 + 4 put:value
!

message
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 0
!

message: value

    self pointerAt:1 + 0 put:value
! !

!GitErrorStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
