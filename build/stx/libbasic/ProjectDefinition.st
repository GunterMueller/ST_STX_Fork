"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
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

Object subclass:#ProjectDefinition
	instanceVariableNames:''
	classVariableNames:'AbbrevDictionary AccessLock FolderForSubApplicationsType
		GUIApplicationType LibraryType NonGUIApplicationType
		PackagesBeingLoaded Verbose'
	poolDictionaries:''
	category:'System-Support-Projects'
!

ProjectDefinition class instanceVariableNames:'safeForOverwrittenMethods extensionOverwriteInfo projectIsLoaded'

"
 No other class instance variables are inherited by this class.
"
!

Object subclass:#AbbrevEntry
	instanceVariableNames:'className fileName category numClassInstVars'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectDefinition
!

Object subclass:#ApplicationDocumentTypeDescription
	instanceVariableNames:'extension iconFileOSX mimeType typeName iconFileWindows
		iconFileLinux roleOSX'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectDefinition
!

!ProjectDefinition class methodsFor:'documentation'!

buildingMakefiles
"
    You can define additional rules and flag settings for use in the makeFile generation:

    redefinable build-file attributes:
        stcOptimizationOptions  -> STCLOCALOPT
        stcWarningOptions       -> STCLOCALOPT
        localIncludes_unix      -> LOCALINCLUDES (Make.proto)
        localIncludes_win32     -> LOCALINCLUDES (bc.mak)

    for applications:
        startupClassName
        startupSelector

    for libraries:

"
!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
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
    As ST/X is (still) very tightly bound with stc, we keep the package and project information
    in a class-object (instead of some project object) and all queries about package contents and 
    attributes are implemented as class methods. 
    This has the advantage, that it can be compiled and included in a compiled class library just like any other class.
    Every package includes a subclass of me (an instance of my meta), which provides useful
    information about the versioning and packaging. 
    Me myself, I know how to generate dependency information and can generate makefiles and other build-support 
    files for compilation (see the browser's 'Checkin Build Support File' menu item. For more details, see
    section 'Build Support Files' below.

    When a package is loaded from a binary shared class lib (i.e. a compiled class library is loaded
    via 'Smalltalk loadPackage:'), the loading is done in multiple phases:
        1) the shared object is loaded, but not installed (registered) in Smalltalk
        2) the ProjectDefinition class is registered and initialized.
        3) the ProjectDefinition class is asked to load its prerequisites. This may lead to other packages
           to be loaded - either as binary class libraries or from source, whichever is found.
        4) the remaining classes and extensions are registered

    ## Some special notes about extension methods:
      if a package is loaded (Smalltalk loadPackage:'foo:bar/baz'), any already loaded package of which
      methods are overwritten by an extension method of the loaded package, the other package is asked to safe those
      methods in its safe(ForOverwrittenMethods). 
      Thus, if the other package or any of its classes is asked
      to file itself out, it can do so using the safe (otherwise, you'd not be able to check the original class into
      its repository while it has an overriding extension loaded).

      Also, the information about which other package was in charge when a method is overwritten is recorded in
      extensionOverwriteInfo. 
      This is used to correctly reinstall an overwritten method, whenever a package is unloaded.

    ## Custom project definition methods

    Some packages may want to compile custom methods when project definition is updated
    based on project contents - similarly to how #classNamesAndAttributes or #extensionMethodNames
    are updated.

    To support this, packages mey add extension methods annotated by <method:category:overwrite:>
    or <method:category:>. The meaning og arguments is the following:

    * method: <Symbol>     - the selector of method which this method generates.
    * category: <Symbol>   - the category in which to place generated method
    * overwrite: <Boolean> - specifies whether the method should obe overwritten
                             or not. Use `false` only for methods which should be
                             generated once and then left for user to manually tweak.
                             optional, defaults to `true` (i.e., do owerwrite methods)

    The annotated method is invoked to get the code od the method to generate, i.e., it must
    return the source code as String. If it returns nil - no method is generated.

    ## Build Support Files

    To support pre-compilation of a package, ProjectDefinition can generate a set of makefiles and other
    support files to allow that. To see the set of files that should be generated, see #fileNamesToGenerate.
    These files are usually generated and saved to the repository upon a commit - the source code management
    does (should) care for this.

    Packages may add more files to this list by defining an (extension) mehtod in project definition class
    and by annotating the method by <file:overwrite:> annotation:

        * the first parameter is the file name to generate as String, relative to the package root. As directory
          separator, use slash (as on UNIX), it will be automagically converted to platform's separator.
        * The second paramterer (true or false) tells the SCM whether the file should be generated (and thus
          overwritten) upon each commit (when true) or only the first time (when false). Important: see the 
          remark below.
        * The method itself should return file's contents a string. If it returns nil, then the file is *not*
          generated at all.

    For examples, see #generate_java_build_auto_dot_xml and #generate_java_build_dot_xml defined by STX:LIBJAVA.

    REMARK: CAUTION:
    The overwrite: boolean is currently *not* supported by old SCM managers, more specifically
    CVSSourceCodeManager does not support it. CVSSourceCodeManager will always overwrite the file!!
    It *is* supported by all SCMs based on new stx:libscm. More specifically, *it is supported* by
    Mercurial.

    ## Adding additional rules to generated makefiles

    There are two ways to add additional rules to generated makefiles (Make.proto and bc.mak):
      1) overriding #additionalRules_make_dot_proto and/or #additionalRules_bc_dot_mak
      2) adding a method annotated by <file:target:> or <file:target:extends:> 

    ### Overriding #additionalRules* methods

    You may override #additionalRules_make_dot_proto and/or #additionalRules_bc_dot_mak and return
    string containing the code of the rules. This string is inserted to the resulting makefile
    as-is. This is the traditional way of doing this.

    If you any of the targets defined there to be called as part of standard build, you may
    also want to list these targets in #additionalTargets_make_dot_proto and/or
    #additionalTargets_bc_dot_mak

    ### Adding annotatated method

    Alternatively, you may add one method per rule and annotate it by
    <file:target:> or <file:target:extends:> annotation. For example,
    to call 'ant' whenever a package is built, add a method like:

    additionalRuleAnt_make_dot_proto
        <file: 'Make.proto' target: 'ant' extends: 'pre_objs' >  

        ^ '
        java:
                ant -f java/build.xml
        '

    The meaning annotation parameters is the following:

        * file: <String> - name of the file in which to include
          the rule. Currently only two values are valid:
          'Make.proto' and 'bc.mak'.
        * target: <String> - name of the target'
        * extends: <String> - optional name of the target that this additional
          rule extends. This means that the extending target (specified by target:
          annotation parameter) is called as part of building of  the extended target
          (i.e., the target specified by extends: annotation parameter). Not all targets
          are extendable, see below.

    Method annotated by these annotations should return - when executed - a string
    with exactly one rule. The rule name SHOULD match with the name in target: annotation
    parameter, otherwise the extends: parameter will not work correctly.
    If the methor returns nil, the rule is not included in resulting makefile.

    The advantage of this approach is that it allows for additional, non-basic packages to hook in
    and add their own targets if they want to. The disadvantage is that if package makefiles
    are regenerated without this extending package loaded, targets are lost. To avid this,
    you may want to add this non-basic package to prerequsites.

    Currently, this mechanism is used by STX:LIBJAVA to call ant to compile package's java classes.

    #### Extendable targets

    Make.proto:
        all
        clean
        ...more to be added...

    bc.mak
        ALL
        clean
        ...more to be added...

"
! !

!ProjectDefinition class methodsFor:'instance creation'!

definitionClassForPackage:aPackageID
    "given a packageID (such as 'stx:libfoo/bar'), lookup the corresponding peoject definition class.
     Return it, or nil if not present"

    ^ self definitionClassForPackage:aPackageID createIfAbsent:false

    "
     ProjectDefinition definitionClassForPackage:'stx:libbasic'
     ProjectDefinition definitionClassForPackage:'stx:libfoobarBaz'
    "

    "Modified: / 17-08-2006 / 14:33:35 / cg"
!

definitionClassForPackage:aPackageID createIfAbsent:doCreateIfAbsent
    ^ self definitionClassForPackage:aPackageID createIfAbsent:doCreateIfAbsent projectType:nil

    "Modified: / 23-08-2006 / 14:29:15 / cg"
!

definitionClassForPackage: aPackageID createIfAbsent: doCreateIfAbsent projectType:typeOrNil
    |packageDefinitionClassName class|

    packageDefinitionClassName := self projectDefinitionClassNameForDefinitionOf:aPackageID.
    class := Smalltalk classNamed:packageDefinitionClassName.
    class isNil ifTrue:[
        doCreateIfAbsent ifTrue:[
            typeOrNil = GUIApplicationType ifTrue:[
                class := ApplicationDefinition newForPackage:aPackageID.
            ] ifFalse:[
                typeOrNil = NonGUIApplicationType ifTrue:[
                    class := ApplicationDefinition newForPackage:aPackageID.
                ] ifFalse:[
                    typeOrNil = FolderForSubApplicationsType ifTrue:[
                        class := FolderForProjectsDefinition newForPackage:aPackageID.
                    ] ifFalse:[
                        class := LibraryDefinition newForPackage:aPackageID.
                    ]
                ]
            ].
            "setup before prerequisites are defined"
            class setupForType:typeOrNil.
            "/ look what is there and include it; is this ok ?
            class compileDescriptionMethods
        ].
    ] ifFalse:[
        typeOrNil notNil ifTrue:[
            doCreateIfAbsent ifTrue:[
                class projectType == typeOrNil ifFalse: [
                    class setupForType:typeOrNil.
                ]
            ].
        ].
    ].
    ^ class

    "Created: / 23-08-2006 / 14:29:21 / cg"
    "Modified: / 23-08-2006 / 15:35:26 / cg"
!

definitionClassForPackage:newProjectID projectType:typeOrNil createIfAbsent:createIfAbsent
    ^ (self definitionClassForType:typeOrNil)
            definitionClassForPackage:newProjectID
            createIfAbsent:createIfAbsent
            projectType:typeOrNil

    "Created: / 23-08-2006 / 14:28:53 / cg"
!

definitionClassForType: type
    "answer the class that describes a give project type"

    (type = LibraryType) ifTrue:[ ^ LibraryDefinition ].
    (type = GUIApplicationType) ifTrue:[ ^ ApplicationDefinition ].
    (type = NonGUIApplicationType) ifTrue:[ ^ ApplicationDefinition ].
    (type = FolderForSubApplicationsType) ifTrue:[ ^ FolderForProjectsDefinition ].
    (type = 'Application') ifTrue:[ ^ ApplicationDefinition ].     "/ temporary - for backward compat.
    self error:'unknown project type'.

    "Created: / 17-08-2006 / 14:46:28 / cg"
    "Modified: / 23-08-2006 / 13:49:27 / cg"
!

newForPackage:packageID
    ^ self
        newNamed:(self projectDefinitionClassNameForDefinitionOf:packageID)
        package:packageID.

    "Created: / 11-08-2006 / 14:27:19 / cg"
!

newNamed:newName package:packageID
    |newClass|

    "/ for now, we are strict.
    self assert:(self projectDefinitionClassNameForDefinitionOf:packageID) = newName.
    self assert:(self ~~ ProjectDefinition).  "ProjectDefinition is abstract"

    newClass := self
                    subclass:(newName asSymbol)
                    instanceVariableNames:''
                    classVariableNames:''
                    poolDictionaries:''
                    category:(self defaultCategory).

    newClass package:packageID asSymbol.
    ^ newClass

    "Created: / 09-08-2006 / 17:57:37 / fm"
    "Modified: / 09-08-2006 / 19:27:53 / fm"
    "Modified: / 17-08-2006 / 17:24:23 / cg"
! !

!ProjectDefinition class methodsFor:'accessing'!

directory
    "for packageId compatibility"

    ^ self moduleDirectory

    "
     bosch_dapasx_datenbasis_Definition moduleDirectory
     bosch_dapasx_parameter_system_Definition moduleDirectory
     stx_libbasic3 moduleDirectory
     cg_croquet moduleDirectory
     cg_croquet package asPackageId module
     cg_croquet moduleDirectory
     stx_goodies_xml_vw moduleDirectory
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified: / 18-08-2006 / 12:18:33 / cg"
!

extensionsRevisionInfoForManager:managerOrNil
    "return the revisionInfo object for my extensions for a particular source code manager.
     Return nil, if there is either no manager, or I have no extensions"

    |mgr versionMethod revString|

    (mgr := managerOrNil) isNil ifTrue:[
        mgr := SourceCodeManagerUtilities sourceCodeManagerFor:self.
        mgr isNil ifTrue:[
            ^ nil
        ].
    ].

    versionMethod := mgr nameOfVersionMethodForExtensions.
    (self class implements:versionMethod) ifFalse:[^ nil].

    revString := self perform:(mgr nameOfVersionMethodForExtensions) ifNotUnderstood:nil.
    revString isNil ifTrue:[
        ^ nil.
    ].
    ^ mgr revisionInfoFromString:revString.

    "
     (stx_libcomp extensionsRevisionInfoForManager:nil) revision
     (stx_libbasic extensionsRevisionInfoForManager:nil)
    "

    "Created: / 25-11-2011 / 14:34:01 / cg"
!

fullPackageName
    "all components with underlines"

    ^ self fullPackageNameFor: self package

    "
     stx_libwidg2 packageName
     stx_libwidg2 fullPackageName
     stx_goodies_refactoryBrowser_browser packageName
     stx_goodies_refactoryBrowser_browser fullPackageName
    "
!

fullPackageNameFor: aProjectID
    ^ (aProjectID copyReplaceAny:':/' with:$_)

    "
     stx_goodies_refactoryBrowser_lint fullPackageNameFor:#stx_goodies_refactoryBrowser_lint  
    "
!

initialClassNameForDefinitionOf:aPackageId
    <resource: #obsolete>

    "now obsolete - left here for backward compatibility
     given a package-ID, return an appropriate class name for this package"

    ^ self projectDefinitionClassNameForDefinitionOf:aPackageId

    "
     ProjectDefinition projectDefinitionClassNameForDefinitionOf:'bosch:dapasx/interactiver_editor'
     ProjectDefinition projectDefinitionClassNameForDefinitionOf:'stx:libbasic'
     ProjectDefinition projectDefinitionClassNameForDefinitionOf:'stx:goodies/xml'
     ProjectDefinition projectDefinitionClassNameForDefinitionOf:'stx/goodies/xml'
     ProjectDefinition projectDefinitionClassNameForDefinitionOf:'stx_goodies_xml'
    "
!

libraryName
    ^ self package asPackageId libraryName

    "
     bosch_dapasx_datenbasis libraryName
     stx_libbasic3 libraryName
    "

    "Modified: / 09-08-2006 / 18:20:29 / fm"
    "Modified: / 18-08-2006 / 12:36:45 / cg"
!

libraryNameFor:aProjectID
    ^ aProjectID asPackageId libraryName

    "
     bosch_dapasx_datenbasis libraryName
     stx_libbasic3 libraryNameFor:'stx:libbasic'
     stx_libbasic3 libraryNameFor:'bosch:dapasx/datenbasis'
    "

    "Modified: / 09-08-2006 / 18:20:29 / fm"
    "Modified: / 18-08-2006 / 12:37:02 / cg"
!

loadDirectory
    "if I was loaded from a directory (as opposed to loaded via a dll or from a source code manager),
     return that directory. Otherwise return nil."

    ^ self getAttribute:#projectDirectory
!

loadDirectory:aDirectory
    "remember the directory from which I was loaded from"

    self setAttribute:#projectDirectory to:aDirectory
!

module
    ^ self moduleOfClass:self

    "
       bosch_dapasx_datenbasis_Definition module
       DapasX_Datenbasis module
       stx_libbasic3 module
       stx_libbasic3 directory
    "

    "Created: / 08-08-2006 / 20:24:53 / fm"
    "Modified: / 09-08-2006 / 16:16:37 / fm"
    "Modified: / 17-08-2006 / 20:50:46 / cg"
!

moduleDirectory
    ^ (PackageId from:self package) directory

    "
     bosch_dapasx_datenbasis_Definition moduleDirectory
     bosch_dapasx_parameter_system_Definition moduleDirectory
     stx_libbasic3 moduleDirectory
     cg_croquet moduleDirectory
     cg_croquet package asPackageId module
     cg_croquet moduleDirectory
     stx_goodies_xml_vw moduleDirectory
     cg_demos_demo1 moduleDirectory
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified (comment): / 05-09-2012 / 10:07:18 / cg"
!

moduleDirectoryFor:aProjectID
    ^ (aProjectID subStrings:$:) last

    "
        bosch_dapasx_datenbasis_Definition moduleDirectory
        bosch_dapasx_parameter_system_Definition moduleDirectory
    "

    "Created: / 08-08-2006 / 20:25:39 / fm"
    "Modified: / 17-08-2006 / 14:13:41 / cg"
!

moduleDirectory_win32
    ^ (PackageId from:self package) directory copyReplaceAll:$/ with:$\

    "
     bosch_dapasx_datenbasis moduleDirectory_win32
     bosch_dapasx_parameter_system moduleDirectory_win32
     stx_libbasic3 moduleDirectory_win32
    "

    "Created: / 14-09-2006 / 20:19:17 / cg"
!

moduleDirectory_win32For: projectID

    ^(self moduleDirectoryFor:projectID) copyReplaceAll:$/ with:$\

    "
     self moduleDirectory_win32For: #'bosch:dapasx/pav_vergleich'
     self moduleDirectory_win32For: #'stx:goodies/xml/stx'
     self moduleDirectory_win32For: #'stx:libbasic2'
    "

    "Modified: / 16-07-2013 / 19:47:24 / cg"
!

moduleFor:aProjectID
    ^ (aProjectID subStrings:$:) first

    "
       DapasXProject module
       DapasX_Datenbasis module
    "

    "Created: / 09-08-2006 / 16:16:16 / fm"
    "Modified: / 17-08-2006 / 14:13:46 / cg"
!

moduleOfClass:aClass
    ^ self moduleFor:aClass package

    "
       DapasXProject module
       DapasX_Datenbasis module
    "

    "Created: / 09-08-2006 / 16:16:16 / fm"
    "Modified: / 17-08-2006 / 14:13:51 / cg"
!

monticelloPackageName
    "hook for packages which have been loaded from monticello"

    ^ nil
!

msdosPathToPackage:toPackageID from:fromPackageID
    "Returns the path to the package defined by aPackageID relative to my path"

    |parts1 parts2 common up down|

    parts1 := fromPackageID asCollectionOfSubstringsSeparatedByAny:':/'.
    parts2 := toPackageID asCollectionOfSubstringsSeparatedByAny:':/'.
    common := parts1 commonPrefixWith:parts2.
    up := ((1 to:parts1 size - common size) collect:[:p | '..']) asStringWith:'\'.
    down := (parts2 copyFrom:common size+1) asStringWith:'\'.
    up isEmpty ifTrue:[
       down isEmpty ifTrue:[^ '.'].
        ^ down.
    ].
    down isEmpty ifTrue:[
        ^ up.
    ].
    ^ up, '\', down

    "
     self msdosPathToPackage:'bosch:dapasx/kernel' from:'bosch:dapasx/application'
     self msdosPathToPackage:'stx:libbasic' from:'bosch:dapasx/application'
     self msdosPathToPackage:'bosch:dapasx/application' from:'stx:libbasic'
     self msdosPathToPackage:'exept:expecco' from:'exept:expecco/application'
     self msdosPathToPackage:'exept:expecco/application' from:'exept:expecco'
    "

    "Created: / 17-08-2006 / 14:26:39 / cg"
    "Modified: / 14-09-2006 / 22:04:56 / cg"
!

packageDirectory
    "if I was loaded from a directory (as opposed to loaded via a dll or from a source code manager),
     return that directory.
     Otherwise ask Smalltalk for my package directory a long the package path."

    |loadDirectory|

    (loadDirectory := self loadDirectory) notNil ifTrue:[ ^ loadDirectory ].
    ^ Smalltalk getPackageDirectoryForPackage: self package

    "Created: / 15-06-2009 / 12:01:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-06-2016 / 07:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageName
    "the last component"

    ^ self packageNameFor: self package

    "
     stx_libwidg2 packageName
     stx_goodies_refactoryBrowser_browser packageName
     bosch_dapasx_hw_schnittstellen packageName
     bosch_dapasx_datenbasis packageName
     bosch_dapasx_parameter_system packageName
    "

    "Created: / 08-08-2006 / 20:24:53 / fm"
    "Modified: / 09-08-2006 / 16:16:37 / fm"
!

packageNameFor: aProjectID
    ^ (aProjectID asCollectionOfSubstringsSeparatedByAny:':/') last.

    "
     bosch_dapasx_hw_schnittstellen packageName
     bosch_dapasx_datenbasis packageName
     bosch_dapasx_parameter_system packageName
     cg_croquet packageName
     stx_goodies_xml_vw packageName
     stx_goodies_xml_vw packageDirectory
    "

    "Created: / 08-08-2006 / 20:24:53 / fm"
    "Modified: / 09-08-2006 / 16:16:37 / fm"
    "Modified: / 11-08-2006 / 14:02:32 / cg"
!

parentProject
    "return the packageID of the parent project. 
     That is the projectID of the package above in the folder hierarchy"

    ^ (self parentProjectFor: self package)

    "
     bosch_dapasx_hw_schnittstellen_Definition parentProject
     DapasX_Datenbasis parentProject

     stx_libbasic parentProject      
     stx_goodies_refactoryBrowser_lint parentProject      
    "
!

parentProjectFor: aProjectID
    "given a packageID symbol or string, return the packageID of the
     parent project. 
     That is the projectID of the package above in the folder hierarchy"

    |path|

    path := aProjectID splitByAny:':/'.
    path size == 1 ifTrue:[^ nil].
    path size == 2 ifTrue:[^ path first].
    ^ path first , ':' , ((path copyFrom:2 to:path size - 1) asStringWith:'/')

    "
     bosch_dapasx_hw_schnittstellen parentProject

     self parentProjectFor:'bosch:dapasx'    
     self parentProjectFor:'bosch:dapasx/hw_schnittstellen'    
     self parentProjectFor:'stx:goodies/refactoryBrowser/lint'                   
     self parentProjectFor:'stx:goodies/svg'                   
     self parentProjectFor:'stx:libbasic'                      
     self parentProjectFor:'exept:expecco/application'         

     self parentProjectFor:'stx'                   
     self parentProjectFor:'exept'                   
    "
!

pathSeparator:platformName
    ^ platformName == #unix ifTrue:['/'] ifFalse:['\'].
!

pathTo:aBaseFilename inPackage:aPackageID architecture:arch
    "Returns the path to stx counting the number of $/ and $: in the package name and adding for each one '../' to get the ST/X top directory"

    |p separator|

    separator := self pathSeparator:arch.
    p := self pathToPackage:aPackageID withSeparator:separator.
    aBaseFilename isNil ifTrue:[^ p].
    ^ p , separator, aBaseFilename
!

pathToPackage:toPackageID from:fromPackageID withSeparator:pathSeparator
    "Returns the path to the package defined by aPackageID relative to my path"

    |parts1 parts2 common up down rel oneUp|

    oneUp := '..', pathSeparator.

    parts1 := fromPackageID asCollectionOfSubstringsSeparatedByAny:':/'.
    parts2 := toPackageID asCollectionOfSubstringsSeparatedByAny:':/'.
    common := parts1 commonPrefixWith:parts2.
    common notEmpty ifTrue:[
        up := ((1 to:parts1 size - common size) collect:[:p | oneUp]) asStringWith:''.
        down := (parts2 copyFrom:common size+1) asStringWith:pathSeparator.
        (up isEmpty and:[down isEmpty]) ifTrue:[^ '.'].
        ^ up , down
    ].

    rel := (self topRelativePathToPackage:toPackageID withSeparator:pathSeparator).
    (rel startsWith:('stx', pathSeparator)) ifTrue:[
        ^ '$(TOP)', (rel copyFrom:'stx/' size) "/ notice: the separator remains
    ].

    ^ '$(TOP)', pathSeparator, oneUp, rel.

    "
     self pathToPackage:'bosch:dapasx/kernel' from:'bosch:dapasx/application' withSeparator:'\'
     self pathToPackage:'stx:libbasic' from:'bosch:dapasx/application' withSeparator:'\'
     self pathToPackage:'bosch:dapasx/application' from:'stx:libbasic' withSeparator:'\'
    "

    "Created: / 14-09-2006 / 15:21:10 / cg"
!

pathToPackage:aPackageID withSeparator:pathSeparator
    "Returns the path to stx counting the number of $/ and $: in the package name and adding for each one '../' to get the ST/X top directory"

    |rel|

    aPackageID asPackageId module = self package asPackageId module ifTrue:[
        ^ self pathToPackage:aPackageID from:self package withSeparator:pathSeparator.
    ].
    rel := self topRelativePathToPackage:aPackageID withSeparator:pathSeparator.
    (rel startsWith:('stx', pathSeparator)) ifTrue:[
        ^ '$(TOP)', (rel copyFrom:'stx/' size).   "keep the separator"
    ] ifFalse:[
        ^ '$(TOP)', pathSeparator, '..', pathSeparator, rel
    ]

    "
     exept_expecco_application pathToPackage:'exept:expecco/application' withSeparator:'\'
     exept_expecco_application pathToPackage:'exept:expecco/report' withSeparator:'\'
     stx_libbasic pathToPackage:'exept:expecco/application' withSeparator:'\'
    "

    "Modified: / 16-08-2006 / 18:55:41 / User"
    "Created: / 14-09-2006 / 13:21:23 / cg"
    "Modified: / 14-09-2006 / 15:23:59 / cg"
!

pathToTopFor:aProjectID withSeparator:aPathSeparator
    "Returns the path to stx counting the number of $/ and $: in the package name and adding for each one '../' to get the ST/X top directory"

    |parts oneUp|

    oneUp := '..', aPathSeparator.

    parts := aProjectID asCollectionOfSubstringsSeparatedByAny:':/'.

    parts first = 'stx' ifTrue:[
        parts size == 1 ifTrue:[^ ''].
        ^ (((2 to:parts size-1) collect:[:p | oneUp]) asStringWith:'') , '..'
    ].

    ^ ((parts collect:[:p | oneUp]) asStringWith:'') , 'stx'

    "
     self pathToTopFor: #'exept' with:'/'
     self pathToTopFor: #'exept:expecco' with:'/'
     self pathToTopFor: #'exept:expecco/application' with:'/'
     self pathToTopFor: #'stx' with:'/'
     self pathToTopFor: #'stx:libview' with:'/'
     self pathToTopFor: #'stx:goodies/foo' with:'/'
    "

    "Created: / 14-09-2006 / 14:59:53 / cg"
!

pathToTopWithSeparator:aPathSeparator
    "Returns the path to stx counting the number of $/ and $: in the package name and adding for each one '../' to get the ST/X top directory"

    ^ self pathToTopFor:self package withSeparator:aPathSeparator

    "
     exept_expecco_application pathToTopWithSeparator:'\'
     stx_libbasic pathToTopWithSeparator:'\'
     stx_goodies_xml pathToTopWithSeparator:'\'
     stx_libhtml pathToTopWithSeparator:'\'
     stx_goodies_refactoryBrowser_changes pathToTopWithSeparator:'\'
    "

    "Created: / 09-08-2006 / 15:45:54 / fm"
    "Modified: / 14-09-2006 / 15:01:47 / cg"
!

projectDefinitionClassNameForDefinitionOf:aPackageId
    "given a package-ID, return an appropriate class name for this package"

    |s|

    s := aPackageId asString copy replaceAny:' :/-' with:$_.
    (s endsWith:$_) ifTrue:[
        s := s copyButLast:1
    ].
    ^ s

    "
     ProjectDefinition initialClassNameForDefinitionOf:'bosch:dapasx/interactiver_editor'
     ProjectDefinition initialClassNameForDefinitionOf:'stx:libbasic'
     ProjectDefinition initialClassNameForDefinitionOf:'stx:goodies/xml'
     ProjectDefinition initialClassNameForDefinitionOf:'stx/goodies/xml'
     ProjectDefinition initialClassNameForDefinitionOf:'stx_goodies_xml'
    "
!

