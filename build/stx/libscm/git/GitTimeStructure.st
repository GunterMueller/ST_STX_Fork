"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitTimeStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitTimeStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^12
! !

!GitTimeStructure methodsFor:'accessing'!

offset
    "Returns int32"

    ^self longAt:1 + 8
!

offset: value

    self longAt:1 + 8 put:value
!

time
    "Returns a Cface::CLongNode"

    ^self longLongAt:1 + 0
!

time: value

    self longLongAt:1 + 0 put:value
! !

!GitTimeStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
