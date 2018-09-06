"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Label subclass:#Button
	instanceVariableNames:'activeLogo passiveLogo disabledLogo focusLogo onLevel offLevel
		disabledFgColor disabledEtchedFgColor activeFgColor activeBgColor
		enteredFgColor enteredBgColor isReturnButton shadowForm lightForm
		formColor formShadowColor formLightColor edgeStyle
		halfShadowColor halfLightColor defaultable enterLevel leaveLevel
		enteredLogo'
	classVariableNames:'ReturnForm ReturnLightForm ReturnShadowForm DefaultActiveLevel
		DefaultPassiveLevel DefaultEdgeStyle DefaultBorderWidth
		DefaultForegroundColor DefaultBackgroundColor
		DefaultDisabledForegroundColor DefaultDisabledBackgroundColor
		DefaultDisabledEtchedForegroundColor
		DefaultEnteredForegroundColor DefaultEnteredBackgroundColor
		DefaultActiveForegroundColor DefaultActiveBackgroundColor
		DefaultReturnButtonHasImage DefaultReturnButtonHasBorder
		DefaultShadowColor DefaultLightColor DefaultHalfShadowColor
		DefaultHalfLightColor DefaultFocusHighlightStyle'
	poolDictionaries:''
	category:'Views-Interactors'
!

!Button class methodsFor:'documentation'!

actionBlocksVersusModelChanges 
"
    You may ask yourself, why ST/X supports two different ways
    to trigger a buttons action (also true for sliders, selectionInListViews,
    toggles etc.) and when to use which mechanism.

    There are two reasons:
	1) history - historically, ST/X used only actionBlocks
	   Basically, these provide the most general functionality
	   (you can of course send change-messages from those blocks)

	   Change-message notification was added later, to make porting
	   of existing applications easier.

	2) for many (simple) applications, it is often easier, to simply
	   define an action block. This is especially true, if the button
	   triggers some action (such as ok-/abort-buttons) and does NOT
	   change some models internal value.
	   (other smalltalks provide extra adapter-models for this,
	    in which you can set actionBlocks in much the same way).

    In general:
	use model-change-messages, iff multiple views are possibly open
	on the same domain model, and changes can occur from multiple
	places. Or if a change has to be forwarded to multiple other objects
	(possible not foreseen).

	For simplicity, better use actionBlocks for trigger-like actions
	(such as closing a view, ok/abort etc.) iff there is only a single
	entity which is interested in that button press.
