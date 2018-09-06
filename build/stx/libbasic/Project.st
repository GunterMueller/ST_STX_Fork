"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Project
	instanceVariableNames:'name changeSet views directoryName properties packageName
		repositoryDirectory repositoryModule isLoaded'
	classVariableNames:'CurrentProject SystemProject NextSequential AllProjects'
	poolDictionaries:''
	category:'System-Support'
!

Object subclass:#ClassInfo
	instanceVariableNames:'conditionForInclusion className classFileName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Project
!

Object subclass:#MethodInfo
	instanceVariableNames:'conditionForInclusion methodName className fileName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Project
!

!Project class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    WARNING:
        This class is almost completely obsolete 
        (before even being finished)

    Most references to this class are being removed, and we are only
    looking at PackageId and ProjectDefinition in the future.
    Please ignore everything regarding to packaging and building below.
    Project instance(s) are still used to keep a reference to the current changeSet,
    but even that may move to a projectDefinition in the future.

    All this class does is to keep track of per-project views 
    (to hide or show them), define the directory when filing-out,
    and define packageNames for new classes and methods.

    instance variables:
        name            <String>        the name of this project, as shown
                                        in a ProjectView

        changeSet       <ChangeSet>     changes done, while this was the active project

        views           <Collection>    views opened while this was the active project

        directoryName   <String>        directory name, where fileOuts are done

        properties 

        packageName     <String>        given to classes/methods which are created while
                                        this is the active project

        repositoryDirectory             (default) name of the repository, when a new source containers are
                                        created.

        repositoryModule                (default) name of the module, when new source containers are
                                        created.

    Future: 
        - keep track of per-project changes
        - allow speficiation of the type of the project (application or library)
        - allow building of whatever the target (as defined by the type) is
          (this will allow build of class libs and apps by clicking a button)
        - allow removal of project specific classes, methods etc.

    [author:]
        Claus Gittinger
"
! !

!Project class methodsFor:'initialization'!

initKnownProjects
    "this is a temporary experimental kludge"

    AllProjects isNil ifTrue:[
        AllProjects := IdentitySet new.
    ].

    AllProjects add:SystemProject.
    AllProjects add:CurrentProject.

    "
     AllProjects := nil.
     self initKnownProjects
    "

    "Modified: / 17-08-2006 / 14:08:47 / cg"
!

initialize
    SystemProject isNil ifTrue:[
        self initializeSystemProject.
    ].

    CurrentProject := SystemProject.
    AllProjects := nil.
    self initKnownProjects.

    "
     SystemProject := nil.
     Project initialize
    "
!

initializeSystemProject
    NextSequential := 1.
    SystemProject := self new name:'default'.
    SystemProject package:(PackageId noProjectID).
    SystemProject defaultNameSpace:Smalltalk.

    ChangeSet notNil ifTrue:[
        SystemProject changeSet:ChangeSet new
    ].
    self changed:#defaultProject

    "Modified: / 17-08-2006 / 16:39:25 / cg"
!

reinitKnownProjects
    "rescan the image for projects"

    AllProjects := nil.
    self initKnownProjects
! !

!Project class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Project class methodsFor:'accessing'!

addKnownProject:aProject
    |allProjects|

    allProjects := self knownProjects.
    (allProjects contains:[:p | p package = aProject package])  ifTrue:[
        self warn:'Project for ' , aProject package , ' is already present.'.
        ^ self.
    ].

    AllProjects add:aProject.
    self changed:#allProjects
!

addLoadedProject:aProject
    aProject isLoaded:true.
    self addKnownProject:aProject.
!

current
    "return the currently active project"

    CurrentProject isNil ifTrue:[CurrentProject := SystemProject ].
    ^ CurrentProject

    "
     Project current
    "
!

current:aProject
    "set the currently active project"

    |prevProject|

    prevProject := CurrentProject.
    CurrentProject := aProject.
    prevProject notNil ifTrue:[
        self changed:#currentProject
    ].
!

currentPackageName
    CurrentProject notNil ifTrue:[
	^ CurrentProject package
    ].
    ^ nil

    "
     Project currentPackageName
    "
!

