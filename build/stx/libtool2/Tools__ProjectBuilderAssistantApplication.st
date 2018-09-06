"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

AssistantApplication subclass:#ProjectBuilderAssistantApplication
	instanceVariableNames:'packageToBuildHolder projectType projectTypeHolder
		selectedProjectIndexHolder selectedProjectDefinition
		listOfMatchingProjects listOfMatchingPackageIds
		selectedProjectsComment hasProjectSelectedHolder newProjectsName
		hideSTXProjects hideOtherApplicationClasses
		hideOtherStartupClasses startMakeButtonEnabled
		stopMakeButtonVisible makeOutputHolder newApplicationsName
		listOfApplicationsInProject selectedApplicationIndexHolder
		selectedApplication hasApplicationSelectedHolder
		listOfStartupClassesInProject selectedStartupClassIndexHolder
		selectedStartupClass hasStartupClassSelectedHolder
		selectedApplicationsComment buildDirectoryHolder makeProcess
		listOfClassesInProject makeOutputWindow projectBuilder
		newStartupClassName usedCompilerHolder listOfNewProjectsName
		newProjectsNameListExtendedComboBox productNameHolder
		companyNameHolder compilerWarnMessageHolder
		compilerWarnMessageVisibleHolder listOfPrerequisitesInProject
		nameOfUsedCompilerSuiteHolder usedCompilerIndexHolder'
	classVariableNames:'LastUsedCompiler Debugging'
	poolDictionaries:''
	category:'System-Support-Projects'
!

!ProjectBuilderAssistantApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    a user friendly interface to the build process.
    Simply wraps up existing tools like the CodeGeneratorTool, the browsers
    and the ProjetBuilder

    [see also:]
        CodeGeneratorTool
        ProjectBuilder
        ProjectDefinition

    [author:]
        Claus Gittinger
"
!

help
"
  Packager - A Standalone-Executable Builder and Packager

    This assistant-application allows for standalone applications to be built very easily.
    It will generate all required classes, files, start the compilation process,
    generate a self-installable executable with a few mouse clicks.

    A simple demo application like the famous 'Hello World' can be generated in a few minutes.

  Prerequisites

    * Windows Users:
    Please install either the 'Borland Free Commandline Compiler Tools (bcc32)'
    or the 'Microsoft Visual-C++' package (also free).
     In addition, the 'NullSoft NSIS-Installer Package' is required.

    Due to limitations and bugs in the Visual-C++ compiler (limit on the size of
    string-constants), some Smalltalk code is still not compilable
    (currently, this affects classes which contain image-resource methods for big images).
    Although microsoft is doing their best (a relative measure) to make things better
    (they increase the string-limit with every new release), they still seem to be unable
    to figure out how ti use malloc for string-data).
    We are patiently waiting for a real fix and still using bcc in the meanwhile.
    Therefore, we recommend using the borland compiler suite.
    Please install it at its standard location ('C:\Borland') as our makefiles might
    still contain hard-coded paths (yes, we are ashamed about this).

    * Unix Users:
    You should already have the gcc compile suite (including all required header files)
    installed and ready to use. For a lack of time on our side, there is currently no
    self-installer support for Unix. The packager will generate a zipped tar file,
    which must be deployed and unpacked for use. This may change in the near future.

  Packages, Projects, PackageIDs and ProjectDefinitions

    Smalltalk basically uses two objects for packaging:

        * PackageIDs (also called ProjectID's occasionally)
        * ProjectDefinitions

    Older ST/X versions used instances of a Project class - this is now obsolete and
    removed from the system (although there are still some minor uses of it,
    which might remain there for backward compatibility for some time, as some customers
    have built their own packaging scheme around it).

  PackageIDs

    These are simple symbols and are attached to classes and methods. If a method has
    a packageID different from its class, it is called an extension method.
    PackageIDs must have a certain fixed format: they always contain exactly two parts,
    which are separated by a colon character: the module and the directory part.
    The module is used as main-selector on where and how the source code repository is
    accessed. The directory is a path below that repository. If checked out into the local
    filesystem, the module defines the top-level directory. Thus, if a packageID is
    'stx:libbasic', the corresponding sources will be found in the repository associated
    to the 'stx' module, under the directory 'libbasic'.
    In the local file system, it will be found under 'stx/libbasic'.
    As another example, if the packageID is 'exept:expecco/plugins/foo',
    the repository is whichever is associated with the 'exept' module, and the subdirectory
    is 'expecco/plugins/foo'. The local path to the sourcefiles would be
    'exept/expecco/plugins/foo'.

    Please notice that it does make sense to associate different repositories to different
    modules: for example, you could setup the sourceCodeManager to use CVS access to the
    exept repository for everything under the 'stx' module,
    and at the same time, use a local SVN repository for everything under the 'myCompany'
    module.

  ProjectDefinitions

    These describe the contents of a project, such as the classes to include,
    the set of extension methods, any additional compilation information.
    ProjectDefinitions come in 3 flavours:

        * GUI Application Definition
        * non-GUI Application Definition
        * ClassLibrary Definition

    ProjectDefinitions are stored and managed as class-instances, located as subclasses
    of one of ApplicationDefinition or LibraryDefinition.
    As classes, they are themself managed, compiled and packaged as part of the project
    (and also have the same PackageID as their components).
    They are also treated like any other class w.r.t. source code management.

  Packaging

    All classes and extension methods belonging to a single package are supposed to be
    loaded (and possibly unloaded) together. They are also usually deployed inside a single
    dynamic link library ('dll', for short). In the Unix world, these are called
    'shared object' or 'so'.
    Finally, they are stored in a common directory both on the local file system and in a
    source code repository (CVS, SVN, etc.).

  Structure of a Project

    The artefacts as manipulated by the packager are:

        * the ProjectDefinition class
          This defines the type of application (GUI / non-GUI),
          its contents (i.e. the set of classes to be included in the binary itself and
          the set of library-dll's to be included in the deployed package),
          and some other metadata, such as icon, title etc.

        * the ApplicationModel class
          This defines the GUI, and is typically created using the UI-Painter.

        * the Startup class
          This is the first class which gets control when the executable is started;
          it can analyze the command line arguments, read patches or updates,
          start background ptocesses, and will eventually open the applications GUI.

  Build Procedure

    All of the three components above can be generated by the packager to provide an
    initial framework for further work.

    After the definition of those classes, all required files are stored in a temporary
    build directory. This means that the above classes are filed out,
    and make- and other support files are generated.

    Finally, the actual build process is started. This requires an external C-compiler.
    Under windows, both Borland-C (free download available via the internet) and Microsoft's
    Visual-C++ (also available for free) can be used (the later with some limitations as explained above).

    A self-installing executable is built using the NullSoft NSIS package.
    This is also required to be installed before the packager is started.

    After the build, all required files are packaged in a single install-file.
    This is called 'MyApplicationSetup.exe' and found in the project-specific subdirectory
    of the build directory. For deployment, this single file has to be delivered to a customer
    and executed there.

    Summary: It has NEVER been easier to create a GUI application with Smalltalk.
"
! !

!ProjectBuilderAssistantApplication class methodsFor:'defaults'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary projectBuilderIcon
!

windowLabelTemplate
    ^ 'ST/X Packager: %1'
! !

!ProjectBuilderAssistantApplication class methodsFor:'help'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#'projectType'
'Choose the type of Project you are about to deploy'

#existingProjects
'Projects with an existing ProjectDefinition of the chosen type (above)'

#nameOfApplicationClass
'For GUI applications: the name of your application class (subclass of ApplicationModel).
This will be opened by the startup sequence and defines the UI.
(Usually, these are named "XXXApplication" or "XXXApp")
Click on the "Create"-button to create a simple helloWorld app to start with'

#createNewApplication
'Create a new simple dummy application (HelloWorld-like). 
Press this button to get some template code to play with - but enter a name first'

#nameOfStartupClass
'This class contains the main method, in which the show starts when the executable runs.
Its main task is to parse command line arguments (if any) and fire up the real application.
It should inherit from StandaloneStartup.
(Usually, these are named "XXXStart" or "XXXStartup")
Click on the "Create"-button to create something to start with (will launch your application)'

#createNewStartupClass
'Create a new simple startup class which fires up the defined application.
Press this button to get a standard startup class which does not care for command line args.
But enter a name first'

#browseSelectedProject
'Open a SystemBrowser on the selected Project'

#hideSTXBasePackages
'Only show packages which are not already included in the basic ST/X delivery'

#'listOfNewProjectsName'
'PackageID (module:directory).
The pull-down list contains packageIDs for which no ProjectDefinition exists (yet)'

#'createNewProject'
'PackageID (module:directory).
Click to create a new (empty) ProjectDefinition for the given PackageID'

#clearBuildDirectory
'Clear the build directory'

#makeAll
'Build a self-installing deployable package'

#makeApp
'Build the app only (for test-running)'

#makeExe
'Build the executable only (for test-running)'

#makeExeQuick
'Quick build the executable only (for test-running). 
Does not regenerate the header files. Only the target package files are recreated'

#makeOutput
'Displays the output of the build process (make command)'

#openExplorer
'Open a Windows Explorer on the build directory. You can double-click on the built executable there'

#openFinder
'Open a Finder on the build directory. You can double-click on the built executable there'

#openFileBrowser
'Open a Filebrowser on the build directory'

#openTerminal
'Open a terminal (console) in the build directory'

#stopMake
'Abort the ongoing build process. Please clear the build directory afterwards to remove any leftover garbage'

#hideOtherStartupClasses
'Hide startup classes from other packages. Uncheck to see them.\(Notice: the startup class really should be in the same package)'

)

    "Modified: / 06-09-2012 / 16:09:10 / cg"
! !

!ProjectBuilderAssistantApplication class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::ProjectBuilderAssistantApplication
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#companyName
''

#hideOtherStartupClasses
''

#productName
''

#programName
''

)
! !

!ProjectBuilderAssistantApplication class methodsFor:'interface specs'!

