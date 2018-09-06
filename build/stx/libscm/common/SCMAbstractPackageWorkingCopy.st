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

SCMAbstractPackageModel subclass:#SCMAbstractPackageWorkingCopy
	instanceVariableNames:'wc wcroot changed classesHasChanged extensionsHasChanged
		lastSequenceNumber lastSequenceNumberForChildren'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMAbstractPackageWorkingCopy class methodsFor:'documentation'!

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
    A model of a Smalltalk/X package in a checked-out working copy. 
    It knows how to map living classes to their respective file containers 
    and can fileout individual classes. Used (not only) by SCMAbstractCommitTask.

    == Changed packages ==

    A 'changed' package is a package that contain changes, i.e., some method/class
    beloging to a package has been modified or class/method has been added/removed.
    Compared to state of the package at its LOAD TIME, not to last nor compiled 
    revision !!!!!!

    See #hasChanges, #classesHasChanged, #extensionsHasChanged.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SCMAbstractPackageModel

"
! !

!SCMAbstractPackageWorkingCopy class methodsFor:'instance creation'!

named: package
    self subclassResponsibility

    "Created: / 16-11-2012 / 19:52:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SCMAbstractPackageWorkingCopy class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractPackageWorkingCopy

    "Created: / 13-11-2012 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:59:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'accessing'!

abbrevs
    ^ self definition abbrevs

    "Created: / 14-03-2014 / 22:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classes

    ^self classesIncludingPrivate reject:[:cls|cls owningClass notNil]

    "Created: / 06-10-2012 / 23:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesFiltered: classFilter

    ^self classes select: [:class|classFilter value: class].

    "Created: / 06-10-2012 / 23:14:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesIncludingPrivate
    ^ProjectDefinition searchForClassesWithProject: self name

    "Created: / 06-10-2012 / 23:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitDialog
    ^self commitDialogClass new

    "Modified: / 14-11-2012 / 22:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitTask
    ^self commitTaskClass new
        package: self;
        yourself

    "Created: / 06-10-2012 / 22:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 23:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definition
    ^LibraryDefinition definitionClassForPackage:self name createIfAbsent:true

    "Created: / 06-10-2012 / 23:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definitionOrNilIfNotExists
    ^LibraryDefinition definitionClassForPackage:self name createIfAbsent:false

    "Created: / 11-06-2015 / 07:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensions

    ^ProjectDefinition searchForExtensionsWithProject: self name

    "Created: / 06-10-2012 / 23:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionsFiltered:aBlock
    ^self extensions select:aBlock

    "Created: / 06-10-2012 / 23:19:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manager
    "Returns a source code manager for this kind of package"

    ^self subclassResponsibility

    "Created: / 14-11-2012 / 01:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    "Return a logical revision of the package, i.e., a revision
     on which the next commit will be based on"              

    self isVirtual ifTrue:[ 
        | childRevs |

        childRevs := Set new.
        self childrenDo:[:each | childRevs add: each revision ].
        childRevs size == 0 ifTrue:[ 
            self error: 'No non-virtual children'.
            ^ nil.
        ].
        childRevs size ~~ 1 ifTrue:[ 
            self error: 'Inconsistent revisions of chilren of virtual package'.
            ^ nil
        ].
        ^ childRevs anElement
    ] ifFalse:[ 
        ^ self getRevision
    ].

    "Modified: / 28-02-2014 / 09:38:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopy
    self ensureTemporaryWorkingCopy.
    ^wc

    "Created: / 01-12-2012 / 00:26:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopyPath
    "Return the directory which contains temporary working copy.
     The directory may not exists if the temporary working copy has
     not yet been initialized (which is done on demand)"

    ^ self manager temporaryWorkingCopyDirectory / repository uuid printString

    "Created: / 05-02-2013 / 09:30:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopyRoot
    self ensureTemporaryWorkingCopy.
    ^ wcroot

    "Created: / 14-11-2012 / 23:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'accessing-classes'!

commitDialogClass
    self subclassResponsibility

    "Created: / 14-11-2012 / 22:29:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitTaskClass
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!SCMAbstractPackageWorkingCopy methodsFor:'accessing-containers'!

