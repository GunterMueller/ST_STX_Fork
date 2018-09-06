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

ViewWithScrollerSpec subclass:#DataSetSpec
	instanceVariableNames:'rowClassName rowIfAbsent dataList useIndex has3Dseparators
		doubleClickSelector columnHolder showLabels selectRowOnDefault
		valueChangeSelector multipleSelectOk beDependentOfRows
		verticalSpacing showHorizontalLines showVerticalLines
		selectCondition horizontalSpacing columns columnAdaptor
		tabAtEndAction tabAtStartAction x_modifiedChannel tabIntern
		doubleClickChannel separatorOneDColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!DataSetSpec class methodsFor:'documentation'!

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

!DataSetSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'DataSetSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@TUUUUU0Q@@@@B@D***+H@R<<<4 1H@@@R@D/OOMH@R@@@D AK333RKD @@AH8R<<<4 AH@@@R@D5UUUHDP@@@@ C*****@@@@@@@@b');
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

!DataSetSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DataSetSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'DataSet Basics'
         name: 'DataSet Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 398 388)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 178 0)
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
                   layout: (LayoutFrame 100 0 6 0 3 1.0 28 0)
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
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: selectionHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 31 0 -17 1 53 0)
                   activeHelpKey: selectionHolder
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
                   layout: (LayoutFrame -17 1 31 0 3 1 53 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 68 0 1 0.5)
                   activeHelpKey: listHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0.0 57 0 -87 1.0 79 0)
                   activeHelpKey: listHolder
                   tabable: true
                   model: listSelector
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button2'
                   layout: (LayoutFrame -87 1 57 0 -67 1 79 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: listSelector
                 )
                (CheckBoxSpec
                   label: 'Index'
                   name: 'useIndex'
                   layout: (AlignmentOrigin 8 1.0 69 0 1 0.5)
                   activeHelpKey: useIndex
                   tabable: true
                   model: useIndex
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Columns:'
                   name: 'columnsLabel'
                   layout: (AlignmentOrigin 100 0 93 0 1 0.5)
                   activeHelpKey: columnHolder
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'columnField'
                   layout: (LayoutFrame 100 0 82 0 3 1.0 104 0)
                   activeHelpKey: columnHolder
                   tabable: true
                   model: columnHolder
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: 'Table Column Editor'
                   name: 'startBuilder'
                   layout: (LayoutFrame 100 0 108 0 3 1.0 132 0)
                   activeHelpKey: columnButton
                   translateLabel: true
                   tabable: true
                   model: openDataSetColumnEditor
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 174 0 0 1.0 289 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 292 0 0 1.0 389 0)
             majorKey: UISpecification
             minorKey: scrollerSubSpec
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
     UIPainter new openOnClass:DataSetSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'DataSet Channels'
         name: 'DataSet Channels'
         min: (Point 329 493)
         max: (Point 329 493)
         bounds: (Rectangle 0 0 329 493)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 149 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'VisibilityChannelSubSpecification'
                   layout: (LayoutFrame 0 0.0 4 0.0 4 1.0 29 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 30 0.0 4 1.0 55 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 56 0.0 4 1.0 81 0)
                   majorKey: UISpecification
                   minorKey: subSpecForModifiedChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification6'
                   layout: (LayoutFrame 0 0.0 82 0.0 3 1.0 107 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 153 0 0 1.0 216 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification3'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks - Selection'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 216 0.0 0 1.0 336 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 7 0.0 4 1.0 35 0)
                   majorKey: UISpecification
                   minorKey: subSpecForSelectedValueChangeCallBack
                 )
                (UISubSpecification
                   name: 'SubSpecification5'
                   layout: (LayoutFrame 0 0.0 33 0.0 4 1.0 61 0)
                   majorKey: UISpecification
                   minorKey: subSpecForDoubleClickCallBack
                 )
                (LabelSpec
                   label: 'SelectCond:'
                   name: 'selectCondLabel'
                   layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                   activeHelpKey: selectConditionSelector
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'selectCondField'
                   layout: (LayoutFrame 100 0 60 0 3 1.0 82 0)
                   activeHelpKey: selectConditionSelector
                   tabable: true
                   model: selectCondition
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Callbacks - List'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 340 0.0 0 1.0 406 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Row If Abs.:'
                   name: 'rowIfAbsentLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: rowIfAbsent
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'rowIfAbsentField'
                   layout: (LayoutFrame 100 0 6 0 3 1.0 28 0)
                   activeHelpKey: rowIfAbsent
                   tabable: true
                   model: rowIfAbsent
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Focus At Start/End of List'
             name: 'FocusFrame'
             layout: (LayoutFrame 0 0.0 406 0 0 1.0 498 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Start Action:'
                   name: 'tabAtStartActionLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: tabbedOverStartAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'tabAtStartAction'
                   layout: (LayoutFrame 100 0 6 0 3 1 28 0)
                   activeHelpKey: tabbedOverStartAction
                   tabable: true
                   model: tabAtStartAction
                   group: inputGroup
                   acceptOnLeave: false
                   acceptOnLostFocus: false
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'End Action:'
                   name: 'tabAtEndActionLabel'
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: tabbedOverEndAction
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'tabAtEndAction'
                   layout: (LayoutFrame 100 0 32 0 3 1 54 0)
                   activeHelpKey: tabbedOverEndAction
                   tabable: true
                   model: tabAtEndAction
                   group: inputGroup
                   acceptOnLeave: false
                   acceptOnLostFocus: false
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
!

details2EditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DataSetSpec andSelector:#details2EditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: details2EditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Details2'
         name: 'SequenceView Details2'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 426 270)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Selection Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 102 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Allow Multiple Selections'
                   name: 'isMultiSelectCheckBox'
                   layout: (Point 10 2)
                   activeHelpKey: isMultiSelect
                   tabable: true
                   model: isMultiSelect
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Select Row for Unselectable Cell'
                   name: 'selectRowOnDefault'
                   layout: (Point 10 30)
                   activeHelpKey: selectRowOnDefault
                   tabable: true
                   model: selectRowOnDefault
                   translateLabel: true
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 105 0 0 1.0 177 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 179 0 0 1.0 248 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (Point 10 3)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Tab Into'
                   name: 'tabIntern'
                   layout: (Point 175 3)
                   activeHelpKey: tabIntern
                   tabable: true
                   model: tabIntern
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
     UIPainter new openOnClass:DataSetSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'DataSet Details'
         name: 'DataSet Details'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 398 378)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 240 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'FontMenu1'
                   layout: (LayoutFrame 100 0 6 0 5 1.0 28 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 100 0 47 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 100 0 35 0 5 1.0 57 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 75 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 63 0 5 1.0 85 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'borderLabel'
                   layout: (AlignmentOrigin 100 0 103 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'borderField'
                   layout: (LayoutFrame 100 0 92 0 140 0 114 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: borderWidth
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 228 0 103 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 230 0 92 0 270 0 114 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'H-Spacing:'
                   name: 'hSpaceLabel'
                   layout: (AlignmentOrigin 100 0 128 0 1 0.5)
                   activeHelpKey: horizontalSpace
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'hSpaceField'
                   layout: (LayoutFrame 100 0 117 0 140 0 139 0)
                   activeHelpKey: horizontalSpace
                   tabable: true
                   model: horizontalSpacing
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'V-Spacing:'
                   name: 'vSpaceLabel'
                   layout: (AlignmentOrigin 228 0 128 0 1 0.5)
                   activeHelpKey: verticalSpace
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'vSpaceField'
                   layout: (LayoutFrame 230 0 117 0 270 0 139 0)
                   activeHelpKey: verticalSpace
                   tabable: true
                   model: verticalSpacing
                   group: inputGroup
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: '3D-Look'
                   name: 'has3Dseparators'
                   layout: (Point 95 142)
                   activeHelpKey: has3Dseparators
                   tabable: true
                   model: has3Dseparators
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Show-Labels'
                   name: 'showLabels'
                   layout: (Point 227 142)
                   activeHelpKey: showLabels
                   tabable: true
                   model: showLabels
                   translateLabel: true
                 )
                (LabelSpec
                   label: '1D-Separator:'
                   name: 'separatorOneDColorLabel'
                   layout: (AlignmentOrigin 100 0 183 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'separatorOneDColor'
                   layout: (LayoutFrame 100 0 173 0 5 1.0 195 0)
                   activeHelpKey: separatorOneDColor
                   model: separatorOneDColor
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Row Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 237 0.0 0 1.0 305 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Make Rows Dependent'
                   name: 'beDependentOfRows'
                   layout: (Point 10 1)
                   activeHelpKey: beDependentOfRows
                   tabable: true
                   model: beDependentOfRows
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Adaptor'
             name: 'FramedBox3'
             layout: (LayoutFrame 0 0.0 296 0.0 0 1.0 362 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Columns'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: columnAdaptor
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 100 0 6 0 0 1 28 0)
                   activeHelpKey: columnAdaptor
                   tabable: true
                   model: columnAdaptor
                   group: inputGroup
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

!DataSetSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        tabIntern
                        isMultiSelect
                        showLabels
                        useIndex
                        has3Dseparators
                        rowClassName
                        beDependentOfRows
                        showHorizontalLines
                        showVerticalLines
                        selectRowOnDefault
                        separatorOneDColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        x_modifiedChannel
                        listSelector
                        doubleClickSelector
                        valueChangeSelector
                        tabAtEndAction
                        tabAtStartAction
                        rowIfAbsent
                        columnHolder
                        columnAdaptor
                        selectCondition
                        doubleClickChannel
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        horizontalSpacing
                        verticalSpacing
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    "Modified: / 30.1.2000 / 11:54:38 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics             basicsEditSpec)
            (Details1           detailsEditSpec)
            (Details2           details2EditSpec)
            (Channels           channelsEditSpec)
            ('Drag && Drop'      dragAndDropSpec)
       )

! !

!DataSetSpec class methodsFor:'queries'!

supportsDrag
    ^ true


!

supportsDrop
    ^ true


! !

!DataSetSpec methodsFor:'accessing'!

beDependentOfRows
    "return the value of the instance variable 'beDependentOfRows' (automatically generated)"

    ^ beDependentOfRows ? false
!

beDependentOfRows:something
    "set the value of the instance variable 'beDependentOfRows' (automatically generated)"

    beDependentOfRows := something.
!

columnAdaptor
    "return the value of the instance variable 'columnAdaptor' (automatically generated)"

    ^ columnAdaptor

    "Created: / 26.7.1998 / 12:07:01 / cg"
!

columnAdaptor:something
    "set the value of the instance variable 'columnAdaptor' (automatically generated)"

    columnAdaptor := something.

    "Created: / 26.7.1998 / 12:07:01 / cg"
!

columnHolder
    "return the value of the instance variable 'columnHolder' (automatically generated)"

    ^ columnHolder
!

columnHolder:something
    "set the value of the instance variable 'columnHolder' (automatically generated)"

    columnHolder := something.
!

columns
    "return the value of the instance variable 'columns' (automatically generated)"

    ^ columns
!

columns:something
    something size == 0 ifTrue:[
        columns := nil.
        ^ self
    ].
    (something first isKindOf:DataSetColumnSpec) ifFalse:[
        columns := (something 
                        collect:[:el | el decodeAsLiteralArray]
                        thenSelect:[:col | col isKindOf:DataSetColumnSpec]) 
                            asNilIfEmpty.
    ] ifTrue:[
        columns := something
    ].
!

dataList
    ^ dataList


!

dataList:aList
    dataList := aList


!

doubleClickSelector
    "return the value of the instance variable 'doubleClickSelector' (automatically generated)"

    ^ doubleClickSelector
!

doubleClickSelector:something
    "set the value of the instance variable 'doubleClickSelector' (automatically generated)"

    doubleClickSelector := something.
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    separatorOneDColor notNil ifTrue:[separatorOneDColor := separatorOneDColor decodeAsLiteralArray].
!

has3Dseparators
    "return the value of the instance variable 'has3Dseparators' (automatically generated)"

    ^ has3Dseparators ? false
!

has3Dseparators:something
    "set the value of the instance variable 'has3Dseparators' (automatically generated)"

    has3Dseparators := something.
!

has3Dsepartors
    "temporary kludge to fix ca's typo (which found its way into many specs ;-)"

    ^ self has3Dseparators
!

has3Dsepartors:something
    "temporary kludge to fix ca's typo (which found its way into many specs ;-)"

    self has3Dseparators:something
!

horizontalSpacing
    "return the value of the instance variable 'horizontalSpacing' (automatically generated)"

    horizontalSpacing isNil ifTrue:[
        horizontalSpacing := DSVColumnView horizontalSpacing
    ].
    ^ horizontalSpacing
!

horizontalSpacing:something
    "set the value of the instance variable 'horizontalSpacing' (automatically generated)"

    horizontalSpacing := something.
!

isMultiSelect

    ^ self multipleSelectOk
!

isMultiSelect:something

    multipleSelectOk := something.
!

listSelector
    ^ dataList


!

listSelector:something
    self dataList:something


!

multipleSelectOk
    "return the value of the instance variable 'multipleSelectOk' (automatically generated)"

    ^ multipleSelectOk ? false
!

multipleSelectOk:something
    "set the value of the instance variable 'multipleSelectOk' (automatically generated)"

    multipleSelectOk := something.
!

rowIfAbsent
    "return the value of the instance variable 'rowIfAbsent' (automatically generated)"

    ^ rowIfAbsent
!

rowIfAbsent:something
    "set the value of the instance variable 'rowIfAbsent' (automatically generated)"

    rowIfAbsent := something.
!

selectCondition
    "a select condition callback; must return true if a select is allowed"

    ^ selectCondition
!

selectCondition:something
    "a select condition callback; must return true if a select is allowed"

    selectCondition := something.
!

selectRowOnDefault
    "if a non-selectable column is clicked, shall the row be selected instead ?"

    ^ selectRowOnDefault ? true
!

selectRowOnDefault:something
    "if a non-selectable column is clicked, shall the row be selected instead ?"

    selectRowOnDefault := something.
!

separatorOneDColor
    "get the color used to draw a separator in oneD mode"

    ^ separatorOneDColor
!

separatorOneDColor:aColor
    "set the color used to draw a separator in oneD mode"

    separatorOneDColor := aColor.
!

showHorizontalLines
    ^ showHorizontalLines ? true
!

showHorizontalLines:aBoolean
    showHorizontalLines := aBoolean
!

showLabels

    ^ showLabels ? true
!

showLabels:something
    "set the value of the instance variable 'showLabels' (automatically generated)"

    showLabels := something.

!

showVerticalLines
    ^ showVerticalLines ? true
!

showVerticalLines:aBoolean
    showVerticalLines := aBoolean
!

tabAtEndAction
    "return the value of the instance variable 'tabAtEndAction' (automatically generated)"

    ^ tabAtEndAction
!

tabAtEndAction:something
    "set the value of the instance variable 'tabAtEndAction' (automatically generated)"

    tabAtEndAction := something.
!

tabAtStartAction
    "return the value of the instance variable 'tabAtStartAction' (automatically generated)"

    ^ tabAtStartAction
!

tabAtStartAction:something
    "set the value of the instance variable 'tabAtStartAction' (automatically generated)"

    tabAtStartAction := something.
!

tabIntern
    "return the value of the instance variable 'tabIntern' (automatically generated)"

    ^ tabIntern ? true
!

tabIntern:aBool
    "set the value of the instance variable 'tabIntern' (automatically generated)"

    tabIntern := aBool.
!

useIndex
    "return the value of the instance variable 'useIndex' (automatically generated)"

    ^ useIndex ? true
!

useIndex:something
    "set the value of the instance variable 'useIndex' (automatically generated)"

    useIndex := something.
!

valueChangeSelector
    "return the value of the instance variable 'valueChangeSelector' (automatically generated)"

    ^ valueChangeSelector
!

valueChangeSelector:something
    "set the value of the instance variable 'valueChangeSelector' (automatically generated)"

    valueChangeSelector := something.
!

verticalSpacing
    "return the value of the instance variable 'verticalSpacing' (automatically generated)"

    verticalSpacing isNil ifTrue:[
        verticalSpacing := DSVColumnView verticalSpacing
    ].
    ^ verticalSpacing
!

verticalSpacing:something
    "set the value of the instance variable 'verticalSpacing' (automatically generated)"

    verticalSpacing := something.
! !

!DataSetSpec methodsFor:'accessing-builder'!

rowClassName
    "used by the DataSetBuilder; get name of 'row' class
    "
    ^ rowClassName
!

rowClassName:aClassName
    "used by the DataSetBuilder; set name of 'row' class
    "
    rowClassName := aClassName.
! !

!DataSetSpec methodsFor:'accessing-channels'!

doubleClickChannel
    ^ doubleClickChannel

    "Modified: / 25-10-2010 / 12:29:02 / cg"
!

doubleClickChannel:something
    "set the value of the instance variable 'doubleClickChannel' (automatically generated)"

    doubleClickChannel := something.
!

x_modifiedChannel
    "return the value of the instance variable 'modifiedChannel' (automatically generated)"

    ^ x_modifiedChannel

    "Created: / 30.1.2000 / 11:54:57 / cg"
    "Modified: / 30.1.2000 / 12:30:52 / cg"
!

x_modifiedChannel:something
    "set the value of the instance variable 'modifiedChannel' (automatically generated)"

    x_modifiedChannel := something.

    "Created: / 30.1.2000 / 11:54:52 / cg"
    "Modified: / 30.1.2000 / 12:30:57 / cg"
! !

!DataSetSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |col appl chnl action callBack|

    aBuilder isEditing ifFalse:[
        dataList isNil ifTrue:[
            self setModelAttributeIn:aView with:aBuilder
        ] ifFalse:[
            self setModelIn:aView useIndex:(self useIndex) with:aBuilder.
        ].
    ].
    super setAttributesIn:aView with:aBuilder.

    aView showLabels:(self showLabels).
    aView has3Dseparators:(self has3Dseparators).
    aView builder:aBuilder.
    x_modifiedChannel notNil ifTrue:[aView modifiedChannel:(self getBindingIn:aBuilder binding:x_modifiedChannel)].
    horizontalSpacing notNil ifTrue:[aView horizontalSpacing:(self horizontalSpacing)].
    verticalSpacing   notNil ifTrue:[aView verticalSpacing:(self verticalSpacing)].

    aView showLabels:(self showLabels).
    aView has3Dseparators:(self has3Dseparators).

    aBuilder isEditing ifTrue:[
        ^ self setEditingAttributesIn:aView with:aBuilder.
    ].

    aView builder:aBuilder.
    "/ horizontalSpacing notNil ifTrue:[aView horizontalSpacing:(self horizontalSpacing)].
    "/ verticalSpacing   notNil ifTrue:[aView verticalSpacing:(self verticalSpacing)].

    "
     showHorizontalLines
     showVerticalLines
    "
    rowIfAbsent notNil ifTrue:[
        aView rowIfAbsent:(self callBackActionFor:rowIfAbsent with:aBuilder).
    ].
    aView beDependentOfRows:(self beDependentOfRows).

    columnAdaptor notNil ifTrue:[
        col := (self getBindingIn:aBuilder binding:columnAdaptor).
        col notNil ifTrue:[
            aView columnAdaptor:col.
        ]
    ].
    
    columns size ~~ 0 ifTrue:[
        columns do:[:aCol |
            |label rawLabel|

            label := aCol label.
            (label isString) ifTrue:[
                (aCol labelIsImage) ifTrue:[
                    aBuilder isEditing ifTrue:[
                        rawLabel := nil
                    ] ifFalse:[
                        rawLabel := aBuilder labelFor:(label asSymbol).
                    ]
                ] ifFalse:[
                    aCol translateLabel == true ifTrue:[
                        rawLabel := aBuilder translateString:label
                    ]
                ]
            ].
        ]
    ].

    aView columnDescriptors:columns.
    columnHolder notNil ifTrue:[
        aView columnHolder:(self getBindingIn:aBuilder binding:columnHolder).
    ].
    aView multipleSelectOk:(self multipleSelectOk).
    aView tabIntern:(self tabIntern).
    aView selectRowOnDefault:(self selectRowOnDefault).

    (tabAtStartAction notNil or:[tabAtEndAction notNil]) ifTrue:[
        (appl := aBuilder application) notNil ifTrue:[
            tabAtStartAction notNil ifTrue:[aView tabAtStartAction:[ appl perform:tabAtStartAction]].
            tabAtEndAction   notNil ifTrue:[aView   tabAtEndAction:[ appl perform:tabAtEndAction  ]].
        ]
    ].

    doubleClickSelector notNil ifTrue:[
        action := self callBackActionFor:doubleClickSelector with:aBuilder.
    ].

    doubleClickChannel notNil ifTrue:[
        chnl := self getBindingIn:aBuilder binding:doubleClickChannel.

        chnl notNil ifTrue:[
            action isNil ifTrue:[
                action := [:arg| chnl value:arg ].
            ] ifFalse:[
                callBack := action.
                action := [:arg| chnl value:arg. callBack value:arg ].
            ].
        ].
    ].

    aView doubleClickAction:action.
    valueChangeSelector notNil ifTrue:[
        aView action:(self callBackActionFor:valueChangeSelector with:aBuilder).
    ].
    selectCondition notNil ifTrue:[
        aView selectConditionBlock:(self callBackActionFor:selectCondition with:aBuilder).
    ].

"/    self setMenuIn:aView with:aBuilder.

    "Modified (format): / 13-09-2017 / 16:19:35 / cg"
!

setColorAttributesIn:aView with:aBuilder
    "apply my color attributes to aView"

    |realView|

    super setColorAttributesIn:aView with:aBuilder.

    self has3Dseparators ifFalse:[
        realView := aView.

        (aView respondsTo: #scrolledView) ifTrue: [
            realView := aView scrolledView
        ].
        realView separatorOneDColor:separatorOneDColor.
    ].
!

setEditingAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |row list|

    self showLabels ifFalse:[^ self].

    aBuilder showDefaults ifTrue:[
        aView has3Dseparators:true.
        aView columnDescriptors:(Array
            with:(DataSetColumnSpec label:'Table' selector:#at:)
            with:(DataSetColumnSpec label:'.....' selector:#at:)
        ).
        row := Array with:'cell 1' with:'cell 2'.
        aView list:(Array with:row with:row).
    ] ifFalse:[
        columns size ~~ 0 ifTrue:[
            list := columns
        ] ifFalse:[
            columnHolder notNil ifTrue:[
                list := aBuilder aspectFor:columnHolder
            ]
        ].

        list notNil ifTrue:[
            Error handle:[:ex|] do:[
                aView columnDescriptors:list
            ]
        ]
    ].
! !

!DataSetSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    (separatorOneDColor isNil or:[self has3Dseparators]) ifTrue:[
        l add:#separatorOneDColor
    ].
    doubleClickChannel isNil   ifTrue:[l add:#doubleClickChannel].
    selectCondition isNil      ifTrue:[l add:#selectCondition].
    dataList isNil             ifTrue:[l add:#dataList].
    self useIndex              ifTrue:[l add:#useIndex].
    self tabIntern             ifTrue:[l add:#tabIntern].
    self showLabels            ifTrue:[l add:#showLabels].
    self multipleSelectOk      ifFalse:[l add:#multipleSelectOk].
    self has3Dseparators       ifFalse:[l add:#has3Dseparators].
    self beDependentOfRows     ifFalse:[l add:#beDependentOfRows].
    self showVerticalLines     ifTrue:[l add:#showVerticalLines].
    self showHorizontalLines   ifTrue:[l add:#showHorizontalLines].
    self selectRowOnDefault    ifTrue:[l add:#selectRowOnDefault].
    x_modifiedChannel isNil    ifTrue:[l add:#modifiedChannel].
    doubleClickSelector isNil  ifTrue:[l add:#doubleClickSelector].
    valueChangeSelector isNil  ifTrue:[l add:#valueChangeSelector].
    tabAtEndAction isNil       ifTrue:[l add:#tabAtEndAction].
    tabAtStartAction isNil     ifTrue:[l add:#tabAtStartAction].
    rowIfAbsent  isNil         ifTrue:[l add:#rowIfAbsent].
    columnHolder isNil         ifTrue:[l add:#columnHolder].
    columnAdaptor isNil        ifTrue:[l add:#columnAdaptor].
    rowClassName isNil         ifTrue:[l add:#rowClassName].

    self verticalSpacing == DSVColumnView verticalSpacing ifTrue:[
        l add:#verticalSpacing
    ].

    self horizontalSpacing == DSVColumnView horizontalSpacing ifTrue:[
        l add:#horizontalSpacing
    ].
    ^ l

    "Modified: / 30.1.2000 / 12:23:11 / cg"
! !

!DataSetSpec methodsFor:'copying'!

postCopy
    super postCopy.
    columns := columns copy.
! !

!DataSetSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    multipleSelectOk   := aView multipleSelectOk.
    useIndex           := aView useIndex.
    has3Dseparators    := aView has3Dseparators.
    showLabels         := aView showLabels.
    beDependentOfRows  := aView beDependentOfRows.
    verticalSpacing    := aView verticalSpacing.
    horizontalSpacing  := aView horizontalSpacing.
    selectRowOnDefault := aView selectRowOnDefault.
    tabIntern          := aView tabIntern.

    showHorizontalLines := true.
    showVerticalLines   := true.

    super fromView:aView callBack:aBlock
! !

!DataSetSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Table'

!

viewClass
    "return the corresponding view class of the spec"

    ^ DataSetView
! !

!DataSetSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.

    rowIfAbsent         notNil ifTrue:[more add:rowIfAbsent].
    doubleClickSelector notNil ifTrue:[more add:doubleClickSelector].
    valueChangeSelector notNil ifTrue:[more add:valueChangeSelector].
    tabAtEndAction      notNil ifTrue:[more add:tabAtEndAction].
    tabAtStartAction    notNil ifTrue:[more add:tabAtStartAction].
    selectCondition     notNil ifTrue:[more add:selectCondition].
    ^ more

    "Modified: / 10.2.2000 / 01:25:46 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    dataList            notNil ifTrue:[more add:dataList].
    columnHolder        notNil ifTrue:[more add:columnHolder].
    doubleClickChannel  notNil ifTrue:[more add:doubleClickChannel].

    ^ more

    "Modified: / 10.2.2000 / 01:25:07 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator
    "
    dataList notNil ifTrue:[
        dataList == someAspect ifTrue:[
            ^ List
        ].
        ^ super defaultModelClassFor:someAspect
    ].
    ^ SelectionInList

    "Modified: / 26.10.1997 / 18:58:09 / cg"
!

defaultModelValueStringFor:someAspect
    "used by the UIPainters aspectGenerator
    "
    columnHolder == someAspect ifTrue:[
        ^ 'self class ' , someAspect , ' asValue'
    ].
    ^ super defaultModelValueStringFor:someAspect
! !

!DataSetSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitDataSetSpec:self
! !

!DataSetSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/DataSetSpec.st,v 1.107 2017-11-28 18:21:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/DataSetSpec.st,v 1.107 2017-11-28 18:21:32 cg Exp $'
! !

