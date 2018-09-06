"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

ComponentSpec subclass:#WindowSpec
	instanceVariableNames:'label labelChannel min max bounds menu performer
		hasHorizontalScrollBar hasVerticalScrollBar
		miniScrollerHorizontal miniScrollerVertical backgroundColor
		usePreferredExtent forceRecursiveBackground
		forceRecursiveBackgroundOfDefaultBackground iconLabel icon
		returnIsOKInDialog escapeIsCancelInDialog autoHideScrollBars
		exportedAspects listOfExportedAspects'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!WindowSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

!WindowSpec class methodsFor:'instance creation'!

label:aString
    ^ self new label:aString
! !

!WindowSpec class methodsFor:'defaults'!

defaultExtentInUIPainter
    ^ 300@300
! !

!WindowSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'WindowSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @P7]7]7]7]@ @P@@@@@@@@@ @PH"H0H"H#@ @PJH PJH"A@ @PJH PJH"A@ @PJH PJH"A@ @PJH PJH"A@ @PJH PJH"A@ @PJH PJH"A@ @PLQDPLQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
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

!WindowSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WindowSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'WindowSpec Basics'
         name: 'WindowSpec Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 330)
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
                         label: 'Label:'
                         name: 'titleLabel'
                         layout: (AlignmentOrigin 100 0 19 0 1 0.5)
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'titleField'
                         layout: (LayoutFrame 100 0 8 0 5 1 30 0)
                         activeHelpKey: windowLabel
                         tabable: true
                         model: label
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (UISubSpecification
                         name: 'SubSpecification3'
                         layout: (LayoutFrame 0 0.0 32 0.0 5 1.0 57 0)
                         majorKey: UISpecification
                         minorKey: subSpecForLabelChannel
                       )
                      (LabelSpec
                         label: 'Icon:'
                         name: 'iconLabel'
                         layout: (AlignmentOrigin 100 0 69 0 1 0.5)
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'iconField'
                         layout: (LayoutFrame 100 0 58 0 5 1 80 0)
                         activeHelpKey: windowIcon
                         tabable: true
                         model: icon
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      )
                    
                   )
                   extent: (Point 400 120)
                 )
                (FramedBoxSpec
                   label: 'MenuBar'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Selector:'
                         name: 'selectorLabel'
                         layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'menuField'
                         layout: (LayoutFrame 100 0 7 0 5 1.0 29 0)
                         activeHelpKey: menuId
                         tabable: true
                         model: menuSelector
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (LabelSpec
                         label: 'Performer:'
                         name: 'performerLabel'
                         layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'performerField'
                         layout: (LayoutFrame 100 0 32 0 5 1.0 54 0)
                         activeHelpKey: menuPerformer
                         tabable: true
                         model: performer
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      (ActionButtonSpec
                         label: 'Menu Editor'
                         name: 'menuButton'
                         layout: (LayoutFrame 100 0 59 0 5 1 83 0)
                         activeHelpKey: menuButton
                         translateLabel: true
                         tabable: true
                         model: openEditMenu
                       )
                      )
                    
                   )
                   extent: (Point 400 122)
                 )
                (UISubSpecification
                   name: 'scrollerSubSpec'
                   minorKey: scrollerSubSpec
                   extent: (Point 400 101)
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
     UIPainter new openOnClass:WindowSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'Window Channels'
         name: 'Window Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 63)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 -2 0.0 4 1.0 23 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
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
     UIPainter new openOnClass:WindowSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'WindowSpec Details'
         name: 'WindowSpec Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 464 335)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Window Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 222 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Min Width:'
                   name: 'minXLabel'
                   layout: (AlignmentOrigin 100 0 19 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'minXField'
                   layout: (LayoutFrame 100 0 8 0 150 0 30 0)
                   activeHelpKey: minXField
                   tabable: true
                   model: minX
                   group: inputGroup
                   type: numberOrNil
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Height:'
                   name: 'minYFabel'
                   layout: (AlignmentOrigin 222 0 19 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'minYField'
                   layout: (LayoutFrame 224 0 8 0 274 0 30 0)
                   activeHelpKey: minYField
                   tabable: true
                   model: minY
                   group: inputGroup
                   type: numberOrNil
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: ' Pick '
                   name: 'setMinButton'
                   layout: (LayoutFrame 287 0 8 0 326 0 30 0)
                   activeHelpKey: setMinExtent
                   translateLabel: true
                   tabable: true
                   model: setMinExtent
                 )
                (LabelSpec
                   label: 'Max Width:'
                   name: 'maxXLabel'
                   layout: (AlignmentOrigin 100 0 44 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'maxXField'
                   layout: (LayoutFrame 100 0 33 0 150 0 55 0)
                   activeHelpKey: maxXField
                   tabable: true
                   model: maxX
                   group: inputGroup
                   type: numberOrNil
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Height:'
                   name: 'maxYLabel'
                   layout: (AlignmentOrigin 222 0 44 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'maxYField'
                   layout: (LayoutFrame 224 0 33 0 274 0 55 0)
                   activeHelpKey: maxYField
                   tabable: true
                   model: maxY
                   group: inputGroup
                   type: numberOrNil
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: ' Pick '
                   name: 'setMaxButton'
                   layout: (LayoutFrame 287 0 33 0 326 0 55 0)
                   activeHelpKey: setMaxExtent
                   translateLabel: true
                   tabable: true
                   model: setMaxExtent
                 )
                (CheckBoxSpec
                   label: 'Use Preferred Extent'
                   name: 'prefExtentCheckBox'
                   layout: (Point 7 63)
                   activeHelpKey: usePreferredExtent
                   tabable: true
                   model: usePreferredExtent
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 109 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 97 0 2 1 119 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (CheckBoxSpec
                   label: 'In All Views with Default Background'
                   name: 'forceCheckBox2'
                   layout: (Point 7 123)
                   activeHelpKey: forceRecursiveBackgroundOfDefaultBackground
                   tabable: true
                   model: forceRecursiveBackgroundOfDefaultBackground
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'In All Views (Unconditional Overwrite)'
                   name: 'forceCheckBox'
                   layout: (Point 7 148)
                   activeHelpKey: forceRecursiveBackground
                   tabable: true
                   model: forceRecursiveBackground
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'If opened as Dialog'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 218 0 0 1.0 312 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Escape is Cancel'
                   name: 'escapeIsCancelCheckBox'
                   layout: (Point 7 2)
                   activeHelpKey: escapeIsCancelInDialog
                   tabable: true
                   model: escapeIsCancelInDialog
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Return is OK'
                   name: 'returnIsOKCheckBox'
                   layout: (Point 7 27)
                   activeHelpKey: returnIsOKInDialog
                   tabable: true
                   model: returnIsOKInDialog
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

exportChannelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WindowSpec andSelector:#exportChannelSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: exportChannelSpec
       window: 
      (WindowSpec
         label: 'Export Channels'
         name: 'Export Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 318 309)
       )
       component: 
      (SpecCollection
         collection: (
          (DataSetSpec
             name: 'ExportedAspectsTable'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             level: 0
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             autoHideScrollBars: true
             dataList: exportedAspects
             columns: 
            (Array
               
              (DataSetColumnSpec
                 label: 'Aspect'
                 labelAlignment: left
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: subAspect
                 canSelect: false
                 showSelectionHighLighted: false
               ) 
              (DataSetColumnSpec
                 label: 'Type'
                 labelButtonType: Button
                 columnAlignment: center
                 usePreferredWidth: true
                 height: heightOfFirstRow
                 model: typeString
                 canSelect: false
                 showSelectionHighLighted: false
               )
               
              (DataSetColumnSpec
                 label: 'Export'
                 labelButtonType: Button
                 usePreferredWidth: true
                 height: heightOfFirstRow
                 editorType: CheckToggle
                 rendererType: CheckToggle
                 model: callBack
                 showSelectionHighLighted: false
               )
             )
             #'x_modifiedChannel:' modifiedChannel
           )
          )
        
       )
     )
! !

!WindowSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        label
                        iconLabel
                        minX
                        minY
                        maxX
                        maxY
                        bounds
                        backgroundColor
                        usePreferredExtent
                        forceRecursiveBackground
                        forceRecursiveBackgroundOfDefaultBackground
                        escapeIsCancelInDialog
                        returnIsOKInDialog

                        exportedAspects
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        menu
                        performer
                        menuSelector
                        icon
                        labelChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#literal.

    self addScrollBarBindingsTo:env for:anInstance channel:aChannel.
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics             basicsEditSpec)
            (Details            detailsEditSpec)
            (Channels           channelsEditSpec)
            ('Export Channels'  exportChannelSpec)
       )
! !

!WindowSpec methodsFor:'accessing'!

autoHideScrollBars
    "return the value of the instance variable 'autoHideScrollBars' (automatically generated)"

    ^ autoHideScrollBars

!

autoHideScrollBars:aBooleanOrNil
    "set the value of the instance variable 'autoHideScrollBars' (automatically generated)"

    autoHideScrollBars := aBooleanOrNil

!

bounds
    "return bounds"

    ^ bounds
!

bounds:something
    "set bounds"

    bounds := something.
!

escapeIsCancelInDialog
    ^ escapeIsCancelInDialog ? true
!

escapeIsCancelInDialog:aBoolean
    escapeIsCancelInDialog := aBoolean
!

forceRecursiveBackground
    ^ forceRecursiveBackground ? false
!

forceRecursiveBackground:aBoolean
    forceRecursiveBackground := aBoolean.

    "Created: / 26.10.1997 / 22:18:10 / cg"
!

forceRecursiveBackgroundOfDefaultBackground
    ^ forceRecursiveBackgroundOfDefaultBackground ? false

    "Created: / 26.10.1997 / 22:18:10 / cg"
!

forceRecursiveBackgroundOfDefaultBackground:aBoolean
    forceRecursiveBackgroundOfDefaultBackground := aBoolean.

    "Created: / 26.10.1997 / 22:18:10 / cg"
!

hasHorizontalScrollBar
    ^ hasHorizontalScrollBar ? false


!

hasHorizontalScrollBar:something
    hasHorizontalScrollBar := something.


!

hasVerticalScrollBar
    ^ hasVerticalScrollBar ? false


!

hasVerticalScrollBar:something
    hasVerticalScrollBar := something.


!

icon
    "return the value of the instance variable 'icon' (automatically generated)"

    ^ icon

    "Created: / 27.10.1997 / 03:33:54 / cg"
!

icon:something
    "set the value of the instance variable 'icon' (automatically generated)"

    icon := something.

    "Created: / 27.10.1997 / 03:33:54 / cg"
!

iconLabel
    "return the value of the instance variable 'iconLabel' (automatically generated)"

    ^ iconLabel

    "Created: / 27.10.1997 / 03:33:49 / cg"
!

iconLabel:something
    "set the value of the instance variable 'iconLabel' (automatically generated)"

    iconLabel := something.

    "Created: / 27.10.1997 / 03:33:49 / cg"
!

label
    "return label"

    ^ label
!

label:something
    "set label"

    label := something.
!

max
    "return max"

    ^ max

    "Created: 14.2.1997 / 14:01:56 / cg"
!

max:something
    "set max"

    max := something.

    "Created: 14.2.1997 / 14:01:56 / cg"
!

maxX
    "return max x"

    max isNil ifTrue:[^ nil].
    ^ max x

    "Created: / 14.2.1997 / 14:01:56 / cg"
    "Modified: / 29.1.2000 / 23:48:16 / cg"
!

maxX:n
    "set max x"

    |y|

    y := max isNil ifTrue:[0] ifFalse:[max y].
    max := Point x:n y:y.

    "Modified: / 16.7.1998 / 17:52:50 / cg"
!

maxY
    "return max y"

    max isNil ifTrue:[^ nil].
    ^ max y

    "Created: / 14.2.1997 / 14:01:56 / cg"
    "Modified: / 29.1.2000 / 23:48:21 / cg"
!

maxY:n
    "set max y"

    |x|

    x := max isNil ifTrue:[0] ifFalse:[max x].
    max := Point x:x y:n

    "Modified: / 16.7.1998 / 17:53:32 / cg"
!

menu
    "return the value of the instance variable 'menu' (automatically generated)"

    ^ menu

    "Created: 25.1.1997 / 02:11:51 / cg"
!

menu:something
    "set the value of the instance variable 'menu' (automatically generated)"

    menu := something.

    "Created: 25.1.1997 / 02:11:52 / cg"
!

menuPerformer
    menu notNil ifTrue:[^ performer ].
  ^ nil


!

min
    "return min"

    ^ min
!

min:something
    "set min"

    min := something.
!

minX
    "return min x"

    min isNil ifTrue:[^ nil].
    ^ min x

    "Created: / 14.2.1997 / 14:01:56 / cg"
    "Modified: / 29.1.2000 / 23:47:34 / cg"
!

minX:n
    "set min x"
    |y|

    y := min isNil ifTrue:[0] ifFalse:[min y].
    min := Point x:n y:y
!

minY
    "return min y"

    min isNil ifTrue:[^ nil].
    ^ min y

    "Created: / 14.2.1997 / 14:01:56 / cg"
    "Modified: / 29.1.2000 / 23:47:55 / cg"
!

minY:n
    "set min y"

    |x|

    x := min isNil ifTrue:[0] ifFalse:[min x].
    min := Point x:x y:n

    "Modified: / 16.7.1998 / 17:53:15 / cg"
!

miniScrollerHorizontal
    ^ miniScrollerHorizontal ? false


!

miniScrollerHorizontal:something
    miniScrollerHorizontal := something.


!

miniScrollerVertical
    ^ miniScrollerVertical ? false


!

miniScrollerVertical:something
    miniScrollerVertical := something.


!

name:something
    "set label"

    "label := " name := something.
    label isNil ifTrue:[
        label := something
    ].
!

performer
    "return the value of the instance variable 'performer' (automatically generated)"

    ^ performer
!

performer:something
    "set the value of the instance variable 'performer' (automatically generated)"

    performer := something.
!

returnIsOKInDialog
    ^ returnIsOKInDialog ? true
!

returnIsOKInDialog:aBoolean
    returnIsOKInDialog := aBoolean
!

usePreferredExtent
    "return the value of the instance variable 'usePreferredExtent' (automatically generated)"

    ^ usePreferredExtent ? false

    "Created: / 26.10.1997 / 02:58:19 / cg"
    "Modified: / 26.10.1997 / 02:51:09 / cg"
!

usePreferredExtent:something
    "set the value of the instance variable 'usePreferredExtent' (automatically generated)"

    usePreferredExtent := something.

    "Created: / 26.10.1997 / 02:58:19 / cg"
! !

!WindowSpec methodsFor:'accessing-channels'!

labelChannel
    "return the value of the instance variable 'labelChannel' (automatically generated)"

    ^ labelChannel
!

labelChannel:something
    "set the value of the instance variable 'labelChannel' (automatically generated)"

    labelChannel := something.
! !

!WindowSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor

    "Created: / 25.10.1997 / 18:31:13 / cg"
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.

    "Created: / 25.10.1997 / 18:31:13 / cg"
! !

!WindowSpec methodsFor:'accessing-dummies'!

isEventDriven:aBoolean
    "what is that supposed to mean ?"
! !

!WindowSpec methodsFor:'accessing-export'!

exportedAspects
    ^ exportedAspects
!

exportedAspects:aList
    aList notNil ifTrue:[
        exportedAspects := SortedCollection sortBlock:[:a :b| a subAspect < b subAspect].

        aList do:[:el|
            el callBack == true ifTrue:[exportedAspects add:(el copy)]
        ]
    ] ifFalse:[
        exportedAspects := nil
    ].

!

exportedAspectsAddKey:aKey type:aTypeOrNil
    |entry|

    aKey isString ifFalse:[
        ^ nil
    ].

    entry := exportedAspects detect:[:el| el subAspect = aKey] ifNone:nil.

    entry isNil ifTrue:[
        entry := SubChannelInfoSpec new.
        entry subAspect:aKey asSymbol.
        entry type:aTypeOrNil.
        entry callBack:false.
        exportedAspects add:entry.
    ].
    ^ entry

    "Modified: / 18.2.2000 / 01:39:53 / cg"
!

setExportedAspects:theAspects
    exportedAspects := theAspects.
!

setExportedAspectsFrom:aList

    exportedAspects := SortedCollection sortBlock:[:a :b| a subAspect < b subAspect].

    aList size == 0 ifTrue:[
      ^ self
    ].
    aList do:[:el|
        |entry subAspect|

        el isArray ifTrue:[
            subAspect := (el first).
        ] ifFalse:[
            subAspect := el
        ].
        subAspect := subAspect asSymbol.

        (exportedAspects contains:[:entry | entry subAspect = subAspect]) ifFalse:[
            entry := SubChannelInfoSpec new.
            entry subAspect:subAspect.
            el isArray ifTrue:[
                entry type:(el at:2 ifAbsent:nil).
            ].
            entry callBack:true.
            exportedAspects add:entry.
        ].
    ].

    "Modified: / 18.2.2000 / 01:46:01 / cg"
! !

!WindowSpec methodsFor:'building'!

buildView
    |v|

    v := ApplicationWindow new.
    uuid notNil ifTrue:[
        v automationUUID:uuid.
    ].    
    ^ v

    "Modified: / 10-11-2017 / 00:03:18 / cg"
!

buildViewFor:aBuilder
    |v|

    "/ notice: the menu and scrollBars are setup in FullSpec ...
    v := self buildView.
    v application:(aBuilder application).
    self setupView:v for:aBuilder.
    ^ v

    "Modified: / 26.10.1997 / 22:30:37 / cg"
!

postBuildView:aView for:aBuilder
    "callback from builder, when a components subComponents
     have been built - allows for late fixups ..."

    |theOnlySubView subViews theMenuView firstViewsIndex 
     prefMenu prefView pref numSubViews ext|

    (forceRecursiveBackground == true 
    or:[ forceRecursiveBackgroundOfDefaultBackground == true ]) ifTrue:[
        self recursivelySetViewBackgroundsInView:aView for:aBuilder
    ].

    self usePreferredExtent == true ifTrue:[
        "/ too bad: we need a menu-wrapping widget here,
        "/ which provides a proper preferredExtent.
        "/ for now, hand-craft the prefExtent by summing
        "/ up the menus (if any) and the other views preferred
        "/ extent.

        subViews := aView subViews.
        (numSubViews := subViews size) > 0 ifTrue:[
            firstViewsIndex := 1.
            numSubViews > 1 ifTrue:[
                menu notNil ifTrue:[
                    theMenuView := subViews first.
                    prefMenu := theMenuView preferredExtent.
                    firstViewsIndex := 2.
                ].
            ].
            numSubViews == firstViewsIndex ifTrue:[
                theOnlySubView := subViews at:firstViewsIndex.
                prefView := pref := theOnlySubView preferredExtent.
                prefMenu notNil ifTrue:[
                    pref := (prefView x max:(prefMenu x))
                            @
                            (prefMenu y + prefView y).
                ].
                aView extent:pref.
            ].
"/            theOnlySubView origin:0.0@0.0 extent:1.0@1.0.
        ]
    ] ifFalse:[
        ext := bounds extent.
"/        ext := ext min:aView device extent.
        aView preferredExtent:ext.
        aView extent:ext.
    ].

    "Created: / 26.10.1997 / 22:30:29 / cg"
    "Modified: / 30.1.2000 / 00:55:19 / cg"
!

recursivelySetViewBackgroundsInView:aView for:aBuilder
    |bg|

    bg := aView viewBackground.
    forceRecursiveBackground == true ifTrue:[
        aView allSubViewsBackground:bg
    ] ifFalse:[
        forceRecursiveBackgroundOfDefaultBackground == true ifTrue:[
            aView 
                allSubViewsBackground:bg 
                if:[:eachSubView | 
                    |eachViewsSpec|

                    eachViewsSpec := aBuilder componentToSpecMappingAt:eachSubView.
                    eachViewsSpec isNil ifTrue:[
                        true
                    ] ifFalse:[
                        eachViewsSpec usedBackgroundColor isNil
                    ]
                ]
        ].
    ].
!

scaledValue:val
    ^ val
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |img x y kp|

    label notNil ifTrue:[
        aView label:(self getLabel:label translate:true with:aBuilder). 
    ].
    iconLabel notNil ifTrue:[
        aView iconLabel:(self getLabel:iconLabel translate:true with:aBuilder). 
    ].

    min notNil ifTrue:[ 
        x := min x ? 0. 
        y := min y ? 0.
        aView minExtent:(x @ y) 
    ].
    max notNil ifTrue:[ 
        x := max x ? 9999. 
        y := max y ? 9999.
        aView maxExtent:(x @ y) 
    ].
    bounds notNil ifTrue:[ aView extent:bounds extent ].
    icon notNil ifTrue:[
        img := aBuilder labelFor:icon asSymbol.
        img notNil ifTrue:[
            aView icon:img
        ]
    ].                       
    self setBackgroundColorAttributesIn:aView with:aBuilder.
    aBuilder isEditing ifFalse:[
        (aView respondsTo:#keyboardProcessor:) ifTrue:[
            (kp := aBuilder keyboardProcessor) notNil ifTrue:[
                kp returnIsOKInDialog:(self returnIsOKInDialog).
                kp escapeIsCancelInDialog:(self escapeIsCancelInDialog).
                aView keyboardProcessor:kp.
            ].
        ].
    ].
    aBuilder isEditing ifFalse:[
        borderWidth := nil.
        super setAttributesIn:aView with:aBuilder.
    ].
!

setBackgroundColorAttributesIn:aView with:aBuilder
    self setViewBackgroundAttribute:backgroundColor in:aView with:aBuilder.

    backgroundColor notNil ifTrue:[
        (forceRecursiveBackground == true
        or:[ forceRecursiveBackgroundOfDefaultBackground == true ]) ifTrue:[
            self recursivelySetViewBackgroundsInView:aView for:aBuilder
        ]
    ].
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        labelChannel notNil ifTrue:[
            c := self channel:#labelChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView labelChannel:c].
        ].
    ].
!

setupView:v for:aBuilder
    self setAttributesIn:v with:aBuilder.
    self setKeyboardFocusAttributesIn:v with:aBuilder.
    ^ v.

    "Modified: / 26.10.1997 / 02:57:10 / cg"
! !

!WindowSpec methodsFor:'converting'!

flags
    flags := 0.

    self hasHorizontalScrollBar ifTrue:[
        flags := flags bitOr:FlagHScroll.

        self miniScrollerHorizontal ifTrue:[
            flags := flags bitOr:FlagHScrollMini.
        ]
    ].

    self hasVerticalScrollBar ifTrue:[
        flags := flags bitOr:FlagVScroll.

        self miniScrollerVertical ifTrue:[
            flags := flags bitOr:FlagVScrollMini.
        ]
    ].
  ^ flags
!

flags:something
    flags := something ? 0.

    hasHorizontalScrollBar := flags bitTest:FlagHScroll.
    hasVerticalScrollBar   := flags bitTest:FlagVScroll.
    miniScrollerHorizontal := flags bitTest:FlagHScrollMini.
    miniScrollerVertical   := flags bitTest:FlagVScrollMini.
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    layout := nil.
    label isArray ifTrue:[label := label decodeAsLiteralArray].
    min notNil ifTrue:[min := min decodeAsLiteralArray].
    max notNil ifTrue:[max := max decodeAsLiteralArray].
    bounds notNil ifTrue:[bounds := bounds decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

    "Modified: / 25.10.1997 / 18:28:59 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    l addAll:
        #(
            #hasHorizontalScrollBar
            #miniScrollerHorizontal
            #hasVerticalScrollBar
            #miniScrollerVertical
            #listOfExportedAspects      "/ never set with WindowSpec
            #exportedAspects            "/ never set with WindowSpec

            #borderWidth                "/ inherited, but never set with WindowSpec
            #level                      "/ inherited, but never set with WindowSpec
            #layout                     "/ inherited, but never set with WindowSpec
        ).
    backgroundColor isNil          ifTrue:[l add:#backgroundColor].
    (usePreferredExtent ~~ true)   ifTrue:[l add:#usePreferredExtent].
    forceRecursiveBackground ~~ true ifTrue:[l add:#forceRecursiveBackground].
    forceRecursiveBackgroundOfDefaultBackground ~~ true ifTrue:[l add:#forceRecursiveBackgroundOfDefaultBackground].
    iconLabel isNil                ifTrue:[l add:#iconLabel].
    icon isNil                     ifTrue:[l add:#icon].
    labelChannel isNil             ifTrue:[l add:#labelChannel].
    (escapeIsCancelInDialog ~~ false) ifTrue:[l add:#escapeIsCancelInDialog].
    (returnIsOKInDialog ~~ false)     ifTrue:[l add:#returnIsOKInDialog].

    (min isNil or:[min x isNil and:[min y isNil]]) ifTrue:[l add:#min].
    (max isNil or:[max x isNil and:[max y isNil]]) ifTrue:[l add:#max].
    icon isNil                                     ifTrue:[l add:#icon].

    menu isNil ifTrue:[
        l add:#performer; add:#menu.
    ] ifFalse:[
        performer isNil ifTrue:[l add:#performer].
    ].

    ^l

    "Modified: / 20.6.1998 / 13:42:04 / cg"
! !

!WindowSpec methodsFor:'copying'!

copy
    "have to copy my exported aspects
    "
    |aCopy|

    aCopy := super copy.
    aCopy exportedAspects:(aCopy exportedAspects copy).
  ^ aCopy
! !

!WindowSpec methodsFor:'kludge-helpers'!

copyValuesFromSpec:aWindowSpec
    "needed for the UIPainter..."

    self menu:(aWindowSpec menu).
    self performer:(aWindowSpec performer).
    self flags:(aWindowSpec flags).
    self forceRecursiveBackground:(aWindowSpec forceRecursiveBackground).
    self forceRecursiveBackgroundOfDefaultBackground:(aWindowSpec forceRecursiveBackgroundOfDefaultBackground).
    self usePreferredExtent:(aWindowSpec usePreferredExtent).
    self backgroundColor:(aWindowSpec backgroundColor).
    self iconLabel:(aWindowSpec iconLabel).
    self icon:(aWindowSpec icon).
    self min:(aWindowSpec min).
    self max:(aWindowSpec max).
    self returnIsOKInDialog:(aWindowSpec returnIsOKInDialog).
    self escapeIsCancelInDialog:(aWindowSpec escapeIsCancelInDialog).
    self hasHorizontalScrollBar:(aWindowSpec hasHorizontalScrollBar).
    self hasVerticalScrollBar:(aWindowSpec hasVerticalScrollBar).
    self miniScrollerHorizontal:(aWindowSpec miniScrollerHorizontal).
    self miniScrollerVertical:(aWindowSpec miniScrollerVertical).
    self label:(aWindowSpec label).
    self labelChannel:(aWindowSpec labelChannel).
    self visibilityChannel:(aWindowSpec visibilityChannel).
    self exportedAspects:(aWindowSpec exportedAspects).
    self uuid:(aWindowSpec uuid).
    self name:(aWindowSpec name).
! !

!WindowSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    |clr|

    label := aView topView label.
    min := aView minExtent.
    max := aView maxExtent.
    max = aView device usableExtent ifTrue:[
        "do not set the default value (screen size).
         Someone may want to open the window on a larger display"

        max := nil.
    ].
    bounds := aView origin extent:aView extent.

    clr := aView viewBackground.
    (clr = View defaultViewBackgroundColor) ifTrue:[
        clr := nil
    ].
    self backgroundColor:clr.

    super fromView:aView callBack:aBlock.

    "
     |top|

     top := StandardSystemView new.
     top extent:200@350.
     top label:'hello'.

     (WindowSpec fromView:top) inspect
    "

    "Modified: / 10-11-2017 / 00:16:47 / cg"
! !

!WindowSpec methodsFor:'queries'!

documentFileName
    "returns the basename of the file, which contains the html documentation for
     the widget (shown in the UI-Painters widget-doc)."

    ^ 'WindowSpec'

    "Created: / 02-10-2014 / 11:35:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasHScroller
    "returns true if horizontal scrollers are configured
    "
    ^ (flags ? 0) bitTest:FlagHScroll
!

hasVScroller
    "returns true if vertical scrollers are configured
    "
    ^ (flags ? 0) bitTest:FlagVScroll
!

menuSelector
    ^ menu


!

menuSelector:something
    menu := something


!

pullDownMenuIn:aBuilder
    "returns the pulldown menu or nil
    "
    |sel menu appl recv|

    (     (sel  := self menuSelector) notNil
     and:[(appl := aBuilder application) notNil
     and:[(menu := aBuilder menuFor:sel) notNil]]
    ) ifTrue:[
        menu := menu value.

        menu isArray ifTrue:[
            menu := menu decodeAsLiteralArray
        ].

        performer notNil ifTrue:[
            (recv := self getBindingIn:aBuilder binding:performer) notNil ifTrue:[
                appl := recv
            ]
        ].
        menu findGuiResourcesIn:appl.
        "/ care for redefined aspects in the builder's bindings
        "/ this allows for open:withBindings: to provide menu actions in the bindings
        menu allItemsDo:[:item |
            item itemValue isSymbol ifTrue:[
                (aBuilder bindings includesKey:item itemValue) ifTrue:[
                    item itemValue:(aBuilder actionFor:item itemValue).
                    "/ Transcript show:item itemValue; show:' -> '; showCR:(aBuilder actionFor:item itemValue).
                ].    
            ].    
        ].

        "/ menu receiver:appl   -- now done in findGuiResources ...
    ].
    ^ menu

    "Modified: / 27.10.1997 / 15:27:58 / cg"
! !

!WindowSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "answer the selectors used to fetch aspects"

    |more|

    more := super aspectSelectors.
    labelChannel notNil ifTrue:[more add:labelChannel].
    ^ more
! !

!WindowSpec methodsFor:'testing'!

isWindowSpec
    ^ true
! !

!WindowSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitWindowSpec:self
! !

!WindowSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/WindowSpec.st,v 1.127 2017-11-28 18:21:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/WindowSpec.st,v 1.127 2017-11-28 18:21:42 cg Exp $'
! !

