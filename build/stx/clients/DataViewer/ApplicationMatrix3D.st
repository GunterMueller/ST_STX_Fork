"{ NameSpace: TDV }"

ApplicationModel subclass:#ApplicationMatrix3D
	instanceVariableNames:'view drawingFunc drawFrameForPresentation drawAxisForPresentation
		drawPlaneForPresentation process lastHit multi selectedFunc
		actDataIndex sensorArray maxY minY separatorPlaneYValue
		separatorPlaneIntensity scale1 scale2 quo dataForFunction
		dataManager deltaY components dimensionX dimensionZ
		pickSelectionHolder accessLock lockDataForFunction
		drawGridForXAxisFirst drawGridForXAxisSecond
		drawGridForYAxisFirst drawGridForYAxisSecond
		drawGridForZAxisFirst drawGridForZAxisSecond'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-OpenGL'
!


!ApplicationMatrix3D class methodsFor:'interface specs'!

dialogSpec1
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TDV::ApplicationMatrix3D andSelector:#dialogSpec1
     TDV::ApplicationMatrix3D new openInterface:#dialogSpec1
    "

    <resource: #canvas>

    ^

       #(#FullSpec
	  #window:
	   #(#WindowSpec
	      #name: 'Function settings'
	      #layout: #(#LayoutFrame 550 0 110 0 888 0 264 0)
	      #label: 'Function settings'
	      #min: #(#Point 10 10)
	      #max: #(#Point 1024 768)
	      #bounds: #(#Rectangle 550 110 889 265)
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
		    #layout: #(#LayoutFrame 252 0 67 0 270 0 100 0)
		    #upAction: #setSensorNumber:
		    #downAction: #setSensorNumber:
		    #upArgument: 'inc'
		    #downArgument: 'dec'
		)
		 #(#InputFieldSpec
		    #name: 'EntryField1'
		    #layout: #(#LayoutFrame 205 0 72 0 247 0 94 0)
		    #model: #dialogInputSensorNumber
		    #isReadOnly: true
		    #type: #number
		    #numChars: 4
		)
		 #(#LabelSpec
		    #name: 'Label1'
		    #layout: #(#LayoutFrame 68 0 73 0 199 0 95 0)
		    #label: 'Number of z values'
		    #translateLabel: true
		    #adjust: #left
		)
		 #(#InputFieldSpec
		    #name: 'EntryField2'
		    #layout: #(#LayoutFrame 205 0 20 0 247 0 42 0)
		    #model: #dialogInputYValuesToShow
		    #isReadOnly: true
		    #type: #number
		    #numChars: 4
		)
		 #(#UpDownButtonSpec
		    #name: 'UpDownButton2'
		    #layout: #(#LayoutFrame 252 0 15 0 270 0 48 0)
		    #upAction: #setYValuesNumber:
		    #downAction: #setYValuesNumber:
		    #upArgument: 'inc'
		    #downArgument: 'dec'
		)
		 #(#LabelSpec
		    #name: 'Label2'
		    #layout: #(#LayoutFrame 68 0 22 0 202 0 42 0)
		    #label: 'Number of x values'
		    #translateLabel: true
		    #adjust: #left
		)
	      )
	  )
      )

    "Modified: / 16.10.1998 / 11:45:56 / ps"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TDV::ApplicationMatrix3D andSelector:#windowSpec
     TDV::ApplicationMatrix3D new openInterface:#windowSpec
     TDV::ApplicationMatrix3D open
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #windowSpec
	#window:
       #(#WindowSpec
	  #label: '3D Matrix Viewer'
	  #name: '3D Matrix Viewer'
	  #layout: #(#LayoutFrame 214 0 171 0 1013 0 820 0)
	  #level: 0
	  #min: #(#Point 800 650)
	  #max: #(#Point 1024 720)
	  #bounds: #(#Rectangle 214 171 1014 821)
	  #menu: #menu
	  #usePreferredExtent: false
	  #returnIsOKInDialog: true
	  #escapeIsCancelInDialog: true
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#ArbitraryComponentSpec
	      #name: 'DataViewer3D'
	      #layout: #(#LayoutFrame 179 0 0 0 -20 1.0 -20 1.0)
	      #hasBorder: false
	      #component: #DataViewer3D
	    )
	   #(#FramedBoxSpec
	      #label: 'Scaling'
	      #name: 'FramedBox1'
	      #layout: #(#LayoutFrame -2 0 53 0 174 0 181 0)
	      #labelPosition: #topLeft
	      #style: #(#FontDescription #helvetica #bold #roman 12)
	      #translateLabel: true
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#LabelSpec
		    #label: 'Z:'
		    #name: 'ZLabel'
		    #layout: #(#LayoutFrame 25 0 71 0 45 0 93 0)
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
		    #label: 'Y:'
		    #name: 'Label3'
		    #layout: #(#LayoutFrame 22 0 36 0 42 0 58 0)
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
		    #label: 'X:'
		    #name: 'Label4'
		    #layout: #(#LayoutFrame 22 0 4 0 42 0 26 0)
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
	    )
	   #(#FramedBoxSpec
	      #label: 'Navigation'
	      #name: 'FramedBox2'
	      #layout: #(#LayoutFrame -2 0 181 0 174 0 376 0)
	      #labelPosition: #topLeft
	      #style: #(#FontDescription #helvetica #bold #roman 12)
	      #translateLabel: true
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'upIcon'
		    #name: 'moveUp'
		    #layout: #(#LayoutFrame 63 0 2 0 91 0 46 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'up'
		  )
		 #(#ActionButtonSpec
		    #label: 'rightIcon'
		    #name: 'moveRight'
		    #layout: #(#LayoutFrame 84 0 53 0 141 0 80 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'right'
		  )
		 #(#ActionButtonSpec
		    #label: 'downIcon'
		    #name: 'moveDown'
		    #layout: #(#LayoutFrame 63 0 89 0 91 0 133 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'down'
		  )
		 #(#ActionButtonSpec
		    #label: 'leftIcon'
		    #name: 'moveLeft'
		    #layout: #(#LayoutFrame 18 0 53 0 69 0 80 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'left'
		  )
		 #(#ActionButtonSpec
		    #label: 'forwardIcon'
		    #name: 'moveForward'
		    #layout: #(#LayoutFrame -3 0 2 0 24 0 46 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'forward'
		  )
		 #(#ActionButtonSpec
		    #label: 'backwardIcon'
		    #name: 'moveBack'
		    #layout: #(#LayoutFrame -3 0 89 0 24 0 133 0)
		    #hasCharacterOrientedLabel: false
		    #translateLabel: true
		    #model: #moveEye:
		    #isTriggerOnDown: true
		    #autoRepeat: true
		    #actionValue: 'back'
		  )
		 #(#ActionButtonSpec
		    #label: 'Reset Viewing'
		    #name: 'Button1'
		    #layout: #(#LayoutFrame 0 0 140 0 0 1 162 0)
		    #translateLabel: true
		    #model: #resetViewing
		  )
		 )

	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Animation'
	      #name: 'FramedBox5'
	      #layout: #(#LayoutFrame -2 0 3 0 174 0 53 0)
	      #labelPosition: #topLeft
	      #style: #(#FontDescription #helvetica #bold #roman 12)
	      #translateLabel: true
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#RadioButtonSpec
		    #label: 'stop'
		    #name: 'RadioButton2'
		    #layout: #(#LayoutFrame 78 0.0 1 0 130 0 23 0)
		    #translateLabel: true
		    #model: #stopApplication
		    #isTriggerOnDown: true
		    #lampColor: #(#Color 0.0 0.0 0.0)
		    #select: #stop
		  )
		 #(#RadioButtonSpec
		    #label: 'start'
		    #name: 'RadioButton1'
		    #layout: #(#LayoutFrame 14 0.0 1 0 63 0 23 0)
		    #translateLabel: true
		    #model: #stopApplication
		    #isTriggerOnDown: true
		    #lampColor: #(#Color 0.0 0.0 0.0)
		    #select: #start
		  )
		 )

	      )
	    )
	   #(#ThumbWheelSpec
	      #name: 'ThumbWheelRotateX'
	      #layout: #(#LayoutFrame -20 1.0 0 0 0 1.0 -20 1.0)
	      #model: #angleX
	      #step: 1
	      #endlessRotation: true
	    )
	   #(#ThumbWheelSpec
	      #name: 'ThumbWheelRotateY'
	      #layout: #(#LayoutFrame 179 0 -20 1.0 -20 1.0 0 1.0)
	      #model: #angleY
	      #orientation: #horizontal
	      #step: 1
	      #endlessRotation: true
	    )
	   #(#FramedBoxSpec
	      #label: 'Separator Plane'
	      #name: 'FramedBox6'
	      #layout: #(#LayoutFrame -2 0 373 0 174 0 534 0)
	      #labelPosition: #topLeft
	      #style: #(#FontDescription #helvetica #bold #roman 12)
	      #translateLabel: true
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#RadioButtonSpec
		    #label: 'on'
		    #name: 'RadioButton3'
		    #layout: #(#LayoutFrame 20 0.0 1 0 66 0 23 0)
		    #translateLabel: true
		    #model: #switchSeparatorPlane
		    #isTriggerOnDown: true
		    #lampColor: #(#Color 0.0 0.0 0.0)
		    #select: #true
		  )
		 #(#RadioButtonSpec
		    #label: 'off'
		    #name: 'RadioButton4'
		    #layout: #(#LayoutFrame 85 0 1 0 137 0 23 0)
		    #translateLabel: true
		    #model: #switchSeparatorPlane
		    #isTriggerOnDown: true
		    #lampColor: #(#Color 0.0 0.0 0.0)
		    #select: #false
		  )
		 #(#LabelSpec
		    #label: 'Y :'
		    #name: 'Label1'
		    #layout: #(#LayoutFrame 1 0 64 0 25 0 82 0)
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
		    #label: 'Intensity:'
		    #name: 'Label5'
		    #layout: #(#LayoutFrame 1 0 104 0 54 0 126 0)
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
	    )
	   #(#InputFieldSpec
	      #name: 'EntryField4'
	      #layout: #(#LayoutFrame 4 0 550 0 166 0 572 0)
	      #model: #pickSelectionHolderOnString
	      #style: #(#FontDescription #helvetica #medium #roman 10)
	      #isReadOnly: true
	    )
	   )

	)
      )

    "Modified: / 25.6.1999 / 14:35:19 / ps"