"
!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Buttons are Labels which do something when pressed/released.
    Since they inherit from Label, read the documentation on Labels to 
    see how color, layout, font, image or labelString are changed.

    Buttons (and also instances of subclasses, such as toggles, checkToggles
    and radioButtons) perform some action when pressed, and optionally when
    released. Due to historic reasons, ST/X buttons support two mechanisms:

    Actionblock operation:
      the button has an actionBlock (actually, it has two: a pressAction and
      a releaseAction) which is evaluated, when the button is pressed.
      The user of a button can set these action blocks via the #action:,
      #pressAction: or #releaseAction: messages.

    Model-View interaction:
      buttons with a model will send change-messages to the model and also react 
      to changes in the model.
      You have to define the buttons labelMessage and an aspectSymbol.
      When changed, the model should send 'self changed:<aspect>' if it wants the
      label to change and return a string from the labelSymbol-message.
      By default, the labelMsg is nil, therefore no update of the label is done.
      (this behavior is inherited from label, see documentation there)

      When pressed, the button sends a changeMessage to the model.
      If the changeMsg is for a one-argument message, the current
      press-state is passed as argument (i.e. true if pressed, false if released).
      By default, the change-Message is #value: (for ST-80 compatibility).

        button model:aModel.
        button aspect:aspectSymbol.
        button change:changeSymbol.
        button labelMessage:labelSymbol.

        model sends #changed:aspectSymbol
        ---> button will redraw its label from value returned by model>>labelSymbol

        button changes state:
        ---> button sends changeSymbol / changeSymbol:state to the model

      By default (as inherited), the labelMsg is nil; therefore, buttons
      do not try to acquire a new labelString from the model.
      If you want this behavior, you must set labelMsg and aspectMsg
      as appropriate.

    labels
      Originally, labels only had a label- and disabledLabel attributes (both
      had to be explicitly set via setter methods).
      Later the model- and labelChannel interfaces were added; model interface
      for compatbility with other smalltalks, where a single multi-aspect model
      might be used, the channels were added to support visualWorks style of multiple
      single-aspect holders. This final version is also what the UIBuilder is working
      against. The other mechanisms are still present, but disabled if a newer mechanism
      is used (i.e. if a labelChannel has been given, the label and disabledLabel instvars
      are ignored).
      All of this is here to provide backward compatibility for existing customers
      and st/x programs (which is a good thing to have, b.t.w).


    See examples.


    [Instance variables:]

      activeLogo              <StringOrImage> logo to show when active (pressed)
      passiveLogo             <StringOrImage> logo to show when passive (released)
                                              default is nil for both, so the normal logo is used
                                              (see superclass: Label)
      onLevel                 <Integer>       level when pressed (3D only) (default: depends on style)
      offLevel                <Integer>       level when released (3D only) (default: depends on style)
      disabledFgColor         <Color>         color used to draw logo when disabled (default: depends on style)
      activeFgColor           <Color>         color to draw logo when pressed (default: depends on style)
      activeBgColor           <Color>         bg color when pressed (default: depends on style)
      enteredFgColor          <Color>         fg color to draw logo when cursor entered (default: depends on style)
      enteredBgColor          <Color>         bg color when cursor entered (default: depends on style)

      isReturnButton          <Boolean>       true if this button is also activated by the
                                              return key - if true, it will draw a return-bitmap 
                                              in addition to the logo (default: false)

      defaultable             <Boolean>       true, if this button can become a returnButton.
                                              (computes its default extent differently)

      shadowForm              <Form>          form to display in addition to buttons label (returnbutton only)
      lightForm               <Form>          light part of shadowForm (returnbutton only)

      formColor               <Color>         color to draw form with (returnbutton only)
      formShadowColor         <Color>         color for shadowing the form (3D only & return)
      formLightColor          <Color>         color for lighting the form (3D only)


    [styleSheet parameters:]

      buttonActiveLevel       <Integer>       level when on (ignored in 2D styles)
      buttonPassiveLevel      <Integer>       level when off (ignored in 2D styles)
      buttonBorderWidth       <Integer>       default borderwidth
      buttonEdgeStyle         <Symbol>        style of edges (currently #soft or nil)
      buttonFont              <Font>          font to use for textual labels
      buttonForegroundColor   <Color>         color to draw foreground pixels (i.e. the string)
      buttonBackgroundColor   <Color>         color to draw background pixels
      buttonDisabledForegroundColor <Color>   same when disabled
      buttonDisabledBackgroundColor <Color>   same when disabled
      buttonEnteredForegroundColor  <Color>   same when mouse pointer is in
      buttonEnteredBackgroundColor  <Color>   same when mouse pointer is in
      buttonActiveForegroundColor   <Color>   same when button is active
      buttonActiveBackgroundColor   <Color>   same when button is active
      buttonShadowColor             <Color>   shadow color for edgaes (ignored in 2D styles)
      buttonLightColor              <Color>   light color for edgaes (ignored in 2D styles)
      buttonHalfShadowColor         <Color>   half shadow color; for soft edges only
      buttonHalfLightColor          <Color>   half light color; for soft edges only

      buttonReturnButtonHasImage    <Boolean> if true, return-buttons draw a return-key image
      buttonReturnButtonHasBorder   <Boolean> if true, return-buttons show a border

    [author:]
        Claus Gittinger

    [see also:]
        Toggle CheckToggle CheckBox
        Dialog
        ValueHolder TriggerValue
        Block
"
!

examples 
"
    You don't have to normally care for all the internals 
    (they allow many variations though). 
    For buttons with a stringLabel, the typical use is:

        b := Button label:'some logo' in:aView.
        b action:[ .. things to do, when pressed ... ]

    and for bitmap/image buttons its:

        b := Button label:someImage in:aView.
        b action:[ .. things to do, when pressed ... ]



    Of course, you can also setup things the ST-80 way, in first
    creating the button and later add it to some superview:

        b := Button new.
        b label:someImage.
        b action:[ .. things to do, when pressed ... ]
        ...
        aSuperView add:b in:<frameRectangle>.


    Although you can specify most of the look of a button,
    you should use the defaults in most applications.
    As you specify more things in your program, 
    the styleSheet settings are more and more ignored.
    Also, even though it might look fancy, colorful
    button panels are usually not a good GUI design;
    they will attract the users attention - possibly to things
    which are not worth it.
    Finally, if you use fancy colors, always think of those poor users
    without color displays - the styleSheet allows those people to adjust things,
    while hard-coded colors cannot be fixed without changing the code.

    a simple button with default settings and no action:
    (you may want to try it with different viewStyle settings in effect):
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b label:'hello'.

          top open.
                                                                        [exEnd]


    give it some action (watch the transcript):
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b label:'hello'.
          b action:[Transcript flash].

          top open.
                                                                        [exEnd]


    there is also a combined instance creation message:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button label:'hello' action:[Transcript flash] in:top.

          top open.
                                                                        [exEnd]


    a return button
    (in dialogs, you should setup things to have the return-key perform
     the ok action, and mark the corresponding button as being a returnButton):
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button label:'hello' action:[Transcript flash] in:top.
          b beReturnButton.
          top open.
                                                                        [exEnd]



    multiple buttons in a panel:
                                                                        [exBegin]
          |top panel b1 b2 b3|

          top := StandardSystemView new.
          top extent:300@100.

          panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

          b1 := Button label:'one'   in:panel.
          b2 := Button label:'two'   in:panel.
          b3 := Button label:'three' action:[Transcript flash] in:panel.

          top open.
                                                                        [exEnd]



    enabling/disabling buttons via explicit messages:
                                                                        [exBegin]
          |top panel b1 b2 b3|

          top := StandardSystemView new.
          top extent:300@100.
          panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

          b1 := Button label:'enable'  action:[b3 enable] in:panel.
          b2 := Button label:'disable' action:[b3 disable] in:panel.
          b3 := Button label:'flash'   action:[Transcript flash] in:panel.
          top open.
                                                                        [exEnd]



    enabling/disabling buttons via implicit value change of a valueHolder:
    The two views are only indirectly coupled (via the valueHolder);
    not knowing about each other.
                                                                        [exBegin]
          |top panel ena t b1 b2 b3 check|

          top := StandardSystemView new.
          top extent:300@100.

          panel := HorizontalPanelView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.

          ena := false asValue.

          t := Toggle label:'enable' in:panel.
          t model:ena.

          b1 := Button label:'button1' in:panel.
          b1 controller enableChannel:ena.

          b2 := Button label:'button2' in:panel.
          b2 controller enableChannel:ena.

          b3 := Button label:'button3' in:panel.
          b3 controller enableChannel:ena.

          top open.

          check := CheckBox model:ena.
          check label:'also enable'.
          check extent:(check preferredExtent + (5@5)).
          check open
                                                                        [exEnd]



    changing colors:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button label:'hello' in:top.
          b action:[Transcript flash].
          b activeForegroundColor:(Color white).
          b activeBackgroundColor:(Color red).

          top open.
                                                                        [exEnd]


    changing more colors:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button label:'hello' in:top.
          b action:[Transcript flash].
          b enteredForegroundColor:(Color red).
          b enteredBackgroundColor:(b backgroundColor).
          b activeForegroundColor:(Color white).
          b activeBackgroundColor:(Color red).

          top open.
                                                                        [exEnd]


    button with an image and different colors:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b label:(Image fromFile:'bitmaps/SBrowser.xbm').
          b action:[Transcript flash].
          b enteredForegroundColor:(Color green darkened).
          b enteredBackgroundColor:(b backgroundColor).
          b activeForegroundColor:(Color white).
          b activeBackgroundColor:(Color red).

          top open.
                                                                        [exEnd]


    changing the image when pressed:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b passiveLogo:(Image fromFile:'bitmaps/SBrowser.xbm').
          b activeLogo:(Image fromFile:'bitmaps/CBrowser.xbm').
          b action:[Transcript flash].
          b enteredForegroundColor:(Color red).
          b enteredBackgroundColor:(b backgroundColor).
          b activeForegroundColor:(Color white).
          b activeBackgroundColor:(Color red).

          top open.
                                                                        [exEnd]


    well, even that is possible (but you should NEVER do it):
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b passiveLogo:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_tools/email.xpm').
          b activeLogo:'start'.
          b action:[Transcript flash].
          b enteredForegroundColor:(Color red).
          b enteredBackgroundColor:(b backgroundColor).
          b activeForegroundColor:(Color white).
          b activeBackgroundColor:(Color red).
          top open.
                                                                        [exEnd]


    more playing with colors:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button in:top.
          b logo:(Image fromFile:'../../goodies/bitmaps/xbmBitmaps/TicTacToe.xbm').
          b action:[Transcript flash].
          b foregroundColor:(Color red:0 green:80 blue:20) darkened.
          b backgroundColor:(Color grey:10).
          b enteredForegroundColor:(Color red).
          b activeForegroundColor:(Color red).
          b activeBackgroundColor:(Color grey:50).
          top open.
                                                                        [exEnd]


    fire on press (buttons in scrollbars do this, while normal buttons
    fire on release).
    To give the user a chance to change her mind
    and leave the button without action, you should not change the default 
    behavior and NOT use triggerOnDown-buttons in most applications:
                                                                        [exBegin]
          |top b|

          top := StandardSystemView new.
          top extent:100@100.

          b := Button label:'hello' in:top.
          b controller beTriggerOnDown.
          b action:[Transcript flash].
          top open.
                                                                        [exEnd]


    To implement fun buttons (for games, show-demos etc.), you can
    access all internal parameters (and not take the viewStyle defaults)
    as in:
                                                                        [exBegin]
          |b granite light shadow|

          b := Button label:'a nice one ?'.
          granite := Image fromFile:'bitmaps/granite_small.tiff'.
          light := granite lightened.
          shadow := granite darkened darkened.
          b backgroundColor:granite.
          b foregroundColor:Color white.
          b shadowColor:shadow.
          b lightColor:light.
          b enteredBackgroundColor:light.
          b enteredForegroundColor:Color black.
          b activeLevel:-3; passiveLevel:5.
          b extent:(200 @ 50).
          b open
                                                                         [exEnd]

    However, in your application, you may want to read those bitmaps only once
    during startup and cache them for later reuse in some class variable
    (reading, lightning & darkening of images is a bit slow)


    ST/X Buttons allow simulation of the ST-80 MVC way of interacting.
    To do so, instead (or in addition) to defining actionBlocks, set the
    buttons model to have this be informed (in addition):

    Model-View interaction (ST-80 style):
    (have a look at the models values in the inspector, as the toggles change)
                                                                        [exBegin]
        |bool1 bool2 b1 b2 panel top|

        bool1 := ValueHolder newBoolean.
        bool2 := ValueHolder newBoolean value:true.

        top := StandardSystemView new.
        top extent:200@100.

        panel := HorizontalPanelView 
                  origin:0.0 @ 0.0 corner:1.0 @ 50 in:top.

        b1 := Toggle label:'eat me' in:panel.
        b1 model:bool1.

        b2 := Toggle label:'drink me' in:panel.
        b2 model:bool2.

        top open.
        bool1 inspect.
        bool2 inspect.
                                                                        [exEnd]


    Using a PluggableAdaptor (ST-80 style):
    (notice, that this is almost what ST/X buttons did originally,
     therefore, you may want use actionBlocks right away ...)
                                                                        [exBegin]
          |adaptor1 adaptor2 b1 b2 panel top|

          adaptor1 := PluggableAdaptor new 
                            getBlock:[:m | false] 
                            putBlock:[:m :v | Transcript showCR:'eat']
                            updateBlock:nil.
          adaptor2 := PluggableAdaptor new 
                            getBlock:[:m | false] 
                            putBlock:[:m :v | Transcript showCR:'drink']
                            updateBlock:nil.

          top := StandardSystemView new.
          top extent:200@100.

          panel := HorizontalPanelView 
                    origin:0.0 @ 0.0 corner:1.0 @ 50 in:top.

          b1 := Button label:'eat me' in:panel.
          b1 model:adaptor1.

          b2 := Button label:'drink me' in:panel.
          b2 model:adaptor2.

          top open.
                                                                        [exEnd]


    as a reminder, the corresponding ST/X setup is:
                                                                        [exBegin]
          |b1 b2 panel top|

          top := StandardSystemView new.
          top extent:200@100.

          panel := HorizontalPanelView 
                    origin:0.0 @ 0.0 corner:1.0 @ 50 in:top.

          b1 := Button label:'eat me' in:panel.
          b1 action:[Transcript showCR:'eat'].

          b2 := Button label:'drink me' in:panel.
          b2 action:[Transcript showCR:'drink'].

          top open.
                                                                        [exEnd]


    accessing multiple aspects of a complex model
    (using a plug here to simulate that model ...)
    (Notice, the next example shall demonstrate multiple aspects;
     for this kind of functionality, you'd better use actionBlocks in
     real applications)
                                                                        [exBegin]
          |myModel b1 b2 panel top|

          myModel := Plug new.
          myModel respondTo:#grow with:[top extent:200@300].
          myModel respondTo:#shrink with:[top extent:200@100].

          top := StandardSystemView new.
          top extent:200@100.

          panel := HorizontalPanelView 
                    origin:0.0 @ 0.0  
                    corner:1.0 @ 50
                    in:top.

          b1 := Button label:'eat me' in:panel.
          b1 model:myModel; change:#grow.

          b2 := Button label:'drink me' in:panel.
          b2 model:myModel; change:#shrink.

          top open.
                                                                        [exEnd]


    acquiring the label from the model
    (this functionality is inherited from Label)
                                                                        [exBegin]
          |myModel b1 b2 b3 panel top currentLabel|

          currentLabel := 'foo'.

          myModel := Plug new.
          myModel respondTo:#getLabel with:[currentLabel].
          myModel respondTo:#b0Pressed with:[].
          myModel respondTo:#b1Pressed with:[currentLabel := 'bar'.
                                             myModel changed:#labelAspect].
          myModel respondTo:#b2Pressed with:[currentLabel := 'foo'.
                                             myModel changed:#labelAspect].

          top := StandardSystemView new.
          top extent:300@100.

          panel := HorizontalPanelView 
                    origin:0.0 @ 0.0  
                    corner:1.0 @ 50
                    in:top.

          b1 := Button label:'press me' in:panel.
          b1 model:myModel; change:#b0Pressed; 
             labelMessage:#getLabel; aspect:#labelAspect.

          b2 := Button label:'press for bar' in:panel.
          b2 model:myModel; change:#b1Pressed.

          b3 := Button label:'press for foo' in:panel.
          b3 model:myModel; change:#b2Pressed.

          top open.
                                                                        [exEnd]


    the same, using actionBlocks:
    (notice, that we must disable changeMessages from the first button).
                                                                        [exBegin]
          |myModel b1 b2 b3 panel top currentLabel|

          currentLabel := 'foo'.

          myModel := Plug new.
          myModel respondTo:#getLabel with:[currentLabel].

          top := StandardSystemView new.
          top extent:300@100.

          panel := HorizontalPanelView origin:0.0 @ 0.0 corner:1.0 @ 50 in:top.

          b1 := Button label:'press me' in:panel.
          b1 model:myModel; action:[Transcript showCR:'pressed']; 
             labelMessage:#getLabel; aspect:#labelAspect; change:nil.

          b2 := Button label:'press for bar' in:panel.
          b2 action:[currentLabel := 'bar'. myModel changed:#labelAspect].

          b3 := Button label:'press for foo' in:panel.
          b3 action:[currentLabel := 'foo'. myModel changed:#labelAspect].

          top open.
                                                                        [exEnd]


    the same, using a labelChannel:
                                                                        [exBegin]
          |b1 b2 b3 panel top labelHolder|

          labelHolder := 'press me' asValue.

          top := StandardSystemView new.
          top extent:350@100.

          panel := HorizontalPanelView origin:0.0 @ 0.0 corner:1.0 @ 50 in:top.

          b1 := Button label:'none yet ' in:panel.
          b1 labelChannel:labelHolder.
          b1 action:[Transcript showCR:'pressed'].
          b1 sizeFixed:true.

          b2 := Button label:'press for bar' in:panel.
          b2 action:[ labelHolder value:'bar' ].

          b3 := Button label:'press for foo' in:panel.
          b3 action:[ labelHolder value:'foo' ].

          top open.
                                                                        [exEnd]

    the same, using a labelChannel:
                                                                        [exBegin]
          |b|
          b := Button new.
          b label:'hello'.
          b renderer:(ButtonRenderer new).
          b open.
                                                                        [exEnd]


    see 'doc/coding-examples' and 'doc/misc/quick_view_intro.doc' 
    for more variations on this theme.
"
! !

!Button class methodsFor:'instance creation'!

abortButton
    "since abort-buttons are very common, here is a convenient
     method to create one ..."

    |aButton|

    aButton := self label:(self classResources string:'Cancel').
    aButton name: 'abortButton'.
    aButton cursor:(Cursor thumbsDown).
    ^ aButton

    "Modified: 20.2.1996 / 20:20:16 / cg"
!

abortButtonIn:aView
    "since abort-buttons are very common, here is a convenient
     method to create one ..."

    |b|

    aView addSubView:(b := self abortButton). 
    ^ b
!

form:aForm action:aBlock in:aView
    "create and return a new Button with icon-label, aForm
     and pressAction, aBlock.  Button is placed into aView.
     OBSOLETE: this is for backward compatibility; 
     you can now pass an image or form in the #label:action:in: message."

    <resource:#obsolete>

    ^ ((self in:aView) form:aForm) action:aBlock
!

label:aLabel action:aBlock
    "create and return a new Button with text-label, aString
     and pressAction, aBlock."

    ^ (self label:aLabel) action:aBlock
!

label:aLabel action:aBlock in:aView
    "create and return a new Button with text-label, aString
     and pressAction, aBlock.  Button is placed into aView."

    ^ ((self in:aView) label:aLabel) action:aBlock
!

okButton
    "since ok-buttons are very common, here is a convenient
     method to create one ..."

    |aButton|

    aButton := self label:(self classResources string:'OK').
    aButton name: 'okButton'.
    aButton cursor:(Cursor thumbsUp).
    aButton beReturnButton.
    ^ aButton
!

okButtonIn:aView
    "since ok-buttons are very common, here is a convenient
     method to create one ..."

    |b|

    aView addSubView:(b := self okButton).
    ^ b
! !

!Button class methodsFor:'ST-80 instance creation'!

switch
    "ST-80 compatibility: create & return a new radioButton"

    ^ RadioButton new.

    "Created: 18.4.1997 / 20:19:09 / cg"
    "Modified: 18.4.1997 / 20:28:10 / cg"
!

toggle
    "ST-80 compatibility: create & return a new toggle."

    ^ Toggle new

    "
     Button toggle label:'press me';
		   model:((PluggableAdaptor on:(Point new))
			    getSelector:#x putSelector:#x:)
    "
    "this is the same as"
    "
     Toggle new label:'press me';
		model:((PluggableAdaptor on:(Point new))
			    getSelector:#x putSelector:#x:)
    "
!

trigger
    "ST-80 compatibility: create & return a new button, which
     triggers on press."

    |b|

    b := self new.
    b controller beTriggerOnDown.
    ^ b

    "Created: 18.4.1997 / 19:55:57 / cg"
    "Modified: 18.4.1997 / 19:56:52 / cg"
! !

!Button class methodsFor:'defaults'!

defaultDisabledForegroundColor
    ^  DefaultDisabledForegroundColor

    "Created: / 20.6.1998 / 15:18:28 / cg"
!

returnFormOn:aDevice
    "return the form used for the return arrow in non-3D;
     cache the one for Display for the next round."

    |f|

    ReturnForm notNil ifTrue:[
        ^ ReturnForm onDevice:aDevice.
    ] ifFalse:[
        f := Form width:24 height:14 fromArray:#[2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000011 2r11100000
                                                 2r00000001 2r10000011 2r11100000
                                                 2r00000011 2r10000011 2r11100000
                                                 2r00000111 2r11111111 2r11100000
                                                 2r00001111 2r11111111 2r11100000
                                                 2r00011111 2r11111111 2r11100000
                                                 2r00001111 2r11111111 2r11100000
                                                 2r00000111 2r11111111 2r11100000
                                                 2r00000011 2r10000000 2r00000000
                                                 2r00000001 2r10000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000]
                                              onDevice:aDevice.
        aDevice == Display ifTrue:[
            ReturnForm := f.
        ].
        ^ f.
    ]. 

    "Modified: / 3.11.1997 / 09:12:37 / cg"
!

returnLightFormOn:aDevice
    "return the form used for the return arrow light pixels (3D only);
     cache the one for Display for the next round"


    |f|

    ReturnLightForm notNil ifTrue:[
        ^ ReturnLightForm onDevice:aDevice.    
    ] ifFalse:[
        f := Form width:24 height:14 fromArray:#[2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r00000000 2r00100000
                                                 2r00000000 2r11111111 2r11100000
                                                 2r00000000 2r10000000 2r00000000
                                                 2r00000000 2r10000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000]
                                              onDevice:aDevice.
        aDevice == Display ifTrue:[
            ReturnLightForm := f.
        ].
        ^ f.
    ].

    "Modified: / 3.11.1997 / 09:12:23 / cg"
!

returnShadowFormOn:aDevice
    "return the form used for the return arrow shadow pixels (3D only);
     cache the one for Display for the next round."

    |f|

    ReturnShadowForm notNil ifTrue:[
        ^ ReturnShadowForm onDevice:aDevice.    
    ] ifFalse:[
        f := Form width:24 height:14 fromArray:#[2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000011 2r11100000
                                                 2r00000001 2r10000010 2r00000000
                                                 2r00000010 2r10000010 2r00000000
                                                 2r00000100 2r11111110 2r00000000
                                                 2r00001000 2r00000000 2r00000000
                                                 2r00010000 2r00000000 2r00000000
                                                 2r00001000 2r00000000 2r00000000
                                                 2r00000100 2r00000000 2r00000000
                                                 2r00000010 2r00000000 2r00000000
                                                 2r00000001 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000
                                                 2r00000000 2r00000000 2r00000000]
                                              onDevice:aDevice.
        aDevice == Display ifTrue:[
            ReturnShadowForm := f.
        ].
        ^ f.
    ].


    "Modified: / 3.11.1997 / 09:12:11 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'button.edgeStyle' #'button.font' #'button.borderWidth'
                       #'button.activeLevel' #'button.passiveLevel'
                       #'button.backgroundColor' #'button.foregroundColor'
                       #'button.activeBackgroundColor' #'button.activeForegroundColor'
                       #'button.enteredBackgroundColor' #'button.enteredForegroundColor'
                       #'button.disabledForegroundColor' #'button.disabledBackgroundColor'
                       #'button.disabledEtchedForegroundColor' 
                       #'button.returnButtonHasImage'
                       #'button.returnButtonHasBorder' 
                       #'button.shadowColor' #'button.lightColor'
                       #'button.halfShadowColor' #'button.halfLightColor'
                       #'focusHighlightStyle')>

    |defaultLevel|

    StyleSheet is3D ifTrue:[
        defaultLevel := 1.
    ] ifFalse:[
        defaultLevel := 0
    ].
    DefaultActiveLevel := StyleSheet at:#'button.activeLevel' default:(defaultLevel negated).
    DefaultPassiveLevel := StyleSheet at:#'button.passiveLevel' default:defaultLevel.

    DefaultEdgeStyle := StyleSheet at:#'button.edgeStyle'.
    DefaultFont := StyleSheet fontAt:#'button.font'.
    DefaultBorderWidth := StyleSheet at:#'button.borderWidth'.
    DefaultForegroundColor := StyleSheet colorAt:#'button.foregroundColor'.
    DefaultBackgroundColor := StyleSheet colorAt:#'button.backgroundColor'.
    DefaultDisabledForegroundColor := StyleSheet colorAt:#'button.disabledForegroundColor' default:Color gray.
    DefaultDisabledBackgroundColor := StyleSheet colorAt:#'button.disabledBackgroundColor'.
    DefaultDisabledEtchedForegroundColor := StyleSheet colorAt:#'button.disabledEtchedForegroundColor'.
    DefaultEnteredForegroundColor := StyleSheet colorAt:#'button.enteredForegroundColor'.
    DefaultEnteredBackgroundColor := StyleSheet colorAt:#'button.enteredBackgroundColor'.
    DefaultActiveForegroundColor := StyleSheet colorAt:#'button.activeForegroundColor'.
    DefaultActiveBackgroundColor := StyleSheet colorAt:#'button.activeBackgroundColor'.
    DefaultReturnButtonHasImage := StyleSheet at:#'button.returnButtonHasImage' default:true.
    DefaultReturnButtonHasBorder := StyleSheet at:#'button.returnButtonHasBorder' default:false.
    DefaultShadowColor := StyleSheet colorAt:#'button.shadowColor'.
    DefaultLightColor := StyleSheet colorAt:#'button.lightColor'.
    DefaultHalfShadowColor := StyleSheet colorAt:#'button.halfShadowColor'.
    DefaultHalfLightColor := StyleSheet colorAt:#'button.halfLightColor'.
    DefaultFocusHighlightStyle := StyleSheet at:#'focusHighlightStyle'.

    "Modified: 20.10.1997 / 13:49:41 / cg"
! !

!Button methodsFor:'accessing-behavior'!

action:aBlock
    "convenient method: depending on the setting of controllers triggerOnDown flag,
     either set the press-action and clear any release-action or
     vice versa, set the release-action and clear the press-action."

    controller isNil ifTrue:[
        'Button [error]: no controller in #action' errorPrintCR.
    ] ifFalse:[
        controller action:aBlock
    ].
!

autoRepeat
    "turn on autorepeat OBSOLETE; use #autoRepeat:"

    <resource:#obsolete>

    controller autoRepeat

    "Modified: 9.2.1996 / 22:42:37 / cg"
!

autoRepeat:aBoolean
    "turn on/off autorepeat"

    controller autoRepeat:aBoolean

    "Modified: 5.9.1995 / 22:06:13 / claus"
!

doubleClickAction
    "return the doubleClickAction; that's the block which gets evaluated
     when the button is double-clicked (if non-nil).
     Seldom used with buttons"

    ^ controller doubleClickAction
!

doubleClickAction:aBlock
    "define the action to be performed on doubleClick
     Seldom used with buttons."

    controller notNil ifTrue:[
        controller doubleClickAction:aBlock
    ]
!

enabled
    "return true if the button is enabled"

    ^ controller notNil and:[controller enabled]

    "Created: 17.12.1995 / 16:12:26 / cg"
!

enabled:aBoolean
    "enable/disable the button"

    controller notNil ifTrue:[
        controller enabled:aBoolean
    ]

    "Created: / 30.3.1999 / 14:50:58 / stefan"
!

pressAction
    "return the pressAction; that's the block which gets evaluated
     when the button is pressed (if non-nil)"

    ^ controller pressAction
!

pressAction:aBlock
    "define the action to be performed on press"

    controller notNil ifTrue:[
        controller pressAction:aBlock
    ]
!

releaseAction
    "return the releaseAction; that's the block which gets evaluated
     when the button is released (if non-nil)"

    ^ controller releaseAction
!

releaseAction:aBlock
    "define the action to be performed on release"

    controller notNil ifTrue:[
        controller releaseAction:aBlock
    ]
! !

!Button methodsFor:'accessing-channels'!

enableChannel
    "return a valueHolder for enable/disable"

    controller isNil ifTrue:[^ nil].
    ^ controller enableChannel

    "Modified: / 13.8.1998 / 12:04:46 / cg"
!

enableChannel:aValueHolderForBoolean
    "set the valueHolder used for enable/disable"

    controller enableChannel:aValueHolderForBoolean
!

pressChannel
    "return the pressChannel"

    controller isNil ifTrue:[^ nil].
    ^ controller pressChannel

    "Modified: / 7.9.1995 / 18:16:20 / claus"
    "Modified: / 13.8.1998 / 12:04:51 / cg"
!

pressChannel:aBlock
    "set the pressChannel"

    controller pressChannel:aBlock

    "Modified: 7.9.1995 / 18:05:14 / claus"
!

releaseChannel
    "return the releaseChannel"

    controller isNil ifTrue:[^ nil].
    ^ controller releaseChannel

    "Modified: / 7.9.1995 / 18:15:24 / claus"
    "Modified: / 13.8.1998 / 12:04:55 / cg"
!

releaseChannel:aBlock
    "set the releaseChannel"

    controller releaseChannel:aBlock

    "Modified: 7.9.1995 / 18:05:21 / claus"
! !

!Button methodsFor:'accessing-look'!

activeBackgroundColor
    "return the background color to be used when pressed"

    ^ activeBgColor
!

activeBackgroundColor:aColor
    "set the background color to be used when pressed"

    activeBgColor := aColor.
    self redrawIfPressed
!

activeForegroundColor
    "return the foreground color to be used when pressed"

    ^ activeFgColor
!

activeForegroundColor:aColor
    "set the foreground color to be used when pressed"

    activeFgColor := aColor.
    self redrawIfPressed
!

activeForegroundColor:fgColor backgroundColor:bgColor
    "set both fg and bg colors to be used when pressed"

    activeFgColor := fgColor.
    activeBgColor := bgColor.
    self redrawIfPressed
!

activeLevel
    "return the level of the button when pressed"

    ^ onLevel
!

activeLevel:aNumber
    "set the level of the button when pressed (i.e. how deep)"

    onLevel ~~ aNumber ifTrue:[
        (styleSheet at:'button.ignoreLevel' default:false) ifFalse:[
            onLevel := aNumber.
            (controller notNil
            and:[controller pressed]) ifTrue:[
                self level:onLevel.
                margin := onLevel abs max:offLevel abs.
                self invalidate. 
            ]
        ]
    ].

    "Modified: / 30.7.1998 / 22:29:01 / cg"
!

activeLogo:anImageOrString
    "define the logo to be displayed while active -
     this is optional; the default is to display the same
     (logo) in both pressed and released states."

    activeLogo := anImageOrString.
    controller pressed ifTrue:[
        self label:anImageOrString
    ]
!

allViewBackground:something if:condition
    "ignore here"
!

beImageButton
    "make mySelf an image button - that is turn off all levelChanges
     and logo spacing. This should be sent for buttons which use both
     passive and active logos, and the 3D effect comes from the bitmaps
     (i.e. windows buttons)."

    self 
        extent:(labelWidth @ labelHeight);
        sizeFixed:true; 
        borderWidth:0;
        activeLevel:0; 
        passiveLevel:0; 
        horizontalSpace:0; 
        verticalSpace:0;
        newLayout.

    "Created: 17.9.1995 / 20:41:47 / claus"
    "Modified: 19.9.1995 / 16:34:08 / claus"
    "Modified: 28.5.1996 / 22:04:14 / cg"
!

beReturnButton
    "show show a return-key image after the label.
     Same as 'isReturnButton:true' for ST-80 compatibility."

    self isReturnButton:true
!

beRoundRadioButton
    "setup myself for a round radioButton look.
     this is a private method; do not use it. It is going to move into the
     RadioButton class."

    self activeLogo:(Icon constantNamed:'RadioOn').
    self passiveLogo:(Icon constantNamed:'RadioOff').
    self activeLevel:0; 
	 passiveLevel:0; 
	 activeBackgroundColor:bgColor;
	 activeForegroundColor:fgColor;
	 borderWidth:0;
	 enteredBackgroundColor:bgColor.
    self computeLabelSize.
    self beImageButton.

    "Created: 22.9.1995 / 15:48:05 / claus"
    "Modified: 22.9.1995 / 17:07:46 / claus"
!

defaultable
    "return true, if the receiver is defaultable"

    ^ defaultable
!

defaultable:aBoolean
    "set/clear the defaultable attribute. If defaultable,
     the preferredExtent is computed to include any additional
     space required when the receiver is a returnButton."

    defaultable ~~ aBoolean ifTrue:[
	defaultable := aBoolean.
	self newLayout
    ]
!

disabledForegroundColor
    "return the foreground color used when the button is disabled"

    ^ disabledFgColor
!

disabledForegroundColor:aColor
    "set the foreground color used when the button is disabled"

    disabledFgColor := aColor
!

disabledLogo:anImageOrString
    "define the logo to be displayed while disabled -
     this is optional; the default is to display the same
     (logo) in both pressed and released states.
     However, the disabled logo is ignored if a labelChannel has
     been set - then that value has priority."

    disabledLogo := anImageOrString.
    labelChannel isNil ifTrue:[
        self enabled ifFalse:[
            self label:anImageOrString
        ]
    ]

    "Created: 17.9.1995 / 19:50:17 / claus"
    "Modified: 17.9.1995 / 19:50:34 / claus"
!

edgeStyle:aSymbol
    "set the edgestyle - currently only #soft or nil"

    edgeStyle := aSymbol
!

enterLevel
    "return the level to be used when the mouse
     pointer enters the button area"

    ^ enterLevel

    "Created: 26.4.1997 / 20:48:53 / cg"
    "Modified: 26.4.1997 / 20:49:29 / cg"
!

enterLevel:aNumber
    "set the level to be used when the mouse
     pointer enters the button area"

    enterLevel := aNumber

    "Created: 26.4.1997 / 20:49:10 / cg"
    "Modified: 26.4.1997 / 20:49:35 / cg"
!

enteredBackgroundColor
    "return the background color to be used when the mouse
     pointer enters the button area"

    ^ enteredBgColor
!

enteredBackgroundColor:aColor
    "set the background color to be used when the mouse
     pointer enters the button area"

    enteredBgColor := aColor
!

enteredForegroundColor
    "return the foreground color to be used when the mouse
     pointer enters the button area"

    ^ enteredFgColor
!

enteredForegroundColor:aColor
    "set the foreground color to be used when the mouse
     pointer enters the button area"

    enteredFgColor := aColor
!

enteredLogo:anImageOrString
    "define the logo to be displayed while the mousePointer is in the button -
     this is optional; the default is to display the same
     (logo) in both entered and normal states.
     However, the entered logo is ignored if a labelChannel has
     been set - then that value has priority."

    enteredLogo := anImageOrString.
    labelChannel isNil ifTrue:[
        controller entered ifTrue:[
            self label:anImageOrString
        ]
    ]
!

focusLogo:anImageOrString
    "define the logo to be displayed while active -
     this is optional; the default is to display the same
     (logo) in both pressed and released states.
     However, the focus logo is ignored if a labelChannel has
     been set - then that value has priority."

    focusLogo := anImageOrString.

    "Created: 17.9.1995 / 19:50:17 / claus"
    "Modified: 17.9.1995 / 20:00:43 / claus"
!

isReturnButton:aBoolean
    "show/don't show a return-key image after the label"

    isReturnButton ~~ aBoolean ifTrue:[
        DefaultReturnButtonHasBorder ifTrue:[
            self borderWidth:(aBoolean ifTrue:[1] ifFalse:[0])
        ].
        isReturnButton := aBoolean.
        self newLayout
    ]
!

label:aStringOrImageOrForm
    |xlatedLabel|

    xlatedLabel := self defineShortcutAndTranslateLabelStringFrom:aStringOrImageOrForm.
    super label:xlatedLabel.
!

leaveLevel
    "return the level to be used when the mouse
     pointer leaves the button area"

    ^ leaveLevel

    "Created: 26.4.1997 / 20:48:26 / cg"
    "Modified: 26.4.1997 / 20:49:47 / cg"
!

leaveLevel:aNumber
    "set the level to be used when the mouse
     pointer leaves the button area"

    leaveLevel := aNumber

    "Created: 26.4.1997 / 20:49:22 / cg"
    "Modified: 26.4.1997 / 20:49:53 / cg"
!

loseDefault
    "ST-80 compatibility - clear isReturnButton attribute"

    self isReturnButton:false

    "Created: 3.3.1997 / 16:20:47 / cg"
    "Modified: 3.3.1997 / 18:12:06 / cg"
!

offLevel
    <resource: #obsolete>
    "return the level of the button when released.
     Historic leftover; use #passiveLevel."

    ^ offLevel
!

offLevel:aNumber
    <resource: #obsolete>
    "set the level of the button when released (i.e. how deep).
     Historic leftover; use #passiveLevel:."

    ^ self passiveLevel:aNumber
!

onLevel
    <resource: #obsolete>
    "return the level of the button when pressed.
     Historic leftover; use #activeLevel."

    ^ onLevel
!

onLevel:aNumber
    <resource: #obsolete>
    "set the level of the button when pressed (i.e. how deep).
     Historic leftover; use #activeLevel:."

    ^ self activeLevel:aNumber
!

passiveLevel
    "return the level of the button when released"

    ^ offLevel
!

passiveLevel:aNumber
    "set the level of the button when not pressed (i.e. how high)"

    offLevel ~~ aNumber ifTrue:[
        (styleSheet at:'button.ignoreLevel' default:false) ifFalse:[
            offLevel := aNumber.
            (controller notNil
            and:[controller pressed not]) ifTrue:[
                self level:offLevel.
                margin := onLevel abs max:offLevel abs.
                self invalidate.
            ]
        ]
    ]

    "Modified: / 30.7.1998 / 22:29:17 / cg"
!

passiveLogo:anImageOrString
    "define the logo to be displayed while inactive -
     this is optional; the default is to display the same
     (logo) in both pressed and released states.
     However, the inactive logo is ignored if a labelChannel has
     been set - then that value has priority."

    passiveLogo := anImageOrString.
    labelChannel isNil ifTrue:[
        controller pressed ifFalse:[
            self label:anImageOrString
        ]
    ]
!

takeDefault
    "ST-80 compatibility - set isReturnButton attribute"

    self isReturnButton:true

    "Created: 3.3.1997 / 16:20:52 / cg"
    "Modified: 3.3.1997 / 18:11:58 / cg"
!

viewBackground:something
    super viewBackground:something.
    something isColor ifTrue:[
        device hasGrayscales ifTrue:[
            halfLightColor notNil ifTrue:[
                halfLightColor := (something averageColorIn:(0@0 corner:7@7)) lightened "on:device".
            ].
            halfShadowColor notNil ifTrue:[
                halfShadowColor := (something averageColorIn:(0@0 corner:7@7)) darkened "on:device".
            ]
        ]
    ].

    "Modified: 3.5.1997 / 10:37:24 / cg"
! !

!Button methodsFor:'changing state'!

toggle
    "toggle and perform the action"

    controller toggle
!

toggleNoAction
    "toggle, but do NOT perform any action - can be used to change a toggle
     under program control (i.e. turn one toggle off from another one)"

    controller toggleNoAction
!

turnOff
    "turn the button off (if not already off) do NOT perform actions/change notifications"

    (controller notNil and:[controller pressed]) ifTrue:[
        offLevel ~~ level ifTrue:[
            self level:offLevel.
        ].
        (passiveLogo notNil and:[passiveLogo ~~ logo]) ifTrue:[
            self label:passiveLogo
        ].
        controller setPressed:false.
        controller active:false.
        level := offLevel.
        margin := level abs.
        self invalidate
    ]

    "Modified: 8.2.1997 / 15:21:44 / cg"
!

turnOffWithAction
    "turn the button off (if not already off) and perform any action/change notification"

    (controller notNil and:[controller pressed]) ifTrue:[
        offLevel ~~ level ifTrue:[
            self level:offLevel.
        ].
        (passiveLogo notNil and:[passiveLogo ~~ logo]) ifTrue:[
            self label:passiveLogo
        ].
        self turnOffWithoutRedraw.
        self invalidate
    ]

    "Created: 15.11.1995 / 16:55:37 / cg"
    "Modified: 8.2.1997 / 15:21:53 / cg"
!

turnOffWithoutRedraw
    "turn the button off - no redraw but perform any action/change notification"

    controller notNil ifTrue:[
        controller pressed:false.
        controller active:false.
    ].

    "do not use super level:offLevel
     - because that one does redraw the edges.
     Sure, this is no good coding style"

    level := offLevel.
    margin := level abs

    "Modified: 8.2.1996 / 15:28:53 / cg"
!

turnOn
    "turn the button on (if not already on) - do NOT perform any action/notification"

    (controller notNil and:[controller pressed not]) ifTrue:[
        onLevel ~~ level ifTrue:[
            self level:onLevel.
        ].
        (activeLogo notNil and:[activeLogo ~~ logo]) ifTrue:[
            self label:activeLogo
        ].
        controller setPressed:true.
        level := onLevel.
        margin := level abs.

        self invalidate
    ]

    "Created: 14.11.1995 / 22:00:45 / cg"
    "Modified: 8.2.1997 / 15:22:01 / cg"
!

turnOnWithAction
    "turn the button on (if not already on) and perform any change actions/notifications"

    (controller notNil and:[controller pressed not]) ifTrue:[
        onLevel ~~ level ifTrue:[
            self level:onLevel.
        ].
        (activeLogo notNil and:[activeLogo ~~ logo]) ifTrue:[
            self label:activeLogo
        ].
        self turnOnWithoutRedraw.
        self invalidate
    ]

    "Created: 15.11.1995 / 16:55:56 / cg"
    "Modified: 8.2.1997 / 15:22:09 / cg"
!

turnOnWithoutRedraw
    "turn the button on - no redraw but perform any change actions/notifications"

    controller notNil ifTrue:[
        controller pressed:true.
    ].

    "do not use super level:offLevel
     - because that one does redraw the edges.
     Sure, this is no good coding style"

    level := onLevel.
    margin := level abs

    "Modified: 8.2.1996 / 15:29:23 / cg"
! !

!Button methodsFor:'focus handling'!

showFocus:explicit
    "the button got the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    focusLogo notNil ifTrue:[
        self enabled ifTrue:[
            logo := focusLogo.  
            self invalidate.
            ^ self.
        ]
    ].
    (styleSheet at:#'focus.showBorder' default:true) ifFalse:[
        self invalidate.
        ^ self.
    ].
    super showFocus:explicit

    "Created: / 17.9.1995 / 19:58:50 / claus"
    "Modified: / 19.11.1998 / 13:02:48 / cg"
!

showNoFocus:explicit
    "the button lost the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    focusLogo notNil ifTrue:[
        disabledLogo notNil ifTrue:[
            self enabled ifTrue:[
                logo := passiveLogo.  
            ] ifFalse:[
                logo := disabledLogo.  
            ].
        ] ifFalse:[
            logo := passiveLogo
        ].
        self invalidate.
        ^ self
    ].
    (styleSheet at:#'focus.showBorder' default:true) ifFalse:[
        self invalidate.
        ^ self
    ].
    super showNoFocus:explicit

    "Created: / 17.9.1995 / 20:00:06 / claus"
    "Modified: / 17.9.1995 / 20:26:32 / claus"
    "Modified: / 19.11.1998 / 13:02:44 / cg"
