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

StandardSystemView subclass:#PopUpMenuDemo3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!PopUpMenuDemo3 class methodsFor:'documentation'!

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
 how to define menus with submenus

 [author:]
        Claus Gittinger (spring 91)

 [start with:]
        PopUpMenuDemo3 start
"
! !

!PopUpMenuDemo3 class methodsFor:'startup'!

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
     PopUpMenuDemo3 start
    "
! !

!PopUpMenuDemo3 methodsFor:'initialization'!

initialize
    |myLabel aMenu subMenu subSubMenu|

    super initialize.
    myLabel := Label origin:(0.0 @ 0.0) extent:(1.0 @ 1.0) in:self.
    myLabel label:'press middle button for menu'.

    aMenu := PopUpMenu
                labels:#(
                         'one'
                         'two'
                         'three'
                         '-'
                         'quit'
                        )
             selectors:#(
                         subMenu
                         twoSelected
                         threeSelected
                         nil
                         finish
                        )
              receiver:self.

    subMenu := PopUpMenu
                  labels:#(
                           'one.one'
                           'one.two'
                           'even more'
                          )
               selectors:#(
                           oneOneSelected
                           oneTwoSelected
                           subSubMenu
                          )
                receiver:self.

    subSubMenu := PopUpMenu
                  labels:#(
                           'one.three.one'
                           'one.three.two'
                           'thats enough'
                          )
               selectors:#(
                           oneThreeOneSelected
                           oneThreeTwoSelected
                           oneThreeThreeSelected
                          )
                receiver:self.

    aMenu subMenuAt:#subMenu put:subMenu.
    subMenu subMenuAt:#subSubMenu put:subSubMenu.
"
you can also specify submenus as:

    aMenu subMenuAt:'one ...' put:subMenu.
or:
    aMenu subMenuAt:1 put:subMenu
"

    myLabel middleButtonMenu:aMenu

! !

!PopUpMenuDemo3 methodsFor:'user interaction'!

finish
    self destroy
!

oneOneSelected
    Transcript showCR:'function 1.1'
!

oneThreeOneSelected
    Transcript showCR:'function 1.3.1'
!

oneThreeThreeSelected
    Transcript showCR:'function 1.3.3'
!

oneThreeTwoSelected
    Transcript showCR:'function 1.3.2'
!

oneTwoSelected
    Transcript showCR:'function 1.2'
!

threeSelected
    Transcript showCR:'function 3'
!

twoSelected
    Transcript showCR:'function 2'
! !

!PopUpMenuDemo3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-PopUpMenu-submenus.st,v 1.8 1997-01-03 21:41:16 cg Exp $'
! !
