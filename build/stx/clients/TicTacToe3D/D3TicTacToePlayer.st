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

Object subclass:#D3TicTacToePlayer
	instanceVariableNames:'game which'
	classVariableNames:''
	poolDictionaries:''
	category:'games-3DTicTacToe'
!

!D3TicTacToePlayer class methodsFor:'documentation'!

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
    [start with:]
        Games::D3TicTacToeGame open

    [author:]
        David Queeney
"

! !

!D3TicTacToePlayer methodsFor:'accessing'!

game:aGame playing:XorO
    game := aGame.
    which := XorO.
    game addDependent:self.

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToePlayer methodsFor:'events'!

update:something with:aParameter from:changedObject
    something == #player ifTrue:[
	game currentPlayer == which ifTrue:[
	    "/ its my turn ...
	    self playNext
	]
    ]

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToePlayer methodsFor:'next move decision'!

canFillCol:who

    |pattern result|

    pattern := Array with:who with:who with:who with:who.

    "check if a row can be filled"
    1 to:4 do:[:lev |
      1 to:4 do:[:col |
	1 to:4 do:[:row |
	  pattern at:row put:nil.
	  ((game boardAtRow:1 col:col lev:lev) == (pattern at:1)) ifTrue:[
	    ((game boardAtRow:2 col:col lev:lev) == (pattern at:2)) ifTrue:[
	      ((game boardAtRow:3 col:col lev:lev) == (pattern at:3)) ifTrue:[
		((game boardAtRow:4 col:col lev:lev) == (pattern at:4)) ifTrue:[
		  ^ ( Array with:col with:lev) "must return a collection of column, level!!"
		]
	      ]
	    ]
	  ].
	  pattern at:row put:who
       ]
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag0:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"

    1 to:4 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:1 col:1 lev:1) == (pattern at:1)) ifTrue:[
	((game boardAtRow:2 col:2 lev:2) == (pattern at:2)) ifTrue:[
	  ((game boardAtRow:3 col:3 lev:3) == (pattern at:3)) ifTrue:[
	    ((game boardAtRow:4 col:4 lev:4) == (pattern at:4)) ifTrue:[
	      ^ 1 
	    ]
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag1:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"

    1 to:4 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:4 col:1 lev:1) == (pattern at:1)) ifTrue:[
	((game boardAtRow:3 col:2 lev:2) == (pattern at:2)) ifTrue:[
	  ((game boardAtRow:2 col:3 lev:3) == (pattern at:3)) ifTrue:[
	    ((game boardAtRow:1 col:4 lev:4) == (pattern at:4)) ifTrue:[
	      ^ 1 
	    ]
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag1Col:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:col |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:1 col:col lev:1) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:2 col:col lev:2) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:3 col:col lev:3) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:4 col:col lev:4) == (pattern at:4)) ifTrue:[
		^ col
	      ]
	    ]
	  ]
	].
	pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag1Lev:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:lev |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:1 col:1 lev:lev) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:2 col:2 lev:lev) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:3 col:3 lev:lev) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:4 col:4 lev:lev) == (pattern at:4)) ifTrue:[
		^ lev
	      ]
	    ]
	  ]
	].
	pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag1Row:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:row |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:row col:1 lev:1) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:row col:2 lev:2) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:row col:3 lev:3) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:row col:4 lev:4) == (pattern at:4)) ifTrue:[
		^ row     
	      ]
	    ]
	  ]
	].
	pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag2:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"

    1 to:4 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:1 col:4 lev:1) == (pattern at:1)) ifTrue:[
	((game boardAtRow:2 col:3 lev:2) == (pattern at:2)) ifTrue:[
	  ((game boardAtRow:3 col:2 lev:3) == (pattern at:3)) ifTrue:[
	    ((game boardAtRow:4 col:1 lev:4) == (pattern at:4)) ifTrue:[
	      ^ 1
	    ]
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag2Col:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:col |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:4 col:col lev:1) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:3 col:col lev:2) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:2 col:col lev:3) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:1 col:col lev:4) == (pattern at:4)) ifTrue:[
		^ col
	      ]
	    ]
	  ]
	].
      pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag2Lev:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:lev |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:1 col:4 lev:lev) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:2 col:3 lev:lev) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:3 col:2 lev:lev) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:4 col:1 lev:lev) == (pattern at:4)) ifTrue:[
		^ lev
	      ]
	    ]
	  ]
	].
      pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag2Row:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:row |
      1 to:4 do:[:x |
	pattern at:x put:nil.
	((game boardAtRow:row col:4 lev:1) == (pattern at:1)) ifTrue:[
	  ((game boardAtRow:row col:3 lev:2) == (pattern at:2)) ifTrue:[
	    ((game boardAtRow:row col:2 lev:3) == (pattern at:3)) ifTrue:[
	      ((game boardAtRow:row col:1 lev:4) == (pattern at:4)) ifTrue:[
		^ row
	      ]
	    ]
	  ]
	].
      pattern at:x put:who
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillDiag3:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a diagonal can be filled"
    1 to:4 do:[:x |
      pattern at:x put:nil.
      ((game boardAtRow:4 col:4 lev:1) == (pattern at:1)) ifTrue:[
	((game boardAtRow:3 col:3 lev:2) == (pattern at:2)) ifTrue:[
	  ((game boardAtRow:2 col:2 lev:3) == (pattern at:3)) ifTrue:[
	    ((game boardAtRow:1 col:1 lev:4) == (pattern at:4)) ifTrue:[
	      ^ 1
	    ]
	  ]
	]
      ].
      pattern at:x put:who
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillLev:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a level can be filled"
    1 to:4 do:[:lev |
      1 to:4 do:[:row |
	1 to:4 do:[:col |
	  pattern at:lev put:nil.
	  ((game boardAtRow:row col:col lev:1) == (pattern at:1)) ifTrue:[
	    ((game boardAtRow:row col:col lev:2) == (pattern at:2)) ifTrue:[
	      ((game boardAtRow:row col:col lev:3) == (pattern at:3)) ifTrue:[
		((game boardAtRow:row col:col lev:4) == (pattern at:4)) ifTrue:[
		  ^ (Array with:row with:col)  "column, row"
		]
	      ]
	    ]
	  ].
	  pattern at:lev put:who
	]
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

canFillRow:who

    |pattern|

    pattern := Array with:who with:who with:who with:who.

    "check if a row can be filled"
    1 to:4 do:[:lev |
      1 to:4 do:[:row |
	1 to:4 do:[:col |
	  pattern at:col put:nil.
	  ((game boardAtRow:row col:1 lev:lev) == (pattern at:1)) ifTrue:[
	    ((game boardAtRow:row col:2 lev:lev) == (pattern at:2)) ifTrue:[
	      ((game boardAtRow:row col:3 lev:lev) == (pattern at:3)) ifTrue:[
		((game boardAtRow:row col:4 lev:lev) == (pattern at:4)) ifTrue:[
		  ^ (Array with:row with:lev)  "row, level"
		]
	      ]
	    ]
	  ].
	  pattern at:col put:who
	]
      ]
    ].
    ^ nil

    "Created 10.10.1996 / David Queeney"
!

diag1Has2EmptySlotsAnd:who

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
!

diag2Has2EmptySlotsAnd:who

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

!D3TicTacToePlayer methodsFor:'playing'!

play:who col:col lev:lev
    "place any field in a column for player 'who'"

    #(1 4 3 2) do:[:row |
	(game boardAtRow:row col:col lev:lev) isNil ifTrue:[
	    game userPlay:who row:row col:col lev:lev.
	    ^ row
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

play:who row:row col:col
    "place any field in a level for player 'who'"

    #(1 4 3 2) do:[:lev |
	(game boardAtRow:row col:col lev:lev) isNil ifTrue:[
	    game userPlay:who row:row col:col lev:lev.
	    ^ lev
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

play:who row:row lev:lev
    "place any field in a row for player 'who'"

    #(1 4 3 2) do:[:col |
	(game boardAtRow:row col:col lev:lev) isNil ifTrue:[
	    game userPlay:who row:row col:col lev:lev.
	    ^ col
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag0:who
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:x col:x lev:x) isNil ifTrue:[
	    game userPlay:who row:x col:x lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag1:who
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:(5 - x) col:x lev:x) isNil ifTrue:[
	    game userPlay:who row:(5 - x) col:x lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag1:who col:col
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:x col:col lev:x) isNil ifTrue:[
	    game userPlay:who row:x col:col lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag1:who lev:lev
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:x col:x lev:lev) isNil ifTrue:[
	    game userPlay:who row:x col:x lev:lev.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag1:who row:row
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:row col:x lev:x) isNil ifTrue:[
	    game userPlay:who row:row col:x lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag2:who
    "place any field in the second diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:x col:(5 - x) lev:x) isNil ifTrue:[
	    game userPlay:who row:x col:(5 - x) lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag2:who col:col
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:(5 - x) col:col lev:x) isNil ifTrue:[
	    game userPlay:who row:(5 - x) col:col lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag2:who lev:lev
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:(5 - x) col:x lev:lev) isNil ifTrue:[
	    game userPlay:who row:(5 - x) col:x lev:lev.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag2:who row:row
    "place any field in the first diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:row col:(5 - x) lev:x) isNil ifTrue:[
	    game userPlay:who row:row col:(5 - x) lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playDiag3:who
    "place any field in the second diagonal for player 'who'"

    #(1 4 3 2) do:[:x |
	(game boardAtRow:(5 - x) col:(5 - x) lev:x) isNil ifTrue:[
	    game userPlay:who row:(5 - x) col:(5 - x) lev:x.
	    ^ x
	]
    ]

    "Created 10.10.1996 / David Queeney"
!

playNext
    "make a move"

    self playNext:which

    "Created: 18.9.1995 / 11:15:16 / claus"
    "Modified: 18.9.1995 / 15:38:57 / claus"
!

playNext:who
    "determine the next move for player 'who'"

    |row col lev other rowColLev|

    "try if I can win"

	"Check rows, columns, and levels"

    rowColLev := self canFillRow:who.      "row, lev"
    rowColLev notNil ifTrue:[
	self play:who row:(rowColLev at:1) lev:(rowColLev at:2).
	^ self
    ].
    rowColLev := self canFillCol:who.      "col, lev"
    rowColLev notNil ifTrue:[
	self play:who col:(rowColLev at:1) lev:(rowColLev at:2).
	^ self
    ].
    rowColLev := self canFillLev:who.      "row, col"
    rowColLev notNil ifTrue:[
	self play:who row:(rowColLev at:1) col:(rowColLev at:2).
	^ self
    ].

	" check diag 0,1,2,3 "

    (self canFillDiag0:who) notNil ifTrue:[
	self playDiag0:who.
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
    (self canFillDiag3:who) notNil ifTrue:[
	self playDiag3:who.
	^ self
    ].

	" check diag per row, column, and level "

    row := self canFillDiag1Row:who.
    row notNil ifTrue:[
	self playDiag1:who row:row.
	^ self
    ].
    row := self canFillDiag2Row:who.
    row notNil ifTrue:[
	self playDiag2:who row:row.
	^ self
    ].
    col := self canFillDiag1Col:who.
    col notNil ifTrue:[
	self playDiag1:who col:col.
	^ self
    ].
    col := self canFillDiag2Col:who.
    col notNil ifTrue:[
	self playDiag2:who col:col.
	^ self
    ].
    lev := self canFillDiag1Lev:who.
    lev notNil ifTrue:[
"/ self halt.
	self playDiag1:who lev:lev.
	^ self
    ].
    lev := self canFillDiag2Lev:who.
    lev notNil ifTrue:[
"/ self halt.
	self playDiag2:who lev:lev.
	^ self
    ].

    (who == #X) ifTrue:[
	other := #O
    ] ifFalse:[
	other := #X
    ].

    "try to prevent other from winning"

	"Check rows, columns, and levels"

    rowColLev := self canFillRow:other.      "row, lev"
    rowColLev notNil ifTrue:[
	self play:who row:(rowColLev at:1) lev:(rowColLev at:2).
	^ self
    ].
    rowColLev := self canFillCol:other.      "col, lev"
    rowColLev notNil ifTrue:[
	self play:who col:(rowColLev at:1) lev:(rowColLev at:2).
	^ self
    ].
    rowColLev := self canFillLev:other.      "row, col"
    rowColLev notNil ifTrue:[
	self play:who row:(rowColLev at:1) col:(rowColLev at:2).
	^ self
    ].

	" check diag 0,1,2,3 "

    (self canFillDiag0:other) notNil ifTrue:[
	self playDiag0:who.
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
    (self canFillDiag3:other) notNil ifTrue:[
	self playDiag3:who.
	^ self
    ].

	" check diag per row, column, and level "

    row := self canFillDiag1Row:other.
    row notNil ifTrue:[
	self playDiag1:who row:row.
	^ self
    ].
    row := self canFillDiag2Row:other.
    row notNil ifTrue:[
	self playDiag2:who row:row.
	^ self
    ].
    col := self canFillDiag1Col:other.
    col notNil ifTrue:[
	self playDiag1:who col:col.
	^ self
    ].
    col := self canFillDiag2Col:other.
    col notNil ifTrue:[
	self playDiag2:who col:col.
	^ self
    ].
    lev := self canFillDiag1Lev:other.
    lev notNil ifTrue:[
	self playDiag1:who lev:lev.
	^ self
    ].
    lev := self canFillDiag2Lev:other.
    lev notNil ifTrue:[
	self playDiag2:who lev:lev.
	^ self
    ].

    "if other has a row/col with 2 empty slots - play there"
"
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
"
    "no winning chance - find a row with 1 of mine, 2 empty slots"
"
    row := self findRowWith2EmptySlotsAnd:who.
    row notNil ifTrue:[
"
	"if row intersects a col with 2 empty slots, take it"
"
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
"
    "rest ist heuristic ..."
    "center position is best"

    #( (2 2 2) (2 2 3) (2 3 2) (2 3 3) (3 2 2) (3 2 3) (3 3 2) (3 3 3) ) 
    triplesDo:[ :row :col :lev |
	(game boardAtRow:row col:col lev:lev) isNil ifTrue:[
	    game userPlay:who row:row col:col lev:lev.
	    ^ self
	]
    ].

    "then corners"

    #( (1 1 1) (1 1 4) (1 4 1) (1 4 4) (4 1 1) (4 1 4) (4 4 1) (4 4 4) )
    triplesDo:[ :row :col :lev |
	(game boardAtRow:row col:col lev:lev) isNil ifTrue:[
	    game userPlay:who row:row col:col lev:lev.
	    ^ self
	]
    ].


    "any free slot"

    1 to:4 do:[:lev |
      1 to:4 do:[:row |
	  1 to:4 do:[:col |
	      (game boardAtRow:row col:col lev:lev) isNil ifTrue:[
		  game userPlay:who row:row col:col lev:lev.
		  ^ self
	      ]
	  ]
       ]
    ].

    ^ self

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToePlayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe3D/D3TicTacToePlayer.st,v 1.4 1997-08-08 16:44:38 cg Exp $'
! !
