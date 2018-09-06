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

Task subclass:#FileoutLikeTask
	instanceVariableNames:'suppressClasses suppressExtensions suppresBuildSupportFiles
		packageClassesChanged packageExtensionsChanged extensionMethods'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!FileoutLikeTask class methodsFor:'documentation'!

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

!FileoutLikeTask class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!FileoutLikeTask methodsFor:'accessing'!

extensionMethods
    ^ extensionMethods
!

extensionMethods:aCollection"of Methods"

    extensionMethods := aCollection.

    "Modified: / 14-05-2009 / 13:38:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filesToGenerate
    ^ self packageDefinition fileNamesToGenerate keys

    "
        SVN::CommitTask new
            package: #stx:libsvn;
            buildSupportFiles"

    "Created: / 27-11-2009 / 11:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2010 / 14:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageDefinition

    ^self workingCopy packageDefinition

    "Created: / 27-11-2009 / 11:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suppresBuildSupportFiles
    ^ suppresBuildSupportFiles
!

suppresBuildSupportFiles:something
    suppresBuildSupportFiles := something.
!

suppressClasses
    ^ suppressClasses
!

suppressClasses:aBoolean
    suppressClasses := aBoolean.
!

suppressExtensions
    ^ suppressExtensions
!

suppressExtensions:aBoolean
    suppressExtensions := aBoolean.
! !

!FileoutLikeTask methodsFor:'executing'!

doFileOut
    "Fileouts everything to the working copy"

    self
        doUpdateBuildSupportFiles;
        doRenameContainers;
        doFileOutPackageClasses;
        doFileOutPackageExtensions;
        doAddNewContainers;
        doRemoveOldContainers.

    "Created: / 10-05-2012 / 17:05:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutAll

    self
        doUpdateCode;
        doFileOut.

    "Created: / 17-08-2009 / 18:28:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-05-2012 / 17:06:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateCode
    "Updates project definitions and compiles version/copyright methods"

    self
        doInitStateVariables;
        doCompileVersionMethods;
        doCompileCopyrightMethods;
        doCompileSvnRepositoryUrlStringMethod;
        doCompileSvnRevisionNrMethod:false;
        doUpdateProjectDefinition.

    "Created: / 10-05-2012 / 17:04:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileoutLikeTask methodsFor:'executing - private'!

