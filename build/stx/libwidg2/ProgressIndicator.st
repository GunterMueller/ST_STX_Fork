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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#ProgressIndicator
	instanceVariableNames:'percentage showPercentage fgColor bgColor connectedTop
		connectedLabel collector finishAction closeTopWhenDone showBusy
		busyPosition busyDelta busyIndicationProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!ProgressIndicator class methodsFor:'documentation'!

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
    a view showing a rectangle filled according the percentage value.
    Can be used as a progress indicator a la MSwindows;
    it can also be configured as a non-percentage busy indication
    via the showBusyIndication flag (a la netscape).

    Can be used as a widget within an application, or
    via the convenient #inBox: instance creation messages,
    which shows a progressDisplay in a modalBox, while some
    action is performed.
    See examples.

    [author:]
	Claus Gittinger

    [see also:]
	ActionWaitBox AnimatedLabel
"
!

examples
"
    basic (internal) interface
    (if progress indicator is to be used in a complex box ...):

    Before you get frustrated - see the convenient-interface examples
    at the end ;-)

                                                                        [exBegin]
      |top p h|

      top := ModalBox new.
      top extent:300@100.
      top label:'Progress'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      h := p preferredExtent y.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.

      [
          1 to:100 do:[:val |
              (Delay forSeconds:0.05) wait.
              p percentage:val 
          ].
          top hide.
      ] fork.
      top open.
                                                                        [exEnd]

    as a busy indicator
                                                                        [exBegin]
      |top p h|

      top := ModalBox new.
      top extent:300@100.
      top label:'Busy'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      h := p preferredExtent y.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.

      p showBusyIndication:true.
      [
          'do something here ....'.
          (Delay forSeconds:5) wait.
          top hide.
      ] fork.
      top open.
                                                                        [exEnd]

    changing colors, turning percentage display off:
                                                                        [exBegin]
      |top p h|

      top := StandardSystemView new.
      top extent:300@100.
      top label:'Progress'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      p showPercentage:false.
      p foregroundColor:(Color red).
      h := 10.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.
      top open.
      [
          1 to:100 do:[:val |
              (Delay forSeconds:0.05) wait.
              p percentage:val 
          ]
      ] fork
                                                                        [exEnd]

    as a busy indicator and percentage display (as in netscape)
                                                                        [exBegin]
      |top p h|

      top := ModalBox new.
      top extent:300@60.
      top label:'Busy'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      p showPercentage:false.
      p backgroundColor:(Color cyan).
      h := p preferredExtent y.
      p topInset:(h // 3) negated; 
        bottomInset:(h // 3) negated;
        leftInset:5;
        rightInset:5.

      p showBusyIndication:true.
      [
          top label:'Busy'.
          1 to:100 do:[:i |
            (Delay forSeconds:0.05) wait.
          ].

          top label:'Percentage'.
          p showBusyIndication:false.
          1 to:100 do:[:i |
            (Delay forSeconds:0.05) wait.
            p percentage:i. 
          ].

          top hide.
      ] fork.
      top open.
                                                                        [exEnd]

    with border (2D look):
                                                                        [exBegin]
      |top p h|

      top := StandardSystemView new.
      top extent:300@100.
      top label:'Progress'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p borderWidth:1.
      h := p preferredExtent y.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.
      top open.
      [
          1 to:100 do:[:val |
              (Delay forSeconds:0.05) wait.
              p percentage:val 
          ]
      ] fork
                                                                        [exEnd]


    getting progress from a model:
                                                                        [exBegin]
      |model top p h|

      model := 0 asValue.

      top := StandardSystemView new.
      top extent:300@100.
      top label:'Progress'.
      p := ProgressIndicator in:top.
      p model:model.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      h := p preferredExtent y.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.
      top open.

      [
          1 to:100 do:[:val |
              (Delay forSeconds:0.05) wait.
              model value:val 
          ]
      ] fork
                                                                        [exEnd]


    concrete example:
      search all files in the source directory for a string
      using grep. Show progress while doing so.
                                                                        [exBegin]
      |top p h names done|

      top := StandardSystemView new.
      top extent:300@100.
      top label:'Searching ...'.
      p := ProgressIndicator in:top.
      p origin:(0.0@0.5) corner:(1.0@0.5).
      p level:-1.
      h := p preferredExtent y.
      p topInset:(h // 2) negated; 
        bottomInset:(h // 2) negated;
        leftInset:5;
        rightInset:5.
      top openWithPriority:(Processor activePriority + 1).

      names := 'source' asFilename directoryContents.
      done := 0.
      names do:[:aName |
        |fn stream line|

        p percentage:(done / names size * 100).
        fn := ('source/' , aName) asFilename.
        fn isDirectory ifFalse:[
            stream := fn readStream.
            [stream atEnd] whileFalse:[
                line := stream nextLine.
                (line findString:'subclass:') ~~ 0 ifTrue:[
                    Transcript showCR:line
                ].
            ].
            stream close.
        ].
        done := done + 1
      ].

      top destroy
                                                                        [exEnd]


   using the convenient inBox-interface

   (this creates a box and an activity label and evaluates a block
    to indicate ...)

    basic interface demonstration:
                                                                        [exBegin]
      |p|

      p := ProgressIndicator 
                inBoxWithLabel:'doing something  ...'
                abortable:true.
      p showProgressOf:
            [:progressValue :currentAction |

              1 to:100 do:[:val |
                  (Delay forSeconds:0.05) wait.
                  val == 25 ifTrue:[
                      currentAction value:'still going ...'
                  ].
                  val == 50 ifTrue:[
                      currentAction value:'halfway through ...'
                  ].
                  val == 75 ifTrue:[
                      currentAction value:'almost finished ...'
                  ].
                  progressValue value:val 
              ]
            ]
                                                                        [exEnd]


    above search example using this convenient interface:
                                                                        [exBegin]
      |p|

      p := ProgressIndicator 
                inBoxWithLabel:'searching files ...'
                abortable:false.
      p showProgressOf:
            [:progressValue :currentAction |
                |names nDone|

                names := 'source' asFilename directoryContents.
                nDone := 0.
                names do:[:aName |
                  |fn stream line|

                  progressValue value:(nDone / names size * 100).
                  currentAction value:'searching ' , 'source/' , aName , ' ...'.

                  fn := ('source/' , aName) asFilename.
                  fn isDirectory ifFalse:[
                      stream := fn readStream.
                      [stream atEnd] whileFalse:[
                          line := stream nextLine.
                          (line findString:'subclass:') ~~ 0 ifTrue:[
                              Transcript showCR:line
                          ].
                      ].
                      stream close.
                  ].
                  nDone := nDone + 1
                ].
            ].
                                                                        [exEnd]


    a nice example: copying files a la windows ...
    the following copies all files to /dev/null.
                                                                        [exBegin]
      |p|

      (ProgressIndicator 
                inBoxWithLabel:'copy files to /dev/null ...'
                abortable:true)
         showProgressOf:
            [:progressValue :currentAction |
                |files nFiles nDone|

                files := '.' asFilename directoryContents.
                nFiles := files size.
                nDone := 0.
                files do:[:aFileName |
                    |percent|

                    nDone := nDone + 1.
                    percent := nDone / nFiles * 100.
                    progressValue value:percent. 
                    aFileName asFilename isDirectory ifTrue:[
                        Transcript showCR:('skipping ' , aFileName , ' ...'). 
                        currentAction value:('skipping ' , aFileName , ' ...'). 
                    ] ifFalse:[
                        Transcript showCR:('copying ' , aFileName , ' ...').
                        currentAction value:('copying ' , aFileName , ' ...').
                        Object errorSignal handle:[:ex |
                            self warn:'an error occurred while copying ' , aFileName.
                            ex return
                        ] do:[
                            aFileName asFilename copyTo:'/dev/null'.
                        ]
                    ].
                ].
            ].
                                                                        [exEnd]

                                                                        [exBegin]
        ProgressIndicator 
            displayBusyIndicator:'Test...'
            at:(Screen default center)
            during:[:p |
                p labelWidget label:'bla...'.
                Delay waitForSeconds:0.5.

                1 to:3 do:[:idx |
                    Delay waitForSeconds:0.5.
                    p labelWidget label:('bla %1...' bindWith:idx).
                ].
                Delay waitForSeconds:0.5.
                p labelWidget label:'blabla...'.
                Delay waitForSeconds:0.5.
            ].
                                                                        [exEnd]
"
! !

!ProgressIndicator class methodsFor:'instance creation'!

inBox
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self inBoxWithLabel:'executing ...' abortable:false

    "Modified: 22.10.1997 / 21:08:37 / cg"
!

inBoxWithLabel:aLabel
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self inBoxWithLabel:aLabel abortable:false 
!

inBoxWithLabel:aLabel abortable:abortable
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self
	inBoxWithLabel:aLabel   
	text:''
	abortable:abortable

    "Modified: 17.7.1996 / 15:14:58 / cg"
!

inBoxWithLabel:aLabel icon:anIcon text:text abortable:abortable view:additionalView closeWhenDone:closeWhenDoneBoolean
    "create a topView containing an instance of myself,
     return the new instance, for later use with #showProgressOf:"

    |top p l y y2|

    top := Dialog new.
    top label:aLabel.
    top cursor:(Cursor wait).

    y2 := 0.
    anIcon notNil ifTrue:[
        y := top yPosition.
        l := top addTextLabel:anIcon.
        l borderWidth:0.
        l adjust:#left.
        l cursor:(Cursor wait).
        y2 := top yPosition.
        top yPosition:y.
    ].

    l := top addTextLabel:text.
    l borderWidth:0.
    l adjust:#left.
    l cursor:(Cursor wait).
    anIcon notNil ifTrue: [l leftInset:(anIcon width + 10)].

    top yPosition:(top yPosition max:y2).

    top addVerticalSpace.

    p := ProgressIndicator new.
    p extent:(1.0 @ p preferredHeight).
    p level:-1.
    p leftInset:5;
      rightInset:5.
    p cursor:(Cursor wait).
    p closeTopWhenDone:closeWhenDoneBoolean.
    p connectToTop:top label:l.

    top addComponent:p.

    additionalView notNil ifTrue:[
        top addComponent:additionalView.
        additionalView extent:(1.0 @ additionalView preferredHeight).
    ].

    abortable ifTrue:[
        top addVerticalSpace.
        top addAbortButton
    ].
    abortable ifFalse:[
        "/ top beUndecorated.  -- buggy for now; sets wrong height (caption not included ?)
        "/ would need the following kludge:
        "/ top preferredExtent:(top preferredExtent + (0@30)).
    ].

    ^ p

    "Created: 17.7.1996 / 15:14:33 / cg"
    "Modified: 17.7.1996 / 15:16:58 / cg"
!

inBoxWithLabel:aLabel text:text abortable:abortable
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self
	inBoxWithLabel:aLabel 
	text:text 
	abortable:abortable 
	view:nil

!

inBoxWithLabel:aLabel text:text abortable:abortable view:additionalView
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self
	inBoxWithLabel:aLabel 
	text:text 
	abortable:abortable 
	view:additionalView 
	closeWhenDone:true

!

inBoxWithLabel:aLabel text:text abortable:abortable view:additionalView closeWhenDone:closeWhenDoneBoolean
    "create a topView containing an instance of myself,
     for later use with #showProgressOf:"

    ^ self
	inBoxWithLabel:aLabel 
	icon:nil
	text:text 
	abortable:abortable 
	view:additionalView 
	closeWhenDone:closeWhenDoneBoolean

!

progressOpenOn:progressModel label:aLabel
    "create and open a progressIndicator dialog window,
     bit do not open it modal; instead, it is opened modeless
     and control returns to the caller.
     The models value is assumed to be 0..1 
     (which is for compatibility and different from ST/X's percentage use)
     Added for VW compatibility (RB)."

    ^ self progressOpenOn:progressModel title:aLabel label:aLabel
!

progressOpenOn:progressModel title:title label:aLabel
    "create and open a progressIndicator dialog window,
     bit do not open it modal; instead, it is opened modeless
     and control returns to the caller.
     The models value is assumed to be 0..1 
     (which is for compatibility and different from ST/X's percentage use)
     Added for VW compatibility (RB)."

    |p ra|

    p := self
            inBoxWithLabel:title 
            icon:nil
            text:aLabel
            abortable:false
            view:nil
            closeWhenDone:false.

    ra := RangeAdaptor on:progressModel start:0 stop:0.01 grid:nil.
    p model:ra.

    p topView openModeless; waitUntilVisible.
    ^ p.

    "Modified: / 4.2.2000 / 01:25:55 / cg"
! !

!ProgressIndicator class methodsFor:'simple public API'!

displayBusyIndicator:aLabel abortable:abortable at:aPoint during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed the progressIndicator as argument
     so the block can change the label and/or change the progress value."

    ^ self
        displayBusyIndicator:aLabel 
        message:aLabel
        abortable:abortable 
        at:aPoint 
        during:aBlock

    "
     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        abortable:true
        at:(Screen default center)
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
            ]
        ].

     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        abortable:true
        at:(Screen default center)
        during:[
            Delay waitForSeconds:3.
        ].
    "

    "Modified: / 12-11-2010 / 18:59:45 / cg"
!

displayBusyIndicator:aLabel at:aPoint during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed a valueHolder, which is to be set to values from
     startValue to endValue during the blocks evaluation.
     This is scaled to 0..100% completion.
     Set the valueHolder to nil, to get a busy-indicator"

    self
        displayBusyIndicator:aLabel 
        abortable:false 
        at:aPoint 
        during:aBlock

    "
     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        at:(Screen default center)
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
            ]
        ].
    "
!

displayBusyIndicator:aLabel message:messageString abortable:abortable at:aPoint during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed the progressIndicator as argument
     so the block can change the label and/or change the progress value."

    |p|

    p := self
            inBoxWithLabel:aLabel 
            icon:nil
            text:messageString
            abortable:abortable
            view:nil
            closeWhenDone:true.

    aPoint notNil ifTrue:[
        p topView origin:aPoint
    ].

    p showBusyIndication:true.
    p showBusyIndicatorDuring:[
        CannotReturnError catch:[
            aBlock valueWithOptionalArgument:p.    
        ]
    ]

    "
     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        abortable:true
        at:(Screen default center)
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
            ]
        ].

     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        abortable:true
        at:(Screen default center)
        during:[
            Delay waitForSeconds:3.
        ].
    "

    "Created: / 12-11-2010 / 18:59:13 / cg"
