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

NamedSpec subclass:#ProgressIndicatorSpec
	instanceVariableNames:'foregroundColor backgroundColor showPercentage direction reverse
		area position isActivityIndicator'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ProgressIndicatorSpec class methodsFor:'documentation'!

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

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!ProgressIndicatorSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ProgressIndicatorSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G????8@_???? Q@@@@B@DUUUUH$Q??=T AF??5R@DUUUUHLP@@@@ A????>@G????8D_???? C*****O@@@@@@@b');
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

!ProgressIndicatorSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProgressIndicatorSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'ProgressIndicator Basics'
          name: 'ProgressIndicator Basics'
          min: (Point 10 10)
          max: (Point 1152 900)
          bounds: (Rectangle 16 46 416 147)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: UISpecification
              minorKey: subSpecForIDAndModel
            )
"/           (FramedBoxSpec
"/              label: 'Basic Attributes'
"/              name: 'FramedBox'
"/              layout: (LayoutFrame 0 0.0 6 0 0 1.0 98 0)
"/              labelPosition: topLeft
"/              translateLabel: true
"/              component: 
"/             (SpecCollection
"/                collection: (
"/                 (LabelSpec
"/                    label: 'ID:'
"/                    name: 'nameLabel'
"/                    layout: (AlignmentOrigin 88 0 23 0 1 0.5)
"/                    activeHelpKey: id
"/                    translateLabel: true
"/                    resizeForLabel: true
"/                    adjust: right
"/                  )
"/                 (InputFieldSpec
"/                    name: 'nameField'
"/                    layout: (LayoutFrame 90 0 12 0 5 1.0 34 0)
"/                    activeHelpKey: id
"/                    tabable: true
"/                    model: name
"/                    group: inputGroup
"/                    acceptChannel: acceptChannel
"/                    modifiedChannel: modifiedChannel
"/                    acceptOnPointerLeave: false
"/                  )
"/                 (LabelSpec
"/                    label: 'Model:'
"/                    name: 'modelLabel'
"/                    layout: (AlignmentOrigin 88 0 48 0 1 0.5)
"/                    activeHelpKey: progressValueHolder
"/                    translateLabel: true
"/                    resizeForLabel: true
"/                    adjust: right
"/                  )
"/                 (InputFieldSpec
"/                    name: 'modelField'
"/                    layout: (LayoutFrame 90 0 37 0 5 1.0 59 0)
"/                    activeHelpKey: progressValueHolder
"/                    tabable: true
"/                    model: model
"/                    group: inputGroup
"/                    acceptChannel: acceptChannel
"/                    modifiedChannel: modifiedChannel
"/                    acceptOnPointerLeave: false
"/                  )
"/                 )
"/               
"/              )
"/            )
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
     UIPainter new openOnClass:ProgressIndicatorSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       uuid: 'fbf1606e-801a-11e8-8e2b-b8f6b1108e05'
       window: 
      (WindowSpec
         label: 'ProgressIndicator Details'
         name: 'ProgressIndicator Details'
         uuid: 'fbf16316-801a-11e8-8e2b-b8f6b1108e05'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 400 264)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsEditSpec'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 165 0)
             uuid: 'fbf16550-801a-11e8-8e2b-b8f6b1108e05'
             majorKey: SequenceViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 164 0 0 1.0 257 0)
             uuid: 'fbf16726-801a-11e8-8e2b-b8f6b1108e05'
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Show Percentage'
                   name: 'showPercentageCheckBox'
                   layout: (Point 3 5)
                   activeHelpKey: showPercentage
                   uuid: 'fbf1688e-801a-11e8-8e2b-b8f6b1108e05'
                   tabable: true
                   model: showPercentage
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 3 30)
                   activeHelpKey: initiallyInvisible
                   uuid: 'fbf16d70-801a-11e8-8e2b-b8f6b1108e05'
                   tabable: true
                   model: initiallyInvisible
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Activity Indicator'
                   name: 'isActivityIndicatorCheckBox'
                   layout: (Point 201 5)
                   activeHelpKey: showPercentage
                   uuid: 'fbf17144-801a-11e8-8e2b-b8f6b1108e05'
                   tabable: true
                   model: isActivityIndicator
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ProgressIndicatorSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        style
                        showPercentage
                        isActivityIndicator
                        foregroundColor
                        backgroundColor
                     )
        to:env 
        for:anInstance 
        channel:aChannel.
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics  basicsEditSpec)
            (Details detailsEditSpec)
            (Channels visibilityAndBackgroundChannelEditSpec) 
       )
