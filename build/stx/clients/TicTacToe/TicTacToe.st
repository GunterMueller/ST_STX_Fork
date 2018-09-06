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


"{ Package: 'stx:clients/TicTacToe' }"

"{ NameSpace: Games }"

StandardSystemView subclass:#TicTacToe
	instanceVariableNames:'board circleForm gameOver player winner box gamesPlayed oColor
		xColor winColor'
	classVariableNames:''
	poolDictionaries:''
	category:'games-TicTacToe'
!

!TicTacToe class methodsFor:'documentation'!

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
    This is a very old version of the TicTacToe game;
    all game playing and displaying is contained in this
    single view class.
    This may make it easier to understand, however, it makes
    it difficult to extent the game for two user playing.

    See TicTacToeGame/TicTacToeView/TicTacToePlayer for a better
    structured version.
    See both solutions side-by-side and learn from it ...

    [see also:]
        TicTacToeGame TicTacToeView

    [author:]
        Claus Gittinger

    [start with:]
        Games::TicTacToe open
"

! !

!TicTacToe class methodsFor:'queries'!

isVisualStartable

    ^ true
! !

!TicTacToe class methodsFor:'startup'!

open
    |newGame|

    newGame := self label:'Tic Tac Toe'.
    newGame icon:(Image fromFile:'TicTacToe.xbm' resolution:100).
    newGame open.
    ^ newGame

    "
     TicTacToe open
    "

    "Modified: 9.5.1996 / 12:51:56 / cg"
! !

!TicTacToe methodsFor:'accessing'!

boardAtRow:row col:col
    ^ board at:(((row - 1) * 3) + col)
!

boardAtRow:row col:col put:something
    board at:(((row - 1) * 3) + col) put:something
! !

!TicTacToe methodsFor:'events'!

buttonPress:button x:x y:y
    "when user presses a button, check for valid field,
     place, check if game is over, make my next move,
     and check if game is over again"

    |row col hspace vspace s|

    gameOver ifTrue:[gameOver printNewline. ^ self].

    vspace := height // 3.
    hspace := width // 3.

    row := y // vspace + 1.
    col := x // hspace + 1.

    (row < 1) ifTrue:[^ self].
    (col < 1) ifTrue:[^ self].
    (row > 3) ifTrue:[^ self].
    (col > 3) ifTrue:[^ self].

    self checkGameFinished.
    gameOver ifFalse:[
	(self boardAtRow:row col:col) isNil ifTrue:[
	    self boardAtRow:row col:col put:#O.
	    self redrawRow:row col:col.
	    self checkGameFinished:#O.
	    self checkGameFinished.
	    gameOver ifFalse:[
		self playNext:#X.
		self checkGameFinished:#X.
		self checkGameFinished
	    ]
	]
    ].
    gameOver ifTrue:[
	self showGameOver
    ]

    "Created: 18.9.1995 / 11:26:59 / claus"
! !

!TicTacToe methodsFor:'initialization'!

initialize
    super initialize.

    self extent:(80 * device pixelPerMillimeter) asInteger.

    board := Array new:9.
    self enableButtonEvents.
    gameOver := true.
    winner := nil.
    viewBackground := Color white.

    device hasColors ifTrue:[
	oColor := Color red.
	xColor := Color blue.
	winColor := Color red:0 green:50 blue:0.
    ] ifFalse:[
	oColor := xColor := Color black.
	winColor := Color veryLightGrey.
    ].

    self askWhoStarts

    "Created: 18.9.1995 / 11:17:42 / claus"
! !

!TicTacToe methodsFor:'misc'!

