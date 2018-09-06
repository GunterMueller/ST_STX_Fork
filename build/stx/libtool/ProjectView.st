"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

StandardSystemView subclass:#ProjectView
	instanceVariableNames:'myProject toggle'
	classVariableNames:'ActiveProjectView'
	poolDictionaries:''
	category:'Interface-Tools'
!

!ProjectView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    ProjectViews basically offer two functionalities:

      - keep a group of windows in order to organize the desktop
	(I am not sure, if this is really a useful feature, now that we
	 have modern windowManagers which have multiple desktops as well).

	All views as created while a project is active are remembered
	and can be hidden/shown altogether.
	(this has nothing to do with windowGroups)

	Also, it is possible to close down all those windows (by destroying the project).

      - keep defaults for various system activities:
		- the fileOut directory (i.e. where the SystemBrowser creates fileOut sources)

		- keep the source module/package
		    thats the default offered when classes are checkedIn the very first time

		- keep a default package-identifier assigned when classes/methods are created/modified.
		    thats mostly useful to browse all classes/methods that have been touched
		    in a projects context

		- keep a per-project changeList

      - allow opening a browser on all classes/methods which were created or modified
	while a project was active.

      - allow opening a browser on this projects changeList (which contains the subset of changes
	 which were done while this project was active)

      - allow removal of all classes/methods which have the current projects packageIdentifier

    [author:]
	Claus Gittinger

    [see also:]
	Project
	NameSpace
	CVSSourceCodemanager
"

! !

!ProjectView class methodsFor:'instance creation'!

for:aProject
    "create & open a new projectView on some project"

    |newView|

    newView := super new.
    newView setProject:aProject.
    ^ newView

    "
     ProjectView for:(Project new)
    "

    "Modified: 14.2.1997 / 13:46:07 / cg"
! !

!ProjectView methodsFor:'initialize / release'!

addToCurrentProject
    "add this view to the current projects set of views.
     Ignored here - ProjectViews are global."

    ^ self

    "Modified: 14.2.1997 / 13:35:58 / cg"
!

destroy
    "Let user confirm, then close all of my views, and get rid of the changeList.
     However, methods and classes are not restored to their
     previous state."

    |views|

    myProject notNil ifTrue:[
        views := myProject views.
        (views size > 0) ifTrue:[
            |box|

            box := YesNoBox new.
            box title:(resources string:'PROJECT_DESTROY') withCRs.
            box okText:(resources string:'yes').
            (box confirm) ifFalse:[^ self]
        ].
    ].
    self doDestroy

    "Modified: 14.2.1997 / 13:39:03 / cg"
!

initialize
    super initialize.

    "/
    "/ create the toggle ...
    "/
    toggle := Toggle in:self.
    toggle borderWidth:0.
    toggle pressAction:[self showProject].
    toggle releaseAction:[self hideProject].

    "/
    "/ and give it a menu
    "/

    toggle menuHolder:self; menuMessage:#projectMenu.

    "Created: 25.11.1995 / 18:06:32 / cg"
    "Modified: 27.1.1997 / 11:53:18 / cg"
!

projectMenu
    "return a popUpMenu"

    |labels selectors m|

    labels := #(
                    'class documentation'
                    '-'
                    'show'
                    'hide'
                    '-'
                    'changes'
                    'browse'
                    'browse redefined'
                    'fileOut classes'
                    '-'
                    'fileOut directory ...'
                    'repository defaults ...'
                    'package name ...'
                    'default nameSpace for fileIn ...'
"/                        '-'
"/                        'save project code'
"/                        'build'
                    '-'
                    'remove package code'
                    'remove project'
                    '-'
                    'rename ...'
               ).

     selectors := #(        
                    showClassDocumentation
                    nil
                    showProject
                    hideProject
                    nil
                    browseChanges
                    browsePackage
                    browseRedefined
                    fileOutClasses
                    nil
                    projectDirectory
                    projectRepositoryAndModule
                    projectPackage
                    projectNameSpace