!

displayBusyIndicator:aLabel message:messageString at:aPoint during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed a valueHolder, which is to be set to values from
     startValue to endValue during the blocks evaluation.
     This is scaled to 0..100% completion.
     Set the valueHolder to nil, to get a busy-indicator"

    self
        displayBusyIndicator:aLabel
        message:messageString
        abortable:false 
        at:aPoint 
        during:aBlock

    "
     ProgressIndicator
        displayBusyIndicator:'doobidoobidoo...'
        at:(Screen default center)
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
            ]
        ].
    "

    "Created: / 12-11-2010 / 19:01:12 / cg"
!

displayProgress:aLabel at:aPoint from:startValue to:endValue during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed a valueHolder, which is to be set to values from
     startValue to endValue during the blocks evaluation.
     This is scaled to 0..100% completion.
     Set the valueHolder to nil, to get a busy-indicator"

    ^ self
        displayProgress:aLabel 
        message:aLabel
        at:aPoint 
        from:startValue 
        to:endValue 
        during:aBlock

    "
     ProgressIndicator
        displayProgress:'doobidoobidoo...'
        at:(Screen default center)
        from:200 to:400
        during:[:val |
            200 to:400 by:5 do:[:i |
                val value:i.
                Delay waitForSeconds:0.1.
            ]
        ].
    "

    "Modified: / 12-11-2010 / 19:02:27 / cg"
