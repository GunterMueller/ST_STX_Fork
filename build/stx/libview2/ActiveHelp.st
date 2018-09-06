"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

EventListener subclass:#ActiveHelp
	instanceVariableNames:'lastHelpText listeningForAll applicationsOrTopViewsWithHelp
		lastHelpWidget'
	classVariableNames:'Debugging'
	poolDictionaries:''
	category:'Interface-Help'
!

ActiveHelp class instanceVariableNames:'DelayTime ShowTime TheOneAndOnlyHelpListener'

"
 No other class instance variables are inherited by this class.
"
!

!ActiveHelp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    The active help (tooltip) listener.

    The one and only instance of myself intercepts incoming mouse & keyboard 
    events for the display device, being especially interested in view-enter/
    leave events. When such an event arrives, it asks the corresponding view
    or its model for a help message and displays it via an ActiveHelpView.
    Actually, the view is first asked if it would like to display it itself
    - for example, in some information-view at the bottom of its main window.

    The query for the helpText is repeated along the view's superView chain, 
    until any model or view returns a nonNil answer for the 
    #helpTextFor:<aSubView> at:<position> or #helpTextFor:<aSubView> message.

    All I need for automatic help is some model/view/applicationModel along
    the superview chain of the entered component, which responds to the
    #helpTextFor: message with a non-nil (string-) answer.
    I close down the help view after a while, if a key is pressed or the mouse
    moved to another view.

    Who should provide the helpText:
        the best place is the application object (an instance of ApplicationModel)
        or the topView, if its a derived class of StandardSystemView.
        This should know about its components and return the string
        when asked via #helpTextFor:<aSubView>.
        See examples in FileBrowser, Launcher etc.

    Be aware, that for applicationModels, there must be a link from the
    topView to this applicationModel 
    (set via: aTopView application:anApplicationModel)
    otherwise, the helpManager has no means of finding the application which
    corresponds to a view.

    Who should display the helpText:
        by default, the helpListener opens a little popup view, which displays the
        returned help message. However, a nice trick which can be used by applications
        is to create an infoLabel as a subview of the topFrame (a la windows)
        and display the text right in the #helpTextFor: method. To cheat the
        help listener, this method should then return nil, to keep it silent.


    Usage:
        If help is to be shown for all views (as enabled by the launchers help menu),
        use 'ActiveHelp start' and 'ActiveHelp stop'.

        Individual apps may enable/disable active help for themself by:
        'ActiveHelp startFor:app' or 'ActiveHelp stopFor:app', passing either
        the topView or the topViews application as argument.
        This is usually done by applications which want to show contextHelp in
        some infoView.
        Late note: thsi is no longer recommended - one such mouse watcher process is
        good enough for all views.
        
    [author:]
        Claus Gittinger

    [start with:]
        ActiveHelp start
        ActiveHelp stop

    [See also:]
        ActiveHelpView
        WindowGroup WindowEvent
        ApplicationModel StandardSystemView
"
!

