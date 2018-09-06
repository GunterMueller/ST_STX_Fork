"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996 by eXept Software AG
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

ApplicationModel subclass:#SimpleDialog
	instanceVariableNames:'accept cancel close escapeIsCancel postBuildBlock postOpenBlock
		preBuildBlock closeAllowedChannel acceptedValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

!SimpleDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    Use SimpleDialog to specify Dialogs with a windowSpec built by the GUI Builder.

    Notice: this class was implemented using protocol information
    from alpha testers and PD code - it may not be complete or compatible to
    the corresponding ST-80 class. If you encounter any incompatibilities,
    please forward a note to the ST/X team.

    [author:]
        Claus Gittinger

    [see also:]
        StandardSystemView
        WindowGroup DeviceWorkstation DialogBox
"
! !

!SimpleDialog class methodsFor:'queries'!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    self == SimpleDialog ifTrue:[^false].
    ^super isVisualStartable
! !

!SimpleDialog methodsFor:'DialogBox compatibility'!

destroy
    self closeRequest
!

hide
    self window hide
! !

!SimpleDialog methodsFor:'accessing'!

accept
    "return the valueholder which gets set to true by the accept button.
     Also, when this valueHolder gets a true stuffed into it, the dialog is closed.
     This valueHolder is also set to true, if the acceptValue get a value stored into."

    accept isNil ifTrue:[
        accept := ValueHolder with:false.
    ].

    ^ accept

    "Modified: / 20.5.1998 / 20:51:05 / cg"
!

acceptValue:something
    "save something in acceptedValue (to be passed back to the opened of this dialog),
     and set the accept-holder to true, which closes the dialog window.
     This is similar to a regular accept, but allows for a particular return-value to be passed
     back."

    acceptedValue := something.
    self closeAccept
!

accepted
    "after the box has closed:
         return true if accepted, false if canceled"

    ^ accept value
!

acceptedValue
    "an additional value which can be passed back to the one who opened a dialog"

    ^ acceptedValue
!

bindings
    "return my builders bindings"

    ^ builder bindings

    "Modified: / 20.5.1998 / 20:51:15 / cg"
!

cancel
    "return the valueholder which gets set by the cancel button.
     Also, when this valueHolder gets a true stuffed into it, the
     dialog is closed."

    cancel isNil ifTrue:[
        cancel := ValueHolder with:false.
    ].
    ^ cancel

    "Modified: / 20.5.1998 / 20:51:02 / cg"
!

closeAllowedChannel
    "return the value-provider which controls if close is allowed.
     This is initialized to true."

    ^ closeAllowedChannel

    "Created: / 20.5.1998 / 21:52:32 / cg"
    "Modified: / 20.5.1998 / 21:53:18 / cg"
!

closeAllowedChannel:aValueHolderOrBlock
    "set a value-provider which controls if close is allowed."

    ^ closeAllowedChannel

    "Created: / 20.5.1998 / 21:52:53 / cg"
!

closeChannel
    "return the closeChannel; If a true is stuffed into this valueHolder,
     I will close myself."

    ^ close

    "Modified: / 20.5.1998 / 20:52:29 / cg"
!

escapeIsCancel
    "return the escapeIsCancel setting"

    ^ escapeIsCancel

    "Modified: / 20.5.1998 / 20:52:44 / cg"
!

escapeIsCancel:something
    "set/clear the escapeIsCancel option.
     If on, an ESC-key will be treated like a cancel action."

    escapeIsCancel := something.

    "Modified: / 20.5.1998 / 20:53:23 / cg"
!

postBuildBlock:something
    "set postBuildBlock; if non-nil, this is evaluated after the build process"

    postBuildBlock := something.

    "Modified: / 20.5.1998 / 20:54:06 / cg"
!

postOpenBlock:something
    "set the postBuildBlock; if non-nil, this is evaluated after the view is opened"

    postOpenBlock := something.

    "Modified: / 20.5.1998 / 20:54:23 / cg"
!

preBuildBlock:something
    "set the preBuildBlock; if non-nil, this is evaluated before the view is constructed"

    preBuildBlock := something.

    "Modified: / 20.5.1998 / 20:54:41 / cg"
!

source:anApplication
    "define the application which provides resources, aspects etc."

    builder source:anApplication.
    masterApplication isNil ifTrue:[
        anApplication ~~ self ifTrue:[
            masterApplication := anApplication
        ]
    ].

    "Modified: / 8.9.1998 / 01:46:06 / cg"
! !

!SimpleDialog methodsFor:'accessing-window'!

minWidth:nPixels
    |w|

    w := builder window width.
    builder window width:(w max:nPixels).

"/    box := builder window displayBox.
"/    box width: (box width max: nPixels).
"/    builder window displayBox: box

    "Modified: 3.3.1997 / 21:56:27 / cg"
! !

!SimpleDialog methodsFor:'events'!

closeAccept
    "accept was pressed. close the dialog"

    self requestForWindowClose ifTrue:[
        builder keyboardProcessor requestGlobalAutoAccept ifTrue:[
            accept value:true.
            self closeWindow
        ]
    ]

    "Modified: 17.6.1997 / 14:10:23 / cg"
