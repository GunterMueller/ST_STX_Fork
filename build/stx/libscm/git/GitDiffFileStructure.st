"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitDiffFileStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitDiffFileStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^40
! !

!GitDiffFileStructure methodsFor:'accessing'!

flags
    "Returns unsigned 
		int32"

    ^self longAt:1 + 32
!

flags: value

    self longAt:1 + 32 put:value
!

mode
    "Returns a Cface::CShortNode"

    ^self longAt:1 + 36
!

mode: value

    self longAt:1 + 36 put:value
!

oid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 0
!

oid: value

    self at:1 + 0 put:value
!

path
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 20
!

path: value

    self pointerAt:1 + 20 put:value
!

size
    "Returns a Cface::CLongNode"

    ^self longLongAt:1 + 24
!

size: value

    self longLongAt:1 + 24 put:value
! !

!GitDiffFileStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
