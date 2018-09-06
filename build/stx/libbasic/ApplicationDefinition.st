"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2010-2011 Jan Vrany
 COPYRIGHT (c) 2015-2018 Jan Vrany
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

ProjectDefinition subclass:#ApplicationDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

!ApplicationDefinition class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2010-2011 Jan Vrany
 COPYRIGHT (c) 2015-2018 Jan Vrany
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
    subclasses provide the info on the contents of a package/project and
    how to build executables and class libraries and how to load/unload packages.
    Actually, subclasses MUST be subclasses of the two abstract classes LibraryDefinition or
    ApplicationDefinition. These two know how to generate all required help files for the
    make/build/load process.
    File creation is driven by file templates which are expanded using strings from the file mappings.

    Concrete definition classes MUST redefine:
        classNamesAndAttributes
                                list of classes which are part of the dll/exe

        extensionMethodNames
                                list of extension methods

        startupClassName / startupSelector
                                class and selector with which the show starts

        buildTarget             name of the generated exe-file

        
    should redefine:
        preRequisites           list of required packages

        iconFileName            name of a .ico file containing the applications icon

        companyName             name of your company - will be shown by windows explorer
                                as attribute of a .dll or .exe

        description             short description; shown by windows explorer

        legalCopyright          copyright message; shown by windows explorer

        productName             product name; shown by windows explorer

        applicationName         app name; shown by windows explorer


    might redefine:    
        isConsoleApplication    if true, windows-build generates a console app.

        isGUIApplication        if true, the GUI framework is linked in
                                (as opposed to a non-GUI server-like executable)


    The above info might be outdated a bit - see stx_projects_smalltalk as a concrete example.

    [author:]
        Felix Madrid
        Claus Gittinger

    [see also:]
        stx_projects_smalltalk
        stx_libbasic
        stx_libbasic2
"
! !

!ApplicationDefinition class methodsFor:'accessing'!

appSourcesProjects
    "Returns only the application projects (which are included in the application module)"

    ^ self effectivePreRequisites
        select:[:each |
            (self moduleFor: each) = self module
        ].

    "
     bosch_dapasx_application appSourcesProjects
    "
!

startupClass
    "the class, but only if loaded"

    |cls|

    Error 
        handle:[:ex | ] 
        do:[
            |clsName|

            clsName := self startupClassName.
            cls := Smalltalk classNamed:clsName.
        ].
    ^ cls

    "Created: / 20-07-2012 / 16:37:36 / cg"
!

stxSourcesProjects
    "Returns only the required STX projects (which are included in the STX module)"

    ^ self effectivePreRequisites select:[:each | 
        (self moduleFor: each) = (self moduleFor: #stx)
    ].

    "
        bosch_dapasx_application stxSourcesProjects
    "

    "
    #(
       'libbasic' 
       'libbasic2' 
       'libcomp' 
       'libview' 
       'libview2'
       'libwidg' 
       'libwidg2' 
       'libtool' 
       'libtool2' 
       'libhtml' 
       'libui'
    )
    "
! !

!ApplicationDefinition class methodsFor:'code generation'!

forEachMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:ignoreOldDefinition
    "redefined to add application stuff, such as definitions for the app-icon, 
     startup class and installation directory"

    |spec1 spec2|
    
    super forEachMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:ignoreOldDefinition.

    spec1 := #().
    self isGUIApplication ifTrue:[
        spec1 := 
            #(
                (applicationIconFileNameWindows applicationIconFileNameWindows_code 'description - project information')
                (applicationIconFileNameLinux applicationIconFileNameLinux_code 'description - project information')
                (applicationIconFileNameOSX applicationIconFileNameOSX_code 'description - project information')
            )
    ].
    spec2 := 
        #(
            "/ Not needed, done in ProjectDefinition>>forEachMethodsCodeToCompileDo:ignoreOldDefinition:
            "/ (subProjects subProjects_code 'description')
            (productInstallDirBaseName productInstallDirBaseName_code 'description - project information')
            (startupClassName startupClassName_code 'description - startup')
            (startupSelector startupSelector_code 'description - startup')
        ).
    (spec1 , spec2) triplesDo:[:selector :codeMethodSelector :category|
        (self class includesSelector:selector) ifFalse:[
            aTwoArgBlock
                value: (self perform:codeMethodSelector)
                value: category.
        ].
    ].

    "Created: / 10-08-2006 / 16:35:47 / cg"
    "Modified: / 30-08-2006 / 19:03:48 / cg"
    "Modified: / 25-11-2013 / 13:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupClassName_code
    "generate code that answers the startupClass."
    
    |classes startClasses mainClasses appClasses|

    classes := self classNamesAndAttributes 
                collect:[:nmOrPair | 
                            |nm| 
                            nm := nmOrPair isArray ifTrue:[nmOrPair first] ifFalse:[nmOrPair].
                            Smalltalk classNamed:nm
                        ] 
                thenSelect:[:cls | cls notNil and:[cls isProjectDefinition not ]].

    mainClasses := classes select:[:each | each theMetaclass includesSelector:#main ].
    mainClasses size == 1 ifTrue:[
        ^ self startupClassName_codeFor:(mainClasses first name)
    ].
    mainClasses isEmpty ifTrue:[
        startClasses := classes select:[:each | each theMetaclass includesSelector:#start ].
        startClasses size == 1 ifTrue:[
            ^ self startupClassName_codeFor:(startClasses first name)
        ].
        startClasses isEmpty ifTrue:[
            appClasses := classes select:[:each | each isSubclassOf:ApplicationModel ].
            appClasses size == 1 ifTrue:[
                ^ self startupClassName_codeFor:(appClasses first name)
            ].
        ]
    ].

    ^ 
'startupClassName
    "the name of the class which starts the show in its <startupSelector> method.
     Usually, the name of a subclass of StandAloneStartup."

    self error:''undefined startupClass''.
    ^ ''<name of class here>''
'

    "Modified: / 27-12-2006 / 11:43:34 / cg"
!

startupClassName_codeFor:aClassName
    "code that answers aClassName as the startupClass."

    ^ 
'startupClassName
    "the class that starts the show in its startupSelector method"

    ^ ''',aClassName,'''
'

    "Created: / 05-09-2006 / 13:40:32 / cg"
!

startupSelector_code
    "generate a the code that answers the startupSelector.
     try #open and #start."

    |clsName cls sel|

    Error 
        handle:[:ex | ] 
        do:[
            clsName := self startupClassName.
            cls := Smalltalk classNamed:clsName.
        ].

    sel := #start.
    cls notNil ifTrue:[
        (cls respondsTo:#open) ifTrue:[
            sel := #open
        ].
    ].

    ^ self startupSelector_codeFor:sel

    "Modified: / 27-12-2006 / 11:45:38 / cg"
!

startupSelector_codeFor:aSelector
    "generate code that answers aSelector as the startupSelector."

    ^ 
'startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #''',aSelector,'''        
'

    "Created: / 05-09-2006 / 13:41:01 / cg"
    "Modified: / 15-12-2006 / 14:10:11 / cg"
!

subProjects_code        
    "generate code which returns a collection of subproject names."

    |subProjects|

    subProjects := 
        (self siblingsAreSubProjects)
            ifTrue:[ self searchForSiblingProjects ]
            ifFalse:[ self searchForSubProjects ].

    subProjects removeAll: self excludedFromSubProjects.

    ^ String streamContents:[:s |
        s nextPutLine:'subProjects'.
        s nextPutLine:'    "list packages which are known as subprojects.'.
        s nextPutLine:'     This method is generated automatically; however, when generating automatically,'. 
        s nextPutLine:'     packages are only added - never removed, unless listed in #excludedFromSubProjects."'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        subProjects do:[:eachPackageID |    
            s nextPutLine:eachPackageID asString storeString
        ].      
        s nextPutLine:')'
    ].

    "
     bosch_dapasx subProjects_code
     stx_goodies subProjects_code
     exept_expecco subProjects_code
    "

    "Modified: / 08-08-2006 / 19:24:34 / fm"
    "Created: / 17-08-2006 / 21:26:51 / cg"
! !

!ApplicationDefinition class methodsFor:'defaults'!

buildTarget
    "which target in the Makefile should be built by default?
     For now, reasonable return values are 'exe', which builds the executable(s),
     and 'ALL', which builds everything, including an installable package.
     Here, 'ALL' is returned.
     There is usually no need to redefine this default - we at exept do it for the
     stx package only to speed up our own build, as we seldom need new install packages,
     put often build new executables..."

     ^ 'ALL'
!

extraTargets
    "extra targets to be built when creating the exe"

     self needResources ifTrue:[
        ^ #('RESOURCEFILES')
     ].

     ^ #()
!

guiClassFileNames_unix
    ^ self guiClasses_unix 
        collect:[:cls | (cls classBaseFilename asFilename withSuffix:'so') baseName].

    "Created: / 14-09-2006 / 18:13:22 / cg"
    "Modified: / 12-10-2006 / 15:50:39 / cg"
!

guiClassFileNames_win32
    ^ self guiClasses_win32 
        collect:[:cls | (cls classBaseFilename asFilename withSuffix:'dll') baseName].

    "Created: / 07-09-2006 / 17:23:13 / cg"
    "Modified: / 12-10-2006 / 15:50:42 / cg"
!

guiClasses_unix
    ^ #()

    "Created: / 14-09-2006 / 18:12:58 / cg"
!

guiClasses_win32
    ^ #()
    "/ ^ Array with:XWorkstation

    "Created: / 07-09-2006 / 17:22:27 / cg"
    "Modified: / 14-09-2006 / 18:12:35 / cg"
!

needResources
    "answer true, if this application
     needs resources to be installed. This is normally true.
     Even non-GUI apps need some (libbasic/resources)"

    ^ true 
! !

!ApplicationDefinition class methodsFor:'description'!

additionalFilesToInstall_unix
    "application-specific files to be installed.
     Each entry gives a pattern of a file to be copied and a destination directory.
     Can be redefined in subclasses."

    ^ #()

    "Created: / 01-03-2007 / 20:02:21 / cg"
!

additionalFilesToInstall_win32
    "application-specific files to be installed.
     Each line defines an entry in the NSI file, for a pattern of a file to be copied.
     Can be redefined in subclasses."

    ^ #()

    "Created: / 01-03-2007 / 20:02:21 / cg"
!

additionalResourceTargets
    "application-specific additional resource targets to be invoked.
     Can be redefined in subclasses."

    ^ #()
!

applicationInstallIconFileName
    "answer the base-name of the installer icon (i.e. 'app' in <app>.ico).

     Default is the same as the application icon"

    ^ self applicationIconFileNameWindows.

    "Modified: / 26-10-2016 / 23:18:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationName
    "answer the name of the application.
     This is also the name of the generated .exe file.

     Subclasses may redefine this"

    ^ self applicationNameFromPackage

    "
     bosch_dapasx_application applicationName
     stx_projects_smalltalk applicationName
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified: / 30-08-2006 / 19:29:25 / cg"
!

documentExtensions
    "list extensions which should be registered with the application.
     Results in the application to be started when double-clicking on such a file (win32)"

    ^ #()

    "Created: / 15-10-2006 / 12:44:14 / cg"
!

includedInPreRequisites
    "list packages which are to be implicitely included in the prerequisites list,
     even if not found by the automatic search.
     Redefine this, if classes from other packages are referred to via reflection
     or by constructing names dynamically (i.e. the search cannot find it)"

    ^ self isGUIApplication ifTrue:[
        #(
            #'stx:libcomp'   "/ to read the rc file
            #'stx:libbasic2' "/ UI framework
            #'stx:libview'   "/ UI framework
            #'stx:libview2'  "/ UI framework
            #'stx:libwidg'   "/ UI framework
            #'stx:libwidg2'  "/ UI framework
            #'stx:libui'     "/ UI framework
        )
    ] ifFalse:[
        #(
            #'stx:libcomp'   "/ to read the rc file
        )
    ].
!

initiallyLoadedPreRequisites
   "Prereqisites packages that are not to be loaded at application startup, but
    that maybe loaded later by the application.
    This is used for a fast startup in case that the application wants to only inform
    an already running application to e.g. open an additional window."

    ^ nil       "the default, nil means: all prerequisites should be loaded initially"

"/    ^ #(
"/        #'stx:libbasic'  
"/        #'stx:libbasic2'   
"/        #'stx:libcomp'
"/    )
!

isConsoleApplication
    "Used with WIN32 only (i.e. affects bc.mak).
     Return true, if this is a console application. 
     Console applications have stdout and stderr and open up a command-window
     when started. Only console applications can interact with the user in the
     command line window.
     By default, GUI apps are compiled as non-console apps.
     If you need both (as in expecco), redefine this as true AND in addition redefine 
     makeConsoleApplication to return true."

    ^ self isGUIApplication not

    "Created: / 20-09-2006 / 11:29:24 / cg"
!

isGUIApplication
    "Return true, if this is a GUI app. 
     Redefine to return false for non-GUI applications (affects inclusion of Display classes)."

    ^true

    "Created: / 08-08-2006 / 11:15:01 / fm"
    "Modified: / 17-08-2006 / 19:47:36 / cg"
!

isSingleThreadedApplication
    "Return true, if this should be started without multiple threads. 
     (not possible with gui applications)"

    ^false

    "Created: / 05-09-2006 / 13:36:18 / cg"
!

logFilenameNoConsole
    "/ ^ (self applicationNameNoConsole , '_%d.log')
    ^ (self applicationName , '.log')
!

mainDefines
    ^ '-DIGNORE_IMAGE -DNO_DISPLAY'
!

makeConsoleApplication
    "Used with WIN32 only (i.e. affects bc.mak).
     Return true, if this should be built as a console application.
     Redefine to return true, if you want one always i.e. to generate both)."

    ^ self isConsoleApplication
!

makeNonConsoleApplication
    "Used with WIN32 only (i.e. affects bc.mak).
     Return true, if this should be built as a non-console application"

    ^ self isGUIApplication
!

offerApplicationSourceCode
    "Return true, if the source code of the application should be offered as install option"

    ^ false

    "Created: / 15-05-2007 / 16:46:05 / cg"
!

offerSmalltalkSourceCode
    "Return true, if the source code of the smalltalk base system should be offered as install option"

    ^ false

    "Created: / 15-05-2007 / 16:46:18 / cg"
!

runAsAdmin
    "WINDOWS only!! Optionally used by NSI installer.
     defines a registry entry,
     which sets RUNASADMIN file attribute to the noconsole application exe"
    ^ false

    "Created: / 12-10-2012 / 10:19:56 / sr"
!

startupClassName
    "return he name of the class which provides the entry point for the application;
     a fully specified symbol or string."

    self subclassResponsibility

    "Modified: / 17-08-2006 / 20:00:22 / cg"
!

startupSelector
    "The name of the entry point method (in startUpClass) used to start the application."

    ^ #start

    "Modified: / 17-08-2006 / 20:01:00 / cg"
! !

!ApplicationDefinition class methodsFor:'description - private'!

applicationNameConsole
    "only used for windows builds"

    ^ self applicationName, '.com'
!

applicationNameFromPackage
    "answer the name of the application.
     This is also the name of the generated .exe file.

     Subclasses may redefine this"

    |m path|

    m := self moduleDirectory.
    path := m subStrings:$/.
    path last = 'application' ifTrue:[
        path size > 1 ifTrue:[
            path := path copyButLast:1.
        ].
    ].
    ^ path last

    "
     stx_projects_smalltalk applicationNameFromPackage
     exept_expecco_application applicationNameFromPackage
     bosch_dapasx_application applicationNameFromPackage
     alspa_batch_application applicationNameFromPackage
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified: / 05-09-2012 / 10:08:44 / cg"
!

applicationNameNoConsole
    "only used for windows builds"
    
    ^ self applicationName , '.exe'
!

applicationPackage

    ^self module, ':', self applicationNameFromPackage

    "
     bosch_dapasx_application applicationPackage
     stx_projects_smalltalk applicationPackage
     alspa_batch_application applicationPackage
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified: / 30-08-2006 / 19:29:25 / cg"
!

commonFilesToInstall_unix
    "files installed for applications.
     Each entry gives a pattern of a file to be copied and a destination directory.
     Do not redefine - see additionalFilesToInstall for a redefinable variant of this"

    ^ #(
        ('*.so'         'bin')
        ('symbols.stc'  'bin')
        ('*.stx'        'bin')
        ('*.rc'         'bin')
        ('resources'    'bin')
    )

    "Created: / 01-03-2007 / 20:05:40 / cg"
!

commonFilesToInstall_win32
    "files installed for applications - used only for NSIS installer under WIN32.
     Each line defines an entry in the NSI file, for a pattern of a file to be copied.
     Do not redefine - see additionalFilesToInstall for a redefinable variant of this"

    ^ #(
        '"*.dll"'
        '"symbols.stc"'
        '"*.stx"'
        '"*.rc"'
        '/r /x CVS /x ".*" resources'
    )

    "Created: / 01-03-2007 / 20:05:40 / cg"
!

docDirPath_unix
    "path relative to my dir to the documentation - or nil"

    ^ self docDirPath replaceAll:$\ with:$/.
!

docDirPath_win32
    "path relative to my dir to the documentation - or nil"

    ^ self docDirPath replaceAll:$/ with:$\.
! !

!ApplicationDefinition class methodsFor:'description - project information'!

applicationType 

    ^self isGUIApplication
        ifTrue:['GUI_APPLICATION']
        ifFalse:['NON_GUI_APPLICATION']
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    self module = 'stx' ifTrue:[
        ^ 'Smalltalk/X Application'
    ].

    ^ 'Application'

    "Created: / 17-08-2006 / 20:52:48 / cg"
    "Modified: / 18-08-2006 / 16:16:01 / cg"
!

docDirPath
    "path relative to my dir to the documentation - or empty."

    ^ ''

    "Created: / 20-09-2006 / 17:58:40 / cg"
!

hasLicenceToAcceptDuringInstallation
    ^ false

    "Created: / 14-09-2006 / 22:34:00 / cg"
! !

!ApplicationDefinition class methodsFor:'file generation'!

basicFileNamesToGenerate
    "answer a dictionary (filename -> generator method) with all the files, that have to be generated for this
     package"
    
    |dict|

    dict := super basicFileNamesToGenerate.

    dict 
        at:'modules.stx'        put:#'generate_modules_dot_stx';
        at:'modules.c'          put:#'generate_modules_dot_c';
        at:self rcFilename      put:#'generate_packageName_dot_rc';
        at:self nsiFilename     put:#'generate_packageName_dot_nsi';
        at:self apspecFilename  put:#'generate_autopackage_default_dot_apspec'; "/ for linux
        at:'osx/Info.plist'     put:#'generate_osx_info_dot_plist';
"/        at:'osx/PkgInfo'        put:#'generate_osx_pkginfo';
        at:'builder/baseline.rbspec'  put:#'generate_builder_baseline_dot_rbspec';
        at:'builder/package.deps.rake' put: #'generate_package_dot_deps_dot_rake'.

"/    self isGUIApplication ifFalse:[    
"/        dict at:'osx/Distribution'  put:#'generate_osx_distributionScript'.
"/    ].
    ^ dict.

    "Modified: / 21-12-2010 / 11:01:27 / cg"
    "Modified: / 26-02-2011 / 15:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateFile:filename

   (filename = 'builder/baseline.rpspec') ifTrue:[
        ^ self generate_builder_baseline_dot_rbspec
   ].
    (filename = 'app.nsi' or:[filename = self nsiFilename]) ifTrue:[
        ^ self generate_packageName_dot_nsi
    ].
    (filename = 'autopackage/default.apspec' or:[filename = self apspecFilename]) ifTrue:[
        "/ for linux
        ^ self generate_autopackage_default_dot_apspec
    ].
    ^ super generateFile:filename

    "Modified: / 21-12-2010 / 11:00:59 / cg"
    "Modified: / 24-02-2011 / 12:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate_modules_dot_c

    ^self replaceMappings: self modules_dot_c_mappings 
            in: self modules_dot_c

    "
     bosch_dapasx_application generate_modules_dot_c
    "

    "Created: / 19-09-2006 / 22:35:27 / cg"
!

generate_modules_dot_stx

    ^self replaceMappings: self modules_dot_stx_mappings 
            in: self modules_dot_stx

"
  bosch_dapasx_application generate_modules_dot_stx

"

    "Modified: / 09-08-2006 / 11:31:09 / fm"
    "Modified: / 11-08-2006 / 14:01:56 / cg"
!

generate_osx_pkginfo
    ^ 'APPL',self applicationName
!

generate_packageName_dot_nsi

    ^self 
        replaceMappings: self packageName_dot_nsi_mappings 
        in: self packageName_dot_nsi

    "
     bosch_dapasx_application generate_packageName_dot_nsi
    "

    "Modified: / 09-08-2006 / 11:31:09 / fm"
    "Created: / 14-09-2006 / 21:08:23 / cg"
    "Modified: / 15-10-2006 / 12:52:21 / cg"
!

nsiFilename
    ^ self packageName,'.nsi'.

    "Created: / 14-09-2006 / 21:03:41 / cg"
! !

!ApplicationDefinition class methodsFor:'file mappings'!

additionalFilesToInstall_dot_nsi:bindings 
    ^ String 
        streamContents:[:s | 
            self additionalFilesToInstall_win32 do:[:pattern | 
                s nextPutLine:((self installFileLine_nsi_for:pattern) 
                            expandPlaceholdersWith:bindings)
            ].
        ].

    "Created: / 01-03-2007 / 19:59:18 / cg"
!

additionalSectionsDescriptions_dot_nsi
    ^''
!

additionalSectionsDescriptions_dot_nsi:bindings
    ^self additionalSectionsDescriptions_dot_nsi expandPlaceholdersWith:bindings
!

additionalSectionsInsertDescriptions_dot_nsi
    ^''
!

additionalSectionsInsertDescriptions_dot_nsi:bindings
    ^self additionalSectionsInsertDescriptions_dot_nsi expandPlaceholdersWith:bindings
!

additionalSections_dot_nsi
    ^''
!

additionalSections_dot_nsi:bindings
    ^self additionalSections_dot_nsi expandPlaceholdersWith:bindings
!

appSourcesLines_dot_nsi:bindings
    ^ String streamContents:[:s |
        s nextPutAll:
('Section "Application Sources" Section4
    SectionIn 1
    SetOverwrite ifnewer
' expandPlaceholdersWith:bindings).
        self appSourcesProjects do:[:projectID |
            s nextPutAll:((self defineAPPSourceLine_nsi_for: projectID)expandPlaceholdersWith:bindings).
            s cr.
        ].
        s nextPutAll:
'SectionEnd'
    ].

    "Created: / 15-10-2006 / 12:59:03 / cg"
!

autopackage_default_dot_apspec_mappings
    |mappings|

    mappings := super autopackage_default_dot_apspec_mappings.

    mappings
        at: 'APPLICATION' put: self applicationName;
        at: 'APPLICATION_PACKAGE' put: self package printString "applicationPackage";
        at: 'APPLICATION_TYPE' put: self applicationType;
        yourself.

    self offerSmalltalkSourceCode ifTrue:[ 
"/        mappings
"/            at: 'STX_SOURCE_RULES' put: ( self replaceMappings: mappings 
"/                                            in: self make_dot_proto_stx_source_rules).
    ].

    self offerApplicationSourceCode ifTrue:[  
"/        mappings
"/            at: 'SOURCE_RULES' put:( self replaceMappings: mappings 
"/                                            in: self make_dot_proto_app_source_rules ).
    ].

    self needResources ifTrue:[
"/        mappings
"/            at: 'REQUIRED_SUPPORT_DIRS' put: 'RESOURCEFILES';
"/            at: 'RESOURCE_RULES' put:( self replaceMappings: mappings 
"/                                            in: self make_dot_proto_resource_rules );
"/            at: 'STX_RESOURCE_RULES' put: ( self replaceMappings: mappings 
"/                                            in: self make_dot_proto_stx_resource_rules);
"/            at: 'ADDITIONAL_RESOURCE_TARGETS' put:( self additionalResourceTargets asStringWith:' ');
"/            yourself.
    ].

    ^ mappings

    "Created: / 21-12-2010 / 09:00:49 / cg"
    "Modified: / 21-12-2010 / 11:00:22 / cg"
    "Modified (comment): / 04-09-2012 / 13:09:22 / cg"
!

bc_dot_mak_mappings
    |d|

    d := super bc_dot_mak_mappings.
    d 
        at: 'LOCAL_INCLUDES' put: (self generateLocalIncludes_win32);
        at: 'CONSOLE_APPLICATION_OR_EMPTY' put:(self makeConsoleApplication ifTrue:['consoleApp'] ifFalse:'');
        at: 'NOCONSOLE_APPLICATION_OR_EMPTY' put:(self makeNonConsoleApplication ifTrue:['noConsoleApp'] ifFalse:'');
        at: 'APPLICATION' put: (self applicationName);
        at: 'NSI_FILENAME' put: self nsiFilename ;
        at: 'PRODUCT_NAME' put: (self productName);
        at: 'PRODUCT_FILENAME' put: (self productFilename);
        at: 'CONSOLE_APPLICATION' put: (self applicationNameConsole);
        at: 'NOCONSOLE_APPLICATION' put: (self applicationNameNoConsole);
        at: 'NOCONSOLE_LOGFILE' put:(self logFilenameNoConsole);
        at: 'RESFILENAME' put: (self resourceFilename );
        at: 'RCFILENAME' put: (self rcFilename );
        at: 'STARTUP_CLASS' put: ( self startupClassName );
        at: 'STARTUP_SELECTOR' put: (self startupSelector );
        at: 'MAIN_DEFINES' put: (self mainDefines );
        at: 'REQUIRED_LIBS' put: (self generateRequiredLibs_bc_dot_mak); 
        at: 'PREREQUISITES_LIBS' put: (self generatePreRequisiteLines_bc_dot_mak );  
        at: 'DEPENDENCIES' put: (self generateDependencies_win32);
        at: 'SUBPROJECT_LIBS' put: (self generateSubProjectLibs_bc_dot_mak ); 
        at: 'SUBPROJECTS_LINES' put: (self generateSubProjectLines_bc_dot_mak ); 
        at: 'BUILD_TARGET' put: (self buildTarget );
        at: 'REQUIRED_SUPPORT_DIRS' put: (self extraTargets asStringWith:' ');
        yourself.

    self needResources ifTrue:[
        d 
            at: 'RESOURCE_RULES' put:( self replaceMappings: d 
                                            in: self bc_dot_mak_resource_rules );
            at: 'STX_RESOURCE_RULES' put: ( self replaceMappings: d 
                                            in: self bc_dot_mak_stx_resource_rules);
            at: 'ADDITIONAL_RESOURCE_TARGETS' put:( self additionalResourceTargets asStringWith:' ');
            yourself
    ].
    self offerSmalltalkSourceCode ifTrue:[
        d 
            at: 'STX_SOURCE_RULES' put: ( self replaceMappings: d 
                                               in: self bc_dot_mak_stx_source_rules);
            yourself
    ].
    self offerApplicationSourceCode ifTrue:[
        d 
            at: 'APP_SOURCE_RULES' put: ( self replaceMappings: d 
                                               in: self bc_dot_mak_app_source_rules);
            yourself
    ].
    ^ d

    "Modified: / 15-05-2007 / 17:27:04 / cg"
!

bmake_dot_mak_mappings
    ^ super bmake_dot_mak_mappings
        at:'SKIP_IF_ARG_IS_APP_TARGET' put:'
@IF "%1" EQU "exe" exit /b 0
@IF "%1" EQU "setup" exit /b 0
@IF "%1" EQU "pluginSetup" exit /b 0
';
        yourself

    "Modified: / 06-06-2016 / 12:06:16 / cg"
!

buildDate_dot_h_mappings
    |d|

    d := Dictionary new.
    d 
        at: 'BUILDDATE' put: (Timestamp now printStringRFC1123Format ). 

    ^ d

    "Created: / 30-08-2006 / 19:19:30 / cg"
    "Modified: / 14-09-2006 / 18:58:31 / cg"
!

commonFilesToInstall_dot_nsi:bindings 
    ^ String 
        streamContents:[:s | 
            self commonFilesToInstall_win32 do:[:pattern | 
                s nextPutLine:((self installFileLine_nsi_for:pattern) 
                            expandPlaceholdersWith:bindings)
            ].
        ].

    "Created: / 01-03-2007 / 20:05:20 / cg"
!

directoryUninstallLines_dot_nsi
    "%(DIRECTORY_UNINSTALL_LINES)"

  ^'
    Delete "$INSTDIR\*"
    RMDir /r "$INSTDIR"'
!

fileExtensionDefinitionLines_dot_nsi:bindings
    ^ String streamContents:[:s |
        self documentExtensions do:[:ext |
            s nextPutAll:((self defineExtenionLine_nsi_for:ext) expandPlaceholdersWith:bindings)
        ].
    ].

    "Created: / 15-10-2006 / 12:59:03 / cg"
!

fileExtensionUndefinitionLines_dot_nsi:bindings
    ^ String streamContents:[:s |
        self documentExtensions do:[:ext |
            s nextPutAll:((self undefineExtenionLine_nsi_for:ext) expandPlaceholdersWith:bindings)
        ].
    ].

    "Created: / 15-10-2006 / 12:59:18 / cg"
!

make_dot_proto_mappings
    |mappings|

    mappings := super make_dot_proto_mappings.
    mappings
        at: 'NSI_FILENAME' put: self nsiFilename ;
        at: 'APPLICATION' put: self applicationName;
        at: 'APPLICATION_PACKAGE' put: self package printString "applicationPackage";
        at: 'APPLICATION_TYPE' put: self applicationType;
        at: 'STARTUP_CLASS' put: (self startupClassName);
        at: 'STARTUP_SELECTOR' put: (self startupSelector);
        at: 'MAIN_DEFINES' put: (self mainDefines);
        at: 'PREREQUISITES_LIBS' put: (self generatePreRequisiteLines_make_dot_proto);  
        at: 'REQUIRED_LIBS' put: (self generateRequiredLibs_make_dot_proto);  
        at: 'REQUIRED_LIBOBJS' put: (self generateRequiredLibobjs_make_dot_proto);
        at: 'REQUIRED_LINK_LIBOBJS' put: (self generateRequiredLinkLibobjs_make_dot_proto);
        at: 'REQUIRED_SUPPORT_DIRS' put: (self extraTargets asStringWith:' ');
        at: 'DEPENDENCIES' put: (self generateDependencies_unix);
        at: 'SUBPROJECTS_LINES' put: (self generateSubProjectLines_make_dot_proto); 
        at: 'SUBPROJECT_LIBS' put: (self generateSubProjectLibs_make_dot_proto); 
        at: 'PRODUCT_NAME' put: (self productName);
        at: 'PRODUCT_FILENAME' put: (self productFilename);
        at: 'PRODUCT_VERSION' put: (self productVersion);
        at: 'PRODUCT_DATE' put: (self productDate);
        at: 'PRODUCT_PUBLISHER' put: (self productPublisher);
        at: 'PRODUCT_WEBSITE' put: (self productWebSite);
        at: 'PRODUCT_INSTALLDIR' put: (self productInstallDir);
        at: 'OSX_DMG_SETUP' put: (self osxDmgImageSetupLines);
        at: 'OSX_PKG_SETUP' put: (self osxPkgImageSetupLines);
        at: 'PRODUCT_ID' put: (self package copyReplaceAny:':/' with:$.); 
        at: 'BUILD_TARGET' put: (self buildTarget ).

    self offerSmalltalkSourceCode ifTrue:[ 
        mappings
            at: 'STX_SOURCE_RULES' put: ( self replaceMappings: mappings 
                                            in: self make_dot_proto_stx_source_rules).
    ].

    self offerApplicationSourceCode ifTrue:[  
        mappings
            at: 'SOURCE_RULES' put:( self replaceMappings: mappings 
                                            in: self make_dot_proto_app_source_rules ).
    ].

    self needResources ifTrue:[
        mappings
            at: 'RESOURCE_RULES' put:( self replaceMappings: mappings 
                                            in: self make_dot_proto_resource_rules );
            at: 'STX_RESOURCE_RULES' put: ( self replaceMappings: mappings 
                                            in: self make_dot_proto_stx_resource_rules);
            at: 'ADDITIONAL_RESOURCE_TARGETS' put:( self additionalResourceTargets asStringWith:' ');
            yourself.
    ].

    ^ mappings

    "Modified (format): / 04-09-2012 / 13:06:50 / cg"
!

modules_dot_c_mappings
    |d|

    d := Dictionary new.
    d 
        at: 'INIT_LIST' put: 
            ((self generateClassLines:(self classLine_modules_dot_c)) , 
             (self generateExtensionLine:(self extensionsLine_modules_dot_c)));
        at: 'EXTERN_INIT_NAME_LIST' put: 
            ((self generateClassLines:(self classLine_modules_dot_c_extern)),
             (self generateExtensionLine:(self extensionsLine_modules_dot_c_extern)));
        yourself.

    ^ d

    "
        cvut_fel_izar modules_dot_c_mappings
    "

    "Created: / 19-09-2006 / 22:42:15 / cg"
    "Modified: / 03-03-2011 / 19:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modules_dot_stx_mappings
    |d|

    d := Dictionary new.
    d 
        at: 'PREREQUISITE_LIBS' put: (self generatePreRequisiteLibs_modules_dot_stx);
        at: 'ALLPREREQUISITE_LIBS' put: (self generateAllPreRequisiteLibs_modules_dot_stx);
        at: 'SUBPROJECT_LIBS' put: (self generateSubProjectLines_modules_dot_stx  ). 

    ^ d

    "Modified: / 14-09-2006 / 18:58:41 / cg"
!

nsiDeliveredConsoleExecutable
    self isGUIApplication ifFalse:[^ '' "made anyway"].
    self makeConsoleApplication ifTrue:[
        ^ ('"',self applicationName,'.com','"').
    ].
    ^ ''
!

nsiDeliveredExecutables
    "by default, an executable named after the application.
     Redefine, if that's not the case. If multiple have to be delivered, 
     return a string containing each individually double-quoted."

    |s|

    s := ''.
    self makeNonConsoleApplication ifTrue:[
        s := '"', self applicationNameNoConsole,'"'.
    ].
    self makeConsoleApplication ifTrue:[
        s := s , (' "',self applicationNameConsole,'"').
    ].
    ^ s
!

packageName_dot_nsi_mappings
    |d s defLines undefLines defRunAsAdmin undefRunAsAdmin stxSourcesLines appSourcesLines|

    d := Dictionary new.
    d
        at: 'TOP' put: ( self pathToTopWithSeparator:'\' );

        at: 'APPLICATION' put: (self applicationName);
        at: 'APPLICATION_ICON' put: (self applicationInstallIconFileName);
        at: 'NSI_FILENAME' put: (self nsiFilename );
        at: 'CONSOLE_APPLICATION' put: (self applicationNameConsole);
        at: 'NOCONSOLE_APPLICATION' put: (self applicationNameNoConsole);
        at: 'DELIVERED_EXECUTABLES' put: (self nsiDeliveredExecutables);
        at: 'MODULE' put: ( self module );  
        at: 'MODULE_KEY' put: ( self module asUppercaseFirst );  
        at: 'PRODUCT_NAME' put: (self productName);
        at: 'PRODUCT_FILENAME' put: (self productFilename);
        at: 'PRODUCT_VERSION' put: (self productVersion);
        at: 'PRODUCT_DATE' put: (self productDate);
        at: 'PRODUCT_PUBLISHER' put: (self productPublisher);
        at: 'PRODUCT_WEBSITE' put: (self productWebSite);
        at: 'PRODUCT_INSTALLDIR' put: (self productInstallDir);
        at: 'FILETYPE' put: ( 'VFT_DLL' );
        at: 'FILE_VERSION_COMMASEPARATED' put: (self fileVersionCommaSeparated);
        at: 'PRODUCT_VERSION_COMMASEPARATED' put: (self productVersionCommaSeparated);

        at: 'COMPANY_NAME' put: (self companyName);
        at: 'FILE_DESCRIPTION' put: (self fileDescription);
        at: 'FILE_VERSION' put: (self fileVersion);
        at: 'LEGAL_COPYRIGHT' put: (self legalCopyright ? '');
        at: 'INTERNAL_NAME' put: (self internalName).

    s := self legalCopyright.
    s notNil ifTrue:[
        d  at: 'LEGAL_COPYRIGHT_LINE' put: '      VALUE "LegalCopyright", "',s,'\0"'
    ].
    s := self applicationInstallIconFileName.
    s isNil ifTrue:[
        d  at:'SEMI_IF_NO_ICON_EXISTS' put:';; '.
        d  at:'SEMI_IF_ICON_EXISTS' put:''.
    ] ifFalse:[
        d  at:'SEMI_IF_NO_ICON_EXISTS' put:''.
        d  at:'SEMI_IF_ICON_EXISTS' put:';; '.
"/        d  at: #'ICONDEFINITION_LINE' put: 'IDR_MAINFRAME           ICON    DISCARDABLE     "',s,'"'
    ].

"/    s := self splashFileName.
"/    s notNil ifTrue:[
"/        d  at: #'SPLASHDEFINITION_LINE' put: 'IDR_SPLASH            BITMAP DISCARDABLE     "',s,'"'
"/    ].

    s := self docDirPath_win32.
    s isEmptyOrNil ifTrue:[
        d  at:'SEMI_IF_NO_DOC_EXISTS' put:';; '.
    ] ifFalse:[
        d  at:'SEMI_IF_NO_DOC_EXISTS' put:''.
    ].   
    self offerSmalltalkSourceCode ifTrue:[
        stxSourcesLines := self stxSourcesLines_dot_nsi:d.
        d at:'STX_SOURCES_LINES' put:stxSourcesLines.
        d  at:'SEMI_IF_NO_STX_SOURCES' put:''.
    ] ifFalse:[
        d at:'STX_SOURCES_LINES' put:''.
        d  at:'SEMI_IF_NO_STX_SOURCES' put:';;'.
    ].
    self offerApplicationSourceCode ifTrue:[
        appSourcesLines := self appSourcesLines_dot_nsi:d.
        d at:'APP_SOURCES_LINES' put:appSourcesLines.
        d at:'SEMI_IF_NO_STX_SOURCES' put:''.
    ] ifFalse:[
        d at:'APP_SOURCES_LINES' put:''.
        d at:'SEMI_IF_NO_APP_SOURCES' put:';;'.
    ].

    defLines := self fileExtensionDefinitionLines_dot_nsi:d.
    undefLines := self fileExtensionUndefinitionLines_dot_nsi:d.

    defRunAsAdmin := self runAsAdminDefinitionLines_dot_nsi:d.
    undefRunAsAdmin := self runAsAdminUndefinitionLines_dot_nsi:d.

    d at:'FILE_EXTENSION_DEFINITION_LINES' put:defLines.
    d at:'FILE_EXTENSION_UNDEFINITION_LINES' put:undefLines.
    d at:'DEFINITION_NOCONSOLE_APPLICATION_RUNASADMIN' put:defRunAsAdmin.
    d at:'UNDEFINITION_NOCONSOLE_APPLICATION_RUNASADMIN' put:undefRunAsAdmin.
    d at:'ADDITIONAL_FILES_TO_INSTALL' put:(self additionalFilesToInstall_dot_nsi:d).
    d at:'COMMON_FILES_TO_INSTALL' put:(self commonFilesToInstall_dot_nsi:d).
    d at:'ADDITIONAL_SECTIONS' put:(self additionalSections_dot_nsi:d).
    d at:'ADDITIONAL_SECTIONS_DESCRIPTIONS' put:(self additionalSectionsDescriptions_dot_nsi:d).
    d at:'ADDITIONAL_SECTIONS_INSERT_DESCRIPTIONS' put:(self additionalSectionsInsertDescriptions_dot_nsi:d).
    d at: 'DIRECTORY_UNINSTALL_LINES' put: (self directoryUninstallLines_dot_nsi).
    ^ d

    "Created: / 14-09-2006 / 21:08:44 / cg"
    "Modified: / 15-05-2007 / 17:24:27 / cg"
    "Modified: / 12-10-2012 / 11:44:32 / sr"
!

preRequisiteLine_bc_dot_mak_mappings: aProjectID 

    ^ Dictionary new
        at: 'FILE_NAME' put: (self libraryNameFor:aProjectID);  
        at: 'MODULE_DIRECTORY' put: (self msdosPathToPackage:aProjectID from:self package);     
        at: 'BACK_DIRECTORY' put: (self msdosPathToPackage:self package from:aProjectID);     
        yourself

    "Modified: / 09-02-2007 / 16:59:21 / cg"
!

preRequisiteLine_bc_dot_mak_mappingsForClass:aClass
    |relPath|

    relPath := (PackageId from:aClass package) directory copyReplaceAll:$/ with:$\.

    ^ Dictionary new
        at: 'FILE_NAME' put: ( aClass classBaseFilename asFilename withoutSuffix baseName );  
        at: 'MODULE_DIRECTORY' put:relPath;     
        yourself

    "Modified: / 16-07-2013 / 19:50:26 / cg"
!

preRequisiteLine_make_dot_proto_mappings: aProjectID 

    ^ Dictionary new
        at: 'FILE_NAME' put: (self libraryNameFor:aProjectID);  
        at: 'MODULE_DIRECTORY' put: (self pathToPackage:aProjectID from:self package withSeparator:'/');     
        at: 'BACK_DIRECTORY' put: (self pathToPackage:self package from:aProjectID withSeparator:'/');     
        yourself
!

preRequisiteLine_make_dot_proto_mappingsForClass:aClass
    |relPath|

    relPath := (PackageId from:aClass package) directory.

    ^ Dictionary new
        at: 'FILE_NAME' put: ( aClass classBaseFilename asFilename withoutSuffix baseName );  
        at: 'MODULE_DIRECTORY' put:relPath;     
        yourself

    "Modified: / 09-02-2007 / 16:28:12 / cg"
!

runAsAdminDefinitionLines_dot_nsi:bindings
    self runAsAdmin ifFalse:[
        ^ ''
    ].

    ^ String streamContents:[:s |
        s nextPutLine:('  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)" "RUNASADMIN"' expandPlaceholdersWith:bindings).
        s nextPutLine:'  SetRegView 64'.
        s nextPutLine:('  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)" "RUNASADMIN"' expandPlaceholdersWith:bindings).
        s nextPutAll:'  SetRegView 32'.
    ].

    "Created: / 12-10-2012 / 10:12:12 / sr"
!

runAsAdminUndefinitionLines_dot_nsi:bindings
    self runAsAdmin ifFalse:[
        ^ ''
    ].

    ^ String streamContents:[:s |
        s nextPutLine:('  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)"' expandPlaceholdersWith:bindings).
        s nextPutLine:'  SetRegView 64'.
        s nextPutLine:('  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)"' expandPlaceholdersWith:bindings).
        s nextPutAll:'  SetRegView 32'.
    ].

    "Created: / 12-10-2012 / 10:12:37 / sr"
!

stxSourcesLines_dot_nsi:bindings
    ^ String streamContents:[:s |
        s nextPutAll:
'Section "STX Sources" Section3
    SectionIn 1
    SetOverwrite ifnewer
'.
        self stxSourcesProjects do:[:projectID |
            s nextPutAll:((self defineSTXSourceLine_nsi_for: projectID) expandPlaceholdersWith:bindings).
            s cr.
        ].
        s nextPutAll:
'SectionEnd'.

    ].

    "Created: / 15-10-2006 / 12:59:03 / cg"
!

subProjectLine_bc_dot_mak_mappings: aProjectID 
    ^ Dictionary new
        at: 'LIBRARY_NAME' put: (self libraryNameFor: aProjectID );     
        at: 'PATH_TO_SUB_PROJECT' put: (self msdosPathToPackage:aProjectID from:self package); 
        at: 'PATH_TO_MYPROJECT' put: (self msdosPathToPackage: self package from: aProjectID); 
        yourself

    "Modified: / 14-09-2006 / 18:59:26 / cg"
!

subProjectLine_make_dot_proto_mappings: aProjectID 
    ^ Dictionary new
        at: 'LIBRARY_NAME' put: (self libraryNameFor:aProjectID );     
        at: 'PATH_TO_SUB_PROJECT' put: (self pathToPackage:aProjectID from:self package withSeparator:'/'); 
        at: 'PATH_TO_MYPROJECT' put: (self pathToPackage:self package from:aProjectID withSeparator:'/'); 
        yourself

    "Modified: / 14-09-2006 / 18:59:26 / cg"
! !

!ApplicationDefinition class methodsFor:'file mappings support'!

generateAllPreRequisiteLibs_modules_dot_stx
    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:projectID | 
            (self shouldBeLoadedInitially:projectID) ifFalse:[
                s nextPut:$*.
            ].
            s nextPutLine:(self libraryNameFor:projectID).
        ].
        self isGUIApplication ifTrue:[
            self guiClassFileNames_win32 do:[:eachFilename |
                s nextPutLine:(eachFilename asFilename withoutSuffix baseName)
            ].
        ].
    ].

    "
     exept_expecco_application generateAllPreRequisiteLibs_modules_dot_stx
    "

    "Modified: / 07-09-2006 / 17:22:58 / cg"
!

generateExtensionLine: extensionLineTemplate

    ^self hasExtensionMethods
        ifFalse:['']
        ifTrue:[
            self replaceMappings: 
                (Dictionary new 
                    at: 'CLASS' put:( self st2c:(ProjectDefinition projectDefinitionClassNameForDefinitionOf:self package) );
                    yourself)
                in: extensionLineTemplate
            ]

    "Created: / 18-11-2010 / 09:38:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generatePreRequisiteLibs_modules_dot_stx
    ^ String streamContents:[:s |
        self effectivePreRequisites do:[:projectID | 
            (self shouldBeLoadedInitially:projectID) ifFalse:[
                s nextPut:$*.
            ].
            s nextPutLine:(self libraryNameFor:projectID).
        ].
    ].

    "
     exept_expecco_application generatePreRequisiteLibs_modules_dot_stx
    "

    "Modified: / 07-09-2006 / 17:22:58 / cg"
!

generatePreRequisiteLines_bc_dot_mak         

    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:eachPackage |
            |mappings newObjectLine|
            mappings := self preRequisiteLine_bc_dot_mak_mappings: eachPackage.
            newObjectLine := self replaceMappings: mappings
                                in: self preRequisiteLine_bc_dot_mak.
            s nextPutAll:newObjectLine. 
            s cr. 
        ].
        self guiClasses_win32 do:[:eachClass |
            |mappings newObjectLine|
            mappings := self preRequisiteLine_bc_dot_mak_mappingsForClass: eachClass.
            newObjectLine := self replaceMappings: mappings
                                in: self preRequisiteLine_bc_dot_mak.
            s nextPutAll:newObjectLine. 
            s cr. 
        ].
    ]

    "
     bosch_dapasx_application generatePreRequisiteLines_bc_dot_mak 
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 14-09-2006 / 21:58:47 / cg"
!

generatePreRequisiteLines_make_dot_proto        

    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:eachPackage |
            |mappings newObjectLine|
            mappings := self preRequisiteLine_make_dot_proto_mappings: eachPackage.
            newObjectLine := self replaceMappings: mappings
                                in: self preRequisiteLine_make_dot_proto.
            s nextPutAll:newObjectLine. 
            s cr. 
        ].
        self guiClasses_unix do:[:eachClass |
            |mappings newObjectLine|
            mappings := self preRequisiteLine_make_dot_proto_mappingsForClass: eachClass.
            newObjectLine := self replaceMappings: mappings
                                in: self preRequisiteLine_make_dot_proto.
            s nextPutAll:newObjectLine. 
            s cr. 
        ].
    ]

    "
     exept_expecco_application generatePreRequisiteLines_bc_dot_mak 
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 14-09-2006 / 21:58:47 / cg"
!

generateRequiredLibobjs_make_dot_proto
    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:projectID |
            |libobjPath libPath|

            libPath := self pathToPackage:projectID withSeparator:'/'.
            libobjPath := libPath , '/', (self libraryNameFor:projectID).
            s space; nextPutAll: libobjPath; nextPutLine:'$(O_EXT) \'.
        ].

        s cr.
    ].

    "
     exept_expecco_application generateRequiredLibobjs_make_dot_proto      
    "
!

generateRequiredLibs_bc_dot_mak
    ^ String streamContents:[:s |
        s nextPutLine:' \'.
        self allPreRequisitesSorted do:[:projectID | 
            s space; nextPutAll:(self libraryNameFor:projectID); nextPutLine:'.dll \'.
        ].

"/ Subprojects are not linked to the exe!!
"/        self subProjects do:[:projectID | 
"/            s space; nextPutAll:(self libraryNameFor:projectID),'.dll'; nextPutLine:' \'.
"/        ].

        self isGUIApplication ifTrue:[
            self guiClassFileNames_win32 do:[:eachFilename |
                s space; nextPutAll:eachFilename; nextPutLine:' \'.
            ].
        ].
        s cr.
    ].

    "
     bosch_dapasx_application generateRequiredLibs_bc_dot_mak      
    "

    "Modified: / 07-09-2006 / 17:22:51 / cg"
!

generateRequiredLibs_make_dot_proto
    "/ cg: why not (self libraryNameFor:projectID),'.so'; ???
    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:projectID | 
            s space; nextPutAll:(self libraryNameFor:projectID); nextPutLine:' \'.
        ].
"/ Subprojects are only built, but not linked to the executable!!
"/        self subProjects do:[:projectID | 
"/            s space; nextPutAll:(self libraryNameFor:projectID); nextPutLine:' \'.
"/        ].

        self isGUIApplication ifTrue:[
            self guiClassFileNames_unix do:[:eachFilename |
                s space; nextPutAll:eachFilename; nextPutLine:' \'.
            ].
        ].
        s cr.
    ].

    "
     alspa_batch_application generateRequiredLibs_make_dot_proto      
    "
!

generateRequiredLinkLibobjs_make_dot_proto

    ^ String streamContents:[:s |
        self allPreRequisitesSorted do:[:projectID | 
            s space; nextPutAll:(self libraryNameFor:projectID),'$(O_EXT)'; nextPutLine:' \'.
        ].

        self isGUIApplication ifTrue:[
            self guiClassFileNames_unix do:[:eachFilename |
                s space; nextPutAll:eachFilename,'$(O_EXT)'; nextPutLine:' \'.
            ].
        ].
"/        self subProjects do:[:projectID | 
"/            s space; nextPutAll:(self libraryNameFor:projectID),'$(O_EXT)'; nextPutLine:' \'.
"/        ].
        s cr.
    ].

    "
     alspa_batch_application generateRequiredLinkLibobjs_make_dot_proto      
    "
!

generateSubProjectLibs_bc_dot_mak         
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#win32) do:[:projectID | 
            |libPath libobjPath|

            libPath := self pathToPackage:projectID withSeparator:'\'.
            libobjPath := libPath , '\$(OBJDIR)\', (self libraryNameFor:projectID).
            s space; nextPutAll:libobjPath; nextPutLine:'.dll \'.
        ].
        s cr.
    ].

    "
     exept_expecco_application generateSubProjectLibs_bc_dot_mak 
     cg_newCompiler_driver_stc generateSubProjectLines_bc_dot_mak 
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 14-09-2006 / 18:46:09 / cg"
    "Modified: / 17-01-2017 / 21:26:08 / stefan"
!

generateSubProjectLibs_make_dot_proto
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#unix) do:[:projectID | 
            |libPath libobjPath|

            libPath := self pathToPackage:projectID withSeparator:'/'.
            libobjPath := libPath , '/', (self libraryNameFor:projectID).
            s space; nextPutAll:libobjPath; nextPutLine:'$(O_EXT) \'.
        ].
        s cr.
    ].

    "
     exept_expecco_application generateSubProjectLibs_make_dot_proto      
    "

    "Modified: / 17-01-2017 / 16:16:38 / stefan"
!

generateSubProjectLines_bc_dot_mak         
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#win32) do:[:projectID |
            |mappings newObjectLine|

            mappings := self subProjectLine_bc_dot_mak_mappings: projectID.
            newObjectLine := self replaceMappings: mappings
                                in: self subProjectLine_bc_dot_mak.
            s nextPutAll:newObjectLine. 
            s cr. 
        ]
    ]

    "
     exept_expecco_application generateSubProjectLines_bc_dot_mak 
     bosch_dapasx_application generateSubProjectLines_bc_dot_mak 
     cg_newCompiler_driver_stc generateSubProjectLines_bc_dot_mak 
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 14-09-2006 / 18:46:09 / cg"
    "Modified (comment): / 17-01-2017 / 17:01:38 / stefan"
!

generateSubProjectLines_make_dot_proto         
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#unix) do:[:projectID |
            |mappings newObjectLine|

            mappings := self subProjectLine_make_dot_proto_mappings: projectID.
            newObjectLine := self replaceMappings: mappings
                                in: self subProjectLine_make_dot_proto.
            s nextPutAll:newObjectLine. 
            s cr. 
        ]
    ]

    "
     exept_expecco_application generateSubProjectLines_make_dot_proto 
     cg_newCompiler_driver_stc generateSubProjectLines_make_dot_proto
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 14-09-2006 / 18:46:09 / cg"
    "Modified: / 17-01-2017 / 16:17:16 / stefan"
!

generateSubProjectLines_modules_dot_stx
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#win32) do:[:projectID |
            (self shouldBeLoadedInitially:projectID) ifFalse:[
                s nextPut:$*.
            ].
            s nextPutLine:(self libraryNameFor:projectID).
        ].
    ].

    "
     exept_expecco_application generateSubProjectLines_modules_dot_stx
     cg_newCompiler_driver_stc generateSubProjectLines_modules_dot_stx
    "

    "Modified: / 17-08-2006 / 17:22:37 / cg"
    "Modified: / 17-01-2017 / 16:17:36 / stefan"
! !

!ApplicationDefinition class methodsFor:'file templates'!

bc_dot_def
    "the template code for the bc.def file"

^ 
'DESCRIPTION     %(DESCRIPTION)
CODE            PRELOAD MOVEABLE DISCARDABLE
SEGMENTS
    INITCODE    PRELOAD DISCARDABLE
'

    "Created: / 08-08-2006 / 12:26:58 / fm"
    "Modified: / 08-08-2006 / 19:32:27 / fm"
    "Modified: / 17-08-2006 / 20:05:17 / cg"
!

bc_dot_mak
    "answer a template for the bc.mak makefile.
     Any variable definition %(Variable) will be later replaced by the mapping.
     $% characters have to be duplicated"

^ '# $','Header','$
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Historic Note:
#  this used to contain only rules to make with borland 
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
# Rules found here:
#   bmake 
#       - build everything, incl. a self installing exe for deployment
#   bmake exe
#       - only build the executable; to be executed and tested here
#   bmake setup
#       - make the self installing exe (assuming that the exe is already present)
#   bmake clean
#       - remove everything that is not needed to execute
#   bmake clobber
#       - remove everything that cannot be reconstructed by bmake
#
# For a 64bit build, replace bmake by mingwmake.

TOP=%(TOP)       
INCLUDE_TOP=$(TOP)\..

# An old file, used as a dummy target for FORCE if we do not want
#   re-make libraries. Windows make does not work if we redefine FORCE=   (empty string)
# OLD_FILE=bmake.bat
OLD_FILE="c:\windows\win.ini"

#dummy target to force a build
!!ifndef FORCE
FORCE=$(OLD_FILE)
!!endif

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"%(STARTUP_CLASS)\"" \
 -DSTARTUP_SELECTOR="\"%(STARTUP_SELECTOR)\"" \
 -DUSE_MODULE_TABLE

#

!!INCLUDE $(TOP)\rules\stdHeader_bc
!!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

%(ADDITIONAL_DEFINITIONS)

#
APPNAME=%(LIBRARY_NAME)
LIBNAME=%(LIBRARY_NAME)
MODULE_PATH=%(MODULE_PATH)
STCOPT="+optinline"
LOCALINCLUDES=%(LOCAL_INCLUDES)
LOCALDEFINES=%(LOCAL_DEFINES)
GLOBALDEFINES=%(GLOBAL_DEFINES)

STCLOCALOPT=''-package=$(PACKAGE)'' $(LOCALDEFINES) $(LOCALINCLUDES) %(HEADEROUTPUTARG) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LFLAGS=$(APP_LFLAGS)

PROJECT_NOCONSOLE= %(NOCONSOLE_APPLICATION)
PROJECT_CONSOLE= %(CONSOLE_APPLICATION)
ALLOBJFILES= main.$(O)
!!ifdef USETCC
RESFILES=
!!else
RESFILES= %(RESFILENAME)
!!endif

ALLOBJ= $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
ALLLIB=$(LIBFILES) $(APP_IMPORTLIBS) $(APP_RT_LIB)

!!if defined(USEMINGW32)
RT_DLL=libgcc_s_dw2-1.dll
!!endif

REQUIRED_LIBS=librun.dll %(REQUIRED_LIBS)
REQUIRED_FILES=$(RT_DLL) $(X11_DLL) $(XEXT_DLL) symbols.stc $(REQUIRED_LIBS)

SUBPROJECT_LIBS=%(SUBPROJECT_LIBS)

REQUIRED_SUPPORT_DIRS=%(REQUIRED_SUPPORT_DIRS)

target: %(BUILD_TARGET) postBuildCleanup 

# the executable, all required files and a self-installing-installer-exe
ALL:: prereq ALL_NP

# all, but no prereqs
ALL_NP:: exe $(REQUIRED_SUPPORT_DIRS) postBuildCleanup subProjects

exe:  newBuildDate $(REQUIRED_LIBS) noConsoleApp consoleApp registerApplication

# the executable only
# with console
consoleApp: $(REQUIRED_LIBS)
        -del main.$(O)
        $(MAKE) -N -f bc.mak $(USE_ARG) \
                MAKE_BAT=$(MAKE_BAT) \
                PROJECT=$(PROJECT_CONSOLE) \
                CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_CONSOLE)" \
                LFLAGS_APPTYPE=" $(LFLAGS_CONSOLE)" \
                CRT_STARTUP=" $(CRT_STARTUP_CONSOLE)" theExe

# without console
noConsoleApp: $(REQUIRED_LIBS)
        -del main.$(O)
        $(MAKE) -N -f bc.mak $(USE_ARG) \
                MAKE_BAT=$(MAKE_BAT) \
                PROJECT=$(PROJECT_NOCONSOLE) \
                CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_NOCONSOLE) -DWIN_LOGFILE="\\"\"%(NOCONSOLE_LOGFILE)\\"\""" \
                LFLAGS_APPTYPE=" $(LFLAGS_NOCONSOLE)" \
                CRT_STARTUP=" $(CRT_STARTUP_NOCONSOLE)" theExe

# the executable only (internal target; needs some defines)
theExe: $(OUTDIR) $(OBJS) $(REQUIRED_FILES) show $(PROJECT) 

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
        $(MAKE) -N -f bc.mak $(USE_ARG) FORCE=FORCE_BUILD makePrereq

makePrereq: $(REQUIRED_LIBS)

subProjects:
        $(MAKE) -N -f bc.mak $(USE_ARG) FORCE=FORCE_BUILD makeSubProjects

makeSubProjects: $(SUBPROJECT_LIBS)
        @echo "sub-projects made"

FORCE_BUILD:
        @rem Dummy target to force a build

# a nullsoft installable delivery
# This uses the Nullsoft Installer Package and works in Windows only

!!if defined(USEMINGW64)

setup: $(PROJECT) postBuildCleanup %(NSI_FILENAME) 
        $(MAKENSIS) /DOBJ_DIR=objmingw /DSETUP_NAME=%(PRODUCT_FILENAME)Setup64 %(NSI_FILENAME)
        %(ADDITIONAL_POSTNSISRULES64)

!!else

setup: $(PROJECT) postBuildCleanup %(NSI_FILENAME)
        $(MAKENSIS) /DOBJ_DIR=objbc /DSETUP_NAME=%(PRODUCT_FILENAME)Setup %(NSI_FILENAME)
        %(ADDITIONAL_POSTNSISRULES)

!!endif

newBuildDate:
        del buildDate.h

new:
        $(MAKE_BAT) clean
        $(MAKE_BAT)

RESOURCEFILES: %(APPLICATION)_RESOURCES %(APPLICATION)_BITMAPS %(ADDITIONAL_RESOURCE_TARGETS) \
        stx_RESOURCES stx_STYLES stx_BITMAPS

%(RESOURCE_RULES)
%(STX_RESOURCE_RULES)

%(APP_SOURCE_RULES)
%(STX_SOURCE_RULES)

%(PREREQUISITES_LIBS)      
%(SUBPROJECTS_LINES)

sources: 
        mkdir sources

show:
        @echo LFLAGS= $(LFLAGS)
        @echo ALLOBJ= $(ALLOBJ)
        @echo PROJECT= $(PROJECT)
        @echo APP_IMPORTLIBS= $(APP_IMPORTLIBS)
        @echo ALLLIB= $(ALLLIB)
        @echo DEFFILE= $(DEFFILE)
        @echo ALLRES= $(ALLRES)

!!ifdef USEBC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_CONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_NOCONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

!!else
!! ifdef USEVC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) /OUT:"$(PROJECT_CONSOLE)" \
            /MANIFEST /MANIFESTFILE:"$(PROJECT_CONSOLE).manifest" \
            /PDB:"$(PROJECT_CONSOLE).pdb" \
            /SUBSYSTEM:CONSOLE $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) /OUT:"$(PROJECT_NOCONSOLE)" \
            /MANIFEST /MANIFESTFILE:"$(PROJECT_NOCONSOLE).manifest" \
            /PDB:"$(PROJECT_NOCONSOLE).pdb" \
            /SUBSYSTEM:WINDOWS $(ALLLIB) $(RESFILES)

!! else
!!  ifdef USELCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) -subsystem console $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) -subsystem windows $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!!  else
!!   ifdef USETCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!!   else
!!    if defined(USEMINGW32) || defined(USEMINGW64)

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(APP_IMPORTLIBS) $(RESFILES)

!!    else
error error error
!!    endif
!!   endif
!!  endif
!! endif
!!endif

!!INCLUDE $(TOP)\rules\stdRules_bc

#
# additional rules
#
%(APPLICATION)Win.$(RES): %(APPLICATION)Win.rc %(APPLICATION).ico

main.$(O): buildDate.h main.c bc.mak

main.c: $(TOP)\librun\main.c
        copy $(TOP)\librun\main.c main.c

# now in stdRules.
#buildDate.h: $(GENDATE_UTILITIY)
#        $(GENDATE_UTILITIY)

librun.dll: $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll
        copy $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll librun.dll

!!ifdef USEBC 
#cs3245.dll
$(RT_DLL): $(TOP)\support\win32\borland\$(RT_DLL)
        copy $(TOP)\support\win32\borland\$(RT_DLL) $(RT_DLL)

X11.dll: $(TOP)\support\win32\X11.dll
        copy $(TOP)\support\win32\X11.dll X11.dll

Xext.dll: $(TOP)\support\win32\Xext.dll
        copy $(TOP)\support\win32\Xext.dll Xext.dll
!!endif

!!if defined(USEMINGW32)
$(RT_DLL): $(MINGW_DIR)\bin\$(RT_DLL)
        -copy $(MINGW_DIR)\bin\$(RT_DLL) $(RT_DLL)
        -copy $(MINGW_DIR)\bin\libwinpthread-1.dll libwinpthread-1.dll
!!endif

symbols.stc: $(TOP)\include\symbols.stc
        copy $(TOP)\include\symbols.stc symbols.stc

%(ADDITIONAL_RULES)

%(ADDITIONAL_HEADERRULES)

clean::
        -del genDate.exe genDate.com
        -del c0x32.dll
        -del c0x32.lib
        -del buildDate.h
        -del $(PROJECT)
        -del install_%(APPLICATION).exe
        -del stx.lib
        -del stx.dll
        -del $(RT_DLL)
        -del $(REQUIRED_FILES)
        -del main.c
        -del *.log
        -del *.$(RES)
        -rmdir /S /Q resources
        -rmdir /S /Q $(OBJDIR)

clobber:: clean
        -del *.dll *.exe *.com

postBuildCleanup::
        @rem  stupid win-make does not allow empty

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line
%(ADDITIONAL_RULES_HG)'.

    "Modified: / 02-06-2015 / 17:40:03 / gg"
    "Modified: / 03-03-2016 / 21:15:43 / cg"
    "Modified: / 19-01-2017 / 11:50:05 / stefan"
    "Modified: / 25-01-2017 / 20:03:01 / jv"
    "Modified: / 29-08-2018 / 13:32:38 / svestkap"
!

bc_dot_mak_app_source_rules
    |p|

    ^ String streamContents:[:s |
        s nextPutAll:'
%(APPLICATION)_SOURCES: sources\%(MODULE)\%(MODULE_PATH)
        -copy ..\*.st sources\%(MODULE)\%(MODULE_PATH)\..\*.*

'.

        p := self moduleDirectory_win32 asCollectionOfSubstringsSeparatedBy:$\.
        p size to:2 by:-1 do:[:len |
            |part2 part1|

            part2 := (p copyTo:len) asStringWith:$\.
            part1 := (p copyTo:len-1) asStringWith:$\.
            s nextPutAll:'
sources\%(MODULE)\',part2,': sources\%(MODULE)\',part1,'
        mkdir sources\%(MODULE)\',part2,'
'.
            s cr.
        ].

        s nextPutAll:'
sources\%(MODULE)\',p first,': sources\%(MODULE)
        mkdir sources\%(MODULE)\',p first,'
'.
        s cr.

        "/ be careful to not include two rules for it (-> stx_source_rules).
        self module ~= 'stx' ifTrue:[
            s nextPutAll:
'sources\%(MODULE): sources
        mkdir sources\%(MODULE)
'.
        ].
    ]

    "Created: / 15-05-2007 / 17:27:37 / cg"
    "Modified: / 29-08-2018 / 13:32:23 / svestkap"
!

bc_dot_mak_resource_rules
    |p|

    ^ String streamContents:[:s |
        s nextPutAll:'
%(APPLICATION)_RESOURCES: resources\%(MODULE)\%(MODULE_PATH)
        -copy ..\resources\*.rs resources\%(MODULE)\%(MODULE_PATH)\..
        -copy ..\resources\*.style resources\%(MODULE)\%(MODULE_PATH)\..

%(APPLICATION)_BITMAPS: resources\%(MODULE)\%(MODULE_PATH)\bitmaps
        -copy *.ico resources\%(MODULE)\%(MODULE_PATH)\bitmaps
        -copy *.gif resources\%(MODULE)\%(MODULE_PATH)\bitmaps

resources\%(MODULE)\%(MODULE_PATH)\bitmaps: resources\%(MODULE)\%(MODULE_PATH)
        mkdir resources\%(MODULE)\%(MODULE_PATH)\bitmaps
'.

        p := self moduleDirectory_win32 asCollectionOfSubstringsSeparatedBy:$\.
        p size to:2 by:-1 do:[:len |
            |part2 part1|

            part2 := (p copyTo:len) asStringWith:$\.
            part1 := (p copyTo:len-1) asStringWith:$\.
            s nextPutAll:'
resources\%(MODULE)\',part2,': resources\%(MODULE)\',part1,'
        mkdir resources\%(MODULE)\',part2,'
'.
        ].

        s nextPutAll:'
resources\%(MODULE)\',p first,': resources\%(MODULE)
        mkdir resources\%(MODULE)\',p first,'
'.

        "/ be careful to not include two rules for it (-> stx_resource_rules).
        self module ~= 'stx' ifTrue:[
            s nextPutAll:
'resources\%(MODULE): resources
        mkdir resources\%(MODULE)
'.
        ].
    ]

    "Modified: / 09-02-2007 / 16:13:43 / cg"
    "Modified: / 29-08-2018 / 13:31:41 / svestkap"
!

bc_dot_mak_stx_resource_rules
    |rsrcs|

    self isGUIApplication ifTrue:[
        rsrcs := '

stx_RESOURCES: \
        keyboard.rc \
        keyboardMacros.rc \
        host.rc \         
        display.rc \
        d_win32.rc \
        libbasic_RESOURCES \
        libview_RESOURCES \
        libtool_RESOURCES  \
        libtool2_RESOURCES
'
    ] ifFalse:[
        rsrcs := '

stx_RESOURCES: \
        host.rc \
        libbasic_RESOURCES \
'
    ].

    ^ rsrcs , '

keyboard.rc: $(TOP)\projects\smalltalk\keyboard.rc
        copy $(TOP)\projects\smalltalk\keyboard.rc *.*

keyboardMacros.rc: $(TOP)\projects\smalltalk\keyboardMacros.rc
        copy $(TOP)\projects\smalltalk\keyboardMacros.rc *.*

host.rc: $(TOP)\projects\smalltalk\host.rc
        copy $(TOP)\projects\smalltalk\host.rc *.*

display.rc: $(TOP)\projects\smalltalk\display.rc
        copy $(TOP)\projects\smalltalk\display.rc *.*

d_win32.rc: $(TOP)\projects\smalltalk\d_win32.rc
        copy $(TOP)\projects\smalltalk\d_win32.rc *.*

stx_STYLES: resources\stx\libview  resources\stx\libview\styles
        -copy $(TOP)\libview\styles\*.style resources\stx\libview\styles\*.*
        -copy $(TOP)\libview\styles\*.common resources\stx\libview\styles\*.*

stx_BITMAPS: \
        libwidg_BITMAPS

libwidg_BITMAPS: resources\stx\libwidg\bitmaps
        -copy $(TOP)\libwidg\bitmaps\*.xpm resources\stx\libwidg\bitmaps\*.*

libbasic_RESOURCES: resources\stx\libbasic
        -copy $(TOP)\libbasic\resources\*.rs resources\stx\libbasic\*.*

libtool_RESOURCES: resources\stx\libtool
        -copy $(TOP)\libtool\resources\*.rs resources\stx\libtool\*.*

libtool2_RESOURCES: resources\stx\libtool2
        -copy $(TOP)\libtool2\resources\*.rs resources\stx\libtool2\*.*

libview_RESOURCES: resources\stx\libview 
        -copy $(TOP)\libview\resources\*.rs resources\stx\libview\*.*

libview2_RESOURCES: resources\stx\libview2
        -copy $(TOP)\libview2\resources\*.rs resources\stx\libview2\*.*

resources\stx\libbasic: resources\stx
        mkdir resources\stx\libbasic

resources\stx\libtool: resources\stx
        mkdir resources\stx\libtool

resources\stx\libtool2: resources\stx
        mkdir resources\stx\libtool2

resources\stx\libview: resources\stx
        mkdir resources\stx\libview

resources\stx\libview\styles: resources\stx\libview
        mkdir resources\stx\libview\styles

resources\stx\libview2: resources\stx
        mkdir resources\stx\libview2

resources\stx\libwidg\bitmaps: resources\stx\libwidg
        mkdir resources\stx\libwidg\bitmaps

resources\stx\libwidg: resources\stx
        mkdir resources\stx\libwidg

resources\stx: resources
        mkdir resources\stx

resources:
        mkdir resources

bitmaps:
        mkdir bitmaps

doc:
        mkdir doc

'.

    "Created: / 20-09-2006 / 17:36:29 / cg"
    "Modified: / 06-06-2016 / 16:06:01 / cg"
    "Modified: / 29-08-2018 / 13:29:25 / svestkap"
!

bc_dot_mak_stx_source_rules
    |libDirs|

    libDirs := self stxSourcesProjects collect:[:projectID | self moduleDirectory_win32For:projectID].

    ^ String streamContents:[:s |
        s nextPutAll:'
STX_SOURCES:'.
        libDirs do:[:libDir |
            s nextPutAll:' '; nextPutAll:('sources\stx\',libDir)
        ].
        s cr.

        libDirs do:[:libDir |
            s nextPutLine:('sources\stx\',libDir,': sources\stx').
            s tab; nextPutLine:('mkdir sources\stx\',libDir).
            s tab; nextPutLine:('-copy $(TOP)\',libDir,'\*.st sources\stx\',libDir,'\*.*').
            s cr.
        ].
        s nextPutLine:'sources\stx: sources'.
        s tab; nextPutLine:'mkdir sources\stx'.
        s cr.
    ]

    "Created: / 15-05-2007 / 17:27:37 / cg"
    "Modified: / 29-08-2018 / 13:23:42 / svestkap"
!

bmake_dot_mak
    "the template code for the bmake.bat file
     Notice: duplicate %'s if they are needed as such in the generated file"

    ^
'@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

make.exe -N -f bc.mak  %%DEFINES%% %%*

@IF "%%1" EQU "exe" exit /b 0
@IF "%%1" EQU "setup" exit /b 0
@IF "%%1" EQU "pluginSetup" exit /b 0

%(SUBPROJECT_BMAKE_CALLS)
'

    "Created: / 17-08-2006 / 20:04:14 / cg"
    "Modified: / 04-09-2012 / 11:46:22 / cg"
!

buildDate_dot_h
    "the template code for the buildDate.h file"

^ 
'#define BUILD_DATE "%(BUILDDATE)"'

    "Created: / 30-08-2006 / 19:18:34 / cg"
!

classLine_modules_dot_c

^'_%(CLASS)_Init,'

    "Modified: / 08-08-2006 / 15:46:05 / fm"
    "Created: / 19-09-2006 / 22:49:46 / cg"
!

classLine_modules_dot_c_extern

^'extern void _%(CLASS)_Init();'

    "Modified: / 08-08-2006 / 15:46:05 / fm"
    "Created: / 19-09-2006 / 22:50:14 / cg"
!

defineAPPSourceLine_nsi_for: projectID

^      
'   
    SetOutPath "$INSTDIR\sources\',(self moduleFor: projectID),'\',(self moduleDirectory_win32For:projectID) ,'"
    File /r "${STX_ROOT}\', (self moduleFor: projectID) ,'\',(self moduleDirectory_win32For:projectID) ,'\*.st"'

    "Created: / 15-10-2006 / 12:50:00 / cg"
!

defineExtenionLine_nsi_for:extension
    "the template code for a single extenions definition line in the <appname>.nsi file"

    ^ '  WriteRegStr HKCR ".',extension,'" "" "%(MODULE_KEY).%(PRODUCT_FILENAME).1"'

    "Created: / 15-10-2006 / 12:50:00 / cg"
!

defineExtensionLine_nsi_for:extension 
    "the template code for a single extenions definition line in the <appname>.nsi file"
    
    ^ '  WriteRegStr HKCR ".' , extension 
        , '" "" "%(MODULE_KEY).%(PRODUCT_FILENAME).1"'

    "Created: / 15-10-2006 / 12:50:00 / cg"
!

defineSTXSourceLine_nsi_for: projectID

^      
'  
    SetOutPath "$INSTDIR\sources\stx\', (self moduleDirectory_win32For:projectID),'"
    File /r "${STX_ROOT}\stx\', (self moduleDirectory_win32For:projectID),'\*.st"'

    "Created: / 15-10-2006 / 12:50:00 / cg"
!

extensionsLine_modules_dot_c

    ^'_%(CLASS)_extensions_Init,'

    "Created: / 18-11-2010 / 10:36:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionsLine_modules_dot_c_extern

    ^'extern void _%(CLASS)_Init();'

    "Created: / 03-03-2011 / 19:13:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installFileLine_nsi_for:filePattern
    "the template code for a single file-install pattern to be added to the <appname>.nsi file"

    (filePattern startsWith:'SetOutPath ') ifTrue:[
        ^ filePattern.
    ].        

    ^  '  File ', filePattern

    "Created: / 01-03-2007 / 20:00:20 / cg"
!

linuxSetupRules
    "this is sliced into the generated Make.proto file"
    
    ^ '
#
# for linux, this uses autopackage
# (SETUP_RULE is set to setup_linux)
setup_linux:
        @if test -d autopackage; then \
            if which autopackage; then \
		makepackage; \
	    else \
		echo "Warning: autopackage not found, installer NOT created"; \
	    fi \
        else \
            echo "Error: missing autopackage directory"; \
            exit 1; \
        fi
        
# backward compatible fallback
setup::
        @if test -d autopackage; then \
            if which autopackage; then \
		makepackage; \
	    else \
		echo "Warning: autopackage not found, installer NOT created"; \
	    fi \
	else \
            echo "Error: make setup not yet available in this unix"; \
            exit 1; \
        fi
'
!

make_dot_proto

^
'# $','Header','$
#
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
#
# -------------- no need to change anything below ----------
#
# This makefile generates some standalone demo applications
#
#    make
#       generates %(APPLICATION)
#

TOP=%(TOP)
INCLUDE_TOP=$(TOP)/..

# set to a dummy file name (like FORCE=@@@FORCE-BUILD@@@) to force the build of prereq packages
FORCE=
.PHONY: $(FORCE)

PACKAGE=%(APPLICATION_PACKAGE)
SUBDIRS=
SUPPRESS_LOCAL_ABBREVS="yes"
NOAUTOLOAD=1
NOSUBAUTOLOAD=1

LOCALINCLUDES=%(LOCAL_INCLUDES)
LOCALDEFINES=%(LOCAL_DEFINES)
GLOBALDEFINES=%(GLOBAL_DEFINES)
MAIN_DEFINES=%(MAIN_DEFINES)

RCSSOURCES=Make.proto *.st
LINKSOURCES=Make.proto *.st

DELIVERBINARIES=

APPNAME=%(LIBRARY_NAME)
LIBNAME=%(LIBRARY_NAME)
STCLOCALOPT=''-package=$(PACKAGE)'' -I. -headerDir=. $(LOCALINCLUDES) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) %(HEADEROUTPUTARG) %(COMMONSYMFLAG) -varPrefix=$(LIBNAME)


# ********** OPTIONAL: MODIFY the next line ***
# additional C-libraries that should be pre-linked with the class-objects
LD_OBJ_LIBS=%(ADDITIONAL_LINK_LIBRARIES)
LOCAL_SHARED_LIBS=%(ADDITIONAL_SHARED_LINK_LIBRARIES)


# ********** OPTIONAL: MODIFY the next line ***
# additional C targets or libraries should be added below
LOCAL_EXTRA_TARGETS=

OBJS= $(COMMON_OBJS) $(UNIX_OBJS)

%(ADDITIONAL_DEFINITIONS)

%(ADDITIONAL_DEFINITIONS_SVN)

LIBLIST = $(REQUIRED_LIBS)

# required libs:
#

REQUIRED_LIBS=%(REQUIRED_LIBS)
REQUIRED_LIBOBJS=%(REQUIRED_LIBOBJS)
REQUIRED_LINK_LIBOBJS=%(REQUIRED_LINK_LIBOBJS)
REQUIRED_SUPPORT_DIRS=%(REQUIRED_SUPPORT_DIRS)

SUBPROJECT_LIBS=%(SUBPROJECT_LIBS)

target: %(BUILD_TARGET)

all::   prereq ALL_NP

# like ALL, but not prereqs
ALL_NP:: exe subProjects $(REQUIRED_SUPPORT_DIRS) $(SETUP_RULE)

exe:    %(APPLICATION) registerApplication

%(APPLICATION): $(APP_DIRS_TO_MAKE) $(APP_LIBOBJS) $(REQUIRED_LIBOBJS) $(OBJS)
        $(MAKE) link_%(APPLICATION)


link_%(APPLICATION):
        $(MAKE) %(APPLICATION_TYPE) \
                    TARGET=%(APPLICATION) \
                    APPLICATION_CLASSES="$(COMMON_CLASSES) $(UNIX_CLASSES)" \
                    APPLICATION_OBJS="$(OBJS)" \
                    APPLICATION_LIBLIST="$(REQUIRED_LIBS)" \
                    APPLICATION_LIBOBJS="$(REQUIRED_LIBOBJS)" \
                    APPLICATION_LINK_LIBOBJS="$(REQUIRED_LINK_LIBOBJS)" \
                    STARTUP_CLASS="%(STARTUP_CLASS)" \
                    STARTUP_SELECTOR="%(STARTUP_SELECTOR)" \
                    MAIN_DEFINES="%(MAIN_DEFINES)"

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
        $(MAKE) FORCE=@@@FORCE-BUILD@@@ makePrereq

makePrereq: $(REQUIRED_LIBOBJS)

subProjects:
        $(MAKE) FORCE=@@@FORCE-BUILD@@@ makeSubProjects

makeSubProjects: $(SUBPROJECT_LIBS)
        @echo "sub-projects made"

#
# a self installable delivery
#
',self linuxSetupRules,'
',self osxSetupRules,'

SOURCEFILES: %(APPLICATION)_SOURCES \
        stx_SOURCES

%(SOURCE_RULES)
%(STX_SOURCE_RULES)

RESOURCEFILES: %(APPLICATION)_RESOURCES %(APPLICATION)_BITMAPS %(ADDITIONAL_RESOURCE_TARGETS) \
        stx_RESOURCES stx_STYLES stx_BITMAPS

%(RESOURCE_RULES)
%(STX_RESOURCE_RULES)

%(PREREQUISITES_LIBS)

%(SUBPROJECTS_LINES)

%(ADDITIONAL_RULES)

%(ADDITIONAL_RULES_SVN)

%(ADDITIONAL_RULES_HG)

%(ADDITIONAL_HEADERRULES)

clean::
        -rm -f *.so %(APPLICATION).$(O)

clobber:: clean
        -rm -f %(APPLICATION) *.img *.sav

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line
'

    "Modified: / 09-08-2006 / 16:50:23 / fm"
    "Created: / 29-09-2006 / 23:47:07 / cg"
    "Modified: / 24-06-2009 / 21:40:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-07-2012 / 00:57:07 / cg"
    "Modified: / 19-01-2017 / 11:41:26 / stefan"
    "Modified: / 25-01-2017 / 22:01:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make_dot_proto_app_source_rules

    ^ String streamContents:[:s |
        s
          cr;
          nextPutAll: '%(APPLICATION)_SOURCES: '.
        self appSourcesProjects do:[:projectID |
            s nextPutAll: ' \
        ', (self make_dot_proto_source_title_for: projectID).
        ].
        s cr; cr.
        self appSourcesProjects do:[:projectID |
            s nextPutAll:(self make_dot_proto_app_source_rules_for: projectID) .
            s cr; cr.
        ].
    ].
!

make_dot_proto_app_source_rules_for: projectID

    | module moduleDirectory|

    module := self moduleFor: projectID.
    moduleDirectory := self moduleDirectoryFor:projectID.
    ^ String lf,
    (self make_dot_proto_source_title_for: projectID), ':
        mkdir -p sources/', module,'/', moduleDirectory, '
        cp $(TOP)/../', module, '/', moduleDirectory,'/*.st sources/', module,'/', moduleDirectory.
!

make_dot_proto_resource_rules
    ^ String streamContents:[:s |
        s nextPutAll:'
%(APPLICATION)_RESOURCES: 
        mkdir -p resources/%(MODULE)/%(MODULE_PATH)
        -cp ../resources/*.rs ../resources/*.style resources/%(MODULE)/%(MODULE_PATH)/..

%(APPLICATION)_BITMAPS: 
        mkdir -p resources/%(MODULE)/%(MODULE_PATH)/bitmaps
        -cp *.ico *.gif *.png resources/%(MODULE)/%(MODULE_PATH)/bitmaps
'.
    ].
!

make_dot_proto_source_title_for: projectID

    |packageName |

    packageName := self packageNameFor: projectID.
    ^ packageName, '_SOURCES'
!

make_dot_proto_stx_resource_rules
    self isGUIApplication ifFalse:[
        "/ non-GUI app: only include libbasic resources (for Date)
        ^ '
stx_RESOURCES: \
        libbasic_RESOURCES

stx_STYLES: 

stx_BITMAPS:

libbasic_RESOURCES: 
        mkdir -p resources/stx/libbasic
        -cp $(TOP)/libbasic/resources/*.* resources/stx/libbasic
'
    ].

    "/ GUI app: include all resources and rc files
    ^ '

stx_RESOURCES: \
        keyboard.rc \
        keyboardMacros.rc \
        display.rc \
        libbasic_RESOURCES \
        libview_RESOURCES \
        libtool_RESOURCES  \
        libtool2_RESOURCES

keyboard.rc: $(TOP)/projects/smalltalk/keyboard.rc
        cp $(TOP)/projects/smalltalk/keyboard.rc .

keyboardMacros.rc: $(TOP)/projects/smalltalk/keyboardMacros.rc
        cp $(TOP)/projects/smalltalk/keyboardMacros.rc .

display.rc: $(TOP)/projects/smalltalk/display.rc
        cp $(TOP)/projects/smalltalk/display.rc .

stx_STYLES: 
        mkdir -p resources/stx/libview
        mkdir -p resources/stx/libview/styles
        cp $(TOP)/libview/styles/*.common resources/stx/libview/styles
        cp $(TOP)/libview/styles/*.style resources/stx/libview/styles

stx_BITMAPS: \
        libwidg_BITMAPS

libwidg_BITMAPS: 
        mkdir -p resources/stx/libwidg/bitmaps
        -cp $(TOP)/libwidg/bitmaps/*.* resources/stx/libwidg/bitmaps

libbasic_RESOURCES: 
        mkdir -p resources/stx/libbasic
        -cp $(TOP)/libbasic/resources/*.* resources/stx/libbasic

libtool_RESOURCES: 
        mkdir -p resources/stx/libtool
        -cp $(TOP)/libtool/resources/*.* resources/stx/libtool

libtool2_RESOURCES: 
        mkdir -p resources/stx/libtool2
        -cp $(TOP)/libtool2/resources/*.* resources/stx/libtool2

libview_RESOURCES: 
        mkdir -p resources/stx/libview
        -cp $(TOP)/libview/resources/*.* resources/stx/libview

libview2_RESOURCES: 
        mkdir -p resources/stx/libview2
        -cp $(TOP)/libview2/resources/*.* resources/stx/libview2

bitmaps:
        mkdir -p bitmaps

doc:
        mkdir -p doc

'.
!

make_dot_proto_stx_source_rules

    ^ String streamContents:[:s |
        s
          cr;
          nextPutAll: 'stx_SOURCES: '.
        self stxSourcesProjects do:[:projectID |
            s nextPutAll: '\
        ', (self make_dot_proto_source_title_for: projectID).
        ].
        s cr; cr.
        self stxSourcesProjects do:[:projectID |
            s nextPutAll:(self make_dot_proto_stx_source_rules_for: projectID) .
            s cr; cr.
        ].
    ].
!

make_dot_proto_stx_source_rules_for: projectID

    | moduleDirectory|

    moduleDirectory := self moduleDirectoryFor:projectID.
    ^ String lf,
    (self make_dot_proto_source_title_for: projectID), ':
        mkdir -p sources/stx/', moduleDirectory, '
        cp $(TOP)/', moduleDirectory,'/*.st sources/stx/', moduleDirectory.
!

modules_dot_c

^ 
'/* $','Header','$
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: ',self name,'.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

%(EXTERN_INIT_NAME_LIST)

static vf modules[] = {
    %(INIT_LIST)
    (vf)0
};

vf *__modules__ = modules;
'

    "Created: / 19-09-2006 / 22:36:58 / cg"
!

modules_dot_stx

^ 
'# $','Header','$
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: ',self name,'.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file is (currently) only used with win-95 / win-NT versions of STX.
# It lists the dll''s which are to be loaded at startup time.
# Notice, lines starting with a "#" are comments.
# Lines starting with a "*" are treated as comments by the VM, but are usually loaded
# by the application at the very beginning.
#
# All classes loaded at startup time will be present as precompiled classes.
# Others might be autoloaded or loaded explicit using "Smalltalk loadPackage:xxx".
#
%(ALLPREREQUISITE_LIBS)
'

    "Created: / 08-08-2006 / 12:26:58 / fm"
    "Modified: / 08-08-2006 / 19:32:27 / fm"
    "Modified: / 16-08-2006 / 17:56:58 / User"
    "Modified: / 09-11-2010 / 11:57:39 / cg"
!

osxDmgImageSetupLines
    "generate (OSX unix) copy commands to generate a directory holding the dmg prototype image directory.
     This is used to generate a macOS deployable dmg containing an app"

    |genLine product productFile dmgVolume dmgDir appDir contentsDir macOSDir resourcesDir dirsMade|

    product := self productName.
    productFile := self productFilename.

    dmgVolume := productFile,'.dmg'.
    dmgDir := productFile,'_dmg'.
    appDir := dmgDir,'/',productFile,'.app'.
    contentsDir := appDir,'/Contents'.
    macOSDir := contentsDir,'/MacOS'.
    resourcesDir := contentsDir,'/Resources'.
    dirsMade := Set new.

    genLine :=
        [:s :d :srcAndDest |
            |sourcePattern relPath destination|

            sourcePattern := srcAndDest first.
            relPath := srcAndDest second.
            (relPath startsWith:'bin') ifTrue:[
                relPath := '.',(relPath copyFrom:4)
            ].
            destination := contentsDir,'/',d,'/',relPath.
            (dirsMade includes:destination) ifFalse:[
                s tab; nextPutLine:('@-mkdir "%1"' bindWith:destination).
                dirsMade add:destination.
            ].
            s tab; nextPutLine:('-cp -r %1 "%2"' bindWith:sourcePattern with:destination).
        ].

    ^ String streamContents:[:s |
        s tab; nextPutLine:('@-rm -rf "%1"' bindWith:dmgDir).
        s tab; nextPutLine:('@-mkdir "%1"' bindWith:dmgDir).  dirsMade add:dmgDir.
        s tab; nextPutLine:('@-mkdir "%1"' bindWith:appDir).  dirsMade add:appDir.
        s tab; nextPutLine:('@-mkdir "%1"' bindWith:contentsDir).  dirsMade add:contentsDir.
        s tab; nextPutLine:('@-mkdir "%1"' bindWith:macOSDir).  dirsMade add:macOSDir.
        s tab; nextPutLine:('cp "',self applicationName,'" "',macOSDir,'/"').
        s tab; nextPutLine:('@-cp osx/Info.plist "',contentsDir,'/"').
        "/ s tab; nextPutLine:('@-cp osx/PkgInfo "',contentsDir,'/"').
        self commonFilesToInstall_unix do:[:eachPair | genLine value:s value:'MacOS' value:eachPair].
        s tab; nextPutLine:('@-rm "%1/"*WINrc.rc' bindWith:macOSDir).
        self additionalFilesToInstall_unix do:[:eachPair | genLine value:s value:'MacOS' value:eachPair].
    ].
!

osxPkgDistributionScript
    "unfinished.
     generate (OSX unix) copy commands to generate a directory holding the pkg prototype image directory.
     This is used to generate a macOS deployable pkg containing libraries or non-GUI programs"

    |packageID product|

    product := self productName.
    packageID := self package copyReplaceAny:':/' with:$..

    ^  '
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<installer-gui-script minSpecVersion="1">
    <title>',product,'</title>
    <options customize="never"/>
    <allowed-os-versions>
        <os-version min="10.5"/>
    </allowed-os-versions>
    <installation-check script="InstallationCheck();"/>
    <script><!![CDATA[
function InstallationCheck () {
    if (system.compareVersions(system.version.ProductVersion, "10.5") < 0) {
        my.result.message = "This package is meant to be installed on Mac OS X 10.5 or newer.";
        my.result.type = ''Fatal'';
        return false;
    }
    if (system.files.fileExistsAtPath(''/opt/local/bin/',product,''')) {
        my.result.message = "',product,' is already installed.";
        my.result.type = ''Warn'';
        return false;
    }
    return true;
}
    ]]></script>
    <readme mime-type="text/html" file="ReadMe.html"/>
    <welcome mime-type="text/html" file="Welcome.html"/>
    <choices-outline>
        <line choice="default">
            <line choice="',packageID,'"/>
        </line>
    </choices-outline>
    <choice id="default"/>
    <choice id="',packageID,'" visible="false">
        <pkg-ref id="',packageID,'"/>
    </choice>
    <pkg-ref id="',packageID,'" version="0.2.3.3.0.0.0.0.0" installKBytes="14236">#MacPorts-2.3.3-component.pkg</pkg-ref>
    <pkg-ref id="',packageID,'">
        <bundle-version/>
    </pkg-ref>
    <product id="',packageID,'"/>
