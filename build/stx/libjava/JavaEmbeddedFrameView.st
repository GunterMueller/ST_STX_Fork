"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaView subclass:#JavaEmbeddedFrameView
	instanceVariableNames:'codeURL codeBaseURL documentURL archiveURL parameterDictionary
		embeddedAppletFrame applet appletID appletThread
		infoDisplayReceiver autoSetupApplet autoStartApplet
		autoDestroyApplet isNS40 attributeHashTable appletIsPreloaded'
	classVariableNames:'NextSequentialAppletID'
	poolDictionaries:''
	category:'Languages-Java-Views-Support'
!

!JavaEmbeddedFrameView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaEmbeddedFrameView class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaEmbeddedFrameView class methodsFor:'support'!

newAppletContext
    | jMozillaAppletContextClass |

    "/ this makes it a modzilla applet context ...
    jMozillaAppletContextClass := JavaVM 
                classForName: 'netscape.applet.MozillaAppletContext'.
    jMozillaAppletContextClass isNil ifTrue: [
        self warn: 'no netscape.applet.MozillaAppletContext class'.
        ^ nil
    ].
    jMozillaAppletContextClass instVarNamed: 'debug' put: 1.
    ^ jMozillaAppletContextClass new.

    "Created: / 20.10.1998 / 15:40:08 / cg"
    "Modified: / 20.10.1998 / 15:43:47 / cg"
! !

!JavaEmbeddedFrameView methodsFor:'accessing'!

applet
    ^ applet

    "Created: / 26.1.1999 / 13:51:10 / cg"
!

appletID
    "return the value of the instance variable 'appletID' (automatically generated)"

    ^ appletID

    "Created: / 28.1.1998 / 21:08:54 / cg"
!

appletID:something
    "set the value of the instance variable 'appletID' (automatically generated)"

    appletID := something.

    "Created: / 28.1.1998 / 21:08:54 / cg"
!

appletIsPreloaded:aBoolean
    appletIsPreloaded := aBoolean.
!

appletThread
    ^ appletThread

    "Created: / 28.1.1998 / 21:39:42 / cg"
!

archiveURL:anArchiveURLString
    archiveURL := anArchiveURLString

    "Created: / 28.1.1998 / 21:00:38 / cg"
!

codeBaseURL:aCodeBaseURLString
    codeBaseURL := aCodeBaseURLString

    "Created: / 28.1.1998 / 20:59:34 / cg"
!

codeURL:aCodeURLString
    codeURL := aCodeURLString

    "Created: / 28.1.1998 / 21:10:11 / cg"
!

documentURL:aDocumentURLString
    documentURL := aDocumentURLString

    "Created: / 28.1.1998 / 21:00:03 / cg"
    "Modified: / 28.1.1998 / 21:00:28 / cg"
!

embeddedAppletFrame
    ^ embeddedAppletFrame

    "Created: / 28.1.1998 / 21:39:35 / cg"
!

infoDisplayReceiver
    "return the value of the instance variable 'infoDisplayReceiver' (automatically generated)"

    ^ infoDisplayReceiver

    "Created: / 28.1.1998 / 21:43:54 / cg"
!

infoDisplayReceiver:something
    "set the value of the instance variable 'infoDisplayReceiver' (automatically generated)"

    infoDisplayReceiver := something.

    "Created: / 28.1.1998 / 21:43:54 / cg"
!

parameterAt:key put:valueString
    parameterDictionary isNil ifTrue:[
        parameterDictionary := IdentityDictionary new.
    ].
    parameterDictionary at:key put:valueString.
    attributeHashTable 
        perform:#'put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;'
        with:(Java as_String:key)
        with:(Java as_String:valueString)

    "Created: / 26.1.1999 / 13:46:01 / cg"
    "Modified: / 28.1.1999 / 17:59:36 / cg"
!

parameterDictionary:aParameterDictionary
    parameterDictionary := aParameterDictionary

    "Created: / 28.1.1998 / 21:01:20 / cg"
! !

!JavaEmbeddedFrameView methodsFor:'applet control'!

appletDESTROY
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_DESTROY);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_DESTROY').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_DESTROY').

    "Created: / 28.1.1998 / 21:41:45 / cg"
    "Modified: / 13.11.1998 / 14:19:49 / cg"
!

appletDISPOSE
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_DISPOSE);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_DISPOSE').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_DISPOSE').

    "Created: / 28.1.1998 / 21:41:57 / cg"
    "Modified: / 13.11.1998 / 14:19:43 / cg"
!

appletINIT
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_INIT);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_INIT').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_INIT').

    "Created: / 28.1.1998 / 21:17:51 / cg"
    "Modified: / 13.11.1998 / 14:19:35 / cg"
