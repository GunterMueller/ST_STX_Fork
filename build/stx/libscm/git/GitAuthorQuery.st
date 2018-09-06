"{ Package: 'stx:libscm/git' }"

GitSignatureQuery subclass:#GitAuthorQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Exceptions'
!


!GitAuthorQuery class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