defaultNameSpace
    "return the default namespace, where new classes are installed,
     if NO special nameSpace handler is present"

    |p|

    (p := Project current) notNil ifTrue:[
        ^ p defaultNameSpace
    ].

    ^ Smalltalk

    "Created: / 17-08-2006 / 14:01:02 / cg"
!

defaultProject
    "return the SystemDefault project"

    ^ SystemProject.

    "
     Project defaultProject package
    "
!

knownProjects
    AllProjects isNil ifTrue:[
	self initKnownProjects
    ].
    ^ AllProjects ? #()
!

loadedProjects
    ^ self knownProjects select:[:p | p isLoaded]
!

noProjectID
    <resource: #obsolete>

    self obsoleteMethodWarning:'Please use PackageId noProjectID'.
    ^ PackageId noProjectID
!

projectNamed:aProjectName
    "retrieve the named project; return nil if not known"

    ^ self knownProjects detect:[:p | p name = aProjectName] ifNone:nil.

    "
     Project projectNamed:'stx'
     Project projectNamed:'default'
    "
!

projectWithId:aPackageId
    "retrieve the project with a particular id; return nil if not known"

    ^ self knownProjects detect:[:p | p package = aPackageId] ifNone:nil.

    "
     Project projectWithId:#'stx:libbasic'
     Project projectWithId:'__NoProject__'
    "
!

setDefaultProject
    "set the currently active project to be the SystemDEfault project"

    self current:SystemProject.
!

setProject:aProjectOrNil
    "set the currently active project without updating others"

    CurrentProject := aProjectOrNil.

    "Created: 7.2.1996 / 14:00:45 / cg"
    "Modified: 7.2.1996 / 14:01:16 / cg"
! !

!Project class methodsFor:'changes management'!

addClassCommentChangeFor:aClass
    "add a comment-change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addClassCommentChangeFor:aClass 
    ]
!

addClassDefinitionChangeFor:aClass
    "add a class-def-change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addClassDefinitionChangeFor:aClass 
    ]

    "Created: 3.12.1995 / 13:44:58 / cg"
    "Modified: 3.12.1995 / 13:58:04 / cg"
!

addClassRemoveChange:oldClass
    "add a class-remove-change to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addClassRemoveChange:oldClass
    ]
!

addClassRenameChangeFrom:oldName to:newName
    "add a class-rename-change to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addClassRenameChangeFrom:oldName to:newName 
    ]
!

addDoIt:aString
    "add a doIt to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addDoIt:aString 
    ]

    "Created: 3.12.1995 / 13:44:58 / cg"
    "Modified: 3.12.1995 / 13:58:04 / cg"
!

addInstVarDefinitionChangeFor:aClass
    "add an instvar-change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addInstVarDefinitionChangeFor:aClass 
    ]

    "Created: 3.12.1995 / 13:44:58 / cg"
    "Modified: 3.12.1995 / 13:58:04 / cg"
!

addMethodCategoryChange:aMethod category:newCategory in:aClass
    "add a method-category-change for aMethod in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addMethodCategoryChange:aMethod category:newCategory in:aClass 
    ]
!

addMethodChange:aMethod fromOld:oldMethod in:aClass
    "add a method change in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addMethodChange:aMethod fromOld:oldMethod in:aClass 
    ].
!

addMethodChange:aMethod in:aClass
    "add a method change in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addMethodChange:aMethod in:aClass 
    ].
!

addMethodPackageChange:aMethod package:newPackage in:aClass
    "add a method-package-change for aMethod in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addMethodPackageChange:aMethod package:newPackage in:aClass 
    ]

    "Created: / 09-10-2006 / 13:50:30 / cg"
!

addMethodPrivacyChange:aMethod in:aClass
    "add a privacy change for aMethod in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addMethodPrivacyChange:aMethod in:aClass 
    ]

    "Modified: 27.8.1995 / 22:48:17 / claus"
!

addPrimitiveDefinitionsChangeFor:aClass
    "add a primitiveDef change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addPrimitiveDefinitionsChangeFor:aClass 
    ]
!

addPrimitiveFunctionsChangeFor:aClass
    "add a primitiveFuncs change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addPrimitiveFunctionsChangeFor:aClass 
    ]
