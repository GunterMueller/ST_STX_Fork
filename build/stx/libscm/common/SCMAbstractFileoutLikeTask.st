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

SCMAbstractTask subclass:#SCMAbstractFileoutLikeTask
	instanceVariableNames:'suppressClasses suppressExtensions suppresBuildSupportFiles
		packageClassesChanged packageExtensionsChanged extensionMethods
		fileout2codeMap'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX-Tasks'
!

!SCMAbstractFileoutLikeTask class methodsFor:'documentation'!

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

!SCMAbstractFileoutLikeTask methodsFor:'accessing'!

extensionMethods
    ^ extensionMethods
!

extensionMethods:aCollection"of Methods"

    extensionMethods := aCollection.

    "Modified: / 14-05-2009 / 13:38:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filesToGenerate
    self error: 'Should not be sent'.
    ^ self packageDefinition fileNamesToGenerate keys

    "
	SVN::CommitTask new
	    package: #stx:libsvn;
	    buildSupportFiles"

    "Created: / 27-11-2009 / 11:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 22:31:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filesToGenerateFor: package
    ^ self filesToGenerateFor: package skipNotOverwritable: true

    "Created: / 22-02-2014 / 22:31:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2015 / 08:20:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filesToGenerateFor: package skipNotOverwritable: skipNotOverwritable
    | files definition fileNamesToSkip |


    package isVirtual ifTrue:[ 
        ^ OrderedCollection new 
    ].
    (self isSelectiveFileoutTask and:[packageClassesChanged not and:[(classes includes: package definition) not]]) ifTrue:[
        ^ OrderedCollection new
    ].  
    files := OrderedCollection new.
    definition := package definition.

    fileNamesToSkip := #().
    (package temporaryWorkingCopyRoot / definition rcFilename) exists ifTrue:[
        "/ Skip .rc files, it only generates a noise in repo and merge conflicts...
        fileNamesToSkip := fileNamesToSkip copyWith: definition rcFilename.
    ].

    definition fileNamesToGenerate keysAndValuesDo:[:file :selector |
        (fileNamesToSkip includes: file) ifFalse:[
            skipNotOverwritable ifTrue:[
                | annotation |

                annotation := (definition class lookupMethodFor: selector) annotationAt: #file:overwrite:.
                (annotation isNil or:[ (annotation argumentAt: 2) or:[ (package temporaryWorkingCopyRoot / file) exists not] ]) ifTrue:[ 
                    files add: file
                ].
            ] ifFalse:[ 
                files add: file
            ].
        ].
    ].
    ^ files

    "
        SVN::CommitTask new
            package: #stx:libsvn;
            buildSupportFiles"

    "Created: / 11-06-2015 / 08:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageDefinition
    self error: 'Should not be sent'.
    ^self package definition

    "Created: / 27-11-2009 / 11:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 22:53:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

!SCMAbstractFileoutLikeTask methodsFor:'executing - private'!

