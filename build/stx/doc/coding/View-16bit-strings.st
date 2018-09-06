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


"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#TwoByteStringDemo1
	instanceVariableNames:'kFont normalFont'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-16bitStrings'
!

!TwoByteStringDemo1 class methodsFor:'documentation'!

copyright
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

!

documentation
"
 demonstrates 16-bit string drawing (needs k14 font)

 If there is no k14 font on your machine, replace k14
 by some other 16bit font (12x24kana, kana14, ...) in the
 #fontToUse method.

 [author:]
     Claus Gittinger (july 93)

 [start with:]
     TwoByteStringDemo1 start
"
! !

!TwoByteStringDemo1 class methodsFor:'startup'!

start
    |aDemo|


    aDemo := self
		label:'a 16bit string'
		icon:(Form fromFile:'Demo.xbm' resolution:100)
		minExtent:(200 @ 50)
		maxExtent:(1000 @ 1000).
    aDemo extent:(400 @ 100).
    aDemo open.
    ^ aDemo

    "
     TwoByteStringDemo1 start
    "
! !

!TwoByteStringDemo1 methodsFor:'defaults'!

fontToUse
    ^ 'k14'
! !

!TwoByteStringDemo1 methodsFor:'initialization'!

initialize
    |nm|

    super initialize.
    nm := self fontToUse.
    (device fontFamilies includes:nm) ifFalse:[
	self warn:'no ' , nm , ' font available - required for this demo'.
    ].
    kFont := Font family:nm face:nil style:nil size:nil.
    normalFont := font
! !

!TwoByteStringDemo1 methodsFor:'redrawing'!

redraw
    |s|

    self font:normalFont.
    self displayString:'16bit chars (font ' , self fontToUse , '):' x:10 y:20.

    self font:kFont.
    s := TwoByteString new:10.
    s at:1 put:(Character value:16r2154).   "<<"
    s at:2 put:(Character value:16r2155).   ">>"
    s at:3 put:(Character value:16r2341).   "A"
    s at:4 put:(Character value:16r2342).   "B"
    s at:5 put:(Character value:16r2343).   "C"
    s at:6 put:(Character value:16r2541).   "some random chars"
    s at:7 put:(Character value:16r2551).
    s at:8 put:(Character value:16r2561).
    s at:9 put:(Character value:16r3144).
    s at:10 put:(Character value:16r5055).
    self displayString:s x:10 y:50.
! !

!TwoByteStringDemo1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-16bit-strings.st,v 1.6 1997-01-03 20:21:29 cg Exp $'
! !
