"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitIndexEntryUnmergedStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitIndexEntryUnmergedStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^76
! !

!GitIndexEntryUnmergedStructure methodsFor:'accessing'!

mode
    "Returns a Cface::CArrayNode"

    ^self at:1 + 0
!

mode: value

    self at:1 + 0 put:value
!

oid
    "Returns a Cface::CArrayNode"

    ^self at:1 + 12
!

oid: value

    self at:1 + 12 put:value
!

path
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 72
!

path: value

    self pointerAt:1 + 72 put:value
! !

!GitIndexEntryUnmergedStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
