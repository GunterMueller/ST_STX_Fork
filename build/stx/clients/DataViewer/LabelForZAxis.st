"{ NameSpace: TDV }"

DrawableComponent subclass:#LabelForAxis
	instanceVariableNames:'drawLabelsForAxis x deltaX y deltaY z deltaZ lenghtOfLabelLine
		stepForMainLabel stepForMinorLabel startNumberForMainLabel
		stepForNumberOfMainLabel distanceToAxisForMajorLabel
		distanceToAxisForMinorLabel lenghtOfMajorLabel lenghtOfMinorLabel
		stepForGrid drawGridForFirstPlane drawGridForSecondPlane
		drawMainLabel drawMinorLabel colorForMainText colorForMinorText
		colorForMainLabel colorForMinorLabel colorForGrid
		textSizeForMainLabel distanceToAxisForMajorLabelText
		stepForNextMainLabelForNumber numberForMainText
		startOffsetForMainText'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!LabelForAxis methodsFor:'initialization'!

initialize
"setup up default values

<return: self>
"    
    super initialize.
    "initialize variables"
    x     := 0.0.
    y     := 0.0.
    z     := 0.0.
    colorForGrid:= #(0.2 0.2 0.2) asFloatArray.
    colorForMinorLabel:= #(0.2 0.2 0.2) asFloatArray.
    colorForMainLabel:= #(0.2 0.2 0.2) asFloatArray.
    colorForMainText:= #(1.0 1.0 1.0) asFloatArray.
    colorForMinorText:= #(1.0 1.0 1.0) asFloatArray.
    numberForMainText := OrderedCollection new.
    textSizeForMainLabel := 10.0.
    stepForNextMainLabelForNumber := 1.
    startOffsetForMainText := 1.    
    draw := true.

    "Modified: / 25.6.1999 / 15:58:11 / ps"
! !

!LabelForAxis methodsFor:'protocol'!

copyAspects
"store an aspect identified by its symbol and its value to a local varibale

