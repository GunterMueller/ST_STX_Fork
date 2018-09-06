"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#DSVColumnView
	instanceVariableNames:'labelView listHolder editValue editView multipleSelectOk useIndex
		selectedColIndexHolder selectedRowIndex selectRowOnDefault
		buttonMotionAction buttonReleaseAction rowHeight minRowHeight
		columnDescriptors viewOrigin colorMap rowFontAscent lockRowIndex
		rowIfAbsentBlock columnHolder registererImages list fgColor
		separatorSize catchChangeEvents beDependentOfRows bgColor
		actionBlock builder tabIntern doubleClickActionBlock
		verticalSpacing horizontalSpacing rowSelectorForm
		buttonLightColor buttonShadowColor buttonHalfLightColor
		buttonHalfShadowColor checkToggleExtent checkToggleForm
		checkToggleActiveImage checkTogglePassiveImage checkToggleLevel
		radioButtonActiveImage radioButtonPassiveImage comboButtonExtent
		comboButtonForm comboButtonLevel dropSource columnAdaptor
		tabAtEndAction tabAtStartAction modifiedChannel autoScroll
		autoScrollBlock needFitColumns scrollWhenUpdating
		separatorOneDColor selectionForegroundColor
		selectionForegroundColorNoFocus selectionBackgroundColor
		selectionBackgroundColorNoFocus selectionFrameColor
		selectionFrameColorNoFocus previousExtent selectConditionBlock
		scrollRowWise autoScrollToColumn cachedPreferredExtent
		sortListInPlace labelFgColor labelBgColor
		updateListHolderWhenSorting'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor
		DefaultHilightForegroundColor DefaultHilightBackgroundColor
		DefaultHilightFrameColor ButtonLightColor ButtonShadowColor
		CheckToggleActiveImage CheckTogglePassiveImage
		ButtonHalfLightColor ButtonHalfShadowColor ButtonEdgeStyle
		CheckToggleForm CheckToggleLevel CheckToggleExtent
		ComboButtonForm ComboButtonLevel ComboButtonExtent
		StopRedrawSignal RadioButtonActiveImage RadioButtonPassiveImage
		PreselectAllWhenOpeningEditor
		DefaultHilightForegroundColorNoFocus
		DefaultHilightBackgroundColorNoFocus DefaultLabelForegroundColor
		DefaultLabelBackgroundColor'
	poolDictionaries:''
	category:'Views-DataSet'
!

!DSVColumnView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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
    ColumnView part of a DataSetView.
    implements a scrollable selection view based on rows and columns.
    Used as the contents-part of a DataSetView.

    [Instance variables:]

        editValue               <Model>                 current editing model
        editView                <View>                  current editing component

        buttonReleaseAction     <Action or nil>         called if the mouse button is released
        buttonMotionAction      <Action or nil>         called during mouse motion with one
                                                        argument the point under the mouse.

        multipleSelectOk        <Boolean>               multiple selection enabled/disabled

        selectedColIndex        <Integer>               selected column index or 0
        selectedRowIndex        <Integer>               selected row    index or 0

        rowHeight               <Integer>               maximum height of any row
        minRowHeight            <Integer>               minimum height of all displayed labels

        columnDescriptors       <SequancableCollection> list of column descriptors

        viewOrigin              <Point>                 current view origin

        colorMap                <Dictionary>            store and register used colors on device

        rowFontAscent           <SmallInteger>          inset of a printable text in a row
                                                        including separator and font ascent.

        lockRowIndex            <SmallInteger>          internal used to indicate a row which has
                                                        changed its contents but no redraw should be
                                                        done( at:put: ).

        columnHolder            <ValueHolder>           holder which keeps the list of column descriptors.

        registererImages        <IdentityDictionary>    list of images registered on the device

        list                    <SequancableCollection> list of rows


        catchChangeEvents       <Boolean>               internal used to discard change notifications

        beDependentOfRows       <Boolean>               keep rows dependent; on default is disabled.
                                                        in case of enabled a row can raise a change
                                                        notification whithout a parameter which
                                                        will force a redraw of the row or the
                                                        readSelector of the column which will
                                                        redraw the cell in the row only.

        fgColor                 <Color>                 foreground color
        bgColor                 <Color>                 background color
        hgLgFgColor             <Color>                 highlight foreground color (selected)
        hgLgBgColor             <Color>                 highlight background color (selected)

        buttonLightColor        <Color>                 LightColor      ( drawing the edge of a button )
        buttonShadowColor       <Color>                 ShadowColor     ( drawing the edge of a button )
        buttonHalfLightColor    <Color>                 HalfLightColor  ( drawing the edge of a button )
        buttonHalfShadowColor   <Color>                 HalfShadowColor ( drawing the edge of a button )

        actionBlock             <a OneArgBlock>         action block performed on select
        doubleClickActionBlock  <a OneArgBlock>         action block performed on double click
        rowIfAbsentBlock        <a OneArgBlock>         this block is performed on an empty list entry
                                                        to retrive the item from the application. The
                                                        argument to the block is the index into the list.
                                                        The block should return the row instance which
                                                        is put to the list under the index.

        builder                 <UIBuilder>             builder set by application

        verticalSpacing         <SmallInteger>          vertical   row spacing( top  & bottom )
        horizontalSpacing       <SmallInteger>          horizontal row spacing( left & right )
        separatorSize           <SmallInteger>          line width of a vertical or horizontal separator

        rowSelectorForm         <Form>                  form used by a row selector

        checkToggleForm         <Form>                  form used by a checkToggle
        checkToggleExtent       <Point>                 extent of a checkToggle
        checkToggleLevel        <SmallInteger>          level used to draw a check toggle

        comboButtonForm         <Form>                  form used by a comboList or -Box
        comboButtonExtent       <Point>                 extent of a comboList or -Box
        comboButtonLevel        <SmallInteger>          level used to draw a comboList or -Box

        dropTarget              <DropTarget>            drag & drop target
        dropSource              <DropSource>            drag & drop source

    [author:]
        Claus Atzkern

    [see also:]
        DataSetColumnSpec
        DataSetColumn
        DataSetView
"
! !

!DSVColumnView class methodsFor:'defaults'!

defaultFont
    ^ SelectionInListView defaultFont
!

horizontalSpacing
    "returns the default horizontal space between rows
    "
    ^ 4

!

preselectAllWhenOpeningEditor:aBoolean
    PreselectAllWhenOpeningEditor := aBoolean

    "Created: / 02-11-2010 / 22:00:28 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#textForegroundColor 
                       #'scrollableView.backgroundColor'
                       #'button.lightColor'
                       #'button.shadowColor'
                       #'button.halfLightColor'
                       #'button.halfShadowColor'
                       #'button.edgeStyle'
                       #'checkToggle.activeImage'
                       #'checkToggle.passiveImage'
                       #'radioButton.activeImage'
                       #'radioButton.passiveImage'
                       #'selection.hilightForegroundColor'
                       #'selection.hilightBackgroundColor' 
                       #'selection.hilightFrameColor'
                       #'dataSet.labelView.foregroundColor'
                       #'dataSet.labelView.backgroundColor'
    )>

    DefaultForegroundColor        := StyleSheet colorAt:#'textForegroundColor' default:(Color black).
    "/ DefaultBackgroundColor        := StyleSheet colorAt:#'scrollableView.backgroundColor' default:DefaultViewBackgroundColor.
    DefaultBackgroundColor        := StyleSheet colorAt:#'selection.backgroundColor' default:DefaultViewBackgroundColor.

    DefaultHilightForegroundColor := StyleSheet colorAt:#'selection.hilightForegroundColor' default:DefaultBackgroundColor.
    DefaultHilightBackgroundColor := StyleSheet colorAt:#'selection.hilightBackgroundColor' default:DefaultForegroundColor.
    DefaultHilightForegroundColorNoFocus := StyleSheet colorAt:#'selection.hilightForegroundColorNoFocus'.
    DefaultHilightBackgroundColorNoFocus := StyleSheet colorAt:#'selection.hilightBackgroundColorNoFocus'.
    DefaultHilightFrameColor      := StyleSheet colorAt:#'selection.hilightFrameColor'. "/ no default; nil means: no frame

    DefaultHilightForegroundColor = DefaultHilightBackgroundColor ifTrue:[
        DefaultHilightBackgroundColor := Color black
    ].
    ButtonLightColor       := StyleSheet colorAt:#'button.lightColor'.
    ButtonShadowColor      := StyleSheet colorAt:#'button.shadowColor'.
    ButtonHalfLightColor   := StyleSheet colorAt:#'button.halfLightColor'.
    ButtonHalfShadowColor  := StyleSheet colorAt:#'button.halfShadowColor'.
    ButtonEdgeStyle        := StyleSheet at:#'button.edgeStyle'.

    CheckToggleActiveImage := StyleSheet at:#'checkToggle.activeImage'.
    CheckToggleActiveImage isNil ifTrue:[
        CheckTogglePassiveImage := nil
    ] ifFalse:[
        CheckTogglePassiveImage := StyleSheet at:#'checkToggle.passiveImage'.
        CheckTogglePassiveImage isNil ifTrue:[
            CheckToggleActiveImage := nil
        ]
    ].
    CheckToggleForm   := nil.
    CheckToggleLevel  := nil.
    CheckToggleExtent := nil.

    RadioButtonActiveImage := StyleSheet at:#'radioButton.activeImage'.
    RadioButtonPassiveImage := StyleSheet at:#'radioButton.passiveImage'.
    (RadioButtonActiveImage isNil or:[ RadioButtonPassiveImage isNil ]) ifTrue:[
        RadioButtonActiveImage := RadioButton roundOnForm.
        RadioButtonPassiveImage := RadioButton roundOffForm.
    ].

    ComboButtonForm   := nil.
    ComboButtonLevel  := nil.
    ComboButtonExtent := nil.

    DefaultLabelBackgroundColor := StyleSheet at:#'dataSet.labelView.backgroundColor' default:nil.
    DefaultLabelForegroundColor := StyleSheet at:#'dataSet.labelView.foregroundColor' default:nil.
    
    "
     self updateStyleCache.
    "

    "Modified: / 20-01-2011 / 08:44:28 / cg"
!

verticalSpacing
    "returns the default vertical space between rows
    "
    ^ 2

! !

!DSVColumnView class methodsFor:'image specs'!

