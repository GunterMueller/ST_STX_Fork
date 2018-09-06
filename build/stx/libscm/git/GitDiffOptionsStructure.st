"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitDiffOptionsStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitDiffOptionsStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^24
! !

!GitDiffOptionsStructure methodsFor:'accessing'!

contextLines
    "Returns a Cface::CShortNode"

    ^self longAt:1 + 4
!

contextLines: value

    self longAt:1 + 4 put:value
!

flags
    "Returns unsigned 
		int32"

    ^self longAt:1 + 0
!

flags: value

    self longAt:1 + 0 put:value
!

interhunkLines
    "Returns a Cface::CShortNode"

    ^self longAt:1 + 6
!

interhunkLines: value

    self longAt:1 + 6 put:value
!

newPrefix
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 12
!

newPrefix: value

    self pointerAt:1 + 12 put:value
!

oldPrefix
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 8
!

oldPrefix: value

    self pointerAt:1 + 8 put:value
!

pathspec
    "Returns ;; Line: 427
;; Class: GitStrarrayStructure
"

    ^self at:1 + 16
!

pathspec: value

    self at:1 + 16 put:value
! !

!GitDiffOptionsStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
