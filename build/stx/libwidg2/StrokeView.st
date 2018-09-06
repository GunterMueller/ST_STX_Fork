"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#StrokeView
	instanceVariableNames:'strokes currentStroke lastPoint clearButton clearLastButton
		strokeAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!StrokeView class methodsFor:'documentation'!

documentation
"
    a simple view, which collects strokes.
    will eventually become a character-input method
    for non-latin languages.
"
!

examples
"
        |v|

        v := StrokeView open.
        v inspect.



        |v|

        v := StrokeView openOnXScreenNamed:'bitsy:0'.    ' my pda !!!! '.
        v inspect.
"
! !

!StrokeView methodsFor:'accessing'!

strokeAction:something
    strokeAction := something.
! !

!StrokeView methodsFor:'button actions'!

newStrokeSequence
    strokes removeAll.
    currentStroke := lastPoint := nil.
    self updateButtonStates.
    self redraw.

    strokeAction notNil ifTrue:[
        strokeAction value:strokes.
    ]
!

removeLastStroke
    strokes size > 0 ifTrue:[
        strokes removeLast.
    ].

    currentStroke := lastPoint := nil.
    self updateButtonStates.
    self redraw.

    strokeAction notNil ifTrue:[
        strokeAction value:strokes.
    ]
!

updateButtonStates
    strokes isEmpty ifTrue:[
        clearButton disable.
        clearLastButton disable.
    ] ifFalse:[
        clearButton enable.
        clearLastButton enable.
    ]
! !

!StrokeView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |thisPoint|

    state == 0 ifTrue:[^ self].

    thisPoint := x@y.
    currentStroke add:(LineSegment from:lastPoint to:thisPoint).

    self paint:Color yellow.
    self displayLineFrom:lastPoint to:thisPoint.

    lastPoint := thisPoint.
!

buttonPress:state x:x y:y
    currentStroke isNil ifTrue:[
        currentStroke := OrderedCollection new.
    ].
    lastPoint := x@y.
!

buttonRelease:state x:x y:y
    currentStroke notNil ifTrue:[
        strokes add:currentStroke.
        currentStroke := nil.
        self updateButtonStates.
        self redrawStrokes.
        strokeAction notNil ifTrue:[
            strokeAction value:strokes.
        ]
    ].
! !

!StrokeView methodsFor:'initialization'!

drawStroke:aStroke
    aStroke do:[:eachSegment |
        self displayLineFrom:(eachSegment start) to:(eachSegment end).
    ].
!

initialize
    super initialize.

    self viewBackground:Color black.

    strokes := OrderedCollection new.

    clearButton := self newButton2D.
    clearButton label:'Clear'.
    clearButton layout:(LayoutFrame
                            leftFraction:0 offset:0 
                            rightFraction:0.5 offset:0
                            topFraction:1 offset:-20
                            bottomFraction:1 offset:0).

    clearButton action:[ self newStrokeSequence ].
    clearButton disable.

    clearLastButton := self newButton2D.
    clearLastButton label:'Undo'.
    clearLastButton layout:(LayoutFrame
                            leftFraction:0.5 offset:0 
                            rightFraction:1 offset:0
                            topFraction:1 offset:-20
                            bottomFraction:1 offset:0).

    clearLastButton action:[ self removeLastStroke ].
    clearLastButton disable.
!

newButton2D
    |button|

    "
     Times Are a'Changing -
        now it takes more effort to setup a 2D button,
        than to set up a 3D one ;-)"

    button := Button in:self.
    button passiveLevel:0.
    button activeLevel:0.
    button borderWidth:1.
    button borderColor:(Color black).
    button foregroundColor:(Color black).
    button backgroundColor:(Color white).
    ^ button
!

redraw
    self clear.
    self redrawStrokes.
!

redrawStrokes
    self paint:Color cyan.
    strokes do:[:eachStroke |
        self drawStroke:eachStroke
    ].

    self paint:Color yellow.
    currentStroke notNil ifTrue:[
        self drawStroke:currentStroke
    ].
! !

!StrokeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/StrokeView.st,v 1.3 2004-03-02 08:44:45 cg Exp $'
! !

