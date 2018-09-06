"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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

ApplicationModel subclass:#EventMonitor
	instanceVariableNames:'outputSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

View subclass:#EventMonitorView
	instanceVariableNames:'outputStream labelHolder showButtonMotion showFocusEvents
		showTimestamp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EventMonitor
!

!EventMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    like xev - show events.

    You can use this to check your keyboard mappings, for example.
    start with:
        EventMonitor open
    and watch the output on the xterm/console.
"
! !

!EventMonitor class methodsFor:'defaults'!

defaultExtent
    ^ 200 @ 200
!

defaultLabel
    ^ 'Event Monitor'
! !

!EventMonitor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:EventMonitor andSelector:#windowSpec
     EventMonitor new openInterface:#windowSpec
     EventMonitor open
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: windowSpec
        window:
       (WindowSpec
          label: 'EventMonitor'
          name: 'EventMonitor'
          min: (Point 100 100)
          bounds: (Rectangle 0 0 300 300)
          menu: mainMenu
        )
        component:
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'eventMonitorView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: EventMonitorView
            )
           )

        )
      )
! !

!EventMonitor class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:EventMonitor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(EventMonitor mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu:
           (Menu
              (
               (MenuItem
                  label: 'Open Modal Box'
                  itemValue: openModalBox
                  translateLabel: true
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Filter'
            translateLabel: true
            submenu:
           (Menu
              (
               (MenuItem
                  label: 'Show ButtonMotion Events'
                  itemValue: showButtonMotion:
                  translateLabel: true
                  indication: showButtonMotion
                )
               (MenuItem
                  label: 'Show Focus Events'
                  itemValue: showFocusEvents:
                  translateLabel: true
                  indication: showFocusEvents
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Output'
            translateLabel: true
            submenu:
           (Menu
              (
               (MenuItem
                  label: 'Stdout'
                  translateLabel: true
                  choice: outputSelector
                  choiceValue: stdout
                )
               (MenuItem
                  label: 'Transcript'
                  translateLabel: true
                  choice: outputSelector
                  choiceValue: transcript
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show Timestamp'
                  itemValue: showTimestamp:
                  translateLabel: true
                  indication: showTimestamp
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            translateLabel: true
            startGroup: right
            submenu:
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!EventMonitor methodsFor:'aspects'!

eventMonitorView
    ^ (self builder componentAt:#eventMonitorView)
!

outputSelector
    outputSelector isNil ifTrue:[
        outputSelector := #transcript asValue.
        outputSelector onChangeEvaluate:[ self outputSelectorChanged ].
    ].
    ^ outputSelector
!

outputSelectorChanged
    |stream|

    stream := self outputSelector value == #transcript ifTrue:[Transcript] ifFalse:[Stdout].
    self eventMonitorView outputStream:stream.
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self outputSelectorChanged.
!

showButtonMotion
    ^ self eventMonitorView showButtonMotion
!

showButtonMotion:aBoolean
    ^ self eventMonitorView showButtonMotion:aBoolean
!

showFocusEvents
    ^ self eventMonitorView showFocusEvents

    "Created: / 04-10-2006 / 13:05:16 / cg"
!

showFocusEvents:aBoolean
    ^ self eventMonitorView showFocusEvents:aBoolean

    "Created: / 04-10-2006 / 13:05:19 / cg"
!

showTimestamp
    ^ self eventMonitorView showTimestamp

    "Created: / 04-10-2006 / 13:14:49 / cg"
!

showTimestamp:aBoolean
    ^ self eventMonitorView showTimestamp:aBoolean

    "Created: / 04-10-2006 / 13:14:53 / cg"
! !

!EventMonitor methodsFor:'menu actions'!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#EVENTMONITOR'.
!

openModalBox
    Dialog information:'Modal Box'
! !

!EventMonitor::EventMonitorView class methodsFor:'defaults'!

defaultExtent
    ^ 200 @ 200
!

defaultLabel
    ^ 'Event Monitor'
! !

!EventMonitor::EventMonitorView class methodsFor:'documentation'!

documentation
"
    like xev - show events.
    You can use this to check your keyboard mappings, for example.
    start with:
        EventMonitorView open
    and watch the output on xterm.
"
! !

!EventMonitor::EventMonitorView class methodsFor:'startup'!

isVisualStartable
    ^ true

    "Created: / 10.8.1998 / 16:03:13 / cg"
! !

!EventMonitor::EventMonitorView methodsFor:'accessing'!

outputStream:aStream
    outputStream := aStream.

    labelHolder value:nil.
    outputStream == Stdout ifTrue:[
        labelHolder value: 'See event trace\on the standard output' withCRs.
    ].
    outputStream == Transcript ifTrue:[
        labelHolder value: 'See event trace\on the Transcript' withCRs.
    ].
    self invalidate.

    "Modified: / 04-10-2006 / 13:04:16 / cg"
!

showButtonMotion
    ^ showButtonMotion ? false

    "Modified: / 04-10-2006 / 13:03:31 / cg"
!

showButtonMotion:aBoolean
    showButtonMotion := aBoolean.

    "Modified: / 04-10-2006 / 13:04:08 / cg"
!

showFocusEvents
    ^ showFocusEvents ? true

    "Created: / 04-10-2006 / 13:03:48 / cg"
!

showFocusEvents:aBoolean
    showFocusEvents := aBoolean.

    "Created: / 04-10-2006 / 13:04:04 / cg"
!

showTimestamp
    ^ showTimestamp ? false

    "Created: / 04-10-2006 / 13:06:57 / cg"
!

showTimestamp:aBoolean
    showTimestamp := aBoolean.

    "Created: / 04-10-2006 / 13:07:02 / cg"
! !

!EventMonitor::EventMonitorView methodsFor:'drawing'!

redraw
    |y p lines font|

    self clear.
    lines := labelHolder value asCollectionOfLines.
    font := gc font.

    y := (self height - ((font heightOf:'A') * lines size)) // 2.
    lines do:[:eachLine |
        p := (self center x - ((font widthOf:eachLine) // 2)) @ y.
        self displayString:eachLine value x:(p x) y:(p y).
        y := y + (font heightOf:eachLine).
    ]
!

showEventTime
    self showTimestamp ifTrue:[
        Transcript show:(Timestamp now); show:' '.
    ]

    "Created: / 04-10-2006 / 13:08:27 / cg"
! !

!EventMonitor::EventMonitorView methodsFor:'events'!

buttonMotion:state x:x y:y
    self showButtonMotion ifFalse:[^ self].

    self showEventTime.
    outputStream nextPutAll:'buttonMotion x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' state:'.
    state printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:07:53 / cg"
!

buttonMultiPress:button x:x y:y
    self showEventTime.

    outputStream nextPutAll:'buttonMultiPress x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' button:'.
    button printOn:outputStream.
    outputStream cr.

    "Created: / 19-05-1999 / 09:40:40 / cg"
    "Modified: / 04-10-2006 / 13:08:36 / cg"
!

buttonPress:button x:x y:y
    self showEventTime.

    outputStream nextPutAll:'buttonPress x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' button:'.
    button printOn:outputStream.
    outputStream cr.
    outputStream flush.

    "Modified: / 04-10-2006 / 13:08:43 / cg"
!

buttonRelease:button x:x y:y
    self showEventTime.

    outputStream nextPutAll:'buttonRelease x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' button:'.
    button printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:08:46 / cg"
!

configureX:x y:y width:newWidth height:newHeight
    self showEventTime.

    outputStream nextPutAll:'configure x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' width:'.
    newWidth printOn:outputStream.
    outputStream nextPutAll:' height:'.
    newHeight printOn:outputStream.
    outputStream nextPutAll:' button:'.
    outputStream cr.

    super configureX:x y:y width:newWidth height:newHeight.

    self invalidate.

    "Modified: / 04-10-2006 / 13:08:49 / cg"
!

coveredBy:coveringView

    self showEventTime.

    outputStream nextPutAll:'coveredBy: '.
    coveringView printOn:outputStream.
    outputStream cr.
!

dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate
    event isButtonMotionEvent ifTrue:[
        self showButtonMotion ifFalse:[^ self].
    ].

"/    Timestamp now printOn:outputStream.
"/    outputStream nextPutAll:' '.

    super dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate.

    "Created: / 20-09-2006 / 10:29:38 / cg"
!

dropMessage:dropType data:dropData
    self showEventTime.

    outputStream nextPutAll:'drop '.
    dropType printOn:outputStream.
    outputStream nextPutAll:' data:'.
    dropData printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:09:13 / cg"
!

focusIn
    self showFocusEvents ifFalse:[^ self].

    self showEventTime.

    outputStream nextPutLine:'focusIn '.

    "Created: / 07-03-1996 / 15:06:18 / cg"
    "Modified: / 04-10-2006 / 13:09:17 / cg"
!

focusOut
    self showFocusEvents ifFalse:[^ self].

    self showEventTime.

    outputStream nextPutLine:'focusOut '.

    "Created: / 07-03-1996 / 15:06:21 / cg"
    "Modified: / 04-10-2006 / 13:09:20 / cg"
!

hasKeyboardFocus:aBoolen
    self showFocusEvents ifFalse:[^ self].

    self showEventTime.

    outputStream nextPutAll:'hasKeyboardFocus:'.
    aBoolen printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:09:23 / cg"
!

keyPress:key x:x y:y
    | s rawKey binding |

    self showEventTime.

    s := 'KeyPress x:' , x printString , ' y:' , y printString.
    s printOn:outputStream.

    (key isMemberOf:Character) ifTrue:[
        s := ' character key:' , key storeString
             , ' (' , key asciiValue printString , ')'.
    ] ifFalse:[
        s := ' symbolic key:' , key storeString.
        binding := device keyboardMap bindingForLogical:key.
        binding isNil ifTrue:[
            binding := device keyboardMap aliasesForLogical: key.
        ].
        binding notNil ifTrue:[
            s := s , ' untranslated key:' , binding storeString
        ].
    ].
    rawKey := (WindowGroup lastEventQuerySignal query) rawKey.
    s := s , ' rawKey:' , rawKey storeString.

    s printOn:outputStream.

    key isCharacter ifTrue:[
        outputStream nextPutAll:' '''.
        key asString printOn:outputStream.
        outputStream nextPutAll:''''.
    ].
    outputStream cr.

    "Modified: / 04-10-2006 / 13:12:07 / cg"
    "Modified: / 12-10-2017 / 00:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyRelease:key x:x y:y
    |binding|

    self showEventTime.

    'KeyRelease x:' printOn:outputStream.
    x printOn:outputStream.
    ' y:' printOn:outputStream.
    y printOn:outputStream.

    (key isMemberOf:Character) ifTrue:[
        key codePoint <= 16rFF ifTrue:[
            ' character key:' printOn:outputStream.
            key storeString printOn:outputStream.
        ] ifFalse:[
            ' unicode character utf8:' printOn:outputStream.
            key asString utf8Encoded asByteArray hexPrintOn:outputStream.
        ].
        ' (' printOn:outputStream. key asciiValue printOn:outputStream. ')' printOn:outputStream
    ] ifFalse:[
        ' symbolic key:' printOn: outputStream. key storeString printOn:outputStream.
        binding := device keyboardMap bindingForLogical:key.
        binding isNil ifTrue:[
            binding := device keyboardMap aliasesForLogical: key.
        ].
        binding notNil ifTrue:[
            ' untranslated key:' printOn:outputStream. binding storeString printOn:outputStream
        ]. 
    ].

    outputStream cr

    "Modified: / 04-10-2006 / 13:09:27 / cg"
    "Modified: / 12-10-2017 / 00:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mapped
    self showEventTime.

    outputStream nextPutLine:'mapped '.

    super mapped.

    "Modified: / 04-10-2006 / 13:09:31 / cg"
!

pointerEnter:state x:x y:y
    self showEventTime.

    outputStream nextPutAll:'pointerEnter x:'.
    x printOn:outputStream.
    outputStream nextPutAll:' y:'.
    y printOn:outputStream.
    outputStream nextPutAll:' state:'.
    state printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:09:34 / cg"
!

pointerLeave:state
    self showEventTime.

    outputStream nextPutAll:'pointerLeave state:'.
    state storeString printOn:outputStream.
    outputStream cr.

    "Modified: / 04-10-2006 / 13:09:36 / cg"
!

sizeChanged:how
    outputStream nextPutAll:'sizeChanged how:'.
    how printOn:outputStream.
    outputStream cr.

    super sizeChanged:how.
    self invalidate

    "Modified: / 04-10-2006 / 13:17:46 / cg"
!

unmapped
    self showEventTime.

    outputStream nextPutLine:'unmapped '.

    super unmapped.

    "Modified: / 04-10-2006 / 13:09:41 / cg"
!

visibilityChange:how
    self showEventTime.

    outputStream nextPutAll:'visibilityChange:'.
    how storeString printOn:outputStream.
    outputStream cr.

    super visibilityChange:how

    "Modified: / 04-10-2006 / 13:09:43 / cg"
! !

!EventMonitor::EventMonitorView methodsFor:'initialization'!

initialize
    super initialize.

    labelHolder := '' asValue.
    self outputStream:Stdout.
! !

!EventMonitor::EventMonitorView methodsFor:'realization'!

initEvents
    self enableMotionEvents.
    self enableKeyReleaseEvents.
    self enableEnterLeaveEvents.
    self enableFocusEvents.
    self enableEvent:#visibilityChange.
"/    self enableEvent:#structureNotify.
"/    self enableEvent:#substructureNotify.

    "Modified: 7.3.1996 / 15:06:42 / cg"
! !

!EventMonitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

