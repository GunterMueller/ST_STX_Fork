"{ Package: 'stx:libscm/git' }"

SharedPool subclass:#GitCheckoutStrategy
	instanceVariableNames:''
	classVariableNames:'GIT_CHECKOUT_DEFAULT GIT_CHECKOUT_OVERWRITE_MODIFIED
		GIT_CHECKOUT_CREATE_MISSING GIT_CHECKOUT_REMOVE_UNTRACKED
		GIT_CHECKOUT_NONE'
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Constants'
!


!GitCheckoutStrategy class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    GIT_CHECKOUT_DEFAULT :=             1.
    GIT_CHECKOUT_OVERWRITE_MODIFIED :=  2.
    GIT_CHECKOUT_CREATE_MISSING :=      4.
    GIT_CHECKOUT_REMOVE_UNTRACKED :=    8.
    GIT_CHECKOUT_NONE := GIT_CHECKOUT_DEFAULT. "/ more meaningfull alias

    "Modified: / 19-09-2012 / 18:35:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCheckoutStrategy class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !

GitCheckoutStrategy initialize!
