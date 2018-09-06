"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ResourceSpecEditor subclass:#MenuEditor
	instanceVariableNames:'selectionHolder tabHolder listOfItems listOfTabs
		selectedSuperItems notifyDisabledCounter wizards listOfItemsView
		dropOverLine savedSpec'
	classVariableNames:'ImageRetrieverClasses'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'menuItem'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

ApplicationModel subclass:#ImageResourceEditor
	instanceVariableNames:'selectorHolder iconAndLabelHolder retrieverHolder imageHolder
		imageList selectorFilterHolder imageListView'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

HierarchicalItem subclass:#ImageResourceEditorItem
	instanceVariableNames:'selector icon'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor::ImageResourceEditor
!

MenuEditor::Item subclass:#ActionItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

MenuEditor::Item subclass:#LinkedMenuItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

MenuEditor::Item subclass:#MenuSliceItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

MenuEditor::Item subclass:#RegularMenuItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

MenuEditor::RegularMenuItem subclass:#RootItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

MenuEditor::Item subclass:#SeparatorItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEditor
!

!MenuEditor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    The MenuEditor allows you to create, modify or just inspect
    menu specifications. Such specifications are returned by menu-spec methods
    of the application class. These methods are typically tagged with a menu-resource.
    The menu editor is able to retrieve such specifications and generate new menu-spec
    methods.

    The editor is typically opened by double-clicking on a menu-spec method in the browser.

    [Instance variables:]

	listOfItemsView         <HierarcicalListView>  the view which shows the list of items
	listOfItems             <HierarchicalList>     hierarchical list of menu items
	listOfTabs              <List>                 list of current shown tab-labels

	selectionHolder         <ValueHolder>          collection of current selected items
	selectedSuperItems      <Collection>           collection of superItems derived from selection

	tabHolder               <ValueHolder>          selected tab label holder
	notifyDisabledCounter   <SmallInteger>         ~~ 0 than change notifications are discard
	wizards                 <IdentityDictionary>   keeps all created wizard dialogs

	dropOverLine            <nil or SmallInteger>  nil: drop context not dropabel.
						       = 0: drop context dropable but no item specified
						       ~ 0: drop context dropable for item at lineNumber
						       used t6o restore drop indication drawings

    [Class variables:]
	ImageRetrieverClasses   <Collection>        sorted collection of image receivers

    [start with:]
	MenuEditor open
	MenuEditor openOnClass:MenuEditor andSelector:#menu

    [author:]
	Claus Atzkern, eXept Software AG
	Thomas Zwick, eXept Software AG
"
! !

!MenuEditor class methodsFor:'initialization'!

initialize
    ImageRetrieverClasses := #(
				Icon
				SystemBrowser
				ToolbarIconLibrary
			      ).

    "
     self initialize
    "
! !

!MenuEditor class methodsFor:'instance creation'!

openModalOnMenu: aMenu
    "Open a MenuEditor modal on aMenu
     self openModalOnMenu: (self perform: #menu) decodeAsLiteralArray
    "
    ^self new openModalOnMenu:aMenu
! !

!MenuEditor class methodsFor:'accessing image retriever'!

addNewImageRetriever:aSymbolOrClass
    "add a class to the imageRetriever list"

    |key|

    aSymbolOrClass isBehavior ifTrue:[
	key := aSymbolOrClass nameWithNameSpacePrefix
    ] ifFalse:[
	key := aSymbolOrClass
    ].

    key size ~~ 0 ifTrue:[
	key := key asSymbol.

	(ImageRetrieverClasses includes:key) ifFalse:[
	    ImageRetrieverClasses := ImageRetrieverClasses asOrderedCollection.
	    ImageRetrieverClasses add:key.
	    ImageRetrieverClasses sort.
	]
    ].
!

imageRetrieverClasses
    "returns a collection of image retrievers
    "
    ^ ImageRetrieverClasses
! !

!MenuEditor class methodsFor:'aspects'!

aspects
    "get the aspects for the attributes of the menu components"

    ^#(
	rawLabel
	accessCharacterPosition
	showBusyCursorWhilePerforming
	horizontalLayout
	triggerOnDown
	font
	argument
	submenuChannel
	keepLinkedMenu
	enabled
	itemValue
	nameKey
	indication
	choice
	choiceValue
	translateLabel
	isButton
	shortcutKeyCharacter
	startGroup
	isVisible
	hideMenuOnActivated
	auxValue
	activeHelpKey
	resourceRetriever
	sendToOriginator
	ignoreMnemonicKeys
	ignoreShortcutKeys
	isMenuSlice
     )
! !

!MenuEditor class methodsFor:'defaults'!

resourceType
    "get the type of the resource of the method generated by the MenuEditor
    "
    ^ #menu
! !

!MenuEditor class methodsFor:'help specs'!

flyByHelpSpec
    ^super flyByHelpSpec addPairsFrom:(self localFlyHelpSpecStrings)
!

helpSpec
    ^super helpSpec addPairsFrom:(self localFlyHelpSpecStrings)

    "Modified: / 03-08-2011 / 10:13:37 / cg"
!

localFlyHelpSpecStrings
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MenuEditor
    "

    <resource: #help>

    ^ #(

#editCut
'Cut Item'

#editCopy
'Copy Item'

#editPaste
'Paste Item'

#fileSaveSpec
'Save Menuspec'

#addMenuSlice
'Add Menuslice'

#addDelayedMenu
'Add a new delayed menu to item.'

#addDelayedSubMenuLink
'Add a new linked delayed menu to item.'

#addMenuItem
'Add a new menu item.'

#addMenuSeparator
'Add a new menu separator.'

#addMenuSliceItem
'Add a new menu slice.'

#addSubMenu
'Add a new sub menu.'

#addSubMenuLink
'Add a new linked sub menu.'

#basicsAction
'An action selector with 0, 1 (the argument field), or 2 (the selected item) arguments.'

#browseMethod
'Open a browser on this method in the application. Create the method, if it does not exist.'

#basicsArgument
'An optional arg passed with above selector, if it is a 1 or 2 arg selector (enter a Smalltalk literal).'

#basicsChoice
'Aspect for a boolean holder, block or method, specifying the choices state (RadioButton behavior).'

#basicsChoiceValue
'That choices value (typically number or symbol).'

#basicsIndication
'Aspect for boolean holder, block, or method, specifying the indication state (CheckToggle behavior).'

#basicsIsButton
'Button-like look and behavior.'

#basicsKey
'Internal key of the item (optional, for programmed accesses).'

#basicsLabel
'Label of the item.'

#basicsMenu
'Aspect providing the sub menu to be opened if item is selected (provide spec or valueHolder).'

#basicsMenuArgument
'An argument passed with the menu selector.'

#basicsNameKey
'Unique identifier of the item (optional).'

#basicsSelector
'Selector under which the generated menu spec is saved.'

#basicsSeparatorType
'List of valid separators.'

#basicsTranslateLabel
'Translate the label via the classes resource file (internationalization).'

#browseResource
'Search for methods with image resource.'

#detailsAccelerator
'Accelerator key to select the menu item from the keyboard (Cmdx or Ctrlx).'

#detailsAccessCharaterPosition
'Index of the access character position of the textual label (obsolete, VW compatibility).'

#detailsAuxValue
'Some additional value - for arbitrary use by the program.'

#detailsEnabled
'Aspect or binding providing a boolean value holder to enable/disable the menu item.'

#detailsIgnoreAcceleratorKeys
'Ignore accelerator keys in submenu(s).'

#detailsIgnoreMnemonicKeys
'Ignore mnemonic keys (access characters) in submenu(s).'

#detailsStartGroup
'Specify start of a specially aligned group.'

#detailsVisibility
'Boolean, or aspect or binding for a boolean holder controlling the visibility of the menu item.'

#fileLoad
'Load a menu spec from a class.'

#fileNew
'Create a new menu spec.'

#filePickAMenu
'Select a menu from an open view and read its specification'

#fileChooseAMenu
'Select a menu from an open view and edit its spec-method'

#fileSave
'Save the menu spec (and the help spec, if modified).'

#fileSaveAs
'Open a dialog to save the menu spec (and the help spec, if modified).'

#fileShowMenuSpec
'Opens a Workspace showing the current menu spec.'

#generateAspectMethods
'Generates aspect methods for defined aspect selectors of the menu.'

#hideMenuOnActivated
'If on, the menu hides itself after the item was activated (PopUp/PullDown-Menus only).'

#horizontalLayout
'If on, the submenu organizes its items horizontal instead of vertical (default).'

#imageImageAndLabel
'Toggle display of both image and textual label.'

#imageImageEditor
'Open an Image Editor on the resource method defined by retriever and selector.'

#imageBrowseImageClass
'Open a Browser on the resource retriever class.'

#imageImageList
'Currently existing image resources.'

#imageRetriever
'Class implementing the image resource method. If unspecified, the application instance / class are asked.'

#imageSelector
'Selector returning an image (sent to above or the application).'

#keepLinkedMenu
'Keep the linked menu after activation (do not destroy; if off, menu is rebuild for every activation).'

#sendToOriginator
'Send action-Message to widget (instead of application); only valid for PopUpMenus.'

#settingsRedefineAspectMethods
'Toggles the permission to overwrite existing aspect methods.'

#showBusyCursorWhilePerforming
'If on, a busy cursor is shown while the items action is performing.'

#triggerOnDown
'If on, the items action is performed on mouse-button press (default is: on button-release).'

#selectorFilter
'In the list below, only matching selectors are shown'
)

    "Modified: / 03-08-2011 / 10:17:05 / cg"
! !

!MenuEditor class methodsFor:'image specs'!

browseActionImage
    <resource: #programImage>

    ^ UIPainter browseActionImage
!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary startMenuEditorIcon
!

iconUnknown
    "returns an image used for picked items containing an image
    "
    <resource: #programImage>

    ^ MenuPanelSpec icon
! !

!MenuEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor andSelector:#windowSpec
     MenuEditor new openInterface:#windowSpec
     MenuEditor open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Menu Editor'
	  name: 'Menu Editor'
	  min: (Point 550 385)
	  bounds: (Rectangle 0 0 574 473)
	  menu: menu
	  icon: defaultIcon
	  returnIsOKInDialog: false
	  escapeIsCancelInDialog: false
	)
	component:
       (SpecCollection
	  collection: (
	   (MenuPanelSpec
	      name: 'toolbar'
	      layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
	      tabable: true
	      menu: toolbar
	      showSeparatingLines: true
	    )
	   (VariableHorizontalPanelSpec
	      name: 'mainPanel'
	      layout: (LayoutFrame 0 0.0 34 0.0 0 1.0 -26 1.0)
	      component:
	     (SpecCollection
		collection: (
		 (HierarchicalListViewSpec
		    name: 'ListOfItemsView'
		    model: selectionHolder
		    menu: editMenu
		    hasHorizontalScrollBar: true
		    hasVerticalScrollBar: true
		    miniScrollerHorizontal: true
		    miniScrollerVertical: true
		    listModel: listOfItems
		    multipleSelectOk: true
		    useIndex: false
		    highlightMode: label
		    doubleClickSelector: indicatorClickedAt:
		    selectConditionSelector: canSelect:
		    showLeftIndicators: false
		    indicatorSelector: indicatorClickedAt:
		    properties:
		   (PropertyListDictionary
		      dropSelector: doDrop:
		      dragArgument: nil
		      dropObjectSelector: dropObjects
		      overSelector: dropOver:
		      dropArgument: nil
		      leaveSelector: dropLeave:
		      canDropSelector: canDrop:
		      enterSelector: dropEnter:
		    )
		    postBuildCallback: postBuildListOfItemsView:
		  )
		 (ViewSpec
		    name: 'Box'
		    level: -1
		    component:
		   (SpecCollection
		      collection: (
		       (NoteBookViewSpec
			  name: 'NoteBook'
			  layout: (LayoutFrame 1 0.0 0 0.0 1 1.0 -30 1.0)
			  enableChannel: hasSingleSelectionChannel
			  tabable: true
			  model: tabHolder
			  menu: listOfTabs
			  fitLastRow: false
			  translateLabel: true
			  canvas: wizardHolder
			  keepCanvasAlive: true
			  postBuildCallback: postBuildNoteBook:
			)
		       (UISubSpecification
			  name: 'SubSpecification'
			  layout: (LayoutFrame 2 0.0 -26 1 -2 1.0 -2 1.0)
			  majorKey: ToolApplicationModel
			  minorKey: windowSpecForCommit
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.300493 1.0)
	    )
	   (UISubSpecification
	      name: 'infoBarSubSpec'
	      layout: (LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
	      majorKey: ToolApplicationModel
	      minorKey: windowSpecForInfoBar
	    )
	   )

	)
      )
! !

!MenuEditor class methodsFor:'menu specs'!

addMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#addMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor addMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: addMenuSeparator
	    label: 'Separator'
	    itemValue: doCreateSep
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconSeparator '')
	  )
	 (MenuItem
	    activeHelpKey: addMenuItem
	    label: 'Item'
	    itemValue: doCreateItem
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconItem '')
	  )
	 (MenuItem
	    activeHelpKey: addMenuSliceItem
	    label: 'Menu Slice'
	    itemValue: doCreateMenuSliceItem
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconSliceMenu '')
	  )
	 (MenuItem
	    activeHelpKey: addMenuItem
	    label: 'Menu'
	    itemValue: doCreateMenu
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconMenu '')
	  )
	 (MenuItem
	    activeHelpKey: addSubMenuLink
	    label: 'Linked Menu'
	    itemValue: doCreateLinkedMenu
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconLinkedMenu '')
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: addDelayedMenu
	    enabled: canCreateDelayedMenuChannel
	    label: 'Delayed Menu'
	    itemValue: doCreateDelayedMenu:
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconDelayedMenu '')
	    argument: menu
	  )
	 (MenuItem
	    activeHelpKey: addDelayedSubMenuLink
	    enabled: canCreateDelayedMenuChannel
	    label: 'Delayed Linked Menu'
	    itemValue: doCreateDelayedMenu:
	    translateLabel: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconDelayedLinkedMenu '')
	    argument: linkedMenu
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Standard Menus'
	    translateLabel: true
	    submenuChannel: standardMenus
	    keepLinkedMenu: true
	  )
	 )
"/        nil
"/        nil
      )
!

editMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#editMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor editMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            activeHelpKey: editCut
            enabled: hasSelectionChannel
            label: 'Cut'
            itemValue: doCut
            translateLabel: true
            shortcutKey: Cut
          )
         (MenuItem
            activeHelpKey: editCopy
            enabled: hasSelectionChannel
            label: 'Copy'
            itemValue: doCopy
            translateLabel: true
            shortcutKey: Copy
          )
         (MenuItem
            activeHelpKey: editPaste
            enabled: canPasteHolder
            label: 'Paste'
            itemValue: doPaste
            translateLabel: true
            shortcutKey: Paste
          )
         (MenuItem
            activeHelpKey: editDelete
            enabled: hasSelectionChannel
            label: 'Delete'
            itemValue: doDelete
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: makeLinkedMenu
            enabled: hasNonLinkedMenuSelectedHolder
            label: 'Make Linked Menu...'
            itemValue: doMakeLinkedMenu
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editMoveUp
            enabled: enableMovingUpOrDownHolder
            label: 'Move Up'
            itemValue: doMoveUpOrDown:
            translateLabel: true
            startGroup: right
            shortcutKey: CtrlCursorUp
            labelImage: (ResourceRetriever Icon upIcon 'Move Up')
            argument: up
          )
         (MenuItem
            activeHelpKey: editMoveDown
            enabled: enableMovingUpOrDownHolder
            label: 'Move Down'
            itemValue: doMoveUpOrDown:
            translateLabel: true
            shortcutKey: CtrlCursorDown
            labelImage: (ResourceRetriever Icon downIcon 'Move Down')
            argument: down
          )
         (MenuItem
            activeHelpKey: editMoveIn
            enabled: enableMovingInHolder
            label: 'Move Into Next'
            itemValue: doMoveIn:
            translateLabel: true
            shortcutKey: CtrlCursorRight
            labelImage: (ResourceRetriever Icon downRightIcon 'Move Into Next')
            argument: inNext
          )
         (MenuItem
            activeHelpKey: editMoveInAbove
            enabled: enableMovingInAboveHolder
            label: 'Move Into Previous'
            itemValue: doMoveIn:
            translateLabel: true
            labelImage: (ResourceRetriever Icon upRightIcon 'Move Into Previous' )
            argument: inPrev
          )
         (MenuItem
            activeHelpKey: editMoveOut
            enabled: enableMovingOutHolder
            label: 'Move Out'
            itemValue: doMoveOut
            translateLabel: true
            shortcutKey: CtrlCursorLeft
            labelImage: (ResourceRetriever Icon leftDownIcon 'Move Out' )
          )
         )
        nil
        nil
      )
!

