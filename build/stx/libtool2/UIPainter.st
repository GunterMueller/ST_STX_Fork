"
 COPYRIGHT (c) 1995-1998 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ResourceSpecEditor subclass:#UIPainter
	instanceVariableNames:'specSuperclassName treeView selectionPanel specTool layoutTool
		helpTool painterView painter lastPort lastPage'
	classVariableNames:'SelectionPanelClass UseViewScroller LastPort LastPage
		DefaultEditToolBarVisible DefaultToolBarVisible'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

Query subclass:#ApplicationClassQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIPainter
!

SelectionInTreeView subclass:#TreeView
	instanceVariableNames:'lastDrawnMaster canvasEventsDisabled windowSpec windowSpecClass
		painter'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIPainter
!

!UIPainter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995-1998 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    The GUI Painter provides the user with a graphical user interface for building own 
    interfaces by interactively assembling widgets and defining the behavior of the widgets.
    The resulting interface specifications can be saved as methods on the application
    classes, typically subclasses of the class ApplicationModel. These specifications
    are used by the UIBuilder to generate the application window and its widgets when 
    opening the application.

    [start with:]
        UIPainter open

    [author:]
        Claus Gittinger, eXept Software AG
        Claus Atzkern, eXept Software AG
        Thomas Zwick, eXept Software AG

    [see also:]
        UIBuilder
        ApplicationModel
        UISpecification

    [instance variables:]                                                  
        isSpecOnlyPainter       true if this painter is for a spec only (as used by expecco),
                                as opposed to a regular painter, which stores the spec in a class.
                                A spec-only painter has no class to store additional specs (esp.
                                menu- and tabSpecs) and should not offer postBuild and other
                                callback functions.
"
! !

!UIPainter class methodsFor:'initialization'!

initialize
    SelectionPanelClass isNil ifTrue:[
        SelectionPanelClass := UISelectionPanel
    ].
! !

!UIPainter class methodsFor:'instance creation'!

openOnClass:aClass andSelector:aSelector
    "open a GUI Painter on aClass and (windowSpec) aSelector"

    ^ self new openOnClass:aClass theNonMetaclass andSelector:aSelector
! !

!UIPainter class methodsFor:'ST-80 queries'!

preferenceFor:aSymbol
    "ST-80 compatible; always returns false
    "
    ^ false


! !

!UIPainter class methodsFor:'defaults'!

defaultEditToolbarVisible
    ^ DefaultEditToolBarVisible ? true
!

defaultNameOfCanvas
    "returns the default name of the application"

    ^ 'NewApplication'
!

defaultToolbarVisible
    ^ DefaultToolBarVisible ? true
!

selectionPanelClass
    ^ SelectionPanelClass

    "
     UIPainter selectionPanelClass.
     UIPainter selectionPanelClass:UISelectionPanel
    "
!

selectionPanelClass:something
    "set the class used as selection panel.
     this is UISelectionPanel as default"

    SelectionPanelClass := something.

    "
     UIPainter selectionPanelClass:UISelectionPanel
    "
! !

!UIPainter class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec 
        addPairsFrom:#(

#fileSave
'Save Spec'

shadesOfRed
'Red color tones'

shadesOfGreen
'Green color tones'

shadesOfBlue
'Blue color tones'

shadesOfCyan
'Cyan color tones'

shadesOfMagenta
'Magenta color tones'

shadesOfYellow
'Yellow color tones'

shadesOfGray
'Gray color tones'

openColorEditor
'Open a color editor'

pickColorFromScreen
'Pick a color from the screen'

recentlyUsedColors
'Pick a recently used color'

useDefaultColorToggle
'Toggle between default and explicit color'

);
    declareAllFrom:self helpSpec
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UIPainter    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#align
'Widget alignment functions'

#alignResizeSelectionBottom
'Resize the selected widgets'' bottom edges to align them with the bottom of the dominant widget'

#alignResizeSelectionLeft
'Resize the selected widgets'' left edges to align them with the left edge of the dominant widget'

#alignResizeSelectionRight
'Resize the selected widgets'' right edges to align them with the right edge of the dominant widget'

#alignResizeSelectionTop
'Resize the selected widgets'' top edges to align them with the top edge of the dominant widget'

#alignSelectionBottom
'Aligns the selected widgets'' bottom edges with the bottom of the dominant widget'

#alignSelectionCenterHor
'Aligns the selected widgets'' centers vertically with the center of the dominant widget'

#alignSelectionCenterVer
'Aligns the selected widgets'' centers horizontally with the center of the dominant widget'

#alignSelectionLeft
'Aligns the selected widgets'' left edges with the left edge of the dominant widget'

#alignSelectionLeftAndRight
'Aligns the selected widgets'' left & right edges with the dominant widget'

#alignSelectionRight
'Aligns the selected widgets'' right edges with the right edge of the dominant widget'

#alignSelectionTop
'Aligns the selected widgets'' top edges with the top edge of the dominant widget'

#alignSelectionTopAndBottom
'Aligns the selected widgets'' top and bottom edges with the dominant widget'

#alignToGrid
'Am Raster ausrichten'

#centerSelectionHor
'Centers the selected widgets horizontally within their containing widget'

#centerSelectionVer
'Centers the selected widgets vertically within their containing widget'

#changePositionDown
'Moves the selected widget(s) towards the bottom (by %1 pixels)'

#changePositionLeft
'Moves the selected widget(s) towards the left (by %1 pixels)'

#changePositionRight
'Moves the selected widget(s) towards the right (by %1 pixels)'

#changePositionUp
'Moves the selected widget(s) towards the top (by %1 pixels)'

#'changeMoveDelta'
'Click to change the delta by which the buttons to the left move the selected widget(s)'

#drawEdit
''

#editBrowseViewClass
'Opens a browser on the class of the selected widget'

#editDimensionCopyExtent
'Copies the extent of the selected widget'

#editDimensionCopyLayout
'Copies the layout of the selected widget'

#editDimensionDefaultExtent
'Sets the selected widget(s) extent to their default'

#editDimensionDefaultHeight
'Sets the selected widget(s) height to their default'

#editDimensionDefaultWidth
'Sets the selected widget(s) width to their default'

#editDimensionPasteExtent
'Sets the extent of the selected widget(s) to the last copied extent'

#editDimensionPasteHeight
'Sets the height of the selected widget(s) to the height of the last copied layout/extent'

#editDimensionPasteLayout
'Sets the layout of the selected widget(s) to the last copied layout'

#editDimensionPasteWidth
'Sets the width of the selected widget(s) to the width of the last copied layout/extent'

#editInspectSpec
'Opens an inspector on the spec of the selected widget'

#editInspectView
'Opens an inspector on the selected widget'

#editOpenSpecDocumentation
'Opens the documentation of the selected widget'

#editSaveSpecForSelection
'Generate a sub-spec method for the selected element only.\Useful when refactoring an existing spec into sub specifications.'

#fileBrowseAspectMethods
'Opens a System Browser on the application''s aspect methods'

#fileBrowseClass
'Open a System Browser on the application''s class'

#fileLoad
'Opens a dialog to load a window specification from a classes spec method'

#fileLoadSubspec
'Opens a dialog to load a sub specification from a classes windowSpec method'

#fileNew
'Creates a new window spec'

#filePickAnInterface
'Select a view on the screen, generate a window spec for it and edit this spec'

#fileSave
'Saves the window spec in the current class (as spec method)'

#fileSaveAs
'Opens a dialog to select class and selector for saving the window spec'

#fileShowWindowSpec
'Opens a Workspace showing the current window spec'

#generateAspectMethods
'Generates aspect methods for defined aspect selectors of the widgets'

#generateHookMethods
'Generates startup/release methods. (#closeRequest, #postBuildWith:, #postOpenWith:)'

#helpExamples
'Show some examples uses of the GUI Painter'

#helpFunctions
'Show the documentation on the GUI Painters menu and button functions'

#helpLayoutTool
'Show the Layout Tools documentation'

#helpSelectedWidget
'Show the documentation of the selected widget'

#helpTutorial
'Show the GUI Painters documentation'

#historyMenuItem
'Edit this windowSpec'

#moveWidgetDown
'Moves the selected widget down in the list (brings it to the front)'

#moveWidgetInto
'Moves the selected widget into next widget as child widget'

#moveWidgetOut
'Moves the selected widget out of its parent widget'

#moveWidgetUp
'Moves the selected widget up in the list (brings it to the back)'

#openColorEditor
'Open a color editor'

#pasteBuffer
'Pastes the widgets of the clipboard at the current mouse position'

#pasteWithLayout
'Pastes the widgets of the clipboard without changing their layouts'

#pickColorFromScreen
'Pick a color from the screen'

#recentlyUsedColors
'Pick a recently used color'

#referToConfigDatabase
''

#settingsAspectsAsInstances
'Generate aspects as instance variables (or bindings, if off)'

#settingsCanvas
'Shows or hides the canvas window'

#settingsGallery
'Shows or hides the gallery window'

#settingsGenerateCommentedCode
'Enables/disables comments in the generated code, especially in aspect and hook methods'

#settingsGridManager
'Opens a dialog to toggle grid display or to change the grids spacing'

#settingsRedefineAspectMethods
'Toggles the permission to overwrite existing aspect methods'

#settingsTranscriptHelp
'Toggles display of help texts (after opening a new GUI Painter)'

#settingsUndoManager
'Opens a dialog to undo modifications'

#shadesOfBlue
'Blue color tones'

#shadesOfCyan
'Cyan color tones'

#shadesOfGray
'Gray color tones'

#shadesOfGreen
'Green color tones'

#shadesOfMagenta
'Magenta color tones'

#shadesOfRed
'Red color tones'

#shadesOfYellow
'Yellow color tones'

#showGrid
'Raster zeigen'

#sortItems
'Sort the selected items by position (left to right, top to bottom)'

#spreadSelectionHor
'Sets the horizontal spaces between the selected widgets to the same value'

#spreadSelectionVer
'Sets the vertical spaces between the selected widgets to the same value'

#testGeometryTestMode
'Toggles geometry test mode (to define ratios of variable panels and top-window dimension)'

#testStartApplication
'Starts the application with the current window spec'

#useDefaultColorToggle
'Toggle between default and explicit color'

#useDefaultFontToggle
'Toggle between default and explicit font'

#concreteFontsFamily
'Choose a font family'

#concreteFontsFace
'Choose a font face'

#concreteFontsStyle
'Choose a font style'

#concreteFontsSize
'Choose a font size (in points, not pixels)'


)
! !

!UIPainter class methodsFor:'helpers'!

convertString:aString maxLineSize:maxCharactersPerLine skipLineFeed:skipLineFeed
    "converts a string to a string collection with maximum characters
     per line
    "
    |stream
        max     "{ Class:SmallInteger }"
        size    "{ Class:SmallInteger }"
        start   "{ Class:SmallInteger }"
        stop    "{ Class:SmallInteger }"
        cpySz   "{ Class:SmallInteger }"
        lnSz    "{ Class:SmallInteger }"
        atBeginOfLine|

    maxCharactersPerLine < 20 ifFalse:[max := maxCharactersPerLine - 1]
                               ifTrue:[max := 20].

    (size := aString size) <= max ifTrue:[
        ^ aString
    ].
    start  := 1.
    lnSz   := 0.
    stream := (String new:size) writeStream.

    atBeginOfLine := true.

    [start <= size] whileTrue:[
        (start := aString indexOfNonSeparatorStartingAt:start) == 0 ifTrue:[
            ^ stream contents
        ].
        (aString at:start) == $\ ifTrue:[
            skipLineFeed ifFalse:[
                stream nextPut:$\
            ].
            start := start + 1.
            stream cr.
            start := start + 1.
            lnSz := 0.
        ] ifFalse:[
            (stop := aString indexOfSeparatorStartingAt:start) == 0 ifTrue:[
                stop := size + 1
            ].
            (aString at:(stop - 1)) == $\ ifTrue:[
                stop := stop - 1
            ].
            cpySz := stop - start.

            lnSz == 0 ifFalse:[
                (lnSz := lnSz + cpySz) >= max ifTrue:[stream cr.    lnSz := cpySz. atBeginOfLine := true. ]
                                             ifFalse:[stream space. lnSz := lnSz + 1]
            ] ifTrue:[
                lnSz := cpySz
            ].
            stream nextPutAll:aString startingAt:start to:(stop - 1).
            start := stop.
        ]
    ].
    ^ stream contents

    "Modified: / 1.2.1998 / 14:42:56 / cg"
! !

!UIPainter class methodsFor:'image specs'!

arrowDown
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self arrowDown inspect
     ImageEditor openOnClass:self andSelector:#arrowDown
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class arrowDown'
        ifAbsentPut:[
            (Depth1Image new)
                width:11;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'?>C?8O? ?>C@XNC <^C;8O? ?>C?8@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:11;
                            height:11;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@? A<@C @D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

arrowLeft
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self arrowLeft inspect
     ImageEditor openOnClass:self andSelector:#arrowLeft
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class arrowLeft'
        ifAbsentPut:[
            (Depth1Image new)
                width:11;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'?>C?8O7 >^C18NG <^C98O7 ?>C?8@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:11;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@H@A @N@A8@C PF@@H@@@@@@@@a');
                            yourself);
                yourself
        ]
!

arrowRight
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self arrowRight inspect
     ImageEditor openOnClass:self andSelector:#arrowRight
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class arrowRight'
        ifAbsentPut:[
            (Depth1Image new)
                width:11;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'?>C?8O_ <>C18OC <^C38O_ ?>C?8@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:11;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@ @C@@NA@<@C @L@@ @@@@@@@@a');
                            yourself);
                yourself
        ]
!

arrowUp
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self arrowUp inspect
     ImageEditor openOnClass:self andSelector:#arrowUp
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class arrowUp'
        ifAbsentPut:[
            (Depth1Image new)
                width:11;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'?>C?8O? >>C18NC 0FC?8O? ?>C?8@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:11;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@A@@NG1<@O8@@@@@@@@@@AP@a');
                            yourself);
                yourself
        ]
!

browseActionImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self browseActionImage inspect
     ImageEditor openOnClass:self andSelector:#browseActionImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class browseActionImage'
        ifAbsentPut:[
            (Depth8Image new)
                width:11;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
R@@@RT%RST1LTD9H@D%IT%MRSD1PS$!!RT$5RUEILT%INT%UVT%YWU%IVUUIHT%!!YV%-ZVU!!RWD!!MT%Y[@E-VT%5\RD1RU%,@V5YRWU1HT%!!YV%-ZVU!!RWEIU
U%IVU5YRU%URZ%IR@EITT ART&,@@@@@T%MR@@@@@@@@@@@@T @@@@@@');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 127 160 216 207 216 240 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 48 80 176 223 216 224 96 152 224 96 152 216 95 152 216 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 ];
                mask:((ImageMask new)
                            width:11;
                            height:12;
                            bits:(ByteArray fromPackedString:'A@@N@F;@?>A?0G>@O8A?0O? [,@N@@P@');
                            yourself);
                yourself
        ]
!

builderIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self builderIcon inspect
     ImageEditor openOnClass:self andSelector:#builderIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'UIPainter builderIcon'
        ifAbsentPut:[(Depth1Image width:48 height:48 photometric:#whiteIs0) bits:(ByteArray fromPackedString:'
@@@@@@@@O??????<H@@@@@@DH_@@@@@DH_@OC?>DH_@IC??$H_@IC??4H_@IC??$H_@IC?>DH_@F@J DH_@F@M DH_@F@J DH_@F@M DH_@F@J DH_@F@M D
H_@F@J DH_@F@M DH_@F@J DH_@F@M DH_@F@J DH_@_ M DH_@ PJ DH_@)PM DH_@)PJ DH_@)PM DH? )PJ DI?0)PM DK?8)PJ DK18)PM DK 8)PJ D
K@X)PM DK@X PG@DK@X_ @@DH@@@@@@DH@@@@@@DO??????<@@@@@@@@NDIHNG''@IDIHIDD H$IHH$DPIDIHH$DPNDIHH$D IDIHH''G@H$IHH$E@H$IHH$D 
IBQHIDDPNA!!ONG$P@@@@@@@@'); yourself]
!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary startUIPainterIcon

    "Created: / 10-02-2007 / 14:45:56 / cg"
    "Modified: / 17-09-2007 / 11:36:33 / cg"
!