</installer-gui-script>
'.
!

osxPkgImageSetupLines
    "generate (OSX unix) copy commands to generate a directory holding the pkg prototype image directory.
     This is used to generate a macOS deployable pkg containing libraries or non-GUI programs"

    |product productFile pkgVolume pkgDir 
     optDir optLocalDir optLocalBinDir|

    product := self productName.
    productFile := self productFilename.

    pkgVolume := productFile,'.pkg'.
    pkgDir := productFile,'_pkg'.
    optDir := pkgDir,'/opt'.
    optLocalDir := optDir,'/local'.
    optLocalBinDir := optLocalDir,'/bin'.

    ^ String streamContents:[:s |
        s tab; nextPutLine:('-rm -rf "%1"' bindWith:pkgDir).
        s tab; nextPutLine:('-mkdir "%1"' bindWith:pkgDir).  
        s tab; nextPutLine:('-mkdir "%1"' bindWith:optDir). 
        s tab; nextPutLine:('-mkdir "%1"' bindWith:optLocalDir). 
        s tab; nextPutLine:('-mkdir "%1"' bindWith:optLocalBinDir). 
        s tab; nextPutLine:('cp "',self applicationName,'" "',optLocalBinDir,'/"').
    ].
!

osxSetupRules
    "this is sliced into the generated Make.proto file"

    self isGUIApplication ifTrue:[
        ^ self osxSetupRules_forDMG
    ].
    ^ self osxSetupRules_forPKG