doAddNewContainers
    packages do:[:each | each isVirtual ifFalse: [ self doAddNewContainersFor: each ] ]

    "Created: / 11-04-2008 / 10:58:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:00:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAddNewContainersFor: package
    | wcroot containers |

    ActivityNotification notify:'Adding new containers'.
    wcroot := package temporaryWorkingCopyRoot.
    containers := (self containersToFileOutFor: package)
                    collect:[ :e | wcroot / e ].
    self temporaryWorkingCopy track: containers.

    "Created: / 22-02-2014 / 22:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2017 / 21:45:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileCopyrightMethods
    packages do:[:each | each isVirtual ifFalse: [ self doCompileCopyrightMethodsFor: each ] ]

    "Modified: / 16-08-2009 / 12:59:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 08-04-2010 / 14:31:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileCopyrightMethodsFor: package
    | klasses source |

    (package definition class includesSelector: #copyright) ifFalse:[^self].
    ActivityNotification notify:'Compiling #copyright methods...'.
    klasses := (self classesToFileOutFor: package) asArray.
    source := (package definition class compiledMethodAt: #copyright) source.

    klasses
	withIndexDo:[:cls :index |
	    |metaCls|
	    metaCls := cls theMetaclass.
	    (((metaCls includesSelector:#copyright) not) and:[metaCls programmingLanguage isSmalltalk])
		ifTrue:[
		    metaCls compile:source classified:'documentation'.
		    (metaCls compiledMethodAt:#copyright)
			setPackage:package name asSymbol
		    ].
	    ProgressNotification newException
		messageText: ('Compiling %1 (%2)' bindWith:#copyright
						      with:cls nameWithoutPrefix);
		parameter: (100 / klasses size) * index;
		raiseRequest.
	]

    "Created: / 21-02-2014 / 22:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileVersionMethods
    packages do:[:each |
	each isVirtual ifFalse: [
	    | klasses |

	    klasses := self classesToFileOutFor: each.
	    self doCompileVersionMethodsFor: each in: klasses asArray.
	]
    ].

    "Created: / 09-10-2013 / 11:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileVersionMethodsFor: package in: klasses
    | versionMethodName|

    versionMethodName := package manager nameOfVersionMethodInClasses.
    ActivityNotification notify:'Compiling #version methods...'.
    klasses
        withIndexDo:[:cls :index |
            |metaCls|

            cls isJavaClass ifFalse:[
                metaCls := cls theMetaclass.
                ((metaCls includesSelector:versionMethodName) not
                    "JV@2012-11-14: libsvn did this check, however, it is not valid for
                     SCMs that does not expand keywords. I disable it, but kept as comment
                     as I do not remember why it was good for..."
                    "or:[ ((cls perform:versionMethodName asSymbol) startsWith:'$Id') not ]")
                        ifTrue:[
                            metaCls compile:(metaCls
                                        versionMethodTemplateForSourceCodeManager:package manager)
                                classified:'documentation'.
                            (metaCls compiledMethodAt:versionMethodName)
                                setPackage:package name asSymbol
                        ].
                package manager utilities ensureCorrectVersionMethodsInClass: cls usingManager: package manager.
            ].
            ^ ProgressNotification newException
                messageText: ('Compiling %1 (%2)' bindWith:versionMethodName
                                                      with:cls nameWithoutPrefix);
                parameter: (100 / klasses size) * index;
                raiseRequest
        ].

    (self extensionMethodsToFileOutFor: package) notEmpty ifTrue:[
        | def |

        "TODO: Not programming language aware..."
        ((def := package definition) class includesSelector: package manager nameOfVersionMethodForExtensions) ifFalse:[
            def class
                compile:
                    (package manager versionMethodTemplateForSmalltalkFor:package manager nameOfVersionMethodForExtensions)
                classified: #documentation.
            (def class compiledMethodAt:package manager nameOfVersionMethodForExtensions)
                setPackage:package name asSymbol

        ]
    ]

    "Created: / 21-02-2014 / 23:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2014 / 09:04:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

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
    "Modified: / 21-11-2012 / 00:43:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutAll

    self
	doUpdateCode;
	doFileOut.

    "Created: / 17-08-2009 / 18:28:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-05-2012 / 17:06:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageClasses
    packages do:[:each | each isVirtual ifFalse: [ self doFileOutPackageClassesFor: each ] ].

    "Created: / 11-04-2008 / 10:58:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:44:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageClassesFor: package
    |klasses|

    suppressClasses == true ifTrue:[^self].

    ActivityNotification notify:'Filing out package classes'.
    klasses := (self classesToFileOutFor: package) asArray.
    klasses
	withIndexDo:[:cls :index |
	    |clsStream|
	    ProgressNotification newException
		messageText: 'Filing out ' , cls nameWithoutPrefix;
		parameter: (100 / klasses size) * index;
		raiseRequest.

	    (self shouldFileOutClass:cls) ifTrue:[package fileOutClass: cls]
	].

    "Created: / 21-02-2014 / 23:09:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageExtensions
    packages do:[:each | each isVirtual ifFalse: [ self doFileOutPackageExtensionsFor: each ] ]

    "Modified: / 07-04-2008 / 08:37:25 / janfrog"
    "Created: / 11-04-2008 / 10:58:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-05-2009 / 13:37:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFileOutPackageExtensionsFor: package
    | extensions |

    suppressExtensions == true ifTrue:[^self].

    extensions := self extensionMethodsToFileOutFor: package.
    extensions notEmpty ifTrue:[
	package fileOutExtensions: extensions.
    ]

    "Created: / 21-02-2014 / 23:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 23:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInitStateVariables
    packageClassesChanged := packages contains:[:each| each isVirtual not and: [ each classesHasChanged ] ] .
    packageExtensionsChanged := packages contains:[:each|  each isVirtual not and: [ each extensionsHasChanged ] ].

    "Created: / 17-06-2009 / 10:17:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 10:18:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-06-2015 / 06:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemoveOldContainers
    packages do:[:each | each isVirtual ifFalse: [ self doRemoveOldContainersFor: each ] ]

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemoveOldContainersFor: package
    | wcroot containers containersToKeep containersToDelete |

    self isSelectiveFileoutTask ifTrue:[
	^ self
    ].
    ActivityNotification notify:'Removing old containers'.
    wcroot := package temporaryWorkingCopyRoot.
    containers := package containers.

    containersToKeep := package containersToKeep.
    containersToDelete := containers \ containersToKeep.
    "/ Fix for issue #26: Java extension files are removed.
    "/ Filter out all Java extension containers which are for classes which
    "/ are currently not loaded.
    containersToDelete := containersToDelete reject:[:each |
	(each startsWith: 'java/extensions/')
	    and:[
		| nm |

		nm := each copyFrom:17 to: (each lastIndexOf: $.) - 1.
		(JavaVM registry classes contains: [:cls | cls binaryName = nm]) not.
	    ].
    ].

    containersToDelete do:[:nm|
	| entry |

	entry := wcroot / nm.
	entry remove
    ]

    "Created: / 21-02-2014 / 23:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRenameContainerForClassNamed: new for: package using: renames language: lang

    | wcroot assoc old circular oldC oldE newC newE  |
    assoc := renames detectLast:[:each | each key == new ] ifNone:[ ^ self ].
    old := assoc value.
    renames remove: assoc.

    "/ Call recursively to process sequence of renames but not if
    "/ its a circular rename...
    circular := (renames contains:[:each | each value == new ]).
    circular ifTrue:[ ^ self ].
    self doRenameContainerForClassNamed: old for: package using: renames language: lang.

    wcroot := package temporaryWorkingCopyRoot.
    oldC := package containerNameForClassNamed: old language: lang .
    newC := package containerNameForClassNamed: new language: lang .
    (oldE := wcroot / oldC) exists ifTrue:[
	packageClassesChanged := true.
	newE := wcroot / newC.
	oldE moveTo: newE.
    ].

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 06-08-2011 / 21:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 00:13:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRenameContainers

    | renames names |
    renames := OrderedCollection new.
    names := OrderedCollection new.
    ChangeSet current do:
		[:chg|
		chg isClassRenameChange ifTrue:[
		    renames add: chg className -> chg oldName.
		    names add: chg fullClassName.
		]].
    packages do:[:each |
	each isVirtual ifFalse: [
	    (self classesToFileOutFor: each) do:[:cls|
		(names includes: cls name) ifTrue:[
		    self doRenameContainerForClassNamed: cls name for: each using: renames language: cls programmingLanguage.
		]
	    ]
	]
    ].

    "Created: / 11-04-2008 / 11:00:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:03:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 06-08-2011 / 21:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2014 / 22:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateBuildSupportFiles
    packages do:[:each | self doUpdateBuildSupportFilesFor: each ]

    "Created: / 20-06-2009 / 16:01:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-06-2009 / 15:18:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-01-2015 / 07:20:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateBuildSupportFilesFor: package
    | actuallyGeneratedFiles |

    suppresBuildSupportFiles == true ifTrue:[
        ^self.
    ].

    actuallyGeneratedFiles := OrderedCollection new.
    ActivityNotification notify:'Updating build files'.
    "First, generate files into a temporary files - so originals
     are not destroyed when something goes wrong."
    (self filesToGenerateFor: package) do:[:supportFileName |
        | supportFile supportFileContents |

        supportFile := package temporaryWorkingCopyRoot / (supportFileName , '.tmp').
        (packageClassesChanged or:[ supportFile exists not ]) ifTrue:[
            ActivityNotification notify:'Updating ' , supportFileName.
            supportFileContents := self generateFile:supportFileName for: package. 
            supportFileContents notNil ifTrue:[  
                supportFile directory exists ifFalse: [supportFile directory makeDirectory].
                supportFile writingFileDo:[:s|
                    s nextPutAll:supportFileContents
                ].
                actuallyGeneratedFiles add: (package temporaryWorkingCopyRoot / supportFileName).
            ]
        ]
    ].
    "Now, copy them over the old files"
    actuallyGeneratedFiles do:[:supportFile |
        | supportFileTmp |

        supportFileTmp := temporaryWorkingCopy pathName asFilename / (supportFile pathNameRelative , '.tmp').
        supportFileTmp moveTo: supportFile.
    ].
    "Finally make sure all generated files are tracked"
    temporaryWorkingCopy track: actuallyGeneratedFiles.

    "Created: / 21-02-2014 / 23:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 16:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateCode
    "Updates project definitions and compiles version/copyright methods"

    self
	doInitStateVariables;
	doCompileVersionMethods;
	doCompileCopyrightMethods;
	doUpdateProjectDefinition.

    "Created: / 10-05-2012 / 17:04:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateProjectDefinition
    packages do:[:each | each isVirtual ifFalse: [ self doUpdateProjectDefinitionFor: each ] ]

    "Created: / 11-04-2008 / 11:01:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 09:13:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2014 / 22:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateProjectDefinitionFor: package
    | prjClass prjClassChanged |

    (packageClassesChanged | packageExtensionsChanged) ifFalse:[
        ^ self
    ].
    prjClassChanged := false.
    ActivityNotification notify:'Updating project definition'.
    prjClass := ProjectDefinition definitionClassForPackage: package name createIfAbsent:false.
    prjClass isNil ifTrue:[
        prjClass := ProjectDefinition definitionClassForPackage: package name createIfAbsent:true.
        prjClassChanged := true.
    ].

    "/Now do standard update
    [
        prjClass theNonMetaclass
            forEachContentsMethodsCodeToCompileDo:[:code :category |
                (code startsWith: 'excludedFromPreRequisites')
                    ifFalse:[prjClass theMetaclass compile:code classified:category]
            ]
            "/ignoreOldEntries: false
            ignoreOldDefinition: false.
    ] on: Class packageQuerySignal do:[ :query |
        prjClassChanged := true.
        query resume: prjClass package
    ].
    (self isSelectiveFileoutTask and:[ prjClassChanged ]) ifTrue:[ 
        classes := classes copyWith: prjClass.
    ].

    "Created: / 21-02-2014 / 23:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2017 / 11:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-07-2017 / 08:22:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractFileoutLikeTask methodsFor:'private'!

classesToFileOutFor: package

    suppressClasses == true ifTrue:[^#()].

    ^ package classesFiltered:
	    [:class |
	    class isLoaded and: [ classes isNil or: [ classes includes: class ] ] ]

    "Created: / 21-02-2014 / 22:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 22:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containersToFileOut
    | containers |

    containers := OrderedCollection new.
    packages do:[:each | 
        each isVirtual ifFalse: [ 
            containers addAll: ((self containersToFileOutFor: each) collect:[ :container | each repositoryRoot , Filename separator , container ]).
        ] 
    ].
    ^ containers.

    "Created: / 14-05-2009 / 11:35:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-02-2015 / 08:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containersToFileOutFor: package
    | containers extensions |

    containers := (self classesToFileOutFor: package)
		collect: [:class | package containerNameForClass: class ].
    (extensions := (self extensionMethodsToFileOutFor: package)) notEmpty ifTrue:[
	| languages extensionsNonJava extensionsJava |

	extensionsNonJava := extensions reject:[:m | m mclass programmingLanguage isJava].
	extensionsJava := extensions select:[:m | m mclass programmingLanguage isJava].
	languages :=  (extensionsNonJava collect:[:each|each programmingLanguage]) asSet.
	languages do: [:lang| containers add: (package containerNameForExtensions: lang)].
	extensionsJava do:[:m |
	    | container |

	    container := package containerNameForExtensions: m programmingLanguage javaClass: m mclass.
	    (containers includes: container) ifFalse:[
		 containers add: container
	    ].
	].
    ].
    ^ containers

    "Created: / 22-02-2014 / 22:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodsToFileOut
   self error: 'Should no longer be sent'.
    ^ self package extensionsFiltered:
	    [:mth |
	    extensionMethods isNil or: [ extensionMethods includes: mth ] ]

    "Created: / 14-05-2009 / 11:32:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-02-2014 / 22:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodsToFileOutFor: package
    ^package extensionsFiltered:
	    [:mth |
	    extensionMethods isNil or: [ extensionMethods includes: mth ] ]

    "Created: / 21-02-2014 / 23:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 22:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateFile: file for: package 
    | def contents savedClassFilenames |

    def := package definition.
    file ~= 'abbrev.stc' ifTrue:[^def generateFile: file].

    "Yet another kludge to trick Smalltalk>>fileNameForClass:, sigh"
    savedClassFilenames := Dictionary new.
    (def searchForClasses reject:[:e|e owningClass notNil or:[ e isJavaClass ] ] ) do:
        [:cls|
        savedClassFilenames
            at: cls
            put: cls getClassFilename.
        cls setClassFilename: (package containerNameForClass: cls)].
    contents := def generateFile: file.
    savedClassFilenames keysAndValuesDo:
        [:cls :classFileName|
        cls setClassFilename: classFileName].
    ^contents

    "Created: / 20-01-2015 / 08:11:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldFileOutClass: class
    ^ packages anySatisfy:
	[:p | p name = class package and:[ p hasChangesInClass: class ] ]

    "Created: / 24-06-2009 / 19:04:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:54:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-03-2014 / 09:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractFileoutLikeTask methodsFor:'queries'!

isSelectiveFileoutTask
    ^ classes notNil or: [ extensionMethods notNil ]

    "Created: / 14-05-2009 / 13:24:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractFileoutLikeTask class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

