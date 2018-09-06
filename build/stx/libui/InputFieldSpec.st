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

MenuComponentSpec subclass:#InputFieldSpec
	instanceVariableNames:'group isReadOnly callbacksSpec type formatString immediateAccept
		acceptOnLeave acceptOnReturn acceptOnTab acceptOnLostFocus
		numChars alignment hasBorder foregroundColor backgroundColor
		minValue maxValue acceptChannel converter modifiedChannel
		acceptOnPointerLeave acceptIfUnchanged autoSelectInitialText
		hasKeyboardFocusInitially entryCompletionBlock
		valueChangeCallBackSelector emptyFieldReplacementText
		translateEmptyFieldReplacementText'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!InputFieldSpec class methodsFor:'documentation'!

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

!InputFieldSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'InputFieldSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU0A????>@G????8@P@@@@!!AJ***2@D%UUUH@RUUUT QIUUURDD%UUUH@RPDAT AMUUUR@D@@@@H0_???? #*****A@@@@@@@b');
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

!InputFieldSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:InputFieldSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'InputField Basics'
         name: 'InputField Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 407 365)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 148 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 6 0 5 1.0 28 0)
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
                   label: 'Group ID:'
                   name: 'groupLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: inputFieldGroup
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'groupField'
                   layout: (LayoutFrame 100 0 31 0 5 1 53 0)
                   activeHelpKey: inputFieldGroup
                   tabable: true
                   model: group
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: textModel
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 56 0 -15 1 78 0)
                   activeHelpKey: textModel
                   tabable: true
                   model: model
                   acceptOnLeave: true
                   acceptOnLostFocus: false
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 56 0 5 1 78 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'View Class:'
                   name: 'viewClassLabel'
                   layout: (AlignmentOrigin 100 0 92 0 1 0.5)
                   activeHelpKey: viewClass
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'viewClassField'
                   layout: (LayoutFrame 100 0 81 0 5 1 103 0)
                   activeHelpKey: viewClass
                   tabable: true
                   model: viewClassName
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Field Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 144 0 0 1.0 349 0)
             visibilityChannel: fieldAttributesVisible
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Type:'
                   name: 'typeLabel'
                   layout: (AlignmentOrigin 120 0 19 0 1 0.5)
                   activeHelpKey: typeConverter
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'string'
                   name: 'typeListPopUpList'
                   layout: (LayoutFrame 120 0 7 0 5 1.0 31 0)
                   activeHelpKey: typeConverter
                   translateLabel: true
                   tabable: true
                   model: type
                   enableChannel: typeEnabled
                   menu: typeList
                 )
                (LabelSpec
                   label: 'Converter:'
                   name: 'converterLabel'
                   layout: (AlignmentOrigin 120 0 46 0 1 0.5)
                   activeHelpKey: converter
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'converterField'
                   layout: (LayoutFrame 120 0 35 0 5 1 57 0)
                   activeHelpKey: converter
                   tabable: true
                   model: converter
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Size:'
                   name: 'sizeLabel'
                   layout: (AlignmentOrigin 120 0 74 0 1 0.5)
                   activeHelpKey: maxChars
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'numCharsField'
                   layout: (LayoutFrame 120 0 62 0 149 0 84 0)
                   activeHelpKey: maxChars
                   tabable: true
                   model: numChars
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'FormatString:'
                   name: 'formatStringLabel'
                   layout: (AlignmentOrigin 275 0 74 0 1 0.5)
                   activeHelpKey: formatString
                   foregroundChannel: greyIfFormatStringDisabled
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'formatStringField'
                   layout: (LayoutFrame 275 0 62 0 0 1 84 0)
                   activeHelpKey: formatString
                   enableChannel: formatStringEnabled
                   tabable: true
                   model: formatString
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'MinValue:'
                   name: 'minLabel'
                   layout: (AlignmentOrigin 120 0 100 0 1 0.5)
                   activeHelpKey: minValue
                   foregroundChannel: greyIfMinMaxDisabled
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'minValueField'
                   layout: (LayoutFrame 120 0 89 0 180 0 111 0)
                   activeHelpKey: minValue
                   enableChannel: minMaxEnabled
                   tabable: true
                   model: minValue
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'MaxValue:'
                   name: 'maxLabel'
                   layout: (AlignmentOrigin 268 0 100 0 1 0.5)
                   activeHelpKey: maxValue
                   foregroundChannel: greyIfMinMaxDisabled
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'maxValueField'
                   layout: (LayoutFrame 268 0 89 0 338 0 111 0)
                   activeHelpKey: maxValue
                   enableChannel: minMaxEnabled
                   tabable: true
                   model: maxValue
                   group: inputGroup
                   type: numberOrNil
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'If Empty:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 120 0 127 0 1 0.5)
                   activeHelpKey: emptyFieldReplacementText
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 120 0 116 0 5 1 138 0)
                   activeHelpKey: emptyFieldReplacementText
                   tabable: true
                   model: emptyFieldReplacementText
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (CheckBoxSpec
                   label: 'Translate'
                   name: 'translateEmptyFieldTextCheckBox'
                   layout: (AlignmentOrigin 10 1 142 0 1 0)
                   activeHelpKey: translateEmptyFieldReplacementText
                   tabable: true
                   model: translateEmptyFieldReplacementText
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )

    "Modified: / 24-11-2017 / 00:35:13 / cg"
