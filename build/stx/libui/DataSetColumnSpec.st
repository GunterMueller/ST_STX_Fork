"{ Encoding: utf8 }"

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

Object subclass:#DataSetColumnSpec
	instanceVariableNames:'id rawLabel label labelIsImage labelButtonType minWidth width
		usePreferredWidth menu editorType rendererType size type
		readSelector writeSelector printSelector selectSelector
		converterSelector showRowSeparator rowSeparatorSelector
		showSelectionHighLighted showColSeparator showComboFieldSelector
		formatString canSelect choices translatedChoices height
		backgroundColor foregroundColor foregroundSelector
		backgroundSelector doubleClickedSelector labelForegroundColor
		labelBackgroundColor labelFont labelActionSelector
		labelActionArgument labelAlignment columnAlignment translateLabel
		isResizeable numberOfRowsProbedForColumnSize
		longStringCompression visibilitySelector formatSelector minValue
		maxValue selectedForegroundColor selectedBackgroundColor
		selectedForegroundSelector selectedBackgroundSelector
		activeHelpKey activeHelpKeyForLabel isSortable sortSelector
		sortBlockSelector menuFromApplication drawSelector
		longStringCompressionAtLeft'
	classVariableNames:'DefaultIcon'
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

Object subclass:#EditorAndModel
	instanceVariableNames:'editor model'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DataSetColumnSpec
!

DataSetColumnSpec::EditorAndModel subclass:#StandardEditorAndModel
	instanceVariableNames:'editorType'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DataSetColumnSpec
!

DataSetColumnSpec::EditorAndModel subclass:#UserProvidedEditorAndModel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DataSetColumnSpec
!

