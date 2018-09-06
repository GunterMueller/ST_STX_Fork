"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MessageTally
	instanceVariableNames:'tree probes ntally theBlock spyInterval executing startTime
		endTime'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!MessageTally class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    MessageTally allows profiling excution of a block; 
    statistic of method evaluation is output on Transcript.
    To get statistic, use 'MessageTally spyOn:aBlock'.

    By default, probing is done every 10ms (i.e. the execution of the block is 
    interrupted every 10ms, and the context chain analyzed).

    For better resolution, use smaller clock ticks (if your OperatingSystem
    supports it). Try 'spyDetailedOn:aBlock', which tries to measure things
    every 1ms. 
    (Notice, that some OS's do not provide this timer resolution,
     so measuring may be less accurate.)

    For good results, make certain that the measured block runs for some
    time (say 5 seconds) - add a timesRepeat-loop around it if required.

    The displayed information is:
        - the calling tree augmented with total and leaf times.
          the leaf time is the time spent in the method itself;
          the total time is the time spent in the method and all of its called
          methods.

        - the leaf methods by receiver
          this lists the leaf nodes only, sorted by time spent there.
          Here, method invocations for different receiver types are
          listed separately.

        - the leaf methods
          this lists the leaf nodes only, sorted by time spent there.
          Here, method invocations for different receiver types are
          summed up separately.

    The last list (leaf methods) is propably the most interesting;
    if you are only interested in that (or the calling hierarchy is too
    deep for the list to be useful or the amount of data to be handled
    correctly), use a leaf-spy with:
        MessageTally spyLeafOn:aBlock
    This only accumulates statistics about methods where the cpu time
    is actually spent (not collecing hierarchy information).


    [author:]
        Claus Gittinger

    [see also:]
        CallChain ProfileTree
        MessageTracer
"
!