containerFor: aString ifAbsent: aBlock
    "Return a container as Filename with given name. If there's no such
     container, evaluates a block"            

    ^self temporaryWorkingCopyRoot / aString

    "Created: / 14-03-2014 / 22:18:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamFor: containerName
    | filename directory |

    filename := self containerFor: containerName.
    (directory := filename directory) exists ifFalse:[
        directory recursiveMakeDirectory
    ].
    ^filename writeStream
        eolMode: #nl;
        yourself

    "Created: / 09-10-2008 / 20:24:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-03-2014 / 22:56:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamForClass:cls
    ^self containerWriteStreamFor: (self containerNameForClass:cls)

    "Created: / 07-10-2012 / 10:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamForExtensions: aProgrammingLanguage
    ^self containerWriteStreamFor: (self containerNameForExtensions: aProgrammingLanguage)

    "Created: / 30-12-2009 / 18:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2012 / 10:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerWriteStreamForExtensions: aProgrammingLanguage javaClass: aJavaClass
    | container |

    container := self containerFor: (self containerNameForExtensions: aProgrammingLanguage javaClass: aJavaClass).
    container directory exists ifFalse:[
         container directory recursiveMakeDirectory.
    ].
    ^ container writeStream

    "Created: / 04-09-2012 / 23:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2014 / 22:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containers
    | containers jextensions |

    containers := OrderedCollection new.
    containers addAll:
        (wcroot  directoryContents select:
                [:container|self containerSuffixes anySatisfy:
                    [:suffix|container endsWith:suffix]]) asSet.
    (jextensions:= wcroot / 'java' / 'extensions') exists ifTrue:[
        jextensions recursiveDirectoryContentsDo:[:each|
            (self containerSuffixes anySatisfy:[:suffix|each endsWith:suffix]) ifTrue:[
                (jextensions / each) isRegularFile ifTrue:[
                    containers add: 'java/extensions/' , each.
                ].
            ].
        ]
    ].
    ^ containers

    "Created: / 23-03-2009 / 18:52:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-06-2009 / 21:44:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-03-2014 / 23:29:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containersToKeep

    | containers extensions |

    containers := self classes collect:[:cls|self containerNameForClass: cls].
    (extensions := self extensions) notEmpty ifTrue:[
        | languages extensionsNonJava extensionsJava |

        extensionsNonJava := extensions reject:[:m | m mclass programmingLanguage isJava].
        extensionsJava := extensions select:[:m | m mclass programmingLanguage isJava].
        languages :=  (extensionsNonJava collect:[:each|each programmingLanguage]) asSet.
        languages do: [:lang| containers add: (self containerNameForExtensions: lang)].
        extensionsJava do:[:m |
            | container |

            container := self containerNameForExtensions: m programmingLanguage javaClass: m mclass.
            (containers includes: container) ifFalse:[
                 containers add: container
            ].
        ].
    ].

    "Keep all directories"
    wcroot directoryContents do: [:f|
        (f ~= '.hg' and: [(wcroot / f) isDirectory]) ifTrue:[
            containers add: f
        ].
    ].
    "Keep all .st files that are for with other operating systems"

    self definition classNamesAndAttributesDo: [:nm :attributes|
        attributes do:[:attr|
            (#(win32 unix vms autoload) includes: attr) ifTrue:[
                containers add: (self containerNameForClassNamed: nm language: SmalltalkLanguage instance)
            ]
        ]
    ].


    ^containers asSet.

    "Created: / 12-06-2009 / 21:27:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-09-2013 / 12:32:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'accessing-hierarchy'!

children
    "Returns all my immediate children."

    self updateCachedValues.
    ^ children values.

    "
    (HGPackageModelRegistry packageNamed: 'stx:libscm') children
    "

    "Created: / 19-02-2014 / 23:43:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2014 / 23:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'accessing-private'!

childNamed: aString
    "Returns a child name aString. If no such child
     exist, create one"

    | child nm|

    children at: aString ifPresent:[:child|^child].
    child := self class new.
    nm := (name includes: $:)
        ifTrue: [name , '/' , aString]
        ifFalse:[name , ':' , aString].
    child setName: nm repository: repository.
    child setParent: self.
    children at: aString put: child.
    ^child

    "Created: / 01-12-2012 / 01:29:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 18:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getRevision
    "Return a logical revision of the package, i.e., a revision
     on which the next commit will be based on"              

    ^ self subclassResponsibility

    "Created: / 28-02-2014 / 09:33:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'file out'!

fileOutClass:cls

    |stream|

    stream := self containerWriteStreamForClass:cls.
    [
        self fileOutClass:cls on:stream
    ] ensure:[
        stream close
    ]

    "Modified: / 11-06-2009 / 16:18:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 19:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2013 / 19:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 30-07-2014 / 20:49:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutClass:cls on:clsStream

