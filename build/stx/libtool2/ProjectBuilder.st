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

Object subclass:#ProjectBuilder
	instanceVariableNames:'package projectDefinitionClass sourceCodeManager buildDirectory
		myWorkingDirectory mySTXTopDirectory myTopDirectory outputStream
		makeExeOnly makeAppOnly makeQuick usedCompiler stdOut stdErr
		isQuickBuild isLocalBuild'
	classVariableNames:'PreviousBuildDirectory'
	poolDictionaries:''
	category:'System-Support-Projects'
!

!ProjectBuilder class methodsFor:'documentation'!

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
! !

!ProjectBuilder class methodsFor:'accessing'!

previousBuildDirectory
    ^ PreviousBuildDirectory
!

previousBuildDirectory:something
    PreviousBuildDirectory := something.
! !

!ProjectBuilder class methodsFor:'examples'!

example1
    Smalltalk loadPackage:'stx:projects/helloWorldApp' asAutoloaded:true.

    self new
        package:'stx:projects/helloWorldApp';
        build
!

example2
    |builder|

    Smalltalk loadPackage:'stx:clients/Demos/foxCalcApplication' asAutoloaded:true.

    builder := self new.
    builder 
        package:'stx:clients/Demos/foxCalcApplication';
        build.

    UserPreferences fileBrowserClass openOnDirectory:builder packageBuildDirectory.

    "Modified: / 03-09-2012 / 19:23:53 / cg"
! !

!ProjectBuilder class methodsFor:'queries'!

defaultUsedCompiler
    |compiler|

    (compiler := UserPreferences current usedCompilerForBuild) notNil ifTrue:[
        ^ compiler
    ].

    ^ ParserFlags usedCompiler
!

listOfPossibleCompilers
    OperatingSystem isMSWINDOWSlike ifTrue:[
        OperatingSystem getLoginName = 'cg' ifTrue:[
            ^ #(
                'bcc'   "/ OK
                'vc'    "/ almost OK
                'lcc'   "/ experimental, but only free for non-commercial work
                'tcc'   "/ experimental; limited but free
                'mingw' "/ experimental; free
             )
        ].
        ^ #('bcc' 'vc' 'mingw' )
    ].
    ^ #('gcc')

    "Created: / 21-01-2012 / 14:04:15 / cg"
!

suiteNameOfCompiler:usedCompiler
    usedCompiler = 'bcc' ifTrue:[
        ^ 'Borland C-Compiler'.
    ].
    usedCompiler = 'vc' ifTrue:[
        ^ 'Microsoft Visual C Compiler'.
    ].
    usedCompiler = 'lcc' ifTrue:[
        ^ 'LCC C-Compiler'.
    ].
    usedCompiler = 'tcc' ifTrue:[
        ^ 'Tiny C-Compiler'.
    ].
    usedCompiler = 'gcc' ifTrue:[
        ^ 'GNU C-Compiler'.
    ].
    usedCompiler = 'mingw' ifTrue:[
        ^ 'MINGW GNU C-Compiler'.
    ].
    self halt:'unknown compiler'.

    ^ 'C-Compiler'.

    "Created: / 06-09-2012 / 15:58:33 / cg"
! !

!ProjectBuilder methodsFor:'accessing'!

buildDirectory
    buildDirectory isNil ifTrue:[
        self determineBuildDirectory
    ].    
    ^ buildDirectory
!

buildDirectory:something
    buildDirectory := something.
!

isLocalBuild
    ^ isLocalBuild ? false
!

isLocalBuild:aBoolean
    "create a files without going through the source code manager"

    isLocalBuild := aBoolean.
!

isQuickBuild
    ^ isQuickBuild ? false
!

isQuickBuild:aBoolean
    "skips creation of header files, and copying of support files, if possible
     to speedup a build. Use with care."

    isQuickBuild := aBoolean.
!

makeAppOnly
    ^ (makeAppOnly ? false)
!

makeAppOnly:aBoolean
    makeAppOnly := aBoolean.
!

makeExeOnly
    ^ (makeExeOnly ? false)
!

makeExeOnly:aBoolean
    makeExeOnly := aBoolean.
!

makeQuick
    ^ (makeQuick ? false)
!

makeQuick:aBoolean
    makeQuick := aBoolean.
!

package:aPackageIDOrSymbol
    package := aPackageIDOrSymbol asPackageId.
!

packageBuildDirectory
    "the directoray, where the deployable binary is created (xxxSetup.exe)"

    ^ buildDirectory / (package asPackageId module) / (package asPackageId directory)
!

projectDefinitionClass:something
    projectDefinitionClass := something.
!

suffixForHeaderFiles
    ^ OperatingSystem isUNIXlike ifTrue:['.H'] ifFalse:['.STH']
!

usedCompilerForBuild:something
    usedCompiler := something.

    "Created: / 22-01-2012 / 10:50:48 / cg"
! !

!ProjectBuilder methodsFor:'building'!

build
    "/ intermediate - this will move into a commonly used utility class
    "/ (where all the project code support will be collected).

    |makeOutput|

    makeOutput := TextStream on:(Text new:10000).
    self buildWithColorizedOutputTo:makeOutput.

    TextView openWith:makeOutput contents.
