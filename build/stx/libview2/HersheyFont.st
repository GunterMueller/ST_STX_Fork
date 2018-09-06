"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Font subclass:#HersheyFont
	instanceVariableNames:'glyphs scale'
	classVariableNames:'GlyphData'
	poolDictionaries:''
	category:'Graphics-Support'
!

HersheyFont comment:'
Support for hershey fonts is based on a freeware cd-rom distribution 
by DEC. This disk contains the hershey outlines and glyph maps of
the following fonts:

Fonts:
	Roman:  Plain, Simplex, Duplex, Complex Small, Complex, Triplex
       Italic:  Complex Small, Complex, Triplex
       Script:  Simplex, Complex
       Gothic:  German, English, Italian
	Greek:  Plain, Simplex, Complex Small, Complex
     Cyrillic:  Complex

Symbols:
	Mathematical 
	Daggers 
	Astronomical 
	Astrological 
	Musical 
	Typesetting (ffl,fl,fi sorts of things) 
	Miscellaneous:
		- Playing card suits
		- Meteorology
		- Graphics (lines, curves)
		- Electrical
		- Geometric (shapes)
		- Cartographic
		- Naval
		- Agricultural
		- Highways
		- Etc...

Legal notice:
	This distribution of the Hershey Fonts may be used by anyone for
	any purpose, commercial or otherwise, providing that:

	1. The following acknowledgements must be distributed with
	the font data:
	    - The Hershey Fonts were originally created by Dr.
		    A. V. Hershey while working at the U. S.
		    National Bureau of Standards.
	    - The format of the Font data in this distribution
		    was originally created by
			    James Hurt
			    Cognition, Inc.
			    900 Technology Park Drive
			    Billerica, MA 01821
			    (mit-eddie!!ci-dandelion!!hurt)

	2. The font data in this distribution may be converted into
	any other format *EXCEPT* the format distributed by
	the U.S. NTIS (which organization holds the rights
	to the distribution and use of the font data in that
	particular format). Not that anybody would really
	*want* to use their format... each point is described
	in eight bytes as "xxx yyy:", where xxx and yyy are
	the coordinate values as ASCII numbers.
'
!

!HersheyFont class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    HersheyFont provides (limited) support to draw characters
    from the hershey font set.

    This is a demo class - not maintained or meant for productive use.
    Notice: this is a very old demo - it should be rewritten to honor
    the FontDescription protocol (see BitmapFont as a better example).

    Caveat: not completely correct; the ascent and descent data is wrong, which
    gives textView a little trouble when selecting. (see examples)
    We leave it as an exercise to the interested user to fix those.

    You need the data file 'hersh.oc' and the glyph data files
        astrol.hmp              astrology
        scripts.hmp             cursive
        cyrilc.hmp              cyrillic
        romans.hmp              futura.l
        romand.hmp              futura.m
        gotheng.hmp             gothic.eng
        gothger.hmp             gothic.ger
        gothita.hmp             gothic.ita
        greeks.hmp              greek
        marker.hmp              markers
        lowmat.hmp              math.low
        uppmat.hmp              math.upp
        meteo.hmp               meteorology
        music.hmp               music
        scriptc.hmp             script
        symbol.hmp              symbolic
        greekc.hmp              times.g
        italicc.hmp             times.i
        italict.hmp             times.ib
        romanc.hmp              times.r
        romant.hmp              times.rb
        japan.hmp               japanese

    (these are available via http/ftp and must be acquired from elsewhere due to
     copyright restrictions - google for 'hersh.oc' or search for hershey in github).

    You should install those files in some font folder
    (see hersheyFontPath for a list of places where they are expected)

    [see also:]
        BitmapFont FontDescription Font


    Support for hershey fonts is based on a freeware cd-rom distribution
    by DEC. This disk contains the hershey outlines and glyph maps of
    the following fonts:

    Fonts:
        Roman:  Plain, Simplex, Duplex, Complex Small, Complex, Triplex
       Italic:  Complex Small, Complex, Triplex
       Script:  Simplex, Complex
       Gothic:  German, English, Italian
        Greek:  Plain, Simplex, Complex Small, Complex
     Cyrillic:  Complex

    Symbols:
        Mathematical
        Daggers
        Astronomical
        Astrological
        Musical
        Typesetting (ffl,fl,fi sorts of things)
        Miscellaneous:
                - Playing card suits
                - Meteorology
                - Graphics (lines, curves)
                - Electrical
                - Geometric (shapes)
                - Cartographic
                - Naval
                - Agricultural
                - Highways
                - Etc...

    Legal notice:
        This distribution of the Hershey Fonts may be used by anyone for
        any purpose, commercial or otherwise, providing that:

        1. The following acknowledgements must be distributed with
        the font data:
            - The Hershey Fonts were originally created by Dr.
                    A. V. Hershey while working at the U. S.
                    National Bureau of Standards.
            - The format of the Font data in this distribution
                    was originally created by
                            James Hurt
                            Cognition, Inc.
                            900 Technology Park Drive
                            Billerica, MA 01821
                            (mit-eddie!!ci-dandelion!!hurt)

        2. The font data in this distribution may be converted into
        any other format *EXCEPT* the format distributed by
        the U.S. NTIS (which organization holds the rights
        to the distribution and use of the font data in that
        particular format). Not that anybody would really
        *want* to use their format... each point is described
        in eight bytes as 'xxx yyy:', where xxx and yyy are
        the coordinate values as ASCII numbers.
