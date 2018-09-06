"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitStatusOptionsStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitStatusOptionsStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^16
! !

!GitStatusOptionsStructure methodsFor:'accessing'!

flags
    "Returns unsigned 
		int32"

    ^self longAt:1 + 4
!

flags: value

    self longAt:1 + 4 put:value
!

pathspec
    "Returns ;; Line: 427
;; Class: GitStrarrayStructure
"

    ^self at:1 + 8
!

pathspec: value

    self at:1 + 8 put:value
!

show
    "Returns ;; Line: 620
;; Class: GitStatusShowType
(enum git_status_show_t
	(value (GIT_STATUS_SHOW_INDEX_AND_WORKDIR) 0)
	(value (GIT_STATUS_SHOW_INDEX_ONLY) 1)
	(value (GIT_STATUS_SHOW_WORKDIR_ONLY) 2)
	(value (GIT_STATUS_SHOW_INDEX_THEN_WORKDIR) 3) )"

    ^self doubleWordAt:1 + 0
!

show: value

    self doubleWordAt:1 + 0 put:value
! !

!GitStatusOptionsStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
