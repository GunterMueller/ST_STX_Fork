"{ Namespace: 'CodingExamples_GUI' }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

'From Smalltalk/X, Version:2.10.1 on 9-may-1994 at 12:37:26'!
"
 the model-view way of using a popUpList
"
!

Model subclass:#SimpleDemoModel3
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-MVC-Support'
!

!SimpleDemoModel3 methodsFor:'user actions'!

selectionChanged:newSelection
    Transcript showCR:'selection changed to:', newSelection displayString
!

button1Pressed
    Transcript showCR:'button1 was pressed'
!

button2Pressed
    Transcript showCR:'button2 was pressed'
! !

!SimpleDemoModel3 methodsFor:'initialization'!

open
    |top p b1 b2 pop|

    top:= StandardSystemView new; extent:100@100.
    p := PanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
    b1 := Button label:'one' in:p.
    b2 := Button label:'two' in:p.
    pop := PopUpList label:'xxxxxxx' in:p.
    pop list:#('apples' 'bananas' 'grape').
"/    pop values:(1 to:3).
    b1 model:self; change:#button1Pressed.
    b2 model:self; change:#button2Pressed.
    pop model:self; 
	change:#selectionChanged:;
	listMessage:nil.

    top open.

    "SimpleDemoModel3 new open"
! !