!

buildWithColorizedOutputTo:makeOutput
    "/ intermediate - this will move into a commonly used utility class
    "/ (where all the project code support will be collected).

    |lock|

    lock := Semaphore forMutualExclusion.

    stdErr := ActorStream new
                    nextPutBlock:[:char |
                        lock critical:[
                            makeOutput 
                                withEmphasis:{#backgroundColor->Color red. #color->Color white.}
                                do:[makeOutput nextPut:char].
                        ]
                    ];
                    nextPutAllBlock:[:string |
                        lock critical:[          
                            makeOutput
                                withEmphasis:{#backgroundColor->Color red. #color->Color white.}
                                do:[makeOutput nextPutAll:string].
                        ]
                    ].
    stdOut := ActorStream new
                    nextPutBlock:[:char |
                        lock critical:[
                            makeOutput nextPut:char.
                        ]
                    ];
                    nextPutAllBlock:[:string |
                        lock critical:[         
                            makeOutput nextPutAll:string.
                        ]
                    ].

    self buildWithOutputTo:stdOut errorTo:stdErr.

    "Modified: / 06-09-2012 / 16:15:50 / cg"
!

buildWithOutputTo:stdOutArg errorTo:stdErrArg
    "/ intermediate - this will move into a commonly used utility class
    "/ (where all the project code support will be collected).

    |module directory|

    usedCompiler isNil ifTrue:[
        usedCompiler := ParserFlags usedCompiler.
        usedCompiler isNil ifTrue:[ self error:'no compiler defined (settings)'. ].
    ].

    projectDefinitionClass := ProjectDefinition definitionClassForPackage:package.
    projectDefinitionClass isNil ifTrue:[
        self error:('Missing ProjectDefinition class for "',package asString,'"')
    ].

    "/ ensure that everything is loaded...
    projectDefinitionClass loadAsAutoloaded:false.
    projectDefinitionClass loadExtensions.
    projectDefinitionClass loadAllClassesAsAutoloaded:false.

    module := package module.
    directory := package directory.

    buildDirectory isNil ifTrue:[
        self determineBuildDirectory.
    ].

    "/ self validateBuildDirectoryIsPresent.

    PreviousBuildDirectory := buildDirectory.

    "/ UserPreferences current localBuild:true
    (self isLocalBuild or:[UserPreferences current localBuild]) ifFalse:[
        SourceCodeManager notNil ifTrue:[
            sourceCodeManager := SourceCodeManagerUtilities sourceCodeManagerFor:projectDefinitionClass.
        ]
    ].
    sourceCodeManager := nil.

    myTopDirectory := 
        Smalltalk packagePath 
            detect:[:aPath |
                (aPath asFilename / 'stx' / 'include') exists
                and: [ (aPath asFilename / 'stx' / 'rules') exists ]]
            ifNone:nil.       
    myTopDirectory isNil ifTrue:[
        self error:('Cannot figure out my top directory (where stx/include and stx/rules are)')
    ].
    myTopDirectory := myTopDirectory asFilename.
    mySTXTopDirectory := myTopDirectory / 'stx'.

    self makeQuick ifFalse:[
        self setupBuildDirectory.
        self activityNotification:'Generating stc directory...'.
        self copySTCDirectoryForBuild.
    ].
    self activityNotification:'Generating source files...'.
    self generateSourceFiles.
    false "self makeQuick" ifFalse:[
        self activityNotification:'Copying dlls for linkage...'.
        self copyDLLsForLinkage.
        self activityNotification:'Copying support files for compilation and linkage...'.
        self copySupportFilesForCompilation.
        self copySupportFilesForLinkage.
        self copyStartupFilesFromSmalltalk.
    ].
    self makeWithOutputTo:stdOut errorTo:stdErr.

    "Modified: / 06-06-2016 / 15:16:28 / cg"
! !

!ProjectBuilder methodsFor:'building/private'!

copyDLLsForLinkage
    |targetBuildDir preRequisites dllRelativeSourcePaths dllRelativeDestPaths|

    targetBuildDir := buildDirectory / package module / package directory.

    preRequisites := projectDefinitionClass allPreRequisites.
    OperatingSystem isUNIXlike ifTrue:[
        "For now: unix Makefiles require some libs implicitely..."
        preRequisites := preRequisites union:#(
                               #'stx:goodies/refactoryBrowser/parser'
                               #'stx:libtool'
                            ).
    ].

    preRequisites do:[:eachPackageToFileout |
        |packageId packageDef packageModule packageDirectory packageTargetDir
         dllSource dllSourceDir libraryName dllRelativePathSource
         dllRelativePathDest objDirSource objDirDest alternativeObjDirSource|

        packageId := eachPackageToFileout asPackageId.
        packageModule := packageId module.
        packageDirectory := packageId directory.
        packageTargetDir := (buildDirectory / packageModule / packageDirectory) recursiveMakeDirectory.

        packageDef := packageId projectDefinitionClass.
        libraryName := packageDef libraryName.

        "/ mhmh - take them from my tree or from the projects/smalltalk execution directory ??
        dllSourceDir := myTopDirectory / packageModule / packageDirectory.

        OperatingSystem isMSWINDOWSlike ifTrue:[
            objDirDest := self objDirForUsedCompiler:usedCompiler.
            objDirSource := objDirDest.
"/            "/ use visual-c files for tcc linkage
"/            usedCompiler = 'tcc' ifTrue:[
"/                objDirSource := self objDirForUsedCompiler:'vc'.
"/            ] ifFalse:[
"/                objDirSource := objDirDest
"/            ].
            (dllSourceDir / objDirSource / (libraryName, '.dll')) exists ifFalse:[
                alternativeObjDirSource := self objDirForUsedCompiler:'vc'.
                (dllSourceDir / alternativeObjDirSource / (libraryName, '.dll')) exists ifTrue:[
                    objDirSource := alternativeObjDirSource.
                    stdErr nextPutLine:(('Warning: using alternative %1 from %2 (%3 version)...'
                                                bindWith:libraryName
                                                with:alternativeObjDirSource
                                                with:(self class suiteNameOfCompiler:'vc'))
                                            emphasizeAllWith:(#color -> Color red darkened)).
                ] ifFalse:[
                    alternativeObjDirSource := self objDirForUsedCompiler:'bcc'.
                    (dllSourceDir / alternativeObjDirSource / (libraryName, '.dll')) exists ifTrue:[
                        objDirSource := alternativeObjDirSource.
                        stdErr nextPutLine:('Warning: using alternative %1 from %2 (%3 version)...'
                                    bindWith:libraryName
                                    with:alternativeObjDirSource
                                    with:(self class suiteNameOfCompiler:'bcc')).
                    ]
                ].
            ].

"/            dllRelativePath := objDir,'/',(libraryName,'.dll').
"/            (dllSourceDir / dllRelativePath) exists
            dllRelativeSourcePaths := Array with:(objDirSource,'\', libraryName, '.dll').
            dllRelativeDestPaths := Array with:(objDirDest,'\', libraryName, '.dll').
        ] ifFalse:[
            dllRelativeSourcePaths := Array with:(libraryName,'.so').
            dllRelativeDestPaths := Array with:(libraryName, '.so').
            (packageModule = 'stx' and:[packageDirectory = 'libview']) ifTrue:[
                dllRelativeSourcePaths := dllRelativeSourcePaths copyWith:('XWorkstation.so').
                dllRelativeDestPaths := dllRelativeDestPaths copyWith:'XWorkstation.so'.
                dllRelativeSourcePaths := dllRelativeSourcePaths copyWith:('GLXWorkstation.so').
                dllRelativeDestPaths := dllRelativeDestPaths copyWith:'GLXWorkstation.so'.
            ].
        ].
        dllRelativeSourcePaths with:dllRelativeDestPaths do:[:dllRelativeSourcePath :dllRelativeDestPath|
            |source dest|

            source := dllSourceDir / dllRelativeSourcePath.
            source exists ifFalse:[
                self activityNotification:'   skip missing file: ',source pathName.
            ] ifTrue:[
                dest := packageTargetDir / dllRelativeDestPath.
                (dest exists not
                 or:[source fileSize ~= dest fileSize
                 or:[source modificationTime > dest modificationTime
                 "/ or:[ ((dllSourceDir / dllRelativePath) sameContentsAs:(packageTargetDir / dllRelativePath)) not ]
                ]]) ifTrue:[
                    Transcript showCR:'updating ',dllRelativeDestPath.
                    dest directory recursiveMakeDirectory.
                    source copyTo:dest.
                    self activityNotification:'    ',dest pathName
                ] ifFalse:[
                    Transcript showCR:'already up-to-date: ',dllRelativeDestPath.
                ]
            ]
        ].
    ].

    "Modified: / 06-09-2012 / 16:19:29 / cg"
!

copyDirectory:relativepath
    "/ need rules in stx
    ((Smalltalk projectDirectoryForPackage:'stx') asFilename construct:relativepath)
        recursiveCopyTo:(buildDirectory construct:'stx').
!

copyDirectoryForBuild:subdir
    |targetDir targetFile|

    targetDir := buildDirectory / 'stx' / subdir.
    targetDir exists ifFalse:[
        targetDir makeDirectory.
    ] ifTrue:[
        self isQuickBuild ifTrue:[^ self]
    ].
    (mySTXTopDirectory / subdir) directoryContentsAsFilenamesDo:[:eachFile |
        eachFile isDirectory ifFalse:[
            targetFile := targetDir / eachFile baseName.
            (targetFile exists not
            or:[ targetFile modificationTime < eachFile modificationTime ]) ifTrue:[
                self activityNotification:'copying ',eachFile pathName,'...'.
                eachFile copyTo:(targetDir construct:eachFile baseName)
            ]
        ].
    ].
    self activityNotification:nil
!

copyResourcesForPackage:aPackage
    |module directory myPackageDirectory rsrcDir stylesDir|

    module := aPackage asPackageId module.
    directory := aPackage asPackageId directory.

    myPackageDirectory := myTopDirectory / module / directory.

    (rsrcDir := myPackageDirectory / 'resources' ) exists ifTrue:[
        rsrcDir recursiveCopyTo:(buildDirectory / module / directory)
    ].
    (stylesDir := myPackageDirectory / 'styles' ) exists ifTrue:[
        stylesDir recursiveCopyTo:(buildDirectory / module / directory)
    ].
!

copySTCDirectoryForBuild
    "copy stc files to the build directory"

    |targetDir stc files|

    targetDir := buildDirectory / 'stx' / 'stc'.
    targetDir exists ifFalse:[ targetDir makeDirectory ].

    stc := OperatingSystem isMSWINDOWSlike 
                ifTrue:[ 'stc.exe' ]
                ifFalse:[ 'stc' ].

    files := #( ) copyWith:stc.

    files do:[:eachFile |
        |sourceFile targetFile|

        sourceFile := mySTXTopDirectory / 'stc' / eachFile.
        targetFile := targetDir / eachFile.
        (targetFile exists not
        or:[ targetFile modificationTime < sourceFile modificationTime ]) ifTrue:[
            self activityNotification:'copying ',sourceFile pathName,'...'.
            sourceFile copyTo:targetFile
        ].
    ].

    OperatingSystem isUNIXlike ifTrue:[
        (targetDir / 'stc') makeExecutableForAll    
    ].

    self activityNotification:nil

    "Modified (comment): / 04-09-2012 / 00:49:19 / cg"
!

copyStartupFilesFromSmalltalk
    "copy additional smalltalk startup files to the build directory"

    (buildDirectory / 'stx' / 'projects/smalltalk' ) exists ifFalse:[
        (buildDirectory / 'stx' / 'projects/smalltalk' ) recursiveMakeDirectory.
    ].

    #( 
        'keyboard.rc' 
        'keyboardMacros.rc' 
        'display.rc' 
        'd_win32.rc'
        'host.rc' 
        'h_win32.rc'  
        'smalltalk.rc'  
        'private.rc'  
    ) do:[:fn |
        (myTopDirectory / 'stx' / 'projects/smalltalk' / fn)
            copyTo: (buildDirectory / 'stx' / 'projects/smalltalk' / fn)
    ].

    (myTopDirectory / 'stx' / 'doc/online/english/LICENCE_STX.html')
            copyTo: (buildDirectory / 'stx' / 'projects/smalltalk' / 'LICENCE_STX.html').

    "Modified (comment): / 04-09-2012 / 00:48:47 / cg"
!

copySupportFilesForCompilation
    "copy the tcc compiler to the build directory"

    |files|

    files := #().

    OperatingSystem isMSWINDOWSlike ifTrue:[
        files := files , #( 
                        'librun/genDate.com' 
                    ).
        usedCompiler = 'tcc' ifTrue:[
            files := files , #( 
                        'support/tcc'
                    ).
        ].
    ] ifFalse:[
        files := files , #( 
                        "/ 'librun/genDate'   -- not needed on unix (done via script)
                        'configurations/myConf' 
                        'configurations/vendorConf' 
                        'configurations/conf.inc' 
                        'configurations/COMMON' 
                    ).
    ].

    files do:[:relativePath |
        (mySTXTopDirectory / relativePath) exists ifTrue:[
            ((buildDirectory / 'stx' / relativePath) exists
            and:[ (mySTXTopDirectory / relativePath) fileSize = (buildDirectory / 'stx' / relativePath) fileSize
            and:[ (mySTXTopDirectory / relativePath) modificationTime < (buildDirectory / 'stx' / relativePath) modificationTime
            "/ and:[ (mySTXTopDirectory / dllRelativePath) sameContentsAs:(targetBuildDir / dllRelativePath) ]
            ]]) ifFalse:[
                (buildDirectory / 'stx' / relativePath) directory recursiveMakeDirectory.    
                (mySTXTopDirectory / relativePath) isDirectory ifTrue:[
                    (mySTXTopDirectory / relativePath) recursiveCopyTo:(buildDirectory / 'stx' / relativePath) directory.    
                ] ifFalse:[
                    (mySTXTopDirectory / relativePath) copyTo:(buildDirectory / 'stx' / relativePath) directory.    
                ]
            ]
        ] ifFalse:[
            self error:'Missing file or directory: ',relativePath printString mayProceed:true.
        ].
    ].

    "Created: / 04-09-2012 / 00:47:49 / cg"
!

copySupportFilesForLinkage
    "copy additional files which are req'd for linkage to the build directory"

    |files fn|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        files := #( 
                    'librun/genDate.com'
                    'librun/main.c'
                    'projects/smalltalk/stx_16x16.ico'
                    'projects/smalltalk/stx_32x32.ico'
                    'projects/smalltalk/stx_splash.bmp'
                 ).

        usedCompiler = 'bcc' ifTrue:[
            files := files , #( 
                        'librun/objbc/librun.dll'
                        'support/win32/borland/cs3245.dll' 
                        'support/win32/X11.dll'
                        'support/win32/Xext.dll'
                        'lib/bc/librun.lib'
                        'lib/bc/cs32i.lib'
                    ).
        ].
        usedCompiler = 'vc' ifTrue:[
            files := files , #( 
                        'librun/objvc/librun.dll'
                        'lib/vc/librun.lib'
                    ).
        ].
        usedCompiler = 'tcc' ifTrue:[
            files := files , #( 
                        'librun/objvc/librun.dll'   "/ linkage is against vc version!!
                        'lib/vc/librun.lib'
                    ).
        ].
        usedCompiler = 'lcc' ifTrue:[
            files := files , #( 
                        'librun/objvc/librun.dll'   "/ linkage is against vc version!!
                        'lib/vc/librun.lib'
                    ).
        ].
        usedCompiler = 'mingw' ifTrue:[
            files := files , #( 
                        'librun/objmingw/librun.dll'   "/ linkage is against vc version!!
                        'lib/mingw/librun.lib'
                    ).
        ].
    ] ifFalse:[
        files := #(
                    'librun/main.c'
                    'librun/librun.so'
                )
    ].
    files := files asOrderedCollection.
    files add:'RELEASE'.
    
    OperatingSystem isMSWINDOWSlike ifTrue:[
        (fn := projectDefinitionClass applicationIconFileNameWindows) notNil ifTrue:[
            fn asFilename suffix isEmptyOrNil ifTrue:[
                fn := fn,'.ico'
            ].    
            files add:('projects/smalltalk/',fn)
        ].
        (fn := projectDefinitionClass splashFileName) notNil ifTrue:[
            files add:('projects/smalltalk/',fn,'.bmp')
        ].
    ].
    OperatingSystem isOSXlike ifTrue:[
        (fn := projectDefinitionClass applicationIconFileNameOSX) notNil ifTrue:[
            fn asFilename suffix isEmptyOrNil ifTrue:[
                fn := fn,'.icns'
            ].    
            files add:('projects/smalltalk/',fn)
        ].
    ].

    files do:[:relativePath |
        (mySTXTopDirectory / relativePath) exists ifTrue:[
            ((buildDirectory / 'stx' / relativePath) exists
            and:[ (mySTXTopDirectory / relativePath) fileSize = (buildDirectory / 'stx' / relativePath) fileSize
            and:[ (mySTXTopDirectory / relativePath) modificationTime < (buildDirectory / 'stx' / relativePath) modificationTime
            "/ and:[ (mySTXTopDirectory / dllRelativePath) sameContentsAs:(targetBuildDir / dllRelativePath) ]
            ]]) ifFalse:[
                (buildDirectory / 'stx' / relativePath) directory recursiveMakeDirectory.
                (mySTXTopDirectory / relativePath) copyTo:(buildDirectory / 'stx' / relativePath).    
            ]
        ] ifFalse:[
"/ does not really help: objbc/librun.lib does not work with MSVC and vice versa...
"/            ((relativePath = 'librun/objvc/librun.dll')
"/            and:[ (mySTXTopDirectory / 'librun/objbc/librun.dll') exists ])ifTrue:[
"/                stdErr nextPutLine:('Warning: using alternative librun from objbc (Borland version)...'). 
"/                (buildDirectory / 'stx' / relativePath) directory recursiveMakeDirectory.
"/                (mySTXTopDirectory / 'librun/objbc/librun.dll') copyTo:(buildDirectory / 'stx' / relativePath).    
"/            ] ifFalse:[
"/                ((relativePath = 'librun/objbc/librun.dll')
"/                and:[ (mySTXTopDirectory / 'librun/objvc/librun.dll') exists ])ifTrue:[
"/                    stdErr nextPutLine:('Warning: using alternative librun from objvc (MSVC version)...'). 
"/                    (buildDirectory / 'stx' / relativePath) directory recursiveMakeDirectory.
"/                    (mySTXTopDirectory / 'librun/objvc/librun.dll') copyTo:(buildDirectory / 'stx' / relativePath).    
"/                ] ifFalse:[
                    self error:'Missing file: ',relativePath printString mayProceed:true.
"/                ]
"/            ]
        ].
    ].

    "Modified: / 05-09-2012 / 16:26:25 / cg"
