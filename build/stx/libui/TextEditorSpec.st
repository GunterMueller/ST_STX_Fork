"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewWithScrollerSpec subclass:#TextEditorSpec
	instanceVariableNames:'isReadOnly callbacksSpec acceptChannel modifiedChannel
		acceptCallBack showingCode allowDoIt tabRequiresControl
		hasKeyboardFocusInitially'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!TextEditorSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.
"

! !

!TextEditorSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'TextEditorSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU0A@@@@B@D***+HDRUUUT!!AH@UUR@D%UUUH@R@@ET AIUUURLD @UUH,RUUUT AH@@AR@D5UUUH<P@@@@"3*****@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!TextEditorSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TextEditorSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'TextEditor Basics'
          name: 'TextEditor Basics'
          min: (Point 10 10)
          max: (Point 1280 1024)
          bounds: (Rectangle 0 0 400 311)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: UISpecification
              minorKey: subSpecForIDAndModelAndViewClass
            )
           (UISubSpecification
              name: 'menuSubSpec'
              layout: (LayoutFrame 0 0.0 99 0 0 1.0 214 0)
              majorKey: UISpecification
              minorKey: menuSubSpec
            )
           (UISubSpecification
              name: 'scrollerSubSpec'
              layout: (LayoutFrame 0 0.0 215 0 0 1.0 316 0)
              majorKey: UISpecification
              minorKey: scrollerSubSpec
            )
           )
         
        )
      )

    "Modified: / 01-01-1970 / 01:00:00 / cg"
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TextEditorSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'TextEditor Channels'
         name: 'TextEditor Channels'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 403 247)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 155 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 10 0.0 4 1.0 35 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 35 0.0 4 1.0 60 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'AcceptChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 60 0.0 4 1.0 85 0)
                   majorKey: UISpecification
                   minorKey: subSpecForAcceptChannel
                 )
                (UISubSpecification
                   name: 'ModifiedChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 85 0.0 4 1.0 110 0)
                   majorKey: UISpecification
                   minorKey: subSpecForModifiedChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 155 0 0 1.0 243 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 -1 0.0 4 1.0 24 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 24 0.0 4 1.0 49 0)
                   majorKey: UISpecification
                   minorKey: subSpecForAcceptCallBack
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TextEditorSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'TextEditor Details'
         name: 'TextEditor Details'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 490 487)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'fontColorSubSpec'
                   majorKey: UISpecification
                   minorKey: fontColorBorderSubSpec
                   extent: (Point 490 159)
                 )
                (FramedBoxSpec
                   label: 'Init Attributes'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Initially Invisible'
                         name: 'initiallyInvisibleCheckBox'
                         layout: (LayoutOrigin 10 0 1 0)
                         activeHelpKey: initiallyInvisible
                         tabable: true
                         model: initiallyInvisible
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 490 68)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabableCheckBox'
                         layout: (LayoutOrigin 10 0 5 0)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Read Only'
                         name: 'isReadOnlyCheckBox'
                         layout: (LayoutOrigin 174 0 5 0)
                         activeHelpKey: readOnly
                         tabable: true
                         model: isReadOnly
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Has Initial Focus'
                         name: 'hasInitialFocusCheckBox'
                         layout: (LayoutOrigin 10 0 35 0)
                         activeHelpKey: hasKeyboardFocusInitially
                         tabable: true
                         model: hasKeyboardFocusInitially
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 490 102)
                 )
                (FramedBoxSpec
                   label: 'Text Attributes'
                   name: 'FramedBox4'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Allow DoIt'
                         name: 'AllowDoItCheckBox'
                         layout: (LayoutOrigin 174 0 5 0)
                         activeHelpKey: allowDoIt
                         tabable: true
                         model: allowDoIt
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Showing Code'
                         name: 'ShowingCodeCheckBox'
                         layout: (LayoutOrigin 10 0 5 0)
                         activeHelpKey: showingCode
                         tabable: true
                         model: showingCode
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 490 71)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!TextEditorSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        isReadOnly
                        allowDoIt
                        showingCode
                        hasKeyboardFocusInitially
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:#(
                        x_acceptChannel
                        x_modifiedChannel
                        acceptCallBack
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 30.1.1998 / 14:44:45 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(     
        (Basics         basicsEditSpec)
        (Details        detailsEditSpec)
        (Channels       channelsEditSpec)
        ('Drag && Drop'  dragAndDropSpec)
      )