editMenuForMainMenuWithoutAccelerators
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#editMenuForMainMenuWithoutAccelerators
     (Menu new fromLiteralArrayEncoding:(MenuEditor editMenuForMainMenuWithoutAccelerators)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: editCut
	    enabled: hasSelectionChannel
	    label: 'Cut'
	    itemValue: doCut
	    translateLabel: true
	  )
	 (MenuItem
	    activeHelpKey: editCopy
	    enabled: hasSelectionChannel
	    label: 'Copy'
	    itemValue: doCopy
	    translateLabel: true
	  )
	 (MenuItem
	    activeHelpKey: editPaste
	    enabled: canPasteHolder
	    label: 'Paste'
	    itemValue: doPaste
	    translateLabel: true
	  )
	 (MenuItem
	    activeHelpKey: editDelete
	    enabled: hasSelectionChannel
	    label: 'Delete'
	    itemValue: doDelete
	    translateLabel: true
	    isVisible: false
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: editMoveUp
	    enabled: enableMovingUpOrDownHolder
	    label: 'Move Up'
	    itemValue: doMoveUpOrDown:
	    translateLabel: true
	    startGroup: right
	    labelImage: (ResourceRetriever Icon upIcon 'Move Up')
	    argument: up
	  )
	 (MenuItem
	    activeHelpKey: editMoveDown
	    enabled: enableMovingUpOrDownHolder
	    label: 'Move Down'
	    itemValue: doMoveUpOrDown:
	    translateLabel: true
	    labelImage: (ResourceRetriever Icon downIcon 'Move Down')
	    argument: down
	  )
	 (MenuItem
	    activeHelpKey: editMoveIn
	    enabled: enableMovingInHolder
	    label: 'Move Into Next'
	    itemValue: doMoveIn:
	    translateLabel: true
	    labelImage: (ResourceRetriever Icon downRightIcon 'Move Into Next')
	    argument: inNext
	  )
	 (MenuItem
	    activeHelpKey: editMoveInAbove
	    enabled: enableMovingInAboveHolder
	    label: 'Move Into Previous'
	    itemValue: doMoveIn:
	    translateLabel: true
	    labelImage: (ResourceRetriever Icon upRightIcon 'Move Into Previous')
	    argument: inPrev
	  )
	 (MenuItem
	    activeHelpKey: editMoveOut
	    enabled: enableMovingOutHolder
	    label: 'Move Out'
	    itemValue: doMoveOut
	    translateLabel: true
	    labelImage: (ResourceRetriever Icon leftDownIcon 'Move Out')
	  )
	 )
	nil
	nil
      )
!

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#fileMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor fileMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    isVisible: isNotEditingSpecOnlyAndNotEmbeddedInBrowser
	    activeHelpKey: fileNew
	    label: 'New'
	    itemValue: doNew
	    translateLabel: true
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnlyAndNotEmbeddedInBrowser
	    label: '-'
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnlyAndNotEmbeddedInBrowser
	    activeHelpKey: fileLoad
	    label: 'Load...'
	    itemValue: doLoad
	    translateLabel: true
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnlyAndNotEmbeddedInBrowser
	    label: '-'
	  )
	 (MenuItem
	    isVisible: isEditingSpecOnly
	    activeHelpKey: fileSaveSpec
	    label: 'Save'
	    itemValue: doSave
	    translateLabel: true
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnly
	    activeHelpKey: fileSave
	    label: 'Save'
	    itemValue: doSave
	    translateLabel: true
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnlyAndNotEmbeddedInBrowser
	    activeHelpKey: fileSaveAs
	    label: 'Save As...'
	    itemValue: doSaveAs
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: filePickAMenu
	    label: 'Pick a Menu...'
	    itemValue: doPickAMenu
	    translateLabel: true
	  )
	 (MenuItem
	    activeHelpKey: fileChooseAMenu
	    label: 'Choose a Menu...'
	    itemValue: doChooseAMenu
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	    isVisible: isStandAlone
	  )
	 (MenuItem
	    activeHelpKey: fileBrowseClass
	    enabled: hasValidSpecClass
	    label: 'Browse Class'
	    itemValue: doBrowseClass
	    translateLabel: true
	    isVisible: isStandAlone
	  )
	 (MenuItem
	    activeHelpKey: fileShowMenuSpec
	    label: 'Show Menu Spec'
	    itemValue: doShowMenuSpec
	    translateLabel: true
	    isVisible: isStandAlone
	  )
	 (MenuItem
	    label: '-'
	    isVisible: isStandAlone
	  )
	 (MenuItem
	    activeHelpKey: fileExit
	    label: 'Exit'
	    itemValue: closeRequest
	    translateLabel: true
	    isVisible: isStandAlone
	  )
	 )
	nil
	nil
      )
!

generateMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#generateMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor generateMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #activeHelpKey: #generateAspectMethods
	    #enabled: #hasValidSpecClass
	    #label: 'Aspect Methods'
	    #itemValue: #doGenerateAspectMethods
	    #translateLabel: true
	  )
	 )
	nil
	nil
      )
!

helpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#helpMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor helpMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #activeHelpKey: #helpTutorial
	    #label: 'Documentation'
	    #itemValue: #openHTMLDocument:
	    #translateLabel: true
	    #argument: 'tools/uipainter/MenuEditor.html'
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #helpHelpTool
	    #label: 'Help Tool'
	    #itemValue: #openHTMLDocument:
	    #translateLabel: true
	    #argument: 'tools/uipainter/HelpTool.html'
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #helpShowHelp
	    #label: 'Show Help Texts'
	    #translateLabel: true
	    #indication: #showingHelp:
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #aboutThisAppliaction
	    #label: 'About MenuEditor...'
	    #itemValue: #openAboutThisApplication
	    #translateLabel: true
	  )
	 )
	nil
	nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(MenuEditor menu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: '&File'
	    translateLabel: true
	    submenuChannel: fileMenu
	    keepLinkedMenu: true
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    label: '&Edit'
	    translateLabel: true
	    submenuChannel: editMenuForMainMenuWithoutAccelerators
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    enabled: hasSingleSelectionChannel
	    label: 'Item'
	    translateLabel: true
	    submenuChannel: addMenu
	    keepLinkedMenu: true
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    isVisible: isNotEditingSpecOnly
	    label: 'Generate'
	    translateLabel: true
	    submenuChannel: generateMenu
	    keepLinkedMenu: true
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    label: 'Test'
	    translateLabel: true
	    submenuChannel: submenuTest
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    label: 'Settings'
	    translateLabel: true
	    submenuChannel: settingsMenu
	    keepLinkedMenu: true
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    label: 'History'
	    translateLabel: true
	    isVisible: isStandAlone
	    submenuChannel: menuHistory
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 (MenuItem
	    label: 'MENU_Help'
	    translateLabel: true
	    startGroup: conditionalRight
	    submenuChannel: helpMenu
	    keepLinkedMenu: true
	    ignoreMnemonicKeys: true
	    ignoreShortcutKeys: true
	  )
	 )
	nil
	nil
      )
!

settingsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#settingsMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor settingsMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    isVisible: isNotEditingSpecOnly
	    #activeHelpKey: #settingsRedefineAspectMethods
	    #enabled: #hasValidSpecClass
	    #label: 'Redefine Aspect Methods'
	    #translateLabel: true
	    #hideMenuOnActivated: false
	    #indication: #redefineAspectMethodsChannel
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsRedefineAspectMethods
	    #label: 'AutoAccept on Selection-Change'
	    #translateLabel: true
	    #hideMenuOnActivated: false
	    #indication: #autoAcceptOnSelectionChange
	  )
	 )
	nil
	nil
      )
!

standardMenus
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#standardMenus
     (Menu new fromLiteralArrayEncoding:(MenuEditor standardMenus)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Standard Menu: File'
	    #itemValue: #doCreateStandardFileMenu
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #label: 'Standard Menu: Edit'
	    #itemValue: #doCreateStandardEditMenu
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #label: 'Standard Menu: Help'
	    #itemValue: #doCreateStandardHelpMenu
	    #translateLabel: true
	  )
	 )
	nil
	nil
      )
!

toolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#toolbar
     (Menu new fromLiteralArrayEncoding:(MenuEditor toolbar)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: fileNew
	    label: 'New'
	    itemValue: doNew
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary newMenuIcon)
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: fileLoad
	    label: 'Load'
	    itemValue: doLoad
	    translateLabel: true
	    isButton: true
	    isVisible: isNotEditingSpecOnly
	    submenuChannel: menuHistory
	    labelImage: (ResourceRetriever ToolbarIconLibrary loadFromMethodIcon)
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    activeHelpKey: fileSave
	    label: 'Save'
	    itemValue: doSave
	    translateLabel: true
	    isButton: true
	    isVisible: isNotEditingSpecOnly
	    labelImage: (ResourceRetriever ToolbarIconLibrary saveAsMethodIcon)
	  )
	 (MenuItem
	    activeHelpKey: fileSaveSpec
	    label: 'Save'
	    itemValue: doSave
	    translateLabel: true
	    isButton: true
	    isVisible: isEditingSpecOnly
	    labelImage: (ResourceRetriever XPToolbarIconLibrary saveImageIcon)
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: editCut
	    enabled: hasSelectionChannel
	    label: 'Cut'
	    itemValue: doCut
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary cutMenuItemIcon)
	  )
	 (MenuItem
	    activeHelpKey: editCopy
	    enabled: hasSelectionChannel
	    label: 'Copy'
	    itemValue: doCopy
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary copyMenuItemIcon)
	  )
	 (MenuItem
	    activeHelpKey: editPaste
	    enabled: canPasteHolder
	    label: 'Paste'
	    itemValue: doPaste
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary pasteMenuItemIcon)
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    activeHelpKey: addMenuItem
	    enabled: hasSingleSelectionChannel
	    label: 'Add Item'
	    itemValue: doCreateItem
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconItem)
	  )
	 (MenuItem
	    activeHelpKey: addMenuSeparator
	    enabled: hasSingleSelectionChannel
	    label: 'Add Separator'
	    itemValue: doCreateSep
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconSeparator)
	  )
	 (MenuItem
	    activeHelpKey: addMenuSlice
	    enabled: hasSingleSelectionChannel
	    label: 'Menu Slice'
	    itemValue: doCreateMenuSliceItem
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconSliceMenu)
	  )
	 (MenuItem
	    activeHelpKey: addSubMenu
	    enabled: hasSingleSelectionChannel
	    label: 'Add Menu'
	    itemValue: doCreateMenu
	    translateLabel: true
	    isButton: true
	    submenuChannel: standardMenus
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconMenu)
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    activeHelpKey: addSubMenuLink
	    enabled: hasSingleSelectionChannel
	    label: 'Add Linked Menu'
	    itemValue: doCreateLinkedMenu
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconLinkedMenu)
	  )
	 (MenuItem
	    activeHelpKey: addDelayedMenu
	    enabled: canCreateDelayedMenuChannel
	    label: 'Add Delayed Menu'
	    itemValue: doCreateDelayedMenu:
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconDelayedMenu)
	    argument: menu
	  )
	 (MenuItem
	    activeHelpKey: addDelayedSubMenuLink
	    enabled: canCreateDelayedMenuChannel
	    label: 'Add Delayed Linked Menu'
	    itemValue: doCreateDelayedMenu:
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever #'MenuEditor::Item' iconDelayedLinkedMenu)
	    argument: linkedMenu
	  )
	 (MenuItem
	    label: ''
	  )
	 (MenuItem
	    activeHelpKey: editMoveUp
	    enabled: enableMovingUpOrDownHolder
	    label: 'Move Up'
	    itemValue: doMoveUp
	    translateLabel: true
	    isButton: true
	    startGroup: right
	    labelImage: (ResourceRetriever Icon upIcon)
	  )
	 (MenuItem
	    activeHelpKey: editMoveDown
	    enabled: enableMovingUpOrDownHolder
	    label: 'Move Down'
	    itemValue: doMoveDown
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever Icon downIcon)
	  )
	 (MenuItem
	    activeHelpKey: editMoveIn
	    enabled: enableMovingInHolder
	    label: 'Move Into Next'
	    itemValue: doMoveInNext
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever Icon downRightIcon)
	  )
	 (MenuItem
	    activeHelpKey: editMoveInAbove
	    enabled: enableMovingInAboveHolder
	    label: 'Move Into Previous'
	    itemValue: doMoveInPrevious
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever Icon upRightIcon)
	  )
	 (MenuItem
	    activeHelpKey: editMoveOut
	    enabled: enableMovingOutHolder
	    label: 'Move Out'
	    itemValue: doMoveOut
	    translateLabel: true
	    isButton: true
	    labelImage: (ResourceRetriever Icon leftDownIcon)
	  )
	 )
	nil
	nil
      )
! !

!MenuEditor class methodsFor:'menu specs-standard'!

standardEditMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#standardEditMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor standardEditMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Cut'
	    #translateLabel: true
	    #value: #cutSelection
	  )
	 #(#MenuItem
	    #label: 'Copy'
	    #translateLabel: true
	    #value: #copySelection
	  )
	 #(#MenuItem
	    #label: 'Paste'
	    #translateLabel: true
	    #value: #paste
	  )
	 )
	nil
	nil
      )
!

standardFileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#standardFileMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor standardFileMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'New'
	    #translateLabel: true
	    #value: #menuNew
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Open...'
	    #translateLabel: true
	    #value: #menuOpen
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Save'
	    #translateLabel: true
	    #value: #menuSave
	  )
	 #(#MenuItem
	    #label: 'Save As...'
	    #translateLabel: true
	    #value: #menuSaveAs
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Exit'
	    #translateLabel: true
	    #value: #closeRequest
	  )
	 )
	nil
	nil
      )
!

standardHelpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MenuEditor andSelector:#standardHelpMenu
     (Menu new fromLiteralArrayEncoding:(MenuEditor standardHelpMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Documentation'
	    #translateLabel: true
	    #value: #openDocumentation
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'About this Application...'
	    #translateLabel: true
	    #value: #openAboutThisApplication
	  )
	 )
	nil
	nil
      )
! !

!MenuEditor methodsFor:'accessing'!

helpSpec
    |spec t g|

    spec := super helpSpec.
    t := spec at:#detailsStartGroup.
    g := (aspects at:#startGroup ifAbsent:nil) value.
    g == #conditionalRight ifTrue:[
        t := t , ' #conditionalRight means: "right on non-win32 systems"'
    ].
    g == #right ifTrue:[
        t := t , ' #right means: "right align from here"'
    ].
    g == #left ifTrue:[
        t := t , ' #left means: "left align group"'
    ].
    spec at:#detailsStartGroup put:t.

    ^ spec.
"/ #detailsStartGroup
"/ 'Specify start of a right-aligned item group.'

    "Created: / 16-10-2006 / 13:19:14 / cg"
!

helpTool
    "get the help tool application
    "
    ^ wizards at:#help ifAbsentPut:[ |tool|
	tool := UIHelpTool new.
	tool masterApplication:self.
	tool modifiedHolder: self enablingCommitButtonsHolder.
	tool builder window:(ApplicationSubView new client:tool spec:#innerSpec).
	tool masterApplication:self.
	tool
    ]
!

imageTool
    "get the image tool application"

    ^ wizards
	at:#image
	ifAbsentPut:[
	    |tool|

	    tool := ImageResourceEditor new createBuilder.
	    tool masterApplication:self.
	    tool modifiedChannel: self enablingCommitButtonsHolder.
	    tool builder window:(ApplicationSubView new client:tool).
	    tool
	]

    "Modified: / 03-08-2011 / 10:03:08 / cg"
!

savedSpec
    ^ savedSpec
!

useHelpTool:aHelpTool
    "take the help dictionaries from aHelpTool into my helpTool
    "
    self helpTool loadFromHelpTool:aHelpTool.
! !

!MenuEditor methodsFor:'actions'!

accept
    "accept modifications
    "
    self accept:true.
!

accept:ok
    "if ok is true, the modifications are accepted.
     then reload from item
    "
    |selectedItem rscRetrHolder helpKeyHolder helpTool imageTool acceptChannel|

    selectedItem := self selectedItem.

    selectedItem notNil ifTrue:[
	self withoutNotifyDo:[
	    rscRetrHolder := aspects at:#resourceRetriever.
	    helpKeyHolder := aspects at:#activeHelpKey.
	    imageTool     := self imageTool.
	    helpTool      := self helpTool.
	    acceptChannel := self acceptChannel.

	    acceptChannel triggerValue:true.
	    acceptChannel setValue:false.

	    ok ifTrue:[
		helpTool accept.
		rscRetrHolder value:(imageTool resourceRetriever).
		helpKeyHolder value:(helpTool helpKey).
		selectedItem  fromAspects:aspects.
		self setModified.

		selectedItem isRootItem ifTrue:[
		    "/ update specSelector
		    specSelector := selectedItem rawLabel.
		].
	    ].
	    selectedItem toAspects:aspects.
	    helpTool     helpKey:(helpKeyHolder value).
	    imageTool    resourceRetriever:(rscRetrHolder value).
	]
    ].
    self updateChannels.
"/    self clearModified.
    self clearModifiedFlag.

    self enablingCommitButtonsHolder value:false.

    "Modified: / 29-11-2011 / 11:28:02 / cg"
!

cancel
    "reload aspects from current selected item; reset modification flag"

    self accept:false.

    "Modified: / 29-08-2006 / 10:20:46 / cg"
!

indicatorClickedAt:atLine
    "indicator clicked at line number; toggle expand of item at line
    "
    |item|

    item := listOfItems at:atLine ifAbsent:nil.
    item notNil ifTrue:[
	item toggleExpand.
	self hasSelection ifFalse:[
	    self selectedItem:item
	]
    ].

    "Modified: / 29-11-2011 / 11:28:20 / cg"
! !

!MenuEditor methodsFor:'aspects'!

canCreateDelayedMenuChannel
    "boolean holder, true if the current selected item accepts a delayed menu
    "
    ^ builder booleanValueAspectFor:#canCreateDelayedMenuChannel
!

