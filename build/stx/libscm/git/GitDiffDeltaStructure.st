"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitDiffDeltaStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitDiffDeltaStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^92
! !

!GitDiffDeltaStructure methodsFor:'accessing'!

binary
    "Returns int32"

    ^self longAt:1 + 88
!

binary: value

    self longAt:1 + 88 put:value
!

newFile
    "Returns ;; Line: 3277
;; Class: GitDiffFileStructure
"

    ^self at:1 + 40
!

newFile: value

    self at:1 + 40 put:value
!

oldFile
    "Returns ;; Line: 3277
;; Class: GitDiffFileStructure
"

    ^self at:1 + 0
!

oldFile: value

    self at:1 + 0 put:value
!

similarity
    "Returns unsigned 
		int32"

    ^self longAt:1 + 84
!

similarity: value

    self longAt:1 + 84 put:value
!

status
    "Returns ;; Line: 3004
;; Class: GitDeltaType
(enum git_delta_t
	(value (GIT_DELTA_UNMODIFIED) 0)
	(value (GIT_DELTA_ADDED) 1)
	(value (GIT_DELTA_DELETED) 2)
	(value (GIT_DELTA_MODIFIED) 3)
	(value (GIT_DELTA_RENAMED) 4)
	(value (GIT_DELTA_COPIED) 5)
	(value (GIT_DELTA_IGNORED) 6)
	(value (GIT_DELTA_UNTRACKED) 7) )"

    ^self doubleWordAt:1 + 80
!

status: value

    self doubleWordAt:1 + 80 put:value
! !

!GitDiffDeltaStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
