"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Object subclass:#KeyboardProcessor
	instanceVariableNames:'returnIsOKInDialog escapeIsCancelInDialog menuBar
		autoAcceptListeners globalAccelerators componentWithInitialFocus
		altFunctionWasExecuted eventFilter returnAction cancelAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

!KeyboardProcessor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    ST80 compatibility (mimicry) class.

    The class is not completed yet and certainly not bug free.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by reading public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    KeyboardProcessor is going to take over the focus control
    mechanism (which are currently located in the windowGroup).
    Currently, it keeps track of inputFields, and allows for
    a global accept to be forced.
    This is especially useful with dialogs, where a global accept
    should be performed on all inputFields, when the OK button
    is pressed.

    specials:
        eventFilter ....................... if non-nil, a block to return false, if
                                            the event is to be ignored.

    [author:]
        Claus Gittinger
"
! !

!KeyboardProcessor class methodsFor:'defaults'!

isCommandKey:aKeyCode
    "returns true if the keyCode is for a Command key (such as Cmda)"

    ^ aKeyCode size == 4                   "/ only CMD-single letter !!
        and:[aKeyCode startsWith:'Cmd']    "/ CmdMenu for right-alt in vmware ???
!

isFunctionKey:aKeyCode
    "returns true if the key code is for a Function key (such as F10)"

    (aKeyCode startsWith:'F') ifTrue:[
        (aKeyCode size between:2 and:3) ifTrue:[   
            (aKeyCode at:2) isDigit ifFalse:[^ false].
            aKeyCode size == 2 ifTrue:[^ true].
            ^ (aKeyCode at:3) isDigit
        ].
    ].
    ^ false
!

isKeyEventIgnoredAsShortcut:aKeyEvent
    "returns true if the key event ignored is a shortCut key
    "
    |rawKey|

    rawKey := aKeyEvent rawKey.
    rawKey isSymbol ifFalse:[^ true].
"/    "/ ignore cursor keys
"/    (#(
"/        Up Down Left Right 
"/        CursorUp CursorDown CursorLeft CursorRight
"/    ) includes:rawKey) ifTrue:[^ true].

    "/ ignore some meta keys
    (#( 
        #'Control_L' #'Control_R' #'Control' #'Ctrl' 
        #'CmdMenu' #'BackSpace' #Tab
        #'Cmd_L' #'Cmd_R' #'Cmd' #'Menu' 
        #'Shift_L' #'Shift_R' Shift 
        #'Alt_L' #'Alt_R' #'Alt'
        #'Super_R' #'Super_L' #'Super'
    ) includes:aKeyEvent key) ifTrue:[^ true].

    ^ false

    "Created: / 17.1.2001 / 11:57:07 / cg"
    "Modified: / 17.1.2001 / 13:05:46 / cg"
!

isMnemonicKeyEvent:aKeyEvent
    "returns true if the key event is a mnemonic key (such as Cmda)
    "
    |rawKey|

    rawKey := aKeyEvent rawKey.
    rawKey isSymbol ifFalse:[^ false].
    (self isCommandKey:rawKey) ifTrue:[^ true].
    (self isFunctionKey:rawKey) ifTrue:[^ true].
    ^ false
! !

!KeyboardProcessor methodsFor:'Compatibility-VW'!

keyboardConsumers
    ^ #()

    "Created: 6.3.1997 / 15:16:32 / cg"
!

removeKeyboardReceiver:aController

    "Created: / 31.10.1997 / 01:56:54 / cg"
!

sendKeyboardTo:aController

    "Created: / 31.10.1997 / 01:57:15 / cg"
!

setActive:aWidget

    "Created: 3.3.1997 / 18:31:09 / cg"
! !

!KeyboardProcessor methodsFor:'accessing'!

addAccelerator:aKey action:aSelectorOrBlock
    "add a global accelerator - these are handled even if no corresponding
     menu shortcut is defined"

    globalAccelerators isNil ifTrue:[
        globalAccelerators := Dictionary new
    ].
    globalAccelerators at:aKey put:aSelectorOrBlock
!

cancelAction:aBlock
    "this entry allows for another cancel action to be installed,
     to overwrite the default action, which closes a dialog without accept"
     
    cancelAction := aBlock.
!

componentWithInitialFocus
    ^ componentWithInitialFocus
!

componentWithInitialFocus:aComponent
    componentWithInitialFocus := aComponent
!

escapeIsCancelInDialog:aBoolean
    "set the escapeIsCancel flag.
     If off, Escape is NOT handled as cancel (the builder defaults it to true,)"

    escapeIsCancelInDialog := aBoolean
!

eventFilter:something
    eventFilter := something.
!

menuBar
    "return the value of the instance variable 'menuBar' (automatically generated)"

    ^ menuBar
!

menuBar:something
    "set the value of the instance variable 'menuBar' (automatically generated)"

    menuBar := something.
!

returnAction:aBlock
    "this entry allows for another return action to be installed,
     to overwrite the default action, which closes a dialog with accept"

    returnAction := aBlock.
!

returnIsOKInDialog:aBoolean
    "set the returnIsOK flag.
     If off, Return is NOT handled as accept (the builder defaults it to true,)"

    returnIsOKInDialog := aBoolean
! !

!KeyboardProcessor methodsFor:'event handling'!