!

displayProgress:aLabel message:messageString at:aPoint from:startValue to:endValue during:aBlock
    "easy interface - show progress while evaluating aBlock.
     The block is passed a valueHolder, which is to be set to values from
     startValue to endValue during the blocks evaluation.
     This is scaled to 0..100% completion.
     Set the valueHolder to nil, to get a busy-indicator"

    |p|

    p := self
            inBoxWithLabel:aLabel 
            icon:nil
            text:messageString
            abortable:false
            view:nil
            closeWhenDone:true.

    p showProgressOf:[:progressValue :currentAction |
        |scaler|

        scaler := [:scaledValue | 
                        |newPercentage oldPercentage oldLabel|

                        scaledValue isNil ifTrue:[
                            p showBusyIndication:true
                        ] ifFalse:[
                            p showBusyIndication:false.
                            oldPercentage := progressValue value.
                            endValue = startValue ifTrue:[
                                newPercentage := 0.
                            ] ifFalse:[
                                newPercentage := (scaledValue - startValue) / (endValue-startValue) * 100.
                            ].
                            newPercentage ~= oldPercentage ifTrue:[
                                progressValue value:newPercentage.
                            ].
                            oldLabel := currentAction value.
                            oldLabel ~= aLabel ifTrue:[
                                currentAction value:aLabel.
                            ]
                        ]
                  ].
        CannotReturnError catch:[
            aBlock valueWithOptionalArgument:scaler and:p.    
        ]
    ]

    "
     ProgressIndicator
        displayProgress:'doobidoobidoo...'
        at:(Screen default center)
        from:200 to:400
        during:[:val |
            200 to:400 by:5 do:[:i |
                val value:i.
                Delay waitForSeconds:0.1.
            ]
        ].
    "

    "Created: / 12-11-2010 / 19:01:38 / cg"
