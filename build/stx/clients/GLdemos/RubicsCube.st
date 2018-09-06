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
"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Demos }"

Object subclass:#RubicsCube
	instanceVariableNames:'subSides moveHistory'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!RubicsCube class methodsFor:'documentation'!

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
    this is the RubicsCubeView's model.

    This is only a data holder for the subCubes' side colors;
    basically - its dump. The only operation supported is to
    rotate one of its planes, and tell dependents about that.
    All drawing is done in the view.

    [start with:]
        RubicsCubeView open

    [author:]
        Claus Gittinger

    [see also:]
        RubicsCubeView
"
! !

!RubicsCube methodsFor:'accessing sides'!

side:side sub:sub
    "fetch a sides (1..6) subCube (1..9) color."

    |idx|

    idx := (side - 1) * 9 + sub.
    ^ subSides at:idx

    "Created: 18.3.1996 / 21:21:09 / cg"
!

side:side sub:sub put:color
    "set a sides (1..6) subCube (1..9) color."

    |idx|

    idx := (side - 1) * 9 + sub.
    subSides at:idx put:color

    "Modified: 18.3.1996 / 21:20:58 / cg"
    "Created: 24.3.1996 / 17:54:31 / cg"
! !

!RubicsCube methodsFor:'history'!

undo
    "undo the last move"

    |lastMove side n|

    moveHistory isEmpty ifTrue:[^ self].

    lastMove := moveHistory removeLast.
    side := lastMove key.
    n := lastMove value.

    1 to:(4 - n) do:[:i |
        self rotate:side
    ].

    self changed

    "Created: 24.3.1996 / 17:30:29 / cg"
!

undoAll
    "undo the last move"

    [moveHistory notEmpty] whileTrue:[
        self undo.
        Delay waitForSeconds:0.1
    ].

    "Created: 24.3.1996 / 17:39:23 / cg"
    "Modified: 24.3.1996 / 18:50:15 / cg"
! !

!RubicsCube methodsFor:'initialization'!

initialize
    "setup the cubes sides"

    subSides := Array new:6*9.


    #(1 2 3 4 5 6) 
    with:#(1 2 3 4 5 6) do:[:side :color |
        1 to:9 do:[:sub |
            self side:side sub:sub put:color
        ]
    ].
    moveHistory := OrderedCollection new.

    "
     RubicsCube new initialize
    "

    "Created: 18.3.1996 / 21:10:43 / cg"
    "Modified: 22.4.1996 / 23:34:19 / cg"
! !

!RubicsCube methodsFor:'misc'!

randomize
    "randomly rotate planes"

    |rnd nMoves whichSide howMuch|

    rnd := Random new.
    nMoves := rnd nextIntegerBetween:20 and:30.
    nMoves timesRepeat:[
        whichSide := rnd nextIntegerBetween:1 and:6.
        howMuch := rnd nextIntegerBetween:1 and:3.
        self rotate:whichSide n:howMuch.
        self changed.
        Delay waitForSeconds:0.1
    ]

    "Created: 24.3.1996 / 17:24:32 / cg"
    "Modified: 24.3.1996 / 17:28:47 / cg"
!

reset
    "reset to intitial state"

    self initialize.
    self changed

    "Created: 24.3.1996 / 17:23:04 / cg"
    "Modified: 24.3.1996 / 17:24:36 / cg"
! !

!RubicsCube methodsFor:'private rotating'!

rotate:side
    "rotate a side (1..6) clockwise"

    |rem idx others spec|

    "/ rotate the facing side itself

    "/
    "/   1 2 3        3 6 9
    "/   4 5 6    ->  2 5 8
    "/   7 8 9        1 4 7
    "/
    rem := (1 to:9) collect:[:i | self side:side sub:i].

    #(1 2 3 4 5 6 7 8 9)
    with:#(7 4 1 8 5 2 9 6 3)
    do:[:src :dst |
        self side:side sub:dst put:(rem at:src)
    ].

    "/ rotate the other faces of the subcubes

