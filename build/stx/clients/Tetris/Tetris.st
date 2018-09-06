"
    COPYRIGHT (c) 1993 by Claus Gittinger
              All Rights Reserved

    This software is furnished under a license and may be used
    only in accordance with the terms of that license and with the
    inclusion of the above copyright notice.   This software may not
    be provided or otherwise made available to, or used by, any
    other person.  No title to or ownership of the software is
    hereby transferred.

    This is a demo example:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
"
"{ Package: 'stx:clients/Tetris' }"

"{ NameSpace: Games }"

StandardSystemView subclass:#Tetris
	instanceVariableNames:'currentBlock gameGrid gameLevel firstGame playing score
		scoreLabel levelLabel userName hiscoreNames hiscoreValues message
		blockColor paused nRows nCols haveLock'
	classVariableNames:''
	poolDictionaries:''
	category:'games-Tetris'
!

Object subclass:#TetrisBlock
	instanceVariableNames:'slots origin sideLength color'
	classVariableNames:'RandomStream'
	poolDictionaries:''
	privateIn:Tetris
!

!Tetris class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1993 by Claus Gittinger
              All Rights Reserved

    This software is furnished under a license and may be used
    only in accordance with the terms of that license and with the
    inclusion of the above copyright notice.   This software may not
    be provided or otherwise made available to, or used by, any
    other person.  No title to or ownership of the software is
    hereby transferred.

    This is a demo example:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
"


!

documentation
"
    This is a quick & dirty implementation of the Tetris game;
    the game was written a long tme ago, not using many newer features
    of the system; some things may be done differently today ...

    [see also:]
        TetrisBlock

    [author:]
        Claus Gittinger

    [start with:]
        Games::Tetris open
"



! !

!Tetris class methodsFor:'defaults'!

blockSize
    |display factor|

    display := Screen current.

    factor := display horizontalPixelPerInch / 100.0.
    (self gridSize y * 30 * factor) > display height ifTrue:[
      (self gridSize y * 20 * factor) > display height ifTrue:[
        (self gridSize y * 15 * factor) > display height ifTrue:[
            ^ (10 * factor) rounded asInteger
        ].
        ^ (15 * factor) rounded asInteger
      ].
      ^ (20 * factor) rounded asInteger
    ].
    ^ (30 * factor) rounded asInteger
!

delayOfLevel:level
    "delay to move down a block as per level"
    ^ #(500 450 400 300 200 150 100 80 70 60 50 40 30 20 10) at:level
!

gridSize
    ^ 10 @ 25
!

maxScoreOf:level
    "when are we switching levels"
    ^ #(500 1000 2500 5000 7500 10000
	15000 20000 30000 50000 100000
	200000 500000) at:level
! !

!Tetris class methodsFor:'startup'!

open 
    |aGame box|

    aGame := self new.
    aGame label:'Tetris'.
    aGame icon:(Image fromFile:'bitmaps/Tetris.xbm' resolution:100).

    "before starting the game, ask for username"
    box := EnterBox new.
    box title:'Enter your name please:'.
    box initialText:(OperatingSystem getLoginName).
    box action:[:aString | aGame userName:aString. 
                           box destroy.
                           aGame open.
                           ^ aGame ].
    box showAtPointer

    "Tetris open"
! !

!Tetris methodsFor:'current block handling'!

