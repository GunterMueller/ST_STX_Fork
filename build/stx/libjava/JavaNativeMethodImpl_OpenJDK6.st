"
 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaNativeMethodImpl_OpenJDK6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Support-Java 6'
!

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

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
    This class implements all native methods of Open JDK 6.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        JavaVM
        JavaVMData

"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'helpers'!

nativeContext
    "Return a context (JavaContext) of the native method
     being executed. Should be used only by certain methods
     like getCallingClassLoader or so"

    | ctx mthd |

    ctx := thisContext sender.
    [
        mthd := ctx method.
        mthd notNil and:[mthd isJavaMethod].
    ] whileFalse:[
        ctx := ctx sender.
    ].
    self assert: mthd isNative.
    ^ctx.

    "Created: / 30-01-2013 / 14:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2013 / 12:59:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'helpers - awt - UNPORTED'!

commonReshapeComponent: nativeContext
    |view x y width height ext menu|

    view := self viewForWPeer: nativeContext.

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    width := nativeContext argAt:3.
    height := nativeContext argAt:4.
    ext := width@height.

"/    'pReshape ' print. view print.
"/    ' ' print. x print. '/' print. y print.
"/    ' extent: ' print. ext printNL.
    view isPopUpView ifTrue:[
	view origin:x@y extent:ext.
    ] ifFalse:[
	(view isTopView
	or:[view isMemberOf:JavaEmbeddedFrameView]) ifTrue:[
	    "/
	    "/ dont allow setting the origin
	    "/
	    menu := self topViewsMenu:view.
	    menu notNil ifTrue:[
		"/ must add the menus height
		height := height + menu height.
		ext := width@height.
	    ].

	    "/ to prevent a view from not being visible/closable
	    "/ in case Java goes mad ..

	    (width < 30
	    or:[height < 10]) ifTrue:[
		"/ self halt.
		width := 30.
		height := 20.
		ext := width@height.
	    ].

	    view extent:ext.
	    (view isKindOf:ModalBox) ifTrue:[
		view preferredExtent:ext
	    ].

	    "/ adjust non-resizable views min/max

	    view isTopView ifTrue:[
		view minExtent notNil ifTrue:[
		    view minExtent:ext.
		    view maxExtent:ext
		].
	    ]
	] ifFalse:[
	    (view superView notNil
	    and:[view superView isTopView]) ifTrue:[
		menu := self topViewsMenu:view superView.
		menu notNil ifTrue:[
		    "/ must add menus height to yPos
		    y := y + menu height.
		]
	    ] ifFalse:[
		"/ post a configuration event
		EventTrace == true ifTrue:[
		    'JAVA: configure: need event' printCR.
		]
	    ].
	    (x isNil or:[y isNil]) ifTrue:[
		Transcript showCR:'bad args to reshape'.
	    ] ifFalse:[
		view origin:x@y extent:ext.
	    ]
	].
    ].

    view isJavaView ifTrue:[
	view invalidate.
    ].

    ^ nil

    "Created: / 4.1.1998 / 18:00:52 / cg"
    "Modified: / 5.12.1998 / 13:34:20 / cg"
!

createdWindowsView:aView for:aJavaPeer
    "this is only sent with the sun.awt.windows toolkit"

    aJavaPeer instVarNamed:'pData' put:aView.

    JavaWindowGroup isNil ifTrue:[
	JavaWindowGroup := WindowGroup new.
	JavaWindowGroup isForModalSubview:true.
    ].
    aView windowGroup:JavaWindowGroup.
    JavaWindowGroup addView:aView.

    KnownWindows isNil ifTrue:[
	KnownWindows := IdentityDictionary new.
    ].
    KnownWindows at:aJavaPeer put:aView.

    FirstWindowCreationSemaphore signalIf.

"/'*** ' print. aJavaPeer print. ' -> ' print. aView printCR.
"/(aView isKindOf:ModalBox) ifTrue:[
"/    self halt.
"/].

    "Created: / 4.1.1998 / 17:57:16 / cg"
    "Modified: / 28.1.1998 / 22:40:19 / cg"
!

gcForWGraphics: nativeContext
    |jGraphics gc orgX orgY trans tX tY|

    jGraphics := nativeContext receiver.
    O_WGgraphics_pData isNil ifTrue:[
	O_WGgraphics_pData := (jGraphics class instVarIndexFor:'pData').
    ].
    O_WGgraphics_originX isNil ifTrue:[
	O_WGgraphics_originX := (jGraphics class instVarIndexFor:'originX').
    ].
    O_WGgraphics_originY isNil ifTrue:[
	O_WGgraphics_originY := (jGraphics class instVarIndexFor:'originY').
    ].
    gc := jGraphics instVarAt:O_WGgraphics_pData.

    trans := gc translation.
    tX := trans x.
    tY := trans y.
"/    tX := gc translationX.
"/    tY := gc translationY.

    orgX := jGraphics instVarAt:O_WGgraphics_originX.
    orgY := jGraphics instVarAt:O_WGgraphics_originY.
    ((orgX ~~ tX) or:[orgY ~~ tY]) ifTrue:[
	gc translation:orgX@orgY
    ].
    ^ gc

    "Created: / 8.1.1998 / 00:16:38 / cg"
    "Modified: / 23.12.1998 / 20:27:35 / cg"
!

jPeerForView:aView
    ^ KnownWindows keyAtValue:aView ifAbsent:nil

    "Created: / 15.1.1998 / 13:48:01 / cg"
    "Modified: / 15.1.1998 / 13:48:43 / cg"
!

pReshape: nativeContext
    |jFramePeer view x y width height menu|

    jFramePeer := nativeContext receiver.
    view := jFramePeer instVarNamed:'pData'.

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    width := nativeContext argAt:3.
    height := nativeContext argAt:4.

"/    'pReshape ' print. view print.
"/    ' ' print. x print. '/' print. y print.
"/    ' extent: ' print. width print. '/' print. height printNL.

    view isPopUpView ifTrue:[
	self halt.
    ].

    (view isTopView
    or:[view isMemberOf:JavaEmbeddedFrameView]) ifTrue:[
	"/
	"/ dont allow setting the origin
	"/
	menu := self topViewsMenu:view.
	menu notNil ifTrue:[
	    "/ must add the menus height
	    height := height + menu height
	].
	view extent:width@height.
    ] ifFalse:[
	(view superView notNil
	and:[view superView isTopView]) ifTrue:[
	    menu := self topViewsMenu:view superView.
	    menu notNil ifTrue:[
		"/ must add menus height to yPos
		y := y + menu height.
	    ]
	].
	view origin:x@y extent:width@height.
    ].

    ^ nil

    "Created: / 7.1.1998 / 21:47:11 / cg"
    "Modified: / 5.12.1998 / 13:47:52 / cg"
!

replacementFontFor:name style:styleNr size:size
    |font family style|

    style := 'roman'.
    styleNr = 0 ifTrue:[
        style := 'roman'
    ].

    font := Font family:name style:style size:size.
    font notNil ifTrue:[^ font].

    name = 'Dialog' ifTrue:[
        family := 'helvetica'
    ] ifFalse:[
        family := 'courier'
    ].

    ^ Font family:name style:style size:size.
!

topViewsMenu:view
    |idx|

    view isTopView ifTrue:[
	view subViews size > 0 ifTrue:[
	    (idx := view subViews findFirst:[:v | v isMemberOf:MenuPanel]) ~~ 0 ifTrue:[
		"/ must add the menus height
		^ view subViews at:idx
	    ]
	].
    ].
    ^ nil

    "Modified: / 4.8.1997 / 01:23:06 / cg"
    "Created: / 4.1.1998 / 18:01:42 / cg"
!

viewForWPeer: nativeContext
    |jPeer|

    jPeer := nativeContext receiver.

    "/ sigh; pData was renamed to pNativeWidget in jdk1.2 ...
    O_FramePeer_pNativeWidget isNil ifTrue:[
        O_FramePeer_pNativeWidget := (jPeer class instVarIndexFor:'pNativeWidget').
        O_FramePeer_pNativeWidget isNil ifTrue:[
            O_FramePeer_pNativeWidget := 0.
            O_FramePeer_pData isNil ifTrue:[
                O_FramePeer_pData := (jPeer class instVarIndexFor:'pData').
            ].
        ]
    ].
    O_FramePeer_pNativeWidget > 0 ifTrue:[
        "/ ok, we are < 1.2
        ^ jPeer instVarAt:O_FramePeer_pNativeWidget.
    ].
    ^ jPeer instVarAt:O_FramePeer_pData.

    "Modified: / 19.11.1998 / 01:43:20 / cg"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'helpers - io'!

addOpenFile:aStream
    "Given a stream, adds it into the open file table. Returns a
     (fake) file descriptor number"
    | fd |

    OpenFileTableLock critical:[
        fd := OpenFileTable indexOf: nil.
        fd ~~ 0 ifTrue:[
            OpenFileTable at: fd put: aStream.
            fd := fd - 1.
        ] ifFalse:[
            OpenFileTable add:aStream.
            fd := OpenFileTable size - 1.
        ].
    ].
    ^fd

    "Created: / 02-01-1998 / 18:32:59 / cg"
    "Modified (comment): / 18-07-2012 / 23:00:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

anyStream_read: jstream bytes: bytes offset: offset count: count
    | stream nRead|

    stream := self validateFile: jstream.

    "/ should always be bytes
    bytes class isBytes ifFalse:[
        self halt.
    ].
    stream == Stdin ifTrue:[
        stream := StdinReplacementFileQuerySignal raiseRequest.
        stream isNil ifTrue:[
            ^ -1 "/ 0  EOF
        ]
    ].

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: read ' , count printString , ' bytes from ' , stream pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    stream isPositionable ifFalse:[
        "/ mhmh - some kind of socket or pipe

        stream readWait.
    ].

    count == 0 ifTrue:[^0].

    Stream readErrorSignal handle:[:ex |
        nRead := -1
    ] do:[
        nRead := stream nextAvailableBytes:count into:bytes startingAt:offset+1.
    ].
    nRead == 0 ifTrue:[
        stream atEnd ifTrue:[
            FileIOTrace ifTrue:[
                Logger 
                      log:('JAVA: at EOF ' , nRead printString)
                      severity:Logger severityTRACE
                      facility:#JVM.
            ].
            ^ -1
        ].
    ].
    count ~~ nRead ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: only got ' , nRead printString)
                  severity:Logger severityTRACE
                  facility:#JVM.
        ]
    ].
    ^ nRead

    "Created: / 30-01-2013 / 17:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

anyStream_write: jstream bytes: bytes offset: offset count: count append: append
    | stream |

    stream := self validateFile:jstream.
    append ifTrue:[ stream setToEnd ].

    FileIOTrace ifTrue:[
        stream isFileStream ifTrue:[
            Logger log: ('write ' , count printString , ' bytes to ' , stream pathName) severity: Logger severityTRACE facility: 'JVM'.
        ] ifFalse:[
            stream ~~ Stdout ifTrue:[
                stream ~~ Stderr ifTrue:[
                    Logger log: ('write ' , count printString , ' bytes to ' , stream displayString) severity: Logger severityTRACE facility: 'JVM'.
                ]
            ]
        ]
    ].

    "/ should always be bytes
    Stream writeErrorSignal handle:[:ex |
        ex return
    ] do:[
        Socket brokenConnectionSignal handle:[:ex |
            ex return
        ] do:[
            stream isBinary ifTrue:[
                stream nextPutBytes:count from:bytes startingAt:offset+1
            ] ifFalse:[
                stream nextPutAll: (bytes asString copyFrom: offset + 1 to: offset + count).
            ]

        ].
        stream == Transcript ifTrue:[
            Transcript endEntry
        ]
    ].

    "Created: / 08-02-2013 / 11:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 14:03:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkWritePermissionOfDirectory:dir message:msg
    |answer|

    (PermittedDirectories notNil
    and:[PermittedDirectories includes:dir]) ifFalse:[
	FileOpenConfirmation ifTrue:[
	    answer := Dialog
		    confirmWithCancel:msg withCRs
			       labels:#('no' 'grant')
			       values:#(false true)
			      default:2.
	    answer == false ifTrue:[
		^ false
	    ].

	    (self confirm:('JAVA Security check\\Always permit writes in this directory (''' , dir pathName , ''') ?') withCRs)
	    ifTrue:[
		PermittedDirectories isNil ifTrue:[
		    PermittedDirectories := Set new
		].
		PermittedDirectories add:dir.
	    ]
	]
    ].
    ^ true

    "Created: / 3.12.1998 / 15:07:56 / cg"
    "Modified: / 3.12.1998 / 15:16:55 / cg"
!

commonClose: jstream

    | fdobj fd stream |
    fdobj := (jstream instVarNamed: #fd).
    fd    := fdobj instVarNamed: #fd.
    fd == -1 ifTrue:[
        "Never opened or already closed"
        ^self.
    ].
    stream := self getOpenFileAt:fd.
    stream notNil ifTrue:[
        stream isView ifTrue:[
            "Some applications close stdout/stderr (such as Apache Tomcat).
             We don't want that, so ignore a close in that case"
            stream ~~ Transcript ifTrue:[
                self breakPoint: #jv.
            ].
        ] ifFalse:[
            (stream ~~ Stdout and:[stream ~~ Stderr and:[stream ~~ Stdin]]) ifTrue:[
                stream close.
            ]
        ]
    ] ifFalse:[
        self breakPoint: #jv.
    ].
    self setOpenFile: nil at: fd.
    fdobj instVarNamed:#fd put: -1.

    "Created: / 10-08-2011 / 14:02:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 17:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commonOpen: fs path: path forAppend:forAppend
    | fd fn nm dir stream fileNo readonly|

    fd := fs instVarNamed:'fd'.
    (fd instVarNamed:'fd') ~~ -1 ifTrue:[
        "/self halt:'file already open'.
        self internalError:'file already open'.
        ^ self.
    ].


    nm := Java as_ST_String:path.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opening ' , nm)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    fn := nm utf8Decoded asFilename.
    dir := fn directory pathName.

    readonly := false.
"/    (PermittedDirectories notNil
"/    and:[PermittedDirectories includes:dir]) ifFalse:[
"/        FileOpenConfirmation ifTrue:[
"/            answer := Dialog
"/                    confirmWithCancel:('JAVA Security check\\Opening ''' , name , ''' for read/write.\Grant permission ?') withCRs
"/                               labels:#('no' 'grant' 'readonly')
"/                               values:#(false true #readonly)
"/                              default:3.
"/            answer == false ifTrue:[
"/                self throwIOExceptionWithMessage:('no permission to open ' , name , ' for writing').
"/                ^ self
"/            ].
"/            readonly := (answer == #readonly).
"/
"/            readonly ifFalse:[
"/                (self confirm:('JAVA Security check\\Always permit writes in this directory (''' , dir , ''') ?') withCRs)
"/                ifTrue:[
"/                    PermittedDirectories isNil ifTrue:[
"/                        PermittedDirectories := Set new
"/                    ].
"/                    PermittedDirectories add:dir.
"/                ]
"/            ]
"/        ]
"/    ].

    readonly ifTrue:[
        (fn exists and:[fn isReadable not]) ifTrue:[
            ^JavaVM throwFileNotFoundException: 'File is not readable'
        ].
        stream := fn readStream.
    ] ifFalse:[
"/        fn exists ifFalse:[
"/            ^self throwFileNotFoundException: 'File does not exist'
"/        ].
        fn isDirectory ifTrue:[
             ^JavaVM throwFileNotFoundException: 'File is directory'
        ].
        (fn exists and:[fn isWritable not]) ifTrue:[
            ^JavaVM throwFileNotFoundException: 'File does not writable'
        ].
        forAppend ifTrue:[
            stream := self commonOpenStreamUsing:[fn appendingWriteStream].
        ] ifFalse:[
            stream := self commonOpenStreamUsing:[fn writeStream].
        ]
    ].
    stream isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:('cannot open ' , nm , ' for writing').
    ].
    stream binary.

    fileNo := self addOpenFile:stream.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opened ' , nm , ' as FD ' , fileNo printString 
                      , ' for writing')
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    fd instVarNamed:'fd' put:fileNo.

    "Kludge for finalization..."
    fs finalizationLobby registerChange: fs

    "Created: / 30-01-2013 / 17:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commonOpenStreamUsing: aBlock
    "Helper for opening a stream. Catches 'too many files' open error
     and tries to GC to cleanup if necessary"

    | stream retry |

    retry := false.
    [ stream := aBlock value ] on:OpenError do:[:ex|
        (ex errorCode) == (OperatingSystem errorNumberFor:#EMFILE) ifTrue:[
            "Worst case, try to cleanup"
            Logger log: 'maximum number of open files reached, forcing finalization...' severity: Logger severityWARN facility: #JVM.
            [
                FinalizationLobby finalizeNow.
                Delay waitForSeconds: 5. "/Give Java finalization thread a chance to clean up
                ObjectMemory garbageCollect.
                retry := true.
                JavaVM performance printOpenExternalStreamsOn: Stderr.
            ] on: Error do:[:ex|
                Logger log: 'failed to force finalization: ', ex description severity: Logger severityERROR facility: #JVM
            ].
        ] ifFalse:[
            ex pass.
        ].
    ].
    retry ifTrue:[
        stream := aBlock value.
        Logger log: 'good, forced finalization solved the problem' severity: #info facility: #JVM
    ].
    ^stream

    "Created: / 23-07-2012 / 19:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2012 / 02:25:06 / jv"
    "Modified: / 02-03-2015 / 14:02:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStreamForReading:name
    |fn stream tryAlongClassPath|

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opening for read:' , name)
              severity:Logger severityTRACE
              facility:#JVM.
    ].
    fn := name asFilename.
    fn exists  ifFalse:[
        ^JavaVM throwFileNotFoundException: 'File does not exists'
    ].
    fn isDirectory ifTrue:[
        ^JavaVM throwFileNotFoundException: 'File is directory'
    ].
    fn isReadable  ifFalse:[
        ^JavaVM throwFileNotFoundException: 'File is not readable'
    ].

    stream := self commonOpenStreamUsing:[fn readStream].
    stream notNil ifTrue:[^ stream].

    fn isAbsolute ifFalse:[
        "/ if not absolute, try along classPath
        "/ This allows classes to open local files (JEdit)
        "/ even if they have NOT been loaded by a Java classLoader.
        "/ Only do this for image files
        "/ (and maybe some other config files in the future),
        "/ to avoid security holes.
        tryAlongClassPath := true.
"/        tryAlongClassPath := false.
"/        (fn hasSuffix:'gif') ifTrue:[
"/            tryAlongClassPath := true.
"/        ].
"/        (fn hasSuffix:'jpg') ifTrue:[
"/            tryAlongClassPath := true.
"/        ].

        tryAlongClassPath ifTrue:[
            Java effectiveClassPath do:[:dirName |
                |fn|

                (fn := dirName asFilename construct:name) exists ifTrue:[
                    fn isReadable ifFalse:[
                        JavaVM throwFileNotFoundException: 'File is not readable'.
                        ^nil
                    ].
                    stream := fn readStream.
                    stream notNil ifTrue:[^ stream].
                ]
            ]
        ]
    ].
    ^ nil.

    "Modified: / 27-01-1999 / 18:54:46 / cg"
    "Modified: / 24-04-2013 / 11:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fixFilename:path
    OperatingSystem isMSDOSlike ifTrue:[
	(#($/ $\) includes:(path at:1)) ifTrue:[
	    (path at:3) == $: ifTrue:[
		^ path copyFrom:2
	    ]
	]
    ].
    ^ path

    "Created: / 20.10.1998 / 20:58:45 / cg"
    "Modified: / 20.10.1998 / 21:06:49 / cg"
!

getOpenFileAt:idx
    ^ OpenFileTable at:idx+1 ifAbsent:nil.

    "Created: / 2.1.1998 / 18:28:01 / cg"
    "Modified: / 2.1.1998 / 18:33:06 / cg"
!

setOpenFile:aStream at:idx
    OpenFileTable size < (idx+1) ifTrue:[
        OpenFileTable grow:idx+1.
    ].
    OpenFileTable at:idx+1 put:aStream.

"/    Do not shrink OpenFileTable now, make debugging easier
"/    aStream isNil ifTrue:[
"/        [ OpenFileTable last isNil ] whileTrue:[
"/            OpenFileTable removeLast.
"/        ]
"/    ].

    "Modified: / 02-01-1998 / 18:33:21 / cg"
    "Modified: / 14-11-2011 / 19:53:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateFile:javaStream
    |fileNo file|

    fileNo := self validateFileNo:javaStream.
    file := self getOpenFileAt:fileNo.

    file isNil ifTrue:[
        JavaVM
            throwIOExceptionWithMessage:('stream with file descriptor %1 closed or was never open'
            bindWith:fileNo).
        ^ nil
    ].

    ^ file

    "Created: / 04-01-1998 / 16:50:38 / cg"
    "Modified: / 28-07-2012 / 02:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateFileDescriptor: jFileDescriptor
    "Validates given instance of java.io.FileDescriptor.
     If it is valid, return underlying Smalltalk stream,
     otherwise, throws java.io.IOException"

    | fileNo stream |

    fileNo := jFileDescriptor instVarNamed:'fd'.
    ((fileNo == -1) and:[OperatingSystem isMSWINDOWSlike]) ifTrue:[
        fileNo := jFileDescriptor instVarNamed:'handle'.
    ].
    fileNo isInteger ifFalse:[
        JavaVM throwIOExceptionWithMessage:'Invalid fd in java.io.FileDescriptor'.
        ^ nil
    ].
    fileNo == -1 ifTrue:[
        JavaVM throwIOExceptionWithMessage:'java.io.FileDescriptor not open'.
        ^ nil
    ].
    stream := self getOpenFileAt:fileNo.
    stream isNil ifTrue:[
        JavaVM
    throwIOExceptionWithMessage:'Stale descriptor in java.io.FileDescriptor (VM stream does not exists)'.
        ^nil
    ].
    ^ stream.

    "Created: / 06-07-2012 / 23:02:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateFileNo:javaStream
    |fileNo descriptor|

    "/ JDK 1.1.3 has fileDescriptor wrapped
    "/ JDK 1.0 has it directly as integer

    fileNo := javaStream instVarNamed:'fd'.
    fileNo isInteger ifFalse:[
        descriptor := fileNo.
        descriptor notNil ifTrue:[
            fileNo := descriptor instVarNamed:'fd'.
            ((fileNo == -1) and:[OperatingSystem isMSWINDOWSlike]) ifTrue:[
                fileNo := descriptor instVarNamed:'handle'.
            ].
            fileNo isInteger ifFalse:[
                JavaVM
    throwIOExceptionWithMessage:('invalid fd value in FileDescriptor (%1 [%2])'
            bindWith:fileNo
            with:fileNo class).
                ^self
            ].
            ^fileNo
        ]
    ].

    fileNo isInteger ifFalse:[
"/        self halt:'invalid fileNo in read'.
"/        self internalError:'invalid fileNo in read'.
        JavaVM
    throwIOExceptionWithMessage:('invalid fd value in stream object (%1 [%2])'
            bindWith:fileNo
            with:fileNo class).
        ^ nil
    ].

    ^ fileNo.

    "Created: / 04-01-1998 / 17:49:08 / cg"
    "Modified: / 13-01-1998 / 14:07:47 / cg"
    "Modified: / 18-08-2011 / 20:03:37 / jv"
    "Modified: / 28-07-2012 / 02:42:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'helpers - reflection'!

invoke: jmethod receiver: obj arguments: args context: context "of the native method" constructor: isConstructor

    "Common helper for invoking methods and ctors. Performs
     (type) checks and unboxing. Return (possibly boxed) return value."

    | method parameterTypes bargs bargss retval retcls bi executionEx |

    method := Reflection methodForJavaConstructorObject: jmethod.
    parameterTypes := jmethod instVarNamed: #parameterTypes.

    (obj isNil and:[method isStatic not]) ifTrue:[
        JavaVM throwNullPointerException.
        ^nil.
    ].

    "/ Possibly box/unbox arguments
    args notEmptyOrNil ifTrue:[
        bargs := Array new: (bargss := method numArgs).
        bi := 1.
        1 to: args size do:[:i|
            | cls |
            bi > bargss ifTrue:[
"/                self breakPoint: #jv.
                JavaVM throwIllegalArgumentException: 'passed more arguments than expected'.
            ].

            cls := Reflection classForJavaClassObject: (parameterTypes at: i).
            cls isJavaPrimitiveType ifTrue:[
                bargs at: bi put: (cls javaUnbox: (args at:i) onError:[
"/                    self breakPoint: #jv.
                    JavaVM throwIllegalArgumentException:'illegal unbox'. ^nil
                ]).
                (cls == LargeInteger or:[cls == Float]) ifTrue:[bi := bi + 1].
            ] ifFalse:[
                ((args at:i) isNil or:[(JavaVM canCast: (args at:i) class to: cls)]) ifFalse:[
                    self breakPoint: #jv.
                    JavaVM throwIllegalArgumentException:'incomplatible argument types'. ^nil.
                ].
                bargs at: bi put: (args at:i).
            ].
            bi := bi + 1.
       ].
        bi <= bargss ifTrue:[
"/             self breakPoint: #jv.
             JavaVM throwExceptionClassName: 'java.lang.reflect.InvocationTargetException'
                              withMessage: 'not enough arguments'
        ].
    ] ifFalse:[
        bargs := #()
    ].

    "Check number of arguments"
    method numArgs ~= bargs size ifTrue:[
        JavaVM throwIllegalArgumentException:'Invalid number of arguments'.
        ^nil.
    ].

    "Lookup the method here - hack, because of those stupid package private methods"
    method isStatic ifFalse:[
        method := JavaLookup instance
                    lookupMethodForSelector: method selector
                                 directedTo: obj class
                                        for: obj
                              withArguments: bargs
                                       from: context
                                        ilc: nil.
        method isNil ifTrue:[
            JavaVM throwIllegalArgumentException:'Message not understood - invalid class for ''this'''.
            ^nil.
        ].
    ].

    "/ Apparently, invocation of interface method initializes the class,
    "/ so check whether the method is an interface one and if so, initialize
    "/ the interface...
    (isConstructor not and:[method isStatic not and:[method javaClass interfaces notEmpty]]) ifTrue:[
        | selector ifacesQ ifacesSeen |

        selector := method selector.
        ifacesQ := OrderedCollection with: (method javaClass interfaces).
        ifacesSeen := Set new.
        [ ifacesQ notEmpty ] whileTrue:[
            | ifaces newIfaces m |

            ifaces := ifacesQ removeFirst.
            ifaces do:[:iface |
                (ifacesSeen includes: iface) ifFalse:[
                    ifacesSeen add: iface.
                    m := iface compiledMethodAt: selector.
                    m notNil ifTrue:[
                        "/ OK, it's an interface method, initialize the class
                        m javaClass classInit.
                    ].
                ].
            ].
            m isNil ifTrue:[
                newIfaces := Set new.
                ifaces do:[:iface| newIfaces addAll: iface interfaces ].
                newIfaces notEmpty ifTrue:[
                    ifacesQ add: newIfaces.
                ].
            ] ifFalse:[
                "/ It's an inteface method, so clear the queue to terminate the loop.
                ifacesQ := #()
            ].
        ]
    ].


    "Fire the method"
    [
        retval := method isStatic
            ifTrue:[ method valueWithReceiver: method javaClass arguments: bargs ]
            ifFalse:[ method valueWithReceiver: obj arguments: bargs ].
    ] on: (JavaVM classForName:'java.lang.Throwable' definedBy:nil) do:[:ex |
        executionEx := ex.
    ].
    executionEx notNil ifTrue:[
        JavaVM throwInvocationTargetException: 'An exception occured during invocation' target: executionEx.
        ^nil.
    ].

    isConstructor ifFalse:[
        retcls := jmethod instVarNamed: #returnType.
        retcls notNil ifTrue:[
            retcls := JavaVM classForJavaClassObject: retcls.
            retcls ~~ UndefinedObject ifTrue:[
                retval := retcls javaBox: retval.
            ]
        ].
    ].
    ^retval.

    "Created: / 05-07-2012 / 23:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2013 / 21:30:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'helpers - zip'!

getZipArchiveAt:index
    | zar |

    "Kludge for BCC 5.5 as it does not allow for more than 50 files to be opened at time Sigh"

    zar := ZipCache at:index.
    OperatingSystem isUNIXlike ifTrue:[
        ^zar
    ].
    zar == ZipCacheLastAccessed ifFalse:[
        ZipCacheLastAccessed := zar.
    ].
    ^zar

    "Created: / 11-02-2013 / 12:32:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2016 / 22:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - UNPORTED'!

_AccessController_beginPrivileged: nativeContext
    "/ introduced with jdk1.2

    "Created: / 27.1.1998 / 18:18:11 / cg"
!

_AccessController_endPrivileged: nativeContext
    "/ introduced with jdk1.2

    "Created: / 27.1.1998 / 18:18:32 / cg"
!

_AudioDevice_audioClose: nativeContext
    |device fd stream|

    device := nativeContext receiver.
    device notNil ifTrue:[
        fd := device instVarNamed:'dev'.
        (fd notNil and:[fd > 0]) ifTrue:[
            stream := self getOpenFileAt:fd.
            stream notNil ifTrue:[
                stream close.
                device instVarNamed:'dev' put:0.
            ]
        ]
    ]

    "Created: / 10.1.1998 / 15:45:16 / cg"
    "Modified: / 13.1.1998 / 18:08:20 / cg"
!

_AudioDevice_audioOpen: nativeContext
    |f stream fileNo|

    NoAudio ifTrue:[
        Transcript showCR:'JAVA: audio disabled'.
        ^ -1
    ].

    Stream streamErrorSignal handle:[:ex |
        Stream streamErrorSignal handle:[:ex |
            stream := nil.
            ex return.
        ] do:[
            stream := SoundStream writing.
        ].
    ] do:[
        stream := SoundStream writing.
        stream notNil ifTrue:[
            stream setSampleRate:8000.
        ]
    ].
    stream isNil ifTrue:[
"/        ^ -1.

        f := '/dev/audio' asFilename.
        f exists ifFalse:[
            Transcript showCR:'JAVA: neither SoundStream nor /dev/audio available'.
            ^ -1
        ].
        stream := self commonOpenStreamUsing: [f readWriteStream].
        stream isNil ifTrue:[
            Transcript showCR:'JAVA: /dev/audio exists, but cannot be opened'.
            ^ -1
        ].
        fileNo := self addOpenFile:stream.
    ].

    fileNo := self addOpenFile:stream.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opened audioDevice as FD ' , fileNo printString)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    ^ fileNo

    "Created: / 10-01-1998 / 15:45:30 / cg"
    "Modified: / 14-10-1998 / 15:20:52 / cg"
    "Modified: / 23-07-2012 / 19:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_AudioDevice_audioWrite: nativeContext
    |device fd stream bytes count|

    device := nativeContext receiver.
    device notNil ifTrue:[
        fd := device instVarNamed:'dev'.
        (fd notNil and:[fd > 0]) ifTrue:[
            stream := self getOpenFileAt:fd.
            stream notNil ifTrue:[
                bytes := nativeContext argAt:1.
                count := nativeContext argAt:2.
                stream nextPutBytes:count from:bytes startingAt:1
            ]
        ]
    ]

    "Created: / 10.1.1998 / 15:45:16 / cg"
    "Modified: / 13.1.1998 / 18:07:20 / cg"
!

_BigInteger_plumbInit: nativeContext
    JavaVM unimplementedNativeMethodSignal raiseRequest

    "Modified: / 12.11.1998 / 19:23:00 / cg"
!

_ColorModel_deletepData: nativeContext
    "/ void deletepData ()
    JavaVM unimplementedNativeMethodSignal raiseRequest

    "Created: / 12.11.1998 / 19:22:05 / cg"
!

_ColorModel_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:19:23 / cg"
!

_Constructor_getModifiers: nativeContext
    "/ int getModifiers ()

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 02:54:38 / cg"
!

_Constructor_newInstance: nativeContext
    "/ java.lang.Object newInstance (java.lang.Object[])

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
!

_Field_get: nativeContext
    "/ java.lang.Object get (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:04:18 / cg"
!

_Field_getBoolean: nativeContext
    "/ boolean getBoolean (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:05:16 / cg"
!

_Field_getByte: nativeContext
    "/ byte getByte (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:05:30 / cg"
!

_Field_getChar: nativeContext
    "/ char getChar (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:03:37 / cg"
!

_Field_getDouble: nativeContext
    "/ double getDouble (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:07:49 / cg"
!

_Field_getFloat: nativeContext
    "/ float getFloat (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:05:41 / cg"
!

_Field_getInt: nativeContext
    "/ int getInt (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:04:47 / cg"
!

_Field_getLong: nativeContext
    "/ long getLong (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:05:54 / cg"
!

_Field_getModifiers: nativeContext
    "/ int getModifiers ()

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:07:03 / cg"
!

_Field_getShort: nativeContext
    "/ unsigned short getShort (java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:07:35 / cg"
!

_Field_set: nativeContext
    "/ void set (java.lang.Object java.lang.Object)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:04:33 / cg"
!

_Field_setBoolean: nativeContext
    "/ void setBoolean (java.lang.Object boolean)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:06:06 / cg"
!

_Field_setByte: nativeContext
    "/ void setByte (java.lang.Object byte)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:06:20 / cg"
!

_Field_setChar: nativeContext
    "/ void setChar (java.lang.Object char)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:03:48 / cg"
!

_Field_setDouble: nativeContext
    "/ void setDouble (java.lang.Object double)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:04:02 / cg"
!

_Field_setFloat: nativeContext
    "/ void setFloat (java.lang.Object float)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:06:48 / cg"
!

_Field_setInt: nativeContext
    "/ void setInt (java.lang.Object int)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:05:04 / cg"
!

_Field_setLong: nativeContext
    "/ void setLong (java.lang.Object long)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:06:37 / cg"
!

_Field_setShort: nativeContext
    "/ void setShort (java.lang.Object unsigned short)

JavaVM unimplementedNativeMethodSignal raiseRequest.

    "Modified: / 27.1.2000 / 02:53:55 / cg"
    "Created: / 27.1.2000 / 03:03:23 / cg"
!

_FileDescriptor_initSystemFD: nativeContext
    |descriptor fileNo myStream|

    descriptor := nativeContext argAt:1.
    fileNo := nativeContext argAt:2.

    fileNo == 0 ifTrue:[
        myStream := Stdin
    ] ifFalse:[
        fileNo == 1 ifTrue:[
           myStream := JavaConsoleStream ? Stdout
        ] ifFalse:[
            fileNo == 2 ifTrue:[
                myStream := JavaConsoleStream ? Stderr
            ] ifFalse:[
                self halt:'invalid fileNo given'.
                self internalError:'invalid fileNo given'.
            ]
        ]
    ].

    self setOpenFile:myStream at:fileNo.

    descriptor instVarNamed:'fd' put:fileNo.
    ^ descriptor

    "Modified: / 27-01-1998 / 18:15:28 / cg"
    "Modified (format): / 28-07-2012 / 02:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_FileDescriptor_valid: nativeContext
    "/ boolean valid ()
    |descriptor fileNo stream|

    descriptor := nativeContext receiver.
    fileNo := descriptor instVarNamed:'fd'.
    stream := self getOpenFileAt:fileNo.
    stream isNil ifTrue:[^ 0]. "/ FALSE
    stream isOpen ifFalse:[^ 0].  "/ FALSE

    ^ 1 "/ TRUE

    "Modified: / 11.12.1998 / 13:02:47 / cg"
!

_FileInputStream_close: nativeContext
    ^ self anyStream_close: nativeContext

    "Created: / 4.1.1998 / 17:45:23 / cg"
    "Modified: / 4.2.1998 / 15:20:46 / cg"
!

_FileOutputStream_close: nativeContext
    ^ self anyStream_close: nativeContext

    "Created: / 13.1.1998 / 09:33:16 / cg"
    "Modified: / 4.2.1998 / 15:20:53 / cg"
!

_File_canonPath: nativeContext
    "/ introduced with jdk1.2 ... (sigh)

    |jPath path realPath|

    jPath := nativeContext argAt:1.
    jPath isNil ifTrue:[^ jPath].

    path := Java as_ST_String:jPath.
    realPath := path asFilename pathName.

    ^ Java as_String:realPath

    "Created: / 27.1.1998 / 18:35:58 / cg"
    "Modified: / 27.1.1998 / 21:36:03 / cg"
!

_File_initIDs: nativeContext
    "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 18:25:19 / cg"
!

_File_rmdir0: nativeContext
    "/ boolean rmdir0 ()
    JavaVM unimplementedNativeMethodSignal raiseRequest

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:03:52 / cg"
!

_Float_floatToIntBits: nativeContext
    |f i|

    f := nativeContext argAt:1.

    UninterpretedBytes isBigEndian ifTrue:[
        i := f basicAt:4.
        i := i bitOr:((f basicAt:3) bitShift:8).
        i := i bitOr:((f basicAt:2) bitShift:16).
        i := i bitOr:((f basicAt:1) bitShift:24).
    ] ifFalse:[
        i := f basicAt:1.
        i := i bitOr:((f basicAt:2) bitShift:8).
        i := i bitOr:((f basicAt:3) bitShift:16).
        i := i bitOr:((f basicAt:4) bitShift:24).
    ].

    ^ i.

    "Created: / 4.1.1998 / 01:25:50 / cg"
!

_FontDescriptor_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:30:52 / cg"
!

_Font_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 27.1.1998 / 21:43:25 / cg"
!

_GifImageDecoder_parseImage: nativeContext
    |decoder width height bool1 depth subHdrBytes dstBytes i1 i2 colorModel
     stream compressedData compressedSize index count data
     leftOffs topOffs codeLen flags pixelStore clrModel t buffSize
     countGot|

    decoder := nativeContext receiver.

    i1 := nativeContext argAt:1.
    i2 := nativeContext argAt:2.
    width := nativeContext argAt:3.
    height := nativeContext argAt:4.
    bool1 := nativeContext argAt:5.
    depth := nativeContext argAt:6.
    subHdrBytes := nativeContext argAt:7.
    dstBytes := nativeContext argAt:8.
    colorModel := nativeContext argAt:9.

    leftOffs := subHdrBytes wordAt:1 MSB:false.
    topOffs := subHdrBytes wordAt:3 MSB:false.
    width := subHdrBytes wordAt:5 MSB:false.
    height := subHdrBytes wordAt:7 MSB:false.
    flags := subHdrBytes at:9.
    codeLen := subHdrBytes at:10.

    stream := decoder instVarNamed:'input'.
    pixelStore := decoder instVarNamed:'store'.
    pixelStore isNil ifTrue:[
        ^ 0
    ].

    buffSize := (width * height // 2) max:4096.
    compressedData := ByteArray uninitializedNew:buffSize.
    "get compressed data"
    index := 1.
    count := stream perform:#'read()I'.

    [count notNil and:[count > 0]] whileTrue:[
        (index + count) > buffSize ifTrue:[
            t := ByteArray uninitializedNew:(buffSize * 2).
            t replaceFrom:1 to:buffSize with:compressedData startingAt:1.
            compressedData := t.
            buffSize := buffSize * 2.
        ].
        [count ~~ 0] whileTrue:[
            countGot := stream
                        perform:#'read([BII)I'
                        with:compressedData
                        with:index-1
                        with:count.

            countGot > 0 ifTrue:[
                count := count - countGot.
                index := index + countGot.
            ] ifFalse:[
                count := -1.
            ]
        ].

        count >= 0 ifTrue:[
            count := stream perform:#read.
        ]
    ].
    compressedSize := index - 1.

    data := pixelStore perform:#'allocateLines(I)Ljava/lang/Object;' with:height.
    (data isMemberOf:ByteArray) ifFalse:[
        self halt.
        ^ 0.
    ].
"/    'GIFReader: decompressing ...' infoPrintCR.


    GIFReader
        decompressGIFFrom:compressedData
        count:compressedSize
        into:data
        startingAt:1
        codeLen:(codeLen + 1).

    clrModel := pixelStore instVarNamed:'colormodel'.

    pixelStore
        perform:#'setPixels(IIII[BII)Z'
        withArguments:
            (Array
                with:0        "/ x
                with:0        "/ y
                with:width    "/ w
                with:height   "/ h
                with:data
                with:0        "/ offs
                with:width).   "/ scanSize

    pixelStore  perform:#'imageComplete()V'.
"/        perform:#'imageComplete(I)V'
"/        with:((Java at:'java.awt.image.ImageConsumer') instVarNamed:'STATICIMAGEDONE').

"/ self internalError:'breakPoint'.
    ^ 1 "/ true

    "Modified: / 10.4.1998 / 14:31:59 / cg"
!

_ImageRepresentation_disposeImage: nativeContext
    |imgRep img|

    imgRep := nativeContext receiver.

    img := imgRep instVarNamed:'pData'.
    (img notNil and:[img ~~ 0]) ifTrue:[
        ImageStretchCache notNil ifTrue:[
            ImageStretchCache removeKey:img ifAbsent:nil.
        ]
    ].

    imgRep instVarNamed:'pData' put:0.
"/    self halt.

    "Created: / 7.1.1998 / 22:31:46 / cg"
    "Modified: / 17.1.1998 / 13:26:55 / cg"
!

_ImageRepresentation_finish: nativeContext
    |imgRep bool|

    imgRep := nativeContext receiver.
    bool := nativeContext argAt:1.
"/ self halt.
"/    'JAVA: ImageRepresentation_finish ignored for now' infoPrintCR.

    ^ 1 "/ true

    "Created: / 8.1.1998 / 00:11:40 / cg"
    "Modified: / 6.2.1998 / 02:12:54 / cg"
!

_ImageRepresentation_imageDraw: nativeContext
    |imgRep x y img deviceImage jGraphics gc clr|

    imgRep := nativeContext receiver.
    img := imgRep instVarNamed:'pData'.
    (img isNil or:[img == 0]) ifTrue:[
        "/ self halt.
        ^ self.
    ].
    jGraphics := nativeContext argAt:1.
    gc := jGraphics instVarNamed:'pData'.
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:2.
    y := nativeContext argAt:3.
    clr := nativeContext argAt:4.

    deviceImage := img onDevice:gc device.
    deviceImage ~~ img ifTrue:[
        imgRep instVarNamed:'pData' put:deviceImage.
    ].
    gc realized ifFalse:[^ self].
    deviceImage displayOn:gc x:x y:y.
    ^ 1.

    "Created: / 13.1.1998 / 13:32:28 / cg"
    "Modified: / 25.11.1998 / 15:36:38 / cg"
!

_ImageRepresentation_imageStretch: nativeContext
    |imgRep x1 y1 x2 y2 srcX1 srcY1 w h
     img deviceImage jGraphics gc clr stretchWidth stretchHeight|

    imgRep := nativeContext receiver.
    img := imgRep instVarNamed:'pData'.
    (img isNil or:[img == 0]) ifTrue:[
        "/ self halt.
        ^ self.
    ].

    jGraphics := nativeContext argAt:1.
    gc := jGraphics instVarNamed:'pData'.
    gc realized ifFalse:[^ self].

    x1 := nativeContext argAt:2.
    y1 := nativeContext argAt:3.
    x2 := nativeContext argAt:4.
    y2:= nativeContext argAt:5.
    srcX1 := nativeContext argAt:6.
    srcY1 := nativeContext argAt:7.
    w := nativeContext argAt:8.
    h := nativeContext argAt:9.
    clr := nativeContext argAt:10.

    (srcX1 ~~ 0 or:[srcY1 ~~ 0]) ifTrue:[
        self halt.
        ^ self.
    ].
    (w ~~ img width or:[h ~~ img height]) ifTrue:[
        self halt.
        ^ self
    ].

    "/ TODO: remember magnified images somewhere for a while,
    "/ to avoid repeated action ...

    stretchWidth := (x2-x1).
    stretchHeight := (y2-y1).

    (stretchWidth == img width
    and:[stretchHeight == img height]) ifTrue:[
        deviceImage := img onDevice:gc device.
        deviceImage ~~ img ifTrue:[
            imgRep instVarNamed:'pData' put:deviceImage.
        ].
    ] ifFalse:[
        ImageStretchCache notNil ifTrue:[
            deviceImage := ImageStretchCache at:img ifAbsent:nil.
        ].
        (deviceImage isNil
        or:[deviceImage width ~~ stretchWidth
        or:[deviceImage height ~~ stretchHeight]]) ifTrue:[
            deviceImage := (img magnifiedTo:stretchWidth@stretchHeight) onDevice:gc device.
            ImageStretchCache isNil ifTrue:[
                ImageStretchCache := WeakIdentityDictionary new.
            ].
            ImageStretchCache at:img put:deviceImage
        ].
    ].
    deviceImage displayOn:gc x:x1 y:y1

    "Created: / 13.1.1998 / 13:32:28 / cg"
    "Modified: / 15.1.1998 / 13:14:47 / cg"
!

_ImageRepresentation_offscreenInit: nativeContext
    |imgRep jclr w h form screenDevice|

    imgRep := nativeContext receiver.
    jclr := nativeContext argAt:1.

    w := imgRep instVarNamed:'width'.
    h := imgRep instVarNamed:'height'.

    screenDevice := Screen current.
    form := Form width:w height:h depth:(screenDevice depth) on:screenDevice.

    imgRep instVarNamed:'pData' put:form.
    "/ self halt.

    "Created: / 7.1.1998 / 22:31:46 / cg"
    "Modified: / 17.1.1998 / 12:36:43 / cg"
!

_ImageRepresentation_setBytePixels: nativeContext
    |imgRep x y w h clrModel bytes offs img depth cmap rgbMap opaque transparentColorIndex
     scanLineWidth nBytes srcIdx dstIdx|

    imgRep := nativeContext receiver.
    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    clrModel := nativeContext argAt:5.
    bytes := nativeContext argAt:6.
    offs := nativeContext argAt:7.  "/ offset ??
    scanLineWidth := nativeContext argAt:8.

    depth := clrModel instVarNamed:'pixel_bits'.
    (clrModel instVarNamed:'map_size') ~~ 0 ifTrue:[
        rgbMap := clrModel instVarNamed:'rgb'.
        cmap := Array new:rgbMap size.
        rgbMap
            keysAndValuesDo:[:idx :rgb |
                cmap at:idx put:(Color rgbValue:(rgb bitAnd:16rFFFFFF))
            ].
    ].

    opaque := (clrModel instVarNamed:'opaque') ~~ 0.
    opaque ifFalse:[
        transparentColorIndex := clrModel instVarNamed:'transparent_index'
    ].

    img := imgRep instVarNamed:'pData'.
    (img isNil or:[img == 0]) ifFalse:[
"/        self halt
    ].

    (offs ~~ 0 or:[scanLineWidth ~~ w]) ifTrue:[
        nBytes := ByteArray new:w*h.
        srcIdx := offs+1.
        dstIdx := 1.
        1 to:h do:[:y |
            nBytes replaceFrom:dstIdx to:(dstIdx+w-1) with:bytes startingAt:srcIdx.
            srcIdx := srcIdx + scanLineWidth.
            dstIdx := dstIdx + w.
        ].
        bytes := nBytes.
    ].
    img := Image width:w height:h depth:depth fromArray:bytes.
    cmap notNil ifTrue:[
        img colorMap:cmap.
        img photometric:#palette
    ].
    opaque ifFalse:[
        img mask:(ImageReader
                    buildMaskFromColor:transparentColorIndex
                    for:bytes
                    width:w
                    height:h)
    ].

    imgRep instVarNamed:'pData' put:img.
    ^ 1.

    "Created: / 7.1.1998 / 22:31:46 / cg"
    "Modified: / 21.10.1998 / 00:35:45 / cg"
!

_ImageRepresentation_setIntPixels: nativeContext
    |imgRep x y w h clrModel ints offs scanLineWidth
     img depth cmap rgbMap opaque transparentColorIndex
     bytes srcIdx dstIdx val red green blue
     redMask greenMask blueMask redShift greenShift blueShift|

    imgRep := nativeContext receiver.
    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    clrModel := nativeContext argAt:5.
    ints := nativeContext argAt:6.
    offs := nativeContext argAt:7.  "/ offset ??
    scanLineWidth := nativeContext argAt:8.  "/ scanLineWidth ??
    opaque := false.
offs ~~ 0 ifTrue:[
 self halt
].

    depth := clrModel instVarNamed:'pixel_bits'.
    clrModel class == (Java at:'java.awt.image.DirectColorModel') ifTrue:[
    ] ifFalse:[
        (clrModel instVarNamed:'map_size') ~~ 0 ifTrue:[
            rgbMap := clrModel instVarNamed:'rgb'.
            cmap := Array new:rgbMap size.
            rgbMap
                keysAndValuesDo:[:idx :rgb |
                    cmap at:idx put:(Color rgbValue:(rgb bitAnd:16rFFFFFF))
                ].
        ].
        opaque := (clrModel instVarNamed:'opaque') ~~ 0.
        opaque ifFalse:[
            transparentColorIndex := clrModel instVarNamed:'transparent_index'
        ].
    ].

    img := imgRep instVarNamed:'pData'.
    (img isNil or:[img == 0]) ifFalse:[
"/        self halt.
    ].

    depth == 32 ifTrue:[
        "/ temporary kludge - ony use 24 bits/pixel
        bytes := ByteArray new:w*h*3.
        srcIdx := 1.
        dstIdx := 1.
        redMask := clrModel instVarNamed:'red_mask'.
        greenMask := clrModel instVarNamed:'green_mask'.
        blueMask := clrModel instVarNamed:'blue_mask'.
        redShift := (clrModel instVarNamed:'red_offset') negated.
        greenShift := (clrModel instVarNamed:'green_offset') negated.
        blueShift := (clrModel instVarNamed:'blue_offset') negated.

        1 to:h do:[:y |
            1 to:w do:[:x |
                val := ints at:srcIdx.
                red := (val bitAnd:redMask) bitShift:redShift.
                green := (val bitAnd:greenMask) bitShift:greenShift.
                blue := (val bitAnd:blueMask) bitShift:blueShift.
                bytes at:dstIdx put:red.
                bytes at:dstIdx+1 put:green.
                bytes at:dstIdx+2 put:blue.
                dstIdx := dstIdx + 3.
                srcIdx := srcIdx + 1.
            ].
            srcIdx := srcIdx + (scanLineWidth - w).
        ].
        img := Depth24Image width:w height:h depth:24 fromArray:bytes.
        img photometric:#rgb.
    ] ifFalse:[
        scanLineWidth ~~ w ifTrue:[
            self halt
        ].
        img := Image width:w height:h depth:depth fromArray:ints.
        cmap notNil ifTrue:[
            img colorMap:cmap.
            img photometric:#palette
        ] ifFalse:[
            img photometric:#rgb
        ].
    ].
    opaque ifFalse:[
        img mask:(ImageReader
                    buildMaskFromColor:transparentColorIndex
                    for:ints
                    width:w
                    height:h)
    ].

    imgRep instVarNamed:'pData' put:img.
    ^ 1.

    "Created: / 1.2.1998 / 17:38:47 / cg"
    "Modified: / 21.10.1998 / 00:35:37 / cg"
!

_InetAddressImpl_getHostByAddr: nativeContext
    "/ java.lang.String getHostByAddr (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:08:04 / cg"
!

_InetAddressImpl_getInetFamily: nativeContext
    "/ self unimplementedNativeMethod.
    ^ 0

    "Modified: / 15.8.1997 / 17:04:43 / cg"
    "Created: / 5.1.1998 / 02:05:48 / cg"
!

_InetAddressImpl_getLocalHostName: nativeContext
    ""

    |hostName|

    hostName := OperatingSystem getHostName.

    ^ (Java as_String:hostName).

    "Modified: / 7.8.1997 / 21:16:55 / cg"
    "Created: / 5.1.1998 / 02:07:03 / cg"
!

_InetAddressImpl_lookupAllHostAddr: nativeContext
    ""

    |jAddrImpl jHostName hostName addrBytes|

    jAddrImpl := nativeContext receiver.
    jHostName := nativeContext argAt:1.

    hostName := Java as_ST_String:jHostName.
    addrBytes := Socket ipAddressOfHost:hostName.
    addrBytes isNil ifTrue:[
        addrBytes := #[0 0 0 0] copy
    ].
    ^ Array with:addrBytes

    "Modified: / 8.8.1997 / 12:04:25 / cg"
    "Created: / 7.1.1998 / 18:51:31 / cg"
!

_InetAddressImpl_makeAnyLocalAddress: nativeContext
    ""

    |jAddrImpl jAddr hostName addrBytes address|

    jAddrImpl := nativeContext receiver.
    jAddr := nativeContext argAt:1.

    hostName := OperatingSystem getHostName.
    addrBytes := Socket ipAddressOfHost:hostName.
    addrBytes isNil ifTrue:[
        addrBytes := #[127 0 0 0].
    ].
    "/ MSB first into an integer.
    address := (addrBytes at:1).
    address := (address bitShift:8) bitOr:(addrBytes at:2).
    address := (address bitShift:8) bitOr:(addrBytes at:3).
    address := (address bitShift:8) bitOr:(addrBytes at:4).

    jAddr instVarNamed:'hostName' put:(Java as_String:hostName).
    jAddr instVarNamed:'address' put:address.
    jAddr instVarNamed:'family' put:0.

    ^ nil

    "Created: / 5.1.1998 / 02:06:27 / cg"
    "Modified: / 21.10.1998 / 03:30:29 / cg"
!

_InetAddress_getInetFamily: nativeContext
    "/ self unimplementedNativeMethod.
    ^ 0

    "Modified: / 15.8.1997 / 17:04:43 / cg"
    "Created: / 17.11.1998 / 23:54:38 / cg"
!

_InetAddress_getLocalHostName: nativeContext
    ""

    |hostName|

    hostName := OperatingSystem getHostName.

    ^ Java as_String:hostName.

    "Modified: / 7.8.1997 / 21:16:55 / cg"
    "Created: / 17.11.1998 / 23:54:54 / cg"
!

_InetAddress_lookupAllHostAddr: nativeContext
    ""

    |jAddrImpl jHostName hostName addrBytes|

    jAddrImpl := nativeContext receiver.
    jHostName := nativeContext argAt:1.

    hostName := Java as_ST_String:jHostName.
    addrBytes := Socket ipAddressOfHost:hostName.
    addrBytes isNil ifTrue:[
        addrBytes := #[0 0 0 0] copy
    ].
    ^ Array with:addrBytes

    "Modified: / 8.8.1997 / 12:04:25 / cg"
    "Created: / 17.11.1998 / 23:56:10 / cg"
!

_InetAddress_lookupHostByAddr: nativeContext
    "java.lang.Object[] lookupHostByAddr (int)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:59:22 / cg"
!

_InetAddress_lookupHostByName: nativeContext
    "java.lang.Object[] lookupHostByName (java.lang.String)"

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 02:58:53 / cg"
!

_InetAddress_makeAnyLocalAddress: nativeContext
    ""

    |jAddrImpl jAddr hostName addrBytes address|

    jAddrImpl := nativeContext receiver.
    jAddr := nativeContext argAt:1.

    hostName := OperatingSystem getHostName.
    addrBytes := Socket ipAddressOfHost:hostName.
    addrBytes isNil ifTrue:[
        addrBytes := #[127 0 0 0].
    ].
    "/ MSB first into an integer.
    address := (addrBytes at:1).
    address := (address bitShift:8) bitOr:(addrBytes at:2).
    address := (address bitShift:8) bitOr:(addrBytes at:3).
    address := (address bitShift:8) bitOr:(addrBytes at:4).

    jAddr instVarNamed:'hostName' put:(Java as_String:hostName).
    jAddr instVarNamed:'address' put:address.
    jAddr instVarNamed:'family' put:0.

    ^ nil

    "Modified: / 21.10.1998 / 03:30:29 / cg"
    "Created: / 17.11.1998 / 23:54:00 / cg"
!

_Inflater_end0: nativeContext
    "/ void end0 ()

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:11:21 / cg"
!

_Inflater_getAdler0: nativeContext
    "/ int getAdler0 ()

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:12:15 / cg"
!

_Inflater_getTotalIn0: nativeContext
    "/ int getTotalIn0 ()

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 03:10:50 / cg"
    "Modified: / 27.1.2000 / 03:11:08 / cg"
!

_Inflater_getTotalOut0: nativeContext
    "/ int getTotalOut0 ()

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:12:01 / cg"
!

_Inflater_inflate0: nativeContext
    "/ int inflate0 (byte[] int int)

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:11:39 / cg"
!

_Inflater_reset0: nativeContext
    "/ void reset0 ()

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:11:02 / cg"
!

_Inflater_setDictionary0: nativeContext
    "/ void setDictionary0 (byte[] int int)

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:08:47 / cg"
    "Created: / 27.1.2000 / 03:10:33 / cg"
!

_InputThread_run: nativeContext
    self _WToolkit_eventLoop: nativeContext.

    "Created: / 28.1.1998 / 22:34:47 / cg"
    "Modified: / 28.1.1998 / 22:35:16 / cg"
!

_Introspector_getMethodDescriptor: nativeContext
    "java.lang.String getMethodDescriptor (java.lang.reflect.Method)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:47:43 / cg"
!

_Introspector_getMethodParameterCount: nativeContext
    "int getMethodParameterCount (java.lang.reflect.Method)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:49:15 / cg"
!

_Introspector_getPublicDeclaredMethods0: nativeContext
    "java.lang.reflect.Method[] getPublicDeclaredMethods0 (java.lang.Class)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:48:49 / cg"
!

_JPEGImageDecoder_readImage: nativeContext
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 18:53:30 / cg"
    "Modified: / 12.11.1998 / 18:53:40 / cg"
!

_MButtonPeer_create: nativeContext
    ^ self _WButtonPeer_create: nativeContext
!

_MCanvasPeer_create: nativeContext
    |jCanvasPeer jFrame frame subView|

    jCanvasPeer := nativeContext receiver.

    jFrame := nativeContext argAt:1.
    jFrame isNil ifTrue:[
        self halt:'no frame in canvasPeer create'.
        self internalError:'no frame in canvasPeer create'.
        ^ self.
    ].
    frame := jFrame instVarNamed:'pData'.

    subView := JavaView in:frame.
    subView delegate:self.
    subView javaPeer:jCanvasPeer.

    self createdWindowsView:subView for:jCanvasPeer.

    WindowCreationTrace == true ifTrue:[
        'WCanvasPeer_create: ' print. frame print. ' -> ' print. subView printNL.
    ].

    "Modified: / 16.1.1998 / 13:40:00 / cg"
    "Created: / 18.11.1998 / 00:14:44 / cg"
!

_MComponentPeer_cacheInit: nativeContext

    "Created: / 28.1.1998 / 22:22:30 / cg"
!

_MComponentPeer_handleEvent: nativeContext
    ^ self _WComponentPeer_handleEvent: nativeContext

    "Created: / 18.11.1998 / 00:21:17 / cg"
!

_MComponentPeer_nativeHandleEvent: nativeContext
    ^ self _WComponentPeer_nativeHandleEvent: nativeContext
!

_MComponentPeer_pHide: nativeContext
    ^ self _WComponentPeer_hide: nativeContext

    "Created: / 18.11.1998 / 00:15:18 / cg"
!

_MComponentPeer_pInitialize: nativeContext

    "Created: / 28.1.1998 / 22:27:25 / cg"
!

_MComponentPeer_pReshape: nativeContext
    self commonReshapeComponent: nativeContext

    "Created: / 18.11.1998 / 00:18:17 / cg"
!

_MComponentPeer_pSetBackground: nativeContext
    |view jClr rgb clr|

    view := self viewForWPeer: nativeContext.
    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.

    clr := Color rgbValue:rgb.

    clr := clr on:(view device).
    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view viewBackground:clr.
    view backgroundPaint:clr.
!

_MComponentPeer_pSetFont: nativeContext
    |view jFont stFont name style size|

    view := self viewForWPeer: nativeContext.
    jFont := nativeContext argAt:1.

    stFont := jFont instVarNamed:'pData'.
    (stFont isNil or:[stFont == 0]) ifTrue:[
        name := jFont instVarNamed:'name'.
        style := jFont instVarNamed:'style'.
        size := jFont instVarNamed:'size'.

        stFont := self replacementFontFor:(Java as_ST_String:name) style:style size:size.
        jFont instVarNamed:'pData' put:stFont.
    ].
    view font:stFont.

    ^ nil
!

_MComponentPeer_pSetForeground: nativeContext
    |view jClr rgb clr|

    view := self viewForWPeer: nativeContext.
    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.

    clr := Color rgbValue:rgb.

    clr := clr on:(view device).

    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view foregroundColor:clr.
!

_MComponentPeer_pShow: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.

    "/ frame views are under my browsers own control
    (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
        view beVisible.
        view realize.
    ].

"/    view windowGroup notNil ifTrue:[
"/        windowServer addGroup:(view windowGroup)
"/    ].

    ^ nil

"/ self halt.

    "Modified: / 25.1.1998 / 09:54:07 / cg"
    "Created: / 18.11.1998 / 00:21:51 / cg"
!

_MComponentPeer_setBackground: nativeContext
    |jClr rgb clr view|

    view := self viewForWPeer: nativeContext.

    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.
"/ self halt.
    clr := Color rgbValue:rgb.


    clr := clr on:(view device).

    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view viewBackground:clr.
    view backgroundPaint:clr.

    "Created: / 17.11.1998 / 23:49:41 / cg"
!

_MComponentPeer_setCursor: nativeContext

    "Created: / 28.1.1998 / 22:27:35 / cg"
!

_MComponentPeer_setFont: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/ self halt.

    "Modified: / 25.1.1998 / 01:22:19 / cg"
    "Created: / 17.11.1998 / 23:43:48 / cg"
!

_MComponentPeer_setForeground: nativeContext
    |jClr rgb clr view|

    view := self viewForWPeer: nativeContext.

    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.
"/ self halt.
    clr := Color rgbValue:rgb.

    clr := clr on:(view device).

    view paint:clr.

    "Created: / 17.11.1998 / 23:50:31 / cg"
    "Modified: / 17.11.1998 / 23:57:29 / cg"
!

_MFramePeer_create: nativeContext
    ^ self _WFramePeer_create: nativeContext

    "Created: / 28.1.1998 / 22:25:44 / cg"
!

_MFramePeer_getWindowBackgroundColor: nativeContext
    ^ View defaultViewBackgroundColor rgbValue.

    "Created: / 17.11.1998 / 23:55:42 / cg"
!

_MFramePeer_pHide: nativeContext
    ^ self _WComponentPeer_hide: nativeContext

    "Created: / 28.1.1998 / 22:27:04 / cg"
!

_MFramePeer_pReshape: nativeContext
    self commonReshapeComponent: nativeContext

    "Created: / 28.1.1998 / 22:28:00 / cg"
    "Modified: / 28.1.1998 / 22:29:34 / cg"
!

_MFramePeer_pSetTitle: nativeContext
    self _WWindowPeer__setTitle: nativeContext

    "Created: / 28.1.1998 / 22:30:23 / cg"
!

_MFramePeer_pShow: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.

    "/ frame views are under my browsers own control
    (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
        view beVisible.
        view realize.
    ].

"/    view windowGroup notNil ifTrue:[
"/        windowServer addGroup:(view windowGroup)
"/    ].

    ^ nil

"/ self halt.

    "Modified: / 25.1.1998 / 09:54:07 / cg"
    "Created: / 18.11.1998 / 00:19:59 / cg"
!

_MFramePeer_setInsets: nativeContext

    "Created: / 17.11.1998 / 23:55:32 / cg"
!

_MFramePeer_setResizable: nativeContext
    |view onOff|

    view := self viewForWPeer: nativeContext.

    onOff := (nativeContext argAt:1) == 1.
    view isTopView ifTrue:[
        onOff ifTrue:[
            view minExtent:10@10.
            view maxExtent:(Screen current extent).
        ] ifFalse:[
            view minExtent:view extent.
            view maxExtent:view extent.
        ]
    ] ifFalse:[
        (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
            self halt.
        ]
    ].

"/ 'JAVA: WWindowPeer_setResizable: ' print. view print. ' yes/no: ' print. onOff printNL.

    ^ nil

    "Modified: / 16.1.1998 / 18:08:00 / cg"
    "Created: / 17.11.1998 / 23:51:45 / cg"
!

_MToolkit_callbackLoop: nativeContext
    | toolKit |
    toolKit := nativeContext receiver.
    ^ self.
"/    self halt.
"/        self halt: 'monitors has changer, update me if you know how and why'.
"/    "self wakeup: toolKit."
"/    self halt.
"/    (JavaEventThread notNil and: [ JavaEventThread isDead not ]) ifTrue: [
"/        'JavaVM [warning]: oops - two threads executing eventLoop' errorPrintCR.
"/    ].
"/    JavaEventThread := Processor activeProcess.
"/    [
"/        [ true ] whileTrue: [
"/            AbortSignal handle: [:ex | ex return ] do: [ self doWindowsEventThread. ]
"/        ].
"/    ] valueNowOrOnUnwindDo: [ JavaEventThread := nil. ].

    "Created: / 17-11-1998 / 23:58:33 / cg"
    "Modified: / 08-01-1999 / 17:08:35 / cg"
    "Modified: / 22-11-2011 / 13:25:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_MToolkit_eventLoop: nativeContext
    | toolKit |
    (JavaEventThread notNil and: [ JavaEventThread isDead not ]) ifTrue: [
        'JavaVM [warning]: oops - two threads executing eventLoop' errorPrintCR.
    ].
    toolKit := nativeContext receiver.
    self halt: 'monitors has changer, update me if you know how and why'.
    "self wakeup: toolKit."
    self halt.
    JavaEventThread := Processor activeProcess.
    [
        [ true ] whileTrue: [
            AbortSignal handle: [:ex | ex return ] do: [ self doWindowsEventThread. ]
        ].
    ] valueNowOrOnUnwindDo: [ JavaEventThread := nil. ].

    "Created: / 17-11-1998 / 23:04:29 / cg"
    "Modified: / 08-01-1999 / 17:08:21 / cg"
    "Modified: / 22-11-2011 / 13:24:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_MToolkit_init: nativeContext

    "Created: / 28.1.1998 / 22:21:54 / cg"
!

_MToolkit_loadSystemColors: nativeContext
    ^ self _WToolkit_loadSystemColors: nativeContext
!

_MToolkit_run: nativeContext

    "Created: / 28.1.1998 / 22:22:10 / cg"
!

_Math_IEEEremainder: nativeContext
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 18:52:36 / cg"
!

_Math_acos: nativeContext
    "arc cosine"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>acos' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal arcCos

    "Created: / 7.5.1998 / 00:34:50 / cg"
    "Modified: / 11.11.1998 / 15:08:20 / cg"
!

_Math_asin: nativeContext
    "arc sine"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>asin' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal arcSin

    "Created: / 7.5.1998 / 00:34:26 / cg"
    "Modified: / 11.11.1998 / 15:08:15 / cg"
!

_Math_atan2: nativeContext
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 18:52:52 / cg"
!

_Math_atan: nativeContext
    "arc tangens"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>atan' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal arcTan

    "Created: / 6.2.1998 / 01:24:12 / cg"
    "Modified: / 11.11.1998 / 15:08:11 / cg"
!

_Math_ceil: nativeContext
    "ceiling"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>ceil' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal ceilingAsFloat

    "Created: / 7.1.1998 / 15:43:00 / cg"
    "Modified: / 11.11.1998 / 15:08:04 / cg"
!

_Math_cos: nativeContext
    "cosine"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>cos' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal cos

    "Created: / 7.1.1998 / 15:41:30 / cg"
    "Modified: / 11.11.1998 / 15:07:59 / cg"
!

_Math_exp: nativeContext
    "exponential"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>exp' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal exp

    "Created: / 7.5.1998 / 00:36:19 / cg"
    "Modified: / 11.11.1998 / 15:07:50 / cg"
!

_Math_floor: nativeContext
    "floor"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>floor' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal floorAsFloat

    "Created: / 7.1.1998 / 19:09:21 / cg"
    "Modified: / 11.11.1998 / 15:07:45 / cg"
!

_Math_log: nativeContext
    "natural logarithm"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>log' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal ln

    "Created: / 7.1.1998 / 15:42:19 / cg"
    "Modified: / 30.12.1998 / 17:41:42 / cg"
!

_Math_pow: nativeContext
    "power"

    |dVal1 dVal2|

    dVal1 := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal1 isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>pow' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    dVal2 := nativeContext argAt:3.
"/    (nativeContext argAt:4) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal2 isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>pow' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal1 raisedTo:dVal2

    "Created: / 7.1.1998 / 15:44:13 / cg"
    "Modified: / 11.11.1998 / 15:07:33 / cg"
!

_Math_rint: nativeContext
    |dVal|

    dVal := nativeContext argAt:1.
    ^ dVal rounded asFloat.
!

_Math_sin: nativeContext
    "sine"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>sin' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal sin

    "Created: / 7.1.1998 / 15:41:40 / cg"
    "Modified: / 11.11.1998 / 15:07:09 / cg"
!

_Math_sqrt: nativeContext
    "square root"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>sqrt' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].

    "/ how about domain errors ?
    dVal < 0 ifTrue:[
        ^ 0.0
    ].
    ^ dVal sqrt

    "Created: / 7.1.1998 / 15:42:40 / cg"
    "Modified: / 29.12.1998 / 13:22:36 / cg"
!

_Math_tan: nativeContext
    "tangent"

    |dVal|

    dVal := nativeContext argAt:1.
"/    (nativeContext argAt:2) ~~ DUMMY_DOUBLE_HIGHWORD ifTrue:[
"/        dVal isReal ifTrue:[
"/            'JAVAVM [info]: missing double flag in Math>>tan' infoPrintCR.
"/        ] ifFalse:[
"/            self halt:'expected double arg'
"/        ]
"/    ].
    ^ dVal tan

    "Created: / 7.5.1998 / 00:34:03 / cg"
    "Modified: / 11.11.1998 / 15:07:14 / cg"
!

_MemoryAdvice_register0: nativeContext
    "private native void register0()"

    "/ UnimplementedNativeMethodSignal raise
!

_Method_getModifiers: nativeContext
    |jMethod mthd|

    jMethod := nativeContext receiver.

    mthd := JavaMethods at:jMethod ifAbsent:nil.
    mthd isNil ifTrue:[
        self halt.
        ^ 0
    ].
    ^ mthd accessFlags

    "Modified: / 9.4.1998 / 17:50:01 / cg"
!

_MozillaAppletContext_pMochaOnLoad: nativeContext
    |id|

    id := nativeContext argAt:1.
"/ 'JAVA: MozillaAppletContext_pMochaOnLoad: ' print. id printNL.
    ^ nil

    "Created: / 6.1.1998 / 20:37:13 / cg"
    "Modified: / 6.2.1998 / 02:13:09 / cg"
!

_MozillaAppletContext_pShowDocument: nativeContext
    |jAppletContext s1 s2 s3 js|

    jAppletContext := nativeContext receiver.
    js := nativeContext argAt:1.
    s1 := Java as_ST_String:js.
    js := nativeContext argAt:2.
    s2 := Java as_ST_String:js.
    js := nativeContext argAt:3.
    s3 := Java as_ST_String:js.

    "/ somehow pass it to the html browser ....
Transcript show:'pShowDocument: '; show:s1; show:' / ';
           show:s2; show:' / '; showCR:s3.

    ^ nil

    "Created: / 29.3.1998 / 15:53:17 / cg"
    "Modified: / 29.12.1998 / 13:32:41 / cg"
!

_MozillaAppletContext_pShowStatus: nativeContext
    |s js|

    js := nativeContext argAt:1.
    js isNil ifTrue:[
        s := ''
    ] ifFalse:[
        s := Java as_ST_String:js.
    ].

    self activityNotification:s.
"/ Transcript showCR:s.
    ^ nil

    "Created: / 6.1.1998 / 18:31:34 / cg"
    "Modified: / 22.10.1998 / 01:17:46 / cg"
!

_MozillaAppletContext_setConsoleState0: nativeContext
    "/ void setConsoleState0 (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:23:22 / cg"
!

_ObjectInputStream_allocateNewArray: nativeContext
    "/ java.lang.Object allocateNewArray (java.lang.Class int)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:02:52 / cg"
!

_ObjectInputStream_allocateNewObject: nativeContext
    "/ java.lang.Object allocateNewObject (java.lang.Class java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:02:40 / cg"
!

_ObjectInputStream_inputClassFields: nativeContext
    "/ void inputClassFields (java.lang.Object java.lang.Class int[])
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:02:22 / cg"
!

_ObjectInputStream_invokeDefaultReadObject: nativeContext
    "/ void invokeDefaultReadObject (java.lang.Object java.lang.Class)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 03:00:47 / cg"
!

_ObjectInputStream_invokeObjectReader: nativeContext
    "/ boolean invokeObjectReader (java.lang.Object java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:03:06 / cg"
!

_ObjectInputStream_invokeReadObject: nativeContext
    "/ void invokeReadObject (java.lang.Object java.lang.Class)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 03:01:02 / cg"
!

_ObjectInputStream_loadClass0: nativeContext
    "/ java.lang.Class loadClass0 (java.lang.Class java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:01:15 / cg"
    "Modified: / 12.11.1998 / 19:01:48 / cg"
!

_ObjectOutputStream_invokeDefaultWriteObject: nativeContext
    "/ void invokeDefaultWriteObject (java.lang.Object java.lang.Class)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 03:01:36 / cg"
!

_ObjectOutputStream_invokeObjectWriter: nativeContext
    "/ boolean invokeObjectWriter (java.lang.Object java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:00:36 / cg"
    "Modified: / 12.11.1998 / 19:01:45 / cg"
!

_ObjectOutputStream_invokeWriteObject: nativeContext
    "/ void invokeWriteObject (java.lang.Object java.lang.Class)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 03:01:52 / cg"
!

_ObjectOutputStream_outputClassFields: nativeContext
    "/ void outputClassFields (java.lang.Object java.lang.Class int[])
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:00:09 / cg"
    "Modified: / 12.11.1998 / 19:01:42 / cg"
!

_ObjectStreamClass_doMismatchedRead: nativeContext
    "/ void doMismatchedRead (java.io.ObjectInputStream java.lang.Object)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 02:50:55 / cg"
!

_ObjectStreamClass_findObjectMethod0: nativeContext
    "/ boolean findObjectMethod0 (java.lang.Class int)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 02:51:50 / cg"
!

_ObjectStreamClass_getClassAccess: nativeContext
    "/ int getClassAccess (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:04:19 / cg"
!

_ObjectStreamClass_getClassDefinedUID: nativeContext
    "/ long getClassDefinedUID (java.lang.Class)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 02:51:33 / cg"
!

_ObjectStreamClass_getFieldAccess: nativeContext
    "/ int getFieldAccess (java.lang.Class java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:05:19 / cg"
!

_ObjectStreamClass_getFieldSignatures: nativeContext
    "/ java.lang.String[] getFieldSignatures (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:05:04 / cg"
!

_ObjectStreamClass_getFields0: nativeContext
    "/ java.io.ObjectStreamField[] getFields0 (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:05:32 / cg"
!

_ObjectStreamClass_getMethodAccess: nativeContext
    "/ int getMethodAccess (java.lang.Class java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:04:51 / cg"
!

_ObjectStreamClass_getMethodSignatures: nativeContext
    "/ java.lang.String[] getMethodSignatures (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:04:34 / cg"
!

_ObjectStreamClass_getSerialVersionUID: nativeContext
    "/ long getSerialVersionUID (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:05:43 / cg"
!

_ObjectStreamClass_hasWriteObject: nativeContext
    "/ boolean hasWriteObject (java.lang.Class)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 19:01:48 / cg"
    "Created: / 12.11.1998 / 19:05:53 / cg"
!

_OffScreenImageSource_sendPixels: nativeContext
    "/ self halt.
    "/ UnimplementedNativeMethodSignal raise

    "Modified: / 16.1.1998 / 18:22:23 / cg"
    "Created: / 17.1.1998 / 12:36:25 / cg"
!

_PackedColorModel_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:19:35 / cg"
!

_PlainDatagramSocketImpl_bind: nativeContext
    |jsock jaddr port sock hostName ok err|

    jsock := nativeContext receiver.
    port := nativeContext argAt:1.
    jaddr := nativeContext argAt:2.

    hostName := jaddr instVarNamed:'hostName'.
    hostName isNil ifTrue:[
        self halt.
    ] ifFalse:[
        hostName := Java as_ST_String:hostName
    ].

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket bind to ' , hostName printString , ' port ' 
                          , port printString)
                  severity:Logger severityTRACE
                  facility:#JVM
        ].

        ok := sock bindTo:port address:nil "hostName".
        ok ifFalse:[
            err := OperatingSystem lastErrorString.
            Transcript showCR:'sock err: ' , err printString.
            JavaVM throwIOExceptionWithMessage:'bind failed'.
        ]
    ].

    "Created: / 4.2.1998 / 15:06:20 / cg"
    "Modified: / 30.12.1998 / 20:10:16 / cg"
!

_PlainDatagramSocketImpl_join: nativeContext
    "/ native void join (InetAddress arg1)

    |jsock addr sock|

    jsock := nativeContext receiver.
    addr := nativeContext argAt:1.

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket join ' , addr printString)
                  severity:Logger severityTRACE
                  facility:#JVM
        ].
        JavaVM throwIOExceptionWithMessage:'unimplemented: join'.
self halt.
        ^ nil.  "/ void
    ].

    "Created: / 4.2.1998 / 15:06:20 / cg"
    "Modified: / 30.12.1998 / 20:10:16 / cg"
!

_PlainDatagramSocketImpl_receive: nativeContext
    |jsock jdatagramPacket sock|

    jsock := nativeContext receiver.
    jdatagramPacket := nativeContext argAt:1.

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket receive')
                  severity:Logger severityTRACE
                  facility:#JVM
        ].
        ^ -1.
    ].
    ^ -1

    "Created: / 4.2.1998 / 15:06:20 / cg"
    "Modified: / 30.12.1998 / 20:10:16 / cg"
!

_PlainDatagramSocketImpl_socketGetOption: nativeContext
    |jsock opt sock|

    jsock := nativeContext receiver.
    opt := nativeContext argAt:1.

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket getOption ' , opt printString)
                  severity:Logger severityTRACE
                  facility:#JVM
        ].
        JavaVM throwIOExceptionWithMessage:'unimplemented: getOption'.
self halt.
        ^ -1.
    ].
    ^ -1.

    "Created: / 4.2.1998 / 15:06:20 / cg"
    "Modified: / 30.12.1998 / 20:10:16 / cg"
!

_PlainSocketImpl_socketAvailable: nativeContext
    |jSock sock n|

    jSock := nativeContext receiver.

    sock := self validateFile:jSock.
    sock isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:'socketAvailable on closed socket'.
        ^ self.
    ].

    n := sock numAvailable.
    ^ n

    "Created: / 4.2.1998 / 16:58:49 / cg"
    "Modified: / 30.12.1998 / 20:10:08 / cg"
!

_PlainSocketImpl_socketClose: nativeContext
    |jsock sock|

    jsock := nativeContext receiver.

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:'JAVA: close socket'
                  severity:Logger severityTRACE
                  facility:#JVM
        ].
        sock close.
    ].

    "Modified: / 21.8.1997 / 17:09:40 / cg"
    "Created: / 25.1.1998 / 20:04:24 / cg"
!

_PlatformFont_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:30:41 / cg"
!

_PrintStream_isOutputStreamLocalised: nativeContext
    "/ boolean isOutputStreamLocalised (java.io.DataOutputStream)

    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 03:00:20 / cg"
!

_RandomAccessFile_close: nativeContext
    ^ self anyStream_close: nativeContext

    "Created: / 4.2.1998 / 13:26:53 / cg"
    "Modified: / 4.2.1998 / 15:21:08 / cg"
!

_Runtime_buildLibName: nativeContext
    |jPath jFileName path fileName libName|

    jPath := nativeContext argAt:1.
    jFileName := nativeContext argAt:2.

    path := Java as_ST_String:jPath.
    fileName := Java as_ST_String:jFileName.

    path = '__builtIn__' ifTrue:[
        libName := path , '/' , fileName
    ] ifFalse:[
        libName := path , '/lib' , fileName , '.so'.
    ].
    ^ Java as_String:libName.

    "Modified: / 8.8.1997 / 12:05:05 / cg"
    "Created: / 4.1.1998 / 19:07:14 / cg"
!

_Runtime_execInternal: nativeContext
    "Run a unix-command; return a process object."

    | cmdAndArgArray  envArray  cmd  jProcessClass  jProcess |

    cmdAndArgArray := nativeContext argAt: 1.
    envArray := nativeContext argAt: 2.
    cmd := cmdAndArgArray at: 1.
    OperatingSystem isUNIXlike ifTrue: [
        jProcessClass := JavaVM classForName:'java.lang.UNIXProcess' definedBy:nil.
    ] ifFalse: [ jProcessClass := Java classForName: 'java.lang.Win32Process'. ].

"/

    jProcessClass notNil ifTrue: [
        self halt.
        jProcess := jProcessClass newCleared.
        jProcess
            perform: #'<init>([Ljava/lang/String;[Ljava/lang/String;)V'
            with: cmdAndArgArray
            with: envArray.
        ^ jProcess
    ].
    self halt.
    JavaVM
    throwIOExceptionWithMessage:'Process execution disabled/unimplemented'.
    ^ nil

    "Created: / 15.1.1998 / 01:50:31 / cg"
    "Modified: / 11.12.1998 / 13:09:36 / cg"
!

_Runtime_initializeLinkerInternal: nativeContext
    "init sharedLib linker, return searchPath as javaString"

    |path|

    "/ build a colon-separated string
    path := ''.
    LibPath do:[:comp | 
        path size == 0 ifTrue:[
            path := path , comp
        ] ifFalse:[
            path := path , ':' , comp
        ]
    ].

    ^ Java as_String:path

    "Modified: / 7.8.1997 / 21:17:03 / cg"
    "Created: / 4.1.1998 / 17:53:15 / cg"
!

_Runtime_isInputStreamLocalised: nativeContext
    "/ boolean isInputStreamLocalised (java.io.DataInputStream)

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 03:03:01 / cg"
!

_Runtime_isOutputStreamLocalised: nativeContext
    "/ boolean isOutputStreamLocalised (java.io.DataOutputStream)

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 03:02:49 / cg"
!

_Runtime_loadFileInternal: nativeContext
    "load a sharedLib, return boolean 0 (false) if fail; 1 (true) if ok"

    |ret|

    ret := self _Runtime_loadFileInternalI: nativeContext.
    ret < 0 ifTrue:[ ret := 0 ].
    ^ ret

    "Created: / 4.1.1998 / 19:10:20 / cg"
    "Modified: / 4.1.1998 / 19:11:04 / cg"
!

_Runtime_loadFileInternalI: nativeContext
    "1.1b3 change; load a sharedLib like 'loadFileInternal',
     but return integer:
        -1   outOfMemory error
        0    failed to load
        1    loaded or already loaded (i.e. ok)"

    |jLibName libName libHandle|

    jLibName := nativeContext argAt:1.
    libName := Java as_ST_String:jLibName.

    (SimulatedLibs includes:libName) ifTrue:[
"/        ('JAVA: builtIn libLoad simulated: ' , libName) printNL.
        ^ 1
    ].
    (LoadedLibs notNil and:[LoadedLibs includesKey:libName]) ifTrue:[
"/        ('JAVA: already loaded: ' , libName) printNL.
        ^ 1
    ].

    libName asFilename exists ifFalse:[
        ('JAVA: no file to load: ' , libName) printNL.
        ^ 0
    ].

    (self confirm:'permission to load native library: ' , libName , ' ?') ifFalse:[
        ^ 0
    ].

    libHandle := ObjectFileLoader loadLibrary:libName.
    libHandle isNil ifTrue:[
        ('JAVA: failed to load: ' , libName) printNL.
        ^ 0
    ].

    LoadedLibs isNil ifTrue:[
        LoadedLibs := Dictionary new.
    ].

    LoadedLibs at:libName put:libHandle.
    ^ 1

    "Created: / 4.1.1998 / 19:10:54 / cg"
    "Modified: / 6.2.1998 / 03:11:59 / cg"
!

_Runtime_runFinalization: nativeContext
    "/ void runFinalization ()
"/    UnimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:59:01 / cg"
!

_Runtime_runFinalizersOnExit0: nativeContext
    ""

    |onOff|

    onOff := nativeContext argAt:1.
    ^ 1

    "Modified: / 6.2.1998 / 03:11:59 / cg"
    "Created: / 15.10.1998 / 23:34:55 / cg"
!

_Runtime_setInputStreamLocalised: nativeContext

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:02:27 / cg"
!

_Runtime_setOutputStreamLocalised: nativeContext

JavaVM unimplementedNativeMethodSignal raise.

    "Modified: / 27.1.2000 / 03:02:32 / cg"
!

_Runtime_totalMemory: nativeContext
    "free memory - Returns the total number of bytes"

    ^ ObjectMemory oldSpaceSize + ObjectMemory newSpaceSize

    "Created: / 12.1.1998 / 12:59:23 / cg"
!

_Runtime_traceInstructions: nativeContext
    "/ void traceInstructions (boolean)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:59:18 / cg"
!

_Runtime_traceMethodCalls: nativeContext
    "/ void traceMethodCalls (boolean)
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:59:37 / cg"
!

_ScrollPane_initIDs: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:19:23 / cg"
!

_SecurityManager_classDepth: nativeContext
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:56:27 / cg"
!

_SecurityManager_classLoaderDepth:nativeContext 
    | con  depth |

    con := thisContext sender.
    depth := 1.
    [ con notNil ] whileTrue:[
        con receiver == JavaClassReader classLoaderQuerySignal ifTrue:[
            con selector == #handle:do: ifTrue:[
                depth := depth + 1
            ]
        ].
        con := con sender.
    ].
    Logger 
        log:'JAVA: classLoaderDepth -> ' , depth
        severity:Logger severityTRACE
        facility:#JVM.
    ^ depth.

    "                log:depth"
    "                             severity"

    "Modified: / 02-03-2015 / 15:31:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_SecurityManager_currentClassLoader: nativeContext
    |loader|

    loader := JavaClassReader classLoaderQuerySignal query.
"/ 'JAVA: currentClassLoader -> ' infoPrint. loader displayString infoPrintCR.
    ^ loader.

    "Created: / 13.1.1998 / 09:23:28 / cg"
    "Modified: / 11.12.1998 / 12:39:59 / cg"
!

_SecurityManager_currentLoadedClass0: nativeContext
    JavaVM unimplementedNativeMethodSignal raise

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:56:41 / cg"
!

_SocketInputStream_socketRead: nativeContext
    ^ self anyStream_readBytes: nativeContext

    "Created: / 25.1.1998 / 20:56:53 / cg"
    "Modified: / 4.2.1998 / 15:52:31 / cg"
!

_SocketOutputStream_socketWrite: nativeContext
    ^ self anyStream_writeBytes: nativeContext

    "Created: / 25.1.1998 / 21:06:55 / cg"
    "Modified: / 4.2.1998 / 15:52:40 / cg"
!

_String_compareTo: nativeContext
    "int compareTo (java.lang.String)"

    |jString1 jString2|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:28:59 / cg"
!

_String_equals: nativeContext
    |jString1 jString2|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    ^ (jString1 instVarAt:1) = (jString2 instVarAt:1)

    "Created: / 18.11.1998 / 00:52:03 / cg"
    "Modified: / 18.11.1998 / 00:53:01 / cg"
!

_String_equalsIgnoreCase: nativeContext
    "boolean equalsIgnoreCase (java.lang.String)"

    |jString1 jString2|

self halt:'untested'.

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    ^ (jString1 instVarAt:1) sameAs: (jString2 instVarAt:1)

    "Modified: / 18.11.1998 / 00:53:01 / cg"
    "Created: / 27.1.2000 / 02:27:46 / cg"
!

_String_indexOf: nativeContext
    "int indexOf (java.lang.String int)"

    |jString1 jString2 idx|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    idx := nativeContext argAt:2.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:30:22 / cg"
!

_String_lastIndexOf: nativeContext
    "int lastIndexOf (java.lang.String int)"

    |jString1 jString2 idx|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    idx := nativeContext argAt:2.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:33:59 / cg"
!

_String_length: nativeContext
    |jString|

    jString := nativeContext receiver.
    ^ (jString instVarAt:3)

    "Created: / 18.11.1998 / 00:53:50 / cg"
    "Modified: / 18.11.1998 / 00:54:18 / cg"
!

_String_regionMatches2: nativeContext
    "boolean regionMatches (boolean int java.lang.String int int)"

    |jString1 bool jString2 idx1 idx2|

    jString1 := nativeContext receiver.
    bool := nativeContext argAt:1.
    jString2 := nativeContext argAt:2.
    idx1 := nativeContext argAt:3.
    idx2 := nativeContext argAt:4.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:33:40 / cg"
!

_String_regionMatches: nativeContext
    "boolean regionMatches (int java.lang.String int int)"

    |jString1 jString2 idx1 idx2|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    idx1 := nativeContext argAt:2.
    idx2 := nativeContext argAt:3.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:32:29 / cg"
!

_String_startsWith: nativeContext
    "boolean startsWith (java.lang.String int)"

    |jString1 jString2 idx|

    jString1 := nativeContext receiver.
    jString2 := nativeContext argAt:1.
    idx := nativeContext argAt:2.
JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:31:40 / cg"
!

_SystemColor_GetSysColor: nativeContext
    "/ int GetSysColor (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 27.1.2000 / 02:44:41 / cg"
!

_SystemResourceManager_getEntryFromKey: nativeContext
    "get a resource by name"

    |key s|

    key := nativeContext argAt:1.

    s := Java effectiveClassPath at:(key+1) ifAbsent:nil.
    s isNil ifTrue:[^ nil].
    ^ Java as_String:s

    "Modified: / 22-11-2010 / 13:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_SystemResourceManager_validateSystemResource: nativeContext
    "check a resource"

    |bool str1 str2|

    bool := nativeContext argAt:1.
    str1 := nativeContext argAt:2.
    str2 := nativeContext argAt:3.
    ^ 1 "/ true
!

_System_getCallerClass: nativeContext
    "/ introduced with jdk1.2

    |senderContext cls|

    senderContext := nativeContext sender.
    [senderContext receiver == (Java at:'java.lang.System')] whileTrue:[
        senderContext := senderContext sender.
    ].

    senderContext method isStatic ifTrue:[
        cls := senderContext receiver
    ] ifFalse:[
        cls := senderContext receiver class
    ].
    cls isJavaClass ifTrue:[
        ^ Reflection javaClassObjectForClass:cls
    ].
    (cls isMemberOf:(Java at:'java.lang.Class')) ifTrue:[
        ^ Java at:'java.lang.Class'
    ].
    self halt.
    ^ nil

    "Modified: / 27.1.1998 / 18:33:13 / cg"
!

_System_validateSecurityManager: nativeContext
    "void validateSecurityManager (java.lang.SecurityManager)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:43:25 / cg"
!

_ThreadGroup_initMainThreadGroup0: nativeContext
    "void initMainThreadGroup0 (java.lang.ThreadGroup)"

JavaVM unimplementedNativeMethodSignal raise.

    "Created: / 27.1.2000 / 02:45:52 / cg"
!

_Thread_countStackFrames: nativeContext
    "/ int countStackFrames ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:06:21 / cg"
!

_Thread_start: nativeContext
    "start the thread"

    | jThread  jName  name  stProcess |
    jThread := nativeContext receiver.
    (jThread instVarNamed: 'priority') < 1 ifTrue: [
        self halt.
        jThread instVarNamed: 'priority' put: 1.
    ].
    stProcess := JavaProcess
                for: [
                    | procName |
                    AbortOperationRequest
                        handle: [
                            :ex |
                            procName := stProcess name.
                            (procName startsWith: 'JAVA-AWT-EventQueue') ifTrue: [
                                Logger 
                                      log:('JAVA [info]: thread ' , procName , ' aborted - restarting process.')
                                      severity:Logger severityTRACE
                                      facility:#JVM.
                                ex restart.
                            ] ifFalse: [
                                (stProcess == JavaScreenUpdaterThread
                                    or: [ stProcess == JavaEventQueueThread ])
                                        ifTrue: [
                                            Logger 
                                                  log:('JAVA [info]: thread ' , procName , ' aborted - restarting process.')
                                                  severity:Logger severityTRACE
                                                  facility:#JVM.
                                            ex restart
                                        ]
                                        ifFalse: [ Logger 
                                                         log:('JAVA [info]: thread ' , procName , ' aborted.')
                                                         severity:Logger severityTRACE
                                                         facility:#JVM. ]
                            ].
                        ]
                        do: [
                            [
                                JavaVM javaExceptionSignal
                                    handle: [
                                        :ex |
                                        | exClass |
                                        procName := stProcess name.
                                        exClass := ex parameter class.
                                        exClass == (Java at: 'java.lang.ThreadDeath') ifTrue: [
                                            Logger 
                                                  log:('JAVA: thread ' , procName , ' terminated')
                                                  severity:Logger severityTRACE
                                                  facility:#JVM.
                                        ] ifFalse: [
                                            Transcript
                                                showCR: ('JAVA: thread ''' , procName , ''' terminated with exception: '
                                                        , exClass name).
                                        ].
                                        ex return.
                                    ]
                                    do: [
                                        MessageNotUnderstood
                                            handle: [
                                                :ex |
                                                |
                                                "/ remap doesNotUnderstand with nil-receiver to
                                                "/ a nullPointerException ...
                                                 con  m |
                                                con := ex suspendedContext.
                                                con receiver isNil ifTrue: [
                                                    ((m := con sender method) notNil and: [ m isJavaMethod ]) ifTrue: [
                                                        JavaVM throwNullPointerException.
                                                        AbortSignal raise.

                                                        "/ ex proceed.
                                                    ]
                                                ].
                                                ex reject.
                                            ]
                                            do: [
                                                "/ Transcript showCR:(Timestamp now printString , 'start thread: ', stProcess name).
                                                jThread perform: #'run()V'.
                                                ThreadTrace == true ifTrue: [
                                                    Logger 
                                                          log:('JAVA: thread ' , stProcess name , ' terminated')
                                                          severity:Logger severityTRACE
                                                          facility:#JVM.
                                                ].
                                                jThread perform: #'exit()V'.
                                                ThreadTrace == true ifTrue: [
                                                    Logger 
                                                          log:('JAVA: after exit of thread ' , stProcess name)
                                                          severity:Logger severityTRACE
                                                          facility:#JVM.
                                                ]
                                            ]
                                    ]
                            ] ensure: [
                                | monitors |
                                monitors := EnteredMonitorsPerProcess at: stProcess ifAbsent: nil.
                                monitors notNil ifTrue: [
                                    monitors do: [
                                        :obj |
                                        | mon |
                                        mon := obj getJavaMonitor.
                                        mon notNil ifTrue: [
                                            mon owningProcess == stProcess ifTrue: [
                                                Logger 
                                                      log:('JAVA: release monitor owned by dying thread: ' , stProcess name)
                                                      severity:Logger severityTRACE
                                                      facility:#JVM.
                                                mon release
                                            ].
                                        ].
                                    ].
                                    EnteredMonitorsPerProcess removeKey: stProcess.
                                    stProcess == JavaScreenUpdaterThread ifTrue: [
                                        JavaScreenUpdaterThread := nil.
                                    ].
                                    stProcess == JavaEventQueueThread ifTrue: [ JavaEventQueueThread := nil. ].

"/                                    screenUpdaterClass := Java at:'sun.awt.ScreenUpdater'.
"/                                    screenUpdaterClass notNil ifTrue:[
"/                                        screenUpdaterClass instVarNamed:'updater' put:nil.
"/                                    ].
                                ].
                                Java removeThread: jThread ifAbsent: [].
                            ]
                        ]
                ]
                priority: (Processor activePriority).
    jName := jThread instVarNamed: 'name'.
    jName isString ifFalse: [ name := Java as_ST_String: jName. ] ifTrue: [
        name := jName
    ].

    "/ kludge - remember the ScreenUpdater ...

    name = 'Screen Updater' ifTrue: [ JavaScreenUpdaterThread := stProcess. ] ifFalse: [
        name = 'AWT-Windows' ifTrue: [ JavaEventThread := stProcess. ] ifFalse: [
            (name startsWith: 'AWT-EventQueue') ifTrue: [
                JavaEventQueueThread := stProcess.
            ].
        ]
    ].

"/name = 'UserDialogShowThread' ifTrue:[
"/self halt
"/].
    "/ when that process terminates, wakup any waiters

    stProcess addExitAction: [ self notify: jThread ].
    stProcess name: 'JAVA-' , name.
    stProcess restartable: true.
    stProcess resume.
    Java addThread: jThread for: stProcess.
    ^ nil

    "Created: / 03-01-1998 / 02:05:52 / cg"
    "Modified: / 24-12-1999 / 03:14:33 / cg"
    "Modified: / 09-12-2011 / 12:52:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:20:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_Thread_suspend0: nativeContext
    "yield"

    |jThread stProcess|

    jThread := nativeContext receiver.
    stProcess := JavaVM stProcessForJavaThread:jThread.
    stProcess isNil ifTrue:[
        ThreadTrace == true ifTrue:[
            ('JAVA: no stProcess for javaThread: ' , jThread displayString) printNL.
        ].
        ^ nil "void"
    ].
    stProcess suspend

    "Created: / 8.1.1998 / 01:05:49 / cg"
    "Modified: / 6.2.1998 / 02:15:23 / cg"
!

_Throwable_printStackTrace0: nativeContext
    |out outStream exceptionObject contextList|

    outStream := nativeContext argAt:1.
    exceptionObject := nativeContext receiver.

    contextList := exceptionObject instVarNamed:'backtrace'.

    out := self javaConsoleStream.
    out cr.
    out nextPutLine:'JAVA: stackTrace:'.

    contextList do:[:con |
        out
            nextPutAll:'  ';
            nextPutAll:(con method javaClass fullName);
            nextPutAll:'.';
            nextPutAll:(con method selector);
            nextPutAll:' [';
            nextPutAll:(con method javaClass sourceFile);
            nextPutAll:' ';
            nextPutAll:(con lineNumber displayString);
            nextPutAll:']'.
        out cr
    ].
    out nextPutLine:'----------------------------------------------------'

    "Created: / 04-01-1998 / 14:27:40 / cg"
    "Modified: / 10-11-1998 / 14:19:32 / cg"
    "Modified: / 11-09-2013 / 03:09:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_URLConnection_close: nativeContext
    "/ void close ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:26:03 / cg"
!

_URLConnection_finalize: nativeContext
    "/ void finalize ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:22 / cg"
!

_URLConnection_getContentLength0: nativeContext
    "/ int getContentLength0 ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:34 / cg"
!

_URLConnection_getContentType0: nativeContext
    "/ java.lang.String getContentType0 ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:42 / cg"
!

_URLConnection_getHeaderField0: nativeContext
    "/ java.lang.String getHeaderField0 (java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:53 / cg"
!

_URLConnection_pCreate: nativeContext
    "/ void pCreate (java.lang.String java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:14 / cg"
!

_URLInputStream_available: nativeContext
    "/ int available ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:26 / cg"
!

_URLInputStream_open: nativeContext
    "/ void open ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:01 / cg"
!

_URLInputStream_read: nativeContext
    "/ int read (byte[] int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:12 / cg"
!

_URLOutputStream_open: nativeContext
    "/ void open ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:38 / cg"
!

_URLOutputStream_pClose: nativeContext
    "/ void pClose ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:25:02 / cg"
!

_URLOutputStream_write: nativeContext
    "/ void write (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:45 / cg"
!

_URLOutputStream_writeBytes: nativeContext
    "/ void writeBytes (byte[] int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:24:55 / cg"
!

_URLStreamHandlerFactory_pInit: nativeContext
    "/ self unimplementedNativeMethod.

    "Created: / 10.1.1998 / 15:47:24 / cg"
!

_URLStreamHandlerFactory_pSupportsProtocol: nativeContext
    "/ boolean pSupportsProtocol (java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:23:43 / cg"
!

_VM_getState: nativeContext
    "/ int getState ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:06:44 / cg"
!

_VM_resetJavaMonitor: nativeContext
    "/ void resetJavaMonitor ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 14.11.1998 / 10:43:23 / cg"
!

_VM_resumeJavaMonitor: nativeContext
    "/ void resumeJavaMonitor ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 14.11.1998 / 10:42:49 / cg"
!

_VM_suspendJavaMonitor: nativeContext
    "/ void suspendJavaMonitor ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 14.11.1998 / 10:43:07 / cg"
!

_VM_threadsSuspended: nativeContext
    "/ boolean threadsSuspended ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:07:10 / cg"
!

_VM_unsuspendSomeThreads: nativeContext
    "/ void unsuspendSomeThreads ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:07:29 / cg"
!

_VM_unsuspendThreads: nativeContext
    "/ void unsuspendThreads ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:07:20 / cg"
!

_VM_writeJavaMonitorReport: nativeContext
    "/ void writeJavaMonitorReport ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 14.11.1998 / 10:43:37 / cg"
!

_WButtonPeer_create: nativeContext
    |jButtonPeer jButton jFrame frame button
     lbl|

    jButtonPeer := nativeContext receiver.
    jButton := jButtonPeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    button := Button in:frame.
    button sizeFixed:true.
    button action:[
                        jButtonPeer perform:#'handleAction()V'.
                  ].

    lbl := jButton instVarNamed:'label'.
    lbl notNil ifTrue:[
        lbl := Java as_ST_String:lbl.
        button label:lbl
    ].
    self createdWindowsView:button for:jButtonPeer.

    WindowCreationTrace == true ifTrue:[
        'WButtonPeer_create: ' print. frame print. ' -> ' print. button printNL.
    ].

    "Created: / 5.1.1998 / 01:53:30 / cg"
    "Modified: / 11.12.1998 / 00:19:22 / cg"
!

_WButtonPeer_setLabel: nativeContext
    |label jString|

    jString := nativeContext argAt:1.

    label := self viewForWPeer: nativeContext.
    label label:(Java as_ST_String:jString)

    "Modified: / 8.1.1998 / 17:35:50 / cg"
    "Created: / 1.2.1998 / 17:05:47 / cg"
!

_WCanvasPeer_create: nativeContext
    |jCanvasPeer jFrame frame subView|

    jCanvasPeer := nativeContext receiver.

    jFrame := nativeContext argAt:1.
    jFrame isNil ifTrue:[
        self halt:'no frame in canvasPeer create'.
        subView := JavaView new.
"/        self internalError:'no frame in canvasPeer create'.
"/        ^ self.
    ] ifFalse:[
        frame := jFrame instVarNamed:'pData'.
        subView := JavaView in:frame.
    ].

    subView delegate:self.
    subView javaPeer:jCanvasPeer.

    self createdWindowsView:subView for:jCanvasPeer.

    WindowCreationTrace == true ifTrue:[
        'WCanvasPeer_create: ' print. frame print. ' -> ' print. subView printNL.
    ].

    "Created: / 5.1.1998 / 00:59:19 / cg"
    "Modified: / 16.1.1998 / 13:40:00 / cg"
!

_WCheckboxMenuItemPeer_setState: nativeContext
    "/ void setState (boolean)
"/    UnimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:14:35 / cg"
    "Modified: / 3.12.1998 / 21:41:13 / cg"
!

_WCheckboxPeer_create: nativeContext
    |jCheckboxPeer jCheckbox jFrame frame checkBox lbl|

    jCheckboxPeer := nativeContext receiver.
    jCheckbox := jCheckboxPeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    checkBox := CheckBox in:frame.
    checkBox action:[
                        jCheckboxPeer
                            perform:#'handleAction(Z)V'
                            with:(checkBox isOn ifTrue:[1] ifFalse:[0])
                    ].

    lbl := jCheckbox instVarNamed:'label'.
    lbl notNil ifTrue:[
        lbl := Java as_ST_String:lbl.
        checkBox label:lbl
    ].

    self createdWindowsView:checkBox for:jCheckboxPeer.

    WindowCreationTrace == true ifTrue:[
        'WCheckboxPeer_create: ' print. frame print. ' -> ' print. checkBox printNL.
    ].

    "Created: / 7.1.1998 / 21:48:03 / cg"
    "Modified: / 15.1.1998 / 12:27:04 / cg"
!

_WCheckboxPeer_setCheckboxGroup: nativeContext
    |checkBox jGroup|

    checkBox := self viewForWPeer: nativeContext.

    jGroup := nativeContext argAt:1.

    "Created: / 7.1.1998 / 21:48:47 / cg"
    "Modified: / 25.1.1998 / 01:20:42 / cg"
!

_WCheckboxPeer_setLabel: nativeContext
    "/ void setLabel (java.lang.String)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:14:53 / cg"
!

_WCheckboxPeer_setState: nativeContext
    |checkBox state|

    checkBox := self viewForWPeer: nativeContext.

    state := nativeContext argAt:1.
    state ~~ 0 ifTrue:[
        checkBox turnOn
    ] ifFalse:[
        checkBox turnOff
    ].

    "Created: / 7.1.1998 / 21:49:13 / cg"
    "Modified: / 25.1.1998 / 01:26:18 / cg"
!

_WChoicePeer_addItem: nativeContext
    |jString index comboBox|

    comboBox := self viewForWPeer: nativeContext.

    jString := nativeContext argAt:1.
    index := nativeContext argAt:2.

    comboBox model list addLast:(Java as_ST_String:jString).
    comboBox model changed:#list.

    "Created: / 7.1.1998 / 21:45:12 / cg"
    "Modified: / 24.1.1998 / 18:51:32 / cg"
!

_WChoicePeer_create: nativeContext
    |jChoicePeer jChoice jFrame frame comboBox|

    jChoicePeer := nativeContext receiver.
    jChoice := jChoicePeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    comboBox := ComboListView in:frame.
    comboBox model:(SelectionInList new list:(OrderedCollection new)).
    comboBox action:[:index |
                        jChoicePeer
                            perform:#'handleAction(I)V'
                            with:(comboBox model selectionIndex - 1)
                    ].

    self createdWindowsView:comboBox for:jChoicePeer.

    WindowCreationTrace == true ifTrue:[
        'WChoicePeer_create: ' print. frame print. ' -> ' print. comboBox printNL.
    ].

    "Created: / 7.1.1998 / 21:44:31 / cg"
    "Modified: / 28.1.1998 / 23:19:17 / cg"
!

_WChoicePeer_remove: nativeContext
    "/ void remove (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:12:20 / cg"
!

_WChoicePeer_reshape: nativeContext
    self commonReshapeComponent: nativeContext.
"/    self pReshape: nativeContext.
    ^ self.

    "Created: / 7.1.1998 / 21:46:18 / cg"
    "Modified: / 23.12.1998 / 19:08:07 / cg"
!

_WChoicePeer_select: nativeContext
    |comboBox index|

    comboBox := self viewForWPeer: nativeContext.

    index := nativeContext argAt:1.
    comboBox model selectionIndex:(index + 1).  "/ JAVA indexing starts at 0

    "Created: / 7.1.1998 / 21:45:43 / cg"
    "Modified: / 25.1.1998 / 09:55:05 / cg"
!

_WClipboard_getClipboardText: nativeContext
    "/ java.lang.String getClipboardText ()

    |str|

    str := Screen current rootView getTextSelection.
    str isNil ifTrue:[
        str := ''.
    ].
    ^ Java as_String:''.

    "Modified: / 10.12.1998 / 21:28:29 / cg"
!

_WClipboard_init: nativeContext
"/ self halt.

    "Modified: / 18.3.1997 / 18:43:18 / cg"
    "Created: / 4.1.1998 / 19:03:59 / cg"
!

_WClipboard_setClipboardText: nativeContext
    "/ void setClipboardText (java.awt.datatransfer.StringSelection)

    |strSel data|

    strSel := nativeContext argAt:1.
    data := strSel instVarNamed:'data'.
    data class == (Java at:'java.lang.String') ifTrue:[
        Screen current rootView setClipboardText:(Java as_ST_String:data)
    ].
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:15:31 / cg"
    "Modified: / 10.12.1998 / 21:25:20 / cg"
!

_WColor_getDefaultColor: nativeContext
    | clrIndex  jClr  clr |

    clrIndex := nativeContext argAt: 1.

    "/ windows defaults:
    "/  1: view background

    clrIndex == 1 ifTrue: [
        clr := View defaultViewBackgroundColor.
        clr isColor ifFalse: [ clr := Color gray: 50. ].
    ].
    clrIndex == 2 ifTrue: [ clr := Color black. ].
    clr isNil ifTrue: [
        self halt.
        self internalError: 'breakpoint'.
        ^ nil.
    ].
    clr := clr on: (Screen current).
    jClr := (JavaVM classForName:'java.awt.Color' definedBy:nil) new.
    jClr instVarNamed: 'pData' put: clr.
    jClr instVarNamed: 'value' put: (clr rgbValue).

"/ self halt.

    ^ jClr.

    "Created: / 15.8.1997 / 15:38:10 / cg"
    "Modified: / 4.1.1998 / 18:06:51 / cg"
!

_WComponentPeer__beginValidate: nativeContext
    "/ void _beginValidate ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:10:08 / cg"
!

_WComponentPeer__dispose: nativeContext
    |view jPeer|

    view := self viewForWPeer: nativeContext.

    Error catch:[
        view destroy.
    ].
    JavaWindowGroup removeView:view.

    jPeer := nativeContext receiver.
    jPeer instVarNamed:'pData' put:0.

    "Created: / 7.1.1998 / 22:36:25 / cg"
    "Modified: / 25.1.1998 / 16:43:06 / cg"
!

_WComponentPeer__setBackground: nativeContext
    |rgb clr view|

    view := self viewForWPeer: nativeContext.
    view isNil ifTrue:[^ self].

    rgb := nativeContext argAt:1.
    clr := Color rgbValue:rgb.

"/ self halt.
"/ self internalError:'breakPoint'.

    clr := clr on:(view device).

"/    (view superView isMemberOf:JavaEmbeddedFrameView) ifTrue:[
"/        view viewBackground:(view superView viewBackground).
"/        view backgroundPaint:(view superView viewBackground).
"/    ] ifFalse:[
"/        (view isMemberOf:JavaView) ifTrue:[
"/            view viewBackground:clr.
"/            view backgroundPaint:clr.
"/        ]
"/    ].

    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view viewBackground:clr.
    view backgroundPaint:clr.

    "Created: / 4.1.1998 / 18:07:39 / cg"
    "Modified: / 4.12.1998 / 17:26:06 / cg"
!

_WComponentPeer__setForeground: nativeContext
    |rgb clr view|

    view := self viewForWPeer: nativeContext.

    rgb := nativeContext argAt:1.
    clr := Color rgbValue:rgb.

"/ self halt.
"/ self internalError:'breakPoint'.

    clr := clr on:(view device).

    view paint:clr.

    "Created: / 4.1.1998 / 18:08:13 / cg"
    "Modified: / 8.1.1998 / 17:32:45 / cg"
!

_WComponentPeer_disable: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.

    Error
        handle:[:ex |]
        do:[
            view disable
        ]

    "Created: / 6.1.1998 / 18:26:36 / cg"
    "Modified: / 8.1.1998 / 17:32:53 / cg"
!

_WComponentPeer_enable: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.

    Error handle:[:ex |
    ] do:[
        view enable
    ]

    "Modified: / 8.1.1998 / 17:32:53 / cg"
    "Created: / 13.1.1998 / 23:08:05 / cg"
!

_WComponentPeer_endValidate: nativeContext
    "/ void endValidate ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:10:20 / cg"
!

_WComponentPeer_getLocationOnScreen: nativeContext
    "/ java.awt.Point getLocationOnScreen ()

    | view  p  jP |

    view := self viewForWPeer: nativeContext.
    view isNil ifTrue: [ ^ nil ].
    p := view originRelativeTo: nil.
    jP := (JavaVM classForName:'java.awt.Point' definedBy:nil) basicNew.
    jP instVarNamed: 'x' put: p x.
    jP instVarNamed: 'y' put: p y.
    ^ jP

    "Modified: / 5.12.1998 / 14:44:31 / cg"
!

_WComponentPeer_handleEvent: nativeContext
    "this is invoked by java, to let a widget handle any event which
     was not consumed (eaten) by java.
     If the view in question is some ST-widget, forward it.
     Ignore for JavaViews."

    |view jEv stEv ignore|

    view := self viewForWPeer: nativeContext.
    view notNil ifTrue:[
        jEv := nativeContext argAt:1.
        stEv := jEv instVarNamed:'data'.
        (stEv notNil and:[stEv ~~ 0]) ifTrue:[
            ignore := true.
            view isJavaView ifFalse:[
                ignore := false
            ] ifTrue:[
                view isTopView ifTrue:[
                    stEv type == #terminate ifTrue:[
                        ignore := false
                    ].
                ]
            ].

            ignore ifFalse:[
                EventTrace == true ifTrue:[
                    Logger 
                          log:('JAVA: WComponent - handleEvent: ' , stEv type , ' for ' 
                                  , view printString)
                          severity:Logger severityTRACE
                          facility:#JVM.
                ].
                view dispatchEvent:stEv.
                ^ self.
            ].

            EventTrace == true ifTrue:[
                Logger 
                      log:('JAVA: WComponent - handleEvent ignored:' , stEv type)
                      severity:Logger severityTRACE
                      facility:#JVM.
            ].
            ^ self
        ]
    ].
    EventTrace == true ifTrue:[
        Logger 
              log:('JAVA: WComponent - handleEvent ignored')
              severity:Logger severityTRACE
              facility:#JVM.
    ]

    "Created: / 6.1.1998 / 21:10:17 / cg"
    "Modified: / 11.12.1998 / 01:04:14 / cg"
!

_WComponentPeer_hide: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/ view isPopUpView ifTrue:[self halt].

    Error handle:[:ex |
    ] do:[
        view beInvisible
    ]

    "Created: / 7.1.1998 / 22:35:32 / cg"
    "Modified: / 4.12.1998 / 17:53:41 / cg"
!

_WComponentPeer_nativeHandleEvent: nativeContext
    "this is invoked by java, to let a widget handle any event which
     was not consumed (eaten) by java.
     If the view in question is some ST-widget, forward it.
     Ignore for JavaViews."

^self.

"/    |view jEv stEv|
"/
"/    view := self viewForWPeer: nativeContext.
"/    view notNil ifTrue:[
"/        (view isKindOf:JavaView) ifFalse:[
"/            jEv := nativeContext argAt:1.
"/            stEv := jEv instVarNamed:'data'.
"/            (stEv notNil and:[stEv ~~ 0]) ifTrue:[
"/                EventTrace == true ifTrue:[
"/                    Logger 
"/                          log:('JAVA: WComponent - handleEvent: ' , stEv type , ' for ' 
"/                                  , view printString)
"/                          severity:Logger severityTRACE
"/                          facility:#JVM.
"/                ].
"/                stEv sendEventWithFocusOn:nil.
"/                ^ self.
"/            ]
"/        ]
"/    ].
"/    EventTrace == true ifTrue:[
"/        Logger 
"/              log:('JAVA: WComponent - handleEvent ignored')
"/              severity:Logger severityTRACE
"/              facility:#JVM.
"/    ]

    "Created: / 19.10.1998 / 21:26:16 / cg"
    "Modified: / 19.10.1998 / 23:26:37 / cg"
!

_WComponentPeer_requestFocus: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/ 'getFocus - ' print. view displayString printCR.

"/    view getKeyboardFocus

    "Created: / 7.1.1998 / 22:30:03 / cg"
    "Modified: / 4.12.1998 / 19:42:18 / cg"
!

_WComponentPeer_reshape: nativeContext
    self commonReshapeComponent: nativeContext

    "Modified: / 18.3.1997 / 19:30:21 / cg"
    "Created: / 4.1.1998 / 18:01:11 / cg"
!

_WComponentPeer_setBackground: nativeContext
    |jClr rgb clr view|

    view := self viewForWPeer: nativeContext.

    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.
"/ self halt.
    clr := Color rgbValue:rgb.


    clr := clr on:(view device).

"/    (view superView isMemberOf:JavaEmbeddedFrameView) ifTrue:[
"/        view viewBackground:(view superView viewBackground).
"/        view backgroundPaint:(view superView viewBackground).
"/    ] ifFalse:[
"/        (view isMemberOf:JavaView) ifTrue:[
"/            view viewBackground:clr.
"/            view backgroundPaint:clr.
"/        ]
"/    ].

    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view viewBackground:clr.
    view backgroundPaint:clr.

    "Created: / 16.10.1998 / 02:16:31 / cg"
    "Modified: / 16.10.1998 / 02:26:29 / cg"
!

_WComponentPeer_setCursor: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/ self halt.

    "Created: / 5.1.1998 / 01:52:30 / cg"
    "Modified: / 25.1.1998 / 01:21:52 / cg"
!

_WComponentPeer_setFont: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/ self halt.

    "Created: / 5.1.1998 / 00:55:17 / cg"
    "Modified: / 25.1.1998 / 01:22:19 / cg"
!

_WComponentPeer_setForeground: nativeContext
    |jClr rgb clr view|

    view := self viewForWPeer: nativeContext.

    jClr := nativeContext argAt:1.
    rgb := jClr instVarNamed:'value'.
"/ self halt.
    clr := Color rgbValue:rgb.


    clr := clr on:(view device).

    (view isKindOf:ScrollableView) ifTrue:[
        view := view scrolledView
    ].
    view paint:clr.

    "Created: / 16.10.1998 / 02:18:58 / cg"
    "Modified: / 16.10.1998 / 02:26:37 / cg"
!

_WComponentPeer_setZOrderPosition: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
"/    self unimplementedNativeMethod.
"/ self halt.
"/ self internalError:'breakPoint'

    "Created: / 4.1.1998 / 17:59:26 / cg"
    "Modified: / 25.1.1998 / 01:22:32 / cg"
!

_WComponentPeer_show: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.

    "/ frame views are under my browsers own control
    (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
        view beVisible.
        view realize.
    ].

"/    view windowGroup notNil ifTrue:[
"/        windowServer addGroup:(view windowGroup)
"/    ].

    ^ nil

"/ self halt.

    "Created: / 5.1.1998 / 01:26:22 / cg"
    "Modified: / 4.12.1998 / 17:43:53 / cg"
!

_WComponentPeer_start: nativeContext
"/ self halt.

    "Modified: / 18.3.1997 / 18:43:18 / cg"
    "Created: / 5.1.1998 / 00:58:40 / cg"
!

_WContainerPeer_calculateInsets: nativeContext
    "/ new with ns4.0 ...

    "Created: / 16.10.1998 / 02:12:59 / cg"
!

_WDefaultFontCharset_canConvert: nativeContext
    ^ 1

    "Modified: / 21.8.1997 / 15:56:57 / cg"
    "Created: / 5.1.1998 / 01:55:47 / cg"
!

_WDialogPeer__hide: nativeContext
    |dialog|

    dialog := self viewForWPeer: nativeContext.

    dialog hide.

    "Created: / 7.1.1998 / 22:34:10 / cg"
    "Modified: / 8.1.1998 / 17:34:10 / cg"
!

_WDialogPeer__show: nativeContext
    |dialog|

    dialog := self viewForWPeer: nativeContext.
"/
"/ show does not work (yet); must setup windowgroup
"/ for it to get events ...
"/    dialog realize.

dialog show.
"/dialog fixSize.
"/dialog makeFullyVisible.
"/dialog openModal:[true] inGroup:JavaWindowGroup

    "Created: / 7.1.1998 / 21:52:15 / cg"
    "Modified: / 11.12.1998 / 14:43:05 / cg"
!

_WDialogPeer_create: nativeContext
    |jDialogPeer dialog|

    jDialogPeer := nativeContext receiver.

    dialog := ModalBox new.
    jDialogPeer instVarNamed:'pData' put:dialog.

    self createdWindowsView:dialog for:jDialogPeer.
    dialog windowGroup:JavaWindowGroup.
    JavaWindowGroup addTopView:dialog.

    WindowCreationTrace == true ifTrue:[
        'WDialogPeer_create: ' print. dialog printNL.
    ].

    "Created: / 7.1.1998 / 21:51:00 / cg"
    "Modified: / 15.1.1998 / 16:12:44 / cg"
!

_WDrawingSurfaceInfo_getDepth: nativeContext
    "/ int getDepth ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:21:00 / cg"
!

_WDrawingSurfaceInfo_getHBitmap: nativeContext
    "/ int getHBitmap ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:32 / cg"
!

_WDrawingSurfaceInfo_getHDC: nativeContext
    "/ int getHDC ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:50 / cg"
!

_WDrawingSurfaceInfo_getHPalette: nativeContext
    "/ int getHPalette ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:21:07 / cg"
!

_WDrawingSurfaceInfo_getHWnd: nativeContext
    "/ int getHWnd ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:23 / cg"
!

_WDrawingSurfaceInfo_getPBits: nativeContext
    "/ int getPBits ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:41 / cg"
!

_WDrawingSurfaceInfo_lock: nativeContext
    "/ int lock ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:00 / cg"
!

_WDrawingSurfaceInfo_unlock: nativeContext
    "/ void unlock ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:20:13 / cg"
!

_WEmbeddedFramePeer_create: nativeContext
    "/ void create (sun.awt.windows.WComponentPeer)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:16:09 / cg"
!

_WFileDialogPeer_show: nativeContext
    |jDialogPeer jDialog dialogView stDialog
     title dir pattern f|

    jDialogPeer := nativeContext receiver.
    jDialog := jDialogPeer instVarNamed:'target'.
    dialogView := jDialogPeer instVarNamed:'pData'.

    stDialog := FileSelectionBox new.

    dir := jDialog instVarNamed:'dir'.
    dir notNil ifTrue:[
        stDialog directory:(Java as_ST_String:dir).
    ].
    pattern := jDialog instVarNamed:'file'.
    pattern notNil ifTrue:[
        stDialog pattern:(Java as_ST_String:pattern).
    ].
    title := jDialog instVarNamed:'title'.
    title notNil ifTrue:[
        stDialog title:(Java as_ST_String:title).
        stDialog label:(Java as_ST_String:title).
    ].

    stDialog show.

    stDialog accepted ifTrue:[
        f := stDialog pathName.

        "/ cannot use the one below - it has a builtIn fileSeparator if '\' (sigh)
        "/ jDialogPeer perform:#'handleSelected(Ljava/lang/String;)V' with:(Java as_String:f).

        jDialog
            perform:#'setFile(Ljava/lang/String;)V'
            with:(Java as_String:(f asFilename baseName)).
        jDialog
            perform:#'setDirectory(Ljava/lang/String;)V'
            with:(Java as_String:(f asFilename directoryName , Filename separator asString)).
        jDialog
            perform:#'setVisible(Z)V'
            with:0.
    ] ifFalse:[
        jDialogPeer
            perform:#'handleCancel()V'
    ].
"/ self halt.

    "Created: / 7.1.1998 / 22:38:45 / cg"
    "Modified: / 15.1.1998 / 13:04:05 / cg"
!

_WFontMetrics_bytesWidth: nativeContext
    "/ int bytesWidth (byte[] int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:11:46 / cg"
!

_WFontMetrics_getMFCharSegmentWidth: nativeContext
    "get multi-font string-segment width.
     Not yet supported - use standard strings width"

    |jMetrics jFont jFontDescr stFont w
     bool1 cp offs lenght bp int1|

    jMetrics := nativeContext receiver.
    jFont := nativeContext argAt:1.
    jFontDescr := nativeContext argAt:2.
    bool1 := nativeContext argAt:3.
    cp := nativeContext argAt:4.
    offs := nativeContext argAt:5.
    lenght := nativeContext argAt:6.
    bp := nativeContext argAt:7.
    int1 := nativeContext argAt:8.

    stFont := jFont instVarNamed:'pData'.
    (stFont isNil or:[stFont == 0]) ifTrue:[
        self halt
    ].

    stFont device isNil ifTrue:[
        stFont := stFont on:Display.
        jFont instVarNamed:'pData' put:stFont.
    ].
    w := stFont widthOf:cp from:offs+1 to:offs+lenght.
    ^ w.

    "Created: / 5.1.1998 / 01:57:45 / cg"
    "Modified: / 13.1.1998 / 23:44:03 / cg"
!

_WFontMetrics_init: nativeContext
    |jMetrics jFont stFont widths family name style size|

    jMetrics := nativeContext receiver.
    jFont := jMetrics instVarNamed:'font'.

    family := jFont instVarNamed:'family'.
    family := Java as_ST_String:family.

    name := jFont instVarNamed:'name'.
    name := Java as_ST_String:name.

    style := jFont instVarNamed:'style'.
    size := jFont instVarNamed:'size'.

    stFont := Font family:family size:size.
    stFont isNil ifTrue:[
        stFont := Font family:'helvetica' size:size.
    ].
    stFont := stFont on:Display.
self halt.
"/    stFont := jFont instVarNamed:'pData'.
"/    stFont isNil ifTrue:[
"/        self halt
"/    ].

    stFont := stFont on:Display.
    jFont instVarNamed:'pData' put:stFont.

    jMetrics instVarNamed:'ascent'     put:stFont ascent.
    jMetrics instVarNamed:'descent'    put:stFont descent.
    jMetrics instVarNamed:'leading'    put:0.
    jMetrics instVarNamed:'height'     put:stFont height.
    jMetrics instVarNamed:'maxAscent'  put:stFont maxAscent.
    jMetrics instVarNamed:'maxDescent' put:stFont maxDescent.
    jMetrics instVarNamed:'maxHeight'  put:stFont maxHeight.
    jMetrics instVarNamed:'maxAdvance' put:stFont maxWidth.

    widths := Array new:256.
    0 to:255 do:[:i |
        widths at:(i+1) put:(stFont widthOf:(Character value:i))
    ].
    jMetrics instVarNamed:'widths' put:widths.
"/ self halt.

    "Modified: / 8.8.1997 / 12:06:53 / cg"
    "Created: / 5.1.1998 / 01:54:29 / cg"
!

_WFontMetrics_needsConversion: nativeContext
    |jFont jFontDescr stFont|

    jFont := nativeContext argAt:1.
    jFontDescr := nativeContext argAt:2.

    stFont := jFont instVarNamed:'pData'.
"/    stFont isNil ifTrue:[
"/        self halt
"/    ].
"/    stFont device isNil ifTrue:[
"/        stFont := stFont on:Display.
"/        jFont instVarNamed:'pData' put:stFont.
"/    ].
"/

    ^ 0

    "Modified: / 17.8.1997 / 17:16:29 / cg"
    "Created: / 5.1.1998 / 01:56:42 / cg"
!

_WFramePeer__setIconImage: nativeContext
    |frame imgRep image|

    frame := self viewForWPeer: nativeContext.
    imgRep := nativeContext argAt:1.
    imgRep notNil ifTrue:[
        image := imgRep instVarNamed:'pData'.
        (image notNil and:[image ~~ 0]) ifTrue:[
            frame icon:image.
        ]
    ].

    "Created: / 27.4.1998 / 17:15:09 / cg"
    "Modified: / 27.4.1998 / 17:18:24 / cg"
!

_WFramePeer_create: nativeContext
    |jFramePeer jFrame frame pDataIdx|

    jFramePeer := nativeContext receiver.

    "/ for now: a kludge to create an embedded frame for
    "/ mozillaFrames

    jFrame := jFramePeer instVarNamed:'target'.
    (jFrame notNil
    and:[(pDataIdx := jFrame class instVarIndexFor:'pData') notNil])
    ifTrue:[
        ((frame := jFrame instVarAt:pDataIdx) notNil
        and:[frame ~~ 0]) ifTrue:[
            WindowCreationTrace == true ifTrue:[
                Logger 
                      log:'JAVA: targetFrame view already created: '
                      severity:Logger severityTRACE
                      facility:#JVM.
            ].
            "/ sigh; pData was renamed to pNativeWidget in jdk1.2 ...
            pDataIdx := jFramePeer class instVarIndexFor:'pNativeWidget'.
            pDataIdx isNil ifTrue:[
                "/ ok, we are < 1.2
                pDataIdx := jFramePeer class instVarIndexFor:'pData'.
            ].
            jFramePeer instVarAt:pDataIdx put:frame.
        ]
    ] ifFalse:[
        frame := jFramePeer instVarNamed:'pData'
    ].

    (frame notNil and:[frame ~~ 0]) ifTrue:[
        WindowCreationTrace == true ifTrue:[
            'JAVA: frame view already created: ' infoPrint.
            Logger 
                  log:jFramePeer class name
                  severity:Logger severityTRACE
                  facility:#JVM.
        ].
    ] ifFalse:[
"/ OLD
"/        frame := StandardSystemView new.
"/        self createdWindowsView:frame for:jFramePeer.
"/        JavaWindowGroup addTopView:frame.

        frame := JavaTopView new.
        frame delegate:self.
        frame javaPeer:jFramePeer.
        self createdWindowsView:frame for:jFramePeer.
        JavaWindowGroup addTopView:frame.

"/        top := StandardSystemView new.
"/        frame := JavaView origin:0.0@0.0 corner:1.0@1.0 in:top.
"/        frame delegate:self.
"/        frame javaPeer:jFramePeer.
"/        self createdWindowsView:frame for:jFramePeer.
"/        JavaWindowGroup addTopView:top.

    ].

    WindowCreationTrace == true ifTrue:[
        'JAVA: WFramePeer_create: ' print. jFramePeer displayString print.
        ' frame: ' print. frame printNL.
    ].

    "Created: / 4.1.1998 / 17:56:39 / cg"
    "Modified: / 3.12.1998 / 00:10:21 / cg"
!

_WFramePeer_setMenuBar0: nativeContext
    |frame jMenuBarPeer menuPanel|

    frame := self viewForWPeer: nativeContext.

    jMenuBarPeer := nativeContext argAt:1.
    jMenuBarPeer isNil ifTrue:[
        "/ mhmh - JAVA wants to remove the frames menuPanel.
        "/ but I have no handle on it (for destroy).
        "/ search it in subViews of the frame.
        frame subViews copy do:[:v |
            (v isKindOf:MenuPanel) ifTrue:[
                v destroy
            ]
        ]
    ] ifFalse:[
        menuPanel := jMenuBarPeer instVarNamed:'pData'.

        menuPanel origin:0.0@0.0 corner:1.0@(menuPanel preferredExtent y).
        frame addSubView:menuPanel.
    ].
    ^ nil

    "Created: / 7.1.1998 / 21:41:35 / cg"
    "Modified: / 8.1.1998 / 17:35:04 / cg"
!

_WFramePeer_setResizable: nativeContext
    |view onOff|

    view := self viewForWPeer: nativeContext.

    onOff := (nativeContext argAt:1) == 1.
    view isTopView ifTrue:[
        onOff ifTrue:[
            view minExtent:10@10.
            view maxExtent:(Screen current extent).
        ] ifFalse:[
            view minExtent:view extent.
            view maxExtent:view extent.
        ]
    ] ifFalse:[
        (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
            self halt.
        ]
    ].

"/ 'JAVA: WWindowPeer_setResizable: ' print. view print. ' yes/no: ' print. onOff printNL.

    ^ nil

    "Modified: / 16.1.1998 / 18:08:00 / cg"
    "Created: / 16.10.1998 / 02:21:34 / cg"
!

_WFramePeer_setTitle: nativeContext
    |view jString string|

    view := self viewForWPeer: nativeContext.

    jString := nativeContext argAt:1.
    string := Java as_ST_String:jString.

"/ 'JAVA: WFramePeer_pSetTitle: ' print. string print. ' ' print. view printNL.

    view label:string.
    ^ nil

    "Modified: / 8.1.1998 / 17:37:41 / cg"
    "Created: / 27.1.1998 / 21:42:57 / cg"
!

_WGraphics__dispose: nativeContext
    "/ void _dispose()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:17:51 / cg"
!

_WGraphics_changeClip: nativeContext
    |gc x y w h r bool|

    gc := self gcForWGraphics: nativeContext.

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    bool := (nativeContext argAt:5) ~~ 0.

    r := Rectangle left:x top:y width:w height:h.
"/ 'WGraphics_changeClip: ' infoPrint. r infoPrintCR.
    gc clippingRectangle:r.

    "Created: / 6.1.1998 / 20:57:21 / cg"
    "Modified: / 20.10.1998 / 19:40:10 / cg"
!

_WGraphics_clearRect: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].

    gc realized ifFalse:[
        Logger log: 'JAVA: drawing on unrealized gc - ignored' severity: Logger severityERROR facility: #JVM.
        ^ self
    ].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

"/ self halt.
"/ self internalError:'breakPoint'.

    gc clearRectangleX:x y:y width:w height:h.

    "Created: / 08-01-1998 / 00:16:00 / cg"
    "Modified: / 02-03-2015 / 15:51:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WGraphics_close: nativeContext
    "/ void close (sun.awt.windows.WPrintJob)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:19:40 / cg"
!

_WGraphics_copyArea: nativeContext
    |gc srcX srcY w h deltaX deltaY|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].

    gc realized ifFalse:[
        Logger log: 'JAVA: copyArea on unrealized gc - ignored' severity: Logger severityERROR facility: #JVM.
        ^ self
    ].

    srcX := nativeContext argAt:1.
    srcY := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    deltaX := nativeContext argAt:5.
    deltaY := nativeContext argAt:6.

    gc
        copyFrom:gc
        x:srcX y:srcY
        toX:srcX+deltaX y:srcY+deltaY
        width:w height:h

    "Created: / 08-01-1998 / 00:16:00 / cg"
    "Modified: / 09-04-1998 / 22:01:32 / cg"
    "Modified: / 02-03-2015 / 15:51:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WGraphics_createFromComponent: nativeContext
    |jGraphics jWin view|

    jGraphics := nativeContext receiver.
    jWin := nativeContext argAt:1.

    view := KnownWindows at:jWin ifAbsent:nil.
    view isNil ifTrue:[
        self halt.
        ^ self
    ].
    view clippingRectangle:nil.

"/    "/ just a consistency check ...
"/    (jWin instVarNamed:'xid') ~~ view ifTrue:[
"/        self halt:'consistency check'
"/    ].

    jGraphics instVarNamed:'pData' put:view.

    "Created: / 6.1.1998 / 20:55:18 / cg"
    "Modified: / 20.10.1998 / 19:38:18 / cg"
!

_WGraphics_createFromGraphics: nativeContext
    |jGraphics graphics gc|

    jGraphics := nativeContext receiver.
    graphics := nativeContext argAt:1.
    gc := graphics instVarNamed:'pData'.

    jGraphics instVarNamed:'pData' put:gc.
    gc clippingRectangle:nil.

    "Created: / 8.1.1998 / 00:47:39 / cg"
    "Modified: / 20.10.1998 / 19:37:58 / cg"
!

_WGraphics_createFromHDC: nativeContext
    "/ void createFromHDC (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:17:32 / cg"
!

_WGraphics_createFromPrintJob: nativeContext
    "/ void createFromPrintJob (sun.awt.windows.WPrintJob)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:17:20 / cg"
!

_WGraphics_dispose: nativeContext
    |gc|

    gc := self gcForWGraphics: nativeContext.
    gc isNil ifTrue:[^ self].
    gc clippingRectangle:nil.

    "Created: / 6.1.1998 / 20:58:38 / cg"
    "Modified: / 20.10.1998 / 19:35:05 / cg"
!

_WGraphics_drawArc: nativeContext
    |gc x y w h startAngle endAngle|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    startAngle := nativeContext argAt:5.
    endAngle := nativeContext argAt:6.

    DrawOPTrace ifTrue:[
        'drawArc x/y= ' print. x print. '@' print. y print.
               ' w/h= ' print. w print. '@' print. h print.
               ' startAngle= ' print. startAngle print. ' endAngle= ' print. endAngle printCR.
    ].
    gc
        displayArcX:x y:y
        width:w height:h
        from:startAngle angle:(endAngle - startAngle).

    "Created: / 6.1.1998 / 21:00:15 / cg"
    "Modified: / 28.1.1999 / 17:38:45 / cg"
!

_WGraphics_drawBytes: nativeContext
    "/ void drawBytes (byte[] int int int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:18:56 / cg"
!

_WGraphics_drawLine: nativeContext
    |gc x y x2 y2|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    x2 := nativeContext argAt:3.
    y2 := nativeContext argAt:4.

    DrawOPTrace ifTrue:[
        'drawLine x/y= ' print. x print. '@' print. y print. ' x2/y2= ' print. x2 print. '@' print. y2 printCR.
    ].
    gc displayLineFromX:x y:y toX:x2 y:y2

    "Created: / 6.1.1998 / 20:59:27 / cg"
    "Modified: / 8.1.1998 / 00:34:23 / cg"
!

_WGraphics_drawMFCharsConvertedSegment: nativeContext
    "/ int drawMFCharsConvertedSegment (java.awt.Font sun.awt.FontDescriptor byte[] int int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:18:44 / cg"
!

_WGraphics_drawMFCharsSegment: nativeContext
    |jFont jFontDescr s gc x y offs len|

    gc := self gcForWGraphics: nativeContext.
    gc realized ifFalse:[^ self].

    jFont := nativeContext argAt:1.
    jFontDescr := nativeContext argAt:2.
    s := nativeContext argAt:3.
    offs := nativeContext argAt:4.
    len := nativeContext argAt:5.
    x := nativeContext argAt:6.
    y := nativeContext argAt:7.

    DrawOPTrace ifTrue:[
        'drawMFCharsSegment x/y= ' print. x print. '@' print. y print. ' s= ' print. s printCR.
    ].
    gc displayString:s from:offs+1 to:offs+len x:x y:y.
    ^ (gc font onDevice:(gc graphicsDevice)) widthOf:s.

    "Created: / 6.1.1998 / 21:01:07 / cg"
    "Modified: / 25.1.1998 / 20:45:55 / cg"
!

_WGraphics_drawOval: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

    DrawOPTrace ifTrue:[
        'drawOval x/y= ' print. x print. '@' print. y print.
                ' w/h= ' print. w print. '@' print. h printCR.
    ].
    gc displayArcX:x y:y width:w height:h from:0 angle:360.

    "Created: / 8.1.1998 / 00:44:31 / cg"
    "Modified: / 9.4.1998 / 22:10:23 / cg"
!

_WGraphics_drawPolygon: nativeContext
    |gc xVector yVector count points|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    xVector := nativeContext argAt:1.
    yVector := nativeContext argAt:2.
    count := nativeContext argAt:3.

    DrawOPTrace ifTrue:[
        'drawPolgon' printCR.
    ].

    points := (1 to:count) collect:[:i | (xVector at:i) @ (yVector at:i)].
    gc displayPolygon:points

    "Created: / 8.1.1998 / 00:57:28 / cg"
    "Modified: / 8.1.1998 / 00:57:49 / cg"
!

_WGraphics_drawPolyline: nativeContext
    "/ void drawPolyline (int[] int[] int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:19:07 / cg"
!

_WGraphics_drawRect: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

"/ self halt.
"/ self internalError:'breakPoint'.

    gc displayRectangleX:x y:y width:w height:h.

    "Modified: / 8.1.1998 / 00:34:33 / cg"
    "Created: / 8.1.1998 / 00:59:05 / cg"
!

_WGraphics_drawRoundRect: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

"/ self halt.
"/ self internalError:'breakPoint'.

    gc displayRectangleX:x y:y width:w height:h.

    "Modified: / 8.1.1998 / 00:34:33 / cg"
    "Created: / 8.1.1998 / 00:59:26 / cg"
!

_WGraphics_drawSFChars: nativeContext
    "/ void drawSFChars (char[]s, int pos1, int len, int x, int y)

    |gc str x y idx1 nChars|

    gc := self gcForWGraphics: nativeContext.
    gc realized ifFalse:[^ self].

    str := nativeContext argAt:1.
    idx1 := nativeContext argAt:2.
    nChars := nativeContext argAt:3.
    x := nativeContext argAt:4.
    y := nativeContext argAt:5.

    DrawOPTrace ifTrue:[
        'drawSFChars x/y= ' print. x print. '@' print. y print.
               ' s= ' print. str printCR.
    ].
    gc displayString:str from:idx1+1 to:idx1+nChars x:x y:y

    "Created: / 6.1.1998 / 21:11:31 / cg"
    "Modified: / 8.1.1998 / 00:33:59 / cg"

!

_WGraphics_fillArc: nativeContext
    |gc x y w h startAngle endAngle|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.
    startAngle := nativeContext argAt:5.
    endAngle := nativeContext argAt:6.

    DrawOPTrace ifTrue:[
        'fillArc x/y= ' print. x print. '@' print. y print.
               ' w/h= ' print. w print. '@' print. h print.
               ' startAngle= ' print. startAngle print. ' endAngle= ' print. endAngle printCR.
    ].
    gc fillArcX:x y:y width:w height:h from:startAngle angle:(endAngle - startAngle)

    "Created: / 6.1.1998 / 21:11:31 / cg"
    "Modified: / 8.1.1998 / 00:33:59 / cg"
!

_WGraphics_fillOval: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

    DrawOPTrace ifTrue:[
        'drawOval x/y= ' print. x print. '@' print. y print.
                ' w/h= ' print. w print. '@' print. h printCR.
    ].
    gc fillArcX:x y:y width:w height:h from:0 angle:360

    "Created: / 8.1.1998 / 00:46:00 / cg"
    "Modified: / 8.1.1998 / 00:46:20 / cg"
!

_WGraphics_fillPolygon: nativeContext
    |gc xVector yVector count points|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    xVector := nativeContext argAt:1.
    yVector := nativeContext argAt:2.
    count := nativeContext argAt:3.

    DrawOPTrace ifTrue:[
        'fillPolgon' printCR.
    ].

    points := (1 to:count) collect:[:i | (xVector at:i) @ (yVector at:i)].
    gc fillPolygon:points

    "Created: / 8.1.1998 / 00:58:09 / cg"
    "Modified: / 25.1.1998 / 11:03:19 / cg"
!

_WGraphics_fillRect: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

"/ self halt.
"/ self internalError:'breakPoint'.

    gc fillRectangleX:x y:y width:w height:h.

    "Created: / 15.8.1997 / 15:43:10 / cg"
    "Modified: / 8.1.1998 / 00:34:33 / cg"
!

_WGraphics_fillRoundRect: nativeContext
    |gc x y w h|

    gc := self gcForWGraphics: nativeContext.
"/    gc isNil ifTrue:[^ self].
    gc realized ifFalse:[^ self].

    x := nativeContext argAt:1.
    y := nativeContext argAt:2.
    w := nativeContext argAt:3.
    h := nativeContext argAt:4.

"/ self halt.
"/ self internalError:'breakPoint'.

    gc displayRectangleX:x y:y width:w height:h.

    "Modified: / 8.1.1998 / 00:34:33 / cg"
    "Created: / 8.1.1998 / 00:59:36 / cg"
!

_WGraphics_getClipBounds: nativeContext
    | gc  rect  r  x  y  w  h |

    gc := self gcForWGraphics: nativeContext.

"/    gc isNil ifTrue:[^ nil].

    rect := (JavaVM classForName:'java.awt.Rectangle' definedBy:nil) basicNew.
    (gc isMemberOf: JavaView) ifTrue: [
        "/ r := gc clippingRectangleOrNil.
        r := gc getNextUpdateRectangle.
    ].
    r isNil ifTrue: [ r := gc clippingRectangleOrNil. ].
    r isNil ifTrue: [
        x := y := 0.
        w := (gc width).
        h := (gc height).
    ] ifFalse: [
        x := (r left).
        y := (r top).
        w := (r width).
        h := (r height).
    ].
    rect instVarNamed: 'x' put: x.
    rect instVarNamed: 'y' put: y.
    rect instVarNamed: 'width' put: w.
    rect instVarNamed: 'height' put: h.

"/ 'WGraphics__getClipBounds ' infoPrint. (x@y extent:w@h) infoPrintCR.

    ^ rect

    "Created: / 6.1.1998 / 20:58:07 / cg"
    "Modified: / 23.12.1998 / 20:14:09 / cg"
!

_WGraphics_imageCreate: nativeContext
    |jGraphics imgRep|

    jGraphics := nativeContext receiver.
    imgRep := nativeContext argAt:1.

    jGraphics instVarNamed:'pData' put:(imgRep instVarNamed:'pData').
"/ self halt.

    "Created: / 11.1.1998 / 16:34:30 / cg"
    "Modified: / 17.1.1998 / 12:37:18 / cg"
!

_WGraphics_pSetFont: nativeContext
    |gc jFont stFont|

    gc := self gcForWGraphics: nativeContext.
    jFont := nativeContext argAt:1.

    stFont := jFont instVarNamed:'pData'.
    (stFont isNil or:[stFont == 0]) ifTrue:[
"/ self halt.
    ] ifFalse:[
        gc font:stFont
    ].

    "Created: / 6.1.1998 / 20:56:47 / cg"
    "Modified: / 15.1.1998 / 12:31:20 / cg"
!

_WGraphics_pSetForeground: nativeContext
    |gc rgb clr|

    gc := self gcForWGraphics: nativeContext.

    rgb := nativeContext argAt:1.
    rgb isInteger ifFalse:[
        "/ its a java.awt.Color
        rgb := rgb instVarNamed:'value'.
    ].
    clr := Color rgbValue:rgb.
    gc paint:(clr nearestOn:gc device).

"/ self halt.
"/ self internalError:'breakPoint'.

    "Created: / 6.1.1998 / 20:56:14 / cg"
    "Modified: / 23.12.1998 / 20:10:49 / cg"
!

_WGraphics_print: nativeContext
    "/ void print (sun.awt.windows.WComponentPeer)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:19:25 / cg"
!

_WGraphics_removeClip: nativeContext
    "/ void removeClip ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:18:05 / cg"
!

_WGraphics_setPaintMode: nativeContext
    |gc|

    gc := self gcForWGraphics: nativeContext.
    gc function:#copy.

    true "DrawOPTrace" ifTrue:[
        Logger log: 'copyMode' severity: Logger severityTRACE facility: #JVM
    ].

    "Created: / 08-01-1998 / 00:33:44 / cg"
    "Modified: / 28-01-1998 / 23:25:56 / cg"
    "Modified (format): / 02-03-2015 / 15:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WGraphics_setXORMode: nativeContext
    |gc jColor invColor device|

    gc := self gcForWGraphics: nativeContext.
    jColor := nativeContext argAt:1.
    device := gc graphicsDevice.

"/    "/ on trueColor systems, use the provided
"/    "/ rgb value for inverting.
"/    "/ on palette systems, use white ^ black
"/
"/    device visualType == #TrueColor ifTrue:[
"/        rgb := jColor instVarNamed:'value'.
"/        rgb := rgb bitAnd:16rFFFFFF.
"/        rgb == 0 ifTrue:[
"/            rgb := 16rFFFFFF.
"/        ].
"/        invColor := rgb
"/    ] ifFalse:[
"/        invColor := device blackpixel bitXor:device whitepixel.
"/    ].

    invColor := device blackpixel bitXor:device whitepixel.

"/    gc foreground:(Color colorId:invColor)
"/       background:device blackColor.
    device
        setForeground:invColor background:0
        in:gc gcId.
    gc function:#xor.

    true "DrawOPTrace" ifTrue:[
        Logger 
              log:'xorMode'
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    "Created: / 8.1.1998 / 00:36:17 / cg"
    "Modified: / 28.1.1998 / 23:45:03 / cg"
!

_WLabelPeer_create: nativeContext
    |jLabelPeer jLabel jFrame frame label
     lbl|

    jLabelPeer := nativeContext receiver.
    jLabel := jLabelPeer instVarNamed:'target'.

    lbl := jLabel instVarNamed:'text'.
    lbl notNil ifTrue:[
        lbl := Java as_ST_String:lbl
    ].

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    label := Label in:frame.
    label sizeFixed:true.
    lbl notNil ifTrue:[
        label label:lbl
    ].
    self createdWindowsView:label for:jLabelPeer.

    WindowCreationTrace == true ifTrue:[
        'WLabelPeer_create: ' print. frame print. ' -> ' print. label printNL.
    ].

    "Created: / 7.1.1998 / 21:42:31 / cg"
    "Modified: / 13.1.1998 / 22:10:47 / cg"
!

_WLabelPeer_setAlignment: nativeContext
    |label alignNr|

    alignNr := nativeContext argAt:1.
    label := self viewForWPeer: nativeContext.
    label notNil ifTrue:[
    ].

    "Created: / 7.1.1998 / 21:43:12 / cg"
    "Modified: / 8.1.1998 / 17:35:29 / cg"
!

_WLabelPeer_setText: nativeContext
    |label jString str|

    jString := nativeContext argAt:1.

    label := self viewForWPeer: nativeContext.
    jString notNil ifTrue:[
        str := Java as_ST_String:jString
    ].
    label label:str

    "Created: / 7.1.1998 / 21:43:51 / cg"
    "Modified: / 3.12.1998 / 14:59:18 / cg"
!

_WListPeer__addItem: nativeContext
    |jString index1 length selListView m|

    selListView := self viewForWPeer: nativeContext.

    jString := nativeContext argAt:1.
    index1 := nativeContext argAt:2.
    length := nativeContext argAt:3.

    (m := selListView model) notNil ifTrue:[
        m list addLast:(Java as_ST_String:jString).
        m changed:#list.
    ].

    "Created: / 26.10.1998 / 20:11:30 / cg"
    "Modified: / 14.11.1998 / 01:21:03 / cg"
!

_WListPeer_addItem: nativeContext
    |jString index selListView m|

    selListView := self viewForWPeer: nativeContext.

    jString := nativeContext argAt:1.
    index := nativeContext argAt:2.

    m := selListView model.
    m isNil ifTrue:[
        Transcript showCR:'JAVA: access to listModel of closed view'.
    ] ifFalse:[
        m list addLast:(Java as_ST_String:jString).
        m changed:#list.
    ]

    "Created: / 24.1.1998 / 21:10:05 / cg"
    "Modified: / 2.11.1998 / 17:12:52 / cg"
!

_WListPeer_create: nativeContext
    |jListPeer jFrame frame selectionInListView|

    jListPeer := nativeContext receiver.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    selectionInListView := ScrollableView for:SelectionInListView in:frame.
    selectionInListView action:[:index | jListPeer perform:#'handleListChanged(I)V' with:(index - 1)].
    selectionInListView doubleClickAction:[:index | jListPeer perform:#'handleAction(I)V' with:(index - 1)].
    selectionInListView model:(SelectionInList new list:(List new)).
    selectionInListView useIndex:true.

    self createdWindowsView:selectionInListView for:jListPeer.

    WindowCreationTrace == true ifTrue:[
        'WTextAreaPeer_create: ' print. frame print. ' -> ' print. selectionInListView printNL.
    ].

    "Created: / 24.1.1998 / 19:58:54 / cg"
    "Modified: / 9.4.1998 / 22:19:07 / cg"
!

_WListPeer_delItems: nativeContext
    |index1 index2 selListView model list|

    selListView := self viewForWPeer: nativeContext.

    index1 := (nativeContext argAt:1) + 1. "/ java indices are 0-based.
    index2 := (nativeContext argAt:2) + 1. "/ st indices are 1-based.

    model := selListView model.
    model isNil ifTrue:[^ self].
    list := model list.
    list size >= index1 ifTrue:[
        list removeFromIndex:index1 toIndex:(index2 min:list size).
        model changed:#list.
    ].

    "Created: / 9.4.1998 / 22:19:25 / cg"
    "Modified: / 30.12.1998 / 20:00:50 / cg"
!

_WListPeer_deselect: nativeContext
    "/ void deselect (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:15:10 / cg"
!

_WListPeer_getMaxWidth: nativeContext
    "/ int getMaxWidth ()

    ^ 1000 "/ a dummy value

"/    UnimplementedNativeMethodSignal raise

    "Created: / 14.11.1998 / 10:44:29 / cg"
!

_WListPeer_isSelected: nativeContext
    |selectionInListView index model|

    selectionInListView := self viewForWPeer: nativeContext.

    index := nativeContext argAt:1.
    (model := selectionInListView model) notNil ifTrue:[
        (model selectionIndex == (index + 1))  "/ JAVA indexing starts at 0
        ifTrue:[
            ^ 1
        ]
    ].
    ^ 0.

    "Created: / 24.1.1998 / 22:42:31 / cg"
    "Modified: / 25.1.1998 / 01:35:32 / cg"
!

_WListPeer_makeVisible: nativeContext
    |selectionInListView lineNr|

    selectionInListView := self viewForWPeer: nativeContext.

    lineNr := nativeContext argAt:1.

    selectionInListView makeLineVisible:(lineNr + 1)

    "Modified: / 24.1.1998 / 20:01:06 / cg"
    "Created: / 20.10.1998 / 14:14:50 / cg"
!

_WListPeer_select: nativeContext
    |selectionInListView index model|

    selectionInListView := self viewForWPeer: nativeContext.

    index := nativeContext argAt:1.
    (model := selectionInListView model) notNil ifTrue:[
        model selectionIndex:(index + 1).  "/ JAVA indexing starts at 0
    ]

    "Created: / 24.1.1998 / 22:32:35 / cg"
    "Modified: / 25.1.1998 / 01:28:46 / cg"
!

_WListPeer_setMultipleSelections: nativeContext
    |selectionInListView onOff|

    selectionInListView := self viewForWPeer: nativeContext.

    onOff := (nativeContext argAt:1) ~~ 0.

    selectionInListView multipleSelectOk:onOff.

    "Modified: / 24.1.1998 / 20:01:06 / cg"
!

_WListPeer_updateMaxItemWidth: nativeContext
    |selectionInListView|

    selectionInListView := self viewForWPeer: nativeContext.

    "Created: / 26.10.1998 / 20:09:46 / cg"
!

_WMenuBarPeer_addMenu: nativeContext
    "/ void addMenu (java.awt.Menu)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:14:00 / cg"
!

_WMenuBarPeer_create: nativeContext
    |jMenuBarPeer jMenuBar jFrame frame menuBar|

    jMenuBarPeer := nativeContext receiver.
    jMenuBar := jMenuBarPeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    menuBar := MenuPanel in:frame.
    menuBar verticalLayout:false.
    menuBar realize.

    self createdWindowsView:menuBar for:jMenuBarPeer.

    WindowCreationTrace == true ifTrue:[
        'WMenuBarPeer_create: ' print. frame print. ' -> ' print. menuBar printNL.
    ].

    "Created: / 7.1.1998 / 21:38:31 / cg"
    "Modified: / 25.1.1998 / 13:19:03 / cg"
!

_WMenuBarPeer_delMenu: nativeContext
    "/ void delMenu (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:14:11 / cg"
!

_WMenuItemPeer__dispose: nativeContext
    |jMenuItemPeer item|

    jMenuItemPeer := nativeContext receiver.
    item := jMenuItemPeer instVarNamed:'pData'.

"/ what should be done here ?

    "Created: / 29.3.1998 / 17:16:05 / cg"
    "Modified: / 29.3.1998 / 17:16:35 / cg"
!

_WMenuItemPeer__setLabel: nativeContext
    "/ void _setLabel (java.lang.String)

    |jMenuItemPeer item label|

    jMenuItemPeer := nativeContext receiver.
    item := jMenuItemPeer instVarNamed:'pData'.
    (item isNil or:[item == 0]) ifTrue:[
        Logger log: 'JAVA [warning]: NULL menu item in setLabel' severity: Logger severityERROR facility: #JVM.
        ^ self
    ].

    label := nativeContext argAt:1.
    label isNil ifTrue:[
        label := ''
    ] ifFalse:[
        label := Java as_ST_String:label
    ].
    item label:label.

    "Modified: / 11-12-1998 / 16:40:18 / cg"
    "Modified: / 02-03-2015 / 15:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WMenuItemPeer_create: nativeContext
    |jMenuItemPeer jMenuItem jMenuPeer menu item lbl|

    jMenuItemPeer := nativeContext receiver.
    jMenuItem := jMenuItemPeer instVarNamed:'target'.

    jMenuPeer := nativeContext argAt:1.
    menu := jMenuPeer instVarNamed:'pData'.
    (menu isNil or:[menu == 0]) ifTrue:[
        Logger log: 'JAVA: no menu to create item in' severity: Logger severityERROR facility: #JVM.
        ^ self
    ].
    item := menu createAtIndex:nil.
    item value:[
                jMenuItemPeer perform:#'handleAction(I)V' with:0
               ].

    lbl := jMenuItem instVarNamed:'label'.
    lbl notNil ifTrue:[
        lbl := Java as_ST_String:lbl.
        item label:lbl
    ].

    jMenuItemPeer instVarNamed:'pData' put:item.

    WindowOPTrace == true ifTrue:[
        'WMenuItem_create: ' print. menu print. ' -> ' print. item printNL.
    ].

    "Created: / 07-01-1998 / 21:40:44 / cg"
    "Modified: / 03-12-1998 / 20:43:20 / cg"
    "Modified: / 02-03-2015 / 15:52:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WMenuItemPeer_enable: nativeContext
    |jMenuItemPeer item state|

    jMenuItemPeer := nativeContext receiver.
    item := jMenuItemPeer instVarNamed:'pData'.
    (item isNil or:[item == 0]) ifTrue:[
        Logger log: 'JAVA [warning]: NULL menu item in enable' severity: Logger severityERROR facility: #JVM.
        ^ self
    ].

    state := nativeContext argAt:1.
    item enabled:(state ~~ 0)

    "Created: / 07-01-1998 / 22:41:38 / cg"
    "Modified: / 11-12-1998 / 16:40:26 / cg"
    "Modified: / 02-03-2015 / 15:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_WMenuPeer_addSeparator: nativeContext
    "/ void addSeparator ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:13:14 / cg"
!

_WMenuPeer_createMenu: nativeContext
    |jMenuPeer jMenu jMenuBarPeer menuPanel menu
     lbl item|

    jMenuPeer := nativeContext receiver.
    jMenu := jMenuPeer instVarNamed:'target'.

    jMenuBarPeer := nativeContext argAt:1.
    menuPanel := jMenuBarPeer instVarNamed:'pData'.

    item := menuPanel createAtIndex:nil.
    lbl := jMenu instVarNamed:'label'.
    lbl notNil ifTrue:[
        lbl := Java as_ST_String:lbl.
        item label:lbl
    ].

    menu := MenuPanel new.
    item submenu:menu.

    jMenuPeer instVarNamed:'pData' put:menu.

'createMenuPeer: ' print. menuPanel print. ' -> ' print. menu printNL.

    "Created: / 7.1.1998 / 21:39:50 / cg"
    "Modified: / 13.1.1998 / 22:11:09 / cg"
!

_WMenuPeer_createSubMenu: nativeContext
    "/ void createSubMenu (sun.awt.windows.WMenuPeer)
"/    UnimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:13:43 / cg"
    "Modified: / 3.12.1998 / 21:41:07 / cg"
!

_WMenuPeer_delItem: nativeContext
    "/ void delItem (int)
    |jMenuPeer menuPanel itemIndex|

    jMenuPeer := nativeContext receiver.
    menuPanel := jMenuPeer instVarNamed:'pData'.

    itemIndex := nativeContext argAt:1.
    menuPanel remove:itemIndex.

"/    UnimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:13:30 / cg"
    "Modified: / 10.12.1998 / 21:12:29 / cg"
!

_WPanelPeer_calculateInsets: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 27.1.1998 / 21:40:00 / cg"
!

_WPopupMenuPeer__show: nativeContext
    "/ void _show (java.awt.Event)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:12:53 / cg"
!

_WPopupMenuPeer_createMenu: nativeContext
    "/ void createMenu (sun.awt.windows.WComponentPeer)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:12:43 / cg"
!

_WPrintJob_end: nativeContext
    "/ void end ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:11:28 / cg"
!

_WScrollPanePeer__getHScrollbarHeight: nativeContext
    |scrollPane|

    scrollPane := self viewForWPeer: nativeContext.
    ^ HorizontalScrollBar new preferredExtent y.

    "Created: / 9.4.1998 / 17:30:56 / cg"
    "Modified: / 10.4.1998 / 14:59:28 / cg"
!

_WScrollPanePeer__getVScrollbarWidth: nativeContext
    |scrollPane|

    scrollPane := self viewForWPeer: nativeContext.
    ^ ScrollBar new preferredExtent x.

    "Created: / 9.4.1998 / 17:29:48 / cg"
    "Modified: / 10.4.1998 / 15:00:33 / cg"
!

_WScrollPanePeer_create: nativeContext
    |jScrollPanePeer jScrollPane jFrame frame scrollPane|

    jScrollPanePeer := nativeContext receiver.
    jScrollPane := jScrollPanePeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    "/ create with a simple view ...
    scrollPane := ScrollableView for:JavaView in:frame.

    self createdWindowsView:scrollPane for:jScrollPanePeer.

    WindowCreationTrace == true ifTrue:[
        'WScrollPanePeer_create: ' print. frame print. ' -> ' print. scrollPane printNL.
    ].

    "Created: / 9.4.1998 / 17:25:08 / cg"
    "Modified: / 9.4.1998 / 22:06:09 / cg"
!

_WScrollPanePeer_getOffset: nativeContext
    "/ int getOffset (int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:16:29 / cg"
!

_WScrollPanePeer_getScrollChild: nativeContext
    "/ java.awt.Component getScrollChild ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:17:00 / cg"
!

_WScrollPanePeer_setInsets: nativeContext

    "Modified: / 9.4.1998 / 17:26:11 / cg"
    "Created: / 9.4.1998 / 17:29:10 / cg"
!

_WScrollPanePeer_setScrollPosition: nativeContext
    "/ void setScrollPosition (int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:16:44 / cg"
!

_WScrollPanePeer_setSpans: nativeContext

    "Created: / 9.4.1998 / 17:31:44 / cg"
!

_WScrollbarPeer__setValues: nativeContext
    |scrollBar value visibleAmount min max|

    scrollBar := self viewForWPeer: nativeContext.

    value := nativeContext argAt:1.
    visibleAmount := nativeContext argAt:2.
    min := nativeContext argAt:3.
    max := nativeContext argAt:4.

    (min ~~ 0 or:[max ~~ 100]) ifTrue:[
        scrollBar thumb start:min stop:max.
    ].

    scrollBar thumbOrigin:value thumbHeight:visibleAmount.

    "Created: / 13.1.1998 / 22:13:57 / cg"
    "Modified: / 14.10.1998 / 14:53:00 / cg"
!

_WScrollbarPeer_create: nativeContext
    |jScrollbarPeer jScrollbar jFrame frame scrollBar
     min max|

    jScrollbarPeer := nativeContext receiver.
    jScrollbar := jScrollbarPeer instVarNamed:'target'.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    (jScrollbar instVarNamed:'orientation') == 0 "HORIZONTAL" ifTrue:[
        scrollBar := HorizontalScrollBar in:frame.
    ] ifFalse:[
        scrollBar := ScrollBar in:frame.
    ].
    min := jScrollbar instVarNamed:'minimum'.
    max := jScrollbar instVarNamed:'maximum'.

    scrollBar scrollDownAction:[
                        scrollBar thumbOrigin:(scrollBar thumbOrigin + ((max-min)/10) min:max).
                        jScrollbarPeer perform:#'dragAbsolute(I)V' with:scrollBar thumbOrigin rounded.
                     ].
    scrollBar scrollUpAction:[
                        scrollBar thumbOrigin:(scrollBar thumbOrigin - ((max-min)/10) max:min).
                        jScrollbarPeer perform:#'dragAbsolute(I)V' with:scrollBar thumbOrigin rounded.
                     ].
    scrollBar scrollAction:[:org |
                        jScrollbarPeer perform:#'dragAbsolute(I)V' with:org rounded.
                     ].
    self createdWindowsView:scrollBar for:jScrollbarPeer.

    WindowCreationTrace == true ifTrue:[
        'WScrollbarPeer_create: ' print. frame print. ' -> ' print. scrollBar printNL.
    ].

    "Created: / 5.1.1998 / 01:53:30 / cg"
    "Modified: / 14.10.1998 / 15:36:19 / cg"
!

_WScrollbarPeer_setLineIncrement: nativeContext
    |scrollBar inc|

Transcript showCR:'JavaVM: WScrollbarPeer_setLineIncrement unimplemented'.

    scrollBar := self viewForWPeer: nativeContext.

    inc := nativeContext argAt:1.
"/    scrollBar thumb lineIncrement:inc.

    "Created: / 25.1.1998 / 11:52:19 / cg"
    "Modified: / 14.10.1998 / 14:53:56 / cg"
!

_WScrollbarPeer_setPageIncrement: nativeContext
    |scrollBar inc|

Transcript showCR:'JavaVM: WScrollbarPeer_setPageIncrement unimplemented'.

    scrollBar := self viewForWPeer: nativeContext.

    inc := nativeContext argAt:1.
"/    scrollBar thumb pageIncrement:inc.

    "Created: / 25.1.1998 / 11:52:01 / cg"
    "Modified: / 14.10.1998 / 14:54:04 / cg"
!

_WTextAreaPeer_create: nativeContext
    |jTextAreaPeer jFrame frame editTextView|

    jTextAreaPeer := nativeContext receiver.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    editTextView := HVScrollableView for:EditTextView in:frame.

    self createdWindowsView:editTextView for:jTextAreaPeer.

    WindowCreationTrace == true ifTrue:[
        'WTextAreaPeer_create: ' print. frame print. ' -> ' print. editTextView printNL.
    ].

    "Created: / 7.1.1998 / 21:49:49 / cg"
    "Modified: / 15.1.1998 / 12:56:18 / cg"
!

_WTextAreaPeer_insertText: nativeContext
    |textView pos string jstring|

    textView := self viewForWPeer: nativeContext.
    (textView isKindOf:ScrollableView) ifTrue:[
        textView := textView scrolledView
    ].

    jstring := nativeContext argAt:1.
    string := Java as_ST_String:jstring.
    pos := nativeContext argAt:2.

    textView insert:string at:pos.
    textView cursorToCharacterPosition:pos + string size.
    textView makeCursorVisible.
"/ textView invalidateRepairNow:true.
    ^ nil

    "Created: / 7.1.1998 / 21:50:23 / cg"
    "Modified: / 5.4.1998 / 17:37:24 / cg"
!

_WTextAreaPeer_replaceText: nativeContext
    "/ void replaceText (java.lang.String int int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:11:14 / cg"
!

_WTextComponentPeer_enableEditing: nativeContext
    |textView enabled|

    textView := self viewForWPeer: nativeContext.
    enabled := (nativeContext argAt:1) ~~ 0.

    ^ textView readOnly:enabled not

    "Created: / 5.1.1998 / 01:29:38 / cg"
    "Modified: / 25.1.1998 / 16:29:56 / cg"
!

_WTextComponentPeer_getSelectionEnd: nativeContext
    |textView|

    textView := self viewForWPeer: nativeContext.

    ^ textView characterPositionOfSelectionEnd

    "Created: / 8.1.1998 / 17:41:56 / cg"
    "Modified: / 15.1.1998 / 15:47:18 / cg"
!

_WTextComponentPeer_getSelectionStart: nativeContext
    |textView|

    textView := self viewForWPeer: nativeContext.

    ^ textView characterPositionOfSelection - 1

    "Created: / 15.8.1997 / 15:45:45 / cg"
    "Modified: / 15.1.1998 / 15:46:51 / cg"
!

_WTextComponentPeer_getText: nativeContext
    |textView string jString|

    textView := self viewForWPeer: nativeContext.

    string := textView contents asString.
    jString := Java as_String:string.
    ^ jString

    "Created: / 6.1.1998 / 21:05:15 / cg"
    "Modified: / 8.1.1998 / 17:36:52 / cg"
!

_WTextComponentPeer_select: nativeContext
    |textView selStart selEnd|

    textView := self viewForWPeer: nativeContext.
    selStart := nativeContext argAt:1.
    selEnd := nativeContext argAt:2.

    selStart == selEnd ifTrue:[
        "/ clear selection
        textView unselect.
        "/ and set caret
        textView cursorToCharacterPosition:selStart + 1
    ] ifFalse:[
        "/ change selection
        textView selectFromCharacterPosition:selStart+1 to:selEnd
    ].

    "Created: / 15.8.1997 / 15:45:58 / cg"
    "Modified: / 15.1.1998 / 21:55:57 / cg"
!

_WTextComponentPeer_setText: nativeContext
    |textView string jstring|

    textView := self viewForWPeer: nativeContext.

    jstring := nativeContext argAt:1.
    jstring notNil ifTrue:[
        string := Java as_ST_String:jstring
    ].

    textView contents:string.

    "Created: / 5.1.1998 / 01:28:23 / cg"
    "Modified: / 11.12.1998 / 12:16:46 / cg"
!

_WTextFieldPeer_create: nativeContext
    |jTextFieldPeer jFrame frame editField|

    jTextFieldPeer := nativeContext receiver.

    jFrame := nativeContext argAt:1.
    frame := jFrame instVarNamed:'pData'.

    editField := EditField in:frame.

    self createdWindowsView:editField for:jTextFieldPeer.

    editField crAction:[
                        jTextFieldPeer perform:#handleAction.
                  ].
    WindowCreationTrace == true ifTrue:[
        'WTextFieldPeer_create: ' print. frame print. ' -> ' print. editField printNL.
    ].

    "Created: / 5.1.1998 / 01:27:37 / cg"
    "Modified: / 4.11.1998 / 21:07:30 / cg"
!

_WTextFieldPeer_setEchoCharacter: nativeContext
    |editField char|

    editField := self viewForWPeer: nativeContext.

    char := nativeContext argAt:1.
    editField passwordCharacter:(Character value:char).

    "Created: / 25.1.1998 / 16:28:30 / cg"
!

_WToolkit_beep: nativeContext
    "/ void beep ()

    Screen current beep

    "Created: / 12.11.1998 / 19:09:23 / cg"
    "Modified: / 11.12.1998 / 12:15:23 / cg"
!

_WToolkit_eventLoop: nativeContext
    (JavaEventThread notNil and:[JavaEventThread isDead not]) ifTrue:[
        'JavaVM [warning]: oops - two threads executing eventLoop' errorPrintCR.
    ].

    JavaEventThread := Processor activeProcess.
    [
        [true] whileTrue:[
            AbortSignal handle:[:ex |
                ex return
            ] do:[
                self doWindowsEventThread.
            ]
        ].
    ] valueNowOrOnUnwindDo:[
        JavaEventThread := nil.
    ].

    "Created: / 6.1.1998 / 21:01:44 / cg"
    "Modified: / 8.1.1999 / 17:08:00 / cg"
!

_WToolkit_getComboHeightOffset: nativeContext
    ^ 0

    "Modified: / 20.3.1997 / 13:50:04 / cg"
    "Created: / 22.10.1998 / 00:59:14 / cg"
!

_WToolkit_getScreenHeight: nativeContext
    ^ Screen current height

    "Modified: / 20.3.1997 / 13:50:04 / cg"
    "Created: / 13.1.1998 / 09:24:45 / cg"
!

_WToolkit_getScreenResolution: nativeContext
    ^ Screen current resolution x rounded

    "Modified: / 20.3.1997 / 13:50:04 / cg"
    "Created: / 17.1.1998 / 21:54:48 / cg"
!

_WToolkit_getScreenWidth: nativeContext
    ^ Screen current width

    "Modified: / 20.3.1997 / 13:50:04 / cg"
    "Created: / 13.1.1998 / 09:24:37 / cg"
!

_WToolkit_init: nativeContext

    "Created: / 3.1.1998 / 02:30:57 / cg"
!

_WToolkit_loadSystemColors: nativeContext
"/ self halt.

    "Modified: / 18.3.1997 / 18:43:26 / cg"
    "Created: / 5.1.1998 / 02:19:09 / cg"
!

_WToolkit_makeColorModel: nativeContext
    "/ java.awt.image.ColorModel makeColorModel ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:08:47 / cg"
!

_WToolkit_sync: nativeContext
    "/ void sync ()
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:09:14 / cg"
!

_WWindowPeer__setResizable: nativeContext
    |view onOff|

    view := self viewForWPeer: nativeContext.

    onOff := (nativeContext argAt:1) == 1.
    view isTopView ifTrue:[
        onOff ifTrue:[
            view minExtent:10@10.
            view maxExtent:(Screen current extent).
        ] ifFalse:[
            view minExtent:view extent.
            view maxExtent:view extent.
        ]
    ] ifFalse:[
        (view isMemberOf:JavaEmbeddedFrameView) ifFalse:[
            self halt.
        ]
    ].

"/ 'JAVA: WWindowPeer_setResizable: ' print. view print. ' yes/no: ' print. onOff printNL.

    ^ nil

    "Created: / 5.1.1998 / 00:57:59 / cg"
    "Modified: / 16.1.1998 / 18:08:00 / cg"
!

_WWindowPeer__setTitle: nativeContext
    |view jString string|

    view := self viewForWPeer: nativeContext.

    jString := nativeContext argAt:1.
    string := Java as_ST_String:jString.

"/ 'JAVA: WWindowPeer_pSetTitle: ' print. string print. ' ' print. view printNL.

    view label:string.
    ^ nil

    "Created: / 5.1.1998 / 00:57:17 / cg"
    "Modified: / 8.1.1998 / 17:37:41 / cg"
!

_WWindowPeer_create: nativeContext
    "/ void create (sun.awt.windows.WComponentPeer)
    |jWindowPeer jWindow window|

    jWindowPeer := nativeContext receiver.

    jWindow := jWindowPeer instVarNamed:'target'.
    window := jWindowPeer instVarNamed:'pData'.

    (window notNil and:[window ~~ 0]) ifTrue:[
        WindowCreationTrace == true ifTrue:[
            'JAVA: window view already created: ' infoPrint.
            Logger 
                  log:jWindowPeer class name
                  severity:Logger severityTRACE
                  facility:#JVM.
        ].
    ] ifFalse:[
"/ OLD
"/        window := StandardSystemView new.
"/        self createdWindowsView:window for:jWindowPeer.
"/        JavaWindowGroup addTopView:window.

        window := JavaPopUpView new.
        window borderWidth:0.
        window level:0.
        window delegate:self.
        window javaPeer:jWindowPeer.
        self createdWindowsView:window for:jWindowPeer.
        JavaWindowGroup addTopView:window.

"/        top := StandardSystemView new.
"/        window := JavaView origin:0.0@0.0 corner:1.0@1.0 in:top.
"/        window delegate:self.
"/        window javaPeer:jWindowPeer.
"/        self createdWindowsView:window for:jWindowPeer.
"/        JavaWindowGroup addTopView:top.

    ].

    WindowCreationTrace == true ifTrue:[
        'JAVA: WWindowPeer_create: ' print. jWindowPeer displayString print.
        ' window: ' print. window printNL.
    ].

    "Created: / 4.1.1998 / 17:56:39 / cg"
    "Modified: / 4.12.1998 / 17:37:59 / cg"
!

_WWindowPeer_getContainerElement: nativeContext
    "/ java.awt.Component getContainerElement (java.awt.Container int)
    JavaVM unimplementedNativeMethodSignal raise

    "Created: / 12.11.1998 / 19:10:54 / cg"
!

_WWindowPeer_toBack: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
    view lower.

    "Created: / 7.5.1998 / 00:23:03 / cg"
!

_WWindowPeer_toFront: nativeContext
    |view|

    view := self viewForWPeer: nativeContext.
    view raise.

    "Created: / 9.4.1998 / 22:17:28 / cg"
!

_WWindowPeer_updateInsets: nativeContext
"/ self halt.

    "Modified: / 18.3.1997 / 18:43:18 / cg"
    "Created: / 4.1.1998 / 18:09:04 / cg"
!

_Win32Process_create: nativeContext
    "really create a win32 process"

    |env cmd jProcess p inPipe outPipe errorPipe|

    jProcess := nativeContext receiver.
    cmd := nativeContext argAt:1.
    cmd := Java as_ST_String:cmd.

    env := nativeContext argAt:2.
    env notNil ifTrue:[
        self halt
    ].
self halt.

    p := Win32Process new.
    p command:cmd.
    p environment:env.
    p inStream:inPipe.
    p outStream:outPipe.
    p errorStream:errorPipe.
    p directory:nil.
    p startProcess.
self halt.

    jProcess instVarNamed:'handle' put:p.

    "Created: / 10.11.1998 / 19:50:31 / cg"
    "Modified: / 10.11.1998 / 21:34:18 / cg"
!

_X11FontMetrics_getMFCharSegmentWidth: nativeContext
    "get multi-font string-segment width.
     Not yet supported - use standard strings width"

    |jMetrics jFont jFontDescr stFont w cp lenght|

    jMetrics := nativeContext receiver.
    jFont := nativeContext argAt:1.
    jFontDescr := nativeContext argAt:2.
    cp := nativeContext argAt:3.
    lenght := nativeContext argAt:4.

    stFont := jFont instVarNamed:'pData'.
    (stFont isNil or:[stFont == 0]) ifTrue:[
        self halt
    ].

    stFont device isNil ifTrue:[
        stFont := stFont on:Display.
        jFont instVarNamed:'pData' put:stFont.
    ].
    w := stFont widthOf:cp from:1 to:lenght.
    ^ w.
!

_X11FontMetrics_init: nativeContext
    ^ self _WFontMetrics_init: nativeContext
!

_X11GraphicsDevice_getConfigType: nativeContext
    "/ new with jdk1.2 ...

    |configNr cls|

    "/ for now, only one config.
    configNr := nativeContext argAt:1.

    cls := Java classNamed:'java.awt.GraphicsDevice'.
    ^ cls instVarNamed:'TYPE_RASTER_SCREEN'.

    "Created: / 28.1.1998 / 22:19:05 / cg"
!

_X11GraphicsDevice_getNumConfigs: nativeContext
    "/ new with jdk1.2 ...

    ^ 1

    "Created: / 28.1.1998 / 22:13:26 / cg"
    "Modified: / 28.1.1998 / 22:14:33 / cg"
!

_X11GraphicsEnvironment_getNumScreens: nativeContext
    "/ new with jdk1.2 ...

    "/ could return the actual number of screens ...

    ^ 1

    "Created: / 28.1.1998 / 01:50:22 / cg"
    "Modified: / 28.1.1998 / 22:12:32 / cg"
!

_X11GraphicsEnvironment_initDisplay: nativeContext
    "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 01:50:22 / cg"
!

_X11Graphics_changeClip: nativeContext
    ^ self _WGraphics_changeClip: nativeContext
!

_X11Graphics_createFromComponent: nativeContext
    ^ self _WGraphics_createFromComponent: nativeContext
!

_X11Graphics_disposeImpl: nativeContext
    ^ self _WGraphics_dispose: nativeContext
!

_X11Graphics_drawMFCharsSegment: nativeContext
    ^ self _WGraphics_drawMFCharsSegment: nativeContext
!

_X11Graphics_drawRect: nativeContext
    ^ self _WGraphics_drawRect: nativeContext
!

_X11Graphics_fillOval: nativeContext
    ^ self _WGraphics_fillOval: nativeContext
!

_X11Graphics_fillRect: nativeContext
    ^ self _WGraphics_fillRect: nativeContext
!

_X11Graphics_pSetFont: nativeContext
    ^ self _WGraphics_pSetFont: nativeContext
!

_X11Graphics_pSetForeground: nativeContext
    ^ self _WGraphics_pSetForeground: nativeContext
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.demo.jvmti.hprof'!

_com_sun_demo_jvmti_hprof_Tracker_nativeCallSite: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/demo/jvmti/hprof/Tracker' name: 'nativeCallSite(Ljava/lang/Object;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_demo_jvmti_hprof_Tracker_nativeNewArray: this _: a1 _: a2

    <javanative: 'com/sun/demo/jvmti/hprof/Tracker' name: 'nativeNewArray(Ljava/lang/Object;Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_demo_jvmti_hprof_Tracker_nativeObjectInit: this _: a1 _: a2

    <javanative: 'com/sun/demo/jvmti/hprof/Tracker' name: 'nativeObjectInit(Ljava/lang/Object;Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_demo_jvmti_hprof_Tracker_nativeReturnSite: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/demo/jvmti/hprof/Tracker' name: 'nativeReturnSite(Ljava/lang/Object;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.imageio.plugins.jpeg'!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_abortRead: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'abortRead(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_disposeReader: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'disposeReader(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_initJPEGImageReader: this

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'initJPEGImageReader()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_initReaderIDs: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'initReaderIDs(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_readImage: this _: a1

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'readImage(J[BI[I[IIIIIII[Ljavax/imageio/plugins/jpeg/JPEGQTable;[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;IIZ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_readImageHeader: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'readImageHeader(JZZ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_resetLibraryState: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'resetLibraryState(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_resetReader: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'resetReader(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_setOutColorSpace: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'setOutColorSpace(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_setSource: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'setSource(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageReader_setSource: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageReader' name: 'setSource(JLjavax/imageio/stream/ImageInputStream;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_abortWrite: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'abortWrite(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_disposeWriter: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'disposeWriter(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_initJPEGImageWriter: this

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'initJPEGImageWriter()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_initWriterIDs: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'initWriterIDs(Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_initWriterIDs: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'initWriterIDs(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_resetWriter: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'resetWriter(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_setDest: this _: a1 _: a2

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'setDest(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_setDest: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'setDest(JLjavax/imageio/stream/ImageOutputStream;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_writeImage: this _: a1

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'writeImage(J[BIII[IIIIII[Ljavax/imageio/plugins/jpeg/JPEGQTable;Z[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;ZZZI[I[I[I[I[IZI)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_imageio_plugins_jpeg_JPEGImageWriter_writeTables: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'com/sun/imageio/plugins/jpeg/JPEGImageWriter' name: 'writeTables(J[Ljavax/imageio/plugins/jpeg/JPEGQTable;[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;[Ljavax/imageio/plugins/jpeg/JPEGHuffmanTable;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.java.swing.plaf.gtk'!

_com_sun_java_swing_plaf_gtk_GTKEngine_nativeFinishPainting: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'nativeFinishPainting([III)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_nativeSetRangeValue: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'nativeSetRangeValue(IDDDD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_nativeStartPainting: this _: a1 _: a2

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'nativeStartPainting(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_get_gtk_setting: this _: a1

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_get_gtk_setting(I)Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_arrow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_arrow(IIILjava/lang/String;IIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_background: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_background(IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_box: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_box(IIILjava/lang/String;IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_box_gap: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_box_gap(IIILjava/lang/String;IIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_check: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_check(IILjava/lang/String;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_expander: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_expander(IILjava/lang/String;IIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_extension: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_extension(IIILjava/lang/String;IIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_flat_box: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_flat_box(IIILjava/lang/String;IIIIZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_focus: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_focus(IILjava/lang/String;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_handle: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_handle(IIILjava/lang/String;IIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_hline: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_hline(IILjava/lang/String;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_option: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_option(IILjava/lang/String;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_shadow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_shadow(IIILjava/lang/String;IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_slider: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_slider(IIILjava/lang/String;IIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_paint_vline: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_paint_vline(IILjava/lang/String;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKEngine_native_switch_theme: this

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKEngine' name: 'native_switch_theme()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKStyle_nativeGetClassValue: this _: a1 _: a2

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKStyle' name: 'nativeGetClassValue(ILjava/lang/String;)Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKStyle_nativeGetColorForState: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKStyle' name: 'nativeGetColorForState(III)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKStyle_nativeGetPangoFontName: this _: a1

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKStyle' name: 'nativeGetPangoFontName(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKStyle_nativeGetXThickness: this _: a1

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKStyle' name: 'nativeGetXThickness(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_swing_plaf_gtk_GTKStyle_nativeGetYThickness: this _: a1

    <javanative: 'com/sun/java/swing/plaf/gtk/GTKStyle' name: 'nativeGetYThickness(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.java.util.jar.pack'!

_com_sun_java_util_jar_pack_NativeUnpack_finish: this

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'finish()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_getNextFile: this _: a1

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'getNextFile([Ljava/lang/Object;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_getOption: this _: a1

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'getOption(Ljava/lang/String;)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_getUnusedInput: this

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'getUnusedInput()Ljava/nio/ByteBuffer;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_initIDs: this

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_setOption: this _: a1 _: a2

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'setOption(Ljava/lang/String;Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_java_util_jar_pack_NativeUnpack_start: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/java/util/jar/pack/NativeUnpack' name: 'start(Ljava/nio/ByteBuffer;J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.management'!

_com_sun_management_UnixOperatingSystem_getCommittedVirtualMemorySize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getCommittedVirtualMemorySize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getFreePhysicalMemorySize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getFreePhysicalMemorySize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getFreeSwapSpaceSize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getFreeSwapSpaceSize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getMaxFileDescriptorCount: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getMaxFileDescriptorCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getOpenFileDescriptorCount: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getOpenFileDescriptorCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getProcessCpuTime: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getProcessCpuTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getTotalPhysicalMemorySize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getTotalPhysicalMemorySize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_getTotalSwapSpaceSize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'getTotalSwapSpaceSize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_management_UnixOperatingSystem_initialize: this

    <javanative: 'com/sun/management/UnixOperatingSystem' name: 'initialize()V'>

    Logger log: 'mh did not set page_size here, which he should :)' severity:Logger severityWARN facility:#JVM.
    ^self.

    "Modified: / 03-11-2011 / 18:59:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.media.sound'!

_com_sun_media_sound_DirectAudioDeviceProvider_nGetNumDevices: this

    <javanative: 'com/sun/media/sound/DirectAudioDeviceProvider' name: 'nGetNumDevices()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDeviceProvider_nNewDirectAudioDeviceInfo: this _: a1

    <javanative: 'com/sun/media/sound/DirectAudioDeviceProvider' name: 'nNewDirectAudioDeviceInfo(I)Lcom/sun/media/sound/DirectAudioDeviceProvider$DirectAudioDeviceInfo;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nAvailable: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nAvailable(JZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nClose: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nClose(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nFlush: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nFlush(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nGetBufferSize: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nGetBufferSize(JZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nGetBytePosition: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nGetBytePosition(JZJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nGetFormats: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nGetFormats(IIZLjava/util/Vector;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nIsStillDraining: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nIsStillDraining(JZ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nOpen: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nOpen(IIZIFIIIZZI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nRead: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nRead(J[BIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nRequiresServicing: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nRequiresServicing(JZ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nService: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nService(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nSetBytePosition: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nSetBytePosition(JZJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nStart: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nStart(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nStop: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nStop(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_DirectAudioDevice_nWrite: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'com/sun/media/sound/DirectAudioDevice' name: 'nWrite(J[BIIIFF)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDeviceProvider_nGetDescription: this _: a1

    <javanative: 'com/sun/media/sound/MidiInDeviceProvider' name: 'nGetDescription(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDeviceProvider_nGetName: this _: a1

    <javanative: 'com/sun/media/sound/MidiInDeviceProvider' name: 'nGetName(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDeviceProvider_nGetNumDevices: this

    <javanative: 'com/sun/media/sound/MidiInDeviceProvider' name: 'nGetNumDevices()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDeviceProvider_nGetVendor: this _: a1

    <javanative: 'com/sun/media/sound/MidiInDeviceProvider' name: 'nGetVendor(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDeviceProvider_nGetVersion: this _: a1

    <javanative: 'com/sun/media/sound/MidiInDeviceProvider' name: 'nGetVersion(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nClose: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nClose(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nGetMessages: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nGetMessages(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nGetTimeStamp: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nGetTimeStamp(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nOpen: this _: a1

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nOpen(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nStart: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nStart(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiInDevice_nStop: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiInDevice' name: 'nStop(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDeviceProvider_nGetDescription: this _: a1

    <javanative: 'com/sun/media/sound/MidiOutDeviceProvider' name: 'nGetDescription(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDeviceProvider_nGetName: this _: a1

    <javanative: 'com/sun/media/sound/MidiOutDeviceProvider' name: 'nGetName(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDeviceProvider_nGetNumDevices: this

    <javanative: 'com/sun/media/sound/MidiOutDeviceProvider' name: 'nGetNumDevices()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDeviceProvider_nGetVendor: this _: a1

    <javanative: 'com/sun/media/sound/MidiOutDeviceProvider' name: 'nGetVendor(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDeviceProvider_nGetVersion: this _: a1

    <javanative: 'com/sun/media/sound/MidiOutDeviceProvider' name: 'nGetVersion(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDevice_nClose: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiOutDevice' name: 'nClose(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDevice_nGetTimeStamp: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/MidiOutDevice' name: 'nGetTimeStamp(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDevice_nOpen: this _: a1

    <javanative: 'com/sun/media/sound/MidiOutDevice' name: 'nOpen(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDevice_nSendLongMessage: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'com/sun/media/sound/MidiOutDevice' name: 'nSendLongMessage(J[BIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_MidiOutDevice_nSendShortMessage: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'com/sun/media/sound/MidiOutDevice' name: 'nSendShortMessage(JIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_Platform_nGetExtraLibraries: this

    <javanative: 'com/sun/media/sound/Platform' name: 'nGetExtraLibraries()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_Platform_nGetLibraryForFeature: this _: a1

    <javanative: 'com/sun/media/sound/Platform' name: 'nGetLibraryForFeature(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_Platform_nIsBigEndian: this

    <javanative: 'com/sun/media/sound/Platform' name: 'nIsBigEndian()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_Platform_nIsSigned8: this

    <javanative: 'com/sun/media/sound/Platform' name: 'nIsSigned8()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixerProvider_nGetNumDevices: this

    <javanative: 'com/sun/media/sound/PortMixerProvider' name: 'nGetNumDevices()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixerProvider_nNewPortMixerInfo: this _: a1

    <javanative: 'com/sun/media/sound/PortMixerProvider' name: 'nNewPortMixerInfo(I)Lcom/sun/media/sound/PortMixerProvider$PortMixerInfo;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nClose: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nClose(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nControlGetFloatValue: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nControlGetFloatValue(J)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nControlGetIntValue: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nControlGetIntValue(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nControlSetFloatValue: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nControlSetFloatValue(JF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nControlSetIntValue: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nControlSetIntValue(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nGetControls: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nGetControls(JILjava/util/Vector;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nGetPortCount: this _: a1 _: a2

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nGetPortCount(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nGetPortName: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nGetPortName(JI)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nGetPortType: this _: a1 _: a2 _: a3

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nGetPortType(JI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_media_sound_PortMixer_nOpen: this _: a1

    <javanative: 'com/sun/media/sound/PortMixer' name: 'nOpen(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - com.sun.security.auth.module'!

_com_sun_security_auth_module_UnixSystem_getUnixInfo: this

    <javanative: 'com/sun/security/auth/module/UnixSystem' name: 'getUnixInfo()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.awt'!

_java_awt_AWTEvent_initIDs: this

    <javanative: 'java/awt/AWTEvent' name: 'initIDs()V'>

    "Intentionally left blank"

    "Modified: / 12-08-2011 / 19:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_awt_AWTEvent_nativeSetSource: this _: a1

    <javanative: 'java/awt/AWTEvent' name: 'nativeSetSource(Ljava/awt/peer/ComponentPeer;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Button_initIDs: this

    <javanative: 'java/awt/Button' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:34 / mh <hlopik@gmail.com>"
!

_java_awt_CheckboxMenuItem_initIDs: this

    <javanative: 'java/awt/CheckboxMenuItem' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Checkbox_initIDs: this

    <javanative: 'java/awt/Checkbox' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Color_initIDs: this

    <javanative: 'java/awt/Color' name: 'initIDs()V'>

        "/ new with jdk1.2 ...

    "Created: / 28.1.1998 / 22:19:23 / cg"
!

_java_awt_Component_initIDs: this

    <javanative: 'java/awt/Component' name: 'initIDs()V'>

        "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 19:53:29 / cg"
!

_java_awt_Container_initIDs: this

    <javanative: 'java/awt/Container' name: 'initIDs()V'>

    "Intentionally left blank"

    "Modified: / 12-08-2011 / 19:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_awt_Cursor_finalizeImpl: this _: a1 _: a2

    <javanative: 'java/awt/Cursor' name: 'finalizeImpl(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Cursor_initIDs: this

    <javanative: 'java/awt/Cursor' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:49 / mh <hlopik@gmail.com>"
!

_java_awt_Dialog_initIDs: this

    <javanative: 'java/awt/Dialog' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:09 / mh <hlopik@gmail.com>"
!

_java_awt_Dimension_initIDs: this

    <javanative: 'java/awt/Dimension' name: 'initIDs()V'>

    "Intentionally left blank"

    "Modified: / 12-08-2011 / 19:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_awt_Event_initIDs: this

    <javanative: 'java/awt/Event' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:11 / mh <hlopik@gmail.com>"
!

_java_awt_FileDialog_initIDs: this

    <javanative: 'java/awt/FileDialog' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_FontMetrics_initIDs: this

    <javanative: 'java/awt/FontMetrics' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Font_initIDs: this

    <javanative: 'java/awt/Font' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Frame_initIDs: this

    <javanative: 'java/awt/Frame' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:52 / mh <hlopik@gmail.com>"
!

_java_awt_Insets_initIDs: this

    <javanative: 'java/awt/Insets' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:54 / mh <hlopik@gmail.com>"
!

_java_awt_KeyboardFocusManager_initIDs: this

    <javanative: 'java/awt/KeyboardFocusManager' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:55:04 / mh <hlopik@gmail.com>"
!

_java_awt_Label_initIDs: this

    <javanative: 'java/awt/Label' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_MenuBar_initIDs: this

    <javanative: 'java/awt/MenuBar' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_MenuComponent_initIDs: this

    <javanative: 'java/awt/MenuComponent' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:22 / mh <hlopik@gmail.com>"
!

_java_awt_MenuItem_initIDs: this

    <javanative: 'java/awt/MenuItem' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:40 / mh <hlopik@gmail.com>"
!

_java_awt_Menu_initIDs: this

    <javanative: 'java/awt/Menu' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Rectangle_initIDs: this

    <javanative: 'java/awt/Rectangle' name: 'initIDs()V'>

    "Intentionally left blank"

    "Modified: / 27-10-2011 / 15:07:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_awt_ScrollPaneAdjustable_initIDs: this

    <javanative: 'java/awt/ScrollPaneAdjustable' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_ScrollPane_initIDs: this

    <javanative: 'java/awt/ScrollPane' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Scrollbar_initIDs: this

    <javanative: 'java/awt/Scrollbar' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__close: this _: a1 _: a2

    <javanative: 'java/awt/SplashScreen' name: '_close(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__getBounds: this _: a1 _: a2

    <javanative: 'java/awt/SplashScreen' name: '_getBounds(J)Ljava/awt/Rectangle;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__getImageFileName: this _: a1 _: a2

    <javanative: 'java/awt/SplashScreen' name: '_getImageFileName(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__getImageJarName: this _: a1 _: a2

    <javanative: 'java/awt/SplashScreen' name: '_getImageJarName(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__getInstance: this

    <javanative: 'java/awt/SplashScreen' name: '_getInstance()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__isVisible: this _: a1 _: a2

    <javanative: 'java/awt/SplashScreen' name: '_isVisible(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__setImageData: this _: a1 _: a2 _: a3

    <javanative: 'java/awt/SplashScreen' name: '_setImageData(J[B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_SplashScreen__update: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'java/awt/SplashScreen' name: '_update(J[IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_TextArea_initIDs: this

    <javanative: 'java/awt/TextArea' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_TextField_initIDs: this

    <javanative: 'java/awt/TextField' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Toolkit_initIDs: this

    <javanative: 'java/awt/Toolkit' name: 'initIDs()V'>

        "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 19:53:50 / cg"
!

_java_awt_TrayIcon_initIDs: this

    <javanative: 'java/awt/TrayIcon' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_Window_initIDs: this

    <javanative: 'java/awt/Window' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:47 / mh <hlopik@gmail.com>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.awt.event'!

_java_awt_event_InputEvent_initIDs: this

    <javanative: 'java/awt/event/InputEvent' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:27 / mh <hlopik@gmail.com>"
!

_java_awt_event_KeyEvent_initIDs: this

    <javanative: 'java/awt/event/KeyEvent' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:33 / mh <hlopik@gmail.com>"
!

_java_awt_event_MouseEvent_initIDs: this

    <javanative: 'java/awt/event/MouseEvent' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:53:40 / mh <hlopik@gmail.com>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.awt.image'!

_java_awt_image_BufferedImage_initIDs: this

    <javanative: 'java/awt/image/BufferedImage' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_ColorModel_initIDs: this

    <javanative: 'java/awt/image/ColorModel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_ComponentSampleModel_initIDs: this

    <javanative: 'java/awt/image/ComponentSampleModel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_IndexColorModel_initIDs: this

    <javanative: 'java/awt/image/IndexColorModel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_Kernel_initIDs: this

    <javanative: 'java/awt/image/Kernel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_Raster_initIDs: this

    <javanative: 'java/awt/image/Raster' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_SampleModel_initIDs: this

    <javanative: 'java/awt/image/SampleModel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_awt_image_SinglePixelPackedSampleModel_initIDs: this

    <javanative: 'java/awt/image/SinglePixelPackedSampleModel' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.io'!

_java_io_Console_echo: this

    <javanative: 'java/io/Console' name: 'echo(Z)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_Console_echo: this _: a1

    <javanative: 'java/io/Console' name: 'echo(Z)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_Console_encoding: this

    <javanative: 'java/io/Console' name: 'encoding()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_Console_istty: this

    <javanative: 'java/io/Console' name: 'istty()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_FileDescriptor_initIDs: this

    <javanative: 'java/io/FileDescriptor' name: 'initIDs()V'>

        "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 18:16:29 / cg"
!

_java_io_FileDescriptor_set: this _:a1

    <javanative: 'java/io/FileDescriptor' name: 'set(I)J'>

    "SunJDK Speciofic method, we don't need handles, so return
     FD instead"

    ^a1

    "Modified: / 18-08-2011 / 19:54:36 / jv"
!

_java_io_FileDescriptor_sync: this

    <javanative: 'java/io/FileDescriptor' name: 'sync()V'>
    "
    /**
    * Force all system buffers to synchronize with the underlying
    * device.  This method returns after all modified data and
    * attributes of this FileDescriptor have been written to the
    * relevant device(s).  In particular, if this FileDescriptor
    * refers to a physical storage medium, such as a file in a file
    * system, sync will not return until all in-memory modified copies
    * of buffers associated with this FileDescriptor have been
    * written to the physical medium.
    *
    * sync is meant to be used by code that requires physical
    * storage (such as a file) to be in a known state  For
    * example, a class that provided a simple transaction facility
    * might use sync to ensure that all changes to a file caused
    * by a given transaction were recorded on a storage medium.
    *
    * sync only affects buffers downstream of this FileDescriptor.  If
    * any in-memory buffering is being done by the application (for
    * example, by a BufferedOutputStream object), those buffers must
    * be flushed into the FileDescriptor (for example, by invoking
    * OutputStream.flush) before that data will be affected by sync.
    *
    * @exception SyncFailedException
    *        Thrown when the buffers cannot be flushed,
    *        or because the system cannot guarantee that all the
    *        buffers have been synchronized with physical media.
    * @since     JDK1.1
    */
    public native void sync() throws SyncFailedException;
    "

    OpenFileTable do:[:stream|
        stream notNil ifTrue:[stream flush].
    ].

    "Created: / 12-11-1998 / 19:26:25 / cg"
    "Modified (format): / 10-08-2011 / 19:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_available: this

    <javanative: 'java/io/FileInputStream' name: 'available()I'>

        |file|

    file := self validateFile:this.
    file == Stdin ifTrue:[
        file := StdinReplacementFileQuerySignal raiseRequest.
        file isNil ifTrue:[
            ^ 1
        ]
    ].
    file isFileStream ifTrue:[
        ^ file size - file position + 1
    ].
    file atEnd ifTrue:[
        ^ 0.
    ].
    self halt.
    ^ 1

    "Modified: / 14-01-1998 / 15:12:52 / cg"
    "Modified: / 28-07-2012 / 02:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_close0: this

    <javanative: 'java/io/FileInputStream' name: 'close0()V'>

    ^self commonClose: this

    "Modified: / 30-01-2013 / 17:50:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_initIDs: this

    <javanative: 'java/io/FileInputStream' name: 'initIDs()V'>

        "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 18:15:51 / cg"
!

_java_io_FileInputStream_open: this _:fnameArg

    <javanative: 'java/io/FileInputStream' name: 'open(Ljava/lang/String;)V'>

    |fs fd fname stream fileNo|

    fs := this.
    fd := fs instVarNamed:'fd'.
    (fileNo := fd instVarNamed:'fd') ~~ 0 ifTrue:[
        fileNo ~~ -1 ifTrue:[
            self halt:'file already open'.
            self internalError:'file already open'.
            ^ self.
        ]
    ].

    fname := fnameArg.
    fname := Java as_ST_String:fname.

    fname := self fixFilename:fname.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opening ' , fname)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    stream := self fileStreamForReading:fname.
    stream isNil ifTrue:[
        ^ self.
    ].
    stream buffered:false.

"/    FileOpenConfirmation ifTrue:[
"/        (self confirm:('JAVA Security check\\Opening ''' , name , ''' for reading.\Grant permission ?') withCRs)
"/        ifFalse:[
"/            self throwIOExceptionWithMessage:('no permission to open ' , name , ' for reading').
"/            ^ self
"/        ]
"/    ].

    fileNo := self addOpenFile:stream.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opened ' , fname , ' as FD ' , fileNo printString)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    fd instVarNamed:'fd' put:fileNo.
    "Kludge for finalization..."

    "Created: / 04-01-1998 / 16:47:12 / cg"
    "Modified: / 28-01-1999 / 17:24:07 / cg"
    "Modified: / 24-07-2012 / 02:17:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_read: this

    <javanative: 'java/io/FileInputStream' name: 'read()I'>

        |file byte|

    file := self validateFile:this.

    file == Stdin ifTrue:[
        file := StdinReplacementFileQuerySignal raiseRequest.
        file isNil ifTrue:[
            ^ -1
        ]
    ].

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: read 1 byte from ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    byte := file nextByte.
    byte isNil ifTrue:[
        ^ -1
    ].
    "Java bytes are signed"
    byte > 127 ifTrue:[
        byte :=
            byte"/ - 255.
    ].
    ^ byte

    "Created: / 05-01-1998 / 02:17:08 / cg"
    "Modified (format): / 12-12-2012 / 23:53:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_readBytes: this _:bytes _: offset _: count

    <javanative: 'java/io/FileInputStream' name: 'readBytes([BII)I'>

    ^ self anyStream_read: this bytes: bytes offset: offset count: count.

    "Modified: / 04-02-1998 / 15:23:08 / cg"
    "Modified: / 30-01-2013 / 17:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileInputStream_skip: this _:a1 _: a2

    <javanative: 'java/io/FileInputStream' name: 'skip(J)J'>

        "/ long skip (long)
    |file nSkip|

    file := self validateFile:this.
    nSkip := a1.

    file == Stdin ifTrue:[
        file := StdinReplacementFileQuerySignal raiseRequest.
        file isNil ifTrue:[
            ^ -1
        ]
    ].

    FileIOTrace ifTrue:[
        Logger 
              log:(('JAVA: skip %1 byte(s) from ' bindWith:nSkip printString) 
                      , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    file skip:nSkip.
    ^ nSkip

    "Modified: / 27.1.1999 / 20:36:11 / cg"
!

_java_io_FileOutputStream_close0: this

    <javanative: 'java/io/FileOutputStream' name: 'close0()V'>

    ^self commonClose: this

    "Modified: / 30-01-2013 / 17:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_initIDs: this

    <javanative: 'java/io/FileOutputStream' name: 'initIDs()V'>

        "/ introduced with jdk1.2 ... (sigh)

    "Created: / 27.1.1998 / 18:16:40 / cg"
!

_java_io_FileOutputStream_open: this _:a1

    <javanative: 'java/io/FileOutputStream' name: 'open(Ljava/lang/String;)V'>

    ^ self commonOpen: this path: a1 forAppend:false

    "Modified: / 07-04-1998 / 19:14:31 / cg"
    "Modified: / 30-01-2013 / 17:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_openAppend: this _:a1

    <javanative: 'java/io/FileOutputStream' name: 'openAppend(Ljava/lang/String;)V'>

    ^ self commonOpen: this path: a1  forAppend:true

    "Modified: / 07-04-1998 / 19:13:42 / cg"
    "Modified: / 30-01-2013 / 17:53:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_write: this _:a1

    <javanative: 'java/io/FileOutputStream' name: 'write(I)V'>
    "
     /**
     * Writes the specified byte to this file output stream. Implements
     * the <code>write</code> method of <code>OutputStream</code>.
     *
     * @param      b   the byte to be written.
     * @exception  IOException  if an I/O error occurs.
     */
     public native void write(int b) throws IOException;
    "

    | fdobj fd stream b |
    b := a1.
    "/Java byte is signed, make it integer in 0-255"
    b < 0 ifTrue:[b := b + 256].
    fdobj := (this instVarNamed: #fd).
    fd    := fdobj instVarNamed: #fd.
    stream := self getOpenFileAt:fd.
    [
        stream nextPut: b
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage:ex description
    ]

    "Modified: / 15-12-2012 / 16:31:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_writeBytes: this _:bytes _: offset _: count

    <javanative: 'java/io/FileOutputStream' name: 'writeBytes([BII)V'>

    ^ self anyStream_write: this bytes: bytes offset: offset count: count append: false

    "Modified: / 04-02-1998 / 15:24:20 / cg"
    "Modified: / 08-02-2013 / 11:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileSystem_getFileSystem: this
    <javanative: 'java/io/FileSystem' name: 'getFileSystem()Ljava/io/FileSystem;'>
    OperatingSystem isUNIXlike ifTrue: [
        ^ (JavaVM classForName:'java.io.UnixFileSystem' definedBy:nil) new
    ].
    OperatingSystem isMSWINDOWSlike ifTrue: [
        ^ (JavaVM classForName: 'java.io.WinNTFileSystem' definedBy: nil) new
    ].
    self error: 'Unknown/Unsupported platform'

    "Created: / 09-12-2010 / 17:58:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2013 / 10:58:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_ObjectInputStream_bytesToDoubles: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/ObjectInputStream' name: 'bytesToDoubles([BI[DII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectInputStream_bytesToDoubles: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/io/ObjectInputStream' name: 'bytesToDoubles([BI[DII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectInputStream_bytesToFloats: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/ObjectInputStream' name: 'bytesToFloats([BI[FII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectInputStream_bytesToFloats: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/io/ObjectInputStream' name: 'bytesToFloats([BI[FII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectInputStream_latestUserDefinedLoader: this

    <javanative: 'java/io/ObjectInputStream' name: 'latestUserDefinedLoader()Ljava/lang/ClassLoader;'>

    "
    /**
    * Returns the first non-null class loader (not counting class loaders of
    * generated reflection implementation classes) up the execution stack, or
    * null if only code from the null class loader is on the stack.  This
    * method is also called via reflection by the following RMI-IIOP class:
    *
    *     com.sun.corba.se.internal.util.JDKClassLoader
    *
    * This method should not be removed or its signature changed without
    * corresponding modifications to the above class.
    */
    // REMIND: change name to something more accurate?
    private static native ClassLoader latestUserDefinedLoader();
    "

    | ctx cl |
    ctx := self nativeContext.
    [ ctx notNil ] whileTrue:[
        ctx receiver isJavaObject ifTrue:[
            (cl := ctx receiver class classLoader) notNil ifTrue:[
                "/self breakPoint: #jv info: 'Should not count class loaders of generated reflection implementation classes'.
                "/Please check"
                ^cl.
            ]
        ].
        ctx := ctx sender.
    ].
    ^nil

    "Modified: / 30-01-2013 / 14:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_ObjectOutputStream_doublesToBytes: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/ObjectOutputStream' name: 'doublesToBytes([DI[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectOutputStream_doublesToBytes: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/io/ObjectOutputStream' name: 'doublesToBytes([DI[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectOutputStream_floatsToBytes: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/ObjectOutputStream' name: 'floatsToBytes([FI[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectOutputStream_floatsToBytes: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/io/ObjectOutputStream' name: 'floatsToBytes([FI[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_ObjectStreamClass_hasStaticInitializer: this _:a1

    <javanative: 'java/io/ObjectStreamClass' name: 'hasStaticInitializer(Ljava/lang/Class;)Z'>

    | cls |
    cls := Reflection classForJavaClassObject: a1.
    ^(cls includesSelector: #'<clinit>()V') ifTrue:[1] ifFalse:[0]

    "Modified: / 10-08-2011 / 01:13:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_ObjectStreamClass_initNative: this

    <javanative: 'java/io/ObjectStreamClass' name: 'initNative()V'>


    "
    /**
     * Initializes native code.
     */
    "
    "Nothing to do"

    "Created: / 20-12-2010 / 17:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_close0: this

    <javanative: 'java/io/RandomAccessFile' name: 'close0()V'>

    ^ self commonClose: this

    "Modified: / 30-01-2013 / 17:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_getFilePointer: this
    "
    /**
     * Returns the current offset in this file.
     *
     * @return     the offset from the beginning of the file, in bytes,
     *             at which the next read or write occurs.
     * @exception  IOException  if an I/O error occurs.
     */
    "
    <javanative: 'java/io/RandomAccessFile' name: 'getFilePointer()J'>

    | file |

    file := self validateFile:this.

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: getFilePointer on ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].
    ^file position

    "Modified: / 13-11-2013 / 11:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_initIDs: this

    <javanative: 'java/io/RandomAccessFile' name: 'initIDs()V'>

    "Nothing to do"

    "Modified: / 10-08-2011 / 21:49:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_length: this

    <javanative: 'java/io/RandomAccessFile' name: 'length()J'>

    | file sz |

    file := self validateFile:this.

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: length of ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    file flush.
    sz := file fileSize.
    ^ sz.

    "Created: / 04-02-1998 / 13:27:58 / cg"
    "Modified (format): / 13-11-2013 / 10:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_open: this _:a1 _: a2

    <javanative: 'java/io/RandomAccessFile' name: 'open(Ljava/lang/String;I)V'>

    |fs fd nm mode filename dir stream fileNo answer readonly|


    fs := this.
    fd := fs instVarNamed:'fd'.
    (fd instVarNamed:'fd') ~~ -1 ifTrue:[
        self halt:'file already open'.
        self internalError:'file already open'.
        ^ self.
    ].

    nm := a1.
    nm := Java as_ST_String:nm.
    nm := self fixFilename:nm.
    mode := a2.

    "
    private static final int O_RDONLY = 1;
    private static final int O_RDWR =   2;
    private static final int O_SYNC =   4;
    private static final int O_DSYNC =  8;
    "
    readonly := (mode bitAnd:1) == 1.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opening ' , nm)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    dir := (filename := nm utf8Encoded asFilename) directory pathName.

    filename isDirectory ifTrue:[
        JavaVM throwFileNotFoundException: nm , ' is directory, not file'.
        ^ nil.
    ].

    (PermittedDirectories notNil
    and:[PermittedDirectories includes:dir]) ifFalse:[
        FileOpenConfirmation ifTrue:[
            answer := Dialog
                    confirmWithCancel:('JAVA Security check\\Opening ''' , nm , ''' for read/write.\Grant permission ?') withCRs
                               labels:#('no' 'grant' 'readonly')
                               values:#(false true #readonly)
                              default:3.
            answer == false ifTrue:[
                JavaVM throwIOExceptionWithMessage:('no permission to open ' , nm
            , ' for writing').
                ^ self
            ].
            readonly := (answer == #readonly).

            readonly ifFalse:[
                (self confirm:('JAVA Security check\\Always permit writes in this directory (''' , dir , ''') ?') withCRs)
                ifTrue:[
                    PermittedDirectories isNil ifTrue:[
                        PermittedDirectories := Set new
                    ].
                    PermittedDirectories add:dir.
                ]
            ]
        ]
    ].

    (filename exists not and:[readonly]) ifTrue:[
        JavaVM throwIOExceptionWithMessage:'File ' , nm , ' does not exist'.
        ^ nil.
    ].

    readonly ifTrue:[
        stream := self commonOpenStreamUsing:[filename readStream].
    ] ifFalse:[
        stream := self commonOpenStreamUsing:[filename readWriteStream].
        stream isNil ifTrue:[
            JavaVM throwIOExceptionWithMessage:('cannot open ' , nm , ' for writing').
        ].
    ].
    stream binary.


    fileNo := self addOpenFile:stream.

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: opened ' , nm , ' as FD ' , fileNo printString 
                      , ' for writing')
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    fd instVarNamed:'fd' put:fileNo.
    "Kludge for finalization..."
    fs finalizationLobby registerChange: fs

    "Created: / 04-02-1998 / 00:14:48 / cg"
    "Modified: / 12-11-1998 / 21:29:46 / cg"
    "Modified: / 13-11-2013 / 11:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_read: this

    <javanative: 'java/io/RandomAccessFile' name: 'read()I'>

        |file byte|

    file := self validateFile:this.

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: read 1 byte from ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    byte := file nextByte.
    byte isNil ifTrue:[
        ^ -1
    ].
    ^ byte

    "Modified: / 5.1.1998 / 02:17:25 / cg"
    "Created: / 27.1.1999 / 19:01:15 / cg"
!

_java_io_RandomAccessFile_readBytes: this _:bytes _: offset _: count

    <javanative: 'java/io/RandomAccessFile' name: 'readBytes([BII)I'>

    ^ self anyStream_read: this bytes: bytes offset: offset count: count.

    "Modified: / 04-02-1998 / 15:23:27 / cg"
    "Modified: / 30-01-2013 / 17:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_seek: this _:a1 _: a2
    <javanative: 'java/io/RandomAccessFile' name: 'seek(J)V'>

        |file pos|

    file := self validateFile:this.

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: seek on ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    pos := a1.
    file position:pos

    "Created: / 04-02-1998 / 13:25:38 / cg"
    "Modified (comment): / 06-07-2012 / 12:39:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_setLength: this _: newLength _: ignored

    <javanative: 'java/io/RandomAccessFile' name: 'setLength(J)V'>
    "
    /**
     * Sets the length of this file.
     *
     * <p> If the present length of the file as returned by the
     * <code>length</code> method is greater than the <code>newLength</code>
     * argument then the file will be truncated.  In this case, if the file
     * offset as returned by the <code>getFilePointer</code> method is greater
     * than <code>newLength</code> then after this method returns the offset
     * will be equal to <code>newLength</code>.
     *
     * <p> If the present length of the file as returned by the
     * <code>length</code> method is smaller than the <code>newLength</code>
     * argument then the file will be extended.  In this case, the contents of
     * the extended portion of the file are not defined.
     *
     * @param      newLength    The desired length of the file
     * @exception  IOException  If an I/O error occurs
     * @since      1.2
     */
    "

    | file sz |

    file := self validateFile:this.

    FileIOTrace ifTrue:[
        Logger 
              log:('JAVA: length of ' , file pathName)
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    file flush.
    sz := file fileSize.
    file truncateTo: newLength .
    sz > newLength ifTrue:[
        file position0Based: newLength.
    ].
    ^ sz.

    "Modified: / 13-11-2013 / 11:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_write: this _: a1

    <javanative: 'java/io/RandomAccessFile' name: 'write(I)V'>

    ^ self _java_io_FileOutputStream_write: this _:a1

    "Modified: / 13-11-2013 / 11:03:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_RandomAccessFile_writeBytes: this _:bytes _: offset _: count

    <javanative: 'java/io/RandomAccessFile' name: 'writeBytes([BII)V'>

        ^ self anyStream_write: this bytes: bytes offset: offset count: count append: false

    "Created: / 04-02-1998 / 15:24:35 / cg"
    "Modified: / 08-02-2013 / 11:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_canonicalize0: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'canonicalize0(Ljava/lang/String;)Ljava/lang/String;'>

    |  path |

    path := Java as_ST_String: a1.
    ^(Java as_String: path utf8Encoded asFilename asAbsoluteFilename pathName utf8Decoded)

    "Created: / 10-12-2010 / 14:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_checkAccess: this _:a1 _: a2

    <javanative: 'java/io/UnixFileSystem' name: 'checkAccess(Ljava/io/File;I)Z'>

    "
     public static final int ACCESS_READ    = 0x04;
     public static final int ACCESS_WRITE   = 0x02;
     public static final int ACCESS_EXECUTE = 0x01;
    "

    | fileobj file access result |
    fileobj := a1.
    file := (Java as_ST_String:(fileobj instVarNamed:#path)) asFilename.
    access := a2.
    [
        access == 16r01 ifTrue:[result := file isExecutable].
        access == 16r02 ifTrue:[result := file isWritable].
        access == 16r04 ifTrue:[result := file isReadable].
    ] on: Error do:[
        result := false.
    ].
    ^result ifTrue:[1] ifFalse:[0].

    "Modified: / 09-08-2011 / 17:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_createDirectory: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'createDirectory(Ljava/io/File;)Z'>

    | fileobj file |
    fileobj := a1.
    file := Java as_ST_String: (fileobj instVarNamed:#path).
    file := file asFilename.
    file exists ifFalse:[
        [
            file recursiveMakeDirectory.
            ^1.
        ] on: Error do:[:ex|
            JavaVM throwIOExceptionWithMessage:ex description.
        ].
    ].
    ^0

    "Modified: / 05-12-2011 / 23:04:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_createFileExclusively: this _: name

    <javanative: 'java/io/UnixFileSystem' name: 'createFileExclusively(Ljava/lang/String;)Z'>

    | path file result |

    path := Java as_ST_String: name.
    [
        file := FileStream basicNew.
        result := (file openFile: path withMode: #(CREATE_NEW GENERIC_READ_WRITE) attributes: nil) notNil ifTrue:[1] ifFalse:[0].
        file close.
    ] on: OpenError do:[
        result := 0.
    ].
    ^ result.

    "Modified: / 12-11-2013 / 23:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_createFileExclusively: this _:a1 _: a2

    <javanative: 'java/io/UnixFileSystem' name: 'createFileExclusively(Ljava/lang/String;Z)Z'>

    | file |
    file := Java as_ST_String: a1.
    file := file asFilename.
    file exists ifFalse:[
        [
            file createAsEmptyFile
        ] on: Error do:[:ex|
            JavaVM throwIOExceptionWithMessage:ex description.
        ].
        ^1
    ].
    ^0

    "Modified: / 10-08-2011 / 13:42:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_delete0: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'delete0(Ljava/io/File;)Z'>
    "
      /**
      * Delete the file or directory denoted by the given abstract pathname,
      * returning <code>true</code> if and only if the operation succeeds.
      */
      public abstract boolean delete(File f);
    "
    | file |

    file := (Java as_ST_String: (a1 instVarNamed: #path)) asFilename.
    file exists ifFalse:[^0].
    ^[
        file remove.
        true
    ] on: Error do:[
        false
    ]

    "Modified: / 09-08-2011 / 17:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_getBooleanAttributes0: this _:a1
    <javanative: 'java/io/UnixFileSystem' name: 'getBooleanAttributes0(Ljava/io/File;)I'>
    | file  path  retval  fileSystemClass |
    retval := 0.
    file := a1.
    path := Java as_ST_String: (a1 perform: #'getAbsolutePath()Ljava/lang/String;').
    fileSystemClass := JavaVM classForName:'java.io.FileSystem' definedBy:nil.
    path asFilename exists ifTrue: [
        retval := retval bitOr: (fileSystemClass instVarNamed: #'BA_EXISTS')
    ] ifFalse: [ ^ 0. ].
    path asFilename isDirectory ifTrue: [
        retval := retval bitOr: (fileSystemClass instVarNamed: #'BA_DIRECTORY')
    ].
    path asFilename isRegularFile ifTrue: [
        retval := retval bitOr: (fileSystemClass instVarNamed: #'BA_REGULAR')
    ].
    path asFilename isHidden ifTrue: [
        retval := retval bitOr: (fileSystemClass instVarNamed: #'BA_HIDDEN')
    ].
    ^ retval

    "Modified: / 10-12-2010 / 14:43:31 / Jan Kurs <kurs.jan@post.cz>"
    "Created: / 10-12-2010 / 14:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-12-2010 / 19:44:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2011 / 11:03:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_java_io_UnixFileSystem_getLastModifiedTime: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'getLastModifiedTime(Ljava/io/File;)J'>

    | file  filename  |

    file := a1.
    filename := (Java as_ST_String: (file instVarNamed: #path)) utf8Encoded asFilename.
    ^filename exists ifTrue:[
        filename modificationTime asMilliseconds
    ] ifFalse:[
        0
    ].

    "Modified: / 10-12-2010 / 14:43:31 / Jan Kurs <kurs.jan@post.cz>"
    "Created: / 27-03-2011 / 15:32:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 06-07-2012 / 08:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_getLength: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'getLength(Ljava/io/File;)J'>

    | file |

    file := (Java as_ST_String: (a1 instVarNamed: #path)) asFilename.
    file exists ifFalse:[^0].
    ^file fileSize

    "Modified: / 09-08-2011 / 15:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_getSpace: this _: a1

    <javanative: 'java/io/UnixFileSystem' name: 'getSpace(Ljava/io/File;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_UnixFileSystem_getSpace: this _: a1 _: a2

    <javanative: 'java/io/UnixFileSystem' name: 'getSpace(Ljava/io/File;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_UnixFileSystem_initIDs: this

    <javanative: 'java/io/UnixFileSystem' name: 'initIDs()V'>


    self breakPoint: #libjava

    "Created: / 10-12-2010 / 14:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-12-2010 / 20:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_list: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: #'list(Ljava/io/File;)[Ljava/lang/String;'>
    "
    /**
    * Returns an array of strings naming the files and directories in the
    * directory denoted by this abstract pathname.
    *
    * <p> If this abstract pathname does not denote a directory, then this
    * method returns {@code null}.  Otherwise an array of strings is
    * returned, one for each file or directory in the directory.  Names
    * denoting the directory itself and the directory's parent directory are
    * not included in the result.  Each string is a file name rather than a
    * complete path.
    *
    * <p> There is no guarantee that the name strings in the resulting array
    * will appear in any specific order; they are not, in particular,
    * guaranteed to appear in alphabetical order.
    *
    * @return  An array of strings naming the files and directories in the
    *          directory denoted by this abstract pathname.  The array will be
    *          empty if the directory is empty.  Returns {@code null} if
    *          this abstract pathname does not denote a directory, or if an
    *          I/O error occurs.
    */
   "
    | fileobj file names jnames |
    fileobj := a1.
    file := Java as_ST_String: (fileobj instVarNamed:#path).
    file := file asFilename.
    file exists ifFalse:[^nil].
    file isDirectory ifFalse:[^nil].

    names := file directoryContents.
    jnames := (Java at:'java.lang.String') javaArrayClass new: names size.
    1 to: names size do:[:i|
        jnames at: i put: (Java as_String:(names at: i))
    ].
    ^jnames

    "Modified: / 23-07-2012 / 21:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_rename0: this _:a1 _: a2

    <javanative: 'java/io/UnixFileSystem' name: 'rename0(Ljava/io/File;Ljava/io/File;)Z'>

    | file1 file2 |

    file1 := (Java as_ST_String: (a1 instVarNamed: #path)) asFilename.
    file2 := (Java as_ST_String: (a2 instVarNamed: #path)) asFilename.
    file1 exists ifFalse:[^0].
    ^[
        file1 moveTo: file2.
        true
    ] on: Error do:[
        false
    ]

    "Modified: / 09-12-2011 / 20:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_setLastModifiedTime: this _:a1 _: a2 _: a3

    <javanative: 'java/io/UnixFileSystem' name: 'setLastModifiedTime(Ljava/io/File;J)Z'>

    | f mtime file |
    f := a1.
    mtime := a2.
    file := (Java as_ST_String: (f instVarNamed: #path)) asFilename.

    self breakPoint: #jv. "There is no interface for that in St/X"

    "Modified: / 05-12-2011 / 23:42:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_setPermission: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/UnixFileSystem' name: 'setPermission(Ljava/io/File;IZZ)Z'>
    "
    /**
     * Set on or off the access permission (to owner only or to all) to the file
     * or directory denoted by the given abstract pathname, based on the parameters
     * enable, access and oweronly.
     */
    public abstract boolean setPermission(File f, int access, boolean enable, boolean owneronly);
    "
    | f access enable owneronly file perms |
    f := a1.
    access := a2.
    enable := a3 == 1.
    owneronly := a4 == 1.
    file := (Java as_ST_String: (f instVarNamed: #path)) asFilename.
    "
    public static final int ACCESS_READ    = 0x04;
    public static final int ACCESS_WRITE   = 0x02;
    public static final int ACCESS_EXECUTE = 0x01;
    "

    access == 16r04 ifTrue:[
        perms := owneronly ifFalse:[#(readUser readGroup readOthers)] ifTrue:[#(readUser)].
    ].
    access == 16r02 ifTrue:[
        perms := owneronly ifFalse:[#(writeUser writeGroup writeOthers)] ifTrue:[#(writeUser)].
    ].
    access == 16r01 ifTrue:[
        perms := owneronly ifFalse:[#(executeUser executeGroup executeOthers)] ifTrue:[#(executeUser)].
    ].
    [
        enable ifTrue:[
            file addAccessRights: perms
        ] ifFalse:[
            file removeAccessRights: perms
        ].
        ^ 1.
    ] on: Error do:[
        ^ 0
    ].
    ^0

    "Modified: / 09-08-2011 / 17:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_UnixFileSystem_setReadOnly: this _:a1

    <javanative: 'java/io/UnixFileSystem' name: 'setReadOnly(Ljava/io/File;)Z'>

    | fileobj file |
    fileobj := a1.
    file := Java as_ST_String: (fileobj instVarNamed:#path).
    file := file asFilename.
    file exists ifFalse:[^0].
    [
        file  removeAccessRights: #(writeUser writeGroup writeOthers).
        ^1
    ] on: Error do:[
        ^0
    ].
    ^0

    "Modified: / 10-08-2011 / 13:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_canonicalize0: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'canonicalize0(Ljava/lang/String;)Ljava/lang/String;'>

    ^ self _java_io_WinNTFileSystem_canonicalize0: this _: a1

    "Modified: / 11-11-2013 / 22:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_canonicalizeWithPrefix0: this _: a1 _: a2

    <javanative: 'java/io/Win32FileSystem' name: 'canonicalizeWithPrefix0(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;'>

    ^ self _java_io_WinNTFileSystem_canonicalizeWithPrefix0: this _: a1 _: a2

    "Modified: / 11-11-2013 / 22:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_checkAccess: this _: a1 _: a2

    <javanative: 'java/io/Win32FileSystem' name: 'checkAccess(Ljava/io/File;I)Z'>

    ^ self _java_io_WinNTFileSystem_checkAccess: this _: a1 _: a2

    "Modified: / 11-11-2013 / 22:01:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_createDirectory: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'createDirectory(Ljava/io/File;)Z'>

    ^ self _java_io_WinNTFileSystem_createDirectory: this _: a1

    "Modified: / 11-11-2013 / 22:01:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_createFileExclusively: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'createFileExclusively(Ljava/lang/String;)Z'>

    ^ self _java_io_WinNTFileSystem_createFileExclusively: this _: a1

    "Modified: / 11-11-2013 / 22:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_createFileExclusively: this _: a1 _: a2 

    <javanative: 'java/io/Win32FileSystem' name: 'createFileExclusively(Ljava/lang/String;Z)Z'>

    ^ self _java_io_WinNTFileSystem_createFileExclusively: this _: a1 _: a2

    "Modified: / 12-02-2014 / 10:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_delete0: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'delete0(Ljava/io/File;)Z'>

    ^ self _java_io_WinNTFileSystem_delete0: this _: a1

    "Modified: / 11-02-2014 / 18:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_getBooleanAttributes: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'getBooleanAttributes(Ljava/io/File;)I'>

    ^ self _java_io_WinNTFileSystem_getBooleanAttributes: this _: a1

    "Modified: / 11-02-2014 / 18:30:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_getDriveDirectory: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'getDriveDirectory(I)Ljava/lang/String;'>

    ^ self _java_io_WinNTFileSystem_getDriveDirectory: this _: a1

    "Modified: / 11-02-2014 / 18:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_getLastModifiedTime: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'getLastModifiedTime(Ljava/io/File;)J'>

    ^ self _java_io_WinNTFileSystem_getLastModifiedTime: this _: a1

    "Modified: / 11-02-2014 / 18:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_getLength: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'getLength(Ljava/io/File;)J'>

    ^ self _java_io_WinNTFileSystem_getLength: this _: a1

    "Modified: / 11-02-2014 / 18:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_getSpace0: this _: a1 _: a2

    <javanative: 'java/io/Win32FileSystem' name: 'getSpace0(Ljava/io/File;I)J'>

    ^ self _java_io_WinNTFileSystem_getSpace0: this _: a1 _: a2

    "Modified: / 11-02-2014 / 18:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_initIDs: this

    <javanative: 'java/io/Win32FileSystem' name: 'initIDs()V'>

    "Intentionally left blank"
!

_java_io_Win32FileSystem_list: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'list(Ljava/io/File;)[Ljava/lang/String;'>

    ^ self _java_io_WinNTFileSystem_list: this _: a1

    "Modified: / 11-02-2014 / 18:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_listRoots0: this

    <javanative: 'java/io/Win32FileSystem' name: 'listRoots0()I'>

    | driveMask codePointA |

    driveMask := 0.
    codePointA := $A codePoint.
    OperatingSystem getDriveList do:[:each |
        driveMask := driveMask | (1 << (each first codePoint - codePointA))
    ].
    ^driveMask

    "
    self _java_io_Win32FileSystem_listRoots0: nil.
    "

    "Modified: / 12-02-2014 / 10:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_rename0: this _: a1 _: a2

    <javanative: 'java/io/Win32FileSystem' name: 'rename0(Ljava/io/File;Ljava/io/File;)Z'>

    ^ self _java_io_WinNTFileSystem_rename0: this _: a1 _: a2

    "Modified: / 11-02-2014 / 18:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_setLastModifiedTime: this _: a1 _: a2 _: a3

    <javanative: 'java/io/Win32FileSystem' name: 'setLastModifiedTime(Ljava/io/File;J)Z'>

    ^ self _java_io_WinNTFileSystem_setLastModifiedTime: this _: a1 _: a2 _: a3

    "Modified: / 11-02-2014 / 18:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_setPermission: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/Win32FileSystem' name: 'setPermission(Ljava/io/File;IZZ)Z'>

    ^ self _java_io_WinNTFileSystem_setPermission: this _: a1 _: a2 _: a3 _: a4

    "Modified: / 11-02-2014 / 18:31:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_Win32FileSystem_setReadOnly: this _: a1

    <javanative: 'java/io/Win32FileSystem' name: 'setReadOnly(Ljava/io/File;)Z'>

    ^ self _java_io_WinNTFileSystem_setReadOnly: this _: a1

    "Modified: / 11-02-2014 / 18:31:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_canonicalize0: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'canonicalize0(Ljava/lang/String;)Ljava/lang/String;'>

    |  file |

    file := Java as_ST_String: a1.
    file := file asFilename.
    file exists ifFalse:[
        JavaVM throwIOExceptionWithMessage:'File does not exists'.
        ^nil.
    ].
    ^(Java as_String: file asAbsoluteFilename pathName)

    "Created: / 01-04-2011 / 23:00:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2013 / 06:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

_java_io_WinNTFileSystem_canonicalizeWithPrefix0: this _:a1 _: a2

    <javanative: 'java/io/WinNTFileSystem' name: 'canonicalizeWithPrefix0(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;'>

    |  path |

    path := Java as_ST_String: a2.
    ^(Java as_String: path utf8Encoded asFilename asAbsoluteFilename pathName utf8Decoded)

    "Modified: / 01-09-2011 / 21:50:47 / jv"
!

_java_io_WinNTFileSystem_checkAccess: this _:a1 _: a2

    <javanative: 'java/io/WinNTFileSystem' name: 'checkAccess(Ljava/io/File;I)Z'>

    ^ self _java_io_UnixFileSystem_checkAccess: this _:a1 _: a2

    "Modified: / 12-02-2014 / 09:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_createDirectory: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'createDirectory(Ljava/io/File;)Z'>

    ^ self _java_io_UnixFileSystem_createDirectory: this _:a1

    "Modified: / 12-02-2014 / 09:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_createFileExclusively: this _: name

    <javanative: 'java/io/WinNTFileSystem' name: 'createFileExclusively(Ljava/lang/String;)Z'>

    | path file result |

    path := Java as_ST_String: name.
    [
        file := FileStream basicNew.
        result := (file openFile: path withMode: #(GENERIC_READ_WRITE FILE_SHARE_READ FILE_SHARE_WRITE  CREATE_NEW) attributes: nil)  notNil ifTrue:[1] ifFalse:[0].
        file close.
    ] on: OpenError do:[
        result := 0.
    ].
    ^ result.

    "Modified: / 18-08-2011 / 17:26:11 / jv"
    "Modified: / 12-11-2013 / 23:52:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_createFileExclusively: this _: a1 _: a2 

    <javanative: 'java/io/WinNTFileSystem' name: 'createFileExclusively(Ljava/lang/String;Z)Z'>

    ^self _java_io_UnixFileSystem_createFileExclusively: this _: a1 _: a2

    "Modified: / 12-02-2014 / 09:59:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_delete0: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'delete0(Ljava/io/File;)Z'>

    ^ self _java_io_UnixFileSystem_delete0: this _:a1

    "Modified: / 12-02-2014 / 09:39:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_getBooleanAttributes: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'getBooleanAttributes(Ljava/io/File;)I'>

    ^ self _java_io_UnixFileSystem_getBooleanAttributes0: this _:a1

    "Created: / 01-04-2011 / 18:10:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 14:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_getDriveDirectory: this _: a1

    <javanative: 'java/io/WinNTFileSystem' name: 'getDriveDirectory(I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_WinNTFileSystem_getLastModifiedTime: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'getLastModifiedTime(Ljava/io/File;)J'>

    ^ self _java_io_UnixFileSystem_getLastModifiedTime: this _:a1

    "Modified: / 18-08-2011 / 14:12:07 / jv"
    "Modified: / 30-01-2013 / 14:17:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_getLength: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'getLength(Ljava/io/File;)J'>

    ^ self _java_io_UnixFileSystem_getLength: this _:a1

    "Modified: / 18-08-2011 / 14:15:36 / jv"
    "Modified: / 30-01-2013 / 14:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_getSpace0: this _: a1 _: a2

    <javanative: 'java/io/WinNTFileSystem' name: 'getSpace0(Ljava/io/File;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_io_WinNTFileSystem_initIDs: this

    <javanative: 'java/io/WinNTFileSystem' name: 'initIDs()V'>

    ^ self _java_io_UnixFileSystem_initIDs: this

    "Modified: / 11-02-2014 / 19:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_list: this _:a1

    <javanative: 'java/io/WinNTFileSystem' name: 'list(Ljava/io/File;)[Ljava/lang/String;'>

    ^ self _java_io_UnixFileSystem_list: this _:a1

    "Modified: / 01-09-2011 / 21:46:37 / jv"
    "Modified: / 30-01-2013 / 14:17:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_rename0: this _: a1 _: a2

    <javanative: 'java/io/WinNTFileSystem' name: 'rename0(Ljava/io/File;Ljava/io/File;)Z'>

    ^ self _java_io_UnixFileSystem_rename0: this _: a1 _: a2

    "Modified (format): / 11-02-2014 / 20:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_setLastModifiedTime: this _: a1 _: a2 _: a3 

    <javanative: 'java/io/WinNTFileSystem' name: 'setLastModifiedTime(Ljava/io/File;J)Z'>

    ^ self _java_io_UnixFileSystem_setLastModifiedTime: this _: a1 _: a2 _: a3

    "Modified: / 03-02-2014 / 09:16:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_setPermission: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/io/WinNTFileSystem' name: 'setPermission(Ljava/io/File;IZZ)Z'>

    ^ self _java_io_UnixFileSystem_setPermission: this _: a1 _: a2 _: a3 _: a4

    "Modified: / 11-02-2014 / 19:56:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_WinNTFileSystem_setReadOnly: this _: a1

    <javanative: 'java/io/WinNTFileSystem' name: 'setReadOnly(Ljava/io/File;)Z'>

    ^ self _java_io_UnixFileSystem_setReadOnly: this _: a1

    "Modified: / 11-02-2014 / 19:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.lang'!

_java_lang_ClassLoader_NativeLibrary_find: this

    <javanative: 'java/lang/ClassLoader$NativeLibrary' name: 'find(Ljava/lang/String;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_NativeLibrary_find: this _: a1

    <javanative: 'java/lang/ClassLoader$NativeLibrary' name: 'find(Ljava/lang/String;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_NativeLibrary_load: this _:a1
    <javanative: 'java/lang/ClassLoader$NativeLibrary' name: 'load(Ljava/lang/String;)V'>
    "/ introduced with jdk1.2 ... (sigh)

    | nativeLoader  jLibName  libName  libHandle  index |

    nativeLoader := this.
    jLibName := a1.
    libName := (Java as_ST_String: jLibName) asFilename baseName.
    (index := SimulatedNativeLibs indexOf: libName) ~~ 0 ifTrue: [
        "/ Do not load pkcs11.so/dll - this is not supported yet
        (libName ~= 'libj2pkcs11.so'  and:[libName ~= 'j2pkcs11.dll']) ifTrue:[
            nativeLoader instVarNamed: 'handle' put: index.
        ].
        ^ self
        "/ void
    ].
    (LoadedNativeLibs notNil and: [ LoadedNativeLibs includesKey: libName ]) ifTrue: [
        "/        ('JAVA: native library already loaded: ' , libName) printNL.
        nativeLoader instVarNamed: 'handle' put: (LoadedNativeLibs at: libName).
        ^ self
        "/ void
    ].
    (self confirm: 'permission to load native library: ' , libName , ' ?') ifFalse: [
        ^ self
    ].
    self halt.
    libName asFilename exists ifFalse: [
        ('JAVA: no file to load nativeLib: ' , libName) printNL.
        ^ self
        "/ void
    ].
    libHandle := ObjectFileLoader loadLibrary: libName.
    libHandle isNil ifTrue: [
        ('JAVA: failed to load nativeLib: ' , libName) printNL.
        ^ self
        "/ void
    ].
    LoadedNativeLibs isNil ifTrue: [ LoadedNativeLibs := Dictionary new. ].
    LoadedNativeLibs at: libName put: libHandle.
    nativeLoader instVarNamed: 'handle' put: (LoadedNativeLibs at: libName).
    ^ self
    "/ void

    "Modified: / 06-02-1998 / 03:12:17 / cg"
    "Created: / 10-12-2010 / 15:11:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2011 / 18:25:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-09-2013 / 23:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_NativeLibrary_unload: this

    <javanative: 'java/lang/ClassLoader$NativeLibrary' name: 'unload()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/ClassLoader' name: 'defineClass0(Ljava/lang/String;[BIILjava/security/ProtectionDomain;)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/lang/ClassLoader' name: 'defineClass0(Ljava/lang/String;[BIILjava/security/ProtectionDomain;)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 

    <javanative: 'java/lang/ClassLoader' name: 'defineClass0(Ljava/lang/String;[BIILjava/security/ProtectionDomain;Z)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass1: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6
    <javanative: 'java/lang/ClassLoader' name: 'defineClass1(Ljava/lang/String;[BIILjava/security/ProtectionDomain;Ljava/lang/String;)Ljava/lang/Class;'>
    "
     private native Class defineClass1(String name, byte[] b, int off, int len,
                                      ProtectionDomain pd, String source);"

    ^ self
        _java_lang_ClassLoader_defineClass1: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: 1"verify"

    "Modified: / 22-04-2014 / 22:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_defineClass1: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: verify
    <javanative: 'java/lang/ClassLoader' name: 'defineClass1(Ljava/lang/String;[BIILjava/security/ProtectionDomain;Ljava/lang/String;Z)Ljava/lang/Class;'>
    "
     private native Class defineClass1(String name, byte[] b, int off, int len,
                                      ProtectionDomain pd, String source,
                                      Boolean verify);"

    | className  b  off  len  pd bs cls |

    className := Java as_ST_String: a1.
    cls := nil.
    b := a2.
    b isNil ifTrue: [JavaVM throwNullPointerException].
    off := a3.
    len := a4.
    pd := a5.
    "/source := Java as_ST_String: a6.

    bs := (off = 0 and: [ len = b size ])
        ifTrue: [ b readStream ]
        ifFalse: [ bs := (b copyFrom: off + 1 to: off + len) readStream ].
    [
        cls := JavaClassReader readStream: bs loader: this.
    ] on: JavaClassReader invalidClassFormatSignal do: [:ex |
        JavaVM throwClassFormatError:ex description.
        ^ nil.
    ].
    "if name starts with java.* or package is signed by something else and we are not signed, throw security exception"
    "ClassLoadersTest>>testEyeOpeningClassLoaderLoadObject"
    "18.11. mh revised - they really test it against java., totally ignoring boot class path.. That surpsised me"
    (cls binaryName startsWith: 'java/') ifTrue: [
        JavaVM throwSecurityExceptionWith:'className=' , cls name
    ].
    self assert: cls classLoader == this.
     "FIXME: What to do with source?"
    ClassRegistry registerClass: cls.
    "JavaClassReader classLoaderQuerySignal answer: nativeContext receiver
        do: [ cls resolveAll. ]."
    ^ Reflection javaClassObjectForClass: cls.

    "Modified: / 08-12-2011 / 20:56:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 10-09-2012 / 22:21:22 / m"
    "Modified: / 22-04-2014 / 22:32:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_defineClass2: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/lang/ClassLoader' name: 'defineClass2(Ljava/lang/String;Ljava/nio/ByteBuffer;IILjava/security/ProtectionDomain;Ljava/lang/String;)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass2: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/lang/ClassLoader' name: 'defineClass2(Ljava/lang/String;Ljava/nio/ByteBuffer;IILjava/security/ProtectionDomain;Ljava/lang/String;)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass2: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 

    <javanative: 'java/lang/ClassLoader' name: 'defineClass2(Ljava/lang/String;Ljava/nio/ByteBuffer;IILjava/security/ProtectionDomain;Ljava/lang/String;Z)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_findBootstrapClass: this _:a1
    <javanative: 'java/lang/ClassLoader' name: 'findBootstrapClass(Ljava/lang/String;)Ljava/lang/Class;'>
    "Return class loaded by bootstrap (primordial) classloader or null.
     See OpenJDK, file src/jdk7/hostspot/src/share/vm/prims/jvm.cpp"

    | nm  class |
    nm := Java as_ST_String: a1.
    class := ClassRegistry
                classForName: nm asSlashedJavaClassName
                loader: nil
                ifAbsentPut: [ class := JavaVM loadClassNamed: nm usingClassLoader: nil ].

    ^ class notNil
        ifTrue: [ Reflection javaClassObjectForClass: class ]
        ifFalse: [ JavaVM throwClassNotFoundException:nm ].

    "Modified: / 02-11-2011 / 20:13:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-09-2013 / 23:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_findLoadedClass0: this _:a1

    <javanative: 'java/lang/ClassLoader' name: 'findLoadedClass0(Ljava/lang/String;)Ljava/lang/Class;'>

    "
    Return java class object for class with given name
    loaded by the receiver or null if not found.
    See OpenJDK:
        src/jdk7/hostspot/src/share/vm/classfile/systemDictionary.cpp
        src/jdk7/hostspot/src/share/vm/prims/jvm.cpp

    "
    | nm class |
    nm := Java as_ST_String: a1.
    class := ClassRegistry classNamed: nm asSlashedJavaClassName loader: this.

    ^class notNil ifTrue: [
        Reflection javaClassObjectForClass:class
    ] ifFalse:[
        nil
    ]

    "Modified: / 30-10-2011 / 21:48:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_registerNatives: this

    <javanative: 'java/lang/ClassLoader' name: 'registerNatives()V'>


    "Nothing to do"

    "Created: / 09-11-2010 / 20:55:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_resolveClass0: this _:a1
    <javanative: 'java/lang/ClassLoader' name: 'resolveClass0(Ljava/lang/Class;)V'>
    "resolve a new class as previously created by defineClass0"
    "or to be more precise - link class"

    | jClassLoader  jCls  cls |
    jClassLoader := this.
    jCls := a1.
    jCls isNil ifTrue: [
        JavaVM throwNullPointerException.
        ^ nil
    ].
    cls := Reflection classForJavaClassObject: jCls.
    self assert: cls notNil.
    JavaClassReader classLoaderQuerySignal answer: jClassLoader
     do: [ "cls resolveAll." ].
    ^ cls.

    "
        Links the specified class.  This (misleadingly named) method may be
        * used by a class loader to link a class.  If the class <tt>c</tt> has
        * already been linked, then this method simply returns. Otherwise, the
        * class is linked as described in the Execution chapter of the <a
        * href=http://java.sun.com/docs/books/jls/>Java Language
        * Specification</a>.
        * </p>
        *
        * @param  c
        *         The class to link
        *
        * @throws  NullPointerException
         *          If <tt>c</tt> is <tt>null</tt>."

    "Created: / 07-01-1998 / 13:12:27 / cg"
    "Modified: / 20-10-1998 / 19:01:57 / cg"
    "Modified: / 28-01-2011 / 15:28:18 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-12-2011 / 20:52:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-12-2011 / 14:12:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ClassLoader_retrieveDirectives: this

    <javanative: 'java/lang/ClassLoader' name: 'retrieveDirectives()Ljava/lang/AssertionStatusDirectives;'>

    | directives |
    directives := (JavaVM classForName:'java.lang.AssertionStatusDirectives' definedBy:nil) new.
    directives instVarNamed:#classes
        put: ((JavaVM classForName:'java.lang.String' definedBy:nil) javaArrayClass new:0).
    directives instVarNamed:#classEnabled
        put: (Boolean javaArrayClass new:0).
    directives instVarNamed:#packages
        put: ((JavaVM classForName:'java.lang.String' definedBy:nil) javaArrayClass new:0).
    directives instVarNamed:#packageEnabled
        put: (Boolean javaArrayClass new:0).
    directives instVarNamed:#deflt
        put: ((AssertionsEnabled == true) ifTrue:[1] ifFalse:[0]).
    ^directives

    "Modified: / 06-07-2012 / 08:49:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_desiredAssertionStatus0: this _:a1

    <javanative: 'java/lang/Class' name: 'desiredAssertionStatus0(Ljava/lang/Class;)Z'>


    ^AssertionsEnabled == true

    "Created: / 24-11-2010 / 08:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_forName0: this _: classname _: initialize _: loader
    <javanative: 'java/lang/Class' name: 'forName0(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;'>

    | nm nmAsJavaString dim class classObject  |

    nmAsJavaString := classname.
    nm := Java as_ST_String:classname.
    "/ Using Class.forName() to get a primitive type is not allowed"
    (nm size == 1 and:[JavaDescriptor baseTypes includesKey:nm first]) ifTrue:[
        ^ JavaVM throwClassNotFoundException:nm.
    ].
    (JavaDescriptor baseTypesByTypeName includesKey:nm) ifTrue:[
        ^ JavaVM throwClassNotFoundException:nm.
    ].

    "/ Could be array type, check and compute dimension\
    dim := 0.
    [ dim < nm size and:[(nm at: dim + 1) == $[] ] whileTrue:[ dim := dim + 1 ].
    "/ Check for malformed class name (like "[[[")
    dim = nm size ifTrue:[
        JavaVM throwClassNotFoundException:nm.
        ^ nil
    ].
    dim > 0 ifTrue:[
        (nm at: dim + 1) == $L ifTrue:[
            "/ Reference type array...
            nm last ~~ $; ifTrue:[
                JavaVM throwClassNotFoundException:nm.
                ^ nil
            ].
            (dim + 2) >= (nm size - 1) ifTrue:[
                JavaVM throwClassNotFoundException:nm.
                ^ nil
            ].
            nm := nm copyFrom: dim + 2 to: nm size - 1.
            nmAsJavaString := Java as_String: nm.
        ] ifFalse:[
            "/ Primitive type array
            nm size ~~ (dim + 1) ifTrue:[
                JavaVM throwClassNotFoundException:nm.
                ^ nil
            ].
            class := JavaDescriptor baseTypes at: nm last ifAbsent:[
                JavaVM throwClassNotFoundException:nm.
                ^ nil
            ].
            dim timesRepeat: [ class := class javaArrayClass ].
            ^ JavaVM javaClassObjectForClass:class.
        ].
    ].

    loader isNil ifTrue:[
        "/OK. return class loaded by primordial class loader

        class :=  JavaVM classForName: nm definedBy: nil.
        class isNil ifTrue:[ ^ JavaVM throwClassNotFoundException:nm ].
        ((initialize ~~ 0)
            and:[class isJavaArrayClass not
            and:[class isJavaPrimitiveType not]])
            ifTrue:[
                "/JV: Should be removed/rewieved once bug #47 is closed.
                [ class classInit ] on: Error do:[ self throwExceptionInInitializerError:nm ]
            ].
        dim timesRepeat: [ class := class javaArrayClass ].
        classObject := JavaVM javaClassObjectForClass:class.
    ] ifFalse:[
        "/ Custom class loader, call loadClass(String, boolean)...
        classObject :=  loader
                            perform:#'loadClass(Ljava/lang/String;Z)Ljava/lang/Class;'
                            with: nmAsJavaString
                            with: initialize.
        dim > 0 ifTrue:[
            class := JavaVM classForJavaClassObject:classObject.
            dim timesRepeat: [ class := class javaArrayClass ].
            classObject := JavaVM javaClassObjectForClass:class.
        ].
    ].
    ^ classObject

    "Created: / 24-11-2010 / 09:03:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2011 / 19:12:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-11-2013 / 23:02:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_forName0: this _: classname _: initialize _: loader _: caller

    <javanative: 'java/lang/Class' name: 'forName0(Ljava/lang/String;ZLjava/lang/ClassLoader;Ljava/lang/Class;)Ljava/lang/Class;'>

    ^ self _java_lang_Class_forName0: this _: classname _: initialize _: loader

    "Modified: / 04-11-2014 / 09:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getClassLoader0: this

    <javanative: 'java/lang/Class' name: 'getClassLoader0()Ljava/lang/ClassLoader;'>

    "get a classes loader"

    | jClass cls cl|

    jClass := this.
    cls := Reflection classForJavaClassObject:jClass.
    cl := cls javaMirror getClassLoader.
    ^ cl

    "Created: / 19-01-2013 / 23:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2015 / 15:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getComponentType: this

    <javanative: 'java/lang/Class' name: 'getComponentType()Ljava/lang/Class;'>

        |cls|

    cls := Reflection classForJavaClassObject:this.
    cls isJavaArrayClass ifTrue:[
        ^ Reflection javaClassObjectForClass:cls javaComponentClass
    ].
    ^ nil

    "Created: / 12-11-1998 / 18:54:46 / cg"
    "Modified: / 28-01-2011 / 15:18:59 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-11-2013 / 23:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getConstantPool: this

    <javanative: 'java/lang/Class' name: 'getConstantPool()Lsun/reflect/ConstantPool;'>

        | class |

    class := Reflection classForJavaClassObject: this.
    class isJavaClass ifFalse:[
        ^nil
    ].

    ^ Reflection javaConstantPoolObjectFor:class constantPool.

    "Created: / 21-12-2010 / 20:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2011 / 18:05:13 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 31-07-2012 / 00:47:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaredClasses0: this

    <javanative: 'java/lang/Class' name: 'getDeclaredClasses0()[Ljava/lang/Class;'>

    | class inners |
    class := Reflection classForJavaClassObject: this.
    inners := class innerClasses.
    ^inners collect: [:cls | Reflection javaClassObjectForClass: cls] as: (Java at: 'java.lang.Class') javaArrayClass

    "Created: / 19-01-2013 / 23:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 17:00:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaredConstructors0: this _:a1
    <javanative: 'java/lang/Class' name: 'getDeclaredConstructors0(Z)[Ljava/lang/reflect/Constructor;'>

    | class publicOnly |

    class := Reflection classForJavaClassObject:this.
    publicOnly := a1 == 1.
    ^class javaMirror getDeclaredConstructors: publicOnly.

    "Created: / 24-11-2010 / 09:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:24:03 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (format): / 01-08-2012 / 11:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaredFields0: this _:a1
    <javanative: 'java/lang/Class' name: 'getDeclaredFields0(Z)[Ljava/lang/reflect/Field;'>
    |class fields publicOnly|

    class := Reflection
                classForJavaClassObject:(this).
    (class isJavaPrimitiveType or:[class isJavaArrayClass]) ifTrue:[
        ^(JavaVM classForName:'java.lang.reflect.Field' definedBy:nil) javaArrayClass new:0.
    ].

    publicOnly := a1 == 1.
    fields := class javaMirror getDeclaredFields: publicOnly.
    ^fields

    "Created: / 10-11-2010 / 16:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:19:06 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 30-01-2013 / 14:15:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaredMethods0: this _:a1
    <javanative: 'java/lang/Class' name: 'getDeclaredMethods0(Z)[Ljava/lang/reflect/Method;'>

    | class publicOnly |

    class := Reflection classForJavaClassObject:this.
    publicOnly := a1 == 1.
    ^class javaMirror getDeclaredMethods: publicOnly.

    "Created: / 21-12-2010 / 22:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:19:09 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-06-2011 / 17:07:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-08-2012 / 11:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaringClass0: this
    <javanative: 'java/lang/Class' name: 'getDeclaringClass0()Ljava/lang/Class;'>
    "
     /**
     * If the class or interface represented by this {@code Class} object
     * is a member of another class, returns the {@code Class} object
     * representing the class in which it was declared.  This method returns
     * null if this class or interface is not a member of any other class.  If
     * this {@code Class} object represents an array class, a primitive
     * type, or void,then this method returns null.
     *
     * @return the declaring class for this class
     * @since JDK1.1
     */"

    | cls declaringClass |

    cls := Reflection classForJavaClassObject: this.
    (cls isJavaPrimitiveType or: [ cls isJavaArrayClass ]) ifTrue: [ ^ nil ].
    declaringClass := cls declaringClass.
    declaringClass notNil ifTrue:[
        ^ Reflection javaClassObjectForClass: declaringClass
    ].
    ^ nil

    "Modified: / 04-08-2014 / 22:54:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getDeclaringClass: this
    <javanative: 'java/lang/Class' name: 'getDeclaringClass()Ljava/lang/Class;'>

    ^ self _java_lang_Class_getDeclaringClass0: this

    "Modified: / 04-08-2014 / 22:39:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getEnclosingMethod0: this

    <javanative: 'java/lang/Class' name: 'getEnclosingMethod0()[Ljava/lang/Object;'>

    "Returns an Object[3]:
        info[0] =  enclosing class as Class
        ifno[1] = enclosing method name as String
        info[2] = enclosing method descriptor as String

    or nil if there's no enclosing method attribute.
    "

    | cls attr info|

    info := nil.
    cls := JavaVM reflection classForJavaClassObject: this.
    cls isJavaPrimitiveType ifTrue:[^nil].
    attr := cls getAttribute: #EnclosingMethod.
    attr notNil ifTrue:[ 
        info := _java_lang_Object_CLASS javaArrayClass new: 3.
        info at: 1 put: (JavaVM reflection javaClassObjectForClass: ((cls constantPool at: attr first) resolve: false)).
        attr second ~~ 0 ifTrue:[ 
            info at: 2 put: (Java as_String: (cls constantPool at: attr second) name).
            info at: 3 put: (Java as_String: (cls constantPool at: attr second) descriptor).
        ].
    ].
    ^ info.

    "Modified: / 07-04-2016 / 16:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getGenericSignature: this

    <javanative: 'java/lang/Class' name: 'getGenericSignature()Ljava/lang/String;'>

    |cls sig |

    cls := Reflection classForJavaClassObject:this.
    sig := cls javaMirror getGenericSignature.
    ^sig notNil ifTrue:[
        Java as_String: sig
    ] ifFalse:[
        nil
    ]

    "Modified: / 22-08-2012 / 11:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getInterfaces: this
    <javanative: 'java/lang/Class' name: 'getInterfaces()[Ljava/lang/Class;'>
    |jClass cls interfaces jInterfaces|

    jClass := this.
    cls := Reflection classForJavaClassObject:jClass.
    interfaces := cls javaMirror getInterfaces.
    jInterfaces := _java_lang_Class_CLASS javaArrayClass new:interfaces size.
    interfaces
        withIndexDo:[:iface :idx | jInterfaces at:idx put:(Reflection javaClassObjectForClass:iface) ].
    ^ jInterfaces

    "Modified: / 28-01-2011 / 15:19:11 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 21-05-2013 / 16:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getModifiers: this
    <javanative: 'java/lang/Class' name: 'getModifiers()I'>
    | cls |

    cls := (Reflection classForJavaClassObject: this).
    ^cls javaMirror getModifiers

    "Created: / 12-11-1998 / 18:54:53 / cg"
    "Modified: / 28-01-2011 / 15:19:14 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 22-08-2012 / 11:04:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getName0: this

    <javanative: 'java/lang/Class' name: 'getName0()Ljava/lang/String;'>

    |class|

    class := this.
    class := Reflection classForJavaClassObject: this.
    ^ Reflection
        javaStringObjectForString:class javaMirror getName
        interned:true.

    "Modified: / 19-01-2013 / 23:48:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getPrimitiveClass: this _:a1

    <javanative: 'java/lang/Class' name: 'getPrimitiveClass(Ljava/lang/String;)Ljava/lang/Class;'>

        "get a primitive class by name"

    |jClassName className|

    jClassName := a1.
    className := Java as_ST_String:jClassName.
    (JavaDescriptor baseTypesByTypeName keys includes: className)
        ifFalse:[JavaVM throwClassNotFoundException:className].
    ^Reflection javaClassObjectForClassNamed: className

    "Created: / 04-01-1998 / 00:46:03 / cg"
    "Modified: / 28-01-2011 / 15:30:45 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-02-2011 / 21:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getProtectionDomain0: this

    <javanative: 'java/lang/Class' name: 'getProtectionDomain0()Ljava/security/ProtectionDomain;'>

    ^(Reflection classForJavaClassObject: this) javaMirror getProtectionDomain

    "Modified: / 22-08-2012 / 12:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getRawAnnotations: this

    <javanative: 'java/lang/Class' name: 'getRawAnnotations()[B'>

    |class |

    class := Reflection classForJavaClassObject: this.
    class isJavaArrayClass ifTrue:[
        ^nil
    ].
    class isJavaPrimitiveType ifTrue:[
        ^nil
    ].
    class isJavaClass ifFalse:[
        ^nil.
    ].
    ^ class runtimeVisibleAnnotationsAsBytesOrNil

    "Created: / 21-12-2010 / 19:35:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:19:20 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 31-07-2012 / 00:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getSigners: this

    <javanative: 'java/lang/Class' name: 'getSigners()[Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Class_getSuperclass: this
    <javanative: 'java/lang/Class' name: 'getSuperclass()Ljava/lang/Class;'>
    "return a classes superclass"

    | jClass  cls  superCls |

    jClass := this.
    cls := Reflection classForJavaClassObject: jClass.

    cls isJavaPrimitiveType ifTrue: [ ^ nil ].
    cls isJavaArrayClass ifTrue: [
        ^ Reflection javaClassObjectForClass:(Java at:'java.lang.Object')
    ].
    cls == Object ifTrue: [
        ^ Reflection javaClassObjectForClass:(Java at:'java.lang.Object')
    ].
    cls isInterface ifTrue: [ ^ nil ].
    superCls := cls superclass.
    superCls == JavaObject ifTrue: [ ^ nil. ].
    superCls ==     Object ifTrue: [ ^ nil ]. "/for Java
    ^ Reflection javaClassObjectForClass:superCls

    "Created: / 12-01-1998 / 12:38:36 / cg"
    "Modified: / 04-02-1998 / 14:51:22 / cg"
    "Modified: / 28-01-2011 / 14:12:47 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 31-07-2012 / 00:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_isArray: this

    <javanative: 'java/lang/Class' name: 'isArray()Z'>

        ^ (Reflection classForJavaClassObject: this) isJavaArrayClass
        ifTrue:[1]
        ifFalse:[0]

    "Created: / 12-11-1998 / 18:54:24 / cg"
    "Modified: / 20-12-2010 / 23:20:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:19:24 / Marcel Hlopko <hlopik@gmail.com>"
!

_java_lang_Class_isAssignableFrom:this _:a1 
    <javanative: 'java/lang/Class' name: 'isAssignableFrom(Ljava/lang/Class;)Z'>
    "
/**
 * Determines if the class or interface represented by this
 * {@code Class} object is either the same as, or is a superclass or
 * superinterface of, the class or interface represented by the specified
 * {@code Class} parameter. It returns {@code true} if so;
 * otherwise it returns {@code false}. If this {@code Class}
 * object represents a primitive type, this method returns
 * {@code true} if the specified {@code Class} parameter is
 * exactly this {@code Class} object; otherwise it returns
 * {@code false}.
 *
 * <p> Specifically, this method tests whether the type represented by the
 * specified {@code Class} parameter can be converted to the type
 * represented by this {@code Class} object via an identity conversion
 * or via a widening reference conversion. See <em>The Java Language
 * Specification</em>, sections 5.1.1 and 5.1.4 , for details.
 *
 * @param cls the {@code Class} object to be checked
 * @return the {@code boolean} value indicating whether objects of the
 * type {@code cls} can be assigned to objects of this class
 * @exception NullPointerException if the specified Class parameter is
 *            null.
 * @since JDK1.1
 */"
    
    | clsObj  me  other |

    clsObj := a1.
    clsObj isNil ifTrue:[
        ^ JavaVM throwNullPointerException
    ].
    me := Reflection classForJavaClassObject:this.
    other := Reflection classForJavaClassObject:clsObj.
    
    "/    Determines if the class or interface represented by this
    "/    @code Class} object is either the same as, or is a superclass or
    "/    superinterface of, the class or interface represented by the specified
    "/    {@code Class} parameter.
    
    ^ (other includesBehavior:me) ifTrue:[ 1 ] ifFalse:[ 0 ]

    "Created: / 12-11-1998 / 18:54:16 / cg"
    "Modified: / 04-08-2014 / 15:55:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_isInstance: this _:a1

    <javanative: 'java/lang/Class' name: 'isInstance(Ljava/lang/Object;)Z'>

        "
    /**
     * Determines if the specified {@code Object} is assignment-compatible
     * with the object represented by this {@code Class}.  This method is
     * the dynamic equivalent of the Java language {@code instanceof}
     * operator. The method returns {@code true} if the specified
     * {@code Object} argument is non-null and can be cast to the
     * reference type represented by this {@code Class} object without
     * raising a {@code ClassCastException.} It returns {@code false}
     * otherwise.
     *
     * <p> Specifically, if this {@code Class} object represents a
     * declared class, this method returns {@code true} if the specified
     * {@code Object} argument is an instance of the represented class (or
     * of any of its subclasses); it returns {@code false} otherwise. If
     * this {@code Class} object represents an array class, this method
     * returns {@code true} if the specified {@code Object} argument
     * can be converted to an object of the array class by an identity
     * conversion or by a widening reference conversion; it returns
     * {@code false} otherwise. If this {@code Class} object
     * represents an interface, this method returns {@code true} if the
     * class or any superclass of the specified {@code Object} argument
     * implements this interface; it returns {@code false} otherwise. If
     * this {@code Class} object represents a primitive type, this method
     * returns {@code false}.
     *
     * @param   obj the object to check
     * @return  true if {@code obj} is an instance of this class
     *
     * @since JDK1.1
     */
    public native boolean isInstance(Object obj);
    "

    |jClass cls obj|

    obj := a1.
    obj isNil ifTrue:[^ 0].
    jClass := this.
    cls := Reflection classForJavaClassObject:jClass.
    ^JavaVM _INSTANCEOF:obj _:cls

    "Modified: / 09-02-1998 / 14:56:23 / cg"
    "Modified: / 28-01-2011 / 14:12:42 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 16-01-2013 / 19:46:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_isInterface: this

    <javanative: 'java/lang/Class' name: 'isInterface()Z'>

        "return true, if this class is an interface"

    |jClass cls|

    jClass := this.
    cls := Reflection classForJavaClassObject:jClass.
    cls isJavaClass ifFalse:[
        ^ 0
    ].
    cls isInterface ifTrue:[
        ^ 1 "TRUE"
    ].
    ^ 0 "FALSE"

    "Created: / 12-01-1998 / 12:37:02 / cg"
    "Modified: / 28-01-2011 / 14:12:35 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-02-2011 / 21:50:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_isPrimitive: this

    <javanative: 'java/lang/Class' name: 'isPrimitive()Z'>

        "return true, if this class is builtin primitive class
     (i.e. byteArray, array, string etc."

    |jClass cls|

    jClass := this.
    cls := Reflection classForJavaClassObject:jClass.
    ^cls isJavaPrimitiveType
        ifTrue:[1"true"]
        ifFalse:[0"false"].

    "Created: / 09-02-1998 / 14:46:07 / cg"
    "Modified: / 28-01-2011 / 14:12:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-02-2011 / 11:56:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_registerNatives: this

    <javanative: 'java/lang/Class' name: 'registerNatives()V'>

     "Nothing to do, native method are bound lazily"

    "Created: / 20-10-2010 / 11:13:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2013 / 20:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_setProtectionDomain0: this _: a1

    <javanative: 'java/lang/Class' name: 'setProtectionDomain0(Ljava/security/ProtectionDomain;)V'>

    (Reflection classForJavaClassObject: this) protectionDomain: a1.
    ^a1

    "Created: / 21-01-2013 / 17:27:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2013 / 09:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_setSigners: this

    <javanative: 'java/lang/Class' name: 'setSigners([Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Class_setSigners: this _: a1

    <javanative: 'java/lang/Class' name: 'setSigners([Ljava/lang/Object;)V'>

    "Nothing to do now"

    "Modified: / 02-09-2013 / 00:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Compiler_command: this _: a1

    <javanative: 'java/lang/Compiler' name: 'command(Ljava/lang/Object;)Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Compiler_compileClass: this _: a1

    <javanative: 'java/lang/Compiler' name: 'compileClass(Ljava/lang/Class;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Compiler_compileClasses: this _: a1

    <javanative: 'java/lang/Compiler' name: 'compileClasses(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Compiler_disable: this

    <javanative: 'java/lang/Compiler' name: 'disable()V'>

    "Modified: / 09-02-2012 / 22:56:44 / mh <hlopik@gmail.com>"
!

_java_lang_Compiler_enable: this

    <javanative: 'java/lang/Compiler' name: 'enable()V'>

    "Modified: / 09-02-2012 / 22:57:15 / mh <hlopik@gmail.com>"
!

_java_lang_Compiler_initialize: this

    <javanative: 'java/lang/Compiler' name: 'initialize()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Compiler_registerNatives: this

    <javanative: 'java/lang/Compiler' name: 'registerNatives()V'>

    "Modified: / 09-02-2012 / 22:56:37 / mh <hlopik@gmail.com>"
!

_java_lang_Double_doubleToRawLongBits: this _: d _: ignored

    <javanative: 'java/lang/Double' name: 'doubleToRawLongBits(D)J'>

        "
    /**
     * Returns a representation of the specified floating-point value
     * according to the IEEE 754 floating-point 'double
     * format' bit layout, preserving Not-a-Number (NaN) values.
     *
     * <p>Bit 63 (the bit that is selected by the mask
     * {@code 0x8000000000000000L}) represents the sign of the
     * floating-point number. Bits
     * 62-52 (the bits that are selected by the mask
     * {@code 0x7ff0000000000000L}) represent the exponent. Bits 51-0
     * (the bits that are selected by the mask
     * {@code 0x000fffffffffffffL}) represent the significand
     * (sometimes called the mantissa) of the floating-point number.
     *
     * <p>If the argument is positive infinity, the result is
     * {@code 0x7ff0000000000000L}.
     *
     * <p>If the argument is negative infinity, the result is
     * {@code 0xfff0000000000000L}.
     *
     * <p>If the argument is NaN, the result is the {@code long}
     * integer representing the actual NaN value.  Unlike the
     * {@code doubleToLongBits} method,
     * {@code doubleToRawLongBits} does not collapse all the bit
     * patterns encoding a NaN to a single 'canonical' NaN
     * value.
     *
     * <p>In all cases, the result is a {@code long} integer that,
     * when given to the {@link #longBitsToDouble(long)} method, will
     * produce a floating-point value the same as the argument to
     * {@code doubleToRawLongBits}.
     *
     * @param   value   a {@code double} precision floating-point number.
     * @return the bits that represent the floating-point number.
     * @since 1.3
     */
    "
"/      | b |
"/
"/    (d =  0.0) ifTrue:[^0].
"/    (d = -0.0) ifTrue:[^(1 bitShift: 63)].
"/
"/    b := ByteArray streamContents:[:s|Float storeBinaryIEEEDouble:d on:s MSB: UninterpretedBytes isBigEndian].
"/    ^ LargeInteger digitBytes: b MSB: UninterpretedBytes isBigEndian.


"/    d class == Float ifFalse:[ ^self throwIllegalArgumentException: 'Not a double'].
%{
    union {
        double dbl;
        __int64__ l;
    } u;
    u.dbl = __floatVal(d);
    RETURN ( __MKINT64( &(u.l) ) );
%}.
    self primitiveFailed.

    "Created: / 10-11-2010 / 14:48:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 00:09:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

_java_lang_Double_longBitsToDouble: this _:i _: a2

    <javanative: 'java/lang/Double' name: 'longBitsToDouble(J)D'>

"/    | aFloat|
"/
"/    aFloat := Float new.
"/    UninterpretedBytes isBigEndian ifTrue:[
"/        aFloat basicAt:1 put:((i bitShift:-56) bitAnd:16rFF).
"/        aFloat basicAt:2 put:((i bitShift:-48) bitAnd:16rFF).
"/        aFloat basicAt:3 put:((i bitShift:-40) bitAnd:16rFF).
"/        aFloat basicAt:4 put:((i bitShift:-32) bitAnd:16rFF).
"/        aFloat basicAt:5 put:((i bitShift:-24) bitAnd:16rFF).
"/        aFloat basicAt:6 put:((i bitShift:-16) bitAnd:16rFF).
"/        aFloat basicAt:7 put:((i bitShift:-8) bitAnd:16rFF).
"/        aFloat basicAt:8 put:(i bitAnd:16rFF).
"/    ] ifFalse:[
"/        aFloat basicAt:1 put:(i bitAnd:16rFF).
"/        aFloat basicAt:2 put:((i bitShift:-8) bitAnd:16rFF).
"/        aFloat basicAt:3 put:((i bitShift:-16) bitAnd:16rFF).
"/        aFloat basicAt:4 put:((i bitShift:-24) bitAnd:16rFF).
"/        aFloat basicAt:5 put:((i bitShift:-32) bitAnd:16rFF).
"/        aFloat basicAt:6 put:((i bitShift:-40) bitAnd:16rFF).
"/        aFloat basicAt:7 put:((i bitShift:-48) bitAnd:16rFF).
"/        aFloat basicAt:8 put:((i bitShift:-56) bitAnd:16rFF).
"/    ].
"/
"/    ^ aFloat.


    | f |

    f := Float new.
%{
    union {
        double dbl;
        __int64__ l;
    } u;
    __signedLong64IntVal(i, &(u.l));
    __floatVal(f) = u.dbl;
%}.
    ^f

    "Modified: / 14-11-2013 / 20:05:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Float_floatToRawIntBits: this _:f

    <javanative: 'java/lang/Float' name: 'floatToRawIntBits(F)I'>

        "
    /**
     * Returns a representation of the specified floating-point value
     * according to the IEEE 754 floating-point 'single format' bit
     * layout, preserving Not-a-Number (NaN) values.
     *
     * <p>Bit 31 (the bit that is selected by the mask
     * {@code 0x80000000}) represents the sign of the floating-point
     * number.
     * Bits 30-23 (the bits that are selected by the mask
     * {@code 0x7f800000}) represent the exponent.
     * Bits 22-0 (the bits that are selected by the mask
     * {@code 0x007fffff}) represent the significand (sometimes called
     * the mantissa) of the floating-point number.
     *
     * <p>If the argument is positive infinity, the result is
     * {@code 0x7f800000}.
     *
     * <p>If the argument is negative infinity, the result is
     * {@code 0xff800000}.
     *
     * <p>If the argument is NaN, the result is the integer representing
     * the actual NaN value.  Unlike the {@code floatToIntBits}
     * method, {@code floatToRawIntBits} does not collapse all the
     * bit patterns encoding a NaN to a single 'canonical'
     * NaN value.
     *
     * <p>In all cases, the result is an integer that, when given to the
     * {@link #intBitsToFloat(int)} method, will produce a
     * floating-point value the same as the argument to
     * {@code floatToRawIntBits}.
     *
     * @param   value   a floating-point number.
     * @return the bits that represent the floating-point number.
     * @since 1.3
     */
    "
%{
    union {
        float flt;
        int i;
    } u;
    u.flt = __shortFloatVal(f);
    RETURN ( __MKINT( u.i ) );
%}.
    self primitiveFailed.

    "Created: / 09-11-2010 / 20:59:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 23:11:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Float_intBitsToFloat: this _: ii

    <javanative: 'java/lang/Float' name: 'intBitsToFloat(I)F'>

    | ff |

    ff := ShortFloat new.
%{
    union {
        float flt;
        int i;
    } u;
    u.i = __signedLongIntVal(ii);
    __shortFloatVal(ff) = u.flt;
%}.
    ^ff

    "Modified: / 14-11-2013 / 23:07:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Object_clone: this

    <javanative: 'java/lang/Object' name: 'clone()Ljava/lang/Object;'>

    "clone an object"

    | cls |

    cls := this class.
    cls isCloneable == false ifTrue:[
        JavaVM throwCloneNotSupportedException.
        ^ nil.
    ].
    ^ this shallowCopy.

    "Created: / 04-01-1998 / 19:39:26 / cg"
    "Modified: / 12-11-2013 / 02:03:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Object_getClass: this
    <javanative: 'java/lang/Object' name: 'getClass()Ljava/lang/Class;'>
    "return an objects class"

    | o  cls  jClass |

    o := this.
    cls := o class.
    jClass := Reflection javaClassObjectForClass:cls.
    ^ jClass

    "Created: / 6.1.1998 / 18:28:27 / cg"
    "Modified: / 23.1.1998 / 17:48:22 / cg"
!

_java_lang_Object_hashCode: this

    <javanative: 'java/lang/Object' name: 'hashCode()I'>

        "identityHash"

    |o rslt|

    o := this.
    rslt := o identityHash.
    ^ rslt

    "Created: / 4.1.1998 / 19:40:26 / cg"
!

_java_lang_Object_notify: this
    <javanative: 'java/lang/Object' name: 'notify()V'>

    this isNil ifTrue:[ 
        ^ JavaVM throwNullPointerException:'Attempt to notify() a null reference'.
    ].
    (this getJavaMonitor notify:false) ifFalse:[ 
        ^ JavaVM throwIllegalMonitorStateException: 'Attempt to notify() a lock not acquired by the calling thread'
    ].

    "Created: / 06-01-1998 / 21:09:26 / cg"
    "Modified: / 22-11-2011 / 13:24:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Object_notifyAll: this
    <javanative: 'java/lang/Object' name: 'notifyAll()V'>

    this isNil ifTrue:[ 
        ^ JavaVM throwNullPointerException:'Attempt to notifyAll() a null reference'.
    ].
    (this getJavaMonitor notify: true) ifFalse:[ 
        ^ JavaVM throwIllegalMonitorStateException: 'Attempt to notifyAll() a lock not acquired by the calling thread'
    ].

    "Created: / 03-01-1998 / 03:06:56 / cg"
    "Modified: / 22-11-2011 / 13:27:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Object_registerNatives: this

    <javanative: 'java/lang/Object' name: 'registerNatives()V'>
    "Nothing to do, native method are bound lazily"

    "Created: / 19-10-2010 / 12:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2013 / 20:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Object_wait: this _: millis _: dummy
    <javanative: 'java/lang/Object' name: 'wait(J)V'>

    millis < 0 ifTrue:[
        JavaVM throwIllegalArgumentException:'Negative millis'
    ].
    this isNil ifTrue:[ 
        ^ JavaVM throwNullPointerException:'Attempt to wait() on a null reference'.
    ].
    (this getJavaMonitor waitForMilliseconds:millis) ifFalse:[ 
        ^ JavaVM throwIllegalMonitorStateException: 'Attempt to wait() on a lock not acquired by the calling thread'
    ].

    "Modified: / 30-12-1998 / 19:20:43 / cg"
    "Modified: / 22-11-2011 / 13:17:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:58:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Package_getSystemPackage0: this _:a1

    <javanative: 'java/lang/Package' name: 'getSystemPackage0(Ljava/lang/String;)Ljava/lang/String;'>

    "Based on code on OpenJDK, it is ok to return nil here:"

    | syspkg syspkg_s |
    syspkg := a1.
    syspkg isNil ifTrue:[ ^ nil ].
    syspkg_s := Java as_ST_String: syspkg.
    ^(ClassRegistry systemPackage: syspkg_s) notNil ifTrue:[
        syspkg
    ] ifFalse:[
        nil
    ].

    "Modified: / 16-08-2012 / 17:45:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Package_getSystemPackages0: this

    <javanative: 'java/lang/Package' name: 'getSystemPackages0()[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessEnvironment_environ: this

    <javanative: 'java/lang/ProcessEnvironment' name: 'environ()[[B'>

    | env jenv i|
    env := OperatingSystem getEnvironment.
    jenv :=  ByteArray javaArrayClass new: env size * 2.
    i := 1.
    env keysAndValuesDo:
        [:name :value|
        jenv
            at: i   put: name  asByteArray;
            at: i+1 put: value asByteArray.
        i := i + 2].
    ^jenv

    "Modified: / 25-06-2011 / 08:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_ProcessEnvironment_environmentBlock: this

    <javanative: 'java/lang/ProcessEnvironment' name: 'environmentBlock()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_availableProcessors: this

    <javanative: 'java/lang/Runtime' name: 'availableProcessors()I'>
    "
    /**
     * Returns the number of processors available to the Java virtual machine.
     *
     * <p> This value may change during a particular invocation of the virtual
     * machine.  Applications that are sensitive to the number of available
     * processors should therefore occasionally poll this property and adjust
     * their resource usage appropriately. </p>
     *
     * @return  the maximum number of processors available to the virtual
     *          machine; never smaller than one
     * @since 1.4
     */
    "

    ^ 1 "/ Since Smalltalk/X is single-thread application

    "Modified: / 03-09-2012 / 18:53:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Runtime_freeMemory: this

    <javanative: 'java/lang/Runtime' name: 'freeMemory()J'>

        "free memory - Returns the number of free bytes"

    ^ ObjectMemory freeListSpace + ObjectMemory freeSpace

    "Created: / 12.1.1998 / 12:59:53 / cg"
!

_java_lang_Runtime_gc: this

    <javanative: 'java/lang/Runtime' name: 'gc()V'>

        "Runs the garbage collector.
     Ignored, since the ST-gc runs all the time."

    ^ self

    "Modified: / 12.1.1998 / 12:58:32 / cg"
!

_java_lang_Runtime_maxMemory: this

    <javanative: 'java/lang/Runtime' name: 'maxMemory()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_runFinalization0: this

    <javanative: 'java/lang/Runtime' name: 'runFinalization0()V'>

    Smalltalk garbageCollect

    "Modified: / 08-08-2011 / 17:48:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Runtime_totalMemory: this

    <javanative: 'java/lang/Runtime' name: 'totalMemory()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_traceInstructions: this

    <javanative: 'java/lang/Runtime' name: 'traceInstructions(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_traceInstructions: this _: a1

    <javanative: 'java/lang/Runtime' name: 'traceInstructions(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_traceMethodCalls: this

    <javanative: 'java/lang/Runtime' name: 'traceMethodCalls(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Runtime_traceMethodCalls: this _: a1

    <javanative: 'java/lang/Runtime' name: 'traceMethodCalls(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_SecurityManager_classDepth: this _: a1

    <javanative: 'java/lang/SecurityManager' name: 'classDepth(Ljava/lang/String;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_SecurityManager_classLoaderDepth0: this

    <javanative: 'java/lang/SecurityManager' name: 'classLoaderDepth0()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_SecurityManager_currentClassLoader0: this

    <javanative: 'java/lang/SecurityManager' name: 'currentClassLoader0()Ljava/lang/ClassLoader;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_SecurityManager_currentLoadedClass0: this

    <javanative: 'java/lang/SecurityManager' name: 'currentLoadedClass0()Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_SecurityManager_getClassContext: this

    <javanative: 'java/lang/SecurityManager' name: 'getClassContext()[Ljava/lang/Class;'>
    "
    /**
     * Returns the current execution stack as an array of classes.
     * <p>
     * The length of the array is the number of methods on the execution
     * stack. The element at index <code>0</code> is the class of the
     * currently executing method, the element at index <code>1</code> is
     * the class of that method's caller, and so on.
     *
     * @return  the execution stack.
     */

    "

    | classes ctx jclasses |
    classes := OrderedCollection new.
    ctx := thisContext.
    [ ctx notNil ] whileTrue: [
        ctx isJavaContext ifTrue:[
            classes add: ctx method javaClass.
        ].
        ctx := ctx sender.
    ].

    jclasses := _java_lang_Class_CLASS javaArrayClass new: classes size.
    1 to: classes size do:[:i|
        jclasses at: i put: (Reflection javaClassObjectForClass: (classes at: i)).
    ].
    ^jclasses

    "Created: / 12-11-1998 / 18:56:06 / cg"
    "Modified: / 21-05-2013 / 16:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Shutdown_halt0: this _:a1

    <javanative: 'java/lang/Shutdown' name: 'halt0(I)V'>

    AbortOperationRequest raise

    "Modified: / 06-07-2012 / 13:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Shutdown_runAllFinalizers: this

    <javanative: 'java/lang/Shutdown' name: 'runAllFinalizers()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_StrictMath_IEEEremainder: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/StrictMath' name: 'IEEEremainder(DD)D'>

%{
    extern double jremainder ( double , double );
    RETURN ( __MKFLOAT( jremainder ( __floatVal ( a1 ) , __floatVal ( a3 ) ) ) );
%}

!

_java_lang_StrictMath_acos: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'acos(D)D'>

%{
    extern double jacos ( double );
    RETURN ( __MKFLOAT( jacos ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_asin: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'asin(D)D'>

%{
    extern double jasin ( double );
    RETURN ( __MKFLOAT( jasin ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_atan2: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/StrictMath' name: 'atan2(DD)D'>

%{
    extern double jatan2 ( double , double );
    RETURN ( __MKFLOAT( jatan2 ( __floatVal ( a1 ) , __floatVal ( a3 ) ) ) );
%}

!

_java_lang_StrictMath_atan: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'atan(D)D'>

%{
    extern double jatan ( double );
    RETURN ( __MKFLOAT( jatan ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_cbrt: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'cbrt(D)D'>

%{
    extern double jcbrt ( double );
    RETURN ( __MKFLOAT( jcbrt ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 07-09-2011 / 17:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_ceil: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'ceil(D)D'>

%{
    extern double jceil ( double );
    RETURN ( __MKFLOAT( jceil ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 21-08-2012 / 18:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_cos: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'cos(D)D'>

%{
    extern double jcos ( double );
    RETURN ( __MKFLOAT( jcos ( __floatVal ( a1 ) ) ) );
%}


    "Modified: / 07-09-2011 / 17:34:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_cosh: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'cosh(D)D'>

%{
    extern double jcosh ( double );
    RETURN ( __MKFLOAT( jcosh ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 06-09-2011 / 19:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_exp: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'exp(D)D'>

%{
    extern double jexp ( double );
    RETURN ( __MKFLOAT( jexp ( __floatVal ( a1 ) ) ) );
%}
!

_java_lang_StrictMath_expm1: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'expm1(D)D'>

%{
    extern double jexpm1 ( double );
    RETURN ( __MKFLOAT( jexpm1 ( __floatVal ( a1 ) ) ) );
%}
    "Modified: / 07-09-2011 / 17:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_floor: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'floor(D)D'>

%{
    extern double jfloor ( double );
    RETURN ( __MKFLOAT( jfloor ( __floatVal ( a1 ) ) ) );
%}
    "Modified: / 07-09-2011 / 17:33:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_hypot: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/StrictMath' name: 'hypot(DD)D'>

%{
    extern double jhypot ( double, double );
    RETURN ( __MKFLOAT( jhypot ( __floatVal ( a1 ) , __floatVal ( a3 ) ) ) );
%}
!

_java_lang_StrictMath_log10: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'log10(D)D'>

%{
    extern double jlog10 ( double );
    RETURN ( __MKFLOAT( jlog10 ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_log1p: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'log1p(D)D'>

%{
    extern double jlog1p ( double );
    RETURN ( __MKFLOAT( jlog1p ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_log: this _: a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'log(D)D'>

%{
    extern double jlog ( double );
    RETURN ( __MKFLOAT( jlog ( __floatVal ( a1 ) ) ) );
%}
!

_java_lang_StrictMath_pow: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/StrictMath' name: 'pow(DD)D'>

%{
    extern double jpow ( double, double );
    RETURN ( __MKFLOAT( jpow ( __floatVal ( a1 ) , __floatVal ( a3 ) ) ) );
%}

    "Modified: / 07-09-2011 / 17:33:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_sin: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'sin(D)D'>

%{
    extern double jsin ( double );
    RETURN ( __MKFLOAT( jsin ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 08-02-2013 / 10:49:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_sinh: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'sinh(D)D'>

 %{
    extern double jsinh ( double );
    RETURN ( __MKFLOAT( jsinh ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 06-09-2011 / 19:36:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-09-2011 / 17:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_sqrt: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'sqrt(D)D'>

%{
    extern double jsqrt ( double );
    RETURN ( __MKFLOAT( jsqrt ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 17-07-2012 / 20:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_StrictMath_tan: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'tan(D)D'>

%{
    extern double jtan ( double );
    RETURN ( __MKFLOAT( jtan ( __floatVal ( a1 ) ) ) );
%}

!

_java_lang_StrictMath_tanh: this _:a1 _: a2

    <javanative: 'java/lang/StrictMath' name: 'tanh(D)D'>
%{
    extern double jtanh ( double );
    RETURN ( __MKFLOAT( jtanh ( __floatVal ( a1 ) ) ) );
%}

    "Modified: / 07-09-2011 / 17:32:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_String_intern: this

    <javanative: 'java/lang/String' name: 'intern()Ljava/lang/String;'>

        |jString|

    jString := this.
    ^ Java intern:jString
!

_java_lang_System_arraycopy: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/lang/System' name: 'arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V'>

    |srcArray srcIdx dstArray dstIdx srcArrayCC dstArrayCC count dstEndIdx|

    srcArray := a1.
    srcArray isNil ifTrue:[
        ^ JavaVM throwNullPointerException
    ].
    srcArray isJavaArray ifFalse:[
        ^ JavaVM throwArrayStoreException:srcArray
    ].
    srcIdx := a2.
    dstArray := a3.
    dstArray isNil ifTrue:[
        ^ JavaVM throwNullPointerException
    ].
    dstArray isJavaArray ifFalse:[
        ^ JavaVM throwArrayStoreException:dstArray
    ].

    srcArrayCC := srcArray class javaComponentClass.
    dstArrayCC := dstArray class javaComponentClass.

    srcArrayCC isJavaPrimitiveType == dstArrayCC isJavaPrimitiveType
        ifTrue:
            [srcArrayCC isJavaPrimitiveType
                ifTrue:
                    [srcArrayCC ~~ dstArrayCC ifTrue:
                        [^ JavaVM throwArrayStoreException:dstArray]].
            ]
        ifFalse:
            [^ JavaVM throwArrayStoreException:dstArray].

    dstIdx := a4.
    count := a5.

    count < 0 ifTrue:[
        ^ JavaVM throwArrayIndexOutOfBoundsException:(srcIdx + count - 1)
    ].

    ((srcIdx < 0) or:[srcIdx + count > srcArray size]) ifTrue:[
        srcArray size == 0 ifTrue:[
            srcArray isVariable ifFalse:[
                ^ JavaVM throwArrayStoreException:srcArray
            ]
        ].
        ^ JavaVM throwArrayIndexOutOfBoundsException:(srcIdx + count - 1)
    ].
    ((dstIdx < 0) or:[dstIdx + count > dstArray size]) ifTrue:[
        dstArray size == 0 ifTrue:[
            dstArray isVariable ifFalse:[
                ^ JavaVM throwArrayStoreException:dstArray
            ]
        ].
        ^ JavaVM throwArrayIndexOutOfBoundsException:(dstIdx + count - 1)
    ].

    dstEndIdx := dstIdx + count.
    dstIdx := dstIdx + 1.       "/ ST uses 1-based indexing
    srcIdx := srcIdx + 1.       "/ ST uses 1-based indexing



    (srcArray class isBytes and:[dstArray class isBytes]) ifTrue:[
        dstArray replaceBytesFrom:dstIdx to:dstEndIdx with:srcArray startingAt:srcIdx.
    ] ifFalse:[
        dstArrayCC isJavaPrimitiveType ifFalse:[
            "Copy from array iff src=dst to avoid overwriting a data when copying"
            srcArray == dstArray ifTrue:[srcArray := srcArray copy].
            1 to: count do:[:i|
                | obj |

                obj := srcArray at:srcIdx + i - 1.

                (obj notNil and:[(JavaVM canCast: obj class to: dstArrayCC) not]) ifTrue:[
                    ^ JavaVM throwArrayStoreException:dstArray
                ].
                dstArray at: dstIdx + i - 1 put: (srcArray at:srcIdx + i - 1)
            ]
        ] ifTrue:[
            dstArray replaceFrom:dstIdx to:dstEndIdx with:srcArray startingAt:srcIdx.
        ]
    ].
    ^ nil.

    "Modified: / 16-01-2013 / 21:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_currentTimeMillis: this

    <javanative: 'java/lang/System' name: 'currentTimeMillis()J'>

    "return the milliseconds since 1.jan.1970"

    "Should be OK, see Timestamp>>getMilliseconds & Timestamp>>getSeconds & Timestamp>>utcSecondsSince1970"
    ^ Timestamp now getMilliseconds

    "
     JavaVM _System_currentTimeMillis:nil
    "

    "Modified: / 23-12-1998 / 21:54:50 / cg"
    "Modified: / 19-07-2012 / 11:44:56 / jv"
!

_java_lang_System_identityHashCode: this _:a1

    <javanative: 'java/lang/System' name: 'identityHashCode(Ljava/lang/Object;)I'>

        |obj|

    obj := a1.
    ^ obj identityHash

    "Modified: / 12.11.1998 / 18:52:07 / cg"
    "Created: / 12.11.1998 / 18:54:00 / cg"
!

_java_lang_System_initProperties: this _:a1

    <javanative: 'java/lang/System' name: 'initProperties(Ljava/util/Properties;)Ljava/util/Properties;'>

    |props stProps|

    props := a1.
    stProps := JavaVM systemProperties.

    "/ recursively invoke myself on the Java HashTable.
    "/ calling 'put' to stuff in the values ...

    stProps keysAndValuesDo:[:key :value |
        |keyObj valueObj|

        keyObj := Java as_String:key.
        valueObj := Java as_String:value.

        props
            perform:#'put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;'
            with:keyObj
            with:valueObj.
    ].
    ^ props

    "Created: / 03-01-1998 / 14:25:22 / cg"
    "Modified: / 04-01-1998 / 14:23:18 / cg"
    "Modified: / 16-01-2013 / 19:47:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_mapLibraryName: this _:a1

    <javanative: 'java/lang/System' name: 'mapLibraryName(Ljava/lang/String;)Ljava/lang/String;'>


    | name |
    name := Java as_ST_String: a1.

    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem isOSXlike ifTrue:[
            ^Java as_String: ('lib' , name , '.jnilib').
        ].
        ^Java as_String: ('lib' , name , '.so').
    ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^Java as_String: ( name , '.dll').
    ].

    self error:'Unknown/Unsupported platform'

    "Created: / 09-12-2010 / 18:16:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2011 / 18:14:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_nanoTime: this

    <javanative: 'java/lang/System' name: 'nanoTime()J'>

    ^ OperatingSystem getMicrosecondTime * 1000

    "Modified: / 07-08-2011 / 21:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_registerNatives: this

    <javanative: 'java/lang/System' name: 'registerNatives()V'>
    "Nothing to do, native method are bound lazily"

    "Created: / 20-10-2010 / 10:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2013 / 20:44:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_setErr0: this _:a1

    <javanative: 'java/lang/System' name: 'setErr0(Ljava/io/PrintStream;)V'>

        |stream|

    stream := a1.

    self setOpenFile:(JavaVM javaConsoleStream ? Stderr) at:2.

    this instVarNamed:'err' put:stream.

    "Created: / 18-03-1997 / 15:02:05 / cg"
    "Modified: / 04-01-1998 / 16:21:15 / cg"
    "Modified: / 16-01-2013 / 19:48:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_setIn0: this _:a1

    <javanative: 'java/lang/System' name: 'setIn0(Ljava/io/InputStream;)V'>

        |stream|

    stream := a1.

    self setOpenFile:Stdin at:0.

    this instVarNamed:'in' put:stream.

    "Created: / 4.1.1998 / 16:16:38 / cg"
    "Modified: / 4.1.1998 / 16:20:44 / cg"
!

_java_lang_System_setOut0: this _:a1

    <javanative: 'java/lang/System' name: 'setOut0(Ljava/io/PrintStream;)V'>

        |stream|

    stream := a1.

    self setOpenFile:(JavaVM javaConsoleStream ? Stdout) at:1.

    this instVarNamed:'out' put:stream.

    "Created: / 04-01-1998 / 16:18:26 / cg"
    "Modified: / 16-01-2013 / 19:48:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_countStackFrames: this

    <javanative: 'java/lang/Thread' name: 'countStackFrames()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_currentThread: this
    <javanative: 'java/lang/Thread' name: 'currentThread()Ljava/lang/Thread;'>
    | t  p |
    p := Processor activeProcess.
    t := JavaVM javaThreadForSTProcess: p.
"/    (nctx := self nativeContext) sender receiver class name
"/        = 'java/util/concurrent/locks/ReentrantLock$NonfairSync'
"/            ifTrue: [
"/                | owner |
"/                owner := (nctx sender receiver
"/                            perform: #'getExclusiveOwnerThread()Ljava/lang/Thread;').
"/                (owner notNil and: [ owner ~= t ]) ifTrue: [ self breakPoint: #mh. ]
"/            ].
    t notNil ifTrue: [ ^ t ].
    t := JavaVM newThread: p name.
    t instVarNamed: 'tid' put: p id.
    Java addThread: t for: p.
    ^ t

    "Modified: / 09-12-2011 / 12:52:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-01-2013 / 14:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_dumpThreads: this

    <javanative: 'java/lang/Thread' name: 'dumpThreads([Ljava/lang/Thread;)[[Ljava/lang/StackTraceElement;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_dumpThreads: this _: a1

    <javanative: 'java/lang/Thread' name: 'dumpThreads([Ljava/lang/Thread;)[[Ljava/lang/StackTraceElement;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_getThreads: this

    <javanative: 'java/lang/Thread' name: 'getThreads()[Ljava/lang/Thread;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_holdsLock: this _:a1
    <javanative: 'java/lang/Thread' name: 'holdsLock(Ljava/lang/Object;)Z'>
    | obj  mon  thisProcess |
    obj := a1.
    obj isNil ifTrue: [Reflection
    throwNullPointerException:'null given to _java_lang_Thread_holdsLock'].
    mon := obj getJavaMonitor.
    thisProcess := Processor activeProcess.
    (mon isOwnedBy: thisProcess) ifTrue: [ ^ 1 ] ifFalse: [ ^ 0 ].

    "Created: / 30-04-2011 / 22:06:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2011 / 11:13:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-08-2012 / 11:36:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_interrupt0: this
    <javanative: 'java/lang/Thread' name: 'interrupt0()V'>
    | jThread  stProcess |
    jThread := this.
    stProcess := JavaVM stProcessForJavaThread: jThread.
    self assert: stProcess notNil.
    stProcess javaInterrupt.

    "Modified: / 02-01-1998 / 21:49:06 / cg"
    "Created: / 10-04-1998 / 15:21:43 / cg"
    "Modified: / 30-11-2011 / 13:36:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-01-2013 / 19:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_isAlive: this

    <javanative: 'java/lang/Thread' name: 'isAlive()Z'>

        "is it alive ?"

    |jThread stProcess|

    jThread := this.
    stProcess := JavaVM stProcessForJavaThread:jThread.
    stProcess isNil ifTrue:[
        ThreadTrace == true ifTrue:[
            ('JAVA: no stProcess for javaThread: ' , jThread displayString) printNL.
        ].
        ^ 0 "FALSE"
    ].
    stProcess isDead ifTrue:[^ 0 "FALSE"].
    ^ 1 "TRUE"

    "Created: / 5.1.1998 / 02:03:51 / cg"
    "Modified: / 6.2.1998 / 02:15:01 / cg"
!

_java_lang_Thread_isInterrupted: this _:a1
    <javanative: 'java/lang/Thread' name: 'isInterrupted(Z)Z'>
    "ask if a thread is interrupted (clear interruptState if arg is true)"

    | jThread  stProcess  clearInterrupt  wasInterrupted |
    jThread := this.
    stProcess := JavaVM stProcessForJavaThread: jThread.
    self assert: stProcess notNil.
    clearInterrupt := a1.
    wasInterrupted := stProcess isInterrupted.
    clearInterrupt ~~ 0 ifTrue: [ stProcess clearInterrupted ].
    stProcess isDead ifTrue: [ ^ 0 ].
    wasInterrupted ifTrue: [ ^ 1 ] ifFalse: [ ^ 0 ].

    "Modified: / 02-01-1998 / 21:49:06 / cg"
    "Created: / 07-01-1998 / 18:50:26 / cg"
    "Modified: / 30-11-2011 / 12:22:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-01-2013 / 19:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_registerNatives: this

    <javanative: 'java/lang/Thread' name: 'registerNatives()V'>


    "Nothing to do, native method are bound lazily"

    "Created: / 20-10-2010 / 11:12:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_resume0: this

    <javanative: 'java/lang/Thread' name: 'resume0()V'>

        "yield"

    |jThread stProcess|

    jThread := this.
    stProcess := JavaVM stProcessForJavaThread:jThread.
    stProcess isNil ifTrue:[
        ThreadTrace == true ifTrue:[
            ('JAVA: no stProcess for javaThread: ' , jThread displayString) printNL.
        ].
        ^ nil "void"
    ].
    stProcess resume

    "Created: / 8.1.1998 / 01:06:27 / cg"
    "Modified: / 6.2.1998 / 02:15:08 / cg"
!

_java_lang_Thread_setNativeName: this _: a1 

    <javanative: 'java/lang/Thread' name: 'setNativeName(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_setPriority0: this _:a1

    <javanative: 'java/lang/Thread' name: 'setPriority0(I)V'>

   |t p prio|

    t := this.
    p := JavaVM stProcessForJavaThread:t.
    prio := a1.

    p isNil ifTrue:[
        ThreadTrace == true ifTrue:[
            Logger 
                  log:'JAVA [info]: no process yet (in setPriority)'
                  severity:Logger severityTRACE
                  facility:#JVM.
        ].
        ^ nil
    ].

    "Modified: / 01-05-2011 / 13:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_sleep: this _:a1 _: a2
    <javanative: 'java/lang/Thread' name: 'sleep(J)V'>
    "sleep for some milliseconds "

    | millis |
    millis := a1.
    millis < 0 ifTrue: [
        JavaVM throwIllegalArgumentException:('negative timeout: %1 in Thread.sleep' bindWith:millis)
    ].
    Logger
        log: ('%1 going to sleep for %2'
                bindWith: Processor activeProcess printString
                with: millis)
        severity: Logger severityDEBUG
        facility: #JVM.
    JavaVM sleepForTimeout: millis state: #sleep.

    "Modified: / 08-01-1999 / 16:42:52 / cg"
    "Modified: / 30-11-2011 / 13:58:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_start0: this

    <javanative: 'java/lang/Thread' name: 'start0()V'>


    ^JavaVM threadStart: self nativeContext

    "Created: / 19-01-2013 / 23:44:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 14:16:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Thread_stop0: this _:a1

    <javanative: 'java/lang/Thread' name: 'stop0(Ljava/lang/Object;)V'>

        "terminate a thread"

    | jThread  stProcess  death |
    jThread := this.
    stProcess := JavaVM stProcessForJavaThread: jThread.
    stProcess isNil ifTrue: [
        ThreadTrace == true ifTrue: [
            ('JAVA: no stProcess for javaThread: ' , jThread displayString) printNL.
        ].
        ^ nil "void"
    ].
    stProcess == JavaScreenUpdaterThread ifTrue: [ self halt ].
    stProcess == JavaEventQueueThread ifTrue: [ self halt ].
    death := a1.
    stProcess
        interruptWith: [
            JavaVM javaExceptionSignal
                handle: [
                    :ex |
                    Processor activeProcess == JavaScreenUpdaterThread ifTrue: [ self halt ].
                    Processor activeProcess == JavaEventQueueThread ifTrue: [ self halt ].
                    Processor activeProcess terminate
                ]
                do: [
                    ThreadTrace == true ifTrue: [
                        ('JAVA: thread exit: ' , jThread displayString) infoPrintNL.
                    ].

                    jThread perform: #'exit()V'.

                    JavaVM throwException:death.
                ]
        ].

    "Created: / 08-01-1998 / 13:11:17 / cg"
    "Modified: / 24-12-1999 / 02:32:45 / cg"
    "Modified: / 01-12-2011 / 18:26:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_java_lang_Thread_suspend0: this

    <javanative: 'java/lang/Thread' name: 'suspend0()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_yield: this

    <javanative: 'java/lang/Thread' name: 'yield()V'>

        "yield"

    Processor yield.
"/    jThread := nativeContext receiver.
"/    stProcess := JavaVM stProcessForJavaThread:jThread.
"/    stProcess isNil ifTrue:[
"/        ThreadTrace == true ifTrue:[
"/            ('JAVA: no stProcess for javaThread: ' , jThread displayString) printNL.
"/        ].
"/        ^ nil "void"
"/    ].
"/    stProcess == Processor activeProcess ifTrue:[
"/        Processor yield.
"/    ] ifFalse:[
"/        self halt.
"/    ].

    "Created: / 5.1.1998 / 02:03:51 / cg"
    "Modified: / 23.12.1998 / 19:19:17 / cg"
!

_java_lang_Throwable_fillInStackTrace: this
    <javanative: 'java/lang/Throwable' name: 'fillInStackTrace()Ljava/lang/Throwable;'>
    | java_lang_Throwable  exceptionObject  list  con |

    java_lang_Throwable := JavaVM classNamed: 'java/lang/Throwable' definedBy: nil.
    exceptionObject := this.

    "/
    "/ debugging only
    "/

    (java_lang_Throwable notNil and:[(exceptionObject isKindOf: java_lang_Throwable) not]) ifTrue: [
        self error:'Thrown object is not a java.lang.Throwable'.
    ].
    con := "self nativeContext"thisContext sender.

    "/
    "/ we are not interrested in all intermediate Exception frames ...
    "/

    FullExceptionTrace ifFalse: [
        "/ first, skip any JavaVM contexts
        [ con receiver == exceptionObject ] whileFalse: [ con := con sender ].

        "/ then, all exception-init contexts

        [ con receiver == exceptionObject ] whileTrue: [ con := con sender ].
    ].
    list := OrderedCollection new.
    [ con notNil ] whileTrue: [
        (con isJavaContext) ifTrue: [
            "/ add a copy, in case the context continues with some
            "/ cleanup ...
            list add: con shallowCopy
        ].
        con := nil"/con sender
    ].
    exceptionObject instVarNamed: 'backtrace' put: (list asArray).
    ^ nil.

    "Created: / 04-01-1998 / 14:27:40 / cg"
    "Modified: / 08-05-1998 / 21:29:53 / cg"
    "Modified: / 21-10-2011 / 13:41:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-05-2013 / 01:17:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Throwable_getStackTraceDepth: this

    <javanative: 'java/lang/Throwable' name: 'getStackTraceDepth()I'>


    ^(this instVarNamed: #backtrace) size

    "Modified: / 01-05-2011 / 20:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Throwable_getStackTraceElement: this _:a1

    <javanative: 'java/lang/Throwable' name: 'getStackTraceElement(I)Ljava/lang/StackTraceElement;'>

    | throwable index ctx stackTraceElement |
    throwable := this.
    index :=  a1.
    ctx := (throwable instVarNamed:#backtrace) at: index + 1.

    stackTraceElement := (JavaVM classForName:'java.lang.StackTraceElement' definedBy:nil) new.

    stackTraceElement
        instVarNamed: #declaringClass
        put: (Java as_String:(ctx method javaClass javaName));

        instVarNamed: #methodName
        put: (Java as_String:"(ctx method printStringForBrowserWithSelector:ctx method selector inClass: ctx method javaClass) asString"ctx method selector);

        instVarNamed: #lineNumber
        put: ctx lineNumber.

    ctx method javaClass sourceFile notNil ifTrue:[
        stackTraceElement
            instVarNamed: #fileName
            put: (Java as_String:(ctx method javaClass sourceFile))
    ].
    ^ stackTraceElement

    "Modified: / 02-12-2011 / 23:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_UNIXProcess_destroyProcess: this _: a1

    <javanative: 'java/lang/UNIXProcess' name: 'destroyProcess(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_UNIXProcess_forkAndExec: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'java/lang/UNIXProcess' name: 'forkAndExec([B[BI[BI[BZLjava/io/FileDescriptor;Ljava/io/FileDescriptor;Ljava/io/FileDescriptor;)I'>

    "^ UnimplementedNativeMethodSignal raise"
!

_java_lang_UNIXProcess_initIDs: this

    <javanative: 'java/lang/UNIXProcess' name: 'initIDs()V'>

    "Nothing to do"

    "Modified: / 25-06-2011 / 10:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_UNIXProcess_waitForProcessExit: this _:a1

    <javanative: 'java/lang/UNIXProcess' name: 'waitForProcessExit(I)I'>

    "^ UnimplementedNativeMethodSignal raise"

! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.lang.ref'!

_java_lang_ref_Finalizer_invokeFinalizeMethod: this _:a1

    <javanative: 'java/lang/ref/Finalizer' name: 'invokeFinalizeMethod(Ljava/lang/Object;)V'>

    | o |

    o := a1.

    Logger log: 'Finalizing ' , o printString  severity: Logger severityDEBUG facility: 'JVM' .
    o perform:#'finalize()V'

    "Modified: / 02-03-2015 / 14:03:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.lang.reflect'!

_java_lang_reflect_Array_get: this _: arr _: idx

    <javanative: 'java/lang/reflect/Array' name: 'get(Ljava/lang/Object;I)Ljava/lang/Object;'>

    | e |

    arr isNil ifTrue:[ 
        JavaVM throwNullPointerException: 'array argumen is null'.
        ^ self.
    ].

    arr isJavaArray ifFalse:[ 
        JavaVM throwIllegalArgumentException: 'array argument is not an array'.
    ].

    (idx between: 0 and: arr size - 1) ifFalse:[ 
        JavaVM throwArrayIndexOutOfBoundsException: arr _: idx. 
        ^ self.
    ].

    e := arr at: idx + 1.
    arr class javaComponentClass isJavaPrimitiveType ifTrue:[ 
        e := arr class javaComponentClass javaBox: e.  
    ].
    ^ e

    "Modified: / 10-04-2014 / 15:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_reflect_Array_getBoolean: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getBoolean(Ljava/lang/Object;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getByte: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getByte(Ljava/lang/Object;I)B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getChar: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getChar(Ljava/lang/Object;I)C'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getDouble: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getDouble(Ljava/lang/Object;I)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getFloat: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getFloat(Ljava/lang/Object;I)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getInt: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getInt(Ljava/lang/Object;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getLength: this _:a1

    <javanative: 'java/lang/reflect/Array' name: 'getLength(Ljava/lang/Object;)I'>

    ^a1 size

    "Modified: / 17-08-2011 / 09:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_reflect_Array_getLong: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getLong(Ljava/lang/Object;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_getShort: this _: a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'getShort(Ljava/lang/Object;I)S'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_multiNewArray: this _:a1 _: a2

    <javanative: 'java/lang/reflect/Array' name: 'multiNewArray(Ljava/lang/Class;[I)Ljava/lang/Object;'>

    |componentClass sizes cls array |

    a1 isNil ifTrue:[
        JavaVM throwNullPointerException.
        ^nil.
    ].
    a2 isNil ifTrue:[
        JavaVM throwNullPointerException.
        ^nil.
    ].

    componentClass := Reflection
                classForJavaClassObject:a1.
    componentClass == UndefinedObject ifTrue:[
        JavaVM throwIllegalArgumentException:'invalid class: void'.
        ^nil
    ].
    sizes := a2.
    sizes class == SignedIntegerArray ifFalse:[
        JavaVM throwIllegalArgumentException:('sizes arguments not instance of int[] (is: %1)' bindWith:sizes class).
        ^nil
    ].
    sizes size == 0 ifTrue:[
        JavaVM throwIllegalArgumentException:('sizes argument has no elements').
        ^nil
    ].
    array := nil.
    cls := componentClass.
    sizes do:[:size|
        | newArray |
        size > SmallInteger maxVal ifTrue:[
            "This is just for Mauve tests"
            JavaVM throwExceptionClassName:'java.lang.OutOfMemoryError'
                    withMessage:'array size too big'.
            ^nil.
        ].
        size <  0 ifTrue:[
            JavaVM throwExceptionClassName:'java.lang.NegativeArraySizeException'
                    withMessage:'negative array size not allowed'.
            ^nil
        ].
        cls := cls javaArrayClass.
        newArray := cls new: size.
        1 to: size do:[:i|
            newArray at:i put: array copy.
        ].
        array := newArray.
    ].
    ^array.

    "Modified: / 23-04-2013 / 23:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_reflect_Array_newArray: this _:a1 _: a2
    <javanative: 'java/lang/reflect/Array' name: 'newArray(Ljava/lang/Class;I)Ljava/lang/Object;'>
    |componentClass size|

    a1 isNil ifTrue:[
        JavaVM throwNullPointerException.
        ^nil.
    ].
    componentClass := Reflection
                classForJavaClassObject:a1.
    componentClass == UndefinedObject ifTrue:[
        JavaVM throwIllegalArgumentException:'invalid class: void'.
        ^nil
    ].
    size := a2.
    size < 0 ifTrue:[
        JavaVM throwExceptionClassName:'java.lang.NegativeArraySizeException'
    withMessage:'negative array size not allowed'.
        ^nil
    ].
    ^ componentClass javaArrayClass new:size

    "Created: / 17-12-2010 / 14:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:18:50 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-06-2011 / 17:06:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-04-2013 / 23:43:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_reflect_Array_set: this _: array _: index0 _: value

    <javanative: 'java/lang/reflect/Array' name: 'set(Ljava/lang/Object;ILjava/lang/Object;)V'>

    | index valueToStore |

    index := index0 + 1.

    array isJavaArray ifFalse:[
        JavaVM throwIllegalArgumentException:'array argument is not an array'.
        ^nil.
    ].
    index < 1 ifTrue:[
        JavaVM throwIllegalArgumentException:'index is negative'.
        ^nil.
    ].
    index > array size ifTrue:[
        JavaVM throwArrayIndexOutOfBoundsException:index.
        ^nil.
    ].
    value isNil ifTrue:[
        array at: index put: nil.
        ^nil
    ].
    (JavaVM canCast: value class to: array class javaComponentClass) ifFalse:[
        JavaVM throwIllegalArgumentException:'type-incompatible value'.
        ^nil.
    ].

    valueToStore := value.
    array class javaComponentClass isJavaPrimitiveType ifTrue:[ 
        valueToStore := array class javaComponentClass javaUnbox: value.
    ].


    array at: index put: valueToStore.

    "Modified: / 10-04-2014 / 15:32:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_reflect_Array_setBoolean: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setBoolean(Ljava/lang/Object;IZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setByte: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setByte(Ljava/lang/Object;IB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setChar: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setChar(Ljava/lang/Object;IC)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setDouble: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/reflect/Array' name: 'setDouble(Ljava/lang/Object;ID)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setFloat: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setFloat(Ljava/lang/Object;IF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setInt: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setInt(Ljava/lang/Object;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setLong: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/lang/reflect/Array' name: 'setLong(Ljava/lang/Object;IJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Array_setShort: this _: a1 _: a2 _: a3

    <javanative: 'java/lang/reflect/Array' name: 'setShort(Ljava/lang/Object;IS)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_reflect_Proxy_defineClass0: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/lang/reflect/Proxy' name: 'defineClass0(Ljava/lang/ClassLoader;Ljava/lang/String;[BII)Ljava/lang/Class;'>

        "
    private static native Class defineClass0(ClassLoader loader, String name,
                                             byte[] b, int off, int len);
    "
    | loader nm b off len  bs cls |
    loader := a1.
    nm := a2.
    b := a3.
    off := a4.
    len := a5.

    bs := (off = 0 and: [len = b size])
            ifTrue:[b readStream]
            ifFalse:[(b copyFrom: off + 1 to: off + len) readStream].

    cls := JavaClassReader readStream: bs loader: loader.
    cls classLoader: loader.
    ClassRegistry registerClass: cls.

    ^Reflection javaClassObjectForClass: cls.

    "Created: / 06-02-2011 / 16:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2013 / 09:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.net'!

_java_net_DatagramPacket_init: this

    <javanative: 'java/net/DatagramPacket' name: 'init()V'>

    _java_net_DatagramPacket_CLASS := this.
    _java_net_DatagramPacket_buf_ID         := _java_net_DatagramPacket_CLASS instVarIndexFor: #buf.
    _java_net_DatagramPacket_offset_ID      := _java_net_DatagramPacket_CLASS instVarIndexFor: #offset.
    _java_net_DatagramPacket_length_ID      := _java_net_DatagramPacket_CLASS instVarIndexFor: #length.
    _java_net_DatagramPacket_bufLength_ID   := _java_net_DatagramPacket_CLASS instVarIndexFor: #bufLength.
    _java_net_DatagramPacket_address_ID     := _java_net_DatagramPacket_CLASS instVarIndexFor: #address.
    _java_net_DatagramPacket_port_ID        := _java_net_DatagramPacket_CLASS instVarIndexFor: #port.

    "Modified: / 13-08-2013 / 11:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_Inet4AddressImpl_getHostByAddr: this _:a1

    <javanative: 'java/net/Inet4AddressImpl' name: 'getHostByAddr([B)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet4AddressImpl_getLocalHostName: this

    <javanative: 'java/net/Inet4AddressImpl' name: 'getLocalHostName()Ljava/lang/String;'>

    ^Java as_String: OperatingSystem getHostName

    "Modified: / 13-09-2011 / 22:36:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_Inet4AddressImpl_isReachable0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/net/Inet4AddressImpl' name: 'isReachable0([BI[BI)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet4AddressImpl_lookupAllHostAddr: this _:a1

    <javanative: 'java/net/Inet4AddressImpl' name: 'lookupAllHostAddr(Ljava/lang/String;)[Ljava/net/InetAddress;'>

    | hostname sockaddr inet4AddreessClass inet4Address |
    hostname := Java as_ST_String: a1.
    [
        sockaddr := IPSocketAddress hostName: hostname.
    ] on: HostNameLookupError do: [:ex|
        JavaVM  throwExceptionClassName:'java.net.UnknownHostException'
                withMessage:(ex description , '(' , hostname , ')').
        ^nil.
    ].
    "Bad, here we have an access to just one inet address,
     that's fine for now, however"

    inet4AddreessClass := JavaVM classForName:'java.net.Inet4Address' definedBy:nil.
    inet4AddreessClass instSize == 3 ifTrue:[
        "/ OpenJDK version with holder...
        | holder |

        inet4Address := (JavaVM classForName:'java.net.Inet4Address' definedBy:nil) new.
        holder := inet4Address instVarNamed: #holder.
        holder
            instVarNamed: #family put: 1; "/IPv4
            instVarNamed: #address put: (sockaddr address signedDoubleWordAt: 1 MSB: true);
            instVarNamed: #hostName put: a1.
        inet4Address
            instVarNamed: #canonicalHostName put: a1.
    ] ifFalse:[
        inet4Address := (JavaVM classForName:'java.net.Inet4Address' definedBy:nil) newCleared.
        inet4Address
            instVarNamed: #family put: 1; "/IPv4
            instVarNamed: #address put: (sockaddr address signedDoubleWordAt: 1 MSB: true);
            instVarNamed: #hostName put: a1;
            instVarNamed: #canonicalHostName put: a1.
    ].

    ^(JavaVM classForName:'java.net.InetAddress' definedBy:nil) javaArrayClass with: inet4Address.

    "Modified: / 12-08-2013 / 10:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_Inet4Address_init: this

    <javanative: 'java/net/Inet4Address' name: 'init()V'>

    _java_net_Inet4Address_CLASS := this.

    "Modified: / 14-08-2013 / 00:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_Inet6AddressImpl_getHostByAddr: this _: a1

    <javanative: 'java/net/Inet6AddressImpl' name: 'getHostByAddr([B)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet6AddressImpl_getLocalHostName: this

    <javanative: 'java/net/Inet6AddressImpl' name: 'getLocalHostName()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet6AddressImpl_isReachable0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/net/Inet6AddressImpl' name: 'isReachable0([BII[BII)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet6AddressImpl_lookupAllHostAddr: this _: a1

    <javanative: 'java/net/Inet6AddressImpl' name: 'lookupAllHostAddr(Ljava/lang/String;)[Ljava/net/InetAddress;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_Inet6Address_init: this

    <javanative: 'java/net/Inet6Address' name: 'init()V'>

    "Nothing to do"

    "Modified: / 13-09-2011 / 22:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_InetAddressImplFactory_isIPv6Supported: this

    <javanative: 'java/net/InetAddressImplFactory' name: 'isIPv6Supported()Z'>

    ^ 0 "IPv6 is not supported!!"

    "Modified: / 13-09-2011 / 19:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_InetAddress_init: this

    <javanative: 'java/net/Inet4Address' name: 'init()V'>

    _java_net_InetAddress_CLASS := this.
    _java_net_InetAddress_CLASS instSize == 3 ifTrue:[
        _java_net_InetAddress_holder_ID := _java_net_InetAddress_CLASS instVarIndexFor: #holder.

    ] ifFalse:[
        _java_net_InetAddress_family_ID  := _java_net_InetAddress_CLASS instVarIndexFor: #family.
        _java_net_InetAddress_address_ID := _java_net_InetAddress_CLASS instVarIndexFor: #address.
        _java_net_InetAddress_hostName_ID := _java_net_InetAddress_CLASS instVarIndexFor: #hostName.
    ].
    _java_net_InetAddress_canonicalHostName_ID := _java_net_InetAddress_CLASS instVarIndexFor: #canonicalHostName.

    "Created: / 27-01-1998 / 18:16:40 / cg"
    "Modified: / 14-08-2013 / 00:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_NetworkInterface_getAll: this

    <javanative: 'java/net/NetworkInterface' name: 'getAll()[Ljava/net/NetworkInterface;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getBroadcast0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'getBroadcast0(Ljava/lang/String;I)Ljava/net/Inet4Address;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getByIndex: this _: a1

    <javanative: 'java/net/NetworkInterface' name: 'getByIndex(I)Ljava/net/NetworkInterface;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getByInetAddress0: this _: a1

    <javanative: 'java/net/NetworkInterface' name: 'getByInetAddress0(Ljava/net/InetAddress;)Ljava/net/NetworkInterface;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getByName0: this _:a1

    <javanative: 'java/net/NetworkInterface' name: 'getByName0(Ljava/lang/String;)Ljava/net/NetworkInterface;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getMTU0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'getMTU0(Ljava/lang/String;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getMacAddr0: this _: a1 _: a2 _: a3

    <javanative: 'java/net/NetworkInterface' name: 'getMacAddr0([BLjava/lang/String;I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_getSubnet0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'getSubnet0(Ljava/lang/String;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_init: this

    <javanative: 'java/net/NetworkInterface' name: 'init()V'>

    "Nothing to do"

    "Modified: / 13-09-2011 / 22:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_NetworkInterface_isLoopback0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'isLoopback0(Ljava/lang/String;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_isP2P0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'isP2P0(Ljava/lang/String;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_isUp0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'isUp0(Ljava/lang/String;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_NetworkInterface_supportsMulticast0: this _: a1 _: a2

    <javanative: 'java/net/NetworkInterface' name: 'supportsMulticast0(Ljava/lang/String;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_bind0: this _:a1 _: a2

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'bind0(ILjava/net/InetAddress;)V'>

    | port addr sock fd |

    port := a1.
    addr := a2.
    addr isNil ifTrue:[
        JavaVM throwSocketException:'Passed InetAddress object is null'.
        ^nil.
    ].
    fd := this instVarNamed: #fd.
    fd isNil ifTrue:[
        JavaVM throwSocketException:'Socket closed'.
        ^nil.
    ].
    sock := self validateFile: this.

    addr := addr perform: #'getAddress()[B'.
    addr = #[0 0 0 0] ifTrue:[
        addr := nil
    ] ifFalse:[
        addr := IPSocketAddress hostAddress: addr.
    ].

    [
        sock bindTo: port address: addr reuseAddress: true.
        this instVarNamed: #localPort put: sock port.
    ] on: Error do:[:ex|
        JavaVM throwSocketException:'bind0() failed: ' , ex description
    ]

    "Modified: / 12-08-2013 / 21:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_connect0: this _: jaddr _: port

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'connect0(Ljava/net/InetAddress;I)V'>

    | sock sockaddr ok |

    jaddr isNil ifTrue:[
        JavaVM throwNullPointerException: 'address parameter is nil'.
        ^ nil.
    ].

    sockaddr := IPSocketAddress new.
    sockaddr hostAddress: (jaddr perform: #'getAddress()[B').
    sockaddr port: port.

    sock := self validateFile:this.

    [
        ok := sock connectTo:sockaddr port:port.
        ok ifFalse:[
            JavaVM throwExceptionClassName:'java.net.ConnectException' withMessage:'Connect failed'.
        ].
    ] on: Error do:[:ex|
        JavaVM throwExceptionClassName:'java.net.ConnectException' withMessage:'Connect failed: ' , ex description
    ].

    "Modified: / 15-08-2013 / 23:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_datagramSocketClose: this

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'datagramSocketClose()V'>

        |jsock sock|

    jsock := this.

    sock := self validateFile:jsock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:'JAVA: datagram close socket'
                  severity:Logger severityTRACE
                  facility:#JVM
        ].
        sock close.
    ].

    "Modified: / 21.8.1997 / 17:09:40 / cg"
    "Created: / 25.1.1998 / 20:04:24 / cg"
!

_java_net_PlainDatagramSocketImpl_datagramSocketCreate: this

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'datagramSocketCreate()V'>

        |jsock fd sock fileNo|

    jsock := this.

    fd := jsock instVarNamed:'fd'.
    (fd instVarNamed:'fd') ~~ -1 ifTrue:[
        self halt:'file already open'.
        self internalError:'file already open'.
        JavaVM throwIOExceptionWithMessage:'file already open in socketCreate'.
        ^ self.
    ].

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: create datagram socket')
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    sock := self commonOpenStreamUsing:[JavaSocket newUDP].
    sock isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:'socketCreate failed'.
    ].

    fileNo := self addOpenFile:sock.
    fd instVarNamed:'fd' put:fileNo.
    "Kludge for finalization..."
    jsock finalizationLobby registerChange: jsock

    "Created: / 25-01-1998 / 19:59:25 / cg"
    "Modified: / 30-12-1998 / 20:10:38 / cg"
    "Modified: / 15-08-2013 / 21:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_disconnect0: this _: a1

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'disconnect0(I)V'>

    | sock sockaddr |

    sock := self validateFile: this.
    sockaddr := IPSocketAddress new.
    sock connectTo: sockaddr port: (this instVarNamed: #localPort)

    "Modified: / 15-08-2013 / 23:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_getTTL: this

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'getTTL()B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_getTimeToLive: this

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'getTimeToLive()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_init: this

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'init()V'>

    _java_net_PlainDatagramSocketImpl_CLASS := this.
    _java_net_PlainDatagramSocketImpl_timeout_ID := _java_net_PlainDatagramSocketImpl_CLASS instVarIndexFor: #timeout.

    "Modified: / 15-08-2013 / 22:04:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_join: this _: a1 _: a2

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'join(Ljava/net/InetAddress;Ljava/net/NetworkInterface;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_leave: this _: a1 _: a2

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'leave(Ljava/net/InetAddress;Ljava/net/NetworkInterface;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_peek: this _: a1

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'peek(Ljava/net/InetAddress;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_peekData: this _: a1

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'peekData(Ljava/net/DatagramPacket;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_receive0: this _: packet

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'receive0(Ljava/net/DatagramPacket;)V'>
    "
    /**
     * Receives a datagram packet from this socket. When this method
     * returns, the <code>DatagramPacket</code>'s buffer is filled with
     * the data received. The datagram packet also contains the sender's
     * IP address, and the port number on the sender's machine.
     * <p>
     * This method blocks until a datagram is received. The
     * <code>length</code> field of the datagram packet object contains
     * the length of the received message. If the message is longer than
     * the packet's length, the message is truncated.
     * ...
     */
    "

    | sock sockaddr dbuffer offset len address tout |

    sock := self validateFile: this.
    sockaddr := IPSocketAddress new.
    dbuffer := packet instVarAt: _java_net_DatagramPacket_buf_ID.
    offset  := packet instVarAt: _java_net_DatagramPacket_offset_ID.
    len     := packet instVarAt: _java_net_DatagramPacket_length_ID.
    tout    := this instVarAt: _java_net_PlainDatagramSocketImpl_timeout_ID.

    [
        tout ~~ 0 ifTrue:[
            (sock readWaitWithTimeoutMs: tout) ifTrue:[
                JavaVM throwInterruptedIOException: 'Timeout occured when receiving datagram'.
                ^ nil.
            ]
        ].
        sock receiveFrom:sockaddr buffer: dbuffer start:offset + 1 for: len.
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage: ex description.
    ].

    address := _java_net_Inet4Address_CLASS new.
    address perform: #'<init>(Ljava/lang/String;[B)V' with: nil with: sockaddr hostAddress.
    packet instVarAt: _java_net_DatagramPacket_address_ID put: address.
    packet instVarAt: _java_net_DatagramPacket_port_ID put: sockaddr port.

    "Modified: / 15-08-2013 / 22:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_send: this _:packet

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'send(Ljava/net/DatagramPacket;)V'>

    | sock address sockaddr dbuffer offset len |

    sock := self validateFile:this.
    address := packet instVarAt: _java_net_DatagramPacket_address_ID.
    address isNil ifTrue:[
        JavaVM throwNullPointerException: 'null address in datagram packet'.
    ].
    sockaddr := IPSocketAddress new.
    sockaddr hostAddress: (address perform: #'getAddress()[B').
    sockaddr port: (packet instVarAt: _java_net_DatagramPacket_port_ID).
    sockaddr port == 0 ifTrue:[
        JavaVM throwIOExceptionWithMessage: 'port 0 is reserved'.
        ^nil.
    ].
    dbuffer := packet instVarAt: _java_net_DatagramPacket_buf_ID.
    offset  := packet instVarAt: _java_net_DatagramPacket_offset_ID.
    len     := packet instVarAt: _java_net_DatagramPacket_length_ID.

    [
        sock sendTo: sockaddr buffer: dbuffer start: offset + 1 for: len
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage: ex description.
    ]

    "Created: / 04-02-1998 / 15:06:20 / cg"
    "Modified: / 30-12-1998 / 20:10:16 / cg"
    "Modified: / 14-08-2013 / 00:09:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_setTTL: this _: a1

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'setTTL(B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_setTimeToLive: this _: a1

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'setTimeToLive(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainDatagramSocketImpl_socketGetOption: this _: optid

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'socketGetOption(I)Ljava/lang/Object;'>

    | sock ret |

    sock := self validateFile: this.

"/    case IP_TOS:
    optid == 16r1002 ifTrue:[
        self breakPoint: #jv.
        ^Java as_Integer:-1 "/Unsupported
    ].

"/    case SO_BINDADDR:
    optid == 16rF ifTrue:[
        | addr |
"/        ^ Java as_Integer: (sock getSocketAddress doubleWordAt:1)
        addr := sock getFullSocketAddress.
        ^ (JavaVM classForName:'java.net.Inet4Address') basicNew
                perform: #'<init>(Ljava/lang/String;[B)V'
                with: (Java as_String: addr hostName)
                with: (addr hostAddress);
                yourself

    ].

"/    case IP_MULTICAST_IF:
    optid == 16r10 ifTrue:[

    ].

"/    case IP_MULTICAST_IF2:
    optid == 16r1f ifTrue:[

    ].

"/    case SO_RCVBUF:
    optid == 16r1002 ifTrue:[
        ^ sock receiveBufferSize
    ].

"/    case SO_SNDBUF:
    optid == 16r1001 ifTrue:[
        ^ sock sendBufferSize
    ].

"/    case IP_MULTICAST_LOOP:
    optid == 16r12 ifTrue:[6

    ].

"/    case SO_REUSEADDR:
    optid == 16r4 ifTrue:[
        ret := sock getSocketOption: #SO_REUSEADDR.
        ^ ret ifTrue:[Java as_Integer:1] ifFalse:[Java as_Integer:0].
    ].

"/    case SO_BROADCAST:
    optid == 16r20 ifTrue:[

    ].

    ^ Java as_Integer: -1.

    "Modified: / 13-08-2013 / 01:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainDatagramSocketImpl_socketSetOption: this _:a1 _: a2

    <javanative: 'java/net/PlainDatagramSocketImpl' name: 'socketSetOption(ILjava/lang/Object;)V'>

    | opt val sock o arg1 arg2 |
    opt := a1.
    val  := a2.

    sock := self validateFile: this.

"/  TCP_NODELAY = 1;
    opt = 1 ifTrue:[
        o := #TCP_NODELAY.
        arg1 := (val instVarNamed: #value == 1)
    ].
"/  SO_BINDADDR = 15;
    opt = 15 ifTrue:[
        ^self "/Unsupported
    ].

"/  SO_REUSEADDR = 4;
    opt = 4 ifTrue:[
        o := #SO_REUSEADDR.
        arg1 := ((val instVarNamed: #value) == 1)
    ].
"/  IP_TOS = 3;
    opt = 3 ifTrue:[
        ^self "/Unssuported
    ].
"/  SO_LINGER = 128;
"/    opt = 128 ifTrue:[
"/        o := #SO_LINGER.
"/        arg1 := (on == 1).
"/        arg2 := val instVarNamed: #value.
"/    ].

"/  SO_TIMEOUT = 4102;
    opt = 4102 ifTrue:[
        JavaVM internalError: 'Should not happen!!'.
        ^nil
                   .
    ].
"/  SO_SNDBUF = 4097;
    opt = 4097 ifTrue:[
        o := #SO_SNDBUF.
        arg1 := val instVarNamed: #value.
    ].

"/  SO_RCVBUF = 4098;
    opt = 4098 ifTrue:[
        o := #SO_RCVBUF.
        arg1 := val instVarNamed: #value.
    ].

"/  SO_KEEPALIVE = 8;
    opt = 8 ifTrue:[
        o := #SO_KEEPALIVE.
        arg1 := ((val instVarNamed: #value) == 1)
    ].

"/  SO_OOBINLINE = 4099;
    opt = 4099 ifTrue:[
        o := #SO_OOBINLINE.
        arg1 := ((val instVarNamed: #value) == 1)
    ].

    [
        sock setSocketOption: o argument: arg1 argument: arg2.
    ] on: Error do:[:ex|
        JavaVM throwSocketException:'Error setting socket option: ' , ex description.
    ].

    "Created: / 04-02-1998 / 15:06:20 / cg"
    "Modified: / 30-12-1998 / 20:10:16 / cg"
    "Modified: / 15-08-2013 / 22:02:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_initProto: this

    <javanative: 'java/net/PlainSocketImpl' name: 'initProto()V'>

    "Nothing to do"

    "Created: / 12-01-1998 / 12:56:52 / cg"
    "Modified (comment): / 13-09-2011 / 22:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketAccept: this _:a1

    <javanative: 'java/net/PlainSocketImpl' name: 'socketAccept(Ljava/net/SocketImpl;)V'>

    |jsock fd newJSock sock newSock fileNo|

    jsock := this.

    sock := self validateFile:jsock.
    sock isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:'nil socket in accept'.
        ^ self.
    ].

    newJSock := a1.
    fd := newJSock instVarNamed:'fd'.
    (fd instVarNamed:'fd') ~~ -1 ifTrue:[
        self halt:'file already open'.
        self internalError:'file already open'.
        JavaVM throwIOExceptionWithMessage:'socket already open in socketAccept'.
        ^ self.
    ].
    FileIOTrace ifTrue:[
        Logger 
              log:'JAVA: socket accept'
              severity:Logger severityTRACE
              facility:#JVM
    ].
    [
        newSock := self commonOpenStreamUsing:[sock accept].
    ] on: Error do:[:ex|
        JavaVM throwSocketException:'accept failed: ' , ex description.
        ^nil.
    ].
    newSock isNil ifTrue:[
        JavaVM throwSocketException:'accept failed'.
        ^nil.
    ].
    fileNo := self addOpenFile:newSock.
    fd instVarNamed:'fd' put:fileNo.
    newJSock instVarNamed:'localport' put: newSock port.
    newJSock instVarNamed:'port' put: newSock getPeer port.

    "Kludge for finalization..."
    newJSock finalizationLobby registerChange: newJSock.

    "Created: / 04-02-1998 / 15:26:49 / cg"
    "Modified: / 30-12-1998 / 20:10:01 / cg"
    "Modified: / 23-07-2012 / 19:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketAvailable: this

    <javanative: 'java/net/PlainSocketImpl' name: 'socketAvailable()I'>

        |jSock sock n|

    jSock := this.

    sock := self validateFile:jSock.
    sock isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:'socketAvailable on closed socket'.
        ^ self.
    ].

    n := sock numAvailable.
    ^ n

    "Created: / 4.2.1998 / 16:58:49 / cg"
    "Modified: / 30.12.1998 / 20:10:08 / cg"
!

_java_net_PlainSocketImpl_socketBind: this _: addr _:  port

    <javanative: 'java/net/PlainSocketImpl' name: 'socketBind(Ljava/net/InetAddress;I)V'>

    |sock sockaddr ok err|

    sockaddr := IPSocketAddress new.
    sockaddr hostAddress: (addr perform: #'getAddress()[B').
    sockaddr port: port.

    sock := self validateFile:this.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket bind to ' , sockaddr printString , ' port ' 
                          , port printString)
                  severity:Logger severityTRACE
                  facility:#JVM
        ].

        [
            ok := sock bindTo:port address: sockaddr
        ] on: Error do: [:ex|
            JavaVM throwExceptionClassName:'java.net.BindException' withMessage:'bind failed: ' , ex description.
        ].
        ok ifFalse:[
            err := OperatingSystem lastErrorString.
            JavaVM throwExceptionClassName:'java.net.BindException' withMessage:'bind failed: ' , err.
        ].
       this instVarNamed: #localport put: sock port.
       this instVarNamed: #address put: addr.
    ].

    "Created: / 04-02-1998 / 15:06:20 / cg"
    "Modified: / 30-12-1998 / 20:10:16 / cg"
    "Modified: / 17-08-2013 / 09:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketClose0: this _:a1

    <javanative: 'java/net/PlainSocketImpl' name: 'socketClose0(Z)V'>

    ^self commonClose: this

    "Modified: / 30-01-2013 / 17:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketConnect: this _:jaddr _: port _: a3

    <javanative: 'java/net/PlainSocketImpl' name: 'socketConnect(Ljava/net/InetAddress;II)V'>

    | sock sockaddr ok|

    jaddr isNil ifTrue:[
        JavaVM throwNullPointerException: 'address parameter is nil'.
        ^ nil.
    ].

    sockaddr := IPSocketAddress new.
    sockaddr hostAddress: (jaddr perform: #'getAddress()[B').
    sockaddr port: port.

    sock := self validateFile:this.

    [
        ok := sock connectTo:sockaddr port:port.
        ok ifFalse:[
            JavaVM throwExceptionClassName:'java.net.ConnectException' withMessage:'connect failed'.
        ].
        this instVarNamed: #localport put: sock port.
        this instVarNamed: #address put: jaddr.
    ] on: Error do:[:ex|
        JavaVM throwExceptionClassName:'java.net.ConnectException' withMessage:'connect failed: ' , ex description
    ].

    "Created: / 25-01-1998 / 20:02:27 / cg"
    "Modified: / 30-12-1998 / 20:10:28 / cg"
    "Modified: / 16-08-2013 / 09:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketCreate: this _:a1

    <javanative: 'java/net/PlainSocketImpl' name: 'socketCreate(Z)V'>

    |jsock isStream fd sock fileNo|

    jsock := this.
    isStream := a1 == 1.

    fd := jsock instVarNamed:'fd'.
    fd isNil ifTrue:[
        JavaVM throwSocketException:'null fd object'.
    ].
    (fd instVarNamed:'fd') ~~ -1 ifTrue:[
        self halt:'file already open'.
        self internalError:'file already open'.
        JavaVM throwSocketException:'socket already open in socketCreate'.
        ^ self.
    ].

    FileOpenTrace ifTrue:[
        Logger 
              log:('JAVA: create socket')
              severity:Logger severityTRACE
              facility:#JVM.
    ].

    isStream ifTrue:[
        sock := self commonOpenStreamUsing:[JavaSocket newTCP].
    ] ifFalse:[
        sock := self commonOpenStreamUsing:[JavaSocket newUDP].
    ].
    sock isNil ifTrue:[
        JavaVM throwIOExceptionWithMessage:'socketCreate failed'.
    ].

    (jsock instVarNamed: #serverSocket) notNil ifTrue:[
        "/If this is a server socket then enable SO_REUSEADDR
        [
            Object primitiveFailureSignal
        ] on: Object primitiveFailureSignal do:[:ex|
            JavaVM
    throwIOExceptionWithMessage:'cannot set SO_REUSEADDR: ' , ex description.
            ^nil.
        ]
    ].



    fileNo := self addOpenFile:sock.
    fd instVarNamed:'fd' put:fileNo.
    "Kludge for finalization..."
    jsock finalizationLobby registerChange: jsock

    "Created: / 25-01-1998 / 19:59:25 / cg"
    "Modified: / 30-12-1998 / 20:10:38 / cg"
    "Modified: / 23-07-2012 / 19:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketGetOption1: this _: a1 _: a2 _: a3

    <javanative: 'java/net/PlainSocketImpl' name: 'socketGetOption1(ILjava/lang/Object;Ljava/io/FileDescriptor;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_PlainSocketImpl_socketGetOption: this _:a1 _: a2

    <javanative: 'java/net/PlainSocketImpl' name: 'socketGetOption(ILjava/lang/Object;)I'>

    | opt arg sock ret |
    opt := a1.
    arg := a2.

    sock := self validateFile: this.

"/  TCP_NODELAY = 1;
    opt = 1 ifTrue:[
        ret := sock getSocketOption: #TCP_NODELAY.
        ^ret ifTrue:[1] ifFalse:[-1].
    ].
"/  SO_BINDADDR = 15;
    opt = 15 ifTrue:[
        self breakPoint: #jv.
        ^-1 "/Unsupported
    ].

"/  SO_REUSEADDR = 4;
    opt = 4 ifTrue:[
        ret := sock getSocketOption: #SO_REUSEADDR.
        ^ret ifTrue:[1] ifFalse:[-1].
    ].
"/  IP_TOS = 3;
    opt = 3 ifTrue:[
        self breakPoint: #jv.
        ^-1 "/Unsupported
    ].
"/  SO_LINGER = 128;
    opt = 128 ifTrue:[
        ret := sock getSocketOption:#SO_LINGER.
        ^ret
    ].
"/  SO_TIMEOUT = 4102;
    opt = 4102 ifTrue:[
        self breakPoint: #jv.
        ^-1 "/Unsupported                   .
    ].
"/  SO_SNDBUF = 4097;
    opt = 4097 ifTrue:[
        ret := sock getSocketOption: #SO_SNDBUF.
        ^ret
    ].

"/  SO_RCVBUF = 4098;
    opt = 4098 ifTrue:[
        ret := sock getSocketOption: #SO_RCVBUF.
        ^ret
    ].

"/  SO_KEEPALIVE = 8;
    opt = 8 ifTrue:[
        ret := sock getSocketOption: #SO_KEEPALIVE.
        ^ret ifTrue:[1] ifFalse:[-1].
    ].

"/  SO_OOBINLINE = 4099;
    opt = 4099 ifTrue:[
        ret := sock getSocketOption: #SO_OOBINLINE.
        ^ret ifTrue:[1] ifFalse:[-1].
    ]

    "Modified: / 13-11-2011 / 23:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketListen: this _:a1

    <javanative: 'java/net/PlainSocketImpl' name: 'socketListen(I)V'>

        |jSock time sock ok|

    jSock := this.
    time := a1.

    sock := self validateFile:jSock.
    sock notNil ifTrue:[
        FileIOTrace ifTrue:[
            Logger 
                  log:('JAVA: socket listen with timeout ' , time printString)
                  severity:Logger severityTRACE
                  facility:#JVM.
        ].
        ok := sock listenFor:5.
        ok ifFalse:[
            JavaVM throwIOExceptionWithMessage:'listen failed'.
            ^ self.
        ].
        time ~~ 0 ifTrue:[
            sock readWaitWithTimeoutMs:time
        ]
    ].

    "Created: / 04-02-1998 / 15:17:48 / cg"
    "Modified: / 30-12-1998 / 20:10:46 / cg"
    "Modified: / 17-08-2012 / 15:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketSendUrgentData: this _: data

    <javanative: 'java/net/PlainSocketImpl' name: 'socketSendUrgentData(I)V'>

    | sock |

    sock := self validateFile: this.
    sock nextPut: (data & 16rFF)
!

_java_net_PlainSocketImpl_socketSetOption: this _:a1 _: a2 _: a3

    <javanative: 'java/net/PlainSocketImpl' name: 'socketSetOption(IZLjava/lang/Object;)V'>

    | opt on val sock o arg1 arg2 |
    opt := a1.
    on  := a2.
    val := a3.

    sock := self validateFile: this.

"/  TCP_NODELAY = 1;
    opt = 1 ifTrue:[
        o := #TCP_NODELAY.
        arg1 := (on == 1)
    ].
"/  SO_BINDADDR = 15;
    opt = 15 ifTrue:[
        ^self "/Unsupported
    ].

"/  SO_REUSEADDR = 4;
    opt = 4 ifTrue:[
        o := #SO_REUSEADDR.
        arg1 := (on == 1)
    ].
"/  IP_TOS = 3;
    opt = 3 ifTrue:[
        ^self "/Unssuported
    ].
"/  SO_LINGER = 128;
    opt = 128 ifTrue:[
        o := #SO_LINGER.
        arg1 := (on == 1).
        arg2 := val instVarNamed: #value.
    ].
"/  SO_TIMEOUT = 4102;
    opt = 4102 ifTrue:[
        sock timeout: (val instVarNamed: #value).
        ^self
                   .
    ].
"/  SO_SNDBUF = 4097;
    opt = 4097 ifTrue:[
        o := #SO_SNDBUF.
        arg1 := val instVarNamed: #value.
    ].

"/  SO_RCVBUF = 4098;
    opt = 4098 ifTrue:[
        o := #SO_RCVBUF.
        arg1 := val instVarNamed: #value.
    ].

"/  SO_KEEPALIVE = 8;
    opt = 8 ifTrue:[
        o := #SO_KEEPALIVE.
        arg1 := (on == 1)
    ].

"/  SO_OOBINLINE = 4099;
    opt = 4099 ifTrue:[
        o := #SO_OOBINLINE.
        arg1 := (on == 1)
    ].

    [
        sock setSocketOption: o argument: arg1 argument: arg2.
    ] on: Error do:[:ex|
        JavaVM throwSocketException:'Error setting socket option: ' , ex description.
    ].

    "Modified: / 14-08-2013 / 15:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_PlainSocketImpl_socketShutdown: this _: what
    <javanative: 'java/net/PlainSocketImpl' name: 'socketShutdown(I)V'>
    "Shuts down either reading (what = 0) or writing (what = 1) end of a socket"

    | sock |

    sock := self validateFile: this.
    sock shutdown: what.
!

_java_net_SocketInputStream_init: this

    <javanative: 'java/net/SocketInputStream' name: 'init()V'>

    "Nothing to do"

    "Modified: / 09-11-2011 / 22:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_SocketInputStream_socketRead0: this _:fdObj _: data _: off _: len _: timeout

    <javanative: 'java/net/SocketInputStream' name: 'socketRead0(Ljava/io/FileDescriptor;[BIII)I'>

    | sock nread timeoutOrNil |

    fdObj isNil ifTrue:[
        JavaVM throwSocketException:'Socket closed (null fdObj passed to socketRead0)'.
        ^ -1.
    ].

    timeoutOrNil := nil.
    sock := self validateFile: fdObj.
    timeout ~~ 0 ifTrue:[
        timeoutOrNil := timeout.
"/        Transcript show: ' -- timeout '; showCR: timeout printString.
    ].

    [
        (sock readWaitWithTimeoutMs: timeoutOrNil) ifTrue:[
            JavaVM throwExceptionClassName:'java.net.SocketTimeoutException' withMessage:'Read timed out'.
            ^ -1.
        ].
        nread := sock nextAvailableBytes: len into: data startingAt: off + 1.
"/        Transcript show: '<   '; showCR: nread printString.
"/        Transcript show: '<-- '; showCR: (data copyFrom: off + 1 to: off + nread ) asString.
    ] on: Error do:[:ex|
        JavaVM throwSocketException:'Error when reading: ' , ex description.
    ].

    ^nread

    "Modified: / 18-08-2013 / 00:53:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_SocketOutputStream_init: this

    <javanative: 'java/net/SocketOutputStream' name: 'init()V'>

    "Nothing to do"

    "Modified: / 09-11-2011 / 23:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_net_SocketOutputStream_socketWrite0: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/net/SocketOutputStream' name: 'socketWrite0(Ljava/io/FileDescriptor;[BII)V'>

    | fdObj data off len  sock |
    fdObj   := a1.
    data    := a2.
    off     := a3.
    len     := a4.


    fdObj isNil ifTrue:[
        JavaVM throwSocketException:'Socket closed (null fdObj passed to socketRead0)'.
        ^ -1.
    ].

    sock := self validateFile: fdObj.

    [
        sock nextPutBytes: len from: data startingAt: off + 1.
"/        Transcript show: '--> '; showCR: (data copyFrom: off + 1 to: off + len ) asString.
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage:'Error when writing: ' , ex description.
    ].

    "Modified: / 18-08-2013 / 00:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.nio'!

_java_nio_Bits_copyFromByteArray: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "
    static native void copyFromByteArray(Object src, long srcPos, long dstAddr,
                                         long length);
    "


    <javanative: 'java/nio/Bits' name: 'copyFromByteArray(Ljava/lang/Object;JJJ)V'>

    | src srcPos dstAddr length |
    src := a1.
    srcPos := a2.
    dstAddr := a4.
    length := a6.
    SimulatedNativeMemory  bcopy: dstAddr length: length from: src offset: srcPos.

    "Modified: / 11-07-2012 / 10:37:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_nio_Bits_copyFromIntArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyFromIntArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyFromIntArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyFromIntArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyFromLongArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyFromLongArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyFromLongArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyFromLongArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyFromShortArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyFromShortArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyFromShortArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyFromShortArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToByteArray: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "
    static native void copyToByteArray(long srcAddr, Object dst, long dstPos,
                                       long length);
    "

    <javanative: 'java/nio/Bits' name: 'copyToByteArray(JLjava/lang/Object;JJ)V'>

    | srcAddr dst dstPos length |

    srcAddr := a1.
    dst := a3.
    dstPos := a4.
    length := a6.
    SimulatedNativeMemory bcopy: srcAddr length: length into: dst offset: dstPos.

    "Modified: / 11-07-2012 / 10:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_nio_Bits_copyToIntArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyToIntArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToIntArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyToIntArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToLongArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyToLongArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToLongArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyToLongArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToShortArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'java/nio/Bits' name: 'copyToShortArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_Bits_copyToShortArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/nio/Bits' name: 'copyToShortArray(JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_MappedByteBuffer_force0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/nio/MappedByteBuffer' name: 'force0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_MappedByteBuffer_isLoaded0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/nio/MappedByteBuffer' name: 'isLoaded0(JJI)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_nio_MappedByteBuffer_load0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/nio/MappedByteBuffer' name: 'load0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.security'!

_java_security_AccessController_doPrivileged: this _:a1

    <javanative: 'java/security/AccessController' name: 'doPrivileged(Ljava/security/PrivilegedAction;)Ljava/lang/Object;'>
    <javanative: 'java/security/AccessController' name: 'doPrivileged(Ljava/security/PrivilegedExceptionAction;)Ljava/lang/Object;'>

    "we don't care about permissions, we will just allow this. Now it's guaranteed that called code will not perform access permission checks"

    | retval |
    JavaVM privilegedAccessQuery answer: true
        do: [
            retval := a1 perform: #'run()Ljava/lang/Object;'.
        ].
    ^ retval

    "Created: / 20-10-2010 / 12:31:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2011 / 23:56:31 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 10-09-2012 / 23:22:59 / m"
    "Modified: / 08-02-2013 / 11:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_security_AccessController_doPrivileged: this _: a1 _: a2

    <javanative: 'java/security/AccessController' name: 'doPrivileged(Ljava/security/PrivilegedAction;Ljava/security/AccessControlContext;)Ljava/lang/Object;'>
    <javanative: 'java/security/AccessController' name: 'doPrivileged(Ljava/security/PrivilegedExceptionAction;Ljava/security/AccessControlContext;)Ljava/lang/Object;'>

    | retval |
    JavaVM privilegedAccessQuery answer: true
        do: [
            retval := a1 perform: #'run()Ljava/lang/Object;'.
        ].
    ^ retval

    "Modified: / 08-02-2013 / 10:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_security_AccessController_getInheritedAccessControlContext: this

    <javanative: 'java/security/AccessController' name: 'getInheritedAccessControlContext()Ljava/security/AccessControlContext;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_security_AccessController_getStackAccessControlContext: this
    <javanative: 'java/security/AccessController' name: 'getStackAccessControlContext()Ljava/security/AccessControlContext;'>
    "/ introduced with jdk1.2
    "/ supposed to do more here ...

    ^nil.

    "Created: / 27-01-1998 / 18:22:15 / cg"
    "Modified: / 09-10-2011 / 23:40:46 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.sql'!

_java_sql_DriverManager_getCallerClassLoader: this

    <javanative: 'java/sql/DriverManager' name: 'getCallerClassLoader()Ljava/lang/ClassLoader;'>

    ^self nativeContext
        sender sender
        receiver class theNonMetaclass
        classLoader

    "Modified: / 30-01-2013 / 14:16:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.text'!

_java_text_Bidi_nativeBidiChars: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'java/text/Bidi' name: 'nativeBidiChars(Ljava/text/Bidi;[CI[BIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_text_Bidi_nativeGetDirectionCode: this _: a1

    <javanative: 'java/text/Bidi' name: 'nativeGetDirectionCode(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util'!

_java_util_ResourceBundle_getClassContext: this

    <javanative: 'java/util/ResourceBundle' name: 'getClassContext()[Ljava/lang/Class;'>

    "returns an array filled with the contextChain receivers classes.
     What an ugly, messy interface."

    |chain con cls jClass|

    chain := OrderedCollection new.
    con := thisContext sender"trampoline" sender"sender of getClassContext".

    [con notNil] whileTrue:[
        (true) "con isJavaContext" ifTrue:[
            cls := con receiver class.
            cls isMeta ifTrue:[
                "/ t'was a static method
                cls := cls soleInstance
            ].
            cls isJavaClass ifTrue:[
                jClass := Reflection javaClassObjectForClass:cls.
                chain add:jClass.
            ]
        ].
        con := con sender.
    ].
    ^_java_lang_Class_CLASS javaArrayClass withAll: chain

    "Created: / 05-01-1998 / 02:47:00 / cg"
    "Modified: / 24-12-1998 / 00:34:57 / cg"
    "Modified: / 28-01-2011 / 15:31:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 21-05-2013 / 16:25:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_TimeZone_getSystemGMTOffsetID: this

    <javanative: 'java/util/TimeZone' name: 'getSystemGMTOffsetID()Ljava/lang/String;'>

    ^ Java as_String: 'GMT'

    "Modified: / 09-01-2013 / 16:18:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_TimeZone_getSystemTimeZoneID: this _:a1 _: a2

    <javanative: 'java/util/TimeZone' name: 'getSystemTimeZoneID(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;'>

    "JV@2011-06-25: TODO: finish, returning nil here means GMT"

    ^ nil

    "Modified: / 25-06-2011 / 08:26:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util.concurrent.atomic'!

_java_util_concurrent_atomic_AtomicLong_VMSupportsCS8: this

    <javanative: 'java/util/concurrent/atomic/AtomicLong' name: 'VMSupportsCS8()Z'>

    "Should be safe - say we don't support lockless updates"

    ^ 0

    "Modified: / 07-08-2011 / 20:53:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util.jar'!

_java_util_jar_JarFile_getMetaInfEntryNames: this

    <javanative: 'java/util/jar/JarFile' name: 'getMetaInfEntryNames()[Ljava/lang/String;'>
    "
    private native String[] getMetaInfEntryNames();
    "
    | zipArchive entries jentries |

    zipArchive := self getZipArchiveAt:(this instVarNamed:#jzfile).
    entries := (zipArchive entries select:[:entry|entry size > 9 and:[entry startsWith: 'META-INF/']]) asArray.
    jentries := Java java_lang_String javaArrayClass new: entries size.
    1 to: entries size do:[:i|
        jentries at: i put: (Java as_String: (entries at: i))
    ].
    ^jentries

    "Modified: / 10-12-2012 / 05:42:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util.logging'!

_java_util_logging_FileHandler_isSetUID: this

    <javanative: 'java/util/logging/FileHandler' name: 'isSetUID()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util.prefs'!

_java_util_prefs_FileSystemPreferences_chmod: this _: a1 _: a2

    <javanative: 'java/util/prefs/FileSystemPreferences' name: 'chmod(Ljava/lang/String;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_prefs_FileSystemPreferences_lockFile0: this _: a1 _: a2 _: a3

    <javanative: 'java/util/prefs/FileSystemPreferences' name: 'lockFile0(Ljava/lang/String;IZ)[I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_prefs_FileSystemPreferences_unlockFile0: this _: a1

    <javanative: 'java/util/prefs/FileSystemPreferences' name: 'unlockFile0(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - java.util.zip'!

_java_util_zip_Adler32_update: this _: a1 _: a2

    <javanative: 'java/util/zip/Adler32' name: 'update(II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Adler32_updateBytes: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/Adler32' name: 'updateBytes(I[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_CRC32_update: this _:a1 _: a2

    <javanative: 'java/util/zip/CRC32' name: 'update(II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_CRC32_updateBytes: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/CRC32' name: 'updateBytes(I[BII)I'>

    | crc b off len |
    crc := a1.
    b   := a2.
    off := a3.
    len := a4.

    ^ZipStream crc32BytesIn:b from:off + 1  to: off + len crc:crc

    "Modified: / 05-12-2011 / 00:41:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_deflateBytes: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/util/zip/Deflater' name: 'deflateBytes(J[BII)I'>

    "
    private native int deflateBytes(long addr, byte[] b, int off, int len);
    "

    | addr b off len deflater ret |
    addr := a1."long takes 2 slots"
    b := a3.
    off := a4.
    len := a5.

    deflater := ZipInflaters at: addr.

    ret := deflater deflate: b offset: off length: len flush: 0 deflater: this.

    ^ret.

    "Modified: / 25-10-2012 / 20:19:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_end: this _:a1 _: a2

    <javanative: 'java/util/zip/Deflater' name: 'end(J)V'>

    | addr deflater |
    addr := a1.
    deflater := ZipInflaters at: addr.
    ZipInflaters at: addr put: nil.
    deflater end.

    "Modified: / 25-10-2012 / 20:24:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_getAdler: this _: a1 _: a2

    <javanative: 'java/util/zip/Deflater' name: 'getAdler(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Deflater_getBytesRead: this _:a1 _: a2

    <javanative: 'java/util/zip/Deflater' name: 'getBytesRead(J)J'>

    | addr deflater |
    addr := a1.
    deflater := ZipInflaters at: addr.
    ^deflater bytesRead.

    "Modified: / 25-10-2012 / 20:19:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_getBytesWritten: this _:a1 _: a2

    <javanative: 'java/util/zip/Deflater' name: 'getBytesWritten(J)J'>

    | addr deflater |
    addr := a1.
    deflater := ZipInflaters at: addr.
    ^deflater bytesWritten.

    "Modified: / 25-10-2012 / 20:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_init: this _:a1 _: a2 _: a3

    <javanative: 'java/util/zip/Deflater' name: 'init(IIZ)J'>

    | level strategy nowrap deflater |
    level := a1.
    strategy := a2.
    nowrap := a3.
    deflater := JavaZipDeflater new vm: self.
    deflater init: strategy level: level nowrap: nowrap.
    1 to: ZipInflaters size do:[:i|
        (ZipInflaters at: i) isNil ifTrue:[
            ZipInflaters at: i put: deflater.
            ^i
        ].
    ].
    ZipInflaters add: deflater.
    ^ZipInflaters size.
    "/^deflater

    "Modified: / 25-07-2014 / 00:36:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_initIDs: this
    <javanative: 'java/util/zip/Deflater' name: 'initIDs()V'>

    "Nothing to do here"

    "Modified: / 08-12-2011 / 21:11:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 10-05-2012 / 17:03:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_reset: this _:a1 _: a2

    <javanative: 'java/util/zip/Deflater' name: 'reset(J)V'>

    | addr deflater |
    addr := a1.
    deflater := ZipInflaters at: addr.
    deflater reset.

    "Modified: / 25-10-2012 / 20:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Deflater_setDictionary: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/util/zip/Deflater' name: 'setDictionary(J[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Inflater_end: this _:a1 _: a2

    <javanative: 'java/util/zip/Inflater' name: 'end(J)V'>

     "
    private native static void reset(long addr);
    "
    | addr inflater |
    addr := a1.
    inflater := ZipInflaters at: addr.
    ZipInflaters at: addr put: nil.
    inflater end.

    "Modified: / 25-10-2012 / 20:24:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_getAdler: this _: a1

    <javanative: 'java/util/zip/Inflater' name: 'getAdler(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Inflater_getAdler: this _: a1 _: a2

    <javanative: 'java/util/zip/Inflater' name: 'getAdler(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Inflater_getBytesRead: this _:a1 _: a2

    <javanative: 'java/util/zip/Inflater' name: 'getBytesRead(J)J'>

    | addr inflater |
    addr := a1.
    inflater := ZipInflaters at: addr.
    ^inflater bytesRead.

    "Modified: / 25-10-2012 / 20:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_getBytesWritten: this _:a1 _: a2

    <javanative: 'java/util/zip/Inflater' name: 'getBytesWritten(J)J'>

    | addr inflater |
    addr := a1.
    inflater := ZipInflaters at: addr.
    ^inflater bytesWritten.

    "Modified: / 25-10-2012 / 20:20:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_inflateBytes: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/util/zip/Inflater' name: 'inflateBytes(J[BII)I'>
    "
    private native int inflateBytes(long addr, byte[] b, int off, int len)
    "

    | addr b off len inflater ret |
    addr := a1."long takes 2 slots"
    b := a3.
    off := a4.
    len := a5.

    inflater := ZipInflaters at: addr.

    ret := inflater inflate: b offset: off length: len inflater: this.

    ^ret.

    "Created: / 30-04-2011 / 23:02:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-10-2012 / 20:20:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_init: this _:a1

    <javanative: 'java/util/zip/Inflater' name: 'init(Z)J'>


    | nowrap inflater |
    nowrap := a1.
    inflater := JavaZipInflater new vm: self.  
    inflater init: nowrap.
    1 to: ZipInflaters size do:[:i|
        (ZipInflaters at: i) isNil ifTrue:[
            ZipInflaters at: i put: inflater.
            ^i
        ].
    ].
    ZipInflaters add: inflater.
    ^ ZipInflaters size.

    "Created: / 01-02-1998 / 20:14:01 / cg"
    "Modified: / 25-07-2014 / 00:36:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_initIDs: this

    <javanative: 'java/util/zip/Inflater' name: 'initIDs()V'>


    "Nothing to do, used only to register natives"

    "Created: / 30-04-2011 / 21:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_reset: this _:a1 _: a2

    <javanative: 'java/util/zip/Inflater' name: 'reset(J)V'>
    "
    private native static void reset(long addr);
    "
    | addr inflater |
    addr := a1.
    inflater := ZipInflaters at: addr.
    inflater reset.

    "Created: / 01-02-1998 / 20:14:13 / cg"
    "Modified: / 25-10-2012 / 20:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_Inflater_setDictionary: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/Inflater' name: 'setDictionary(J[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_Inflater_setDictionary: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'java/util/zip/Inflater' name: 'setDictionary(J[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_ZipEntry_initFields:this _:a1 _:a2 
    <javanative: 'java/util/zip/ZipEntry' name: 'initFields(J)V'>
    | entry  jzentry  zmember |

    entry := this.
    jzentry := a1.
    zmember := ZipEntryCache at:jzentry.
    entry
        instVarNamed:#name put:(Java as_String:zmember fileName);
        instVarNamed:#time put:-1;
        instVarNamed:#crc put:zmember crc32;
        instVarNamed:#size put:zmember uncompressedSize;
        instVarNamed:#csize put:zmember compressedSize;
        instVarNamed:#method put:zmember compressionMethod;
        instVarNamed:#extra put:zmember extraField;
        instVarNamed:#comment put:(zmember fileComment notNil ifTrue:[ Java as_String:zmember fileComment ]).

    "Created: / 01-04-2011 / 13:04:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:52:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipEntry_initIDs: this

    <javanative: 'java/util/zip/ZipEntry' name: 'initIDs()V'>

        "hopefully nothing to do"

    "Created: / 01-04-2011 / 13:02:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_java_util_zip_ZipFile_close: this _:a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'close(J)V'>

    | jzfile zar |
    jzfile := a1.
    zar := self getZipArchiveAt:jzfile.
    zar close.
    ZipCache at: jzfile put: nil.

    "Modified: / 03-11-2011 / 22:22:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_freeEntry: this _: jzfile _: dummy1 _: jzentry _: dummy2

    <javanative: 'java/util/zip/ZipFile' name: 'freeEntry(JJ)V'>

    jzentry = 0 ifFalse: [
        ZipEntryCacheLock critical:[
            "/Logger
            "/    log: 'java.util.zip.ZipFile.freeEntry() called for ', jzentry printString
            "/    severity: #debug
            "/    facility: 'JVM'.
            ZipEntryCache at: jzentry put: ZipEntryCacheFirstFree.
            ZipEntryCacheFirstFree := jzentry.
        ].
    ].

    "Modified: / 10-12-2013 / 00:55:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getCSize: this _:a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getCSize(J)J'>


    | jzentry zmember |
    jzentry := a1.
    zmember := ZipEntryCache at: jzentry.

    ^zmember compressedSize

    "Created: / 30-04-2011 / 21:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntry: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/ZipFile' name: 'getEntry(JLjava/lang/String;Z)J'>

    | zipArchive  filename  member |

    zipArchive := self getZipArchiveAt:a1.
    filename := Java as_ST_String: a3.
    member := (zipArchive findMemberAllowForMissingTrailingSlash: filename).
    member isNil ifTrue: [
        ^ 0
    ] ifFalse: [
        "/^ ZipEntryCache indexOf: member ifAbsent:[
            | index |

            ZipEntryCacheLock critical:[
                ZipEntryCacheFirstFree == 0 ifTrue:[
                    ZipEntryCache add: member.
                    index := ZipEntryCache size.
                ] ifFalse:[
                    index := ZipEntryCacheFirstFree.
                    ZipEntryCacheFirstFree := ZipEntryCache at: index.
                    ZipEntryCache at: index put: member.
                ].
            ].
            "/Logger
            "/    log: 'java.util.zip.ZipFile.getEntry()  called for ', index printString
            "/    severity: #debug
            "/    facility: 'JVM'.
            ^ index.
        "/"].
    ].

    "Created: / 27-03-2011 / 16:59:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-04-2011 / 16:03:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-08-2011 / 19:44:56 / jv"
    "Modified: / 25-07-2014 / 01:26:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getMethod: this _:a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getMethod(J)I'>


    | jzentry zmember |
    jzentry := a1.
    zmember := ZipEntryCache at: jzentry.

    ^zmember compressionMethod

    "Created: / 30-04-2011 / 21:53:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getNextEntry: this _:jzfile _: dummy1 _: index

    <javanative: 'java/util/zip/ZipFile' name: 'getNextEntry(JI)J'>

    | zipArchive member jzentry |

    zipArchive := self getZipArchiveAt:jzfile.
    (index between: 0 and: zipArchive members size - 1) ifFalse:[ ^ 0 ].
    member := zipArchive members at: index + 1.
    ZipEntryCacheLock critical:[
        ZipEntryCacheFirstFree == 0 ifTrue:[
            ZipEntryCache add: member.
            jzentry := ZipEntryCache size.
        ] ifFalse:[
            jzentry := ZipEntryCacheFirstFree.
            ZipEntryCacheFirstFree := ZipEntryCache at: jzentry.
            ZipEntryCache at: jzentry put: member.
        ].
    ].
    ^ jzentry.

    "Modified: / 25-07-2014 / 01:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getSize: this _:a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getSize(J)J'>


    | jzentry zmember |
    jzentry := a1.
    zmember := ZipEntryCache at: jzentry.

    ^zmember uncompressedSize

    "Created: / 30-04-2011 / 21:53:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getTotal: this _:a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getTotal(J)I'>

    | zar|
    zar := self getZipArchiveAt:a1.
    ^ zar entries size.

    "Modified: / 23-07-2012 / 23:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getZipMessage: this _: a1

    <javanative: 'java/util/zip/ZipFile' name: 'getZipMessage(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_ZipFile_getZipMessage: this _: a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getZipMessage(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_ZipFile_initIDs: this

    <javanative: 'java/util/zip/ZipFile' name: 'initIDs()V'>


    "Nothing to do"

    "Created: / 23-03-2011 / 19:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_open: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/ZipFile' name: 'open(Ljava/lang/String;IJ)J'>

    | path  mode  lastModTime  result |

    a1 isNil ifTrue: [ JavaVM throwZipException ].
    path := Java as_ST_String: a1.
    "/(path endsWith:'.jar') ifFalse:[self breakPoint: #jv].
    mode := a2.
    lastModTime := a3.
    result := path asFilename.
    ^[
        | i zar |

        zar := JavaZipFile readingFrom: result readStream.
        zar checkZipArchive ifFalse:[
            JavaVM throwZipException:'Cannot open zip file: not a zip archive'.
        ].
        i := ZipCache indexOf: nil.
        i ~~ 0 ifTrue:[
            ZipCache at: i put: zar.
            i
        ] ifFalse:[
            ZipCache add: zar.
            ZipCache size.
        ].
    ] on: Error do:[:ex|
        JavaVM throwZipException:'Cannot open zip file: ' , ex description
    ]

    "Modified: / 01-04-2011 / 15:35:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-11-2016 / 22:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_read: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'java/util/zip/ZipFile' name: 'read(JJJ[BII)I'>


    | jzfile jzentry pos b off len zar zmember bytesToRead |
    jzfile := a1.
    jzentry := a3. "first arg is long!!!!!!"
    pos := a5. "jzentry arg is long!!!!!!"
    b := a7.
    off := a8.
    len := a9.

    zar := self getZipArchiveAt:jzfile.
    zmember := ZipEntryCache at: jzentry.

    bytesToRead := len min: (zmember compressedSize - pos).

    ^zar nextBytes: bytesToRead of: zmember startingAt: pos into: b startingAt: off + 1.

    "Created: / 30-04-2011 / 22:15:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2011 / 16:22:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_startsWithLOC: this _: a1 _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'startsWithLOC(J)Z'>

    "Hmm, what to return here?"
    ^ 0"false"

    "Modified: / 27-07-2013 / 19:09:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - org.GNOME.Accessibility'!

_org_GNOME_Accessibility_AtkWrapper_componentAdded: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'componentAdded(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_componentRemoved: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'componentRemoved(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_dispatchKeyEvent: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'dispatchKeyEvent(Lorg/GNOME/Accessibility/AtkKeyEvent;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_emitSignal: this _: a1 _: a2 _: a3

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'emitSignal(Ljavax/accessibility/AccessibleContext;I[Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_focusNotify: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'focusNotify(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_initNativeLibrary: this

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'initNativeLibrary()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_loadAtkBridge: this

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'loadAtkBridge()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_objectStateChange: this _: a1 _: a2 _: a3

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'objectStateChange(Ljavax/accessibility/AccessibleContext;Ljava/lang/Object;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowActivate: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowActivate(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowClose: this _: a1 _: a2

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowClose(Ljavax/accessibility/AccessibleContext;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowDeactivate: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowDeactivate(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowMaximize: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowMaximize(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowMinimize: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowMinimize(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowOpen: this _: a1 _: a2

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowOpen(Ljavax/accessibility/AccessibleContext;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowRestore: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowRestore(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_GNOME_Accessibility_AtkWrapper_windowStateChange: this _: a1

    <javanative: 'org/GNOME/Accessibility/AtkWrapper' name: 'windowStateChange(Ljavax/accessibility/AccessibleContext;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - org.apache.tomcat.jni'!

_org_apache_tomcat_jni_Library_aprVersionString: this

    <javanative: 'org/apache/tomcat/jni/Library' name: 'aprVersionString()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_globalPool: this

    <javanative: 'org/apache/tomcat/jni/Library' name: 'globalPool()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_has: this _: a1

    <javanative: 'org/apache/tomcat/jni/Library' name: 'has(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_initialize: this

    <javanative: 'org/apache/tomcat/jni/Library' name: 'initialize()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_size: this _: a1

    <javanative: 'org/apache/tomcat/jni/Library' name: 'size(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_terminate: this

    <javanative: 'org/apache/tomcat/jni/Library' name: 'terminate()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_version: this _: a1

    <javanative: 'org/apache/tomcat/jni/Library' name: 'version(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_apache_tomcat_jni_Library_versionString: this

    <javanative: 'org/apache/tomcat/jni/Library' name: 'versionString()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - org.classpath.icedtea.pulseaudio'!

_org_classpath_icedtea_pulseaudio_ContextEvent_init_constants: this

    <javanative: 'org/classpath/icedtea/pulseaudio/ContextEvent' name: 'init_constants()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_EventLoop_nativeUpdateSourcePortNameList: this

    <javanative: 'org/classpath/icedtea/pulseaudio/EventLoop' name: 'nativeUpdateSourcePortNameList()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_EventLoop_nativeUpdateTargetPortNameList: this

    <javanative: 'org/classpath/icedtea/pulseaudio/EventLoop' name: 'nativeUpdateTargetPortNameList()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_EventLoop_native_iterate: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/EventLoop' name: 'native_iterate(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_EventLoop_native_setup: this _: a1 _: a2

    <javanative: 'org/classpath/icedtea/pulseaudio/EventLoop' name: 'native_setup(Ljava/lang/String;Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_EventLoop_native_shutdown: this

    <javanative: 'org/classpath/icedtea/pulseaudio/EventLoop' name: 'native_shutdown()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Operation_init_constants: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Operation' name: 'init_constants()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Operation_native_get_state: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Operation' name: 'native_get_state()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Operation_native_ref: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Operation' name: 'native_ref()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Operation_native_unref: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Operation' name: 'native_unref()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_PulseAudioSourcePort_native_set_volume: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/PulseAudioSourcePort' name: 'native_set_volume(F)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_PulseAudioSourcePort_native_update_volume: this

    <javanative: 'org/classpath/icedtea/pulseaudio/PulseAudioSourcePort' name: 'native_update_volume()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_PulseAudioTargetPort_native_set_volume: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/PulseAudioTargetPort' name: 'native_set_volume(F)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_PulseAudioTargetPort_native_update_volume: this

    <javanative: 'org/classpath/icedtea/pulseaudio/PulseAudioTargetPort' name: 'native_update_volume()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_bytesInBuffer: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'bytesInBuffer()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_init_constants: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'init_constants()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_connect_playback: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_connect_playback(Ljava/lang/String;IIIIIJ[B[B)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_connect_record: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_connect_record(Ljava/lang/String;IIIIIJ[B[B)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_cork: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_cork(I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_disconnect: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_disconnect()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_drain: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_drain()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_drop: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_drop()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_flush: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_flush()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_buffer_attr: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_buffer_attr()Lorg/classpath/icedtea/pulseaudio/StreamBufferAttributes;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_context: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_context()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_device_index: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_device_index()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_device_name: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_device_name()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_index: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_index()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_latency: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_latency()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_sample_spec: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_sample_spec()Lorg/classpath/icedtea/pulseaudio/StreamSampleSpecification;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_state: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_state()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_get_time: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_get_time()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_is_corked: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_is_corked()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_is_suspended: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_is_suspended()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_new: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_new([BLjava/lang/String;Ljava/lang/String;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_peek: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_peek()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_readable_size: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_readable_size()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_set_buffer_attr: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_set_buffer_attr(Lorg/classpath/icedtea/pulseaudio/StreamBufferAttributes;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_set_name: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_set_name(Ljava/lang/String;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_trigger: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_trigger()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_unref: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_unref()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_updateTimingInfo: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_updateTimingInfo()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_update_sample_rate: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_update_sample_rate(I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_writable_size: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_writable_size()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_pa_stream_write: this _: a1 _: a2 _: a3

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_pa_stream_write([BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_set_volume: this _: a1

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_set_volume(F)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_org_classpath_icedtea_pulseaudio_Stream_native_update_volume: this

    <javanative: 'org/classpath/icedtea/pulseaudio/Stream' name: 'native_update_volume()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava'!

_stx_libjava_ClassLoader_findClassS: this _:a1

    <javanative: 'stx/libjava/ClassLoader' name: 'findClassS(Ljava/lang/String;)Ljava/lang/Class;'>

    | nm cls |
    nm := Java as_ST_String: a1.
    (nm startsWith: 'SMALLTALK.') ifFalse:[
        JavaVM
            throwClassNotFoundException:('No such smalltalk class (%1)' bindWith:nm).
        ^self
    ].
    nm := nm copyFrom: 'SMALLTALK.' size + 1.
    cls := Smalltalk at: nm asSymbol.
    cls isNil ifTrue:[
        JavaVM
            throwClassNotFoundException:('No such smalltalk class (%1)' bindWith:nm).
        ^self
    ].
    ^Reflection javaClassObjectForClass: cls.

    "Modified: / 19-01-2013 / 18:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava.groovy'!

_stx_libjava_groovy_GroovyClassLoader_SystemClassCollector_getDefiningClassLoader: this

    <javanative: 'stx/libjava/groovy/GroovyClassLoader$SystemClassCollector' name: 'getDefiningClassLoader()Lstx/libjava/groovy/GroovyClassLoader;'>

    ^ SystemClassLoader

    "Modified: / 20-02-2012 / 22:30:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava.tests'!

_stx_libjava_tests_MonitorTests_abort: this

    <javanative: 'stx/libjava/tests/MonitorTests' name: 'abort()V'>

    AbortOperationRequest raiseRequest.

    "Modified: / 04-11-2011 / 21:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava.tests.lang'!

_stx_libjava_tests_lang_MonitorTests_abort: this
    <javanative: 'stx/libjava/tests/lang/MonitorTests' name: 'abort()V'>

    AbortOperationRequest raiseRequest.

    "Modified: / 10-09-2012 / 22:56:16 / m"
    "Modified: / 08-10-2013 / 23:15:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava.tests.vm'!

_stx_libjava_tests_vm_XLOAD_forcePatchupAndUnfix: this

    <javanative: 'stx/libjava/tests/MonitorTests' name: 'abort()V'>

    | ctx |

    ctx := thisContext.

    ObjectMemory garbageCollect.
    [ ctx notNil ] whileTrue:[
        1 to: ctx size do:[:i|
                Transcript showCR: i printString , ' -> ', (ctx at: i) printString.
        ].
        ctx := ctx sender.

    ].
    ObjectMemory garbageCollect.


    "Modified: / 04-11-2011 / 21:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - stx.libjava.tools.environment'!

_stx_libjava_tools_environment_Environment_findClassBytesForClass0: this _: jclass

    <javanative: 'stx/libjava/tools/environment/Environment' name: 'findClassBytesForClass0(Ljava/lang/Class;)[B'>

    ^(JavaVM reflection classForJavaClassObject: jclass) classfileBytes

    "Created: / 11-09-2013 / 23:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.awt'!

_sun_awt_DebugSettings_setCTracingOn: this _: a1

    <javanative: 'sun/awt/DebugSettings' name: 'setCTracingOn(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_DebugSettings_setCTracingOn: this _: a1 _: a2

    <javanative: 'sun/awt/DebugSettings' name: 'setCTracingOn(ZLjava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_DebugSettings_setCTracingOn: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/DebugSettings' name: 'setCTracingOn(ZLjava/lang/String;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_DefaultMouseInfoPeer_fillPointWithCoords: this _: a1

    <javanative: 'sun/awt/DefaultMouseInfoPeer' name: 'fillPointWithCoords(Ljava/awt/Point;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_DefaultMouseInfoPeer_isWindowUnderMouse: this _: a1

    <javanative: 'sun/awt/DefaultMouseInfoPeer' name: 'isWindowUnderMouse(Ljava/awt/Window;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_FontDescriptor_initIDs: this

    <javanative: 'sun/awt/FontDescriptor' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_KeyboardFocusManagerPeerImpl_clearNativeGlobalFocusOwner: this _: a1

    <javanative: 'sun/awt/KeyboardFocusManagerPeerImpl' name: 'clearNativeGlobalFocusOwner(Ljava/awt/Window;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_KeyboardFocusManagerPeerImpl_getNativeFocusOwner: this

    <javanative: 'sun/awt/KeyboardFocusManagerPeerImpl' name: 'getNativeFocusOwner()Ljava/awt/Component;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_KeyboardFocusManagerPeerImpl_getNativeFocusedWindow: this

    <javanative: 'sun/awt/KeyboardFocusManagerPeerImpl' name: 'getNativeFocusedWindow()Ljava/awt/Window;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_PlatformFont_initIDs: this

    <javanative: 'sun/awt/PlatformFont' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_SunToolkit_closeSplashScreen: this

    <javanative: 'sun/awt/SunToolkit' name: 'closeSplashScreen()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_check_gtk: this

    <javanative: 'sun/awt/UNIXToolkit' name: 'check_gtk()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_load_gtk: this

    <javanative: 'sun/awt/UNIXToolkit' name: 'load_gtk()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_load_gtk_icon: this _: a1

    <javanative: 'sun/awt/UNIXToolkit' name: 'load_gtk_icon(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_load_stock_icon: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/awt/UNIXToolkit' name: 'load_stock_icon(ILjava/lang/String;IILjava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_nativeSync: this

    <javanative: 'sun/awt/UNIXToolkit' name: 'nativeSync()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_UNIXToolkit_unload_gtk: this

    <javanative: 'sun/awt/UNIXToolkit' name: 'unload_gtk()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_createBackBuffer: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'createBackBuffer(JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_destroyBackBuffer: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'destroyBackBuffer(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_dispose: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'dispose(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_getNumColors: this

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'getNumColors()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_getXResolution: this _: a1

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'getXResolution(I)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_getYResolution: this _: a1

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'getYResolution(I)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_init: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'init(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_initIDs: this

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_isTranslucencyCapable: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'isTranslucencyCapable(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_makeColorModel: this

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'makeColorModel()Ljava/awt/image/ColorModel;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_pGetBounds: this _: a1

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'pGetBounds(I)Ljava/awt/Rectangle;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsConfig_swapBuffers: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11GraphicsConfig' name: 'swapBuffers(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_configDisplayMode: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'configDisplayMode(IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_enterFullScreenExclusive: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'enterFullScreenExclusive(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_enumDisplayModes: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'enumDisplayModes(ILjava/util/ArrayList;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_exitFullScreenExclusive: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'exitFullScreenExclusive(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getConfigColormap: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getConfigColormap(II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getConfigDepth: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getConfigDepth(II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getConfigVisualId: this _: a1 _: a2

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getConfigVisualId(II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getCurrentDisplayMode: this _: a1

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getCurrentDisplayMode(I)Ljava/awt/DisplayMode;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getDisplay: this

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getDisplay()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getDoubleBufferVisuals: this _: a1

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getDoubleBufferVisuals(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_getNumConfigs: this _: a1

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'getNumConfigs(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_initIDs: this

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_initXrandrExtension: this

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'initXrandrExtension()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_isDBESupported: this

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'isDBESupported()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsDevice_resetNativeData: this _: a1

    <javanative: 'sun/awt/X11GraphicsDevice' name: 'resetNativeData(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_checkShmExt: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'checkShmExt()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_getDefaultScreenNum: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'getDefaultScreenNum()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_getDisplayString: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'getDisplayString()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_getNumScreens: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'getNumScreens()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_getXineramaCenterPoint: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'getXineramaCenterPoint()Ljava/awt/Point;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_initDisplay: this _: a1

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'initDisplay(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_initGLX: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'initGLX()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_initXRender: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'initXRender()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11GraphicsEnvironment_pRunningXinerama: this

    <javanative: 'sun/awt/X11GraphicsEnvironment' name: 'pRunningXinerama()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_disposeXIC: this

    <javanative: 'sun/awt/X11InputMethod' name: 'disposeXIC()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_initIDs: this

    <javanative: 'sun/awt/X11InputMethod' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_isCompositionEnabledNative: this

    <javanative: 'sun/awt/X11InputMethod' name: 'isCompositionEnabledNative()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_resetXIC: this

    <javanative: 'sun/awt/X11InputMethod' name: 'resetXIC()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_setCompositionEnabledNative: this _: a1

    <javanative: 'sun/awt/X11InputMethod' name: 'setCompositionEnabledNative(Z)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11InputMethod_turnoffStatusWindow: this

    <javanative: 'sun/awt/X11InputMethod' name: 'turnoffStatusWindow()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.awt.X11'!

_sun_awt_X11_XDesktopPeer_gnome_url_show: this _: a1

    <javanative: 'sun/awt/X11/XDesktopPeer' name: 'gnome_url_show([B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XDesktopPeer_init: this

    <javanative: 'sun/awt/X11/XDesktopPeer' name: 'init()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XFontPeer_initIDs: this

    <javanative: 'sun/awt/X11/XFontPeer' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XInputMethod_adjustStatusWindow: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XInputMethod' name: 'adjustStatusWindow(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XInputMethod_createXICNative: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XInputMethod' name: 'createXICNative(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XInputMethod_openXIMNative: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XInputMethod' name: 'openXIMNative(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XInputMethod_setXICFocusNative: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XInputMethod' name: 'setXICFocusNative(JZZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_getRGBPixelsImpl: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'getRGBPixelsImpl(Lsun/awt/X11GraphicsConfig;IIII[I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_keyPressImpl: this _: a1

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'keyPressImpl(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_keyReleaseImpl: this _: a1

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'keyReleaseImpl(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_mouseMoveImpl: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'mouseMoveImpl(Lsun/awt/X11GraphicsConfig;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_mousePressImpl: this _: a1

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'mousePressImpl(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_mouseReleaseImpl: this _: a1

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'mouseReleaseImpl(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_mouseWheelImpl: this _: a1

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'mouseWheelImpl(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XRobotPeer_setup: this

    <javanative: 'sun/awt/X11/XRobotPeer' name: 'setup()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_awt_output_flush: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'awt_output_flush()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_awt_toolkit_init: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'awt_toolkit_init()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_getDefaultScreenData: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'getDefaultScreenData()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_getDefaultXColormap: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'getDefaultXColormap()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_getEnv: this _: a1

    <javanative: 'sun/awt/X11/XToolkit' name: 'getEnv(Ljava/lang/String;)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_initIDs: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_nativeLoadSystemColors: this _: a1

    <javanative: 'sun/awt/X11/XToolkit' name: 'nativeLoadSystemColors([I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_waitForEvents: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XToolkit' name: 'waitForEvents(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XToolkit_wakeup_poll: this

    <javanative: 'sun/awt/X11/XToolkit' name: 'wakeup_poll()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindowPeer_getJvmPID: this

    <javanative: 'sun/awt/X11/XWindowPeer' name: 'getJvmPID()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindowPeer_getLocalHostname: this

    <javanative: 'sun/awt/X11/XWindowPeer' name: 'getLocalHostname()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getAWTKeyCodeForKeySym: this _: a1

    <javanative: 'sun/awt/X11/XWindow' name: 'getAWTKeyCodeForKeySym(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getKeySymForAWTKeyCode: this _: a1

    <javanative: 'sun/awt/X11/XWindow' name: 'getKeySymForAWTKeyCode(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getNativeColor: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XWindow' name: 'getNativeColor(Ljava/awt/Color;Ljava/awt/GraphicsConfiguration;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getTopWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XWindow' name: 'getTopWindow(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getWMInsets: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/awt/X11/XWindow' name: 'getWMInsets(JJJJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_getWindowBounds: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/awt/X11/XWindow' name: 'getWindowBounds(JJJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_haveCurrentX11InputMethodInstance: this

    <javanative: 'sun/awt/X11/XWindow' name: 'haveCurrentX11InputMethodInstance()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_initIDs: this

    <javanative: 'sun/awt/X11/XWindow' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XWindow_x11inputMethodLookupString: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XWindow' name: 'x11inputMethodLookupString(J[J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_CallErrorHandler: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'CallErrorHandler(JJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DefaultScreen: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DefaultScreen(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DisplayHeight: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DisplayHeight(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DisplayHeightMM: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DisplayHeightMM(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DisplayWidth: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DisplayWidth(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DisplayWidthMM: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DisplayWidthMM(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_DoesBackingStore: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'DoesBackingStore(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_ExitSecondaryLoop: this

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'ExitSecondaryLoop()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_GetProperty: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'GetProperty(JJJ)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_InternAtom: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'InternAtom(JLjava/lang/String;I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_IsKeypadKey: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'IsKeypadKey(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_PrintXErrorEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'PrintXErrorEvent(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_RootWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'RootWindow(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_ScreenCount: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'ScreenCount(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_ScreenOfDisplay: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'ScreenOfDisplay(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_ServerVendor: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'ServerVendor(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_SetBitmapShape: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'SetBitmapShape(JJII[I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_SetProperty: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'SetProperty(JJJLjava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_SetRectangularShape: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'SetRectangularShape(JJIIIILsun/java2d/pipe/Region;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_SetToolkitErrorHandler: this

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'SetToolkitErrorHandler()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_VendorRelease: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'VendorRelease(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XAllocColor: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XAllocColor(JJJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XAllocSizeHints: this

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XAllocSizeHints()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XAllocWMHints: this

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XAllocWMHints()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XBell: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XBell(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XChangeActivePointerGrab: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XChangeActivePointerGrab(JIJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XChangePropertyImpl: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XChangePropertyImpl(JJJJIIJI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XChangePropertyS: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XChangePropertyS(JJJJIILjava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XChangeWindowAttributes: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XChangeWindowAttributes(JJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XClearWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XClearWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCloseDisplay: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCloseDisplay(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XConfigureWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XConfigureWindow(JJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XConvertCase: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XConvertCase(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XConvertSelection: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XConvertSelection(JJJJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreateBitmapFromData: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreateBitmapFromData(JJJII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreateFontCursor: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreateFontCursor(JI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreateGC: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreateGC(JJJJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreateImage: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreateImage(JJIIIJIIII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreatePixmap: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreatePixmap(JJIII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreatePixmapCursor: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreatePixmapCursor(JJJJJII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XCreateWindow: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XCreateWindow(JJIIIIIIJJJJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XDeleteProperty: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XDeleteProperty(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XDestroyImage: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XDestroyImage(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XDestroyWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XDestroyWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XDisplayString: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XDisplayString(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XEventsQueued: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XEventsQueued(JI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFilterEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFilterEvent(JJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFlush: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFlush(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFree: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFree(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFreeCursor: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFreeCursor(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFreeGC: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFreeGC(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFreeModifiermap: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFreeModifiermap(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XFreePixmap: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XFreePixmap(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetAtomName: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetAtomName(JJ)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetDefault: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetDefault(JLjava/lang/String;Ljava/lang/String;)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetGeometry: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetGeometry(JJJJJJJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetIconSizes: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetIconSizes(JJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetInputFocus: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetInputFocus(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetModifierMapping: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetModifierMapping(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetPointerMapping: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetPointerMapping(JJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetSelectionOwner: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetSelectionOwner(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetVisualInfo: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetVisualInfo(JJJJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetWMHints: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetWMHints(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetWMNormalHints: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetWMNormalHints(JJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetWindowAttributes: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetWindowAttributes(JJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGetWindowProperty: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGetWindowProperty(JJJJJJJJJJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGrabKeyboard: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGrabKeyboard(JJIIIJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGrabPointer: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGrabPointer(JJIIIIJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XGrabServer: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XGrabServer(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XIconifyWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XIconifyWindow(JJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XInternAtoms: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XInternAtoms(J[Ljava/lang/String;ZJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XKeycodeToKeysym: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XKeycodeToKeysym(JII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XKeysymToKeycode: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XKeysymToKeycode(JJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XLowerWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XLowerWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMapRaised: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMapRaised(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMapWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMapWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMaskEvent: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMaskEvent(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMaxRequestSize: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMaxRequestSize(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMoveResizeWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMoveResizeWindow(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XMoveWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XMoveWindow(JJII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XNextEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XNextEvent(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XNextSecondaryLoopEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XNextSecondaryLoopEvent(JJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XOpenDisplay: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XOpenDisplay(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XPeekEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XPeekEvent(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XPutBackEvent: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XPutBackEvent(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XPutImage: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XPutImage(JJJJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XQueryBestCursor: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XQueryBestCursor(JJIIJJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XQueryExtension: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XQueryExtension(JLjava/lang/String;JJJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XQueryPointer: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XQueryPointer(JJJJJJJJJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XQueryTree: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XQueryTree(JJJJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XRaiseWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XRaiseWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XReparentWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XReparentWindow(JJJII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XResizeWindow: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XResizeWindow(JJII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XRestackWindows: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XRestackWindows(JJI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XScreenNumberOfScreen: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XScreenNumberOfScreen(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSelectInput: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSelectInput(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSendEvent: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSendEvent(JJZJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetCloseDownMode: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetCloseDownMode(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetErrorHandler: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetErrorHandler(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetInputFocus2: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetInputFocus2(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetInputFocus: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetInputFocus(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetLocaleModifiers: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetLocaleModifiers(Ljava/lang/String;)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetMinMaxHints: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetMinMaxHints(JJIIIIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetSelectionOwner: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetSelectionOwner(JJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetTransientFor: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetTransientFor(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetWMHints: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetWMHints(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetWMNormalHints: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetWMNormalHints(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetWindowBackground: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetWindowBackground(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSetWindowBackgroundPixmap: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSetWindowBackgroundPixmap(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XShapeQueryExtension: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XShapeQueryExtension(JJJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSupportsLocale: this

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSupportsLocale()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSync: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSync(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XSynchronize: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XSynchronize(JZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XTextPropertyToStringList: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XTextPropertyToStringList([BJ)[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XTranslateCoordinates: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XTranslateCoordinates(JJJJJJJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XUngrabKeyboard: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XUngrabKeyboard(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XUngrabPointer: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XUngrabPointer(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XUngrabServer: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XUngrabServer(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XUnmapWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XUnmapWindow(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XWindowEvent: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XWindowEvent(JJJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeAllocateBackBufferName: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeAllocateBackBufferName(JJI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeBeginIdiom: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeBeginIdiom(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeDeallocateBackBufferName: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeDeallocateBackBufferName(JJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeEndIdiom: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeEndIdiom(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeQueryExtension: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeQueryExtension(JJJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_XdbeSwapBuffers: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'XdbeSwapBuffers(JJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_copyIntArray: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'copyIntArray(JLjava/lang/Object;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_copyLongArray: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'copyLongArray(JLjava/lang/Object;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_getAddress: this _: a1

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'getAddress(Ljava/lang/Object;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_getScreenOfWindow: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'getScreenOfWindow(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_getStringBytes: this _: a1 _: a2

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'getStringBytes(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_X11_XlibWrapper_memcpy: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/awt/X11/XlibWrapper' name: 'memcpy(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.awt.image'!

_sun_awt_image_BufImgSurfaceData_freeNativeICMData: this _: a1 _: a2

    <javanative: 'sun/awt/image/BufImgSurfaceData' name: 'freeNativeICMData(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_BufImgSurfaceData_initIDs: this _: a1 _: a2

    <javanative: 'sun/awt/image/BufImgSurfaceData' name: 'initIDs(Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_BufImgSurfaceData_initRaster: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/awt/image/BufImgSurfaceData' name: 'initRaster(Ljava/lang/Object;IIIIIILjava/awt/image/IndexColorModel;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ByteComponentRaster_initIDs: this

    <javanative: 'sun/awt/image/ByteComponentRaster' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_BytePackedRaster_initIDs: this

    <javanative: 'sun/awt/image/BytePackedRaster' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_DataBufferNative_getElem: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/image/DataBufferNative' name: 'getElem(IILsun/java2d/SurfaceData;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_DataBufferNative_setElem: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/image/DataBufferNative' name: 'setElem(IIILsun/java2d/SurfaceData;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_GifImageDecoder_initIDs: this

    <javanative: 'sun/awt/image/GifImageDecoder' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_GifImageDecoder_parseImage: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/image/GifImageDecoder' name: 'parseImage(IIIIZI[B[BLjava/awt/image/IndexColorModel;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImageRepresentation_initIDs: this

    <javanative: 'sun/awt/image/ImageRepresentation' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImageRepresentation_setDiffICM: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/awt/image/ImageRepresentation' name: 'setDiffICM(IIII[IIILjava/awt/image/IndexColorModel;[BIILsun/awt/image/ByteComponentRaster;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImageRepresentation_setICMpixels: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/awt/image/ImageRepresentation' name: 'setICMpixels(IIII[I[BIILsun/awt/image/IntegerComponentRaster;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_convolveBI: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/image/ImagingLib' name: 'convolveBI(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;Ljava/awt/image/Kernel;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_convolveRaster: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/image/ImagingLib' name: 'convolveRaster(Ljava/awt/image/Raster;Ljava/awt/image/Raster;Ljava/awt/image/Kernel;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_init: this

    <javanative: 'sun/awt/image/ImagingLib' name: 'init()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_lookupByteBI: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/image/ImagingLib' name: 'lookupByteBI(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;[[B)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_lookupByteRaster: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/image/ImagingLib' name: 'lookupByteRaster(Ljava/awt/image/Raster;Ljava/awt/image/Raster;[[B)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_transformBI: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/image/ImagingLib' name: 'transformBI(Ljava/awt/image/BufferedImage;Ljava/awt/image/BufferedImage;[DI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ImagingLib_transformRaster: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/image/ImagingLib' name: 'transformRaster(Ljava/awt/image/Raster;Ljava/awt/image/Raster;[DI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_IntegerComponentRaster_initIDs: this

    <javanative: 'sun/awt/image/IntegerComponentRaster' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_JPEGImageDecoder_initIDs: this _: a1

    <javanative: 'sun/awt/image/JPEGImageDecoder' name: 'initIDs(Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_JPEGImageDecoder_readImage: this _: a1 _: a2

    <javanative: 'sun/awt/image/JPEGImageDecoder' name: 'readImage(Ljava/io/InputStream;[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_image_ShortComponentRaster_initIDs: this

    <javanative: 'sun/awt/image/ShortComponentRaster' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.awt.motif'!

_sun_awt_motif_AWTLockAccess_awtLock: this

    <javanative: 'sun/awt/motif/AWTLockAccess' name: 'awtLock()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_AWTLockAccess_awtNotifyAll: this

    <javanative: 'sun/awt/motif/AWTLockAccess' name: 'awtNotifyAll()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_AWTLockAccess_awtUnlock: this

    <javanative: 'sun/awt/motif/AWTLockAccess' name: 'awtUnlock()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_AWTLockAccess_awtWait: this _: a1 _: a2

    <javanative: 'sun/awt/motif/AWTLockAccess' name: 'awtWait(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MFontPeer_initIDs: this

    <javanative: 'sun/awt/motif/MFontPeer' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkitThreadBlockedHandler_enter: this

    <javanative: 'sun/awt/motif/MToolkitThreadBlockedHandler' name: 'enter()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkitThreadBlockedHandler_exit: this

    <javanative: 'sun/awt/motif/MToolkitThreadBlockedHandler' name: 'exit()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_beep: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'beep()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getEventNumber: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getEventNumber()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getLockingKeyStateNative: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'getLockingKeyStateNative(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getMulticlickTime: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getMulticlickTime()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getNumMouseButtons: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getNumMouseButtons()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getScreenHeight: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getScreenHeight()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getScreenResolution: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getScreenResolution()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getScreenWidth: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getScreenWidth()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_getWMName: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'getWMName()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_init: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'init(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_isDynamicLayoutSupportedNative: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'isDynamicLayoutSupportedNative()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_isFrameStateSupported: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'isFrameStateSupported(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_isSyncFailed: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'isSyncFailed()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_isSyncUpdated: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'isSyncUpdated()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_loadSystemColors: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'loadSystemColors([I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_loadXSettings: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'loadXSettings()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_makeColorModel: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'makeColorModel()Ljava/awt/image/ColorModel;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_nativeGrab: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'nativeGrab(Ljava/awt/peer/WindowPeer;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_nativeUnGrab: this _: a1

    <javanative: 'sun/awt/motif/MToolkit' name: 'nativeUnGrab(Ljava/awt/peer/WindowPeer;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_run: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'run()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_shutdown: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'shutdown()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MToolkit_updateSyncSelection: this

    <javanative: 'sun/awt/motif/MToolkit' name: 'updateSyncSelection()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_MWindowAttributes_initIDs: this

    <javanative: 'sun/awt/motif/MWindowAttributes' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_X11FontMetrics_bytesWidth: this _: a1 _: a2 _: a3

    <javanative: 'sun/awt/motif/X11FontMetrics' name: 'bytesWidth([BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_X11FontMetrics_getMFCharsWidth: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/awt/motif/X11FontMetrics' name: 'getMFCharsWidth([CIILjava/awt/Font;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_X11FontMetrics_init: this

    <javanative: 'sun/awt/motif/X11FontMetrics' name: 'init()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_awt_motif_X11FontMetrics_initIDs: this

    <javanative: 'sun/awt/motif/X11FontMetrics' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.font'!

_sun_font_FileFontStrike__getGlyphImageFromWindows: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/font/FileFontStrike' name: '_getGlyphImageFromWindows(Ljava/lang/String;IIIZ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FileFontStrike_initNative: this

    <javanative: 'sun/font/FileFontStrike' name: 'initNative()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_getFont2D: this _: a1

    <javanative: 'sun/font/FontManager' name: 'getFont2D(Ljava/awt/Font;)Lsun/font/Font2D;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_getFontConfig: this _: a1 _: a2

    <javanative: 'sun/font/FontManager' name: 'getFontConfig(Ljava/lang/String;[Lsun/font/FontManager$FontConfigInfo;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_getFontConfigAASettings: this _: a1 _: a2

    <javanative: 'sun/font/FontManager' name: 'getFontConfigAASettings(Ljava/lang/String;Ljava/lang/String;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_getFontPath: this _: a1

    <javanative: 'sun/font/FontManager' name: 'getFontPath(Z)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_getPlatformFontVar: this

    <javanative: 'sun/font/FontManager' name: 'getPlatformFontVar()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_initIDs: this

    <javanative: 'sun/font/FontManager' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:56:51 / mh <hlopik@gmail.com>"
!

_sun_font_FontManager_isCreatedFont: this _: a1

    <javanative: 'sun/font/FontManager' name: 'isCreatedFont(Ljava/awt/Font;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_populateFontFileNameMap: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/font/FontManager' name: 'populateFontFileNameMap(Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/Locale;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_setCreatedFont: this _: a1

    <javanative: 'sun/font/FontManager' name: 'setCreatedFont(Ljava/awt/Font;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_setFont2D: this _: a1 _: a2

    <javanative: 'sun/font/FontManager' name: 'setFont2D(Ljava/awt/Font;Lsun/font/Font2DHandle;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FontManager_setNativeFontPath: this _: a1

    <javanative: 'sun/font/FontManager' name: 'setNativeFontPath(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_createScalerContextNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/font/FreetypeFontScaler' name: 'createScalerContextNative(J[DZIIFF)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_disposeNativeScaler: this _: a1 _: a2

    <javanative: 'sun/font/FreetypeFontScaler' name: 'disposeNativeScaler(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getFontMetricsNative: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getFontMetricsNative(Lsun/font/Font2D;JJ)Lsun/font/StrikeMetrics;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphAdvanceNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphAdvanceNative(Lsun/font/Font2D;JJI)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphCodeNative: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphCodeNative(JC)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphImageNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphImageNative(Lsun/font/Font2D;JJI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphMetricsNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphMetricsNative(Lsun/font/Font2D;JJILjava/awt/geom/Point2D$Float;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphOutlineBoundsNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphOutlineBoundsNative(Lsun/font/Font2D;JJI)Ljava/awt/geom/Rectangle2D$Float;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphOutlineNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphOutlineNative(Lsun/font/Font2D;JJIFF)Ljava/awt/geom/GeneralPath;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphPointNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphPointNative(Lsun/font/Font2D;JJII)Ljava/awt/geom/Point2D$Float;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getGlyphVectorOutlineNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getGlyphVectorOutlineNative(Lsun/font/Font2D;JJ[IIFF)Ljava/awt/geom/GeneralPath;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getLayoutTableCacheNative: this _: a1 _: a2

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getLayoutTableCacheNative(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getMissingGlyphCodeNative: this _: a1 _: a2

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getMissingGlyphCodeNative(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getNumGlyphsNative: this _: a1 _: a2

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getNumGlyphsNative(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_getUnitsPerEMNative: this _: a1 _: a2

    <javanative: 'sun/font/FreetypeFontScaler' name: 'getUnitsPerEMNative(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_FreetypeFontScaler_initIDs: this _:a1

    <javanative: 'sun/font/FreetypeFontScaler' name: 'initIDs(Ljava/lang/Class;)V'>


!

_sun_font_FreetypeFontScaler_initNativeScaler: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/font/FreetypeFontScaler' name: 'initNativeScaler(Lsun/font/Font2D;IIZI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_countGlyphs: this _: a1 _: a2

    <javanative: 'sun/font/NativeFont' name: 'countGlyphs([BI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_fontExists: this _: a1

    <javanative: 'sun/font/NativeFont' name: 'fontExists([B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_getFontMetrics: this _: a1 _: a2

    <javanative: 'sun/font/NativeFont' name: 'getFontMetrics(J)Lsun/font/StrikeMetrics;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_getGlyphAdvance: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/NativeFont' name: 'getGlyphAdvance(JI)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_getGlyphImage: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/NativeFont' name: 'getGlyphImage(JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_getGlyphImageNoDefault: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/NativeFont' name: 'getGlyphImageNoDefault(JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeFont_haveBitmapFonts: this _: a1

    <javanative: 'sun/font/NativeFont' name: 'haveBitmapFonts([B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeStrikeDisposer_freeNativeScalerContext: this _: a1 _: a2

    <javanative: 'sun/font/NativeStrikeDisposer' name: 'freeNativeScalerContext(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeStrike_createNullScalerContext: this

    <javanative: 'sun/font/NativeStrike' name: 'createNullScalerContext()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeStrike_createScalerContext: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/font/NativeStrike' name: 'createScalerContext([BID)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NativeStrike_getMaxGlyph: this _: a1 _: a2

    <javanative: 'sun/font/NativeStrike' name: 'getMaxGlyph(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NullFontScaler_getGlyphImage: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/NullFontScaler' name: 'getGlyphImage(JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_NullFontScaler_getNullScalerContext: this

    <javanative: 'sun/font/NullFontScaler' name: 'getNullScalerContext()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_StrikeCache_freeIntMemory: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/StrikeCache' name: 'freeIntMemory([IJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_StrikeCache_freeIntPointer: this _: a1

    <javanative: 'sun/font/StrikeCache' name: 'freeIntPointer(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_StrikeCache_freeLongMemory: this _: a1 _: a2 _: a3

    <javanative: 'sun/font/StrikeCache' name: 'freeLongMemory([JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_StrikeCache_freeLongPointer: this _: a1 _: a2

    <javanative: 'sun/font/StrikeCache' name: 'freeLongPointer(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_StrikeCache_getGlyphCacheDescription: this _:a1
    <javanative: 'sun/font/StrikeCache' name: 'getGlyphCacheDescription([J)V'>
    a1 at: 1 put: 4.

    "Modified: / 09-02-2012 / 22:57:08 / mh <hlopik@gmail.com>"
    "Modified: / 05-11-2012 / 17:07:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_sun_font_SunLayoutEngine_initGVIDs: this

    <javanative: 'sun/font/SunLayoutEngine' name: 'initGVIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_SunLayoutEngine_nativeLayout: this _: a1

    <javanative: 'sun/font/SunLayoutEngine' name: 'nativeLayout(Lsun/font/Font2D;Lsun/font/FontStrike;[FII[CIIIIIIILjava/awt/geom/Point2D$Float;Lsun/font/GlyphLayout$GVData;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_font_X11TextRenderer_doDrawGlyphList: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/font/X11TextRenderer' name: 'doDrawGlyphList(JJLsun/java2d/pipe/Region;Lsun/font/GlyphList;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.instrument'!

_sun_instrument_InstrumentationImpl_appendToClassLoaderSearch0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'appendToClassLoaderSearch0(JLjava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_getAllLoadedClasses0: this _: a1 _: a2

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'getAllLoadedClasses0(J)[Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_getInitiatedClasses0: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'getInitiatedClasses0(JLjava/lang/ClassLoader;)[Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_getObjectSize0: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'getObjectSize0(JLjava/lang/Object;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_isModifiableClass0: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'isModifiableClass0(JLjava/lang/Class;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_isRetransformClassesSupported0: this _: a1 _: a2

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'isRetransformClassesSupported0(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_redefineClasses0: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'redefineClasses0(J[Ljava/lang/instrument/ClassDefinition;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_retransformClasses0: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'retransformClasses0(J[Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_setHasRetransformableTransformers: this _: a1 _: a2 _: a3

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'setHasRetransformableTransformers(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_instrument_InstrumentationImpl_setNativeMethodPrefixes: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/instrument/InstrumentationImpl' name: 'setNativeMethodPrefixes(J[Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.io'!

_sun_io_Win32ErrorMode_setErrorMode: this _:a1 _: a2

    <javanative: 'sun/io/Win32ErrorMode' name: 'setErrorMode(J)J'>

    "FIXME: Ignored for now"
    ^0

    "Modified (format): / 14-08-2012 / 11:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d'!

_sun_java2d_DefaultDisposerRecord_invokeNativeDispose: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/DefaultDisposerRecord' name: 'invokeNativeDispose(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_Disposer_initIDs: this

    <javanative: 'sun/java2d/Disposer' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:54:59 / mh <hlopik@gmail.com>"
!

_sun_java2d_SurfaceData_initIDs: this

    <javanative: 'sun/java2d/SurfaceData' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_SurfaceData_isOpaqueGray: this _: a1

    <javanative: 'sun/java2d/SurfaceData' name: 'isOpaqueGray(Ljava/awt/image/IndexColorModel;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.cmm.lcms'!

_sun_java2d_cmm_lcms_LCMS_colorConvert: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'colorConvert(Lsun/java2d/cmm/lcms/LCMSTransform;Lsun/java2d/cmm/lcms/LCMSImageLayout;Lsun/java2d/cmm/lcms/LCMSImageLayout;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_createNativeTransform: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'createNativeTransform([JILjava/lang/Object;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_freeProfile: this _: a1 _: a2

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'freeProfile(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_freeTransform: this _: a1 _: a2

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'freeTransform(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_getProfileData: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'getProfileData(J[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_getProfileID: this _: a1

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'getProfileID(Ljava/awt/color/ICC_Profile;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_getProfileSize: this _: a1 _: a2

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'getProfileSize(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_cmm_lcms_LCMS_getTagData: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'getTagData(JI[B)V'>

    | profileId tag data |

    profileId := a1.
    tag := a3.
    data := a4.

    self assert: a1 = 12344321.

    tag = 1751474532 ifTrue:[
        data replaceBytesFrom:1
                with:#[0  3  146  96  108  99  109  115  4  0  0  0  115  112  97  99  51  67  76  82  88  89  90  32  7  216  0  4  0  10  0  10  0  24  0  22  97  99  115  112  65  80  80  76  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  1  0  0  246  214  0  1  0  0  0  0  211  45  108  99  109  115  240  231  92  85  210  30  77  140  137  67  22  250  239  246  146  191  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0]
                startingAt: 1.
        ^self.
    ].

    self breakPoint: #jv.

    "Modified: / 18-04-2012 / 08:29:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_java2d_cmm_lcms_LCMS_getTagSize: this _:a1 _: a2 _: a3

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'getTagSize(JI)I'>

    | profileId tag |
    profileId := a1.
    tag := a3.

    self assert: a1 = 12344321.

    "Magic numbers based on trace of real Java code"

    tag = 1751474532 ifTrue:[ ^ 128 ].


    self breakPoint: #jv.

    ^128 "Some magic default"

    "Modified: / 18-04-2012 / 08:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_java2d_cmm_lcms_LCMS_initLCMS: this _:a1 _: a2 _: a3

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'initLCMS(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;)V'>

    "Nothing to do"

    "Modified: / 09-12-2011 / 18:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_java2d_cmm_lcms_LCMS_loadProfile: this _:a1

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'loadProfile([B)J'>

    "FAKE, return some magic"
    ^12344321

    "Modified: / 09-12-2011 / 18:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_java2d_cmm_lcms_LCMS_setTagData: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/cmm/lcms/LCMS' name: 'setTagData(JI[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.jules'!

_sun_java2d_jules_JulesAATileGenerator_freePixmanImgPtr: this _: a1 _: a2

    <javanative: 'sun/java2d/jules/JulesAATileGenerator' name: 'freePixmanImgPtr(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_jules_JulesAATileGenerator_rasterizeTrapezoidsNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/jules/JulesAATileGenerator' name: 'rasterizeTrapezoidsNative(J[I[II[BII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_jules_JulesPathBuf_tesselateFillNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'sun/java2d/jules/JulesPathBuf' name: 'tesselateFillNative([I[BII[IIIIIII)[I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_jules_JulesPathBuf_tesselateStrokeNative: this _: a1

    <javanative: 'sun/java2d/jules/JulesPathBuf' name: 'tesselateStrokeNative([I[BII[IIDIID[DIDDDDDDDIIII)[I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.loops'!

_sun_java2d_loops_BlitBg_BlitBg: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'sun/java2d/loops/BlitBg' name: 'BlitBg(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;IIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_Blit_Blit: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/loops/Blit' name: 'Blit(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawGlyphListAA_DrawGlyphListAA: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/loops/DrawGlyphListAA' name: 'DrawGlyphListAA(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;Lsun/font/GlyphList;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawGlyphListLCD_DrawGlyphListLCD: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/loops/DrawGlyphListLCD' name: 'DrawGlyphListLCD(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;Lsun/font/GlyphList;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawGlyphList_DrawGlyphList: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/loops/DrawGlyphList' name: 'DrawGlyphList(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;Lsun/font/GlyphList;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawLine_DrawLine: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/loops/DrawLine' name: 'DrawLine(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawParallelogram_DrawParallelogram: this _: a1

    <javanative: 'sun/java2d/loops/DrawParallelogram' name: 'DrawParallelogram(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;DDDDDDDD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawPath_DrawPath: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/loops/DrawPath' name: 'DrawPath(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IILjava/awt/geom/Path2D$Float;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawPolygons_DrawPolygons: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/loops/DrawPolygons' name: 'DrawPolygons(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;[I[I[IIIIZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_DrawRect_DrawRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/loops/DrawRect' name: 'DrawRect(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_FillParallelogram_FillParallelogram: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14

    <javanative: 'sun/java2d/loops/FillParallelogram' name: 'FillParallelogram(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;DDDDDD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_FillPath_FillPath: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/loops/FillPath' name: 'FillPath(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IILjava/awt/geom/Path2D$Float;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_FillRect_FillRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/loops/FillRect' name: 'FillRect(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_FillSpans_FillSpans: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/loops/FillSpans' name: 'FillSpans(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;IJLsun/java2d/pipe/SpanIterator;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_GraphicsPrimitiveMgr_initIDs: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11

    <javanative: 'sun/java2d/loops/GraphicsPrimitiveMgr' name: 'initIDs(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_GraphicsPrimitiveMgr_registerNativeLoops: this

    <javanative: 'sun/java2d/loops/GraphicsPrimitiveMgr' name: 'registerNativeLoops()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_MaskBlit_MaskBlit: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/java2d/loops/MaskBlit' name: 'MaskBlit(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;IIIIII[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_MaskFill_DrawAAPgram: this _: a1

    <javanative: 'sun/java2d/loops/MaskFill' name: 'DrawAAPgram(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;Ljava/awt/Composite;DDDDDDDD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_MaskFill_MaskFill: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/loops/MaskFill' name: 'MaskFill(Lsun/java2d/SunGraphics2D;Lsun/java2d/SurfaceData;Ljava/awt/Composite;IIII[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_ScaledBlit_Scale: this _: a1

    <javanative: 'sun/java2d/loops/ScaledBlit' name: 'Scale(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;IIIIDDDD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_TransformBlit_Transform: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/java2d/loops/TransformBlit' name: 'Transform(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;Ljava/awt/geom/AffineTransform;IIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_loops_TransformHelper_Transform: this _: a1

    <javanative: 'sun/java2d/loops/TransformHelper' name: 'Transform(Lsun/java2d/loops/MaskBlit;Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Ljava/awt/Composite;Lsun/java2d/pipe/Region;Ljava/awt/geom/AffineTransform;IIIIIIIII[III)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.opengl'!

_sun_java2d_opengl_GLXGraphicsConfig_getGLXConfigInfo: this _: a1 _: a2

    <javanative: 'sun/java2d/opengl/GLXGraphicsConfig' name: 'getGLXConfigInfo(II)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_GLXGraphicsConfig_getOGLCapabilities: this _: a1 _: a2

    <javanative: 'sun/java2d/opengl/GLXGraphicsConfig' name: 'getOGLCapabilities(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_GLXGraphicsConfig_initConfig: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/opengl/GLXGraphicsConfig' name: 'initConfig(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_GLXSurfaceData_initOps: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/opengl/GLXSurfaceData' name: 'initOps(Lsun/awt/X11ComponentPeer;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_GLXSurfaceData_initPbuffer: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/opengl/GLXSurfaceData' name: 'initPbuffer(JJZII)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLContext_getOGLIdString: this

    <javanative: 'sun/java2d/opengl/OGLContext' name: 'getOGLIdString()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLMaskFill_maskFill: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/opengl/OGLMaskFill' name: 'maskFill(IIIIIII[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLRenderQueue_flushBuffer: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/opengl/OGLRenderQueue' name: 'flushBuffer(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLRenderer_drawPoly: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/opengl/OGLRenderer' name: 'drawPoly([I[IIZII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLSurfaceData_getTextureID: this _: a1 _: a2

    <javanative: 'sun/java2d/opengl/OGLSurfaceData' name: 'getTextureID(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLSurfaceData_getTextureTarget: this _: a1 _: a2

    <javanative: 'sun/java2d/opengl/OGLSurfaceData' name: 'getTextureTarget(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLSurfaceData_initFBObject: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/opengl/OGLSurfaceData' name: 'initFBObject(JZZZII)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLSurfaceData_initFlipBackbuffer: this _: a1 _: a2

    <javanative: 'sun/java2d/opengl/OGLSurfaceData' name: 'initFlipBackbuffer(J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLSurfaceData_initTexture: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/opengl/OGLSurfaceData' name: 'initTexture(JZZZII)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_opengl_OGLTextRenderer_drawGlyphList: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/opengl/OGLTextRenderer' name: 'drawGlyphList(IZZZIFF[J[F)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.pipe'!

_sun_java2d_pipe_BufferedMaskBlit_enqueueTile: this _: a1

    <javanative: 'sun/java2d/pipe/BufferedMaskBlit' name: 'enqueueTile(JILsun/java2d/SurfaceData;JI[BIIIIIIIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_BufferedRenderPipe_fillSpans: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/pipe/BufferedRenderPipe' name: 'fillSpans(Lsun/java2d/pipe/RenderQueue;JIILsun/java2d/pipe/SpanIterator;JII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_Region_initIDs: this

    <javanative: 'sun/java2d/pipe/Region' name: 'initIDs()V'>

    "Modified: / 09-02-2012 / 22:55:09 / mh <hlopik@gmail.com>"
!

_sun_java2d_pipe_RenderBuffer_copyFromArray: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/pipe/RenderBuffer' name: 'copyFromArray(Ljava/lang/Object;JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_addSegment: this _: a1 _: a2

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'addSegment(I[F)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_appendPoly: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'appendPoly([I[IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_closePath: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'closePath()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_curveTo: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'curveTo(FFFFFF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_dispose: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'dispose()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_getNativeConsumer: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'getNativeConsumer()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_getNativeIterator: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'getNativeIterator()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_getPathBox: this _: a1

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'getPathBox([I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_initIDs: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_intersectClipBox: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'intersectClipBox(IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_lineTo: this _: a1 _: a2

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'lineTo(FF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_moveTo: this _: a1 _: a2

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'moveTo(FF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_nextSpan: this _: a1

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'nextSpan([I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_pathDone: this

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'pathDone()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_quadTo: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'quadTo(FFFF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_setNormalize: this _: a1

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'setNormalize(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_setOutputAreaXYXY: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'setOutputAreaXYXY(IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_setRule: this _: a1

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'setRule(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_ShapeSpanIterator_skipDownTo: this _: a1

    <javanative: 'sun/java2d/pipe/ShapeSpanIterator' name: 'skipDownTo(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_SpanClipRenderer_eraseTile: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/pipe/SpanClipRenderer' name: 'eraseTile(Lsun/java2d/pipe/RegionIterator;[BII[I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_SpanClipRenderer_fillTile: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/pipe/SpanClipRenderer' name: 'fillTile(Lsun/java2d/pipe/RegionIterator;[BII[I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_pipe_SpanClipRenderer_initIDs: this _: a1 _: a2

    <javanative: 'sun/java2d/pipe/SpanClipRenderer' name: 'initIDs(Ljava/lang/Class;Ljava/lang/Class;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.x11'!

_sun_java2d_x11_X11PMBlitBgLoops_nativeBlitBg: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/java2d/x11/X11PMBlitBgLoops' name: 'nativeBlitBg(JJJIIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11PMBlitLoops_nativeBlit: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13

    <javanative: 'sun/java2d/x11/X11PMBlitLoops' name: 'nativeBlit(JJJLsun/java2d/pipe/Region;IIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11PMBlitLoops_updateBitmask: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/x11/X11PMBlitLoops' name: 'updateBitmask(Lsun/java2d/SurfaceData;Lsun/java2d/SurfaceData;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDoPath: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDoPath(Lsun/java2d/SunGraphics2D;JJIILjava/awt/geom/Path2D$Float;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawArc: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawArc(JJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawLine: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawLine(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawOval: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawOval(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawPoly: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawPoly(JJII[I[IIZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawRect(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XDrawRoundRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XDrawRoundRect(JJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillArc: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillArc(JJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillOval: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillOval(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillPoly: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillPoly(JJII[I[II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillRect(JJIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillRoundRect: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillRoundRect(JJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_XFillSpans: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'XFillSpans(JJLsun/java2d/pipe/SpanIterator;JII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11Renderer_devCopyArea: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/x11/X11Renderer' name: 'devCopyArea(JJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_XSetCopyMode: this _: a1 _: a2

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'XSetCopyMode(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_XSetForeground: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'XSetForeground(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_XSetXorMode: this _: a1 _: a2

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'XSetXorMode(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_initIDs: this _: a1 _: a2

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'initIDs(Ljava/lang/Class;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_initSurface: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'initSurface(IIIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_isDgaAvailable: this

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'isDgaAvailable()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_X11SurfaceData_isShmPMAvailable: this

    <javanative: 'sun/java2d/x11/X11SurfaceData' name: 'isShmPMAvailable()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_XCreateGC: this _: a1 _: a2

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'XCreateGC(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_XResetClip: this _: a1 _: a2

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'XResetClip(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_XSetClip: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'XSetClip(JIIIILsun/java2d/pipe/Region;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_XSetGraphicsExposures: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'XSetGraphicsExposures(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_flushNativeSurface: this

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'flushNativeSurface()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_initOps: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'initOps(Lsun/awt/X11ComponentPeer;Lsun/awt/X11GraphicsConfig;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_isDrawableValid: this

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'isDrawableValid()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_x11_XSurfaceData_setInvalid: this

    <javanative: 'sun/java2d/x11/XSurfaceData' name: 'setInvalid()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.java2d.xr'!

_sun_java2d_xr_XIDGenerator_bufferXIDs: this _: a1 _: a2

    <javanative: 'sun/java2d/xr/XIDGenerator' name: 'bufferXIDs([II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_GCRectanglesNative: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'GCRectanglesNative(IJ[II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRAddGlyphsNative: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRAddGlyphsNative(I[JI[BI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRCreateLinearGradientPaintNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRCreateLinearGradientPaintNative([F[SIIIIIIIIIIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRCreateRadialGradientPaintNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRCreateRadialGradientPaintNative([F[SIIIIIIIIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRFreeGlyphsNative: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRFreeGlyphsNative(I[II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRSetClipNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRSetClipNative(JIIIILsun/java2d/pipe/Region;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRSetTransformNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRSetTransformNative(IIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRenderCompositeTextNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRenderCompositeTextNative(IIIJ[I[III)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRenderCreateGlyphSetNative: this _: a1 _: a2

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRenderCreateGlyphSetNative(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_XRenderRectanglesNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'XRenderRectanglesNative(IBSSSS[II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_copyArea: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'copyArea(IIJIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_createGC: this _: a1

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'createGC(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_createPictureNative: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'createPictureNative(IJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_createPixmap: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'createPixmap(IIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_freeGC: this _: a1 _: a2

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'freeGC(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_freePicture: this _: a1

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'freePicture(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_freePixmap: this _: a1

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'freePixmap(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_initIDs: this

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_padBlitNative: this _: a1

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'padBlitNative(BIIIIIIIIIIIIIIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_renderComposite: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'renderComposite(BIIIIIIIIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_renderCompositeTrapezoidsNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'renderCompositeTrapezoidsNative(BIJIII[I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_renderRectangle: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'renderRectangle(IBSSSSIIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_setFilter: this _: a1 _: a2

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'setFilter(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_setGCExposures: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'setGCExposures(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_setGCForeground: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'setGCForeground(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_setGCMode: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'setGCMode(JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRBackendNative_setPictureRepeat: this _: a1 _: a2

    <javanative: 'sun/java2d/xr/XRBackendNative' name: 'setPictureRepeat(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRMaskBlit_maskBlit: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14

    <javanative: 'sun/java2d/xr/XRMaskBlit' name: 'maskBlit(JJIIIIIIIII[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRMaskFill_maskFill: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10

    <javanative: 'sun/java2d/xr/XRMaskFill' name: 'maskFill(JIIIIIII[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRSurfaceData_XRInitSurface: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/java2d/xr/XRSurfaceData' name: 'XRInitSurface(IIIJI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRSurfaceData_initIDs: this

    <javanative: 'sun/java2d/xr/XRSurfaceData' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_java2d_xr_XRSurfaceData_initXRPicture: this _: a1 _: a2 _: a3

    <javanative: 'sun/java2d/xr/XRSurfaceData' name: 'initXRPicture(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.jkernel'!

_sun_jkernel_DownloadManager_addToTotalDownloadSize: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'addToTotalDownloadSize(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_askUserToRetryDownloadOrQuit: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'askUserToRetryDownloadOrQuit(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_bundleInstallComplete: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'bundleInstallComplete()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_bundleInstallStart: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'bundleInstallStart()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_displayError: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'displayError(ILjava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_downloadFromURLImpl: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/jkernel/DownloadManager' name: 'downloadFromURLImpl(Ljava/lang/String;Ljava/io/File;Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getCurrentProcessId: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getCurrentProcessId()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getDebugKey: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getDebugKey()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getUrlFromRegistry: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getUrlFromRegistry()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getVisitorId0: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getVisitorId0()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isIEProtectedMode: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isIEProtectedMode()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isJBrokerRunning: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isJBrokerRunning()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isWindowsVista: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isWindowsVista()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_launchJBroker: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'launchJBroker(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_moveDirWithBrokerImpl: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'moveDirWithBrokerImpl(Ljava/lang/String;Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_moveFileWithBrokerImpl: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'moveFileWithBrokerImpl(Ljava/lang/String;Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_postDownloadComplete: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'postDownloadComplete()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_postDownloadError: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'postDownloadError(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_startBackgroundDownloadWithBrokerImpl: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'startBackgroundDownloadWithBrokerImpl(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.management'!

_sun_management_ClassLoadingImpl_setVerboseClass: this _: a1

    <javanative: 'sun/management/ClassLoadingImpl' name: 'setVerboseClass(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_FileSystemImpl_isAccessUserOnly0: this _: a1

    <javanative: 'sun/management/FileSystemImpl' name: 'isAccessUserOnly0(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_getAllFlagNames: this

    <javanative: 'sun/management/Flag' name: 'getAllFlagNames()[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_getFlags: this _: a1 _: a2 _: a3

    <javanative: 'sun/management/Flag' name: 'getFlags([Ljava/lang/String;[Lsun/management/Flag;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_getInternalFlagCount: this

    <javanative: 'sun/management/Flag' name: 'getInternalFlagCount()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_initialize: this

    <javanative: 'sun/management/Flag' name: 'initialize()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_setBooleanValue: this _: a1 _: a2

    <javanative: 'sun/management/Flag' name: 'setBooleanValue(Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_setLongValue: this _: a1 _: a2 _: a3

    <javanative: 'sun/management/Flag' name: 'setLongValue(Ljava/lang/String;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_Flag_setStringValue: this _: a1 _: a2

    <javanative: 'sun/management/Flag' name: 'setStringValue(Ljava/lang/String;Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_GarbageCollectorImpl_getCollectionCount: this

    <javanative: 'sun/management/GarbageCollectorImpl' name: 'getCollectionCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_GarbageCollectorImpl_getCollectionTime: this

    <javanative: 'sun/management/GarbageCollectorImpl' name: 'getCollectionTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_GcInfoBuilder_fillGcAttributeInfo: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/management/GcInfoBuilder' name: 'fillGcAttributeInfo(Ljava/lang/management/GarbageCollectorMXBean;I[Ljava/lang/String;[C[Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_GcInfoBuilder_getLastGcInfo0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/management/GcInfoBuilder' name: 'getLastGcInfo0(Ljava/lang/management/GarbageCollectorMXBean;I[Ljava/lang/Object;[C[Ljava/lang/management/MemoryUsage;[Ljava/lang/management/MemoryUsage;)Lcom/sun/management/GcInfo;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_GcInfoBuilder_getNumGcExtAttributes: this _: a1

    <javanative: 'sun/management/GcInfoBuilder' name: 'getNumGcExtAttributes(Ljava/lang/management/GarbageCollectorMXBean;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_HotSpotDiagnostic_dumpHeap0: this _: a1 _: a2

    <javanative: 'sun/management/HotSpotDiagnostic' name: 'dumpHeap0(Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_HotSpotDiagnostic_dumpHeap: this _: a1 _: a2

    <javanative: 'sun/management/HotSpotDiagnostic' name: 'dumpHeap(Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_HotspotThread_getInternalThreadCount: this

    <javanative: 'sun/management/HotspotThread' name: 'getInternalThreadCount()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_HotspotThread_getInternalThreadTimes0: this _: a1 _: a2

    <javanative: 'sun/management/HotspotThread' name: 'getInternalThreadTimes0([Ljava/lang/String;[J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryImpl_getMemoryManagers0: this

    <javanative: 'sun/management/MemoryImpl' name: 'getMemoryManagers0()[Ljava/lang/management/MemoryManagerMXBean;'>

    "HACK, we'll see"

    | beanCls |
    beanCls := JavaVM classForName:'java.lang.management.MemoryManagerMXBean'
    definedBy:nil.
    ^beanCls javaArrayClass new:0.

    "Modified: / 04-12-2011 / 19:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_management_MemoryImpl_getMemoryPools0: this

    <javanative: 'sun/management/MemoryImpl' name: 'getMemoryPools0()[Ljava/lang/management/MemoryPoolMXBean;'>

    "HACK, we'll see"

    | beanCls |
    beanCls := JavaVM classForName:'java.lang.management.MemoryPoolMXBean' definedBy:nil.
    ^beanCls javaArrayClass new:0.

    "Modified: / 04-12-2011 / 19:58:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_management_MemoryImpl_getMemoryUsage0: this _: a1

    <javanative: 'sun/management/MemoryImpl' name: 'getMemoryUsage0(Z)Ljava/lang/management/MemoryUsage;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryImpl_setVerboseGC: this _: a1

    <javanative: 'sun/management/MemoryImpl' name: 'setVerboseGC(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryManagerImpl_getMemoryPools0: this

    <javanative: 'sun/management/MemoryManagerImpl' name: 'getMemoryPools0()[Ljava/lang/management/MemoryPoolMXBean;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_getCollectionUsage0: this

    <javanative: 'sun/management/MemoryPoolImpl' name: 'getCollectionUsage0()Ljava/lang/management/MemoryUsage;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_getMemoryManagers0: this

    <javanative: 'sun/management/MemoryPoolImpl' name: 'getMemoryManagers0()[Ljava/lang/management/MemoryManagerMXBean;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_getPeakUsage0: this

    <javanative: 'sun/management/MemoryPoolImpl' name: 'getPeakUsage0()Ljava/lang/management/MemoryUsage;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_getUsage0: this

    <javanative: 'sun/management/MemoryPoolImpl' name: 'getUsage0()Ljava/lang/management/MemoryUsage;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_resetPeakUsage0: this

    <javanative: 'sun/management/MemoryPoolImpl' name: 'resetPeakUsage0()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_setCollectionThreshold0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/management/MemoryPoolImpl' name: 'setCollectionThreshold0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_setPoolCollectionSensor: this _: a1

    <javanative: 'sun/management/MemoryPoolImpl' name: 'setPoolCollectionSensor(Lsun/management/Sensor;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_setPoolUsageSensor: this _: a1

    <javanative: 'sun/management/MemoryPoolImpl' name: 'setPoolUsageSensor(Lsun/management/Sensor;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_MemoryPoolImpl_setUsageThreshold0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/management/MemoryPoolImpl' name: 'setUsageThreshold0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_dumpThreads0: this _: a1 _: a2 _: a3

    <javanative: 'sun/management/ThreadImpl' name: 'dumpThreads0([JZZ)[Ljava/lang/management/ThreadInfo;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_findDeadlockedThreads0: this

    <javanative: 'sun/management/ThreadImpl' name: 'findDeadlockedThreads0()[Ljava/lang/Thread;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_findMonitorDeadlockedThreads0: this

    <javanative: 'sun/management/ThreadImpl' name: 'findMonitorDeadlockedThreads0()[Ljava/lang/Thread;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_getThreadInfo0: this _: a1 _: a2 _: a3

    <javanative: 'sun/management/ThreadImpl' name: 'getThreadInfo0([JI[Ljava/lang/management/ThreadInfo;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_getThreadTotalCpuTime0: this _: a1 _: a2

    <javanative: 'sun/management/ThreadImpl' name: 'getThreadTotalCpuTime0(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_getThreadUserCpuTime0: this _: a1 _: a2

    <javanative: 'sun/management/ThreadImpl' name: 'getThreadUserCpuTime0(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_getThreads: this

    <javanative: 'sun/management/ThreadImpl' name: 'getThreads()[Ljava/lang/Thread;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_resetContentionTimes0: this _: a1 _: a2

    <javanative: 'sun/management/ThreadImpl' name: 'resetContentionTimes0(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_resetPeakThreadCount0: this

    <javanative: 'sun/management/ThreadImpl' name: 'resetPeakThreadCount0()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_setThreadContentionMonitoringEnabled0: this _: a1

    <javanative: 'sun/management/ThreadImpl' name: 'setThreadContentionMonitoringEnabled0(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_ThreadImpl_setThreadCpuTimeEnabled0: this _: a1

    <javanative: 'sun/management/ThreadImpl' name: 'setThreadCpuTimeEnabled0(Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getAvailableProcessors: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getAvailableProcessors()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getClassInitializationTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getClassInitializationTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getClassLoadingTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getClassLoadingTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getClassVerificationTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getClassVerificationTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getDaemonThreadCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getDaemonThreadCount()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getInitializedClassCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getInitializedClassCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getLiveThreadCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getLiveThreadCount()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getLoadedClassSize: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getLoadedClassSize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getMethodDataSize: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getMethodDataSize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getPeakThreadCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getPeakThreadCount()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getProcessId: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getProcessId()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getSafepointCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getSafepointCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getSafepointSyncTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getSafepointSyncTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getStartupTime: this
    <javanative: 'sun/management/VMManagementImpl' name: 'getStartupTime()J'>
    ^ StartupTime.

    "Modified: / 03-11-2011 / 19:17:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_sun_management_VMManagementImpl_getTotalApplicationNonStoppedTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getTotalApplicationNonStoppedTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getTotalClassCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getTotalClassCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getTotalCompileTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getTotalCompileTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getTotalSafepointTime: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getTotalSafepointTime()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getTotalThreadCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getTotalThreadCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getUnloadedClassCount: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getUnloadedClassCount()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getUnloadedClassSize: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getUnloadedClassSize()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getVerboseClass: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getVerboseClass()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getVerboseGC: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getVerboseGC()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_getVersion0: this
    <javanative: 'sun/management/VMManagementImpl' name: 'getVersion0()Ljava/lang/String;'>
    ^ Java as_String: '1.2'.

    "Modified: / 03-11-2011 / 18:42:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_sun_management_VMManagementImpl_getVmArguments0: this

    <javanative: 'sun/management/VMManagementImpl' name: 'getVmArguments0()[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_initOptionalSupportFields: this
    <javanative: 'sun/management/VMManagementImpl' name: 'initOptionalSupportFields()V'>
    | cls |
    cls := this.

    cls instVarNamed: #compTimeMonitoringSupport put: 0.
    cls instVarNamed: #threadContentionMonitoringSupport put: 0.
    cls instVarNamed: #currentThreadCpuTimeSupport put: 0.
    cls instVarNamed: #otherThreadCpuTimeSupport put: 0.
    cls instVarNamed: #bootClassPathSupport put: 0.
    cls instVarNamed: #synchronizerUsageSupport put: 0.
    cls instVarNamed: #objectMonitorUsageSupport put: 0.
    ^ self.

    "Modified: / 13-12-2011 / 14:35:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_sun_management_VMManagementImpl_isThreadContentionMonitoringEnabled: this

    <javanative: 'sun/management/VMManagementImpl' name: 'isThreadContentionMonitoringEnabled()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_management_VMManagementImpl_isThreadCpuTimeEnabled: this

    <javanative: 'sun/management/VMManagementImpl' name: 'isThreadCpuTimeEnabled()Z'>

    ^ 0 "/false should be safe, we'll see...

    "Modified: / 03-11-2011 / 22:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.misc'!

_sun_misc_GC_maxObjectInspectionAge: this

    <javanative: 'sun/misc/GC' name: 'maxObjectInspectionAge()J'>

    "
    /**
     * Returns the maximum <em>object-inspection age</em>, which is the number
     * of real-time milliseconds that have elapsed since the
     * least-recently-inspected heap object was last inspected by the garbage
     * collector.
     *
     * <p> For simple stop-the-world collectors this value is just the time
     * since the most recent collection.  For generational collectors it is the
     * time since the oldest generation was most recently collected.  Other
     * collectors are free to return a pessimistic estimate of the elapsed
     * time, or simply the time since the last full collection was performed.
     *
     * <p> Note that in the presence of reference objects, a given object that
     * is no longer strongly reachable may have to be inspected multiple times
     * before it can be reclaimed.
     */
    public static native long maxObjectInspectionAge();
    "

    ^Random nextIntegerBetween: 0 and: 3600. "Just return some number"

    "Modified: / 02-12-2011 / 21:56:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_MessageUtils_toStderr: this _: a1

    <javanative: 'sun/misc/MessageUtils' name: 'toStderr(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_MessageUtils_toStdout: this _: a1

    <javanative: 'sun/misc/MessageUtils' name: 'toStdout(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_NativeSignalHandler_handle0: this _: a1 _: a2

    <javanative: 'sun/misc/NativeSignalHandler' name: 'handle0(IJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_NativeSignalHandler_handle0: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/NativeSignalHandler' name: 'handle0(IJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_attach: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Perf' name: 'attach(Ljava/lang/String;II)Ljava/nio/ByteBuffer;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_createByteArray: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Perf' name: 'createByteArray(Ljava/lang/String;II[BI)Ljava/nio/ByteBuffer;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_createLong: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Perf' name: 'createLong(Ljava/lang/String;IIJ)Ljava/nio/ByteBuffer;'>

    | memory |

    memory := JavaVM performance counters at: (Java as_ST_String: a1) ifAbsentPut:[ ByteArray new: 8].
    ^JAVA java nio HeapByteBuffer new: memory with: 0 with: 8.

    "Modified: / 20-02-2013 / 00:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Perf_detach: this _: a1

    <javanative: 'sun/misc/Perf' name: 'detach(Ljava/nio/ByteBuffer;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_highResCounter: this

    <javanative: 'sun/misc/Perf' name: 'highResCounter()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_highResFrequency: this

    <javanative: 'sun/misc/Perf' name: 'highResFrequency()J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Perf_registerNatives: this

    <javanative: 'sun/misc/Perf' name: 'registerNatives()V'>

    "Nothing to do here"

    "Modified: / 11-02-2013 / 02:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Signal_findSignal: this _:a1

    <javanative: 'sun/misc/Signal' name: 'findSignal(Ljava/lang/String;)I'>

        | input signame |

    input := Java as_ST_String: a1.
    OperatingSystem isUNIXlike ifTrue:[
        signame := 'SIG', (input asUppercase).
        ^UnixOperatingSystem signalNamed: signame asSymbol.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        signame := 'sig', (input asUppercase).
        ^Win32OperatingSystem perform: signame asSymbol.
    ].
    self error: 'Unsupported OS'

    "Created: / 11-12-2010 / 15:22:07 / Jan Kurs <kurs.jan@post.cz>"
!

_sun_misc_Signal_handle0: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Signal' name: 'handle0(IJ)J'>

        self breakPoint: #libjava.
    ^ 0.

    "Created: / 11-12-2010 / 16:33:38 / Jan Kurs <kurs.jan@post.cz>"
!

_sun_misc_Signal_raise0: this

    <javanative: 'sun/misc/Signal' name: 'raise0(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Signal_raise0: this _: a1

    <javanative: 'sun/misc/Signal' name: 'raise0(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_addressSize: this

    <javanative: 'sun/misc/Unsafe' name: 'addressSize()I'>

    ^ExternalAddress pointerSize

    "Modified: / 10-07-2012 / 01:19:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_allocateInstance: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'allocateInstance(Ljava/lang/Class;)Ljava/lang/Object;'>

        "
    /** Allocate an instance but do not run any constructor.
        Initializes the class if it has not yet been. */
    public native Object allocateInstance(Class cls)
        throws InstantiationException;
    "
    | cls |
    cls := Reflection classForJavaClassObject: a1.
    cls classInit.
    ^cls newCleared

    "Created: / 05-02-2011 / 23:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_allocateMemory: this _:a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'allocateMemory(J)J'>


    | size |
    size := a1.
    ^SimulatedNativeMemory malloc: size.

    "Created: / 07-12-2010 / 21:04:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2010 / 23:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_arrayBaseOffset: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'arrayBaseOffset(Ljava/lang/Class;)I'>
    "
    /**
    * Report the offset of the first element in the storage allocation of a
    * given array class.  If {@link #arrayIndexScale} returns a non-zero value
    * for the same class, you may use that scale factor, together with this
    * base offset, to form new offsets to access elements of arrays of the
    * given class.
    *
    * @see #getInt(Object, long)
    * @see #putInt(Object, long, int)
    */
    public native int arrayBaseOffset(Class arrayClass);
    "

    ^ 1

    "Modified (comment): / 10-08-2011 / 01:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_arrayIndexScale: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'arrayIndexScale(Ljava/lang/Class;)I'>

    "
      /**
      * Report the scale factor for addressing elements in the storage
      * allocation of a given array class.  However, arrays of 'narrow' types
      * will generally not work properly with accessors like {@link
      * #getByte(Object, int)}, so the scale factor for such classes is reported
      * as zero.
      *
      * @see #arrayBaseOffset
      * @see #getInt(Object, long)
      * @see #putInt(Object, long, int)
      */
    public native int arrayIndexScale(Class arrayClass);
    "
    ^ 1

    "Modified: / 10-08-2011 / 01:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_compareAndSwapInt: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'compareAndSwapInt(Ljava/lang/Object;JII)Z'>

    ^self _sun_misc_Unsafe_compareAndSwapObject: this _:a1 _: a2 _: a3 _: a4 _: a5

    "Created: / 22-11-2010 / 18:40:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 13:56:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_compareAndSwapLong: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/misc/Unsafe' name: 'compareAndSwapLong(Ljava/lang/Object;JJJ)Z'>

        "
    /**
     * Atomically update Java variable to <tt>x</tt> if it is currently
     * holding <tt>expected</tt>.
     * @return <tt>true</tt> if successful
     */
    public final native boolean compareAndSwapInt(Object o, long offset,
                                                  long expected,
                                                  long new);
    "
    | o offset expected real new ok |
    o := a1.
    offset := a2.
    "offset is long, so nativeContext at:3 is dummy nil!!!!!!"
    expected := a4.
    new := a6.

    OperatingSystem blockInterrupts.
    real := o instVarAt: offset.
    (real == expected)
            ifTrue:[o instVarAt: offset put: new. ok := 1]
            ifFalse:[ok := 1].
    OperatingSystem unblockInterrupts.
    ^ok

    "Modified: / 18-10-2011 / 21:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_compareAndSwapObject: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'compareAndSwapObject(Ljava/lang/Object;JLjava/lang/Object;Ljava/lang/Object;)Z'>

        "
    /**
     * Atomically update Java variable to <tt>x</tt> if it is currently
     * holding <tt>expected</tt>.
     * @return <tt>true</tt> if successful
     */
    public final native boolean compareAndSwapInt(Object o, long offset,
                                                  int expected,
                                                  int new);
    "
    | o offset expected real new ok isArray|

    o := a1.
    offset := a2.
    "offset is long, so nativeContext at:3 is dummy nil!!!!!!"
    expected := a4.
    new := a5.

    OperatingSystem blockInterrupts.
    (isArray := o isArray) ifTrue:[
        real := o at: offset.
    ] ifFalse:[
        real := o instVarAt: offset.
    ].
    (real == expected) ifTrue:[
        isArray ifTrue:[
            o at: offset put: new.
        ] ifFalse:[
            offset :=
            o instVarAt: offset put: new.
        ].
        ok := 1
    ] ifFalse:[
        ok := 0
    ].
    OperatingSystem unblockInterrupts.
    ^ok

    "Modified: / 08-02-2013 / 09:24:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_copyMemory: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6
    "
    /**
     * Sets all bytes in a given block of memory to a copy of another
     * block.
     */
    public native void copyMemory(long srcAddress, long destAddress,
                                  long bytes);
    "

    <javanative: 'sun/misc/Unsafe' name: 'copyMemory(JJJ)V'>

    | srcAddress dstAddress bytes |

    srcAddress := a1.
    dstAddress := a3.
    bytes      := a5.
    SimulatedNativeMemory bcopy: srcAddress to: dstAddress length: bytes.

    "Modified (format): / 11-07-2012 / 10:25:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_copyMemory: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 

    <javanative: 'sun/misc/Unsafe' name: 'copyMemory(Ljava/lang/Object;JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_defineClass: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'defineClass(Ljava/lang/String;[BII)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_defineClass: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'defineClass(Ljava/lang/String;[BII)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_defineClass: this _:a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/misc/Unsafe' name: 'defineClass(Ljava/lang/String;[BIILjava/lang/ClassLoader;Ljava/security/ProtectionDomain;)Ljava/lang/Class;'>

        "
    /**
     * Tell the VM to define a class, without security checks.  By default, the
     * class loader and protection domain come from the caller's class.
     */
    public native Class defineClass(String name, byte[] b, int off, int len,
                                    ClassLoader loader,
                                    ProtectionDomain protectionDomain);
    "
    | nm b off len loader protectionDomain bs cls |
    nm := a1.
    b := a2.
    off := a3.
    len := a4.
    loader := a5.
    protectionDomain := a6.

    bs := (off = 0 and: [len = b size])
            ifTrue:[b readStream]
            ifFalse:[(b copyFrom: off + 1 to: off + len) readStream].

    cls := JavaClassReader readStream: bs loader: loader.
    cls classLoader: loader.
    cls protectionDomain: protectionDomain.

    ^Reflection javaClassObjectForClass: cls.

    "Created: / 05-02-2011 / 22:57:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2013 / 09:59:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_ensureClassInitialized: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'ensureClassInitialized(Ljava/lang/Class;)V'>

        |class|

    class := Reflection classForJavaClassObject:a1.
     "Sometimes there is a nil. I don't know why, so I did quickfix"
    self breakPoint:#libjava.
    class notNil ifTrue:[class classInit.].

    "Created: / 11-12-2010 / 15:01:36 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 08-01-2011 / 15:11:21 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 28-01-2011 / 15:19:31 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 16-01-2013 / 19:52:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_freeMemory: this _:a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'freeMemory(J)V'>

    | address  |
    address := a1.
    ^SimulatedNativeMemory free: address

    "Created: / 09-12-2010 / 17:56:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getAddress: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getAddress(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getAddress: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getAddress(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getBoolean: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getBoolean(Ljava/lang/Object;J)Z'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 19-11-2011 / 10:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getBooleanVolatile: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getBooleanVolatile(Ljava/lang/Object;J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getBooleanVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getBooleanVolatile(Ljava/lang/Object;J)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getByte: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getByte(J)B'>

    | address |
    address := a1.
    ^SimulatedNativeMemory byteAt: address

    "Modified: / 20-01-2013 / 20:54:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-01-2013 / 17:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getByte: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getByte(Ljava/lang/Object;J)B'>
    <javanative: 'sun/misc/Unsafe' name: 'getByte(J)B'>

    | object offset |

    "getByte(Ljava/lang/Object;J)V"
    object := a1.
    offset := a2.
    ^object instVarAt: offset

    "Created: / 09-12-2010 / 17:29:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-01-2013 / 20:55:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getByteVolatile: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getByteVolatile(Ljava/lang/Object;J)B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getByteVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getByteVolatile(Ljava/lang/Object;J)B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getChar: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getChar(J)C'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getChar: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getChar(J)C'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getChar: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getChar(Ljava/lang/Object;J)C'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 22-11-2011 / 14:51:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getCharVolatile: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getCharVolatile(Ljava/lang/Object;J)C'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getCharVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getCharVolatile(Ljava/lang/Object;J)C'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getDouble: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getDouble(J)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getDouble: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getDouble(J)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getDouble: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getDouble(Ljava/lang/Object;J)D'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 10-05-2012 / 17:01:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getDoubleVolatile: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getDoubleVolatile(Ljava/lang/Object;J)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getDoubleVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getDoubleVolatile(Ljava/lang/Object;J)D'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getFloat: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getFloat(J)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getFloat: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getFloat(J)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getFloat: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getFloat(Ljava/lang/Object;J)F'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 22-11-2011 / 14:53:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getFloatVolatile: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getFloatVolatile(Ljava/lang/Object;J)F'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 10-05-2012 / 17:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getInt: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getInt(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getInt: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getInt(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getInt: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getInt(Ljava/lang/Object;J)I'>
    "
    /**
    * Fetches a integer value from a given Java variable.
    */
    public native int getInt(Object o, long offset);
    "
    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 18-10-2011 / 20:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getIntVolatile: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getIntVolatile(Ljava/lang/Object;J)I'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 28-03-2012 / 15:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getLoadAverage: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getLoadAverage([DI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getLoadAverage: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getLoadAverage([DI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getLong: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getLong(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getLong: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getLong(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getLong: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getLong(Ljava/lang/Object;J)J'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 25-08-2012 / 11:15:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getLongVolatile: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getLongVolatile(Ljava/lang/Object;J)J'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 31-08-2011 / 23:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getObject: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getObject(Ljava/lang/Object;J)Ljava/lang/Object;'>
    "
    /**
    * Fetches a reference value from a given Java variable.
    * @see #getInt(Object, long)
    */
    public native Object getObject(Object o, long offset);
    "
    | o offset |
    o := a1.
    offset := a2.
    ^o isArray ifTrue:[
        o at: offset
    ] ifFalse:[
        o instVarAt: offset
    ]

    "Modified: / 03-09-2012 / 19:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getObjectVolatile: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getObjectVolatile(Ljava/lang/Object;J)Ljava/lang/Object;'>
    "
    /**
    * Fetches a reference value from a given Java variable, with volatile
    * load semantics. Otherwise identical to {@link #getObject(Object, long)}
    */
    public native Object getObjectVolatile(Object o, long offset);
    "

    ^self _sun_misc_Unsafe_getObject: this _:a1 _: a2 _: a3

    "Modified: / 30-01-2013 / 13:56:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getShort: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'getShort(J)S'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getShort: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'getShort(J)S'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_getShort: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getShort(Ljava/lang/Object;J)S'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 22-11-2011 / 14:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_getShortVolatile: this _:a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'getShortVolatile(Ljava/lang/Object;J)S'>

    | o offset |
    o := a1.
    offset := a2.
    ^o instVarAt: offset

    "Modified: / 29-06-2012 / 19:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_monitorEnter: this

    <javanative: 'sun/misc/Unsafe' name: 'monitorEnter(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_monitorEnter: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'monitorEnter(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_monitorExit: this

    <javanative: 'sun/misc/Unsafe' name: 'monitorExit(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_monitorExit: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'monitorExit(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_objectFieldOffset: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'objectFieldOffset(Ljava/lang/reflect/Field;)J'>


    | javaFieldObject |
    javaFieldObject := a1.
    ^javaFieldObject instVarNamed: #slot

    "Created: / 22-11-2010 / 17:58:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_pageSize: this

    <javanative: 'sun/misc/Unsafe' name: 'pageSize()I'>

    ^ 4096"4K is the page size on x86, I think... "

    "Modified: / 25-11-2011 / 19:24:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_park: this _:absolute _: millisOrNanos _: ignored

    <javanative: 'sun/misc/Unsafe' name: 'park(ZJ)V'>
    "
    /**
     * Block current thread, returning when a balancing
     * <tt>unpark</tt> occurs, or a balancing <tt>unpark</tt> has
     * already occurred, or the thread is interrupted, or, if not
     * absolute and time is not zero, the given time nanoseconds have
     * elapsed, or if absolute, the given deadline in milliseconds
     * since Epoch has passed, or spuriously (i.e., returning for no
     * 'reason'). Note: This operation is in the Unsafe class only
     * because <tt>unpark</tt> is, so it would be strange to place it
     * elsewhere.
     */
    "

    | tout process |

    millisOrNanos ~~ 0 ifTrue:[
        absolute == 1 ifTrue:[
            tout := millisOrNanos - OperatingSystem getOSTime.
            tout < 1 ifTrue:[
                tout := nil.
            ].
        ] ifFalse:[
            "/ It's nanos in this case !!!!!!
            tout := (millisOrNanos / 1000000) rounded
        ]
    ] ifFalse:[
        tout := nil.
    ].

    process := Processor activeProcess.
    JavaVM park: process timeout: tout.

    "Modified: / 18-08-2013 / 00:49:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putAddress: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putAddress(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putAddress: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putAddress(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putBoolean: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putBoolean(Ljava/lang/Object;JZ)V'>

    "Like putInt:, see _sun_misc_Unsafe_putInt:"

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 27-10-2011 / 16:23:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putBooleanVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putBooleanVolatile(Ljava/lang/Object;JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putBooleanVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putBooleanVolatile(Ljava/lang/Object;JZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putByte: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'putByte(JB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putByte: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putByte(JB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putByte: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putByte(Ljava/lang/Object;JB)V'>
    <javanative: 'sun/misc/Unsafe' name: 'putByte(JB)V'>

    | o offset x |
    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 30-01-2013 / 13:57:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putByteVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putByteVolatile(Ljava/lang/Object;JB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putByteVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putByteVolatile(Ljava/lang/Object;JB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putChar: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'putChar(JC)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putChar: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putChar(JC)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putChar: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putChar(Ljava/lang/Object;JC)V'>

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 22-11-2011 / 14:52:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putCharVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putCharVolatile(Ljava/lang/Object;JC)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putCharVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putCharVolatile(Ljava/lang/Object;JC)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putDouble: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putDouble(JD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putDouble: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putDouble(JD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putDouble: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'putDouble(Ljava/lang/Object;JD)V'>
    <javanative: 'sun/misc/Unsafe' name: 'putDouble(JD)V'>

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    o instVarAt: offset put: x.
    ^nil

    "Modified: / 30-01-2013 / 13:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putDoubleVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putDoubleVolatile(Ljava/lang/Object;JD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putDoubleVolatile: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'putDoubleVolatile(Ljava/lang/Object;JD)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putFloat: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'putFloat(JF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putFloat: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putFloat(JF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putFloat: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putFloat(Ljava/lang/Object;JF)V'>

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 22-11-2011 / 14:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putFloatVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putFloatVolatile(Ljava/lang/Object;JF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putFloatVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putFloatVolatile(Ljava/lang/Object;JF)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putInt: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'putInt(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putInt: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putInt(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putInt: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putInt(Ljava/lang/Object;JI)V'>
    "
    /**
     * Stores a value into a given Java variable.
     * <p>
     * The first two parameters are interpreted exactly as with
     * {@link #getInt(Object, long)} to refer to a specific
     * Java variable (field or array element).  The given value
     * is stored into that variable.
     * <p>
     * The variable must be of the same type as the method
     * parameter <code>x</code>.
     *
     * @param o Java heap object in which the variable resides, if any, else
     *        null
     * @param offset indication of where the variable resides in a Java heap
     *        object, if any, else a memory address locating the variable
     *        statically
     * @param x the value to store into the indicated Java variable
     * @throws RuntimeException No defined exceptions are thrown, not even
     *         {@link NullPointerException}
     */
    public native void putInt(Object o, long offset, int x);
    "

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 30-08-2011 / 15:48:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putIntVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putIntVolatile(Ljava/lang/Object;JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putIntVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putIntVolatile(Ljava/lang/Object;JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putLong: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putLong(JJ)V'>

    | o x |

    "putDouble(JD)V"
    o := a1.
    x := a3.
    SimulatedNativeMemory sint64At: o put: x.
    ^nil

    "Modified: / 20-01-2013 / 20:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putLong: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'putLong(Ljava/lang/Object;JJ)V'>

    | o offset x |


    o := a1.
    offset := a2.
    x := a4.
    o instVarAt: offset put: x.
    ^nil

    "Created: / 07-12-2010 / 23:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2013 / 09:24:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putLongVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putLongVolatile(Ljava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putLongVolatile: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'putLongVolatile(Ljava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putObject: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putObject(Ljava/lang/Object;JLjava/lang/Object;)V'>

    "
    /**
     * Stores a reference value into a given Java variable.
     * <p>
     * Unless the reference <code>x</code> being stored is either null
     * or matches the field type, the results are undefined.
     * If the reference <code>o</code> is non-null, car marks or
     * other store barriers for that object (if the VM requires them)
     * are updated.
     * @see #putInt(Object, int, int)
     */
     public native void putObject(Object o, long offset, Object x);
     "
    | o offset x |
    o := a1.
    offset := a2.
    x := a4.

    ^o isArray ifTrue:[
        o at: offset put: x
    ] ifFalse:[
        o instVarAt: offset put: x.
    ].

    "Modified: / 03-09-2012 / 18:59:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putObjectVolatile: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putObjectVolatile(Ljava/lang/Object;JLjava/lang/Object;)V'>

    ^self _sun_misc_Unsafe_putObject: this _:a1 _: a2 _: a3 _: a4

    "Modified: / 30-01-2013 / 14:16:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putOrderedInt: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putOrderedInt(Ljava/lang/Object;JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putOrderedInt: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putOrderedInt(Ljava/lang/Object;JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putOrderedLong: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putOrderedLong(Ljava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putOrderedLong: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'putOrderedLong(Ljava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putOrderedObject: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putOrderedObject(Ljava/lang/Object;JLjava/lang/Object;)V'>

    "
    /**
     * Version of {@link #putObjectVolatile(Object, long, Object)}
     * that does not guarantee immediate visibility of the store to
     * other threads. This method is generally only useful if the
     * underlying field is a Java volatile (or if an array cell, one
     * that is otherwise only accessed using volatile accesses).
     */
    "

    ^ self _sun_misc_Unsafe_putObject: this _:a1 _: a2 _: a3 _: a4

    "Modified: / 30-01-2013 / 14:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putShort: this _: a1 _: a2

    <javanative: 'sun/misc/Unsafe' name: 'putShort(JS)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putShort: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putShort(JS)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putShort: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putShort(Ljava/lang/Object;JS)V'>

    | o offset x |

    o := a1.
    offset := a2.
    x := a4.
    ^o instVarAt: offset put: x.

    "Modified: / 22-11-2011 / 14:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_putShortVolatile: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'putShortVolatile(Ljava/lang/Object;JS)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_putShortVolatile: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'putShortVolatile(Ljava/lang/Object;JS)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_reallocateMemory: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'reallocateMemory(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_reallocateMemory: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/misc/Unsafe' name: 'reallocateMemory(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_registerNatives: this

    <javanative: 'sun/misc/Unsafe' name: 'registerNatives()V'>


     "Nothing to do, native method are bound lazily"

    "Created: / 25-10-2010 / 16:14:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_setMemory: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/misc/Unsafe' name: 'setMemory(JJB)V'>

    | address bytes value|

    address := a1.
    bytes := a3.
    value := a5.
    SimulatedNativeMemory memset: address value: value length: bytes.

    "Modified (format): / 11-07-2012 / 10:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_staticFieldBase: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'staticFieldBase(Ljava/lang/reflect/Field;)Ljava/lang/Object;'>
    "
      /**
      * Report the location of a given static field, in conjunction with {@link
      * #staticFieldOffset}.
      * <p>Fetch the base 'Object', if any, with which static fields of the
      * given class can be accessed via methods like {@link #getInt(Object,
      * long)}.  This value may be null.  This value may refer to an object
      * which is a 'cookie', not guaranteed to be a real Object, and it should
      * not be used in any way except as argument to the get and put routines in
      * this class.
      */
      public native Object staticFieldBase(Field f);
    "
     | javaFieldObject javaClassObject |
     javaFieldObject := a1.
     javaClassObject := javaFieldObject instVarNamed: #clazz.
     ^Reflection classForJavaClassObject:javaClassObject.

    "Modified: / 17-08-2011 / 09:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_staticFieldOffset: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'staticFieldOffset(Ljava/lang/reflect/Field;)J'>

    | javaFieldObject |
    javaFieldObject := a1.
    ^javaFieldObject instVarNamed: #slot

    "Modified: / 17-08-2011 / 09:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_throwException: this

    <javanative: 'sun/misc/Unsafe' name: 'throwException(Ljava/lang/Throwable;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_throwException: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'throwException(Ljava/lang/Throwable;)V'>

    ^ JavaVM _ATHROW: a1.

    "Modified: / 07-11-2013 / 23:41:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_tryMonitorEnter: this

    <javanative: 'sun/misc/Unsafe' name: 'tryMonitorEnter(Ljava/lang/Object;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_tryMonitorEnter: this _: a1

    <javanative: 'sun/misc/Unsafe' name: 'tryMonitorEnter(Ljava/lang/Object;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_unpark: this _:a1

    <javanative: 'sun/misc/Unsafe' name: 'unpark(Ljava/lang/Object;)V'>
    "
    /**
     * Unblock the given thread blocked on <tt>park</tt>, or, if it is
     * not blocked, cause the subsequent call to <tt>park</tt> not to
     * block.  Note: this operation is 'unsafe' solely because the
     * caller must somehow ensure that the thread has not been
     * destroyed. Nothing special is usually required to ensure this
     * when called from Java (in which there will ordinarily be a live
     * reference to the thread) but this is not nearly-automatically
     * so when calling from native code.
     * @param thread the thread to unpark.
     *
     */
    public native void unpark(Object thread);
    "

    | thread process |

    thread := a1.
    process := Java threads at: thread ifAbsent:[
        self error: 'No process for given thread'.
    ].
    JavaVM unpark: process.

    "Modified: / 16-01-2013 / 19:54:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_VMSupport_initAgentProperties: this _: a1

    <javanative: 'sun/misc/VMSupport' name: 'initAgentProperties(Ljava/util/Properties;)Ljava/util/Properties;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_VM_getThreadStateValues: this _: a1

    <javanative: 'sun/misc/VM' name: 'getThreadStateValues([[I[[Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_VM_getThreadStateValues: this _: a1 _: a2

    <javanative: 'sun/misc/VM' name: 'getThreadStateValues([[I[[Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_VM_initialize: this

    <javanative: 'sun/misc/VM' name: 'initialize()V'>


    "Nothing to do"

    "Created: / 26-11-2010 / 18:43:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Version_getJdkSpecialVersion: this

    <javanative: 'sun/misc/Version' name: 'getJdkSpecialVersion()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Version_getJdkVersionInfo: this

    <javanative: 'sun/misc/Version' name: 'getJdkVersionInfo()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Version_getJvmSpecialVersion: this

    <javanative: 'sun/misc/Version' name: 'getJvmSpecialVersion()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Version_getJvmVersionInfo: this

    <javanative: 'sun/misc/Version' name: 'getJvmVersionInfo()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.net.dns'!

_sun_net_dns_ResolverConfigurationImpl_fallbackDomain0: this

    <javanative: 'sun/net/dns/ResolverConfigurationImpl' name: 'fallbackDomain0()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_net_dns_ResolverConfigurationImpl_localDomain0: this

    <javanative: 'sun/net/dns/ResolverConfigurationImpl' name: 'localDomain0()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.net.spi'!

_sun_net_spi_DefaultProxySelector_getSystemProxy: this _: a1 _: a2

    <javanative: 'sun/net/spi/DefaultProxySelector' name: 'getSystemProxy(Ljava/lang/String;Ljava/lang/String;)Ljava/net/Proxy;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_net_spi_DefaultProxySelector_init: this

    <javanative: 'sun/net/spi/DefaultProxySelector' name: 'init()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.nio.ch'!

_sun_nio_ch_DatagramChannelImpl_disconnect0: this _: a1

    <javanative: 'sun/nio/ch/DatagramChannelImpl' name: 'disconnect0(Ljava/io/FileDescriptor;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramChannelImpl_initIDs: this

    <javanative: 'sun/nio/ch/DatagramChannelImpl' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramChannelImpl_receive0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/nio/ch/DatagramChannelImpl' name: 'receive0(Ljava/io/FileDescriptor;JIZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramChannelImpl_send0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/nio/ch/DatagramChannelImpl' name: 'send0(Ljava/io/FileDescriptor;JILjava/net/SocketAddress;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramChannelImpl_send0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/DatagramChannelImpl' name: 'send0(Ljava/io/FileDescriptor;JILjava/net/InetAddress;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramDispatcher_read0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/DatagramDispatcher' name: 'read0(Ljava/io/FileDescriptor;JI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramDispatcher_readv0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/DatagramDispatcher' name: 'readv0(Ljava/io/FileDescriptor;JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramDispatcher_write0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/DatagramDispatcher' name: 'write0(Ljava/io/FileDescriptor;JI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DatagramDispatcher_writev0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/DatagramDispatcher' name: 'writev0(Ljava/io/FileDescriptor;JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_fdLimit: this

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'fdLimit()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_init: this

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'init()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_interrupt: this _: a1

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'interrupt(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_poll0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'poll0(JIJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_register: this _: a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'register(III)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_DevPollArrayWrapper_registerMultiple: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/DevPollArrayWrapper' name: 'registerMultiple(IJI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_epollCreate: this

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'epollCreate()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_epollCtl: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'epollCtl(IIII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_epollWait: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'epollWait(JIJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_fdLimit: this

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'fdLimit()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_init: this

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'init()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_interrupt: this _: a1

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'interrupt(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_offsetofData: this

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'offsetofData()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_EPollArrayWrapper_sizeofEPollEvent: this

    <javanative: 'sun/nio/ch/EPollArrayWrapper' name: 'sizeofEPollEvent()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_force0: this _: a1 _: a2

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'force0(Ljava/io/FileDescriptor;Z)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_initIDs: this

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'initIDs()J'>

    ^ 4096 "/page size, see

    "Modified: / 10-07-2012 / 01:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileChannelImpl_lock0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'lock0(Ljava/io/FileDescriptor;ZJJZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_map0: this _:a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'map0(IJJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_position0: this _:a1 _: a2 _: a3
    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'position0(Ljava/io/FileDescriptor;J)J'>

    | fd position stream |

    fd := a1.
    position := a2.
    stream := self validateFileDescriptor: fd.
    stream isFileStream ifFalse:[
        JavaVM throwIOExceptionWithMessage:'Not a file stream'.
        ^nil.
    ].
    ^position = -1
        ifTrue:[stream position]
        ifFalse:[stream position: position. 0].

    "Modified: / 10-07-2012 / 01:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileChannelImpl_release0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'release0(Ljava/io/FileDescriptor;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_size0: this _:a1
    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'size0(Ljava/io/FileDescriptor;)J'>

    | fd stream |

    fd := a1.
    stream := self validateFileDescriptor: fd.
    stream isFileStream ifFalse:[
        JavaVM throwIOExceptionWithMessage:'Not a file stream'.
        ^nil.
    ].
    ^stream fileSize max: stream position.

    "Modified: / 10-07-2012 / 01:28:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileChannelImpl_transferTo0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'transferTo0(IJJI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileChannelImpl_truncate0: this _:a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'truncate0(Ljava/io/FileDescriptor;J)I'>

    | fd size stream |

    fd := a1.
    size := a2.
    stream := self validateFileDescriptor: fd.
    stream isFileStream ifFalse:[
        JavaVM throwIOExceptionWithMessage:'Not a file stream'.
        ^nil.
    ].
    stream truncateTo: size.
    ^0.

    "Modified: / 10-07-2012 / 01:02:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileChannelImpl_unmap0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/FileChannelImpl' name: 'unmap0(JJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_close0: this _: a1

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'close0(Ljava/io/FileDescriptor;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_closeIntFD: this _: a1

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'closeIntFD(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_init: this

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'init()V'>

    ^ JavaNioSupport _sun_nio_ch_FileDispatcher_init

    "Modified: / 06-07-2012 / 22:35:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileDispatcher_preClose0: this _:a1

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'preClose0(Ljava/io/FileDescriptor;)V'>

    "Nothing to do here"

    "Modified: / 10-07-2012 / 00:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileDispatcher_pread0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'pread0(Ljava/io/FileDescriptor;JIJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_pwrite0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'pwrite0(Ljava/io/FileDescriptor;JIJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_read0: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'read0(Ljava/io/FileDescriptor;JI)I'>

    | fd address len stream |

    fd := a1.
    address := a2.
    len := a4.

    stream := self validateFileDescriptor: fd.
    stream atEnd ifTrue:[ ^ -1 ].
    [
        self shouldImplement.
        "/WAS: read := stream nextBytes:len into:SimulatedNativeMemory memory startingAt: address
        "/ ^ read
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage:ex description.
        ^ 0
    ].

    "Modified (comment): / 11-07-2012 / 10:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileDispatcher_readv0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'readv0(Ljava/io/FileDescriptor;JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileDispatcher_write0: this _:a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'write0(Ljava/io/FileDescriptor;JI)I'>

    | fd address len stream |

    fd := a1.
    address := a2.
    len := a4.

    stream := self validateFileDescriptor: fd.
    [
        self shouldImplement.
        "/WAS: writtem := stream nextPutBytes:len from:SimulatedNativeMemory memory startingAt: address
        "/^ written
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage:ex description.
        ^ 0
    ].

    "Modified: / 11-07-2012 / 10:38:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_FileDispatcher_writev0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/FileDispatcher' name: 'writev0(Ljava/io/FileDescriptor;JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileKey_init: this _: a1

    <javanative: 'sun/nio/ch/FileKey' name: 'init(Ljava/io/FileDescriptor;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_FileKey_initIDs: this

    <javanative: 'sun/nio/ch/FileKey' name: 'initIDs()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_configureBlocking: this _: a1 _: a2

    <javanative: 'sun/nio/ch/IOUtil' name: 'configureBlocking(Ljava/io/FileDescriptor;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_drain: this _: a1

    <javanative: 'sun/nio/ch/IOUtil' name: 'drain(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_fdVal: this _: a1

    <javanative: 'sun/nio/ch/IOUtil' name: 'fdVal(Ljava/io/FileDescriptor;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_initIDs: this

    <javanative: 'sun/nio/ch/IOUtil' name: 'initIDs()V'>

    "Nothing to do here"

    "Modified: / 06-07-2012 / 22:10:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_IOUtil_initPipe: this _:a1 _: a2

    <javanative: 'sun/nio/ch/IOUtil' name: 'initPipe([IZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_randomBytes: this _: a1

    <javanative: 'sun/nio/ch/IOUtil' name: 'randomBytes([B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_IOUtil_setfdVal: this _: a1 _: a2

    <javanative: 'sun/nio/ch/IOUtil' name: 'setfdVal(Ljava/io/FileDescriptor;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_close0: this _: a1

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'close0(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_dup2: this _: a1 _: a2

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'dup2(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_dup: this _: a1

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'dup(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_open0: this _: a1 _: a2

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'open0(Ljava/lang/String;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_peerAddress0: this _: a1

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'peerAddress0(I)Ljava/net/InetAddress;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_peerPort0: this _: a1

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'peerPort0(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_InheritedChannel_soType0: this _: a1

    <javanative: 'sun/nio/ch/InheritedChannel' name: 'soType0(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_NativeThread_current: this

    <javanative: 'sun/nio/ch/NativeThread' name: 'current()J'>

    ^ JavaNioSupport _sun_nio_ch_NativeThread_current

    "Modified: / 06-07-2012 / 22:39:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_NativeThread_init: this

    <javanative: 'sun/nio/ch/NativeThread' name: 'init()V'>

    ^ JavaNioSupport _sun_nio_ch_NativeThread_init

    "Modified: / 06-07-2012 / 22:38:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_NativeThread_signal: this _: a1 _: a2

    <javanative: 'sun/nio/ch/NativeThread' name: 'signal(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_bind0: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/Net' name: 'bind0(Ljava/io/FileDescriptor;ZLjava/net/InetAddress;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_bind: this _: a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/Net' name: 'bind(Ljava/io/FileDescriptor;Ljava/net/InetAddress;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_connect: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/nio/ch/Net' name: 'connect(Ljava/io/FileDescriptor;Ljava/net/InetAddress;II)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_getIntOption0: this _: a1 _: a2

    <javanative: 'sun/nio/ch/Net' name: 'getIntOption0(Ljava/io/FileDescriptor;I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_initIDs: this

    <javanative: 'sun/nio/ch/Net' name: 'initIDs()V'>

    "Nothing to do here"

    "Modified: / 10-05-2012 / 17:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_Net_isExclusiveBindAvailable: this

    <javanative: 'sun/nio/ch/Net' name: 'isExclusiveBindAvailable()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_localInetAddress: this _: a1

    <javanative: 'sun/nio/ch/Net' name: 'localInetAddress(Ljava/io/FileDescriptor;)Ljava/net/InetAddress;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_localPort: this _: a1

    <javanative: 'sun/nio/ch/Net' name: 'localPort(Ljava/io/FileDescriptor;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_setIntOption0: this _: a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/Net' name: 'setIntOption0(Ljava/io/FileDescriptor;II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_Net_socket0: this _:a1 _: a2

    <javanative: 'sun/nio/ch/Net' name: 'socket0(ZZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_PollArrayWrapper_interrupt: this _: a1

    <javanative: 'sun/nio/ch/PollArrayWrapper' name: 'interrupt(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_PollArrayWrapper_poll0: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/nio/ch/PollArrayWrapper' name: 'poll0(JIJ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_ServerSocketChannelImpl_accept0: this _: a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/ServerSocketChannelImpl' name: 'accept0(Ljava/io/FileDescriptor;Ljava/io/FileDescriptor;[Ljava/net/InetSocketAddress;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_ServerSocketChannelImpl_initIDs: this

    <javanative: 'sun/nio/ch/ServerSocketChannelImpl' name: 'initIDs()V'>

    "Nothing to do here"

    "Modified: / 10-05-2012 / 16:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_nio_ch_ServerSocketChannelImpl_listen: this _: a1 _: a2

    <javanative: 'sun/nio/ch/ServerSocketChannelImpl' name: 'listen(Ljava/io/FileDescriptor;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_SocketChannelImpl_checkConnect: this _: a1 _: a2 _: a3

    <javanative: 'sun/nio/ch/SocketChannelImpl' name: 'checkConnect(Ljava/io/FileDescriptor;ZZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_ch_SocketChannelImpl_shutdown: this _: a1 _: a2

    <javanative: 'sun/nio/ch/SocketChannelImpl' name: 'shutdown(Ljava/io/FileDescriptor;I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.print'!

_sun_print_CUPSPrinter_canConnect: this _: a1 _: a2

    <javanative: 'sun/print/CUPSPrinter' name: 'canConnect(Ljava/lang/String;I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_print_CUPSPrinter_getCupsPort: this

    <javanative: 'sun/print/CUPSPrinter' name: 'getCupsPort()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_print_CUPSPrinter_getCupsServer: this

    <javanative: 'sun/print/CUPSPrinter' name: 'getCupsServer()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_print_CUPSPrinter_getMedia: this _: a1

    <javanative: 'sun/print/CUPSPrinter' name: 'getMedia(Ljava/lang/String;)[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_print_CUPSPrinter_getPageSizes: this _: a1

    <javanative: 'sun/print/CUPSPrinter' name: 'getPageSizes(Ljava/lang/String;)[F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_print_CUPSPrinter_initIDs: this

    <javanative: 'sun/print/CUPSPrinter' name: 'initIDs()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.reflect'!

_sun_reflect_ConstantPool_getClassAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getClassAt0(Ljava/lang/Object;I)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getClassAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getClassAt0(Ljava/lang/Object;I)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getClassAtIfLoaded0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getClassAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getClassAtIfLoaded0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getClassAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getDoubleAt0: this _:a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getDoubleAt0(Ljava/lang/Object;I)D'>

        | cpool  index  double |

    cpool := Reflection constantPoolFor:this.
    index := a2.
    double := cpool at:index.
    self assert:double isFloat message:'Not a float constant!!'.
    ^ double

    "Created: / 28-02-2011 / 17:24:17 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 02-11-2011 / 11:24:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-01-2013 / 13:58:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_ConstantPool_getFieldAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getFieldAt0(Ljava/lang/Object;I)Ljava/lang/reflect/Field;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getFieldAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getFieldAt0(Ljava/lang/Object;I)Ljava/lang/reflect/Field;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getFieldAtIfLoaded0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getFieldAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/reflect/Field;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getFieldAtIfLoaded0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getFieldAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/reflect/Field;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getFloatAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getFloatAt0(Ljava/lang/Object;I)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getFloatAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getFloatAt0(Ljava/lang/Object;I)F'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getIntAt0: this _:a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getIntAt0(Ljava/lang/Object;I)I'>

        | cpool  index  int |

    cpool := Reflection constantPoolFor:this.
    index := a2.
    int := cpool at:index.
    self assert:int isInteger message:'Not an integer constant!!'.
    ^ int

    "Created: / 28-02-2011 / 17:28:10 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 30-01-2013 / 13:58:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_ConstantPool_getLongAt0: this _:a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getLongAt0(Ljava/lang/Object;I)J'>

        | cpool  index  long |

    cpool := Reflection constantPoolFor:this.
    index := a2.
    long := cpool at:index.
    self assert:long isInteger message:'Not a float constant!!'.
    ^ long

    "Modified: / 28-02-2011 / 17:40:02 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 30-01-2013 / 13:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_ConstantPool_getMemberRefInfoAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getMemberRefInfoAt0(Ljava/lang/Object;I)[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getMemberRefInfoAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getMemberRefInfoAt0(Ljava/lang/Object;I)[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getMethodAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getMethodAt0(Ljava/lang/Object;I)Ljava/lang/reflect/Member;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getMethodAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getMethodAt0(Ljava/lang/Object;I)Ljava/lang/reflect/Member;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getMethodAtIfLoaded0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getMethodAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/reflect/Member;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getMethodAtIfLoaded0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getMethodAtIfLoaded0(Ljava/lang/Object;I)Ljava/lang/reflect/Member;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getSize0: this

    <javanative: 'sun/reflect/ConstantPool' name: 'getSize0(Ljava/lang/Object;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getSize0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getSize0(Ljava/lang/Object;)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getStringAt0: this _: a1

    <javanative: 'sun/reflect/ConstantPool' name: 'getStringAt0(Ljava/lang/Object;I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getStringAt0: this _: a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getStringAt0(Ljava/lang/Object;I)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_reflect_ConstantPool_getUTF8At0: this _:a1 _: a2

    <javanative: 'sun/reflect/ConstantPool' name: 'getUTF8At0(Ljava/lang/Object;I)Ljava/lang/String;'>


    | cpool index string |
    cpool := Reflection constantPoolFor: this.
    index := a2.

    string := cpool at: index.
    self assert: string isString message: 'Not an UTF8 constant!!'.
    ^Java as_String: string

    "Created: / 06-02-2011 / 12:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 13:59:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_NativeConstructorAccessorImpl_newInstance0: this _:a1 _: a2

    <javanative: 'sun/reflect/NativeConstructorAccessorImpl' name: 'newInstance0(Ljava/lang/reflect/Constructor;[Ljava/lang/Object;)Ljava/lang/Object;'>


    | ctor args method instance class |
    ctor := a1.
    args := a2.
    class := Reflection classForJavaConstructorObject: ctor.
    method := Reflection methodForJavaConstructorObject: ctor.

    instance := class basicNew.
    self invoke: ctor receiver: instance arguments: args context: self nativeContext constructor: true.
    ^instance

    "Created: / 26-11-2010 / 11:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:12:10 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 17-08-2013 / 17:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_NativeMethodAccessorImpl_invoke0: this _:a1 _: a2 _: a3

    <javanative: 'sun/reflect/NativeMethodAccessorImpl' name: 'invoke0(Ljava/lang/reflect/Method;Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;'>
    "
    private static native Object invoke0(Method m, Object obj, Object[] args);
    "
    | m obj args method |
    m := a1.
    obj := a2.
    args := a3.
    method := Reflection methodForJavaMethodObject: m.

    ^ self invoke: m receiver: obj arguments: args context: self nativeContext constructor: false.

    "Created: / 06-02-2011 / 00:00:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2011 / 16:57:31 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 19-08-2011 / 15:06:00 / cg"
    "Modified: / 30-01-2013 / 14:16:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_Reflection_getCallerClass0: this _: a1

    <javanative: 'sun/reflect/Reflection' name: 'getCallerClass0(I)Ljava/lang/Class;'>

    "/ Until there is hotspot @CallerSensitive support,
    "/ depth must always be 2 to get the immediate caller
    ^ self _sun_reflect_Reflection_getCallerClass: this _: 2

    "Modified (comment): / 11-11-2013 / 21:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_Reflection_getCallerClass: this

    <javanative: 'sun/reflect/Reflection' name: 'getCallerClass()Ljava/lang/Class;'>

    "/ Until there is hotspot @CallerSensitive support,
    "/ depth must always be 2 to get the immediate caller
    ^ self _sun_reflect_Reflection_getCallerClass0: this _: 2

    "Modified (comment): / 11-11-2013 / 21:18:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_Reflection_getCallerClass: this _:a1

    <javanative: 'sun/reflect/Reflection' name: 'getCallerClass(I)Ljava/lang/Class;'>
    "
    /** Returns the class of the method <code>realFramesToSkip</code>
        frames up the stack (zero-based), ignoring frames associated
        with java.lang.reflect.Method.invoke() and its implementation.
        The first frame is that associated with this method, so
        <code>getCallerClass(0)</code> returns the Class object for
        sun.reflect.Reflection. Frames associated with
        java.lang.reflect.Method.invoke() and its implementation are
        completely ignored and do not count toward the number of 'real'
        frames skipped. */
    "

    | framesToSkip framesSkipped frame cls |


    framesToSkip := a1.
    framesSkipped := 0.
    frame := self nativeContext.

    "The callstack here may look like:

    (0 native ctx) JAVA::sun::reflect::Reflection(JAVA::sun::reflect::Reflection) >> getCallerClass()Ljava/lang/Class;  {1380352} [0]
    (1           ) JavaNativeMethod(CompiledCode) >> valueWithReceiver:arguments:selector:search:sender: [88]) {7286784} [17]
    (2           ) JavaNativeMethod(JavaMethod) >> valueWithReceiver:arguments:selector:search:sender:  [88]) {4497408} [7]
    (3           ) JavaVM class >> _INVOKESTATIC_R: sun/reflect/Reflection.getCallerClass {4157440} [9]
    (4           ) JAVA::sun::misc::Unsafe(JAVA::sun::misc::Unsafe) >> getUnsafe()Lsun/misc/Unsafe;  {4501504} [88]

    in case Reflection,getCallerClass() has been called from JIT-compiled code
    and methodref to Reflection.getCallerClass() has not yet been resolved
    (in that case JIT code sends #_INVOKESTATIC_R:. Care about this now.
    "
    frame sender selector == #valueWithReceiver:arguments:selector:search:sender: ifTrue:[
        frame := frame sender.
        frame sender selector == #valueWithReceiver:arguments:selector:search:sender: ifTrue:[
            frame := frame sender.
        ].
        frame sender selector == #'_INVOKESTATIC_R:' ifTrue:[
            frame := frame sender.
        ].
    ].

    [ framesSkipped == framesToSkip ] whileFalse:[
        frame := frame sender.
        "Frames for java,lang.reflect.Method.invoke() does not count, sigh.
         What a crappy implementation"
        (frame selector == #'invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;'
            and:[ frame receiver class binaryName = #'java/lang/reflect/Method']) ifFalse:[
                framesSkipped := framesSkipped + 1
            ]
    ].

    "Returns the __class of the method__, not !!!!!! the class of method's receiver !!!!!!"
    "                  |                                                            "
    "                  V                                                            "
    cls := frame method mclass theNonMetaclass.
    ^cls isJavaClass
        ifTrue:[JavaVM javaClassObjectForClass:cls]
        ifFalse:[nil]

    "Created: / 25-10-2010 / 16:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-01-2014 / 11:35:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_reflect_Reflection_getClassAccessFlags: this _:a1

    <javanative: 'sun/reflect/Reflection' name: 'getClassAccessFlags(Ljava/lang/Class;)I'>

        |class|

    class := Reflection classForJavaClassObject:a1.
    ^(class isJavaPrimitiveType or:[class isJavaArrayClass]) ifTrue:[
        1041"FIXME: make it symbolic"
    ] ifFalse:[
        class accessFlags
    ]

    "Created: / 26-11-2010 / 10:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 15:19:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 01-09-2011 / 09:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.rmi.server'!

_sun_rmi_server_MarshalInputStream_latestUserDefinedLoader: this

    <javanative: 'sun/rmi/server/MarshalInputStream' name: 'latestUserDefinedLoader()Ljava/lang/ClassLoader;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.jgss.wrapper'!

_sun_security_jgss_wrapper_GSSLibStub_acceptContext: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'acceptContext(JLorg/ietf/jgss/ChannelBinding;[BLsun/security/jgss/wrapper/NativeGSSContext;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_acquireCred: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'acquireCred(JII)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_canonicalizeName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'canonicalizeName(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_compareName: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'compareName(JJ)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_deleteContext: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'deleteContext(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_displayName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'displayName(J)[Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_exportContext: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'exportContext(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_exportName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'exportName(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getContextMech: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getContextMech(J)Lorg/ietf/jgss/Oid;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getContextName: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getContextName(JZ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getContextTime: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getContextTime(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getCredName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getCredName(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getCredTime: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getCredTime(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getCredUsage: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getCredUsage(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getMechPtr: this _: a1

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getMechPtr([B)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_getMic: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'getMic(JI[B)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_importContext: this _: a1

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'importContext([B)Lsun/security/jgss/wrapper/NativeGSSContext;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_importName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'importName([BLorg/ietf/jgss/Oid;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_indicateMechs: this

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'indicateMechs()[Lorg/ietf/jgss/Oid;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_init: this _: a1

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'init(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_initContext: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'initContext(JJLorg/ietf/jgss/ChannelBinding;[BLsun/security/jgss/wrapper/NativeGSSContext;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_inquireContext: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'inquireContext(J)[J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_inquireNamesForMech: this

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'inquireNamesForMech()[Lorg/ietf/jgss/Oid;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_releaseCred: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'releaseCred(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_releaseName: this _: a1 _: a2

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'releaseName(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_unwrap: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'unwrap(J[BLorg/ietf/jgss/MessageProp;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_verifyMic: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'verifyMic(J[B[BLorg/ietf/jgss/MessageProp;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_wrap: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'wrap(J[BLorg/ietf/jgss/MessageProp;)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_jgss_wrapper_GSSLibStub_wrapSizeLimit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/jgss/wrapper/GSSLibStub' name: 'wrapSizeLimit(JIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.krb5'!

_sun_security_krb5_Config_getWindowsDirectory: this

    <javanative: 'sun/security/krb5/Config' name: 'getWindowsDirectory()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_krb5_Credentials_acquireDefaultNativeCreds: this

    <javanative: 'sun/security/krb5/Credentials' name: 'acquireDefaultNativeCreds()Lsun/security/krb5/Credentials;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.pkcs11'!

_sun_security_pkcs11_Secmod_nssGetLibraryHandle: this _: a1

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssGetLibraryHandle(Ljava/lang/String;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_Secmod_nssGetModuleList: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssGetModuleList(J)Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_Secmod_nssInit: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssInit(Ljava/lang/String;JLjava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_Secmod_nssLoadLibrary: this _: a1

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssLoadLibrary(Ljava/lang/String;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_Secmod_nssVersionCheck: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssVersionCheck(JLjava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.pkcs11.wrapper'!

_sun_security_pkcs11_wrapper_PKCS11_C_CloseSession: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_CloseSession(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_CopyObject: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_CopyObject(JJ[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_CreateObject: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_CreateObject(J[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Decrypt: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Decrypt(J[BII[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DecryptFinal: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DecryptFinal(JJ[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DecryptInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DecryptInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DecryptUpdate: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DecryptUpdate(JJ[BIIJ[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DeriveKey: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DeriveKey(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DestroyObject: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DestroyObject(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DigestFinal: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DigestFinal(J[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DigestInit: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DigestInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DigestKey: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DigestKey(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DigestSingle: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DigestSingle(JLsun/security/pkcs11/wrapper/CK_MECHANISM;[BII[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_DigestUpdate: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_DigestUpdate(JJ[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Encrypt: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Encrypt(J[BII[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_EncryptFinal: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_EncryptFinal(JJ[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_EncryptInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_EncryptInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_EncryptUpdate: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_EncryptUpdate(JJ[BIIJ[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Finalize: this _: a1

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Finalize(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_FindObjects: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_FindObjects(JJ)[J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_FindObjectsFinal: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_FindObjectsFinal(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_FindObjectsInit: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_FindObjectsInit(J[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GenerateKey: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GenerateKey(JLsun/security/pkcs11/wrapper/CK_MECHANISM;[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GenerateKeyPair: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GenerateKeyPair(JLsun/security/pkcs11/wrapper/CK_MECHANISM;[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)[J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GenerateRandom: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GenerateRandom(J[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetAttributeValue: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetAttributeValue(JJ[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetInfo: this

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetInfo()Lsun/security/pkcs11/wrapper/CK_INFO;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetMechanismInfo: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetMechanismInfo(JJ)Lsun/security/pkcs11/wrapper/CK_MECHANISM_INFO;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetMechanismList: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetMechanismList(J)[J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetOperationState: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetOperationState(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetSessionInfo: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetSessionInfo(J)Lsun/security/pkcs11/wrapper/CK_SESSION_INFO;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetSlotInfo: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetSlotInfo(J)Lsun/security/pkcs11/wrapper/CK_SLOT_INFO;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetSlotList: this _: a1

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetSlotList(Z)[J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_GetTokenInfo: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_GetTokenInfo(J)Lsun/security/pkcs11/wrapper/CK_TOKEN_INFO;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Initialize: this _: a1

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Initialize(Ljava/lang/Object;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Login: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Login(JJ[C)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Logout: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Logout(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_OpenSession: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_OpenSession(JJLjava/lang/Object;Lsun/security/pkcs11/wrapper/CK_NOTIFY;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SeedRandom: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SeedRandom(J[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SetAttributeValue: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SetAttributeValue(JJ[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SetOperationState: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SetOperationState(J[BJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Sign: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Sign(J[B)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SignFinal: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SignFinal(JI)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SignInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SignInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SignRecover: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SignRecover(J[BII[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SignRecoverInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SignRecoverInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_SignUpdate: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_SignUpdate(JJ[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_UnwrapKey: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_UnwrapKey(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J[B[Lsun/security/pkcs11/wrapper/CK_ATTRIBUTE;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_Verify: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_Verify(J[B[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_VerifyFinal: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_VerifyFinal(J[B)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_VerifyInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_VerifyInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_VerifyRecover: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_VerifyRecover(J[BII[BII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_VerifyRecoverInit: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_VerifyRecoverInit(JLsun/security/pkcs11/wrapper/CK_MECHANISM;J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_VerifyUpdate: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_VerifyUpdate(JJ[BII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_C_WrapKey: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'C_WrapKey(JLsun/security/pkcs11/wrapper/CK_MECHANISM;JJ)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_connect: this _: a1 _: a2

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'connect(Ljava/lang/String;Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_disconnect: this

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'disconnect()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_finalizeLibrary: this

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'finalizeLibrary()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_wrapper_PKCS11_initializeLibrary: this

    <javanative: 'sun/security/pkcs11/wrapper/PKCS11' name: 'initializeLibrary()V'>

    "Nothing to do be default"

    "Modified: / 23-09-2013 / 23:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.provider'!

_sun_security_provider_NativeSeedGenerator_nativeGenerateSeed: this _:a1

    <javanative: 'sun/security/provider/NativeSeedGenerator' name: 'nativeGenerateSeed([B)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'native - sun.security.smartcardio'!

_sun_security_smartcardio_PCSC_SCardBeginTransaction: this _: a1 _: a2

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardBeginTransaction(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardConnect: this _: a1 _: a2 _: a3 _: a4 _: a5

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardConnect(JLjava/lang/String;II)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardControl: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardControl(JI[B)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardDisconnect: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardDisconnect(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardEndTransaction: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardEndTransaction(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardEstablishContext: this _: a1

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardEstablishContext(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardGetStatusChange: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardGetStatusChange(JJ[I[Ljava/lang/String;)[I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardListReaders: this _: a1 _: a2

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardListReaders(J)[Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardStatus: this _: a1 _: a2 _: a3

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardStatus(J[B)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PCSC_SCardTransmit: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/security/smartcardio/PCSC' name: 'SCardTransmit(JI[BII)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_smartcardio_PlatformPCSC_initialize: this _: a1

    <javanative: 'sun/security/smartcardio/PlatformPCSC' name: 'initialize(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK6 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

