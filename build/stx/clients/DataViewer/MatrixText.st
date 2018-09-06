"{ NameSpace: TDV }"

DrawableComponent subclass:#MatrixText
	instanceVariableNames:'vf3 maxY minY x z xdiff zdiff string'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!MatrixText methodsFor:'initialization'!

initialize
"setup up default values

<return: self>
"    
    super initialize.
    "initialize variables"
    maxY   := 1.0.
    minY   := 0.0.
    x      := 1.0.
    z      := 1.0.
    xdiff  := 1.0.
    zdiff  := 1.0.
    string := ''.



! !

!MatrixText methodsFor:'rendering'!

drawing
"draw column descriptions

<retrun: self>
"

    |vector distance font aSize|

    distance := renderer sizeForText.
    distance := distance*0.7.
    aSize := 12.
    (TextUtilities checkMaxFontSize:'Helvetica' withSize:aSize) < distance
	ifFalse:[aSize := 8.
		(TextUtilities checkMaxFontSize:'Helvetica' withSize:aSize) < distance
		    ifFalse:[aSize:= nil]].
    aSize = nil ifFalse:[
	(vector := vf3) isNil ifTrue:[
	    vector := vf3 := FloatArray new:3.
	].


    gl glDisableIS: gl GL_LIGHTING.

"/    vector at:1 put:0.0.
"/    vector at:2 put:1.0.
"/    vector at:3 put:0.0.
"/    gl glNormal3FV: vector.

    "draw column text"
    gl glColor3FV: #(1.0 1.0 1.0) asFloatArray.
    string isNil ifFalse:[
	gl glRasterPositionXDS: xdiff negated * 2
			   YDS: minY
			   ZDS: z.
	(renderer glContextInstance) displayText:string
				      withFont:'Helvetica'
				      withSize:aSize.
    ].
    gl glEnableIS: gl GL_LIGHTING.
].
    "Modified: / 13.10.1998 / 14:37:39 / ps"
    "Modified: / 22.10.1998 / 14:25:51 / cg"
! !

!MatrixText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/MatrixText.st,v 1.4 1999-04-23 15:22:54 cg Exp $'
! !