dragIconMulti
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dragIconMulti inspect
     ImageEditor openOnClass:self andSelector:#dragIconMulti
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DSVColumnView dragIconMulti'
        ifAbsentPut:[(Depth1Image width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O?<0@C??L@@<@@@@O@@@@C3??L@<??3@OO?<<C3??O@<??0@OO?<@C3???0<???<OO???C3???0<???<OO???@C?
??0@???<@O???@C???0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 255 255 255]
            mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@O??<@C???@@???<@O???@C????@????0O????C????0?????O????3?????????????????????????????????????????????
????????@????0O???<C????@????0@@@@@@@@@@@@@@@@@@@@@b'); yourself); yourself]
!

dragIconSingle
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dragIconSingle inspect
     ImageEditor openOnClass:self andSelector:#dragIconSingle
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DSVColumnView dragIconSingle'
        ifAbsentPut:[(Depth1Image width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O?<0@C??L@@??30@O?<<@C??@@@??0@@O???@C???0@???<@O???@C???0@???<@O???@C???0@???<@O???@C??
?0@???<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 255 255 255]
            mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@O??<@C???@@???<@O???@C???<@????@O???<C????@????0O???<C????@????0O???<C????@????0O???<C????@????0O??
?<C????@????0O???<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b'); yourself); yourself]
!

rowSelectorImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rowSelectorImage inspect
     ImageEditor openOnClass:self andSelector:#rowSelectorImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'DSVColumnView class rowSelectorImage'
        ifAbsentPut:[
            (Depth2Image new)
                width:11;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@0@@@1@@?1P@@A4@EW=@G?? O?:@@C(@?2 @@2@@@0@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:11;
                            height:11;
                            bits:(ByteArray fromPackedString:'C@@N@@<@?8C?0O? ?<C? @<@C @L@@@a');
                            yourself);
                yourself
        ]
! !

!DSVColumnView class methodsFor:'signal constants'!

stopRedrawSignal
    "returns the signal which is raised during drawing if the
     required label height is less than the current rowHeight
    "
    StopRedrawSignal isNil ifTrue:[
        StopRedrawSignal := Notification newSignalMayProceed:true.
        StopRedrawSignal nameClass:self message:#stopRedrawSignal.
    ].
    ^ StopRedrawSignal
! !

!DSVColumnView methodsFor:'accessing'!

builder
    "get the builder (UIBuilder or nil)"
    
    ^ builder
!

builder:aBuilder 
    "set the builder (UIBuilder or nil)"
    
    builder := aBuilder
!

columnView
    "returns self"
    
    ^ self
!

heightOfContents
    "return the height of the contents in pixels"
    
    cachedPreferredExtent isNil ifTrue:[
        self preferredExtent
    ].
    ^ cachedPreferredExtent y
!

labelView

    ^labelView
!

labelView:aView
    labelView := aView for:self.

    labelView layout:(LayoutFrame
                        leftFraction:0 offset:0 
                        rightFraction:1 offset:0 
                        topFraction:0 offset:0 
                        bottomFraction:0 offset:[self preferredLabelViewHeight]).
!

level:aLevel 
    "change the level and thus the level of the labelView"
    
    aLevel ~~ level ifTrue:[
        super level:aLevel.
"/        labelView level:aLevel.
    ]
!

modifiedChannel
    ^ modifiedChannel

    "Created: / 30.1.2000 / 12:10:57 / cg"
!

modifiedChannel:something
    modifiedChannel := something.

    "Created: / 30.1.2000 / 12:10:57 / cg"
!

preferredLabelViewHeight
    ^ labelView preferredHeight "/ + (labelView margin + self verticalSpacing * 2).
!

rowFontAscent
    "returns the inset of a printable text in a row"
    
    ^ rowFontAscent
!

selectedColIndex:newSelectedColIndex
    self selectedColIndexHolder value:newSelectedColIndex
!

selectedColIndexHolder
    selectedColIndexHolder isNil ifTrue:[
        selectedColIndexHolder := ValueHolder new.
    ].
    ^ selectedColIndexHolder
! !

!DSVColumnView methodsFor:'accessing-actions'!

action:aOneArgAction 
    "set the action block to be performed on select"
    
    actionBlock := aOneArgAction
!

doubleClickAction:aOneArgAction 
    "set the action block to be performed on doubleclick"
    
    doubleClickActionBlock := aOneArgAction
!

rowIfAbsent:aOneArgAction 
    "set the action block to be performed on each 'nil' entry into the
     list. The argument to the block is the index into the list. The
     block returns the row which is put to the list"
    
    rowIfAbsentBlock := aOneArgAction
!

selectConditionBlock
    "get the select-conditionBlock; this block is evaluated before 
     any selection change is performed (passing the to-be-changed row number
     index as arg).
     The change will not be done, if the block returns false. "
    
    ^ selectConditionBlock
!

selectConditionBlock:aOneArgBlockOrNil 
    "set the select-conditionBlock; this block is evaluated before 
     any selection change is performed (passing the to-be-changed row number
     index as arg).
     The change will not be done, if the block returns false. "
    
    selectConditionBlock := aOneArgBlockOrNil.
!

tabAtEndAction:aNoneArgAction 
    "set the action, called without any argument at end of the list entering
     tab next.
     The default is to give the focus to the view after self in the focusSequence"
    
    tabAtEndAction := aNoneArgAction
!

tabAtStartAction:aNoneArgAction 
    "set the action, called without any argument at start of the list entering
     tab previous.
     The default is to give the focus to the view before self in the focusSequence"
    
    tabAtStartAction := aNoneArgAction
! !

!DSVColumnView methodsFor:'accessing-behavior'!

autoScrollToColumn
    "return true, if I scroll to the column, when one is selected."

    ^ autoScrollToColumn

    "Created: / 22-10-2006 / 11:01:25 / cg"
!

autoScrollToColumn:aBoolean
    "control, if I should scroll to the column, when one is selected.
     The default is true"

    autoScrollToColumn := aBoolean

    "Created: / 22-10-2006 / 11:01:46 / cg"
!

beDependentOfRows
    "make myself dependent of any row; in this case any change notification
     raised by a row is catched and the cell identified by the 'readSelector'
     is redrawn. In case of a nil readSelector, the whole raw is redrawn.
        -> row changed:'what'
     By default, the attribute is set to false (disabled)."
    
    ^ beDependentOfRows
!

beDependentOfRows:aBool 
    "make myself dependent of any row; in this case any change notification
     raised by a row is catched and the cell identified by the 'readSelector'
     is redrawn. In case of a nil readSelector, the whole raw is redrawn.
        -> row changed:'what'
     By default, the attribute is set to false (disabled)."
    
    aBool ~~ beDependentOfRows ifTrue:[
        beDependentOfRows := aBool.
        aBool ifTrue:[
            self makeDependentOfRows
        ] ifFalse:[
            self makeIndependentOfRows
        ].
    ]
!

enableChannel:aChannel
    enableChannel notNil ifTrue:[
        enableChannel removeDependent:self
    ].
    (enableChannel := aChannel) notNil ifTrue:[
        enableChannel addDependent:self
    ].
!

makeDependentOfRows 
    "make myself dependent of any row"
    
    list size ~~ 0 ifTrue:[
        list do:[:aRow | 
            aRow notNil ifTrue:[
                aRow addDependent:self
            ]
        ]
    ]
!

makeIndependentOfRows 
    "make myself independent of any row"
    
    list size ~~ 0 ifTrue:[
        list do:[:aRow | 
            aRow notNil ifTrue:[
                aRow removeDependent:self
            ]
        ]
    ]
!

multipleSelectOk
    "allow/disallow multiple row selections; the default is false"
    
    ^ multipleSelectOk
!

multipleSelectOk:aState 
    "allow/disallow multiple row selections; the default is false"

    |colIdx rowIdx|

    aState == multipleSelectOk ifTrue:[^ self ].
    colIdx := rowIdx := 0.

    self hasSelection ifTrue:[
        colIdx := self selectedColIndex.
        rowIdx := self selectedRowIndex.

        rowIdx isSequenceable ifTrue:[
            rowIdx := rowIdx at:1 ifAbsent:0
        ].
        self setSelectColIndex:0 rowIndex:0 openEditor:false.
    ].
    multipleSelectOk := aState.
    self selectColIndex:colIdx rowIndex:rowIdx openEditor:false.
!

opaqueColumnResize
    ^ labelView opaqueColumnResize
!

opaqueColumnResize:aBoolean
    labelView opaqueColumnResize:aBoolean
!

scrollWhenUpdating
    "return the scroll behavior, when I get a new text 
     (via the model or the #contents/#list)
     Possible returnValues are:
        #keep / nil     -> no change
        #endOfText      -> scroll to the end
        #beginOfText    -> scroll to the top
     The default is #beginOfText.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    ^ scrollWhenUpdating
!

scrollWhenUpdating:aSymbolOrNil
    "define how to scroll, when I get a new text 
     (via the model or the #contents/#list)
     Allowed arguments are:
        #keep / nil     -> no change
        #endOfText      -> scroll to the end
        #beginOfText    -> scroll to the top
     The default is #beginOfText.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    scrollWhenUpdating := aSymbolOrNil
!

selectRowOnDefault
    "if true, in case of selecting a none selectable cell, the row is selected.
     If false, nothing is selected. The default is true."
    
    ^ selectRowOnDefault
!

selectRowOnDefault:aBool 
    "if true, in case of selecting a none selectable cell, the row is selected.
     If false, nothing is selected. The default is true."
    
    selectRowOnDefault := aBool
!

sortListInPlace
    "when false (default for backward compatibility): 
     if sorting, create a copy
     of the list, which is wrong when useIndex is on,
     as the application will get the index in the sorted
     list, which is probably different from tha apps list mode.
     When true (should be default, but that might break many
     users), the passed in list is sorted in place (i.e. possibly
     sorting the application's list)."
     
    ^ sortListInPlace
!

sortListInPlace:aBoolean
    "when false (default for backward compatibility): 
     if sorting, create a copy
     of the list, which is wrong when useIndex is on,
     as the application will get the index in the sorted
     list, which is probably different from tha apps list mode.
     When true (should be default, but that might break many
     users), the passed in list is sorted in place (i.e. possibly
     sorting the application's list)."
     
    sortListInPlace := aBoolean.
!

tabIntern
    "returns true if tabing is supported in the widget"
    
    ^ tabIntern
!

tabIntern:aBool 
    "returns true if tabing is supported in the widget"
    
    tabIntern := aBool ? true
!

updateListHolderWhenSorting
    "return true if the the listHolder's value are be updated,
     when I sort a list.
     By default, this is false so it must be set explicitly
     (for bug-backward compatibility,
     and to avoid introducing new side effects)."

    ^ updateListHolderWhenSorting 
!

updateListHolderWhenSorting:aBoolean
    "define if the the listHolder's value should be updated,
     when I sort a list.
     By default, this is false so it must be set explicitly
     (for bug-backward compatibility,
     and to avoid introducing new side effects)."

    updateListHolderWhenSorting := aBoolean
!

useIndex
    "specify, if the selected components value or its index in the
     list should be sent to the model. The default is its index."
    
    ^ useIndex
!

useIndex:aBool 
    "specify, if the selected components value or its index in the
     list should be sent to the model. The default is its index."
    
    useIndex := aBool
! !

!DSVColumnView methodsFor:'accessing-colors'!

backgroundColor
    "get the background color of the rows"
    
    ^ bgColor
!

backgroundColor:aColor 
    "set the background color of the rows"
    
    bgColor ~~ aColor ifTrue:[
        super viewBackground:bgColor.
        self realized ifTrue:[
            bgColor := aColor onDevice:device.
            self invalidate
        ] ifFalse:[
            bgColor := aColor
        ]
    ]
!

foregroundColor
    "return the foreground color of the rows"
    
    ^ fgColor
!

foregroundColor:aColor 
    "set the foreground color of the rows"
    
    fgColor ~~ aColor ifTrue:[
        self realized ifTrue:[
            fgColor := aColor onDevice:device.
            self invalidate
        ] ifFalse:[
            fgColor := aColor
        ]
    ]
!

labelBackgroundColor
    "get the background color of the label row"
    
    ^ labelBgColor ? bgColor
!

labelForegroundColor
    "get the foreground color of the label row"
    
    ^ labelFgColor ? fgColor
!

selectionBackgroundColor
    "returns the background color of a selected row"
    
    self hasFocus ifTrue:[
        ^ selectionBackgroundColor
    ].
    ^ selectionBackgroundColorNoFocus.
!

selectionForegroundColor
    "returns the foreground color of a selected row"

    self hasFocus ifTrue:[
        ^ selectionForegroundColor
    ].
    ^ selectionForegroundColorNoFocus.
!

selectionFrameColor
    "returns the frame color of a selected row"

    self hasFocus ifTrue:[
        ^ selectionFrameColor
    ].
    ^ selectionFrameColorNoFocus.

    "Created: / 20-01-2011 / 08:45:08 / cg"
!

separatorDarkColor
    "returns the dark color used for drawing a shadowed separator (3D)"
    
    ^ shadowColor
!

separatorLightColor
    "returns the light color used for drawing a shadowed separator (3D)"
    
    ^ lightColor
!

separatorOneDColor
    "returns the color used for drawing a oneD separator"
    
    separatorOneDColor isNil ifTrue:[
        ^ fgColor
    ].
    ^ separatorOneDColor
!

separatorOneDColor:aColorOrNil 
    "set the color used for drawing a oneD separator; if the color
     is nil, the current forgroundColor is used"
    
    separatorOneDColor = aColorOrNil ifTrue:[
        ^ self
    ].
    separatorOneDColor := aColorOrNil.
    self realized ifTrue:[
        separatorOneDColor notNil ifTrue:[
            separatorOneDColor := separatorOneDColor onDevice:device.
        ].
        self invalidate.
    ].
! !

!DSVColumnView methodsFor:'accessing-columns'!

columnAt:anIndex
    <resource: #obsolete>
 
    "returns the column at an index"

    self obsoleteMethodWarning:'use columnDescriptorAt:'.
    ^ self columnDescriptorAt:anIndex
!

columnDescriptorAt:anIndex 
    "returns the columnDescriptor at an index"
    
    ^ columnDescriptors at:anIndex ifAbsent:nil
!

columnDescriptors
    "returns list of column descriptors"
    
    ^ columnDescriptors collect:[:aCol | aCol description ]
!

columnDescriptors:aColumnDescriptionList 
    "set the columnDescriptors; scroll to top and deselect"
    
    |delta|

    self deselect.
    (viewOrigin x ~~ 0 or:[ viewOrigin y ~~ 0 ]) ifTrue:[
        delta := viewOrigin negated.
        viewOrigin := 0 @ 0.
        self originChanged:delta
    ].
    self setColumnDescriptors:aColumnDescriptionList
!

dataSetColumns
    "returns the list of DataSetColumns; each column represents a DataSetColumnSpec"
    
    ^ columnDescriptors
!

firstColumn
    "returns the first column"
    
    ^ columnDescriptors at:1
!

lastColumn
    "returns the last column"
    
    ^ columnDescriptors last
!

setColumnDescriptors:aColumnDescriptionList
    "set the columnDescriptors; don't deselect and do not scroll to top"
    |cid|

    cid := 0.

    aColumnDescriptionList isEmptyOrNil ifTrue:[
        columnDescriptors := OrderedCollection new.
    ] ifFalse:[
        columnDescriptors := aColumnDescriptionList 
            collect:
                [:el||dsc lbl|
                    dsc := el isSequenceable 
                                ifTrue:[DataSetColumnSpec decodeFromLiteralArray:el]
                                ifFalse:[el].
                    cid := cid + 1.
                    lbl := DataSetLabel new description:dsc builder:builder on:labelView.
                    DataSetColumn new on:self description:dsc columnNumber:cid label:lbl
                ].
    ].

    cachedPreferredExtent := nil.
    labelView columns:columnDescriptors.

    self fitColumns.

    "Modified: / 07-01-2012 / 16:46:59 / cg"
! !

!DSVColumnView methodsFor:'accessing-interactors'!

checkToggleActiveImage
    ^ checkToggleActiveImage
!

checkToggleExtent
    "returns the extent of a checkToggle"
    
    ^ checkToggleExtent
!

checkToggleForm
    "returns the form of a checkToggle"
    
    ^ checkToggleForm
!

checkToggleLevel
    "returns the level of a checkToggle button"
    
    ^ checkToggleLevel
!

checkTogglePassiveImage
    ^ checkTogglePassiveImage
!

comboButtonExtent
    "returns the extent of a comboList or -Box"
    
    ^ comboButtonExtent
!

comboButtonForm
    "returns the form of a comboList or -Box"
    
    ^ comboButtonForm
!

comboButtonLevel
    "returns the level of a comboList or -Box button"
    
    ^ comboButtonLevel
!

radioButtonExtent
    "returns the extent of a radio button"
    
    ^ radioButtonActiveImage extent
!

rowSelectorExtent
    "returns the bitmap of a selected row"
    
    ^ rowSelectorForm extent
!

rowSelectorForm
    "returns the (arrow-) image shown for a selected row.
     (the arrow shown in the first column)"
    
    ^ rowSelectorForm
! !

!DSVColumnView methodsFor:'accessing-mvc'!

columnAdaptor
    "return the value of the instance variable 'columnAdaptor' (automatically generated)"
    
    columnAdaptor isValueModel ifTrue:[
        ^ columnAdaptor value
    ].
    ^ columnAdaptor
!

columnAdaptor:something
    "set the value of the instance variable 'columnAdaptor' (automatically generated)"

    columnAdaptor isValueModel ifTrue:[
        columnAdaptor removeDependent:self
    ].
    (columnAdaptor := something) isValueModel ifTrue:[
        columnAdaptor addDependent:self
    ].
!

columnHolder
    "get the valueHolder, which keeps the list of column descriptions"
    
    ^ columnHolder
!

columnHolder:aValueHolder 
    "set the valueHolder, which keeps the list of column descriptions"
    
    |columns|

    columnHolder notNil ifTrue:[
        columnHolder removeDependent:self
    ].
    (columnHolder := aValueHolder) notNil ifTrue:[
        columnHolder addDependent:self.
        columns := columnHolder value.
        columns notNil ifTrue:[
            self columnDescriptors:columns
        ]
    ].
!

listAt:index put:newElement 
    "kludge callback, when an element hs to be replaced
     due to a col-adaptor returning a new row element"
    
    |list|

    (list := listHolder value) notNil ifTrue:[
        list at:index put:newElement
    ]
!

listHolder
    "get the valueHolder which holds the list of rows"
    
    ^ listHolder
!

listHolder:aListHolder 
    "set the valueHolder which holds the list of rows"
    
    listHolder ~~ aListHolder ifTrue:[
        listHolder notNil ifTrue:[
            listHolder removeDependent:self
        ].
        (listHolder := aListHolder) notNil ifTrue:[
            listHolder addDependent:self
        ]
    ].
    self pushEvent:#list: with:(listHolder value).
!

model:aModel 
    "set the valueHolder which holds the selection and maybe the list of rows"
    
    model notNil ifTrue:[
        model removeDependent:self.
        (model respondsTo:#list) ifTrue:[
            (model list == listHolder) ifTrue:[
                self listHolder:nil
            ]
        ]
    ].
    (model := aModel) notNil ifTrue:[
        model addDependent:self.
        (aModel respondsTo:#list) ifTrue:[
            self listHolder:model list
        ]
    ]
! !

!DSVColumnView methodsFor:'accessing-rows'!

at:aRowNr
    "return the row at an index, aRowNr"

    |row|

    list isNil ifTrue:[^ nil].
    (row := list at:aRowNr ifAbsent:nil) isNil ifTrue:[
        lockRowIndex := aRowNr.

        (rowIfAbsentBlock notNil
        and:[(row := rowIfAbsentBlock value:aRowNr) notNil]) ifTrue:[
            list at:aRowNr put:row.
            beDependentOfRows ifTrue:[row addDependent:self].
        ].

        lockRowIndex := 0
    ].
    ^ row

    "Modified: / 22-01-2011 / 09:14:48 / cg"
!

at:aRowNr ifAbsent:exceptionBlock 
    "return the row at a aRowNr. If the index is invalid, return the
     result of evaluating the exceptionblock"
    
    (aRowNr between:1 and:list size) ifTrue:[
        ^ self at:aRowNr
    ].
    ^ exceptionBlock value
!

at:aRowNr put:aRow 
    "change the row at an index. The added row is returned"
    
    lockRowIndex ~~ aRowNr ifTrue:[
        (aRowNr <= list size and:[ (list at:aRowNr) == aRow ]) ifTrue:[
            self invalidateRowAt:aRowNr
        ] ifFalse:[
            self 
                replaceFrom:aRowNr
                to:aRowNr
                with:(Array with:aRow)
                startingAt:1.
        ]
    ].
    ^ aRow
!

first
    "return the first row"
    
    ^ self at:1
!

identityIndexOfRow:aRow 
    "returns index of a row or 0"
    
    (list size ~~ 0 and:[ aRow notNil ]) ifTrue:[
        ^ list identityIndexOf:aRow
    ].
    ^ 0
!

last
    "return the last row"
    
    ^ self at:(list size)
!

list
    "get the list of rows"
    
    ^ list
!

list:aRawList
    "set the list of rows"

    |newList selectionHasChanged sortColNr sortSelectorOrBlock sortBlockSelector sortBlock|

    "/ remove selection without redraw

    selectionHasChanged := self hasSelection.

    self destroyEditView.

    self selectedColIndex:0.
    selectedRowIndex := multipleSelectOk ifTrue:[nil] ifFalse:[0].

    shown ifFalse:[
        cachedPreferredExtent := nil
    ] ifTrue:[
        aRawList size == 0 ifTrue:[  
            "/ keep old column-width information
        ] ifFalse:[
            columnDescriptors notNil ifTrue:[
                columnDescriptors do:[:aCol| aCol invalidate ].
            ].
            cachedPreferredExtent := nil.
        ]
    ].

    beDependentOfRows ifTrue:[
        self makeIndependentOfRows
    ].

    aRawList size == 0 ifTrue:[
        list := nil.
        viewOrigin := 0 @ 0.
    ] ifFalse:[
        "/ list := OrderedCollection withAll:aRawList.
        sortListInPlace ifTrue:[
            newList := aRawList
        ] ifFalse:[
            newList := aRawList copyAsOrderedCollection.
        ].
        (sortColNr := labelView indexOfSortColumn) notNil ifTrue:[
            sortBlockSelector := (columnDescriptors at:sortColNr) sortBlockSelector.
            sortBlockSelector notNil ifTrue:[
                sortBlock := self application aspectFor:sortBlockSelector.
                newList sort:sortBlock
            ] ifFalse:[
                sortSelectorOrBlock := (columnDescriptors at:sortColNr) sortSelector.
                sortSelectorOrBlock notNil ifTrue:[
                    sortSelectorOrBlock isBlock ifTrue:[
                        newList sort:sortSelectorOrBlock
                    ] ifFalse:[
                        newList sort:[:a :b | (a perform:sortSelectorOrBlock) < (b perform:sortSelectorOrBlock)]
                    ].
                ].
            ].
            labelView reverseSort ifTrue:[
                newList reverse.
            ].
        ].
        list := newList.
        
        sortListInPlace ifFalse:[
            listHolder notNil ifTrue:[
                updateListHolderWhenSorting ifTrue:[
                    listHolder value:newList withoutNotifying:self.
                ].
            ].
        ].
        
        beDependentOfRows ifTrue:[
            self makeDependentOfRows
        ].
    ].

    shown ifTrue:[
        self fitColumns
    ] ifFalse:[
        needFitColumns := true
    ].
    selectionHasChanged ifTrue:[
        self selectionChanged.
    ].
    cachedPreferredExtent := nil.
    self contentsChanged.

    "Modified: / 08-11-2010 / 22:07:49 / cg"
! !

!DSVColumnView methodsFor:'accessing-visibility'!

font:aFont 
    "set the font for all shown rows."
    
    (aFont notNil and:[ aFont ~~ self font ]) ifTrue:[
        super font:aFont.
        rowFontAscent := gc font ascent.
        realized ifTrue:[
            columnDescriptors do:[:aCol | 
                aCol invalidate
            ].
            self preferredExtentChanged.
            self invalidate.
            self contentsChanged
        ].
        labelView notNil ifTrue:[
            labelView font:gc font
        ].
    ]
!

has3Dseparators
    "returns true if shown in 3D mode"
    
    ^ separatorSize ~~ 1
!

has3Dseparators:aBool 
    "enable or disable 3D mode"
    
    |newSepSize|

    newSepSize := aBool ifTrue:[2] ifFalse:[1].
    newSepSize ~~ separatorSize ifTrue:[
        separatorSize := newSepSize.
        realized ifTrue:[
            columnDescriptors do:[:aCol | 
                aCol invalidate
            ].
            self preferredExtentChanged.
            self invalidate.
            self contentsChanged
        ]
    ]
!

horizontalSpacing
    "horizontal spacing used by columns"
    
    ^ horizontalSpacing
!

horizontalSpacing:aNumber 
    "horizontal spacing used by columns"
    
    horizontalSpacing ~~ aNumber ifTrue:[
        horizontalSpacing := aNumber.
        self preferredExtentChanged.
    ].
!

showLabels
    "control the labels view to be visible or unvisible"
    
    ^ labelView isVisible
!

showLabels:aState 
    "control the labels view to be visible or unvisible"
    
    labelView isVisible:aState
!

verticalSpacing
    "vertical spacing used by columns"
    
    ^ verticalSpacing
!

verticalSpacing:aNumber 
    "vertical spacing used by columns"
    
    verticalSpacing ~~ aNumber ifTrue:[
        verticalSpacing := aNumber.
        self preferredExtentChanged.
    ].
! !

!DSVColumnView methodsFor:'adding & removing rows'!

add:aRow 
    "insert row at end"
    
    ^ self add:aRow beforeIndex:(1 + list size)
!

add:aRow afterIndex:aRowNr 
    "add a new row after slot aRowNr and redisplay; returns nil in case
     of an invalid index or the row"
    
    ^ self add:aRow beforeIndex:(aRowNr + 1)
!

add:aRow beforeIndex:aRowNr 
    "add a new row before slot aRowNr and redisplay; returns nil in case
     of an invalid index or the row"
    
    self addAll:(Array with:aRow) beforeIndex:aRowNr.
    ^ aRow.
!

addAll:aList beforeIndex:start
    "add a collection of rows before slot start and redisplay"

    |y0 y1 yD h dH size noSel|

    (size := aList size) == 0 ifTrue:[
        ^ self
    ].

    beDependentOfRows ifTrue:[
        aList do:[:aRow| aRow notNil ifTrue:[aRow addDependent:self]]
    ].

    list isNil ifTrue:[
        self list:aList.
    ] ifFalse:[
        noSel := self numberOfSelections.

        noSel ~~ 0 ifTrue:[
            multipleSelectOk ifFalse:[
                selectedRowIndex >= start ifTrue:[
                    selectedRowIndex := selectedRowIndex + size
                ]
            ] ifTrue:[
                1 to:noSel do:[:i||v|
                    (v := selectedRowIndex at:i) >= start ifTrue:[
                        selectedRowIndex at:i put:(v + size)
                    ]
                ]
            ]
        ].
        list addAll:aList beforeIndex:start.
    ].

    self recomputeHeightOfContents.

    y0 := (start - 1) * rowHeight.
    yD := size * rowHeight.
    y1 := y0 + yD.

    y0 < viewOrigin y ifTrue:[
        self originWillChange.
        viewOrigin := viewOrigin x @ (yD + viewOrigin y).
        "/ viewOrigin y:(yD + viewOrigin y).
        self originChanged:(0 @ yD).
    ].

    (shown not or:[self sensor hasDamageFor:self]) ifTrue:[
        self invalidate.
        self contentsChanged.
        ^ self
    ].

    y0 := self yVisibleOfRowNr:start.
    h  := height - margin.
    y1 := y0 + yD min:h.

    (y1 > margin and:[y0 < h]) ifTrue:[
        "/ cg: if I have a non-solid background color,
        "/ or individual items have a bgColor selector,
        "/ invalidate the area (and readraw) instead of a scroll.
        (viewBackground isImageOrForm 
        or:[ self anyColumnHasPotentialNonConstantBackground ])
        ifTrue:[
            "/ do not scroll but invalidate ...
            self invalidateX:margin y:y0 width:width - margin - margin height:(height - y0).
        ] ifFalse:[
            h  := h - y1.
            y0 := y0 max:margin.
            dH := y1 - y0.

            start == list size ifFalse:[
                self copyFrom:self x:0 y:y0 toX:0 y:y1 width:width height:h async:false
            ].
            self invalidateX:margin y:y0 width:width - margin - margin height:dH.
        ]
    ].

    self contentsChanged.

    (scrollWhenUpdating == #end or:[scrollWhenUpdating == #endOfText]) ifTrue:[
        self scrollToBottom.
    ].
!

addFirst:aRow 
    "insert a row at start"
    
    ^ self add:aRow beforeIndex:1
!

remove:aRow 
    "remove a row"
    
    |idx|

    idx := list identityIndexOf:aRow.
    idx ~~ 0 ifTrue:[
        self removeFrom:idx to:idx.
    ].
    ^ aRow
!

removeFirst
    "remove first row; returns the removed row"
    
    ^ self removeIndex:1
!

removeFrom:startIndex to:stopIndex
    "remove rows from start to stop"

    |coll noRedraw
     noSel "{ Class: SmallInteger }"
     size  "{ Class: SmallInteger }"
     start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"
     y0    "{ Class: SmallInteger }"
     y1    "{ Class: SmallInteger }"
     oY    "{ Class: SmallInteger }"
     dY    "{ Class: SmallInteger }"
     yB    "{ Class: SmallInteger }"
     h     "{ Class: SmallInteger }"
    |

    (    (start := startIndex) < 1
     or:[(stop := stopIndex) > list size]
    ) ifTrue:[
        ^ self subscriptBoundsError:start
    ].
    size := stop - start + 1.

    beDependentOfRows ifTrue:[
        list from:start to:stop do:[:r| r notNil ifTrue:[r removeDependent:self]].
    ].
    noSel := self numberOfSelections.

    noSel ~~ 0 ifTrue:[
        noSel == 1 ifTrue:[
            noSel := self firstIndexSelected.

            noSel < start ifFalse:[
                noSel > stop ifTrue:[
                    noSel := noSel - size.

                    multipleSelectOk ifFalse:[selectedRowIndex := noSel]
                                      ifTrue:[selectedRowIndex at:1 put:noSel]
                ] ifFalse:[
                    editValue notNil ifTrue:[
                        editValue removeDependent:self.
                        editValue := nil.
                    ].
                    self deselect.
                ]
            ]
        ] ifFalse:[
            coll := OrderedCollection new:noSel.

            selectedRowIndex do:[:i|
                i < start ifTrue:[
                    coll add:i
                ] ifFalse:[
                    i > stop ifTrue:[
                        coll add:(i - size)
                    ]
                ]
            ].
            coll size == 0 ifTrue:[
                self deselect
            ] ifFalse:[
                selectedRowIndex := coll
            ]
        ]
    ].
    list removeFrom:start to:stop.

    y0 := (start - 1) * rowHeight.
    dY := size * rowHeight.
    y1 := dY + y0.
    yB := y1 + margin - viewOrigin y.
    self recomputeHeightOfContents.

    y0 < (oY := viewOrigin y) ifTrue:[
        (noRedraw := y1 <= oY) ifFalse:[dY := y0 - oY]
                                ifTrue:[dY := dY negated].
        self originWillChange.
        viewOrigin := viewOrigin x @ (dY + oY).
        "/ viewOrigin y:(dY + oY).
        self originChanged:(0 @ dY).        
    ] ifFalse:[
        noRedraw := y0 > (height + viewOrigin y)
    ].

    (shown not or:[self sensor hasDamageFor:self]) ifTrue:[
          self invalidate.
        ^ self contentsChanged.
    ].

    (noRedraw or:[shown not]) ifFalse:[
        y0 := self yVisibleOfRowNr:start.
        y0 := y0 max:margin.

        "/ cg: if I have a non-solid background color,
        "/ or individual items have a bgColor selector,
        "/ invalidate the area (and readraw) instead of a scroll.
        (viewBackground isImageOrForm 
        or:[ self anyColumnHasPotentialNonConstantBackground ])
        ifTrue:[
            "/ do not scroll but invalidate ...
        ] ifFalse:[
            y1 := yB.
            h  := height - margin - yB.

            h > 0 ifTrue:[
                self copyFrom:self x:0 y:yB toX:0 y:y0 width:width height:h async:false
            ].
            y0 := y0 + h.
        ].
        self invalidateX:margin y:y0 width:width - margin - margin height:(height - y0).
    ].
    self contentsChanged.
!

removeIndex:aRowNr 
    "remove row at an index; returns the removed row"
    
    |row|

    row := list at:aRowNr ifAbsent:nil.
    self removeFrom:aRowNr to:aRowNr.
    ^ row
!

removeLast
    "remove last row; the row is returned"
    
    ^ self removeIndex:(list size)
!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "replace elements in the receiver between index start and stop,
     with elements  taken from replacementCollection starting at repStart.
     Return the receiver."

    |inSelList listSize repStop run|

    inSelList := OrderedCollection new.
    listSize  := list size.
    repStop   := repStart + (stop - start).

    list isNil ifTrue:[
        list := OrderedCollection new
    ].

    [listSize < stop] whileTrue:[ list add:nil. listSize := listSize + 1 ].

    start to:stop do:[:i| |aRow|
        aRow := list at:i ifAbsent:nil.
    
        aRow notNil ifTrue:[
            beDependentOfRows ifTrue:[aRow removeDependent:self].

            (self isInSelection:i) ifTrue:[
                inSelList add:i
            ].
            list at:i put:nil.
        ]
    ].

    beDependentOfRows ifTrue:[
        aCollection from:repStart to:repStop do:[:aRow|
            aRow notNil ifTrue:[aRow addDependent:self]
        ]
    ].

    run := start.
    aCollection from:repStart to:repStop do:[:aRow|
        list at:run put:aRow.
        run := run + 1.
    ].
    self invalidateRowsFrom:start to:stop.

    inSelList size ~~ 0 ifTrue:[
        self numberOfSelections == inSelList size ifTrue:[
            self deselect
        ] ifFalse:[
            selectedRowIndex := selectedRowIndex select:[:i| (inSelList identityIndexOf:i) == 0 ].
            self selectionChanged.
        ]
    ].
! !

!DSVColumnView methodsFor:'change & update'!

changeWidthOfColumn:aColumn deltaX:aDeltaX

    aColumn setDescWidth:(aColumn width + aDeltaX).
    cachedPreferredExtent notNil ifTrue:[self fitColumns]
!

update:what with:aPara from:chgObj 
    "one of my rows/cells changed its value"
    
    |row listHoldersList arg1 arg2 col|

    chgObj == columnHolder ifTrue:[
        cachedPreferredExtent := nil.
        self columnDescriptors:(columnHolder value). 
        ^ self. 
    ].
    chgObj == columnAdaptor ifTrue:[
        col := columnAdaptor value.
        columnDescriptors do:[:aCol | 
            aCol columnAdaptor:col
        ].
        self invalidate.
        ^ self
    ].
    chgObj == editValue ifTrue:[
        self updateColumnFromEditValue.
        ^ self
    ].

    chgObj == model ifTrue:[
        (what == #selectionIndex or:[ what == #selection ]) ifTrue:[
            self selectRowIndex:(model selectionIndex copy). 
            ^ self. 
        ].
        what == #list ifTrue:[
            cachedPreferredExtent := nil.
            self listHolder:model list. 
            ^ self. 
        ].
        what == #value ifTrue:[
            model == listHolder ifTrue:[
                cachedPreferredExtent := nil.
                self list:(listHolder value)
            ] ifFalse:[
                self selectRowIndex:model value
            ].
            ^ self
        ].
        ^ self
    ].

    (chgObj == listHolder) ifTrue:[
        cachedPreferredExtent := nil.
        listHoldersList := listHolder value.

        what == #value ifTrue:[
            self list:listHoldersList.  
            ^ self. 
        ].
        aPara isCollection ifTrue:[
            arg1 := aPara at:1.
            arg2 := aPara at:2.
        ] ifFalse:[
            arg1 := arg2 := aPara
        ].
        what == #at: ifTrue:[
            self at:arg1 put:(listHoldersList at:arg1). 
            ^ self.
        ].
        what == #insert: ifTrue:[
            self add:(listHoldersList at:arg1) beforeIndex:arg1. 
            ^ self.
        ].
        what == #remove: ifTrue:[
            self removeFrom:arg1 to:arg1. 
            ^ self.
        ].
        what == #removeFrom: ifTrue:[
            listHoldersList size == 0 ifTrue:[
                self list:nil
            ] ifFalse:[
                self removeFrom:arg1 to:arg2
            ].
            ^ self
        ].
        what == #insertCollection: ifTrue:[
            arg2 ~~ 0 ifTrue:[
                self addAll:(listHoldersList copyFrom:arg1 to:(arg1 + arg2 - 1))
                    beforeIndex:arg1
            ].
            ^ self.
        ].
        what == #replace: ifTrue:[
            self 
                replaceFrom:arg1 to:arg2
                with:listHoldersList startingAt:arg1.
            ^ self
        ].
        self list:listHoldersList.
        ^ self
    ].

    arg1 := aPara ? what.
    row := (what isNumber) ifTrue:[what] ifFalse:[chgObj].
    self invalidateVisibleRow:row readSelector:arg1.
    editView notNil ifTrue:[
        (self isInSelection:(self identityIndexOfRow:row)) ifTrue:[
            self updateEditorFromChangedRow
        ]
    ].

    "Modified: / 30.1.2000 / 12:16:49 / cg"
