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

View subclass:#PingPongView
	instanceVariableNames:'game controlledPlayer'
	classVariableNames:''
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongView class methodsFor:'documentation'!

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

examples
"
                                                                [exBegin]
    Games::PingPongGame open
                                                                [exEnd]


                                                                [exBegin]
    Games::PingPongGame openTwoPlayer
                                                                [exEnd]
"

! !

!PingPongView methodsFor:'accessing'!

controlledPlayer
    "return the value of the instance variable 'controlledPlayer' (automatically generated)"

    ^ controlledPlayer
!

controlledPlayer:something
    "set the value of the instance variable 'controlledPlayer' (automatically generated)"

    controlledPlayer := something.
!

game
    "return the value of the instance variable 'game' (automatically generated)"

    ^ game
!

game:something
    "set the value of the instance variable 'game' (automatically generated)"

    game := something.
    game addDependent:self
! !

!PingPongView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    self shown ifTrue:[
        something == #aboutToGo ifTrue:[
            aParameter clearIn:self.
            ^ self
        ].
        something == #aboutToCome ifTrue:[
            aParameter displayIn:self.
            device flush. "/ must flush here, if its for another processes view
            ^ self
        ].
        something == #aboutToMove ifTrue:[
            aParameter clearIn:self.
            ^ self
        ].
        something == #moved ifTrue:[
            aParameter displayIn:self.
            device flush. "/ must flush here, if its for another processes view
            ^ self
        ].
        something == #aboutToResize ifTrue:[
            aParameter clearIn:self.
            ^ self
        ].
        something == #resized ifTrue:[
            aParameter displayIn:self.
            device flush. "/ must flush here, if its for another processes view
            ^ self
        ].
    ]

    "Modified: / 13.12.1999 / 15:28:43 / cg"
! !

!PingPongView methodsFor:'drawing'!

redraw
    self clear.

    game notNil ifTrue:[
        game leftPlayer displayIn:self.
        game rightPlayer displayIn:self.
        game ball displayIn:self.
    ]

    "Modified: / 13.12.1999 / 19:45:21 / cg"
! !

!PingPongView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |oldPos newPos now dT vel lastMoveTime|

    self sensor leftButtonPressed ifTrue:[
        oldPos := controlledPlayer yPos.
        controlledPlayer attemptToMoveToyPos:y.
        
        "/ compute the speed of the paddle ...
        newPos := controlledPlayer yPos.
        now := Timestamp now.

        (lastMoveTime := controlledPlayer lastMoveTime) notNil ifTrue:[
            dT := now millisecondDeltaFrom:lastMoveTime.
            dT == 0 ifTrue:[
                dT := 1
            ].
            vel := (newPos - oldPos) / dT*1000.   "/ pixels per second
            vel := vel rounded.
            controlledPlayer yVel:vel.
        ].
        controlledPlayer lastMoveTime:now.
    ].

    "Modified: / 13.12.1999 / 23:12:39 / cg"
!

buttonPress:button x:x y:y
    game playerIsReady:controlledPlayer.
    controlledPlayer lastMoveTime:Timestamp now.
    self cursor:Cursor blank.
    Processor activeProcess priority:9.

    "Modified: / 13.12.1999 / 23:12:52 / cg"
!

buttonRelease:button x:x y:y
    self cursor:Cursor normal.

    "Modified: / 13.12.1999 / 12:33:36 / cg"
    "Created: / 13.12.1999 / 20:03:57 / cg"
!

destroy
    super destroy.
    game stop
!

keyPress:key x:x y:y
    key == $s ifTrue:[
        game prepareNewBall
    ].
    key == $p ifTrue:[
        game pause
    ].

    "Created: / 13.12.1999 / 20:04:25 / cg"
    "Modified: / 13.12.1999 / 20:06:19 / cg"
! !

!PingPongView methodsFor:'initialization'!

initialize
    super initialize.
    self viewBackground:Color green darkened.
! !

!PingPongView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongView.st,v 1.8 2004-03-20 19:20:39 stefan Exp $'
! !