hasItemValue
    "boolean holder, true if any item is selected
    "
    ^ BlockValue
	with:[:holder | holder size > 0]
	argument:(self aspectFor:#itemValue)

    "Modified: / 08-03-2007 / 22:59:42 / cg"
!

hasNonLinkedMenuSelectedHolder
    "boolean holder, true if a single non linked menu item is selected
    "
    ^ BlockValue
        with:[:m | 
                |items| 

                items := self selectionHolder value.
                (items size == 1) 
                and:[items first isKindOfNonLinkedMenu
                and:[items first isRootItem not]]
             ]
        argument:(self selectionHolder)
!

hasSelectionChannel
    "boolean holder, true if any item is selected
    "
    ^ builder booleanValueAspectFor:#hasSelectionChannel
!

hasSingleSelectionChannel
    "boolean holder, true if one item is selected
    "
    ^ builder booleanValueAspectFor:#hasSingleSelectionChannel
!

listOfItems
    "returns the hierarchical list of menuItems
    "
    ^ listOfItems
!

listOfTabs
    "returns the list of current shown tab-labels retrieved
     from the current selected item.
    "
    ^ listOfTabs
!

redefineAspectMethodsChannel
    "boolean holder, true if aspects should be generated in only implemented
     in superClass by calling #super ...
    "
    ^ builder booleanValueAspectFor:#redefineAspectMethodsChannel
!

selectionHolder
    "value holder, which keeps the current selected items
    "
    ^ selectionHolder
!

tabHolder
    "value holder, which keeps the current selected tab label or nil
    "
    ^ tabHolder
!

wizardHolder
    "holder, which keeps the current wizard window
    "
    |holder|

    holder := builder bindingAt:#wizardHolder.

    holder isNil ifTrue:[
	holder := nil asValue.
	builder aspectAt:#wizardHolder put:holder.
    ].
    ^ holder
! !

!MenuEditor methodsFor:'building'!

buildFromMenu:aMenu selector:aSelector
    "rebuild menu from a Menu
    "
    |root menu|

    aMenu isCollection ifTrue:[menu := aMenu decodeAsLiteralArray]
		      ifFalse:[menu := aMenu].

    self enablingCommitButtonsHolder value:false.
    root := listOfItems root.

    self withoutNotifyDo:[
	selectionHolder setValue:#().
	root menu:aMenu labeled:(aSelector ? specSelector).
    ].
    self selectedItem:root.
    self updateHistory.
!

buildFromResourceSpec:aResourceSpec
    "rebuild the menu from a resource spec"

    self buildFromMenu:aResourceSpec selector:nil
!

loadFromClass:aClass andSelector:aSelector
    "rebuild menu from a class and selector"

    |cls menu|

    self assert:(aClass isNil or:[aClass isClass]).

    menu := nil.

    self isStandAlone ifTrue:[ self helpTool loadFromClass:aClass ].

    specClass := aClass.
    specSelector := aSelector.

    aSelector notNil ifTrue:[
	aClass notNil ifTrue:[
	    cls := aClass isBehavior ifTrue:[ aClass ] ifFalse:[ self resolveName:aClass].

	    (cls respondsTo:aSelector) ifTrue:[
		menu := cls perform: aSelector.
	    ].
	].
    ].
    self loadFromMenu:menu selector:aSelector.
!

loadFromMenu:menuArg selector:selectorOrNil
    "rebuild menu"

    |menu|

    menu := menuArg.
    menu notNil ifTrue:[
	(menu isCollection) ifTrue:[
	    menu := Menu decodeFromLiteralArray:menu
	].
    ].
    self buildFromMenu:menu selector:selectorOrNil.
    self clearModified.

    "Modified: / 27-03-2007 / 11:16:47 / cg"
! !

!MenuEditor methodsFor:'change & update'!

selectedSuperItems
    "returns collection of superItems derived from selection
    "
    |selection size root|

    selectedSuperItems notNil ifTrue:[ ^ selectedSuperItems ].

    selection := selectionHolder value.
    size      := selection size.

    size <= 1 ifTrue:[
	selectedSuperItems := selection ? #().
      ^ selectedSuperItems
    ].

    root := listOfItems root.

    (selection includesIdentical:root) ifTrue:[
	selectedSuperItems := Array with:root.
      ^ selectedSuperItems
    ].
    selectedSuperItems := OrderedCollection new.

    selection do:[:anItem|
	anItem parentsDetect:[:el| selection includesIdentical:el ]
		      ifNone:[ selectedSuperItems add:anItem ].
    ].
    ^ selectedSuperItems

    "Modified: / 29-11-2011 / 11:28:23 / cg"
!

selectionChanged
    "called if the selection has changed
    "
    |newTabList selection|

    selection := selectionHolder value.

    selection size == 1 ifTrue:[
	selectedSuperItems := selection.

	newTabList := selection first slices collect:[:el| el first ].
	newTabList = listOfTabs ifFalse:[
	    listOfTabs contents:newTabList.
	].
    ] ifFalse:[
	"must compute selected super items on request
	"
	selectedSuperItems := nil.
    ].
    self cancel.
    self tabChanged.
    self updateChannels.
!

tabChanged
    "called if the tab changed"

    |tab selector item canvas wizardHolder|

    wizardHolder := self wizardHolder.
    item := self selectedItem.
    item isNil ifTrue:[
	wizardHolder value:nil.
	^ self
    ].

    tab := tabHolder value.

    tab notNil ifTrue:[
	tab := item slices detect:[:el| el first = tab ] ifNone:nil.
    ].
    tab isNil ifTrue:[
	tabHolder value:( listOfTabs at:1 ifAbsent:nil ).
	^ self.
    ].
    selector := tab last.

    selector == #help  ifTrue:[
	wizardHolder value:(self helpTool  window).
	^ self
    ].
    selector == #image ifTrue:[
	wizardHolder value:(self imageTool window).
	^ self
    ].

    canvas := wizards
		at:(item class name, selector) asSymbol
		ifAbsentPut:[
		    SimpleView new
			client:self
			spec:(item class perform:selector)
			builder:(self builder)
		].

    wizardHolder value:canvas.
!

update:something with:aParameter from:changedObject
    |lbl|

    notifyDisabledCounter ~~ 0 ifTrue:[ ^ self ].

    changedObject == selectionHolder ifTrue:[ ^ self selectionChanged ].
    changedObject == tabHolder       ifTrue:[ ^ self tabChanged ].

    changedObject == self autoAcceptOnSelectionChange ifTrue:[
	lbl := changedObject value ifTrue:['Apply'] ifFalse:['OK'].
	(builder componentAt:'okButton') label:(resources string:lbl).
	^ self
    ].

    super update:something with:aParameter from:changedObject
!

updateChannels
    "update all channels"

    |selection sizeOfSel selectedItem hasSelection|

    super updateChannels.

    selection := selectionHolder value.
    sizeOfSel := selection size.

    hasSelection := sizeOfSel ~~ 0.
    sizeOfSel == 1 ifTrue:[selectedItem := selection at:1]
		  ifFalse:[selectedItem := nil].

    self hasSelectionChannel       value:hasSelection.
    self hasSingleSelectionChannel value:(selectedItem notNil).

    selectedItem isNil ifTrue:[
"/        self enableMovingUpOrDownHolder  value:false.
	self enableMovingInHolder        value:false.
	self enableMovingOutHolder       value:false.
	self enableMovingInAboveHolder   value:false.
	self canCreateDelayedMenuChannel value:false.
    ] ifFalse:[
"/        self enableMovingUpOrDownHolder  value:(selectedItem canMoveUpOrDown).
	self enableMovingInHolder        value:(selectedItem canMoveInNext).
	self enableMovingOutHolder       value:(selectedItem canMoveOut).
	self enableMovingInAboveHolder   value:(selectedItem canMoveInAbove).
	self canCreateDelayedMenuChannel value:(selectedItem canAddDelayedMenu).
    ].
    self enableMovingUpOrDownHolder value:(selection conform:[:i | i canMoveUpOrDown]).

    "Modified (comment): / 18-01-2012 / 11:24:07 / cg"
! !

!MenuEditor methodsFor:'drag & drop'!

canDrop:aDropContext
    "return true, if the DropContext can be dropped into the list of items.
     The dropable objects are already validated by: #dropEnter:"

    ^ (dropOverLine notNil and:[dropOverLine ~~ 0])

    "Modified: / 13-10-2006 / 16:03:47 / cg"
!

changeDropLineTo:aLineOrNil in:aContext
    "the over dropLine changed; redraw drop indication stuff
    "
    |x0 x1 y0|

    aLineOrNil == dropOverLine ifTrue:[
	^ self. "/ nothing changed
    ].
    x0 := listOfItemsView margin + 2.
    x1 := listOfItemsView width - x0.

    "/ inform the DragAndDrop handler that the draw contents will change
    aContext contentsWillChange.

    (dropOverLine notNil and:[dropOverLine ~~ 0]) ifTrue:[
	"/ restore old draw
	y0 := listOfItemsView yVisibleOfLine:(dropOverLine + 1).
	y0 := y0 - 3.

	listOfItemsView invalidate:(Rectangle left:x0 top:y0 width:(x1-x0+1) height:2)
			 repairNow:true.
    ].

    dropOverLine := aLineOrNil.

    (dropOverLine notNil and:[dropOverLine ~~ 0]) ifTrue:[
	"/ highlight new drop target
	y0 := listOfItemsView yVisibleOfLine:(dropOverLine + 1).
	y0 := y0 - 3.

	listOfItemsView paint:(Color white).
	listOfItemsView displayLineFromX:x0 y:y0 toX:x1 y:y0.
	y0 := y0 + 1.
	listOfItemsView paint:(Color black).
	listOfItemsView displayLineFromX:x0 y:y0 toX:x1 y:y0.
    ].
!

doDrop:aDropContext
    "drop the dropContext into the hierachical list of items
    "
    |done item|

    dropOverLine isNil ifTrue:[^ false ].      "/ context not valid to me ...

    item := listOfItems at:dropOverLine ifAbsent:nil.
    self dropLeave:aDropContext.
    item isNil ifTrue:[^ false].

    selectionHolder setValue:(Array with:item).

    done := false.

    self addAndSelectValueOf:[
	done := true.
	aDropContext dropObjects collect:[:el| Item menuItem:(el theObject) ]
    ].
    ^ done

    "Modified: / 13-10-2006 / 16:03:54 / cg"
!

