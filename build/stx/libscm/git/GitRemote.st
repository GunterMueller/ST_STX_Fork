"{ Package: 'stx:libscm/git' }"

GitRepositoryObject subclass:#GitRemote
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:'GitObjectType'
	category:'SCM-Git-Core'
!

!GitRemote class methodsFor:'documentation'!

documentation
"
    A GitRemote represents a remote repository.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GitRemote methodsFor:'accessing'!

name
    ^ name
! !

!GitRemote methodsFor:'initialization'!

setName: aString
    name := aString

    "Created: / 30-09-2012 / 20:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRemote methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        GitPrimitives prim_git_remote_free: handle. 
        handle := nil.
    ].

    "Created: / 30-09-2012 / 23:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRemote methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    name printOn:aStream.
    aStream nextPut:$).

    "Modified: / 30-09-2012 / 20:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRemote methodsFor:'private-accessing'!

getHandleClass
    "Returns a class of my handle."

    ^GitRemoteHandle

    "Created: / 30-09-2012 / 20:33:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRemote class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
