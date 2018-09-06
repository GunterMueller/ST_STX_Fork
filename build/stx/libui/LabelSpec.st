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

ViewWithLabelSpec subclass:#LabelSpec
	instanceVariableNames:'menu performer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!LabelSpec class methodsFor:'documentation'!

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

!LabelSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'LabelSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G????8@P@@@@ QEUUUR@DQTTEH$QEDQD ADTAAR@DQQDQHLQADPT AEUUUR@D@@@@HD_???? C*****O@@@@@@@b');
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

!LabelSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LabelSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Label Basics'
         name: 'Label Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 413 319)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Basic Attributes'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'ID:'
                         name: 'nameLabel'
                         layout: (AlignmentOrigin 100 0 26 0 1 0.5)
                         activeHelpKey: id
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'nameField'
                         layout: (LayoutFrame 100 0 15 0 5 1.0 37 0)
                         activeHelpKey: id
                         tabable: true
                         model: name
                         group: inputGroup
                         acceptOnLeave: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: 'Label Text:'
                         name: 'labelLabel'
                         layout: (LayoutFrame 0 0 42 0 100 0 59 0)
                         activeHelpKey: label
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'labelField'
                         layout: (LayoutFrame 100 0 40 0 5 1 62 0)
                         activeHelpKey: label
                         tabable: true
                         model: label
                         group: inputGroup
                         acceptOnLeave: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: true
                       )
                      )
                    
                   )
                   extent: (Point 413 100)
                 )
                (UISubSpecification
                   name: 'menuSubSpec'
                   majorKey: UISpecification
                   minorKey: menuSubSpec
                   extent: (Point 413 115)
                 )
                (FramedBoxSpec
                   label: 'Label Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Label is Image'
                         name: 'hasImageOrientedLabel'
                         layout: (Point 10 7)
                         activeHelpKey: labelIsImage
                         tabable: true
                         model: hasImageOrientedLabel
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Translate Label'
                         name: 'translateLabel'
                         layout: (LayoutOrigin 0 0.5 7 0)
                         activeHelpKey: translateLabel
                         tabable: true
                         model: translateLabel
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 413 74)
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
     UIPainter new openOnClass:LabelSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'Label Channels'
         name: 'Label Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 420 299)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Channels'
                   name: 'FramedBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (UISubSpecification
                         name: 'VisibilityChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 13 0.0 4 1.0 38 0)
                         majorKey: UISpecification
                         minorKey: subSpecForVisibilityChannel
                       )
                      (UISubSpecification
                         name: 'SubSpecification1'
                         layout: (LayoutFrame 0 0.0 39 0.0 4 1.0 64 0)
                         majorKey: UISpecification
                         minorKey: subSpecForLabelChannel
                       )
                      (UISubSpecification
                         name: 'SubSpecification2'
                         layout: (LayoutFrame 0 0.0 65 0.0 4 1.0 90 0)
                         majorKey: UISpecification
                         minorKey: subSpecForFGColorChannel
                       )
                      (UISubSpecification
                         name: 'SubSpecification3'
                         layout: (LayoutFrame 0 0.0 91 0.0 4 1.0 116 0)
                         majorKey: UISpecification
                         minorKey: subSpecForBGColorChannel
                       )
                      (UISubSpecification
                         name: 'SubSpecification5'
                         layout: (LayoutFrame 0 0.0 117 0.0 4 1.0 142 0)
                         majorKey: UISpecification
                         minorKey: subSpecForEnableDisableColorChannel
                       )
                      )
                    
                   )
                   extent: (Point 420 177)
                 )
                (FramedBoxSpec
                   label: 'CallBacks'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (UISubSpecification
                         name: 'SubSpecification4'
                         layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                         majorKey: UISpecification
                         minorKey: subSpecForPostBuildCallBack
                       )
                      )
                    
                   )
                   extent: (Point 420 65)
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
     UIPainter new openOnClass:LabelSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Label Details'
         name: 'Label Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 431 391)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'detailsEditSpec'
                   majorKey: SequenceViewSpec
                   minorKey: detailsEditSpec
                   extent: (Point 431 163)
                 )
                (FramedBoxSpec
                   label: 'Label Attributes'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Alignment:'
                         name: 'justificationLabel'
                         layout: (AlignmentOrigin 177 0 21 0 1 0.5)
                         activeHelpKey: labelAlignment
                         translateLabel: true
                         resizeForLabel: false
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'Alignment'
                         name: 'alignmentPopUpList'
                         layout: (LayoutFrame 184 0 9 0 5 1 33 0)
                         activeHelpKey: labelAlignment
                         translateLabel: true
                         tabable: true
                         model: alignment
                         menu: alignmentList
                       )
                      (CheckBoxSpec
                         label: 'Resize For Label'
                         name: 'resizeForLabelCheckBox'
                         layout: (Point 10 42)
                         activeHelpKey: resizeForLabel
                         tabable: true
                         model: resizeForLabel
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Multiline Label'
                         name: 'CheckBox1'
                         layout: (Point 10 72)
                         activeHelpKey: multilLineLabel
                         tabable: true
                         model: multiLineLabel
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 431 139)
                 )
                (FramedBoxSpec
                   label: 'Init Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Initially Invisible'
                         name: 'initiallyInvisibleCheckBox'
                         layout: (Point 10 2)
                         activeHelpKey: initiallyInvisible
                         tabable: true
                         model: initiallyInvisible
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 431 68)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!LabelSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        menuSelector
                        performer
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:ButtonSpec
        with:ActionButtonSpec
        with:TextEditorSpec

    "Created: / 05-09-2012 / 19:26:31 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
      )