"/            p5------p6             *-------*
"/           /|      /|             /|  S3  /|
"/          / |     / |            / |     / |
"/         /  |    /  |           /  |S5  /  |
"/        p1------p2  |          *-------*   |
"/        |   |   |   |          | 4 |   | 2 |
"/        |   p8--|---p7         |S  *---|S--*
"/        |  /    |  /           |  /S1  |  /
"/        | /     | /            | /   S6| /      S1:front S2:right S3:back S4:left
"/        |/      |/             |/      |/       S5:top S6:bottom
"/        p4------p3             *-------*  

"/ S1  S2   S3      S4    S5     S6
"/ red blue magenta white yellow green


    "/
    "/ when rotating side i,
    "/ care for other sides as:

    others := #(
                (
                    "/ side 1 rotation
                    (6 7 6 4 6 1   2 7 2 4 2 1   4 1 4 2 4 3   5 7 5 4 5 1)
                    (4 1 4 2 4 3   6 7 6 4 6 1   5 7 5 4 5 1   2 7 2 4 2 1)
                )                              

                (
                    "/ side 2
                    (1 3 1 6 1 9   5 1 5 2 5 3   3 7 3 4 3 1   6 9 6 8 6 7)
                    (5 1 5 2 5 3   3 7 3 4 3 1   6 9 6 8 6 7   1 3 1 6 1 9)
                )

                (
                    "/ side 3
                    (2 9 2 6 2 3   5 9 5 6 5 3   4 7 4 8 4 9   6 9 6 6 6 3)
                    (5 9 5 6 5 3   4 7 4 8 4 9   6 9 6 6 6 3   2 9 2 6 2 3)
                )

                (
                    "/ side 4
                    (5 9 5 8 5 7   1 7 1 4 1 1   6 1 6 2 6 3   3 3 3 6 3 9)
                    (1 7 1 4 1 1   6 1 6 2 6 3   3 3 3 6 3 9   5 9 5 8 5 7)
                )

                (
                    "/ side 5
                    (4 3 4 6 4 9   3 9 3 8 3 7   2 9 2 8 2 7   1 9 1 8 1 7)
                    (3 9 3 8 3 7   2 9 2 8 2 7   1 9 1 8 1 7   4 3 4 6 4 9)
                )

                (
                    "/ side 6
                    (2 1 2 2 2 3   3 1 3 2 3 3   4 7 4 4 4 1   1 1 1 2 1 3)
                    (3 1 3 2 3 3   4 7 4 4 4 1   1 1 1 2 1 3   2 1 2 2 2 3)
                )
               ).

    spec := others at:side.
    rem := (spec at:1) pairWiseCollect:[:side :sub | self side:side sub:sub].

    idx := 1.
    (spec at:2) pairWiseDo:[:side :sub | 
                        self side:side sub:sub put:(rem at:idx).
                        idx := idx + 1
                ].

    "Modified: 24.3.1996 / 18:14:13 / cg"
! !

!RubicsCube methodsFor:'rotating'!

rotate:side n:nRotates
    "rotate a side (1..6) clockwise; 
     nRotates is the number of 90-degree rotates - use 3 for counter-clockwise rotation"

    1 to:nRotates do:[:r |
        self rotate:side
    ].
    moveHistory addLast:(side -> nRotates).

    self changed

    "Modified: 24.3.1996 / 17:29:04 / cg"
!

startRandomMoveProcessWhile:aBlock
    "fork a process to randomly rotate slides and return the process"

    ^ [
        |rnd side dir|

        rnd := Random new.

        aBlock whileTrue:[
            Delay waitForSeconds:1.

            "/ choose a side

            side := rnd nextIntegerBetween:1 and:6.
        
            "/ which direction ?

            dir := rnd nextBoolean.

            self rotate:side n:(dir ifTrue:1 ifFalse:3)
        ]
    ] forkAt:4.

    "Created: 1.3.1997 / 22:37:51 / cg"
    "Modified: 1.3.1997 / 22:48:30 / cg"
! !

!RubicsCube class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/RubicsCube.st,v 1.9 2016-01-21 18:06:03 cg Exp $'
! !