"/                        nil
"/                        saveProjectFiles
"/                        buildProject
                    nil
                    removePackage
                    destroy
                    nil
                    renameProject
                ).

    m := PopUpMenu
                labels:(resources array:labels)
                selectors:selectors
                receiver:self.

    SourceCodeManager isNil ifTrue:[
        m disableAll:#(#projectRepository #projectRepositoryAndModule).
    ].

    ^ m

    "Created: / 27.1.1997 / 11:53:30 / cg"
    "Modified: / 6.2.1998 / 12:57:21 / cg"
! !

!ProjectView methodsFor:'menu actions'!

browseChanges
    "open a changeBrowser showing all changes made in this project
     (i.e. while this project was the active project)"

    |changes b|

    changes := myProject changeSet.
    changes size == 0 ifTrue:[
	self warn:(resources string:'no changes made in this project (yet)').
	^ self
    ].

    b := ChangeSetBrowser openOn:(myProject changeSet).
    b label:(resources string:'Changes in %1' with:myProject name)

    "Modified: 14.2.1997 / 13:36:40 / cg"
!

browsePackage
    "launch browsers for all classes/methods which are defined in this package
     (i.e. whose packageIdentifier is the same as my Projects packageIdentifier)"

    self topView withWaitCursorDo:[
        |classes packageName methods methodList anyClasses anyMethods ignoredClasses|

        anyMethods := anyClasses := false.

        packageName := myProject package.
        classes := myProject classes.
        (classes notNil and:[classes notEmpty]) ifTrue:[
            anyClasses := true.
        ].

        methods := myProject individualMethods.
        methods notEmpty ifTrue:[
            anyMethods := true.
            SystemBrowser browseMethods:methods
                                  title:(resources string:'individual methods in package %1' with:packageName).
        ].
        anyClasses ifTrue:[
            SystemBrowser browseClasses:classes
                                  title:(resources string:'classes in package %1' with:packageName).
        ].
        (anyClasses or:[anyMethods]) ifFalse:[
            self information:(resources string:'no classes or methods in this project (yet)')
        ]
    ]

    "Created: 10.12.1995 / 00:08:58 / cg"
    "Modified: 12.12.1995 / 16:35:07 / cg"
!

browseProps
    "show the projects properties.
     This is not yet finished ...
     ... and will look better, once property inspector runs ..."

    myProject properties inspect

    "Modified: 14.2.1997 / 13:37:15 / cg"
!

browseRedefined
    "launch browsers for all redefined methods.
     Thats methods which existed before and were redefined by package methods"

    self topView withWaitCursorDo:[
	|redefined methods|

	redefined := myProject overwrittenMethods.
	redefined notNil ifTrue:[
	    methods := redefined values.
	].
	methods size > 0 ifTrue:[
	    SystemBrowser browseMethods:methods
				  title:(resources string:'redefined methods in package %1' with:myProject packageName).
	] ifFalse:[
	    self information:(resources string:'no redefined methods in this project (yet)')
	]
    ]

    "Created: 27.1.1997 / 11:57:03 / cg"
    "Modified: 27.1.1997 / 11:58:06 / cg"
!

buildProject
    "build the project; this is not yet finished ...
     ... and will eventually create all sources, makefile and
     build what is to be built: either a classLibrary or an application"

    self topView withWaitCursorDo:[
	|dir|

	self saveProjectFiles.
	(self confirm:'make object files in: ' ,  dir , ' ?') ifTrue:[
	    myProject buildProject.
	]
    ].

    "Modified: 14.2.1997 / 13:38:06 / cg"
!

doDestroy
    "close all of my views, and get rid of the changeList.
     However, methods and classes are not restored to their
     previous state.
     No confiramtion here."

    self hideProject.
    myProject := nil.
    super destroy

    "Modified: 14.2.1997 / 13:39:18 / cg"
!

