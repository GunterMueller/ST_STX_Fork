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

StandardSystemView subclass:#Example2
       instanceVariableNames:'subview1 subview2'
       classVariableNames:''
       poolDictionaries:''
       category:'examples-Views-Tutorial'
!

!Example2 class methodsFor:'documentation'!

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
    Tutorial example - a view with 2 subviews; each one computes its extent.

    [author:]
	Claus Gittinger (spring 92)

    [start with:]
	Example2 start
"
!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Example2.st,v 1.6 1996-12-21 17:56:04 cg Exp $'
! !

!Example2 methodsFor:'initialization'!

initialize
    |hPixelPerMM vPixelPerMM|

    super initialize.

    self label:'Turorial Example2'.

    hPixelPerMM := self horizontalPixelPerMillimeter rounded asInteger.
    vPixelPerMM := self verticalPixelPerMillimeter rounded asInteger.

    subview1 := View origin:(hPixelPerMM @ vPixelPerMM)
		     extent:[
			     (width - (hPixelPerMM * 2))
			      @ 
			     (height - (vPixelPerMM * 2) // 2 - vPixelPerMM)
			    ]
			 in:self.

    subview1 level:-1.

    subview2 := View origin:[
			      hPixelPerMM 
			      @ 
			      (subview1 bottom + vPixelPerMM)
			    ]
		     extent:[
			     (width - (hPixelPerMM * 2))
			      @ 
			     (height - (vPixelPerMM * 2) // 2 - vPixelPerMM)
			    ]
			 in:self.
    subview2 level:-1

    "Example2 start"
! !