page1_projectTypeSelectionSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page1_projectTypeSelectionSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page1_projectTypeSelectionSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'page1_projectTypeSelectionSpec'
        window: 
       (WindowSpec
          label: 'Project Selection'
          name: 'Project Selection'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 626 394)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Project Type'
              name: 'FramedBox1'
              layout: (LayoutFrame 0 0.0 0 0 4 1.0 120 0)
              activeHelpKey: projectType
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (VerticalPanelViewSpec
                    name: 'VerticalPanel1'
                    layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                    horizontalLayout: leftSpace
                    verticalLayout: topSpace
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: 'Box1'
                          extent: (Point 10 10)
                        )
                       (RadioButtonSpec
                          label: 'GUI Application'
                          name: 'RadioButton1'
                          translateLabel: true
                          model: projectTypeHolder
                          isTriggerOnDown: true
                          onCallBackSelector: projectTypeChanged
                          select: #'GUI-Application'
                          extent: (Point 294 22)
                        )
                       (RadioButtonSpec
                          label: 'Non-GUI Application'
                          name: 'RadioButton2'
                          translateLabel: true
                          model: projectTypeHolder
                          isTriggerOnDown: true
                          onCallBackSelector: projectTypeChanged
                          select: #'NonGUI-Application'
                          extent: (Point 294 22)
                        )
                       (RadioButtonSpec
                          label: 'Class Library'
                          name: 'RadioButton3'
                          translateLabel: true
                          model: projectTypeHolder
                          isTriggerOnDown: true
                          onCallBackSelector: projectTypeChanged
                          select: Library
                          extent: (Point 294 22)
                        )
                       )
                     
                    )
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'Existing Projects of this Type (PackageIDs)'
              name: 'FramedBox2'
              layout: (LayoutFrame 0 0.0 123 0 4 1.0 0 1)
              activeHelpKey: existingProjects
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (VariableHorizontalPanelSpec
                    name: 'VariableHorizontalPanel1'
                    layout: (LayoutFrame 0 0 4 0 0 1 -26 1)
                    component: 
                   (SpecCollection
                      collection: (
                       (SequenceViewSpec
                          name: 'List1'
                          model: selectedProjectIndexHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          useIndex: true
                          sequenceList: listOfMatchingPackageIds
                        )
                       (TextEditorSpec
                          name: 'TextEditor1'
                          model: selectedProjectsComment
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          isReadOnly: true
                          hasKeyboardFocusInitially: false
                        )
                       )
                     
                    )
                    handles: (Any 0.34560327198364 1.0)
                  )
                 (CheckBoxSpec
                    label: 'Hide ST/X Base Packages'
                    name: 'CheckBox1'
                    layout: (LayoutFrame -1 0 -18 1 0 1 4 1)
                    activeHelpKey: hideSTXBasePackages
                    model: hideSTXProjects
                    translateLabel: true
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

page2_projectSelectionSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page2_projectSelectionSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page2_projectSelectionSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page2_projectSelectionSpec'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 453)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'New Project''s PackageID'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 72 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (ExtendedComboBoxSpec
                   name: 'NewProjectsNameListExtendedComboBox'
                   layout: (LayoutFrame 1 0 6 0 -113 1 34 0)
                   activeHelpKey: listOfNewProjectsName
                   model: newProjectsName
                   readOnly: false
                   miniScrollerHorizontal: true
                   postBuildCallback: postBuildNewProjectsNameListExtendedComboBox:
                 )
                (ActionButtonSpec
                   label: 'Create'
                   name: 'Button1'
                   layout: (LayoutFrame -100 1 6 0 2 1 34 0)
                   activeHelpKey: createNewProject
                   translateLabel: true
                   model: createNewProject
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Existing Projects with ProjectDefinition'
             name: 'FramedBox4'
             layout: (LayoutFrame 0 0.0 70 0 4 1.0 -34 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel2'
                   layout: (LayoutFrame 0 0 4 0 0 1 -26 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'List2'
                         model: selectedProjectIndexHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         useIndex: true
                         sequenceList: listOfMatchingPackageIds
                       )
                      (TextEditorSpec
                         name: 'TextEditor2'
                         model: selectedProjectsComment
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                         viewClassName: 'TextView'
                       )
                      )
                    
                   )
                   handles: (Any 0.35000000000000003 1.0)
                 )
                (CheckBoxSpec
                   label: 'Hide ST/X Base Packages'
                   name: 'CheckBox1'
                   layout: (LayoutFrame -1 0 -17 1 0 1 5 1)
                   activeHelpKey: hideSTXBasePackages
                   model: hideSTXProjects
                   translateLabel: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Browse Selected Project'
                   name: 'Button3'
                   activeHelpKey: browseSelectedProject
                   translateLabel: true
                   model: doBrowseProject
                   enableChannel: hasProjectSelectedHolder
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page3_applicationSelectionSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page3_applicationSelectionSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page3_applicationSelectionSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page3_applicationSelectionSpec'
       window: 
      (WindowSpec
         label: 'Application Selection'
         name: 'Application Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 519 406)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'New Application Class'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 70 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 1 0 6 0 -113 1 34 0)
                   activeHelpKey: nameOfApplicationClass
                   model: newApplicationsName
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   emptyFieldReplacementText: 'MyApplication'
                 )
                (ActionButtonSpec
                   label: 'Create'
                   name: 'Button1'
                   layout: (LayoutFrame -100 1 6 0 1 1 34 0)
                   activeHelpKey: createNewApplication
                   translateLabel: true
                   model: createNewApplication
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Existing Applications'
             name: 'FramedBox4'
             layout: (LayoutFrame 0 0.0 72 0 4 1.0 -34 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel2'
                   layout: (LayoutFrame 0 0 4 0 0 1 -26 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'List2'
                         model: selectedApplicationIndexHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         useIndex: true
                         sequenceList: listOfApplicationsInProject
                         ignoreReselect: false
                       )
                      (TextEditorSpec
                         name: 'TextEditor2'
                         model: selectedApplicationsComment
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                         viewClassName: 'TextView'
                       )
                      )
                    
                   )
                   handles: (Any 0.35000000000000003 1.0)
                 )
                (CheckBoxSpec
                   label: 'Hide other Application Classes'
                   name: 'CheckBox1'
                   layout: (LayoutFrame -1 0 -18 1 0 1 4 1)
                   model: hideOtherApplicationClasses
                   translateLabel: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Browse Selected App'
                   name: 'Button3'
                   translateLabel: true
                   model: doBrowseApplication
                   enableChannel: hasApplicationSelectedHolder
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Launch Selected App'
                   name: 'Button4'
                   translateLabel: true
                   model: doLaunchApplication
                   enableChannel: hasApplicationSelectedHolder
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page4_startupClassSelectionSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page4_startupClassSelectionSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page4_startupClassSelectionSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page4_startupClassSelectionSpec'
       window: 
      (WindowSpec
         label: 'Startup Class Selection'
         name: 'Startup Class Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 408)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'New Startup Class'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 70 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 1 0 6 0 -113 1 34 0)
                   activeHelpKey: nameOfStartupClass
                   model: newStartupClassName
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   emptyFieldReplacementText: 'MyStandAloneStartup'
                 )
                (ActionButtonSpec
                   label: 'Create'
                   name: 'Button1'
                   layout: (LayoutFrame -100 1 6 0 1 1 34 0)
                   activeHelpKey: createNewStartupClass
                   translateLabel: true
                   model: createNewStartupClass
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Existing Startup Classes'
             name: 'FramedBox4'
             layout: (LayoutFrame 0 0.0 72 0 4 1.0 -34 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel2'
                   layout: (LayoutFrame 0 0 4 0 0 1 -26 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'List2'
                         model: selectedStartupClassIndexHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         useIndex: true
                         sequenceList: listOfStartupClassesInProject
                       )
                      (TextEditorSpec
                         name: 'TextEditor2'
                         model: selectedStartupClassesComment
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                         viewClassName: 'TextView'
                       )
                      )
                    
                   )
                   handles: (Any 0.35000000000000003 1.0)
                 )
                (CheckBoxSpec
                   label: 'Hide other Startup Classes'
                   name: 'CheckBox1'
                   layout: (LayoutFrame -1 0 -20 1 0 1 2 1)
                   activeHelpKey: hideOtherStartupClasses
                   model: hideOtherStartupClasses
                   translateLabel: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Browse Selected StartupClass'
                   name: 'Button3'
                   translateLabel: true
                   model: doBrowseStartupClass
                   enableChannel: hasStartupClassSelectedHolder
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page5_specifyIncludedClasses
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page5_specifyIncludedClasses
     Tools::ProjectBuilderAssistantApplication new openInterface:#page5_specifyIncludedClasses
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page5_specifyIncludedClasses'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 400)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Project Contents'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 -34 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (SequenceViewSpec
                   name: 'List1'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   initiallyDisabled: true
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   useIndex: false
                   sequenceList: listOfClassesInProject
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Browse Project Definition'
                   name: 'Button3'
                   translateLabel: true
                   model: doBrowseProjectDefinitionClass
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Update Contents (Scan)'
                   name: 'Button4'
                   translateLabel: true
                   model: doGenerateProjectContentsDefinition
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page5b_specifyPrerequisitePackages
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page5b_specifyPrerequisitePackages
     Tools::ProjectBuilderAssistantApplication new openInterface:#page5b_specifyPrerequisitePackages
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page5b_specifyPrerequisitePackages'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 400)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Prerequisite Packages'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 -34 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (SequenceViewSpec
                   name: 'List1'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   initiallyDisabled: true
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   useIndex: false
                   sequenceList: listOfPrerequisitesInProject
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Browse Project Definition'
                   name: 'Button3'
                   translateLabel: true
                   model: doBrowseProjectDefinitionClassForPrereqs
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Update Prerequisites (Scan)'
                   name: 'Button4'
                   translateLabel: true
                   model: doGenerateProjectPrerequisitesDefinition
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page6a_specifyProjectAttributes
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page6a_specifyProjectAttributes
     Tools::ProjectBuilderAssistantApplication new openInterface:#page6a_specifyProjectAttributes
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page6a_specifyProjectAttributes'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 239)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Product Information'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 116 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Product Name:'
                   name: 'Label1'
                   layout: (LayoutFrame 0 0 10 0 148 0 40 0)
                   activeHelpKey: productName
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'EntryField4'
                   layout: (LayoutFrame 150 0.0 10 0 0 1.0 40 0)
                   activeHelpKey: productName
                   model: productNameHolder
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   viewClassName: ''
                 )
                (LabelSpec
                   label: 'Company Name:'
                   name: 'Label2'
                   layout: (LayoutFrame 0 0 45 0 148 0 75 0)
                   activeHelpKey: companyName
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'EntryField3'
                   layout: (LayoutFrame 150 0.0 45 0 0 1.0 75 0)
                   activeHelpKey: companyName
                   model: companyNameHolder
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   viewClassName: ''
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Executable'
             name: 'FramedBox4'
             layout: (LayoutFrame 0 0.0 124 0 4 1.0 200 0)
             visibilityChannel: executableNameVisible
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Name:'
                   name: 'Label3'
                   layout: (LayoutFrame 0 0 10 0 148 0 40 0)
                   activeHelpKey: programName
                   translateLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'EntryField5'
                   layout: (LayoutFrame 150 0.0 10 0 0 1.0 40 0)
                   activeHelpKey: programName
                   model: executableNameHolder
                   isReadOnly: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   viewClassName: ''
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page6b_specifyBuildDirectorySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page6b_specifyBuildDirectorySpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page6b_specifyBuildDirectorySpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page6b_specifyBuildDirectorySpec'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 521 361)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Build Directory'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 115 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (FilenameInputFieldSpec
                   name: 'FilenameEntryField1'
                   layout: (LayoutFrame 0 0.0 10 0 0 1.0 40 0)
                   model: buildDirectoryHolder
                   acceptOnPointerLeave: true
                   viewClassName: FilenameWidgetWithHistory
                 )
                (ActionButtonSpec
                   label: 'Clear'
                   name: 'Button1'
                   layout: (LayoutFrame -127 1 50 0 -2 1 72 0)
                   translateLabel: true
                   model: clearBuildDirectory
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Compiler / Toolchain'
             name: 'FramedBox4'
             layout: (LayoutFrame 0 0.0 116 0 4 1.0 190 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (ComboListSpec
                   name: 'ComboList1'
                   layout: (LayoutFrame 0 0 10 0 137 0 40 0)
                   model: usedCompilerHolder
                   comboList: listOfPossibleCompilers
                   useIndex: false
                 )
                (LabelSpec
                   label: 'Compiler Suite'
                   name: 'Label2'
                   layout: (LayoutFrame 163 0 10 0 0 1 40 0)
                   translateLabel: true
                   labelChannel: nameOfUsedCompilerSuiteHolder
                   adjust: left
                 )
                )
              
             )
           )
          (TextEditorSpec
             name: 'TextEditor1'
             layout: (LayoutFrame 2 0.0 190 0 -2 1.0 303 0)
             level: -1
             visibilityChannel: compilerWarnMessageVisibleHolder
             model: compilerWarnMessageHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             backgroundColor: (Color 100.0 50.0 50.0)
             hasKeyboardFocusInitially: false
             postBuildCallback: postBuildWarnMessageView:
           )
          )
        
       )
     )
