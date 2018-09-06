"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ActiveHelp subclass:#FlyByHelp
	instanceVariableNames:'currentFrame currentView currentHelpView showProcess closeProcess'
	classVariableNames:'MaxNumberOfLines MaxNumberOfColumns'
	poolDictionaries:''
	category:'Interface-Help'
!

!FlyByHelp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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

examples
"
    UserPreferences current toolTipShapeStyle:nil
    UserPreferences current toolTipShapeStyle:#cartoon

     FlyByHelp isActive

     FlyByHelp stop
     FlyByHelp start
"
! !

!FlyByHelp class methodsFor:'accessing'!

currentlyShownView
    TheOneAndOnlyHelpListener isNil ifTrue:[^ nil].
    ^ TheOneAndOnlyHelpListener currentlyShownView

    "Modified: / 09-06-2010 / 16:35:48 / cg"
!

maxNumberOfColumns
    ^ MaxNumberOfColumns ? 200
!

maxNumberOfLines
    ^ MaxNumberOfLines ? 40
! !

!FlyByHelp methodsFor:'defaults'!

flyByHelpTimeoutMillis
    "abort flyby help text generation, if no text can be generated within that
     time delta. This is used to abort long-lasting parsing/scanning/analysis in
     large methods when the mouse is moved over some syntactic constructs, and
     it takes too long to parse...
     The returned time is given in ms"

    ^ 300
! !

!FlyByHelp methodsFor:'event handling'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    aView == currentHelpView ifTrue:[
        "/ the help-bubble itself
        ^ false
    ].

    "/ don't start tooltip, if this view is not active
    "/ does not work, because motion events are reported for the current focus-view,
    "/ which is always active. Must check after we have determined the view under the pointer
    "/      aView topView isActive ifFalse:[^ false].

    ^ super buttonMotion:buttonAndModifierState x:x y:y view:aView
!

buttonPress:button x:x y:y view:aView
    |prevView|

    "/ hideHelp nils the currentView
    "/ we restore it, so the tooltip is not shown again for this view
    "/ until the mouse really leaves the view
    "/ let's call this the "do-not-show-in-this-view mode"
    prevView := currentView.
    self hideHelp.
    currentView := prevView.

    ^ false

    "Modified: / 23-12-2011 / 20:37:28 / cg"
!

keyPress:key x:x y:y view:aView
    <resource: #keyboard (#Escape)>

    |prevView|

    currentHelpView notNil ifTrue:[
        key == $ ifTrue:[
            "/ generate a line suitable for the resources file (a null translation)
            "/ into the clipboard; makes it easy to add missing translations to a .rs file,
            "/ by pressing paragrapj whenever you see an untranslated helptext
            aView setClipboardText:(lastHelpText storeString , '    ' , lastHelpText storeString).
            self hideHelp.
            ^ true
        ].
        key == #Escape ifTrue:[
            prevView := currentView.
            self hideHelp.
            currentView := prevView.
            ^ true
        ].
        (#('Shift' #'Shift_L' #'Shift_R') includes:key) ifTrue:[
            "/ do not close on those...
            ^ false
        ].
    ].

    "/ hideHelp nils the currentView
    "/ we restore it, so the tooltip is not shown again for this view
    "/ until the mouse really leaves the view
    "/ let's call this the "do-not-show-in-this-view mode"
    prevView := currentView.
    self hideHelpIgnoringErrors.
    currentView := prevView.

    ^ false
    "/ ^ super keyPress:key x:x y:y view:aView

    "Modified (format): / 25-12-2011 / 10:25:23 / cg"
!

mouseWheelMotion:state x:x y:y amount:amount deltaTime:dTime view:aView
    currentHelpView notNil ifTrue:[
        self handleMouseIn:aView x:x y:y.
    ].
    ^ false
!

pointerLeave:state view:aView
    aView == currentHelpView ifTrue:[^ true].

    "/ clear the do-not-show-in-this-view mode (see keyPress)
"/     (currentHelpView isNil and:[currentView notNil]) ifTrue:[currentView := nil].

    ^ super pointerLeave:state view:aView
! !

!FlyByHelp methodsFor:'help texts'!

helpTextFromModel:aModel view:aView at:aPointOrNil 
    "helper: ask aModel for its helpText."

    |text|

    aPointOrNil notNil ifTrue:[
        (aModel respondsTo:#flyByHelpTextFor:at:) ifTrue:[
            text := aModel flyByHelpTextFor:aView at:aPointOrNil.
            text notNil ifTrue:[^ text].
        ].
    ].
    (aModel respondsTo:#flyByHelpTextFor:) ifTrue:[
        text := aModel flyByHelpTextFor:aView.
        text notNil ifTrue:[^ text].
    ].
    ^ nil
!

