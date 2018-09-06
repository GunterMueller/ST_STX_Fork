"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitSignatureStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitSignatureStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^20
! !

!GitSignatureStructure methodsFor:'accessing'!

email
    "Returns (pointer-to char)"

    ^ExternalAddress new setAddress: (self longAt:1 + 4)

    "Modified: / 19-09-2012 / 01:57:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

email: value

    self longAt:1 + 4 put:value

    "Modified: / 25-09-2012 / 14:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "Returns (pointer-to char)"

    ^ExternalAddress new setAddress: (self longAt:1 + 0)

    "Modified: / 19-09-2012 / 01:55:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name: value

    self longAt:1 + 0 put:value

    "Modified: / 25-09-2012 / 14:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

offset"^ <SmallInteger>"
    
    ^self longAt:1 + 8 + 8

    "Created: / 25-09-2012 / 14:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

offset: value"<SmallInteger>"
    
    ^self longAt:1 + 8 + 8 put: value

    "Created: / 25-09-2012 / 14:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

time"^ <LargeInteger>"
    
    ^self unsignedLongLongAt:1 + 8 bigEndian:UninterpretedBytes isBigEndian

    "Created: / 25-09-2012 / 14:46:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

time: value"<LargeInteger>"
    
    ^self unsignedLongLongAt:1 + 8 put: value

    "Created: / 25-09-2012 / 14:46:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignatureStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
