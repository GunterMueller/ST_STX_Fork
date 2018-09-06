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

ViewSpec subclass:#FramedBoxSpec
	instanceVariableNames:'label labelChannel labelPosition showFrame foregroundColor
		translateLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!FramedBoxSpec class methodsFor:'documentation'!

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
    not normally used by applications

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!FramedBoxSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'FramedBoxSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@X"@@H"H"H  @PB@"H@@@@@ @PJ@BHH"H"@ @PJ@"H"H"A@ @PJ@"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PJH"H"H"A@ @PHQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!FramedBoxSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FramedBoxSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'FramedBox Basics'
         name: 'FramedBox Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 244)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 127 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 7 0 5 1.0 29 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'labelLabel'
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: label
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'labelField'
                   layout: (LayoutFrame 100 0 32 0 5 1.0 54 0)
                   activeHelpKey: label
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (PopUpListSpec
                   label: 'Position'
                   name: 'popUpListAlignment'
                   layout: (LayoutFrame 100 0 58 0 5 1.0 82 0)
                   activeHelpKey: labelPositionList
                   translateLabel: true
                   tabable: true
                   model: labelPosition
                   menu: labelPositionList
                 )
                (LabelSpec
                   label: 'Position:'
                   name: 'positionLabel'
                   layout: (AlignmentOrigin 100 0 70 0 1 0.5)
                   activeHelpKey: labelPositionList
                   translateLabel: true
                   resizeForLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 128 0 0 1.0 231 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'CheckBox1'
                   layout: (Point 10 7)
                   activeHelpKey: translateLabel
                   tabable: true
                   model: translateLabel
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show Frame'
                   name: 'CheckBox2'
                   layout: (Point 10 35)
                   activeHelpKey: showFrame
                   tabable: true
                   model: showFrame
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FramedBoxSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'FramedBox Channels'
         name: 'FramedBox Channels'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 392 161)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 92 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 3 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                   majorKey: UISpecification
                   minorKey: subSpecForLabelChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 95 0 0 1.0 160 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
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
     UIPainter new openOnClass:FramedBoxSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Details'
         name: 'SequenceView Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 243)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 161 0)
             majorKey: UISpecification
             minorKey: fontColorBorderSubSpec
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 167 0 0 1.0 237 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 10 4)
                   activeHelpKey: initiallyInvisible
                   tabable: true
                   model: initiallyInvisible
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FramedBoxSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        label
                        labelPosition
                        showFrame
                        style
                        foregroundColor
                        translateLabel
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        labelChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    env
        at:#labelPositionList 
        put:(ValueHolder with:#(
                #topLeft
                #topCenter
                #topRight
                #bottomLeft 
                #bottomCenter
                #bottomRight
                #hidden
             )).

    "Modified: / 20.5.1998 / 02:19:36 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics     basicsEditSpec)
            (Details    detailsEditSpec)
            (Channels   channelsEditSpec)
       )


! !

!FramedBoxSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ true


! !

!FramedBoxSpec methodsFor:'accessing'!

label
    "return label"

    ^ label

    "Modified: 4.9.1995 / 17:23:30 / claus"
!

label:something
    "set label"

    label := something.

    "Modified: 4.9.1995 / 17:23:30 / claus"
!

labelPosition
    "return labelPosition"

    ^ labelPosition

    "Modified: 4.9.1995 / 17:23:30 / claus"
!

labelPosition:something
    "set labelPosition"

    labelPosition := something.

    "Modified: 4.9.1995 / 17:23:30 / claus"
!

showFrame
    "return showFrame"

    ^ showFrame ? true
!

showFrame:something
    "set showFrame"

    showFrame := something.
!

translateLabel
    "return the value of the instance variable 'translateLabel' (automatically generated)"

    ^ translateLabel ? true

    "Created: / 20.5.1998 / 02:12:58 / cg"
!

translateLabel:something
    "set the value of the instance variable 'translateLabel' (automatically generated)"

    translateLabel := something.

    "Created: / 20.5.1998 / 02:12:58 / cg"
! !

!FramedBoxSpec methodsFor:'accessing-channels'!

labelChannel
    "return the value of the instance variable 'labelChannel' (automatically generated)"

    ^ labelChannel



!

labelChannel:something
    "set the value of the instance variable 'labelChannel' (automatically generated)"

    labelChannel := something.


! !

!FramedBoxSpec methodsFor:'accessing-color & font'!

foregroundColor
    "return the value of the instance variable 'foregroundColor' (automatically generated)"

    ^ foregroundColor
!

foregroundColor:something
    "set the value of the instance variable 'foregroundColor' (automatically generated)"

    foregroundColor := something.
! !

!FramedBoxSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    labelChannel notNil ifTrue:[more add:labelChannel].
    ^ more
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |l c|

    super setAttributesIn:aView with:aBuilder.

    labelPosition notNil ifTrue:[aView labelPosition:labelPosition].
    showFrame notNil     ifTrue:[aView     showFrame:showFrame].

    foregroundColor notNil ifTrue:[
        aView foregroundColor:foregroundColor
    ] ifFalse:[
        aBuilder isEditing ifTrue:[
            aView foregroundColor:Color black
        ]
    ].
    (l := label) notNil ifTrue:[
        l := self getLabel:l translate:translateLabel with:aBuilder.
        aView label:l
    ].

    aBuilder isEditing ifTrue:[
        aView invalidate
    ] ifFalse:[
        labelChannel notNil ifTrue:[
            c := self channel:#labelChannel inBuilder:aBuilder
        ] ifFalse:[
            c := nil
        ].
        aView labelChannel:c
    ].
! !

!FramedBoxSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    showFrame ~~ false    ifTrue:[l add:#showFrame].
    foregroundColor isNil ifTrue:[l add:#foregroundColor].
    labelChannel    isNil ifTrue:[l add:#labelChannel].

    ^l
! !

!FramedBoxSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    style := aView font.
    label := aView label.
    labelPosition := aView labelPosition.
    showFrame := aView showFrame.
    foregroundColor := aView foregroundColor.

    super fromView:aView callBack:aBlock.
! !

!FramedBoxSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName

! !

!FramedBoxSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitFramedBoxSpec:self
! !

!FramedBoxSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/FramedBoxSpec.st,v 1.67 2017-11-28 18:21:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/FramedBoxSpec.st,v 1.67 2017-11-28 18:21:21 cg Exp $'
! !