!

page7_buildSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page7_buildSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page7_buildSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page7_buildSpec'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 679 492)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Make Output'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 -106 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (TextEditorSpec
                   name: 'MakeOutputWindow'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   activeHelpKey: makeOutput
                   model: makeOutputHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   hasKeyboardFocusInitially: false
                   postBuildCallback: postBuildMakeOutputWindow:
                   viewClassName: 'TextCollector'
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -106 1 0 1 -72 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Make All'
                   name: 'Button3'
                   activeHelpKey: makeAll
                   translateLabel: true
                   model: doStartMakeAll
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Make App'
                   name: 'Button17'
                   activeHelpKey: makeAll
                   visibilityChannel: osIsOSX
                   translateLabel: true
                   model: doStartMakeApp
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Make EXE only'
                   name: 'Button5'
                   activeHelpKey: makeExe
                   translateLabel: true
                   model: doStartMakeExe
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Quick Make EXE'
                   name: 'Button16'
                   activeHelpKey: makeExeQuick
                   translateLabel: true
                   model: doStartMakeExeQuick
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ViewSpec
                   name: 'Box1'
                   extent: (Point 20 10)
                 )
                (ActionButtonSpec
                   label: 'Stop Make'
                   name: 'Button4'
                   activeHelpKey: stopMake
                   visibilityChannel: stopMakeButtonVisible
                   translateLabel: true
                   model: doStopMake
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel2'
             layout: (LayoutFrame 0 0 -70 1 0 1 -36 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Build Directory'
                   name: 'Label1'
                   translateLabel: true
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Finder'
                   name: 'Button13'
                   activeHelpKey: openFinder
                   visibilityChannel: osIsOSX
                   translateLabel: true
                   model: doOpenFinder
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Explorer'
                   name: 'Button14'
                   activeHelpKey: openExplorer
                   visibilityChannel: osIsWindows
                   translateLabel: true
                   model: doOpenExplorer
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Browser'
                   name: 'Button11'
                   activeHelpKey: openFileBrowser
                   translateLabel: true
                   model: doBrowseBuildDirectory
                   useDefaultExtent: true
                 )
                (ViewSpec
                   name: 'Box2'
                   extent: (Point 20 10)
                 )
                (ActionButtonSpec
                   label: 'Clear'
                   name: 'Button12'
                   activeHelpKey: clearBuildDirectory
                   translateLabel: true
                   model: doClearBuildDirectory
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel3'
             layout: (LayoutFrame 0 0 -34 1 0 1 0 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Terminal in Build Directory'
                   name: 'Button15'
                   activeHelpKey: openTerminal
                   translateLabel: true
                   model: doOpenTerminal
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page7a_checkinSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page7a_checkinSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page7a_checkinSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page7a_checkinSpec'
       window: 
      (WindowSpec
         label: 'Check Into Repository'
         name: 'Check Into Repository'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 679 492)
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel2'
             layout: (LayoutFrame 10 0 10 0 0 1 44 0)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Checkin...'
                   name: 'CheckinButton'
                   activeHelpKey: openFinder
                   visibilityChannel: osIsOSX
                   translateLabel: true
                   resizeForLabel: true
                   model: doCheckin
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page7b_buildSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page7b_buildSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page7b_buildSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page7b_buildSpec'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 679 492)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Make Output'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 -106 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (TextEditorSpec
                   name: 'MakeOutputWindow'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   activeHelpKey: makeOutput
                   model: makeOutputHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   hasKeyboardFocusInitially: false
                   postBuildCallback: postBuildMakeOutputWindow:
                   viewClassName: 'TextCollector'
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -106 1 -2 1 -72 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Make All'
                   name: 'Button3'
                   activeHelpKey: makeAll
                   translateLabel: true
                   model: doStartMakeAll
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Make APP only'
                   name: 'Button17'
                   activeHelpKey: makeApp
                   visibilityChannel: osIsOSX
                   translateLabel: true
                   model: doStartMakeApp
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Make EXE only'
                   name: 'Button5'
                   activeHelpKey: makeExe
                   translateLabel: true
                   model: doStartMakeExe
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Quick Make EXE'
                   name: 'Button16'
                   activeHelpKey: makeExeQuick
                   translateLabel: true
                   model: doStartMakeExeQuick
                   enableChannel: startMakeButtonEnabled
                   useDefaultExtent: true
                 )
                (ViewSpec
                   name: 'Box1'
                   extent: (Point 20 10)
                 )
                (ActionButtonSpec
                   label: 'Stop Make'
                   name: 'Button4'
                   activeHelpKey: stopMake
                   visibilityChannel: stopMakeButtonVisible
                   translateLabel: true
                   model: doStopMake
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel2'
             layout: (LayoutFrame 0 0 -70 1 -2 1 -36 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Build Directory:'
                   name: 'Label1'
                   translateLabel: true
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Finder'
                   name: 'Button13'
                   activeHelpKey: openFinder
                   visibilityChannel: osIsOSX
                   translateLabel: true
                   model: doOpenFinder
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Explorer'
                   name: 'Button14'
                   activeHelpKey: openExplorer
                   visibilityChannel: osIsWindows
                   translateLabel: true
                   model: doOpenExplorer
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Browser'
                   name: 'Button11'
                   activeHelpKey: openFileBrowser
                   translateLabel: true
                   model: doBrowseBuildDirectory
                   useDefaultExtent: true
                 )
                (ViewSpec
                   name: 'Box2'
                   extent: (Point 20 10)
                 )
                (ActionButtonSpec
                   label: 'Clear'
                   name: 'Button12'
                   activeHelpKey: clearBuildDirectory
                   translateLabel: true
                   model: doClearBuildDirectory
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel3'
             layout: (LayoutFrame 0 0 -34 1 -2 1 0 1)
             horizontalLayout: leftSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Terminal in Build Directory'
                   name: 'Button15'
                   activeHelpKey: openTerminal
                   translateLabel: true
                   model: doOpenTerminal
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

page8_deploySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#page8_deploySpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#page8_deploySpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'page8_deploySpec'
       window: 
      (WindowSpec
         label: 'Project Selection'
         name: 'Project Selection'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 520 478)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Files for Deployment'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 5 0 4 1.0 0 1)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'FileBrowserSubCanvas'
                   layout: (LayoutFrame 0 0 0 0 0 1 -34 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   clientHolder: fileBrowserInstance
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel1'
                   layout: (LayoutFrame 0 0 -34 1 -2 1 0 1)
                   horizontalLayout: centerMax
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component: 
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Windows Explorer'
                         name: 'Button1'
                         visibilityChannel: osIsWindows
                         translateLabel: true
                         resizeForLabel: true
                         model: doOpenExplorer
                         useDefaultExtent: true
                       )
                      (ActionButtonSpec
                         label: ' Finder'
                         name: 'Button3'
                         visibilityChannel: osIsOSX
                         translateLabel: true
                         resizeForLabel: true
                         model: doOpenFinder
                         useDefaultExtent: true
                       )
                      (ActionButtonSpec
                         label: 'Terminal'
                         name: 'Button2'
                         translateLabel: true
                         resizeForLabel: true
                         model: doOpenTerminal
                         useDefaultExtent: true
                       )
                      )
                    
                   )
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ProjectBuilderAssistantApplication class methodsFor:'misc specs'!

newProjectsNameListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectBuilderAssistantApplication andSelector:#newProjectsNameListSpec
     Tools::ProjectBuilderAssistantApplication new openInterface:#newProjectsNameListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: newProjectsNameListSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 131 207)
          usePreferredExtent: true
        )
        component: 
       (SpecCollection
          collection: (
           (SequenceViewSpec
              name: 'ReferencePoint2'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              activeHelpKey: listOfNewProjectsName
              model: newProjectsName
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              miniScrollerVertical: false
              useIndex: false
              sequenceList: listOfNewProjectsName
              doubleClickChannel: newProjectsNameListDoubleClickChannel
              usePreferredHeight: true
              useDynamicPreferredHeight: true
            )
           )
         
        )
      )
! !

!ProjectBuilderAssistantApplication class methodsFor:'startup'!

openOn:aProjectDefinitionOrStartupClass
    ^ self new openOn:aProjectDefinitionOrStartupClass

    "Created: / 20-07-2012 / 12:33:25 / cg"
!

openOnPackage:aPackageId
    ^ self new openOnPackage:aPackageId

    "Created: / 20-07-2012 / 13:22:50 / cg"
! !

!ProjectBuilderAssistantApplication methodsFor:'actions'!

buildDirectoryChanged
    self updateButtonEnableState.
!

clearBuildDirectory
    self halt.
!

createNewApplication
    <resource: #uiCallback>

    |newAppName newAppClass|

    newAppName := self newApplicationsName value.
    newAppName isEmptyOrNil ifTrue:[
        Dialog warn:'Please enter the name of the Application-Class first.'.
        ^ self
    ].
    newAppName isUppercaseFirst ifFalse:[
        (Dialog confirm:(resources 
                    stringWithCRs:'Class names must start with an uppercase character.\\Change to "%1"?'
                    with:newAppName asUppercaseFirst))
        ifFalse:[
            ^ self
        ].
        newAppName := newAppName asUppercaseFirst.
        self newApplicationsName value:newAppName.
    ].

    self withWaitCursorDo:[
        Class packageQuerySignal answer:(selectedProjectDefinition package)
        do:[
            newAppClass := ApplicationModel
                            subclass:newAppName asSymbol
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Applications'.
            SmalltalkCodeGeneratorTool createApplicationCodeFor:newAppClass.
        ].
        self updateListOfApplicationsInProject.
        self selectedApplicationIndexHolder value:(listOfApplicationsInProject value indexOf:newAppClass).
    ].

    "Modified: / 31-01-2011 / 18:29:50 / cg"
!

createNewProject
    <resource: #uiCallback>

    |newProjectID projectDefinitionType projectDefinitionClass projectClasses|

    newProjectID := self newProjectsName value.
    newProjectID isEmptyOrNil ifTrue:[
        Dialog warn:(resources string:'Please enter a packageID first.').
        ^ self
    ].
    newProjectID asPackageId isModuleId ifTrue:[
        Dialog warn:(resources stringWithCRs:
'Please enter a corrent packageID.

All packages must be named like "%1:%2"
(%2 can be a path like "dir/dir/...").' with:(resources string:'module')allItalic
                                        with:(resources string:'directory')allItalic).
        ^ self
    ].

    self withWaitCursorDo:[
        projectDefinitionType := self projectType. "/ ProjectDefinition perform:(self projectTypeHolder value).

        projectDefinitionClass := ProjectDefinition
                                    definitionClassForPackage:newProjectID
                                    projectType: projectDefinitionType
                                    createIfAbsent:true.

        projectDefinitionClass compileDescriptionMethods.
        self updateListOfMatchingProjects.
        self updateListOfNewProjectsName.

        self selectedProjectIndexHolder value:( self listOfMatchingProjects value indexOf:projectDefinitionClass).

        projectClasses := projectDefinitionClass allClasses.

"/    projectDefinitionClass isGUIApplication ifTrue:[
"/        "/ see if it has an AppModel class
"/        (projectClasses contains:[:cls | cls isVisualStartable]) ifFalse:[
"/            (Dialog confirm:'Create an Application Class ?') ifTrue:[
"/                self halt.
"/            ].
"/        ].
"/    ].

"/    projectDefinitionClass isLibrary ifFalse:[
"/        "/ see if it has a Startup class
"/        (projectClasses contains:[:cls | cls isStartable]) ifFalse:[
"/        ].
"/    ].

    ].

    "Modified: / 06-08-2012 / 16:55:54 / cg"
!

createNewStartupClass
    <resource: #uiCallback>

    |newClassName newStartupClass startupApplication|

    newClassName := self newStartupClassName value.
    newClassName isEmptyOrNil ifTrue:[
        Dialog warn:'Please enter the name of the Startup-Class first.'.
        ^ self
    ].
    newClassName isUppercaseFirst ifFalse:[
        (Dialog confirm:(resources 
                    stringWithCRs:'Class names must start with an uppercase character.\\Change to "%1"?'
                    with:newClassName asUppercaseFirst))
        ifFalse:[
            ^ self
        ].
        newClassName := newClassName asUppercaseFirst.
        self newStartupClassName value:newClassName.
    ].

    self withWaitCursorDo:[ 
        |pkg|

        pkg := selectedProjectDefinition notNil 
                    ifTrue:[selectedProjectDefinition package]
                    ifFalse:[newProjectsName value].
        Class packageQuerySignal answer:pkg
        do:[
            |startupClass|
            
            startupClass := self projectTypeIsNonGuiApplication
                                ifTrue:[ StandaloneStartupHeadless ]
                                ifFalse:[ StandaloneStartup ]. 
            newStartupClass := startupClass
                            subclass:newClassName asSymbol
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'Applications'.   

            self projectTypeIsGuiApplication ifTrue: [startupApplication := selectedApplication].
            SmalltalkCodeGeneratorTool createStartupCodeFor:newStartupClass forStartOf:startupApplication.
        ].
        self updateListOfStartupClassesInProject.
        self selectedStartupClassIndexHolder value:(listOfStartupClassesInProject value indexOf:newStartupClass).
    ].

    "Modified: / 31-01-2011 / 18:29:47 / cg"
!

doAddClassToProject
    <resource: #uiCallback>

    Transcript showCR:self class name, ': action for doAddClassToProject ...'.
    self halt:'unimplemented'.
!

doBrowseApplication
    <resource: #uiCallback>

    |appClass|

    self hasApplicationSelected ifTrue:[
        appClass := self listOfApplicationsInProject value at:(self selectedApplicationIndexHolder value).
        UserPreferences systemBrowserClass 
            openInClass:appClass class selector:#windowSpec.
    ].
!

doBrowseBuildDirectory
    <resource: #uiCallback>

    projectBuilder isNil ifTrue:[ self getProjectBuilder ].
    projectBuilder buildDirectory isNil ifTrue:[
        Dialog information:'No build directory yet'.
        ^  self
    ].
    UserPreferences fileBrowserClass
        openIn:projectBuilder packageBuildDirectory asFilename
"/    projectBuilder packageBuildDirectory asFilename openExplorer

    "Created: / 20-08-2012 / 17:05:54 / cg"
!

doBrowseProject
    <resource: #uiCallback>

    UserPreferences systemBrowserClass openOnPackage:selectedProjectDefinition package.
!

doBrowseProjectDefinitionClass
    <resource: #uiCallback>

    |defClass|

    self hasProjectSelected ifTrue:[
        defClass := self selectedProjectDefinition.
        UserPreferences systemBrowserClass 
            openInClass:defClass class selector:#classNamesAndAttributes.
    ].
!

doBrowseProjectDefinitionClassForPrereqs
    <resource: #uiCallback>

    |defClass|

    self hasProjectSelected ifTrue:[
        defClass := self selectedProjectDefinition.
        UserPreferences systemBrowserClass 
            openInClass:defClass class selector:#referencedPreRequisites "/ #mandatoryPreRequisites.
    ].
!

doBrowseStartupClass
    <resource: #uiCallback>

    |startupClass|

    self hasStartupClassSelected ifTrue:[
        startupClass := self listOfStartupClassesInProject value at:(self selectedStartupClassIndexHolder value).
        UserPreferences systemBrowserClass 
            openInClass:startupClass class selector:#main:.
    ].
!

doCheckin
    <resource: #uiCallback>

    |package utilities|

    package := selectedProjectDefinition package.
    utilities := (AbstractSourceCodeManager managerForPackage:package) utilities.

    AbortAllOperationRequest catch:[
        self withWaitCursorDo:[
            utilities
                checkinPackage:package
                classes:true
                extensions:true
                buildSupport:true
                askForMethodsInOtherPackages:true
        ]
    ]
!

doClearBuildDirectory
    <resource: #uiCallback>

    projectBuilder isNil ifTrue:[ self getProjectBuilder ].
    projectBuilder buildDirectory notNil ifTrue:[   
        self withWaitCursorDo:[
            projectBuilder packageBuildDirectory asFilename recursiveRemove
        ]
    ].

    "Created: / 05-09-2012 / 10:35:54 / cg"
!

doGenerateProjectContentsDefinition
    self generatePackageContentsMethods
!

doGenerateProjectPrerequisitesDefinition
    self generatePackageContentsMethods

    "Created: / 19-01-2012 / 15:44:23 / cg"
!

doLaunchApplication
    <resource: #uiCallback>

    |appClass|

    self hasApplicationSelected ifTrue:[
        appClass := self listOfApplicationsInProject value at:(self selectedApplicationIndexHolder value).
        appClass open.
    ].
!

doOpenExplorer
    projectBuilder isNil ifTrue:[ self getProjectBuilder ].
    projectBuilder buildDirectory isNil ifTrue:[
        Dialog information:'No build directory yet'.
        ^  self
    ].
    projectBuilder packageBuildDirectory asFilename openExplorer

    "Modified: / 21-07-2012 / 12:29:21 / cg"
!

doOpenFinder
    projectBuilder isNil ifTrue:[ self getProjectBuilder ].
    projectBuilder buildDirectory isNil ifTrue:[
        Dialog information:'No build directory yet'.
        ^  self
    ].
    projectBuilder packageBuildDirectory asFilename openFinder

    "Modified: / 21-07-2012 / 12:29:21 / cg"
!

doOpenTerminal
    projectBuilder isNil ifTrue:[ self getProjectBuilder ].
    projectBuilder buildDirectory isNil ifTrue:[
        Dialog information:'No build directory yet'.
        ^  self
    ].
    projectBuilder packageBuildDirectory asFilename openTerminal
!

doStartMake:whichTarget
    <resource: #uiCallback>

    self stopMakeButtonVisible value:true.
    self startMakeButtonEnabled value:false.

    self infoHolder value:'Building (make) - please wait...'.
    makeOutputWindow clear.

    makeProcess := 
            [
                [
                    self runBuildProcess:whichTarget
                ] ensure:[
                    self stopMakeButtonVisible value:false.
                    self startMakeButtonEnabled value:true.
                    makeProcess := nil.
                    self updateButtonEnableState.
                    self infoHolder value:''.
                ].
            ] newProcess.

    makeProcess priority:4.
    makeProcess priorityRange:(4 to:8).
    makeProcess resume.
!

doStartMakeAll
    <resource: #uiCallback>

    self doStartMake:'all'
!

doStartMakeApp
    <resource: #uiCallback>

    self doStartMake:'app'
!

doStartMakeExe
    <resource: #uiCallback>

    self doStartMake:'exe'
!

doStartMakeExeQuick
    <resource: #uiCallback>

    self doStartMake:'exeQuick'
!

doStopMake
    <resource: #uiCallback>

    |p|

    (p := makeProcess) notNil ifTrue:[
        makeProcess := nil.
        self withWaitCursorDo:[
            p terminate.
            p waitUntilTerminated.
        ].
        makeOutputWindow endEntry.
        makeOutputWindow cr.
        makeOutputWindow nextPutLine:('Make Cancelled' colorizeAllWith:Color white on:Color red).
        makeOutputWindow endEntry.
    ].

    "Modified: / 26-09-2012 / 21:01:37 / cg"
!

fetchSelectedProject
    |selectedProjectIndex|

    selectedProjectIndex := self selectedProjectIndexHolder value.
    (selectedProjectIndex ? 0) == 0 ifTrue:[
        selectedProjectDefinition := nil.
    ] ifFalse:[
        selectedProjectDefinition := self listOfMatchingProjects value at:(selectedProjectIndex).
    ].
    self hasProjectSelectedHolder value:(selectedProjectDefinition notNil).

    "Created: / 04-09-2012 / 09:52:32 / cg"
!

getProjectBuilder
    projectBuilder := ProjectBuilder new.
    projectBuilder package:(selectedProjectDefinition package).
    projectBuilder usedCompilerForBuild:(usedCompilerHolder value).
    ^ projectBuilder

    "Created: / 26-09-2012 / 20:57:32 / cg"
!

projectTypeChanged
    <resource: #uiCallback>

    self updateListOfMatchingProjects
!

runBuildProcess:what
    <resource: #uiCallback>

    self assert:makeOutputWindow notNil.
    self assert:makeOutputWindow model == self makeOutputHolder.

    ActivityNotification handle:[:ex |
        ex messageText notNil ifTrue:[
            makeOutputWindow endEntry.
            makeOutputWindow cr.
            makeOutputWindow nextPutLine:(ex messageText colorizeAllWith:Color white on:Color blue).
            makeOutputWindow endEntry.
        ].
        ex proceed.
    ] do:[
        self getProjectBuilder.
        projectBuilder makeExeOnly:((what = 'exe') or:[what = 'exeQuick']).
        projectBuilder makeAppOnly:(what = 'app').
        projectBuilder makeQuick:(what = 'exeQuick').

        Error handle:[:ex |
            ex creator = MessageNotUnderstood ifTrue:[ex reject].

            makeOutputWindow endEntry.
            makeOutputWindow cr.
            makeOutputWindow nextPutLine:(ex description colorizeAllWith:Color white on:Color red).
            makeOutputWindow endEntry.
            Debugging == true ifTrue:[ ex reject ].
            ex proceed.
        ] do:[
            projectBuilder buildWithColorizedOutputTo:makeOutputWindow.
        ].
    ].

    "
     Debugging := true.   
     Debugging := false.   
    "

    "Modified: / 07-06-2016 / 11:00:01 / cg"
!

selectedApplicationChanged
    |idx|

    ((idx := self selectedApplicationIndexHolder value) isNil
    or:[idx == 0]) ifTrue:[
        selectedApplication := nil.
    ] ifFalse:[
        selectedApplication := self listOfApplicationsInProject value at:idx.
    ].
    self hasApplicationSelectedHolder value:(selectedApplication notNil).

"/    selectedApplication notNil ifTrue:[
"/        "/ generate startupClass code
"/        CodeGeneratorTool
"/            compile:(selectedProjectDefinition startupClassName_codeFor:(selectedApplication name))
"/            forClass:selectedProjectDefinition theMetaclass
"/            inCategory:'description - startup'.
"/    ].
    self updateApplicationComment.
    self updateButtonEnableState.
!

selectedProjectChanged
    self fetchSelectedProject.

    self updateComment.
    self updateListOfApplicationsInProject.
    self updateButtonEnableState.

    "Modified: / 04-09-2012 / 09:52:43 / cg"
!

selectedStartupClassChanged
    self selectedStartupClassIndexHolder value isNil ifTrue:[
        selectedStartupClass := nil.
    ] ifFalse:[
        selectedStartupClass := self listOfStartupClassesInProject value at:(self selectedStartupClassIndexHolder value).
    ].
    self hasStartupClassSelectedHolder value:(selectedStartupClass notNil).

    selectedStartupClass notNil ifTrue:[
        "/ generate startupClass code
        Class packageQuerySignal
            answer:selectedProjectDefinition package
            do:[
                SmalltalkCodeGeneratorTool
                    compile:(selectedProjectDefinition startupClassName_codeFor:(selectedStartupClass name))
                    forClass:selectedProjectDefinition theMetaclass
                    inCategory:'description - startup'.
            ]
    ].
    self updateButtonEnableState.

    "Modified: / 31-01-2011 / 18:29:42 / cg"
! !

!ProjectBuilderAssistantApplication methodsFor:'aspects'!

buildDirectoryHolder
    <resource: #uiAspect>

    |buildDirectory|

    buildDirectoryHolder isNil ifTrue:[
        buildDirectoryHolder := nil asValue.
        buildDirectoryHolder onChangeSend:#buildDirectoryChanged to:self.
    ].
    buildDirectoryHolder value isEmptyOrNil ifTrue:[
        buildDirectory := ProjectBuilder previousBuildDirectory.
        buildDirectory isNil ifTrue:[
            buildDirectory := UserPreferences current buildDirectory.
            buildDirectory isNil ifTrue:[
                buildDirectory := Filename tempDirectory construct:'stx_build'.
            ].
        ].
        buildDirectoryHolder value: buildDirectory.
    ].
    ^ buildDirectoryHolder.
!

companyNameHolder
    <resource: #uiAspect>

    companyNameHolder isNil ifTrue:[
        companyNameHolder := 'MyCompany' asValue.
    ].
    ^ companyNameHolder.
!

compilerWarnMessageHolder
    <resource: #uiAspect>

    compilerWarnMessageHolder isNil ifTrue:[
        compilerWarnMessageHolder := '' asValue.
    ].
    ^ compilerWarnMessageHolder.
!

compilerWarnMessageVisibleHolder
    <resource: #uiAspect>

    compilerWarnMessageVisibleHolder isNil ifTrue:[
        compilerWarnMessageVisibleHolder := false asValue.
    ].
    ^ compilerWarnMessageVisibleHolder.
!

execuableNameVisible
    ^ self projectTypeIsNonGuiApplication
!

executableNameHolder
    |holder|

    (holder := builder bindingAt:#executableNameHolder) isNil ifTrue:[
        builder aspectAt:#executableNameHolder put:(holder := nil asValue).
    ].
    ^ holder.
!

hasApplicationSelectedHolder
    <resource: #uiAspect>

    hasApplicationSelectedHolder isNil ifTrue:[
        hasApplicationSelectedHolder := nil asValue.
    ].
    ^ hasApplicationSelectedHolder.
!

hasProjectSelectedHolder
    <resource: #uiAspect>

    hasProjectSelectedHolder isNil ifTrue:[
        hasProjectSelectedHolder := nil asValue.
    ].
    ^ hasProjectSelectedHolder.
!

hasStartupClassSelectedHolder
    <resource: #uiAspect>

    hasStartupClassSelectedHolder isNil ifTrue:[
        hasStartupClassSelectedHolder := nil asValue.
    ].
    ^ hasStartupClassSelectedHolder.
!

hideOtherApplicationClasses
    <resource: #uiAspect>

    hideOtherApplicationClasses isNil ifTrue:[
        hideOtherApplicationClasses := true asValue.
        hideOtherApplicationClasses onChangeSend:#updateListOfApplicationsInProject to:self.
    ].
    ^ hideOtherApplicationClasses.
!

hideOtherStartupClasses
    <resource: #uiAspect>

    hideOtherStartupClasses isNil ifTrue:[
        hideOtherStartupClasses := true asValue.
        hideOtherStartupClasses onChangeSend:#updateListOfStartupClassesInProject to:self.
    ].
    ^ hideOtherStartupClasses.
!

hideSTXProjects
    <resource: #uiAspect>

    hideSTXProjects isNil ifTrue:[
        hideSTXProjects := true asValue.
        hideSTXProjects onChangeSend:#updateListOfMatchingProjects to:self.
    ].
    ^ hideSTXProjects.
!

listOfApplicationsInProject
    <resource: #uiAspect>

    listOfApplicationsInProject isNil ifTrue:[
        listOfApplicationsInProject := ValueHolder new.
    ].
    ^ listOfApplicationsInProject.
!

listOfClassesInProject
    <resource: #uiAspect>

    listOfClassesInProject isNil ifTrue:[
        listOfClassesInProject := ValueHolder new.
    ].
    ^ listOfClassesInProject.
!

listOfMatchingPackageIds
    <resource: #uiAspect>

    listOfMatchingPackageIds isNil ifTrue:[
        listOfMatchingPackageIds := ValueHolder new.
    ].
    ^ listOfMatchingPackageIds.
!

listOfMatchingProjects
    <resource: #uiAspect>

    listOfMatchingProjects isNil ifTrue:[
        listOfMatchingProjects := ValueHolder new.
    ].
    ^ listOfMatchingProjects.
!

listOfNewProjectsName

    <resource: #uiAspect>

    listOfNewProjectsName isNil ifTrue:[
        listOfNewProjectsName := ValueHolder new.
    ].
    ^ listOfNewProjectsName.
!

listOfPossibleCompilers
    ^ Tools::ProjectBuilder listOfPossibleCompilers

    "Modified: / 05-09-2012 / 19:10:24 / cg"
!

listOfPrerequisitesInProject
    <resource: #uiAspect>

    listOfPrerequisitesInProject isNil ifTrue:[
        listOfPrerequisitesInProject := ValueHolder new.
    ].
    ^ listOfPrerequisitesInProject.

    "Created: / 19-01-2012 / 15:39:34 / cg"
!

listOfStartupClassesInProject
    <resource: #uiAspect>

    listOfStartupClassesInProject isNil ifTrue:[
        listOfStartupClassesInProject := ValueHolder new.
    ].
    ^ listOfStartupClassesInProject.
!

makeOutputHolder
    <resource: #uiAspect>

    makeOutputHolder isNil ifTrue:[
        makeOutputHolder := ValueHolder new.
    ].
    ^ makeOutputHolder.
!

nameOfUsedCompilerSuiteHolder
    <resource: #uiAspect>

    nameOfUsedCompilerSuiteHolder isNil ifTrue:[
        nameOfUsedCompilerSuiteHolder := nil asValue.
    ].
    ^ nameOfUsedCompilerSuiteHolder.

    "Created: / 03-09-2012 / 19:32:27 / cg"
!

newApplicationsName
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    newApplicationsName isNil ifTrue:[
        newApplicationsName := ValueHolder new.
    ].
    ^ newApplicationsName.
!

newProjectsName
    <resource: #uiAspect>

    newProjectsName isNil ifTrue:[
        newProjectsName := nil asValue.
    ].
    ^ newProjectsName.
!

newProjectsNameListDoubleClickChannel
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#newProjectsNameListDoubleClickChannel) isNil ifTrue:[
        holder := TriggerValue new.
        builder aspectAt:#newProjectsNameListDoubleClickChannel put:holder.
        holder onChangeEvaluate:[       
            newProjectsNameListExtendedComboBox notNil ifTrue: [
                newProjectsNameListExtendedComboBox closeMenu.
            ]
        ]
    ].
    ^ holder.
