"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016-2018 Jan Vrany
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

View subclass:#MenuPanel
	instanceVariableNames:'shadowView mapTime mustRearrange superMenu shortKeyInset
		selection items groupSizes receiver enabled lastActiveMenu
		enteredItem prevFocusView previousPointerGrab
		previousKeyboardGrab relativeGrabOrigin hasImplicitGrap
		scrollActivity rightArrowShadow rightArrow fgColor verticalLayout
		showSeparatingLines showGroupDivider implicitGrabView
		lastPointerView openDelayedMenuBlock closeDelayedMenuBlock
		preferredWidth application originator centerItems hideOnRelease
		defaultHideOnRelease buttonInsetX buttonInsetY itemSpace
		activeBackgroundColor stringOffsetX doAccessCharacterTranslation
		lastItem hasPerformed focusComesByTab lastDrawnScrollerNextBounds
		buttonActiveBackgroundColor buttonEnteredBackgroundColor
		buttonPassiveBackgroundColor maxExtent sizeFixed extraMargin
		buttonActiveLevel buttonPassiveLevel buttonEnteredLevel
		pluggableHelpSpecProvider'
	classVariableNames:'DefaultBackgroundColor DefaultForegroundColor
		IconDisabledIndicationOff IconDisabledIndicationOn
		IconDisabledRadioOff IconDisabledRadioOn IconIndicationOff
		IconIndicationOn IconRadioOff IconRadioOn Images
		InitialSelectionQuerySignal LigthenedImages
		MaxShortCutSearchLevel'
	poolDictionaries:''
	category:'Views-Menus'
!

Object subclass:#Item
	instanceVariableNames:'menuItem layout menuPanel subMenu displayLabel displayLabelExtent
		disabledDisplayLabel enableChannel label activeHelpText
		flyByHelpText isVisible indication choice accessCharacter'
	classVariableNames:'HorizontalInset VerticalInset HorizontalButtonInset
		VerticalButtonInset LabelRightOffset VerticalPopUpInset'
	poolDictionaries:''
	privateIn:MenuPanel
!

Object subclass:#Adornment
	instanceVariableNames:'indication accessCharacterPosition shortcutKey argument argument2
		choice choiceValue'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuPanel::Item
!

Object subclass:#ScrollActivity
	instanceVariableNames:'semaLock activeMenu scrollTask direction icons'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuPanel
!

!MenuPanel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016-2018 Jan Vrany
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
    a menu panel used for both pull-down-menus and pop-up-menus.

    Due to some historic leftover, there are two mechanisms for menus:
	1) the (very) old MenuView (which inherits from SelectionInListView)
	2) this new MenuPanel.

    this will eventually replace most of the MenuView and PopUpMenu stuff.
    (and hopefully be ST-80 compatible...)

    To create a menu, there exists a MenuEditor which can generate
    menu specifications, from which a MenuPanel can be dynamically created.


    Notice:
	This is going to replace the obsolete MenuView.

    [author:]
	Claus Atzkern

    [see also:]
	Menu
	MenuItem
	MenuEditor

    cg: this code is so ugly - needs a complete rewrite...

"
!

examples

"
  a PullDownMenu
                                                                                [exBegin]
    |top subView mview labels|

    top := StandardSystemView new.

    labels := #( 'foo' 'bar' 'baz' 'test') copy.
    labels at:4 put:(LabelAndIcon label:'test' icon:(ToolbarIconLibrary cutIcon)).

    mview := MenuPanel in:top.
    mview labels:labels.
    (mview itemAt:1) enabled:false.
    (mview itemAt:4) enabled:false.
    top extent:(mview preferredExtent + 20).
    top open.
                                                                                [exEnd]

                                                                                [exBegin]
    |top subView mview desc s1 s2 s3 img lbs labels|

    top := StandardSystemView new.

    mview := MenuPanel in:top.

    labels := #( 'foo' 'bar' 'baz' 'test' 'claus' ).
    mview level:2.
    mview verticalLayout:false.
    img := Image fromFile:'bitmaps/SBrowser.xbm'.
    lbs := Array with:'foo' with:'bar' with:img with:'baz' with:'test' with:'ludwig'.
    mview labels:lbs.
    mview shortcutKeyAt:2 put:#Cut.
    mview accessCharacterPositionAt:1 put:1.
    mview accessCharacterPositionAt:2 put:2.

    mview enabledAt:5 put:false.
    mview groupSizes:#( 2 2 ).
    s1 := MenuPanel labels:labels.
    s1 accessCharacterPositionAt:1 put:1.
    s1 accessCharacterPositionAt:2 put:2.
    s1 groupSizes:#( 2 2 ).
    s2 := MenuPanel labels:#( '1' nil '2' '-' '3' '=' '4' ' ' '5' ).
    s3 := MenuPanel labels:lbs.

    s1 subMenuAt:2 put:s2.
    s1 subMenuAt:3 put:(MenuPanel labels:lbs).
    s2 subMenuAt:3 put:s3.
    s3 subMenuAt:3 put:(MenuPanel labels:labels).
    s3 shortcutKeyAt:3 put:$q.

    mview subMenuAt:1 put:s1.
    mview subMenuAt:4 put:(MenuPanel labels:lbs).
    (mview subMenuAt:4) shortcutKeyAt:3 put:#Copy.
    s1 shortcutKeyAt:1 put:#Copy.
    s1 shortcutKeyAt:3 put:#Paste.

    mview subMenuAt:2 put:(MenuPanel labels:labels).
    top extent:(mview preferredExtent).
    top open.
                                                                                [exEnd]

  a PullDownMenu with applications
                                                                                [exBegin]
    |top menu view item|

    top  := StandardSystemView extent:240@100.
    menu := MenuPanel in:top.
    menu labels:#( 'foo' 'Application' 'Clock' ).
    menu verticalLayout:false.

    menu subMenuAt:1 put:(MenuPanel labels:#( 'bar' 'baz' )).
    menu subMenuAt:2 put:(MenuPanel labels:#( 'foo' 'bar' 'baz' )).

    view := ClockView new.
    view preferredExtent:100@100.
    item := menu itemAt:3.
    item submenu:view.

    view := ImageView new.
    view image:(Image fromScreen:(0@0 corner:200@200)).
    view preferredExtent:(200@200).
    item := menu itemAt:2.
    item submenu:view.

    menu origin:0@0 corner:1.0@30.
    top open.
                                                                                [exEnd]


  a PopUpMenu
                                                                                [exBegin]
    |subView mview desc s1 s2 s3 img lbs labels|

    mview := MenuPanel new.
    labels := #( 'foo' 'bar' 'baz' ).
    mview level:2.

    img := Image fromFile:'bitmaps/SBrowser.xbm'.
    lbs := Array with:'foo' with:'bar' with:img with:'baz' with:'test'.
    mview labels:lbs.

    s1 := MenuPanel labels:labels.
    s2 := MenuPanel labels:#( '1' nil '2' '-' '3' '=' '4' ' ' '5' ).
    s3 := MenuPanel labels:lbs.
    s1 subMenuAt:2 put:s2.
    s1 subMenuAt:3 put:(MenuPanel labels:lbs).
    s2 subMenuAt:3 put:s3.
    s3 subMenuAt:3 put:(MenuPanel labels:labels).
    s3 shortcutKeyAt:3 put:$q.

    mview subMenuAt:1 put:s1.
    mview subMenuAt:4 put:(MenuPanel labels:lbs).
    (mview subMenuAt:4) shortcutKeyAt:3 put:#Copy.
    s1 shortcutKeyAt:1 put:#Copy.
    s1 shortcutKeyAt:3 put:#Paste.

    mview subMenuAt:2 put:(MenuPanel labels:labels).
    mview startUp
                                                                                [exEnd]


  a menu spec
                                                                                [exBegin]
    |menu|

    menu := MenuPanel menu:
        #(#Menu #( #(#MenuItem
                    #label: 'File'
                    #submenu:
                      #(#Menu #(#(#MenuItem #label: 'quit' #value:#quit )
                                 (#MenuItem
                                    #label: 'edit'
                                    #submenu:
                                      #(#Menu #( #(#MenuItem #label: 'edit'  #value:#edit )
                                                 #(#MenuItem #label: 'close' #value:#close)
                                               )
                                               nil
                                               nil
                                       )
                                  )
                                 #(#MenuItem #label: 'help' #value:#help )
                               )
                               nil
                               nil
                       )
                 )
                #(#MenuItem #label: 'Inspect' #value:#inspectMenu )
                #(#MenuItem #label: 'Bar'
                            #submenu:
                               #(#Menu #( #(#MenuItem #label: 'bar 1' #value:#bar1 )
                                          #(#MenuItem #label: 'bar 2' #value:#bar2 )
                                        )
                                        nil
                                        nil
                                )
                 )
              )
              #( 2 )
              nil
         ) decodeAsLiteralArray.

    menu verticalLayout:false.
    Transcript showCR:(menu startUp).
                                                                                [exEnd]

"
! !

!MenuPanel class methodsFor:'instance creation'!

fromSpec:aSpec
    ^ self fromSpec:aSpec receiver:nil
!

fromSpec:aSpec receiver:aReceiver
    |menu|

    aSpec notNil ifTrue:[
	menu := Menu new.
	menu receiver:aReceiver.
	menu fromLiteralArrayEncoding:aSpec.
    ].
  ^ self menu:menu receiver:aReceiver
!

labels:labels
    ^ self labels:labels nameKeys:nil receiver:nil
!

labels:labels nameKeys:nameKeys
    ^ self labels:labels nameKeys:nameKeys receiver:nil
!

labels:labels nameKeys:nameKeys receiver:aReceiver
    |mview|

    mview := self menu:nil receiver:aReceiver.
    mview labels:labels.
    mview nameKeys:nameKeys.
  ^ mview

!

labels:labels receiver:aReceiver
    ^ self labels:labels nameKeys:nil receiver:aReceiver
!

menu:aMenu
    ^ self menu:aMenu receiver:nil
!

menu:aMenu receiver:aReceiver
    |mview|

    mview := self new.

    (aMenu notNil and:[aMenu receiver isNil]) ifTrue:[
	"/ no receiver specified in the menu; thus set the receiver immediately
	mview receiver:aReceiver
    ].

    mview menu:aMenu.


"/ a menu itself may contain a receiver
"/ thus we do not overwrite the receiver

    aReceiver notNil ifTrue:[
	mview receiver:aReceiver
    ].
  ^ mview
! !

!MenuPanel class methodsFor:'class initialization'!

initialize
    InitialSelectionQuerySignal isNil ifTrue:[
	InitialSelectionQuerySignal := QuerySignal new.
    ].

    "
     self initialize
    "

    "Modified: / 15.1.1998 / 23:08:31 / stefan"
! !

!MenuPanel class methodsFor:'default icons'!