!

displayProgressNotifications:aLabel abortable:abortable at:aPointOrNil during:aBlock
    "easy interface - show progress as provided by progressNotifications
     while evaluating aBlock.
     The block is passed the progressIndicator as optional argument,
     however, progressNotifications are handled and update the percentage."

    ^ self
        displayProgressNotifications:aLabel 
        message:aLabel 
        abortable:abortable 
        at:aPointOrNil 
        during:aBlock


    "
     ProgressIndicator
        displayProgressNotifications:'doobidoobidoo...'
        abortable:true
        at:nil
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
                ProgressNotification progressPercentage:(i / 4).
            ]
        ].
    "
    "
     ProgressIndicator
        displayProgressNotifications:'doobidoobidoo...'
        abortable:true
        at:nil
        during:[
            Delay waitForSeconds:3.
        ].
    "

    "Modified: / 12-11-2010 / 19:03:09 / cg"
!

displayProgressNotifications:aLabel message:messageString abortable:abortable at:aPointOrNil during:aBlock
    "easy interface - show progress as provided by progressNotifications
     while evaluating aBlock.
     The block is passed the progressIndicator as optional argument,
     however, progressNotifications are handled and update the percentage."

    |p|

    p := self
            inBoxWithLabel:aLabel 
            icon:nil
            text:messageString
            abortable:abortable
            view:nil
            closeWhenDone:true.

    p showBusyIndicatorDuring:[
        CannotReturnError catch:[
            ProgressNotification handle:[:ex |
                p percentage:ex progressValue.
                ex proceed.
            ] do:[
                aBlock valueWithOptionalArgument:p.    
            ].
        ]
    ]

    "
     ProgressIndicator
        displayProgressNotifications:'doobidoobidoo...'
        abortable:true
        at:nil
        during:[
            200 to:400 by:5 do:[:i |
                Delay waitForSeconds:0.1.
                ProgressNotification progressPercentage:(i / 4).
            ]
        ].
    "
    "
     ProgressIndicator
        displayProgressNotifications:'doobidoobidoo...'
        abortable:true
        at:nil
        during:[
            Delay waitForSeconds:3.
        ].
    "

    "Created: / 12-11-2010 / 19:02:43 / cg"