doAddNewContainers
    |filesAndDirsToAdd filesToAdd containers|

    ActivityNotification notify:'Adding new containers'.
    containers := self isSelectiveFileoutTask ifTrue:[
                #()
            ] ifFalse:[
                self containersToFileOut
            ].
    filesAndDirsToAdd := ((StatusCommand new)
                workingCopy:self workingCopy;
                paths:containers;
                execute) 
                    select:[:wcEntry | wcEntry status isUnversioned ]
                    thenCollect:[:wcEntry | wcEntry path ].
    filesToAdd := filesAndDirsToAdd select:
        [:fname|(workingCopy path / fname) isDirectory not].
    filesAndDirsToAdd isEmpty ifFalse:[
        packageClassesChanged := true.
        (AddCommand new)
            workingCopy:self workingCopy;
            paths:filesAndDirsToAdd;
            execute.
    ].
    filesToAdd isEmpty ifFalse:[
        (PropsetCommand new)
            workingCopy:self workingCopy;
            name:'svn:keywords';
            value:'Id HeadURL';
            paths:filesToAdd;
            execute.
        (PropsetCommand new)
            workingCopy:self workingCopy;
            name:'svn:eol-style';
            value:'LF';
            paths:filesToAdd;
            execute
    ]

    "Created: / 11-04-2008 / 10:58:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:00:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-03-2014 / 16:49:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileCopyrightMethods
    | klasses source |

    (self packageDefinition class includesSelector: #copyright) ifFalse:[^self].
    ActivityNotification notify:'Compiling #copyright methods...'.
    klasses := self classesToFileOut asArray.
    source := (self packageDefinition class compiledMethodAt: #copyright) source.

    klasses 
        withIndexDo:[:cls :index | 
            |metaCls|
            metaCls := cls theMetaclass.
            (((metaCls includesSelector:#copyright) not) and:[metaCls programmingLanguage isSmalltalk])
                ifTrue:[
                    metaCls compile:source classified:'documentation'.
                    (metaCls compiledMethodAt:#copyright) 
                        setPackage:self package asSymbol
                    ].
            ProgressNotification 
                notify:('Compiling %1 (%2)' bindWith:#copyright
                        with:cls nameWithoutPrefix)
                progress:(100 / klasses size) * index.
        ]

    "Modified: / 16-08-2009 / 12:59:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 08-04-2010 / 14:31:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileVersionMethods
    |klasses versionMethodName|

    versionMethodName := SVNSourceCodeManager nameOfVersionMethodInClasses.
    ActivityNotification notify:'Compiling #version methods...'.
    klasses := self classesToFileOut asArray.
    klasses 
        withIndexDo:[:cls :index | 
            |metaCls|

            metaCls := cls theMetaclass.
            ((metaCls includesSelector:versionMethodName) not 
                or:[ ((cls perform:versionMethodName asSymbol) startsWith:'$Id') not ]) 
                    ifTrue:[
                        metaCls compile:(metaCls 
                                    versionMethodTemplateForSourceCodeManager:SVNSourceCodeManager)
                            classified:'documentation'.
                        (metaCls compiledMethodAt:versionMethodName) 
                            setPackage:self package asSymbol
                    ].
            SVNSourceCodeManager utilities ensureCorrectVersionMethodsInClass: cls usingManager: SVNSourceCodeManager.
            ProgressNotification 
                notify:('Compiling %1 (%2)' bindWith:versionMethodName
                        with:cls nameWithoutPrefix)
                progress:(100 / klasses size) * index.
        ].

    self extensionMethodsToFileOut notEmpty ifTrue:[
        | def |

        "TODO: Not programming language aware..."
        ((def := self packageDefinition) class includesSelector: SVNSourceCodeManager nameOfVersionMethodForExtensions) ifFalse:[
            def class 
                compile:
                    (SVNSourceCodeManager versionMethodTemplateForSmalltalkFor:SVNSourceCodeManager nameOfVersionMethodForExtensions)
                classified: #documentation.
            (def class compiledMethodAt:SVNSourceCodeManager nameOfVersionMethodForExtensions) 
                setPackage:self package asSymbol

        ]
    ]

    "Created: / 28-05-2008 / 07:43:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 12:59:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2011 / 20:15:21 / jv"
    "Modified: / 28-03-2012 / 18:34:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageClasses
    |klasses|

    suppressClasses == true ifTrue:[^self].

    ActivityNotification notify:'Filing out package classes'.
    klasses := self classesToFileOut asArray.
    klasses 
        withIndexDo:[:cls :index | 
            |clsStream|

            ProgressNotification notify:'Filing out ' , cls nameWithoutPrefix
                progress:(100 / klasses size) * index.
            (self shouldFileOutClass:cls) ifTrue:[self workingCopy fileOutClass: cls]]

    "Created: / 11-04-2008 / 10:58:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:44:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2011 / 20:14:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageExtensions

    suppressExtensions == true ifTrue:[^self].

    self extensionMethodsToFileOut isEmpty ifTrue:[^self].
    self workingCopy fileOutExtensions: self extensionMethodsToFileOut

    "Modified: / 07-04-2008 / 08:37:25 / janfrog"
    "Created: / 11-04-2008 / 10:58:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-05-2009 / 13:37:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2011 / 20:14:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInitStateVariables
    packageClassesChanged := self workingCopy packageClassesChanged.
    packageExtensionsChanged := self workingCopy packageExtensionsChanged.

    "Created: / 17-06-2009 / 10:17:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 10:18:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doRemoveOldContainers
    |containers containersToKeep containersToDelete|

    self isSelectiveFileoutTask ifTrue:[
        ^ self
    ].
    ActivityNotification notify:'Removing old containers'.
    containers := self workingCopy containers.
    containersToKeep := self workingCopy containersToKeep.
    containersToDelete := containers \ containersToKeep.
    containersToDelete isEmpty ifFalse:[
        packageClassesChanged := true.
        (DeleteCommand new)
            workingCopy:self workingCopy;
            paths:containersToDelete;
            execute
    ].

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 14:33:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRenameContainerForClassNamed: new using: renames language: lang

    | old oldC newC |
    old := renames at: new.
    (renames includesKey: old) ifTrue:[
        self doRenameContainerForClassNamed: old using: renames language: lang.
    ].
    oldC := (SVN::Repository containerNameWithoutSuffixForClassNamed: old) , '.' , lang sourceFileSuffix.
    newC := (SVN::Repository containerNameWithoutSuffixForClassNamed: new) , '.' , lang sourceFileSuffix.
    (workingCopy containerFilenameFor: oldC) exists ifTrue:[
        packageClassesChanged := true.
        MoveCommand new
            workingCopy: workingCopy;
            src: oldC;
            dst: newC;
            execute.
    ].

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 06-08-2011 / 21:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRenameContainers

    | renames |
    renames := Dictionary new.
    ChangeSet current do:
                [:chg|
                chg isClassRenameChange ifTrue:[
                    renames at: chg className put: chg oldName.
                ]].
    self classesToFileOut do:[:cls|
        (renames includesKey: cls name) ifTrue:[
            self doRenameContainerForClassNamed: cls name using: renames language: cls programmingLanguage.
        ]        
    ]

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 06-08-2011 / 21:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateBuildSupportFiles
    |pkgDef|

    suppresBuildSupportFiles == true ifTrue:[
        ^self.
    ].

    pkgDef := self workingCopy packageDefinition.

    (self isSelectiveFileoutTask and:[packageClassesChanged not and:[(classes includes: pkgDef) not]]) ifTrue:[
        ^self.
    ].

    ActivityNotification notify:'Updating build files'.
    "First, generate files into a temporary files - so originals
     are not destroyed when something goes wrong."
    self filesToGenerate do:[:supportFileName | 
        | supportFile supportFileContents |

        supportFile := workingCopy path / (supportFileName , '.tmp').
        (packageClassesChanged or:[ supportFile exists not ]) ifTrue:[
            ActivityNotification notify:'Updating ' , supportFileName.
            supportFileContents := (self for: pkgDef generateFile:supportFileName).
            supportFileContents notNil ifTrue:[ 
                supportFile directory exists ifFalse: [supportFile directory makeDirectory].
                supportFile writingFileDo:[:s|
                        s nextPutAll:supportFileContents
                ]
            ]
        ]
    ].
    "Now, copy them over the old files"
    self filesToGenerate do:[:supportFileName |
        | supportFile supportFileTmp |

        supportFile := workingCopy path / supportFileName.
        supportFileTmp := workingCopy path / (supportFileName , '.tmp').
        supportFileTmp exists ifTrue:[
            supportFileTmp moveTo: supportFile
        ]
    ].

    "Created: / 20-06-2009 / 16:01:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-06-2009 / 15:18:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-01-2016 / 23:38:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateProjectDefinition
    |prjClass|

    (packageClassesChanged | packageExtensionsChanged) ifFalse:[
        ^ self
    ].
    ActivityNotification notify:'Updating project definition'.
    prjClass := Smalltalk 
                at:(ProjectDefinition initialClassNameForDefinitionOf:self package) 
                        asSymbol.
    prjClass 
        ifNotNil:[
            Class packageQuerySignal answer:prjClass package
                do:[
                    prjClass theNonMetaclass 
                        forEachContentsMethodsCodeToCompileDo:[:code :category |
                            (code startsWith: 'excludedFromPreRequisites')
                                ifFalse:[prjClass theMetaclass compile:code classified:category]
                        ]
                        ignoreOldEntries: false
                        ignoreOldDefinition: false
                ]
        ]

    "Created: / 11-04-2008 / 11:01:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 09:13:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-09-2011 / 17:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileoutLikeTask methodsFor:'private'!

classesToFileOut

    suppressClasses == true ifTrue:[^#()].

    ^ self workingCopy packageClassesFiltered:
            [:class |
            class isLoaded and: [ classes isNil or: [ classes includes: class ] ] ]

    "Created: / 23-03-2009 / 12:08:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-06-2009 / 18:17:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-10-2011 / 20:15:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containersToFileOut
    | containers extensions |

    containers := self classesToFileOut
                collect: [:class | self repository containerNameForClass: class ].
    (extensions := self extensionMethodsToFileOut) notEmpty ifTrue:
        [| languages |
        languages :=  (extensions collect:[:each|each programmingLanguage]) asSet.
        languages do:
            [:lang|containers add: (Repository containerNameForExtensions: lang)]].
    ^ containers

    "Created: / 14-05-2009 / 11:35:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 22:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodsToFileOut
    ^ self workingCopy packageExtensionsFiltered:
	    [:mth |
	    extensionMethods isNil or: [ extensionMethods includes: mth ] ]

    "Created: / 14-05-2009 / 11:32:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

for: def generateFile: file

    | contents savedClassFilenames |

        
    file ~= 'abbrev.stc' ifTrue:[^def generateFile: file].

    "Yet another kludge to trick Smalltalk>>fileNameForClass:, sigh"

    savedClassFilenames := Dictionary new.
    (def searchForClasses reject:[:e|e owningClass notNil or:[e isJavaClass ] ]) do:
        [:cls|
        savedClassFilenames 
            at: cls
            put: cls getClassFilename.
        cls setClassFilename: (SVN::Repository containerNameForClass: cls)].
    contents := def generateFile: file.
    savedClassFilenames keysAndValuesDo:
        [:cls :classFileName|
        cls setClassFilename: classFileName].
    ^contents

    "Modified: / 30-07-2014 / 20:43:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldFileOutClass: class

    "Do not fileout autoloaded classes,
    they are untouched"
    class isLoaded ifFalse:[^false].
    class theNonMetaclass isJavaClass ifTrue:[ ^ false ].

    class theNonMetaclass
        methodsDo:[:mth|(self shouldFileOutMethod: mth) ifTrue:[^true]].
    class theMetaclass
        methodsDo:[:mth|(self shouldFileOutMethod: mth) ifTrue:[^true]].
    class privateClasses 
        do:[:cls|(self shouldFileOutClass: cls) ifTrue:[^true]].

    (ChangeSet current includesChangeForClass:class) ifTrue:[ ^ true ].

    ^false

    "
        CommitTask basicNew
            package: #'stx:libsvn';
            shouldFileOutClass: CommitTask

        CommitTask basicNew
            package: #'stx:libbasic';
            shouldFileOutClass: Object
    "

    "Created: / 24-06-2009 / 19:04:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:54:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2014 / 10:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldFileOutMethod: mth

    ^mth package = package and:
	[mth getSourcePosition isNil]

    "
	CommitTask basicNew
            package: #'stx:libsvn';
	    shouldFileOutMethod: (CommitTask >> #shouldFileOutMethod:)

	CommitTask basicNew
	    package: #'stx:libbasic';
	    shouldFileOutMethod: (Object >> #yourself)
    "

    "Created: / 24-06-2009 / 19:07:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FileoutLikeTask methodsFor:'queries'!

isSelectiveFileoutTask
    ^ classes notNil or: [ extensionMethods notNil ]

    "Created: / 14-05-2009 / 13:24:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FileoutLikeTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN

    ^ '$Id$'

! !

