"{ Package: 'stx:libscm/git' }"

GitObject subclass:#GitTag
	instanceVariableNames:'tree'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitTag methodsFor:'accessing'!

oid     
    oid isNil ifTrue:[
        oid := GitOid fromBytes: (GitPrimitives prim_git_tag_id: handle).
    ].
    ^ oid

    "Created: / 30-09-2012 / 10:40:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTag methodsFor:'testing'!

isGitTag
    ^true

    "Created: / 19-09-2012 / 13:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isGitTreeish
    ^true

    "Created: / 19-09-2012 / 13:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTag class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
