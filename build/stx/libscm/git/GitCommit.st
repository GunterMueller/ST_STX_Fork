"{ Package: 'stx:libscm/git' }"

GitObject subclass:#GitCommit
	instanceVariableNames:'author commiter message timestamp tree parents'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitCommit class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^0
! !

!GitCommit methodsFor:'accessing'!

/ name
    "Returns an tree entry with given name"

    ^self tree / name

    "Created: / 10-09-2012 / 19:03:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

author
    author isNil ifTrue:[
	author := GitSignature new
		    setHandle: (GitPrimitives prim_git_commit_author: handle)
		    yourself.
    ].
    ^author

    "Created: / 19-09-2012 / 01:23:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

committer
    commiter isNil ifTrue:[
	commiter := GitSignature new
		    setHandleFromExternalAddress: (GitPrimitives prim_git_commit_committer: handle)
		    yourself.
    ].
    ^commiter

    "Created: / 19-09-2012 / 01:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message
    message isNil ifTrue:[
	message := GitPrimitives prim_git_commit_message: handle.
    ].
    ^message

    "Created: / 10-09-2012 / 14:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oid
    oid isNil ifTrue:[
	oid := GitOid fromBytes: (GitPrimitives prim_git_commit_id: handle).
    ].
    ^ oid

    "Created: / 30-09-2012 / 10:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parents
    parents isNil ifTrue:[
	| nparents ref err |
	nparents := GitPrimitives prim_git_commit_parentcount: handle.
	parents := Array new: nparents.
	ref := ByteArray new: ExternalBytes sizeofPointer.
	0 to: nparents - 1 do:[:n|
	    | parent |
	    err := GitPrimitives prim_git_commit_parent: ref commit: handle n: n.
	    GitError raiseIfError: err.
	    parent := GitCommit new.
	    parent setHandleFromRef: ref.
	    parents at: n + 1 put: parent.
	].
    ].

    ^parents.

    "Created: / 30-09-2012 / 10:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tree
    "Return a GitTree associated with this commit"

    tree isNil ifTrue:[
	| ref oid |
	ref := ByteArray new: ExternalBytes sizeofPointer.
	GitError raiseIfError: (GitPrimitives prim_git_commit_tree: ref commit: handle).
	oid := GitPrimitives prim_git_commit_tree_oid: handle.
	tree := GitTree new
		    setHandleFromRef: ref;
		    setOid: oid;
		    setRepository: self repository;
		    yourself.
    ].
    ^tree

    "Created: / 10-09-2012 / 19:02:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommit methodsFor:'private-accessing'!

getHandleClass
    ^GitCommitHandle

    "Created: / 17-09-2012 / 21:20:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommit methodsFor:'testing'!

isGitCommit
    ^true

    "Created: / 19-09-2012 / 13:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isGitTreeish
    ^true

    "Created: / 19-09-2012 / 13:57:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommit class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
