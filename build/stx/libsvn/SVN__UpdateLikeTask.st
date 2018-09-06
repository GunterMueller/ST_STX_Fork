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

FileoutLikeTask subclass:#UpdateLikeTask
	instanceVariableNames:'notifications updates conflicts resolution'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!UpdateLikeTask class methodsFor:'documentation'!

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

!UpdateLikeTask class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!UpdateLikeTask methodsFor:'accessing'!

conflicts
    ^ conflicts
!

conflicts:something
    "set the value of the instance variable 'conflicts' and send a change notification (automatically generated)"

    (conflicts ~~ something) ifTrue:[
        conflicts := something.
        self changed:#conflicts with: something
     ].

    "Modified: / 25-11-2009 / 20:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notifications
    ^ notifications
!

resolution

    "
        Tools::ChangeSetBrowser new 
            changeset: updates;
            open

        Tools::ChangeSetBrowser new 
            changeset: conflicts resolution;
            open

    "
    

    ^resolution
        ifNotNil:[resolution]
        ifNil:[updates , conflicts resolution]

    "Created: / 26-11-2009 / 08:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolution: aChangeSet

    resolution := aChangeSet.
    self changed: #resolution with: aChangeSet

    "Created: / 26-11-2009 / 08:46:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updates
    ^ updates
!

updates:something
    "set the value of the instance variable 'updates' and send a change notification (automatically generated)"

    (updates ~~ something) ifTrue:[
        updates := something.
        self changed:#updates with: something
     ].

    "Modified: / 25-11-2009 / 20:40:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeTask methodsFor:'executing'!

do
    "
     Perform whole task"
    
    self
        doComputeUpdates;
        doApplyUpdates.

    "Modified: / 23-11-2009 / 15:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doApplyUpdates
    |resolutionToApply|

    resolutionToApply := self resolution select:[:chg | chg removed not ].
     "
     Tools::ChangeSetBrowser new
     changeset:resolutionToApply;
     open.
    "
    self do:[
        resolutionToApply isNilOrEmptyCollection ifFalse:[
            (Class updateChangeFileQuerySignal , Class updateChangeListQuerySignal) 
                answer:false
                do:[
                    resolutionToApply 
                        withIndexDo:[:change :index | 
                            change apply.
                            ProgressNotification notify:'Applying changes'
                                progress:(100 / resolutionToApply size) * index
                        ]
                ]
        ].
    ]

    "Created: / 23-03-2009 / 18:36:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 19:39:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2009 / 14:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doComputeUpdates
    self workingCopy ensureIsValid.
    self 
        doRevert;
        doFileOutAll;
        doUpdate;
        doProcessNotifications

    "Created: / 22-11-2009 / 07:29:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 14:54:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeTask methodsFor:'executing - private'!

doProcessNotifications
    updates := ChangeSet new.
    conflicts := DiffSet new.
    resolution := nil.
    notifications 
        withIndexDo:[:each :index | 
            ProgressNotification notify:('Processing ' , each entry path)
                progress:(100 / notifications size) * index.
            (each action isConflict or:[ each entry isSourceEntry ]) ifTrue:[
                each processUsing:self
            ]
        ].
    self changed:#updates with:updates.
    self changed:#conflicts with:conflicts.

    "
     SVN::MergeBrowser new
     diffset: conflicts;
     open"
    "Modified: / 18-08-2009 / 08:59:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2009 / 14:53:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRevert
    ActivityNotification notify:'Reverting local changes'.
    (RevertCommand new)
        workingCopy:self workingCopy;
        paths:(ProgrammingLanguage all 
                    collect:[:lang | '*.' , lang sourceFileSuffix ]);
        execute.

    "Modified: / 26-11-2009 / 15:13:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdate

    ^self subclassResponsibility

    "Created: / 26-11-2009 / 14:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeTask methodsFor:'processing - private'!

processAddedEntry:entry 
    entry programmingLanguage isSmalltalk ifTrue:[
        updates addAll:(ChangeSet fromStream:entry readStream)
    ] ifFalse:[
        "/self error:'Non smalltalk source not yet supported'
        self breakPoint: #jv
    ]

    "Created: / 27-08-2009 / 08:54:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-02-2010 / 13:52:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processConflictEntry: entry

    | working merge base |

    "Ignore generated files, they will be regenerated..."
    (self filesToGenerate includes: entry path) ifTrue:
        [^self].
    entry programmingLanguage isSmalltalk ifFalse:
        [^self error:'Only Smalltalk source file merging is supported right now, sorry.'].

    working := entry fileMergeWorking.    
    merge := entry fileMergeRight.
    base := entry fileMergeLeft.

    conflicts add:
        ((ChangeSetDiff 
            versionA: (ChangeSet fromFile: working) 
            versionB:  (ChangeSet fromFile: merge) 
            versionBase: (ChangeSet fromFile: base))
            name: entry className;
            versionALabel: 'Current (in image)';
            versionBLabel: merge suffix , ' (to be merged in)');
            versionBaseLabel: base suffix , ' (base)'.

    "Created: / 23-11-2009 / 17:40:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2009 / 11:34:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 20:02:50 / jv"
!

processDeletedEntry:entry 
    entry programmingLanguage isSmalltalk ifTrue:[
        entry path = 'extensions.st' ifTrue:[
            self halt "not yet finished"
        ].
        self halt.
    ]

    "Created: / 27-08-2009 / 09:56:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processMergedEntry: aWCNotification

    ^ self processUpdatedEntry: aWCNotification

    "Created: / 26-11-2009 / 15:36:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2009 / 11:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processNoneEntry:entry 

    "Nothing to do"

    "Created: / 07-04-2010 / 00:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processUpdatedEntry:entry 

    | class wcChangeset imageChangeset diffset |
    "We don't care about non source code files..."
    entry isSourceEntry ifFalse:
        [^self].
    wcChangeset := entry asChangeSet.
    (wcChangeset first isClassDefinitionChange) 
        ifTrue:[class := wcChangeset first changeClass].
    (class isNil or:[class isLoaded not]) ifTrue:[^self].
    imageChangeset := ChangeSet forExistingClass: class.

    diffset := imageChangeset diffSetsAgainst: wcChangeset.

    diffset onlyInReceiver do:
        [:chg|updates add:chg asAntiChange].
    diffset changed do:
        [:chgPair|updates add:chgPair second].
    diffset onlyInArg do:
        [:chg|updates add:chg].

    "Created: / 26-11-2009 / 19:01:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2009 / 11:35:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeTask methodsFor:'queries'!

hasChanges

    (updates isNil or:[conflicts isNil])
        ifTrue:[self error:'#doComputeChanges should be invoked before asking for changes'].

    ^updates isEmpty not or:[conflicts isEmpty not]

    "Created: / 09-12-2009 / 17:39:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeTask methodsFor:'testing'!

isMergeTask
    ^ false
!

isUpdateTask
    ^ false
! !

!UpdateLikeTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__UpdateLikeTask.st 371 2011-09-28 18:47:07Z vranyj1 §'
! !
