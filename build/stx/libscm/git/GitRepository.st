"{ Package: 'stx:libscm/git' }"

GitLibraryObject subclass:#GitRepository
	instanceVariableNames:'path workdir remotes index'
	classVariableNames:''
	poolDictionaries:'GitObjectType GitStatusCodes'
	category:'SCM-Git-Core'
!


!GitRepository class methodsFor:'instance creation'!

clone: url to: stringOrDirectory
    | dir ref fetchStats checkoutStats options |

    (url asString startsWith: 'file://') ifTrue:[
        "Arghhh...local transport not yet supported by libgit2, use command line..."
        GitCommand clone: url to: stringOrDirectory pathName.
        ^self open: stringOrDirectory pathName
    ].


    dir := stringOrDirectory asFilename.
    dir exists ifTrue:[
        GitError raiseErrorString:'Destination directory already exists'.
        ^self
    ].
    dir directory isDirectory ifFalse:[
        GitError raiseErrorString:'Parent directory for destination does not exists'.
        ^self
    ].

    ref := ByteArray new: ExternalBytes sizeofPointer.
    fetchStats := GitIndexerStatsStructure new.
    checkoutStats := GitIndexerStatsStructure new.
    options := GitCheckoutOptions new.
    options strategyCreateMissing.
    GitError raiseIfError: 
        (GitPrimitives prim_git_clone: ref origin_url: url asString workdir_path: dir pathName fetch_stats: fetchStats checkout_stats: checkoutStats checkout_opts: options).
    ^self new 
        setHandleFromRef:ref;
        setPath: dir pathName;
        yourself

    "Created: / 01-10-2012 / 00:09:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

discover: path
    "Find a git repository in given directory or super-directories.
     If not repository is found, return nil.

     Currently, it searches for presence of .git
     directory"

    | d |

    path isNil ifTrue:[ ^ nil ].
    d := path asFilename.
    [ d notNil ] whileTrue:[
        (d / '.git') exists ifTrue:[ ^ d ].
        d := d isRootDirectory 
            ifTrue:[nil]
            ifFalse:[d := d directory].
    ].
    ^nil

    "Created: / 06-10-2012 / 19:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

open: aStringOrFilename
    "Opens an existing git repository on given path"

    | ref |

    ref := ByteArray new: ExternalBytes sizeofPointer.
    GitError raiseIfError: (GitPrimitives prim_git_repository_open: ref path: aStringOrFilename asString).
    ^self new 
        setHandleFromRef:ref;
        setPath: aStringOrFilename;
        yourself

    "Created: / 07-09-2012 / 23:45:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository class methodsFor:'accessing'!

structSize
    "Returns size of undelaying structure in bytes"

    ^0
! !

!GitRepository methodsFor:'accessing'!

head
    | ref err |
    ref := ByteArray new: ExternalBytes sizeofPointer.
    err := GitPrimitives prim_git_repository_head: ref repo: handle.
    GitError raiseIfError: err.

    ^GitReference new setHandleFromRef: ref

    "Created: / 25-09-2012 / 10:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index
    "Return repository working index"

    index isNil ifTrue:[
        | ref err |

        ref := ByteArray new: ExternalBytes sizeofPointer.
        err := GitPrimitives prim_git_repository_index: ref repo: handle.
               GitError raiseIfError: err.
        index := GitIndex new
                setHandleFromRef: ref;
                setRepository: self;
                yourself
    ].
    ^index

    "Created: / 02-10-2012 / 15:33:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index: aGitIndex
    "Sets repository working index to given index"

    self assert: (aGitIndex isKindOf: GitIndex).
    index := nil.
    GitPrimitives prim_git_repository_set_index: handle index: aGitIndex getHandle.
    aGitIndex setRepository: self.
    index := aGitIndex

    "Created: / 02-10-2012 / 15:33:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path
    ^ path
!

