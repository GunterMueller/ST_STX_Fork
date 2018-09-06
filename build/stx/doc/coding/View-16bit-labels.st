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

StandardSystemView subclass:#TwoByteStringDemo2
	instanceVariableNames:'l'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-16bitStrings'
!

!TwoByteStringDemo2 class methodsFor:'documentation'!

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
 demonstrates use of 16-bit strings in labels 

 If there is no k14 font on your machine, replace k14
 by some other 16bit font (12x24kana, kana14, ...)
 in the #fontToUse method.

 [author:]
     Claus Gittinger (feb 94)

 [start with:]
     TwoByteStringDemo2 start
"
! !

!TwoByteStringDemo2 class methodsFor:'startup'!

start
    |aDemo|


    aDemo := self
		label:'16bit string label'
		icon:(Form fromFile:'Demo.xbm' resolution:100)
		minExtent:(50 @ 50)
		maxExtent:(1000 @ 1000).
    aDemo extent:(300 @ 100).
    aDemo open.
    ^ aDemo

    "
     TwoByteStringDemo2 start
    "
! !

!TwoByteStringDemo2 methodsFor:'defaults'!

fontToUse
    ^ 'k14'
! !

!TwoByteStringDemo2 methodsFor:'initialization'!

initialize
    |s p f nm|

    super initialize.

    p := HorizontalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.

    s := TwoByteString new:4.
    s at:1 put:(Character value:16r2154);
      at:2 put:(Character value:16r2541);
      at:3 put:(Character value:16r3144);
      at:4 put:(Character value:16r5055).
    l := Label in:p.
    l label:s.

    nm := self fontToUse.
    (device fontFamilies includes:nm) ifFalse:[
	self warn:'no ' , nm , '  font available - required for this demo'.
    ].
    f := (Font family:nm face:nil style:nil size:nil).
    l font:f.
    l level:-1.
! !

!TwoByteStringDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-16bit-labels.st,v 1.6 1997-01-03 20:23:47 cg Exp $'
! !