fileOutClasses
    "fileout all classes belonging to that package.
     CAVEAT: individual methods are not yet supported."

    self topView withWaitCursorDo:[
	|classes packageName methods methodList anyClasses anyMethods ignoredClasses|

	anyMethods := anyClasses := false.

	packageName := myProject packageName.
	classes := myProject classes.
	(classes notNil and:[classes notEmpty]) ifTrue:[
	    anyClasses := true.
	].

	methods := myProject individualMethods.
	methods notEmpty ifTrue:[
	    anyMethods := true.
	    self warn:'individual methods are currently not handled'
	].
	anyClasses ifTrue:[
	    classes do:[:aClass |
		Transcript showCR:'fileOut: ' , aClass name , ' ...'.
		aClass fileOut
	    ].
	].
	(anyClasses or:[anyMethods]) ifFalse:[
	    self information:(resources string:'no classes or methods in this project (yet)')
	]
    ]

    "Created: 11.4.1996 / 19:29:50 / cg"
!

hideProject
    "hide all views belonging to that project and switch
     to the default project"

    myProject notNil ifTrue:[
        myProject hideViews.
    ].
    ActiveProjectView := nil.
    toggle turnOff.
    Project setDefaultProject.

    "Modified: 14.2.1997 / 13:39:43 / cg"
!

projectDirectory
    "ask for the default directory, where fileOut will write
     its files. Will eventually also be the place, where makefiles
     and additional stuff is saved, for project building."

    |box d|

    box := FilenameEnterBox new.
    box directoriesOnly.
    box title:(resources string:'PROJECT_DIRECTPORY') withCRs.
    (d := myProject directory) notNil ifTrue:[
	box initialText:d
    ].
    box action:[:dirName |
	(OperatingSystem isDirectory:dirName) ifFalse:[
	    (OperatingSystem isValidPath:dirName) ifTrue:[
		self warn:(resources string:'%1 is not a valid directory' with:dirName).
		^ self
	    ].
	    (self confirm:(resources string:'%1 does not exist\\create ?' with:dirName) withCRs) ifTrue:[
		(OperatingSystem recursiveCreateDirectory:dirName) ifFalse:[
		    self warn:(resources string:'cannot create %1' with:dirName)
		]
	    ].
	].
	"did it work ?"
	(OperatingSystem isDirectory:dirName) ifTrue:[
	    myProject directory:dirName
	].
    ].
    box showAtPointer

    "Modified: 14.2.1997 / 13:44:59 / cg"
!

projectNameSpace
    "ask for the default nameSpace, into which new classes
     are loaded while this project is active.
     Useful before filing in alien code, to make certain that loaded
     classes do not conflict with existing ones ..."

    self topView withWaitCursorDo:[
        |box allNameSpaces|

        allNameSpaces := (NameSpace allNameSpaces 
                            select:[:ns | ns isTopLevelNameSpace])
                                collect:[:ns | ns name].

        box := ListSelectionBox title:(resources string:'default nameSpace:') withCRs.
        box list:(allNameSpaces asOrderedCollection sort).
        box action:[:nsName |
            |ns|

            "/ only create topLevel nameSpaces here

            Class nameSpaceQuerySignal 
            answer:Smalltalk
            do:[
                ns := NameSpace name:nsName.
            ].    
            myProject defaultNameSpace:ns
        ].
        box showAtPointer
    ]

    "Created: 9.12.1995 / 16:50:45 / cg"
    "Modified: 16.1.1997 / 01:00:06 / cg"
!

