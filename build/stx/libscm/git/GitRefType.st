"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitRefType
	instanceVariableNames:''
	classVariableNames:'REF_INVALID REF_OID REF_SYMBOLIC REF_PACKED REF_HAS_PEEL
		REF_LISTALL'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitRefType class methodsFor:'initialization'!

initialize

    REF_INVALID := 0.
    REF_OID := 1.
    REF_SYMBOLIC := 2.
    REF_PACKED := 4.
    REF_HAS_PEEL := 8.
    REF_LISTALL := 7.
! !

!GitRefType class methodsFor:'constants'!

REF_HAS_PEEL

    ^REF_HAS_PEEL
!

REF_INVALID

    ^REF_INVALID
!

REF_LISTALL

    ^REF_LISTALL
!

REF_OID

    ^REF_OID
!

REF_PACKED

    ^REF_PACKED
!

REF_SYMBOLIC

    ^REF_SYMBOLIC
! !

!GitRefType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitRefType initialize!