!

newStartupClassName
    <resource: #uiAspect>

    newStartupClassName isNil ifTrue:[
        newStartupClassName := ValueHolder new.
    ].
    ^ newStartupClassName.
!

osIsOSX
   ^ OperatingSystem isOSXlike
!

osIsUnix
   ^ OperatingSystem isUNIXlike 
!

osIsWindows
   ^ OperatingSystem isMSWINDOWSlike
!

productNameHolder
    <resource: #uiAspect>

    productNameHolder isNil ifTrue:[
        productNameHolder := 'MyProduct' asValue.
    ].
    ^ productNameHolder.
!

projectType
    ^ self projectTypeHolder value

    "Modified: / 20-07-2012 / 13:28:46 / cg"
!

projectType:aProjectTypeSymbol
    self assert:(ProjectDefinition projectTypes includes:aProjectTypeSymbol).
    self projectTypeHolder value:aProjectTypeSymbol

    "Modified: / 20-07-2012 / 13:28:25 / cg"
!

projectTypeHolder
    <resource: #uiAspect>

    projectTypeHolder isNil ifTrue:[
        projectTypeHolder := RadioButtonGroup new.
        projectTypeHolder value:ProjectDefinition guiApplicationType.
    ].
    ^ projectTypeHolder.

    "Modified: / 20-07-2012 / 13:30:16 / cg"
