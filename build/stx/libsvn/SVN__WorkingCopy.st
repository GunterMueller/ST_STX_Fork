"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

Object subclass:#WorkingCopy
	instanceVariableNames:'path repository branch packageClassesChanged
		packageExtensionsChanged'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!WorkingCopy class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

!WorkingCopy class methodsFor:'instance creation'!

branch: aBranch path: aStringOrFilename

    ^self new 
        branch: aBranch; 
        path: aStringOrFilename;
        yourself

    "Created: / 19-08-2009 / 11:25:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path: aStringOrFilename

    ^self new 
        path: aStringOrFilename;
        yourself

    "Created: / 19-08-2009 / 11:25:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 07-02-2012 / 22:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopy methodsFor:'accessing'!

branch
    branch ifNil:[ 
        branch := self isValid
                    ifTrue:[self branchFromWorkingCopy]
                    ifFalse:[self branchFromQuery].
        branch ifNil:[branch := self defaultBranch]].
    ^ branch value

    "Created: / 31-03-2008 / 12:50:17 / janfrog"
    "Modified: / 14-04-2008 / 12:44:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 12:10:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branch: branchOrString

    branch := branchOrString isString
        ifFalse:
            [repository := branchOrString repository.
            branchOrString]
        ifTrue:
            ["Do it in separate thread to speedup things"
            Promise value:
                [branch := 
                    repository branches
                        detect:[:branch|branch path = branchOrString]
                        ifNone:[self error:'No such branch: ', branchOrString]]].

    "Created: / 31-03-2008 / 13:29:13 / janfrog"
    "Modified: / 19-08-2009 / 11:22:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 12:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchOrNil           

    | branches |

    branch ifNil:
        [branches := repository branches.
        branches size = 1 ifTrue:[^branch := branches anyOne].
        repository preferredBranch 
            ifNotNil:
                [branch := branches 
                    detect:[:branch|branch asString = repository preferredBranch]
                    ifNone:[nil]]].
    ^branch

    "Created: / 31-03-2008 / 12:50:17 / janfrog"
    "Modified: / 14-04-2008 / 12:44:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-03-2010 / 13:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitMode

    "UI Helper"

    ^self packageClassesChanged ifTrue:[#full] ifFalse:[#fast]

    "Created: / 13-08-2009 / 15:12:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

commitMode: mode

    mode == #full ifTrue:[packageClassesChanged := true].

    "Created: / 13-08-2009 / 15:13:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultBranch

    ^repository branches 
        detect:[:branch | branch isTrunk ]
        ifNone:[self error: 'No branch!!'].

    "Created: / 11-04-2008 / 13:15:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2008 / 11:53:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

manager

    ^repository manager

    "Created: / 11-06-2009 / 13:33:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

package

    ^self branch package

    "Created: / 31-03-2008 / 13:04:52 / janfrog"
    "Modified: / 08-02-2012 / 18:25:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageClasses

    ^self packageClassesWithPrivate reject:[:cls|cls owningClass notNil]

    "Created: / 31-03-2008 / 13:06:13 / janfrog"
    "Modified: / 23-03-2009 / 12:16:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageClassesChanged
    packageClassesChanged :=
        (packageClassesChanged == true)
            or:[self computePackageClassesChanged].

    ^ packageClassesChanged

    "Modified: / 13-08-2009 / 10:21:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-04-2010 / 23:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageClassesFiltered: classFilter

    ^self packageClasses select: [:class|classFilter value: class].

    "Created: / 23-03-2009 / 12:04:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageClassesWithPrivate

    ^ProjectDefinition searchForClassesWithProject: self package

    "Created: / 23-03-2009 / 12:06:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageClassesWithPrivateFiltered: classFilter

    ^self packageClassesWithPrivate select: [:class|classFilter value: class].

    "Created: / 23-03-2009 / 12:07:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageDefinition
    ^LibraryDefinition definitionClassForPackage:self package createIfAbsent:true

    "Created: / 15-06-2009 / 12:41:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-05-2012 / 17:15:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageExtensions

    ^ProjectDefinition searchForExtensionsWithProject: self package

    "Created: / 31-03-2008 / 13:06:13 / janfrog"
    "Modified: / 11-04-2008 / 08:25:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageExtensionsChanged
    packageExtensionsChanged :=
        (packageExtensionsChanged == true)
            or:[self computePackageExtensionsChanged].

    ^ packageExtensionsChanged

    "Modified: / 13-08-2009 / 10:22:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-04-2010 / 23:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageExtensionsFiltered:aBlock

    ^self packageExtensions select:aBlock

    "Created: / 11-06-2009 / 13:37:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path

    ^ path

    "Created: / 31-03-2008 / 12:42:42 / janfrog"
    "Modified: / 21-08-2009 / 17:47:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path:aStringOrFilename
    path := aStringOrFilename asFilename.

    "Created: / 31-03-2008 / 12:42:42 / janfrog"
!

pathBase

    ^self manager workingCopyBase.

    "Created: / 11-06-2009 / 13:32:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repository
    ^ repository

    "Created: / 31-03-2008 / 12:42:22 / janfrog"
!

repository:aRepository
    repository := aRepository.

    "Created: / 31-03-2008 / 12:42:22 / janfrog"
!

url

    ^branch url

    "Created: / 31-03-2008 / 13:05:01 / janfrog"
! !

!WorkingCopy methodsFor:'accessing - change sets'!

changeSet

    ^self changeSetIgnoreAutoloaded: false

    "Created: / 23-03-2009 / 18:57:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-08-2009 / 14:26:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetForContainer: containerName

    ^(ChangeSet fromStream:
        (self containerReadStreamFor: containerName))
        name: containerName;
        yourself

    "Created: / 09-10-2008 / 20:21:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2011 / 21:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForContainer: containerName revision: rev
    | containerContents |

    containerContents := self cat: containerName revision: rev.
    ^(ChangeSet fromStream: containerContents readStream)
        name: containerName , ' (' , rev printString , ')';
        yourself

    "Created: / 10-02-2012 / 09:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetForUpdate
    |diffSet classesToRemove|

    diffSet := self diffSetBetweenImageAndWorkingCopy.
    classesToRemove := Set new.
    ActivityNotification notify:'Computing update change set'.
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
                 "Created: / 24-03-2009 / 08:17:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetIgnoreAutoloaded: ignoreAutoloaded

    | containersToIgnore changeSet |

    containersToIgnore :=
        (self packageClassesFiltered:[:cls|cls isLoaded not])
            collect:[:cls|repository containerNameForClass: cls].

    changeSet := ChangeSet new.
    self containers do:
        [:container |
        (containersToIgnore includes: container)
            ifFalse:
                [changeSet addAll: 
                    (self changeSetForContainer: container)]].
    ^changeSet

    "Created: / 12-08-2009 / 14:26:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopy methodsFor:'accessing - containers'!

containerFilenameFor: containerName

    ^self path construct: containerName

    "Created: / 09-10-2008 / 20:25:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containerReadStreamFor: containerName

    | containerFile containerStream |
    containerFile := self containerFilenameFor: containerName. 
    OperatingSystem isMSWINDOWSlike
        ifTrue:
            ["
            Dirty hack for MS Windows:
            Windows do not allow me to open some files for the first
            time (OpenError is raised). Second try after some time is usually OK.
            I don't know why this happens. Claus, do you have any idea?
            "
            [ containerStream := containerFile readStream ]
                on: OpenError do: 
                    [Delay waitForMilliseconds: 100. "A magic constant here :-("
                    containerStream := containerFile readStream]]
        ifFalse:
            ["
            Unix behaves pretty fine :-)
            "
            containerStream := containerFile readStream].

    ^containerStream

    "Created: / 09-10-2008 / 20:26:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containerSuffixes

    ^ProgrammingLanguage all collect:[:each|each sourceFileSuffix]

    "Created: / 23-03-2009 / 18:53:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 18:15:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamFor: containerName
    | filename directory |

    filename := self containerFilenameFor: containerName.
    (directory := filename directory) exists ifFalse:[
        directory recursiveMakeDirectory
    ].
    ^filename writeStream
        eolMode: #nl;
        yourself

    "Created: / 09-10-2008 / 20:24:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-09-2012 / 23:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamForExtensions: aProgrammingLanguage


    ^self containerWriteStreamFor: 
        (Repository containerNameForExtensions: aProgrammingLanguage)

    "Created: / 30-12-2009 / 18:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2009 / 22:00:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamForExtensions: aProgrammingLanguage javaClass: aJavaClass

    ^self containerWriteStreamFor: 
        ('java' , Filename separator , 'extensions' , Filename separator , 
            ((aJavaClass theNonMetaclass name copyReplaceAll: $/ with: (Filename separator)) , '.' ,aProgrammingLanguage sourceFileSuffix))

    "Created: / 04-09-2012 / 23:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 23:40:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containers

    ^(self path directoryContents 
        select:
            [:container|self containerSuffixes anySatisfy:
                [:suffix|container endsWith:suffix]]) asSet

    "Created: / 23-03-2009 / 18:52:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-06-2009 / 21:44:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containersToKeep

    | containers extensions |

    containers := self packageClasses 
        collect:[:cls|self repository containerNameForClass: cls].
    (extensions := self packageExtensions) notEmpty ifTrue:
        [| languages |
        languages :=  (extensions collect:[:each|each programmingLanguage]) asSet.
        languages do:
            [:lang|containers add: (Repository containerNameForExtensions: lang)]].    
    "Keep all directories"
    path directoryContents do:
        [:f|
        (f ~= '.svn' and: [(path / f) isDirectory]) ifTrue:
            [containers add: f]].
    "Keep all .st files that are for with other operating systems"

    self packageDefinition classNamesAndAttributesDo: [:nm :attributes|
        attributes do:[:attr|
            (#(win32 unix vms autoload) includes: attr) ifTrue:[
                containers add: ((SVN::Repository containerNameWithoutSuffixForClassNamed: nm) , '.st')
            ]
        ]
    ].


    ^containers asSet.

    "Created: / 12-06-2009 / 21:27:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-09-2011 / 17:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containersWriteStreamForClass:cls 

    ^self containerWriteStreamFor: (repository containerNameForClass:cls)

    "Created: / 09-10-2008 / 20:23:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopy methodsFor:'accessing - diff sets'!

