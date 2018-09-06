"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#GraphicDrawingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!GraphicDrawingTest methodsFor:'tests'!

_testDraw:drawBlock thenCheck:checkBlock
    |form|

    form := Form width:30 height:30 depth:(Display depth) onDevice:Display.
    form clear.
    drawBlock value:form.

    checkBlock value:form.
!

test_01_Clear
    self
	_testDraw:[:form | ]
	thenCheck:[:form |
	    |blackPixel whitePixel pix|

	    blackPixel := (Color black onDevice:Display) colorId.
	    whitePixel := (Color white onDevice:Display) colorId.

	    0 to:form height-1 do:[:y |
		0 to:form width-1 do:[:x |
		    pix := form atX:x y:y.
		    self assert:( pix == blackPixel )
		]
	    ]
	]

    "
     self new test_01_Clear
    "
!

test_02_DrawHLine
    self
	_testDraw:[:form |
	    form paint:Color white.
	    form displayLineFromX:1 y:0 toX:form width-1-1 y:0.
	]
	thenCheck:[:form |
	    |blackPixel whitePixel pix|

	    blackPixel := (Color black onDevice:Display) colorId.
	    whitePixel := (Color white onDevice:Display) colorId.

	    1 to:form height-1 do:[:y |
		0 to:form width-1 do:[:x |
		    pix := form atX:x y:y.
		    self assert:( pix == blackPixel )
		]
	    ].

	    pix := form atX:0 y:0.
	    self assert:( pix == blackPixel ).
	    pix := form atX:(form width-1) y:0.
	    self assert:( pix == blackPixel ).

	    1 to:form width-2 do:[:x |
		pix := form atX:x y:0.
		self assert:( pix == whitePixel )
	    ]
	]

    "
     self new test_02_DrawHLine
    "
!

test_03_DrawRectangle
    self
	_testDraw:[:form |
	    form paint:Color white.
	    form displayRectangleX:1 y:1 width:(form width-1-1) height:(form height-1-1).
	]
	thenCheck:[:form |
	    |blackPixel whitePixel pix|

	    blackPixel := (Color black onDevice:Display) colorId.
	    whitePixel := (Color white onDevice:Display) colorId.

	    2 to:form height-1-1-1 do:[:y |
		2 to:form width-1-1-1 do:[:x |
		    pix := form atX:x y:y.
		    self assert:( pix == blackPixel )
		]
	    ].

	    0 to:form width-1 do:[:x |
		pix := form atX:x y:0.
		self assert:( pix == blackPixel )
	    ].
	    0 to:form width-1 do:[:x |
		pix := form atX:x y:(form height-1).
		self assert:( pix == blackPixel )
	    ].
	    0 to:form height-1 do:[:y |
		pix := form atX:0 y:y.
		self assert:( pix == blackPixel )
	    ].
	    0 to:form height-1 do:[:y |
		pix := form atX:(form width-1) y:y.
		self assert:( pix == blackPixel )
	    ].

	    1 to:form width-1-1 do:[:x |
		pix := form atX:x y:1.
		self assert:( pix == whitePixel )
	    ].
	    1 to:form width-1-1 do:[:x |
		pix := form atX:x y:(form height-2).
		self assert:( pix == whitePixel )
	    ].

	]

    "
     self new test_03_DrawRectangle
    "
!

test_03_DrawVLine
    self
	_testDraw:[:form |
	    form paint:Color white.
	    form displayLineFromX:0 y:1 toX:0 y:form height-1-1.
	]
	thenCheck:[:form |
	    |blackPixel whitePixel pix|

	    blackPixel := (Color black onDevice:Display) colorId.
	    whitePixel := (Color white onDevice:Display) colorId.

	    0 to:form height-1 do:[:y |
		1 to:form width-1 do:[:x |
		    pix := form atX:x y:y.
		    self assert:( pix == blackPixel )
		]
	    ].

	    pix := form atX:0 y:0.
	    self assert:( pix == blackPixel ).
	    pix := form atX:0 y:(form height-1).
	    self assert:( pix == blackPixel ).

	    1 to:form height-2 do:[:y |
		pix := form atX:0 y:y.
		self assert:( pix == whitePixel )
	    ]
	]

    "
     self new test_03_DrawVLine
    "
! !

!GraphicDrawingTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