projectPackage
    "ask for the package identifier of this project.
     New classes and methods get this identifier, to find them
     quickly later."

    self topView withWaitCursorDo:[
        |box p existingPackages allClasses|

        existingPackages := Set new.
        (allClasses := Smalltalk allClasses) do:[:aClass |
            |p|

            (aClass isNameSpace 
"/            or:[aClass isLoaded not]
            ) ifFalse:[
                p := aClass package.
                p size == 0 ifTrue:[
                    p := 'no package'.
                ].
                existingPackages add:(p asString).

                aClass methodDictionary do:[:aMethod |
                    p := aMethod package.
                    p size == 0 ifTrue:[
                        p := 'no package'.
                    ].
                    existingPackages add:(p asString).
                ].
                aClass class methodDictionary do:[:aMethod |
                    p := aMethod package.
                    p size == 0 ifTrue:[
                        p := 'no package'.
                    ].
                    existingPackages add:(p asString).
                ].
            ].
        ].

        box := ListSelectionBox title:(resources string:'PROJECT_PACKAGENAME') withCRs.
        box list:(existingPackages asOrderedCollection sort).
        (p := myProject package) notNil ifTrue:[
            box initialText:p
        ].
        box action:[:packageName |
            |someClass module directory|

            "/ (try) to extract the module & repository directory from someClass which
            "/ is already contained in that package

            Smalltalk allClasses 
                detect:[:cls | 
                                |info|

                                (cls package = packageName) ifTrue:[
                                    (info := cls packageSourceCodeInfo) notNil ifTrue:[
                                        module := info at:#module ifAbsent:nil.
                                        directory := info at:#directory ifAbsent:nil.
                                    ]
                                ].
                                module notNil and:[directory notNil].
                        ]
                ifNone:nil.

            module notNil ifTrue:[
                myProject repositoryModule:module
            ].
            directory notNil ifTrue:[
                myProject repositoryDirectory:directory
            ].
            myProject packageName:packageName.

        ].
        box showAtPointer
    ]

    "Created: 9.12.1995 / 16:50:45 / cg"
    "Modified: 19.9.1997 / 10:55:19 / cg"
!

projectRepositoryAndModule
    "ask for a default module and package directory.
     This is offered as default, when new containers are
     created. However, when creating, these can still be changed"

    |box moduleHolder dirHolder|

    box := DialogBox new.
    (box addTextLabel:(resources string:'PROJECT_MODULEANDDIR') withCRs)
	adjust:#left.
    box addHorizontalLine.

    moduleHolder := myProject repositoryModule asValue.
    dirHolder := myProject repositoryDirectory asValue.

    (box addTextLabel:(resources string:'PROJECT_MODULEDIR') withCRs)
	adjust:#left.
    box addFilenameInputFieldOn:moduleHolder in:nil tabable:true.

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    (box addTextLabel:(resources string:'PROJECT_PACKAGEDIR') withCRs)
	adjust:#left.
    box addFilenameInputFieldOn:dirHolder in:nil tabable:true.

    box addAbortButton; addOkButton.
    box showAtPointer.

    box accepted ifTrue:[
	myProject repositoryModule:moduleHolder value.
	myProject repositoryDirectory:dirHolder value.
    ].

    box destroy.

    "Modified: 14.2.1997 / 13:42:05 / cg"
!

removePackage
    "remove all classes and individual methods from the system.
     Currently, this cannot fully restore the state to before
     the time the package was loaded (redefined methods are lost).
     In the future, we may keep a backref of overwritten methods
     and restore them from their source ..."

    |classesToRemove methodsToRemove theProject|

    (myProject isNil
    or:[(theProject := myProject packageName) isNil]) ifTrue:[
	self warn:(resources string:'No current package.').
	^ self
    ].

    classesToRemove := IdentitySet new.
    methodsToRemove := IdentitySet new.

    Smalltalk allClassesDo:[:aClass |
	|p|

	(p := aClass package) notNil ifTrue:[
	    p = theProject  ifTrue:[
		classesToRemove add:aClass
	    ]
	].
    ].
    Smalltalk allClassesDo:[:aClass |
	|p|

	(classesToRemove includes:aClass) ifFalse:[
	    aClass methodDictionary keysAndValuesDo:[:sel :aMethod |
		(p := aMethod package) notNil ifTrue:[
		    p = theProject  ifTrue:[
			methodsToRemove add:aMethod
		    ]
		]
	    ].
	    aClass class methodDictionary keysAndValuesDo:[:sel :aMethod |
		(p := aMethod package) notNil ifTrue:[
		    p = theProject  ifTrue:[
			methodsToRemove add:aMethod
		    ]
		]
	    ].
	].
    ].

    (classesToRemove isEmpty
    and:[methodsToRemove isEmpty]) ifTrue:[
	self warn:(resources string:'No classes or methods found in %1' with:theProject).
	^ self
    ].

    (self confirm:(resources
			string:'About to remove %1 classes and %2 additional methods.\\Are you certain you want this ?'
			with:classesToRemove size
			with:methodsToRemove size) withCRs)
	ifTrue:[
	    classesToRemove do:[:aClass |
		('PROJECT: removing ' , aClass name) infoPrintNL.
		Smalltalk removeClass:aClass.   
	    ].
	    methodsToRemove do:[:aMethod |
		|where|

		('PROJECT: removing ' , aMethod displayString) infoPrintNL.
		where := aMethod who.
		where isNil ifTrue:[
		    'PROJECT: oops, some method is gone' infoPrintNL.
		] ifFalse:[
		    (where at:1) removeSelector:(where at:2)
		]
	    ]
    ].
