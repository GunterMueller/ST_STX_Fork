"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017-2018 Jan Vrany
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

TestCase subclass:#VMSpawningTestCase
	instanceVariableNames:''
	classVariableNames:'EXIT_CODE_SUCCESS EXIT_CODE_FAILURE EXIT_CODE_ERROR
		EXIT_CODE_SKIPPED'
	poolDictionaries:''
	category:'tests-Regression-Abstract'
!

!VMSpawningTestCase class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017-2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!VMSpawningTestCase class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    EXIT_CODE_SUCCESS := 0.
    EXIT_CODE_FAILURE := 1.
    EXIT_CODE_ERROR := 2.
    "/ Never define EXIT_CODE_SKIPPED as 3. On Windows,
    "/ 3 is used by abort() so then we'd not be able to
    "/ tell between skip and crash!! Sigh.
    EXIT_CODE_SKIPPED := 97.

    "Modified: / 03-09-2016 / 08:23:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2016 / 12:44:05 / jv"
! !

!VMSpawningTestCase class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RegressionTests::VMSpawningTestCase.
! !

!VMSpawningTestCase methodsFor:'private'!

spawnSelector:selector 
    "Perform selector in freshly spawned Smalltalk."
    
    | tempDir |

    [
        tempDir := Filename newTemporary.
        tempDir makeDirectory.
        self spawnSelector:selector inDirectory:tempDir.
    ] ensure:[
        (tempDir notNil and:[ tempDir exists ]) ifTrue:[
            [
                tempDir recursiveRemove.
            ] on:Error
                    do:[:ex | 
                OperatingSystem isMSWINDOWSlike ifFalse:[
                    ex reject.
                ].
            ]
        ].
    ].

    "Created: / 05-01-2017 / 23:08:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-01-2017 / 22:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnSelector:selector inDirectory:directory 
    "Perform `selector` in new smalltalk process. Set new process's working directory to `directory`"
    
    | testcaseFile script |

    directory makeDirectory.
    testcaseFile := directory 
            / ((Smalltalk fileNameForClass:self class) , '.st').
    self class fileOutAs:testcaseFile.
    script := 'NoHandlerError emergencyHandler:[:ex |
                    ex suspendedContext fullPrintAllOn: Stdout.
                    Stdout nextPutAll: ''ERROR (unhandled) '', ex printString.
                    Smalltalk exit: %7
               ].
               Smalltalk packagePath: %1.
               Smalltalk loadPackage:%2.
               Smalltalk fileIn: %3.
               Smalltalk addStartBlock:[
                   Processor exitWhenNoMoreUserProcesses: false.                   
                   [
                       (%4 selector: %5) spawnSelectorInternal: %6.                   
                   ] ensure:[
                       Smalltalk exit: %7
                   ]
               ].
               ' 
            bindWith:Smalltalk packagePath asArray storeString
            with:self class package storeString
            with:testcaseFile pathName storeString
            with:self class name
            with:testSelector storeString
            with:selector storeString
            with:EXIT_CODE_ERROR storeString.
    (directory / 'run.st') writingFileDo:[:f | f nextPutAll:script. ].
    self spawnSmalltalk: { '--abortOnSEGV'. '-I'. '--quick'. '--load'. (directory / 'run.st') pathName } inDirectory: directory

    "Created: / 06-01-2017 / 22:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-01-2017 / 19:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnSelectorInternal:selector 
    [
        [
            self perform:selector.
            Stdout
                cr;
                nextPutAll:'PASSED';
                cr.
            Smalltalk exit:EXIT_CODE_SUCCESS
        ] on:TestResult skipped
                do:[:skip | 
            Stdout
                cr;
                nextPutAll:'SKIPPED';
                cr.
            Smalltalk exit:EXIT_CODE_SKIPPED.
        ]
    ] on:TestResult failure
            do:[:failure | 
        Stdout
            cr;
            nextPutAll:'FAILURE: ';
            nextPutAll:failure description;
            cr.
        Smalltalk exit:EXIT_CODE_FAILURE.
    ]
            on:TestResult exError
            do:[:error | 
        Stdout
            cr;
            nextPutAll:'ERROR: ';
            nextPutAll:error description;
            cr.
        Smalltalk exit:EXIT_CODE_ERROR.
    ].

    "Created: / 05-01-2017 / 23:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnSmalltalk:argv
    | tempDir |
    [
        tempDir := Filename newTemporary.
        tempDir makeDirectory.
        self spawnSmalltalk:argv inDirectory:tempDir.
    ] ensure:[
        (tempDir notNil and:[ tempDir exists ]) ifTrue:[
            [
                tempDir recursiveRemove.
            ] on:Error
                    do:[:ex | 
                OperatingSystem isMSWINDOWSlike ifFalse:[
                    ex reject.
                ].
            ]
        ].
    ].

    "Created: / 17-04-2018 / 15:56:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnSmalltalk:argv inDirectory:directory 
    "
     A helper method to spawn a new smalltalk process using current executable and
     given arguments (in `argv`). Set initial working copy of freskly spawned process
     to `directory`. Wait until spawned smalltalk finishes and then if process exit status

      * is EXIT_CODE_SUCCESS do nothing and return
      * is EXIT_CODE_SKIPPED then signal skipped test by means of #skipIf:description:
      * is EXIT_CODE_FAILURE then signal test failure by means of failed #assert:
      * is anything else then signal test error by means of #error:"
    
    | exe  args  environment  outputFile  output  pid  blocker  status |

    exe := OperatingSystem pathOfSTXExecutable.
    args := { exe } , #('--abortOnSEGV') , argv , #('--no-preferences').
    OperatingSystem isMSWINDOWSlike ifTrue:[
        args := String 
                streamContents:[:s | 
                    args 
                        do:[:each | 
                            s
                                nextPut:$";
                                nextPutAll:each;
                                nextPut:$"
                        ]
                        separatedBy:[ s space ]
                ]
    ].
    outputFile := directory / 'output.txt'.
    output := outputFile writeStream.
    environment := OperatingSystem isUNIXlike ifTrue:[
            OperatingSystem getEnvironment copy
        ] ifFalse:[
            environment := Dictionary new
        ].
    blocker := Semaphore new.
    Processor 
        monitor:[
            pid := OperatingSystem 
                    exec:exe
                    withArguments:args
                    environment:environment
                    fileDescriptors:{
                            0.
                            output fileDescriptor.
                            output fileDescriptor
                        }
                    fork:true
                    newPgrp:false
                    inDirectory:directory pathName
                    showWindow:true
        ]
        action:[:s | 
            status := s.
            blocker signal.
        ].
    output close.
    pid isNil ifTrue:[
        self error:'Failed to spawn test'.
        ^ self.
    ].
    [
        blocker wait.
        status code == EXIT_CODE_SUCCESS ifFalse:[
            status code == EXIT_CODE_SKIPPED ifTrue:[
                self skipIf:true description:'Skipped'.
            ] ifFalse:[
                status code == EXIT_CODE_FAILURE ifTrue:[
                    "
                    (directory / 'output.txt') contents asString
                    "
                    self writeFile: outputFile to: Stdout labeled: 'TEST FAILED'.
                    self assert:false description:'Assertion failed, see log'.
                ] ifFalse:[
                    "
                    directory inspect
                    "
                    self writeFile: outputFile to: Stdout labeled: 'TEST ERROR'.                 
                    self error:'Error occured'.
                ].
            ].
        ].
    ] on: TerminateProcessRequest do:[:ex|
        pid notNil ifTrue:[ OperatingSystem killProcess: pid ].
        self writeFile: outputFile to: Stdout labeled: 'TEST TERMINATED'.
        ex pass.
    ].

    "Created: / 06-01-2017 / 11:25:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-07-2017 / 10:55:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-11-2017 / 14:03:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-01-2018 / 16:26:09 / jv"
!

writeFile: aFilename to: aStream labeled: aString
    "
    Write contents of given `aFilename` to given `aStream` with given label (`aString`).
    Utility method for spawnSmalltalk:inDirectory: to ease the debugging.
    "
    aStream
            nextPutAll: '== ';
            nextPutAll: aString;
            nextPutAll: ' (testcase ';
            nextPutAll: self printString;
            nextPutLine:') =='.
    aFilename isNil ifTrue:[
        aStream nextPutLine: 'No file given!!'
    ] ifFalse:[ aFilename exists ifFalse:[
        aStream nextPutAll: 'File does not exist: '; nextPutLine: aFilename pathName
    ] ifTrue:[
        aFilename readingFileDo:[:s | 
            [ s atEnd ] whileFalse:[ aStream nextPutLine:s nextLine.].
        ].
    ]].

    "Created: / 28-07-2017 / 10:48:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMSpawningTestCase class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


VMSpawningTestCase initialize!