diffSetBetweenImageAndWorkingCopy

    | imageChangeSet revisionChangeSet |
    imageChangeSet := ChangeSet forPackage: self package ignoreAutoloaded: true.
    revisionChangeSet := self changeSetIgnoreAutoloaded: true.
    ^imageChangeSet diffSetsAgainst: revisionChangeSet

    "Created: / 24-03-2009 / 08:17:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-08-2009 / 14:32:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopy methodsFor:'accessing - tasks'!

commitTask

    ^CommitTask new workingCopy: self

    "Created: / 23-03-2009 / 11:47:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

mergeTask

    ^MergeTask new workingCopy: self

    "Created: / 25-11-2009 / 17:16:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTask

    ^UpdateTask new workingCopy: self

    "Created: / 24-03-2009 / 15:13:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopy methodsFor:'commands'!

cat: file

    ^self cat: file revision: SVN::Revision head

    "Created: / 19-04-2008 / 10:52:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-10-2008 / 20:16:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cat: file revision: revision

    ^CatCommand new
        workingCopy: self;
        path: file;
        revision: revision;
        execute.

    "Created: / 19-04-2008 / 10:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-01-2010 / 13:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkout
    |pkgDef|

    pkgDef := self packageDefinition.
    self 
        checkout:(pkgDef ifNotNil:[ pkgDef svnRevision ] ifNil:[ SVN::Revision head ])
