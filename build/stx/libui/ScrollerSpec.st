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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

NamedSpec subclass:#ScrollerSpec
	instanceVariableNames:'orientation start stop step backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ScrollerSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!ScrollerSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ScrollerSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G????8@_???? Q@@@@B@DVO<VH$Q8?18 AG#?G"@D*O<*HLP@@@@ A????>@G????8D_???? C*****O@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
!

icon_horizontal
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon_horizontal inspect
     ImageEditor openOnClass:self andSelector:#icon_horizontal
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ScrollerSpec class icon_horizontal'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G????8@_???? Q@@@@B@DVO<VH$Q8?18 AG#?G"@D*O<*HLP@@@@ A????>@G????8D_???? C*****O@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
!

icon_vertical
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon_vertical inspect
     ImageEditor openOnClass:self andSelector:#icon_vertical
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ScrollerSpec class icon_vertical'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01?0@O>@G?EX?8@_<_#? Q?2*O>@G?@@?8$_<?3? A?3?O>@G?@@?8L_<U#? A?1>O>@G?J(?8D_<@C? C*****O@@@@@@@b');
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

!ScrollerSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ScrollerSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Scroller Basics'
         name: 'Scroller Basics'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 399 202)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 202 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 24 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 103 0 13 0 5 1.0 35 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 49 0 1 0.5)
                   activeHelpKey: scrollerValueHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 103 0 38 0 5 1.0 60 0)
                   activeHelpKey: scrollerValueHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Min:'
                   name: 'minLabel'
                   layout: (AlignmentOrigin 100 0 74 0 1 0.5)
                   activeHelpKey: start
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'minField'
                   layout: (LayoutFrame 103 0 63 0 5 1 85 0)
                   activeHelpKey: start
                   tabable: true
                   model: start
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Max:'
                   name: 'maxLabel'
                   layout: (AlignmentOrigin 100 0 99 0 1 0.5)
                   activeHelpKey: stop
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'maxField'
                   layout: (LayoutFrame 103 0 88 0 5 1 110 0)
                   activeHelpKey: stop
                   tabable: true
                   model: stop
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'orientationLabel'
                   layout: (AlignmentOrigin 100 0 145 0 1 0.5)
                   activeHelpKey: orientation
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'orientation'
                   name: 'orientationPopUpList'
                   layout: (LayoutFrame 103 0 133 0 5 1.0 157 0)
                   activeHelpKey: orientation
                   translateLabel: true
                   tabable: true
                   model: orientation
                   menu: orientationList
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
     UIPainter new openOnClass:ScrollerSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Slider Details'
         name: 'Slider Details'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 400 210)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'colorBGSubSpec'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 67 0)
             activeHelpKey: backgroundColor
             majorKey: UISpecification
             minorKey: colorBGSubSpec
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 71 0 0 1.0 139 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 140 0 0 1.0 208 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (LayoutFrame 10 0 10 0 166 0 32 0)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )
         
! !

!ScrollerSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        orientation
                        backgroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        start
                        stop
                        step
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    env at:#orientationList put:#(horizontal #vertical).

    "Modified: / 26.10.1997 / 03:41:00 / cg"
! !

!ScrollerSpec methodsFor:'accessing'!

orientation
    "return the value of the instance variable 'orientation' (automatically generated)"

    ^ orientation ? #vertical

    "Created: 1.4.1997 / 12:05:12 / cg"
    "Modified: 1.4.1997 / 12:16:09 / cg"
!

orientation:something
    "set the value of the instance variable 'orientation' (automatically generated)"

    orientation := something.

    "Created: 1.4.1997 / 12:05:12 / cg"
!

start
    "return the value of the instance variable 'start' (automatically generated)"

    ^ start ? (self defaultStart)

    "Created: 1.4.1997 / 12:05:13 / cg"
    "Modified: 17.6.1997 / 10:34:52 / cg"
!

start:something
    "set the value of the instance variable 'start' (automatically generated)"

    start := something.

    "Created: 1.4.1997 / 12:05:13 / cg"
!

step
    "return the value of the instance variable 'step' (automatically generated)"

    ^ step ? (self defaultStep)

    "Created: 1.4.1997 / 12:05:13 / cg"
    "Modified: 17.6.1997 / 10:35:14 / cg"
!

step:something
    "set the value of the instance variable 'step' (automatically generated)"

    step := something.

    "Created: 1.4.1997 / 12:05:13 / cg"
!

stop
    "return the value of the instance variable 'stop' (automatically generated)"

    ^ stop ? (self defaultStop)

    "Created: / 1.4.1997 / 12:05:13 / cg"
    "Modified: / 5.6.1998 / 01:39:35 / cg"
!

stop:something
    "set the value of the instance variable 'stop' (automatically generated)"

    stop := something.

    "Created: 1.4.1997 / 12:05:13 / cg"
! !

!ScrollerSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:aColor
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := aColor
! !

!ScrollerSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    self setModelAttributeIn:aView with:aBuilder.

    aView orientation:self orientation.
    aView preferredExtent:nil.  "/ flush any cached preferrences

    "/ set both in one operation,
    "/ in case newStop == oldStart or vice versa.

    start notNil ifTrue:[
        stop notNil ifTrue:[
            aView start:start stop:stop
        ] ifFalse:[
            aView start:start
        ]
    ] ifFalse:[
        stop notNil ifTrue:[
            aView stop:stop
        ].
    ].
    step notNil ifTrue:[
        aView step:step
    ].

    "/ aView backgroundColor:backgroundColor ? (self viewClass styleSheet colorAt:'scroller.viewBackground' default: aView class defaultViewBackgroundColor).
    backgroundColor notNil ifTrue:[
        aView backgroundColor:backgroundColor.
    ].

    aBuilder isEditing ifTrue: [
        (aView class == Scroller or:[aView class == HorizontalScroller]) ifTrue:[
            aView thumbOrigin:50.
            aView thumbHeight:30.
        ].
        aView invalidate
    ]

    "Modified: / 2.10.1998 / 13:40:48 / cg"
! !

!ScrollerSpec methodsFor:'converting'!

defaultStart
    ^ 0

    "Created: / 18.4.1998 / 14:44:02 / cg"
!

defaultStep
    ^ nil

    "Created: / 18.4.1998 / 14:44:37 / cg"
    "Modified: / 18.4.1998 / 15:09:45 / cg"
!

defaultStop
    ^ 100

    "Created: / 18.4.1998 / 14:44:07 / cg"
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self start == self defaultStart ifTrue:[l add:#start].
    self stop  == self defaultStop  ifTrue:[l add:#stop].
    self step  == self defaultStep  ifTrue:[l add:#step].

    self orientation == #vertical ifTrue:[l add:#orientation].

    ^ l

    "Modified: / 20.6.1998 / 13:41:26 / cg"
! !

!ScrollerSpec methodsFor:'interface - painter'!

icon
    self orientation == #vertical ifTrue:[
        ^ self class icon_vertical
    ] ifFalse:[
        ^ self class icon_horizontal
    ].
! !

!ScrollerSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    orientation := aView orientation.
    start := aView thumb start.
    stop := aView thumb stop.
    step := aView thumb step.
    backgroundColor := aView backgroundColor.

    super fromView:aView callBack:aBlock
! !

!ScrollerSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ScrollerSpec.st,v 1.47 2017-11-28 18:21:46 cg Exp $'
! !

