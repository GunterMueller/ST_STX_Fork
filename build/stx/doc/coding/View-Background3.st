"
 COPYRIGHT (c) 1997 by Claus Gittinger
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

StandardSystemView subclass:#BackgroundDemo3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!BackgroundDemo3 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
    create a very simple view with a COLORED background pattern
    (using a bitmap loaded from a file)

    [start with:]
        BackgroundDemo3 start

    [author:]
        Claus Gittinger (jan 97)
"



! !

!BackgroundDemo3 class methodsFor:'startup'!

start
    |aDemo|

    aDemo := self
                label:'View background Demo'
                icon:(Image fromFile:'bitmaps/Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo extent:(300 @ 100).
    aDemo open.
    ^ aDemo

    "
     BackgroundDemo3 start
    "

    "Modified: 3.1.1997 / 21:37:25 / cg"
! !

!BackgroundDemo3 methodsFor:'initialization'!

realize
    |img|

    super realize.
    img := Image fromFile:'bitmaps/SBrowser.xbm'.
    img colorMap:(Array with:(Color white)
                        with:(Color red)).
    self viewBackground:img

    "Modified: 3.1.1997 / 21:37:25 / cg"
! !

!BackgroundDemo3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Background3.st,v 1.1 1997-01-03 20:42:20 cg Exp $'
! !
