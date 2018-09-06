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

ApplicationModel subclass:#PingPongGame
	instanceVariableNames:'leftPlayer rightPlayer ball gameFieldExtent leftScore rightScore
		secondsTillStart messageHolder playersReady waitingForReady
		paused'
	classVariableNames:''
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongGame class methodsFor:'documentation'!

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



!

documentation
"
    Simple by todays standards, but fun when played in two-player mode

    [author:]
         (cg@smc1)

    [start with:]
         Games::PingPongGame open
         Games::PingPongGame open2PlayerGame

"
!

examples
"
                                                                [exBegin]
    Games::PingPongGame open
                                                                [exEnd]


                                                                [exBegin]
    Games::PingPongGame open2PlayerGame
                                                                [exEnd]
"
! !

!PingPongGame class methodsFor:'helpers'!

askForOtherScreen
    |parts displayName|

    displayName := Dialog 
                        request:'Other players display:' 
                        initialAnswer:'host:0'
                        initialSelection:(1 to:4).
    displayName size == 0 ifTrue:[^ nil].

    parts := displayName asCollectionOfSubstringsSeparatedBy:$:.
    parts size == 1 ifTrue:[
        displayName := displayName , ':0'.
    ].
    ^ displayName

    "
     self askForOtherScreen 
    "
!

askOtherPlayerOn:aDevice
    |answer|

    Screen currentScreenQuerySignal answer:aDevice do:[
        answer := Dialog 
                    confirm:('Would you like to play a game of PingPong with %1 ?:'
                              bindWith:OperatingSystem getFullUserName). 
    ].

    ^ answer

    "
     self askOtherPlayerOn:Display        
    "

    "Created: / 13.12.1999 / 13:39:59 / cg"
    "Modified: / 13.12.1999 / 13:40:30 / cg"
!

openXDisplayOn:aDisplayName
    |newDevice someScreen|

    newDevice := XWorkstation new.
    [ 
        newDevice := newDevice initializeFor:aDisplayName.
    ] on:newDevice deviceErrorSignal do:[
        self warn:('Could not open display: ' , aDisplayName).
        ^ nil.
    ].
    newDevice startDispatch.
    (someScreen := Screen current) isNil ifTrue:[
        someScreen := Screen default.
    ].
    someScreen notNil ifTrue:[
        newDevice keyboardMap:(someScreen keyboardMap).
        newDevice buttonTranslation:(someScreen buttonTranslation).
    ].

    "/ arrange for it to finish its event dispatch loop, 
    "/ when the last view on it is closed.
    newDevice exitOnLastClose:true.

    ^ newDevice
! !

!PingPongGame class methodsFor:'start'!

open
    |game fieldSize|

    "/ use the smaller display's size as field size ...
    fieldSize := Screen current extent.
    fieldSize := 400 @ 250.

    game := self basicNew 
                initializeForField:fieldSize 
                computerPlayer:true.

    "/
    "/ open the game on the local screen
    "/
    game 
        openOnDevice:Screen current 
        title:'Left player'
        controlledPlayer:game leftPlayer.

    "
     PingPongGame open
    "





!

