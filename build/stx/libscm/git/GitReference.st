"{ Package: 'stx:libscm/git' }"

GitLibraryObject subclass:#GitReference
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitReference methodsFor:'accessing'!

name
    name isNil ifTrue:[
        name := (GitPrimitives prim_git_reference_name: handle) 
    ].
    ^name

    "Created: / 25-09-2012 / 11:00:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oid

    ^ GitOid fromBytes: (GitPrimitives prim_git_reference_oid: handle).

    "Created: / 25-09-2012 / 10:48:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitReference methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        GitPrimitives prim_git_reference_free: handle. 
        handle := nil.
    ].

    "Created: / 25-09-2012 / 10:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitReference methodsFor:'private-accessing'!

getHandleClass
    ^GitReferenceHandle

    "Created: / 25-09-2012 / 10:44:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitReference methodsFor:'testing'!

isGitReference
    ^true

    "Created: / 02-10-2012 / 16:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitReference class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
