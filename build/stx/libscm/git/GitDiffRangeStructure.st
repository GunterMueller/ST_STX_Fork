"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitDiffRangeStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitDiffRangeStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^16
! !

!GitDiffRangeStructure methodsFor:'accessing'!

newLines
    "Returns int32"

    ^self longAt:1 + 12
!

newLines: value

    self longAt:1 + 12 put:value
!

newStart
    "Returns int32"

    ^self longAt:1 + 8
!

newStart: value

    self longAt:1 + 8 put:value
!

oldLines
    "Returns int32"

    ^self longAt:1 + 4
!

oldLines: value

    self longAt:1 + 4 put:value
!

oldStart
    "Returns int32"

    ^self longAt:1 + 0
!

oldStart: value

    self longAt:1 + 0 put:value
! !

!GitDiffRangeStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