!

selectedApplicationIndexHolder
    <resource: #uiAspect>

    selectedApplicationIndexHolder isNil ifTrue:[
        selectedApplicationIndexHolder := ValueHolder new.
        selectedApplicationIndexHolder onChangeSend:#selectedApplicationChanged to:self.
    ].
    ^ selectedApplicationIndexHolder.
!

selectedApplicationsComment
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    selectedApplicationsComment isNil ifTrue:[
        selectedApplicationsComment := '' asValue.
    ].
    ^ selectedApplicationsComment.
!

selectedProjectDefinition
    <resource: #uiAspect>

    ^ selectedProjectDefinition.
!

selectedProjectIndexHolder
    <resource: #uiAspect>

    selectedProjectIndexHolder isNil ifTrue:[
        selectedProjectIndexHolder := ValueHolder new.
        selectedProjectIndexHolder onChangeSend:#selectedProjectChanged to:self.
    ].
    ^ selectedProjectIndexHolder.
!

selectedProjectsComment
    <resource: #uiAspect>

    selectedProjectsComment isNil ifTrue:[
        selectedProjectsComment := '' asValue.
    ].
    ^ selectedProjectsComment.
!

selectedStartupClassIndexHolder
    <resource: #uiAspect>

    selectedStartupClassIndexHolder isNil ifTrue:[
        selectedStartupClassIndexHolder := ValueHolder new.
        selectedStartupClassIndexHolder onChangeSend:#selectedStartupClassChanged to:self.
    ].
    ^ selectedStartupClassIndexHolder.