!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false

    "Created: / 28-03-2012 / 09:45:59 / cg"
! !

!Button methodsFor:'initialization'!

defaultControllerClass
    ^ ButtonController
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    |graphicsDevice|

    super fetchDeviceResources.
    graphicsDevice := device.

    disabledFgColor notNil ifTrue:[disabledFgColor := disabledFgColor onDevice:graphicsDevice].
    disabledEtchedFgColor notNil ifTrue:[disabledEtchedFgColor := disabledEtchedFgColor onDevice:graphicsDevice].
    activeFgColor notNil ifTrue:[activeFgColor := activeFgColor onDevice:graphicsDevice].
    activeBgColor notNil ifTrue:[activeBgColor := activeBgColor onDevice:graphicsDevice].
    enteredFgColor notNil ifTrue:[enteredFgColor := enteredFgColor onDevice:graphicsDevice].
    enteredBgColor notNil ifTrue:[enteredBgColor := enteredBgColor onDevice:graphicsDevice].

    formColor notNil ifTrue:[formColor := formColor onDevice:graphicsDevice].
    formLightColor notNil ifTrue:[formLightColor := formLightColor onDevice:graphicsDevice].
    formShadowColor notNil ifTrue:[formShadowColor := formShadowColor onDevice:graphicsDevice].
    halfShadowColor notNil ifTrue:[halfShadowColor := halfShadowColor onDevice:graphicsDevice].
    halfLightColor notNil ifTrue:[halfLightColor := halfLightColor onDevice:graphicsDevice].

    "Modified: 15.2.1997 / 17:14:16 / cg"
