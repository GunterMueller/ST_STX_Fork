"{ Package: 'stx:libscm/git' }"

ExternalAddress subclass:#GitReflogEntryHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Handles'
!


!GitReflogEntryHandle class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^0
! !

!GitReflogEntryHandle class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
