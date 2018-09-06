"
    COPYRIGHT (c) 1995 by Claus Gittinger
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

StandardSystemView subclass:#TicTacToeView
	instanceVariableNames:'circleForm player oColor xColor winColor expectInput isSlaveView'
	classVariableNames:''
	poolDictionaries:''
	category:'games-TicTacToe'
!

!TicTacToeView class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1995 by Claus Gittinger
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
    This is a restructured version of the TicTacToe class;
    and provided for didactic reasons, to see the difference between
    a non-well-written version (TicTacToe) and a better structured
    one (TicTacToeView / TicTacToeGame and TicTacToePlayer).

    See TicTacToe for a less structured (single user only) version.
    See both solutions side-by-side and learn from it ...


    Instances of TicTacToeView know how to repsent a TicTacToe
    games board. 
    The connection to it is via the dependency mechanism (i.e. 
    the game is my model). See the update method for interaction from
    the game (model).
    This allows multiple views to show a single game (multi-display
    operation).


    [see also:]
        TicTacToeGame TicTacToePlayer
        TicTacToe

    [author:]
        Claus Gittinger

    [start with:]
        Games::TicTacToeGame open
        Games::TicTacToeGame open2UserGame
"


! !

!TicTacToeView methodsFor:'accessing'!

beSlaveView
    isSlaveView := true

    "Created: 18.9.1995 / 11:49:04 / claus"
    "Modified: 19.9.1995 / 00:12:30 / claus"
!

playing:XorO 
    player := XorO

    "Created: 18.9.1995 / 11:49:04 / claus"
    "Modified: 18.9.1995 / 15:33:24 / claus"
! !

!TicTacToeView methodsFor:'events'!

buttonPress:button x:x y:y
    "when user presses a button, check for valid field,
     place, check if game is over, make my next move,
     and check if game is over again"

    |row col hspace vspace s|

    model gameOver ifTrue:[^ self].
    expectInput ifFalse:[^ self].

    vspace := height // 3.
    hspace := width // 3.

    row := y // vspace + 1.
    col := x // hspace + 1.

    (row < 1) ifTrue:[^ self].
    (col < 1) ifTrue:[^ self].
    (row > 3) ifTrue:[^ self].
    (col > 3) ifTrue:[^ self].

    model userPlay:player row:row col:col.

    "Created: 18.9.1995 / 11:26:59 / claus"
    "Modified: 18.9.1995 / 13:39:31 / claus"
!

update:something with:aParameter from:changedObject
    "something changed in the game - see what"

    |l|

    something == #player ifTrue:[
        "/ current player ...

        model currentPlayer == player ifTrue:[
            "/ its my turn
            self cursor:Cursor normal.
            expectInput := true.
            self label:'TicTacToe: your turn'.
        ] ifFalse:[
            "/ others turn
            self cursor:Cursor stop.
            expectInput := false.
            self label:'TicTacToe: others turn'.
        ].
        ^ self
    ].

    shown ifFalse:[^ self].

    something == #board ifTrue:[
        "/ board changed
        self clear.
        self redraw.
        ^ self
    ].
    something == #field: ifTrue:[
        "/ some field changed
        self redrawRow:(aParameter y) col:(aParameter x).
        ^ self
    ].
    something == #gameOver ifTrue:[
        "/ game is over
        self sensor pushUserEvent:#showGameOver for:self.
        ^ self
    ].
    something == #gameFinished ifTrue:[
        "/ game was finished
        self sensor pushUserEvent:#showGameFinished for:self.
        ^ self
    ].
    something == #winner ifTrue:[
        "/ winner is known
        l := model winningLine.
        self showWinningLine:l key to:l value.
        ^ self
    ].

    "Created: 18.9.1995 / 11:26:59 / claus"
    "Modified: 19.9.1995 / 00:05:04 / claus"
    "Modified: 26.6.1997 / 20:36:43 / cg"
! !

!TicTacToeView methodsFor:'initialization'!

destroy
    model removeDependent:self.
    model notNil ifTrue:[model gameFinished:true].
    super destroy.

    "Created: 18.9.1995 / 11:17:42 / claus"
    "Modified: 18.9.1995 / 23:42:41 / claus"
!

