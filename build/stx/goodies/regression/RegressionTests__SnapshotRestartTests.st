"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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

VMSpawningTestCase subclass:#SnapshotRestartTests
	instanceVariableNames:'packageDir exe tmpdir make'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

TestCase subclass:#ToRunOnFreshAndRestartedSnapshotTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SnapshotRestartTests
!

!SnapshotRestartTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SnapshotRestartTests methodsFor:'compilation'!

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
    "Modified: / 23-11-2017 / 23:16:28 / jv"
! !

!SnapshotRestartTests methodsFor:'private'!

do: setupBlock onRestartDo: restartBlock
    self assert: setupBlock byteCode notNil   description: 'setupBlock must have bytecode - stc-compiled blocks not supported'.
    self assert: restartBlock byteCode notNil description: 'restartBlock must have bytecode - stc-compiled blocks not supported'.

    self setUp.
    setupBlock value.
    Smalltalk addImageStartBlock:[
        [ 
            Stdout nextPutLine:'===> Restarted from snapshot'.
            restartBlock value.
            Smalltalk exit: EXIT_CODE_SUCCESS.
        ] fork
    ].
    Stdout nextPutLine:'===> Saving snapshot to ', testSelector , '.img'.
    ObjectMemory snapShotOn: testSelector , '.img'.
    Smalltalk exit: EXIT_CODE_SUCCESS.

    "Created: / 06-01-2017 / 22:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-01-2017 / 23:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2017 / 00:10:11 / jv"
!

performTest
    | imageFile |

    imageFile := tmpdir / (testSelector , '.img').

    self spawnSelector:#performTestInternal inDirectory:tmpdir.
    self assert: imageFile exists description: 'Image file does not exist - did test save it?'.

    "/ For debugging purposes, save output.txt
    ( tmpdir / 'output.txt' ) exists ifTrue:[ 
        (tmpdir / 'output.txt') moveTo: (tmpdir / 'output0.txt')
    ].

    self spawnSmalltalk: { '--image' . imageFile pathName } inDirectory: tmpdir.

    "/ If control reaches this point, the test was successful. In that case.
    "/ remove the temp directory.
    [ 
        tmpdir recursiveRemove
    ] on: Error do:[:ex | 
        OperatingSystem isMSWINDOWSlike ifTrue:[ 
            "/ Argh, Windows and its file locking...
            Delay waitForSeconds: 1.
            Error ignoreIn: [ tmpdir recursiveRemove ] .
        ] ifFalse:[ 
            ex reject.
        ].
    ].

    "Created: / 06-01-2017 / 22:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2017 / 09:35:37 / jv"
!

performTestInternal
    super performTest.

    "Created: / 06-01-2017 / 22:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTests methodsFor:'running'!

setUp
    super setUp.
    packageDir := Smalltalk getPackageDirectoryForPackage: #'stx:goodies/regression/testData/packages/snapshot_restart'.
    self assert: packageDir notNil.
    self assert: packageDir isDirectory.         
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
    tmpdir := Filename newTemporaryDirectory.
    exe := OperatingSystem pathOfSTXExecutable.
    self make:'clobber'.

    "Created: / 14-08-2013 / 18:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-01-2017 / 23:21:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-11-2017 / 23:16:35 / jv"
!

tearDown
    super tearDown.

    "/ No, don't remove the temp directory here. This is done in
    "/ #performTest and only if test is successful. If not, leave
    "/ it behind for debugging purposes.
    "/ tmpdir recursiveRemove.

    "Created: / 14-08-2013 / 20:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-02-2017 / 09:32:38 / jv"
! !

!SnapshotRestartTests methodsFor:'tests'!

test_bc
    "Test restart with bytecode-compiled package"

    | result |

    self do:[
        Display isNil ifTrue:[Smalltalk openDisplay].
        self skipIf: (OperatingSystem isMSWINDOWSlike and:[Display isNil]) description: 'No display available'.     
        result := ToRunOnFreshAndRestartedSnapshotTests buildSuite run.
        self assert: result errorCount == 0.
        self assert: result failureCount == 0.
    ] onRestartDo:[ 
        result := ToRunOnFreshAndRestartedSnapshotTests buildSuite run.
        self assert: result errorCount == 0.
        self assert: result failureCount == 0.
    ].

    "Created: / 14-08-2013 / 19:58:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2017 / 12:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_gui_reopening
    "
    Test that GUI reopens just fine.
    "
    | workspace browser |
    self do:[
    	Display isNil ifTrue:[Smalltalk openDisplay].
    	self skipIf: Display isNil description: 'No display available'.
        workspace := WorkspaceApplication new.
        workspace open.
        workspace window waitUntilVisible.
        browser := Tools::NewSystemBrowser new.
        browser open.
        browser window waitUntilVisible.

        self assert: workspace window notNil.
        self assert: workspace window reallyRealized.

        self assert: browser window notNil.
        self assert: browser window reallyRealized.       
    ] onRestartDo:[ 

    	Delay waitForSeconds: 1. "Give windows a chance to come up"
        self assert: workspace window notNil.
        self assert: workspace window reallyRealized.

        self assert: browser window notNil.
        self assert: browser window reallyRealized.       
    ].

    "Created: / 06-01-2017 / 23:44:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stc
    "Test restart with bytecode-compiled package"

    | result |

    self do:[
        Display isNil ifTrue:[Smalltalk openDisplay].
        self skipIf:(OperatingSystem isMSWINDOWSlike and:[Display isNil]) description: 'No display available'.     
        self make.
        result := ToRunOnFreshAndRestartedSnapshotTests buildSuite run.
        self assert: result errorCount == 0.
        self assert: result failureCount == 0.
    ] onRestartDo:[ 
        result := ToRunOnFreshAndRestartedSnapshotTests buildSuite run.
        self assert: result errorCount == 0.
        self assert: result failureCount == 0.
    ].

    "Created: / 14-08-2013 / 20:26:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2017 / 12:25:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2017 / 00:10:40 / jv"
! !

!SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests methodsFor:'running'!

setUp
    (Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') isNil ifTrue:[
        Smalltalk loadPackage: #'stx:goodies/regression/testData/packages/snapshot_restart'.
    ].

    "Created: / 14-08-2013 / 19:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests methodsFor:'tests'!

test_01

    "/ Use Smalltalk at: to workaround compiler bug...
    self assert: (Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') notNil.
    self assert: ((Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') new addSimple: 12 to: 12) == 24

    "Created: / 14-08-2013 / 19:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2013 / 08:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    "/ Use Smalltalk at: to workaround compiler bug...
    self assert: (Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') notNil.
    self assert: ((Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') new addUsingBlock: 10 to: 10) == 20

    "Created: / 14-08-2013 / 19:46:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2013 / 08:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests methodsFor:'tests - disabled'!

disabled_test_03
    "/ Not yet supported, but JV has an idea how to fix it :-)

    self assert: (Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') notNil.
    self assert: ((Smalltalk at: #'RegressionTests::SnapshotRestartTestsObject') new addThirteenUsingRememberedBlockTo: 2) == 15

    "Created: / 14-08-2013 / 19:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2013 / 08:20:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTests class methodsFor:'documentation'!

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
    ^ '$Id$'
! !

