"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

View subclass:#InitialLabelView
	instanceVariableNames:'selectAction selected'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-AddressBook'
!

!InitialLabelView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

!InitialLabelView methodsFor:'accessing'!

action:aBlock
    selectAction := aBlock
! !

!InitialLabelView methodsFor:'drawing'!

redraw
    |x dl w p1 p2 p3 p4 ps b|

    self clear.
    x := 0.
    dl := font widthOf:(Character space asString).
    ($A to: $Z) do:[:label |
	w := font widthOf:(label asString).

	p1 := x @ height.
	x := x + dl.
	p2 := x @ 1.
	ps := (x @ font ascent) + (2@4).
	x := x + w + 4.
	p3 := x @ 1.
	x := x + dl.
	p4 := x @ height.

	self paint:Color white.
	self fillPolygon:(Array with:p1
				with:p2
				with:p3
				with:p4).
	self paint:Color black.
	self displayLineFrom:p1 to:p2.
	self displayLineFrom:p2 to:p3.
	self displayLineFrom:p3 to:p4.

	label == selected ifTrue:[
	    self paint:Color black.
	    self fillPolygon:(Array with:p1 + (2@0)
				    with:p2 + (2@2)
				    with:p3 + (-2@2)
				    with:p4 + (-2@0)).
	    self paint:Color white

	].

	self displayString:label asString at:ps.
    ]
! !

!InitialLabelView methodsFor:'initialization'!

initialize
    super initialize.
    self viewBackground:(Color grey).
    height := font height * 2.
    selected := nil
! !

!InitialLabelView methodsFor:'private'!

boundaryOfTab:aCharacter
    |index dl x w startX endX|

    aCharacter isUppercase ifFalse:[
	self error:'bad character'.
	^ 0@0 corner:0@0
    ].

    x := 0.
    dl := font widthOf:(Character space asString).
    ($A to: aCharacter) do:[:label |
	startX := x.
	w := font widthOf:(label asString).
	x := x + dl.    "ascending ramp"
	x := x + w + 4. "character space"
	x := x + dl.    "descending ramp"
	endX := x.
    ].
    ^ startX@height corner:endX@height
! !

!InitialLabelView methodsFor:'user actions'!

buttonPress:button x:xButt y:yButt
    |x dl w p1 p2 p3 p4 ps|

    x := 0.
    dl := font widthOf:(Character space asString).
    ($A to: $Z) do:[:label |
	((self boundaryOfTab:label) containsPoint:(xButt@height)) ifTrue:[
	    selectAction notNil ifTrue:[
		selected := label.
		self redraw.
		selectAction value:label.
	    ].
	    ^ self
	]
    ]
! !

!InitialLabelView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/AddrBook/InitialLabelView.st,v 1.6 1996-05-10 13:32:12 cg Exp $'
! !
