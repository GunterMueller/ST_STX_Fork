"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitRemoteCompletionType
	instanceVariableNames:''
	classVariableNames:'REMOTE_COMPLETION_DOWNLOAD REMOTE_COMPLETION_INDEXING
		REMOTE_COMPLETION_ERROR'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitRemoteCompletionType class methodsFor:'initialization'!

initialize

    REMOTE_COMPLETION_DOWNLOAD := 0.
    REMOTE_COMPLETION_INDEXING := 1.
    REMOTE_COMPLETION_ERROR := 2.
! !

!GitRemoteCompletionType class methodsFor:'constants'!

REMOTE_COMPLETION_DOWNLOAD

    ^REMOTE_COMPLETION_DOWNLOAD
!

REMOTE_COMPLETION_ERROR

    ^REMOTE_COMPLETION_ERROR
!

REMOTE_COMPLETION_INDEXING

    ^REMOTE_COMPLETION_INDEXING
! !

!GitRemoteCompletionType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitRemoteCompletionType initialize!
