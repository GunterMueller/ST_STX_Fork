"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitAttrType
	instanceVariableNames:''
	classVariableNames:'ATTR_UNSPECIFIED_T ATTR_TRUE_T ATTR_FALSE_T ATTR_VALUE_T'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitAttrType class methodsFor:'initialization'!

initialize

    ATTR_UNSPECIFIED_T := 0.
    ATTR_TRUE_T := 1.
    ATTR_FALSE_T := 2.
    ATTR_VALUE_T := 3.
! !

!GitAttrType class methodsFor:'constants'!

ATTR_FALSE_T

    ^ATTR_FALSE_T
!

ATTR_TRUE_T

    ^ATTR_TRUE_T
!

ATTR_UNSPECIFIED_T

    ^ATTR_UNSPECIFIED_T
!

ATTR_VALUE_T

    ^ATTR_VALUE_T
! !

!GitAttrType class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitAttrType initialize!
