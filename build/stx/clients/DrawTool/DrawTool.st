"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

Object subclass:#DrawTool
	instanceVariableNames:'topView drawView menu commandPanel formMenu ruler vRuler fileBox
		importBox currentFileName resources buttonGroup
		imageColorResolution infoHolder'
	classVariableNames:'ColorList PatternListInMenu PatternList'
	poolDictionaries:''
	category:'demos-DrawTool'
!

!DrawTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    quite a nice demo application; showing many different GUI components.

    However, (as you can see from the date), this application was written
    quite a while ago, and has only been used as a testbed for the objectViews
    features (for example, zooming).
    Only a few things were updated over time, most is just as it was in 89.

    Therefore, the code does not make (good) use of some of the newer
    classes and facilities; most obvious: it should now be a subclass of
    ApplicationModel, to get all resource stuff inherited.
    It may be rewritten, once I find some spare time .... ;-)

    [author:]
	Claus Gittinger

    [start with:]
	DrawTool open

    [see also:]
	DrawView DrawObject
	Ruler VerticalRuler LineMenu PatternMenu
	LogicTool WindowTreeView
"
! !

!DrawTool class methodsFor:'defaults'!

commandPanelWidth
    ^ 60
!

listOfColorSpecs
    "return a list of color values to be presented in the fg/bg pulldown menus"

    ^ #(
	 nil
	 ( 100 100 100 ) "/ white
	 (   0   0   0 ) "/ black

	 (  25  25  25 ) "/ grey
	 (  50  50  50 ) "/ grey
	 (  75  75  75 ) "/ grey

	 ( 100 100   0 ) "/ yellow
	 ( 100   0   0 ) "/ red
	 ( 100   0 100 ) "/ magenta

	 (   0   0 100 ) "/ blue
	 (   0 100 100 ) "/ cyan
	 (   0 100   0 ) "/ green
       )
!

listOfObjectClasses
    "return a collection of classes for which buttons are created in
     the command panel"

    |classes|

    classes := OrderedCollection new.
    classes add:DrawText.
    classes add:DrawLine.
"/    classes add:DrawHLine.
"/    classes add:DrawVLine.
    classes add:DrawArrow.
    classes add:DrawRectangle.
    classes add:DrawRoundRectangle.
    classes add:DrawEllipse.
"/    classes add:DrawCircle.
    classes add:DrawPolygon.
    classes add:DrawSpline.
    classes add:DrawCurve.

    ^ classes

    "Modified: 5.6.1996 / 12:11:14 / cg"
!

listOfPatternFileNames
    "return a list of filenames which contain patterns to be
     presented in the pattern/pen pulldown menus"

    ^ #('nopattern.xbm' 'white.xbm'
	'grey94.xbm' 'grey88.xbm' 'grey75.xbm'
	'grey50.xbm' 'grey25.xbm' 'grey12.xbm' 'grey6.xbm'
	'black.xbm'
	'grey75_2.xbm' 'grey50_2.xbm' 'grey25_2.xbm'
	'grey50_3.xbm'
	'hline1.xbm' 'hline2.xbm' 'hline3.xbm'
	'vline1.xbm' 'vline2.xbm' 'vline3.xbm'
	'd1line1.xbm' 'd1line2.xbm' 'd1line3.xbm'
	'd2line1.xbm' 'd2line2.xbm' 'd2line3.xbm'
	'brick1.xbm' 'brick2.xbm'
	'wave1.xbm' 'wave2.xbm'
	'cross1.xbm' 'cross2.xbm')
! !

!DrawTool class methodsFor:'private'!

listOfColors
    "return a list of colors to be presented in the bg pulldown menus.
     Uses names returned by listOfColorNames."

    ColorList isNil ifTrue:[
	ColorList := OrderedCollection new.
	self listOfColorSpecs do:[:rgbTriple |
	    rgbTriple isNil ifTrue:[
		ColorList add:nil
	    ] ifFalse:[
		ColorList add:(Color
				 red:(rgbTriple at:1)
				 green:(rgbTriple at:2)
				 blue:(rgbTriple at:3)
			      )
	    ]
	]
    ].
    ^ ColorList

    "
     ColorList := nil
    "
