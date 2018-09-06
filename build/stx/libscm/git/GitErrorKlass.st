"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitErrorKlass
	instanceVariableNames:''
	classVariableNames:'GITERR_NOMEMORY GITERR_OS GITERR_INVALID GITERR_REFERENCE
		GITERR_ZLIB GITERR_REPOSITORY GITERR_CONFIG GITERR_REGEX
		GITERR_ODB GITERR_INDEX GITERR_OBJECT GITERR_NET GITERR_TAG
		GITERR_TREE GITERR_INDEXER GITERR_SSL GITERR_SUBMODULE'
	poolDictionaries:''
	category:'Git-Internal-Constants'
!


!GitErrorKlass class methodsFor:'initialization'!

initialize

    GITERR_NOMEMORY := 0.
    GITERR_OS := 1.
    GITERR_INVALID := 2.
    GITERR_REFERENCE := 3.
    GITERR_ZLIB := 4.
    GITERR_REPOSITORY := 5.
    GITERR_CONFIG := 6.
    GITERR_REGEX := 7.
    GITERR_ODB := 8.
    GITERR_INDEX := 9.
    GITERR_OBJECT := 10.
    GITERR_NET := 11.
    GITERR_TAG := 12.
    GITERR_TREE := 13.
    GITERR_INDEXER := 14.
    GITERR_SSL := 15.
    GITERR_SUBMODULE := 16.
! !

!GitErrorKlass class methodsFor:'constants'!

GITERR_CONFIG

    ^GITERR_CONFIG
!

GITERR_INDEX

    ^GITERR_INDEX
!

GITERR_INDEXER

    ^GITERR_INDEXER
!

GITERR_INVALID

    ^GITERR_INVALID
!

GITERR_NET

    ^GITERR_NET
!

GITERR_NOMEMORY

    ^GITERR_NOMEMORY
!

GITERR_OBJECT

    ^GITERR_OBJECT
!

GITERR_ODB

    ^GITERR_ODB
!

GITERR_OS

    ^GITERR_OS
!

GITERR_REFERENCE

    ^GITERR_REFERENCE
!

GITERR_REGEX

    ^GITERR_REGEX
!

GITERR_REPOSITORY

    ^GITERR_REPOSITORY
!

GITERR_SSL

    ^GITERR_SSL
!

GITERR_SUBMODULE

    ^GITERR_SUBMODULE
!

GITERR_TAG

    ^GITERR_TAG
!

GITERR_TREE

    ^GITERR_TREE
!

GITERR_ZLIB

    ^GITERR_ZLIB
! !

!GitErrorKlass class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitErrorKlass initialize!
