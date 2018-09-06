"
 COPYRIGHT (c) 1999 by eXept Software AG
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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

FontDescription subclass:#CompoundFont
	instanceVariableNames:'baseFont characterToFontMapping maxAscent maxDescent maxHeight
		device'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!CompoundFont class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    a CompountFont is a font which consists of character glyphs from multiple
    other (base-)fonts; for each character code, an individual font may be given.

    This has been mostly added to allow for non-EURO fonts to be used with ST/X,
    by defining a mixedFont, which has an EURO-glyph at the desired character
    position.
    Do not hardCode usage of MixedFonts into your application, since they
    might disappear in the future (when Unicode support has been fully 
    implemented in ST/X, and Unicode fonts are generally available under X).
    I.e. to use these fonts, add appropriate setup to the styleSheet,
    or private.rc and use those fonts transparently.

    [Instance variables:]

      baseFont                  <Font>          fallback (default-) font
      characterToFontMapping    <Dictionary>    maps characters to a fonts

    [class variables:]

    [see also:]
        Font BitmapFont
        DeviceDrawable GraphicsContext

    [author:]
        Claus Gittinger
"


!

examples
"
    a mixed font; all vowels are displayed in times;
    the rest in helvetica.
                                                                        [exBegin]
    |font top list|

    font := CompoundFont basedOn:(Font family:'courier' size:18).
    #($a $e $i $o $u) do:[:char |
        font glyphAt:char putFont:(Font family:'times' size:18).
    ].
    top := ScrollableView forView:(list := EditTextView new).
    list font:font.
    list list:#('a' 'z' 'aaa' 'zzz' 'azaz' 'zaza' 'aa' 'az' 'za' 'hello' 'abcdef' 'xyz').
    top extent:200@200.
    top open.
                                                                        [exEnd]

                                                                        [exBegin]
    |font font2 top list|

    font := CompoundFont basedOn:(Font family:'courier' size:18).
    font2 := Font family:'times' size:24.

    #($a $e $i $o $u $j) do:[:char |
        font glyphAt:char putFont:font2.
        font glyphAt:char asUppercase putFont:font2.
    ].
    top := ScrollableView forView:(list := EditTextView new).
    list font:font.
    list list:#('hello' 'abcdefghijklmnopqrstuvwxyz' 'xyz'
                'HELLO' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'XYZ').
    top extent:200@200.
    top open.
                                                                        [exEnd]

    a mixed font; the dollar character is replaced by the european
    EURO symbol; the rest is helvetica
    (this is a hack - we really need a resizable font for this):

                                                                        [exBegin]
    |font baseFont euroGlyph glyphs euroFont top list|

    baseFont := Font family:'helvetica' size:12.
    baseFont := baseFont onDevice:Display.
    glyphs := Array new:256.
    euroGlyph := Form 
                    width:12 
                    height:16 
                    fromArray:#( 
                                2r00000000 2r00000000
                                2r00000000 2r00000000
                                2r00000000 2r00000000
                                2r00000111 2r11000000
                                2r00001000 2r00100000
                                2r00010000 2r00000000
                                2r01111111 2r10000000
                                2r00010000 2r00000000
                                2r01111111 2r10000000
                                2r00010000 2r00000000
                                2r00001000 2r00100000
                                2r00000111 2r11000000
                                2r00000000 2r00000000
                                2r00000000 2r00000000
                                2r00000000 2r00000000
                                2r00000000 2r00000000
                               ).
    glyphs at:($$ asciiValue+1) put:euroGlyph.

    euroFont := BitmapFont new glyphs:glyphs.
    euroFont setAscent:(baseFont ascent).
    euroFont setDescent:(baseFont descent).

    font := CompoundFont basedOn:baseFont.
    font glyphAt:$$ putFont:euroFont.

    top := ScrollableView forView:(list := EditTextView new).
    list font:font.
    list list:#('100 $' '193 DM').
    top extent:200@200.
    top open.
                                                                        [exEnd]
"
! !

!CompoundFont class methodsFor:'instance creation'!

basedOn:aRealFont
    ^ self new baseFont:aRealFont
! !

!CompoundFont methodsFor:'accessing'!

baseFont
    "return the value of the instance variable 'baseFont' (automatically generated)"

    ^ baseFont
!

baseFont:something
    "set the value of the instance variable 'baseFont' (automatically generated)"

    baseFont := something.
    maxAscent := maxDescent := nil.
!

glyphAt:char putFont:aFont
    characterToFontMapping isNil ifTrue:[
        characterToFontMapping := Dictionary new.
    ].

    characterToFontMapping at:char put:aFont.
    maxAscent := maxDescent := maxHeight := nil.
!

graphicsDevice
    "return the device I am on"

    ^ device
! !

!CompoundFont methodsFor:'displaying'!