initialize
    super initialize.

    self extent:(80 * device pixelPerMillimeter) asInteger.

    self enableButtonEvents.
    expectInput := false.

    viewBackground := Color white.

    device hasColors ifTrue:[
        oColor := Color red.
        xColor := Color blue.
        winColor := Color red:0 green:50 blue:0.
    ] ifFalse:[
        oColor := xColor := Color black.
        winColor := Color veryLightGrey.
    ].
    oColor := oColor onDevice:device.
    xColor := xColor onDevice:device.
    winColor := winColor onDevice:device.

    self cursor:Cursor stop

    "Created: 18.9.1995 / 11:17:42 / claus"
    "Modified: 18.9.1995 / 19:26:52 / claus"
! !

!TicTacToeView methodsFor:'misc'!

showGameFinished
    |box|

    model gameFinished ifTrue:[
	box := InfoBox onDevice:device.
	box title:'game finished by other player'.
	box showAtPointerNotCovering:self.
	self destroy.
	^ self
    ].

    "Created: 18.9.1995 / 11:25:23 / claus"
    "Modified: 18.9.1995 / 23:52:28 / claus"
!

showGameOver
    |s box winner|

    model gameOver ifTrue:[

        winner := model winner.
        winner isNil ifTrue:[
            s := 'no winner !!\another game ?'
        ] ifFalse:[
            winner == player ifTrue:[
                s := 'You win !!\another game ?'
            ] ifFalse:[
                s := 'You loose !!\another game ?'
            ]
        ].

        box := YesNoBox onDevice:self device.
        box title:s withCRs.
        box yesAction:["/ model gameFinished ifTrue:[
                       "/      self showGameFinished
                       "/ ] ifFalse:[
                            model newGame
                       "/ ]
                      ]
             noAction:[self destroy].
        box showAtPointerNotCovering:self.
    ]

    "Created: 18.9.1995 / 11:25:23 / claus"
    "Modified: 19.9.1995 / 11:48:41 / claus"
    "Modified: 26.6.1997 / 19:37:14 / cg"
! !

!TicTacToeView methodsFor:'redrawing'!

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
    "Modified: 18.9.1995 / 11:43:51 / claus"
!

drawXIn:aRectangle
    "draw an X"

    self paint:xColor on:viewBackground.
    self displayLineFrom:(aRectangle origin) to:(aRectangle corner).
    self displayLineFrom:(aRectangle topRight) to:(aRectangle bottomLeft)

    "Created: 18.9.1995 / 11:23:45 / claus"
    "Modified: 18.9.1995 / 11:43:52 / claus"
!

redraw
    "redraw everything"

    |l|

    self redrawGrid.

    1 to:3 do:[:row |
	1 to:3 do:[:col |
	    self redrawRow:row col:col
	].
    ].
    (l := model winningLine) notNil ifTrue:[
	self showWinningLine:(l key) to:(l value).
    ].

    "Created: 18.9.1995 / 11:23:56 / claus"
    "Modified: 18.9.1995 / 15:27:37 / claus"
!

redrawGrid
    "redraw the grid only; the view is assumed to be
     cleared (to background) already."

    |hspace vspace|

    shown ifFalse:[^ self].

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
    "Modified: 18.9.1995 / 15:28:28 / claus"
!

redrawRow:row col:col
    |who hspace vspace x y rect lw lw2 lw4|

    shown ifFalse:[^ self].

    lw := device horizontalPixelPerMillimeter rounded asInteger.
    lw2 := lw * 2.
    lw4 := lw * 4.

    vspace := height // 3.
    hspace := width // 3.

    y := (row - 1) * vspace.
    x := (col - 1) * hspace.
    who := model boardAtRow:row col:col.
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

    "Created: 18.9.1995 / 11:43:51 / claus"
    "Modified: 18.9.1995 / 15:28:11 / claus"
!

showWinningLine:p1 to:p2
    |hspace vspace red|

    shown ifFalse:[^ self].

    vspace := height // 3.
    hspace := width // 3.

    "draw the grid"

    self lineWidth:(device horizontalPixelPerMillimeter rounded asInteger).
    self paint:winColor.
    self displayLineFromX:((p1 x - 1) * hspace + (hspace // 2)) 
			y:((p1 y - 1) * vspace + (vspace // 2))
		      toX:((p2 x - 1) * hspace + (hspace // 2))
			y:((p2 y - 1) * vspace + (vspace // 2))

    "Created: 18.9.1995 / 11:43:52 / claus"
    "Modified: 18.9.1995 / 15:28:41 / claus"
! !

!TicTacToeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe/TicTacToeView.st,v 1.11 2002-11-19 17:03:56 stefan Exp $'
! !
