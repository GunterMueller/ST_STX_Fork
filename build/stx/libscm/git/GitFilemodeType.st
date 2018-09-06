"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitFilemodeType
	instanceVariableNames:''
	classVariableNames:'FILEMODE_NEW FILEMODE_TREE FILEMODE_BLOB FILEMODE_BLOB_EXECUTABLE
		FILEMODE_LINK FILEMODE_COMMIT'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitFilemodeType class methodsFor:'initialization'!

initialize

    FILEMODE_NEW := 0.
    FILEMODE_TREE := 16384.
    FILEMODE_BLOB := 33188.
    FILEMODE_BLOB_EXECUTABLE := 33261.
    FILEMODE_LINK := 40960.
    FILEMODE_COMMIT := 57344.
! !

!GitFilemodeType class methodsFor:'constants'!

FILEMODE_BLOB

    ^FILEMODE_BLOB
!

FILEMODE_BLOB_EXECUTABLE

    ^FILEMODE_BLOB_EXECUTABLE
!

FILEMODE_COMMIT

    ^FILEMODE_COMMIT
!

FILEMODE_LINK

    ^FILEMODE_LINK
!

FILEMODE_NEW

    ^FILEMODE_NEW
!

FILEMODE_TREE

    ^FILEMODE_TREE
! !

!GitFilemodeType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitFilemodeType initialize!