!DataSetColumnSpec class methodsFor:'documentation'!

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
    describes one single column of a DataSetView.

    [Instance variables:]

        label                   <misc>          the label of the column
        labelIsButton           <Boolean>       label looks like a button
        width                   <Integer/nil>   the width of a fixed column; in case of
                                                nil or 0 the column width will be computed
                                                dependent on the contents
        minWidth                <Integer/nil>   makes sense if the width is set to 0 or nil.
                                                This is the minimum size required; no
                                                computation dependent on the contents.
                                                When resizing the view the column may grow
                                                or shrink to the mimimum width.
        height                  <Integer/nil>   preferred height (optional)
        menu                    <Selector/nil>  selector to get the menu for the selected
                                                cell (optional).
        choices                 <Selector/nil>  selector to get the collection of choice for
                                                a #ComboBox or #ComboList (optional).
        editorType              <Symbol>        editor type; #None #InputField #CheckToggle
                                                #ComboBox #ComboList. Or if the user wants to
                                                create its own editor, a selector with no args
                                                which returns the editor.
        rendererType            <Symbol>        description type: #Text #CheckToggle #ComboBox
                                                #ComboList
        readSelector            <Selector>      selector to get the value of a cell (required).
        writeSelector           <Selector/nil>  selector to set the value of a cell
                                                (derived from readSelector).
        printSelector           <Selector/nil>  selector to get the drawable value of a cell (optional).
        isResizeable            <Boolean>       true if the column is resizeable (default is true)
        showRowSeparator        <Boolean>       show row separator (horizontal).
        showColSeparator        <Boolean>       show column separator (vertical).
        canSelect               <Boolean>       entries into row are selectable or not.
        selectSelector          <Selector/nil>  selector to test whether a cell in the column is
                                                selectable; the 'canSelect' flag must be enabled.
        size                    <Integer/nil>   max size of an InputField, ComboBox or ComboList.
                                                0 or nil means unlimited.
        type                    <Symbol>        a type converter symbol used by the input field
                                                one of ( #string #password #number #numberOrNil 
                                                #symbolOrNil ).
        formatString            <String/nil>    string describing special formatting for an input
                                                field { #InputField #ComboBox #ComboList }
                                                !!!! float's are supported !!!!
        foregroundSelector      <Selector/nil>  selector which returns the foreground color for a
                                                cell (optional). If the selector is nil or returns
                                                nil, the default foreground color is set.
        backgroundSelector      <Selector/nil>  selector which returns the background color for a
                                                cell (optional). If the selector is nil or returns
                                                nil, the default background color is set.
        doubleClickedSelector   <Selector/nil>  selector which is evaluated on double click
                                                If the selector is nil, the view's double click
                                                action (if not nil) is performed.
        showSelectionHighLighted <Boolean>      true: change fg/bg color if selected 

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
        DataSetColumn
        DataSetView
        DSVColumnView
"
! !

!DataSetColumnSpec class methodsFor:'instance creation'!

label:aColumnLabel editorType:anEditorType selector:aReadWriteSelectorOrCollectionOfSelectors
    "instance creation; set renderType dependent on the editorType"

    |column slice|

    column := self new.
    slice  := self slices 
                        detect:[:aSlice| (aSlice at:1) == anEditorType ]
                        ifNone:#Text.

    column label:aColumnLabel.
    column editorType:anEditorType.
    column rendererType:(slice at:2).

    aReadWriteSelectorOrCollectionOfSelectors isSymbol ifTrue:[
        column readSelector:aReadWriteSelectorOrCollectionOfSelectors
    ] ifFalse:[
        aReadWriteSelectorOrCollectionOfSelectors size > 0 ifTrue:[
            column  readSelector:(aReadWriteSelectorOrCollectionOfSelectors at:1).
            aReadWriteSelectorOrCollectionOfSelectors size > 1 ifTrue:[
                column writeSelector:(aReadWriteSelectorOrCollectionOfSelectors at:2).
            ]
        ]
    ].
    ^ column
!

label:aColumnLabel selector:aReadWriteSelector
    "instance creation"

    ^ self label:aColumnLabel editorType:#None selector:aReadWriteSelector.
!

new
    "instance creation"

    ^ self basicNew initialize.
!

rowSelector
    "instance creation"

    |column|

    column := self new.
    column rendererType:#rowSelector.
    column editorType:#None.
    ^ column
! !

!DataSetColumnSpec class methodsFor:'constants'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DataSetColumnSpec defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DQDQDQDQ@@@QDQADQQD@@ADQADQDTP@@DQDPQDTQ@@@QDQDIDQD@@ADQDP$QDP@@CMCL2L4Q@@@L3
L3L3L3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 205 0 133 62 38 0 139 0 173 216 230]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@??3??O?<??3??O?<??3??O?<??0@@@@@@@@b') ; yourself); yourself]
!

slices
    "return the slices for the attribute sections in the TableColumnEditor"


"         ----------------------------------------------------------
          editorType            default rendererType    editor class
          ----------------------------------------------------------
"
    ^ #(
        ( #None                 #Text                   nil )
        ( #InputField           #Text                   EditField     )
        ( #CheckToggle          #CheckToggle            CheckToggle   )
        ( #RadioButton          #RadioButton            RadioButton   )
        ( #ComboBox             #ComboBox               ComboBoxView  )
        ( #ComboList            #ComboList              ComboListView )
        ( #PopUpList            #PopUpList              PopUpList )
        ( #None                 #rowSelector            nil )
       )
! !

!DataSetColumnSpec methodsFor:'accessing'!

activeHelpKey
    ^ activeHelpKey

    "Created: / 26-03-2007 / 13:38:03 / cg"
!

activeHelpKey:aSymbol
    activeHelpKey := aSymbol

    "Created: / 26-03-2007 / 13:41:46 / cg"
!

activeHelpKeyForLabel
    ^ activeHelpKeyForLabel ? activeHelpKey

    "Created: / 26-03-2007 / 13:38:03 / cg"
!

activeHelpKeyForLabel:aSymbol
    activeHelpKeyForLabel := aSymbol

    "Created: / 26-03-2007 / 13:41:46 / cg"
!

choices
    "selector to get the collection of choices for a #ComboBox or #ComboList"

    ^ choices
!

choices:aSelector
    "selector to get the collection of choices for a #ComboBox or #ComboList"

    aSelector notNil ifTrue:[choices := aSelector asSymbol]
                    ifFalse:[choices := nil].
!

columnAlignment
    "return the column's alignment, one of #left, #right, #center, #decimal or #decimalRight. 
     The default is #left."

    ^ columnAlignment ? #left
!

columnAlignment:how
    "specify how the label is to be aligned;
     Supports #left, #right, #center, #decimal and #decimalRight.
     The default is #left."

    columnAlignment := how
!

drawSelector
    "Get the draw selector. If not nil, the view will draw cell contents using
     this message sent to the row-objects, passing arguments:
        - GC to draw on
        - x, y, width, height
        - col number (optional)

    "

    ^ drawSelector

    "Modified (comment): / 17-04-2013 / 12:52:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawSelector: aSymbol
    "Sets the draw selector. If not nil, the view will draw cell's contents using
     this message sent to the row-objects, passing arguments:
        - GC to draw on
        - x, y, width, height         
        - col number (optional)
    "

    drawSelector := aSymbol

    "Modified (comment): / 17-04-2013 / 12:52:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editorType
    "get the editor type or selector"

    ^ editorType
!

editorType:aType
    "set the editor type or selector"

    aType notNil ifTrue:[editorType := aType asSymbol]
                ifFalse:[editorType := #None].
!

formatSelector
    "selector to ask row for a print-format of a column (i.e. dynamic formatString)"

    ^ formatSelector
!

formatSelector:aSelectorOrNil
    "selector to ask row for a print-format of a column (i.e. dynamic formatString)"

    formatSelector := aSelectorOrNil
!

formatString
    "string describing special formatting for an input 
     field { #InputField #ComboBox #ComboList }."

    ^ formatString
!

formatString:aFormatString
    "string describing special formatting for an input 
     field { #InputField #ComboBox #ComboList }."

    |format|

    aFormatString size ~~ 0 ifTrue:[
        format := aFormatString withoutSeparators.

        format size == 0 ifTrue:[
            format := nil
        ]
    ].
    formatString := format
!

height
    "returns the fixed height of a cell (if >0)
     or 0 (ask each row),
     or -1/#fontHeight to use the font height
     or #heightOfFirstRow to assume all rows have the same height"

    ^ height
!

height:aHeight
    "set a fixed height of a cell (>0)
     or 0 (ask each),
     or -1/#fontHeight to use the font height
     or #heightOfFirstRow to assume all rows have the same height"

    height := aHeight ? 0
!

id
    "get the columns id"

    ^ id

    "Modified: / 19.5.1998 / 19:53:08 / cg"
    "Created: / 19.5.1998 / 20:27:10 / cg"
!

id:usuallyASymbol
    "set the columns id"

    id := usuallyASymbol

    "Modified: / 19.5.1998 / 19:53:08 / cg"
    "Created: / 19.5.1998 / 20:27:27 / cg"
!

isSortable
    ^ isSortable ? false
!

isSortable:something
    isSortable := something.
!

label
    "get the label or selector to access a label/bitmap. 
     To get the label to be shown, use: #rawLabel "

    ^ label
!

label:aLabel
    "set the label or selector to access the label/bitmap"

    label := aLabel
!

labelAlignment
    "align label left, right or center; default is center"

    ^ labelAlignment ? #center
!

labelAlignment:how
    "align label left, right or center; default is center"

    labelAlignment := how
!

labelFont
    ^ labelFont

!

labelFont:aFont
    labelFont := aFont

!

labelIsImage
    "returns true if label is an image"

    ^ labelIsImage ? false
!

labelIsImage:aBoolean

    labelIsImage := aBoolean
!

longStringCompression
    "if true, long strings are shown as 'x...', with x being the longest possible part of the string"
    
    ^ longStringCompression ? true
!

longStringCompression:aBoolean
    "if true, long strings are shown as 'x...', with x being the longest possible part of the string"

    longStringCompression := aBoolean
!

longStringCompressionAtLeft
    "if true, long strings are shown as '...x', with x being the longest possible right part of the string.
     If false (the default), long strings are compressed to 'x...', with x the longest possible left part"

    ^ longStringCompressionAtLeft ? false
!

longStringCompressionAtLeft:aBoolean
    "if true, long strings are shown as '...x', with x being the longest possible right part of the string.
     If false (the default), long strings are compressed to 'x...', with x the longest possible left part"

    longStringCompressionAtLeft := aBoolean
!

maxValue
    ^ maxValue
!

maxValue:something
    maxValue := something.
!

menu
    "selector to get the menu for the selected component"

    ^ menu
!

menu:aMenuSelector
    "selector to get the menu for the selected component"

    menu := aMenuSelector

    "Modified: / 25-10-2010 / 10:38:26 / cg"
!

menuForRow:aRow
    "OBSOLETE: returns the middle button menu or nil assigned to the row (cell)
    "
    ^ self menuForRow:aRow orAdaptor:nil
!

menuForRow:aRow inApplication:anApplication
    "OBSOLETE: returns the middle button menu assigned to the row (cell), or nil.
     If the menuSelector is a 0-arg selector, that message is sent to the row-object.
     If it's a 1-arg selector, the current application is passed as arg.
     This allows the item to return a menu with menuPerform already set."

    ^ self menuForRow:aRow orAdaptor:nil inApplication:anApplication

    "Modified (comment): / 13-02-2017 / 19:59:22 / cg"
!

menuForRow:aRow orAdaptor:anAdaptorOrNil
    "returns the middle button menu or nil assigned to the row (cell)"

    |m|

    menu notNil ifTrue:[
        menuFromApplication == true ifTrue:[
            m := nil. "/ anApplication menuFor:menu
        ] ifFalse:[
            m := self send:menu to:aRow orAdaptor:anAdaptorOrNil.
        ].
        m notNil ifTrue:[
            m isArray ifTrue:[
                m := m decodeAsLiteralArray.
            ].
            m receiver isNil ifTrue:[
                m receiver:(anAdaptorOrNil ? aRow)
            ]
        ].
    ].
    ^ m

    "Modified: / 25-10-2010 / 13:43:53 / cg"
!

menuForRow:aRow orAdaptor:anAdaptorOrNil inApplication:anApplication
    "returns the middle button menu or nil assigned to the row (cell).
     If the menuSelector is a 0-arg selector,
     that message is sent to the row-object.
     If it's a 1-arg selector, the current application is passed as arg.
     This allows the item to return a menu with menuPerform already set."

    |m|

    menu notNil ifTrue:[
        menuFromApplication == true ifTrue:[
            m := anApplication menuFor:menu
        ] ifFalse:[
            m := self send:menu with:anApplication to:aRow orAdaptor:anAdaptorOrNil.
        ].
"/        menu numArgs == 0 ifTrue:[
"/            m := aRow perform:menu
"/        ] ifFalse:[
"/            m := aRow perform:menu with:anApplication
"/        ].
        m notNil ifTrue:[
            m isArray ifTrue:[
                m := m decodeAsLiteralArray.
            ].
            m receiver isNil ifTrue:[
                m receiver:(anAdaptorOrNil ? aRow)
            ]
        ]
    ].
    ^ m

    "Modified: / 25-10-2010 / 10:40:30 / cg"
    "Modified (comment): / 13-02-2017 / 19:59:26 / cg"
!

menuFromApplication
    "true, if menu-selector is to be sent to the application instead of the row"

    ^ menuFromApplication ? false

    "Created: / 25-10-2010 / 10:36:46 / cg"
!

menuFromApplication:aBoolean
    "true, if menu-selector is to be sent to the application instead of the row"

    menuFromApplication := aBoolean

    "Created: / 25-10-2010 / 10:37:16 / cg"
!

minValue
    ^ minValue
!

minValue:something
    minValue := something.
!

minWidth
    "optional: if no width is specified and the column is asked for
     the widest row, this width is returned if not 0. Otherwise
     we sre going throught to each row and ask for the width."

    ^ minWidth ? 0
!

minWidth:aMinWidth
    "optional: if no width is specified and the column is asked for
     the widest row, this width is returned if not 0. Otherwise
     we sre going throught to each row and ask for the width."

    minWidth := aMinWidth ? 0
!

noScroll
    "not supported yet"

    ^ false
!

noScroll:aBoolean
    "not supported yet"
!

numberOfRowsProbedForColumnSize
    "only the first numberOfRowsProbedForColumnSize are probed when the column computes
     its size (width),
     In case the access is expensive (dataBase apps).
     The default is 15."

    ^ numberOfRowsProbedForColumnSize ? 15
!

numberOfRowsProbedForColumnSize:aNumberOrNil
    "only the first numberOfRowsProbedForColumnSize are probed when the column computes
     its size (width),
     In case the access is expensive (dataBase apps).
     The default is 15."

    (aNumberOrNil notNil and:[aNumberOrNil > 0]) ifTrue:[
        numberOfRowsProbedForColumnSize := aNumberOrNil.
    ] ifFalse:[
        numberOfRowsProbedForColumnSize := nil.
    ].
!

rawLabel
    "returns the label to be shown"

    self labelIsImage ifFalse:[
        ^ label
    ].
    rawLabel notNil ifTrue:[^ rawLabel].
    ^ self class defaultIcon

    "Modified: / 18-07-2011 / 09:32:48 / cg"
!

rawLabel:something
    "set the value of the instance variable 'rawLabel' (automatically generated)"

    rawLabel := something.
!

rendererType
    "get the discription type of any row"

    ^ rendererType
!

rendererType:aType
    "set the discription type of any row"

    aType notNil ifTrue:[rendererType := aType asSymbol]
                ifFalse:[rendererType := #Text].
!

size:aSize
    "maximum number of characters that are allowed in an input field.
     0 or nil means unlimited"

    size := aSize ? 0
!

translateLabel
    "get the translateLabel attribute (language string translation)"

    ^ translateLabel ? true

    "Created: / 19.5.1998 / 19:52:44 / cg"
    "Modified: / 19.5.1998 / 19:53:08 / cg"
!

translateLabel:aBoolean
    "set/clear the translateLabel attribute (language string translation)"

    translateLabel := aBoolean.

    "Created: / 19.5.1998 / 19:52:44 / cg"
    "Modified: / 19.5.1998 / 19:53:19 / cg"
!

translatedChoices
    "selector to get the collection of shown choices for a #ComboBox or #ComboList"

    ^ translatedChoices
!

translatedChoices:aSelector
    "selector to get the collection of shown choices for a #ComboBox or #ComboList"

    aSelector notNil ifTrue:[translatedChoices := aSelector asSymbol]
                    ifFalse:[translatedChoices := nil].
!

type
    "a type converter symbol"

    ^ type
!

type:aType
    "a type converter symbol"

    aType notNil ifTrue:[type := aType asSymbol]
                ifFalse:[type := #string]
!

usePreferredWidth
    "optional: the width is computed from the label and the first
     n entries"

    ^ usePreferredWidth ? false
!

usePreferredWidth:aBool
    "optional: the width is computed from the label and the first
     n entries"

    usePreferredWidth := aBool ? false
!

visibilitySelector
    "selector to get the visibility of a column (per row)"

    ^ visibilitySelector
!

visibilitySelector:aSelector
    "selector to get the visibility of a column (per row)"

    visibilitySelector := aSelector
!

width
    "get the width; in case that the width is 0 or nil, the width
     is recomputed dependent on the view width and the entries of
     the rows"

    ^ width ? 0
!

width:aWidth
    "set the width; in case that the width is 0 or nil, the width
     is recomputed dependent on the view width and the entries of
     the rows"

    width := aWidth ? 0.
! !

!DataSetColumnSpec methodsFor:'accessing-color & font'!

backgroundColor
    "get the user configured backgroundColor or nil"

    ^ backgroundColor
!

backgroundColor:aColor
    "set the user configured backgroundColor or nil"

    backgroundColor := aColor
!

foregroundColor
    "get the user configured foregroundColor or nil"

    ^ foregroundColor
!

foregroundColor:aColor
    "set the user configured foregroundColor or nil"

    foregroundColor := aColor
!

labelBackgroundColor
    ^ labelBackgroundColor
!

labelBackgroundColor:aColor
    labelBackgroundColor := aColor
!

labelForegroundColor
    ^ labelForegroundColor
!

labelForegroundColor:aColor
    labelForegroundColor := aColor
!

selectedBackgroundColor
    "get the user configured selectedBackgroundColor or nil"

    ^ selectedBackgroundColor
!

selectedBackgroundColor:aColor
    "set the user configured selectedbackgroundColor or nil"

    selectedBackgroundColor := aColor
!

selectedForegroundColor
    "get the user configured selectedForegroundColor or nil"

    ^ selectedForegroundColor
!

selectedForegroundColor:aColor
    "set the user configured selectedforegroundColor or nil"

    selectedForegroundColor := aColor
! !

!DataSetColumnSpec methodsFor:'accessing-selectors'!

backgroundSelector
    "selector which returns a background color for a cell or nil"

    ^ backgroundSelector
!

backgroundSelector:aSelector
    "selector which returns a background color for a cell or nil"

    aSelector isEmptyOrNil ifTrue:[
        backgroundSelector := nil
    ] ifFalse:[
        backgroundSelector := aSelector asSymbol
    ]
!

converterSelector
    "get the selector which returns a converter on a model or nil"

    ^ converterSelector
!

converterSelector:aSelector
    "set the selector which returns a converter on a model or nil"

    (aSelector notEmptyOrNil and:[aSelector argumentCount == 1]) ifTrue:[
        converterSelector := aSelector asSymbol.
    ].
    converterSelector := nil

    "Modified: / 08-03-2018 / 13:30:58 / stefan"
!

doubleClickedSelector
    "selector which is evaluated without an argument on the cell"

    ^ doubleClickedSelector
!

doubleClickedSelector:aSelector
    "selector which is evaluated without an argument on the cell"

    aSelector isEmptyOrNil ifTrue:[
        doubleClickedSelector := nil
    ] ifFalse:[
        doubleClickedSelector := aSelector asSymbol
    ]
!

foregroundSelector
    "selector which returns a foreground color for a cell or nil"

    ^ foregroundSelector
!

foregroundSelector:aSelector
    "selector which returns a foreground color for a cell or nil"

    aSelector isEmptyOrNil ifTrue:[
        foregroundSelector := nil
    ] ifFalse:[
        foregroundSelector := aSelector asSymbol
    ]
!

labelActionArgument
    "argument to labelSelectionSelector (optional)"

    ^ labelActionArgument
!

labelActionArgument:anArgument
    "argument to labelSelectionSelector (optional)"

    labelActionArgument := anArgument
!

labelActionSelector
    "selector which is evaluated with the 'labelActionArgument', column label or without an argumnent
     when the label is pressed."

    ^ labelActionSelector
!

labelActionSelector:aSelector
    "selector which is evaluated with the 'labelActionArgument', column label or without an argumnent
     when the label is pressed."

    aSelector isEmptyOrNil ifTrue:[
        labelActionSelector := nil
    ] ifFalse:[
        labelActionSelector := aSelector asSymbol
    ]
!

printSelector
    "get the printSelector or nil. If nil, the read selector will be used as fall back"

    ^ printSelector
!

printSelector:aSelector
    "set the printSelector. Called for drawable instance with argument
     a GC; as fault back the read operation will be used"

    aSelector isEmptyOrNil ifTrue:[
        printSelector := nil
    ] ifFalse:[
        printSelector := aSelector asSymbol
    ]
!

readSelector
    "get the readSelector (used to access columns)"

    ^ readSelector
!

readSelector:aSelector
    "set the readSelector (used to access columns)"

    aSelector isBlock ifTrue:[
        readSelector := aSelector
    ] ifFalse:[
        aSelector isEmptyOrNil ifTrue:[
            readSelector := nil
        ] ifFalse:[
            readSelector := aSelector asSymbol
        ]
    ]
!

rowSeparatorSelector
    "selector which returns false if the row separator to the
     next row is invisible"

    ^ rowSeparatorSelector
!

rowSeparatorSelector:aSelector
    "selector which returns false if the row separator to the
     next row is invisible"

    aSelector isEmptyOrNil ifTrue:[
        rowSeparatorSelector := nil
    ] ifFalse:[
        rowSeparatorSelector := aSelector asSymbol
    ]
!

selectSelector
    "the message selector send to the application when about to select a column.
     Should return true if a cell in the column is selectable, false otherwise."

    ^ selectSelector
!

selectSelector:aSelector
    "the message selector send to the application when about to select a column.
     Should return true if a cell in the column is selectable, false otherwise."

    aSelector isEmptyOrNil ifTrue:[
        selectSelector := nil.
    ] ifFalse:[
        selectSelector := aSelector asSymbol.

"/ cg: no longer a good test (columnAdaptor could be present)
"/        selectSelector numArgs == 0 ifFalse:[
"/            selectSelector := nil.
"/            self error:'selector must be for 0-arg message'
"/        ]
    ]

    "Modified: / 8.8.1998 / 13:47:51 / cg"
!

selectedBackgroundSelector
    "selector which returns a selected-background color for a cell or nil"
    
    ^ selectedBackgroundSelector
!

selectedBackgroundSelector:aSelector
    "selector which returns a selectedbackground color for a cell or nil"

    aSelector isEmptyOrNil ifTrue:[
        selectedBackgroundSelector := nil
    ] ifFalse:[
        selectedBackgroundSelector := aSelector asSymbol
    ]
!

selectedForegroundSelector
    "selector which returns a selected-foreground color for a cell or nil"
    
    ^ selectedForegroundSelector
!

selectedForegroundSelector:aSelector
    "selector which returns a selectedforeground color for a cell or nil"

    aSelector isEmptyOrNil ifTrue:[
        selectedForegroundSelector := nil
    ] ifFalse:[
        selectedForegroundSelector := aSelector asSymbol
    ]
!

showComboFieldSelector
    "selector which returns true if a field for a ComboBox is shown"

    ^ showComboFieldSelector
!

showComboFieldSelector:aSelector
    "selector which returns true if a field for a ComboBox is shown"

    showComboFieldSelector := aSelector
!

sortBlockSelector
    "selector used to fetch a sortBlock"
    
    ^ sortBlockSelector

    "Created: / 06-05-2010 / 10:19:31 / cg"
!

sortBlockSelector:aSymbol
    "selector used to fetch a sortBlock"
    
    sortBlockSelector := aSymbol

    "Created: / 06-05-2010 / 10:19:52 / cg"
!

sortSelector
    "selector used to get a comparable value from the row for sorting"
    
    ^ sortSelector

    "Modified: / 16-06-2010 / 15:56:21 / cg"
!

sortSelector:aSelector
    "selector which to get a comparable value from the row for sorting"

    aSelector isEmptyOrNil ifTrue:[
        sortSelector := nil
    ] ifFalse:[
        sortSelector := aSelector asSymbol
    ]
!

writeSelector
    "get the writeSelector. used to write back a value to the cell"

    writeSelector isNil ifTrue:[
        readSelector notNil ifTrue:[
            readSelector numArgs == 0 ifTrue:[
                writeSelector := readSelector asMutator
            ]
        ]
    ].
    ^ writeSelector
!

writeSelector:aSelector
    "set the writeSelector. used to wtite back a value to the cell"

    aSelector isBlock ifTrue:[
        writeSelector := aSelector
    ] ifFalse:[
        aSelector size == 0 ifTrue:[
            writeSelector := nil
        ] ifFalse:[
            writeSelector := aSelector asSymbol
        ]
    ]
! !

!DataSetColumnSpec methodsFor:'accessing-visibility'!

isResizeable
    "true: the label and thus all rows are resizable 
    "
    ^ isResizeable ? true
!

isResizeable:aBoolean
    "true: the label and thus all rows are resizable 
    "
    isResizeable := aBoolean.
!

labelButtonType
    ^ labelButtonType
!

labelButtonType:aType
    "#None, #Button or #Group"

    labelButtonType := aType.
!

labelIsButton
    "true if row label looks like a button; the default is true
    "
    ^ labelButtonType == #Button

    "Modified (comment): / 14-06-2018 / 08:33:46 / Claus Gittinger"
!

labelIsButton:aBoolean
    "true if row label looks like a button; the default is true
    "
    |type|

    type := aBoolean == false ifTrue:[#None] ifFalse:[#Button].
    self labelButtonType:type
!

showColSeparator
    "true if column seperator is shown; vertical line at the right side
     of the row; default is true"

    ^ showColSeparator
!

showColSeparator:aBoolean
    "true if column seperator is shown; vertical line at the right side
     of the row; default is true"

    showColSeparator := aBoolean ? true
!

showRowSeparator
    "true if row seperator is shown; horizontal line at the bottom
     of the row; default is true"

    ^ showRowSeparator
!

showRowSeparator:aBoolean
    "true if row seperator is shown; horizontal line at the bottom
     of the row; default is true"

    showRowSeparator := aBoolean ? true
!

showSelectionHighLighted
    "true: change fg/bg color if selected" 

    ^ showSelectionHighLighted
!

showSelectionHighLighted:aBoolean
    "true: change fg/bg color if selected"

    showSelectionHighLighted := aBoolean ? true
! !

!DataSetColumnSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray.
     Redefined to special-care for the label attribute"
    
    |selector value msg|

    2 to:aSpecArray size by:2 do:[:i |

        selector := aSpecArray at:i.
        (self respondsTo:selector) ifTrue:[
            value := aSpecArray at:i+1.
            (value isArray and:[selector == #label:]) ifFalse:[ 
                value := value decodeAsLiteralArray
            ].
            self perform:selector with:value
        ] ifFalse:[
            msg := '%1: unhandled literalArray attribute:'
                        bindWith:self class name
                        with:selector.

            UnhandledAttributeInLiteralArrayErrorSignal isHandled ifTrue:[
                UnhandledAttributeInLiteralArrayErrorSignal new
                    badLiteralArray:self; parameter:selector;
                    notify:msg.
            ] ifFalse:[
                msg infoPrintCR.
                self breakPoint:#cg info:('Unrecognized attribute in spec: #', selector).
            ].
        ].
    ].

"
#(#DataSetColumnSpec 
        #model: #'selectedStatusMessage operator' 
        #label: 'Op' 
        #labelIsImage: false 
        #width: 24 
        #rendererType: #InputField 
        #editorType: #ComboBox 
        #noScroll: false 
        #formatString: '0.0'
) decodeAsLiteralArray literalArrayEncoding

"

    "Modified: / 29.1.2000 / 22:59:21 / cg"
!

literalArrayEncoding
    "return myself encoded as a literal array"

    |coll val|

    coll := OrderedCollection new.
    coll add:#DataSetColumnSpec.

    label notNil ifTrue:[
        coll add:#'label:' ; add:(label isArray ifTrue:[label] ifFalse:[label literalArrayEncoding] ).

        id size > 0 ifTrue:[
            coll add:#id: ; add:(id literalArrayEncoding).
        ].
        self labelIsImage ifTrue:[
            coll add:#labelIsImage: ; add:true.
        ].
        (val := self translateLabel) ifFalse:[   "/ skip if true, which is the default
            coll add:#translateLabel: ; add:(val literalArrayEncoding).
        ].
        labelBackgroundColor notNil ifTrue:[
            coll add:#labelBackgroundColor: ; add:(labelBackgroundColor literalArrayEncoding).
        ].
        labelForegroundColor notNil ifTrue:[
            coll add:#labelForegroundColor: ; add:(labelForegroundColor literalArrayEncoding).
        ].
        labelFont notNil ifTrue:[
            coll add:#labelFont: ; add:(labelFont literalArrayEncoding).
        ].
        (val := self labelAlignment) ~~ #center ifTrue:[
            coll add:#labelAlignment: ; add:(val literalArrayEncoding).
        ]
    ].

    activeHelpKey notNil ifTrue:[
        coll add:#activeHelpKey: ; add:activeHelpKey.
    ].
    activeHelpKeyForLabel notNil ifTrue:[
        coll add:#activeHelpKeyForLabel: ; add:activeHelpKeyForLabel.
    ].

    coll add:#labelButtonType:; add:labelButtonType.

    labelActionSelector notNil ifTrue:[
        coll add:#labelActionSelector: ; add:(labelActionSelector literalArrayEncoding).

        labelActionArgument notNil ifTrue:[
            coll add:#labelActionArgument: ; add:(labelActionArgument literalArrayEncoding)
        ]
    ].
    (val := self isSortable) ifTrue:[   "/ skip if false, which is the default
        coll add:#isSortable: ; add:(val literalArrayEncoding).
        sortSelector notNil ifTrue:[
            coll add:#sortSelector: ; add:(sortSelector literalArrayEncoding)
        ].
        sortBlockSelector notNil ifTrue:[
            coll add:#sortBlockSelector: ; add:(sortBlockSelector literalArrayEncoding)
        ]
    ].

    (val := self columnAlignment) ~~ #left ifTrue:[
        coll add:#columnAlignment: ; add:(val literalArrayEncoding).
    ].

    (val := self longStringCompression) ifFalse:[
        coll add:#longStringCompression: ; add:false
    ].
    (val := self longStringCompressionAtLeft) ifTrue:[
        coll add:#longStringCompressionAtLeft: ; add:true
    ].
    (val := self usePreferredWidth) ifTrue:[
        coll add:#usePreferredWidth: ; add:true
    ].
    (val := self width) ~~ 0 ifTrue:[
        coll add:#width: ; add:(val literalArrayEncoding)
    ].
    (val := self minWidth) ~~ 0 ifTrue:[
        coll add:#minWidth: ; add:(val literalArrayEncoding)
    ].
    (val := self height) ~~ 0 ifTrue:[
        coll add:#height: ; add:(val literalArrayEncoding)
    ].
    editorType ~~ #None ifTrue:[
        coll add:#editorType: ; add:(editorType literalArrayEncoding)
    ].
    rendererType ~~ #Text ifTrue:[
        coll add:#rendererType: ; add:(rendererType literalArrayEncoding)
    ].
    (val := self size) ~~ 0 ifTrue:[
        coll add:#size: ; add:(val literalArrayEncoding)
    ].
    (val := self type) ~~ #string ifTrue:[
        coll add:#type: ; add:(val literalArrayEncoding)
    ].
    readSelector notNil ifTrue:[
        coll add:#model: ; add:(readSelector literalArrayEncoding)
    ].

    #(
        formatString
        formatSelector
        foregroundColor
        backgroundColor
        selectedForegroundColor
        selectedBackgroundColor
        choices
        translatedChoices
        menu
        menuFromApplication
        visibilitySelector
        converterSelector
        printSelector
        minValue
        maxValue
        doubleClickedSelector
        foregroundSelector
        backgroundSelector
        selectedForegroundSelector
        selectedBackgroundSelector
    ) do:[:eachVarName |
        |val|

        val := self instVarNamed:eachVarName.
        val notNil ifTrue:[
            coll add:eachVarName asMutator; 
                 add:(val literalArrayEncoding)
        ].
    ].

    writeSelector notNil ifTrue:[
        (    (readSelector size == (writeSelector size - 1))
        and:[writeSelector startsWith:readSelector]
        ) ifFalse:[
            coll add:#writeSelector:; 
                 add:(writeSelector literalArrayEncoding).
        ].
    ].
    self canSelect ifFalse:[
        coll add:#canSelect: ; 
             add:false
    ] ifTrue:[
        selectSelector notNil ifTrue:[
            coll add:#selectSelector: ; 
                 add:(selectSelector literalArrayEncoding)
        ].
        (     showComboFieldSelector notNil
         and:[(editorType == #ComboBox or:[editorType == #ComboBox])]
        )  ifTrue:[
            coll add:#showComboFieldSelector: ;
                 add:(showComboFieldSelector literalArrayEncoding)
        ]
    ].

    isResizeable == false ifTrue:[
        coll add:#isResizeable: ; 
             add:false
    ].

    self showRowSeparator ifFalse:[
        coll add:#showRowSeparator: ; 
             add:false
    ] ifTrue:[
        rowSeparatorSelector notNil ifTrue:[
            coll add:#rowSeparatorSelector: ; 
                 add:(rowSeparatorSelector literalArrayEncoding)
        ]
    ].

    self showSelectionHighLighted ifFalse:[
        coll add:#showSelectionHighLighted: ; 
             add:false
    ].

    self showColSeparator ifFalse:[
        coll add:#showColSeparator: ; 
             add:false
    ].

    ^ coll asArray

    "Modified: / 25-10-2010 / 10:43:40 / cg"
!

model:aReadSelector
    "used by builder
    "
    self readSelector:aReadSelector.
! !

!DataSetColumnSpec methodsFor:'editing'!

editorOn:aRow at:aRowNr column:aColumn value:aValue usingAdaptor:anAdaptorOrNil 
    "creates the editor for the row in a view and returns an editorAndModel object, or nil."

    |editor edType edClass editorsModel menu y slice field 
     choices shownChoices state model selectAllInitially|

    (edType := editorType) == #None ifTrue:[
        ^ nil
    ].

    selectAllInitially := false.

    slice := self class slices 
                detect:[:aSlice | (aSlice at:1) == edType] 
                ifNone:[nil].

    slice isNil ifTrue:[
        "/ edType is either a class-name (if uppercase)
        "/ or a selector to be sent to the row to either return
        "/ an editor instance, or an editorType symbol, or an editorClass class.
        edType isUppercaseFirst ifFalse:[
            editor := self send:edType to:aRow orAdaptor:anAdaptorOrNil.
            editor isNil ifTrue:[ ^ nil ].
            editor isBehavior ifTrue:[
                edClass := editor.
                editor := nil.
            ] ifFalse:[
                "/ the row or adaptor may return one of the standard-editor symbols
                editor isSymbol ifTrue:[
                    edType := editor.
                    editor := nil.
                ].
            ].
        ] ifTrue:[
            edClass := Smalltalk resolveName:edType inClass:(self class).
            edClass isNil ifTrue:[ ^ nil ].
        ].
        edClass notNil ifTrue:[
            editor := edClass new.
        ].
        editor notNil ifTrue:[
            editor geometryLayout:( LayoutFrame 
                                        leftFraction:0.0 rightFraction:1.0
                                        topFraction:0.0 bottomFraction:1.0 ).

            (editor isKindOf:EditField) ifTrue:[
                editor selectAllInitially.
            ].
            ^ UserProvidedEditorAndModel new editor:editor.
        ]
    ].

    (edType == #ComboList or:[edType == #ComboBox]) ifTrue:[
        showComboFieldSelector notNil ifTrue:[
            state := self send:showComboFieldSelector to:aRow orAdaptor:anAdaptorOrNil.
            state == false ifTrue:[
                edType := #ComboList
            ] ifFalse:[
                state == true ifTrue:[
                    edType := #ComboBox
                ]
            ]
        ].
    ].

    (edType == #ComboList 
     or:[edType == #ComboBox
     or:[edType == #PopUpList]]) 
    ifTrue:[
        "/ get choices
        (choices := self choicesFor:aRow at:aRowNr column:aColumn) isNil ifTrue:[
            "/ all but ComboBox cannot do anything, if there are none
            (edType ~~ #ComboBox) ifTrue:[
                ^ nil
            ].
            "/ ComboBox becomes InputField, if no choices are present
            edType := #InputField
        ] ifFalse:[
            shownChoices := self translatedChoicesFor:aRow at:aRowNr column:aColumn.
            shownChoices := shownChoices ? choices.    
        ].
    ].

    "/ refetch slice - could have changed
    slice := self class slices detect:[:aSlice| (aSlice at:1) == edType] ifNone:nil.
    slice isNil ifTrue:[ ^ nil ].

    "/ change to editTextView for multiple-line input
    (converterSelector isNil 
    and:[aValue isNonByteCollection]) ifTrue:[
        (edType == #InputField
        and:[aValue conform:[:el | el isNil or:[ el isString ] ]]
        ) ifTrue:[
            model  := ValueHolder with:aValue.
            editor := ScrollableView for:EditTextView miniScrollerH:true miniScrollerV:true.

            editor geometryLayout:( LayoutFrame
                                        leftFraction:0.0 rightFraction:1.0
                                        topFraction:0.0 bottomFraction:1.0 ).
            editor list:aValue.
            editor acceptAction:[:aContents|
                #todo. "/ cg: check if that is true: will remove empty lines. What if inner empty lines are wanted ?
                model value:(aContents select:[:el| el notNil]).
            ].
            ^ UserProvidedEditorAndModel new editor:editor model:model.
        ].
        model := ValueHolder with:(aValue at:1 ifAbsent:nil)
    ] ifFalse:[
        model  := ValueHolder with:aValue.
    ].

    editorsModel := model.
    editor := (Smalltalk classNamed:(slice at:3)) new.

    (edType == #ComboList or:[edType == #ComboBox]) ifTrue:[
        rendererType == #Text ifTrue:[
            "/ a little kludge here:
            "/ if rendererType is Text, make the Combos labels/fields 3D level
            "/ zero. Looks better.
            editor level:0; borderWidth:0.
            editor field level:0.
        ].
    ].

    (edType ~~ #CheckToggle and:[edType ~~ #RadioButton]) 
    ifTrue:[
        y := (1 + editor preferredHeight) // 2.
        editor geometryLayout:( LayoutFrame 
                                    leftFraction:0.0   offset:0
                                    rightFraction:1.0  offset:0
                                    topFraction:0.5    offset:y negated
                                    bottomFraction:0.5 offset:y ).

        choices notNil ifTrue:[
            editor list:choices.
            (edType == #ComboList or:[edType == #PopUpList]) ifTrue:[
                shownChoices notNil ifTrue:[
                    editor values:choices.
                    editor list:shownChoices.
                ].
                field := editor label
            ] ifFalse:[
                field := editor editor
            ]
        ] ifFalse:[
            "/ an EditField
            field := editor.
            "/ editor immediateAccept:true.
            editor acceptOnTab:true.
            editor acceptOnReturn:true.
            editor acceptOnLeave:true.
            editor acceptOnLostFocus:true.
            editor acceptOnPointerLeave:true.
            selectAllInitially := true.
        ].
        (size ~~ 0 and:[edType ~~ #ComboList]) ifTrue:[
            editor maxChars:size
        ].

        converterSelector notNil ifTrue:[
            editorsModel := self send:converterSelector with:model to:aRow orAdaptor:anAdaptorOrNil.
            editorsModel isNil ifTrue:[editorsModel := model].
        ] ifFalse:[
            (type ~~ #string and:[type ~~ #password]) ifTrue:[
                editorsModel := TypeConverter on:model.
                editorsModel perform:type.
            ] ifFalse:[
                type == #password ifTrue:[
                    editor bePassword
                ]
            ].
        ].
    ] ifFalse:[
        editor geometryLayout:( AlignmentOrigin new
                                    leftFraction:0.5;
                                    topFraction:0.5;
                                    leftAlignmentFraction:0.5;
                                    topAlignmentFraction:0.5 ).

        edType == #RadioButton ifTrue:[
            editor preferredExtent:editor extent.
        ].
    ].
    editor model:editorsModel.

    (menu := self menuForRow:aRow orAdaptor:anAdaptorOrNil) notNil ifTrue:[
        editor middleButtonMenu:menu
    ].
    selectAllInitially ifTrue:[
        editor selectAllInitially.
    ].
    ^ StandardEditorAndModel new editor:editor model:model editorType:edType.

    "Modified: / 26-09-1999 / 13:35:02 / cg"
    "Modified (format): / 12-07-2011 / 13:21:29 / cg"
!

editorOn:aRow column:aColumn value:aValue usingAdaptor:anAdaptorOrNil
    <resource: #obsolete>
 
    "creates the editor for the row in a view and returns an editorSpec"

    self obsoleteMethodWarning.
    ^ self 
        editorOn:aRow at:1
        column:aColumn value:aValue usingAdaptor:anAdaptorOrNil
!

row:aRow at:anIndex put:something
    |selector|

    selector := self writeSelector.

    "/ stupid: cannot use #perform:withOptionalArg - because of arg-order.
    selector argumentCount == 1 ifTrue:[
        aRow perform:selector with:something
    ] ifFalse:[
        aRow perform:selector with:anIndex with:something
    ]

    "Modified: / 08-03-2018 / 13:31:15 / stefan"
! !

!DataSetColumnSpec methodsFor:'initialization'!

initialize
    "setup default values"

    super initialize.

    editorType       := #None.
    rendererType     := #Text.
    showRowSeparator := true.
    showColSeparator := true.
    labelButtonType  := #Button.
    canSelect        := true.
    type             := #string.
    size             := 0.
    height           := #heightOfFirstRow.
    showSelectionHighLighted := true.
! !

!DataSetColumnSpec methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    (id ? label) storeOn:aStream.
    aStream nextPut:$).

    "Modified: / 17-04-2013 / 12:58:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DataSetColumnSpec methodsFor:'private'!

send:aSelector to:aRow orAdaptor:anAdaptorOrNil
    anAdaptorOrNil isNil ifTrue:[
        ^ aRow perform:aSelector
    ].

    ^ anAdaptorOrNil perform:aSelector withOptionalArgument:aRow
!

send:aSelector with:arg to:aRow orAdaptor:anAdaptorOrNil
    anAdaptorOrNil isNil ifTrue:[
        ^ aRow perform:aSelector withOptionalArgument:arg
    ].
    "/ stupid: cannot use #perform:withOptionalArg - because of arg-order.
    aSelector argumentCount == 1 ifTrue:[
        ^ anAdaptorOrNil perform:aSelector with:arg
    ].
    ^ anAdaptorOrNil perform:aSelector with:aRow with:arg

    "Modified: / 08-03-2018 / 13:31:24 / stefan"
! !

!DataSetColumnSpec methodsFor:'queries'!

canResize
    "returns true if the column is resizable
    "
    width := width ? 0.

    (rendererType ~~ #CheckToggle and:[rendererType ~~ #rowSelector]) ifTrue:[
        ^ width == 0 or:[self hasRelativeWidth "width isLimitedPrecisionReal"]
    ].
    ^ false
!

canSelect
    "returns true if cells are selectable
    "
    ^ canSelect ? true
!

canSelect:aBoolean
    "true if cells are selectable
    "
    canSelect := aBoolean
!

choicesFor:aRow
    choices notNil ifTrue:[
        ^ aRow perform:choices
    ].
    ^ nil
!

choicesFor:aRow at:aRowNr column:aColumn
    "invoked to retrieve a choice list for a comboList."

    choices notNil ifTrue:[
        ^ aColumn choicesFor:aRow at:aRowNr.
    ].
    ^ nil
!

choicesFor:aRow column:aColumn
    <resource: #obsolete>
    "invoked to retrieve a choice list for a comboList."

    self obsoleteMethodWarning.
    ^ self choicesFor:aRow at:1 column:aColumn
!

hasChoices:aRow
    ^ (self choicesFor:aRow) notNil
!

hasRelativeWidth
    "returns true if width is relative
    "
    ^ width isInteger not "/ width isLimitedPrecisionReal
!

labelHasButtonLayout
    ^ labelButtonType ~~ #None
!

labelIsPartOfGroup
    ^ labelButtonType == #Group
!

rowIsVisible:aRow
    visibilitySelector notNil ifTrue:[
        ^ aRow perform:visibilitySelector
    ].
    ^ true
!

size
    "maximum number of characters that are allowed in an input field.
     0 or nil means unlimited
    "
    ^ size 
!

translatedChoicesFor:aRow
    translatedChoices notNil ifTrue:[
        ^ aRow perform:translatedChoices
    ].
    ^ nil
!

translatedChoicesFor:aRow at:aRowNr column:aColumn
    "invoked to retrieve a choice list for a comboList."

    translatedChoices notNil ifTrue:[
        ^ aColumn translatedChoicesFor:aRow at:aRowNr.
    ].
    ^ nil
! !

!DataSetColumnSpec::EditorAndModel class methodsFor:'documentation'!

documentation
"
    argghhh - this is NOT a spec; instead it keeps the editor-view, the model
    and some more info.
    Thus it should be named an EditorInstanceInfoHolder or similar.
    please change.
"
! !

!DataSetColumnSpec::EditorAndModel methodsFor:'accessing'!

editor
    ^ editor
!

editor:something
    editor := something.
!

editor:editorArg model:modelArg 
    editor := editorArg.
    model := modelArg.
!

model
    ^ model
!

model:something
    model := something.
! !

!DataSetColumnSpec::EditorAndModel methodsFor:'queries'!

editorNeedsCursorKeys
    (editor isKindOf:EditField) ifTrue:[^ false ].

    "/ actually: don't know
    ^ true
!

editorNeedsReturnKey
    (editor isKindOf:EditField) ifTrue:[^ false ].

    "/ actually: don't know
    ^ true
!

isStandardEditorSpec
    ^ false
! !

!DataSetColumnSpec::StandardEditorAndModel class methodsFor:'documentation'!

documentation
"
    argghhh - this is NOT a spec; instead it keeps the editor-view, the model
    and some more info.
    Thus it should be named an EditorInstanceInfoHolder or similar.
    please change.
"
! !

!DataSetColumnSpec::StandardEditorAndModel methodsFor:'accessing'!

editor:editorArg model:modelArg editorType:editorTypeArg 
    editor := editorArg.
    model := modelArg.
    editorType := editorTypeArg.
!

editorType
    ^ editorType
!

editorType:something
    editorType := something.
! !

!DataSetColumnSpec::StandardEditorAndModel methodsFor:'queries'!

editorNeedsCursorKeys
    ^ false
!

editorNeedsReturnKey
    ^ false
!

isStandardEditorSpec
    ^ true
! !

!DataSetColumnSpec::UserProvidedEditorAndModel class methodsFor:'documentation'!

documentation
"
    argghhh - this is NOT a spec; instead it keeps the editor-view, the model
    and some more info.
    Thus it should be named an EditorInstanceInfoHolder or similar.
    please change.
"
! !

!DataSetColumnSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/DataSetColumnSpec.st,v 1.126 2018-06-14 09:38:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/DataSetColumnSpec.st,v 1.126 2018-06-14 09:38:02 cg Exp $'
! !