fall
    "fall gives row points"

    |r|

    currentBlock notNil ifTrue:[
	r := (nRows - currentBlock origin y).
	(r < 0) ifTrue:[r := 0].
	score := score + (r // 2).
	[currentBlock notNil] whileTrue:[
	    self moveDown.
	    device flush
	]
    ]
!

moveDown
    |legal|

    currentBlock notNil ifTrue:[
	currentBlock moveDown.
	legal := self legalPosition.
	currentBlock moveUp.        
	legal ifTrue:[
	    currentBlock moveDownIn:self
	] ifFalse:[
	    self makeDebris.
	    self reduceDebris ifTrue:[
		self fill:viewBackground.
		self redraw
	    ]
	]
    ]
!

moveLeft
    |legal|

    currentBlock notNil ifTrue:[
	currentBlock moveLeft.
	legal := self legalPosition.
	currentBlock moveRight.
	legal ifTrue:[
	    currentBlock moveLeftIn:self
	]
    ]
!

moveRight
    |legal|

    currentBlock notNil ifTrue:[
	currentBlock moveRight.
	legal := self legalPosition.
	currentBlock moveLeft.
	legal ifTrue:[
	    currentBlock moveRightIn:self
	]
    ]
!

newBlock
    currentBlock notNil ifTrue:[
	self makeDebris
    ].
    currentBlock := TetrisBlock newWithSize:(self class blockSize).
    currentBlock color:blockColor.
    currentBlock origin:(3 @ currentBlock origin y).
    self legalPosition ifFalse:[
	currentBlock := nil
    ] ifTrue:[
	currentBlock drawIn:self
    ]
!

rotateLeft
    |legal|

    currentBlock notNil ifTrue:[
	currentBlock rotateLeft.
	legal := self legalPosition.
	currentBlock rotateRight.
	legal ifTrue:[
	    currentBlock rotateLeftIn:self
	]
    ]
!

rotateRight
    |legal|

    currentBlock notNil ifTrue:[
	currentBlock rotateRight.
	legal := self legalPosition.
	currentBlock rotateLeft.
	legal ifTrue:[
	    currentBlock rotateRightIn:self
	]
    ]
! !

!Tetris methodsFor:'debris handling'!

isFullRow:aRow
    "answer true, if given debris row is full"

    |index|
    index := 1.
    [index <= aRow size] whileTrue:[
	(aRow at:index) isNil ifTrue:[^ false].
	index := index + 1
    ].
    ^ true
!

makeDebris
    "transform the currentblock into debris"

    |slots index x y|

    slots := currentBlock slots.
    index := 1.
    [index <= (slots size)] whileTrue:[
	x := ((slots at:index) x) + currentBlock origin x.
	y := ((slots at:index) y) + currentBlock origin y.
	((y >= 0) and:[x >= 0]) ifTrue:[
	    (gameGrid at:(y + 1)) at:(x + 1) put:true
	].
	index := index + 1
    ].
    currentBlock := nil
!

reduceDebris
    "check for full row(s) of debris - remove if found
     answer true if any change"

    |srcIndex dstIndex rowCount|

    rowCount := 0.

    "find full rows - each one gives gameLevel * 100 points"
    1 to:nRows do:[:srcIndex |
	(self isFullRow:(gameGrid at:srcIndex)) ifTrue:[
	    gameGrid at:srcIndex put:nil.
	    rowCount := rowCount + 1.
	    score := score + (gameLevel * 100)
	]
    ].

    (rowCount ~~ 0) ifTrue:[
	"now remove all full lines"

	srcIndex := nRows.
	dstIndex := srcIndex.
	[srcIndex >= 1] whileTrue:[
	    (gameGrid at:srcIndex) notNil ifTrue:[
		gameGrid at:dstIndex put:(gameGrid at:srcIndex).
		dstIndex := dstIndex - 1
	    ].
	    srcIndex := srcIndex - 1
	].
	[dstIndex >= 1] whileTrue:[
	    gameGrid at:dstIndex put:(Array new:nCols).
	    dstIndex := dstIndex - 1
	].
	scoreLabel label:('score: ' , score printString)
    ].
    currentBlock := nil.
    ^ (rowCount ~~ 0)
! !

!Tetris methodsFor:'drawing'!

redraw
    realized ifFalse:[^ self].
    playing ifTrue:[
	paused ifTrue:[
	    self showCentered:'Game Paused\\press ESC to continue\q to exit' withCRs
	] ifFalse:[
	    self redrawDebris.
	    currentBlock notNil ifTrue:[
		currentBlock drawIn:self
	    ]
	]
    ] ifFalse:[
	firstGame ifTrue:[
	    self showCentered:'Hit return to start\
a ........... rotate left \d ........... rotate right

cursor left . move left   \cursor right  move right  \
space ....... fall        \
ESC ......... pause       \
q to exit' withCRs
	] ifFalse:[
	    self showGameOver
	]
    ]
!

redrawDebris
    1 to:nRows do:[:rowNr |
	self redrawDebrisRow:rowNr
    ]
!

redrawDebrisRow:rowNr
    |x y row side|

    row := gameGrid at:rowNr.
    side := self class blockSize.
    x := 0.
    y := (rowNr - 1) * side.
    row do:[:element |
	element notNil ifTrue:[
	    self paint:blockColor.
	    self fillRectangleX:(x + 1) y:(y + 1) 
			  width:(side - 2) height:(side - 2).
	    self is3D ifTrue:[
		self drawEdgesForX:(x + 1" + 1") y:(y + 1" + 1")
			      width:(side - 2) 
			     height:(side - 2) level:2
	    ]
	].
	x := x + side
    ]
!

showCentered:something
    |w h y text|

    text := something asStringCollection.

    font := font onDevice:device.
    h := font height * text size.
    self fill:viewBackground.
    y := (height - h) // 2.
    self paint:White.
    text do:[:line |
        w := font widthOf:line.
        self displayString:line x:(width - w) // 2 y:y.
        y := y + font height
    ]
!

showGameOver
    message notNil ifTrue:[
	self showCentered:message
    ] ifFalse:[
	self showCentered:'Game Over\\press return for new game\q to exit' withCRs
    ]
! !

!Tetris methodsFor:'hiscore handling'!

checkForNewHiscore
    "put players result into hiscore list, 
     return a message string to display or nil if the result wasn't worth it"

    |overAllBestPlayer overAllBestValue thisPlayer thisValue wow
     scoreList f|

    (OperatingSystem isReadable:'tetris.scores') ifFalse:[
        f := FileStream newFileNamed:'tetris.scores'.
        f isNil ifTrue:[
            self warn:'cannot create hiscore file'.
            ^ self
        ].
        f close
    ].

    self createScoreLock ifTrue:[
        self getHiscoreInfo.

        "if its this players first game, add her/him to list"
        hiscoreNames indexOf:userName ifAbsent:[
            hiscoreNames add:userName.
            hiscoreValues add:0
        ].

        wow := false.
        overAllBestValue := 0.

        1 to:(hiscoreNames size) do:[:index |
            thisPlayer := hiscoreNames at:index.
            thisValue := hiscoreValues at:index.

            "check if this is users best result so far"
            (thisPlayer = userName) ifTrue:[
                (score > thisValue) ifTrue:[
                    wow := true.
                    hiscoreValues at:index put:score.
                    thisValue := score
                ]
            ].

            "which one is best"
            (thisValue > overAllBestValue) ifTrue:[
                overAllBestValue := thisValue.
                overAllBestPlayer := thisPlayer
            ]
        ].
        hiscoreValues sortWith:hiscoreNames.
        hiscoreValues reverse. hiscoreNames reverse.
        scoreList := OrderedCollection with:'Top ten players:' with:''.
        1 to:(10 min:(hiscoreValues size)) do:[:index |
            scoreList add:((hiscoreNames at:index) printStringRightAdjustLen:14) ,
                          '  ' ,
                          ((hiscoreValues at:index) printStringRightAdjustLen:6)
        ].
        scoreList add:''.
        scoreList add:''.

        message := scoreList asStringWithCRs.

        wow ifTrue:[
            self putHiscoreInfo.
            self releaseScoreLock.
            (overAllBestPlayer = userName) ifTrue:[
                ^ message ,('congratulations ' , userName ,
                            '\you are champion\\press return for new game\q to exit') withCRs
            ].
            ^ message , ('congratulations ' , userName ,
                         '\this is your best result so far\\press return for new game\q to exit')
                                                                             withCRs
        ].
        self releaseScoreLock.
        ^ message , 'press return for new game\q to exit' withCRs
    ].
    ^ 'scorefile problem\\\press return for new game\q to exit' withCRs

    "Modified: 11.7.1996 / 23:56:34 / cg"
!

createScoreLock
    OperatingSystem supportsFileLinks ifTrue:[
        1 to:3 do:[:count |
            1 to:5 do:[:count |
                (OperatingSystem linkFile:'tetris.scores' to:'tetris.lock') ifTrue:[
                    haveLock := true. 
                    ^ true
                ].
                OperatingSystem sleep:1
            ].
            self warn:'Cannot update score-file (leftover lockfile)\\ - please remove tetris.lock by hand.' withCRs
        ].
    ].
    ^ false

    "Modified: / 12.9.1998 / 14:52:10 / cg"
!

getHiscoreInfo
     |aStream name value|

     hiscoreNames := OrderedCollection new.
     hiscoreValues := OrderedCollection new.
     aStream := FileStream readonlyFileNamed:'tetris.scores'.
     aStream notNil ifTrue:[
	[aStream atEnd] whileFalse:[
	    name := aStream fileInNextChunkNotifying:nil.
	    value := aStream fileInNextChunkNotifying:nil.
	    name notNil ifTrue:[
		hiscoreNames add:name.
		hiscoreValues add:value
	    ]
	]
    ]
!

putHiscoreInfo
     |aStream|

     aStream := FileStream oldFileNamed:'tetris.scores'.
     aStream isNil ifTrue:[
	aStream := FileStream newFileNamed:'tetris.scores'
     ].
     aStream notNil ifTrue:[
	1 to:(hiscoreNames size) do:[:index |
	    (hiscoreNames at:index) storeOn:aStream.
	    aStream nextPut:$!!.
	    (hiscoreValues at:index) storeOn:aStream.
	    aStream nextPut:$!!.
	    aStream cr
	].
	aStream close
    ] ifFalse:[
	self notify:'cannot create or write hiscore file'
    ]
!

releaseScoreLock
    haveLock ifTrue:[OperatingSystem removeFile:'tetris.lock']
! !

!Tetris methodsFor:'initialization'!

initForNewGame
    gameGrid := Array new:nRows.
    1 to:nRows do:[:index |
	gameGrid at:index put:(Array new:nCols)
    ].
    currentBlock := nil.
    gameLevel := 1.
    playing := false.
    score := 0
!

initialize
    |gameSize labelFont|

    super initialize.

    nRows := self class gridSize y.
    nCols := self class gridSize x.
    haveLock := false.

    "choose a smaller font on small Displays"
    Screen current width < 801 ifTrue:[
        self font:(Font family:'courier'
                          face:'medium'
                         style:'roman'
                          size:8).
        labelFont := (Font family:'courier'
                             face:'medium'
                            style:'roman'
                             size:10)
    ] ifFalse:[
        labelFont := font
    ].

    viewBackground := Color black.
    self is3D ifTrue:[
        blockColor := Grey "Color grey"
    ] ifFalse:[
        blockColor := White
    ].

    levelLabel := Label in:self.
    levelLabel origin:(0.0 @ 0.0) extent:(0.5 @ levelLabel height).
    levelLabel label:'level: 1'.
    levelLabel level:1.
    levelLabel font:labelFont.

    scoreLabel := Label in:self.
    scoreLabel origin:(0.5 @ 0.0) extent:(0.5 @ scoreLabel height).
    scoreLabel label:'score: 0'.
    scoreLabel level:1.
    scoreLabel font:labelFont.

    gameSize := self class gridSize * self class blockSize.
    gameSize := gameSize + (0 @ scoreLabel height).

    self extent:gameSize.
    self minExtent:gameSize.
    self maxExtent:gameSize.

    self initForNewGame.
    firstGame := true.
    paused := false

    "Tetris start"
!

initializeMiddleButtonMenu
    |labels|

    Smalltalk language == #german ifTrue:[
	labels := #('Neues Spiel'
		    '-'
		    'ende'
		   )
    ] ifFalse:[
	labels := #('new game'
		    '-'
		    'quit')
    ].

    self middleButtonMenu:(PopUpMenu
				labels:labels
			     selectors:#(newGame
					 nil
					 quit)
				receiver:self
				     for:self)
