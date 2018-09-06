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

WidgetSpec subclass:#CheckBoxSpec
	instanceVariableNames:'label translateLabel hasCharacterOrientedLabel
		valueChangeSelector labelChannel resizeForLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!CheckBoxSpec class methodsFor:'documentation'!

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

!CheckBoxSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'CheckBoxSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G????8@\@@??!!A1UV<>@GDT[L8@\P1,3 A1P60N@GE1[L8@\UU,3 A>**?>@G????8P_???? C*****@@@@@@@@b');
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

!CheckBoxSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CheckBoxSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'CheckBox Basics'
         name: 'CheckBox Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 196)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 123 0)
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
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 7 0 1 1 29 0)
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
                 )
                (InputFieldSpec
                   name: 'labelField'
                   layout: (LayoutFrame 100 0 32 0 1 1 54 0)
                   activeHelpKey: label
                   tabable: true
                   model: label
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 68 0 1 0.5)
                   activeHelpKey: booleanModel
                   translateLabel: true
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 57 0 -20 1 79 0)
                   activeHelpKey: booleanModel
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -20 1 57 0 0 1 79 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 122 0 0 1.0 193 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Label is Image'
                   name: 'imageLabelCheckBox'
                   layout: (Point 7 5)
                   activeHelpKey: labelIsImage
                   tabable: true
                   model: hasImageOrientedLabel
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabelCheckBox'
                   layout: (LayoutOrigin 0 0.5 5 0)
                   activeHelpKey: translateLabel
                   tabable: true
                   model: translateLabel
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
    ^ ToggleSpec channelsEditSpec
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CheckBoxSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'CheckBox Details'
         name: 'CheckBox Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 392)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'fontColorSubSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 127 0)
             majorKey: UISpecification
             minorKey: fontColorSubSpec
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 131 0 0 1.0 200 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 200 0 0 1.0 270 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabable'
                   layout: (Point 10 3)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Look Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 266 0 0 1.0 332 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Resize For Label'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 10 0 6 0 298 0 32 0)
                   activeHelpKey: tabable
                   tabable: true
                   model: resizeForLabel
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!CheckBoxSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        label
                        hasImageOrientedLabel
                        translateLabel
                        foregroundColor
                        backgroundColor
                        resizeForLabel
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        labelChannel
                        foregroundChannel
                        onCallBackSelector
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )
           
! !

!CheckBoxSpec methodsFor:'accessing'!

hasCharacterOrientedLabel
    ^ hasCharacterOrientedLabel ? true


!

hasCharacterOrientedLabel:aBoolean
    hasCharacterOrientedLabel := aBoolean


!

hasImageOrientedLabel
    ^ self hasCharacterOrientedLabel not


!

hasImageOrientedLabel:something
    self hasCharacterOrientedLabel:something not.


!

label
    "return label"

    ^ label
!

label:something
    "set label"

    label := something.
!

onCallBackSelector
    ^ self valueChangeSelector
!

onCallBackSelector:something
    self valueChangeSelector:something.
!

resizeForLabel
    ^ resizeForLabel
!

resizeForLabel:something
    resizeForLabel := something.
!

translateLabel
    "return the value of the instance variable 'translateLabel' (automatically generated)"

    ^ translateLabel ? true

    "Created: 28.2.1997 / 12:26:48 / cg"
!

translateLabel:something
    "set the value of the instance variable 'translateLabel' (automatically generated)"

    translateLabel := something.

    "Created: 28.2.1997 / 12:26:48 / cg"
!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector


!

valueChangeSelector:something
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := something.


! !

!CheckBoxSpec methodsFor:'accessing-channels'!

labelChannel

    ^ labelChannel
     
!

labelChannel: aValueHolder

    labelChannel := aValueHolder
     
! !

!CheckBoxSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder 
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    labelChannel isNil ifTrue:[
        aView label:(self getLabel:label translate:translateLabel with:aBuilder).
    ].

    resizeForLabel notNil ifTrue:[
        aView resizeForLabel:resizeForLabel
    ].
    aBuilder isEditing ifFalse:[
        valueChangeSelector notNil ifTrue:[
            aView action:(self callBackActionFor:valueChangeSelector with:aBuilder).
        ]
    ].

    "Modified: / 10.3.1998 / 17:19:28 / stefan"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        foregroundChannel notNil ifTrue:[
            c := self channel:#foregroundChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView foregroundChannel:c].
        ].
        labelChannel notNil ifTrue:[
            c := self channel:#labelChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView labelChannel:c].
        ]
    ].
! !

!CheckBoxSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    hasCharacterOrientedLabel ~~ false ifTrue:[l add:#hasCharacterOrientedLabel].
    "/ translateLabel            ~~ true  ifTrue:[l add:#translateLabel].
    valueChangeSelector isNil          ifTrue:[l add:#valueChangeSelector].
    labelChannel        isNil          ifTrue:[l add:#labelChannel].
    resizeForLabel      ~~ true        ifTrue:[l add:#resizeForLabel].

    ^l

    "Modified: / 20.6.1998 / 13:40:49 / cg"
! !

!CheckBoxSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    label                     := aView label.
    hasCharacterOrientedLabel := label isImageOrForm not.
    resizeForLabel            := aView resizeForLabel.
    super fromView:aView callBack:aBlock
! !

!CheckBoxSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    valueChangeSelector notNil ifTrue:[more add:valueChangeSelector].
    ^ more

    "Modified: / 10.2.2000 / 01:25:42 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    labelChannel      notNil ifTrue:[more add:labelChannel].
    foregroundChannel notNil ifTrue:[more add:foregroundChannel].

    ^ more

    "Modified: / 10.2.2000 / 01:25:20 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == model ifTrue:[
        ^ true
    ].

    ^ super defaultModelValueFor:someAspect

    "Created: / 29.7.1998 / 11:02:53 / cg"
    "Modified: / 10.2.2000 / 01:27:47 / cg"
! !

!CheckBoxSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitCheckBoxSpec:self
! !

!CheckBoxSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/CheckBoxSpec.st,v 1.91 2017-11-28 18:21:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/CheckBoxSpec.st,v 1.91 2017-11-28 18:21:48 cg Exp $'
! !