dropEnter:aDropContext
    "a drop operation enters my widget; validate dropable objects.
     If the objects are not dropable, dropOverLine is set to nil,
     otherwise to 0 (can drop the contents but not).
    "
    |objects|

    dropOverLine := nil.

    self enablingCommitButtonsHolder value ifTrue:[
	"/ current editing spec is modified (couldn't accept operation)
	^ self
    ].
    objects := aDropContext dropObjects.
    objects isEmpty ifTrue:[ ^ self ].  "/ nothing to drop ???

    "/ test whether all objects are dropable (kind of MenuItem)
    (objects conform:[:el | (el theObject askFor:#isMenuItem)]) ifTrue:[
	"/ ok, the contents is dropable
	dropOverLine := 0.
    ]

    "Modified: / 13-10-2006 / 16:04:14 / cg"
!

dropLeave:aDropContext
    "restore drop indications drawn..."

    self changeDropLineTo:nil in:aDropContext.

    "Modified: / 13-10-2006 / 16:03:59 / cg"
!

dropObjects
    "returns list of DropObjects
    "
    |obj items|

    items := self selectedSuperItems.
    items isEmpty ifTrue:[ ^ nil ].

  ^ items collect:[:el|
	obj := DropObject new:(el menuItem).
	obj displayObject:(el rawLabel).
	obj
    ].
!

dropOver:aDropContext
    "called during drag & drop while moving over the widget."

    |lnNr item|

    dropOverLine isNil ifTrue:[^ self ].       "/ context not valid to me ...

    lnNr := listOfItemsView yVisibleToLineNr:(aDropContext targetPoint y).
    item := nil.

    lnNr notNil ifTrue:[
	item := listOfItems at:lnNr ifAbsent:nil.
	item notNil ifTrue:[
	    (item isAction and:[item hasDelayedMenu]) ifTrue:[
		item := nil
	    ]
	]
    ].
    item isNil ifTrue:[ lnNr := 0 ].   "/ not dropable for item

    "/ redraw drop indication
    self changeDropLineTo:lnNr in:aDropContext.

    "Modified: / 29-11-2011 / 11:28:17 / cg"
! !

!MenuEditor methodsFor:'event processing'!

processEvent:anEvent
    "filter keyboard edit-events typed into the listOfItemsView.
     Return true, if I have eaten the event"

    <resource: #keyboard (#Delete #BackSpace #Cut #Copy #Paste #CtrlCursorUp #CtrlCursorDown
			  #CtrlCursorLeft #CtrlCursorRight )>

    |evView rawKey key|

    anEvent isKeyPressEvent ifFalse:[^ false].

    evView := anEvent targetView.
    evView isNil ifTrue:[ ^ false ].

    "/ only handle keyboard events for the left item list
    "/ (otherwise, copy-paste would not work in the editFields on the right)
    (evView isSameOrComponentOf:listOfItemsView) ifFalse:[^ false].

    key    := anEvent key.
    rawKey := anEvent rawKey.

    (    key == #Delete
     or:[key == #BackSpace
     or:[key == #Cut]]
    ) ifTrue:[
	self doCut.
	^ true.
    ].

    key == #Copy  ifTrue:[ self doCopy.  ^ true ].
    key == #Paste ifTrue:[ self doPaste. ^ true ].

    (rawKey == #CtrlCursorUp) ifTrue:[
	self doMoveUp.
	^ true.
    ].
    (rawKey == #CtrlCursorDown) ifTrue:[
	self doMoveDown.
	^ true.
    ].
    (rawKey == #CtrlCursorLeft) ifTrue:[
	self doMoveOut.
	^ true.
    ].
    (rawKey == #CtrlCursorRight) ifTrue:[
	self doMoveInNext.
	^ true.
    ].

    ^ false.
! !

!MenuEditor methodsFor:'initialization & release'!

closeRequest
    "asks for permission before closing"

    self askForModification ifFalse:[^self].

"/    self enablingCommitButtonsHolder value ifTrue:[
"/        self setModified.
"/        self askForListModification.
"/        modified ifTrue:[^ self].
"/        self clearModified.
"/    ].
    super closeRequest

    "Modified: / 05-09-2006 / 18:44:15 / cg"
!

commonPostBuild
    self autoAcceptOnSelectionChange addDependent:self.
    self autoAcceptOnSelectionChange value ifTrue:[
	(builder componentAt:'okButton') label:(resources string:'Apply')
    ].

    "/ using masters infoHolder ?
    (builder aspectAt:#useAlienInfoLabelHolder) == true ifTrue:[
	(builder componentAt:#mainPanel) layout bottomOffset:0.
	(builder componentAt:#infoBarSubSpec) beInvisible
    ]
!

commonPostOpen
    "reset keyboardProcessor for menuBar"

    super commonPostOpen.
    builder keyboardProcessor menuBar:nil.
    self windowGroup addPreEventHook:self.
!

initialize
    "setup aspects, ...
    "
    super initialize.
    notifyDisabledCounter := 0.

    Item withAllSubclasses do:[:aClass|
	aClass addBindingsTo:aspects for:self.
    ].

    selectionHolder    := #() asValue.
    selectionHolder addDependent:self.

    listOfItems := HierarchicalList new.
    listOfItems application:self.
    listOfItems root:(RootItem new).

    tabHolder := nil asValue.
    tabHolder addDependent:self.

    listOfTabs := List new.
    wizards    := IdentityDictionary new.
!

loadFromResourceSpec:aResourceSpec
    self loadFromMenu:aResourceSpec selector:nil
!

openModalOnMenu:aMenuOrNil
    "build a tree from aMenu and open it modal"

    self openModalOnResourceSpec:aMenuOrNil
!

postBuildListOfItemsView:aSrollableView
    listOfItemsView := aSrollableView scrolledView.
!

postBuildNoteBook:aNoteBook
    aNoteBook tabLabelInset:16@4.
! !

!MenuEditor methodsFor:'menus-dynamic'!

submenuTest
    "returns a menu on the current editing menu
    "
    |menu indication choice submenu retriever|

    menu := listOfItems root submenu.
    menu isNil ifTrue:[^ nil ].

    menu allItemsDo:[:anItem|
        anItem ignoreShortcutKeys:true.
        anItem isVisible:true.
        anItem enabled:true.
        anItem translateLabel:false.

        anItem itemValue notNil ifTrue:[
            anItem itemValue:[ Transcript showCR:(anItem label) ].
        ].
        anItem indication notNil ifTrue:[
            indication isNil ifTrue:[ indication := true asValue ].
            anItem indication:indication
        ].
        anItem choice notNil ifTrue:[
            choice isNil ifTrue:[ choice := anItem choiceValue asValue ].
            anItem choice:choice
        ].
        anItem isMenuSlice ifTrue:[
            anItem submenuChannel:nil.
            anItem label:'... Slice Menu ...'.
        ].
        anItem submenuChannel notNil ifTrue:[
            anItem submenuChannel:nil.
            anItem submenu isNil ifTrue:[
                submenu isNil ifTrue:[
                    submenu := Menu new.
                    submenu addItem:(MenuItem label:'Linked Menu...').
                ].
                anItem submenu:submenu.
            ].
        ].
        retriever := anItem resourceRetriever.
        retriever notNil ifTrue:[
            retriever labelText notNil ifTrue:[ retriever labelText:(anItem label) ]
        ].
    ].
    menu findGuiResourcesIn:(self resolveName:specClass).
    ^ menu
! !

!MenuEditor methodsFor:'private'!

addAndSelectValueOf:aBlockOrItem
    "add an item(s) derived from the block; test if add operation
     is enabled. On success the new item(s) are returned otherwise nil.
    "
    |intoItem index newItem|

    intoItem := self selectedItem.
    intoItem isNil ifTrue:[ ^ nil].

    self askForItemModification ifFalse:[ ^ nil ].

    index := 1.

    (intoItem canAddChildren and:[intoItem isExpanded]) ifFalse:[
	intoItem parent notNil ifTrue:[
	    [ intoItem parent canAddChildren ] whileFalse:[
		intoItem := intoItem parent.
	    ].
	    index := intoItem parent identityIndexOf:intoItem.
	    index := index + 1.
	    intoItem := intoItem parent.
	].
    ].
    newItem := aBlockOrItem value.

    newItem notNil ifTrue:[
	selectionHolder setValue:nil.
	intoItem expand.

	newItem isCollection ifTrue:[
	    intoItem addAll:newItem beforeIndex:index.
	    selectionHolder value:newItem.
	] ifFalse:[
	    intoItem add:newItem beforeIndex:index.
	    selectionHolder value:(Array with:newItem).
	].
	self setModified.
    ].
    ^ newItem

    "Modified: / 29-11-2011 / 11:28:06 / cg"
!

clearModified
    "clear the modifiedChannel and the commitPanel"

    super clearModified.
    self enablingCommitButtonsHolder value:false.
    self clearModifiedFlag.
!

generateMenuSpec
    "generate and returns the current menu spec or nil"

    ^ self generateMenuSpecFor:listOfItems root
!

generateMenuSpecFor:aMenuItem
    "generate and returns a menu spec or nil"

    |menu|

    menu := aMenuItem submenu.
    menu isNil ifTrue:[^ nil].

    ^ menu literalArrayEncoding.
!

generateMenuSpecString
    "generate and returns the current menu spec as string or nil"

    ^ self generateMenuSpecStringFor:listOfItems root 
!

generateMenuSpecStringFor:aMenuItem
    "generate and returns the current menu spec as string or nil"

    |menu specStream|

    menu := self generateMenuSpecFor:aMenuItem.
    menu isNil ifTrue:[^ nil].

    specStream := WriteStream on:''.
    UISpecification prettyPrintSpecArray:menu on:specStream indent:5.
    ^ specStream contents.
!

withoutNotifyDo:aBlock
    "evaluate the block; all change notifications are
     discard during the block is evaluated"

    |blockResult|

    [
	notifyDisabledCounter := notifyDisabledCounter + 1.
	blockResult := aBlock value.
    ] ensure:[
	notifyDisabledCounter := notifyDisabledCounter - 1
    ].
    ^ blockResult
! !

!MenuEditor methodsFor:'queries'!

hasValidSpecClass
    "returns true if a valid specClass exists
    "
    specClass isNil ifTrue:[^ false].
    ^ (self resolveName:specClass) notNil

    "Modified: / 19-11-2016 / 20:19:30 / cg"
!

isEditingSpecOnly
    ^ masterApplication notNil
    and:[ masterApplication perform:#isEditingSpecOnly ifNotUnderstood:false]
!

isNotEditingSpecOnly
    ^ self isEditingSpecOnly not
!

isNotEditingSpecOnlyAndNotEmbeddedInBrowser
    ^ self isNotEditingSpecOnly and:[ self isEmbeddedInBrowser not ]
! !

!MenuEditor methodsFor:'selection'!

canSelect:anIndex
    "called whenever the selection changed; test whether
     current item is not modified ....
    "
    |oldSelectedItem newSelectedItem anythingChanged|

    self enablingCommitButtonsHolder value ifFalse:[
	^ true
    ].
    oldSelectedItem := self selectedItem.
    oldSelectedItem isNil ifTrue:[^ true].

    newSelectedItem := listOfItems at:anIndex ifAbsent:nil.
    oldSelectedItem == newSelectedItem ifTrue:[
	^ true
    ].

    anythingChanged := self enablingCommitButtonsHolder value.
    anythingChanged ifTrue:[
	self autoAcceptOnSelectionChange value ifTrue:[
	    self accept.
	    ^ true
	].
    ].

    ^ self askForItemModification
!

hasSelection
    "returns true if a selection exists
    "
    ^ selectionHolder value size ~~ 0
!

selectedItem
    "returns the selected item or nil (none or multiple selected)"

    |selection|

    selection := selectionHolder value.
    selection size == 1 ifTrue:[ ^ selection first ].
    ^ nil

    "Modified: / 18-01-2012 / 11:33:42 / cg"
!

selectedItem:anItem
    "change selection to an item
    "
    |selection|

    anItem notNil ifTrue:[ selection := Array with:anItem ]
		 ifFalse:[ selection := #() ].

    selectionHolder value:selection.
!

selectedItems
    "returns the selected items or an empty collection"

    ^ selectionHolder value.

    "Created: / 18-01-2012 / 11:32:20 / cg"
!

selectedItems:aCollectionOfItems
    "set the selected items"

    selectionHolder value:aCollectionOfItems.

    "Created: / 18-01-2012 / 11:32:37 / cg"
! !

!MenuEditor methodsFor:'user actions-aspects'!

collectActionSelectors
    |selectors|

    selectors := IdentitySet new.

    listOfItems root recursiveDo:[:el|
	el actionSelectors do:[:s| selectors add:s ].
    ].
    ^ selectors asOrderedCollection
!

collectAspectSelectors
    |selectors|

    selectors := IdentitySet new.

    listOfItems root recursiveDo:[:el|
	selectors addAll:(el aspectSelectors).
    ].
    ^ selectors asOrderedCollection
!

doBrowseActionMethod
    "open a browser on the action callback method (create if not yet existing)"

    self doBrowseApplicationMethodFor:#itemValue

    "Modified: / 21-10-2010 / 14:09:33 / cg"
!

doBrowseApplicationMethodFor:aspect
    |selector cls implClass browsedClass category|

    specClass isNil ifTrue:[
        self warn:(resources string:'Please define the application class first.').
        ^ self
    ].

    selector := (self aspectValueFor:aspect).
    selector isEmptyOrNil ifTrue:[
        Dialog information:(resources string:'Missing name for the action/aspect method.').
        ^ self
    ].
    (selector = 'true' or:[selector = 'false']) ifTrue:[^ self].
    (selector == true or:[selector == false]) ifTrue:[^ self].

    selector := selector asSymbol.

    cls := self resolveName:specClass.
    cls isNil ifTrue:[
        self warn:(resources string:'Class %1 does not exist!!' with:specClass asString).
        ^ self
    ].

    browsedClass := cls.
    (cls includesSelector:selector) ifFalse:[
        | generate |    
        (implClass := cls whichClassImplements:selector) notNil ifTrue:[
            generate := (Dialog 
                confirm:(resources 
                            stringWithCRs:'The application does not directly implement %1.\However it inherits this from %2.\\Create a redefinition in %1?'
                            with:cls name
                            with:implClass name)
                initialAnswer:false)
        ] ifFalse:[ 
            generate := true.
        ].
        category := UserPreferences current categoryForMenuActionsMethods.

        SmalltalkCodeGeneratorTool
            createActionMethodFor:selector in:cls
            category:category
            redefine:(self redefineAspectMethodsChannel value).
    ].

    browsedClass browserClass openInClass:browsedClass selector:selector

    "Created: / 21-10-2010 / 14:07:32 / cg"
    "Modified: / 31-01-2011 / 18:28:59 / cg"
    "Modified: / 17-03-2014 / 12:25:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doBrowseChoiceMethod
    "open a browser on the choice aspect method (create if not yet existing)"

    self doBrowseApplicationMethodFor:#choice
!

doBrowseEnabledMethod
    "open a browser on the enabled method (create if not yet existing)"

    self doBrowseApplicationMethodFor:#enabled

    "Created: / 21-10-2010 / 14:09:41 / cg"
!

doBrowseIndicationMethod
    "open a browser on the indicator aspect method (create if not yet existing)"

    self doBrowseApplicationMethodFor:#indication
!

doBrowseVisibilityMethod
    "open a browser on the visibility method (create if not yet existing)"

    self doBrowseApplicationMethodFor:#isVisible

    "Created: / 21-10-2010 / 14:09:56 / cg"
!

doGenerateAspectMethods
    "compile aspect and action methods"

    |cls redefineAspectMethods category|

    specClass isNil ifTrue:[
	self warn:'Define the class first !!'.
	^ self
    ].
    redefineAspectMethods := self redefineAspectMethodsChannel value.

    cls := self resolveName:specClass.
    cls isNil ifTrue:[
	self warn:'Class ', specClass asString, ' does not exist!!'.
	^ self
    ].

    category := UserPreferences current categoryForMenuActionsMethods.

    self collectActionSelectors do:[:aSelector|
	SmalltalkCodeGeneratorTool
	    createActionMethodFor:aSelector in:cls
	    category:category
	    redefine:redefineAspectMethods.
    ].

    self collectAspectSelectors do:[:anAspect|
	SmalltalkCodeGeneratorTool
	    createAspectMethodFor:anAspect in:cls
	    category:category
	    redefine:redefineAspectMethods
    ].

    "Modified: / 31-01-2011 / 18:29:06 / cg"
! !

!MenuEditor methodsFor:'user actions-building'!

compileSpecMethodFor:aMenuItem selector:specSelector
    "save current editing menu to
           class: specClass
        selector: specSelector
    "
    |cls specCode mthd category s|

    specCode := self generateMenuSpecStringFor:aMenuItem.
    specCode isNil ifTrue:[^ nil].

    cls  := self resolveName:specClass.

    "/ if that method already exists, do not overwrite the category

    category := 'menu specs'.
    (mthd := cls theMetaclass compiledMethodAt:specSelector) notNil ifTrue:[
        category := mthd category.
    ].

    s := '' writeStream.

    s nextPutChunkSeparator;
      nextPutAll:(cls name);
      nextPutAll:' class methodsFor:';
      nextPutAll:category storeString;
      nextPutChunkSeparator;
      cr; cr;
      nextPutAll:specSelector;
      cr;
      nextPutAllAsChunk:(self class codeGenerationComment) withCRs;
      cr; cr;
      nextPutLine:'    "';
      nextPutLine:('     MenuEditor new openOnClass:' , cls name , ' andSelector:#' , specSelector);
      nextPutLine:('     (Menu new fromLiteralArrayEncoding:(' , cls name , ' ' , specSelector , ')) startUp');
      nextPutLine:'    "';
      cr;
      nextPutLine:'    <resource: #menu>';
      cr;
      nextPutAll:'    ^ ';
      nextChunkPut:specCode;
      space;
      nextPutChunkSeparator;
      cr.

    Class packageQuerySignal answer:cls package do:[
        (ReadStream on:s contents) fileIn.
    ].
!

doChooseAMenu
    "pick a menu and edit its spec method"

    |view subSpec app bldr spec menuSelector1 menuSelector2 info|

    self askForModification ifTrue:[
	view := Screen current viewFromUser.
	(view isNil or:[view == Screen current rootView]) ifTrue:[
	    ^ self
	].
	view specClass == MenuPanelSpec ifTrue:[
	    (app := view application) isNil ifTrue:[
		info := 'Could not figure out the application class.'
	    ] ifFalse:[
		(bldr := app builder) isNil ifTrue:[
		    info := 'Application has no builder.'
		] ifFalse:[
		    menuSelector1 := bldr namedComponents keyAtValue:view ifAbsent:nil.
		    (spec := bldr spec) isNil ifTrue:[
			info := 'Cannot fetch spec from applications builder.'
		    ] ifFalse:[
			subSpec := spec findSpecForWhich:[:subSpec | subSpec name = view name].
			subSpec isNil ifTrue:[
			    info := 'Cannot find view-spec for ',view name asString,'.'
			] ifFalse:[
			    menuSelector2 := subSpec menu.
			]
		    ].
		    (menuSelector1 isNil and:[ menuSelector2 isNil ]) ifTrue:[
			info := 'menu is probably not provided by a menuSelector.'
		    ] ifFalse:[
			(app class respondsTo:menuSelector1) ifTrue:[
			    self loadFromClass:app class andSelector:menuSelector1.
			    ^ self.
			].
			(app class respondsTo:menuSelector2) ifTrue:[
			    self loadFromClass:app class andSelector:menuSelector2.
			    ^ self.
			].
			info := 'menu is probably not provided by a menuSelector.'
		    ].
		]
	    ].
	    info notNil ifTrue:[
		app notNil ifTrue:[
		    (Dialog confirm:(info,'\\Browse ?' withCRs)) ifTrue:[
			app browse.
		    ].
		] ifFalse:[
		    Dialog information:info.
		].
	    ].
	    ^ self.
	].
    ].
!

doNew
    "clear editing menu; start from scratch
    "
    super doNew ifTrue:[ self helpTool doNew ].
!

doPickAMenu
    "let user pick a menu and create a new spec"

    |view|

    self askForModification ifTrue:[
	view := Screen current viewFromUser.
	(view isNil or:[view == Screen current rootView]) ifTrue:[
	    ^ self
	].
	view specClass == MenuPanelSpec ifTrue:[
	    specSelector := #pickedMenu.
	    self buildFromMenu:(view asMenu) selector:specSelector.
	].
    ].
!

doSave
    "save current editing menu to
           class: specClass
        selector: specSelector
    "
    self isEditingSpecOnly ifTrue:[
        savedSpec := self generateMenuSpec.
        hasSaved := true.
        self clearModified.
        ^ self
    ].

    super doSave ifFalse: [^nil].

    self compileSpecMethodFor:listOfItems root selector:specSelector.
    self isStandAlone ifTrue:[
        self helpTool doSave
    ].

    self updateHistory.
    hasSaved := true.
    self clearModified.

    "Modified: / 28-01-2014 / 21:57:24 / cg"
!

doSaveAs
    "save current editing menu to class and selector
     defined by the user.
    "
    super doSaveAs ifTrue:[
	listOfItems root rawLabel:specSelector
    ].
!

doShowMenuSpec
    "opens a code view with the contents of the menu spec"

    |code|

    code := self generateMenuSpecString.

    code notNil ifTrue:[
	CodeView openWith:code title: 'Menu Spec'
    ].

    "Modified: / 29-11-2011 / 11:28:12 / cg"
!

save
    self doSave
! !

!MenuEditor methodsFor:'user actions-creation'!

doCreateDelayedMenu:what
    |selectedItem delayedItem|

    selectedItem := self selectedItem.
    selectedItem isNil ifTrue:[^ self].

    selectedItem canAddDelayedMenu      ifFalse:[ ^ self ].
    self askForItemModification ifFalse:[ ^ self ].

    what == #menu ifTrue:[ delayedItem := RegularMenuItem new ]
		 ifFalse:[ delayedItem := LinkedMenuItem new ].

    delayedItem setExpanded:true.
    delayedItem := selectedItem add:delayedItem.

    delayedItem notNil ifTrue:[
	self selectedItem:delayedItem.
    ].

    "Modified: / 29-11-2011 / 11:28:09 / cg"
!

doCreateItem
    "create a new Item
    "
    self addAndSelectValueOf:[ ActionItem new translateLabel:true ].
!

doCreateLinkedMenu
    "create a new Linked Menu
    "
    self addAndSelectValueOf:[ LinkedMenuItem new ].
!

doCreateMenu
    "create a new Menu
    "
    self addAndSelectValueOf:
	[ |item|
	    item := RegularMenuItem new.
	    "/ --- do not add it expanded - because that makes it hard to add multipe menus
	    "/ item expand.
	    item
	].
!

doCreateMenuSliceItem
    "create a new MenuSlice Item
    "
    self addAndSelectValueOf:[ MenuSliceItem new ].
!

doCreateSep
    "create a new Separator Item
    "
    self addAndSelectValueOf:[ SeparatorItem new ].
!

doCreateStandardEditMenu
    "create a standard edit menu
    "
    self addAndSelectValueOf:[
	RegularMenuItem menu:(self class standardEditMenu) labeled:'Edit' translateLabel:true
    ].
!

doCreateStandardFileMenu
    "create a standard file menu
    "
    self addAndSelectValueOf:[
	RegularMenuItem menu:(self class standardFileMenu) labeled:'File' translateLabel:true
    ].
!

doCreateStandardHelpMenu
    "create a standard help menu
    "
    |item|

    self addAndSelectValueOf:[
	item := RegularMenuItem menu:(self class standardHelpMenu) labeled:'Help' translateLabel:true.
	item aspectAt:#startGroup put:#conditionalRight.
	item
    ].

    "Modified: / 16-10-2006 / 12:49:27 / cg"
! !

!MenuEditor methodsFor:'user actions-editing'!

doCopy
    "copy selected menuItems to the clipboard
    "
    |clip items|

    items := self selectedSuperItems.
    items isEmpty ifTrue:[ ^ self ].

    clip := OrderedCollection new.
    items do:[:el| clip add:(el menuItem) ].

    self clipboard:clip.
    self updateAllToolInstances.
!

doCut
    "copy selected menuItems to the clipboard and delete
    "
    self doCopy.
    self doDelete.
!

doDelete
    "delete selected menuItems
    "
    |selectedItem parent toDelete behind nextItem prevItem|

    toDelete := self selectedSuperItems.
    toDelete isEmpty ifTrue:[ ^ self ].

    self clearModified.

    selectedItem := toDelete first.

    selectedItem isRootItem ifTrue:[
	^ selectedItem removeAll.
    ].
    "/ compute the new selection

    prevItem := parent := selectedItem parent.
    nextItem := nil.

    parent children size ~~ 1 ifTrue:[
	behind := false.

	parent do:[:el|
	    behind ifTrue:[
		(nextItem notNil or:[toDelete includesIdentical:el]) ifFalse:[ nextItem := el ].
	    ] ifFalse:[
		behind := el == selectedItem.
		(behind or:[toDelete includesIdentical:el]) ifFalse:[ prevItem := el ].
	    ]
	]
    ].
    self withoutNotifyDo:[
	toDelete do:[:el| el remove ].
    ].
    self selectedItem:(nextItem ? prevItem).
    self setModified.
    self updateChannels.
!

doPaste
    "paste from clipboard
    "
    ^ self doPaste:(self clipboard)
!

doPaste:aCollection
    "paste collection of MenuItems
    "
    |item loMenuItems|

    aCollection size == 0 ifTrue:[ ^ self ].

    item := self selectedItem.
    item isNil ifTrue:[ ^ self ].

    loMenuItems := OrderedCollection new.
    aCollection do:[:el|
	(el askFor:#isMenuItem) ifTrue:[ loMenuItems add:el ].
    ].
    loMenuItems isEmpty ifTrue:[ ^ self ].

    self addAndSelectValueOf:[
	loMenuItems collect:[:el| Item menuItem:el ]
    ].
! !

!MenuEditor methodsFor:'user actions-hierarchy'!

doMakeLinkedMenu
    "the selected item must be a regular submenu.
     create a new menuspec for it,
     and chenge the item to a linke menu item."

    |cls subSelector oldMenuItem newLinkedMenuItem index|

    oldMenuItem := self selectionHolder value first.

    subSelector := Dialog 
                    request:'Name of spec method for submenu:'
                    initialAnswer:((oldMenuItem label reject:[:ch | ch isLetterOrDigit not]),'MenuSpec') asLowercaseFirst.
    subSelector isEmptyOrNil ifTrue:[^ self].
    subSelector := subSelector asSymbol.

    cls  := self resolveName:specClass.
    (cls theMetaclass compiledMethodAt:subSelector) notNil ifTrue:[
        (Dialog confirm:'Overwrite existing spec?') ifFalse:[^ self].
    ].

    self compileSpecMethodFor:oldMenuItem selector:subSelector.

    newLinkedMenuItem := LinkedMenuItem new.
    newLinkedMenuItem submenuChannel:subSelector.
    newLinkedMenuItem menuItem nameKey:(oldMenuItem menuItem nameKey).
    newLinkedMenuItem menuItem label:oldMenuItem menuItem label.
    newLinkedMenuItem menuItem rawLabel:oldMenuItem menuItem rawLabel.
    newLinkedMenuItem menuItem translateLabel:(oldMenuItem menuItem translateLabel).

    index := oldMenuItem parent identityIndexOf:oldMenuItem.
    oldMenuItem parent at:index put:newLinkedMenuItem.

    self selectedItem:newLinkedMenuItem.
!

doMoveDown
    "move selected item down"

    self doMoveUpOrDown:#down
!

doMoveIn:aDirection
    "move selected item into the next (#inNext) or previous (#inPrev) item
    "
    |item idx parent toParent|

    item := self selectedItem.
    item isNil ifTrue:[^ self].

    aDirection == #inNext ifTrue:[ item canMoveInNext  ifFalse:[^ self] ]
			 ifFalse:[ item canMoveInAbove ifFalse:[^ self] ].

    self askForItemModification ifFalse:[ ^ self ].

    parent := item parent.
    idx    := parent identityIndexOf:item.

    aDirection == #inNext ifTrue:[ toParent := parent at:(idx + 1) ifAbsent:nil ]
			 ifFalse:[ toParent := parent at:(idx - 1) ifAbsent:nil ].

    self withoutNotifyDo:[
	selectionHolder setValue:#().
	parent removeIndex:idx.

	aDirection == #inNext ifTrue:[ toParent addFirst:item ]
			     ifFalse:[ toParent  addLast:item ].
	item makeVisible.
    ].
    self selectedItem:item.
    self setModified.
!

doMoveInNext
    "move selected item into the next item"

    self doMoveIn:#inNext.
!

doMoveInPrevious
    "move selected item into the previous item"

    self doMoveIn:#inPrev.
!

doMoveOut
    "move selected item out of current item
    "
    |item parent grandParent index|

    item := self selectedItem.
    item isNil ifTrue:[^ self].
    item canMoveOut ifFalse:[^ self].

    self askForItemModification ifFalse:[ ^ self ].

    parent      := item parent.
    grandParent := parent parent.
    index       := grandParent identityIndexOf:parent.

    self withoutNotifyDo:[
	selectionHolder setValue:#().
	parent remove:item.
	index > grandParent size ifTrue:[ grandParent add:item ]
				ifFalse:[ grandParent add:item afterIndex:index ]
    ].
    self selectedItem:item.
    self setModified.
!

doMoveUp
    "move selected item up"

    self doMoveUpOrDown:#up
!

doMoveUpOrDown:aDirectionSymbol
    "move selected item up (#up) or down (#down)"

    |items itemsSortedByIndex index parent children|

    items := self selectedItems.
    items isEmptyOrNil ifTrue:[^ self].
    (items conform:[:i | i canMoveUpOrDown]) ifFalse:[^ self].

    self askForItemModification ifFalse:[ ^ self ].

    self withoutNotifyDo:[
	itemsSortedByIndex := items copy.
	(items collect:[:i | listOfItems identityIndexOf:i])
	    sortWith:itemsSortedByIndex.

	aDirectionSymbol == #down ifTrue:[
	    itemsSortedByIndex := itemsSortedByIndex reversed
	].
	itemsSortedByIndex do:[:item |
	    parent   := item parent.
	    children := parent children.
	    index    := children identityIndexOf:item.

	    selectionHolder setValue:#().
	    children removeIndex:index.

	    aDirectionSymbol == #up ifTrue:[
		index == 1 ifTrue:[ children add:item ]
			ifFalse:[ children add:item beforeIndex:index - 1 ]
	    ] ifFalse:[
		index > children size ifTrue:[ children addFirst:item ]
				    ifFalse:[ children add:item afterIndex:index ]
	    ].
	    parent childrenOrderChanged.
	]
    ].
    self selectedItems:items.
    self setModified.

    "Modified: / 18-01-2012 / 11:35:38 / cg"
! !

!MenuEditor::Item class methodsFor:'defaults'!

defaultLabel
    ^ self subclassResponsibility
! !

!MenuEditor::Item class methodsFor:'image specs'!

iconDelayedLinkedMenu
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconDelayedLinkedMenu inspect
     ImageEditor openOnClass:self andSelector:#iconDelayedLinkedMenu
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MenuEditor::Item iconDelayedLinkedMenu'
        ifAbsentPut:[(Depth4Image new) width:20; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@DQDQDQDQDQDR@AH"H"H"H"H"H0@@@BH"H"@@@BL@QDPBH"H"@@H#@DQDPBH@H"@"H0ADQDPBA@H"H"L@@@QDP@Q@@@@C@ADPQDQDQ@DQD:
@RH QDQDQ@H"L@D"H QDQD@"H#@A@@@@@DP@@@@0@QDQDQA@DQDQL@D"H"H @"H"H#@BL3L3L3L3L3L0@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 127 127 127 255 0 0]; mask:((ImageMask new) width:20; height:16; bits:(ByteArray fromPackedString:'???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0') ; yourself); yourself]
!

iconDelayedMenu
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconDelayedMenu inspect
     ImageEditor openOnClass:self andSelector:#iconDelayedMenu
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconDelayedMenu'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@UUUUUVA*****,F***@B0Z***@+A****J,F*****0@@@@@@AUUUUUXF*****0Z****+A@@@@@LEUUUUU0Z****+B?????<@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 127 127 127 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0');
                            yourself);
                yourself
        ]
!

iconItem
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconItem inspect
     ImageEditor openOnClass:self andSelector:#iconItem
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconItem'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'UUUUUUUUUUUUUP@@@@@@EUUUUU Z****+A.?/;+,F:::/>0[++>:;A...++,F::?..0Z****+B?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 127 127 127 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@???0???0???0???0???0???0???0???0???0???0???0@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconLinkedMenu
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconLinkedMenu inspect
     ImageEditor openOnClass:self andSelector:#iconLinkedMenu
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconLinkedMenu'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@QDQDQDQDQDQA@DH"H"H"H"H"HPABH@@@H"H"H"D@PQ@3L0DQDQDQ@D@@L3L0@@@@@PADPCL3L0PCADD@P"@@@3L0@3@!!@DH"H"@3L3L3@P
AADQDQ@3L3L3@@P@@@@@@3L3LA@DQDQDQD@@L0PPABH"H"H"HC@"D@P"H"H"H"@BH!!@BDQDQDQDQDQDP@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 127 127 127 170 170 170 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0');
                            yourself);
                yourself
        ]
!

iconMenu
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconMenu inspect
     ImageEditor openOnClass:self andSelector:#iconMenu
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconMenu'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@?????=C*****$N*****P5UUUUUC@@@@@DO?????P:****)C*****$MUUUUUP0@@@@AC?????4N*****P:****)BUUUUUT@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 127 127 127 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0???0');
                            yourself);
                yourself
        ]
!

iconSeparator
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconSeparator inspect
     ImageEditor openOnClass:self andSelector:#iconSeparator
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconSeparator'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'UUUUUUUUUUUUUP@@@@@@EUUUUU Z****+A*****,F????:0[@@@@[A)UUUU,F*****0Z****+B?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 127 127 127 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@???0???0???0???0???0???0???0???0???0???0???0@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconSliceMenu
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconSliceMenu inspect
     ImageEditor openOnClass:self andSelector:#iconSliceMenu
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'MenuEditor::Item class iconSliceMenu'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@O?????0:*****C/?6??XN:*[*) ;*).*&C.*&:*XN5U[UU :*****C*****(@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 127 127 127 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@???0???0???0???0???0???0???0???0???0???0???0@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!MenuEditor::Item class methodsFor:'instance creation'!

classFor:aMenuItem

    aMenuItem isNil ifTrue:[ ^ nil ].

    aMenuItem itemValue isNil ifTrue:[
	aMenuItem isMenuSlice ifTrue:[ ^ MenuEditor::MenuSliceItem ].
	aMenuItem submenu notNil ifTrue:[ ^ MenuEditor::RegularMenuItem ].
	aMenuItem submenuChannel notNil ifTrue:[ ^ MenuEditor::LinkedMenuItem ].

	(self separatorTypeOf:(aMenuItem rawLabel)) notNil ifTrue:[
	    ^ MenuEditor::SeparatorItem
	]
    ].
    ^ MenuEditor::ActionItem
!

menuItem:aMenuItem
    |item cls|

    cls := self classFor:aMenuItem.
    cls isNil ifTrue:[^ nil].

    item := cls new.
    item menuItem:aMenuItem.
    ^ item
! !

!MenuEditor::Item class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::Item andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: detailsEditSpec
	window:
       (WindowSpec
	  label: 'Details Edit'
	  name: 'Details Edit'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 407 291)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Accelerator:'
	      name: 'shortcutKeyLabel'
	      layout: (AlignmentOrigin 107 0 26 0 1 0.5)
	      activeHelpKey: detailsAccelerator
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'shortcutKeyField'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: detailsAccelerator
	      tabable: true
	      model: shortcutKeyCharacter
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Enabled:'
	      name: 'enabledLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      activeHelpKey: detailsEnabled
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'enabledField'
	      layout: (LayoutFrame 110 0 40 0 -25 1.0 62 0)
	      activeHelpKey: detailsEnabled
	      tabable: true
	      model: enabled
	      group: inputGroup
	      type: symbolOrBooleanOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (ActionButtonSpec
	      label: 'browseActionImage'
	      name: 'Button1'
	      layout: (LayoutFrame -25 1 40 0 -5 1 62 0)
	      activeHelpKey: browseMethod
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	      resizeForLabel: true
	      tabable: true
	      model: doBrowseEnabledMethod
	    )
	   (LabelSpec
	      label: 'Visibility:'
	      name: 'visibilityLabel'
	      layout: (AlignmentOrigin 107 0 76 0 1 0.5)
	      activeHelpKey: detailsVisibility
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'isVisibleInputField'
	      layout: (LayoutFrame 110 0 65 0 -25 1.0 87 0)
	      activeHelpKey: detailsVisibility
	      tabable: true
	      model: isVisible
	      group: inputGroup
	      type: symbolOrBooleanOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (ActionButtonSpec
	      label: 'browseActionImage'
	      name: 'Button2'
	      layout: (LayoutFrame -25 1 65 0 -5 1 87 0)
	      activeHelpKey: browseMethod
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	      resizeForLabel: true
	      tabable: true
	      model: doBrowseVisibilityMethod
	    )
	   (LabelSpec
	      label: 'Aux Value'
	      name: 'auxLabel'
	      layout: (AlignmentOrigin 107 0 101 0 1 0.5)
	      activeHelpKey: detailsAuxValue
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'auxInputField'
	      layout: (LayoutFrame 110 0 90 0 -5 1.0 112 0)
	      activeHelpKey: detailsAuxValue
	      tabable: true
	      model: auxValue
	      group: inputGroup
	      type: smalltalkObjectOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Start Group:'
	      name: 'StartGroupLabel'
	      layout: (AlignmentOrigin 107 0 139 0 1 0.5)
	      activeHelpKey: detailsStartGroup
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (PopUpListSpec
	      label: 'left'
	      name: 'StartGroupPopUp'
	      layout: (LayoutFrame 110 0 128 0 -5 1.0 150 0)
	      activeHelpKey: detailsStartGroup
	      tabable: true
	      model: startGroup
	      menu:
	     (Array
		left right
		conditionalRight
	      )
	    )
	   (LabelSpec
	      label: 'Access Character Position:'
	      name: 'accessCharLabel'
	      layout: (AlignmentOrigin 217 0 170 0 1 0.5)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'accessCharField'
	      layout: (LayoutFrame 220 0 159 0 -5 1.0 181 0)
	      activeHelpKey: detailsAccessCharaterPosition
	      tabable: true
	      model: accessCharacterPosition
	      group: inputGroup
	      type: numberOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (CheckBoxSpec
	      label: 'Ignore Accelerator (i.e. Display Only)'
	      name: 'ignoreShortcutKeysInItem'
	      layout: (AlignmentOrigin 42 0 204 0 0 0.5)
	      activeHelpKey: detailsIgnoreAcceleratorKeys
	      visibilityChannel: hasNoSubmenu
	      model: ignoreShortcutKeys
	      translateLabel: true
	      resizeForLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Ignore Accelerators in Submenu'
	      name: 'ignoreShortcutKeys'
	      layout: (AlignmentOrigin 42 0 204 0 0 0.5)
	      activeHelpKey: detailsIgnoreAcceleratorKeys
	      visibilityChannel: hasSubmenu
	      model: ignoreShortcutKeys
	      translateLabel: true
	      resizeForLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Ignore Mnemonics in Submenu'
	      name: 'ignoreMnemonicKeys'
	      layout: (AlignmentOrigin 42 0 232 0 0 0.5)
	      activeHelpKey: detailsIgnoreMnemonicKeys
	      visibilityChannel: hasSubmenu
	      model: ignoreMnemonicKeys
	      translateLabel: true
	      resizeForLabel: true
	    )
	   (LabelSpec
	      label: 'Font:'
	      name: 'fontLabel'
	      layout: (AlignmentOrigin 107 0 271 0 1 0.5)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (FontMenuSpec
	      name: 'fontMenu'
	      layout: (LayoutFrame 110 0 260 0 -5 1.0 282 0)
	      activeHelpKey: fontMenu
	      model: font
	      allowSymbolicFonts: true
	    )
	   )

	)
      )

    "Modified: / 21-10-2010 / 14:15:09 / cg"
! !

!MenuEditor::Item class methodsFor:'interface-editor'!

addBindingsTo:aspects for:aMenuEditor
    "add additional bindings to the aspects
    "
    aspects at:#notDelayedMenu ifAbsentPut:[true asValue].
    aspects at:#hasSubmenu ifAbsentPut:[false asValue].
    aspects at:#hasNoSubmenu ifAbsentPut:[true asValue].
! !

!MenuEditor::Item class methodsFor:'testing'!

separatorTypeOf:aString
    |size first|

    size := aString size.

    size == 0 ifTrue:[ ^ #blank ].

    size == 1 ifTrue:[
	first := aString first.
	first == $-                ifTrue:[ ^ #single ].
	first == $=                ifTrue:[ ^ #double ].
	first == (Character space) ifTrue:[ ^ #blank  ].
    ].
    ^ nil
! !

!MenuEditor::Item methodsFor:'accessing'!

children
    "optimize access; do not ask the model for unspecified children
    "
    ^ children
!

menuItem
     "returns self as a MenuItem
    "
    ^ MenuItem decodeFromLiteralArray:(menuItem literalArrayEncoding).

    "Modified: / 27-03-2007 / 08:43:14 / cg"
!

menuItem:aMenuItem
    "rebuild self from a MenuItem
    "
    |value|

    menuItem := MenuItem label:(self rawLabel).

    MenuEditor aspects do:[:aKey|
        value := self validateValue:(aMenuItem perform:aKey).

        value notNil ifTrue:[
            self aspectAt:aKey put:value.
        ].
    ].
!

rawLabel
    "returns the label assigned to the item
    "
    ^ menuItem rawLabel
!

rawLabel:aValue
    "set the label assigned to the item
    "
    aValue isString ifTrue:[
	"/ KLUDGE alarm: '-' and '' indicate a separator
	"/ (there is no separate menuItem class for them)

	(self isKindOfMenu or:[(self class separatorTypeOf:aValue) isNil]) ifTrue:[
	    menuItem rawLabel:aValue
	]
    ].
!

slices
    "returns a sequence of supported slices
    "
    ^ self subclassResponsibility
!

submenu
    "returns the submenu (of class Menu) or nil
    "
    ^ nil
!

translateLabel:aBoolean
    menuItem translateLabel:aBoolean
! !

!MenuEditor::Item methodsFor:'aspects'!

aspectAt:aKey put:aValue
    "set a specific aspect named aKey to the aValue"

    aKey == #rawLabel       ifTrue:[ ^ self rawLabel:aValue ].
    aKey == #submenuChannel ifTrue:[ ^ self ].
    menuItem perform:(aKey asMutator) with:aValue.

    "Modified: / 05-09-2006 / 17:47:19 / cg"
!

fromAspects:aspects
    "read values from aspects
    "
    MenuEditor aspects do:[:aKey|
	self aspectAt:aKey put:((aspects at:aKey) value).
    ].
    self validateMenuItem.
    self changed.
!

toAspects:aspects
    "write values to aspects
    "
    MenuEditor aspects do:[:aKey|
	(aspects at:aKey) value:(menuItem perform:aKey)
    ].
    (aspects at:#notDelayedMenu) value:(self isDelayedMenu not).
    (aspects at:#hasSubmenu)     value:(self isKindOfMenu or:[self children size ~~ 0]).
    (aspects at:#hasNoSubmenu)   value:(self isKindOfMenu not ).
!

validateMenuItem
    "validate the menuItem for correctness"

    menuItem isNil ifTrue:[^ self].

    menuItem choice isEmptyOrNil ifTrue:[
	menuItem choice:nil.
	menuItem choiceValue:nil.
    ].
! !

!MenuEditor::Item methodsFor:'displaying'!

displayLabel
    "returns the label on default displayed on the screen
    "
    ^ menuItem rawLabel
!

displayOn:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    "display the item in the graphicsContext, aGC"

    |label|

    label := self displayLabel.

    label notNil ifTrue:[
        self displayLabel:label h:(self heightOn:aGC) on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    ].
!

heightOn:aGC
    "returns the height of the label on a GC
    "
    height isNil ifTrue:[ height := parent heightOn:aGC ].
    ^ height
!

label
    "get the rawLabel assigned to the item
    "
    ^ menuItem rawLabel
!

label:aLabel
    "set the rawLabel assigned to the item
    "
    self rawLabel:aLabel
!

widthOn:aGC
    "returns the height of the displayLabel on a GC
    "
    width isNil ifTrue:[ width := self widthOf:(self displayLabel) on:aGC ].
    ^ width
! !

!MenuEditor::Item methodsFor:'initialization'!

initialize
    super initialize.
    menuItem := MenuItem label:(self class defaultLabel).
! !

!MenuEditor::Item methodsFor:'private'!

validateValue:aValue
    "if we pick a menupanel, the values of an item can be
     a block model, ....
    "
    aValue notNil ifTrue:[
	aValue isBlock      ifTrue:[ ^ #block ].
	aValue isValueModel ifTrue:[ ^ #valueModel ].
    ].
    ^ aValue
! !

!MenuEditor::Item methodsFor:'queries'!

isAction
    "returns true if the item is an Action
    "
    ^ false
!

isDelayedMenu
    "returns true if the item is a Delayed (Linked) Menu
    "
    ^ parent isAction
!

isKindOfLinkedMenu
    "returns true if the item is a Linked Menu
    "
    ^ false
!

isKindOfMenu
    "returns true if the item is a Linked Menu or Menu
    "
    ^ false
!

isKindOfNonLinkedMenu
    "returns true if the item is a Linked Menu
    "
    ^ false
!

isMenuEditItem
    ^ true
!

isRootItem
    "returns true if the item is the root item
    "
    ^ false
! !

!MenuEditor::Item methodsFor:'queries-editor'!

actionSelectors
    "return my action selectors"

    |value|

    value := menuItem value.
    value isSymbol ifTrue:[ ^ Array with:value ].
    ^ #()
!

aspectSelectors
    "return my aspect selectors"

    |aspects|

    aspects := OrderedCollection new.

    #( indication choice enabled isVisible ) do:[:aKey| |sel|
	sel := menuItem perform:aKey.
	sel isSymbol ifTrue:[ aspects add:sel ]
    ].
    ^ aspects
! !

!MenuEditor::Item methodsFor:'queries-operation'!

canAddChildren
    "returns true if children can be added
    "
    ^ false
!

canAddDelayedMenu
    "returns true if a delayed menu can be added;
     on default false is returned
    "
    ^ false
!

canMoveInAbove
    "returns true if the item can become a child of its previous sibling
    "
    |siblings index nextItem|

    siblings := parent children.
    siblings size > 1 ifFalse:[ ^ false ].

    index    := siblings identityIndexOf:self.
    nextItem := siblings at:(index - 1)  ifAbsent:nil.

    nextItem isNil ifTrue:[^ false].
    ^ nextItem canAddChildren
!

canMoveInNext
    "returns true if the item can become a child of its next sibling
    "
    |siblings index nextItem|

    siblings := parent children.
    siblings size > 1 ifFalse:[ ^ false ].

    index    := siblings identityIndexOf:self.
    nextItem := siblings at:(index + 1)  ifAbsent:nil.

    nextItem isNil ifTrue:[^ false].
    ^ nextItem canAddChildren
!

canMoveOut
    "returns true if the item can be moved out from its current parent
    "
    self   isDelayedMenu ifTrue:[^ false].
    parent isDelayedMenu ifTrue:[^ false].

  ^ parent parent notNil
!

canMoveUpOrDown
    "returns true if the item can change its vertical order in its sibling
    "
    ^ parent children size > 1
! !

!MenuEditor::ImageResourceEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::ImageResourceEditor andSelector:#windowSpec
     MenuEditor::ImageResourceEditor new openInterface:#windowSpec
     MenuEditor::ImageResourceEditor open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Image Item'
	  name: 'Image Item'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 303 304)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Retriever:'
	      name: 'retrieverLabel'
	      layout: (AlignmentOrigin 107 0 26 0 1 0.5)
	      activeHelpKey: imageRetriever
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (ComboBoxSpec
	      name: 'retrieverHolder'
	      layout: (LayoutFrame 110 0 15 0 -2 1.0 37 0)
	      activeHelpKey: imageRetriever
	      tabable: true
	      model: retrieverHolder
	      type: symbolOrNil
	      immediateAccept: true
	      acceptOnReturn: false
	      acceptOnTab: false
	      acceptOnPointerLeave: false
	      entryCompletionBlock: entryCompletionForRetriever
	      comboList: retrieverList
	      isFilenameBox: false
	    )
	   (LabelSpec
	      label: 'Selector:'
	      name: 'iconLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      activeHelpKey: imageSelector
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'selectorHolder'
	      layout: (LayoutFrame 110 0 40 0 -24 1.0 62 0)
	      activeHelpKey: imageSelector
	      tabable: true
	      model: selectorHolder
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: true
	      acceptOnReturn: false
	      acceptOnTab: false
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (ActionButtonSpec
	      label: '...'
	      name: 'browseButton'
	      layout: (LayoutFrame -22 1 40 0 -2 1 62 0)
	      activeHelpKey: browseResource
	      tabable: true
	      model: doBrowseForImageResource
	    )
	   (DividerSpec
	      name: 'Separator1'
	      layout: (LayoutFrame 0 0.0 66 0 0 1.0 70 0)
	    )
	   (ViewSpec
	      name: 'SelectorFilterBox2'
	      layout: (LayoutFrame 0 0.0 74 0 0 1.0 96 0)
	      activeHelpKey: selectorFilter
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Filter:'
		    name: 'Label1'
		    layout: (AlignmentOrigin 107 0 11 0 1 0.5)
		    activeHelpKey: selectorFilter
		    translateLabel: true
		    resizeForLabel: true
		    adjust: right
		  )
		 (InputFieldSpec
		    name: 'EntryField1'
		    layout: (LayoutFrame 110 0 0 0 -2 1 22 0)
		    model: selectorFilterHolder
		    immediateAccept: true
		    acceptOnLeave: true
		    acceptOnReturn: false
		    acceptOnTab: false
		    acceptOnPointerLeave: false
		    activeHelpKey: selectorFilter
		  )
		 )

	      )
	    )
	   (HierarchicalListViewSpec
	      name: 'imageList'
	      layout: (LayoutFrame 2 0.0 100 0 -2 1.0 -60 1.0)
	      activeHelpKey: imageImageList
	      model: imageHolder
	      menu: menuEditImage
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      miniScrollerHorizontal: true
	      listModel: imageList
	      useIndex: false
	      highlightMode: label
	      postBuildCallback: postBuildImageViewer:
	    )
	   (ViewSpec
	      name: 'Box1'
	      layout: (LayoutFrame 20 0.0 -60 1.0 -20 1.0 0 1.0)
	      level: 0
	      component:
	     (SpecCollection
		collection: (
		 (CheckBoxSpec
		    label: 'Image & Label'
		    name: 'iconAndLabelCheckBox'
		    layout: (AlignmentOrigin 0 0 17 0 0 0.5)
		    activeHelpKey: imageImageAndLabel
		    tabable: true
		    model: iconAndLabelHolder
		    translateLabel: true
		  )
		 (ActionButtonSpec
		    label: 'Image Editor'
		    name: 'imageEditorButton'
		    layout: (AlignmentOrigin -69 1.0 17 0 0 0.5)
		    activeHelpKey: imageImageEditor
		    hasCharacterOrientedLabel: false
		    foregroundColor: (Color 0.0 0.0 66.9993133440146)
		    tabable: true
		    model: doEditImage
		  )
		 (ActionButtonSpec
		    label: 'Browse'
		    name: 'Button1'
		    layout: (AlignmentOrigin -69 1.0 41 0 0 0.5)
		    activeHelpKey: imageBrowseImageClass
		    hasCharacterOrientedLabel: false
		    foregroundColor: (Color 0.0 0.0 66.9993133440146)
		    tabable: true
		    model: doBrowseImageClass
		  )
		 )

	      )
	    )
	   )

	)
      )

    "Modified: / 03-08-2011 / 10:16:13 / cg"
! !

!MenuEditor::ImageResourceEditor methodsFor:'accessing'!

resourceRetriever
    |rcv sel cls clsName|

    sel := selectorHolder value.
    sel size == 0 ifTrue:[ ^ nil ].
    cls := self retrieverClass.
    cls notNil ifTrue:[
	clsName := retrieverHolder value.
	clsName isEmptyOrNil ifTrue:[
	    clsName := cls name.
	].
	clsName := clsName asSymbol.
    ].

    rcv := ResourceRetriever new.
    rcv className:clsName.
    rcv selector:sel.

    iconAndLabelHolder value ifTrue:[ rcv labelText:'' ].
    ^ rcv
!

resourceRetriever:aResourceRetriever
    |className sel isOn|

    aResourceRetriever notNil ifTrue:[
	className := aResourceRetriever className.
	className isBehavior ifTrue:[
	    className := className name asSymbol
	].
	sel  := aResourceRetriever selector.
	isOn := aResourceRetriever labelText notNil.
    ] ifFalse:[
	className := sel := nil.
	isOn := false.
    ].

    retrieverHolder value:className.
    selectorHolder  value:sel.
    iconAndLabelHolder value:isOn.
!

retrieverClass
    |clsName cls|

    clsName  := retrieverHolder value.
    clsName notEmptyOrNil ifTrue:[
	cls := Smalltalk at:clsName ifAbsent:nil.
	(cls isBehavior) ifTrue:[
	    ^ cls
	].
    ].
    ^ nil
! !

!MenuEditor::ImageResourceEditor methodsFor:'actions'!

doBrowseForImageResource
    "opens a browser on image-resource methods"

    |classAndSelector|

    classAndSelector := ResourceSelectionBrowser
		request:'Use Image From Class'
		onSuperclass:nil
		andClass:(self retrieverClass)
		andSelector:(selectorHolder value)
		withResourceTypes:#(image fileImage programImage).

    classAndSelector isNil ifTrue:[ ^ self ].

    retrieverHolder value:(classAndSelector methodClass) name.
    selectorHolder  value:(classAndSelector methodSelector).
!

doBrowseImageClass
    |cls sel image|

    (cls := retrieverHolder value) isNil ifTrue:[
        Dialog warn:'No resource retriever is defined.'.
    ] ifFalse:[
        sel := selectorHolder value.

        cls := Smalltalk classNamed:cls.
        cls isNil ifTrue:[
            Dialog warn:'No such resource retriever class.'.
        ] ifFalse:[
            (cls respondsTo:#visualFor:) ifTrue:[
                image := cls visualFor:sel.
                image ~~ (cls perform:sel ifNotUnderstood:nil) ifTrue:[
                    self warn:'The image as returned by #visualFor: is probably provided by another class.\\Showing all implementors of #',sel.
                    "/ sel := #visualFor:.
                    UserPreferences systemBrowserClass browseImplementorsOf:sel.
                    ^ self.
                ].
            ].
            UserPreferences systemBrowserClass openInClass:(cls class) selector:sel
        ]
    ]

    "Created: / 20-09-2010 / 13:27:34 / cg"
!

doEditImage
    |sel cls item image|

    item := imageHolder value.
    item notNil ifTrue:[
	item doEdit.
	^ self.
    ].

    sel := selectorHolder value.
    sel isNil ifTrue:[
	Dialog warn:'No selector is defined.'.
	^ self.
    ].
    cls := retrieverHolder value.
    cls isNil ifTrue:[
	Dialog warn:'No resource retriever is defined.'.
	^ self.
    ].
    cls := Smalltalk classNamed:cls.
    cls isNil ifTrue:[
	Dialog warn:'No such resource retriever class.'.
	^ self.
    ].
    (cls respondsTo:#visualFor:) ifTrue:[
	image := cls visualFor:sel.
	image ~~ (cls perform:sel ifNotUnderstood:nil) ifTrue:[
	    self warn:'The image is resolved via #visualFor: from some unknown class'.
	    image notNil ifTrue:[
		ImageEditor openOnImage:image.
	    ].
	    ^ self.
	].
    ].

    ImageEditor openOnClass:cls andSelector:sel
! !

!MenuEditor::ImageResourceEditor methodsFor:'aspects'!

entryCompletionForRetriever
    ^ DoWhatIMeanSupport classNameEntryCompletionBlock.

    "Modified: / 10-08-2006 / 12:55:22 / cg"
!

iconAndLabelHolder
    ^ iconAndLabelHolder
!

imageHolder
    ^ imageHolder.
!

imageList
    ^ imageList
!

modifiedChannel
    ^ builder booleanValueAspectFor: #modifiedChannel
!

modifiedChannel:aChannel
    builder aspectAt:#modifiedChannel put:aChannel.
!

retrieverHolder
    ^ retrieverHolder
!

retrieverList
    |listOfClassNames cls owner|

    listOfClassNames := builder bindingAt:#retrieverList.
    listOfClassNames isNil ifTrue:[
        listOfClassNames := MenuEditor imageRetrieverClasses asList.
        builder aspectAt:#retrieverList put:listOfClassNames.
    ].
    (masterApplication notNil
     and:[(cls := masterApplication specClass) notNil]) ifTrue:[
        (listOfClassNames includes:cls name) ifFalse:[ listOfClassNames addFirst:cls name ].
        cls isPrivate ifTrue:[
            (owner := cls owningClass) notNil ifTrue:[
                (listOfClassNames includes:owner name) ifFalse:[ listOfClassNames addFirst:owner name ].   
            ].
        ].
    ].
    ^ listOfClassNames
!

selectorFilterHolder
    ^ selectorFilterHolder

    "Created: / 03-08-2011 / 10:01:05 / cg"
!

selectorHolder
    ^ selectorHolder.
! !

!MenuEditor::ImageResourceEditor methodsFor:'change & update'!

retrieverChanged
    |retriever list name|

    retriever := self retrieverClass.
    imageHolder setValue:nil.

    self updateImageList.
    self updateSelectedImage.

    (retriever notNil and:[imageList size ~~ 0]) ifTrue:[
	list := self retrieverList.
	name := retriever name.

	(list includes:name) ifFalse:[
	    list add:(name asSymbol).
	]
    ].

    "Modified: / 03-08-2011 / 10:56:58 / cg"
!

selectorChanged
    self updateSelectedImage.

    "Modified: / 03-08-2011 / 10:56:04 / cg"
!

selectorFilterChanged
    self updateImageList.
    self updateSelectedImage.

    "Created: / 03-08-2011 / 10:58:47 / cg"
!

update:what with:aPara from:aModel
    |item|

    self modifiedChannel value:true.

    aModel == retrieverHolder ifTrue:[ self retrieverChanged. ^ self ].
    aModel == selectorHolder ifTrue:[ self selectorChanged. ^ self  ].
    aModel == selectorFilterHolder ifTrue:[ self selectorFilterChanged. ^ self  ].

    aModel == imageHolder ifTrue:[
	item := imageHolder value.
	item notNil ifTrue:[
	    selectorHolder value:(item label)
	].
	^ self
    ].
    super update:what with:aPara from:aModel

    "Modified: / 29-11-2011 / 11:28:26 / cg"
!

updateImageList
    |retriever selectorFilterString filter|

    retriever := self retrieverClass.

    filter := [:sel | true].
    (selectorFilterString := selectorFilterHolder value) notEmptyOrNil ifTrue:[
	selectorFilterString includesMatchCharacters ifTrue:[
	    filter := [:sel | selectorFilterString match:sel ignoreCase:true].
	] ifFalse:[
	    filter := [:sel | sel includesString:selectorFilterString].
	].
    ].

    imageList root updateFromClass:retriever selectorFilter:filter.

    "Created: / 03-08-2011 / 10:56:41 / cg"
!

updateSelectedImage
    "provider or selector has changed; select it in the list"

    |item selector line|

    imageList isEmpty ifTrue:[^ self].

    selector := selectorHolder value.
    selector isEmptyOrNil ifTrue:[
	imageHolder value:nil.
	^ self
    ].

    item     := nil.
    selector := selector asSymbol.

    imageList do:[:anItem|
	|sel|

	sel := anItem selector.
	selector == sel ifTrue:[
	    imageHolder value:anItem.
	    ^ self
	].
	item isNil ifTrue:[
	    (sel startsWith:selector) ifTrue:[ item := anItem ]
	]
    ].
    imageHolder value:nil.

    item notNil ifTrue:[
	line := imageList identityIndexOf:item.
	line ~~ 0 ifTrue:[
	    "/ imageListView scrollToLine:line
	    imageListView makeLineVisible:line
	]
    ].

    "Created: / 03-08-2011 / 10:55:45 / cg"
! !

!MenuEditor::ImageResourceEditor methodsFor:'initialization'!

initialize
    super initialize.

    iconAndLabelHolder := true asValue.
    iconAndLabelHolder addDependent:self.

    imageHolder := nil asValue.

    selectorHolder := nil asValue.
    selectorHolder addDependent:self.

    imageList := HierarchicalList new.
    imageList application:self.
    imageList root:(ImageResourceEditorItem new).
    imageList showRoot:false.

    imageHolder := nil asValue.
    imageHolder addDependent:self.

    retrieverHolder := nil asValue.
    retrieverHolder addDependent:self.

    selectorFilterHolder := '' asValue.
    selectorFilterHolder addDependent:self.

    "Modified: / 03-08-2011 / 10:18:46 / cg"
!

postBuildImageViewer:aWidget
    imageListView := aWidget.
! !

!MenuEditor::ImageResourceEditor::ImageResourceEditorItem methodsFor:'accessing'!

icon
    ^ icon
!

label
    ^ selector
!

selector
    ^ selector
! !

!MenuEditor::ImageResourceEditor::ImageResourceEditorItem methodsFor:'instance creation'!

forClass:aClass selector:aSelector
    |w h magnify iconOrSymbol|

    selector := aSelector asSymbol.
    selector numArgs == 0 ifFalse:[^ self].

    "do what the ResourceRetriever will do"
    (aClass respondsTo:#visualFor:) ifTrue:[
	iconOrSymbol := aClass visualFor:selector.
    ].
    iconOrSymbol isNil ifTrue:[
	iconOrSymbol := aClass perform:selector.
    ].
    iconOrSymbol isNil ifTrue:[^ self].

    iconOrSymbol isSymbol ifTrue:[
	icon := ToolbarIconLibrary perform:iconOrSymbol.
    ] ifFalse:[
	icon := iconOrSymbol.
    ].

    w := icon width.
    h := icon height.

    w > 32 ifTrue:[
	magnify := 32 / w.
	h > 32 ifTrue:[ magnify := (32 / h) max:magnify ].
    ] ifFalse:[
	h > 32 ifFalse:[^ self].
	magnify := 32 / h.
    ].
    icon := icon magnifiedBy: magnify.

    "Modified: / 13-04-2011 / 18:56:45 / cg"
    "Created: / 03-08-2011 / 10:47:16 / cg"
!

initialize
    super initialize.
    children := #().
!

updateFromClass:aClass selectorFilter:aFilterBlock
    (aClass notNil and:[aClass isBehavior]) ifFalse:[
        ^ self collapse.
    ].
"/    aClass == selector ifTrue:[
"/        ^ self expand
"/    ].
    self collapse.

    selector := aClass.

    self application withWaitCursorDo:[
        |methods|
        methods := aClass methodsWithAnyResource:#(image programImage).
        children := methods 
                        select:[:each| aFilterBlock value:each selector]
                        thenCollect:[:each|
                                |item|
                                item := self class new forClass:aClass selector:each selector.
                                item parent:self.
                        ].

        children sort:[:a :b | a label < b label ].
        self expand
    ].

    "Created: / 03-08-2011 / 10:48:10 / cg"
! !

!MenuEditor::ImageResourceEditor::ImageResourceEditorItem methodsFor:'user operations'!

doEdit
    "open image browser on self"

    |parent aClass image|

    parent := self parent.
    parent notNil ifTrue:[
	aClass := parent selector.
	(aClass respondsTo:#visualFor:) ifTrue:[
	    image := aClass visualFor:selector.
	    image ~~ (aClass perform:selector) ifTrue:[
		self warn:'The image is resolved via #visualFor: from some unknown class'.
		ImageEditor openOnImage:image.
		^ self.
	    ].
	].
	ImageEditor openOnClass:aClass andSelector:selector.
    ].
! !

!MenuEditor::ActionItem class methodsFor:'defaults'!

defaultLabel
    ^ 'Action'
! !

!MenuEditor::ActionItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::ActionItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'basicsEditSpec'
          name: 'basicsEditSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 340 340)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Name Key:'
              name: 'nameKeyLabel'
              layout: (AlignmentOrigin 107 0 25 0 1 0.5)
              activeHelpKey: basicsKey
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'nameKeyField'
              layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
              activeHelpKey: basicsKey
              tabable: true
              model: nameKey
              group: inputGroup
              type: symbolOrNil
              immediateAccept: false
              acceptOnLeave: false
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: false
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Label:'
              name: 'labelLabel'
              layout: (AlignmentOrigin 107 0 51 0 1 0.5)
              activeHelpKey: basicsLabel
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'labelField'
              layout: (LayoutFrame 110 0 40 0 -5 1.0 62 0)
              activeHelpKey: basicsLabel
              tabable: true
              model: rawLabel
              group: inputGroup
              immediateAccept: false
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: false
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Action:'
              name: 'valueLabel'
              layout: (AlignmentOrigin 107 0 82 0 1 0.5)
              activeHelpKey: basicsAction
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'valueField'
              layout: (LayoutFrame 110 0 71 0 -25 1.0 93 0)
              activeHelpKey: basicsAction
              tabable: true
              model: itemValue
              group: inputGroup
              type: symbolOrNil
              immediateAccept: false
              acceptOnLeave: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: true
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -25 1 71 0 -5 1 93 0)
              activeHelpKey: browseMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              resizeForLabel: true
              tabable: true
              model: doBrowseActionMethod
            )
           (LabelSpec
              label: 'Argument:'
              name: 'argumentLabel'
              layout: (AlignmentOrigin 107 0 107 0 1 0.5)
              activeHelpKey: basicsArgument
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'argumentField'
              layout: (LayoutFrame 110 0 96 0 -5 1.0 118 0)
              activeHelpKey: basicsArgument
              tabable: true
              model: argument
              group: inputGroup
              type: smalltalkObjectOrNil
              immediateAccept: false
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: false
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Indication:'
              name: 'indicationLabel'
              layout: (AlignmentOrigin 107 0 138 0 1 0.5)
              activeHelpKey: basicsIndication
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'indicationField'
              layout: (LayoutFrame 110 0 127 0 -25 1.0 149 0)
              activeHelpKey: basicsIndication
              enableChannel: indicationEnabled
              tabable: true
              model: indication
              group: inputGroup
              type: symbolOrNil
              immediateAccept: true
              acceptOnReturn: false
              acceptOnTab: false
              acceptOnLostFocus: false
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button2'
              layout: (LayoutFrame -25 1 127 0 -5 1 149 0)
              activeHelpKey: browseMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              resizeForLabel: true
              tabable: true
              model: doBrowseIndicationMethod
            )
           (LabelSpec
              label: 'Choice:'
              name: 'choiceLabel'
              layout: (AlignmentOrigin 107 0 163 0 1 0.5)
              activeHelpKey: basicsChoice
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'choiceField'
              layout: (LayoutFrame 110 0 152 0 -25 1.0 174 0)
              activeHelpKey: basicsChoice
              enableChannel: choiceEnabled
              tabable: true
              model: choice
              group: inputGroup
              type: symbolOrNil
              immediateAccept: true
              acceptOnReturn: false
              acceptOnTab: false
              acceptOnLostFocus: false
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button3'
              layout: (LayoutFrame -25 1 152 0 -5 1 174 0)
              activeHelpKey: browseMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              resizeForLabel: true
              tabable: true
              model: doBrowseChoiceMethod
            )
           (LabelSpec
              label: 'Value:'
              name: 'choiceValueLabel'
              layout: (AlignmentOrigin 107 0 188 0 1 0.5)
              activeHelpKey: basicsChoiceValue
              translateLabel: true
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'choiceValueField'
              layout: (LayoutFrame 110 0 177 0 -5 1.0 199 0)
              activeHelpKey: basicsChoiceValue
              enableChannel: choiceValueEnabled
              tabable: true
              model: choiceValue
              group: inputGroup
              type: smalltalkObjectOrNil
              immediateAccept: false
              acceptOnLeave: false
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: false
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              acceptOnPointerLeave: false
            )
           (CheckBoxSpec
              label: 'Translate Label'
              name: 'translateLabelCheckBox'
              layout: (AlignmentOrigin 7 0 213 0 0 0)
              activeHelpKey: basicsTranslateLabel
              tabable: true
              model: translateLabel
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Is Button'
              name: 'isButtonCheckBox'
              layout: (AlignmentOrigin 7 0 238 0 0 0)
              activeHelpKey: basicsIsButton
              tabable: true
              model: isButton
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Hide Menu after Activation'
              name: 'hideMenuOnActivated'
              layout: (AlignmentOrigin 7 0 263 0 0 0)
              activeHelpKey: hideMenuOnActivated
              tabable: true
              model: hideMenuOnActivated
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'BusyCursor while Active'
              name: 'showBusyCursorWhilePerforming'
              layout: (AlignmentOrigin 7 0 288 0 0 0)
              activeHelpKey: showBusyCursorWhilePerforming
              tabable: true
              model: showBusyCursorWhilePerforming
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Trigger on Down'
              name: 'triggerOnDown'
              layout: (AlignmentOrigin 25 0.5 238 0 0 0)
              activeHelpKey: triggerOnDown
              enableChannel: hasNoDelayedMenuValue
              tabable: true
              model: triggerOnDown
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Send to Originating Widget'
              name: 'sendToOriginator'
              layout: (AlignmentOrigin 7 0 313 0 0 0)
              activeHelpKey: sendToOriginator
              enableChannel: hasItemValue
              tabable: true
              model: sendToOriginator
              translateLabel: true
            )
           )
         
        )
      )
! !

!MenuEditor::ActionItem class methodsFor:'interface-editor'!

addBindingsTo:aspects for:aMenuEditor
    "add additional bindings to the aspects
    "
    aspects
	at:#indicationEnabled
	ifAbsentPut:[ BlockValue with:[:a | a size == 0 ] argument:(aspects at:#choice)].

    aspects
	at:#choiceEnabled
	ifAbsentPut:[ BlockValue with:[:a | a size == 0 ] argument:(aspects at:#indication)].

    aspects
	at:#choiceValueEnabled
	ifAbsentPut:[ BlockValue with:[:a | a size ~~ 0 ] argument:(aspects at:#choice)].

    aspects
	at:#hasNoDelayedMenuValue
	ifAbsentPut:[true asValue].
! !

!MenuEditor::ActionItem methodsFor:'accessing'!

menuItem
    |item|

    item := super menuItem.
    self hasDelayedMenu ifTrue:[
	children first setDelayedAttributesTo:item.

	menuItem value isNil ifTrue:[
	    menuItem value:#unspecified
	]
    ].
    ^ item
!

menuItem:anItem
    |submenu item|

    super menuItem:anItem.
    submenu := anItem submenu.

    submenu notNil ifTrue:[
	item := MenuEditor::RegularMenuItem new
    ] ifFalse:[
	anItem submenuChannel isNil ifTrue:[
	    ^ self
	].
	item := MenuEditor::LinkedMenuItem new
    ].
    item getDelayedAttributesFrom:anItem.
    self add:item.
!

slices
    ^ #(
	    (Basics   basicsEditSpec )
	    (Details  detailsEditSpec)
	    (Image    image  )
	    (Help     help)
       )
! !

!MenuEditor::ActionItem methodsFor:'adding & removing'!

add:anItem
    "add an item; test whether the item is a delayed menu and
     not already a delayed menu exists."

    (anItem isKindOfMenu and:[ self canAddDelayedMenu ]) ifFalse:[
	^ nil
    ].

    menuItem triggerOnDown:false.
    anItem argument:(menuItem argument).
    isExpanded := false.
    anItem parent:self.
    children := Array with:anItem.
    self expand.
    ^ anItem

    "Modified: / 05-09-2006 / 17:49:57 / cg"
! !

!MenuEditor::ActionItem methodsFor:'aspects'!

aspectAt:aKey put:aValue
    "set a specific aspect named aKey to the aValue"

    aKey == #argument ifTrue:[
	self hasDelayedMenu ifTrue:[
	    children first argument:aValue
	].
	menuItem argument:aValue.
	^ self
    ].

    aKey == #triggerOnDown ifTrue:[
	|triggerOnDown|

	self hasDelayedMenu ifTrue:[
	    triggerOnDown := false
	] ifFalse:[
	    triggerOnDown := aValue
	].
	menuItem triggerOnDown:triggerOnDown.
	^ self.
    ].
    super aspectAt:aKey put:aValue.

    "Modified: / 05-09-2006 / 17:47:24 / cg"
!

toAspects:aspects
    "write values to aspects
    "
    |hasDelayedMenu|

    super toAspects:aspects.

    hasDelayedMenu := self hasDelayedMenu.
    (aspects at:#hasNoDelayedMenuValue) value:(hasDelayedMenu not).

    hasDelayedMenu ifTrue:[
	(aspects at:#triggerOnDown) value:false
    ].
! !

!MenuEditor::ActionItem methodsFor:'displaying'!

icon
    ^ self class iconItem
! !

!MenuEditor::ActionItem methodsFor:'initialization'!

initialize
    super initialize.
    isExpanded := true.
! !

!MenuEditor::ActionItem methodsFor:'queries'!

canCollapse
    ^ false
!

hasDelayedMenu
    "returns true if a delayed menu exists
    "
    ^ children size ~~ 0
!

hasIndicator
    ^ false
!

isAction
    ^ true
! !

!MenuEditor::ActionItem methodsFor:'queries-operation'!

canAddDelayedMenu
    "returns true if a delayed menu can be added
    "
    ^ self hasDelayedMenu not
! !

!MenuEditor::LinkedMenuItem class methodsFor:'defaults'!

defaultLabel
    ^ 'Linked Menu'
! !

!MenuEditor::LinkedMenuItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::LinkedMenuItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: basicsEditSpec
	window:
       (WindowSpec
	  label: 'basicsEditSpec'
	  name: 'basicsEditSpec'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 340 340)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Name Key:'
	      name: 'nameKeyLabel'
	      layout: (AlignmentOrigin 107 0 25 0 1 0.5)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'nameKeyField'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: nameKey
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnLeave: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Label:'
	      name: 'labelLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'labelField'
	      layout: (LayoutFrame 110 0 40 0 -5 1.0 62 0)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: rawLabel
	      group: inputGroup
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Menu:'
	      name: 'menuLabel'
	      layout: (AlignmentOrigin 107 0 90 0 1 0.5)
	      activeHelpKey: basicsLabel
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'menuField'
	      layout: (LayoutFrame 110 0 79 0 -5 1.0 101 0)
	      activeHelpKey: basicsMenu
	      tabable: true
	      model: submenuChannel
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Argument:'
	      name: 'argumentLabel'
	      layout: (AlignmentOrigin 107 0 115 0 1 0.5)
	      activeHelpKey: basicsLabel
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'argumentField'
	      layout: (LayoutFrame 110 0 104 0 -5 1.0 126 0)
	      activeHelpKey: basicsMenuArgument
	      enableChannel: notDelayedMenu
	      tabable: true
	      model: argument
	      group: inputGroup
	      type: smalltalkObjectOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (CheckBoxSpec
	      label: 'Translate Label'
	      name: 'translateLabelCheckBox'
	      layout: (Point 20 213)
	      activeHelpKey: basicsTranslateLabel
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: translateLabel
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Is Button'
	      name: 'isButtonCheckBox'
	      layout: (Point 20 238)
	      activeHelpKey: basicsIsButton
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: isButton
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Horizontal Layout'
	      name: 'horizontalLayout'
	      layout: (Point 20 263)
	      activeHelpKey: horizontalLayout
	      tabable: true
	      model: horizontalLayout
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Do not Destroy Linked Menu'
	      name: 'keepLinkedMenu'
	      layout: (Point 20 288)
	      activeHelpKey: keepLinkedMenu
	      tabable: true
	      model: keepLinkedMenu
	      translateLabel: true
	    )
	   )

	)
      )
! !

!MenuEditor::LinkedMenuItem methodsFor:'accessing'!

argument:aValue
    menuItem argument:aValue.
!

menuItem
     "returns self as a MenuItem
    "
    |item|

    item := super menuItem.
    item submenuChannel:(self submenuChannel).
  ^ item
!

slices
    self isDelayedMenu ifTrue:[
	^ #(
		(Basics   basicsEditSpec )
	   )
    ].

    ^ #(
	    (Basics   basicsEditSpec )
	    (Details  detailsEditSpec)
	    (Image    image  )
	    (Help     help)
       )
!

submenuChannel
    ^ menuItem submenuChannel ? #unspecified
!

submenuChannel:aValue
    menuItem submenuChannel:aValue.
! !

!MenuEditor::LinkedMenuItem methodsFor:'aspects'!

aspectAt:aKey put:aValue
    "set a specific aspect named aKey to the aValue"

    aKey == #submenuChannel ifTrue:[ ^ self submenuChannel:aValue ].
    super aspectAt:aKey put:aValue.

    "Modified: / 05-09-2006 / 17:47:39 / cg"
!

getDelayedAttributesFrom:anItem

    menuItem rawLabel:'Delayed'.

    menuItem   submenuChannel:(self validateValue:(anItem submenuChannel)).
    menuItem horizontalLayout:(self validateValue:(anItem horizontalLayout)).
    menuItem   keepLinkedMenu:(self validateValue:(anItem keepLinkedMenu)).
!

setDelayedAttributesTo:aMenuItem
    aMenuItem   submenuChannel:(self submenuChannel).
    aMenuItem horizontalLayout:(menuItem horizontalLayout).
    aMenuItem   keepLinkedMenu:(menuItem keepLinkedMenu).
! !

!MenuEditor::LinkedMenuItem methodsFor:'displaying'!

displayLabel
    "returns the label dependent on is delayed or not
    "
    self isDelayedMenu ifTrue:[ ^ self submenuChannel ].
  ^ menuItem rawLabel
!

icon
    self isDelayedMenu ifTrue:[ ^ self class iconDelayedLinkedMenu ].
  ^ self class iconLinkedMenu
! !

!MenuEditor::LinkedMenuItem methodsFor:'initialization'!

initialize
    "setup default values on the item
    "
    super initialize.

    "setting default values
    "
    "/ CG: Thu, 08 May 2008 11:16:54 GMT
    "/     I think having keepLinkedMenu true by default
    "/     will confuse newcomers (even me occasionally)
    "/     (will search, why the menu is not updated...)

    "/ menuItem keepLinkedMenu:true.
    menuItem keepLinkedMenu:false.
! !

!MenuEditor::LinkedMenuItem methodsFor:'queries'!

isKindOfLinkedMenu
    ^ true
!

isKindOfMenu
    ^ true
! !

!MenuEditor::MenuSliceItem class methodsFor:'defaults'!

defaultLabel
    ^ 'Menu Slice'
! !

!MenuEditor::MenuSliceItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::MenuSliceItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: basicsEditSpec
	window:
       (WindowSpec
	  label: 'basicsEditSpec'
	  name: 'basicsEditSpec'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 344 146)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Name Key:'
	      name: 'nameKeyLabel'
	      layout: (AlignmentOrigin 107 0 25 0 1 0.5)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'nameKeyField'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: nameKey
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnLeave: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Label:'
	      name: 'labelLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'labelField'
	      layout: (LayoutFrame 110 0 40 0 -5 1.0 62 0)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: rawLabel
	      group: inputGroup
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Menu:'
	      name: 'menuLabel'
	      layout: (AlignmentOrigin 107 0 90 0 1 0.5)
	      activeHelpKey: basicsLabel
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'menuField'
	      layout: (LayoutFrame 110 0 79 0 -5 1.0 101 0)
	      activeHelpKey: basicsMenu
	      tabable: true
	      model: submenuChannel
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Argument:'
	      name: 'argumentLabel'
	      layout: (AlignmentOrigin 107 0 115 0 1 0.5)
	      activeHelpKey: basicsLabel
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'argumentField'
	      layout: (LayoutFrame 110 0 104 0 -5 1.0 126 0)
	      activeHelpKey: basicsMenuArgument
	      enableChannel: notDelayedMenu
	      tabable: true
	      model: argument
	      group: inputGroup
	      type: smalltalkObjectOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   )

	)
      )
