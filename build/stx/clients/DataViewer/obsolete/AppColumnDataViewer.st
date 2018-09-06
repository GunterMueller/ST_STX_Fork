"{ NameSpace: TDV }"

ApplicationModel subclass:#AppColumnDataViewer
	instanceVariableNames:'view drawingFunc drawingSolid drawingPlanes drawingGrids process
		lastHit multi selectedFunc actDataIndex sensorArray
		maxOldValuesToHold maxY minY separatorPlaneYValue
		separatorPlaneIntensity'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-OpenGL'
!

Object subclass:#ColumnRow
	instanceVariableNames:'visibility showName name showPeak peak'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AppColumnDataViewer
!


!AppColumnDataViewer class methodsFor:'interface specs'!

dialogSpec1
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TDV::Application andSelector:#dialogSpec1
     TDV::Application new openInterface:#dialogSpec1
    "

    <resource: #canvas>

    ^

       #(#FullSpec
	  #window:
	   #(#WindowSpec
	      #name: 'Function settings'
	      #layout: #(#LayoutFrame 396 0 140 0 734 0 294 0)
	      #label: 'Function settings'
	      #min: #(#Point 10 10)
	      #max: #(#Point 1024 768)
	      #bounds: #(#Rectangle 396 140 735 295)
	      #usePreferredExtent: false
	  )
	  #component:
	   #(#SpecCollection
	      #collection:
	       #(
		 #(#HorizontalPanelViewSpec
		    #name: 'HorizontalPanel1'
		    #layout: #(#LayoutFrame 0 0.0 -30 1.0 0 1.0 0 1.0)
		    #component:
		     #(#SpecCollection
			#collection:
			 #(
			   #(#ActionButtonSpec
			      #name: 'Button2'
			      #label: 'Cancel'
			      #translateLabel: true
			      #model: #cancel
			      #extent: #(#Point 125 22)
			  )
			   #(#ActionButtonSpec
			      #name: 'Button1'
			      #label: 'OK'
			      #translateLabel: true
			      #model: #accept
			      #extent: #(#Point 125 22)
			  )
			)
		    )
		    #horizontalLayout: #center
		    #verticalLayout: #center
		    #horizontalSpace: 3
		    #verticalSpace: 3
		)
		 #(#UpDownButtonSpec
		    #name: 'UpDownButton1'
		    #layout: #(#LayoutFrame 221 0 5 0 239 0 38 0)
		    #upAction: #setSensorNumber:
		    #downAction: #setSensorNumber:
		    #upArgument: 'inc'
		    #downArgument: 'dec'
		)
		 #(#InputFieldSpec
		    #name: 'EntryField1'
		    #layout: #(#LayoutFrame 174 0 10 0 216 0 32 0)
		    #model: #dialogInputSensorNumber
		    #isReadOnly: true
		    #type: #number
		    #numChars: 4
		)
		 #(#LabelSpec
		    #name: 'Label1'
		    #layout: #(#LayoutFrame 5 0 11 0 114 0 33 0)
		    #label: 'Number of sensors'
		    #translateLabel: true
		    #adjust: #left
		)
		 #(#InputFieldSpec
		    #name: 'EntryField2'
		    #layout: #(#LayoutFrame 174 0 50 0 216 0 72 0)
		    #model: #dialogInputYValuesToShow
		    #isReadOnly: true
		    #type: #number
		    #numChars: 4
		)
		 #(#UpDownButtonSpec
		    #name: 'UpDownButton2'
		    #layout: #(#LayoutFrame 221 0 45 0 239 0 78 0)
		    #upAction: #setYValuesNumber:
		    #downAction: #setYValuesNumber:
		    #upArgument: 'inc'
		    #downArgument: 'dec'
		)
		 #(#LabelSpec
		    #name: 'Label2'
		    #layout: #(#LayoutFrame 5 0 52 0 169 0 72 0)
		    #label: 'Number of y values to show'
		    #translateLabel: true
		    #adjust: #left
		)
	      )
	  )
      )

    "Modified: / 29.9.1998 / 14:37:27 / ps"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TDV::Application andSelector:#windowSpec
     TDV::Application new openInterface:#windowSpec
     TDV::Application open
    "

    <resource: #canvas>

    ^

       #(#FullSpec
	  #window:
	   #(#WindowSpec
	      #name: 'Data Viewer 3D'
	      #layout: #(#LayoutFrame 550 0 12 0 1349 0 661 0)
	      #label: 'Data Viewer 3D'
	      #min: #(#Point 800 650)
	      #max: #(#Point 1024 720)
	      #bounds: #(#Rectangle 550 12 1350 662)
	      #menu: #menu
	      #usePreferredExtent: false
	  )
	  #component:
	   #(#SpecCollection
	      #collection:
	       #(
		 #(#VariableVerticalPanelSpec
		    #name: 'VariableVerticalPanel1'
		    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
		    #component:
		     #(#SpecCollection
			#collection:
			 #(
			   #(#ViewSpec
			      #name: 'Box1'
			      #component:
			       #(#SpecCollection
				  #collection:
				   #(
				     #(#ArbitraryComponentSpec
					#name: 'DataViewer3D'
					#layout: #(#LayoutFrame 179 0 0 0 -20 1.0 -20 1.0)
					#component: #DataViewer3D
					#hasBorder: false
				    )
				     #(#FramedBoxSpec
					#name: 'FramedBox1'
					#layout: #(#LayoutFrame -2 0 53 0 174 0 181 0)
					#component:
					 #(#SpecCollection
					    #collection:
					     #(
					       #(#LabelSpec
						  #name: 'ZLabel'
						  #layout: #(#LayoutFrame 25 0 71 0 45 0 93 0)
						  #label: 'Z:'
						  #translateLabel: true
						  #adjust: #left
					      )
					       #(#InputFieldSpec
						  #name: 'EntryFieldScaleZ'
						  #layout: #(#LayoutFrame 48 0 71 0 86 0 93 0)
						  #model: #scaleZValue
						  #isReadOnly: true
						  #type: #number
					      )
					       #(#UpDownButtonSpec
						  #name: 'UpDownButtonScaleZ'
						  #layout: #(#LayoutFrame 93 0 69 0 110 0 96 0)
						  #upAction: #setScaleZ:
						  #downAction: #setScaleZ:
						  #upArgument: 'up'
						  #downArgument: 'down'
					      )
					       #(#LabelSpec
						  #name: 'Label3'
						  #layout: #(#LayoutFrame 22 0 36 0 42 0 58 0)
						  #label: 'Y:'
						  #translateLabel: true
						  #adjust: #left
					      )
					       #(#InputFieldSpec
						  #name: 'EntryFieldScaleY'
						  #layout: #(#LayoutFrame 48 0 36 0 86 0 58 0)
						  #model: #scaleYValue
						  #isReadOnly: true
						  #type: #number
					      )
					       #(#UpDownButtonSpec
						  #name: 'UpDownButtonScaleY'
						  #layout: #(#LayoutFrame 93 0 35 0 110 0 62 0)
						  #upAction: #setScaleY:
						  #downAction: #setScaleY:
						  #upArgument: 'up'
						  #downArgument: 'down'
					      )
					       #(#LabelSpec
						  #name: 'Label4'
						  #layout: #(#LayoutFrame 22 0 4 0 42 0 26 0)
						  #label: 'X:'
						  #translateLabel: true
						  #adjust: #left
					      )
					       #(#InputFieldSpec
						  #name: 'EntryFieldScaleX'
						  #layout: #(#LayoutFrame 48 0 4 0 86 0 26 0)
						  #model: #scaleXValue
						  #isReadOnly: true
						  #type: #number
					      )
					       #(#UpDownButtonSpec
						  #name: 'UpDownButtonScaleX'
						  #layout: #(#LayoutFrame 93 0 1 0 110 0 28 0)
						  #upAction: #setScaleX:
						  #downAction: #setScaleX:
						  #upArgument: 'up'
						  #downArgument: 'down'
					      )
					    )
					)
					#label: 'Scaling'
					#labelPosition: #topLeft
					#style: #(#FontDescription #helvetica #bold #roman 12)
					#translateLabel: true
				    )
				     #(#FramedBoxSpec
					#name: 'FramedBox2'
					#layout: #(#LayoutFrame -2 0 181 0 174 0 376 0)
					#component:
					 #(#SpecCollection
					    #collection:
					     #(
					       #(#ActionButtonSpec
						  #name: 'moveUp'
						  #layout: #(#LayoutFrame 63 0 2 0 91 0 46 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'upIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'up'
					      )
					       #(#ActionButtonSpec
						  #name: 'moveRight'
						  #layout: #(#LayoutFrame 84 0 53 0 141 0 80 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'rightIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'right'
					      )
					       #(#ActionButtonSpec
						  #name: 'moveDown'
						  #layout: #(#LayoutFrame 63 0 89 0 91 0 133 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'downIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'down'
					      )
					       #(#ActionButtonSpec
						  #name: 'moveLeft'
						  #layout: #(#LayoutFrame 18 0 53 0 69 0 80 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'leftIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'left'
					      )
					       #(#ActionButtonSpec
						  #name: 'moveForward'
						  #layout: #(#LayoutFrame -3 0 2 0 24 0 46 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'forwardIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'forward'
					      )
					       #(#ActionButtonSpec
						  #name: 'moveBack'
						  #layout: #(#LayoutFrame -3 0 89 0 24 0 133 0)
						  #hasCharacterOrientedLabel: false
						  #label: 'backwardIcon'
						  #translateLabel: true
						  #model: #moveEye:
						  #isTriggerOnDown: true
						  #autoRepeat: true
						  #actionValue: 'back'
					      )
					       #(#ActionButtonSpec
						  #name: 'Button1'
						  #layout: #(#LayoutFrame 0 0 140 0 0 1 162 0)
						  #label: 'Reset Viewing'
						  #translateLabel: true
						  #model: #resetViewing
					      )
					    )
					)
					#label: 'Navigation'
					#labelPosition: #topLeft
					#style: #(#FontDescription #helvetica #bold #roman 12)
					#translateLabel: true
				    )
				     #(#FramedBoxSpec
					#name: 'FramedBox5'
					#layout: #(#LayoutFrame -2 0 3 0 174 0 53 0)
					#component:
					 #(#SpecCollection
					    #collection:
					     #(
					       #(#RadioButtonSpec
						  #name: 'RadioButton2'
						  #layout: #(#LayoutFrame 78 0.0 1 0 130 0 23 0)
						  #label: 'stop'
						  #translateLabel: true
						  #model: #stopApplication
						  #isTriggerOnDown: true
						  #lampColor: #(#Color 0.0 0.0 0.0)
						  #select: #stop
					      )
					       #(#RadioButtonSpec
						  #name: 'RadioButton1'
						  #layout: #(#LayoutFrame 14 0.0 1 0 63 0 23 0)
						  #label: 'start'
						  #translateLabel: true
						  #model: #stopApplication
						  #isTriggerOnDown: true
						  #lampColor: #(#Color 0.0 0.0 0.0)
						  #select: #start
					      )
					    )
					)
					#label: 'Animation'
					#labelPosition: #topLeft
					#style: #(#FontDescription #helvetica #bold #roman 12)
					#translateLabel: true
				    )
				     #(#ThumbWheelSpec
					#name: 'ThumbWheelRotateX'
					#layout: #(#LayoutFrame -20 1.0 0 0 0 1.0 -20 1.0)
					#model: #angleX
					#step: 1
					#endlessRotation: true
					#startMotionCallBack: #startRotation
					#endMotionCallBack: #endRotation
				    )
				     #(#ThumbWheelSpec
					#name: 'ThumbWheelRotateY'
					#layout: #(#LayoutFrame 179 0 -20 1.0 -20 1.0 0 1.0)
					#model: #angleY
					#orientation: #horizontal
					#step: 1
					#endlessRotation: true
					#startMotionCallBack: #startRotation
					#endMotionCallBack: #endRotation
				    )
				     #(#FramedBoxSpec
					#name: 'FramedBox6'
					#layout: #(#LayoutFrame -2 0 373 0 174 0 534 0)
					#component:
					 #(#SpecCollection
					    #collection:
					     #(
					       #(#RadioButtonSpec
						  #name: 'RadioButton3'
						  #layout: #(#LayoutFrame 20 0.0 1 0 66 0 23 0)
						  #label: 'on'
						  #translateLabel: true
						  #model: #switchSeparatorPlane
						  #isTriggerOnDown: true
						  #lampColor: #(#Color 0.0 0.0 0.0)
						  #select: #true
					      )
					       #(#RadioButtonSpec
						  #name: 'RadioButton4'
						  #layout: #(#LayoutFrame 85 0 1 0 137 0 23 0)
						  #label: 'off'
						  #translateLabel: true
						  #model: #switchSeparatorPlane
						  #isTriggerOnDown: true
						  #lampColor: #(#Color 0.0 0.0 0.0)
						  #select: #false
					      )
					       #(#LabelSpec
						  #name: 'Label1'
						  #layout: #(#LayoutFrame 1 0 64 0 25 0 82 0)
						  #label: 'Y :'
						  #translateLabel: true
						  #adjust: #left
					      )
					       #(#InputFieldSpec
						  #name: 'EntryField1'
						  #layout: #(#LayoutFrame 23 0 62 0 97 0 84 0)
						  #model: #separatorPlaneYValue
						  #type: #number
						  #immediateAccept: false
						  #acceptOnLeave: true
						  #acceptOnLostFocus: true
						  #numChars: 4
					      )
					       #(#UpDownButtonSpec
						  #name: 'UpDownButton1'
						  #layout: #(#LayoutFrame 105 0 58 0 123 0 87 0)
						  #upAction: #setSeparatorPlaneY:
						  #downAction: #setSeparatorPlaneY:
						  #upArgument: 'up'
						  #downArgument: 'down'
					      )
					       #(#InputFieldSpec
						  #name: 'EntryField2'
						  #layout: #(#LayoutFrame 0 0 30 0 0 1 51 0)
						  #model: #textYPlaneValue
						  #isReadOnly: true
					      )
					       #(#InputFieldSpec
						  #name: 'EntryField3'
						  #layout: #(#LayoutFrame 54 0 103 0 97 0 125 0)
						  #model: #separatorPlaneIntensity
						  #type: #number
						  #immediateAccept: false
						  #acceptOnLeave: true
						  #acceptOnLostFocus: true
					      )
					       #(#UpDownButtonSpec
						  #name: 'UpDownButton2'
						  #layout: #(#LayoutFrame 105 0 99 0 123 0 128 0)
						  #upAction: #setSeparatorPlaneIntensity:
						  #downAction: #setSeparatorPlaneIntensity:
						  #upArgument: 'up'
						  #downArgument: 'down'
					      )
					       #(#LabelSpec
						  #name: 'Label5'
						  #layout: #(#LayoutFrame 1 0 104 0 54 0 126 0)
						  #label: 'Intensity:'
						  #translateLabel: true
						  #adjust: #left
					      )
					       #(#DividerSpec
						  #name: 'Separator1'
						  #layout: #(#LayoutFrame -7 0 91.0 0 7 1.0 96 0)
					      )
					       #(#DividerSpec
						  #name: 'Separator2'
						  #layout: #(#LayoutFrame -7 0 22 0 7 1.0 27 0)
					      )
					    )
					)
					#label: 'Separator Plane'
					#labelPosition: #topLeft
					#style: #(#FontDescription #helvetica #bold #roman 12)
					#translateLabel: true
				    )
				  )
			      )
			  )
			   #(#DataSetSpec
			      #name: 'Table1'
			      #hasHorizontalScrollBar: true
			      #hasVerticalScrollBar: true
			      #miniScrollerHorizontal: true
			      #dataList: #columnHolder
			      #has3Dsepartors: false
			      #beDependentOfRows: true
			      #columns:
			       #(
				 #(#DataSetColumnSpec
				    #label: 'Show name'
				    #rendererType: #CheckToggle
				    #model: #showName
				    #selectSelector: #toggleShowName:
				    #showSelectionHighLighted: false
				)
				 #(#DataSetColumnSpec
				    #label: 'Name'
				    #editorType: #InputField
				    #model: #name
				)
				 #(#DataSetColumnSpec
				    #label: 'Show peak labels'
				    #rendererType: #CheckToggle
				    #model: #showPeak
				    #selectSelector: #togglePeakLabels:
				    #showSelectionHighLighted: false
				)
				 #(#DataSetColumnSpec
				    #label: 'Trigger value for peak labels'
				    #editorType: #InputField
				    #type: #number
				    #model: #peak
				)
				 #(#DataSetColumnSpec
				    #label: 'Visibility'
				    #rendererType: #CheckToggle
				    #model: #visibility
				    #selectSelector: #toggleVisibility:
				    #showSelectionHighLighted: false
				)
			      )
			  )
			)
		    )
		    #handles: #(#Any 0.82 1.0)
		)
	      )
	  )
      )

    "Modified: / 3.10.1998 / 15:29:13 / ps"
