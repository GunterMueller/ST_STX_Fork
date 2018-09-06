"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

View subclass:#MemoryMonitorView
	instanceVariableNames:'updateInterval updateBlock myProcess oldData newData freeData
		updateIndex org maxTotal minTotal dX newColor freeColor oldColor
		prevTotal prevLimit prevFree prevFree2 prevOld scale drawLock
		prevMemUsed prevCodeUsed prevNumWeak prevNumRem prevNumLifoRem
		prevTenureAge prevIGCPhase prevLastScavengeReclamation
		prevMinScavengeReclamation prevScavengeCount mallocColor
		drawAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!MemoryMonitorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    Shows memory usage (oldspace + newspace). Simple, but useful.

    The numbers shown are:
        tot     total memory usage (i.e. allocated oldSpace + allocated newSpace)
                (does not include the second semispace and other help-areas,
                 such as the remembered set etc.)

        all     current oldSpace in use + newSpace in use

        new     current newSpace in use

        frl     free space in (fragmented) free lists
        fre     compact free area above the used oldSpace

        old     current oldSpace in use

        mal     memory used by malloc (netto)

        mto     total memory that has been reserved by the malloc subsystem
                (may contained mem that has been freed or not yet allocated)

        cod     dynamic compiled code space size (just in time compiler)

        max,    extreme values of 'tot' since the monitor started
        min     (can be reset by typing 'r' in the view)

        t       tenure threshold (1 .. 30)

        I       incremental GC state (2 = idle)

        weak    number of weak objects

        rem     size of rememberedSet

        minsc:  percent of newspace remaining after scavenge (worst case)
                (i.e. the minimum %% of scavenged objects)

        count   number of scavenges since system started

        %       percentage of live objects in newSpace after last scavenge
                (i.e. this is the garbage vs. living objects ratio of
                 newSpace objects after the last scavenge)

    the graphic shows:
        orange  newSpace used
        green   free memory in freeLists
        white   oldSpace used


    the popupMenu offers GC functions; keyboard options are:
        'f' -> faster; 's' -> slower; 'r' -> reset min/max

    Disclaimer:
        this was one of the first tools written for ST/X (around 1989/90);
        today, it would probably be written differently...
        
    [author:]
        Claus Gittinger

    [start with:]
        MemoryMonitor open
        MemoryMonitorView open

    [see also:]
        ObjectMemory MemoryMonitor
        MemoryUsageMonitor ProcessMonitor
"
! !

!MemoryMonitorView methodsFor:'drawing'!

displayKilo:aNumber name:nm y:y
    |s|