!

checkout:revision 

    "Checkout a working copy. If full is true, then
     full checkout is performed, i.e., whole subtree
     is checked out. If not, only project files and
     common subdirectories are check out"


    ^self checkout: revision full: false

    "Created: / 31-03-2008 / 12:57:58 / janfrog"
    "Modified: / 21-08-2009 / 17:45:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-04-2011 / 15:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkout:revision full: full

    "Checkout a working copy. If full is true, then
     full checkout is performed, i.e., whole subtree
     is checked out. If not, only project files and
     common subdirectories are check out"

    |checkoutInfo pkg |

    pkg := self package.
    self 
        synchronized:[
            self ensurePathExists.
            ActivityNotification notify:'Checking out ' , pkg.
            full ifTrue:[
                checkoutInfo := (CheckoutCommand new)
                                    revision:revision;
                                    depth: 'infinity';
                                    workingCopy:self;
                                    execute
            ] ifFalse:[
                "JV@2011-06-13: TODO: rewrite it so it does not set
                 inifinite depth on subpackages. This requires to
                 split this method..."

                | subdirs |
                checkoutInfo := (CheckoutCommand new)
                                    revision:revision;
                                    depth: 'immediates';
                                    workingCopy:self;
                                    execute.
                "Checkout common subdirs"
                subdirs := #('resources' 'bitmaps' 'autopackage' 'builder' 'java')
                                select:[:e| (path / e) isDirectory].
                checkoutInfo addAll:
                    (UpdateCommand new
                        workingCopy: self;
                        setDepth: 'infinity';
                        paths: subdirs;
                        execute
                    ).
                "Checkout nested packages"
                subdirs := OrderedCollection new.
                Smalltalk allPackageIDs do:
                    [:each |
                    (each size > pkg size and:[(each at: pkg size + 1) == $/ and:[each startsWith: pkg]]) ifTrue:
                        [subdirs add: ((each copyFrom: self package size + 2) replaceAll:$/ with: Filename separator)]].
                subdirs notEmpty ifTrue:[
                    subdirs := subdirs asSortedCollection:[:a :b| a size < b size].
                    checkoutInfo addAll:
                        (UpdateCommand new
                            workingCopy: self;
                            setDepth: 'empty';
                            paths: subdirs;
                            execute
                    ).
                ]
            ]
        ].
    ^ checkoutInfo

    "Modified: / 21-08-2009 / 17:45:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 25-04-2011 / 15:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2012 / 23:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cleanup

    self ensurePathExists.
    self isValid ifFalse:[^self].
    ^CleanupCommand new
        workingCopy: self path;
        execute.

    "Created: / 08-11-2008 / 08:12:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