!

reinitialize
    "when coming up from a snapshot, forget old game ..."

    super reinitialize.
    playing := false.
    realized ifTrue:[
	self showGameOver
    ]
!

userName:aString
    userName := aString
! !

!Tetris methodsFor:'playing'!

playOneBlock
    |delay endTime|

    delay := self class delayOfLevel:gameLevel.
    score := score + (10 * gameLevel).
    scoreLabel label:('score: ' , score printString).
    (score > (self class maxScoreOf:gameLevel)) ifTrue:[
	gameLevel := gameLevel + 1.
	levelLabel label:('level: ' , gameLevel printString)
    ].
    [currentBlock notNil] whileTrue:[
	endTime := OperatingSystem getMillisecondTime + delay.
	[OperatingSystem getMillisecondTime < endTime] whileTrue:[
	    currentBlock isNil ifTrue:[^ true].

	    ProcessorScheduler isPureEventDriven ifTrue:[
		"old scheme:"
		device eventPending ifTrue:[
		    device dispatchEvent
		] ifFalse:[
		    OperatingSystem millisecondDelay:10
		].
	    ] ifFalse:[
		"new scheme:"
		(self sensor hasDamage or:[self sensor hasEvents]) ifTrue:[
		    windowGroup processEvents
		] ifFalse:[
		    (Delay forMilliseconds:10) wait.
		].
	    ].
	    playing ifFalse:[^ self]
	].
	playing ifFalse:[^ self].
	paused ifFalse:[
	    self moveDown
	]
    ]

    "Tetris start"
