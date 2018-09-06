"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#XEmbedContainerView
	instanceVariableNames:'clientViewId clientView workarounds'
	classVariableNames:'XEMBED_EMBEDDED_NOTIFY XEMBED_WINDOW_ACTIVATE
		XEMBED_WINDOW_DEACTIVATE XEMBED_REQUEST_FOCUS XEMBED_FOCUS_IN
		XEMBED_FOCUS_OUT XEMBED_FOCUS_NEXT XEMBED_FOCUS_PREV
		XEMBED_MODALITY_ON XEMBED_MODALITY_OFF
		XEMBED_REGISTER_ACCELERATOR XEMBED_UNREGISTER_ACCELERATOR
		XEMBED_ACTIVATE_ACCELERATOR XEMBED_FOCUS_CURRENT
		XEMBED_FOCUS_FIRST XEMBED_FOCUS_LAST'
	poolDictionaries:''
	category:'Views-XEmbed'
!

SimpleView subclass:#ClientView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XEmbedContainerView
!

!XEmbedContainerView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    I can be used to embed alien views under X Window.
    I implement the XEmbed protocol:
    http://standards.freedesktop.org/xembed-spec/xembed-spec-latest.html
    

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XEmbedContainerView class methodsFor:'initialization'!

initialize

    "From http://standards.freedesktop.org/xembed-spec/xembed-spec-latest.html:

    #define XEMBED_EMBEDDED_NOTIFY      0
    #define XEMBED_WINDOW_ACTIVATE      1
    #define XEMBED_WINDOW_DEACTIVATE    2
    #define XEMBED_REQUEST_FOCUS        3
    #define XEMBED_FOCUS_IN         4
    #define XEMBED_FOCUS_OUT        5
    #define XEMBED_FOCUS_NEXT       6
    #define XEMBED_FOCUS_PREV       7
    
    #define XEMBED_MODALITY_ON      10
    #define XEMBED_MODALITY_OFF         11
    #define XEMBED_REGISTER_ACCELERATOR     12
    #define XEMBED_UNREGISTER_ACCELERATOR   13
    #define XEMBED_ACTIVATE_ACCELERATOR     14


    A detail code is required for XEMBED_FOCUS_IN. The following values are valid:
    #define XEMBED_FOCUS_CURRENT        0
    #define XEMBED_FOCUS_FIRST      1
    #define XEMBED_FOCUS_LAST       2

    "


    XEMBED_EMBEDDED_NOTIFY              := 0.
    XEMBED_WINDOW_ACTIVATE              := 1.
    XEMBED_WINDOW_DEACTIVATE            := 2.
    XEMBED_REQUEST_FOCUS                := 3.
    XEMBED_FOCUS_IN                     := 4.
    XEMBED_FOCUS_OUT                    := 5.
    XEMBED_FOCUS_NEXT                   := 6.
    XEMBED_FOCUS_PREV                   := 7.

    XEMBED_MODALITY_ON                  := 10.
    XEMBED_MODALITY_OFF                 := 11.
    XEMBED_REGISTER_ACCELERATOR         := 12.
    XEMBED_UNREGISTER_ACCELERATOR       := 13.
    XEMBED_ACTIVATE_ACCELERATOR         := 14.


    XEMBED_FOCUS_CURRENT                := 0.
    XEMBED_FOCUS_FIRST                  := 1.
    XEMBED_FOCUS_LAST                   := 2.

    "Created: / 30-05-2011 / 19:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView class methodsFor:'startup'!

open
    "launch a new workspace"
    
    |xembed topView|

    topView := StandardSystemView extent:(640 @ 480).
    xembed := self in:topView.
    xembed origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    
    "/ adjust topViews extent according to my font
    
    topView open.
    Delay waitForMilliseconds:5.
    topView 
        label:(self classResources string:'XEmbedContainerView ' 
                        , xembed embeddingWindowId printString).
    self == XEmbedContainerView 
        ifTrue:
            [ Transcript
                show:'XEmbed Socket WID: ' , xembed embeddingWindowId printString;
                cr ].
    ^ xembed

    "
      Workspace open
    "

    "Modified: / 16-05-1998 / 16:53:53 / cg"
    "Created: / 30-05-2011 / 23:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2011 / 18:40:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView methodsFor:'accessing'!

embeddingWindowId
    ^ self drawableId address

    "Created: / 06-06-2011 / 10:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workarounds
    ^ workarounds ? #()

    "Modified: / 03-06-2011 / 09:58:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workarounds:something
    workarounds := something.
! !

!XEmbedContainerView methodsFor:'event handling'!

clientPlugged

    "Triggered when client application plugged into
     the view"

    "Modified: / 06-06-2011 / 10:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clientUnplugged: clientInitiated

    "Triggered when client uplugs. If the client itself
     unplugs, then clientInitiated is true, false otherwise"

    "Created: / 06-06-2011 / 10:02:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createWindowX:x y:y width:w height:h
    |childWindowIds|

    childWindowIds := device childIdsOf:self drawableId.
    childWindowIds size == 1 
        ifFalse:[ self error:'I should have exactly one child'. ].
    clientViewId := childWindowIds first.
    clientView := ClientView new setContainer: self id: clientViewId.
    self sendXEmbeddedNotify.    
    self clientPlugged.

    "
     device getGeometryOf:clientWindowId"
    "/device mapWindow: clientWindowId.

    "Created: / 01-06-2011 / 12:56:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 18:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destroyed
    "A client just destroyed its window"

    | childWindowIds |

    childWindowIds := device childIdsOf: self drawableId.  
    childWindowIds size == 0 ifTrue:[
        device removeKnownView: clientView withId: clientViewId.
        clientViewId := nil.
        clientView := nil.        
    ].
    self clientUnplugged: true.

    "Created: / 30-05-2011 / 19:24:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2011 / 10:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