!

addPrimitiveVariablesChangeFor:aClass
    "add a primitiveVars change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addPrimitiveVariablesChangeFor:aClass 
    ]
!

addRemoveSelectorChange:aSelector fromOld:oldMethod in:aClass
    "add a method-remove change in aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addRemoveSelectorChange:aSelector fromOld:oldMethod in:aClass 
    ]

    "Created: / 16.2.1998 / 12:45:10 / cg"
!

addRenameCategoryChangeIn:aClass from:oldCategory to:newCategory
    "add a category rename change for aClass to the current project"

    |p|

    p := CurrentProject.
    p notNil ifTrue:[
        p addRenameCategoryChangeIn:aClass from:oldCategory to:newCategory 
    ]

    "Created: / 6.2.2000 / 02:27:35 / cg"
!

currentProjectDirectory
    "return the name of the directory to use for fileOut.
     The returned name already includes a file-separator at the end, 
     so the filename can be concatenated to it."

    |p dirName|

    p := CurrentProject.
    p notNil ifTrue:[
	dirName := p directory  
    ] ifFalse:[
	dirName := Filename currentDirectory name
    ].
    ^ dirName

    "Modified: 7.9.1997 / 23:52:25 / cg"
! !

!Project methodsFor:'accessing'!

changeSet
    "return the set of changes made in this project"

    changeSet isNil ifTrue:[
        "/
        "/ for tiny-configurations, allow ChangeSet to be absent
        "/
        ChangeSet notNil ifTrue:[
            changeSet := ChangeSet new.
        ].
    ].

    ^ changeSet

    "Modified: 27.1.1997 / 11:58:36 / cg"
!

changeSet:aChangeSet
    "set the set of changes made in this project - dangerous, you may loose
     the actual changeSet."

    changeSet := aChangeSet

    "Modified: 27.1.1997 / 11:59:02 / cg"
!

changedClasses
    ^ self changeSet changedClasses

    "
     Project current changedClasses
    "

    "Modified: / 17-08-2006 / 12:46:35 / cg"
!