!

playOneGame
    self newGame.
    self fill:viewBackground.
    playing := true.
    firstGame := false.
    [playing] whileTrue:[
	self newBlock.
	currentBlock isNil ifTrue:[
	    playing := false
	] ifFalse:[
	    self playOneBlock
	]
    ].
    message := self checkForNewHiscore.
    realized ifTrue:[
	self showGameOver
    ]
! !

!Tetris methodsFor:'testing'!

legalPosition
    "answer true, if currentblocks position is legal"

    |maximumX minimumX maximumY minimumY x y yIndex|

    "check if out if game"

    minimumX := currentBlock minX + currentBlock origin x.
    (minimumX < 0) ifTrue:[^ false].

    maximumX := currentBlock maxX + currentBlock origin x.
    (maximumX >= nCols) ifTrue:[^ false].

    maximumY := currentBlock maxY + currentBlock origin y.
    minimumY := currentBlock minY + currentBlock origin y.

    (minimumY < 0) ifTrue:[
	minimumY := 0
    ] ifFalse:[
	(maximumY >= nRows) ifTrue:[^ false]
    ].

    "check if it hits any debris"
    y := minimumY.
    [y <= maximumY] whileTrue:[
	yIndex := y + 1.
	x := minimumX.
	[x <= maximumX] whileTrue:[
	    ((gameGrid at:yIndex) at:(x + 1)) notNil ifTrue:[
		(currentBlock hits:(x @ y)) ifTrue:[^ false]
	    ].
	    x := x + 1
	].
	y := y + 1
    ].
    ^ true