! !

!LabelSpec methodsFor:'accessing'!

menu
    "return the value of the instance variable 'menu' (automatically generated)"

    ^ menu


!

menu:something
    "set the value of the instance variable 'menu' (automatically generated)"

     menu := something

!

menuPerformer
    menu notNil ifTrue:[^ performer ].
    ^ nil

    "Modified: / 24-12-2010 / 02:06:12 / cg"
!

performer
    "return the value of the instance variable 'performer' (automatically generated)"

    ^ performer
!

performer:something
    "set the value of the instance variable 'performer' (automatically generated)"

    performer := something.
! !

!LabelSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        self setMenuIn:aView with:aBuilder.                             
    ]
! !

!LabelSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    menu      isNil ifTrue:[l add:#menu].
    performer isNil ifTrue:[l add:#performer].

    ^l


! !

!LabelSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    adjust      := aView adjust.
    hasCharacterOrientedLabel := aView label isImageOrForm not.

    super fromView:aView callBack:aBlock.


! !

!LabelSpec methodsFor:'queries'!

menuSelector
    ^ menu


!

menuSelector:something
    menu := something

!

usefulReplacementSpecClassNames
    ^ #( ButtonSpec )
! !

!LabelSpec methodsFor:'queries-UIPainter'!

nameOfMainAspect
    labelChannel notNil ifTrue:[
        ^ labelChannel
    ].
    (label notEmptyOrNil) ifTrue:[
        label isImage ifTrue:[
"/            "/ define a method for the label
"/            selector := Dialog request:'Name of image-resource method for the label (empty, to skip) ?'.
"/            selector notNil ifTrue:[
"/                hasCharacterOrientedLabel := false.
"/                ^ selector
"/            ].
            ^ 'someImage'
        ].
        ^ '''', (label contractTo:20), ''''
    ].
    ^ super nameOfMainAspect

    "Modified: / 07-07-2010 / 19:05:52 / cg"
! !

!LabelSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitLabelSpec:self
! !

!LabelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/LabelSpec.st,v 1.93 2016-08-25 21:12:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/LabelSpec.st,v 1.93 2016-08-25 21:12:46 cg Exp $'
! !