delta
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self delta inspect
     ImageEditor openOnClass:self andSelector:#delta
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'UIPainter delta'
        ifAbsentPut:[(Depth1Image new) width:11; height:11; bits:(ByteArray fromPackedString:'?>C?8O? >>C@XLA 0VB;(H@ ?"C?8@@a') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:11; height:11; bits:(ByteArray fromPackedString:'
@@@@@@@@A@@J@AD@HHA@PG?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

editTableIcon
    <resource: #programImage>

    ^ SystemBrowser tableColumnsIcon
!

helpIcon
    <resource: #programImage>

    ^ Icon helpIcon
!

hideToolBarIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary hideToolBarIcon
!

iconAlignB
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignB inspect
     ImageEditor openOnClass:self andSelector:#iconAlignB
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignB'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E@@@@@@@G@@@@@@@G@E@@@@@G@G@@@@@G@G@@@@@G@G@@@E@G@G@@@G@G@G@K@G@G@G@@@G@G@G@A@G@G@G@@
@G@G@G@K@@@@@@@@B*****(@B*****(@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@G C@G @@G'' @G'' @G'' @G'' G'''' G'''' G'''' G''''!!G'''' G'''' G'''' G'''' O??0O??0@@@@@@@C@@@@');
                            yourself);
                yourself
        ]
!

iconAlignL
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignL inspect
     ImageEditor openOnClass:self andSelector:#iconAlignL
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignL'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@(@@@@@@@(@@@@@@@(UUUP@I@(_??0@@@(@@@@@@@(@@@@@@@(@@@@@@@(@@@@@@@(UUUU@@@(_???@@@(@@@@@E@(@@@@@@@(@@@@@@
@(@@@@@@@(UU@@@@@(_?@@@@@(@@@@@@@(@@@@@@@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@F@@@G?>@G?>@G?>@G?>@F@@@F@@@G?? G?? G?? G?? F@@@F@@@G? @G? @G? @G? @F@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconAlignLR
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignLR inspect
     ImageEditor openOnClass:self andSelector:#iconAlignLR
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignLR'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@(@@@B @@(@@@B @@(UUUR I@(_??2 @@(@@@B @@(@@@B @@(@@@B @@(@@@B @@(UUUR @@(_??2 @@(@@@B E@(@@@B @@(@@@B @
@(@@@B @@(UUUR @@(_??B @@(@@@B @@(@@@B @@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@F@A G?? G?? G?? G?? F@A F@A G?? G?? G?? G?? F@A F@A G?? G?? G?; G?? F@A @@@@@@@@');
                            yourself);
                yourself
        ]
!

iconAlignR
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignR inspect
     ImageEditor openOnClass:self andSelector:#iconAlignR
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignR'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@B @@@@@@B @@@UUUR I@@_??2 @@@@@@B @@@@@@B @@@@@@B @@@@@@B @@EUUUR @@G???2 @@@@@@B E@@@@@B @@@@@@B @
@@@@@B @@@@EUR @@@@G?2 @@@@@@B @@@@@@B @@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@A A?? A?? A?? A?? @@A @@A G?? G?? G?? G?? @@A @@A @G? @G? @G? @G? @@A @@@@@@@@');
                            yourself);
                yourself
        ]
!

iconAlignT
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignT inspect
     ImageEditor openOnClass:self andSelector:#iconAlignT
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignT'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@B*****(@B*****(@@@@@@@@@@E@E@E@K@G@G@G@@@G@G@G@A@G@G@G@@@G@G@G@K@G@G@G@@@@@G@G@@@@@G@G@@@@@G@G@@
@@@G@G@@@@@G@@@@@@@G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@C@@@@O??0O??0G'''' G'''' G'''' G'''' G''''!!G'''' G'''' G'''' @G'' @G'' @G'' @G'' @G @@G C@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconAlignTB
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconAlignTB inspect
     ImageEditor openOnClass:self andSelector:#iconAlignTB
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconAlignTB'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@A@@@@@@@@@@@@@@@@B*****(@B*****(@@@@@@@@@@E@E@E@G@G@G@G@@@G@G@G@@@G@G@G@@@G@G@G@H@G@G@G@@@G@G@G@A@G@G@G@@@G@G@G@@
@G@G@D@@@@@@@@@@B*****(@B*****(@@@@@@@@@@@@@@@@H@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@C@@@@O??0O??0G'''' G''''!!G'''' G'''' G'''' G'''' G'''' G'''' G''''!!G''''!!G''& G'''' O??0O??2@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconCenterH
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconCenterH inspect
     ImageEditor openOnClass:self andSelector:#iconCenterH
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconCenterH'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@(@J@B @@(@J@B @@(UZUR @@(?:?R @@(@J@B @@(@J@B @@(@J@B @@@@J@@@@@EUZUU@@@O?:?=@@@@@J@@@@@(@J@B @@(@J@B @
@(@J@B @@(EZUB@@@(O:=B @@(@J@B @@(@J@B @@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@C@@A?>@A?>@A?>@A?>@@C@@@C@@G?? G?? G?? G??#@C@@@C@C@?<@@?<A@?<@@?<@@C@@@@@A@@@@');
                            yourself);
                yourself
        ]
!

iconCenterHInFrame
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconCenterHInFrame inspect
     ImageEditor openOnClass:self andSelector:#iconCenterHInFrame
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconCenterHInFrame'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@J******@H@@@@@B@HL@@@CB@H8UUUR2@HH???RB@H8@@@B2@HH@@@BB@H8@@@B2@H@@@@@B@HEUUUUB@HO???=B@H@@@@@B@H8@@@@2@HH@@@@B@
H8@@@@2@HHEUUBB@H8O?=B2@HL@@@CB@H@@@@@B@J******@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_??8P@@HW??(U?>(U?>(U?>(T@@(T@@(W??(W??(W??(W??+T@@(T@@+T?<(T?<)T?<(W??(P@@H_??9@@@@');
                            yourself);
                yourself
        ]
!

iconCenterV
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconCenterV inspect
     ImageEditor openOnClass:self andSelector:#iconCenterV
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconCenterV'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@B**@J*(@B**MJ*(@@@@M@@@@@@@M@M@@@M@M@M@@@M@M@M@@@M@M@M@@B*****(@B*****(@@M@M@M@@@M@M@M@@@E@M@M@@
@@@M@E@@@@@M@@@@B**EJ*(@B(*@J*(@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@G @@G @@G'' G''''!!G'''' G'''' G'''' O??0O??0G'''' G'''' G'''' G'''' @G''#@G @@G C@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconCenterVInFrame
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconCenterVInFrame inspect
     ImageEditor openOnClass:self andSelector:#iconCenterVInFrame
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconCenterVInFrame'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@J******@H@@@@@B@HL3@L3B@H:*GJ*2@H@@G@@B@HG@G@@B@HG@G@GB@HG@G@GB@HG@G@GB@HG@G@GB@HG@G@GB@HG@G@GB@HG@G@GB@HG@G@EB@
HE@G@@B@H@@G@@B@H:*E@J2@HL3@L3B@H@@@@@B@J******@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@B_??9P@@HW??(TG (W'' (W''''*W''''(W''''*W'''')W''''(W'''')W''''+W''''*W''''*W''''(W'' )TG (W??(P@@H_??8@@@@');
                            yourself);
                yourself
        ]
!

iconDistributeH
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconDistributeH inspect
     ImageEditor openOnClass:self andSelector:#iconDistributeH
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconDistributeH'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E@@E@@E@G@@G@@G@G@@G@@G@GHBGHBG@GHBGHBG@GJ*GJ*G@GHBGHBG@GHBGHBG@GB*GJ G@GB*GJ G@
G@@G@@G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@<G <<G <<G ?<G =>O1?>O1????<>O1<>O1><G <<G ><G <<G ?@@@A@@@@@@@@@@@@@@@A');
                            yourself);
                yourself
        ]
!

iconDistributeV
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconDistributeV inspect
     ImageEditor openOnClass:self andSelector:#iconDistributeV
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconDistributeV'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@UUUT@@@@???4@@@@@@@@@@@@@*(@@@@@JB@@@@@@JB@@@@@@JB@@@@@@J*(@@@@@@@@@@@@@UUUT@@@@???4@@@@@@@@@@@@J*(@@@@@JB@@@@
@@JB@@@@@@@B@@@@@@@*(@@@@@@@@@@@@@UUUT@@@@???4@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'A??@A??@A??CA??@@G0@@A@@@A@@@A@@@G0CA??@A??@A??@A??@@G0C@A@@@A@@@A@@@G0AA??AA??@A??@A??B');
                            yourself);
                yourself
        ]
!

iconResizeB
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeB inspect
     ImageEditor openOnClass:self andSelector:#iconResizeB
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeB'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M@@@@@@@M@@@@@@@M@M@@@@@M@M@@@@@M@M@@@@@M@M@@@M@M@M@@@M@M@M@@@M@M@M@@@M@M@M@@@@@@@M@@
@@@@@E@@@@@@@@@@B*****(@B*****(@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@G A@G @@G'' @G'' @G''#@G'' G''''"G'''' G''''!!G'''' G'''' O?7 G'''' CCG O??0O??0@@@A@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconResizeL
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeL inspect
     ImageEditor openOnClass:self andSelector:#iconResizeL
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeL'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@(@@@@@@@(@@@@@@@(UUUP@I@(_??0@@@(@@@@@@@(@@@@@@@(@@@@@@@(@@@@@@@(AUUU@@@(C???@@@(@@@@@E@(@@@@@@@(@@@@@@
@(@@@@@@@(AU@@@@@(C?@@@@@(@@@@@@@(@@@@@@@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@F@@@G?>@G?>@G?>@G?>@F@@@FP@@F?? G?? G?? F?? FP@@FP@@F? @G? @G? @F? @FP@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconResizeLR
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeLR inspect
     ImageEditor openOnClass:self andSelector:#iconResizeLR
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeLR'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@(@@@B @@(@@@B @@(UUUR I@(???2 @@(@@@B @@(@@@B @@(@@@B @@(@@@B @@(AUTB @@(C?<B @@(@@@B E@(@@@B @@(@@@B @
@(@@@B @@(AUTB @@(C?<B @@(@@@B @@(@@@B @@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@F@A G?? G?? G?? G?? F@A FPI F?= G?? G?? F?= FPI FPI F?= G?? G?? F?= FPI @@@@@@@@');
                            yourself);
                yourself
        ]
!

iconResizeR
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeR inspect
     ImageEditor openOnClass:self andSelector:#iconResizeR
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeR'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@B @@@@@@B @@@UUUR I@@???R @@@@@@B @@@@@@B @@@@@@B @@@@@@B @@EUUTB @@O??<B @@@@@@B E@@@@@B @@@@@@B @
@@@@@B @@@@ETB @@@@O<B @@@@@@B @@@@@@B @@@@@@@@E@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@A A?? A?? A?? A?? @@A @@I G?= G?? G?? G?= @@I @@I @G= @G? @G? @G= @@I @@@@@@@@');
                            yourself);
                yourself
        ]
!

iconResizeT
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeT inspect
     ImageEditor openOnClass:self andSelector:#iconResizeT
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeT'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@B*****(@B*****(@@@@@@@@@@@@@@E@@@@@@@M@@@M@M@M@@@M@M@M@@@M@M@M@@@M@M@M@@@@@M@M@@@@@M@M@@@@@M@M@@
@@@M@M@@@@@M@@@@@@@M@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@AO??0O??0CCG G'''' O?7 G'''' G'''' G''''!!G'''' G''''"@G'' @G''#@G'' @G'' @G @@G A@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconResizeTB
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconResizeTB inspect
     ImageEditor openOnClass:self andSelector:#iconResizeTB
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UIPainter class iconResizeTB'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@B*****(@B*****(@@@@@@@@@@G@@@@@@@G@@@@@@@G@G@G@@@G@G@G@@@G@G@G@@@G@G@G@@@G@G@G@@@G@G@G@@@G@@@@@@
@G@@@@@@@@@@@@@@B*****(@B*****(@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@B@@@@@@@BO??0O??2G#C@G'''' G/?0G''''#G'''' G'''' G'''' G'''' G''''"G/?0G'''' G#C@O??1O??0@@@A@@@B@@@@');
                            yourself);
                yourself
        ]
! !

!UIPainter class methodsFor:'interface specs'!

dialogSpecForDefiningClassAndSelector
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIPainter andSelector:#dialogSpecForDefiningClassAndSelector
     UIPainter new openInterface:#dialogSpecForDefiningClassAndSelector
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'GUI Painter'
              #layout: #(#LayoutFrame 291 0 130 0 637 0 289 0)
              #label: 'GUI Painter'
              #min: #(#Point 350 160)
              #bounds: #(#Rectangle 291 130 638 290)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#FramedBoxSpec
                    #name: 'FramedBox'
                    #layout: #(#LayoutFrame 0 0.0 3 0.0 0 1.0 -35 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#LabelSpec
                              #name: 'selectorLabel'
                              #layout: #(#AlignmentOrigin 67 0.11 29 0 1 0.5)
                              #label: 'Selector:'
                              #translateLabel: true
                              #adjust: #right
                              #resizeForLabel: true
                          )
                           #(#InputFieldSpec
                              #name: 'methodNameField'
                              #layout: #(#LayoutFrame 70 0.11 18 0 4 1.0 40 0)
                              #tabable: true
                              #model: #methodNameChannel
                              #group: #inputGroup
                          )
                           #(#LabelSpec
                              #name: 'classLabel'
                              #layout: #(#AlignmentOrigin 67 0.11 54 0 1 0.5)
                              #label: 'Class:'
                              #translateLabel: true
                              #adjust: #right
                              #resizeForLabel: true
                          )
                           #(#InputFieldSpec
                              #name: 'classNameField'
                              #layout: #(#LayoutFrame 70 0.11 43 0 4 1.0 65 0)
                              #tabable: true
                              #model: #classNameChannel
                              #group: #inputGroup
                          )
                           #(#LabelSpec
                              #name: 'superClassLabel'
                              #layout: #(#AlignmentOrigin 67 0.11 79 0 1 0.5)
                              #label: 'Superclass:'
                              #translateLabel: true
                              #adjust: #right
                              #resizeForLabel: true
                          )
                           #(#ComboBoxSpec
                              #name: 'superclassNameComboBox'
                              #layout: #(#LayoutFrame 70 0.11 68 0 4 1.0 90 0)
                              #tabable: true
                              #model: #superclassNameChannel
                              #comboList: #superclassNameDefaults
                          )
                        )
                    )
                    #label: 'Define Class And Selector'
                    #labelPosition: #topLeft
                    #translateLabel: true
                )
                 #(#UISubSpecification
                    #name: 'subSpec'
                    #layout: #(#LayoutFrame 0 0.0 -29 1 0 1.0 -5 1)
                    #majorKey: #ToolApplicationModel
                    #minorKey: #windowSpecForCommitWithoutChannels
                )
              )
          )
      )

    "Modified: / 13.8.1998 / 19:59:44 / cg"
!

dialogSpecForDefiningGridParameters
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIPainter andSelector:#dialogSpecForDefiningGridParameters
     UIPainter new openInterface:#dialogSpecForDefiningGridParameters
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpecForDefiningGridParameters
        window: 
       (WindowSpec
          label: 'GUI Painter'
          name: 'GUI Painter'
          min: (Point 300 200)
          max: (Point 300 200)
          bounds: (Rectangle 16 46 298 244)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Grid Parameter'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 3 0.0 0 1.0 -35 1.0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (CheckBoxSpec
                    label: 'Show Grid'
                    name: 'ShowGridCheckBox'
                    layout: (Point 13 14)
                    model: showGrid
                    translateLabel: true
            activeHelpKey: showGrid
                  )
                 (CheckBoxSpec
                    label: 'Align To Grid'
                    name: 'AlignCheckBox'
                    layout: (Point 13 42)
                    model: alignToGrid
                    translateLabel: true
            activeHelpKey: alignToGrid
                  )
                 (LabelSpec
                    label: 'Horizontal Pixels:'
                    name: 'HorizontalPixelsLabel'
                    layout: (AlignmentOrigin 138 0 89 0 1 0.5)
                    translateLabel: true
                    resizeForLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'HorizontalPixelsField'
                    layout: (LayoutFrame 144 0 77 0 197 0 99 0)
                    model: hspace
                    group: inputGroup
                    type: numberOrNil
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Vertical Pixels:'
                    name: 'VerticalPixelsLabel'
                    layout: (AlignmentOrigin 139 0 114 0 1 0.5)
                    translateLabel: true
                    resizeForLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'VerticalPixelsField'
                    layout: (LayoutFrame 144 0 102 0 197 0 124 0)
                    model: vspace
                    group: inputGroup
                    type: numberOrNil
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           (UISubSpecification
              name: 'subSpec'
              layout: (LayoutFrame 0 0.0 -29 1 0 1.0 -5 1)
              majorKey: ToolApplicationModel
              minorKey: windowSpecForCommitWithoutChannels
            )
           )
         
        )
      )
!

dialogSpecForDefiningPortAndPageName
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIPainter andSelector:#dialogSpecForDefiningPortAndPageName
     UIPainter new openInterface:#dialogSpecForDefiningPortAndPageName
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpecForDefiningPortAndPageName
        window: 
       (WindowSpec
          label: 'GUI Painter'
          name: 'GUI Painter'
          min: (Point 350 140)
          max: (Point 500 140)
          bounds: (Rectangle 0 0 346 138)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Define Service and Pagename'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 3 0.0 0 1.0 -34 1.0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Service (or Port):'
                    name: 'portLabel'
                    layout: (AlignmentOrigin 67 0.11 29 0 1 0.5)
                    translateLabel: true
                    resizeForLabel: true
                    adjust: right
                  )
                 (ComboBoxSpec
                    name: 'ComboBox1'
                    layout: (LayoutFrame 70 0.11 18 0 4 1.0 40 0)
                    model: serviceOrPortNameChannel
                    acceptOnPointerLeave: false
                    comboList: runningServerPorts
                  )
                 (LabelSpec
                    label: 'Pagename:'
                    name: 'pageNameLabel'
                    layout: (AlignmentOrigin 67 0.11 54 0 1 0.5)
                    translateLabel: true
                    resizeForLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'pageNameNameField'
                    layout: (LayoutFrame 70 0.11 43 0 4 1.0 65 0)
                    tabable: true
                    model: pageNameNameChannel
                    group: inputGroup
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           (UISubSpecification
              name: 'subSpec'
              layout: (LayoutFrame 0 0.0 -29 1 0 1.0 -5 1)
              majorKey: ToolApplicationModel
              minorKey: windowSpecForCommitWithoutChannels
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIPainter andSelector:#windowSpec
     UIPainter new openInterface:#windowSpec
     UIPainter open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'GUI Painter'
          name: 'GUI Painter'
          min: (Point 560 460)
          bounds: (Rectangle 0 0 834 575)
          menu: menu
          icon: defaultIcon
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'mainPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 -24 1)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'ToolBar'
                    layout: (LayoutFrame 0 0 0 0 0 1 32 0)
                    visibilityChannel: toolBarVisibleHolder
                    component: 
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'hideToolBarIcon'
                          name: 'HideToolBarButton'
                          layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                          activeHelpKey: hideToolBar
                          hasCharacterOrientedLabel: false
                          translateLabel: true
                          model: hideToolbar
                          postBuildCallback: hideToolBarButtonCreated:
                        )
                       (MenuPanelSpec
                          name: 'menuToolbarView'
                          layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: toolBarVisibleHolder
                          menu: menuToolbar
                          textDefault: true
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'EditToolBar'
                    layout: (LayoutFrame 0 0 30 0 0 1 62 0)
                    visibilityChannel: editToolBarVisibleHolder
                    component: 
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'hideToolBarIcon'
                          name: 'HideEditToolBarButton'
                          layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                          activeHelpKey: hideToolBar
                          hasCharacterOrientedLabel: false
                          translateLabel: true
                          model: hideEditToolbar
                          postBuildCallback: hideToolBarButtonCreated:
                        )
                       (MenuPanelSpec
                          name: 'EditToolBar1'
                          layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: editToolBarVisibleHolder
                          menu: editToolbar
                          textDefault: true
                        )
                       )
                     
                    )
                  )
                 (VariableHorizontalPanelSpec
                    name: 'Painter'
                    layout: (LayoutFrame 0 0.0 60 0.0 0 1.0 0 1.0)
                    level: 1
                    component: 
                   (SpecCollection
                      collection: (
                       (ArbitraryComponentSpec
                          name: 'treeView'
                          tabable: true
                          menu: menuEdit
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          miniScrollerVertical: true
                          hasBorder: false
                          component: treeView
                        )
                       (ViewSpec
                          name: 'specHolderView'
                          level: 0
                          component: 
                         (SpecCollection
                            collection: (
                             (MenuPanelSpec
                                name: 'menuToolbar2View'
                                layout: (LayoutFrame 2 0.0 2 0 -2 1.0 32 0)
                                level: 0
                                tabable: true
                                menu: menuToolbar2
                              )
                             (NoteBookViewSpec
                                name: 'noteBook'
                                layout: (LayoutFrame 2 0.0 32 0.0 -2 1.0 -28 1.0)
                                level: 0
                                enableChannel: enableChannel
                                tabable: true
                                model: tabModel
                                menu: tabList
                                translateLabel: true
                                canvas: noteBookView
                              )
                             (HorizontalPanelViewSpec
                                name: 'HorizontalPanel1'
                                layout: (LayoutFrame 2 0 -26 1 -2 1 -2 1)
                                horizontalLayout: fit
                                verticalLayout: fit
                                horizontalSpace: 3
                                verticalSpace: 3
                                reverseOrderIfOKAtLeft: true
                                component: 
                               (SpecCollection
                                  collection: (
                                   (ActionButtonSpec
                                      label: 'Cancel'
                                      name: 'cancelButton'
                                      activeHelpKey: commitCancel
                                      translateLabel: true
                                      tabable: true
                                      model: cancel
                                      enableChannel: modifiedChannel
                                      extent: (Point 274 24)
                                    )
                                   (ActionButtonSpec
                                      label: 'OK'
                                      name: 'acceptButton'
                                      activeHelpKey: commitOK
                                      translateLabel: true
                                      tabable: true
                                      model: accept
                                      enableChannel: modifiedChannel
                                      extent: (Point 274 24)
                                    )
                                   )
                                 
                                )
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    handles: (Any 0.3 1.0)
                  )
                 )
               
              )
            )
           (UISubSpecification
              name: 'infoBarSubSpec'
              layout: (LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
              level: 1
              majorKey: ToolApplicationModel
              minorKey: windowSpecForInfoBar
            )
           )
         
        )
      )
! !

!UIPainter class methodsFor:'menu specs'!

cutCopyPasteMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(UIPainter menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: editCut
            enabled: canCutHolder
            label: 'Cut'
            itemValue: deleteSelection
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary cutWidgetIcon)
          )
         (MenuItem
            activeHelpKey: editCopy
            enabled: canCopyHolder
            label: 'Copy'
            itemValue: copySelection
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary copyWidgetIcon)
          )
         (MenuItem
            activeHelpKey: editPaste
            enabled: canPasteKeepingLayoutHolder
            label: 'Paste with Layout'
            itemValue: pasteWithLayout
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary pasteWidgetIcon)
          )
         (MenuItem
            activeHelpKey: editDelete
            enabled: canCutHolder
            label: 'Delete'
            itemValue: deleteTotalSelection
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteWidgetIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editUndo
            enabled: hasUndoHistoryHolder
            label: 'Undo'
            itemValue: undoLast
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary undoIcon)
          )
         )
        nil
        nil
      )
!

editToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#editToolbar
     (Menu new fromLiteralArrayEncoding:(UIPainter editToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'moveItems'
            translateLabel: true
            submenuChannel: moveInListMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'gridItems'
            translateLabel: true
            submenuChannel: gridMenuSlice
            isMenuSlice: true
          )
         )
        nil
        nil
      )
!

gridMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Workflow::WorksheetEditor andSelector:#zoomMenuSlice
     (Menu new fromLiteralArrayEncoding:(Workflow::WorksheetEditor zoomMenuSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'ShowGrid'
            translateLabel: true
            isButton: true
            indication: gridShownHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary gridIcon)
            activeHelpKey: showGrid
          )
         (MenuItem
            label: 'AlignToGrid'
            translateLabel: true
            isButton: true
            indication: alignToGridHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary gridAlignIcon)
            activeHelpKey: alignToGrid
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
     MenuEditor new openOnClass:UIPainter andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(UIPainter menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: '&File'
            translateLabel: true
            submenuChannel: menuFile
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Edit'
            translateLabel: true
            submenuChannel: menuEdit
          )
         (MenuItem
            label: 'View'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: settingsCanvas
                  label: 'Canvas'
                  translateLabel: true
                  indication: painterShown
                )
               (MenuItem
                  activeHelpKey: settingsGallery
                  label: 'Gallery'
                  translateLabel: true
                  indication: galleryShown
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Toolbar'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: toolBarVisibleHolder
                )
               (MenuItem
                  label: 'Editor Toolbar'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: editToolBarVisibleHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Load Sketch as Background...'
                  itemValue: useSketch
                  translateLabel: true
                )
               (MenuItem
                  label: 'Load Image as Background...'
                  itemValue: useBackgroundImage
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Align'
            translateLabel: true
            submenuChannel: menuAlign
          )
         (MenuItem
            label: 'Generate'
            translateLabel: true
            isVisible: isNotEditingSpecOnly
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: generateAspectMethods
                  enabled: hasSpecClass
                  label: 'Aspect Methods'
                  itemValue: doGenerateAspectMethods
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: generateAspectMethodFor
                  enabled: hasSpecClass
                  label: 'Aspect Method For...'
                  itemValue: doGenerateAspectMethodFor
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSpecClass
                  label: 'Menu Stub Methods'
                  itemValue: doGenerateMenuMethods
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: generateHookMethods
                  enabled: hasSpecClass
                  label: 'Hook Methods'
                  itemValue: doGenerateHookMethods
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Test'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: testStartApplication
                  label: 'Start Application'
                  itemValue: doStartApplication
                  translateLabel: true
                  isVisible: isNotEditingSpecOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: isNotEditingSpecOnly
                )
               (MenuItem
                  activeHelpKey: testGeometryTestMode
                  label: 'Geometry Test/Set Mode'
                  translateLabel: true
                  indication: testMode:
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Settings'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: settingsAspectsAsInstances
                  label: 'Aspects as InstanceVariables'
                  translateLabel: true
                  isVisible: isNotEditingSpecOnly
                  indication: generateAspectsAsInstanceVariables:
                )
               (MenuItem
                  activeHelpKey: settingsRedefineAspectMethods
                  label: 'Redefine Aspect Methods'
                  translateLabel: true
                  isVisible: isNotEditingSpecOnly
                  indication: redefineAspectMethods:
                )
               (MenuItem
                  activeHelpKey: settingsGenerateCommentedCode
                  label: 'Generate Commented Code'
                  translateLabel: true
                  isVisible: isNotEditingSpecOnly
                  indication: generateCommentedCode:
                )
               (MenuItem
                  label: 'AutoAccept on Selection-Change '
                  translateLabel: true
                  indication: autoAcceptOnSelectionChange
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: settingsUndoManager
                  enabled: hasUndoHistory
                  label: 'Undo Manager...'
                  itemValue: openUndoMenu
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: settingsGridManager
                  label: 'Grid Manager...'
                  itemValue: doDefineGrid
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'History'
            translateLabel: true
            isVisible: isStandAlone
            submenuChannel: menuHistory
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: helpTutorial
                  label: 'Tutorial'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/uipainter/TOP.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: helpFunctions
                  label: 'Functions'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/uipainter/Functions.html'
                )
               (MenuItem
                  activeHelpKey: helpExamples
                  label: 'Examples'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/uipainter/Examples.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: helpHelpTool
                  label: 'Help Tool'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/uipainter/HelpTool.html'
                )
               (MenuItem
                  activeHelpKey: helpLayoutTool
                  label: 'Layout Tool'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/uipainter/LayoutTool.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: helpSelectedWidget
                  label: 'Selected Widget'
                  itemValue: doOpenWidgetDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: helpShowHelp
                  label: 'Show Help Texts'
                  translateLabel: true
                  indication: showingHelp:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: aboutThisAppliaction
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

menuAlign
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuAlign
     (Menu new fromLiteralArrayEncoding:(UIPainter menuAlign)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: alignSelectionLeft
            enabled: canMoveOrAlignSelection
            label: 'Left'
            itemValue: alignSelectionLeft
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconAlignL 'Left')
          )
         (MenuItem
            activeHelpKey: alignSelectionRight
            enabled: canMoveOrAlignSelection
            label: 'Right'
            itemValue: alignSelectionRight
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconAlignR 'Right')
          )
         (MenuItem
            activeHelpKey: alignSelectionTop
            enabled: canMoveOrAlignSelection
            label: 'Top'
            itemValue: alignSelectionTop
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconAlignT 'Top')
          )
         (MenuItem
            activeHelpKey: alignSelectionBottom
            enabled: canMoveOrAlignSelection
            label: 'Bottom'
            itemValue: alignSelectionBottom
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconAlignB 'Bottom')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: alignResizeSelectionLeft
            enabled: canMoveOrAlignSelection
            label: 'Resize Left'
            itemValue: alignResizeSelectionLeft
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeL 'Resize Left')
          )
         (MenuItem
            activeHelpKey: alignResizeSelectionRight
            enabled: canMoveOrAlignSelection
            label: 'Resize Right'
            itemValue: alignResizeSelectionRight
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeR 'Resize Right')
          )
         (MenuItem
            activeHelpKey: alignResizeSelectionTop
            enabled: canMoveOrAlignSelection
            label: 'Resize Top'
            itemValue: alignResizeSelectionTop
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeT 'Resize Top')
          )
         (MenuItem
            activeHelpKey: alignResizeSelectionBottom
            enabled: canMoveOrAlignSelection
            label: 'Resize Bottom'
            itemValue: alignResizeSelectionBottom
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeB 'Resize Bottom')
          )
         (MenuItem
            activeHelpKey: alignSelectionLeftAndRight
            enabled: canResizeSelection
            label: 'Left && Right'
            itemValue: alignSelectionLeftAndRight
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeLR 'Left && Right')
          )
         (MenuItem
            activeHelpKey: alignSelectionTopAndBottom
            enabled: canResizeSelection
            label: 'Top && Bottom'
            itemValue: alignSelectionTopAndBottom
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconResizeTB 'Top && Bottom')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: alignSelectionCenterHor
            enabled: canMoveOrAlignSelection
            label: 'Center Horizontal'
            itemValue: alignSelectionCenterHor
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconCenterH 'Center Horizontal')
          )
         (MenuItem
            activeHelpKey: centerSelectionHor
            enabled: canMoveOrAlignSelection
            label: 'Center Horizontal in Frame'
            itemValue: centerSelectionHor
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconCenterHInFrame 'Center Horizontal in Frame')
          )
         (MenuItem
            activeHelpKey: alignSelectionCenterVer
            enabled: canMoveOrAlignSelection
            label: 'Center Vertical'
            itemValue: alignSelectionCenterVer
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconCenterV 'Center Vertical')
          )
         (MenuItem
            activeHelpKey: centerSelectionVer
            enabled: canMoveOrAlignSelection
            label: 'Center Vertical in Frame'
            itemValue: centerSelectionVer
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconCenterVInFrame 'Center Vertical in Frame')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: spreadSelectionHor
            enabled: canMoveOrAlignSelection
            label: 'Distribute Horizontal'
            itemValue: spreadSelectionHor
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconDistributeH 'Distribute Horizontal')
          )
         (MenuItem
            activeHelpKey: spreadSelectionVer
            enabled: canMoveOrAlignSelection
            label: 'Distribute Vertical'
            itemValue: spreadSelectionVer
            translateLabel: true
            labelImage: (ResourceRetriever UIPainter iconDistributeV 'Distribute Vertical')
          )
         )
        nil
        nil
      )
!

menuEdit
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuEdit
     (Menu new fromLiteralArrayEncoding:(UIPainter menuEdit)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: editUndo
            enabled: hasUndoHistory
            label: 'Undo'
            itemValue: undoLast
            nameKey: undo
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editCut
            enabled: canCutHolder
            label: 'Cut'
            itemValue: deleteSelection
          )
         (MenuItem
            activeHelpKey: editCopy
            enabled: canCopyHolder
            label: 'Copy'
            itemValue: copySelection
          )
         (MenuItem
            activeHelpKey: editPaste
            enabled: canPasteHolder
            label: 'Paste'
            itemValue: pasteBuffer
          )
         (MenuItem
            activeHelpKey: pasteWithLayout
            enabled: canPasteKeepingLayoutHolder
            label: 'Paste with Layout'
            itemValue: pasteWithLayout
          )
         (MenuItem
            activeHelpKey: editPaste
            enabled: canPasteKeepingLayoutHolder
            label: 'Paste Keeping Absolute Position'
            itemValue: pasteKeepingPosition
          )
         (MenuItem
            activeHelpKey: editDelete
            enabled: canCutHolder
            label: 'Delete'
            itemValue: deleteTotalSelection
          )
         (MenuItem
            activeHelpKey: replaceBy
            enabled: canReplaceSelection
            label: 'Replace By...'
            itemValue: doAskAndReplaceWidgetBy
          )
         (MenuItem
            activeHelpKey: wrapInto
            enabled: canWrapSelection
            label: 'Wrap Into...'
            itemValue: doAskAndWrapWidgetInto
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canMoveSelection
            label: 'Move'
            submenuChannel: menuMove
          )
         (MenuItem
            enabled: canMoveOrAlignSelection
            label: 'Align'
            submenuChannel: menuAlign
          )
         (MenuItem
            enabled: hasSelection
            label: 'Dimension'
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: editDimensionCopyLayout
                  enabled: hasSingleSelection
                  label: 'Copy Layout'
                  itemValue: copyLayout
                )
               (MenuItem
                  activeHelpKey: editDimensionPasteLayout
                  enabled: canMoveOrAlignSelection
                  label: 'Paste Layout'
                  itemValue: pasteLayout
                )
               (MenuItem
                  activeHelpKey: editDimensionExchangeLayouts
                  enabled: canExchangeSelectionLayouts
                  label: 'Exchange Layouts'
                  itemValue: exchangeLayouts
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: editDimensionCopyExtent
                  enabled: hasSingleSelection
                  label: 'Copy Extent'
                  itemValue: copyExtent
                )
               (MenuItem
                  activeHelpKey: editDimensionPasteExtent
                  enabled: canMoveOrAlignSelection
                  label: 'Paste Extent'
                  itemValue: pasteExtent
                )
               (MenuItem
                  activeHelpKey: editDimensionPasteWidth
                  enabled: canMoveOrAlignSelection
                  label: 'Paste Width'
                  itemValue: pasteWidth
                )
               (MenuItem
                  activeHelpKey: editDimensionPasteHeight
                  enabled: canMoveOrAlignSelection
                  label: 'Paste Height'
                  itemValue: pasteHeight
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: editDimensionDefaultExtent
                  enabled: canMoveOrAlignSelection
                  label: 'Set Default Extent'
                  itemValue: setToDefaultExtent
                )
               (MenuItem
                  activeHelpKey: editDimensionDefaultWidth
                  enabled: canMoveOrAlignSelection
                  label: 'Set Default Width'
                  itemValue: setToDefaultWidth
                )
               (MenuItem
                  activeHelpKey: editDimensionDefaultHeight
                  enabled: canMoveOrAlignSelection
                  label: 'Set Default Height'
                  itemValue: setToDefaultHeight
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editOpenSpecDocumentation
            label: 'Open Widget Documentation'
            itemValue: doOpenWidgetDocumentation
            enabled: hasOneSelectionOtherThanCanvas
          )
         (MenuItem
            activeHelpKey: referToConfigDatabase
            label: 'Refer to Config Database'
            itemValue: configSelection
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            activeHelpKey: drawEdit
            label: 'Draw Edit'
            itemValue: shapeEdit
            isVisible: false
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: sortItems
            label: 'Sort Selected Items by Position'
            itemValue: doSortItems
            enabled: hasMultipleSelectionOtherThanCanvas
          )
         (MenuItem
            activeHelpKey: groupWithLayout
            enabled: canGroup
            label: 'Group with Layout'
            itemValue: groupWithLayout
          )
         (MenuItem
            activeHelpKey: ungroup
            enabled: canUngroup
            label: 'Ungroup'
            itemValue: ungroup
          )
         (MenuItem
            activeHelpKey: ungroupWithLayout
            enabled: canUngroup
            label: 'Ungroup with Layout'
            itemValue: ungroupWithLayout
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editBrowseViewClass
            enabled: hasOneSelectionOtherThanCanvas
            label: 'Browse Widget Class'
            itemValue: doBrowseViewClass
          )
         (MenuItem
            activeHelpKey: editInspectView
            enabled: hasOneSelectionOtherThanCanvas
            label: 'Inspect Widget'
            itemValue: doInspectView
          )
         (MenuItem
            activeHelpKey: editBrowseViewClass
            label: 'Browse Specification Class'
            itemValue: doBrowseSpecificationClass
            enabled: hasOneSelectionOtherThanCanvas
          )
         (MenuItem
            activeHelpKey: editInspectSpec
            label: 'Inspect Spec'
            itemValue: doInspectSpec
            enabled: hasOneSelectionOtherThanCanvas
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editSaveSpecForSelection
            enabled: hasOneSelectionOtherThanCanvas
            label: 'Save Spec of Selection...'
            itemValue: doSaveElementSpecAs
          )
         )
        nil
        nil
      )
!

menuFile
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuFile
     (Menu new fromLiteralArrayEncoding:(UIPainter menuFile)) startUp
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
                  isVisible: isStandAlone
                )
               (MenuItem
                  label: '-'
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: fileLoad
                  label: 'Load...'
                  itemValue: doLoad
                  translateLabel: true
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: fileLoadSubspec
                  label: 'Load Subspec...'
                  itemValue: doLoadSubspec
                  translateLabel: true
                  isVisible: isStandAlone
                )
               (MenuItem
                  label: '-'
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: fileSave
                  label: 'Save'
                  itemValue: doSave
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: fileSaveAs
                  label: 'Save As...'
                  itemValue: doSaveAs
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileSaveAs
                  label: 'Define Class and Selector...'
                  itemValue: doDefineClassAndSelector
                  translateLabel: true
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: filePickAnInterface
                  label: 'Pick a Window Spec...'
                  itemValue: doPickAView
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Launch'
                  itemValue: doStartApplication
                  translateLabel: true
                )
               (MenuItem
                  enabled: canInstallAsWebPageHolder
                  label: 'Install as WebPage'
                  itemValue: doInstallAsWebPage
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileShowWindowSpec
                  label: 'Show Window Spec'
                  itemValue: doWindowSpec
                  translateLabel: true
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: fileBrowseClass
                  enabled: hasSpecClass
                  label: 'Browse Applications Class'
                  itemValue: doBrowseClass
                  translateLabel: true
                  isVisible: isStandAlone
                )
               (MenuItem
                  activeHelpKey: fileBrowseAspectMethods
                  enabled: hasSpecClass
                  label: 'Browse Applications Aspect Methods'
                  itemValue: doBrowseAspectMethods
                  translateLabel: true
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

menuMove
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuMove
     (Menu new fromLiteralArrayEncoding:(UIPainter menuMove)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Up'
                #translateLabel: true
                #value: #doStepUp
                #activeHelpKey: #moveWidgetUp
                #enabled: #canChangeOrderInContainer
                #labelImage: #(#ResourceRetriever #Icon #upIcon 'Up')
            )
             #(#MenuItem
                #label: 'Down'
                #translateLabel: true
                #value: #doStepDown
                #activeHelpKey: #moveWidgetDown
                #enabled: #canChangeOrderInContainer
                #labelImage: #(#ResourceRetriever #Icon #downIcon 'Down')
            )
             #(#MenuItem
                #label: 'Into'
                #translateLabel: true
                #value: #doStepIn
                #activeHelpKey: #moveWidgetInto
                #enabled: #canMoveSelectionIntoContainer
                #labelImage: #(#ResourceRetriever #Icon #downRightIcon 'Into')
            )
             #(#MenuItem
                #label: 'Out'
                #translateLabel: true
                #value: #doStepOut
                #activeHelpKey: #moveWidgetOut
                #enabled: #canMoveSelectionOutOfContainer
                #labelImage: #(#ResourceRetriever #Icon #leftDownIcon 'Out')
            )
          ) nil
          nil
      )
!

menuReplaceWidget
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuReplaceWidget
     (Menu new fromLiteralArrayEncoding:(UIPainter menuReplaceWidget)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: replaceBy
            enabled: canChangeOrderInContainer
            label: 'Replace By...'
            itemValue: doAskAndReplaceWidgetBy
            translateLabel: true
          )
         )
        nil
        nil
      )
!

menuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(UIPainter menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: testStartApplication
            label: 'Start'
            itemValue: doStartApplication
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary start22x22Icon)
          )
         (MenuItem
            enabled: canInstallAsWebPageHolder
            label: 'Install as WebPage'
            itemValue: doInstallAsWebPage
            translateLabel: true
            isButton: true
            isVisible: installAsWebPageVisible
            labelImage: (ResourceRetriever XPToolbarIconLibrary installAsWebPage24x24Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileNew
            label: 'New'
            itemValue: doNew
            translateLabel: true
            isButton: true
            isVisible: isStandAlone
            labelImage: (ResourceRetriever ToolbarIconLibrary newWindowSpecIcon)
          )
         (MenuItem
            label: '-'
            isVisible: isStandAlone
          )
         (MenuItem
            activeHelpKey: fileLoad
            label: 'Load'
            itemValue: doLoad
            translateLabel: true
            isButton: true
            isVisible: isStandAlone
            labelImage: (ResourceRetriever ToolbarIconLibrary loadFromMethodIcon)
          )
         (MenuItem
            activeHelpKey: fileSave
            label: 'Save'
            itemValue: doSave
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveAsMethodIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'CutCopyPaste'
            translateLabel: true
            submenuChannel: cutCopyPasteMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
            startGroup: right
          )
         (MenuItem
            activeHelpKey: settingsCanvas
            label: 'Canvas'
            translateLabel: true
            indication: painterShown
          )
         (MenuItem
            activeHelpKey: settingsGallery
            label: 'Gallery'
            translateLabel: true
            indication: galleryShown
          )
         )
        nil
        nil
      )
!

menuToolbar2
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:UIPainter andSelector:#menuToolbar2
     (Menu new fromLiteralArrayEncoding:(UIPainter menuToolbar2)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: alignSelectionLeft
            enabled: canMoveOrAlignSelection
            label: 'Align Left'
            itemValue: alignSelectionLeft
            isButton: true
            labelImage: (ResourceRetriever nil iconAlignL)
          )
         (MenuItem
            activeHelpKey: alignSelectionRight
            enabled: canMoveOrAlignSelection
            label: 'Align Right'
            itemValue: alignSelectionRight
            isButton: true
            labelImage: (ResourceRetriever nil iconAlignR)
          )
         (MenuItem
            activeHelpKey: alignSelectionTop
            enabled: canMoveOrAlignSelection
            label: 'Align Top'
            itemValue: alignSelectionTop
            isButton: true
            labelImage: (ResourceRetriever nil iconAlignT)
          )
         (MenuItem
            activeHelpKey: alignSelectionBottom
            enabled: canMoveOrAlignSelection
            label: 'Align Bottom'
            itemValue: alignSelectionBottom
            isButton: true
            labelImage: (ResourceRetriever nil iconAlignB)
          )
         (MenuItem
            activeHelpKey: alignSelectionLeftAndRight
            enabled: canResizeSelection
            label: 'Align Left & Right'
            itemValue: alignSelectionLeftAndRight
            isButton: true
            labelImage: (ResourceRetriever nil iconResizeLR)
          )
         (MenuItem
            activeHelpKey: alignSelectionTopAndBottom
            enabled: canResizeSelection
            label: 'Align Top & Bottom'
            itemValue: alignSelectionTopAndBottom
            isButton: true
            labelImage: (ResourceRetriever nil iconResizeTB)
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: changePositionLeft
            enabled: canMoveOrAlignSelection
            label: 'Move Left'
            itemValue: moveSelectionLeft
            isButton: true
            hideMenuOnActivated: false
            triggerOnDown: true
            labelImage: (ResourceRetriever nil arrowLeft)
          )
         (MenuItem
            activeHelpKey: changePositionRight
            enabled: canMoveOrAlignSelection
            label: 'Move Right'
            itemValue: moveSelectionRight
            isButton: true
            hideMenuOnActivated: false
            triggerOnDown: true
            labelImage: (ResourceRetriever nil arrowRight)
          )
         (MenuItem
            activeHelpKey: changePositionUp
            enabled: canMoveOrAlignSelection
            label: 'Move Up'
            itemValue: moveSelectionUp
            isButton: true
            hideMenuOnActivated: false
            triggerOnDown: true
            labelImage: (ResourceRetriever nil arrowUp)
          )
         (MenuItem
            activeHelpKey: changePositionDown
            enabled: canMoveOrAlignSelection
            label: 'Move Down'
            itemValue: moveSelectionDown
            isButton: true
            hideMenuOnActivated: false
            triggerOnDown: true
            labelImage: (ResourceRetriever nil arrowDown)
          )
         (MenuItem
            activeHelpKey: changeMoveDelta
            label: 'Move by'
            nameKey: MoveByMenu
            isButton: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: '1'
                  itemValue: setMoveByStep:
                  argument: 1
                )
               (MenuItem
                  label: '5'
                  itemValue: setMoveByStep:
                  argument: 5
                )
               (MenuItem
                  label: '10'
                  itemValue: setMoveByStep:
                  argument: 10
                )
               (MenuItem
                  label: '24'
                  itemValue: setMoveByStep:
                  argument: 24
                )
               (MenuItem
                  label: '30'
                  itemValue: setMoveByStep:
                  argument: 30
                )
               (MenuItem
                  label: '100'
                  itemValue: setMoveByStep:
                  argument: 100
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Enter Value...'
                  itemValue: askForMoveByStep
                )
               )
              nil
              nil
            )
            labelImage: (ResourceRetriever UIPainter delta)
          )
         (MenuItem
            activeHelpKey: editOpenSpecDocumentation
            label: 'Widget Documentation'
            itemValue: doOpenWidgetDocumentation
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever Icon helpIcon)
          )
         )
        nil
        nil
      )
!

moveInListMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:UIPainter andSelector:#editToolbar
     (Menu new fromLiteralArrayEncoding:(UIPainter editToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: moveWidgetUp
            enabled: canChangeOrderInContainer
            label: 'Move Up'
            itemValue: doStepUp
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetUpIcon)
          )
         (MenuItem
            activeHelpKey: moveWidgetDown
            enabled: canChangeOrderInContainer
            label: 'Move Down'
            itemValue: doStepDown
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownIcon)
          )
         (MenuItem
            activeHelpKey: moveWidgetInto
            enabled: canMoveSelectionIntoContainer
            label: 'Move Into'
            itemValue: doStepIn
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownRightIcon)
          )
         (MenuItem
            activeHelpKey: moveWidgetOut
            enabled: canMoveSelectionOutOfContainer
            label: 'Move Out'
            itemValue: doStepOut
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetLeftDownIcon)
          )
         )
        nil
        nil
      )
! !

!UIPainter class methodsFor:'private class access'!

applicationClassQuery
    ^ ApplicationClassQuery
! !

!UIPainter methodsFor:'aspects'!

alignToGridHolder
    |holder|

    (holder := builder bindingAt:#alignToGridHolder) isNil ifTrue:[
        holder := (self class settings at: #GridAlign ifAbsent: [painter gridAlign]) asValue.
        builder aspectAt:#alignToGridHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder
!

aspectFor:aKey
    "returns the aspect for aKey or nil"

    ^ aspects at:aKey ifAbsent:[ super aspectFor:aKey ]
!

canChangeOrderInContainer
    "returns a boolean value holder which is true if the widget order can be changed 
     within their container"

    ^ builder booleanValueAspectFor:#canChangeOrderInContainer
!

canExchangeSelectionLayouts
    "returns a boolean value holder which is true in case that the selection 
     consists of exactly 2 components
     and all widgets in the selection can change its layout through to a move or
     align operation"

    ^ builder booleanValueAspectFor:#canExchangeSelectionLayouts
!

canInstallAsWebPage
    ^ specClass notNil
       and:[ specClass isSubclassOf:WebApplicationModel ]

    "Created: / 14-01-2008 / 17:34:56 / cg"
!

canInstallAsWebPageHolder
    ^ builder 
            valueAspectFor:#canInstallAsWebPageHolder
            initialValue:(self canInstallAsWebPage).

    "Created: / 14-01-2008 / 17:36:04 / cg"
!

canMoveOrAlignSelection
    "returns a boolean value holder which is true in case that any selection exists
     and all widgets in the selection can change their layout through to a move or
     align operation"

    ^ builder booleanValueAspectFor:#canMoveOrAlignSelection
!

canMoveSelection
    "true if move-in/move-out/move-up and down are enabled"

    treeView hasOneSelectionOtherThanCanvas ifFalse:[^ false].
    ^ self canChangeOrderInContainer value 
     or: [ self canMoveSelectionOutOfContainer value 
     or: [ self canMoveSelectionIntoContainer value ]]
!

canMoveSelectionIntoContainer
    "returns true in case that at least one widget is selected and can change its container
     widget to an element below"

    ^ builder booleanValueAspectFor:#canMoveSelectionIntoContainer
!

canMoveSelectionOutOfContainer
    "returns a boolean value holder which is true in case that at least one widget is selected
     which is contained within another component"

    ^ builder booleanValueAspectFor:#canMoveSelectionOutOfContainer
!

canPasteHolder

    |holder|
    (holder := builder bindingAt:#canPasteHolder) isNil ifTrue:[
        holder := [ self canPaste ].
    ].
    ^ holder
!

canPasteKeepingLayoutHolder
    ^ self canPasteHolder
!

canReplaceSelection
    treeView hasOneSelectionOtherThanCanvas ifFalse:[^ false].
    ^ true
!

canResizeSelection
    "returns a boolean value holder which is true in case that any selection exists
     and all widgets in the selection can be resized"

    ^ builder booleanValueAspectFor:#canResizeSelection
!

canWrapSelection
    treeView hasOneSelectionOtherThanCanvas ifFalse:[^ false].
    ^ true
!

editToolBarVisibleHolder
    |holder|

    (holder := builder bindingAt:#editToolBarVisibleHolder) isNil ifTrue:[
        holder := self class defaultEditToolbarVisible asValue.
        builder aspectAt:#editToolBarVisibleHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder
!

enableChannel
    "true if modifications are allowed otherwise in test mode"

    ^ builder valueAspectFor:#enableChannel initialValue:true
!

enableChannel2
    "true if modifications are allowed otherwise running test"

    ^ self painter enableChannel
!

galleryShown
    "returns a boolean value holder which is set to true if the gallery is shown"

    |holder|

    (holder := builder bindingAt:#galleryShown) isNil ifTrue:[
        builder aspectAt:#galleryShown put:(holder :=  true asValue).
        holder addDependent:self
    ].
    ^ holder

!

gridShownHolder
    |holder|

    (holder := builder bindingAt:#gridShownHolder) isNil ifTrue:[
        holder := (self class settings at: #GridShown ifAbsent: [painter gridShown]) asValue.
        builder aspectAt:#gridShownHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder
!

hasMultipleSelectionOtherThanCanvas
    "returns a value holder which is true in case that multiple widget other than the root are selected"

    ^ builder booleanValueAspectFor:#hasMultipleSelectionOtherThanCanvas
!

hasOneSelectionOtherThanCanvas
    "returns a value holder which is true in case that one widget is selected
     other than the root"

    ^ builder booleanValueAspectFor:#hasOneSelectionOtherThanCanvas
!

hasSelectionOtherThanCanvas
    "returns a value holder which is true in case that any widget other than the root is selected"

    ^ builder booleanValueAspectFor:#hasSelectionOtherThanCanvas
!

hasUndoHistory
    ^ self painter hasUndoHistory
!

hasUndoHistoryHolder
    ^ self painter hasUndoHistoryHolder
!

installAsWebPageVisible
    ^ true

    "Created: / 14-01-2008 / 17:46:05 / cg"
!

noteBookView
    "returns the notebook view; initialize the tools embedded in the notebook"

    |noteBook|

    (noteBook := builder bindingAt:#noteBookView) isNil ifTrue:[
        noteBook := View new.
        builder aspectAt:#noteBookView put:noteBook.

        layoutTool := self createToolApplication:UILayoutTool        spec:#windowSpec in:noteBook.
        helpTool   := self createToolApplication:UIHelpTool          spec:#innerSpec  in:noteBook.
        specTool   := self createToolApplication:UISpecificationTool spec:#windowSpec in:noteBook.

        helpTool loadFromClass:specClass.
    ].
    ^ noteBook

    "Modified: / 31-08-2006 / 10:11:15 / cg"
!

painterShown
    "returns a boolean value holder which is set to true if the painter is shown"

    |holder|

    (holder := builder bindingAt:#painterShown) isNil ifTrue:[
        builder aspectAt:#painterShown put:(holder :=  true asValue).
        holder addDependent:self
    ].
    ^ holder

!

tabList
    "returns a value holder which keeps a list of the section labels in the notebook"

    |tabs holder|

    (holder := builder bindingAt:#tabList) isNil ifTrue:[
        tabs := #(Basics Details Layout).
        builder aspectAt:#tabList put:(holder :=  (resources array:tabs) asValue).
    ].
    ^ holder
!

tabModel
    "returns a value holder which keeps the label of the current section in the notebook"

    |holder|

    (holder := builder bindingAt:#tabModel) isNil ifTrue:[
        holder := AspectAdaptor new subject:self; forAspect:#tabSelection.
        builder aspectAt:#tabModel put:holder.
    ].
    ^ holder
!

toolBarVisibleHolder
    |holder|

    (holder := builder bindingAt:#toolBarVisibleHolder) isNil ifTrue:[
        holder := self class defaultToolbarVisible asValue.
        builder aspectAt:#toolBarVisibleHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder
!

treeView
    "returns the tree view which holds all widget"

    ^ treeView
!

valueOfCanPasteWithKeepingLayout
    <resource: #obsolete>
    self obsoleteMethodWarning:'stupid name - use #canPasteKeepingLayoutHolder'.
    ^ self canPasteKeepingLayoutHolder
! !

!UIPainter methodsFor:'building editors'!

XXopenDataSetColumnEditor
    "opens a Table Column Editor on current widget"

    |cls editor specTool columnHolder tableSelector columns isEditingSpecOnly|

    isEditingSpecOnly := self isEditingSpecOnly.

    isEditingSpecOnly ifFalse:[
        (cls := self resolveName:specClassName) isNil ifTrue:[
            self askForSaving ifTrue:[cls := self resolveName:specClassName].
        ].
        cls isNil ifTrue:[^ self].
    ].

    self acceptOrIgnoreSectionModification.

    editor   := DataSetBuilder new.
    editor masterApplication:self.
    specTool := self specTool.

    isEditingSpecOnly ifFalse:[
        editor specClass: cls.
        editor rowClassName:(specTool specification rowClassName).
    ].
    columnHolder  := specTool aspectFor:#columnHolder.
    tableSelector := columnHolder value.

    tableSelector := tableSelector notEmptyOrNil 
                        ifTrue:[tableSelector asSymbol]
                        ifFalse:[nil].

    (isEditingSpecOnly not
    and:[tableSelector notNil 
    and:[cls class includesSelector:tableSelector]]) ifTrue:[
        editor openModalOnClass:cls andSelector:tableSelector
    ] ifFalse:[
        editor editingSpecOnly:true.

        columns := specTool specification columns.
        columns size ~~ 0 ifTrue:[
            editor openModalOnResourceSpec:columns
        ] ifFalse:[
            editor openModal
        ].
    ].

    isEditingSpecOnly ifFalse:[
        editor hasSaved ifTrue:[
            specTool specification 
                columns:nil;
                rowClassName:(editor rowClassName).

            tableSelector = editor specSelector ifFalse:[
                columnHolder value:(editor specSelector).
                self accept.
            ].
            ^ self
        ].
    ].

    tableSelector isNil ifTrue:[
        editor hasSaved ifTrue:[
            editor modified ifFalse:[
                specTool specification 
                    columns:(editor acceptedColumns);
                    rowClassName:(editor rowClassName).
                self modifiedChannel value:true.
            ].
        ].
    ].

    "Modified: / 12-01-2008 / 10:31:47 / cg"
!

openDataSetColumnEditor
    "opens a Table Column Editor on current widget"

    |cls editor specTool columnHolder tableSelector columns isEditingSpecOnly|

    self isModified ifTrue:[
        "/ force editFields to accept
        self acceptChannel value:true; value:false.
    ].

    specTool := self specTool.
    columnHolder := specTool aspectFor:#columnHolder.
    tableSelector := columnHolder value.

    tableSelector notEmptyOrNil ifTrue:[
        tableSelector := tableSelector asSymbol.
    ] ifFalse:[
        tableSelector := nil.
    ].

    isEditingSpecOnly := true.

    (tableSelector notNil and:[self isEditingSpecOnly not]) ifTrue:[
        (cls := self resolveName:specClassName) notNil ifTrue:[
            isEditingSpecOnly := false.
        ].
    ].
    editor := DataSetBuilder new.
    editor masterApplication:self.

    isEditingSpecOnly ifFalse:[
        editor specClass:cls.
        editor rowClassName:(specTool specification rowClassName).
    ].

    isEditingSpecOnly ifFalse:[
        editor openModalOnClass:cls andSelector:tableSelector.

        editor hasSaved ifTrue:[
            specTool specification 
                columns:nil;
                rowClassName:(editor rowClassName).

            tableSelector = editor specSelector ifFalse:[
                columnHolder value:(editor specSelector).
                self accept.
            ].
        ].
        ^ self
    ].

    editor editingSpecOnly:true.

    columns := specTool specification columns.

    columns size ~~ 0 ifTrue:[
        editor openModalOnResourceSpec:columns
    ] ifFalse:[
        editor openModal
    ].

    editor hasSaved ifTrue:[
        columnHolder value:nil.

        specTool specification 
            columns:(editor acceptedColumns);
            rowClassName:(editor rowClassName).

        columnHolder value:nil.
        self modifiedChannel value:true.
    ].
!

openEditMenu
    "opens a Menu Editor on current widget for the standard menu
     (accessed via #menu or #menuSelector)"

    ^ self
        openEditMenuFor:#menu
        and:#menuSelector
!

openEditMenuFor:menuSelector and:menuSelectorSelector
    "opens a Menu Editor on the current widget.
     The arguments menuSelector (typically: #menu) 
     and menuSelectorSelector (typically: #menuSelector) can be passed in
     for widgets with a secondary menu (with different selectors)"

    |cls selectorOrMenu editor selectedSpec windowSpec holder|

    self isEditingSpecOnly ifFalse:[
        "/ normal mode
        (cls := self resolveName:specClassName) isNil ifTrue:[
            self askForSaving ifTrue:[cls := self resolveName:specClassName].
        ].
        cls isNil ifTrue:[^ self].
    ].

    self acceptOrIgnoreSectionModification.
    windowSpec := self specTool specification.

    self isEditingSpecOnly ifTrue:[
        selectorOrMenu := windowSpec perform:menuSelector
    ] ifFalse:[
        (selectorOrMenu := (windowSpec perform:menuSelectorSelector)) notNil ifTrue:[
            selectorOrMenu := selectorOrMenu asSymbol
        ] ifFalse:[
            "/ cg: q&d hack ...
            selectorOrMenu := nil.

            (selectedSpec := treeView propertySelected) notNil ifTrue:[
                Error handle:[:ex |
                    selectorOrMenu := nil.
                ] do:[
                    selectorOrMenu := selectedSpec view asMenu.
                ]
            ].
        ].
    ].

    editor := MenuEditor new.
    editor masterApplication:self.
    self isEditingSpecOnly ifFalse:[
        editor specClass: cls.
        editor useHelpTool:(self helpTool).
    ].

    (self isEditingSpecOnly or:[selectorOrMenu class == Menu]) ifTrue: [
        editor openModalOnMenu:(selectorOrMenu).
        editor hasSaved ifTrue:[
            windowSpec perform:menuSelector asMutator with:(editor savedSpec).
            self accept.
        ].
    ] ifFalse: [
        editor openModalOnClass:cls andSelector:selectorOrMenu.
        editor hasSaved ifTrue:[
            holder := self specTool aspectFor:menuSelector.
            holder value:(editor specSelector).
            self accept.
        ].
    ].

    "Modified: / 12-01-2008 / 10:31:41 / cg"
!

openHierarchicalListEditor
    "opens a Hierarchical List Editor on current widget"

    |selector editor spec|

    (self resolveName:specClassName) isNil ifTrue:[
        self askForSaving ifFalse: [^self]
    ].

    spec := self specTool specification.
    (selector := spec hierarchicalList) notNil ifTrue:[
        selector := selector asSymbol
    ].

    editor := HierarchicalListEditor new.
    editor masterApplication:self.
    editor openModalOnClass:specClassName andSelector:selector.

    editor specSelector ~= selector ifTrue:[
        editor hasSaved ifTrue:[
            spec hierarchicalList:editor specSelector.
            self modifiedChannel value:true.
            self accept
        ]
    ]

    "Modified: / 16.7.1998 / 18:15:46 / cg"
!

openSubSpecBrowser
    "opens a browser on the current subspecification"

    self withSpecClassAndSelectorDo:[:cls :sel |
        cls theMetaclass browse:sel.
    ].
!

openSubSpecGUIPainter
    "opens a GUI Painter on the current subspecification"

    self withSpecClassAndSelectorDo:[:cls :sel |
        self class 
            openOnClass:cls theMetaclass soleInstance 
            andSelector:sel.
    ].        

    "Modified: / 5.11.2001 / 16:51:46 / cg"
!

openTabListEditor
    "opens a Tab List Editor on current widget"

    |selector editor spec cls holder|

    (cls := self resolveName:specClassName) isNil ifTrue:[
        self askForSaving ifTrue:[cls := self resolveName:specClassName].
    ].
    cls isNil ifTrue:[^ self].

    self acceptOrIgnoreSectionModification.
    spec := self specTool specification.

    (selector := spec listSelector) isArray 
        ifTrue: [^self warn: 'Cannot open the Tab List Editor on an array!!'].

    editor := TabListEditor new.
    editor masterApplication:self.
    editor openModalOnClass:cls andSelector:selector.

    editor hasSaved ifTrue:[
        holder := self specTool aspectFor:#listSelector.

        holder value ~= editor specSelector ifTrue:[
            holder value:editor specSelector.
            self accept.
        ]
    ].

    "Modified: / 12-01-2008 / 10:31:34 / cg"
!

withSpecClassAndSelectorDo:aTwoArgBlock
    "helper for open GUI Painter/open Browser on the current subspecification"

    |spec cls meta sel|

    (self resolveName:specClassName) isNil ifTrue:[
        self askForSaving ifFalse: [^self]
    ]. 

    spec := self specTool specification.
    cls := spec majorKey.
    cls isNil ifTrue:[
        cls := specClassName.
    ].
    (cls := self resolveName:cls inClass:(Smalltalk at: specClassName asSymbol)) isNil ifTrue:[
        spec majorKey isNil ifTrue:[
            ^ self warn:'Cannot find class (no majorKey specified).'.
        ].
        ^ self warn:('Cannot find class ', spec majorKey allBold, '.').
    ].
    sel := spec minorKey.
    meta := cls class whichClassIncludesSelector:sel.
    meta isNil ifTrue:[
        ^ self warn:'Cannot find selector #', (sel ? '') allBold, ' in class ', cls name allBold, '!!'
    ].

    aTwoArgBlock value:meta value:spec minorKey.
! !

!UIPainter methodsFor:'change & update'!

layoutChanged
    "called by the painter/canvas whenever the layout of the current selected
     widget has changed"

    self isModified ifFalse:[
        self layoutTool update.
        self clearModifiedFlag
    ]
!

propertyChanged
    "called by the painter/canvas whenever the property of the current selected
     widget has changed"

    |property spec|

    (property := treeView propertySelected) notNil ifTrue:[
        spec := property spec copy.
        self specTool specification:spec.
        self setViewInLayoutTool:(property view) spec:spec.
        self clearModifiedFlag
    ] ifFalse:[
        self layoutTool layoutView notNil ifTrue:[
            self clearModifiedFlag.
            self treeSelectionChanged
        ]
    ]
!

toolBarVisibilityChanged
    |toolBarVisible editToolBarVisible toolBar editToolBar noteBook topOffset|

    topOffset := 0.

    toolBar := self componentAt:#ToolBar.
    toolBar notNil ifTrue:[
        toolBarVisible := self toolBarVisibleHolder value.
        DefaultToolBarVisible := toolBarVisible.
        toolBarVisible ifTrue:[
            topOffset := topOffset + toolBar height.
        ]
    ].

    editToolBar := self componentAt:#EditToolBar.
    editToolBar notNil ifTrue:[
        editToolBar layout 
            topOffset:topOffset bottomOffset:(topOffset + editToolBar height).
        "/ force it to recompute its dimension
        editToolBar container notNil ifTrue:[
            editToolBar containerChangedSize.
        ].
        editToolBarVisible := self editToolBarVisibleHolder value.
        DefaultEditToolBarVisible := editToolBarVisible.
        editToolBarVisible ifTrue:[
            topOffset := topOffset + editToolBar height.
        ]
    ].

    noteBook := self componentAt:#Painter.
    noteBook notNil ifTrue:[
        noteBook layout topOffset:topOffset.
        "/ force it to recompute its dimension
        noteBook container notNil ifTrue:[
            noteBook containerChangedSize.
        ].
    ].

    "Created: / 18-02-2007 / 14:46:22 / cg"
!

update:something with:aParameter from:changedObject
    "catches change notifications"

    |window lbl|

    ((changedObject == self toolBarVisibleHolder)
    or:[ changedObject == self editToolBarVisibleHolder ]) ifTrue:[
        self toolBarVisibilityChanged.
        ^ self
    ].
    changedObject == self gridShownHolder ifTrue:[
        self class settings at: #GridShown  put: changedObject value.
        painter gridShown:changedObject value.
        ^ self
    ].
    changedObject == self alignToGridHolder ifTrue:[
        self class settings at: #GridAlign  put: changedObject value.
        painter gridAlign:changedObject value.
        ^ self
    ].

    changedObject == treeView model ifTrue:[
        (something == #selection
        or:[something == #selectionIndex]) ifTrue:[self treeSelectionChanged].
        ^ self
    ].

    changedObject == self galleryShown ifTrue:[
        "/ galleryShown toggle changed
        window := selectionPanel window.
        (changedObject value) ifTrue:[
            self raiseUIView:window
        ] ifFalse:[
            self hideUIView:window
        ].
        ^ self
    ].

    changedObject == self painterShown ifTrue:[
        "/ canvasShown toggle changed
        window := self painter topView.
        (changedObject value) ifTrue:[
            self raiseUIView:window
        ] ifFalse:[
            self hideUIView:window
        ].
        ^ self
    ].

    changedObject == self autoAcceptOnSelectionChange ifTrue:[
        lbl := changedObject value ifTrue:['Apply'] ifFalse:['OK'].
        (builder componentAt:'acceptButton') label:(resources string:lbl).
        ^ self
    ].

    "Modified: / 16.7.1998 / 19:09:57 / cg"
!

updateChannels
    "updates the channels"

    |canCutOrCopy|

    treeView isNil ifTrue:[^ self].

    self canMoveOrAlignSelection        value:(treeView canMoveOrAlignSelection).
    self canResizeSelection             value:(treeView canResizeSelection).
    self canExchangeSelectionLayouts    value:(treeView canExchangeSelectionLayouts).
    self canChangeOrderInContainer      value:(treeView canChangeOrderInContainer).
    self canMoveSelectionIntoContainer  value:(treeView canMoveSelectionIntoContainer).
    self canMoveSelectionOutOfContainer value:(treeView canMoveSelectionOutOfContainer).
    self hasOneSelectionOtherThanCanvas value:(treeView hasOneSelectionOtherThanCanvas).
    self hasSelectionOtherThanCanvas    value:(treeView hasSelectionOtherThanCanvas).
    self hasMultipleSelectionOtherThanCanvas value:(treeView hasMultipleSelectionOtherThanCanvas).
    
    "/ the top-node cannot be cut, copied or pasted.
    canCutOrCopy := treeView selection notEmptyOrNil and:[treeView selection first ~~ 1].

    self canCutHolder value: canCutOrCopy.
    self canCopyHolder value: canCutOrCopy.

"/    self modifiedChannel value: false.

    "Modified: / 16.7.1998 / 19:13:30 / cg"
! !

!UIPainter methodsFor:'defaults'!

defaultNameOfCanvas
    ^ self class defaultNameOfCanvas
!

defaultWindowSpecClass
    ^ WindowSpec
! !

!UIPainter methodsFor:'event handling'!

doesNotUnderstand:aMessage
    "forward misunderstood messages to the painter"

    |painter|

    painter := self painter.

    (painter respondsTo:(aMessage selector)) ifTrue:[
        ^ aMessage sendTo:painter
    ].
    super doesNotUnderstand:aMessage

!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#CtrlCursorUp #CtrlCursorDown #CtrlCursorLeft #CtrlCursorRight)>

    |key|

    anEvent isKeyPressEvent ifTrue:[ 
        anEvent targetView == treeView ifFalse:[^ false].
        treeView hasFocus ifFalse:[^ false].

        key := anEvent key.

"/        (anEvent rawKey == #Cmdr) ifTrue:[
"/            self openNameEditorOnTreeSelection.
"/            ^ true.
"/        ].
        (anEvent rawKey == #CtrlCursorUp) ifTrue:[ 
            self doStepUp.
            ^ true.
        ].
        (anEvent rawKey == #CtrlCursorDown) ifTrue:[ 
            self doStepDown.
            ^ true.
        ].
        (anEvent rawKey == #CtrlCursorLeft) ifTrue:[ 
            self doStepOut.
            ^ true.
        ].
        (anEvent rawKey == #CtrlCursorRight) ifTrue:[ 
            self doStepIn.
            ^ true.
        ].
    ].

    ^ false.
! !

!UIPainter methodsFor:'help'!

defaultInfoLabel
    "returns the default info label"

    specClassName isNil ifTrue: [^'No class defined.'].
    specSelector isNil ifTrue: [^'No selector defined.'].
    ^ specClassName printString, ' >> ', specSelector

    "Modified: / 31-08-2006 / 10:12:03 / cg"
! !

!UIPainter methodsFor:'help specs'!

basicHelpTextFromSpecification:specification forKey:aKey
    "redefinable, to allow for subclasses to overwrite the helpTexts of the ui-spec"

    ^ specification helpSpec at:aKey ifAbsent:nil
!

flyByHelpSpec
    |spec painter|

    painter := self painter.

    spec := self class flyByHelpSpec.
    spec at:#editUndo put:(resources string:'Undo (%1)' 
                        with:(resources string:painter undoHistory labelOfLastUndo)).

    spec at:#changePositionDown put:(resources string:
                (spec at:#changePositionDown) with:painter nPixelsForMoveSelection).

    spec at:#changePositionLeft put:(resources string:
                (spec at:#changePositionLeft) with:painter nPixelsForMoveSelection). 

    spec at:#changePositionRight put:(resources string:
                (spec at:#changePositionRight) with:painter nPixelsForMoveSelection). 

    spec at:#changePositionUp put:(resources string:
                (spec at:#changePositionUp) with:painter nPixelsForMoveSelection). 

    ^ spec
!

helpSpec
    |spec|

    spec := self class helpSpec.
    spec at:#editUndo put:(resources string:'Undo (%1)' 
                        with:(resources string:self painter undoHistory labelOfLastUndo)).
    ^ spec
! !

!UIPainter methodsFor:'initialization'!

hideToolBarButtonCreated:aButton
    aButton passiveLevel:(MenuPanel defaultLevel). 
"/    aButton passiveLevel:1.
    aButton activeLevel:-1.
    aButton backgroundColor:(MenuPanel defaultBackgroundColor).
!

initialize
    |name scroller viewScroller|

    super initialize.

    modified := false.

    aspects := IdentityDictionary new.
    aspects at:#classNameChannel put:'NewApplication' asValue.
    aspects at:#superclassNameChannel put:'ApplicationModel' asValue.
    aspects at:#methodNameChannel put:'windowSpec' asValue.

    treeView := TreeView new.
    treeView painter:self.
    treeView windowSpecClass:(self defaultWindowSpecClass).
    treeView selectConditionBlock:[:newSelection | self selectionChangeAllowed:newSelection ].

    painterView := StandardSystemView new.
    name := name ? self defaultNameOfCanvas.
    painterView beToolWindow.
    painterView name:name.
    painterView label:name.
    painterView extent:(treeView windowSpecClass defaultExtentInUIPainter).

    UseViewScroller == true ifTrue:[
        scroller := HVScrollableView for:ViewScroller in:painterView.
        scroller
            horizontalScrollable:true miniScroller:true;
            verticalScrollable:true; verticalMini:true;
            autoHideScrollBars:false;
            layout:(0.0 @ 0.0 corner:1.0 @ 1.0) asLayout.
        viewScroller := scroller scrolledView.
        painter := UIPainterView new.
        painter extent:300@300.
        viewScroller scrolledView:painter.
    ] ifFalse:[
        painter := UIPainterView in:painterView.
        painter layout:(0.0 @ 0.0 corner:1.0 @ 1.0) asLayout.
    ].

    treeView := treeView canvas:painter specName:name.
    painter treeView:treeView.
    treeView model addDependent:self.
    painter enableChannel:(self enableChannel).

    selectionPanel := self selectionPanelClass new.
    selectionPanel allButOpenInterface:#windowSpec.
! !

!UIPainter methodsFor:'menus-dynamic'!

menuEdit
    ^ [
        |m i|

        m := self class menuEdit.
        m := m decodeAsLiteralArray.
        i := m detectItem:[:item | item nameKey == #undo] ifNone:nil.
        i notNil ifTrue:[
            i label:(resources string:(i label , ' (%1)') 
                        with:(resources string:self painter undoHistory labelOfLastUndo)).
        ].
        "/ m receiver:self.   -- now done in findGuiResources ...
        m findGuiResourcesIn:self.
        m
      ].
!

menuReplaceWidget
    ^ [
        |m i specAndView spec usefulReplacementSpecClasses|

        m := self class menuReplaceWidget.
        m := m decodeAsLiteralArray.

        specAndView := self selectedSpecAndView.
        spec := specAndView first.
        spec notNil ifTrue:[
            usefulReplacementSpecClasses := spec usefulReplacementSpecClasses.
            usefulReplacementSpecClasses notEmptyOrNil ifTrue:[
                m addSeparator.
                usefulReplacementSpecClasses do:[:eachClass |      
                    |item|

                    item := MenuItem  
                                label:(resources string:'Replace by %1' with:eachClass userFriendlyName)
                                itemValue:#replaceWidgetByClass: argument:eachClass.
                    item translateLabel:false.
                    m addItem:item.
                ].
            ].
        ].

        m findGuiResourcesIn:self.
        m
      ].

    "Modified: / 09-09-2012 / 13:25:09 / cg"
! !

!UIPainter methodsFor:'private'!

acceptOrIgnoreSectionModification
    self isModified ifTrue:[
        (self confirm:'Accept changes made to spec ?') ifTrue:[
            self accept
        ]
    ].

    "Created: / 12-01-2008 / 10:31:20 / cg"
!

askForModification
    "asks for window spec modification"

    |painter|

    painter := self painter.

    self askForSectionModification.    

    (modified or: [painter isModified or: [self helpTool modified]])
    ifTrue:[
        ((YesNoBox title:(resources string:'Window spec was modified. Exit anyway?'))        
            noText:(resources string:'Cancel');
            yesText:(resources string:'Discard Changes and Exit');
            showAtPointer;
            accepted) ifFalse: [^false].
        self clearModified.
        painter resetModification
    ].
    ^ true

    "Modified: / 20.5.1998 / 02:03:16 / cg"
!

askForSaving
    "asks for defining an application class"

    self askForSectionModification.    

    ((YesNoBox title:'No application class defined yet!!')        
        noText:'Cancel';
        yesText:'Define';
        showAtPointer;
        accepted) ifFalse: [^false].

    self doSave.

    ^true
!

askForSectionModification
    "asks for section modification in the notebook"

    self isModified ifTrue:[
        (self confirm:'Accept modifications in section ' , tabSelection printString allBold, '?') ifTrue:[
            self accept
        ] ifFalse: [
            self cancel
        ]
    ]
!

checkClassAndSelector
    "checks for class & superclass"

    |superclass cls|

    specClassName isNil ifTrue:[^ false].

    cls := self resolveName:specClassName.

    cls isNil ifTrue:[
        superclass := self resolveName:specSuperclassName.

        superclass isNil ifTrue:[
            self warn:'No class named ' , specSuperclassName , ' exists!!'.
            ^ false.
        ].

        (self confirm:'Create class ' , specClassName allBold, '?') ifTrue:[
            cls := superclass 
                        subclass:(specClassName asSymbol)
                        instanceVariableNames:''
                        classVariableNames:''
                        poolDictionaries:''
                        category:'Applications'.

            cls name ~= specClassName ifTrue:[
                self information:'Created new class is ' , cls name.
                specClassName := cls name
            ].
            ^ true.
        ].
        ^ false.
    ].
    cls isBehavior ifFalse:[
        self warn:'A global named ' , specClassName , ' exists, but it is no class.'.
        ^ false.
    ].

    specSuperclassName isBehavior ifFalse:[
        specSuperclassName notEmptyOrNil ifTrue:[
            superclass := self resolveName:specSuperclassName
        ] ifFalse:[
            specSuperclassName := nil.
        ]
    ] ifTrue:[
        superclass := specSuperclassName
    ].

    specSuperclassName notNil ifTrue:[
        superclass isNil ifTrue:[
            self warn:'No class named ' , specSuperclassName , ' exists!!'.
            ^ false.
        ].

        (cls isSubclassOf:superclass) ifFalse:[
            self information:('A global named ' , specClassName , ' exists,\' ,
                              'but is not a subclass of ' , superclass name , '.\\' ,
                              'Check and try again if that is not what you want.') withCRs.
        ]
    ].

    superclass isNil ifTrue:[
        cls notNil ifTrue:[
            specSuperclassName := cls superclass name
        ]
    ].

    ^ true

    "Modified: 12.8.1997 / 23:39:10 / cg"
!

createToolApplication:anApplicationClass spec:aSpec in:aView
    |appl applBuilder applWindow|

    appl := anApplicationClass new.
    appl createBuilder.
    applBuilder := appl builder.

    applWindow  := ApplicationSubView origin:0.0@0.0 corner:1.0@1.0 in:aView.
    applWindow level:0.
    applWindow hiddenOnRealize:true.

    appl masterApplication:self.
    applBuilder window:applWindow.
    applWindow client:appl spec:aSpec builder:applBuilder.
    appl modifiedHolder:(self modifiedChannel).
    applBuilder window:applWindow.

    ^ appl
!

hideUIView:aView
    "hides the view which is an application or top view"

    aView beIndependent.
    aView unmap.
!

raiseTabView
    |tool|

             self isLayoutToolSelected ifTrue:[tool := layoutTool ]
    ifFalse:[self isHelpToolSelected   ifTrue:[tool := helpTool   ]
    ifFalse:[
        tool := specTool.
        tool notNil ifTrue:[
            ApplicationClassQuery answer:specClass do:[
                    "/ the spectool needs to know, in which nameSpace the application class is located, to find out
                    "/ how to resolve short majorKeys...
                    UISpecification uiMajorKeyBindingNameSpaceQuery 
                        answer:(specClass notNil ifTrue:[specClass nameSpace] ifFalse:Smalltalk)
                        do:[
                            specTool selection:tabSelection 
                        ].
                ].
        ].
    ]].

    (Array with:helpTool with:layoutTool with:specTool) do:[:aTool|
        aTool ~~ tool ifTrue:[
            aTool window beInvisible.
        ].
    ].
    tool notNil ifTrue:[
        tool window beVisible.
    ].
!

raiseUIView:aView
    "raise the view which is an application or top view"

    aView remap.
    aView bePartner.
!

setClass:cls selector:selector
    "sets the specClass and the specSelector under which the window spec should be saved"

    |clsName superClassName|

    clsName := cls name.
    superClassName := cls superclass name.

    (self aspectFor:#classNameChannel) value:clsName.
    (self aspectFor:#methodNameChannel) value:(selector ? '').
    (self aspectFor:#superclassNameChannel) value:superClassName.

    self painter 
            className:clsName 
            superclassName:superClassName
            selector:(selector ? '').

    self specClass:clsName.
    specSelector := (selector ? '').
    specSuperclassName := superClassName.

    (specClassName notNil and:[ selector notNil ]) ifTrue:[
        self addHistoryEntryForClass:specClass selector:specSelector.
        self updateInfoLabel
    ].

    "Modified: / 05-02-1998 / 09:44:58 / stefan"
    "Modified: / 31-08-2006 / 10:14:49 / cg"
!

setViewInLayoutTool:aView spec:aSpec
    "sets view for layout tool"

    |type|

    self painter topView == aView ifTrue:[
        type := #Extent
    ] ifFalse:[
        self canvas == aView ifTrue:[
            type := #Extent
        ]
    ].
    self layoutTool layoutView:aView type:type spec:aSpec
!

specClass
    specClass isNil ifTrue:[
        specClassName notNil ifTrue:[
            specClass := Smalltalk classNamed:specClassName.
            self canInstallAsWebPageHolder value:self canInstallAsWebPage.
        ]
    ].
    ^ specClass

    "Created: / 31-08-2006 / 10:08:43 / cg"
    "Modified: / 14-01-2008 / 17:39:32 / cg"
!

specClass:aClassOrClassName
    "sets the specClass and updates the Help Tool"

    aClassOrClassName isBehavior 
        ifTrue: [ specClass := aClassOrClassName.
                  specClassName := aClassOrClassName name ]
        ifFalse:[ specClass := Smalltalk classNamed:aClassOrClassName.
                  specClassName := aClassOrClassName ].

    self canInstallAsWebPageHolder value:self canInstallAsWebPage.
    self helpTool loadFromClass:specClass.    
    self clearModifiedFlag.

    "Modified: / 14-01-2008 / 17:39:08 / cg"
! !

!UIPainter methodsFor:'private-tools'!

canvas
    "returns the canvas view"

    UseViewScroller == true ifTrue:[
        ^ painter.
    ].

    ^ painter topView.
"/    ^ treeView canvas

    "Modified: / 05-09-2006 / 18:36:32 / cg"
!

helpTool
    "returns the help tool"

    helpTool isNil ifTrue:[self noteBookView].
  ^ helpTool
!

layoutTool
    "returns the layout tool"

    layoutTool isNil ifTrue:[self noteBookView].
  ^ layoutTool
!

painter
    "returns the canvas view"

    ^ painter.
"/    ^ treeView canvas

    "Modified: / 05-09-2006 / 18:36:32 / cg"
!

specTool
    "returns the spec tool"

    specTool isNil ifTrue:[self noteBookView].
  ^ specTool
! !

!UIPainter methodsFor:'queries'!

canPaste
    |clipboard sel|

    clipboard := painterView getClipboardObject.

    (clipboard isCollection 
    and:[ clipboard notEmptyOrNil ]) 
            ifTrue:[sel := clipboard first]
            ifFalse:[sel := clipboard].

    ^ (sel isKindOf:UISpecification) 
"/                    and:[treeSelection size  = 1 
"/                    and:[treeSelection first == 1 
"/                         or: [self canPasteInto: treeView selectedNode contents view]]]
!

hasSpecClass
    "answers whether an application class is defined"

    ^ (self resolveName:specClassName) notNil
!

hasSpecClassAndSelector
    "answers whether an application class and a selector under which
     the window spec is stored is defined"

    specSelector size > 1 ifTrue:[
        ^ self hasSpecClass
    ].
    ^ false
!

isEditingSpecOnly
    ^ self isNotEditingSpecOnly not
!

isHelpToolSelected
    "answers whether the current selected section in the noteBook is the Help Tool"

    ^ tabSelection = UIHelpTool label
!

isLayoutToolSelected
    "answers whether the current selected section in the noteBook is the Layout Tool"

    ^ tabSelection = UILayoutTool label
!

isModified
    "answers whether the current window spec or a layout is modified"

    ^ self modifiedChannel value
!

isNotEditingSpecOnly
    ^ true
!

isPainterEnabled
    "answers whether I am running in test mode"

    ^ self painter enabled
!

isUIPainter
    ^ true
!

listOfAspects
    ^ self painter listOfAspects

    "Created: / 12-01-2008 / 19:24:51 / cg"
!

listOfCallbacks
    ^ self painter listOfCallbacks

    "Created: / 12-01-2008 / 19:25:09 / cg"
! !

!UIPainter methodsFor:'selection'!

askForUnsavedModifications
    |whatToDo|

    self isModified ifFalse:[^ true].

    whatToDo := DialogBox 
                    confirmWithCancel:'Accept modifications in section ' , tabSelection printString allBold, ' ?'
                    labels:#('Cancel' 'Ignore' 'Accept')
                    default:3.
    whatToDo isNil ifTrue:[^ false].
    whatToDo == true ifTrue:[
        self accept
    ] ifFalse:[
        self cancel
    ].

    ^ true
!

copySelection
    self painter copySelection.
    self updateChannels.
!

selectedSpec
    |specAndView|

    specAndView := self selectedSpecAndView.
    ^ specAndView first
!

selectedSpecAndView
    |spec view property|

    treeView isCanvasSelected ifTrue:[
        spec := treeView canvasSpec.
        view := self canvas. "/ self painter topView.
    ] ifFalse:[
        (property := treeView propertySelected) notNil ifTrue:[
            treeView canResizeSelectedWidget ifTrue:[
                view := property view.
            ].
            spec := property spec copy.
        ]
    ].
    ^ Array with:spec with:view
!

tabSelection
    "returns the label of the current section in the notebook"

    ^ tabSelection
!

tabSelection:something
    "called whenever the section of the notebook has changed"

    (something isNil or:[tabSelection = something]) ifTrue:[
        ^ self
    ].

    self isModified ifTrue:[
        self autoAcceptOnSelectionChange value ifTrue:[
            self accept
        ] ifFalse:[
            self askForUnsavedModifications ifFalse:[^ self].
        ].
    ].
    tabSelection := something.
    self raiseTabView.
    self cancel.
!

treeSelectionChanged
    "called whenever the selection of the treeview has changed"

    |specAndView view spec|

    self askForUnsavedModifications ifFalse:[^ self].
"/    self isModified ifTrue:[
"/        (self confirm:'Accept modifications in section ' , tabSelection printString asBoldText, '?') ifTrue:[
"/            self accept
"/        ]
"/    ].

    specAndView := self selectedSpecAndView.
    spec := specAndView first.
    view := specAndView last.

    self setViewInLayoutTool:view spec:spec.
    self specTool specification:spec.

    self updateSlicesForSpec:spec andView:view.
    self clearModifiedFlag.
    self updateChannels.
!

updateSlicesForSpec:spec andView:view
    "fetch slices-info from the spec; add help and geometry slices manually"

    |slices "size" list tabComponent|

    tabComponent := self componentAt:#noteBook.

    spec notNil ifTrue:[
        self helpTool helpKey:(spec activeHelpKey).
        slices := spec class slices.

        list := slices collect:[:eachSlice | eachSlice first asString].
        self treeView isCanvasSelected ifFalse:[
            list := list copyWith:(UIHelpTool label)
        ].
        view notNil ifTrue:[
            "/ for now, keep it as an empty slice;
            "/ better when toggling as we do not loos the 'geometry' selection.
            "/ slices notebook should remember the last 'explicit' selected tab.
            true "spec hasLayout" ifTrue:[
                list := list copyWith:UILayoutTool label.
            ]
        ].

"/        size   := slices size.
"/        view notNil ifTrue:[
"/            self treeView isCanvasSelected ifFalse:[
"/                list := Array new:(size + 2).
"/                list at:(size + 2) put:(UILayoutTool label).
"/            ] ifTrue:[
"/                list := Array new:(size + 1).
"/                list at:(size + 1) put:(UILayoutTool label).
"/            ].
"/        ] ifFalse:[
"/            list := Array new:(size + 1).
"/        ].
"/
"/        1 to:size do:[:i| list at:i put:((slices at:i) first asString)].
"/        self treeView isCanvasSelected ifFalse: [
"/            list at:(size + 1) put:(UIHelpTool label)
"/        ].

        self tabList value:list.
        self showHelp:spec class name for:self.
        tabComponent enabled:true.

        (tabSelection := tabComponent selection) isNil ifTrue:[
            tabComponent setSelection:(tabSelection := list first)
        ].
        self raiseTabView
    ] ifFalse:[
        self helpTool helpKey:nil.
        tabComponent enabled:false.
        self defaultInfoLabel.
    ].
! !

!UIPainter methodsFor:'settings'!

generateAspectsAsInstanceVariables
    "if on, aspects are held as instance variables;
     if off (the default), they are kept in the bindings dictionary."

    ^ UIPainterView generateAspectsAsInstanceVariables

    "Created: / 29-07-1998 / 11:17:59 / cg"
    "Modified: / 12-01-2008 / 10:37:43 / cg"
!

generateAspectsAsInstanceVariables:aBoolean
    "if on, aspects are held as instance variables;
     if off (the default), they are kept in the bindings dictionary."

    ^ UIPainterView generateAspectsAsInstanceVariables:aBoolean

    "Created: / 29.7.1998 / 11:18:20 / cg"
!

generateCommentedCode
    "comments in generated aspect methods; yes or no."

    ^ UIPainterView generateCommentedCode

    "Created: / 12-01-2008 / 10:34:14 / cg"
!

generateCommentedCode:aBoolean
    "comments in generated aspect methods; yes or no."

    UIPainterView generateCommentedCode:aBoolean

    "Created: / 12-01-2008 / 10:23:10 / cg"
!

redefineAspectMethods
    "redefine methods yes or no.
     If a method is defined in super class should the message be reinstalled ?"

    ^ UIPainterView redefineAspectMethods

    "Modified: / 12-01-2008 / 10:34:07 / cg"
!

redefineAspectMethods:aBoolean
    "redefine methods yes or no.
     If a method is defined in super class should the message be reinstalled ?"

    UIPainterView redefineAspectMethods:aBoolean

    "Modified: / 12-01-2008 / 10:23:20 / cg"
! !

!UIPainter methodsFor:'startup & release'!

closeRequest
    "asks for permission before closing"

    self askForModification ifFalse:[^self].

    super closeRequest.

    painterView notNil ifTrue:[
        painterView masterApplication:nil.
        painterView closeRequest.
    ].
    treeView notNil ifTrue:[
        treeView model removeDependent:self.
    ].
    selectionPanel notNil ifTrue:[
        selectionPanel masterApplication:nil.
        selectionPanel closeRequest
    ].
    "/ selectionPanel := nil.
    "/ treeView       := nil.
!

closeRequestFor:aTopView
    "handles a close request for a specific view"

    |topView|

    (topView := self window) == aTopView ifTrue:[
        super closeRequestFor:aTopView
    ] ifFalse:[
        aTopView = selectionPanel window ifTrue:[
            self galleryShown value:false
        ] ifFalse:[
            aTopView == (self painter topView) ifTrue:[
                self painterShown value:false
            ] ifFalse:[
                aTopView closeRequest
            ]
        ].
        topView raise.
    ].
!

commonPostBuild
    "sets the root of the tree view as first selection;
     sets the grid parameters, if defined"

    |cls sel|

    cls := self specClass.
    sel := specSelector.
    cls notNil ifTrue:[
        self setClass:cls selector:sel.

        (cls respondsTo:sel) ifTrue:[  
            self painter setupFromSpec:(cls perform:sel).
        ]
    ].

    self autoAcceptOnSelectionChange addDependent:self.
    self autoAcceptOnSelectionChange value ifTrue:[
        (builder componentAt:'acceptButton') label:(resources string:'Apply')
    ].

    "/ using masters infoHolder ?
    (builder aspectAt:#useAlienInfoLabelHolder) == true ifTrue:[
        (builder componentAt:#mainPanel) layout bottomOffset:0.
        (builder componentAt:#infoBarSubSpec) beInvisible
    ].

    self updateInfoLabel.

    "Modified: / 31-08-2006 / 10:12:53 / cg"
!

loadFromClass:aClass andSelector:selector
    "loads a window spec by evaluating aMessageString
     (which is something like 'fooClass windowSpec')"

    self assert:(aClass isNil or:[aClass isClass]).

    self askForModification ifFalse:[^ self].

    self setClass:aClass selector:selector.    

    (aClass respondsTo:selector) ifTrue:[   
        self loadFromSpec:(aClass perform:selector).
    ]
!

loadFromMessage:classAndSelector
    "loads a window spec by evaluating aMessageString
     (which is something like 'fooClass windowSpec')"

    self askForModification ifFalse:[^ self].

    classAndSelector notNil ifTrue:[
        self 
            loadFromClass:classAndSelector methodClass 
            andSelector:classAndSelector methodSelector
    ]
!

loadFromSpec:aSpec
    "loads a window spec proper"

    self askForModification ifFalse:[^ self].

    self painter setupFromSpec:aSpec.
!

openInterface:aSymbol 
    "in addition to opening my interface, also open up a gallery and a painter"
    
    |topView|

    self setupSpecClassAndSelector.

"/    treeView := TreeView new.
"/    treeView windowSpecClass:(self defaultWindowSpecClass).
"/    treeView 
"/        selectConditionBlock:[:newSelection | self selectionChangeAllowed:newSelection ].

"/    painterView := StandardSystemView new.
"/    name := name ? UIPainter defaultNameOfCanvas.
"/    painterView beToolWindow.
"/    painterView name:name.
"/    painterView label:name.
"/    painterView extent:(treeView windowSpecClass defaultExtentInUIPainter).
"/    painter := UIPainterView in:painterView.
"/    painter layout:(0.0 @ 0.0 corner:1.0 @ 1.0) asLayout.
"/    treeView := treeView canvas:painter specName:name.
"/    painter treeView:treeView.
"/    treeView model addDependent:self.
"/    painter enableChannel:(self enableChannel).

    super openInterface:aSymbol.

    topView := self window.
    topView label:'GUI Painter'.

"/    self setupCanvasAndSelectionPanel.
"/
"/    selectionPanel window waitUntilVisible.
"/    painterView window waitUntilVisible.
"/    self window waitUntilVisible.
"/    [ Delay waitForSeconds:0.5. self window topView raise ] fork.

    "Modified: / 31-08-2006 / 10:13:16 / cg"
!

openOnClass:aClass
    "opens the GUI Painter on aClass and #windowSpec"

    self openOnClass:aClass andSelector:#windowSpec
!

openOnClass:aClass andSelector:aSelector
    "opens the GUI Painter on aClass and aSelector"

    aClass isNil ifTrue:[
        (self confirm:'No class given to the GUI Painter (class was probably renamed?)\\Open anyway (to create a new window spec) ?' withCRs)
        ifFalse:[^ nil].
    ].

    specSelector := aSelector.
    specClass := aClass.
    specClassName := aClass name.

    self openInterface.

"/    specSelector := aSelector.
"/    specClass := aClass.

    "Modified: / 31-08-2006 / 10:13:31 / cg"
!

postBuildWith: aBuilder
    super postBuildWith:aBuilder.

    (self toolBarVisibleHolder value 
    or:[ self editToolBarVisibleHolder value ]) ifTrue:[ self toolBarVisibilityChanged ].

    "Created: / 18-02-2007 / 15:03:08 / cg"

    self setupPainter.

    "Modified: / 22.8.1998 / 17:41:34 / cg"
!

postOpenWith: aBuilder
    "spread the painter and gallery views on the screen"

    |myWindow canvasWindow canvasOrg galleryWindow 
     galleryOrg windowGroup monitorBounds myViewRectangle|

    super postOpenWith:aBuilder.

    windowGroup := self topApplication windowGroup.
    windowGroup addPreEventHook:self.

    treeView selection: #(1).
    aBuilder keyboardProcessor menuBar:nil.

    myWindow := self window.
    canvasWindow := self painter topView.
    [selectionPanel isNil] whileTrue:[
        Delay waitForSeconds:0.1.
    ].

    galleryWindow := selectionPanel window.

    "/ try to lay out things non-overlapping
    "/ but only, if the window manager placed all windows
    "/ on top of each other
    "/ make sure, that all the windows are on the same physical monitor
    monitorBounds := device monitorBoundsAt:self window origin.
    myViewRectangle := myWindow screenBounds.
    (myViewRectangle intersects:galleryWindow screenBounds) ifTrue:[
        galleryOrg := (monitorBounds right - galleryWindow width - 20) 
                      @ 
                      ((myWindow bottom + 20) min:(monitorBounds bottom - galleryWindow height - 20)).
        galleryWindow 
            origin:galleryOrg;
            raise.
    ].
    ((myViewRectangle intersects:canvasWindow screenBounds)
     or:[galleryWindow screenBounds intersects:canvasWindow screenBounds])ifTrue:[          
        canvasOrg := monitorBounds origin + (10@20).
        canvasWindow 
            origin:canvasOrg;
            raise.
    ].

    self setupCanvasAndSelectionPanel.

"/    selectionPanel window waitUntilVisible.
"/    painterView window waitUntilVisible.
"/    self window waitUntilVisible.
    [   
        Delay waitForSeconds:0.1. 
        myWindow topView raise.
        Delay waitForSeconds:0.25. 
        myWindow topView raise 
    ] fork.
    "Modified: / 13.7.1999 / 21:26:52 / cg"
!

release
    super release.

    painterView notNil ifTrue:[
        painterView destroy.
    ].
    selectionPanel notNil ifTrue:[
        selectionPanel masterApplication:nil.
        selectionPanel window destroy
    ].
    selectionPanel := nil.
    treeView       := nil.
    painterView    := nil.
!

selectionPanelClass
    ^ SelectionPanelClass
!

setupCanvasAndSelectionPanel
    |topView galleryWindow icon|

    painterView isOpen ifTrue:[
        ^ self.
    ].

    icon := self class builderIcon.

    topView := self window.

    painterView openInGroup:(topView windowGroup).
    painterView application:self.

    galleryWindow := selectionPanel window.
    galleryWindow beToolWindow.
    galleryWindow openInGroup:(topView windowGroup).

    selectionPanel masterApplication:self.

    topView iconLabel:'GUI Painter'.
    topView icon:icon.
    painterView iconLabel:'GUI Canvas'.
    painterView icon:icon.
    galleryWindow iconLabel:'GUI Gallery'.
    galleryWindow icon:icon.
    
    topView isModal ifFalse:[
        topView bePartner.
        painterView bePartner.
        galleryWindow bePartner.
    ]
!

setupPainter
    "sets the painter's grid parameters, if defined"

    |painter settings gridPara hspace vspace|

    painter  := self painter.
    settings := self class settings.
    gridPara := painter gridParameters copy.
    hspace   := settings at: #HGridSpace ifAbsent:10.
    vspace   := settings at: #VGridSpace ifAbsent:10.
    gridPara at:1 put:hspace; at:2 put:vspace; at:5 put:hspace; at:6 put:vspace.
    painter gridParameters:gridPara.
    painter gridShown: (settings at: #GridShown ifAbsent:false).
    painter gridAlign: (settings at: #GridAlign ifAbsent:false).
    painter shown ifTrue:[painter clearView].

    "Modified: / 22.8.1998 / 17:41:34 / cg"
!

setupSpecClassAndSelector
    |cls name|

    self specClass notNil ifTrue:[
        specClassName isBehavior ifTrue:[
            name := specClassName nameWithoutPrefix.
        ] ifFalse:[
            name := specClassName printString string
        ]
    ].
    (aspects at:#classNameChannel) value:(specClassName ? 'NewApplication').

    specSuperclassName isNil ifTrue:[
        specClassName notNil ifTrue:[
            (cls := self resolveName:specClassName) notNil ifTrue:[
                specSuperclassName := cls superclass name.
            ]
        ]
    ].
    aspects at:#superclassNameChannel
        put:((specSuperclassName notNil 
                ifTrue:[ specSuperclassName ]
                ifFalse:[ 'ApplicationModel' ]) asValue).
    aspects at:#superclassNameDefaults
        put:#( 'ApplicationModel' 'SimpleDialog' 'WebApplicationModel') asValue.
    aspects at:#methodNameChannel
        put:((specSelector notNil 
                ifTrue:[ specSelector asValue ]
                ifFalse:[ #windowSpec ]) asValue).

    "Modified: / 16-01-2008 / 10:44:55 / cg"
! !

!UIPainter methodsFor:'user actions'!

accept
    "accepts all modifications done to the attributes of the current section"

    |painter layout spec layoutTool layoutView t|

    self acceptChannel value:true; value:false.  "/ force editFields to accept
    self clearModifiedFlag.

    painter := self painter.
    spec := self specTool specification.

    self isLayoutToolSelected ifTrue:[
        layoutTool := self layoutTool.

        (layout := layoutTool layout) notNil ifTrue:[
            "/ cg->ca: the following code should be moded to the layoutTool
            "/ (i.e. layoutTool saveInSpec:spec).

            layoutTool layoutType == #Extent ifTrue:[
                layoutView := layoutTool layoutView.

                layoutView == self canvas ifTrue:[
                    layoutView extent:layout.
                    UseViewScroller == true ifTrue:[
                        layoutView container container sizeChanged:nil.
                    ].
                ] ifFalse:[
                    spec useDefaultExtent:(layoutTool aspectValueFor:#useDefaultExtent).
                    spec useDefaultExtent ifTrue:[
                        "/ temporarily unfreeze the widgets size
                        "/ (but remember, the old setting, which is actually
                        "/ controlled by the resizeForLabel attribute)
                        t := layoutView sizeFixed.
                        layoutView sizeFixed:false.
                        layout := layoutView preferredExtent.    
                        layoutView sizeFixed:t.
                    ].
                    spec usePreferredWidth:(layoutTool aspectValueFor:#usePreferredWidth).
                    spec usePreferredHeight:(layoutTool aspectValueFor:#usePreferredHeight).
                    spec useDynamicPreferredWidth:(layoutTool aspectValueFor:#useDynamicPreferredWidth).
                    spec useDynamicPreferredHeight:(layoutTool aspectValueFor:#useDynamicPreferredHeight).
                    painter setExtent:layout.
                    painter updateFromSpec:spec.
                ]
            ] ifFalse:[
                spec useDefaultExtent:false.
                spec usePreferredWidth:(layoutTool aspectValueFor:#usePreferredWidth).
                spec usePreferredHeight:(layoutTool aspectValueFor:#usePreferredHeight).
                spec useDynamicPreferredWidth:(layoutTool aspectValueFor:#useDynamicPreferredWidth).
                spec useDynamicPreferredHeight:(layoutTool aspectValueFor:#useDynamicPreferredHeight).
                layoutTool layoutType == #LayoutFrame ifTrue:[
                    spec keepSpaceForOSXResizeHandleH:(layoutTool aspectValueFor:#keepSpaceForOSXResizeHandleH).
                    spec keepSpaceForOSXResizeHandleV:(layoutTool aspectValueFor:#keepSpaceForOSXResizeHandleV).
                ].
                painter setLayout:layout.
                spec layout:layout.
                painter updateFromSpec:spec.
            ].
        ]
    ] ifFalse:[
        self isHelpToolSelected ifTrue:[
            self helpTool accept.      
            spec activeHelpKey:self helpTool helpKey.
        ].      
        painter updateFromSpec:spec
    ].

    self clearModified
!

addWidget: aSpecClassSymbol
    "adds a widget from aSpecClass to the current widget"

    self addWidgetOfSpec: (Array with: (Smalltalk at: aSpecClassSymbol) new)
!

addWidgetOfSpec: aSpec
    "adds a widget from aSpec to the current widget"

    |newSel|

    (newSel := painter pasteSpecifications:aSpec keepLayout:false at:0@0) notNil
    ifTrue:[
        painter select: newSel
    ] ifFalse:[   
        ((treeView selection size = 0) or: [treeView selectedNode isNil])
        ifTrue:[                          
            treeView selection: #(1).
        ] ifFalse:[  
            treeView selectNode: (treeView detectNode: [:n| n = treeView selectedNode parent])
        ].
        self addWidgetOfSpec: aSpec
    ]

    "Modified: / 05-09-2006 / 18:37:12 / cg"
!

askForMoveByStep
    "open a dialog to ask for a number"

    |s nPixels|

    s := Dialog request:'Number of Pixels to Move: '
                initialAnswer:painter nPixelsForMoveSelection asString.
    s isEmptyOrNil ifTrue:[^ self].
    nPixels := Integer readFrom:s onError:nil.
    nPixels isNil ifTrue:[^ self].

    self painter nPixelsForMoveSelection:nPixels
!

cancel
    "cancels all modifications done to the attributes of the current section; 
     reread the old attributes"

    |spec key view|

    self isModified ifTrue:[
        (spec := self painter specForSelection) notNil ifTrue:[
            key := spec activeHelpKey.
        ].
        self helpTool helpKey:key.

        treeView isCanvasSelected ifTrue: [
            spec := treeView canvasSpec.
        ].

        self specTool specification:spec.
        view := self layoutTool layoutView.

        self setViewInLayoutTool:view spec:spec.
        spec class == DataSetSpec ifTrue:[
            view notNil ifTrue:[
                view columnDescriptors:(spec columns)
            ]
        ].        
        self clearModifiedFlag.
        self clearModified.
    ]
!

hideEditToolbar
    self editToolBarVisibleHolder value:false
!

hideToolbar
    self toolBarVisibleHolder value:false
!

replaceWidgetByClass:aSpecOrWidgetClass
    "replace the selected widget by a new instance of aSpecOrWidgetClass,
     which gets the old widget's layout"

    |newSpecClass oldSpec newSpec|

    treeView isCanvasSelected ifTrue:[
        ^ self
    ].
    (newSpecClass := self specClassFromUsersSpecOrWidgetClass:aSpecOrWidgetClass) isNil ifTrue:[
        ^ newSpecClass
    ].

    oldSpec := self selectedSpec.
    newSpec := newSpecClass cloneFrom:oldSpec.

    self painter replaceSelectionBy:newSpec.

    "Modified: / 05-09-2012 / 19:24:40 / cg"
!

setMoveByStep:nPixels
    "change the number of pixels by which the step-buttons move the selected widget(s)"

    self painter nPixelsForMoveSelection:nPixels
!

specClassFromUsersSpecOrWidgetClass:aSpecOrWidgetClass
    |newSpecClass|

    (aSpecOrWidgetClass isSubclassOf:UISpecification) ifTrue:[
        newSpecClass := aSpecOrWidgetClass.
    ] ifFalse:[
        (aSpecOrWidgetClass isSubclassOf:View) ifTrue:[
            newSpecClass := aSpecOrWidgetClass basicNew specClass.
        ] ifFalse:[
            newSpecClass := nil
        ].
    ].
    newSpecClass isNil ifTrue:[
        Dialog warn:'Invalid Spec- or View-Class: ' , aSpecOrWidgetClass name.
        ^ nil.
    ].
    ^ newSpecClass
!

useBackgroundImage
    "select bitmap to underly"

    |fn|

    fn := Dialog requestFileName:'Bitmap Image File ?' pattern:'*.gif;*.tiff;*.jpg;*.png' fromDirectory:'f:'.
    fn isNil ifTrue:[
        ^ self
    ].
    painter useSketchFile:fn

    "Created: / 16-01-2008 / 17:49:20 / cg"
!

useSketch
    "select sketchfile to underly.
     Sketchfiles are generated by notepads, which can offline-store drawn sketches"

    |fn|

    fn := Dialog requestFileName:'Sketch (Notepad Drawing) ?' pattern:'*.TOP' fromDirectory:'f:'.
    fn isNil ifTrue:[
        ^ self
    ].
    painter useSketchFile:fn

    "Created: / 16-01-2008 / 17:49:20 / cg"
!

wrapWidgetIntoClass:aSpecOrWidgetClass
    "put the selected widget into a new instance of aSpecOrWidgetClass,
     which gets the wrapped widget's layout"

    |newSpecClass oldSpec newSpec|

    treeView isCanvasSelected ifTrue:[
        ^ self
    ].
    (newSpecClass := self specClassFromUsersSpecOrWidgetClass:aSpecOrWidgetClass) isNil ifTrue:[
        ^ newSpecClass
    ].

    oldSpec := self selectedSpec.
    newSpec := newSpecClass new.
    newSpec layout:oldSpec layout.
    newSpec component:oldSpec.
    
    self painter replaceSelectionBy:newSpec.

    "Modified: / 05-09-2012 / 19:24:40 / cg"
! !

!UIPainter methodsFor:'user actions-menu'!

doAskAndReplaceWidgetBy
    "ask for a widget class,
     and replace the selected widget by a new instance of that one,
     which gets the old widget's layout"

    |widgetClass list common selectedSpec|

    selectedSpec := self selectedSpec.
    selectedSpec isNil ifTrue:[^ self].

    list :=  UISpecification allSubclasses
                select:[:cls | 
                    [ cls viewClass notNil]
                        on: NotFoundError
                        do:[ false ]
                ].
    list sort:[:a :b | a name < b name].

    common := selectedSpec class commonReplacementClasses.
    common notEmpty ifTrue:[
        list addAllFirst:(common , (Array with:'-')).
    ].
    widgetClass := Dialog 
                        requestClass:'Replace by (Spec or View Class):'
                        list:list
                        okLabel:'OK' 
                        initialAnswer:nil.
    widgetClass isNil ifTrue:[
        ^ self
    ].
    self replaceWidgetByClass:widgetClass

    "Modified: / 05-09-2012 / 19:31:22 / cg"
!

doAskAndWrapWidgetInto
    "ask for a container class,
     and put the selected widget into a new instance of that one,
     which gets the wrapped widget's layout"

    |widgetClass list selectedSpec|

    selectedSpec := self selectedSpec.
    selectedSpec isNil ifTrue:[^ self].

    list :=  UISpecification allSubclasses
                select:[:cls | 
                    [ cls viewClass notNil
                      and:[ cls supportsSubComponents ]]
                        on: NotFoundError
                        do:[ false ]
                ].
    list sort:[:a :b | a name < b name].

    widgetClass := Dialog 
                        requestClass:'Wrap into (Spec or View Class):'
                        list:list
                        okLabel:'OK' 
                        initialAnswer:nil.
    widgetClass isNil ifTrue:[
        ^ self
    ].
    self wrapWidgetIntoClass:widgetClass
!

doBrowseActionMethod:aspectSelector
    "browse or create the action method as entered in the field 
     (button beside input field in ui-slice pressed)"

    self acceptOrIgnoreSectionModification.

    self doBrowseActionMethod:aspectSelector nameAs:aspectSelector

    "Modified: / 12-01-2008 / 10:32:12 / cg"
!

doBrowseActionMethod:aspectSelector nameAs:aspectNameShown
    "browse or create the action method as entered in the field.
     sent by embedded ui-slice's browse class button."

    |cls spec aspect code|

    cls := self specClass.
    cls isNil ifTrue:[
        Dialog information:'No application class defined.'.
        ^ self
    ].

    spec := painter specForSelection.
    spec isNil ifTrue:[^ self].
    aspect := spec perform:aspectSelector.
    aspect isNil ifTrue:[
        Dialog information:(resources 
                                string:'Please enter an action method name for "%1" first.'
                                with:(resources string:aspectNameShown) allBold).
        ^ self
    ].
        
    (cls includesSelector:aspect asSymbol) ifFalse:[
        (Dialog confirm:(resources 
                            stringWithCRs:'%1 does not implement %2.\\Create ?'
                            with:(cls name allBold)
                            with:aspect allBold)) 
        ifFalse:[
            (Dialog confirm:(resources 
                                stringWithCRs:'Browse implementors of %1 ?'
                                with:aspect allBold)) 
            ifTrue:[
                SystemBrowser default browseImplementorsOf:aspect
            ].
            ^ self
        ].
        code := painter
            generateActionMethodFor:aspect 
            spec:nil 
            inClass:cls.
        Class packageQuerySignal answer:painter targetClass package do:[
            code readStream fileIn.
        ].
    ].
    SystemBrowser default openInClass:cls selector:aspect

    "Modified: / 28-01-2014 / 21:55:56 / cg"
!

doBrowseAspectClass: aspect
    "sent by embedded ui-slice's 'browse'-class button (for example, subcanvasSpec)."

    | spec className class |

    spec := painter specForSelection.
    spec isNil ifTrue:[ self error: 'No spec!!'.].      
    className := spec perform: aspect.
    class := self resolveName: className inClass: specClass.
    class isNil ifTrue:[ 
        Dialog warn: (resources string: 'No such class (%1)' with: className). 
        ^ self.
    ].
    Smalltalk browseInClass: (self resolveName: className inClass: specClass)

    "Created: / 24-02-2014 / 17:20:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doBrowseAspectClassAndSelector:classAspectAndSelectorAspect
    "sent by embedded ui-slice's browse class button (for example, subcanvasSpec)."

    | classAspect selector selectorAspect spec className class |

    classAspect := classAspectAndSelectorAspect first. "/ #(#majorKey #minorKey)
    selectorAspect := classAspectAndSelectorAspect second. "/ #(#majorKey #minorKey)

    spec := painter specForSelection.
    spec isNil ifTrue:[ self error: 'No spec!!'.].      
    className := spec perform: classAspect.
    class := self resolveName: className inClass: specClass.
    class isNil ifTrue:[ 
        Dialog warn: (resources string: 'No such class (%1)' with: className). 
        ^ self.
    ].
    selector := spec perform: selectorAspect.
    Smalltalk 
        browseInClass: (self resolveName: className inClass: specClass) theMetaclass
        selector:selector
!

doBrowseAspectMethod:aspectSelector
    "browse or create the aspect method as entered in the field 
    (button beside input field pressed)"

    self isModified ifTrue:[ self accept ].
    "/ self acceptOrIgnoreSectionModification.
    self doBrowseAspectMethod:aspectSelector nameAs:aspectSelector

    "Modified: / 12-01-2008 / 10:32:15 / cg"
    "Modified (format): / 24-02-2014 / 17:44:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doBrowseAspectMethod:aspectSelector nameAs:aspectNameShown
    "browse or create the aspect method as entered in the field"

    |cls spec aspect implementingClass answer|

    cls := self specClass.
    cls isNil ifTrue:[
        Dialog information:'No Application Class defined.'.
        ^ self
    ].

    spec := painter specForSelection.
    spec isNil ifTrue:[self halt. ^ self].

    aspect := spec perform:aspectSelector.
    aspect isString ifFalse:[
        "ignore non-strings (list may be an Array)"
        aspect isNil ifTrue:[
            Dialog information:(resources 
                                    string:'Please enter a Method name for "%1" first.'
                                    with:(resources string:aspectNameShown) allBold).
        ].
        ^ self
    ].

    implementingClass := (cls whichClassIncludesSelector:aspect asSymbol).
    implementingClass isNil ifTrue:[
        implementingClass := (cls class whichClassIncludesSelector:aspect asSymbol).
    ].
    implementingClass isNil ifTrue:[
        answer := OptionBox
                          request:(resources 
                                    stringWithCRs:'%1 does not implement %2.\\Create ?'
                                    with:(cls name allBold)
                                    with:aspect allBold)
                          label:'Create/Browse Aspect Method'
                          image:(WarningBox iconBitmap)
                          buttonLabels:#('Cancel' 'Browse Implementors' 'Create & Browse' 'Create' )
                          values:#(abort browseImplementors createAndBrowse create )
                          default:#create
                          onCancel:#abort.

        answer == #browseImplementors ifTrue:[
            UserPreferences systemBrowserClass browseImplementorsOf:aspect.
            ^ self
        ].
        answer == #abort ifTrue:[
            ^ self
        ].

        self doGenerateAspectMethodsForAll:(Array with:aspect).
        implementingClass := self painter targetClass.

        answer == #create ifTrue:[^ self].
    ] ifFalse:[
        (Dialog confirm:(resources string:'Browse the implementation of "%1" ?' with:aspect)) ifFalse:[
            ^ self.
        ].
    ].

    UserPreferences systemBrowserClass 
        openInClass:implementingClass selector:aspect
!

doBrowseAspectMethods
    "opens a browser on all the aspect methods"

    |methods|

    self painter isModified ifTrue:[
        self warn:'The current window spec has not yet been saved!!\\The System Browser may show the code of the old aspect methods.' withCRs.
    ].

    (methods := self painter aspectMethods) isEmpty ifTrue:[
        self warn:'No aspect methods found !!'.
        ^ self.
    ].
    UserPreferences systemBrowserClass 
        browseMethods:methods 
        title:'Aspect methods'.
!

doBrowseClass
    "opens a System Browser on the specClass"

    self painter isModified ifTrue:[
        self warn:'The current window spec has not yet been saved!!\\The System Browser will show the code of the old window spec.' withCRs.
    ].

    Smalltalk browseInClass:(self resolveName:specClassName)
!

doBrowseSpecificationClass
    "opens an browser on the spec class of the selected widget"

    |spec|

    (spec := self painter specForSelection) isNil ifTrue:[
        treeView isCanvasSelected ifTrue:[
            spec := treeView canvasSpec.
        ]
    ].
    spec notNil ifTrue:[
        spec class browse
    ]
!

doBrowseViewClass
    "opens a browser on the selected widgets class"

    |selection widget|

    ((selection := self painter selection) isCollection and: [selection size >= 1]) ifTrue:[
        widget := selection first
    ] ifFalse:[
        widget := selection
    ].

    widget scrolledView class browse

    "Modified: / 22-01-2011 / 12:02:31 / cg"
!

doDefineClassAndSelector
    "launches a dialog for defining class, superclass, and selector of the application"

    | again readFromModelKeyed |

    readFromModelKeyed := [:aKey| |ret|
        ret := (self aspectValueFor:aKey).
        ret isEmptyOrNil ifTrue:[
            ret := nil
        ] ifFalse:[
            ret isString ifTrue:[
                ret := ret string withoutSeparators.
                ret := ret isEmpty ifTrue:[nil] ifFalse:[ret asSymbol].
            ].
        ].
        ret
    ].

    [
        again := false.

        aspects at:#classNameChannel      put:(specClassName  ? 'NewApplication')   asValue.
        aspects at:#methodNameChannel     put:(specSelector   ? 'windowSpec')       asValue.
        aspects at:#superclassNameChannel put:(specSuperclassName ? 'ApplicationModel') asValue.

        (self openDialogInterface:#dialogSpecForDefiningClassAndSelector) ifTrue:[
            specClassName  := readFromModelKeyed value:#classNameChannel.
            specSelector   := readFromModelKeyed value:#methodNameChannel.
            specSuperclassName := readFromModelKeyed value:#superclassNameChannel.

            (again := self checkClassAndSelector not) ifFalse:[
                self painter 
                    className:specClassName
                    superclassName:specSuperclassName
                    selector:specSelector.
            ].

            again ifFalse:[
                ((Smalltalk at:specClassName asSymbol) notNil
                and:[ (Smalltalk at:specClassName asSymbol) class includesSelector:specSelector ])
                ifTrue:[
                    (self confirm:('%1 already implements %2. Overwrite ?' bindWith:specClassName with:specSelector))
                    ifFalse:[
                        again := true.
                    ].
                ].
            ].
        ] ifFalse: [
            ^nil
        ]

    ] doWhile:[again].

    specClassName := specClassName isBehavior 
                        ifTrue:[specClassName name]
                        ifFalse:[specClassName].
    specClass := self resolveName: specClassName.  

    self clearModifiedFlag.
    self helpTool buildAndMergeFromClass:specClass.
    self updateInfoLabel

    "Modified: / 16-07-1998 / 18:26:33 / cg"
    "Modified: / 18-01-2017 / 23:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDefineGrid
    "opens a dialog for the grid parameters"

    |hspace vspace bindings painter gridPara settings|

    painter  := self painter.
    bindings := IdentityDictionary new.
    gridPara := painter gridParameters copy.
    settings := self class settings.

    bindings at:#showGrid    put:((settings at: #GridShown ifAbsent: [painter gridShown]) asValue).
    bindings at:#alignToGrid put:((settings at: #GridAlign ifAbsent: [painter gridAlign]) asValue).
    bindings at:#hspace      put:((gridPara at:1) asValue).
    bindings at:#vspace      put:((gridPara at:2) asValue).

    (self openDialogInterface:#dialogSpecForDefiningGridParameters withBindings:bindings) ifFalse:[
        ^ self
    ].

    hspace := (bindings at:#hspace) value ? 5.
    vspace := (bindings at:#vspace) value ? 5.

    gridPara at:1 put:hspace.
    gridPara at:2 put:vspace.
    gridPara at:5 put:hspace.
    gridPara at:6 put:vspace.

    painter gridShown:false. 
    painter gridAlign:false. 
    painter gridParameters:gridPara.
    painter gridAlign:(bindings at:#alignToGrid) value.
    painter gridShown:(bindings at:#showGrid) value.

    settings at: #GridShown  put: (bindings at:#showGrid) value.
    settings at: #GridAlign  put: (bindings at:#alignToGrid) value.
    settings at: #HGridSpace put: hspace.
    settings at: #VGridSpace put: vspace.
    painter clearView.

    "Modified: / 4.2.1999 / 15:36:34 / cg"
!

doEditList:listSelector
    "browse or create the aspect method as entered in the field (button beside input fieled pressed)"

    |spec list editor|

    self acceptOrIgnoreSectionModification.

    UIListEditor isNil ifTrue:[^ self].

    spec := painter specForSelection.
    spec isNil ifTrue:[^ self].

    "Kludge: subject - fetch the AspectAdaptor behind the TypeConverter"
    list := (specTool aspectFor:listSelector) subject value.
    list isNil ifTrue:[
        list := #()
    ].

    editor := UIListEditor new.
    editor
        informationLabel:'Edit List';
        list:list;
        useSymbols:(list notEmpty and:[list conform:[:e| e isSymbol]]);    "set use symbols, if all elements are symbols"
        open.


    editor accepted ifTrue:[
        "Kludge: subject - fetch the AspectAdaptor behind the TypeConverter"
        (specTool aspectFor:listSelector) subject value:editor list.
    ].
!

doGenerateAspectMethodFor
    |cls aspectList displayedList selectorsToGenerateCode 
     doBrowse methods|

    self askForSectionModification.

    cls := self painter targetClass.

    aspectList := OrderedCollection new.

    self painter aspectSelectorsAndTypesDo:[:selector :type |
            |newEntry|

            ( #(#modelAspect channelAspect actionSelector valueSelector) includes:type) ifTrue:[
                ((cls canUnderstand:selector) or:[cls class canUnderstand:selector]) ifFalse:[
                    newEntry := Array with:selector with:type.    
                    (aspectList includes:newEntry) ifFalse:[    
                        aspectList add:newEntry.
                    ]
                ]
            ]
        ].
    
    aspectList isEmpty ifTrue:[
        self information:'All aspect methods exist.'.
        ^ self.
    ].

    aspectList sort:[:a :b | a first < b first].
    displayedList := aspectList collect:[:entry | (((entry first) paddedTo:25) contractTo:25) , ' -> ' , entry second ].
    aspectList := aspectList collect:[:each | each first].

    doBrowse := false.    
    selectorsToGenerateCode := Dialog
        choose:'Select aspect(s) for which code shall be generated:' 
        fromList:displayedList 
        values:aspectList 
        initialSelection:nil
        buttons:nil 
        values:nil 
        lines:15 
        cancel:nil 
        multiple:true
        postBuildBlock:[:dialog | 
                            |b|

                            b := Button label:'Generate & Browse'.
                            b action:[doBrowse := true. dialog okPressed].
                            b := dialog addButton:b before:dialog okButton.
                       ].

    selectorsToGenerateCode isEmptyOrNil ifTrue:[^ self].

    self doGenerateAspectMethodsForAll:selectorsToGenerateCode.

    "/ refetch - cls is now obsolete
    cls := self painter targetClass.

    doBrowse ifTrue:[
        methods := selectorsToGenerateCode 
                        collect:[:sel | cls compiledMethodAt:sel]
                        thenSelect:[:m | m notNil].

        UserPreferences systemBrowserClass 
            browseMethods:methods 
            title:'Some Aspect methods'.
    ].
!

doGenerateAspectMethods
    "generates aspect and action methods for the application class"

    self askForSectionModification.
    self withWaitCursorDo:[
        |code|

        code := self painter generateAspectMethodCode.
        Class packageQuerySignal answer:painter targetClass package do:[
            code readStream fileIn.
        ]
    ]

    "Modified: / 28-01-2014 / 21:56:03 / cg"
!

doGenerateAspectMethodsForAll:selectorsToGenerateCode
    |code|

    code := self painter generateAspectMethodCodeFiltering:selectorsToGenerateCode.
    Class packageQuerySignal answer:painter targetClass package do:[
        code readStream fileIn.
    ]

    "Modified: / 28-01-2014 / 21:56:06 / cg"
!

doGenerateAspectSelectorsMethod
    "generates aspectSelectors method for the exported aspects"

    |aspectSelectorsAsString|

    self askForSectionModification.
    aspectSelectorsAsString := self painter generateAspectSelectorsMethod.
    aspectSelectorsAsString notEmptyOrNil ifTrue:[
        Class packageQuerySignal answer:painter targetClass package do:[
            (ReadStream on:aspectSelectorsAsString) fileIn.
        ].
    ].

    "Modified: / 28-01-2014 / 21:56:09 / cg"
!

doGenerateHookMethods
    "generates hook methods for the application class"

    self askForSectionModification.

    Class packageQuerySignal answer:painter targetClass package do:[
        (ReadStream on:painter generateHookMethods) fileIn.
    ]

    "Modified: / 28-01-2014 / 21:56:13 / cg"
!

doGenerateMenuMethods
    "generates menu stub methods for the application class"

    self askForSectionModification.

    Class packageQuerySignal answer:painter targetClass package do:[
        (ReadStream on:painter generateMenuMethods) fileIn.
    ]

    "Created: / 23-08-1998 / 16:10:04 / cg"
!

doInspectSpec
    "opens an inspector on the spec of the selected widget"

    |spec|

    (spec := self painter specForSelection) isNil ifTrue:[
        treeView isCanvasSelected ifTrue:[
            spec := treeView canvasSpec.
        ]
    ].
    spec notNil ifTrue:[
        spec inspect.
    ]
!

doInspectView
    "opens an inspector on the view of the selected widget"

    |selection|

    ((selection := self painter selection) isCollection and: [selection size >= 1]) ifTrue:[
        selection first inspect
    ] ifFalse: [
        selection inspect
    ]

!

doInstallAsWebPage
    "lets user select a service, page-name and installs the page"

    |runningServerPorts again serviceOrPort pageName port serviceLinkName service server app|

    runningServerPorts := (HTTPServer runningServers collect:[:s | s port printString]) asOrderedCollection sort.
    serviceOrPort := lastPort ? LastPort ? '8080'.
    pageName := lastPage ? LastPage ? 'myPage'.

    [
        again := false.

        aspects at:#serviceOrPortNameChannel put:serviceOrPort printString  asValue.
        aspects at:#pageNameNameChannel      put:pageName printString asValue.
        aspects at:#runningServerPorts       put:runningServerPorts.

        (self openDialogInterface:#dialogSpecForDefiningPortAndPageName) ifFalse:[^ nil].

        port := Integer readFrom:(aspects at:#serviceOrPortNameChannel) value onError:nil.
        port isNil ifTrue:[
            serviceLinkName := (aspects at:#serviceOrPortNameChannel) value.
            service := HTTPPortalService allSubInstances select:[:s | s linkName = serviceLinkName].
            service notEmptyOrNil ifTrue:[
                again := false.
                service := service first.    
            ] ifFalse:[
                Dialog warn:'No such service'
            ].
        ] ifFalse:[
            server := HTTPServer serverOnPort:port.
            service := server 
                        serviceForLink:'/portal'
                        ifAbsent:[
                            service := HTTPPortalService new.
                            service linkName:'/portal'.
                            service class unRegisterServiceOn:server.
                            service registerServiceOn:server.
                        ].
        ].

        pageName := (aspects at:#pageNameNameChannel) value.
    ] doWhile:[again].

    lastPage := LastPage := pageName.
    lastPort := LastPort := port.

    app := self specClass new.
    app webLink:pageName.
    app service:service.
    app defineInterface:(self specSelector).
    app addToService.

"/    self clearModifiedFlag.
"/    self helpTool buildAndMergeFromClass:specClassName.
    self updateInfoLabel

    "Modified: / 15-01-2008 / 14:18:53 / cg"
!

doLoad
    "opens a ResourceSelectionBrowser for loading a window spec from a class"

    self askForModification ifFalse: [^nil].

    self loadFromMessage: 
        (ResourceSelectionBrowser
            request: 'Load Window Spec from Class'
            onSuperclass: nil
            andClass: self specClass
            andSelector: specSelector ? #windowSpec
            withResourceTypes: #(canvas))

    "Modified: / 31-08-2006 / 10:14:01 / cg"
!

doLoadSubspec
    "opens a ResourceSelectionBrowser for loading a sub spec from a class"

    |classAndSelector class selector|

    self askForSectionModification.

    classAndSelector := ResourceSelectionBrowser
            request: 'Load Subspec from Class'
            onSuperclass: nil
            andClass: self specClass
            andSelector: specSelector
            withResourceTypes: #(canvas).

    classAndSelector isNil ifTrue:[^ self].
    class := classAndSelector methodClass.
    selector := classAndSelector methodSelector.
    (class == specClassName and: [selector == specSelector]) ifTrue: [
        self warn: 'Current interface as subspec not allowed!!'.
        ^ self.
    ].
    (class respondsTo:selector) ifTrue:[
        self addWidgetOfSpec:(Array with: (UISubSpecification new majorKey: class name; minorKey: selector))
    ]

    "Modified: / 31-08-2006 / 10:13:56 / cg"
!

doNew
    "removes all widgets, specClass, and specSelector"

    self askForModification ifFalse: [^nil].
    specClass := specClassName := specSelector := nil.
    self painter removeAll.
"/ self halt.
    treeView canvas topView 
        name:  self defaultNameOfCanvas;
        label: self defaultNameOfCanvas.
    self helpTool doNew.
    self treeSelectionChanged.
    treeView selectedNode changed.
    self tabModel value: self tabList value first.
    self updateInfoLabel.

    "Modified: / 31-08-2006 / 10:14:10 / cg"
!

doOpenAspectClassChooserFor: aspect
    "open a class chooser; when ok, set the aspect to its name
     sent by embedded ui-slice's '...'-class button (for example, subcanvasSpec)."

    | spec className class choice|

    spec := painter specForSelection.
    spec isNil ifTrue:[ self error: 'No spec!!'.].      
    className := spec perform: aspect.
    class := self resolveName: className inClass: specClass.
    choice := Dialog requestClassName:'Choose class' initialAnswer:(class isNil ifTrue:nil ifFalse:[class name]).
    choice isEmptyOrNil ifTrue:[^ self ].

    spec perform: (aspect asMutator) with:choice.
    (specTool aspectFor:aspect) value:choice.
!

doOpenWidgetDocumentation
    "opens documentation for the selected widget"

    |spec document|

    (spec := self specForSelection) isNil ifTrue:[
"/        treeView isCanvasSelected ifTrue:[
"/            spec := nil
"/        ]
    ].
    spec notNil ifTrue:[
        document := 'tools/uipainter/', spec documentFileName,'.html'
    ] ifFalse: [
        document := 'tools/uipainter/WindowSpec.html'
    ].
    HTMLDocumentView openFullOnDocumentationFile: document 
!

doPickAView
    "changes the cursor for picking a view and builds a window spec from it"

    |view|

    self askForModification ifFalse: [^nil].

    (view := Screen current viewFromUser) notNil ifTrue:[
        view == Screen current rootView ifFalse:[
            self painter setupFromSpec:(UISpecification fromView:view topView).
        ]
    ].

    self updateInfoLabel

!

doSave
    "saves the window spec"
    
    |code painter specClass extentUsed|

    self askForSectionModification.
    self hasSpecClassAndSelector ifFalse:[
        self doDefineClassAndSelector isNil ifTrue:[
            ^ nil
        ]
    ].

    specClass := self resolveName:specClassName.
    (specClass notNil and:[ specClass isClass ]) ifFalse:[
        self warn:('Oops - cannot save. Class not found: ' , specClassName).
        ^ nil
    ].
    ApplicationModel forgetDefaultExtentFor:specClass.

    painter := self painter.
    painter 
        class:specClass
        superclassName:specSuperclassName
        selector:specSelector.

"/    Transcript showCR:'generating windowSpec code...'.

    extentUsed := self canvas extent.
    (extentUsed > (1024 @ 768)) ifTrue:[
        Dialog 
            warn:(resources
                stringWithCRs:'The application''s default window-size is taken from the current size and will be %1.\\This may be too large for some displays - if required, resize and save again.'
                with:extentUsed printString allBold)
    ].
    (self canvas maxExtent notNil
    and:[ extentUsed > self canvas maxExtent ]) ifTrue:[
        Dialog 
            warn:(resources
                stringWithCRs:'The window-size is larger than its max-extent.\\This may lead to trouble (lost extent) later. I suggest removal of the max or resizing.'
                with:extentUsed printString allBold)
    ].

    code := painter generateWindowSpecMethodSource.
    Class packageQuerySignal answer:specClass package do:[
        (ReadStream on:code) fileIn.
    ].
    self doGenerateAspectSelectorsMethod.
    self helpTool doSave.
    self updateInfoLabel.
    self clearModified.
    painter resetModification.
    (specClass respondsTo:specSelector) ifTrue:[
        self addHistoryEntryForClass:specClass selector:specSelector.
    ].

    "Modified: / 28-01-2014 / 21:52:32 / cg"
!

doSaveAs
    "opens a ResourceSelectionBrowser for saving the window spec on a class"

    |classAndSelector|

    self askForSectionModification.
"/    self hasSpecClassAndSelector ifTrue:[
"/        self askForModification ifFalse:[^ false].
"/    ].

    classAndSelector := ResourceSelectionBrowser
            request: 'Save Window Spec in Class'
            onSuperclass: #Object
            andClass: (specClassName ? #ApplicationModel) asSymbol
            andSelector: specSelector ? #windowSpec
            withResourceTypes: #(canvas).

    classAndSelector isNil ifTrue:[^ false].

    self clearModified.
    self painter resetModification.

    specClass := classAndSelector methodClass.
    specClassName := classAndSelector methodClass name.
    specSelector := classAndSelector methodSelector.
    specSuperclassName := specClass superclass name.
    self doSave.
    ^ true
!

doSaveElementSpecAs
    "opens a ResourceSelectionBrowser for saving a spec for the selected
     elements on a class.
     Useful to save parts for refactoring a spec into
     subSpecifications, for example when putting parts into a tab"

    |spec fullSpec classAndSelector subSpecClass subSpecClassName subSpecSelector code|

    self askForSectionModification.

    (spec := self painter specForSelection) isNil ifTrue:[
        self warn:('Select a single item first').
        ^ false
    ].

    classAndSelector := ResourceSelectionBrowser
            request: 'Save Subspec in Class'
            onSuperclass: #Object
            andClass: specClassName
            andSelector: #subSpec
            withResourceTypes: #(canvas).

    classAndSelector isNil ifTrue:[^ false].

    self clearModified.
    self painter resetModification.

    subSpecClass := classAndSelector methodClass.
    subSpecClassName := classAndSelector methodClass name.
    subSpecSelector := classAndSelector methodSelector.

    subSpecClass := self resolveName:subSpecClassName.
    (subSpecClass notNil and:[ subSpecClass isClass ]) ifFalse:[
        self warn:('Oops - cannot save - class not found: ' , subSpecClassName).
        ^ false
    ].

    spec := painter fullSpecFor:(painter singleSelection).

    fullSpec := treeView generateFullSpecForComponents:(Array with:spec) named:subSpecSelector asUppercaseFirst.
    code := painter generateWindowSpecMethodSourceFor:fullSpec class:subSpecClassName selector:subSpecSelector.
    Class packageQuerySignal answer:subSpecClass package do:[
        (ReadStream on:code) fileIn.
    ].
    ^ true

    "Modified: / 28-01-2014 / 21:53:35 / cg"
!

doSelectAspectMethod:aspectSelector
    "open a dialog to select an existing aspect method and enter in the field"

    self doSelectAspectMethod:aspectSelector nameAs:aspectSelector
!

doSelectAspectMethod:aspectSelector nameAs:aspectNameShown
"/    |cls spec aspect code|
"/
"/    cls := self specClass.
"/    cls isNil ifTrue:[
"/        Dialog information:'No Application Class defined.'.
"/        ^ self
"/    ].
"/
"/    spec := painter specForSelection.
"/    spec isNil ifTrue:[^ self].
"/    aspect := spec perform:aspectSelector.
"/    aspect isNil ifTrue:[
"/        Dialog information:(resources 
"/                                string:'Please enter a Method name for "%1" first.'
"/                                with:(resources string:aspectNameShown) allBold).
"/        ^ self
"/    ].
"/        
"/    (cls implements:aspect asSymbol) ifFalse:[
"/        (Dialog confirm:(resources 
"/                            stringWithCRs:'%1 does not implement %2.\\Create ?'
"/                            with:(cls name allBold)
"/                            with:aspect allBold)) 
"/        ifFalse:[
"/            (Dialog confirm:(resources 
"/                                stringWithCRs:'Browse implementors of %1 ?'
"/                                with:aspect allBold)) 
"/            ifTrue:[
"/                UserPreferences current systemBrowserClass browseImplementorsOf:aspect
"/            ].
"/            ^ self
"/        ].
"/        code := painter
"/            generateAspectMethodFor:aspect 
"/            spec:nil 
"/            inClass:cls.
"/        code readStream fileIn.
"/    ].
"/    UserPreferences current systemBrowserClass openInClass:cls selector:aspect
!

doSortItems
    "sort the selected items by position"

    treeView doSortItems
!

doStartApplication
    "starts the application on the editing window spec"

    |cls application|

    self hasSpecClassAndSelector ifFalse:[
        self doSave isNil ifTrue: [^nil].
    ] ifTrue: [
        self askForSectionModification.    
        (modified or: [self painter isModified or: [self helpTool modified]])
        ifTrue:
        [
            ((YesNoBox title:'Window Spec was modified!!')        
                noText:'Cancel';
                yesText:'Save it and start';
                showAtPointer;
                accepted) ifFalse: [^nil].
            self doSave isNil ifTrue: [^nil]
        ]
    ].

    cls := self resolveName:specClassName.
    cls isNil ifTrue:[
        self warn:'Oops cannot start application - no class:' , specClassName.
        ^ nil
    ].
    application := cls new.
    (application respondsTo:#openInterface:) ifFalse:[
        (self confirm:('The application does not respond to the ''openInterface:'' message.\(maybe the spec is supposed to be used as subApplication/subCanvas)\\Shall I try to open this as a standAlone dialog ?') withCRs)
        ifTrue:[
            SimpleDialog new openSpec:(cls perform:specSelector) withBindings:nil.
        ].
        ^ self.
    ].        
    application openInterface:specSelector
!

doStepDown
    "moves the selected widget(s) one step down in the hierarchy"

    treeView doStepOver:1
!

doStepIn
    "moves the selected widget into the next widget as child"

    treeView doStepIn
!

doStepOut
    "moves the selected widget out of the parent widget"

    treeView doStepOut
!

doStepUp
    "moves the selected widget(s) one step up in the hierarchy"

    treeView doStepOver:-1
!

doWindowSpec
    "opens a code view with the contents of the window spec"

    self askForSectionModification.

    CodeView 
        openWith: self painter generateWindowSpecMethodSource 
        title: 'Window Spec'

! !

!UIPainter::ApplicationClassQuery class methodsFor:'documentation'!

documentation
    "This Query answers the application class, that is currently being edited"
! !

!UIPainter::TreeView class methodsFor:'documentation'!

documentation
"
    selection in tree view; only used by the UIPainter

    [see also:]
        SelectionInTreeView
        SelectionInTree
        TreeItem
        UIPainter

    [author:]
        Claus Atzkern
"


! !

!UIPainter::TreeView methodsFor:'accessing'!

canvas
    "returns the canvas (UIPainterView)"

    ^ model root contents view


!

canvas:aCanvas
    "install canvas (UIPainterView)"

    self canvas:aCanvas specName:nil
!

canvas:aCanvas specName:nameOfSpec
    "install canvas (UIPainterView)"

    |props|

    props := UIPainterView::ViewProperty new.
    props view:aCanvas.

    model root:(TreeItem 
                    name:(nameOfSpec ? painter defaultNameOfCanvas) allBold 
                    contents:props).

    model root expand.
    self enableChannel:(aCanvas enableChannel).
!

canvasSpec
    "returns spec assigned to canvas"

    |spec list cls canvas|

    spec := self windowSpecClass new.
    canvas := self canvas.

    spec fromView:(canvas topView) callBack:nil.

    windowSpec notNil ifTrue:[
        spec copyValuesFromSpec:windowSpec.
    ].

    spec exportedAspects isNil ifTrue:[
        (     (cls  := canvas className) notNil
         and:[(cls  := canvas resolveName:cls) notNil]
        ) ifTrue:[
            list := cls perform:#aspectSelectors ifNotUnderstood:nil.
        ].
        spec setExportedAspectsFrom:list.
        windowSpec notNil ifTrue:[
            windowSpec exportedAspects:(spec exportedAspects).
        ]
    ].

    self propertiesDo:[:aProp| 
        |propsSpec|

        spec exportedAspectsAddKey:(aProp model) type:nil.
        propsSpec := aProp spec.
        propsSpec aspectSelectors 
                select:[:a | a isString or:[a isSymbol]] 
                thenDo:[:aKey|spec exportedAspectsAddKey:aKey type:nil].
        propsSpec actionSelectors 
                select:[:a | a isString or:[a isSymbol]] 
                thenDo:[:aKey|spec exportedAspectsAddKey:aKey type:#action].
    ].
  ^ spec
!

canvasSpec:aSpec
    "update canvas from spec"

    |spec|

    self setAttributesFromWindowSpec:aSpec.
    spec := aSpec copy.
    spec  menu:nil.
    spec flags:nil.

    spec setAttributesIn:(self canvas "topView") with:(UIBuilder new isEditing:true).
!

exportedAspects
    "returns spec assigned to canvas"

    windowSpec isNil ifTrue:[^ #()].
    ^ windowSpec exportedAspects ? #()

!

itemOfView:aView
    "returns item assigned to view or nil"

    aView notNil ifTrue:[
        self allItemsDo:[:anItem|
            (anItem contents view == aView) ifTrue:[^ anItem]
        ]
    ].
    ^ nil


!

lastDrawnMaster
    "returns the lastDrawnMaster"

    ^ lastDrawnMaster


!

painter
    ^ painter
!

painter:something
    painter := something.
!

windowSpecClass
    "returns the default  windowSpecClass (WindowSpec)"

    ^ windowSpecClass ? WindowSpec
!

windowSpecClass:aClass
    "set the default windowSpecClass"

    windowSpecClass := aClass
! !

!UIPainter::TreeView methodsFor:'accessing-property'!

propertiesDo:aOneArgBlock
    "evaluates the argument a block on each property"

    self allItemsDo:[:anItem| aOneArgBlock value:(anItem contents)]


!

propertyDetect:aOneArgBlock
    "evaluates the block on each property"

    self allItemsDo:[:anItem|
        (aOneArgBlock value:(anItem contents)) ifTrue:[^ anItem contents]
    ].
    ^ nil

!

propertySelected
    "returns current selected property or nil in case of multi selection
     or empty selection "

    |idx|

    selection size == 1 ifTrue:[
        (idx := selection first) ~~ 1 ifTrue:[          "canvas: not yet supported"
            ^ (listOfNodes at:idx) contents
        ]
    ].
    ^ nil

! !

!UIPainter::TreeView methodsFor:'adding & removing'!

addProperty:aProperty
    "adds a new item"

    ^ self addProperty:aProperty beforeIndex:nil.
!

addProperty:aProperty beforeIndex:anIndex
    "adds a new item"

    |parent treeItem index| 

    parent := self detectItemCorespondingToView:(aProperty view superView).
    parent isNil ifTrue:[^ nil ].

    treeItem := TreeItem new contents:aProperty.
    index := parent numberOfChildren + 1.

    (anIndex notNil and:[anIndex > 0]) ifTrue:[
        index := anIndex min:index.
    ].
    model add:treeItem beforeIndex:index below:parent.
    ^ treeItem
!

removeAll
    "removes all items other than canvas"

    lastDrawnMaster := nil.
    windowSpec := nil.

    self canvas components copy do:[:aView|
        aView destroy
    ].
    self canvas subViews copy do:[:aView|
        "/ care to not destroy the transparent input view
        (aView isInputOnly) ifFalse:[aView destroy]
    ].
    model root name: painter defaultNameOfCanvas allBold.
    model removeAllOtherThanRoot.
!

removeView:aView
    "removes a view"

    |item prnt|

    ((item := self itemOfView:aView) notNil and:[(prnt := item parent) notNil]) ifTrue:[
        aView destroy.
        prnt contents view sizeChanged:nil.
        model remove:item
    ]


! !

!UIPainter::TreeView methodsFor:'building'!

generateFullSpecForComponents:aSpecArray named:specNameSymbol
    "generates a full spec from aSpecArray"

    |fullSpec winSpec|

    fullSpec := FullSpec new.
    fullSpec name:specNameSymbol.

    fullSpec fromBuilder:(self canvas)
              components:(SpecCollection new collection:aSpecArray).

    winSpec := fullSpec window.
    windowSpec isNil ifTrue:[
        "/ kludge: if grid was on, its now present in the windowSpec (which should not)
        self canvas gridShown ifTrue:[
            fullSpec window backgroundColor:nil.    
        ].
    ] ifFalse:[
        winSpec copyValuesFromSpec:windowSpec.
    ].    
    winSpec name: winSpec label.
    ^ fullSpec.
!

setAttributesFromWindowSpec:aWindowSpec
    "sets a window spec from aWindowSpec and applies some attributes
     to the canvas."

    |name canvasView builder|

    windowSpec := (self windowSpecClass) new copyValuesFromSpec:aWindowSpec.
    canvasView := self canvas.

    builder := UIBuilder new isEditing:true.
    aWindowSpec setAttributesIn:canvasView with:builder.

    name := aWindowSpec label.
    canvasView topView name:name.
    self canvasNameChanged:name.
    self application treeSelectionChanged.
! !

!UIPainter::TreeView methodsFor:'canvas selection'!

canvasSelection:aSelection
    "canvas changed its selection
    "
    |sel list size|

    ((sel := aSelection) isNil or:[sel isCollection]) ifFalse:[
        sel := Array with:sel
    ].

    (size := sel size) ~~ 0 ifTrue:[
        list := OrderedCollection new:size.

        sel do:[:aView|
            |item|

            (item := self itemOfView:aView) notNil ifTrue:[
                list add:item.
                model doMakeVisible:item.
            ]
        ].
        sel := list collect:[:anItem| self indexOfNode:anItem ].
    ].
    self canvasEventsDisabledDo:[ self selection:sel ].            
!

canvasSelectionAdd:aView
    "canvas adds a view to current selection
    "
    |item index oldSel|

    item := self itemOfView:aView.

    item notNil ifTrue:[
        model doMakeVisible:item.

        (index := self indexOfNode:item) ~~ 0 ifTrue:[
            oldSel := selection copy.
            self addToSelection:index.
            self selectionChangedFrom:oldSel
        ]        
    ]            
!

canvasSelectionRemove:aView
    "canvas removes a view from current selection
    "
    |item index oldSel|

    (     (item := self itemOfView:aView) notNil
     and:[(index := self indexOfNode:item) ~~ 0
     and:[self isInSelection:index]]
    ) ifTrue:[
        oldSel := selection copy.
        self removeFromSelection:index.
        self selectionChangedFrom:oldSel.
    ].
!

selectedViews
    ^ self selection 
        collect:[:index |
            |node view|

            node := listOfNodes at:index.
            view := node contents view.
            view
        ]
! !

!UIPainter::TreeView methodsFor:'change & update'!

canvasNameChanged:aName
    "called if identification name assigned to window (canvas) changed
    "
    |name node|

    node := listOfNodes at:1.

    (    aName size ~~ 0
     and:[(name := aName string withoutSeparators) size ~~ 0
     and:[(self propertyDetect:[:p| p name = name]) isNil
     and:[node name ~= name]]]
    ) ifTrue:[
        node name: name allBold.
        node changed.   
    ].
!

layoutChanged
    "layout of any component changed; in case of single selection, the
     application will be informed to update its layout
    "
    selection size == 1 ifTrue:[
        self application layoutChanged
    ]


!

propertyChanged:aProperty
    "property of view derived from argument a property changed
    "
    |item idx end|

    item := self itemOfView:(aProperty view).

    item notNil ifTrue:[
        item contents:aProperty.

        item name = aProperty name ifFalse:[
            idx := self firstLineShown.

            (end := self lastLineShown) > listOfNodes size ifTrue:[
                end := listOfNodes size
            ].                          
            item changed.   

            [idx <= end] whileTrue:[
                (listOfNodes at:idx) == item ifTrue:[
                    self redrawLine:idx.                "/ is visible; redraw line
                    end := 0
                ] ifFalse:[
                    idx := idx + 1
                ]
            ]
        ].

        self selectedNode == item ifTrue:[              "/ inform application
            self application propertyChanged
        ]
    ].


! !

!UIPainter::TreeView methodsFor:'drag & drop'!

canDrop:aDropContext
    "can drop ? -> delegate to canvas"

    ^ self canvas canDrop:aDropContext

    "Modified: / 13-10-2006 / 16:08:43 / cg"
!

canDrop:aDropContext at:aPoint
    "can drop ? -> delegate to canvas"

    ^ self canvas canDrop:aDropContext at:aPoint

    "Created: / 13-10-2006 / 12:35:53 / cg"
    "Modified: / 13-10-2006 / 16:08:46 / cg"
!

canDropObjects:aCollectionOfDropObjects
    "can drop ? -> delegate to canvas"

    ^ self canvas canDropObjects:aCollectionOfDropObjects

    "Created: / 13-10-2006 / 16:08:31 / cg"
!

canDropObjects:aCollectionOfDropObjects at:aPoint
    "can drop ? -> delegate to canvas"

    ^ self canvas canDropObjects:aCollectionOfDropObjects at:aPoint

    "Created: / 13-10-2006 / 16:08:35 / cg"
!

drop:aDropContext
    "drop objects -> delegate to canvas"

    self canvas drop:aDropContext

    "Created: / 13-10-2006 / 12:35:59 / cg"
    "Modified: / 13-10-2006 / 16:09:04 / cg"
!

drop:aDropContext at:aPoint
    "drop objects -> delegate to canvas"

    self canvas drop:aDropContext at:nil

    "Modified: / 13-10-2006 / 16:09:07 / cg"
!

dropObjects:aCollectionOfDropObjects
    "drop objects -> delegate to canvas"

    self canvas dropObjects:aCollectionOfDropObjects

    "Created: / 13-10-2006 / 16:08:51 / cg"
!

dropObjects:aCollectionOfDropObjects at:aPoint
    "drop objects -> delegate to canvas"

    self canvas dropObjects:aCollectionOfDropObjects at:nil

    "Created: / 13-10-2006 / 16:08:56 / cg"
! !

!UIPainter::TreeView methodsFor:'enumerating'!

allItemsDo:aOneArgBlock
    "evaluates the argument a block on each item other than the canvas"

    model root allChildrenDo:aOneArgBlock


! !

!UIPainter::TreeView methodsFor:'event handling'!

canvasEventsDisabledDo:aBlock
    "evaluates the block without raising selection changed notifications to canvas"

    |restoreCanvasEvents|

    restoreCanvasEvents  := canvasEventsDisabled.
    canvasEventsDisabled := true.
    aBlock value.
    canvasEventsDisabled := restoreCanvasEvents.
!

doubleClicked
    "disables collapsing of the root item"

    self selectedNode == model root ifFalse:[
        super doubleClicked
    ]


!

redrawLabelAt:x y:yTop index:anIndex
    "draws a tiny rectangle for indicating the master node (first selected node)"

    |dX|

    super redrawLabelAt:x y:yTop index:anIndex.

    ((selection size > 1) and: [selection first == anIndex]) ifTrue:[
        dX := textInset - 1.
        self paint:(Color red). "/ self application painter handleMasterColor.
        self fillRectangleX:(x - dX - 2)
                          y:yTop + ((fontHeight - dX) // 2)
                      width:dX
                     height:dX
    ]
! !

!UIPainter::TreeView methodsFor:'initialization'!

iconForNode:aNode
    |spec|       

    spec := aNode contents spec.
    spec isNil ifTrue: [
        ^ WindowSpec icon
    ] ifFalse:[
        ^ spec icon
    ]
!

initialize
    "initialize the tree view; multiple select and tree item actions"

    super initialize.

    self multipleSelectOk:true.
    canvasEventsDisabled := false.
    self showDirectoryIndicator: true.
    self showDirectoryIndicatorForRoot: false.

    self model 
        iconAction:[:aNode| self iconForNode:aNode];
        labelAction: [:aNode | self labelForNode:aNode].
!

labelForNode:aNode
    |spec|

    spec := aNode contents spec.
    spec notNil ifTrue: [
        ^ self nameForSpecInList:spec
    ] ifFalse:[
        ^ aNode name
    ]
! !

!UIPainter::TreeView methodsFor:'private'!

nameForSpecInList:aSpec
    "returns the tree item label for aSpec"

    |aspect aspectPrefix nameString viewClassString|

    nameString := aSpec name ? ''.
    viewClassString := '[',aSpec viewClass name,']' .

    aspect := aSpec nameOfMainAspect.
    aspect notNil ifTrue:[
        aspectPrefix := '(',aspect allBold ,') '
    ] ifFalse:[
        aspectPrefix := ''.
    ].

    ^ aspectPrefix, nameString, ': ', viewClassString

    "Modified: / 17-08-2011 / 09:10:31 / cg"
!

selectionChangedFrom:oldSelection
    "selection has changed. update master selection and raise notification
     to canvas in case of enabled cvs events
    "
    |sel size|

    super selectionChangedFrom:oldSelection.
    size := selection size.

    canvasEventsDisabled ifFalse:[
        (size ~~ 0 and:[size ~~ 1 or:[selection first ~~ 1]]) ifTrue:[
            sel := OrderedCollection new.

            selection do:[:i|
                i ~~ 1 ifTrue:[sel add:(listOfNodes at:i) contents view]
            ]
        ].
        self canvas updateSelectionFromModel:sel
    ].             
    size = 1 ifTrue:[
        oldSelection size > 1 ifTrue: [
            (listOfNodes at:lastDrawnMaster) retrieveLabel.
            self redrawLine: lastDrawnMaster. 
            lastDrawnMaster := selection first
        ]
    ].
    size > 1 ifTrue:[
        selection first ~~ lastDrawnMaster ifTrue: [
            (listOfNodes at:selection first) retrieveLabel.
            lastDrawnMaster notNil ifTrue: [(listOfNodes at:lastDrawnMaster) retrieveLabel].
            self redrawLine: lastDrawnMaster. 
            self redrawLine: (lastDrawnMaster := selection first)
        ]
    ]         
    ifFalse: [
        lastDrawnMaster := nil
    ] 
! !

!UIPainter::TreeView methodsFor:'queries'!

canChangeOrderInContainer
    "returns true if any selection exists and all widgets in the selection
     can change their layout through to a move or align operation"

"/ old code (only allow if a single item is selected):
"/
"/    ^(selection size == 1)  and: 
"/    [(selection at: 1) ~~ 1 and:   
"/    [self selectedNode parent children size > 1]] 

    ^ self selectedNodes 
        conform:[:eachSelectedNode |
            |parent|

            (parent := eachSelectedNode parent) notNil
            and:[parent children size > 1]
        ].
!

canExchangeSelectionLayouts 
    "returns true if the selections size is exactly 2
     and all widgets in the selection
     can change their layout through to a move or align operation"

    selection size == 2 ifFalse:[
        ^ false
    ].
    ^ self canMoveOrAlignSelection
!

canMoveOrAlignSelection
    "returns true if any selection exists and all widgets in the selection
     can change their layout through to a move or align operation"

    selection isEmptyOrNil ifTrue:[
        ^ false
    ].

    selection do:[:i|
        |node view|

        i == 1 ifTrue:[
            "/ the tree node for the canvas itself.
            ^ false
        ].
        node := listOfNodes at:i.
        view := node contents view.
        (self canvas canChangeLayoutOfView:view) ifFalse:[
            ^ false
        ]
    ].
    ^ true
!

canMoveSelectionIntoContainer
    "returns true in case that one widget is selected and can change its container
     widget to an element below"

    |item oldParentItem newParentItem idx|

    item := self selectedNode.
    (item notNil and:[(oldParentItem := item parent) notNil]) ifTrue:[
        idx := (oldParentItem indexOfChild:item) + 1.
        newParentItem := oldParentItem children detect:[:eachChild|
            eachChild contents spec class supportsSubComponents
        ] startingAt:idx ifNone:nil.
        ^ newParentItem notNil.
    ].

    ^ false
!

canMoveSelectionOutOfContainer
    "returns true in case that one widget is selected which is contained within
     another widget"

    |item prnt|

    (     (item := self selectedNode) isNil
      or:[(prnt := item parent) isNil
      or:[prnt parent isNil]]
    ) ifTrue:[
        ^ false
    ].
    ^ true
!

canResizeSelectedWidget
    "returns true in case of one widget selected and is contained
     within a widget which allows to resize sub components"

    |selectedNode|

    (selectedNode := self selectedNode) notNil ifTrue:[
        (selectedNode := selectedNode parent) notNil ifTrue:[
            ^ (selectedNode parent isNil or:[selectedNode contents spec class canResizeSubComponents])
        ]
    ].
    ^ false
!

canResizeSelection
    "returns true if all selected widgets can be resized"

    selection isEmptyOrNil ifTrue:[ ^ false ].
    ^ self canvas canResize:(self selectedViews)
!

hasMultipleSelectionOtherThanCanvas
    "returns true in case that any selection other than the canvas exists"

    ^ selection size > 0 and:[ (selection count:[:anyindex | anyindex ~~ 1]) > 1]
!

hasOneSelectionOtherThanCanvas
    "returns true in case that one selection exists other than the canvas"

    ^ selection size == 1 and:[selection first ~~ 1]
!

hasSelectionOtherThanCanvas
    "returns true in case that any selection other than the canvas exists"

    ^ selection size > 0 and:[selection contains:[:anyindex | anyindex ~~ 1]]
!

isCanvasSelected
    "returns true in case of a single selection and the
     selection is the canvas (index 1)"

    ^ selection size == 1 and:[self isInSelection:1]
! !

!UIPainter::TreeView methodsFor:'searching'!

detectItemCorespondingToView:aView
    "detects the item coresponding to the view. The item of the view or the first
     subview providing the item is returned. If no property is detected nil is
     returned"

    |view item|

    (view := aView) isNil ifTrue:[ ^ nil ].

    [(item := self itemOfView:view) isNil] whileTrue:[
        (view := view superView) isNil ifTrue:[^ listOfNodes at:1]
    ].
    ^ item
! !

!UIPainter::TreeView methodsFor:'user interaction'!

askForSelectionChangeAllowed 
    selectConditionBlock notNil ifTrue:[
        ^ selectConditionBlock value:nil 
    ].
    ^ true
!

doChangeParentOfSelectedItemTo:newParentItem

    |canvas|

    newParentItem isNil ifTrue:[
        ^ self
    ].
    self askForSelectionChangeAllowed ifFalse:[^ self].    
    self setSelection:nil.

    canvas := self canvas.
    canvas deleteSelection.
    canvas setSelection:(newParentItem contents view) withRedraw:false.
    canvas pasteWithLayout.
!

doSortItems
    "sort items by their top-left position"

    |selectedItems parent sortedItems newChildren itemList parentView|

    self askForSelectionChangeAllowed ifFalse:[^ self].

    selectedItems := self selectedNodes.
    selectedItems size <= 1 ifTrue:[^ self].
    parent := selectedItems first parent.
    (parent isNil or:[(selectedItems conform:[:e| e parent == parent]) not]) ifTrue:[^ self].

    sortedItems := selectedItems sort:[:a :b| 
                            a contents view origin isLeftOrAbove:(b contents view origin)].
    itemList := selectedItems asIdentitySet.

    newChildren := parent children collect:[:eachChild|
        (itemList includes:eachChild) ifTrue:[
            sortedItems removeFirst.
        ] ifFalse:[
            eachChild.
        ].
    ].

    self setSelection:nil.
    model remove:parent children.
    model add:newChildren beforeIndex:1 below:parent.

    parentView := parent contents view.

    self canvas hideSelection.
    newChildren keysAndValuesDo:[:idx :eachItem|
        parentView changeSequenceOrderFor:eachItem contents view to:idx.
    ].
    parentView specClass isLayoutContainer ifFalse:[
        parentView components notEmptyOrNil ifTrue:[ self halt ].
        parentView subViews do:[:v| v raise ].
    ].
    self canvas showSelection.

    self selectNodes:itemList asOrderedCollection.
!

doStep:item over:anIndex
    "moves a single child 'anIndex' forward or backward in list of children.
     positive index: move down; negative index: move up"

    |idx size parentItem parentItemsView itemsView canvas prevSelection|

    self askForSelectionChangeAllowed ifFalse:[^ self].

    (    item isNil
     or:[(parentItem := item parent) isNil
     or:[(size := parentItem children size) < 2
     or:[(idx  := parentItem indexOfChild:item) == 0]]]
    ) ifTrue:[
        ^ self
    ].

    idx := idx + anIndex.

    idx < 1 ifTrue:[idx := size]
           ifFalse:[idx > size ifTrue:[idx := 1]].

    prevSelection := self selectedNodes.
    self setSelection:nil.

    model remove:item.
    model add:item beforeIndex:idx below:parentItem.

    idx := parentItem indexOfChild:item.
    itemsView := item contents view.
    parentItemsView := parentItem contents view.

    canvas := self canvas.
    canvas hideSelection.

    itemsView isView ifFalse:[
        "/ a component - has its own collection (and therefore indexing) - sigh
        idx := idx - ((1 to:idx-1) count:[:i | (parentItem children at:i) contents view isView]).
        parentItemsView changeSequenceOrderFor:itemsView to:idx.
    ] ifTrue:[
        "/ a view - has its own collection (and therefore indexing) - sigh
        idx := idx - ((1 to:idx-1) count:[:i | (parentItem children at:i) contents view isView not]).
        parentItemsView changeSequenceOrderFor:itemsView to:idx.
    ].

    parentItemsView specClass isLayoutContainer ifFalse:[
        "/ spVw components notEmptyOrNil ifTrue:[ self halt ].
        parentItemsView subViews do:[:v| v raise ].
    ].
    self selectNodes:prevSelection.
    canvas showSelection.
!

doStepIn
    "move the currently selected widget into the next available container below"
    
    |item oldParentItem newParentItem idx|

    item := self selectedNode.
    (item notNil and:[(oldParentItem := item parent) notNil]) ifTrue:[
        idx := (oldParentItem indexOfChild:item) + 1.
        newParentItem := oldParentItem children 
                    detect:[:eachChild | eachChild contents spec class supportsSubComponents]
                    startingAt:idx
                    ifNone:nil.
        newParentItem notNil ifTrue:[
            self doChangeParentOfSelectedItemTo:newParentItem
        ].
    ]
!

doStepOut
    |item|

    item := self selectedNode.    
    (item notNil and:[(item := item parent) notNil]) ifTrue:[
        self doChangeParentOfSelectedItemTo:(item parent)
    ].
!

doStepOver:anIndex
    "moves child 'anIndex' forward or backward in list of children"

    |item idx size parentItem parentItemsView itemsView canvas|

    self askForSelectionChangeAllowed ifFalse:[^ self].

    anIndex < 0 ifTrue:[
        "/ moving up
        self selectedNodes do:[:eachNode |
            self doStep:eachNode over:anIndex.
        ].
    ] ifFalse:[
        "/ moving down
        self selectedNodes reverseDo:[:eachNode |
            self doStep:eachNode over:anIndex.
        ].
    ].
    ^ self.

    (    (item := self selectedNode) isNil
     or:[(parentItem := item parent) isNil
     or:[(size := parentItem children size) < 2
     or:[(idx  := parentItem indexOfChild:item) == 0]]]
    ) ifTrue:[
        ^ self
    ].

    idx := idx + anIndex.

    idx < 1 ifTrue:[idx := size]
           ifFalse:[idx > size ifTrue:[idx := 1]].

    self setSelection:nil.
    model remove:item.
    model add:item beforeIndex:idx below:parentItem.

    idx := parentItem indexOfChild:item.
    itemsView := item contents view.
    parentItemsView := parentItem contents view.

    canvas := self canvas.
    canvas hideSelection.

    itemsView isView ifFalse:[
        "/ a component - has its own collection (and therefore indexing) - sigh
        idx := idx - ((1 to:idx-1) count:[:i | (parentItem children at:i) contents view isView]).
        parentItemsView changeSequenceOrderFor:itemsView to:idx.
    ] ifTrue:[
        "/ a view - has its own collection (and therefore indexing) - sigh
        idx := idx - ((1 to:idx-1) count:[:i | (parentItem children at:i) contents view isView not]).
        parentItemsView changeSequenceOrderFor:itemsView to:idx.
    ].

    parentItemsView specClass isLayoutContainer ifFalse:[
        "/ spVw components notEmptyOrNil ifTrue:[ self halt ].
        parentItemsView subViews do:[:v| v raise ].
    ].
    canvas showSelection.
    self selectNode:item.
! !

!UIPainter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


UIPainter initialize!
