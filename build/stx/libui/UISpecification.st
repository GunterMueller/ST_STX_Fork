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

Object subclass:#UISpecification
	instanceVariableNames:'otherAttributes name layout flags activeHelpKey attributes colors
		style uuid'
	classVariableNames:'FlagBorder FlagDisabled FlagHScroll FlagHScrollMini FlagInvisible
		FlagMenuBar FlagVScroll FlagVScrollMini'
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

IdentityDictionary subclass:#UIBindingsIdentityDictionary
	instanceVariableNames:'builder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UISpecification
!

Query subclass:#UIMajorKeyBindingNameSpaceQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UISpecification
!

!UISpecification class methodsFor:'documentation'!

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
    Instances (and derived instances) are used temporarily while a view
    is created from a spec. They collect attributes from a specArray and
    know how to create & initialize a view from those.

    They are not normally used by applications.

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

!UISpecification class methodsFor:'instance creation'!

from:aSpecOrSpecArray
    "create and return a new spec, given a literalArray encoding"

    aSpecOrSpecArray isArray ifTrue:[
        ^ aSpecOrSpecArray decodeAsLiteralArray
    ].
    ^ aSpecOrSpecArray

    "example from ClassChooser PD code:

        UISpecification from:
             #(#FullSpec 
                #window: 
                    #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #min: #(#Point 50 50 ) 
                        #bounds: #(#Rectangle 448 407 648 607 ) ) 
                #component: 
                    #(#SpecCollection
                        #collection: 
                            #(
                                #(#LabelSpec 
                                    #layout: #(#Point 0 2 ) 
                                    #label: 'Classes:' )
                                #(#SequenceViewSpec 
                                    #layout: #(#LayoutFrame 0 0 27 0 0 1 0 1 ) 
                                    #model: #classChoice 
                                    #tabable: false ) 
                                #(#InputFieldSpec 
                                    #layout: #(#LayoutFrame 70 0 2 0 0 1 25 0 )   
                                    #model: #classPattern ) ) ) )
    "

    "Modified: 13.2.1997 / 13:26:35 / cg"
!

fromView:aView
    "create and return a new instance, by walking over a view's hierarchy.
     (used by the UIPainters pick-a-view function)"

    ^ self
        fromView:aView callBack:nil

    "Modified: / 13-02-1997 / 13:24:33 / cg"
    "Modified (comment): / 31-08-2017 / 20:17:56 / cg"
!

fromView:aView callBack:aTwoArgCallBackBlock
    "create and return a new instance, by walking over a view's hierarchy.
     (used by the UIPainters pick-a-view function).
     For every created subSpec-element, the callBackBlock is evaluated,
     passing the specElement and the view as arguments.
     This can be used to fill in additional information, which cannot be
     extracted from the view (for example: names, aspects etc.).
     The callBack argument may be nil."

    |newSpec specClass viewClassName|

    self ~~ UISpecification ifTrue:[
        newSpec := self new fromView:aView callBack:aTwoArgCallBackBlock.
    ] ifFalse:[

        "/ to allow for ST-80 compatible renaming 
        "/ (for example: EditField vs. InputField),
        "/ we ask the view for its Spec-class first.
        "/ if it provides none, we take the view clases name,
        "/ append 'Spec' and look if that exists.
        "/ If still not, create an arbitrarySpec.
        "/

        (aView respondsTo:#specClass) ifTrue:[
            specClass := aView specClass
        ].
        aView superView isNil ifTrue:[
            specClass := FullSpec
        ].
        specClass isNil ifTrue:[
            viewClassName := aView class name.

            specClass := self resolveName:(viewClassName , 'Spec').
            specClass isNil ifTrue:[
                (viewClassName endsWith:'View') ifTrue:[
                    specClass := self resolveName:((viewClassName copyButLast:4), 'Spec').
                ].
                specClass isNil ifTrue:[
                    specClass := ArbitraryComponentSpec
                ].
            ].
        ].
        newSpec := specClass fromView:aView callBack:aTwoArgCallBackBlock.
    ].

    ^ newSpec

    "Created: / 13-02-1997 / 13:24:07 / cg"
    "Modified (comment): / 31-08-2017 / 20:18:00 / cg"
!

fromViewWithLayout:aView
    |spec|

    spec := self fromView:aView callBack:nil.
    spec layoutFromView:aView.
    ^ spec

    "Modified: 13.2.1997 / 13:27:10 / cg"
!

label:l layout:ly
    ^ self new
        label:l;
        layout:ly;
        yourself

    "Created: 3.3.1997 / 22:14:19 / cg"
!

model:m label:l layout:ly
    ^ self new
        setModel:m;
        label:l;
        layout:ly;
        yourself

    "Created: 3.3.1997 / 22:11:12 / cg"
!

model:m label:l select:s layout:ly
    ^ self new
        setModel:m;
        label:l;
        select:s;
        layout:ly;
        yourself

    "Created: 3.3.1997 / 22:24:06 / cg"
!

model:m layout:ly
    ^ self new
        setModel:m;
        layout:ly;
        yourself

    "Created: 3.3.1997 / 22:10:56 / cg"
!

model:m menu:l layout:ly
    ^ self new
        setModel:m;
        menu:l;
        layout:ly;
        yourself

    "Created: 3.3.1997 / 22:13:53 / cg"
!

new
    ^ self basicNew initialize
! !

!UISpecification class methodsFor:'class initialization'!

initialize
    FlagVScroll := 1.
    FlagHScroll := 2.
    FlagMenuBar := 4.   
    FlagBorder := 8.
    FlagInvisible := 16.
    FlagDisabled := 32.
    FlagHScrollMini := 128. 
    FlagVScrollMini := 256.
! !

!UISpecification class methodsFor:'constants'!

flagBorder
    "return the bit mask of the border flag in the flags instVar"

    ^ FlagBorder

    "Created: 20.6.1997 / 11:18:10 / cg"
    "Modified: 20.6.1997 / 11:18:31 / cg"
!

flagDisabled
    "return the bit mask of the initially disabled flag in the flags instVar"

    ^ FlagDisabled

    "Modified: 20.6.1997 / 11:18:55 / cg"
    "Created: 20.6.1997 / 11:19:27 / cg"
!

flagHScroll
    "return the bit mask of the horizontalScrollable flag in the flags instVar"

    ^ FlagHScroll

    "Created: 20.6.1997 / 11:18:27 / cg"
!

flagHScrollMini
    "return the bit mask of the miniScrollerHorizontal flag in the flags instVar"

    ^ FlagHScrollMini
!

flagInvisible
    "return the bit mask of the initially invisible flag in the flags instVar"

    ^ FlagInvisible

    "Modified: 20.6.1997 / 11:18:55 / cg"
    "Created: 20.6.1997 / 11:19:19 / cg"
!

flagMenuBar
    "return the bit mask of the menuBar flag in the flags instVar"

    ^ FlagMenuBar

    "Created: 20.6.1997 / 11:18:49 / cg"
!

flagVScroll
    "return the bit mask of the verticalScrollable flag in the flags instVar"

    ^ FlagVScroll

    "Created: 20.6.1997 / 11:18:38 / cg"
    "Modified: 20.6.1997 / 11:18:55 / cg"
!

flagVScrollMini
    "return the bit mask of the miniScrollerVertical flag in the flags instVar"

    ^ FlagVScrollMini
! !

!UISpecification class methodsFor:'help'!

helpSpec
    "
     UIHelpTool openOnClass:UISpecification    
    "

    <resource: #help>

    ^ IdentityDictionary new addPairsFrom:#(

#acceptCallBack
'0 or 1-arg message, sent when text is accepted (arg is text)'

#acceptChannel
'Aspect selector or binding for a triggerValue to force accept'

#acceptIfUnchanged
'Accept even if text is unchanged'

#acceptImmediate
'Enable sending of the entered string to the model with every key press'

#acceptOnLeave
'Enable sending of the entered string to the model when field is left via a keyboard action'

#acceptOnLostFocus
'Enable sending of the entered string to the model when the field looses its input focus'

#acceptOnPointerLeaveFocus
'Enable sending of the entered string to the model when field is left via a mouse motion'

#acceptOnReturn
'Enable sending of the entered string to the model when the RETURN key is pressed'

#acceptOnTab
'Enable sending of the entered string to the model when the TAB key is pressed'

#accessTabMenuAction
'Message sent to the application to ask for a tab menu'

#action
'Message sent to the application when the widget is activated'

#actionArg
'Optional argument passed with the action message'

#actionCallBackSelector
'Message sent when the widget changes its state/value (optional arg is state)'

#allowDoIt
'DoIt is allowed (Danger - User can execute Smalltalk expressions)'

#appletParamText
'Paste the complete appletTAGs HTML text here (i.e. all from <applet> up to and including the </applet>). Press parse to extract all parameters from it.'

#appletTextParse
'Parse the appletTAG and fill the parameters directory from it'

#arbitraryView
'If lowercase, the message sent to ask the application for the view instance.\If uppercase, the name of the view class'

#archiveEntry
'The name of a zip-file archive, if the class(es) are to be loaded from a zip-archive'

#arrowButtonDirection
'Defines the direction of the arrow'

#autoHideScrollBars
'AutoHide mode (always / never / controlled by ViewStyle)'

#autoHideScrollBarsBoolean
'AutoHide scrollbars'

#autoRepeat
'Enable auto-repeat of the action as long as the button is pressed (Must be Trigger-on-Down)'

#autoScrollHorizontal
'Enable horizontal auto-scrollability to show the selection'

#backgroundChannel
'Aspect selector or binding for a background color holder'

#enableDisableColorChannel
'Aspect selector or binding for a boolean holder, which changes the color to the disabled/enabled color of buttons'

#backgroundColor
'Defines the background color of the widget'

#backgroundColorEntered
'Defines the background color when the mouse is in'

#barLevel
'Defines the 3D level of the separating bar between views'

#barWidth
'Defines the width of the separating bar between views (in pixels)'

#beDefault
'Show a default (-return) bitmap after the label'

#beDependentOfRows
'Make the widget dependent on each row (i.e. rows send change messages)'

#beforeOpenAction
'Message sent to the application right before opening the pulled widget'

#booleanHolder
'Aspect selector or binding for a boolean holder which enables the widget'

#booleanModel
'Aspect selector or binding for a holder on the boolean state'

#borderWidth
'Defines the width of the border (in pixels)\If empty, the widget''s default (from stylesheet) is taken.\If symbol, key defines styleSheet entry.\Use with care - may make UI look ugly in other view styles;\if you really want to specify, use a symbol and define in styleSheet.'

#buttonModelArg
'Value stored into the model when the button is pressed'

#canvas
'Aspect selector or binding for the widget placed into the notebook'

#canvasArgument
'An optional argument passed with the message'

#canvasInset
'Inset of canvas; a Point or Integer; leave blank for default'

#canvasSelector
'Message sent after opening the canvas'

#centerIcons
'Center icons horizontally'

#chartHolder
'Value holder on a chart description'

#chartLabel
'Label string shown with the chart'

#clientHolder
'Aspect selector or binding for a holder on the client application to be opened'

#clientKey
'Message sent to ask the master application for an application instance; (default: the master application itself)'

#codeBaseHolder
'The URL of the directory, where the classFile-file resides. If the classFile is located on the local machine, use\ file:/<fullPath>\ where fullPath is an absolute pathname. If it''s to be accessed via http, use\ http:/<host>/<relativePath>\ where relativePath is the path relative to the http''s top diretory on that host'

#codeFileEntry
'The name of the java classFile which contains the applets code. For example: ''ArcTest.class'''

#converter
'Aspect selector or binding providing an object-to-string converter (an instance of TypeConverter)'

#columnAdaptor
'Name of a method in the application which returns a column adaptor'

#columnButton
'Opens a Table Columns Builder'

#columnHolder
'Aspect selector or binding for a holder on the list of the column descriptions'

#componentsChangeSize
'Recompute layout when any component changes its size'

#converter
'Method in the application returning a typeconverter'

#createNewApplication
'Create a new appModel instance for the subCanvas (ClientHolder must be empty)'

#createNewBuilder
'Create a new builder instance for the subCanvas (subApp will use its own aspects)'

#dblClickChannel
'Aspect selector or binding for a holder on the double-clicked item'

#defaultLabel
'Default label (used, if nothing selected)'

#addTabAction
'Message sent to the application to add a tab (via add button).'

#destroyTabAction
'Message sent to the application to destroy a tab (via destroy button). Tab index is passed as optional argument.'

#disabledLabel
'The label of the widget shown when disabled'

#documentText
'Aspect selector or binding for a holder of the html document itself'

#documentURL
'Aspect selector or binding for a holder of the URL of the document'

#doubleClickSelector
'Message sent upon double click'

#downAction
'Message sent when the down(right)-button is pressed'

#dragDisplayObjects
'1-arg (the dropSource) message, to get the list of Objects displayed during dragging'

#dragDropObjects
'1-arg (the dropSource) message, to get the list of DropObjects'

#dragFeedBack
'Optional 1-arg (dropContext) message, to give feedBack of a finished drag operation'

#dragStart
'Optional 2-arg (dropSource and view) message, called to start your own drag handler'

#dragStartArgument
'Optional user defined argument stored in the DropSource'

#drawBoxChannel
'Boolean aspect which controls box-display'

#drawNormalsChannel
'Boolean aspect which controls normals-display'

#dropArgument
'Optional user defined argument stored in the DropTarget'

#dropCanCheck
'1-arg (dropContext) message, to ask if drop is allowed'

#dropEnter
'Optional 1-arg (dropContext) message, sent when entering the widget'

#dropLeave
'Optional 1-arg (dropContext) message, sent when leaving the widget'

#dropOver
'Optional 1-arg (dropContext) message, sent while moving over the widget'

#dropSelector
'1-arg (dropContext) message, to drop the collection of DropObjects'

#emptyFieldReplacementText
'This is shown when the field is empty and passive (typically some info shown in grey, such as "enter bla here")'

#translateEmptyFieldReplacementText
'Translate the empty-field text to a national string via the application''s resources'

#enableChannel
'Aspect selector or binding for a boolean holder which enables the widget'

#endMotionCallBack
'Message sent with end of thumb motion'

#entryCompletionBlock
'Message sent to the app to ask for an entry-completion block'

#escapeIsCancelInDialog
'If on, and the window is opened modal, the ESC-Key acts like a Cancel-action'

#fileSelectionFilterClas
'The name of the item class used to create the entries into the hierarchical list'

#fileSelectionTreeRoot
'Aspect selector or binding for a holder on the root directories path name'

#fitLastRow
'Resize the last row to fit the width of the widget'

#fontMenu
'Defines the font used by the widget.\Use with care - may make UI look ugly in other view styles.'

#forceRecursiveBackground
'If on, the background color is recursively set in all sub components'

#forceRecursiveBackgroundOfDefaultBackground
'If on, the background color is recursively set in all sub components with default background'

#foregroundChannel
'Aspect selector or binding for a foreground color holder'

#foregroundColor
'Defines the foreground (drawing) color of the widget'

#foregroundColorEntered
'Defines the foreground (drawing) color when the mouse is in'

#galleryLabels
'Aspect selector or binding for a holder on the label list'

#galleryModel
'Aspect selector or binding for the selected label'

#gallerySelection
'Aspect selector or binding for a holder which gets the windowSpec of the selected widget'

#gallerySelectors
'Message sent to ask the application for a list of resource spec selectors'

#glxGraphXMax
'range end x'

#glxGraphXMin
'range start x'

#glxGraphXStep
'range step x'

#glxGraphYMax
'range end y'

#glxGraphYMin
'range start y'

#glxGraphYStep
'range step y'

#handlePosition
'The postion of the handle (Default means: as specified by viewStyle)'

#has3Dseparators
'Enable 3D-look row/column separators'

#hasBorder
'Draw a border around the widget - ignored in 3D view styles (ST80 compatibility)'

#hasKeyboardFocusInitially
'Widget tries to take the focus (when app is started)'

#hierarchicalList
'Aspect selector or binding for a root item holder'

#hierarchicalListButton
'Opens a Hierarchical List Editor on the application class and the defined selector'

#highlightMode
'Defines how selected items are highlighted'

#holderToToggleVisibility
'Aspect selector or binding for a boolean to toggle visibility'

#horizontalLayout
'Defines how sub components are arranged horizontally'

#horizontalMiniScroller
'Use a mini-scroller as horizontal scrollbar'

#horizontalScroller
'Enable horizontal scrollability'

#horizontalSpace
'Horizontal space between subcomponents (in pixels)'

#id
'Unique symbolic name (ID) of the widget'

#ignoreReselect
'Ignore user reselecting the same item'

#image
'Message sent to ask the application for the image'

#indicatorClickSelector
'Message sent upon indicator click'

#initiallyDisabled
'Widget is initially disabled.\Can be ensabled by sending it #enable, or via a value holder in the enableChannel'

#reverseOrderIfOKAtLeft
'Reverse the order if the viewStyle has OK buttons at the left.\Use this for button panels of dialog boxes containing OK and Cancel buttons.\Please arrange OK buttons at the right here, and set this flag to reverse dynamically as required.\This is needed to avoid hard-coding any specifics of the underlying window system (Windows vs. XWindow)'