! !

!AppColumnDataViewer class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:TDV::Application andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(TDV::Application menu)) startUp
    "

    <resource: #menu>

    ^

       #(#Menu

	   #(
	     #(#MenuItem
		#label: 'File'
		#translateLabel: true
		#submenu:
		 #(#Menu

		     #(
		       #(#MenuItem
			  #label: 'Exit'
			  #translateLabel: true
			  #value: #closeRequest
		      )
		    ) nil
		    nil
		)
	    )
	     #(#MenuItem
		#label: 'Options'
		#translateLabel: true
		#submenu:
		 #(#Menu

		     #(
		       #(#MenuItem
			  #label: 'Solid'
			  #translateLabel: true
			  #indication: #drawingSolid:
		      )
		       #(#MenuItem
			  #label: 'Planes'
			  #translateLabel: true
			  #indication: #drawingPlanes:
		      )
		       #(#MenuItem
			  #label: 'Grid'
			  #translateLabel: true
			  #indication: #drawingGrids:
		      )
		    ) nil
		    nil
		)
	    )
	     #(#MenuItem
		#label: 'Functions'
		#translateLabel: true
		#submenu:
		 #(#Menu

		     #(
		       #(#MenuItem
			  #label: 'reset actual function'
			  #translateLabel: true
			  #value: #resetFunc
		      )
		       #(#MenuItem
			  #label: '-'
		      )
		       #(#MenuItem
			  #label: 'draw sinus and cosinus waves'
			  #translateLabel: true
			  #choice: #drawingFunc
			  #choiceValue: #sinAndCos
		      )
		       #(#MenuItem
			  #label: 'random values'
			  #translateLabel: true
			  #choice: #drawingFunc
			  #choiceValue: #random
		      )
		    ) nil
		    nil
		)
	    )
	     #(#MenuItem
		#label: 'Help'
		#translateLabel: true
		#startGroup: #right
		#submenu:
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
			  #label: 'About Data Viewer 3D'
			  #translateLabel: true
			  #value: #openAboutThisApplication
		      )
		    ) nil
		    nil
		)
	    )
	  ) nil
	  nil
      )

    "Modified: / 3.10.1998 / 14:54:04 / ps"
