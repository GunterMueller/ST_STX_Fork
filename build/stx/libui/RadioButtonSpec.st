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

ToggleSpec subclass:#RadioButtonSpec
	instanceVariableNames:'select callbacksSpec isToggle'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!RadioButtonSpec class methodsFor:'documentation'!

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
    documentation to be added.

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

!RadioButtonSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'RadioButtonSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU3A????>@G????8@_?@O?!!A?1UO>@G<\M/8@_1@F? A?D@[>@G<\M/8@_<U[? A?>*?>@G????8P_???? C*****@@@@@@@@b');
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

!RadioButtonSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RadioButtonSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Button Basic'
         name: 'Button Basic'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 413 331)
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
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 21 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 10 0 0 1.0 32 0)
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
                   layout: (AlignmentOrigin 100 0 46 0 1 0.5)
                   activeHelpKey: label
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'labelInputField'
                   layout: (LayoutFrame 100 0 35 0 0 1 57 0)
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
                   layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                   activeHelpKey: radioButtonGroup
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 60 0 -20 1 82 0)
                   activeHelpKey: radioButtonGroup
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
                   layout: (LayoutFrame -20 1 60 0 0 1 82 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'Value:'
                   name: 'valueLabel'
                   layout: (AlignmentOrigin 100 0 96 0 1 0.5)
                   activeHelpKey: radioButtonValue
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'actionValueField'
                   layout: (LayoutFrame 100 0 85 0 0 1.0 107 0)
                   activeHelpKey: radioButtonValue
                   tabable: true
                   model: select
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'basicsEditSubSpec'
             layout: (LayoutFrame 0 0.0 151 0 0 1.0 247 0)
             majorKey: ActionButtonSpec
             minorKey: basicsEditSubSpec
           )
          (FramedBoxSpec
             label: 'Button Behavior'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 244 0 0 1.0 306 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Be Toggle'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 10 0 4 0 146 0 26 0)
                   model: isToggle
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

colorSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RadioButtonSpec andSelector:#colorSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: colorSubSpec
       window: 
      (WindowSpec
         label: 'Toggle Colors'
         name: 'Toggle Colors'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 200)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 197 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 100 0 4 0 5 1.0 26 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 46 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenu1'
                   layout: (LayoutFrame 100 0 34 0 5 1.0 56 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 76 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 64 0 5 1.0 86 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (CheckBoxSpec
                   label: 'Show Lamp'
                   name: 'showLamp'
                   layout: (Point 10 98)
                   activeHelpKey: showLamp
                   initiallyInvisible: true
                   model: showLamp
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Lamp Clr:'
                   name: 'lampColorLabel'
                   layout: (AlignmentOrigin 100 0 141 0 1 0.5)
                   activeHelpKey: lampColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuLamp'
                   layout: (LayoutFrame 100 0 129 0 4 1 151 0)
                   activeHelpKey: lampColor
                   model: lampColor
                   allowSymbolicColors: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!RadioButtonSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        isToggle
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        select
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#smalltalkObjectOrNil 

    "Modified: / 30.1.2000 / 23:14:15 / cg"
! !

!RadioButtonSpec methodsFor:'accessing'!

callbacksSpec
    "return the value of the instance variable 'callbacksSpec' (automatically generated)"

    ^ callbacksSpec

    "Created: / 20.6.1998 / 13:53:51 / cg"
!

callbacksSpec:something
    "set the value of the instance variable 'callbacksSpec' (automatically generated)"

    callbacksSpec := something.

    "Created: / 20.6.1998 / 13:53:51 / cg"
!

isToggle
    "return the value of the instance variable 'isToggle' (automatically generated)"

    ^ isToggle

    "Created: / 20.6.1998 / 13:53:51 / cg"
!

isToggle:something
    "set the value of the instance variable 'isToggle' (automatically generated)"

    isToggle := something.

    "Created: / 20.6.1998 / 13:53:51 / cg"
!

select
    "return the value of the instance variable 'select' (automatically generated)"

    ^ select
!

select:something
    "set the value of the instance variable 'select' (automatically generated)"

    select := something.
! !

!RadioButtonSpec methodsFor:'building'!

createViewFor:aBuilder in:aView
    |v|

    v := super createViewFor:aBuilder in:aView.
    v forceRadioButtonStyle.
    isToggle == true ifTrue:[v controller beToggle].
    isToggle == false ifTrue:[v controller beRadioButton].
    ^ v

    "Created: / 18.6.1998 / 21:14:50 / cg"
    "Modified: / 18.6.1998 / 21:24:10 / cg"
!

defineCallBacksFor:aBuilder view:aView
    |inpChgSel appl|

    "/ transform ST-80 Style callBackSpec
    "/ into ST/X actions ...

    (     aBuilder isEditing not
     and:[callbacksSpec notNil
     and:[(appl := aBuilder application) notNil]]
    ) ifTrue:[
        inpChgSel := callbacksSpec valueChangeSelector.

        inpChgSel notNil ifTrue:[
            aView action:[:t| 
                              "/ actually, ST80 apps expect the controller here ...  
                              self sendMessage:inpChgSel withOptionalArg:aView to:appl.
                         ].
        ]
    ].

    "Created: / 20.6.1998 / 13:45:35 / cg"
    "Modified: / 20.6.1998 / 13:54:34 / cg"
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |group|

    (model isNil or:[aBuilder isEditing]) ifFalse:[
        group := aBuilder aspectFor:model.

        group isNil ifTrue:[
            group := RadioButtonGroup new.
            aBuilder aspectAt:model put:group
        ].

        "/ check if it's really a radioButtonGroup;
        "/ VW applications could return a ValueHolder or whatever
        "/ if not (ie. a ValueHolder), adapt the view to it

        (group isKindOf:RadioButtonGroup) ifFalse:[
            aView model:(RadioButtonGroup adaptorFor:group value:select)
        ] ifTrue:[
            group add:aView value:select
        ].
        callbacksSpec notNil ifTrue:[self defineCallBacksFor:aBuilder view:aView].
    ].

    "Modified: / 20-06-1998 / 13:54:21 / cg"
    "Modified (comment): / 13-02-2017 / 20:29:45 / cg"
! !

!RadioButtonSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    callbacksSpec notNil ifTrue:[callbacksSpec := callbacksSpec decodeAsLiteralArray].

    "Created: / 20.6.1998 / 13:49:34 / cg"
! !

!RadioButtonSpec methodsFor:'queries-UIDefiner'!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator"

    ^ RadioButtonGroup

    "Modified: / 26.10.1997 / 18:58:50 / cg"
!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    someAspect == model ifTrue:[^ false].
    ^ super defaultModelIsCallBackMethodSelector:someAspect

    "Created: / 21.4.1998 / 20:25:02 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    someAspect == model ifTrue:[
        ^ nil
    ].

    ^ super defaultModelValueFor:someAspect

    "Modified: / 10.2.2000 / 01:29:15 / cg"
! !

!RadioButtonSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitRadioButtonSpec:self
! !

!RadioButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/RadioButtonSpec.st,v 1.67 2017-02-13 19:46:41 cg Exp $'
! !

