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

"{ NameSpace: Smalltalk }"

SCMAbstractFileoutLikeTask subclass:#SCMAbstractCommitTask
	instanceVariableNames:'message paths'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX-Tasks'
!

!SCMAbstractCommitTask class methodsFor:'documentation'!

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

!SCMAbstractCommitTask methodsFor:'accessing'!

message
    "Returns initial commit message"

"/  NO, do not generate commit message based on changes in code.
"/  Such commit message is completely useless!!
    ^ ''

"/    message isNil ifTrue:[
"/        self isPackageCommit ifTrue:[
"/            message := String streamContents: [:s|
"/                | klasses methods msg |    
"/                klasses := OrderedCollection streamContents:[:s|packages do:[:each | s nextPutAll: (self classesToFileOutFor: each) ]].
"/                methods := OrderedCollection streamContents:[:s|packages do:[:each | s nextPutAll: (self extensionMethodsToFileOutFor: each) ]].     .
"/                klasses do:[:cls|
"/                    msg := SCMAbstractSourceCodeManager utilities goodInitialLogMessageForCheckinClassOfClass:cls.
"/                    msg notEmptyOrNil ifTrue: [
"/                        s nextPutAll: ' - '; nextPutLine: cls name.
"/                        msg asStringCollection do:[:line|
"/                            s nextPutAll:'    '; nextPutLine: line.
"/                        ]
"/                    ].
"/                ].
"/                methods notEmptyOrNil ifTrue:[
"/                    s nextPutLine: ' - extensions'.
"/                    s nextPutLine: '    ...'.
"/                ].
"/            ]
"/        ].
"/    ].
"/    ^message.

    "Modified: / 26-03-2014 / 15:01:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message:aString
    message := aString.
!

paths
    ^ paths
!

paths:aCollection
    paths := aCollection.
! !

!SCMAbstractCommitTask methodsFor:'executing'!