!

renameProject
    "give that project another name - has no semantic meaning,
     and does not affect any class/method"

    |box|

    box := EnterBox new.
    box title:(resources string:'new name of project:').
    box okText:(resources string:'rename').
    box initialText:(myProject name).
    box action:[:newName |
	myProject name:newName.
	self setProject:myProject.
	self windowGroup process name:'Project: ' , newName.
    ].
    box showAtPointer

    "Modified: 14.2.1997 / 13:41:15 / cg"
!

saveProjectFiles
    "create the projects files.
     This is not yet finished."

    self topView withWaitCursorDo:[
	|dir|

	dir := myProject directory.
	(self confirm:'create source files in: ' ,  dir , ' ?') ifTrue:[
	    myProject createProjectFiles.
	]
    ].

    "Modified: 14.2.1997 / 13:40:40 / cg"
!

showClassDocumentation
    "open a documentViewer on the projects classes documentation only"

    self topView withWaitCursorDo:[
        |classes packageName methods methodList anyClasses anyMethods 
         html|

        anyMethods := anyClasses := false.

        packageName := myProject package.
        classes := myProject classes.
        (classes notNil and:[classes notEmpty]) ifTrue:[
            anyClasses := true.
        ].
        (anyClasses or:[anyMethods]) ifFalse:[
            self information:(resources string:'no classes or methods in this project (yet)').
            ^ self.
        ].

        methods := myProject individualMethods.
        methods notEmpty ifTrue:[
            anyMethods := true.
            "/ not yet shown ...
        ].

        anyClasses ifFalse:[ ^ self].

        html := HTMLDocGenerator 
                        htmlClasses:classes 
                        title:'project classes' 
                        backTo:#none.

        HTMLDocumentView openFullOnText:html
    ]

    "Created: 11.4.1996 / 19:29:50 / cg"
    "Modified: 26.4.1996 / 17:48:33 / cg"
!

showProject
    "show all views belonging to that project and hide
     the active projects views (except for those opened before)"

    ActiveProjectView notNil ifTrue:[
	ActiveProjectView hideProject
    ].
    ActiveProjectView := self.

    myProject showViews.
    Project current:myProject.
    toggle turnOn

    "Modified: 14.2.1997 / 13:40:10 / cg"
! !

!ProjectView methodsFor:'private accessing'!

setProject:aProject
    |name e|

    name := aProject name.
    self label:name.
    self iconLabel:name.
    toggle label:'Project: ' , name.
    toggle resize.
    myProject := aProject.
    e := (toggle width @ toggle height).
    drawableId isNil ifTrue:[
	self minExtent:e.
	self maxExtent:e.
	self open
    ] ifFalse:[
	self unmap.
	self minExtent:e.
	self maxExtent:e.
	self extent:e.
	self remap
    ]
! !

!ProjectView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