#ignoreInvisibleComponents
'Ignore invisible components in the layout computation'

#initiallyInvisible
'Widget is initially invisible.\Can be made visible by sending it #beVisible, or via a value holder in the visibilityChannel'

#inputFieldGroup
'Unique symbolic name (ID) for the group of the entry field'

#isMultiSelect
'Enable/disable multiple selections'

allowToggleSelect
'Enable/disable toggling a selected item (also: deselect)'

#isOpaque
'If on, the widget is displayed opaque; if off, its transparent'

#isTriggerOnDown
'If on, the button triggers its action when pressed. If off, it triggers on release'

#itemChildrenSelector
'Method in the application to return a block retrieveing nodes (lazy) children'

#itemContentsSelector
'Method in the application to return a block retrieveing a nodes (lazy) contents'

#itemIconSelector
'Method in the application to return a block retrieveing nodes (lazy) icon'

#itemLabelSelector
'Method in the application to return a block retrieveing nodes (lazy) label'

#keepCanvasAlive
'If on, the view is unmapped when switching; otherwise, its destroyed'

#keyboardStep
'Defines the step used with cursor keys'

#label
'The label of the widget'

#labelAlignment
'Specifies how the label''s logo is positioned within the Label.\left: left aligned\right: right aligned\centered: center; if multiline, center en-bloque\centerEach: center; if multiline, center each line individually\leftRight: left aligned; show right end if too long\rightLeft: right aligned; show left if too long\centerRight: centered; show right if too long\centerLeft: centered; show left if too long'

#labelChannel
'Aspect selector or binding for a labelString holder'

#labelIsImage
'Label is actually the selector of a message (to the app) providing an image-label'

#labelPositionList
'Defines the position of the label'

#lampColor
'Defines the lamps color'

#level
'Level of the 3D-border (in pixels or name in style-sheet)\positive sticks out; negative goes in.\If empty, the widget''s default (from stylesheet) is taken.\If symbol, key defines styleSheet entry.\Use with care - may make UI look ugly in other view styles;\if you really want to specify, use a symbol and define in styleSheet.'

#listHolder
'Aspect selector or binding for the list or list holder'

#majorKey
'Name of the class which provides the window spec. If empty, the application itself is used'

#maxChars
'Maximum number of characters in the field'

#maxMenuHeight
'Maximum height (in pixels) of the pulled menu'

#maxSize
'Those two fields specify the windows maximum size. The user will not be allowed to resize it to a larger size'

#maxValue
'An optional maximum value (if fieldType = numberInRange)'

#maxXField
'The maximum width of the applications topWindow'

#maxYField
'The maximum height of the applications topWindow'

#menuButton
'Open an editor on the menu'

#comboMenuButton
'Open an editor on the combo menu'

#openTabListEditor
'Open an editor on the tab list'

#menuId
'Aspect selector or binding providing the menu spec'

#menuPerformer
'Aspect selector or binding providing the receiver of menu messages'

#comboMenuId
'Aspect selector or binding providing the menu spec for the combo menu'

#comboMenuPerformer
'Aspect selector or binding providing the receiver of combo menu messages'

#middleButtonPressed
'Message sent when the middle button is pressed'

#minValue
'An optional minimum value (if fieldType = numberInRange)'

#minXField
'The minimum width of the applications topWindow'

#minYField
'The minimum height of the applications topWindow'

#minorKey
'Message sent to ask the class (major) for the window spec (default: #windowSpec)'

#model
'Aspect selector or binding providing the model of the widget'

#modifiedChannel
'Aspect selector or binding for a holder for the modified-flag'

#monitoring
'Enable automatic update whenever the directory is modified'

#monitoringDelayTime
'Time in seconds between updates (if monitoring is enabled)'

#moveSelectedRow
'Enable/disable automatic movement of the row containing the selected tab item'

#noMenuButton
'Do not show the pull-down-menu button'

#oneTabPerLine
'Arrange tabs vertically, with only one tab item per row'

#openSubSpecGuiHelp
'Opens a GUI Builder on the defined class and selector'

#orientation
'Defines the orientation (horizontal or vertical)'

#paramAdd
'Adds a name-value pair to the appletParameter collection'

#paramList
'Lists defined parameters'

#paramNameField
'The name of the appletParameter'

#paramRemove
'Removes that appletParameter'

#paramValueField
'The value of the appletParameter'

#possiblyScrollable
'Support scrolling of the embedded view (but only if the embedded application specifies so in its own window spec).'

#postBuildChannel
'1-arg message sent to the application after creation of this widget (arg is widget)'

#progressValueHolder
'Aspect selector or binding for a holder on the indicators value'

#radioButtonGroup
'Aspect selector or binding providing the radioButton group-model'

#radioButtonValue
'Value passed to the radioButton group-model'

#readOnly
'Make the contents be readOnly'

#regionType
'Defines the shape of the widget'

#resizeForLabel
'Enable/disable automatic resize after a label change'

#multiLineLabel
'The label may contain backslash-characters, which are translated to line breaks'

#resourceSelector
'Message sent to ask the application for a directory of keys and icons to register on the device'

#returnIsOKInDialog
'If on, and the window is opened modal, the Return/Enter-Key acts like an Accept-action'

#rowIfAbsent
'Message sent when an empty list entry is detected'

#scrollTabs
'Scroll Tabs (if too many) as opposed to showing multiple lines'

#scrollerValueHolder
'Aspect selector or binding for a holder on the scrollers value'

#selectConditionSelector
'Message sent to validate a selection (not selectable if false is returned)'

#selectInitially
'Text is initially selected'

#selectOnMenuButton
'Select item under mouse before opening the menu (always / never / controlled by ViewStyle)'

#selectRowOnDefault
'Select whole row, if unselectable column is selected'

#selectionHolder
'Aspect selector or binding for a holder on the selection'

#separatorOneDColor
'Defines the line color of the 1D-separator'

#setMaxExtent
'Pick the maximum extent from the canvases current extent'

#setMinExtent
'Pick the minimum extent from the canvases current extent'

#showBox
'Display a bounding box'

#showDirectoryIndicator
'Show/hide directory indicators for non-empty directories'

#showDirectoryIndicatorForRoot
'Show/hide the indicator for the most left item'

#showHandle
'Show resize-handles (Default means: as specified by viewStyle)'

#showIndicators
'Show/hide the indicators'

#showingCode
'Editor is showing code - enables additional menu functions (comment/uncomment etc.)'

#showLabels
'Show/hide column labels'

#showLamp
'Show/hide the colored lamp'

#showLines
'Show/hide connecting lines between tree items'

#showNormals
'Display normals'

#showPercentage
'Show/hide the percentage display'

#showRoot
'Show/hide the root item'

#showSeparatingLines
'Show/hide separated lines'

#sizeAsDefault
'Size the widget to include space for the default-(return) bitmap'

#sliderValueHolder
'Aspect selector or binding for a holder on the sliders value'

#snapMode
'Show a quick-resize snap handle'

#specHolder
'Aspect selector or binding for holding the selector returning a window specification'

#start
'Defines the ranges minimum'

#startMotionCallBack
'Message sent with start of thumb motion'

#step
'Defines the step increment/decrement value within the range'

#stepValue
'Defines the step increment/decrement value within the range'

#minValueOfRange
'Defines the minimum value'

#maxValueOfRange
'Defines the maximum value'

#stop
'Defines the ranges maximum'

#supportsExpandAll
'Enable/disable the expand-all function'

#tabIntern
'Tab into the widget; if off, TAB skips over the widget''s fields'

#tabLabelInset
'Inset of tab label; a Point or Integer; leave blank for default'

#tabLabels
'Message sent to ask the application for a list of tab-item-labels'

#tabLevel
'3D Level (in pixels) of frame and tabs; take widget''s default if left empty'

#tabBottomMargin
'Margin (in pixels) between tabs and canvas; take widget''s default if left empty'

#tabTopMargin
'Margin (in pixels) between tabs and outer frame; take widget''s default if left empty'

#tabLeftMargin
'Margin (in pixels) between the left border and the first tab'

#tabRightMargin
'Margin (in pixels) between the right border and the last tab'

#tabOrientation
'Defines the side for the arrangement of the tab items'

#tabWidget
'Defines the type of the border style of the tab items (Windows style vs. Mac style)'

#tabable
'Widget can be reached by pressing the TAB key'

#tabbedOverEndAction
'Message sent when the end was reached by tabbing'

#tabbedOverStartAction
'Message sent when the beginning was reached by tabbing'

#textModel
'Aspect selector or binding providing the model of the widget; (string-valued, unless a type/converter is given)'

#translateLabel
'Translate the label via the resource mechanism to a national language string'

#typeConverter
'Defines how the entry string is converted to an object which is passed to the model'

#upAction
'Message sent when the up(left)-button is pressed'

#useDefaultIcons
'If on, default icons are drawn for each item which donot provide its own icon'

#useIndex
'If on, use the item''s index as selection; if off, use the item''s value'

#usePreferredWidth
'Use the pulled widget''s preferred width (instead of my width)'

#usePreferredExtent
'If on, the window computes its preferred extent; if off, the layout-sections value is used'

#validateDoubleClickSelector
'Message sent to the application to validate double click (no action if false is returned)'

#validateExpandabilitySelector
'Message sent to the application to validate expand on double click (no expand if false is returned)'

#valueChangeSelector
'Message sent to the application when the selection has changed'

#valueChangeCallBackSelector
'Message sent to the application when the model value has changed'

#verticalLayout
'Defines how sub components are vertically arranged'

#verticalMiniScroller
'Use a mini-scroller as vertical scrollbar'

#verticalScroller
'Enable vertical scrollability'

#verticalSpace
'Vertical space between the sub components (in pixels)'

#viewChannel
'Aspect selector or binding for a holder which provides the view to be embedded'

#viewClass
'Optional alternative class of the view (used when building the interface).\The name of the class (if uppercase) or the selector to ask the application (if lowercase)'

#visibilityChannel
'Aspect selector or binding for a boolean holder which makes the widget visible'

#whichViewIsToggled
'Which views visibility is toggled by the valueHolder'

#widgetHolder
'Aspect selector or binding for the widget or widget holder (shown when pulled)'

#windowIcon
'Message sent to ask the application for an icon image for the top window'

#windowLabel
'Label of the top window'

#xRotChannel
'Aspect providing x-Rotation value'

#xTransChannel
'Aspect providing x-Translation value'

#yRotChannel
'Aspect providing y-Rotation value'

#yTransChannel
'Aspect providing y-Translation value'

#zRotChannel
'Aspect providing z-Rotation value'

#zTransChannel
'Aspect providing z-Translation value'

)

    "Modified: / 24-11-2017 / 00:36:07 / cg"
    "Modified: / 24-05-2018 / 11:22:47 / Claus Gittinger"
! !

!UISpecification class methodsFor:'interface specs'!

basicsEditSpec
    ^ self basicsEditSpecWithoutModelAndViewClass
!

basicsEditSpecWithModel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#basicsEditSpecWithModel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpecWithModel
        window: 
       (WindowSpec
          label: 'UISpecification Basics'
          name: 'UISpecification Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 216)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: UISpecification
              minorKey: subSpecForIDAndModel
            )
           (UISubSpecification
              name: 'additionalBasicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 86 0 0 1.0 0 1)
              minorKey: additionalBasicAttributesSubSpec
            )
           )
         
        )
      )
!

basicsEditSpecWithModelAndViewClass
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#basicsEditSpecWithModelAndViewClass
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpecWithModelAndViewClass
        window: 
       (WindowSpec
          label: 'UISpecification Basics'
          name: 'UISpecification Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 294)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: UISpecification
              minorKey: subSpecForIDAndModelAndViewClass
            )
           (UISubSpecification
              name: 'additionalBasicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 108 0 0 1.0 0 1)
              minorKey: additionalBasicAttributesSubSpec
            )
           )
         
        )
      )
!

basicsEditSpecWithViewClass
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#basicsEditSpecWithViewClass
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpecWithViewClass
        window: 
       (WindowSpec
          label: 'UISpecification Basics'
          name: 'UISpecification Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 204)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 110 0)
              majorKey: UISpecification
              minorKey: subSpecForIDAndViewClass
            )
           (UISubSpecification
              name: 'additionalBasicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 86 0 0 1.0 0 1)
              minorKey: additionalBasicAttributesSubSpec
            )
           )
         
        )
      )
!

basicsEditSpecWithoutModelAndViewClass
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#basicsEditSpecWithoutModelAndViewClass
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpecWithoutModelAndViewClass
        window: 
       (WindowSpec
          label: 'UISpecification Basics'
          name: 'UISpecification Basics'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 283)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'basicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 -5 0 0 1.0 88 0)
              majorKey: UISpecification
              minorKey: subSpecForID
            )
           (UISubSpecification
              name: 'additionalBasicAttributesSubSpec'
              layout: (LayoutFrame 0 0.0 61 0 0 1.0 0 1)
              minorKey: additionalBasicAttributesSubSpec
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
     UIPainter new openOnClass:UISpecification andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: channelsEditSpec
        window: 
       (WindowSpec
          label: 'Any Component CallBacks'
          name: 'Any Component CallBacks'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 414 114)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Callbacks'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 66 0)
              labelPosition: topLeft
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'postBuildCallBack'
                    layout: (LayoutFrame 0 0.0 0 0 4 1.0 30 0)
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

dragAndDropEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#dragAndDropEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dragAndDropEditSpec
        window: 
       (WindowSpec
          label: 'Source and Target Drag&Drop SubSpec'
          name: 'Source and Target Drag&Drop SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 414 422)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'dragEditSpec'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 179 0)
              majorKey: UISpecification
              minorKey: dragEditSpec
            )
           (UISubSpecification
              name: 'dropEditSpec'
              layout: (LayoutFrame 0 0.0 176 0 0 1.0 374 0)
              majorKey: UISpecification
              minorKey: dropEditSpec
            )
           )
         
        )
      )
!

dragAndDropSpec
    "returns the drag & drop spec (drag, drop or dragAndDrop spec)"

    |canDrag canDrop|

    canDrag := self supportsDrag.
    canDrop := self supportsDrop.

    canDrag ifTrue:[
        canDrop ifTrue:[
            ^ self dragAndDropEditSpec
        ].
        ^ self dragEditSpec
    ].
    canDrop ifTrue:[
        ^ self dropEditSpec
    ].
    ^ nil
!

dragEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#dragEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dragEditSpec
        window: 
       (WindowSpec
          label: 'Source Drag&Drop SubSpec'
          name: 'Source Drag&Drop SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 173)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Source'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 173 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Start:'
                    name: 'startLabel'
                    layout: (AlignmentOrigin 100 0 21 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'startDragSelectorField'
                    layout: (LayoutFrame 100 0 10 0 5 1 32 0)
                    activeHelpKey: dragStart
                    tabable: true
                    model: startDragSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Argument:'
                    name: 'startDragArgumentLabel'
                    layout: (AlignmentOrigin 100 0 46 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'startDragArgumentField'
                    layout: (LayoutFrame 100 0 35 0 5 1 57 0)
                    activeHelpKey: dragStartArgument
                    tabable: true
                    model: dragArgument
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Feedback:'
                    name: 'feedBackLabel'
                    layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'feedBackSelectorField'
                    layout: (LayoutFrame 100 0 60 0 5 1 82 0)
                    activeHelpKey: dragFeedBack
                    tabable: true
                    model: dropFeedBackSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Objects:'
                    name: 'objectsLabel'
                    layout: (AlignmentOrigin 100 0 96 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'dropObjectSelectorField'
                    layout: (LayoutFrame 100 0 85 0 5 1 107 0)
                    activeHelpKey: dragDropObjects
                    tabable: true
                    model: dropObjectSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Displ. Objects:'
                    name: 'displayObjectsLabel'
                    layout: (AlignmentOrigin 100 0 121 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'displayObjectSelectorField'
                    layout: (LayoutFrame 100 0 110 0 5 1 132 0)
                    activeHelpKey: dragDisplayObjects
                    tabable: true
                    model: displayObjectSelector
                    group: inputGroup
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

dropEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#dropEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dropEditSpec
        window: 
       (WindowSpec
          label: 'Target Drag&Drop SubSpec'
          name: 'Target Drag&Drop SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 16 46 315 245)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Target'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 198 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Drop:'
                    name: 'dropLabel'
                    layout: (AlignmentOrigin 98 0 21 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'dropSelectorField'
                    layout: (LayoutFrame 100 0 10 0 5 1 32 0)
                    activeHelpKey: dropSelector
                    tabable: true
                    model: dropSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Argument:'
                    name: 'dropArgumentLabel'
                    layout: (AlignmentOrigin 98 0 46 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'dragDropArgumentField'
                    layout: (LayoutFrame 100 0 35 0 5 1 57 0)
                    activeHelpKey: dropArgument
                    tabable: true
                    model: dropArgument
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Can Drop:'
                    name: 'canDropLabel'
                    layout: (AlignmentOrigin 98 0 71 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'canDropSelectorField'
                    layout: (LayoutFrame 100 0 60 0 5 1 82 0)
                    activeHelpKey: dropCanCheck
                    tabable: true
                    model: canDropSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Enter:'
                    name: 'enterLabel'
                    layout: (AlignmentOrigin 98 0 96 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'enterSelectorField'
                    layout: (LayoutFrame 100 0 85 0 5 1 107 0)
                    activeHelpKey: dropEnter
                    tabable: true
                    model: enterSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Over:'
                    name: 'overLabel'
                    layout: (AlignmentOrigin 98 0 121 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'overSelectorField'
                    layout: (LayoutFrame 100 0 110 0 5 1 132 0)
                    activeHelpKey: dropOver
                    tabable: true
                    model: overSelector
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Leave:'
                    name: 'leaveLabel'
                    layout: (AlignmentOrigin 98 0 146 0 1 0.5)
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'leaveSelectorField'
                    layout: (LayoutFrame 100 0 135 0 5 1 157 0)
                    activeHelpKey: dropLeave
                    tabable: true
                    model: leaveSelector
                    group: inputGroup
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

subChannelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subChannelsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subChannelsEditSpec
        window: 
       (WindowSpec
          label: 'SubCanvas Channels'
          name: 'SubCanvas Channels'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 332 355)
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'Table1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              autoHideScrollBars: true
              dataList: subAspectHolderDataList
              has3Dseparators: false
              columns: 
             (OrderedCollection
                
               (DataSetColumnSpec
                  label: 'SubAspect'
                  labelButtonType: Button
                  model: subAspect
                  canSelect: false
                  showSelectionHighLighted: false
                ) 
               (DataSetColumnSpec
                  label: 'T'
                  id: 'Type'
                  labelButtonType: Button
                  width: 20
                  minWidth: 20
                  model: typeString
                  canSelect: false
                  showSelectionHighLighted: false
                )
                
               (DataSetColumnSpec
                  label: 'Aspect'
                  labelButtonType: Button
                  editorType: InputField
                  model: aspectString
                  writeSelector: aspect:
                  selectSelector: aspectCanBeEdited
                  showSelectionHighLighted: false
                ) 
               (DataSetColumnSpec
                  label: 'CallBack'
                  labelButtonType: Button
                  editorType: InputField
                  model: callBack
                  showSelectionHighLighted: false
                )
              )
              #'x_modifiedChannel:' modifiedChannel
            )
           )
         
        )
      )
!

subSpecForAcceptCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForAcceptCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForAcceptCallBack
       window: 
      (WindowSpec
         label: 'Any Component AcceptCallBack'
         name: 'Any Component AcceptCallBack'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Accepted:'
             name: 'acceptCallBackLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: acceptCallBack
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'acceptCallbackField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: acceptCallBack
             tabable: true
             model: acceptCallBack
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfCallbacks
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAction
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseActionMethod:
             actionValue: acceptCallBack
           )
          )
        
       )
     )
!

subSpecForAcceptChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForAcceptChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForAcceptChannel
       window: 
      (WindowSpec
         label: 'Any Component AcceptChannel'
         name: 'Any Component AcceptChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Accept:'
             name: 'acceptChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: acceptChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'acceptChannelField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: acceptChannel
             tabable: true
             model: #'x_acceptChannel'
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfAspects
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAspectMethod
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseAspectMethod:
             actionValue: #'x_acceptChannel'
           )
          )
        
       )
     )
!

subSpecForBGColorChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForBGColorChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForBGColorChannel
       window: 
      (WindowSpec
         label: 'Any Component BGColorChannel'
         name: 'Any Component BGColorChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'BG-Color:'
             name: 'bgColorChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: backgroundChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'bgColorChannelField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: backgroundChannel
             tabable: true
             model: backgroundChannel
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfAspects
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAspectMethod
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseAspectMethod:
             actionValue: backgroundChannel
           )
          )
        
       )
     )
!

subSpecForDoubleClickCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForDoubleClickCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForDoubleClickCallBack
       window: 
      (WindowSpec
         label: 'Any Component DoubleClickCallBack'
         name: 'Any Component DoubleClickCallBack'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'DblClick:'
             name: 'doubleClickCallBackLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: doubleClickSelector
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'acceptCallbackField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: doubleClickSelector
             tabable: true
             model: doubleClickSelector
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfCallbacks
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAction
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseActionMethod:
             actionValue: doubleClickSelector
           )
          )
        
       )
     )
!

subSpecForDoubleClickChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForDoubleClickChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForDoubleClickChannel
       window: 
      (WindowSpec
         label: 'Any Component DoubleClickChannel'
         name: 'Any Component DoubleClickChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'DblClick Chnl:'
             name: 'doubleClickChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: doubleClickChannel
             translateLabel: true
             resizeForLabel: true
           )
          (InputFieldSpec
             name: 'doubleClickChannelField'
             layout: (LayoutFrame 100 0 1 0 0 1.0 23 0)
             activeHelpKey: doubleClickChannel
             tabable: true
             model: doubleClickChannel
             group: inputGroup
             type: string
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
           )
          )
        
       )
     )
!

subSpecForEnableChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForEnableChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForEnableChannel
       window: 
      (WindowSpec
         label: 'Any Component EnableChannel'
         name: 'Any Component EnableChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Enable:'
             name: 'enableChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: enableChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'enableChannelField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: enableChannel
             tabable: true
             model: enableChannel
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfAspects
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAspectMethod
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseAspectMethod:
             actionValue: enableChannel
           )
          )
        
       )
     )
!

subSpecForEnableDisableColorChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForEnableDisableColorChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForEnableDisableColorChannel
       window: 
      (WindowSpec
         label: 'Any Component Enable/Disable ColorChannel'
         name: 'Any Component Enable/Disable ColorChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Enable-Clr:'
             name: 'enableDisableColorChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: enableDisableColorChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'enableDisableColorChannelField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: enableDisableColorChannel
             tabable: true
             model: enableDisableColorChannel
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfAspects
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAspectMethod
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseAspectMethod:
             actionValue: enableDisableColorChannel
           )
          )
        
       )
     )
!

subSpecForFGColorChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForFGColorChannel
       window: 
      (WindowSpec
         label: 'Any Component FGColorChannel'
         name: 'Any Component FGColorChannel'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'FG-Color:'
             name: 'fgColorChannelLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: foregroundChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'fgColorChannelField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: foregroundChannel
             tabable: true
             model: foregroundChannel
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfAspects
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAspectMethod
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseAspectMethod:
             actionValue: foregroundChannel
           )
          )
        
       )
     )
!

subSpecForID
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForID
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForID
       window: 
      (WindowSpec
         label: 'subSpecForID'
         name: 'subSpecForID'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 64)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 68 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 2 0 5 1.0 24 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForIDAndModel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForIDAndModel
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForIDAndModel
       window: 
      (WindowSpec
         label: 'subSpecForIDAndModel'
         name: 'subSpecForIDAndModel'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 88)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 94 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 2 0 5 1.0 24 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 38 0 1 0.5)
                   activeHelpKey: model
                   translateLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 27 0 -15 1 49 0)
                   activeHelpKey: model
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 27 0 5 1 49 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForIDAndModelAndViewClass
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForIDAndModelAndViewClass
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForIDAndModelAndViewClass
       window: 
      (WindowSpec
         label: 'subSpecForIDAndModelAndViewClass'
         name: 'subSpecForIDAndModelAndViewClass'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 116)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 116 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 2 0 5 1.0 24 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                 )
                (LabelSpec
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 38 0 1 0.5)
                   activeHelpKey: model
                   translateLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 27 0 -15 1 49 0)
                   activeHelpKey: model
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 27 0 5 1 49 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'View Class:'
                   name: 'viewClassLabel'
                   layout: (AlignmentOrigin 100 0 63 0 1 0.5)
                   activeHelpKey: viewClass
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'viewClassField'
                   layout: (LayoutFrame 100 0 52 0 5 1 74 0)
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
          )
        
       )
     )
!

subSpecForIDAndViewClass
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForIDAndViewClass
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForIDAndViewClass
       window: 
      (WindowSpec
         label: 'subSpecForIDAndViewClass'
         name: 'subSpecForIDAndViewClass'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 91)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 92 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 2 0 5 1.0 24 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                 )
                (LabelSpec
                   label: 'View Class:'
                   name: 'viewClassLabel'
                   layout: (AlignmentOrigin 100 0 38 0 1 0.5)
                   activeHelpKey: viewClass
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'viewClassField'
                   layout: (LayoutFrame 100 0 27 0 5 1 49 0)
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
          )
        
       )
     )
!

subSpecForLabelChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForLabelChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForLabelChannel
        window: 
       (WindowSpec
          label: 'Any Component LabelChannel'
          name: 'Any Component LabelChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Label:'
              name: 'labelChannelLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: labelChannel
              translateLabel: true
              resizeForLabel: true
            )
           (ComboBoxSpec
              name: 'labelChannelField'
              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
              activeHelpKey: labelChannel
              tabable: true
              model: labelChannel
              acceptOnLostFocus: true
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              comboList: listOfAspects
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: labelChannel
            )
           )
         
        )
      )
!

subSpecForMaxChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForMaxChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMaxChannel
        window: 
       (WindowSpec
          label: 'Any Component MaxChannel'
          name: 'Any Component MaxChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Max:'
              name: 'maxChannelLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: maxChannel
              translateLabel: true
              resizeForLabel: true
            )
"/           (InputFieldSpec
"/              name: 'maxChannelField'
"/              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
"/              activeHelpKey: maxChannel
"/              tabable: true
"/              model: maxChannel
"/              group: inputGroup
"/              acceptChannel: acceptChannel
"/              modifiedChannel: modifiedChannel
"/              acceptOnPointerLeave: false
"/            )
                 (ComboBoxSpec
                    name: 'maxChannelField'
                    layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
                    activeHelpKey: maxChannel
                    tabable: true
                    model: maxChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: maxChannel
            )
           )
         
        )
      )

    "Modified: / 12-01-2008 / 19:24:16 / cg"
!

subSpecForMinChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForMinChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMinChannel
        window: 
       (WindowSpec
          label: 'Any Component MinChannel'
          name: 'Any Component MinChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Min:'
              name: 'minChannelLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: minChannel
              translateLabel: true
              resizeForLabel: true
            )
"/           (InputFieldSpec
"/              name: 'minChannelField'
"/              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
"/              activeHelpKey: minChannel
"/              tabable: true
"/              model: minChannel
"/              group: inputGroup
"/              acceptChannel: acceptChannel
"/              modifiedChannel: modifiedChannel
"/              acceptOnPointerLeave: false
"/            )
                 (ComboBoxSpec
                    name: 'minChannelField'
                    layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
                    activeHelpKey: minChannel
                    tabable: true
                    model: minChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: minChannel
            )
           )
         
        )
      )

    "Modified: / 12-01-2008 / 19:24:18 / cg"
!

subSpecForModifiedChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForModifiedChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForModifiedChannel
        window: 
       (WindowSpec
          label: 'Any Component ModifiedChannel'
          name: 'Any Component ModifiedChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Modified:'
              name: 'modifiedChannelLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: modifiedChannel
              translateLabel: true
              resizeForLabel: true
            )
"/           (InputFieldSpec
"/              name: 'modifiedChannelField'
"/              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
"/              activeHelpKey: modifiedChannel
"/              tabable: true
"/              model: #'x_modifiedChannel'
"/              group: inputGroup
"/              acceptChannel: acceptChannel
"/              modifiedChannel: modifiedChannel
"/              acceptOnPointerLeave: false
"/            )
                 (ComboBoxSpec
                    name: 'modifiedChannelField'
                    layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
                    activeHelpKey: modifiedChannel
                    tabable: true
                    model: #'x_modifiedChannel'
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: #'x_modifiedChannel'
            )
           )
         
        )
      )

    "Modified: / 12-01-2008 / 19:24:22 / cg"
!

subSpecForPostBuildCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForPostBuildCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForPostBuildCallBack
       window: 
      (WindowSpec
         label: 'Any Component CallBacks'
         name: 'Any Component CallBacks'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'PostBuild:'
             name: 'postBuildCallbackLabel'
             layout: (AlignmentOrigin 100 0 12 0 1 0.5)
             activeHelpKey: postBuildChannel
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'postBuildCallbackInputField'
             layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
             activeHelpKey: postBuildChannel
             enableChannel: isNotEditingSpecOnly
             tabable: true
             model: postBuildCallback
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfCallbacks
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAction
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseActionMethod:
             enableChannel: isNotEditingSpecOnly
             actionValue: postBuildCallback
           )
          )
        
       )
     )
!

subSpecForSelectConditionCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForSelectConditionCallBack
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForSelectConditionCallBack
        window: 
       (WindowSpec
          label: 'Any Component SelectConditionCallBack'
          name: 'Any Component SelectConditionCallBack'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'SelectCond.:'
              name: 'selectConditionCallBackLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: selectConditionSelector
              translateLabel: true
              resizeForLabel: true
            )
           (InputFieldSpec
              name: 'selectConditionCallBackField'
              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
              activeHelpKey: selectConditionSelector
              tabable: true
              model: selectConditionSelector
              group: inputGroup
              type: string
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAction
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseActionMethod:
              actionValue: selectConditionSelector
            )
           )
         
        )
      )
!

subSpecForSelectedValueChangeCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForSelectedValueChangeCallBack
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForSelectedValueChangeCallBack
       window: 
      (WindowSpec
         label: 'Any Component SelectedValueChangeCallBack'
         name: 'Any Component SelectedValueChangeCallBack'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 31)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Selected:'
             name: 'selectedValueChangeCallBackLabel'
             layout: (AlignmentOrigin 140 0 12 0 1 0.5)
             activeHelpKey: valueChangeSelector
             translateLabel: true
             resizeForLabel: true
           )
          (ComboBoxSpec
             name: 'selectedValueChangeCallBackField'
             layout: (LayoutFrame 140 0 1 0 -20 1.0 23 0)
             activeHelpKey: valueChangeSelector
             tabable: true
             model: valueChangeSelector
             acceptChannel: acceptChannel
             modifiedChannel: modifiedChannel
             comboList: listOfCallbacks
           )
          (ActionButtonSpec
             label: 'browseActionImage'
             name: 'Button1'
             layout: (LayoutFrame -20 1 1 0 0 1 23 0)
             activeHelpKey: browseAction
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: doBrowseActionMethod:
             actionValue: valueChangeSelector
           )
          )
        
       )
     )
!

subSpecForValueChangeCallBack
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForValueChangeCallBack
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForValueChangeCallBack
        window: 
       (WindowSpec
          label: 'Any Component ValueChangeCallBack'
          name: 'Any Component ValueChangeCallBack'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 27)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Changed:'
              name: 'changedLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: valueChangeCallBackSelector
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (ComboBoxSpec
              name: 'onCallBackSelectorField'
              layout: (LayoutFrame 100 0 1 0 -20 1 23 0)
              activeHelpKey: valueChangeCallBackSelector
              tabable: true
              model: valueChangeCallBackSelector
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
              comboList: listOfCallbacks
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 5 1 23 0)
              activeHelpKey: browseAction
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseActionMethod:
              actionValue: valueChangeCallBackSelector
            )
           )
         
        )
      )
!

subSpecForVisibilityChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForVisibilityChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForVisibilityChannel
        window: 
       (WindowSpec
          label: 'Any Component VisibilityChannel'
          name: 'Any Component VisibilityChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Visible:'
              name: 'visibilityChannelLabel'
              layout: (AlignmentOrigin 100 0 12 0 1 0.5)
              activeHelpKey: visibilityChannel
              translateLabel: true
              resizeForLabel: true
            )
           (ComboBoxSpec
              name: 'visibilityChannelInputField'
              layout: (LayoutFrame 100 0 1 0 -20 1.0 23 0)
              activeHelpKey: visibilityChannel
              tabable: true
              model: visibilityChannel
              acceptOnLeave: true
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              comboList: listOfAspects
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: visibilityChannel
            )
           )
         
        )
      )
! !

!UISpecification class methodsFor:'interface-painter'!

adapt:aSpec forAspect:anAspect channel:aChannel 
    "generate an aspect adaptor, to access one of
     my instance variables"

    aChannel isNil ifTrue:[
        ^ (AspectAdaptor subject:aSpec) forAspect:anAspect
    ].
    ^ (AspectAdaptor subjectChannel:aChannel) forAspect:anAspect.

    "Modified: / 26.10.1997 / 02:58:05 / cg"
!

adaptApects:aCollectionOfAspects to:aDirectory for:anInstance channel:aChannel 
    "helper - adapting a bunch of aspects is so common ...
     generate and install a aspect adaptors, for a list of aspect
     (i.e. instance variable). Add each to the binding environment"

    aCollectionOfAspects do:[:aSymbol |
        aDirectory at:aSymbol put:(self adapt:anInstance forAspect:aSymbol channel:aChannel)
    ]

    "Created: / 26.10.1997 / 02:04:14 / cg"
    "Modified: / 26.10.1997 / 02:59:21 / cg"
