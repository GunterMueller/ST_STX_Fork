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

Object subclass:#Branch
	instanceVariableNames:'repository path url'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!Branch class methodsFor:'documentation'!

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

!Branch class methodsFor:'instance creation'!

repository: aRepository path: aString

    ^self new
        repository: aRepository;
        path: aString;
        yourself

    "Created: / 19-08-2009 / 11:19:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Branch class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Branch methodsFor:'accessing'!

icon


    self isBranch ifTrue:[^IconLibrary branch].
    self isTag ifTrue:[^IconLibrary tag].
    ^IconLibrary empty

    "Created: / 11-04-2008 / 13:45:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2008 / 11:15:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

name

    ^self isTrunk 
        ifTrue:[(path ? 'trunk/') allButLast asText allBold]
        ifFalse:[path allButLast]

    "Created: / 19-03-2008 / 08:27:54 / janfrog"
    "Modified: / 31-03-2008 / 15:20:04 / janfrog"
!

package

    ^repository package

    "Created: / 20-05-2008 / 17:56:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path
    ^ path

    "Created: / 19-03-2008 / 08:27:47 / janfrog"
!

path:aString
    path := aString.
    (path endsWith: $/) ifFalse:
        [path := path , $/]

    "Created: / 19-03-2008 / 08:27:47 / janfrog"
    "Modified: / 22-10-2008 / 13:18:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repository
    ^ repository

    "Created: / 19-03-2008 / 08:28:39 / janfrog"
!

repository:something
    repository := something.

    "Created: / 19-03-2008 / 08:28:39 / janfrog"
!

url

    url ifNil:[url := repository urlForBranch: path].
    ^url

    "Created: / 19-03-2008 / 09:40:41 / janfrog"
    "Modified: / 14-03-2011 / 09:58:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Branch methodsFor:'accessing - change sets'!

changeSet

    ^self changeSet: SVN::Revision head

    "Created: / 19-04-2008 / 14:09:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSet:revision 

    ^self changeSet:revision ignoreAutoloaded: false
!

changeSet:revision ignoreAutoloaded:ignoreAutoloaded 
    |entries changeSet|

    ActivityNotification notify:'Listing repository'.
    entries := (self list:revision) select:[:entry | entry isSourceEntry ].
    changeSet := ChangeSet new.
    ActivityNotification notify:'Reading rev. ' , revision printString.
    entries 
        withIndexDo:[:entry :index | 
            ProgressNotification 
                notify:'Reading ' , entry path , ' rev. ' , revision printString
                progress:((100 / entries size) * index) rounded.
            changeSet addAll:(self 
                        changeSetForContainer:entry path
                        revision:revision
                        ignoreAutoloaded:ignoreAutoloaded).
        ].
    ^ changeSet

    "Created: / 19-04-2008 / 14:09:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-10-2008 / 13:00:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 15:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForClass: cls

    ^self changeSetForClass: cls revision: SVN::Revision head

    "Created: / 19-04-2008 / 17:24:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetForClass: cls revision: revision

    ^self changeSetForClass: cls revision: revision ignoreAutoloaded: false



    "Created: / 19-04-2008 / 17:23:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 20:20:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetForClass: cls revision: revision ignoreAutoloaded: ignoreAutoloaded


    ^(ignoreAutoloaded or:[cls isLoaded])
        ifTrue:
            [self 
                changeSetForContainer:(repository containerNameForClass: cls)
                revision: revision]
        ifFalse:
            [ChangeSet new].

    "Created: / 19-04-2008 / 17:23:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 20:20:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 15:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForContainer: container revision: revision

    ^self changeSetForContainer: container revision: revision ignoreAutoloaded: false

    "Created: / 19-04-2008 / 20:18:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 15:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForContainer: container revision: revision ignoreAutoloaded: ignoreAutoloaded

    | containerStream |
    ignoreAutoloaded ifTrue:
        [|cls|
        cls := SVN::Repository classFromContainerName: container.
        (cls isNil or: [cls isLoaded not]) ifTrue:[^ChangeSet new]].

    containerStream := (self 
                            cat:container
                            revision: revision) readStream.
    ^(ChangeSet fromStream: containerStream)
        name: container , ' r' , revision printString

    "Created: / 19-11-2009 / 15:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForExtensions

    ^self changeSetForExtensionsRevision: SVN::Revision head

    "Created: / 19-04-2008 / 20:21:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetForExtensionsRevision: revision

    ^self 
        changeSetForContainer:(repository containerNameForExtensions)
        revision: revision.

    "Created: / 19-04-2008 / 19:08:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 20:20:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetForLoad:revision 
    |diffSet classesToRemove|

    diffSet := self diffSetBetweenImageAndRevision:revision.
    classesToRemove := Set new.
    ActivityNotification notify:'Computing load set'.
     "self = image, arg = revision"
    ^ (diffSet onlyInArg) 
        , (diffSet changed collect:[:changePair | changePair second ]) 
            , (diffSet onlyInReceiver 
                    select:[:change | change isClassDefinitionChange ]
                    thenCollect:[:change | 
                        classesToRemove add:change className.
                        ClassRemoveChange className:change className
                    ]) 
            , (diffSet onlyInReceiver 
                    select:[:change | 
                        change isMethodDefinitionChange 
                            and:[ (classesToRemove includes:change className) not ]
                    ]
                    thenCollect:[:change | 
                        MethodRemoveChange className:change className selector:change selector
                    ])
                 "Created: / 22-10-2008 / 11:08:06 / Jan Vrany <vranyj1@fel.cvut.cz>" "Modified: / 07-11-2008 / 08:09:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Branch methodsFor:'accessing - diff sets'!

