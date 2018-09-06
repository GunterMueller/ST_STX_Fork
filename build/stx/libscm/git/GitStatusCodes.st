"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitStatusCodes
	instanceVariableNames:''
	classVariableNames:'GIT_STATUS_CURRENT GIT_STATUS_INDEX_NEW GIT_STATUS_INDEX_MODIFIED
		GIT_STATUS_INDEX_DELETED GIT_STATUS_WT_NEW GIT_STATUS_WT_MODIFIED
		GIT_STATUS_WT_DELETED GIT_STATUS_IGNORED'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitStatusCodes class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    GIT_STATUS_CURRENT := 0.
    GIT_STATUS_INDEX_NEW := 1 << 0.
    GIT_STATUS_INDEX_MODIFIED := 1 << 1.
    GIT_STATUS_INDEX_DELETED := 1 << 2.

    GIT_STATUS_WT_NEW := 1 << 3.
    GIT_STATUS_WT_MODIFIED := 1 << 4.
    GIT_STATUS_WT_DELETED := 1 << 5.
    GIT_STATUS_IGNORED := 1 << 6.

    "Modified: / 24-09-2012 / 22:06:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStatusCodes class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitStatusCodes initialize!