examples
"
  Active Help for a single view
  or app (whatever the global settings are):
  Can be initiated by an app when its opened.
                                                                        [exBegin]
        |app top myAppClass|

        Class withoutUpdatingChangesDo:[
            myAppClass := ApplicationModel 
                            subclass:#'Demos::DemoApp'
                            instanceVariableNames:''
                            classVariableNames:''
                            poolDictionaries:''
                            category:'demos'.

            myAppClass 
                compile:'helpTextFor:aView    Transcript showCR:''hello''. ^ ''this is some helpText'''.

        ].
        app := myAppClass new.

        top := StandardSystemView new.
        top extent:300@100.
        top application:app.
        top open.

        ActiveHelp startFor:app.

        Class withoutUpdatingChangesDo:[
            myAppClass removeFromSystem
        ]
                                                                        [exEnd]


  Active Help (for all views):

    (make certain that activeHelp is turned on ...
     ... otherwise, you will see nothing)

    the following example uses a Plug as a model replacement.
    In concrete application, you would create a method to implement the helpText
    query message.
                                                                        [exBegin]
        |app top button1 button2|

        app := Plug new.
        app respondTo:#helpTextFor:
                 with:[:view | 
                               view == button1 ifTrue:[
                                 'this is button1'
                               ] ifFalse:[
                                 view == button2 ifTrue:[
                                   'some help for button2'
                                 ] ifFalse:[
                                   nil
                                 ]
                               ]
                      ].

        top := StandardSystemView new.
        top extent:300@100.
        button1 := Button label:'b1' in:top.
        button1 origin:0.0@0.0 corner:0.5@30. 
        button2 := Button label:'b2' in:top.
        button2 origin:0.5@0.0 corner:1.0@30.
        top model:app. '<-- normally this would be: top application:app'.
        top open
                                                                        [exEnd]

    (make certain that activeHelp is turned on ...
     ... otherwise, you will see nothing)

    alternatively, display of the helpMessage in a local, private view:
                                                                        [exBegin]
        |app top button1 button2 infoView|

        app := Plug new.
        app respondTo:#helpTextFor:
                 with:[:view | infoView label:'info ...'.
                               view == button1 ifTrue:[
                                 infoView label:'this is button1'
                               ].
                               view == button2 ifTrue:[
                                 infoView label:'some help for button2'
                               ].
                               nil
                      ].

        top := StandardSystemView new.
        top extent:300@100.
        button1 := Button label:'b1' in:top.
        button1 origin:0.0@0.0 corner:0.5@30. 
        button2 := Button label:'b2' in:top.
        button2 origin:0.5@0.0 corner:1.0@30.
        infoView := Label label:'info ...' in:top.
        infoView level:-1; origin:0.0@1.0 corner:1.0@1.0.
        infoView topInset:(infoView preferredExtent y negated - 3);
                 leftInset:3; 
                 rightInset:3; 
                 bottomInset:3;
                 adjust:#left.
        top model:app. '<-- normally this would be: top application:app'.
        top open
                                                                        [exEnd]
"
! !

!ActiveHelp class methodsFor:'initialization'!

initialize
    Debugging := false.
! !

!ActiveHelp class methodsFor:'accessing'!

debugging
    ^ Debugging

    "Modified: / 22-12-2011 / 10:46:30 / cg"
!

debugging:something
    Debugging := something.

    "
     self debugging:true
     self debugging:false
    "

    "Modified (comment): / 22-12-2011 / 10:43:32 / cg"
! !

!ActiveHelp class methodsFor:'queries'!

currentHelpListener
    "return the activeHelp listener if activeHelp is turned on, nil otherwise"

    ^ TheOneAndOnlyHelpListener

    "
     ActiveHelp currentHelpListener
     FlyByHelp currentHelpListener
    "

    "Created: 28.6.1997 / 13:59:44 / cg"
!

delayTime
    ^ DelayTime ? 0.4
!