examples
"
  the block must execute for a while;
  otherwise, no probes (and therefore no statistics) can
  be gathered:
                                                                        [exBegin]
     MessageTally spyOn:[ #(6 5 4 3 2 1) copy sort ]
                                                                        [exEnd]


  if required, execute the block in a loop;
  however, for the example below, a larger repeat count
  is required, for a reasonable measurement:
                                                                        [exBegin]
     MessageTally spyOn:[
        10000 timesRepeat:[ #(6 5 4 3 2 1) copy sort] 
     ]
                                                                        [exEnd]


  that's better:
                                                                        [exBegin]
     MessageTally spyOn:[
        100000 timesRepeat:[ #(6 5 4 3 2 1) copy sort] 
     ]
                                                                        [exEnd]


  that's much better
                                                                        [exBegin]
     MessageTally spyOn:[
        500000 timesRepeat:[#(6 5 4 3 2 1) copy sort] 
     ]
                                                                        [exEnd]


  a smaller probing tick also helps:
                                                                        [exBegin]
     MessageTally spyDetailedOn:[
        500000 timesRepeat:[(10 to:1 by:-1) asArray reverse] 
     ]
                                                                        [exEnd]


  as usual, measurements add some extra overhead;
  compare the above time to the time given by:
                                                                        [exBegin]
     Transcript showCR:(
         Time millisecondsToRun:[
            500000 timesRepeat:[#(6 5 4 3 2 1) copy sort] 
         ]
     )
                                                                        [exEnd]
  probing the leafs only may help to reduce the overhead
  a bit:
                                                                        [exBegin]
     MessageTally spyLeafDetailedOn:[
        500000 timesRepeat:[#(6 5 4 3 2 1) copy sort] 
     ]
                                                                        [exEnd]




                                                                        [exBegin]
     MessageTally spyOn:[SystemBrowser open ]
                                                                        [exEnd]


                                                                        [exBegin]
     MessageTally spyDetailedOn:[SystemBrowser open ]
                                                                        [exEnd]
"
! !


!MessageTally class methodsFor:'constants'!

detailedSamplingIntervalMS
    ^ 1
!

normalSamplingIntervalMS
    ^ 10
! !


!MessageTally class methodsFor:'spying-private'!

spyLeafOn:aBlock interval:ms to:outStream
    "evaluate aBlock and output leaf method statistics on outStream.
     Return the value from aBlock."

    |aTally retVal|

    aTally := self new.

    [
        [
            retVal := aTally spyLeafOn:aBlock interval:ms.
        ] ifCurtailed:[
            outStream nextPutLine:'TALLY: block returned'.
        ]
    ] ensure:[
        aTally printLeafStatisticOn:outStream
    ].
    ^ retVal

    "Modified: 22.3.1997 / 16:50:47 / cg"
!

spyOn:aBlock interval:ms to:outStream
    "evaluate aBlock and output full statistics on outstream.
     Return the value from aBlock."

    |aTally retVal|

    aTally := self new.

    [
        [
            retVal := aTally spyOn:aBlock interval:ms.
        ] ifCurtailed:[
            outStream nextPutLine:'TALLY: block returned'.
        ]
    ] ensure:[
        aTally printFullStatisticOn:outStream
    ].
    ^ retVal

    "Modified: 22.3.1997 / 16:54:36 / cg"
! !


!MessageTally class methodsFor:'spying-public interface'!

spyDetailedOn:aBlock
    "evaluate aBlock and output full statistics on the Transcript.
     The Tick is 1ms for more detailed measurement.
     Notice: not all architectures support such a small timer interval."

    ^ self spyOn:aBlock interval:(self detailedSamplingIntervalMS) to:Transcript

    "Modified: 22.3.1997 / 16:26:39 / cg"
!

spyLeafDetailedOn:aBlock
    "evaluate aBlock and output leaf method statistics on the Transcript.
     The Tick is 1ms for more detailed measurement.
     Notice: not all architectures support such a small timer interval."

    ^ self spyLeafOn:aBlock interval:(self detailedSamplingIntervalMS) to:Transcript

    "Created: 20.3.1997 / 20:41:53 / cg"
    "Modified: 22.3.1997 / 16:26:47 / cg"
!

spyLeafOn:aBlock
    "evaluate aBlock and output leaf method statistics on the Transcript.
     The Tick is 10ms for less detailed measurements."

    ^ self spyLeafOn:aBlock interval:(self normalSamplingIntervalMS) to:Transcript

    "Created: 20.3.1997 / 20:41:40 / cg"
    "Modified: 22.3.1997 / 16:26:49 / cg"
!

spyOn:aBlock
    "evaluate aBlock and output full statistics on the Transcript.
     The Tick is 10ms for less detailed measurements."

    ^ self spyOn:aBlock interval:(self normalSamplingIntervalMS) to:Transcript

    "Modified: 22.3.1997 / 16:26:51 / cg"
! !


!MessageTally methodsFor:'accessing'!

endTime
    "return the endTime of the run"

    ^ endTime

    "Modified: 18.5.1996 / 18:47:47 / cg"
    "Created: 22.3.1997 / 16:44:29 / cg"
!

nTally 
    "return the number of accumulated probes"

    ^ ntally

    "Modified: 18.5.1996 / 18:47:47 / cg"
!

probes
    "return the accumulated collection of flat probes"

    ^ probes

    "Modified: 18.5.1996 / 18:47:57 / cg"
    "Created: 20.3.1997 / 20:54:19 / cg"
!

startTime
    "return the startTime of the run"

    ^ startTime

    "Modified: 18.5.1996 / 18:47:47 / cg"
    "Created: 22.3.1997 / 16:44:33 / cg"
!

tree
    "return the accumulated calling tree"

    ^ tree

    "Modified: 18.5.1996 / 18:47:57 / cg"
! !


!MessageTally methodsFor:'printing & storing'!

printFlatMethodLeafsOn:aStream
    "print all flat method leafNodes statistics on aStream"

    |leafNodes|

    leafNodes := OrderedCollection new.
    probes do:[:aProbe | aProbe addMethodLeafNodesTo:leafNodes].
    leafNodes := leafNodes asSortedCollection:[:a :b |
                                        a leafTally < b leafTally].
    leafNodes do:[:aNode |
        aNode leafTally ~= 0 ifTrue:[
            aNode printSingleMethodLeafOn:aStream.
            aStream cr.
        ]
    ].

    "Created: 20.3.1997 / 20:56:13 / cg"
    "Modified: 21.3.1997 / 10:18:31 / cg"
!

printFullStatisticOn:outStream
    "output full statistics on outstream"

    |runTime err|

    ntally == 0 ifTrue:[
        self printNoProbesOn:outStream.
        ^ self
    ].

    tree computePercentage:ntally.

    runTime := endTime - startTime.

    outStream cr.
    err := (1000 // ntally / 10.0).
    err > 0 ifTrue:[
        outStream nextPutLine:('total execution time: '
                           , runTime printString , ' ms '
                           , '(' , ntally printString , ' probes ;'
                           , ' error ' 
                           , (1000 // ntally / 10.0) printString
                           , '%)'
                          ).
    ] ifFalse:[
        outStream nextPutLine:('total execution time: '
                           , runTime printString , ' ms '
                           , '(' , ntally printString , ' probes)'
                          ).
    ].

    outStream cr.
    tree printOn:outStream.
    outStream cr; cr.

    outStream nextPutLine:'leafs of calling tree (by receiver & implementing method):'.
    outStream cr.
    tree printLeafsOn:outStream.
    outStream cr; cr.

    outStream nextPutLine:'method leafs of calling tree (by implementing method only):'.
    outStream cr.
    tree printMethodLeafsOn:outStream.
    outStream cr; cr.

    "Created: 22.3.1997 / 16:52:09 / cg"
    "Modified: 22.3.1997 / 16:53:38 / cg"
!

printLeafStatisticOn:outStream
    "output leaf statistics on outstream"

    |runTime err|

    ntally == 0 ifTrue:[
        self printNoProbesOn:outStream.
        ^ self.
    ].

    runTime := endTime - startTime.

    probes do:[:aProbe |
        aProbe computePercentage:ntally
    ].

    outStream cr.
    err := (1000 // ntally / 10.0).
    err > 0 ifTrue:[
        outStream nextPutLine:('total execution time: '
                           , runTime printString , ' ms '
                           , '(' , ntally printString , ' probes ;'
                           , ' error ' 
                           , (1000 // ntally / 10.0) printString
                           , '%)'
                          ).
    ] ifFalse:[
        outStream nextPutLine:('total execution time: '
                           , runTime printString , ' ms '
                           , '(' , ntally printString , ' probes)'
                          ).
    ].

    outStream nextPutLine:'method leafs of calling tree:'.
    outStream cr.
    self printFlatMethodLeafsOn:outStream.
    outStream cr; cr.

    "Created: 22.3.1997 / 16:50:06 / cg"
    "Modified: 22.3.1997 / 16:53:15 / cg"
!

printNoProbesOn:outStream
    "output a message that no probes are present"

    outStream cr.
    outStream nextPutLine:'TALLY: No probes - execution time too short;'.
    outStream nextPutLine:'TALLY: retry using: spyOn:[n timesRepeat:[...]]'.

    "Created: 22.3.1997 / 16:53:23 / cg"
! !


!MessageTally methodsFor:'private'!

execute
    "evaluate the target block"

    executing := true.
    ^ theBlock value

    "Modified: 20.3.1997 / 21:36:27 / cg"
! !


!MessageTally methodsFor:'probing'!

count:aContext
    "entered whenever the probed block gets interrupted;
     look where it is, and remember in the calling tree"

    "{ Pragma: +optSpeed }"

    |chain|

    chain := CallChain 
                callChainTo:aContext 
                stopAtCallerForWhich:[:con |
                    (con receiver == self) and:[con selector == #execute]
                ].

    "add chain to the tree"

    chain notNil ifTrue:[
        ntally := ntally + 1.
        tree addChain:chain
    ].

    "Modified: / 04-07-2010 / 09:45:28 / cg"
!

countLeaf:aContext
    "entered whenever the probed block gets interrupted;
     look where it is, and remember in the flat profile"

    "{ Pragma: +optSpeed }"

    |con entry recClass selector mthdClass sender home existingEntry|

    con := aContext.
    con isNil ifTrue:[^ self].

    "walk up above the interrupt context"

    [con receiver == Processor] whileTrue:[
        con := con sender
    ].

    "got it - collect info from contexts"

    con isNil ifTrue:[^ self].
    ((con receiver == self) and:[con selector == #execute]) ifTrue:[^ self].

    sender := con sender.
    sender isNil ifTrue:[^ self].
    ((sender receiver == self) and:[sender selector == #execute]) ifTrue:[^ self].

    home := con methodHome.
    home isNil ifTrue:[
        recClass := UndefinedObject.
        selector := 'optimized'.
        mthdClass := UndefinedObject.
    ] ifFalse:[
        recClass := home receiver class.
        selector := home selector.
        mthdClass := home methodClass.
    ].

    "add info to the probes collection"

    ntally := ntally + 1.

    entry := ProfileTree new.
    entry
        receiver:recClass
        selector:selector
        class:mthdClass
        isBlock:(con isBlockContext).

    existingEntry := probes elementAt:entry ifAbsent:nil.
    existingEntry isNil ifTrue:[
        probes add:entry
    ] ifFalse:[
        existingEntry incrementLeafTally.
    ].

    "Modified: / 04-07-2010 / 09:47:06 / cg"
! !


!MessageTally methodsFor:'spy setup'!

spyLeafOn:aBlock interval:ms
    "spy on execution time; generate information on leaf nodes only
     (which generates slightly less sampling overhead)
     Return the value from aBlock."

    |probing delay probingProcess probedProcess retVal|

    theBlock := aBlock.

    Processor activeProcess withPriority:(Processor userInterruptPriority-1) do:[

        probingProcess := [
            |p|

            p := probedProcess.
            [probing] whileTrue:[
                delay wait.
                executing ifTrue:[
                    self countLeaf:p suspendedContext
                ]
            ].
        ] newProcess.

        probingProcess priority:(Processor userInterruptPriority+1).

        delay := (Delay forMilliseconds:ms).
        ntally := 0.
        probes := Set new:200.

        probedProcess := Processor activeProcess.
        
        executing := false.
        probing := true.
        probingProcess resume.

        [
            startTime := OperatingSystem getMillisecondTime.
            retVal := self execute.
        ] ensure:[
            probing := executing := false.
            theBlock := nil.
            endTime := OperatingSystem getMillisecondTime.
        ].
    ].
    ^ retVal

    "Created: 20.3.1997 / 20:15:07 / cg"
    "Modified: 22.3.1997 / 16:46:42 / cg"
!

spyOn:aBlock interval:ms
    "spy on execution time, generate a hierarchical call information on the output stream.
     Return the value from aBlock."

    |probing delay probingProcess probedProcess retVal runPrio probePrio|

    theBlock := aBlock.
    runPrio := (Processor activePriority-1 "userInterruptPriority-1").
    probePrio := (Processor activePriority"+1" "Processor userInterruptPriority+1").

    Processor activeProcess 
        withPriority:runPrio 
        do:[

            probingProcess := [
                |p|

                p := probedProcess.
                [probing] whileTrue:[
                    delay wait. 
                    executing ifTrue:[
                        self count:p suspendedContext
                    ]
                ].
            ] newProcess.

            probingProcess priority:probePrio.

            delay := (Delay forMilliseconds:ms).
            ntally := 0.

            tree := ProfileTree new.
            tree 
                receiver:MessageTally 
                selector:#execute 
                class:MessageTally
                isBlock:false.

            probedProcess := Processor activeProcess.

            executing := false.
            probing := true.
            probingProcess resume.

            [
                startTime := OperatingSystem getMillisecondTime.
                retVal := self execute.
            ] ensure:[
                probing := executing := false.
                theBlock := nil.
                endTime := OperatingSystem getMillisecondTime.
            ].
        ].

    ^ retVal

    "Created: 20.3.1997 / 20:14:44 / cg"
    "Modified: 22.3.1997 / 16:45:42 / cg"
! !


!MessageTally class methodsFor:'documentation'!

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
    ^ 'Id: MessageTally.st 1981 2012-11-30 17:20:01Z vranyj1 '
! !

