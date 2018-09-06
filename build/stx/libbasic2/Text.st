"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

CharacterArray subclass:#Text
	instanceVariableNames:'string runs'
	classVariableNames:'BackgroundColorEmphasis ColorEmphasis ItalicEmphasis BoldEmphasis
		UnderlineEmphasis UnderwaveEmphasis OverlineEmphasis
		StrikeoutEmphasis ReverseEmphasis BoldUnderlineEmphasis
		BoldOverlineEmphasis BoldUnderwaveEmphasis
		ItalicUnderlineEmphasis ItalicUnderwaveEmphasis
		UnderlineColorEmphasis StrikeoutColorEmphasis EtchColorEmphasis
		FontEmphasis Superscript Subscript'
	poolDictionaries:''
	category:'Collections-Text'
!

!Text class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Texts add emphasis information to a string.

    Texts and strings should behave interchanchably to the outside
    world, except that texts keep per-character emphasis information.
    (strings return nil when asked for an element's emphasis).
    Use #string, to get a text's underlying plain string without any emphasis
    information.

    Currently, the following attributes are supported:
        #bold
        #italic
        #underline
        #underwave
        #strikeout
        (#color -> aColor)
        (#backgroundColor -> aColor)
        (#underlineColor -> aColor)
        (#strikeoutColor -> aColor)

    Attributes may be combined (pass an array of above) as emphasis.
    See examples.

    This class is a hack and may need some massage.

    [author:]
        Claus Gittinger

    [see also:]
        CharacterArray String RunArray
"
!

examples
"
  In a textView:
                                                                        [exBegin]
    |t v|

    t := 'The quick brown fox jumps over the lazy dog' asText.
    t emphasizeFrom:(t findString:'quick')
      count:5 with:#bold.

    t emphasizeFrom:(t findString:'brown')
      count:9 with:(Array with:#color->(Color name:'brown')
                                                     with:#bold).
    t emphasizeFrom:(t findString:'lazy')
      count:4 with:(Array with:#color->(Color red)
                                                      with:#italic).
    t emphasizeFrom:(t findString:'dog')
      count:3 with:#underline.

    v := HVScrollableView for:EditTextView.
    v contents:t.

    v width:450.
    v open.
                                                                        [exEnd]

                                                                        [exBegin]
    |t v|

    t := 'a',('1' emphasizeAllWith:#subscript),'x',('3' emphasizeAllWith:#superscript)
         ,'a',('2' emphasizeAllWith:#subscript),'x',('2' emphasizeAllWith:#superscript)
         ,'a',('3' emphasizeAllWith:#subscript),'x',('n' emphasizeAllWith:#superscript).

    Dialog information:t.
                                                                        [exEnd]

  plain string (for comparison):
                                                                        [exBegin]
    Dialog information:'hello'
                                                                        [exEnd]


  emphasized strings as dialog titles:
                                                                        [exBegin]
    Dialog
        information:((Text string:'hello') allBold)
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello' emphasis:#italic)
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello' emphasis:#(underline))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello' emphasis:#(underwave))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello' emphasis:#(bold underline))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello'
                 emphasis:(Array with:#bold
                                 with:#strikeout
                                 with:(#color->Color red)))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello'
                 emphasis:(Array with:(#color->Color black)
                                 with:#underwave
                                 with:(#underlineColor->Color red)))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello'
                 emphasis:(Array with:#bold
                                 with:#strikeout
                                 with:(#color->Color red)
                                 with:(#backgroundColor->Color yellow)))
                                                                        [exEnd]
                                                                        [exBegin]
    Dialog
        information:(Text string:'hello' color:(Color red))
                                                                        [exEnd]

"
! !

!Text class methodsFor:'initialization'!

initialize
    "initialize the class"

    "
     consider this a kludge:
     I want to inherit behavior from CharacterArray, but not
     its implementation (indexed access).
    "

    self flags:(Behavior flagRegular).

    BackgroundColorEmphasis := #backgroundColor.
    ColorEmphasis := #color.
    ItalicEmphasis := #italic.
    BoldEmphasis := #bold.
    UnderlineEmphasis := #underline.
    UnderwaveEmphasis := #underwave.
    OverlineEmphasis := #overline. 
    StrikeoutEmphasis := #strikeout.
    ReverseEmphasis := #reverse.
    BoldUnderlineEmphasis := #boldUnderline.
    BoldOverlineEmphasis := #boldOverline. 
    BoldUnderwaveEmphasis := #boldUnderwave.
    ItalicUnderlineEmphasis := #italicUnderline. 
    ItalicUnderwaveEmphasis := #italicUnderwave.
    UnderlineColorEmphasis := #underlineColor. 
    StrikeoutColorEmphasis := #strikeoutColor. 
    EtchColorEmphasis := #etchColor.
    FontEmphasis := #font.
    Superscript := #superscript.
    Subscript := #subscript.

    "
     Text initialize
    "

    "Modified: 12.5.1996 / 17:53:50 / cg"
! !

!Text class methodsFor:'instance creation'!

fromString:aString 
    "create a Text instance, for the characters in aString,
     without emphasis."

    ^ super new string:aString emphasis:nil

    "
     Text fromString:'hello'
    "

    "Modified: 12.5.1996 / 17:05:34 / cg"
!

new
    "create a new empty Text instance.
     Redefined for string-protocol compatibility"

    ^ super new string:'' emphasis:nil

    "Text new"

    "Modified: 12.5.1996 / 17:05:17 / cg"
    "Modified: 31.12.1996 / 12:39:57 / stefan"
!

new:size
    "create a new empty Text instance.
     Redefined for string-protocol compatibility"

    ^ self string:(String new:size)

    "Created: 12.5.1996 / 11:57:27 / cg"
    "Modified: 12.5.1996 / 17:05:17 / cg"
!

string:aString 
    "create a Text instance, for the characters in aString,
     without emphasis."

    ^ super new string:aString emphasis:nil

    "
     Text string:'hello'
    "

    "Modified: 12.5.1996 / 17:05:00 / cg"
!

string:aString color:aColor
    "create a Text instance, for the characters in aString,
     which are colored as aColor (only the foregroundColor is affected).
     This is a shortCut for creating an emphasis of (#color->aColor)"

    ^ super new string:aString emphasis:(#color->aColor)

    "
     Dialog
        information:(Text string:'hello' color:(Color red))
    "

    "Created: 12.5.1996 / 17:03:20 / cg"
    "Modified: 27.2.1997 / 10:13:36 / cg"
!

string:aString emphasis:attribute
    "create a Text instance, for the characters in aString,
     which are emphasized as described by attribute."

    ^ super new string:aString emphasis:attribute

    "
     Text string:'hello' emphasis:#bold

     Dialog
        information:(Text string:'hello' emphasis:#bold)

     Dialog
        information:(Text string:'hello' emphasis:#italic)

     Dialog
        information:(Text string:'hello' emphasis:#underline)

     Dialog
        information:(Text string:'hello' emphasis:#strikeout)
    "

    "Modified: 12.5.1996 / 17:16:03 / cg"
!

string:aString emphasisCollection:attributeCollection
    "create a Text instance, for the characters in aString,
     which are individually emphasized as described by attributeCollection."

    ^ super new string:aString emphasisCollection:attributeCollection

    "
     Text 
        string:'hello' 
        emphasisCollection:#(#bold #bold #italic #italic #italic)

     Dialog
        information:(Text 
                        string:'hello' 
                        emphasisCollection:#(#bold #bold #italic #italic #(#underline italic)))
    "

    "Created: 14.5.1996 / 14:02:18 / cg"
    "Modified: 14.5.1996 / 15:01:28 / cg"
!

string:aString foregroundColor:fgColor backgroundColor:bgColor
    "create a Text instance, for the characters in aString,
     which are colored in fgColor on bgColor.
     This is a shortCut for creating an emphasis of 
     #( #color->fgColor) (#backgroundColor->bgColor)"

    ^ super new 
        string:aString 
        emphasis:(Array with:#color->fgColor
                        with:#backgroundColor->bgColor)

    "
     Dialog
        information:(Text string:'hello' 
                          foregroundColor:(Color red)
                          backgroundColor:(Color yellow))
    "

    "Modified: 11.5.1996 / 14:21:01 / cg"
    "Created: 16.5.1996 / 12:37:24 / cg"
!

string:aString runs:aRun
    "create a Text instance, for the characters in aString,
     which are individually emphasized as described by attributeCollection."

    ^ super new string:aString emphasisCollection:aRun.
!

uninitializedNew:size
    "for compatibility only"

    ^ self new:size
!

writeStreamClass
    "the type of stream used in writeStream"

    ^ TextStream
! !

!Text class methodsFor:'emphasis constants'!

backgroundColorEmphasis
    ^ BackgroundColorEmphasis
!

foregroundColorEmphasis
    ^ ColorEmphasis
! !

!Text class methodsFor:'emphasis helper'!

addEmphasis:e1 to:e2
    "merge two emphasis's into one"

    |ne|

    e1 isNil ifTrue:[^ e2].
    e2 isNil ifTrue:[^ e1].
    e1 == e2 ifTrue:[^ e1].

    (e1 isSymbol 
     or:[e1 isAssociation]) ifTrue:[
        (e2 isSymbol 
         or:[e2 isAssociation]) ifTrue:[
            ^ Array with:e1 with:e2
        ].
        (e2 includes:e1) ifTrue:[^ e2].
        ^ e2 copyWith:e1
    ].
    (e2 isSymbol 
     or:[e2 isAssociation]) ifTrue:[
        (e1 includes:e2) ifTrue:[^ e1].
        ^ e1 copyWith:e2
    ].
    "/ ould use:
    "/    ^ (e1 asSet addAll:e2; asArray)

    "/ but we do it manually, to preserve the
    "/ order. (should create longer runs, while editing)

    ne := e1.
    e2 do:[:e |
        (ne includes:e) ifFalse:[
           ne := ne copyWith:e
        ]
    ].
    ^ ne.

    "
     Text addEmphasis:#bold to:#bold           
     Text addEmphasis:#bold to:#italic         
     Text addEmphasis:#bold to:#(italic strikeout)   
     Text addEmphasis:#italic to:#(italic strikeout) 
     Text addEmphasis:#(italic strikeout) to:#bold  
     Text addEmphasis:#(italic strikeout) to:#italic 
     Text addEmphasis:#(italic strikeout) to:#(bold underline) 
     Text addEmphasis:(#color->Color red) to:#(bold underline) 
    "

    "Modified: 14.5.1996 / 17:15:44 / cg"
!

emphasis:e1 includes:e2
    "return true, if e1 includes e2.
     e2 should be a single emphasis."

    e1 isNil ifTrue:[^ false].
    e2 isNil ifTrue:[^ false].
    e1 == e2 ifTrue:[^ true].

    e1 isSymbol ifTrue:[
        ^ false
    ].
    e1 isAssociation ifTrue:[
        ^ e1 key == e2
    ].
    (e1 isSymbol 
     or:[e1 isAssociation]) ifTrue:[
        ^ false
    ].
    e2 isSymbol ifTrue:[
        ^ (e1 includes:e2) or:[e1 contains:[:e |e isAssociation and:[e key == e2]]].
    ].
    e2 isAssociation ifTrue:[
        ^ (e1 includes:e2 key) or:[e1 contains:[:e |e isAssociation and:[e key == e2 key]]].
    ].
    ^ false

    "
     Text emphasis:#bold includes:#bold           
     Text emphasis:#bold includes:#italic         
     Text emphasis:#(italic strikeout) includes:#bold  
     Text emphasis:#(italic strikeout) includes:#italic 
     Text emphasis:(#color->Color red) includes:#color 
    "

    "Modified: 14.5.1996 / 17:45:11 / cg"
!

extractEmphasis:key from:e
    "if key is included in the emphasis, e then return the key.
     Otherwise, if a n association with that key is included, return the value.
     Otherwise, return nil."

    e isNil ifTrue:[^ nil].
    key == e ifTrue:[^ e].
    e isSymbol ifTrue:[^ nil].

    e isAssociation ifTrue:[
        e key == key ifTrue:[^ e value].
        ^ nil
    ].
    e do:[:entry | 
        entry == key ifTrue:[^ key].
        entry isAssociation ifTrue:[
            entry key == key ifTrue:[
                ^ entry value
            ]
        ]
    ].
    ^ nil

    "
     Text extractEmphasis:#bold  from:#bold           
     Text extractEmphasis:#bold  from:#italic           
     Text extractEmphasis:#bold  from:#(italic strikeout)           
     Text extractEmphasis:#bold  from:#(italic bold)           
     Text extractEmphasis:#color  from:(#color->Color red)           
     Text extractEmphasis:#color  from:(#foo->Color red)           
    "

    "Modified: 14.5.1996 / 17:45:11 / cg"
    "Created: 11.7.1996 / 09:49:58 / cg"
!

removeEmphasis:emToRemove from:empArg
    "remove an emphasis; if it was not in empArg, do nothing"

    |ne idx emp|

    emp := empArg.
    emToRemove isNil ifTrue:[^ emp].
    emp isNil ifTrue:[^ emp].
    emToRemove == emp ifTrue:[^ nil].

    emp isSymbol ifTrue:[
        emToRemove isSymbol ifTrue:[^ emp].  "/ knowing they are not identical
        emToRemove isAssociation ifTrue:[
            emToRemove key == emp ifTrue:[^ nil].
            ^ emp
        ].
        (emToRemove includes:emp) ifTrue:[^ nil].
        ^ emp
    ].
    emp isAssociation ifTrue:[
        emToRemove isSymbol ifTrue:[
            emp key == emToRemove ifTrue:[^ nil].
            ^ emp
        ].
        emToRemove isAssociation ifTrue:[
            emToRemove key == emp key ifTrue:[^ nil].
            ^ emp
        ].
        (emToRemove includes:emp) ifTrue:[^ nil].
        ^ emp
    ].
    "/ e2 must be a collection
    (emToRemove isSymbol 
     or:[emToRemove isAssociation]) ifTrue:[
        (emp includes:emToRemove) ifTrue:[
            ne := emp copyWithout:emToRemove.
            ne size == 1 ifTrue:[^ ne at:1].
            ne size == 0 ifTrue:[^ nil].
            ^ ne
        ].
        
        idx := emp findFirst:[:em | em isAssociation and:[em key == emToRemove]].
        (idx ~~ 0) ifTrue:[
            emp := emp copyWithoutIndex:idx.
            [ 
                idx := emp findFirst:[:em | em isAssociation and:[em key == emToRemove]] startingAt:idx.
                idx ~~ 0 
            ] whileTrue:[
                emp := emp copyWithoutIndex:idx.
            ]
        ].
        ^ emp
    ].

    "/ could use:
    "/    ^ (e2 asSet removeAll:e1; asArray)

    "/ but we do it manually, to preserve the
    "/ order. (should create longer runs, while editing)

    ne := emp.
    emToRemove do:[:e |
        (ne includes:e) ifTrue:[
           ne := ne copyWithout:e
        ]
    ].
    ne size == 1 ifTrue:[^ ne at:1].
    ne size == 0 ifTrue:[^ nil].
    ^ ne.

    "
     Text removeEmphasis:#bold from:#bold           
     Text removeEmphasis:#bold from:#italic         
     Text removeEmphasis:#bold from:#(italic strikeout)    
     Text removeEmphasis:#bold from:#(italic bold strikeout)    
     Text removeEmphasis:#italic from:#(italic strikeout) 
     Text removeEmphasis:#(italic strikeout) from:#bold  
     Text removeEmphasis:#(italic strikeout) from:#italic  
     Text removeEmphasis:#(italic strikeout) from:#(bold underline) 
     Text removeEmphasis:#(italic strikeout bold) from:#(bold underline) 
     Text removeEmphasis:#(italic strikeout bold underline) from:#(bold underline) 
     Text removeEmphasis:(#color->Color red) from:#(bold underline) 
     Text removeEmphasis:(#color->Color red) from:(#color->Color red) 
     Text removeEmphasis:#color from:(#color->Color red)   
     Text removeEmphasis:#color from:(#backgroundColor->Color red)      
     Text removeEmphasis:#color from:(Array with:#bold with:#underline with:#color->Color red) 
    "

    "Modified: / 25-01-2001 / 15:24:46 / ps"
    "Modified (comment): / 06-03-2012 / 18:23:32 / cg"
! !

!Text methodsFor:'accessing'!

at:characterIndex
    "return the plain character at characterIndex"

    ^ string at:characterIndex

    "Created: 11.5.1996 / 14:25:41 / cg"
    "Modified: 16.5.1996 / 11:15:33 / cg"
!

at:characterIndex put:aCharacter
    "change the character at characterIndex to be aCharacter.
     The emphasis (if any) of that character remains unchanged."

    ^ string at:characterIndex put:aCharacter

    "Created: 11.5.1996 / 14:25:49 / cg"
    "Modified: 16.5.1996 / 11:15:57 / cg"
!

byteAt:characterIndex
    "return the plain character at characterIndex"

    ^ string byteAt:characterIndex

    "Created: 11.5.1996 / 14:25:41 / cg"
    "Modified: 16.5.1996 / 11:15:33 / cg"
!

byteAt:characterIndex put:aCharacter
    "change the character at characterIndex to be aCharacter.
     The emphasis (if any) of that character remains unchanged."

    ^ string byteAt:characterIndex put:aCharacter

    "Created: 11.5.1996 / 14:25:49 / cg"
    "Modified: 16.5.1996 / 11:15:57 / cg"
! !

!Text methodsFor:'comparing'!

= aStringOrText
    "compare the receiver and the argument, ignoring emphasis"

    aStringOrText isString ifFalse:[^ false].
    ^ string = aStringOrText string


    "
     'hello' asText = 'hello'        
     'hello' asText = 'hello' asText 
     'hello' asText allBold = 'hello' 
    "

    "Modified: 4.6.1996 / 11:14:58 / cg"
!

hash
    "return a suitable hashcode (req'd since = is redefined)"

    ^ string hash

    "Created: / 19.6.1998 / 04:15:57 / cg"
! !

!Text methodsFor:'converting'!

asSingleByteString
    ^ self class string:string asSingleByteString runs:runs.

    "
      'hello world' asUnicodeString asText asSingleByteString
    "
!

asText
    "return a Text-object (string with emphasis) from myself.
     I am already a text object."

    ^ self

    "Created: 11.5.1996 / 14:08:36 / cg"
    "Modified: 16.5.1996 / 11:15:12 / cg"
! !

!Text methodsFor:'copying'!

, aStringOrText
    "concatenate the receiver's characters with the argument's characters, 
     and return string or text object containing those characters.
     If either the receiver or the argument contains emphasis information,
     a text object will be returned. 
     Otherwise, a string (i.e. without emphasis) is returned."

    |newRuns|

    aStringOrText isCharacter ifTrue:[
        ^ self , aStringOrText asString
    ].
    aStringOrText hasChangeOfEmphasis ifTrue:[    
        ^ self species new
            string:(string , aStringOrText)
            emphasisCollection:(runs , aStringOrText emphasisCollection)
    ].
    runs notNil "self hasChangeOfEmphasis" ifTrue:[ 
        newRuns := runs copyFrom:1 to:(runs size).
        newRuns add:nil withOccurrences:(aStringOrText size).
        ^ self species new
            string:(string , aStringOrText)
            emphasisCollection:newRuns
    ].
    ^ string , aStringOrText string

    "
     ('hello' asText allBold) , ' world'    
     'hello' , (' world' asText allBold)
     'hello' , ' world'
     ('hello' asText allBold) , (' world' asText allBold)
    "

    "Modified: / 31-03-1998 / 16:34:04 / cg"
    "Modified (comment): / 01-04-2012 / 13:20:02 / cg"
!

concatenateFromString:aString
    "return the concatenation of aString and myself.
     This may be a Text (if I have emphasis) or a string (if not)."

    self hasChangeOfEmphasis ifTrue:[
        ^ self species new
                string:(aString , string)
                emphasisCollection:((RunArray new:(aString size)) , runs).
    ].
    ^ aString , string

    "Modified: 14.5.1996 / 15:56:05 / cg"
!

copyFrom:start to:stop
    "return the subcollection starting at index start, anInteger and ending
     at stop, anInteger."

    self hasChangeOfEmphasis ifTrue:[
        ^ self species new
                string:(string copyFrom:start to:stop)
                emphasisCollection:(runs copyFrom:start to:stop).
    ].
    ^ string copyFrom:start to:stop

    "Modified: 14.5.1996 / 15:56:05 / cg"
    "Created: 22.10.1996 / 21:01:16 / cg"
!

postCopy
    string := string copy.
    runs := runs copy.

    "
     |t|

     t := 'hello' emphasizeAllWith:#bold.
     t inspect. t copy inspect.
     t emphasisAllRemove:#bold.
    "
! !

!Text methodsFor:'displaying'!

displayOn:aGCOrView x:x0 y:yBase opaque:opaqueWanted
    "display the receiver on a GC.
     This is one of the ugliest pieces of code..."

    |savedFont savedPaint savedFgPaint savedBgPaint font color boldFont italicFont boldItalicFont 
     bgPaint etchColor ulPaint strikePaint
     wasItalic overline altFont
     bold italic underline underwave strikeout reverse subOrSuperscript
     pos    "{ Class: SmallInteger }"
     endPos "{ Class: SmallInteger }"
     x y    
     len    "{ Class: SmallInteger }"
     bgFill
     yL k value device opaque|

    savedFont := aGCOrView basicFont.
    savedPaint := aGCOrView paint.
    savedBgPaint := aGCOrView backgroundPaint.

    opaque := opaqueWanted.
    device := aGCOrView graphicsDevice.

    pos := 1.
    x := x0.
    bold := italic := underline := underwave := strikeout := reverse := overline := false.

    runs size > string size ifTrue:[
        Transcript showCR:'inconsistent text: runs size > string size'.
        runs := runs copyTo:(string size)
    ].

    runs runsDo:[:runLen :emphasis |
        wasItalic := italic.
        color := savedPaint.
        bold := italic := underline := underwave := strikeout := reverse := overline := false.
        altFont := subOrSuperscript := nil.
        bgPaint := savedBgPaint.
        y := yBase.
        
        emphasis isSymbol ifTrue:[
            emphasis == BoldEmphasis ifTrue:[bold := true]
            ifFalse:[emphasis == ItalicEmphasis ifTrue:[italic := true]
            ifFalse:[emphasis == UnderlineEmphasis ifTrue:[underline := true]
            ifFalse:[emphasis == OverlineEmphasis ifTrue:[overline := true]   "MB:added"
            ifFalse:[emphasis == UnderwaveEmphasis ifTrue:[underwave := true]
            ifFalse:[emphasis == StrikeoutEmphasis ifTrue:[strikeout := true]
            ifFalse:[emphasis == ReverseEmphasis ifTrue:[reverse := true]
            ifFalse:[emphasis == BoldUnderlineEmphasis ifTrue:[bold := underline := true]
            ifFalse:[emphasis == BoldOverlineEmphasis ifTrue:[bold := overline := true]     "MB:added"
            ifFalse:[emphasis == BoldUnderwaveEmphasis ifTrue:[bold := underwave := true]
            ifFalse:[emphasis == ItalicUnderlineEmphasis ifTrue:[italic := underline := true]
            ifFalse:[emphasis == ItalicUnderwaveEmphasis ifTrue:[italic := underwave := true]
            ifFalse:[emphasis == Subscript ifTrue:[subOrSuperscript := Subscript]
            ifFalse:[emphasis == Superscript ifTrue:[subOrSuperscript := Superscript]
            ]]]]]]]]]]]]]
        ] ifFalse:[
            emphasis isAssociation ifTrue:[
                value := emphasis value.
                value notNil ifTrue:[
                    k := emphasis key.
                    k == ColorEmphasis ifTrue:[
                        color := value onDevice:device.
                        "/ emphasis value:color.
                    ] ifFalse:[k == BackgroundColorEmphasis ifTrue:[
                        bgPaint := value onDevice:device.
                        "/ emphasis value:bgPaint.
                        opaque := true.
                    ] ifFalse:[k == UnderlineColorEmphasis ifTrue:[
                        ulPaint := value onDevice:device.
                        "/ emphasis value:ulPaint.
                    ] ifFalse:[k == StrikeoutColorEmphasis ifTrue:[
                        strikePaint := value onDevice:device.
                        "/ emphasis value:strikePaint.
                    ] ifFalse:[k == EtchColorEmphasis ifTrue:[
                        etchColor := value onDevice:device.
                        "/ emphasis value:etchColor.
                    ] ifFalse:[k == FontEmphasis ifTrue:[
                        altFont := value onDevice:device.
                        "/ emphasis value:altFont.
                    ]]]]]]
                ]
            ] ifFalse:[
                emphasis notNil ifTrue:[
                    emphasis do:[:entry |
                        entry == BoldEmphasis ifTrue:[bold := true]
                        ifFalse:[entry == ItalicEmphasis ifTrue:[italic := true]
                        ifFalse:[entry == UnderlineEmphasis ifTrue:[underline := true]
                        ifFalse:[entry == OverlineEmphasis ifTrue:[overline := true] 
                        ifFalse:[entry == UnderwaveEmphasis ifTrue:[underwave := true]
                        ifFalse:[entry == StrikeoutEmphasis ifTrue:[strikeout := true]
                        ifFalse:[entry == ReverseEmphasis ifTrue:[reverse := true]
                        ifFalse:[entry == BoldUnderlineEmphasis ifTrue:[bold := underline := true]
                        ifFalse:[emphasis == BoldUnderwaveEmphasis ifTrue:[bold := underwave := true]
                        ifFalse:[entry == ItalicUnderlineEmphasis ifTrue:[italic := underline := true]
                        ifFalse:[emphasis == ItalicUnderwaveEmphasis ifTrue:[italic := underwave := true]
                        ifFalse:[emphasis == Subscript ifTrue:[subOrSuperscript := Subscript]
                        ifFalse:[emphasis == Superscript ifTrue:[subOrSuperscript := Superscript]
                        ifFalse:[
                            entry isAssociation ifTrue:[
                                value := entry value.
                                value notNil ifTrue:[
                                    k := entry key.
                                    k == ColorEmphasis ifTrue:[
                                        color := value onDevice:device.
                                        "/ entry value:color.
                                    ] ifFalse:[k == BackgroundColorEmphasis ifTrue:[
                                        bgPaint := value onDevice:device.
                                        "/ entry value:bgPaint.
                                        opaque := true.
                                    ] ifFalse:[k == UnderlineColorEmphasis ifTrue:[
                                        ulPaint := value onDevice:device.
                                        "/ entry value:ulPaint.
                                    ] ifFalse:[k == StrikeoutColorEmphasis ifTrue:[
                                        strikePaint := value onDevice:device.
                                        "/ entry value:strikePaint.
                                    ] ifFalse:[k == EtchColorEmphasis ifTrue:[
                                        etchColor := value onDevice:device.
                                        "/ entry value:etchColor.
                                    ] ifFalse:[k == FontEmphasis ifTrue:[
                                        altFont := value onDevice:device.
                                        "/ entry value:altFont.
                                    ]]]]]]
                                ]
                            ]
                        ]]]]]]]]]]]]]
                    ]
                ]
            ]
        ].
        altFont notNil ifTrue:[
            font := altFont.
        ] ifFalse:[
            bold ifTrue:[
                italic ifTrue:[
                    boldItalicFont isNil ifTrue:[
                        boldItalicFont := savedFont asBold asItalic onDevice:device
                    ].
                    font := boldItalicFont.
                ] ifFalse:[
                    boldFont isNil ifTrue:[
                        boldFont := savedFont asBold onDevice:device
                    ].
                    font := boldFont.
                ]
            ] ifFalse:[
                italic ifTrue:[
                    italicFont isNil ifTrue:[
                        italicFont := savedFont asItalic onDevice:device
                    ].
                    font := italicFont.
                ] ifFalse:[
                    font := savedFont
                ]
            ].
        ].
        subOrSuperscript notNil ifTrue:[
            font := font asSize:(font size * 3 // 4).
            subOrSuperscript == Superscript ifTrue:[
                y := y - (font height // 3).
            ] ifFalse:[                
                y := y + (font height // 3).
            ].    
        ].    
        aGCOrView basicFont:font.
        reverse ifTrue:[
            aGCOrView paint:bgPaint on:(bgFill := color).
            opaque := true.
        ] ifFalse:[
            aGCOrView paint:color on:(bgFill := bgPaint).
        ].

        endPos := pos + runLen - 1.

"/ disabled - it is too ugly (and not handled correctly, anyway).
"/        wasItalic ~~ italic ifTrue:[
"/            italic ifFalse:[
"/                "/ going from italic to non-italic; leave some space for the shear
"/                x := x + (font width " // 2" )
"/            ].
"/        ].

        len := font widthOf:string from:pos to:endPos.

        (opaque and:[etchColor isNil]) ifTrue:[
            aGCOrView fillRectangleX:x y:y+1 width:len height:(font descent) color:bgFill.
            aGCOrView displayOpaqueString:string from:pos to:endPos x:x y:y.
        ] ifFalse:[
            etchColor notNil ifTrue:[
                opaque ifTrue:[
                    "/ sigh - must draw the background rectangle;
                    "/ it's easier (and faster) to draw the string twice here ...
                    aGCOrView fillRectangleX:x y:y+1 width:len height:(font descent) color:bgFill.
                    aGCOrView displayOpaqueString:string from:pos to:endPos x:x y:y.
                ].
                savedFgPaint := aGCOrView paint.
                aGCOrView paint:etchColor.
                aGCOrView displayString:string from:pos to:endPos x:x+1 y:y+1.
                aGCOrView paint:savedFgPaint.
            ].
            aGCOrView displayString:string from:pos to:endPos x:x y:y.
        ].
        len := font widthOf:string from:pos to:endPos.

        underline ifTrue:[
            ulPaint notNil ifTrue:[aGCOrView paint:ulPaint].
            yL := y+1.
            aGCOrView displayLineFromX:x y:yL toX:x+len-1 y:yL
        ].
        overline ifTrue:[                               "MB:added v"
            ulPaint notNil ifTrue:[aGCOrView paint:ulPaint].
            yL := y-(font heightOf: string) + 2.
            aGCOrView displayLineFromX:x y:yL toX:x+len-1 y:yL
        ].                                               "MB:added ^"
        underwave ifTrue:[
            ulPaint notNil ifTrue:[aGCOrView paint:ulPaint].
            yL := y+1.
            aGCOrView displayHorizontalWavelineFromX:x y:yL toX:x+len-1
        ].
        strikeout ifTrue:[
            strikePaint notNil ifTrue:[aGCOrView paint:strikePaint].
            yL := y-(font ascent//2).
            aGCOrView displayLineFromX:x y:yL toX:x+len-1 y:yL
        ].

        x := x + len.
        pos := endPos + 1
    ].

    aGCOrView basicFont:savedFont.
    aGCOrView paint:savedPaint on:savedBgPaint.

    pos < string size ifTrue:[
       "/ draw rest
       aGCOrView displayString:string from:pos to:string size x:x y:y.
    ].

    "Created: / 12.5.1996 / 11:14:30 / cg"
    "Modified: / 7.7.1999 / 00:08:12 / cg"
! !

!Text methodsFor:'emphasis'!

actionForAll:aBlock
    "change the actionBlock of all characters. 
     Some widgets use this like a href if clicked onto the text."

    self emphasisAllAdd:(#actionBlock -> aBlock).

    "transcript ignores this...
     Transcript showCR:
        ((Text string:'hello - click on me') actionForAll:[Transcript flash]) 
    "

    "labels also...
     Label new
        label: ((Text string:'hello - click on me') actionForAll:[Transcript flash]);
        open
    "
!

allBold
    "make all characters bold"

    self emphasisAllAdd:BoldEmphasis

    "
     (Text string:'hello') allBold
     Transcript showCR: ('hello' allBold)   
    "

    "Modified: 10.7.1996 / 12:07:51 / cg"
!

allBoldOverline
    "make all characters bold and overline"

    self emphasisAllAdd:BoldOverlineEmphasis
!

allItalic
    "make all characters italic"

    self emphasisAllAdd:ItalicEmphasis

    "
     (Text string:'hello') allItalic
     Transcript showCR: ('hello' allItalic)   
    "

    "Modified: 10.7.1996 / 12:07:51 / cg"
!

allNonBold
    "make all characters non-bold"

    self emphasisAllRemove:BoldEmphasis

    "
     (Text string:'hello') allBold allNonBold
    "
!

allOverline
    "make all characters overline"

    self emphasisAllAdd:OverlineEmphasis

    "
     Transcript showCR: ('hello' asText allOverline)   
    "
!

allStrikedOut
    "strikeOut all characters"

    self emphasisAllAdd:StrikeoutEmphasis.

    "
     Transcript showCR: ('hello' allStrikedOut)   
    "
!

allUnderlined
    "underline all characters"

    self emphasisAllAdd:UnderlineEmphasis.

    "
     Transcript showCR:('hello' allUnderlined) 
    "
!

allUnderwaved
    "underwave all characters"

    self emphasisAllAdd:UnderwaveEmphasis.

    "
     Transcript showCR:('hello' asText allUnderwaved) 
    "
!

backgroundColorizeAllWith:aColor
    "change the bg-color of all characters"

    self emphasisAllAdd:(BackgroundColorEmphasis -> aColor).

    "
     Transcript showCR:
        ((Text string:'hello') backgroundColorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello' allBold backgroundColorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello' asText backgroundColorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello ' , ('red' allBold backgroundColorizeAllWith:(Color red)) , ' world')
    "

    "Modified: / 01-04-2011 / 16:19:21 / cg"
!

colorizeAllWith:aColor
    "change the color of all characters"

    self emphasisAllAdd:(ColorEmphasis -> aColor).

    "
     Transcript showCR:
        ((Text string:'hello') colorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello' colorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello' allBold colorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello' asText colorizeAllWith:(Color red)) 

     Transcript showCR:
        ('hello ' , ('red' allBold colorizeAllWith:(Color red)) , ' world')
    "
!

colorizeAllWith:fgColor on:bgColor
    "change the color and bg-color of all characters"

    self emphasisAllAdd:(ColorEmphasis -> fgColor).
    self emphasisAllAdd:(BackgroundColorEmphasis -> bgColor).

    "
     Transcript showCR:
        ((Text string:'hello') colorizeAllWith:(Color blue) on:(Color yellow)) 
    "

    "Created: / 05-08-2006 / 14:48:13 / cg"
!

emphasis
    "return the emphasis"

    ^ runs

    "
     (Text string:'hello') allBold emphasis 
     'hello' emphasis   
    "

    "Modified: 11.5.1996 / 14:22:31 / cg"
    "Created: 14.5.1996 / 13:59:03 / cg"
!

emphasis:emArray
    1 to:string size do:[:characterIndex |
        self emphasisAt:characterIndex put:(emArray at:characterIndex)
    ].

    "
     (Text string:'hello') emphasis:#(italic bold italic bold bold)
    "

    "Modified: / 31.3.1998 / 16:45:14 / cg"
!

emphasisAllAdd:newEmphasis
    "add to the emphasis to all characters. return the receiver"

    runs isNil ifTrue:[ ^ self ].   "/ just in case: empty

    (runs conform:[:runValue | runValue isNil]) ifTrue:[
        "/ no emphasis - happens often
        runs atAllPut:newEmphasis.
    ] ifFalse:[
        self emphasisFrom:1 to:(self size) add:newEmphasis
    ].

    "
     (Text string:'hello') allBold 
        emphasisAllAdd:#italic

     Transcript show:((Text string:'hello') allBold 
                        emphasisAllAdd:#italic)
    "
!

emphasisAllRemove:anEmphasis
    "remove the emphasis from all characters. return the receiver"

    self emphasisFrom:1 to:(self size) remove:anEmphasis

    "
     ((Text string:'hello') emphasizeAllWith:#(bold italic))
        emphasisAllRemove:#italic

     ((Text string:'hello') emphasizeAllWith:(Array with:#color->Color red
                                                    with:#italic))
        emphasisAllRemove:#italic

     ((Text string:'hello') emphasizeAllWith:(Array with:#color->Color red
                                                    with:#italic))
        emphasisAllRemove:#color

     Transcript show:(((Text string:'hello') emphasizeAllWith:#(bold italic)) 
                        emphasisAllRemove:#italic)
    "
!

emphasisAt:characterIndex
    "return the emphasis at some index"

    ^ runs at:characterIndex

    "
     (Text string:'hello') allBold emphasisAt:2 
    "

    "Modified: 11.5.1996 / 14:22:31 / cg"
!

emphasisAt:characterIndex add:newEmphasis
    "add to the emphasis at some index. return the receiver"

    |e prevE|

    e := runs at:characterIndex.
    e := self class addEmphasis:newEmphasis to:e.

    "/ if its equal to the previous emphasis, make it identical.

    characterIndex > 1 ifTrue:[
        prevE := runs at:characterIndex-1.
        e = prevE ifTrue:[
            e := prevE
        ]
    ].
    runs at:characterIndex put:e.

    "
     (Text string:'hello') allBold emphasisAt:2 add:#italic
    "

    "Created: / 14.5.1996 / 16:48:39 / cg"
    "Modified: / 31.3.1998 / 15:29:14 / cg"
!

emphasisAt:characterIndex put:emphasis
    "change the emphasis at some index. return the receiver"

    |e prevE|

    e := emphasis.

    "/ if its equal to the previous emphasis, make it identical.

    characterIndex > 1 ifTrue:[
        prevE := runs at:characterIndex-1.
        emphasis = prevE ifTrue:[
            e := prevE
        ]
    ].
    runs at:characterIndex put:e.

    "
     (Text string:'hello') allBold emphasisAt:2 put:#italic
    "

    "Modified: / 31.3.1998 / 16:45:14 / cg"
!

emphasisAt:characterIndex remove:emphasisToRemove
    "remove from the emphasis at some index. return the receiver"

    |e|

    e := runs at:characterIndex.
    e := self class removeEmphasis:emphasisToRemove from:e.
    runs at:characterIndex put:e.

    "
     (Text string:'hello') 
        allBold emphasisAt:2 remove:#bold

     (Text string:'hello' emphasis:#(bold italic)) 
        emphasisAt:2 remove:#bold
    "

    "Created: 14.5.1996 / 16:48:39 / cg"
    "Modified: 14.5.1996 / 17:25:04 / cg"
!

emphasisCollection
    "return the emphasis"

    ^ runs

    "
     (Text string:'hello') allBold emphasis 
     'hello' emphasis   
    "

    "Created: 14.5.1996 / 13:59:03 / cg"
    "Modified: 14.5.1996 / 15:02:11 / cg"
!

emphasisFrom:start to:stop add:newEmphasis
    "add to the emphasis within some range. return the receiver"

    start to:stop do:[:characterIndex |
        self emphasisAt:characterIndex add:newEmphasis
    ].

    "
     (Text string:'hello') allBold 
        emphasisFrom:2 to:4 add:#italic

     Transcript showCR:((Text string:'hello') allBold 
                            emphasisFrom:2 to:4 add:#italic)

    "
!

emphasisFrom:start to:stop remove:anEmphasis
    "remove from the emphasis within some range. return the receiver"

    start to:stop do:[:characterIndex |
        self emphasisAt:characterIndex remove:anEmphasis
    ].

    "
     (Text string:'hello') allBold 
        emphasisFrom:2 to:4 remove:#bold

     Transcript showCR:((Text string:'hello') allBold 
                            emphasisFrom:2 to:4 remove:#bold)
    "
!

emphasiseFrom:start to:stop with:newEmphasis
    "set to the emphasis within some range. return the receiver"

    start to:stop do:[:characterIndex |
        self emphasisAt:characterIndex put:newEmphasis
    ].

    "
     (Text string:'hello') allBold 
        emphasiseFrom:2 to:4 with:#italic

     Transcript showCR:((Text string:'hello') allBold 
                            emphasiseFrom:2 to:4 with:#italic)

    "
!

emphasizeAllWith:emphasis
    "change the emphasis of all characters"

    runs := RunArray new:(string size) withAll:emphasis.

    "
     (Text string:'hello') allBold emphasizeAllWith:#italic 
    "

    "Modified: 11.5.1996 / 14:22:52 / cg"
!

emphasizeFrom:start count:count with:emphasis
    "change the emphasis of a range of characters, given startIndex and count."

    self emphasizeFrom:start to:(start+count-1) with:emphasis

    "
     (Text string:'hello world') 
        emphasizeFrom:1 count:5 with:#bold;
        emphasizeFrom:7 count:5 with:#italic
    "

    "Modified: 11.5.1996 / 14:30:02 / cg"
    "Created: 16.5.1996 / 10:52:27 / cg"
!

emphasizeFrom:start to:stop with:emphasis
    "change the emphasis of a range of characters"

"/    |newRuns|

    runs from:start to:stop put:emphasis.

"/    newRuns := RunArray new.
"/
"/    "/ for now - a q&d hack
"/    1 to:start-1 do:[:i |
"/        newRuns add:(runs at:i).
"/    ].
"/    newRuns add:emphasis withOccurrences:(stop - start + 1).
"/    stop+1 to:string size do:[:i |
"/        newRuns add:(runs at:i)
"/    ].
"/    runs := newRuns

    "
     (Text string:'hello world') 
        emphasizeFrom:1 to:5 with:#bold;
        emphasizeFrom:7 to:11 with:#italic
    "

    "Modified: / 7.4.1998 / 08:52:18 / cg"
!

emphasizeFrom:start with:emphasis
    "change the emphasis of some characters upTo the end"

    self emphasizeFrom:start to:(self size) with:emphasis

    "
     (Text string:'hello world') 
        emphasizeFrom:1 count:5 with:#bold;
        emphasizeFrom:7 with:#italic
    "

    "Modified: 11.5.1996 / 14:30:02 / cg"
    "Created: 17.5.1996 / 15:15:32 / cg"
!

strikeoutAll
    "strikeout all characters"

    self emphasisAllAdd:StrikeoutEmphasis.

    "
     Transcript showCR:
        ('hello' asText strikeoutAll) 
    "
!

withoutAnyColorEmphasis
    "return a copy with color emphasis removed (fg and bg)"

    ^ (self withoutEmphasis:BackgroundColorEmphasis) 
            withoutEmphasis:ColorEmphasis
!

withoutBackgroundColorEmphasis
    "return a copy with bg-color emphasis removed"

    ^ self withoutEmphasis:BackgroundColorEmphasis
!

withoutEmphasis
    "return my underlying plain string"

    ^ string
!

withoutEmphasis:emphasisToRemove 
    "return a copy with a particular emphasis removed"

    |newText anyEmphasis|

    self hasChangeOfEmphasis ifTrue:[
        newText := self copyFrom:1 to:self size.
        anyEmphasis := false.
        1 to:newText size do:[:col |
            |em newem|

            em := (newText emphasis) at:col.
            em notNil ifTrue:[
                newem := Text removeEmphasis:emphasisToRemove from:em.
                newem ~~ em ifTrue:[
                    newText emphasisAt:col put:newem.
                ].
                newem notNil ifTrue:[ anyEmphasis := true ].
            ].
        ].
        anyEmphasis ifFalse:[^ newText string].
        ^ newText
    ].
    ^ self
!

withoutForegroundColorEmphasis
    "return a copy with fg-color emphasis removed"

    ^ self withoutEmphasis:ColorEmphasis
! !


!Text methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "append a printed representation from which the receiver can be reconstructed
     to aStream."

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        aGCOrStream nextPutAll:'(Text string:'.
        string storeOn:aGCOrStream.
        aGCOrStream nextPutAll:' runs:'.
        runs displayOn:aGCOrStream.
        aGCOrStream nextPutAll:')'.
        ^ self.
    ].
    ^ self displayOn:aGCOrStream x:0 y:0.

    "Created: 11.5.1996 / 14:27:09 / cg"
    "Modified: 16.5.1996 / 11:23:32 / cg"
!

displayString
    "return a string used when displaying the receiver in a view."

    ^ self.
!

printOn:aStream
    "print the receiver's characters (including emphasis) on aStream. 
     Notice, that some streams simply ignore the emphasis"

    aStream nextPutAllText:self

    "
     Transcript showCR:'hello world'.
     Transcript showCR:'hello world' asText allBold.
     Transcript showCR:('hello world' asText emphasizeAllWith:#italic).
    "

    "Modified: 12.7.1996 / 10:15:47 / cg"
!

storeOn:aStream
    "append a printed representation from which the receiver can be reconstructed
     to aStream."

    aStream nextPutAll:'(Text string:'.
    string storeOn:aStream.
    aStream nextPutAll:' runs:'.
    runs storeOn:aStream.
    aStream nextPutAll:')'.

    "Created: 11.5.1996 / 14:27:09 / cg"
    "Modified: 16.5.1996 / 11:23:32 / cg"
! !

!Text methodsFor:'private-accessing'!

emphasisCollection:emphasisCollection
    "set the string and emphasis collection.
     The emphasis collection contains per-character information."

    runs := emphasisCollection.

    "Created: / 7.4.1998 / 08:52:03 / cg"
!

runs
    ^ runs
!

setRuns:anArrayOrRunArray
    runs := anArrayOrRunArray.
!

setString:aString setRuns:anArrayOrRunArray
    string := aString.
    runs := anArrayOrRunArray.
!

string:aString emphasis:emphasis
    "set the string and emphasis. The emphasis is applied to all characters."

    string := aString string.
    runs   := RunArray new:string size withAll:emphasis.

    "
     |t|

     t := Text new string:'hello' emphasis:#bold.
     t emphasisAt:2.
    "

    "Modified: 16.5.1996 / 11:24:03 / cg"
!

string:aString emphasisCollection:emphasisCollection
    "set the string and emphasis collection.
     The emphasis collection contains per-character information."

    string := aString string.
    string size == 0 ifTrue:[
        runs := RunArray new.
    ] ifFalse:[
        runs := emphasisCollection asRunArray
    ].

    "
     |t|

     t := Text new string:'hello' emphasisCollection:(#bold #bold #bold #italic #italic).
     t emphasisAt:2.
    "

    "Created: 14.5.1996 / 14:03:29 / cg"
    "Modified: 16.5.1996 / 11:24:21 / cg"
! !

!Text methodsFor:'queries'!

bitsPerCharacter
    "return the number of bits I (my underlying string) require for storage.
     (i.e. is it a regular String or a TwoByteString)"

    ^ string bitsPerCharacter.
!

emphasisAtPoint:aPoint on:aGCOrView
    "return the emphasis at a given point, or nil if there is none"

    |pointX savedFont boldFont italicFont bold italic wasItalic pos font len gcDevice posX boldItalicFont|

    gcDevice := aGCOrView graphicsDevice.
    savedFont := aGCOrView basicFont onDevice:gcDevice.

    pos := 1.
    posX := 0.
    pointX := aPoint x.
    len := 0.
    italic := false.
    runs runsDo:[:runLen :emphasis |
        wasItalic := italic.
        emphasis isSymbol ifTrue:[
            bold := emphasis == BoldEmphasis 
                        or:[emphasis == BoldUnderlineEmphasis
                        or:[emphasis == BoldOverlineEmphasis
                        or:[emphasis == BoldUnderwaveEmphasis]]].
            italic := emphasis == ItalicEmphasis
                        or:[emphasis == ItalicUnderlineEmphasis
                        or:[emphasis == ItalicUnderwaveEmphasis]].
        ] ifFalse:[
            bold := italic := false.
            (emphasis isNil or:[emphasis isAssociation]) ifFalse:[
                emphasis do:[:eachEmphasisSymbol|
                    eachEmphasisSymbol == BoldEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == ItalicEmphasis ifTrue:[italic := true]
                    ifFalse:[eachEmphasisSymbol == BoldUnderlineEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == BoldUnderwaveEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == ItalicUnderlineEmphasis ifTrue:[italic := true]
                    ifFalse:[eachEmphasisSymbol == ItalicUnderwaveEmphasis ifTrue:[italic := true]]]]]].
                ].
            ]
        ].

        bold ifTrue:[
            italic ifTrue:[
                boldItalicFont isNil ifTrue:[
                    boldItalicFont := savedFont asBold asItalic onDevice:gcDevice
                ].
                font := boldItalicFont.
            ] ifFalse:[
                boldFont isNil ifTrue:[
                    boldFont := savedFont asBold onDevice:gcDevice
                ].
                font := boldFont.
            ]
        ] ifFalse:[
            italic ifTrue:[
                italicFont isNil ifTrue:[
                    italicFont := savedFont asItalic onDevice:gcDevice
                ].
                font := italicFont
            ] ifFalse:[
                font := savedFont
            ]
        ].
"/ disabled - it is too ugly (and not handled correctly, anyway).
"/        wasItalic ~~ italic ifTrue:[
"/            italic ifFalse:[
"/                "/ going from italic to non-italic; leave some space for the shear
"/                l := l + (f width " // 2" )
"/            ].
"/        ].
        len := font widthOf:string from:pos to:(pos + runLen - 1).
        (pointX between:posX and:posX + len) ifTrue:[
            ^ emphasis
        ].
        pos := pos + runLen.
        posX := posX + len.
    ].

    ^ nil
!

encoding
    ^ string encoding
!

hasChangeOfEmphasis
    "return true, if the receiver contains non-empty emphasis information
     i.e. any non-normal (=emphasized) characters"

    ^ runs notEmptyOrNil
       and:[ runs contains:[:e | e notNil] ]

    "Created: 11.5.1996 / 14:03:19 / cg"
    "Modified: 14.5.1996 / 15:51:01 / cg"
!

hasEmphasis: emphasis
    "return true, if the receiver contains given emphasis"

    "HACK!!!!!!"

    | emphasisArray  |

    (emphasis isSymbol or:[emphasis isAssociation]) ifTrue:[
        emphasisArray := Array with: emphasis
    ] ifFalse:[
        emphasisArray := emphasis.
    ].
    emphasisArray isNil ifTrue:[^false].
    
    runs do:[:runEmph|    
        emphasisArray do:[:searchEmph|
            (runEmph = searchEmph 
            or: [runEmph isCollection 
                 and:[runEmph isSymbol not 
                 and:[runEmph includes: searchEmph]]]
            ) ifTrue:[
                ^ true
            ]                    
        ]
    ].
    ^ false

    "
        'Hello' asText allBold hasEmphasis: #bold.
        'Hello' asText allBold allUnderlined hasEmphasis: #bold.
        'Hello' asText allBold allUnderlined hasEmphasis: #italic.                              
        ('Hello' asText allBold allUnderlined , ' World' asText allItalic) hasEmphasis: #italic.
    "

    "Created: / 20-07-2011 / 17:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:55:10 / cg"
!

heightOn:aGC
    "return the number of device units, required on aGC's device"

    ^ aGC deviceFont heightOf:string

    "Created: 12.5.1996 / 11:02:03 / cg"
!

indexOf:aCharacter startingAt:index
    "search aCharacters index in the underlying string"

    ^ string indexOf:aCharacter startingAt:index

    "Created: 11.5.1996 / 13:58:56 / cg"
    "Modified: 16.5.1996 / 11:25:12 / cg"
!

isPlainString
    "return true, if the receiver is a plain string - without attributes;
     false is returned here."

    ^ false
!

isText
    "return true if this is a Text object - always true here"

    ^ true

    "Created: 12.5.1996 / 10:56:24 / cg"
    "Modified: 16.5.1996 / 11:25:29 / cg"
!

occurrencesOf:aCharacter
    "count & return the number of occurrences of aCharacter in the 
     underlying string"

    ^ string occurrencesOf:aCharacter

    "Created: 11.5.1996 / 13:58:46 / cg"
    "Modified: 16.5.1996 / 11:25:51 / cg"
!

size
    "return the number of characters in the underlying string"

    ^ string size

    "Created: 11.5.1996 / 14:25:15 / cg"
    "Modified: 16.5.1996 / 11:26:08 / cg"
!

string
    "return the receiver without any emphasis information
     i.e. the underlying string."

    ^ string

    "Created: 11.5.1996 / 13:58:38 / cg"
    "Modified: 16.5.1996 / 11:26:30 / cg"
!

widthFrom:startIndex to:endIndex on:aGC
    "return the number of device units, required on aGC's device"

    ^ (self copyFrom:startIndex to:endIndex) widthOn:aGC
!

widthOn:aGC
    "return the number of device units, required on aGC's device"

    |savedFont boldFont italicFont bold italic wasItalic pos font len gcDevice boldItalicFont|

    gcDevice := aGC graphicsDevice.
    savedFont := aGC basicFont onDevice:gcDevice.

    pos := 1.
    len := 0.
    italic := false.
    runs runsDo:[:runLen :emphasis |
        wasItalic := italic.
        emphasis isSymbol ifTrue:[
            bold := emphasis == BoldEmphasis 
                        or:[emphasis == BoldUnderlineEmphasis
                        or:[emphasis == BoldOverlineEmphasis
                        or:[emphasis == BoldUnderwaveEmphasis]]].
            italic := emphasis == ItalicEmphasis
                        or:[emphasis == ItalicUnderlineEmphasis
                        or:[emphasis == ItalicUnderwaveEmphasis]].
        ] ifFalse:[
            bold := italic := false.
            (emphasis isNil or:[emphasis isAssociation]) ifFalse:[
                emphasis do:[:eachEmphasisSymbol|
                    eachEmphasisSymbol == BoldEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == ItalicEmphasis ifTrue:[italic := true]
                    ifFalse:[eachEmphasisSymbol == BoldUnderlineEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == BoldUnderwaveEmphasis ifTrue:[bold := true]
                    ifFalse:[eachEmphasisSymbol == ItalicUnderlineEmphasis ifTrue:[italic := true]
                    ifFalse:[eachEmphasisSymbol == ItalicUnderwaveEmphasis ifTrue:[italic := true]]]]]].
                ].
            ]
        ].

        bold ifTrue:[
            italic ifTrue:[
                boldItalicFont isNil ifTrue:[
                    boldItalicFont := savedFont asBold asItalic onDevice:gcDevice
                ].
                font := boldItalicFont.
            ] ifFalse:[
                boldFont isNil ifTrue:[
                    boldFont := savedFont asBold onDevice:gcDevice
                ].
                font := boldFont.
            ]
        ] ifFalse:[
            italic ifTrue:[
                italicFont isNil ifTrue:[
                    italicFont := savedFont asItalic onDevice:gcDevice
                ].
                font := italicFont
            ] ifFalse:[
                font := savedFont
            ]
        ].
"/ disabled - it is too ugly (and not handled correctly, anyway).
"/        wasItalic ~~ italic ifTrue:[
"/            italic ifFalse:[
"/                "/ going from italic to non-italic; leave some space for the shear
"/                l := l + (f width " // 2" )
"/            ].
"/        ].
        len := len + (font widthOf:string from:pos to:(pos + runLen - 1)).
        pos := pos + runLen
    ].

    ^ len

    "Modified: 5.7.1996 / 17:54:58 / cg"
! !

!Text methodsFor:'replacing'!

replaceFrom:start to:stop with:aCollection startingAt:startIndex
    "replace a range of characters, from another string or text object.
     The corresponding characters' emphasis information is also copied.
     Return the receiver."

    |idx maxCharacter|

    aCollection isString ifTrue:[
        aCollection bitsPerCharacter > string bitsPerCharacter ifTrue:[
            "have to create a new string with appropriate character size"
            string := aCollection string species fromString:string.
        ].
        aCollection hasChangeOfEmphasis ifTrue:[
            string replaceFrom:start to:stop with:aCollection startingAt:startIndex.
            idx := startIndex.
            start to:stop do:[:col |
                self emphasisAt:col put:(aCollection emphasisAt:idx).
                idx := idx + 1.
            ].
            ^ self.
        ]
    ] ifFalse:[
        "aCollection is an arbitrary SequenceableCollection"
        maxCharacter := $0.    "some 8-bit character"
        aCollection do:[:eachCharacter |
            maxCharacter := maxCharacter max:eachCharacter
        ].
        maxCharacter bitsPerCharacter > string bitsPerCharacter ifTrue:[
            "have to create a new string with appropriate character size"
            string := maxCharacter stringSpecies fromString:string.
        ].
    ].
        
    string replaceFrom:start to:stop with:aCollection startingAt:startIndex.
    self emphasizeFrom:start to:stop with:nil.

    "
     ((Text string:'hello') allBold emphasisAt:2 put:#italic)
        replaceFrom:1 to:3 with:'HEL' startingAt:1

     ((Text string:'hello') allBold emphasisAt:2 put:#italic)
        replaceFrom:1 to:3 with:#($H $E $L) startingAt:1
    "

    "Modified: / 28.1.1998 / 16:50:06 / cg"
! !

!Text class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Text initialize!