"
!

examples
"
                                                                [exBegin]
     |aView|

     aView := TextView new extent:400@400.
     aView openAndWait.
     aView font:(HersheyFont family:'hershey-gothic-german' face:'bold' style:'roman' size:12).
     aView contents:'

Hello world

Is this nice?'.
                                                                [exEnd]

                                                                [exBegin]
     |aView|

     aView := View new extent:500@200.
     aView openAndWait.
     aView backingStore:true.

     HersheyFont showFont:(HersheyFont family:'hershey-astrology'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-music'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-meteorology'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-cursive'
                                         face:'medium'
                                        style:'roman'
                                         size:10) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-cursive'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-cursive'
                                         face:'medium'
                                        style:'roman'
                                         size:48) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-script'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'medium'
                                        style:'roman'
                                         size:12) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'medium'
                                        style:'roman'
                                         size:48) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'medium'
                                        style:'italic'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-times'
                                         face:'bold'
                                        style:'italic'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-futura'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-futura'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-markers'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-math1'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-math2'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-symbol'
                                         face:'medium'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-gothic-italian'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-gothic-german'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView

     HersheyFont showFont:(HersheyFont family:'hershey-gothic-english'
                                         face:'bold'
                                        style:'roman'
                                         size:24) in:aView
     ].
                                                                [exEnd]
"
! !

!HersheyFont class methodsFor:'instance creation'!

family:family face:face style:style size:sz
    "return a HersheyFont, given an ST/X-style fontName"

    |fontNames|

    fontNames := #(
        ('hershey-times'                'bold'          'roman'         'romant')
        ('hershey-times'                'medium'        'roman'         'romanc')
        ('hershey-times'                'medium'        'italic'        'italicc')
        ('hershey-times'                'bold'          'italic'        'italict')
        ('hershey-times'                'bold'          'greek'         'greekc')

        ('hershey-japan'                'bold'          'normal'        'japan')

        ('hershey-gothic-german'        'bold'          'roman'         'gothger')
        ('hershey-gothic-english'       'bold'          'roman'         'gotheng')
        ('hershey-gothic-italian'       'bold'          'roman'         'gothita')

        ('hershey-cursive'              'medium'        'roman'         'scripts')
        ('hershey-script'               'bold'          'roman'         'scriptc')

        ('hershey-futura'               'medium'        'roman'         'romans')
        ('hershey-futura'               'bold'          'roman'         'romand')

        ('hershey-markers'              'medium'        'roman'         'marker')
        ('hershey-math1'                'medium'        'roman'         'lowmat')
        ('hershey-math2'                'medium'        'roman'         'uppmat')
        ('hershey-symbol'               'medium'        'roman'         'symbol')

        ('hershey-astrology'            'bold'          'roman'         'astrol')
        ('hershey-meteorology'          'medium'        'roman'         'meteo')
        ('hershey-music'                'bold'          'roman'         'music')
    ).

    fontNames do:[:entry |
        (entry at:1) = family ifTrue:[
            (entry at:2) = face ifTrue:[
                (entry at:3) = style ifTrue:[
                    ^ self name:(entry at:4) family:family face:face style:style size:sz
                ]
            ]
        ]
    ].
    ^ nil

    "
     HersheyFont family:'hershey-gothic-german' face:'bold' style:'roman' size:12
    "

    "Modified: 16.1.1997 / 18:19:47 / cg"
! !

!HersheyFont class methodsFor:'drawing'!