!

createHeaderFileFor:aClass in:packageTargetDir
    |instVarList classInstVarList classVarList bindings superclassFilename
     template file newContents oldContents|

    instVarList := StringCollection new.
    aClass instVarNames do:[:v |
        instVarList add:('OBJ %1;' bindWith:v)
    ].
    classInstVarList := StringCollection new.
    aClass class instVarNames do:[:v |
    "/ (v includes:$_) ifTrue:[self halt].
        classInstVarList add:('OBJ %1;' bindWith:v)
    ].
    classVarList := StringCollection new.
    aClass classVarNames do:[:v |
        classVarList add:('extern OBJ %1_%2;' bindWith:aClass name with:v)
    ].

    bindings := Dictionary new.
    bindings at:'ClassName' put:aClass name. 
    aClass superclass isNil ifTrue:[
        bindings at:'SuperclassName' put:'-'. 
        bindings at:'SuperclassFileInclude' put:''.
    ] ifFalse:[
        bindings at:'SuperclassName' put:aClass superclass name. 
        bindings at:'SuperclassFileName' put:(superclassFilename := Smalltalk fileNameForClass:aClass superclass).
        bindings at:'SuperclassFileInclude' put:('#include "%1.STH"' bindWith:superclassFilename).
    ].
    bindings at:'InstVarList' put:instVarList asString. 
    bindings at:'ClassVarList' put:classVarList asString. 
    bindings at:'ClassInstVarList' put:classInstVarList asString. 

    template := 