diffSetBetweenImageAndRevision: revision

    | imageChangeSet revisionChangeSet |
    imageChangeSet := ChangeSet forPackage: self package ignoreAutoloaded: true.
    revisionChangeSet := self changeSet: revision ignoreAutoloaded: true.
    ^(ChangeSetDiff versionA: imageChangeSet versionB: revisionChangeSet)
        versionALabel: 'Current (in image)';
        versionBLabel: revision printString

    "Created: / 20-05-2008 / 17:56:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-03-2010 / 16:33:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 20:02:19 / jv"
!

diffSetBetweenRevision: revisionA andRevision: revisionB

    | revisionAChangeSet revisionBChangeSet |
    revisionAChangeSet := self changeSet: revisionA.
    revisionBChangeSet := self changeSet: revisionB.
    ^(ChangeSetDiff versionA: revisionAChangeSet versionB: revisionBChangeSet)
        versionALabel: revisionA printString;
        versionBLabel: revisionB printString

    "Created: / 20-05-2008 / 17:58:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2009 / 11:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 20:02:27 / jv"
!

diffSetForClass: cls betweenImageAndRevision: revision

    | imageChangeSet revisionChangeSet |

    ActivityNotification notify: 'Reading class ',cls fullName asText allBold.
    imageChangeSet := ChangeSet forExistingClass:cls withExtensions: false extensionsOnly:false.
    ActivityNotification notify: 'Reading class ',cls fullName asText allBold, ' (rev. ', revision printString,')'.
    revisionChangeSet := self changeSetForClass: cls revision: revision.
    ActivityNotification notify: 'Computing differences for ',cls fullName asText allBold.
    ^(ChangeSetDiff versionA: imageChangeSet versionB: revisionChangeSet)
        name: cls fullName;
        versionALabel: 'Current (in image)';
        versionBLabel: revision printString

    "Created: / 19-04-2008 / 18:34:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-03-2010 / 16:33:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 20:02:30 / jv"
!