! !

!ProgressIndicatorSpec methodsFor:'accessing'!

area
    "return the value of the instance variable 'area' (automatically generated)"

    ^ area

    "Created: / 4.2.2000 / 09:52:27 / cg"
!

area:something
    "set the value of the instance variable 'area' (automatically generated)"

    area := something.

    "Created: / 4.2.2000 / 09:52:27 / cg"
!

direction
    "return the value of the instance variable 'direction' (automatically generated)"

    ^ direction

    "Created: / 4.2.2000 / 09:50:40 / cg"
!

direction:something
    "set the value of the instance variable 'direction' (automatically generated)"

    direction := something.

    "Created: / 4.2.2000 / 09:50:51 / cg"
!

isActivityIndicator
    "return the value of the instance variable 'isActivityIndicator' (automatically generated)"

    ^ isActivityIndicator
!

isActivityIndicator:something
    "set the value of the instance variable 'isActivityIndicator' (automatically generated)"

    isActivityIndicator := something.
!

position
    "return the value of the instance variable 'position' (automatically generated)"

    ^ position

    "Created: / 4.2.2000 / 09:52:31 / cg"
!

position:something
    "set the value of the instance variable 'position' (automatically generated)"

    position := something.

    "Created: / 4.2.2000 / 09:52:31 / cg"
!

reverse
    "return the value of the instance variable 'reverse' (automatically generated)"

    ^ reverse

    "Created: / 4.2.2000 / 09:52:23 / cg"
!

reverse:something
    "set the value of the instance variable 'reverse' (automatically generated)"

    reverse := something.

    "Created: / 4.2.2000 / 09:52:23 / cg"
!

showPercentage
    "return the value of the instance variable 'showPercentage' (automatically generated)"

    ^ showPercentage ? true

    "Created: 29.3.1997 / 16:11:24 / cg"
!

showPercentage:something
    "set the value of the instance variable 'showPercentage' (automatically generated)"

    showPercentage := something

! !

!ProgressIndicatorSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor  
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something
!

foregroundColor
    "return the value of the instance variable 'foregroundColor' (automatically generated)"

    ^ foregroundColor

!

foregroundColor:something
    "set the value of the instance variable 'foregroundColor' (automatically generated)"

    foregroundColor := something

! !

!ProgressIndicatorSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    self setModelAttributeIn:aView with:aBuilder.

    aBuilder isEditing ifTrue:[aView percentage:25].

    showPercentage  notNil ifTrue:[aView showPercentage:showPercentage].
    foregroundColor notNil 
        ifTrue: [aView foregroundColor:foregroundColor]
        ifFalse:[aBuilder isEditing ifTrue: [aView foregroundColor: (self viewClass styleSheet colorAt:'progressIndicator.foregroundColor' default:Color blue)]].
    backgroundColor notNil 
        ifTrue: [aView backgroundColor:backgroundColor]
        ifFalse:[aBuilder isEditing ifTrue: [aView backgroundColor: (self viewClass styleSheet colorAt:'progressIndicator.viewBackground' default:Color white)]].

    isActivityIndicator == true ifTrue:[
        aView showBusyIndication:isActivityIndicator
    ].
    aBuilder isEditing ifTrue: [aView invalidate]
! !

!ProgressIndicatorSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self showPercentage ifTrue:[l add:#showPercentage].
    isActivityIndicator ~~ true ifTrue:[l add:#isActivityIndicator].

    ^l

    "Modified: / 20.6.1998 / 13:41:21 / cg"
! !

!ProgressIndicatorSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    style           := aView font.
    showPercentage  := aView showPercentage.
    foregroundColor := aView foregroundColor.
    backgroundColor := aView backgroundColor.

    super fromView:aView callBack:aBlock
! !

!ProgressIndicatorSpec methodsFor:'queries'!

isRound
    ^ false
! !

!ProgressIndicatorSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitProgressIndicatorSpec:self
! !

!ProgressIndicatorSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ProgressIndicatorSpec.st,v 1.48 2018-07-05 06:16:59 cg Exp $'
! !