! !

!Tetris methodsFor:'user actions'!

destroy
    currentBlock := nil.
    playing := false.
    super destroy
!

keyPress:key x:x y:y
    (key == #Escape) ifTrue:[
	playing ifTrue:[
	    paused := paused not.
	    self clear.
	    self redraw
	].
	^ self
    ].

    (key == $q) ifTrue:[
	playing ifFalse:[
	   self quit
	].
	paused ifTrue:[
	    self quit
	].
	^ self
    ].
    "ignore everything else if paused"

    paused ifTrue:[^ self].
    (key == (Character space)) ifTrue:[
	playing ifTrue:[
	    ^ self fall
	].
	^ self
    ].
    (key == #Return) ifTrue:[
	playing ifFalse:[
	    ^ self playOneGame
	].
	^ self fall
    ].
    playing ifFalse:[ ^ self].

    (key == #CursorRight) ifTrue:[
	^ self moveRight
    ].
    (key == $l) ifTrue:[
	^ self moveRight
    ].
    (key == #CursorLeft) ifTrue:[
	^ self moveLeft
    ].
    (key == $h) ifTrue:[
	^ self moveLeft
    ].
    (key == $m) ifTrue:[
	^ self moveDown
    ].
    (key == #CursorUp) ifTrue:[
	^ self rotateLeft
    ].
    (key == $a) ifTrue:[
	^ self rotateLeft
    ].
    (key == #CursorDown) ifTrue:[
	^ self rotateRight
    ].
    (key == $d) ifTrue:[
	^ self rotateRight
    ]
