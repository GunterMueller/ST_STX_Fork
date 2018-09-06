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

DisplayObject subclass:#DisplayText
	 instanceVariableNames:'fontFamily fontFace fontStyle fontSize font text'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DisplayText class methodsFor:'instance creation'!

new
    ^ self family:'Helvetica' face:'medium' style:'roman' size:12
!

family:aFamily face:aFace style:aStyle size:aSize
    |newDText|

    newDText := super new.
    newDText setFontFamily:aFamily face:aFace style:aStyle size:aSize.
    newDText getFont.
    newDText text:(StringCollection new:1).
    ^ newDText

!

font:aFont
    |newDText|

    newDText := super new.
    newDText setFont:aFont.
    newDText text:(StringCollection new:1).
    ^ newDText

! !

!DisplayText methodsFor:'accessing'!

text:aText
    text := aText.
    self recomputeFrame

!

text
    ^ text
!

fontFamily:aFamily
    fontFamily := aFamily.
    self getFont.
    self recomputeFrame

!

fontFace:aFace
    fontFace := aFace.
    self getFont.
    self recomputeFrame

!

fontStyle:aStyle
    fontStyle := aStyle.
    self getFont.
    self recomputeFrame

!

fontSize:aSize
    fontSize := aSize.
    self getFont.
    self recomputeFrame

!

fontFamily:familyString face:faceString style:aStyleString size:aNumber
    fontFamily := familyString.
    fontFace := faceString.
    fontSize := aNumber.
    fontStyle := aStyleString.
    self getFont.
    self recomputeFram

!

font:aFont
    font := aFont.
    fontFamily := aFont family.
    fontFace := aFont face.
    fontSize := aFont size.
    fontStyle := aFont style.
    self recomputeFrame


!

origin:aPoint
    frame := Rectangle origin:aPoint corner:aPoint.
    self recomputeFrame
! !

!DisplayText methodsFor:'private'!

setFontFamily:familyString face:faceString style:aStyleString size:aNumber
    fontFamily := familyString.
    fontFace := faceString.
    fontSize := aNumber.
    fontStyle := aStyleString.
    self getFont

!

setFontFamily:familyString
    fontFamily := familyString.
    self getFont

!

setFontFace:faceString
    fontFace := faceString.
    self getFont

!

setFontStyle:aStyleString
    fontStyle := aStyleString.
    self getFont

!

setFontSize:aNumber
    fontSize := aNumber.
    self getFont
!

getFont
    font := Font family:fontFamily face:fontFace
		  style:fontStyle size:fontSize.
    font isNil ifTrue:[
       font := Font defaultFont
    ]

!

recomputeFrame
    |maxLen thisLen nLines origin corner|

    frame isNil ifTrue:[^ self].
    origin := frame origin.
    origin isNil ifTrue:[^ self].
    maxLen := 0.
    nLines := 0.
    font notNil ifTrue:[
	font device isNil ifTrue:[
	    font := font on:Display
	].
	(text isKindOf:String) ifTrue:[
	    thisLen := font widthOf:text.
	    (thisLen > maxLen) ifTrue:[maxLen := thisLen].
	    nLines := 1
	] ifFalse:[
	    text do:[:line |
		line notNil ifTrue:[
		    thisLen := font widthOf:line.
		    (thisLen > maxLen) ifTrue:[maxLen := thisLen]
		]
	    ].
	    nLines := text size
	]
    ].
    (maxLen == 0) ifTrue:[
	corner := origin
    ] ifFalse:[
	corner := (origin + (maxLen @ (nLines * font height)))
    ].
    frame := Rectangle origin:origin corner:corner
!

setFont:aFont
    font := aFont.
    fontFamily := aFont family.
    fontFace := aFont face.
    fontSize := aFont size.
    fontStyle := aFont style





! !

!DisplayText methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    self drawIn:aGC offset:anOffset with:(Color black)
				     and:(Color white)
!

drawIn:aGC offset:anOffset with:fgColor and:bgColor
    |xpos ypos delta origin|

    text notNil ifTrue:[
	origin := frame origin.
	xpos := origin x + anOffset x.
	ypos := origin y + anOffset y + font ascent.
	delta := font height.
	aGC font:font.
	aGC paint:fgColor on:bgColor.
	(text isKindOf:String) ifTrue:[
	    aGC displayOpaqueString:text x:xpos y:ypos
	] ifFalse:[
	    text do:[:line |
		line notNil ifTrue:[
		    aGC displayString:line x:xpos y:ypos
		].
		ypos := ypos + delta
	    ]
	]
    ]
!

drawSelectedIn:aGC offset:anOffset
    self drawIn:aGC offset:anOffset with:(Color white)
				     and:(Color black)
! !

!DisplayText methodsFor:'events'!

doubleClick
    "some text has been doubleclicked on"
    ^ self
! !