helpTextFromView:aView at:aPointOrNil 
    "helper: ask aView for its helpText."

    |text key app|

    aPointOrNil notNil ifTrue:[
        (aView respondsTo:#flyByHelpTextAt:) ifTrue:[
            text := aView flyByHelpTextAt:aPointOrNil.
            text notNil ifTrue:[^ text].
        ].
    ].
    (aView respondsTo:#flyByHelpText) ifTrue:[
        text := aView flyByHelpText.
        text notNil ifTrue:[^ text].
    ].
    "/ to be enabled in next release...
"/    (aView superView notNil
"/    and:[aView superView respondsTo:#flyByHelpTextFor:]) ifTrue:[
"/        text := aView superView flyByHelpTextFor:aView.
"/        text notNil ifTrue:[^ text].
"/    ].
    (aView respondsTo:#helpKey) ifTrue:[
        key := aView helpKey.
        key notNil ifTrue:[
            app := aView application.
            app isNil ifTrue:[
                "/ special case for oldStyle Dialog subclasses.
                aView topView flyByHelpSpec notNil ifTrue:[
                    text := aView topView flyByHelpSpec at:key ifAbsent:nil.
                    text notNil ifTrue:[
                        ^ aView topView resources stringWithCRs:text.
                    ].    
                ].    
                app := Error handle:[:ex | nil] do:[ aView windowGroup mainGroup application ].
            ].
            app notNil ifTrue:[
                ^ app flyByHelpTextForKey:key
            ].
            ^ aView resources string:key
        ].
    ].
    ^ nil.
! !

!FlyByHelp methodsFor:'private'!

hideIfPointerLeft:aView
    "hide help, if the pointer is not in aView"

    |whereOnScreen|

    currentFrame notNil ifTrue:[
        whereOnScreen := aView graphicsDevice pointerPosition.

        (currentFrame notNil
        and:[(currentFrame insetBy:1@1) containsPoint:whereOnScreen]) ifFalse:[
            self hideHelp.
        ].
    ].

    "Modified: 28.5.1996 / 20:18:28 / cg"
!

initiateHelpFor:aView at:aPointOrNil now:showItNow
    "ask aView for helpText, passing x/y coordinates;
     start a timeout process to display this helpText after some delay;
     Normally used internally, but can also be used by widgets to force 
     re-negotiation of the displayed helpText 
     (for example in a menu, when the selection changes)"

    |text delayTime now|

    (self interestedIn:aView) ifFalse:[
        ^ self
    ].

    now := Timestamp now.

    "/ do not allow for more than 200 ms to be spent in the
    "/ helpText gatherer (the codeView parses the code for the variable under the cursor)
    [
        Error handle:[:ex |
            ('FlyByhelp [warning]: error while asking for helpText: ',ex description) errorPrintCR.
            Transcript showCR:'-------------------------'.
            ex suspendedContext fullPrintAllOn:Transcript.
            "/ self halt.
        ] do:[
            text := self helpTextFor:aView at:aPointOrNil.
        ].
    ] valueWithWatchDog:[ 
        'FlyByhelp [info]: flyBy text generation took too long' infoPrintCR.
        ^ self 
    ] afterMilliseconds:(self flyByHelpTimeoutMillis).

    lastHelpText = text ifTrue:[
        lastHelpWidget == aView ifTrue:[ 
            self toolTipFollowsMouse ifFalse:[
                ^ self
            ]
        ]
    ].

    ((text size > 0) or:[text isString not]) ifTrue:[
        (showItNow not and:[(delayTime := self delayTime) > 0]) ifTrue:[
            self stopHelpDisplayProcess.
            showProcess := 
                [
                    Delay waitForSeconds:delayTime.
                    [
                        aView device notNil ifTrue:[    
                            aView device anyButtonPressed ifFalse:[
                                showProcess := nil.
                                self showHelp:text for:aView
                            ]
                        ].
                    ] ensure:[
                        showProcess := nil.
                    ]
                ] forkAt:(Processor userSchedulingPriority + 1).
        ] ifFalse:[
            self showHelp:text for:aView
        ]
    ] ifFalse:[
        self hideHelp
    ].

    "Modified: / 22-03-2011 / 19:10:28 / cg"
! !

!FlyByHelp methodsFor:'queries'!

currentlyShownView
    ^ currentHelpView
!

toolTipFollowsMouse
    "if true, the tooltip-window moves with the pointer
     so that it stays away from (does not cover) the mouse pointer"

    ^ false
! !

!FlyByHelp methodsFor:'show & hide help'!

activeHelpViewForApplication:applicationOrNil text:helpText onDevice:aDevice
    applicationOrNil notNil ifTrue:[
        ^ applicationOrNil activeHelpViewFor:helpText onDevice:aDevice
    ].
    ^ ActiveHelpView for:helpText onDevice:aDevice.

    "
     (ActiveHelpView for:'Hello' onDevice:Display) open
    "
!

