"{ NameSpace: Demos }"

View subclass:#SmilyView
	instanceVariableNames:'linkesOhrHolder rechtesOhrHolder nasenHolder mundHolder
		augenHolder haedXradius haedYradius'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tutorial'
!

!SmilyView class methodsFor:'documentation'!

documentation
"
    Part of Timos learning application (use of valueHolders, embedded widgets etc).

    [author:]
        Timo Merkert (tm@idefix)

    [see also:]
        FaceBuilderApplication
"

! !

!SmilyView methodsFor:'accessing'!

augenHolder
    "return the value of the instance variable 'augenHolder' (automatically generated)"

    ^ augenHolder!

augenHolder:something
    "set the value of the instance variable 'augenHolder' (automatically generated)"

    augenHolder := something.
    augenHolder onChangeSend:#redrawFace to:self.

!

linkesOhrHolder
    "return the value of the instance variable 'linkesOhrHolder' (automatically generated)"

    ^ linkesOhrHolder!

linkesOhrHolder:something
    "set the value of the instance variable 'linkesOhrHolder' (automatically generated)"

    linkesOhrHolder := something.
    linkesOhrHolder onChangeSend:#redrawFace to:self.

!

mundHolder
    "return the value of the instance variable 'mundHolder' (automatically generated)"

    ^ mundHolder!

mundHolder:something
    "set the value of the instance variable 'mundHolder' (automatically generated)"

    mundHolder := something.
    mundHolder onChangeSend:#redrawFace to:self.
!

nasenHolder
    "return the value of the instance variable 'nasenHolder' (automatically generated)"

    ^ nasenHolder!

nasenHolder:something
    "set the value of the instance variable 'nasenHolder' (automatically generated)"

    nasenHolder := something.
    nasenHolder onChangeSend:#redrawFace to:self.

!

rechtesOhrHolder
    "return the value of the instance variable 'rechtesOhrHolder' (automatically generated)"

    ^ rechtesOhrHolder!

rechtesOhrHolder:something
    "set the value of the instance variable 'rechtesOhrHolder' (automatically generated)"

    rechtesOhrHolder := something.
    rechtesOhrHolder onChangeSend:#redrawFace to:self.

! !

!SmilyView methodsFor:'drawing'!

drawAugen
    | maxAuge minAuge x1 x2 y r pos augenPos mitteL mitteR mb|

    r := (haedYradius * 0.15) rounded.    
    maxAuge := (haedXradius *5 /6) rounded.
    minAuge := 2*r.

    mitteL := (self width / 2 - r) rounded.
    mitteR := (self width / 2 + r) rounded.
    y := ( (self height /2) - (haedYradius * 0.5)) rounded.

    augenHolder isNil ifTrue:[
                               augenPos := 50.
                             ] ifFalse:[
                                         augenPos := augenHolder value
                                       ].
    augenHolder = 0 ifTrue:[ augenPos := 1].

    "/ augenHolder haelt 0..100%

    pos := maxAuge - minAuge .
    mb := pos * augenPos / 100.

    x1 := mitteL - mb.
    x2 := mitteR + mb.

    self displayCircleX:x1 y:y radius:r.
    self displayCircleX:x2 y:y radius:r


"
    self new open
"



!

drawFace
    self drawHaed.
    self drawAugen.
    self drawNase.
    self drawMund.
    self drawLOhr.
    self drawROhr
!

drawHaed
    | ohrenplatz x y radx rady r |

    ohrenplatz := (self width *0.3).
    x := (self width  /2) rounded.
    y := (self height /2) rounded.
    x>y ifTrue:[
                 r := y.
               ]
        ifFalse:[
                  r :=x.
                ].

    r := r - (ohrenplatz /2) rounded.
    haedXradius := r.                    "Instanz-Variable mit Wert fuellen"
    haedYradius := r.                    "Instanz-Variable mit Wert fuellen"


    self displayCircleX:x y:y radius:r



!