! !

!TextEditorSpec class methodsFor:'queries'!

supportsDrag
    ^ false

!

supportsDrop
    ^ true

!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ false

!

viewClass
    "only needed for completeness;
     UIPainter needs it to generate a replace-by list"

    ^ EditTextView

    "Created: / 05-09-2012 / 19:21:39 / cg"
! !

!TextEditorSpec methodsFor:'accessing'!

acceptCallBack
    "return the value of the instance variable 'acceptCallBack' (automatically generated)"

    ^ acceptCallBack
!

acceptCallBack:aspectName
    "set the value of the instance variable 'acceptCallBack' (automatically generated)"

    acceptCallBack := aspectName.
!

allowDoIt
    "return the value of the instance variable 'allowDoIt' (automatically generated)"

    ^ allowDoIt ? false
!

allowDoIt:aBoolean
    allowDoIt := aBoolean.
!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec

    "Created: 7.4.1997 / 19:18:57 / cg"
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.

    "Created: 7.4.1997 / 19:18:57 / cg"
!

hasHorizontalScrollBar
    "return the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    ^ hasHorizontalScrollBar ? true

    "Created: 7.4.1997 / 19:12:50 / cg"
    "Modified: 8.4.1997 / 00:36:05 / cg"
!

hasHorizontalScrollBar:aBoolean
    "set the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    hasHorizontalScrollBar := aBoolean.

    "Created: 7.4.1997 / 19:12:50 / cg"
!

hasKeyboardFocusInitially
    ^ hasKeyboardFocusInitially ? false
!

hasKeyboardFocusInitially:aBoolean
    hasKeyboardFocusInitially := aBoolean.
!

hasVerticalScrollBar
    "return the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    ^ hasVerticalScrollBar ? true

    "Created: 7.4.1997 / 19:12:53 / cg"
    "Modified: 8.4.1997 / 00:36:01 / cg"
!

hasVerticalScrollBar:aBoolean
    "set the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    hasVerticalScrollBar := aBoolean.

    "Created: 7.4.1997 / 19:12:53 / cg"
!

isReadOnly
    "return true, if the text is readonly."

    ^ isReadOnly ? false

    "Created: 14.2.1997 / 16:00:03 / cg"
!

isReadOnly:aBoolean
    "set the value of the instance variable 'isReadOnly' (automatically generated)"

    isReadOnly := aBoolean.
!

miniScrollerHorizontal
    "return the value of the instance variable 'miniScrollerHorizontal' (automatically generated)"

    hasHorizontalScrollBar ~~ true ifTrue:[^ false].
    ^ miniScrollerHorizontal ? false

    "Created: 7.4.1997 / 19:12:55 / cg"
    "Modified: 8.4.1997 / 00:54:49 / cg"
!

miniScrollerHorizontal:aBoolean
    "set the value of the instance variable 'miniScrollerHorizontal' (automatically generated)"

    miniScrollerHorizontal := aBoolean.

    "Created: 7.4.1997 / 19:12:55 / cg"
!

miniScrollerVertical
    "return the value of the instance variable 'miniScrollerVertical' (automatically generated)"

    hasVerticalScrollBar ~~ true ifTrue:[^ false].
    ^ miniScrollerVertical ? false

    "Created: 7.4.1997 / 19:12:59 / cg"
    "Modified: 8.4.1997 / 00:54:57 / cg"
!

miniScrollerVertical:aBoolean
    "set the value of the instance variable 'miniScrollerVertical' (automatically generated)"

    miniScrollerVertical := aBoolean.

    "Created: 7.4.1997 / 19:12:59 / cg"
!

showingCode
    ^ showingCode ? false