commit:message 

    ^self commitTask
        message: message;
        do

    "Created: / 31-03-2008 / 13:11:15 / janfrog"
    "Modified: / 07-04-2008 / 08:52:13 / janfrog"
    "Modified: / 23-03-2009 / 11:48:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

commit:message files: files

    ^self commitTask
        message: message;
        paths: files;
        do

    "Created: / 31-03-2008 / 13:11:15 / janfrog"
    "Modified: / 07-04-2008 / 08:52:13 / janfrog"
    "Modified: / 23-03-2009 / 11:48:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-03-2012 / 17:15:25 / jv"
!

info: paths

    ^SVN::InfoCommand new
        workingCopy: self;
        paths: paths;
        execute
!

log

    ^self branch log

    "Created: / 19-04-2008 / 10:52:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

log: aString

    ^self branch log: aString

    "Created: / 19-04-2008 / 10:53:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revert

    self ensurePathExists.
    self isValid ifFalse:[^self checkout].
    ^RevertCommand new
        workingCopy: self path;
        execute.

    "Created: / 22-10-2008 / 16:46:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revert: containers

    | revertInfo |

    self ensurePathExists.
    self isValid ifFalse:[^self checkout].
    self synchronized:
        [revertInfo := RevertCommand new
                            workingCopy: self;
                            paths: containers;
                            execute].
    ^revertInfo

    "Created: / 03-11-2008 / 21:20:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-11-2008 / 08:54:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-12-2009 / 20:16:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status

    | status |
    self ensureIsValid.
    self synchronized:
        [status := StatusCommand new
                    workingCopy: self;
                    execute].
    ^status

    "Created: / 11-04-2008 / 09:22:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:35:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

update

    | updateInfo |

    self ensurePathExists.
    self isValid ifFalse:[^self checkout].
    self synchronized:
        [updateInfo := UpdateCommand new
                            workingCopy: self path;
                            execute].
    ^updateInfo

    "Created: / 21-05-2008 / 09:44:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:25:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopy methodsFor:'error reporting'!

error

    self error:'Unknown error'

    "Created: / 31-03-2008 / 12:44:06 / janfrog"
!

error: aString

    WCError raiseWith:#error: errorString:aString

    "Created: / 31-03-2008 / 12:43:51 / janfrog"
! !

!WorkingCopy methodsFor:'inspecting'!

browse
    "Opens a file browser on the working copy"

    UserPreferences current fileBrowserClass
        openOnDirectory: path asFilename

    "Created: / 04-02-2012 / 17:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2TabBrowser

    self exists ifTrue:[
        ^self newInspector2Tab
           label: 'Working copy';
            priority: 35;
            application: (SVN::WorkingCopyBrowser on: self)
    ] ifFalse:[
        ^self newInspector2Tab
           label: 'Working copy';
           priority: 35;
           view: (Label new label:'Not yet checked out'; yourself)    
    ]

    "Modified: / 14-04-2011 / 17:42:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2011 / 11:56:28 / cg"
! !

!WorkingCopy methodsFor:'private'!