!

newGame
    self fill:viewBackground.
    self initForNewGame.
    self redraw
!

quit
    "user selected quit - from either menu or keyboard"

    self destroy
! !

!Tetris::TetrisBlock class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1993 by Claus Gittinger
              All Rights Reserved

    This software is furnished under a license and may be used
    only in accordance with the terms of that license and with the
    inclusion of the above copyright notice.   This software may not
    be provided or otherwise made available to, or used by, any
    other person.  No title to or ownership of the software is
    hereby transferred.

    This is a demo example:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
"


!

documentation
"
    Instances of TetrisBlock represents blocks as used in the Tetris
    game. This is a helper class.

    [see also:]
        Tetris

    [author:]
        Claus Gittinger

    [start with:]
        Tetris open
"


!

version
    ^ '$Header: /cvs/stx/stx/clients/Tetris/Tetris.st,v 1.18 2006-10-10 15:14:01 stefan Exp $'
! !

!Tetris::TetrisBlock class methodsFor:'instance creation'!

newWithSize:l
    "generate a new random TetrisBlock"
    |rnd newBlock|

    RandomStream isNil ifTrue:[
	RandomStream := Random new
    ].
    rnd := -1.
    [(rnd < 0) or:[rnd > 6]] whileTrue:[
	rnd := self nextRandomNumber
    ].
    newBlock := self basicNew initialize.
    newBlock setType:rnd.
    newBlock sideLength:l.
    ^ newBlock
! !

!Tetris::TetrisBlock class methodsFor:'private'!

nextRandomNumber
    |rnd|

    rnd := RandomStream next.   "0 < rnd < 1"
    rnd := rnd * 7.             "0 < rnd < 7"
    rnd := rnd asInteger.       "0 .. 6"
    ^ rnd
! !

!Tetris::TetrisBlock methodsFor:'accessing'!

color:aColor
    color := aColor
!

origin
    ^ origin
!

origin:aPoint
    origin := aPoint
!

sideLength:aNumber
    sideLength := aNumber
!

slots
    ^ slots
! !

!Tetris::TetrisBlock methodsFor:'drawing'!

clearIn:aView
    |orgX orgY|

    aView paint:(aView viewBackground).
    orgX := origin x.
    orgY := origin y.
    slots do:[:aPoint |
	aView fillRectangleX:(orgX + aPoint x) * sideLength
			   y:(orgY + aPoint y) * sideLength
		       width:sideLength
		      height:sideLength
    ]
!

drawIn:aView
    |side orgX orgY x y|

    side := sideLength - 2.
    orgX := origin x.
    orgY := origin y.
    aView paint:color.
    slots do:[:aPoint |
	x := (orgX + aPoint x) * sideLength.
	y := (orgY + aPoint y) * sideLength.
	aView fillRectangleX:x + 1
			   y:y + 1
		       width:side
		      height:side.
    ].
    aView is3D ifTrue:[
	slots do:[:aPoint |
	    x := (orgX + aPoint x) * sideLength.
	    y := (orgY + aPoint y) * sideLength.
	    aView drawEdgesForX:(x + 1) y:(y + 1)
			  width:(side) height:(side) level:2
	]
    ]
! !

!Tetris::TetrisBlock methodsFor:'manipulation'!

moveDown
    origin y:(origin y + 1)
!