drawLOhr
    | a b c mitte x x0 y y0 minY maxY posY xrad yrad startangle endangle ohrLwert prozentanteil|

    mitte := (self height /2) rounded.
    startangle := 0.
    endangle := 360.
    xrad := (haedXradius * 0.2 /2) rounded.
    yrad := (haedXradius * 0.3 /2) rounded.

    x0 := ( (self width /2) - haedXradius - xrad ) .
    y0 := mitte.
    minY := ((mitte) - haedYradius + yrad) rounded.
    maxY := ((mitte) + haedYradius - yrad) rounded.

    linkesOhrHolder isNil ifTrue:[
                                    ohrLwert := 0
                                  ] 
                           ifFalse:[
                                     ohrLwert := linkesOhrHolder value.
                                     posY := ohrLwert
                                   ].


    "Ohr-Value von 0 - 50"
    ohrLwert < 0 ifTrue:[ ohrLwert := ohrLwert negated ].

    prozentanteil :=  ((mitte - minY) * ohrLwert /50).

    posY < 0 ifTrue:[ y := (y0 - prozentanteil) rounded]  "wenn Ohr-Value negativ , dann von 
                                                           Mitte hoch gehen"
            ifFalse:[y := (y0 + prozentanteil) rounded ]. "ansonsten weiter runter"

   "Hypothenuse"
   c := haedXradius.

   posY <= 0 ifTrue:[ a := (y0 - y) ]
            ifFalse:[ a := (y - y0) ].
   b :=( ( (c*c)-(a*a) ) sqrt) asInteger.

    x := (( self width / 2 ) - b - xrad) rounded.

    self displayArcX:x y:y width:xrad height:yrad from:startangle angle:endangle


"
    self new open
"

!

drawMund
    |halberWinkel mitte x y mb procentualeMundBreite xrad yrad startangle endangle|

    y := (self height /2 ) rounded.
    x := (self width /2 ) rounded.

    mitte := (self width /2 ) rounded.

    startangle := 270.

    xrad := (haedXradius * 0.8) rounded.
    yrad := (haedYradius * 0.8) rounded.

    halberWinkel := 60.

    mundHolder isNil ifTrue:[
                              procentualeMundBreite := 50.
                            ] ifFalse:[
                                        procentualeMundBreite := mundHolder value
                                      ].

    "/ mundHolder haelt 0..100%

    mb := halberWinkel * procentualeMundBreite / 100.

    startangle := startangle - mb.
    endangle := ( mb * 2 ).

    self displayArcX:x-xrad y:y-yrad
         width:xrad*2 height:yrad*2
         from:startangle angle:endangle



"
    self new open  
"
!

drawNase
    | linkeNasenGrenze rechteNasenGrenze mb mitte x y r nasenRadius procentualeNasenPosition|

    y := (self height /2) rounded.
    r := (haedYradius * 0.2) rounded.    
    nasenRadius := (r /2) rounded.

    mitte := (self width / 2) rounded.


    nasenHolder isNil ifTrue:[
                               procentualeNasenPosition := 50.
                             ] ifFalse:[
                                         procentualeNasenPosition := nasenHolder value
                                       ].

    "/ nasenHolder haelt 0..100%

    linkeNasenGrenze := mitte - haedYradius + r.
    rechteNasenGrenze := mitte + haedYradius -r.

    mb := (rechteNasenGrenze-linkeNasenGrenze * procentualeNasenPosition /100) rounded.
    x := linkeNasenGrenze + mb.

    self displayCircleX:x y:y radius:r


"
    self new open
"
!

drawROhr
    | a b c mitte x x0 y y0 minY maxY posY xrad yrad startangle endangle ohrRwert prozentanteil|

    mitte := (self height /2) rounded.
    startangle := 0.
    endangle := 360.
    xrad := (haedXradius * 0.2 /2) rounded.
    yrad := (haedXradius * 0.3 /2) rounded.

    x0 := ( (self width /2) - haedXradius - xrad ) .
    y0 := mitte.
    minY := (((self height /2)) - haedYradius + yrad) .
    maxY := (((self height /2)) + haedYradius - yrad) .

    rechtesOhrHolder isNil ifTrue:[
                                    ohrRwert := 0
                                  ] 
                           ifFalse:[
                                     ohrRwert := rechtesOhrHolder value.
                                     posY := ohrRwert
                                   ].

    "Ohr-Value von 0 - 50"
    ohrRwert < 0 ifTrue:[ ohrRwert := ohrRwert negated ].

    prozentanteil :=  (((self height /2) - minY) * ohrRwert /50) .

    posY < 0 ifTrue:[ y := (y0 - prozentanteil) rounded]  "wenn Ohr-Value negativ , dann von 
                                                           Mitte hoch gehen"
             ifFalse:[y := (y0 + prozentanteil) rounded ]. "ansonsten weiter runter"

   "Hypothenuse"
   c := haedXradius.

   posY <= 0 ifTrue:[ a := (y0 - y) ]
            ifFalse:[a := (y - y0) ].
   b :=( ( (c*c)-(a*a) ) sqrt)  asInteger.

    x := ( ( self width / 2 )+ b) rounded .


    self displayArcX:x y:y width:xrad height:yrad from:startangle angle:endangle



"
    self new open
"
!

redrawFace
    self clear.
    self drawFace
! !

!SmilyView methodsFor:'event handling'!

redrawX:x y:y width:w height:h
    self redrawFace
!

sizeChanged:how
    self redrawFace
! !

!SmilyView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/SmilyView.st,v 1.2 1999-09-01 22:12:42 cg Exp $'
! !
