"{ Package: 'stx:libscm/git' }"

SCMAbstractPackageModelRegistry subclass:#GitPackageModelRegistry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-StX'
!


!GitPackageModelRegistry methodsFor:'accessing'!

packageNamed:package
    "Returns a GitPackageWorkingCopy for given package."

    | dir repo |

    packages at: package ifPresent: [ :pkg | ^ pkg ].
    wcs at: package ifPresent:[ :wc | ^ wc ].
    dir := Smalltalk getPackageDirectoryForPackage: package.
    dir := GitRepository discover: dir.
    dir isNil ifTrue:[
        GitError raiseErrorString: 'No repository found for package ',package.
        ^nil.
    ].
    repo := repositories at: dir ifAbsentPut: [ GitRepository open: dir ].
    ^packages at: package ifAbsentPut: [ GitPackageModel name: package repository: repo ].

    "Created: / 06-10-2012 / 22:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 00:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPackageModelRegistry class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
