"{ Package: 'stx:libscm/git' }"

SCMAbstractPackageModel subclass:#GitPackageModel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-StX'
!


!GitPackageModel methodsFor:'accessing'!

manager
    "Returns a source code manager for this kind of package"

    ^GitSourceCodeManager2

    "Created: / 14-11-2012 / 01:02:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPackageModel methodsFor:'accessing-tasks'!

commitTaskClass
    ^SCMAbstractCommitTask

    "Created: / 13-11-2012 / 23:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPackageModel methodsFor:'utils'!

ensureWorkingCopy
    "Nothing to do, got GIT, there is always WC"

    wc isNil ifTrue:[
        self wc: repository workingCopy
    ]

    "Created: / 07-10-2012 / 09:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 00:32:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitPackageModel class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