hideHelp
    "hide the help text"

    |p|

    "/ lastHelpText := nil.
    self stopHelpDisplayProcess.
    lastHelpText := lastHelpWidget := nil.

    currentHelpView notNil ifTrue:[
        [
            currentHelpView notNil ifTrue:[
                currentHelpView unmap.
                currentHelpView destroy.
                currentHelpView := nil.
                currentView := nil.
            ]
        ] valueUninterruptably
    ].
    currentFrame := nil.
    (p := closeProcess) notNil ifTrue:[
        closeProcess := nil.
        p terminate.
    ]

    "Modified: / 28-06-1997 / 14:03:50 / cg"
    "Modified: / 04-05-2016 / 10:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showHelp:aHelpText for:view
    "show the help text for aView"

    |wg applicationOrNil org p v device helpTextShown textLines
     helpViewWidth helpViewHeight usableWidth monitorBounds usableHeight
     showTime cursorView|

    "/ thisContext fullPrintAllOn:Transcript.
    (wg := view windowGroup) notNil ifTrue:[
        wg isInModalLoop ifTrue:[
            wg isModal ifFalse:[
                ^ self
            ].
        ].
    ].

    device := view graphicsDevice.

    "/ mouse still over that view?
    cursorView := device viewFromPoint:(device pointerPosition).
    cursorView ~~ view ifTrue:[
        Debugging ifTrue:[ 'mouse no longer in view' infoPrintCR ].
        ^ self
    ].

    view == currentView ifTrue:[
        lastHelpText = aHelpText ifTrue:[
            ^ self
        ]
    ].
    lastHelpWidget := view.

    lastHelpText := aHelpText.
    helpTextShown := aHelpText.
    "/ the text originator must already have generated CRs;
    "/ no longer done here (otherwise, we could not generate tooltips with windows filenames in it)
    textLines := helpTextShown isStringCollection 
                    ifTrue:[helpTextShown]
                    ifFalse:[ 
                        helpTextShown isString 
                            ifTrue:[helpTextShown "withCRs" asCollectionOfLines asStringCollection]
                            ifFalse:[nil]].
    textLines notNil ifTrue:[
        textLines size > (self class maxNumberOfLines) ifTrue:[
            textLines := (textLines copyTo:(self class maxNumberOfLines)) copyWith:'...'
        ].
        textLines := textLines collect:[:l | l contractAtEndTo:(self class maxNumberOfColumns)].
        helpTextShown := textLines asString.
    ].
    
    (p := closeProcess) notNil ifTrue:[
        closeProcess := nil.
        p terminate.
    ].
    currentHelpView notNil ifTrue:[
        self hideHelp
    ].

    "/ Transcript showCR:helpTextShown storeString.
    helpTextShown isEmptyOrNil ifTrue:[^ self].
    
    org := view originRelativeTo:nil.
    currentFrame := org extent:view extent.
    org := org + (view extent // 2).

    wg notNil ifTrue:[ applicationOrNil := wg application ].
    v := self activeHelpViewForApplication:applicationOrNil text:helpTextShown onDevice:device.
    v perform:#controllingHelpListener: with:self ifNotUnderstood:[].

    helpViewWidth := v width.
    helpViewHeight := v height.

    org := device pointerPosition + (0@18"24").
    monitorBounds := device monitorBoundsAt:org.
    usableWidth := monitorBounds width - 2.
    usableHeight := device usableHeightAt:org.

    helpViewWidth > usableWidth ifTrue:[v width:(helpViewWidth := usableWidth)].    
    helpViewHeight > usableHeight ifTrue:[v height:(helpViewHeight := usableHeight)].    

    (org x + helpViewWidth) > (monitorBounds left + usableWidth) ifTrue:[
        org := ((monitorBounds left + usableWidth - helpViewWidth) @ org y).
    ].
    (org y + helpViewHeight) > (monitorBounds top + usableHeight) ifTrue:[
        org := org x @ (monitorBounds top + usableHeight - helpViewHeight).
    ].

    v origin:org.
    v realize.
    v enableButtonMotionEvents.
    v enableMotionEvents.
    currentHelpView := v.
    currentView := view.

    showTime := self showTime.
    (showTime notNil and:[showTime > 0]) ifTrue:[
        closeProcess := [
                [
                    (Delay forSeconds:showTime) wait.
                    [
                        |v|
                        (v := currentHelpView) notNil ifTrue:[
                            currentHelpView := nil.
                            v unmap.
                            v destroy.
                        ]
                    ] valueUninterruptably
                ] ifCurtailed:[
                    closeProcess := nil.
                ].
            ] newProcess.
        closeProcess priority:(Processor userSchedulingPriority + 1).
        closeProcess resume.
    ].

    "Modified: / 31-08-1995 / 19:20:45 / claus"
    "Modified: / 17-11-2016 / 22:11:37 / cg"
!

stopHelpDisplayProcess
    |p|

    (p := showProcess) notNil ifTrue:[
        showProcess := nil.
        p terminate.
    ].

    "Created: 28.6.1997 / 14:03:17 / cg"
! !

!FlyByHelp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

