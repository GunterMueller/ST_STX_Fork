"{ Package: 'stx:libscm/git' }"

GitSignatureQuery subclass:#GitCommitterQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Exceptions'
!


!GitCommitterQuery methodsFor:'default values'!

defaultResumeValue
    ^GitSignature default

    "Created: / 25-09-2012 / 11:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommitterQuery class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