!

listOfPatterns
    PatternList isNil ifTrue:[
	self listOfPatternsInMenu
    ].
    ^ PatternList
!

listOfPatternsInMenu
    "return a list of patterns to be presented in the pattern/pen pulldown menus.
     Uses names returned by listOfPatternNames."

    |form|

    PatternListInMenu isNil ifTrue:[
	PatternListInMenu := OrderedCollection new.
	PatternList := OrderedCollection new.
	self listOfPatternFileNames do:[:fileName |
	    form := Smalltalk imageFromFileNamed:fileName forClass:self.
	    PatternListInMenu add:form.
	    PatternList add:form
	].
	PatternList at:1 put:nil
    ].
    ^ PatternListInMenu
! !

!DrawTool class methodsFor:'startup'!

isVisualStartable
    ^ true
!

open
    "startup a DrawTool window with emty contents"

    ^ self new open

    "
     DrawTool open
    "
!

openOn:aFileName
    "startup a DrawTool window, initialize contents from aFileName"

    ^ self new openOn:aFileName

    "
     DrawTool openOn:'aFileName'
    "
!

start
    ^ self open
!

startOn:aFileName
    ^ self openOn:aFileName
! !

!DrawTool methodsFor:'changes'!

update:something with:someArgument from:changedObject
    "since we installed ourself as dependent of the drawView,
     we will be notified here about scroll actions. Pass scroll activity
     to rulers."

    changedObject == drawView ifTrue:[
	something == #originOfContents ifTrue:[
	    ruler viewOrigin:(drawView viewOrigin x @ 0).
	    vRuler viewOrigin:(0 @ drawView viewOrigin y).
	    ^ self.
	].

	something == #selection ifTrue:[
	    self enableDisableMenuItems.
	    ^ self.
	].

	something == #polygonEdgeMode ifTrue:[
	    drawView polygonEdgeMode ifTrue:[
		menu enable:#setPolygonFrameMode.
		menu disable:#setPolygonEdgeMode.
	    ] ifFalse:[
		menu disable:#setPolygonFrameMode.
		menu enable:#setPolygonEdgeMode.
	    ].
	    ^ self.
	].
    ]
! !

!DrawTool methodsFor:'menu definition'!

enableDisableMenuItems
    |selection|

    selection := drawView selection.
    selection isNil ifTrue:[
	#(ungroup group makePolygon makeSpline
	  selectionToFront selectionToBack
	  flipHorizontal flipVertical
	  rotate90 rotate270
	  selectionAlignLeft selectionAlignRight
	  selectionAlignTop selectionAlignBottom
	  selectionAlignHorizontal selectionAlignVertical
	) do:[:i |
	    menu disable:i.
	].
	^ self
    ].

    #(group makePolygon makeSpline
      selectionToFront selectionToBack
      flipHorizontal flipVertical
      rotate90 rotate270
      selectionAlignLeft selectionAlignRight
      selectionAlignTop selectionAlignBottom
      selectionAlignHorizontal selectionAlignVertical
    ) do:[:i |
	menu enable:i.
    ].

    "/ any group selected ?
    (selection contains:[:any | any groupedObjects ~~ any]) ifFalse:[
	menu disable:#ungroup
    ] ifTrue:[
	menu enable:#ungroup
    ].

!

initMenu
    |labels lineMenu drawToolImage "smallImage"|

    drawToolImage := menu topView icon.

    labels := resources array:#(
			       'about'
			       'file'
			       'edit'
			       'font'
			       'form'
			       'extra'
			       'pattern'
			       'line'
			       'pen'
			       'foreground'
			       'background').
    menu labels:labels.
    menu selectors:#(about file edit font form extra pattern line pen fg bg).

    menu at:#about
	    putLabels:(resources array:#(
					'about DrawTool ...'
					))
	    selectors:#(doAbout)
	     receiver:self.

