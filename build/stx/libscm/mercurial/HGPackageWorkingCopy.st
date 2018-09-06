"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

SCMAbstractPackageWorkingCopy subclass:#HGPackageWorkingCopy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGPackageWorkingCopy class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGPackageWorkingCopy class methodsFor:'instance creation'!

named:pkg
    ^HGPackageWorkingCopyRegistry packageNamed: pkg

    "Modified: / 05-03-2014 / 21:50:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'accessing'!

manager
    ^ HGSourceCodeManager

    "Created: / 14-11-2012 / 01:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    "Returns original package repository (not the temporary repository)"

    ^repository

    "Created: / 15-11-2012 / 09:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 00:33:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryRepository
    self ensureTemporaryWorkingCopy.
    ^wc repository

    "Created: / 01-12-2012 / 00:31:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'accessing-classes'!

commitDialogClass
    "raise an error: must be redefined in concrete subclass(es)"

    ^ HGCommitDialog

    "Created: / 14-11-2012 / 22:30:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitTaskClass
    ^ HGCommitTask

    "Created: / 14-11-2012 / 00:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'accessing-private'!

getRevision
    "Return a logical revision of the package, i.e., a revision
     on which the next commit will be based on"

    | model |

    model := self.
    [ model notNil ] whileTrue:[
        | rev |

        rev := model definition hgLogicalRevision.
        rev notNil ifTrue:[ ^rev ].
        model := model parent.
    ].

    ^repository workingCopy changesetId

    "Created: / 28-02-2014 / 09:34:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'initialization'!

setName:aSymbolOrPackageId repository:aRepository 
    | wcopy  wcopyroot  components |

    name := aSymbolOrPackageId asSymbol.
    repository := aRepository.
    wcopy := repository workingCopy.
    components := (name copyReplaceAll:$: with:$/) tokensBasedOn:$/.
    wcopyroot := wcopy root.
     "This is rubbish but I have to move on..."
    1 to:components size do:[:i | 
        | f |

        f := wcopy root asFilename.
        i to:components size do:[:j | 
            f := f / (components at:j).
            (f exists and:[f isDirectory]) ifTrue:[
                wcopyroot := wcopy root.
                i to:components size do:[:j | 
                    wcopyroot := wcopyroot / (components at:j).
                ].
                repositoryRoot := wcopyroot pathNameRelative.
                ^ self.
            ]
        ]
    ].
    repositoryRoot := '.'.

    "Created: / 01-12-2012 / 17:52:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-03-2015 / 03:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'inspecting'!

inspector2TabContentsView
    <inspector2Tab>

    ^ wcroot inspector2TabContentsView

    "Created: / 12-06-2015 / 10:35:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'private'!

commited
    "Sent by commit task once commited"

    | def oldRev newRev |

    super commited.

    def := self definition.
    oldRev := def hgLogicalRevision.
    newRev := wc changeset id.

    self root yourselfAndAllChildrenDo:[:each|
        each isVirtual ifFalse:[
            each updateLogicalRevisionFrom: oldRev to: newRev 
        ].
    ].

    self assert: (def hgLogicalRevision = newRev).

    "Created: / 23-11-2012 / 22:52:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2014 / 23:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateLogicalRevisionFrom: oldRev to: newRev
    "Updates package logical revision to `newRev` but
     only if it's current logical revision is `oldRev`"

    | def |

    def := self definition.
    def hgLogicalRevision = oldRev ifTrue:[ 
        def hgLogicalRevision: newRev
    ].

    "Created: / 20-02-2014 / 00:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy methodsFor:'utils'!

ensureTemporaryWorkingCopy
    | rev  tmpPath  tmpRepo  tmpWc |

    rev := self revision.
    (wc notNil and:[ wc path exists ]) ifTrue:[
        ^ self
    ].
    tmpPath := self temporaryWorkingCopyPath.
    tmpPath exists ifTrue:[
        tmpRepo := HGRepository on:tmpPath.
	tmpRepo isShared ifFalse:[
            tmpRepo pull.
        ]
    ] ifFalse:[
        UserPreferences current hgUseSharedRepositories ifTrue:[ 
            tmpRepo := repository shareTo:tmpPath update:false.            
        ] ifFalse:[ 
            tmpRepo := repository cloneTo:tmpPath update:false.
        ].
    ].
    tmpWc := tmpRepo workingCopy.

    "If it is fresh repository, it has no changeset yet..."
    (rev ~~ HGChangesetId null) ifTrue:[
        tmpWc update:rev.
    ].

    "Update branch to match branch of master working copy"
    tmpWc branch: repository workingCopy branch name.
    self setWorkingCopy:tmpWc.
    wcroot exists ifFalse:[
        wcroot recursiveMakeDirectory.
    ].

    "Created: / 14-11-2012 / 00:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 02:00:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureTemporaryWorkingCopyAtRevision:rev 
    "Make sure temporary working exists and is at
     given revision"

    | cs r |

    cs := self repository changesetWithId: rev.
    r := cs id.


    self ensureTemporaryWorkingCopy.
    (r revno ~~ -1) ifTrue:[
        wc update:r hexPrintString.
        "Update branch to match branch of master working copy"
        wc branch: repository workingCopy branch name.

    ].

    "Created: / 28-11-2012 / 09:38:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-07-2014 / 09:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopy class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