!

initBorderStyle
    DefaultBorderWidth notNil ifTrue:[ self borderWidth: DefaultBorderWidth].
!

initCursor
    "set up a hand cursor"

    cursor := Cursor hand
!

initEvents
    super initEvents.
    self enableEnterLeaveEvents
!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#name #'button.style')>

    |hasGreyscales nm graphicsDevice buttonStyle borderStyle|

    super initStyle.
    graphicsDevice := device.

    DefaultBorderWidth notNil ifTrue:[ self borderWidth: DefaultBorderWidth].
    DefaultForegroundColor notNil ifTrue:[fgColor := DefaultForegroundColor].
    DefaultBackgroundColor notNil ifTrue:[bgColor := DefaultBackgroundColor].

    edgeStyle := DefaultEdgeStyle.
    onLevel := DefaultActiveLevel.
    offLevel := DefaultPassiveLevel.

    DefaultDisabledForegroundColor notNil ifTrue:[
        disabledFgColor := DefaultDisabledForegroundColor
    ] ifFalse:[
        disabledFgColor := fgColor
    ].
    disabledEtchedFgColor := DefaultDisabledEtchedForegroundColor.

    DefaultEnteredForegroundColor notNil ifTrue:[enteredFgColor := DefaultEnteredForegroundColor].
    DefaultEnteredBackgroundColor notNil ifTrue:[enteredBgColor := DefaultEnteredBackgroundColor].
    DefaultActiveForegroundColor notNil ifTrue:[activeFgColor := DefaultActiveForegroundColor].
    DefaultActiveBackgroundColor notNil ifTrue:[activeBgColor := DefaultActiveBackgroundColor].

    DefaultShadowColor notNil ifTrue:[shadowColor := DefaultShadowColor].
    DefaultLightColor notNil ifTrue:[lightColor := DefaultLightColor].

    shadowColor isNil ifTrue:[
        shadowColor := self blackColor.
    ].
    lightColor isNil ifTrue:[
        lightColor := self whiteColor.
    ].

    hasGreyscales := graphicsDevice hasGrayscales.
    (edgeStyle == #soft or:[edgeStyle == #softWin95]) ifTrue:[
        DefaultHalfShadowColor notNil ifTrue:[halfShadowColor := DefaultHalfShadowColor].
        DefaultHalfLightColor notNil ifTrue:[halfLightColor := DefaultHalfLightColor].

        halfShadowColor isNil ifTrue:[
"/            hasGreyscales ifTrue:[
"/                halfShadowColor := Color darkGrey
"/            ] ifFalse:[
"/                halfShadowColor := shadowColor
"/            ]
            halfShadowColor := shadowColor lightened
        ]
    ].

    "
     actually, the stuf below should not be needed
     - the styleSheet should provide values for nonGreyscale displays too
    "
    nm := styleSheet name.
    (nm == #iris) ifTrue:[
        hasGreyscales ifTrue:[
            DefaultEnteredBackgroundColor isNil ifTrue:[
                enteredBgColor := bgColor lightened "Color lightGray".
            ].
            DefaultActiveBackgroundColor isNil ifTrue:[
                activeBgColor := enteredBgColor.
            ].
            DefaultActiveForegroundColor isNil ifTrue:[
                activeFgColor := enteredFgColor.
            ].
        ] ifFalse:[
            DefaultEnteredBackgroundColor isNil ifTrue:[
                enteredBgColor := Color veryLightGray.
            ].
            DefaultActiveBackgroundColor isNil ifTrue:[
                activeBgColor := self blackColor.
            ].
            DefaultActiveForegroundColor isNil ifTrue:[
                activeFgColor := self whiteColor.
            ].
        ].
    ] ifFalse:[
        nm == #motif ifTrue:[
            lightColor isNil ifTrue:[
                lightColor := bgColor lightened
            ].
"/            hasGreyscales ifTrue:[
"/                lightColor := Color lightGrey
"/            ]
        ] ifFalse:[
            nm == #st80 ifTrue:[
                hasGreyscales ifTrue:[
                    DefaultActiveForegroundColor isNil ifTrue:[
                        activeFgColor := fgColor.
                    ].
                    DefaultActiveBackgroundColor isNil ifTrue:[
                        activeBgColor := bgColor darkened.
                    ].
                ] ifFalse:[
                    DefaultActiveForegroundColor isNil ifTrue:[
                        activeFgColor := self whiteColor.
                    ].
                    DefaultActiveBackgroundColor isNil ifTrue:[
                        activeBgColor := self blackColor
                    ]
                ]
            ]
        ]
    ].

    offLevel ~~ level ifTrue:[
        self level:offLevel.
        margin := (onLevel abs) max:(offLevel abs).
    ].

    DefaultReturnButtonHasImage ifTrue:[
        (hasGreyscales and:[styleSheet is3D]) ifTrue:[
            shadowForm := self class returnShadowFormOn:graphicsDevice.
            lightForm := self class returnLightFormOn:graphicsDevice.
            formColor := viewBackground.
            formShadowColor := shadowColor.
            formLightColor := lightColor
        ] ifFalse:[
            shadowForm := self class returnFormOn:graphicsDevice.
            formColor := self blackColor
        ].
    ].

    buttonStyle := styleSheet at:'button.style' default:nil.
    ((self class == Button) and:[ buttonStyle == #MacOSX ]) ifTrue:[
        borderStyle := styleSheet at:'button.borderStyle'.
        self border:( (Smalltalk at:borderStyle asSymbol) color:self blackColor).
        self viewBackground:(View defaultViewBackgroundColor).
    ].

"/ unfinished...
"/    nm = #winVista ifTrue:[
"/        self border:(RoundButtonBorder width:2 color:Color grey).
"/    ].

    "Modified: / 20-08-1998 / 12:07:37 / cg"
    "Modified (comment): / 05-10-2011 / 15:51:19 / az"
!

initialize
    super initialize.

    isReturnButton := defaultable := false.
!

reinitialize
    super reinitialize.
    controller notNil ifTrue:[
        controller reinitialize.
    ]
! !

!Button methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    self class == Button ifTrue:[
        ^ #Button
    ].
    ^ nil
!

win32nativeWMCommand:commandID
    self controller performAction
! !

!Button methodsFor:'private'!

computeLabelOrigin
    "compute the origin of the text - if  I am a returnButton,
     shift it somwehat to the right (we have already allocated the
     real estate, since computeLabelSize returned some extra space
     before)."

    super computeLabelOrigin.
    shadowForm notNil ifTrue:[
        isReturnButton ifTrue:[
            labelOriginX := labelOriginX + hSpace + hSpace.
        ].

        defaultable ifTrue:[
            labelOriginX < margin ifTrue:[
                labelOriginX := margin
            ]
        ]
    ].
"/    self class == Button ifTrue:[
"/        labelOriginY := labelOriginY + 1.
"/        labelOriginX := labelOriginX + 1.
"/    ]

    "Modified: / 9.9.1998 / 20:22:01 / cg"
!

getLabelFromLabelChannel
    passiveLogo := labelChannel value.
    super getLabelFromLabelChannel.
!

rawLabelSizeOf:aLogo
    "compute the extent needed to hold the label (plus the return form)"

    |ext|

    ext := super rawLabelSizeOf:aLogo.

    (activeLogo notNil and:[activeLogo ~~ logo]) ifTrue:[
        ext := ext max:(super rawLabelSizeOf:activeLogo).
    ].
    (passiveLogo notNil and:[passiveLogo ~~ logo]) ifTrue:[
        ext := ext max:(super rawLabelSizeOf:passiveLogo).
    ].

    ((isReturnButton or:[defaultable]) and:[shadowForm notNil]) ifTrue:[
        ^ (ext x + (hSpace * 2) + shadowForm width)
          @
          (ext y max: (shadowForm height "+ vSpace"))
    ].
    ^ ext

    "Modified: / 3.11.1997 / 09:15:52 / cg"
!

shiftLabelWhenPressed
    ^ self class == Button
! !

!Button methodsFor:'queries'!

extraMarginForBorder
    (self class == Button
    and:[ (styleSheet at:'button.style' default:nil) == #'MacOSX' ]) ifTrue:[
        ^ 4
    ].    
    ^ 0
!

is3D
    "return true, if the receiver is a 3D style view"

    <resource: #style (#name)>

    styleSheet name == #mswindows ifTrue:[^ true].
    styleSheet name == #win8 ifTrue:[^ false].
    ^ super is3D

    "Modified: 22.10.1996 / 18:26:41 / cg"
!

isDefault
    "return true, if this is a default OK button"

    ^ isReturnButton
!

isOn
    "return true, if this button is currently pressed"

    ^ controller notNil and:[controller pressed]
!

isReturnButton
    "return true, if this is a return button"

    ^ isReturnButton
!

isTriggerOnDown
    "return true, if I fire on press (instead of fire-on-release)"
        
    ^ controller notNil and:[controller isTriggerOnDown]

    "Created: / 31.10.1997 / 19:33:56 / cg"
    "Modified: / 31.10.1997 / 19:34:34 / cg"
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not ButtonSpec)"

    self class == Button ifTrue:[^ ActionButtonSpec].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:49:07 / cg"
! !

!Button methodsFor:'redrawing'!

drawBottomEdge
    "draw bottom 3D edge into window frame"

    self drawBottomEdgeLevel:level
		      shadow:shadowColor 
		      light:lightColor
		      halfShadow:halfShadowColor 
		      halfLight:halfLightColor
		      style:edgeStyle.
!

drawEdges
    "draw all of my 3D edges"

    self drawEdgesForX:0 y:0 width:width height:height level:level 
		shadow:shadowColor 
		light:lightColor
		halfShadow:halfShadowColor 
		halfLight:halfLightColor
		style:edgeStyle 
!

drawLeftEdge
    "draw left 3D edge into window frame"

    self drawLeftEdgeLevel:level
		    shadow:shadowColor 
		     light:lightColor
		     halfShadow:halfShadowColor 
		     halfLight:halfLightColor
		     style:edgeStyle.
!

drawRightEdge
    "draw right 3D edge into window frame"

    self drawRightEdgeLevel:level
		     shadow:shadowColor 
		      light:lightColor
		      halfShadow:halfShadowColor 
		      halfLight:halfLightColor
		      style:edgeStyle.
!

drawTopEdge
    "draw top 3D edge into window frame"

    self drawTopEdgeLevel:level
		   shadow:shadowColor 
		   light:lightColor
		   halfShadow:halfShadowColor 
		   halfLight:halfLightColor
		   style:edgeStyle.
!

drawWith:fg and:bg
    "redraw myself with fg/bg. Use super to draw the label, add
     the return-arrow here."

    |x y sColor lColor etchFg shownLogo isEnabled isActive isEntered clearInside showBorder|

    shown ifFalse:[^ self].

    isEnabled := self enabled.
    isActive := (controller active or:[controller pressed]).
    isEntered := (controller entered or:[controller pressed]).
    
    isEnabled ifFalse:[
        etchFg := disabledEtchedFgColor.
    ].

    isActive ifTrue:[
        shownLogo := activeLogo ? enteredLogo ? passiveLogo ? logo. 
    ] ifFalse:[
        shownLogo := passiveLogo ? logo.
        (enteredLogo notNil and:[controller entered]) ifTrue:[
            shownLogo := enteredLogo.
        ].
    ].
    (disabledLogo notNil and:[isEnabled not]) ifTrue:[
        shownLogo := disabledLogo.
    ].
    shownLogo ~= logo ifTrue:[
        self label:shownLogo redraw:false.
        logo := shownLogo.
    ].

    clearInside := true.
    showBorder := false.
    
    (self class == Button
    and:[ ((styleSheet at:'button.style' default:nil) == #'MacOSX') ]) ifTrue:[
        |c1 c2 c3 bc|
        isActive ifTrue:[
            c1 := (styleSheet colorAt:'button.activeBackgroundColor1' default:nil). 
            c2 := (styleSheet colorAt:'button.activeBackgroundColor2' default:nil).
            c3 := (styleSheet colorAt:'button.activeBackgroundColor3' default:nil).
            bc := (styleSheet colorAt:'button.activeBorderColor' default:(Color grey:72)).
        ] ifFalse:[
            isEntered ifTrue:[
                c1 := (styleSheet colorAt:'button.enteredBackgroundColor1' default:nil). 
                c2 := (styleSheet colorAt:'button.enteredBackgroundColor2' default:nil).
                c3 := (styleSheet colorAt:'button.enteredBackgroundColor3' default:nil).
                bc := (styleSheet colorAt:'button.enteredBorderColor' default:(Color grey:72)).
            ] ifFalse:[
                c1 := (styleSheet colorAt:'button.passiveBackgroundColor1' default:nil). 
                c2 := (styleSheet colorAt:'button.passiveBackgroundColor2' default:nil).
                c3 := (styleSheet colorAt:'button.passiveBackgroundColor3' default:nil).
                bc := (styleSheet colorAt:'button.passiveBorderColor' default:(Color grey:72)).
            ].    
        ].    
        (border class == MacFlatButtonBorder) ifTrue:[ 
            (c1 notNil and:[c2 notNil]) ifTrue:[
                border backgroundColor1:c1.
                border backgroundColor2:c2.
                border color:bc.
                (GradientBackground new
                        direction:#northSouth;
                         colors:{c1 . c2};
                         usedLength:height)
                    fillRectangleX:0 y:0 width:width height:height in:self.

                clearInside := false.
            ] ifFalse:[
                c1 := c2 := bg. 
                border backgroundColor1:c1.
                border backgroundColor2:c2.
                border color:bc.
            ].
            showBorder := true.
        ].
        (border class == MacButtonBorder) ifTrue:[ 
            (c1 notNil and:[c2 notNil and:[c3 notNil]]) ifTrue:[
                border backgroundColor1:c1.
                border backgroundColor2:c2.
                border color:bc.
                (GradientBackground new
                        direction:#northSouth;
                        colors:{ c1 . c2 . c3};
                        usedLength:height)
                    fillRectangleX:0 y:0 width:width height:height in:self.

                clearInside := false.
            ] ifFalse:[
                c1 := c2 := bg. 
                border backgroundColor1:c1.
                border backgroundColor2:c2.
                border color:bc.
            ].
            showBorder := true.
        ].
    ].    
    self drawWith:fg and:bg clearInside:clearInside etchedFg:etchFg.   "this draws the text/image"
    
    showBorder ifTrue:[
        border displayOn:self forDisplayBox:(0@0 corner:width@height).
    ].
    
    (isReturnButton and:[shadowForm notNil]) ifTrue:[
        y := (height - shadowForm height) // 2.
        x := width - shadowForm width - (hSpace // 2).

        (self shiftLabelWhenPressed and:[level < 0]) ifTrue:[
            x := x + 1.
            y := y + 1
        ].

        formShadowColor isNil ifTrue:[
            gc paint:fg on:bg.
            gc displayOpaqueForm:shadowForm x:x y:y.
            ^ self
        ].

        "
         drawing form in 3d-style (i.e. with shadow and light)
        "
        (formShadowColor isColor and:[formShadowColor isDithered not
         and:[formLightColor isColor and:[formLightColor isDithered not
         and:[formColor isColor and:[formColor isDithered not]]]]])
        ifTrue:[
            sColor := formShadowColor.
            lColor := formLightColor.
        ] ifFalse:[
            sColor := device blackColor.
            lColor := device whiteColor.
        ].
        gc foreground:sColor.
        gc displayForm:shadowForm x:x y:y.

        lightForm notNil ifTrue:[
            gc foreground:lColor.
            gc displayForm:lightForm x:x y:y.
        ].
        gc paint:fg.
    ].

    self hasFocus ifTrue:[ 
        self drawFocusFrame 
    ].

    "Modified: / 22-10-2010 / 15:55:03 / cg"
!

redraw
    "redraw the button. 
     That's like redrawing a label, but uses different colors when pressed
     or entered."

    |fg bg entered hasFrame lvl isEnabled|

    shown ifFalse:[^ self].
    isEnabled := self enabled.

    "/ Transcript showCR:border.
    
"/    disabledLogo notNil ifTrue:[
"/        isEnabled ifFalse:[
"/            logo := disabledLogo.
"/        ] ifTrue:[
"/            controller active ifTrue:[
"/                logo := activeLogo
"/            ] ifFalse:[
"/                logo := passiveLogo
"/            ].
"/        ].
"/    ].

    hasFrame := false.
    fg := fgColor.
    bg := bgColor.
    isEnabled ifFalse:[
        fg := disabledFgColor.
    ] ifTrue:[
        entered := controller entered.
        entered ifTrue:[
            enteredFgColor notNil ifTrue:[fg := enteredFgColor].
            enteredBgColor notNil ifTrue:[bg := enteredBgColor].
            lvl := enterLevel.
        ] ifFalse:[
            lvl := leaveLevel
        ].
        (enterLevel notNil and:[leaveLevel notNil]) ifTrue:[
            offLevel ~~ lvl ifTrue:[
                offLevel := lvl.
                offLevel ~~ level ifTrue:[
                    self level:offLevel
                ]
            ]
        ].
        (controller pressed and:[entered or:[controller isTriggerOnDown]]) ifTrue:[
            hasFrame := self is3D not.
            activeFgColor isNil ifTrue:[
                onLevel == offLevel ifTrue:[
                    fg := bgColor
                ]
            ] ifFalse:[
                fg := activeFgColor.
            ].
            activeBgColor isNil ifTrue:[
                onLevel == offLevel ifTrue:[
                    bg := fgColor
                ]
            ] ifFalse:[
                bg := activeBgColor
            ].

            self is3D ifFalse:[
                hasFrame := ((fgColor = fg) and:[bgColor = bg]) not.
            ].
        ].
    ].

    self drawWith:fg and:bg.
    hasFrame ifTrue:[
        "
         draw a rectangle around (2D styles only)
        "
        gc paint:fg.
        gc displayRectangleX:0 y:0 width:width height:height.
        ^ self
    ].

    "Modified: / 3.11.1997 / 11:56:02 / cg"
!

redrawIfPressed
    "redraw the button, but only if visible and currently being pressed"

    shown ifTrue:[
        controller pressed ifTrue:[
            self redraw
        ]
    ]

    "Modified: 1.4.1997 / 13:26:27 / cg"
!

redrawX:x y:y width:w height:h 
    self renderOrRedraw.

    "Modified: 1.4.1997 / 13:26:31 / cg"
!

showActive
    "redraw myself as active (i.e. busy)"

    onLevel ~~ level ifTrue:[
        self level:onLevel.
    ].
"/    (activeLogo notNil and:[activeLogo ~~ logo]) ifTrue:[
"/        self logo:activeLogo
"/    ].
    self invalidate

    "Modified: 26.5.1996 / 18:08:52 / cg"
!

showPassive
    "redraw myself as passive"

    offLevel ~~ level ifTrue:[
        self level:offLevel.
    ].
    (passiveLogo notNil and:[passiveLogo ~~ logo]) ifTrue:[
        self label:passiveLogo
    ].
    self invalidate.

    "Modified: 26.5.1996 / 18:08:56 / cg"
! !

!Button class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