! !

!MenuEditor::MenuSliceItem methodsFor:'accessing'!

icon
    ^ self class iconSliceMenu
!

menuItem
     "returns self as a MenuItem
    "
    |item|

    item := super menuItem.
    item submenuChannel:(self submenuChannel).
    item isMenuSlice:true.
  ^ item
!

slices
    ^ #(
	    (Basics   basicsEditSpec)
       )
! !

!MenuEditor::MenuSliceItem methodsFor:'aspects'!

argument:aValue
    menuItem argument:aValue.
!

aspectAt:aKey put:aValue
    "set a specific aspect named aKey to the aValue"

    aKey == #submenuChannel ifTrue:[ ^ self submenuChannel:aValue ].
    aKey == #isSliceMenu    ifTrue:[ ^ self ].

    super aspectAt:aKey put:aValue.

    "Modified: / 05-09-2006 / 17:47:42 / cg"
!

submenuChannel
    ^ menuItem submenuChannel ? #unspecified
!

submenuChannel:aValue
    menuItem submenuChannel:aValue.
! !

!MenuEditor::RegularMenuItem class methodsFor:'defaults'!

defaultDelayedLabel
    ^ 'delayed'
!

defaultLabel
    ^ 'Menu'
! !

!MenuEditor::RegularMenuItem class methodsFor:'instance creation'!