defaultNameSpace
    "return the defaultNameSpace of this project.
     New classes will (if not specified by a directive) be installed
     in this nameSpace. Useful, when filing in ST-80 code, to avoid
     overwriting of standard classes."

    ^ (self propertyAt:#defaultNameSpace) ? Smalltalk

!

defaultNameSpace:aNamespace
    "set the defaultNameSpace of this project.
     New classes will (if not specified by a directive) be installed
     in this nameSpace. Useful, when filing in ST-80 code, to avoid
     overwriting of standard classes."

    |prevDefault|

    prevDefault := self defaultNameSpace.
    aNamespace ~~ prevDefault ifTrue:[
        self propertyAt:#defaultNameSpace put:aNamespace.
        self changed:#defaultNameSpace.
        self == CurrentProject ifTrue:[
            self class changed:#defaultNameSpace 
        ]
    ]

    "Created: 2.1.1997 / 19:54:37 / cg"
    "Modified: 27.1.1997 / 12:00:01 / cg"
!

directory
    "return the projects directory.
     If not specified, a fileOut will be done into that directory"

    directoryName isNil ifTrue:[^ '.'].
    ^ directoryName

    "Modified: 27.1.1997 / 12:00:41 / cg"
!

directory:aDirectoryName
    "set the projects directory.
     If not specified, a fileOut will be done into that directory"

    directoryName := aDirectoryName.
    self changed:#directory.
    self == CurrentProject ifTrue:[
        self class changed:#directory 
    ]

    "Modified: 27.1.1997 / 12:00:47 / cg"
!

isLoaded:aBoolean
    isLoaded := aBoolean
!

libraryName
    "return the projects library name.
     This is the name of a classLibrary, created from this project"

    ^ self name asPackageId libraryName.

    "Modified: / 18-08-2006 / 17:14:52 / cg"
!

name
    "return the projects name.
     This is for the user only - shown in the projectViews label"

    ^ name

    "Modified: 27.1.1997 / 12:01:16 / cg"
!

name:aString
    "set the projects name.
     This is for the user only - shown in the projectViews label"

    name := aString.
    self changed:#name.
    self == CurrentProject ifTrue:[
        self class changed:#name
    ]

    "Modified: 27.1.1997 / 12:01:09 / cg"
!

package
    "return the projects package identifier.
     This identifier marks all methods and new classes which are created
     in this project."

    ^ packageName

    "Modified: 27.1.1997 / 12:10:00 / cg"
!

package:aPackageId
    "set the projects package identifier.
     This identifier marks all methods and new classes which are created
     in this project."

    packageName := aPackageId

    "Modified: 27.1.1997 / 12:10:00 / cg"
!

repositoryDirectory
    "return the projects default repository location.
     This is offered initially, when classes are checked into the
     source repository initially"

    ^ repositoryDirectory

    "Created: 25.11.1995 / 18:04:51 / cg"
    "Modified: 27.1.1997 / 12:13:35 / cg"
!

repositoryDirectory:aRelativePathName
    "set the projects default repository location.
     This will be offered initially, when classes are checked into the
     source repository initially"

    repositoryDirectory := aRelativePathName

    "Created: 25.11.1995 / 18:05:06 / cg"
    "Modified: 27.1.1997 / 12:13:28 / cg"
!

repositoryModule
    "return the projects default repository module name.
     This is offered initially, when classes are checked into the
     source repository initially"

    ^ repositoryModule

    "Created: 25.11.1995 / 18:04:51 / cg"
    "Modified: 27.1.1997 / 12:13:50 / cg"
!

repositoryModule:aString
    "set the projects default repository module name.
     This is offered initially, when classes are checked into the
     source repository initially"

    repositoryModule := aString

    "Created: 25.11.1995 / 18:05:06 / cg"
    "Modified: 27.1.1997 / 12:13:57 / cg"
!

views
    "return a collection of views which were opened in this project"

    ^ views asArray

    "Modified: 27.1.1997 / 12:14:18 / cg"
!

views:aSetOfViews
    "set the collection of views which were opened in this project"

    views := WeakIdentitySet withAll:aSetOfViews

    "Modified: 27.1.1997 / 12:14:26 / cg"
! !

!Project methodsFor:'administration'!

removeClassesFromSystem
    "remove the all of my classes & patches from the system"

    self classInfo do:[:clsInfo |
        |clsName cls|

        clsName := clsInfo className.
        clsName isSymbol ifTrue:[
            cls := Smalltalk at:clsName.
            cls notNil ifTrue:[
                cls removeFromSystem.
            ].
        ] ifFalse:[
            self error:'non-symbol class name' mayProceed:true.
        ].
    ].
!

removeFromSystem
    "remove the project and all of its classes & patches from the system"

    self removeClassesFromSystem.
    AllProjects remove:self ifAbsent:nil.
! !

!Project methodsFor:'changes'!

addClassCommentChangeFor:aClass
    "add a comment-change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addClassCommentChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:04 / cg"
!

addClassDefinitionChangeFor:aClass
    "add a class-def-change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addClassDefinitionChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:07 / cg"
!

addClassRemoveChange:oldClass
    "add a class-remove-change to the current project"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addClassRemoveChange:oldClass
    ].
!

addClassRenameChangeFrom:oldName to:newName
    "add a class-rename-change to the current project"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addClassRenameChangeFrom:oldName to:newName 
    ].

    "Modified: / 17-08-2006 / 11:20:12 / cg"
!

addDoIt:aString
    "add a doIt to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addDoIt:aString 
    ].
!

addInstVarDefinitionChangeFor:aClass
    "add an instvar-definition-change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addInstVarDefinitionChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:15 / cg"
!

addMethodCategoryChange:aMethod category:newCategory in:aClass
    "add a method-category-change for aMethod in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addMethodCategoryChange:aMethod category:newCategory in:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:17 / cg"
!

addMethodChange:aMethod fromOld:oldMethod in:aClass
    "add a method change in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addMethodChange:aMethod fromOld:oldMethod in:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:20 / cg"
!

addMethodChange:aMethod in:aClass
    "add a method change in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addMethodChange:aMethod in:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:23 / cg"
!

