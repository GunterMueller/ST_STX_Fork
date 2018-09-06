"
    COPYRIGHT (c) 1997 by eXept Software AG
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






"{ NameSpace: Games }"

Model subclass:#D3TicTacToeGame
	instanceVariableNames:'board gameOver gameFinished winner winningLine beginner
		currentPlayer'
	classVariableNames:''
	poolDictionaries:''
	category:'games-3DTicTacToe'
!

!D3TicTacToeGame class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1997 by eXept Software AG
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
    This is a restructured version of the D3TicTacToe class;

    The games actions has been separated into 3 different areas
    (i.e. Model-View separation):

        displaying 
                - done by D3TicTacToeView, which gets notified
                  by its model, an instance of D3TicTacToeGame.
                  There can be an arbitrary number of views
                  displaying the board simultaneously.

        managing turns,
        managing the board and
        notifying players
                - done by D3TicTacToeGame, which is a model for
                  the views.
                  D3TicTacToeGame does not itself know about how
                  to play - however, it knows the rules for game
                  over, and how to let two players play alternatively

        playing,
        choosing a move
                - done by D3TicTacToePlayer, or the user

    With this separation, it is very easy, to implement both
    user/user playing and user/computer playing.
    In the first case, two views are setup on two displays,
    alternating entry-permission  between them.
    In the second case, one part is done by an instance of D3TicTacToePlayer.

    Communication from the Game to its players and views is via
    change messages (the model does not know who is playing).
    between these objects is via change messages;


    [see also:]
        TicTacToeView
        TicTacToe

    [author:]
        David Queeney
        modelled on TicTacGame by Claus Gittinger

    [start with:]
        Games::D3TicTacToeGame open
        Games::D3TicTacToeGame open2UserGame
"


! !

!D3TicTacToeGame class methodsFor:'startup'!

open
    |gameView game computerPlayer|

    game := self new initialize.

    computerPlayer := D3TicTacToePlayer new.
    computerPlayer game:game playing:#X.

    gameView := D3TicTacToe open.

    gameView model:game.
    gameView playing:#O.

    game askWhoStartsIn:gameView.

    "
     D3TicTacToeGame open
    "
!

open2UserGame
    |gameView1 gameView2 game displayName otherDisplay|

    displayName := Dialog request:'other player on which host ?'.
    (displayName isNil or:[displayName isEmpty]) ifTrue:[
        ^ self
    ].

    otherDisplay := XWorkstation new.
    otherDisplay := otherDisplay initializeFor:(displayName , ':0').
    otherDisplay isNil ifTrue:[
        self warn:'cannot connect to that display'.
        ^ self
    ].
    otherDisplay startDispatch.

    game := self new initialize.

    gameView1 := D3TicTacToe3DView label:'Tic Tac Toe'.
    gameView1 extent:300@300.
    gameView1 icon:(Form fromFile:'TicTacToe.xbm' resolution:100).
    gameView1 model:game.
    gameView1 playing:#X.

    gameView2 :D3TicTacToe3DViewew onDevice:otherDisplay.
    gameView2 label:'3D Tic Tac Toe'.
    gameView2 extent:300@300.
    gameView2 icon:(Form fromFile:'TicTacToe.xbm' resolution:100).
    gameView2 model:game.
    gameView2 playing:#O.
    gameView2 beSlaveView.

    game askWhoStartsIn:gameView1 and:gameView2.

    gameView1 open.
    gameView2 open.

    "
     D3TicTacToeGame open2UserGame
    "

    "Modified: 19.9.1995 / 11:33:32 / claus"
! !

!D3TicTacToeGame methodsFor:'accessing'!

boardAtRow:row col:col lev:lev
    "return the boards value at row/col"

    ^ ((board at:(((lev - 1) * 16) + ((row - 1) * 4) + col)) )

    "Created 10.10.1996 / David Queeney"
!