!

updateColumnFromEditValue
    |editValueBefore firstSelectedIndex newValue realValue col|

    editValueBefore := editValue.

    firstSelectedIndex := self firstIndexSelected.
    newValue := editValue value.

    col := self selectedColumn.
    col at:firstSelectedIndex put:newValue.

    col editorType == #RadioButton ifTrue:[
        "/ turn off the other column

        1 to:list size do:[:rowNr |
            rowNr ~~ firstSelectedIndex ifTrue:[
                (col at:rowNr) ~~ false ifTrue:[
                    col at:rowNr put:false.
                    self invalidateRowAt:rowNr colAt:col columnNumber.
                ].
            ]
        ]
    ].

    realValue := col at:firstSelectedIndex.
    (realValue ~= newValue) ifTrue:[
        "/ some validation by the row-object; the stored value
        "/ is different from what I think.
        "/ update my input fields modelValue

        "/ just in case someone nilled or changed the editValue
        "/ Q: is this CA's paranoia or could this really be done in the at:put: above ???
        "/ A (sv): it me happen, if the set method specified in the column descriptor did not set the
        "/         model.
        (editValueBefore == editValue) ifTrue:[ 
            editValue value:realValue withoutNotifying:self.
        ].
    ].

    modifiedChannel notNil ifTrue:[
        modifiedChannel value:true.
    ].


!

updateEditorFromChangedRow
    |rowsValue rowNr|

    (rowNr := selectedRowIndex) isNumber ifFalse:[
        rowNr := rowNr first.
    ].
    rowsValue := (self columnDescriptorAt:self selectedColIndex) at:rowNr.
    (editValue notNil and:[ editValue value ~= rowsValue ]) ifTrue:[
        editValue value:rowsValue withoutNotifying:self.
        editView 
            withAllSubViewsDo:[:v | 
                v isInputField ifTrue:[
                    v flash.
                ]
            ]
    ].
!

updateList
    listHolder notNil ifTrue:[
        self list:listHolder value.
        ^ self
    ].
    model notNil ifTrue:[
        self list:model value.
        ^ self
    ].
! !

!DSVColumnView methodsFor:'drag & drop'!

canDrag
    "returns true if dragging is enabled"
    
    ^ dropSource notNil
!

canStartDragAt:aPoint clickedAt:clickPoint
    self canDrag ifFalse:[
        ^ false
    ].
    ^ (aPoint dist:clickPoint) > (UserPreferences current motionDistanceToStartDrag)
!

dragAutoScroll:aContext
    "called by the DragAndDropManager to scroll during a drag/drop operation
     if necassery (decided by the widget itself); If a scroll is done return
     true otherwise false (used to restore the background)"

    |yInset absLnNr y|

    y := aContext targetPoint y.
    yInset := margin + rowHeight.
    y > yInset ifTrue:[
        y >= (height - yInset) ifFalse:[^ false].
    ].

    absLnNr := self yVisibleToRowNr:y.
    absLnNr isNil ifTrue:[^ false].

    (absLnNr > 1 and:[absLnNr < self size]) ifFalse:[
        ^ false
    ].
    aContext contentsWillChange.

    y > yInset 
        ifTrue:[self scrollDown:rowHeight]
        ifFalse:[self scrollUp:rowHeight].

    ^ true
!

dropSource
    "returns the dropSource or nil"
    
    ^ dropSource
!

dropSource:aDropSourceOrNil 
    "set the dropSource or nil"
    
    dropSource := aDropSourceOrNil.
!

startDragAt:aPoint

    dropSource notNil ifTrue:[
        buttonReleaseAction := buttonMotionAction := nil.
        dropSource startDragIn:self at:aPoint.
    ]
! !

!DSVColumnView methodsFor:'drawing'!

colorOnDevice:aColor 
    "returns color on device"
    
    |col|

    aColor = Color noColor ifFalse:[
        col := colorMap at:aColor ifAbsent:nil.
        col isNil ifTrue:[
            colorMap at:aColor put:(col := aColor onDevice:device)
        ].
        ^ col
    ].
    ^ bgColor
!

forceRedraw
    "a redraw forced by any other component"
    
    shown ifTrue:[
        self invalidate
    ]
!