!

osxSetupRules_forDMG
    "this is sliced into the generated Make.proto file"

    ^ '
#
# for mac, a dmg is generated
# (SETUP_RULE is set to setup_macosx)
#
setup_macosx:   "%(PRODUCT_FILENAME)_dmg"
        -rm "%(PRODUCT_FILENAME).dmg"
        hdiutil create -fs HFSX -layout SPUD "%(PRODUCT_FILENAME).dmg" -srcfolder "%(PRODUCT_FILENAME)_dmg" -format UDZO -volname "%(PRODUCT_NAME)" -quiet

app: "%(PRODUCT_FILENAME)_dmg"

"%(PRODUCT_FILENAME)_dmg": $(SUBPROJECT_LIBS) $(REQUIRED_SUPPORT_DIRS) 
%(OSX_DMG_SETUP)
'
!

osxSetupRules_forPKG
    "this is sliced into the generated Make.proto file"

    ^ '
#
# for mac, a pkg is generated
# (SETUP_RULE is set to setup_macosx)
#
setup_macosx:   "%(PRODUCT_FILENAME)_pkg"
        -rm "%(PRODUCT_FILENAME).pkg"
        pkgbuild --identifier "%(PRODUCT_ID)" --version "%(PRODUCT_VERSION)" --root %(PRODUCT_FILENAME)_pkg "%(PRODUCT_FILENAME).pkg"

