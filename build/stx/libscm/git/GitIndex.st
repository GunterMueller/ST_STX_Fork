"{ Package: 'stx:libscm/git' }"

GitLibraryObject subclass:#GitIndex
	instanceVariableNames:'repository'
	classVariableNames:''
	poolDictionaries:'GitObjectType'
	category:'SCM-Git-Core'
!


!GitIndex class methodsFor:'instance creation'!

on: path
    "Creates new index on given file. If the file does not exist,
     the index is only in-memory. To write it to disk, use #write"

    | err ref |

    ref := ByteArray new: ExternalBytes sizeofPointer.
    err := GitPrimitives prim_git_index_open: ref index_path: path asString.
            GitError raiseIfError: err.
    ^GitIndex new
        setHandleFromRef: ref;
        yourself

    "Created: / 02-10-2012 / 15:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex methodsFor:'accessing'!

tree
    | oid err |

    oid := GitOid new.
    err := GitPrimitives prim_git_tree_create_fromindex: oid index: handle.
    GitError raiseIfError: err.
    ^repository lookup: oid type: OBJ_TREE

    "Created: / 25-09-2012 / 10:22:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex methodsFor:'adding & removing'!

add: entry
    ^self add: entry stage: 0

    "Created: / 25-09-2012 / 00:26:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

add: entry stage: stage
    | path err |

    path := entry pathNameRelative.
    err := GitPrimitives prim_git_index_add: handle path: path stage: stage.
    GitError raiseIfError: err.

    "Created: / 25-09-2012 / 10:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        GitPrimitives prim_git_index_free: handle. 
        handle := nil.
    ].

    "Created: / 24-09-2012 / 15:40:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex methodsFor:'operations'!

read
    "Add or update an index entry from a file in disk"

    | err |     
    err := GitPrimitives prim_git_index_read: handle.
    GitError raiseIfError: err.

    "Created: / 24-09-2012 / 22:02:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unique
    "Add or update an index entry from a file in disk"

    | err |     
    err := GitPrimitives prim_git_index_uniq: handle.
    GitError raiseIfError: err.

    "Created: / 25-09-2012 / 00:17:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

write
    | err |     

"/    err := GitPrimitives prim_git_index_uniq: handle.
"/    GitError raiseIfError: err.
    err := GitPrimitives prim_git_index_write: handle.
    GitError raiseIfError: err.

    "Created: / 25-09-2012 / 00:17:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex methodsFor:'private-accessing'!

getHandleClass
    ^GitIndexHandle

    "Created: / 25-09-2012 / 00:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setRepository: aGitRepository
    repository := aGitRepository

    "Created: / 24-09-2012 / 21:47:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitIndex class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
