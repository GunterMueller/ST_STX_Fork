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

PingPongObject subclass:#PingPongPlayer
	instanceVariableNames:'lastMoveTime'
	classVariableNames:''
	poolDictionaries:''
	category:'games-PingPong'
!

!PingPongPlayer class methodsFor:'documentation'!

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

!PingPongPlayer methodsFor:'accessing'!

lastMoveTime
    "return the value of the instance variable 'lastMoveTime' (automatically generated)"

    ^ lastMoveTime

    "Created: / 13.12.1999 / 23:12:01 / cg"
!

lastMoveTime:something
    "set the value of the instance variable 'lastMoveTime' (automatically generated)"

    lastMoveTime := something.

    "Created: / 13.12.1999 / 23:12:01 / cg"
! !

!PingPongPlayer methodsFor:'dummy'!

startPlaying
    "nothing done here - but needed for computerPlayer"

    "Created: / 13.12.1999 / 15:37:43 / cg"
!

stopPlaying
    "nothing done here - but needed for computerPlayer"

    "Created: / 13.12.1999 / 15:32:26 / cg"
! !

!PingPongPlayer methodsFor:'misc'!

recomputeVelocity
    | now|

    now := Timestamp now.
    (now millisecondDeltaFrom:lastMoveTime) > 50 ifTrue:[
        yVel := 0.
        lastMoveTime := now
    ].

    "Created: / 13.12.1999 / 23:17:01 / cg"
! !

!PingPongPlayer methodsFor:'queries'!

isHuman
    ^ true
! !

!PingPongPlayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/PingPong/PingPongPlayer.st,v 1.5 2004-03-20 19:20:57 stefan Exp $'
! !