! !

!AppColumnDataViewer methodsFor:'accessing'!

backwardIcon

    ^Icon backwardIcon

!

downIcon

    ^Icon downIcon

!

forwardIcon

    ^Icon forwardIcon

!

leftIcon

    ^Icon leftIcon

!

rightIcon

    ^Icon rightIcon
!

upIcon

    ^Icon upIcon

! !

!AppColumnDataViewer methodsFor:'actions'!

accept
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': action for accept ...'.

    "Created: / 29.9.1998 / 14:24:00 / ps"
!

cancel
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': action for cancel ...'.

    "Created: / 29.9.1998 / 14:24:00 / ps"
!

endRotation
"indicate that a rotation ended
"
    view endRotation.
!

moveEye:aDirection
"move the eye position in a specfic direction
"
    |now delta|

    now := Timestamp now.
    lastHit = nil ifTrue:[
	lastHit := now.
    ]ifFalse:[
	delta := now millisecondDeltaFrom: lastHit.
	lastHit := now.
	delta < 100 ifTrue:[
	    multi := multi + 0.1.
	]ifFalse:[
	    multi := 1.0.
	].
    ].
    view moveEye:aDirection moveFactor:multi.

!

openAboutThisApplication

    |b textLabel sep|

    b := DialogBox new.
    b label:'About DataViewer3D'.

    b addVerticalSpace:4.
    b addTextLabel:'DataViewer3D by Pierre Schwarz 1998'.
    b addVerticalSpace:4.
    b addHorizontalLine.
    b addVerticalSpace:3.
    b addTextLabel:'Information about OpenGL:'.
    b addVerticalSpace:3.

    b addTextLabel:('Vendor: ', view glVendor).
    b addTextLabel:('OpenGL version: ', view glVersion).
    b addTextLabel:('GLU Version: ', view gluVersion).
    b addTextLabel:('GL Renderer: ', view glRenderer).

    b addVerticalSpace:2.
    b addHorizontalLine.

"/    sep := Separator in:b.
"/    sep origin:[0.0 @ textLabel bottom].
"/    sep extent:(1.0 @ sep preferredExtent y).


    b addOkButton.

"/    b extent:(b preferredExtent).

"/    b title:'DataViewer3D by Pierre Schwarz 1998'.

    b show.
!

reinitOfColumn

    (view columns at:1) aspectAt:#shown put:false.
!

resetFunc

    (self openDialogInterface:#dialogSpec1) ifTrue:[
	self stopDataProcess.
	view reinitialize.
	self reinitialize.
	self initializeFunc:selectedFunc.
	self startDataProcess.
    ].
!

resetViewing
"set eye coordinates to default values
"
   view resetViewing.
   view doInvalidateGraph
!

setScaleX:anArgument

    |val|

    anArgument = 'up' ifTrue:[
	self scaleXValue value:(self scaleXValue value + 0.1).
    ]ifFalse:[
	val := self scaleXValue value.
	(val - 0.1) <= 0.0001 ifFalse:[
	    self scaleXValue value:(val - 0.1).
	].
    ].

!

