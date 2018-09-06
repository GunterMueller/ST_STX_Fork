"{ Namespace: 'CodingExamples_GUI' }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

StandardSystemView subclass:#Example8
       instanceVariableNames:'subview menu'
       classVariableNames:''
       poolDictionaries:''
       category:'examples-Views-Tutorial'
!

!Example8 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Tutorial example - a view with a subview and a menu;
    also on the fly, you see how notify: and confirm: messages are used.

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example8 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example8.st,v 1.7 1996-12-21 17:56:08 cg Exp $'
! !

!Example8 methodsFor:'initialization'!

initialize
    |hPixelPerMM vPixelPerMM|

    super initialize.

    self label:'Turorial Example8'.

    menu := PullDownMenu in:self.
    menu labels:#('foo' 'bar' 'baz').
    menu at:1
	    putLabels:#(
			'foo' 
			'foobar' 
			'-' 
			'quit'
		       )
	    selectors:#(
			doFoo
			doFoobar
			nil 
			finish
		       )
	     receiver:self.

    menu at:2
	    putLabels:#(
			'bar' 
			'barfoo'
		       )
	    selectors:#(
			doBar 
			doBarfoo
		       )
	     receiver:self.

    menu at:3
	    putLabels:#(
			'baz' 
			'bazfoo'
		       )
	    selectors:#(
			doBaz 
			doBazfoo
		       )
	     receiver:self.

    hPixelPerMM := self horizontalPixelPerMillimeter rounded asInteger.
    vPixelPerMM := self verticalPixelPerMillimeter rounded asInteger.

    subview := TextView origin:(hPixelPerMM @ (menu height + vPixelPerMM))
			extent:[(width - (hPixelPerMM * 2))
				 @ 
				(height - (menu height) - (vPixelPerMM * 2))]
			    in:self.
    subview level:-1.
    subview contents:'
This is an example of a view with a pull-down-menu.

It also demonstrates the use of Notifier and Confirmer -
try the different menu entries and you will see ....
(some menu entries will pop-up a notifier, some a confirmer
 and others will just output something to the Transcript)


To finish, use quit from the foo-menu.'

    "Example8 start"
! !

!Example8 methodsFor:'user interaction'!

finish
    self destroy
!

doFoo
    self notify:'its a foo'
!

doFoobar
    Transcript showCR:'you selected; foobar'
!

doBar
    self notify:'it was: bar'
!

doBarfoo
    Transcript showCR:'barfoo'
!

doBaz
    (self confirm:'do you really want to: baz') ifTrue:[
	Transcript showCR:'yes I want a baz'
    ] ifFalse:[
	Transcript showCR:'no I dont need any baz (what is a baz anyway ?)'
    ]
!

doBazfoo
    Transcript showCR:'bazfoo'
! !