processEvent:event forModalView:modalTopOrNil
    "process a key-event; return true, if handled & eaten; false if not.
     Here, first, we look for a globalAccelerator,
     then for Return and Escape in modal applications,
     (which lead to Accept & Cancel resp.)
     Finally, menu-shortcuts are handled."

    <resource: #keyboard (#Return #Escape #CloseWindowRequest)>

    |key rawKey topView wg app view action explicitFocusView focusView|

    event isKeyEvent ifFalse:[ ^ false ].

    eventFilter notNil ifTrue:[
        (eventFilter value:event) ifFalse:[
            ^ false.
        ]
    ].

    key := event key.
    rawKey := event rawKey.

    view := event view.

    topView := modalTopOrNil notNil ifTrue:[ modalTopOrNil ] ifFalse:[ view topView ].
    wg := topView windowGroup.
    app := topView application.

    "/ little state machine, to detect if the alt-key was pressed
    "/ without a concrete command key.
    "/ this will bring the focus to the menuPanel, if there is one.
"/ cg: disabled for now;
"/ leads to occasional leftover popupmenus floating around;
"/ ca has to look for this first.
false ifTrue:[
    key = #'Cmd' ifTrue:[
        event isKeyPressEvent ifTrue:[
            altFunctionWasExecuted := false.
        ] ifFalse:[
            event isKeyReleaseEvent ifTrue:[
                altFunctionWasExecuted ifFalse:[
                    (wg processShortcut:event) ifTrue:[
                        ^ true
                    ].
                ].
            ].
        ].
    ] ifFalse:[
        altFunctionWasExecuted := true.
    ].
].

    event isKeyPressEvent ifTrue:[
        "/ key startsWith:'Cmd'

        "/ how about global accelerators ?
        (globalAccelerators notNil
        and:[(action := globalAccelerators at:key ifAbsent:nil) notNil])
        ifTrue:[
            event consumed:true.
            action isSymbol ifTrue:[
                app notNil ifTrue:[
                    app perform:action withOptionalArgument:event
                ]
            ] ifFalse:[
                action valueWithOptionalArgument:event
            ].
            "/ ^ true
            ^ event consumed
        ].

        topView isModal ifTrue:[
            (key == #Return) ifTrue:[
                returnAction notNil ifTrue:[
                    returnAction value.
                    ^ true.
                ].    
                (returnIsOKInDialog ? true) ifTrue:[
                    (wg notNil 
                    and:[(explicitFocusView := wg explicitFocusView) isNil
                          or:[ false "explicitFocusView isKeyboardConsumer not" 
                          or:[ explicitFocusView isInputField ]]
                    ]) ifTrue:[
                        ((focusView := wg focusView) notNil and:[focusView isTextView]) ifTrue:[
                            focusView isInputField ifFalse:[
                                "/ modalBox with a TextView
                                ^ false
                            ].
                            "/ this is a kludge for subcanvases input-fields, which
                            "/ are not affected by #requestGlobalAutoAccept below.
                            focusView isAcceptOnReturn ifTrue:[
                                focusView accept
                            ].
                        ].

                        self requestGlobalAutoAccept ifFalse:[^ true].

                        "/ only care for RETURN and ESC if the window is the
                        "/ apps topView (not if its a popup or dialog of it)
                        (app notNil and:[app window == topView]) ifTrue:[
                            app doAcceptByReturnKey.
                        ] ifFalse:[
                            "/ oldStyle modalBox - for now, let Box handle it itself
                            ^ false
                        ].
                        ^ true
                    ].
                ].
            ].
            (key == #Escape) ifTrue:[
                cancelAction notNil ifTrue:[
                    cancelAction value.
                    ^ true.
                ].    
                (escapeIsCancelInDialog ? true) ifTrue:[
                    "/ only care for RETURN and ESC if the window is the
                    "/ apps topView (not if its a popup or dialog of it)
                    (app notNil and:[app window == topView]) ifTrue:[
                        app doCancelByEscapeKey.
                    ] ifFalse:[
                        "/ oldStyle modalBox - for now, let Box handle it itself
                        ^ false
                    ].
                    ^ true
                ].
            ].
        ].

        wg notNil ifTrue:[
            (self class isMnemonicKeyEvent:event) ifTrue:[
"/Transcript showCR:event rawKey.
"/Transcript showCR:event key.
                (wg processMnemonic:event) ifTrue:[
                    ^ true
                ]
            ].
            (self class isKeyEventIgnoredAsShortcut:event) ifFalse:[
"/Transcript showCR:event rawKey.
"/Transcript showCR:event key.
                (wg processShortcut:event) ifTrue:[
                    ^ true
                ].
            ].
        ].
        "/ support ALT-F4 (close window)
        (key == #CloseWindowRequest) ifTrue:[
            app notNil ifTrue:[
                app closeRequest
            ] ifFalse:[
                topView closeRequest
            ].
        ].
    ].

    "/ let view dispatch it.
    ^ false

    "Modified: / 18-07-2011 / 09:47:57 / cg"
!

requestForWindowClose
     "about to close the window."

     ^ true
!

requestGlobalAutoAccept
     "about to close the window via return ok accept.
      Ask all acceptListeners to accept their value and return true, if all of those fields
      did."

    autoAcceptListeners notNil ifTrue:[
        ^ autoAcceptListeners conform:[:aListener | (aListener requestAutoAccept)]
    ].
    "/ if no input field (or comparable widget) is present ...
"/    ^ false     <- wrong.
    ^ true.

    "Modified: / 13-10-2006 / 12:56:02 / cg"
! !

!KeyboardProcessor methodsFor:'setup'!

addAutoAcceptListener:aListener
    "add a aListener to my autoAcceptListeners.
     Typically, inputFields add themself, to be notified (via requestForAutoAccept)
     when the dialog is about to be closed with returnIsOK or accept.
     (of course, other listeners are also invited ;-)"

    autoAcceptListeners isNil ifTrue:[
        autoAcceptListeners := IdentitySet new.
    ].
    autoAcceptListeners add:aListener
! !

!KeyboardProcessor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