<return: self>
"
    |aspect|  
    (aspect := globalAspectsIdentDic at:#drawLabelsForAxis ifAbsent:[nil]) notNil
        ifTrue:[drawLabelsForAxis := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#x ifAbsent:[nil]) notNil
        ifTrue:[x := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#deltaX ifAbsent:[nil]) notNil
        ifTrue:[deltaX := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#y ifAbsent:[nil]) notNil
        ifTrue:[y := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#deltaY ifAbsent:[nil]) notNil
        ifTrue:[deltaY := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#z ifAbsent:[nil]) notNil
        ifTrue:[z := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#deltaZ ifAbsent:[nil]) notNil
        ifTrue:[deltaZ := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#lenghtOfLabelLine ifAbsent:[nil]) notNil
        ifTrue:[lenghtOfLabelLine := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#stepForMainLabel ifAbsent:[nil]) notNil
        ifTrue:[stepForMainLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#stepForMinorLabel ifAbsent:[nil]) notNil
        ifTrue:[stepForMinorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#stepForNumberOfMainLabel ifAbsent:[nil]) notNil
        ifTrue:[stepForNumberOfMainLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#distanceToAxisForMajorLabel ifAbsent:[nil]) notNil
        ifTrue:[distanceToAxisForMajorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#distanceToAxisForMinorLabel ifAbsent:[nil]) notNil
        ifTrue:[distanceToAxisForMinorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#lenghtOfMajorLabel ifAbsent:[nil]) notNil
        ifTrue:[lenghtOfMajorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#lenghtOfMinorLabel ifAbsent:[nil]) notNil
        ifTrue:[lenghtOfMinorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#stepForGrid ifAbsent:[nil]) notNil
        ifTrue:[stepForGrid := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawGridForFirstPlane ifAbsent:[nil]) notNil
        ifTrue:[drawGridForFirstPlane := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawGridForSecondPlane ifAbsent:[nil]) notNil
        ifTrue:[drawGridForSecondPlane := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawMainLabel ifAbsent:[nil]) notNil
        ifTrue:[drawMainLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawMinorLabel ifAbsent:[nil]) notNil
        ifTrue:[drawMinorLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#colorForMainText ifAbsent:[nil]) notNil
        ifTrue:[colorForMainText := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#textSizeForMainLabel ifAbsent:[nil]) notNil
        ifTrue:[textSizeForMainLabel := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#distanceToAxisForMajorLabelText ifAbsent:[nil]) notNil
        ifTrue:[distanceToAxisForMajorLabelText := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#stepForNextMainLabelForNumber ifAbsent:[nil]) notNil
        ifTrue:[stepForNextMainLabelForNumber := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#numberForMainText ifAbsent:[nil]) notNil
        ifTrue:[numberForMainText := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#startOffsetForMainText ifAbsent:[nil]) notNil
        ifTrue:[startOffsetForMainText := aspect.initialized := false].


    globalAspectsIdentDic removeAll

    "Modified: / 25.6.1999 / 16:00:31 / ps"
!

draw
"draw grid

<return: self>
"
    |id vector4f vector1 vector2 displId|

    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    vector4f:= FloatArray new:4.

    vector4f at:1 put:0.2.
    vector4f at:2 put:0.2.
    vector4f at:3 put:0.2.
    vector4f at:4 put:1.0.
    gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
             valuesFV: vector4f.

    (drawLabelsForAxis == #xAxis) ifTrue:[self drawLabelsForXAxis.
                                           self drawLabelTextForXAxis.
                                           self drawGridForXAxis].
    (drawLabelsForAxis == #yAxis) ifTrue:[self drawLabelsForYAxis.
                                         "self drawLabelTextForYAxis."
                                          self drawGridForYAxis].
    (drawLabelsForAxis == #zAxis) ifTrue:[self drawLabelsForZAxis.
                                          "self drawLabelTextForZAxis."
                                          self drawGridForZAxis].

    "Modified: / 25.6.1999 / 15:44:32 / ps"
!

drawGridForXAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glColor3FV: colorForGrid.

    gl glBeginIS: gl GL_LINES.
        stepForGrid notNil
            ifTrue:[
                (drawGridForFirstPlane == true) ifTrue:[
                    "draw grid for main plane"
                    vector1 at:2 put:y.
                    vector2 at:2 put:y.
                    vector1 at:3 put:z.
                    vector2 at:3 put:z negated.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:1 put:x - i.
                        vector2 at:1 put:x - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]].
                (drawGridForSecondPlane == true) ifTrue:[
                    "draw grid for second plane"
                    vector1 at:2 put:y.
                    vector2 at:2 put:y+deltaY.
                    vector1 at:3 put:z negated.
                    vector2 at:3 put:z negated.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:1 put:x - i.
                        vector2 at:1 put:x - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]]].
    gl glEnd.

    "Created: / 25.6.1999 / 14:56:37 / ps"
    "Modified: / 25.6.1999 / 15:19:54 / ps"
!

drawGridForYAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glColor3FV: colorForGrid.    

    gl glBeginIS: gl GL_LINES.
        stepForGrid notNil
            ifTrue:[
                (drawGridForFirstPlane == true) ifTrue:[
                    "draw grid for main plane"
                    vector1 at:1 put:0.0.
                    vector2 at:1 put:x.
                    vector1 at:3 put:z.
                    vector2 at:3 put:z.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:2 put:y - i.
                        vector2 at:2 put:y - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]].
                (drawGridForSecondPlane == true) ifTrue:[
                    "draw grid for second plane"
                    vector1 at:1 put:x.
                    vector2 at:1 put:x.
                    vector1 at:3 put:z.
                    vector2 at:3 put:z + deltaZ.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:2 put:y - i.
                        vector2 at:2 put:y - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]]].
    gl glEnd.

    "Created: / 25.6.1999 / 15:15:02 / ps"
    "Modified: / 25.6.1999 / 15:20:01 / ps"
!

drawGridForZAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glColor3FV: colorForGrid.

    gl glBeginIS: gl GL_LINES.
        stepForGrid notNil
            ifTrue:[
                (drawGridForFirstPlane == true) ifTrue:[
                    "draw grid for main plane"
                    vector1 at:1 put:0.0.
                    vector2 at:1 put:x.
                    vector1 at:2 put:y.
                    vector2 at:2 put:y.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:3 put:z - i.
                        vector2 at:3 put:z - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]].
                (drawGridForSecondPlane == true) ifTrue:[
                    "draw grid for second plane"
                    vector1 at:1 put:x.
                    vector2 at:1 put:x.
                    vector1 at:2 put:y.
                    vector2 at:2 put:y+deltaY.
                    0 to: lenghtOfLabelLine by: stepForGrid do:[:i|
                        vector1 at:3 put:z - i.
                        vector2 at:3 put:z - i.
                        gl glVertex3FV:vector1.
                        gl glVertex3FV:vector2]]].
    gl glEnd.

    "Modified: / 25.6.1999 / 15:19:46 / ps"
!

drawLabelTextForXAxis
"

<return: self>
"
    |step number index|      

    index := 1.
    "draw text for main label"
    gl glDisableIS: gl GL_LIGHTING.
    gl glColor3FV: colorForMainText.

    step := stepForNextMainLabelForNumber.   

    stepForMainLabel notNil ifTrue:[
        (drawMainLabel == true) ifTrue:[
            "draw major labels"
            0 to: lenghtOfLabelLine by: (stepForMainLabel * step) do:[:i|
                (number := (numberForMainText at: (index+step) ifAbsent:[nil])) notNil
                    ifTrue:[
                        gl glRasterPositionXDS: i - (textSizeForMainLabel/4) 
                                           YDS: y - (textSizeForMainLabel/2)
                                           ZDS: z - (distanceToAxisForMajorLabel+lenghtOfMajorLabel)
                                                    + distanceToAxisForMajorLabelText.
                        (renderer glContextInstance) displayText:number printString
                                                     withFont:'Helvetica'
                                                     withSize:textSizeForMainLabel.
                        index := index + 1.
    ]]]].
    gl glEnableIS: gl GL_LIGHTING.

    "Modified: / 25.6.1999 / 15:57:32 / ps"
!

drawLabelTextForYAxis

    |number step|
    (textSizeForMainLabel = nil or:[startNumberForMainLabel = nil or:
    [stepForNumberOfMainLabel = nil]])
        ifFalse:[
            "draw text for main label"
            gl glDisableIS: gl GL_LIGHTING.
            gl glColor3FV: colorForMainText.
            number := startNumberForMainLabel.
            stepForNextMainLabelForNumber isNil
                ifTrue: [step := 1]
                ifFalse:[step := stepForNextMainLabelForNumber].
            stepForMainLabel notNil ifTrue:[
                (drawMainLabel == true) ifTrue:[
                    "draw major labels"
                    0 to: lenghtOfLabelLine by: (stepForMainLabel * step) do:[:i|
                        gl glRasterPositionXDS: 0.0 - (distanceToAxisForMajorLabel+lenghtOfMajorLabel)
                                                   - distanceToAxisForMajorLabelText
                                           YDS: i - (textSizeForMainLabel/6) - y 
                                           ZDS: z - (textSizeForMainLabel/2).
                        (renderer glContextInstance) displayText:number printString
                                                     withFont:'Helvetica'
                                                     withSize:textSizeForMainLabel.
                        number := number + (stepForNumberOfMainLabel * step).
            ]]].
            gl glEnableIS: gl GL_LIGHTING.
     ]

    "Modified: / 25.6.1999 / 15:23:50 / ps"
!

drawLabelTextForZAxis

    |number step|
    (textSizeForMainLabel = nil or:[startNumberForMainLabel = nil or:
    [stepForNumberOfMainLabel = nil]])
        ifFalse:[
            "draw text for main label"
            gl glDisableIS: gl GL_LIGHTING.
            gl glColor3FV: colorForMainText.
            number := startNumberForMainLabel.
            stepForNextMainLabelForNumber isNil
                ifTrue: [step := 1]
                ifFalse:[step := stepForNextMainLabelForNumber].
            stepForMainLabel notNil ifTrue:[
                (drawMainLabel == true) ifTrue:[
                    "draw major labels"
                    0 to: lenghtOfLabelLine by: (stepForMainLabel * step) do:[:i|
                        gl glRasterPositionXDS: 0.0 - (distanceToAxisForMajorLabel+lenghtOfMajorLabel)
                                                   - distanceToAxisForMajorLabelText
                                           YDS: y - (textSizeForMainLabel/2) 
                                           ZDS: z - i - (textSizeForMainLabel/4).
                        (renderer glContextInstance) displayText:number printString
                                                     withFont:'Helvetica'
                                                     withSize:textSizeForMainLabel.
                        number := number + (stepForNumberOfMainLabel * step).
            ]]].
            gl glEnableIS: gl GL_LIGHTING.
     ]

    "Modified: / 25.6.1999 / 15:23:56 / ps"
!

drawLabelsForXAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glBeginIS: gl GL_LINES.
        stepForMainLabel notNil ifTrue:[
            (drawMainLabel == true) ifTrue:[
                gl glColor3FV: colorForMainLabel.
                "draw major labels"
                vector1 at:2 put:y.
                vector2 at:2 put:y.
                vector1 at:3 put:z - distanceToAxisForMajorLabel.
                vector2 at:3 put:z - (distanceToAxisForMajorLabel+lenghtOfMajorLabel).
                0 to: lenghtOfLabelLine by: stepForMainLabel do:[:i|
                    vector1 at:1 put:x - i.
                    vector2 at:1 put:x - i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2]]].
        stepForMinorLabel notNil ifTrue:[                              
            (drawMinorLabel == true) ifTrue:[
                gl glColor3FV: colorForMinorLabel.
                "draw minor labels"
                vector1 at:2 put:y.
                vector2 at:2 put:y.
                vector1 at:3 put:z - distanceToAxisForMinorLabel.
                vector2 at:3 put:z - (distanceToAxisForMinorLabel+lenghtOfMinorLabel).
                0 to: lenghtOfLabelLine by: stepForMinorLabel do:[:i|
                    vector1 at:1 put:x - i.
                    vector2 at:1 put:x - i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2]]].

    gl glEnd.

    "Modified: / 25.6.1999 / 15:20:42 / ps"
!

drawLabelsForYAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glBeginIS: gl GL_LINES.
        stepForMainLabel notNil ifTrue:[
            (drawMainLabel == true) ifTrue:[
                gl glColor3FV: colorForMainLabel.
                "draw major labels"
                vector1 at:1 put:0.0 - distanceToAxisForMajorLabel.
                vector2 at:1 put:0.0 - (distanceToAxisForMajorLabel+lenghtOfMajorLabel).
                vector1 at:3 put:z.
                vector2 at:3 put:z.

                0 to: lenghtOfLabelLine by: stepForMainLabel do:[:i|
                    vector1 at:2 put:y-i.
                    vector2 at:2 put:y-i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2]]].
        stepForMinorLabel notNil ifTrue:[
            (drawMinorLabel == true) ifTrue:[
                gl glColor3FV: colorForMinorLabel.
                "draw minor labels"
                vector1 at:1 put:0.0 - distanceToAxisForMinorLabel.
                vector2 at:1 put:0.0 - (distanceToAxisForMinorLabel+lenghtOfMinorLabel).
                vector1 at:3 put:z.
                vector2 at:3 put:z.
                0 to: lenghtOfLabelLine by: stepForMinorLabel do:[:i|
                    vector1 at:2 put:y-i.
                    vector2 at:2 put:y-i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2.]]].
    gl glEnd.

    "Modified: / 25.6.1999 / 15:20:38 / ps"
!

drawLabelsForZAxis
"draw grid

<return: self>
"
    |vector1 vector2|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.

    gl glBeginIS: gl GL_LINES.
        stepForMainLabel notNil ifTrue:[
            (drawMainLabel == true) ifTrue:[
                gl glColor3FV: colorForMainLabel.
                "draw major labels"
                vector1 at:1 put:0.0 - distanceToAxisForMajorLabel.
                vector2 at:1 put:0.0 - (distanceToAxisForMajorLabel+lenghtOfMajorLabel).
                vector1 at:2 put:y.
                vector2 at:2 put:y.
                0 to: lenghtOfLabelLine by: stepForMainLabel do:[:i|
                    vector1 at:3 put:z - i.
                    vector2 at:3 put:z - i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2.]]].
        stepForMinorLabel notNil ifTrue:[
            (drawMinorLabel == true) ifTrue:[
                gl glColor3FV: colorForMinorLabel.
                "draw minor labels"
                vector1 at:1 put:0.0 - distanceToAxisForMinorLabel.
                vector2 at:1 put:0.0 - (distanceToAxisForMinorLabel+lenghtOfMinorLabel).
                0 to: lenghtOfLabelLine by: stepForMinorLabel do:[:i|
                    vector1 at:3 put:z - i.
                    vector2 at:3 put:z - i.
                    gl glVertex3FV:vector1.
                    gl glVertex3FV:vector2.]]].
    gl glEnd.

    "Modified: / 25.6.1999 / 15:20:35 / ps"
! !

!LabelForAxis class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/LabelForZAxis.st,v 1.4 1999-06-25 14:06:47 ps Exp $'
! !