'/* This file was generated by ProjectBuilder. */
/* !!!!!!!! Do not change by hand !!!!!!!! */

/* Class: %(ClassName) */
/* Superclass: %(SuperclassName) */

%(SuperclassFileInclude)

/* INDIRECTGLOBALS */
#ifdef _HEADER_INST_
%(InstVarList)
#endif /* _HEADER_INST_ */

#ifdef _HEADER_CLASS_
%(ClassVarList)
#endif /* _HEADER_CLASS_ */

#ifdef _HEADER_CLASSINST_
%(ClassInstVarList)
#endif /* _HEADER_CLASSINST_ */
'.
    newContents := template bindWithArguments:bindings.
    file := packageTargetDir asFilename / ((Smalltalk fileNameForClass:aClass),(self suffixForHeaderFiles)).
    (file exists not
    or:[ (oldContents := file contents) ~= newContents ]) ifTrue:[
        file contents: newContents.
    ].

    "Modified: / 15-08-2011 / 14:58:46 / cg"
!

determineBuildDirectory
    buildDirectory isNil ifTrue:[
        buildDirectory := PreviousBuildDirectory ifNil:[ UserPreferences current buildDirectory ].
        buildDirectory isNil ifTrue:[
            buildDirectory := Filename tempDirectory construct:'stx_build'.
        ].
    ].
    buildDirectory := buildDirectory asFilename.