diffSetForExtensionsBetweenImageAndRevision: revision

    | imageChangeSet revisionChangeSet |
    ActivityNotification notify: 'Reading extensions for ',self package asText allItalic.
    imageChangeSet := ChangeSet forExistingMethods: repository packageExtensions.
    ActivityNotification notify: 'Reading extensions for ',self package asText allItalic, ' (rev. ', revision printString,')'.
    revisionChangeSet := self changeSetForExtensionsRevision: revision.
    ActivityNotification notify: 'Computing differences'.
    ^(ChangeSetDiff versionA: imageChangeSet versionB: revisionChangeSet)
        name: 'package extensions';
        versionALabel: 'Current (in image)';
        versionBLabel: revision printString

    "Created: / 19-04-2008 / 19:08:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-03-2010 / 16:33:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 20:02:34 / jv"
! !

!Branch methodsFor:'commands'!

cat: file

    ^self cat: file revision: SVN::Revision head

    "Created: / 19-04-2008 / 10:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cat: file revision: revision

    ^CatCommand new
        branch: self;
        path: file;
        revision: revision;
        execute.

    "Created: / 19-04-2008 / 10:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

exists:file 

    ^self exists: file revision: SVN::Revision head.

    "Created: / 19-04-2008 / 13:42:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:01:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-10-2011 / 11:14:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exists:file revision:revision 

    ^[
        ListCommand new
            branch: self;
            recursive: true;
            revision: revision;
            execute.
        true.
    ] on: SVNError do:[
        false.
    ]

    "Created: / 19-04-2008 / 13:42:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:01:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 10-10-2011 / 14:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

list


    ^self list: SVN::Revision head.

    "Created: / 19-04-2008 / 13:42:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

list: revision

    ^ListCommand new
        branch: self;
        recursive: true;
        revision: revision;
        execute

    "Created: / 19-04-2008 / 13:42:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:01:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

log

    ^self log: nil

    "Created: / 19-04-2008 / 10:52:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 12:16:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2011 / 16:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: stringOrClass

    ^self log: stringOrClass limit: nil

    "Created: / 19-04-2008 / 10:52:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:03:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2011 / 16:30:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: stringOrClass limit: limit

    ^self log: stringOrClass limit: limit revisions: nil

    "Created: / 19-04-2008 / 10:52:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:03:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 15-10-2011 / 16:29:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: stringOrClass limit: limit revisions: revisionRangeOrNil

    | container |
    container := stringOrClass isBehavior 
                    ifFalse:[stringOrClass]
                    ifTrue:[repository containerNameForClass: stringOrClass].

    ^LogCommand new
        branch: self;
        path: container ? '';
        revision: revisionRangeOrNil;
        limit: limit;
        execute

    "Created: / 19-04-2008 / 10:52:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:03:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 15-10-2011 / 17:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revert

    self repository workingCopy revert

    "Created: / 22-10-2008 / 16:46:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revert: paths

    self repository workingCopy revert: paths

    "Created: / 03-11-2008 / 21:21:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

update

    self repository workingCopy update

    "Created: / 22-10-2008 / 16:41:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Branch methodsFor:'comparing'!

= anotherBranch

    ^self class = anotherBranch class
        and:[self repository = anotherBranch repository
            and:[self path = anotherBranch path]]

    "Created: / 31-03-2008 / 14:38:38 / janfrog"
!

hash

    ^path hash bitXor: repository hash

    "Created: / 31-03-2008 / 14:37:45 / janfrog"
! !

!Branch methodsFor:'converting'!

asString

    ^path

    "Created: / 09-03-2010 / 22:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Branch methodsFor:'displaying'!

displayString

    ^LabelAndIcon label: self name icon: self icon

    "Created: / 14-04-2008 / 11:11:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Branch methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    path printOn:aStream.
    aStream nextPut:$).

    "Created: / 19-03-2008 / 08:34:04 / janfrog"
! !

!Branch methodsFor:'testing'!

isBranch

    ^path startsWith:'/branches'

    "Created: / 19-03-2008 / 08:42:46 / janfrog"
!

isTag

    ^path startsWith:'/tags'

    "Created: / 19-03-2008 / 08:42:53 / janfrog"
!

isTrunk

    ^path = '/trunk/' or:[path = '']

    "Created: / 19-03-2008 / 08:42:58 / janfrog"
    "Modified: / 14-04-2008 / 12:48:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Branch class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