!

appletLOAD
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_LOAD);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_LOAD').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_LOAD').

    "Created: / 28.1.1998 / 21:17:37 / cg"
    "Modified: / 13.11.1998 / 14:19:31 / cg"
!

appletSTART
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_START);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_START').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_START').

    "Created: / 28.1.1998 / 21:18:01 / cg"
    "Modified: / 13.11.1998 / 14:19:21 / cg"
!

appletSTOP
    | ev |

    isNS40 ifTrue: [
        "/ ev = netscape.applet.AppletEvent(APPLET_STOP);
        ev := (JavaVM classForName: 'netscape.applet.AppletEvent') 
                    newWith_int: (embeddedAppletFrame class instVarNamed: 'APPLET_STOP').
        embeddedAppletFrame perform: #'sendEvent(Lnetscape/applet/NEvent;)V'
            with: ev.
        ^ self
    ].
    embeddedAppletFrame perform: #'sendEvent(I)V'
        with: (embeddedAppletFrame class instVarNamed: 'APPLET_STOP').

    "Created: / 28.1.1998 / 21:41:33 / cg"
    "Modified: / 13.11.1998 / 14:19:14 / cg"
!

autoDestroyApplet:aBoolean
    "set/clear the autoDestroy flag.
     If set, the applet will be shutDown whenever the I get destroyed.
     if clear, the applet is not automatically shutDown and must be
     terminated by someone else.
     The default is false."

    autoDestroyApplet := aBoolean.

    "Created: / 29.1.1998 / 15:18:50 / cg"
    "Modified: / 29.1.1998 / 15:21:01 / cg"
!

autoSetupApplet:aBoolean
    "set/clear the autoSetup flag.
     If set, the appletFrame will be setup whenever the I get realized
     for the first time.
     If clear, the frame is not automatically setup and must be
     setup by someone else.
     The default is true."


    autoSetupApplet := aBoolean.

    "Created: / 29.1.1998 / 15:18:41 / cg"
    "Modified: / 29.1.1998 / 20:45:37 / cg"
!

autoStartApplet:aBoolean
    "set/clear the autoStart flag.
     If set, the applet will be loaded & started whenever the I get realized
     for the first time.
     If clear, the applet is not automatically started and must be
     started by someone else.
     The default is false."


    autoStartApplet := aBoolean.

    "Created: / 29.1.1998 / 15:18:41 / cg"
    "Modified: / 29.1.1998 / 15:20:54 / cg"
!

startApplet
    "/ ensure its initialized when the first event comes;
    "/ therefore, raise my prio above the event dispatchers prio for a while.

    Processor activeProcess withPriority:(Processor activePriority + 1)
    do:[
        self startAppletThread.

        appletIsPreloaded ifFalse:[self appletLOAD].
        self appletINIT.
    ].

    self appletSTART

    "Modified: / 28.1.1998 / 21:30:24 / cg"
!

startAppletThread
    |appletName|

    appletThread := JavaProcess 
            for:[
                    "/ passnotifications to the documentFrame ...
                    UserInformation handle:[:ex |
                        JavaVM javaConsoleStream showCR:ex errorString.
                        ex proceed.
                    ] do:[
                        ActivityNotification handle:[:ex |
                            infoDisplayReceiver notNil ifTrue:[
                                infoDisplayReceiver infoDisplay:ex errorString.
                            ] ifFalse:[
                                Transcript showCR:ex errorString
                            ].
                            ex proceed.
                        ] do:[
                            [
                                "/ Transcript showCR:(Timestamp now printString , ' start embeddedAppletFrame').
                                embeddedAppletFrame perform:#'run()V'.
                            ] ensure:[
                                appletThread notNil ifTrue:[
                                    appletThread terminateAllSubprocesses.
                                ].
                                Logger log:'JAVA applet startup finished' severity: Logger severityDEBUG facility: 'JVM'
                            ]
                        ]
                    ]
                ]
            priority:(Processor activePriority "- 1").

    appletName := codeURL asFilename withoutSuffix baseName.
    appletThread name:('JAVA-' , appletName , '-applet' , ' [startup]').
    appletThread restartable:true.
    appletThread resume.
    ^ appletThread.

    "Created: / 28-01-1998 / 21:30:32 / cg"
    "Modified: / 24-12-1999 / 02:58:50 / cg"
    "Modified: / 02-03-2015 / 14:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopApplet
    |n n2|

    (appletThread notNil 
    and:[appletThread isDead not])ifTrue:[
"/        'EmbeddedAppletFrame [info]: send APPLET_STOP ...' infoPrintCR.
        self appletSTOP.

"/        'EmbeddedAppletFrame [info]: send APPLET_DESTROY ...' infoPrintCR.
        self appletDESTROY.

"/        'EmbeddedAppletFrame [info]: send APPLET_DISPOSE ...' infoPrintCR.
        self appletDISPOSE.

        "/
        "/ give it a chance to stop ...
        "/
        Processor yield.
        n2 := 0.
        [appletThread isDead] whileFalse:[
            "/ give it a second to shut down ...
            n := 0.
            [n < 10 and:[appletThread isDead not]] whileTrue:[
                Delay waitForSeconds:0.1.
                n := n + 1.
            ].
            appletThread isDead ifFalse:[
                "/ after 3 seconds, kill it.
                Logger log:'EmbeddedAppletFrame: JAVA thread did not stop - soft terminate ...'  severity: Logger severityDEBUG facility: 'JVM'.
appletThread == JavaVM javaScreenUpdaterThread ifTrue:[self halt].
appletThread == JavaVM javaEventQueueThread ifTrue:[self halt].
                appletThread terminate.
                n2 := n2 + 1.
                n2 > 3 ifTrue:[
                    Logger log:'EmbeddedAppletFrame: JAVA thread did not stop - shooting down ...' severity: Logger severityDEBUG facility: 'JVM'.
                    appletThread terminateNoSignal
                ]
            ].
        ].
    ].
    appletThread := nil

    "Modified: / 24-12-1999 / 02:35:25 / cg"
    "Modified: / 02-03-2015 / 14:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEmbeddedFrameView methodsFor:'initialize / release'!