branchFromQuery

    ^BranchQuery new 
        repository: repository;
        raiseRequest.
!

branchFromWorkingCopy

    | info bpath |
    info := (self info:#('.')) anyOne.
    bpath := info url copyFrom: info root size + 1.
    repository isNil ifTrue:[
        repository := Repository package: nil url: info root.
    ].
    ^path isEmptyOrNil
        ifTrue:[nil]
        ifFalse:[Branch repository: repository path: bpath].

    "Modified: / 08-02-2012 / 18:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commited

    packageExtensionsChanged := false.
    packageClassesChanged := false.

    "Created: / 13-08-2009 / 10:23:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

computePackageClassesChanged
    "
        Answers true iff package classes differs from
        those listed in ProjectDefinition>>classNamesAndAttributes"

    |listedClasses realClasses pkgDef |

    (pkgDef := self packageDefinition) isNil ifTrue:[^true].

    listedClasses :=    pkgDef compiled_classNames_common ,
                        pkgDef compiled_classNamesForPlatform ,
                        pkgDef autoloaded_classNames.

    realClasses := self  packageClasses collect:[:cls | cls fullName ].
    listedClasses size ~= realClasses size 
        ifTrue:[^ true].
    (realClasses allSatisfy:[:realClass | listedClasses includes:realClass ])
        ifFalse:[^true].
    ^false




    "
        (CommitTask new package: 'stx:libsvn')
            computePackageClassesChanged
        (CommitTask new package: 'cvut:fel/smallruby')
            computePackageClassesChanged
        (SVN::RepositoryManager workingCopyForPackage: #'stx:libbasic')
            computePackageClassesChanged 
    "

    "Created: / 16-06-2009 / 10:08:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-08-2009 / 10:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 07-09-2012 / 11:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computePackageExtensionsChanged
    "
        Answers true iff package extension method differs from
        those listed in ProjectDefinition>>extensionMethodNames"
    
    |listedExtensions listedExtensionsDictionary realExtensions|

    realExtensions := self  packageExtensions.
    listedExtensions := self packageDefinition 
                extensionMethodNames.
    (listedExtensions size / 2) ~= realExtensions size ifTrue:[
        ^ true
    ].
    listedExtensionsDictionary := Dictionary new.
    listedExtensions 
        pairWiseDo:[:className :selector | 
            (listedExtensionsDictionary at:className
                ifAbsentPut:[ OrderedCollection new ]) add:selector
        ].
    ^ (realExtensions 
        allSatisfy:[:mth | 
            (listedExtensionsDictionary includesKey:mth mclass name) 
                and:[ (listedExtensionsDictionary at:mth mclass name) includes:mth selector ]
        ]) 
            not

    "
        (CommitTask new package: 'stx:libsvn')
            packageExtensionsHasChanged"

    "Created: / 16-06-2009 / 10:11:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 10:27:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 04-05-2012 / 17:12:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureIsValid

    self isValid ifFalse:
        [self checkout].
    self isValid ifFalse:[self error:'Cannot create working copy']

    "Created: / 08-04-2008 / 14:19:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

ensureMethodsHasAbsoluteSourceFiles

    Smalltalk allClassesDo:
        [:cls| | tryLocalSourceFirst makeLocalSource |
        makeLocalSource :=  
            [:mth|
            mth package = self package ifTrue:
                [mth makeSourceFileAbsolute]].
        tryLocalSourceFirst := Class tryLocalSourceFirst.
        Class tryLocalSourceFirst: true.
        cls methodsDo: makeLocalSource.
        cls class methodsDo: makeLocalSource.
        Class tryLocalSourceFirst: tryLocalSourceFirst.].

    "Created: / 21-08-2009 / 17:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 16:07:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensurePathExists

     [path exists ifFalse:
        ["/self ensureMethodsHasAbsoluteSourceFiles.
        path recursiveMakeDirectory
        ]]
        on: Smalltalk::Error do:[:ex|self error:'Cannot create working copy'].

    "Created: / 08-04-2008 / 14:26:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-08-2009 / 17:46:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 16:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2012 / 11:17:21 / jv"
! !

!WorkingCopy methodsFor:'private - file out'!

fileOutClass:cls

    |stream|

    [stream := self  containersWriteStreamForClass:cls.
    self fileOutClass:cls on:stream]
        ensure:[ stream ifNotNil:[ stream close ]]

    "Modified: / 11-06-2009 / 16:18:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 19:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutClass:cls on:clsStream

"/    cls methodDictionary do:
"/        [:each|each makeLocalStringSource].
"/
"/    cls class methodDictionary do:
"/        [:each|each makeLocalStringSource].

    SVNSourceCodeManager
                fileOutSourceCodeOf:cls 
                                 on:clsStream 
                      withTimeStamp:false 
                     withInitialize:true 
                     withDefinition:true
                       methodFilter:[:mth | mth package = self package ]

    "
        String streamContents:[:s|
            (SVN::RepositoryManager repositoryForPackage: Setup::ML package)
                workingCopy
                fileOutClass: Setup::ML on: s
        ]

    "

    "Created: / 19-04-2008 / 09:58:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-06-2009 / 16:18:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2011 / 20:21:59 / jv"
    "Modified (format): / 07-07-2011 / 20:29:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods

    ^self fileOutExtensions: extensionMethods in: self path

    "Created: / 30-12-2009 / 19:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods in: directory

    ProgrammingLanguage all do:[:lang| 
        | stream methods |

        methods := extensionMethods select:[:mth|mth programmingLanguage = lang].
        methods notEmpty ifTrue: [
            ActivityNotification notify:'Filing out extension methods (', lang name , ')'.
            self fileOutExtensions: methods in: directory language: lang
        ]
    ]

    "Created: / 04-09-2012 / 22:56:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods in: directory language: lang
    "Given a directory, files out extensions methods in given language.
     Takes care about Java extensions, as they are filed out separately
     in per-classe .st file in <package dir>/java/extensions/<package>/<java classname>.st"

    | stream nonJavaExtensionsMethod javaExtensionsMethods |


    stream := self containerWriteStreamForExtensions: lang.
    [
        nonJavaExtensionsMethod := extensionMethods reject:[:each|each mclass theNonMetaclass isJavaClass].
        self fileOutExtensions: nonJavaExtensionsMethod on: stream language: lang.
    ] ensure:[
        stream close
    ].

    javaExtensionsMethods := Dictionary new.
    extensionMethods do:[:mthd|
        mthd mclass  theNonMetaclass isJavaClass ifTrue:[
            (javaExtensionsMethods at: mthd mclass ifAbsentPut:[OrderedCollection new]) add: mthd.
        ].
    ].
    javaExtensionsMethods keysAndValuesDo:[:cls :methods|
        [
            stream := self containerWriteStreamForExtensions: lang javaClass: cls.
            self fileOutExtensions: methods on: stream language: lang.
        ] ensure:[
            stream close.
        ]

    ]

    "Created: / 04-09-2012 / 23:05:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-11-2012 / 00:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods on:stream language: language 

    extensionMethods do:[:each|each makeLocalStringSource].

    "Special hack for Smalltalk - use SourceCodeManager routine"
    (language isSmalltalk and:[extensionMethods anyOne mclass theNonMetaclass isJavaClass not]) ifTrue:[
        SVNSourceCodeManager fileOutSourceCodeExtensions: extensionMethods package: self package on: stream.
        ^self.
    ].

    "/ Generic fileout "

    language sourceFileWriterClass new
        fileOutPackageDefinition: self package on: stream;
        fileOutMethods: extensionMethods on: stream

    "Modified: / 15-06-2009 / 11:55:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 19:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 23:54:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopy methodsFor:'queries'!

exists

    ^self isValid

    "Created: / 09-12-2010 / 23:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasBranch

    branch ifNotNil:[^true].
    ^repository preferredBranch 
        ifNotNil:[self branchOrNil notNil]
        ifNil:[repository branches size == 1]

    "Modified: / 29-03-2010 / 13:57:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopy methodsFor:'testing'!

isValid

    | svnMetadataDir contents |

    svnMetadataDir := self path / '.svn'.
    svnMetadataDir exists ifFalse:[ ^false ].
    (svnMetadataDir / 'wc.db') exists ifTrue:[ ^ true ].
    (svnMetadataDir / 'entries') exists  ifFalse:[ ^false ].
    (svnMetadataDir / 'text-base') exists ifFalse:[ ^false ].

    ((contents := self path directoryContents) size = 1 
        and:[contents anElement ~= '.svn']) ifTrue:[ ^ false ].

    ^true

    "Created: / 08-04-2008 / 14:17:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-07-2009 / 13:57:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-01-2016 / 23:14:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopy class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

