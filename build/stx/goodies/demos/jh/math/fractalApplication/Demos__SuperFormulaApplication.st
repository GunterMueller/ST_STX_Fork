"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#SuperFormulaApplication
	instanceVariableNames:'superFormula superFormulaView n3Holder bHolder n2Holder n1Holder
		mHolder aHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-SuperFormula'
!

!SuperFormulaApplication class methodsFor:'documentation'!

documentation
    "
    Application to display the shape of a superformula. Change a parameter and the shape will change.

    [author:]
	Jan (Jan@DESKTOPJAN)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    SuperFormulaApplication open
							       [exEnd]
"
!

history
    "Created: / 4.5.2003 / 23:34:03 / Jan"
! !

!SuperFormulaApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::SuperFormulaApplication andSelector:#windowSpec
     Demos::SuperFormulaApplication new openInterface:#windowSpec
     Demos::SuperFormulaApplication open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Super Formula'
	  name: 'Super Formula'
	  min: (Point 391 426)
	  max: (Point 391 426)
	  bounds: (Rectangle 0 0 391 426)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (FramedBoxSpec
	      label: ''
	      name: 'FramedBox2'
	      layout: (LayoutFrame 5 0 5 0 -5 1 -105 1)
	      labelPosition: topLeft
	      translateLabel: true
	      component:
	     (SpecCollection
		collection: (
		 (NonScrollableArbitraryComponentSpec
		    name: 'NonScrollableArbitraryComponent1'
		    layout: (LayoutFrame -8 0.0 -6 0.0 15 0.973753 15 0.968354)
		    component: superFormulaView
		  )
		 )

	      )
	    )
	   (FramedBoxSpec
	      label: 'Parameters'
	      name: 'FramedBox1'
	      layout: (LayoutFrame 5 0 -105 1 -5 1 -5 1)
	      labelPosition: topLeft
	      translateLabel: true
	      component:
	     (SpecCollection
		collection: (
		 (InputFieldSpec
		    name: 'inputField1'
		    layout: (LayoutFrame 16 0 0 0 83 0 22 0)
		    model: n1Holder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (LabelSpec
		    label: 'n1'
		    name: 'Label1'
		    layout: (LayoutFrame -7 0 -2 0 18 0 25 0)
		    translateLabel: true
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton1'
		    layout: (LayoutFrame -110 0.5 1 0 -262 1 -41 1)
		    model: n1Holder
		    step: 0.1
		  )
		 (LabelSpec
		    label: 'n2'
		    name: 'Label2'
		    layout: (LayoutFrame -7 0 23 0 18 0 50 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'InputField2'
		    layout: (LayoutFrame 16 0 24 0 83 0 46 0)
		    model: n2Holder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton2'
		    layout: (LayoutFrame -110 0.5 25 0 -262 1 -17 1)
		    model: n2Holder
		    step: 0.1
		  )
		 (LabelSpec
		    label: 'n3'
		    name: 'Label3'
		    layout: (LayoutFrame -7 0 46 0 18 0 73 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'InputField3'
		    layout: (LayoutFrame 16 0 48 0 83 0 70 0)
		    model: n3Holder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton3'
		    layout: (LayoutFrame -111 0.5 49 0 -263 1 7 1)
		    model: n3Holder
		    step: 0.1
		  )
		 (LabelSpec
		    label: 'm'
		    name: 'Label4'
		    layout: (LayoutFrame 119 0 -2 0 144 0 25 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'InputField1'
		    layout: (LayoutFrame 144 0 0 0 211 0 22 0)
		    model: mHolder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton4'
		    layout: (LayoutFrame 17 0.5 1 0 -135 1 -41 1)
		    model: mHolder
		    step: 0.1
		  )
		 (LabelSpec
		    label: 'a'
		    name: 'Label5'
		    layout: (LayoutFrame 244 0 -2 0 269 0 25 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'InputField5'
		    layout: (LayoutFrame 272 0 0 0 339 0 22 0)
		    model: aHolder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton5'
		    layout: (LayoutFrame 145 0.5 1 0 -7 1 -41 1)
		    model: aHolder
		    step: 0.1
		  )
		 (LabelSpec
		    label: 'b'
		    name: 'Label6'
		    layout: (LayoutFrame 244 0 48 0 269 0 73 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'EntryField1'
		    layout: (LayoutFrame 272 0 48 0 339 0 70 0)
		    model: bHolder
		    type: number
		    acceptOnPointerLeave: false
		  )
		 (UpDownButtonSpec
		    name: 'UpDownButton6'
		    layout: (LayoutFrame 145 0.5 48 0 -7 1 6 1)
		    model: bHolder
		    step: 0.1
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!SuperFormulaApplication class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Demos::SuperFormulaApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Demos::SuperFormulaApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'File'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Exit'
		  itemValue: closeRequest
		  translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Help'
	    translateLabel: true
	    startGroup: right
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Documentation'
		  itemValue: openDocumentation
		  translateLabel: true
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'About this Application'
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
! !

!SuperFormulaApplication methodsFor:'accessing'!

aboutThisApplicationText
^'Written by

Jan Hussaarts'
!

superFormulaView
    ^ superFormulaView
! !

!SuperFormulaApplication methodsFor:'aspects'!

aHolder

    ^aHolder
!

bHolder

    ^bHolder
!

mHolder

    ^mHolder
!

n1Holder

    ^n1Holder
!

n2Holder

    ^n2Holder
!

n3Holder

    ^n3Holder
!

update:anAspect
    superFormula
	n1:n1Holder value
	n2:n2Holder value
	n3:n3Holder value
	m:mHolder value
	a:aHolder value
	b:bHolder value.
    self superFormulaView redraw
! !

!SuperFormulaApplication methodsFor:'initialization & release'!

open
    |n1 n2 n3 m a b|

    n1 := 0.3000000000000000000000.
    n2 := 0.3000000000000000000000.
    n3 := 0.3000000000000000000000.
    m := 2.83333333333333333333333.
    a := 1.00000000000000000000000.
    b := 1.00000000000000000000000.
    n1Holder := n1 asValue.
    n1Holder addDependent:self.
    n2Holder := n2 asValue.
    n2Holder addDependent:self.
    n3Holder := n3 asValue.
    n3Holder addDependent:self.
    aHolder := a asValue.
    aHolder addDependent:self.
    bHolder := b asValue.
    bHolder addDependent:self.
    mHolder := m asValue.
    mHolder addDependent:self.
    superFormulaView := View on:(superFormula := SuperFormula
			n1:n1
			n2:n2
			n3:n3
			m:m
			a:a
			b:b).
    super open
! !

!SuperFormulaApplication methodsFor:'menu actions'!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!SuperFormulaApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/Demos__SuperFormulaApplication.st,v 1.2 2008-10-26 13:45:19 cg Exp $'
! !
