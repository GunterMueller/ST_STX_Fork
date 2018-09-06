"{ Package: 'stx:libscm/git' }"

GitRepositoryObject subclass:#GitObject
	instanceVariableNames:'oid'
	classVariableNames:''
	poolDictionaries:'GitObjectType'
	category:'SCM-Git-Core'
!


!GitObject class methodsFor:'instance creation'!

newForType: type
    type == OBJ_ANY ifTrue:[
        ^self new
    ].
    type == OBJ_COMMIT ifTrue:[
        ^GitCommit new
    ].
    type == OBJ_TREE ifTrue:[
        ^GitTree new
    ].
    type == OBJ_TAG ifTrue:[
        ^GitTag new 
    ].
    type == OBJ_BLOB ifTrue:[
        ^GitBlob new
    ].
    self error:'Unsupported git object type: ', type printString.

    "Created: / 10-09-2012 / 18:52:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitObject class methodsFor:'accessing'!

structSize
    "Returns size of undelaying structure in bytes"

    ^0
! !

!GitObject methodsFor:'accessing'!

oid     
    oid isNil ifTrue:[
        " Replace by proper git_*_id call ------------v               "
        oid := GitOid fromBytes: (GitPrimitives subclassResponsibility).
    ].
    ^ oid

    "Modified: / 30-09-2012 / 10:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitObject methodsFor:'initialization'!

setOid: aGitOid
    oid := aGitOid

    "Created: / 10-09-2012 / 18:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitObject methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        GitPrimitives prim_git_object_free: handle.
        handle := nil.
    ].

    "Created: / 17-09-2012 / 21:16:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitObject methodsFor:'testing'!

isGitObject
    ^true

    "Created: / 19-09-2012 / 13:55:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitObject class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
