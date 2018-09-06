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

Object subclass:#TicTacToePlayer
	instanceVariableNames:'game whatAmIPlaying'
	classVariableNames:''
	poolDictionaries:''
	category:'games-TicTacToe'
!

!TicTacToePlayer class methodsFor:'documentation'!

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


    Instances of TicTacToePlayer know how to play the game,
    and take the role of the other player in a single player
    game. They are not involved, if two humans play against each other.

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

!TicTacToePlayer methodsFor:'accessing'!

game:aGame playing:XorO
    game := aGame.
    whatAmIPlaying := XorO.
    game addDependent:self.

    "Created: 18.9.1995 / 15:23:55 / claus"
    "Modified: 18.9.1995 / 15:32:52 / claus"
    "Modified: 26.6.1997 / 19:44:11 / cg"
! !

!TicTacToePlayer methodsFor:'events'!

update:something with:aParameter from:changedObject
    something == #player ifTrue:[
        game currentPlayer == whatAmIPlaying ifTrue:[
            "/ its my turn ...
            self playNext
        ]
    ]

    "Created: 18.9.1995 / 15:40:10 / claus"
    "Modified: 18.9.1995 / 16:00:24 / claus"
    "Modified: 26.6.1997 / 19:44:14 / cg"
! !

!TicTacToePlayer methodsFor:'next move decision'!

canFillCol:who
    "return true, if a col can be filled by a move of who"

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a row can be filled"
    1 to:3 do:[:col |
      1 to:3 do:[:row |
        pattern at:row put:nil.
        ((game boardAtRow:1 col:col) == (pattern at:1)) ifTrue:[
          ((game boardAtRow:2 col:col) == (pattern at:2)) ifTrue:[
            ((game boardAtRow:3 col:col) == (pattern at:3)) ifTrue:[
                ^ col
            ]
          ]
        ].
        pattern at:row put:who
      ]
    ].
    ^ nil

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:13 / claus"
    "Modified: 26.6.1997 / 19:47:36 / cg"
!

