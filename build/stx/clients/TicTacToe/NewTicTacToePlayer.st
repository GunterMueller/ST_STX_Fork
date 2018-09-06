"{ Package: 'stx:clients/TicTacToe' }"

"{ NameSpace: Games }"

TicTacToePlayer subclass:#NewTicTacToePlayer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'games-TicTacToe'
!

!NewTicTacToePlayer class methodsFor:'documentation'!

documentation
"
   a better player (uses an exhaustive alpha-beta search)
   If you make a mistake, it will win.

   2002 by claus
"
! !

!NewTicTacToePlayer methodsFor:'playing'!

bestMoveFor:who in:board
    "simulate a move - return the best move for 'who' to take
     (return a pair: who would win -> if this move was taken)"

    |other toTry best|

    toTry := OrderedCollection new.
    self 
        possibleMovesFor:who in:board 
        do:[:move | |win|

            game board:board atRow:(move y) col:(move x) put:who.
            win := self isWinning:who in:board.
            game board:board atRow:(move y) col:(move x) put:nil.
            win ifTrue:[
                ^ (who -> move).
            ].
            toTry add:move.
        ].

    toTry isEmpty ifTrue:[
        "/ no more moves to make
        ^ nil
    ].

    other := (who == #X) ifTrue:[#O] ifFalse:[#X].

    best := nil.
    toTry do:[:move |
        |bestMoveForOther|

        game board:board atRow:(move y) col:(move x) put:who.
        bestMoveForOther := self 
            bestMoveFor:other 
            in:board.

        game board:board atRow:(move y) col:(move x) put:nil.

        bestMoveForOther isNil ifTrue:[
            "/ the other one cannot make any more moves -
            best isNil ifTrue:[
                best := (nil -> move). "/ remis if move is made
            ].
        ] ifFalse:[
            bestMoveForOther key isNil ifTrue:[
                "/ the best the other can do is a remis
                best isNil ifTrue:[
                    best := (nil -> move). "/ remis if move is made
                ]
            ] ifFalse:[
                bestMoveForOther key == who ifTrue:[
                    "/ the other cannot avoid who to win
                    ^ (who -> move)
                ]
            ]
        ].
    ].

    best isNil ifTrue:[
        "/ other player wins always - sigh
        ^ (other -> nil)
    ].
    ^ best
!

isWinning:who in:aBoard
    "/ 3 in a row ?
    1 to:3 do:[:row |
        (((game board:aBoard atRow:row col:1) == who)
        and:[ ((game board:aBoard atRow:row col:2) == who)
        and:[ ((game board:aBoard atRow:row col:3) == who) ]])
        ifTrue:[
            ^ true.
        ]
    ].
    "/ 3 in a col ?
    1 to:3 do:[:col |
        (((game board:aBoard atRow:1 col:col) == who)
        and:[ ((game board:aBoard atRow:2 col:col) == who)
        and:[ ((game board:aBoard atRow:3 col:col) == who) ]])
        ifTrue:[
            ^ true.
        ]
    ].
    "/ diag1
    (((game board:aBoard atRow:1 col:1) == who)
    and:[ ((game board:aBoard atRow:2 col:2) == who)
    and:[ ((game board:aBoard atRow:3 col:3) == who) ]])
    ifTrue:[
        ^ true.
    ].
    "/ diag2
    (((game board:aBoard atRow:1 col:3) == who)
    and:[ ((game board:aBoard atRow:2 col:2) == who)
    and:[ ((game board:aBoard atRow:3 col:1) == who) ]])
    ifTrue:[
        ^ true.
    ].
    ^ false
!

playNext:who
    |board bestMove|

    board := game board copy.

    bestMove := self bestMoveFor:who in:board.
    bestMove notNil ifTrue:[
        game userPlay:who row:(bestMove value y) col:(bestMove value x).
    ]
!

possibleMovesFor:who in:board do:aBlock
    1 to:3 do:[:row |
        1 to:3 do:[:col |
            (game board:board atRow:row col:col) isNil ifTrue:[
                game board:board atRow:row col:col put:who.    
                aBlock value:(col@row).
                game board:board atRow:row col:col put:nil.    
            ].
        ]      
    ].
! !

!NewTicTacToePlayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe/NewTicTacToePlayer.st,v 1.1 2002-02-15 22:35:28 cg Exp $'
! !