isActive
    "return true, if activeHelp is turned on"

    TheOneAndOnlyHelpListener notNil ifTrue:[
        ((WindowSensor eventListeners ? #()) includesIdentical:TheOneAndOnlyHelpListener) ifTrue:[
            ^ true
        ].
        TheOneAndOnlyHelpListener := nil.
    ].
    ^ false.

    "
     FlyByHelp isActive
    "

    "Modified: 27.4.1996 / 15:07:57 / cg"
!

showTime
    "set the number of seconds, a help messages is to be shown.
     The default is 45 seconds.
     0 means: show forever (i.e. until mouse is moved)"

    ^ ShowTime ? 45

    "Modified: / 10-11-2010 / 12:29:44 / cg"
! !

!ActiveHelp class methodsFor:'snapshots'!

preSnapshot
    "Sent by ObjectMemory to all classes, before a snapshot is written."

    TheOneAndOnlyHelpListener notNil ifTrue:[ 
        TheOneAndOnlyHelpListener hideHelp
    ].

    "Created: / 04-05-2016 / 10:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ActiveHelp class methodsFor:'start & stop'!

start
    "start activeHelp for all apps"

    TheOneAndOnlyHelpListener notNil ifTrue:[
        TheOneAndOnlyHelpListener stop.    
        TheOneAndOnlyHelpListener := nil.    
    ].

    TheOneAndOnlyHelpListener isNil ifTrue:[
        TheOneAndOnlyHelpListener := self new.
    ].
    TheOneAndOnlyHelpListener start.
    ^ TheOneAndOnlyHelpListener

    "
     ActiveHelp start
     FlyByHelp start
    "

    "Modified: / 26.10.1997 / 23:16:54 / cg"
!

startFor:anApplicationOrTopView
    "start activeHelp for a single app"

    TheOneAndOnlyHelpListener isNil ifTrue:[
        TheOneAndOnlyHelpListener := self new.
    ].
    TheOneAndOnlyHelpListener listenFor:anApplicationOrTopView

    "Modified: / 26.10.1997 / 23:17:05 / cg"
!

stop
    "stop activeHelp for all (except for individual apps)"

    TheOneAndOnlyHelpListener notNil ifTrue:[
        TheOneAndOnlyHelpListener stop.
        TheOneAndOnlyHelpListener := nil.
    ].

    "
     ActiveHelp stop
     FlyByHelp stop
    "

    "Modified: / 26.10.1997 / 23:18:58 / cg"
!

stopFor:anAppOrTopView
    "stop activeHelp for a single app"

    TheOneAndOnlyHelpListener notNil ifTrue:[
        TheOneAndOnlyHelpListener unlistenFor:anAppOrTopView.
    ].

    "Modified: / 26.10.1997 / 23:12:55 / cg"
    "Created: / 26.10.1997 / 23:18:41 / cg"
! !

!ActiveHelp class methodsFor:'times'!

delayTime:numberOfSeconds
    "set the delay (the time, the cursor has to be in the view
     before help is shown). The default is 2 seconds."

    DelayTime := numberOfSeconds

    "
     ActiveHelp delayTime:0.5
     ActiveHelp delayTime:2
     ActiveHelp delayTime:10
    "
!

showTime:numberOfSeconds
    "set the number of seconds, a help messages is to be shown.
     The default is 30 seconds.
     0 means: show forever (i.e. until mouse is moved)"

    ShowTime := numberOfSeconds

    "
     ActiveHelp showTime:10
     ActiveHelp showTime:99999 
     ActiveHelp showTime:30
    "

    "Modified: / 10-11-2010 / 12:29:40 / cg"
! !

!ActiveHelp methodsFor:'event handling'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    "handle motion events - prepare to show help"

    |realViewUnderCursor realP|

    buttonAndModifierState == 0 ifTrue:[
"/        realViewUnderCursor := aView device viewFromPoint:(aView pointerPosition).
"/        realP := aView device translatePoint:(x@y) fromView:aView toView:realViewUnderCursor.
"/        self handleMouseIn:realViewUnderCursor x:realP x y:realP y.
        Debugging ifTrue:['motion' infoPrintCR].
        self handleMouseIn:aView x:x y:y.
    ].
    ^ false
!

keyPress:key x:x y:y view:view
    "unconditionally hide the help view"

    self hideHelpIgnoringErrors.
    ^ false

    "Modified: 27.4.1996 / 15:09:57 / cg"
!

pointerEnter:state x:x y:y view:aView
    "handle pointer entering a view; prepare to show help"

    state == 0 ifTrue:[
        self handleMouseIn:aView x:x y:y.
    ].    
    ^ false
!

pointerLeave:state view:aView
    "handle pointer leaving a view; hide help text"

    |sensor|

    sensor := aView sensor.
    sensor notNil ifTrue:[
        sensor flushEventsFor:self withType:#initiateHelpFor:at:.
    ].
    self hideHelpIgnoringErrors.
    ^ false
!