!

closeCancel
    "cancel was pressed. close the dialog"

    self requestForWindowClose ifTrue:[
        self closeWindow
    ]

    "Modified: 17.6.1997 / 14:10:29 / cg"
!

closeWindow
    "close the dialog"

    |c|

    c := self closeChannel.
    c retractInterestsFor:self.
    c value:true.

    "/ must destroy instead of hide - otherwise there is no #release to
    "/ the controller (onChangeSend-dependency problem)
    "/     builder window destroy. "/ hide

    "/ changed to use the general closeDownViews 
    "/ (some want to redefine it and expect it to be called; it eventually also does a window destroy)
    self closeDownViews.

    "Modified (comment): / 31-07-2013 / 18:02:55 / cg"
!

requestForWindowClose
    "the dialog is about to be closed - this method is invoked and may
     return false to suppress the close.
     Here the value of closeAllowedChannel is returned, which is
     set to true initially.
     You may redefined this in a special dialog, and/or provide a boolean
     valueHolder or a boolean block via the #closeAllowedChannel: method."

    ^ closeAllowedChannel value

    "Modified: / 20.5.1998 / 21:52:25 / cg"
! !

!SimpleDialog methodsFor:'forced actions'!

doAccept
    "force accept"

    self accept value:true

    "Created: / 18.10.1997 / 05:18:09 / cg"
    "Modified: / 20.5.1998 / 21:53:35 / cg"
!

doCancel
    "force cancel"

    self cancel value:true

    "Created: / 18.10.1997 / 05:18:22 / cg"
    "Modified: / 20.5.1998 / 21:53:40 / cg"
! !

!SimpleDialog methodsFor:'initialization'!

initialize
    accept := (ValueHolder with:false).
    close := (ValueHolder with:false).
    cancel := (ValueHolder with:false).
    self createBuilder.
    builder aspectAt:#accept put:accept.
    builder aspectAt:#close put:close.
    builder aspectAt:#cancel put:cancel.
    escapeIsCancel := true.
    closeAllowedChannel := true

    "Modified: / 19.6.1998 / 03:35:48 / cg"
!

initializeBuilderFor:aView 
    aView notNil ifTrue:[
        builder window:aView.
    ]

    "Created: 3.3.1997 / 16:23:04 / cg"
!

initializeWindowFor:aView
    |v|

    (v := aView) isNil ifTrue:[
        v := ModalBox new.
    ].

    builder setupWindowFor:v.

    "Modified: 3.3.1997 / 20:39:46 / cg"
! !

!SimpleDialog methodsFor:'opening-dialogInterface'!

allButOpenFor:anApplication interfaceSpec:aSpec withBindings:bindings
    "open the dialog for some appModel from a given spec;
     the bindings argument may provide overwriting bindings for the dialog.
     Return true if accepted, false if canceled"

    |app|

    builder isNil ifTrue:[ self createBuilder ].

    builder addBindings:bindings.
    (app := anApplication) isNil ifTrue:[
        app := ApplicationModel new
    ].
    self source:app.
    ^ self allButOpenFrom:aSpec

    "Created: / 05-11-2010 / 11:27:26 / cg"
!

allButOpenFrom:aSpec
    "create my views but do not open the main window"

    super allButOpenFrom:aSpec.
    self preOpen
!

openFor:anApplication interface:aSelector
    "open the dialog for some appModel from a given spec;
     Return true if accepted, false if canceled"

    ^ self openFor:anApplication interface:aSelector withBindings:nil

    "Modified: 28.2.1997 / 16:22:08 / cg"
!

openFor:anApplication interface:aSelector withBindings:bindings
    "open the dialog for some appModel from a given specSymbol;
     the application must provide an interfaceSpec for that symbol.
     The bindings argument may provide overwriting bindings for the
     dialog.
     Return true if accepted, false if canceled"

    ^ self
        openFor:anApplication 
        interfaceSpec:(anApplication interfaceSpecFor:aSelector)
        withBindings:bindings

    "Modified: 18.10.1997 / 04:43:13 / cg"
!

openFor:anApplication interfaceSpec:aSpec withBindings:bindings
    "open the dialog for some appModel from a given spec;
     the bindings argument may provide overwriting bindings for the
     dialog.
     Return true if accepted, false if canceled"

    self allButOpenFor:anApplication interfaceSpec:aSpec withBindings:bindings.
    self openDialog.
    ^ accept value

    "Created: / 07-07-2011 / 16:52:04 / cg"
!

openFor:anApplication spec:aSpec withBindings:bindings
    "open the dialog for some appModel from a given spec.
     The bindings argument may provide overwriting bindings for the
     dialog.
     Return true if accepted, false if canceled"

    ^ self
        openFor:anApplication 
        interfaceSpec:aSpec
        withBindings:bindings

    "Modified: / 18.10.1997 / 04:43:13 / cg"
    "Created: / 20.5.1998 / 20:28:29 / cg"
!

openFrom:anInterfaceSpec
    "open the dialog from a given spec;
     return true if accepted, false if canceled"

    self allButOpenFrom:anInterfaceSpec.
    self openDialog.
    ^ accept value

    "Modified: 28.2.1997 / 16:40:36 / cg"