app: "%(PRODUCT_FILENAME)_pkg"

"%(PRODUCT_FILENAME)_pkg": $(SUBPROJECT_LIBS) $(REQUIRED_SUPPORT_DIRS) 
%(OSX_PKG_SETUP)
'
!

packageName_dot_nsi
    "the template code for the <appname>.nsi file"

|docDirPath|

^ 
'; $','Header','$
; Script generated by ProjectDefinition.

!!define PRODUCT_NAME "%(PRODUCT_NAME)"
!!define PRODUCT_FILENAME "%(PRODUCT_FILENAME)"
!!define PRODUCT_VERSION "%(PRODUCT_VERSION)"
!!define PRODUCT_PUBLISHER "%(PRODUCT_PUBLISHER)"
!!define PRODUCT_WEB_SITE "%(PRODUCT_WEBSITE)"
!!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_FILENAME}"
!!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;
; SETUP_NAME can come from makefile as either setup or setup64
;
!!if "${SETUP_NAME}" == ""
SETUP_NAME="%(PRODUCT_NAME)Setup"
!!endif

!!define STX_ROOT "%(TOP)\.."

SetCompressor /solid lzma

!!include "MUI2.nsh"
!!include "x64.nsh"

; MUI Settings

!!define MUI_WELCOMEPAGE_TITLE_3LINES
!!define MUI_ABORTWARNING
%(SEMI_IF_ICON_EXISTS)!!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
%(SEMI_IF_NO_ICON_EXISTS)!!define MUI_ICON "%(APPLICATION_ICON).ico"
%(SEMI_IF_ICON_EXISTS)!!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
%(SEMI_IF_NO_ICON_EXISTS)!!define MUI_UNICON "%(APPLICATION_ICON).ico"