!

startMakeButtonEnabled
    <resource: #uiAspect>

    startMakeButtonEnabled isNil ifTrue:[
        startMakeButtonEnabled := true asValue.
    ].
    ^ startMakeButtonEnabled.
!

stopMakeButtonVisible
    <resource: #uiAspect>

    stopMakeButtonVisible isNil ifTrue:[
        stopMakeButtonVisible := false asValue.
    ].
    ^ stopMakeButtonVisible.
!

usedCompilerHolder
    <resource: #uiAspect>

    usedCompilerHolder isNil ifTrue:[
        usedCompilerHolder := ValueHolder new.
        usedCompilerHolder value:(LastUsedCompiler ? ProjectBuilder defaultUsedCompiler).
        usedCompilerHolder onChangeSend:#checkCompilerAvailability to:self.
    ].
    ^ usedCompilerHolder.

    "Modified: / 04-09-2012 / 09:43:20 / cg"
! !

!ProjectBuilderAssistantApplication methodsFor:'initialization & release'!

fileBrowserInstance
    "setup the embedded fileBrowser (in the last page)"

    |targetDirectory browser|

    targetDirectory := projectBuilder packageBuildDirectory.

    browser := FileBrowserV2 new.
    browser onDirectory:targetDirectory.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        browser filter:'*.exe;*.com'.
    ] ifFalse:[
        browser filter:'*'.
    ].
    ^ browser.
!

openOn:aProjectDefinitionOrStartupClass
    |type "apps" projectDefinitionClass startupClass pageToGo|

    self allButOpen.
    (aProjectDefinitionOrStartupClass inheritsFrom:StandaloneStartup) ifTrue:[
        startupClass := aProjectDefinitionOrStartupClass.
        type := ProjectDefinition nonGuiApplicationType.
        projectDefinitionClass := startupClass projectDefinitionClass.
        (projectDefinitionClass startupClass == startupClass) ifFalse:[
            self halt.
        ].    
    ] ifFalse:[ 
        projectDefinitionClass := aProjectDefinitionOrStartupClass.
        projectDefinitionClass isFolderForProjectsDefinition ifFalse:[
            projectDefinitionClass isLibraryDefinition ifTrue:[
                type := ProjectDefinition libraryType
            ] ifFalse:[
                projectDefinitionClass isGUIApplication ifTrue:[
                    type := ProjectDefinition guiApplicationType.
                    startupClass := projectDefinitionClass startupClass
                ] ifFalse:[
                    type := ProjectDefinition nonGuiApplicationType.
                    startupClass := projectDefinitionClass startupClass
                ]
            ].
        ].
    ].
    self projectTypeHolder value:type.
    self hideSTXProjects value:false.
    selectedProjectDefinition := projectDefinitionClass.
    self selectedProjectIndexHolder value:(self listOfMatchingPackageIds value indexOf:projectDefinitionClass package).
    self hasProjectSelectedHolder value:true.

    pageToGo := 2.
    (type == ProjectDefinition guiApplicationType) ifTrue:[
        pageToGo := 3.
        startupClass notNil ifTrue:[
            self updateListOfStartupClassesInProject.
            selectedStartupClass := startupClass.
            self selectedStartupClassIndexHolder value:(self listOfStartupClassesInProject value indexOf:startupClass).
            pageToGo := 5.
        ]. 
        "/ apps := (aProjectDefinitionClass classes select:[:cls | cls isKindOf:ApplicationModel])
    ].
    (type == ProjectDefinition nonGuiApplicationType) ifTrue:[
        pageToGo := 4.
        startupClass notNil ifTrue:[
            self updateListOfStartupClassesInProject.
            selectedStartupClass := startupClass.
            self selectedStartupClassIndexHolder value:(self listOfStartupClassesInProject value indexOf:startupClass).
            pageToGo := 5.
        ]. 
    ].
    self gotoPage:pageToGo.
    self openWindow.

    "Created: / 20-07-2012 / 12:34:02 / cg"
!

openOnPackage:aPackageId
    self allButOpen.
    self projectTypeHolder value:(ProjectDefinition guiApplicationType).
    self hideSTXProjects value:false.
    self selectedProjectIndexHolder value:(self listOfMatchingPackageIds indexOf:aPackageId).
    self hasProjectSelectedHolder value:true.
    self gotoPage:2.
    self openWindow.

    "Created: / 20-07-2012 / 13:24:38 / cg"
!

postBuildMakeOutputWindow:aView
    makeOutputWindow := aView.
    makeOutputWindow lineLimit:10000.

    "Modified: / 05-09-2012 / 11:11:45 / cg"
!

postBuildNewProjectsNameListExtendedComboBox:anExtendedComboBox

    |menu|

    menu := SubCanvas new.
    menu client:self spec:#newProjectsNameListSpec builder:nil.
    anExtendedComboBox closeOnSelect: false.
    anExtendedComboBox menuWidget:menu.

    anExtendedComboBox editor 
            immediateAccept:true;
            acceptOnLeave:true;
            acceptOnLostFocus:true;
            acceptOnPointerLeave:true;
            acceptOnReturn:true;
            acceptOnTab:true.

    newProjectsNameListExtendedComboBox := anExtendedComboBox.
!

postBuildWarnMessageView:aView
    aView font:(Label defaultFont).

    "Created: / 05-09-2012 / 19:34:29 / cg"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self updateListOfMatchingProjects.
    self updateListOfNewProjectsName.

    Smalltalk addDependent:self.
!

release
    Smalltalk removeDependent:self.
    super release
! !

!ProjectBuilderAssistantApplication methodsFor:'menu actions'!

openDocumentation
   self openHTMLDocument:'tools/misc/TOP.html#PACKAGER'.
! !

!ProjectBuilderAssistantApplication methodsFor:'private'!

commentFromClass:aClass
    |docMethod comment indents minIndent maxLineLength|

    docMethod := aClass class compiledMethodAt:#documentation.
    docMethod notNil ifTrue:[
        comment := docMethod comment.
        comment := comment asStringCollection 
                        collect:[:line | line withoutTrailingSeparators].
        [comment notEmpty and:[comment first isBlank]] whileTrue:[ comment removeFirst ].
        maxLineLength := (comment collect:[:line | line size]) max.
        indents := comment collect:[:line | 
                                        line isEmptyOrNil
                                            ifTrue:[maxLineLength]
                                            ifFalse:[ line findFirst:[:ch | ch isSeparator not]]].
        (minIndent := indents min) > 1 ifTrue:[
            comment := comment collect:[:line | line copyFrom:minIndent].
        ].
        comment := comment asString.
    ].
    ^ comment
!

generatePackageContentsMethods
    <resource: #uiCallback>

    selectedProjectDefinition
        updateContentsMethodsCodeUsingCompiler:SmalltalkCodeGeneratorTool 
        ignoreOldDefinition:true.

"/    Class packageQuerySignal answer:(selectedProjectDefinition package)
"/    do:[
"/        selectedProjectDefinition 
"/            forEachContentsMethodsCodeToCompileDo:[:code :category |
"/                    SmalltalkCodeGeneratorTool
"/                        compile:code
"/                        forClass:selectedProjectDefinition theMetaclass
"/                        inCategory:category.
"/                ]
"/            ignoreOldDefinition:true
"/    ].
    self updateListOfClassesInProject

    "Modified: / 31-01-2011 / 18:29:44 / cg"
!

hasApplicationSelected
    ^ self selectedApplicationIndexHolder value notNil
!

hasBuildDirectorySpecified
    ^ self buildDirectoryHolder value notEmptyOrNil
!

hasProjectBuilder
    ^ projectBuilder notNil
!

hasProjectSelected
    ^ self selectedProjectIndexHolder value notNil
!

hasStartupClassSelected
    ^ self selectedStartupClassIndexHolder value notNil
! !

!ProjectBuilderAssistantApplication methodsFor:'queries'!

canEnterApplicationSelection
    self hasProjectSelected ifFalse:[
        self infoHolder value:'no project selected'. 
        ^ false
    ].
    ^ true

    "Modified: / 23-08-2011 / 12:12:35 / cg"
!

canEnterBuild
    self hasBuildDirectorySpecified ifFalse:[
        self infoHolder value:'no build directory specified'. 
        ^ false
    ].
    ^ true

    "Modified: / 23-08-2011 / 12:13:29 / cg"
!