!

openInterface:aSymbol
    "open a standard interface.
     Redefined to return the accept value instead of the builder."

    self accept setValue:false.

    super openInterfaceModal:aSymbol.
    acceptedValue notNil ifTrue:[^ acceptedValue].
    ^ accept value.

    "Created: / 23.1.1998 / 18:19:57 / cg"
    "Modified: / 20.5.1998 / 20:21:28 / cg"
!

openInterface:aSymbol at:position
    "open a standard interface.
     Redefined to return the accept value instead of the builder."

    super openInterfaceModal:aSymbol at:position.
    acceptedValue notNil ifTrue:[^ acceptedValue].
    ^ accept value.

    "Created: / 23.1.1998 / 18:19:57 / cg"
    "Modified: / 20.5.1998 / 20:21:28 / cg"
!

openModelessFor:anApplication interfaceSpec:aSpec withBindings:bindings
    "open the dialog for some appModel from a given spec;
     the bindings argument may provide overwriting bindings for the
     dialog.
     Return immediately, not blocking the caller"

    self allButOpenFor:anApplication interfaceSpec:aSpec withBindings:bindings.
    self openDialogModeless
!

openModelessFor:anApplication spec:aSpec withBindings:bindings
    "open the dialog for some appModel from a given spec.
     The bindings argument may provide overwriting bindings for the
     dialog.
     Return immediately (i.e non-blocking the caller)"

    self
        openModelessFor:anApplication 
        interfaceSpec:aSpec
        withBindings:bindings
!

openSpec:aWindowSpec
    "open a window spec.
     Redefned to open modal and to return the accept value instead 
     of the builder."

    super openSpecModal:aWindowSpec.
    ^ accept value.

    "Modified: / 22.4.1998 / 11:59:05 / cg"
    "Created: / 20.5.1998 / 20:21:17 / cg"
!

openSpec:anInterfaceSpec withBindings:bindings
    "open the dialog with a given spec;
     The bindings argument is mandatory and provides aspect bindings for the
     dialog.
     Return true if accepted, false if canceled"

    ^ self
        openFor:self 
        interfaceSpec:anInterfaceSpec
        withBindings:bindings
!

postBuildWith:aBuilder
    "this is sent after the dialogs widgets have been created
     (but before the dialog is opened).
     If a postBuildBlock was set, evaluate it here."

    postBuildBlock notNil ifTrue:[
        postBuildBlock valueWithOptionalArgument:aBuilder
    ].
    builder source ~= self ifTrue:[
        "/ I was opened as dialogInterface for another application;
        "/ inform it that I am ready now
        builder source postBuildDialogWith:aBuilder
    ].

    super postBuildWith:aBuilder

    "Created: / 18-10-1997 / 05:17:12 / cg"
!

postOpenWith:aBuilder
    "this is sent after the dialogs main window is opened.
     If a postOpenBlock was set, evaluate it here."

    postOpenBlock notNil ifTrue:[
        postOpenBlock valueWithOptionalArgument:aBuilder
    ].
    builder source ~= self ifTrue:[
        "/ I was opened as dialogInterface for another application;
        "/ inform it that I am ready now
        builder source postOpenDialogWith:aBuilder
    ].
    super postOpenWith:aBuilder

    "Created: / 18-10-1997 / 05:15:48 / cg"
!

preBuildWith:aBuilder
    "this is sent before the dialogs widgets are created.
     If a preBuildBlock was set, evaluate it here."

    preBuildBlock notNil ifTrue:[
        preBuildBlock valueWithOptionalArgument:aBuilder
    ].
    builder source ~= self ifTrue:[
        "/ I was opened as dialogInterface for another application;
        "/ inform it that I am ready now
        builder source preBuildDialogWith:aBuilder
    ].
    super preBuildWith:aBuilder

    "Created: / 18-10-1997 / 15:02:27 / cg"
!

preOpen
    "arrange for #closeAccept & #closeCancel to be invoked when
     either accept or close is triggered
     (usually the models of corresponding buttons)"

    accept onChangeSend:#closeAccept to:self.
    cancel onChangeSend:#closeCancel to:self.
    close  onChangeSend:#closeWindow to:self.

    "Modified: / 20.5.1998 / 20:49:26 / cg"
!

preOpenWith:aBuilder
    "this is sent after the dialogs main window is opened.
     If a postOpenBlock was set, evaluate it here."

    builder source ~= self ifTrue:[
        "/ I was opened as dialogInterface for another application;
        "/ inform it that I am ready now
        builder source preOpenDialogWith:aBuilder
    ].
    super preOpenWith:aBuilder

    "Created: / 05-03-2014 / 18:47:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleDialog methodsFor:'queries'!

defaultWindowType
    "SimpleDialogs come up modal, by default"

    ^ #dialog

    "Modified: 14.2.1997 / 22:17:20 / cg"
!

shouldRememberLastExtent
    (self accepted) ifFalse:[^ false].
    ^ super shouldRememberLastExtent

    "Created: / 31-07-2013 / 18:06:12 / cg"
! !

!SimpleDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