remotes

    remotes isNil ifTrue:[
        | list  |

        list := GitStringArray new.
        GitError raiseIfError:(GitPrimitives prim_git_remote_list: list repo: handle).
        remotes := Dictionary new.
        list do:[:name|
            remotes at: name put: (self remoteNamed: name)
        ].
    ].
    ^remotes.

    "Created: / 30-09-2012 / 20:15:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy
    ^self workingCopyOn: self path

    "Created: / 19-09-2012 / 15:32:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'actions'!

commit: message tree: tree parents: parents update: refOrNil commiter: commiterOrNil author: authorOrNil
    | oid err committer author parentsA |

    committer := commiterOrNil notNil 
                    ifTrue:[committer copyNow]
                    ifFalse:[GitCommitterQuery query copyNow].
    author := commiterOrNil notNil
                    ifTrue:[author]
                    ifFalse:[committer copy].
    parentsA := ByteArray new: (ExternalBytes sizeofPointer * parents size).
    parents withIndexDo:[:each :idx|
        parentsA pointerAt: (1 + ((idx - 1) * ExternalBytes sizeofPointer)) put: each getHandle.
    ].
    oid := GitOid new.

    err := GitPrimitives prim_git_commit_create: oid 
                                           repo: handle 
                                     update_ref: (refOrNil notNil ifTrue:[refOrNil name] ifFalse:[nil]) 
                                         author: author getHandle
                                      committer: committer getHandle
                               message_encoding: 'utf-8'
                                        message: message utf8Encoded
                                           tree: tree getHandle
                                   parent_count: parents size
                                        parents: parentsA.
    GitError raiseIfError: err.

    ^self lookup: oid type: OBJ_COMMIT.

    "Created: / 25-09-2012 / 14:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

detach
    "Detach the HEAD.
     If the HEAD is already detached and points to a Commit, 0 is returned.

     If the HEAD is already detached and points to a Tag, the HEAD is
     updated into making it point to the peeled Commit, and 0 is returned.

     If the HEAD is already detached and points to a non commitish, the HEAD is 
     unaletered, and -1 is returned.

     Otherwise, the HEAD will be detached and point to the peeled Commit.
    "

    GitError raiseIfError: (GitPrimitives prim_git_repository_detach_head: handle).

    "Created: / 02-10-2012 / 17:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push: aGitRemote
    "pushes all changes to given remote repository"

    GitCommand push
        workingDirectory: self path;
        remote: aGitRemote name;
        execute

    "Created: / 30-09-2012 / 23:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'copying'!

cloneTo: aStringOrFilename"^<GitRepository>"

    "Clones the receiver to given directory. And equivalent to

        git clone <path> <clonePath>

    "

    ^GitRepository 
        clone: ('file://', self path ) 
           to: (aStringOrFilename)

    "Created: / 30-09-2012 / 19:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shallowCopy

    ^self class open: path pathName

    "Created: / 10-09-2012 / 19:04:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'initialization'!

setPath: aStringOrFilename
    path := aStringOrFilename asFilename

    "Created: / 10-09-2012 / 19:05:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        GitPrimitives prim_git_object_free: handle. 
        handle := nil.
    ].

    "Created: / 17-09-2012 / 21:16:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'lookup'!

lookup: oid
    "Lookup an object with given OID"
    ^self lookup: oid type: OBJ_ANY

    "Created: / 10-09-2012 / 10:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookup: oid type: typeId
    "Lookup an object with given OID"

    | ref err type obj |

    oid class == GitOid ifFalse:[
        self error: 'Passed oid is not a GitOid'.
        ^nil.
    ].
    ref := ByteArray new: ExternalBytes sizeofPointer.
    err := GitPrimitives prim_git_object_lookup: ref repo: handle id: oid type: typeId.
    GitError raiseIfError: err.

    typeId == OBJ_ANY ifTrue:[
        obj := ExternalAddress new setAddressFromBytes:ref.
        type := GitPrimitives prim_git_object_type: obj.
    ] ifFalse:[
        type := typeId.
    ].
    obj := GitObject newForType: type.
    ^obj
        setHandleFromRef: ref;
        setOid: oid;
        setRepository: self;
        yourself

    "Created: / 10-09-2012 / 11:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'private'!