menu:aMenu labeled:aString
    |item|

    item := self new.
    item menu:aMenu labeled:aString.
    ^ item
!

menu:aMenu labeled:aString translateLabel:translateLabel
    |item|

    item := self new.
    item menu:aMenu labeled:aString.
    item translateLabel:translateLabel.
    ^ item
! !

!MenuEditor::RegularMenuItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::RegularMenuItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: basicsEditSpec
	window:
       (WindowSpec
	  label: 'basicsEditSpec'
	  name: 'basicsEditSpec'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 340 340)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Name Key:'
	      name: 'nameKeyLabel'
	      layout: (AlignmentOrigin 107 0 25 0 1 0.5)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'nameKeyField'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: basicsKey
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: nameKey
	      group: inputGroup
	      type: symbolOrNil
	      immediateAccept: false
	      acceptOnLeave: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Label:'
	      name: 'labelLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'labelField'
	      layout: (LayoutFrame 110 0 40 0 -5 1.0 62 0)
	      activeHelpKey: basicsLabel
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: rawLabel
	      group: inputGroup
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptOnLostFocus: false
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (CheckBoxSpec
	      label: 'Translate Label'
	      name: 'translateLabelCheckBox'
	      layout: (Point 20 213)
	      activeHelpKey: basicsTranslateLabel
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: translateLabel
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Is Button'
	      name: 'isButtonCheckBox'
	      layout: (Point 20 238)
	      activeHelpKey: basicsIsButton
	      visibilityChannel: notDelayedMenu
	      tabable: true
	      model: isButton
	      translateLabel: true
	    )
	   (CheckBoxSpec
	      label: 'Horizontal Layout'
	      name: 'horizontalLayout'
	      layout: (Point 20 263)
	      activeHelpKey: horizontalLayout
	      tabable: true
	      model: horizontalLayout
	      translateLabel: true
	    )
	   )

	)
      )