addMethodPackageChange:aMethod package:newPackage in:aClass
    "add a method-package-change for aMethod in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addMethodPackageChange:aMethod package:newPackage in:aClass 
    ].

    "Created: / 09-10-2006 / 13:48:55 / cg"
!

addMethodPrivacyChange:aMethod in:aClass
    "add a privacy change for aMethod in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addMethodPrivacyChange:aMethod in:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:26 / cg"
!

addPrimitiveDefinitionsChangeFor:aClass
    "add a primitiveDef change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addPrimitiveDefinitionsChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:29 / cg"
!

addPrimitiveFunctionsChangeFor:aClass
    "add a primitiveFuncs change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addPrimitiveFunctionsChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:32 / cg"
!

addPrimitiveVariablesChangeFor:aClass
    "add a primitiveVars change for aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addPrimitiveVariablesChangeFor:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:35 / cg"
!

addRemoveSelectorChange:aSelector fromOld:oldMethod in:aClass
    "add a method-remove change in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addRemoveSelectorChange:aSelector fromOld:oldMethod in:aClass 
    ].

    "Modified: / 17-08-2006 / 11:20:39 / cg"
!

addRenameCategoryChangeIn:aClass from:oldCategory to:newCategory
    "add a category rename change in aClass to the receiver's changeSet"

    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet addRenameCategoryChangeIn:aClass from:oldCategory to:newCategory 
    ].

    "Created: / 06-02-2000 / 02:28:07 / cg"
    "Modified: / 17-08-2006 / 11:20:37 / cg"
!

condenseChangesForClassCheckin:aClass
    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet condenseChangesForClass:aClass package:aClass package
    ].

    "Modified: / 5.11.2001 / 16:24:18 / cg"
!

condenseChangesForExtensionsCheckInInPackage:package
    |changeSet|

    (changeSet := self changeSet) notNil ifTrue:[
        changeSet condenseChangesForExtensionsInPackage:package
    ].

    "Created: / 5.11.2001 / 17:07:45 / cg"
! !

!Project methodsFor:'initialization'!

initialize
    |numString|

    views := WeakIdentitySet new.
    numString := NextSequential printString.
    NextSequential := NextSequential + 1.

    name := 'new Project-' , numString.
    packageName := 'private-' , numString.

    self directory:'.'.
    self repositoryModule:(UserPreferences current usersModuleName "OperatingSystem getLoginName").
    self repositoryDirectory:'private'

    "Created: 25.11.1995 / 18:05:44 / cg"
    "Modified: 3.1.1997 / 13:24:10 / cg"
! !

!Project methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(;
        nextPutAll:(name ? '<unnamed>');
        nextPut:$).
! !

!Project methodsFor:'properties'!

addClass:classOrClassName
    "add a class to the project"

    |fn|

    (classOrClassName isBehavior and:[classOrClassName isLoaded]) ifTrue:[
        fn := classOrClassName classFilename.
    ].
    self addClass:classOrClassName classFileName:fn
!

addClass:classOrClassName classFileName:fileName
    "add a class to the project"

    self
	addClass:classOrClassName 
	conditionForInclusion:#always 
	classFileName:fileName

!

addClass:classOrClassName conditionForInclusion:conditionBlock classFileName:fileName
    "add a class to the project"

    |i clsName|

    (clsName := classOrClassName) isBehavior ifTrue:[
        clsName := classOrClassName name
    ].
    clsName := clsName withoutPrefix:'Smalltalk::'.

    i := ClassInfo new.
    i className:clsName.
    i classFileName:fileName.
    i conditionForInclusion:conditionBlock.
    self addClassInfo:i
!

addClassInfo:newInfo
    "add a class info to the project"

    |infoCollection index|

    (infoCollection := self classInfo) isNil ifTrue:[
        self classInfo:(infoCollection := OrderedCollection new).
    ].

    index := infoCollection findFirst:[:i | |nm1 nm2|
                                        nm1 := i className.
                                        nm2 := newInfo className.
                                        nm1 = nm2
                                      ].
    index ~~ 0 ifTrue:[
        infoCollection at:index put:newInfo
    ] ifFalse:[
        infoCollection add:newInfo
    ]
!

classInfo:aClassInfoCollection
    "set the class info of the project"

    self propertyAt:#classInfo put:aClassInfoCollection