delayedMenuIndicator
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self delayedMenuIndicator inspect
     ImageEditor openOnClass:self andSelector:#delayedMenuIndicator
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'MenuPanel class delayedMenuIndicator'
	ifAbsentPut:[
	    (Depth1Image new)
		width:7;
		height:6;
		photometric:(#palette);
		bitsPerSample:(#( 1 ));
		samplesPerPixel:(1);
		bits:(ByteArray fromPackedString:'@@@@@HCB');
		colorMapFromArray:#[ 0 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:7;
			    height:6;
			    bits:(ByteArray fromPackedString:'@J+V[C P');
			    yourself);
		yourself
	]
!

iconIndicationDisabledOff
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconIndicationDisabledOff inspect
     ImageEditor openOnClass:self andSelector:#iconIndicationDisabledOff"

    IconDisabledIndicationOff isNil ifTrue:[
	IconDisabledIndicationOff := Icon
		constantNamed:#'MenuPanel iconIndicationDisabledOff'
		ifAbsentPut:[
		    (Depth2Image new)
			width:14;
			height:14;
			photometric:(#palette);
			bitsPerSample:(#( 2 ));
			samplesPerPixel:(1);
			bits:(ByteArray
				    fromPackedString:'UUUUPG???8A:***@^*** G***(A:***@^*** G***(A:***@^*** G***(A:***@Z*** @@@@@@b');
			colorMapFromArray:#[ 255 255 255 127 127 127 170 170 170 0 0 0 ];
			mask:((ImageMask new)
				    width:14;
				    height:14;
				    bits:(ByteArray
						fromPackedString:'??3??O?<??3??O?<??3??O?<??3??O?<??3??@@a');
				    yourself);
			yourself
		]
    ].
    ^ IconDisabledIndicationOff
!

iconIndicationDisabledOn
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconIndicationDisabledOn inspect
     ImageEditor openOnClass:self andSelector:#iconIndicationDisabledOn"

    IconDisabledIndicationOn isNil ifTrue:[
	IconDisabledIndicationOn := Icon
		constantNamed:#'MenuPanel iconIndicationDisabledOn'
		ifAbsentPut:[
		    (Depth2Image new)
			width:14;
			height:14;
			photometric:(#palette);
			bitsPerSample:(#( 2 ));
			samplesPerPixel:(1);
			bits:(ByteArray
				    fromPackedString:'****$H@@@MBO???P#???4H??<=BO?<OP#O<C4H0<C=BL@C?P#0C?4H?C?=BO???P/???4EUUUU@b');
			colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
			mask:((ImageMask new)
				    width:14;
				    height:14;
				    bits:(ByteArray
						fromPackedString:'??3??O?<??3??O?<??3??O?<??3??O?<??3??@@a');
				    yourself);
			yourself
		]
    ].
    ^ IconDisabledIndicationOn
!

iconIndicationOff
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconIndicationOff inspect
     ImageEditor openOnClass:self andSelector:#iconIndicationOff"

    IconIndicationOff isNil ifTrue:[
	IconIndicationOff := Icon constantNamed:#'MenuPanel iconIndicationOff'
		ifAbsentPut:[
		    (Depth2Image new)
			width:14;
			height:14;
			photometric:(#palette);
			bitsPerSample:(#( 2 ));
			samplesPerPixel:(1);
			bits:(ByteArray
				    fromPackedString:'UUUUPG???8A0@@B@\@@@ G@@@HA0@@B@\@@@ G@@@HA0@@B@\@@@ G@@@HA0@@B@Z*** @@@@@@b');
			colorMapFromArray:#[ 255 255 255 127 127 127 170 170 170 0 0 0 ];
			mask:((ImageMask new)
				    width:14;
				    height:14;
				    bits:(ByteArray
						fromPackedString:'??3??O?<??3??O?<??3??O?<??3??O?<??3??@@a');
				    yourself);
			yourself
		]
    ].
    ^ IconIndicationOff
!

iconIndicationOn
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconIndicationOn inspect
     ImageEditor openOnClass:self andSelector:#iconIndicationOn"

    IconIndicationOn isNil ifTrue:[
	IconIndicationOn := Icon constantNamed:#'MenuPanel iconIndicationOn'
		ifAbsentPut:[
		    (Depth2Image new)
			width:14;
			height:14;
			photometric:(#palette);
			bitsPerSample:(#( 2 ));
			samplesPerPixel:(1);
			bits:(ByteArray
				    fromPackedString:'****$H@@@MBEUUWP!!UUU4HUUT]BEUTGP!!ETA4HPTA]BD@AWP!!PAU4HUAU]BEUUWP/???4EUUUU@b');
			colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
			mask:((ImageMask new)
				    width:14;
				    height:14;
				    bits:(ByteArray
						fromPackedString:'??3??O?<??3??O?<??3??O?<??3??O?<??3??@@a');
				    yourself);
			yourself
		]
    ].
    ^ IconIndicationOn
!

iconRadioGroupDisabledOff
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconRadioGroupDisabledOff inspect
     ImageEditor openOnClass:self andSelector:#iconRadioGroupDisabledOff
    "

"/    <resource: #image>
"/
"/    IconDisabledRadioOff isNil ifTrue:[
"/        IconDisabledRadioOff := Icon
"/            constantNamed:#'MenuPanel iconRadioGroupDisabledOff'
"/            ifAbsentPut:[(Depth2Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@AUP@@E@AP@DJ*Y@DZ**(AJ**+AJ***LR***#D***(1J***LR***#AZ**#@Z**(0A** 0@C@C0@@O?@@') ; colorMapFromArray:#[0 0 0 85 85 85 170 170 170 255 255 255]; mask:((Depth1Image new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?:??+?>/?:??)?=G?4O< HL@_@') ; yourself); yourself]
"/    ].
"/    ^ IconDisabledRadioOff

    <resource: #programImage>
    ^ RadioButton disabledPassiveForm
!

iconRadioGroupDisabledOn
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconRadioGroupDisabledOn inspect
     ImageEditor openOnClass:self andSelector:#iconRadioGroupDisabledOn
     Icon flushCachedIcons
    "

"/    <resource: #image>
"/
"/    IconDisabledRadioOn isNil ifTrue:[
"/        IconDisabledRadioOn := Icon
"/            constantNamed:#'MenuPanel class iconRadioGroupDisabledOn'
"/            ifAbsentPut:[(Depth2Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@AUP@@E@AP@DJ*Y@DYUZ(AIUU+AIUUVLRUUU#D%UUX1IUUVLRUUU#AYUU#@Z%U(0A** 0@C@C0@@O?@@') ; colorMapFromArray:#[0 0 0 85 85 85 170 170 170 255 255 255]; mask:((Depth1Image new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?:??+?>/?:??)?=G?4O< HL@_@') ; yourself); yourself]
"/    ].
"/    ^ IconDisabledRadioOn

    <resource: #programImage>
    ^ RadioButton disabledActiveForm
!

iconRadioGroupEnteredOff
    <resource: #programImage>
    ^ RadioButton enteredPassiveForm
!

iconRadioGroupEnteredOn
    <resource: #programImage>
    ^ RadioButton enteredActiveForm
!

iconRadioGroupOff
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconRadioGroupOff inspect
     ImageEditor openOnClass:self andSelector:#iconRadioGroupOff
    "

"/    <resource: #image>
"/
"/    IconRadioOff isNil ifTrue:[
"/        IconRadioOff := Icon
"/            constantNamed:#'MenuPanel iconRadioGroupOff'
"/            ifAbsentPut:[(Depth2Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@AUP@@E@AP@DO?Y@D_?>(AO??;AO???LS???3D???<1O???LS???3A_??3@Z??<0A+?00@C@C0@@O?@@') ; colorMapFromArray:#[0 0 0 85 85 85 170 170 170 255 255 255]; mask:((Depth1Image new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?:??+?>/?:??)?=G?4O< HL@_@') ; yourself); yourself]
"/    ].
"/    ^ IconRadioOff

    <resource: #programImage>
    ^ RadioButton passiveForm
!

iconRadioGroupOn
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconRadioGroupOn inspect
     ImageEditor openOnClass:self andSelector:#iconRadioGroupOn
    "

"/    <resource: #image>
"/
"/    IconRadioOn isNil ifTrue:[
"/        IconRadioOn := Icon
"/            constantNamed:#'MenuPanel iconRadioGroupOn'
"/            ifAbsentPut:[(Depth2Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@AUP@@E@AP@DO?Y@D]@^(AL@@;AM@@GLS@@@3D0@@L1L@@CLSP@A3A\@@3@Z4A<0A+?00@C@C0@@O?@@') ; colorMapFromArray:#[0 0 0 85 85 85 170 170 170 255 255 255]; mask:((Depth1Image new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?:??+?>/?:??)?=G?4O< HL@_@') ; yourself); yourself]
"/    ].
"/    ^ IconRadioOn

    <resource: #programImage>
    ^ RadioButton activeForm
!

menuIndicator
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuIndicator inspect
     ImageEditor openOnClass:self andSelector:#menuIndicator
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'MenuPanel class menuIndicator'
	ifAbsentPut:[
	    (Depth1Image new)
		width:7;
		height:4;
		photometric:(#palette);
		bitsPerSample:(#( 1 ));
		samplesPerPixel:(1);
		bits:(ByteArray fromPackedString:'@@B@0 @a');
		colorMapFromArray:#[ 0 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:7;
			    height:4;
			    bits:(ByteArray fromPackedString:'?''08D@@a');
			    yourself);
		yourself
	]
! !

!MenuPanel class methodsFor:'defaults'!

defaultBackgroundColor
    DefaultBackgroundColor notNil ifTrue:[^ DefaultBackgroundColor].
    ^ StyleSheet at:#'pullDownMenu.backgroundColor' default:DefaultViewBackgroundColor.
!

defaultLevel
    ^ StyleSheet at:#'pullDownMenu.level' default:1
"
self defaultLevel
"
!

delayedMenuIndicatorOffset
    "returns an additional offset between the label and the
     delayedMenu indication (i.e. the down-arrow icon)"

    ^ 1 "2"
!

maxShortCutSearchLevel
    "1 means: only search in top items.
     2 means: search one level of menus.
     used to be 10"

    MaxShortCutSearchLevel isNil ifTrue:[MaxShortCutSearchLevel := 2.].
    ^ MaxShortCutSearchLevel
!

maxShortCutSearchLevel: anInteger
    "1 means: only search in top items.
     2 means: search one level of menus."

    MaxShortCutSearchLevel := anInteger
!

menuIndicatorOffset
    "returns an additional offset between the label and the
     delayedMenu indication (i.e. the down-arrow icon)"

    ^ 1 "2"
!

mnemonicIdentifier
    "returns the identifier each mnemonic starts with;
     ex:
	&File   mnemonic := Cmdf
	F&ile   mnemonic := Cmdi
	....."

    ^ 'Cmd'
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (
        #'selection.disabledForegroundColor'
        #'pullDownMenu.foregroundColor' #'pullDownMenu.backgroundColor' #'pullDownMenu.level'
        #'menu.itemHorizontalSpace' #'menu.buttonItemHorizontalSpace' #'menu.buttonItemSpace'
        #'menu.itemSpace' #'menu.buttonItemVerticalSpace'
        #'menu.buttonActiveLevel' #'menu.buttonPassiveLevel' #'menu.buttonEnteredLevel'
        #'menu.hilightLevel' #'menu.enteredLevel'
        #'menu.groupDividerSize' #'menu.itemMargin'
        #'menu.disabledEtchedForegroundColor' #'menu.hilightForegroundColor'
        #'menu.enteredBackgroundColor' #'menu.enteredForegroundColor'
        #'menu.disabledForegroundColor' #'menu.buttonEnteredBackgroundColor'
        #'menu.selectionFollowsMouse'
        #'button.disabledEtchedForegroundColor' #'button.disabledForegroundColor'
        #'button.activeBackgroundColor' #'button.backgroundColor' #'button.lightColor'
        #'button.enteredBackgroundColor' #'button.halfLightColor' #'button.halfShadowColor'
        #'button.activeLevel' #'button.passiveLevel' #'button.edgeStyle'
        #'menu.iconIndicationOn' #'menu.iconIndicationOff'
        #'menu.iconIndicationOn.bitmapFile' #'menu.iconIndication.bitmapOffFile'
        #'menu.iconDisabledIndicationOn' #'menu.iconDisabledIndicationOff'
        #'menu.iconDisabledIndicationOn.bitmapFile' #'menu.iconDisabledIndication.bitmapOffFile'
        #'menu.iconRadioOn' #'menu.iconRadioOff'
        #'menu.iconRadioOn.bitmapFile' #'menu.iconRadioOff.bitmapFile'
        #'menu.iconDisabledRadioOn' #'menu.iconDisabledRadioOff'
        #'menu.iconDisabledRadioOn.bitmapFile' #'menu.iconDisabledRadioOff.bitmapFile'
    )>

    |styleSheet style var foregroundColor backgroundColor buttonPassiveBackgroundColor
    buttonActiveLevel buttonPassiveLevel buttonEnteredLevel getBitmapOrFile|

    "clear DefaultBackgroundColor caused by accessing the #defaultBackgroundColor
     which returns the default cashed DefaultBackgroundColor
    "
    DefaultBackgroundColor := nil.

    MenuView            updateStyleCache.
    SelectionInListView updateStyleCache.

    styleSheet  := StyleSheet.
    style       := styleSheet name.

    DefaultFont     := MenuView defaultFont.
    foregroundColor := DefaultForegroundColor := styleSheet colorAt:#'pullDownMenu.foregroundColor'
                                                            default:[styleSheet
                                                                        colorAt:#'menu.foregroundColor'
                                                                        default:Color black].
    backgroundColor := DefaultBackgroundColor := self defaultBackgroundColor.

    var := styleSheet colorAt:#'menu.hilightBackgroundColor'.
    var isNil ifTrue:[
        style == #motif ifTrue:[ var := backgroundColor ]
                       ifFalse:[ var := styleSheet is3D ifFalse:[foregroundColor] ifTrue:[backgroundColor] ]
    ].
    styleSheet at:#'menuPanel.activeBackgroundColor' put:var.

    var := styleSheet colorAt:#'menu.disabledEtchedForegroundColor'.
    var isNil ifTrue:[ var := styleSheet colorAt:#'button.disabledEtchedForegroundColor' ].
    styleSheet at:#'menuPanel.disabledEtchedFgColor' put:var.

    var := styleSheet colorAt:#'menu.disabledForegroundColor'.
    var isNil ifTrue:[
        var := styleSheet colorAt:#'selection.disabledForegroundColor'.
        var isNil ifTrue:[ var := styleSheet colorAt:#'button.disabledForegroundColor' default:Color darkGray ]
    ].
    styleSheet at:#'menuPanel.disabledForegroundColor' put:var.

    var := styleSheet colorAt:#'menu.hilightForegroundColor'.
    var isNil ifTrue:[ var := styleSheet is3D ifTrue:[foregroundColor] ifFalse:[backgroundColor] ].
    styleSheet at:#'menuPanel.activeForegroundColor' put:var.


    buttonActiveLevel := styleSheet at:#'menu.buttonActiveLevel' default:(styleSheet is3D ifTrue:[-2] ifFalse:[0]).
    buttonActiveLevel isNil ifTrue:[ buttonActiveLevel := styleSheet at:#'button.activeLevel' default:(styleSheet is3D ifTrue:[-2] ifFalse:[0]) ].
    "/ styleSheet at:#'menuPanel.buttonActiveLevel' put:buttonActiveLevel.

    buttonPassiveLevel := styleSheet at:#'menu.buttonPassiveLevel'.
    buttonPassiveLevel isNil ifTrue:[ buttonPassiveLevel :=  styleSheet at:#'button.passiveLevel' default:(styleSheet is3D ifTrue:[2] ifFalse:[0])].
    "/ styleSheet at:#'menuPanel.buttonPassiveLevel' put:buttonPassiveLevel.

    buttonEnteredLevel := styleSheet at:#'menu.buttonEnteredLevel' default:buttonPassiveLevel.
    "/ styleSheet at:#'menuPanel.buttonEnteredLevel' put:buttonEnteredLevel.

    var := (buttonActiveLevel abs max:(buttonPassiveLevel abs)) max:(buttonEnteredLevel abs).
    styleSheet at:#'menuPanel.maxAbsoluteButtonLevel' put:var.

    buttonPassiveBackgroundColor := styleSheet at:#'button.backgroundColor'.
    buttonPassiveBackgroundColor isNil ifTrue:[
        buttonPassiveBackgroundColor := (styleSheet at:'viewBackground') ? backgroundColor
    ].
    styleSheet at:#'menuPanel.buttonPassiveBackgroundColor' put:buttonPassiveBackgroundColor.

    var := styleSheet at:#'button.lightColor'.
    var isNil ifTrue:[ var := (buttonPassiveBackgroundColor averageColorIn:(0@0 corner:7@7)) lightened ].
    styleSheet at:#'menuPanel.buttonLightColor' put:var.

    var :=  styleSheet at:#'button.shadowColor'.
    var isNil ifTrue:[ var := (buttonPassiveBackgroundColor averageColorIn:(0@0 corner:7@7)) darkened ].
    styleSheet at:#'menuPanel.buttonShadowColor' put:var.

    var := styleSheet colorAt:#'menu.buttonEnteredBackgroundColor'.
    var isNil ifTrue:[ var := styleSheet colorAt:#'button.enteredBackgroundColor' default:buttonPassiveBackgroundColor ].
    styleSheet at:#'menuPanel.buttonEnteredBackgroundColor' put:var.

    Item updateStyleCache.

    getBitmapOrFile := [:key :fileKey |
        |var|

        var := styleSheet at:key ifAbsent:nil.
        var isNil ifTrue:[
            var := styleSheet at:fileKey ifAbsent:nil.
            var notNil ifTrue:[
                var := Smalltalk imageFromFileNamed:var forClass:self.
            ].
        ].
        var
    ].

    IconIndicationOn := getBitmapOrFile value:#'menu.iconIndicationOn' value:#'menu.iconIndicationOn.bitmapFile'.
    IconIndicationOff := getBitmapOrFile value:#'menu.iconIndicationOff' value:#'menu.iconIndicationOff.bitmapFile'.
    IconDisabledIndicationOn := getBitmapOrFile value:#'menu.iconDisabledIndicationOn' value:#'menu.iconDisabledIndicationOn.bitmapFile'.
    IconDisabledIndicationOff := getBitmapOrFile value:#'menu.iconDisabledIndicationOff' value:#'menu.iconDisabledIndicationOff.bitmapFile'.

    IconRadioOn := getBitmapOrFile value:#'menu.iconRadioOn' value:#'menu.iconRadioOn.bitmapFile'.
    IconRadioOff := getBitmapOrFile value:#'menu.iconRadioOff' value:#'menu.iconRadioOff.bitmapFile'.
    IconDisabledRadioOn := getBitmapOrFile value:#'menu.iconDisabledRadioOn' value:#'menu.iconDisabledRadioOn.bitmapFile'.
    IconDisabledRadioOff := getBitmapOrFile value:#'menu.iconDisabledRadioOff' value:#'menu.iconDisabledRadioOff.bitmapFile'.

    "
     self updateStyleCache
    "

    "Modified: / 19-01-2012 / 13:17:59 / cg"
! !

!MenuPanel class methodsFor:'image registration'!

image:anImage onDevice:aDevice
"
Images := nil
"
    |deviceImages|

    anImage device == aDevice ifTrue:[
        ^ anImage
    ].

    Images isNil ifTrue:[ 
        Images := IdentityDictionary new.
    ].
    deviceImages := Images at:aDevice ifAbsentPut:[Dictionary new].
    ^ deviceImages at:anImage ifAbsentPut:[anImage copy onDevice:aDevice].
!

lightenedImage:anImage onDevice:aDevice
"
LigthenedImages := nil
"
    |deviceImages image colorMap|

    LigthenedImages isNil ifTrue:[LigthenedImages := IdentityDictionary new].

    deviceImages := LigthenedImages at:aDevice ifAbsentPut:[WeakIdentityDictionary new].
    (image := deviceImages at:anImage ifAbsent:nil) notNil ifTrue:[
        ^ image
    ].

    colorMap := anImage perform:#colorMap ifNotUnderstood:nil.
    colorMap notNil ifTrue:[
        image := anImage lightened onDevice:aDevice.
    ] ifFalse:[
        image := self image:anImage onDevice:aDevice
    ].
    deviceImages at:anImage put:image.
    ^ image
!

releaseCachedImagesFromDevice:aGraphicsDevice
    "flush cached resources before saving a snapshot
     (do not save them in the image)"

    aGraphicsDevice isNil ifTrue:[
        Images := LigthenedImages := nil.
        ^ self.
    ].

    Images notNil ifTrue:[
        Images removeKey:aGraphicsDevice ifAbsent:[].
    ].
    LigthenedImages notNil ifTrue:[
        LigthenedImages removeKey:aGraphicsDevice ifAbsent:[].
    ].
! !

!MenuPanel class methodsFor:'private'!

subMenu:aSubMenu
    "create a submenu; can be redifined in derived classes"

    ^ (self new) menu:aSubMenu.

    "Modified: / 8.8.1998 / 02:13:11 / cg"
! !

!MenuPanel class methodsFor:'startup & release'!

preSnapshot
    "flush cached resources before saving a snapshot
     (do not save them in the image)"

    self releaseCachedImagesFromDevice:nil
! !

!MenuPanel class methodsFor:'utilities'!

processAmpersandCharactersFor:aLabel withAccessCharacterPosition:accessCharacterPositionOrNil
    "replace &x by the short-key attribute (i.e. remove & and underline x)
     The position is either specified by an accessCharacter position (useful if computed
     or fix), or by an ampersand escape.
     Double ampersands are replaced by a single one."

    |i label nextChar rest pos size accessCharacter|

    pos := accessCharacterPositionOrNil.

    label := aLabel.
    size := aLabel size.
    i := 1.
    [((i := label indexOf:$& startingAt:i) ~~ 0 and:[i < size])] whileTrue:[
	nextChar := label at:(i+1).
	nextChar isSeparator ifTrue:[
	    i := i + 1
	] ifFalse:[
	    rest := label copyFrom:(i+1).

	    i == 1 ifTrue:[label := rest]
		  ifFalse:[label := (label copyFrom:1 to:(i-1)), rest].

	    (label at:i) == $& ifTrue:[i := i + 1] ifFalse:[pos := i].
	    size := size - 1.
	].
    ].

    (pos isNil or:[(accessCharacter := label at:pos ifAbsent:nil) isNil]) ifTrue:[
	^ label
    ].

    label isText ifFalse:[
	label := Text string:label
    ].
    label emphasisAt:pos add:#underline.
    ^ label

    "Created: / 15-02-2012 / 18:50:58 / cg"
! !

!MenuPanel methodsFor:'accepting'!

accept
    "accept the current selected item"

    |item|

    (item := self selection) isNil ifTrue:[
	self topMenu
	    openDelayed:nil;
	    accept:nil.
    ] ifFalse:[
	self acceptItem:item inMenu:self
    ]

    "Modified: / 29-06-2011 / 16:14:26 / cg"
!

accept:anItemOrNil
    "this is the topMenu: close the menu and accept the item (if not nil)"

    |itemAcceptedOrNil tgState itemIdx recv panel masterGroup winGrp focusView sensor|

    self superMenu notNil ifTrue:[
        ^ self topMenu accept:anItemOrNil
    ].
    prevFocusView ~~ self ifTrue:[
        focusView := prevFocusView.
    ].
    prevFocusView := nil.

    self openDelayed:nil.
    self scrollActivity stop.
    self selection:nil.

    (anItemOrNil notNil and:[anItemOrNil canAccept]) ifTrue:[
        tgState := anItemOrNil toggleIndication.
        panel := anItemOrNil menuPanel.
        itemIdx := panel findFirst:[:el| el == anItemOrNil ].
        itemAcceptedOrNil := anItemOrNil.
        recv := panel receiver.
    ].
    self doUngrab:true.

    winGrp := self windowGroup.

    self isPopUpView ifFalse:[
        self do:[:el| el updateIndicators].
        winGrp notNil ifTrue:[
            winGrp processExposeEvents.
        ].
    ] ifTrue:[
        self unmap.
        device sync. "/ round trip - all expose events are now received

        winGrp notNil ifTrue:[
            "/ give expose event a chance to arrive
            [shown and:[realized]] whileTrue:[
                winGrp processExposeEventsFor:self
            ].
            masterGroup := winGrp previousGroup.
        ].
        "/ cg: disabled-not needed - try PopUpList with destroy...
        "/ self destroy.
        masterGroup notNil ifTrue:[masterGroup processExposeEvents].
    ].

    (focusView notNil and:[winGrp notNil]) ifTrue:[
        winGrp focusView:focusView.
    ].

    itemAcceptedOrNil isNil ifTrue:[
        hasPerformed := true.
        self isPopUpView ifTrue:[
            lastItem := itemAcceptedOrNil.
        ].
        ^ itemAcceptedOrNil.
    ].

"/ using master maingroup, sensor in my current windowgroup
"/ flushes its events if the window goes
winGrp notNil ifTrue:[
    winGrp mainGroup notNil ifTrue:[
        sensor := winGrp mainGroup sensor.
    ].
].
sensor isNil ifTrue:[sensor := self sensor ].

    sensor pushEvent:(
        MenuEvent
            selectMenuItem:itemAcceptedOrNil
            index:itemIdx
            text:nil
            value:tgState
            inMenu:self
            menuReceiver:recv).

    ^ anItemOrNil.  "/ stupid convention

"/    acceptAction := [ self accept:itemAcceptedOrNil index:itemIdx toggle:tgState receiver:recv ].
"/
"/    winGrpForBusyCursor := masterGroup ? winGrp.
"/
"/    (itemAcceptedOrNil showBusyCursorWhilePerforming
"/    and:[winGrpForBusyCursor notNil])
"/    ifTrue:[
"/        winGrpForBusyCursor withWaitCursorDo:acceptAction
"/    ] ifFalse:[
"/        acceptAction value
"/    ].

    "Modified: / 07-07-2011 / 18:08:41 / cg"
!

accept:anItem index:anIndex toggle:aState receiver:aReceiver
    "really accept an item"

    |selectorOrBlock argument numArgs isValueModel rec args arg2
     app master fallBack|

    isValueModel := aReceiver isValueModel.

    hasPerformed := isValueModel.

    (selectorOrBlock := anItem value) isNil ifTrue:[
        ^ self "/ ^ anIndex
    ].

    (argument := anItem argument) isNil ifTrue:[
        argument := aState ? anItem
    ].

    (selectorOrBlock isSymbol or:[selectorOrBlock isArray]) ifFalse:[
        "/ a valueHolder or block
        (selectorOrBlock respondsTo:#valueWithArguments:) ifFalse:[
            'MenuPanel [warning]: menuItem''s value does not respond to #value protocol' infoPrintCR.
             ^ self "/ ^ selectorOrBlock
        ].

        numArgs := selectorOrBlock perform:#numArgs ifNotUnderstood:0.

        numArgs == 0 ifTrue:[
            args := nil
        ] ifFalse:[
            numArgs == 1 ifTrue:[
                args := Array with:argument
            ] ifFalse:[
                args := Array with:argument with:self
            ]
        ].

        selectorOrBlock valueWithArguments:args.

        hasPerformed := true.
        ^ self "/ ^ anIndex
    ].

    anItem sendToOriginator ifTrue:[
        rec := self originator.
        rec isNil ifTrue:[
            self error:'no originating widget (no target for message)' mayProceed:true.
        ].
    ] ifFalse:[
        rec := anItem receiver ? aReceiver
    ].

    rec isNil ifTrue:[
        'MenuPanel [warning]: menu has no receiver defined' infoPrintCR.
        ^ self "/ ^ selectorOrBlock
    ].

    isValueModel ifTrue:[
        rec value:selectorOrBlock
    ] ifFalse:[
        selectorOrBlock isArray ifTrue:[
            "/ a hack !!!!!! Must be compatible to old MenuView
            args := selectorOrBlock copyFrom:2.
            selectorOrBlock := selectorOrBlock first.
        ] ifFalse:[

            arg2 := anItem.

            "/ support for ST80 style applications
            "/ (expecting the message to go to the application
            "/  if not understood by the view)
            "/ These expect the controller to be passed as argument.
            "/ sigh.

            (rec isView
            and:[(rec respondsTo:selectorOrBlock) not
            and:[(app := rec application) ~~ rec
            and:[app notNil]]]) ifTrue:[
                arg2 := rec controller.       "/ the view's controller
                rec := app.
            ].

            (numArgs := selectorOrBlock numArgs) == 0 ifTrue:[
                args := nil
            ] ifFalse:[
                numArgs == 1 ifTrue:[
                    args := Array with:argument
                ] ifFalse:[
                    args := Array with:argument with:arg2
                ]
            ].
        ].

        fallBack :=
            [
                |val|

                "/ mhmh - the receiver did not respond to that message;
                "/ if there is a master-application, try that one
                "/ (recursive)
                master := rec perform:#masterApplication ifNotUnderstood:nil.
                master notNil ifTrue:[
                    rec := master.
                    val := rec perform:selectorOrBlock withArguments:args ifNotUnderstood:fallBack
                ] ifFalse:[
                    self
                        error:('Unimplemented (or error in) menu message: %1 for %2'
                                    bindWith:selectorOrBlock
                                    with:aReceiver printString)
                        mayProceed:true.
                    val := nil.
                ].
                val
            ].

        rec perform:selectorOrBlock withArguments:args ifNotUnderstood:fallBack.
    ].
    hasPerformed := true.
    ^ self "/ ^ selectorOrBlock

    "Modified: / 06-03-2012 / 14:49:00 / cg"
    "Modified: / 16-03-2018 / 10:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptItem:anItemOrNil inMenu:aMenu
    |tgState topMenu|

    topMenu := self topMenu.
    topMenu openDelayed:nil.

    (anItemOrNil isNil or:[anItemOrNil hideMenuOnActivated]) ifTrue:[
	topMenu accept:anItemOrNil
    ] ifFalse:[
	anItemOrNil canAccept ifTrue:[
	    tgState := anItemOrNil toggleIndication.

	    self
		accept:anItemOrNil
		index:(aMenu selectionIndex)
		toggle:tgState
		receiver:(aMenu receiver).

	    aMenu do:[:el| el updateIndicators].
	    anItemOrNil hideMenuOnActivated ifFalse:[
		aMenu invalidate
	    ].
	]
    ]

    "Modified: / 29-06-2011 / 14:34:45 / cg"
!

lastItemAccepted
    "returns last item selected or nil"

  ^ lastItem

    "Modified: / 29-06-2011 / 16:24:48 / cg"
!

lastValueAccepted
    "returns last value accepted or nil"

    ^ self lastItemAccepted value
! !

!MenuPanel methodsFor:'accessing'!

accessCharacterPositionAt:stringOrNumber
    "get the access character position for a textLabel"

    ^ self itemAt:stringOrNumber do:[:el| el accessCharacterPosition ]
!

accessCharacterPositionAt:stringOrNumber put:anIndexOrNil
    "get the access character position for a textLabel"

    self itemAt:stringOrNumber do:[:el| el accessCharacterPosition:anIndexOrNil ]
!

accessCharacterPositions
    "returns a collection of accessCharacterPositions or nil"

    ^ self collect:[:anItem| anItem accessCharacterPosition ]
!

accessCharacterPositions:something
    "define accessCharacterPositions for each item"

    self onEachPerform:#accessCharacterPosition: withArgList:something
!

args
    "returns a collection of arguments or nil"

    ^ self collect:[:anItem| anItem argument ]
!

args:something
    "define arguments for each item"

    self onEachPerform:#argument: withArgList:something
!

argsAt:stringOrNumber
    "gets the argument of an item or nil"

    ^ self itemAt:stringOrNumber do:[:el| el argument ]
!

argsAt:stringOrNumber put:anArgument
    "sets the argument of an item"

    self itemAt:stringOrNumber do:[:el| el argument:anArgument ]
!

doAccessCharacterTranslation
    "true if &-chars in a label are to be treated as accessCharacter indicators.
     Can be set to false to leave accessCharacter unchanged"

    ^ doAccessCharacterTranslation ? true

    "Modified: / 02-11-2010 / 10:19:09 / cg"
!

doAccessCharacterTranslation:aBoolean
    "true if &-chars in a label are to be treated as accessCharacter indicators.
     Can be set to false to leave accessCharacter unchanged"

    doAccessCharacterTranslation := aBoolean

    "Modified: / 02-11-2010 / 10:19:14 / cg"
!

enteredItem
    "return the item over which the mouse pointer is located;
     nil if the mouse is not over any item"

    ^ enteredItem

    "Created: / 20.8.1998 / 13:12:34 / cg"
!

groupSizes
    "gets collection of group sizes"

  ^ groupSizes
!

groupSizes:aGroupSizes
    "sets collection of group sizes"

    aGroupSizes = groupSizes ifFalse:[
	groupSizes := aGroupSizes copy.
	self mustRearrange.
    ].
!

hideOnRelease
    ^ hideOnRelease
!

hideOnRelease:aBoolean
    hideOnRelease := aBoolean
!

keyboardMap
    "Return a KeyboardMap used to translate symbolic shortcuts to real key combinations."

    superMenu notNil ifTrue:[ 
        ^ superMenu keyboardMap.
    ].
    originator notNil ifTrue:[ 
        ^ originator keyboardMap.
    ].
    ^ super keyboardMap

    "Created: / 13-03-2017 / 22:52:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelAt:stringOrNumber
    "gets the label of an item or nil"

  ^ self itemAt:stringOrNumber do:[:el| el label ]
!

labelAt:stringOrNumber put:aLabel
    "sets the label of an item"

    self itemAt:stringOrNumber do:[:el| el label:aLabel ]
!

labels
    "returns a collection of labels's or nil"

    ^ self collect:[:anItem| anItem label ]
!

labels:labels
    "define labels for each item"

    |size|

    self disabledRedrawDo:[
	self removeAll.
	size := labels size.

	size > 0 ifTrue:[
	    items := OrderedCollection new:size.
	    labels do:[:aLabel| items add:(Item in:self label:aLabel) ].
	    preferredExtent := nil.     "/ flush cached preferredExtent
	]
    ].
!

menuPerformer:anObject
    "set the menu-receiver. That's the one who gets the messages ( both from myself and
     from all submenus no specific receiver is defined )."

    ^ self receiver:anObject
!

nameKeyAt:stringOrNumber
    "gets the nameKey of an item or nil"

    ^ self itemAt:stringOrNumber do:[:el| el nameKey ]
!

nameKeyAt:stringOrNumber put:aNameKey
    "sets the nameKey of an item"

    self itemAt:stringOrNumber do:[:el| el nameKey:aNameKey ]
!

nameKeys
    "returns a collection of nameKeyss or nil"

    ^ self collect:[:anItem| anItem nameKey ]
!

nameKeys:something
    "define nameKeys for each item"

    self onEachPerform:#nameKey: withArgList:something
!

numberOfItems
    "gets number of items"

    ^ items size
!

originator
    originator notNil ifTrue:[^ originator].
    superMenu notNil ifTrue:[
	^ superMenu originator
    ].
    ^ nil
!

originator: anObject
    "Set the originator object, i.e., who requested this menu to opem.

     If set, keyboard mappings are taken from the originator, i.e,
     `anObject` must respond to #keyboardMap (views and application models do)"

    originator := anObject

    "Created: / 14-03-2018 / 11:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

receiver
    "get the menu-receiver. That's the one who gets the messages ( both from myself and
     from all submenus no specific receiver is defined )."

    (receiver isNil and:[superMenu notNil]) ifTrue:[
        ^ superMenu receiver
    ].
    ^ receiver

    "Modified (format): / 05-02-2018 / 10:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

receiver:anObject
    "set the menu-receiver. That's the one who gets the messages ( both from myself and
     from all submenus no specific receiver is defined )."

    receiver := anObject
!

shortcutKeyAt:stringOrNumber
    "gets the shortCutKey of an item or nil"

    ^ self itemAt:stringOrNumber do:[:el| el shortcutKey ]
!

shortcutKeyAt:stringOrNumber put:aKey
    "sets the shortCutKey of an item"

    self itemAt:stringOrNumber do:[:el| el shortcutKey:aKey ]
!

shortcutKeys
    "returns a collection of shortcutKeys or nil"

    ^ self collect:[:anItem| anItem shortcutKey ]
!

shortcutKeys:something
    "define shortcutKeys for each item"

    self onEachPerform:#shortcutKey: withArgList:something
!

valueAt:stringOrNumber
    "gets value of an item; a block, valueHolder, ..."

    ^ self itemAt:stringOrNumber do:[:el| el value ]
!

valueAt:stringOrNumber put:aBlockOrValueHolderOrSelector
    "sets value of an item; a block, valueHolder, ..."

    self itemAt:stringOrNumber do:[:el| el value:aBlockOrValueHolderOrSelector ]
!

values:something
    "define values for each item"

    self onEachPerform:#value: withArgList:something
! !

!MenuPanel methodsFor:'accessing-behavior'!

disableAll
    "disable all items; not the menu in case of enabled"

    self do:[:anItem| anItem enabled:false]
!

disableAll:collectionOfIndicesOrNames
    "disable an collection of items"

    collectionOfIndicesOrNames do:[:entry| self enabledAt:entry put:false ].
!

enableAll
    "enable all items; not the menu in case of disabled"

    self do:[:anItem| anItem enabled:true]
!

enableAll:collectionOfIndicesOrNames
    "enable an collection of items"

    collectionOfIndicesOrNames do:[:entry| self enabledAt:entry put:true ].
!

enabled
    "returns enabled state"

    ^ enabled
!

enabled:aState
    "change enabled state of menu"

    |state|

    state := aState ? true.

    enabled ~~ state ifTrue:[
	enabled := state.
	self invalidate.
    ].
!

enabledAt:stringOrNumber
    "gets the enabled state of an item or false"

  ^ self itemAt:stringOrNumber do:[:el| el enabled ] ifAbsent:false
!

enabledAt:stringOrNumber put:aState
    "sets the enabled state of an item"

    self itemAt:stringOrNumber do:[:el| el enabled:aState ]
!

exclusivePointer:aBoolean
    "Do nothing here. Compatibility with PopUpListController"

    ^ self
!

isEnabled:stringOrNumber
    "gets the enabled state of an item or false"

    ^ self enabledAt:stringOrNumber
! !

!MenuPanel methodsFor:'accessing-channels'!

enableChannel:aValueHolder
    "set my enableChannel"

    enableChannel notNil ifTrue:[
	enableChannel removeDependent:self
    ].

    (enableChannel := aValueHolder) notNil ifTrue:[
	enableChannel addDependent:self.
    ].
    self enabled:(enableChannel value).
!

menuChannel
    ^ self menuHolder

    "Created: / 27-03-2007 / 08:38:31 / cg"
!

menuHolder:aValueHolder
    "set my menuHolder"

    menuHolder notNil ifTrue:[
	menuHolder removeDependent:self
    ].

    (menuHolder := aValueHolder) notNil ifTrue:[
	menuHolder addDependent:self.
    ].
    self menu:(menuHolder value)
! !

!MenuPanel methodsFor:'accessing-color & font'!

activeBackgroundColor
    "get the background drawing color used to highlight selection"

    ^ styleSheet colorAt:#'menuPanel.activeBackgroundColor'
!

activeForegroundColor
    "get the foreground color used to highlight selections"

    ^ styleSheet colorAt:#'menuPanel.activeForegroundColor'
!

backgroundColor
    "return the background color"

    ^ super viewBackground
!

backgroundColor:aColor
    "set the background drawing color. You should not use this method;
     instead, leave the value as defined in the styleSheet."

    self backgroundColor ~~ aColor ifTrue:[
	super viewBackground:aColor.
	self invalidate "/ RepairNow:true
    ]

    "Modified: / 6.6.1998 / 19:50:06 / cg"
!

buttonActiveBackgroundColor
    "get the background drawing color used to highlight button selection"

    ^ buttonActiveBackgroundColor ? viewBackground

    "Modified: / 19-01-2012 / 11:51:46 / cg"
!

buttonActiveForegroundColor
    "get the foreground drawing color used to highlight button selection"

    ^ styleSheet colorAt:#'button.activeForegroundColor'
		 default:(self foregroundColor)
!

buttonEdgeStyle
    "get the button edge style"

    ^ styleSheet at:#'button.edgeStyle'
!

buttonEnteredBackgroundColor
    "get the background drawing color used to highlight entered button items"

    ^ buttonEnteredBackgroundColor ? viewBackground

    "Modified: / 19-01-2012 / 11:52:17 / cg"
!

buttonEnteredLevel
    "get the 3D-level used to highlight entered button items"

    ^ buttonEnteredLevel "/ ? (styleSheet at:#'menuPanel.buttonEnteredLevel') ? 0
!

buttonHalfLightColor
    "get the background drawing color used to half light button frame"

    ^ styleSheet colorAt:#'button.halfLightColor'
!

buttonHalfShadowColor
    "get the background drawing color used to half shadow button frame"

    ^ styleSheet colorAt:#'button.halfShadowColor'
!

buttonLightColor
    "get the background drawing color used to light button frame"

    ^ styleSheet colorAt:#'menuPanel.buttonLightColor'
!

buttonPassiveBackgroundColor
    "get the background drawing color used for button"

    ^ buttonPassiveBackgroundColor ? viewBackground

    "Modified: / 19-01-2012 / 13:13:59 / cg"
!

buttonShadowColor
    "get the background drawing color used to shadow button frame"

    ^ styleSheet colorAt:#'menuPanel.buttonShadowColor'
!

disabledEtchedForegroundColor
    "return the color used for etching disabled items.
     If nil, no 3D effect is drawn."

    |bg|

    (bg := self backgroundColor) = DefaultBackgroundColor ifFalse:[
	^ bg mixed:0.5 with:Color white
    ].
    ^ styleSheet colorAt:#'menuPanel.disabledEtchedFgColor'

    "Modified: / 28-11-2013 / 16:28:25 / cg"
!

disabledForegroundColor
    "return the foreground color used by disabled items"

    ^ styleSheet colorAt:#'menuPanel.disabledForegroundColor'
!

enteredBackgroundColor
    "return the background color for entered items"

    ^ styleSheet colorAt:#'menu.enteredBackgroundColor'
		 default:(self backgroundColor)
!

enteredForegroundColor
    "return the foreground color for entered items"

    ^ styleSheet colorAt:#'menu.enteredForegroundColor' default:fgColor
!

font:aFont
    "set the font"

    (aFont isNil or:[aFont = gc font]) ifTrue:[ ^ self ].

    super font:aFont.
    self do:[:anItem| anItem fontChanged ].

    (shown and:[superMenu notNil]) ifTrue:[
	self extent:(self preferredExtent)
    ].
    self mustRearrange.
!

foregroundColor
    "return the passive foreground color"

    ^ fgColor
!

foregroundColor:aColor
    "set the foregroundColor drawing color. You should not use this method;
     instead leave the value as defined in the styleSheet."

    aColor ~= fgColor ifTrue:[
        fgColor := aColor onDevice:device.
        self invalidate
    ].
!

maxAbsoluteButtonLevel
    "returns the maximum absolute button level; used to compute the preferred
     extent of a button"

    ^ (styleSheet at:#'menuPanel.maxAbsoluteButtonLevel') ? 0

    "Modified: / 19-01-2011 / 21:21:53 / cg"
!

selectionFrameBrightColor
    "get the selection frame bright color"

    ^ self whiteColor
!

selectionFrameDarkColor
    "get the selection frame dark color"

    ^ self blackColor
!

setFont:aFont
    "set the font if the argument is nonNil;
     Return nil, if the font was unchanged; otherwise, return the old font"

    |currentFont|

    currentFont := gc font.
    (aFont notNil and:[aFont ~= currentFont]) ifTrue:[
	super font:aFont.
    ].
    ^ currentFont
!

suppressSeparatingLines
    ^ self verticalLayout not
    and:[ (styleSheet at:#'menu.suppressSeparatingLinesInToolbar' default:false) ] 
! !

!MenuPanel methodsFor:'accessing-dimensions'!

height
    "default height"

    self hasExplicitExtent ifFalse:[
	^ self preferredHeight
    ].
    ^ super height
!

maxExtent
    |minH pos|

    maxExtent notNil ifTrue:[^ maxExtent].

    device notNil ifTrue:[
        "/ notice, the position-dependent query: if there is a higher secondary screen,
        "/ this makes a difference in where a popUpMenu is allowed...
        pos := self origin.
        pos = (0@0) ifTrue:[
            "called too early"
            minH := device smallestMonitorHeight.
        ] ifFalse:[
            minH := device usableHeightAt:pos.
        ].
        ^ device usableWidth @ (minH - 2)
        "/ ^ self graphicsDevice usableExtent - 5.
    ].
    superMenu notNil ifTrue:[
        ^ superMenu maxExtent
    ].
    "don't know, assume there is no maxExtent"
    self error:'don''t know maxExtent'.

    "Modified: / 15-02-2012 / 19:22:24 / cg"
!

origin:origin
    "changed due to menu in horizontal panel, if the origin
     changed we have to rearrange the menu items if size not fixed"

    |oldLeft|

    (shown and:[mustRearrange not and:[sizeFixed not]]) ifFalse:[
	^ super origin:origin
    ].
    "left partner in horizontal panel toggles visibility"
    oldLeft := self left.
    super origin:origin.
    oldLeft = self left ifFalse:[
	"/ no change notification... so cannot call #mustRearrange
	mustRearrange := true.
	self invalidate.
    ].
!

preferredExtent
    "compute and returns my preferred extent"

    |maxExtent usedExtent|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    usedExtent := self preferredExtentOfItems.
    superView isNil ifTrue:[
        "/ is standalone
        preferredWidth notNil ifTrue:[
            usedExtent x < preferredWidth ifTrue:[
                usedExtent := preferredWidth @ usedExtent y.
            ]
        ]
    ].

    maxExtent := self maxExtent.
    maxExtent notNil ifTrue:[
        usedExtent := usedExtent min:maxExtent.
    ].
    "/ changed due to menu in horizontal panel
    (superView notNil and:[items size == 0] ) ifTrue:[
        self isViewWrapper ifFalse:[ ^ usedExtent ].
    ].

    preferredExtent := usedExtent.
    ^ usedExtent

    "Modified: / 10.10.2001 / 14:57:25 / cg"
!

preferredExtentOfItems
    "compute and returns my preferred extent including all items
        !!!!!! changes have influence on method #rearrangeItems !!!!!!"

    |hasMenu shCtKey extent showAcc sck
     x            "{ Class:SmallInteger }"
     y            "{ Class:SmallInteger }"
     size         "{ Class:SmallInteger }"
     buttonInsetX2 "{ Class:SmallInteger }"
     buttonInsetY2 "{ Class:SmallInteger }"
     labelInsetX  "{ Class:SmallInteger }"
     labelInsetY  "{ Class:SmallInteger }"
     itemMargin   "{ Class:SmallInteger }"
     groupDividerSize "{ Class:SmallInteger }"
    |

    (size := items size) == 0 ifTrue:[
        self isViewWrapper ifTrue:[ ^ subViews first extent ].
        ^ 32 @ 32
    ].
    stringOffsetX := nil.
    buttonInsetX2 := 2 * buttonInsetX.
    buttonInsetY2 := 2 * buttonInsetY.

    self isPopUpView ifFalse:[
        labelInsetX := labelInsetY := 2 * (self enteredLevel abs).
    ] ifTrue:[
        labelInsetX := labelInsetY := 0.
    ].

    x := 0.
    y := 0.
    groupDividerSize := self groupDividerSize.

    self verticalLayout ifFalse:[
        items keysAndValuesDo:[:key :el| |eX eY|
            extent := el preferredExtent.

            "/ check for visibility (extent x ~~ 0)
            (eX := extent x) ~~ 0 ifTrue:[
                eY := extent y.

                el isButton ifTrue:[
                    eX := eX + buttonInsetX2.
                    eY := eY + buttonInsetY2.
                ] ifFalse:[
                    eX := eX + labelInsetX.
                    eY := eY + labelInsetY.
                ].
                key ~~ size ifTrue:[
                    (self hasGroupDividerAt:key) ifTrue:[
                        x := x + groupDividerSize
                    ] ifFalse:[
                        el needsItemSpaceWhenDrawing ifTrue:[
                            x := x + itemSpace
                        ]
                    ]
                ].
                x := x + eX.
                y := y max:eY.
            ]
        ]
    ] ifTrue:[
        hasMenu := false.
        shCtKey := 0.
        showAcc := MenuView showAcceleratorKeys == true.
        y := x.
        x := 0.
        itemMargin := 2 * self itemMargin.

        items keysAndValuesDo:[:key :el| |eX eY|
            extent := el preferredExtent.

            "/ check for visibility (extent x ~~ 0)
            (eX := extent x) ~~ 0 ifTrue:[
                eY := extent y.

                el isButton ifTrue:[
                    eX := eX + buttonInsetX2.
                    eY := eY + buttonInsetY2.
                ] ifFalse:[
                    eX := eX + labelInsetX.
                    eY := eY + labelInsetY.
                ].
                hasMenu ifFalse:[
                    hasMenu := el hasSubmenu
                ].
                (showAcc and:[(sck := el shortcutKeyAsString) notNil]) ifTrue:[
                    shCtKey := shCtKey max:(sck widthOn:self)
                ].
                key ~~ size ifTrue:[
                    (self hasGroupDividerAt:key) ifTrue:[
                        y := y + groupDividerSize
                    ]
                ].
                y := y + eY.
                x := x max:eX.
            ].
        ].
        x := x + itemMargin.

        (hasMenu or:[shCtKey ~~ 0]) ifTrue:[
            shortKeyInset := x + Item labelRightOffset.
            x := shortKeyInset + shCtKey + self subMenuIndicationWidth.

            (shCtKey ~~ 0 and:[hasMenu]) ifTrue:[
                x := x + self shortcutKeyOffset.
            ]
        ].
"/ to have a small inset
        y := y + 1.
"/        x := x + 1.
    ].
    x := x + ((margin + extraMargin)*2).
    y := y + ((margin + extraMargin)*2).

    ^ x @ y
!

preferredWidth:aWidthOrNil
    "used for example by combo box to setup the preferred width for the popup menu.
     If nil (default), the width is computed from the contained items.
     If not nil, the width is the maximum from the contained items and the required width."

    preferredWidth := aWidthOrNil.
!

shortKeyInset
    "left inset of shortcutKey"

    ^ shortKeyInset
!

sizeFixed:aBoolean
    "set/clear the fix-size attribute.
     If true (the default), the menuPanel will not change its size when items become visible/invisible.
     If false, it will resize itself to adapt to the number of visible items"

    sizeFixed := aBoolean.

    sizeFixed ifFalse:[
	"/ changed due to menu in horizontal panel
	superView notNil ifTrue:[ superView addDependent:self ].
    ].
!

stringOffsetXfor:anItem
    "return the x offset for a MenuItem where to draw the text
    "
    |label w|

    anItem isButton ifTrue:[ ^ 0 ].

    stringOffsetX isNil ifTrue:[
        stringOffsetX := 0.

        (self isPopUpView or:[self verticalLayout]) ifTrue:[
            self do:[:el|
                el isVisible ifTrue:[
                    (    (label := el indicatorForm) notNil
                     or:[(label := el choiceForm) notNil]
                    ) ifTrue:[
                        stringOffsetX := stringOffsetX max:(label width + 2).
                    ] ifFalse:[
                        label := el displayLabel.
                        label class == LabelAndIcon ifTrue:[
                            stringOffsetX := stringOffsetX max:(label xOfString).
                        ].
                    ].
                ].
            ].
        ].
    ].
    w := 0.

    (    (label := anItem indicatorForm) notNil
     or:[(label := anItem choiceForm) notNil]
    ) ifTrue:[
        w := label width + 2.
    ].
    stringOffsetX == 0 ifTrue:[
        ^ w
    ].
    w == 0 ifTrue:[
        label := anItem displayLabel.

        label class == LabelAndIcon ifTrue:[
            ^ stringOffsetX - label xOfString
        ].
    ].
    ^ stringOffsetX.

    "Modified: / 14-03-2018 / 10:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subMenuIndicationWidth
    ^ self rightArrow width
! !

!MenuPanel methodsFor:'accessing-interactors'!

iconIndicationDisabledOff
    ^ self registerImageOnDevice:(self class iconIndicationDisabledOff)
!

iconIndicationDisabledOn
    ^ self registerImageOnDevice:(self class iconIndicationDisabledOn)
!

iconIndicationOff
    ^ self registerImageOnDevice:(self class iconIndicationOff)
!

iconIndicationOn
    ^ self registerImageOnDevice:(self class iconIndicationOn)
!

iconRadioGroupDisabledOff
    ^ self registerImageOnDevice:(self class iconRadioGroupDisabledOff)
!

iconRadioGroupDisabledOn
    ^ self registerImageOnDevice:(self class iconRadioGroupDisabledOn)
!

iconRadioGroupEnteredOff
    ^ self registerImageOnDevice:(self class iconRadioGroupEnteredOff)
!

iconRadioGroupEnteredOn
    ^ self registerImageOnDevice:(self class iconRadioGroupEnteredOn)
!

iconRadioGroupOff
    ^ self registerImageOnDevice:(self class iconRadioGroupOff)
!

iconRadioGroupOn
    ^ self registerImageOnDevice:(self class iconRadioGroupOn)
! !

!MenuPanel methodsFor:'accessing-items'!

hasItems
    "return true, if I have items"

    ^ items notEmptyOrNil
!

itemAt:stringOrNumber do:aOneArgBlock
    "evaluate the block for an item and return the result from the block. In case that
     the item does not exist nil is returned"

    ^ self itemAt:stringOrNumber do:aOneArgBlock ifAbsent:nil
!

itemAt:stringOrNumber do:aOneArgBlock ifAbsent:exceptionBlock
    "evaluate teh block for an item and return the result from the block. In case that
     the item does not exists the result of the exception block is returned (no arguments)"

    |item|

    item := self itemAt:stringOrNumber.
    item notNil ifTrue:[ ^ aOneArgBlock value:item ].
    ^ exceptionBlock value
!

itemAtIndex:anIndex
    "returns item at an index or nil"

    ^ items notNil ifTrue:[items at:anIndex ifAbsent:nil] ifFalse:[nil]
!

items
    "returns the list of items or nil.
     Warning: do not change this list - it is mine !!"

    ^ items

    "Modified: / 09-11-2010 / 10:10:40 / cg"
!

itemsDo:aBlock
    items notNil ifTrue:[
	items do:aBlock
    ]

    "Created: / 09-11-2010 / 10:05:54 / cg"
!

itemsDoWithIndex:aBlock
    items notNil ifTrue:[
	items doWithIndex:aBlock
    ]

    "Created: / 09-11-2010 / 10:06:02 / cg"
! !

!MenuPanel methodsFor:'accessing-look'!

buttonActiveLevel
    "get the buttons active level"

    ^ buttonActiveLevel "/ ? (styleSheet at:#'menuPanel.buttonActiveLevel') ? 0
!

buttonPassiveLevel
    "get the buttons passive level"

    ^ buttonPassiveLevel "/ ? (styleSheet at:#'menuPanel.buttonPassiveLevel') ? 0
!

centerItems
    ^ centerItems ? false
!

centerItems:aBoolean
    centerItems := aBoolean
!

fitFirstPanel
    "gets true if the first panel in the menu hierarchy must be fit
     to the extent of its superView

     NOT SUPPORTED"

    ^ false
!

fitFirstPanel:aState
    "sets true if the first panel in the menu hierarchy must be fit
     to the extent of its superView

     NOT SUPPORTED"
!

level:anInt
    anInt ~~ level ifTrue:[
	super level:anInt.
	self mustRearrange
    ]

    "Modified: / 15.11.2001 / 17:42:07 / cg"
!

rightArrow
    rightArrow isNil ifTrue:[
        device isNil ifTrue:[
            ^ SelectionInListView rightArrowFormOn:Screen current
        ].
        rightArrow := SelectionInListView rightArrowFormOn:device
    ].
    ^ rightArrow
!

rightArrowShadow
    ^ rightArrowShadow
!

showGroupDivider
    "get the enabled flag for showing groupDiveders"

    ^ showGroupDivider
!

showGroupDivider:aState
    "set the enabled flag for showing groupDiveders"

    showGroupDivider ~~ aState ifTrue:[
	showGroupDivider := aState.
	self mustRearrange.
    ]
!

showSeparatingLines
    "gets true if drawing of separating lines is enabled."

    ^ showSeparatingLines
!

showSeparatingLines:aState
    "turn on/off drawing of separating lines."

    aState ~~ showSeparatingLines ifTrue:[
	showSeparatingLines := aState.
	self mustRearrange
    ].
!

verticalLayout
    "get the layout: vertical( true ) or horizontal( false )"

    verticalLayout notNil ifTrue:[ ^ verticalLayout ].

    superMenu notNil ifTrue:[ verticalLayout := true ]
		    ifFalse:[ verticalLayout := self isPopUpView ].
    ^ verticalLayout
!

verticalLayout:aState
    "set the layout: vertical( true ) or horizontal( false )"

    aState ~~ verticalLayout ifTrue:[
	verticalLayout isNil ifTrue:[
	    verticalLayout := aState
	] ifFalse:[
	    verticalLayout := aState.
	    self mustRearrange.
	].
    ].
! !

!MenuPanel methodsFor:'accessing-style'!

buttonInsetX
    "returns the verical button space"

    ^ buttonInsetX
!

buttonInsetY
    "returns the verical button space"

    ^ buttonInsetY
!

delayInSecondsBeforeOpeningSubmenu
    "answer the seconds a submenu will be delayed before
    open; an already open submenu than will be closed"

    ^ styleSheet at:#'menu.delayInSecondsBeforeOpeningSubmenu'  default:0.15
!

drawMenuIndicatorSeparatorLine
    ^ true.
"/    ^ styleSheet at:#'menu.drawMenuIndicatorSeparatorLine'  default:false
!

enteredLevel
    "returns the enter-level for an unselected item moved through"

    ^ styleSheet at:#'menu.enteredLevel'  default:0
!

groupDividerSize
    "returns the width of a group divider"

    ^ styleSheet at:#'menu.groupDividerSize' default:6
!

itemMargin
    "returns the margin of an item"

    ^ styleSheet at:#'menu.itemMargin' default:0
!

itemSpace
    "returns the additional space for an item in a (vertical) panel"

    ^ itemSpace
!

menuIndicatorVerticalPosition
    "#center, #top or #bottom"

    ^ #center
    "/ ^ styleSheet at:#'menu.menuIndicatorVerticalPosition' default:#bottom
!

selectionFollowsMouse
    "returns true if the selection follows the mouse"

    ^ styleSheet at:#'menu.selectionFollowsMouse' default:false
!

shortcutKeyOffset
    "returns the offset for a shortcutKey"

    ^ 5
! !

!MenuPanel methodsFor:'accessing-submenu'!

subMenuAt:stringOrNumber
    "gets the current submenu of an item; if the submenu is nil, the
     submenu is generated if specified otherwise nil is returned."

    |submenu|

    self itemAt:stringOrNumber do:[:anItem|
	submenu := anItem currentSubmenu.
	submenu isNil ifTrue:[
	    submenu := anItem setupSubmenu
	].
    ].
    ^ submenu

    "Modified: / 22-09-2010 / 13:53:21 / cg"
!

subMenuAt:stringOrNumber put:aSubMenu
    "sets the submenu of an item"

    self itemAt:stringOrNumber do:[:el| el submenu:aSubMenu ]
!

subMenuShown
    "return the currently visible submenu - or nil if there is none"

    |item submenu|

    item := self selection.

    item notNil ifTrue:[
	submenu := item currentSubmenu.

	(submenu notNil and:[submenu shown]) ifTrue:[
	    ^ submenu
	].
    ].
    ^ nil
! !

!MenuPanel methodsFor:'activation & deactivation'!

closeMenus
    "close all menus without accepting"

    self topMenu accept:nil.
!

hide
    "hide the view, leave its modal event loop"

    "/ TODO: replace with LeaveSignal raise.

    self selection:nil.
    self unmap.
!

show
    "realize the view at its last position;
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAt:(self origin) resizing:true
!

showAt:aPoint
    "realize the view at aPoint.
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAt:aPoint resizing:true
!

showAt:aPoint resizing:aBoolean
    "realize the view at aPoint; return nil if no item was selected,
     or if I have already performed.
     Return the items value, otherwise.
     Notice, that this is returned back to the one who started this
     menu (i.e. the view or controller), which will perform the action
     if a non-nil is returned."

    self origin:aPoint.
    self rearrangeItemsIfItemVisibilityChanged.

    aBoolean ifTrue:[
	self fixSize.
    ].
"/    self makeFullyVisible.   -- done in realize
    self openModal:[true]. "realize     "

    "/ if I have already performed,
    "/ return nil - to avoid items triggering twice.

    self topMenu hasPerformed ifTrue:[
	^ nil
    ].

    ^ self lastValueAccepted

    "Modified: / 29-06-2011 / 16:24:22 / cg"
!

showAtPointer
    "realize the view at the current pointer position.
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAt:(device pointerPosition) resizing:true

    "Modified (format): / 22-07-2011 / 15:24:48 / cg"
!

showCenteredIn:aView
    "make myself visible at the screen center.
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    |top|

    top := aView topView.
    top raise.
    ^ self showAt:(top origin + (aView originRelativeTo:top) + (aView extent // 2) - (self extent // 2))

    "Modified: / 15.9.1998 / 12:45:50 / cg"
!

startUp
    "realize the menu at the current pointer position
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAtPointer
!

startUpAt:aPoint
    "realize the menu at aPoint
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAt:aPoint

    "Created: / 21.5.1998 / 14:15:57 / cg"
!

startUpFor:originatingWidget
    "realize the menu at the current pointer position
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    originator := originatingWidget.
    ^ self startUp
!

startUpOrNil
    "realize the menu at the current pointer position
     return the value of the selectedItem or nil, of none was selected
     (unless the menu has already performed its action, by sending an appropriate message
      to some performer)"

    ^ self showAtPointer
! !

!MenuPanel methodsFor:'adding & removing'!

createAtIndex:anIndexOrNil
    "create an item and add this item to the index. In case of nil, the item
     is added to the end. If the index is not valid nil is returned;
     otherwise the new created item is returned."

    |max item index|

    max := (items size) + 1.

    (index := anIndexOrNil) notNil ifTrue:[
	(anIndexOrNil < 1 or:[anIndexOrNil > max]) ifTrue:[
	    index := max.
	    "/ ^ nil
	]
    ].
    items isNil ifTrue:[
	items := OrderedCollection new
    ] ifFalse:[
	items := items asOrderedCollection
    ].
    item := Item in:self.

    (index isNil or:[index == max]) ifTrue:[
	items add:item
    ] ifFalse:[
	items add:item beforeIndex:index
    ].
    preferredExtent := nil.     "/ flush cached preferredExtent
    self mustRearrange.
    ^ item

    "Modified: / 03-07-2011 / 22:49:47 / cg"
!

remove:stringOrNumber
    "remove the first item which is assigned to stringOrNumber;
     if found, remove and return it"

    |item|

    (item := self itemAt:stringOrNumber) notNil ifTrue:[
	items remove:item.
	items := items asNilIfEmpty.
	item destroy.
	preferredExtent := nil.     "/ flush cached preferredExtent
	self mustRearrange.
    ].
    ^ item

    "Modified: / 09-11-2010 / 10:04:08 / cg"
!

removeAll
    "remove all items and submenus"

    self disabledRedrawDo:[
	self selection:nil.
	groupSizes := nil.
	items notNil ifTrue:[
	    items copy do:[:el| el destroy ].
	].
	items := nil.
	preferredExtent := nil.     "/ flush cached preferredExtent
    ].

    "Modified: / 15.11.2001 / 17:02:51 / cg"
! !

!MenuPanel methodsFor:'change & update'!

update:something with:aParameter from:changedObject

    changedObject == menuHolder    ifTrue:[^ self menu:(menuHolder value)].
    changedObject == enableChannel ifTrue:[^ self enabled:(enableChannel value)].

    changedObject == superView ifTrue:[
	"/ changed due to menu in horizontal panel
	something == #sizeOfView ifTrue:[
	    (shown and:[sizeFixed not]) ifTrue:[
		"/ no change notification... so cannot call #mustRearrange
		mustRearrange := true.
		self invalidate.
	    ].
	].
	^ self
    ].

    super update:something with:aParameter from:changedObject
! !

!MenuPanel methodsFor:'converting'!

asMenu
    "convert contents to a menu"

    |menu|

    menu := Menu new.
    menu groupSizes:groupSizes.
    self do:[:anItem| menu addItem:(anItem asMenuItem) ].
    ^ menu

    "Modified: / 27-03-2007 / 08:39:48 / cg"
!

fromSpec:aMenuSpec
    "build from spec"

    self menu:(Menu decodeFromLiteralArray:aMenuSpec)

    "Modified: / 27-03-2007 / 08:42:43 / cg"
!

menu:aMenu
    "setup from a menu"

    self disabledRedrawDo:[
	|menu newItems menuReceiver|

	self removeAll.

	(menu := aMenu) notNil ifTrue:[
	    (aMenu isCollection) ifTrue:[
		menu := Menu decodeFromLiteralArray:aMenu.
	    ] ifFalse:[
		menuReceiver := menu receiver.
		menuReceiver notNil ifTrue:[
		    self receiver:menuReceiver.
		]
	    ].
	    (newItems := menu menuItems) notEmptyOrNil ifTrue:[
		items := newItems collect:[:ni |
				|i|

				i:= Item in:self.
				i menuItem:ni.
				i.
			    ].
	    ].
	    self groupSizes:(menu groupSizes).
	    preferredExtent := nil.     "/ flush cached preferredExtent
	]
    ]

    "Modified: / 09-11-2010 / 11:52:28 / cg"
! !

!MenuPanel methodsFor:'dependents access'!

addDependencies
    "add all dependencies"

    self do:[:anItem| anItem addDependencies ].

    menuHolder    notNil ifTrue:[menuHolder    addDependent:self].
    enableChannel notNil ifTrue:[enableChannel addDependent:self].
!

removeDependencies
    "remove all dependencies"

    self do:[:anItem| anItem removeDependencies ].

    menuHolder    notNil ifTrue:[menuHolder    removeDependent:self].
    enableChannel notNil ifTrue:[enableChannel removeDependent:self].
! !

!MenuPanel methodsFor:'drawing'!

disabledRedrawDo:aBlock
    "evaluate a block without redrawing within the block; after processing
     of the block a redraw might be performed"

    |state|

    state := mustRearrange.
    mustRearrange := true.
    aBlock value.
    mustRearrange := state.
    self mustRearrange
!

drawButtonEdgesFor:anItem level:aLevel
    |layout|

    aLevel isNil ifTrue:[^ self].
    aLevel == 0 ifTrue:[^ self].

    layout := anItem layout.

    (styleSheet at:'menuPanel.button3D' default:styleSheet is3D) ifFalse:[
        self displayRectangle:layout.
    ] ifTrue:[
        self drawEdgesForX:(layout left)
                         y:(layout top)
                     width:(layout width)
                    height:(layout height)
                     level:aLevel
                    shadow:(self buttonShadowColor)
                     light:(self buttonLightColor)
                halfShadow:(self buttonHalfShadowColor)
                 halfLight:(self buttonHalfLightColor)
                     style:(self buttonEdgeStyle)
    ]

    "Modified: / 06-02-2014 / 14:55:05 / cg"
!

drawFocusForItem:anItem
    |lytItem|

    lytItem := anItem layout.
    self paint:(self blackColor).

    self displayDottedRectangleX:(lytItem left)
                               y:(lytItem top)
                           width:(lytItem width)
                          height:(lytItem height).
!

drawItemsX:x y:y width:w height:h
    "redraw items and groups"

    |isVertical item layout prevClip
     x1             "{ Class:SmallInteger }"
     x2             "{ Class:SmallInteger }"
     y1             "{ Class:SmallInteger }"
     y2             "{ Class:SmallInteger }"
     start          "{ Class:SmallInteger }"
     stop           "{ Class:SmallInteger }"
     size           "{ Class:SmallInteger }"
     groupDivInset  "{ Class:SmallInteger }"
    |

    size := items size.
    isVertical := self verticalLayout.

    isVertical ifTrue:[
        start := items findFirst:[:el| |l| l := el layout. l notNil and:[l bottom > y]].
        start == 0 ifTrue:[ ^ self ].
        y1 := y + h.
        stop := items findFirst:[:el| |l| l := el layout. l notNil and:[l top > y1] ]
                     startingAt:(start + 1).
    ] ifFalse:[
        start := items findFirst:[:el| |l| l := el layout. l notNil and:[l right > x ]].
        start == 0 ifTrue:[ ^ self ].
        x1  := x + w.
        stop := items findFirst:[:el| |l| l := el layout .l notNil and:[l left > x1]]
                     startingAt:(start + 1).
    ].
    stop  == 0 ifTrue:[stop := size] ifFalse:[stop := stop - 1].

    (groupSizes size ~~ 0 and:[showGroupDivider]) ifTrue:[
        groupDivInset := self groupDividerSize // 2.

        groupDivInset ~~ 0 ifTrue:[
            (start ~~ 1 and:[self hasGroupDividerAt:(start-1)]) ifTrue:[
                start := start - 1
            ]
        ].
    ] ifFalse:[
        groupDivInset := 0
    ].

    prevClip := self clippingBoundsOrNil.
    self clippingBounds:(Rectangle left:x top:y width:w height:h).

    start to:stop do:[:i|
        item := items at:i.
        item draw.

        (groupDivInset ~~ 0 and:[i ~~ size and:[self hasGroupDividerAt:i]]) ifTrue:[
            layout := item layout.

            isVertical ifTrue:[
                x1 := layout left.
                x2 := layout right.
                y1 := layout bottom + groupDivInset.
                y2 := y1.
            ] ifFalse:[
                y1 := layout top.
                y2 := layout bottom.
                x1 := layout right + groupDivInset.
                x2 := x1.
            ].
            self paint:shadowColor.
            self displayLineFromX:x1 y:y1 toX:x2 y:y2.
            self paint:lightColor.

            isVertical ifTrue:[y1 := y1 + 1. y2 := y1 ]
                      ifFalse:[x1 := x1 + 1. x2 := x1 ].

            self displayLineFromX:x1 y:y1 toX:x2 y:y2
        ].
        selection == item ifTrue:[
            self focusComesByTab ifTrue:[
                self drawFocusForItem:item.
            ].
        ].
    ].
    self clippingBounds:prevClip.
!

drawLabelEdgeFor:anItem selected:isSelected
    |level layout|

    isSelected ifTrue:[
	level := styleSheet at:#'menu.hilightLevel' default:0.
    ] ifFalse:[
	anItem == enteredItem ifTrue:[ level := self enteredLevel ]
			     ifFalse:[ level := 0 ]
    ].

    level ~~ 0 ifTrue:[
	layout := anItem layout.

	self drawEdgesForX:(layout left)
			 y:(layout top)
		     width:(layout width)
		    height:(layout height)
		     level:level
    ].
!

drawScrollerAt:aDirection bounds:bounds
    "draw a scroller"

    |scrolling icon level x y w h|

    x := bounds left.
    y := bounds top.
    w := bounds width.
    h := bounds height.

    scrolling := self scrollActivity.

    (scrolling activeMenu == self and:[scrolling direction == aDirection]) ifTrue:[
        level := styleSheet at:'menuPanel.scrollButtonActiveLevel' default:-2
    ] ifFalse:[
        level := styleSheet at:'menuPanel.scrollButtonPassiveLevel' default:1
    ].

    self isPopUpView ifFalse:[
        self verticalLayout ifFalse:[
            aDirection == #NEXT ifTrue:[
                icon := scrolling class iconScrollRightM    
            ] ifFalse:[
                aDirection == #PREV ifTrue:[
                    icon := scrolling class iconScrollLeftM    
                ]     
            ]     
        ]     
    ].
    icon isNil ifTrue:[
        icon := scrolling iconAt:aDirection on:self.
    ].
    
    icon displayOn:self x:(x + ((w - icon width) // 2))
                        y:(y + 2 + ((h - 2 - icon height) // 2)).

    level ~~ 0 ifTrue:[
        self drawEdgesForX:x y:y width:w height:h level:level.
    ] ifFalse:[
"/        self paint:lightColor.
"/        self displayLineFromX:x y:2 toX:x+w-1 y:2.
"/        aDirection == #NEXT ifTrue:[    
"/            self displayLineFromX:x y:2 toX:x y:h-1.
"/        ] ifFalse:[    
"/            aDirection == #PREV ifTrue:[    
"/                self paint:shadowColor.
"/                self displayLineFromX:x+w-1 y:2 toX:x+w-1 y:h-1.
"/            ].    
"/        ].    
    ].
!

invalidateItem:anItem repairNow:aBool
    "an item changed; invalidate the items layout"

    |layout|

    (mustRearrange not and:[shown]) ifTrue:[
	layout := anItem layout.

	(layout bottom > margin and:[layout top < (height - margin)]) ifTrue:[
	    self invalidate:(layout "insetBy:-1") repairNow:aBool
	]
    ].

    "Modified: / 29.2.2000 / 11:28:59 / cg"
!

mustRearrange
    "force rearrange (i.e. set the rearrange flag)"

    |oldPref|

    mustRearrange ifFalse:[
        oldPref := preferredExtent.
        preferredExtent := nil.
        mustRearrange := true.
        "/ if I am not yet created/was never created, do nothing
        device notNil ifTrue:[
            self invalidate. "/ RepairNow:true
            (oldPref notNil and:[oldPref ~= self preferredExtent]) ifTrue:[
                dependents notNil ifTrue:[ self changed:#preferredExtent ]
            ].
        ]
    ]

    "Modified: / 6.6.1998 / 19:51:07 / cg"
!

rearrangeGroups
    "implements the groupIdentifier #right/#conditionalRight in a horizontal menu"

    <resource: #style (#'menuPanel.ignoreConditionalStartGroupRight')>

    |layout point
     dltX  "{ Class:SmallInteger }"
     start "{ Class:SmallInteger }"
    |

    (self isPopUpView or:[self verticalLayout]) ifTrue:[
        ^ self
    ].

    layout := items last layout.
    layout notNil ifTrue:[
        (dltX := width - margin - extraMargin - layout right) <= 0 ifTrue:[
            ^ self  "/ no free space
        ].
    ].

    "/ The behavior of #conditionalRight is controlled by the styleSheet.
    "/ If menuPanel.ignoreConditionalStartGroupRight is true, it is ignored.
    "/ otherwise, it is treated like #right.
    "/ This allows for groups to be specified as #right under motif, but
    "/ non-right under win32 (as is used woth the help-menus).
    (StyleSheet at:#'menuPanel.ignoreConditionalStartGroupRight' ifAbsent:false) ifTrue:[
        start := items findFirst:[:anItem| anItem startGroup == #right ].
    ] ifFalse:[
        start := items findFirst:[:anItem| anItem startGroup == #right or:[ anItem startGroup == #conditionalRight ] ].
    ].
    start == 0 ifTrue:[
        ^ self  "/ no right-group item detected
    ].
    
    point := dltX @ 0.

    "/ move items layout to right
    items from:start do:[:anItem|
        anItem isVisible ifTrue:[
            anItem layout moveBy:point.
        ]
    ].
    self updateEnteredItem.

    "Modified: / 10-10-2007 / 00:29:34 / cg"
!

rearrangeItems
    "recompute the layout of each item
        !!!!!! changes have influence on method #preferredExtentOfItems !!!!!!"

    |isVertical extent isPopUpMenu
     x            "{ Class:SmallInteger }"
     y            "{ Class:SmallInteger }"
     x0           "{ Class:SmallInteger }"
     y0           "{ Class:SmallInteger }"
     x1           "{ Class:SmallInteger }"
     y1           "{ Class:SmallInteger }"
     size         "{ Class:SmallInteger }"
     insetX       "{ Class:SmallInteger }"
     insetY       "{ Class:SmallInteger }"
     labelInsetX  "{ Class:SmallInteger }"
     labelInsetY  "{ Class:SmallInteger }"
     itemMargin   "{ Class:SmallInteger }"
     groupDividerSize "{ Class:SmallInteger }"
    |

    (mustRearrange and:[(size := items size) ~~ 0]) ifFalse:[
        mustRearrange := false.
        ^ self
    ].

"/  DON'T SET THIS!!
"/  item layout:  below of first item -> item invalidate
"/                                    -> menuPanel invalidateItem:repairDamage:
"/                                    -> invalidate:rapairDamage:
"/                                    -> redrawX:y:width:height:
"/                                    tries to get uninitialized layout from second item.
"/ This happens in a modal debugger!!
"/    mustRearrange := false.
    isVertical       := self verticalLayout.
    groupDividerSize := self groupDividerSize.
    isPopUpMenu      := self isPopUpView.

    isPopUpMenu ifFalse:[
        labelInsetX := labelInsetY := self enteredLevel abs.
    ] ifTrue:[
        labelInsetX := labelInsetY := 0
    ].

    (isPopUpMenu or:[self hasExplicitExtent not]) ifTrue:[
        |saveExtent maxExtent extentToSet|

        extent := self preferredExtent.

        isPopUpMenu ifTrue:[
            maxExtent := self maxExtent.
            maxExtent notNil ifTrue:[
                extentToSet := isVertical ifTrue:[extent x @ (extent y min:(maxExtent y))]
                                          ifFalse:[(extent x min:(maxExtent x)) @ extent y].
            ].
        ] ifFalse:[
            extent := extentToSet := isVertical ifTrue:[extent x @ 1.0] ifFalse:[1.0 @ extent y].
        ].
        self extent:extentToSet.
    ] ifFalse:[
        extent := self computeExtent
    ].

    x := y := margin + extraMargin.
    
    isVertical ifFalse:[
        y0 := y.
        y1 := extent y - margin - extraMargin.

        items keysAndValuesDo:[:anIndex :el|
            el isVisible ifFalse:[
                el layout:(Rectangle left:x top:y0 right:x bottom:y1)
            ] ifTrue:[
                el isButton ifTrue:[
                    insetX := buttonInsetX.
                    insetY := buttonInsetY.
                ] ifFalse:[
                    insetX := labelInsetX.
                    insetY := labelInsetY.
                ].
                x0 := x  + insetX.
                x1 := x0 + (el preferredWidth).
                el layout:(Rectangle left:x0 top:(y0 + insetY) right:x1 bottom:(y1 - insetY)).
                x := x1 + insetX.

                size ~~ anIndex ifTrue:[
                    (self hasGroupDividerAt:anIndex) ifTrue:[
                        x := x + groupDividerSize
                    ] ifFalse:[
                        el needsItemSpaceWhenDrawing ifTrue:[
                            x := x + itemSpace
                        ]
                    ]
                ]
            ].
        ].
    ] ifTrue:[
        itemMargin := self itemMargin.
        x0 := margin.
        x1 := extent x - margin - itemMargin.  "/ -1

        items keysAndValuesDo:[:anIndex :el|
            el isVisible ifFalse:[
                el layout:(Rectangle left:x0 top:y right:x1 bottom:y)
            ] ifTrue:[
                el isButton ifTrue:[
                    insetX := buttonInsetX.
                    insetY := buttonInsetY.
                ] ifFalse:[
                    insetX := labelInsetX.
                    insetY := labelInsetY.
                ].
                y0 := y  + insetY.
                y1 := y0 + el preferredHeight.
                el layout:(Rectangle left:(x0 + insetX + itemMargin) top:y0 right:(x1 - insetX) bottom:y1).
                y := y1 + insetY.

                size ~~ anIndex ifTrue:[
                    (self hasGroupDividerAt:anIndex) ifTrue:[
                        y := y + groupDividerSize
                    ]
                ]
            ]
        ]
    ].
    self rearrangeGroups.
    selection notNil ifTrue:[self makeItemVisible:selection].
    mustRearrange := false.

    "Modified: / 13.11.2001 / 20:17:21 / cg"
!

rearrangeItemsIfItemVisibilityChanged
    "check for items which can change its visibility;
     if at least one item exists, rearrange all items"

    items isNil ifTrue:[^ self].

    (items contains:[:item | item canChangeVisibility]) ifTrue:[
	mustRearrange := true.
	self rearrangeItems.
    ]

    "Modified: / 03-12-2013 / 17:04:05 / cg"
!

redrawX:x y:y width:w height:h
    "redraw a damage"

    |y0 y1 x0 x1 prvBound mustDrawLeft mustDrawRight nxtBound isScroller|

    (shown and:[w ~~ 0]) ifFalse:[^ self].

    mustRearrange ifTrue:[
        self isPopUpView ifFalse:[
            self explicitExtent:true.

            "/ changed due to menu in horizontal panel
            sizeFixed ifFalse:[
                self preferredExtent.

                preferredExtent notNil ifTrue:[ |lw|
                    lw := (superView width - self left) max: 1.
                    self width:(preferredExtent x min:lw).
                ].
            ].
        ].
        self rearrangeItems.
        self invalidate.
        ^ self
    ].

    "/ self paint:(self viewBackground).
    self clearRectangleX:x y:y width:w height:h.

    items size == 0 ifTrue:[
        ^ self
    ].

    y0 := y.
    y1 := y + h.
    x0 := x.
    x1 := x + w.

    "Draw the scroll handles - especially for Popup-Lists"
    mustDrawLeft := mustDrawRight := false.
    
    self hasScrollers ifTrue:[
        (self hasScrollerAt:#PREV) ifTrue:[
            prvBound := self scrollerBoundsAt:#PREV.

            self verticalLayout ifTrue:[
                (mustDrawLeft := (prvBound bottom > y)) ifTrue:[
                    y0 := prvBound bottom.
                ].
            ] ifFalse:[
                (mustDrawLeft := (prvBound right > x)) ifTrue:[
                    x0 := prvBound right.
                ].
            ].
        ].

        (self hasScrollerAt:#NEXT) ifTrue:[
            nxtBound := self scrollerBoundsAt:#NEXT.

            self verticalLayout ifTrue:[
                (mustDrawRight := (nxtBound top < y1)) ifTrue:[
                    y1 := nxtBound top.
                ]
            ] ifFalse:[
                (mustDrawRight := (nxtBound left < x1)) ifTrue:[
                    x1 := nxtBound left.
                ]
            ].
        ].
    ].
    lastDrawnScrollerNextBounds := nxtBound.

    (y1 > y0 and:[x1 > x0]) ifTrue:[
        self drawItemsX:x0 y:y0 width:(x1 - x0) height:(y1 - y0)
    ].

    mustDrawLeft ifTrue:[
        self drawScrollerAt:#PREV bounds:prvBound.
    ].
    mustDrawRight ifTrue:[
        self drawScrollerAt:#NEXT bounds:nxtBound.
    ].
!

updateEnteredItem
    |mousePoint|

    mousePoint  := device translatePoint:(device pointerPosition)
                           fromView:nil toView:self.

    (self containsPoint:mousePoint) ifTrue:[
        enteredItem := self itemAtPoint:mousePoint
    ].
! !

!MenuPanel methodsFor:'enumerating & searching'!

collect:aOneArgBlock
    "evaluate the argument, aOneArgBlock for every item in the menuPanel
     and return a collection of the results"

    items notNil ifTrue:[^ items collect:aOneArgBlock ].
    ^ nil
!

do:aOneArgBlock
    "evaluate the argument, aOneArgBlock for every item in the menuPanel."

    items notNil ifTrue:[ items do:aOneArgBlock ].
!

findFirst:aOneArgBlock
    "find the index of the first item, for which evaluation of the argument, aOneArgBlock
     returns true; return its index or 0 if none detected."

    items notNil ifTrue:[ ^ items findFirst:aOneArgBlock ].
    ^ 0
!

findLast:aOneArgBlock
    "find the last item, for which evaluation of the argument, aOneArgBlock
     returns true; return its index or 0 if none detected."

    items notNil ifTrue:[ ^ items findLast:aOneArgBlock ].
    ^ 0
!

firstItemSelectable
    "returns the first item which is selectable or nil
    "
    items size > 0 ifTrue:[
	^ items detect:[:anItem| anItem canSelect ] ifNone:nil
    ].
    ^ nil
!

indexOf:something
    "returns index of an item assigned to an index, nameKey, textLabel or value if symbol.
     If no item match 0 is returned. No range checks are performed on a number argument"

    |i v|

    something isNumber ifTrue:[ ^ something ].
    something isNil    ifTrue:[ ^ 0 ].

    i := self findFirst:[:el | (el nameKey = something) or: [el = something]].

    i ~~ 0 ifTrue:[
	^ i
    ].

    something isSymbol ifTrue:[
	i := self findFirst:[:el|
				v := el value.
				v isSymbol and:[v == something]
			    ].
	i ~~ 0 ifTrue:[
	    ^ i
	]
    ].

    (something respondsTo:#string) ifTrue:[
	v := something string.
      ^ self findFirst:[:el | el textLabel = v].
    ].
    ^ 0
!

indexOfItem:anItem
    "returns the index of the item or 0"

    ^ items notNil ifTrue:[items identityIndexOf:anItem] ifFalse:[0]
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aTwoArgBlock for every item in the menuPanel."

    items notNil ifTrue:[ items keysAndValuesDo:aTwoArgBlock ].
! !

!MenuPanel methodsFor:'event handling'!

buttonMotion:state x:x y:y
    "open or close the corresponding submenu"

    |menue motionPoint translatedPoint sensor|

    self scrollActivity isActive ifTrue:[
	^ self
    ].

    sensor := self sensor.
"/ cg: the following seems to lead to leftover submenus to remain unclosed...
"/    (sensor isNil or:[sensor hasButtonMotionEventFor:nil]) ifTrue:[
"/        ^ self
"/    ].
    menue := self detectGrabMenu.

    motionPoint := x@y.
    translatedPoint := menue translateGrabPoint:motionPoint.
    menue handleButtonMotion:state atPoint:translatedPoint.

    "/ hideOnRelease := true.

    (self isPopUpView or:[sensor anyButtonPressed]) ifTrue:[
	^ self
    ].

    hideOnRelease ifTrue:[
	sensor anyButtonPressed ifFalse:[^ self]
    ] ifFalse:[
	sensor anyButtonPressed ifTrue:[^ self]
    ].

    (selection notNil and:[selection visibleSubmenu isNil]) ifTrue:[
	"/ selection on grabView without a submenu (Button ...); check whether moving out
	(self containsPoint:motionPoint) ifFalse:[
	    ^ self accept:nil
	]
    ].

    "Modified: / 13.11.2001 / 20:21:49 / cg"
!

buttonPress:button x:x y:y
    "any button pressed; open or close the corresponding submenus"

    |menu point screen screenPoint targetView targetPoint wg|

    hideOnRelease := true.

    "/ simulate momentary loss of focus to force accept into models in other components
    wg := self windowGroup.
    wg notNil ifTrue:[
        wg focusMomentaryRelease.
    ].

    self scrollActivity stop.
    point := x@y.
    menu  := self detectMenuAtGrabPoint:point.

    menu isNil ifTrue:[
        self accept:nil.

        "/ tell underlying view about the click...
        ((button ~~ 2)
        or:[(button == 2 and:[UserPreferences current showRightButtonMenuOnRelease])]) ifTrue:[
            screen := device.
            screenPoint := screen translatePointToRoot:point fromView:self.
            targetView := screen viewFromPoint:screenPoint.
            (targetView notNil and:[targetView ~~ self]) ifTrue:[
                targetPoint := screen translatePoint:screenPoint fromView:screen rootView toView:targetView.
                targetView buttonPress:button x:targetPoint x y:targetPoint y.
            ]
        ].
    ] ifFalse:[
        point := menu translateGrabPoint:point.
        menu handleButtonPress:button atPoint:point.
    ]

    "Modified: / 02-10-2011 / 09:20:08 / cg"
!

buttonRelease:button x:x y:y
    "button release action; accept selection and close all views"

    |topMenu dstMenu item srcPoint dstPoint subm hideMenuAndPerformAction
     releaseTime menuMapTime|

    hideOnRelease ifFalse:[
	^ self
    ].
    topMenu := self topMenu.
    topMenu openDelayed:nil.

    self scrollActivity stop ifTrue:[
	^ self
    ].
    dstMenu := topMenu activeMenu.
    hideMenuAndPerformAction := dstMenu selection notNil or:[dstMenu isPopUpView not].

    hideMenuAndPerformAction ifTrue:[
	"open topMenu, a popup by click and release button in a short time period"
	(topMenu == self
	and:[mapTime notNil
	and:[dstMenu == self
	and:[dstMenu isPopUpView]]]) ifTrue:[
	    hideMenuAndPerformAction := false.
	].
    ].
    hideMenuAndPerformAction ifFalse:[
	hideOnRelease ifTrue:[
	    releaseTime := windowGroup lastEvent timeStamp.
	    menuMapTime := dstMenu mapTime ? releaseTime.

	    hideMenuAndPerformAction := (releaseTime millisecondDeltaFrom:menuMapTime)
					> (PopUpMenu maxClickTimeToStayOpen).
	].
    ].
    hideMenuAndPerformAction ifTrue:[
	srcPoint := x@y.

	(     (dstMenu := self detectMenuAtGrabPoint:srcPoint) notNil
	 and:[(item    := dstMenu selection) notNil]
	) ifTrue:[
	    item visibleSubmenu notNil ifTrue:[
		dstMenu selection:nil.
		(selection isNil and:[self isPopUpView not]) ifTrue:[
		    self accept:nil.
		].
		^ self
	    ].
	    subm := item currentSubmenu.

	    subm notNil ifTrue:[
		subm shown ifTrue:[^ self].
		"/ test whether any action is assigned to the menu
		"/ if not ignorre accept
		item hasDelayedMenu ifFalse:[^ self].
		"/ handle action defined for the delayed menu
	    ].
	    dstPoint := dstMenu translateGrabPoint:srcPoint.

	    (dstMenu itemAtPoint:dstPoint) == dstMenu selection ifFalse:[
		item := nil
	    ].
	    topMenu acceptItem:item inMenu:dstMenu.
	    ^ self
	].

	(selection notNil and:[dstMenu == self]) ifTrue:[
	    selection visibleSubmenu notNil ifTrue:[
		^ self
	    ]
	].
	self accept:nil.
    ].
!

handleSizeChanged:how
    "used to handle the scrollers and groups in a none popUpView
    "
    |layouts damage isVertical scrollBound|

    (mustRearrange or:[items size == 0 or:[self isPopUpView]]) ifTrue:[
	^ self
    ].
    mustRearrange := true.

    shown ifFalse:[
	^ self
    ].
    layouts := OrderedCollection new.

    items do:[:el| |layout|
	(layout := el layout) isNil ifTrue:[
	    self invalidate.
	    ^ self.
	].
	layouts add:layout.
    ].
    isVertical  := self verticalLayout.
    scrollBound := self scrollerBoundsAt:#NEXT.

    self rearrangeItems.

    items keysAndValuesDo:[:i :el| |newLyt oldLyt|
	damage isNil ifTrue:[
	    newLyt := el layout.
	    oldLyt := layouts at:i ifAbsent:newLyt.

	    newLyt ~= oldLyt ifTrue:[ |x y start|
		start := 0.

		i > 1 ifTrue:[
		    isVertical ifTrue:[
			x := 0.
			y := start := (oldLyt top min:(newLyt top)) min:(height - scrollBound height).
		    ] ifFalse:[
			y := 0.
			x := start := (oldLyt left min:(newLyt left)) min:(width - scrollBound width).
		    ].
		].
		start <= 20 ifTrue:[
		    self invalidate.
		    ^ self
		].
		damage := Rectangle left:x top:y extent:(self extent).
	    ].
	].
    ].
    damage isNil ifTrue:[
	damage := scrollBound.
    ].
    scrollBound := lastDrawnScrollerNextBounds.
    scrollBound notNil ifTrue:[
	damage := damage merge:scrollBound
    ].
    self invalidate:damage.

    "Modified: / 29-06-2011 / 16:24:59 / cg"
!

keyPress:key x:x y:y
    "any key is pressed"

    <resource: #keyboard (#Escape
			  #Tab #FocusNext #FocusPrevious
			  #CursorLeft #CursorRight )>

    |menu menusSuperMenu sensor|

    sensor := self sensor.

"/    sensor anyButtonPressed ifTrue:[
"/        ^ self  "/ ignored while any button is pressed
"/    ].

    self scrollActivity isActive ifTrue:[
	key ~~ #Escape ifTrue:[
	    ^ self
	].
	self scrollActivity stop
    ].

       (key == #Tab
    or:[key == #FocusNext
    or:[key == #FocusPrevious]]) ifTrue:[
	self accept:nil.
	^ super keyPress:key x:x y:y
    ].

    menu := self detectGrabMenu.
    menusSuperMenu := menu superMenu.

    (key == #Escape) ifTrue:[
	"/ must hide the active menu
	menusSuperMenu notNil ifTrue:[
	    "/ hide active menu but keep the grab
	    menusSuperMenu selection hideSubmenu
	] ifFalse:[
	    "/ hide active menu and ungrab
	    self accept:nil
	].
	^ self
    ].

    menu isViewWrapper ifFalse:[
	sensor compressKeyPressEventsWithKey:key.
	menu handleKeyPress:key.
	^ self
    ].
    menusSuperMenu == self ifFalse:[^ self].

    "/ allow cursor movement
    (key == #CursorLeft or:[key == #CursorRight]) ifTrue:[
	(self containsPoint:x@y) ifTrue:[
	    self handleKeyPress:key.
	]
    ].
!

mapped
    super mapped.

    "/ if I come up with a pressed button, react on release instead.
    gc device anyButtonPressed ifTrue:[ hideOnRelease := true ].
!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime
    "mousewheel action"

    |menu|

    menu := self detectGrabMenu.
    menu isViewWrapper ifTrue:[
        menu superMenu ~~ self ifTrue:[^ self].
        menu := self.
    ].
    "/ support line and page scrolling
    menu shown ifTrue:[
        self window sensor shiftDown ifTrue:[
            amount > 0 ifTrue:[menu pageUp]
                      ifFalse:[menu pageDown].
        ] ifFalse:[
            amount > 0 ifTrue:[menu scrollUp]
                      ifFalse:[menu scrollDown].
        ].
    ].
!

pointerLeave:state
    |sensor|

    self scrollActivity isActive ifTrue:[^ self].

    self detectGrabMenu handlePointerLeave:state.

    (selection isNil or:[self isPopUpView]) ifTrue:[
	^ self
    ].

    selection visibleSubmenu notNil ifTrue:[^ self].

    windowGroup focusView ~~ self ifTrue:[
	self accept:nil
    ] ifFalse:[
	selection isButton ifTrue:[
	    sensor := self sensor.

	    sensor isNil ifTrue:[
		self accept:nil
	    ] ifFalse:[
		"/ I'have the focus; if no button pressed, than keep the selection
		sensor anyButtonPressed ifTrue:[
		    self selection:nil
		]
	    ].
	]
    ].
!

sizeChanged:how
    "redraw #right groups"

"/    self isPopUpView ifFalse:[
"/        mustRearrange := true.
"/        self invalidate
"/    ].
"/    ^ super sizeChanged:how.

    self handleSizeChanged:how.
    super sizeChanged:how.
! !

!MenuPanel methodsFor:'event handling-processing'!

clearImplicitGrab
    implicitGrabView := lastPointerView := nil.
!

dispatchEvent:ev withFocusOn:focusView delegate:doDelegate
    "dispatch and handle an event"

    |view x y p syntheticEvent menu|

    ev isDamage ifTrue:[
        ^ super dispatchEvent:ev withFocusOn:focusView delegate:false.
    ].
    device isNil ifTrue:[
        "/ 'MenuPanel - leftover event ignored' infoPrintCR.
        ^ self
    ].

    (superMenu isNil and:[ev isButtonPressEvent]) ifTrue:[
        focusView ~~ self ifTrue:[prevFocusView := focusView].
    ].

    "/ situation: we get a buttonPress, set implicitGrab (for scrollbars etc.)
    "/ but never get the buttonRelease, since someone else (a popUp) grabbed the
    "/ pointer in the meantime, and has eaten the release event ... (double-sigh)
    implicitGrabView notNil ifTrue:[
        self sensor leftButtonPressed ifFalse:[
            self clearImplicitGrab.
        ].
    ].

    ((x := ev x) isNil or:[(y := ev y) isNil]) ifTrue:[
        ^ super dispatchEvent:ev withFocusOn:focusView delegate:false.
    ].

    implicitGrabView notNil ifTrue:[
        ev isButtonEvent ifTrue:[
            p := device translatePoint:(x@y) fromView:self toView:implicitGrabView.
            ev view:implicitGrabView.
            ev arguments at:2 put:p x.
            ev arguments at:3 put:p y.
            implicitGrabView dispatchEvent:ev withFocusOn:focusView delegate:false.

            ev isButtonReleaseEvent ifTrue:[
                self clearImplicitGrab.
            ].
            ^ self
        ]
    ].
    menu := self detectMenuAtGrabPoint:(x@y).

    (menu isNil or:[menu isViewWrapper not]) ifTrue:[
        self clearImplicitGrab.
        ^ super dispatchEvent:ev withFocusOn:focusView delegate:false
    ].

    p := menu translateGrabPoint:(x@y).
    view := self detectViewAtX:(p x) y:(p y) in:menu.
    view == self ifTrue:[^self].  "MB:changed - recursion"

    p := device translatePoint:(x@y) fromView:self toView:view.

    ev isButtonPressEvent ifTrue:[
        (view wantsFocusWithButtonPress) ifTrue:[
            view requestFocus.
        ].
        view ~~ self ifTrue:[ "/ can this ever be self ?
            implicitGrabView := view.
        ]
    ].

    ev isButtonMotionEvent ifTrue:[
        lastPointerView ~~ view ifTrue:[
            "/ must generate enter/leave ... (sigh)
            lastPointerView notNil ifTrue:[
                "/ XXX: should be fixed
                syntheticEvent := WindowEvent pointerLeave:0 view:lastPointerView.
                lastPointerView dispatchEvent:syntheticEvent withFocusOn:nil delegate:false.
            ].
            view notNil ifTrue:[
                syntheticEvent := WindowEvent pointerEnter:0 x:x y:y view:view.
                view dispatchEvent:syntheticEvent withFocusOn:nil delegate:false.
            ].
            lastPointerView := view.
        ].
    ].

    ev view:view.
    ev x:p x.
    ev y:p y.
    view dispatchEvent:ev withFocusOn:focusView delegate:false.

    "Modified: / 10.10.2001 / 13:54:47 / cg"
!

handleButtonMotion:state atPoint:motionPoint
    "open or close the corresponding submenus"

    |menu item translatedPoint containsPoint direction|

    containsPoint := self containsPoint:motionPoint.
    (containsPoint not and:[items size > 0]) ifTrue:[
	"/ check if there is still open a menu which is not assigned to the
	"/ current selection
	item := items detect:[:el| el visibleSubmenu notNil ] ifNone:nil.
	item notNil ifTrue:[
	    |visibleSubmenu point|

	    visibleSubmenu := item visibleSubmenu.
	    visibleSubmenu notNil ifTrue:[
		point := self translateMenuPoint:motionPoint toMenu:visibleSubmenu.

		(visibleSubmenu containsPoint:point) ifTrue:[
		    selection notNil ifTrue:[ selection invalidate ].
		    selection := item.
		    selection invalidate.
		    visibleSubmenu becomesActiveMenu.
		    ^ self.
		].
	    ].
	    item := nil.
	].
    ].
    containsPoint ifTrue:[
	item := self itemAtPoint:motionPoint
    ].

    "no autoscroll, if the mouse pointer is inside the scroll button"
    direction := self scrollerDirectionAtPoint:motionPoint.
    direction notNil ifTrue:[
	self pointerEntersItem:nil.

	self sensor anyButtonPressed ifTrue:[
	    self scrollActivity startIfRequiredAt:direction on:self comesViaButtonPress:false.
	].
	^ self
    ].

    "/ self pointerEntersItem:item.

    (state == 0 or:[self sensor anyButtonPressed not]) ifTrue:[
	(self selectionFollowsMouse
	 and:[self topMenu focusComesByTab not]
	) ifTrue:[
	    self isPopUpView ifTrue:[
		item isNil ifTrue:[
		    superMenu notNil ifTrue:[
			translatedPoint := self translateMenuPoint:motionPoint toMenu:superMenu.
			superMenu handleButtonMotion:state atPoint:translatedPoint.
		    ]
		] ifFalse:[
		    self selectAndOpenDelayed:item.
		].
	    ] ifFalse:[
		"/ processing in the toolbar
		(item notNil and:[self hasSelection and:[item canSelect]]) ifTrue:[
		    self selectAndOpenDelayed:item.
"/                    self selection:item openMenu:true.
		].
	    ].
	].
	^ self
    ].

    containsPoint ifTrue:[
	self isPopUpView ifTrue:[
	    self selectAndOpenDelayed:item.
	] ifFalse:[
	    "/ also open delayed if I am the top-menu
	    self selectAndOpenDelayed:item.
"/            self selection:item openMenu:true.
	].
	^ self
    ].

    menu := self superMenuAtPoint:motionPoint.
    menu notNil ifTrue:[
	translatedPoint := self translateMenuPoint:motionPoint toMenu:menu.
	menu handleButtonMotion:state atPoint:translatedPoint.
	^ self
    ].
    self isPopUpView ifTrue:[
	self selection:nil
    ].
!

handleButtonPress:button atPoint:aPoint
    "a button pressed; open or close the corresponding submenus"

    |item scrollerDirectionOrNil wasSelected|

    "/ is a scroller-button present and hit ?
    scrollerDirectionOrNil := self scrollerDirectionAtPoint:aPoint.
    scrollerDirectionOrNil notNil ifTrue:[
        (self scrollActivity startIfRequiredAt:scrollerDirectionOrNil on:self comesViaButtonPress:true) ifTrue:[
            self pointerEntersItem:nil.
            ^ self
        ]
    ].

    item := self itemAtPoint:aPoint.
    item isNil ifTrue:[
        self selection:nil openMenu:false.
        ^ self
    ].

    "/ right button always immediately pulls the delayedMenu
    button == 2 ifTrue:[
        item hasDelayedMenu ifTrue:[
            self selection:item openMenu:false.
            self openDelayed:item afterSeconds:0.
            ^ self.
        ].
    ].

    wasSelected := (selection == item).
    wasSelected ifFalse:[
        self selection:item openMenu:true.
        "/ make sure that a momentary press is visible
        (item hasIndication or:[item hasSubmenu and:[item hasDelayedMenu not]]) ifFalse:[
            self repairDamage.
            Delay waitForSeconds:0.1.
        ].
    ].
    item hasDelayedMenu ifTrue:[
        "/ clicked on the arrow icon ?
        (item menuIndicatorContains:aPoint) ifTrue:[
            self selection:item openMenu:false.
            self openDelayed:item afterSeconds:0.
            ^ self.
        ].
        ^ self
    ].

    (item isToggle or:[item triggerOnDown]) ifFalse:[
        (wasSelected and:[item hasSubmenu and:[item visibleSubmenu isNil]]) ifTrue:[
            item toggleSubmenuVisibility
        ].
        ^ self
    ].
    (item canAccept and:[item == self selection]) ifFalse:[
        ^ self
    ].
    self invalidateItem:item repairNow:true.
    self acceptItem:item inMenu:self.

    [ (device notNil and:[device anyButtonPressed]) ] whileTrue:[
        "/ using device - sensor is not updated sometimes
        Delay waitForSeconds:0.1.
    ].
    self sensor flushUserEvents.
    self selection:nil.

    "Created: / 13-11-2001 / 14:12:04 / cg"
    "Modified: / 20-11-2016 / 13:20:04 / cg"
!

handleCursorKey:aKey
    "handle a cursor key"

    |next menu item isVrt backKey p1 p2
     idx0  "{ Class:SmallInteger }"
     idx   "{ Class:SmallInteger }"
     size  "{ Class:SmallInteger }"
    |
    (size  := items size) == 0 ifTrue:[
	superMenu notNil ifTrue:[superMenu handleCursorKey:aKey].
	^ self
    ].

    isVrt := self verticalLayout.

    selection isNil ifTrue:[
	(isVrt and:[aKey == #CursorDown]) ifTrue:[
	    idx := items findFirst:[:el | el notNil and:[ el canSelect ]].
	    idx ~~ 0 ifTrue:[
		self selection:(items at:idx).
		^ self
	    ]
	].
	(isVrt and:[aKey == #CursorUp]) ifTrue:[
	    idx := items findLast:[:el | el notNil and:[ el canSelect ]].
	    idx ~~ 0 ifTrue:[
		self selection:(items at:idx).
		^ self
	    ]
	]
    ].

    (    (isVrt     and:[aKey == #CursorUp    or:[aKey == #CursorDown]])
     or:[(isVrt not and:[aKey == #CursorRight or:[aKey == #CursorLeft]])]
    ) ifTrue:[
	selection isNil ifTrue:[
	    (superMenu notNil and:[superMenu verticalLayout == isVrt]) ifTrue:[
		^ superMenu handleCursorKey:aKey
	    ].
	    idx := 0.

	    isVrt ifTrue:[
		"/ used because of vertical scrolling
		idx := items findFirst:[:el| el layout top > 0 ].
		idx ~~ 0 ifTrue:[idx := idx - 1 ]
	    ].
	] ifFalse:[
	    idx := self indexOf:selection.
	].
	next := aKey == #CursorRight or:[aKey == #CursorDown].

	idx0 := idx.
	size timesRepeat:[
	    |el|

	    next ifTrue:[idx := idx + 1] ifFalse:[idx := idx - 1].

	    idx > size ifTrue:[
		idx := 0 "1"
	    ] ifFalse:[
		idx < 0 ifTrue:[
		    idx := size
		]
	    ].

	    idx == 0 ifTrue:[
		self selection:nil.
		^ self
	    ] ifFalse:[
		(el := items at:idx ifAbsent:nil) notNil ifTrue:[
		    el canSelect ifTrue:[
			el hasDelayedMenu ifTrue:[
			    "/ do not open menu
			    self selection:el openMenu:false
			] ifFalse:[
			    "/ open comes from style-sheet
			    self selection:el.
			].
			^ self
		    ].
		]
	    ].
	    idx == idx0 ifTrue:[
		^ self
	    ].
	].
	^ self
    ].

    superMenu notNil ifTrue:[
	p1 := self translateGrabPoint:0.
	p2 := superMenu translateGrabPoint:0.
    ].

    isVrt ifTrue:[
	(superMenu notNil and:[p1 x > p2 x]) ifTrue:[
	    backKey := #CursorRight
	] ifFalse:[
	    backKey := #CursorLeft.
	]
    ] ifFalse:[
	(superMenu notNil and:[p1 y > p2 y]) ifTrue:[
	    backKey := #CursorDown
	] ifFalse:[
	    backKey := #CursorUp.
	]
    ].

    aKey == backKey ifTrue:[
	superMenu isNil ifTrue:[
	    self accept:nil
	] ifFalse:[
	    superMenu verticalLayout ~~ isVrt ifTrue:[
		superMenu handleCursorKey:aKey
	    ] ifFalse:[
		superMenu selection hideSubmenu
	    ]
	].
	^ self
    ].

    selection isNil ifTrue:[
	superMenu isNil ifTrue:[^ self accept:nil].

	superMenu verticalLayout ~~ isVrt ifTrue:[
	    superMenu handleCursorKey:aKey
	] ifFalse:[
	    (item := items findFirst:[:el| el canSelect]) notNil ifTrue:[
		self selectionIndex:item
	    ]
	].
	^ self
    ].

    selection hasSubmenu ifTrue:[
	(menu := selection visibleSubmenu) isNil ifTrue:[
	    selection toggleSubmenuVisibility
	] ifFalse:[
	    menu selectionIndex:1
	]
    ] ifFalse:[
	superMenu notNil ifTrue:[
	    superMenu verticalLayout ~~ isVrt ifTrue:[
		superMenu handleCursorKey:aKey
	    ]
	] ifFalse:[
	    self accept:nil
	]
    ].
!

handleKeyPress:key
    <resource: #keyboard (#CursorDown #CursorUp #CursorLeft #CursorRight #Return)>

    "any key is pressed"

    |item inMenu|

    (key == #Return or:[key == Character space]) ifTrue:[
        self handleReturnPressed.
        ^ true.
    ].
    key isCharacter ifTrue:[
"/            selection notNil ifTrue:[
"/                inMenu := self
"/            ] ifFalse:[
"/                (inMenu := superMenu) isNil ifTrue:[^ self].
"/            ].
        inMenu := self.

        (item := inMenu detectItemForKey:key) notNil ifTrue:[
            inMenu selection:item
        ].
        ^ true
    ].
    (key == #CursorDown
        or:[key == #CursorUp
        or:[key == #CursorLeft
        or:[key == #CursorRight]]])
    ifTrue:[
        self handleCursorKey:key.
        ^ true
    ].
    "/ handle scrolling keys"
    key == #EndOfLine    ifTrue:[self scrollToBottom. ^ true ].
    key == #BeginOfLine  ifTrue:[self scrollToTop. ^ true.].
    key == #NextPage     ifTrue:[self pageDown. ^ true.].
    key == #PreviousPage ifTrue:[self pageUp. ^ true.].

    ^ false.
!

handlePointerLeave:state
    self  pointerEntersItem:nil.
    super pointerLeave:state
!

handleReturnPressed
    "any key is pressed"

    |sensor subm item|

    (item := selection) isNil ifTrue:[
	superMenu notNil ifTrue:[
	    item := superMenu selection.

	    item value notNil ifTrue:[
		"/ is a delayed menu
		self accept:item
	    ] ifFalse:[
		item toggleSubmenuVisibility
	    ]
	] ifFalse:[
	    self accept
	].
	^ self
    ].
    selection hasSubmenu ifTrue:[
	selection hasDelayedMenu ifFalse:[
	    selection toggleSubmenuVisibility.
	  ^ self
	].
	subm := selection currentSubmenu.

	(subm notNil and:[subm shown]) ifTrue:[
	    selection toggleSubmenuVisibility.
	  ^ self
	].
	self openDelayed:nil
    ].
    self accept.

    " test for toggle "
    item isToggle ifTrue:[
	self selection:item.
    ] ifFalse:[
	(selection notNil and:[selection triggerOnDown]) ifFalse:[
	    ^ self
	]
    ].

    (sensor := self sensor) isNil ifTrue:[
	^ self
    ].

    [
	sensor flushKeyboardFor:nil.
	Delay waitForSeconds:0.1.
	sensor hasKeyPressEventFor:nil.
    ] whileTrue.
!

pointerEntersItem:anItemOrNil
    "the pointer moves over an item or nil; restore the old item and
     redraw the new item highlighted."

    |oldItem newItem|

    (     anItemOrNil notNil
     and:[anItemOrNil canSelect
     and:[selection isNil
     and:[self isPopUpView not]]]) ifTrue:[
	anItemOrNil isButton ifTrue:[
	    (    self buttonEnteredBackgroundColor ~= self buttonPassiveBackgroundColor
	     or:[self buttonEnteredLevel ~= self buttonPassiveLevel]
	    ) ifTrue:[
		newItem := anItemOrNil
	    ]
	] ifFalse:[
	    (self enteredLevel ~~ 0
	      or:[self enteredBackgroundColor ~= self backgroundColor]
	    ) ifTrue:[
		newItem := anItemOrNil
	    ]
	]
    ].

    newItem ~~ enteredItem ifTrue:[
	oldItem     := enteredItem.
	enteredItem := newItem.

	oldItem notNil ifTrue:[
	    self invalidateItem:oldItem repairNow:(enteredItem isNil).
	].

	enteredItem notNil ifTrue:[
	    self invalidateItem:enteredItem repairNow:true.
	].
    ].
!

processHideMenuEvent:ev
    "to be filled..."

    "Modified: / 29-06-2011 / 16:39:36 / cg"
!

processMenuEnterItemEvent:ev
    "to be filled..."

    "Created: / 29-06-2011 / 13:18:05 / cg"
    "Modified: / 29-06-2011 / 16:39:29 / cg"
!

processMenuSelectItemEvent:ev
    |winGrp masterGroup winGrpForBusyCursor item itemIndex itemValue menuReceiver acceptAction|

    winGrp := self windowGroup.
    winGrp notNil ifTrue:[
	masterGroup := winGrp previousGroup.
    ].
    winGrpForBusyCursor := masterGroup ? winGrp.

    item := ev item.
    itemIndex := ev itemIndex.
    itemValue := ev itemValue.
    menuReceiver := ev menuReceiver.

    acceptAction := [ self accept:item index:itemIndex toggle:itemValue receiver:menuReceiver ].

    (item showBusyCursorWhilePerforming
    and:[winGrpForBusyCursor notNil])
    ifTrue:[
	winGrpForBusyCursor withWaitCursorDo:acceptAction
    ] ifFalse:[
	acceptAction value
    ].

    "Modified: / 29-06-2011 / 16:32:36 / cg"
! !

!MenuPanel methodsFor:'focus handling'!

canTab
    "depends whether I'am a toolbar and selectable items exists
    "
    |selectableItem|

    (super canTab and:[self isPopUpView not]) ifTrue:[
	selectableItem := self firstItemSelectable.
	^ selectableItem notNil
    ].
    ^ false
!

focusComesByTab
    "returns true if focus comes by tab and should be drawn"

    focusComesByTab == true ifTrue:[
	(shown and:[self hasFocus]) ifTrue:[
	    ^ true
	].
	focusComesByTab := false.
    ].
    ^ false

    "Modified: / 29-06-2011 / 16:23:09 / cg"
!

focusComesByTab:aBoolean
    "only handled for toolBars"

    |selectableItem|

    (self supportsFocusOnTab and:[self isPopUpView not]) ifTrue:[
	focusComesByTab := aBoolean.

	self hasSelection ifTrue:[
	    ^ self
	].

	aBoolean ifTrue:[
	    selectableItem := self firstItemSelectable.
	].
	self selection:selectableItem openMenu:false.
    ].

    "Modified: / 29-06-2011 / 16:23:19 / cg"
!

hasKeyboardFocus:aBoolean
    "notification from the windowGroup that I got/lost the keyboard focus."

    self isPopUpView ifTrue:[
	"/ not visible for popup menus
	^ super hasKeyboardFocus:aBoolean
    ].

"/    (aBoolean not and:[hasImplicitGrap ~~ true]) ifTrue:[
"/        (windowGroup focusView ~~ self) ifTrue:[
"/            self selection:nil.
"/        ].
"/    ].
    super hasKeyboardFocus:aBoolean.
!

showFocus:focusComesByTab
    self focusComesByTab:focusComesByTab.
    super showFocus:focusComesByTab.
!

showNoFocus:focusByTab
    self focusComesByTab:false.
    super showNoFocus:focusByTab.
!

supportsFocusOnTab
    "returns true if focus is supported
    "
    ^ (styleSheet at:#'focusHighlightStyle') == #win95
!

wantsFocusWithButtonPress
    "needs only the focus if I'am a toolbar; all events are delegated
     to my subMenus"

"/ old:
"/    ^ self isPopUpView not

    "/ I am not sure how this really should be -
    "/ I guess, it needs a more intelligent and dynamic decision.
    "/ for now, the menuPanelTakesFocusOnClick returns true, otherwise,
    "/ we cannot control menus with the keyboard.
    self isPopUpView ifTrue:[
	^ false
    ] ifFalse:[
	^ UserPreferences current menuPanelTakesFocusOnClick.
    ]
! !

!MenuPanel methodsFor:'grabbing'!

doGrab
    relativeGrabOrigin := nil.

    superMenu notNil ifTrue:[
        superMenu doGrab
    ] ifFalse:[
        hasImplicitGrap ~~ true ifTrue:[
            self grabMouseAndKeyboard.
            hasImplicitGrap := true
        ]
    ]
!

doUngrab:forceDo

    relativeGrabOrigin := nil.
    self clearImplicitGrab.

    superMenu notNil ifTrue:[
	forceDo ifTrue:[
	    superMenu doUngrab:true
	].
	^ self
    ].

    hasImplicitGrap ~~ true ifTrue:[
	^ self
    ].

    forceDo ifFalse:[
	(selection notNil or:[prevFocusView == self]) ifTrue:[
	    ^ self
	].
    ].
    self ungrabMouseAndKeyboard.
    self selection:nil.
    hasImplicitGrap := nil.
    prevFocusView   := nil.
!

grabKeyboard
    "grap the keyboard; keep previous grab"

    previousKeyboardGrab := device activeKeyboardGrab.
    ^ super grabKeyboard
!

grabMouseAndKeyboard
    "get exclusive access to pointer and keyboard"

    |winGroup sensor activeGrab|

    winGroup := self windowGroup.

    (realized and:[winGroup notNil]) ifTrue:[
        prevFocusView isNil ifTrue:[
             prevFocusView := winGroup focusView.
        ].
        sensor := self sensor.

        device activePointerGrab ~~ self ifTrue:[
            sensor flushMotionEventsFor:nil.

            (self grabPointer) ifFalse:[
                Delay waitForSeconds:0.1.
                (self grabPointer) ifFalse:[
                    "give up"
                    'MenuPanel [warning]: could not grab pointer' errorPrintCR.
                    self unmap
                ]
            ]
        ].

        (activeGrab := device activeKeyboardGrab) ~~ self ifTrue:[
            device sync.
            "/ cg: mhmh - should we flush for all or for the activeGrab only ?
"/            activeGrab notNil ifTrue:[
"/                sensor flushKeyboardFor:activeGrab.
"/            ].
            sensor flushKeyboardFor:nil.
            self grabKeyboard.
        ]
    ]


    "Modified: / 2.2.1998 / 23:43:59 / stefan"
    "Modified: / 15.3.1999 / 12:01:38 / cg"
!

grabPointerWithCursor:aCursorOrNil
    "grap the pointer; keep previous grab"

    previousPointerGrab := device activePointerGrab.
    hasImplicitGrap := true.
    ^ super grabPointerWithCursor:aCursorOrNil
!

ungrabKeyboard
    "ungrap the keyboard; restore previous grab"

    super ungrabKeyboard.

    (previousKeyboardGrab notNil
    and:[ previousKeyboardGrab realized ]) ifTrue:[
        device grabKeyboardInView:previousKeyboardGrab.
    ].
!

ungrabMouseAndKeyboard
    "ungrab resources (mouse and keyboard)"

    self ungrabPointer.
    self ungrabKeyboard.
!

ungrabPointer
    "ungrap the pointer; restore previous grab"

    super ungrabPointer.

    (previousPointerGrab notNil
    and:[ previousPointerGrab realized ]) ifTrue:[
        device grabPointerInView:previousPointerGrab.
    ].
! !

!MenuPanel methodsFor:'help'!

flyByHelpSpec
    "allows subclasses to provide texts"

    pluggableHelpSpecProvider notNil ifTrue:[
        ^ pluggableHelpSpecProvider flyByHelpSpec.
    ].    
    ^ Dictionary new.
!

flyByHelpSpecProvider:aSpecProvider
    "pluggable helpspec provider"

    pluggableHelpSpecProvider := aSpecProvider
!

flyByHelpTextAt:aPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item).
     If there is a selection, that items helpText is used (ignoring the given point)."

    |scrollerDirectionOrNil|

    "/ is a scroller-button present and hit ?
    scrollerDirectionOrNil := self scrollerDirectionAtPoint:aPoint.
    scrollerDirectionOrNil notNil ifTrue:[
	^ 'Scroll Menu Items'
    ].

    self withMenuAndItemAt:aPoint do:[:menu :item | ^ menu flyByHelpTextForItem:item].
    ^ nil
!

flyByHelpTextForItem:anItem
    "returns the helpText for an item (empty if none)"

    anItem isNil ifTrue:[^ nil].
    ^ anItem flyByHelpText.
!

flyByHelpTextForKey:aKey
    |app text spec|

    app := self application.
    app notNil ifTrue:[
        text := app flyByHelpTextForKey:aKey.
        text notNil ifTrue:[^ text].
    ].
    spec := self flyByHelpSpec.
    spec isNil ifTrue:[^ nil].
    ^ spec at:aKey ifAbsent:nil
!

helpText
    "return the helpText for the currently selected item (empty if none)"

    ^ self helpTextForItem:selection
!

helpTextAt:aPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item).
     If there is a selection, that items helpText is used (ignoreing the given point)."

    |scrollerDirectionOrNil|

    "/ is a scroller-button present and hit ?
    scrollerDirectionOrNil := self scrollerDirectionAtPoint:aPoint.
    scrollerDirectionOrNil notNil ifTrue:[
	^ 'Scroll Menu Items'
    ].

    self withMenuAndItemAt:aPoint do:[:menu :item | ^ menu helpTextForItem:item].
    ^ nil
!

helpTextForItem:anItem
    "returns the helpText for an item (empty if none)"

    anItem isNil ifTrue:[^ nil].
    ^ anItem activeHelpText.
!

withMenuAndItemAt:srcPoint do:aBlock
    |dstMenu dstPoint item|

    dstMenu := self detectMenuAtGrabPoint:srcPoint.
    dstMenu notNil ifTrue:[
	dstPoint := dstMenu translateGrabPoint:srcPoint.
	item := dstMenu itemAtPoint:dstPoint.
	aBlock value:dstMenu value:item.
    ]
! !

!MenuPanel methodsFor:'image registration'!

imageOnMyDevice:anImage
    "returns image registered on device"

    ^ self class image:anImage value onDevice:device
!

lightenedImageOnDevice:anImage
    "returns lightened image registered on device"

    ^ self class lightenedImage:anImage onDevice:device
! !

!MenuPanel methodsFor:'initialization & release'!

addToCurrentProject
    "ignored here"
!

create
    "create the shadow view for a none contained submenu"

    super create.

    self isPopUpView ifTrue:[
        (PopUpView shadowsOnDevice:device) ifTrue:[
            shadowView isNil ifTrue:[
                shadowView := (ShadowView onDevice:device) for:self
            ] ifFalse:[
                self saveUnder:true.
            ].
        ]
    ] ifFalse:[
        self hasExplicitExtent ifTrue:[
            (self width) == (superView width) ifTrue:[
                self verticalLayout:false
            ]
        ]
    ]

    "Modified: / 28.7.1998 / 02:11:44 / cg"
!

destroy
    "destroy items and shadowView; remove dependencies"

    self clearLastActiveMenu.
    items notNil ifTrue:[items copy do:[:el|el destroy]].
    items := nil.
    self removeDependencies.

    super destroy.
    prevFocusView := superMenu := nil.
    shadowView notNil ifTrue:[shadowView destroy].

    "Modified: / 15.11.2001 / 17:08:45 / cg"
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    |style|

    superMenu notNil ifTrue:[
        styleSheet := superMenu styleSheet
    ].

    super fetchDeviceResources.

    "/ that's a kludge - will be replaced by values from the styleSheet ...
    "/ (i.e. read menu.buttonActiveLevel & menu.buttonPassiveLevel)

    superMenu isNil ifTrue:[
        rightArrow isNil ifTrue:[
            rightArrow := SelectionInListView rightArrowFormOn:device.
        ].
        fgColor := fgColor onDevice:device.
        style   := styleSheet name.

        (style ~~ #os2 and:[style ~~ #win95 and:[style ~~ #winXP]]) ifTrue:[
            rightArrowShadow := SelectionInListView rightArrowShadowFormOn:device
        ] ifFalse:[
            rightArrowShadow := nil
        ].
    ] ifFalse:[
        rightArrow       := superMenu rightArrow.
        rightArrowShadow := superMenu rightArrowShadow.

        self foregroundColor:(superMenu foregroundColor).
        self             font:(superMenu font).
"/        self  viewBackground:(superMenu viewBackground).
    ].

    items notNil ifTrue:[
        items do:[:eachItem| eachItem fetchDeviceResources ]
    ].

    "Modified: / 15.9.1998 / 12:51:29 / cg"
!

initStyle
    "initialize style specific stuff"

    <resource: #style (#'menu.buttonItemHorizontalSpace' #'menu.buttonItemSpace'
                       #'menu.buttonItemVerticalSpace'   #'menu.itemSpace'
                       #'menu.itemHorizontalSpace'
                       #'menu.extraMargin'
                       #'button.activeBackgroundColor'
                       #'button.buttonEnteredBackgroundColor'
                       #'button.buttonPassiveBackgroundColor'
                       #'popup.hideOnRelease'
                       )>
    |fn|

    super initStyle.

    buttonInsetX := styleSheet at:#'menu.buttonItemHorizontalSpace'.
    buttonInsetX isNil ifTrue:[ buttonInsetX := styleSheet at:#'menu.buttonItemSpace' default:0 ].
    buttonInsetX := buttonInsetX abs.

    buttonInsetY := styleSheet at:#'menu.buttonItemVerticalSpace'.
    buttonInsetY isNil ifTrue:[ buttonInsetY := styleSheet at:#'menu.buttonItemSpace' default:0 ].
    buttonInsetY := buttonInsetY abs.

    itemSpace := styleSheet at:#'menu.itemHorizontalSpace'.
    itemSpace isNil ifTrue:[ 
        itemSpace := styleSheet at:#'menu.itemSpace' default:[ gc font widthOf:' '] 
    ].
    extraMargin := styleSheet at:#'menu.extraMargin' default:0.

    fgColor := DefaultForegroundColor.
    fgColor isNil ifTrue:[ fgColor := Color black ].
    DefaultBackgroundColor notNil ifTrue:[ viewBackground := DefaultBackgroundColor ].
    fn := self class defaultFont.
    fn notNil ifTrue:[ self font:fn ].

    defaultHideOnRelease := styleSheet at:#'popup.hideOnRelease' default:true.

    buttonActiveBackgroundColor := styleSheet colorAt:#'button.activeBackgroundColor'.
    buttonEnteredBackgroundColor := styleSheet colorAt:#'button.buttonEnteredBackgroundColor'.
    buttonPassiveBackgroundColor := styleSheet colorAt:#'button.buttonPassiveBackgroundColor'.

    buttonActiveLevel := styleSheet at:#'menu.buttonActiveLevel' default:nil.
    buttonActiveLevel isNil ifTrue:[
        buttonActiveLevel := styleSheet at:#'button.activeLevel' default:0.
    ].    
    buttonPassiveLevel := styleSheet at:#'menu.buttonPassiveLevel' default:nil.
    buttonPassiveLevel isNil ifTrue:[
        buttonPassiveLevel := styleSheet at:#'button.passiveLevel' default:0.
    ].    
    buttonEnteredLevel := styleSheet at:#'menu.buttonEnteredLevel' default:nil.
    buttonEnteredLevel isNil ifTrue:[
        buttonEnteredLevel := styleSheet at:#'button.enteredLevel' default:0.
    ].    
    
    self updateLevelAndBorder.

    "Modified (format): / 19-01-2012 / 13:19:19 / cg"
!

initialize
    "set default configuration"

    mustRearrange       := false.
    sizeFixed := true.
    extraMargin := 0.
    
    super initialize.

    self enableMotionEvents.  "/ for flyByHelp
    enabled := true.
    self originChangedFlag:false extentChangedFlag:false.
    "/ explicitExtent      := nil.
    shortKeyInset       := 0.
    showSeparatingLines := false.
    showGroupDivider    := true.
    hideOnRelease := defaultHideOnRelease.
!

map
    "grab the pointer here, when visible (but not if control has already been lost).
     If the grab fails, try again and unmap myself if that fails too."

    |loIndices loItems|

    enteredItem := nil.

    self enableMotionEvents.
    self becomesActiveMenu.
    super map.
    self addDependencies.

    loIndices := InitialSelectionQuerySignal query.
    loItems   := items ? #[].

    loItems do:[:anItem| anItem fetchImages ].

    self isPopUpView ifTrue:[
	self doGrab
    ] ifFalse:[
	super viewBackground:(self backgroundColor).
    ].
    loItems do:[:el| el updateIndicators ].

    loIndices size > 0 ifTrue:[
	self redrawX:0 y:0 width:width height:height.
	self openMenusFromItemIndices:loIndices.
    ].

    "Modified: / 19.11.1998 / 12:59:00 / cg"
    "Modified: / 18.3.1999 / 18:22:18 / stefan"
!

realize
    "realize menu and shadowView"

    |bgColor|

    self isPopUpView ifTrue:[
	bgColor := styleSheet colorAt:'menu.backgroundColor'.
	bgColor notNil ifTrue:[ self viewBackground:bgColor ].

	"Because of #saveUnder of ShadowView the order of realize is significant:
	 shadowView must be realized before self"
	self hiddenOnRealize:true.
	super realize.
	self resize.
	self makeFullyVisible.
"/        self mustRearrange.
	shadowView notNil ifTrue:[
	    shadowView realize.
	].
	self raise.
	self map.
    ] ifFalse:[
	super realize.
    ].
    self allSubViewsDo:[:aView| aView realize ].
    "/ hideOnRelease := defaultHideOnRelease.
!

recreate
    "this is called after a snapin or a migration.
     If the image was saved with an active menu, hide the menu"

    selection := nil.
    super recreate.
!

reinitStyle
    "handle style change while being open (win32 only - for now)"

    super reinitStyle.

    self fetchDeviceResources.
    self mustRearrange.      "/ care for changed font sizes etc.

    self do:[:anItem |
	anItem reinitStyle
    ].

    "Created: / 10.9.1998 / 21:37:05 / cg"
    "Modified: / 17.8.2000 / 18:01:33 / cg"
!

unmap
    "unmap the view - the view stays created (but invisible), and can be remapped again later.
     If we have a popup supermenu, it will get all keyboard and mouse events."

    mapTime := nil.

    "hide all submenus opened within the menu"
    self itemsDo:[:eachItem|
	eachItem visibleSubmenu notNil ifTrue:[ eachItem hideSubmenu ].
    ].

    self removeDependencies.
    self clearLastActiveMenu.
    self doUngrab:(superMenu isNil).
"/    self isPopUpView ifTrue:[
"/         self doUngrab:(superMenu isNil)
"/    ].
    prevFocusView := nil.
    super unmap.
    shadowView notNil ifTrue:[shadowView unmap].
!

updateLevelAndBorder
    "update level & border"

    <resource: #style (#'popup.borderWidth'
                       #'popup.borderColor'
                       #'popup.level'
                       #'pullDownMenu.level'
                       )>

    |bw bc lvl|

    self isPopUpView ifTrue:[
        bw  := styleSheet at:#'popup.borderWidth' default:1.
        lvl := styleSheet at:#'popup.level'       default:0.
    ] ifFalse:[
        bw  := styleSheet is3D ifFalse:[1] ifTrue:[0].
        lvl := styleSheet at:#'pullDownMenu.level' default:1.
    ].
    bw ~~ 0 ifTrue:[
        bc  := styleSheet at:#'popup.borderColor' default:self blackColor.
        self borderColor:bc
    ].
    self borderWidth:bw.
    self level:lvl.
! !

!MenuPanel methodsFor:'keyboard control'!

mnemonicViewNext:aKeyEvent
    "a  mnemonicKey event as forwarded from the keyboardProcessor - if there
     is the mnemonic-key defined for any menuItem, handle the menuItem and
     return the topMenu otherwise nil."

    |menu uKey lKey list index accessCharacterMatchQuery maxShortCutSearchLevel|

    superMenu notNil ifTrue:[ ^ superMenu mnemonicViewNext:aKeyEvent ].
    shown ifFalse:[^ nil].

    uKey := aKeyEvent rawKey last asUppercase.
    lKey := uKey asLowercase.

    accessCharacterMatchQuery :=
	[:el|
	    |k|

	    k := el accessCharacter.
	    k == uKey or:[k == lKey]
	].
    maxShortCutSearchLevel := self class maxShortCutSearchLevel.

    selection notNil ifTrue:[
	"first lookup the current grapMenu before starting in the topMenu
	"
	menu := self detectGrabMenu.

	[ menu ~~ self ] whileTrue:[
	    index := menu selectionIndex.
	    list  := menu
			selectItemIndicesFor:accessCharacterMatchQuery
			maxDepth:maxShortCutSearchLevel from:(index + 1) to:99999
			ignoreSubmenuBlock:[:anItem| anItem ignoreMnemonicKeys ].

	    list size ~~ 0 ifTrue:[
		"/ has item which responds to the mnemonic
		menu processCollectedShortcutIndices:list.
		^ self
	    ].
	    menu := menu superMenu.
	].
	index := self selectionIndex.
	list  := self
		    selectItemIndicesFor:accessCharacterMatchQuery
		    maxDepth:maxShortCutSearchLevel from:(1 + index) to:99999
		    ignoreSubmenuBlock:[:anItem| anItem ignoreMnemonicKeys ].

    ] ifFalse:[
	index := 99999.
	list  := nil.
    ].

    list isNil ifTrue:[
	list := self
		    selectItemIndicesFor:accessCharacterMatchQuery
		    maxDepth:maxShortCutSearchLevel from:1 to:index
		    ignoreSubmenuBlock:[:anItem| anItem ignoreMnemonicKeys ].


	list isNil ifTrue:[
	    "/ must clear existing selection
	    self selection:nil.
	    ^ nil
	]
    ].

    "/ has item which responds to the mnemonic
    self processCollectedShortcutIndices:list.

    "Modified: / 06-10-2011 / 16:25:21 / cg"
!

openMenusFromItemIndices:anItemIndiceList
    "open all menus derived from sequence of item indices"

    |item|

    anItemIndiceList size == 0 ifTrue:[
	^ self
    ].
    item := self itemAt:(anItemIndiceList removeFirst).

    (item notNil and:[item enabled]) ifTrue:[
	InitialSelectionQuerySignal answer:anItemIndiceList do:[
	    self selection:item openMenu:true.
	]
    ].
!

processCollectedShortcutIndices:indices
    |menu item|

    indices size == 0 ifTrue:[
	^ self
    ].
    menu := self.

    "/ first lookup in current open submenus
    [menu selectionIndex == indices first] whileTrue:[
	(    (item := menu selection) isNil
	 or:[(menu := item currentSubmenu) isNil]
	) ifTrue:[ "/ selected but no submenu open - not handled
	    ^ self
	].
	indices removeFirst.

	indices isEmpty ifTrue:[
	   menu selection:nil.
	    ^ self
	]
    ].
    menu openMenusFromItemIndices:indices.

    "Modified: / 24-03-2011 / 11:19:38 / cg"
    "Created: / 06-10-2011 / 16:19:30 / cg"
!

processShortcut:aKeyEvent
    "a shortcutKey event as forwarded from the keyboardProcessor.
     If there is a shortcut-key defined, process it and return true.
     Otherwise return false."

    |menu rawKey logicalKey list item selectableItem|

    superMenu notNil ifTrue:[
        ^ superMenu processShortcut:aKeyEvent
    ].
    shown ifFalse:[^ false].

    logicalKey := aKeyEvent key.

    "/ fast check, cursor keys are not supported

    ( #( CursorDown CursorUp CursorRight CursorLeft Return Escape
       ) includes:logicalKey
    ) ifTrue:[
        ^ false.
    ].

    rawKey := aKeyEvent rawKey.
    item := nil.
    menu := self detectGrabMenu. "/ first lookup the current grabMenu before starting in the topMenu

    "/ special for Cmd-only event (i.e. ALT-only)
    aKeyEvent isKeyReleaseEvent ifTrue:[
        selection isNil ifTrue:[
            prevFocusView := self windowGroup focusView.
            self requestFocus. "/ self windowGroup focusView:self.
            selectableItem := self firstItemSelectable.
            self selection:selectableItem openMenu:false.
        ] ifFalse:[
            prevFocusView requestFocus.
            self selection:nil.
        ].
        ^ true
    ].

    Menu::NeedResourcesQuery answer:false do:[

        [true] whileTrue:[
            list := menu
                        selectItemIndicesFor:[:el|
                            |skey|

                            item := el.
                            el ignoreShortcutKeys ifTrue:[
                                false
                            ] ifFalse:[
                                skey := el shortcutKey.
                                skey == rawKey or:[skey == logicalKey]
                            ]
                        ]
                        maxDepth:(self class maxShortCutSearchLevel) from:1 to:99999
                        ignoreSubmenuBlock:[:anItem | anItem ignoreShortcutKeys ].

            list size ~~ 0 ifTrue:[
                "/ has item which responds to the shortcut
                item hasSubmenu ifFalse:[
                    menu accept:item
                ] ifTrue:[
                    menu processCollectedShortcutIndices:list.
                    self requestFocus. "/ self windowGroup focusView:self.
                ].
                ^ true
            ].

            menu == self ifTrue:[ ^ false ].
            menu := self.
        ].
    ].
    ^ false     "/ never reached

    "Modified: / 06-10-2011 / 16:19:27 / cg"
!

selectItemIndicesFor:aOneArgBlock maxDepth:maxDepth from:aStart to:aStop ignoreSubmenuBlock:ignoreSubmenueBlock
    "returns the sequence of indices up to the item for which the block returns true.
     The first entry is the topmenu, the last entry the item for which the block returns
     true. If no item is detected, nil is returned.
     If the ignoreSubmenueBlock is not nil, the menu under the item (argument to the block)
     is created and passed through if the block returns false.
     Otherwise the item is not asked for its submenu."

    |start stop|

    maxDepth <= 0 ifTrue:[^ nil].

    start := aStart max:1.
    stop  := aStop  min:(items size).

    start to:stop do:[:i|
	|item menu result|

	item := items at:i.
	(item enabled and:[item isVisible]) ifTrue:[
	    (aOneArgBlock value:item) ifTrue:[
		^ OrderedCollection with:i
	    ].

	    maxDepth > 1 ifTrue:[
		(item hasSubmenu and:[item hasDelayedMenu not]) ifTrue:[
		    (ignoreSubmenueBlock isNil or:[(ignoreSubmenueBlock value:item) not]) ifTrue:[
			menu := item setupSubmenu.

			(menu notNil and:[menu isEnabled]) ifTrue:[
			    result := menu
					selectItemIndicesFor:aOneArgBlock
					maxDepth:(maxDepth - 1) from:1 to:99999
					ignoreSubmenuBlock:ignoreSubmenueBlock.

			    result notNil ifTrue:[
				result addFirst:i.
				^ result
			    ].
			].
		    ].
		].
	    ].
	].
    ].
    ^ nil

    "Modified: / 18-10-2006 / 10:30:00 / cg"
! !

!MenuPanel methodsFor:'misc'!

raiseDeiconified
    ^ self raise

    "Created: 21.6.1997 / 13:29:12 / cg"
!

superMenu
    "returns supermenu or nil"

    ^ superMenu
!

topMenu
    "returns the topMenu; the one having no superMenu"

    |menu smenu|

    menu := self.

    [(smenu := menu superMenu) notNil] whileTrue:[
	menu := smenu
    ].
    ^ menu
! !

!MenuPanel methodsFor:'printing & storing'!

printOn:aStream
    |label|

    aStream nextPutAll:'Menu:'.

    self do:[:eachItem|
        label := eachItem label.
        label notEmptyOrNil ifTrue:[
            aStream nextPutAll:'  '.
            label printOn:aStream.
        ].
    ].
! !

!MenuPanel methodsFor:'private'!

application
    "optimize access to retrive the application"

    application notNil ifTrue:[^ application ].

    superMenu notNil ifTrue:[
	application := superMenu application.
	^ application
    ].
    application := super application.
    ^ application
!

detectItem:aBlock
    "returns the item for which aBlock returns true."

    items notNil ifTrue:[
	items keysAndValuesDo:[:anIndex :anItem|
	    (aBlock value:anItem) ifTrue:[^ anItem].
	].
    ].
    ^ nil
!

detectItemForKey:aKey
    "returns the item assigned to a key, accessCharacter or starts with.
     if no item is detected nil is returned."

    |cIdx uKey lKey item|

    items isNil ifTrue:[^ nil].

    cIdx := self selectionIndex.
    uKey := aKey asUppercase.
    lKey := aKey asLowercase.

    items keysAndValuesDo:[:anIndex :anItem|
	|char label|

	(     anIndex ~~ cIdx
	 and:[anItem canSelect
	 and:[(label := anItem textLabel) notNil
	 and:[label size ~~ 0]]]
	) ifTrue:[
	    (char := anItem accessCharacter) notNil ifTrue:[
		(char == uKey or:[char == lKey]) ifTrue:[
		    ^ anItem
		]
	    ] ifFalse:[
		char := label at:1.

		(char == uKey or:[char == lKey]) ifTrue:[
		    anIndex > cIdx ifTrue:[
			^ anItem
		    ].
		    item isNil ifTrue:[item := anItem]
		]
	    ]
	]
    ].
    ^ item
!

detectItemForLabel:aLabel
    ^ self detectItem:[:anItem | anItem label = aLabel].
!

detectItemForNameKey:aKey
    ^ self detectItem:[:anItem | anItem nameKey == aKey].
!

onEachPerform:aSelector withArgList:aList
    "on each item perform selector with an argument derived from aList"

    aList isCollection ifTrue:[
	items size >= aList size ifTrue:[
	    aList keysAndValuesDo:[:anIndex :anArg|
		(items at:anIndex) perform:aSelector with:anArg
	    ]
	]
    ] ifFalse:[
	self do:[:anItem| anItem perform:aSelector with:aList ]
    ]
!

registerImageOnDevice:anImage
    anImage isNil ifTrue:[ ^ nil ].
    ^ self class image:anImage onDevice:device

"/    |image|
"/
"/    (image := anImage) notNil ifTrue:[
"/        image device ~~ device ifTrue:[
"/            image := image copy.
"/        ].
"/        image := image onDevice:device.
"/        image := image clearMaskedPixels.
"/    ].
"/    ^ image
!

superMenu:aSuperMenu
    "set my supermenu from which i'am activated"

    superMenu := aSuperMenu.

    superMenu notNil ifTrue:[
	styleSheet       := superMenu styleSheet.
	rightArrow       := superMenu rightArrow.
	rightArrowShadow := superMenu rightArrowShadow.
    ].
! !

!MenuPanel methodsFor:'private-activation'!

activeMenu
    "returns the current active menu or self (the top menu)"

    ^ lastActiveMenu ? self

    "Created: / 27.2.1998 / 17:41:15 / cg"
!

activeMenu:aMenu
    "set the current active menu"

    lastActiveMenu := aMenu

    "Created: / 27.2.1998 / 17:41:16 / cg"
!

becomesActiveMenu
    "submenu becomes the active menu"

    mapTime isNil ifTrue:[
	"/ set the mapTime if not yet done
	mapTime := Timestamp now.
    ].
    self topMenu activeMenu:self.

    "Created: / 27.2.1998 / 17:41:23 / cg"
!

clearLastActiveMenu
    "reset the current active menu"

    |top|

    top := self topMenu.

"/    prevFocusView notNil ifTrue:[
"/        self windowGroup focusView:prevFocusView.
"/        prevFocusView := nil.
"/    ].
"/
    top activeMenu == self ifTrue:[
	top activeMenu:nil
    ]

    "Created: / 27.2.1998 / 17:41:17 / cg"
!

mapTime
    "get the time the menu was activated or nil"

    ^ mapTime

    "Modified: / 27.2.1998 / 17:41:18 / cg"
!

mapTime:aTimestamp
    "set the time the menu was activated"

    mapTime := aTimestamp.

    "Modified: / 27.2.1998 / 17:41:18 / cg"
! !

!MenuPanel methodsFor:'private-scrolling'!

hasScrollerAt:aDirection
    "returns true if a visible scroller at a direction exists"

    self hasScrollers ifTrue:[ |layout item|
        aDirection == #PREV ifTrue:[
            item   := items detect:[:each|(each layout notNil and:[each isVisible])] ifNone:[^ false ].
            layout := item layout.

          ^ self verticalLayout ifTrue:[ layout top  < margin]
                               ifFalse:[ layout left < margin]
        ].
        aDirection == #NEXT ifTrue:[
            "/ must check for visibility
            item   := items detectLast:[:each|(each layout notNil and:[each isVisible])] ifNone:[^ false ].
            layout := item layout.

          ^ self verticalLayout ifTrue:[ layout bottom > (height - margin)]
                               ifFalse:[ layout right  > (width  - margin)]
        ].
    ].
    ^ false
!

hasScrollers
    "returns true if scrollers are needed"

    |maxExtent first last isVert|

    (mustRearrange or:[items size <= 1]) ifTrue:[^ false].

    isVert := self verticalLayout.

    superView notNil ifTrue:[
	((first := items first layout) isNil
	 or:[(last  := items last layout) isNil]
	) ifTrue:[
	    ^ false
	].
	isVert ifTrue:[
	    ^ first top < 0 or:[last bottom > height]
	].
	^ first left < 0 or:[last right > width]
    ].
    maxExtent := self maxExtent.
    isVert ifTrue:[
	^ (height >= maxExtent y)
    ].
    ^ (width >= maxExtent x)
!

indexOfFirstItemShown
    "answer the index of the first item shown (scrolling) or 0"
    items size == 0 ifTrue:[^ 0].

    self verticalLayout ifTrue:[
        ^ items findFirst:[:each|(each layout notNil and:[each layout top >= 0 and:[each isVisible]])].
    ].
    ^ items findFirst:[:each|(each layout notNil and:[each layout left >= 0 and:[each isVisible]])].
!

indexOfItemAtScroller:aDirection
     <resource: #obsolete>

    "returns the index of the item under the scroller or 0"

    |bounds min max layout|

    self hasScrollers ifFalse:[ ^ 0 ].
    bounds := self scrollerBoundsAt:aDirection.

    self verticalLayout ifTrue:[
        min := bounds top.
        max := bounds bottom.

        items keysAndValuesDo:[:anIndex :anItem|
            anItem isVisible ifTrue:[
                layout := anItem layout.

                (layout top < max and:[layout bottom > min]) ifTrue:[
                    ^ anIndex
                ].
            ].
        ].
    ] ifFalse:[
        min := bounds left.
        max := bounds right.

        items keysAndValuesDo:[:anIndex :anItem|
            anItem isVisible ifTrue:[
                layout := anItem layout.

                (layout left < max and:[layout right > min]) ifTrue:[
                    ^ anIndex
                ].
            ].
        ]
    ].
    ^ 0
!

indexOfLastItemShown
    "answer the index of the last item shown (scrolling) or 0"

    items size == 0 ifTrue:[^ 0].

    self verticalLayout ifTrue:[
        ^ items findLast:[:each|(each layout notNil and:[each layout bottom <= height and:[each isVisible]])].
    ].
    ^ items findLast:[:each|(each layout notNil and:[each layout right <= width and:[each isVisible]])].
!

makeItemVisible:anItem
    "make an item visible"

    |boundsPREV boundsNEXT delta layout index scr0 scr1 windowSz scrSz doScroll
     isVertical boundsMin layoutMin boundsMax layoutMax dltOrg
     inv1 inv2|

    (     anItem notNil
     and:[self hasScrollers
     and:[(layout := anItem layout) notNil]]
    ) ifFalse:[
	^ self
    ].
    index      := self indexOfItem:anItem.
    boundsPREV := self scrollerBoundsAt:#PREV.
    boundsNEXT := self scrollerBoundsAt:#NEXT.

    isVertical := self verticalLayout.

    isVertical ifTrue:[
	boundsMin := boundsPREV bottom.
	boundsMax := boundsNEXT top.
	layoutMin := layout top.
	layoutMax := layout bottom.
	windowSz  := height.
    ] ifFalse:[
	boundsMin := boundsPREV right.
	boundsMax := boundsNEXT left.
	layoutMin := layout left.
	layoutMax := layout right.
	windowSz  := width.
    ].


    layoutMin < boundsMin ifTrue:[
	layoutMin >= 0 ifTrue:[
	    ^ self
	].
	"/ test whether is first visible item
	index := items findLast:[:el| el isVisible] startingAt:(index - 1).

	index == 0 ifTrue:[ scr0 := margin ]
		  ifFalse:[ scr0 := boundsMin ].

	delta := layoutMin negated + scr0.
    ] ifFalse:[
	layoutMax > boundsMax ifFalse:[
	    ^ self
	].
	"/ test whether is last visible item
	index  := items findFirst:[:el| el isVisible ] startingAt:(index + 1).

	index == 0 ifTrue:[ scr0 := windowSz - margin ]
		  ifFalse:[ scr0 := boundsMax ].

	delta := scr0 - layoutMax.
    ].
    delta == 0 ifTrue:[ ^ self ].

    doScroll := false.

    shown ifTrue:[
	delta abs < (windowSz / 2) ifTrue:[
	    doScroll := true.
	    self repairDamage
	]
    ].
    isVertical ifTrue:[ dltOrg := 0@delta ] ifFalse:[dltOrg := delta@0].
    items do:[:el| el moveBy:dltOrg ].

    doScroll ifFalse:[
	self invalidate.
	^ self
    ].

    windowSz  := windowSz - margin - margin.

    scr0  := boundsMin.
    scr1  := scr0 + delta abs.
    scrSz := boundsMax - scr1.

    delta < 0 ifTrue:[
	isVertical ifTrue:[
	    self copyFrom:self x:margin y:scr1 toX:margin y:scr0
			   width:windowSz height:scrSz async:false.

	    scr1 := scr0 + scrSz.
	    inv2 := (margin @ scr1) extent:(windowSz @ (height - scr1 - margin)).
	    "/ self invalidateX:margin y:scr1 width:windowSz height:(height - scr1 - margin).
	] ifFalse:[
	    self copyFrom:self x:scr1 y:margin toX:scr0 y:margin
			   width:scrSz height:windowSz async:false.

	    scr1 := scr0 + scrSz.
	    inv2 := (scr1 @ margin) extent:((width - scr1 - margin) @ windowSz).
	    "/ self invalidateX:scr1 y:margin width:(width - scr1 - margin) height:windowSz.
	].
	inv1 := boundsPREV.
    ] ifFalse:[
	isVertical ifTrue:[
	    self copyFrom:self x:margin y:scr0 toX:margin y:scr1
			   width:windowSz height:scrSz async:false.

	    inv2 := (margin @ margin) extent:(windowSz @ (scr1 - margin)).
	    "/ self invalidateX:margin y:margin width:windowSz height:scr1 - margin.
	] ifFalse:[
	    self copyFrom:self x:scr0 y:margin toX:scr1 y:margin
			   width:scrSz height:windowSz async:false.

	    inv2 := (margin @ margin) extent:(scr1 - margin) @ windowSz.
	    "/ self invalidateX:margin y:margin width:scr1 - margin height:windowSz.
	].
	inv1 := boundsNEXT.
    ].
    self invalidate:inv1.
    self invalidate:inv2.

    "Modified: / 13.11.2001 / 20:26:42 / cg"
!

pageDown
    "scroll one page down"
    |index delta foundItem isVertical|

    (self hasScrollerAt:#NEXT) ifFalse:[^ self].

    index := self indexOfLastItemShown.
    index == 0 ifTrue:[^ self].
    
    isVertical := self verticalLayout.
    delta := isVertical ifTrue:[self height] ifFalse:[self width].
    delta := delta - 15. "/ bounds

    [delta > 0] whileTrue:[ |item|
        item := items at:index ifAbsent:nil.
        item isNil ifTrue:[
            delta := 0
        ] ifFalse:[
            (item layout notNil and:[item isVisible]) ifTrue:[
                isVertical ifTrue:[delta := delta - item layout height]
                          ifFalse:[delta := delta - item layout width].
                foundItem := item.
            ]
        ].
        index := index + 1.
     ].
     self makeItemVisible:foundItem.
!

pageUp
    "scroll one page up"
    |index delta foundItem isVertical|

    (self hasScrollerAt:#PREV) ifFalse:[^ self].

    index := self indexOfFirstItemShown.
    index == 0 ifTrue:[^ self].
    
    isVertical := self verticalLayout.
    delta := isVertical ifTrue:[self height] ifFalse:[self width].
    delta := delta - 15. "/ bounds

    [delta > 0] whileTrue:[ |item|
        item := items at:index ifAbsent:nil.
        item isNil ifTrue:[
            delta := 0
        ] ifFalse:[
            (item layout notNil and:[item isVisible]) ifTrue:[
                isVertical ifTrue:[delta := delta - item layout height]
                          ifFalse:[delta := delta - item layout width].
                foundItem := item.
            ]
        ].
        index := index - 1.
     ].
     self makeItemVisible:foundItem.
!

scrollActivity
    "returns the one and only scrollActivity - data holder
     for a menu and all contained submenus"

    superMenu notNil ifTrue:[
	^ superMenu scrollActivity
    ].
    scrollActivity isNil ifTrue:[
	scrollActivity := ScrollActivity new.
    ].
    ^ scrollActivity
!

scrollDown
    "scroll one line down"
    |item index|

    (self hasScrollerAt:#NEXT) ifFalse:[^ self].

    index := self indexOfLastItemShown.
    index > 0 ifTrue:[
        item := items
            detect:[:each| (each layout notNil and:[each isVisible]) ]
            startingAt:(index + 1)
            ifNone:nil.
    ].
    item notNil ifTrue:[self makeItemVisible:item]
               ifFalse:[self scrollToBottom].
!

scrollToBottom
    "scroll to last visible item"
    |item|
    
    (self hasScrollerAt:#NEXT) ifFalse:[^ self].

    item := items
        detectLast:[:each| (each layout notNil and:[each isVisible]) ]
        ifNone:nil.

    self makeItemVisible:item.
!

scrollToTop
    "scroll to first visible item"
    |item|

    (self hasScrollerAt:#PREV) ifFalse:[^ self].

    item := items
        detect:[:each| (each layout notNil and:[each isVisible]) ]
        ifNone:nil.

    self makeItemVisible:item.
!

scrollUp
    "scroll one line up"
    |item index|

    (self hasScrollerAt:#PREV) ifFalse:[^ self].

    index := self indexOfFirstItemShown.
    index > 1 ifTrue:[
        item := items
            detectLast:[:each| (each layout notNil and:[each isVisible]) ]
            startingAt:(index - 1)
            ifNone:nil.
    ].    
    item notNil ifTrue:[self makeItemVisible:item]
               ifFalse:[self scrollToTop].
!

scrollerBoundsAt:aDirection
    "returns the bounds of the scroller at a direction"

    |y x w h|

    x := 0.
    y := 0.
    w := 15.
    h := 15.

    self verticalLayout ifTrue:[
        aDirection == #NEXT ifTrue:[
            y := height - h.
        ].
        w := width.
    ] ifFalse:[
        aDirection == #NEXT ifTrue:[
            x := width - w.
        ].
        h := height.
    ].
    ^ Rectangle left:x top:y width:w height:h
!

scrollerDirectionAtPoint:aPoint
    "returns the scroller-direction at aPoint, or nil"

    self hasScrollers ifTrue:[
        #( PREV NEXT ) do:[:aDirection| 
            |bounds|
            
            (self hasScrollerAt:aDirection) ifTrue:[
                bounds := self scrollerBoundsAt:aDirection.

                (bounds containsPoint:aPoint) ifTrue:[^ aDirection]
            ]
        ]
    ].
    ^ nil

    "Created: / 13.11.2001 / 14:13:16 / cg"
! !

!MenuPanel methodsFor:'private-searching'!

detectGrabMenu
    "returns the menu which is responsible for the grap; the last opened menu"

    |subMenu|

    selection notNil ifTrue:[
	(subMenu := selection visibleSubmenu) notNil ifTrue:[
	    ^ subMenu detectGrabMenu
	]
    ].
    ^ self
!

detectMenuAtGrabPoint:aGrabPoint
    "returns the menu which contains the grab-point"

    |dstMenu dstPoint firstMenu|

    dstPoint := self translateGrabPoint:aGrabPoint.

    ((dstPoint x between:0 and:width) and:[dstPoint y between:0 and:height]) ifTrue:[
	firstMenu := self.
    ].

    (selection isNil or:[(dstMenu := selection visibleSubmenu) isNil]) ifTrue:[
	^ firstMenu
    ].
    dstMenu := dstMenu detectMenuAtGrabPoint:aGrabPoint.
    ^ dstMenu ? firstMenu
!

detectViewAtX:x y:y in:aTopView
    "detect view at x@y"

    ^ aTopView detectViewAt:(x@y).

"/ cg: old code was (refactored to use common code)
"/
"/    |p subViews|
"/
"/    (subViews := aTopView subViews) notNil ifTrue:[
"/        subViews do:[:v| |p|
"/            v shown ifTrue:[
"/                (    (x between:(v left) and:(v right))
"/                 and:[y between:(v top)  and:(v bottom)]
"/                ) ifTrue:[
"/                    p := device translatePoint:(x@y) from:(aTopView id) to:(v id).
"/                  ^ self detectViewAtX:p x y:p y in:v.
"/                ]
"/            ]
"/        ]
"/    ].
"/    ^ aTopView

    "Modified: / 10.10.2001 / 13:45:56 / cg"
!

itemAt:stringOrNumberOrPoint
    "returns item assigned to an index, nameKey, textLabel or value if symbol.
     If no item match nil is returned."

    |idx|

    stringOrNumberOrPoint isPoint ifTrue:[
	^ self itemAtPoint:stringOrNumberOrPoint
    ].
    idx := self indexOf:stringOrNumberOrPoint.
    (idx > 0 and:[idx <= items size]) ifTrue:[ ^ items at:idx ].
    ^ nil
!

itemAtPoint:aPoint
    "returns the item at aPoint or nil if none detected"

    |x y|

    items notNil ifTrue:[
	x := aPoint x.
	y := aPoint y.
	^ items detect:[:el| el containsPointX:x y:y] ifNone:nil
    ].
    ^ nil
!

superMenuAtPoint:aPoint
    "returns the superMenu which contains aPoint, or nil if none detected"

    |grabPoint superMenu|

    (self containsPoint:aPoint) ifTrue:[
	^ self
    ].

    grabPoint := aPoint - (self translateGrabPoint:0).
    superMenu := self.

    [ (superMenu := superMenu superMenu) notNil ] whileTrue:[
	(superMenu containsPoint:(superMenu translateGrabPoint:grabPoint)) ifTrue:[
	    ^ superMenu
	]
    ].
    ^ nil

    "Created: / 13.11.2001 / 20:22:53 / cg"
! !

!MenuPanel methodsFor:'queries'!

container:aView
    super container:aView.
    aView notNil ifTrue:[
	"/ I am no longer a popUpView
	self updateLevelAndBorder
    ].
!

containsPoint:aPoint
    "returns true if the argument, aPoint is contained by the view"

    ^ self containsPointX:(aPoint x) y:(aPoint y)
!

containsPointX:x y:y
    "returns true if point is contained by the view"

    ^ (x between:0 and:width) and:[y between:0 and:height]
!

hasGroupDividerAt:anIndex
    "returns true if a divider is defined at an index"

    |i|

    groupSizes size ~~ 0 ifTrue:[
	i := 0.

	groupSizes do:[:t|
	    (i := i + t) == anIndex ifTrue:[
		^ true
	    ]
	]
    ].
    ^ false
!

hasGroupDividers
    "returns true if any group divider exists"

    ^ (items size ~~ 0 and:[groupSizes size ~~ 0])
!

hasPerformed
    ^ hasPerformed ? false

    "Created: / 29-06-2011 / 16:24:14 / cg"
!

isFitPanel
    "returns true if the panel is the first in the menu hierarchy
     and must be fit to the extent of its superView;
     Obsolete: NO LONGER SUPPORTED"

    ^ false
!

isPopUpView
    "return true if view is a popup view; without decoration
     and popUp to top immediately"

    ^ superView isNil
!

isVerticalLayout
    "returns true if vertical layout otherwise false( horizontal layout )"

    ^ self verticalLayout
!

isViewWrapper
    ^ items size == 0 and:[subViews size ~~ 0]
!

type
    ^ nil.

! !

!MenuPanel methodsFor:'selection'!

hasSelection
    "returns true if a selection exists"

    ^ self selection notNil
!

openDelayed:anItem
    self openDelayed:anItem afterSeconds:0.5.
!

openDelayed:anItemOrNil afterSeconds:seconds
    |b|

    superMenu notNil ifTrue:[
	superMenu openDelayed:anItemOrNil afterSeconds:seconds.
	^ self
    ].
    (b := openDelayedMenuBlock notNil) ifTrue:[
	openDelayedMenuBlock := nil.
	Processor removeTimedBlock:b.
    ].
    (anItemOrNil notNil and:[anItemOrNil hasSubmenu]) ifFalse:[
	openDelayedMenuBlock := nil.
	^ self
    ].

    openDelayedMenuBlock :=
	[
	    openDelayedMenuBlock := nil.
	    anItemOrNil openDelayedSubmenu
	].

    Processor addTimedBlock:openDelayedMenuBlock afterSeconds:seconds.

    "Modified: / 29-08-2013 / 09:40:28 / cg"
!

selectAndOpenDelayed:anItemOrNil
    "change selection to an item or nil"

    |helpListener oldSelect delayedOpenSeconds b|

    anItemOrNil == selection ifTrue:[ ^ self ].
    "/ self openDelayed:nil.

    (b := closeDelayedMenuBlock notNil) ifTrue:[
	closeDelayedMenuBlock := nil.
	Processor removeTimedBlock:b.
    ].
    (b := openDelayedMenuBlock notNil) ifTrue:[
	openDelayedMenuBlock := nil.
	Processor removeTimedBlock:b.
    ].

    delayedOpenSeconds := self delayInSecondsBeforeOpeningSubmenu.
    "/ self verticalLayout ifFalse:[ delayedOpenSeconds := 0.1 ].

    oldSelect := selection.
    selection := nil.

    "/ redraw current selection cleared
    oldSelect notNil ifTrue:[
	|oldSubmenu|

	oldSubmenu := oldSelect visibleSubmenu.
	oldSubmenu notNil ifTrue:[
	    "/ if the new item has a submenu, any current submenu will be closed, when that
	    "/ one eventuall opens. However, if it is a simple item,
	    "/ it would remain open. So schedule a delayed close action for it.
	    closeDelayedMenuBlock :=
		[
		    "/ but only if we have not reentered the item with the submenu we want to close
		    selection ~~ oldSelect ifTrue:[
			(oldSelect hasSubmenu
			and:[ oldSelect visibleSubmenu notNil ]) ifTrue:[
			    oldSelect hideSubmenu.
			].
		    ].
		].
	    Processor addTimedBlock:closeDelayedMenuBlock afterSeconds:delayedOpenSeconds.
"/ mhmh - seems to not only not needed, but actually hurting (leftover menus)
"/            Processor addTimedBlock:[
"/                selection ~~ anItemOrNil ifTrue:[
"/                    "cancels the current delayed operation"
"/                    oldSelect hideSubmenu.
"/
"/                    ( selection notNil
"/                    and:[selection hasSubmenu
"/                    and:[selection visibleSubmenu isNil]]
"/                    ) ifTrue:[
"/                        "setup new delayed operation.."
"/                        self openDelayed:selection afterSeconds:delayedOpenSeconds "0.1"
"/                    ].
"/                ].
"/            ] afterSeconds:delayedOpenSeconds.
	].
	oldSelect invalidate.
    ].

    anItemOrNil notNil ifTrue:[
	self makeItemVisible:anItemOrNil.
	anItemOrNil canSelect ifTrue:[
	    selection := anItemOrNil
	].
    ].
    selection isNil ifTrue:[^ self].

    ActiveHelp isActive ifTrue:[
	helpListener := ActiveHelp currentHelpListener.
	helpListener initiateHelpFor:self at:nil now:true.
    ].

    shown ifTrue:[
	"/ self rearrangeItems.
	selection invalidate.
	selection hasSubmenu ifTrue:[
	    "/ cg: disabled: prevents delayed menu when moving over a separator item
	    false "(oldSelect isNil or:[oldSelect visibleSubmenu isNil])" ifTrue:[
		self openDelayed:selection afterSeconds:0.
	    ] ifFalse:[
		self openDelayed:selection afterSeconds:delayedOpenSeconds.
	    ]
	].
    ].

    "Modified: / 29-08-2013 / 09:44:06 / cg"
!

selection
    "returns current selected item or nil"

    ^ selection
!

selection:anItemOrNil
    "change selection to an item or nil
     if the item has a submenu the first item might be selected (style-sheet)"

    |openMenu openOnSelect submenu item|

    selection == anItemOrNil ifTrue:[^ self].

    (anItemOrNil isNil or:[anItemOrNil hasSubmenu not]) ifTrue:[
	self selection:anItemOrNil openMenu:false.
	^ self
    ].

    openMenu     := self isPopUpView not.
    openOnSelect := styleSheet at:#'menu.openOnSelect' default:false.

    openMenu ifFalse:[
	openMenu := openOnSelect.
    ].
    self selection:anItemOrNil openMenu:openMenu.

    openOnSelect ifFalse:[
	"/ select first item in submenu

	submenu := anItemOrNil currentSubmenu.

	submenu notNil ifTrue:[
	    item := submenu itemAt:1.
	    (item notNil and:[item hasSubmenu not]) ifTrue:[
		submenu selection:item openMenu:false
	    ]
	].
    ].
!

selection:anItemOrNil openMenu:openMenu
    "change selection to an item or nil"

    |helpListener oldSelect|

    anItemOrNil == selection ifTrue:[
	^ self
    ].
    self openDelayed:nil.

    oldSelect := selection.
    selection := nil.

    anItemOrNil notNil ifTrue:[
	self makeItemVisible:anItemOrNil.
	anItemOrNil canSelect ifTrue:[
	    selection := anItemOrNil
	] ifFalse:[
	    oldSelect isNil ifTrue:[^ self].
	].
    ].
    oldSelect notNil ifTrue:[
	"/ clear current selection
	oldSelect isSelected:false.
    ].
    selection isNil ifTrue:[
	^ self
    ].

"/    selection == enteredItem ifTrue:[
"/        enteredItem := nil
"/    ] ifFalse:[
"/        self pointerEntersItem:nil
"/    ].
    ActiveHelp isActive ifTrue:[
	helpListener := ActiveHelp currentHelpListener.
	helpListener initiateHelpFor:self at:nil now:true.
    ].
    shown ifTrue:[
	"/ self rearrangeItems.

	openMenu ifFalse:[
	    selection invalidate.
	]
    ].
    openMenu ifTrue:[
	selection isSelected:true.
    ].
!

selectionIndex
    "returns index of current selection or 0"

    |item|

    (item := self selection) notNil ifTrue:[
	^ self findFirst:[:el| el == item ]
    ].
    ^ 0
!

selectionIndex:anIndex
    "set selection at an index"

    self selection:(self itemAt:anIndex)
! !

!MenuPanel methodsFor:'translation'!

translateGrabPoint:aGrabPoint
    "translate the grab point into self"

    superMenu isNil ifTrue:[
	"I am the grabView"
	aGrabPoint isNumber ifTrue:[^ aGrabPoint @ aGrabPoint].
	^ aGrabPoint
    ].

    relativeGrabOrigin isNil ifTrue:[
	relativeGrabOrigin := self topMenu translatePoint:0 to:self.
	relativeGrabOrigin isNil ifTrue:[
	    "I am the grabView"
	    aGrabPoint isNumber ifTrue:[^ aGrabPoint @ aGrabPoint].
	    ^ aGrabPoint
	].
    ].
    ^ relativeGrabOrigin + aGrabPoint
!

translateMenuPoint:aPoint toMenu:aMenu
    "translate a point into another menu its point"

    |grapPoint|

    aMenu == self ifTrue:[
	^ aPoint
    ].
    grapPoint := aPoint - (self translateGrabPoint:0).

    ^ aMenu translateGrabPoint:grapPoint
!

translatePoint:aPoint to:anotherWindowOrNilForScreen
    "translate a point in my window to anotherWindowOrNilForScreen (or root window if nil)"

    ^ device
        translatePoint:aPoint asPoint
        fromView:self
        toView:anotherWindowOrNilForScreen

    "Modified: / 10.10.2001 / 14:11:47 / cg"
! !

!MenuPanel::Item class methodsFor:'accessing'!

horizontalInset
    ^ HorizontalInset
!

labelRightOffset
    ^ LabelRightOffset
!

verticalInset
    ^ VerticalInset
!

verticalPopUpInset
    ^ VerticalPopUpInset
! !

!MenuPanel::Item class methodsFor:'defaults'!

halfSeparatorSize
    "returns the size of a space-separator"

    ^ 5
!

separatorSize
    "returns the size of a separator"

    ^ 10
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'menuPanel.verticalInset')>

    HorizontalInset       := 2.
    VerticalInset         := MenuPanel styleSheet at:#'menuPanel.verticalInset' default:2.
    VerticalPopUpInset    := 2.

    HorizontalButtonInset := 3.
    VerticalButtonInset   := 3.

    LabelRightOffset      := 15.

    "
     self updateStyleCache
    "
! !

!MenuPanel::Item class methodsFor:'instance creation'!

in:aSuperMenu
    ^ self in:aSuperMenu label:nil
!

in:aSuperMenu label:aLabel
    |item|

    item := self new in:aSuperMenu.
    item label:aLabel.
    ^ item
!

in:aSuperMenu menuItem:aMenuItem
    |item|

    item := self in:aSuperMenu.
    item menuItem:aMenuItem.
    ^ item.
!

new
    ^ self basicNew initialize
! !

!MenuPanel::Item methodsFor:'accepting'!

canAccept
    "returns true if item is acceptable"

    self enabled    ifFalse:[ ^ false].
    self hasSubmenu ifFalse:[ ^ true ].

    self hasDelayedMenu ifFalse:[^ false ].
    ^ subMenu isNil or:[subMenu shown not]
!

receiver
    "Return an object used to resolve 'aspects' and used
     as a rever if 'action' messages."

    | receiver |

    receiver := menuItem receiver.
    receiver notNil ifTrue:[ ^ receiver ].
    ^  menuPanel receiver

    "Created: / 05-02-2018 / 12:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toggleIndication
    "toggle indication or choice"

    |arg|

    indication notNil ifTrue:[
	arg := self indicationValue not.
	self indicationValue:arg.
    ] ifFalse:[
	(choice notNil and:[choice isValueModel])ifTrue:[
	    choice value:(menuItem choiceValue).
	    ^ true
	].
    ].
    ^ arg
! !

!MenuPanel::Item methodsFor:'accessing'!

accessCharacter
    "returns my accessCharacter or nil"

    ^ accessCharacter
!

accessCharacterPosition
    "get the access character position or nil"

    ^ menuItem accessCharacterPosition
!

accessCharacterPosition:anIndex
    "set the access character position or nil"

    menuItem accessCharacterPosition:anIndex.
!

argument
    "gets the argument"

    ^ menuItem argument
!

argument:anArgument
    "sets the argument"

    menuItem argument:anArgument.
!

displayLabel
    "returns my printable Label"

    ^ displayLabel
!

displayLabelExtent
    "returns the labels extent"

    |myFont prevFont w h|

    displayLabelExtent notNil ifTrue:[
	^ displayLabelExtent
    ].

    displayLabel isNil ifTrue:[
	displayLabelExtent := 0@0.
	^ displayLabelExtent
    ].

    myFont := self font.
    myFont isNil ifTrue:[ self font:(myFont := menuPanel font) ].
    myFont := myFont onDevice:menuPanel device.

    prevFont := menuPanel setFont:myFont.

    displayLabel isString ifTrue:[
	w := displayLabel widthOn:menuPanel.
	h := displayLabel heightOn:menuPanel.
"/        w := myFont widthOf:displayLabel.
"/        h := myFont heightOf:displayLabel.
    ] ifFalse:[
	displayLabel isArray ifTrue:[
	    w := h := 0.

	    displayLabel do:[:aSubLabel|
		aSubLabel notNil ifTrue:[
		    w := w max:(aSubLabel widthOn:menuPanel).
		    h := h + 1 + (aSubLabel heightOn:menuPanel).
		] ifFalse:[
		    h := h + (self spaceBetweenEmptyLines)
		]
	    ]
	] ifFalse:[
	    w := displayLabel widthOn:menuPanel.
	    h := displayLabel heightOn:menuPanel.
	].
    ].

    menuPanel setFont:prevFont.     "/ restore previous font

    "/ care for italic fonts - give a few more pixels at the end
    myFont italic ifTrue:[
	w := w + 2.
    ].
    displayLabelExtent := w@h.
    ^ displayLabelExtent

    "Modified: / 17-08-2010 / 10:46:06 / cg"
!

font
    "returns the user configured font or nil (default menu font)"

    |font|

    menuPanel isNil ifTrue:[^ nil].

    font := menuItem font.

    font notNil ifTrue:[
	font := font onDevice:(menuPanel device).
	menuItem font:font.
    ].
    ^ font
!

font:aFont
    "returns the user configured font or nil (default menu font)"

    menuItem font:aFont.
!

ignoreMnemonicKeys
    "if true, mnemonic (access character) in the submenus under the item are ignored.
     Set this to speedup accelerator key processing for slow dynamci menus"

    ^ menuItem ignoreMnemonicKeys

    "Modified (comment): / 08-09-2011 / 04:29:47 / cg"
!

ignoreMnemonicKeys:aBoolean
    "if true, mnemonic (access character) in the submenus under the item are ignored"

    menuItem ignoreMnemonicKeys:aBoolean.
!

ignoreShortcutKeys
    "if true, shortcutKeys (accelerators) in the submenus under the item are ignored"

    ^ menuItem ignoreShortcutKeys
!

ignoreShortcutKeys:aBoolean
    "if true, shortcutKeys (accelerators) in the submenus under the item are ignored"

    menuItem ignoreShortcutKeys:aBoolean.
!

itemValue
    "gets the item's value"

    ^ menuItem itemValue

    "Modified (comment): / 06-03-2012 / 14:41:27 / cg"
!

itemValue:aValue
    "argument could be a value holder, an action or selector"

    menuItem itemValue:aValue.
!

label
    "returns the label"

    ^ label
!

label:aLabel
    "set a new label; if the label changed, a redraw is performed;
     handle characters $& (ST-80 compatibility)"

    |size char oldExtent|

    oldExtent          := displayLabelExtent.
    displayLabelExtent := nil. "/ force a recomputation
    accessCharacter    := disabledDisplayLabel := nil.

    "Stefan: Why do we use #value two times??"
    label              := aLabel value.
    displayLabel       := label value ? ''.

    displayLabel isString ifTrue:[
	"CHECK FOR SEPARATOR"

	(menuItem isButton not and:[indication isNil and:[choice isNil]]) ifTrue:[
	    size := displayLabel size.

	    size == 0 ifTrue:[
		displayLabel := nil.            "blank separator"
		^ self
	    ].

	    size == 1 ifTrue:[
		char := displayLabel first.

		(char == $- or:[char == $=]) ifTrue:[
		    label := displayLabel.      "line separator"
		    displayLabel := nil.
		    ^ self
		]
	    ]
	]
    ] ifFalse:[
	displayLabel isCollection ifTrue:[
	    displayLabel := displayLabel asArray.
	]
    ].
    menuPanel notNil ifTrue:[
	menuPanel doAccessCharacterTranslation ifTrue:[
	    displayLabel notNil ifTrue:[
		displayLabel isArray ifTrue:[
		    displayLabel keysAndValuesDo:[:i :el|
			el notNil ifTrue:[
			    displayLabel at:i put:(self updateAccessCharacterFor:el).
			].
		    ].
		] ifFalse:[
		    displayLabel isImageOrForm ifFalse:[
			displayLabel := self updateAccessCharacterFor:displayLabel.
		    ].
		].
	    ].
	].

	menuPanel shown ifTrue:[
	    self fetchImages.

	    oldExtent = self displayLabelExtent ifTrue:[
		self invalidate
	    ] ifFalse:[
		menuPanel mustRearrange
	    ]
	].
    ].

    "Modified: / 06-10-2011 / 16:36:53 / cg"
!

menuPanel
    "returns my menuPanel"

    ^ menuPanel
!

nameKey
    "gets the nameKey"

    ^ menuItem nameKey
!

nameKey:aNameKey
    "sets the nameKey"

    menuItem nameKey:aNameKey.
!

rawLabel
    "returns my raw, unprocessed label"

    ^ menuItem rawLabel
!

shortcutKey
    "get the key to press to select the submenu from the keyboard or if
     no submenu exists evaluate the action assigned to the item (accept)."

    ^ menuItem shortcutKey
!

shortcutKey:aKey
    "set the key to press to select the submenu from the keyboard or if
     no submenu exists evaluate the action assigned to the item (accept)."

    menuItem shortcutKey ~= aKey ifTrue:[
	menuItem shortcutKey:aKey.
	self invalidate.
    ].
!

startGroup
    "start group #left #right #conditionalRight ... or nil
     at the moment only #right and #conditionalRight are implemented"

    ^ menuItem startGroup

    "Modified: / 16-10-2006 / 13:06:25 / cg"
!

startGroup:aSymbol
    "start group #left #right #conditionalRight ...
     at the moment only #right and #conditionalRight are implemented"

    menuItem startGroup:aSymbol.

    "Modified: / 16-10-2006 / 13:06:37 / cg"
!

submenu
    "returns my submenu or creates it if its defined via a selector or channel.
     May return nil, if there is really no menu"

    subMenu isNil ifTrue:[
	self setupSubmenu
    ].
    ^ subMenu

    "Modified: / 07-11-2006 / 11:09:49 / cg"
!

submenu:aSubMenu
    "set a new submenu; an existing submenu will be destroyed.
     This might lead to a redraw if 'hasSubmenu' changed"

    |widget|

    subMenu notNil ifTrue:[
	subMenu ~~ aSubMenu ifTrue:[
	    subMenu destroy.
	    subMenu := nil.
	].
    ].

    aSubMenu isNil ifTrue:[
	subMenu notNil ifTrue:[
	    subMenu destroy.
	    subMenu := nil.
	].
	^ self
    ].

    (aSubMenu isKindOf:Menu) ifTrue:[
	subMenu := MenuPanel new.

	menuPanel notNil ifTrue:[
	    subMenu receiver:menuPanel receiver.
	].
	subMenu superMenu:menuPanel.

	menuItem horizontalLayout == true ifTrue:[
	    subMenu verticalLayout:false
	].
	subMenu menu:aSubMenu.
    ] ifFalse:[
	aSubMenu isView ifFalse:[
	    (aSubMenu isKindOf:ApplicationModel) ifFalse:[
		"/ ... mhhhh ....
		^ menuItem submenuChannel:aSubMenu
	    ].
	    widget := SimpleView new.
	    widget client:aSubMenu.
	] ifTrue:[
	    widget := aSubMenu.
	    subMenu perform:#superMenu: with:menuPanel ifNotUnderstood:[].
	].

	(widget isKindOf:MenuPanel) ifTrue:[
	    subMenu := widget.

	    menuItem horizontalLayout == true ifTrue:[
		subMenu verticalLayout:false
	    ].
	] ifFalse:[
	    subMenu := MenuPanel new.
	    subMenu receiver:menuPanel receiver.
	    subMenu addSubView:widget.
	    subMenu extent:(widget preferredExtent).
	    widget origin:0.0@0.0 corner:1.0@1.0.
	].
	subMenu superMenu:menuPanel.
    ].
!

submenuOrNil
    "returns my submenu or nil if there is none or its defined via a channel or selector"

    ^ subMenu

    "Created: / 07-11-2006 / 11:04:47 / cg"
!

textLabel
    "returns my textLabel or nil.
     Used internally to select items via initial-character, for example."

    |txt|

    displayLabel notNil ifTrue:[
	displayLabel isArray ifFalse:[
	    ^ displayLabel perform:#string ifNotUnderstood:nil
	].

	displayLabel do:[:el|
	    (txt := el perform:#string ifNotUnderstood:nil) notNil ifTrue:[
		^ txt
	    ]
	].
    ].
    ^ nil
!

triggerOnDown
    "return true if triggering the action if pressed"

    menuItem triggerOnDown ifTrue:[
	self hasSubmenu ifFalse:[^ true].
    ].
    ^ false
!

triggerOnDown:aBool
    "setup to trigger the action if pressed"

    menuItem triggerOnDown:aBool.
!

value
    "gets the item's value
     Left here for ST80 compatibility - value is a bad name"

    ^ menuItem itemValue

    "Modified (comment): / 06-03-2012 / 14:41:23 / cg"
!

value:aValue
    "could be a value holder, an action or selector
     Left here for ST80 compatibility - value: is a bad name"

    menuItem itemValue:aValue.
!

value:aValue argument:anArgument
    "set the value and an argument"

    menuItem itemValue:aValue.
    menuItem  argument:anArgument.
! !

!MenuPanel::Item methodsFor:'accessing-behavior'!

choice
    "implements a radio group; the field"

    ^ choice
!

choice:something
    "set choice indication"

    choice == something ifTrue:[^ self].

    choice isValueModel ifTrue:[
	choice removeDependent:self
    ].

    choice := something.
    choice notNil ifTrue:[
	choice isSymbol ifTrue:[
	    choice := (self aspectAt:choice) ? choice.
	].
	choice isValueModel ifTrue:[
	    choice addDependent:self
	]
    ].
!

choiceValue
    "implements a radio group; the value writen to the choice if selected"

    ^ menuItem choiceValue
!

choiceValue:something
    "implements a radio group; the value writen to the choice if selected"

    menuItem choiceValue ~= something ifTrue:[
	menuItem choiceValue:something.
	choice notNil ifTrue:[ self invalidate ].
    ].
!

enabled
    "returns the enabled state"

    |state|

    menuPanel isNil ifTrue:[ ^ false].
    menuPanel enabled ifFalse:[^ false].

    enableChannel isSymbol ifTrue:[
        state := self aspectAt:enableChannel.
        state isValueModel ifTrue:[
            enableChannel := state.
            enableChannel addDependent:self.
        ].
    ] ifFalse:[
        state := enableChannel.
    ].
    ^ state value ~~ false
!

enabled:something
    "change the enabled state; if the state changed, a redraw is performed"

    |oldState newState|

    enableChannel isNil ifTrue:[
	oldState := true
    ] ifFalse:[
	oldState := enableChannel value.
	enableChannel isValueModel ifTrue:[
	    enableChannel removeDependent:self
	]
    ].
    enableChannel := something.

    enableChannel isNil ifTrue:[
	menuPanel shown ifFalse:[^ self].
	newState := true
    ] ifFalse:[
	enableChannel isValueModel ifTrue:[
	    enableChannel addDependent:self
	] ifFalse:[
	    enableChannel isSymbol ifTrue:[^ self]
	].
	menuPanel shown ifFalse:[^ self].
	newState := enableChannel value.
    ].

    newState ~~ oldState ifTrue:[
	self invalidate
    ].
!

hideMenuOnActivated
    "hide the menu when the item was activated; the default is true"

    ^ menuItem hideMenuOnActivated
!

hideMenuOnActivated:aBool
   "hide the menu when the item was activated; the default is true"

   menuItem hideMenuOnActivated:aBool.
!

ifNotInUIBuilderInfoPrintCR:aMessage
    "/ q&d hack to suppress info-messages in UIBuilder

    |app|

    app := menuPanel application.

    "/ JV@2016-04-15: Fix for https://swing.fit.cvut.cz/projects/stx-jv/ticket/78
    "/ The isKinfOf: below is a super ugly, whip me hard,
    "/ but a correct fix, i.e., adding isUIPainter to UISelectionPanel
    "/ would require to fork stx:libtool2 which I'd like to avoid for now.
    "/ If more fixes would go to stx:libtool2 then I will fork, and
    "/ remove this code.
    (self receiver isNil
    and:[ app notNil
    and:[ (app askFor:#isUIPainter) or:[app isKindOf: (Smalltalk at:#UISelectionPanel)]]])
    ifTrue:[
        ^ self "/ suppressed
    ].
    Logger info: aMessage

    "Modified: / 05-02-2018 / 12:06:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indication
    "get on/off indication"

    ^ indication
!

indication:aValueHolder
    "set on/off indication"

    indication == aValueHolder ifTrue:[^ self].

    indication isValueModel ifTrue:[
	indication removeDependent:self
    ].

    (indication := aValueHolder) notNil ifTrue:[
	indication isValueModel ifTrue:[
	    indication addDependent:self
	] ifFalse:[
	    "/ to force an update of the value
	    self indicationValue
	]
    ].
!

keepLinkedMenu
    "get the keepLinkedMenu flag"

    ^ menuItem keepLinkedMenu
!

keepLinkedMenu:aBool
    "get the keepLinkedMenu flag"

    menuItem keepLinkedMenu:aBool.
!

sendToOriginator
    "if true, the message is sent to the originating widget;
     otherwise (the default), it it sent to the receiver/application."

    ^ menuItem sendToOriginator
!

sendToOriginator:aBoolean
    "if true, the message is sent to the originating widget;
     otherwise (the default), it it sent to the receiver/application."

    menuItem sendToOriginator:aBoolean.
!

submenuChannel
    "get the submenu channel"

    ^ menuItem submenuChannel
!

submenuChannel:aSelectorOrNil
    "returns the submenu channel"

    menuItem submenuChannel:aSelectorOrNil.
! !

!MenuPanel::Item methodsFor:'accessing-dimension'!

moveBy:aPoint
    "move the layouts origin"

    layout moveBy:aPoint.
!

preferredExtent
    "compute my preferred extent excluding the shortCutKey and the menu identifier"

    |isVertical icon wIcon isButton labelExtent
     x "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"
     s "{ Class:SmallInteger }"
    |
    self isVisible ifFalse:[^ 0@0 ].

    isButton := menuItem isButton.

    isButton ifTrue:[
	s := menuPanel maxAbsoluteButtonLevel ? 0.
	x := s + HorizontalButtonInset.
	y := s + VerticalButtonInset.
    ] ifFalse:[
	x  := HorizontalInset.
	y  := (menuPanel isPopUpView ifTrue:[VerticalPopUpInset] ifFalse:[VerticalInset]) ? 2.
    ].
    x := x * 2.
    y := y * 2.

    isVertical := menuPanel verticalLayout.

    self isSeparator ifTrue:[
	s := self class separatorSize.
	label = '' ifTrue:[
	    s := self class halfSeparatorSize.
	].

	"width of doubleSeparator is 5 !!!!"
	isVertical ifFalse:[
	    x := x max:s.
	    y := y + 5.
	] ifTrue:[
	    y := y max:s.
	    x := x + 5.
	].
    ] ifFalse:[
	labelExtent := self displayLabelExtent.

	x := x + labelExtent x.
	y := y + labelExtent y.
	x := x + (menuPanel stringOffsetXfor:self).

	isButton ifFalse:[
	    menuPanel showSeparatingLines ifTrue:[
		"width of separator is 2 plus right offset 1 := 3"
		isVertical ifFalse:[x := x + 3] ifTrue:[y := y + 3].
	    ].
	].
	wIcon := 0.
	self hasMenuIndicator ifTrue:[
	    icon := MenuPanel menuIndicator.
	    wIcon := MenuPanel menuIndicatorOffset + icon width.
	] ifFalse:[
	    self hasDelayedMenuIndicator ifTrue:[
		icon := MenuPanel delayedMenuIndicator.
		wIcon := MenuPanel delayedMenuIndicatorOffset + icon width.
	    ]
	].
	x := x + wIcon.
    ].
    ^ x@y

    "Modified: / 19-01-2011 / 21:20:35 / cg"
!

preferredHeight
    ^ self preferredExtent y
!

preferredWidth
    ^ self preferredExtent x
! !

!MenuPanel::Item methodsFor:'accessing-help'!

activeHelpKey
    "get the active helpKey; the key to retrieve the helpText from the application"

    ^ menuItem activeHelpKey
!

activeHelpKey:aHelpKey
    "set the active helpKey; the key to retrieve the helpText from the application"

    menuItem activeHelpKey:aHelpKey.
    activeHelpText := nil.
!

activeHelpText
    "get the active helpText or nil if not yet resolved"

    |app key|

    activeHelpText notNil ifTrue:[^ activeHelpText].

    ((key := self activeHelpKey) notNil
    and:[(app := menuPanel application) notNil]) ifTrue:[
	^ app helpTextForKey:key.
    ].
    ^ nil
!

activeHelpText:aText
    "set the active helpText"

    activeHelpText := aText.
!

flyByHelpText
    "get the flyBy helpText or nil."

    |text key app keyUsed itemsActionSelector|

    flyByHelpText notNil ifTrue:[^ flyByHelpText].

    self isSeparator ifTrue:[^ nil].

    "/ its NOT the button-attribute, which controls flyByHelp suppression...
    "/ (if you have an argument for that let us know..)
    "/    self isButton ifFalse:[^ nil].
    (menuPanel isNil or:[menuPanel isPopUpView]) ifTrue:[^ nil].

    "/ if an activeHelpKey was explicitely given, use that one
    key := keyUsed := self activeHelpKey.
    keyUsed isNil ifTrue:[
        "/ try action as key
        (itemsActionSelector := menuItem itemValue) isSymbol ifTrue:[
            keyUsed := itemsActionSelector.
        ].
    ].

    "/ special hook for menuItems added by other applications (i.e. via addMenuItem to the launcher)
    (keyUsed isAssociation) ifTrue:[
        app := keyUsed key.
        keyUsed := keyUsed value.
    ] ifFalse:[
        app := menuPanel application.
    ].

    keyUsed notNil ifTrue:[
        app notNil ifTrue:[
            text := app flyByHelpTextForKey:keyUsed.
        ].
        text isNil ifTrue:[
            text := menuPanel flyByHelpTextForKey:keyUsed.
        ].
        "/ if the key used is NOT the activeHelpKey, but the action name,
        "/ then do not accept the default
        ((text = keyUsed) and:[key isNil]) ifTrue:[
            text := nil.
        ].
    ].

    "/ otherwise, construct from the label; but only if I do not have a submenu
    text isNil ifTrue:[
        self hasSubmenu ifTrue:[
            ^ key
        ].

        "/ then use the original activeHelpKey (but not the action)
        text := key.
        text isNil ifTrue:[
            displayLabel isString ifTrue:[
                text := displayLabel string.
            ].
        ].
        text isNil ifTrue:[
            text := self rawLabel.
            text isString ifFalse:[
                text := menuItem rawLabel.
                text isString ifFalse:[
                    text := nil.
                ]
            ].
            text notNil ifTrue:[
                (text includes:$&) ifTrue:[
                    text := (self updateAccessCharacterFor:text) string.
                ].
            ].
        ].
    ].

    (text isString and:[text isBlank]) ifTrue:[ text := nil ].
    text = displayLabel ifTrue:[
        "for text menus: it does not make sense to show the label's string again
         (i.e. in a pull down menu)"
        ^ nil
    ].
    ^ text
!

flyByHelpText:aText
    "exlicitly set the flyBy helpText. For example, to dynamically change it."

    flyByHelpText := aText.
! !

!MenuPanel::Item methodsFor:'accessing-look'!

horizontalLayout
    "on default submenus has a vertical layout;
     true, the submenu has a horizontal layout."

    ^ menuItem horizontalLayout ? false
!

horizontalLayout:aBoolean
    "on default submenus has a vertical layout;
     true, the submenu has a horizontal layout."

    menuItem horizontalLayout:aBoolean.
!

isButton
    "returns whether the item looks like a Button"

    ^ menuItem isButton
!

isButton:aBool
    "set/clear the item to look like a Button"

    menuItem isButton ~~ aBool ifTrue:[
	menuItem isButton:aBool.
	self invalidate.
    ]
!

layout
    "returns my layout ( Rectangle )"

    ^ layout
!

layout:aLayout
    "set a new layout ( Rectangle )"

    layout := aLayout.
    self invalidate.
!

showBusyCursorWhilePerforming
    "get the flag which controls if a busy cursor is to be shown
     while performing the menu action. Defaults to false."

    ^ menuItem showBusyCursorWhilePerforming
!

showBusyCursorWhilePerforming:aBoolean
    "set/clear the flag which controls if a busy cursor is to be shown
     while performing the menu action. Defaults to false."

    menuItem showBusyCursorWhilePerforming:aBoolean.
! !

!MenuPanel::Item methodsFor:'activation & deactivation'!

currentSubmenu
    "returns the current submenu or nil"

    ^ subMenu
!

hideSubmenu
    "hide submenu"

    self hideSubmenu:subMenu.
!

hideSubmenu:aSubmenu
    "hide submenu"

    |id wg|

    aSubmenu isNil ifTrue:[^ self].
    aSubmenu removeDependencies.

    aSubmenu realized ifFalse:[
	id := aSubmenu id.
	id notNil ifTrue:[ menuPanel device unmapWindow:id ]
    ] ifTrue:[
	aSubmenu hide
    ].

    aSubmenu windowGroup:nil.
    (wg := menuPanel windowGroup) notNil ifTrue:[
	wg removeView:aSubmenu.
    ].

    "/ release menu if derived from channel
    (subMenu == aSubmenu and:[menuItem submenuChannel notNil]) ifTrue:[
	menuItem keepLinkedMenu ifFalse:[
	    subMenu := nil
	]
    ].
!

openDelayedSubmenu
    "called to open now my delayed submenu"

    |subMenuBeforeOpening|

    (self isSelected and:[menuPanel shown]) ifFalse:[^ self].
    subMenu notNil ifTrue:[
        subMenu realized ifTrue:[
            "/ already open
            ^ self
        ].
    ].

    "/ bugfix : check if delayed menu canbe open (only for toolbars and items having a delayed menu)
    (menuPanel isPopUpView                      
    or:[self hasDelayedMenu not
    or:[menuPanel sensor anyButtonPressed]]
    ) ifFalse:[
        "/ check if any menu already is open than accept otherwise ignore

        menuPanel items
            detect:[:el|(el currentSubmenu isView and:[el currentSubmenu realized])]
            ifNone:[^ self].
    ].

    self setupSubmenu.
    subMenu isNil ifTrue:[^ self].
    subMenu hasItems ifFalse:[^ self].
    subMenuBeforeOpening := subMenu.
    self openSubmenu.

    (subMenuBeforeOpening == subMenu and:[self isSelected]) ifFalse:[
        "/ closed during building or opening the submenu
        self hideSubmenu:subMenuBeforeOpening.
    ].

    "Modified: / 07-11-2006 / 11:07:57 / cg"
!

openSubmenu
    "opens the submenu; make sure, that the submenu and the menPanel
     is fully visible by shifting it into the visible screen area if
     nescessary."

    |p o device isVertical topMenu windGrp prefExtent lastEvent
     devBot   "{ Class:SmallInteger }"
     devRight "{ Class:SmallInteger }"
     width    "{ Class:SmallInteger }"
     height   "{ Class:SmallInteger }"
     top      "{ Class:SmallInteger }"
     left     "{ Class:SmallInteger }"
    |

    (subMenu isNil or:[subMenu shown or:[self isSelected not or:[menuPanel realized not]]]) ifTrue:[
	^ self
    ].
    "close all other open submenus assigned to the menuPanel I'am located in"

    menuPanel itemsDo:[:eachItem|
	(eachItem ~~ self and:[eachItem visibleSubmenu notNil]) ifTrue:[
	    eachItem hideSubmenu.
	].
    ].
    topMenu := menuPanel topMenu.
    (subMenu device notNil and:[topMenu device ~~ subMenu device]) ifTrue:[
	subMenu releaseDeviceResources.
	subMenu setDevice:topMenu device id:nil gcId:nil.
	subMenu recreate.
    ].

    windGrp := topMenu windowGroup.
    windGrp notNil ifTrue:[
	lastEvent := windGrp lastEvent.

	(lastEvent notNil and:[lastEvent isButtonPressEvent]) ifTrue:[
	    subMenu mapTime:(lastEvent timeStamp).
	].
    ].
    subMenu superMenu:menuPanel.
    subMenu becomesActiveMenu.
    subMenu cursor:Cursor hand.

    windGrp notNil ifTrue:[
	subMenu windowGroup:windGrp.
	windGrp addTopView:subMenu.
    ].

    "Q&D kludge - test whether the layout is nil;
		  if true recompute the layouts
    "
    layout isNil ifTrue:[menuPanel rearrangeItems].

    isVertical := menuPanel verticalLayout.

    p := isVertical ifTrue:[layout topRight - 2] ifFalse:[layout bottomLeft].
    menuPanel isPopUpView ifTrue:[
	o := menuPanel origin + p
    ] ifFalse:[
	o := menuPanel translatePoint:p to:nil.   "/ translate to root window
    ].
    subMenu origin:o.   "set temporary origin to compute preferredExtent"

    " Q&D kludge - if any visibility attributes are blocks;
      TODO: only invoke mustRearrange if any are blocks
	    (since I react correctly on valueHolder changes)
    "
    subMenu rearrangeItemsIfItemVisibilityChanged.
    subMenu fixSize.

    "compute origin of subMenu"
    device     := menuPanel device.
    prefExtent := subMenu preferredExtent.
    height     := prefExtent y.
    width      := prefExtent x.
    devBot     := device  usableHeightAt:o.
    devRight   := device  usableWidth.

    left := o x.
    top  := o y.

    top + height > devBot ifTrue:[
	top := isVertical ifTrue:[devBot - height]
			 ifFalse:[top - layout height - height + 2]
    ].

"/    (isVertical not and:[subMenu isVerticalLayout]) ifTrue:[
"/        top < menuPanel bottom ifTrue:[
"/            left := left + layout width.
"/        ].
"/        left + width > devRight ifTrue:[
"/            left := o x - width - 2
"/        ].
"/    ].

    left + width > devRight ifTrue:[
	left := isVertical ifTrue:[left - layout width - width + 2]
			  ifFalse:[devRight - width]
    ].

"/ ***** MULTI SCREEN
"/    top := top max:0.
"/    left := left max:0.

    subMenu origin:(left@top).

    subMenu realized ifFalse:[
	subMenu realize.
    ] ifTrue:[
	topMenu device mapWindow:(subMenu id).
    ].
!

toggleSubmenuVisibility
    "toggle the visibility of the submenu"

    subMenu notNil ifTrue:[
	subMenu shown ifTrue:[^ self hideSubmenu]
    ] ifFalse:[
	self setupSubmenu.
	subMenu isNil ifTrue:[
	    "/ cannot open a submenu
	    ^ self
	]
    ].
    self openSubmenu.

    "Modified: / 07-11-2006 / 11:06:42 / cg"
!

visibleSubmenu
    "returns the current visible submenu or nil"

    subMenu notNil ifTrue:[
	subMenu shown ifTrue:[^ subMenu].
    ].
    ^ nil
! !

!MenuPanel::Item methodsFor:'building'!

aspectAt:aKey
    "returns the value assigned to key or nil"

    |appl value|

    appl := self receiver.
    (appl isValueModel) ifTrue:[
        ^ appl value:aKey
    ].
    appl isNil ifTrue:[
        appl := menuPanel application.
        appl isNil ifTrue:[ ^ nil].
    ].

    MessageNotUnderstood handle:[:ex|
        ex selector ~~ aKey ifTrue:[
            ex reject
        ].
        self ifNotInUIBuilderInfoPrintCR:
            ('application (%1) does not provide aspect: %2 (in %3)'
             bindWith:appl classNameWithArticle
             with:aKey
             with:(label isString ifTrue:[label] ifFalse:[self nameKey ? self itemValue ? '???'])).
    ] do:[
        aKey argumentCount == 1 ifTrue:[
            value := appl perform:aKey with:(menuItem argument ? self).
        ] ifFalse:[
            (appl respondsTo:#aspectFor:) ifTrue:[
                value := appl aspectFor:aKey
            ] ifFalse:[
                value := appl perform:aKey
            ]
        ]
    ].
    ^ value

    "Modified: / 02-08-2013 / 16:44:28 / cg"
    "Modified: / 05-02-2018 / 12:06:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MenuPanel::Item methodsFor:'change & update'!

fontChanged
    "called whenever the font changed"

    displayLabel notNil ifTrue:[
	displayLabelExtent := nil.

	subMenu notNil ifTrue:[
	    subMenu font:(menuPanel font).
	].
    ].
!

update:something with:aParameter from:changedObject

    |form rect|

    (menuPanel isNil or:[layout isNil]) ifTrue:[^ self].        "/ not yet realized or computed

    self isSeparator ifFalse:[
	"/ NOT A SEPARATOR

	menuPanel shown ifTrue:[
	    changedObject == enableChannel ifTrue:[
		(enableChannel value == false and:[self isSelected]) ifTrue:[
		    ^ menuPanel selection:nil.
		].
		^ self invalidate
	    ].

	    (changedObject == indication or:[changedObject == choice]) ifTrue:[
		menuItem isButton ifTrue:[
		    self invalidate
		] ifFalse:[
		    "/ invalidate the interactor only
		    "/ take any interactor; interactors has the same extent
		    form := menuPanel iconIndicationOff.

		    rect := Rectangle left:(layout left + HorizontalInset)
				       top:(layout top)
				     width:(form width)
				    height:(layout height).

		    menuPanel invalidate:rect repairNow:false
		].
		^ self
	    ].
	    self invalidate.
	].
    ].

    changedObject == isVisible ifTrue:[
	menuPanel mustRearrange.
	"/ actually: the following is wrong, because we have to delay the rearrangement
	"/ until the next redraw event comes. Otherwise, we might compute new layouts
	"/ too early if more items change their visibility.
	"/ redraw will call rearrangeItems, if the mustRearrange is set.

	"/ menuPanel rearrangeItems.
	^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified (comment): / 24-11-2011 / 19:01:42 / cg"
!

updateIndicators
    "update indicators "

    indication notNil ifTrue:[
	(indication isSymbol
	or:[menuItem hideMenuOnActivated not])
	ifTrue:[
	    "indication is a selector;
	     otherwise no need to redraw, because
	     a change notification is raised from the model !!!!"
	    self update:nil with:nil from:indication
	]
    ]
! !

!MenuPanel::Item methodsFor:'converting'!

asMenuItem
    "convert to a MenuItem"

    ^ menuItem
!

menuItem
    ^ menuItem
!

menuItem:aMenuItem
    "setup attributes from a MenuItem"

    |lbl|

    menuPanel disabledRedrawDo:[
	menuItem := aMenuItem.
	menuItem isNil ifTrue:[ menuItem := MenuItem new].

	label := displayLabel := activeHelpText := nil.

	self    enabled:(menuItem enabled).
	self indication:(menuItem indication).
	self     choice:(menuItem choice).
	self  isVisible:(menuItem isVisible ? true).

"/ we should call the resourceRetriever here instead of labelImage
"/ but ... ??

	(lbl := menuItem labelImage value) isNil ifTrue:[
	    lbl := menuItem rawLabel. "/ avoid translating &'s twice
	].

	self submenu:(menuItem submenu).
	self label:lbl.
    ]

    "Modified: / 22.8.1998 / 15:34:16 / cg"
! !

!MenuPanel::Item methodsFor:'dependents access'!

addDependencies
    "add all dependencies"

    enableChannel isValueModel ifTrue:[enableChannel addDependent:self].
    isVisible     isValueModel ifTrue:[isVisible     addDependent:self].
    indication    isValueModel ifTrue:[indication    addDependent:self].
    choice        isValueModel ifTrue:[choice        addDependent:self].
!

removeDependencies
    "remove all dependencies"

    enableChannel isValueModel ifTrue:[enableChannel removeDependent:self].
    isVisible     isValueModel ifTrue:[isVisible     removeDependent:self].
    indication    isValueModel ifTrue:[indication    removeDependent:self].
    choice        isValueModel ifTrue:[choice        removeDependent:self].
! !

!MenuPanel::Item methodsFor:'drawing'!

choiceForm
    "returns choice form or nil"

    |isOn|

    choice isNil ifTrue:[^ nil].

    isOn := (choice value = menuItem choiceValue).
    self enabled ifFalse:[
	^ isOn ifTrue:[menuPanel iconRadioGroupDisabledOn]
	       ifFalse:[menuPanel iconRadioGroupDisabledOff]
    ].
    self isSelected ifTrue:[
	^ isOn == true
	    ifTrue:[menuPanel iconRadioGroupEnteredOn]
	    ifFalse:[menuPanel iconRadioGroupEnteredOff]
    ].
    ^ isOn ifTrue:[menuPanel iconRadioGroupOn]
	   ifFalse:[menuPanel iconRadioGroupOff]
!

draw
    "redraw this item"

    |isSelected ownBgCol paint bgColor
     x  "{ Class:SmallInteger }"
     y  "{ Class:SmallInteger }"
     w  "{ Class:SmallInteger }"
     h  "{ Class:SmallInteger }"
    |

    self isVisible ifFalse:[^ self].
    layout isNil ifTrue:[
	"/ cg: why does this happen - it does!!
	^ self
    ].

    self isSeparator ifTrue:[
	self drawSeparator.
	^ self
    ].
    menuItem isButton ifTrue:[
	self drawButton.
	^ self
    ].

    "/ DRAW A LABELED ENTRY; no button, no separator

    isSelected := self isSelected.
    bgColor    := menuPanel backgroundColor.
    paint      := isSelected
		    ifTrue:[self activeBackgroundColor]
		    ifFalse:[
			(self isEnabled and:[ self isEntered ]) ifTrue:[
			    menuPanel enteredBackgroundColor
			] ifFalse:[
			    bgColor
			]].

    (ownBgCol := self backgroundColorFromLabel) notNil ifTrue:[
	paint := ownBgCol
    ].

    paint ~= bgColor ifTrue:[
	menuPanel paint:paint.
	menuPanel fillRectangle:layout.
    ].

    menuPanel showSeparatingLines ifTrue:[
	self drawSeparatingLines
    ].

    self drawLabel.

    (ownBgCol notNil and:[isSelected]) ifTrue:[
	ownBgCol brightness > 0.5 ifTrue:[menuPanel paint: menuPanel selectionFrameDarkColor]
				 ifFalse:[menuPanel paint: menuPanel selectionFrameBrightColor].

	x := layout left.
	y := layout top.
	w := layout width.
	h := layout height.

	menuPanel displayRectangleX:(x + 1) y:(y + 1) width:(w - 2) height:(h - 2).
	menuPanel displayRectangleX:(x + 2) y:(y + 2) width:(w - 4) height:(h - 4).
    ].
    menuPanel drawLabelEdgeFor:self selected:isSelected.
!

drawButton
    "draw as button"

    |drawObject fg etchFg level isEnabled isSelected bg ownBgCol showSelected
     x "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"
    |
    drawObject := displayLabel.
    isEnabled  := self enabled.
    isSelected := self isSelected.

    isSelected ifFalse:[
	"/ test whether button has pressed toggle behaviour
	showSelected := (self isToggle and:[self indicationValue]).
    ] ifTrue:[
	showSelected := isSelected
    ].

    showSelected ifTrue:[
	bg := self activeBackgroundColor.
	fg := self activeForegroundColor.
    ] ifFalse:[
	self isEntered ifTrue:[
	    bg := self buttonEnteredBackgroundColor
	] ifFalse:[
	    bg := self backgroundColor
	].
	isEnabled ifTrue:[
	    fg := menuPanel foregroundColor
	] ifFalse:[
	    fg := menuPanel disabledForegroundColor.
	    etchFg := menuPanel disabledEtchedForegroundColor.
	    drawObject := self disabledRawLabel
	]
    ].

    (ownBgCol := self backgroundColorFromLabel) notNil ifTrue:[
	bg := ownBgCol
    ].

    "DRAW BACKGROUND"
    bg ~= menuPanel backgroundColor ifTrue:[
	menuPanel paint:bg.
	menuPanel fillRectangle:layout.
    ].

    x := layout left + menuPanel buttonPassiveLevel + HorizontalButtonInset.

    (drawObject isImage and:[menuPanel centerItems]) ifTrue:[
	x := x + (layout width - menuPanel buttonPassiveLevel - HorizontalButtonInset - 1 - drawObject width // 2).
    ].

    isSelected ifFalse:[
	"check whether button should be drawn selected; indicator or radio button"

	indication notNil ifTrue:[
	    "button is indicator and set"
	    isSelected := self indicationValue
	] ifFalse:[
	    isSelected := (choice notNil and:[choice value = menuItem choiceValue]).
	]
    ].
    y := 0.

    isSelected ifTrue:[
	level := menuPanel buttonActiveLevel.
	x     := x + 1 "level abs".
	y     := y + 1 "level abs".
    ] ifFalse:[
	level := self isEntered ifTrue:[menuPanel buttonEnteredLevel]
			       ifFalse:[menuPanel buttonPassiveLevel].
    ].

    drawObject notEmptyOrNil ifTrue:[
	etchFg notNil ifTrue:[
	    "/ donot draw images twice.. images are shown lightened
	    drawObject isImageOrForm ifFalse:[
		self drawRawLabel:drawObject atX:x+1 yOffset:y+1 paint:etchFg.
	    ].
	].
	self drawRawLabel:drawObject atX:x yOffset:y+0 paint:fg.
    ].
    self drawMenuIndicator.

    level ~~ 0 ifTrue:[
	menuPanel drawButtonEdgesFor:self level:level
    ].
!

drawLabel
    "draw a labeled entry; no button, no separator."

    |scKey cLb cLa drawObject fg etchFg arrow
     isSelected isEnabled form
     h "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"
     x "{ Class:SmallInteger }"
     t "{ Class:SmallInteger }"
    |
    drawObject := displayLabel.
    isEnabled  := self enabled.
    isSelected := self isSelected.

    isSelected ifTrue:[
        fg := self activeForegroundColor
    ] ifFalse:[
        isEnabled ifTrue:[
            self isEntered ifTrue:[
                fg := menuPanel enteredForegroundColor
            ] ifFalse:[
                fg := menuPanel foregroundColor
            ]
        ] ifFalse:[
            fg          := menuPanel disabledForegroundColor.
            etchFg      := menuPanel disabledEtchedForegroundColor.
            drawObject  := self disabledRawLabel
        ]
    ].

    h := layout height.
    x := layout left + HorizontalInset.
    t := layout top.

    (    (form := self indicatorForm) notNil
     or:[(form := self choiceForm) notNil]
    ) ifTrue:[
        y := t + ((h - form height) // 2).
        form displayOn:menuPanel x:x y:y.
    ].

    drawObject notEmptyOrNil ifTrue:[
        x := x + (menuPanel stringOffsetXfor:self).

        etchFg notNil ifTrue:[
            "/ do not draw images twice.. images are shown lightened
            drawObject isImageOrForm ifFalse:[
                self drawRawLabel:drawObject atX:x+1 yOffset:1 paint:etchFg.
            ].
        ].
        self drawRawLabel:drawObject atX:x yOffset:0 paint:fg.
    ].
    self drawMenuIndicator.

    "/ DRAW SHORTCUT KEY
    (     menuItem shortcutKey notNil
     and:[(x := menuPanel shortKeyInset) ~~ 0
     and:[(scKey:= self shortcutKeyAsString) notNil]]
    ) ifTrue:[            
        "/ x := layout left + x.
        x := menuPanel width - (menuPanel font widthOf:scKey) - 20.
        y := t + ((h - (scKey heightOn:menuPanel)) // 2).
        y := y + menuPanel font ascent.
        scKey displayOn:menuPanel x:x y:y.
    ].

    "/ DRAW SUBMENU INDICATION (if a vertical menu with submenu)
    (menuPanel isVerticalLayout and:[self hasSubmenu]) ifTrue:[
        arrow := menuPanel rightArrow.
        x := layout right - arrow width - HorizontalInset.
        y := t + ((h - arrow height) // 2).

        (menuPanel styleSheet is3D not
        or:[(drawObject := menuPanel rightArrowShadow) isNil]) ifTrue:[
            menuPanel displayForm:arrow x:x y:y.
        ] ifFalse:[
            cLa := menuPanel shadowColor.
            cLb := menuPanel lightColor.

            isSelected ifFalse:[
                fg  := cLa.
                cLa := cLb.
                cLb := fg
            ].
            menuPanel paint:cLa.
            menuPanel displayForm:arrow x:x y:y.
            menuPanel paint:cLb.
            menuPanel displayForm:drawObject x:x y:y.
        ].
    ].

    "Modified: / 06-09-1998 / 21:48:53 / cg"
    "Modified: / 12-05-2017 / 15:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawMenuIndicator
    "draw a menu indicator if the item has a menu or delayed menu."

    |x y icon bAbsLevel verticalPosition|

    icon := self menuIndicatorIcon.
    icon isNil ifTrue:[
	^ self
    ].

    x := layout right  - icon width.
    verticalPosition := menuPanel menuIndicatorVerticalPosition.
    verticalPosition == #center ifTrue:[
	y := (layout height - icon height) // 2 + layout top.
    ] ifFalse:[
	verticalPosition == #top ifTrue:[
	    y := layout top + 2.
	] ifFalse:[
	    y := layout bottom - icon height - 2.
	]
    ].

    bAbsLevel := 0.
    menuItem isButton ifTrue:[
	self isSelected ifTrue:[
	    x := x + 1.
	    y := y + 1.
	].
	bAbsLevel := menuPanel maxAbsoluteButtonLevel.
	x := x - bAbsLevel.
	y := y - bAbsLevel.
    ].
    x := x - 1 "- HorizontalInset".

    (self isEnabled "and:[self delayedMenuIsEnabled]") ifFalse:[
	icon := menuPanel lightenedImageOnDevice:icon
    ].
    icon displayOn:menuPanel x:x y:y.

    (menuPanel drawMenuIndicatorSeparatorLine
	and:[ self isEntered
	and:[ menuPanel buttonEnteredLevel ~~ 0] ])
    ifTrue:[
	menuPanel paint:menuPanel buttonShadowColor.
	menuPanel displayLineFromX:x-2 y:layout top+bAbsLevel+1 toX:x-2 y:layout bottom-bAbsLevel-2.
	menuPanel paint:menuPanel buttonLightColor.
	menuPanel displayLineFromX:x-1 y:layout top+bAbsLevel+1 toX:x-1 y:layout bottom-bAbsLevel-2.
    ].
!

drawRawLabel:aLabel atX:x yOffset:yOffset paint:fg
    "draw a labeled entry; no button, no separator."

    |oldFont labelExtent
     y  "{ Class:SmallInteger }"
     y0 "{ Class:SmallInteger }"
     x0 "{ Class:SmallInteger }"
     isSelected|

    isSelected := self isSelected.

    oldFont := menuPanel setFont:(self font).
    menuPanel paint:fg.
    labelExtent := self displayLabelExtent.

    y := layout top + ((layout height - labelExtent y) // 2) + yOffset.
    aLabel isArray ifFalse:[
        |printLabel|

        (aLabel isText or:[aLabel isLabelAndIcon]) ifTrue:[
            "/ background of label has already been drawn
            "/ cg: 1.12.2014: remove any emphasis (in case we draw grey on light blue)
            isSelected ifTrue:[
                printLabel := aLabel withoutAnyColorEmphasis.
            ] ifFalse:[
                printLabel := aLabel withoutBackgroundColorEmphasis.
            ].
        ] ifFalse:[
            printLabel := aLabel.
        ].
        y := y + (printLabel ascentOn:menuPanel).
        printLabel displayOn:menuPanel x:x y:y.
    ] ifTrue:[
        aLabel do:[:eachLine|
            |shownLine|

            eachLine notNil ifTrue:[
                "/ cg: 1.12.2014: remove any emphasis (in case we draw grey on light blue)
                isSelected ifTrue:[
                    shownLine := eachLine withoutAnyColorEmphasis.
                ] ifFalse:[
                    shownLine := eachLine withoutBackgroundColorEmphasis.
                ].

                y0 := y + (shownLine ascentOn:menuPanel).
"/                el isImageOrForm ifFalse:[
"/                    y0 := y + fontAscent
"/                ] ifTrue:[
"/                    y0 := y
"/                ].
                x0 := x + ((labelExtent x - (shownLine widthOn:menuPanel)) // 2).
                shownLine displayOn:menuPanel x:x0 y:y0.
                y := y + 1 + (shownLine heightOn:menuPanel)
            ] ifFalse:[
                y := y + (self spaceBetweenEmptyLines)
            ]
        ].
    ].
    menuPanel setFont:oldFont
!

drawSeparatingLines
    "draw separating lines"

    |myIndex lfSep rtSep items prevItem nextItem
     lightColor shadowColor
     l "{ Class:SmallInteger }"
     t "{ Class:SmallInteger }"
     r "{ Class:SmallInteger }"
     b "{ Class:SmallInteger }"
    |

    items := menuPanel items.
    myIndex := items identityIndexOf:self.

    prevItem  := items at:(myIndex - 1) ifAbsent:nil.
    lfSep := prevItem notNil and:[prevItem isButton not].

    nextItem  := items at:(myIndex + 1) ifAbsent:nil.
    rtSep := nextItem notNil and:[nextItem isButton not].

    (lfSep or:[rtSep]) ifFalse:[
        ^ self
    ].

    menuPanel suppressSeparatingLines ifTrue:[^ self].

    lightColor := menuPanel lightColor.
    shadowColor := menuPanel shadowColor.

    menuPanel paint:lightColor.

    l := layout left.
    t := layout top.
    r := layout right.
    b := layout bottom.

    menuPanel verticalLayout ifTrue:[
        lfSep ifTrue:[menuPanel displayLineFromX:l y:t-1 toX:r y:t-1].
        rtSep ifTrue:[menuPanel displayLineFromX:l y:b-1 toX:r y:b-1].

        menuPanel paint:shadowColor.
        lfSep ifTrue:[menuPanel displayLineFromX:l y:t-2 toX:r y:t-2].
        rtSep ifTrue:[menuPanel displayLineFromX:l y:b-2 toX:r y:b-2].
    ] ifFalse:[
        lfSep ifTrue:[menuPanel displayLineFromX:l-1 y:t toX:l-1 y:b].
        rtSep ifTrue:[menuPanel displayLineFromX:r-1 y:t toX:r-1 y:b].

        menuPanel paint:shadowColor.
        lfSep ifTrue:[menuPanel displayLineFromX:l-2 y:t toX:l-2 y:b].
        rtSep ifTrue:[menuPanel displayLineFromX:r-2 y:t toX:r-2 y:b].
    ]
!

drawSeparator
    "draw as separator"

    |type lightColor shadowColor isDouble
     left top
     x0  "{ Class:SmallInteger }"
     x1  "{ Class:SmallInteger }"
     y0  "{ Class:SmallInteger }"
     y1  "{ Class:SmallInteger }"
    |

    type := self separatorType.
    (type isNil or:[type == #blankLine]) ifTrue:[
        ^ self
    ].
    menuPanel suppressSeparatingLines ifTrue:[^ self].
    
    isDouble := type == #doubleLine.

    lightColor := menuPanel lightColor.
    shadowColor := menuPanel shadowColor.
    menuPanel paint:shadowColor.

    left := layout left.
    top := layout top.

    menuPanel verticalLayout ifTrue:[
        x0 := left  + HorizontalInset.
        x1 := layout right - HorizontalInset.
        y0 := top   - 1 + (layout height // 2).
        isDouble ifTrue:[y0 := y0 - 2].

        menuPanel displayLineFromX:x0 y:y0   toX:x1 y:y0.
        isDouble ifTrue:[menuPanel displayLineFromX:x0 y:y0+4 toX:x1 y:y0+4].

        menuPanel paint:lightColor.
        menuPanel displayLineFromX:x0 y:y0+1 toX:x1 y:y0+1.
        isDouble ifTrue:[menuPanel displayLineFromX:x0 y:y0+5 toX:x1 y:y0+5].

    ] ifFalse:[
        y1 := layout bottom.
        x0 := left - 1 + (layout width // 2).
        y0 := top.
        isDouble ifTrue:[x0 := x0 - 2].

        menuPanel displayLineFromX:x0   y:y0 toX:x0   y:y1.
        isDouble ifTrue:[menuPanel displayLineFromX:x0+4 y:y0 toX:x0+4 y:y1].

        menuPanel paint:lightColor.
        menuPanel displayLineFromX:x0+1 y:y0 toX:x0+1 y:y1.
        isDouble ifTrue:[menuPanel displayLineFromX:x0+5 y:y0 toX:x0+5 y:y1].
    ]
!

indicatorForm
    "returns indication form or nil"

    |isOn|

    indication isNil ifTrue:[^ nil].

    isOn := self indicationValue.
    self enabled ifFalse:[
	^ isOn == true
	    ifTrue:[menuPanel iconIndicationDisabledOn]
	    ifFalse:[menuPanel iconIndicationDisabledOff]
    ].
"/    self isSelected ifTrue:[
"/        ^ isOn == true
"/            ifTrue:[menuPanel iconIndicationEnteredOn]
"/            ifFalse:[menuPanel iconIndicationEnteredOff]
"/    ].

    ^ isOn == true
	ifTrue:[menuPanel iconIndicationOn]
	ifFalse:[menuPanel iconIndicationOff]
!

invalidate

    layout isNil ifTrue:[^ self].

    (displayLabel notNil and:[menuPanel notNil]) ifTrue:[
	menuPanel invalidateItem:self repairNow:false
    ]
!

menuIndicatorIcon
    "return a menu indicator icon used if the item has a menu or delayed menu."

    self hasDelayedMenuIndicator ifTrue:[
	^ MenuPanel delayedMenuIndicator.
    ].
    self hasMenuIndicator ifTrue:[
	^ MenuPanel menuIndicator.
    ].
    ^ nil
! !

!MenuPanel::Item methodsFor:'initialization'!

destroy
    "destroy submenus, remove dependencies"

    self submenu:nil.
    self removeDependencies.

    menuPanel := nil.
!

in:aPanel
    "create item in a menuPanel"

    menuPanel := aPanel.

    menuItem isNil ifTrue:[
	self breakPoint:#ca.
	menuItem := MenuItem new
    ].
!

initialize
    menuItem := MenuItem new.
!

reinitStyle

    subMenu notNil ifTrue:[
	subMenu reinitStyle
    ].

    "Created: / 17.8.2000 / 17:57:07 / cg"
    "Modified: / 17.8.2000 / 18:00:08 / cg"
! !

!MenuPanel::Item methodsFor:'label basics'!

disabledRawLabel
    "returns the label used if the item is disabled"

    |block form image|

    disabledDisplayLabel notNil ifTrue:[^ disabledDisplayLabel].

    disabledDisplayLabel := displayLabel ? ''.

    disabledDisplayLabel isString ifTrue:[
	^ disabledDisplayLabel
    ].

    block := [:el| |rslt|
	(rslt := el) notNil ifTrue:[
	    el isImageOrForm ifTrue:[
		el colorMap notNil ifTrue:[
		    rslt := menuPanel lightenedImageOnDevice:el
		]
	    ] ifFalse:[
		(displayLabel isKindOf:LabelAndIcon) ifTrue:[
		    ((form := el icon) notNil and:[form colorMap notNil]) ifTrue:[
			form := menuPanel lightenedImageOnDevice:form
		    ].
		    ((image := el image) notNil and:[image colorMap notNil]) ifTrue:[
			image := menuPanel lightenedImageOnDevice:image
		    ].
		    rslt := LabelAndIcon form:form image:image string:(el string).
		]
	    ]
	].
	rslt
    ].

    displayLabel isArray ifTrue:[
	disabledDisplayLabel := Array new:(displayLabel size).

	displayLabel keysAndValuesDo:[:anIndex :aLabel|
	    disabledDisplayLabel at:anIndex put:(block value:aLabel)
	]
    ] ifFalse:[
	disabledDisplayLabel := block value:displayLabel
    ].
    ^ disabledDisplayLabel
!

fetchDeviceResources

    disabledDisplayLabel := nil.
    self fetchImages.
!

fetchImages
    "fetch my icon images"

    |icon|

    (displayLabel isNil or:[displayLabel isString]) ifTrue:[
	^ self
    ].
    displayLabel isImageOrForm ifTrue:[
	displayLabel := menuPanel imageOnMyDevice:displayLabel.
	^ self.
    ].

    (displayLabel isKindOf:LabelAndIcon) ifTrue:[
	(icon := displayLabel image) notNil ifTrue:[
	    displayLabel image:(menuPanel imageOnMyDevice:icon)
	].
	(icon := displayLabel icon) notNil ifTrue:[
	    displayLabel icon:(menuPanel imageOnMyDevice:icon)
	].
	^ self
    ].

    displayLabel isArray ifFalse:[^ self].

    displayLabel keysAndValuesDo:[:i :el|
	(el notNil and:[el isString not]) ifTrue:[
	    el isImageOrForm ifTrue:[
		displayLabel at:i put:(menuPanel imageOnMyDevice:el).
	    ] ifFalse:[
		el class == LabelAndIcon ifTrue:[
		    (icon := el image) notNil ifTrue:[
			el image:(menuPanel imageOnMyDevice:icon)
		    ].
		    (icon := el icon) notNil ifTrue:[
			el icon:(menuPanel imageOnMyDevice:icon)
		    ]
		]
	    ]
	]
    ].
!

updateAccessCharacterFor:aLabel
    "replace &x by the short-key attribute (i.e. remove & and underline x)"

    accessCharacter notNil ifTrue:[^ aLabel].

    aLabel isString ifFalse:[
	aLabel class == LabelAndIcon ifTrue:[
	    aLabel string:(self updateAccessCharacterFor:(aLabel string))
	].
	^ aLabel
    ].

    ^ MenuPanel
		processAmpersandCharactersFor:aLabel
		withAccessCharacterPosition:(menuItem accessCharacterPosition).

    "Modified: / 15-02-2012 / 18:53:11 / cg"
! !

!MenuPanel::Item methodsFor:'printing & storing'!

printOn:aGCOrStream
    aGCOrStream
	nextPutAll:self class name;
	nextPut:$(.
    label displayOn:aGCOrStream.
    aGCOrStream nextPut:$).
! !

!MenuPanel::Item methodsFor:'private'!

activeBackgroundColor
    "returns the active background color derived from menuPanel"

    menuItem isButton ifTrue:[
	^ menuPanel buttonActiveBackgroundColor
    ].
    ^ menuPanel activeBackgroundColor
!

activeForegroundColor
    "returns the active foreground color derived from menuPanel"

    menuItem isButton ifTrue:[
	^ menuPanel buttonActiveForegroundColor
    ].
    ^menuPanel activeForegroundColor
!

backgroundColor
    "returns the background color derived from menuPanel"

    menuItem isButton ifTrue:[
	^ menuPanel buttonPassiveBackgroundColor
    ].
    ^ menuPanel backgroundColor
!

backgroundColorFromLabel
    "returns the background color derived from label or nil"

    |run|

    label isText ifFalse:[^ nil ].
    run := label emphasis.
    run size == 0 ifTrue:[^ nil ].

    run := run first.

    run size == 0 ifTrue:[
	(run value isColor and:[run key == #backgroundColor]) ifTrue:[
	    ^ run value
	]
    ] ifFalse:[
	run do:[:r|
	    (r value isColor and:[r key == #backgroundColor]) ifTrue:[
		^ r value
	    ]
	]
    ].
  ^ nil
!

buttonEnteredBackgroundColor
    "returns the background color to use when thhe mouse has entered
     derived from menuPanel"

    menuItem isButton ifTrue:[
	^ menuPanel buttonEnteredBackgroundColor
    ].
    ^ menuPanel backgroundColor
!

findSubMenuIn:aRecv
    "ask the receiver for a submenu aspect, sending it
     #aspectFor: first; then trying the selector itself.
     Ignore the error if that message is not understood
     (but not other message-not-understoods)"

    |subm sel numArgs gotMenu|

    aRecv isNil ifTrue:[^ nil].

    sel := menuItem submenuChannel.
    (sel isString or:[sel isSymbol]) ifFalse:[^ nil].
    sel := sel asSymbol.
    numArgs := sel numArgs.

    numArgs == 0 ifTrue:[
	gotMenu := false.
	MessageNotUnderstood handle:[:ex |
	    |selector|

	    ((selector := ex selector) == sel
	    or:[selector == #aspectFor:]) ifFalse:[
		ex reject
	    ].
	] do:[
	    subm := aRecv aspectFor:sel.
	    gotMenu := true.
	].
	"/ used to be subm notNil; however, this is a bad test,
	"/ as it does not allow for the app to return nil for no-menu.
	gotMenu ifTrue:[^ subm].
    ].

    (Array with:(aRecv) with:(aRecv class))
    do:[:aPossibleReceiver |
	MessageNotUnderstood handle:[:ex|
	    ex message selector == sel ifFalse:[ ex reject ]
	] do:[
	    numArgs == 0 ifTrue:[
		subm := aPossibleReceiver perform:sel
	    ] ifFalse:[
		numArgs == 1 ifTrue:[
		    subm := aPossibleReceiver perform:sel with:(menuItem argument ? menuPanel)
		] ifFalse:[
		    subm := aPossibleReceiver perform:sel with:(menuItem argument) with:menuPanel
		]
	    ]
	].
	subm notNil ifTrue:[^ subm].
	Smalltalk isSmalltalkDevelopmentSystem ifTrue:[
	    "/ ('MenuPanel [info]: no submenu for "%1" from %2' bindWith:sel with:aPossibleReceiver) infoPrintCR.
	]
    ].

    ^ subm

    "Modified: / 24-03-2011 / 11:20:24 / cg"
!

indicationValue
    "returns indication value or nil in case of no indication"

    |numArgs sel recv|

    indication isNil ifTrue:[^ nil].       "no indication specified"

    indication isSymbol ifFalse:[
        ^ indication value == true          "block or model"
    ].

    numArgs := indication numArgs.
    numArgs == 2 ifTrue:[
        recv := self receiver ? menuPanel application.
        (recv notNil and:[recv isValueModel not]) ifTrue:[
            sel := indication copyFrom:1 to:(indication indexOf:$:).
            sel := sel asSymbol.

            MessageNotUnderstood handle:[:ex|
                ex selector ~~ sel ifTrue:[
                    ex reject.
                ].
            ] do:[
                sel := recv perform:sel with:(menuItem argument).
            ]
        ].
    ] ifFalse:[
        numArgs == 0 ifTrue:[
            sel := indication
        ] ifFalse:[
            sel := (indication copyButLast:1) asSymbol.
        ].
        sel := self aspectAt:sel.
        sel isValueModel ifTrue:[
            indication := sel.
            indication addDependent:self.
        ].
    ].
    ^ sel value == true

    "Modified: / 05-02-2018 / 12:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indicationValue:aValue
    "set the indication value"

    |numArgs recv|

    indication isNil ifTrue:[^ self].                                   "no indication specified"

    indication isSymbol ifFalse:[
        indication perform:#value: with:aValue ifNotUnderstood:nil.     "block or model"
        ^ self
    ].

    (numArgs := indication numArgs) == 0 ifTrue:[                       "no arguments to selector; cannot set"
        ^ self
    ].

    recv := self receiver.
    recv isValueModel ifTrue:[^ self].

    recv isNil ifTrue:[
        recv := menuPanel application.
        recv isNil ifTrue:[^ self].
    ].

    MessageNotUnderstood handle:[:ex|
        (ex selector ~~ indication) ifTrue:[
            ex reject
        ].
        self ifNotInUIBuilderInfoPrintCR:
            ('application (%1) does not respond to: %2'
             bindWith:recv classNameWithArticle
             with:indication).
    ] do:[
        numArgs == 1 ifTrue:[
            recv perform:indication with:aValue
        ] ifFalse:[
            recv perform:indication with:(menuItem argument ? self) with:aValue
        ]
    ].

    "Modified (format): / 02-08-2013 / 16:42:20 / cg"
    "Modified: / 05-02-2018 / 12:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isEntered
    "returns true if the mouse pointer is over the item"

    ^ menuPanel enteredItem == self

    "Created: / 20.8.1998 / 13:11:50 / cg"
!

separatorType
    "returns type of separator line or nil"

    |c lbl|

    self isSeparator ifFalse:[
	^ nil
    ].

    (lbl := label value) isNil ifTrue:[
	^ #singleLine
    ].

    lbl size == 1 ifTrue:[
	c := lbl first.
	c == $- ifTrue:[^ #singleLine].
	c == $= ifTrue:[^ #doubleLine].
    ].
    ^ #blankLine
!

setupSubmenu
    |appl submenuProvider master recv submenuHolder newSubmenu submenuEncoding
     channel whoProvidedMenu t|

    channel := menuItem submenuChannel value.
    channel isNil ifTrue:[ ^ subMenu ].

    subMenu notNil ifTrue:[
	menuItem keepLinkedMenu ifTrue:[ ^ subMenu ].
    ].

    channel isSymbol ifFalse:[
	submenuHolder := channel
    ] ifTrue:[
	"/ submenu is specified by a selector in submenuChannel.
	"/ who gets me the menu:
	"/ 1) submenuProvider (if not nil)
	"/ 2) menuPanel application
	"/ 3) menuPanel receiver
	"/ 4) menuPanel application master-chain
	"/ 5) menuPanel receiver master-chain

	(submenuProvider := menuItem submenuProvider) notNil ifTrue:[
	    submenuHolder := self findSubMenuIn:submenuProvider.
	    whoProvidedMenu := submenuProvider.
	].
	submenuHolder isNil ifTrue:[
	    appl := menuPanel application.
	    (appl notNil and:[appl ~~ submenuProvider]) ifTrue:[
		submenuHolder := self findSubMenuIn:appl.
		whoProvidedMenu := appl.
	    ].
	    submenuHolder isNil ifTrue:[
		recv := menuPanel receiver.
		(recv notNil and:[recv ~~ appl and:[recv ~~ submenuProvider]]) ifTrue:[
		    submenuHolder := self findSubMenuIn:recv.
		    whoProvidedMenu := recv.
		].
		(submenuHolder isNil and:[appl notNil]) ifTrue:[
		    t := appl.
		    [ submenuHolder isNil
		       and:[ (master := t perform:#masterApplication ifNotUnderstood:nil) notNil ]
		    ] whileTrue:[
		       ( master ~~ appl
			and:[ master ~~ recv
			and:[ master ~~ submenuProvider ]] ) ifTrue:[
			    submenuHolder := self findSubMenuIn:master.
			].
			t := master.
			whoProvidedMenu := master.
		    ]
		].
		(submenuHolder isNil and:[recv notNil]) ifTrue:[
		    t := recv.
		    [ submenuHolder isNil
		       and:[ (master := t perform:#masterApplication ifNotUnderstood:nil) notNil ]
		    ] whileTrue:[
		       ( master ~~ appl
			and:[ master ~~ recv
			and:[ master ~~ submenuProvider ]] ) ifTrue:[
			    submenuHolder := self findSubMenuIn:master.
			].
			t := master.
			whoProvidedMenu := master.
		    ]
		].
	    ].
	].
"/        submenuHolder isNil ifTrue:[
"/            self halt:'did not find any menu'
"/        ].

"/        appl := menuPanel application.
"/        appl isNil ifTrue:[
"/            appl := menuPanel receiver.
"/            appl notNil ifTrue:[
"/                (submenuHolder := self findSubMenuIn:appl) isNil ifTrue:[
"/                    [submenuHolder isNil
"/                     and:[(master := appl perform:#masterApplication ifNotUnderstood:nil) notNil
"/                          and:[master ~~ appl]]] whileTrue:[
"/                        appl := master.
"/                        submenuHolder := self findSubMenuIn:appl.
"/                    ].
"/                ]
"/            ].
"/        ].
"/        submenuHolder isNil ifTrue:[
"/            (submenuHolder := self findSubMenuIn:appl) isNil ifTrue:[
"/                (recv := menuPanel receiver) ~~ appl ifTrue:[
"/                    appl := recv.
"/                    submenuHolder := self findSubMenuIn:appl
"/                ]
"/            ]
"/        ]
    ].

    (newSubmenu := submenuHolder value) isArray ifTrue:[
	submenuEncoding := newSubmenu.
	newSubmenu := Menu decodeFromLiteralArray:submenuEncoding.
	"/ cg: linked menus also may contain translations ...
	newSubmenu notNil ifTrue:[
	    whoProvidedMenu "appl" notNil ifTrue:[
		newSubmenu findGuiResourcesIn:whoProvidedMenu "appl".
	    ]
	].
    ].
    "/ appl notNil ifTrue:[submenu application:appl].
    self submenu:newSubmenu.
    ^ subMenu

    "Modified: / 22-09-2010 / 14:37:46 / cg"
!

spaceBetweenEmptyLines
	^ 3
! !

!MenuPanel::Item methodsFor:'queries'!

canChangeVisibility
    "return true if I am not always visible; can only be changed by a selector
     otherwise there is a change notification raised if the model changed"

    ^ isVisible isSymbol or:[isVisible isValueModel]
"/  ^ isVisible notNil and:[isVisible ~~ true]

    "Modified: / 11-10-2006 / 21:43:31 / cg"
    "Modified: / 12-10-2006 / 09:30:48 / User"
!

canSelect
    "returns true if item is selectable; no separator, visible and enabled.
     in case of a choice (RadioButton) i have to check for the choiceValue"

    self isSeparator ifTrue:[^ false].

    (self isVisible and:[self enabled]) ifTrue:[
	(choice isNil or:[choice value ~= menuItem choiceValue]) ifTrue:[
	    ^ true
	].
    ].
    ^ false
!

containsPoint:aPoint
    "returns true if aPoint is contained in my layout"

    (self isVisible and:[layout notNil]) ifTrue:[
	^ layout containsPoint:aPoint
    ].
    ^ false

    "Created: / 13.11.2001 / 13:55:31 / cg"
!

containsPointX:x y:y
    "returns true if point is contained in my layout"

    (self isVisible and:[layout notNil]) ifTrue:[
	^ layout containsPointX:x y:y
    ].
    ^ false
!

hasDelayedMenu
    "returns true if a delayed menu exists"

    self hasSubmenu ifFalse:[
	^ false
    ].
    menuItem itemValue notNil ifTrue:[ ^ true ].

    (indication isNil and:[choice isNil]) ifTrue:[
	^ false
    ].
    ^ true
!

hasDelayedMenuIndicator
    "returns true if the item has a delayed menu
     and is in the topMenuPanel (because submenuIndicator is already drawn in popUpViews)"

    menuPanel isPopUpView ifFalse:[
	^ self hasDelayedMenu
    ].
    ^ false
!

hasIndication
    "returns true if on/off indication exists"

    ^ indication notNil
!

hasMenuIndicator
    "returns true if the item has a delayed menu
     and is in the topMenuPanel (because submenuIndicator is already drawn in popUpViews)"

    menuPanel isPopUpView ifFalse:[
	^ self hasSubmenu and:[menuItem isButton]
    ].
    ^ false
!

hasSubmenu
    "returns true if the item is configured as an subMenu entry"

    ^ subMenu notNil or:[ menuItem submenuChannel notNil ]
!

isEnabled
    "returns the enabled state"

    ^ self enabled
!

isSeparator
    "returns true if item is a separator"

    ^ displayLabel isNil
!

isToggle
    "returns true if on/off indication exists"

    ^ self hasIndication and:[ self isButton ]
!

isVisible
    "returns the visibility state"

    |state|

    menuPanel isNil ifTrue:[^ false].

    isVisible isSymbol ifTrue:[
        state := self aspectAt:isVisible.
        state isValueModel ifTrue:[
            isVisible := state.
            isVisible addDependent:self.
        ].
    ] ifFalse:[
        state := isVisible
    ].
    ^ state value ~~ false

    "Modified: / 5.10.1998 / 12:08:28 / cg"
!

isVisible:something
    "change the visibility state; if the state changed, a redraw is performed"

    |oldState newState|

    isVisible isNil ifTrue:[
	oldState := true
    ] ifFalse:[
	oldState := isVisible value.
	isVisible isValueModel ifTrue:[
	    isVisible removeDependent:self
	]
    ].
    isVisible := something.

    isVisible isNil ifTrue:[
	newState := true
    ] ifFalse:[
	isVisible isValueModel ifTrue:[
	    isVisible addDependent:self
	] ifFalse:[
	    isVisible isSymbol ifTrue:[^ self]
	].
	menuPanel shown ifFalse:[^ self].
	newState := isVisible value.
    ].

    newState ~~ oldState ifTrue:[
	menuPanel mustRearrange
    ]

    "Modified: / 5.10.1998 / 12:12:04 / cg"
!

menuIndicatorContains:aPoint
    "returns true if the items delayed menu is hit by a button-press"

    |icon xSep|

    (self isVisible and:[layout notNil]) ifTrue:[
	(layout containsPoint:aPoint) ifTrue:[
	    icon := self menuIndicatorIcon.
	    icon notNil ifTrue:[
		xSep := layout right - icon width.
		^ aPoint x >= xSep
	    ]
	]
    ].
    ^ false
!

needsItemSpaceWhenDrawing
    ^ self isSeparator not and:[menuItem isButton not]
!

shortcutKeyAsString
    "converts shortcutKey to a text object for the menu-label-hint.
     returns nil, if the key has no assignment."

    |shortcutKey|

    shortcutKey := menuItem shortcutKey.

    shortcutKey isNil ifTrue:[
        ^ nil
    ].
    shortcutKey isCharacter ifTrue:[
        shortcutKey == Character space ifFalse:[
            ^ 'Space'
        ].
        ^ shortcutKey asString
    ].
    ^ menuPanel shortKeyStringFor:shortcutKey.

    "Modified: / 08-08-2006 / 15:46:24 / cg"
    "Modified: / 08-02-2017 / 23:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MenuPanel::Item methodsFor:'selection'!

isSelected
    "returns true if item is selected"

    ^ menuPanel notNil and:[menuPanel selection == self]
!

isSelected:isSelected
    "change selection to a state. Depending on the state open or hide an existing
     submenu and perform a redraw"

    (isSelected and:[menuPanel notNil]) ifFalse:[
        self invalidate.
        self hideSubmenu.
        ^ self
    ].

    menuPanel realized ifFalse:[ ^ self ].

    (indication isNil or:[menuItem isButton not]) ifTrue:[
        self invalidate
    ].
    self hasSubmenu ifFalse:[ ^ self].

    self hasDelayedMenu ifTrue:[
        menuPanel openDelayed:self
    ] ifFalse:[
        self setupSubmenu.
        subMenu notNil ifTrue:[ self openSubmenu ].
    ].

    "Modified: / 07-11-2006 / 11:08:03 / cg"
! !

!MenuPanel::Item methodsFor:'testing'!

isMenuItem
    "return true, if the receiver is a menu item inside a MenuPanel, Menu or PopUpmenu.
     true is returned here - I am a menuitem"

    ^ true
! !

!MenuPanel::Item::Adornment methodsFor:'accessing'!

argument2

  ^ argument2
!

argument2:anArgumentOrNil

    argument2 := anArgumentOrNil
! !

!MenuPanel::ScrollActivity class methodsFor:'default icons'!

icon
    ^ self iconGrey
! !

!MenuPanel::ScrollActivity class methodsFor:'image specs'!

iconBlack
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconBlack inspect
     ImageEditor openOnClass:self andSelector:#iconBlack
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconBlack'
        ifAbsentPut:[(Depth1Image width:11 height:11) bits:(ByteArray fromPackedString:'?>@@@@@@ @C@@N@@<@C8@O<@@@@@@@@a') colorMapFromArray:#[0 0 0 255 255 255] mask:((ImageMask width:11 height:11) bits:(ByteArray fromPackedString:'@@@@@@@@_<@? A<@C @D@@@@@@@@@@@a'); yourself); yourself]
!

iconGrey
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconGrey inspect
     ImageEditor openOnClass:self andSelector:#iconGrey
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconGrey'
        ifAbsentPut:[(Depth1Image width:11 height:11) bits:(ByteArray fromPackedString:'?>@@@@@@ @C@@N@@<@C8@O<@@@@@@@@a') colorMapFromArray:#[91 91 91 255 255 255] mask:((ImageMask width:11 height:11) bits:(ByteArray fromPackedString:'@@@@@@@@_<@? A<@C @D@@@@@@@@@@@a'); yourself); yourself]
!

iconGrey3D
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconGrey inspect
     ImageEditor openOnClass:self andSelector:#iconGrey
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconGrey'
        ifAbsentPut:[(Depth1Image width:11 height:11) bits:(ByteArray fromPackedString:'?>@@@@@@ @C@@N@@<@C8@O<@@@@@@@@a') colorMapFromArray:#[91 91 91 255 255 255] mask:((ImageMask width:11 height:11) bits:(ByteArray fromPackedString:'@@@@@@@@_<@? A<@C @D@@@@@@@@@@@a'); yourself); yourself]
!

iconScrollLeft
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconScrollLeft inspect
     ImageEditor openOnClass:self andSelector:#iconScrollLeft
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconScrollLeft'
        ifAbsentPut:[(Depth8Image width:12 height:14) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@1H14@@@@@@@@@@A4R@A@@@@@@@@@@J@8I@" @@@@@@@@ B28)@Q8@@@@@@A$$F!! FG @@@@@@C@P,E (^@@@@@@@@CAPWA2,@
@@@@@@@@@@L%D2X"@@@@@@@@@@@HCPT[EP@@@@@@@@@@BB<*G0X@@@@@@@@@@@0''KP<@@@@@@@@@@C@\K"@@@@@@@@@@@@@^DQ8@@@@@') colorMapFromArray:#[139 138 139 227 227 227 133 133 133 240 240 240 106 106 106 173 173 173 226 226 226 160 160 160 239 239 239 145 145 145 225 225 225 104 104 104 238 238 238 157 157 157 103 103 103 116 116 116 89 89 89 250 250 250 102 102 102 169 169 169 142 142 142 222 222 222 155 155 155 168 168 168 141 141 141 236 236 236 154 154 154 127 127 127 234 234 234 229 229 230 247 247 247 128 128 128 233 233 233 246 246 246 219 219 219 85 85 85 107 107 108 152 152 152 125 125 125 165 165 165 231 231 231 137 137 137 177 177 177 217 217 217 163 163 163 176 176 176 149 149 149 162 162 162 247 246 247 228 228 228] mask:((Depth1Image width:12 height:14) bits:(ByteArray fromPackedString:'@@@G@@<@G0@?@G8@?@C8@G0@O @_@@<@C0@G@@@a'); yourself); yourself]
!

iconScrollLeftM
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconScrollLeftM inspect
     ImageEditor openOnClass:self andSelector:#iconScrollLeftM
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconScrollLeftM'
        ifAbsentPut:[(Depth8Image width:12 height:14) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@1H14@@A4@@@@@@A4R@A@@@@@]@@@@J@8I@ @]@A4@@@@ B28)@Q8@GP@@@A$$F!! FG @]@A4@C@P,E (^GQ4@GP@]CAPWA2,]
GP@]@A4@@@L%D2X"GQ4@GP@@@@@HCPT[EP@]@A4@@@@@BB<*G0X@GP@]@@@@@@0''KP<]@A4@@@@@@@@\K"@@GP@@@@@@@@@@DQ8]@A4@') colorMapFromArray:#[139 138 139 227 227 227 133 133 133 240 240 240 106 106 106 173 173 173 226 226 226 160 160 160 239 239 239 145 145 145 225 225 225 104 104 104 238 238 238 157 157 157 103 103 103 116 116 116 89 89 89 250 250 250 102 102 102 169 169 169 142 142 142 222 222 222 155 155 155 168 168 168 141 141 141 236 236 236 154 154 154 127 127 127 234 234 234 229 229 230 247 247 247 128 128 128 233 233 233 246 246 246 219 219 219 85 85 85 107 107 108 152 152 152 125 125 125 165 165 165 231 231 231 137 137 137 177 177 177 217 217 217 163 163 163 176 176 176 149 149 149 162 162 162 247 246 247 228 228 228] mask:((Depth1Image width:12 height:14) bits:(ByteArray fromPackedString:'@@@GH@<PG*@?PG: ?5C>(G=@O*@_T@> A4@C(@@a'); yourself); yourself]
!

iconScrollRight
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconScrollRight inspect
     ImageEditor openOnClass:self andSelector:#iconScrollRight
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconScrollRight'
        ifAbsentPut:[(Depth8Image width:12 height:14) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A4#LP@@@@@@@@@@@A@@D!!4@@@@@@@@@@B BBP8(@@@@@@@@@A8AJR8KH@@@@@@@@@@^A!! ZIA$@@@@@@@@@G (VK@PL@@@@@@@@
@B,GE1PL@@@@@@@@H"XSIPL@@@@@@@@UF0TMB@@@@@@@@@X_J"<H@@@@@@@@@@<-I00@@@@@@@@@@B@.GC@@@@@@@@@@@A8QG @@@@@@') colorMapFromArray:#[139 138 139 227 227 227 133 133 133 240 240 240 106 106 106 173 173 173 226 226 226 160 160 160 239 239 239 145 145 145 225 225 225 104 104 104 238 238 238 157 157 157 103 103 103 116 116 116 89 89 89 250 250 250 102 102 102 169 169 169 142 142 142 222 222 222 155 155 155 168 168 168 141 141 141 236 236 236 154 154 154 127 127 127 234 234 234 229 229 230 247 247 247 128 128 128 233 233 233 246 246 246 219 219 219 85 85 85 107 107 108 152 152 152 125 125 125 165 165 165 231 231 231 137 137 137 177 177 177 217 217 217 163 163 163 176 176 176 149 149 149 162 162 162 247 246 247 228 228 228] mask:((Depth1Image width:12 height:14) bits:(ByteArray fromPackedString:'@@@N@@<@C8@O0@_ @?@A<@O A<@O @<@C0@N@@@a'); yourself); yourself]
!

iconScrollRightM
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconScrollRightM inspect
     ImageEditor openOnClass:self andSelector:#iconScrollRightM
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuPanel::ScrollActivity iconScrollRightM'
        ifAbsentPut:[(Depth8Image width:12 height:14) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@A4@@A4#LP@@@@@@GP@@@A@@D!!4@@@@@@A4@GP@BBP8(@@@@@@@]@A8AJR8KH@@@@A4@GP@^A!! ZIA$@GP@]@A4]G (VK@PL@A4@GP@]
GR,GE1PL@@@]@A4]H"XSIPL@@A4@GP@UF0TMB@@@GP@]@@X_J"<H@@@@@A4@GP<-I00@@@@@@@@]@B@.G@@@@@@@@A4@GQ8Q@@@@@@@@') colorMapFromArray:#[139 138 139 227 227 227 133 133 133 240 240 240 106 106 106 173 173 173 226 226 226 160 160 160 239 239 239 145 145 145 225 225 225 104 104 104 238 238 238 157 157 157 103 103 103 116 116 116 89 89 89 250 250 250 102 102 102 169 169 169 142 142 142 222 222 222 155 155 155 168 168 168 141 141 141 236 236 236 154 154 154 127 127 127 234 234 234 229 229 230 247 247 247 128 128 128 233 233 233 246 246 246 219 219 219 85 85 85 107 107 108 152 152 152 125 125 125 165 165 165 231 231 231 137 137 137 177 177 177 217 217 217 163 163 163 176 176 176 149 149 149 162 162 162 247 246 247 228 228 228] mask:((Depth1Image width:12 height:14) bits:(ByteArray fromPackedString:'@@AN@H<@U8@/0E_ +?AW<B? U<B/ E<@K A\@@@a'); yourself); yourself]
! !

!MenuPanel::ScrollActivity class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!MenuPanel::ScrollActivity methodsFor:'accessing'!

activeMenu
    "returns the active menu the scrolling is activated on; nil
     is returned if scrolling is deactivated"

    ^ activeMenu
!

direction
    "returns the scroll-direction"

    ^ direction
!

iconAt:aDirection on:aMenu
    |icon menusDevice index|

    menusDevice := aMenu device.

    aDirection == #PREV ifTrue:[
        aMenu verticalLayout ifTrue:[index := 3]    "/ 3 - 1 * 90  180
                            ifFalse:[index := 2]    "/ 2 - 1 * 90  90
    ] ifFalse:[
        aMenu verticalLayout ifTrue:[index := 1]    "/ 1 - 1 * 90  0
                            ifFalse:[index := 4]    "/ 4 - 1 * 90  270
    ].

    icon := icons at:index.

    (icon isNil or:[icon device ~~ menusDevice]) ifTrue:[
        icon := self class icon.
        index > 1 ifTrue:[ icon := icon rotated:((index - 1) * 90) ]
                 ifFalse:[ icon := icon copy ].

        icon := icon onDevice:menusDevice.
        icons at:index put:icon
    ].
    ^ icon

    "Modified (format): / 16-11-2016 / 23:12:59 / cg"
! !

!MenuPanel::ScrollActivity methodsFor:'initialization'!

initialize

    semaLock := RecursionLock new name:'MenuPanel ScrollActivity'.
    icons    := Array new:4.
! !

!MenuPanel::ScrollActivity methodsFor:'queries'!

isActive
    "returns true if scrolling is activated"

    ^ activeMenu notNil
! !

!MenuPanel::ScrollActivity methodsFor:'user operations'!

startIfRequiredAt:aDirection on:aMenu comesViaButtonPress:comesViaButtonPress
    "start scrolling; returns true if scrolling is activated"

    |isScrolledMenu|
"/true ifTrue:[^ self __startIfRequiredAt:aDirection on:aMenu comesViaButtonPress:comesViaButtonPress].

    isScrolledMenu := (aDirection notNil and:[aMenu notNil and:[aMenu hasScrollers]]).

    semaLock critical:[ |bounds boundsOnRoot|
        self stop.

        (aMenu notNil and:[aMenu shown and:[aMenu hasScrollerAt:aDirection]]) ifTrue:[
            bounds := aMenu scrollerBoundsAt:aDirection.

            comesViaButtonPress ifFalse:[
                boundsOnRoot := Rectangle origin:(aMenu device translatePointToRoot:(bounds origin) fromView:aMenu)
                                          extent:(bounds extent).
            ].
            "clear selection"
            aMenu selection:nil openMenu:false.

            activeMenu := aMenu.
            direction  := aDirection.

            (aMenu hasScrollerAt:aDirection) ifTrue:[
                scrollTask :=
                    [
                        |continue|

                        [
                            aDirection == #PREV ifTrue:[aMenu scrollUp] ifFalse:[aMenu scrollDown].
                            Delay waitForSeconds:(ButtonController defaultInitialDelay).

                            [
                                continue := aMenu shown.

                                boundsOnRoot notNil ifTrue:[
                                    continue ifTrue:[
                                        continue := boundsOnRoot containsPoint:aMenu sensor mousePoint.
                                    ] ifFalse:[
                                        boundsOnRoot := nil.
                                    ]
                                ].
                                continue
                            ]  whileTrue:[
                                aDirection == #PREV ifTrue:[aMenu scrollUp] ifFalse:[aMenu scrollDown].
                                Delay waitForSeconds:(ButtonController defaultRepeatDelay).
                            ].
                        ] ensure:[
                            activeMenu := direction := scrollTask := nil.
                            aMenu invalidate:bounds.
                        ].
                    ] forkAt:8.
            ] ifFalse:[
                aMenu invalidate:bounds.
            ].
        ].
    ].
    ^ scrollTask notNil

    "Created: ca"

    "Modified: / 13.11.2001 / 20:15:52 / cg"
!

stop
    "stop scrolling; returns true if the scrolling was activated otherwise false"

    |task resp|

    activeMenu isNil ifTrue:[
	^ false
    ].

    semaLock critical:[
	resp := activeMenu notNil.

	(task := scrollTask) notNil ifTrue:[
	    scrollTask := nil.

	    Error handle:[:ex|
	    ] do:[
		task terminateWithAllSubprocessesInGroup.
		task waitUntilTerminated.
	    ].
	].
	activeMenu := direction := nil.
    ].
    ^ resp
! !

!MenuPanel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


MenuPanel initialize!