setScaleY:anArgument

    |val|

    anArgument = 'up' ifTrue:[
	self scaleYValue value:(self scaleYValue value + 0.1).
    ]ifFalse:[
	val := self scaleYValue value.
	(val - 0.1) <= 0.001 ifFalse:[
	    self scaleYValue value:(val - 0.1).
	].
    ].

!

setScaleZ:anArgument

    |val|

    anArgument = 'up' ifTrue:[
	self scaleZValue value:(self scaleZValue value + 0.1).
    ]ifFalse:[
	val := self scaleZValue value.
	(val - 0.1) <= 0.0001 ifFalse:[
	    self scaleZValue value:(val - 0.1).
	].
    ].

!

setSensorNumber:anArgument

    |val|

    anArgument = 'inc' ifTrue:[
	self dialogInputSensorNumber value:(self dialogInputSensorNumber value + 1).
    ]ifFalse:[
	val := self dialogInputSensorNumber value.
	(val - 1) >= 2 ifTrue:[
	    self dialogInputSensorNumber value:(val - 1).
	].
    ].

!

setSeparatorPlaneIntensity:anArgument
    |val|

    val := self separatorPlaneIntensity value.
    anArgument = 'up' ifTrue:[
	val := val + 0.1.
	self separatorPlaneIntensity value:val.
    ]ifFalse:[
	val := val - 0.1.
	self separatorPlaneIntensity value:val.
    ].

    "Modified: / 3.10.1998 / 13:33:48 / ps"
    "Created: / 3.10.1998 / 15:26:00 / ps"
!

setSeparatorPlaneY:anArgument

    |val|

    val := self separatorPlaneYValue value.
    anArgument = 'up' ifTrue:[
	val := val + 10.
	self separatorPlaneYValue value:val.
    ]ifFalse:[
	val := val - 10.0.
	self separatorPlaneYValue value:val.
    ].

    "Created: / 2.10.1998 / 21:31:50 / ps"
    "Modified: / 2.10.1998 / 22:09:35 / ps"
!

setYValuesNumber:anArgument

    |val|

    anArgument = 'inc' ifTrue:[
	self dialogInputYValuesToShow value:(self dialogInputYValuesToShow value + 1).
    ]ifFalse:[
	val := self dialogInputYValuesToShow value.
	(val - 1) >= 2 ifTrue:[
	    self dialogInputYValuesToShow value:(val - 1).
	].
    ].

    "Created: / 29.9.1998 / 14:21:32 / ps"
    "Modified: / 29.9.1998 / 14:22:34 / ps"
!

startRotation
"indicate that a rotation started
"
    view startRotation.
! !

!AppColumnDataViewer methodsFor:'aspects'!

angleX

    |holder|

    (holder := builder bindingAt:#angleX) isNil ifTrue:[
	builder aspectAt:#angleX put:(holder :=  ValueHolder new).
	holder addDependent:self.
    ].
    ^ holder
!

angleY

    |holder|

    (holder := builder bindingAt:#angleY) isNil ifTrue:[
	builder aspectAt:#angleY put:(holder :=  ValueHolder new).
	holder addDependent:self.
    ].
    ^ holder
!

columnHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#columnHolder) isNil ifTrue:[
	builder aspectAt:#columnHolder put:(holder :=  List new).
    ].
    ^ holder.

    "Modified: / 24.9.1998 / 13:45:29 / ps"
!

dialogInputSensorNumber

    |holder|

    (holder := builder bindingAt:#dialogInputSensorNumber) isNil ifTrue:[
	builder aspectAt:#dialogInputSensorNumber put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:10.
    ].
    ^ holder.

    "Modified: / 3.10.1998 / 13:10:57 / ps"
!

dialogInputYValuesToShow

    |holder|

    (holder := builder bindingAt:#dialogInputYValuesToShow) isNil ifTrue:[
	builder aspectAt:#dialogInputYValuesToShow put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:25.
    ].
    ^ holder.

    "Created: / 29.9.1998 / 14:19:56 / ps"
    "Modified: / 29.9.1998 / 14:29:49 / ps"
!

drawingFunc

    ^drawingFunc

!

drawingGrids

    ^drawingGrids
!

drawingGrids:aBoolean

    aBoolean ~~ drawingGrids ifTrue:[
	drawingGrids := aBoolean.
	self drawingGridsChanged.
    ].
!

drawingPlanes

    ^drawingPlanes
!

drawingPlanes:aBoolean

    aBoolean ~~ drawingPlanes ifTrue:[
	drawingPlanes := aBoolean.
	self drawingPlanesChanged.
    ].
!

drawingSolid

    ^drawingSolid
!

drawingSolid:aBoolean

    aBoolean ~~ drawingSolid ifTrue:[
	drawingSolid := aBoolean.
	self drawingStyleChanged.
    ].
!

scaleXValue

    |holder|

    (holder := builder bindingAt:#scaleXValue) isNil ifTrue:[
	builder aspectAt:#scaleXValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:1.0.
    ].
    ^ holder
!

scaleYValue

    |holder|

    (holder := builder bindingAt:#scaleYValue) isNil ifTrue:[
	builder aspectAt:#scaleYValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:1.0.
    ].
    ^ holder
!

scaleZValue

    |holder|

    (holder := builder bindingAt:#scaleZValue) isNil ifTrue:[
	builder aspectAt:#scaleZValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:1.0.
    ].
    ^ holder
!

selectedFuncIndex

    ^selectedFunc
!

selectedFuncIndex:aFunc

    |oldFunc|

    oldFunc := drawingFunc value.
    (self openDialogInterface:#dialogSpec1) ifTrue:[
	self stopDataProcess.
	view reinitialize.
	self reinitialize.
	self initializeFunc:aFunc.
	self startDataProcess.
	selectedFunc := aFunc.
    ]ifFalse:[
	drawingFunc value:oldFunc.
    ].

!

separatorPlaneIntensity
    |holder|

    (holder := builder bindingAt:#separatorPlaneIntensity) isNil ifTrue:[
	builder aspectAt:#separatorPlaneIntensity put:(holder :=  ValueHolder new).
	holder value:1.0.
	holder addDependent:self.
    ].
    ^ holder.

    "Modified: / 3.10.1998 / 13:30:27 / ps"
    "Created: / 3.10.1998 / 15:24:58 / ps"
!

separatorPlaneYValue

    |holder|

    (holder := builder bindingAt:#separatorPlaneYValue) isNil ifTrue:[
	builder aspectAt:#separatorPlaneYValue put:(holder :=  ValueHolder new).
	holder value:1.0.
	holder addDependent:self.
    ].
    ^ holder

    "Created: / 2.10.1998 / 21:49:16 / ps"
    "Modified: / 2.10.1998 / 21:54:14 / ps"
!

stopApplication
    |holder|

    (holder := builder bindingAt:#stopApplication) isNil ifTrue:[
	builder aspectAt:#stopApplication put:(holder :=  RadioButtonGroup new).
	holder value:#start.
	holder addDependent:self.
    ].
    ^ holder.

    "Created: / 29.9.1998 / 12:15:50 / ps"
    "Modified: / 29.9.1998 / 12:24:54 / ps"
!

switchSeparatorPlane
    |holder|

    (holder := builder bindingAt:#switchSeparatorPlane) isNil ifTrue:[
	builder aspectAt:#switchSeparatorPlane put:(holder :=  RadioButtonGroup new).
	holder value:#true.
	holder addDependent:self.
    ].
    ^ holder.

    "Modified: / 2.10.1998 / 16:38:35 / ps"
    "Created: / 2.10.1998 / 21:32:20 / ps"
