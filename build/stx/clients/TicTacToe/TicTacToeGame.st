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

Model subclass:#TicTacToeGame
	instanceVariableNames:'board gameOver gameFinished winner winningLine beginner
		currentPlayer'
	classVariableNames:''
	poolDictionaries:''
	category:'games-TicTacToe'
!

!TicTacToeGame class methodsFor:'documentation'!

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
    one (TicTacToeView / Game and Player).

    See TicTacToe for a less structured (single user only) version.
    See both solutions side-by-side and learn from it ...


    The games actions has been separated into 3 different areas
    (i.e. Model-View separation):

        displaying 
                - done by TicTacToeView, which gets notified
                  by its model, an instance of TicTacToeGame.
                  There can be an arbitrary number of views
                  displaying the board simultaneously.

        managing turns,
        managing the board and
        notifying players
                - done by TicTacToeGame, which is a model for
                  the views.
                  TicTacToeGame does not itself know about how
                  to play - however, it knows the rules for game
                  over, and how to let two players play alternatively

        playing,
        choosing a move
                - done by TicTacToePlayer, or the user

    With this separation, it is now very easy, to implement both
    user/user playing and user/computer playing.
    In the first case, two views are setup on two displays,
    alternating entry-permission  between them.
    In the second case, one part is done by an instance of TicTacToePlayer.

    Communication from the Game to its players and views is via
    change messages (the model does not know who is playing).
    between these objects is via change messages;


    [see also:]
        TicTacToeView
        TicTacToe

    [author:]
        Claus Gittinger

    [start with:]
        Games::TicTacToeGame open
        Games::TicTacToeGame open2UserGame
"

! !

!TicTacToeGame class methodsFor:'startup'!

isVisualStartable

    ^ true
!

open
    |gameView game computerPlayer|

    game := self new initialize.

    "/ computerPlayer := TicTacToePlayer new.
    computerPlayer := NewTicTacToePlayer new.
    computerPlayer game:game playing:#X.

    gameView := TicTacToeView label:'Tic Tac Toe'.
    gameView extent:300@300.
    gameView icon:(Image fromFile:'bitmaps/TicTacToe.xbm' resolution:100).

    gameView model:game.
    gameView playing:#O.

    game askWhoStartsIn:gameView.

    gameView open.

    "
     TicTacToeGame open
    "
!

open2UserGame
    |gameView1 gameView2 game displayName otherDisplay icon|

    displayName := Dialog request:'Other player on which X11 host ?' initialAnswer:'hostName:0'.
    (displayName isNil or:[displayName isEmpty]) ifTrue:[
        ^ self
    ].

    [ 
        otherDisplay := otherDisplay initializeFor:displayName.
    ] on:otherDisplay deviceErrorSignal do:[
        self warn:('Could not open display: ' , displayName).
        ^ nil.
    ].
    otherDisplay startDispatch.

    icon := Image fromFile:'TicTacToe.xbm' resolution:100.

    game := self new initialize.

    gameView1 := TicTacToeView label:'Tic Tac Toe'.
    gameView1 extent:300@300.
    gameView1 icon:icon.
    gameView1 model:game.
    gameView1 playing:#X.

    gameView2 := TicTacToeView onDevice:otherDisplay.
    gameView2 label:'Tic Tac Toe'.
    gameView2 extent:300@300.
    gameView2 icon:icon.
    gameView2 model:game.
    gameView2 playing:#O.
    gameView2 beSlaveView.

    game askWhoStartsIn:gameView1 and:gameView2.

    "
     TicTacToeGame open2UserGame
    "

    "Modified: 19.9.1995 / 11:33:32 / claus"
    "Modified: 25.2.1997 / 11:40:23 / cg"
! !

!TicTacToeGame methodsFor:'accessing'!

board
    ^ board
!

board:aBoard atRow:row col:col
    "return aBoards value at row/col"

    ^ aBoard at:(((row - 1) * 3) + col)
!

board:aBoard atRow:row col:col put:something
    "set aBoards value at row/col"

    aBoard at:(((row - 1) * 3) + col) put:something.
!

boardAtRow:row col:col
    "return the boards value at row/col"

    ^ self board:board atRow:row col:col

    "Created: 18.9.1995 / 11:31:23 / claus"
!

boardAtRow:row col:col put:something
    "set the boards value at row/col"

    self board:board atRow:row col:col put:something.
    self changed:#field: with:(col @ row)

    "Created: 18.9.1995 / 11:31:23 / claus"
    "Modified: 18.9.1995 / 11:55:25 / claus"
!

currentPlayer 
    ^ currentPlayer

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 15:59:46 / claus"
!

gameFinished
    ^ gameFinished

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 23:41:54 / claus"
!

gameFinished:aBoolean
    gameFinished := gameOver := aBoolean.
    self changed:#gameFinished

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 23:46:42 / claus"
!

gameOver
    ^ gameOver

    "Created: 18.9.1995 / 11:41:18 / claus"