!

adaptApects:aCollectionOfAspects to:aDirectory for:anInstance channel:aChannel converter:converterSymbol
    "helper - adapting a bunch of aspects and converting the type is so common ...
     for each aspect in the list, generate an aspect adaptor and a typeconverter,
     Add each to the binding environment.
     converterSymbol is sent to TypeConverter to define the conversion
     (typically something like #symbolOrNil)"

    aCollectionOfAspects do:[:aSymbol |
        aDirectory 
            at:aSymbol 
            put:((TypeConverter on:(self adapt:anInstance forAspect:aSymbol channel:aChannel))
                     perform:converterSymbol)
    ]

    "Created: / 26.10.1997 / 03:07:36 / cg"
    "Modified: / 26.10.1997 / 03:22:50 / cg"
!

addBindingsTo:aDictionary for:anInstance
    "not currently used"

    self addBindingsTo:aDictionary for:anInstance channel:anInstance asValue

    "Modified: / 26.10.1997 / 03:02:54 / cg"
!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    self 
        adaptApects:
                    #(  
                        name
                        layout
                        flags
                        activeHelpKey
                        viewClassName
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        postBuildCallback
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self supportsDrag ifTrue:[
        self 
            adaptApects:
                        #(  
                            startDragSelector
                            dropFeedBackSelector
                            dropObjectSelector
                            displayObjectSelector
                         )
            to:env 
            for:anInstance 
            channel:aChannel
            converter:#symbolOrNil.

        self 
            adaptApects:#(  dragArgument )
            to:env 
            for:anInstance 
            channel:aChannel.
    ].

    self supportsDrop ifTrue:[
        self 
            adaptApects:
                        #(  
                            dropSelector
                            canDropSelector
                            enterSelector
                            overSelector
                            leaveSelector
                         )
            to:env 
            for:anInstance 
            channel:aChannel
            converter:#symbolOrNil.

        self 
            adaptApects:#(  dropArgument )
            to:env 
            for:anInstance 
            channel:aChannel.
    ].
!

addScrollBarBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    |hideIdx|

    self 
        adaptApects:
                    #(  
                        autoHideScrollBars
                        hasHorizontalScrollBar
                        hasVerticalScrollBar
                        miniScrollerHorizontal 
                        miniScrollerVertical
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    hideIdx := (#(nil true false) indexOf:(env at:#autoHideScrollBars) value) asValue.
    env at:#autoHideScrollBarsIdx put:hideIdx.
    hideIdx
        onChangeEvaluate:[ (env at:#autoHideScrollBars) value:(#(nil true false) at:hideIdx value).
                           "(env at:#modifiedChannel)  value:true" ].
    env at:#autoHideScrollBarsList put:#('Default' 'On' 'Off').

    env at:#hasVerticalOrHorizontalScrollBar 
        put:(BlockValue
                forLogical:(env at:#hasVerticalScrollBar) or:(env at:#hasHorizontalScrollBar)).
    env at:#autoHideInScrollerSubSpecVisible put:true

    "Modified: / 01-01-1970 / 01:00:00 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ #()

    "Created: / 12-01-2008 / 23:43:10 / cg"
!

helpSpecClass
    "return the class implementing the help texts of the field attributes"

    ^UISpecificationTool

!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'UISpecification class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU0A@@@@B@D***+HDR???4!!AK???R@D/??=H@R???4 AK???RLD/??=H,R???4 AK???R@D5UUUH<P@@@@"3*****@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
!

possiblePrintConverterTypes
    ^ TypeConverter possiblePrintConverterTypes

    "Modified: / 25-09-2010 / 11:27:55 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"
    "each item consists of a label and a window-spec selector"

    ^#(     
        (Basics   basicsEditSpec)
        (Channels channelsEditSpec)
      )
! !

!UISpecification class methodsFor:'misc'!

newBindingsDictionary
    "create & return an instance of my private UIBindingsDictionary class.
     This has the same functionality like ordinary dictionaries,
     put passes the builder as instvars for those specs which need to know about
     it."

    ^ UIBindingsIdentityDictionary new

    "Created: / 30.1.1998 / 13:48:00 / cg"
!

updatedAspectHolderDataList:subAspectHolders forClassNamed:className
    "update subAspectHolders for aClass;
     common helper for SubCanvas and ArbitraryComponents"

    |nameSpace cls possibleSubAspects possibleSubAspectTypes
     moreAspects updatedSubAspectHolders|

    updatedSubAspectHolders := subAspectHolders.

    className isSymbol ifTrue:[
        nameSpace := (className includes: $:) 
                        ifTrue:[ Smalltalk ]
                        ifFalse:[UIMajorKeyBindingNameSpaceQuery query].
        cls := nameSpace classNamed:className.
        cls notNil ifTrue:[
           possibleSubAspects := cls perform:#aspectSelectors ifNotUnderstood:nil.
        ]
    ].

    possibleSubAspects notNil ifTrue:[
        "/ spec contains both plain-symbols and 
        "/ arrays (symbol type)
        possibleSubAspectTypes := possibleSubAspects collect:[:el | el isSymbol 
                                                                ifTrue:[nil]
                                                                ifFalse:[el second]].

        possibleSubAspects := possibleSubAspects collect:[:el | el isSymbol 
                                                                ifTrue:[el]
                                                                ifFalse:[el first]].

        updatedSubAspectHolders isNil ifTrue:[
            updatedSubAspectHolders := OrderedCollection new.
        ].

        updatedSubAspectHolders := updatedSubAspectHolders select:[:el |
            el aspect notNil
            or:[el callBack notNil
            or:[possibleSubAspects includes:el subAspect]]
        ].

        "/ defined subAspects, which are no longer found in the
        "/ classes aspectSelectors list are marked red.
        updatedSubAspectHolders do:[:el |
            |theAspect|

            theAspect := el subAspect.
            (possibleSubAspects includes:theAspect) ifFalse:[
                el subAspect:(theAspect emphasizeAllWith:(Array with:#bold with:(#color->Color red)))
            ]
        ].

        "/ add remaining subAspects with empty values
        moreAspects := OrderedCollection new.
        possibleSubAspects with:possibleSubAspectTypes do:[:aSubAspect :aspectType |
            |info|

            info := updatedSubAspectHolders detect:[:el | el subAspect = aSubAspect] ifNone:nil.
            info isNil ifTrue:[
                "/ a new one
                moreAspects add:(SubChannelInfoSpec new subAspect:aSubAspect; type:aspectType )
            ] ifFalse:[
                "/ already there - fill in type
                info type:aspectType
            ]
        ].
        updatedSubAspectHolders := updatedSubAspectHolders , moreAspects.
        updatedSubAspectHolders := updatedSubAspectHolders asArray sort:[:a :b | a subAspect < b subAspect].
    ].

    ^ updatedSubAspectHolders

    "Modified (format): / 17-03-2014 / 16:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UISpecification class methodsFor:'printing support'!

prettyPrintSpecArray:spec on:aStream indent:i
    "just for your convenience: prettyPrint a specArray to aStream - it looks better that way"

    ^ self prettyPrintSpecArray:spec on:aStream indent:i isArrayElement:false
!

prettyPrintSpecArray:spec on:aStream indent:i isArrayElement:isArrayElement
    "just for your convenience: prettyPrint a specArray to aStream - it looks better that way"

    |what oneLine|

    spec isArray ifFalse:[
        spec isLiteral ifTrue:[
            isArrayElement ifTrue:[
                spec storeArrayElementOn:aStream.
            ] ifFalse:[
                spec storeOn:aStream.
            ]
        ] ifFalse:[
            self error:'non literal in specArray'.
        ].
        ^ self
    ].

    spec isEmpty ifTrue:[
        isArrayElement ifTrue:[
            aStream nextPutAll:'()'.
        ] ifFalse:[
            aStream nextPutAll:'#()'.
        ].
        ^ self
    ].

    what := spec at:1.
    what isArray ifTrue:[
        "/ aStream cr; spaces:i+2.
        isArrayElement ifTrue:[
            aStream nextPutAll:'('.
        ] ifFalse:[
            aStream nextPutAll:'#('.
        ].
        "/ a spec-collection
        spec do:[:element |
            self prettyPrintSpecArray:element on:aStream indent:i+2 isArrayElement:true.
        ].
        aStream cr.
        aStream spaces:i+2.
        aStream nextPut:$).
        aStream cr.
        aStream spaces:i.
        ^ self.
    ].

    oneLine := #(LayoutFrame LayoutOrigin AlignmentOrigin 
                 Rectangle Point FontDescription
                 Color ColorValue ResourceRetriever Any
                ) includesIdentical:what.

    oneLine ifFalse:[
        aStream cr; spaces:i.
    ].
    isArrayElement ifTrue:[
        aStream nextPutAll:'('.
    ] ifFalse:[
        aStream nextPutAll:'#('.
    ].
    what storeArrayElementOn:aStream.

    (oneLine or:[(spec size==1)]) ifFalse:[
        aStream cr; spaces:i+2.
    ].

    2 to:spec size do:[:index |
        aStream space.
        self prettyPrintSpecArray:(spec at:index) on:aStream indent:i+2 isArrayElement:true.
        oneLine ifFalse:[
            (index odd and:[index ~~ (spec size)]) ifTrue:[
                aStream cr; spaces:i+2.
            ]
        ]
    ].
    oneLine ifFalse:[
        aStream cr; spaces:i+1.
    ].
    aStream nextPut:$).

    "Modified: / 05-09-1995 / 17:44:20 / claus"
    "Modified: / 21-12-2010 / 14:15:52 / cg"
!

prettyPrintSpecArray:spec on:aStream tabLevel:i
    "prettyPrint - ST-80 compatible name"

    self prettyPrintSpecArray:spec on:aStream indent:i


! !

!UISpecification class methodsFor:'queries'!

canResizeSubComponents
    "answer whether included sub components can be resized or are handled by the view itself"

    ^ true
!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == UISpecification.
!

isLayoutContainer
    "answer whether corresponding view instances of the spec class can contain (and arrange) other view"

    ^ false


!

resolveName:aName
    ^ self resolveName:aName in:nil
!

resolveName:aName in:aBuilder
    |appl|

    aName notNil ifTrue:[
        (aBuilder notNil and:[(appl := aBuilder application) notNil]) ifTrue:[
            ^ appl resolveName:aName
        ].
        ^ Smalltalk resolveName:aName inClass:self.
    ].
    ^ nil
!

supportsDrag
    ^ false
!

supportsDrop
    ^ false
!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false


!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ false


!

uiMajorKeyBindingNameSpaceQuery
    ^ UIMajorKeyBindingNameSpaceQuery
!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    |name|
    name := self name.

    (name endsWith:'Spec') ifTrue:[
        name := name copyButLast:4.
    ] ifFalse:[
        name := name copy
    ].
    ^name
!

viewClass
    "return the corresponding view class of the spec.
     This is an instance method, since it may depend on some attribute."

    |specClassName cls|

    specClassName := self name.

    (specClassName endsWith:'Spec') ifTrue:[
        specClassName := specClassName copyButLast:4.             "/ try name without 'Spec'
        cls  := self resolveName:specClassName.
        cls notNil ifTrue:[
            cls := cls autoload.
            ((cls isSubclassOf:SimpleView) or:[cls isSubclassOf:VisualPart]) ifTrue:[
                ^ cls
            ]
        ].

        cls := self resolveName:(specClassName , 'View').    "/ try with 'Spec' replaced by 'View'
        cls notNil ifTrue:[
            cls := cls autoload.
            ((cls isSubclassOf:SimpleView) or:[cls isSubclassOf:VisualPart]) ifTrue:[
                ^ cls
            ]
        ]
    ].

    "/ there is no class named after my name (i.e. FooSpec -> FooView).
    "/ must have redefined #viewClass in the concrete spec-class.

    ^ self errorNotFound:'UISpecification: missing/unknown view class for: ' , self name.

    "
     WindowSpec viewClass 
     ComboBoxSpec viewClass 
    "

    "Modified: / 21.4.1998 / 20:19:56 / cg"
! !

!UISpecification class methodsFor:'testing'!

testBuild
"
   some specs to play with, extracted from PD code found
   in the manchester archives:

   The examples below will not fill the view with live 
   (no appModel provided)


   found in a classSelection tool:

        |spec builder view|

        spec := UISpecification from:
             #(#FullSpec 
                #window: 
                    #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #min: #(#Point 50 50 ) 
                        #bounds: #(#Rectangle 448 407 648 607 ) ) 
                #component: 
                    #(#SpecCollection
                        #collection: 
                            #(
                                #(#LabelSpec 
                                    #layout: #(#Point 0 2 ) 
                                    #label: 'Classes:' )
                                #(#SequenceViewSpec 
                                    #layout: #(#LayoutFrame 0 0 27 0 0 1 0 1 ) 
                                    #model: #classChoice 
                                    #tabable: false ) 
                                #(#InputFieldSpec 
                                    #layout: #(#LayoutFrame 70 0 2 0 0 1 25 0 )   
                                    #model: #classPattern ) ) ) ).

        builder := UIBuilder new.
        view := spec buildViewFor:builder.
        view open


   Found in a file dialog goody:

        |spec builder view|

        spec := UISpecification from:
            #(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'File Dialog' 
                        #bounds: #(#Rectangle 16 155 485 402 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#LabelSpec 
                                        #layout: #(#Point 10 7 ) 
                                        #label: 'File Name:' ) 
                                #(#InputFieldSpec 
                                        #layout: #(#Rectangle 10 30 168 51 ) 
                                        #model: #filePatternHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #typedNewFileName ) ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#Rectangle 10 59 168 181 ) 
                                        #model: #fileNamesHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedFileName 
                                                #doubleClickSelector: #acceptedFileName ) ) 
                                #(#LabelSpec 
                                        #layout: #(#Point 10 186 ) 
                                        #label: 'List Files of Type:' ) 
                                #(#LabelSpec 
                                        #layout: #(#Point 192 7 ) 
                                        #label: 'Directories:' ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#Rectangle 192 59 350 181 ) 
                                        #model: #directoriesHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedDirectory 
                                                #doubleClickSelector: #expandedOrContractedDirectory ) ) 
                                #(#LabelSpec 
                                        #layout: #(#Point 192 186 ) 
                                        #label: 'Drives:' ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#Rectangle 365 11 453 36 ) 
                                        #model: #clickedOK 
                                        #label: 'OK' 
                                        #defaultable: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#Rectangle 365 45 453 70 ) 
                                        #model: #clickedCancel 
                                        #label: 'Cancel' 
                                        #defaultable: true ) 
                                #(#ComboBoxSpec 
                                        #layout: #(#Rectangle 10 209 168 230 ) 
                                        #model: #fileTypesSelectionHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedFileType ) 
                                        #comboList: #fileTypesHolder ) 
                                #(#ComboBoxSpec 
                                        #layout: #(#Rectangle 192 209 350 230 ) 
                                        #model: #driveListSelectionHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedDrive ) 
                                        #comboList: #driveListHolder ) 
                                #(#InputFieldSpec 
                                        #layout: #(#Rectangle 192 30 350 51 ) 
                                        #flags: 0 
                                        #model: #currentDirectoryHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #typedNewFileName ) 
                                        #isReadOnly: true ) ) ) ).

        builder := UIBuilder new.
        view := spec buildViewFor:builder.
        view open
"

    "Modified: 17.1.1997 / 21:32:30 / cg"
!

testing
"
     |top|

     top := StandardSystemView new.
     top extent:200@350.
     top label:'hello'.

     (WindowSpec fromView:top) inspect



     |top spec app|

     top := StandardSystemView new.
     top extent:200@350.
     top label:'hello'.

     spec := (FullSpec fromView:top).

     app := ApplicationModel new.
     app allButOpenFrom:spec.
     app builder openWithExtent:nil.



     |top l b|

     top := StandardSystemView new.
     top extent:200@350.
     top label:'hello'.

     l := Label label:'some label'.
     l layout:(10@10) asLayout.
     top addComponent:l.

     b := Button label:'press me'.
     b layout:((0.0@0.5) corner:(1.0@1.0)) asLayout.
     top addComponent:b.

     (FullSpec fromView:top) inspect



     |top|

     top := FileBrowser new.
     top openAndWait.

     (FullSpec fromView:top) inspect


"
! !

!UISpecification class methodsFor:'window sub-specs'!

colorBGSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#colorBGSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: colorBGSubSpec
       window: 
      (WindowSpec
         label: 'BG-Color SubSpec'
         name: 'BG-Color SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 65)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 66 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 120 0 21 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 120 0 9 0 5 1 31 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
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
     UIPainter new openOnClass:UISpecification andSelector:#colorSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: colorSubSpec
       window: 
      (WindowSpec
         label: 'BG- and FG-Color SubSpec'
         name: 'BG- and FG-Color SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 109)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 106 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 100 0 23 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 100 0 11 0 5 1.0 33 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 53 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 41 0 5 1.0 63 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsInitSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#detailsInitSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsInitSubSpec
       uuid: 'd385871e-319f-11e8-9bf1-b8f6b1108e05'
       window: 
      (WindowSpec
         label: 'Init Attributes SubSpec'
         name: 'Init Attributes SubSpec'
         uuid: 'd38589da-319f-11e8-9bf1-b8f6b1108e05'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 56)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 64 0)
             uuid: 'd3858c32-319f-11e8-9bf1-b8f6b1108e05'
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Disabled'
                   name: 'initiallyDisabledCheckBox'
                   layout: (Point 10 0)
                   activeHelpKey: initiallyDisabled
                   uuid: 'd3858e94-319f-11e8-9bf1-b8f6b1108e05'
                   tabable: true
                   model: initiallyDisabled
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (LayoutOrigin 0 0.5 0 0)
                   activeHelpKey: initiallyInvisible
                   uuid: 'd38590b0-319f-11e8-9bf1-b8f6b1108e05'
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
!

fontColorBorderSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#fontColorBorderSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: fontColorBorderSubSpec
       window: 
      (WindowSpec
         label: 'Font and BG- and FG-Color SubSpec'
         name: 'Font and BG- and FG-Color SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 159)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 161 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 120 0 20 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'FontMenu'
                   layout: (LayoutFrame 120 0 8 0 5 1.0 30 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                   labelsAreEmphasized: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 120 0 50 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 120 0 38 0 5 1.0 60 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 120 0 80 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 120 0 68 0 5 1.0 90 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'borderLabel'
                   layout: (AlignmentOrigin 120 0 106 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'borderWidthField'
                   layout: (LayoutFrame 120 0 95 0 198 0 117 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: borderWidth
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: false
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'levelLabel'
                   layout: (AlignmentOrigin 263 0 106 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 265 0 95 0 357 0 117 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: false
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
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
     UIPainter new openOnClass:UISpecification andSelector:#fontColorSubSpec
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
         bounds: (Rectangle 0 0 400 135)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 136 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'fontLabel'
                   layout: (AlignmentOrigin 120 0 21 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 120 0 9 0 5 1.0 31 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                (LabelSpec
                   label: 'FG-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 120 0 51 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 120 0 39 0 5 1.0 61 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 120 0 81 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 120 0 69 0 5 1.0 91 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

fontSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#fontSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: fontSubSpec
       window: 
      (WindowSpec
         label: 'Font SubSpec'
         name: 'Font SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 73)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 68 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Font:'
                   name: 'widgetLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: fontMenu
                   translateLabel: true
                   resizeForLabel: true
                 )
                (FontMenuSpec
                   name: 'fontMenu'
                   layout: (LayoutFrame 100 0 8 0 -2 1.0 30 0)
                   activeHelpKey: fontMenu
                   model: style
                   allowSymbolicFonts: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

menuSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#menuSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: menuSubSpec
       window: 
      (WindowSpec
         label: 'Menu SubSpec'
         name: 'Menu SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 123)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Popup Menu'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 121 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Selector:'
                   name: 'selectorLabel'
                   layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                   activeHelpKey: menuId
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
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Performer:'
                   name: 'performerLabel'
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: menuPerformer
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
                   acceptOnLeave: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
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
           )
          )
        
       )
     )
!

modelListSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#modelListSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: modelListSubSpec
       window: 
      (WindowSpec
         label: 'ModelList SubSpec'
         name: 'ModelList SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 119)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 124 0)
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
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 45 0 1 0.5)
                   activeHelpKey: selectionHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'ComboBox1'
                   layout: (LayoutFrame 100 0 34 0 -15 1 56 0)
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
                   layout: (LayoutFrame -15 1 34 0 5 1 56 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 72 0 1 0.5)
                   activeHelpKey: listHolder
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 100 0.0 61 0 -113 1.0 83 0)
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
                   layout: (LayoutFrame -109 1 61 0 -89 1 83 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   enableChannel: hasListSelector
                   actionValue: listSelector
                 )
                (CheckBoxSpec
                   label: 'Index'
                   name: 'useIndexCheckBox'
                   layout: (AlignmentOrigin 12 1.0 73 0 1 0.5)
                   activeHelpKey: useIndex
                   tabable: true
                   model: useIndex
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ActionButtonSpec
                   label: 'editTableIcon'
                   name: 'Button3'
                   layout: (LayoutFrame -85 1 61 0 -65 1 83 0)
                   activeHelpKey: editListSpec
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doEditList:
                   actionValue: listSelector
                 )
                )
              
             )
           )
          )
        
       )
     )
!

scrollerSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#scrollerSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: scrollerSubSpec
       window: 
      (WindowSpec
         label: 'Scroller SubSpec'
         name: 'Scroller SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 98)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'ScrollBars'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 97 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Vertical'
                   name: 'verticalScrollBarCheckBox'
                   layout: (Point 10 6)
                   activeHelpKey: verticalScroller
                   tabable: true
                   model: hasVerticalScrollBar
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Horizontal'
                   name: 'horizontalScrollBarCheckBox'
                   layout: (LayoutFrame 135 0 6 0 247 0 35 0)
                   activeHelpKey: horizontalScroller
                   tabable: true
                   model: hasHorizontalScrollBar
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Mini'
                   name: 'miniScrollerVerticalCheckBox'
                   layout: (Point 10 31)
                   activeHelpKey: verticalMiniScroller
                   enableChannel: hasVerticalScrollBar
                   tabable: true
                   model: miniScrollerVertical
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Mini'
                   name: 'miniScrollerHorizontalCheckBox'
                   layout: (Point 135 31)
                   activeHelpKey: horizontalMiniScroller
                   enableChannel: hasHorizontalScrollBar
                   tabable: true
                   model: miniScrollerHorizontal
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Auto Hide:'
                   name: 'Label1'
                   layout: (LayoutFrame 262 0 6 0 354 0 35 0)
                   activeHelpKey: autoHideScrollBars
                   visibilityChannel: autoHideInScrollerSubSpecVisible
                   translateLabel: true
                   adjust: left
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'PopUpList1'
                   layout: (LayoutFrame 262 0 34 0 346 0 56 0)
                   activeHelpKey: autoHideScrollBars
                   visibilityChannel: autoHideInScrollerSubSpecVisible
                   translateLabel: true
                   tabable: true
                   model: autoHideScrollBarsIdx
                   enableChannel: hasVerticalOrHorizontalScrollBar
                   menu: autoHideScrollBarsList
                   useIndex: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

visibilityAndBackgroundChannelEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#visibilityAndBackgroundChannelEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: visibilityAndBackgroundChannelEditSpec
       window: 
      (WindowSpec
         label: 'NamedSpec Channels'
         name: 'NamedSpec Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 155)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 95 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 30 0.0 4 1.0 60 0)
                   majorKey: UISpecification
                   minorKey: subSpecForBGColorChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 93 0.0 0 1.0 160 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
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

visibilityChannelEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#visibilityChannelEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: visibilityChannelEditSpec
       window: 
      (WindowSpec
         label: 'NamedSpec Channels'
         name: 'NamedSpec Channels'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 155)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 95 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 93 0.0 0 1.0 158 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification4'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!UISpecification methodsFor:'accessing'!

activeHelpKey
    "the key used to ask the application for the tooltip text (via helpTextFor:)"

    ^ activeHelpKey
!

activeHelpKey:aKey
    "the key used to ask the application for the tooltip text (via helpTextFor:)"

    activeHelpKey := aKey
!

attributes
    ^ attributes

    "Created: / 3.2.1998 / 19:05:56 / cg"
!

attributes:something
    attributes := something.

    "Created: / 3.2.1998 / 19:05:59 / cg"
!

colors
    ^ colors
!

colors:something
    colors := something.
!

extent:extentPoint
    "very special - only an extent is specified"

    layout := #extent->extentPoint
!

flags
    ^ flags ? 0

    "Modified: 20.6.1997 / 11:20:34 / cg"
!

flags:something
    flags := something.
!

keepSpaceForOSXResizeHandleH
    "very very special - if running under OS/X, AND my right corner is 1.0,
     then subtract the space needed for the window resize handle from my width.
     This is used for the lower info-areas (in Launcher and Browser), to avoid
     this area being overdrawn by the window's resize handle (which OSX draws inside the view).
     May also be useful for other window systems, which place the resize handle there.
     This is a boolean flag, which is ignored on non MACOS-X systems."

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#keepSpaceForOSXResizeHandleH) ? false.
!

keepSpaceForOSXResizeHandleH:aBoolean
    "very very special - if running under OS/X, AND my right corner is 1.0,
     then subtract the space needed for the window resize handle from the width.
     This is used for the lower info-areas (in Launcher and Browser), to avoid
     this area being overdrawn by the window's resize handle (which OSX draws inside the view).
     May also be useful for other window systems, which place the resize handle there.
     This is a boolean flag, which is ignored on non MACOS-X systems."

    self otherAttributeAt:#keepSpaceForOSXResizeHandleH put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

keepSpaceForOSXResizeHandleV
    "very very special - if running under OS/X, AND my bottom corner is 1.0,
     then subtract the space needed for the window resize handle from my height.
     This is used for the lower info-areas (in Launcher and Browser), to avoid
     this area being overdrawn by the window's resize handle (which OSX draws inside the view).
     May also be useful for other window systems, which place the resize handle there.
     This is a boolean flag, which is ignored on non MACOS-X systems."

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#keepSpaceForOSXResizeHandleV) ? false.
!

keepSpaceForOSXResizeHandleV:aBoolean
    "very very special - if running under OS/X, AND my bottom corner is 1.0,
     then subtract the space needed for the window resize handle from the height.
     This is used for the lower info-areas (in Launcher and Browser), to avoid
     this area being overdrawn by the window's resize handle (which OSX draws inside the view).
     May also be useful for other window systems, which place the resize handle there.
     This is a boolean flag, which is ignored on non MACOS-X systems."

    self otherAttributeAt:#keepSpaceForOSXResizeHandleV put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

layout
    ^ layout
!

layout:aLayout
    layout := aLayout
!

name
    "name of the component, by which it can be retrieved from the builder via componentNamed:"

    ^ name 
!

name:aSymbol
    "name of the component, by which it can be retrieved from the builder via componentNamed:"

    name := aSymbol

    "Modified: / 17-08-2011 / 10:00:30 / cg"
!

postBuildCallback
    "very special - allow application to hook on component creation"

    otherAttributes isNil ifTrue:[^ nil].
    ^ (self otherAttributeAt:#postBuildCallback).
!

postBuildCallback:anActionSelector
    "very special - allow application to hook on component creation"

    self otherAttributeAt:#postBuildCallback put:anActionSelector
!

style
    ^ style
!

style:something
    style := something.
    style == #default ifTrue:[style := nil]
!

useDefaultExtent
    "very special - let view use its default extent"

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#useDefaultExtent) ? false.
!

useDefaultExtent:aBoolean
    "very special - let view use its default extent"

    self otherAttributeAt:#useDefaultExtent put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

useDynamicPreferredHeight
    "very special - let view use its dynamic preferred height"

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#useDynamicPreferredHeight) ? false.
!

useDynamicPreferredHeight:aBoolean
    "very special - let view use its dynamic preferred height"

    self otherAttributeAt:#useDynamicPreferredHeight put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

useDynamicPreferredWidth
    "very special - let view use its dynamic preferred width"

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#useDynamicPreferredWidth) ? false.
!

useDynamicPreferredWidth:aBoolean
    "very special - let view use its dynamic preferred width"

    self otherAttributeAt:#useDynamicPreferredWidth put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

usePreferredHeight
    "very special - let view use its preferred height"

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#usePreferredHeight) ? false.
!

usePreferredHeight:aBoolean
    "very special - let view use its preferred height"

    self otherAttributeAt:#usePreferredHeight put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

usePreferredWidth
    "very special - let view use its preferred width"

    otherAttributes isNil ifTrue:[^ false].
    ^ (self otherAttributeAt:#usePreferredWidth) ? false.
!

usePreferredWidth:aBoolean
    "very special - let view use its preferred width"

    self otherAttributeAt:#usePreferredWidth put:(aBoolean ifTrue:[true] ifFalse:[nil])
!

usedBackgroundColor
    ^ self backgroundColor
!

uuid
    "this UUID will be unique among all specs.
     When the spec is used by the builder,
     this uuid is set in the generated view;
     Thus, all views which will ever be created will get this same
     uuid assigned, and can thus be accessed using that id,
     independent of their hierarchy, label, contents etc.
     Useful for automation of Smalltalk applications (i.e. expecco).

     If a spec has no uuid, it will get one assigned, when stored the next time
     (and then remain fix forever)"

    ^ uuid

    "Modified (comment): / 09-11-2017 / 22:26:10 / cg"
!

uuid:aUUID
    "this UUID MUST be unique among all specs.
     When the spec is used by the builder,
     this uuid is set in the generated view;
     Thus, all views which will ever be created will get this same
     uuid assigned, and can thus be accessed using that id,
     independent of their hierarchy, label, contents etc.
     Useful for automation of Smalltalk applications (i.e. expecco).

     If a spec has no uuid, it will get one assigned, when stored the next time
     (and then remain fix forever)"
     
    uuid := aUUID

    "Modified (comment): / 09-11-2017 / 22:26:16 / cg"
! !

!UISpecification methodsFor:'accessing-channels'!

foregroundChannel
    "return nil here, so every component can be asked for it"

    ^ nil
! !

!UISpecification methodsFor:'accessing-color & font'!

backgroundColor
    "return nil here, so every component can be asked for it"

    ^ nil
! !

!UISpecification methodsFor:'accessing-dummies'!

defaultable
    ^ nil
!

defaultable:aBoolean
!

initiallyInvisible
    ^ nil
!

initiallyInvisible:aBoolean
!

labelSelector
    ^ nil



!

listSelector
    ^ nil


!

listSelector:aSelector


!

menuSelector
    ^ nil



!

menuSelector:something



!

model
    "many subclasses redefine this to return a real model"

    ^ nil
!

modelSelector
    "return my model selector"

    ^ nil



!

tabable
    ^ nil



!

tabable:something



!

translateLabel
    ^ nil
! !

!UISpecification methodsFor:'building'!

addView:aView toMappingOfBuilder:aBuilder
    aBuilder componentToSpecMappingAt:aView put:self.
!

basicCreateViewFor:aBuilder in:aParentView
    "low level create - no attributes are set.
     Can be redefined for special creation (see arbitraryComponentSpec)"

    |cls newView|

    cls := self realViewClassFor:aBuilder.
    cls isNil ifTrue:[^ nil].

    (cls includesBehavior:SimpleView) ifTrue:[
        newView := cls in:aParentView
    ] ifFalse:[
        newView := cls new.
        aParentView notNil ifTrue:[ aParentView add:newView ].
    ].

    ^ newView

    "Modified: / 26-09-2011 / 16:18:00 / cg"
!

buildViewFor:aBuilder in:aView
    "create and set attributes.
     No need to redefine"

    |newView|

    newView := self createViewFor:aBuilder in:aView.
    newView isNil ifTrue:[^ nil].

    self setAttributesIn:newView with:aBuilder.
    self setKeyboardFocusAttributesIn:newView with:aBuilder.

    self postCreateView:newView for:aBuilder.
    ^ newView

    "Modified: / 30.1.1998 / 14:36:50 / cg"
!

buildViewWithLayoutFor:aBuilder in:aParentView
    |newView parentViewSpecClass creationMessage|

    creationMessage := self viewCreationMessage.
    creationMessage notNil ifTrue:[
        newView := aBuilder application 
                        perform:creationMessage 
                        withOptionalArgument:aBuilder 
                        and:aParentView
                        and:self.
    ] ifFalse:[
        newView := self createViewFor:aBuilder in:aParentView.
    ].

    newView isNil ifTrue:[^ nil].

    self 
        setAttributesIn:newView with:aBuilder;
        setKeyboardFocusAttributesIn:newView with:aBuilder.

    aParentView notNil ifTrue:[
        parentViewSpecClass := aParentView specClass.
    ].

    layout notNil ifTrue:[
        self hasLayout ifTrue:[
            (aParentView notNil and:[parentViewSpecClass isLayoutContainer]) ifTrue:[
                parentViewSpecClass canResizeSubComponents ifTrue:[
                    self layout:layout for:newView
                ].
                parentViewSpecClass basicNew setupInitialLayoutFor:newView.
            ] ifFalse:[
                self layout:layout for:newView
            ]
        ]
    ] ifFalse:[
        aParentView notNil ifTrue:[
            parentViewSpecClass isLayoutContainer ifTrue:[
                parentViewSpecClass basicNew setupInitialLayoutFor:newView.
            ]
        ].
    ].

    self postCreateView:newView for:aBuilder.
    ^ newView

    "Modified: / 30.1.1998 / 14:36:54 / cg"
!

callBackActionFor:aSelector with:aBuilder
    "given a callBack selector, return a corresponding action block"

    |appl nA bindings b|

    aBuilder isEditing ifFalse:[
        aSelector notNil ifTrue:[
            bindings := aBuilder bindings.
            bindings notNil ifTrue:[
                "if there are bindings, fetch the action from bindings.
                 This makes us compatible with ActionButtons"
                b := bindings at:aSelector ifAbsent:nil.
                b notNil ifTrue:[^ [:dummyArg| b value:true]].
            ].

            appl := aBuilder application.
            appl notNil ifTrue:[
                nA := aSelector numArgs.
                nA == 1 ifTrue:[ 
                    ^ [:selIdxOrVal | appl perform:aSelector with:selIdxOrVal] 
                ].
                nA == 2 ifTrue:[ 
                    ^ [:selIdxOrVal :additionalArg | appl perform:aSelector with:selIdxOrVal with:additionalArg] 
                ].
                ^ [appl perform:aSelector].
            ].
        ]
    ].
    ^ nil
!

channel:aChannelSymbol inBuilder:aBuilder
    |c|

    c := self perform:aChannelSymbol.
    c isSymbol ifTrue:[
        ^ self getBindingIn:aBuilder binding:c
    ].
    ^ c

    "Created: 28.3.1997 / 20:33:57 / cg"
!

createViewFor:aBuilder in:aParentView
    "low level create - no attributes are set.
     Can be redefined for special creation (see arbitraryComponentSpec)"

    ^ self basicCreateViewFor:aBuilder in:aParentView.
!

defineCallBackActionFor:aSelector with:aBuilder
    "cg: renamed - it does not define anything, only return it"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #callBackActionFor:with:'.
    ^ self callBackActionFor:aSelector with:aBuilder
!

getBindingIn:aBuilder
    ^ self getBindingIn:aBuilder binding:#model
!

getBindingIn:aBuilder binding:b
    ^ aBuilder aspectAt:b
!

getLabel:label translate:translateLabel with:aBuilder
    "setup a view's label; if translate is true, the string is passed
     through the resource translation mechanism (national language string)"

    |l translate|

    (label isNil or:[label isImageOrForm]) ifTrue:[
        ^ label.
    ].

    translate := translateLabel.
    (label isSymbol or:[self hasCharacterOrientedLabel not]) ifTrue:[
        l := aBuilder labelFor:label asSymbol.
        l notNil ifTrue:[
            "/ labels fetched from the application are supposed
            "/ to be already translated
            translate := false.
        ].
    ].

    l isNil ifTrue:[
        l := label.
    ].

    (translate == true and:[l isImageOrForm not]) ifTrue:[
        l := aBuilder translateString:l.
    ].
    ^ l

    "Modified: / 29-10-1997 / 21:41:50 / cg"
    "Created: / 10-03-1998 / 17:05:49 / stefan"
    "Modified (comment): / 31-08-2017 / 20:17:47 / cg"
!

layout:aLayout for:aView
    |l isExtent isLayoutFrame wResizeHandle hResizeHandle display|

    self useDefaultExtent ifTrue:[
        ^ self.
    ].

    isExtent := false.
    isLayoutFrame := false.

    aLayout notNil ifTrue:[
        aLayout isAssociation ifTrue:[
            aLayout key == #extent ifTrue:[
                isExtent := true.
                l := aLayout value copy.
            ]
        ] ifFalse:[
            l := aLayout copy.
            aView geometryLayout:l.
            isLayoutFrame := (l isKindOf:LayoutFrame).
        ]
    ].

    self usePreferredHeight ifTrue:[
        isLayoutFrame ifTrue:[
            l bottomFraction:0; bottomOffset:(aView top - aView superViewRectangle top + aView preferredHeight)
        ] ifFalse:[
            isExtent ifTrue:[
                l y:"aView top + "aView preferredHeight.
            ] ifFalse:[
                'UISpecification [info]: preferredHeight only allowed with layoutFrame' infoPrintCR.
            ]
        ].
    ].
    self usePreferredWidth ifTrue:[
        isLayoutFrame ifTrue:[
            l rightFraction:0; rightOffset:(aView left - aView superViewRectangle left + aView preferredWidth)
        ] ifFalse:[
            isExtent ifTrue:[
                l x:aView preferredWidth.
            ] ifFalse:[
                'UISpecification [info]: preferredWidth only allowed with layoutFrame' infoPrintCR.
            ]
        ].
    ].
    self useDynamicPreferredHeight ifTrue:[
        isLayoutFrame ifTrue:[
            l bottomFraction:0; bottomOffset:[ aView top - aView superViewRectangle top + aView preferredHeight ]
        ] ifFalse:[ 
            isExtent ifTrue:[
                self useDynamicPreferredWidth ifTrue:[
                    l := [ aView preferredExtent ].
                ] ifFalse:[
                    |w|
                    w := l x.
                    l := [ w @ (aView preferredHeight) ].
                ].
            ] ifFalse:[
                'UISpecification [info]: dynamic preferredHeight only allowed with layoutFrame' infoPrintCR.
            ]
        ].
    ].
    self useDynamicPreferredWidth ifTrue:[
        isLayoutFrame ifTrue:[
            l rightFraction:0; rightOffset:[ aView left  - aView superViewRectangle left + aView preferredWidth ]
        ] ifFalse:[
            isExtent ifTrue:[
                l isBlock ifFalse:[
                    self useDynamicPreferredHeight ifTrue:[
                        l := [ aView preferredExtent ].
                    ] ifFalse:[
                        |h|
                        h := l y.
                        l := [ aView preferredWidth @ h ].
                    ].
                ].
            ] ifFalse:[
                'UISpecification [info]: dynamic preferredWidth only allowed with layoutFrame' infoPrintCR.
            ]
        ].
    ].
    (isLayoutFrame and:[display := Screen current. display notNil]) ifTrue:[
        self keepSpaceForOSXResizeHandleH ifTrue:[
            wResizeHandle := display extentOfResizeHandle x.
            wResizeHandle > 0 ifTrue:[
                (l rightFraction = 1 and:[l bottomFraction = 1]) ifTrue:[
                    l rightOffset negated < wResizeHandle ifTrue:[
                        l rightOffset:(l rightOffset - wResizeHandle)
                    ]
                ]
            ]
        ] .
        self keepSpaceForOSXResizeHandleV ifTrue:[
            hResizeHandle := display extentOfResizeHandle y.
            hResizeHandle > 0 ifTrue:[
                (l rightFraction = 1 and:[l bottomFraction = 1]) ifTrue:[
                    l bottomOffset negated < hResizeHandle ifTrue:[
                        l bottomOffset:(l bottomOffset - hResizeHandle)
                    ]
                ]
            ]
        ]
    ].

    isExtent ifTrue:[
        aView extent:l.
    ].
!

modelInBuilder:aBuilder
    |modelAspect m adaptor path|

    m := self model.
    m notNil ifTrue:[
        m isBlock ifTrue:[^ m].

        aBuilder isEditing ifFalse:[
            m isSymbol ifTrue:[
                "/ special VW kludge:
                "/ if it's a multi-word symbol, separated by spaces,
                "/ the first word defines the aspect, 
                "/ the second and following an accessPath (i.e. a sequence
                "/ of messages to be sent to the value ... to get to the actual
                "/ value.)
                "/ In this case, create a ProtocolAdaptor here.
                "/
                "/ I hope that's really what it does - reading the code
                "/ from the PhoneBook example ...

                (m includes:Character space) ifTrue:[
                    (path := m asCollectionOfWords) size > 1 ifTrue:[
                        m := (path at:1) asSymbol.
                        path := (path copyFrom:2) collect:[:s | s asSymbol].
                    ] ifFalse:[
                        "/ just in case there was a space ...
                        "/ should we trim it ?
                        path := nil.
                    ]
                ].

                modelAspect := m.
                m := self getBindingIn:aBuilder binding:modelAspect.

                m isNil ifTrue:[
                    ('%1 [info]: application (%2) doesn''t provide a #%3 aspect.' 
                        bindWith:self className with:aBuilder application with:modelAspect) infoPrintCR.
                ] ifFalse:[
                    path notNil ifTrue:[
                        adaptor := ProtocolAdaptor accessPath:path.
                        adaptor subjectChannel:m.
                        ^ adaptor
                    ]
                ]
            ]
        ].
    ].
    ^ m

    "Modified: / 30-01-1998 / 02:03:41 / cg"
    "Modified (format): / 13-02-2017 / 20:33:48 / cg"
!

postBuildView:aView for:aBuilder
    "callback from builder, when a components subComponents
     have been built - allows for late fixups ..."

    "Created: / 26.10.1997 / 22:30:11 / cg"
!

postCreateView:v for:aBuilder
    aBuilder notNil ifTrue:[
        "/ code moved to the builder
        aBuilder createdComponent:v forSpec:self named:name.
    ].

    "Modified: / 31.10.1997 / 18:45:12 / cg"
!

setAcceptAttributesIn:aView with:aBuilder
    "for editfields and friends"
    
    aView immediateAccept:(self immediateAccept).
    aView acceptOnReturn:(self acceptOnReturn).
    aView acceptOnTab:(self acceptOnTab).
    aView acceptOnLeave:(self acceptOnLeave).
    aView acceptOnLostFocus:(self acceptOnLostFocus).
    aView acceptOnPointerLeave:(self acceptOnPointerLeave).
    aView acceptIfUnchanged:self acceptIfUnchanged.

    "Modified (comment): / 24-11-2017 / 00:30:34 / cg"
!

setAttributesIn:aView with:aBuilder
    "having just built a view, now, set my attributes in aView
     (actually, translating ST-80 messages to ST/X messages where required)"

    |helpKey|

    name notNil ifTrue:[
        aView notNil ifTrue:[
            aView name:name.
            "/ could be a visualComponent ...    
            "/ aView perform:#name: with:name ifNotUnderstood:nil.
        ].
    ].
    helpKey := activeHelpKey.

    "/ breaks tooltips; q: why ?
    "/ (helpKey isNil ifTrue:[
    "/        helpKey := self model.
    "/    ].
    helpKey notNil ifTrue:[
        aBuilder helpKeyFor:aView put:helpKey.
    ].

    uuid notNil ifTrue:[
        aView perform:#automationUUID: with:uuid ifNotUnderstood:nil.
    ].

    "/ install all attributes for the view
    attributes notNil ifTrue:[
        aView notNil ifTrue:[
            1 to: attributes size by: 2 do:[ :i | 
                | sym attr |

                sym  := attributes at:i.
                sym isString ifTrue:[
                    sym  := sym asSymbol.
                    attr := attributes at:(i + 1).
                    aView objectAttributeAt:sym put:attr. 
                ]
            ]
        ]        
    ].

    "/ Set the attributes to the view in order to have later access to the attributes from the Specs
    attributes := aView.

"/ WO wants this.
"/    (aBuilder respondsTo: #view) ifTrue:[
"/        aBuilder view: aView.
"/    ].
"/    aBuilder spec: self.

    self setPropertiesIn:aView with:aBuilder.
    style notNil ifTrue:[self setStyle:style in:aView with:aBuilder].
    colors notNil ifTrue:[ self setColorAttributesIn:aView with:aBuilder].

    aBuilder isEditing ifTrue:[^self].
    self setChannelsIn:aView with:aBuilder.

    "Modified: / 26-01-1998 / 16:17:00 / av"
    "Modified: / 09-11-2017 / 22:36:41 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    "to be redefined (with super ...) in subclasses which have channels" 
!

setColorAttributesIn:v with:aBuilder
    |clr|

    colors notNil ifTrue:[
        clr := colors at:#backgroundColor ifAbsent:nil.
        clr notNil ifTrue:[
            clr := self resolveColor:clr ifUnknown:[Color yellow] with:aBuilder.
            v backgroundColor:clr
        ].

        clr := colors at:#foregroundColor ifAbsent:nil.
        clr notNil ifTrue:[
            clr := self resolveColor:clr ifUnknown:[Color red] with:aBuilder.
            v foregroundColor:clr
        ].
    ].
!

setKeyboardFocusAttributesIn:aView with:aBuilder
!

setLayoutsInLayoutContainer:aLayoutContainer
    "/ intentionally left blank here
!

setModelAttributeIn:aView with:aBuilder
    "set my model attributes to aView (or its model)"
    "to be redefined (with super ...) in subclasses which have additional model(s)"

    aBuilder isEditing ifFalse:[
        aView model:(self modelInBuilder:aBuilder)
    ]
                                
!

setModelIn:aView useIndex:useIndex with:aBuilder
    |model listMsg listHolder constantList adapter|

    aBuilder isEditing ifTrue:[
        ^ self
    ].

    model:= self modelInBuilder:aBuilder.

    "/ special - allow constant list.

    (listMsg := self listSelector) isArray ifTrue:[
        constantList := listMsg.
        listHolder := nil.
        model isNil ifTrue:[
            aView list:constantList.
            ^ self
        ].
    ] ifFalse:[
        listHolder := self getBindingIn:aBuilder binding:listMsg.
    ].

    (model notNil or:[listHolder notNil]) ifTrue:[
        MessageNotUnderstood
            handle:[:ex| 
                adapter := useIndex == true 
            ] do:[
                aView useIndex:(useIndex == true)
            ].

        (model isKindOf:SelectionInList) ifTrue:[
            aView useIndex:true.

            "/ kludge for SelectionInListView
            "/ For VW compatibility, we MUST set the model
            "/ correctly to be a selectionInList;
            "/ however, our other views do not fully
            "/ work with it yet.
            "/ (must check/change comboXXX, popupList etc.)

            ((aView isKindOf:SelectionInListView) 
            or:[(aView isKindOf:ScrollableView) and:[ (aView scrolledView isKindOf:SelectionInListView)]]) ifTrue:[
                aView printItems:true.
                aView aspectMessage:#list.
                aView changeMessage:#selectionIndex:.
                aView initialSelectionMessage:#selectionIndex.
                aView model:model.
                listHolder notNil ifTrue:[
                    model listHolder:listHolder
                ].
                constantList notNil ifTrue:[
                    model list:constantList
                ].
            ] ifFalse:[
                aView aspectMessage:#value.
                aView listHolder:(model listHolder).
                aView 
                    model:(self 
                            validateModel:(model selectionIndexHolder) 
                            forView:aView 
                            withValue:constantList).
            ].
            ^ self
        ].

        listHolder notNil ifTrue:[
            aView listHolder:listHolder.
            constantList notNil ifTrue:[
                listHolder value:constantList
            ].
        ].

        model notNil ifTrue:[
            aView changeMessage:#value:.
            aView aspectMessage:#value.

            adapter == true ifTrue:[
                listHolder notNil ifTrue:[
                    aView model:((PluggableAdaptor on:model)

                       getBlock:[:m||idx s l|
                                    (idx := m value) notNil ifTrue:[
                                        l := listHolder value.
                                        (l size ~~ 0) ifTrue:[
                                            s := l at:idx ifAbsent:nil
                                        ].
                                    ].
                                    s
                                ]
                       putBlock:[:m :arg||l s|
                                    s := nil.
                                    arg notNil ifTrue:[
                                        l := listHolder value.
                                        l size ~~ 0 ifTrue:[
                                            s := l findFirst:[:e| e = arg ].
                                        ]
                                    ].
                                    model value:s
                                ]
                    updateBlock:[:m :aspect :p | true ])
                ]
            ] ifFalse:[
                aView model:(self validateModel:model forView:aView withValue:constantList).
            ]
        ]
    ]

    "Modified: / 27.1.1998 / 09:17:36 / stefan"
    "Modified: / 20.6.1998 / 12:13:30 / cg"
!

setViewBackgroundAttribute:backgroundColor in:aView with:aBuilder
    "setup a view's viewBackground"

    |viewBG newBG default convertedBackgroundColor|

    viewBG := aView viewBackground.
    backgroundColor notNil ifTrue:[
        convertedBackgroundColor := self resolveColor:backgroundColor ifUnknown:[Color yellow] with:aBuilder.
        convertedBackgroundColor ~= viewBG ifTrue:[
            newBG := convertedBackgroundColor.
        ]
    ] ifFalse:[
        viewBG ~= (default := aView class defaultViewBackgroundColor) ifTrue:[
            newBG := default.
        ]
    ].
    newBG notNil ifTrue:[ 
        aView viewBackground:newBG.
        aView backgroundColor:newBG.
        aView shown ifTrue:[
            aView clearView
        ]
    ]

    "Created: / 25-10-1997 / 18:30:22 / cg"
    "Modified: / 26-10-1997 / 22:14:10 / cg"
    "Modified (comment): / 31-08-2017 / 20:17:51 / cg"
!

setVisibilityAttribute:invisible in:v

    v hiddenOnRealize:invisible.

    v id notNil ifTrue:[
        invisible 
            ifTrue:[v beInvisible]
            ifFalse:[v beVisible]
    ]
!

setVisibilityChannel:aHolder inView:aView with:aBuilder
    "set my visibility channel in aView"

    aView visibilityChannel:aHolder

!

setupInitialLayoutFor:aView
    |layout|

    (aView specClass isLayoutContainer) ifTrue:[
        layout := aView bounds asLayout
    ] ifFalse:[
        aView extent = aView preferredExtent ifTrue:[
            layout := LayoutOrigin fromPoint:aView bounds origin
        ] ifFalse:[
            layout := aView bounds asLayout.
        ]
    ].

    aView geometryLayout:layout
!

validateModel:aModel forView:aView withValue:constantValue
    "nothing done here - but can be redefined to check
     for the model being of correct type for that view,
     and return an adapted or converted model, and/or
     change the view's aspect/changeSelectors as appropriate.
     (for example: being a selectionInList in a sequenceView)"

    ^ aModel

    "Modified: / 26.10.1997 / 14:56:50 / cg"
    "Created: / 26.10.1997 / 15:12:17 / cg"
!

validateSelectionInListModel:aModel forView:aView withValue:constantList
    "about to set the model.
     If it's a plain valueHolder, change the listMessage
     to #value"

    (aModel respondsTo:#list) ifFalse:[
        "/ assume that the model holds the selection ...
        constantList notNil ifTrue:[aView listHolder:(constantList asValue)].
        (aView respondsTo:#listMessage:) ifTrue:[
            aView listMessage:nil.
        ].
        (aView respondsTo:#initialSelectionMessage:) ifTrue:[
            aView initialSelectionMessage:nil.
        ].
        ^ aModel
    ].
    ^ aModel

    "Created: / 26-10-1997 / 19:11:00 / cg"
    "Modified (comment): / 13-02-2017 / 20:33:53 / cg"
!

wrappedViewOf:aView
    "redefined in specs, which automatically build a wrapper
     (scroller) around a component"

    ^ aView

    "Created: 20.6.1997 / 14:25:06 / cg"
! !

!UISpecification methodsFor:'converting'!

basicFromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray.
     Similar to Object>>fromLiteralArrayEncoding: ;
     however, does NOT decode the arguments."

    |sel litVal
     stop   "{ Class:SmallInteger }" |

    stop := aSpecArray size.

    2 to:stop by:2 do:[:i |
        sel := aSpecArray at:i.
        litVal := aSpecArray at:i+1.
        self 
            perform:sel with:litVal "unevaluated here" 
            ifNotUnderstood:[
                |msg|
                
                "/ The value is:   litVal storeString.    
                self breakPoint:#cg info:('Unrecognized attribute in spec: #', sel printString).

                msg := '%1: unhandled literalArrayEncoding attribute:'
                            bindWith:self class name
                            with:sel.
                UnhandledAttributeInLiteralArrayErrorSignal isHandled ifTrue:[
                    UnhandledAttributeInLiteralArrayErrorSignal new
                        badLiteralArray:self; parameter:sel;
                        notify:msg.
                ] ifFalse:[    
                    msg infoPrintCR.
                ].
            ]
    ].

    "Created: / 30-01-2000 / 01:15:15 / cg"
!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    self basicFromLiteralArrayEncoding:aSpecArray.

    colors notNil ifTrue:[colors := colors decodeAsLiteralArray].
    style notNil ifTrue:[style := style decodeAsLiteralArray].

    layout notNil ifTrue:[
        layout isAssociation ifFalse:[
            layout := layout decodeAsLiteralArray.
        ] ifTrue:[
            layout := #extent->(layout value decodeAsLiteralArray)
        ]
    ].
    uuid notNil ifTrue:[
        uuid := uuid decodeAsLiteralArray.
    ].

    "
        UISpecification from:
             #(#FullSpec 
                #window: 
                    #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #min: #(#Point 50 50 ) 
                        #bounds: #(#Rectangle 448 407 648 607 ) ) 
                #component: 
                    #(#SpecCollection
                        #collection: 
                            #(
                                #(#LabelSpec 
                                    #layout: #(#Point 0 2 ) 
                                    #label: 'Classes:' )
                                #(#SequenceViewSpec 
                                    #layout: #(#LayoutFrame 0 0 27 0 0 1 0 1 ) 
                                    #model: #classChoice 
                                    #tabable: false ) 
                                #(#InputFieldSpec 
                                    #layout: #(#LayoutFrame 70 0 2 0 0 1 25 0 )   
                                    #model: #classPattern ) ) ) )
    "

    "Modified: / 30.1.2000 / 01:15:36 / cg"
!

literalArrayEncoding
    "generate a literalArrayEncoding array for myself.
     This uses #literalArrayEncodingSlotOrder which defines the slots and
     order and #skippedInLiteralEncoding which defines slots to skip.
     For most subclasses, there is no need to redefine those."

    |instSlots literalArray cls skipped savedLayout coll2 attrs|

    "/ generate a unique uuid, if there is none yet.
    uuid isNil ifTrue:[
        uuid := UUID new printString. "/ stored as string, to make the spec simpler
    ].
    
    cls := self class.
    instSlots :=  cls allInstVarNames.
    literalArray := OrderedCollection new.
    literalArray add:cls name.

    "Get all the attributes. We assume here, that the instance variable 'attributes'
     actually holds the view for this spec. 
     Then we have a chance to get all attributes with objectAttributes. The 'attributes' instvar is set
     to the view in UISpecification>>setAttributesIn:with:"

    attrs := attributes objectAttributes.
    attrs notEmptyOrNil ifTrue:[
        coll2 := OrderedCollection new:attrs size.
        attrs keysAndValuesDo:[:eachAttributeKey :eachAttributeValue|
            eachAttributeValue notNil ifTrue:[
                "/ only add if not in instSlot
                (instSlots includes:eachAttributeKey) ifFalse:[
                    "/ KLUDGE for ca's objectAttribute misuse ...
                    (eachAttributeKey ~~ #snapPart and:[eachAttributeKey ~~ #vpext]) ifTrue:[
                        coll2 
                            add:eachAttributeKey;
                            add:eachAttributeValue literalArrayEncoding.
                    ]
                ]
            ]
        ].
        coll2 notEmpty ifTrue:[
            literalArray 
                add:#attributes:; 
                add:coll2 asArray.
        ].
    ].

    "/ kludge - see below
    layout isAssociation ifTrue:[
        savedLayout := layout.
        layout := nil.
    ].

    skipped := self skippedInLiteralEncoding.

    (self literalArrayEncodingSlotOrder) do:[:instSlot |
        |val eachInstvarName|

        eachInstvarName := instSlots at:instSlot.

        (skipped includes:eachInstvarName) ifFalse:[
            val := self perform:eachInstvarName asSymbol.
            val notNil ifTrue:[
                literalArray 
                    add:(eachInstvarName) asMutator;
                    add:val literalArrayEncoding
            ]
        ]
    ].

    "/ kludge
    savedLayout notNil ifTrue:[
        self useDefaultExtent ifFalse:[
            literalArray 
                add:#extent:; 
                add:savedLayout value literalArrayEncoding.
        ].
        layout := savedLayout.
    ].

    self otherAttributesLiteralArrayEncoding:literalArray.

    ^ literalArray asArray

    "Modified: / 26-01-1998 / 16:01:43 / av"
    "Modified: / 09-11-2017 / 22:28:40 / cg"
!

literalArrayEncodingSlotOrder
    "define the order in which inst-slots are saved when generating a literalArrayEncoding"

    |order idx|

    order := super literalArrayEncodingSlotOrder asOrderedCollection.

    "/ make certain, that the id and label come early
    idx := self class instVarIndexFor:'label'.
    idx notNil ifTrue:[
        order remove:idx.
        order add:idx afterIndex:1.
    ].
    "/ make certain, that the component comes late
    idx := self class instVarIndexFor:'component'.
    idx notNil ifTrue:[
        order remove:idx.
        order addLast:idx.
    ].
    ^ order

    "Modified (format): / 09-08-2018 / 17:29:01 / Claus Gittinger"
!

prettyPrintString
    ^ String streamContents:[:s | 
        self class prettyPrintSpecArray:self literalArrayEncoding on:s indent:0
    ]
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := OrderedCollection 
            with:#otherAttributes 
            with:#attributes
            with:#uiPainterAttributes.

    activeHelpKey isNil ifTrue:[l add:#activeHelpKey].
    self flags == 0     ifTrue:[l add:#flags].
    colors isNil        ifTrue:[l add:#colors].
    style isNil         ifTrue:[l add:#style].
    uuid isNil          ifTrue:[l add:#uuid].
    name isEmptyOrNil   ifTrue:[l add:#name].

    ^ l

    "Modified: / 24-01-1998 / 14:18:27 / av"
    "Modified: / 17-08-2011 / 15:34:22 / cg"
! !

!UISpecification methodsFor:'copying'!

postCopy
    "must copy collections as well"

    <modifier: #super> "must be called if redefined"

    layout := layout copy.
    layout isAssociation ifTrue:[ layout value:layout value copy].
    otherAttributes := otherAttributes copy.
    colors := colors copy.

    "Modified (comment): / 08-02-2017 / 00:16:04 / cg"
! !

!UISpecification methodsFor:'drag & drop'!

canDropSelector
    ^ self propertyAt:#canDropSelector:
!

canDropSelector:aSelector
    self propertyAt:#canDropSelector: put:aSelector

!

displayObjectSelector
    ^ self propertyAt:#displayObjectSelector:

!

displayObjectSelector:aSelector
    self propertyAt:#displayObjectSelector: put:aSelector

!

dragAndDropArgumentAt:aKey
    |arg|

    (arg := self propertyAt:aKey) notNil ifTrue:[
        ^ arg isSymbol ifTrue:[ '#', arg ]
                      ifFalse:[ arg printString ]
    ].
    ^ nil
!

dragAndDropArgumentAt:aKey put:anArgument
    |arg|

    (arg := anArgument) notNil ifTrue:[
        arg := arg withoutSeparators.

        arg size == 0 ifTrue:[
            arg := nil
        ] ifFalse:[
            (arg at:1) == $# ifTrue:[
                arg := (arg copyFrom:2) asSymbol
            ] ifFalse:[
                arg := Number readFrom:arg onError:arg
            ]
        ]
    ].
    self propertyAt:aKey put:arg
!

dragArgument
    ^ self dragAndDropArgumentAt:#dragArgument:
!

dragArgument:anArgument
    self dragAndDropArgumentAt:#dragArgument: put:anArgument
!

dropArgument
    ^ self dragAndDropArgumentAt:#dropArgument:
!

dropArgument:anArgument
    self dragAndDropArgumentAt:#dropArgument: put:anArgument

!

dropFeedBackSelector
    ^ self propertyAt:#feedBackSelector:
!

dropFeedBackSelector:aSelector
    self propertyAt:#feedBackSelector: put:aSelector
!

dropObjectSelector
    ^ self propertyAt:#dropObjectSelector:

!

dropObjectSelector:aSelector
    self propertyAt:#dropObjectSelector: put:aSelector

!

dropSelector
    ^ self propertyAt:#dropSelector:

!

dropSelector:aSelector
    self propertyAt:#dropSelector: put:aSelector

!

enterSelector
    ^ self propertyAt:#enterSelector:

!

enterSelector:aSelector
    self propertyAt:#enterSelector: put:aSelector

!

leaveSelector
    ^ self propertyAt:#leaveSelector:
!

leaveSelector:aSelector
    self propertyAt:#leaveSelector: put:aSelector

!

overSelector
    ^ self propertyAt:#overSelector:

!

overSelector:aSelector
    self propertyAt:#overSelector: put:aSelector

!

startDragSelector
    ^ self propertyAt:#startDragSelector:

!

startDragSelector:aSelector
    self propertyAt:#startDragSelector: put:aSelector

! !

!UISpecification methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for me and all of my sub-componen-specs.
     To be redefined in specs which have children"
     
    aBlock value:self
!

findSpecForWhich:aBlock
    "find a spec"

    self do:[:subSpec | (aBlock value:subSpec) ifTrue:[^ subSpec]].
    ^ nil
!

findSpecNamed:aName
    "find a spec by name"

    self do:[:subSpec | subSpec name = aName ifTrue:[^ subSpec]].
    ^ nil
! !

!UISpecification methodsFor:'help'!

helpSpec
    ^ self class helpSpec
! !

!UISpecification methodsFor:'helpers'!

resolveColor:colorOrSymbol ifUnknown:relacementValue with:aBuilder 
    "resolve colorOrSymol to a real color"

    |color|

    colorOrSymbol isSymbol ifTrue:[
        aBuilder isEditing ifTrue:[
            "special for UIPainter setup: check class for color"
            aBuilder applicationClass notNil ifTrue:[
                color := aBuilder applicationClass colorFor:colorOrSymbol.
            ].
            color isNil ifTrue:[ ^ relacementValue value "Color yellow" ].
            ^ color.
        ].    
        color := aBuilder application colorFor:colorOrSymbol.
        color isNil ifTrue:[
            ('Missing color <1p> in <2p>' expandMacrosWith:colorOrSymbol with:aBuilder application class) errorPrintCR.
            ^ relacementValue value "Color red".
        ].
        ^ color.
    ].

    ^ colorOrSymbol
!

resolveColor:colorOrSymbol with:aBuilder 
    "resolve colorOrSymbol to a real color"

    ^ self 
        resolveColor:colorOrSymbol 
        ifUnknown:[ aBuilder isEditing 
                        ifTrue:[Color yellow]
                        ifFalse:[Color red]
                  ]
        with:aBuilder
!

sendMessage:selector withOptionalArg:optionalArg to:target
    selector notNil ifTrue:[
        target perform:selector withOptionalArgument:optionalArg
    ]
! !

!UISpecification methodsFor:'initialization'!

initialize
! !

!UISpecification methodsFor:'obsolete'!

feedBackSelector
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #dropFeedBackSelector'.
    ^ self dropFeedBackSelector
!

feedBackSelector:aSelector
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #dropFeedBackSelector:'.
    self dropFeedBackSelector:aSelector
!

parseArg:argSpec
    <resource: #obsolete>

    |first cls selector|

    "
     if the arg is another spec,
     parse it and assign the resulting spec-object
    "
    ((argSpec isMemberOf:Array)
    and:[argSpec size > 1]) ifTrue:[
        first := argSpec at:1.
        cls := self resolveName:first.

        cls notNil ifTrue:[
            "
             check for special args first ...
            "
            selector := ('get' , first) asMutator.
            (self respondsTo:selector) ifTrue:[
                ^ self perform:selector with:argSpec
            ]
        ].

        (cls notNil and:[cls isBehavior]) ifTrue:[
            "
             ok, another spec ...
            "
            ^ UISpecification from:argSpec.
        ].

        (first endsWith:'Spec') ifTrue:[
            "
             mhmh - non existing (unsupported) spec.
            "
            ^ UISpecification from:argSpec.
        ]
    ].

    ^ argSpec

    "
     UISpecification new parseArg: #( Point 50 50 )  
     UISpecification new parseArg: #( Rectangle 10 15 50 100 ) 
     UISpecification new parseArg: #( LayoutFrame 0 0 27 0 0 1 0 1 )  
     UISpecification new parseArg: 'hello'     
     UISpecification new parseArg: #( LabelSpec 
                                        #layout: #(#Point 0 2 ) 
                                        #label: 'Classes:' )  
    "
!

parseSpecCollectionFrom:argArray
    <resource: #obsolete>
    |collection|

    ((argArray at:2) ~~ #collection:) ifTrue:[
        self error:'UISpecification: unexpected specCollection' mayProceed:true.
        ^ argArray
    ].

    collection := (argArray at:3) collect:[:el | UISpecification from:el].
    ^ collection

    "Modified: 17.1.1997 / 21:22:11 / cg"
! !

!UISpecification methodsFor:'other attributes'!

canUIDrag
    "true, if I can be dragged out of the UIGallery. All draggable objects are marked
     by the UIGalleryView::Canvas as such, to avoid the user from dragging out labels and other decoration.
     cg: I think this is a bad design by ca, to place this UIGallery specific, private stuff
     into the UISpec here - it ought to be an additional attribute placed onto the view 
     and handled in the UIGallery alone."

    |b|

    b := self otherAttributeAt:#canUIDrag.
    ^ b ? true
!

canUIDrag:aBool
    "true, if I can be dragged out of the UIGallery. All draggable objects are marked
     by the UIGalleryView::Canvas as such, to avoid the user from dragging out labels and other decoration.
     cg: I think this is a bad design by ca, to place this UIGallery specific, private stuff
     into the UISpec here - it ought to be an additional attribute placed onto the view 
     and handled in the UIGallery alone."

    self otherAttributeAt:#canUIDrag put:aBool
!

keepUILayout
    "true, if when I am dragged out of the UIGallery, the layout should be preserved.
     False by default, there is (currently) only one which has this attribute false
     (the buttonPanel)."

    |b|

    b := self otherAttributeAt:#keepUILayout.
    ^ b ? false
!

keepUILayout:aBool
    "true, if when I am dragged out of the UIGallery, the layout should be preserved.
     False by default, there is (currently) only one which has this attribute false
     (the buttonPanel)."

    self otherAttributeAt:#keepUILayout put:aBool.
!

otherAttributeAt:selector
    otherAttributes notNil ifTrue:[
        ^ otherAttributes at:selector ifAbsent:nil
    ].
    ^ nil
!

otherAttributeAt:selector put:args
    "change arguments assigned to a selector; in case of nil arguments,
     the selector will be removed from the otherAttributes list.
    "
    args isNil ifTrue:[
        otherAttributes notNil ifTrue:[
            otherAttributes removeKey:selector ifAbsent:nil.
        ]
    ] ifFalse:[
        otherAttributes isNil ifTrue:[
            otherAttributes := IdentityDictionary new.
        ].
        otherAttributes at:selector put:args
    ]
!

otherAttributesLiteralArrayEncoding:aColl
    "generate a literalArrayEncoding array for other attributes
    "
    |properties|

    properties := self properties.

    (properties notNil and:[properties isEmpty]) ifTrue:[
        self properties:nil
    ].

    otherAttributes isNil ifFalse:[
        otherAttributes keysAndValuesDo:[:k :v|
            v notNil ifTrue:[
                aColl add:k asMutator.
                aColl add:v literalArrayEncoding.
            ]
        ]
    ]
!

properties
    ^ self otherAttributeAt:#properties
!

properties:something
    |list|

    ((list := something) notNil and:[something class ~= PropertyListDictionary]) ifTrue:[
        list := PropertyListDictionary decodeFromLiteralArray:something
    ].
    self otherAttributeAt:#properties put:list

    "Modified: / 27-03-2007 / 08:44:13 / cg"
!

propertyAt:aKey
    |list|

    list := self otherAttributeAt:#properties.

    list notNil ifTrue:[
        ^ list at:aKey ifAbsent:nil
    ].
    ^ nil
!

propertyAt:aKey put:something
    |list|

    list := self otherAttributeAt:#properties.

    list isNil ifTrue:[
        something isNil ifTrue:[^ self].
        self otherAttributeAt:#properties put:(list := PropertyListDictionary new)
    ].
    list at:aKey put:something
!

setPropertiesIn:aView with:aBuilder
    "set properties; DragAndDrop"

    |properties receiver|

    (aBuilder isEditing
     or:[(receiver := aBuilder application) isNil
     or:[(properties := self properties) isEmptyOrNil]]) ifTrue:[
        ^ self
    ].

    self class supportsDrag ifTrue:[
        aView dropSource:(properties dropSourceFor:receiver)    
    ].
    self class supportsDrop ifTrue:[
        aView dropTarget:(properties dropTargetFor:receiver)    
    ]

    "Modified: / 17-03-2017 / 18:49:12 / stefan"
!

viewClassName
    ^ self otherAttributeAt:#viewClassName


!

viewClassName:aSymbol
    self otherAttributeAt:#viewClassName put:aSymbol
!

viewCreationMessage
    ^ self otherAttributeAt:#viewCreationMessage
!

viewCreationMessage:aSymbol
    self otherAttributeAt:#viewCreationMessage put:aSymbol
! !

!UISpecification methodsFor:'parsing a view'!

attributesFromView:aView
    "(try to) extract the attributes from the view"

    | attrs coll cls instSlots|

    coll := OrderedCollection new.

    (attrs := aView objectAttributes) notNil ifTrue:[
        cls := self class.
        instSlots := cls allInstVarNames.

        attrs keysAndValuesDo:[ :k :v | | key value |
            key := k asSymbol.
            "/ only add it if not in my instVars
            (instSlots includes:key) ifFalse:[
                (v respondsTo:#literalArrayEncoding) ifTrue:[
                    value := v literalArrayEncoding.
                ] ifFalse:[
                    value := v storeString.
                ].
                coll add:(Array with:key with:value).
            ]
        ]
    ].

    attributes := coll asArray.

    "Modified: / 25.1.1998 / 00:08:09 / av"
    "Created: / 3.2.1998 / 19:06:31 / cg"
    "Modified: / 5.2.2000 / 20:02:26 / cg"
!

dragAndDropArgumentsFromView:aView
    "(try to) extract the drag & drop attributes from the view
    "
    |attr dropSource dropTarget|

    (self class supportsDrag and:[(dropSource := aView dropSource) notNil]) ifTrue:[
        self startDragSelector:(dropSource startDragSelector).
        self dropFeedBackSelector:(dropSource dropFeedBackSelector).
        self dropObjectSelector:(dropSource dropObjectSelector).
        self displayObjectSelector:(dropSource displayObjectSelector).

        attr := dropSource argument.
        attr notNil ifTrue:[attr := attr printString].
        self dragArgument:attr.
    ].

    (self class supportsDrag and:[(dropTarget := aView dropTarget) notNil]) ifTrue:[
        self dropSelector:(dropTarget dropSelector).
        self canDropSelector:(dropTarget canDropSelector).
        self enterSelector:(dropTarget enterSelector).
        self overSelector:(dropTarget overSelector).
        self leaveSelector:(dropTarget leaveSelector).

        attr := dropTarget argument.
        attr notNil ifTrue:[attr := attr printString].
        self dropArgument:attr.
    ].

    "Modified: / 08-08-2010 / 15:19:20 / cg"
!

fromView:aView 
    "extract attributes from aView"

    ^ self fromView:aView callBack:nil

    "Created: / 13-02-1997 / 13:27:33 / cg"
    "Modified (comment): / 10-11-2017 / 00:14:29 / cg"
!

fromView:aView callBack:aBlock
    "extract attributes from aView;
     if aBlock is non-nil, call it for me and the view I copied from."

    |id|
    
    name := aView name.
    self layoutFromView:aView.
    self tabableFromView:aView.
    self attributesFromView:aView.
    self dragAndDropArgumentsFromView:aView.

    (id := aView automationUUID) notNil ifTrue:[
        uuid := id.
    ].
    
    aBlock notNil ifTrue:[
        aBlock value:self value:aView
    ].

    "Modified: / 22-01-1998 / 18:36:07 / av"
    "Modified: / 10-11-2017 / 00:16:07 / cg"
!

layoutFromView:aView
    |o c e absOrgX absOrgY relOrgX relOrgY relCornX relCornY absCornX absCornY
     superView absExtX absExtY relExtX relExtY pixelExt |

    superView := aView superView.
    (superView notNil and:[superView specClass canResizeSubComponents not]) ifTrue:[
        layout := nil.
        ^ self
    ].

    (layout := aView geometryLayout copy) notNil ifTrue:[
        ^ self
    ].
    "/
    "/ if the view is in a layoutContainer, only keep its extent.
    "/
    (superView notNil and:[superView specClass isLayoutContainer]) ifTrue:[
        pixelExt := aView computeExtent.
        layout := #extent->pixelExt.
        ^ self
    ].

    "/
    "/ the view has no layout - (but origin/extent or something else instead)
    "/ get the view's current dimension and create one
    "/
    (    aView originRule notNil 
     or:[aView extentRule notNil
     or:[aView cornerRule notNil]]
    ) ifTrue:[
        "/ layout := aView bounds asLayout
        layout := ((aView computeOrigin) corner:(aView computeCorner)) asLayout.
        ^ self
    ].
    relOrgX  := relOrgY := relCornX := relCornY := 0.
    absOrgX  := aView left.
    absOrgY  := aView top.
    absCornX := aView right.
    absCornY := aView bottom.

    "/ old ST/X views have no layout - look for relative components.
    (o := aView relativeOrigin) notNil ifTrue:[
        (relOrgX := o x) isInteger ifTrue:[absOrgX := relOrgX. relOrgX := 0]
                                  ifFalse:[absOrgX := 0].
        
        (relOrgY := o y) isInteger ifTrue:[absOrgY := relOrgY. relOrgY := 0]
                                  ifFalse:[absOrgY := 0].
    ].

    (c := aView relativeCorner) notNil ifTrue:[
        (relCornX := c x) isInteger ifTrue:[absCornX := relCornX. relCornX := 0]
                                   ifFalse:[absCornX := 0].

        (relCornY := c y) isInteger ifTrue:[absCornY := relCornY. relCornY := 0]
                                   ifFalse:[absCornY := 0].
    ].

    (e := aView relativeExtent) notNil ifTrue:[
        (relExtX := e x) isInteger ifTrue:[absExtX := relExtX. relExtX := nil].
        (relExtY := e y) isInteger ifTrue:[absExtY := relExtY. relExtY := nil].

        relExtX notNil ifTrue:[relCornX := relOrgX + relExtX. absCornX := 0]
                      ifFalse:[absCornX := absOrgX + absExtX. relCornX := 0].

        relExtY notNil ifTrue:[relCornY := relOrgY + relExtY. absCornY := 0]
                      ifFalse:[absCornY := absOrgY + absExtY. relCornY := 0].
    ].

    layout := LayoutFrame 
                    leftFraction:relOrgX offset:(absOrgX  + aView leftInset)
                    rightFraction:relCornX offset:(absCornX - aView rightInset)
                    topFraction:relOrgY offset:(absOrgY  + aView topInset)
                    bottomFraction:relCornY offset:(absCornY - aView bottomInset)
!

tabableFromView:aView
    "(try to) extract the canTab attribute from the view"

    aView canTab ifTrue:[
        self tabable:true
    ].

! !

!UISpecification methodsFor:'printing & storing'!

printOn:aStream
   self className printOn:aStream.
   name notNil ifTrue:[
       aStream nextPut:$(.
       name printOn:aStream.
       aStream nextPut:$).
   ].
! !

!UISpecification methodsFor:'queries'!

documentFileName
    "returns the basename of the file, which contains the html documentation for
     the widget (shown in the UI-Painters widget-doc)."

    ^ self userFriendlyName
!

hasApplication:aBuilder
    ^ aBuilder application notNil
!

hasCharacterOrientedLabel
    "this is true, if my label is not an image"

    ^ true

    "Modified: / 10.3.1998 / 17:01:57 / stefan"
!

hasKeyboardFocusInitially
    "this is true, if will catch the focus initially (there should only be one...)"

    ^ false
!

resolveName:className 
    ^ self class resolveName:className

    "Modified (format): / 30-12-2011 / 11:01:51 / cg"
!

resolveName:className in:aBuilder
    ^ self class resolveName:className in:aBuilder

    "Modified (format): / 30-12-2011 / 11:01:56 / cg"
!

usefulReplacementSpecClassNames
    "returns a list of possible replacement UISpec-class names."

    ^ #()
!

usefulReplacementSpecClasses
    "returns a list of possible replacement UISpec-classes."

    ^ self usefulReplacementSpecClassNames collect:[:each| Smalltalk at:each asSymbol]
!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^self class userFriendlyName
!

viewClass
    "returns the view class to be created for that spec
     This is an instance method, since it may depend on some attribute.
     However, here we ask the class, to allow for class-specific defaults."

    ^ self class viewClass
! !

!UISpecification methodsFor:'queries-UIDefiner'!

actionSelectors
    "return my action selectors (these generate callBack stub methods in the definer)"

    |plist props|

    (     (props := self properties) notNil
     and:[(plist := props actionSelectors) notNil]
    ) ifTrue:[
        ^ plist
    ].
    ^ OrderedCollection new

    "Modified: / 10.2.2000 / 01:26:15 / cg"
!

aspectSelectors
    "return my aspect selectors (these generate aspect methods in the definer)"

    ^ self basicAspectSelectors.

    "Modified: / 10.2.2000 / 01:24:25 / cg"
!

basicAspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |plist props|

    (     (props := self properties) notNil
     and:[(plist := props aspectSelectors) notNil]
    ) ifTrue:[
        ^ plist
    ].
    ^ OrderedCollection new

    "Modified: / 10.2.2000 / 01:24:25 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainter's aspectGenerator;
     Return the default class for some aspect's value."

    ^ ValueHolder

    "Modified: / 21.4.1998 / 20:20:35 / cg"
!

defaultModelIsCallBackMethodSelector:someAspect
    "used by the UIPainters aspectGenerator;
     Return true if the aspect specifies an action method
     (or callBack) as opposed to a real model value."

    ^ false

    "Modified: / 21.4.1998 / 20:20:35 / cg"
    "Created: / 21.4.1998 / 20:21:38 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIPainters aspectGenerator;
     Return the default value for some aspect."

    ^ nil

    "Created: / 26.10.1997 / 18:59:17 / cg"
    "Modified: / 21.4.1998 / 20:20:18 / cg"
!

defaultModelValueStringFor:someAspect
    "used by the UIPainters aspectGenerator;
     Return the default value-generating string for some aspect."

    ^ nil

    "Created: / 26.10.1997 / 18:59:17 / cg"
    "Modified: / 21.4.1998 / 20:20:18 / cg"
!

valueSelectors
    "return my value selectors (these could generate simple value-returning stub methods in the definer)"

    ^ OrderedCollection new.
! !

!UISpecification methodsFor:'queries-UIPainter'!

hasLayout
    "return true, if my view/component optionally has a layout. 
     All Views and Components except for the lineSegment, spline and polygons, do
     support layouts. The other are defined by a set of controlling points."

    ^ true
!

icon
    ^ self class icon
!

nameOfMainAspect
    "return the name of the main aspect; this is used in the UIPainters tree
     to show the aspect of the widget.
     For example, for a checkBox, this is the name of the model-aspect;
     for a Label, this might be the name of the labelChannel-aspect."

    ^ self perform:#model ifNotUnderstood:nil.
!

needsRebuildForAttributes
    "return true, if my view must be rebuild
     when an attribute changes.
     True may be returned by a concrete subclass, 
     if attribute changes imply a view-class change 
     (such as horizontal/vertical)"

    ^ false

    "Created: / 1.3.1997 / 00:27:36 / cg"
    "Modified: / 21.4.1998 / 20:19:35 / cg"
!

realViewClass
    self obsoleteMethodWarning.

    ^ self realViewClassFor:nil

    "Modified: / 26-09-2011 / 16:18:24 / cg"
    "Modified (format): / 30-12-2011 / 11:02:13 / cg"
!

realViewClassFor:aBuilderOrNil
    "returns the real view class to be created for that spec.
     That is typically the UISpecs viewClass (i.e. what it thinks),
     but can be overwritten per instance in some widgets (and specified in
     the UIPainter)."

    |viewClassName cls|

    viewClassName := self viewClassName.
    (viewClassName notEmptyOrNil) ifTrue:[
        viewClassName isUppercaseFirst ifTrue:[
            (cls := self resolveName:viewClassName in:aBuilderOrNil) notNil ifTrue:[
                ^ cls autoload.
            ].
            ('UISpec [Warning]: no viewClass for "',viewClassName,'" - using default') errorPrintCR.
        ] ifFalse:[
            aBuilderOrNil isNil ifTrue:[
                self error:'no application'.
            ].
            aBuilderOrNil isEditing ifFalse:[
                ^ aBuilderOrNil application perform:viewClassName asSymbol
            ].
        ].
    ].
    ^ self viewClass.

    "Created: / 26-09-2011 / 16:17:52 / cg"
! !

!UISpecification methodsFor:'style'!

setStyle:aStyle in:aView 
    "backward compatibility
    "
    self setStyle:aStyle in:aView with:nil
!

setStyle:aStyle in:aView with:aBuilder
    "set style for a view"

    |font slaveView|

    aStyle notNil ifTrue:[
        font := aBuilder resolveFont:aStyle.

        font notNil ifTrue:[
            (aView isScrollWrapper) ifTrue:[
                (slaveView := aView scrolledView) notNil ifTrue:[
                    slaveView font:font
                ]
            ].
            aView font:font
        ]
    ] ifFalse: [
        "/ to reset
        aBuilder notNil ifTrue:[
            aBuilder isEditing ifFalse:[
                aView font: aView class defaultFont
            ]
        ]
    ]

    "Modified: / 20.6.1998 / 14:16:05 / cg"
! !

!UISpecification methodsFor:'testing'!

isWindowSpec
    ^ false
! !

!UISpecification methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    self subclassResponsibility.
    ^ aVisitor visitUISubSpecification:self
! !

!UISpecification::UIBindingsIdentityDictionary methodsFor:'accessing'!

builder
    "return the builder which is currently building the interface
     using myself as bindings."

    ^ builder

    "Created: / 30.1.1998 / 13:48:53 / cg"
    "Modified: / 30.1.1998 / 13:49:28 / cg"
!

builder:something
    "set the builder (which is currently building the interface
     using myself as bindings) useful for some tricky specs."

    builder := something.

    "Created: / 30.1.1998 / 13:48:53 / cg"
    "Modified: / 30.1.1998 / 13:49:53 / cg"
! !

!UISpecification::UIMajorKeyBindingNameSpaceQuery class methodsFor:'documentation'!

documentation
"
    this is used by the UISpec to ask for a possible overwrite of the namespace, in which majorKey bindings
    are searched for.
    This is only required in the ui-painter, as there is no application around in the builder,
    but still we need to know the application's namespace in order find figure out what subaspects are there to show
    in the painter's subAspects list.
    Confusing - I admit.
"
! !

!UISpecification::UIMajorKeyBindingNameSpaceQuery methodsFor:'defaults'!

defaultResumeValue
    "the default answer, if no one handles the query"

    ^ Smalltalk
! !

!UISpecification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UISpecification.st,v 1.385 2018-08-09 15:33:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/UISpecification.st,v 1.385 2018-08-09 15:33:28 cg Exp $'
! !


UISpecification initialize!
