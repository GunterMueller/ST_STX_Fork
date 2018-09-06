"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitIndexTimeStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitIndexTimeStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^12
! !

!GitIndexTimeStructure methodsFor:'accessing'!

nanoseconds
    "Returns unsigned 
		int32"

    ^self longAt:1 + 8
!

nanoseconds: value

    self longAt:1 + 8 put:value
!

seconds
    "Returns a Cface::CLongNode"

    ^self longLongAt:1 + 0
!

seconds: value

    self longLongAt:1 + 0 put:value
! !

!GitIndexTimeStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