"/    cls methodDictionary do:
"/        [:each|each makeLocalStringSource].
"/
"/    cls class methodDictionary do:
"/        [:each|each makeLocalStringSource].

    self manager
                fileOutSourceCodeOf:cls
                                 on:clsStream
                      withTimeStamp:false
                     withInitialize:true
                     withDefinition:true
                       methodFilter:[:mth | mth package = name ]

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
    "Modified: / 14-11-2012 / 01:01:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods

    ^self fileOutExtensions: extensionMethods in: self temporaryWorkingCopyRoot

    "Created: / 30-12-2009 / 19:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 00:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        mthd mclass theNonMetaclass isJavaClass ifTrue:[
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
    "Modified: / 15-12-2012 / 17:50:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: extensionMethods on:stream language: language

    extensionMethods do:[:each|each makeLocalStringSource].

    "Special hack for Smalltalk - use SourceCodeManager routine"
    (language isSmalltalk and:[extensionMethods allSatisfy:[:m|m mclass theNonMetaclass isJavaClass not]]) ifTrue:[
        self manager fileOutSourceCodeExtensions: extensionMethods package: self name on: stream.
        ^self.
    ].

    "/ Generic fileout "

    language sourceFileWriterClass new
        fileOutPackageDefinition: self name on: stream;
        fileOutMethods: extensionMethods on: stream

    "Modified: / 15-06-2009 / 11:55:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 19:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 13:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'initialization'!

initialize
    super initialize.
    children := Dictionary new

    "Created: / 07-03-2014 / 12:57:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setName: aSymbolOrPackageId repository: aRepository
    "Initializes the package. This method also MUST initialize 'repositoryRoot' instvar!!"

    ^self subclassResponsibility

    "Created: / 01-12-2012 / 17:52:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNameComponents: aCollection repository: aRepository

    | nm |
    aCollection isEmpty ifTrue:[
        self setName:'' repository: aRepository.
        ^self.
    ].
    aCollection size == 1 ifTrue:[
        self setName: aCollection first repository: aRepository.
        ^self.
    ].
    nm := aCollection first , ':' , aCollection second.
    aCollection size > 2 ifTrue:[
        3 to: aCollection size do:[:i|
            nm := nm , '/' , (aCollection at: i)
        ].
    ].
    self setName: nm repository: aRepository.
    ^self

    "Created: / 03-12-2012 / 12:36:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent: parentModel
    "Sets the parent model. See class documentation for details on parents models"

    parent := parentModel.
    (parent repositoryRoot = '.') ifTrue:[
        repositoryRoot := (self name copyFrom: parent name size + 2).
    ] ifFalse:[
        repositoryRoot := parent repositoryRoot , '/' , (self name copyFrom: parent name size + 2) .
    ]

    "Created: / 01-12-2012 / 17:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2014 / 10:04:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setWorkingCopy: aSCMAbstractWorkingCopy
    wc := aSCMAbstractWorkingCopy.
    wcroot := wc root / self repositoryRoot

    "Created: / 01-12-2012 / 17:53:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'private'!