do
    self
        doPrepareWorkingCopy;
        doCommit

    "Created: / 23-03-2009 / 11:15:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-06-2009 / 10:16:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCommit
    |containers commitLabel msg |

    msg := ((message ? '<no commit message>') asStringCollection
                reject: [:line|line size >= 2 and:[line first == $# and:[line second == $#]]])
                asString.

    self do:[                             
        self isPackageCommit ifFalse:[
            paths notEmptyOrNil ifTrue:[
                commitLabel := paths size > 2
                    ifTrue:[((paths upTo: 2) asStringWith:', ') , (' and %1 others' bindWith: paths size - 3)]
                    ifFalse:[paths asStringWith:', '].
            ] ifFalse:[
                commitLabel := temporaryWorkingCopy pathName.
            ].
            containers := paths
        ] ifTrue:[
            commitLabel := (paths isEmptyOrNil or:[paths size > 2]) 
                            ifTrue:[packages size == 1 ifTrue:[ packages anElement name ] ifFalse:[ packages first name , ', ...' ]]
                            ifFalse:[paths asStringWith:', '].
            containers := self containersToCommit.
        ].
        (containers isNil or:[containers notEmpty]) ifTrue: [ 
            ActivityNotification notify:'Commiting ' , commitLabel.
            self doCommit: msg files: containers.
        ].
        ActivityNotification notify:'Shrinking changes'.
        self isPackageCommit ifTrue:[
            self doShrinkChanges.
        ].
    ].
    self isPackageCommit ifTrue:[
        packages do:[:each | each isVirtual ifFalse: [ each commited ] ]
    ].

    "Created: / 11-04-2008 / 09:20:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:27:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-03-2012 / 17:42:25 / jv"
    "Modified: / 11-06-2015 / 07:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareWorkingCopy

    self doPrepareWorkingCopy1.
    self doPrepareWorkingCopy2.

    "Created: / 11-04-2008 / 09:19:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 18:28:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2012 / 09:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareWorkingCopy1

    self isPackageCommit ifTrue:[
        self do:[
            self doUpdateCode.
        ]
    ].

    "Created: / 10-05-2012 / 17:08:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareWorkingCopy2

    self isPackageCommit ifTrue:[
        self do:[
            | p |

            p := packages anElement.
            p ensureTemporaryWorkingCopy.
            self doFileOut
        ]
    ].

    "Created: / 10-05-2012 / 17:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 23:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitTask methodsFor:'executing-private'!

doCommit: msg files: containers
    "Actually commit the changes, To be overridden by subclasses"

    self synchronized:[
        self halt: 'Have to be smart here!!!!!!'.
        self package workingCopy commit: msg files: containers.

"/      "Update the working copy. We need svn info
"/       to report commited revision"
"/      (UpdateCommand new)
"/          workingCopy:self workingCopy;
"/          execute
    ].

    "Created: / 15-11-2012 / 09:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 23:27:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSanityChecks
    "Perform some sanity checks on the package
     (or individual classes and/or methods). 
     Return a project checker. Use #problems to get the
     list of problems"

    | checker |

    self isPackageCommit ifFalse:[ ^ nil ].
    (ConfigurableFeatures includesFeature:#ProjectChecker) ifFalse:[ ^ nil ].

    checker := ProjectChecker new.
    packages do:[:each | each isVirtual ifFalse: [ checker package: each name ] ].

    checker
        classes: classes;
        methods: (extensionMethods = #() ifTrue:[nil] ifFalse:[extensionMethods]);
        check.
    ^ checker

    "Created: / 11-04-2008 / 09:19:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 18:28:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 13-02-2012 / 16:36:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2014 / 22:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShrinkChanges

    "Do this only iff this is a package commit"
    self isPackageCommit ifTrue:[
        packages do:[:each |
            each isVirtual ifFalse: [ 
               self doShrinkChangesFor: each.
            ]
        ]
    ].

    "Created: / 15-11-2012 / 09:41:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 00:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShrinkChangesFor: package
    paths isNil ifTrue:[ 
        (ChangeSet current)
           condenseChangesForPackageAfterCommit:package name;
           condenseChangesForExtensionsInPackage:package name;
           flushChangedClassesCache;
            yourself.
    ] ifFalse:[            
        | root commitedClasses commitedExtensions |

        "/ paths is list of !!!!!!absolute filenames!!!!!!, so we have to construct full name
        "/ furtunately, that's easy...
        root := package temporaryWorkingCopyRoot asFilename.

        commitedClasses := Set new.
        package classes do:[:class | 
            | container |

            container := (root / (package containerNameForClass: class)) pathName.
            (paths includes: container) ifTrue:[ 
                commitedClasses add: class.
            ].
        ].

        commitedExtensions := #().
        (paths includes: ((root / package containerNameForExtensions) pathName)) ifTrue:[ 
            commitedExtensions := package extensions.
        ].

        commitedClasses do:[:each |  
            ChangeSet current condenseChangesForClass: each.    
        ].
        commitedExtensions do:[:each |
            ChangeSet current condenseChangesForClass: each mclass selector: each selector.    
        ]



    ].

    "Created: / 15-11-2014 / 00:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 08:47:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitTask methodsFor:'private'!

containersToCommit
    "Return a list of containers (paths) that should be commited. 
     nil return value means 'all modified files'      "

    | containers |

    paths notEmptyOrNil ifTrue:[ ^ paths ].
    self isSelectiveFileoutTask ifFalse: [ ^ nil ].

    containers := OrderedCollection withAll: self containersToFileOut.
    packages do:[:package | 
        (classes includes: package definition) ifTrue:[ 
            (self filesToGenerateFor: package skipNotOverwritable: false) do:[:each | 
                | container |

                container := package containerFor: each.
                (container exists and:[container isModified or:[ container isAdded ]]) ifTrue:[
                    containers add: container pathNameRelative
                ].
            ].
        ].
    ].
    ^ containers

    "Created: / 11-06-2015 / 07:14:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2015 / 08:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitTask methodsFor:'queries'!

isCommitingAllChangedPackages
    "Return true, if package group contain all changed packages
     of given repository, false otherwise."

    ^ packages containsAllChangedPackages

    "Created: / 03-03-2014 / 00:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitTask methodsFor:'testing'!

isPackageCommit
    "Returns true iff this task is for a package
     (or part of it). False if this is ad-hoc commit task -
    for example ad-hoc commit from a file browser"

    ^ packages notEmpty" and:[paths isEmptyOrNil]"

    "Modified: / 14-03-2012 / 17:27:17 / jv"
    "Modified: / 21-02-2014 / 22:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitTask class methodsFor:'documentation'!

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