displayString:aString from:index1 to:index2 x:x0 y:y0 in:aGC opaque:opaque
    "this is only called for fonts which have a nil fontId,
     and therefore use the replacementFont. Should never be called
     for non-replacement fonts."

    |x y|

    x := x0.
    y := y0.

    self 
        substringPartsOf:aString from:index1 to:index2 
        do:[:s :i1 :i2 :font |
            |wString|

            wString := font widthOf:aString from:i1 to:i2.
            opaque ifTrue:[
"/                (font ascent < maxAscent 
"/                or:[font descent < maxDescent]) 
"/                ifTrue:[       
                    aGC 
                        fillRectangleX:x 
                        y:y-maxAscent      
                        width:wString 
                        height:maxAscent+maxDescent 
                        color:aGC backgroundPaint.
"/                ].
            ].
            font displayString:s from:i1 to:i2 x:x y:y in:aGC opaque:opaque.
            x := x + wString.
        ].
! !

!CompoundFont methodsFor:'printing'!

userFriendlyName
    ^ 'CompoundFont(baseFont: ', baseFont userFriendlyName, ')'
! !

!CompoundFont methodsFor:'private'!

computeMaxBounds
    maxAscent := baseFont maxAscent.
    maxDescent := baseFont maxDescent.
    maxHeight := baseFont maxHeight.
    characterToFontMapping notNil ifTrue:[
        characterToFontMapping keysAndValuesDo:[:char :aFont |
            maxAscent := maxAscent max:aFont maxAscent.
            maxDescent := maxDescent max:aFont maxDescent.
            maxHeight := maxHeight max:aFont maxHeight.
        ]
    ].
!

substringPartsOf:aString from:index1 to:index2 do:aBlock
    "helper - evaluate aBlock for parts of a string, which use the same font.
     aBlock is invoked for consecutive substrings, passing the string,
     the startIndex, endIndex and the font as arguments."

    |i1 i2 fn char currentFont|

    index2 < index1 ifTrue:[^ self].

    i1 := index1.
    currentFont := characterToFontMapping at:(aString at:i1) ifAbsent:baseFont.
    i2 := i1 + 1.

    [i2 <= index2] whileTrue:[
        char := aString at:i2.
        fn := characterToFontMapping at:char ifAbsent:baseFont.
        fn ~~ currentFont ifTrue:[
            aBlock value:aString value:i1 value:(i2-1) value:currentFont.
            currentFont := fn.
            i1 := i2.
        ].
        i2 := i2 + 1.
    ].

    i1 < i2 ifTrue:[
        aBlock value:aString value:i1 value:(i2-1) value:currentFont.
    ].

    "
     |f|

     f := self new.
     f baseFont:#baseFont.
     f fontAt:$$ put:#font2.
     f substringPartsOf:'ae$a' from:1 to:8 
       do:[:s :i1 :i2 :f |
             Transcript 
                     show:i1; space;
                     show:i2; space;
                     showCR:f
          ]
    "
! !

!CompoundFont methodsFor:'queries'!

ascent
    ^ self maxAscent
!

descent
    ^ self maxDescent
!

height
    maxHeight isNil ifTrue:[
        self computeMaxBounds
    ].
    ^ maxHeight.
!

isFixedWidth
    "return true, if this is a fixed pitch font 
     (i.e. all characters are of the same width)"

    |w|

    baseFont isFixedWidth ifFalse:[^ false].
    w := baseFont width.

    characterToFontMapping keysAndValuesDo:[:char :font |
        font isFixedWidth ifFalse:[^ false].
        font width ~~ w ifTrue:[^ false].
    ].
    ^ true
!

maxAscent
    maxAscent isNil ifTrue:[
        self computeMaxBounds
    ].
    ^ maxAscent
!

maxDescent
    maxDescent isNil ifTrue:[
        self computeMaxBounds
    ].
    ^ maxDescent
!

onDevice:aDevice
    "return a device representation of the receiver.
     Since I am device independent, return the receiver."

    |newFonts lastFont lastDeviceFont newFont|

    aDevice == device ifTrue:[ ^ self ].

    baseFont := baseFont onDevice:aDevice.
    newFonts := Dictionary new.
    characterToFontMapping keysAndValuesDo:[:char :font |
        font == lastFont ifTrue:[
            newFont := lastDeviceFont
        ] ifFalse:[
            newFont := font onDevice:aDevice.
            lastFont := font.
            lastDeviceFont := newFont.
        ].
        newFonts at:char put:newFont
    ].
    characterToFontMapping := newFonts.
    device := aDevice.
!

widthOf:aString from:index1 to:index2
    |w|

    w := 0.
    self 
        substringPartsOf:aString from:index1 to:index2 
        do:[:s :i1 :i2 :f |
             w := w + (f widthOf:s from:i1 to:i2)
           ].
    ^ w

! !

!CompoundFont class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

