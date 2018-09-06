"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitNoteDataStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitNoteDataStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^40
! !

!GitNoteDataStructure methodsFor:'accessing'!

annotatedObjectOid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 20
!

annotatedObjectOid: value

    self at:1 + 20 put:value
!

blobOid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 0
!

blobOid: value

    self at:1 + 0 put:value
! !

!GitNoteDataStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
