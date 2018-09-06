"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Model subclass:#GraphColumn
	instanceVariableNames:'aspects functionYblock'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Graphs'
!

!GraphColumn class methodsFor:'documentation'!

documentation
"
    a model, which keeps all the information to describe a graph column as used by
    the GraphColumnView. Each change of an attribute will raise a change notification
    and immediately take affect in the graphs


    [author:]
	Claus Atzkern

    [see also:]
	GraphColumnView
	GraphColumnView2D
	GraphColumnView3D
"

! !

!GraphColumn class methodsFor:'instance creation'!

name:aName
    ^ self new name:aName
!

new
    ^ super basicNew initialize
! !

!GraphColumn class methodsFor:'constants'!

lineStyleFor:aStyle
    "returns the valid style for a style; supported styles
     are:
	#dashed and #solid
    "
    ^ aStyle == #dashed ifFalse:[#solid] ifTrue:[#dashed]

! !

!GraphColumn class methodsFor:'menu definitions'!

colorMenuSelector:aSelector
    "specification used to build the Menu
    "
    ^ ColorMenu colorMenu:true value:aSelector.
!

middleButtonMenu
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:GraphColumn andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(GraphColumn middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^

       #(#Menu

	   #(
	     #(#MenuItem
		#'label:' 'Style'
		#'argument:' #'lineStyle:'
		#'submenuChannel:' #'styleMenuSelector:'
	    )
	     #(#MenuItem
		#'label:' 'Size'
		#'argument:' #'lineWidth:'
		#'submenuChannel:' #'widthMenuSelector:'
	    )
	     #(#MenuItem
		#'label:' 'Color'
		#'argument:' #'foregroundColor:'
		#'submenuChannel:' #'colorMenuSelector:'
	    )
	     #(#MenuItem
		#'label:' 'Zoom Y'
		#'argument:' #'zoomY:'
		#'submenuChannel:' #'zoomMenuSelector:'
	    )
	  ) nil
	  nil
      )
!

styleMenuSelector:aSelector
    |menu width height item bitmap|

    menu   := Menu new.
    width  := 40.
    height := 10.

    #( #solid #dashed ) do:[:style|
	bitmap := Form width:width height:height depth:1.
	bitmap paint:(Color colorId:1).
	bitmap fillRectangleX:0 y:0 width:width height:height.

	bitmap paint:(Color colorId:0).
	bitmap fillRectangleX:0 y:0 width:width height:height.
	bitmap paint:(Color colorId:1).
	bitmap lineWidth:2.
	bitmap lineStyle:style.
	bitmap displayLineFromX:2 y:(height // 2) toX:width-2 y:(height // 2).
	item := MenuItem labeled:bitmap.
	item value:aSelector.
	item argument:style.
	menu addItem:item.
    ].
  ^ menu

"
(self styleMenuSelector:#lineStyle) startUp
"

!

widthMenuSelector:aSelector
    |menu width item bitmap|

    menu  := Menu new.
    width := 40.

    #( 1 2 3 4 5 6 ) do:[:height|
	bitmap := Form width:width height:height depth:1.
	bitmap paint:(Color colorId:1).
	bitmap fillRectangleX:0 y:0 width:width height:height.

	item := MenuItem labeled:bitmap.
	item value:aSelector.
	item argument:height.
	menu addItem:item.
    ].
    item := MenuItem labeled:'other ..'.
    item value:[:arg :panel||n|
	n := Number fromString:(Dialog request:'size:') onError:nil.

	n notNil ifTrue:[
	    panel receiver perform:aSelector with:n
	]
    ].
    menu addItem:item.
  ^ menu

"
(self widthMenuSelector:#lineWidth) startUp
"

!

zoomMenuSelector:aSelector
    "specification used to build the Menu
    "
    |menu width item bitmap|

    menu  := Menu new.
    width := 40.

    #( 25 50 75 nil 100 nil 150 200 nil ) do:[:zY|
	zY notNil ifTrue:[
	    item := MenuItem labeled:(zY printString, ' %' ).
	    item value:aSelector.
	    item argument:(zY / 100).
	] ifFalse:[
	    item := MenuItem labeled:'-'.
	].
	menu addItem:item.
    ].
    item := MenuItem labeled:'other ..'.
    item value:[:arg :panel||n|
	n := Number fromString:(Dialog request:'zoom %:') onError:nil.

	n notNil ifTrue:[
	    panel receiver perform:aSelector with:(n / 100)
	]
    ].
    menu addItem:item.
  ^ menu

