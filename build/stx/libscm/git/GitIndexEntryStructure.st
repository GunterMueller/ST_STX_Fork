"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitIndexEntryStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitIndexEntryStructure class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^80
! !

!GitIndexEntryStructure methodsFor:'accessing'!

ctime
    "Returns ;; Line: 447
;; Class: GitIndexTimeStructure
"

    ^self at:1 + 0
!

ctime: value

    self at:1 + 0 put:value
!

dev
    "Returns unsigned 
		int32"

    ^self longAt:1 + 24
!

dev: value

    self longAt:1 + 24 put:value
!

fileSize
    "Returns a Cface::CLongNode"

    ^self longLongAt:1 + 44
!

fileSize: value

    self longLongAt:1 + 44 put:value
!

flags
    "Returns a Cface::CShortNode"

    ^self longAt:1 + 72
!

flags: value

    self longAt:1 + 72 put:value
!

flagsExtended
    "Returns a Cface::CShortNode"

    ^self longAt:1 + 74
!

flagsExtended: value

    self longAt:1 + 74 put:value
!

gid
    "Returns unsigned 
		int32"

    ^self longAt:1 + 40
!

gid: value

    self longAt:1 + 40 put:value
!

ino
    "Returns unsigned 
		int32"

    ^self longAt:1 + 28
!

ino: value

    self longAt:1 + 28 put:value
!

mode
    "Returns unsigned 
		int32"

    ^self longAt:1 + 32
!

mode: value

    self longAt:1 + 32 put:value
!

mtime
    "Returns ;; Line: 447
;; Class: GitIndexTimeStructure
"

    ^self at:1 + 12
!

mtime: value

    self at:1 + 12 put:value
!

oid
    "Returns ;; Line: 1476
;; Class: GitOidStructure
"

    ^self at:1 + 52
!

oid: value

    self at:1 + 52 put:value
!

path
    "Returns (pointer-to char)"

    ^self pointerAt:1 + 76
!

path: value

    self pointerAt:1 + 76 put:value
!

uid
    "Returns unsigned 
		int32"

    ^self longAt:1 + 36
!

uid: value

    self longAt:1 + 36 put:value
! !

!GitIndexEntryStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
