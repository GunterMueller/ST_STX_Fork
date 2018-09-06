"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

FlyByHelp subclass:#FlyByWindowInformation
	instanceVariableNames:'lastApplication lastView cleanupAction finishSemaphore finished'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Help'
!

!FlyByWindowInformation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    I implement a tooltip, which presents a number of interesting facts
    about the window under the mouse pointer, and also offer keyboard
    shortcuts to quickly open browsers and/or inspectors on the view under the
    pointer.
    Enabled via the Launcher's 'FlyBy Window Information' menu item.
"
!

examples
"
    self shownInformationOfViewUnderMouseUntilButtonIsPressed
"
!

shownInformationOfViewUnderMouseUntilButtonIsPressed
    self start waitUntilFinished

    "
     self shownInformationOfViewUnderMouseUntilButtonIsPressed
    "
! !

!FlyByWindowInformation methodsFor:'accessing'!

cleanupAction:something 
    cleanupAction := something.
!

lastApplication
    ^ lastApplication
!

lastView
    ^ lastView
! !

!FlyByWindowInformation methodsFor:'defaults'!

flyByHelpTimeoutMillis
    ^ 1000
! !

!FlyByWindowInformation methodsFor:'event handling'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    finished == true ifTrue:[^ self].

    super buttonMotion:buttonAndModifierState x:x y:y view:aView.
    ^ true
!

buttonPress:button x:x y:y view:aView
    self stop.
    ^ true
!