; Language Selection Dialog Settings
!!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!!insertmacro MUI_PAGE_WELCOME
; License page
; !!define MUI_LICENSEPAGE_CHECKBOX

',(self hasLicenceToAcceptDuringInstallation 
    ifTrue:['!!insertmacro MUI_PAGE_LICENSE $(license)']
    ifFalse:['']),'
!!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!!insertmacro MUI_PAGE_INSTFILES
; Finish page
!!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!!insertmacro MUI_LANGUAGE "English"
!!insertmacro MUI_LANGUAGE "German"

; MUI end ------

',((self hasLicenceToAcceptDuringInstallation and:[(docDirPath := self docDirPath_win32) notEmptyOrNil])
    ifTrue:['
LicenseLangString license ${LANG_ENGLISH} "' , docDirPath , '\licence_en.txt"
LicenseLangString license ${LANG_GERMAN}  "' , docDirPath , '\licence_de.txt"
']
    ifFalse:['']),'

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "%(FILE_VERSION)"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "%(LEGAL_COPYRIGHT)"


OutFile "${SETUP_NAME}.exe"
InstallDir "%(PRODUCT_INSTALLDIR)"
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

InstType Full
InstType Partial

Section "Programme" Section1
  SectionIn 1 2
  SetOutPath "$INSTDIR\bin"
  SetOverwrite ifnewer
  File %(DELIVERED_EXECUTABLES)
