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




"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#ShapeView2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!ShapeView2 class methodsFor:'documentation'!

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
 demonstrates how arbitrary patterns can be used as shape
 in this example, a bitmaps 1-bits are taken as view shape,
 effectively creating a somewhat transparent view.

 This works only, if your X-server supports the XShape
 extension - which is usually the case.

 However, the motif window manager does NOT support it
 (I dont know about the newest version though ..)

 Be prepared, that most X-servers have performance problems
 handling this kind of view-shape ...
 If you have a very good X-server, try move-opaque :-)

 [author:]
     Claus Gittinger (mar 94)

 [start with:]
     ShapeView2 new open
"
! !

!ShapeView2 class methodsFor:'defaults'!

defaultExtent
    ^ 200 @ 200
! !

!ShapeView2 methodsFor:'handling size changes'!

sizeChanged:how
    "must compute a new shape, when size is changed"

    self computeShape.
    super sizeChanged:how
! !

!ShapeView2 methodsFor:'initialization'!

initialize
    super initialize.
    self label:'a funny shape'.
    self viewBackground:Color black.
    self computeShape

    "ShapeView2 new open"
! !

!ShapeView2 methodsFor:'shape computation'!

computeShape
    "define a funny shape"

    |img magnifiedImage form|


"/    img := (Image fromFile:'bitmaps/claus.gif').

"/     img := (Image fromFile:'bitmaps/garfield.gif').

    img := (Image fromFile:'bitmaps/globe1.xbm').

    img isNil ifTrue:[
        self warn:'shape bitmap not existing/not readable'.
        ^ self
    ].
    magnifiedImage := img magnifiedBy:(width / img width) @ (height / img height).
    form := magnifiedImage asMonochromeFormOn:Display.
    self borderShape:form.
    self viewShape:form
! !

!ShapeView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-border-funny.st,v 1.7 1997-01-03 21:39:26 cg Exp $'
! !