! !

!ApplicationMatrix3D class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:TDV::ApplicationMatrix3D andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(TDV::ApplicationMatrix3D menu)) startUp
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
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'Presentation'
	    #translateLabel: true
	    #submenu:
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'Grid'
		  #translateLabel: true
		  #submenu:
		 #(#Menu
		    #(
		     #(#MenuItem
			#label: 'Grid x-Axis (main plane)'
			#translateLabel: true
			#indication: #drawGridForXAxisFirst:
		      )
		     #(#MenuItem
			#label: 'Grid x-Axis (second plane)'
			#translateLabel: true
			#indication: #drawGridForXAxisSecond:
		      )
		     #(#MenuItem
			#label: '-'
		      )
		     #(#MenuItem
			#label: 'Grid y-Axis (main plane)'
			#translateLabel: true
			#indication: #drawGridForYAxisFirst:
		      )
		     #(#MenuItem
			#label: 'Grid y-Axis (second plane)'
			#translateLabel: true
			#indication: #drawGridForYAxisSecond:
		      )
		     #(#MenuItem
			#label: '-'
		      )
		     #(#MenuItem
			#label: 'Grid z-Axis (main plane)'
			#translateLabel: true
			#indication: #drawGridForZAxisFirst:
		      )
		     #(#MenuItem
			#label: 'Grid z-Axis (second plane)'
			#translateLabel: true
			#indication: #drawGridForZAxisSecond:
		      )
		     )
		    nil
		    nil
		  )
		)
	       #(#MenuItem
		  #label: 'Axis'
		  #translateLabel: true
		  #indication: #drawingAxis:
		)
	       #(#MenuItem
		  #label: 'Planes'
		  #translateLabel: true
		  #indication: #drawingPlanes:
		)
	       #(#MenuItem
		  #label: 'Frame'
		  #translateLabel: true
		  #indication: #drawingFrame:
		)
	       )
	      nil
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
		  #label: 'function1'
		  #translateLabel: true
		  #choice: #drawingFunc
		  #choiceValue: #function1
		)
	       #(#MenuItem
		  #label: 'function2'
		  #translateLabel: true
		  #choice: #drawingFunc
		  #choiceValue: #function2
		)
	       #(#MenuItem
		  #label: 'function3'
		  #translateLabel: true
		  #choice: #drawingFunc
		  #choiceValue: #function3
		)
	       #(#MenuItem
		  #label: 'function4'
		  #translateLabel: true
		  #choice: #drawingFunc
		  #choiceValue: #function4
		)
	       )
	      nil
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
		  #label: 'About Data Viewer 3D'
		  #translateLabel: true
		  #value: #openAboutThisApplication
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

    "Modified: / 25.6.1999 / 14:35:14 / ps"
