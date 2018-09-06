"{ Package: 'stx:libscm/git' }"

Error subclass:#GitError
	instanceVariableNames:'code klass'
	classVariableNames:''
	poolDictionaries:'GitErrorKlass'
	category:'SCM-Git-Exceptions'
!


!GitError class methodsFor:'raising'!

raise: code
    "Raises a GitError with given code. Class and message is
     take from last giterr_last, which is then cleared."

    ^self new raise: code

    "Created: / 10-09-2012 / 14:17:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

raiseIfError: code
    "Raises a GitError with given code if its an error. 
     Class and message is take from last giterr_last, which is then cleared."

    code ~~ 0"OK" ifTrue:[
        self new raise: code
    ].

    "Created: / 10-09-2012 / 14:25:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitError methodsFor:'accessing'!

code
    ^ code
!

code:anInteger
    code := anInteger.
!

klass
    ^ klass
!

klass:anInteger
    klass := anInteger.
! !

!GitError methodsFor:'raising'!

raise: gitErrorCode
    "Raises a GitError with given code. Class and message is
     take from last giterr_last, which is then cleared."

    | git_error |

    code := gitErrorCode.
    git_error := GitPrimitives prim_giterr_last.
    git_error setSize: 8.
    messageText := (git_error pointerAt: 1) copyCStringFromHeap.
    klass := git_error longAt:1+4.
    GitPrimitives prim_giterr_clear.

    ^self raise

    "Created: / 10-09-2012 / 14:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitError class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