commited
    "Sent by commit task once commited"

    extensionsHasChanged := false.
    classesHasChanged := false.

    "Created: / 13-08-2009 / 10:23:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-11-2012 / 10:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-11-2012 / 22:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeChildren
    | newChildren newChildNames nameSizePlus1 |

    nameSizePlus1 := name size + 1.
    newChildNames := Smalltalk allLoadedPackageIDs select:[:each |
        (each startsWith: name)
        and:[ each ~= name
        and:[ ((each at: nameSizePlus1) == $/ or:[ (each at: nameSizePlus1) == $: ])
        and:[ (each indexOf: $/ startingAt: nameSizePlus1 + 1) == 0]]]].
    newChildren := Dictionary new.
    newChildNames do:[:each |
        | nm |
        nm := (each copyFrom: nameSizePlus1 + 1).
        newChildren at: nm put: (self childNamed: nm).
    ].
    ^ newChildren.

    "
    (HGPackageModelRegistry packageNamed: 'stx:libscm') children
    "

    "Created: / 28-02-2014 / 23:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2016 / 21:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeClassesHasChanged
    "
        Answers true iff package classes differs from
        those listed in ProjectDefinition>>classNamesAndAttributes"

    | listedClasses realClasses pkgDef |

    (pkgDef := self definitionOrNilIfNotExists) isNil ifTrue:[^true].

    listedClasses :=    pkgDef compiled_classNames_common ,
                        pkgDef compiled_classNamesForPlatform ,
                        pkgDef autoloaded_classNames.

    realClasses := self classes collect:[:cls | cls fullName ].
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

    "Created: / 06-10-2012 / 23:17:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2015 / 07:01:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeExtensionsHasChanged
    "
        Answers true iff package extension method differs from
        those listed in ProjectDefinition>>extensionMethodNames"

    | listedExtensions listedExtensionsDictionary realExtensions |

    realExtensions := self  extensions.
    listedExtensions := self definition
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

    "Created: / 06-10-2012 / 23:17:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-03-2013 / 10:12:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeHasChanges

    classesHasChanged == true ifTrue:[
        ^ true.    
    ].

    extensionsHasChanged == true ifTrue:[
        ^ true.    
    ].

    self classes do:[:class | 
        (self hasChangesInClass: class) ifTrue:[ 
            ^ true.    
        ].
    ].
    self extensions do:[:each |  
        (self hasChangesInMethod: each) ifTrue:[
            ^ true.
        ]
    ].
    ^ false.

    "Created: / 03-03-2014 / 09:08:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeIsVirtual
    ^ self classes isEmpty and:[ self extensions isEmpty ].

    "Created: / 28-02-2014 / 23:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-03-2014 / 23:21:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCachedValues
    "Update all cached data"

    | sequenceNumber |

    sequenceNumber := SCMCodeMonitor sequenceNumber.     
    sequenceNumber ~~ lastSequenceNumber ifTrue:[ 
        lastSequenceNumber := sequenceNumber.
        virtual := self computeIsVirtual.
        virtual ifTrue:[
            classesHasChanged := false.
            extensionsHasChanged := false.
            changed := false.
        ] ifFalse:[ 
            classesHasChanged := (classesHasChanged == true) or:[ self computeClassesHasChanged ].
            extensionsHasChanged := (extensionsHasChanged == true) or:[ self computeExtensionsHasChanged ].
            changed := self computeHasChanges.
        ].
        children := self computeChildren.
    ].

    "Created: / 28-02-2014 / 23:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2014 / 22:44:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'queries'!

classesHasChanged
    "Return true, if list of classes has changed, i.e., a class
     was added, removed or renamed. False otherwise"

    self updateCachedValues.
    ^ classesHasChanged

    "Created: / 06-10-2012 / 23:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2014 / 23:51:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-03-2014 / 09:06:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionsHasChanged
    "Return true, if list of extensions has changed, i.e., a method
     was added, removed or renamed. False otherwise"

    self updateCachedValues.
    ^ extensionsHasChanged

    "Created: / 06-10-2012 / 23:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2014 / 23:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-03-2014 / 09:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasChanges

    self updateCachedValues.
    ^ changed

    "Created: / 03-03-2014 / 00:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2014 / 09:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasChangesInClass: class
    "Return true, if there's a change in given class, false otherwise"

    "/ Class which is not loaded could not be changed
    class isLoaded ifFalse:[^false].

    "/ Java classes that has been modified in St/X IDE have
    "/ its source string set, those loaded from pre-compiled
    "/ .class file has sourceString nil.
    class isJavaClass ifTrue:[ 
        ^ class sourceString notNil
    ].

    "/ class has been filed in...
    class binaryRevisionString isNil ifTrue:[ 
        ^ true.
    ].

    class withAllPrivateClassesDo:[:each |
        (ChangeSet current includesChangeForClass:each) ifTrue:[ ^ true ].
    ].
    class withAllPrivateClassesDo:[:each |
        each theNonMetaclass
            methodsDo:[:mth|(self hasChangesInMethod: mth) ifTrue:[^ true]].
        each theMetaclass
            methodsDo:[:mth|(self hasChangesInMethod: mth) ifTrue:[^ true]].
    ].
    ^false

    "Created: / 03-03-2014 / 09:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-04-2015 / 14:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasChangesInMethod: method
    "Return true, if the method's code has been edited, false otherwise"

    ^ method package = name 
        "/ This is not strictly true, for byte-code compiled method
        "/ sourcePosition is also non-nil...
        and:[ method getSourcePosition isNil ]

    "Created: / 03-03-2014 / 09:13:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'testing'!

isVirtual
    "Return true, if the package is virtual, i.e., there's no code in
     the package. False otherwise.

     Virtual packages serves merely as containers for nested packages"

    self updateCachedValues.
    ^ virtual

    "
    (HGPackageModel named: 'stx:libscm') isVirtual
    (HGPackageModel named: 'stx:libscm/mercurial') isVirtual
    "

    "Created: / 27-02-2014 / 22:46:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2014 / 23:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopy methodsFor:'utilities'!

, anotherPackageModel
    ^ SCMCommonPackageModelGroup 
        with: self
        with: anotherPackageModel

    "Created: / 26-02-2014 / 22:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureTemporaryWorkingCopy
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!SCMAbstractPackageWorkingCopy class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