destroy
    autoDestroyApplet == true ifTrue:[
        self stopApplet
    ].
    super destroy.

    "Created: / 29.1.1998 / 15:21:45 / cg"
    "Modified: / 29.1.1998 / 15:28:26 / cg"
!

initialize           
    appletIsPreloaded := false.
    super initialize.
    viewBackground := Color black.

    "Modified: / 28.1.1999 / 17:44:11 / cg"
!

realize
    autoSetupApplet ~~ false ifTrue:[
        self setupAppletFrameIn:nil initializeJava:true
    ].
    autoStartApplet == true ifTrue:[
        embeddedAppletFrame notNil ifTrue:[
            self startApplet
        ]
    ].
    super realize.

    "Created: / 29.1.1998 / 15:21:30 / cg"
    "Modified: / 20.10.1998 / 15:46:32 / cg"
! !

!JavaEmbeddedFrameView methodsFor:'private'!

setupAppletFrameIn:anAppletContextOrNil
     ^ self setupAppletFrameIn:anAppletContextOrNil initializeJava:true.
!

setupAppletFrameIn: anAppletContextOrNil initializeJava: initializeJava 
    | appletContext  jEmbeddedAppletFrameClass  jDerivedAppletFrameClass  toolkit  peer  attribs  id  jCodeBaseURL  jDocumentURL  jArchiveURL  u  fn |

    embeddedAppletFrame notNil ifTrue: [
        "/ already setup
        ^ self
    ].
    codeBaseURL isNil ifTrue: [ ^ self ].
    initializeJava ifTrue: [ Java startupJavaSystem. ] ifFalse: [
        JavaVM initializeVMIfNoEventThreadRunning
    ].
    
    "/ if its a relative file-URL, make it relative under
    "/ java...
    
    u := URL fromString: codeBaseURL.
    u method = 'file' ifTrue: [
        fn := Smalltalk getSystemFileName: u file.
        fn isNil ifTrue: [
            fn := Smalltalk getPackageFileName: ('stx/libjava/' , u file).
        ]
    ].
    fn notNil ifTrue: [ fn := 'file:' , fn asFilename pathName ] ifFalse: [
        fn := codeBaseURL
    ].
    jCodeBaseURL := Java as_URL: fn.
    documentURL notNil ifTrue: [ jDocumentURL := Java as_URL: documentURL. ] ifFalse: [
        jDocumentURL := Java as_URL: fn
    ].
    archiveURL notNil ifTrue: [ jArchiveURL := Java as_URL: archiveURL. ].
    id := appletID.
    id isNil ifTrue: [
        NextSequentialAppletID isNil ifTrue: [ NextSequentialAppletID := 1. ].
        id := NextSequentialAppletID.
        NextSequentialAppletID := NextSequentialAppletID + 1
    ].
    attribs := Dictionary new.
    width notNil ifTrue: [ attribs at: 'width' put: width printString ].
    height notNil ifTrue: [ attribs at: 'height' put: height printString ].
    codeURL notNil ifTrue: [ attribs at: 'code' put: codeURL ].
    parameterDictionary notNil ifTrue: [
        attribs declareAllFrom: parameterDictionary
    ].
    attributeHashTable := Java as_Hashtable: attribs.
    anAppletContextOrNil notNil ifTrue: [ appletContext := anAppletContextOrNil ] ifFalse: [
        appletContext := self class newAppletContext.
        appletContext isNil ifTrue: [
            self warn: 'no netscape.applet.MozillaAppletContext class'.
            ^ false
        ].
    ].
    jEmbeddedAppletFrameClass := JavaVM 
                classForName: 'netscape.applet.EmbeddedAppletFrame'.
    jEmbeddedAppletFrameClass isNil ifTrue: [
        self warn: 'no netscape.applet.EmbeddedAppletFrame class'.
        ^ false
    ].
    jDerivedAppletFrameClass := Java 
                classForName: 'netscape.applet.DerivedAppletFrame'.
    jDerivedAppletFrameClass notNil ifTrue: [
        "/ ns4.0
        embeddedAppletFrame := jDerivedAppletFrameClass new.
        isNS40 := true.
    ] ifFalse: [
        "/ ns3.x
        embeddedAppletFrame := jEmbeddedAppletFrameClass new.
        isNS40 := false.
    ].
    embeddedAppletFrame instVarNamed: 'pData' put: self.
    toolkit := (Java classForName: 'java.awt.Toolkit') 
                perform: #getDefaultToolkit.
    peer := toolkit 
                perform: #'createFrame(Ljava/awt/Frame;)Ljava/awt/peer/FramePeer;'
                with: embeddedAppletFrame.
    (embeddedAppletFrame 
        respondsTo: #'<init>(Ljava/net/URL;Ljava/net/URL;Ljava/net/URL;Ljava/util/Hashtable;Lnetscape/applet/MozillaAppletContext;Ljava/lang/Integer;Z)V') 
            ifTrue: [
                "/ 4.0 netscape
                embeddedAppletFrame 
                    perform: #'<init>(Ljava/net/URL;Ljava/net/URL;Ljava/net/URL;Ljava/util/Hashtable;Lnetscape/applet/MozillaAppletContext;Ljava/lang/Integer;Z)V'
                    withArguments: (Array 
                            with: jDocumentURL
                            with: jCodeBaseURL
                            with: jArchiveURL
                            with: attributeHashTable
                            with: appletContext
                            with: (Java as_Integer: id)
                            with: 0).
                
                "/ reloadClasses-boolean
            ]
            ifFalse: [
                (embeddedAppletFrame 
                    respondsTo: #'<init>(Ljava/net/URL;Ljava/net/URL;Ljava/net/URL;Ljava/util/Hashtable;Lnetscape/applet/MozillaAppletContext;Ljava/lang/Integer;)V') 
                        ifTrue: [
                            "/ 3.01 netscape
                            embeddedAppletFrame 
                                perform: #'<init>(Ljava/net/URL;Ljava/net/URL;Ljava/net/URL;Ljava/util/Hashtable;Lnetscape/applet/MozillaAppletContext;Ljava/lang/Integer;)V'
                                with: jDocumentURL
                                with: jCodeBaseURL
                                with: jArchiveURL
                                with: attributeHashTable
                                with: appletContext
                                with: (Java as_Integer: id).
                        ]
                        ifFalse: [
                            "/ oldStyle netscape
                            embeddedAppletFrame 
                                perform: #'<init>(Ljava/net/URL;Ljava/net/URL;Ljava/util/Hashtable;Lnetscape/applet/MozillaAppletContext;I)V'
                                with: jDocumentURL
                                with: jCodeBaseURL
                                with: attributeHashTable
                                with: appletContext
                                with: id.
                        ].
            ].
    embeddedAppletFrame instVarNamed: 'peer' put: peer.
    self javaPeer: peer.
    ^ true

    "Created: / 20.10.1998 / 15:47:04 / cg"
    "Modified: / 24.12.1999 / 01:38:17 / cg"
! !

!JavaEmbeddedFrameView methodsFor:'resizing'!

sizeChanged:how
    super sizeChanged:how.
^ self.
    embeddedAppletFrame notNil ifTrue:[
        (embeddedAppletFrame perform:#'isResizable()Z') ~~ 0 ifTrue:[
            self windowGroup sensor
                 pushDamageEvent:(WindowEvent
                                     for:self
                                     type:#configureX:y:width:height:
                                     arguments:(Array with:left with:top with:width with:height)).
"/            embeddedAppletFrame
"/                perform:#'appletResize(II)V'
"/                with:self width
"/                with:self height.
        ]
    ]

    "Modified: / 1.2.1998 / 19:15:07 / cg"
! !

!JavaEmbeddedFrameView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaEmbeddedFrameView.st,v 1.35 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaEmbeddedFrameView.st,v 1.35 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !

