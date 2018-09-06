"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MakefileTests
	instanceVariableNames:'package packageDir make'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

StandaloneStartup subclass:#TestApplication01StartUp
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MakefileTests
!

StandaloneStartup subclass:#TestIssue214StartUp
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MakefileTests
!

!MakefileTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
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
    This testcase tests St/X makefiles used to build
    standalone applications.

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!MakefileTests methodsFor:'compilation'!

make
    ^ self make:''.

    "Created: / 14-08-2013 / 18:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make: target
    | cmd output success |

    cmd := make , ' ' , target.
    output := String streamContents:[ :s|
        success := OperatingSystem executeCommand: cmd outputTo: s inDirectory: packageDir
    ].
    "/ Following is just to ease debugging on Jenkins since stdout
    "/ is shown in the report.
    success ifFalse:[ 
        Stdout nextPutLine: 'Failed to make target ''', target, ''' in test package'.
        Stdout nextPutLine: output.
    ].
    self
        assert: success
        description: 'Failed to make target ''', target, ''' in test package'.

    "Created: / 14-08-2013 / 18:26:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-11-2016 / 00:22:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-11-2017 / 20:35:31 / jv"
! !

!MakefileTests methodsFor:'running'!

setUp
    OperatingSystem isMSWINDOWSlike ifTrue:[
        "/ Hack: generally we don't require Borland tools to be installed anymore.
        "/ However, package build on Windows is driwen by Borland make so we distribute
        "/ it with rakefiles. It's likely not in the PATH, so add it.
        "/ This code assumes the test is run from build environment.
        | path separator binDir mingwBinDir |

        separator := OperatingSystem isMSWINDOWSlike ifTrue:[$;] ifFalse:[$:].
        path := ((OperatingSystem getEnvironment: 'PATH') ? '') tokensBasedOn: separator. 
        binDir := (OperatingSystem pathOfSTXExecutable asFilename directory / '..' / '..' / '..' / '..' / 'bin') pathName.

        STCCompilerInterface getCCDefine = '__BORLANDC__' ifTrue:[ 
            make := 'bmake.bat'
        ].
        STCCompilerInterface getCCDefine = '__MINGW32__' ifTrue:[ 
            (OperatingSystem getEnvironment: 'MINGW_DIR') isNil ifTrue:[
                | mingwDir |

                mingwDir := #('C:\MSYS64\MINGW32' 'C:\MINGW') detect:[:path | path asFilename isDirectory ] ifNone: [ nil ].
                self assert: mingwDir notNil description: 'MINGW_DIR environment variable not set and MINGW32 not found at standard places'.
                OperatingSystem setEnvironment: 'MINGW_DIR'     to: mingwDir.
            ].
            OperatingSystem setEnvironment: 'MINGW'         to: '__MINGW32__'.
            OperatingSystem setEnvironment: 'USEMINGW_ARG'  to: '-DUSEMINGW32'.
            make := 'mingwmake.bat'.
        ].
        STCCompilerInterface getCCDefine = '__MINGW64__' ifTrue:[ 
            (OperatingSystem getEnvironment: 'MINGW_DIR') isNil ifTrue:[ 
                | mingwDir |

                mingwDir := #('C:\MSYS64\MINGW64' 'C:\MINGW64') detect:[:path | path asFilename isDirectory ] ifNone: [ nil ].
                self assert: mingwDir notNil description: 'MINGW_DIR environment variable not set and MINGW64 not found at standard places'.
                OperatingSystem setEnvironment: 'MINGW_DIR'     to: mingwDir.   
            ].
            OperatingSystem setEnvironment: 'MINGW'         to: '__MINGW64__'.
            OperatingSystem setEnvironment: 'USEMINGW_ARG'  to: '-DUSEMINGW64'.
            make := 'mingwmake.bat'.

        ].
        mingwBinDir := (OperatingSystem getEnvironment: 'MINGW_DIR') , '\bin'.
        (path includes: mingwBinDir) ifFalse:[path addLast: mingwBinDir].
        (path includes: binDir) ifFalse:[path addFirst: binDir].
        OperatingSystem setEnvironment: 'PATH' to: (path asStringWith:$;)
    ] ifFalse:[
        make := 'make -f Makefile.init'
    ].



    self setUpForPackage:('tmp:', testSelector) asSymbol.

    "Created: / 19-11-2013 / 12:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-11-2017 / 20:34:37 / jv"
    "Modified: / 30-05-2018 / 14:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUpForPackage: pkg
    | components |
    package := pkg.
    packageDir := (Smalltalk getPackageDirectoryForPackage: Object package) directory directory.
    components := (package copyReplaceAll: $: with:$/) tokensBasedOn: $/.
    components do:[:each |
	packageDir := packageDir / each.
    ].
    packageDir exists ifTrue:[
	packageDir recursiveRemove.
    ].
    packageDir recursiveMakeDirectory

    "Created: / 24-11-2013 / 22:23:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MakefileTests methodsFor:'tests'!

test_application_01a
    <timeout: 600> "600sec = 10min"

    self compile:(Array with:TestApplication01StartUp) type:ProjectDefinition nonGuiApplicationType.

    "Created: / 30-05-2018 / 14:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 31-05-2018 / 21:39:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_application_01b
    <timeout: 600> "600sec = 10min"

    self setUpForPackage:('tmp:' , testSelector , '/' , testSelector) asSymbol.
    self compile:(Array with:TestApplication01StartUp) type:ProjectDefinition nonGuiApplicationType.

    "Created: / 30-05-2018 / 14:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 31-05-2018 / 21:39:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MakefileTests methodsFor:'tests -  regression'!

test_issue_214a
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/214
    "
    <timeout: 600> "600sec = 10min"

    | exe |

    Screen current isNil ifTrue:[
        Smalltalk openDisplay.
    ].
    self skipIf:Screen current isNil description:'No display connection'.

    exe := self compile:(Array with:TestIssue214StartUp) type:ProjectDefinition guiApplicationType.
    self assert: (OperatingSystem executeCommand: exe)

    "Created: / 30-05-2018 / 14:52:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-05-2018 / 21:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MakefileTests methodsFor:'tests-helpers'!

compile: classes type:packageType
    "
    Create a new application package with copy of given classes
    and compile it. Return the path to compiled executable.
    "
    | packageDef  startup executable |

    "/ Compile all classes...
    Class packageQuerySignal answer:package do:[
        classes do:[:cls |
                | copy |

                copy := cls superclass
                        subclass: cls nameWithoutPrefix
                        instanceVariableNames:(cls instVarNames asStringWith:' ')
                        classVariableNames:(cls classVarNames asStringWith:' ')
                        poolDictionaries:cls poolDictionaries
                        category:'** tmp **'.
                cls methodDictionary do:[:each |
                    copy compile:each source classified:each category.
                ].
                cls class methodDictionary do:[:each |
                    copy class compile:each source classified:each category.
                ].
                (copy inheritsFrom:StandaloneStartup) ifTrue:[
                    startup := copy.
                ].
            ].
        ].

    "/ Create project definition class.
    Class packageQuerySignal answer:package do:[
        packageDef := ProjectDefinition
                definitionClassForPackage:package
                projectType:packageType
                createIfAbsent:true.

        packageDef class compile:'applicationIconFileName ^ nil'.
        packageDef theNonMetaclass
            forEachContentsMethodsCodeToCompileDo:[:code :category | packageDef theMetaclass compile:code classified:category ]
            "/ignoreOldEntries: false
            ignoreOldDefinition: false.
        packageDef isApplicationDefinition ifTrue:[
            packageDef class compile:'startupClassName ^ ' , startup fullName storeString.
        ].
    ].
    "/ Fileout to package directory...

    packageDef classes do:[:class |
        | container |

        container := (class fullName copyReplaceAll:$: with:$_) , '.st'.
        (packageDir / container)
            writingFileDo:[:f |
                AbstractSourceCodeManager
                    fileOutSourceCodeOf:class
                    on:f
                    withTimeStamp:false
                    withInitialize:true
                    withDefinition:true
                    methodFilter:[:mth | mth package = package ]
            ]
    ].

    "/ Generate build support files...

    packageDef fileNamesToGenerate keys do:[:filename |
        | contents file |

        contents := packageDef generateFile:filename.
        contents notNil ifTrue:[ 
            file := (packageDir / filename).
            file directory recursiveMakeDirectory.
            file writingFileDo:[:f | f nextPutAll: contents].
        ]
    ].

    self make.
    executable := (Smalltalk getPackageDirectoryForPackage: package) / (OperatingSystem isMSWINDOWSlike ifTrue:[packageDef applicationNameConsole] ifFalse:[ packageDef applicationName ]).
    self assert: executable exists.
    self assert:(OperatingSystem canExecuteCommand: executable pathName).
    ^ executable pathName

    "Created: / 30-05-2018 / 14:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MakefileTests::TestApplication01StartUp class methodsFor:'startup-to be redefined'!

main:args
    args isEmpty ifTrue:[
	Smalltalk exit: 0.
    ].
    args size ~~ 1 ifTrue:[
	Smalltalk exit: 127.
    ].

    [
	Smalltalk exit: args first asInteger.
    ] on: Error do:[:ex|
	Smalltalk exit: 126.
    ].

    "Created: / 19-11-2013 / 13:12:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MakefileTests::TestIssue214StartUp class methodsFor:'startup-to be redefined'!

main:args
    [  
        Smalltalk ignoreAssertions: false.
        Display isNil ifTrue:[ Smalltalk openDisplay ].
        SimpleView setDefaultStyle.

        Stdout nextPutAll: 'Smalltalk packagePath   "/ -> '; nextPutLine: Smalltalk packagePath storeString.
        Stdout nextPutAll: 'Smalltalk realSystemPath"/ -> '; nextPutLine: Smalltalk realSystemPath storeString.
        Stdout nextPutAll: 'SimpleView defaultStyle "/ -> '; nextPutLine: SimpleView defaultStyle storeString.
        Stdout nextPutAll: 'SimpleView styleSheet name"/ -> '; nextPutLine: SimpleView styleSheet name storeString.

        self assert: SimpleView defaultStyle notNil description: 'SimpleView defaultStyle == nil'.
        self assert: (SimpleView styleSheet fileReadFailed not) description: 'SimpleView styleSheet fileReadFailed not'.
    ] on: Error do:[:ex | 
        Stderr nextPutAll: 'ERROR '; nextPutLine: ex description.
        ex suspendedContext fullPrintAllOn: Stderr.  
        Smalltalk exitIfStandalone: 1.
    ].
    Smalltalk exitIfStandalone
    "
    TestIssue214StartUp main: #()
    "

    "Created: / 30-05-2018 / 14:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2018 / 09:39:11 / jv"
! !

!MakefileTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