"
(self zoomMenuSelector:#zoomY) startUp
"

! !

!GraphColumn methodsFor:'accessing'!

name
    "get the name of the column
    "
    ^ aspects at:#name ifAbsent:nil
!

name:aName
    "set the name of the column
    "
    self aspectAt:#name put:aName
!

relativeXaxis
    "returns the relative X-axis (y == 0) into the graph view; staring at top (0.0) to
     bottom (1.0). Thus a relative X axis of 0.5 means the graph is centered in the view.
    "
    ^ aspects at:#relativeXaxis ifAbsent:0.5


!

relativeXaxis:aValue
    "sets the relative X-axis (y == 0) into the graph view; staring at top (0.0) to
     bottom (1.0). Thus a relative X axis of 0.5 means the graph is centered in the view.
     In case that the value is not a valid number, the relative X axis is set to 0.5.
    "
    |x|

    self aspectAt:#relativeXaxis put:(self numberFrom:aValue onError:[0.5])

!

scaleY
    "returns the current y-scale of the column (~~ 0); this value should be set once
     dependent on the maximum and minimum Y value. To zoom the graph vertical use
     insteat #zoomY:.
    "
    ^ aspects at:#scaleY ifAbsent:1
!

scaleY:aFactor
    "set the current y-scale of the column (~~ 0); this value should be set once
     dependent on the maximum and minimum Y value. To zoom the graph vertical use
     insteat #zoomY:.
     In case that the value is not a valid number or less equal zero, the scale Y
     factor is set to its default value (1).
    "
    |y|

    (y := self numberFrom:aFactor onError:[1]) > 0 ifFalse:[ y := 1 ].
    self aspectAt:#scaleY put:y
!

shown
    "returns true if the column is shown otherwise false
    "
    ^ aspects at:#shown ifAbsent:true
!

shown:aState
    "set the visibility state of the column
    "
    self aspectAt:#shown put:aState
!

transY
    "get the current y-transition of the column; the default is 0
    "
    ^ aspects at:#transY ifAbsent:0
!

transY:aValue
    "set the current y-transition of the column to an integer or nil (== 0).
    "
    self aspectAt:#transY put:(self integerFrom:aValue onError:[0])
!

zoomY
    "returns the current y-zoom factor of the column excluding the scale Y factor
    "
    ^ aspects at:#zoomY ifAbsent:1
!

zoomY:aFactor
    "set the current y-zoom factor of the column. The graph and its
     horizontal lines are vertical zoomed relative to its center defined
     by the relativeXaxis.
     In case that the value is not a valid number or less equal zero, the zoom Y
     factor is set to its default value (1).
    "
    |y|

    (y := self numberFrom:aFactor onError:[1]) > 0 ifFalse:[ y := 1 ].
    self aspectAt:#zoomY put:y
! !

!GraphColumn methodsFor:'accessing Y function'!

functionYblock
    "get the two arguments block which is used to access Y values from
     start into an array. The block should return the collection of y
     values; see method: #from:into:
    "
    ^ functionYblock
!

functionYblock:something
    "set the two arguments block which is used to access Y values from
     start into an array. The block should return the collection of y
     values; see method: #from:into:
    "
    functionYblock := something.
    self changed.
! !

!GraphColumn methodsFor:'accessing Y values'!

yValueAt:anIndex
    "returns the Y value at an index
    "
    ^ (self yValuesStartAt:anIndex into:(Array new:1)) at:1
!

yValuesStartAt:start into:anArray
    "returns the Y values from start upto an array size. The collection of Y
     values should be returned.
     You can use the argument anArray, to store the Y values or a new array.
     The functionYblock is obligated to return the array used
    "
    ^ functionYblock value:start value:anArray
! !

!GraphColumn methodsFor:'accessing graph'!

foregroundColor
    "returns the color of the graph; if the color is nil the default foreground color
     of the graph is used which derives from the style sheet.
    "
    ^ aspects at:#foregroundColor ifAbsent:nil

!

foregroundColor:aColor
    "set the color of the graph; if the color is nil the default foreground color
     of the graph is used which derives from the style sheet.
    "
    self aspectAt:#foregroundColor put:aColor

!

lineStyle
    "returns the style in which the graph is drawn; if no style is defined, the
     default style is used (#solid).

     Supported styles are:
	 #solid or #dashed
    "
    ^ aspects at:#lineStyle ifAbsent:#solid
!

lineStyle:aStyle
    "set the style in which the graph is drawn; if no style is defined or
     in case of a non valid style, the default style is used (#solid).

     Supported styles are:
	#solid or #dashed
    "
    self aspectAt:#lineStyle put:(self class lineStyleFor:aStyle)
!

lineWidth
    "returns the width of the graph line
    "
    ^ aspects at:#lineWidth ifAbsent:1
!

lineWidth:anInteger
    "set the width of the graph line; if the width is not defined or
     not a valid number, the default value is set (1).
    "
    self aspectAt:#lineWidth put:(anInteger ? 1)
! !

!GraphColumn methodsFor:'accessing hLines'!

hLineFgColor
    "returns the color of the horizontal lines; if the color is nil the default foreground
     color of the graph is used which derives from the style sheet.
    "
    ^ aspects at:#hLineFgColor ifAbsent:nil
!

hLineFgColor:aColor
    "set the color of the horizontal lines; if the color is nil the default foreground
     color of the graph is used which derives from the style sheet.
    "
    self aspectAt:#hLineFgColor put:aColor
!

hLineList
    "returns the list of horizontal lines or nil
    "
    ^ aspects at:#hLineList ifAbsent:nil
!

hLineList:aCollection
    "set the list of horizontal lines to be drawn
    "
    |col|

    col := (aCollection size ~~ 0) ifTrue:[aCollection]
				  ifFalse:[nil].

    self aspectAt:#hLineList put:col
!

hLineStyle
    "returns the style in which the horizontal lines are drawn; if no style is
     defined, the default style is used (#solid).

     Supported styles are:
	#solid or #dashed
    "
    ^ aspects at:#hLineStyle ifAbsent:#solid
!

hLineStyle:aStyle
    "set the style in which the horizontal lines are drawn; if no style is defined
     or in case of a non valid style, the default style is used (#solid).

     Supported styles are:
	 #solid or #dashed.
    "
    self aspectAt:#hLineStyle put:(self class lineStyleFor:aStyle)

!

hLineWidth
    "returns the width of the horizontal lines
    "
    ^ aspects at:#hLineWidth ifAbsent:1

!

hLineWidth:anInteger
    "set the width of the horizontal lines; if the width is not defined or
     not a valid number, the default value is set (1).
    "
    self aspectAt:#hLineWidth put:(anInteger ? 1)


! !

!GraphColumn methodsFor:'accessing menu'!

middleButtonMenu
    "returns the default middle button menu of a column
    "
    |menu|

    menu := Menu new fromLiteralArrayEncoding:(self class middleButtonMenu).
    menu receiver:self.
  ^ menu


! !

!GraphColumn methodsFor:'accessing without notify'!

setForegroundColor:aColor
    "set the color of the graph; if the color is nil the default foreground color
     of the graph is used which derives from the style sheet.
     No change notification is raised
    "
    self withoutNotificationAspectAt:#foregroundColor put:aColor

!

setHLineFgColor:aColor
    "set the color of the horizontal lines; if the color is nil the default foreground
     color of the graph is used which derives from the style sheet.
     No change notification is raised
    "
    self withoutNotificationAspectAt:#hLineFgColor put:aColor
!

setHLineList:aCollection
    "set the list of horizontal lines to be drawn; no
     change notification is raised
    "
    |col|

    col := (aCollection size ~~ 0) ifTrue:[aCollection]
				  ifFalse:[nil].

    self withoutNotificationAspectAt:#hLineList put:col
!

setHLineStyle:aStyle
    "set the style in which the horizontal lines are drawn; if no style is defined
     or in case of a non valid style, the default style is used (#solid).
     No change notification is raised.

     Supported styles are:
	 #solid or #dashed.
    "
    self withoutNotificationAspectAt:#hLineStyle put:(self class lineStyleFor:aStyle)

!

setHLineWidth:anInteger
    "set the width of the horizontal lines; if the width is not defined or
     not a valid number, the default value is set (1).
     No change notification is raised.
    "
    self withoutNotificationAspectAt:#hLineWidth put:(anInteger ? 1)


!

setLineStyle:aStyle
    "set the style in which the graph is drawn; if no style is defined or
     in case of a non valid style, the default style is used (#solid).
     No change notification is raised.

     Supported styles are:
	#solid or #dashed
    "
    self withoutNotificationAspectAt:#lineStyle put:(self class lineStyleFor:aStyle)

!

setLineWidth:anInteger
    "set the width of the graph line; if the width is not defined or
     not a valid number, the default value is set (1).
     No change notification is raised
    "
    self withoutNotificationAspectAt:#lineWidth put:(anInteger ? 1)
!

setName:aName
    "set the name of the column; no change notification is raised
    "
    self withoutNotificationAspectAt:#name put:aName
!

setRelativeXaxis:aValue
    "sets the relative X-axis (y == 0) into the graph view; staring at top (0.0) to
     bottom (1.0). Thus a relative X axis of 0.5 means the graph is centered in the view.
     In case that the value is not a valid number, the relative X axis is set to 0.5.
     No change notification is raised.
    "
    self withoutNotificationAspectAt:#relativeXaxis
				 put:(self numberFrom:aValue onError:[0.5])

!

setScaleY:aFactor
    "set the current y-scale of the column (~~ 0); this value should be set once
     dependent on the maximum and minimum Y value. To zoom the graph vertical use
     insteat #zoomY:.
     In case that the value is not a valid number or less equal zero, the scale Y
     factor is set to its default value (1).
     No change notification is raised.
    "
    |y|

    (y := self numberFrom:aFactor onError:[1]) > 0 ifFalse:[ y := 1 ].
    self withoutNotificationAspectAt:#scaleY put:y
!

setShown:aState
    "set the visibility state of the column;
     no notification is raised
    "
    self withoutNotificationAspectAt:#shown put:aState
!

setTransY:aValue
    "set the current y-transition of the column to an integer or nil (== 0).
     no notification is raised
    "
    self withoutNotificationAspectAt:#transY
				 put:(self integerFrom:aValue onError:[0])
!

setZoomY:aFactor
    "set the current y-zoom factor of the column. The graph and its
     horizontal lines are vertical zoomed relative to its center defined
     by the relativeXaxis.
     In case that the value is not a valid number or less equal zero, the zoom Y
     factor is set to its default value (1).
     No change notification is raised.
    "
    |y|

    (y := self numberFrom:aFactor onError:[1]) > 0 ifFalse:[ y := 1 ].
    self withoutNotificationAspectAt:#zoomY put:y
! !

!GraphColumn methodsFor:'aspects'!

aspect
    "returns current aspects
    "
    ^ aspects
!

aspectAt:aKey put:aValue
    "set an aspect; if the aspect changed its value, a notification will
     be raised. The arguments to the change notifications is the key of
     the aspect (selector) and the old value of the aspect.
    "
    |oldValue|

    oldValue := aspects at:aKey ifAbsent:nil.

    oldValue ~= aValue ifTrue:[
	aValue isNil ifTrue:[aspects removeKey:aKey]
		    ifFalse:[aspects at:aKey put:aValue].

	self changed:aKey with:oldValue
    ]
!

aspects:aDictionaryOrNil
    "change aspects; raise a change notification when changed. If the argument is
     nil, the default aspects are set
    "
    |oldAspects|

    aDictionaryOrNil == aspects ifFalse:[
	oldAspects := aspects.
	self setAspects:aDictionaryOrNil.
	self changed:#aspects with:oldAspects.
    ]
!

setAspects:aDictionaryOrNil
    "change aspects; raise no notification. If the argument is
     nil, the default aspects are set
    "
    aDictionaryOrNil isNil ifTrue:[
	aspects := IdentityDictionary new.

	aspects at:#hLineWidth    put:1.
	aspects at:#lineWidth     put:1.
	aspects at:#scaleY        put:1.
	aspects at:#zoomY         put:1.
	aspects at:#transY        put:0.
	aspects at:#relativeXaxis put:0.5.
    ] ifFalse:[
	aspects := aDictionaryOrNil
    ]
!

withoutNotificationAspectAt:aKey put:aValue
    "set an aspect without a change notification
    "
    aValue notNil ifTrue:[ aspects at:aKey put:aValue ]
		 ifFalse:[ aspects removeKey:aKey ifAbsent:nil ]
! !

!GraphColumn methodsFor:'conversion'!

integerFrom:aValue onError:aBlock
    "converts something to an integer, on error the result of the block is returned
    "
    |v|

    aValue isNumber ifTrue:[
	^ aValue isInteger ifTrue:[aValue]
			  ifFalse:[(aValue asFloat) rounded]    "/ no fractions
    ].
    ^ aBlock value


!

numberFrom:aValue onError:aBlock
    "converts something to a number (no fractions); on error
     the result of the block is returned
    "
    aValue isNumber ifTrue:[
	^ aValue isInteger ifTrue:[aValue]
			  ifFalse:[aValue asFloat]      "/ no fractions
    ].
    ^ aBlock value
! !

!GraphColumn methodsFor:'initialization'!

initialize
    "setup default values
    "
    super initialize.
    self setAspects:nil.
! !

!GraphColumn methodsFor:'printing'!

printString
    "returns my printable string
    "
    |name|

    ^ (name := self name) notNil ifTrue:[name printString] ifFalse:['']
! !

!GraphColumn methodsFor:'queries'!

centerGraphMaxY:maxY minY:minY
    "set the transition Y for the graph dependent on the current scaleY, the maximum
     and minimum Y value; the graph is centered to its relative X-Axis.
    "
    self transY:(((maxY + minY) / 2) * self scaleY)
!

scaleToHeight:aHeight maxY:maxY minY:minY
    "set the scale Y value dependent on the maximum and minimum Y value to fit into
     a height >= 1
    "
    |dltY|

    (dltY := (maxY - minY) abs) = 0 ifTrue:[dltY := 1].
    self scaleY:((aHeight max:1) / dltY)
! !

!GraphColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/GraphColumn.st,v 1.4 2006-11-13 16:11:29 cg Exp $'
! !