boardAtRow:row col:col lev:lev put:something
    "set the boards value at row/col"

    board at:(((lev - 1) * 16) + ((row - 1) * 4) + col) put:something.
    self changed:#field: with:(Array with:row with:col with:lev)

    "Created 10.10.1996 / David Queeney"
!

currentPlayer 
    ^ currentPlayer

    "Created 10.10.1996 / David Queeney"
!

gameFinished
    ^ gameFinished

    "Created 10.10.1996 / David Queeney"
!

gameFinished:aBoolean
    gameFinished := gameOver := aBoolean.
    self changed:#gameFinished

    "Created 10.10.1996 / David Queeney"
!

gameOver
    ^ gameOver

    "Created 10.10.1996 / David Queeney"
!

gameOver:aBoolean
    gameOver := aBoolean.
    self changed:#gameOver

    "Created 10.10.1996 / David Queeney"
!

setWinner:who row:row col:col lev:lev

        "Change the winning X to x or O to o"

        |win|
        who == #X ifTrue:[
            win := #x
        ] ifFalse:[
            win := #o
        ].

        self boardAtRow:row col:col lev:lev put:win.

        "Created 17.10.1996 / David Queeney"
!

winner 
    ^ winner

    "Created 10.10.1996 / David Queeney"
!

winningLine 
    ^ winningLine

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToeGame methodsFor:'initialization'!

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
        box1 addTextLabel:'3D TicTacToe: You play O''s.\\Waiting for other player to choose beginner ...' withCRs.
        box1 openModelessAtCenter.
    ].

    box2 := YesNoBox onDevice:(view1 device).

    answer := box2 confirm:'TicTacToe: You play X''s, do you want to start ?'.
    answer ifTrue:[
        currentPlayer := #X. 
    ] ifFalse:[
        currentPlayer := #O. 
    ].

    view1 device ~~ view2 device ifTrue:[
        box1 destroy.
    ].

    self changed:#player.

    "Created: 18.9.1995 / 11:17:31 / claus"
    "Modified: 19.9.1995 / 11:35:13 / claus"
!

initialize
    super initialize.
    board := Array new:64.
    gameFinished := false.
    self newGame

    "Created: 09.10.1996 / 12:45:00 / david"

! !

!D3TicTacToeGame methodsFor:'playing'!

checkGameFinished
    "check if game is finished because no more fields are empty;
     i.e. check if there is any nil field"

    1 to:4 do:[:lev |
        1 to:4 do:[:row |
            1 to:4 do:[:col |
                (self boardAtRow:row col:col lev:lev) isNil ifTrue:[^ false]
            ]
        ]
    ].
    gameOver := true.
    ^ true

    "Created 10.10.1996 / David Queeney"
!