!

properties
    "return the property dictionary"

    ^ properties
!

properties:p
    "set the property dictionary"

    properties := p
!

propertyAt:aKey
    "return a property; the key is a symbol"

    properties isNil ifTrue:[^ nil].
    ^ properties at:aKey ifAbsent:nil.
!

propertyAt:aKey put:aValue
    "set a property; the key is a symbol"

    |oldValue|

    oldValue := self propertyAt:aKey.

    properties isNil ifTrue:[
	properties := IdentityDictionary new
    ].
    properties at:aKey put:aValue.

    oldValue ~~ aValue ifTrue:[
	self changed:aKey.
    ].

    "Created: / 23.3.1999 / 14:21:11 / cg"
! !

!Project methodsFor:'queries'!

areAllClassesLoaded
    "return true, if all classes of the package are loaded
     (i.e. there are no autoloaded stubs present)"

    |classes|

    classes := self classes.
    classes isEmptyOrNil ifTrue:[^ isLoaded ? false].

    classes do:[:aClass |
        aClass isBehavior ifFalse:[^ false].
        aClass isLoaded ifFalse:[^ false].
    ].
    ^ true
!

classInfo
    "return a classInfo collection of classes belonging to that project"

    |classInfo classes|

    properties notNil ifTrue:[
        classInfo := properties at:#classInfo ifAbsent:nil.
        classInfo notNil ifTrue:[^ classInfo].
    ].

    classes := self classes.
    classes isEmptyOrNil ifTrue:[
        classInfo := OrderedCollection new
    ] ifFalse:[
        classInfo := classes 
                        collect:[:class |
                            |i|

                            i := ClassInfo new.
                            i conditionForInclusion:#always.
                            i className:class name.
                            i classFileName:(class classBaseFilename).
                            i
                        ] as:OrderedCollection.
    ].
    self propertyAt:#classInfo put:classInfo.
    ^ classInfo

    "Modified: / 12-10-2006 / 15:51:42 / cg"
!

classInfoFor:aClassOrClassName
    "return a classInfo for a particular class"

    |classInfo clsName|

    (classInfo := self classInfo) isNil ifTrue:[^ nil].
    (clsName := aClassOrClassName) isBehavior ifTrue:[
        clsName := aClassOrClassName name
    ].
    ^ classInfo detect:[:i | i className = clsName] ifNone:nil.


    "Modified: 4.1.1997 / 16:51:18 / cg"
!