! !

!ApplicationMatrix3D methodsFor:'accessing'!

backwardIcon

    ^Icon backwardIcon

!

downIcon

    ^Icon downIcon

!

drawingFunc

    ^drawingFunc

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

!ApplicationMatrix3D methodsFor:'accessing renderstyle'!

drawGridForXAxisFirst

    ^drawGridForXAxisFirst


!

drawGridForXAxisFirst:aBoolean

    aBoolean ~~ drawGridForXAxisFirst ifTrue:[
	drawGridForXAxisFirst := aBoolean.
	(components at:#labelForXAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForXAxisFirst.
	view doInvalidateGraph
    ].

!

drawGridForXAxisSecond

    ^drawGridForXAxisSecond


!

drawGridForXAxisSecond:aBoolean

    aBoolean ~~ drawGridForXAxisSecond ifTrue:[
	drawGridForXAxisSecond := aBoolean.
	(components at:#labelForXAxis) aspectAt:#drawGridForSecondPlane  put:drawGridForXAxisSecond.
	view doInvalidateGraph
    ].

!

drawGridForYAxisFirst

    ^drawGridForYAxisFirst


!

drawGridForYAxisFirst:aBoolean

    aBoolean ~~ drawGridForYAxisFirst ifTrue:[
	drawGridForYAxisFirst := aBoolean.
	(components at:#labelForYAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForYAxisFirst.
	view doInvalidateGraph
    ].

!

drawGridForYAxisSecond

    ^drawGridForYAxisSecond


!

drawGridForYAxisSecond:aBoolean

    aBoolean ~~ drawGridForYAxisSecond ifTrue:[
	drawGridForYAxisSecond := aBoolean.
	(components at:#labelForYAxis) aspectAt:#drawGridForSecondPlane  put:drawGridForYAxisSecond.
	view doInvalidateGraph
    ].

!

drawGridForZAxisFirst

    ^drawGridForZAxisFirst


!

drawGridForZAxisFirst:aBoolean

    aBoolean ~~ drawGridForZAxisFirst ifTrue:[
	drawGridForZAxisFirst := aBoolean.
	(components at:#labelForZAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForZAxisFirst.
	view doInvalidateGraph
    ].

!

drawGridForZAxisSecond

    ^drawGridForZAxisSecond


!

drawGridForZAxisSecond:aBoolean

    aBoolean ~~ drawGridForZAxisSecond ifTrue:[
	drawGridForZAxisSecond := aBoolean.
	(components at:#labelForZAxis) aspectAt:#drawGridForSecondPlane  put:drawGridForZAxisSecond.
	view doInvalidateGraph
    ].

!

drawingAxis

    ^drawAxisForPresentation


!

drawingAxis:aBoolean

    aBoolean ~~ drawAxisForPresentation ifTrue:[
	drawAxisForPresentation := aBoolean.
	(components at:#axis) aspectAt:#draw put:(drawAxisForPresentation value).
	view doInvalidateGraph
    ].

!

drawingFrame

    ^drawFrameForPresentation

!

drawingFrame:aBoolean

    aBoolean ~~ drawFrameForPresentation ifTrue:[
	drawFrameForPresentation := aBoolean.
	(components at:#frame) aspectAt:#draw put:(drawFrameForPresentation value).
	view doInvalidateGraph
    ].

!

drawingPlanes

    ^drawPlaneForPresentation

!

drawingPlanes:aBoolean

    aBoolean ~~ drawPlaneForPresentation ifTrue:[
	drawPlaneForPresentation := aBoolean.
	(components at:#plane) aspectAt:#draw put:(drawPlaneForPresentation value).
	view doInvalidateGraph
    ].

! !

!ApplicationMatrix3D methodsFor:'actions'!

XreinitOfColumn

    (view columns at:1) aspectAt:#shown put:false.

    "Created: / 16.10.1998 / 11:47:02 / ps"
!

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
"/    view endRotation.
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
    view doInvalidateGraph.


!

openAboutThisApplication
"about box with vendor and renderer information about openGL"

    |b textLabel sep info|

    b := DialogBox new.
    b label:'About DataViewer3D'.

    b addVerticalSpace:4.
    b addTextLabel:'3D Matrix Viewer by Pierre Schwarz 1998'.
    b addVerticalSpace:4.
    b addHorizontalLine.
    b addVerticalSpace:3.
    b addTextLabel:'Information about OpenGL:'.
    b addVerticalSpace:3.

    info := view glVendor.
    info isNil ifTrue:[
	info := 'information not available'.
    ].
    b addTextLabel:('Vendor: ',info).

    info := view glVersion.
    info isNil ifTrue:[
	info := 'information not available'.
    ].
    b addTextLabel:('OpenGL version: ',info).

    info := view gluVersion.
    info isNil ifTrue:[
	info := 'information not available'.
    ].
    b addTextLabel:('GLU Version: ',info).

    info := view glRenderer.
    info isNil ifTrue:[
	info := 'information not available'.
    ].
    b addTextLabel:('GL Renderer: ',info).

    b addVerticalSpace:2.
    b addHorizontalLine.

    b addOkButton.
    b show.

    "Modified: / 5.11.1998 / 09:58:18 / ps"
!

resetFunc

    (self openDialogInterface:#dialogSpec1) ifTrue:[
	self startUpFunction: selectedFunc.
    ]
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
! !

!ApplicationMatrix3D methodsFor:'aspects'!

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

dialogInputSensorNumber

    |holder|

    (holder := builder bindingAt:#dialogInputSensorNumber) isNil ifTrue:[
	builder aspectAt:#dialogInputSensorNumber put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:20.
    ].
    ^ holder.

    "Modified: / 16.10.1998 / 12:30:30 / ps"
!

dialogInputYValuesToShow

    |holder|

    (holder := builder bindingAt:#dialogInputYValuesToShow) isNil ifTrue:[
	builder aspectAt:#dialogInputYValuesToShow put:(holder :=  ValueHolder new).
	holder addDependent:self.
	holder value:20.
    ].
    ^ holder.

    "Created: / 29.9.1998 / 14:19:56 / ps"
    "Modified: / 16.10.1998 / 12:30:35 / ps"
!

pickSelectionHolder

    pickSelectionHolder isNil
	ifTrue:[pickSelectionHolder :=  ValueHolder new.
		pickSelectionHolder addDependent: self].
    ^ pickSelectionHolder.

    "Created: / 3.10.1998 / 12:10:03 / ps"
    "Modified: / 3.10.1998 / 12:10:19 / ps"
!

pickSelectionHolderOnString
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#pickSelectionHolderOnString) isNil ifTrue:[
	builder aspectAt:#pickSelectionHolderOnString put:(holder :=  ValueHolder new).
    ].
    ^ holder.
!

scaleXValue

    |holder|

    (holder := builder bindingAt:#scaleXValue) isNil ifTrue:[
	builder aspectAt:#scaleXValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
"/        holder value:1.8.
    ].
    ^ holder

    "Modified: / 16.10.1998 / 12:31:24 / ps"
!

scaleYValue

    |holder|

    (holder := builder bindingAt:#scaleYValue) isNil ifTrue:[
	builder aspectAt:#scaleYValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
"/        holder value:1.0.
    ].
    ^ holder
!

scaleZValue

    |holder|

    (holder := builder bindingAt:#scaleZValue) isNil ifTrue:[
	builder aspectAt:#scaleZValue put:(holder :=  ValueHolder new).
	holder addDependent:self.
"/        holder value:1.0.
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
	selectedFunc := aFunc.
	self startUpFunction: selectedFunc.
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

textYPlaneValue
    |holder|

    (holder := builder bindingAt:#textYPlaneValue) isNil ifTrue:[
	builder aspectAt:#textYPlaneValue put:(holder :=  ValueHolder new).
    ].
    ^ holder.

    "Created: / 3.10.1998 / 12:10:03 / ps"
    "Modified: / 3.10.1998 / 12:10:19 / ps"
! !

!ApplicationMatrix3D methodsFor:'change & update'!

update:what with:aPara from:chgObj

    |index val|

    chgObj == self stopApplication ifTrue:[
	self stopApplication value == #stop
		ifTrue:[self stopDataProcess.^self].
	self stopApplication value == #start
		ifTrue:[self startDataProcess.^self].
    ].

    chgObj == self switchSeparatorPlane ifTrue:[
	(components at:#separatorPlane) aspectAt:#draw put:(chgObj value == #true).
	view doInvalidateGraph.
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
	    (components at:#separatorPlane) aspectAt:#y put:(chgObj value).
	    view doInvalidateGraph.
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
	    (components at:#separatorPlane) aspectAt:#intensity put:(chgObj value).
	    view doInvalidateGraph.
	].
	^self.
    ].

    chgObj == self scaleXValue ifTrue:[
	view setAspectsForComponents:[view aspectAt:#scaleX put:chgObj value].
	view doInvalidateGraph.
	^self.
    ].

    chgObj == self scaleYValue ifTrue:[
	view setAspectsForComponents:[view aspectAt:#scaleY put:chgObj value].
	view doInvalidateGraph.
	^self.
    ].

    chgObj == self scaleZValue ifTrue:[
	view setAspectsForComponents:[view aspectAt:#scaleZ put:chgObj value].
	view doInvalidateGraph.
	^self.
    ].

    chgObj == self angleY ifTrue:[
	view setAspectsForComponents:[view aspectAt:#angleY put:chgObj value].
	view doInvalidateGraph.
	^self.
    ].

    chgObj == self angleX ifTrue:[
       view setAspectsForComponents:[view aspectAt:#angleX put:chgObj value].
	view doInvalidateGraph.
	^self.
    ].

    chgObj == self pickSelectionHolder
	ifTrue:[
	    view setAspectsForComponents:[
		(components at:#dataDrawer) aspectAt:#addPickNodes put:
		    (Array with:(chgObj value at:1) with:(chgObj value at:3)).
		(components at:#dataDrawer) aspectAt:#removePickNodes put:
		    (Array with:3 with:8)].
		view doInvalidateGraph.
		self pickSelectionHolderOnString value:(
		    'x: ',(chgObj value at:1) printString,'  ',
		    'y: ',(chgObj value at:2) printString,'  ',
		    'z: ',(chgObj value at:3) printString).
		^self].

    super update:what with:aPara from:chgObj

    "Modified: / 16.10.1998 / 12:34:10 / ps"
! !

!ApplicationMatrix3D methodsFor:'function accessing'!

Xfunction
    ^ [:x :z | (x * scale1) sin * (z * scale2) sin * 100].
"/    ^ [:x :z | (x * 100"* scale1" + scale1) sin *100.0"* 0.1 ""* scale1"].

    "Modified: / 13.10.1998 / 14:47:40 / ps"
    "Created: / 13.10.1998 / 14:54:47 / ps"
!

XgetSimulationValues: anArray
"call function f(x,z) to get an matrix with z rows each with x y values

<return: self>
"
    self halt.
    1 to:dataForFunction size do:[:i|
	anArray at:i put:(dataForFunction at:i)].
    dataForFunction := nil.
!

calcNewSimulationValues
"call function f(x,z) to get an matrix with z rows each with x y values

<return: self>
"

    |f comp|
    dataForFunction isNil ifTrue:[
	lockDataForFunction critical:[
	    dataForFunction := Array new:(dimensionX*dimensionZ).

	    "do scaling"
	    self perform:((self drawingFunc value)printString,'scale')asSymbol.
	    "get function"
	    f := self perform:(self drawingFunc value).

	    1 to:dimensionZ do:[:dz|
		1 to:dimensionX do:[:dx|
		    |vector y red color|
		    vector := Array new:4.
		    color := Array new:3.
		    y := f value:dx value:dz.
		    vector at:1 put:dx.
		    vector at:2 put:y.
		    vector at:3 put:dz.
		    vector at:4 put:color.
		    red := (y - minY)/(deltaY).
		    color at:1 put:red*3.
		    color at:2 put:(1.0-red)*2.
		    color at:3 put:0.0.
		    dataForFunction at:dx+((dz-1)*dimensionX) put:vector
		].
	     ].
	].
    ].
    view doInvalidateGraph.

    "Created: / 13.10.1998 / 13:33:57 / ps"
    "Modified: / 16.10.1998 / 13:20:21 / ps"
!

function
"/    ^ [:x :z | (x * scale1) sin * z cos * 100].
"/    ^ [:x :z | (((x*10.0)*scale1)sin) * ((z+10.0)*scale2)cos * 100.0].
"/    ^[:x :z| (x/4 + scale1)sin * ((z/4 + scale1) sin) * 100.0].
    ^[:x :z| (x/4 + scale1)sin * ((z/4 + scale1)sin) * 100.0].

    "Modified: / 16.10.1998 / 10:34:11 / ps"
!

function1

    ^ [:x :z | (x/8 + scale1)sin * 100.0].

    "Created: / 16.10.1998 / 10:40:25 / ps"
    "Modified: / 16.10.1998 / 12:26:49 / ps"
!

function1scale

    scale1 := scale1 + quo.
    scale2 := scale2 + quo.
    scale1 > 6.28 ifTrue:[
	scale1 := scale1 - 6.28 .
	quo := 0.5.
    ] ifFalse:[
	scale1 < 0.1 ifTrue:[
	    scale1 := 0.1.
	    quo := 0.5.
	]
    ].

    "Modified: / 16.10.1998 / 12:26:49 / ps"
    "Created: / 16.10.1998 / 13:16:07 / ps"
!

function2

    ^ [:x :z | (x/8 + scale1)sin *(z cos) * 100.0].

    "Created: / 16.10.1998 / 12:26:27 / ps"
    "Modified: / 16.10.1998 / 12:26:54 / ps"
!

function2scale

    scale1 := scale1 + quo.
    scale2 := scale2 + quo.
    scale1 > 6.28 ifTrue:[
	scale1 := scale1 - 6.28 .
	quo := 0.5.
    ] ifFalse:[
	scale1 < 0.1 ifTrue:[
	    scale1 := 0.1.
	    quo := 0.5.
	]
    ].

    "Modified: / 16.10.1998 / 12:26:49 / ps"
    "Created: / 16.10.1998 / 13:16:10 / ps"
!

function3

    ^[:x :z| (x/4 + scale1)sin * ((z/4 + scale1)sin) * 100.0].

    "Created: / 16.10.1998 / 12:26:44 / ps"
    "Modified: / 16.10.1998 / 12:26:59 / ps"
!

function3scale

    scale1 := scale1 + quo.
    scale2 := scale2 + quo.
    scale1 > 6.28 ifTrue:[
	scale1 := scale1- 6.28.
	quo := 0.5.
    ] ifFalse:[
	scale1 < 0.1 ifTrue:[
	    scale1 := 0.1.
	    quo := 0.5.
	]
    ].

    "Modified: / 16.10.1998 / 12:26:49 / ps"
    "Created: / 16.10.1998 / 13:16:11 / ps"
!

function4

    ^[:x :z| (x/2+scale1)sin * ((z/10)sin) * 100.0].

    "Modified: / 16.10.1998 / 12:26:59 / ps"
    "Created: / 16.10.1998 / 13:20:52 / ps"
!

function4scale

    scale1 := scale1 + quo.
    scale2 := scale2 + quo.
    scale1 > 6.28 ifTrue:[
	scale1 := scale1- 6.28.
	quo := 0.5.
    ] ifFalse:[
	scale1 < 0.1 ifTrue:[
	    scale1 := 0.1.
	    quo := 0.5.
	]
    ].

    "Modified: / 16.10.1998 / 12:26:49 / ps"
    "Created: / 16.10.1998 / 13:16:13 / ps"
!

getSimulationValues
"call function f(x,z) to get an matrix with z rows each with x y values

<return: self>
"
    |dataArray|
    lockDataForFunction critical:[
	dataForFunction isNil ifTrue:[^nil].
	dataArray := dataForFunction.
	dataForFunction := nil.
    ].
    ^ dataArray
!

simulationValues:anArray
"call function f(x,z) to get an matrix with z rows each with x y values"

    |x z f|

    x := view aspectsForRendering:#dimensionX.
    z := view aspectsForRendering:#dimensionZ.
    "do scaling"
    self perform:((self drawingFunc value)printString,'scale')asSymbol.
    "get function"
    f := self perform:(self drawingFunc value).
    "call function and put y values in array"
"/    1 to:z do:[:j|
"/        |array|
"/        array := Array new:x.
"/        1 to:x do:[:i|
"/            array at:i put:(f value:i value:j).
"/        ].
"/        anArray at:j put:array
"/     ].


    1 to:z do:[:dz|
	1 to:x do:[:dx|
	    |vector y red color|
	    vector := Array new:4.
	    color := Array new:3.
	    y := f value:dx value:dz.
	    vector at:1 put:dx.
	    vector at:2 put:y.
	    vector at:3 put:dz.
	    vector at:4 put:color.
	    red := (y - minY)/(deltaY).
	    color at:1 put:red*3.
	    color at:2 put:(1.0-red)*2.
	    color at:3 put:0.0.
	    anArray at:dx+((dz-1)*x) put:vector
	].
     ].

    "Created: / 13.10.1998 / 13:33:57 / ps"
    "Modified: / 16.10.1998 / 13:20:21 / ps"
! !

!ApplicationMatrix3D methodsFor:'hooks'!

postOpenWith:aBuilder

    super postOpenWith:aBuilder.
    view := (builder componentAt: #DataViewer3D) scrolledView.

    self initializeComponents.
    self startUpFunction: selectedFunc

    "Modified: / 16.10.1998 / 11:49:25 / ps"
! !

!ApplicationMatrix3D methodsFor:'initialization'!

initialize

    super initialize.

    drawingFunc := AspectAdaptor new subject:self.
    drawingFunc forAspect:#selectedFuncIndex.
    selectedFunc := #function1.
    accessLock   := Semaphore forMutualExclusion.
    lockDataForFunction := Semaphore forMutualExclusion.
    multi := 1.0.
    maxY := 1.0.
    minY := 0.0.
    deltaY := 1.0.
    actDataIndex := 1.
    sensorArray := OrderedCollection new.
    scale1 := 1.
    scale2 := 1.
    quo := 1.1.
    dimensionX := 1.
    dimensionZ := 1.
    dataManager :=  MatrixData new.



    "Modified: / 16.10.1998 / 12:12:39 / ps"
!

initializeComponents

    |tmpComp|

    components := OrderedDictionary new:8.
    tmpComp := AxisStandard new.
    components at:#axis put:tmpComp.
    tmpComp := PlaneStandard new.
    components at:#plane put:tmpComp.
    tmpComp := FrameStandard new.
    components at:#frame put:tmpComp.
    tmpComp := MatrixText new.
    components at:#text put:tmpComp.
    tmpComp := DrawWithVertexArray new.
    components at:#dataDrawer put:tmpComp.
    tmpComp := LabelForAxis new.
    components at:#labelForZAxis put:tmpComp.
    tmpComp := LabelForAxis new.
    components at:#labelForYAxis put:tmpComp.
    tmpComp := LabelForAxis new.
    components at:#labelForXAxis put:tmpComp.
    tmpComp := SeparatorPlane new.
    components at:#separatorPlane put:tmpComp.

    view addComponentsForRendering:components

    "Modified: / 25.6.1999 / 14:38:27 / ps"
    "Modified: / 15.10.1999 / 15:42:04 / cg"
!

initializeSimulation:aFunction

    |sim xdiff zdiff tmpComp|
    xdiff := 20.
    zdiff := 40.
    minY  := -100.
    maxY  := 100.
    deltaY := maxY-minY.
    separatorPlaneYValue := maxY-(deltaY/2).
    dimensionZ := self dialogInputSensorNumber value.
    dimensionX := self dialogInputYValuesToShow value.
    drawFrameForPresentation      := true.
    drawAxisForPresentation       := false.
    drawPlaneForPresentation      := true.
    drawGridForXAxisFirst  := false.
    drawGridForXAxisSecond := false.
    drawGridForYAxisFirst  := true.
    drawGridForYAxisSecond := false.
    drawGridForZAxisFirst  := false.
    drawGridForZAxisSecond := false.

    self scaleXValue value:1.8.
    self scaleYValue value:2.5.
    self scaleZValue value:1.0.
    self angleX value:0.0.
    self angleY value:0.0.

    dataManager minY:minY.
    dataManager maxY:maxY.
    dataManager name:aFunction printString.
    dataManager functionYblock:[:anArray|
	|dataArray|
	"return anArray set up with the function values"
	dataArray := self getSimulationValues.
	dataArray.
    ].

    view setAspectsForComponents:[
	(components at:#axis)  aspectAt:#draw put:drawAxisForPresentation.
	(components at:#plane) aspectAt:#draw put:drawPlaneForPresentation.
	(components at:#frame) aspectAt:#draw put:drawFrameForPresentation.
	(components at:#dataDrawer)    aspectAt:#draw put:true.

	view aspectAt:#graph       put:true.
	view aspectAt:#xdiff       put:xdiff.
	view aspectAt:#zdiff       put:zdiff.
	view aspectAt:#dimensionX  put:dimensionX.
	view aspectAt:#dimensionZ  put:dimensionZ.
	view aspectAt:#graphLenght put:(dimensionX-1)*xdiff.
	view aspectAt:#graphWidth  put:(dimensionZ-1)*zdiff.
	view aspectAt:#graphHeight put:(maxY-minY).
	view aspectAt:#minY        put:minY.
	view aspectAt:#maxY        put:maxY.
	view aspectAt:#eyeStepX    put:10.0.
	view aspectAt:#eyeStepY    put:10.0.
	view aspectAt:#eyeStepZ    put:10.0.
	view aspectAt:#lightsOn    put:true.

	(components at:#axis) aspectAt:#minY put:minY.
	(components at:#axis) aspectAt:#maxY put:maxY.
	(components at:#axis) aspectAt:#x    put:(dimensionX-1)*xdiff.
	(components at:#axis) aspectAt:#z    put:((dimensionZ-1)*zdiff)*0.5.

	(components at:#plane) aspectAt:#minY put:minY.
	(components at:#plane) aspectAt:#maxY put:maxY.
	(components at:#plane) aspectAt:#x    put:(dimensionX-1)*xdiff.
	(components at:#plane) aspectAt:#z    put:((dimensionZ-1)*zdiff)*0.5.

	(components at:#frame) aspectAt:#minY put:minY.
	(components at:#frame) aspectAt:#maxY put:maxY.
	(components at:#frame) aspectAt:#x    put:(dimensionX-1)*xdiff.
	(components at:#frame) aspectAt:#z    put:((dimensionZ-1)*zdiff)*0.5.

	(components at:#text) aspectAt:#minY    put:minY.
	(components at:#text) aspectAt:#maxY    put:maxY.
	(components at:#text) aspectAt:#x       put:(dimensionX-1)*xdiff.
	(components at:#text) aspectAt:#z       put:((dimensionZ-1)*zdiff)*0.5.
	(components at:#text) aspectAt:#xdiff   put:xdiff.
	(components at:#text) aspectAt:#zdiff   put:zdiff.
	(components at:#text) aspectAt:#string  put:'function'.

	(components at:#dataDrawer) aspectAt:#dimensionX put:dimensionX.
	(components at:#dataDrawer) aspectAt:#dimensionZ put:dimensionZ.
	(components at:#dataDrawer) aspectAt:#z          put:((dimensionZ-1)*zdiff)*0.5.
	(components at:#dataDrawer) aspectAt:#xdiff      put:xdiff.
	(components at:#dataDrawer) aspectAt:#zdiff      put:zdiff.
	(components at:#dataDrawer) aspectAt:#data       put:dataManager.
	(components at:#dataDrawer) aspectAt:#drawGrid   put:true.
	(components at:#dataDrawer) aspectAt:#drawData   put:true.
	(components at:#dataDrawer) aspectAt:#valueHolderForSelection
							 put:(self pickSelectionHolder).

	(components at:#separatorPlane) aspectAt:#x     put:(dimensionX-1)*xdiff.
	(components at:#separatorPlane) aspectAt:#y     put:separatorPlaneYValue.
	(components at:#separatorPlane) aspectAt:#z     put:((dimensionZ-1)*zdiff)*0.5.
	(components at:#separatorPlane) aspectAt:#draw  put:false.
	(components at:#separatorPlane) aspectAt:#intensity put:0.5.

	(components at:#labelForZAxis) aspectAt:#drawLabelsForAxis put:#zAxis.
	(components at:#labelForZAxis) aspectAt:#drawMainLabel  put:true.
	(components at:#labelForZAxis) aspectAt:#drawMinorLabel put:true.
	(components at:#labelForZAxis) aspectAt:#x     put:(dimensionX-1)*xdiff.
	(components at:#labelForZAxis) aspectAt:#z     put:((dimensionZ-1)*zdiff)*0.5.
	(components at:#labelForZAxis) aspectAt:#y     put:minY.
	(components at:#labelForZAxis) aspectAt:#distanceToAxisForMinorLabel put:2.
	(components at:#labelForZAxis) aspectAt:#distanceToAxisForMajorLabel put:3.
	(components at:#labelForZAxis) aspectAt:#lenghtOfMajorLabel put:xdiff/3.
	(components at:#labelForZAxis) aspectAt:#lenghtOfMinorLabel put:xdiff/3-2.
	(components at:#labelForZAxis) aspectAt:#lenghtOfLabelLine  put:(dimensionZ-1)*zdiff.
	(components at:#labelForZAxis) aspectAt:#stepForMainLabel   put:zdiff.
	(components at:#labelForZAxis) aspectAt:#stepForMinorLabel  put:zdiff/2.
	(components at:#labelForZAxis) aspectAt:#stepForGrid            put:zdiff.
	(components at:#labelForZAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForZAxisFirst.
	(components at:#labelForZAxis) aspectAt:#drawGridForSecondPlane put:drawGridForZAxisSecond.
	(components at:#labelForZAxis) aspectAt:#deltaY                 put:(maxY-minY).
	(components at:#labelForZAxis) aspectAt:#colorForMainText         put:#(1.0 1.0 1.0)asFloatArray.
	(components at:#labelForZAxis) aspectAt:#textSizeForMainLabel     put:nil.
	(components at:#labelForZAxis) aspectAt:#startNumberForMainLabel  put:1.
	(components at:#labelForZAxis) aspectAt:#stepForNumberOfMainLabel put:1.
	(components at:#labelForZAxis) aspectAt:#distanceToAxisForMajorLabelText put:5.


	(components at:#labelForYAxis) aspectAt:#drawLabelsForAxis put:#yAxis.
	(components at:#labelForYAxis) aspectAt:#drawMainLabel  put:true.
	(components at:#labelForYAxis) aspectAt:#drawMinorLabel put:true.
	(components at:#labelForYAxis) aspectAt:#x     put:(dimensionX-1)*xdiff.
	(components at:#labelForYAxis) aspectAt:#z     put:((dimensionZ-1)*zdiff)*0.5 negated.
	(components at:#labelForYAxis) aspectAt:#y     put:maxY.
	(components at:#labelForYAxis) aspectAt:#distanceToAxisForMinorLabel put:2.
	(components at:#labelForYAxis) aspectAt:#distanceToAxisForMajorLabel put:3.
	(components at:#labelForYAxis) aspectAt:#lenghtOfMajorLabel put:xdiff/3.
	(components at:#labelForYAxis) aspectAt:#lenghtOfMinorLabel put:xdiff/3-2.
	(components at:#labelForYAxis) aspectAt:#lenghtOfLabelLine  put:maxY-minY.
	(components at:#labelForYAxis) aspectAt:#stepForMainLabel   put:(maxY-minY)/20.
	(components at:#labelForYAxis) aspectAt:#stepForMinorLabel  put:(maxY-minY)/40.
	(components at:#labelForYAxis) aspectAt:#stepForGrid            put:(maxY-minY)/20.
	(components at:#labelForYAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForYAxisFirst.
	(components at:#labelForYAxis) aspectAt:#drawGridForSecondPlane put:drawGridForYAxisSecond.
	(components at:#labelForYAxis) aspectAt:#deltaZ                 put:(dimensionZ-1)*zdiff.
	(components at:#labelForYAxis) aspectAt:#colorForMainText         put:#(1.0 1.0 1.0)asFloatArray.
	(components at:#labelForYAxis) aspectAt:#textSizeForMainLabel     put:8.
	(components at:#labelForYAxis) aspectAt:#startNumberForMainLabel  put:-100.
	(components at:#labelForYAxis) aspectAt:#stepForNumberOfMainLabel put:10.
	(components at:#labelForYAxis) aspectAt:#stepForNextMainLabelForNumber put:2.
	(components at:#labelForYAxis) aspectAt:#distanceToAxisForMajorLabelText put:5.

	(components at:#labelForXAxis) aspectAt:#drawLabelsForAxis put:#xAxis.
	(components at:#labelForXAxis) aspectAt:#drawMainLabel  put:true.
	(components at:#labelForXAxis) aspectAt:#drawMinorLabel put:true.
	(components at:#labelForXAxis) aspectAt:#x     put:(dimensionX-1)*xdiff.
	(components at:#labelForXAxis) aspectAt:#z     put:(dimensionZ-1)*zdiff*0.5.
	(components at:#labelForXAxis) aspectAt:#y     put:minY.
	(components at:#labelForXAxis) aspectAt:#distanceToAxisForMinorLabel put:-2.
	(components at:#labelForXAxis) aspectAt:#distanceToAxisForMajorLabel put:-3.
	(components at:#labelForXAxis) aspectAt:#lenghtOfMajorLabel put:zdiff/-3.
	(components at:#labelForXAxis) aspectAt:#lenghtOfMinorLabel put:(zdiff/-3)+4.
	(components at:#labelForXAxis) aspectAt:#lenghtOfLabelLine  put:(dimensionX-1)*xdiff.
	(components at:#labelForXAxis) aspectAt:#stepForMainLabel   put:xdiff.
	(components at:#labelForXAxis) aspectAt:#stepForMinorLabel  put:xdiff/2.
	(components at:#labelForXAxis) aspectAt:#stepForGrid            put:xdiff.
	(components at:#labelForXAxis) aspectAt:#drawGridForFirstPlane  put:drawGridForXAxisFirst.
	(components at:#labelForXAxis) aspectAt:#drawGridForSecondPlane put:drawGridForXAxisSecond.
	(components at:#labelForXAxis) aspectAt:#deltaY                 put:(maxY-minY).
	(components at:#labelForXAxis) aspectAt:#colorForMainText       put:#(1.0 1.0 1.0)asFloatArray.
	(components at:#labelForXAxis) aspectAt:#textSizeForMainLabel   put:8.
	(components at:#labelForXAxis) aspectAt:#stepForNextMainLabelForNumber put:1.
	(components at:#labelForXAxis) aspectAt:#distanceToAxisForMajorLabelText put:5.
	(components at:#labelForXAxis) aspectAt:#numberForMainText put:(1 to: dimensionX) asOrderedCollection.



].

    self switchSeparatorPlane value:#false.
    self separatorPlaneYValue value:separatorPlaneYValue.
    self separatorPlaneIntensity value:0.5.
    self textYPlaneValue value:'minY:',minY printString,' maxY:',maxY printString.

    "Modified: / 14.10.1998 / 08:28:59 / cg"
    "Created: / 16.10.1998 / 11:49:10 / ps"
    "Modified: / 25.6.1999 / 15:49:25 / ps"
!

reinitialize


    self angleX value:0.0.
    self angleY value:0.0.
    self scaleXValue value:1.8.
    self scaleYValue value:1.0.
    self scaleZValue value:1.0.
    self drawingGrids:true.
    self drawingPlanes:true.
    self drawingFrame:true.
    self drawingAxis:true.

    "Modified: / 1.10.1998 / 12:25:29 / ps"
!

setNewStyle

!

startUpFunction: aFunction
"

<return: self>
"
    (self stopApplication value == #start)
	ifTrue:[self stopDataProcess].
    view disableRendering.
    self initializeSimulation: aFunction.
    dataForFunction := nil.
    self calcNewSimulationValues.
    view reinitializeTransformation.
    view enableRendering.
    view doInvalidateGraph.
    (self stopApplication value == #start)
	ifTrue:[self startDataProcess].

    "Modified: / 18.6.1999 / 16:10:30 / ps"
! !

!ApplicationMatrix3D methodsFor:'processes'!

startDataProcess
"signal process which calculates new simulation data

"
    process isNil
	ifTrue:[process := Process for:[|win|
				    win := self window.
				    [win realized] whileTrue:[
					accessLock critical:[
					    win shown ifTrue:[self calcNewSimulationValues]]]]
			   priority:( Processor activePriority - 1 ).
		process addExitAction:[process := nil].
		process name:'Application calculate new values'.
		process resume].
    accessLock signalOnce.

!

stopDataProcess
"stop process which indicates new data to the TDV framework via doInvalidateGraph

<return: self>
"
    accessLock wait

! !

!ApplicationMatrix3D methodsFor:'startup / release'!

closeDownViews

    process notNil ifTrue: [process terminate].

    super closeDownViews.


! !

!ApplicationMatrix3D class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/ApplicationMatrix3D.st,v 1.33 2016-11-01 14:42:20 cg Exp $'
! !