!

generateBuildSupportFilesByFilingOutIn:packageTargetDir forDefinitionClass:projectDefinitionClass
    |fullPathName|

    projectDefinitionClass forEachFileNameAndGeneratedContentsDo:[:fileName :fileContents |
        fullPathName := packageTargetDir construct:fileName.
        fullPathName directory exists ifFalse:[
            "take care for files like 'autopackage/default.apspec'"
            fullPathName directory makeDirectory.
        ].
        (fullPathName exists
         and:[ fullPathName contents = fileContents ]) ifFalse:[
            fullPathName contents:fileContents.
        ].
    ].    
!

generateSourceFiles
    (self isLocalBuild not and:[ sourceCodeManager notNil ])  ifTrue:[
        "/ check out / generate files there
        self generateSourceFilesByCheckingOutUsing:sourceCodeManager
    ] ifFalse:[
        "/ local build
        "/ fileout the project
        self generateSourceFilesByFilingOut
    ]
!

generateSourceFilesByCheckingOutUsing:aSourceCodeManager
    "/ will no longer be needed/supported

    |repository stxRepository module directory|

    self breakPoint:#cg.

    "/ check out / generate files there
    repository := (aSourceCodeManager repositoryNameForModule:module) ifNil:[aSourceCodeManager repositoryName].
    stxRepository := aSourceCodeManager repositoryName.

    (buildDirectory construct:'stx') exists ifFalse:[
        (module ~= 'stx') ifTrue:[
            OperatingSystem
                executeCommand:('cvs -d ',stxRepository,' co stx')
                inputFrom:nil
                outputTo:Transcript
                errorTo:Transcript
                inDirectory:buildDirectory
                onError:[:status| self error:'cvs update stx failed'].
        ].
    ].

    ((buildDirectory construct:module) construct:'CVS') exists ifFalse:[
        OperatingSystem
            executeCommand:('cvs -d ',repository,' co -l ',directory)
            inputFrom:nil
            outputTo:Transcript
            errorTo:Transcript
            inDirectory:buildDirectory
            onError:[:status| self error:'cvs update failed'].
    ].
    OperatingSystem
        executeCommand:'cvs upd -d'
        inputFrom:nil
        outputTo:Transcript
        errorTo:Transcript
        inDirectory:(buildDirectory construct:module)
        onError:[:status| self error:'cvs update failed'].