! !

!ProgressIndicator methodsFor:'accessing'!

labelWidget
    ^ connectedLabel

    "Created: / 07-11-2011 / 22:01:00 / cg"
!

model:aValueHolder
    "set my percentage holder"

    super model:aValueHolder.
    aValueHolder notNil ifTrue:[
        self percentage:(model perform:aspectMsg)
    ].
!

percentage:aNumber
    "set the percentage"

    |newPercentage|

    newPercentage := -1.
    (aNumber notNil and:[aNumber >= 0]) ifTrue:[
        newPercentage := ((aNumber max:0) min:100) rounded.
    ].
    newPercentage ~= percentage ifTrue:[
        percentage := newPercentage.
        self invalidateRepairNow:true.
    ]

    "Modified: / 6.6.1998 / 19:43:56 / cg"
!

showBusyIndication:aBooleanHolder
    "switch between percentage mode (if false) and busy indication (if true)"

    aBooleanHolder ~~ showBusy ifTrue:[
        showBusy notNil ifTrue:[        
            showBusy removeDependent:self.
        ].
        showBusy := aBooleanHolder.
        showBusy isValueModel ifTrue:[showBusy addDependent:self].
        (showBusy value) ifTrue:[
            self startBusyIndicationProcess.
        ] ifFalse:[
            self stopBusyIndicationProcess
        ].
        shown ifTrue:[self redraw]
    ].

    "Created: / 21-10-1998 / 17:35:16 / cg"
    "Modified: / 17-11-2010 / 13:43:51 / cg"
! !

!ProgressIndicator methodsFor:'accessing-behavior'!

closeTopWhenDone:aBoolean
    "set/clear the close-topView-when-done flag"

    closeTopWhenDone := aBoolean

    "Created: 3.9.1996 / 14:22:03 / cg"
    "Modified: 29.3.1997 / 16:08:19 / cg"
!

finishAction:aBlock 
    "define an action to be performed when finished"

    finishAction := aBlock

    "Created: 3.9.1996 / 14:15:15 / cg"
    "Modified: 29.3.1997 / 16:08:35 / cg"
! !

!ProgressIndicator methodsFor:'accessing-look'!

backgroundColor 
    "return the percentage displays background color"

    ^ bgColor

!

backgroundColor:aColor 
    "set the percentage display's background color"

    aColor ~= bgColor ifTrue:[
        bgColor := aColor.
        self invalidateRepairNow:true
    ].

    "Modified: / 20-07-1998 / 23:32:48 / cg"
    "Modified (comment): / 19-11-2016 / 12:22:23 / cg"
!

foregroundColor 
    "return the percentage displays foreground color"

    ^ fgColor

    "Created: 29.3.1997 / 16:12:28 / cg"
!

foregroundColor:aColor 
    "set the percentage display's foreground color"

    aColor ~= fgColor ifTrue:[
        fgColor := aColor.
        self invalidateRepairNow:true
    ].

    "Modified: / 20-07-1998 / 23:27:47 / cg"
    "Modified (comment): / 19-11-2016 / 12:22:29 / cg"
!

showPercentage
    "return the flag controlling if the percentage is to be shown numerically"

    ^ showPercentage

    "Created: 29.3.1997 / 16:12:39 / cg"
!