drawGlyph:glyphNo in:aGC x:x y:y scale:aScale
    "draw a single character"

    |moves c1 c2 xPos yPos nX nY draw w h savedLW|

    moves := GlyphData at:glyphNo.
    moves isNil ifTrue:[
        Transcript showCR:('no glyph for ' , glyphNo printString).
        ^ self
    ].
    savedLW := aGC lineWidth.
    aGC lineWidth:(aScale * 2) rounded.

    xPos := 0 "x".
    yPos := 0 "y".
    draw := false. "start with a skip"
    w := ((moves at:1) codePoint - $R codePoint)" * aScale".
    h := ($R codePoint - (moves at:2) codePoint)" negated * aScale".
    w := w negated * aScale * 2.
    h := h negated * aScale * 2.

    3 to:(moves size) by:2 do:[:index |
        c1 := moves at:index.
        c2 := moves at:(index + 1).
        c1 == Character space ifTrue:[
            draw := false
        ] ifFalse:[
            nX := "xPos +" ((c1 codePoint - $R codePoint) * aScale).
            nY := "yPos +" (($R codePoint - c2 codePoint) negated * aScale).
            draw ifTrue:[
                aGC displayLineFromX:((x + xPos) truncated "rounded")
                                   y:((y + yPos) truncated "rounded")
                                 toX:((x + nX) truncated "rounded")
                                   y:((y + nY) truncated "rounded").
            ].
            xPos := nX.
            yPos := nY.
            draw := true
        ]
    ].
    aGC lineWidth:savedLW

    "Smalltalk at:#v put:nil.
     Smalltalk at:#f put:nil.
     v := View new realize.

     v clear.
     v font:(f := HersheyFont family:'hershey-times' face:'bold' style:'roman' size:12).
     v displayString:'hello' x:50 y:50"

    "Modified: 16.1.1997 / 18:22:10 / cg"
!

heightOfGlyph:glyphNo scale:aScale
    "return the height of a single character"

    |moves h|

    moves := GlyphData at:glyphNo.
    moves isNil ifTrue:[
        Transcript showCR:('no glyph for ' , glyphNo printString).
        ^ 0
    ].

    h := ($R codePoint - (moves at:2) codePoint)" negated * aScale".
    h := h negated * aScale * 2.
    ^ h

    "Modified: 16.1.1997 / 18:22:24 / cg"
!

widthOfGlyph:glyphNo scale:aScale
    "return the width of a single character"

    |moves w|

    moves := GlyphData at:glyphNo.
    moves isNil ifTrue:[
        Transcript showCR:('no glyph for ' , glyphNo printString).
        ^ 0
    ].

    w := ((moves at:1) codePoint - $R codePoint).
    w := w negated * aScale * 2.
    ^ w

    "HersheyFont widthOfGlyph:3401 scale:1"

    "Modified: 16.1.1997 / 18:22:31 / cg"
! !

!HersheyFont class methodsFor:'examples'!

showFont:f in:aView
     |x y dy|

     dy := f heightOn:aView device.
     aView clear.
     x := 100. y := dy.
     32 to:47 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     48 to:57 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     58 to:64 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     65 to:90 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     91 to:96 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     97 to:122 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ].

     x := 100. y := y + dy.
     123 to:127 do:[:i |
         f drawCharacter:i in:aView x:x y:y.
         x := x + 30
     ]

    "Modified: 16.1.1997 / 18:27:15 / cg"
! !

!HersheyFont class methodsFor:'private'!

hersheyFontPath
    "the directory, where the glyph data is found;
     you may have to modify this a bit ..."

    #(
        '/usr/local/fonts/hershey'
        '/usr/fonts/hershey'
        '~/fonts/hershey'
        '~/Library/fonts/hershey'
        '~/Fonts/hershey'
        '/Library/fonts/hershey'
        '~/Desktop/fonts/hershey'
        '~/Desktop/hershey'
        '~/Downloads/fonts/hershey'
    ) do:[:each |
        |fn|

        fn := each asFilename.
        (fn / 'data') exists ifTrue:[^ fn pathName].
    ].

    ^ '/usr/local/fonts/hershey'

    "
     self hersheyFontPath
    "

    "Modified: 16.1.1997 / 18:24:35 / cg"
!

name:aFileName family:family face:face style:style size:sz
    "return a font with glyph-data from aFileName"

    |newFont|

    newFont := self basicNew readGlyphsFrom:aFileName.
    newFont family:family face:face style:style size:sz.
    ^ newFont

    "HersheyFont name:'gothger'"
!