checkout: object
    | err stats options |
    object isGitTreeish ifFalse:[
        GitError raiseErrorString:'Invalid argument: ', object printString.
        ^self.
    ].

    stats := GitIndexerStatsStructure new.
    options := GitCheckoutOptions new.
    options strategyCreateMissing.
    err := GitPrimitives prim_git_checkout_tree: handle treeish: object getHandle opts: options stats: stats. 
    GitError raiseIfError: err.

    "Created: / 19-09-2012 / 09:52:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'private-accessing'!

getHandleClass
    ^GitRepositoryHandle

    "Created: / 17-09-2012 / 21:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getIndex
    ^index

    "Created: / 02-10-2012 / 15:40:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remoteNamed: name
    | ref err |

    ref := ByteArray new: ExternalBytes sizeofPointer.
    err := GitPrimitives prim_git_remote_load: ref repo: handle  name: name.
    GitError raiseIfError: err.
    ^GitRemote new
        setHandleFromRef: ref;
        setRepository: self;
        setName: name

    "Created: / 30-09-2012 / 20:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statusOf: aFilename
    | ref err |

    (aFilename pathName startsWith: self workdir pathName ) ifFalse:[
        GitError raiseErrorString: 'Given path is within working copy'.
        ^0.
    ].

    ref := ByteArray new: ExternalBytes sizeofInt.
    err := GitPrimitives prim_git_status_file: ref repo: handle path: (aFilename pathName copyFrom: (workdir pathName size + 2)).
    GitError raiseIfError: err.

    ^ref longAt:1

    "Created: / 24-09-2012 / 22:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workdir
    "Get the path of the working directory for this repository or nil, if
     repository is bare"

    self isBare ifTrue: [ ^ nil ].
    workdir isNil ifTrue:[
        workdir := GitPrimitives prim_git_repository_workdir: handle.
        workdir := workdir asFilename.
    ].
    ^workdir

    "Created: / 10-09-2012 / 19:07:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workdir: aStringOrFilename update: aBoolean
    "Set the path of the working directory for this repository.
     If update is true, then create/update gitlink in workdir and set 
     config 'core.worktree' (if workdir is not the parent of the 
     .git directory)"

    GitError raiseIfError: 
        (GitPrimitives prim_git_repository_set_workdir: handle 
                                               workdir: aStringOrFilename asString
                                        update_gitlink: (aBoolean ifTrue:[1] ifFalse:[0])).
    workdir := aStringOrFilename asFilename.

    "Created: / 10-09-2012 / 19:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyOn: aStringOrFilename
    self isBare ifTrue:[
        GitError raiseErrorString: 'Bare repositories have no working copies'.
        ^nil.
    ].

    aStringOrFilename ~= path ifTrue:[
        GitError raiseErrorString: 'Off-repository working copies are not sypported (and likely never will be)'.
        ^nil
    ].

    ^GitWorkingCopy new setRepository: self

    "Created: / 19-09-2012 / 09:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'queries'!

hasOffRepoWorkdir
    ^self workdir ~= self path

    "Created: / 03-10-2012 / 16:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository methodsFor:'testing'!

headIsDetached
    ^(GitPrimitives prim_git_repository_head_detached: handle) == 1

    "Created: / 25-09-2012 / 11:06:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

headIsOrphan
    ^(GitPrimitives prim_git_repository_head_orphan: handle) == 1

    "Created: / 25-09-2012 / 11:06:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBare
    "Check if a repository is bare"

    ^(GitPrimitives prim_git_repository_is_bare: handle) == 1

    "Created: / 10-09-2012 / 19:11:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isEmpty
    "An empty repository has just been initialized and contains
     no commits."

    ^(GitPrimitives prim_git_repository_is_empty: self) == 1

    "Created: / 10-09-2012 / 19:12:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepository class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