canEnterContentsSelection
    |prj cls impl mthd|

    self hasProjectSelected ifFalse:[
        self infoHolder value:'no project selected'. 
        ^ false
    ].
    "self hasApplicationSelected ifFalse:[^ false]." 
    (self projectTypeIsLibrary or:[self hasStartupClassSelected]) ifFalse:[
        self infoHolder value:'Must be either library or have a startup class'. 
        ^ false
    ].
    prj := self selectedProjectDefinition.
    prj isLibraryDefinition ifFalse:[
        ([prj startupClassName] on:Error do:nil) notNil ifFalse:[
            self infoHolder value:'Must have a startup class'. 
            ^ false
        ].
        ([prj startupSelector] on:Error do:nil) notNil ifFalse:[
            self infoHolder value:'Must have a startup selector'. 
            ^ false
        ].
        (prj class compiledMethodAt:#startupSelector) isNil ifTrue:[
            self infoHolder value:('Inherited startup selector is "%1"' bindWith:prj startupSelector). 
            impl := prj class whichClassImplements:#startupSelector.
            impl isNil ifTrue:[
                self infoHolder value:('Inherited startup selector (%1) not implemented in %2' 
                                        bindWith:prj startupSelector
                                        with:prj class name). 
                ^ false
            ].
        ].
        (mthd := prj class compiledMethodAt:#startupClassName) package == prj package ifFalse:[
            mthd package == PackageId noProjectID ifFalse:[
                self infoHolder value:('Startup class method (#startupClassName) of %3 must be in package "%1" (is in "%2")' 
                    bindWith:prj package
                    with:(prj class compiledMethodAt:#startupClassName) package
                    with:prj class name). 
                ^ false
            ].
        ].
        (mthd := prj class compiledMethodAt:#startupSelector) notNil ifTrue:[
            mthd package == prj package ifFalse:[
                mthd package == PackageId noProjectID ifFalse:[
                    self infoHolder value:('Startup class method (#startupSelector) of %3 must be in package "%1" (is in "%2")' 
                        bindWith:prj package
                        with:mthd package 
                        with:prj class name). 
                    ^ false
                ]
            ].
        ].
        cls := Smalltalk classNamed:prj startupClassName.
        cls isNil ifTrue:[
            self infoHolder value:('Startup class "%1" does not exist' bindWith:prj startupClassName).
            ^ false.
        ].
        (cls implements:(prj startupSelector)) ifFalse:[
            (cls respondsTo:(prj startupSelector)) ifFalse:[
                self infoHolder value:('Startup class "%1" does not implement startup selector "%2"' 
                        bindWith:cls name
                        with:prj startupSelector). 
                ^ false
            ].
        ].
    ].
    self infoHolder value:nil.
    ^ true.

    "Modified: / 04-09-2012 / 10:29:43 / cg"
!

canEnterDeploy
    self hasProjectBuilder ifFalse:[
        self infoHolder value:'Nothing to deploy (please build first)'. 
        ^ false
    ].
    self infoHolder value:nil. 
    ^ true

    "Modified: / 04-09-2012 / 10:30:18 / cg"
!

canEnterPrerequisitesSelection
    |prj cls impl|

    self hasProjectSelected ifFalse:[
        self infoHolder value:'no project selected'. 
        ^ false
    ].
    ^ true.

    "Created: / 19-01-2012 / 15:37:30 / cg"
!

canEnterStartupClassSelection
    self hasProjectSelected ifFalse:[
        self infoHolder value:'no project selected'. 
        ^ false
    ].
    ^ self hasProjectSelected "and:[ self hasApplicationSelected ]"

    "Modified: / 23-08-2011 / 12:16:35 / cg"
!

projectTypeIsGuiApplication
    ^ self projectType == ProjectDefinition guiApplicationType

    "Modified: / 20-07-2012 / 13:29:59 / cg"
!

projectTypeIsLibrary
    ^ self projectType == ProjectDefinition libraryType

    "Modified: / 20-07-2012 / 13:29:24 / cg"
!

projectTypeIsNonGuiApplication
    ^ self projectType == ProjectDefinition nonGuiApplicationType
!

projectTypeIsNotLibrary
    ^ self projectTypeIsLibrary not
! !

!ProjectBuilderAssistantApplication methodsFor:'specs'!

assistantSpec
    |specs|

    specs := OrderedCollection new.
    specs add:
        #( AssistantPageSpec
            pageTitle: 'Project Type Selection'
            windowSpecSelector: page1_projectTypeSelectionSpec
            enterCallbackSelector: updateListOfMatchingProjects
            infoText: 'Define the <B>type</B> of project you are about to build.<P>
Choose <B>GUI-application</B> for a program which will show a graphical user interface,
<br><B>non-GUI-program</b> for a console program, 
<br>and <B>library</b>, for a framework to be
used by other programs (a loadable shared binary class library).'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'ProjectDefinition Selection'
            windowSpecSelector: page2_projectSelectionSpec
            enterCallbackSelector: updateListOfMatchingProjectsAndProjectIDs
            leaveCallbackSelector: fetchAttributesFromProjectDefinition
            infoText: 'Choose either an existing project definition or create a new one. 
These are subclasses of <I>ProjectDefinition</I> and define the type, name and contents of a project. 
<p>
Please enter a project-identifier which must have a well defined format in Smalltalk/X.
Notice that the ID directly reflects the project''s location within the source code repository 
(module:directoryPath). 
<br>If in doubt, use "<b>&lt;yourname&gt;:demos/xxx_n</b>".'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Startup Application Selection'
            windowSpecSelector: page3_applicationSelectionSpec
            isEnabledQuerySelector: #projectTypeIsGuiApplication
            canEnterQuerySelector: #canEnterApplicationSelection
            enterCallbackSelector: updateListOfApplicationsInProject
            infoText: 'Choose an existing application or create a new one. 
These are subclasses of <I>ApplicationModel</I> and define the GUI and control flow inside the application. 
Can also be left blank if the startup class does it all (stx build).'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Startup Class Selection'
            windowSpecSelector: page4_startupClassSelectionSpec
            isEnabledQuerySelector: #projectTypeIsNotLibrary
            canEnterQuerySelector: #canEnterStartupClassSelection
            enterCallbackSelector: updateListOfStartupClassesInProject
            infoText: 'Choose an existing startup-class or create a new one. 
<p>These are subclasses of <I>StandaloneStartup</I> and contain the main function,
which either starts the application (in case of a GUI application)
or directly performs the program''s task (in case of a non-GUI console program).<br> 
Command line arguments are usually interpreted there.
<p>Do not use one of the "StandAloneStartup"-classes, which you may find in the system: 
these are abstract, and to be used as superclass of your concrete startup.
<p>For a quick demo, enter a reasonable name, and press the "Create" button.'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Specify Contents'
            windowSpecSelector: page5_specifyIncludedClasses
            enterCallbackSelector: enterContentsSpecification
            canEnterQuerySelector: #canEnterContentsSelection
            infoText: 'Check the list of other classes which are to be included. 
These are the classes which comprise your application 
(excluding any libraries, which are specified in the next step).
<p>
Press "<I>Update List</I>" to search for and include all classes of the package. 
<p>
Press "<I>Browse</I>" to edit the contents manually (this opens an editor on the defining method
in your project definition class).'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Specify Prerequisites'
            windowSpecSelector: page5b_specifyPrerequisitePackages
            enterCallbackSelector: enterPrerequisitesSpecification
            canEnterQuerySelector: #canEnterPrerequisitesSelection
            infoText: 'Check the list of packages/libraries which are needed as prerequisites. 
These are required class libraries which should be packaged together with the application,
and will be present in the deployed binary.
<p>
Non-GUI programs will typically only require the basic class library 
and libcomp (the parser and bytecode compiler) to be read startup scripts and patches.
<p>
GUI programs will require a number of view- and widget support classes, which contain the
graphical user interface support classes.
<p>
Press "<I>Update</I>" to search for and include prerequisites.
<p>
"<I>Browse</I>" to edit the list manually.'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Specify Project Attributes'
            windowSpecSelector: page6a_specifyProjectAttributes
            infoText: 'Define additional attributes. 
These will be shown during the installation of the deployed package and affect the name of the deployed self-installable file.'
            enterCallbackSelector: updateProjectAttributes
            leaveCallbackSelector: #rememberProjectAttributes
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Specify Build Directory'
            windowSpecSelector: page6b_specifyBuildDirectorySpec
            infoText: 'Define where the build-process is to be performed and which compiler to use. 
<P>All generated files are created below that directory. 
<P>After deployment, the build directory is no longer needed 
(but you can keep it for a faster compile the next time).
<P>Normally, the default values are ok, and there is no need to change anything here.'
            enterCallbackSelector: #checkCompilerAvailability
            leaveCallbackSelector: #rememberUsedCompiler
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Check Into Source Repository'
            windowSpecSelector: page7a_checkinSpec
            enterCallbackSelector: #checkSourceCodeManagerType
            infoText: 'Optionally check the package''s source and build-support files into the 
source code repository.
<p>You can skip this for a quick test (a local build), 
or if you do not have/want a central repository.'
        ) decodeAsLiteralArray.

    specs add:
        #(AssistantPageSpec
            pageTitle: 'Build'
            windowSpecSelector: page7b_buildSpec
            canEnterQuerySelector: #canEnterBuild
            enterCallbackSelector: #restoreMakeOutputsContents
            leaveCallbackSelector: #rememberMakeOutputsContents
            infoText: 'Start the build-process. This will create an isolated build directory,
and run "<i>make</i>" there to compile all required classes.
<P>            
On Windows, it will use "<i>nsis</i>" to generate a self-installable executable, 
and you must have the compiler (borland-bcc, visual-c or mingw) and NullSoft NSIS packages installed for this to work.
Without NSIS, you can "zip" the folder where the "exe" is generated 
and unzip on a target machine.
<P>
On OS X, it will generate a "dmg" for deployment. You should have XCode or the "gcc" tool chain installed.
<P>
On Linux, an installable package will be generated. You should have the development support packages installed (gcc, Xlib etc.).
<P>
To try the application, open an Explorer/Finder on the directory and double click on the executable.
Alternatively, open a command window and type the name of the executable there. 
Sorry, but double-click in the ST/X file browser does not work.'
        ) decodeAsLiteralArray.

    self projectTypeIsLibrary ifTrue:[
        specs add:
            #(AssistantPageSpec
                pageTitle: 'Deploy'
                windowSpecSelector: page8_deploySpec
                canEnterQuerySelector: #canEnterDeploy
                enterCallbackSelector: enterDeploySpecification
                infoText: 'Find the generated binary class library file here.
Because this is a library package (i.e. no application package), 
there is no deployable installer generated, just the binary (.so / .dll).'
            ) decodeAsLiteralArray.
    ] ifFalse:[   
        specs add:
            #(AssistantPageSpec
                pageTitle: 'Deploy'
                windowSpecSelector: page8_deploySpec
                canEnterQuerySelector: #canEnterDeploy
                enterCallbackSelector: enterDeploySpecification
                infoText: 'Find the installer-file to be deployed (or test-run the executable). 
You can open an Explorer/Finder there to copy the files for deployment. 
After that, the build directory is no longer needed. 
However, you can keep it for a faster compile the next time.'
            ) decodeAsLiteralArray.
    ].
    ^ specs.

    "Modified: / 04-09-2012 / 09:49:50 / cg"
! !

!ProjectBuilderAssistantApplication methodsFor:'update'!