classes
    "return a collection of classes belonging to that project.
     This excludes any private classes."

    |classes classInfo|

    properties notNil ifTrue:[
        classInfo := properties at:#classInfo ifAbsent:nil.
        classInfo notNil ifTrue:[
            classes := classInfo collect:[:i | i className]
        ] ifFalse:[
            classes := properties at:#classes ifAbsent:nil
        ]
    ].

    (properties isNil
    or:[properties at:#autoIncludeImageClasses ifAbsent:true])
    ifTrue:[
        classes isNil ifTrue:[
            classes := Smalltalk 
                allClassesForWhich:
                    [:aClass |
                        (true "aClass owningClass isNil"
                        and:[aClass isMeta not
                        and:[aClass package = packageName
                        and:[aClass isRealNameSpace not]]])
                    ].
        ].
    ].
    ^ classes ? #()

    "Modified: / 10-11-2006 / 17:12:21 / cg"
!

includesClass:aClassOrClassName
    "return true, if a class is contained in the project"

    |infoCollection index className|

    (infoCollection := self classInfo) isNil ifTrue:[^ false].

    aClassOrClassName isBehavior ifTrue:[
        className := aClassOrClassName name
    ] ifFalse:[
        className := aClassOrClassName
    ].

    index := infoCollection findFirst:[:i | |nm1 nm2|
                                        i className = className
                                      ].
    ^ index ~~ 0 
!

includesMethod:aMethod
    "return true, if the given method is contained in the project
     (either as patch/extension or as class"

    |who methodClass|

    who := aMethod who.
    who isNil ifTrue:[^ false].
    methodClass := who methodClass.
    (self includesClass:methodClass) ifTrue:[^ true].
    ^ self includesMethodPatch:aMethod
!

includesMethodPatch:aMethod
    "return true, if the given method is contained in the project
     as patch/extension"

    |who methodClass methodClassName methodSelector infoCollection index|

    who := aMethod who.
    who isNil ifTrue:[^ false].
    methodClass := who methodClass.
    methodClassName := methodClass name.
    methodSelector := who methodSelector.

    infoCollection := self methodInfo.

    index := infoCollection findFirst:[:i | 
                        (i className = methodClassName 
                        and:[i methodName = methodSelector])
             ].
    ^ index ~~ 0 
!

isDefaultProject
    ^ self == self class defaultProject
!

isLoaded
    "return true, if all of this project-package has been loaded
     into the system"

    |cls|

    isLoaded == true ifTrue:[^ isLoaded].

    "/ check for loaded class-library - assume loaded if present.
    (ObjectMemory binaryModuleInfo contains:[:i | i package = self package]) ifTrue:[
        isLoaded := true.
        ^ true
    ].

    "/ check for all classes ...
    self classes do:[:aClassOrClassName |
        aClassOrClassName isString ifTrue:[
            (cls := Smalltalk at:aClassOrClassName asSymbol) isNil ifTrue:[
                ^ false
            ].
            cls isBehavior ifFalse:[^ false].
            cls isLoaded ifFalse:[^ false].
        ] ifFalse:[
            aClassOrClassName isBehavior ifFalse:[
                self error:'class is neither a string or a behavior' mayProceed:true.
                ^ false
            ].
        ]
    ].

    "/ check for all patches & extensions ...
    (self methods contains:[:aMethodInfo | aMethodInfo theMethod isNil]) ifTrue:[^ false].

    isLoaded := true.
    ^ true

    "
     (Project projectWithId:#'stx:libbasic') isLoaded
     (Project projectWithId:#'stx:goodies/persistency') isLoaded 
    "

    "Modified: / 12-10-2006 / 20:11:04 / cg"
!

methodInfo
    "return a methodInfo collection of methods belonging to that project"

    |methodInfo methods|

    properties notNil ifTrue:[
        methodInfo := properties at:#methodInfo ifAbsent:nil.
        methodInfo notNil ifTrue:[^ methodInfo].
    ].

    methods := self methods.
    methods isEmptyOrNil ifTrue:[
        methodInfo := OrderedCollection new
    ] ifFalse:[
        methodInfo := methods 
                        collect:[:mthd |
                            |i|

                            mthd isMethod ifTrue:[   
                                i := MethodInfo new.
                                i setupFromMethod:mthd.
                                i conditionForInclusion:#always.
                                i
                            ] ifFalse:[
                                mthd "/ already a methodInfo
                            ]
                        ] as:OrderedCollection.
    ].
    self propertyAt:#methodInfo put:methodInfo.
    ^ methodInfo

    "Modified: / 12-10-2006 / 20:14:09 / cg"
!

methods
    "return a collection of methods belonging to that project.
     This excludes any methods which are already in my class-set."

    |methods methodsInfo|

    properties notNil ifTrue:[
        methodsInfo := properties at:#methodsInfo ifAbsent:nil.
        methodsInfo notNil ifTrue:[
            methods := methodsInfo collect:[:i | i className]
        ] ifFalse:[
            methods := properties at:#methods ifAbsent:nil
        ]
    ].

    methods isNil ifTrue:[
        methods := OrderedCollection new.
        Smalltalk allClassesDo:[:aClass |
            (true "aClass owningClass isNil"
            and:[aClass isMeta not
            and:[aClass package ~= packageName
            and:[aClass isRealNameSpace not]]]) ifTrue:[
            
                aClass methodDictionary keysAndValuesDo:[:sel :mthd |
                    mthd package = packageName ifTrue:[
                        methods add:(MethodInfo new
                                        className:aClass name;
                                        methodName:sel;
                                        yourself)
                    ].
                ].
                aClass class methodDictionary keysAndValuesDo:[:sel :mthd |
                    mthd package = packageName ifTrue:[
                        methods add:(MethodInfo new
                                        className:(aClass name , ' class');
                                        methodName:sel;
                                        yourself)
                    ].
                ]
            ]
        ].
        methods isEmpty ifTrue:[^ #()].
    ].
    ^ methods

    "Modified: / 10-11-2006 / 17:12:28 / cg"
! !

!Project methodsFor:'views'!

addView:aView
    "add a view to this projects set of views"

    views notNil ifTrue:[views add:aView]

    "Modified: 14.2.1997 / 15:36:51 / cg"
!

destroyViews
    "destroy all views of this project"

    views notNil ifTrue:[
	views do:[:aView |
	    aView notNil ifTrue:[aView destroy]
	]
    ].
!

hideViews
    "hide all views of this project"

    views notNil ifTrue:[
	views do:[:aView |
	    aView notNil ifTrue:[aView unmap]
	]
    ].

    "Modified: 3.5.1996 / 23:48:51 / stefan"
!

removeView:aView
    "remove a view from this projects set of views"

    views notNil ifTrue:[
	views remove:aView ifAbsent:nil
    ]

    "Modified: 14.2.1997 / 15:37:20 / cg"
!

showViews
    "show all views of this project"

    views notNil ifTrue:[
	views do:[:aView |
	    aView notNil ifTrue:[aView remap]
	]
    ].

    "Modified: 3.5.1996 / 23:59:10 / stefan"
    "Modified: 14.2.1997 / 15:38:47 / cg"
! !

!Project::ClassInfo methodsFor:'accessing'!

classFileName
    "return the value of the instance variable 'classFileName' (automatically generated)"

    ^ classFileName
!

classFileName:something
    "set the value of the instance variable 'classFileName' (automatically generated)"

    classFileName := something.
!

className
    "return the value of the instance variable 'className' (automatically generated)"

    ^ className
!

className:something
    "set the value of the instance variable 'className' (automatically generated)"

    className := something.
!

conditionForInclusion
    "return the value of the instance variable 'conditionForInclusion' (automatically generated)"

    ^ conditionForInclusion
!

conditionForInclusion:something
    "set the value of the instance variable 'conditionForInclusion' (automatically generated)"

    conditionForInclusion := something.
! !

!Project::ClassInfo methodsFor:'printing & storing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:'ClassInfo: '.
    className printOn:aGCOrStream.
! !

!Project::ClassInfo methodsFor:'queries'!

theClass
    |cls|

    cls := Smalltalk classNamed:className.
    cls isNil ifTrue:[ ^ nil].
    ^ cls

    "Created: / 26.9.1999 / 13:39:00 / cg"
! !

!Project::MethodInfo methodsFor:'accessing'!

className
    "return the value of the instance variable 'className' (automatically generated)"

    ^ className
!

className:something
    "set the value of the instance variable 'className' (automatically generated)"

    className := something.
!

conditionForInclusion
    "return the value of the instance variable 'conditionForInclusion' (automatically generated)"

    ^ conditionForInclusion
!

conditionForInclusion:something
    "set the value of the instance variable 'conditionForInclusion' (automatically generated)"

    conditionForInclusion := something.
!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something.
!

methodName
    "return the value of the instance variable 'methodName' (automatically generated)"

    ^ methodName
!

methodName:something
    "set the value of the instance variable 'methodName' (automatically generated)"

    methodName := something.
!

setupFromMethod:aMethod
    |who|

    who := aMethod who.
    className := who methodClass name.
    methodName := who methodSelector.
    fileName := aMethod sourceFilename.

    "Created: / 12-10-2006 / 20:13:32 / cg"
! !

!Project::MethodInfo methodsFor:'printing & storing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:'MethodInfo: '.
    className printOn:aGCOrStream.
    aGCOrStream nextPutAll:'>>'.
    methodName printOn:aGCOrStream
! !

!Project::MethodInfo methodsFor:'queries'!

method
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self theMethod.

    "Modified: / 26.9.1999 / 13:40:16 / cg"
!

theMethod
    |cls|

    cls := Smalltalk classNamed:className.
    cls isNil ifTrue:[ ^ nil].
    ^ cls compiledMethodAt:methodName asSymbol.

    "Created: / 26.9.1999 / 13:39:07 / cg"
! !

!Project class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Project initialize!