processEvent:ev
    Debugging ifTrue:[
        'event: ' infoPrint. ev class nameWithoutPrefix infoPrint.
        ' view:' infoPrint. ev view infoPrintCR.
    ].
    (ev isPointerEnterLeaveEvent
    or:[ ev isButtonEvent
    or:[ ev isKeyEvent ]]) ifTrue:[
        ^ ev dispatchWithViewArgumentTo:self    
    ].
    ^ false

    "Created: / 29-06-2011 / 18:22:43 / cg"
! !

!ActiveHelp methodsFor:'help texts'!

helpTextFor:aView at:aDevicePointOrNil 
    "retrieve helptext for aView as a string; 
     walk along the view's superView chain,
     asking models and views encountered while walking.
     The first one who understands and returns a nonNil answer to the
     #helpTextFor:at: or #helpTextFor: message ends this search and the
     returned string is returned."

    |model app1 app2 text v sv topView domainPointOrNil|

    aView transformation notNil ifTrue:[
        domainPointOrNil := aView transformation applyInverseTo:aDevicePointOrNil.
    ] ifFalse:[
        domainPointOrNil := aDevicePointOrNil.
    ].

    "/ done below
    "/    text := self helpTextFromView:aView at:domainPointOrNil.
    "/    text notNil ifTrue:[ ^ text ].

    ((aView respondsTo:#application)
    and:[ (app1 := aView application) notNil ]) ifTrue:[
        text := self helpTextFromModel:app1 view:aView at:domainPointOrNil.
        text notNil ifTrue:[ ^ text ].
    ] ifFalse:[
        "/ old style (i.e. StandardSystemView ...)
        topView := aView topView.
        text := self helpTextFromModel:topView view:aView at:domainPointOrNil.
        text notNil ifTrue:[ ^ text ].
    ].

    (model := aView model) notNil ifTrue:[
        model ~~ app1 ifTrue:[
            text := self helpTextFromModel:model view:aView at:domainPointOrNil.
            text notNil ifTrue:[ ^ text ].
        ].
    ].
    text := self helpTextFromView:aView at:domainPointOrNil.
    text notNil ifTrue:[
         ^ text 
    ].

    "walk up the chain - maybe someone knows about its subview ..."
    v := aView.
    [
        (sv := v container) notNil
    ] whileTrue:[
        (model := sv model) notNil ifTrue:[
            text := self helpTextFromModel:model view:aView at:domainPointOrNil.
            text notNil ifTrue:[ ^ text ].
        ].
        "/ maybe the topView knows something about a higher-up widget...
        text := self helpTextFromModel:topView view:sv at:domainPointOrNil.
        text notNil ifTrue:[ ^ text ].
        
        text := self helpTextFromView:sv at:nil.
        text notNil ifTrue:[ ^ text ].
        v := sv
    ].

    (v notNil and:[v respondsTo:#application]) ifTrue:[
        (app2 := v application) notNil ifTrue:[
            (app2 ~~ app1) ifTrue:[
                text := self helpTextFromModel:app2 view:aView at:domainPointOrNil.
                text notNil ifTrue:[ ^ text ].
            ]
        ]
    ].
    (v notNil and:[v respondsTo:#model]) ifTrue:[
        (model := v model) notNil ifTrue:[
            text := self helpTextFromModel:model view:aView at:domainPointOrNil.
            text notNil ifTrue:[ ^ text ].
        ]
    ].
    ^ nil

    "Modified: / 31.8.1995 / 20:38:00 / claus"
    "Modified: / 28.7.1998 / 01:47:27 / cg"
!

helpTextFromModel:aModelOrTopView view:aView at:aPointOrNil 
    "helper: ask aModel for its helpText."

    |text|

    aPointOrNil notNil ifTrue:[
        (aModelOrTopView respondsTo:#helpTextFor:at:) ifTrue:[
            text := aModelOrTopView helpTextFor:aView at:aPointOrNil.
            text notNil ifTrue:[^ text].
        ].
    ].
    (aModelOrTopView respondsTo:#helpTextFor:) ifTrue:[
        text := aModelOrTopView helpTextFor:aView.
        text notNil ifTrue:[^ text].
    ].
    ^ text
!

helpTextFromView:aView at:aPointOrNil 
    "helper: ask aView for its helpText."

    |text|

    aPointOrNil notNil ifTrue:[
        (aView respondsTo:#helpTextAt:) ifTrue:[
            text := aView helpTextAt:aPointOrNil.
        ].
    ].
    text isNil ifTrue:[
        (aView respondsTo:#helpText) ifTrue:[
            text := aView helpText.
        ].
    ].
    ^ text.
! !

!ActiveHelp methodsFor:'private'!

handleMouseIn:aView x:x y:y
    "handle motion events - if the mousepointer left the 
     previous helped view, hide the help"

    Debugging ifTrue:['mouse in' infoPrintCR].
    (self interestedIn:aView) ifFalse:[
        Debugging ifTrue:['not interested 0' infoPrintCR].
        ^ self
    ].

    Error handle:[:ex |
        InfoPrinting == true ifTrue:[
            '---------------------' infoPrintCR.
            ex description infoPrintCR.
            ex suspendedContext fullPrintAll.
        ].
    ] do:[
        |sensor|

"/        self stopHelpDisplayProcess.
        Debugging ifTrue:['hideIf' infoPrintCR].
        self hideIfPointerLeft:aView.

        "/ check again, in case the stop/hide changed something...
        (self interestedIn:aView) ifFalse:[
            Debugging ifTrue:['not interested2' infoPrintCR].
            ^ self
        ].

        "/ if there is a sensor, let the view do it itself (in its process)
        (self targetViewInitiatesHelpViaSensor
        and:[ (sensor := aView sensor) notNil ])
        ifTrue:[
            sensor flushEventsFor:self withType:#initiateHelpFor:at:.
            sensor 
                pushUserEvent:#initiateHelpFor:at: for:self 
                withArguments:(Array with:aView with:(x @ y)).
        ] ifFalse:[
            self initiateHelpFor:aView at:(x @ y).
        ]
    ].
!

hideIfPointerLeft:aView
    "hide help, if the pointer is not in aView"
!

interestedIn:aView
    "return true, if I am interested in aView (either listeningForAll,
     or in my list of apps)"

    |app aViewsTopView device deviceFocusView|

    aView isNil ifTrue:[
        Debugging ifTrue:['nil view' infoPrintCR].
        ^ false
    ].

"/    applicationsOrTopViewsWithHelp isEmptyOrNil ifTrue:[
"/        Debugging ifTrue:['no apps' infoPrintCR].
"/        ^ false
"/    ].

    aViewsTopView := aView topView.

    UserPreferences current onlyShowTooltipsForActiveWindow ifTrue:[
        aViewsTopView isActive ifFalse:[
            Debugging ifTrue:[ 'topview inactive' infoPrintCR].
            ^ false
        ].

        "/ if none of the view's components has focus...
        (device := aViewsTopView graphicsDevice) notNil ifTrue:[
            (deviceFocusView := device focusView) notNil ifTrue:[
                deviceFocusView topView ~~ aViewsTopView ifTrue:[
                    "/ 'for inactive ' infoPrint. aView infoPrintCR.
                    Debugging ifTrue:['inactive topView' infoPrintCR].
                    ^ false
                ].
            ].
        ].
    ].

    listeningForAll == true ifTrue:[^ true].

    applicationsOrTopViewsWithHelp isNil ifTrue:[
        applicationsOrTopViewsWithHelp := WeakIdentitySet new.
    ].
    (applicationsOrTopViewsWithHelp includesIdentical:aViewsTopView) ifTrue:[^ true].
    app := aViewsTopView application.
    app notNil ifTrue:[
        (applicationsOrTopViewsWithHelp includesIdentical:app) ifTrue:[^ true]
    ].
    ^ false

    "Created: / 26.10.1997 / 23:28:52 / cg"
    "Modified: / 8.8.1998 / 13:36:19 / cg"
!

targetViewInitiatesHelpViaSensor
    "true if the target view is asked to show the help via the sensor;
     false, if I do it myself synchronously."

    ^ true
! !

!ActiveHelp methodsFor:'queries'!

delayTime
    ^ self class delayTime
!

showTime
    "how long shall the help be shown;
    0 means: forever (until user moves the mouse);
     >0 means that number of seconds"

    ^ self class showTime
! !

!ActiveHelp methodsFor:'show & hide help'!

hideHelp
    "hide the help text - nothing done here"
!

hideHelpIgnoringErrors
    "hide the help text"

    Error handle:[:ex |
        ex description infoPrintCR.
        ex return
    ] do:[
        self hideHelp.
    ].
!

initiateHelpFor:aView at:aPointOrNil
    "ask aView for helpText, passing x/y coordinates;
     start a timeout process to display this helpText after some delay;
     Normally used internally, but can also be used by widgets to force 
     re-negotiation of the displayed helpText 
     (for example in a menu, when the selection changes)"

    self initiateHelpFor:aView at:aPointOrNil now:false

    "Modified: 28.6.1997 / 14:45:57 / cg"
!

initiateHelpFor:aView at:aPointOrNil now:showItNow
    "ask aView for helpText, passing x/y coordinates;
     start a timeout process to display this helpText after some delay;
     Normally used internally, but can also be used by widgets to force 
     re-negotiation of the displayed helpText 
     (for example in a menu, when the selection changes)"

    |text top app|

    (self interestedIn:aView) ifFalse:[
        ^ self
    ].

    text := self helpTextFor:aView at:aPointOrNil.
    lastHelpText = text ifTrue:[
        ^ self
    ].

    "/ let application show the help
    "/ (i.e. in its own information area)
    "/ nil-text is also passed down, to give it a chance
    "/ to clean its infoDisplay.

    top := aView topView.
    (app := aView application) notNil ifTrue:[
        (app showActiveHelp:text for:aView) ifTrue:[
            lastHelpText := text.
        ]
    ].
!

stopHelpDisplayProcess
! !

!ActiveHelp methodsFor:'start & stop'!

listenFor:anAppOrTopView
    "start listening"

    applicationsOrTopViewsWithHelp isNil ifTrue:[
        applicationsOrTopViewsWithHelp := WeakIdentitySet new.
    ].
    applicationsOrTopViewsWithHelp add:anAppOrTopView.
    super listen.

    "Created: / 26.10.1997 / 23:20:47 / cg"
    "Modified: / 26.10.1997 / 23:21:10 / cg"
!

listenForAll
    "start listening"

    listeningForAll := true.
    super listen.

    "Modified: / 28.6.1997 / 15:07:02 / cg"
    "Created: / 26.10.1997 / 23:19:30 / cg"
!

start
    self listenForAll
!

stop
    self unlistenAll
!

unlistenAll
    "stop listening"

    self hideHelp.

    listeningForAll := false.
    applicationsOrTopViewsWithHelp size == 0 ifTrue:[
        self unlisten.
    ]

    "Created: / 26.10.1997 / 23:14:17 / cg"
    "Modified: / 26.10.1997 / 23:23:04 / cg"
!

unlistenFor:anApp
    "stop listening for an app"

    self hideHelp.

    applicationsOrTopViewsWithHelp isNil ifFalse:[
        applicationsOrTopViewsWithHelp remove:anApp ifAbsent:nil.
    ].
    listeningForAll == true ifFalse:[
        applicationsOrTopViewsWithHelp size == 0 ifTrue:[
            self unlisten.
        ]
    ]

    "Created: / 26.10.1997 / 23:22:42 / cg"
    "Modified: / 29.10.1997 / 15:48:34 / cg"
! !

!ActiveHelp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ActiveHelp initialize!
