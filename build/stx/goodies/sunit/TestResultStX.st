"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestResult subclass:#TestResultStX
	instanceVariableNames:'endTime'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Smalltalk/X'
!


!TestResultStX class methodsFor:'utilities'!

sourceFilenameOfClass:aClass
    "that is ST/X specific"
    "no Smalltalk/X dialect detection needed..."

    |sourceStream testClassSourceFile|

    sourceStream := aClass sourceStream.
    sourceStream notNil ifTrue:[
        [
            sourceStream := sourceStream stream.
            sourceStream isFileStream ifTrue:[
                testClassSourceFile := sourceStream pathName asFilename pathName.
            ].
        ] ensure:[
            sourceStream notNil ifTrue:[ sourceStream close ].
        ]
    ].
    ^ testClassSourceFile
! !

!TestResultStX methodsFor:'accessing'!

endTime
    ^ endTime
!

endTime:aTimestamp
    "sets the overall (suite) end time"

    endTime := aTimestamp.
!

executionTime
    "return the execution time (in seconds). If asked before or during a run, return nil"

    |t1 t2|

    (t1 := self startTime) isNil ifTrue:[^ nil].
    (t2 := self endTime) isNil ifTrue:[^ nil].
    ^ t2 secondDeltaFrom: t1

    "
     |a b|

     a := Timestamp now.
     Delay waitForMilliseconds:567.
     b := Timestamp now.
     b - a   
    "
!

startTime
    ^ timestamp
!

startTime:aTimestamp
    "sets the overall (suite) start time"

    timestamp := aTimestamp.
! !

!TestResultStX methodsFor:'outcome'!

printLineForContextForJavaCompatibleStackTrace:con on:aStream
    "why in java-backtrace format?
     Because then jenkins will be able to extract sourcefile and linenumber
     and generate links in the report page.
     I am not willing to write another plugin for this - using junit compatible format"

    |cls classSourceStream method s lineNumberOfMethod lineNumberInFile relPath methodSourcePosition|

    "/ used to be:
    "/ con printOn:aStream.

    "/ be careful: some tests generate methods on the fly, which are unbound!!
    "/ or even (javascript/other languages) may not have a method at all!!!!

    con fixAllLineNumbers.
    (method := con method) notNil ifTrue:[
        cls := method mclass.
        cls notNil ifTrue:[
            relPath := cls package copyReplaceAll:$: with:$/.
            relPath := relPath asUnixFilenameString.
            relPath := (relPath asFilename construct:cls theNonMetaclass classFilename) name.

            method isJavaMethod ifTrue:[
                lineNumberOfMethod :=  method lineNumberForPC0: 0.
            ] ifFalse:[
                methodSourcePosition := method sourcePosition.
                methodSourcePosition notNil ifTrue:[
                    classSourceStream := cls sourceStream.
                    classSourceStream notNil ifTrue:[
                        "/ sigh - we have the lineNumber within the method,
                        "/ and the characterPosition of the method's start.
                        "/ need to calculate the absolute lineNumber in the file
                        s := LineNumberReadStream on:classSourceStream "(classSourceFile asFilename readStream)".
                        [
                            [s atEnd not and:[s position < methodSourcePosition]] whileTrue:[
                                s nextLine
                            ].
                            lineNumberOfMethod := s lineNumber.
                        ] ensure:[
                            s close.
                        ].
                    ].
                ]
            ]
        ].
    ].

    "/ output something (will not generate a ref to the source file)
    con printReceiverOn:aStream.
    aStream nextPutAll:' >> '.
    con selector printOn:aStream.
    aStream nextPutAll:' ['.
    con lineNumber printOn:aStream.
    aStream nextPut:$].

    relPath notNil ifTrue:[
        lineNumberOfMethod notNil ifTrue:[
            lineNumberInFile := lineNumberOfMethod + con lineNumber - 1.
            aStream nextPutAll:(' (%1:%2)'
                                bindWith: relPath
                                with: lineNumberInFile)
        ] ifFalse:[
            aStream nextPutAll:(' (%1)'
                                bindWith: relPath)
        ].
    ].
    aStream cr.

    "Modified: / 05-08-2012 / 12:00:00 / cg"
    "Modified: / 12-11-2013 / 23:09:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberEndTime
    "remembers the endTime of the current test (in outcome)"

    ^outcome endTime: Timestamp now

    "Created: / 16-08-2011 / 17:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberException:ex
    "Called when a test fails. testCase is the failed 
     testcase, ex is platform specific object describing 
     the failure. Actually, on all platforms exept GemStone, 
     ex is an instance of an exception that caused the failure"

    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        "Do not remember the exception itself as it would prevent objects from
         being garbage collected. Also do not collect backtrace as most of the
         time nobody's interested in it.

         Keep in mind, that standalone test runner uses it's own testresult
         to remember stacktraces for reports. See Builder::TestRunner."
        outcome exceptionDetail:(Dictionary new
                                    at:#exception put:ex creator;
                                    at:#description put:ex description;
                                    yourself).
        ^ self.
    ].

    "add other dialect specifics here"

    "Created: / 06-08-2011 / 11:29:23 / cg"
    "Created: / 16-08-2011 / 17:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-09-2015 / 08:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberOutput: aString
    outcome collectedOutput: aString

    "Created: / 16-08-2011 / 18:18:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberStartTime
    "remembers the startTime of the current test (in outcome)"

    ^outcome startTime: Timestamp now

    "Created: / 16-08-2011 / 17:36:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResultStX methodsFor:'running'!

performCase: aTestCase
    "while performing a testcase, any output to the Transcript is also
     collected and is attached to the test result. Nice when tests are executed
     automatically, for example by jenkins.
     Q: I think, we MUST lock this, 
        or better: acquire the lock and making collecting explicit via
                   call to 'self collectingTranscriptOutputDo:[...]' in the testcase.
        Otherwise we'll run into trouble, when executing multiple tests in parallel.
"

    |savedStdout savedTranscript collector|

    savedStdout := Stdout.
    savedTranscript := Transcript.
    collector := CharacterWriteStream new:100.
    [
        Stdout := SplittingWriteStream on:collector and: Stdout.
        Transcript := SplittingWriteStream on:collector and: Transcript.
        super performCase: aTestCase.
    ] ensure:[
        Stdout := savedStdout.
        Transcript := savedTranscript.
        self rememberOutput: collector contents.
    ].

    "Created: / 16-08-2011 / 18:18:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 29-08-2013 / 11:15:36 / cg"
! !

!TestResultStX class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