invalidate
    "recompute extent before repair range"
    
    self recomputeHeightOfContents.
    super invalidate.
!

invalidateRowAt:aRowNr 
    "redraw total row at an index"
    
    self invalidateRowAt:aRowNr colAt:0
!

invalidateRowAt:aRowNr colAt:aColNr
    "redraw either a single column in a row,
     or the complete visible row (in case of aColNr == 0).
     If the row/column is hidden, no redraw is done"

    |x "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"
     h "{ Class:SmallInteger }"
     w "{ Class:SmallInteger }"
     col|

    (shown and:[aRowNr notNil and:[aRowNr between:1 and:list size]]) ifTrue:[
        h := rowHeight.
        y := self yVisibleOfRowNr:aRowNr.

        y < margin ifTrue:[
            (h := h + y) <= margin ifTrue:[
                ^ self
            ].                                                  "/ row not visible
            h := h - margin.
            y := margin.
        ] ifFalse:[
            y >= height ifTrue:[^ self].
        ].
        aColNr ~~ 0 ifTrue:[                                    "/ redraw column in row
            col := (self columnDescriptorAt:aColNr).
            w := col isNil ifTrue:[0] ifFalse:[col width].
            x := self xVisibleOfColNr:aColNr.

            x < margin ifTrue:[
                (w := w + x) <= margin ifTrue:[
                    ^ self
                ].                                              "/ column not visible
                w := w - margin.
                x := margin.
            ] ifFalse:[
                x >= width ifTrue:[^ self].
            ]
        ] ifFalse:[                                             "/ redraw whole row
            x := margin.
            w := width.
        ].
        self invalidateX:x y:y width:w height:h
    ]
!

invalidateRows:aCollection
    "redraw some visible rows"

    shown ifTrue:[
        aCollection do:[:rowIndex |
            self invalidateRowAt:rowIndex
        ]
    ]
!

invalidateRowsFrom:aStart to:aStop
    "redraw visible row from start to stop"

    |size start stop y0 y1|

    shown ifTrue:[
        size  := list size.
        start := aStart notNil ifTrue:[aStart max:1]    ifFalse:[1].
        stop  := aStop  notNil ifTrue:[aStop  min:size] ifFalse:[size].

        start <= stop ifTrue:[
            y0 := (self yVisibleOfRowNr:start)              max:margin.
            y1 := ((self yVisibleOfRowNr:stop) + rowHeight) min:height.

            y0 < y1 ifTrue:[
                self invalidateX:margin y:y0 width:width height:(y1 - y0)
            ]
        ]
    ]
!

invalidateSelection
    "invalidate (force async redraw) the current selection"

    |colIndex|

    shown ifTrue:[ 
        colIndex := self selectedColIndex ? 0.

        self selectionIndicesDo:[:aRowIndex|
            self invalidateRowAt:aRowIndex colAt:colIndex.
        ].
    ]
!

invalidateVisibleRow:aRow 
    "redraw row if visible"
    
    self invalidateVisibleRow:aRow colAt:0
!