! !

!MenuEditor::RegularMenuItem methodsFor:'accessing'!

argument:aValue
    "/ ignorred.
!

menu:aMenu labeled:aString
    |expanded item menu|

    self criticalDo:[
	self isRootItem ifTrue:[ expanded := true ]
		       ifFalse:[ expanded := isExpanded ].

	self removeAll.
	self rawLabel:aString.

	menu := aMenu value.

	(menu isNil or:[menu isString]) ifTrue:[
	    menu := nil
	] ifFalse:[
	    aMenu isCollection ifTrue:[ menu := Menu decodeFromLiteralArray:aMenu ]
			      ifFalse:[ menu := aMenu ].

	    menu hasItems ifFalse:[
		menu := nil
	    ].
	].
	menu notNil ifTrue:[
	    isExpanded := false.        "/ discard change notifications
	    children   := OrderedCollection new.

	    menu itemsDo:[:el|
		item := self class menuItem:el.
		item parent:self.
		children add:item.
	    ].
	    expanded ifTrue:[ self expand ].
	].
	isExpanded := expanded.
    ].
    self changed

    "Modified: / 29-11-2011 / 11:28:33 / cg"
!

menuItem
    "returns self as a MenuItem
    "
    |item|

    item := super menuItem.
    item submenu:(self submenu).
  ^ item