checkCompilerAvailability
    |cmd suite warnMsg1 warnMsg2 sep usedCompiler|

    cmd := 'cc'.
    warnMsg1 := warnMsg2 := ''.

    usedCompiler := self usedCompilerHolder value.
    usedCompiler = 'bcc' ifTrue:[
        cmd := 'bcc32'.
    ] ifFalse:[
        usedCompiler = 'vc' ifTrue:[
            cmd := 'cl'.
            warnMsg1 := 'Due to bugs in this C-compiler, some classes may not be compilable.'.
        ] ifFalse:[
            usedCompiler = 'lcc' ifTrue:[
                cmd := 'lcc'.
                warnMsg1 := 'The LCC C-compiler suite is not officially supported.'.
            ] ifFalse:[
                usedCompiler = 'tcc' ifTrue:[
                    cmd := 'tcc'.
                    OperatingSystem isMSWINDOWSlike ifTrue:[
                        warnMsg1 := 'The Tiny C-compiler suite is not yet supported (linkage).'.
                    ].
                ] ifFalse:[
                    usedCompiler = 'gcc' ifTrue:[
                        cmd := 'gcc'.
                    ] ifFalse:[
                        cmd := usedCompiler.
                    ].
                ]
            ]
        ]
    ].

    suite := ProjectBuilder suiteNameOfCompiler:(self usedCompilerHolder value).
    self nameOfUsedCompilerSuiteHolder value:suite.

    (OperatingSystem canExecuteCommand:cmd) ifFalse:[
        warnMsg2 :=
'The "%1"-command seems to be not in your path.
Please ensure that you installed the 
"%2" compiler suite correctly.
(However, the makefiles might know where to find the compiler)
' bindWith:cmd with:suite.
    ].

    (warnMsg1 notEmpty or:[warnMsg2 notEmpty]) ifTrue:[
        sep := ''.
        (warnMsg2 notEmpty) ifTrue:[ sep := '\\' withCRs ].

        self compilerWarnMessageHolder value:('Warning:

',warnMsg1,sep,warnMsg2).
        self compilerWarnMessageVisibleHolder value:true.
    ] ifFalse:[
        self compilerWarnMessageVisibleHolder value:false
    ].

    "Modified: / 06-09-2012 / 15:58:58 / cg"
!

checkSourceCodeManagerType
    |button scm package|

    button := self builder componentAt:'CheckinButton'.

    package := selectedProjectDefinition package.
    scm := AbstractSourceCodeManager managerForPackage:package.
    scm isNil ifTrue:[
        scm := selectedApplication sourceCodeManager.
        scm isNil ifTrue:[
            scm := SourceCodeManager
        ].
    ].
    scm isNil ifTrue:[
        button disable
    ] ifFalse:[
        button label:(resources string:'Checkin (%1)...' with:scm managerTypeName)
    ].
!

delayedUpdate:something with:anArgument from:changedObject
    changedObject == Smalltalk ifTrue:[
        (something == #newClass
        or:[something == #classRemove
        or:[something == #projectOrganization]]) ifTrue:[
            self updateListOfMatchingProjects.
            self updateListOfNewProjectsName.
            ^ self.
        ].
        ^ self.
    ].

    "Created: / 10-09-2012 / 14:07:47 / cg"
!

enterContentsSpecification
    |toAdd|

    self updateListOfClassesInProject.

    toAdd := OrderedCollection new.

    "/ ensure that startup & app-class are in the list
    selectedApplication notNil ifTrue:[
        (selectedProjectDefinition classNames includes:selectedApplication name) ifFalse:[
            toAdd add:selectedApplication.
        ].
    ].
    selectedStartupClass notNil ifTrue:[
        (selectedProjectDefinition classNames includes:selectedStartupClass name) ifFalse:[
            toAdd add:selectedStartupClass.
        ].
    ].

    selectedProjectDefinition includeClasses:toAdd usingCompiler:nil.

    self updateListOfClassesInProject.
!

enterDeploySpecification
    |fileBrowserCanvas fileBrowser|

    self projectTypeIsLibrary ifTrue:[
        fileBrowserCanvas := self builder componentAt:'FileBrowserSubCanvas'.
        fileBrowser := fileBrowserCanvas application. 
        fileBrowser filterModel value:('*' , ObjectFileLoader sharedLibraryExtension).
    ].
!

enterPrerequisitesSpecification
    |toAdd|

    self updateListOfPrerequisitesInProject.

"/    toAdd := OrderedCollection new.
"/
"/    "/ ensure that startup & app-class are in the list
"/    selectedApplication notNil ifTrue:[
"/        (selectedProjectDefinition classNames includes:selectedApplication name) ifFalse:[
"/            toAdd add:selectedApplication.
"/        ].
"/    ].
"/    selectedStartupClass notNil ifTrue:[
"/        (selectedProjectDefinition classNames includes:selectedStartupClass name) ifFalse:[
"/            toAdd add:selectedStartupClass.
"/        ].
"/    ].
"/
"/    selectedProjectDefinition includeClasses:toAdd usingCompiler:nil.
"/
"/    self updateListOfClassesInProject.

    "Created: / 19-01-2012 / 15:36:47 / cg"
!

fetchAttributesFromProjectDefinition
    self fetchSelectedProject.
    selectedProjectDefinition notNil ifTrue:[
        self productNameHolder value: selectedProjectDefinition productName.
        self companyNameHolder value: selectedProjectDefinition companyName.
    ].

    "Created: / 04-09-2012 / 09:50:46 / cg"
!

rememberMakeOutputsContents
    makeOutputHolder value:(makeOutputWindow contents)
!

rememberProjectAttributes
    self assert:selectedProjectDefinition notNil.
    Class withoutUpdatingChangesDo:[
        self productNameHolder value ~= selectedProjectDefinition productName ifTrue:[
            selectedProjectDefinition class compile:(selectedProjectDefinition 
                        productName_codeFor:(self productNameHolder value)).
        ].
        self companyNameHolder value ~= selectedProjectDefinition companyName ifTrue:[
            selectedProjectDefinition class compile:(selectedProjectDefinition 
                        companyName_codeFor:(self companyNameHolder value)).
        ]
    ].
!

rememberUsedCompiler
    LastUsedCompiler := self usedCompilerHolder value.

    "Created: / 04-09-2012 / 09:45:42 / cg"
!

restoreMakeOutputsContents
    makeOutputWindow contents:makeOutputHolder value
!

update:something with:anArgument from:changedObject
    changedObject == Smalltalk ifTrue:[
        (something == #newClass
        or:[something == #classRemove
        or:[something == #projectOrganization]]) ifTrue:[
            self enqueueDelayedUpdate:something with:anArgument from:changedObject.
            ^ self.
        ].
        ^ self.
    ].
    super update:something with:anArgument from:changedObject

    "Modified: / 10-09-2012 / 14:08:17 / cg"
!

updateApplicationComment
    |comment|

    self selectedApplicationIndexHolder value notNil ifTrue:[
        comment := self commentFromClass:selectedApplication.
        comment isNil ifTrue:[
            comment := 'Application has no comment' allItalic withColor:Color lightGray.
        ].
    ] ifFalse:[
        comment := 'Please select an Application' allItalic withColor:Color lightGray.
    ].
    self selectedApplicationsComment value:comment.
!

updateComment
    |comment|

    self selectedProjectIndexHolder value notNil ifTrue:[
        comment := self commentFromClass:selectedProjectDefinition.
        comment isNil ifTrue:[
            comment := 'Project has no comment' allItalic withColor:Color lightGray.
        ].
    ] ifFalse:[
        comment := 'Please select a Project' allItalic withColor:Color lightGray.
    ].
    self selectedProjectsComment value:comment.
!

updateListOfApplicationsInProject
    |oldList applicationClasses package appClass appClassIndex|

    appClassIndex := nil.

    selectedProjectDefinition isNil ifTrue:[
        applicationClasses := #()
    ] ifFalse:[
        package := selectedProjectDefinition package.

        applicationClasses := Smalltalk allClasses
                                    select:[:cls |
                                        ((cls isSubclassOf:ApplicationModel)
                                        and:[ self hideOtherApplicationClasses value not
                                              or:[ cls package = package ]])
                                    ].
        applicationClasses := applicationClasses asOrderedCollection.
        applicationClasses sort:[:a :b | a name < b name].

"/        startUpClassName := [ selectedProjectDefinition startupClassName ] ifError:[ nil ].
"/        startUpClassName notNil ifTrue:[
"/            startUpClass := Smalltalk classNamed:startUpClassName.
"/            startUpClass notNil ifTrue:[
"/                appClassIndex := applicationClasses indexOf:startUpClass.
"/                appClassIndex == 0 ifTrue:[ appClassIndex := nil ].
"/            ].
"/        ].
    ].

    oldList := self listOfApplicationsInProject value.
    oldList = applicationClasses ifFalse:[
        appClass := selectedApplication.
        appClassIndex := applicationClasses indexOf:appClass.
        appClassIndex == 0 ifTrue:[ appClassIndex := nil ].

        self listOfApplicationsInProject value:applicationClasses.
        self selectedApplicationIndexHolder value:appClassIndex.
    ].

    "/ auto select first application
    applicationClasses size == 1 ifTrue:[
        self selectedApplicationIndexHolder value:1.
    ].
!

updateListOfClassesInProject
    self listOfClassesInProject value:(selectedProjectDefinition classNames).
!

updateListOfMatchingProjects
    |query matching projectType idx|

    projectType := self projectType.
    projectType = ProjectDefinition libraryType ifTrue:[
        query := #isLibraryDefinition
    ] ifFalse:[
        projectType = ProjectDefinition guiApplicationType ifTrue:[
            query := #isGUIApplication
        ] ifFalse:[
            projectType = ProjectDefinition nonGuiApplicationType ifTrue:[
                query := #isConsoleApplication
            ] ifFalse:[
                self halt:'oops - unknown projectType'.
                projectType := ProjectDefinition guiApplicationType.
            ].
        ].
    ].

    Class flushSubclassInfo.

    matching := ProjectDefinition allSubclasses
                    select:[:defClass |
                        |match|

                        match := false.

                        defClass isAbstract ifFalse:[
                            (self hideSTXProjects value not
                            or:[ defClass package asPackageId module ~= 'stx' ])
                            ifTrue:[
                                match := defClass perform:query
                            ].
                        ].
                        match
                   ]. 

    matching sort:[:a :b | a name < b name].
    self listOfMatchingProjects value:matching.
    self listOfMatchingPackageIds value:(matching collect:[:def | def package]).

    idx := matching indexOf:selectedProjectDefinition.
    idx == 0 ifTrue:[
        self selectedProjectIndexHolder value:nil.
    ] ifFalse:[
        self selectedProjectIndexHolder value:idx.
    ].

    "Modified: / 20-07-2012 / 15:04:15 / cg"
!

updateListOfMatchingProjectsAndProjectIDs
    self updateListOfMatchingProjects.
    self updateListOfNewProjectsName.

    "Created: / 20-08-2012 / 19:33:12 / cg"
!

updateListOfNewProjectsName
    |loadedProjectIDsWithoutProjectDefinition|

    loadedProjectIDsWithoutProjectDefinition := 
        Smalltalk allLoadedPackageIDs 
            select:[:eachPackageID | 
                eachPackageID ~= PackageId noProjectID 
                and:[ (ProjectDefinition definitionClassForPackage: eachPackageID) isNil ].
            ].
    loadedProjectIDsWithoutProjectDefinition := loadedProjectIDsWithoutProjectDefinition asOrderedCollection.
    loadedProjectIDsWithoutProjectDefinition 
        addFirst:(UserPreferences current usersModuleName "OperatingSystem getLoginName",':','demos','/','demo1').
    self listOfNewProjectsName value:loadedProjectIDsWithoutProjectDefinition.

    "Modified: / 20-08-2012 / 19:31:35 / cg"
!

updateListOfPrerequisitesInProject
    self listOfPrerequisitesInProject value:(selectedProjectDefinition effectivePreRequisites).

    "Created: / 19-01-2012 / 15:39:15 / cg"
!

updateListOfStartupClassesInProject
    |startupClasses package startUpClassName startUpClass startupClassIndex|

    startupClassIndex := nil.
    self selectedStartupClassIndexHolder value:nil.

    selectedProjectDefinition isNil ifTrue:[
        startupClasses := #()
    ] ifFalse:[
        package := selectedProjectDefinition package.

        startupClasses := Smalltalk allClasses
                                    select:[:cls |
                                        ((cls includesBehavior:StandaloneStartup)
                                        and:[ self hideOtherStartupClasses value not
                                              or:[ cls package = package ]])
                                        or:[ cls == Smalltalk
                                             and:[ self hideOtherStartupClasses value not ] ]
                                    ].
        startupClasses := startupClasses asOrderedCollection.
        startupClasses sort:[:a :b | a name < b name].

        startUpClassName := [ selectedProjectDefinition startupClassName ] ifError:[ nil ].
        startUpClassName notNil ifTrue:[
            startUpClass := Smalltalk classNamed:startUpClassName.
            startUpClass notNil ifTrue:[
                startupClassIndex := startupClasses indexOf:startUpClass.
                startupClassIndex == 0 ifTrue:[ startupClassIndex := nil ].
            ].
        ].
    ].

    self listOfStartupClassesInProject value:startupClasses.
    self selectedStartupClassIndexHolder value:startupClassIndex.
!

updateProjectAttributes
    self assert:selectedProjectDefinition notNil.
    self productNameHolder value:(selectedProjectDefinition productName).
    self companyNameHolder value:(selectedProjectDefinition companyName).
    self executableNameHolder value:(selectedProjectDefinition applicationName).
! !

!ProjectBuilderAssistantApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

