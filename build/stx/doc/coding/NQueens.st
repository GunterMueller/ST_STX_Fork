"{ Package: 'stx:doc/coding' }"

"{ NameSpace: Demos }"

Object subclass:#NQueens
	instanceVariableNames:'solutions'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Programming'
!

ByteArray variableByteSubclass:#Board
	instanceVariableNames:'dim'
	classVariableNames:''
	poolDictionaries:''
	privateIn:NQueens
!


!NQueens methodsFor:'solving'!

place:nQueens into:aBoard
    self place:nQueens into:aBoard placesInto:(Array new:nQueens) startPlacingAfter:nil
!

place:nQueens into:aBoard placesInto:places startPlacingAfter:pos1
    |pos|

    nQueens == 0 ifTrue:[
        solutions add:places copy.
        "/ aBoard printOn:Transcript.
        ^ true
    ].

    pos := pos1.

    [
        pos := aBoard nextFreePositionAfter:pos.
        pos isNil ifTrue:[
            places at:nQueens put:nil.
            ^ false.
        ].
        (self position:pos isSaveIn:aBoard) ifTrue:[
            aBoard atRow:pos y col:pos x put:1.
            places at:nQueens put:pos.
            (self place:nQueens-1 into:aBoard placesInto:places startPlacingAfter:pos) ifTrue:[
                 "/ ^ true.
            ].

            aBoard atRow:pos y col:pos x put:0.
        ].
    ] loop
!

position:pos isSaveIn:aBoard
    (aBoard hasQueenInRow:(pos y)) ifTrue:[^ false].
    (aBoard hasQueenInCol:(pos x)) ifTrue:[^ false].
    (aBoard hasQueenInDiagonals:pos) ifTrue:[^ false].
    ^ true
!

solve
    |b|

    solutions := OrderedCollection new.
    self place:10 into:(b := Board new:10).
    b printOn:Transcript.
    solutions size printOn:Transcript.
! !

!NQueens::Board class methodsFor:'instance creation'!

new:n
    ^ (super new:n*n) dim:n
! !

!NQueens::Board methodsFor:'accessing'!

atRow:row col:col
    ^ self at:(row-1*dim + col)
!

atRow:row col:col put:newValue
    ^ self at:(row-1*dim + col) put:newValue
!

dim:something
    "set the value of the instance variable 'dim' (automatically generated)"

    dim := something.
! !

!NQueens::Board methodsFor:'printing'!

printOn:aStream
    1 to: dim do:[:row |
        1 to: dim do:[:col |
            aStream nextPutAll:'+---'.
        ].
        aStream nextPutAll:'+'.
        aStream cr.

        1 to: dim do:[:col |
            aStream nextPutAll:'|'.
            aStream nextPutAll:'   '.
        ].
        aStream nextPutAll:'|'.
        aStream cr.

        1 to: dim do:[:col |
            |v|

            v := self atRow:row col:col.

            aStream nextPutAll:'|'.
            v == 0 ifTrue:[
                aStream nextPutAll:'   '.
            ] ifFalse:[
                aStream nextPutAll:' * '.
            ].
        ].
        aStream nextPutAll:'|'.
        aStream cr.

        1 to: dim do:[:col |
            aStream nextPutAll:'|'.
            aStream nextPutAll:'   '.
        ].
        aStream nextPutAll:'|'.
        aStream cr.
    ].

    1 to: dim do:[:col |
        aStream nextPutAll:'+---'.
    ].
    aStream nextPutAll:'+'.
    aStream cr.
! !

!NQueens::Board methodsFor:'searching'!

hasQueenInCol:col
    1 to:dim do:[:row | (self atRow:row col:col) ~~ 0 ifTrue:[^ true]].
    ^ false
!

hasQueenInDiagonals:pos
    |pRow pCol row col|

    pRow := pos y.
    pCol := pos x.

    (self atRow:pRow col:pCol) ~~ 0 ifTrue:[^ true].

    row := pRow+1. col := pCol+1.    
    [ 
        row <= dim and:[col <= dim]
    ] whileTrue:[
        (self atRow:row col:col) ~~ 0 ifTrue:[^ true].
        row := row + 1.
        col := col + 1.
    ].

    row := pRow-1. col := pCol-1.    
    [ 
        row >= 1 and:[col >= 1]
    ] whileTrue:[
        (self atRow:row col:col) ~~ 0 ifTrue:[^ true].
        row := row - 1.
        col := col - 1.
    ].

    row := pRow-1. col := pCol+1.    
    [ 
        row >= 1 and:[col <= dim]
    ] whileTrue:[
        (self atRow:row col:col) ~~ 0 ifTrue:[^ true].
        row := row - 1.
        col := col + 1.
    ].

    row := pRow+1. col := pCol-1.    
    [ 
        row <= dim and:[col >= 1]
    ] whileTrue:[
        (self atRow:row col:col) ~~ 0 ifTrue:[^ true].
        row := row + 1.
        col := col - 1.
    ].

    ^ false
!

hasQueenInRow:row
    1 to:dim do:[:col | (self atRow:row col:col) ~~ 0 ifTrue:[^ true]].
    ^ false
!

nextFreePositionAfter:pos
    |row col|

    pos isNil ifTrue:[
        row := 1. col := 1.
    ] ifFalse:[
        row := pos y. col := pos x + 1.
    ].
    [
        col > dim ifTrue:[
            col := 1.
            row := row + 1.
            row > dim ifTrue:[^ nil].
        ].
        (self atRow:row col:col) == 0 ifTrue:[
            ^ col @ row
        ].
        col := col + 1.
    ] loop.
! !

!NQueens class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/NQueens.st,v 1.1 2003-06-16 09:26:40 cg Exp $'
! !