"/    drawToolImage notNil ifTrue:[
"/        smallImage := drawToolImage magnifiedTo:(menu font height asPoint).
"/        menu labels at:1 put:smallImage.
"/    ].

    (menu subMenuAt:#about) actionAt:#doAbout
			put:[
				|box|

				box := AboutBox new.
				box label:'About DrawTool ...'.
				box title:'DrawTool

demonstrates various user interface components
and graphic object capabilities.

Written as a test environment for the objectView framework
and displayObject hierarchy - not as a usable end-user application.

Notice: this is one of the very first applications ever written
for and with Smalltalk/X (long before Java, Qt and other UI frameworks appeared).
It was kept almost unchanged since then, so don''t blame it for
the old-looking menus, toolbars etc.

Have fun.
'.
				box form:drawToolImage.
				box formLabel foregroundColor:Color white.
				box show
			    ].
    menu at:#file
	    putLabels:(resources array:#(
					'new'
					'open ...'
					'load ...'
					'-'
					'import image ...'
					'-'
					'save'
					'save as ...'
					'-'
					'print'
					'preview'
					'-'
					'quit'))
	    selectors:#(doNew doOpen doLoad nil doImport nil
			doSave doSaveAs nil doPrint doPreview
			nil finish)
	     receiver:self.

    menu at:#edit
	    putLabels:(resources array:#(
					'copy'
					'cut'
					'paste'
"
					'-'
					'edit bitmap'
"
					))
	    selectors:#(copySelection
			deleteSelection
			pasteBuffer
"
			nil
			editBitmap
"
		       )
	     accelerators:#(Copy
			    Cut
			    Paste
			   )
	     receiver:drawView.

    menu at:#font
	    putLabels:(resources array:#(
					'larger'
					'smaller'
					'-'
					'normal'
					'bold'
					'italic'
					'bold italic'
					'-'
					'font panel ...'))
	    selectors:#(largerFont
			smallerFont
			nil
			normalFont
			boldFont
			italicFont
			boldItalicFont
			nil
			showFontPanel)
	     receiver:drawView.

    (Smalltalk language == #english) ifTrue:[
	menu at:#form
		putLabels:(resources array:#(
					    'grid on'
					    'show grid'
					    'image color resolution'
					    '-'
					    'millimeter'
"/                                            'hide ruler'
					    '-'
					    'page size'
					    'zoom'
					    ))
		selectors:#(alignOn
			    showGrid
			    imageColorResolution
			    nil
			    millimeterMetric
"/                            scaleOff
			    nil
			    pageSize
			    zoom)
		 receiver:self
    ] ifFalse:[
	menu at:#form
		putLabels:(resources array:#(
					    'grid on'
					    'show grid'
					    'image color resolution'
					    '-'
					    'inches'
"/                                            'hide ruler'
					    '-'
					    'page size'
					    'zoom'
					    ))
		selectors:#(alignOn
			    showGrid
			    imageColorResolution
			    nil
			    inchMetric
