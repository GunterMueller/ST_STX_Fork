"
    COPYRIGHT (c) 1999 by eXept Software AG
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

Model subclass:#PingPongObject
	instanceVariableNames:'game xPos yPos width height xVel yVel lock'
	classVariableNames:''
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongObject class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1999 by eXept Software AG
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





! !

!PingPongObject class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: / 15.12.1999 / 22:58:24 / cg"
! !

!PingPongObject methodsFor:'accessing'!

attemptToMoveToyPos:something
    "human move"

    |halfHeight newY|

    halfHeight := height // 2.
    newY := something 
                clampBetween:halfHeight 
                and:(game gameFieldExtent y - halfHeight).
    newY ~~ yPos ifTrue:[
        self yPos:newY
    ].

    "Modified: / 13.12.1999 / 19:03:47 / cg"
!

game
    "return the value of the instance variable 'game' (automatically generated)"

    ^ game!

game:aGame
    "set game in which i am in"

    aGame isNil ifTrue:[
        self changed:#aboutToGo.
    ] ifFalse:[
        self changed:#aboutToCom
    ].
    game := aGame.

    "Modified: / 15.12.1999 / 22:56:23 / cg"
!

height
    "return the value of the instance variable 'height' (automatically generated)"

    ^ height!

height:something
    "set the value of the instance variable 'height' (automatically generated)"

    lock critical:[
        self changed:#aboutToResize.
        height := something.
        self changed:#resized.
    ]

    "Modified: / 15.12.1999 / 22:56:45 / cg"
!

maxXVelocity
    ^ 9999

    "Created: / 13.12.1999 / 19:04:37 / cg"
!

minXVelocity
    ^ 0

    "Created: / 13.12.1999 / 19:04:49 / cg"
!

width
    "return the value of the instance variable 'width' (automatically generated)"

    ^ width!

width:something
    "set the value of the instance variable 'width' (automatically generated)"

    lock critical:[
        self changed:#aboutToResize.
        width := something.
        self changed:#resized.
    ]

    "Modified: / 15.12.1999 / 22:56:57 / cg"
!

xPos
    "return the value of the instance variable 'xPos' (automatically generated)"

    ^ xPos!

xPos:something
    "set the value of the instance variable 'xPos' (automatically generated)"

    something ~= xPos ifTrue:[
        lock critical:[
            self changed:#aboutToMove.
            xPos := something.
            self changed:#moved.
        ]
    ]

    "Modified: / 15.12.1999 / 22:57:07 / cg"
!

xPos:newX yPos:newY
    "move the object"

    lock critical:[
        self changed:#aboutToMove.
        xPos := newX.
        yPos := newY.
        self changed:#moved.
    ]

    "Modified: / 15.12.1999 / 22:57:16 / cg"
!

xVel
    "return the value of the instance variable 'xVel' (automatically generated)"

    ^ xVel

    "Created: / 10.12.1999 / 18:39:45 / cg"
!

xVel:something
    "set the value of the instance variable 'xVel' (automatically generated)"

    xVel := something.

    "Created: / 10.12.1999 / 18:39:47 / cg"
!

yPos
    "return the value of the instance variable 'yPos' (automatically generated)"

    ^ yPos!

yPos:something
    "set the value of the instance variable 'yPos' (automatically generated)"

    something ~= yPos ifTrue:[
        lock critical:[
            self changed:#aboutToMove.
            yPos := something.
            self changed:#moved.
        ]
    ]

    "Modified: / 15.12.1999 / 22:57:27 / cg"
!

yVel
    "return the value of the instance variable 'yVel' (automatically generated)"

    ^ yVel

    "Created: / 10.12.1999 / 18:39:49 / cg"
!

yVel:something
    "set the value of the instance variable 'yVel' (automatically generated)"

    yVel := something.

    "Created: / 10.12.1999 / 18:39:52 / cg"
! !

!PingPongObject methodsFor:'bouncing'!

addToXVel:someValue
    |maxVel|

    maxVel := self maxXVelocity + (game numberOfGamesPlayed * 10).
    xVel := (xVel + someValue) clampBetween:maxVel negated and:maxVel.
    xVel > 0 ifTrue:[
        xVel := xVel max:self minXVelocity.
    ] ifFalse:[
        xVel := xVel min:self minXVelocity negated.
    ].

    "Created: / 10.12.1999 / 18:39:58 / cg"
    "Modified: / 13.12.1999 / 20:03:24 / cg"
!

addToYVel:someValue
    yVel := (yVel + someValue) clampBetween:-250 and:250.

    "Created: / 10.12.1999 / 18:40:01 / cg"
    "Modified: / 14.12.1999 / 02:09:54 / cg"
!

bounceX
    xVel := xVel negated

    "Created: / 10.12.1999 / 18:40:04 / cg"
!

bounceY
    yVel := yVel negated

    "Created: / 10.12.1999 / 18:40:07 / cg"
! !

!PingPongObject methodsFor:'displaying'!

clearIn:aGC
    |x y|

    x := xPos - (width // 2).
    y := yPos - (height // 2).
    aGC clearRectangleX:x y:y width:width height:height
!

displayIn:aGC
    |x y|

    x := xPos - (width // 2).
    y := yPos - (height // 2).
    aGC paint:Color white.
    aGC fillRectangleX:x y:y width:width height:height
! !

!PingPongObject methodsFor:'initialization'!

initialize
    lock := Semaphore forMutualExclusion.

    "Created: / 15.12.1999 / 22:57:54 / cg"
! !

!PingPongObject methodsFor:'misc'!

randomizeXVel:someValue

    "Created: / 10.12.1999 / 18:31:02 / cg"
! !

!PingPongObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongObject.st,v 1.10 1999-12-15 22:01:04 cg Exp $'
! !