canFillDiag1:who
    "return true, if the first diagonal can be filled by a move of who"

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:3 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:1 col:1) == (pattern at:1)) ifTrue:[
        ((game boardAtRow:2 col:2) == (pattern at:2)) ifTrue:[
          ((game boardAtRow:3 col:3) == (pattern at:3)) ifTrue:[
              ^ 1
          ]
        ]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:19 / claus"
    "Modified: 26.6.1997 / 19:47:44 / cg"
!

canFillDiag2:who
    "return true, if the 2nd diagonal can be filled by a move of who"

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:3 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:1 col:3) == (pattern at:1)) ifTrue:[
        ((game boardAtRow:2 col:2) == (pattern at:2)) ifTrue:[
          ((game boardAtRow:3 col:1) == (pattern at:3)) ifTrue:[
              ^ 1
          ]
        ]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:22 / claus"
    "Modified: 26.6.1997 / 19:47:48 / cg"
!

canFillRow:who
    "return true, if a row can be filled by a move of who"

    |pattern|

    pattern := Array with:who with:who with:who.

    "check if a row can be filled"
    1 to:3 do:[:row |
      1 to:3 do:[:col |
        pattern at:col put:nil.
        ((game boardAtRow:row col:1) == (pattern at:1)) ifTrue:[
          ((game boardAtRow:row col:2) == (pattern at:2)) ifTrue:[
            ((game boardAtRow:row col:3) == (pattern at:3)) ifTrue:[
                ^ row
            ]
          ]
        ].
        pattern at:col put:who
      ]
    ].
    ^ nil

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:24 / claus"
    "Modified: 26.6.1997 / 19:47:52 / cg"
!

canMakeTrap:who
    |countWho countEmpty|

    countWho := 0.
    countEmpty := 0.

    ((game boardAtRow:2 col:2) == who) ifTrue:[
        ((game boardAtRow:2 col:1) == who) ifTrue:[
            ((game boardAtRow:1 col:1) isNil) ifTrue:[
                ((game boardAtRow:3 col:3) isNil) ifTrue:[
                    ((game boardAtRow:3 col:1) isNil) ifTrue:[
                        ^ 1 @ 1
                    ]
                ]
            ]        
        ].
        ((game boardAtRow:1 col:2) == who) ifTrue:[
            ((game boardAtRow:1 col:1) isNil) ifTrue:[
                ((game boardAtRow:3 col:3) isNil) ifTrue:[
                    ((game boardAtRow:1 col:3) isNil) ifTrue:[
                        ^ 1 @ 1
                    ]
                ]
            ]        
        ].
    ].

    ^ nil
!

diag1Has2EmptySlotsAnd:who
    "return true, if the 1st diagonal has 2 empty slots"

    |countWho countEmpty x|

    countWho := 0.
    countEmpty := 0.
    1 to:3 do:[:i |
        x := game boardAtRow:i col:i.
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

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:28 / claus"
    "Modified: 26.6.1997 / 19:46:07 / cg"
!

diag2Has2EmptySlotsAnd:who
    "return true, if the 2nd diagonal has 2 empty slots"

    |countWho countEmpty x|

    countWho := 0.
    countEmpty := 0.
    1 to:3 do:[:i |
        x := game boardAtRow:i col:(4 - i).
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

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:31 / claus"
    "Modified: 26.6.1997 / 19:46:18 / cg"
!

findColWith2EmptySlotsAnd:who

    |countWho countEmpty x|

    1 to:3 do:[:col |
	countWho := 0.
	countEmpty := 0.
	1 to:3 do:[:row |
	    x := game boardAtRow:row col:col.
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

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:34 / claus"
!

findRowWith2EmptySlotsAnd:who

    |countWho countEmpty x|

    1 to:3 do:[:row |
	countWho := 0.
	countEmpty := 0.
	1 to:3 do:[:col |
	    x := game boardAtRow:row col:col.
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

    "Created: 18.9.1995 / 11:32:10 / claus"
    "Modified: 18.9.1995 / 15:12:37 / claus"
! !

!TicTacToePlayer methodsFor:'playing'!

play:who col:col
    "place any field in a column for player 'who'"

    #(1 3 2) do:[:row |
        (game boardAtRow:row col:col) isNil ifTrue:[
            game userPlay:who row:row col:col.
            ^ row
        ]
    ]

    "Created: 18.9.1995 / 11:14:08 / claus"
    "Modified: 18.9.1995 / 15:43:10 / claus"
    "Modified: 26.6.1997 / 20:02:41 / cg"
!

play:who row:row
    "place any field in a row for player 'who'"

    #(1 3 2) do:[:col |
	(game boardAtRow:row col:col) isNil ifTrue:[
	    game userPlay:who row:row col:col.
	    ^ col
	]
    ]

    "Created: 18.9.1995 / 11:14:16 / claus"
    "Modified: 18.9.1995 / 15:43:15 / claus"
!

playDiag1:who
    "place any field in the first diagonal for player 'who'"

    #(1 3 2) do:[:x |
	(game boardAtRow:x col:x) isNil ifTrue:[
	    game userPlay:who row:x col:x.
	    ^ x
	]
    ]

    "Created: 18.9.1995 / 11:14:31 / claus"
    "Modified: 18.9.1995 / 15:43:20 / claus"
!

playDiag2:who
    "place any field in the second diagonal for player 'who'"

    #(1 3 2) do:[:x |
	(game boardAtRow:x col:(4 - x)) isNil ifTrue:[
	    game userPlay:who row:x col:(4 - x).
	    ^ x
	]
    ]

    "Created: 18.9.1995 / 11:14:38 / claus"
    "Modified: 18.9.1995 / 15:43:26 / claus"
!

playNext
    "make a move"

    self playNext:whatAmIPlaying

    "Created: 18.9.1995 / 11:15:16 / claus"
    "Modified: 18.9.1995 / 15:38:57 / claus"
    "Modified: 26.6.1997 / 20:07:32 / cg"
!

playNext:who
    "determine the next move for player 'who'"

    |row col other pos|

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

    pos := self canMakeTrap:who.
    pos notNil ifTrue:[
        game userPlay:who row:(pos y) col:(pos x).
        ^ self
    ].

    "if other has a row/col with 2 empty slots - play there"

    row := self findRowWith2EmptySlotsAnd:other.
    row notNil ifTrue:[
        col := self findColWith2EmptySlotsAnd:other.
        col notNil ifTrue:[
            (game boardAtRow:row col:col) isNil ifTrue:[
                game userPlay:who row:row col:col.
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
            (game boardAtRow:row col:col) isNil ifTrue:[
                game userPlay:who row:row col:col.
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
    (game boardAtRow:2 col:2) isNil ifTrue:[
        game userPlay:who row:2 col:2.
        ^ self
    ].

    "then corners"
    #(1 1 3 3) with:#(1 3 1 3) do:[:row :col |
        (game boardAtRow:row col:col) isNil ifTrue:[
            game userPlay:who row:row col:col.
            ^ self
        ].
    ].

    "any free slot"
    1 to:3 do:[:row |
        1 to:3 do:[:col |
            (game boardAtRow:row col:col) isNil ifTrue:[
                game userPlay:who row:row col:col.
                ^ self
            ]
        ]
    ].

    ^ self

    "Created: 18.9.1995 / 11:15:16 / claus"
    "Modified: 18.9.1995 / 15:43:57 / claus"
! !

!TicTacToePlayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe/TicTacToePlayer.st,v 1.8 2002-02-15 18:28:01 cg Exp $'
! !