keyPress:key x:x y:y view:aView
    <resource: #keyboard (#Escape #Return)>

    |obj objToInspect objToBrowse lcKey|

    key == #Escape ifTrue:[
        self stop.
        ^ true
    ].

    key == $? ifTrue:[
        [
            WindowTreeView notNil ifTrue:[
                WindowTreeView openOn:(lastView topView) initialSelection:lastView.
            ] ifFalse:[
                self warn:'WindowTreeView class is not present!!'.
            ].
        ] fork.
        self stop.
        ^ true.
    ].

    key == #Return ifTrue:[
        objToBrowse := lastApplication ? lastView
    ].

    key isCharacter ifTrue:[
        lcKey := key asLowercase.

        lcKey == $h ifTrue:[
            "/ use smalltalk at, to avoid dependency on libTool
            [ (Smalltalk at:#'Tools::ViewTreeInspectorApplication') openOn:lastView ] fork.
            ^ true.
        ].
        lcKey == $a ifTrue:[
            obj := lastApplication
        ].
        lcKey == $o ifTrue:[
            lastView notNil ifTrue:[
                obj := lastView model
            ].
        ].
        lcKey == $m ifTrue:[
            lastApplication notNil ifTrue:[
                obj := lastApplication masterApplication
            ]
        ].
        lcKey == $t ifTrue:[
            lastApplication notNil ifTrue:[
                obj := lastApplication topApplication
            ].
        ].
        lcKey == $v ifTrue:[
            obj := lastView
        ].
        lcKey == $g ifTrue:[
            obj := lastView windowGroup
        ].
        lcKey == $w ifTrue:[
            lastView notNil ifTrue:[
                obj := lastView topView
            ]
        ].
        obj notNil ifTrue:[
            key isLowercase ifTrue:[
                objToInspect := obj
            ] ifFalse:[
                objToBrowse := obj
            ].
        ].
    ].

    objToInspect notNil ifTrue:[
        [ objToInspect inspect ] forkAt:(Processor userSchedulingPriority).
    ].
    objToBrowse notNil ifTrue:[
        [ objToBrowse browse ] forkAt:(Processor userSchedulingPriority).
    ].

    ^ true

    "Modified: / 12-11-2010 / 11:51:04 / cg"
! !

!FlyByWindowInformation methodsFor:'help texts'!

helpTextFor:aView at:aPointOrNil
    "generate the text to be shown as popup-flyby info"

    |resources|

    lastView := aView.
    lastApplication := aView application.

    resources := self class classResources.

    ^ Text streamContents:[:s |
        |topViewToInspect applicationToInspect 
         masterApplicationToInspect topApplicationToInspect modelToInspect
         genComponentNameForApplication windowGroupToInspect|

        genComponentNameForApplication := 
            [:app :s |
                (app notNil 
                and:[ app builder notNil ]) ifTrue:[
                    |components v|

                    components := app builder namedComponents.

                    v := aView.
                    [   (components includes:v) not
                        and:[v container notNil]
                    ] whileTrue:[
                        v := v container.
                    ].
                    (components includes:v) ifTrue:[
                        |k|

                        k := components keyAtValue:v.
                        v == aView ifTrue:[
                            s nextPutLine:('       component: ' , k).
                        ] ifFalse:[
                            s nextPutLine:('       subview of component: ' , k).
                        ].
                    ].
                ].
            ].

        aView topView ~~ aView ifTrue:[
            topViewToInspect := aView topView.
        ].
        lastApplication notNil ifTrue:[
            applicationToInspect := lastApplication.
            masterApplicationToInspect := lastApplication masterApplication.
            masterApplicationToInspect notNil ifTrue:[
                masterApplicationToInspect == applicationToInspect ifTrue:[
                    masterApplicationToInspect := nil
                ] ifFalse:[
                    topApplicationToInspect := masterApplicationToInspect topApplication.
                    topApplicationToInspect == masterApplicationToInspect ifTrue:[
                        topApplicationToInspect := nil
                    ]
                ].
            ]
        ].
        aView model notNil ifTrue:[
            modelToInspect := aView model.
            ((modelToInspect == applicationToInspect)
            or:[ modelToInspect == masterApplicationToInspect ]) ifTrue:[
                modelToInspect := nil.
            ].
        ].

        applicationToInspect notNil ifTrue:[
            s nextPutLine:(resources string:'Application: %1' with:applicationToInspect class name allBold).
            genComponentNameForApplication value:applicationToInspect value:s.
        ].
        masterApplicationToInspect notNil ifTrue:[
            s nextPutLine:(resources string:'Master-Application: %1' with:masterApplicationToInspect class name allBold).
            "/ genComponentNameForApplication value:masterApplicationToInspect value:s.
        ].
        topApplicationToInspect notNil ifTrue:[
            s nextPutLine:(resources string:'Top-Application: %1' with:topApplicationToInspect class name allBold).
            "/ genComponentNameForApplication value:topApplicationToInspect value:s.
        ].
        s nextPutLine:(resources string:'View: %1 "%2"' with:aView class name allBold with:aView name).
        topViewToInspect notNil ifTrue:[
            s nextPutLine:(resources string:'Topview: %1' with:topViewToInspect class name allBold).
        ].
        modelToInspect notNil ifTrue:[
            s nextPutLine:(resources string:'Model: %1' with:modelToInspect class name allBold).
        ].

        s cr.
        s nextPutLine:'Press:'.

        "/ use smalltalk at, to avoid dependency on libTool
        (Smalltalk at:#'Tools::ViewTreeInspectorApplication') notNil ifTrue:[
            s nextPutLine:'    ? to show the view''s tree'.
        ].
        applicationToInspect notNil ifTrue:[
            s nextPutLine:'    a to inspect application (A to browse)'.
            masterApplicationToInspect notNil ifTrue:[
                s nextPutLine:'    m to inspect masterApplication (M to browse)'.
                topApplicationToInspect notNil ifTrue:[
                    s nextPutLine:'    t to inspect topApplication (T to browse)'.
                ]
            ].
        ].
        s nextPutLine:'    h to inspect view''s hierarchy'.
        s nextPutLine:'    v to inspect view (V to browse)'.
        topViewToInspect notNil ifTrue:[
            s nextPutLine:'    w to inspect topWindow (W to browse)'.
        ].
        aView windowGroup notNil ifTrue:[
            s nextPutLine:'    g to inspect windowGroup'.
        ].
        modelToInspect notNil ifTrue:[
            s nextPutLine:'    o to inspect model (O to browse)'.
        ].
        s cr.
        s nextPutLine:'RETURN to browse application.'.
        s nextPutAll:'ESC or click to leave flyBy-info mode.'.
    ]

    "
     self shownInformationOfViewUnderMouseUntilButtonIsPressed
    "

    "Modified: / 12-11-2010 / 11:54:59 / cg"
! !

!FlyByWindowInformation methodsFor:'private'!

activeHelpViewForApplication:applicationOrNil text:helpText onDevice:aDevice
    ^ (ActiveHelpView for:helpText onDevice:aDevice) shapeStyle:nil.
!

handleMouseIn:aView x:x y:y
    finished == true ifTrue:[^ self].
    super handleMouseIn:aView x:x y:y
!

targetViewInitiatesHelpViaSensor
    ^ false
! !

!FlyByWindowInformation methodsFor:'queries'!

toolTipFollowsMouse
    "if true, the tooltip-window moves with the pointer
     so that it stays away from (does not cover) the mouse pointer"

    ^ true
! !

!FlyByWindowInformation methodsFor:'start & stop'!

initiateHelpFor:aView at:aPointOrNil
    self initiateHelpFor:aView at:aPointOrNil now:true
!

initiateHelpFor:aView at:aPointOrNil now:showItNow
    finished == true ifTrue:[^ self].
    super initiateHelpFor:aView at:aPointOrNil now:showItNow
!

start
    |l|

    finished == true ifTrue:[^ self].

    l := FlyByHelp currentHelpListener.
    l notNil ifTrue:[
        FlyByHelp stop.
        cleanupAction := [ FlyByHelp start ].
    ].
    finishSemaphore := Semaphore new.
    finished := false.
    super start.
!

stop
    finished := true.
    super stop.
    cleanupAction value.
    finishSemaphore notNil ifTrue:[
        finishSemaphore signalIf.
    ].
!

waitUntilFinished
    finishSemaphore wait.
! !

!FlyByWindowInformation class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