showPercentage:aBoolean
    "set/clear the flag controlling if the percentage is to be shown numerically"

    showPercentage := aBoolean.
    self invalidateRepairNow:true

    "Modified: / 6.6.1998 / 19:28:44 / cg"
! !

!ProgressIndicator methodsFor:'change & update'!

update:aspect with:aParameter from:changedObject
    "react upon value changes of my model"

    (aspect == aspectMsg
    and:[changedObject == model]) ifTrue:[
        self percentage:(model perform:aspectMsg).
        ^ self
    ].
    changedObject == showBusy ifTrue:[
        showBusy value 
            ifTrue:[self startBusyIndicationProcess]
            ifFalse:[self stopBusyIndicationProcess].
        self redraw.
        ^ self
    ].
    ^ super update:aspect with:aParameter from:changedObject

    "Modified: / 21-10-1998 / 18:01:52 / cg"
    "Modified: / 01-11-2006 / 08:40:50 / janfrog"
! !

!ProgressIndicator methodsFor:'drawing'!

redraw
    "redraw the percentage bar and optional percentage string"

    |s lx rx sx sy sw m2 m w h doBusy oldClip deviceFont reallyShowPercentage|

    self shown ifFalse:[^self].

    m := margin + 1.
    m2 := m*2.

    w := width - m2.
    h := height - m2.

"/    self clear.

    doBusy := showBusy value.
    doBusy ifFalse:[
        percentage value < 0 ifTrue:[
            self startBusyIndicationProcess.
            doBusy := true.
        ].        
    ].

    doBusy ifTrue:[
        gc paint:bgColor.
        gc fillRectangleX:m y:m width:w height:h.

        lx := (w * busyPosition / 100) rounded.
        rx := (w * (busyPosition + 20) / 100) rounded.
        rx := rx min:w.
        lx := lx max:m.
        gc paint:fgColor.
        gc fillRectangleX:lx y:m width:(rx - lx) height:h.
        ^ self
    ].

    self stopBusyIndicationProcess.

    rx := (w * percentage / 100) rounded.
    gc paint:bgColor.
    gc fillRectangleX:m+rx y:m width:w-rx height:h.

    (reallyShowPercentage := showPercentage) ifTrue:[
        s := percentage printString , ' %'.

        deviceFont := gc deviceFont.
        reallyShowPercentage := self height >= (deviceFont heightOf:s).
        reallyShowPercentage ifTrue:[
            sw := deviceFont widthOf:s .
            sx := (width - sw) // 2.
            sy := height // 2 + deviceFont descent + 2.

            rx <= (sx+sw) ifTrue:[
                gc paint:self blackColor.
                gc displayString:s x:sx y:sy.
            ]
        ]
    ].

    gc paint:fgColor.
    gc fillRectangleX:m y:m width:rx height:h.

    reallyShowPercentage ifTrue:[
        rx >= sx ifTrue:[
            oldClip := self clippingBoundsOrNil.
            self clippingBounds:(m@m corner:rx+1 @ h).
            
            gc paint:(fgColor contrastingBlackOrWhite).
            gc displayString:s x:sx y:sy.
            self clippingBounds:oldClip
        ]
    ]

    "Modified: / 12-12-2006 / 18:26:02 / janfrog"
    "Modified: / 19-11-2016 / 12:27:05 / cg"
!

sizeChanged:how
    super sizeChanged:how.
    self invalidate

    "Created: / 18.4.1998 / 02:34:37 / cg"
    "Modified: / 18.4.1998 / 14:09:40 / cg"
! !

!ProgressIndicator methodsFor:'initialization & release'!

destroy
    busyIndicationProcess notNil ifTrue:[
	self stopBusyIndicationProcess
    ].
    super destroy.

    "Created: / 21.10.1998 / 17:29:58 / cg"
    "Modified: / 21.10.1998 / 17:30:36 / cg"
!

initStyle
    "initialize styleSheet values"

    <resource: #style (#'progressIndicator.viewBackground'
                       #'progressIndicator.foregroundColor')>

    super initStyle.

    self is3D ifTrue:[
        self level:-1
    ].

    bgColor := styleSheet colorAt:'progressIndicator.viewBackground' default:self whiteColor.
    fgColor := styleSheet colorAt:'progressIndicator.foregroundColor' default:Color blue.
    fgColor := fgColor onDevice:device.

    showPercentage := true.
!

initialize

    super initialize.

    percentage := 0.
    showBusy := false.

    "Modified: / 21.10.1998 / 17:33:02 / cg"
!

mapped
    super mapped.
    (showBusy value) ifTrue:[
	self startBusyIndicationProcess.
    ].
!

release
    super release.
    showBusy notNil ifTrue:[showBusy removeDependent:self].

    "Created: / 17-11-2010 / 13:44:45 / cg"