!

showingCode:aBoolean
    showingCode := aBoolean.
!

tabRequiresControl
    ^ tabRequiresControl
!

tabRequiresControl:aBoolean
    tabRequiresControl := aBoolean.
! !

!TextEditorSpec methodsFor:'accessing-channels'!

acceptChannel
    "return the value of the instance variable 'acceptChannel' (automatically generated)"

    ^ acceptChannel
!

acceptChannel:aspectName
    "set the value of the instance variable 'acceptChannel' (automatically generated)"

    acceptChannel := aspectName.
!

modifiedChannel
    "return the value of the instance variable 'modifiedChannel' (automatically generated)"

    ^ modifiedChannel
!

modifiedChannel:aspectName
    "set the value of the instance variable 'modifiedChannel' (automatically generated)"

    modifiedChannel := aspectName.
!

x_acceptChannel
    "return the value of the instance variable 'acceptChannel' (automatically generated)"

    "/ called x_* to avoid confusion with UIPainter specs acceptChannel

    ^ acceptChannel

    "Created: / 31.1.2000 / 01:34:03 / cg"
!

x_acceptChannel:something
    "set the value of the instance variable 'acceptChannel' (automatically generated)"

    "/ called x_* to avoid confusion with UIPainter specs acceptChannel

    acceptChannel := something.

    "Created: / 31.1.2000 / 01:34:13 / cg"
!

x_modifiedChannel
    "return the value of the instance variable 'modifiedChannel' (automatically generated)"

    "/ called x_* to avoid confusion with UIPainter specs modifiedChannel

    ^ modifiedChannel

    "Created: / 31.1.2000 / 01:32:59 / cg"
    "Modified: / 31.1.2000 / 01:33:48 / cg"
!

x_modifiedChannel:something
    "set the value of the instance variable 'modifiedChannel' (automatically generated)"

    "/ called x_* to avoid confusion with UIPainter specs modifiedChannel

    modifiedChannel := something.

    "Created: / 31.1.2000 / 01:33:07 / cg"
    "Modified: / 31.1.2000 / 01:33:52 / cg"
! !

!TextEditorSpec methodsFor:'building'!

createViewFor:aBuilder in:aView
    "low level create - no attributes are set."

    ^ self createScrollableViewFor:aBuilder in:aView
!

defineCallBacksFor:aBuilder view:aView
    |inpChgSel appl|

    "/ transform ST-80 Style callBackSpec
    "/ into ST/X actions ...

    (     aBuilder isEditing not
     and:[(callbacksSpec notNil or:[acceptCallBack notNil])
     and:[(appl := aBuilder application) notNil]]
    ) ifTrue:[
        callbacksSpec notNil ifTrue:[
            inpChgSel := callbacksSpec valueChangeSelector.
        ].

        aView acceptAction:[:text | 
                                "/ actually, ST80 apps expect the controller here ...
                                self sendMessage:inpChgSel withOptionalArg:aView to:appl.
                                self sendMessage:acceptCallBack withOptionalArg:text to:appl.
                           ].
    ].

    "Modified: / 20.6.1998 / 13:43:26 / cg"
!