"/                            scaleOff
			    nil
			    pageSize
			    zoom)
		 receiver:self
    ].
    formMenu := menu menuAt:#form.

    formMenu subMenuAt:#pageSize
		   put:(PopUpMenu
			   labels:(resources array:#(
						     'a6'
						     'a5'
						     'a4'
						     'a3'
						     'a2'
						     'a1'
						     'letter'
						     '-'
						     'a6 landscape'
						     'a5 landscape'
						     'a4 landscape'
						     'a3 landscape'
						     'a2 landscape'
						     'a1 landscape'
						     'letter landscape'
						    ))
			   selectors:#documentFormat:
			   args:#('a6' 'a5' 'a4' 'a3' 'a2' 'a1' 'letter' nil
				  'a6l' 'a5l' 'a4l' 'a3l' 'a2l' 'a1l' 'letterl' )
			   receiver:self
				for:formMenu
			).

    formMenu subMenuAt:#zoom
		   put:(PopUpMenu
			   labels:(resources array:#(
						     '100 %'
						     '-'
						     '25 %'
						     '50 %'
						     '75 %'
						     '-'
						     '150 %'
						     '200 %'
						     '-'
						     'other ...'
						    ))
			   selectors:#setZoom:
			   args:#(100 nil 25 50 75 nil 150 200 nil nil)
			   receiver:self
				for:formMenu
			).

    formMenu subMenuAt:#imageColorResolution
		   put:(PopUpMenu
			   labels:(resources array:#(
						     '\c low'
						     '\c medium'
						     '\c high'
						    ))
			   selectors:#(lowImageColorResolution:
				       mediumImageColorResolution:
				       highImageColorResolution:)
			   receiver:self
				for:formMenu
			).
    (formMenu subMenuAt:#imageColorResolution)
	 checkToggleAt:#highImageColorResolution: put:true.

    menu at:#extra
	    putLabels:(resources array:#(
					'to front'
					'to back'
					'-'
					'flip horizontal'
					'flip vertical'
					'rotate cw'
					'rotate ccw'
					'-'
					'align left'
					'align right'
					'align top'
					'align bottom'
					'align horizontal'
					'align vertical'
					'-'
					'select all'
					'-'
					'group'
					'ungroup'
					'-'
					'make polygon'
					'make spline'
					'polygon frame mode'
					'polygon edge mode'
			))
	    selectors:#(selectionToFront selectionToBack
			nil flipHorizontal flipVertical
			    rotate90 rotate270
			nil selectionAlignLeft selectionAlignRight
			    selectionAlignTop selectionAlignBottom
			    selectionAlignHorizontal selectionAlignVertical
			nil selectAll
			nil group ungroup
			nil makePolygon makeSpline setPolygonFrameMode setPolygonEdgeMode)
	     receiver:drawView.
    (menu menuAt:#extra) disable:#setPolygonFrameMode.
    drawView setPolygonFrameMode.

    menu at:#pattern
	    putMenu:(PatternMenu
			patterns:(self class listOfPatternsInMenu)
			selectors:#changeFillPattern:
			args:(self class listOfPatterns)
			receiver:drawView
			for:menu).

    menu at:#line
	    putLabels:(resources array:#(
					'width'
					'style'
					))
	    selectors:#(lineWidth lineStyle).

    lineMenu := LineMenu new.
    lineMenu
	lineWidths:#(1 2 3 4 5 6 7 8 9 10 15 20);
	selectors:#changeLineWidth:;
	args:#(1 2 3 4 5 6 7 8 9 10 15 20);
	receiver:drawView.

    (menu menuAt:#line)
	subMenuAt:#lineWidth
	      put:(PopUpMenu forMenu:lineMenu).

    lineMenu := LineMenu new.
    lineMenu
	lineWidths:#(3 3 3 3 3)
	styles:#(#solid #dashed #dotted #dashDot #dashDotDot)
	width:64 height:16;
	selectors:#changeLineStyle:;
	args:#(#solid #dashed #dotted #dashDot #dashDotDot);
	receiver:drawView.

    (menu menuAt:#line)
	subMenuAt:#lineStyle
	      put:(PopUpMenu forMenu:lineMenu).

    menu at:#pen
	    putMenu:(PatternMenu
			patterns:(self class listOfPatternsInMenu)
			selectors:#changeLinePattern:
			args:(self class listOfPatterns)
			receiver:drawView
			for:menu).

    menu at:#fg
	    putMenu:(PatternMenu
			patterns:(self class listOfColors)
			selectors:#changeForeground:
			args:(self class listOfColors)
			receiver:drawView
			for:menu).
    (menu menuAt:#fg) windowRatio:(3@4); orientation:#horizontalFirst.

    menu at:#bg
	    putMenu:(PatternMenu
			patterns:(self class listOfColors)
			selectors:#changeBackground:
			args:(self class listOfColors)
			receiver:drawView
			for:menu).
    (menu menuAt:#bg) windowRatio:(3@4); orientation:#horizontalFirst.

    "Modified: / 22.9.1998 / 16:47:37 / cg"
! !

!DrawTool methodsFor:'startup'!

open
    |frame panelWidth myname pointerForm protoButton vRulerWidth
     oneMillimeter drawPanel spc halfSpc infoView|

    imageColorResolution := #high.

    resources := ResourcePack for:self class.

    myname := self class name.

    "
     the outer top view
    "
    topView := StandardSystemView
		label:myname
		icon:(Smalltalk imageFromFileNamed:(myname , '.xbm') forClass:self class )
		minExtent:(100 @ 100).

    menu := PullDownMenu in:topView.

    oneMillimeter := Screen current horizontalPixelPerMillimeter.

    "
     get this form first to see how wide commandPanel should be
    "
    pointerForm := Smalltalk imageFromFileNamed:'Pointer.xbm' forClass:self class.
    pointerForm isNil ifTrue:[
	self warn:'DrawTool: cannot find (some of) my bitmaps'.
	panelWidth := 80
    ] ifFalse:[
	protoButton := (Toggle new) form:pointerForm.
	panelWidth := protoButton width + (oneMillimeter * 2) rounded.
    ].

    "
     the panel containing the buttons
    "
    "/ commandPanel := VerticalPanelView in:topView.
    commandPanel := PanelView in:topView.
    commandPanel corner:(panelWidth @ 1.0).
    commandPanel verticalLayout:#top.
    commandPanel level:0.
    commandPanel borderWidth:0.

    "/
    "/ a frame for the drawView an its rules
    "/
    drawPanel := View
		     origin:(panelWidth @ (menu height * 2))
		     corner:(1.0 @ 1.0)
		     in:topView.

    "/
    "/ the user-info at the bottom
    "/
    infoHolder := '' asValue.

    spc := View viewSpacing.
    infoView := Label label:'' in:topView.
    infoView adjust:#left; borderWidth:0.
    infoView level:-1.
    infoView is3D ifTrue:[
	halfSpc := spc // 2.
    ] ifFalse:[
	halfSpc := 0
    ].
    infoView topInset:(infoView height negated - spc + drawPanel borderWidth);
	     bottomInset:halfSpc;
	     leftInset:halfSpc;
	     rightInset:halfSpc.
    infoView origin:0.0 @ 1.0 corner:1.0 @ 1.0.
    infoView model:infoHolder; aspect:#value; labelMessage:#value.

    drawPanel bottomInset:(infoView height + spc).

    "/
    "/ horizontal & vertical Rulers
    "/
    ruler := Ruler in:drawPanel.

    vRuler := VerticalRuler in:drawPanel.
    vRulerWidth := ruler height.
    vRuler width:vRulerWidth.

    "/
    "/ the actual drawView in a scroll-wrapper
    "/
    frame := HVScrollableView for:DrawView in:drawPanel.
    frame origin:(0.0 "panelWidth" @ ("menu height * 2 +" ruler height))
	  corner:(1.0 @ 1.0).
    frame rightInset:vRulerWidth+oneMillimeter rounded.
"/    frame setupDimensions.   "/ req'd for #originRelativeTo: below to return the correct value

    drawView := frame scrolledView.
    drawView addDependent:self.

    drawView infoMessageHolder:infoHolder.
    drawView changeFillPattern:nil.
    drawView changeLinePattern:(Form black "fromFile:'black.xbm'").
    drawView changeLineWidth:1.

    ruler origin:[(drawView originRelativeTo:drawPanel) x + drawView borderWidth
		  @ 0 "(menu height * 2)"]
	  corner:(1.0 @ ("menu height * 2 +" ruler height)).
    ruler rightInset:vRulerWidth+oneMillimeter rounded.
    ruler level:-1.

    vRuler origin:(1.0 @ 0.0) corner:(1.0 @ 1.0).
    vRuler leftInset:vRulerWidth negated - (oneMillimeter // 2).
    vRuler topInset:vRulerWidth + (oneMillimeter // 2) + 1.
    vRuler rightInset:(oneMillimeter // 1 "2").
    vRuler bottomInset:(frame horizontalScrollBar height + oneMillimeter rounded).
    vRuler level:-1.

    "
     now, that we know the dimensions, set the commandPanels origin.
    "
    commandPanel origin:(0 @ ((menu height * 2) + ruler height)).

    "
     want to be notified of scroll operations in the drawView
     (to update the rulers)
    "
    drawView addDependent:self.

    self initMenu.

    "
     the buttons created below are arranged in a group to
     give them one-only behavior
    "
    buttonGroup := RadioButtonGroup new:0.

    buttonGroup add:
	(Toggle form:pointerForm
		   action:[drawView noCreate]
		       in:commandPanel) turnOn.

    "
     create one button for each drawobject type
    "
    (self class listOfObjectClasses) do:[:elClass |
	buttonGroup add:(Toggle form:(elClass icon)
				   action:[drawView createObjectWithClass:elClass]
				       in:commandPanel).
    ].

    topView open.

    "Modified: / 25.9.1998 / 19:55:40 / cg"
!

openOn:aFileName
    |aStream baseName|

    self open.

    "read file without redraw - done when file has to be read before
     first expose is handled - avoids double redraw"

    baseName := OperatingSystem baseNameOf:aFileName.
    topView label:baseName , ' - ' , (OperatingSystem directoryNameOf:aFileName).
    topView iconName:baseName.

    aStream := FileStream readonlyFileNamed:aFileName.
    aStream notNil ifTrue:[
	drawView withoutRedrawFileInContentsFrom:aStream.
	aStream close.
	currentFileName := aFileName
    ]
! !

!DrawTool methodsFor:'user interaction'!

alignOff
    formMenu labelAt:#alignOff put:(resources string:'grid on').
    formMenu selectorAt:#alignOff put:#alignOn.
    drawView alignOff
!

alignOn
    formMenu labelAt:#alignOn put:(resources string:'grid off').
    formMenu selectorAt:#alignOn put:#alignOff.
    drawView alignOn
!

doClose
    ^ self
!

doImport
    importBox isNil ifTrue:[
	importBox := ImageSelectionBox "/ FileSelectionBox
			title:''
		       okText:''
		    abortText:(resources string:'abort')
		       action:[nil].
	importBox pattern:'*'.
    ].
    importBox title:(resources string:'Filename of image:').
    importBox action:[:fileName | self import:fileName].
    importBox okText:(resources string:'import').
    importBox showAtPointer

    "Modified: 5.6.1996 / 16:33:48 / cg"
!

doLoad
    "load a drawing and merge into the current one"

    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox
			title:''
			okText:''
			abortText:(resources string:'abort')
			action:[nil].
    ].
    fileBox pattern:'*.draw'.
    fileBox title:(resources string:'load objects from file:').
    fileBox action:[:fileName | self openFile:fileName new:false].
    fileBox okText:(resources string:'load').

    currentFileName notNil ifTrue:[
	(currentFileName startsWith:'/') ifTrue:[
	    fileBox directory:(OperatingSystem directoryNameOf:currentFileName)
	]
    ].
    fileBox showAtPointer
!

doNew
    "clear"

    drawView removeAll
!

doOpen
    "clear and load a new drawing"

    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox
			title:''
			okText:''
			abortText:(resources string:'abort')
			action:[nil].
    ].
    fileBox pattern:'*.draw'.
    fileBox title:(resources string:'open file:').
    fileBox action:[:fileName | self openFile:fileName new:true].
    fileBox okText:(resources string:'open').

    currentFileName notNil ifTrue:[
	(currentFileName startsWith:'/') ifTrue:[
	    fileBox directory:(OperatingSystem directoryNameOf:currentFileName)
	]
    ].
    fileBox showAtPointer
!

doPreview
    |gc printStream warning|

    (Smalltalk includesKey:#PSGraphicsContext) ifFalse:[
	warning := 'not implemented (need PSGraphicsContext)'
    ] ifTrue:[
	PSGraphicsContext isNil ifTrue:[
	    warning := 'not implemented (need PSGraphicsContext)'
	] ifFalse:[
	    (OperatingSystem canExecuteCommand:'ghostview') ifFalse:[
		warning := 'ghostview command not executable'
	    ]
	]
    ].

    warning notNil ifTrue:[
	^ self warn:(resources string:warning)
    ].

    printStream := '/tmp/stx.ps' asFilename writeStream.

    gc := PSGraphicsContext on:printStream extent:(drawView widthOfContents @ drawView heightOfContents).
    [
	drawView redrawObjectsOn:gc
    ] valueNowOrOnUnwindDo:[gc close].

    OperatingSystem executeCommand:'ghostview /tmp/stx.ps'.
    '/tmp/stx.ps' asFilename remove
!

doPrint
    |gc printStream|

    (Smalltalk includesKey:#PSGraphicsContext) ifFalse:[
	^ self warn:'not implemented (need PSGraphicsContext)'
    ].
    PSGraphicsContext isNil ifTrue:[
	^ self warn:'not implemented (need PSGraphicsContext)'
    ].
    (Printer == PostscriptPrinterStream) ifFalse:[
	^ self warn:'currently only postscript printing supported'
    ].

    printStream := Printer newNative. "/ PipeStream writingTo:(Printer printCommand).

    gc := PSGraphicsContext on:printStream extent:(drawView widthOfContents @ drawView heightOfContents).
    [
	drawView redrawObjectsOn:gc
    ] valueNowOrOnUnwindDo:[gc close].

    "Modified: 3.6.1996 / 10:28:28 / cg"
!

doSave
    "save in my own private format - in current file"

    currentFileName notNil ifTrue:[
	self saveAs:currentFileName
    ] ifFalse:[
	self doSaveAs
    ]
!

doSaveAs
    "save in my own private format - let user specify a filename"

    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox
			title:''
			okText:''
			abortText:(resources string:'abort')
			action:[nil].
    ].
    fileBox pattern:'*.draw'.
    fileBox title:(resources string:'save as:').
    fileBox action:[:fileName | self saveAs:fileName].
    fileBox okText:(resources string:'save').
    fileBox showAtPointer
!

documentFormat:aFormat
    drawView documentFormat:aFormat.
    ruler paperWidthMM:(drawView widthOfContentsInMM).
    vRuler paperHeightMM:(drawView heightOfContentsInMM)
!

finish
    fileBox notNil ifTrue:[fileBox destroy. fileBox := nil].
    importBox notNil ifTrue:[importBox destroy. importBox := nil].
    drawView := menu := commandPanel := nil.
    formMenu := ruler := resources := buttonGroup := nil.
    topView destroy.
    "
     notReached
    "
    topView := nil.
!

hideGrid
    formMenu labelAt:#hideGrid put:(resources string:'show grid').
    formMenu selectorAt:#hideGrid put:#showGrid.
    drawView hideGrid.
!

highImageColorResolution:onOff
    self imageColorResolution:(onOff ifTrue:[#high] ifFalse:[imageColorResolution]).
!

imageColorResolution:how
    |m|

    imageColorResolution := how.

    m := (formMenu subMenuAt:#imageColorResolution).
    m checkToggleAt:#lowImageColorResolution: put:(how == #low).
    m checkToggleAt:#mediumImageColorResolution: put:(how == #medium).
    m checkToggleAt:#highImageColorResolution: put:(how == #high).
!

import:aFileName
    "bitmap/image import"

    |img|

    drawView windowGroup withCursor:Cursor wait do:[
	Processor activeProcess withPriority:(Processor userBackgroundPriority)
	do:[
	    AllocationFailure handle:[:ex |
		 self warn:'no memory for image'.
		 ex return
	    ] do:[
		img := Image fromFile:aFileName.
		img notNil ifTrue:[
		    "/
		    "/ get its colors right away, if resolution
		    "/ is not high
		    "/
		    Object errorSignal handle:[:ex |
			ex return
		    ] do:[
			|screen|

			imageColorResolution ~~ #high ifTrue:[
			    screen := drawView device.
			    imageColorResolution == #low ifTrue:[
				Color getColorsRed:3 green:3 blue:2 on:screen
			    ] ifFalse:[
				Color getColorsRed:5 green:5 blue:3 on:screen
			    ].
			    img := img on:screen.
			    screen releaseFixColors
			]
		    ].
		    drawView addSelected:(DrawImage new image:img).
		] ifFalse:[
		   aFileName asFilename isReadable ifTrue:[
			self warn:('unknown image format: ', aFileName)
		   ] ifFalse:[
			self warn:(aFileName , ' unreadable')
		   ]
		]
	    ].
	].
    ].

    "Modified: 2.5.1997 / 18:17:20 / cg"
!

inchMetric
    formMenu labelAt:#inchMetric put:(resources string:'millimeter').
    formMenu selectorAt:#inchMetric put:#millimeterMetric.
    ruler metric:#inch.
    vRuler metric:#inch.
    drawView inchMetric.
    ^ self
!

lowImageColorResolution:onOff
    self imageColorResolution:(onOff ifTrue:[#low] ifFalse:[imageColorResolution]).
!

mediumImageColorResolution:onOff
    self imageColorResolution:(onOff ifTrue:[#medium] ifFalse:[imageColorResolution]).
!

millimeterMetric
    formMenu labelAt:#millimeterMetric put:(resources name:'inches').
    formMenu selectorAt:#millimeterMetric put:#inchMetric.
    ruler metric:#mm.
    vRuler metric:#mm.
    drawView millimeterMetric.
    ^ self
!

openFile:aFileName new:new
    |aStream baseName|

    aStream := FileStream readonlyFileNamed:aFileName.
    aStream notNil ifTrue:[
	drawView fileInContentsFrom:aStream redraw:true new:new.
	aStream close.
	currentFileName := aFileName.
	baseName := OperatingSystem baseNameOf:aFileName.
	topView label:baseName , ' - ' , (OperatingSystem directoryNameOf:aFileName).
	topView iconName:baseName
    ]
!

saveAs:aFileName
    "common helper for saving"

    |aStream|

    aStream := FileStream newFileNamed:aFileName.
    aStream notNil ifTrue:[
	drawView storeContentsOn:aStream.
	aStream close
    ].
    currentFileName := aFileName
!

scaleOff
    formMenu labelAt:#scaleOff put:(resources string:'show ruler').
    formMenu selectorAt:#scaleOff put:#scaleOn.
    drawView hideScale
!

scaleOn
    formMenu labelAt:#scaleOn put:(resources string:'hide ruler').
    formMenu selectorAt:#scaleOn put:#scaleOff.
    drawView showScale
!

setPolygonEdgeMode
    menu enable:#setPolygonFrameMode.
    menu disable:#setPolygonEdgeMode.
    drawView setPolygonEdgeMode
!

setPolygonFrameMode
    menu enable:#setPolygonEdgeMode.
    menu disable:#setPolygonFrameMode.
    drawView setPolygonFrameMode
!

setZoom:zoom
    |zoomFactor|

    zoomFactor := zoom.
    zoom isNil ifTrue:[
	|box zoomString|

	box := EnterBox title:(resources string:'zoom factor (percent):').
	box okText:(resources string:'change').
	zoomString := box request.
	zoomString isNil ifTrue:[^ self].
	zoomFactor := Number readFromString:zoomString onError:[100].
    ].

    drawView zoom:zoomFactor / 100.
    ruler scale:zoomFactor / 100.
    vRuler scale:zoomFactor / 100.
!

showGrid
    formMenu labelAt:#showGrid put:(resources string:'hide grid').
    formMenu selectorAt:#showGrid put:#hideGrid.
    drawView showGrid.
! !

!DrawTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawTool.st,v 1.43 2016-11-02 00:47:36 cg Exp $'
! !
