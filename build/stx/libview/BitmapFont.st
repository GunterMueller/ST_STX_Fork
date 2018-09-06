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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

FontDescription subclass:#BitmapFont
	instanceVariableNames:'characterBitmaps ascent descent maxWidth maxHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!BitmapFont class methodsFor:'documentation'!

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
    This class demonstrates, that it is possible to define your own
    renderers for fonts - you could even write a class which reads 
    a truetype font from a ttf file and display those 
    (maybe someone finds the time to do this 
     and provides the code to the public domain ?)

    Here is a simple & sample implementation of private bitmap fonts;
    Glyphs for each character are stored in the instance variable
    'characterBitmaps'.
    Some sample glyphs can be created with the class' sampleGlyphs method.
    The required protocol is found in drawing and accessing.

    [author:]
        Claus Gittinger

    [see also:]
        Font GraphicsContext
"
!

examples
"
  a label showing characters in a new bitmap font:
                                                                [exBegin]
    |font l|

    font := (BitmapFont new glyphs:(BitmapFont sampleGlyhps)).
    font setAscent:13; setDescent:3.

    l := Label new.
    l font:font.
    l label:'aazzazaz'.
    l open.
                                                                [exEnd]


  a label showing characters in a new smily font:
                                                                [exBegin]
    |font l|

    font := (BitmapFont new glyphs:(BitmapFont smilyGlyhps)).
    font setAscent:16; setDescent:0.

    l := Label new.
    l font:font.
    l label:'aabbaaa'.
    l open.
                                                                [exEnd]


  demonstrate, that this font can be used in listViews just as any other font:
  (well, missing character glyphs are blanked)
                                                                [exBegin]
    |font top list|

    font := (BitmapFont new glyphs:(BitmapFont sampleGlyhps)).
    font setAscent:13; setDescent:3.

    top := ScrollableView forView:(list := SelectionInListView new).
    list font:font.
    list list:#('a' 'z' 'aaa' 'zzz' 'azaz' 'zaza' 'aa' 'az' 'za' 'hello' 'abcdef' 'xyz').
    top extent:200@200.
    top open.
                                                                [exEnd]


  demonstrate, that this font can be used in textViews just as any other font:
  (well, missing character glyphs are blanked)
                                                                [exBegin]
    |font top list|

    font := (BitmapFont new glyphs:(BitmapFont sampleGlyhps)).
    font setAscent:13; setDescent:3.

    top := ScrollableView forView:(list := EditTextView new).
    list font:font.
    list list:#('a' 'z' 'aaa' 'zzz' 'azaz' 'zaza' 'aa' 'az' 'za' 'hello' 'abcdef' 'xyz').
    top extent:200@200.
    top open.
                                                                [exEnd]

  another clock display:
  defines a font with the 7-segment led bitmaps as glyphs for 0-9,
  then simply displays the time as a string in that font.
                                                                [exBegin]
    |glyphs f label|

    glyphs := Array new:256.
    glyphs 
        at:($0 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led0.xpm').
    glyphs 
        at:($1 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led1.xpm').
    glyphs 
        at:($2 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led2.xpm').
    glyphs 
        at:($3 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led3.xpm').
    glyphs 
        at:($4 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led4.xpm').
    glyphs 
        at:($5 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led5.xpm').
    glyphs 
        at:($6 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led6.xpm').
    glyphs 
        at:($7 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led7.xpm').
    glyphs 
        at:($8 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led8.xpm').
    glyphs 
        at:($9 asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/led9.xpm').
    glyphs 
        at:($: asciiValue + 1) 
        put:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_numbers/ledCol.xpm').

    f := BitmapFont new glyphs:glyphs.

    label := Label new label:(Time now printString).
    label font:f.
    label open
                                                                [exEnd]

"
! !

!BitmapFont class methodsFor:'instance creation'!

new
    |newFont|

    newFont := super new 
		  family:'private' 
		  face:nil
		  style:nil
		  size:nil
		  encoding:nil. 

    ^ newFont

    "
     BitmapFont new glyphs:(self sampleGlyhps).
    "
! !

!BitmapFont class methodsFor:'private'!

sampleGlyhps
    "return the bitmap array for a sample font
     (only contains glyphs for $a and $z)"

    |characters|

    characters := Array new:256.
    characters 
        at:(Character space codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]).

    characters 
        at:($a codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00011111 2r11111000
                            2r00011111 2r11111000
                            2r00011000 2r00011000
                            2r00011000 2r00011000
                            2r00011000 2r00011000
                            2r00011000 2r00011000
                            2r00011000 2r00011000
                            2r00011000 2r00011000
                            2r00011111 2r11111110
                            2r00011111 2r11111110
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]).

    characters 
        at:($z codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00011111 2r11111000
                            2r00011111 2r11111000
                            2r00000000 2r00110000
                            2r00000000 2r01100000
                            2r00011111 2r11111000
                            2r00011111 2r11111000
                            2r00000110 2r00000000
                            2r00001100 2r00000000
                            2r00011111 2r11111000
                            2r00011111 2r11111000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]).

    ^ characters
!

smilyGlyhps
    "return the bitmap array for a smily font
     (only contains glyphs for $a, $b and $c)"

    |characters|

    characters := Array new:256.
    characters 
        at:(Character space codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]).

    characters 
        at:($a codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000001 2r10000000
                            2r00001110 2r01110000
                            2r00011000 2r00011000
                            2r00100000 2r00000100
                            2r01100110 2r01100110
                            2r01000110 2r01100010
                            2r01000000 2r00000010
                            2r10000001 2r00000001
                            2r10000001 2r00000001
                            2r01001000 2r00010010
                            2r01001100 2r00110010
                            2r01100111 2r11100110
                            2r00100001 2r10000100
                            2r00011000 2r00011000
                            2r00001110 2r01110000
                            2r00000001 2r10000000]).

    characters 
        at:($b codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000001 2r10000000
                            2r00001110 2r01110000
                            2r00011000 2r00011000
                            2r00100000 2r00000100
                            2r01100110 2r01100110
                            2r01000110 2r01100010
                            2r01000000 2r00000010
                            2r10000001 2r00000001
                            2r10000001 2r00000001
                            2r01000000 2r00000010
                            2r01000001 2r10000010
                            2r01100010 2r01000110
                            2r00100010 2r01000100
                            2r00011000 2r00011000
                            2r00001110 2r01110000
                            2r00000001 2r10000000]).

    characters 
        at:($c codePoint + 1) 
        put:(Form 
                width:16 
                height:16 
                fromArray:#[2r00000001 2r10000000
                            2r00001110 2r01110000
                            2r00011000 2r00011000
                            2r00100000 2r00000100
                            2r01100110 2r01100110
                            2r01000110 2r01100010
                            2r01000000 2r00000010
                            2r10000001 2r00000001
                            2r10000001 2r00000001
                            2r01000000 2r00000010
                            2r01000001 2r10000010
                            2r01100011 2r11000110
                            2r00100011 2r11000100
                            2r00011001 2r10011000
                            2r00001110 2r01110000
                            2r00000001 2r10000000]).

    ^ characters
! !

!BitmapFont methodsFor:'accessing'!

glyphs:aGlyphArray
    "set the glyphs array; that is the collection of
     bitmaps - one for each character"

    characterBitmaps := aGlyphArray.

    maxWidth := maxHeight := 0. 
    aGlyphArray do:[:glyph | glyph notNil ifTrue:[
                                 maxWidth := maxWidth max:(glyph width).
                                 maxHeight := maxHeight max:(glyph height).
                             ]
                   ].
    ascent isNil ifTrue:[ascent := maxHeight].
    descent isNil ifTrue:[descent := 0].
!

setAscent:aNumber
    "set the font's ascent; that is the number of pixels
     above the baseline"

    ascent := aNumber.
    maxHeight := self maxAscent + (self maxDescent max:0)
!

setDescent:aNumber
    "set the font's ascent; that is the number of pixels
     below the baseline"

    descent := aNumber.
    maxHeight := self maxAscent + (self maxDescent max:0).
! !

!BitmapFont methodsFor:'drawing'!

displayString:aString from:index1 to:index2 x:x0 y:y in:aGC opaque:opaque
    "required protocol for new fonts:
     - display part of a string, drawing foreground pixels only"

    |x|

    x := x0.
    index1 to:index2 do:[:index |
        self drawCharacter:(aString at:index) codePoint in:aGC x:x y:y opaque:opaque.
        x := x + (self widthOfCharacter:(aString at:index) codePoint)
    ]
! !

!BitmapFont methodsFor:'private - drawing'!

drawCharacter:ascii in:aGC x:x y:y opaque:opaque
    |glyph|

    glyph := characterBitmaps at:(ascii + 1) ifAbsent:nil.
    glyph isNil ifTrue:[^ self].
    aGC displayForm:glyph x:x y:y-glyph height+descent opaque:opaque
! !

!BitmapFont methodsFor:'private - queries'!

glyphOfCharacter:ascii
    "return the height of a specific character"

    |glyph|

    glyph := characterBitmaps at:(ascii + 1) ifAbsent:nil.
    glyph isNil ifTrue:[
        glyph := characterBitmaps at:(Character space codePoint + 1).
    ].
    ^ glyph
!

heightOfCharacter:ascii
    "return the height of a specific character"

    |glyph|

    glyph := self glyphOfCharacter:ascii.
    glyph isNil ifTrue:[^ 0].
    ^ glyph height
!

widthOfCharacter:ascii
    "return the width of a specific character"

    |glyph|

    glyph := self glyphOfCharacter:ascii.
    glyph isNil ifTrue:[^ 0].
    ^ glyph width
! !

!BitmapFont methodsFor:'queries'!

ascent
    "return the ascent - the number of pixels above the baseLine"

    ^ ascent
!

ascentOn:aDevice
    "return the descent - the number of pixels below the baseLine.
     Since I am not device dependent, return my pixel ascent."

    ^ descent
!

descent
    "return the descent - the number of pixels below the baseLine"

    ^ descent ? 0
!

descentOn:aDevice
    "return the descent - the number of pixels below the baseLine.
     Since I am not device dependent, return my pixel descent."

    ^ descent
!

height
    "return the height - the height in pixels of the highest character"

    ^ self maxHeight
!

heightOf:aString
    "return the height - the height in pixels of the highest character"

    ^ self maxHeight.
!

heightOn:aDevice
    "return the height - the height in pixels of the highest character"

    ^ self maxHeight.
!

isFixedWidth
    "return true if all of the font's characters are equal in
     width."

    |w|

    characterBitmaps do:[:glyph | |wHere|
                                glyph notNil ifTrue:[
                                    wHere := glyph width.  
                                    w isNil 
                                        ifTrue:[ w := wHere ]
                                        ifFalse:[ w ~~ wHere ifTrue:[^ false]]
                                ]
                        ].
    ^ true
!

maxAscent
    "return the maximum ascent; 
     that's the ascent of the highest character"

    ascent isNil ifTrue:[
        ascent := (self maxHeight - self descent) max:0
    ].
    ^ ascent.
!

maxDescent
    "return the maximum descent; 
     that's the descent of the highest character"

    descent isNil ifTrue:[
        descent := (self maxHeight - ascent) max:0
    ].
    ^ descent.
!

maxHeight
    "return the maximum height; 
     that's the height of the highest character"

    ^ maxHeight ? 0
!

maxWidth 
    "return the maximum width - the width of the widest character in pixels"

    ^ maxWidth
!

onDevice:aDevice
    "return a device representation of the receiver.
     Since I am device independent, return the receiver."

    ^ self
!

width 
    "return the width - the average width in pixels"

    ^ self maxWidth
!

widthOf:aString from:start to:stop
    "return the width of a substring"

    |sumW|

    (stop < start) ifTrue:[^ 0].
    sumW := 0.
    start to:stop do:[:index |
        sumW := sumW + (self widthOfCharacter:(aString at:index) codePoint) 
    ].
    ^ sumW
!

widthOf:aString from:startIndex to:endIndex on:aDevice
    "return the width of a substring"

    ^ self widthOf:aString from:startIndex to:endIndex
!

widthOn:aDevice
    "return the width - the average width in pixels"

    ^ self maxWidth
! !

!BitmapFont class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

