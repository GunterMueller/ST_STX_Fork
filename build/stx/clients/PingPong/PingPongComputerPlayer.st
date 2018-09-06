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

PingPongPlayer subclass:#PingPongComputerPlayer
	instanceVariableNames:'playingProcess'
	classVariableNames:'Tick'
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongComputerPlayer class methodsFor:'documentation'!

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

!PingPongComputerPlayer class methodsFor:'initialization'!

initialize
    Tick := 50

    "Created: / 13.12.1999 / 23:04:16 / cg"
! !

!PingPongComputerPlayer methodsFor:'misc'!

recomputeVelocity

    "Created: / 13.12.1999 / 23:15:19 / cg"
! !

!PingPongComputerPlayer methodsFor:'playing'!

doPlay
    |ball ballY halfHeight yWant dY maxSpeed xBall gameExt gameWidth|

    ball := game ball.
    xBall := ball xPos.
    gameExt := game gameFieldExtent.
    gameWidth := gameExt x.

    ball xVel < 0 ifTrue:[ 
        "/ ball moving away - want to move towards the center

        yWant := gameExt y // 2.
        dY := yWant - yPos.
        dY := dY / 10 * (Random nextIntegerBetween:0 and:10).
    ] ifFalse:[
        "/ ball moving towards us - want to move with the ball

        "/ add some sleepy factor.
        "/ there is some chance, that the computer player 'forgets'
        "/ to make a move.
        "/ (otherwise, its not fun to play against the computer)
        xBall < (gameWidth // 8) ifTrue:[
            (Random nextIntegerBetween:0 and:10) < 8 ifTrue:[
                ^ self
            ]
        ] ifFalse:[
            xBall < (gameWidth // 4) ifTrue:[
                (Random nextIntegerBetween:0 and:10) < 6 ifTrue:[
                    ^ self
                ]
            ] ifFalse:[
                xBall < (gameWidth // 2) ifTrue:[
                    (Random nextIntegerBetween:0 and:10) < 3 ifTrue:[
                        ^ self
                    ]
                ].
            ].
        ].

        ballY := ball yPos.
        halfHeight := height//2.

        yWant := ballY 
                    clampBetween:halfHeight 
                    and:(gameExt y - halfHeight).
        dY := yWant - yPos.
    ].

    maxSpeed := 6.5.
    maxSpeed := maxSpeed + ((game numberOfGamesPlayed // 10) * 1.3).
    dY := dY rounded.
    dY := dY clampBetween:maxSpeed negated and:maxSpeed.

    yVel := (dY * (1000 / Tick)) rounded.
    dY ~= 0 ifTrue:[
        lastMoveTime := Timestamp now.
        self yPos:( yPos + dY )
    ].

    "Created: / 13.12.1999 / 13:11:38 / cg"
    "Modified: / 15.12.1999 / 22:59:28 / cg"
!

startPlaying
    playingProcess isNil ifTrue:[
        playingProcess := [
                            [   
                                |stillPlaying|

                                stillPlaying := true.
                                [stillPlaying] whileTrue:[
                                    Delay waitForMilliseconds:Tick.
                                    stillPlaying := self doPlay.
                                ]
                            ] valueOnUnwindDo:[
                                playingProcess := nil
                            ]
                         ] fork.
    ].

    "Created: / 13.12.1999 / 13:11:22 / cg"
    "Modified: / 13.12.1999 / 23:04:25 / cg"
!

stopPlaying
    playingProcess notNil ifTrue:[playingProcess terminate]

    "Created: / 13.12.1999 / 13:13:53 / cg"
! !

!PingPongComputerPlayer methodsFor:'queries'!

isHuman
    ^ false


! !

!PingPongComputerPlayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongComputerPlayer.st,v 1.11 2005-01-07 12:37:43 cg Exp $'
! !

PingPongComputerPlayer initialize!
