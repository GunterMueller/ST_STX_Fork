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

StandardSystemView subclass:#PopUpMenuDemo2
	instanceVariableNames:'myMenu'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!PopUpMenuDemo2 class methodsFor:'documentation'!

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
 how to define menus with a check-mark

 [author:]
        Claus Gittinger (spring 91)

 [start with:]
        PopUpMenuDemo2 start
"
! !

!PopUpMenuDemo2 class methodsFor:'startup'!

start
    |aDemo|

    aDemo := self
                label:'PopUpMenu Demo'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo extent:(300 @ 100).
    aDemo open.
    ^ aDemo

    "
     PopUpMenuDemo2 start
    "
! !

!PopUpMenuDemo2 methodsFor:'initialization'!

initialize
    |myLabel myButton theMenu|

    super initialize.
    myLabel := Label origin:(0.0 @ 0.0) extent:(1.0 @ 1.0) in:self.
    myLabel label:'press middle button for menu'.

    theMenu := PopUpMenu
                labels:#(
                         '\cone (check)'
                         '  two'
                         '  three'
                         '-'
                         '  quit'
                        )
             selectors:#(
                         oneSelected:
                         twoSelected
                         threeSelected
                         nil
                         finish
                        )
              receiver:self.

    myLabel middleButtonMenu:theMenu

! !

!PopUpMenuDemo2 methodsFor:'user interaction'!

finish
    self destroy
!

oneSelected:checkValue
    Transcript show:'function 1 '; showCR:checkValue
!

threeSelected
    Transcript showCR:'function 3'
!

twoSelected
    Transcript showCR:'function 2'
! !

!PopUpMenuDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-PopUpMenu-check.st,v 1.8 1997-01-03 21:44:11 cg Exp $'
! !