!

menuItem:anItem

    super menuItem:anItem.
    self  menu:(anItem submenu) labeled:nil.
!

slices
    self isDelayedMenu ifTrue:[
	^ #(
		(Basics   basicsEditSpec )
	   )
    ].

    ^ #(
	    (Basics   basicsEditSpec )
	    (Details  detailsEditSpec)
	    (Image    image  )
	    (Help     help)
       )
!

submenu
    |menu|

    menu := Menu new.

    children size ~~ 0 ifTrue:[
	children do:[:el| menu addItem:(el menuItem) ].
    ].
    ^ menu
! !

!MenuEditor::RegularMenuItem methodsFor:'aspects'!

getDelayedAttributesFrom:aMenuItem

    |menu|

    menu := self validateValue:(aMenuItem submenu value).

    self menu:menu labeled:nil.
    menuItem horizontalLayout:(aMenuItem horizontalLayout).
!

setDelayedAttributesTo:aMenuItem
    aMenuItem          submenu:(self submenu).
    aMenuItem horizontalLayout:(menuItem horizontalLayout).
! !

!MenuEditor::RegularMenuItem methodsFor:'displaying'!

displayLabel
    "returns the label dependent on is delayed or not
    "
    self isDelayedMenu ifTrue:[ ^ self class defaultDelayedLabel ].
  ^ menuItem rawLabel
!

icon
    self isDelayedMenu ifTrue:[ ^ self class iconDelayedMenu ].
  ^ self class iconMenu
! !

!MenuEditor::RegularMenuItem methodsFor:'queries'!

canAddChildren
    "children can be added
    "
    ^ true
!

canExpand
    "returns true if the item is expandable
    "
    ^ isExpanded == false
!

hasIndicator
    ^ true
!

isKindOfMenu
    ^ true
!

isKindOfNonLinkedMenu
    ^ true
! !

!MenuEditor::RootItem class methodsFor:'defaults'!

defaultLabel
    ^ MenuEditor resourceType
! !

!MenuEditor::RootItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::RootItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: basicsEditSpec
	window:
       (WindowSpec
	  label: 'basicsEditSpec'
	  name: 'basicsEditSpec'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 260 46)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Selector:'
	      name: 'selectorLabel'
	      layout: (AlignmentOrigin 107 0 26 0 1 0.5)
	      activeHelpKey: basicsSelector
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'selectorField'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: basicsSelector
	      tabable: true
	      model: rawLabel
	      group: inputGroup
	      type: string
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   )

	)
      )
! !

!MenuEditor::RootItem class methodsFor:'interface-editor'!

addBindingsTo:aspects for:aMenuEditor
    "add additional bindings to the aspects
    "
! !

!MenuEditor::RootItem methodsFor:'accessing'!

menuItem:aMenuItem
    "rebuild self from a MenuItem
    "
    |submenu selector|

    aMenuItem notNil ifTrue:[
	submenu  := aMenuItem submenu.
	selector := aMenuItem rawLabel.
    ] ifFalse:[
	selector := submenu := nil.
    ].
    self menu:submenu labeled:selector.
!

rawLabel:aValue
    "set the label assigned to the item
    "
    |value|

    aValue isString ifTrue:[
	value := aValue withoutSeparators.

	(value notEmpty and:[value first isLetter]) ifTrue:[
	    menuItem rawLabel:(value asSymbol)
	].
    ].
!

slices
    ^ #(
	    (Basics   basicsEditSpec)
       )
! !

!MenuEditor::RootItem methodsFor:'adding & removing'!

remove
    "cannot remove the root item; delete all my children
    "
    self removeAll.
! !

!MenuEditor::RootItem methodsFor:'aspects'!

aspectAt:aKey put:aValue
    "ignore all aspects other than the rawLabel"

    aKey == #rawLabel ifTrue:[ self rawLabel:aValue ].

    "Modified: / 05-09-2006 / 17:48:01 / cg"
! !

!MenuEditor::RootItem methodsFor:'displaying'!

heightOn:aGC
    height isNil ifTrue:[ height := aGC font heightOn:aGC device ].
    ^ height
! !

!MenuEditor::RootItem methodsFor:'initialization'!

initialize
    super initialize.
    isExpanded := true.
! !

!MenuEditor::RootItem methodsFor:'queries'!

canCollapse
    ^ false
!

hasIndicator
    ^ false
!

isDelayedMenu
    ^ false
!

isRootItem
    ^ true
! !

!MenuEditor::RootItem methodsFor:'queries-editor'!

actionSelectors
    "return my action selectors"

    ^ #()
!

aspectSelectors
    "returns my aspect selectors
    "
    ^ #()
! !

!MenuEditor::RootItem methodsFor:'queries-operation'!

canMoveInAbove
    ^ false
!

canMoveInNext
    ^ false
!

canMoveOut
    ^ false
!

canMoveUpOrDown
   ^ false
! !

!MenuEditor::SeparatorItem class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MenuEditor::SeparatorItem andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: basicsEditSpec
	window:
       (WindowSpec
	  label: 'basicsEditSpec'
	  name: 'basicsEditSpec'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 260 245)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Separator:'
	      name: 'separatorLabel'
	      layout: (AlignmentOrigin 107 0 26 0 1 0.5)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (ComboListSpec
	      name: 'seperatorList'
	      layout: (LayoutFrame 110 0 15 0 -5 1.0 37 0)
	      activeHelpKey: basicsSeparatorType
	      tabable: true
	      model: seperatorSelection
	      comboList: seperatorList
	      useIndex: true
	    )
	   (LabelSpec
	      label: 'Visibility:'
	      name: 'visibilityLabel'
	      layout: (AlignmentOrigin 107 0 51 0 1 0.5)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'visibilityInputField'
	      layout: (LayoutFrame 110 0 40 0 -5 1.0 62 0)
	      activeHelpKey: detailsVisibility
	      tabable: true
	      model: isVisible
	      group: inputGroup
	      type: symbolOrBooleanOrNil
	      immediateAccept: false
	      acceptOnReturn: true
	      acceptOnTab: true
	      acceptChannel: acceptChannel
	      modifiedChannel: modifiedChannel
	      acceptOnPointerLeave: false
	    )
	   (LabelSpec
	      label: 'Start Group:'
	      name: 'startGroupLabel'
	      layout: (AlignmentOrigin 107 0 88 0 1 0.5)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: right
	    )
	   (PopUpListSpec
	      label: 'left'
	      name: 'startGroupPopUp'
	      layout: (LayoutFrame 110 0 77 0 -5 1.0 99 0)
	      activeHelpKey: detailsStartGroup
	      tabable: true
	      model: startGroup
	      menu: (left right conditionalRight)
	    )
	   )

	)
      )

    "Modified: / 16-10-2006 / 12:48:30 / cg"
! !

!MenuEditor::SeparatorItem class methodsFor:'interface-editor'!

addBindingsTo:aspects for:aMenuEditor
    "add additional bindings to the aspects
    "
    |holder|

    aspects
	at:#seperatorList
	ifAbsentPut:
	    [
		|l|

		l := self separatorSlices collect:[:el| el last ].
		l := l collect:[:s | self classResources string:s ].
		l
	    ].

    aspects at:#seperatorSelection ifAbsentPut:[
	holder := 0 asValue.
	holder addDependent:aMenuEditor.
	holder
    ].
!

defaultLabel
    ^ '-'
!

separatorSlices
    "get the list of menu spec values of the corresponding separator types
    "
    ^ #(
	( #blank        ''      'blank' )
	( #single       '-'     'single line')
	( #double       '='     'double line')
      )
! !

!MenuEditor::SeparatorItem methodsFor:'accessing'!

icon
    ^ self class iconSeparator
!

rawLabel:aValue
    |value|

    aValue isString ifTrue:[
	value := aValue withoutSeparators.

	(self class separatorTypeOf:value) notNil ifTrue:[
	    menuItem rawLabel:value
	]
    ].

    "Modified: / 29-11-2011 / 11:28:39 / cg"
!

separatorType
    ^ self class separatorTypeOf:(menuItem rawLabel).
!

slices
    ^ #(
	    (Basics   basicsEditSpec)
       )
! !

!MenuEditor::SeparatorItem methodsFor:'aspects'!

fromAspects:aspects
    "put my values into the values of aspects
    "
    |index slice|

    index  := (aspects at:#seperatorSelection) value ? 0.
    slice  := self class separatorSlices at:index ifAbsent:nil.

    slice notNil ifTrue:[ slice := slice at:2 ].

    (aspects at:#rawLabel) value:slice.
  ^ super fromAspects:aspects.

    "Modified: / 29-11-2011 / 11:28:36 / cg"
!

toAspects:aspects
    "put my values into the values of aspects
    "
    |index type|

    type   := self separatorType.
    index  := self class separatorSlices findFirst:[:el| el first == type ].

    (aspects at:#seperatorSelection) value:index.
  ^ super  toAspects:aspects.
! !

!MenuEditor::SeparatorItem methodsFor:'displaying'!

displayOn:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    "draw the receiver in the graphicsContext, aGC"

    |x1 y0 type|

    type := self separatorType.
    type == #blank ifTrue:[ ^ self ].

    x1 := x + (self widthOn:aGC).
    y0 := y + (h // 2) - 1.

    type == #double ifTrue:[
        y0 := y0 + 1.
        aGC displayLineFromX:x y:y0 toX:x1 y:y0.
        y0 := y0 - 2
    ].
    aGC displayLineFromX:x y:y0 toX:x1 y:y0
!

widthOn:aGC
    width isNil ifTrue:[ width := 60 ].
    ^ width
! !

!MenuEditor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MenuEditor initialize!
