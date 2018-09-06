"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

ApplicationModel subclass:#LabelResizingTest
	instanceVariableNames:'labelView'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!LabelResizingTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	ca (ca@IDEFIX)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    Claus open

								[exEnd]

  more examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 08-10-2007 / 17:39:33 / ca"
! !

!LabelResizingTest class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Claus andSelector:#windowSpec
     Claus new openInterface:#windowSpec
     Claus open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Claus'
	  name: 'Claus'
	  min: (Point 10 10)
	  max: (Point 1024 768)
	  bounds: (Rectangle 0 0 518 496)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (ViewSpec
	      name: 'Box'
	      layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      backgroundColor: (Color 86.999313344015 86.999313344015 86.999313344015)
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Label'
		    name: 'Label'
		    layout: (AlignmentOrigin -5 1.0 5 0 1 0)
		    visibilityChannel: visibleHolder
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		    adjust: left
		    postBuildCallback: postBuildLabel:
		  )
		 (ActionButtonSpec
		    label: 'Button'
		    name: 'Button'
		    layout: (AlignmentOrigin -5 1.0 40 0 1 0)
		    visibilityChannel: visibleHolder
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 (LabelSpec
		    label: 'Point'
		    name: 'Point'
		    layout: (Point 5 5)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 (LabelSpec
		    label: 'Alignment Origin TopLeft'
		    name: 'Alignment Origin TopLeft'
		    layout: (AlignmentOrigin 5 0 30 0 0 0)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 (LabelSpec
		    label: 'Origin'
		    name: 'Origin'
		    layout: (LayoutOrigin 5 0 55 0)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 )

	      )
	    )
	   (LabelSpec
	      label: 'Variable Horizontal Panel'
	      name: 'Variable Horizontal Panel'
	      layout: (LayoutFrame 0 0.0 90 0 0 1.0 120 0)
	      backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
	      translateLabel: true
	      resizeForLabel: true
	    )
	   (VariableHorizontalPanelSpec
	      name: 'VariableHorizontalPanel'
	      layout: (LayoutFrame 0 0.0 120 0 0 1.0 170 0)
	      snapMode: both
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Label'
		    name: 'Label1'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 (ActionButtonSpec
		    label: 'Button'
		    name: 'Button1'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 (LabelSpec
		    label: 'Label'
		    name: 'Label2'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		  )
		 )

	      )
	      handles: (Any 0.33333333333333 0.66666666666667 1.0)
	    )
	   (LabelSpec
	      label: 'Horizontal Panel'
	      name: 'Horizontal Panel'
	      layout: (LayoutFrame 0 0.0 170 0 0 1.0 200 0)
	      backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
	      translateLabel: true
	      resizeForLabel: true
	    )
	   (HorizontalPanelViewSpec
	      name: 'HorizontalPanel'
	      layout: (LayoutFrame 0 0.0 200 0 0 1.0 250 0)
	      horizontalLayout: center
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      elementsChangeSize: true
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Label'
		    name: 'Label3'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		    extent: (Point 74 20)
		  )
		 (ActionButtonSpec
		    label: 'Button'
		    name: 'Button2'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		    extent: (Point 78 24)
		  )
		 (LabelSpec
		    label: 'Label'
		    name: 'Label4'
		    backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
		    translateLabel: true
		    labelChannel: lableHolder
		    resizeForLabel: true
		    extent: (Point 74 20)
		  )
		 )

	      )
	    )
	   (LabelSpec
	      label: 'Vertical Panels'
	      name: 'Vertical Panels'
	      layout: (LayoutFrame 0 0.0 250 0 0 1.0 280 0)
	      backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
	      translateLabel: true
	    )
	   (HorizontalPanelViewSpec
	      name: 'All Panels'
	      layout: (LayoutFrame 0 0.0 280 0 0 1.0 -5 1.0)
	      horizontalLayout: fitSpace
	      verticalLayout: fitSpace
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (ViewSpec
		    name: 'VerticalPanelView'
		    component:
		   (SpecCollection
		      collection: (
		       (LabelSpec
			  label: 'Vertical Panel'
			  name: 'Vertical Panel'
			  layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 30 0)
			  backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
			  translateLabel: true
			)
		       (VerticalPanelViewSpec
			  name: 'VerticalPanel'
			  layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
			  horizontalLayout: center
			  verticalLayout: center
			  horizontalSpace: 3
			  verticalSpace: 3
			  elementsChangeSize: true
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Label'
				name: 'Label5'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 74 20)
			      )
			     (ActionButtonSpec
				label: 'Button'
				name: 'Button3'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 78 24)
			      )
			     (LabelSpec
				label: 'Label'
				name: 'Label6'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 74 20)
			      )
			     )

			  )
			)
		       )

		    )
		    extent: (Point 168 205)
		  )
		 (ViewSpec
		    name: 'PanelView'
		    component:
		   (SpecCollection
		      collection: (
		       (LabelSpec
			  label: 'Panel'
			  name: 'PanelLabel'
			  layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 30 0)
			  backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
			  translateLabel: true
			)
		       (PanelViewSpec
			  name: 'Panel'
			  layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
			  horizontalLayout: fitSpace
			  verticalLayout: fitSpace
			  horizontalSpace: 3
			  verticalSpace: 3
			  elementsChangeSize: true
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Label'
				name: 'Label7'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 74 20)
			      )
			     (ActionButtonSpec
				label: 'Button'
				name: 'Button4'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 78 24)
			      )
			     (LabelSpec
				label: 'Label'
				name: 'Label9'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
				extent: (Point 74 20)
			      )
			     )

			  )
			)
		       )

		    )
		    extent: (Point 169 205)
		  )
		 (ViewSpec
		    name: 'VariableVerticalPanelView'
		    component:
		   (SpecCollection
		      collection: (
		       (LabelSpec
			  label: 'Variable Vertical Panel'
			  name: 'Variable Vertical Panel'
			  layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 30 0)
			  backgroundColor: (Color 49.999237048905 49.999237048905 100.0)
			  translateLabel: true
			)
		       (VariableVerticalPanelSpec
			  name: 'VariableVerticalPanel'
			  layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
			  snapMode: both
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Label'
				name: 'Label8'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
			      )
			     (ActionButtonSpec
				label: 'Button'
				name: 'Button5'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
			      )
			     (LabelSpec
				label: 'Label'
				name: 'Label10'
				backgroundColor: (Color 49.999237048905 100.0 49.999237048905)
				translateLabel: true
				labelChannel: lableHolder
				resizeForLabel: true
			      )
			     )

			  )
			  handles: (Any 0.33333333333333 0.66666666666667 1.0)
			)
		       )

		    )
		    extent: (Point 169 205)
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!LabelResizingTest class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Claus andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Claus mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Label(smaller)'
	    itemValue: doChangeLabel:
	    translateLabel: true
	    argument: smaller
	  )
	 (MenuItem
	    label: 'Label(larger)'
	    itemValue: doChangeLabel:
	    translateLabel: true
	    argument: larger
	  )
	 (MenuItem
	    label: 'Label(null)'
	    itemValue: doChangeLabel:
	    translateLabel: true
	    argument: null
	  )
	 (MenuItem
	    label: 'Visibility'
	    itemValue: doToggleVisibility
	    translateLabel: true
	    isButton: true
	    startGroup: right
	  )
	 (MenuItem
	    label: 'Inspect'
	    translateLabel: true
	    startGroup: right
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Label(View)'
		  itemValue: doInspectLabelView
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
! !

!LabelResizingTest methodsFor:'action'!

doChangeLabel:how
    |label size|

    how == #null ifTrue:[
	size := 0.
    ] ifFalse:[
	size  := self lableHolder value size.

	how == #smaller ifTrue:[
	    size := (size - 2) max:2.
	] ifFalse:[
	    size == 0 ifTrue:[ size := 8 ]
		     ifFalse:[ size := size + 2 ].
	]
    ].
    label := String new:size.
    1 to:size do:[:i| |c|
	c := i \\ 10.
	c == 0 ifTrue:[ label at:i put:$- ]
	      ifFalse:[ label at:i put:(Character digitValue:c) ].
    ].
    self lableHolder value:label.
!

doInspectLabelView
    labelView inspect.
!

doToggleVisibility
    self visibleHolder value:(self visibleHolder value not).
! !

!LabelResizingTest methodsFor:'aspects'!

lableHolder
    |holder|

    (holder := builder bindingAt:#lableHolder) isNil ifTrue:[
	builder aspectAt:#lableHolder put:(holder :=  '' asValue).
    ].
    ^ holder
!

visibleHolder
    |holder|

    (holder := builder bindingAt:#visibleHolder) isNil ifTrue:[
	builder aspectAt:#visibleHolder put:(holder :=  false asValue).
    ].
    ^ holder
! !

!LabelResizingTest methodsFor:'initialize & release'!

postBuildLabel:aLabelView
    labelView := aLabelView.
! !

!LabelResizingTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