!

tableColumns
    |holder|

    (holder := builder bindingAt:#tableColumns) isNil ifTrue:[
	builder aspectAt:#tableColumns put:(holder :=  SelectionInList new).
    ].
    ^ holder.

    "Modified: / 24.9.1998 / 15:15:31 / ps"
!

textYPlaneValue
    |holder|

    (holder := builder bindingAt:#textYPlaneValue) isNil ifTrue:[
	builder aspectAt:#textYPlaneValue put:(holder :=  ValueHolder new).
    ].
    ^ holder.

    "Created: / 3.10.1998 / 12:10:03 / ps"
    "Modified: / 3.10.1998 / 12:10:19 / ps"
! !

!AppColumnDataViewer methodsFor:'change & update'!

update:what with:aPara from:chgObj

    |index val|

    chgObj == self stopApplication ifTrue:[
	view stopApplication:(chgObj value ~~ #start).
	^self.
    ].

    chgObj == self switchSeparatorPlane ifTrue:[
	view drawSeparatorPlane:(chgObj value == #true).
	^self.
    ].

    chgObj == self separatorPlaneYValue ifTrue:[
	val := chgObj value.
	val > maxY ifTrue:[
	    ^chgObj value:maxY
	].
	val < minY ifTrue:[
	    ^chgObj value:minY.
	].
	val ~= separatorPlaneYValue ifTrue:[
	    separatorPlaneYValue := val.
	    view separatorPlaneYValue:(chgObj value).
	].
	^self.
    ].

    chgObj == self separatorPlaneIntensity ifTrue:[
	val := chgObj value.
	val > 1.0 ifTrue:[
	    ^chgObj value:1.0
	].
	val < 0.0 ifTrue:[
	    ^chgObj value:0.0
	].
	val ~= separatorPlaneIntensity ifTrue:[
	    separatorPlaneIntensity := val.
	    view separatorPlaneIntensity:(chgObj value).
	].
	^self.
    ].

    chgObj == self scaleXValue ifTrue:[
	view update:#scaleX with:chgObj value from:chgObj.
	^self.
    ].

    chgObj == self scaleYValue ifTrue:[
	view update:#scaleY with:chgObj value from:chgObj.
	^self.
    ].

    chgObj == self scaleZValue ifTrue:[
	view update:#scaleZ with:chgObj value from:chgObj.
	^self.
    ].

    chgObj == self angleY ifTrue:[
	view update:#angleY with:chgObj value from:chgObj.
	^self.
    ].

    chgObj == self angleX ifTrue:[
	view update:#angleX with:chgObj value from:chgObj.
	^self.
    ].

    (self columnHolder includes:chgObj) ifTrue:[
	index := self columnHolder indexOf:chgObj.
	what == #visibility ifTrue:[
	    (view listOfColumns at:index) shown:(chgObj visibility).
	].
	what == #showName ifTrue:[
	    (view listOfColumns at:index) showName:(chgObj showName).
	].
	what == #name ifTrue:[
	    (view listOfColumns at:index) name:(chgObj name).
	].
	what == #showPeak ifTrue:[
	    (view listOfColumns at:index) showPeak:(chgObj showPeak).
	].
	what == #peak ifTrue:[
	    (view listOfColumns at:index) peak:(chgObj peak).
	].

	^self.
    ].

    super update:what with:aPara from:chgObj

    "Modified: / 3.10.1998 / 15:26:42 / ps"
! !

!AppColumnDataViewer methodsFor:'function accessing'!

initRandomValuesForSensor:nameOfSensor

    |sensor randValue sourceArray|

    randValue := IntegerDataGeneration new.
    randValue startValue:30.
    randValue minValue:20.
    randValue maxValue:80.
    randValue maxDelta:5.
    randValue minPeek:170.
    randValue maxPeek:200.
    randValue peekProbability:0.995.
    randValue peekNumbers:8.

    sourceArray := Array new:500.
    1 to:(sourceArray size) do:[:i| sourceArray at:i put:(randValue getValue)].

    sensor := IdentityDictionary new.
    sensor at:#name put:nameOfSensor.
    sensor at:#randValue put:randValue.
    sensor at:#sourceArray put:sourceArray.
    sensor at:#index put:1.
    sensor at:#newValuesRemoved put:false.
    sensor at:#oldValues put:(OrderedCollection new:maxOldValuesToHold).
    sensorArray add:sensor.

    "Created: / 24.9.1998 / 18:49:16 / ps"
    "Modified: / 24.9.1998 / 18:55:32 / ps"
!