self halt.

    "Modified: / 29-12-2011 / 14:02:56 / cg"
!

generateSourceFilesByFilingOut
    "/ local build
    "/ fileout the project

    (package module ~= 'stx') ifTrue:[
        (buildDirectory / package module) makeDirectory.
    ].

    "/ file out the package(s) which are to be built
    ((Array with:package))
    do:[:eachPackageToFileout |
        |packageId packageModule packageDirectory packageTargetDir packageDef extSource|

        packageId := eachPackageToFileout asPackageId.
        packageModule := packageId module.
        packageDirectory := packageId directory.
        packageTargetDir := (buildDirectory / packageModule / packageDirectory) recursiveMakeDirectory.

        packageDef := packageId projectDefinitionClass.
        (packageDef compiled_classNames_common ,
        packageDef compiled_classNamesForPlatform) do:[:eachClassName |
            |cls fileName newSource|

            cls := Smalltalk classNamed:eachClassName.
            (cls notNil and:[cls isLoaded]) ifFalse:[
                self error:'missing class: ',eachClassName mayProceed:true
            ].
            fileName := (Smalltalk fileNameForClass:cls),'.st'.
            fileName := packageTargetDir asFilename construct:fileName.
            fileName exists ifTrue:[
                newSource := String streamContents:[:s | cls fileOutOn:s withTimeStamp:false].
                newSource = fileName contentsAsString ifFalse:[
                    fileName contents:newSource
                ].
            ] ifFalse:[
                cls fileOutIn:packageTargetDir withTimeStamp:false
            ].
        ].

        packageDef hasExtensionMethods ifTrue:[
            extSource := 
                String streamContents:[:s |
                    s nextPutAll:('"{ Package: ''%1'' }" !!\\' bindWith:packageDef package) withCRs.

                    packageDef extensionMethods do:[:eachMethod |
                        eachMethod mclass fileOutMethod:eachMethod on:s
                    ].
                ].
            extSource isWideString ifTrue:[
                extSource := ( '"{ Encoding: utf8 }"' , Character cr asString, Character cr asString, extSource).
                extSource := extSource utf8Encoded.
            ].
            (packageTargetDir asFilename construct:'extensions.st') contents:extSource
        ].

"/        (Smalltalk allClassesInPackage:eachPackageToFileout) do:[:cls |
"/            cls isPrivate ifFalse:[
"/                cls isLoaded ifFalse:[
"/                    self halt.
"/                    cls autoload.
"/                ].
"/                cls fileOutIn:packageTargetDir
"/            ]
"/        ].
        self generateBuildSupportFilesByFilingOutIn:packageTargetDir forDefinitionClass:projectDefinitionClass.
    ].
    self makeQuick ifFalse:[
        "/ generate header files and build support files
        "/ in prerequisite packages...
        (projectDefinitionClass allPreRequisites)
        do:[:eachPackageToFileout |
            |packageId packageDef packageModule packageDirectory packageTargetDir|

            packageId := eachPackageToFileout asPackageId.
            packageModule := packageId module.
            packageDirectory := packageId directory.
            packageTargetDir := (buildDirectory / packageModule / packageDirectory) recursiveMakeDirectory.

            packageDef := packageId projectDefinitionClass.
            (packageDef compiled_classNames_common ,
            packageDef compiled_classNamesForPlatform) do:[:eachClassName |
                |cls|

                cls := Smalltalk classNamed:eachClassName.
                "/ self assert:cls isLoaded.
                cls isNil ifTrue:[
                    stdErr nextPutLine:('Missing class: ',eachClassName, ' (not present in system. Warning only:subclasses of it will not be compiled)').
                ] ifFalse:[
                    cls isLoaded ifTrue:[    
                        self createHeaderFileFor:cls in:packageTargetDir
                    ]
                ].
            ].
            self copyResourcesForPackage:eachPackageToFileout.
            self generateBuildSupportFilesByFilingOutIn:packageTargetDir forDefinitionClass:packageDef.
            (packageTargetDir / '.NOSOURCE') contents:'existence of this file suppresses compilation of st files'.
        ].
    ].

