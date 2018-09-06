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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ActionButtonSpec subclass:#ArrowButtonSpec
	instanceVariableNames:'direction'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ArrowButtonSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    [author:]
        Claus Gittinger
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!ArrowButtonSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ArrowButtonSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01??C?>@G?8K?8@_>@K? Q?/?;>@G8??K8$\C?<C A0O?0N@G8??K8L_;?>? A?8@/>@G?8K?8D_?0?? C*****O@@@@@@@b');
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

!ArrowButtonSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ArrowButtonSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ArrowButton Basics'
         name: 'ArrowButton Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 152)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 152 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'idLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'idField'
                   layout: (LayoutFrame 100 0 6 0 5 1 28 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Action:'
                   name: 'actionLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: action
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 31 0 5 1 53 0)
                   activeHelpKey: action
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Argument:'
                   name: 'argumentLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: action
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'actionValueField'
                   layout: (LayoutFrame 100 0 56 0 5 1.0 78 0)
                   activeHelpKey: actionArg
                   tabable: true
                   model: actionValue
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'orientationLabel'
                   layout: (AlignmentOrigin 100 0 94 0 1 0.5)
                   activeHelpKey: arrowButtonDirection
                   translateLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'popup'
                   name: 'directionPopup'
                   layout: (LayoutFrame 100 0 82 0 5 1 107 0)
                   activeHelpKey: arrowButtonDirection
                   translateLabel: true
                   tabable: true
                   model: direction
                   menu: directionList
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
     UIPainter new openOnClass:ArrowButtonSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: detailsEditSpec
        window: 
       (WindowSpec
          label: 'ArrowButton Details'
          name: 'ArrowButton Details'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 396 316)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'fontColorSubSpec'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 101 0)
              majorKey: UISpecification
              minorKey: colorSubSpec
            )
           (UISubSpecification
              name: 'detailsInitSubSpec'
              layout: (LayoutFrame 0 0.0 105 0 0 1.0 170 0)
              majorKey: UISpecification
              minorKey: detailsInitSubSpec
            )
           (FramedBoxSpec
              label: 'Keyboard Attributes'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 174 0 0 1.0 269 0)
              labelPosition: topLeft
              component: 
             (SpecCollection
                collection: (
                 (CheckBoxSpec
                    label: 'Can Tab'
                    name: 'tabable'
                    layout: (Point 10 10)
                    activeHelpKey: tabable
                    tabable: true
                    model: tabable
                  )
                 (CheckBoxSpec
                    label: 'Auto Repeat'
                    name: 'autoRepeat'
                    layout: (Point 175 10)
                    activeHelpKey: autoRepeat
                    tabable: true
                    model: autoRepeat
                  )
                 (CheckBoxSpec
                    label: 'Trigger on Down'
                    name: 'isTriggerOnDown'
                    layout: (Point 10 35)
                    activeHelpKey: isTriggerOnDown
                    tabable: true
                    model: isTriggerOnDown
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!ArrowButtonSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        direction
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    env at:#directionList put:#(#up #down #left #right ) asValue.

!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )

! !

!ArrowButtonSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false


! !

!ArrowButtonSpec methodsFor:'accessing'!

direction
    "return the value of the instance variable 'direction' (automatically generated)"

    ^ direction ? #up
!

direction:something
    "set the value of the instance variable 'direction' (automatically generated)"

    something isNil ifTrue:[
        direction := #up
    ] ifFalse:[
        direction := something asSymbol.
    ]
!

isTriggerOnDown
    "return the value of the instance variable 'isTriggerOnDown' (automatically generated)"

    ^ isTriggerOnDown ? true


! !

!ArrowButtonSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aView label:nil.
    (foregroundColor isNil and:[foregroundChannel isNil]) ifTrue:[
        aView viewBackground:(View defaultViewBackgroundColor).
    ].

    direction isNil ifTrue:[
        aView direction:#up
    ] ifFalse:[
        aView direction:direction.
    ].

    "/ kludge for now - the arrowButtons default BG ought to
    "/ be changed to some 'normal' color,
    "/ and the scrollBar should change it to its thumbs bg-color
    "/ For now, change it here (q&d hack). Will be changed.

    aView styleSheet name == #motif ifTrue:[
        |defaultViewBackground|
        (defaultViewBackground := aView class defaultViewBackgroundColor) isColor
            ifTrue: [aView backgroundColor:defaultViewBackground]
    ]. 
! !

!ArrowButtonSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    direction := aView direction.

    super fromView:aView callBack:aBlock


! !

!ArrowButtonSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName

! !

!ArrowButtonSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitArrowButtonSpec:self
! !

!ArrowButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ArrowButtonSpec.st,v 1.51 2016-12-23 10:31:56 cg Exp $'
! !