!

channelsAndModifiedEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:InputFieldSpec andSelector:#channelsAndModifiedEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsAndModifiedEditSpec
       window: 
      (WindowSpec
         label: 'Channels'
         name: 'Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 415 279)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 150 0)
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
                   name: 'EnableChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'ModifiedChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 55 0.0 4 1.0 80 0)
                   majorKey: UISpecification
                   minorKey: subSpecForModifiedChannel
                 )
                (UISubSpecification
                   name: 'BGColorChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 81 0.0 4 1.0 106 0)
                   majorKey: UISpecification
                   minorKey: subSpecForBGColorChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 150 0 0 1.0 270 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification3'
                   layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                   majorKey: UISpecification
                   minorKey: subSpecForValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'EntryCompletionBlockChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 58 0.0 4 1.0 83 0)
                   majorKey: InputFieldSpec
                   minorKey: subSpecForEntryCompletionBlockHolder
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsAcceptSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:InputFieldSpec andSelector:#detailsAcceptSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsAcceptSubSpec
       window: 
      (WindowSpec
         label: 'Accept Entries'
         name: 'Accept Entries'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 411 156)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Accept Entries'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0 0 0 0 1 158 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Immediate'
                   name: 'immediateAcceptCheckBox'
                   layout: (Point 10 3)
                   activeHelpKey: acceptImmediate
                   tabable: true
                   model: immediateAccept
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Tab'
                   name: 'acceptOnTabCheckBox'
                   layout: (Point 141 3)
                   activeHelpKey: acceptOnTab
                   tabable: true
                   model: acceptOnTab
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Lost Focus'
                   name: 'acceptOnLostFocusCheckBox'
                   layout: (Point 242 3)
                   activeHelpKey: acceptOnLostFocus
                   tabable: true
                   model: acceptOnLostFocus
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'On Return'
                   name: 'acceptOnReturnCheckBox'
                   layout: (Point 10 34)
                   activeHelpKey: acceptOnReturn
                   tabable: true
                   model: acceptOnReturn
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Leave'
                   name: 'acceptOnLeaveCheckBox'
                   layout: (Point 141 34)
                   activeHelpKey: acceptOnLeave
                   tabable: true
                   model: acceptOnLeave
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Pointer Leave'
                   name: 'acceptOnPointerLeaveCheckBox'
                   layout: (Point 242 34)
                   activeHelpKey: acceptOnPointerLeaveFocus
                   tabable: true
                   model: acceptOnPointerLeave
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'AcceptChannel:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 150 0 81 0 1 0.5)
                   activeHelpKey: acceptChannel
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 150 0 69 0 -1 1 91 0)
                   activeHelpKey: acceptChannel
                   tabable: true
                   model: #'x_acceptChannel'
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (CheckBoxSpec
                   label: 'Accept if unchanged'
                   name: 'acceptIfUnchanged'
                   layout: (Point 10 96)
                   activeHelpKey: acceptIfUnchanged
                   tabable: true
                   model: acceptIfUnchanged
                   translateLabel: true
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
     UIPainter new openOnClass:InputFieldSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'InputField Details'
         name: 'InputField Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 411 527)
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
             verticalSpace: 0
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'fontColorBorderSubSpec'
                   majorKey: UISpecification
                   minorKey: fontColorBorderSubSpec
                   extent: (Point 411 160)
                 )
                (UISubSpecification
                   name: 'detailsAcceptSubSpec'
                   minorKey: detailsAcceptSubSpec
                   extent: (Point 411 150)
                 )
                (UISubSpecification
                   name: 'detailsInitSubSpec'
                   majorKey: UISpecification
                   minorKey: detailsInitSubSpec
                   extent: (Point 411 56)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabableCheckBox'
                         layout: (Point 10 5)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Read Only'
                         name: 'isReadOnlyCheckBox'
                         layout: (Point 174 5)
                         activeHelpKey: readOnly
                         tabable: true
                         model: isReadOnly
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Has Initial Focus'
                         name: 'hasInitialFocusCheckBox'
                         layout: (LayoutFrame 10 0 35 0 0 1 62 0)
                         activeHelpKey: hasKeyboardFocusInitially
                         tabable: true
                         model: hasKeyboardFocusInitially
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 411 99)
                 )
                (FramedBoxSpec
                   label: 'Initial Selection'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Auto Select Initially'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 10 0 4 0 0 1 28 0)
                         activeHelpKey: selectInitially
                         tabable: true
                         model: autoSelectInitialText
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 411 63)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForEntryCompletionBlockHolder
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:InputFieldSpec andSelector:#subSpecForEntryCompletionBlockHolder
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForEntryCompletionBlockHolder
       window: 
      (WindowSpec
         label: 'Any Component EntryCompletionBlockHolder'
         name: 'Any Component EntryCompletionBlockHolder'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 33)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Completion:'
             name: 'entryCompletionBlockHolderLabel'
             layout: (AlignmentOrigin 150 0 12 0 1 0.5)
             activeHelpKey: entryCompletionBlock
             translateLabel: true
             resizeForLabel: true
           )
          (InputFieldSpec
             name: 'entryCompletionBlockHolderField'
             layout: (LayoutFrame 150 0 1 0 0 1.0 23 0)
             activeHelpKey: entryCompletionBlock
             tabable: true
             model: entryCompletionBlock
             group: inputGroup
             acceptOnLeave: true
             acceptOnLostFocus: true
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             acceptOnPointerLeave: true
           )
          )
        
       )
     )
