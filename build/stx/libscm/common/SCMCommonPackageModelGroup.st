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
"{ Package: 'stx:libscm/common' }"

Collection subclass:#SCMCommonPackageModelGroup
	instanceVariableNames:'roots'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMCommonPackageModelGroup class methodsFor:'documentation'!

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
!

documentation
"
    Package model group represents a group of packages that are related
    and should be manipulated at once by 'tasks'. Use #do: to iterate over
    individual packages.

    All packages in package group are guaranteed to be of same logical
    revision (see SCMAbstractPackageModel>>revision)

    NOTE: If package model A is part of the package group, all its children
    are **automatically** part of of the group (but only if it has the same revision
    as it's parent). Therefore you only need to add roots - in most case there's 
    only one root (the top-most package in the repository).
    It is illegal to add two roots with different revisions, in that case,
    and error is thrown.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SCMAbstractPackageModel
        SCMAbstractTask
        SCMCommitTask

        HGCommitTask
        HGPackageModel


"
! !

!SCMCommonPackageModelGroup class methodsFor:'instance creation'!

with: packageModel
    ^ self new 
        add: packageModel;
        yourself

    "Created: / 25-02-2014 / 22:57:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

with: packageModel1 with: packageModel2
    ^ self new 
        add: packageModel1;
        add: packageModel2;
        yourself

    "Created: / 25-02-2014 / 22:57:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

with: packageModel1 with: packageModel2 with: packageModel3
    ^ self new 
        add: packageModel1;
        add: packageModel2;
        add: packageModel3; 
        yourself

    "Created: / 25-02-2014 / 22:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'accessing'!

commitTask
    self isEmpty ifTrue:[ 
        self error: 'Package group is empty'.
    ].
    ^ roots anElement commitTaskClass new
        packages: self;
        yourself

    "Created: / 26-02-2014 / 22:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    "Return the repository for packages in this group"

    self do:[:each | ^ each repository ].
    ^ self emptyCollectionError

    "Created: / 03-03-2014 / 00:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    "Return the logical revision of packages is this group"

    self do:[:each | ^ each revision ].
    ^ self emptyCollectionError

    "Created: / 03-03-2014 / 00:21:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopy
    self isEmpty ifTrue:[ 
        self error:'Package group is empty'.
    ].
    self activityNotification:'Generating a temporary working copy (hg clone)...'.
    ^ roots anElement temporaryWorkingCopy.

    "Modified: / 26-02-2014 / 23:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopyRoot
    self isEmpty ifTrue:[ 
        self error:'Package group is empty'.
    ].
    self activityNotification:'Generating a temporary working copy (hg clone)...'.
    roots anElement ensureTemporaryWorkingCopy.
    ^ roots size == 1 ifTrue:[ 
        roots anElement temporaryWorkingCopyRoot 
    ] ifFalse:[ 
        roots anElement temporaryWorkingCopy root 
    ].

    "Created: / 14-11-2012 / 23:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-02-2014 / 22:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'adding & removing'!

add: packageModel
    roots isNil ifTrue:[ 
        roots := Array with: packageModel. 
    ] ifFalse:[
        (packageModel isKindOf: roots anElement class) ifFalse:[ 
            self error: 'Package model is for different SCM'.
            ^ self.
        ].
        roots do:[:root | 
            (root isParentOf: packageModel) ifTrue:[ ^ self ] 
        ].
        roots withIndexDo:[:root :i|
            (root isChildOf: packageModel) ifTrue:[ 
                roots at: i put: packageModel.
                ^ self.
            ].
        ].
        (packageModel revision = roots first revision) ifFalse:[ 
            self error: 'Package model has different revision than models already in group!!'.
            ^ self.
        ].
        roots := roots copyWith: packageModel. 
    ].

    "Created: / 25-02-2014 / 22:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2014 / 09:05:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: element ifAbsent: block
    ^ self shouldImplement

    "Created: / 25-02-2014 / 23:12:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'enumerating'!

do: block
    "Evaluate `block` with each package model is a group"

    roots notNil ifTrue:[ 
        | rev |

        rev := roots anElement revision.
        roots do:[:root | root yourselfAndAllChildrenDo: [:p | p revision = rev ifTrue:[ block value: p ] ] ]
    ].

    "Created: / 25-02-2014 / 22:55:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reverseDo: block
    self do: block

    "Created: / 25-02-2014 / 23:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'enumerating-tests'!

containsAllChangedPackages
    "Returns true, if receiver contains all changed packages in a repository"

    | revision changed |

    self isEmpty ifTrue:[ 
        self emptyCollectionError.
        ^ false.
    ].

    "/ Collect all changed packages at given revision...    
    revision := self revision.
    changed := Set new.
    roots anElement root yourselfAndAllChildrenDo:[:each|
        (each isVirtual not and:[each revision = revision and:[ each hasChanges ]]) ifTrue:[ 
            changed add: each.
        ].
    ].

    "/ Remove each package in receiver. If then 
    "/ `changed` collection is empty, all
    self do:[:each | 
        changed remove: each ifAbsent:[ ].
    ].
    ^ changed isEmpty

    "Created: / 03-03-2014 / 00:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'queries'!

species
    "Return the type of collection for select: / collect: / reject: kind
     of methods"
    ^ OrderedCollection

    "Created: / 27-02-2014 / 17:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup methodsFor:'utilities'!

, anotherPackageModel
    ^ self
        add: anotherPackageModel;
        yourself.

    "Created: / 26-02-2014 / 22:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonPackageModelGroup class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

