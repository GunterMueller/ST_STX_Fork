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




"{ Package: 'stx:clients/PingPong' }"

"{ NameSpace: Games }"

PingPongObject subclass:#PingPongBall
	instanceVariableNames:'movingProcess'
	classVariableNames:'Tick MinSpeedX'
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongBall class methodsFor:'documentation'!

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

!PingPongBall class methodsFor:'initialization'!

initialize
    Tick := 20.         "/ milliseconds
    MinSpeedX := 60.     "/ pixels per second

    "Created: / 13.12.1999 / 12:40:07 / cg"
    "Modified: / 13.12.1999 / 19:03:08 / cg"
! !

!PingPongBall methodsFor:'accessing'!

maxXVelocity
    ^ 400 + (game numberOfGamesPlayed * 9).

    "Created: / 13.12.1999 / 19:05:31 / cg"
    "Modified: / 13.12.1999 / 20:57:12 / cg"
!

minXVelocity
    ^ 140

    "Created: / 13.12.1999 / 19:05:44 / cg"
!

xVel
    "return the value of the instance variable 'xVel' (automatically generated)"

    ^ xVel
!

xVel:something
    "set the value of the instance variable 'xVel' (automatically generated)"

    xVel := something.
!

yVel
    "return the value of the instance variable 'yVel' (automatically generated)"

    ^ yVel
!

yVel:something
    "set the value of the instance variable 'yVel' (automatically generated)"

    yVel := something.
! !

!PingPongBall methodsFor:'bouncing'!

bounceX
    xVel := xVel negated
!

bounceY
    yVel := yVel negated
! !

!PingPongBall methodsFor:'displaying'!

clearIn:aGC
    aGC paint:(aGC viewBackground).
    aGC fillCircleX:xPos y:yPos radius:(width // 2).
!

displayIn:aGC
    aGC paint:Color white.
    aGC fillCircleX:xPos y:yPos radius:(width // 2).
! !

!PingPongBall methodsFor:'moving'!

doMove
    |newX newY newPos tps|

    tps := 1000 / Tick. "/ ticks per second
    newX := xPos + (xVel / tps).
    newY := yPos + (yVel / tps).

    newPos := game aboutToMove:self to:(newX @ newY).
    newPos isNil ifTrue:[
        self game:nil.
        ^ false
    ].
    self xPos:(newPos x) yPos:(newPos y).
    ^ true

    "Modified: / 13.12.1999 / 23:29:16 / cg"
!

startMoving
    movingProcess isNil ifTrue:[
        movingProcess := [
                            [
                                |stillMoving|

                                stillMoving := true.
                                [stillMoving] whileTrue:[
                                    Delay waitForMilliseconds:Tick.
                                    stillMoving := self doMove.
                                ]
                            ] valueOnUnwindDo:[
                                movingProcess := nil
                            ]
                         ] fork.
    ].

    "Modified: / 13.12.1999 / 12:40:24 / cg"
!

stopMoving
    movingProcess notNil ifTrue:[movingProcess terminate]
! !

!PingPongBall class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongBall.st,v 1.10 2005-01-07 12:37:57 cg Exp $'
! !

PingPongBall initialize!