%(COMMON_FILES_TO_INSTALL)
%(ADDITIONAL_FILES_TO_INSTALL)

%(FILE_EXTENSION_DEFINITION_LINES)
%(DEFINITION_NOCONSOLE_APPLICATION_RUNASADMIN)
  WriteRegStr HKCR "%(MODULE_KEY).%(PRODUCT_FILENAME).1" "" "%(PRODUCT_FILENAME) File"
  WriteRegStr HKCR "%(MODULE_KEY).%(PRODUCT_FILENAME).1\DefaultIcon" "" ''$INSTDIR\bin\%(NOCONSOLE_APPLICATION),0''
  WriteRegStr HKCR "%(MODULE_KEY).%(PRODUCT_FILENAME).1\Shell\open" "" $(appOpen)
  WriteRegStr HKCR "%(MODULE_KEY).%(PRODUCT_FILENAME).1\Shell\open\command" "" ''"$INSTDIR\bin\%(NOCONSOLE_APPLICATION)" -- "%%1"''
SectionEnd

%(SEMI_IF_NO_DOC_EXISTS)Section "Online-Documentation for %(PRODUCT_NAME)" Section2
%(SEMI_IF_NO_DOC_EXISTS)  SectionIn 1
%(SEMI_IF_NO_DOC_EXISTS)  SetOutPath "$INSTDIR\doc"
%(SEMI_IF_NO_DOC_EXISTS)  SetOverwrite ifnewer
%(SEMI_IF_NO_DOC_EXISTS)  File /r /x CVS "${STX_ROOT}\%(MODULE)\%(APPLICATION)\doc\*"
%(SEMI_IF_NO_DOC_EXISTS)SectionEnd