nameShownWhileEditingFor:aView
    (model notNil) ifTrue:[ ^ model].
    ^ aView name

    "Created: / 30.10.2001 / 14:40:48 / cg"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    isReadOnly == true ifTrue:[
        aView readOnly:true.
    ].
    (self showingCode and:[self allowDoIt not]) ifTrue:[
        aView doItAction:nil.
    ].

    aBuilder isEditing ifTrue:[
        aView contents:(self nameShownWhileEditingFor:aView)
    ] ifFalse:[
        self setModelAttributeIn:aView with:aBuilder.
        (callbacksSpec notNil 
        or:[acceptCallBack notNil]) ifTrue:[
            self defineCallBacksFor:aBuilder view:aView
        ].

"/        self setMenuIn:aView with:aBuilder
        tabRequiresControl notNil ifTrue:[
            aView tabRequiresControl:tabRequiresControl
        ].
        aBuilder keyboardProcessor addAutoAcceptListener:aView.
    ]

    "Modified: / 30.10.2001 / 14:41:05 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        acceptChannel notNil ifTrue:[
            c := self channel:#acceptChannel inBuilder:aBuilder.
            c notNil ifTrue:[
                MessageNotUnderstood handle:[:ex |
                    ex selector == #acceptChannel: ifFalse:[ ex reject ].
                ] do:[
                    aView acceptChannel:c 
                ].
            ].
        ].
        modifiedChannel notNil ifTrue:[
            c := self channel:#modifiedChannel inBuilder:aBuilder.
            c notNil ifTrue:[
                MessageNotUnderstood handle:[:ex |
                    ex selector == #modifiedChannel: ifFalse:[ ex reject ].
                ] do:[
                    aView modifiedChannel:c 
                ]
            ].
        ]
    ]

    "Created: / 30-01-1998 / 14:30:58 / cg"
    "Modified: / 25-07-2011 / 16:25:58 / cg"
!

setKeyboardFocusAttributesIn:aView with:aBuilder
    aBuilder keyboardProcessor addAutoAcceptListener:aView controller.
    super setKeyboardFocusAttributesIn:aView with:aBuilder

    "Created: / 09-12-2010 / 10:46:19 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    aBuilder isEditing ifFalse:[
        aView model:(self modelInBuilder:aBuilder)
    ]
! !

!TextEditorSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    callbacksSpec notNil ifTrue:[
        callbacksSpec := callbacksSpec decodeAsLiteralArray
    ].

    "/in ST-80, the default is true

    hasHorizontalScrollBar isNil ifTrue:[
        hasHorizontalScrollBar := true.
        miniScrollerHorizontal := true.
    ].
    hasVerticalScrollBar isNil ifTrue:[
        hasVerticalScrollBar := true
    ].

    "Created: / 7.4.1997 / 19:19:44 / cg"
    "Modified: / 27.10.1997 / 19:27:05 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    isReadOnly ~~ true ifTrue:[ l add:#isReadOnly ].

    style isNil ifTrue:[ l add:#style ].

    callbacksSpec notNil ifTrue:[
        (callbacksSpec doubleClickSelector isNil
        and:[callbacksSpec valueChangeSelector isNil]) ifTrue:[
            callbacksSpec := nil
        ]
    ].
    allowDoIt isNil ifTrue:[ l add:#allowDoIt ].
    showingCode isNil ifTrue:[ l add:#showingCode ].
    callbacksSpec isNil ifTrue:[ l add:#callbacksSpec ].
    acceptChannel isNil ifTrue:[ l add:#acceptChannel ].
    modifiedChannel isNil ifTrue:[ l add:#modifiedChannel ].
    acceptCallBack isNil ifTrue:[ l add:#acceptCallBack ].
    ^ l

    "Modified: / 20.6.1998 / 13:41:35 / cg"
! !

!TextEditorSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    (self allowDoIt or:[self showingCode]) ifTrue:[
        ^ CodeView
    ].
    ^ EditTextView
! !

!TextEditorSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    acceptChannel notNil ifTrue:[more add:acceptChannel].
    modifiedChannel notNil ifTrue:[more add:modifiedChannel].
    ^ more

    "Created: / 30.1.1998 / 15:12:12 / cg"
    "Modified: / 10.2.2000 / 01:24:31 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator"

    someAspect notNil ifTrue:[
        (acceptChannel == someAspect) ifTrue:[
            ^ TriggerValue
        ].
        (modifiedChannel == someAspect) ifTrue:[
            ^ TriggerValue
        ].
    ].
    ^ super defaultModelClassFor:someAspect
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == model ifTrue:[
        ^ ''
    ].

    ^ super defaultModelValueFor:someAspect
! !

!TextEditorSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitTextEditorSpec:self
! !

!TextEditorSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/TextEditorSpec.st,v 1.112 2017-11-28 18:21:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/TextEditorSpec.st,v 1.112 2017-11-28 18:21:29 cg Exp $'
! !