"/    stx_libbasic2 preRequisitesForBuilding#(#'stx:libbasic')
!

makeCommandOfCompiler:usedCompiler
    usedCompiler notNil ifTrue:[
        usedCompiler = 'bcc' ifTrue:[ 
            ^ 'bmake'.
        ].
        usedCompiler = 'vc' ifTrue:[ 
            ^ 'vcmake'. "/ compilerFlag := '-DUSEVC' 
        ].
        usedCompiler = 'lcc' ifTrue:[ 
            ^ 'lccmake'. "/ compilerFlag := '-DUSELCC' 
        ].
        usedCompiler = 'tcc' ifTrue:[ 
            ^ 'tccmake'. "/ compilerFlag := '-DUSELCC' 
        ].
        usedCompiler = 'mingw' ifTrue:[ 
            ^ 'mingwmake'.  "/ compilerFlag := '-DUSEMINGW' 
        ].
        true "usedCompiler = 'gcc'" ifTrue:[ 
            ^ 'make'.       "/ compilerFlag := '-DUSEGCC' 
        ].
    ].
    self error:'unknown compiler specified'.

    "Created: / 03-09-2012 / 19:46:07 / cg"
    "Modified: / 06-06-2016 / 15:11:54 / cg"
!

makeWithOutputTo:stdOut errorTo:stdErr
    |module directory makeCommand forceArg makeTarget|

    module := package module.
    directory := package directory.

    "/ makeCommand := ParserFlags makeCommand.
    usedCompiler isNil ifTrue:[
        usedCompiler := ParserFlags usedCompiler.
        usedCompiler isNil ifTrue:[ self error:'no compiler defined (settings)'. ].
    ].
    makeCommand := self makeCommandOfCompiler:usedCompiler.
    self activityNotification:'Executing make... (',makeCommand,')'.
    forceArg := ''.
    
    "/ makeCommand := makeCommand, ' TOP=', mySTXTopDirectory pathName.

    OperatingSystem isUNIXlike ifTrue:[
        forceArg := ' FORCE='.

        "/ generate the makefile first
        self activityNotification:('sh %1/rules/stmkmf (in %2)' 
                    bindWith:mySTXTopDirectory pathName    
                    with:(buildDirectory / module / directory)).
        OperatingSystem
            executeCommand:('sh %1/rules/stmkmf' bindWith:mySTXTopDirectory pathName)
            inputFrom:nil
            outputTo:stdOut
            errorTo:stdErr
            inDirectory:(buildDirectory / module / directory)
            onError:[:status | self error:'make failed'].
    ].

    projectDefinitionClass isLibraryDefinition ifTrue:[
        "/ generate the library
        self activityNotification:(makeCommand,' classLibRule').
        OperatingSystem
            executeCommand:(makeCommand,' classLibRule',forceArg)
            inputFrom:nil
            outputTo:stdOut
            errorTo:stdErr
            inDirectory:(buildDirectory / module / directory)
            onError:[:status | self error:'make failed'].
    ] ifFalse:[
        (self makeExeOnly) ifTrue:[
            makeTarget := 'exe'
        ] ifFalse:[
            (self makeAppOnly) ifTrue:[
                makeTarget := 'app'
            ] ifFalse:[
                makeTarget := 'ALL_NP'
            ].
            self activityNotification:(makeCommand,' ',makeTarget).
            OperatingSystem
                "/ generate the executable
                executeCommand:(makeCommand,' ',makeTarget,forceArg)
                inputFrom:nil
                outputTo:stdOut
                errorTo:stdErr
                inDirectory:(buildDirectory / module / directory)
                onError:[:status | self error:'make failed'].
        ]
    ]

    "Modified: / 06-06-2016 / 15:17:00 / cg"