"/    s := nm , (UnitConverter fileSizeStringFor:aNumber).
    aNumber >= (1024*1024*1024*8) ifTrue:[
        s := nm , ((aNumber // (1024*1024*1024)) printStringLeftPaddedTo:5) , 'G '.
    ] ifFalse:[
        aNumber >= (1024*1024*16) ifTrue:[
            s := nm , ((aNumber // (1024*1024)) printStringLeftPaddedTo:5) , 'M '.
        ] ifFalse:[
            s := nm , ((aNumber // 1024) printStringLeftPaddedTo:5) , 'k '.
        ].
    ].
    self displayOpaqueString:s x:0 y:y.

    "Modified: / 23.9.1998 / 13:19:04 / cg"
!

initializeDrawAction
    "extracted into a separate block to avoid memory allocation in updateDisplay"
    
    drawAction :=
        [    
            |total oldSpaceUsed newSpaceUsed freeMem oldSpaceSize
             realOldSpaceSize symSpaceSize realOldSpaceUsed
             gWidth shift scaleChange margin|

            realOldSpaceSize := ObjectMemory oldSpaceSize.
            symSpaceSize := ObjectMemory symSpaceSize.
            realOldSpaceUsed := ObjectMemory oldSpaceUsed.
            
            oldSpaceUsed := realOldSpaceUsed + ObjectMemory symSpaceUsed.
            newSpaceUsed := ObjectMemory newSpaceUsed.
            freeMem := ObjectMemory freeListSpace + (realOldSpaceSize - realOldSpaceUsed).
            oldSpaceSize := realOldSpaceSize + symSpaceSize.
            total := oldSpaceSize + ObjectMemory newSpaceSize.

            scaleChange := false.

            ((total - freeMem) < minTotal) ifTrue:[
                minTotal := total - freeMem.
                scaleChange := true
            ].
            (total > maxTotal) ifTrue:[
                maxTotal := total.
                scaleChange := true
            ].

            oldData at:updateIndex put:oldSpaceSize. "/ oldSpaceUsed.
            newData at:updateIndex put:newSpaceUsed.
            freeData at:updateIndex put:freeMem.
            updateIndex := updateIndex + 1.

            scaleChange ifTrue:[
                scale := height asFloat / (maxTotal + 100000).
                self redraw
            ].

            gWidth := width - org.
            margin := 1.

            ((updateIndex-1) >= (gWidth - margin)) ifTrue:[
                "on slow displays, use:"
                "/            shift := gWidth // 4.

                "for smooth display, use:"
                shift := 1.

                oldData replaceFrom:1 with:oldData startingAt:shift+1.
                newData replaceFrom:1 with:newData startingAt:shift+1.
                freeData replaceFrom:1 with:freeData startingAt:shift+1.

                updateIndex := updateIndex - shift.
                dX := (dX ? 0) + shift.

                "/ before copying, handle any outstanding exposes ...
                self repairDamage.
                "/ self catchExpose.
                self 
                    copyFrom:self 
                    x:(org + shift) y:0 toX:org y:0
                    width:(gWidth - shift - margin) height:height
                    async:false.

                self 
                    clearRectangleX:(width - margin - shift) y:0 
                    width:shift height:height.

                "/ self waitForExpose.
            ].

            self 
                updateLineX:(updateIndex - 1 + org - 1)
                total:total 
                old:oldSpaceSize "/ oldSpaceUsed
                new:newSpaceUsed 
                free:freeMem.

            self updateNumbers.
            self flush.
        ].
!

redraw
    "redraw all"

    self clear.
    self redrawX:0 y:0 width:width height:height
!

redrawX:x y:y width:w height:h
    "redraw data"

    |total oldSpaceUsed newSpaceUsed freeMem lx startIdx endIdx
     right|

    shown ifFalse:[^ self].

    right := x + w - 1.
    right >= org ifTrue:[
        lx := x.
        lx < org ifTrue:[
            lx := org
        ].

        total := ObjectMemory symSpaceSize 
                 + ObjectMemory oldSpaceSize 
                 + ObjectMemory newSpaceSize.

        startIdx := (lx-org+1).
        startIdx < 1 ifTrue:[
            startIdx := 1
        ].

        endIdx := right-org+1.
        endIdx >= updateIndex ifTrue:[
            endIdx := updateIndex-1.
        ].
        dX := 0.

        startIdx to:endIdx do:[:i |
            newSpaceUsed := newData at:i.
            newSpaceUsed notNil ifTrue:[
                oldSpaceUsed := oldData at:i.
                freeMem := freeData at:i.

                self updateLineX:lx - dX
                       total:total 
                       old:oldSpaceUsed 
                       new:newSpaceUsed 
                       free:freeMem.
            ].
            lx := lx + 1
        ]
    ].

    x < org ifTrue:[
        "/ force redraw.

        prevFree := prevFree2 := prevOld := prevTotal := prevLimit := nil.
        prevMemUsed := prevCodeUsed := prevNumWeak := prevNumRem := nil.
        prevNumLifoRem := prevTenureAge := prevIGCPhase := nil.
        prevLastScavengeReclamation := prevMinScavengeReclamation := nil.
        prevScavengeCount := nil.

        self updateNumbers.
    ]

    "Modified: / 14.7.1998 / 23:33:47 / cg"
!

updateDisplay
    "update picture; trigger next update"

    shown ifTrue:[
        drawLock wouldBlock ifFalse:[
            drawLock critical:drawAction.
        ].
    ].

    updateBlock notNil ifTrue:[
        Processor addTimedBlock:updateBlock afterSeconds:updateInterval
    ].

    "Modified: / 5.8.1998 / 13:13:18 / cg"
!

updateLineX:x total:total old:oldSpaceSize new:newSpaceUsed free:freeMem
    |hNew hOld hFree y1 y2 y3|

    hNew := (newSpaceUsed * scale) asInteger.
    hOld := (oldSpaceSize * scale) // 2.
    hFree := (freeMem * scale) // 2.

    y1 := height - 1.

    y2 := y1 - hOld.
    self paint:oldColor.
    self displayLineFromX:x y:y1 toX:x y:y2.

    y3 := y1 - hFree.
    self paint:freeColor.
    self displayLineFromX:x y:y1 toX:x y:y3.

    y1 := y2 - hNew.
    y1 ~= y2 ifTrue:[
       self paint:newColor.
       self displayLineFromX:x y:y1 toX:x y:y2.
    ]

    "Modified: / 29.1.1999 / 20:45:07 / stefan"
!

updateNumbers
    "redraw numbers.
     The values shown are:
        max:    maximum memory used since monitor started
        min:    minimum memory used since monitor started
        tot:    total memory used (overall oldSpace + overall newSpace)
        all:    current memory in use (oldSpace + newSpace)
        new:    current newSpace in use
        fre:    current size of freelist in oldSpace
        old:    current oldSpace in use
        mal:    net allocated by malloc
        mto:    brutto memory reserved by malloc
        code:   current just-in-time compiled code cache size
        t:      current tenure age
        I:      IGC state
        weak:   number of weak arrays in the system
        rem     remembered set size
        lrem    lifo remembered set size
        minsc:  percent of newspace remaining after scavenge (worst case)
        irq:    max. interrupt delay
        count of scavenges / last scavenge survivor rate

    "

    |oldSpaceSize newSpaceSize memUsed oldMemUsed newMemUsed freeMem free2
     mallocAllocated mallocTotal
     codeUsed numWeak numRem numLifoRem tenureAge igcPhase 
     minScavengeReclamation lastScavengeReclamation scavengeCount
     y half s font fontHeight fontAscent fontDescent 
     limit total n prevMallocAllocated prevMallocTotal|

    oldMemUsed := ObjectMemory oldSpaceUsed + ObjectMemory symSpaceUsed.
    newMemUsed := ObjectMemory newSpaceUsed.
    freeMem := ObjectMemory freeListSpace.
    oldSpaceSize := ObjectMemory oldSpaceSize + ObjectMemory symSpaceSize.
    newSpaceSize := ObjectMemory newSpaceSize.

    mallocAllocated := ObjectMemory mallocAllocated.
    mallocTotal := ObjectMemory mallocTotal.
    limit := ObjectMemory maxOldSpace.

    memUsed := oldMemUsed + newMemUsed "- freeMem".
    total := oldSpaceSize + newSpaceSize.
    free2 := ObjectMemory freeSpace.

    self paint:self whiteColor on:self blackColor.

    font := gc font.
    fontDescent := font descent.
    fontAscent := font ascent.
    fontHeight := font height + fontDescent.
    half := height // 2 + fontDescent.

    y := half - (fontHeight * 8).

    limit ~~ prevLimit ifTrue:[
        self displayKilo:limit    name:'lim ' y:fontAscent.
        prevLimit := limit.
    ].
    total ~~ prevTotal ifTrue:[
        ((total - freeMem) < minTotal) ifTrue:[
            minTotal := total - freeMem.
        ].
        (total > maxTotal) ifTrue:[
            maxTotal := total.
        ].

        self displayKilo:maxTotal name:'max ' y:fontAscent + fontHeight.
        self displayKilo:minTotal name:'min ' y:(height - fontDescent).
        self displayKilo:total    name:'tot ' y:y.

        prevTotal := total.
    ].

    y := y + fontHeight.
    memUsed ~~ prevMemUsed ifTrue:[
        self displayKilo:memUsed name:'all ' y:y.
        prevMemUsed := memUsed.
    ].

    y := y + fontHeight.
    self paint:newColor.
    self displayKilo:newMemUsed name:'new ' y:y.

    y := y + fontHeight.
    freeMem ~~ prevFree ifTrue:[
        self paint:freeColor.
        self displayKilo:freeMem name:'frl ' y:y.
        prevFree := freeMem.
    ].

    y := y + fontHeight.
    free2 ~~ prevFree2 ifTrue:[
        self paint:freeColor.
        self displayKilo:free2 name:'fre ' y:y.
        prevFree2 := free2.
    ].

    y := y + fontHeight.
    (oldMemUsed - freeMem) ~~ prevOld ifTrue:[
        self paint:oldColor.
        self displayKilo:(oldMemUsed - freeMem) name:'old ' y:y.
        prevOld := (oldMemUsed - freeMem).
    ].

    y := y + fontHeight.
    mallocAllocated ~~ prevMallocAllocated ifTrue:[
        self paint:mallocColor.
        self displayKilo:mallocAllocated name:'mal ' y:y.
        prevMallocAllocated := mallocAllocated.
    ].

    y := y + fontHeight.
    mallocTotal ~~ prevMallocTotal ifTrue:[
        self paint:mallocColor.
        self displayKilo:mallocTotal name:'mto ' y:y.
        prevMallocTotal := mallocTotal.
    ].

    y := y + fontHeight.
    ObjectMemory supportsJustInTimeCompilation ifTrue:[
        codeUsed := ObjectMemory compiledCodeSpaceUsed.
        prevCodeUsed ~~ codeUsed ifTrue:[
            self paint:oldColor.
            codeUsed > 9999 ifTrue:[
                s := 'code ' , ((codeUsed // 1024) printStringLeftPaddedTo:4) , 'k'.
            ] ifFalse:[
                s := 'code ' , (codeUsed printStringLeftPaddedTo:4) , 'b'.
            ].
            self displayOpaqueString:s x:0 y:y.
            prevCodeUsed := codeUsed.
        ]
    ].

    "
     the following is internal - normally only interesting when debugging the VM
    "
    y := y + fontHeight.
    tenureAge := ObjectMemory tenureAge.
    igcPhase := ObjectMemory incrementalGCPhase.
    (prevTenureAge ~~ tenureAge
    or:[prevIGCPhase ~~ igcPhase]) ifTrue:[
        self paint:oldColor.
        s := 't:' , (tenureAge printStringLeftPaddedTo:2) , ' '.
        s := s , ' I:' , (igcPhase printStringLeftPaddedTo:2) , ' '.
        self displayOpaqueString:s x:0 y:y.
        prevTenureAge := tenureAge.
        prevIGCPhase := igcPhase.
    ].

    y := y + fontHeight.
    numWeak := ObjectMemory numberOfWeakObjects.
    prevNumWeak ~~ numWeak ifTrue:[
        self paint:oldColor.
        s := 'weak: ' , (numWeak printStringLeftPaddedTo:4).
        self displayOpaqueString:s x:0 y:y.
        prevNumWeak := numWeak.
    ].

    y := y + fontHeight.
    numRem := ObjectMemory rememberedSetSize.
    prevNumRem ~~ numRem ifTrue:[
        self paint:oldColor.
        s := 'rem: ' , (numRem printStringLeftPaddedTo:5).
        self displayOpaqueString:s x:0 y:y.
        prevNumRem := numRem.
    ].

    y := y + fontHeight.
    numLifoRem := ObjectMemory lifoRememberedSetSize.
    prevNumLifoRem ~~ numLifoRem ifTrue:[
        self paint:oldColor.
        s := 'lrem: ' , (numLifoRem printStringLeftPaddedTo:4 ifLarger:['****']).
        self displayOpaqueString:s x:0 y:y.
        prevNumLifoRem := numLifoRem.
    ].

"/ does no longer make sense to show ....
"/    y := y + fontHeight.
"/    ObjectMemory runsSingleOldSpace ifTrue:[
"/        self displayOpaqueString:'single' x:0 y:(half + (fontHeight*4)).
"/    ].

    y := y + fontHeight.
    minScavengeReclamation := ObjectMemory minScavengeReclamation * 100 // ObjectMemory newSpaceSize.
    prevMinScavengeReclamation ~~ minScavengeReclamation ifTrue:[
        minScavengeReclamation := 100 - minScavengeReclamation asInteger.
        s := 'minSc ', (minScavengeReclamation printStringLeftPaddedTo:3) , '%'.
        self paint:oldColor.
        self displayOpaqueString:s x:0 y:y.
        prevMinScavengeReclamation := minScavengeReclamation.
    ].

    y := y + fontHeight.
    n := ObjectMemory maxInterruptLatency.
    n notNil ifTrue:[
        s := 'irq ', (n printStringLeftPaddedTo:3) , ' ms'.
    ] ifFalse:[
        s := ''
    ].
    self displayOpaqueString:s x:0 y:y.

    y := y + fontHeight.
    scavengeCount := ObjectMemory scavengeCount.
    lastScavengeReclamation := ObjectMemory lastScavengeReclamation * 100 // ObjectMemory newSpaceSize.
    (prevScavengeCount ~~ scavengeCount
    or:[prevLastScavengeReclamation ~~ lastScavengeReclamation]) ifTrue:[
        lastScavengeReclamation := 100 - lastScavengeReclamation asInteger.
        s := (scavengeCount printStringLeftPaddedTo:6)
             , (lastScavengeReclamation printStringLeftPaddedTo:3) , '%'.
        self displayOpaqueString:s x:0 y:y.
        prevLastScavengeReclamation := lastScavengeReclamation.
        prevScavengeCount := scavengeCount.
    ].

    "Created: / 7.11.1995 / 14:48:16 / cg"
    "Modified: / 14.7.1998 / 23:35:53 / cg"
! !

!MemoryMonitorView methodsFor:'events'!

keyPress:key x:x y:y
    key == $f ifTrue:[
	"faster"
	updateInterval := updateInterval / 2
    ].
    key == $s ifTrue:[
	"slower"
	updateInterval := updateInterval * 2
    ].
    key == $r ifTrue:[
	"reset max"
	maxTotal := prevTotal.
	scale := height asFloat / (maxTotal + 100000).
	self resetStatisticValues.
	self redraw.
    ]

    "Modified: 7.11.1995 / 17:45:13 / cg"
!

sizeChanged:how
    |nn no nf delta oldSize newSize|

    super sizeChanged:how.

    (width == 0 or:[height == 0]) ifTrue:[
        ^ self
    ].

    oldSize := oldData size.
    newSize := width-org+1.
    newSize <= 0 ifTrue:[^ self].

    (newSize ~~ oldSize) ifTrue:[
        nn := Array new:newSize.
        no := Array new:newSize.
        nf := Array new:newSize.

        (newSize > oldSize) ifTrue:[
            nn replaceFrom:1 to:oldSize with:newData.
            no replaceFrom:1 to:oldSize with:oldData.
            nf replaceFrom:1 to:oldSize with:freeData
        ] ifFalse:[
            delta := (oldSize - newSize).
            nn replaceFrom:1 with:newData startingAt:delta+1.
            no replaceFrom:1 with:oldData startingAt:delta+1.
            nf replaceFrom:1 with:freeData startingAt:delta+1.
            updateIndex > newSize ifTrue:[
                updateIndex := updateIndex - delta.
            ]
        ].
        newData := nn.
        oldData := no.
        freeData := nf.

        scale := height asFloat / (maxTotal + 100000).
    ].
    self clear.
    self redraw.

    "Modified: / 7.9.1998 / 21:41:13 / cg"
! !

!MemoryMonitorView methodsFor:'initialization & release'!

destroy
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:updateBlock.
    ] ifFalse:[
        myProcess notNil ifTrue:[
            myProcess terminate.
            myProcess := nil
        ]
    ].
    oldData := newData := freeData := nil.
    super destroy
!

initialize
    super initialize.

    self initializeDrawAction.

    drawLock := Semaphore forMutualExclusion name:'drawLock'.

    updateInterval := 0.5.
    ProcessorScheduler isPureEventDriven ifTrue:[
        updateBlock := [self updateDisplay].
    ].
    oldData := Array new:1000.
    newData := Array new:1000.
    freeData := Array new:1000.

    updateIndex := 1.

    self font:((Font family:'courier' face:'medium' style:'roman' size:10) onDevice:device).
    org := gc font widthOf:'max 99999k '.
    level := 0.

    maxTotal := minTotal := ObjectMemory oldSpaceSize 
                            + ObjectMemory symSpaceSize
                            + ObjectMemory newSpaceSize.

    viewBackground := self blackColor.

    device hasColors ifTrue:[
        newColor := Color orange. "/ yellow.
        freeColor := Color green.
        mallocColor := Color yellow.
    ] ifFalse:[
        newColor := Color grey:67.
        freeColor := Color grey:33.
        mallocColor := Color grey:50.
    ].
    oldColor := self whiteColor.

    self model:self.
    self menu:#memoryMenu

    "
     MemoryMonitor open
    "

    "Modified: / 24-07-2011 / 08:28:51 / cg"
!

realize
    |graphicsDevice|

    super realize.
    updateBlock notNil ifTrue:[
        Processor addTimedBlock:updateBlock afterSeconds:updateInterval.
    ] ifFalse:[
        (myProcess isNil or:[myProcess isDead]) ifTrue:[
            myProcess := [
                [
                    self updateProcess
                ] ensure:[
                    myProcess := nil.
                ].
            ] newProcess.
            myProcess priorityRange:(6 to:8).
            myProcess name:'monitor [' , 
                           Processor activeProcessId printString ,
                           '] update'.
            myProcess restartable:true.
            myProcess resume.
        ].
    ].

    graphicsDevice := device.
    newColor := newColor onDevice:graphicsDevice.
    freeColor := freeColor onDevice:graphicsDevice.
    oldColor := oldColor onDevice:graphicsDevice.
    mallocColor := mallocColor onDevice:graphicsDevice.

    "Modified: / 23.9.1998 / 12:41:10 / cg"
!

reinitStyle
    "ignore style changes"

    "Created: / 15.9.1998 / 15:22:46 / cg"
! !

!MemoryMonitorView methodsFor:'menu functions'!

backgroundCollect
    "start a background (non disturbing) incremental GC. 
     Since the GC is performed at a low priority, it may not make progress if higher
     prio processes are running"
 
    [
	ObjectMemory incrementalGC
    ] forkAt:5 
!

backgroundCollectWithDynamicPrio
    "setup the background collector to run at dynamic priority.
     This is a new experimental feature."

    Processor isTimeSlicing ifFalse:[
        Processor startTimeSlicing.
        Processor supportDynamicPriorities:true
    ].

    ObjectMemory backgroundCollectProcess priorityRange:(5 to:9).
    ObjectMemory backgroundFinalizationProcess priorityRange:(5 to:9).

    "Modified: / 4.8.1998 / 02:16:02 / cg"
!

backgroundCollectWithFixPrio
    "setup the background collector to run at a fix priority.
     This is the default."

    ObjectMemory backgroundCollectProcess priorityRange:nil.
    ObjectMemory backgroundFinalizationProcess priorityRange:nil.

    "Modified: / 4.8.1998 / 02:00:31 / cg"
!

cleanupMemory
    "let all classes release unneeded, cached
     data ..."

    ObjectMemory performLowSpaceCleanup.

    "
     then, perform a GC (incl. symbol reclamation)
    "
    ObjectMemory reclaimSymbols.
    "
     finally, compress
    "
    ObjectMemory tenure.
    ObjectMemory verboseGarbageCollect.

    "Modified: 26.6.1997 / 17:12:53 / cg"
!

cleanupMethodHistory
    "release the oldMethod history"

    (self confirm:'This removes the previous method history,
which is kept for all changed methods in the system.
After that, the browsers cannot easily switch back to a methods
previous version.

However, this is normally not a problem, since
a methods previous code should still be accessible through
either the changes-file, the sourceCode repository or the classes original
source file.

cleanup now ?') ifTrue:[


        Class flushMethodHistory.

        "
         then, perform a GC (incl. symbol reclamation)
        "
        ObjectMemory reclaimSymbols.
        "
         finally, compress
        "
        ObjectMemory verboseGarbageCollect.
   ]
!

collectGarbage
    "perform a blocking (non compressing) garbage collect"

    windowGroup withWaitCursorDo:[
        ObjectMemory tenure.
        ObjectMemory markAndSweep
    ]

    "Modified: 30.7.1997 / 21:19:35 / cg"
!

collectGarbageAndCompress
    "perform a blocking compressing garbage collect."

    windowGroup withWaitCursorDo:[
        ObjectMemory tenure.
        ObjectMemory verboseGarbageCollect
    ]

    "Modified: 30.7.1997 / 21:19:47 / cg"
!

collectGarbageAndSymbols
    "perform a blocking (non compressing) garbage collect
     and reclaim unreferenced symbols."

    windowGroup withWaitCursorDo:[
        ObjectMemory tenure.
        ObjectMemory reclaimSymbols
    ]

    "Modified: 30.7.1997 / 21:19:41 / cg"
!

compressOldSpace
    "perform a blocking compress (only useful if freeList is not empty, after M&S)"

    windowGroup withWaitCursorDo:[
        ObjectMemory compressOldSpace.
    ]

    "Modified: 30.7.1997 / 21:19:35 / cg"
!

compressSources
    (self confirm:'This saves all in-memory source strings into a file
and makes methods reference these (file-) strings,
freeing all in-memory sources.

If that source file is ever lost or gets out of sync with
your system, those method sources are lost and the browser
will show garbage. 
However, you still have a change file as backup.

(Be especially careful, if you move images around:
 the source file must then be the correct one for that image)

A compress is only useful, if you added many methods
and the systems response time suffers from paging.

Compress anyway ?') ifTrue:[
        windowGroup withWaitCursorDo:[
            Smalltalk compressSources.
            ObjectMemory markAndSweep
        ]
    ]

    "Modified: 9.2.1996 / 18:17:22 / cg"
!

incrementalCollect
    "start an incremental GC which does not disturb too much, but is guaranteed to
     make progress.
     This is done by doing the IGC at a very high priority, but giving up the CPU after
     every step. Due to the long delays, this may take a while to finish.
     Notice, that this is different from doing a background collect: that one
     may not make any progress if higher prio processes are runnable."

    |done delay|

    [
        done := false.
        delay := Delay new.
        [done] whileFalse:[
            10 timesRepeat:[
                done ifFalse:[done := ObjectMemory gcStep].
            ].
            (delay delay:10) wait
        ]
    ] forkAt:Processor highestPriority

    "Modified: 23.12.1995 / 17:31:55 / cg"
!

memoryMenu
    <resource: #programMenu>

    |hasSpecialMenu m items moreItems specialMenu|

    hasSpecialMenu := Smalltalk isStandAloneApp not.
    hasSpecialMenu ifTrue:[
        items := #(
                    ('Background Collect Now'       backgroundCollect)
                    ('Hi Prio Incremental Collect'  incrementalCollect)
                    ('-')
                    ('Scavenge'                     scavenge)
                    ('Tenure'                       tenure)
                    ('Compress Only'                compressOldSpace)
                    ('-')
                    ('Cleanup Memory'               cleanupMemory)
                    ('Flush Method History'         cleanupMethodHistory)
                    ('Unload Autoloaded Classes'    unloadAllAutoloadedClasses)
                    ('-')
                    ('Compress Sources'             compressSources)
                  ).

        ObjectMemory backgroundCollectorRunning ifFalse:[
            moreItems := #(
                        ('Start Background Collector'   restartBackgroundCollector )
                     ) 
        ] ifTrue:[
            (ObjectMemory backgroundCollectProcess priorityRange notNil)
            ifTrue:[
                moreItems := #(
                        ('Stop Background Collector'             stopBackgroundCollector      )
                        ('Background Collect with Fix Priority'  backgroundCollectWithFixPrio )
                         ) 
            ] ifFalse:[
                moreItems := #(
                        ('Stop Background Collector'                stopBackgroundCollector      )
                        ('Background Collect with Dynamic Priority' backgroundCollectWithDynamicPrio )
                         ) 
            ].
            ObjectMemory backgroundFinalizationProcess isNil ifTrue:[
                moreItems := moreItems , #(
                            ('Start Background Finalizer'   restartBackgroundFinalizer )
                         )
            ].

        ].
        items := moreItems , items.

        specialMenu := PopUpMenu
                            itemList:items
                            resources:resources.

        self sensor ctrlDown ifTrue:[
            ^ specialMenu
        ].

        items := #(
                    ('Collect Garbage'              collectGarbage                  )
                    ('Collect Garbage & Symbols'    collectGarbageAndSymbols        )
                    ('Collect Garbage & Compress'   collectGarbageAndCompress       )
                    ('-')                                                           
                    ('Reset Statistic Values'       resetStatisticValues            )
                    ('-')
                    ('Others'                       otherMenu                       Ctrl)
                  ).

        m := PopUpMenu itemList:items resources:resources.
        m subMenuAt:#otherMenu put:specialMenu.
    ] ifFalse:[
        items := #(
                    ('Collect Garbage'              collectGarbage                  )
                    ('Collect Garbage & Symbols'    collectGarbageAndSymbols        )
                    ('Collect Garbage & Compress'   collectGarbageAndCompress       )
                    ('-')                                                           
                    ('Reset Statistic Values'       resetStatisticValues            )
                  ).
        m := PopUpMenu itemList:items resources:resources.
    ].

    ^ m

    "Modified: / 5.8.1998 / 15:35:14 / cg"
