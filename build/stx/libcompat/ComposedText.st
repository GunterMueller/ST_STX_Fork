"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ComposedText
	instanceVariableNames:'string font'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!ComposedText class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    This is currently not used by ST/X itself.

    This is an additional goody class; therefore:

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

!ComposedText class methodsFor:'instance creation'!

fromString:aString
    ^ self new string:aString font:(Label defaultFont)
!

withText:aStringOrText style:aStyle
    ^ self new 
        string:aStringOrText font:(Label defaultFont);
        textStyle:aStyle
! !

!ComposedText methodsFor:'accessing'!

centered
    ^ self
!

font:aFont
    font := aFont
!

string:aString font:aFont
    string := aString.
    font := aFont
!

text
    string := string asText.
    ^ string
!

textStyle:aTextStyle
    "ignored"
!

wordWrap:aBoolean
    "ignored"
! !

!ComposedText methodsFor:'displaying'!

displayOn:aGC x:x y:y
    "display the receiver in a graphicsContext - this method allows
     for any object to be displayed in a ListView - for example.
     The fallBack here shows the receiver's printString."

    |oldFont|

    font notNil ifTrue:[
        oldFont := aGC font.
        aGC font:font
    ].
    aGC displayString:string x:x y:y.
    oldFont notNil ifTrue:[
        aGC font:oldFont
    ]

    "Created: 2.4.1997 / 13:59:27 / cg"
! !

!ComposedText methodsFor:'queries'!

bounds
    ^ 0@0 extent:(self width @ self height)
!

height
    ^ font height

    "Modified: 27.1.1997 / 14:06:21 / cg"
!

heightOn:aGC
    ^ font heightOf:string on:aGC device

    "Modified: 27.1.1997 / 14:06:02 / cg"
    "Created: 27.1.1997 / 14:06:15 / cg"
!

width
    ^ font widthOf:string
!

widthOn:aGC
    ^ font widthOf:string on:aGC device

    "Created: 27.1.1997 / 14:05:30 / cg"
    "Modified: 27.1.1997 / 14:06:02 / cg"
! !

!ComposedText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ComposedText.st,v 1.14 2018-05-15 16:15:51 cg Exp $'
! !