open2PlayerGame
    |game otherDisplayName otherDevice fieldSize|

    "/
    "/ ask for and open a game for the other player on another screen ...
    "/
    otherDisplayName := self askForOtherScreen.
    otherDisplayName isNil ifTrue:[^ self].

    otherDevice := self openXDisplayOn:otherDisplayName.
    otherDevice isNil ifTrue:[^ self].

    otherDevice exitOnLastClose:false.
    "/ ask other player
    (self askOtherPlayerOn:otherDevice) ifFalse:[
        otherDevice close.
        (self confirm:'The other player does not want to play.

Play against the computer then ?')
        ifFalse:[
            ^ self
        ].
        ^self open
    ].

    "/ use the smaller display's size as field size ...
    fieldSize := Screen current extent min:(otherDevice extent).
    fieldSize := 400 @ 250.

    game := self basicNew 
                initializeForField:fieldSize
                computerPlayer:false.

    "/
    "/ open the game on the local screen
    "/
    game 
        openOnDevice:Screen current 
        title:'Left player'
        controlledPlayer:game leftPlayer.

    "/
    "/ open the game on the remote screen
    "/
    game 
        openOnDevice:otherDevice 
        title:'Right player'
        controlledPlayer:game rightPlayer.

    otherDevice exitOnLastClose:true.

    "
     PingPongGame open2PlayerGame
    "

    "Modified: / 13.12.1999 / 13:49:08 / cg"
    "Created: / 13.12.1999 / 22:24:21 / cg"
! !

!PingPongGame methodsFor:'accessing'!

ball
    "return the value of the instance variable 'ball' (automatically generated)"

    ^ ball
!

ball:something
    "set the value of the instance variable 'ball' (automatically generated)"

    ball := something.
!

gameFieldExtent
    "return the value of the instance variable 'gameFieldExtent' (automatically generated)"

    ^ gameFieldExtent
!

gameFieldExtent:something
    "set the value of the instance variable 'gameFieldExtent' (automatically generated)"

    gameFieldExtent := something.
!

leftPlayer
    "return the value of the instance variable 'leftPlayer' (automatically generated)"

    ^ leftPlayer
!

leftPlayer:something
    "set the value of the instance variable 'leftPlayer' (automatically generated)"

    leftPlayer := something.
!

numberOfGamesPlayed
    ^ leftScore value + rightScore value.

    "Created: / 13.12.1999 / 18:26:58 / cg"
!

rightPlayer
    "return the value of the instance variable 'rightPlayer' (automatically generated)"

    ^ rightPlayer
!

rightPlayer:something
    "set the value of the instance variable 'rightPlayer' (automatically generated)"

    rightPlayer := something.
! !

!PingPongGame methodsFor:'aspects'!

leftScore
    "return the holder on the left scrore"

    ^ leftScore ifNil:[leftScore := 0 asValue].
!

messageHolder
    ^ messageHolder ifNil:[messageHolder := '' asValue].
!

rightScore
    "return the holder on the right scrore"

    ^ rightScore ifNil:[rightScore := 0 asValue].
! !

!PingPongGame methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "/ forward to views
    self changed:something with:changedObject

! !

!PingPongGame methodsFor:'initialization'!

initialize
    super initialize.
    self initializeScore.
    paused := false.

    gameFieldExtent isNil ifTrue:[
        gameFieldExtent := 400 @ 300.
    ].

    leftPlayer := PingPongPlayer new.
    leftPlayer game:self.
    leftPlayer 
        width:10; height:100; 
        xPos:10; yPos:(gameFieldExtent y // 2).

    rightPlayer isNil ifTrue:[
        rightPlayer := PingPongPlayer new.
    ].

    rightPlayer game:self.
    rightPlayer 
        width:10; height:100; 
        xPos:(gameFieldExtent x - 10); yPos:(gameFieldExtent y // 2).

    leftPlayer addDependent:self.
    rightPlayer addDependent:self.

    self prepareNewBall.

    "Modified: / 13.12.1999 / 20:40:02 / cg"
!

initializeForField:anExtent computerPlayer:againstComputer
    gameFieldExtent := anExtent.
    againstComputer ifTrue:[
        rightPlayer := PingPongComputerPlayer new.
    ].
    self initialize.



!

initializeScore
    self leftScore value:0.
    self rightScore value:0.


!

setRandomBallVelocity
    |randomVelocityX randomVelocityY minXVelocity|

    minXVelocity := ball minXVelocity.

    randomVelocityX := Random nextIntegerBetween:minXVelocity 
                              and:(minXVelocity + 40 + (self numberOfGamesPlayed * 2)).

    (Random nextIntegerBetween:1 and:10) >= 5 ifTrue:[
        randomVelocityX := randomVelocityX negated.
    ].
    randomVelocityY := Random nextIntegerBetween:-40 and:40.

    ball xVel:randomVelocityX; yVel:randomVelocityY.

    "Modified: / 14.12.1999 / 02:19:27 / cg"
! !

!PingPongGame methodsFor:'playing'!

aboutToMove:someObject to:newPos
    |oldX oldY newX newY height halfWidth halfHeight delta
     leftPlayersRight rightPlayersLeft 
     newLeft newRight newTop newBot 
     leftTop leftBot rightTop rightBot 
     leftHalfHeight rightHalfHeight dX dY pX pY|

    height := someObject height.
    halfWidth := someObject width // 2.
    halfHeight := height // 2.

    oldX := someObject xPos.
    oldY := someObject yPos.
    newX := newPos x.
    newY := newPos y.

    newLeft := newX - halfWidth.
    newRight := newX + halfWidth.

"/    newLeft < 0 ifTrue:[
"/        someObject bounceX.
"/        newLeft := newLeft negated.
"/        newX := newLeft + halfWidth.
"/    ] ifFalse:[
"/        newRight > gameFieldExtent x ifTrue:[
"/            someObject bounceX.
"/            delta := newRight - gameFieldExtent x.    
"/            newRight := (gameFieldExtent x - delta).
"/            newX := newRight - halfWidth
"/        ]
"/    ].

    newTop := newY - halfHeight.
    newBot := newY + halfHeight.
    newTop < 0 ifTrue:[
        someObject bounceY.
        newTop := newTop negated.
        newY := newTop + halfHeight.
    ] ifFalse:[
        newBot > gameFieldExtent y ifTrue:[
            someObject bounceY.
            delta := newBot - gameFieldExtent y.    
            newBot := (gameFieldExtent y - delta).
            newY := newBot - halfHeight.
        ]
    ].

    leftPlayersRight := (leftPlayer xPos + (leftPlayer width//2)).

    newLeft <= leftPlayersRight ifTrue:[
        leftHalfHeight := leftPlayer height//2.

        "/ compute the intersection of the ball with the players
        "/ paddle
        dX := newX - oldX.
        dY := newY - oldY.
        pX := leftPlayer xPos - oldX.
        pY := (dY / dX * pX) rounded.
        pY := pY + oldY.

        "/ bounce ?
        leftTop := leftPlayer yPos - leftHalfHeight.
        leftBot := leftPlayer yPos + leftHalfHeight.

        (pY between:(leftTop-height) and:(leftBot+height)) 
        ifTrue:[
            someObject bounceX.
            self randomizeYVelocityOf:ball.
            newLeft := (newLeft - leftPlayersRight) negated + leftPlayersRight.
            newX := newLeft + halfWidth.
            self adjustBallsVelocityFor:leftPlayer.

            "/ additional effay, if ball is hit near the paddles corner
            (pY <= (leftTop+5)) ifTrue:[
                pY > 10 ifTrue:[
                    ball addToYVel:-250. "/ yVel:-250.
                    ball addToXVel:250. 
                ]
            ] ifFalse:[
                (pY >= (leftBot-5)) ifTrue:[
                    pY < (gameFieldExtent y-10) ifTrue:[
                        ball addToYVel:250. "/ yVel:250.
                        ball addToXVel:250. 
                    ]    
                ]
            ].
        ] ifFalse:[
            rightScore value:(rightScore value + 1).
            someObject xPos:pX yPos:pY.
            self prepareNewBall.
            ^ nil.  "/ go away
        ]
    ].

    rightPlayersLeft := (rightPlayer xPos - (rightPlayer width//2)).
    newRight >= rightPlayersLeft ifTrue:[
        rightHalfHeight := rightPlayer height//2.

        "/ compute the intersection of the ball with the players
        "/ paddle
        dX := newX - oldX.
        dY := newY - oldY.
        pX := rightPlayersLeft - oldX.
        pY := (dY / dX * pX) rounded.
        pY := pY + oldY.

        "/ bounce ?
        rightTop := rightPlayer yPos - rightHalfHeight.
        rightBot := rightPlayer yPos + rightHalfHeight.

        (pY between:(rightTop-height) and:(rightBot+height)) 
        ifTrue:[
            someObject bounceX.
            "/ add some randomness...
            self randomizeYVelocityOf:ball.

            delta := newRight - rightPlayersLeft. 
            newRight := rightPlayersLeft - delta.
            newX := newRight - halfWidth.
            self adjustBallsVelocityFor:rightPlayer.

            "/ additional effay, if ball is hit near the paddles corner
            (pY <= (rightTop+5)) ifTrue:[
                pY > 10 ifTrue:[
                    ball addToYVel:-250. "/ yVel:-250.
                    ball addToXVel:-250. 
                ]
            ] ifFalse:[
                (pY >= (rightBot-5)) ifTrue:[
                    pY < (gameFieldExtent y-10) ifTrue:[
                        ball addToYVel:250. "/ yVel:250.
                        ball addToXVel:-250. 
                    ]
                ].
            ].
        ] ifFalse:[
            leftScore value:(leftScore value + 1).
            someObject xPos:pX yPos:pY.
            self prepareNewBall.
            ^ nil.  "/ go away
        ]
    ].

    ^ newX @ newY

    "Modified: / 14.12.1999 / 01:44:17 / cg"
!

adjustBallsVelocityFor:aPlayer
    |vel vX dX vAbs|

    aPlayer recomputeVelocity.

    vel := aPlayer yVel.
    vel notNil ifTrue:[
        vX := ball xVel.
        "/ slow down ball, if paddle is not moving
        dX := 0.
        vel < 60 ifTrue:[
            dX := (vX // 4) negated.
        ].

        ball addToYVel:(vel // 2).

        "/ some of the paddles velocity is added to the balls speed
        vAbs := vel "abs".
        vX > 0 ifTrue:[
            dX := dX + vAbs.
        ] ifFalse:[
            dX := dX - vAbs.
        ].
        ball addToXVel:dX.
    ]

    "Modified: / 06-08-2007 / 02:00:22 / cg"
!

makePaddlesSmaller
    leftPlayer height:(leftPlayer height - 15 max:30).
    rightPlayer height:(rightPlayer height - 15 max:30).

    Delay waitForSeconds:0.3.

    "Created: / 13.12.1999 / 18:41:02 / cg"
!

newBall
    |oldBall|

    (self numberOfGamesPlayed \\ 8) == 0 ifTrue:[
        self makePaddlesSmaller.
    ].

    ball := PingPongBall new.
    ball game:self.
    ball 
        width:10; height:10; 
        xPos:(gameFieldExtent x // 2); yPos:(gameFieldExtent y // 2).

    self setRandomBallVelocity.

    ball addDependent:self.

    "Modified: / 14.12.1999 / 02:22:20 / cg"
!

pause
    waitingForReady ifTrue:[^ self].

    paused := paused not.

    paused ifTrue:[
        rightPlayer stopPlaying.
        leftPlayer stopPlaying.
        ball stopMoving.
        self messageHolder value:'paused'.
    ] ifFalse:[
        rightPlayer startPlaying.
        leftPlayer startPlaying.
        ball startMoving.
        self messageHolder value:'play'.
    ].
!

playerIsReady:aPlayer
    |otherPlayer|

    waitingForReady ifFalse:[^ self].

    playersReady ifNil:[playersReady := IdentitySet new].
    playersReady add:aPlayer.

    (otherPlayer := aPlayer) == leftPlayer ifTrue:[
        otherPlayer := rightPlayer.
    ].
    otherPlayer isHuman ifFalse:[
        playersReady add:otherPlayer.
    ].

    playersReady size = 2 ifTrue:[
        self messageHolder value:'play'.
        self startTheGame.
    ]
        
!

prepareNewBall
    rightPlayer isHuman ifFalse:[
        rightPlayer stopPlaying
    ].

    rightPlayer isHuman ifTrue:[
        self messageHolder value:'take paddles to start'.
    ] ifFalse:[
        self messageHolder value:'take paddle to start'.
    ].

    self newBall.
    waitingForReady := true.
    rightPlayer isHuman ifFalse:[
        rightPlayer startPlaying
    ].

    "Modified: / 14.12.1999 / 02:05:02 / cg"
!

randomizeYVelocityOf:someObject
    |rnd|

    rnd := Random nextIntegerBetween:-20 and:20.
    someObject addToYVel:rnd.

    "Created: / 13.12.1999 / 23:24:21 / cg"
    "Modified: / 13.12.1999 / 23:24:53 / cg"
!

startTheGame
    waitingForReady := false.
    playersReady := nil.

    rightPlayer startPlaying.
    leftPlayer startPlaying.
    ball startMoving.

    "Modified: / 13.12.1999 / 15:37:36 / cg"
! !

!PingPongGame methodsFor:'release'!

stop
    waitingForReady := false.
    ball stopMoving.

    (leftPlayer isHuman 
    and:[rightPlayer isHuman]) ifTrue:[
        self messageHolder value:'Partner finished game.'.
    ].

    leftPlayer stopPlaying.
    rightPlayer stopPlaying.

    "Modified: / 13.12.1999 / 15:31:52 / cg"
! !

!PingPongGame methodsFor:'view opening'!

openOnDevice:aDevice title:titleString controlledPlayer:controlledPlayer
    "open a game view on some screen"

    Screen currentScreenQuerySignal answer:aDevice
    do:[
        |topView gameView leftScoreLabel rightScoreLabel messageLabel ext sep|

        topView := StandardSystemView new.
        topView label:'PingPong-',titleString.
        ext := gameFieldExtent+(0@30).
        topView extent:ext.
        topView minExtent:ext; maxExtent:ext.
        topView icon:(Smalltalk imageFromFileNamed:'PingPong.xbm' forClass:self class).

        gameView := PingPongView new.
        gameView layout:(LayoutFrame
                            leftFraction:0.0 offset:0 
                            rightFraction:1.0 offset:0 
                            topFraction:0.0 offset:0 
                            bottomFraction:1.0 offset:-30).
        topView add:gameView.

        sep := View new.
        sep layout:(LayoutFrame
                            leftFraction:0.0 offset:0 
                            rightFraction:1.0 offset:0 
                            topFraction:1.0 offset:-30 
                            bottomFraction:1.0 offset:-29).
        topView add:sep.
        sep viewBackground:Color white.

        leftScoreLabel := Label new.
        leftScoreLabel sizeFixed:true.
        leftScoreLabel layout:(LayoutFrame
                            leftFraction:0.0 offset:0 
                            rightFraction:0.0 offset:100 
                            topFraction:1.0 offset:-29 
                            bottomFraction:1.0 offset:0).
        leftScoreLabel labelChannel:(TypeConverter onNumberValue:self leftScore).
        leftScoreLabel backgroundColor:(gameView viewBackground).
        leftScoreLabel foregroundColor:Color white.
        topView add:leftScoreLabel.

        rightScoreLabel := Label new.
        rightScoreLabel layout:(LayoutFrame
                            leftFraction:1.0 offset:-100 
                            rightFraction:1.0 offset:0 
                            topFraction:1.0 offset:-29 
                            bottomFraction:1.0 offset:0).
        rightScoreLabel sizeFixed:true.
        rightScoreLabel labelChannel:(TypeConverter onNumberValue:self rightScore).
        rightScoreLabel backgroundColor:(gameView viewBackground).
        rightScoreLabel foregroundColor:Color white.
        topView add:rightScoreLabel.

        messageLabel := Label new.
        messageLabel layout:(LayoutFrame
                            leftFraction:0.5 offset:-100 
                            rightFraction:0.5 offset:100 
                            topFraction:1.0 offset:-29 
                            bottomFraction:1.0 offset:0).
        messageLabel sizeFixed:true.
        messageLabel labelChannel:self messageHolder.
        messageLabel backgroundColor:(gameView viewBackground).
        messageLabel foregroundColor:Color white.
        topView add:messageLabel.

        gameView game:self.
        gameView controlledPlayer:controlledPlayer.

        topView backgroundColor:(gameView viewBackground).
        topView open.
    ]

    "Modified: / 13.12.1999 / 19:46:41 / cg"
! !

!PingPongGame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongGame.st,v 1.15 2012-07-19 12:50:54 stefan Exp $'
! !