;; Section "%(PRODUCT_NAME) Libraries and Demos" Section3
;;   SectionIn 1
;;   SetOutPath "$INSTDIR\lib"
;;   SetOverwrite ifnewer
;; ;   File /r /x CVS "${STX_ROOT}\%(MODULE)\%(APPLICATION)\examples\*"
;; SectionEnd
;; 
;; Section "%(PRODUCT_NAME) Reports and Printing" Section4
;;   SectionIn 1
;;   SetOutPath "$INSTDIR\reportGenerator"
;;   SetOverwrite ifnewer
;; ;  File /r /x CVS "..\reportGenerator\java" "..\reportGenerator\rules" "..\reportGenerator\*.xml" "..\reportGenerator\*.xslt" "..\reportGenerator\CloseApp.exe" "..\reportGenerator\expecco.jpg"
;; SectionEnd


%(STX_SOURCES_LINES)

%(APP_SOURCES_LINES)

%(ADDITIONAL_SECTIONS)

Section -AdditionalIcons
  SetOutPath "$INSTDIR\bin"
  WriteIniStr "$INSTDIR\${PRODUCT_FILENAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\${PRODUCT_FILENAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\%(APPLICATION).lnk" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)"
  CreateShortCut "$DESKTOP\%(APPLICATION).lnk" "$INSTDIR\bin\%(NOCONSOLE_APPLICATION)"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\Website.lnk" "$INSTDIR\${PRODUCT_FILENAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

LangString appOpen ${LANG_GERMAN}  "Mit %(PRODUCT_NAME) öffnen"
LangString appOpen ${LANG_ENGLISH} "Open with %(PRODUCT_NAME)"

LangString DESC_Section1 ${LANG_ENGLISH} "Program components of %(PRODUCT_NAME)"
LangString DESC_Section1 ${LANG_GERMAN}  "Alle Programmkomponenten von %(PRODUCT_NAME)"
%(SEMI_IF_NO_DOC_EXISTS)LangString DESC_Section2 ${LANG_ENGLISH} "Online-Documentation of %(PRODUCT_NAME)"
%(SEMI_IF_NO_DOC_EXISTS)LangString DESC_Section2 ${LANG_GERMAN}  "Online-Dokumentation zu %(PRODUCT_NAME)"
;; LangString DESC_Section3 ${LANG_ENGLISH} "Libraries and Demo Projects"
;; LangString DESC_Section3 ${LANG_GERMAN}  "Bibliotheken und Beispielprojekte"
;; LangString DESC_Section4 ${LANG_ENGLISH} "Logfile Printing and Report Generation"
;; LangString DESC_Section4 ${LANG_GERMAN}  "Drucken und Report-Generierung aus Log-Dateien"
%(SEMI_IF_NO_STX_SOURCES) LangString DESC_Section3 ${LANG_ENGLISH} "Sources of ST/X (Base-System)"
%(SEMI_IF_NO_STX_SOURCES) LangString DESC_Section3 ${LANG_GERMAN}  "Quellcode von ST/X (Basis-System)"
%(SEMI_IF_NO_APP_SOURCES) LangString DESC_Section4 ${LANG_ENGLISH} "Sources of %(PRODUCT_NAME)"
%(SEMI_IF_NO_APP_SOURCES) LangString DESC_Section4 ${LANG_GERMAN}  "Quellcode von %(PRODUCT_NAME)"
%(ADDITIONAL_SECTIONS_DESCRIPTIONS)

!!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !!insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
%(SEMI_IF_NO_DOC_EXISTS)  !!insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
%(SEMI_IF_NO_STX_SOURCES)  !!insertmacro MUI_DESCRIPTION_TEXT ${Section3} $(DESC_Section3)
%(SEMI_IF_NO_APP_SOURCES)  !!insertmacro MUI_DESCRIPTION_TEXT ${Section4} $(DESC_Section4)
%(ADDITIONAL_SECTIONS_INSERT_DESCRIPTIONS)
!!insertmacro MUI_FUNCTION_DESCRIPTION_END



Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "%(PRODUCT_NAME) wurde erfolgreich deinstalliert"
FunctionEnd

Function un.onInit
!!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Möchten Sie %(PRODUCT_NAME) und alle seine Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_FILENAME}.url"
  Delete "$INSTDIR\uninst.exe"
%(DIRECTORY_UNINSTALL_LINES)

  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\Website.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\%(APPLICATION).lnk"
  Delete "$DESKTOP\%(APPLICATION).lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_FILENAME}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKCR "%(MODULE_KEY).%(PRODUCT_FILENAME).1"
%(FILE_EXTENSION_UNDEFINITION_LINES)
%(UNDEFINITION_NOCONSOLE_APPLICATION_RUNASADMIN)

  SetAutoClose true
SectionEnd
'
    "
     bosch_dapasx_application packageName_dot_nsi
     bosch_dapasx_application generateFile:'dapasx.nsi'
    "

    "Modified: / 09-08-2006 / 15:10:57 / fm"
    "Created: / 14-09-2006 / 21:09:18 / cg"
    "Modified: / 15-05-2007 / 17:22:37 / cg"
    "Modified: / 12-10-2012 / 11:59:45 / sr"
!

packageName_dot_rc
    "the template code for the <appname>.rc file"

^ 
'//
// DO NOT EDIT 
// automagically generated from the projectDefinition: ',self name,'.
//
#define IDR_MAINFRAME   128
#define IDR_SPLASH      129

#if (__BORLANDC__)
LANGUAGE LANG_ENGLISH, SUBLANG_ENGLISH_US
#endif

#pragma code_page(1252)

%(ICONDEFINITION_LINE)

VS_VERSION_INFO VERSIONINFO
  FILEVERSION     %(FILE_VERSION_COMMASEPARATED)
  PRODUCTVERSION  %(PRODUCT_VERSION_COMMASEPARATED)
#if (__BORLANDC__)
  FILEFLAGSMASK   VS_FF_DEBUG | VS_FF_PRERELEASE
  FILEFLAGS       VS_FF_PRERELEASE | VS_FF_SPECIALBUILD
  FILEOS          VOS_NT_WINDOWS32
  FILETYPE        %(FILETYPE)
  FILESUBTYPE     VS_USER_DEFINED
#else
  FILEFLAGSMASK 0x3fL
#endif

BEGIN
  BLOCK "StringFileInfo"
  BEGIN
    BLOCK "040904E4"
    BEGIN
      VALUE "CompanyName", "%(COMPANY_NAME)\0"
      VALUE "FileDescription", "%(FILE_DESCRIPTION)\0"
      VALUE "FileVersion", "%(FILE_VERSION)\0"
      VALUE "InternalName", "%(INTERNAL_NAME)\0"
%(LEGAL_COPYRIGHT_LINE)
      VALUE "ProductName", "%(PRODUCT_NAME)\0"
      VALUE "ProductVersion", "%(PRODUCT_VERSION)\0"
      VALUE "ProductDate", "%(PRODUCT_DATE)\0"
    END
  END

  BLOCK "VarFileInfo"
  BEGIN                               //  Language   |    Translation
    VALUE "Translation", 0x409, 0x4E4 // U.S. English, Windows Multilingual
  END
END
'
    "
     stx_libbasic3 packageName_dot_rc
     stx_libbasic3 generate_packageName_dot_rc
    "

    "Modified: / 09-08-2006 / 15:10:57 / fm"
    "Created: / 30-08-2006 / 18:41:47 / cg"
!

preRequisiteLine_bc_dot_mak
    "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
     is required!!"
    ^
'%(FILE_NAME).dll: %(MODULE_DIRECTORY)\$(OBJDIR)\%(FILE_NAME).dll
        copy %(MODULE_DIRECTORY)\$(OBJDIR)\%(FILE_NAME).dll *.*

%(MODULE_DIRECTORY)\$(OBJDIR)\%(FILE_NAME).dll: $(FORCE)
        pushd %(MODULE_DIRECTORY) & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
'

    "Modified: / 06-06-2016 / 15:53:51 / cg"
!

preRequisiteLine_make_dot_proto

    "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
     is required!!"

    ^
'%(FILE_NAME).so: %(MODULE_DIRECTORY)/%(FILE_NAME).so
        ln -sf %(MODULE_DIRECTORY)/%(FILE_NAME).so .

%(MODULE_DIRECTORY)/%(FILE_NAME).so: %(MODULE_DIRECTORY)/makefile $(FORCE)
        @if [ -f "%(MODULE_DIRECTORY)/.NOSOURCE" ]; then \
            echo "skip make in %(MODULE_DIRECTORY) (no source)"; \
        else \
            cd %(MODULE_DIRECTORY) && $(MAKE) "CFLAGS_LOCAL=$(GLOBALDEFINES) "; \
        fi

%(MODULE_DIRECTORY)/makefile: %(MODULE_DIRECTORY)/Make.proto
        $(TOP)/rules/stmkmf --cd %(MODULE_DIRECTORY)
'

    "Modified: / 09-02-2007 / 16:22:47 / cg"
!

subProjectLine_bc_dot_mak
    "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
     is required!!"

^'%(LIBRARY_NAME).dll: %(PATH_TO_SUB_PROJECT)\$(OBJDIR)\%(LIBRARY_NAME).dll
        copy %(PATH_TO_SUB_PROJECT)\$(OBJDIR)\%(LIBRARY_NAME).dll *.*

%(PATH_TO_SUB_PROJECT)\$(OBJDIR)\%(LIBRARY_NAME).dll: $(FORCE)
        pushd %(PATH_TO_SUB_PROJECT) & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
'

    "Modified: / 03-03-2016 / 21:23:00 / cg"
!

subProjectLine_make_dot_proto
    "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
     is required!!"

^'%(LIBRARY_NAME).so: %(PATH_TO_SUB_PROJECT)/%(LIBRARY_NAME).so
        ln -sf %(PATH_TO_SUB_PROJECT)/%(LIBRARY_NAME).so .

%(PATH_TO_SUB_PROJECT)/%(LIBRARY_NAME).so: %(PATH_TO_SUB_PROJECT)/makefile  $(FORCE)
        @if [ -f "%(PATH_TO_SUB_PROJECT)/.NOSOURCE" ]; then \
            echo "skip make in %(PATH_TO_SUB_PROJECT) (no source)"; \
        else \
            cd %(PATH_TO_SUB_PROJECT) && $(MAKE) "CFLAGS_LOCAL=$(GLOBALDEFINES) "; \
        fi

%(PATH_TO_SUB_PROJECT)/makefile: %(PATH_TO_SUB_PROJECT)/Make.proto
        $(TOP)/rules/stmkmf --cd %(PATH_TO_SUB_PROJECT)
'
!

undefineExtenionLine_nsi_for:extension
    "the template code for a single extenions undefinition line in the <appname>.nsi file"

^ 
'  DeleteRegKey HKCR ".',extension,'"'

    "Created: / 15-10-2006 / 12:51:00 / cg"
!

undefineExtensionLine_nsi_for:extension
    "the template code for a single extenions undefinition line in the <appname>.nsi file"

^ 
'  DeleteRegKey HKCR ".',extension,'"'

    "Created: / 15-10-2006 / 12:51:00 / cg"
! !

!ApplicationDefinition class methodsFor:'queries'!

definitionClassOfApplicationBundle
    "Return the applicationDefinition of the applicationBundle or nil. 
     This is the applicationDefinition of the package which gets actually deployed.
     This information is currently used for automatic check of language translations.
     Here, ssume that I am the bundle.
     Redefine in other applications if that is not true."

    ^ self

    "
     exept_expecco definitionClassOfApplicationBundle    
     exept_expecco_application definitionClassOfApplicationBundle    
     exept_expecco_plugin_swt definitionClassOfApplicationBundle    
    "
!

isAbstract
    ^ self == ApplicationDefinition
!

projectType
    ^ self isGUIApplication
        ifTrue:[ GUIApplicationType  ]
        ifFalse:[ NonGUIApplicationType ]
!

shouldBeLoadedInitially:aProjectID
    "answer true, if a class should not be loaded initially,
     but explicitly later by the application"

    |initiallyLoaded|

    initiallyLoaded := self initiallyLoadedPreRequisites.
    initiallyLoaded isNil ifTrue:[
        ^ true.
    ].

    ^ initiallyLoaded includes:aProjectID
! !

!ApplicationDefinition class methodsFor:'sanity checks'!

validateDescription
    "perform some consistency checks (set of classes in project same as those listed in description);
     called before checking in build support files"

    super validateDescription.

    #(
        startupClassName
"/        startupSelector
    ) do:[:sel |
        (self theMetaclass includesSelector:sel) ifFalse:[
            Dialog 
                warn:('The %1-method is missing from the description %2!!' 
                        bindWith:sel allBold
                        with:self name allBold).
            AbortSignal raise.
        ].
        (Error catch:[ self perform:sel ]) ifTrue:[
            (Dialog 
                confirm:('The %1-method needs to be edited in the description %2!!\\Continue anyway?' 
                        bindWith:sel allBold
                        with:self name allBold) withCRs) ifFalse:[
                AbortSignal raise.
            ].
        ].
    ].

    "Modified: / 19-09-2006 / 20:17:38 / cg"
    "Modified (comment): / 31-10-2011 / 10:58:03 / cg"
! !

!ApplicationDefinition class methodsFor:'testing'!

isApplicationDefinition
    ^ self isAbstract not

    "Created: / 23-08-2006 / 15:17:38 / cg"
! !

!ApplicationDefinition class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id: ApplicationDefinition.st 10645 2011-06-09 15:28:45Z vranyj1  $'
! !

