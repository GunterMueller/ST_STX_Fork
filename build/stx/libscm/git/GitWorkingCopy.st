"{ Package: 'stx:libscm/git' }"

GitRepositoryObject subclass:#GitWorkingCopy
	instanceVariableNames:'reference commit index root detached'
	classVariableNames:''
	poolDictionaries:'GitStatusCodes'
	category:'SCM-Git-Core'
!


!GitWorkingCopy methodsFor:'accessing'!

commit
    commit isNil ifTrue:[
        commit := repository lookup: self reference oid.
    ].
    ^ commit

    "Modified: / 30-09-2012 / 10:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index
    "Get the Index file for this repository."

    ^repository index

    "Created: / 24-09-2012 / 15:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    reference isNil ifTrue:[
        reference := repository head.
        detached := repository headIsDetached.
    ].
    ^reference

    "Created: / 30-09-2012 / 10:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

root
    ^ root
! !

!GitWorkingCopy methodsFor:'actions'!

checkout
    self checkout: self reference

    "Created: / 02-10-2012 / 16:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkout: aStringOrOidOrTreeishOrReference
    | obj |

    aStringOrOidOrTreeishOrReference isGitTreeish ifTrue:[
        obj := aStringOrOidOrTreeishOrReference 
    ] ifFalse:[
        | oid |

        aStringOrOidOrTreeishOrReference isGitOid  ifTrue:[
            oid := aStringOrOidOrTreeishOrReference
        ] ifFalse:[
            aStringOrOidOrTreeishOrReference isGitReference ifTrue:[
                oid := aStringOrOidOrTreeishOrReference oid.
            ] ifFalse:[
                oid := GitOid fromString: aStringOrOidOrTreeishOrReference
            ].
        ].
        obj := repository lookup: oid.
    ].

    repository checkout: obj.
    commit := obj.

    "Created: / 19-09-2012 / 14:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message
    ^self commit: message tree: self index tree

    "Created: / 25-09-2012 / 10:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message tree: tree
    ^self commit: message tree: tree parents: (Array with: self commit)

    "Created: / 25-09-2012 / 11:09:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message tree: tree parents: parents 
    ^self commit: message tree: tree parents: parents update: self reference.

    "Created: / 25-09-2012 / 11:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message tree: tree parents: parents update: refOrNil
    ^self commit: message tree: tree parents: parents update: refOrNil commiter: nil.

    "Created: / 25-09-2012 / 12:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message tree: tree parents: parents update: refOrNil commiter: commiterOrNil
    ^self commit: message tree: tree parents: parents update: refOrNil commiter: commiterOrNil author: nil

    "Created: / 25-09-2012 / 14:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message tree: tree parents: parents update: refOrNil commiter: commiterOrNil author: authorOrNil
    reference := commit := detached := nil.
    ^repository commit: message tree: tree parents: parents update: refOrNil commiter: commiterOrNil author: authorOrNil

    "Created: / 25-09-2012 / 14:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stage
    "Stage all unstaged files"

    self entriesAndStatusesDo: [:entry :status|
        (status bitAnd: (GIT_STATUS_WT_MODIFIED | GIT_STATUS_WT_DELETED)) ~~ 0 ifTrue:[
            self index add: entry.            
        ] ifFalse:[
            (status bitAnd: (GIT_STATUS_WT_DELETED)) ~~ 0 ifTrue:[
                self index remove: entry.
            ].
        ].
    ].
    self index write

    "Created: / 25-09-2012 / 00:13:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'enumerating'!

entriesAndStatusesDo: aBlock
    | cb err |

    cb := ExternalFunctionCallback new.
    cb returnType:#int argumentTypes: #(charPointer int pointer).
    cb action:[:path :status :payload|
        aBlock value: (root / path copyCStringFromHeap) value: status
    ].
    cb generateClosure.
    err := GitPrimitives prim_git_status_foreach: repository getHandle callback: cb payload: nil.
    GitError raiseIfError: err.

    "Created: / 25-09-2012 / 00:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'initialization'!

setRepository: aGitRepository
    super setRepository: aGitRepository.
    handle := aGitRepository getHandle.
    root := GitWorkingCopyEntry wc: self path: repository workdir.

    "Created: / 19-09-2012 / 09:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'initialization & release'!

free
    "Nothing to do, I have no backing structure"

    "Modified: / 25-09-2012 / 00:39:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'instance creation'!

/ aString
    ^root construct: aString

    "Created: / 24-09-2012 / 13:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: aString

    ^root construct: aString

    "Created: / 24-09-2012 / 13:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'private'!

statusOf: aStringOrFilenameOrWorkingCopyEntry
    ^repository statusOf: aStringOrFilenameOrWorkingCopyEntry

    "Created: / 24-09-2012 / 22:36:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'private-accessing'!

getHandleClass
    ^ self shouldNotImplement

    "Modified (comment): / 25-09-2012 / 00:39:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy methodsFor:'testing'!

isOffRepo
    "Return true, if the working copy is off-repository, i.e.,
     whether working copy path is not the same as repository
     path."

    ^repository hasOffRepoWorkdir

    "Created: / 02-10-2012 / 16:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitWorkingCopy class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
