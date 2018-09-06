"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitObjectType
	instanceVariableNames:''
	classVariableNames:'OBJ_ANY OBJ_BAD OBJ__EXT1 OBJ_COMMIT OBJ_TREE OBJ_BLOB OBJ_TAG
		OBJ__EXT2 OBJ_OFS_DELTA OBJ_REF_DELTA'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitObjectType class methodsFor:'initialization'!

initialize

    OBJ_ANY := -2.
    OBJ_BAD := -1.
    OBJ__EXT1 := 0.
    OBJ_COMMIT := 1.
    OBJ_TREE := 2.
    OBJ_BLOB := 3.
    OBJ_TAG := 4.
    OBJ__EXT2 := 5.
    OBJ_OFS_DELTA := 6.
    OBJ_REF_DELTA := 7.
! !

!GitObjectType class methodsFor:'constants'!

OBJ_ANY

    ^OBJ_ANY
!

OBJ_BAD

    ^OBJ_BAD
!

OBJ_BLOB

    ^OBJ_BLOB
!

OBJ_COMMIT

    ^OBJ_COMMIT
!

OBJ_OFS_DELTA

    ^OBJ_OFS_DELTA
!

OBJ_REF_DELTA

    ^OBJ_REF_DELTA
!

OBJ_TAG

    ^OBJ_TAG
!

OBJ_TREE

    ^OBJ_TREE
!

OBJ__EXT1

    ^OBJ__EXT1
!

OBJ__EXT2

    ^OBJ__EXT2
! !

!GitObjectType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitObjectType initialize!