focusIn

    super focusIn.

    self sendXEmbedEvent: XEMBED_FOCUS_IN
         detail: 0 data1: 0 data2: 0

    "Created: / 31-05-2011 / 00:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

focusOut

    super focusOut.

    self sendXEmbedEvent: XEMBED_FOCUS_OUT
         detail: 0 data1: 0 data2: 0

    "Created: / 31-05-2011 / 00:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasKeyboardFocus:aBoolean

    super hasKeyboardFocus:aBoolean.

    self sendXEmbedEvent: (aBoolean ifTrue:[XEMBED_FOCUS_IN] ifFalse:[XEMBED_FOCUS_OUT])
         detail: 0 data1: 0 data2: 0

    "Created: / 03-04-2012 / 10:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView methodsFor:'event sending'!

sendXEmbedEvent: message detail: detail data1: data1 data2: data2

    clientViewId ifNil:[^self].

    (device 
        sendClientEvent: (device atomIDOf:'_XEMBED') 
        format:32 
        to:clientViewId 
        propagate:false 
        eventMask:nil 
        window:clientViewId 
        data1:0 
        data2:message 
        data3:detail
        data4:data1 
        data5:data2) ifFalse:[self breakPoint: #jv].

    "Created: / 30-05-2011 / 19:40:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2011 / 13:04:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendXEmbeddedNotify
    self 
        sendXEmbedEvent: XEMBED_EMBEDDED_NOTIFY
        detail: nil 
        data1: self drawableId 
        data2: 0

    "Created: / 30-05-2011 / 19:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView methodsFor:'initialization & release'!

initEvents

    super initEvents.
    self enableEvent: #substructureNotify.
    self enableEvent: #substructureRedirect.

    "Created: / 31-05-2011 / 00:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2012 / 10:12:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView methodsFor:'workarounds'!

hasWorkaround: symbol

    workarounds ifNil:[^false].
    ^workarounds includes: symbol.

    "Created: / 03-06-2011 / 10:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useWorkaround: symbol

    workarounds := (workarounds ? #()) , (Array with: symbol)

    "Created: / 03-06-2011 / 10:01:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView::ClientView methodsFor:'event handling'!

focusIn

    super focusIn.

    superView sendXEmbedEvent: "XEMBED_FOCUS_IN"4
         detail: 0 data1: 0 data2: 0

    "Created: / 31-05-2011 / 00:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

focusOut

    super focusOut.

    superView sendXEmbedEvent: "XEMBED_FOCUS_OUT"5
         detail: 0 data1: 0 data2: 0

    "Created: / 31-05-2011 / 00:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasKeyboardFocus:aBoolean

    super hasKeyboardFocus:aBoolean.

    superView sendXEmbedEvent: (aBoolean ifTrue:[4] ifFalse:[5])
         detail: 0 data1: 0 data2: 0

    "Created: / 03-04-2012 / 10:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyChange:propertyId state:state 
    propertyId == (device atomIDOf:'_XEMBED_INFO') ifTrue:[ 
        self mapUnmapAccordingToXEmbedInfo. 
        ^self.
    ].

    (superView notNil and:[superView hasWorkaround: #uzbl]) ifTrue:[
        propertyId == (device atomIDOf:'WM_NORMAL_HINTS') ifTrue:[         
            device
                resizeWindow:self drawableId 
                width: 0  height: 0.
            device
                resizeWindow:self drawableId 
                width: self width - 1  height: self height - 1.
        ]
    ]

    "Created: / 01-06-2011 / 13:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2011 / 23:29:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView::ClientView methodsFor:'initialization & release'!

destroy
    superView notNil ifTrue:[
        superView clientUnplugged: false.
        superView removeSubView:self.
    ].
    self drawableId notNil ifTrue:[
        device
           reparentWindow: self drawableId to: device rootWindowId;
           removeKnownView:self withId:self drawableId.
    ]

    "Created: / 02-06-2011 / 17:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2012 / 17:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initEvents
    |graphicsDevice|

    graphicsDevice := device.

    graphicsDevice
        setEventMask:
            ((graphicsDevice eventMaskFor:#structureNotify) bitOr:
            ((graphicsDevice eventMaskFor:#propertyChange) bitOr:
             (graphicsDevice eventMaskFor:#focusChange)))
        in:self drawableId.

    "Created: / 02-06-2011 / 17:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setContainer: container id: wid
    self setDevice:container device id:wid gcId:nil.
    superView := container.
    windowGroup := container windowGroup.
    device addKnownView: self withId: wid.
    container add: self.
    self initEvents.
    self origin: 0.0@0.0 corner: 1.0@1.0.

    "Created: / 02-06-2011 / 17:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 19:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView::ClientView methodsFor:'private'!

mapUnmapAccordingToXEmbedInfo
    |val|

    val := device 
                getProperty:(device atomIDOf:'_XEMBED_INFO')
                from:self drawableId
                delete:false.
    val ifNil:
            [ self map.
            ^ self ].
    val key == 0 ifTrue:
            [^self"Huh. may this happen"].
    val value second == 1  
        ifTrue:[ shown ifFalse:[ self map ] ]
        ifFalse:[ shown ifTrue:[ self unmap ] ].

    "Created: / 02-06-2011 / 18:04:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XEmbedContainerView class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !


XEmbedContainerView initialize!
