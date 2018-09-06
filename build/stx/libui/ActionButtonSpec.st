"{ Encoding: utf8 }"

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

ViewWithLabelAndModelSpec subclass:#ActionButtonSpec
	instanceVariableNames:'isDefault defaultable isDecorated isTriggerOnDown autoRepeat
		actionValue foregroundColorEnter backgroundColorEnter
		actionValue2'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ActionButtonSpec class methodsFor:'documentation'!

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
        Claus Gittinger
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!ActionButtonSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'ActionButtonSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUU01????>@G????8@_0?OO Q<<<<>@G333O8$_OOC? A<<<3>@G33338L_OOOO A?C<<>@G????8D_???? C*****O@@@@@@@b');
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

!ActionButtonSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ActionButtonSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ActionButton Basics'
         name: 'ActionButton Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 308)
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
                   name: 'FramedBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'ID:'
                         name: 'nameLabel'
                         layout: (AlignmentOrigin 120 0 15 0 1 0.5)
                         activeHelpKey: id
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'nameField'
                         layout: (LayoutFrame 120 0 4 0 5 1.0 26 0)
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
                         layout: (AlignmentOrigin 120 0 40 0 1 0.5)
                         activeHelpKey: label
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'labelInputField'
                         layout: (LayoutFrame 120 0 29 0 5 1 51 0)
                         activeHelpKey: label
                         tabable: true
                         model: label
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (LabelSpec
                         label: 'Disabled Lbl:'
                         name: 'disabledLabelLabel'
                         layout: (AlignmentOrigin 120 0 65 0 1 0.5)
                         activeHelpKey: disabledLabel
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'disabledLabelInputField'
                         layout: (LayoutFrame 120 0 54 0 5 1 76 0)
                         activeHelpKey: disabledLabel
                         tabable: true
                         model: disabledLogo
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (LabelSpec
                         label: 'Action:'
                         name: 'selectorLabel'
                         layout: (AlignmentOrigin 120 0 98 0 1 0.5)
                         activeHelpKey: action
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'actionInputField'
                         layout: (LayoutFrame 120 0 87 0 -15 1 109 0)
                         activeHelpKey: action
                         tabable: true
                         model: model
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (ActionButtonSpec
                         label: 'browseActionImage'
                         name: 'BrowseActionButton'
                         layout: (LayoutFrame -15 1 87 0 5 1 109 0)
                         activeHelpKey: browseAction
                         hasCharacterOrientedLabel: false
                         translateLabel: true
                         model: doBrowseActionMethod:nameAs:
                         actionValue: model
                         actionValue2: 'action'
                       )
                      (LabelSpec
                         label: 'Argument1:'
                         name: 'argLabel1'
                         layout: (AlignmentOrigin 120 0 123 0 1 0.5)
                         activeHelpKey: actionArg
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'argField1'
                         layout: (LayoutFrame 120 0 112 0 5 1.0 134 0)
                         activeHelpKey: actionArg
                         tabable: true
                         model: actionValue
                         group: inputGroup
                         type: smalltalkObject
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (LabelSpec
                         label: 'Argument2:'
                         name: 'argLabel2'
                         layout: (AlignmentOrigin 120 0 148 0 1 0.5)
                         activeHelpKey: actionArg
                         translateLabel: true
                         resizeForLabel: true
                       )
                      (InputFieldSpec
                         name: 'argField2'
                         layout: (LayoutFrame 120 0 137 0 5 1.0 159 0)
                         activeHelpKey: actionArg
                         tabable: true
                         model: actionValue2
                         group: inputGroup
                         type: smalltalkObject
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      )
                    
                   )
                   extent: (Point 400 197)
                 )
                (UISubSpecification
                   name: 'basicsEditSubSpec'
                   majorKey: ActionButtonSpec
                   minorKey: basicsEditSubSpec
                   extent: (Point 400 112)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

basicsEditSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ActionButtonSpec andSelector:#basicsEditSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSubSpec
       window: 
      (WindowSpec
         label: 'Button Basics'
         name: 'Button Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 404 112)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Label Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 99 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Show as Default'
                   name: 'isDefaultCheckBox'
                   layout: (Point 10 3)
                   activeHelpKey: beDefault
                   tabable: true
                   model: isDefault
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Label is Image'
                   name: 'imageLabelCheckBox'
                   layout: (LayoutOrigin 0 0.5 3 0)
                   activeHelpKey: labelIsImage
                   tabable: true
                   model: hasImageOrientedLabel
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Size as Default'
                   name: 'defaultableCheckBox'
                   layout: (Point 10 33)
                   activeHelpKey: sizeAsDefault
                   tabable: true
                   model: defaultable
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Translate Label'
                   name: 'translateLabelCheckBox'
                   layout: (LayoutOrigin 0 0.5 33 0)
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
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ActionButtonSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'ActionButton Channels'
         name: 'ActionButton Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 413 228)
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
                         layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                         majorKey: UISpecification
                         minorKey: subSpecForVisibilityChannel
                       )
                      (UISubSpecification
                         name: 'EnableChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                         majorKey: UISpecification
                         minorKey: subSpecForEnableChannel
                       )
                      (UISubSpecification
                         name: 'LabelChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 50 0.0 4 1.0 75 0)
                         majorKey: UISpecification
                         minorKey: subSpecForLabelChannel
                       )
                      (UISubSpecification
                         name: 'FGColorChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 76 0.0 4 1.0 101 0)
                         majorKey: UISpecification
                         minorKey: subSpecForFGColorChannel
                       )
                      (UISubSpecification
                         name: 'BGColorChannelSubSpecification'
                         layout: (LayoutFrame 0 0.0 101 0.0 4 1.0 126 0)
                         majorKey: UISpecification
                         minorKey: subSpecForBGColorChannel
                       )
                      )
                    
                   )
                   extent: (Point 413 160)
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
                         name: 'SubSpecification5'
                         layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                         majorKey: UISpecification
                         minorKey: subSpecForPostBuildCallBack
                       )
                      )
                    
                   )
                   extent: (Point 413 65)
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
     UIPainter new openOnClass:ActionButtonSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'ActionButton Details'
         name: 'ActionButton Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 391 506)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             backgroundColor: (Color 80.0 80.0 100.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'fontColorSubSpec'
                   majorKey: ActionButtonSpec
                   minorKey: fontColorSubSpec
                   useDefaultExtent: true
                 )
                (UISubSpecification
                   name: 'detailsInitSubSpec'
                   majorKey: UISpecification
                   minorKey: detailsInitSubSpec
                   useDefaultExtent: true
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabable'
                         layout: (Point 10 1)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Auto Repeat'
                         name: 'autoRepeat'
                         layout: (Point 175 1)
                         activeHelpKey: autoRepeat
                         tabable: true
                         model: autoRepeat
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Trigger on Down'
                         name: 'isTriggerOnDown'
                         layout: (Point 10 26)
                         activeHelpKey: isTriggerOnDown
                         tabable: true
                         model: isTriggerOnDown
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 391 92)
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
                         label: 'Align:'
                         name: 'justificationLabel'
                         layout: (AlignmentOrigin 177 0 27 0 1 0.5)
                         activeHelpKey: labelAlignment
                         translateLabel: true
                         resizeForLabel: false
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'Alignment'
                         name: 'alignmentPopUpList'
                         layout: (LayoutFrame 184 0 15 0 5 1 39 0)
                         activeHelpKey: labelAlignment
                         translateLabel: true
                         tabable: true
                         model: alignment
                         menu: alignmentList
                       )
                      (CheckBoxSpec
                         label: 'Resize For Label'
                         name: 'resizeForLabelCheckBox'
                         layout: (Point 10 48)
                         activeHelpKey: resizeForLabel
                         tabable: true
                         model: resizeForLabel
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Multiline Label'
                         name: 'multiLineLabelCheckBox'
                         layout: (Point 10 78)
                         activeHelpKey: multiLineLabel
                         tabable: true
                         model: multiLineLabel
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 391 145)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

fontColorSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ActionButtonSpec andSelector:#fontColorSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: fontColorSubSpec
       window: 
      (WindowSpec
         label: 'Font and BG- and FG-Color SubSpec'
         name: 'Font and BG- and FG-Color SubSpec'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 209)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 212 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 100 0 21 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 100 0 9 0 5 1.0 31 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 100 0 51 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 100 0 39 0 5 1.0 61 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 81 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 69 0 5 1.0 91 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'FG Entered:'
                   name: 'foregroundEnterLabel'
                   layout: (AlignmentOrigin 100 0 109 0 1 0.5)
                   activeHelpKey: foregroundColorEntered
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFGEnter'
                   layout: (LayoutFrame 100 0 97 0 5 1.0 119 0)
                   activeHelpKey: foregroundColorEntered
                   model: foregroundColorEnter
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG Entered:'
                   name: 'backgroundEnterLabel'
                   layout: (AlignmentOrigin 100 0 137 0 1 0.5)
                   activeHelpKey: backgroundColorEntered
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBGEnter'
                   layout: (LayoutFrame 100 0 125 0 5 1.0 147 0)
                   activeHelpKey: backgroundColorEntered
                   model: backgroundColorEnter
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'borderLabel'
                   layout: (AlignmentOrigin 100 0 166 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'borderWidthField'
                   layout: (LayoutFrame 100 0 153 0 140 0 175 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: borderWidth
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 208 0 166 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 210 0 153 0 360 0 175 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ActionButtonSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        tabable
                        isDefault
                        defaultable
                        initiallyDisabled
                        autoRepeat
                        isDecorated
                        isTriggerOnDown
                        actionValue
                        actionValue2
                        backgroundColorEnter
                        foregroundColorEnter
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:#(
                        model
                        enableChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 26.10.1997 / 03:21:28 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:LabelSpec
        with:ButtonSpec

    "Created: / 05-09-2012 / 19:26:31 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
       )
!

viewClass
    "only needed for completeness;
     UIPainter needs it to generate a replace-by list"

    self == ActionButtonSpec ifTrue:[
        ^ Button
    ].
    ^ super viewClass
! !

!ActionButtonSpec methodsFor:'accessing'!

actionArgument1:something
    <resource: #obsolete>
    self obsoleteMethodWarning.
    actionValue := something.
!

actionArgument2:something
    <resource: #obsolete>
    self obsoleteMethodWarning.
    actionValue2 := something.
!

actionValue
    "return the value of the instance variable 'actionValue' (automatically generated)"

    ^ actionValue
!

actionValue2

    ^ actionValue2
!

actionValue2:something

    actionValue2 := something.
!

actionValue:something
    "set the value of the instance variable 'actionValue' (automatically generated)"

    actionValue := something.
!

autoRepeat
    "return the value of the instance variable 'autoRepeat' (automatically generated)"

    ^ autoRepeat ? false
!

autoRepeat:something
    "set the value of the instance variable 'autoRepeat' (automatically generated)"

    autoRepeat := something.
!

defaultable
    "return defaultable"

    ^ defaultable ? false
!

defaultable:something
    "set defaultable"

    defaultable := something.
!

isDecorated
    "return the value of the instance variable 'isDecorated' (automatically generated)"

    ^ isDecorated ? false
!

isDecorated:something
    "set the value of the instance variable 'isDecorated' (automatically generated)"

    isDecorated := something.
!

isDefault
    "return isDefault"

    ^ isDefault ? false
!

isDefault:something
    "set isDefault"

    isDefault := something.
!

isTriggerOnDown
    "return the value of the instance variable 'isTriggerOnDown' (automatically generated)"

    ^ isTriggerOnDown ? false
!

isTriggerOnDown:something
    "set the value of the instance variable 'isTriggerOnDown' (automatically generated)"

    isTriggerOnDown := something.
! !

!ActionButtonSpec methodsFor:'accessing-color & font'!

backgroundColorEnter

    ^ backgroundColorEnter
!

backgroundColorEnter: something

    backgroundColorEnter := something
!

foregroundColorEnter

    ^ foregroundColorEnter
!

foregroundColorEnter: something

    foregroundColorEnter := something
! !

!ActionButtonSpec methodsFor:'building'!

getBindingIn:aBuilder
    ^ aBuilder actionFor:model

!

getBindingIn:aBuilder binding:binding
    |action nA|

    binding = model ifTrue:[
        "/ ST/X extension ... 
        (nA := model numArgs) == 1 ifTrue:[
            ^ aBuilder actionFor:model withValue:actionValue
        ].
        nA == 2 ifTrue:[
            ^ aBuilder actionFor:model withValue:actionValue withValue:actionValue2
        ]. 

        action := aBuilder actionFor:model.
        action isBlock ifTrue:[ 
            (nA := action numArgs) == 1 ifTrue:[
                ^ [action value:actionValue]
            ].
            nA == 2 ifTrue:[
                ^ [action value:actionValue value:actionValue2]
            ].
        ].
        ^ action
    ].
    ^ super getBindingIn:aBuilder binding:binding

    "Modified: / 18-10-1997 / 05:07:08 / cg"
    "Modified: / 30-07-2010 / 10:41:43 / sr"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.
    level notNil ifTrue:[
        level isSymbol ifTrue:[
            level := aView styleSheet at:level ifAbsent:0.
        ].
        "/ cg -> sv: don't set both from the level-attribute; leads to ugly looking
        "/ buttons in search dialog
        aView "/ activeLevel:level;
              passiveLevel:level.
    ].

    isDefault notNil ifTrue:[aView isReturnButton:self isDefault ].
    defaultable notNil ifTrue:[aView defaultable:self defaultable].
    autoRepeat notNil ifTrue:[aView autoRepeat:self autoRepeat].
    self hasImageOrientedLabel ifTrue:[
        aView beImageButton.
    ].
    self backgroundColorEnter notNil ifTrue:[
        aView enteredBackgroundColor:(self resolveColor:self backgroundColorEnter ifUnknown:[Color yellow] with:aBuilder).
    ].
    self foregroundColorEnter notNil ifTrue:[
        aView enteredForegroundColor:(self resolveColor:self foregroundColorEnter ifUnknown:[Color red] with:aBuilder).
    ].

    aBuilder isEditing ifFalse:[
        (self isDefault or:[self defaultable]) ifTrue:[
            aBuilder keyboardProcessor addAutoAcceptListener:aView controller
        ]
    ]
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"

    |m pressAction releaseAction pressChannel releaseChannel|

    model notNil ifTrue:[
        aBuilder isEditing ifFalse:[
            (m := self modelInBuilder:aBuilder) notNil ifTrue:[
                "/ an actionButton simply sends the model message
                "/ to the application

                m isBlock ifTrue:[
                    self isTriggerOnDown ifTrue:[
                        pressAction := m.
                    ] ifFalse:[
                        releaseAction := m
                    ]
                ] ifFalse:[
                    self isTriggerOnDown ifTrue:[
                        pressChannel := m.
                    ] ifFalse:[
                        releaseChannel := m.
                    ]
                ]
            ] ifFalse:[
                "/ no action ?!!
                ('ActionButtonSpec[info]: app provides no actionFor: ' , model printString) infoPrintCR.
            ].

            pressAction notNil ifTrue:[ aView pressAction:pressAction ].
            releaseAction notNil ifTrue:[ aView releaseAction:releaseAction ].
            pressChannel notNil ifTrue:[ aView pressChannel:pressChannel ].
            releaseChannel notNil ifTrue:[ aView releaseChannel:releaseChannel ].
        ]
    ]
! !

!ActionButtonSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    backgroundColorEnter notNil ifTrue:[backgroundColorEnter := backgroundColorEnter decodeAsLiteralArray].
    foregroundColorEnter notNil ifTrue:[foregroundColorEnter := foregroundColorEnter decodeAsLiteralArray].

    actionValue notNil ifTrue:[ actionValue := actionValue decodeAsLiteralArray ].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    defaultable        ~~ true ifTrue:[l add:#defaultable].
    isDefault          ~~ true ifTrue:[l add:#isDefault].
    isDecorated        ~~ true ifTrue:[l add:#isDecorated].
    autoRepeat         ~~ true ifTrue:[l add:#autoRepeat].
    isTriggerOnDown    ~~ true ifTrue:[l add:#isTriggerOnDown].
    actionValue          isNil ifTrue:[l add:#actionValue].
    actionValue2         isNil ifTrue:[l add:#actionValue2].
    backgroundColorEnter isNil ifTrue:[l add:#backgroundColorEnter ].
    foregroundColorEnter isNil ifTrue:[l add:#foregroundColorEnter ].

    ^l

    "Modified: / 24.8.1998 / 21:19:12 / cg"
! !

!ActionButtonSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    |controller|

    isDefault := aView isReturnButton.
    foregroundColorEnter := aView enteredForegroundColor.
    backgroundColorEnter := aView enteredBackgroundColor.
    hasCharacterOrientedLabel := aView label isImageOrForm not.
    (controller := aView controller) notNil ifTrue:[
        isTriggerOnDown := controller isTriggerOnDown.
    ].
    super fromView:aView callBack:aBlock
! !

!ActionButtonSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^ 'Button'
!

viewClass
    "return the corresponding view class of the spec"

    self class == ActionButtonSpec ifTrue:[
        ^ Button
    ].
    ^ super viewClass
! !

!ActionButtonSpec methodsFor:'queries-UIDefiner'!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    ^ someAspect == model

    "Created: / 21.4.1998 / 20:21:59 / cg"
    "Modified: / 21.4.1998 / 20:23:15 / cg"
! !

!ActionButtonSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitActionButtonSpec:self
! !

!ActionButtonSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ActionButtonSpec.st,v 1.143 2018-07-05 10:54:18 lukas Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ActionButtonSpec.st,v 1.143 2018-07-05 10:54:18 lukas Exp $'
! !

