"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitIndexerStatsStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitIndexerStatsStructure class methodsFor:'instance creation'!

new
    ^self new: self structSize

    "Created: / 19-09-2012 / 09:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndexerStatsStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^12
! !

!GitIndexerStatsStructure methodsFor:'accessing'!

processed
    "Returns unsigned 
		int32"

    ^self longAt:1 + 4
!

processed: value

    self longAt:1 + 4 put:value
!

received
    "Returns unsigned 
		int32"

    ^self longAt:1 + 8
!

received: value

    self longAt:1 + 8 put:value
!

total
    "Returns unsigned 
		int32"

    ^self longAt:1 + 0
!

total: value

    self longAt:1 + 0 put:value
! !

!GitIndexerStatsStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