! !

!InputFieldSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    env at:#fieldAttributesVisible put:true.

    self
        adaptApects:
                    #(
                        isReadOnly
                        type
                        minValue
                        maxValue
                        callbacksSpec
                        colors
                        foregroundColor
                        backgroundColor
                        immediateAccept
                        acceptOnLeave
                        acceptOnReturn
                        acceptOnTab
                        acceptOnLostFocus
                        acceptOnPointerLeave
                        acceptIfUnchanged
                        alignment
                        hasBorder
                        autoSelectInitialText
                        hasKeyboardFocusInitially
                        formatString
                        emptyFieldReplacementText
                        translateEmptyFieldReplacementText
                     )
        to:env
        for:inst
        channel:aChannel.

    self
        adaptApects:
                    #(
                        numChars
                     )
        to:env
        for:inst
        channel:aChannel
        converter:#numberOrNil.

    self
        adaptApects:
                    #(
                        x_acceptChannel
                        x_modifiedChannel
                        converter
                        group
                        entryCompletionBlock
                        valueChangeCallBackSelector
                     )
        to:env
        for:inst
        channel:aChannel
        converter:#symbolOrNil.

    env at:#typeList put:(self possiblePrintConverterTypes).
    env at:#alignmentList put:(ValueHolder with:#() ).
    env at:#minMaxEnabled
        put:(BlockValue
                with:[:v1 :v2 | v2 notNil
                                and:[v1 == #numberInRange
                                     or:[v1 == #integerInRange
                                     or:[v1 == #hexIntegerInRange
                                     or:[v1 == #numberInRangeOrNil]]]]]
                arguments:(Array with:(env at:#type) with:(env at:#model))).

    env at:#greyIfMinMaxDisabled
        put:(BlockValue
                with:[:v | v value ifTrue:[
                                Color black
                           ] ifFalse:[
                                Button defaultDisabledForegroundColor
                           ]
                     ]
                argument:(env at:#minMaxEnabled)).

    env at:#formatStringEnabled
        put:(BlockValue
                with:[:v1 :v2 | v2 value notNil
                                and:[ #( date dateOrNil time timeOrNil timestamp timestampOrNil) includes:v1 value ]]
                arguments:(Array with:(env at:#type) with:(env at:#model))).

    env at:#greyIfFormatStringDisabled
        put:(BlockValue
                with:[:v | v value ifTrue:[
                                Color black
                           ] ifFalse:[
                                Button defaultDisabledForegroundColor
                           ]
                     ]
                argument:(env at:#formatStringEnabled)).

    env at:#typeEnabled
        put:(BlockValue
                with:[:v1 :v2 | v1 value size > 0 and:[v2 value size == 0]]
                arguments:(Array with:(env at:#model) with:(env at:#converter))).

    "Modified: / 12-01-2008 / 19:03:41 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array
        with:ComboBoxSpec
        with:LabelSpec
        with:TextEditorSpec
        with:FilenameInputFieldSpec

    "Created: / 12-01-2008 / 23:42:52 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
	    (Basics   basicsEditSpec)
	    (Details  detailsEditSpec)
	    (Channels channelsAndModifiedEditSpec)
      )





! !

!InputFieldSpec methodsFor:'accessing'!

acceptIfUnchanged
    ^ acceptIfUnchanged  ? false
!

acceptIfUnchanged:something
    acceptIfUnchanged := something.
!

acceptOnLeave
    ^ acceptOnLeave ? true

    "Modified: / 29.7.1998 / 00:54:14 / cg"
!

acceptOnLeave:something
    acceptOnLeave := something.
!

acceptOnLostFocus
    "/ make the default true; seems to be a good default.
    ^ acceptOnLostFocus ? true

    "Modified: / 29.7.1998 / 00:51:44 / cg"
!

acceptOnLostFocus:aBoolean
    acceptOnLostFocus := aBoolean.

    "Modified (format): / 24-11-2017 / 00:24:06 / cg"
!

acceptOnPointerLeave
    ^ acceptOnPointerLeave ? true

    "Created: / 28.6.1999 / 18:09:36 / cg"
!

acceptOnPointerLeave:something
    acceptOnPointerLeave := something.

    "Created: / 28.6.1999 / 18:09:26 / cg"
!

acceptOnReturn
    ^ acceptOnReturn  ? true
!

acceptOnReturn:something
    acceptOnReturn := something.
!

acceptOnTab
    ^ acceptOnTab ? true
!

acceptOnTab:something
    acceptOnTab := something.
!

alignment
    ^ alignment
!

alignment:something
    alignment := something.
!

autoSelectInitialText
    ^ autoSelectInitialText

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

autoSelectInitialText:aBoolean
    autoSelectInitialText := aBoolean.

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

callbacksSpec
    ^ callbacksSpec

    "Created: 14.2.1997 / 15:55:54 / cg"
!

callbacksSpec:something
    callbacksSpec := something.

    "Created: 14.2.1997 / 15:55:54 / cg"
!

converter
    ^ converter
!

converter:something
    converter := something.
!

emptyFieldReplacementText
    ^ emptyFieldReplacementText
!

emptyFieldReplacementText:aStringOrNil
    emptyFieldReplacementText := aStringOrNil.
!

entryCompletionBlock
    ^ entryCompletionBlock
!

entryCompletionBlock:something
    entryCompletionBlock := something.
!

formatString
    ^ formatString
!

formatString:something
    formatString := something.
!

group
    ^ group
!

group:something
    group := something.
!

hasBorder
    ^ hasBorder ? false
!

hasBorder:aBoolean
    hasBorder := aBoolean.
!

hasKeyboardFocusInitially
    ^ hasKeyboardFocusInitially ? false
!

hasKeyboardFocusInitially:aBoolean
    hasKeyboardFocusInitially := aBoolean.
!

immediateAccept
    ^ immediateAccept ? false "/ true

    "Modified: / 29.7.1998 / 00:54:40 / cg"
!

immediateAccept:aBoolean
    immediateAccept := aBoolean.
!

isReadOnly
    "return true, if the text is readonly."

    ^ isReadOnly ? false

    "Created: 7.4.1997 / 19:04:57 / cg"
!

isReadOnly:aBoolean
    isReadOnly := aBoolean.

    "Created: 7.4.1997 / 19:04:57 / cg"
!

maxValue
    ^ maxValue
!

maxValue:aNumberOrNil
    maxValue := aNumberOrNil.
!

minValue
    "return the value of the instance variable 'minValue' (automatically generated)"

    ^ minValue
!

minValue:aNumberOrNil
    minValue := aNumberOrNil.
!

numChars
    ^ numChars
!

numChars:anIntegerOrNil
    numChars := anIntegerOrNil.
!

tabable
    "redefined to default to true (if never set explicitly)"

    ^ tabable ? true

    "Created: / 30.10.2001 / 14:01:06 / cg"
!

translateEmptyFieldReplacementText
    ^ translateEmptyFieldReplacementText ? false
!

translateEmptyFieldReplacementText:aBoolean
    translateEmptyFieldReplacementText := aBoolean.
!

type
    ^ type
!

type:something
    type := something.
!

valueChangeCallBackSelector
    ^ valueChangeCallBackSelector
!

valueChangeCallBackSelector:aSymbolOrNil
    valueChangeCallBackSelector := aSymbolOrNil.
! !

!InputFieldSpec methodsFor:'accessing-channels'!

acceptChannel
    ^ acceptChannel

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

acceptChannel:something
    acceptChannel := something.

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

modifiedChannel
    ^ modifiedChannel
!

modifiedChannel:aSymbolOrNil
    modifiedChannel := aSymbolOrNil.
!

x_acceptChannel
    "return the value of the instance variable 'acceptChannel'.
     This MUST not be named acceptChannel, as there is such channel when a spec is edited"

    ^ acceptChannel

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

x_acceptChannel:something
    "set the value of the instance variable 'acceptChannel'
     This MUST not be named acceptChannel, as there is such channel when a spec is edited"

    acceptChannel := something.

    "Created: / 28.7.1998 / 10:59:01 / cg"
!

x_modifiedChannel
    "return the value of the instance variable 'modifiedChannel'
     This MUST not be named modifiedChannel, as there is such channel when a spec is edited"

    ^ modifiedChannel
!

x_modifiedChannel:something
    "set the value of the instance variable 'modifiedChannel'
     This MUST not be named modifiedChannel, as there is such channel when a spec is edited"

    modifiedChannel := something.
! !

!InputFieldSpec methodsFor:'accessing-color & font'!

backgroundColor
    ^ backgroundColor
!

backgroundColor:something
    backgroundColor := something.
!

foregroundColor
    ^ foregroundColor
!

foregroundColor:something
    foregroundColor := something.
! !

!InputFieldSpec methodsFor:'building'!

defineCallBacksFor:aBuilder view:aView
    |inputChangeSelector appl|

    "/ transform ST-80 Style callBackSpec
    "/ into ST/X actions ...

    aBuilder isEditing ifFalse:[
	appl := aBuilder application.

	(appl notNil and:[callbacksSpec notNil]) ifTrue:[
	    inputChangeSelector := callbacksSpec valueChangeSelector.

	    inputChangeSelector notNil ifTrue:[
		aView crAction:[appl perform:inputChangeSelector].
		aView acceptAction:[:val | appl perform:inputChangeSelector].
	    ]
	]
    ].

    "Modified: / 20.6.1998 / 13:43:20 / cg"
!

getMaxValue: aBuilder
    "maxValue: either a valueHolder or a constant value"

    |chSym mav mavc|

    (chSym := self otherAttributeAt:#maxValueChannel)  notNil ifTrue:[
	mavc := self getBindingIn:aBuilder binding:chSym.
    ].
    (type == #numberInRange
    or:[type == #integerInRange
    or:[type == #hexIntegerInRange
    or:[type == #numberInRangeOrNil
    or:[mavc notNil]]]]
    ) ifTrue:[
	mav := maxValue.
	mavc notNil ifTrue:[
	    mavc value isNil ifTrue:[
		mavc value: mav.
	    ].
	    ^mavc
	].
    ] ifFalse:[
       mav := nil
    ].
    ^mav
!

getMinValue: aBuilder
    "minValue: either a valueHolder or a constant value"

    |chSym mivc miv|

    (chSym := self otherAttributeAt:#minValueChannel)  notNil ifTrue:[
	mivc := self getBindingIn:aBuilder binding:chSym.
    ].
    (type == #numberInRange
    or:[type == #integerInRange
    or:[type == #hexIntegerInRange
    or:[type == #numberInRangeOrNil
    or:[mivc notNil]]]]
    ) ifTrue:[
	miv := minValue.
	mivc notNil ifTrue:[
	    mivc value isNil ifTrue:[
		mivc value: miv.
	    ].
	    ^mivc
	].
    ] ifFalse:[
       miv := nil
    ].
    ^miv
!

modelInBuilder:aBuilder
    "redefined to get a model with optional typeconverter"

    |m tConv conv miv mav fmt|

    m := super modelInBuilder:aBuilder.
    m notNil ifTrue:[
        converter notNil ifTrue:[
            "/ app provides converter
            conv := self getBindingIn:aBuilder binding:converter.
            conv isNil ifTrue:[
                Transcript showCR:'converter aspect missing: ',converter.
            ] ifFalse:[
                conv model:m.
                m := conv.
            ].
        ] ifFalse:[
            "/ type specified ?
            "/ ugly code warning....
            type notNil ifTrue:[
                type == #password ifTrue:[
                    tConv := nil.
                ] ifFalse:[ type == #symbol ifTrue:[
                    tConv := #symbolOrNil
                ] ifFalse:[ type == #object ifTrue:[
                    tConv := #smalltalkObject
                ] ifFalse:[ type == #point ifTrue:[
                    tConv := #smalltalkPoint
                ] ifFalse:[
                    type ~~ #string ifTrue:[
                        tConv := type
                    ]
                ]]]].

                tConv notNil ifTrue:[
                    conv := self typeConverterOn:m builder:aBuilder.

                    fmt := self formatString.
                    self hasMinMax ifTrue:[
                        miv := self getMinValue: aBuilder.
                        mav := self getMaxValue: aBuilder.

                        tConv == #numberInRange ifTrue:[
                            conv numberToTextMinValue:miv maxValue:mav format:fmt.
                        ] ifFalse:[ tConv == #numberInRangeOrNil ifTrue:[
                            conv numberOrNilToTextMinValue:miv maxValue:mav format:fmt
                        ] ifFalse:[ tConv == #integerInRange ifTrue:[
                            conv integerToTextMinValue:miv maxValue:mav format:fmt
                        ] ifFalse:[ tConv == #hexIntegerInRange ifTrue:[
                            conv integerToHexTextMinValue:miv maxValue:mav format:fmt
                        ]]]].
                    ] ifFalse:[
                        tConv == #date ifTrue:[
                            conv dateWithFormat:fmt
                        ] ifFalse:[ tConv == #dateOrNil ifTrue:[
                            conv dateOrNilWithFormat:fmt
                        ] ifFalse:[tConv == #time ifTrue:[
                            conv timeOfClass:Time withFormat:fmt orDefault:Time now.
                        ] ifFalse:[ tConv == #timeOrNil ifTrue:[
                            conv timeOfClass:Time withFormat:fmt orDefault:nil.
                        ] ifFalse:[tConv == #timestamp ifTrue:[
                            conv timeOfClass:Timestamp withFormat:fmt orDefault:Timestamp now.
                        ] ifFalse:[ tConv == #timestampOrNil ifTrue:[
                            conv timeOfClass:Timestamp withFormat:fmt orDefault:nil.
                        ] ifFalse:[
                            conv perform:tConv. "/ something like #numberOrNil
                        ]]]]]].
                    ].
                    m := conv.
                ].
            ].
        ].

"/
"/ Do not use a BufferedValueHolder here;
"/ instead, use the EditFields acceptChannel feature.
"/
"/        acceptChannel notNil ifTrue:[
"/            aC := self getBindingIn:aBuilder binding:acceptChannel.
"/            aC notNil ifTrue:[
"/                m := BufferedValueHolder subject:m triggerChannel:aC
"/            ].
"/        ].
    ].
    ^ m

    "Modified: / 16-01-2011 / 11:10:13 / cg"
!

nameShownWhileEditingFor:aView
    (model notNil) ifTrue:[ ^ model].
    ^ aView name

    "Created: / 30.10.2001 / 13:56:08 / cg"
    "Modified: / 30.10.2001 / 13:59:25 / cg"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |txt|
    
    super setAttributesIn:aView with:aBuilder.
    self setModelAttributeIn:aView with:aBuilder.
    aView readOnly:(self isReadOnly).

    foregroundColor notNil ifTrue: [
        aView foregroundColor:(self resolveColor:foregroundColor ifUnknown:[Color red] with:aBuilder)]
    ifFalse:[
        aBuilder isEditing ifTrue: [
            aView foregroundColor: Color black
        ]
    ].
    backgroundColor notNil ifTrue: [
        aView backgroundColor:(self resolveColor:backgroundColor ifUnknown:[Color red] with:aBuilder)
    ] ifFalse:[
        aBuilder isEditing ifTrue: [
            aView backgroundColor: self viewClass defaultViewBackgroundColor
        ]
    ].

    initiallyDisabled == true ifTrue: [
        aView enabled:false "/ backgroundColor: Color lightGray
    ].

    aBuilder isEditing ifTrue:[
        aView contents:(self nameShownWhileEditingFor:aView).
        ^ self
    ].

    type == #password ifTrue:[
        aView bePassword.
    ].

    callbacksSpec notNil ifTrue:[self defineCallBacksFor:aBuilder view:aView].
    aView maxChars:numChars.
    (txt := emptyFieldReplacementText) notNil ifTrue:[
        (aBuilder application notNil and:[translateEmptyFieldReplacementText == true]) ifTrue:[
            txt := aBuilder application resources string:txt.
        ].    
        aView emptyFieldReplacementText:txt
    ].

    self setAcceptAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        valueChangeCallBackSelector notNil ifTrue:[
            aView model onChangeSend:valueChangeCallBackSelector to:aBuilder application.
            "/aView action:(self callBackActionFor:valueChangeCallBackSelector with:aBuilder).
        ]
    ].
!

setChannelsIn:anEditField with:aBuilder
    "set my model attributes to anEditField (or its model)"

    |mC aC ecC|

    aBuilder isEditing ifTrue:[^self].

    super setChannelsIn:anEditField with:aBuilder.

    modifiedChannel notNil ifTrue:[
	mC := self getBindingIn:aBuilder binding:modifiedChannel.
	mC notNil ifTrue:[
	    anEditField modifiedChannel:mC
	].
    ].

    acceptChannel notNil ifTrue:[
	aC := self getBindingIn:aBuilder binding:acceptChannel.
	aC notNil ifTrue:[
	    anEditField acceptChannel:aC
	].
    ].

    entryCompletionBlock notNil ifTrue:[
	ecC := self getBindingIn:aBuilder binding:entryCompletionBlock.
	ecC notNil ifTrue:[
	    anEditField entryCompletionBlockHolder:ecC
	].
    ].

    "Modified: / 28.7.1998 / 11:25:17 / cg"
!

setKeyboardFocusAttributesIn:aView with:aBuilder
    aBuilder keyboardProcessor addAutoAcceptListener:aView controller.
    super setKeyboardFocusAttributesIn:aView with:aBuilder

    "Created: / 09-12-2010 / 10:46:29 / cg"
!

setModelAttributeIn:anEditField with:aBuilder
    "set my model attributes to anEditField (or its model)"

    |m|

    aBuilder isEditing ifTrue:[^self].

    m := self modelInBuilder:aBuilder.

    m notNil ifTrue:[
        anEditField model:m.
        autoSelectInitialText == true ifTrue:[
            anEditField selectAllInitially
        ]
    ].
!

typeConverterOn:aModel builder:aBuilder
    ^ TypeConverter on:aModel.
! !

!InputFieldSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    callbacksSpec notNil ifTrue:[callbacksSpec := callbacksSpec decodeAsLiteralArray].
    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

    "Modified: / 19.4.1998 / 12:44:20 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    acceptIfUnchanged == true           ifFalse:[l add:#acceptIfUnchanged].
    isReadOnly ~~ true                  ifTrue:[l add:#isReadOnly].
    entryCompletionBlock isNil          ifTrue:[l add:#entryCompletionBlock].
    acceptOnReturn isNil                ifTrue:[l add:#acceptOnReturn].
    acceptOnTab isNil                   ifTrue:[l add:#acceptOnTab].
    acceptOnLeave isNil                 ifTrue:[l add:#acceptOnLeave].
    acceptOnLostFocus isNil             ifTrue:[l add:#acceptOnLostFocus].
    acceptOnPointerLeave isNil          ifTrue:[l add:#acceptOnPointerLeave].
    (self hasBorder)                    ifFalse:[l add:#hasBorder].
    immediateAccept isNil               ifTrue:[l add:#immediateAccept].
    group isNil                         ifTrue:[l add:#group].
    foregroundColor   isNil             ifTrue:[l add:#foregroundColor].
    backgroundColor   isNil             ifTrue:[l add:#backgroundColor].
    converter         isNil             ifTrue:[l add:#converter].
    formatString  isEmptyOrNil          ifTrue:[l add:#formatString].
    autoSelectInitialText ~~ true       ifTrue:[l add:#autoSelectInitialText].
    modifiedChannel isNil               ifTrue:[l add:#modifiedChannel].
    acceptChannel isNil                 ifTrue:[l add:#acceptChannel].
    hasKeyboardFocusInitially ~~ true   ifTrue:[l add:#hasKeyboardFocusInitially].
    translateEmptyFieldReplacementText ~~ true ifTrue:[l add:#translateEmptyFieldReplacementText]. 
    (self hasMinMax not or:[minValue isNil]) ifTrue:[l add:#minValue].
    (self hasMinMax not or:[maxValue isNil]) ifTrue:[l add:#maxValue].
    ^l

    "Modified: / 28.7.1998 / 10:28:43 / cg"
! !

!InputFieldSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    |c|

    (c := aView converter) notNil ifTrue:[
        type := c type.
        (type == #password and:[aView passwordCharacter notNil]) ifTrue:[
            type := #password
        ].
    ] ifFalse:[
        type := nil
    ].
    numChars := aView maxChars.
    immediateAccept := aView isImmediateAccept.
    acceptOnLeave := aView isAcceptOnLeave.
    acceptOnReturn := aView isAcceptOnReturn.
    acceptOnTab := aView isAcceptOnTab.
    acceptOnLostFocus := aView isAcceptOnLostFocus.
    foregroundColor := aView foregroundColor.
    backgroundColor := aView backgroundColor.
    acceptIfUnchanged := aView acceptIfUnchanged.
    emptyFieldReplacementText := aView emptyFieldReplacementText.

    super fromView:aView callBack:aBlock.
! !

!InputFieldSpec methodsFor:'queries'!

hasMinMax
    (type == #integerInRange) ifTrue:[ ^ true].
    (type == #hexIntegerInRange) ifTrue:[ ^ true].
    (type == #numberInRange) ifTrue:[ ^ true].
    (type == #numberInRangeOrNil) ifTrue:[ ^ true].
    ^ false
!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'EntryField'
!

viewClass
    "return the corresponding view class of the spec"

    self class == InputFieldSpec ifTrue:[
	^ EditField
    ].
    ^ super viewClass
! !

!InputFieldSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    group notNil ifTrue:[more add:group].
    acceptChannel notNil ifTrue:[more add:acceptChannel].
    modifiedChannel notNil ifTrue:[more add:modifiedChannel].
    ^ more

    "Modified: / 10.2.2000 / 01:25:00 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator"

    (group notNil and:[group == someAspect]) ifTrue:[
	^ EnterFieldGroup
    ].
    (acceptChannel notNil and:[acceptChannel == someAspect]) ifTrue:[
	^ TriggerValue
    ].
    ^ super defaultModelClassFor:someAspect

    "Modified: / 28.7.1998 / 11:28:33 / cg"
! !

!InputFieldSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitInputFieldSpec:self
! !

!InputFieldSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/InputFieldSpec.st,v 1.185 2017-11-28 18:21:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/InputFieldSpec.st,v 1.185 2017-11-28 18:21:49 cg Exp $'
! !