askWhoStarts 
    box := YesNoBox title:'TicTacToe: Do you want to start ?'.
    box yesAction:[gameOver := false. player := #O]
	 noAction:[gameOver := false. player := #X. self playNext:#X].
    box showAtPointer

    "Created: 18.9.1995 / 11:17:31 / claus"
!

showGameOver
    |s|

    gameOver ifTrue:[
	(winner == #X) ifTrue:[
	    s := 'I win !!\another game ?'
	] ifFalse:[
	    (winner == #O) ifTrue:[
		s := 'You win !!\another game ?'
	    ] ifFalse:[
		s := 'no winner !!\another game ?'
	    ]
	].
	box title:s withCRs.
	box yesAction:[self newGame]
	     noAction:[self destroy].
	box showAtPointerNotCovering:self
    ]

    "Created: 18.9.1995 / 11:25:23 / claus"
! !

!TicTacToe methodsFor:'next move decision'!

canFillCol:who

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a row can be filled"
    1 to:3 do:[:col |
      1 to:3 do:[:row |
	pattern at:row put:nil.
	((self boardAtRow:1 col:col) == (pattern at:1)) ifTrue:[
	  ((self boardAtRow:2 col:col) == (pattern at:2)) ifTrue:[
	    ((self boardAtRow:3 col:col) == (pattern at:3)) ifTrue:[
		^ col
	    ]
	  ]
	].
	pattern at:row put:who
      ]
    ].
    ^ nil
!

canFillDiag1:who

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:3 do:[:x |
      pattern at:x put:nil.
      ((self boardAtRow:1 col:1) == (pattern at:1)) ifTrue:[
	((self boardAtRow:2 col:2) == (pattern at:2)) ifTrue:[
	  ((self boardAtRow:3 col:3) == (pattern at:3)) ifTrue:[
	      ^ 1
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil
!

canFillDiag2:who

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:3 do:[:x |
      pattern at:x put:nil.
      ((self boardAtRow:1 col:3) == (pattern at:1)) ifTrue:[
	((self boardAtRow:2 col:2) == (pattern at:2)) ifTrue:[
	  ((self boardAtRow:3 col:1) == (pattern at:3)) ifTrue:[
	      ^ 1
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil
!

canFillRow:who

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a row can be filled"
    1 to:3 do:[:row |
      1 to:3 do:[:col |
	pattern at:col put:nil.
	((self boardAtRow:row col:1) == (pattern at:1)) ifTrue:[
	  ((self boardAtRow:row col:2) == (pattern at:2)) ifTrue:[
	    ((self boardAtRow:row col:3) == (pattern at:3)) ifTrue:[
		^ row
	    ]
	  ]
	].
	pattern at:col put:who
      ]
    ].
    ^ nil
!

diag1Has2EmptySlotsAnd:who

    |countWho countEmpty x|

    countWho := 0.
    countEmpty := 0.
    1 to:3 do:[:i |
	x := self boardAtRow:i col:i.
	(x == who) ifTrue:[
	    countWho := countWho + 1
	] ifFalse:[
	    x isNil ifTrue:[
		countEmpty := countEmpty + 1
	    ]
	]
    ].
    (countWho == 1) ifTrue:[
	(countEmpty == 2) ifTrue:[
	    ^ true
	]
    ].
    ^ false
!

diag2Has2EmptySlotsAnd:who

    |countWho countEmpty x|

    countWho := 0.
    countEmpty := 0.
    1 to:3 do:[:i |
	x := self boardAtRow:i col:(4 - i).
	(x == who) ifTrue:[
	    countWho := countWho + 1
	] ifFalse:[
	    x isNil ifTrue:[
		countEmpty := countEmpty + 1
	    ]
	]
    ].
    (countWho == 1) ifTrue:[
	(countEmpty == 2) ifTrue:[
	    ^ true
	]
    ].
    ^ false
!

findColWith2EmptySlotsAnd:who

    |countWho countEmpty x|

    1 to:3 do:[:col |
	countWho := 0.
	countEmpty := 0.
	1 to:3 do:[:row |
	    x := self boardAtRow:row col:col.
	    (x == who) ifTrue:[
		countWho := countWho + 1
	    ] ifFalse:[
		x isNil ifTrue:[
		    countEmpty := countEmpty + 1
		]
	    ]
	].
	(countWho == 1) ifTrue:[
	    (countEmpty == 2) ifTrue:[
		^ col
	    ]
	]
    ].
    ^ nil
!

findRowWith2EmptySlotsAnd:who

    |countWho countEmpty x|

    1 to:3 do:[:row |
	countWho := 0.
	countEmpty := 0.
	1 to:3 do:[:col |
	    x := self boardAtRow:row col:col.
	    (x == who) ifTrue:[
		countWho := countWho + 1
	    ] ifFalse:[
		x isNil ifTrue:[
		    countEmpty := countEmpty + 1
		]
	    ]
	].
	(countWho == 1) ifTrue:[
	    (countEmpty == 2) ifTrue:[
		^ row
	    ]
	]
    ].
    ^ nil
! !

!TicTacToe methodsFor:'playing'!

checkGameFinished
    "check if game is finished because no more fields are empty;
     i.e. check if there is any nil field"

    1 to:3 do:[:row |
	1 to:3 do:[:col |
	    (self boardAtRow:row col:col) isNil ifTrue:[^ false]
	]
    ].
    gameOver := true.
    ^ true

    "Created: 18.9.1995 / 11:11:54 / claus"
!

checkGameFinished:who
    "check if 'who' has finished the game because 3 fields are
     filled in a row of his color"

    "check rows"
    1 to:3 do:[:row |
	((self boardAtRow:row col:1) == who) ifTrue:[
	  ((self boardAtRow:row col:2) == who) ifTrue:[
	    ((self boardAtRow:row col:3) == who) ifTrue:[
		winner := who.
		gameOver := true.
		self showWinningLine:(1 @ row) to:(3 @ row).
		^ self
	    ]
	  ]
	]
    ].

    "check cols"
    1 to:3 do:[:col |
	((self boardAtRow:1 col:col) == who) ifTrue:[
	  ((self boardAtRow:2 col:col) == who) ifTrue:[
	    ((self boardAtRow:3 col:col) == who) ifTrue:[
		winner := who.
		gameOver := true.
		self showWinningLine:(col @ 1) to:(col @ 3).
		^ self
	    ]
	  ]
	]
    ].

    "check diagonals"
    ((self boardAtRow:1 col:1) == who) ifTrue:[
      ((self boardAtRow:2 col:2) == who) ifTrue:[
	((self boardAtRow:3 col:3) == who) ifTrue:[
	    winner := who.
	    gameOver := true.
	    self showWinningLine:(1 @ 1) to:(3 @ 3).
	    ^ self
	]
      ]
    ].
    ((self boardAtRow:1 col:3) == who) ifTrue:[
      ((self boardAtRow:2 col:2) == who) ifTrue:[
	((self boardAtRow:3 col:1) == who) ifTrue:[
	    winner := who.
	    gameOver := true.
	    self showWinningLine:(3 @ 1) to:(1 @ 3).
	    ^ self
	]
      ]
    ]

    "Created: 18.9.1995 / 11:12:30 / claus"
!

newGame
    "start a new game; clear board and swap players"

    gameOver := false.
    winner := nil.
    board atAllPut:nil.
    self clear.
    self redraw.

    (player == #O) ifTrue:[
	player := #X.
	self playNext:#X
    ] ifFalse:[
	player := #O
    ]

    "Created: 18.9.1995 / 11:13:23 / claus"
!

play:who col:col
    "place any field in a column for player 'who'"

    #(1 3 2) do:[:row |
	(self boardAtRow:row col:col) isNil ifTrue:[
	    self play:who row:row col:col.
	    ^ row
	]
    ]

    "Created: 18.9.1995 / 11:14:08 / claus"
!

play:who row:row
    "place any field in a row for player 'who'"

    #(1 3 2) do:[:col |
	(self boardAtRow:row col:col) isNil ifTrue:[
	    self play:who row:row col:col.
	    ^ col
	]
    ]

    "Created: 18.9.1995 / 11:14:16 / claus"
!

play:who row:row col:col
    "place at row/col for player 'who'"

    self boardAtRow:row col:col put:who.
    self redrawRow:row col:col

    "Created: 18.9.1995 / 11:14:53 / claus"
!

playDiag1:who
    "place any field in the first diagonal for player 'who'"

    #(1 3 2) do:[:x |
	(self boardAtRow:x col:x) isNil ifTrue:[
	    self play:who row:x col:x.
	    ^ x
	]
    ]

    "Created: 18.9.1995 / 11:14:31 / claus"
!

playDiag2:who
    "place any field in the second diagonal for player 'who'"

    #(1 3 2) do:[:x |
	(self boardAtRow:x col:(4 - x)) isNil ifTrue:[
	    self play:who row:x col:(4 - x).
	    ^ x
	]
    ]

    "Created: 18.9.1995 / 11:14:38 / claus"
!

playNext:who
    "determine the next move for player 'who'"

    |row col other|

    "try if I can win"
    row := self canFillRow:who.
    row notNil ifTrue:[
	self play:who row:row.
	^ self
    ].
    col := self canFillCol:who.
    col notNil ifTrue:[
	self play:who col:col.
	^ self
    ].
    (self canFillDiag1:who) notNil ifTrue:[
	self playDiag1:who.
	^ self
    ].
    (self canFillDiag2:who) notNil ifTrue:[
	self playDiag2:who.
	^ self
    ].

    (who == #X) ifTrue:[
	other := #O
    ] ifFalse:[
	other := #X
    ].

    "try to prevent other from winning"
    row := self canFillRow:other.
    row notNil ifTrue:[
	self play:who row:row.
	^ self
    ].
    col := self canFillCol:other.
    col notNil ifTrue:[
	self play:who col:col.
	^ self
    ].
    (self canFillDiag1:other) notNil ifTrue:[
	self playDiag1:who.
	^ self
    ].
    (self canFillDiag2:other) notNil ifTrue:[
	self playDiag2:who.
	^ self
    ].

    "if other has a row/col with 2 empty slots - play there"

    row := self findRowWith2EmptySlotsAnd:other.
    row notNil ifTrue:[
	col := self findColWith2EmptySlotsAnd:other.
	col notNil ifTrue:[
	    (self boardAtRow:row col:col) isNil ifTrue:[
		self play:who row:row col:col.
		^ self
	    ]
	]
    ].

    "no winning chance - find a row with 1 of mine, 2 empty slots"
    row := self findRowWith2EmptySlotsAnd:who.
    row notNil ifTrue:[
	"if row intersects a col with 2 empty slots, take it"
	col := self findColWith2EmptySlotsAnd:who.
	col notNil ifTrue:[
	    (self boardAtRow:row col:col) isNil ifTrue:[
		self play:who row:row col:col.
		^ self
	    ]
	].
	self play:who row:row.
	^ self
    ].

    col := self findColWith2EmptySlotsAnd:who.
    col notNil ifTrue:[
	self play:who col:col.
	^ self
    ].

    (self diag1Has2EmptySlotsAnd:who) ifTrue:[
	self playDiag1:who.
	^ self
    ].
    (self diag2Has2EmptySlotsAnd:who) ifTrue:[
	self playDiag2:who.
	^ self
    ].

    "rest ist heuristic ..."

    "center position is best"
    (self boardAtRow:2 col:2) isNil ifTrue:[
	self play:who row:2 col:2.
	^ self
    ].

    "then corners"
    (self boardAtRow:1 col:1) isNil ifTrue:[
	self play:who row:1 col:1.
	^ self
    ].
    (self boardAtRow:1 col:3) isNil ifTrue:[
	self play:who row:1 col:3.
	^ self
    ].
    (self boardAtRow:3 col:1) isNil ifTrue:[
	self play:who row:3 col:1.
	^ self
    ].
    (self boardAtRow:3 col:3) isNil ifTrue:[
	self play:who row:3 col:3.
	^ self
    ].

    "any free slot"
    1 to:3 do:[:row |
	1 to:3 do:[:col |
	    (self boardAtRow:row col:col) isNil ifTrue:[
		self play:who row:row col:col.
		^ self
	    ]
	]
    ].

    ^ self

    "Created: 18.9.1995 / 11:15:16 / claus"
! !

!TicTacToe methodsFor:'redrawing'!

drawOIn:rect
    "draw a circle;
     Since some x-servers are slow circle drawers - I keep the circle
     in a form and draw the form .."

    |lw lw2|

    device isSlow ifFalse:[
	"/
	"/ actually, what we want to do is:
	"/

	self paint:oColor on:viewBackground.
	lw := device horizontalPixelPerMillimeter rounded asInteger.
	self lineWidth:lw.
	self displayCircleIn:rect.
    ] ifTrue:[
	"/
	"/ on some slow X-terminals, drawing a circle takes seconds
	"/ there, we should do:
	"/

	circleForm notNil ifTrue:[
	    ((rect width ~~ circleForm width) 
	     or:[rect height ~~ circleForm height]) ifTrue:[
		circleForm := nil
	    ]
	].
	circleForm isNil ifTrue:[
	    circleForm := Form width:(rect width)
			      height:(rect height)
			       depth:1
				  on:device.
	    circleForm paint:(Color colorId:0).
	    circleForm fillRectangleX:0 y:0 width:(rect width)
					   height:(rect height).
	    circleForm paint:(Color colorId:1).
	    lw := device horizontalPixelPerMillimeter rounded asInteger.
	    lw2 := lw // 2.

	    circleForm lineWidth:lw.
	    circleForm displayCircleIn:
		       ((lw2 @ lw2) extent:
			(circleForm extent - (lw @ lw)))
	].

	self paint:oColor on:viewBackground.
	self displayOpaqueForm:circleForm x:(rect origin x) 
					  y:(rect origin y)
    ]

    "Created: 18.9.1995 / 11:23:18 / claus"
!

drawXIn:aRectangle
    "draw an X"

    self paint:xColor on:viewBackground.
    self displayLineFrom:(aRectangle origin) to:(aRectangle corner).
    self displayLineFrom:(aRectangle topRight) to:(aRectangle bottomLeft)

    "Created: 18.9.1995 / 11:23:45 / claus"
!

redraw
    "redraw everything"

    |who hspace vspace x y rect|

    vspace := height // 3.
    hspace := width // 3.

    self redrawGrid.

    y := 0.
    1 to:3 do:[:row |
	x := 0.
	1 to:3 do:[:col |
	    who := self boardAtRow:row col:col.
	    who notNil ifTrue:[
		rect := ((x + 5) @ (y + 5)) 
			extent:
			((hspace - 10) @ (vspace - 10)).
		(who == #O) ifTrue:[
		    self drawOIn:rect
		] ifFalse:[
		    self drawXIn:rect
		]
	    ].
	    x := x + hspace
	].
	y := y + vspace
    ]

    "Created: 18.9.1995 / 11:23:56 / claus"
!

redrawGrid
    "redraw the grid only; the view is assumed to be
     cleared (to background) already."

    |hspace vspace|

    vspace := height // 3.
    hspace := width // 3.

    "draw the grid"

    self lineWidth:(device horizontalPixelPerMillimeter rounded asInteger).
    self paint:Black.
    self displayLineFromX:hspace y:0 toX:hspace y:height.
    self displayLineFromX:(hspace * 2) y:0 toX:(hspace * 2) y:height.
    self displayLineFromX:0 y:vspace toX:width y:vspace.
    self displayLineFromX:0 y:(vspace * 2) toX:width y:(vspace * 2)

    "Created: 18.9.1995 / 11:24:23 / claus"
!

redrawRow:row col:col
    |who hspace vspace x y rect lw lw2 lw4|

    realized ifFalse:[^ self].

    lw := device horizontalPixelPerMillimeter rounded asInteger.
    lw2 := lw * 2.
    lw4 := lw * 4.

    vspace := height // 3.
    hspace := width // 3.

    y := (row - 1) * vspace.
    x := (col - 1) * hspace.
    who := self boardAtRow:row col:col.
    who notNil ifTrue:[
	rect := ((x + lw) @ (y + lw)) 
		extent:
		((hspace - lw2) @ (vspace - lw2)).
	self paint:viewBackground.
	self fillRectangle:rect.
	rect := ((x + lw2) @ (y + lw2)) 
		extent:
		((hspace - lw4) @ (vspace - lw4)).
	(who == #O) ifTrue:[
	    self drawOIn:rect
	] ifFalse:[
	    self drawXIn:rect
	]
    ]
!

showWinningLine:p1 to:p2
    |hspace vspace red|

    vspace := height // 3.
    hspace := width // 3.

    "draw the grid"

    self lineWidth:(device horizontalPixelPerMillimeter rounded asInteger).
    self paint:winColor.
    self displayLineFromX:((p1 x - 1) * hspace + (hspace // 2)) 
			y:((p1 y - 1) * vspace + (vspace // 2))
		      toX:((p2 x - 1) * hspace + (hspace // 2))
			y:((p2 y - 1) * vspace + (vspace // 2))
! !

!TicTacToe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe/TicTacToe.st,v 1.9 2002-11-19 17:02:07 stefan Exp $'
! !