invalidateVisibleRow:aRow colAt:aColNr
    "redraw either a single column in a row,
     or the complete visible row (in case of aColNr == 0).
     If the row/column is hidden, no redraw is done"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
    |

    (start := self indexOfFirstRowShown) ~~ 0 ifTrue:[
        stop := (start + (height // rowHeight)) min:(list size).

        aRow isNumber ifTrue:[
            (aRow between:start and:stop) ifTrue:[
                self invalidateRowAt:aRow colAt:aColNr
            ]
        ] ifFalse:[
            start to:stop do:[:i|
                (self at:i) == aRow ifTrue:[
                    ^ self invalidateRowAt:i colAt:aColNr
                ]
            ]
        ]
    ]
!

invalidateVisibleRow:aRow readSelector:aSelector
    "redraw a column identified by its read selector; if no column with
     the specified read selector is detected, the whole line is drawn."

    |row idx|

    aSelector isNil ifTrue:[
        idx := 0
    ] ifFalse:[
        (row := aRow) isNumber ifTrue:[
            (row := self at:aRow) isNil ifTrue:[ ^ self ]
        ].
        idx := columnDescriptors 
                findFirst:[:aCol| aCol description readSelector == aSelector]
    ].
    self invalidateVisibleRow:aRow colAt:idx
!

redrawX:x y:y width:w height:h
    "redraw part of myself immediately, given logical coordinates "

    |c0 savClip stopRedraw selWidth
     start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
     x0    "{ Class:SmallInteger }"
     x1    "{ Class:SmallInteger }"
     maxX  "{ Class:SmallInteger }"
     yTop  "{ Class:SmallInteger }"
     yBot  "{ Class:SmallInteger }"
     clHg  "{ Class:SmallInteger }"
     size  "{ Class:SmallInteger }"
     lineColor
    |

    shown ifFalse:[^ self].
    self isReallyShown ifFalse:[^ self].

    gc paint:bgColor.

    columnDescriptors isEmpty ifTrue:[
        ^ gc fillRectangleX:x y:y width:w height:h
    ].

    size  := list size.
    yTop  := margin - viewOrigin y.                   
    c0    := y - yTop max:0.
    start := (c0 // rowHeight) + 1.
    stop  := (((c0 + h - 1) // rowHeight) + 1) min:size.

    stop < start ifTrue:[
        ^ gc fillRectangleX:x y:y width:w height:h
    ].
    savClip := self clippingBoundsOrNil.

    maxX := (x + w) min:(width - margin).
    x0   := margin - viewOrigin x.
    yTop := yTop + ((start - 1) * rowHeight).
    clHg := (stop - start + 1) * rowHeight.
    yBot := yTop + clHg.

    stopRedraw := false.

    self class stopRedrawSignal handle:[:ex|
        stopRedraw := true.
    ] do:[
        columnDescriptors do:[:aCol| |cw|
            x1 := x0 + aCol width.

            (x1 > x and:[x0 < maxX]) ifTrue:[
                |left right rect|
                left  := x0 max:x.
                right := x1 min:maxX.
                rect  := Rectangle left:left top:y width:(right - left) height:h.
            
                self clippingBounds:nil.
                self clippingBounds:rect.
                aCol redrawX:x0 y:yTop h:clHg  from:start to:stop.
            ].
            x0 := x1
        ].
    ].

    "/ restore old clipping rectangle
    self clippingBounds:savClip.

    stopRedraw ifTrue:[
        self invalidate.
        self makeSelectionVisible.
        ^ self
    ].

    stop == size ifTrue:[
        yTop := y + h.
        yBot < (yTop - margin) ifTrue:[
            "/ clear to bottom of screen
            gc paint:bgColor.
            gc fillRectangleX:x y:yBot width:w height:(yTop - yBot).
        ]
    ].

    (c0 := w + x- x1) > 0 ifTrue:[
        "/ clear to right of screen
        gc paint:bgColor.
        gc fillRectangleX:x1 y:y width:c0 height:h.
    ].
    "/ if only rows are selected we have to draw
    "/  - the selection frame around the labels
    "/  - and to fill the selection area behind the table if not bound to the width of the view

    self hasRowSelection ifFalse:[ ^ self ].  "/ nothing to do

    selWidth := width-margin-x1.
    lineColor := self selectionFrameColor.

    self selectionIndicesDo:[:rowNr |
        | yVis |
        yVis := self yVisibleOfRowNr:rowNr.
        selWidth > 0 ifTrue:[
            gc paint:selectionBackgroundColor.
            gc fillRectangleX:x1 y:yVis width:selWidth height:rowHeight.
        ].
        lineColor notNil ifTrue:[
            gc paint:lineColor.
            gc displayLineFromX:x y:yVis toX:width y:yVis.
            yVis := yVis+rowHeight -1.
            gc displayLineFromX:x y:yVis toX:width y:yVis.
        ].
    ].     

    "Modified: / 21-01-2011 / 15:58:11 / cg"
! !

!DSVColumnView methodsFor:'drawing interactors'!

displayLabel:aLabel x:xLeft y:yTop
    "display the label at x y; test whether the height of the label matches to the current
     rowHeight. If not, an exception is raised and the rowHeight is recomputed"

    |y h |

    aLabel notNil ifTrue:[
        aLabel isString ifTrue:[
            y := yTop + self rowFontAscent.
        ] ifFalse:[
            h := aLabel heightOn:self.

            h > minRowHeight ifTrue:[
                minRowHeight := h.

                cachedPreferredExtent notNil ifTrue:[
"/                    rowHeight := (minRowHeight + separatorSize + verticalSpacing + verticalSpacing + 1) // 2 * 2.
                    cachedPreferredExtent := Point 
                                            x: cachedPreferredExtent x
                                            y: (list size * rowHeight).
                    self contentsChanged.
                ].
                self class stopRedrawSignal raiseRequest.
            ].
            y := yTop + (aLabel ascentOn:self).
        ].
        aLabel displayOn:self x:xLeft y:y.
    ].

    "Modified: / 05-02-2007 / 09:07:10 / cg"
!

drawCheckToggleAtX:xLeft y:yTop w:cellWidth state:cellValue
    "draw a check toggle button"

    |e form
     y "{ Class:SmallInteger }"
     x "{ Class:SmallInteger }"
     h "{ Class:SmallInteger }"
     w "{ Class:SmallInteger }"
     state|

    state := (cellValue ? false).
    state isBoolean ifFalse:[ state := false ].

    w := checkToggleExtent x.
    h := checkToggleExtent y.
    y := yTop + ((rowHeight - h) // 2).
    x := xLeft + ((cellWidth  - w) // 2).
    h odd ifTrue:[y := y + 1].

    checkToggleActiveImage isNil ifTrue:[
        gc paint:bgColor.
        gc fillRectangleX:x y:y width:w height:h.
        self drawEdgesAtX:x   y:y width:w height:h level:checkToggleLevel on:self.

        state ifFalse:[
            ^ self
        ].
        gc paint:fgColor on:bgColor.
        form := checkToggleForm
    ] ifFalse:[
        form := state 
                    ifTrue:[checkToggleActiveImage]
                    ifFalse:[checkTogglePassiveImage].
    ].
    e := (checkToggleExtent - form extent) // 2.
    gc displayForm:form x:(x + e x) y:(y + e y).
!

drawComboButtonAtX:xTop y:yTop w:rowWidth
    "draw a combo button"

    |e
     x "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"
     h "{ Class:SmallInteger }"
     w "{ Class:SmallInteger }"|

    w := comboButtonExtent x.
    h := comboButtonExtent y.
    y := yTop + ((rowHeight - h) // 2).
    x := xTop + (rowWidth  - w - separatorSize - 1).
    e := (comboButtonExtent - comboButtonForm extent) // 2.

    gc paint:bgColor.
    gc fillRectangleX:x y:y width:w height:h.
    self drawEdgesAtX:x   y:y width:w height:h level:comboButtonLevel on:self.
    gc paint:fgColor on:bgColor.
    gc displayForm:comboButtonForm x:(x + e x) y:(y + e y)
!

drawEdgesAtX:x y:y width:w height:h level:aLevel on:aGC 
    "draw edges for a cell or label"
    
    aGC 
        drawEdgesForX:x
        y:y
        width:w
        height:h
        level:aLevel
        shadow:buttonShadowColor
        light:buttonLightColor
        halfShadow:buttonHalfShadowColor
        halfLight:buttonHalfLightColor
        style:ButtonEdgeStyle.
!

drawRadioButtonAtX:xLeft y:yTop w:cellWidth state:aState
    "draw a radio button"

    |image
     y "{ Class:SmallInteger }"
     x "{ Class:SmallInteger }"
     h "{ Class:SmallInteger }"
     w "{ Class:SmallInteger }"|

    w := radioButtonActiveImage extent x.
    h := radioButtonActiveImage extent y.
    y := yTop + ((rowHeight - h) // 2).
    x := xLeft + ((cellWidth - w) // 2).
    h odd ifTrue:[y := y + 1].

    image := (aState == true) 
                ifTrue:[radioButtonActiveImage]
                ifFalse:[radioButtonPassiveImage].

    image := image onDevice:device.

    self displayForm:image x:x y:y.
! !

!DSVColumnView methodsFor:'enumerating columns'!

columnsDo:aOneArgBlock
    "evaluate the argument, aOneArgBlock for every columnDescriptor"
    
    columnDescriptors do:aOneArgBlock
!

columnsFrom:start to:stop do:aOneArgBlock 
    "evaluate the argument, aOneArgBlock for the columns with index start to
     stop in the collection of column descriptors"
    
    columnDescriptors 
        from:start
        to:stop
        do:aOneArgBlock
! !

!DSVColumnView methodsFor:'event handling'!

buttonControlPressAt:clickPoint rowNr:aRowNr colNr:aColNr
    |isSelected prvRow doAdd chgSet|

    buttonMotionAction := buttonReleaseAction := nil.
    isSelected := self isInSelection:aRowNr.

    multipleSelectOk ifFalse:[
        isSelected ifTrue:[
            self deselect.
        ] ifFalse:[
            self selectRowAt:aRowNr colAt:aColNr atPoint:clickPoint openEditor:false.
        ].
        ^ self
    ].

    isSelected ifTrue:[ self removeRowFromSelection:aRowNr ]
              ifFalse:[ self addRowToSelection:aRowNr ].

    multipleSelectOk ifFalse:[ ^ self ].

    prvRow := aRowNr.
    chgSet := IdentitySet new.
    doAdd  := isSelected not.

    buttonMotionAction := [:p| 
        |rowNr mustRestore step f|

        rowNr := self yVisibleToRowNr:(p y).
        (rowNr notNil and:[rowNr ~~ prvRow]) ifTrue:[
            rowNr == aRowNr ifTrue:[
                mustRestore := true
            ] ifFalse:[
                rowNr > aRowNr ifTrue:[ mustRestore := (rowNr < prvRow) ]
                              ifFalse:[ mustRestore := (rowNr > prvRow) ].
            ].
            prvRow > rowNr ifTrue:[ step := -1 ]
                          ifFalse:[ step :=  1 ].


            mustRestore ifTrue:[
                [ prvRow ~~ rowNr ] whileTrue:[
                    (chgSet removeIdentical:prvRow ifAbsent:nil) notNil ifTrue:[
                        doAdd ifFalse:[ self addRowToSelection:prvRow ]
                               ifTrue:[ self removeRowFromSelection:prvRow ].
                    ].
                    prvRow := prvRow + step.
                ].
            ] ifFalse:[
                [ prvRow ~~ rowNr ] whileTrue:[
                    prvRow := prvRow + step.

                    doAdd ~~ (self isInSelection:rowNr) ifTrue:[
                        chgSet add:prvRow.

                        doAdd ifTrue:[ self addRowToSelection:prvRow ]
                             ifFalse:[ self removeRowFromSelection:prvRow ].
                    ]
                ].
            ].
        ].
    ].

    "Modified: / 21-07-2007 / 22:00:27 / cg"
!

buttonMotion:buttonMask x:x y:y 
    "mouse-move while button was pressed - handle multiple selection changes"
    
    self isEnabled ifFalse:[
        ^ self
    ].

    buttonMotionAction notNil ifTrue:[
        buttonMotionAction value:(x @ y).
        buttonMotionAction notNil ifTrue:[
            autoScroll ifTrue:[
                "/ if moved outside of view, start autoscroll
                (y < 0) ifTrue:[
                    ^ self startAutoScroll:#scrollUp distance:y.
                ].
                (y > height) ifTrue:[
                    ^ self startAutoScroll:#scrollDown distance:(y - height).
                ].
            ]
        ]
    ].
    self stopAutoScroll.
!

buttonMultiPress:button x:x y:y
    "a button was pressed twice - handle doubleclick here"

    |selectedCol|

    buttonMotionAction := buttonReleaseAction := nil.

    self isEnabled ifFalse:[^ self].

    (button == 1) ifFalse:[
        ^ super buttonMultiPress:button x:x y:y
    ].
    self numberOfSelections == 1 ifTrue:[
        self firstIndexSelected == (self yVisibleToRowNr:y) ifTrue:[
            selectedCol := self selectedColIndex.
            ( selectedCol == 0
              or:[selectedCol == (self xVisibleToColNr:x)]
            ) ifTrue:[
                self doubleClicked
            ]
        ]
    ]

    "Modified: / 26-03-2007 / 15:19:04 / cg"
!

buttonPress:button x:x y:y
    "a button was pressed - handle selection here"

    |rowNr colNr sensor clickPoint clickedIntoSelection column columnEditorType|

    buttonMotionAction := buttonReleaseAction := nil.

    self isEnabled ifFalse:[^ self].

    rowNr := self yVisibleToRowNr:y.
    colNr := self xVisibleToColNr:x.

    (button == 2) ifTrue:[ |openMenu|
        openMenu := false.
        
        UserPreferences current selectOnRightClick ifFalse:[
            openMenu := true.
        ] ifTrue:[
            UserPreferences current showRightButtonMenuOnRelease ifFalse:[
                (rowNr notNil and:[colNr notNil and:[self isRowSelectable:rowNr]]) ifTrue:[
                    self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:false
                ].
                openMenu := true.
            ].
        ].
        openMenu ifTrue:[ |menu|
            menu := self findMenuForSelection.
            menu notNil ifTrue:[ 
                self startUpMenu:menu.
            ] ifFalse:[
                super buttonPress:button x:x y:y.
            ].
            ^ self
        ].
    ].
    
    (rowNr isNil or:[colNr isNil]) ifTrue:[
        self deselect.
        super buttonPress:button x:x y:y.
        ^ self
    ].

    (self isRowSelectable:rowNr) ifFalse:[^ self ].

    sensor     := self sensor.
    clickPoint := x @ y.

    sensor shiftDown ifTrue:[
        self buttonShiftPressAt:clickPoint rowNr:rowNr colNr:colNr.
        ^ self
    ].
    sensor ctrlDown ifTrue:[
        self buttonControlPressAt:clickPoint rowNr:rowNr colNr:colNr.
        ^ self
    ].

    multipleSelectOk ifFalse:[
        self canDrag ifFalse:[
            self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:true.
            ^ self
        ].
        self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:false.

        ((button == 2) and:[UserPreferences current selectOnRightClick]) ifTrue:[
            self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:true 
        ] ifFalse:[
            buttonReleaseAction := 
                [ 
                    self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:true 
                ].

            buttonMotionAction := 
                [:aPoint|
                    (self canStartDragAt:aPoint clickedAt:clickPoint) ifTrue:[
                        self startDragAt:aPoint
                    ]
                ].
        ].
        ^ self
    ].

    ((button == 2) and:[UserPreferences current selectOnRightClick]) ifFalse:[
        buttonReleaseAction := 
            [
                self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:true.
            ].

        "/ normally, we select on button release; however, any editor is shown immediately
        ((column := self columnDescriptorAt:colNr) notNil 
        and:[ (columnEditorType := column description editorType) notNil
        and:[ columnEditorType ~~ #None ]]) ifTrue:[
            buttonReleaseAction value.
            buttonReleaseAction := nil.
            editView notNil ifTrue:[
                |p|

                "/ kludge
                p := device translatePoint:x@y fromView:self toView:editView.
                editView simulateButtonPress:button at:p.
                (editView subViews first isKindOf:EditTextView) ifTrue:[
                    editView simulateButtonRelease:button at:p.
                ].
                ^ self.
            ]
        ]
    ].

    clickedIntoSelection := self isInSelection:rowNr.
    clickedIntoSelection ifTrue:[ 
        |selColIdx|

        selColIdx := self selectedColIndex.

        (selColIdx ~~ 0 and:[selColIdx ~~ colNr]) ifTrue:[
            clickedIntoSelection := (selectedRowIndex size > 1)
        ].
    ].

    clickedIntoSelection ifFalse:[
        self selectRowAt:rowNr colAt:colNr atPoint:clickPoint openEditor:false.
    ] ifTrue:[
        self canDrag ifTrue:[
            buttonMotionAction := 
                [:aPoint|
                    (self canStartDragAt:aPoint clickedAt:clickPoint) ifTrue:[
                        self startDragAt:aPoint
                    ]
                ].
            ^ self
        ]
    ].

    buttonMotionAction := [:p|
        (self bounds containsPoint:p) ifTrue:[ 
            |rowUnderPoint|

            rowUnderPoint := self yVisibleToRowNr:(p y).

            rowUnderPoint notNil ifTrue:[
                buttonReleaseAction notNil ifTrue:[
                    rowUnderPoint == rowNr ifFalse:[ 
                        buttonReleaseAction := nil
                    ].
                ].
                buttonReleaseAction isNil ifTrue:[
                    self selectRowFrom:rowNr to:rowUnderPoint.
                ]
            ]
        ].
    ].

    "Modified: / 12-07-2011 / 14:54:45 / cg"
!

buttonRelease:button x:x y:y

    buttonMotionAction := nil.
    self stopAutoScroll.

    buttonReleaseAction notNil ifTrue:[
        buttonReleaseAction value.
        buttonReleaseAction := nil.
    ].
    super buttonRelease:button x:x y:y
!

buttonShiftPressAt:clickPoint rowNr:aRowNr colNr:aColNr
    |colIdx numSelRows|

    buttonReleaseAction := buttonMotionAction := nil.

    colIdx := aColNr.

    (multipleSelectOk and:[(numSelRows := selectedRowIndex size) > 0]) ifTrue:[
        (numSelRows == 1 and:[self isInSelection:aRowNr]) ifFalse:[ |min max|
            min := max := aRowNr.

            selectedRowIndex do:[:anIndex|
                min := min min:anIndex.
                max := max max:anIndex.
            ].
            self selectRowFrom:min to:max.
            ^ self
        ].
        self selectedColIndex ~~ 0 ifTrue:[     "/ toggle column selection
            colIdx := 0
        ].
    ].
    self selectRowAt:aRowNr colAt:colIdx atPoint:clickPoint openEditor:false.
!

characterPress:aChar x:x y:y
    "search row in column at x/y starting its printable label with character."

    |colNr rowNr lsize found column|

    lsize  := list size.

"/    (rowIfAbsentBlock notNil 
"/     or:[x isNil
"/     or:[(colNr := self xVisibleToColNr:x) isNil]]) ifTrue:[
"/        ^ self
"/    ].
    colNr := self findFirstColumnWithStringFrom:1 to:lsize.
    colNr isNil ifTrue:[ ^ self ].

    rowNr  := self lastIndexSelected.
    column := self columnDescriptorAt:colNr.
    found  := 0.

    lsize > rowNr ifTrue:[
        "/ search to end
        found := column findRowNrStartingWithChar:aChar start:(rowNr + 1) stop:lsize.
    ].

    (found == 0 and:[rowNr > 1]) ifTrue:[
     "/ search from begin
        found := column findRowNrStartingWithChar:aChar start:1 stop:(rowNr - 1)
    ].
    found ~~ 0 ifTrue:[
        self selectColIndex:colNr rowIndex:found.
    ].

    "Modified: / 21.5.1998 / 03:30:22 / cg"
!

contentsChanged
    "size of contents changed - move origin up if possible"
    
    |y|

    shown ifTrue:[
        self recomputeHeightOfContents.
        y := self maxViewOriginY.
        viewOrigin y > y ifTrue:[
            scrollWhenUpdating ~~ false ifTrue:[
                self scrollTo:(viewOrigin x @ y)
            ]
        ] ifFalse:[
            self updateEditViewOrigin.
        ]
    ].
    super contentsChanged
!

cursorKey:aKey rawKey:rawKey
    |hasSelectables step start minSelRowNr maxSelRowNr selColNr selRowNr listSize|

    hasSelectables := self hasSelectables.
    listSize := list size.

    (hasSelectables or:[selectRowOnDefault]) ifFalse:[ ^ self ].

    minSelRowNr := self minIndexSelected.
    maxSelRowNr := self maxIndexSelected.

    selColNr := hasSelectables ifFalse:[0] ifTrue:[self selectedColIndex].

    aKey == #CursorUp ifTrue:[
        selRowNr := minSelRowNr > 1 ifTrue:[minSelRowNr - 1] ifFalse:[listSize].
        step := -1.
    ] ifFalse:[
        aKey == #CursorDown ifTrue:[
            selRowNr := maxSelRowNr < listSize ifTrue:[maxSelRowNr + 1] ifFalse:[1].
            step := 1.
        ] ifFalse:[
            ("aKey == #BeginOfLine or:[" rawKey == #Home "]") ifTrue:[
                selRowNr := 1.
                step := 1.
            ] ifFalse:[
                (rawKey == #End) ifTrue:[
                    selRowNr := listSize.
                    step := -1.
                ]
            ]
        ]
    ].
    start := selRowNr.

    [ self isRowSelectable:selRowNr ] whileFalse:[
        selRowNr := selRowNr + step.

        selRowNr == 0 ifTrue:[
            selRowNr := listSize.
        ] ifFalse:[
            selRowNr > listSize ifTrue:[
                selRowNr := 1.
            ].
        ].
        selRowNr == start ifTrue:[^ self ].
    ].

    ((aKey == #CursorUp) or:[aKey == #CursorDown]) ifTrue:[
        (multipleSelectOk and:[self sensor shiftDown]) ifTrue:[
            self addRowToSelection:selRowNr.

            aKey == #CursorDown ifTrue:[
                self makeLineVisible:((selRowNr+1) min:listSize)
            ] ifFalse:[
                self makeLineVisible:((selRowNr-1) max:1)
            ].
            ^ self
        ]
    ].
    self selectColIndex:selColNr rowIndex:selRowNr
!

doubleClicked
    "handle a double click"
    
    |col sel idx|

    self hasSelection ifTrue:[
        idx := self firstIndexSelected.
        col := self selectedColumn.
        (col notNil and:[ (sel := col doubleClickedSelector) notNil ]) ifTrue:[
            col doubleClickOn:idx
        ] ifFalse:[
            doubleClickActionBlock notNil ifTrue:[
                doubleClickActionBlock valueWithOptionalArgument:idx
            ]
        ]
    ]
!

findMenuForSelection
    "find the middle button menu for the current selection; returns the menu or nil"
    
    |col row menu|

    self numberOfSelections == 1 ifTrue:[
        row := self at:(self firstIndexSelected).
        col := self selectedColumn.
        col notNil ifTrue:[
            menu := col menuForRow:row orAdaptor:columnAdaptor.
            menu notNil ifTrue:[ ^ menu ].
        ].

        col := columnDescriptors 
                        detect:[:c | c rendererType == #rowSelector ]
                        ifNone:[ nil ].
        col notNil ifTrue:[
            ^ col menuForRow:row inApplication:(self application)
        ]
    ].
    ^ nil
!

keyPress:aKey x:x y:y
    "a key was pressed - handle page-keys here"

    <resource: #keyboard (#PreviousPage #NextPage #HalfPageUp #HalfPageDown
                          #BeginOfText #EndOfText #ScrollUp #ScrollDown
                          #CursorUp #CursorDown #CursorRight #CursorLeft #SelectAll)>

    |maxColNr firstSelRowNr selRowNr selColNr 
     key column isTab listSize hasSelectables rawKey|

    self isEnabled ifFalse:[^ self].

    (listSize := list size) == 0 ifTrue:[
        ^ super keyPress:aKey x:x y:y
    ].
    aKey isCharacter ifTrue:[
        ^ self characterPress:aKey x:x y:y
    ].

    (aKey == #SelectAll) ifTrue:[
        multipleSelectOk ifTrue:[
            self selectAllRows. 
        ].
        ^ self
    ].

    aKey == #PreviousPage ifTrue:[^ self pageUp].
    aKey == #NextPage     ifTrue:[^ self pageDown].
    aKey == #HalfPageUp   ifTrue:[^ self halfPageUp].
    aKey == #HalfPageDown ifTrue:[^ self halfPageDown].
    aKey == #BeginOfText  ifTrue:[^ self scrollToTop].
    aKey == #EndOfText    ifTrue:[^ self scrollToBottom].
    aKey == #ScrollUp     ifTrue:[^ self scrollUp]. 
    aKey == #ScrollDown   ifTrue:[^ self scrollDown]. 

    aKey == #Return ifTrue:[   
        editView notNil ifTrue:[
            (self selectedRowIndex size == 1
            and:[self selectedRowIndex first == listSize]) ifTrue:[
                self selectRowIndex:nil.
            ] ifFalse:[
                self cursorKey:#CursorDown rawKey:#CursorDown.
            ].
            ^ self
        ].
        self numberOfSelections == 1 ifTrue:[
            self doubleClicked
        ].
        ^ self
    ].

    hasSelectables := self hasSelectables.

    rawKey := (WindowGroup lastEventQuerySignal query) rawKey.

    (aKey == #CursorUp 
    or:[aKey == #CursorDown
    or:[rawKey == #Home
    or:[rawKey == #End]]]) 
    ifTrue:[
        self cursorKey:aKey rawKey:rawKey.
        ^ self
    ].

    hasSelectables ifFalse:[
        ^ super keyPress:aKey x:x y:y
    ].

    "/ CURSOR LEFT/RIGHT or TABING
    (aKey == #CursorLeft or:[aKey == #CursorRight]) ifTrue:[
        isTab := false.
        key   := aKey.
    ] ifFalse:[
        tabIntern ifFalse:[
            ^ super keyPress:aKey x:x y:y
        ].

        (aKey includesString:'Tab') ifTrue:[
            key := (aKey = #BackTab or:[self sensor shiftDown or:[aKey includesString:'Left']]) 
                        ifTrue:[#CursorLeft]
                        ifFalse:[#CursorRight]
        ] ifFalse:[
            (aKey == #FocusPrevious or:[aKey == #FocusNext]) ifFalse:[
                ^ super keyPress:aKey x:x y:y
            ].
            key := aKey == #FocusPrevious ifTrue:[#CursorLeft] ifFalse:[#CursorRight].
        ].
        isTab := true.
    ].

    maxColNr := self numberOfColumns.
    selColNr := self selectedColIndex.

    firstSelRowNr := self firstIndexSelected.

    key == #CursorLeft ifTrue:[
        selRowNr := firstSelRowNr.
        selRowNr == 0 ifTrue:[selRowNr := listSize].
        selColNr == 0 ifTrue:[selColNr := maxColNr + 1].

        [true] whileTrue:[
            (selColNr := selColNr - 1) == 0 ifTrue:[
                [   selRowNr := selRowNr - 1.
                    selRowNr == 0 ifTrue:[
                        isTab ifTrue:[
                            tabAtStartAction notNil ifTrue:[
                                tabAtStartAction value
                            ] ifFalse:[
                                self deselect.
                                self windowGroup focusPreviousFrom:self
                            ]
                        ].
                        ^ self
                    ].
                    (self isRowSelectable:selRowNr)
                ] whileFalse.

                selColNr := maxColNr
            ].
            column := self columnDescriptorAt:selColNr.

            (column rendererType ~~ #rowSelector and:[column canSelect:selRowNr]) ifTrue:[
                ^ self selectColIndex:selColNr rowIndex:selRowNr.
            ]
        ]
    ].

    selRowNr := firstSelRowNr.
    selRowNr == 0 ifTrue:[selRowNr := 1].

    [true] whileTrue:[
        (selColNr := selColNr + 1) > maxColNr ifTrue:[
            [   selRowNr := selRowNr + 1.
                selRowNr > listSize ifTrue:[
                    isTab ifTrue:[
                        tabAtEndAction notNil ifTrue:[
                            tabAtEndAction value
                        ] ifFalse:[
                            self deselect.
                            self windowGroup focusNextFrom:self
                        ]
                    ].
                    ^ self
                ].
                (self isRowSelectable:selRowNr)
            ] whileFalse.

            selColNr := 1
        ].
        column := self columnDescriptorAt:selColNr.

        (column rendererType ~~ #rowSelector and:[column canSelect:selRowNr]) ifTrue:[
            ^ self selectColIndex:selColNr rowIndex:selRowNr
        ]
    ].
!

keyboardZoom:larger
    "CTRL+/- zoom action"

    self fontLargerOrSmaller:larger
!

originChanged:delta 
    "this one is sent, after the origin of my contents has changed -
     tell dependents (i.e. scrollers) about this"
    
    super originChanged:delta.
    self updateEditViewOrigin.
!

sizeChanged:how
    "size changed - move origin up if possible
     change the layout of the labelView dependent on my layout"

    |selectionWasVisible lastExtent|

    lastExtent := previousExtent notNil ifTrue:[previousExtent] ifFalse:[self extent].
    selectionWasVisible := self isSelectionVisibleIn:lastExtent.

    previousExtent := self extent.
    super sizeChanged:how.

    previousExtent := self extent.

    "/ no - must compute even if not visible.
    "/ (could be invisible in a notebook ...)
    realized ifTrue:[                   "used to be: shown" 
"/        labelView isVisible ifTrue:[
"/            lyt := labelView layout.
"/            lyt  leftOffset:(layout leftOffset).
"/            lyt rightOffset:(layout rightOffset).
"/            labelView layout:lyt.
"/        ].
        previousExtent x ~= lastExtent x ifTrue: [
            self fitColumns.
        ].
        selectionWasVisible ifTrue:[
            self makeSelectionVisible.
        ].
        self updateEditViewOrigin.
    ].

    "Modified: / 04-05-2012 / 14:34:24 / cg"
! !

!DSVColumnView methodsFor:'focus handling'!

canTab
    super canTab ifTrue:[
        ^ editView isNil
    ].
    ^ false
!

showFocus:explicit
    self invalidateSelection.
    super showFocus:explicit
!

showNoFocus:explicit
    self invalidateSelection.
    super showNoFocus:explicit
!

wantsFocusWithPointerEnter
    "views which like to take the keyboard focus
     when the pointer enters can do so by redefining this
     to return true"

    editView notNil ifTrue:[^ false].

    (UserPreferences current focusFollowsMouse ~~ false
    and:[(styleSheet at:#'selection.requestFocusOnPointerEnter' default:true)
    ]) ifTrue:[
        list size > 0 ifTrue:[
            ^ true
        ]
    ].
    ^ false

    "Modified: / 08-08-2010 / 14:41:00 / cg"
! !

!DSVColumnView methodsFor:'gc operations'!

imageOnMyDevice:anImage 
    "associate image to device and returns the new image."

    anImage isNil ifTrue:[^ nil].
    ^ anImage onDevice:device.
!

registerImage:anImage key:aKey 
    "any row can register an image with a unique identifier a key symbol"
    
    |img|

    (img := registererImages at:aKey ifAbsent:nil) notNil ifTrue:[
        ^ img
    ].
    img := self imageOnMyDevice:anImage.
    registererImages at:aKey put:img.
    ^ img
!

registeredImageAt:aKey 
    "any row can register an image with a unique identifier"
    
    ^ registererImages at:aKey ifAbsent:nil
!

releaseAllRegisteredImages
    "release all registered images"
    
    registererImages := IdentityDictionary new.
! !

!DSVColumnView methodsFor:'help'!

flyByHelpTextAt:aPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item)."

    |rowNr colNr col|

    columnDescriptors isEmpty ifTrue:[^ nil].

    rowNr := self yVisibleToRowNr:aPoint y.
    rowNr isNil ifTrue:[^ nil ].

    colNr := self xVisibleToColNr:aPoint x.
    colNr notNil ifTrue:[
        col := columnDescriptors at:colNr.
        ^ col activeHelpTextForRow:rowNr.
    ].
    ^ nil

    "Created: / 26-03-2007 / 14:42:54 / cg"
    "Modified: / 16-10-2007 / 17:52:24 / cg"
! !

!DSVColumnView methodsFor:'initialization & release'!

create
    |graphicsDevice|

    super create.
    graphicsDevice := device.

    fgColor     := fgColor     onDevice:graphicsDevice.
    bgColor     := bgColor     onDevice:graphicsDevice.
    selectionForegroundColor := selectionForegroundColor onDevice:graphicsDevice.
    selectionBackgroundColor := selectionBackgroundColor onDevice:graphicsDevice.
    selectionFrameColor notNil ifTrue:[selectionFrameColor := selectionFrameColor onDevice:graphicsDevice].
    selectionForegroundColorNoFocus := selectionForegroundColorNoFocus onDevice:graphicsDevice.
    selectionBackgroundColorNoFocus := selectionBackgroundColorNoFocus onDevice:graphicsDevice.

    buttonShadowColor := buttonShadowColor onDevice:graphicsDevice.
    buttonLightColor  := buttonLightColor onDevice:graphicsDevice.

    buttonHalfShadowColor notNil ifTrue:[
        buttonHalfShadowColor := buttonHalfShadowColor onDevice:graphicsDevice
    ].

    buttonHalfLightColor notNil ifTrue:[
        buttonHalfLightColor := buttonHalfLightColor onDevice:graphicsDevice
    ].
    rowSelectorForm         := self imageOnMyDevice:rowSelectorForm.
    checkToggleActiveImage  := self imageOnMyDevice:checkToggleActiveImage.
    checkTogglePassiveImage := self imageOnMyDevice:checkTogglePassiveImage.
    checkToggleForm         := self imageOnMyDevice:checkToggleForm.
    radioButtonActiveImage  := self imageOnMyDevice:radioButtonActiveImage.
    radioButtonPassiveImage := self imageOnMyDevice:radioButtonPassiveImage.
    comboButtonForm         := self imageOnMyDevice:comboButtonForm.

    "Modified: / 20-01-2011 / 08:43:51 / cg"
!

initStyle
    "setup colors, etc."

    |button widget|

    super initStyle.

    DefaultForegroundColor isNil ifTrue:[
        self class updateStyleCache
    ].
    fgColor     := DefaultForegroundColor.
    bgColor     := DefaultBackgroundColor.
    labelFgColor := DefaultLabelForegroundColor.
    labelBgColor := DefaultLabelBackgroundColor.
    selectionForegroundColor := DefaultHilightForegroundColor.
    selectionBackgroundColor := DefaultHilightBackgroundColor.
    selectionFrameColor      := DefaultHilightFrameColor.

    shadowColor isNil ifTrue:[
        shadowColor := Color grayPercent:40.
    ].

    lightColor isNil ifTrue:[
        lightColor := Color grayPercent:75
    ].

    buttonLightColor    := ButtonLightColor  ? lightColor.
    buttonShadowColor   := ButtonShadowColor ? shadowColor.

    (ButtonEdgeStyle == #soft) ifTrue:[
        buttonHalfShadowColor := ButtonHalfShadowColor.
        buttonHalfLightColor  := ButtonHalfLightColor.

        buttonHalfShadowColor isNil ifTrue:[
            buttonHalfShadowColor := buttonShadowColor lightened
        ]
    ].

    buttonHalfShadowColor isNil ifTrue:[
        buttonHalfShadowColor := Color gray
    ].

    selectionForegroundColorNoFocus isNil ifTrue:[
        selectionForegroundColorNoFocus := DefaultHilightForegroundColorNoFocus.
        selectionForegroundColorNoFocus isNil ifTrue:[
            selectionForegroundColorNoFocus := selectionForegroundColor slightlyLightened.
        ]
    ].
    selectionBackgroundColorNoFocus isNil ifTrue:[
        selectionBackgroundColorNoFocus := DefaultHilightBackgroundColorNoFocus.
        selectionBackgroundColorNoFocus isNil ifTrue:[
            selectionBackgroundColor notNil ifTrue:[
                selectionBackgroundColorNoFocus := selectionBackgroundColor slightlyLightened.
                "/ selectionBackgroundColorNoFocus := Color brightness:(selectionBackgroundColor "lightened" brightness).   "/ asGray.
            ].
        ].
    ].
    selectionFrameColorNoFocus isNil ifTrue:[
        selectionFrameColor notNil ifTrue:[
            selectionFrameColorNoFocus := selectionFrameColor lightened.  
            "/ selectionFrameColorNoFocus := Color brightness:(selectionFrameColor "lightened" brightness).   "/ asGray
        ]
    ].

    rowSelectorForm         := self class rowSelectorImage.

    checkToggleActiveImage  := CheckToggleActiveImage.
    checkTogglePassiveImage := CheckTogglePassiveImage.

    CheckToggleForm isNil ifTrue:[
        widget            := CheckToggle new.
        CheckToggleForm   := widget label.
        CheckToggleLevel  := widget offLevel.
        CheckToggleExtent := widget preferredExtent.
    ].

    checkToggleForm   := CheckToggleForm.
    checkToggleLevel  := CheckToggleLevel.
    checkToggleExtent := CheckToggleExtent.

    radioButtonActiveImage  := RadioButtonActiveImage.
    radioButtonPassiveImage := RadioButtonPassiveImage.

    ComboButtonForm isNil ifTrue:[
        widget            := ComboListView new.
        button            := widget menuButton.
        ComboButtonForm   := button label.
        ComboButtonLevel  := button offLevel.
        ComboButtonExtent := (button preferredWidth) @ (widget preferredHeight).
    ].

    comboButtonForm   := ComboButtonForm.
    comboButtonLevel  := ComboButtonLevel.
    comboButtonExtent := ComboButtonExtent.

    "Modified: / 20-01-2012 / 15:48:13 / cg"
!

initialize
    "set default attributes"

    |fontOnDevice|

    super initialize.
    self lineWidth:0.

    separatorSize      := 1.                            "/ separators mode 2D
    verticalSpacing    := self class verticalSpacing.
    horizontalSpacing  := self class horizontalSpacing.
    tabIntern          := true.
    useIndex           := true.
    viewOrigin         := 0@0.
    fontOnDevice       := gc deviceFont.
    rowFontAscent      := fontOnDevice ascent.
    rowHeight          := verticalSpacing + fontOnDevice height + verticalSpacing + separatorSize.
    minRowHeight       := rowHeight.
    multipleSelectOk   := false.                        "/ multiselect disabled
    selectedRowIndex   := 0.                            "/ no selection
    self selectedColIndex:0.    
    registererImages   := Dictionary new.
    columnDescriptors  := #().
    beDependentOfRows  := false.
    colorMap           := Dictionary new.
    catchChangeEvents  := false.
    selectRowOnDefault := true.
    autoScroll         := true.
    autoScrollToColumn := true.
    scrollRowWise      := false.
    sortListInPlace    := false.    "/ when false (default for backward compatibility): 
                                    "/ if sorting, create a copy
                                    "/ of the list, which is wrong when useIndex is on,
                                    "/ as the application will get the index in the sorted
                                    "/ list, which is probably different from tha apps list mode.
                                    "/ When true (should be default, but that might break many
                                    "/ users), the passed in list is sorted in place (i.e. possibly
                                    "/ sorting the application's list).

    updateListHolderWhenSorting := false.
                                    "/ when false (default for backward compatibility): 
                                    "/ if sorting, do not write back the sorted list into the listHolder
                                    "/ When true (should be default, but that might break many
                                    "/ users), the sorted list is written back into the listHolder,
                                    "/ but only if sortListInPlace is false.

    "/ need for active help
    self enableMotionEvents.

    "Modified: / 22-10-2006 / 11:02:25 / cg"
!

mapped
    "set selection (if any) after mapping"
    
    |idx|

    super mapped.
    needFitColumns == true ifTrue:[
        self fitColumns
    ].
    (idx := self firstIndexSelected) ~~ 0 ifTrue:[
        self scrollToRowAt:idx colAt:0.
    ].
!

realize
    "recompute contents and fit columns to view"
    
    |selection|

    self bitGravity:#NorthWest.
    self recomputeHeightOfContents.
    selection := 0.
    model notNil ifTrue:[
        (model respondsTo:#selectionIndex) ifTrue:[
            selection := model selectionIndex
        ] ifFalse:[
            model == listHolder ifFalse:[
                selection := model value
            ]
        ]
    ].
    self selectRowIndex:selection.
    super realize.
    self fitColumns.
!

release
    "remove dependencies"
    
    self columnHolder:nil.

    beDependentOfRows ifTrue:[self makeIndependentOfRows].
    listHolder notNil ifTrue:[
        listHolder removeDependent:self.
    ].
    columnAdaptor isValueModel ifTrue:[
        columnAdaptor removeDependent:self
    ].
    super release
! !

!DSVColumnView methodsFor:'obsolete'!

has3Dsepartors
    <resource: #obsolete>
    "shouldn't be used any more"

    self obsoleteMethodWarning.
    ^ self has3Dseparators
!

has3Dsepartors:aBool
    <resource: #obsolete>
 
    "shouldn't be used any more"
    
    self obsoleteMethodWarning.
    self has3Dseparators:aBool
! !

!DSVColumnView methodsFor:'private'!

anyColumnHasBackground
    columnDescriptors isNil ifTrue:[^ false].
    columnDescriptors do:[:eachCol |
        |bg|

        bg := eachCol backgroundColor.
        (bg notNil and:[bg isImageOrForm]) ifTrue:[^ true].
        eachCol bgSelector notNil ifTrue:[^ true].
    ].
    ^ false.
!

anyColumnHasPotentialNonConstantBackground
    columnDescriptors isNil ifTrue:[^ false].
    ^ columnDescriptors contains:[:someCol | someCol hasPotentialNonConstantBackground].
"/    columnDescriptors do:[:eachCol | eachCol hasPotentialNonConstantBackground ifTrue:[^ true]].
"/    ^ false.
!

destroyEditView
    "destroy the edit view; release KeyboardForwarder"

    editValue notNil ifTrue:[
        editValue removeDependent:self.
        editValue := nil
    ].

    editView notNil ifTrue:[ |winGroup focusView|
        self hasFocus ifTrue:[focusView := self].

        editView withAllSubViewsDo:[:aView |
            aView hasFocus ifTrue:[focusView := self].
            aView delegate:nil
        ].
        editView destroy.
        editView := nil.

        winGroup := self windowGroup.

        winGroup notNil ifTrue:[
            winGroup focusView:focusView.
        ]
    ].
!

detectViewAt:aPoint in:aView 
    "returns the view at a point"
    
    aView isNil ifTrue:[
        ^ nil
    ].
    ^ aView detectViewAt:aPoint.
!

fitColumns
    "fit columns to view; "

    |selectedColumn columnsWithRelativeWidth 
     overallMinWidth restWidth anyChange oldOrgX newOrgX oldWidth|

    realized ifFalse:[
        needFitColumns := true.
        ^ self
    ].

    cachedPreferredExtent isNil ifTrue:[
        self preferredExtent.
    ] ifFalse:[
        oldWidth := cachedPreferredExtent x.
    ].

    columnDescriptors isEmpty ifTrue:[
        ^ self
    ].

    overallMinWidth := 0.
    anyChange := false.
    columnsWithRelativeWidth := OrderedCollection new.

    columnDescriptors do:[:aCol|
        aCol canResize ifTrue:[
            anyChange := true.
            aCol invalidate.
        ].
        aCol hasRelativeWidth ifTrue:[columnsWithRelativeWidth add:aCol].
        overallMinWidth := overallMinWidth + aCol minWidth.
    ].

    cachedPreferredExtent := width @(self preferredHeight).

    columnsWithRelativeWidth notEmpty ifTrue:[
        restWidth := self innerWidth - overallMinWidth.

        restWidth > 0 ifTrue:[
            |sumOfAnnouncedRelativeWidths sumWeach|

            "/ distribute restwidth among remaining columns according to
            "/ their announced relative width's
            sumOfAnnouncedRelativeWidths := columnsWithRelativeWidth sum:[:each | each description width].
            sumWeach := 0.
            columnsWithRelativeWidth do:[:each |
                |eachRel wEach|

                eachRel := each description width / sumOfAnnouncedRelativeWidths.
                each == columnsWithRelativeWidth last ifTrue:[
                    wEach := restWidth - sumWeach.
                ] ifFalse:[
                    wEach := (eachRel * restWidth) truncated.
                    sumWeach := sumWeach + wEach.
                ].
                each setWidth:wEach.
            ].
        ]
    ] ifFalse:[
        anyChange ifTrue:[
            | resizableColumns numberOfResizeable additionalOffsetX |

            overallMinWidth  := 0.
            resizableColumns := OrderedCollection new.

            columnDescriptors do:[: eachColumn |
                eachColumn canResize ifTrue:[ resizableColumns add: eachColumn ].
                eachColumn width: nil. "force a recomputation of width"
                overallMinWidth := overallMinWidth + eachColumn width.
            ].
            numberOfResizeable := resizableColumns size.
            numberOfResizeable > 0 ifTrue:[
                restWidth := self innerWidth - overallMinWidth.

                restWidth > numberOfResizeable ifTrue:[
                    additionalOffsetX := restWidth // numberOfResizeable.
                    resizableColumns do:[:aCol| aCol growWidth:additionalOffsetX ].
                    restWidth := restWidth - (additionalOffsetX * numberOfResizeable).
                ].
                restWidth > 0 ifTrue:[ resizableColumns last growWidth:restWidth ].
            ].
        ].
    ].

    shown ifTrue:[
        "have to invalidate unconditionally even if nothing has been changed here:
         #fitColumns is called from #changeWidthOfColumn:deltaX:
         after a manual resize"

        self      invalidate.
        labelView invalidate.

        (oldOrgX := viewOrigin x) ~~ 0 ifTrue:[
            |prefWidth|

            "/ UPDATE VIEW-ORIGIN X

            prefWidth   := self preferredWidth.
            newOrgX := (prefWidth - self innerWidth) max:0.

            newOrgX < oldOrgX ifTrue:[
                self originWillChange.
                viewOrigin := newOrgX @ (viewOrigin y).
                self originChanged:((newOrgX - oldOrgX) @ 0).
            ]
        ].

        "/ cg: do not scroll to selection when a column-size is changed

"/        self hasSelection ifTrue:[
"/            editView notNil ifTrue:[
"/                editView width:(self selectedColumn width - (2 * separatorSize)).
"/            ].
"/            self scrollToSelection.
"/        ].

        "/ ca: but resize the editView (if there is any currently visible)

        editView notNil ifTrue:[
            selectedColumn := self selectedColumn.
            selectedColumn notNil ifTrue:[
                editView width:(selectedColumn width - (2 * separatorSize)).
            ]
        ].
        oldWidth ~= self preferredWidth ifTrue:[
            self contentsChanged.
        ].
    ].
!

hasSelectables
    columnDescriptors do:[:aCol|
        (aCol rendererType == #rowSelector) ifFalse:[
            (aCol description canSelect) ifTrue:[^ true].
        ]
    ].
    ^ false.
!

maxViewOriginY
    "returns the maximum possible y of the view origin"
    
    |y|

    y := self heightOfContents - self innerHeight.
    ^ y max:0
!

updateEditViewOrigin
    "update origin of the editView"
    
    |x y|

    editView notNil ifTrue:[
        y := self yVisibleOfRowNr:(self firstIndexSelected).
        x := self xVisibleOfColNr:self selectedColIndex.
        editView origin:(x @ y + separatorSize).
    ].
!

xVisibleOfColNr:aColNr 
    "returns visible x assigned to a column number"
    
    |x 
     end "{ Class:SmallInteger }"|

    x := margin - viewOrigin x.
    aColNr > 1 ifTrue:[
        end := aColNr - 1.
        columnDescriptors 
            from:1
            to:end
            do:[:aCol | x := x + aCol width ]
    ].
    ^ x
!

xVisibleToColNr:x 
    "returns the column number for a physical x position.
     Returns nil if x is beyond the last column."
    
    |x0|

    x0 := x + viewOrigin x - margin.
    columnDescriptors keysAndValuesDo:[:index :aCol | 
        x0 := x0 - aCol width.
        x0 <= 0 ifTrue:[ ^ index ].
    ].
    ^ nil.

    "Modified: / 26-03-2007 / 15:22:01 / cg"
!

yVisibleOfRowNr:aRowNr 
    "returns visible y assigned to the row number"
    
    ^ (aRowNr - 1) * rowHeight + margin - viewOrigin y
!

yVisibleToRowNr:y 
    "returns the row number assigned to a physical y or nil"
    
    |rowNr|

    rowNr := (y + viewOrigin y - margin) // rowHeight + 1.
    (rowNr between:1 and:(list size)) ifTrue:[
        ^ rowNr
    ].
    ^ nil
! !

!DSVColumnView methodsFor:'queries'!

firstLineShown
    "for protocol-compat. with listviews"

    ^ self indexOfFirstRowShown
!

hasOpenEditor
    ^ editView notNil
!

indexOfFirstRowShown
    "returns the index of the first shown row"
    
    |idx|

    idx := (viewOrigin y // rowHeight) + 1.
    ^ (idx max:1)
!

indexOfLastRowShown
    "returns the index of the last shown row"
    
    |idx|

    idx := (viewOrigin y + height - 1 // rowHeight) + 1.
    ^ (idx min:list size)
!

isEnabled
    ^ enableChannel value ~~ false
!

isRowSelectable:aRowNumber 
    "returne true if a row number is selectable"
    
    (aRowNumber notNil and:[ aRowNumber ~~ 0 ]) ifTrue:[
        selectConditionBlock isNil ifTrue:[
            ^ true
        ].
        ^ (selectConditionBlock value:aRowNumber)
    ].
    ^ false
!

numberOfColumns
    "returns number of columns"
    
    ^ columnDescriptors size
!

numberOfRows
    "returns number of raws"
    
    ^ list size
!

rowHeight
    "get the height of the highest row in pixels"
    
    ^ rowHeight
!

separatorSize
    "returns vertical/horizontal size of a separator dependent on the
     3D effect."
    
    ^ separatorSize
!

size
    "returns number of raws"
    
    ^ list size
!

yVisibleToLineNr:yVisible
    ^ self yVisibleToRowNr:yVisible.
! !

!DSVColumnView methodsFor:'recomputation'!

hasPreferredExtent
    "returns true if preferred extent is accumulated"
    
    ^ cachedPreferredExtent notNil
!

preferredExtent
    "return my preferred extent"

    |numRows prefWidth prefHeight|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    "/ cg: you don't need two cached variables - do you ?
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    cachedPreferredExtent notNil ifTrue:[
        ^ cachedPreferredExtent
    ].

    "/ cg: ????? why 3
    prefWidth := 3.
    prefWidth := (columnDescriptors size - 1) max:0.  "/ for the separators
    columnDescriptors do:[:aCol | 
        minRowHeight := (aCol heightOfHighestRow) max:minRowHeight.
        prefWidth := prefWidth + (aCol minWidth max:5).
    ].
"/    rowHeight := (minRowHeight + separatorSize + verticalSpacing 
"/                + verticalSpacing + 1) 
"/                // 2 * 2.
    numRows := list size.

    rowHeight := (verticalSpacing + minRowHeight + verticalSpacing + separatorSize). 
    "/ no need for a separator after the last row.
    prefHeight := (numRows * rowHeight) - separatorSize.
    prefHeight := "(self preferredLabelViewHeight) +" separatorSize + prefHeight + separatorSize.

    cachedPreferredExtent := prefWidth @ prefHeight.
    ^ cachedPreferredExtent
!

preferredExtentChanged
    "called if the preferred extent changed"
    
    |x "{ Class:SmallInteger }"
     y "{ Class:SmallInteger }"|

    y := viewOrigin y.
    x := viewOrigin x.
    (y ~~ 0 or:[ x ~~ 0 ]) ifTrue:[
        self originWillChange.
        viewOrigin := 0 @ 0.
        cachedPreferredExtent := nil.
        self originChanged:(x negated @ y negated).
    ]
!

recomputeHeightOfContents
    "recompute height of contents( scrolling )"

    cachedPreferredExtent := nil.
"/    cachedPreferredExtent notNil ifTrue:[
"/        cachedPreferredExtent y:(rowHeight * list size)
"/    ] ifFalse:[
"/        self preferredExtent
"/    ].
! !

!DSVColumnView methodsFor:'scroller interface'!

innerHeight
    "returns the inner height of the contents shown"
    
    ^ height - margin - margin
!

verticalScrollStep
    "return the amount to scroll when stepping up/down (also used for mouseWheel)."
    
    ^ rowHeight
!

viewOrigin
    "return the viewOrigin; 
     that's the coordinate of the contents which is shown topLeft in the view."
    
    ^ viewOrigin
!

widthOfContents
    "return the width of the contents in pixels"
    
    cachedPreferredExtent isNil ifTrue:[
        self preferredExtent
    ].
    ^ cachedPreferredExtent x
!

xOriginOfContents
    "return the horizontal origin of the contents in pixels"
    
    ^ viewOrigin x
!

yOriginOfContents
    "return the vertical origin of the contents in pixels"
    
    ^ viewOrigin y
! !

!DSVColumnView methodsFor:'scrolling'!

scrollTo:anOrigin redraw:doRedraw
    "change origin to have newOrigin be visible at the top-left."

    |newOrg dltOrg wg
     h       "{ Class:SmallInteger }"
     w       "{ Class:SmallInteger }"
     x       "{ Class:SmallInteger }"
     x0      "{ Class:SmallInteger }"
     x1      "{ Class:SmallInteger }"
     y       "{ Class:SmallInteger }"
     y0      "{ Class:SmallInteger }"
     y1      "{ Class:SmallInteger }"
     dX      "{ Class:SmallInteger }"
     dY      "{ Class:SmallInteger }"
     innerHG "{ Class:SmallInteger }"
     innerWT "{ Class:SmallInteger }"
     lMargin
    |

    shown ifFalse:[
        ^ self
    ].

    (wg := self windowGroup) notNil ifTrue:[
        wg processRealExposeEventsFor:self.
    ].

    innerWT := self innerWidth.
    innerHG := self innerHeight.

    h := viewOrigin y.

    (y := anOrigin y) > h ifTrue:[              "/ end of contents
        y > (dY := self maxViewOriginY) ifTrue:[
            y := dY max:h
        ]
    ] ifFalse:[
        y := y max:0.
    ].

    (x := anOrigin x) > 0 ifTrue:[
        x := x min:(self widthOfContents - innerWT).
    ].
    x      := x max:0.
    newOrg := (x @ y).
    dltOrg := newOrg - viewOrigin.
    dX     := dltOrg x.
    dY     := dltOrg y.

    (dX == 0 and:[dY == 0]) ifTrue:[
        ^ self
    ].
    self originWillChange.
    viewOrigin := newOrg.

    doRedraw ifFalse:[
        ^ self originChanged:dltOrg
    ].

    dY ~~ 0 ifTrue:[                            "/ SCROLL VERTICAL
        dY := dY abs.

        (dX ~~ 0 or:[innerHG - dY < 20]) ifTrue:[
            self invalidate.
        ] ifFalse:[                             "/ COPY VERTICAL
            y0 := y1 := margin + dY.
            h  := innerHG - dY.

            dltOrg y < 0 ifTrue:[y0 := margin. y := y0]
                        ifFalse:[y1 := margin. y := y1 + h].

            self copyFrom:self x:margin y:y0 toX:margin y:y1 width:innerWT height:h async:false.
            self invalidateX:margin y:y width:innerWT height:(innerHG - h).
        ]
    ] ifFalse:[                                 "/ SCROLL HORIZONTAL
        dX := dX abs.

        innerWT - dX < 20 ifTrue:[
            labelView invalidate.
            self invalidate.
        ] ifFalse:[                             "/ COPY HORIZONTAL
            x0 := x1 := dX + margin.
            w  := width - dX.
            lMargin := labelView margin.

            dltOrg x < 0 ifTrue:[
                " ->"
                x0 := x := margin. 
                self copyFrom:self x:margin y:margin toX:margin+dX y:margin width:innerWT-dX height:innerHG async:false.
                self invalidateX:margin y:margin width:dX height:innerHG.

                labelView notNil ifTrue:[
                    labelView copyFrom:labelView x:lMargin y:lMargin toX:lMargin+dX y:lMargin width:labelView innerWidth-dX height:labelView innerHeight async:false.
                    labelView invalidateX:lMargin y:lMargin width:dX height:labelView innerHeight.
                ].
            ] ifFalse:[
                x1 := margin. x := w.
                self copyFrom:self x:margin+dX y:margin toX:margin y:margin width:innerWT-dX height:innerHG async:false.
                self invalidateX:width-margin-dX y:margin width:dX height:innerHG.

                labelView notNil ifTrue:[
                    labelView copyFrom:labelView x:lMargin+dX y:lMargin toX:lMargin y:lMargin width:labelView innerWidth-dX height:labelView innerHeight async:false.
                    labelView invalidateX:labelView width-lMargin-dX y:lMargin width:dX height:labelView innerHeight.
                ].
            ].
            labelView repairDamage.
        ]
    ].
    self originChanged:dltOrg.

    wg notNil ifTrue:[
        wg processRealExposeEventsFor:self.
    ].

    "Modified: / 7.9.1998 / 16:39:49 / cg"
!

scrollToLine:aLineNr
    "for compat. with listViews"

    self scrollToRowAt:aLineNr colAt:1.
!

scrollToRowAt:aRowNr colAt:aColNr
    "make row at a row number in column at a column number visible"

    |x  "{ Class:SmallInteger }"
     y  "{ Class:SmallInteger }"
     l  "{ Class:SmallInteger }"
     dY "{ Class:SmallInteger }"
     dX "{ Class:SmallInteger }"
    |

    (    (aRowNr between:1 and:(list size))
     and:[aColNr between:0 and:(columnDescriptors size)]
    ) ifFalse:[
        ^ self
    ].

    dY := dX := 0.
    y  := self yVisibleOfRowNr:aRowNr.

    y < margin ifTrue:[
        dY := margin - y.
    ] ifFalse:[
        y := y + rowHeight.
        l := height - margin.
        y > l ifTrue:[dY := l - y]
    ].

    aColNr == 0 ifTrue:[
        dY == 0 ifTrue:[^ self].
        dX := 0.
    ] ifFalse:[
        x  := self xVisibleOfColNr:aColNr.

        x <= margin ifTrue:[
            dX := margin - x
        ] ifFalse:[
            x := x + (columnDescriptors at:aColNr) width.
            l := width - margin.
            x > l ifTrue:[dX := l - x]
        ]
    ].

    (dX == 0 and:[dY == 0]) ifFalse:[
        self scrollTo:(viewOrigin - (dX @ dY)).
    ]
!

scrollToSelection
    "make selection visible"

    |rowNr|

    (rowNr := self firstIndexSelected) ~~ 0 ifTrue:[
        self scrollToRowAt:rowNr colAt:self selectedColIndex
    ]
!

scrollVerticalTo:aPixelOffset
    "change origin to make aPixelOffset be the top line"

    |orgX orgY|

    orgX := viewOrigin x.
    scrollRowWise ifTrue:[
        orgY := (aPixelOffset + rowHeight - 1) // rowHeight * rowHeight.
    ] ifFalse:[
        orgY := aPixelOffset.
    ].
    ^ self scrollTo:(orgX @ orgY).
!

startAutoScroll:aSelectorOrBlock distance:aDistance
    "setup for auto-scroll (when button-press-moving below/above view);
     - timeDelta for scroll is computed from distance"

    |timeDelta scrollBlock|

    autoScroll ifFalse:[
        self stopAutoScroll.
        ^ self
    ].

    autoScrollBlock notNil ifTrue:[
        Processor removeTimedBlock:autoScrollBlock.
    ] ifFalse:[
        self compressMotionEvents:false.
    ].

    timeDelta := 0.5 / (aDistance abs).

    scrollBlock := 
        [
            aSelectorOrBlock isSymbol ifTrue:[
                self perform:aSelectorOrBlock.
            ] ifFalse:[
                aSelectorOrBlock value
            ].
            autoScrollBlock notNil ifTrue:[
                Processor addTimedBlock:autoScrollBlock afterSeconds:timeDelta.
            ]
        ].

    autoScrollBlock := [self sensor pushUserEvent:#value for:scrollBlock].
    Processor addTimedBlock:autoScrollBlock afterSeconds:timeDelta.
!

stopAutoScroll
    "stop any autoScroll"

    autoScrollBlock notNil ifTrue:[
        Processor removeTimedBlock:autoScrollBlock.
        autoScrollBlock := nil.
        self compressMotionEvents:true.
    ].
! !

!DSVColumnView methodsFor:'searching'!

findFirstColumnWithStringFrom:start to:stop
    start to:stop do:[:eachNr| 
        |row lbl|

        row := self at:eachNr.
        columnDescriptors keysAndValuesDo:[:colNr :col |    
            lbl := col shownValueForRow:row rowNr:eachNr.

            lbl isNonByteCollection ifTrue:[
                lbl := lbl isEmpty ifTrue:[nil] ifFalse:[lbl first].
            ].
            (lbl respondsTo:#string) ifTrue:[
                lbl := lbl string.
            ].
            (lbl size ~~ 0 and:[(lbl at:1) isCharacter]) ifTrue:[
                ^ colNr
            ]
        ]
    ].
    ^ nil
!

findFirstRowWithString: aString from:start to:stop by: step ignoreCase:ignoreCase
    "Return the rowNr from the first row that matches aString.
     The search is performed between the start and stop row numbers and incrementing by a step"

    |stringToMatch|

    aString isEmptyOrNil ifTrue:[
        ^ self
    ].
    stringToMatch := '*', aString, '*'.

    start to:stop by:step do:[:rowNr| 
        |row lbl|

        row := self at:rowNr.
        columnDescriptors keysAndValuesDo:[:colNr :col |    
            lbl := col shownValueForRow:row rowNr:rowNr.

            lbl isNonByteCollection ifTrue:[
                lbl := lbl isEmpty ifTrue:[nil] ifFalse:[lbl first].
            ].
            (lbl respondsTo:#string) ifTrue:[
                lbl := lbl string.
            ].
            lbl isNumber ifTrue:[
                lbl := lbl printString.
            ].

            (lbl size ~~ 0 
                and:[(lbl at:1) isCharacter 
                and:[stringToMatch match:lbl caseSensitive:ignoreCase not
            ]]) ifTrue:[
                ^ rowNr
            ]
        ]
    ].
    ^ nil
!

findFirstRowWithString: aString from:start to:stop ignoreCase:ignoreCase
    "Return the rowNr from the first row that matches aString.
     The search is performed between the start and stop row numbers"

    ^ self findFirstRowWithString:aString from:start to:stop by:1 ignoreCase:ignoreCase
! !

!DSVColumnView methodsFor:'selection'!

addRowToSelection:aRowNr 
    "add a row to the selection
     if a column is selected, the column will be closed"
    
    |newSelection|

    (self isRowSelectable:aRowNr) ifFalse:[
        ^ self
    ].
    self numberOfSelections == 0 ifTrue:[
        self selectColIndex:0 rowIndex:aRowNr.
        ^ self
    ].
    (self isInSelection:aRowNr) ifTrue:[
        ^ self
    ].
    multipleSelectOk ifFalse:[
        self selectColIndex:0 rowIndex:aRowNr.
        ^ self
    ].
    newSelection := selectedRowIndex copyWith:aRowNr.
    self selectedColIndex ~~ 0 ifTrue:[
        self selectColIndex:0 rowIndex:newSelection.
    ] ifFalse:[
        selectedRowIndex := newSelection.
        self invalidateRowAt:aRowNr.
        self selectionChanged.
    ].
!

deselect
    self selectColIndex:0 rowIndex:0
!

firstIndexSelected
    "returns index of first row selected or 0"

    multipleSelectOk ifFalse:[
        ^ selectedRowIndex
    ].
    selectedRowIndex size ~~ 0 ifTrue:[
        ^ selectedRowIndex at:1
    ].
    ^ 0
!

forceAcceptInEditor
    editView notNil ifTrue:[
        editView 
            allSubViewsDo:[:aSubView | 
                (aSubView respondsTo:#accept) ifTrue:[
                    aSubView accept
                ].
            ]
    ]
!

hasRowSelection
    "returns true if a selection exists, and its a complete row
     (as opposed to either no selection, or a columnSelection)"
    
    ^ self hasSelection and:[ self selectedColIndex == 0 ]
!

hasSelection
    "returns true if a selection exists"

    ^ self numberOfSelections ~~ 0
!

isInSelection:aRowNr
    "returns true, if row, aRowNr is in the selection"

    aRowNr ~~ 0 ifTrue:[
        multipleSelectOk ifFalse:[
            ^ aRowNr == selectedRowIndex
        ].
        selectedRowIndex size ~~ 0 ifTrue:[
            ^ selectedRowIndex includes:aRowNr
        ]
    ].
    ^ false
!

isRowSelected:aRowNr 
    "returns true, if row is in the selection"
    
    self selectedColIndex == 0 ifTrue:[
        ^ self isInSelection:aRowNr
    ].
    ^ false
!

isRowVisible:aRowNr
    |y h|

    h := rowHeight.
    y := self yVisibleOfRowNr:aRowNr.

    y < margin ifTrue:[
        (h := h + y) <= margin ifTrue:[
            ^ false
        ].                                            
    ] ifFalse:[
        y >= (height-margin) ifTrue:[^ false].
    ].
    ^ true
!

isSelected:aRowNr inColumn:aColNr 
    "returns true if cell in a row; a row number, in a column, a column
     number is selected."
    
    multipleSelectOk ifFalse:[
        aRowNr ~~ selectedRowIndex ifTrue:[
            ^ false
        ]
    ] ifTrue:[
        (selectedRowIndex size ~~ 0 and:[ selectedRowIndex includes:aRowNr ]) ifFalse:[
            ^ false
        ]
    ].
    ^ (self selectedColIndex == 0 or:[ self selectedColIndex == aColNr ])
!

isSelectionVisibleIn:anExtentPoint
    self selectionIndicesDo:[:selRowNr |
        |y|

        y := self yVisibleOfRowNr:selRowNr.
        (y between:margin and:(anExtentPoint y - margin)) ifTrue:[^ true].
    ].
    ^ false.
!

lastIndexSelected
    "returns index of last selected row or 0"

    multipleSelectOk ifFalse:[
        ^ selectedRowIndex
    ].
    selectedRowIndex size ~~ 0 ifTrue:[
        ^ selectedRowIndex last
    ].
    ^ 0
!

makeLineVisible:aLine 
    "scroll to make aLine visible"
    
    |colNr|

    aLine == 0 ifTrue:[
        ^ self
    ].
    (self isRowVisible:aLine) ifTrue:[
        ^ self
    ].
    (self selectedColIndex notNil and:[ self selectedColIndex ~~ 0 ]) ifTrue:[
        colNr := self selectedColIndex
    ] ifFalse:[ colNr := 1 ].
    self scrollToRowAt:aLine colAt:colNr
!

makeSelectionVisible
    "scroll to make the selection line visible"
    
    |rowNr colNr|

    rowNr := self firstIndexSelected.
    rowNr == 0 ifTrue:[
        ^ self
    ].
    (self selectedColIndex notNil and:[ self selectedColIndex ~~ 0 ]) ifTrue:[
        colNr := self selectedColIndex
    ] ifFalse:[ colNr := 1 ].
    self scrollToRowAt:rowNr colAt:colNr
!

maxIndexSelected
    "return the largest index selected or 0"

    multipleSelectOk ifFalse:[
        ^ selectedRowIndex
    ].
    selectedRowIndex size ~~ 0 ifTrue:[
        ^ selectedRowIndex max
    ].
    ^ 0
!

minIndexSelected
    "return the smallest index selected or 0"

    multipleSelectOk ifFalse:[
        ^ selectedRowIndex
    ].
    selectedRowIndex size ~~ 0 ifTrue:[
        ^ selectedRowIndex min
    ].
    ^ 0
!

numberOfSelections
    "return the number of selected rows"

    multipleSelectOk ifFalse:[
        ^ selectedRowIndex ~~ 0 ifTrue:[1] ifFalse:[0]
    ].
    ^ selectedRowIndex size
!

openEditorOnSelection
     |colIdx column rowIdx editorAndModel winGroup
      editor filter keyBrdFwd selColor|

    (shown and:[editView isNil]) ifFalse:[
        ^ self
    ].
    winGroup := self windowGroup.
    winGroup isNil ifTrue:[^ self ].

    colIdx := self selectedColIndex ? 0.
    column := self columnDescriptorAt:colIdx.
    column isNil ifTrue:[^ self].

    rowIdx := self selectedRowIndex ? 0.
    rowIdx == 0 ifTrue:[^ self ].

    rowIdx isSequenceable ifTrue:[
        rowIdx := rowIdx at:1 ifAbsent:[ ^ self ].
    ].

    editorAndModel := column editorForRowAt:rowIdx.      
    editorAndModel isNil ifTrue:[^ self].

    autoScrollToColumn == true ifTrue:[
        self scrollToRowAt:rowIdx colAt:colIdx.
    ].

    editView := SimpleView 
                extent:((column width - (2 * separatorSize)) 
                        @ (rowHeight - (2 * separatorSize)))
                in:self.

    self updateEditViewOrigin.

    (column containsText or:[ column showSelectionHighLighted not ]) ifTrue:[
        selColor := (column backgroundColorAt:rowIdx)
    ] ifFalse:[
        selColor := selectionBackgroundColor
    ].
    editView viewBackground:selectionBackgroundColor.

    editor := editorAndModel editor.
    editView add:editor.
    editorAndModel editorNeedsCursorKeys ifTrue:[
        editorAndModel editorNeedsReturnKey ifTrue:[
            "/ only steal TAB from the editor
            filter := [:aKey | #( #Tab #NonInsertingTab #BackTab ) includes:aKey ]
        ] ifFalse:[
            "/ steal TAB and RETURN from the editor
            filter := [:aKey | #( #Tab #NonInsertingTab #BackTab #Return ) includes:aKey ]
        ].
    ] ifFalse:[
        editorAndModel editorNeedsReturnKey ifTrue:[
            "/ only steal TAB and Curosr Keys from the editor
            filter := [:aKey | #( #Tab #NonInsertingTab #BackTab #CursorUp #CursorDown ) includes:aKey ]
        ] ifFalse:[
            "/ steal TAB, RETURN and Curosr Keys from the editor
            filter := [:aKey | #( #Tab #NonInsertingTab #BackTab #CursorUp #CursorDown #Return ) includes:aKey ]
        ].
    ].
    keyBrdFwd := KeyboardForwarder 
                toView:self
                condition:nil
                filter:filter.
    editView 
        withAllSubViewsDo:[:aView | 
            aView delegate:keyBrdFwd.
            aView font:self font.
        ].

    (editValue := editorAndModel model) notNil ifTrue:[
        editValue addDependent:self.
    ].
    editView realize.
    editor canTab:true.

    winGroup focusView:editor.

    self processAllExposeEvents.

    "Modified: / 02-11-2010 / 22:04:01 / cg"
!

processAllExposeEvents
    |sensor|

    sensor := self sensor.
    [ 
        sensor hasExposeEventFor:nil
    ] whileTrue:[
        self windowGroup processExposeEvents
    ].















!

removeRowFromSelection:aRowNr
    "remove a row from the selection"

    (self isInSelection:aRowNr) ifFalse:[^ self].

    self numberOfSelections == 1 ifTrue:[
        self deselect.
    ] ifFalse:[
        selectedRowIndex := selectedRowIndex copyWithout:aRowNr.
        self invalidateRowAt:aRowNr.
        self selectionChanged.
    ].
!

selectAllRows
    "select all"

    multipleSelectOk ifFalse:[^ self].

    selectedRowIndex := (1 to:list size) select:[:idx| self isRowSelectable:idx ].
    self selectionChanged.
    self invalidate.
!

selectColIndex:aColNr rowIndex:aRowNr
    "change selection with notification"

    self selectColIndex:aColNr rowIndex:aRowNr openEditor:true.
!

selectColIndex:aColNr rowIndex:aRowNr openEditor:openEditor
    "change selection with notification"

    |oC oR|

    oC := self selectedColIndex.
    oR := self selectedRowIndex.

    self setSelectColIndex:aColNr rowIndex:aRowNr openEditor:openEditor.

    (oC ~~ self selectedColIndex or:[oR ~= self selectedRowIndex]) ifTrue:[
        self selectionChanged:aColNr
    ].
!

selectRow:something
    "select a row"

    ^ self selectedRowIndex:something
!

selectRowAt:rowNr colAt:colNr atPoint:aPoint
    self selectRowAt:rowNr colAt:colNr atPoint:aPoint openEditor:true.
!

selectRowAt:rowNr colAt:colNr atPoint:aPoint openEditor:openEditor
    |view p shouldClick editorType|

    view := editView.
    self selectColIndex:colNr rowIndex:rowNr openEditor:openEditor.
    openEditor ifFalse:[ ^ self ].

    editView isNil ifTrue:[
        "/ might be a reselection
        self openEditorOnSelection.
        editView isNil ifTrue:[^ self].
    ] ifFalse:[
        editView == view ifTrue:[^ self].
    ].
    view := self detectViewAt:aPoint ignoreInvisible:true.

    shouldClick := true.
    "/ when PreselectAllWhenOpeningEditor is true, we should not click into
    "/ the editor, as this couldclear the selection.
    "/ however, for non-text editors, it is a good idea to do so...
    PreselectAllWhenOpeningEditor == true ifTrue:[
        shouldClick := false.

        editorType := self selectedColumn editorType.
        editorType == #ComboList ifTrue:[ shouldClick := true ].
        "/ TODO: more heuristics here...
        "/ editorType == #RadioButton ifTrue:[ ].
    ].

    shouldClick ifTrue:[
        "/ simulate clicking into the editor
        self breakPoint:#ca.
        (view ~~ self and:[view notNil]) ifTrue:[ 
            p := device translatePoint:aPoint fromView:self toView:view.
            self sensor 
                    pushEvent:(WindowEvent   buttonPress:1 x:p x y:p y view:view);
                    pushEvent:(WindowEvent buttonRelease:1 x:p x y:p y view:view).

"/        "/ a very special hack for radioButtons:
"/        "/ if the button is now on, all other cells must be turned off !!
"/        self selectedColumn editorType == #RadioButton ifTrue:[
"/            1 tolist size do:[:eachRowNr |
"/                eachRowNr ~~ rowNr ifTrue:[
"/                    self at:eachRowNr put:false
"/                ].
"/            ].
"/        ].
        ].
    ].

    "Modified: / 07-09-2011 / 16:08:45 / cg"
!

selectRowFrom:start to:stop 
    |step oldSelection newSelection|

    start == stop ifTrue:[
        self selectColIndex:0 rowIndex:start.
        ^ self
    ].
    step := (start <= stop) ifTrue:1 ifFalse:-1.
    newSelection := (start to:stop by:step) 
                select:[:idx | self isRowSelectable:idx ].
    self selectedColIndex ~~ 0 ifTrue:[
        self selectColIndex:0 rowIndex:newSelection.
        ^ self
    ].
    oldSelection := selectedRowIndex ? #().
    selectedRowIndex := newSelection.
    newSelection 
        select:[:i | (oldSelection includes:i) not ]
        thenDo:[:i | self invalidateRowAt:i ].
    oldSelection 
        select:[:i | (newSelection includes:i) not ]
        thenDo:[:i | self invalidateRowAt:i ].
    self selectionChanged.
!

selectRowIndex:something 
    "set selection of rows"
    
    self selectColIndex:self selectedColIndex rowIndex:something
!

selectedColIndex
    "returns selected column number or 0"

    ^ self selectedColIndexHolder value
!

selectedColumn
    "returns selected column or nil"
    
    ^ columnDescriptors at:self selectedColIndex ifAbsent:nil.
!

selectedRow
    "returns the selected row (or collection if multiple selection) or nil"
    
    multipleSelectOk ifFalse:[
        ^ self at:selectedRowIndex ifAbsent:nil
    ].
    selectedRowIndex size ~~ 0 ifTrue:[
        ^ selectedRowIndex collect:[:i | self at:i ]
    ].
    ^ nil
!

selectedRow:something 
    "select something"
    
    self selectedRowIndex:something
!

selectedRowIndex
    "returns selected row number or 0"
    
    ^ selectedRowIndex
!

selectedRowIndex:something 
    "set the row selection (single or multiple rows);
     does NOT change the selected column."
    
    self selectColIndex:self selectedColIndex rowIndex:something
!

selectionChanged
    "selection has changed"
    
    |val|

    model notNil ifTrue:[
        val := self selectedRowIndex copy.
        (model respondsTo:#selectionIndex:) ifTrue:[
            model selectionIndex:val
        ] ifFalse:[
            useIndex ifFalse:[
                model value:(self selectedRow)
            ] ifTrue:[
                model value:val
            ]
        ]
    ].
    actionBlock notNil ifTrue:[
        actionBlock valueWithOptionalArgument:(self selectedRowIndex)
    ]
!

selectionChanged:colNr
    "selection has changed"
    
    |val|

    model notNil ifTrue:[
        val := self selectedRowIndex copy.
        (model respondsTo:#selectionIndex:) ifTrue:[
            model selectionIndex:val
        ] ifFalse:[
            useIndex ifFalse:[
                model value:(self selectedRow)
            ] ifTrue:[
                model value:val
            ]
        ]
    ].
    actionBlock notNil ifTrue:[
        actionBlock valueWithOptionalArgument:(self selectedRowIndex) and:colNr
    ]
!

selectionIndicesDo:aOneArgBlock 
    "evaluate block on each row selected; the argument to the row
     is the index of the selected row"
    
    multipleSelectOk ifFalse:[
        selectedRowIndex ~~ 0 ifTrue:[
            aOneArgBlock value:selectedRowIndex
        ]
    ] ifTrue:[
        selectedRowIndex size ~~ 0 ifTrue:[
            selectedRowIndex do:aOneArgBlock
        ]
    ]
!

setSelectColIndex:colNrArg rowIndex:rowNrArg 
    "change selection without notification"

    self setSelectColIndex:colNrArg rowIndex:rowNrArg openEditor:true
!

setSelectColIndex:colNrArg rowIndex:rowNrArg openEditor:openEditor
    "change selection without notification"

    |rowNr colNr newCol oldCol oldRow sglSelRow oldSz winGroup|

    rowNr := self validateSelection:rowNrArg.
    colNr := colNrArg.
    rowNr == 0 ifTrue:[
        colNr := 0.
    ] ifFalse:[
        multipleSelectOk ifTrue:[
            (rowNr size == 1) ifFalse:[
                colNr := 0
            ]
        ].
    ].
    (colNr := colNr ? 0) ~~ 0 ifTrue:[
        newCol := self columnDescriptorAt:colNr.
        newCol rendererType == #rowSelector ifTrue:[
            colNr := 0.
            newCol := nil
        ] ifFalse:[
            multipleSelectOk ifTrue:[
                sglSelRow := rowNr at:1
            ] ifFalse:[
                sglSelRow := rowNr
            ].
            (newCol canSelect:sglSelRow) ifFalse:[
                newCol := nil.
                colNr := 0.
                selectRowOnDefault ifFalse:[
                    rowNr := multipleSelectOk ifTrue:[nil] ifFalse:[0]
                ]
            ]
        ]
    ].

    (rowNr = selectedRowIndex and:[ colNr == self selectedColIndex ]) ifTrue:[
        ^ self
    ].

    "/ release old selection

    oldSz := self numberOfSelections.
    oldCol := self selectedColIndex.
    oldRow := selectedRowIndex.
    oldSz == 1 ifTrue:[
        multipleSelectOk ifTrue:[
            oldRow := oldRow at:1
        ].
        self updateColumnFromEditValueAndDestroyEditView.
    ].
    rowNr ~= selectedRowIndex ifTrue:[
        selectedRowIndex := rowNr.
        self selectionChanged:colNr.
    ].
    self selectedColIndex:colNr.
    shown ifFalse:[ ^ self ].

    winGroup := self windowGroup.
    winGroup isNil ifTrue:[^ self ].

    oldSz > 1 ifTrue:[
        "/ redraw old selection
        oldRow do:[:aRowNr | 
            "/ unselected if visible
            self invalidateRowAt:aRowNr colAt:0
        ]
    ] ifFalse:[
        oldSz == 1 ifTrue:[
            self invalidateRowAt:oldRow colAt:oldCol
        ]
    ].

    "/ show new selection

    newCol notNil ifTrue:[
        openEditor ifTrue:[
            self openEditorOnSelection.
            editView notNil ifTrue:[^ self].
        ].
        self invalidateRowAt:sglSelRow colAt:colNr.

        autoScrollToColumn == true ifTrue:[
            self scrollToRowAt:sglSelRow colAt:colNr.
        ].
    ] ifFalse:[
        self selectionIndicesDo:[:i | self invalidateRowAt:i colAt:0 ].
        self scrollToRowAt:(self firstIndexSelected) colAt:0
    ].

    self processAllExposeEvents.

    "Modified: / 12-07-2011 / 14:22:42 / cg"
!

updateColumnFromEditValueAndDestroyEditView
    |edValue selCol selRow|

    selCol := self selectedColIndex.
    selRow := selectedRowIndex.
    editValue notNil ifTrue:[
        editValue removeDependent:self
    ].
    editView notNil ifTrue:[
        self forceAcceptInEditor
    ].
    editValue notNil ifTrue:[
        edValue := editValue value.
        edValue isSequenceable ifTrue:[
            edValue size == 0 ifTrue:[
                edValue := nil
            ] ifFalse:[
                edValue isString ifFalse:[
                    edValue := edValue select:[:el | el notNil ].
                    edValue size == 0 ifTrue:[
                        edValue := nil
                    ]
                ]
            ]
        ].
        selRow isNumber ifFalse:[
            "/ ??? should we do ???:
            "/ selRow do:[:eachRow |
            "/     (self columnAt:selCol) at:eachRow put:edValue.
            "/ ]
            selRow := selRow first
        ].
        (self columnDescriptorAt:selCol) at:selRow put:edValue.
        modifiedChannel notNil ifTrue:[
            modifiedChannel value:true
        ].
        editValue := nil
    ].
    self destroyEditView.
!

validateSelection:aSelection
    |newSel|

    (list size == 0 or:[aSelection isNil or:[aSelection == 0]]) ifTrue:[
        ^ multipleSelectOk ifFalse:[0] ifTrue:[nil]
    ].

    newSel := aSelection.

    multipleSelectOk ifFalse:[
        newSel isInteger ifFalse:[
            newSel := self identityIndexOfRow:aSelection.
        ].
        ^ (self isRowSelectable:newSel) ifTrue:[newSel] ifFalse:[0].
    ].

    "multiple selection
    "
    aSelection size ~~ 0 ifTrue:[
        aSelection first isInteger ifTrue:[
            newSel := aSelection select:[:idx| self isRowSelectable:idx ].
        ] ifFalse:[
            newSel := aSelection 
                            collect:[:el| self identityIndexOfRow:el ]
                            thenSelect:[:idx| self isRowSelectable:idx ].
        ].
        newSel notEmpty ifTrue:[
            ^ newSel
        ].
    ] ifFalse:[
        newSel isInteger ifFalse:[
            newSel := self identityIndexOfRow:aSelection.
        ].
        (self isRowSelectable:newSel) ifTrue:[
            ^ Array with:newSel
        ]
    ].
    ^ nil
! !

!DSVColumnView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