initSinAndCosForSensor:nameOfSensor

    |sensor randValue sourceArray x|

    sourceArray := Array new:63.
    x := 0.0.
    (nameOfSensor -((nameOfSensor//2)*2) = 0) ifTrue:[
	1 to:(sourceArray size) do:[:i| sourceArray at:i put:(100 * (x sin)). x := x + 0.1 ].
    ] ifFalse:[
	1 to:(sourceArray size) do:[:i| sourceArray at:i put:(100 * (x cos)). x := x + 0.1 ].
    ].

    sensor := IdentityDictionary new.
    sensor at:#name put:nameOfSensor.
    sensor at:#sourceArray put:sourceArray.
    sensor at:#index put:1.
    sensor at:#newValuesRemoved put:false.
    sensor at:#oldValues put:(OrderedCollection new:maxOldValuesToHold).
    sensorArray add:sensor.

    "Created: / 24.9.1998 / 18:49:16 / ps"
    "Modified: / 25.9.1998 / 12:15:53 / ps"
!

randomValuesForRow:name anArray:anArray aSize:aSize aMode:aMode

    |sensor sourceArray index offset randValue oldValues|

    sensorArray do:[:i|
	(i at:#name) = name ifTrue:[
	    sensor := i.
	].
    ].

    sensor isNil ifTrue:[self halt].

    aMode = #new ifTrue:[
	sourceArray := sensor at:#sourceArray.
	index := sensor at:#index.
	randValue := sensor at:#randValue.

	"copy values from source array to anArray"
	"source array is an cyclic buffer"
	1 to:aSize do:[:i|
	   |v|
	   index > (sourceArray size) ifTrue:[
	       "end of cyclic buffer reached"
	       "set index to the beginning of the buffer"
	       index:=1.
	   ].
	   "get new random value out of sourceArray"
	   v := sourceArray at:index.
	   v isNil ifTrue:[
	       "value is not initialized, do it"
	       v := randValue getValue.
	       sourceArray at:index put: v.
	   ].
	   "set rndom value to result array"
	   anArray at:i put: v.
	   "set new random value at the actual index in sourceArray"
	   v := randValue getValue.
	   sourceArray at:index put: v.
	   index := index +1.
	].

	sensor at:#sourceArray put:sourceArray.
	sensor at:#index put:index.
	oldValues := (sensor at:#oldValues).
	"save new values to oldValues array because we need them for redrawing"
	(oldValues size + anArray size)< maxOldValuesToHold ifTrue:[
	    "oldValues has the specific size maxOldValuesToHold, do not change"
	    oldValues addAll:anArray.
	]ifFalse:[
	    oldValues removeFromIndex:1 toIndex:(anArray size).
	    oldValues addAll:anArray.
	].
    ]ifFalse:[
	"get old values from oldValues array"
	self halt.
    ].

    "Created: / 24.9.1998 / 18:49:16 / ps"
    "Modified: / 25.9.1998 / 14:08:20 / ps"
!

sinAndCosForRow:name anArray:anArray aSize:aSize aMode:aMode

    |sensor sourceArray index oldValues size|

    sensorArray do:[:i|
	(i at:#name) = name ifTrue:[
	    sensor := i.
	].
    ].

    sensor isNil ifTrue:[self halt].

    aMode = #new ifTrue:[
	sourceArray := sensor at:#sourceArray.
	index := sensor at:#index.
	1 to: aSize do:[:i|
	    index < (sourceArray size) ifTrue:[
		anArray at:i put:(sourceArray at:index).
	    ]ifFalse:[
		index := 1.
		anArray at:i put:(sourceArray at:1).
	    ].
	    index := index + 1.
	].
	sensor at:#index put:index.
	oldValues := (sensor at:#oldValues).
	"save new values to oldValues array because we need them for redrawing"
	(oldValues size + anArray size)<= maxOldValuesToHold ifTrue:[
	    "oldValues has the specific size maxOldValuesToHold, do not change"
	    oldValues addAll:anArray.
	]ifFalse:[
	    oldValues removeFromIndex:1 toIndex:(anArray size).
	].
    ]ifFalse:[
	oldValues := (sensor at:#oldValues).
	oldValues size < anArray size ifTrue:[
	    size := oldValues size.
	]ifFalse:[
	    size := anArray size.
	].
	1 to: size do:[:i|
	    anArray at:i put:(oldValues at:i).
	].
    ].

    "Modified: / 29.9.1998 / 14:11:25 / ps"
! !

!AppColumnDataViewer methodsFor:'hooks'!

closeRequest
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the topView has been asked to close"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "return without the 'super closeRequest' to stay open"

    ^super closeRequest!

postBuildWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    super postBuildWith:aBuilder!

postOpenWith:aBuilder

    super postOpenWith:aBuilder.
    view := (builder componentAt: #DataViewer3D) scrolledView.

    self initializeFunc:#random.
    self startDataProcess.
! !

!AppColumnDataViewer methodsFor:'initialization'!

XXinitGraph

    | list col offset index|

    list   := TDVDataMesh new.

      1 to: 5 do:[:idx|
	|value source|

	offset := 1.
	index  := 1.

	value := TDVIntegerDataGeneration new.
	value initialize.
	value minValue:-100.
	value maxValue:100.
	value maxDelta:10.
	value startValue:-50.

	col := TDVColumnData name:idx.
	col minY:-100.
	col maxY:100.
	" should be two times greater than anArray "
	" XXX - is this ok? "
	source := Array new:500.
	1 to:(source size) do:[:i| source at:i put: value getValue].

	col functionYblock:[:start :anArray|
	    "Zufallswerte"
	    (anArray size)<(source size) ifTrue:[
		index := offset.
		1 to:(anArray size) do:[:i| |v|
		   index > (source size) ifTrue:[
		       index:=1.
		   ].
		   v := source at:index.
		   v isNil ifTrue:[
		       v := value getValue.
		       source at:index put: v.
		   ].
		   anArray at:i put: v.
		   v := value getValue.
		   source at:index put: v.
		   index := index +1.
		].
		offset := index.
"/                Transcript showCR: offset.
	    ]ifFalse:[
		self halt.
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.04.
	].

    ] forkAt:8.

!

XXinitGraphSin

    | list col offset index x|

    list   := TDVDataMesh new.

      1 to: 4 do:[:idx|
	|value source|

	offset := 1.
	index  := 1.

	col := TDVColumnData name:idx.
	col minY:-100.
	col maxY:100.

	col functionYblock:[:start :anArray|
	    x:=0.0.
	    (idx -((idx//2)*2) = 0) ifTrue:[
		1 to:(anArray size) do:[:i| anArray at:i put:100 * (x sin). x := x + 0.1 ].
	    ] ifFalse:[
		1 to:(anArray size) do:[:i| anArray at:i put:100 * (x cos). x := x + 0.1 ].
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:2.
    view yValuesToShow:100.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.04.
	].

    ] forkAt:8.
!

XinitGraphSin

    | list col offset index x|

    list   := TDVDataMesh new.

      1 to: 40 do:[:idx|
	|index source|
	index  := 1.

	col := TDVColumnData name:idx.
	col minY: -100.
	col maxY: 100.
	source := Array new:63.
	(idx -((idx//2)*2) = 0) ifTrue:[
	    1 to:(source size) do:[:i| source at:i put:100 * (x sin). x := x + 0.1 ].
	] ifFalse:[
	    1 to:(source size) do:[:i| source at:i put:100 * (x cos). x := x + 0.1 ].
	].

	col functionYblock:[:start :anArray|
	    1 to:(anArray size) do:[:i|
		anArray at:i put:(source at:index).
		((index + 1) <= source size) ifTrue:[
		    index := index + 1.
		]ifFalse:[
		    index := 1.
		].
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:2.
    view yValuesToShow:100.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.04.
	].

    ] forkAt:8.
!

XinitializeRandom

    |list listOfColumns|

    list := ColumnDataMesh new.

      1 to: self dialogInputSensorNumber value do:[:idx|
	|value source col index offset name|

	offset := 1.
	index  := 1.
	name := idx.

	value := IntegerDataGeneration new.
	value startValue:30.
	value minValue:20.
	value maxValue:80.
	value maxDelta:5.
	value minPeek:170.
	value maxPeek:200.
	value peekProbability:0.995.
	value peekNumbers:8.

	col := ColumnData name:idx.
	col minY:20.
	col maxY:200.
	col shown:true.
	source := Array new:500.
	1 to:(source size) do:[:i| source at:i put:(value getValue)].

	col functionYblock:[:anArray :aSize :aMode|
	    "Zufallswerte"
	    |method|
	    self halt.
	    ^self randomValuesForRow:name anArray:anArray aSize:aSize aMode:aMode.
	].
	list add:col.
    ].

    view yValuesToShow:25.
    view drawGraph:true.
    view drawAxis:true.
    view drawGrid:true.
    view columns:list.
    view xdiff:20.
    view zdiff:40.
    view numOfYData:1.
    "max. number for stepForAnimation is xdiff * nunOfYData"
    view stepForAnimation:5.
    view finishInitialization.

    self initializeColumnTabel.

    "Modified: / 13.10.1998 / 12:55:11 / ps"
!

initGraph

    | list col offset index|

    list   := ColumnDataMesh new.

      1 to: 10 do:[:idx|
	|value source|

	offset := 1.
	index  := 1.

	value := IntegerDataGeneration new.
	value startValue:-50.
	value minValue:-100.
	value maxValue:0.
	value maxDelta:10.
	value minPeek:80.
	value maxPeek:100.
	value peekProbability:0.995.

	col := ColumnData name:idx.
	col minY:-100.
	col maxY:100.
	" should be two times greater than anArray "
	" XXX - is this ok? "
	source := Array new:500.
	1 to:(source size) do:[:i| source at:i put: value getValue].

	col functionYblock:[:start :anArray|
	    "Zufallswerte"
	    (anArray size)<(source size) ifTrue:[
		index := offset.
		1 to:(anArray size) do:[:i| |v|
		   index > (source size) ifTrue:[
		       index:=1.
		   ].
		   v := source at:index.
		   v isNil ifTrue:[
		       v := value getValue.
		       source at:index put: v.
		   ].
		   anArray at:i put: v.
		   v := value getValue.
		   source at:index put: v.
		   index := index +1.
		].
		offset := index.
"/                Transcript showCR: offset.
	    ]ifFalse:[
		self halt.
	    ].
	    anArray
	].
	list add:col.
    ].

    view yValuesToShow:100.
    view drawGraph:true.
    view drawAxis:true.
    view drawGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:3.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.01.
	].

    ] forkAt:8.

    "Modified: / 13.10.1998 / 12:55:14 / ps"
!

initGraphSimple

    | list col index x|

    list   := TDVDataMesh new.

      1 to: 2 do:[:idx|
	|index source|
	index  := 1.

	col := TDVColumnData name:idx.
	col minY: 1.
	col maxY: 200.
	source := Array new:399.
	1 to:200 do:[:i|
	    source at:i put:i.
	].
	1 to:199 do:[:i|
	    source at:i+200 put:200-i.
	].
	col functionYblock:[:start :anArray|
	    1 to:(anArray size) do:[:i|
		anArray at:i put:(source at:index).
		((index + 1) <= source size) ifTrue:[
		    index := index + 1.
		]ifFalse:[
		    index := 1.
		].
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:3.
    view yValuesToShow:100.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.2.
	].

    ] forkAt:8.
!

initGraphSimple2

    | list col index x|

    list   := TDVDataMesh new.

      1 to: 2 do:[:idx|
	|index source|
	index  := 1.

	col := TDVColumnData name:idx.
	col minY: 0.
	col maxY: 200.
	col functionYblock:[:start :anArray|
	    1 to:(anArray size) do:[:i|
		index-((index//2)*2) = 0 ifTrue:[
		    anArray at:i put:0.
		]ifFalse:[
		    anArray at:i put:200.
		].
		index := index + 1.
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:20.
    view zdiff:40.
    view numOfYData:2.
    view yValuesToShow:50.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.2.
	].

    ] forkAt:8.
!

initGraphSin

    | list col offset index x|

    list   := ColumnDataMesh new.

      1 to: 3 do:[:idx|
	|index source|
	index  := 1.

	col := ColumnData name:idx.
	col minY: -100.
	col maxY: 100.
	source := Array new:63.
	x := 0.0.
	(idx -((idx//2)*2) = 0) ifTrue:[
	    1 to:(source size) do:[:i| source at:i put:100 * (x sin). x := x + 0.1 ].
	] ifFalse:[
	    1 to:(source size) do:[:i| source at:i put:100 * (x cos). x := x + 0.1 ].
	].

	col functionYblock:[:start :anArray|
	    1 to:(anArray size) do:[:i|
		anArray at:i put:(source at:index).
		((index + 1) <= source size) ifTrue:[
		    index := index + 1.
		]ifFalse:[
		    index := 1.
		].
	    ].
	    anArray
	].
	list add:col.
    ].

    view showGraph:true.
    view showAxis:true.
    view showGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:3.
    view yValuesToShow:100.


    [   |o i t c|

	i := 0.
	t := 0.
	c := 0.

	[self window realized] whileTrue:[
"/            "t := t + (Time millisecondsToRun:[ view rotateY:i]").
"/            i := i + 1.
"/            c := c + 1.
"/            c == 90 ifTrue:[
"/                Transcript showCR:'Time: ', t printString.
"/                t := 0.
"/                c := 0.
"/                Transcript showCR:'data'.
		view doInvalidateGraph.
"/            ].
	    Delay waitForSeconds:0.04.
	].

    ] forkAt:8.

    "Modified: / 13.10.1998 / 12:55:18 / ps"
!

initialize

    super initialize.

"/    drawingFunc := #random asValue.
"/    drawingFunc onChangeSend:#drawingFuncChanged to:self.

    drawingFunc := AspectAdaptor new subject:self.
    drawingFunc forAspect:#selectedFuncIndex.
    selectedFunc := #random.

    drawingSolid   := true.
    drawingPlanes  := true.
    drawingGrids   := true.
    multi := 1.0.
    maxY := 1.0.
    minY := 0.0.
    actDataIndex := 1.
    sensorArray := OrderedCollection new.

    "Modified: / 2.10.1998 / 21:20:44 / ps"
!

initializeColumnTabel

    |listOfColumns|

    self columnHolder removeAll.

    listOfColumns := view listOfVisibleColumns.
    listOfColumns do:[:i|
	|row|
	row := (TDV::AppColumnDataViewer::ColumnRow) new.
	row showName:(i showName).
	row name:(i name).
	row visibility:(i shown).
	row showPeak:(i showPeak).
	row peak:(i peak).
	self columnHolder add:row.
	row addDependent:self.
    ].

    "Created: / 24.9.1998 / 14:36:38 / ps"
    "Modified: / 12.10.1998 / 10:04:10 / ps"
!

initializeFunc:aFunc

    | list col offset index|

    aFunc == #random ifTrue:[
	self initializeRandom.
    ]ifFalse:[
	aFunc == #sinAndCos ifTrue:[
	    self initializeSinAndCos.
	].
    ].

!

initializeMenu


    drawingSolid   := view drawSolid.
    drawingPlanes  := view drawAxis.
    self switchSeparatorPlane value:(view drawSeparatorPlane printString asSymbol).
    drawingGrids   := view drawGrid.
    minY := view columns minY.
    maxY := view columns maxY.
    view separatorPlaneYValue:maxY/2.
    separatorPlaneYValue := (maxY+minY)/2.
    self separatorPlaneYValue value:separatorPlaneYValue.
    self separatorPlaneIntensity value:(view separatorPlaneIntensity).
    self textYPlaneValue value:'minY: ',minY printString,' maxY: ',maxY printString.

    "Created: / 24.9.1998 / 14:36:38 / ps"
    "Modified: / 3.10.1998 / 15:29:42 / ps"
!

initializeRandom

    |list numberOfSensors|

    numberOfSensors := self dialogInputSensorNumber value.
    maxOldValuesToHold := self dialogInputYValuesToShow value.
    list := ColumnDataMesh new.
    view yValuesToShow:maxOldValuesToHold.
    view drawGraph:true.
    view drawAxis:true.
    view drawGrid:true.
    view drawSeparatorPlane:false.
    view xdiff:20.
    view zdiff:40.
    view numOfYData:1.
    "max. number for stepForAnimation is xdiff * nunOfYData"
    view stepForAnimation:5.

      1 to: numberOfSensors do:[:idx|
	|col name|

	name := idx.
	col := ColumnData name:name.
	col showName:true.
	self initRandomValuesForSensor:name.
	col minY:20.
	col maxY:200.
	col shown:true.
	col peak:170.0.
	col showPeak:true.

	col functionYblock:[:anArray :aSize :aMode|
	    "return anArray set up with the random values"
	    self randomValuesForRow:name anArray:anArray aSize:aSize aMode:aMode.
	    anArray.
	].
	list add:col.
    ].

    view columns:list.
    view finishInitialization.

    self initializeColumnTabel.
    self initializeMenu.

    "Modified: / 13.10.1998 / 12:55:20 / ps"
!

initializeSimple1

    |list|

    list := ColumnDataMesh new.

    1 to: 5 do:[:idx|
	|index source col|
	index  := 1.

	col := ColumnData name:idx.
	col minY: 1.
	col maxY: 200.
	source := Array new:399.
	1 to:200 do:[:i|
	    source at:i put:i.
	].
	1 to:199 do:[:i|
	    source at:i+200 put:200-i.
	].
	col functionYblock:[:anArray|
	    1 to:(anArray size) do:[:i|
		anArray at:i put:(source at:index).
		((index + 1) <= source size) ifTrue:[
		    index := index + 1.
		]ifFalse:[
		    index := 1.
		].
	    ].
	    anArray
	].
	list add:col.
    ].

    view yValuesToShow:100.
    view drawGraph:true.
    view drawAxis:true.
    view drawGrid:true.
    view columns:list.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:2.
    "max. number for stepForAnimation is xdiff * nunOfYData"
    view stepForAnimation:5.

    "Modified: / 13.10.1998 / 12:55:22 / ps"
!

initializeSinAndCos

    |list numberOfSensors|

    numberOfSensors := self dialogInputSensorNumber value.
    maxOldValuesToHold := self dialogInputYValuesToShow value.
    list := ColumnDataMesh new.
    view yValuesToShow:maxOldValuesToHold.
    view drawGraph:true.
    view drawAxis:true.
    view drawGrid:true.
    view drawSeparatorPlane:false.
    view xdiff:5.
    view zdiff:40.
    view numOfYData:1.
    "max. number for stepForAnimation is xdiff * nunOfYData"
    view stepForAnimation:5.

      1 to:  numberOfSensors do:[:idx|
	|col name|

	name := idx.
	col := ColumnData name:name.
	col showName:true.
	self initSinAndCosForSensor:name.
	col minY: -100.
	col maxY: 100.
	col shown:true.
	col peak:100.0.
	col showPeak:true.

	col functionYblock:[:anArray :aSize :aMode|
	    "return anArray set up with the sin or cos values"
	    self sinAndCosForRow:name anArray:anArray aSize:aSize aMode:aMode.
	    anArray
	].
	list add:col.
    ].

    view columns:list.
    view finishInitialization.

    self initializeColumnTabel.
    self initializeMenu.

    "Modified: / 13.10.1998 / 12:55:23 / ps"
!

reinitialize


    self angleX value:0.0.
    self angleY value:0.0.
    self scaleXValue value:1.0.
    self scaleYValue value:1.0.
    self scaleZValue value:1.0.
    self drawingGrids:true.
    self drawingPlanes:true.
    self drawingSolid:true.

    "Modified: / 1.10.1998 / 12:25:29 / ps"
! !

!AppColumnDataViewer methodsFor:'menu actions'!

drawingGridsChanged
"switch the drawing style of grids for the TDV framework to on/off
"
    view drawGrid: drawingGrids value.

    "Modified: / 2.10.1998 / 15:03:50 / ps"
!

drawingPlanesChanged
"switch the drawing style of planes for the TDV framework to on/off
"
    view drawAxis: drawingPlanes value.

    "Modified: / 2.10.1998 / 15:49:03 / ps"
!

drawingSeperatorPlaneChanged
"switch the drawing style of seperator planes for the TDV framework to on/off
"
    view drawSeperatorPlane:drawingSeperatorPlane value.

    "Created: / 2.10.1998 / 15:51:55 / ps"
    "Modified: / 2.10.1998 / 15:52:15 / ps"
!

drawingStyleChanged
"set the solid drawing style of the data function for the TDV framework to true or false
"
    view drawSolid: drawingSolid value.

    "Modified: / 2.10.1998 / 15:04:49 / ps"
! !

!AppColumnDataViewer methodsFor:'processes'!

startDataProcess
"start process which indicates new data to the TDV framework via doInvalidateGraph
"
    process isNil ifTrue:[
	process := Process for:[
	    [self window realized] whileTrue:[
		view doInvalidateGraph.
		Delay waitForSeconds:0.1.
	    ].
	] priority:( Processor activePriority - 1 ).
	process name:'TDV invalidater'.
	process resume.
    ].

    "Modified: / 2.10.1998 / 20:58:45 / ps"
!

stopDataProcess
"stop process which indicates new data to the TDV framework via doInvalidateGraph
"
    process isNil ifFalse:[
	process terminate.
	process := nil.
    ].

    "Modified: / 2.10.1998 / 15:01:18 / ps"
! !

!AppColumnDataViewer::ColumnRow methodsFor:'accessing'!

name

    ^name

    "Created: / 29.9.1998 / 12:52:52 / ps"
    "Modified: / 29.9.1998 / 12:53:36 / ps"
!

name:aValue

    aValue ~~ name ifTrue:[
	name := aValue printString.
	self changed:#name.
    ].

    "Created: / 29.9.1998 / 12:52:58 / ps"
    "Modified: / 29.9.1998 / 13:01:49 / ps"
!

peak

    ^peak

    "Modified: / 29.9.1998 / 12:53:36 / ps"
    "Created: / 30.9.1998 / 12:23:11 / ps"
!

peak:aValue

    aValue  ~~ peak ifTrue:[
	peak := aValue.
	self changed:#peak.
    ].

    "Modified: / 30.9.1998 / 10:34:33 / ps"
    "Created: / 30.9.1998 / 12:23:20 / ps"
!

showName

    ^showName

    "Modified: / 24.9.1998 / 15:20:04 / ps"
    "Created: / 30.9.1998 / 15:05:37 / ps"
!

showName:aBoolean

    aBoolean ~~ showName ifTrue:[
	showName := aBoolean.
	self changed:#showName.
    ].

    "Modified: / 30.9.1998 / 10:25:44 / ps"
    "Created: / 30.9.1998 / 15:06:15 / ps"
!

showPeak

    ^showPeak

    "Modified: / 24.9.1998 / 15:20:04 / ps"
    "Created: / 30.9.1998 / 12:23:32 / ps"
!

showPeak:aBoolean

    aBoolean ~~ showPeak ifTrue:[
	showPeak := aBoolean.
	self changed:#showPeak.
    ].

    "Modified: / 30.9.1998 / 10:25:44 / ps"
    "Created: / 30.9.1998 / 12:23:42 / ps"
!

togglePeakLabels:aValue

    showPeak ifTrue:[
	showPeak := false
    ]ifFalse:[
	showPeak := true
    ].
    self changed:#showPeak.

    "Modified: / 29.9.1998 / 12:50:28 / ps"
    "Created: / 30.9.1998 / 12:24:02 / ps"
!

toggleShowName:aValue

    showName ifTrue:[
	showName := false
    ]ifFalse:[
	showName := true
    ].
    self changed:#showName.

    "Modified: / 29.9.1998 / 12:50:28 / ps"
    "Created: / 30.9.1998 / 15:09:04 / ps"
!

toggleVisibility:aValue

    visibility ifTrue:[
	visibility := false
    ]ifFalse:[
	visibility := true
    ].
    self changed:#visibility.

    "Created: / 24.9.1998 / 14:27:00 / ps"
    "Modified: / 29.9.1998 / 12:50:28 / ps"
!

visibility

    ^visibility

    "Modified: / 24.9.1998 / 15:20:04 / ps"
!

visibility:aBoolean

    aBoolean ~~ visibility ifTrue:[
	visibility := aBoolean.
	self changed:#visibility.
    ].

    "Created: / 24.9.1998 / 13:23:55 / ps"
    "Modified: / 29.9.1998 / 12:47:38 / ps"
! !

!AppColumnDataViewer::ColumnRow methodsFor:'initialization'!

initialize

    super initialize.

    showName := true.
    name:= 1 printString.
    visibility := true.
    showPeak := true.
    peak := 1.0.

    "Modified: / 30.9.1998 / 15:05:59 / ps"
! !

!AppColumnDataViewer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/obsolete/AppColumnDataViewer.st,v 1.2 2016-11-01 14:42:20 cg Exp $'
! !