!

gameOver:aBoolean
    gameOver := aBoolean.
    self changed:#gameOver

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 14:41:26 / claus"
!

winner 
    ^ winner

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 11:43:23 / claus"
!

winningLine 
    ^ winningLine

    "Created: 18.9.1995 / 11:41:18 / claus"
    "Modified: 18.9.1995 / 12:27:25 / claus"
! !

!TicTacToeGame methodsFor:'initialization'!

askWhoStartsIn:aView
    |answer|

    beginner := nil. 
    self newGame. 

    answer := (YesNoBox confirm:'TicTacToe: Do you want to start ?').
    answer ifTrue:[
	beginner := #O.
    ] ifFalse:[
	beginner := #X. 
    ].
    currentPlayer := beginner.
    self changed:#player.

    "Created: 18.9.1995 / 11:17:31 / claus"
    "Modified: 18.9.1995 / 16:01:01 / claus"
!

askWhoStartsIn:view1 and:view2
    |answer box1 box2|

    beginner := nil. 
    self newGame.

    view1 device ~~ view2 device ifTrue:[
        box1 := DialogBox onDevice:view2 device.
        box1 addTextLabel:'TicTacToe: You play O''s.\\Waiting for other player to choose beginner ...' withCRs.
        box1 openModelessAtCenter.
    ].

    box2 := YesNoBox onDevice:(view1 device).

    answer := box2 confirm:'TicTacToe: You play X''s, do you want to start ?'.
    answer ifTrue:[
        currentPlayer := #X. 
    ] ifFalse:[
        currentPlayer := #O. 
    ].

    "/ must make certain that views are opened
    "/ BEFORE closing the dialog box.
    "/ otherwise, the other device thinks its finished and
    "/ shuts down ....

    view1 openAndWait.
    view2 openAndWait.

    view1 device ~~ view2 device ifTrue:[
        box1 destroy.
    ].

    self changed:#player.

    "Created: 18.9.1995 / 11:17:31 / claus"
    "Modified: 19.9.1995 / 11:35:13 / claus"
    "Modified: 25.2.1997 / 11:41:51 / cg"
!

initialize
    super initialize.

    board := Array new:9.
    gameFinished := false.
    self newGame

    "Created: 18.9.1995 / 11:31:05 / claus"
    "Modified: 18.9.1995 / 23:38:27 / claus"
! !

!TicTacToeGame methodsFor:'playing'!

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
    "Modified: 18.9.1995 / 11:37:34 / claus"
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
		winningLine := (1 @ row) -> (3 @ row).
		self changed:#winner.
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
		winningLine := (col @ 1) -> (col @ 3).
		self changed:#winner.
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
	    winningLine := (1 @ 1) -> (3 @ 3).
	    self changed:#winner.
	    ^ self
	]
      ]
    ].
    ((self boardAtRow:1 col:3) == who) ifTrue:[
      ((self boardAtRow:2 col:2) == who) ifTrue:[
	((self boardAtRow:3 col:1) == who) ifTrue:[
	    winner := who.
	    gameOver := true.
	    winningLine := (3 @ 1) -> (1 @ 3).
	    self changed:#winner.
	    ^ self
	]
      ]
    ]

    "Created: 18.9.1995 / 11:12:30 / claus"
    "Modified: 18.9.1995 / 12:30:35 / claus"
!

newGame
    "start a new game; clear board and swap beginner"

    gameOver := false.
    winner := nil.
    winningLine := nil.
    board atAllPut:nil.
    self changed:#board.

    "/ swap beginner
    beginner notNil ifTrue:[
	self swapBeginner.
	currentPlayer := beginner.
	self changed:#player.
    ].

    "Created: 18.9.1995 / 11:13:23 / claus"
    "Modified: 18.9.1995 / 16:00:40 / claus"
!

swapBeginner
    "swap beginner"

    beginner == #X ifTrue:[
	beginner := #O
    ] ifFalse:[
	beginner := #X
    ]

    "Created: 18.9.1995 / 15:31:32 / claus"
!

userPlay:who row:row col:col
    "user plays"

    self checkGameFinished.
    gameOver ifFalse:[
        (self boardAtRow:row col:col) isNil ifTrue:[
            self boardAtRow:row col:col put:who.

            self checkGameFinished:who.
            self checkGameFinished.
            gameOver ifTrue:[
                self changed:#gameOver 
            ] ifFalse:[
                currentPlayer == #X ifTrue:[
                    currentPlayer := #O
                ] ifFalse:[
                    currentPlayer := #X
                ].
                self changed:#player
            ].
        ]
    ].

    "Created: 18.9.1995 / 13:33:51 / claus"
    "Modified: 19.9.1995 / 00:03:57 / claus"
    "Modified: 26.6.1997 / 20:33:42 / cg"
! !

!TicTacToeGame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe/TicTacToeGame.st,v 1.15 2012-07-19 12:50:51 stefan Exp $'
! !