!

objDirForUsedCompiler
    ^ self objDirForUsedCompiler:usedCompiler

    "Created: / 20-08-2012 / 17:01:13 / cg"
!

objDirForUsedCompiler:usedCompiler
    usedCompiler = 'gcc' ifTrue:[^ 'obj'].      "/ unix case

    usedCompiler = 'bcc' ifTrue:[^ 'objbc'].
    usedCompiler = 'vc' ifTrue:[^ 'objvc'].
    usedCompiler = 'tcc' ifTrue:[^ 'objtcc'].
    usedCompiler = 'lcc' ifTrue:[^ 'objlcc'].
    usedCompiler = 'mingw' ifTrue:[^ 'objmingw'].
    self halt:'please add compiler here'.
    ^ 'objbc'

    "Created: / 03-09-2012 / 19:55:34 / cg"
!

recursiveCopyDirectoryForBuild:subdir
    |targetDir|

    targetDir := buildDirectory / 'stx' / subdir.
    targetDir exists ifFalse:[
        targetDir makeDirectory.
    ].
    (mySTXTopDirectory / subdir) directoryContentsAsFilenamesDo:[:eachFile |
        eachFile recursiveCopyTo:(targetDir construct:eachFile baseName)
    ].
    self activityNotification:nil
!

setupBuildDirectory
    self activityNotification:('Setting up build directory %1' bindWith:buildDirectory pathName).

    buildDirectory exists ifFalse:[
        buildDirectory recursiveMakeDirectory.
    ].
    (buildDirectory / 'stx') exists ifFalse:[
        (buildDirectory / 'stx') makeDirectory.
    ].

    self copyDirectoryForBuild:'include'.
    self copyDirectoryForBuild:'rules'.

    OperatingSystem isUNIXlike ifTrue:[
        self recursiveCopyDirectoryForBuild:'configurations'.
    ]
!

validateBuildDirectoryIsPresent

    ^ self.

"/    [
"/        |default directoryIsOKForMe stc |
"/
"/        default := (buildDirectory ?
"/                          PreviousBuildDirectory)
"/                          ifNil:[ UserPreferences current buildDirectory].
"/
"/        buildDirectory := Dialog requestDirectoryName:'Temporary Work-ROOT for build:'
"/                                 default:default.
"/
"/        buildDirectory isEmptyOrNil ifTrue:[^ self].
"/        buildDirectory := buildDirectory asFilename.
"/        directoryIsOKForMe := true.
"/
"/        buildDirectory exists ifFalse:[
"/            Dialog warn:(self classResources string:'Work directory %1 does not exist.' with:buildDirectory).
"/            directoryIsOKForMe := false.
"/        ] ifTrue:[
"/            (buildDirectory construct:'stx') exists ifFalse:[
"/                Dialog warn:(self classResources stringWithCRs:'Work directory must contain an stx subDirectory,\which contains (at least) the stc and include subdirectories.').
"/                directoryIsOKForMe := false.
"/            ] ifTrue:[
"/                stc := (OperatingSystem isMSDOSlike) ifTrue:['stc.exe'] ifFalse:['stc'].
"/                (((buildDirectory construct:'stx')construct:'stc')construct:stc) exists ifFalse:[
"/                    Dialog warn:(self classResources stringWithCRs:'Work directory must contain an stc compiler in the stx/stc subDirectory.').
"/                    directoryIsOKForMe := false.
"/                ].
"/                ((buildDirectory construct:'stx')construct:'include') exists ifFalse:[
"/                    Dialog warn:(self classResources stringWithCRs:'Work directory must have had a make run before (for include files to exists).').
"/                    directoryIsOKForMe := false.
"/                ].
"/            ]
"/        ].
"/        directoryIsOKForMe
"/    ] whileFalse
! !

!ProjectBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