!

unmapped
    super unmapped.
    (showBusy value) ifTrue:[
	self stopBusyIndicationProcess.
    ].
! !

!ProgressIndicator methodsFor:'private'!

connectToTop:top label:label
    connectedTop := top.
    connectedLabel := label
!

startBusyIndicationProcess
    busyIndicationProcess isNil ifTrue:[
        busyPosition := 0.
        busyDelta := 3.
        busyIndicationProcess := [
                                    [self realized and:[self topView realized]] whileTrue:[
                                        Delay waitForSeconds:0.1.
                                        self shown ifTrue:[
                                            self updateBusyIndicatorPosition.
                                        ]
                                    ].
                                    busyIndicationProcess := nil.
                                 ] fork.
    ].

    "Created: / 21.10.1998 / 18:02:35 / cg"
    "Modified: / 21.10.1998 / 18:03:49 / cg"
!

stopBusyIndicationProcess
    busyIndicationProcess notNil ifTrue:[
	busyIndicationProcess terminate.
	busyIndicationProcess := nil
    ].

    "Created: / 21.10.1998 / 17:30:19 / cg"
!

updateBusyIndicatorPosition
    busyPosition := busyPosition + busyDelta.
    busyPosition >= 95 ifTrue:[
        busyPosition := -15.
    ].
"/    busyPosition >= 80 ifTrue:[
"/        busyDelta > 0 ifTrue:[
"/            busyDelta := busyDelta negated.
"/        ]
"/    ] ifFalse:[
"/        busyPosition <= 0 ifTrue:[
"/            busyDelta < 0 ifTrue:[
"/                busyDelta := busyDelta negated.
"/            ]
"/        ]
"/    ].
    self invalidateRepairNow:true

    "Created: / 21.10.1998 / 17:33:28 / cg"
    "Modified: / 21.10.1998 / 17:58:58 / cg"
! !

!ProgressIndicator methodsFor:'queries'!

preferredExtent
    "return my preferred extent"

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    ^ 100 @ (gc font height + gc font descent + ((margin + 1) * 2))

    "Modified: 22.10.1997 / 21:07:17 / cg"
! !

!ProgressIndicator methodsFor:'showing progress'!

new_showBusyIndicatorDuring:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     Caveat: cannot (currently) suppress close of the box ..."

    |labelValue p|

    connectedLabel notNil ifTrue:[
        labelValue := (connectedLabel label ? '') asValue.
        connectedLabel 
            model:labelValue;
            aspect:#value;
            labelMessage:#value.
    ] ifFalse:[
        labelValue := '' asValue.
    ].

    "/ the display process
    p := [
            self topView show.
         ] fork.

    "/ the worker process

    [
        aBlock valueWithOptionalArgument:labelValue
    ] ensure:[
        p terminate.
        p := nil.
        self stopBusyIndicationProcess.
        closeTopWhenDone ifTrue:[
            connectedTop sensor pushEvent:(WindowEvent terminateView:connectedTop).
            connectedTop hide
        ].
        self topView hide.
        finishAction value
    ].

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Created: / 14-09-2011 / 18:41:44 / cg"
!

new_showProgressOf:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     The block is passed two arguments, the progressValue,
     which should be set to the percentage from time-to-time
     within the block and an action value, which should be set to
     the currently performed action (a string) from time to time.
     The second valueHolder can be left unchanged.

     Caveat: cannot (currently) suppress close of the box ..."

    |progressValue labelValue p aborted|

    progressValue := 0 asValue.
    aborted := false.

    connectedLabel notNil ifTrue:[
        labelValue := (connectedLabel label ? '') asValue.
        connectedLabel 
            model:labelValue;
            aspect:#value;
            labelMessage:#value.
    ] ifFalse:[
        labelValue := '' asValue.
    ].

    self model:progressValue.

    "/ the display process
    p := [
            self topView show.
         ] fork.

"/    WindowGroup windowGroupQuerySignal handle:[:ex |
"/        ex proceedWith:self topView windowGroup
"/    ] do:[
        [
            aBlock value:progressValue value:labelValue
        ] ensure:[
            p terminate.
            p := nil.
            closeTopWhenDone ifTrue:[
                connectedTop sensor pushEvent:(WindowEvent terminateView:connectedTop).
                connectedTop hide
            ].
            self topView hide.
            finishAction value
        ].
"/    ].

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Created: / 14-09-2011 / 11:02:21 / cg"
!

