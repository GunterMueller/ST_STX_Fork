"{ Package: 'stx:libscm/git' }"

GitObject subclass:#GitTree
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitTree class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize

    ^0
! !

!GitTree methodsFor:'accessing'!

/ name
    "Returns an tree entry with given name"

    self subclassResponsibility

    "Created: / 10-09-2012 / 19:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oid     
    oid isNil ifTrue:[
        oid := GitOid fromBytes: (GitPrimitives prim_git_tree_id: handle).
    ].
    ^ oid

    "Created: / 30-09-2012 / 10:40:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTree methodsFor:'private-accessing'!

getHandleClass
    ^GitTreeHandle

    "Created: / 17-09-2012 / 21:20:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTree methodsFor:'testing'!

isGitTree
    ^true

    "Created: / 19-09-2012 / 13:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isGitTreeish
    ^true

    "Created: / 19-09-2012 / 13:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTree class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
