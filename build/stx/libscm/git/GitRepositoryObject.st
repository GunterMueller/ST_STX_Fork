"{ Package: 'stx:libscm/git' }"

GitLibraryObject subclass:#GitRepositoryObject
	instanceVariableNames:'repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!

!GitRepositoryObject class methodsFor:'documentation'!

documentation
"
    An abstract superclass for all objects that know the
    repository they belong to

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        repository      <GitRepository> a repository which the object
                                        belong to.

    [class variables:]

    [see also:]

"
! !

!GitRepositoryObject methodsFor:'accessing'!

repository
    ^ repository
! !

!GitRepositoryObject methodsFor:'initialization'!

setRepository: aGitRepository
    repository := aGitRepository

    "Created: / 10-09-2012 / 18:50:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepositoryObject class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