moveLeft
    origin x:(origin x - 1)
!

moveRight
    origin x:(origin x + 1)
!

moveUp
    origin y:(origin y - 1)
!

rotateLeft
    |oldPoint newPoint|

    1 to:(slots size) do:[:index |
	oldPoint := slots at:index.
	newPoint := (oldPoint y) @ (oldPoint x negated).
	slots at:index put:newPoint
    ]
!

rotateRight
    |oldPoint newPoint|

    1 to:(slots size) do:[:index |
	oldPoint := slots at:index.
	newPoint := (oldPoint y negated) @ (oldPoint x).
	slots at:index put:newPoint
    ]
! !

!Tetris::TetrisBlock methodsFor:'private'!

initialize
    slots := Array new:4.
    origin := 0@0
!

setType:type
    (type == 0) ifTrue:[
	"0/0  1/0  2/0  3/0"
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(2 @ 0).
	slots at:4 put:(3 @ 0).
	^ self 
    ].
    (type == 1) ifTrue:[
	"0/0  1/0  
	 0/1  1/1"
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(0 @ 1).
	slots at:4 put:(1 @ 1).
	^ self 
    ].
    (type == 2) ifTrue:[
	"0/0  1/0  2/0
		   2/1"
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(2 @ 0).
	slots at:4 put:(2 @ 1).
	^ self 
    ].
    (type == 3) ifTrue:[
	"0/0  1/0  2/0
	 0/1"
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(2 @ 0).
	slots at:4 put:(0 @ 1).
	^ self 
    ].
    (type == 4) ifTrue:[
	"0/0  1/0  
	      1/1  2/1"
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(1 @ 1).
	slots at:4 put:(2 @ 1).
	^ self 
    ].
    (type == 5) ifTrue:[
	"     1/0  2/0
	 0/1  1/1     "
	slots at:1 put:(1 @ 0).
	slots at:2 put:(2 @ 0).
	slots at:3 put:(0 @ 1).
	slots at:4 put:(1 @ 1).
	^ self 
    ].
    (type == 6) ifTrue:[
	"0/0  1/0  2/0
	      1/1     "
	slots at:1 put:(0 @ 0).
	slots at:2 put:(1 @ 0).
	slots at:3 put:(2 @ 0).
	slots at:4 put:(1 @ 1).
	^ self 
    ].
    self error:'unsupported type'
! !

!Tetris::TetrisBlock methodsFor:'queries'!

hits:aPoint
    slots do:[:p |
	((p + origin) = aPoint) ifTrue:[^ true]
    ].
    ^ false
!

maxX
    |max x|

    max := -9999.
    slots do:[:aPoint |
	x := aPoint x.
	(x > max) ifTrue:[
	    max := x
	]
    ].
    ^ max
!

maxY
    |max y|

    max := -9999.
    slots do:[:aPoint |
	y := aPoint y.
	y > max ifTrue:[
	    max := y
	]
    ].
    ^ max
!

minX
    |min x|

    min := 9999.
    slots do:[:aPoint |
	x := aPoint x.
	x < min ifTrue:[
	    min := x
	]
    ].
    ^ min
!

minY
    |min y|

    min := 9999.
    slots do:[:aPoint |
	y := aPoint y.
	y < min ifTrue:[
	    min := y
	]
    ].
    ^ min
! !

!Tetris::TetrisBlock methodsFor:'visible moving'!

moveDownIn:aView
    self clearIn:aView.
    self moveDown.
    self drawIn:aView
!

moveLeftIn:aView
    self clearIn:aView.
    self moveLeft.
    self drawIn:aView
!

moveRightIn:aView
    self clearIn:aView.
    self moveRight.
    self drawIn:aView
!

rotateLeftIn:aView
    self clearIn:aView.
    self rotateLeft.
    self drawIn:aView
!

rotateRightIn:aView
    self clearIn:aView.
    self rotateRight.
    self drawIn:aView
! !

!Tetris class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Tetris/Tetris.st,v 1.18 2006-10-10 15:14:01 stefan Exp $'
! !