!

resetStatisticValues 
    ObjectMemory resetMaxInterruptLatency.
    ObjectMemory resetMinScavengeReclamation.

    "Created: 7.11.1995 / 17:44:59 / cg"
!

restartBackgroundCollector
    "(re)start a background (non disturbing) incremental GC. 
     Since the GC is performed at a low priority, it may not make progress if higher
     prio processes are running"
 
    ObjectMemory backgroundCollectorRunning
    ifFalse:[
        ObjectMemory startBackgroundCollectorAt:5.
        ObjectMemory startBackgroundFinalizationAt:5
    ]

    "Created: / 21.1.1997 / 00:09:30 / cg"
    "Modified: / 5.8.1998 / 14:30:17 / cg"
!

restartBackgroundFinalizer
    "(re)start a background (non disturbing) incremental finalizer process."
 
    ObjectMemory backgroundFinalizationProcess isNil
    ifTrue:[
        ObjectMemory startBackgroundFinalizationAt:5
    ]

    "Created: / 21.1.1997 / 00:09:30 / cg"
    "Modified: / 5.8.1998 / 14:30:17 / cg"
!

scavenge 
    "perform a blocking newspace garbage collect.
     (this is for debugging only - the system does this automatically)"

    ObjectMemory scavenge
!

stopBackgroundCollector
    "stop the background (non disturbing) incremental GC. 
     We do not recommend this - but maybe useful for debugging and
     evaluating the programs behavior in heavy-load situations
     (background collector cannot keep up with the allocation rate)"
 
    ObjectMemory stopBackgroundCollector.
    ObjectMemory stopBackgroundFinalization

    "Created: / 5.8.1998 / 14:29:40 / cg"
!

tenure 
    "empty the newSpace, by aging all new objects immediately and transfering them
     into oldSpace.
     (this is for debugging only - the system does this automatically)"

    ObjectMemory tenure
!

unloadAllAutoloadedClasses
    "unload all classes which were autoloaded and have no instances"

    Autoload loadedClasses copy do:[:anAutoloadedClass |
        anAutoloadedClass hasInstances ifFalse:[
            anAutoloadedClass unload
        ]
    ].

    "Created: 27.6.1997 / 14:21:45 / cg"
    "Modified: 27.6.1997 / 14:22:47 / cg"
! !

!MemoryMonitorView methodsFor:'private'!

updateProcess
    [true] whileTrue:[
        Delay waitForSeconds:updateInterval.
        self updateDisplay
    ]

    "Modified: / 23.9.1998 / 12:40:31 / cg"
! !

!MemoryMonitorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

