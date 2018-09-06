"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

FileoutLikeTask subclass:#CommitTask
	instanceVariableNames:'message paths'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!CommitTask class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!CommitTask class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CommitTask methodsFor:'accessing'!

message

    message ifNil:[
        message := String streamContents: [:s|
            | classes methods msg |    
            classes := self classesToFileOut.
            methods := self extensionMethodsToFileOut.
            classes do:[:cls|
                msg := SVNSourceCodeManager utilities goodInitialLogMessageForCheckinClassOfClass:cls.
                msg notEmptyOrNil ifTrue: [
                    s nextPutLine: ' - ', cls name.
                    msg asStringCollection do:[:line|
                        s nextPutAll:'    '; nextPutLine: line.
                    ]
                ].
            ].
            methods notEmptyOrNil ifTrue:[
                s nextPutLine: ' - extensions'.
                s nextPutLine: '    ...'.
            ].
        ]
    ].
    ^message.

    "Modified: / 03-04-2012 / 18:15:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

!CommitTask methodsFor:'executing'!

do
    self
        doPrepareWorkingCopy;
        doCommit

    "Created: / 23-03-2009 / 11:15:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-06-2009 / 10:16:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCommit
    |containers commitInfo commitLabel msg |

    msg := ((message ? '<no commit message>') asStringCollection
                reject: [:line|line size >= 2 and:[line first == $# and:[line second == $#]]])
                asString.

    self do:[                             
        self isPackageCommit ifFalse:[
            paths size > 2 ifTrue:[
                commitLabel := ((paths upTo: 2) asStringWith:', ') , (' and %1 others' bindWith: paths size - 3).
            ] ifFalse:[
                commitLabel := paths asStringWith:', '
            ].
            containers := paths
        ] ifTrue:[
            paths size > 2 ifTrue:[
                commitLabel := self package ? ''.
            ] ifFalse:[
                commitLabel := paths asStringWith:', '
            ].
            paths isEmptyOrNil ifTrue:[
                self isSelectiveFileoutTask ifTrue:[
                    containers := self containersToFileOut
                ] ifFalse:[ 
                    containers := #() 
                ]
            ] ifFalse:[
                containers := paths
            ]
        ].
        ActivityNotification notify:'Commiting ' , commitLabel.

        (paths notNil and:[paths isEmpty]) ifFalse:[
            self 
                synchronized:[
                    commitInfo := (CommitCommand new)
                                workingCopy:self workingCopy;
                                message: msg;
                                paths:containers;
                                execute.
                     "Update the working copy. We need svn info
                     to report commited revision"
                    (UpdateCommand new)
                        workingCopy:self workingCopy;
                        execute
                ].
            "Do this only iff this is a package commit"
            self isPackageCommit ifTrue:[
                self doCompileSvnRevisionNrMethod:true.
                self doCompileSvnRepositoryUrlStringMethod.        
                ActivityNotification notify:'Shrinking changes'.
                (ChangeSet current)
                    condenseChangesForPackage2:self package;
                    condenseChangesForExtensionsInPackage:self package;
                    flushChangedClassesCache;
                    yourself.
                ].
        ]
    ].
    self workingCopy commited.
    ^ commitInfo

    "Created: / 11-04-2008 / 09:20:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:27:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-03-2012 / 17:42:25 / jv"
    "Modified: / 04-04-2012 / 17:39:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareWorkingCopy

    self isPackageCommit ifTrue:[
        self do:[
            self workingCopy ensureIsValid.
            self doFileOutAll
        ]
    ].

    "Created: / 11-04-2008 / 09:19:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 18:28:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-02-2012 / 16:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
            self workingCopy ensureIsValid.
            self doFileOut
        ]
    ].

    "Created: / 10-05-2012 / 17:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSanityChecks
    "Perform some sanity checks on the package
     (or individual classes and/or methods). 
     Return a project checker. Use #problems to get the
     list of problems"

    self isPackageCommit ifFalse:[ ^ nil ].
    (ConfigurableFeatures includesFeature:#ProjectChecker) ifFalse:[ ^ nil ].

    ^ProjectChecker new 
        package: self package;
        classes: classes;
        methods: (extensionMethods = #() ifTrue:[nil] ifFalse:[extensionMethods]);
        check;
        yourself

    "Created: / 11-04-2008 / 09:19:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 18:28:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 13-02-2012 / 16:36:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitTask methodsFor:'testing'!

isPackageCommit
    "Returns true iff this task is for a package
     (or part of it). False if this is ad-hoc commit task -
    for example ad-hoc commit from a file browser"

    ^ self package notNil" and:[paths isEmptyOrNil]"

    "Modified: / 14-03-2012 / 17:27:17 / jv"
    "Modified: / 17-03-2012 / 19:49:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CommitTask.st 371 2011-09-28 18:47:07Z vranyj1 §'
! !