readDataFile
    |inStream b5 b3 chars moves glyphNo nPairs char1 char2 index|

    inStream := FileStream readonlyFileNamed:(self hersheyFontPath asFilename / 'data/hersh.oc').
    inStream isNil ifTrue:[
        self error:'no glyph data file ''' , self hersheyFontPath , ''' found.'.
        ^ self
    ].

    GlyphData isNil ifTrue:[
        Transcript showCR:'reading hershey glyphs ...'.

        GlyphData := (OrderedCollection new:4000) grow:4000.
        b5 := String new:5.
        b3 := String new:3.
        [inStream atEnd] whileFalse:[
            chars := inStream nextBytes:5 into:b5.
            glyphNo := Number readFromString:b5.
            chars := inStream nextBytes:3 into:b3.
            nPairs := Number readFromString:b3.
            moves := String new:(nPairs * 2).
            index := 1.
            1 to:nPairs do:[:i |
                char1 := inStream next.
                char1 == Character nl ifTrue:[
                    char1 := inStream next
                ].
                char2 := inStream next.
                char2 == Character nl ifTrue:[
                    char2 := inStream next
                ].
                moves at:index put:char1.
                index := index + 1.
                moves at:index put:char2.
                index := index + 1
            ].
            GlyphData at:glyphNo put:moves.
            [inStream peek == Character nl] whileTrue:[inStream next]
        ].
        inStream close
    ]

    "HersheyFont readDataFile"

    "Modified: 16.1.1997 / 18:24:15 / cg"
! !

!HersheyFont methodsFor:'drawing'!

displayString:aString from:index1 to:index2 x:x0 y:y in:aGC opaque:opaque
    |x|

    x := x0.
    index1 to:index2 do:[:index |
        self drawCharacter:(aString at:index) codePoint in:aGC x:x y:y.
        x := x + (self widthOfCharacter:(aString at:index) codePoint)
    ]
!

displayString:aString x:x0 y:y in:aGC
    |x|

    x := x0.
    aString do:[:character |
        self drawCharacter:character codePoint in:aGC x:x y:y.
        x := x + (self widthOfCharacter:character codePoint)
    ]
!

drawCharacter:ascii in:aGC x:x y:y
    |glyphNo|

    (ascii between:32 and:127) ifFalse:[^ self].

    glyphNo := glyphs at:(ascii - 32 + 1).
    glyphNo isNil ifTrue:[^ self].
    self class drawGlyph:glyphNo in:aGC x:x y:y scale:scale
! !

!HersheyFont methodsFor:'private'!

family:fam face:fac style:st size:sz
    family := fam.
    face := fac.
    style := st.
    size := sz.
    scale := sz / 24
!

onDevice:aDevice
    ^ self copy setDevice:aDevice
!

readGlyphsFrom:aFileName
    "read glyph definitions from aFileName"

    |inStream ascii index1 index2|

    self class readDataFile.
    glyphs := Array new:(256 - 32).
    inStream := FileStream readonlyFileNamed:(self class hersheyFontPath asFilename / 'fonts' / (aFileName , '.hmp')).
    ascii := 32.
    [inStream atEnd] whileFalse:[
        index1 := Number readFrom:inStream.
        index2 := Number readFrom:inStream.
        index2 == 0 ifTrue:[
            index2 := index1
        ].
        index1 to:index2 do:[:pos |
            glyphs at:(ascii - 32 + 1) put:pos.
            ascii := ascii + 1
        ].
        inStream skipSeparators
    ].
    inStream close.
    ^ self
!

scale:aScale
    scale := aScale
!

setDevice:aDevice
    super setDevice:aDevice.
    scale isNil ifTrue:[
        scale := size / 24
    ].
    ascent := maxAscent := self ascentOn:aDevice.
    descent := maxDescent := self descentOn:aDevice.
    width := minWidth := maxWidth := self widthOn:aDevice.
    isFixedWidth := false.
    minCode := 32.
    maxCode := 127.
    encoding := 'ascii'.
! !

!HersheyFont methodsFor:'queries'!

ascentOn:aDevice
    ^ 0
!

descentOn:aDevice
    ^ self heightOn:aDevice
!

heightOfCharacter:ascii
    |glyphNo|

    (ascii between:32 and:127) ifFalse:[^ 0].
    glyphNo := glyphs at:(ascii - 32 + 1).
    glyphNo isNil ifTrue:[^ 0].
    ^ self class heightOfGlyph:glyphNo scale:scale
!

heightOn:aDevice
    ^ scale * (24 + 12)
!

isAlienFont
    ^ true
!

widthOf:aString
    |sumW|

    sumW := 0.
    aString do:[:character |
        sumW := sumW + (self widthOfCharacter:character codePoint)
    ].
    ^ sumW
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

widthOfCharacter:ascii
    |glyphNo|

    (ascii between:32 and:127) ifFalse:[^ 0].

    glyphNo := glyphs at:(ascii - 32 + 1).
    glyphNo isNil ifTrue:[^ 0].
    ^ self class widthOfGlyph:glyphNo scale:scale
!

widthOn:aDevice
    ^ self widthOfCharacter:($m codePoint)
! !

!HersheyFont class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