checkGameFinished:who
    "check if 'who' has finished the game because 4 fields are
     filled in a row of his color"
        "Note that there are the following to be checked:
                1. on each level all (a) rows, (b) columns and (c) diagonals
                2. on each row all (a) levels and (b) diagonals (columns caught in one!!)
                3. on each column all diagonals (rows and levels caught in one and two!!)
                4. the four 3D diagonals (the left overs!!)
        "

    "1a:check rows on each level"
    1 to:4 do:[:lev |
        1 to:4 do:[:row |
            ((self boardAtRow:row col:1 lev:lev) == who) ifTrue:[
              ((self boardAtRow:row col:2 lev:lev) == who) ifTrue:[
                ((self boardAtRow:row col:3 lev:lev) == who) ifTrue:[
                  ((self boardAtRow:row col:4 lev:lev) == who) ifTrue:[
                      winner := who.
                      gameOver := true.
                      self setWinner:who row:row col:1 lev:lev.
                      self setWinner:who row:row col:2 lev:lev.
                      self setWinner:who row:row col:3 lev:lev.
                      self setWinner:who row:row col:4 lev:lev.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:row. 
                      winningLine at:2   put:1.
                      winningLine at:3   put:lev.
                      winningLine at:4   put:row.
                      winningLine at:5   put:2.
                      winningLine at:6   put:lev.
                      winningLine at:7   put:row.
                      winningLine at:8   put:3.
                      winningLine at:9   put:lev.
                      winningLine at:10  put:row.
                      winningLine at:11  put:4.
                      winningLine at:12  put:lev.
"
                      self changed:#winner.
                      ^ self
                  ]
                ]
              ]
            ]
        ]
    ].

    "1b: check cols on each level"
    1 to:4 do:[:lev |
        1 to:4 do:[:col |
            ((self boardAtRow:1 col:col lev:lev) == who) ifTrue:[
              ((self boardAtRow:2 col:col lev:lev) == who) ifTrue:[
                ((self boardAtRow:3 col:col lev:lev) == who) ifTrue:[
                  ((self boardAtRow:4 col:col lev:lev) == who) ifTrue:[
                      winner := who.
                      gameOver := true.
                      self setWinner:who row:1 col:col lev:lev.
                      self setWinner:who row:2 col:col lev:lev.
                      self setWinner:who row:3 col:col lev:lev.
                      self setWinner:who row:4 col:col lev:lev.

"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:1. 
                      winningLine at:2   put:col.
                      winningLine at:3   put:lev.
                      winningLine at:4   put:2.
                      winningLine at:5   put:col.
                      winningLine at:6   put:lev.
                      winningLine at:7   put:3.
                      winningLine at:8   put:col.
                      winningLine at:9   put:lev.
                      winningLine at:10  put:4.
                      winningLine at:11  put:col.
                      winningLine at:12  put:lev.
"
                      self changed:#winner.
                      ^ self
                ]
              ]
            ]
          ]
        ]
    ].

    "1c: check diagonals on each level"

    1 to:4 do:[:lev |
        ((self boardAtRow:1 col:1 lev:lev) == who) ifTrue:[
          ((self boardAtRow:2 col:2 lev:lev) == who) ifTrue:[
            ((self boardAtRow:3 col:3 lev:lev) == who) ifTrue:[
              ((self boardAtRow:4 col:4 lev:lev) == who) ifTrue:[
                  winner := who.
                  gameOver := true.
                      self setWinner:who row:1 col:1 lev:lev.
                      self setWinner:who row:2 col:2 lev:lev.
                      self setWinner:who row:3 col:3 lev:lev.
                      self setWinner:who row:4 col:4 lev:lev.

"
                  winningLine := (Array new:12) from:1 to:12 put:0.
                  winningLine at:1 put:1. 
                  winningLine at:2   put:1.
                  winningLine at:3   put:lev.
                  winningLine at:4   put:2.
                  winningLine at:5   put:2.
                  winningLine at:6   put:lev.
                  winningLine at:7   put:3.
                  winningLine at:8   put:3.
                  winningLine at:9   put:lev.
                  winningLine at:10  put:4.
                  winningLine at:11  put:4.
                  winningLine at:12  put:lev.
"
                  self changed:#winner.
                  ^ self
                ]
              ]
            ]
          ]
    ].
    1 to:4 do:[:lev |
        ((self boardAtRow:1 col:4 lev:lev) == who) ifTrue:[
          ((self boardAtRow:2 col:3 lev:lev) == who) ifTrue:[
            ((self boardAtRow:3 col:2 lev:lev) == who) ifTrue:[
              ((self boardAtRow:4 col:1 lev:lev) == who) ifTrue:[
                winner := who.
                gameOver := true.

                      self setWinner:who row:4 col:1 lev:lev.
                      self setWinner:who row:3 col:2 lev:lev.
                      self setWinner:who row:2 col:3 lev:lev.
                      self setWinner:who row:1 col:4 lev:lev.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:1. 
                      winningLine at:2   put:4.
                      winningLine at:3   put:lev.
                      winningLine at:4   put:2.
                      winningLine at:5   put:3.
                      winningLine at:6   put:lev.
                      winningLine at:7   put:3.
                      winningLine at:8   put:2.
                      winningLine at:9   put:lev.
                      winningLine at:10  put:4.
                      winningLine at:11  put:1.
                      winningLine at:12  put:lev.
"
                self changed:#winner.
                ^ self
              ]
            ]
          ]
        ]
    ].

    "2a:check levels on each row"
    1 to:4 do:[:row |
        1 to:4 do:[:col |
            ((self boardAtRow:row col:col lev:1) == who) ifTrue:[
              ((self boardAtRow:row col:col lev:2) == who) ifTrue:[
                ((self boardAtRow:row col:col lev:3) == who) ifTrue:[
                  ((self boardAtRow:row col:col lev:4) == who) ifTrue:[
                      winner := who.
                      gameOver := true.

                      self setWinner:who row:row col:col lev:1.
                      self setWinner:who row:row col:col lev:2.
                      self setWinner:who row:row col:col lev:3.
                      self setWinner:who row:row col:col lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:row. 
                      winningLine at:2   put:col.
                      winningLine at:3   put:1.
                      winningLine at:4   put:row.
                      winningLine at:5   put:col.
                      winningLine at:6   put:2.
                      winningLine at:7   put:row.
                      winningLine at:8   put:col.
                      winningLine at:9   put:3.
                      winningLine at:10  put:row.
                      winningLine at:11  put:col.
                      winningLine at:12  put:4.
"
                      self changed:#winner.
                      ^ self
                  ]
                ]
              ]
            ]
        ]
    ].

    "2b: check diagonals on each row"
    1 to:4 do:[:row |
        ((self boardAtRow:row col:1 lev:1) == who) ifTrue:[
          ((self boardAtRow:row col:2 lev:2) == who) ifTrue:[
            ((self boardAtRow:row col:3 lev:3) == who) ifTrue:[
              ((self boardAtRow:row col:4 lev:4) == who) ifTrue:[
                  winner := who.
                  gameOver := true.

                      self setWinner:who row:row col:1 lev:1.
                      self setWinner:who row:row col:2 lev:2.
                      self setWinner:who row:row col:3 lev:3.
                      self setWinner:who row:row col:4 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:row. 
                      winningLine at:2   put:1.
                      winningLine at:3   put:1.
                      winningLine at:4   put:row.
                      winningLine at:5   put:2.
                      winningLine at:6   put:2.
                      winningLine at:7   put:row.
                      winningLine at:8   put:3.
                      winningLine at:9   put:3.
                      winningLine at:10  put:row.
                      winningLine at:11  put:4.
                      winningLine at:12  put:4.
"
                  self changed:#winner.
                  ^ self
                ]
              ]
            ]
          ]
    ].

    1 to:4 do:[:row |
        ((self boardAtRow:row col:4 lev:1) == who) ifTrue:[
          ((self boardAtRow:row col:3 lev:2) == who) ifTrue:[
            ((self boardAtRow:row col:2 lev:3) == who) ifTrue:[
              ((self boardAtRow:row col:1 lev:4) == who) ifTrue:[
                winner := who.
                gameOver := true.

                      self setWinner:who row:row col:4 lev:1.
                      self setWinner:who row:row col:3 lev:2.
                      self setWinner:who row:row col:2 lev:3.
                      self setWinner:who row:row col:1 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:row. 
                      winningLine at:2   put:4.
                      winningLine at:3   put:1.
                      winningLine at:4   put:row.
                      winningLine at:5   put:3.
                      winningLine at:6   put:2.
                      winningLine at:7   put:row.
                      winningLine at:8   put:2.
                      winningLine at:9   put:3.
                      winningLine at:10  put:row.
                      winningLine at:11  put:1.
                      winningLine at:12  put:4.
"
                self changed:#winner.
                ^ self
              ]
            ]
          ]
        ]
    ].

    "3: check diagonals on each column"
    1 to:4 do:[:col |
        ((self boardAtRow:1 col:col lev:1) == who) ifTrue:[
          ((self boardAtRow:2 col:col lev:2) == who) ifTrue:[
            ((self boardAtRow:3 col:col lev:3) == who) ifTrue:[
              ((self boardAtRow:4 col:col lev:4) == who) ifTrue:[
                  winner := who.
                  gameOver := true.

                      self setWinner:who row:1 col:col lev:1.
                      self setWinner:who row:2 col:col lev:2.
                      self setWinner:who row:3 col:col lev:3.
                      self setWinner:who row:4 col:col lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:1. 
                      winningLine at:2   put:col.
                      winningLine at:3   put:1.
                      winningLine at:4   put:2.
                      winningLine at:5   put:col.
                      winningLine at:6   put:2.
                      winningLine at:7   put:3.
                      winningLine at:8   put:col.
                      winningLine at:9   put:3.
                      winningLine at:10  put:4.
                      winningLine at:11  put:col.
                      winningLine at:12  put:4.
"
                  self changed:#winner.
                  ^ self
                ]
              ]
            ]
          ]
    ].

    1 to:4 do:[:col |
        ((self boardAtRow:4 col:col lev:1) == who) ifTrue:[
          ((self boardAtRow:3 col:col lev:2) == who) ifTrue:[
            ((self boardAtRow:2 col:col lev:3) == who) ifTrue:[
              ((self boardAtRow:1 col:col lev:4) == who) ifTrue:[
                winner := who.
                gameOver := true.

                      self setWinner:who row:4 col:col lev:1.
                      self setWinner:who row:3 col:col lev:2.
                      self setWinner:who row:2 col:col lev:3.
                      self setWinner:who row:1 col:col lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:4. 
                      winningLine at:2   put:col.
                      winningLine at:3   put:1.
                      winningLine at:4   put:3.
                      winningLine at:5   put:col.
                      winningLine at:6   put:2.
                      winningLine at:7   put:2.
                      winningLine at:8   put:col.
                      winningLine at:9   put:3.
                      winningLine at:10  put:1.
                      winningLine at:11  put:col.
                      winningLine at:12  put:4.
"
                self changed:#winner.
                ^ self
              ]
            ]
          ]
        ]
    ].

    "4: check 3D diagonals"

    ((self boardAtRow:1 col:1 lev:1) == who) ifTrue:[
      ((self boardAtRow:2 col:2 lev:2) == who) ifTrue:[
        ((self boardAtRow:3 col:3 lev:3) == who) ifTrue:[
          ((self boardAtRow:4 col:4 lev:4) == who) ifTrue:[
              winner := who.
              gameOver := true.

                      self setWinner:who row:1 col:1 lev:1.
                      self setWinner:who row:2 col:2 lev:2.
                      self setWinner:who row:3 col:3 lev:3.
                      self setWinner:who row:4 col:4 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:1. 
                      winningLine at:2   put:1.
                      winningLine at:3   put:1.
                      winningLine at:4   put:2.
                      winningLine at:5   put:2.
                      winningLine at:6   put:2.
                      winningLine at:7   put:3.
                      winningLine at:8   put:3.
                      winningLine at:9   put:3.
                      winningLine at:10  put:4.
                      winningLine at:11  put:4.
                      winningLine at:12  put:4.
"
              self changed:#winner.
              ^ self
          ]
        ]
      ]
    ].

    ((self boardAtRow:4 col:1 lev:1) == who) ifTrue:[
      ((self boardAtRow:3 col:2 lev:2) == who) ifTrue:[
        ((self boardAtRow:2 col:3 lev:3) == who) ifTrue:[
          ((self boardAtRow:1 col:4 lev:4) == who) ifTrue:[
            winner := who.
            gameOver := true.

                      self setWinner:who row:4 col:1 lev:1.
                      self setWinner:who row:3 col:2 lev:2.
                      self setWinner:who row:2 col:3 lev:3.
                      self setWinner:who row:1 col:4 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:4. 
                      winningLine at:2   put:1.
                      winningLine at:3   put:1.
                      winningLine at:4   put:3.
                      winningLine at:5   put:2.
                      winningLine at:6   put:2.
                      winningLine at:7   put:2.
                      winningLine at:8   put:3.
                      winningLine at:9   put:3.
                      winningLine at:10  put:1.
                      winningLine at:11  put:4.
                      winningLine at:12  put:4.
"
            self changed:#winner.
            ^ self
          ]
        ]
      ]
    ].

    ((self boardAtRow:4 col:4 lev:1) == who) ifTrue:[
      ((self boardAtRow:3 col:3 lev:2) == who) ifTrue:[
        ((self boardAtRow:2 col:2 lev:3) == who) ifTrue:[
          ((self boardAtRow:1 col:1 lev:4) == who) ifTrue:[
              winner := who.
              gameOver := true.

                      self setWinner:who row:4 col:4 lev:1.
                      self setWinner:who row:3 col:3 lev:2.
                      self setWinner:who row:2 col:2 lev:3.
                      self setWinner:who row:1 col:1 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:4. 
                      winningLine at:2   put:4.
                      winningLine at:3   put:1.
                      winningLine at:4   put:3.
                      winningLine at:5   put:3.
                      winningLine at:6   put:2.
                      winningLine at:7   put:2.
                      winningLine at:8   put:2.
                      winningLine at:9   put:3.
                      winningLine at:10  put:1.
                      winningLine at:11  put:1.
                      winningLine at:12  put:4.
"
              self changed:#winner.
              ^ self
           ]
         ]
       ]
    ].

    ((self boardAtRow:1 col:4 lev:1) == who) ifTrue:[
      ((self boardAtRow:2 col:3 lev:2) == who) ifTrue:[
        ((self boardAtRow:3 col:2 lev:3) == who) ifTrue:[
          ((self boardAtRow:4 col:1 lev:4) == who) ifTrue:[
            winner := who.
            gameOver := true.

                      self setWinner:who row:1 col:4 lev:1.
                      self setWinner:who row:2 col:3 lev:2.
                      self setWinner:who row:3 col:2 lev:3.
                      self setWinner:who row:4 col:1 lev:4.
"
                      winningLine := (Array new:12) from:1 to:12 put:0.
                      winningLine at:1   put:1. 
                      winningLine at:2   put:4.
                      winningLine at:3   put:1.
                      winningLine at:4   put:2.
                      winningLine at:5   put:3.
                      winningLine at:6   put:2.
                      winningLine at:7   put:3.
                      winningLine at:8   put:2.
                      winningLine at:9   put:3.
                      winningLine at:10  put:4.
                      winningLine at:11  put:1.
                      winningLine at:12  put:4.
"
            self changed:#winner.
            ^ self
          ]
        ]
      ]
    ]
    "Created 10.10.1996 / David Queeney"
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

    "Created 10.10.1996 / David Queeney"
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

userPlay:who row:row col:col lev:lev
    "user plays"

    self checkGameFinished.
    gameOver ifFalse:[
        (self boardAtRow:row col:col lev:lev) isNil ifTrue:[
            self boardAtRow:row col:col lev:lev put:who.
            self checkGameFinished:who.
            self checkGameFinished.
            gameOver ifFalse:[
                currentPlayer == #X ifTrue:[
                    currentPlayer := #O
                ] ifFalse:[
                    currentPlayer := #X
                ].
                self changed:#player
            ].
            gameOver ifTrue:[
                self changed:#gameOver 
            ]
        ]
    ].

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToeGame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe3D/D3TicTacToeGame.st,v 1.4 1997-08-08 16:44:34 cg Exp $'
! !