old_showBusyIndicatorDuring:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     Caveat: cannot (currently) suppress close of the box ..."

    |labelValue p|

    connectedLabel notNil ifTrue:[
        labelValue := (connectedLabel label ? '') asValue.
        connectedLabel 
            model:labelValue;
            aspect:#value;
            labelMessage:#value.
    ] ifFalse:[
        labelValue := '' asValue.
    ].


    "/ the worker process

    p := [
        [
            WindowGroup windowGroupQuerySignal handle:[:ex |
                ex proceedWith:self topView windowGroup
            ] do:[
                aBlock valueWithOptionalArgument:labelValue
            ]
        ] ensure:[
            p := nil.
            self stopBusyIndicationProcess.
            closeTopWhenDone ifTrue:[
                connectedTop hide
            ].
            finishAction value.
            
        ]
    ] newProcess.

    Processor activeProcess 
        withHigherPriorityDo:
            [
                p resume.
                self topView show.
            ].
    p notNil ifTrue:[p terminate].

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Created: / 14-09-2011 / 18:41:34 / cg"
!

old_showProgressOf:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     The block is passed two arguments, the progressValue,
     which should be set to the percentage from time-to-time
     within the block and an action value, which should be set to
     the currently performed action (a string) from time to time.
     The second valueHolder can be left unchanged.

     Caveat: cannot (currently) suppress close of the box ..."

    |progressValue labelValue p aborted|

    progressValue := 0 asValue.
    aborted := false.

    connectedLabel notNil ifTrue:[
        labelValue := (connectedLabel label ? '') asValue.
        connectedLabel 
            model:labelValue;
            aspect:#value;
            labelMessage:#value.
    ] ifFalse:[
        labelValue := '' asValue.
    ].

    self model:progressValue.

    "/ the worker process

    p := [
        [
            WindowGroup windowGroupQuerySignal handle:[:ex |
                ex proceedWith:self topView windowGroup
            ] do:[
                AbortOperationRequest handle:[:ex |
                    aborted := true
                ] do:[
                    aBlock value:progressValue value:labelValue
                ]
            ]
        ] ensure:[
            p := nil.
            closeTopWhenDone ifTrue:[
                connectedTop sensor pushEvent:(WindowEvent terminateView:connectedTop).
                connectedTop hide
            ].
            finishAction value
        ]
    ] newProcess.

    Processor activeProcess 
        withHigherPriorityDo:[
            p resume.
            self topView show.
        ].
    p notNil ifTrue:[p terminate].
    aborted ifTrue:[
        AbortOperationRequest raiseRequest
    ].

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Modified: / 12-09-2011 / 09:57:03 / cg"
    "Created: / 14-09-2011 / 11:00:12 / cg"
!

showBusyIndicatorDuring:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     Caveat: cannot (currently) suppress close of the box ..."

    |labelValue p|

    connectedLabel notNil ifTrue:[
        labelValue := (connectedLabel label ? '') asValue.
        connectedLabel 
            model:labelValue;
            aspect:#value;
            labelMessage:#value.
    ] ifFalse:[
        labelValue := '' asValue.
    ].


    "/ the worker process

    p := 
        [
            [
                WindowGroup windowGroupQuerySignal handle:[:ex |
                    ex proceedWith:self topView windowGroup
                ] do:[
                    aBlock valueWithOptionalArgument:labelValue
                ]
            ] ensure:[
                p := nil.
                self stopBusyIndicationProcess.
                closeTopWhenDone ifTrue:[
                    connectedTop hide
                ].
                finishAction value.
            ]
        ] newProcess.

    Processor activeProcess 
        withHigherPriorityDo:
            [
                p resume.
                self topView show.
            ].
    p notNil ifTrue:[p terminate].

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Modified: / 07-11-2011 / 21:53:46 / cg"
    "Modified (format): / 08-01-2012 / 12:00:39 / cg"
!

showProgressOf:aBlock
    "show progress, while evaluating aBlock.
     If the receiver has been created with inBox, show the
     box centered on the screen. If not, the view is assumed to
     be contained in another view, and no special startup actions
     are performed.

     The block is passed two arguments, the progressValue,
     which should be set to the percentage from time-to-time
     within the block and an action value, which should be set to
     the currently performed action (a string) from time to time.
     The second valueHolder can be left unchanged.

     Caveat: cannot (currently) suppress close of the box ..."

    "/ ^ self old_showProgressOf:aBlock
    ^ self new_showProgressOf:aBlock

    "
      |p|

      p := ProgressIndicator inBox.
      p showBusyIndication:true.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:200 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

      'it can be reused ...'.  
      p showBusyIndication:false.
      p showProgressOf:
            [:progressValue :currentAction |
                1 to:100 by:5 do:[:percent |
                    (Delay forSeconds:0.05) wait.
                    progressValue value:percent 
                ].
            ].

    "

    "Modified: / 14-09-2011 / 17:03:08 / cg"
! !

!ProgressIndicator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

