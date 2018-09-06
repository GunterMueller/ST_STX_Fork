"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

"{ Package: 'stx:clients/Clock' }"

StandardSystemView subclass:#Clock
	instanceVariableNames:'clockView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Applications-Clock'
!

!Clock class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
   xclock replacement

   :-) not that I thought this clock is any better than xclock
       or that the world needs clocks ...

   its showing how easy it is to program in Smalltalk - 
   this (together with ClockView) took less than an hour to program
   - compare with xclock code ....

   When started, this class simply wraps a ClockView into a topView,
   and delegates any keyboard input from it to myself.
   (which is the only interesting thing here)


   [author:]
        Claus Gittinger (spring 91)

   [see also:]
        ClockView RoundClock

   [start with:]
        Clock start
"
! !

!Clock class methodsFor:'defaults'!

defaultIcon
    ^ Image fromFile:'bitmaps/Clock.xbm' resolution:100

!

isVisualStartable
    "yes, I can be started via double click in the browser"

    ^  true
! !

!Clock methodsFor:'initialization'!

initialize
    "setup the clock"

    |items|

    super initialize.

    self label:'Clock'.
    self icon:(self class defaultIcon).
    self extent:(200 @ 200).
    self minExtent:(50 @ 50).
    self maxExtent:(1000 @ 1000).

    clockView := ClockView origin:(0.0 @ 0.0) extent:(1.0 @ 1.0) in:self.
    clockView delegate:(KeyboardForwarder to:self).

    items :=  #(
                ('Seconds'  toggleSeconds )
                ('-'        nil           )
                ('Exit'     closeRequest  )
               ).

    clockView
        middleButtonMenu:
            (PopUpMenu
                itemList:items
                resources:resources
                receiver:self
                for:self)
! !

!Clock methodsFor:'user actions'!

keyPress:key x:x y:y view:someView
    "keyboard commands: q -- quit / s -- toggle seconds flag"

    (key == $q) ifTrue:[
        ^ self destroy
    ].
    (key == $s) ifTrue:[
        ^ clockView toggleSeconds
    ]

    "Created: 27.11.1995 / 23:23:17 / cg"
!

keyRelease:key x:x y:y view:someView
    "ignored"

    "Created: / 28.7.1998 / 16:40:39 / cg"
!

toggleSeconds
    clockView toggleSeconds
! !

!Clock class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Clock/Clock.st,v 1.19 2004-01-23 17:44:58 cg Exp $'
! !