projectIsLoaded
    "answer true, if this project is completely loaded into the image"

    projectIsLoaded isNil ifTrue:[
        projectIsLoaded := false.
    ].
    ^ projectIsLoaded

    "
      stx_libbasic projectIsLoaded
      (ProjectDefinition definitionClassForPackage:#'stx:libbasic') projectIsLoaded
    "
!

projectIsLoaded:aBoolean
    projectIsLoaded := aBoolean.
    aBoolean ifTrue:[
        "register myself as dependent - I want to get notified on method changes"
        self class addDependent:self.
        self postLoadAction.
        self executeHooks: #postLoad.
    ].
!

topRelativePathTo:aBaseFilename inPackage:aPackageID architecture:arch
    "Returns the path to stx counting the number of $/ and $: in the package name
     and adding for each one '../' to get the ST/X top directory"

    |p separator|

    separator := self pathSeparator:arch.
    p := self topRelativePathToPackage:aPackageID withSeparator:separator.
    aBaseFilename isNil ifTrue:[^ p].
    ^ p , separator, aBaseFilename
!

topRelativePathToPackage:aPackageID withSeparator:aDirectorySeparator
    "Returns the path to the package as specified by aPackageID relative to the top directory.
     Basically this simply replaces colons and slashes by the OS's path separator."

    ^ aPackageID asString copyReplaceAny:':/' with:aDirectorySeparator first

    "
     self topRelativePathToPackage:'stx:goodies/xml' withSeparator:'\'
     self topRelativePathToPackage:'bosch:dapasx/kernel' withSeparator:'\'
    "

    "Created: / 14-09-2006 / 13:20:40 / cg"
! !

!ProjectDefinition class methodsFor:'accessing - coverage'!

excludedFromCoverage
    "List of classes and/or methods excluded from coverage report.
     Entries maybe ClassName or #(ClassName selector)

     Please note that certain classes and methods are excluded
     in #Builder::CoverageReport>>excludedFromCoverage:.
    "
    ^ #()

    "Created: / 28-06-2013 / 02:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-06-2013 / 11:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

excludedFromCoverage: aMethod
    "Return true if given method should be excluded from coverage
     info. This method may be redefined in subclasses to automagically omit methods
     matching some criteria.

     Please note that certain classes and methods are excluded
     in Builder::CoverageReport>>excludedFromCoverage:.
    "

    |excluded mclass mselector|

    excluded := self excludedFromCoverage.
    excluded notEmptyOrNil ifTrue:[
        mclass := aMethod mclass.
        mselector := aMethod selector.
        excluded do:[:eachSpecLine|
            eachSpecLine isArray ifTrue:[
                (eachSpecLine first = mclass name and:[eachSpecLine second == mselector]) ifTrue:[ ^ true ].
            ].
            eachSpecLine = mclass name ifTrue:[ ^ true ].                
        ].
    ].

    ^ false

    "Created: / 28-06-2013 / 02:14:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-06-2013 / 11:25:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !




!ProjectDefinition class methodsFor:'accessing - packaging'!

classNames:aCollectionOfClassNames
    "set the set of classes"

    self classNamesAndAttributes:aCollectionOfClassNames usingCompiler:nil
!

classNamesAndAttributes:newSpec usingCompiler:compilerOrNil
    "set the set of classes. and attributes
     Because this requires compilation of my classList-method, a compiler can be passed in,
     which has to do the job.
     (this is used by the systembrowser to pass in a CodeGeneratorTool with undo support)"

    |oldSpec newCode|

    oldSpec := self classNamesAndAttributes.
    newSpec = oldSpec ifTrue: [^ self].

    newCode := self classNamesAndAttributes_codeFor:newSpec.

    self compile:newCode categorized:'description - contents' using:compilerOrNil
!

excludeClasses:toExclude usingCompiler:compilerOrNil
    "exclude (remove from classList) a number of classes.
     Because this requires compilation of my classList-method, a compiler can be passed in,
     which has to do the job.
     (this is used by the systembrowser to pass in a CodeGeneratorTool with undo support)"

    |newSpec|

    newSpec := self classNamesAndAttributes copy.

    toExclude do:[:eachClassToExclude |
        |className|
        className := eachClassToExclude theNonMetaclass name.
        (self allClassNames includes:className) ifTrue:[
            |idx|

            idx := newSpec findFirst:[:entry | entry = className or:[entry first = className]].
            idx ~~ 0 ifTrue:[
                newSpec := newSpec copyWithoutIndex:idx.
            ].
        ].
    ].
    self classNamesAndAttributes:newSpec usingCompiler:compilerOrNil

    "Created: / 30-08-2007 / 18:28:28 / cg"
!

excludeMethodFor:selector inClassNamed:className usingCompiler:compilerOrNil
    "exclude (remove from extensionList) a method by name.
     Because this requires compilation of my extensionMethodNames-method, a compiler can be passed in,
     which has to do the job.
     This is used by the systembrowser to pass in a CodeGeneratorTool with undo support.
     If nil is passed in, the recurlar compiler is used (no undo support)"

    |oldSpec newSpec newCode idx|

    oldSpec := self extensionMethodNames.

    idx := (1 to:oldSpec size-1 by:2)
                detect:[:i |
                    ((oldSpec at:i) = className)
                    and:[ (oldSpec at:i+1) = selector ]]
                ifNone:[ ^ self ].

    "/ attention: there are two spec-elements per method
    newSpec := oldSpec copyWithoutIndex:idx toIndex:idx+1.

    newCode := self extensionMethodNames_code_For:newSpec.
    self compile:newCode categorized:'description - contents' using:compilerOrNil
!

excludeMethods:toRemove usingCompiler:compilerOrNil
    "exclude (remove from extensionList) a number of methods.
     Because this requires compilation of my extensionMethodNames-method, a compiler can be passed in,
     which has to do the job.
     This is used by the systembrowser to pass in a CodeGeneratorTool with undo support.
     If nil is passed in, the recurlar compiler is used (no undo support)"

    |oldSpec newSpec newCode extensionMethods|

    oldSpec := self extensionMethodNames.
    newSpec := oldSpec copy.
    extensionMethods := self extensionMethods.

    toRemove do:[:eachMethodToRemove |
        |className selector idx|

        (extensionMethods includes:eachMethodToRemove) ifTrue:[
            className := eachMethodToRemove mclass name.
            selector := eachMethodToRemove selector.
            idx := (1 to:newSpec size-1 by:2)
                        detect:[:i |
                            ((newSpec at:i) = className)
                            and:[ (newSpec at:i+1) = selector ]]
                        ifNone:nil.
            idx notNil ifTrue:[
                "/ attention: there are two spec-elements per method
                newSpec := newSpec removeFromIndex:idx toIndex:idx+1
            ]
        ].
    ].

    newCode := self extensionMethodNames_code_For:newSpec.
    self compile:newCode categorized:'description - contents' using:compilerOrNil
!

includeClasses:toInclude usingCompiler:compilerOrNil
    "include (add to classList) a number of classes.
     Because this requires compilation of my classList-method, a compiler can be passed in,
     which has to do the job.
     This is used by the systembrowser to pass in a CodeGeneratorTool with undo support.
     If nil is passed in, the recurlar compiler is used (no undo support)"

    |oldSpec newSpec|

    oldSpec := self classNamesAndAttributes.
    newSpec := oldSpec copy.

    toInclude do:[:eachClassToInclude |
        |className|

        className := eachClassToInclude theNonMetaclass name.
        (self compiled_classNames includes:className) ifFalse:[
            | idx entry|

            idx := oldSpec findFirst:[:entry | entry = className or:[entry first = className]].
            idx == 0 ifTrue:[
                newSpec := newSpec copyWith:(Array with:className)
            ] ifFalse:[
                entry := newSpec at:idx.
                entry isArray ifTrue:[
                    entry := entry copyWithout:#autoload
                ].
                newSpec at:idx put:entry
            ].
        ].
    ].

    self classNamesAndAttributes:newSpec usingCompiler:compilerOrNil
!

includeMethods:toInclude usingCompiler:compilerOrNil
    "include (add to extensionList) a number of methods.
     Because this requires compilation of my extensionMethodNames-method, a compiler can be passed in,
     which has to do the job.
     This is used by the systembrowser to pass in a CodeGeneratorTool with undo support.
     If nil is passed in, the recurlar compiler is used (no undo support)"

    |oldSpec newSpec newCode extensionMethods|

    oldSpec := self extensionMethodNames.
    newSpec := oldSpec copy.
    extensionMethods := self extensionMethods.

    toInclude do:[:eachMethodToInclude |
        (extensionMethods includes:eachMethodToInclude) ifFalse:[
            newSpec := newSpec copyWith:eachMethodToInclude mclass name.
            newSpec := newSpec copyWith:eachMethodToInclude selector.
        ].
    ].

    newCode := self extensionMethodNames_code_For:newSpec.
    self compile:newCode categorized:'description - contents' using:compilerOrNil
!

makeClassesAutoloaded:toMakeAutoloaded usingCompiler:compilerOrNil
    "include as autoloaded (add to classList) a number of classes.
     Because this requires compilation of my classList-method, a compiler can be passed in,
     which has to do the job.
     (this is used by the systembrowser to pass in a CodeGeneratorTool with undo support)"

    |newSpec|

    newSpec := self classNamesAndAttributes copy.

    toMakeAutoloaded do:[:eachClassToMakeAutoloaded |
        |className|

        className := eachClassToMakeAutoloaded theNonMetaclass name.
        (self autoloaded_classNames includes:className) ifFalse:[
            |idx entry|

            idx := newSpec findFirst:[:entry | entry = className or:[entry first = className]].
            idx == 0 ifTrue:[
                newSpec := newSpec copyWith:(Array with:className with:#autoload)
            ] ifFalse:[
                entry := newSpec at:idx.
                entry isArray ifTrue:[
                    entry := (entry copyWithout:#autoload) copyWith:#autoload.
                ] ifFalse:[
                    entry := Array with:entry with:#autoload
                ].
                newSpec at:idx put:entry.
            ].
        ].
    ].

    self classNamesAndAttributes:newSpec usingCompiler:compilerOrNil
!

updateContentsMethodsCodeUsingCompiler:compilerOrNil ignoreOldDefinition:doRegenerate
    "regenerate the contents-describing methods.
     This searches through the system and picks classes and extension methods
     which have me as package and lists them in the generated class-
     and extensionMethods methods.
     If doRegenerate is true, forget any any previous contents info;
     otherwise, merge new items into the existing lists."

    Class packageQuerySignal
        answer:self package
        do:[
            self
                forEachContentsMethodsCodeToCompileDo:
                    [:code :category |
                        (compilerOrNil ? self theMetaclass compilerClass)
                            compile:code
                            forClass:self theMetaclass
                            inCategory:category.
                    ]
                ignoreOldDefinition:doRegenerate
        ].
!

updateExtensionMethodNamesUsingCompiler:compilerOrNil
    "set the set of extension methods
     Because this requires compilation of my extensionMethodNames-method,
     a compiler can be passed in, which has to do the job.
     (this is used by the systembrowser to pass in a CodeGeneratorTool with undo support)"

    |newCode|

    newCode := self extensionMethodNames_code.
    self compile:newCode categorized:'description - contents' using:compilerOrNil
!

updateMethodsCodeUsingCompiler:compilerOrNil ignoreOldDefinition:doRegenerate
    "regenerate the all contents- plus version describing methods.
     This searches through the system and picks classes and extension methods
     which have me as package and lists them in the generated class-
     and extensionMethods methods.
     If doRegenerate is true, forget any any previous contents info;
     otherwise, merge new items into the existing lists."

    Class packageQuerySignal
        answer:self package
        do:[
            self
                forEachMethodsCodeToCompileDo:
                    [:code :category |
                        (compilerOrNil ? self theMetaclass compilerClass)
                            compile:code
                            forClass:self theMetaclass
                            inCategory:category.
                    ]
                ignoreOldDefinition:doRegenerate
        ].
! !


!ProjectDefinition class methodsFor:'accessing - tests'!

excludedFromTestSuite
    "List of testcases and/or tests excluded from testsuite.
     Entries maybe ClassName or #(ClassName testName)
    "
    ^ #()

    "Created: / 03-06-2011 / 16:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    |suite classes|

    suite := TestSuite named:self package.
    classes := self classes
                select:[:each |
                    [
                    each isLoaded ifFalse:[each autoload].
                    (each isTestCaseLike) and:[ each isAbstract not ]
                    ] on: Autoload autoloadFailedSignal do:[
                                'FAILED TO LOAD: ' infoPrint.
                                each name infoPrintCR.
                        false
                    ]
                ].

    classes := classes asSortedCollection:[:a :b | a name <= b name ].
    classes do: [:eachClass |
        | tests |

        eachClass name infoPrintCR.
        tests := eachClass suite tests.
        tests := tests reject:[:test|self shouldExcludeTest: test].
        suite addTests: tests
    ].
    ^ suite

    "Created: / 01-04-2011 / 15:20:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2011 / 17:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2011 / 14:59:45 / cg"
! !

!ProjectDefinition class methodsFor:'class initialization'!

initialize
    AccessLock isNil ifTrue:[
        LibraryType := #Library.
        GUIApplicationType := #'GUI-Application'.
        NonGUIApplicationType := #'NonGUI-Application'.
        FolderForSubApplicationsType := #'Folder for Subapplications'.
        AccessLock := Semaphore forMutualExclusion name:'ProjectDefinition Lock'.
        Verbose := false.
        PackagesBeingLoaded := Set new.
    ].

    "
     self initialize
    "

    "Modified: / 18-08-2011 / 13:48:31 / cg"
!

initializeAllProjectDefinitions
    "tells all already loaded project definition classes that they are loaded
     (i.e. calls postLoadAction).
     This needs everything else (especially the compiler etc.) to be initialized.
     Therefore, it's not invoked by the projDef's #initialize,
     but instead explicitely, by Smalltalk as a late step in the startup."

    |isStandAloneApp|

    isStandAloneApp := Smalltalk isStandAloneApp.

    self allSubclassesDo:[:eachProjectDefinitionClass |
        eachProjectDefinitionClass isAbstract ifFalse:[
            isStandAloneApp ifFalse:[
                eachProjectDefinitionClass installAutoloadedClasses.
            ].
            eachProjectDefinitionClass projectIsLoaded:true.
        ]
    ].

    "
     self initialize
    "

    "Created: / 23-10-2006 / 16:40:53 / cg"
!

installAutoloadedClasses
    "install all of my autoloaded classes (if any)"

    |classesToFixClassFileName|

    classesToFixClassFileName := OrderedCollection new.

    self autoloaded_classNames do:[:className |
        |cls|

        "/ 'install as autoloaded: ' errorPrint. className errorPrintCR.
        (cls := Smalltalk classNamed:className) isNil ifTrue:[
            Error handle:[:ex |
                (self name,' [warning]: failed to install autoloaded: ',className) errorPrintCR.
                (self name,' [info]: reason: ',ex description) errorPrintCR.
                "/ thisContext fullPrintAll.
            ] do:[
                cls := Smalltalk
                    installAutoloadedClassNamed:className
                    category:'* as yet unknown category *'
                    package:self package
                    revision:nil
            ].
            cls notNil ifTrue:[
                classesToFixClassFileName add:cls.
            ].
        ].
    ].

    Smalltalk addStartBlock:[
        |abbrevs|

        abbrevs := self abbrevs.
        "/ patch the classFileNames
        classesToFixClassFileName do:[:cls |
            |entry classFilenameFromAbbreviations|

            entry := abbrevs at:cls name ifAbsent:nil.
            entry notNil ifTrue:[
                classFilenameFromAbbreviations := entry fileName.
                classFilenameFromAbbreviations notNil ifTrue:[
                    classFilenameFromAbbreviations := classFilenameFromAbbreviations,'.st'.
                    (classFilenameFromAbbreviations ~= cls getClassFilename) ifTrue:[
                        cls setClassFilename:classFilenameFromAbbreviations
                    ].
                ].
            ]
        ].

        "/ patch the categories
        Class withoutUpdatingChangesDo:[
            |entry|

            self classNames do:[:nm |
                |cls|

                ((cls := Smalltalk at: nm) notNil
                        and:[ cls isLoaded not
                        and:[ (entry := abbrevs at:cls name ifAbsent:[nil]) notNil
                ]]) ifTrue:[
                    cls category: (entry category)
                ]
            ]
        ]
    ].


    "
     stx_libbasic installAutoloadedClasses
     stx_libhtml installAutoloadedClasses
     stx_libtool2 installAutoloadedClasses
    "

    "Created: / 23-10-2006 / 16:02:12 / cg"
    "Modified: / 06-03-2011 / 18:26:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 23:32:32 / cg"
! !

!ProjectDefinition class methodsFor:'code generation'!

applicationIconFileNameLinux_code
    ^ String streamContents:[:s |
        s nextPutLine:'applicationIconFileNameLinux'.
        s nextPutLine:'    "Return the name (without suffix) of an icon-file (the app''s icon).'.
        s nextPutLine:'     This is currently unused (will be for desktop definitions)"'.
        s cr;
        nextPutLine:'    ^ nil';
        nextPutLine:'    " ^ self applicationName "'.
    ].

    "
     self applicationIconFileNameLinux_code
     stx_libbasic3 applicationIconFileNameLinux_code
    "

    "Created: / 18-08-2006 / 16:21:01 / cg"
!

applicationIconFileNameOSX_code
    ^ String streamContents:[:s |
        s nextPutLine:'applicationIconFileNameOSX'.
        s nextPutLine:'    "Return the name (without suffix) of an icon-file (the app''s icon).'.
        s nextPutLine:'     This is used to create the info.plist file"'.
        s cr;
        nextPutLine:'    ^ nil';
        nextPutLine:'    " ^ self applicationName "'.
    ].

    "
     self applicationIconFileNameOSX_code
     stx_libbasic3 applicationIconFileNameOSX_code
    "

    "Created: / 18-08-2006 / 16:21:01 / cg"
!

applicationIconFileNameWindows_code
    ^ String streamContents:[:s |
        s nextPutLine:'applicationIconFileNameWindows'.
        s nextPutLine:'    "Return the name (without suffix) of an icon-file (the app''s icon).'.
        s nextPutLine:'     This will be included in the rc-resource file for Windowsdeployment"'.
        s cr;
        nextPutLine:'    ^ nil';
        nextPutLine:'    " ^ self applicationName "'.
    ].

    "
     self applicationIconFileNameWindows_code
     stx_libbasic3 applicationIconFileNameWindows_code
    "

    "Created: / 18-08-2006 / 16:21:01 / cg"
!

applicationIconFileName_code
    "obsolete - replaced by three separate methods as-per-OS"
    
    ^ String streamContents:[:s |
        s nextPutLine:'applicationIconFileName'.
        s nextPutLine:'    "Return the name (without suffix) of an icon-file (the app''s icon);'.
        s nextPutLine:'    "will be included in the rc-resource file"'.
        s cr;
        nextPutLine:'    ^ nil';
        nextPutLine:'    " ^ self applicationName "'.
    ].

    "
     self applicationIconFileName_code
     stx_libbasic3 applicationIconFileName_code
    "

    "Created: / 18-08-2006 / 16:21:01 / cg"
!

classNamesAndAttributes_codeFor:aSpecArray
    "generate method code returning all classes of the project from the given spec."

    ^ String streamContents:[:s |
        s nextPutLine:'classNamesAndAttributes'.
        s nextPutLine:'    "lists the classes which are to be included in the project.'.
        s nextPutLine:'     Each entry in the list may be: a single class-name (symbol),'.
        s nextPutLine:'     or an array-literal consisting of class name and attributes.'.
        s nextPutLine:'     Attributes are: #autoload or #<os> where os is one of win32, unix,..."'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        s nextPutLine:'        "<className> or (<className> attributes...) in load order"'.

        (self classNamesAndAttributesFromSpecArray:aSpecArray) do:[:entry |
            s spaces:8.
            entry storeArrayElementOn:s.
            s cr.
        ].
        s nextPutLine:'    )'
    ].

    "
     stx_libbasic3 classNamesAndAttributes_codeFor:(stx_libbasic3 classNamesAndAttributes)
     exept_expecco classNamesAndAttributes_codeFor:(exept_expecco classNamesAndAttributes)
    "

    "Modified: / 08-08-2006 / 19:24:34 / fm"
    "Created: / 19-02-2007 / 15:43:27 / cg"
!

classNamesAndAttributes_code_ignoreOldEntries:ignoreOldEntries ignoreOldDefinition:ignoreOldDefinition
    "generate method code returning all classes of the project.
     Platform attributes are kept from the old definition.
     If ignoreOldEntries is true, the list is completely recreated;
     if false, existing entries are preserved.
     If ignoreOldDefinition is true, the autoload attribute is set/reset if
     the class is installed as autoloaded in the image (i.e. the state in the image is taken).
     If false, it is taken from an existing definition in #classNamesAndAttributes"

    | newSpec oldSpec ignored renames |

    oldSpec := self classNamesAndAttributesAsSpecArray.
    ignored := self ignoredClassNames asSet.
    newSpec := OrderedCollection new.
    renames := Dictionary new.

    "/ We must preserve attributes across class renames (imagine
    "/ a platform-specific class is renamed). Generally it's not
    "/ possible to reliably detect renames but we're doing our best
    "/ by looking at session changeset. This works fine as long as
    "/ one uses refactorings to rename classes - which she should
    "/ anyeay!!
    "/ 
    "/ So here we create a mapping from old class name (currently in
    "/ a spec) to a new class name (to appear in new spec). This map
    "/ is used later to look up old class entry for (renamed) class
    "/ and copy attributes over.
    ChangeSet current do:[:chg| 
        chg isClassRenameChange ifTrue:[
            | oldName newName |

            oldName := renames keyAtValue: chg oldName ifAbsent:[ chg oldName ].
            newName := chg className.
            oldName = newName ifTrue:[ 
                renames removeKey: oldName
            ] ifFalse:[
                renames at: oldName put: newName.
            ]
        ].
    ].

    ignoreOldEntries ifFalse:[
        oldSpec do:[:oldEntry |
            | newEntry className cls |

            newEntry := oldEntry copy.
            "/ If (old) class has been renamed, add a new entry with new name
            "/ and old attributes...
            className := renames at: oldEntry first ifAbsent:[ oldEntry first ].
            newEntry at: 1 put: className.

            (ignored includes:className) ifFalse:[
                cls := Smalltalk classNamed:className.
                cls notNil ifTrue:[
                    ignoreOldDefinition ifTrue:[
                        cls isLoaded ifFalse:[
                            (newEntry includes:#autoload) ifFalse:[
                                newEntry := newEntry copyWith:#autoload.
                            ].
                        ].
                    ].
                    "JV @ 2010-06-19
                     Force merge default class attributes with existing ones"
                    newEntry := self mergeDefaultClassAttributesFor: cls with: newEntry.
                    newSpec add:newEntry.   
                ] ifFalse:[ 
                    "/ Class named `className` is not present. This can be either
                    "/ because:
                    "/    * it has been deleted or
                    "/    * it's a platform specific class for some other platform
                    "/      than current one.
                    "/ 
                    "/ If the latter, we MUST preserve it in class list.
                    | keep |

                    keep := oldEntry anySatisfy:[:e | e ~~ className and:[ e ~~ #autoload and: [ e ~~ OperatingSystem platformName ]]].
                    keep ifTrue:[ 
                        "Force merge default class attributes with existing ones"
                        newSpec add:newEntry.                                               
                    ].
                ].
            ].
        ].
    ].
    self searchForClasses do:[:eachClass |
        |className attributes oldSpecEntry oldAttributes newEntry|

        eachClass isJavaClass ifFalse:[
            className := eachClass name.
            (ignored includes:className) ifFalse:[
                | oldClassName |

                oldClassName := renames keyAtValue: className ifAbsent:[ className ].
                oldSpecEntry := oldSpec detect:[:entry | entry first = oldClassName] ifNone:nil. 

                (ignoreOldEntries or:[oldSpecEntry isNil]) ifTrue:[
                    (eachClass isLoaded not or:[eachClass isPrivate not]) ifTrue:[
                        (self additionalClassNamesAndAttributes includes:className) ifFalse:[
                            (oldSpecEntry size > 1) ifTrue:[
                                oldAttributes := oldSpecEntry copyFrom:2.
                            ].

                            ignoreOldDefinition ifTrue:[
                                "take autoload attribute from classes state in the image"
                                oldAttributes notNil ifTrue:[
                                    attributes := oldAttributes copyWithout:#autoload.
                                ] ifFalse:[
                                    attributes := #()
                                ].
                                eachClass isLoaded ifFalse:[
                                    attributes := attributes copyWith:#autoload.
                                ].
                            ] ifFalse:[
                                "keep any existing attribute"
                                oldAttributes notNil ifTrue:[
                                    attributes := oldAttributes.
                                ] ifFalse:[
                                    attributes := eachClass isLoaded ifTrue:[ #() ] ifFalse:[ #(autoload) ].
                                ].
                            ].
                            "JV @ 2010-06-19
                             Support fo additional class attributes and programming language attribute"
                            attributes := self mergeDefaultClassAttributesFor: eachClass with: attributes.

                            newEntry := Array with:className.
                            attributes notEmptyOrNil ifTrue:[
                                newEntry := newEntry , attributes.
                            ].
                            newSpec add:newEntry.   
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^ self classNamesAndAttributes_codeFor:newSpec

    "
     stx_libbasic3 classNamesAndAttributes_code_ignoreOldEntries:false ignoreOldDefinition:true
     exept_expecco classNamesAndAttributes_code_ignoreOldEntries:false ignoreOldDefinition:true
    "

    "Modified: / 08-08-2006 / 19:24:34 / fm"
    "Created: / 10-10-2006 / 22:00:50 / cg"
    "Modified: / 06-09-2011 / 07:48:52 / cg"
    "Modified (comment): / 27-07-2017 / 10:56:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

companyName_code
    "generate code that answers the company name."

    ^ self companyName_codeFor:self companyName

    "
     self companyName_code
     stx_libbasic3 companyName_code
    "

    "Created: / 18-08-2006 / 16:20:42 / cg"
!

companyName_codeFor:aString
    "generate code that answers aString as the company name."

    ^ String streamContents:[:s |
        s nextPutLine:'companyName'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #companyName) comment; nextPutLine:'"'.
        s cr; nextPutLine:'    ^ ',aString storeString.
    ].

    "
     self companyName_code
     stx_libbasic3 companyName_code
    "

    "Created: / 18-08-2006 / 16:20:42 / cg"
    "Modified: / 05-03-2014 / 17:00:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileDescriptionMethods
    (self isAbstract) ifTrue:[
        self error:'I am abstract - must be a subclass of Libray- or ApplicationDefinition.'
    ].

    self
        forEachMethodsCodeToCompileDo:[:code :category |
            self compile:code categorized:category
        ].

"/    self instAndClassMethodsDo:[:m | m package:self package].

    "
     DapasXProject compileDescriptionMethods
     DapasX_Datenbasis compileDescriptionMethods
     bosch_dapasx_interactiver_editor compileDescriptionMethods
     stx_libbasic compileDescriptionMethods
    "

    "Created: / 09-08-2006 / 18:00:31 / fm"
    "Modified: / 05-09-2006 / 13:46:29 / cg"
!

description_code
    ^ String streamContents:[:s |
        s nextPutLine:'description'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #description) comment; nextPutLine:'"'.
        s cr; nextPutLine:'    ^ ',self description asString storeString.
    ].

    "
     self description_code
     stx_libbasic3 description_code
    "

    "Created: / 17-08-2006 / 21:24:01 / cg"
    "Modified: / 18-08-2006 / 16:16:24 / cg"
    "Modified: / 05-03-2014 / 17:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

effectiveSubProjects
    "get the subProjects for the current OS platform, that are not excluded"

    ^ self effectiveSubProjects:OperatingSystem platformName

    "Modified: / 17-01-2017 / 16:31:42 / stefan"
!

effectiveSubProjects:osSymbol
    "get the subProjects, that are not excluded.
     osSymbol can be #win32 or #unix (for now)."

    |subProjects|

    subProjects := (self subProjects, self includedInSubProjects) collect:[:eachLine|
                        eachLine isString ifTrue:[
                            eachLine
                        ] ifFalse:[eachLine second = osSymbol ifTrue:[
                            eachLine first.
                        ] ifFalse:[
                            nil.
                        ]].
                   ] as:OrderedSet.

    subProjects remove:self package ifAbsent:[].
    subProjects remove:nil ifAbsent:[].

    self excludedFromSubProjects do:[:eachLine|
        eachLine isString ifTrue:[
            subProjects remove:eachLine ifAbsent:[]. 
        ] ifFalse:[eachLine second = osSymbol ifTrue:[
            subProjects remove:eachLine first ifAbsent:[].
        ]].
    ].

    ^ subProjects

    "Created: / 17-01-2017 / 16:16:03 / stefan"
!

excludedFromPreRequisites_code
    "generate the code of the #excludedFromPreRequisites method"

    ^ String streamContents:[:s |
        s nextPutLine:'excludedFromPreRequisites'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #excludedFromPreRequisites) comment; nextPutLine:'"'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        s nextPutLine:'    )'
    ].

    "Modified: / 05-03-2014 / 17:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodNames_code
    ^ self extensionMethodNames_code_ignoreOldEntries:true

    "
     self extensionMethodNames_code
    "

    "Created: / 17-08-2006 / 21:21:48 / cg"
    "Modified: / 10-10-2006 / 22:02:42 / cg"
!

extensionMethodNames_code_For:extensionMethodNames
    ^ String streamContents:[:s |
        |spec|

        s nextPutLine:'extensionMethodNames'.
        s nextPutLine:'    "lists the extension methods which are to be included in the project.'.
        s nextPutLine:'     Entries are pairwise elements, consisting of class-name and selector."'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.

        spec := extensionMethodNames pairWiseCollect:[:className :selector | className -> selector ].
        spec do:[:entry |
            |mclassName mselector|

            mclassName := entry key asSymbol.
            (mclassName endsWith:' class') ifTrue:[
                mclassName := mclassName asString.
            ].
            mselector := entry value asSymbol.

            s spaces:8.
            mclassName storeArrayElementOn:s.
            s space.
            mselector storeArrayElementOn:s.
            s cr.
        ].
        s nextPutLine:'    )'
    ].
!

extensionMethodNames_code_ignoreOldEntries:ignoreOldEntries
    ^ String streamContents:[:s |
        |oldSpec|

        s nextPutLine:'extensionMethodNames'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #extensionMethodNames) comment; nextPutLine:'"'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.

        oldSpec := self extensionMethodNames pairWiseCollect:[:className :selector | className -> selector ].

        ignoreOldEntries ifFalse:[
            oldSpec do:[:entry |
                |mclassName mselector|

                mclassName := entry key asSymbol.
                (mclassName endsWith:' class') ifTrue:[
                    mclassName := mclassName asString.
                ].
                mselector := entry value asSymbol.

                s spaces:8.
                mclassName storeArrayElementOn:s.
                s space.
                mselector storeArrayElementOn:s.
                s cr.
            ].
        ].

        self searchForExtensions do:[:eachMethod |
            |attributes oldSpecEntry mclassName mselector|

            mclassName := eachMethod mclass name.
            mselector := eachMethod selector.
            "JV@2012-09-07: Do not list Java methods in extensionMethodNames.
             They are loaded lazily by JavaClassReader and if listed here,
             they would cause an error if the package is loaded from source.
             Sort of a HACK, indeed"
            eachMethod mclass theNonMetaclass isJavaClass ifFalse:[
                oldSpecEntry := oldSpec detect:[:entry | entry key = mclassName and:[ entry value = mselector]] ifNone:nil.
                (ignoreOldEntries or:[ oldSpecEntry isNil]) ifTrue:[
                    s spaces:8.
                    mclassName storeArrayElementOn:s.
                    s space.
                    mselector storeArrayElementOn:s.
                    s cr.
                ]
            ].
        ].

        s nextPutLine:'    )'
    ].

    "
     self extensionMethodNames_code_ignoreOldEntries:false
     stx_libjava extensionMethodNames_code_ignoreOldEntries:false
     stx_libtool extensionMethodNames_code_ignoreOldEntries:true
    "

    "Created: / 10-10-2006 / 22:02:36 / cg"
    "Modified: / 23-10-2006 / 11:07:29 / cg"
    "Modified: / 05-03-2014 / 17:00:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forEachContentsMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:ignoreOldDefinition
    "generate code for each contents-specifying method
     (classesAndAttributes, extensionMethodNames, etc.),
     and evaluate aTwoArgBlock on it, passing in the code and the method's category.
     If ignoreOldDefinition is true, new code is generated (class/method scan);
     otherwise, new items are added to the existing lists"

    | cls |

    aTwoArgBlock
        value:(self classNamesAndAttributes_code_ignoreOldEntries:ignoreOldDefinition ignoreOldDefinition:ignoreOldDefinition)
        value:'description - contents'.

    aTwoArgBlock
        value: (self extensionMethodNames_code_ignoreOldEntries:ignoreOldDefinition)
        value: 'description - contents'.

    aTwoArgBlock
        value: self mandatoryPreRequisites_code
        value: 'description'.

    aTwoArgBlock
        value: self referencedPreRequisites_code
        value: 'description'.

    (self class includesSelector:#excludedFromPreRequisites) ifFalse:[
        aTwoArgBlock
            value: self excludedFromPreRequisites_code
            value: 'description'.
    ].

    "/ JV:  No, subProjects **should not** be automatically generated.
    "/      Remember, they are not required to be loaded!! So, generate
    "/      subProjects only if there's no such method yet.
    (self class methodDictionary includesKey: #subProjects) ifFalse:[
        aTwoArgBlock
            value: self subProjects_code
            value: 'description'.
    ].

    (self monticelloPackageName notNil and:[self respondsTo:#monticelloTimestamps_code]) ifTrue:[
        aTwoArgBlock
            value: self monticelloTimestamps_code
            value: 'description - monticello'.
    ].

    "Add additional custom files"
    cls := self.
    [ cls ~~ Object ] whileTrue:[
        cls class selectorsAndMethodsDo:[:selector :method |
            | annotation overwrite |

            annotation := method annotationAt: #method:category:overwrite:.
            annotation notNil ifTrue:[ 
                overwrite := annotation argumentAt: 3.
            ] ifFalse:[ 
                annotation := method annotationAt: #method:category:.
                overwrite := true.
            ].
            (annotation notNil and:[ overwrite or:[ cls class methodDictionary includesKey: (annotation argumentAt:1) ] ]) ifTrue:[
                | code |

                code := self perform: selector.
                code notNil ifTrue:[ 
                    aTwoArgBlock value: code value: (annotation argumentAt: 2)
                ].
            ].
        ].
        cls := cls superclass.
    ].

    "Modified: / 12-06-2015 / 07:02:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forEachDescriptionMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:ignoreOldDefinition
    "generate code for descriptive methods,
     and evaluate aTwoArgBlock on it, passing in the code and the method's category.
     If ignoreOldDefinition is true, new code is generated (class/method scan);
     otherwise, new items are added to the existing lists"

    "/  code like:
    "/
    "/ (self class includesSelector:#productName) ifFalse:[
    "/     aTwoArgBlock
    "/         value: self productName_code
    "/         value: 'description - project information'.
    "/ ].

    #(
        (productName productName_code)
        (description description_code)
        (companyName companyName_code)
        (legalCopyright legalCopyright_code)
    ) pairsDo:[:selector :codeMethodSelector |
        (self class includesSelector:selector) ifFalse:[
            aTwoArgBlock
                value: (self perform:codeMethodSelector)
                value: 'description - project information'.
        ].
    ].
!

forEachMethodsCodeToCompileDo:aTwoArgBlock
    "update code for each method (contents plus version info),
     and evaluate aTwoArgBlock on it, passing in the code and the method's category.
     New items are added to the existing lists"

    self forEachMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:false
!

forEachMethodsCodeToCompileDo:aTwoArgBlock ignoreOldDefinition:ignoreOldDefinition
    "generate code for each method (contents plus version info),
     and evaluate aTwoArgBlock on it, passing in the code and the method's category.
     If ignoreOldDefinition is true, new code is generated (class/method scan);
     otherwise, new items are added to the existing lists"

    self
        forEachContentsMethodsCodeToCompileDo:aTwoArgBlock
        ignoreOldDefinition:ignoreOldDefinition.

    self
        forEachDescriptionMethodsCodeToCompileDo:aTwoArgBlock
        ignoreOldDefinition:ignoreOldDefinition.

    (self monticelloPackageName notNil and:[self respondsTo:#monticelloTimestamps_code]) ifTrue:[
        aTwoArgBlock
            value: self monticelloTimestamps_code
            value: 'description - monticello'.
    ].

    "Created: / 18-08-2006 / 16:22:37 / cg"
    "Modified: / 09-11-2010 / 18:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-12-2011 / 16:42:41 / cg"
!

legalCopyright_code
    ^ String streamContents:[:s |
        s nextPutLine:'legalCopyright'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #legalCopyright) comment; nextPutLine:'"'.
        s cr; nextPutLine:'    ^ ', self legalCopyright storeString.
    ].

    "
     self legalCopyright_code
     stx_libbasic3 legalCopyright_code
    "

    "Created: / 18-08-2006 / 16:21:01 / cg"
    "Modified: / 05-03-2014 / 17:00:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites_code
    "generate the code of the #mandatoryPreRequisites method"

    |preRequisites|

    preRequisites := self searchForPreRequisites first.
    preRequisites removeAllKeys:self excludedFromMandatoryPreRequisites ifAbsent:[].
    preRequisites removeAllKeys:self excludedFromPreRequisites ifAbsent:[].

    ^ String streamContents:[:s |
        s nextPutLine:'mandatoryPreRequisites'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #mandatoryPreRequisites) comment; nextPutLine:'"'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        preRequisites keys asSortedCollection do:[:eachPackageID |
            |reason|

            s spaces:8.
            eachPackageID asSymbol storeOn:s.
            reason := preRequisites at:eachPackageID ifAbsent:[nil].
            reason notEmptyOrNil ifTrue:[
                s nextPutAll:'    "'; nextPutAll:reason anElement; nextPut:$".
            ].
            s cr.
        ].
        s nextPutLine:'    )'
    ].

    "
     demo_demoApp1 mandatoryPreRequisites_code
     stx_libbasic3 mandatoryPreRequisites_code
     stx_libtool2 mandatoryPreRequisites_code
    "

    "Modified: / 08-08-2006 / 19:24:34 / fm"
    "Created: / 17-08-2006 / 21:28:09 / cg"
    "Modified: / 09-10-2006 / 14:27:20 / cg"
    "Modified: / 05-03-2014 / 17:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName_code
    ^ String streamContents:[:s |
        s nextPutLine:'productInstallDirBaseName'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #productInstallDirBaseName) comment; nextPutLine:'"'.
        s cr;
        nextPutLine:'    ^ (self package asCollectionOfSubstringsSeparatedByAny:'':/'') last'.
    ].

    "
     ApplicationDefinition productInstallDirBaseName_code
     stx_libbasic3 productInstallDirBaseName_code
     stx_clients_Clock_QlockTwoWatchApplication productInstallDirBaseName_code
    "

    "Created: / 21-12-2011 / 16:38:11 / cg"
    "Modified: / 05-03-2014 / 17:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName_code
    "generate code that answers the product name."

    ^ self productName_codeFor:(self productName)

    "
     self productName_code
     stx_libbasic3 productName_code
    "

    "Created: / 18-08-2006 / 16:14:19 / cg"
!

productName_codeFor:aString
    "generate code that answers aString as the product name."

    ^ String streamContents:[:s |
        s nextPutLine:'productName'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #productName) comment; nextPutLine:'"'.
        s cr; nextPutLine:'    ^ ',aString storeString.
    ].

    "
     self productName_code
     stx_libbasic3 productName_code
    "

    "Created: / 18-08-2006 / 16:14:19 / cg"
    "Modified: / 05-03-2014 / 17:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

referencedPreRequisites_code
    "generate the code of the #referencedPreRequisites method"

    |preRequisitesColl preRequisites|

    preRequisitesColl := self searchForPreRequisites.
    preRequisites := preRequisitesColl second.
    preRequisites
        removeAllKeys:self excludedFromPreRequisites ifAbsent:[];
        removeAllKeys:self excludedFromRequiredPreRequisites ifAbsent:[];
        removeAllKeys:preRequisitesColl first keys ifAbsent:[].  "remove the mandatory prerequisites"

    ^ String streamContents:[:s |
        s nextPutLine:'referencedPreRequisites'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #referencedPreRequisites) comment; nextPutLine:'"'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        preRequisites keys asSortedCollection do:[:eachPackageID |
            |reason|

            s spaces:8.
            eachPackageID asSymbol storeOn:s.
            reason := preRequisites at:eachPackageID ifAbsent:[nil].
            reason notEmptyOrNil ifTrue:[
                s nextPutAll:'    "'; nextPutAll:reason anElement; nextPut:$".
            ].
            s cr.
        ].
        s nextPutLine:'    )'
    ].

    "
     demo_demoApp1 referencedPreRequisites_code
     stx_libbasic3 referencedPreRequisites_code
     stx_libtool2 referencedPreRequisites_code
    "

    "Modified: / 08-08-2006 / 19:24:34 / fm"
    "Created: / 17-08-2006 / 21:28:09 / cg"
    "Modified: / 09-10-2006 / 14:27:20 / cg"
    "Modified: / 05-03-2014 / 17:00:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects_code
    "generate the code of the #subProjects method.
     Returns nil if no such code is needed (because there are none)"

    ^ String streamContents:[:s |
        s nextPutLine:'subProjects'.
        s nextPutAll: '    "'; nextPutAll: (self class superclass lookupMethodFor: #subProjects) comment; nextPutLine:'"'.
        s nextPutLine:''.
        s nextPutLine:'    ^ #('.
        ProjectDefinition allSubclassesDo:[:each |
            (each package startsWith:(self package,'/')) ifTrue:[
                s nextPutLine:'        #''',each package,''''.
            ]
        ].
        s nextPutLine:'    )'
    ].

    "Modified: / 05-03-2014 / 17:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnRevisionNr_code: revisionNrOrNil
    ^ String streamContents:[:s |
        s nextPutLine:'svnRevisionNr'.
        s nextPutLine:'    "Return a SVN revision number of myself.'.
        s nextPutLine:'     This number is updated after a commit"'.
        s cr;
        nextPutLine:'    ^ "$SVN-Revision:"''', ('%-16s' printf: (Array with: revisionNrOrNil printString)) , '''"$"'.
    ].

    "
     self svnRevisionNr_code
     stx_libbasic3 svnRevisionNr_code
    "

    "Created: / 16-06-2009 / 12:12:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-08-2009 / 09:05:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-03-2012 / 18:43:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!ProjectDefinition class methodsFor:'defaults'!

applicationTypes
    GUIApplicationType isNil ifTrue:[self initialize].
    ^ Array with:GUIApplicationType with:NonGUIApplicationType

    "
     self applicationTypes
    "
!

defaultCategory
    ^'* Projects & Packages *'

    "Created: / 11-08-2006 / 14:16:49 / cg"
!

defaultProjectType
    ^ self libraryTypes first
    "/ ^ self applicationTypes first

    "Created: / 23-08-2006 / 14:27:32 / cg"
!

defaultProjectTypeForGUIApplication
    ^ GUIApplicationType
!

defaultProjectTypeForNonGUIApplication
    ^ NonGUIApplicationType
!

folderForSubApplicationsType
    ^ FolderForSubApplicationsType
!

guiApplicationType
    ^ GUIApplicationType
!

libraryType
    ^ LibraryType
!

libraryTypes
    LibraryType isNil ifTrue:[self initialize].
    ^ Array with:LibraryType

    "
     self libraryTypes
    "
!

nonGuiApplicationType
    ^ NonGUIApplicationType
!

projectTypeSelectors
    "a list of possible project type selectors"

    ^ #( libraryType guiApplicationType nonGuiApplicationType folderForSubApplicationsType )

    "
     self libraryType
     self guiApplicationType
     self nonGuiApplicationType
    "

    "Created: / 23-08-2006 / 14:27:32 / cg"
!

projectTypes
    "a list of possible project types (shown in the new-package dialog's combo list)"

    ^ self libraryTypes , self applicationTypes , { FolderForSubApplicationsType }

    "
     self projectTypes
    "

    "Created: / 23-08-2006 / 14:27:32 / cg"
! !

!ProjectDefinition class methodsFor:'description'!

excludedFromMandatoryPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     mandatory prerequisites list. 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #()
!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #()

    "Modified: / 17-08-2006 / 19:48:59 / cg"
!

excludedFromRequiredPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     required prerequisites list. 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #()

    "Modified: / 17-08-2006 / 19:48:59 / cg"
!

excludedFromSubProjects
    "list packages which are to be explicitely excluded from the automatic constructed
     subProjects list. If empty, every sub-package is included as a prerequisite."

    ^ #()

    "Modified: / 17-08-2006 / 19:49:40 / cg"
!

includedInPreRequisites
    "list packages which are to be implicitely included in the prerequisites list,
     even if not found by the automatic search.
     Redefine this, if classes from other packages are referred to via reflection
     or by constructing names dynamically (i.e. the search cannot find it)"

    ^ #()
!

includedInSubProjects
    "list packages which are to be explicitely included in the subproject list,
     even if not found by the automatic search.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #includedInPreRequisites."

    ^ #()

    "Modified: / 17-08-2006 / 19:57:46 / cg"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #()
!

preRequisites
    "list packages which are required as a prerequisite (both mandatory and referenced).
     This is used to build dependency chains in makefiles"

    "use an OrderedSet here, so that mandatory prerequisites come first"

    ^ OrderedSet new
        addAll:self mandatoryPreRequisites;
        addAll:self referencedPreRequisites;
        addAll:self includedInPreRequisites;
        removeAllFoundIn:self excludedFromPreRequisites;
        yourself.

    "Modified: / 17-08-2006 / 19:54:21 / cg"
!

preRequisitesFor:packageId
    |def|

    def := self definitionClassForPackage:packageId.
    def isNil ifTrue:[
        "Maybe the package is not loaded? Try to load it..."
        [
            Smalltalk loadPackage:packageId.
            def := self definitionClassForPackage:packageId
        ] on:PackageLoadError do:[:ex| def := nil].
    ].
    ^ def isNil ifTrue:[
        "Still no project definition - maybe it does not exist?"
        Transcript showCR:'Warning: no definition class for package: ', packageId.
        ((self searchForPreRequisites:packageId)
            fold:[:d1 :d2| d1 addAll:d2; yourself]) keys
    ] ifFalse:[ 
        def effectivePreRequisites 
    ]

    "Created: / 24-02-2011 / 22:47:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:52:43 / cg"
    "Modified (format): / 19-11-2011 / 11:25:36 / cg"
    "Modified: / 17-01-2017 / 16:55:39 / stefan"
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #()
!

siblingsAreSubProjects
    ^ false
!

splashFileName
    "answer the base-name of the splash bitmap.

     Default is nil, for no splash. If non-nil, it must be a bmp file's name"

    ^ nil.
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #()

    "Modified: / 17-08-2006 / 19:57:46 / cg"
! !

!ProjectDefinition class methodsFor:'description - actions'!

postLoadAction
    "invoked after loading a project"

    "/ intentionally left blank, to be redefined by subclasses (i.e. real projects)

    "Modified: / 17-08-2006 / 19:59:17 / cg"
!

preLoadAction
    "invoked before loading a project"

    "/ intentionally left blank, to be redefined by subclasses (i.e. real projects)
!

preUnloadAction
    "invoked before unloading a project"

    "/ intentionally left blank, to be redefined by subclasses (i.e. real projects)

    "Modified: / 17-08-2006 / 19:59:26 / cg"
! !



!ProjectDefinition class methodsFor:'description - classes'!

additionalClassNamesAndAttributes
    "a List of classes, that belong to the project, but may not be included
     in the image (someone may have removed it by purpose)"

    ^ #()

    "Created: / 21-08-2006 / 19:53:04 / cg"
!

classNamesAndAttributes
    "a correponding method with real names must be present in my concrete subclasses"

    "/ should this be a subclassResponsibility here ?
    ^ #()

    "Created: / 07-08-2006 / 19:02:57 / fm"
    "Modified: / 07-08-2006 / 21:25:25 / fm"
    "Modified: / 17-08-2006 / 20:47:20 / cg"
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    "/ should this be a subclassResponsibility here ?
    ^ #()

    "Modified: / 17-08-2006 / 20:49:51 / cg"
!

ignoredClassNames
    "can be redefined to suppress some classes from being included in a
     generated classNamesAndAttributes spec"

    ^ #()

    "Created: / 23-01-2007 / 19:08:27 / cg"
! !

!ProjectDefinition class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "allows for a base-address definition to be added to the bc.mak file.
     Subclasses may redefine this to something like
        LIB_BASE=$(LIBWIDG_BASE)
     This will be inserted BEFORE the 'include stdHeader'
    "

    ^ nil
!

additionalDefinitions
    "allows for additional definitions/rules to be added to the Make.proto and bc.mak file."

    ^ ''

    "Modified (comment): / 03-02-2015 / 05:59:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalDefinitions_bc_dot_mak
    "allows for additional definitions/rules to be added to the bc.mak file.
     Subclasses may redefine this."

    ^ self additionalDefinitions_nt_dot_mak

    "Created: / 22-08-2006 / 23:59:32 / cg"
!

additionalDefinitions_make_dot_proto
    "allows for additional definitions/rules to be added to the make.proto file."

    ^ self additionalDefinitions

    "Created: / 22-08-2006 / 23:53:08 / cg"
!

additionalDefinitions_nt_dot_mak
    "obsolete - kept for compatibility with old project files"

    ^ self additionalDefinitions

    "Created: / 22-08-2006 / 23:59:32 / cg"
!

additionalHeaderRulesUsingTemplate:template withSeparator:pathSeparator
    "rules for header files (of autoloaded classes).
     For each extended class, which is autoloaded (and therefore, we will not find a header file for it),
     generate a rule to create the header file only."

    ^ String streamContents:[:s |
        (self extensionClassesWithSuperclasses:true) do:[:eachExtendedClass |
            |headerFileDirPath baseFilename|

            (eachExtendedClass isLoaded not or:[eachExtendedClass wasAutoloaded]) ifTrue:[
                headerFileDirPath := self pathToPackage:eachExtendedClass package withSeparator:pathSeparator.
                baseFilename := self filenameForClass:eachExtendedClass.

                s nextPutAll:(template
                                bindWith:headerFileDirPath
                                with:baseFilename).
            ]
        ].
    ].

    "Created: / 12-09-2011 / 16:23:52 / cg"
!

additionalHeaderRules_bc_dot_mak
    "rules for header files (of autoloaded classes)"

    ^ self
        additionalHeaderRulesUsingTemplate:(self singleHeaderRuleTemplate_bc_dot_mak)
        withSeparator:'\'

    "Created: / 12-09-2011 / 15:44:09 / cg"
!

additionalHeaderRules_make_dot_proto
    "rules for header files (of autoloaded classes)"

    ^ self
        additionalHeaderRulesUsingTemplate:(self singleHeaderRuleTemplate_make_dot_proto)
        withSeparator:'/'

    "Created: / 12-09-2011 / 15:44:28 / cg"
!

additionalLinkLibraries_bc_dot_mak
    "allows for additional static libraries to be added to the bc.mak file.
     Subclasses may redefine this"

    "backward compatibilty with old projects"

    ^ self additionalLinkLibraries_nt_dot_mak


    "Created: / 22-08-2006 / 23:53:33 / cg"
!

additionalLinkLibraries_make_dot_proto
    "allows for additional static libraries to be added to the make.proto file."

    ^ ''

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

additionalLinkLibraries_nt_dot_mak
    "obsolete - kept for compatibility with old project files"

    ^ ''

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

additionalRulesFor: fileToGenerateFor
    "Return additional rules for given file specified by <rule:file:> or <rule:extends:file:>.

     See class documentation on rule extension methods"

    | rules cls processed |

    cls := self.
    rules := '' writeStream.
    processed := Set new.
    [ cls ~~ Object ] whileTrue:[
        cls class selectorsAndMethodsDo:[:selector :method |
            method annotationsAt: #file:target: orAt:#file:target:extends: do: [ :annotation |
                (processed includes: selector) ifFalse:[
                    | file target extends contents |

                    processed add: selector.
                    file := annotation argumentAt: 1.
                    target := annotation argumentAt: 2.
                    annotation key == #file:target:extends: ifTrue:[ 
                        extends := annotation argumentAt: 3.
                    ].
                    (#('Make.proto' 'bc.mak' ) includes: file) ifFalse:[ 
                        self error:'Only Make.proto or bc.mak can have extension rules!!'
                    ].
                    extends notNil ifTrue:[
                        file = 'Make.proto' ifTrue:[ 
                            (#('all' 'clean' ) includes: extends) ifFalse:[ 
                                self error: ('Rule %1 cannot be extended. Check documentation to see which rules can be extended' bindWith: extends).
                            ].
                        ].
                        file = 'bc.mak' ifTrue:[ 
                            (#('ALL' 'clean') includes: extends) ifFalse:[ 
                                self error: ('Rule %1 cannot be extended. Check documentation to see which rules can be extended' bindWith: extends).
                            ].
                        ].
                    ].

                    (fileToGenerateFor = file and:[(contents := self perform: selector) notNil]) ifTrue:[ 
                        rules nextPutAll: contents.
                        rules cr.
                        extends notNil ifTrue:[ 
                            rules nextPutAll: extends; nextPutAll:'::'; space; nextPutLine: target; cr.
                        ].
                    ].
                ].
            ]
        ].
        cls := cls superclass.
    ].
    fileToGenerateFor = 'Make.proto' ifTrue:[ 
        rules nextPutAll: self additionalRules_make_dot_proto.
    ] ifFalse:[ 
        fileToGenerateFor = 'bc.mak' ifTrue:[ 
            rules nextPutAll: self additionalRules_bc_dot_mak
        ]
    ].
    ^ rules contents asStringCollection withTabs asString.

    "
    stx_libjava additionalRulesFor: 'Make.proto'
    stx_libjava additionalRulesFor: 'bc.mak'

    stx_libjava generateFile:'Make.proto'
    stx_libjava generateFile:'bc.mak'
    "

    "Created: / 03-02-2015 / 06:49:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2015 / 07:41:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRulesHG_bc_dot_mak

    (self class includesSelector: #version_HG) ifFalse:[^''].

    ^'
# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!!IFDEF HGROOT
$(OUTDIR)%1.$(O): $(HGROOT)\.hg\dirstate
!!ENDIF
' bindWith: self name.

    "
        stx_libscm_mercurial additionalRulesHG_bc_dot_mak
    "

    "Created: / 28-11-2012 / 10:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2012 / 12:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRulesHG_make_dot_proto

    (self class includesSelector: #version_HG) ifFalse:[^''].

    ^'
# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
ifneq (**NOHG**, $(shell hg root 2> /dev/null || echo -n ''**NOHG**''))
%1.$(O): $(shell hg root)/.hg/dirstate
endif
' bindWith: self name.

    "
        stx_libscm_mercurial additionalRulesHG_make_dot_proto
    "

    "Created: / 28-11-2012 / 10:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRulesSvn_make_dot_proto

    (self class includesSelector: #svnRevisionNr) ifFalse:[^''].

    ^'
# Update SVN revision in package definition class
ifneq (,$(findstring .svn,$(wildcard .svn)))
.svnversion: *.st
        if [ -d .svn ]; then \
                rev=$(shell svnversion -n); \
                echo -n $$rev > .svnversion; \
        else \
                echo -n exported > .svnversion; \
        fi

%1.o: %1.st .svnversion
        @if [ -d .svn ]; then \
                rev2="$(shell printf "%-16s" $$(cat .svnversion))"; \
                echo "  [SV]  Expanding svnRevisionNo in $1.st"; \
                sed -e "s/\"\$$SVN\-Revision:\".*\"\$$\"/\"\$$SVN-Revision:\"\''$$rev2\''\"\$$\"/g" $< > .%1.svn.st; \
        fi
        $(MAKE) CC="$(CLASSLIB_CC)" OPT="$(OPT)" SEPINITCODE="$(SEPINITCODE)" STC="$(STC)" STFILE=.%1.svn $(C_RULE);
        sed -i -e "s/\".%1.svn.st\");/\"%1.st\");/g" .%1.svn.c
        $(MAKE) .%1.svn.$(O)
        @mv .%1.svn.$(O) %1.$(O)
endif
' bindWith: self name.

    "
        stx_libbasic3 additionalRulesSvn_make_dot_proto
    "

    "Created: / 24-06-2009 / 21:33:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-11-2012 / 10:12:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_bc_dot_mak
    "obsolete - kept for compatibility with old project files"

    ^ ''

    "Created: / 22-08-2006 / 23:59:24 / cg"
!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ ''

    "Created: / 22-08-2006 / 23:59:16 / cg"
!

additionalSharedLinkLibraries_make_dot_proto
    "allows for additional shared libraries to be added to the make.proto file."

    ^ ''
!

additionalTargetsSvn_make_dot_proto
    "Returns additional targets to make when build projec
     checked out from SVN"

    "As of 2011-02-06, new version of libsvn does not use any additional targets"

    ^''

    "Created: / 24-06-2009 / 21:35:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 06-02-2012 / 15:34:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak
    "obsolete - kept for compatibility with old project files"

    ^ ''

    "Created: / 23-08-2006 / 00:00:35 / cg"
!

additionalTargets_make_dot_proto
    "allows for additional targets to be added to the make.proto file."

    ^ ''

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

additional_post_nsis_rules
    "this will be performed after the nsis did build the program installer"
    ^ ''

    "Created: / 02-06-2015 / 17:41:37 / gg"
!

additional_post_nsis_rules64
    "this will be performed after the nsis did build the program installer for 64bit build"
    ^ ''

    "Created: / 02-06-2015 / 17:41:37 / gg"
!

globalDefines
    "allow for the specification of additional defines for stc compilation of prerequisite packages
     an subprojects"

    ^ ''
!

globalDefines_unix
    "allow for the specification of additional defines for stc compilation of prerequisite packages
     an subprojects"

    ^ self globalDefines
!

globalDefines_win32
    "allow for the specification of additional defines for stc compilation of prerequisite packages
     an subprojects"

    ^ self globalDefines
!

localDefines
    "allow for the specification of additional defines for stc compilation"

    ^ ''
!

localDefines_unix
    "allow for the specification of additional defines for stc compilation"

    ^ self localDefines
!

localDefines_win32
    "allow for the specification of additional defines for stc compilation"

    ^ self localDefines
!

localIncludes
    "allow for the specification of additional include directories"

    ^ ''

    "Created: / 06-09-2006 / 18:14:31 / cg"
!

localIncludes_unix
    "allow for the specification of additional include directories"

    ^ self makeUnixIncludes:(self localIncludes)

    "Created: / 18-08-2006 / 12:50:27 / cg"
    "Modified: / 06-09-2006 / 18:15:26 / cg"
!

localIncludes_win32
    "allow for the specification of additional include directories"

    ^ self makeWin32Includes:(self localIncludes)

    "Created: / 18-08-2006 / 12:50:27 / cg"
    "Modified: / 06-09-2006 / 18:15:37 / cg"
!

primaryTarget
    "allows the primary make target to be defined in the Make.proto/bc.mak file."

    ^ ''

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

primaryTarget_bc_dot_mak
    "allows the primary make target to be defined in the bc.mak file."

    ^ self primaryTarget

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

primaryTarget_make_dot_proto
    "allows the primary make target to be defined in the Make.proto file."

    ^ self primaryTarget

    "Created: / 22-08-2006 / 23:53:33 / cg"
!

singleHeaderRuleTemplate_bc_dot_mak
    "rules for header files (of autoloaded classes)"

    ^ '
%1\%2.$(H):
',Character tab,'pushd %1 \
',Character tab,'& $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly %2.st \
',Character tab,'& popd
'

    "Created: / 12-09-2011 / 15:55:49 / cg"
!

singleHeaderRuleTemplate_make_dot_proto
    "rules for header files (of autoloaded classes)"

    ^ '
%1/%2.$(H):
',Character tab,'cd %1 && $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly %2.st \
'

    "Created: / 12-09-2011 / 15:55:57 / cg"
!

stcOptimizationOptions
    "see the stc reference / stc usage for options.
     Can be redefined in concrete packages.
     For now, the following variants are useful:
        +optspace3                  most compact code
                                    - use for all gui, application code.

        +optinline +optinline2 +inlineNew
                                    fastest code
                                    - use only for computation-intensive classes"

    ^ '+optspace3'

    "Created: / 18-08-2006 / 12:50:27 / cg"
!

stcWarningOptions
    "see the stc reference / stc usage for options.
     Can be redefined in concrete packages.
     For now, the following variants are useful:
        -warn                   no warnings
        -warnNonStandard        no warnings about non-standard smalltalk features
        -warnUnused             no warnings about unused variables"

    ^ '-warnNonStandard'

    "Created: / 18-08-2006 / 12:51:38 / cg"
! !



!ProjectDefinition class methodsFor:'description - project information'!

applicationAdditionalIconFileNames
    "Return the icon-filenames for additional icons of the application
    (empty collection if there are none)"

    ^ #()
!

applicationDocumentTypeDescriptions
    "Return the OSX document type descriptions.
     For deployment, some systems can make use of additional information
     on which documents are handled by the application.
     This is used eg. for double-clicking on a document in OSX.
     If the deployed app can/should handle this, redefine this
     to return a collection of instances of me."


    ^ nil
!

applicationIconFileName
    "Return the icon-filename for the application (nil if there is none)"

    ^ nil
!

applicationIconFileNameLinux
    "Return the icon-filename for the application (nil if there is none)"

    ^ nil
!

applicationIconFileNameOSX
    "Return the OSX icon-filename for the application (nil if there is none).
     This must be the name of a .icns file, which contains the app-icon in
     multiple resolutions."

    ^ nil
!

applicationIconFileNameWindows
    "Return the icon-filename for the application (nil if there is none).
     This must be the name of a .ico file, which contains the app-icon in
     single or multiple resolutions."

    "/ for backward compatibility
    ^ self applicationIconFileName
!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    |m|
    
    m := self module.
    (m = 'stx') ifTrue:[
        ^ 'Claus Gittinger & eXept Software AG'  
    ].
    (m = 'exept') ifTrue:[
        ^ 'eXept Software AG'  
    ].
    ^ 'My Company'

    "Modified: / 18-08-2006 / 16:08:20 / cg"
!

description
    "Returns a description string which will appear in vc.def / bc.def"

    ^self productName,' ',self packageName
"/    ^ self name

    "Created: / 08-08-2006 / 11:15:01 / fm"
    "Modified: / 17-08-2006 / 20:53:34 / cg"
!

fileDescription
    "Returns a description string which will appear in libName.rc and the rc-file"

    ^self description

    "Modified: / 17-08-2006 / 20:27:07 / cg"
!

fileMajorVersionNr
    "Returns a versionNumber which will appear in libName.rc"

    ^ self majorVersionNr

    "Created: / 18-08-2006 / 12:03:32 / cg"
    "Modified: / 30-08-2006 / 18:50:51 / cg"
!

fileMinorVersionNr
    "Returns a versionNumber which will appear in libName.rc"

    ^ self minorVersionNr

    "Created: / 18-08-2006 / 12:03:13 / cg"
    "Modified: / 30-08-2006 / 18:50:46 / cg"
!

fileReleaseNr
    "Returns a releaseNumber which will appear in libName.rc"

    "take the default revision from the cvs-version,
     but ignore a possibly present 'm'-flag that is set when this revision has been modified"

    "JV@2012-11-20: Original code was:

    ^ self cvsRevision last upTo:$m

    But this is too CVS specific. Modern SCMs does not use X.Y style
    revision numbers, instead it uses hashes (Git/Mercurial/Darcs/Monotone).
    Even worse, all the SCM code passes strings around, so providing compatible,
    polymorph object is not possible. Hence following hack."

    | nr |

    nr := (self cvsRevision last upTo:$m) select:[:c|c isDigit].
    nr isEmptyOrNil ifTrue:[^'0'].
    nr := (nr asInteger min: 16r7FFF) printString.
    ^nr

    "Created: / 18-08-2006 / 12:02:58 / cg"
    "Modified: / 30-08-2006 / 18:54:48 / cg"
    "Modified: / 23-11-2012 / 11:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileRevisionNr
    "Returns a revisionNumber which will appear in libName.rc"

    "take the default revision from the cvs-version"

    "JV@2012-11-20: Original code was:

    ^ self cvsRevision first

    But this is too CVS specific. Modern SCMs does not use X.Y style
    revision numbers, instead it uses hashes (Git/Mercurial/Darcs/Monotone).
    Even worse, all the SCM code passes strings around, so providing compatible,
    polymorph object is not possible. Hence following hack."

    | nr |

    nr := self cvsRevision first select:[:c|c isDigit].
    nr isEmptyOrNil ifTrue:[^'0'].
    nr := (nr asInteger min: 16r7FFF) printString.
    ^nr


    "
    stx_libbasic fileRevisionNr
    stx_libbasic2 fileRevisionNr
    stx_libscm_mercurial fileRevisionNr
    "

    "Created: / 18-08-2006 / 12:02:39 / cg"
    "Modified: / 30-08-2006 / 18:54:39 / cg"
    "Modified: / 23-11-2012 / 11:24:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileVersion
    "Returns a fileVersion string which will appear in libName.rc"

    "<major>.<minor>.<rev>.<rel> (such as '1.2.17.1') "

    ^ '%1.%2.%3.%4'
        bindWith:self fileMajorVersionNr
        with:self fileMinorVersionNr
        with:self fileRevisionNr
        with:self fileReleaseNr.

    "
     self fileVersion
    "

    "Modified: / 30-08-2006 / 18:51:49 / cg"
!

fileVersionCommaSeparated
    "Returns a fileVersion string which will appear in libName.rc"

    "<major>,<minor>,<revision>,<release> (such as '2,17,1,2') "

    ^ '%1,%2,%3,%4'
        bindWith:self fileMajorVersionNr
        with:self fileMinorVersionNr
        with:self fileRevisionNr
        with:self fileReleaseNr.

    "Created: / 17-08-2006 / 20:16:17 / cg"
    "Modified: / 30-08-2006 / 18:54:20 / cg"
!

internalName
    "Returns a name string which will appear in libName.rc"

    ^ self package

    "Modified: / 17-08-2006 / 20:27:37 / cg"
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    |m thisYear template|
     
    m := self module.
    thisYear := Date today year.

    m = 'stx' ifTrue:[
        "hardwired-default"
        template := 'Copyright Claus Gittinger %1\nCopyright eXept Software AG %1' 
    ] ifFalse:[
        m = 'exept' ifTrue:[
            "hardwired-default"
            template := 'Copyright eXept Software AG %1' 
        ] ifFalse:[
            template := 'My CopyRight or CopyLeft %1'
        ].
    ].
    ^ template bindWith:thisYear

    "
     self legalCopyright
    "

    "Modified (comment): / 18-11-2016 / 12:23:36 / cg"
!

majorVersionNr
    "Returns a versionNumber which will appear in libName.rc"

    "<major>.<minor>.<revision>.<release> (such as '5.3.2.1')
     the default here takes smalltalks version number.
     But that's probably not good for an end-user-app."

    ^ Smalltalk majorVersionNr

    "Created: / 17-08-2006 / 20:20:18 / cg"
    "Modified: / 30-08-2006 / 18:52:13 / cg"
!

minorVersionNr
    "Returns a versionNumber which will appear in libName.rc"

    "<major>.<minor>.<revision>.<release> (such as '5.3.2.1')
     the default here takes smalltalks version number.
     But that's probably not good for an end-user-app."

    ^ Smalltalk minorVersionNr

    "Created: / 17-08-2006 / 20:20:32 / cg"
    "Modified: / 30-08-2006 / 18:52:16 / cg"
!

productDate
    "Returns a product-date string which will appear in libName.rc and the installer file"

    "take the current date - by default"

    ^ Timestamp now printStringRFC1123Format

    "Created: / 17-08-2006 / 20:17:28 / cg"
!

productDescription
    "Returns a description (for autopackage)"

    ^ self description

    "Created: / 21-12-2010 / 09:32:16 / cg"
!

productFilename
    "Returns a filename which will be used as linkname, product file name etc.
     The final deployable will be named like this (<fn>.dmg / <fn>Setup.ex / <fn>Install.pkg etc.)"

    ^ self productNameAsValidFilename

    "
     stx_projects_smalltalk productName
     stx_projects_smalltalk productFilename
     stx_libbasic productFilename
     stx_doc_coding_demoConsoleApp productFilename
    "

    "Created: / 01-03-2007 / 19:33:06 / cg"
!

productInstallDir
    "Returns a default installDir which will appear in <app>.nsi."

    ^ '$PROGRAMFILES\',(self productInstallDirBaseName).

    "
     stx_projects_smalltalk productInstallDir
     stx_clients_Clock_QlockTwoWatchApplication productInstallDir
    "

    "Created: / 14-09-2006 / 21:23:01 / cg"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ self module

    "Created: / 21-12-2011 / 16:31:38 / cg"
!

productLicense
    "Returns the license (for autopackage)"

    ^ 'Commercial'

    "Created: / 21-12-2010 / 09:31:25 / cg"
!

productMaintainer
    "Returns the maintainer (for autopackage)"

    ^ self companyName

    "Created: / 21-12-2010 / 09:26:16 / cg"
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     This method is usually redefined in a concrete application definition"

    |m nm|

    m := self module.
    m = 'stx' ifTrue:[
        ^ 'Smalltalk/X'
    ].
    m = 'exept' ifTrue:[
        ^ 'eXept AddOns'
    ].

    self isApplicationDefinition ifFalse:[
        ^ 'LibraryName'
    ].

    SubclassResponsibilityError handle:[:ex |
        "/ we get this error, if the concrete class has not yet redefined
        "/ startupClassName.
        self breakPoint:#cg.
        ^ 'ProductName'
    ] do:[
        nm := self startupClassName.
        (nm endsWith:'Startup') ifTrue:[
            ^ nm copyButLast:'Startup' size.
        ].
        (nm endsWith:'Start') ifTrue:[
            ^ nm copyButLast:'Start' size.
        ].
        ^ nm
    ].

    "Modified: / 18-11-2016 / 11:44:03 / cg"
!

productNameAsValidFilename
    "Returns a filename generated from the product name.
     This will be the name of the deployable package (i.e. <fn>.dmg, <fn>Setup.exe, etc.)"

    |nm|

    nm := self productName.
    ^ nm copy replaceAny:'/\:;., ' with:$_

    "
     'Smalltalk/X' replaceAny:'/\:;.,' with:nil
     stx_doc_coding_demoConsoleApp productName
     stx_doc_coding_demoConsoleApp productNameAsValidFilename
    "

    "Created: / 01-03-2007 / 19:19:21 / cg"
!

productPublisher
    "Returns a product publisher which will appear in <app>.nsi."

    ( #('exept' 'stx') includes:self module) ifTrue:[
        ^ 'eXept Software AG'
    ].

    ^ self companyName

    "Created: / 14-09-2006 / 21:12:54 / cg"
!

productType
    "Returns the product type for autopackage"

    ^ 'Application'

    "Created: / 21-12-2010 / 09:28:48 / cg"
!

productVersion
    "Returns a product version which will appear in libName.rc and the installer file"

    "<major>.<minor>.<revision>.<release> (such as '5.3.2.1')"

    ^ '%1.%2.%3.%4'
        bindWith:self majorVersionNr
        with:self minorVersionNr
        with:self revisionNr
        with:self releaseNr.

    "
     self productVersion
    "

    "Modified: / 30-08-2006 / 18:52:47 / cg"
!

productVersionCommaSeparated
    "Returns a product version which will appear in libName.rc"

    "<major>.<minor>.<revision>.<release> (such as '0,1,1,1') "

    ^ '%1,%2,%3,%4'
        bindWith:self majorVersionNr
        with:self minorVersionNr
        with:self revisionNr
        with:self releaseNr.

    "
     self productVersionCommaSeparated
    "

    "Created: / 17-08-2006 / 20:13:32 / cg"
    "Modified: / 30-08-2006 / 18:52:42 / cg"
!

productWebSite
    "Returns a product webSite which will appear in <app>.nsi."

    ( #('exept' 'stx') includes:self module) ifTrue:[
        ^ 'http://www.exept.de'
    ].

    "/ should be redefined by concrete ApplicationDefinition
    ^ 'http://www.yoursite.com'

    "Created: / 14-09-2006 / 21:15:05 / cg"
    "Modified: / 01-03-2007 / 18:11:27 / cg"
!

releaseNr
    "Returns a releaseNr which will appear in libName.rc"

    "<major>.<minor>.<revision>.<release> (such as '5.3.2.1')
     the default here takes smalltalks version number.
     But that's probably not good for an end-user-app."

    ^ Smalltalk releaseNr

    "Created: / 17-08-2006 / 20:20:51 / cg"
    "Modified: / 30-08-2006 / 18:52:22 / cg"
!

revisionNr
    "Returns a revisionNr which will appear in libName.rc"

    "<major>.<minor>.<revision>.<release> (such as '5.3.2.1')
     the default here takes smalltalks version number.
     But that's probably not good for an end-user-app."

    ^ Smalltalk revisionNr

    "Created: / 17-08-2006 / 20:20:40 / cg"
    "Modified: / 30-08-2006 / 18:52:32 / cg"
!

supportedLanguages
    "Returns a list of languages that (should be / are) supported by this application or library.
     Currently this is only used by lint, to verify that the corresponding languages are 
     present in the resource files."

    self module = 'stx' ifTrue:[
        "/ I'm sorry, but for Smalltalk/X jv-branch, we require
        "/ only English. I (JV) can't speak Germang, sadly.
        (Smalltalk releaseIdentification = 'Smalltalk/X jv') 
            ifTrue:[ ^  #(en) ]
            ifFalse:[ ^ #(en de)  ]
    ].    
    ^ #(en)

    "
     stx_goodies_rdoit supportedLanguages
     cg_tools supportedLanguages
    "

    "Modified: / 05-03-2018 / 10:42:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionNumber
    "Returns a version string which will appear in bc.def / vc.def "

    ^''

    "Created: / 08-08-2006 / 11:35:52 / fm"
    "Modified: / 17-08-2006 / 19:46:29 / cg"
! !

!ProjectDefinition class methodsFor:'doc generation'!

autoDocClassNamePatterns
    "lists patterns for class names for which autodoc html-documentation files
     are to be built.
     Return #( '*' ) to get doc files for all classes"

    ^ #(
        '*'
    )
!

generate_autoDocFiles
    "generate html documentation for all classes matching the autoDocNamePatterns.
     Use this, if you don't want to deliver source code, but still need some documentation
     to be deployed."

    self classes do:[:eachClass |
        (self autoDocClassNamePatterns contains:[:pattern | pattern match:eachClass name]) ifTrue:[
            self generateClassDocumentationFor:eachClass.
        ]
    ].
! !

!ProjectDefinition class methodsFor:'file generation'!

apspecFilename
    "/ for linux
    ^ 'autopackage/default.apspec'

    "Created: / 21-12-2010 / 09:43:13 / cg"
!

basicFileNamesToGenerate
    "answer a dictionary (filename -> generator method) with all the files,
     that have to be generated for this package"

    | dict cls |

    dict := OrderedDictionary withKeysAndValues:#(
          'Make.spec'         #'generate_make_dot_spec'
          'Make.proto'        #'generate_make_dot_proto'
          "/ cg: changed to generate Makefile.init instead of Makefile,
          "/     because macosx files are not case sensitive.
          "/ You will have to execute make -f Makefile.init initially
          "/ 'Makefile'          #'generate_makefile'          "/ for unix
          'Makefile.init'     #'generate_makefile'          "/ for unix
          'bc.mak'            #'generate_bc_dot_mak'        "/ for windows
          'abbrev.stc'        #'generate_abbrev_dot_stc'
          'bmake.bat'         #'generate_bmake_dot_mak'     "/ for bcc32
          'vcmake.bat'        #'generate_vcmake_dot_mak'    "/ for msvc
          "/ 'lccmake.bat'       #'generate_lccmake_dot_mak'   "/ for lcc - not supported at the moment
          "/ 'tccmake.bat'       #'generate_tccmake_dot_mak'     "/ for tcc - cannot link at the moment
          'mingwmake.bat'     #'generate_mingwmake_dot_mak'   "/ for mingw
    ).

    dict
        at:self rcFilename      put:#'generate_packageName_dot_rc'.             "/ for windows

    "Add additional custom files"
    cls := self.
    [ cls ~~ Object ] whileTrue:[
        cls class selectorsAndMethodsDo:[:selector :method |
            | annotation |

            annotation := method annotationAt: #file:overwrite:.
            annotation notNil ifTrue:[ 
                dict at: (annotation argumentAt: 1) put: selector
            ].
        ].
        cls := cls superclass.
    ].

    ^ dict.

    "
    stx_libbasic basicFileNamesToGenerate
    stx_libjava basicFileNamesToGenerate
    "

    "Modified (comment): / 05-09-2012 / 19:43:07 / cg"
    "Modified: / 19-01-2015 / 16:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileNamesToGenerate
    "answer the files that have to be generated as a dictionary of names and generator method"

    ^ self basicFileNamesToGenerate removeAllKeys:self protectedFileNames ifAbsent:[]

    "
      stx_libbasic fileNamesToGenerate
    "
!

forEachFileNameAndGeneratedContentsDo:aTwoArgBlock
    "for build-support file generation, checkin etc., use this common method which
     enumerates all fileNames with their generated contents to be built."

    |pairs|

    pairs := OrderedCollection new.
    self forEachFileNameAndGeneratorMethodDo:[:fileName :generator |
        |file|

        file := self perform:generator.
        file notNil ifTrue:[
            pairs add:(Array with:fileName with:file)
        ].
    ].

    pairs pairsDo:aTwoArgBlock

    "Created: / 16-08-2006 / 18:37:52 / User"
    "Modified: / 19-01-2015 / 16:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forEachFileNameAndGeneratorMethodDo:aTwoArgBlock
    "helper for build-support file generation"

    self fileNamesToGenerate keysAndValuesDo:aTwoArgBlock

    "Modified: / 14-09-2006 / 21:02:37 / cg"
!

generateFile:filename
    |action|

    action := self basicFileNamesToGenerate at:filename ifAbsent:[].
    action notNil ifTrue:[
        ^ self perform:action
    ].
    (filename = 'app.rc' or:[filename = 'lib.rc' or:[filename = self rcFilename]]) ifTrue:[
        ^ self generate_packageName_dot_rc
    ].
    (filename = 'loadAll') ifTrue:[
        ^ self generate_loadAll
    ].
    self error:('File "%1" not appropriate (not generated) for this type of project.' bindWith:filename)

    "Modified: / 21-12-2010 / 11:01:10 / cg"
    "Modified (format): / 21-01-2012 / 12:31:40 / cg"
!

generateFile:filename in: directory
    |dir|

    dir := directory asFilename.
    dir exists ifFalse:[self error:'Directory does not exist'].

    (dir / (filename asFilename baseName)) contents:(self generateFile: filename).

    "
        stx_projects_smalltalk generateFile:'package.deps.rake' in: '/tmp'
    "

    "Created: / 26-02-2011 / 10:42:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2011 / 14:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateRemoveShellScriptOn:aStream
    "generate a shell script to a cvs remove of broken class filenames.
     To be called after the output of #generateRenameShellScript: has been performed"

    |firstLine|

    firstLine := true.
    self searchForClasses do:[:eachClass|
        eachClass isJavaClass ifFalse:[
            firstLine ifTrue:[
                aStream nextPutAll:'cvs rm -f '.
                firstLine := false.
            ].
            eachClass classFilename ~= (eachClass generateClassFilename, '.st') ifTrue:[
                aStream nextPutAll:eachClass classBaseFilename; space.
            ]
        ].
    ].
    firstLine ifFalse:[
        aStream cr.
    ].

    "
       stx_goodies_webServer_htmlTree generateRemoveShellScriptOn:Transcript
    "

    "Modified: / 30-07-2014 / 20:44:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateRenameShellScriptOn:aStream
    "generate a shell script to rename broken class filenames"

    self searchForClasses do:[:eachClass|
        eachClass isJavaClass ifFalse:[
            eachClass classFilename ~= (eachClass generateClassFilename, '.st') ifTrue:[
                aStream nextPutAll:'cp ';
                       nextPutAll:eachClass classBaseFilename; nextPutAll:',v ';
                       nextPutAll:eachClass generateClassFilename; nextPutAll:'.st,v'; cr.
            ]
        ]
    ].

    "
       stx_libdb generateRemoveShellScriptOn:Transcript
    "

    "Modified: / 30-07-2014 / 20:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate_abbrev_dot_stc
   "/ for stc: provides abbreviations and namespace information
   self checkIfClassesArePresent.

    ^ String
        streamContents:[:s |
            |addEntry|

            addEntry :=
                [:eachClassName |
                    |cls fn wasLoaded failedToLoad numClassInstvars|

                    s nextPutAll:eachClassName.
                    s nextPutAll:' '.

                    cls := Smalltalk classNamed:eachClassName.
                    cls isNil ifTrue:[
                        fn := self filenameForClass:eachClassName.
                        s nextPutAll:fn.
                        s nextPutAll:' '; nextPutAll:(self package); nextPutAll:' '.
                        s nextPutAll:' '; nextPutAll:'unknownCategory' storeString; nextPutAll:' '.
                        s nextPutAll:' '; nextPutAll:'0'.
                    ] ifFalse:[
                        wasLoaded := cls isLoaded.
                        wasLoaded ifFalse:[
                            failedToLoad := false.

                            Error handle:[:ex |
                                failedToLoad := true.
                            ] do:[
                                ParserFlags
                                    withSTCCompilation:#never
                                    do:[
                                        cls autoload.
                                    ]
                            ].
                        ].

                        fn := self filenameForClass:cls.
                        (fn includes:Character space) ifTrue:[
                            s nextPutAll:fn storeString.
                        ] ifFalse:[
                            s nextPutAll:fn.
                        ].
                        s nextPutAll:' '; nextPutAll:(self package); nextPutAll:' '.
                        s nextPutAll: (cls category asString storeString).
                        failedToLoad ifTrue:[
                            s nextPutAll:' 0'.
                        ] ifFalse:[
                            numClassInstvars := cls theMetaclass instSize - Class instSize.
                            s nextPutAll:' '; nextPutAll:numClassInstvars printString.
                        ].

                        wasLoaded ifFalse:[
                            UserPreferences current autoUnloadAutoloadedClassesInProjectDefinition ifTrue:[
                                cls unload
                            ]
                        ]
                    ].
                    s cr.
                ].

            s nextPutLine:'# automagically generated by the project definition'.
            s nextPutLine:'# this file is needed for stc to be able to compile modules independently.'.
            s nextPutLine:'# it provides information about a classes filename, category and especially namespace.'.

            self allClassNames do:addEntry.
            self namesAndAttributesIn:(self additionalClassNamesAndAttributes) do: [:nm :attr |
                (attr isEmptyOrNil or:[(attr includes:#autoload) not]) ifTrue:[
                    addEntry value:nm
                ].
            ].
        ]

    "
        stx_libbasic generate_abbrev_dot_stc
        DapasXProject generate_abbrev_dot_stc
        DapasX_Datenbasis generate_abbrev_dot_stc
        bosch_dapasx_interactiver_editor generate_abbrev_dot_stc
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 28-01-2014 / 21:43:56 / cg"
!

generate_autopackage_default_dot_apspec

    ^self
        replaceMappings: self autopackage_default_dot_apspec_mappings
        in: self autopackage_default_dot_apspec

    "
     stx_projects_smalltalk generate_autopackage_default_dot_apspec
    "

    "Created: / 21-12-2010 / 09:40:04 / cg"
!

generate_bc_dot_mak
    ^ (self
        replaceMappings: self bc_dot_mak_mappings
        in: self bc_dot_mak) asStringCollection withTabs asString

    "
     DapasXProject generate_bc_dot_mak
     DapasX_Datenbasis generate_bc_dot_mak
    "

    "Modified: / 09-08-2006 / 11:46:14 / fm"
!

generate_bmake_dot_mak

    ^self replaceMappings: self bmake_dot_mak_mappings
            in: self bmake_dot_mak

    "Created: / 17-08-2006 / 20:03:43 / cg"
!

generate_builder_baseline_dot_rbspec
    ^ self replaceMappings:self builder_baseline_dot_rbspec_mappings
        in:self builder_baseline_dot_rbspec

    "
     stx_projects_smalltalk generate_builder_baseline_dot_rbspec

    "

    "Created: / 24-02-2011 / 11:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate_lccmake_dot_mak

    ^self replaceMappings: self bmake_dot_mak_mappings
            in: self lccmake_dot_mak

    "Created: / 03-09-2012 / 19:49:56 / cg"
!

generate_loadAll
    ^ String
        streamContents:[:s |
            |classNames classesLoaded classNamesUnloaded classesSorted|

            classNames := self compiled_classNames_common.
            classesLoaded := classNames
                        collect:[:nm | Smalltalk classNamed:nm]
                        thenSelect:[:cls |  cls notNil and:[cls isLoaded] ].
            classNamesUnloaded := classNames
                        select:[:nm |
                            |cls|
                            cls := Smalltalk classNamed:nm.
                            cls isNil or:[cls isLoaded not]
                        ].

            classesSorted := Class classesSortedByLoadOrder:classesLoaded.

            s nextPutAll:'"/
"/ $' , 'Header' , '$
"/
"/ loadAll-file to fileIn code for: ' , self package , '
"/
"/ Automatically generated from the ProjectDefinition.
"/ DO NOT MODIFY THIS FILE;
"/
"/
"/ Prerequisites:
"/
"/ Smalltalk loadPackage:''module:directory''.
"/ Smalltalk loadPackage:''....''.
!!

"{ package:''' , self package, ''' }"
!!

|files|

''loading package ' , self package ,'...'' infoPrint.

files := #(
'.

            classesSorted do:[:eachClass |
                s nextPutLine:'  ''' , (self filenameForClass:eachClass), ''''.
            ].
            classNamesUnloaded do:[:nm |
                s nextPutLine:'  ''' , (self filenameForClass:nm), ''''.
            ].

            self namesAndAttributesIn:(self additionalClassNamesAndAttributes) do:[:nm :attr |
                (attr isEmptyOrNil or:[(attr includes:#autoload) not]) ifTrue:[
                    s nextPutLine:'  ''' , (self filenameForClass:nm), ''''.
                ].
            ].

            self hasExtensionMethods ifTrue:[
                s nextPutLine:'  ''extensions.st'''.
            ].

            s nextPutAll:'
).

"/ see if there is a classLibrary
(Smalltalk fileInClassLibrary:''' , (self libraryName) , ''') ifTrue:[
    |handle loaded|

    handle := ObjectFileLoader loadedObjectHandles
                    detect:[:h | h package = ''' , self package , '''] ifNone:nil.
    handle ifNotNil:[
        loaded := Set new:(handle classes size).
        handle classes do:[:c| c isMeta ifFalse:[loaded add:c classBaseFilename]].
        files := files \ loaded.
    ].
].

"/ load files which are not in the classLibrary (all if there is none)
files notEmpty ifTrue:[
  '''' infoPrintCR.
  files do:[:f |
    ''.'' infoPrint.
    f asFilename exists ifTrue:[
        Smalltalk fileIn:f.
    ] ifFalse:[
        Smalltalk fileIn:(''source/'' , f)
    ]
  ].
  '' '' infoPrintCR.
].
''done (' , self package ,').'' infoPrintCR.
'.
        ].

    "Created: / 14-09-2006 / 14:21:31 / cg"
    "Modified: / 12-10-2006 / 15:55:00 / cg"
!

generate_make_dot_proto

    ^ (self
        replaceMappings: self make_dot_proto_mappings
        in: self make_dot_proto) asStringCollection withTabs asString

    "
     stx_libbasic2 generate_make_dot_proto
    "

    "Modified: / 09-08-2006 / 11:31:01 / fm"
!

generate_make_dot_spec
    ^ (self
        replaceMappings: self make_dot_spec_mappings
        in: self make_dot_spec) asStringCollection withTabs asString

    "
     DapasXProject generate_make_dot_spec
     DapasX_Datenbasis generate_make_dot_spec
     bosch_dapasx_kernel_Definition generate_make_dot_spec
    "

    "Modified: / 09-08-2006 / 11:31:09 / fm"
!

generate_makefile

    ^ (self
        replaceMappings: self makefile_mappings
        in: self makefile) asStringCollection withTabs asString

    "
     stx_libbasic2 generate_makefile
    "
!

generate_mingwmake_dot_mak

    ^self replaceMappings: self bmake_dot_mak_mappings
            in: self mingwmake_dot_mak

    "Created: / 05-09-2012 / 19:44:07 / cg"
!

generate_packageName_dot_rc

    ^self replaceMappings: self packageName_dot_rc_mappings
            in: self packageName_dot_rc

"
  bosch_dapasx_datenbasis generate_packageName_dot_rc
  bosch_dapasx_hw_schnittstellen  generate_packageName_dot_rc
  stx_libbasic3 generate_packageName_dot_rc
  stx_libwidg3 generate_packageName_dot_rc
  stx_libwidg3 productVersion

"

    "Modified: / 09-08-2006 / 11:31:09 / fm"
    "Modified: / 21-08-2006 / 19:33:21 / cg"
!

generate_package_dot_deps_dot_rake
    ^ (self replaceMappings:self package_dot_deps_dot_rake_mappings
        in:self package_dot_deps_dot_rake) asStringCollection
        withTabs asString

    "
     stx_libjava generate_dependencies_dot_rake"

    "Created: / 24-02-2011 / 22:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate_tccmake_dot_mak

    ^self replaceMappings: self bmake_dot_mak_mappings
            in: self tccmake_dot_mak

    "Created: / 03-09-2012 / 19:50:25 / cg"
!

generate_vc_dot_def

    ^self replaceMappings: self vc_dot_def_mappings
            in: self vc_dot_def

"
  DapasXProject generate_vc_dot_def
  DapasX_Datenbasis generate_vc_dot_def

"

    "Modified: / 09-08-2006 / 11:31:21 / fm"
!

generate_vcmake_dot_mak

    ^self replaceMappings: self bmake_dot_mak_mappings
            in: self vcmake_dot_mak
!

protectedFileNames
    "names of files which should NOT be generated (because they are hand-maintained)
     - redefine this to protect a hand-written Make.proto or other handwritten support files"

    ^ #()

    "Created: / 14-09-2006 / 14:38:40 / cg"
    "Modified: / 21-12-2010 / 11:36:46 / cg"
!

rcFilename
    ^ self fullPackageName,'WINrc.rc'.

    "Created: / 07-09-2006 / 17:07:00 / cg"
!

resourceFilename
    ^ (self rcFilename asFilename withSuffix:'$(RES)') name

    "Created: / 07-09-2006 / 17:12:53 / cg"
! !

!ProjectDefinition class methodsFor:'file mappings'!

autopackage_default_dot_apspec_mappings
    |mappings|

    mappings := Dictionary new.
    ^ mappings
        at: 'TOP' put: (self pathToTopWithSeparator:'/');                 "/ unix here
"/        at: 'MODULE_PATH' put: ( self moduleDirectory );        "/ unix here
        at: 'DESCRIPTION' put: (self description);
        at: 'PRODUCT_NAME' put: (self productName);
        at: 'PRODUCT_VERSION' put: (self productVersion);
        at: 'PRODUCT_DATE' put: (self productDate);
        at: 'PRODUCT_PUBLISHER' put: (self productPublisher);
        at: 'PRODUCT_WEBSITE' put: (self productWebSite);
        at: 'PRODUCT_INSTALLDIR' put: (self productInstallDir);
        at: 'PRODUCT_TYPE' put: (self productType);
        at: 'PRODUCT_LICENSE' put: (self productLicense);
        at: 'PRODUCT_DESCRIPTION' put: (self productDescription);
        at: 'PRODUCT_CPU_VERSIONS' put: 'x86';
        at: 'PRODUCT_ROOT_NAME' put: (self productName);
        at: 'MAINTAINER' put: (self productMaintainer);
        at: 'PACKAGER' put: (self productPublisher);
        at: 'ADDITIONAL_SOURCE_DIRS' put: '';
        at: 'ADDITIONAL_COPYFILES' put: '';
        at: 'ADDITIONAL_INSTALL' put: '';
        yourself.


    "Created: / 21-12-2010 / 09:00:49 / cg"
    "Modified: / 05-09-2012 / 10:09:06 / cg"
!

bc_dot_mak_mappings
    |d|

    d := self common_mappings.
    ^ d
        at: 'TOP' put: ( self pathToTopWithSeparator:'\' );                "/ win32 here
        at: 'MODULE_PATH' put: ( self moduleDirectory_win32 );  "/ win32 here
        at: 'PRIMARY_TARGET' put: (self primaryTarget_bc_dot_mak);
        at: 'ADDITIONAL_BASE_ADDRESS_DEFINITION' put: (self additionalBaseAddressDefinition_bc_dot_mak ? '');
        at: 'ADDITIONAL_DEFINITIONS' put: (self additionalDefinitions_bc_dot_mak ? '');
        at: 'ADDITIONAL_HEADERRULES' put: (self additionalHeaderRules_bc_dot_mak);
        at: 'ADDITIONAL_RULES' put: (self additionalRulesFor: 'bc.mak');
        at: 'ADDITIONAL_RULES_HG' put: (self additionalRulesHG_bc_dot_mak ? '');
        at: 'ADDITIONAL_TARGETS' put: (self additionalTargets_bc_dot_mak ? '');
        at: 'ADDITIONAL_LINK_LIBRARIES' put: (self additionalLinkLibraries_bc_dot_mak ? '');
        at: 'ADDITIONAL_POSTNSISRULES' put: (self additional_post_nsis_rules);  "/ win32 bc here    
        at: 'ADDITIONAL_POSTNSISRULES64' put: (self additional_post_nsis_rules64);  "/ win64 mingw here    
        at: 'LOCAL_INCLUDES' put: (self generateLocalIncludes_win32 ? '');
        at: 'LOCAL_DEFINES' put: self localDefines_win32 ? '';
        at: 'GLOBAL_DEFINES' put: self globalDefines_win32 ? '';
        yourself.

    "Created: / 18-08-2006 / 11:43:39 / cg"
    "Modified: / 05-09-2012 / 10:02:51 / cg"
    "Modified: / 03-02-2015 / 07:28:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2015 / 17:44:11 / gg"
!

bmake_dot_mak_mappings
    ^ self common_mappings
        at:'TOP' put: ( self pathToTopWithSeparator:'\' );
        at:'SUBPROJECT_BMAKE_CALLS' put:(self subProjectBmakeCalls);
        at:'SUBPROJECT_VCMAKE_CALLS' put:(self subProjectVCmakeCalls);
        at:'SUBPROJECT_LCCMAKE_CALLS' put:(self subProjectLCCmakeCalls);
        at:'SUBPROJECT_TCCMAKE_CALLS' put:(self subProjectTCCmakeCalls);
        at:'SUBPROJECT_MINGWMAKE_CALLS' put:(self subProjectMingwmakeCalls);
        yourself

    "Created: / 17-08-2006 / 21:41:56 / cg"
    "Modified: / 05-09-2012 / 19:45:36 / cg"
!

builder_baseline_dot_rbspec_mappings
    |mappings|

    mappings := Dictionary new.
    ^ mappings
        at:'APPLICATION' put:(self perform:#applicationName ifNotUnderstood:[self packageName]);
        at:'APPLICATION_PACKAGE' put:self package printString;
        at:'PREAMBLE' put:self builder_baseline_dot_rbspec_preamble;
        at:'POSTAMBLE' put:self builder_baseline_dot_rbspec_postamble;
        at:'PACKAGES' put:self builder_baseline_dot_rbspec_packages;
        yourself.

    "Modified: / 21-12-2010 / 11:00:22 / cg"
    "Created: / 24-02-2011 / 11:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2011 / 14:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builder_baseline_dot_rbspec_packages
    ^ String streamContents:[:s |
        self allPreRequisitesSorted do: [:packageId |
            s nextPutLine:('  package "%1"' bindWith:packageId).
        ] 
    ].

    "Created: / 24-02-2011 / 11:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2016 / 14:32:44 / cg"
!

classLine_mappings:aClassName
    ^ Dictionary new
        at:'CLASS' put:(self st2c:aClassName);
        yourself

    "Modified: / 09-08-2006 / 18:27:07 / fm"
    "Created: / 19-09-2006 / 22:47:43 / cg"
!

common_mappings
    ^ Dictionary new
        at: 'TAB' put: ( Character tab asString );
        at: 'TOP' put: ( 'depends-on-file(unix vs. win32)' );       "/ must be in specific mapping
        at: 'LIBRARY_NAME' put: ( self libraryName );
        at: 'SUBDIRECTORIES' put: (self generateSubDirectories);
        at: 'MODULE' put: ( self module );
        at: 'MODULE_DIRECTORY' put: ( self moduleDirectory );           "/ always unix format
        at: 'MODULE_PATH' put: ( 'depends-on-file(unix vs. win32)' );   "/ must be in specific mapping
        yourself

    "Created: / 04-09-2012 / 13:04:26 / cg"
!

make_dot_proto_mappings
    ^ self common_mappings
        at: 'MODULE' put: ( self module );
        at: 'MODULE_DIRECTORY' put: ( self moduleDirectory );
        at: 'MODULE_PATH' put: ( self moduleDirectory );
        at: 'TOP' put: ( self pathToTopWithSeparator:'/' );
        at: 'SUBDIRECTORIES' put: (self generateSubDirectories);
        at: 'LIBRARY_NAME' put: ( self libraryName );
        at: 'LOCAL_INCLUDES' put: (self generateLocalIncludes_unix);
        at: 'LOCAL_DEFINES' put: self localDefines_unix;
        at: 'GLOBAL_DEFINES' put: self globalDefines_unix;
        at: 'COMMONSYMFLAG' put: (self commonSymbolsFlag);
        at: 'HEADEROUTPUTARG' put: (self headerFileOutputArg);
        at: 'PRIMARY_TARGET' put: (self primaryTarget_make_dot_proto);
        at: 'ADDITIONAL_DEFINITIONS' put: (self additionalDefinitions_make_dot_proto);
        at: 'ADDITIONAL_HEADERRULES' put: (self additionalHeaderRules_make_dot_proto);
        at: 'ADDITIONAL_RULES' put: (self additionalRulesFor: 'Make.proto');
        at: 'ADDITIONAL_RULES_SVN' put: (self additionalRulesSvn_make_dot_proto);
        at: 'ADDITIONAL_RULES_HG' put: (self additionalRulesHG_make_dot_proto);
        at: 'ADDITIONAL_TARGETS' put: (self additionalTargets_make_dot_proto);
        at: 'ADDITIONAL_TARGETS_SVN' put: (self additionalTargetsSvn_make_dot_proto);
        at: 'ADDITIONAL_LINK_LIBRARIES' put: (self additionalLinkLibraries_make_dot_proto);
        at: 'ADDITIONAL_SHARED_LINK_LIBRARIES' put: (self additionalSharedLinkLibraries_make_dot_proto);
        at: 'DEPENDENCIES' put: (self generateDependencies_unix);
        yourself

    "Created: / 09-08-2006 / 11:20:45 / fm"
    "Modified: / 09-08-2006 / 16:44:48 / fm"
    "Modified: / 24-06-2009 / 21:50:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-09-2012 / 10:10:40 / cg"
    "Modified: / 03-02-2015 / 07:17:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make_dot_spec_mappings
    ^ self common_mappings
        at: 'MODULE_DIRECTORY' put: ( self moduleDirectory );
        at: 'STCWARNINGOPTIONS' put: (self stcWarningOptions);
        at: 'STCOPTIMIZATIONOPTIONS' put: (self stcOptimizationOptions);
        at: 'CLASSES' put: [self generateClasses_make_dot_spec];
        at: 'OBJECTS' put: [self generateObjects_make_dot_spec];
        yourself

    "Created: / 18-08-2006 / 11:44:23 / cg"
    "Modified: / 05-09-2012 / 10:11:02 / cg"
!

makefile_mappings
    ^ Dictionary new
        yourself
!

packageName_dot_rc_mappings
    |d s resourceCount|

    d := Dictionary new.
    d
        at: 'PRODUCT_NAME' put: (self productName);
        at: 'PRODUCT_VERSION' put: (self productVersion);
        at: 'PRODUCT_DATE' put: (self productDate);
        at: 'FILETYPE' put: ( 'VFT_DLL' );
        at: 'FILE_VERSION_COMMASEPARATED' put: (self fileVersionCommaSeparated);
        at: 'PRODUCT_VERSION_COMMASEPARATED' put: (self productVersionCommaSeparated);

        at: 'COMPANY_NAME' put: (self companyName);
        at: 'FILE_DESCRIPTION' put: (self fileDescription);
        at: 'FILE_VERSION' put: (self fileVersion);
        at: 'INTERNAL_NAME' put: (self internalName).

    s := self legalCopyright.
    s notNil ifTrue:[
        d at: 'LEGAL_COPYRIGHT_LINE' put: '      VALUE "LegalCopyright", "',s,'\0"'
    ].
    s := String streamContents:[:stream|
            |suff|

            s := self applicationIconFileNameWindows.
            s notNil ifTrue:[
                s asFilename suffix isEmptyOrNil ifTrue:[
                    suff := '.ico'
                ] ifFalse:[
                    suff := ''
                ].
                'IDR_MAINFRAME           ICON    DISCARDABLE     "%1%2"'
                        expandPlaceholdersWith:(Array with:s with:suff) on:stream.
                stream cr.
            ].

            s := self splashFileName.
            s notNil ifTrue:[
                s asFilename suffix isEmptyOrNil ifTrue:[
                    suff := '.bmp'
                ] ifFalse:[
                    suff := ''
                ].
                'IDR_SPLASH           BITMAP    DISCARDABLE     "%1%2"'
                        expandPlaceholdersWith:(Array with:s with:suff) on:stream.
                stream cr.
            ].
            resourceCount := 2.
            self applicationAdditionalIconFileNames do:[:eachFilename|
                'IDR_MAINFRAME+%1           ICON    DISCARDABLE     "%2"'
                        expandPlaceholdersWith:(Array with:resourceCount with:eachFilename) on:stream.
                stream cr.
                resourceCount := resourceCount+1.
            ].
        ].
    d at: #'ICONDEFINITION_LINE' put:s.

    ^ d

    "Created: / 09-08-2006 / 11:21:21 / fm"
    "Modified: / 22-02-2011 / 11:30:36 / cg"
!

package_dot_deps_dot_rake_mappings
    |dependencies|

    dependencies := String streamContents:[:s |
        "/ Generate dependencies based on mandatory prereqs to define
        "/ build order
        self allPreRequisites asSortedCollection do:[:pkg |
            (ProjectDefinition definitionClassForPackage:pkg) mandatoryPreRequisites asSortedCollection do:[:prereq |
                s nextPutAll:'task "'; nextPutAll: pkg; nextPutAll: '" => "'; nextPutAll: prereq; nextPut: $"; cr.
            ].
            s cr.
        ].
        s cr.

        "/ Now make sure all required libraries are included in the build
        "/ by creating dependency from application to to each prerequisite (both mandatory
        "/ and referenced)
        self allPreRequisites asSortedCollection do:[:prereq |
            s nextPutAll:'task "'; nextPutAll: self package; nextPutAll: '" => "'; nextPutAll: prereq; nextPut: $"; cr.
        ].
    ].

    ^ (Dictionary new)
        at:'DEPENDENCIES' put:dependencies;
        yourself

    "
        stx_libjava generate_package_dot_deps_dot_rake
        cvut_fel_izar_application generate_package_dot_deps_dot_rake
    "

    "Created: / 24-02-2011 / 22:32:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2016 / 09:34:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

replaceMappings: mappings in: fileTemplate
    "Replaces the defined variable mappings found in a file template with the corresponding information"

    ^ fileTemplate bindWithArguments:mappings.

    "
     self replaceMappings: (self nt_dot_def_mappingsFor: self) in: self nt_dot_def
    "

    "Created: / 08-08-2006 / 11:44:27 / fm"
    "Modified: / 08-08-2006 / 12:46:13 / fm"
!

st2c:aString
        ^ (aString asString
            copyReplaceString:'_' withString:('_',($_ codePoint printStringRadix:8)))
                replaceAny:':' with:$_
! !

!ProjectDefinition class methodsFor:'file mappings support'!

classNamesByCategory
    "answer a dictionary
        category -> classNames topological sorted"

    |classes classNames mapping alreadyWarned|

    mapping := Dictionary new.

    classes := Class classesSortedByLoadOrder:self compiled_classes_common.
    classNames := classes collect:[:eachClass| eachClass name].
    self namesAndAttributesIn:(self additionalClassNamesAndAttributes) do: [:nm :attr |
        (attr isEmptyOrNil or:[(attr includes:#autoload) not]) ifTrue:[
            classNames add:nm.
        ].
    ].
    mapping at:'COMMON' put:classNames.

    alreadyWarned := false.
    OperatingSystem knownPlatformNames do:[:platformID |
        |platformClasses platformClassNames|

        platformClasses := self compiled_classesForPlatform:platformID.
        platformClasses notEmpty ifTrue:[
            (platformClasses contains:[:each| each isNil or:[each isLoaded not]]) ifTrue:[
                "win32 classes are not present in linux..."
                Transcript show:'Missing classes for platform: '. Transcript showCR:platformID.
                platformClassNames := self compiled_classNamesForPlatform:platformID.
                platformClassNames
                    select:[:nm | |cls| cls := Smalltalk classNamed:nm. cls isNil or:[cls isLoaded not]]
                    thenDo:[:nm | Transcript tab; showCR:nm].
                UserPreferences current suppressProjectDefinitionWarnings ifFalse:[
                    alreadyWarned ifFalse:[
                        (Dialog confirm:('Dependencies (and therefore build-order) might be incorrect\(some classes for platform ''%1'' are not present or autoloaded; see Transcript).\\Continue anyway without recomputing the compilation order for this platform''s classes?' withCRs bindWith:platformID))
                        ifFalse:[
                            AbortOperationRequest raise.
                        ].
                    ].
                    alreadyWarned := true
                ].
            ] ifFalse:[
                classes := Class classesSortedByLoadOrder:platformClasses.
                platformClassNames := platformClasses collect:[:eachClass| eachClass name].
            ].
            mapping at:platformID asUppercase put:platformClassNames.
        ].
    ].
    ^ mapping

    "
     stx_libbasic classNamesByCategory
     stx_libbasic3 classNamesByCategory
     stx_libview classNamesByCategory
     stx_libjava classNamesByCategory
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 28-01-2014 / 21:40:23 / cg"
!

commonSymbolsFlag
    "only for libraries"

    ^ ''
!

filenameForClass:classNameOrClass
    "answer the base filename of the class without suffix"

"/    "enable this code if you want to convert old filenames to new filenames.
"/     See also: #generateRemoveShellScriptOn: and #generateRenamShellScriptOn:"
"/    classNameOrClass isBehavior ifTrue:[
"/        ^ classNameOrClass generateClassFilename.
"/    ] ifFalse:[
"/        |cls|
"/
"/        cls := Smalltalk classNamed:classNameOrClass.
"/        cls notNil ifTrue:[
"/            ^ cls generateClassFilename.
"/        ].
"/    ].
"/    "end special code"

    ^ Smalltalk fileNameForClass:classNameOrClass.

    "
        self filenameForClass:HTML::Encoder
        Smalltalk fileNameForClass:HTML::Encoder
    "

    "Created: / 08-08-2006 / 20:17:28 / fm"
    "Modified: / 20-10-2006 / 16:22:58 / cg"
!

generateClassLines:classLineTemplate
    "for the init-file: generate class-init-lines for all classes"

    ^ self generateClassLines:classLineTemplate forClasses:(self compiled_classNames_common)
!

generateClassLines:classLineTemplate forClasses:classNames
    "for the init-file: generate class-init-lines for a collection of classes"

    ^ self generateClassLines:classLineTemplate forClasses:classNames includeAdditionalClasses:true
!

generateClassLines:classLineTemplate forClasses:classNames includeAdditionalClasses:includeAdditionalClasses
    "for the init-file: generate class-init-lines for a collection of classes"

    ^ String
        streamContents:[:s |
            |classesLoaded classNamesUnloaded classNamesSorted putLineForClassName|

            putLineForClassName := 
                [:className |
                    |newClassLine mappings|

                    mappings := self classLine_mappings:className.
                    newClassLine := self replaceMappings:mappings in:classLineTemplate.
                    s nextPutLine:newClassLine
                ].
            classesLoaded := classNames collect:[:eachClassName | Smalltalk classNamed:eachClassName]
                                        thenSelect:[:eachClass | eachClass notNil and:[eachClass isLoaded]].
            classNamesUnloaded := classNames
                        select:[:nm |
                            |cls|

                            cls := Smalltalk classNamed:nm.
                            cls isNil or:[ cls isLoaded not ]
                        ].
            classNamesSorted := (Class classesSortedByLoadOrder:classesLoaded) collect:[:cls | cls name].
            classNamesSorted do:putLineForClassName.
            classNamesUnloaded do:putLineForClassName.

            includeAdditionalClasses ifTrue:[
                self namesAndAttributesIn:(self additionalClassNamesAndAttributes)
                    do:[:nm :attr |
                        (attr isEmptyOrNil or:[ (attr includes:#autoload) not ]) ifTrue:[
                            putLineForClassName value:nm.
                        ].
                    ].
                #( ('UNIX' unix)
                   ('WIN32' win32)
                   ('OSX' osx)
                   ('VMS' vms)
                   ('BEOS' beos) )
                        pairsDo:[:ifdef :platformName |
                            |archClassNames archClassesLoaded|

                            archClassNames := self compiled_classNamesForPlatform:platformName.
                            archClassNames notEmpty ifTrue:[
                                s nextPutLine:'#ifdef ' , ifdef.
                                archClassNames do:[:clsName |
                                    putLineForClassName value:clsName
                                ].
                                s nextPutLine:'#endif /* ' , ifdef , ' */'.
                            ].
                        ].
            ]
        ]

    "
     bosch_dapasx_datenbasis  generateClassLines_libInit_dot_cc
     bosch_dapasx_kernel  generateClassLines_libInit_dot_cc
     stx_libbasic3 generateClassLines_libInit_dot_cc
    "

    "Modified: / 16-08-2006 / 18:52:10 / User"
    "Created: / 19-09-2006 / 22:47:50 / cg"
    "Modified: / 20-09-2006 / 11:47:25 / cg"
!

generateClassLines_libInit_dot_cc
    ^ self generateClassLines:(self classLine_libInit_dot_cc)

    "
     bosch_dapasx_datenbasis  generateClassLines_libInit_dot_cc
     bosch_dapasx_kernel  generateClassLines_libInit_dot_cc
     stx_libbasic3 generateClassLines_libInit_dot_cc
    "

    "Created: / 09-08-2006 / 11:21:48 / fm"
    "Modified: / 16-08-2006 / 18:52:10 / User"
    "Modified: / 19-09-2006 / 22:48:14 / cg"
!

generateClasses_make_dot_spec
    |classNamesDict|

    classNamesDict := self classNamesByCategory.

    ^ String streamContents:[:s |
        classNamesDict keys asArray sort do:[:eachCategory|
            | classNames |

            classNames := classNamesDict at: eachCategory. 
            s nextPutAll:eachCategory; nextPutLine:'_CLASSES= \'.
            classNames do:[:eachClassName|
                s tab; nextPutAll:eachClassName; nextPutLine:' \'.
            ].
            s cr.
        ].
        s cr.
    ].

    "
     stx_libbasic generateClasses_make_dot_spec
     stx_libbasic3 generateClasses_make_dot_spec
     stx_libview generateClasses_make_dot_spec
     stx_libboss generateClasses_make_dot_spec
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 20-10-2006 / 16:18:54 / cg"
    "Modified: / 01-02-2017 / 21:57:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateDefinitionClassLine_libInit_dot_cc
    "for the init-file: generate a single class-init-line for the definition class itself"

    ^ self
        generateClassLines:(self classLine_libInit_dot_cc)
        forClasses:(Array with:self name)
        includeAdditionalClasses:false

    "
     stx_libbasic generateDefinitionClassLine_libInit_dot_cc
    "
!

generateDependencies:whichArchitecture
    ^ String
        streamContents:[:s |
            |classNames classesPresent classesLoaded clsBaseName putDependencyForClassBlock
             putDependencyForClassBaseNameBlock
             archClassNames archClassesPresent archClassesLoaded
             putSingleClassDependencyEntryBlock putDependencyForExtensionsBlock classSortBlock|

            classSortBlock := [ :a :b|
                a package == b package ifTrue:[
                    a name < b name
                ] ifFalse:[
                    a package < b package
                ].
            ].

            putSingleClassDependencyEntryBlock := [:cls |
                    |sclsBaseName|

                    s nextPutAll:' $(INCLUDE_TOP)'.
                    s nextPutAll:(self pathSeparator:whichArchitecture).
                    sclsBaseName := self filenameForClass:cls.
                    s nextPutAll:(self
                                topRelativePathTo:sclsBaseName
                                inPackage:cls package
                                architecture:whichArchitecture).
                    s nextPutAll:'.$(H)'.
                ].

            putDependencyForClassBaseNameBlock := [:clsBaseName |
                    s nextPutAll:('$(OUTDIR)',clsBaseName,'.$(O)').
                    s nextPutAll:' '.
                    s nextPutAll:(clsBaseName,'.$(C)').
                    s nextPutAll:' '.
                    s nextPutAll:clsBaseName.
                    s nextPutAll:'.$(H)'.
                    s nextPutAll:': '.
                    s nextPutAll:clsBaseName.
                    s nextPutAll:'.st'.
                ].


            putDependencyForClassBlock := [:cls |
                    |clsBaseName classes|

                    clsBaseName := self filenameForClass:cls.
                    putDependencyForClassBaseNameBlock value:clsBaseName.
                    cls isLoaded ifTrue:[
                        classes := IdentitySet new.
                        cls
                            sharedPools do:[:poolClass |
                                poolClass isNil ifTrue:[
                                    Dialog warn:'At least one pool class is missing.\\Dependencies are incomplete.' withCRs
                                ] ifFalse:[
                                    classes add:poolClass.
                                ]
                            ].

                        cls
                            allSuperclassesDo:[:scls |
                                classes add:scls.
                            ].
                        cls
                            allPrivateClassesDo:[:eachPrivateClass |
                                eachPrivateClass
                                    allSuperclassesDo:[:scls |
                                        |sclsBaseName|

                                        scls ~~ cls ifTrue:[
                                            scls isPrivate ifFalse:[
                                                (classes includes:scls) ifFalse:[
                                                    classes add:scls.
                                                ].
                                            ].
                                        ].
                                    ]
                            ].
                        "/ Sort them to get stable order to avoid false conflicts
                        classes := classes asSortedCollection:classSortBlock.
                        classes do:[:each | putSingleClassDependencyEntryBlock value:each].
                    ].
                    s nextPutLine:' $(STCHDR)'.
                ].

            putDependencyForExtensionsBlock := [
                    | classes |

                    s nextPutAll:'$(OUTDIR)extensions.$(O): extensions.st'.
                    classes := Set new.
                    self extensionMethodNames pairWiseDo:[:className :selector |
                            |mthdCls cls|

                            ((mthdCls := Smalltalk classNamed:className) notNil
                              and:[ mthdCls isLoaded ])
                                    ifTrue:[
                                        cls := mthdCls theNonMetaclass.
                                        (classes includes:cls) ifFalse:[
                                            cls
                                                withAllSuperclassesDo:[:scls |
                                                    (classes includes:scls) ifFalse:[
                                                        classes add:scls.
                                                    ].
                                                ].
                                        ].
                                    ].
                        ].
                    "/ Sort them to get stable order to avoid false conflicts
                    classes := classes asSortedCollection:classSortBlock.
                    classes do:[:each | putSingleClassDependencyEntryBlock value:each].
                    s nextPutLine:' $(STCHDR)'.
                ].

            classNames := self compiled_classNames_common.
            classesPresent := classNames
                collect:[:className | Smalltalk classNamed:className]
                thenSelect:[:cls | cls notNil].
            classesLoaded := classesPresent select:[:cls | cls isLoaded].

            (Class classesSortedByLoadOrder:classesLoaded) do:putDependencyForClassBlock.
            classesPresent reject:[:cls | cls isLoaded] thenDo:putDependencyForClassBlock.

            self namesAndAttributesIn:(self additionalClassNamesAndAttributes)
                do:[:className :attr |
                    |cls|

                    (attr isEmptyOrNil or:[ (attr includes:#autoload) not ]) ifTrue:[
                        ((cls := Smalltalk classNamed:className) notNil) ifTrue:[
                            putDependencyForClassBlock value:cls.
                        ]
                    ].
                ].
            archClassNames := self compiled_classNamesForPlatform:whichArchitecture.
            archClassesPresent := archClassNames
                collect:[:className | Smalltalk classNamed:className]
                thenSelect:[:cls | cls notNil].

            archClassesLoaded := archClassesPresent select:[:cls | cls isLoaded].

            (Class classesSortedByLoadOrder:archClassesLoaded)
                do:putDependencyForClassBlock.

            "some classes are not loaded - probably this is the wrong architecture.
             Sorry, but for these classes, we do not know the superclass chain"
            archClassesPresent
                select:[:cls | cls isLoaded not]
                thenDo:putDependencyForClassBlock.

            "for the following classes, we do not know the superclass chain
             and neither the real class file name"
            archClassNames
                select:[:eachClassName | (Smalltalk classNamed:eachClassName) isNil]
                thenDo:[:eachClassName |
                    putDependencyForClassBaseNameBlock value:(self filenameForClass:eachClassName).
                    s nextPutLine:' $(STCHDR)'.
                ].

            self hasExtensionMethods ifTrue:putDependencyForExtensionsBlock.
        ]

    "
     stx_libbasic3 generateDependencies:#unix
     stx_libbasic3 generateDependencies:#win32
    "

    "Created: / 14-09-2006 / 12:38:57 / cg"
    "Modified: / 27-10-2011 / 16:35:59 / cg"
    "Modified: / 27-02-2014 / 22:34:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateDependencies_unix
    ^ self generateDependencies:#unix

    "
     stx_libbasic3 generateDependencies:#unix
     stx_libbasic3 generateDependencies:#win32
    "

    "Modified: / 14-09-2006 / 13:32:34 / cg"
!

generateDependencies_win32
    ^ self generateDependencies:#win32

    "Created: / 14-09-2006 / 12:39:18 / cg"
!

generateExternalDeclarationForExtensions_libInit_dot_cc
    ^ self hasExtensionMethods ifTrue:[
        'extern void _%1_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);' bindWith: (self st2c: self name)
    ] ifFalse:[ 
        ''
    ].


    "
     stx_libbasic generateExternalDeclarationForExtensions_libInit_dot_cc
     stx_libbasic2 generateExternalDeclarationForExtensions_libInit_dot_cc
    "

    "Created: / 17-06-2016 / 10:50:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateExternalDeclarationLines_libInit_dot_cc
    "for the init-file: generate a single external definition for a single class for the definition class itself"

    ^ self
        generateClassLines:(self classExternalDeclarationLine_libInit_dot_cc)

    "
     stx_libbasic generateExternalDeclarationLines_libInit_dot_cc
     stx_libbasic2 generateExternalDeclarationLines_libInit_dot_cc
    "

    "Modified (comment): / 17-06-2016 / 10:45:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateLocalIncludes_unix
    ^ String streamContents:[:s |
        s nextPutAll:(self localIncludes_unix).
        self searchForProjectsWhichProvideHeaderFiles asSortedCollection
            do:[:includeProject |
                s nextPutAll:' -I$(INCLUDE_TOP)/',(self topRelativePathToPackage:includeProject withSeparator:'/')
            ]
    ]

    "
     bosch_dapasx generateLocalIncludes_unix
     bosch_dapasx_datenbasis generateLocalIncludes_unix
     stx_libbasic generateLocalIncludes_unix
     stx_libview generateLocalIncludes_unix
     stx_libtool2 generateLocalIncludes_unix
     stx_libui generateLocalIncludes_unix
     cg_demos_helloWorld localIncludes_unix
    "

    "Created: / 09-08-2006 / 16:46:49 / fm"
    "Modified: / 07-12-2006 / 17:47:06 / cg"
    "Modified: / 25-11-2013 / 16:40:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateLocalIncludes_win32
    ^ String streamContents:[:s |
        s nextPutAll:(self localIncludes_win32).
        self searchForProjectsWhichProvideHeaderFiles asSortedCollection
            do:[:includeProject |
                s nextPutAll:' -I$(INCLUDE_TOP)\',(self topRelativePathToPackage:includeProject withSeparator:'\')
            ]
    ]

    "
     bosch_dapasx_application generateLocalIncludes_win32
     bosch_dapasx_datenbasis generateLocalIncludes_win32
     stx_libbasic generateLocalIncludes_win32
     stx_libview generateLocalIncludes_win32
     stx_libtool2 generateLocalIncludes_win32
    "

    "Created: / 09-08-2006 / 16:46:49 / fm"
    "Modified: / 07-12-2006 / 17:47:10 / cg"
    "Modified: / 25-11-2013 / 16:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateObjects_make_dot_spec
    |classNamesDict|

    classNamesDict := self classNamesByCategory.

    ^ String streamContents:[:s |
        |putLineForClassName|

        putLineForClassName :=
            [:eachClassName |
                |mappings newObjectLine|
                mappings := self objectLine_make_dot_spec_mappings: eachClassName.
                newObjectLine := self replaceMappings: mappings in: self objectLine_make_dot_spec.
                s nextPutLine:newObjectLine.
            ].

        classNamesDict keys asArray sort do:[:eachCategory | 
            | classNames |

            classNames := classNamesDict at: eachCategory.
            s nextPutAll:eachCategory; nextPutLine:'_OBJS= \'.
            classNames do:putLineForClassName.
            (eachCategory = 'COMMON' and:[self hasExtensionMethods]) ifTrue:[
                s nextPutLine:'    $(OUTDIR)extensions.$(O) \'.
            ].

            s cr.
        ].
        s cr.
    ].

    "
     stx_libbasic generateObjects_make_dot_spec
     stx_libbasic3 generateObjects_make_dot_spec
     stx_libview generateObjects_make_dot_spec
     stx_libboss generateObjects_make_dot_spec
    "

    "Created: / 09-08-2006 / 11:24:39 / fm"
    "Modified: / 20-10-2006 / 16:18:54 / cg"
    "Modified: / 01-02-2017 / 21:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateRequiredMakePrerequisites_bc_dot_mak
    |myProjectId|

    ^ String streamContents:[:s |
        myProjectId := self package.
        "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
         is required!!
         Use 'pushd' instead of 'cd', since cd is executed by borland make directly.
         'popd' is not needed, since each line is executed in
                an own cmd.exe process.
         'popd' is not desireable, since it masks a possible
                error return from the 'bmake'.
        "

        "cg: changed to not go and remake librun"
        (self allPreRequisitesSorted:#effectiveMandatoryPreRequisites "#effectivePreRequisites") do:[:eachProjectId |
            s tab; nextPutAll:'pushd ';
                   nextPutAll:(self msdosPathToPackage:eachProjectId from:myProjectId);
                   nextPutLine:' & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "'.
        ].
    ].

    "
     exept_expecco_application generateRequiredMakePrerequisites_bc_dot_mak
     alspa_batch_application generateRequiredMakePrerequisites_bc_dot_mak
    "
!

generateRequiredMakePrerequisites_make_dot_proto
    |libPath|

    ^ String streamContents:[:s |
        "cg: changed to not go and remake librun"
        (self allPreRequisitesSorted:#effectiveMandatoryPreRequisites "#effectivePreRequisites") do:[:projectID |
            libPath := self pathToPackage:projectID withSeparator:'/'.
            s tab; nextPutAll: 'cd ', libPath; nextPutLine:' && $(MAKE) "CFLAGS_LOCAL=$(GLOBALDEFINES) "'.
        ].

        s cr.
    ].

    "
     exept_expecco_application generateRequiredMakePrerequisites_make_dot_proto
     alspa_batch_application generateRequiredMakePrerequisites_make_dot_proto
    "

    "Modified: / 03-03-2016 / 21:23:31 / cg"
!

generateRequiredMakeReferences_bc_dot_mak
    |myProjectId preRequisites|

    myProjectId := self package.
    "Note: the trailing blank in 'CFLAGS_LOCAL=$(GLOBALDEFINES) '
     is required!!
     Use 'pushd' instead of 'cd', since cd is executed by borland make directly.
     'popd' is not needed, since each line is executed in
            an own cmd.exe process.
     'popd' is not desierable, since it masks a possible
            error return from the 'bmake'.
    "

    preRequisites := self allPreRequisitesSorted:#effectivePreRequisites.
    "these have been already built in preReq"
    preRequisites removeAllFoundIn:(self allPreRequisites:#mandatoryPreRequisites).

    ^ String streamContents:[:s |
        preRequisites do:[:eachProjectId |
            s tab; nextPutAll:'pushd ';
                   nextPutAll:(self msdosPathToPackage:eachProjectId from:myProjectId);
                   nextPutLine:' & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "'.
        ].
    ].

    "
     exept_expecco_application generateRequiredMakeReferences_bc_dot_mak
     alspa_batch_application generateRequiredMakeReferences_bc_dot_mak
    "
!

generateRequiredMakeReferences_make_dot_proto
    |libPath preRequisites|

    preRequisites := self allPreRequisitesSorted:#effectivePreRequisites.
    "these have been already built in preReq"
    preRequisites removeAllFoundIn:(self allPreRequisites:#mandatoryPreRequisites).

    ^ String streamContents:[:s |
        preRequisites do:[:projectID |
            libPath := self pathToPackage:projectID withSeparator:'/'.
            s tab; nextPutAll: 'cd ', libPath; nextPutLine:' && $(MAKE) "CFLAGS_LOCAL=$(GLOBALDEFINES) "'.
        ].

        s cr.
    ].

    "
     exept_expecco_application generateRequiredMakeReferences_make_dot_proto
     alspa_batch_application generateRequiredMakeReferences_make_dot_proto
    "

    "Modified: / 03-03-2016 / 21:23:45 / cg"
!

generateSubDirectories
    ^ String streamContents:[:s |
        self subProjects
            do:[:eachProjectID |
                s space; nextPutAll:(self pathToPackage:eachProjectID from:self package withSeparator:'/')
            ]
    ]

    "
     exept_expecco generateSubDirectories
    "

    "Created: / 09-08-2006 / 11:26:59 / fm"
    "Modified: / 14-09-2006 / 18:46:18 / cg"
!

generate_definitionClassLine_libInit_dot_cc
    "for the init-file: generate a single class-init-line for the definition class itself"

    ^ self
        generateClassLines:(self classLine_libInit_dot_cc)
        forClasses:(Array with:self name)
        includeAdditionalClasses:false

    "
     stx_libbasic generate_definitionClassLine_libInit_dot_cc
    "
!

headerFileOutputArg
    "Every header file is left locally in its lib-dir"

    ^ '-headerDir=.'
!

objectLine_make_dot_spec_mappings: aClassName
    ^ Dictionary new
        at: 'CLASSFILE' put:(self filenameForClass:aClassName);
        yourself

    "Created: / 08-08-2006 / 20:17:28 / fm"
    "Modified: / 09-08-2006 / 18:26:52 / fm"
    "Modified: / 20-10-2006 / 16:22:58 / cg"
!

subProjectBmakeCalls
    "generate submake-calls for borland bcc"

    ^ self subProjectMakeCallsUsing:'call bmake %1 %2'.
!

subProjectLCCmakeCalls
    "generate submake-calls for lcc"

    ^ self subProjectMakeCallsUsing:'call lccmake %1 %2'.

    "Created: / 03-09-2012 / 19:49:08 / cg"
!

subProjectMakeCallsUsing:callString
    "for xxxmake.bat files"
    
    ^ String streamContents:[:s |
        (self effectiveSubProjects:#win32) do:[:packageID |
            |pkgLabel skipLabel joinLabel|
            
            pkgLabel := (packageID copyReplaceAll:$: with:$_) copyReplaceAll:$/ with:$_.
            skipLabel := 'skip_',pkgLabel.
            joinLabel := 'done_',pkgLabel.
            s nextPutLine:'@if not exist ',(self msdosPathToPackage:packageID from:(self package)),' goto ',skipLabel.
            s nextPutLine:'@echo "***********************************"'.
            s nextPutLine:'@echo "Building ',(packageID copyReplaceAll:$: with:$/),'"'.
            s nextPutLine:'@echo "***********************************"'.
            s nextPutLine:'@pushd ', (self msdosPathToPackage:packageID from:(self package)).
            s nextPutAll:'@'; nextPutAll:callString; nextPutLine:' || exit /b "%errorlevel%"'.
            s nextPutLine:'@popd'.
            s nextPutLine:'@goto ',joinLabel.
            s nextPutLine:':',skipLabel.
            s nextPutLine:'@echo "###################################"'.
            s nextPutLine:'@echo "FOLDER MISSING: ',(packageID copyReplaceAll:$: with:$/),'"'.
            s nextPutLine:'@echo "###################################"'.
            s nextPutLine:'exit /b 1'.
            s nextPutLine:':',joinLabel.
            s cr.
        ]
    ]

    "Created: / 14-09-2006 / 18:40:09 / cg"
    "Modified: / 27-09-2011 / 19:36:12 / cg"
    "Modified: / 12-09-2015 / 12:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2017 / 16:32:45 / stefan"
!

subProjectMingwmakeCalls
    "generate submake-calls for mingw"

    ^ self subProjectMakeCallsUsing:'call mingwmake %1 %2'.

    "Created: / 05-09-2012 / 19:45:53 / cg"
!

subProjectTCCmakeCalls
    "generate submake-calls for tcc"

    ^ self subProjectMakeCallsUsing:'call tccmake %1 %2'.

    "Created: / 03-09-2012 / 19:50:53 / cg"
!

subProjectVCmakeCalls
    "generate submake-calls for visual-C"

    ^ self subProjectMakeCallsUsing:'call vcmake %1 %2'.
! !


!ProjectDefinition class methodsFor:'file templates'!

autopackage_default_dot_apspec
    "for linux's autopackage"

^
'# -*- shell-script -*-
[Meta]
ShortName: %(APPLICATION)
SoftwareVersion: %(PRODUCT_VERSION)
DisplayName: %(DESCRIPTION)
RootName: %(PRODUCT_ROOT_NAME)
Summary: %(DESCRIPTION)
Maintainer: %(MAINTAINER)
Packager: %(PACKAGER)
PackageVersion: 1
CPUArchitectures: %(PRODUCT_CPU_VERSIONS)
AutopackageTarget: 1.0
Type: %(PRODUCT_TYPE)
License: %(PRODUCT_LICENSE)

[Description]
%(PRODUCT_DESCRIPTION)

[BuildPrepare]
# If you''re using autotools, the default should be enough.
# prepareBuild will set up apbuild and run configure for you. If you
# need to pass arguments to configure, just add them to prepareBuild:
# prepareBuild --enable-foo --disable-bar
#prepareBuild

[BuildUnprepare]
# If you''re using prepareBuild above, there is no need to change this!!
#unprepareBuild

[Globals]
# Variables declared in this section will be available in all other sections
export APKG_BUILD_SKIP_CONFIGURE=1
export APKG_BUILD_SKIP_MAKE=1
export MYPREFIX=/opt/%(APPLICATION)

[Prepare]
#recommend ''@autopackage.org/autopackage-gtk'' 1

[Imports]
import <<EOF
$source_dir/%(APPLICATION)
%(ADDITIONAL_SOURCE_DIRS)
EOF

for i in $source_dir/*.so
do
    echo $source_dir/$(readlink $i)
done | import

[Install]
if [ "$PREFIX" !!= "/usr" ]
then
    export MYPREFIX=$PREFIX
fi

find . -type d \( -name CVS -or -name ''not_*'' \) -print | xargs rm -rf
mkdir -p $MYPREFIX
copyFiles %(PRODUCT_NAME) *.rc resources        $MYPREFIX/bin
%(ADDITIONAL_COPYFILES)

#installExe %(PRODUCT_NAME)
#installLib *.so
%(ADDITIONAL_INSTALL)

[Uninstall]
# Leaving this at the default is safe unless you use custom commands in
# "Install" to create files. All autopackage API functions
# that installs files are logged.
uninstallFromLog
'

    "Created: / 21-12-2010 / 09:06:21 / cg"
!

bc_dot_mak
    "answer a template for the bc.mak makefile.
     Any variable definition %(Variable) will be later replaced by the mapping.
     $% characters have to be duplicated.
     Only needed for WIN"

    ^ self subclassResponsibility
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
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%%%i in (''hg root'') do SET HGROOT=%%%%i
@IF "%%HGROOT%%" NEQ "" SET DEFINES=%%DEFINES%% "-DHGROOT=%%HGROOT%%"

make.exe -N -f bc.mak  %%DEFINES%% %%*

%(SKIP_IF_ARG_IS_APP_TARGET)

%(SUBPROJECT_BMAKE_CALLS)
'

    "Created: / 17-08-2006 / 20:04:14 / cg"
    "Modified: / 04-09-2012 / 11:46:22 / cg"
    "Modified: / 12-09-2015 / 12:31:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builder_baseline_dot_rbspec
    "For rake-base automatic builder"

    ^ '
# generated from project definition

# load package dependencies
load ''package.deps.rake''

# kludge: clear some invalid dependencies of libwidg
# (should be fixed in baseline)
clear "stx:libwidg" => "stx:libui"
clear "stx:libwidg2" => "stx:libui"

project :''%(APPLICATION):baseline'' do
  # preamble
  %(PREAMBLE)
  # --------

%(PACKAGES)

  application "%(APPLICATION_PACKAGE)"

  # postamble
  %(POSTABLE)
  # ---------

end
'

    "Created: / 24-02-2011 / 11:39:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2011 / 12:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builder_baseline_dot_rbspec_postamble
    ^ ''

    "Created: / 24-02-2011 / 11:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

builder_baseline_dot_rbspec_preamble
    ^ ''

    "Created: / 24-02-2011 / 11:58:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classExternalDeclarationLine_libInit_dot_cc

^'extern void _%(CLASS)_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);'
!

classLine_libInit_dot_cc

^'    _%(CLASS)_Init(pass,__pRT__,snd);'

    "Created: / 08-08-2006 / 12:51:44 / fm"
    "Modified: / 08-08-2006 / 15:46:05 / fm"
!

generate_osx_info_dot_plist
    "template for the info.plist file, which is included in an OS X deployment"
    
    |plist|

    (plist := self osx_info_dot_plist_dictionary) isNil ifTrue:[^ nil].
    MacPlistXMLCoder isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/fileformats/plist/stx'.
        MacPlistXMLCoder isNil ifTrue:[
            self error: 'Cannot load required class MacPlistXMLCoder'.
        ].
    ].    
    ^ MacPlistXMLCoder encode:plist     

    "
     exept_expecco_application info_dot_plist
    "
!

lccmake_dot_mak
    "the template code for the lccmake.bat file"

    ^
'@REM -------
@REM make using lcc compiler
@REM type lccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSELCC=1 %%*

%(SKIP_IF_ARG_IS_APP_TARGET)

%(SUBPROJECT_LCCMAKE_CALLS)
'

    "Created: / 03-09-2012 / 19:49:23 / cg"
!

make_dot_proto
    "the template code for the make.proto file"

    ^ self subclassResponsibility
!

make_dot_spec

^
'# $','Header','$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: ',self name,"' at ',Timestamp now printString,"'.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=%(MODULE)
MODULE_DIR=%(MODULE_DIRECTORY)
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=%(STCOPTIMIZATIONOPTIONS)


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=%(STCWARNINGOPTIONS)

%(CLASSES)

%(OBJECTS)
'

    "Created: / 08-08-2006 / 19:31:29 / fm"
    "Modified: / 09-08-2006 / 15:10:57 / fm"
    "Modified: / 26-07-2012 / 00:56:03 / cg"
!

makefile
^
'#
# DO NOT EDIT
#
# make uses this file (Makefile) only, if there is no
# file named "makefile" (lower-case m) in the same directory.
# My only task is to generate the real makefile and call make again.
# Thereafter, I am no longer used and needed.
#
# MACOSX caveat:
#   as filenames are not case sensitive (in a default setup),
#   we cannot use the above trick. Therefore, this file is now named
#   "Makefile.init", and you have to execute "make -f Makefile.init" to
#   get the initial makefile.  This is now also done by the toplevel CONFIG
#   script.

.PHONY: run

run: makefile
        $(MAKE) -f makefile

#only needed for the definition of $(TOP)
include Make.proto

makefile: mf

mf:
        $(TOP)/rules/stmkmf
'
!

mingwmake_dot_mak
    "the template code for the mingwmake.bat file"

    ^
'@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%%%i in (''hg root'') do SET HGROOT=%%%%i
@IF "%%HGROOT%%" NEQ "" SET DEFINES=%%DEFINES%% "-DHGROOT=%%HGROOT%%"

@pushd %(TOP)\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %%USEMINGW_ARG%% %%*

%(SKIP_IF_ARG_IS_APP_TARGET)

%(SUBPROJECT_MINGWMAKE_CALLS)
'

    "Created: / 05-09-2012 / 19:44:51 / cg"
    "Modified: / 12-09-2015 / 12:31:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectLine_make_dot_spec

    ^'    $(OUTDIR)%(CLASSFILE).$(O) \'

    "Created: / 08-08-2006 / 20:16:46 / fm"
    "Modified: / 23-08-2006 / 11:11:38 / cg"
!

osx_info_dot_plist_dictionary
    "template for the info.plist file, which is included in an OS X deployment"
    
    |plist pkg icnFilename docTypeDescriptions|
    
    plist := Dictionary new.
    plist at:'CFBundleInfoDictionaryVersion' put:'6.0'.
    pkg := self package copyReplaceAny:':/' with:$..
    (pkg endsWith:'.application') ifTrue:[
        pkg := pkg copyButLast:'.application' size.
    ].    
    plist at:'CFBundleIdentifier' put:pkg.
    plist at:'CFBundleShortVersionString' put:(self fileVersion asString).
    plist at:'CFBundleVersion' put:(self fileVersion asString).
    plist at:'LSMinimumSystemVersion' put:'10.6'.
    "/ plist at:'CFBundleDevelopmentRegion' put:'English'.
    plist at:'CFBundleExecutable' put:(self applicationName).
    
    self isLibraryDefinition ifTrue:[
        plist at:'CFBundleName' put:(self package copyReplaceAny:':/' with:$.).
    ] ifFalse:[
        plist at:'CFBundleName' put:(self applicationName).
        plist at:'CFBundlePackageType' put:'APPL'.
    ].    
    (icnFilename := self applicationIconFileNameOSX) notNil ifTrue:[    
        plist at:'CFBundleIconFile' put:icnFilename.
    ].
    (docTypeDescriptions := self applicationDocumentTypeDescriptions) notNil ifTrue:[
        plist at:'CFBundleDocumentTypes' put:
            (docTypeDescriptions collect:[:each |
                |d|
                d := Dictionary new.
                d at:'CFBundleTypeExtensions' put:{ each extension }.
                d at:'CFBundleTypeIconFile' put:{ each iconFileOSX }.
                d at:'CFBundleTypeMimeTypes' put:{ each mimeType }.
                d at:'CFBundleTypeName' put:(each documentTypeName).
                d at:'CFBundleTypeRole' put:'Editor'.
                d
            ]).
    ].        
    ^ plist

    "
     exept_expecco_application info_dot_plist
    "
!

packageName_dot_rc
    "the template code for the <libName>.rc file.
     Only used for WIN"

^
'//
// DO NOT EDIT
// automagically generated from the projectDefinition: ',self name,'.
//
VS_VERSION_INFO VERSIONINFO
  FILEVERSION     %(FILE_VERSION_COMMASEPARATED)
  PRODUCTVERSION  %(PRODUCT_VERSION_COMMASEPARATED)
#if (__BORLANDC__)
  FILEFLAGSMASK   VS_FF_DEBUG | VS_FF_PRERELEASE
  FILEFLAGS       VS_FF_PRERELEASE | VS_FF_SPECIALBUILD
  FILEOS          VOS_NT_WINDOWS32
  FILETYPE        %(FILETYPE)
  FILESUBTYPE     VS_USER_DEFINED
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

    "Created: / 08-08-2006 / 19:31:29 / fm"
    "Modified: / 09-08-2006 / 15:10:57 / fm"
    "Modified: / 07-10-2011 / 10:51:34 / cg"
!

package_dot_deps_dot_rake
    ^ '
# Package dependencies.
# Automatically generated by project defintion.

%(DEPENDENCIES)

'

    "Created: / 24-02-2011 / 22:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tccmake_dot_mak
    "the template code for the tccmake.bat file"

    ^
'@REM -------
@REM make using tcc compiler (Tiny-C)
@REM type tccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSETCC=1 %%*

%(SKIP_IF_ARG_IS_APP_TARGET)


%(SUBPROJECT_TCCMAKE_CALLS)
'

    "Created: / 03-09-2012 / 19:50:41 / cg"
!

vcmake_dot_mak
    "the template code for the vcmake.bat file"

    ^
'@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd %(TOP)\rules
    call vcsetup.bat
    popd
)
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%%%i in (''hg root'') do SET HGROOT=%%%%i
@IF "%%HGROOT%%" NEQ "" SET DEFINES=%%DEFINES%% "-DHGROOT=%%HGROOT%%"


make.exe -N -f bc.mak -DUSEVC=1 %DEFINES% %*

%(SKIP_IF_ARG_IS_APP_TARGET)

%(SUBPROJECT_VCMAKE_CALLS)
'

    "Modified: / 04-09-2012 / 11:45:49 / cg"
    "Modified: / 12-09-2015 / 12:31:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'loading'!

checkForLoad
    "raise an error, if the package is not suitable for loading-"

    self supportedOnPlatform ifFalse:[
        PackageNotCompatibleError raiseWith:self package.
    ].
!

ensureFullyLoaded
    "ensure that all classes and extensions are loaded properly.
     This is normally no problem for compiled classLibs - however, if a package
     has only be installedAsAutoloaded, some classes might want to ensure that
     when being loaded themself."

    self supportedOnPlatform ifFalse:[^ self].

    self hasAllExtensionsLoaded ifFalse:[
        self breakPoint:#cg.
    ].
    self hasAllClassesFullyLoaded ifFalse:[
        self hasAllClassesLoaded ifFalse:[
            self breakPoint:#cg.
        ].
        self installAutoloadedClasses.
        self classes do:[:cls | cls autoload ].
    ].

    "
     stx_libbasic ensureFullyLoaded
    "
    "Verbose := true
     stx_libjavascript hasAllExtensionsLoaded
    "
    "Verbose := true
     stx_goodies_soap_xe hasAllExtensionsLoaded
    "

    "Modified: / 12-09-2011 / 16:57:53 / cg"
!

load
    "load the project
     Answer true, if new classes have been installed for this package,
     false if the package's classes have been already present."

    ^ self loadAsAutoloaded:false.
!

loadAsAutoloaded:asAutoloaded
    "load the project.
     If asAutoloaded == true, install all new classes as autoloaded.
     Answer true, if new classes have been installed for this package,
     false if the package's classes have been already present."

    |newStuffHasBeenLoaded meOrMySecondIncarnation|

    self supportedOnPlatform ifFalse:[^ false].

    self projectIsLoaded ifTrue:[
        asAutoloaded ifFalse:[
            "/ to be considered !!
"/            self isFullyLoaded ifFalse:[
"/                self hasAllExtensionsLoaded ifFalse:[
"/                    self loadExtensions.
"/                ].
"/                self loadAllAutoloadedClasses
"/            ].
        ].
        ^ false
    ].

    "/ the following prevents us from crshing if a project definition's prerequisites
    "/ are wrong and circular/recursive

    thisContext isRecursive ifTrue:[self breakPoint:#cg. ^ false].    "/ avoid endless loops
    (PackagesBeingLoaded includes:self package) ifTrue:[
        "/ seems to be a recursive call
        ^ false
    ].

    PackagesBeingLoaded add:self package.
    PackageLoadInProgressQuery
        answerNotifyLoading:self package
        do:[
            Smalltalk changed: #aboutToLoadPackage with: self.
            [
                newStuffHasBeenLoaded := false.
                Smalltalk silentLoading ifFalse:[
                    "/ thisContext fullPrintAll.
                    Logger info:('loading %1%2...'
                                        bindWith:(asAutoloaded ifTrue:['as autoloaded '] ifFalse:[''])
                                        with:self name).
                ].

                self rememberOverwrittenExtensionMethods.

                self activityNotification:'Executing pre-load action'.
                self executeHooks: #preLoad.
                self preLoadAction.

                meOrMySecondIncarnation := self.

                Class withoutUpdatingChangesDo:[
                    self activityNotification:'Loading prerequisities'.
                    self loadMandatoryPreRequisitesAsAutoloaded:asAutoloaded.

                    self checkPrerequisitesForLoading.

                    asAutoloaded ifFalse:[
                        "ignore binary class library load failure - try is the hard way (loading classes)"
                        PackageLoadError ignoreIn:[
                            self loadClassLibrary.
                            "/ could have overloaded my first incarnation
                            meOrMySecondIncarnation := (Smalltalk at:(self name)) ? self.
                            meOrMySecondIncarnation ~~ self ifTrue:[
                                meOrMySecondIncarnation fetchSlotsFrom:self.
                            ].
                        ].
                    ].

                    self hasAllExtensionsLoaded ifFalse:[
                        self activityNotification:'Loading extensions'.
                        "/ evaluating or here - want extensions to be loaded
                        newStuffHasBeenLoaded := newStuffHasBeenLoaded | meOrMySecondIncarnation loadExtensions.
                    ].
                    (self hasAllClassesLoaded:asAutoloaded not) ifFalse:[
                        self activityNotification:'Loading classes'.
                        "/ evaluating or here - want autoloaded classes to be loaded
                        newStuffHasBeenLoaded := newStuffHasBeenLoaded | (meOrMySecondIncarnation loadAllClassesAsAutoloaded:asAutoloaded).
                    ].
                    "/ no, don't load subProjects here - will lead to a recursion, which leads
                    "/ to some classes being loaded from source (soap)
                    "/     self activityNotification:'Loading sub projects'.
                    "/     meOrMySecondIncarnation loadSubProjectsAsAutoloaded:asAutoloaded.
                ].
                self activityNotification:('Executing post-load action for %1' bindWith:self package).

                "/ mhmh - already done for dll-loaded packages
                "/ meOrMySecondIncarnation initializeAllClasses.

                meOrMySecondIncarnation projectIsLoaded:true.
                meOrMySecondIncarnation ~~ self ifTrue:[
                    self projectIsLoaded:true.
                ].
            ] ensure:[
                PackagesBeingLoaded remove:self package ifAbsent:[].
            ].
            "/ load the other prerequisites
            self loadPreRequisitesAsAutoloaded:asAutoloaded.
            Smalltalk changed: #packageLoaded with: self.
        ].
    self activityNotification:('Done (%1).' bindWith:self package).
    ^ newStuffHasBeenLoaded

    "Created: / 17-08-2006 / 01:01:41 / cg"
    "Modified: / 30-10-2008 / 08:16:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-09-2011 / 10:01:53 / cg"
    "Modified: / 19-09-2016 / 22:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unloadPackage
    "unload the project.
     Fails if there are still instances of any of my classes in the system"

    self projectIsLoaded ifFalse:[^ false].
    thisContext isRecursive ifTrue:[^ false].

    Smalltalk silentLoading ifFalse:[
        "/ thisContext fullPrintAll.
        Logger info:'unloading %1' with:self name.
    ].

    self activityNotification:'Executing pre-unload action'.
    self preUnloadAction.
    self executeHooks: #preUnload.

    self activityNotification:'Restoring original methods'.
    self restoreOverwrittenExtensionMethods.

    Class withoutUpdatingChangesDo:[
        self activityNotification:'Unloading subprojects'.
        self unloadSubProjects.

        self activityNotification:'Unloading classes'.
        self unloadClassLibrary.
        self unloadAllClasses.
    ].
    self projectIsLoaded:false.
    ^ true

    "Modified: / 20-11-2012 / 23:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!ProjectDefinition class methodsFor:'private'!

abbrevs
    "return a dictionary containing my abbreviations;
     this dictionary is read from my project-directory's abbrev.stc file,
     and cached for future use"

    |abbrevs|

    AccessLock critical:[
        |mustRead file myPackageDirectory|

        AbbrevDictionary isNil ifTrue:[
            AbbrevDictionary := WeakIdentityDictionary new.
        ].

        mustRead := false.
        abbrevs := AbbrevDictionary at:self ifAbsent:[ mustRead := true. Dictionary new ].

        mustRead ifTrue:[
            myPackageDirectory := self packageDirectory.
            myPackageDirectory isNil ifTrue:[
            ] ifFalse:[
                file := myPackageDirectory / 'abbrev.stc'.
                file exists ifTrue: [
                    file readingFileDo:[:stream |
                        Smalltalk
                            withAbbreviationsFromStream:stream
                            do:[:nm :fn :pkg :cat :sz|
                                abbrevs at: nm put: (AbbrevEntry new className:nm fileName:fn category:cat numClassInstVars:sz)
                            ]
                    ]
                ].
            ].
        ].
    ].

    ^abbrevs

    "Created: / 06-03-2011 / 18:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-01-2012 / 15:42:47 / cg"
!

additionalClassAttributesFor: aClass
    "Answers additional set of class attributes for given class
     Individual project definitions may override this method, but
     overriding method should always merge its attributes with result
     of 'super additionalClassAttributesFor: aClass'.

     Here, we add #autoload attributes to all test cases and
     test resources, as they are not necessary for the package
     and should not be compiled (because of unwanted dependency
     on stx:goodies/sunit package)

     But not make them autoloaded when the package is separate
     test-package - by conventions such package should by named
     #'module:package/subpackage/tests'
    "
    ((self package endsWith: '/tests') or:[(self package endsWith: '/test')]) ifFalse:[
        (TestCase notNil and:[aClass inheritsFrom: TestCase]) ifTrue:[^#(autoload)].
        (TestResource notNil and:[aClass inheritsFrom: TestResource]) ifTrue:[^#(autoload)].
    ].

    "No additional attributes"
    ^#()

    "
        stx_libbasic additionalClassAttributesFor: Object
        stx_libtool additionalClassAttributesFor: Tools::NavigationHistoryTests
        stx_goodies_sunit additionalClassAttributesFor: TestCase
        stx_goodies_petitparser_tests additionalClassAttributesFor: PPAbstractParseTest


        stx_libtool classNamesAndAttributes_code_ignoreOldEntries:true ignoreOldDefinition: true

    "

    "Created: / 26-10-2009 / 12:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-11-2014 / 00:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkIfClassesArePresent
    "check if all classes defined by this project are present and
     offer a dialog to abort the current operation if not"

    |check nonExistentClasses|

    nonExistentClasses := Set new.

    check :=
            [:eachClassName |
                |cls fn wasLoaded failedToLoad numClassInstvars|

                cls := Smalltalk classNamed:eachClassName.
                cls isNil ifTrue:[
                    Transcript showCR:eachClassName.
                    nonExistentClasses add:eachClassName.
                ].
            ].

    self allClassNames do:check.
    self namesAndAttributesIn:(self additionalClassNamesAndAttributes) do:[:nm :attr |
        (attr isEmptyOrNil or:[(attr includes:#autoload) not]) ifTrue:[
            check value:nm
        ].
    ].

    nonExistentClasses notEmpty ifTrue:[
        Transcript showCR:('"%1" and possibly more classes are missing.\Cannot generate a correct "abbrev.stc" file.' bindWith:nonExistentClasses).
        UserPreferences current suppressProjectDefinitionWarnings ifFalse:[
            (Dialog confirm:(Dialog classResources
                                stringWithCRs:'"%1" and possibly more classes are missing.\Cannot generate a correct "abbrev.stc" file.\\Continue anyway?'
                                with:nonExistentClasses anElement allBold)) ifFalse:[
                AbortOperationRequest raise.
            ].
        ].
        ^ false.
    ].

    ^ true

    "Modified: / 28-01-2014 / 21:44:37 / cg"
!

classNamesAndAttributesAsSpecArray
    "given a classNamesAndAttributes array, make this a spec array (array of arrays).
     This decompresses class-name entries into a one-element array for easier processing"

    ^ self classNamesAndAttributes
        collect:[:entry |
            entry isArray ifTrue:[
                entry first isSymbol ifTrue:[
                    entry
                ] ifFalse:[
                    (Array with:entry first asSymbol) , (entry copyFrom:2)
                ].
            ] ifFalse:[
                Array with:entry asSymbol.
            ]].

    "Created: / 19-02-2007 / 16:11:53 / cg"
!

classNamesAndAttributesDo: aBlock
    self namesAndAttributesIn:(self classNamesAndAttributes) do: aBlock

    "Modified: / 22-08-2006 / 18:20:21 / cg"
!

classNamesAndAttributesFromSpecArray:aSpecArray
    "given a spec array (array of arrays), make this a classNamesAndAttributes array
     as stored literally in the method.
     This compresses single element array-elements into plain names
     (to save code in the compiled binaries) and especially sorts them by load/compile order"

    |newSpec loadedClasses loadedClassNames itemsForUnloadedClasses
     entriesByName|

    entriesByName := Dictionary new.

    newSpec :=
        aSpecArray
            collect:[:entry |
                |nm newEntry|

                (entry isArray and:[entry size == 1]) ifTrue:[
                    nm := newEntry := entry first.
                    entriesByName at:nm put:nm.
                ] ifFalse:[
                    newEntry := entry.
                    (entry isArray and:[entry size > 1]) ifTrue:[
                        nm := entry first.
                        entriesByName at:nm put:entry.
                    ] ifFalse:[
                        nm := entry.
                        entriesByName at:nm put:entry.
                    ].
                ].
                newEntry
            ].

    "/ extract loaded and unloaded classes.
    loadedClasses := OrderedCollection new.
    itemsForUnloadedClasses := OrderedCollection new.

    newSpec do:[:entry |
        |clsName clsOrNil|

        (entry isArray and:[entry includes:#autoload]) ifTrue:[
            itemsForUnloadedClasses add:entry.
        ] ifFalse:[    
            clsName := entry isArray ifTrue:[ entry first ] ifFalse:[ entry ].
            clsOrNil := Smalltalk classNamed:clsName.
            (clsOrNil notNil and:[clsOrNil isLoaded]) ifTrue:[
                loadedClasses add:clsOrNil.
            ] ifFalse:[
                itemsForUnloadedClasses add:entry.
            ]
        ]
    ].
    "/ and sort by load order
    loadedClassNames := (Class classesSortedByLoadOrder:loadedClasses) collect:[:cls | cls name].
    newSpec := loadedClassNames collect:[:nm | entriesByName at:nm ifAbsent:[ { nm . #autoload }]].

    "/ reconstruct contents array, unloaded classes last.
    ^ newSpec asArray , itemsForUnloadedClasses asArray.
!

compile:someCode categorized:category
    ^ self compile:someCode categorized:category using:nil
!

compile:someCode categorized:category using:compilerOrNil
    ^ Class packageQuerySignal
        answer:self package
        do:[
            (compilerOrNil ? self theMetaclass compilerClass)
                compile:someCode
                forClass:self theMetaclass
                inCategory:category
        ]

    "Created: / 23-08-2006 / 14:36:53 / cg"
!

compiled_classes
    ^ self compiled_classNames
        collect:
            [:eachName|
                |cls|

                cls := (Smalltalk at:eachName asSymbol).
                (cls isNil or:[cls isBehavior not]) ifTrue:[
                    Transcript showCR:('ProjectDefinition: missing/invalid class: ', eachName).
                    cls := nil.
                ].
                cls.
            ]
        thenSelect:[:cls | cls notNil]

    "Created: / 09-08-2006 / 16:28:15 / fm"
    "Modified: / 09-08-2006 / 18:02:28 / fm"
    "Modified: / 07-12-2006 / 17:48:11 / cg"
!

compiled_classesDo:aBlock
    self compiled_classes do:aBlock.

    "Created: / 09-08-2006 / 16:28:15 / fm"
    "Modified: / 09-08-2006 / 18:02:28 / fm"
!

compiled_classesForPlatform:arch
    ^ (self compiled_classNamesForPlatform:arch)
        collect:[:eachName | (Smalltalk classNamed:eachName)]

    "
     stx_libbasic compiled_classesForArchitecture:#win32
     stx_libbasic compiled_classesForArchitecture:#macos
     stx_libbasic compiled_classesForArchitecture:#unix
    "

    "Created: / 09-08-2006 / 16:28:15 / fm"
    "Modified: / 09-08-2006 / 18:02:28 / fm"
    "Modified: / 07-12-2006 / 17:43:17 / cg"
!

compiled_classes_common
    ^ self
        compiled_classNames_common
            collect:[:eachName |
                |cls|

                cls := Smalltalk classNamed:eachName.
                cls isNil ifTrue:[
                    Transcript showCR:('Warning: Missing/invalid class: %1 - the class is skipped in the list of compiled classes.').
                    UserPreferences current suppressProjectDefinitionWarnings ifFalse:[
                        self warn:('Missing/invalid class: %1\\%2'
                                    bindWith:eachName
                                    with:('Warning: The class is skipped in the list of compiled classes.' allBold)) withCRs.
                    ].
                    cls := nil.
                ].
                cls
            ]
            thenSelect:[:cls| cls notNil "isBehavior"]

    "Created: / 09-08-2006 / 16:28:15 / fm"
    "Modified: / 09-08-2006 / 18:02:28 / fm"
    "Modified: / 28-01-2014 / 21:45:08 / cg"
!

cvsRevision
    |rev|

    rev := self revision.
    rev isNil ifTrue:[
        "not yet pubplished"
        ^ #( '0' '1' )
    ].
    ^ rev asCollectionOfSubstringsSeparatedBy:$. .

    "
     self cvsRevision
     stx_libbasic3 cvsRevision
    "

    "Created: / 17-08-2006 / 20:19:03 / cg"
!

defaultClassAttributesFor: aClass
    "Answers default set of class attributes for given class.
     This is internal method only, to per-project customization
     please override either #additionalClassAttributes or
     #additional classAttributesFor:"

    | attrs |

    "JV @ 2010-06-19
     Add a programming language attribute for non-smalltalk classes.
     Used by multi-lang enabled loading mechanism"
    attrs := aClass programmingLanguage isSmalltalk
                ifTrue:[#()]
                ifFalse:[Array with: (Array with: #lang with: aClass programmingLanguage name asSymbol)].


    "JV @ 2009-10-26
     Give a project definition to specify additional attributes for given class."
    attrs := attrs , (self additionalClassAttributesFor: aClass).

    ^attrs

    "Created: / 19-06-2010 / 10:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inconsistency:message
    Dialog warn:message

"
    self searchForNeverCompiledSuperclasses
    DapasX_Datenbasis searchForNeverCompiledSuperclasses
"

    "Created: / 09-08-2006 / 16:32:31 / fm"
!

makeOSIncludesWith:fileSeparator from:aString
    ^ aString copy replaceAny:'/\' with:fileSeparator

    "
     self makeOSIncludesWith:$/ from:'-I$(TOP)/foo/bar'
     self makeOSIncludesWith:$\ from:'-I$(TOP)/foo/bar'
    "

    "Created: / 06-09-2006 / 18:17:03 / cg"
!

makeUnixIncludes:aString
    ^ self makeOSIncludesWith:$/ from:aString

    "Created: / 06-09-2006 / 18:16:19 / cg"
!

makeWin32Includes:aString
    ^ self makeOSIncludesWith:$\ from:aString

    "Created: / 06-09-2006 / 18:16:13 / cg"
!

mergeClassAttributes: attr1 with: attr2

    ^attr1 , (attr2 reject:[:each|attr1 includes: each])

    "Created: / 19-06-2010 / 10:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDefaultClassAttributesFor: aClass with: attributes

    ^self mergeClassAttributes: attributes with: (self defaultClassAttributesFor: aClass)

    "Created: / 19-06-2010 / 10:51:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

namesAndAttributesIn:aCollection do: aBlock
    aCollection isNil ifTrue:[^ self].

    aCollection do:[:entry |
        |className attributes|

        entry isArray ifFalse:[
            className := entry.
            attributes := #().
        ] ifTrue:[
            className := entry first.
            attributes := entry copyFrom:2.
        ].
        aBlock value: className value: attributes
     ].

    "Created: / 22-08-2006 / 18:20:09 / cg"
!

searchForClasses
    "answer all non-private classes that belong to this project.
     They are sorted in load order"

    ^ Class classesSortedByLoadOrder:(self searchForClassesWithProject: self package)

    "
     stx_libbasic3 searchForClasses
     stx_goodies_webServer_htmlTree searchForClasses
    "

    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Created: / 17-08-2006 / 21:18:30 / cg"
!

searchForClassesWithProject: aProjectID
    "answer all public and private classes belonging to aProjectID"

    ^ Smalltalk allClasses
        select:[:cls | cls package = aProjectID].

"
    self searchForClassesWithProject: #'exept:ctypes'
"

    "Created: / 07-08-2006 / 20:42:39 / fm"
!

searchForExtensions
    ^ self searchForExtensionsWithProject:self package

"
    self searchForExtensions
    DapasXProject searchForExtensions
    DapasX_Datenbasis searchForExtensions
    stx_libtool searchForExtensions
"

    "Modified: / 09-08-2006 / 13:01:26 / fm"
    "Created: / 17-08-2006 / 21:17:46 / cg"
    "Modified: / 23-10-2006 / 11:03:07 / cg"
!

searchForExtensionsWithProject:aProjectID
    "search for any class which has extensions from aProjectID.
     Return the extension-methods sorted by classname-selector"

    |methods|

    methods := Smalltalk allExtensionsForPackage:aProjectID.
    methods
        sort:[:m1 :m2 |
            |c1 c2|

            c1 := m1 mclass.
            c2 := m2 mclass.
            c1 == c2 ifTrue:[
                m1 selector < m2 selector
            ] ifFalse:[
                (c2 isMeta and:[c1 isMeta not]) ifTrue:[
                    true
                ] ifFalse:[
                    (c1 isMeta and:[c2 isMeta not]) ifTrue:[
                        false
                    ] ifFalse:[
                        c1 name < c2 name
"/                        (c2 isSubclassOf:c1) ifTrue:[
"/                            true
"/                        ] ifFalse:[
"/                            (c1 isSubclassOf:c2) ifTrue:[
"/                                false
"/                            ] ifFalse:[
"/                                "/ leave as is
"/                                true
"/                            ].
"/                        ].
                    ].
                ].
            ].
        ].
    ^ methods

    "
     self searchForExtensionsWithProject:#'bosch:dapasx'
     self searchForExtensionsWithProject:#'cg:oyster'
     self searchForExtensionsWithProject:#'stx:libboss'
    "

    "Created: / 17-08-2006 / 21:19:04 / cg"
    "Modified: / 12-10-2006 / 20:45:39 / cg"
!

searchForProjectsWhichProvideHeaderFiles
    |addPackage myPackageID requiredPackages|

    myPackageID := self package.
    requiredPackages := Set new.

    addPackage :=
        [:package |
            (package ~= myPackageID) ifTrue:[
                true "(package startsWith:'stx:') not" ifTrue:[
                    package ~= PackageId noProjectID ifTrue:[
                        requiredPackages add:package.
                    ]
                ]
            ]
        ].

    "/ need them also...
    self mandatoryPreRequisites do:[:eachPreRequisitePackage |
        addPackage value:eachPreRequisitePackage
    ].

    "/ cg: also need include lines for all referenced packages,
    "/ because otherwise, a reference to a symbol in a namespace
    "/ is not resolved correctly by stc (which would not know, if the
    "/ symbol is in Smalltalk or the NameSpace.
    "/ This happens eg. when referring to a class Foo in namespace N
    "/ as Foo from within the same namespace, but Foo is in another package.
    "/ It is then only in the referencedPreRequisites's, not the mandatory prereqs.
    "/ actually, the question is, if then the package should not be listed in the
    "/ mandatoryPrereqs right away. Discuss this with sv.
    self referencedPreRequisites do:[:eachPreRequisitePackage |
        addPackage value:eachPreRequisitePackage
    ].

    self compiled_classesDo:[:cls |
        cls allSuperclassesDo:[:eachSuperClass |
            addPackage value:(eachSuperClass package)
        ].

        cls allPrivateClassesDo:[:eachPrivateClass |
            eachPrivateClass allSuperclassesDo:[:eachSuperClass |
                eachSuperClass isPrivate ifFalse:[
                    addPackage value:(eachSuperClass package)
                ].
            ]
        ].

        cls sharedPoolNames do:[:eachPoolName |
            |eachPoolClass|

            eachPoolClass := Smalltalk classNamed:eachPoolName.
            eachPoolClass isNil ifTrue:[
                Transcript showCR:('Warning: missing pool: %1 (required by %2)' bindWith:eachPoolName with:cls name)
            ] ifFalse:[
                eachPoolClass withAllSuperclassesDo:[:eachPoolSuperClass |
                    addPackage value:(eachPoolSuperClass package)
                ]
            ]
        ].
    ].

    self extensionMethodNames pairWiseDo:[:className :selector |
        |cls|
        ((cls := Smalltalk classNamed:className) notNil and:[cls isLoaded]) ifTrue:[
            cls withAllSuperclassesDo:[:eachSuperClass |
                addPackage value:(eachSuperClass package)
            ]
        ]
    ].
    ^ requiredPackages

    "
     stx_libtool searchForProjectsWhichProvideHeaderFiles
     cg_demos_helloWorld searchForProjectsWhichProvideHeaderFiles
     cg_tools_emulators_freecell searchForProjectsWhichProvideHeaderFiles
    "

    "Created: / 07-12-2006 / 17:46:38 / cg"
    "Modified: / 18-01-2011 / 17:58:33 / cg"
!

searchForSiblingProjects
    "answer all the packages (package names) having the my parent package"

    |myPackage myParentPackage|

    myPackage := self package asPackageId.
    myParentPackage := myPackage parentPackage.
    myParentPackage isNil ifTrue:[^ #() ].

    ^ Smalltalk allPackageIDs
        select:[:projectID |
            |thisPackage|
            thisPackage := projectID asPackageId.
            (thisPackage parentPackage = myParentPackage)
            and:[ thisPackage ~= myPackage ].
        ]

    "
     self searchForSiblingProjects
     bosch_dapasx_Application searchForSiblingProjects
     stx_goodies_refactoryBrowser_changes searchForSiblingProjects
    "

    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Created: / 23-08-2006 / 15:06:12 / cg"
!

searchForSubProjects
    "answer all packages (package names), that are my subProjects"

    |myPackage|

    myPackage := self package.
    ^ Smalltalk allPackageIDs
        select:[:projectID |
            projectID ~= PackageId noProjectID
            and:[ (projectID asPackageId parentPackage) = myPackage ]].

    "
     self searchForSubProjects
     bosch_dapasx_Application searchForSubProjects
     stx_goodies_refactoryBrowser_changes searchForSubProjects
    "

    "Created: / 07-08-2006 / 20:42:39 / fm"
    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Modified: / 05-12-2006 / 18:04:27 / cg"
!

setupForType:typeOrNil
    typeOrNil = GUIApplicationType ifTrue:[
        self compile:
'isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ true
'
             categorized:'description'.
        self setSuperclass: ApplicationDefinition.
        ^ self
    ].

    typeOrNil = NonGUIApplicationType ifTrue:[
        self compile:
'isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ false
'
             categorized:'description'.
        self setSuperclass: ApplicationDefinition.
        ^ self
    ].

    self theMetaclass removeSelector: #isGUIApplication.
    self setSuperclass: LibraryDefinition.
    ^ self.

    "Created: / 23-08-2006 / 14:26:10 / cg"
!

shouldExcludeTest: test
    ^ self excludedFromTestSuite contains:[:spec|
            (spec isSymbol and:[test class name == spec])
            or:[spec isArray and:[test class name == spec first and:[test selector == spec second]]]
        ].

    "Created: / 03-06-2011 / 17:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verbose:aBoolean
    "enable/disable diagnostic output, which gives more detail on why package loading fails"

    Verbose := aBoolean

    "
     self verbose:true
     self verbose:false
    "
! !

!ProjectDefinition class methodsFor:'private-extension handling'!

extensionOverwriteInfo
    ^ extensionOverwriteInfo
!

fetchSlotsFrom:myFirstIncarnation
    "this is invoked in a just loaded instance of myself,
     to fetch the safe and extensionInfo from my first incarnation"

    safeForOverwrittenMethods := myFirstIncarnation safeForOverwrittenMethods.
    extensionOverwriteInfo := myFirstIncarnation extensionOverwriteInfo.
!

hasSavedOverwrittenMethods
    "true, if any of my methods was overwritten by another loaded package.
     These methods are now in my safe"

    ^ safeForOverwrittenMethods notEmptyOrNil
!

methodOverwrittenBy:anExtensionMethod
    "return the (hidden) original method, which was located in another package
     and which got overwritten by one of my extension methods. Nil if there is none."

    |mclass selector oldPackage|

    extensionOverwriteInfo isNil ifTrue:[^ nil].

    mclass := anExtensionMethod mclass.
    selector := anExtensionMethod selector.
    oldPackage := extensionOverwriteInfo at:(mclass name,'>>',selector) ifAbsent:nil.
    oldPackage isNil ifTrue:[^ nil].
    ^ oldPackage asPackageId projectDefinitionClass
        savedOverwrittenMethodForClass:mclass selector:selector.
!

rememberOverwrittenExtensionMethods
    "before loading, tell other packages to keep a safe reference to any method
     which gets overloaded by me, and also remember here, whome I have overloaded.
     This allows for two things:
        a) correct fileout of the other base-package (for example, when checking in any of its class)
        b) correct unloading of myself"

    self extensionMethodNames pairWiseDo:[:className :selector |
        |class oldMethod oldPackage defClass|

        class := Smalltalk classNamed:className.
        class notNil ifTrue:[
            oldMethod := class compiledMethodAt:selector.
        ].
        oldMethod notNil ifTrue:[
            oldPackage := oldMethod package.
            oldPackage ~= PackageId noProjectID ifTrue:[
                defClass := oldPackage asPackageId projectDefinitionClass.
                defClass notNil ifTrue:[
                    defClass rememberOverwrittenMethod:oldMethod inClass:class.
                    extensionOverwriteInfo isNil ifTrue:[
                        extensionOverwriteInfo := Dictionary new.
                    ].
                    extensionOverwriteInfo at:(className,'>>',selector) put:oldPackage.
                ]
            ].
        ].
    ].
!

rememberOverwrittenMethod:oldMethod inClass:aClass
    "invoked from another projectDefinition, when that package is about to be loaded
     and about to overwrite one of my methods.
     I will save the method locally, to allow for correct fileout of this class/project or
     to correctly reestablish my methods when the other package is unloaded later."

    |thisIsOneOfMyMethods selector|

    selector := oldMethod selector.

    thisIsOneOfMyMethods := (self classNames includes:aClass theNonMetaclass name)
                            or:[ aClass isPrivate and:[ self classNames includes: aClass topOwningClass theNonMetaclass name ]].
    thisIsOneOfMyMethods ifFalse:[
        self extensionMethodNames pairWiseDo:[:extClassName :extSelector |
            extClassName = aClass name ifTrue:[
                selector = extSelector ifTrue:[
                    thisIsOneOfMyMethods := true
                ].
            ].
        ]
    ].
    thisIsOneOfMyMethods ifFalse:[
        "/ self error:'oops - this is not one of my methods' mayProceed:true.
        Transcript showCR:self name,' [warning]:not one of my methods in rememberOverwritten'.
        ^ self
    ].

    safeForOverwrittenMethods isNil ifTrue:[
        safeForOverwrittenMethods := Dictionary new.
    ].
    safeForOverwrittenMethods at:(aClass name,'>>',selector) put:oldMethod.
!

restoreOverwrittenExtensionMethods
    "after unloading, tell other packages to restore any safed reference to any method
     which got overloaded by me.
     Unfinished!!"

    extensionOverwriteInfo notEmptyOrNil ifTrue:[
        self extensionMethodNames pairWiseDo:[:className :selector |
            |class oldMethod oldPackage|

            oldPackage := extensionOverwriteInfo at:(className,'>>',selector).
            oldPackage notNil ifTrue:[
                class := Smalltalk classNamed:className.
                class notNil ifTrue:[
                    oldMethod := oldPackage savedOverwrittenMethodForClass:class selector:selector.
                    oldMethod notNil ifTrue:[
                        self breakPoint:#cg.
                    ].
                ]
            ].
        ].
    ].
!

safeForOverwrittenMethods
    ^ safeForOverwrittenMethods
!

savedOverwrittenMethodForClass:aClass selector:aSelector
    "return one of my saved original methods"

    safeForOverwrittenMethods isNil ifTrue:[^ nil].
    ^ safeForOverwrittenMethods at:(aClass name,'>>',aSelector) ifAbsent:nil
!

savedOverwrittenMethods
    "return my saved original methods"

    ^ safeForOverwrittenMethods ? #()
! !

!ProjectDefinition class methodsFor:'private-loading'!

checkPrerequisitesForLoading
    "check if I can be loaded - i.e. if all classes to be extended are already loaded.
     Raise an error if not"

    |classesAlreadyWarned|

    classesAlreadyWarned := Set new.

    self extensionMethodNames
        pairWiseDo:[:className :selector |
            |class errMsg|

            class := Smalltalk classNamed:className.
            class isNil ifTrue:[
                (classesAlreadyWarned includes:className) ifFalse:[
                    (self classNames includes:className) ifTrue:[
                        errMsg := 'extension for a class in myself: ',className.
                    ] ifFalse:[
                        errMsg := 'missing class for extension: ',className.
                    ].
                    Logger error:errMsg.
                    self error:errMsg mayProceed:true.
                    classesAlreadyWarned add:className.
                ].
            ].
        ]

    "/ todo: more needed here...

    "
     stx_libjavascript checkPrerequisitesForLoading
    "
!

executeHooks: hookSymbol
    "Execute all hooks annotated by the given hook-symbol.
     Currently supported hooks are: #preLoad, #postLoad, #preUnload."

    | cls |

    cls := self.

    [ cls notNil ] whileTrue:[
        cls class selectorsAndMethodsDo:[:selector :method|
            (method annotationAt: hookSymbol) notNil ifTrue:[
                method numArgs == 0 ifTrue:[
                    self perform: selector
                ] ifFalse:[
                    self error:'Hook for %1 may not have arguments' mayProceed: true.
                ]
            ]
        ].
        cls := cls superclass.
    ].

    "Created: / 20-11-2012 / 23:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 16:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadAllAutoloadedClasses
    self allClasses do:[:cls | cls autoload]

    "Created: / 21-08-2011 / 17:24:13 / cg"
!

loadAllClassesAsAutoloaded:asAutoloaded
    "load (fileIn) classes that should be present -
     install as autoloaded classes marked to be autoloaded.
     If asAutoloaded == true, all classes will be installed as autoloaded, even if not marked.

     Answer true, if classes have been loaded"

    ^self loadAllClassesAsAutoloaded:asAutoloaded languages: ProgrammingLanguage all

    "Created: / 17-08-2006 / 01:01:14 / cg"
    "Modified: / 26-10-2006 / 12:30:01 / cg"
    "Modified: / 16-08-2009 / 13:31:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-06-2010 / 11:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadAllClassesAsAutoloaded:asAutoloaded languages: langs
    "load (fileIn) classes in given languages that should be present -
     install as autoloaded classes marked to be autoloaded.
     If asAutoloaded == true, all classes will be installed as autoloaded, even if not marked.
     langs should be collection of ProgrammingLanguage available in the system.

     Answer true, if classes have been loaded"

    |classNamesToLoad classNamesToAutoload classNamesToLangs hasClassesToLoad loadedClasses platformName
     classesWhichFailedToLoad|

    platformName := OperatingSystem platformName.
    classNamesToLoad := OrderedCollection new.
    classNamesToAutoload := OrderedCollection new.
    classNamesToLangs := Dictionary new.

    hasClassesToLoad := false.
    self classNamesAndAttributesDo:[:eachClassname :eachAttributes |
        |eachClassnameSym isAutoload clsLangAttr clsLang cls |

        eachClassnameSym := eachClassname asSymbol.
        isAutoload := asAutoloaded or:[eachAttributes includes:#autoload].
        clsLangAttr := eachAttributes detect:[:a| a isArray and: [a size == 2 and:[a first == #lang]]] ifNone:[nil].
        clsLang := clsLangAttr
                    ifNil:[SmalltalkLanguage instance]
                    ifNotNil:[ProgrammingLanguage named: clsLangAttr second ifNone:[nil]].
        classNamesToLangs at: eachClassname put: clsLang.

        "no need to (re-)load an existing class, but install if should be loaded"
        cls := Smalltalk loadedClassNamed:eachClassnameSym.
        ((cls isNil or:[cls isLoaded not and:[isAutoload not]]) and:[clsLang notNil and:[langs includes: clsLang]]) ifTrue:[
            (eachAttributes isEmpty
             or:[(eachAttributes size == 1 and:[isAutoload])
             or:[(eachAttributes includes:platformName)
             or:[eachAttributes contains:[:a| a isArray]]]]) "/FIXME: Hack."
                ifTrue:[
                    hasClassesToLoad := true.
                    isAutoload ifTrue:[
                        classNamesToAutoload add:eachClassnameSym.
                    ] ifFalse:[
                        classNamesToLoad add:eachClassnameSym.
                    ].
                ].
        ].
    ].

    hasClassesToLoad ifTrue:[
        loadedClasses := OrderedCollection new.

        self packageDirectory isNil ifTrue:[
            classNamesToLoad notEmpty ifTrue:[
                "required classes are missing.
                 Autoloaded classes are considered as optional..."
                self
                    error:(self name,'[error] cannot install because packageDirectory is unknown for missing classes: ', classNamesToLoad printString)
                    mayProceed:true.
                ^ false.
            ].
            (self name,'[info] cannot install autoloaded classes because packageDirectory is unknown') infoPrintCR.
            ^ true.
        ].

        "we need the abbreviations, since sometimes there is no 1-to-1 mapping
         of class name to file name"

        Smalltalk recursiveReadAllAbbreviationsFrom:self packageDirectory maxLevels:1.

        "install autoloaded classes first,
         some others may depend on them"

        classNamesToAutoload withIndexDo:[:eachClassName :index|
            ActivityNotification
                raiseRequestWith: ((100 / classNamesToAutoload size ) * index) rounded
                errorString: 'Autoloading class ', eachClassName.

            self loadClass: eachClassName asAutoloaded: true language: (classNamesToLangs at: eachClassName) .
        ].

        classesWhichFailedToLoad := OrderedCollection new.
        classNamesToLoad notEmpty ifTrue:[
            Verbose ifTrue:[
                Transcript showCR:('  %1: filing in missing classes (%2) individually...'
                                    bindWith:self name with:classNamesToLoad size).
            ]
        ].
        classNamesToLoad withIndexDo:[:eachClassName :index|
            |cls|
            ActivityNotification
                raiseRequestWith: ((100 / classNamesToLoad size) * index) rounded
                errorString: 'Loading class ', eachClassName.

            Error handle:[:ex |
                "maybe, fileIn failed, because the load order is wrong.
                 Work around this by installing the class as autoloaded and
                 loading it"

                classesWhichFailedToLoad add:eachClassName.
                self loadClass: eachClassName asAutoloaded: true language: (classNamesToLangs at: eachClassName).
            ] do:[
                Verbose ifTrue:[
                    Transcript showCR:('  %1: filing in %2...' bindWith:self name with:eachClassName).
                ].
                cls := self loadClass: eachClassName asAutoloaded: false language: (classNamesToLangs at: eachClassName).
                cls notNil ifTrue:[
                    loadedClasses add:cls
                ].
            ].
        ].

        classesWhichFailedToLoad do:[:eachClassName |
            (Smalltalk at:eachClassName) autoload.
        ].

        loadedClasses do:[:eachLoadedClass |
            "do not initialize, if initialize method is inherited"
            (eachLoadedClass theMetaclass includesSelector:#initialize) ifTrue:[
                eachLoadedClass initialize
            ].
        ].
        ^ true.
    ].
    ^ false.

    "Modified: / 26-10-2006 / 12:30:01 / cg"
    "Modified: / 16-08-2009 / 13:31:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 19-06-2010 / 11:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-06-2010 / 15:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadClass: className asAutoloaded: asAutoloaded language: lang
    | packageDir classFile entry category numClassInstVars cls|

    "Handle smalltalk classes specially to provide backward compatibility"
    lang isSmalltalk ifTrue:[
        entry := self abbrevs at: className ifAbsent:[nil].

        asAutoloaded ifTrue:[
            category := entry isNil ifTrue:[#autoloaded] ifFalse:[entry category].
            numClassInstVars := entry isNil ifTrue:[0] ifFalse:[entry numClassInstVars].
            cls := Smalltalk
                installAutoloadedClassNamed: className
                category: category
                package: self package
                revision: nil
                numClassInstVars:numClassInstVars.
            entry notNil ifTrue:[
                cls setClassFilename:(entry fileName,'.st').
            ].
            ^ cls.
        ].
        ^ Smalltalk
            fileInClass:className
            package:self package
            initialize:false
            lazy:false
            silent:true
    ].

    "For non-smalltalk language do"
    asAutoloaded ifTrue:[^self error:'Only Smalltalk classes may be autoloaded (yet)'].

    packageDir := self packageDirectory asFilename.
    classFile := packageDir / ((Smalltalk fileNameForClass: className) , '.' , lang sourceFileSuffix).
    classFile exists ifFalse:[^nil].
    lang fileIn: classFile.
    ^nil "FIXME: should return the class"

    "Created: / 19-06-2010 / 09:11:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2011 / 18:29:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-08-2011 / 14:22:15 / cg"
!

loadClassLibrary
    "try to load a binary class library
     Return true if ok, raise an exception if not."

    |libraryName|

    self supportedOnPlatform ifFalse:[^ false].

    libraryName := self libraryName.

    (Smalltalk isClassLibraryLoaded:libraryName) ifTrue:[
        "already loaded"
        ^ true
    ].
    Verbose ifTrue:[
        Transcript showCR:('  %1: loading classLibrary...' bindWith:self name).
    ].
    self activityNotification:'Loading classLibrary'.

    ^ Smalltalk fileInClassLibrary:libraryName inPackage:self package.
!

loadExtensions
    "load extension methods - do not load if they are already present"

    self supportedOnPlatform ifFalse:[^ false].
    self hasAllExtensionsLoaded ifFalse:[
        self breakPoint:#cg.
        Verbose ifTrue:[
            Transcript showCR:('  %1: filing in extensions...' bindWith:self name).
        ].
        Smalltalk loadExtensionsForPackage:self package.
        ^ true.
    ].
    ^ false.

    "Created: / 17-08-2006 / 00:21:39 / cg"
!

loadExtensionsForLanguage: lang
    "load extension methods for given programming language"

    | filename file |

    self supportedOnPlatform ifFalse:[^ self].

    filename := 'extensions.' , lang sourceFileSuffix.
    file := self packageDirectory / filename.
    file exists ifTrue:[
        lang fileIn: file.
    ]

    "Created: / 17-08-2006 / 00:21:39 / cg"
    "Created: / 25-11-2011 / 18:13:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadMandatoryPreRequisitesAsAutoloaded:asAutoloaded
    "load those packages which are required for loading.
     Called after my definition has been loaded, but before the rest of the
     package is."

    |prereq|

    self supportedOnPlatform ifFalse:[^ self].

    prereq := self mandatoryPreRequisites.
    prereq notEmpty ifTrue:[
        Verbose ifTrue:[
            Transcript showCR:('  %1 loading mandatory prerequisites...' bindWith:self name).
        ].
        self loadPackages:prereq asAutoloaded:asAutoloaded
    ].
!

loadPackages:aListOfPackages asAutoloaded:asAutoloaded
    "load some packages (at least the projectDefinitions and their extensions).
     If asAutoloaded == true, classes will be only installed as autoloaded."

    Class withoutUpdatingChangesDo:[
        aListOfPackages do:[:eachPackageID |
            |cls|

            cls := self definitionClassForPackage:eachPackageID.
            (cls isNil or:[cls isLoaded not or:[cls projectIsLoaded not]]) ifTrue:[
                Smalltalk loadPackage:eachPackageID asAutoloaded:asAutoloaded.
            ].
        ].
    ].

    "Modified: / 09-12-2010 / 12:36:17 / cg"
!

loadPreRequisitesAsAutoloaded:asAutoloaded
    "load other packages (at least the projectDefinitions and their extensions)"

    |prereq|

    prereq := self effectivePreRequisites.
    prereq notEmpty ifTrue:[
        Verbose ifTrue:[
            Transcript showCR:('  %1 loading prerequisites...' bindWith:self name).
        ].
        self loadPackages:prereq asAutoloaded:asAutoloaded
    ].
!

loadSubProjects
    "load other packages (at least the projectDefinitions and their extensions)"

    self loadSubProjectsAsAutoloaded:false.
    self effectiveSubProjects do:[:p |
        |subDef|

        subDef := self definitionClassForPackage:p.
        subDef notNil ifTrue:[
            subDef loadSubProjects
        ].
    ].
!

loadSubProjectsAsAutoloaded:asAutoloaded
    "load other packages (at least the projectDefinitions and their extensions)"

    self loadPackages:(self effectiveSubProjects) asAutoloaded:asAutoloaded

    "Modified: / 25-10-2006 / 17:51:58 / cg"
!

old_loadAllClassesAsAutoloaded:asAutoloaded
    "load (fileIn) classes that should be present -
     install as autoloaded classes marked to be autoloaded.
     If asAutoloaded == true, all classes will be installed as autoloaded, even if not marked.

     Answer true, if classes have been loaded"

    |classNamesToLoad classNamesToAutoload hasClassesToLoad loadedClasses platformName
     classesWhichFailedToLoad|

    platformName := OperatingSystem platformName.
    classNamesToLoad := OrderedCollection new.
    classNamesToAutoload := OrderedCollection new.

    hasClassesToLoad := false.
    self classNamesAndAttributesDo:[:eachClassname :eachAttributes |
        |eachClassnameSym isAutoload cls|

        eachClassnameSym := eachClassname asSymbol.
        isAutoload := asAutoloaded or:[eachAttributes includes:#autoload].

        "no need to (re-)load an existing class, but install if should be loaded"
        cls := Smalltalk loadedClassNamed:eachClassnameSym.
        (cls isNil or:[cls isLoaded not and:[isAutoload not]]) ifTrue:[
            (eachAttributes isEmpty
             or:[(eachAttributes size == 1 and:[isAutoload])
             or:[eachAttributes includes:platformName]]) ifTrue:[
                hasClassesToLoad := true.
                isAutoload ifTrue:[
                    classNamesToAutoload add:eachClassnameSym.
                ] ifFalse:[
                    classNamesToLoad add:eachClassnameSym.
                ].
            ].
        ].
    ].

    hasClassesToLoad ifTrue:[
        loadedClasses := OrderedCollection new.

        self packageDirectory isNil ifTrue:[
            self
                error:(self name,'[error] cannot install because packageDirectory is unknown')
                mayProceed:true.
            ^ false.
        ].

        "we need the abbreviations, since sometimes there is no 1-to-1 mapping
         of class name to file name"

        Smalltalk recursiveReadAllAbbreviationsFrom:self packageDirectory maxLevels:1.

        "install autoloaded classes first,
         some others may depend on them"

        classNamesToAutoload withIndexDo:[:eachClassName :index|
            ActivityNotification
                raiseRequestWith: ((100 / classNamesToAutoload size ) * index) rounded
                errorString: 'Autoloading class ', eachClassName.

            Smalltalk
                installAutoloadedClassNamed:eachClassName
                category:#autoloaded    "FIXME"
                package:self package
                revision:nil
                numClassInstVars:0.     "FIXME"
        ].

        classesWhichFailedToLoad := OrderedCollection new.
        classNamesToLoad notEmpty ifTrue:[
            Verbose ifTrue:[
                Transcript showCR:('  %1: filing in missing classes (%2) individually...'
                                    bindWith:self name with:classNamesToLoad size).
            ]
        ].
        classNamesToLoad withIndexDo:[:eachClassName :index|
            |cls|
            ActivityNotification
                raiseRequestWith: ((100 / classNamesToLoad size) * index) rounded
                errorString: 'Loading class ', eachClassName.

            Error handle:[:ex |
                "maybe, fileIn failed, because the load order is wrong.
                 Work around this by installing the class as autoloaded and
                 loading it"

                classesWhichFailedToLoad add:eachClassName.
                Smalltalk
                    installAutoloadedClassNamed:eachClassName
                    category:#autoloaded    "FIXME"
                    package:self package
                    revision:nil
                    numClassInstVars:0.     "FIXME"
            ] do:[
                Verbose ifTrue:[
                    Transcript showCR:('  %1: filing in %2...' bindWith:self name with:eachClassName).
                ].
                cls := Smalltalk
                            fileInClass:eachClassName
                            package:self package
                            initialize:false
                            lazy:false
                            silent:true.
                cls notNil ifTrue:[
                    loadedClasses add:cls
                ].
            ].
        ].

        classesWhichFailedToLoad do:[:eachClassName |
            (Smalltalk at:eachClassName) autoload.
        ].

        loadedClasses do:[:eachLoadedClass |
            "do not initialize, if initialize method is inherited"
            (eachLoadedClass theMetaclass includesSelector:#initialize) ifTrue:[
                eachLoadedClass initialize
            ].
        ].
        ^ true.
    ].
    ^ false.

    "Modified: / 26-10-2006 / 12:30:01 / cg"
    "Modified: / 16-08-2009 / 13:31:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 19-06-2010 / 11:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unloadAllClasses
    Logger warning:'unloading not yet fully supported'
!

unloadClassLibrary
    Logger warning:'unloading not yet fully supported'
!

unloadSubProjects
    "unload other packages"

    self effectiveSubProjects do:[:p |
        |subDef|

        subDef := self definitionClassForPackage:p.
        subDef notNil ifTrue:[
            subDef unloadSubProjects.
            subDef unloadPackage.
        ].
    ].
!

update:anAspectSymbol with:argument from:changedObject
    "when any of my class methods is changed, we mark the project as unloaded.
     May be some more classes have to be loaded"

    (changedObject == self class and:[anAspectSymbol == #methodDictionary]) ifTrue:[
        self projectIsLoaded:false.
    ]
! !

!ProjectDefinition class methodsFor:'private-prerequisites'!

addReferencesToClassesFromGlobalsIn:aSetOfClasses to:usedClassReasons
    "helper for searchForPreRequisites"

    aSetOfClasses
        do:[:aClass |
            self
                addReferencesToClassesFromGlobalsInMethods:
                    (aClass theNonMetaclass methodDictionary values
                        reject:[:m | m isExtension])
                to:usedClassReasons.

            self
                addReferencesToClassesFromGlobalsInMethods:
                    (aClass theMetaclass methodDictionary values
                        reject:[:m | m isExtension])
                to:usedClassReasons.
        ].

    "Modified: / 10-10-2006 / 23:03:45 / cg"
!

addReferencesToClassesFromGlobalsInMethods:someMethods to:usedClassReasons
    "helper for searchForPreRequisites"

    someMethods do:[:method |
        |resources|

        resources := method resources.
        (resources isNil
        or:[ ((resources includesKey:#'ignoreInPrerequisites') not
              and:[(resources includesKey:#'example') not])])
        ifTrue:[
            method usedGlobals
                do:[:global |
                    |globalsName usedClass|

                    globalsName := global asSymbol.
                    usedClass := Smalltalk at:globalsName.
                    (usedClass notNil and:[usedClass isClass and:[usedClass isNameSpace not]]) ifTrue:[
                        usedClass name == globalsName ifTrue:[ "/ skip aliases
                            (usedClassReasons at:usedClass ifAbsentPut:[Set new])
                                add:(usedClass name, ' - referenced by ', method mclass name,'>>',method selector)
                        ]
                    ]
                ]
            ]
    ]

    "Created: / 10-10-2006 / 23:00:07 / cg"
    "Modified: / 30-05-2007 / 12:48:30 / cg"
!

addReferencesToExtensionMethodsIn:someClasses to:usedMethodReasons
    "helper for searchForPreRequisites: search for sends of a selector which
     is defined in an extension method (in the set of passed-in methods).
     If found, add the extension method and a reason string to usedReasons.
     This should find especially sends to extension methods from libcompat."

    |allRealExtensions|

    "/ only care for methods which are not already implemented in an extension methods's superclass
    allRealExtensions := Smalltalk allExtensions
                            select:[:mthd |
                                |superClass|
                                superClass := mthd mclass superclass.
                                (superClass isNil or:[superClass whichClassIncludesSelector:mthd selector]) isNil
                            ].

    someClasses do:[:eachClass |
        eachClass instAndClassMethodsDo:[:method |
            |resources extensionsSent|

            resources := method resources.
            (resources isNil
            or:[ ((resources includesKey:#'ignoreInPrerequisites') not
                  and:[(resources includesKey:#'example') not])])
            ifTrue:[
                extensionsSent := allRealExtensions select:[:ext | method messagesSent includes:ext selector].
                extensionsSent do:[:eachExtensionMethod |
                    (usedMethodReasons at:eachExtensionMethod ifAbsentPut:[Set new])
                        add:(eachExtensionMethod selector, ' - sent by ', method mclass name,'>>',method selector)
                ]
            ]
        ]
    ]
!

allMandatoryPreRequisites
    "answer all (recursive) mandatory prerequisite project ids of myself - in random order."

    ^ self allPreRequisites:#effectiveMandatoryPreRequisites.

    "
     stx_libbasic allMandatoryPreRequisites 
     stx_libbasic2 allMandatoryPreRequisites
     stx_libview2 allMandatoryPreRequisites 
     stx_libcomp allMandatoryPreRequisites  
    "

    "Created: / 06-06-2016 / 12:19:39 / cg"
!

allMandatoryPreRequisitesSorted
    [
        ^ self allPreRequisitesSorted:#effectiveMandatoryPreRequisites
    ] on:Error do:[:ex |
        (self confirm:(self name,' [warning]: cycle in prerequisites:' ,, Character cr, '    ', (ex parameter printStringWithSeparator:' -> ') ,, Character cr,  'Proceed with incomplete (mandatory) prerequites?'))
        ifFalse:[
            AbortOperationRequest raise
        ].
        ^ self allPreRequisitesSorted:#mandatoryPreRequisites
    ].

    "Created: / 06-06-2016 / 12:20:40 / cg"
!

allPreRequisites
    "answer all (recursive) prerequisite project ids of myself - in random order."

    ^ self allPreRequisites:#effectivePreRequisites.

    "
     stx_libbasic allPreRequisites
     stx_libbasic2 allPreRequisites
     stx_libview2 allPreRequisites
     ubs_application allPreRequisites
     ubs_application allPreRequisitesSorted
     exept_expecco_application allPreRequisites
     exept_expeccoNET_application allPreRequisites
     alspa_batch_application allPreRequisites"
    "Modified: / 13-04-2011 / 15:30:45 / sr"
    "Modified (comment): / 06-09-2011 / 08:26:06 / cg"
!

allPreRequisites:aSelector
    "answer all (recursive) prerequisite project ids of myself - in random order."

    |result|

    result := self
        allPreRequisites:aSelector withParentDo:[:parent :prereq |
            prereq = self package ifTrue:[
                Transcript showCR:('oops: %1 depends on itself' bindWith:prereq)
            ].
        ].
    result remove:self package ifAbsent:[].
    ^ result.

    "
     stx_libbasic allPreRequisites
     stx_libbasic2 allPreRequisites
     stx_libview2 allPreRequisites
     ubs_application allPreRequisites
     ubs_application allPreRequisitesSorted
     exept_expecco_application allPreRequisites
     exept_expeccoNET_application allPreRequisites
     alspa_batch_application allPreRequisites"
    "Modified: / 13-04-2011 / 15:30:45 / sr"
    "Modified (comment): / 06-09-2011 / 08:26:06 / cg"
!

allPreRequisites:aSelector withParentDo:aBlock
    "answer all (recursive) prerequisite project ids of myself - in random order.
     If we exclude a project, but one of our prerequisite projects depends on it,
     then what ????"

    |setOfAllPreRequisites toAdd|

    setOfAllPreRequisites := Set new.
    toAdd := Set withAll:(self perform:aSelector).

    "is a subproject really a prerequisite??
     No, it works the other way: parent projects are prerequisites of sub projects,
     so the following line has been deleted.
     Unfortunately the meaning of 'subproject' has never been well defined. SV."
"/    toAdd addAll:self effectiveSubProjects.

    [toAdd notEmpty] whileTrue:[
        |aPreRequisiteProjectID def|

        aPreRequisiteProjectID := toAdd removeFirst.
        (setOfAllPreRequisites includes:aPreRequisiteProjectID) ifFalse:[
            setOfAllPreRequisites add:aPreRequisiteProjectID.

            def := self definitionClassForPackage:aPreRequisiteProjectID.
            def isNil ifTrue:[
                Transcript showCR:'ProjectDefinition ', aPreRequisiteProjectID, ' is missing - cannot find its preRequisites.'.
            ] ifFalse:[
                (def perform:aSelector)
                    select:[:eachSubPreRequisite | (setOfAllPreRequisites includes:eachSubPreRequisite) not]
                    thenDo:[:eachSubPreRequisite |
                                Verbose == true ifTrue:[
                                    Transcript show:'ProjectDefinition preRequisites: '; showCR:(aPreRequisiteProjectID, ' requires ', eachSubPreRequisite).
                                ].
                                aBlock value:def value:eachSubPreRequisite.
                                toAdd add:eachSubPreRequisite
                           ].

                "but subprojects of our prerequisites are also prerequisites"
"/ SV: - I don't think so. Either we need them, because they have classes being superclasses
"/ or referenced. Or we include the explicitly. In both cases we do not need this code.
"/ But we do not want them only because there is a subProject with examples or tests!!

"/                def effectiveSubProjects
"/                    select:[:eachSubSubRequisite | eachSubSubRequisite ~= self package and:[ (setOfAllPreRequisites includes:eachSubSubRequisite) not ]]
"/                    thenDo:[:eachSubSubRequisite |
"/                                Verbose == true ifTrue:[
"/                                    Transcript show:'ProjectDefinition preRequisites: '; showCR:(aPreRequisiteProjectID, ' hasSub ', eachSubSubRequisite).
"/                                ].
"/                                aBlock value:def value:eachSubSubRequisite.
"/                                toAdd add:eachSubSubRequisite
"/                           ].
            ].
        ]
    ].
    ^ setOfAllPreRequisites.

    "
     stx_libbasic allPreRequisites
     stx_libbasic2 allPreRequisites
     stx_libview2 allPreRequisites
     ubs_application allPreRequisites
     ubs_application allPreRequisitesSorted
     exept_expecco_application allPreRequisites
     exept_expeccoNET_application allPreRequisites
     alspa_batch_application allPreRequisites
    "

    "Created: / 13-04-2011 / 15:23:21 / sr"
    "Modified: / 20-07-2012 / 18:29:31 / cg"
!

allPreRequisitesSorted
    [
        ^ self allPreRequisitesSorted:#effectivePreRequisites
    ] on:Error do:[:ex |
        (self confirm:(self name,' [warning]: cycle in prerequisites:' ,, Character cr, '    ', (ex parameter printStringWithSeparator:' -> ') ,, Character cr,  'Proceed with incomplete (mandatory) prerequites?'))
        ifFalse:[
            AbortOperationRequest raise
        ].
        ^ self allPreRequisitesSorted:#mandatoryPreRequisites
    ].
!

allPreRequisitesSorted:aSelector
    "answer all the prerequisites of this projects sorted in
     the order they are needed.
     Use this to e.g. compile packages in the dependency order"

    |allPreRequisites orderedTuples sortedPackages|

    orderedTuples := OrderedCollection new.
    allPreRequisites := self allPreRequisites:aSelector.
    allPreRequisites := allPreRequisites collect:[ :e | e asString ].

    "/JV@2013-03-13: Added asSortedCollection to make the order of packages
    "/as stable as possible. Makes merging of makefiles a lot easier.
    allPreRequisites asSortedCollection do:[:eachPackageID |
        |def preRequisites|

        self assert:(eachPackageID ~= self package).
        orderedTuples add:(Array with:eachPackageID with:self package).

        def := self definitionClassForPackage:eachPackageID.
        def isNil ifTrue:[
            Transcript showCR:'Warning: no definition class for package: ', eachPackageID.
            ((self searchForPreRequisites: eachPackageID)
                fold:[:d1 :d2| d1 addAll:d2; yourself]) keys
        ] ifFalse:[
            preRequisites := def perform:aSelector.
            preRequisites := preRequisites copyWithoutAll:def excludedFromPreRequisites.
            preRequisites do:[:eachPrerequisitePackageID|
                self assert:(eachPrerequisitePackageID ~= eachPackageID).
                orderedTuples add:(Array with:eachPrerequisitePackageID with:eachPackageID).
            ].
        ].
    ].

    (orderedTuples contains:[:el | el first = el second]) ifTrue:[
        self halt:'something seems to depend upon itself'
    ].
    sortedPackages := orderedTuples topologicalSortStable: true.

    "packages which only result from extension methods are used for computing the sort order,
     but they are not added, if not present in the first place"
    ^ sortedPackages select:[:eachProject| allPreRequisites includes:eachProject]

    "
     stx_libbasic allPreRequisitesSorted
     stx_libbasic2 allPreRequisitesSorted
     stx_libwidg2 allPreRequisitesSorted
     exept_expecco allPreRequisitesSorted
     alspa_batch_application allPreRequisitesSorted
     ubs_application allPreRequisitesSorted
    "

    "Modified: / 13-04-2011 / 15:19:13 / sr"
    "Modified: / 05-06-2014 / 12:22:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allPreRequisitesWithMandatorySorted
    "a list of all prerequisites (mandatory and non-mandatory,
     with the mandatory ones coming first and being sorted by dependency"

    |pre mandatory|

    mandatory := self allMandatoryPreRequisitesSorted.
    pre := OrderedSet withAll:mandatory.
    self allPreRequisites do:[:each |
        (mandatory includes:each) ifFalse:[ pre add: each ]
    ].
    ^ pre

    "Created: / 06-06-2016 / 14:30:25 / cg"
!

allReferences
    "answer all (recursive) projects to which I refer - in random order."

    |result|

    result := self
        allPreRequisites:#referencedPreRequisites withParentDo:[:parent :prereq |
            prereq = self package ifTrue:[
                Transcript showCR:('oops: %1 depends on itself' bindWith:prereq)
            ].
        ].
    result remove:self package ifAbsent:[].
    ^ result.

    "
     stx_libbasic allReferences
     stx_libbasic2 allReferences
     stx_libview2 allReferences
     ubs_application allReferences
     ubs_application allReferences
     exept_expecco_application allReferences
     exept_expeccoNET_application allReferences
     alspa_batch_application allReferences
    "
!

effectiveMandatoryPreRequisites
    "get the preRequisites, that are not excluded, which are needed for loading
     and compiling (i.e. which must be present BEFORE)"

    self mandatoryPreRequisites notEmpty ifTrue:[
        "this is a new subclass - avoid overhead"
        ^ OrderedSet new
            addAll:self mandatoryPreRequisites;
            "/ addAll:self includedInPreRequisites;
            removeAllFoundIn:self excludedFromMandatoryPreRequisites;
            removeAllFoundIn:self excludedFromPreRequisites;
            yourself.
    ].

    "I am an old subclass, where #preRequisites returns a plain array"
    ^ Set new
        addAll:self preRequisites;
        addAll:self includedInPreRequisites;
        removeAllFoundIn:self excludedFromMandatoryPreRequisites;
        removeAllFoundIn:self excludedFromPreRequisites;
        remove:self package ifAbsent:[];
        yourself.
!

effectivePreRequisites
    "get the preRequisites, that are not excluded.
     This method appears to be obsolete, because its functionality
     is now included in #preRequisites.
     But is to be kept for backward compatibilty with old existing subclasses."

    self mandatoryPreRequisites notEmpty ifTrue:[
        "this is a new subclass - avoid overhead"
        ^ self preRequisites.
    ].

    "I am an old subclass, where #preRequisites returns a plain array"
    ^ Set new
        addAll:self preRequisites;
        addAll:self includedInPreRequisites;
        removeAllFoundIn:self excludedFromPreRequisites;
        remove:self package ifAbsent:[];
        yourself.
!

searchForPreRequisites
    "answer a Dictionary where the keys are the prerequisite package for this package
     and the values are a Set of reasons, why each package is required"

    ^ self searchForPreRequisites:self package

    "
     self searchForPreRequisites
     stx_libbasic3 searchForPreRequisites
     bosch_dapasx_Application searchForPreRequisites
     bosch_dapasx_pav_browser searchForPreRequisites
    "

    "Created: / 07-08-2006 / 20:42:39 / fm"
    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Modified: / 06-09-2011 / 08:30:43 / cg"
!

searchForPreRequisites: packageId
    "answer an array containing two Dictionaries where the keys are the prerequisite package for the given package
     and the values are a Set of reasons, why each key package is required.
     The first entry in the array are the mandatory prereqs (required for compilation),
     the second entry are the referenced prereqs (required for loading).
     Referenced prereqs are due to elements accessed at execution time (such as globals)"

    ^ self searchForPreRequisites: packageId withSubProjects:false

    "
     self searchForPreRequisites
     self searchForPreRequisites:#'stx:libwidg3'
     self searchForPreRequisites:#'stx:libtool'
     bosch_dapasx_Application searchForPreRequisites
     bosch_dapasx_pav_browser searchForPreRequisites
    "

    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Created: / 17-11-2010 / 18:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2011 / 08:30:20 / cg"
!

searchForPreRequisites:packageId withSubProjects:withSubProjectsBoolean
    "answer an array containing two Dictionaries where the keys are the prerequisite package for the given package
     and the values are a Set of reasons, why each key package is required.
     The first entry in the array are the mandatory prereqs (required for compilation),
     the second entry are the referenced prereqs (required for loading).
     Referenced prereqs are due to elements accessed at execution time (such as globals)"

    |requiredClasses mandatoryClassesForLoadingWithReasons referencedClassesWithReasons
     ignoredPackages packageExtractionBlock mandatoryPackageReasons referencedPackageReasons referencedMethodsWithReasons|

    mandatoryClassesForLoadingWithReasons := Dictionary new.
    referencedClassesWithReasons := Dictionary new.
    referencedMethodsWithReasons := Dictionary new.

    "my classes are required"
    requiredClasses := self searchForClassesWithProject: packageId.

    withSubProjectsBoolean ifTrue:[
        "my subproject's classes are required"
        self effectiveSubProjects do:[:eachProjectName |
            requiredClasses addAll:(self searchForClassesWithProject:eachProjectName asSymbol)
        ].
    ].

    "/ ...but not if they're a Java class
    requiredClasses := requiredClasses reject:[:each | each isJavaClass ].


    "all superclasses of my classes
     and my subProject's classes (if required) are mandatory.
     All shared pools used by my classes are required as well"
    requiredClasses do:[:cls |
        (self isAutoloaded: cls) ifFalse:[
            cls allSuperclassesDo:[:eachSuperclass |
                (mandatoryClassesForLoadingWithReasons at: eachSuperclass ifAbsentPut:[OrderedSet new])
                    add: (eachSuperclass name, ' - superclass of ', cls name).
            ].
        ] ifTrue:[ 
            cls allSuperclassesDo:[:eachSuperclass |
                (referencedClassesWithReasons at: eachSuperclass ifAbsentPut:[OrderedSet new])
                    add: (eachSuperclass name, ' - superclass of ', cls name).
            ].
        ].
        cls sharedPools do:[:eachSharedPool |
            (mandatoryClassesForLoadingWithReasons at: eachSharedPool ifAbsentPut:[OrderedSet new])
                add: (eachSharedPool name, ' - shared pool used by ', cls name).
            eachSharedPool allSuperclassesDo:[:eachSuperclass |
                (mandatoryClassesForLoadingWithReasons at: eachSuperclass ifAbsentPut:[OrderedSet new])
                    add: (eachSuperclass name, ' - superclass of shared pool ', eachSharedPool name).
            ]
        ]
    ].
    "all classes for which I define extensions are mandatory"
    self allExtensionClasses do:[:eachExtendedClass |
        (mandatoryClassesForLoadingWithReasons at:eachExtendedClass ifAbsentPut:[OrderedSet new])
            add: (eachExtendedClass name, ' - extended').
        eachExtendedClass allSuperclassesDo:[:eachSuperclass |
            (mandatoryClassesForLoadingWithReasons at: eachSuperclass ifAbsentPut:[OrderedSet new])
                add: (eachSuperclass name, ' - superclass of extended ', eachExtendedClass name).
        ]
    ].

    "all classes referenced by my classes or my subproject's classes
     are required. But:
         only search for locals refered to by my methods (assuming that superclasses'
         prerequisites are specified in their package)."

    self addReferencesToClassesFromGlobalsIn:requiredClasses to:referencedClassesWithReasons.
    self addReferencesToClassesFromGlobalsInMethods:(self searchForExtensionsWithProject:self package) to:referencedClassesWithReasons.
    self addReferencesToExtensionMethodsIn:requiredClasses to:referencedMethodsWithReasons.

    "now map classes to packages and collect the reasons"
    packageExtractionBlock :=
        [:classesWithReasons|
            |requiredPackageReasons|
            requiredPackageReasons := Dictionary new.
            classesWithReasons keysAndValuesDo:[:usedClass :reasonsPerClass|
                (requiredPackageReasons at:usedClass package ifAbsentPut:[Set new])
                                addAll:reasonsPerClass.
            ].
            "sort, to avoid differences from one generation to the next one"
            requiredPackageReasons
        ].

    mandatoryPackageReasons := packageExtractionBlock value:mandatoryClassesForLoadingWithReasons.

    referencedPackageReasons := packageExtractionBlock value:referencedClassesWithReasons.

    "and map extension method invocations to packages and collect the reasons"
    referencedMethodsWithReasons keysAndValuesDo:[:usedMethod :reasonsPerMethod |
        (referencedPackageReasons at:usedMethod package ifAbsentPut:[Set new])
            addAll:reasonsPerMethod.
    ].

    ignoredPackages := Set
        with:packageId
        with:PackageId noProjectID.

    referencedPackageReasons removeAllKeys:ignoredPackages ifAbsent:[].
    "sort, to avoid differences from one generation to the next one"
    referencedPackageReasons keysAndValuesDo:[:eachPackageId :eachReasons | referencedPackageReasons at:eachPackageId put:eachReasons asSortedCollection].

    "don't put classes from subProjects into the required list"
    ignoredPackages addAll:(self siblingsAreSubProjects
                                ifTrue:[ self searchForSiblingProjects ]
                                ifFalse:[ self searchForSubProjects ]) asSet.

    mandatoryPackageReasons removeAllKeys:ignoredPackages ifAbsent:[].
    "sort, to avoid differences from one generation to the next one"
    mandatoryPackageReasons keysAndValuesDo:[:eachPackageId :eachReasons | mandatoryPackageReasons at:eachPackageId put:eachReasons asSortedCollection].

    ^ Array
        with:mandatoryPackageReasons
        with:referencedPackageReasons.

    "
     self searchForPreRequisites:#'stx:libwidg3'
     bosch_dapasx_Application searchForPreRequisites
     bosch_dapasx_pav_browser searchForPreRequisites
     self searchForPreRequisites:#'stx:goodies/json' withSubProjects:false
    "

    "Modified: / 07-08-2006 / 21:56:25 / fm"
    "Created: / 17-11-2010 / 18:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 06-09-2011 / 08:29:37 / cg"
    "Modified: / 25-09-2015 / 11:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'queries'!

allClassNames
    ^ self classNamesForWhich:[:nm :attr | true ].
!

allClasses
    ^ self allClassNames
        collect:[:nm |
            |cls|

            cls := Smalltalk classNamed:nm.
            cls isNil ifTrue:[
                Logger warning:'%1: failed to autoload class %2' with:self name with:nm
            ].
            cls
        ]
        thenSelect:[:cls | cls notNil ].

    "Created: / 06-08-2011 / 15:47:36 / cg"
!

allExtensionClasses
    "answer the set of classes, which are extended by the package.
     includes all superclasses of the extended classes"

    ^ self extensionClassesWithSuperclasses:true

    "
     stx_libboss allExtensionClasses
    "

    "Created: / 06-09-2011 / 10:15:54 / cg"
!

autoloaded_classNames
    "the opposite of compiled class names"

    ^ self classNamesForWhich:[:nm :attr | attr notEmptyOrNil and:[attr includes:#autoload]].

    "Modified: / 07-08-2006 / 21:25:25 / fm"
    "Created: / 30-08-2007 / 18:48:09 / cg"
!

canHaveExtensions
    "return true, if this class allows extensions from other packages.
     Private classes, namespaces and projectDefinitions don't allow this"

    ^ self isAbstract

    "
     Smalltalk allClasses select:[:each | each canHaveExtensions not]
    "

    "Created: / 30-08-2006 / 15:29:49 / cg"
!

classNames
    "answer an array containing all the class names of the project's classes"

    ^ self classNamesAndAttributesAsSpecArray collect:[:entry | entry first].

    "
     stx_libhtml classNames
     stx_libhtml classNamesAndAttributesAsSpecArray
    "
!

classNamesForWhich:aBlock
    "a correponding method with real names is generated in my subclasses"

    |coll|

    coll := OrderedCollection new.
    self classNamesAndAttributesDo:[:nm :attributes |
        (aBlock value:nm value:attributes) ifTrue:[
            coll add:nm.
        ].
    ].
    ^ coll

    "Created: / 07-08-2006 / 19:02:57 / fm"
    "Modified: / 07-08-2006 / 21:25:25 / fm"
    "Modified: / 17-08-2006 / 20:47:20 / cg"
!

classes
    "list my classes.
     Project must be loaded - otherwise an error is reported here.
     Use #classNames if you are only interested in the names"

    ^ self classNames collect:[:nm | Smalltalk at:nm ifAbsent:[self error:'Missing class: ',nm]]

    "
     stx_libbasic3 classNames
     stx_libbasic3 classes
    "

    "Modified: / 27-09-2011 / 18:12:33 / cg"
!

classesForPlatform
    "list my classes for the current platform.
     Project must be loaded - otherwise an error is reported here.
     Use #classNames if you are only interested in the names"

    ^ self classNamesForPlatform collect:[:nm | 
            Smalltalk at:nm ifAbsent:[self error:'Missing class: ',nm]]

    "
     stx_libbasic classesForPlatform
     stx_libbasic classes
    "
!

compiled_classNames
    "the opposite of autoloaded class names"

    ^ self classNamesForWhich:[:nm :attr | attr isEmptyOrNil or:[(attr includes:#autoload) not]].

    "Created: / 07-08-2006 / 19:02:57 / fm"
    "Modified: / 07-08-2006 / 21:25:25 / fm"
    "Modified: / 21-08-2006 / 18:48:31 / cg"
    "Modified (comment): / 05-03-2012 / 12:21:23 / cg"
!

compiled_classNamesForPlatform
    "answer the classes to be compiled only for the current platformName"

    ^ self compiled_classNamesForPlatform:OperatingSystem platformName
!

compiled_classNamesForPlatform:platformName
    "answer the classes to be compiled only for platformName
     platformName is one of #unix, #win32, #vms or #osx (OperatingSystem platformName)"

    ^ self
        classNamesForWhich:[:nm :attr |
            (attr includes:#autoload) not and:[attr includes:platformName]
        ].

    "Created: / 07-08-2006 / 19:02:57 / fm"
    "Modified: / 07-08-2006 / 21:25:25 / fm"
    "Modified: / 09-10-2006 / 13:30:08 / cg"
!

compiled_classNames_common
    "classes to be compiled for any platform"

    ^ self
        classNamesForWhich:[:nm :attr |
            attr isEmptyOrNil
        ].

    "Created: / 18-08-2006 / 13:37:51 / cg"
!

compiled_classNames_unix
    "class, only to be compiled under unix"

    ^ self compiled_classNamesForPlatform:#unix.

    "Created: / 18-08-2006 / 13:37:51 / cg"
!

compiled_classNames_windows
    "class, only to be compiled under windows"

    ^ self compiled_classNamesForPlatform:#win32.

    "Created: / 18-08-2006 / 13:37:56 / cg"
!

compiled_classesForPlatform
    "list my classes for the current platform.
     Project must be loaded - otherwise an error is reported here.
     Use #classNames if you are only interested in the names"

    ^ self compiled_classNamesForPlatform collect:[:nm | 
            Smalltalk at:nm ifAbsent:[self error:'Missing class: ',nm]]

    "
     stx_libbasic compiled_classesForPlatform
     stx_libbasic classes
    "
!

extensionClasses
    "answer the set of classes, which are extended by the package"

    ^ self extensionClassesWithSuperclasses:false

    "
     stx_libboss extensionClasses
    "

    "Modified: / 06-09-2011 / 10:21:44 / cg"
!

extensionClassesWithSuperclasses:withSuperclassesBoolean
    "answer the set of classes, which are extended by the package"

    |classes|

    classes := IdentitySet new.

    self extensionMethodNames pairWiseDo:[:className :selector |
        |mthdCls extendedClass|

        mthdCls := Smalltalk classNamed:className.
        (mthdCls notNil and:[mthdCls isLoaded]) ifTrue:[
            extendedClass := mthdCls theNonMetaclass.
            (classes includes:extendedClass) ifFalse:[
                withSuperclassesBoolean ifTrue:[
                    extendedClass withAllSuperclassesDo:[:eachClass |
                        classes add:eachClass.
                    ].
                ] ifFalse:[
                    classes add:extendedClass.
                ].
            ].
        ].
    ].
    ^ classes.

    "
        stx_libboss extensionClasses
    "

    "Created: / 06-09-2011 / 10:17:06 / cg"
!

extensionMethods
    "list my extension methods.
     Project must be loaded - otherwise an error is reported here.
     Use #extensionMethodsNames if you are only interested in the names"

    ^ self extensionMethodNames
        pairWiseCollect:[:className :selector |
            (Smalltalk classNamed:className) compiledMethodAt:selector.
        ].

    "
     stx_libbasic2 extensionMethodNames
     stx_libbasic2 extensionMethods
    "
!

extensionPackages
    "answer the set of packages, which are extended by this package"

    ^ self allExtensionClasses collect:[:eachClass| eachClass package]

    "
        stx_libboss extensionPackages
    "

    "Modified: / 06-09-2011 / 10:20:47 / cg"
!

hasAllClassesFullyLoaded
    "return true, if all classes are present and loaded (not autoloaded)"

    ^ self hasAllClassesLoaded:true

    "Created: / 25-10-2006 / 16:08:25 / cg"
!

hasAllClassesLoaded
    "return true, if all classes are present (although, some might be autoloaded)"

    ^ self hasAllClassesLoaded:false

    "Modified: / 25-10-2006 / 16:08:11 / cg"
!

hasAllClassesLoaded:checkIfFullyLoaded
    "check if all classes for this platform are present.
     If checkIfFullyLoaded is true, they must be fully loaded; that means: not autoloaded"

    ^ (self
            hasClasses:(self classNamesForWhich:[:nm :attr | attr isEmptyOrNil or:[ attr includes:#autoload]])
            loaded:checkIfFullyLoaded)
    and:[
        self
            hasClasses:(self compiled_classNamesForPlatform:OperatingSystem platformName)
            loaded:checkIfFullyLoaded ]

    "Modified: / 07-11-2006 / 11:47:30 / cg"
!

hasAllCompiledClassesFullyLoaded
    "return true, if all compiled classes are present and loaded"

    ^ self hasAllCompiledClassesLoaded:true

    "Created: / 07-11-2006 / 11:48:02 / cg"
!

hasAllCompiledClassesLoaded:checkIfFullyLoaded
    "check if all compiled classes for this platform are present.
     If checkIfFullyLoaded is true, they must be fully loaded, that is not autoloaded"

    ^ (self
            hasClasses:(self classNamesForWhich:[:nm :attr | attr isEmptyOrNil])
            loaded:checkIfFullyLoaded)
    and:[
       self
            hasClasses:(self compiled_classNamesForPlatform:OperatingSystem platformName)
            loaded:checkIfFullyLoaded
    ]
!

hasAllExtensionsLoaded
    "answer true, if all extensions of this package have been loaded.
     This is a query - so no side effects please"

    (self extensionMethodNames ? #()) pairWiseDo:[:className :selector |
        |cls|

        cls := Smalltalk loadedClassNamed:className.
        cls isNil ifTrue:[
            Verbose ifTrue:[
                Transcript showCR:(self name,' missing extension class "',className,'".').
            ].
            ^ false
        ].
        "there is no possibility that we installed an extension method in an unloaded class"
        (cls isLoaded not or:[(cls compiledMethodAt:selector) isNil]) ifTrue:[
            Verbose ifTrue:[
                Transcript showCR:(self name,' missing extension method "',className,'>>',selector,'".').
            ].
            ^ false
        ].
    ].
    ^ true.

    "Created: / 17-08-2006 / 00:50:01 / cg"
    "Modified: / 25-10-2006 / 00:01:10 / cg"
!

hasClasses:classNames loaded:checkIfFullyLoaded
    "answer true, if all classes referenced by classNames have been loaded
     into the image. If checkIfFullyLoaded, classes installed as autoloaded
     are not considered"

    classNames do:[:eachClassName |
        |cls|

        cls := Smalltalk loadedClassNamed:eachClassName.
        cls isNil ifTrue:[
            Verbose ifTrue:[
               (self name, ' [info]: missing class: ', eachClassName) infoPrintCR.
            ].
            ^ false
        ].
        (checkIfFullyLoaded and:[cls isLoaded not]) ifTrue:[
            Verbose ifTrue:[
                (self name,' [info]: unloaded class: ', eachClassName) infoPrintCR.
            ].
            ^ false.
        ].
    ].

    ^ true
!

hasExtensionMethods
    ^ self extensionMethodNames notEmpty

    "Created: / 14-09-2006 / 14:19:35 / cg"
!

hasPostLoadAction
    "/ true if postLoadAction has been redefined
    ^ (self class whichClassIncludesSelector:#postLoadAction) theNonMetaclass isAbstract not
!

hasPostUnloadAction
    "/ true if postUnloadAction has been redefined
    ^ (self class whichClassIncludesSelector:#postUnloadAction) theNonMetaclass isAbstract not
!

hasPreLoadAction
    "/ true if preLoadAction has been redefined
    ^ (self class whichClassIncludesSelector:#preLoadAction) theNonMetaclass isAbstract not
!

hasPreUnloadAction
    "/ true if preUnloadAction has been redefined
    ^ (self class whichClassIncludesSelector:#preUnloadAction) theNonMetaclass isAbstract not
!

isAbstract
    ^ self == ProjectDefinition

    "Modified (format): / 20-08-2011 / 22:47:46 / cg"
!

isAutoloaded:aClassOrClassName
    |className|

    className := aClassOrClassName isBehavior 
                    ifTrue:[ aClassOrClassName theNonMetaclass name ]
                    ifFalse:[ aClassOrClassName ].
    ^ self autoloaded_classNames includes:className

    "
     'stx:goodies/soap/xe/tests' asPackageId projectDefinitionClass
        isAutoloaded:#'SOAP::XeAllTests'
    "
!

isFullyLoaded
    "as the inherited query isLoaded only refers to a single classes load status,
     this one returns true iff the whole project (all classes plus all extensions) is loaded"

    ^ self hasAllCompiledClassesFullyLoaded
    and:[self hasAllClassesLoaded and:[self hasAllExtensionsLoaded]]

    "Created: / 24-10-2006 / 23:52:23 / cg"
    "Modified: / 20-08-2011 / 22:47:16 / cg"
!

projectType
    ^ self subclassResponsibility
!

supportedOnPlatform
    "answer false, if this package is not suitable for
     the current platform. The default here returns true.
     Only to be redefined in packages which are definitely not valid
     for the given platform. For example, the OLE package is only 
     usable under windows"

    ^ true
!

whoReferences:aPackageString
    "answer, which package references directly or indirectly a package defined by aPackageString"

    |referers|

    referers := OrderedCollection new.

    self allSubclassesDo:[:eachPackageDefinitionClass|
        (eachPackageDefinitionClass allPreRequisites includes:aPackageString) ifTrue:[
            referers add:eachPackageDefinitionClass.
        ]
    ].

    ^ referers.

    "
      self whoReferences:'stx:libview3'
      self whoReferences:'stx:libwidg3'
      self whoReferences:'stx:libbasic'
    "
!

whoReferencesSorted:aPackageString
    "answer, which package references directly or indirectly a package define by aPackageString.
     Sort the result, so that the most direct referers are at the top"

    |referers orderedTuples sortedPackages|

    referers := self whoReferences:aPackageString.
    orderedTuples := OrderedCollection new.

    referers do:[:eachProjectDefinition |
        |preRequisites|

        preRequisites := eachProjectDefinition effectivePreRequisites.
        preRequisites do:[:eachPrerequisitePackageID|
            |eachPrerequisitePackage|

            eachPrerequisitePackage := self definitionClassForPackage:eachPrerequisitePackageID.
            (referers includes:eachPrerequisitePackage) ifTrue:[
                orderedTuples add:(Array with:eachPrerequisitePackage with:eachProjectDefinition).
            ].
        ].
    ].

    (orderedTuples contains:[:el | el first = el second]) ifTrue:[
        self halt:'something seems to depend upon itself'
    ].
    sortedPackages := orderedTuples topologicalSortStable: true.

    ^ sortedPackages.

    "
      self whoReferencesSorted:'stx:libview3'
      self whoReferencesSorted:'stx:libwidg3'
      self whoReferencesSorted:'stx:libbasic'
    "
! !

!ProjectDefinition class methodsFor:'queries-privacy'!

showClassDocumentationOf:aClass
    "used by the HTMLDoc-generator to ask if a classes' protocol is to be documented
     or hidden.
     (used for expecco, to suppress documentation of workflow- and expecco classes
     in the expecco-class browser)"

    ^ true

    "Created: / 05-11-2007 / 16:44:16 / cg"
! !

!ProjectDefinition class methodsFor:'sanity checks'!

validateDescription
    "perform some consistency checks (set of classes in project same as those listed in description);
     called before checking in build support files.
     Somewhat obsolete: use the ProjectChecker, which does more checks"

    |emptyProjects nonProjects emptyOrNonProjects classesInImage
     classesInDescription onlyInImage onlyInDescription missingPools myPackage|

    emptyProjects := Set withAll:self effectiveSubProjects.
    Smalltalk allClassesDo:[:cls |
        emptyProjects remove:(cls package) ifAbsent:[].
    ].
    nonProjects := self effectiveSubProjects select:[:p |
                    (self definitionClassForPackage: p) isNil
                   ].

    emptyOrNonProjects := Set withAll:emptyProjects.
    emptyOrNonProjects addAll:nonProjects.

    emptyOrNonProjects notEmpty ifTrue:[
        (Dialog
            confirm:('The following subprojects are non-existent, empty or without description:\\    '
                    , ((emptyOrNonProjects
                            asSortedCollection
                                collect:[:p | p allBold])
                                asStringWith:'\    ')
                    , '\\Continue ?') withCRs
            yesLabel:'OK' noLabel:'Cancel')
        ifFalse:[
            AbortSignal raise
        ].
    ].

    myPackage := self package.
    classesInImage := Smalltalk allClasses select:[:cls | (cls package == myPackage) and:[cls isPrivate not]].
    "/ classesInDescription := self classes asIdentitySet.
    classesInDescription := IdentitySet new.
    ((self compiled_classNamesForPlatform:(OperatingSystem platformName))
    , (self compiled_classNames_common)
    , (self autoloaded_classNames)) do:[:nm |
        |cls|

        cls := Smalltalk at:nm asSymbol.
        cls isNil ifTrue:[
            (self autoloaded_classNames includes:nm) ifTrue:[
                Transcript showCR:'missing autoloaded class: ',nm.
            ] ifFalse:[
                self error:('missing class: ',nm) mayProceed:true.
            ]
        ] ifFalse:[
            classesInDescription add:cls.
        ]
    ].

    missingPools := Set new.
    classesInDescription do:[:eachClass |
        eachClass sharedPoolNames do:[:eachPoolName |
            |pool|

            pool := eachClass nameSpace classNamed:eachPoolName.
            pool isNil ifTrue:[
                eachClass nameSpace ~~ Smalltalk ifTrue:[
                    pool := Smalltalk classNamed:eachPoolName.
                ]
            ].
            pool isNil ifTrue:[
                Transcript showCR:'missing pool: ',eachPoolName.
                missingPools add:eachPoolName.
            ] ifFalse:[
                pool isSharedPool ifFalse:[
                    Transcript showCR:'not a shared pool: ',eachPoolName.
                    missingPools add:eachPoolName.
                ].
            ].
        ].
    ].

    missingPools notEmpty ifTrue:[
        (Dialog
            confirm:('The following sharedpools are non-existent, or not pools:\\    '
                    , ((missingPools
                            asSortedCollection
                                collect:[:p | p allBold])
                                asStringWith:'\    ')
                    , '\\Continue ?') withCRs
            yesLabel:'OK' noLabel:'Cancel')
        ifFalse:[
            AbortOperationRequest raise
        ].
    ].

"/ also found by ProjectChecker...
    classesInImage ~= classesInDescription ifTrue:[
        onlyInImage := (classesInImage reject:[:cls | classesInDescription includes:cls]).
        onlyInImage notEmpty ifTrue:[
            Transcript show:self name; show:': only in image: '; showCR:onlyInImage
        ].
        onlyInDescription := (classesInDescription reject:[:cls | classesInImage includes:cls]).
        onlyInDescription notEmpty ifTrue:[
            Transcript show:self name; show:': only in description: '; showCR:onlyInDescription
        ].
        (Dialog confirm:'The set of classes in the image is different from the listed classes in the project definition.\\Proceed?' withCRs) ifFalse:[
            AbortOperationRequest raiseRequest
        ]
    ].

"/    self validateOrderOfClasses

    "
     exept_expecco_application validateDescription
     squeak_vmMaker validateDescription
    "

    "Modified: / 06-03-2012 / 11:31:37 / cg"
    "Modified: / 17-01-2017 / 16:33:56 / stefan"
!

validateOrderOfClasses
    "check if the project's classes are listed in the correct dependency order in the classList.
     This would be required, if the generated makefile would compile files in that order,
     and superclasses must be compiled before subclasses (for the header files).
     However, the makefile list is generated by a separate mechanism, so that is not requiered."

    |classesInDescriptionInOrder classesInProject already|

    classesInDescriptionInOrder := OrderedCollection new.
    classesInDescriptionInOrder :=
        self compiled_classNames
            collect:[:eachName |
                |cls|

                cls := Smalltalk at:eachName.
                self assert:cls notNil message:'missing class: ',eachName.
                cls
            ].

    classesInProject := classesInDescriptionInOrder asSet.

    already := Set new.
    classesInDescriptionInOrder do:[:eachClass |
        eachClass allSuperclassesDo:[:superclass |
            (classesInProject includes:superclass) ifTrue:[
                "/ if in the set, it must have been already listed
                self
                    assert:(already includes:superclass)
                    message:('superclass "%1" not compiled before "%2"'
                                    bindWith:superclass name
                                    with:eachClass name).
            ].
        ].
        already add:eachClass.
    ].

    "
     stx_goodies_refactoryBrowser_lint validateOrderOfClasses
     squeak_vmMaker validateOrderOfClasses
    "

    "Created: / 05-03-2012 / 12:18:45 / cg"
! !

!ProjectDefinition class methodsFor:'testing'!

isApplicationDefinition
    ^ false

    "Created: / 23-08-2006 / 15:17:32 / cg"
    "Modified: / 20-09-2006 / 14:59:56 / cg"
!

isConsoleApplication
    ^ false

    "Created: / 20-09-2006 / 14:59:49 / cg"
!

isFolderForProjectsDefinition
    ^ false
!

isGUIApplication
    ^ false

    "Created: / 20-09-2006 / 14:59:49 / cg"
!

isLibraryDefinition
    ^ false

    "Created: / 23-08-2006 / 15:17:46 / cg"
    "Modified: / 20-09-2006 / 15:00:00 / cg"
!

isProjectDefinition
    "concrete i.e. not abstract"

    ^ self isAbstract not

    "Created: / 10-08-2006 / 16:24:02 / cg"
    "Modified: / 08-02-2011 / 10:03:49 / cg"
! !

!ProjectDefinition::AbbrevEntry methodsFor:'accessing'!

category
    ^ category
!

className
    ^ className
!

className:classNameArg fileName:fileNameArg category:categoryArg numClassInstVars:numClassInstVarsArg
    className := classNameArg.
    fileName := fileNameArg.
    category := categoryArg.
    numClassInstVars := numClassInstVarsArg.

    "Created: / 18-08-2011 / 14:18:30 / cg"
!

fileName
    ^ fileName
!

numClassInstVars
    ^ numClassInstVars

    "Created: / 18-08-2011 / 14:18:37 / cg"
! !

!ProjectDefinition::ApplicationDocumentTypeDescription class methodsFor:'documentation'!

documentation
"
    for deployment, some systems can make use of additional information
    on which documents are handled by the application.
    This is used eg. for double-clicking on a document in OSX.
    If the deployed app can/should handle this, redefine the
    applicatinDocumentTypeDescriptions / applicatinDocumentTypeDescriptionsOSX
    methods in the projectDefinition to return a collection of instances of me.

    [author:]
        cg

    For example:
        mimeType:  'application/x-expecco-testsuite
        extension: 'ets'
        typeName:  'expecco test suite'  
        iconFileWindows:  'expeccoSuite.ico'  
        iconFileOSX:      'expeccoSuite.icns'  
        roleOSX:          'Editor'  
"
! !

!ProjectDefinition::ApplicationDocumentTypeDescription methodsFor:'accessing'!

extension
    "the extension of the document"
    
    ^ extension
!

extension:aString
    "the extension of the document"

    extension := aString.
!

iconFileLinux
    ^ iconFileLinux
!

iconFileLinux:aString
    iconFileLinux := aString.
!

iconFileOSX
    ^ iconFileOSX
!

iconFileOSX:aString
    iconFileOSX := aString.
!

iconFileWindows
    ^ iconFileWindows
!

iconFileWindows:aString
    iconFileWindows := aString.
!

mimeType
    ^ mimeType
!

mimeType:aString
    mimeType := aString.
!

roleOSX
    ^ roleOSX
!

roleOSX:aString
    roleOSX := aString.
!

typeName
    "something like 'foo Document';
     eg. 'expecco test suite', 'expecco log file', etc."

    ^ typeName
!

typeName:something
    "something like 'foo Document';
     eg. 'expecco test suite', 'expecco log file', etc."

    typeName := something.
! !

!ProjectDefinition class methodsFor:'documentation'!

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
    ^ '$ Id: ProjectDefinition.st 10645 2011-06-09 15:28:45Z vranyj1  $'
! !


ProjectDefinition initialize!
