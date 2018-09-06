"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#CharacterSetView
	instanceVariableNames:'codePageHolder selectedCodePointHolder masterViewOrNil
		encoderOrNil'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!CharacterSetView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Can be used both as an informative display of a font's characters
    (opened via the fontPanels-preview-popUpMenu)
    or to insert characters into a textView 
    (opened by a textEditors misc-specialCharacters menu).

    Author:
        Claus Gittinger
"
!

examples
"
    CharacterSetView openOn:(Button defaultFont).


    CharacterSetView 
        openAsInputFor:Transcript
        label:'Input to Transcript'
        clickLabel:'Click to input character'
"
! !

!CharacterSetView class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!CharacterSetView class methodsFor:'startup'!

open
    self openOn:(View defaultFont)

    "
     self open
    "
!

openAsInputFor:aView label:viewLabel clickLabel:clickLabel
    ^ self 
        openOn:aView font
        label:viewLabel 
        clickLabel:clickLabel
        asInputFor:aView
!

openOn:aFont
    ^ self
        openOn:aFont 
        label:aFont printString
        clickLabel:'Click on glyph to see its codePoint.'

    "
     self openOn:(View defaultFont).
    "
!

openOn:aFont label:viewLabel clickLabel:clickLabel
    ^ self 
        openOn:aFont 
        label:viewLabel 
        clickLabel:clickLabel 
        asInputFor:nil
!

openOn:aFont label:viewLabel clickLabel:clickLabel asInputFor:aView
    self
        openOn:aFont 
        label:viewLabel 
        clickLabel:clickLabel 
        asInputFor:aView 
        encoder:nil

    "
     self openOn:(View defaultFont).
     self openOn:(Font family:'courier' face:'medium' style:'roman' size:12 encoding:'iso10646-1').
    "
!

openOn:aFont label:viewLabel clickLabel:clickLabel asInputFor:aConsumingView encoder:aCharacterEncoderOrNil
    |top panel v bNext bPrev bFirst bLast comboList rangeLabel codePointLabel
     first last next prev enable update updateCodePoint w h
     minPage maxPage insertCharacter deviceFont minCode maxCode
     htmlHolder codePageList|

    htmlHolder := false asValue.

    aCharacterEncoderOrNil isNil ifTrue:[
        deviceFont := aFont onDevice:Screen current.
        minCode := deviceFont minCode.
        maxCode := deviceFont maxCode.
    ] ifFalse:[
        minCode := aCharacterEncoderOrNil minCode.
        maxCode := aCharacterEncoderOrNil maxCode.
    ].

    minPage := minCode >> 8.
    maxPage := maxCode >> 8.

    top := StandardSystemView new.
    top label:viewLabel.

    v := self origin:0.0@0.0 corner:1.0@1.0 in:top.
    v topInset:25.
    v font:aFont.
    v codePageHolder value:minPage.
    v characterEncoding:(aFont encoding).
    v encoder:aCharacterEncoderOrNil.

    panel := HorizontalPanelView in:top.
    panel origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
    panel bottomInset:-25.
    panel horizontalLayout:#leftSpace.

    aConsumingView notNil ifTrue:[
        v useSameFontAs:aConsumingView.
    ].

    "/ actions
    aConsumingView notNil ifTrue:[
        insertCharacter := [:char | 
                                (char isString ifTrue:[char] ifFalse:[Array with:char])
                                do:[:char | 
                                    |unicodePoint unicodeChar pastedString|

                                    unicodePoint := CharacterEncoder encode:(char codePoint) from:aConsumingView characterEncoding into:#unicode.
                                    unicodeChar := Character value:unicodePoint.
                                    pastedString := unicodeChar asString.
                                    htmlHolder value ifTrue:[
                                        "/ insert html
                                        pastedString := HTMLUtilities escapeCharacterEntities:pastedString.
                                    ].
                                    pastedString do:[:eachChar |
                                        aConsumingView dispatchEvent:(WindowEvent keyPress:eachChar x:0 y:0 view:v).
                                        aConsumingView dispatchEvent:(WindowEvent keyRelease:eachChar x:0 y:0 view:v).
                                    ].
                                ].
                           ].
    ].

    updateCodePoint := [
            |selectedCodePoint selectedChar 
             isLetter isDigit isUppercase isLowercase 
             codeString decoded decodedString|

            selectedCodePoint := v selectedCodePoint.
            selectedCodePoint isNil ifTrue:[
                codePointLabel label:clickLabel
            ] ifFalse:[
                selectedChar := Character value:selectedCodePoint.
                (#(unicode #'iso10646-1' #'iso8859-1' ascii) includes:(v font encoding))
                ifTrue:[
                    isLetter := selectedChar isNationalLetter.
                    isDigit := selectedChar isNationalDigit.
                    isUppercase := selectedChar isUppercase.
                    isLowercase := selectedChar isLowercase.
                ] ifFalse:[
                    isLetter := isDigit := isUppercase := isLowercase := false.     "/ actually: unknown
                ].
                aCharacterEncoderOrNil isNil ifTrue:[
                    decodedString := ''.
                    codeString := 'u' , ((selectedCodePoint printStringRadix:16) leftPaddedTo:4 with:$0)
                ] ifFalse:[
                    decoded := aCharacterEncoderOrNil decode:selectedCodePoint.
                    decodedString := 'u' , ((decoded printStringRadix:16) leftPaddedTo:4 with:$0).
                    codeString := ((selectedCodePoint printStringRadix:16) leftPaddedTo:4 with:$0)
                ].
                codePointLabel 
                    label:
                        ('Selected: %1 %2 %3 %4 %5'
                            bindWith:codeString
                            with:((selectedCodePoint printString) leftPaddedTo:5)
                            with:(isUppercase ifTrue:'Uc' ifFalse:[isLowercase ifTrue:'lc' ifFalse:''])
                            with:(isLetter ifTrue:'Letter' ifFalse:[(isDigit ifTrue:'Digit' ifFalse:'')])
                            with:decodedString
                        ).
            ].
            codePointLabel repairDamage.

            aConsumingView notNil ifTrue:[
                selectedCodePoint notNil ifTrue:[
                    insertCharacter value:(Character value:selectedCodePoint).
                    v selectedCodePointHolder setValue:nil.
                ]
            ]
    ].

    update := [
            |uOffs selectedCodePoint lbl nm|

            aCharacterEncoderOrNil isNil ifTrue:[
                lbl := 'u%1..u%2'
            ] ifFalse:[
                nm := aCharacterEncoderOrNil userFriendlyNameOfEncoding.
                lbl := '%1..%2 / %3'
            ].
            uOffs := v codePage * 16r0100.
            rangeLabel label:(lbl 
                        bindWith:((uOffs printStringRadix:16) leftPaddedTo:4 with:$0)
                        with:(((uOffs + 16rFF) printStringRadix:16) leftPaddedTo:4 with:$0)
                        with:nm).
            rangeLabel repairDamage.
        ].

    minPage ~~ maxPage ifTrue:[
        enable := [
                v codePage > minPage ifTrue:[ 
                    bPrev enable. 
                    bFirst enable. 
                ] ifFalse:[
                    bPrev disable. 
                    bFirst disable. 
                ].
                v codePage < maxPage ifTrue:[ 
                    bNext enable. 
                    bLast enable. 
                ] ifFalse:[
                    bNext disable. 
                    bLast disable. 
                ].
            ].
    ].

    next := [
            v codePage:(v codePage + 1). 
            enable value.
            update value.
        ].

    prev := [
            v codePage:(v codePage - 1). 
            enable value.
            update value.
        ].

    first := [
            v codePage:minPage. 
            enable value.
            update value.
        ].

    last := [
            v codePage:maxPage. 
            enable value.
            update value.
        ].

    minPage ~~ maxPage ifTrue:[

        comboList := ComboListView in:panel.
        comboList extent:(16@16).
        comboList label:'?'.
        codePageList := 
            #(
                (16r00   'Latin')          
                (16r03   'Greek')  
                (16r05   'Hebrew')  
                (16r06   'Arabic')
                (16r22   'Math')   
                (16r29   'Math Symbols') 
                (16r2A   'Math Operators') 
                (16r21   'Arrows & Math Letters') 
                (16r23   'Technical') 
                (16r20   'Currency') 
                (16r33   'Units') 
                (16r27   'Dingbat')
                (16r25   'Block Graphic') 
            ).
        comboList 
            list:   (codePageList collect:#second);
            values: (codePageList collect:#first). 
        comboList action:
            [:cp | 
                v codePage:cp. 
                enable value.
                update value.
            ].

        bFirst := Button label:(ToolbarIconLibrary start16x16Icon) in:panel.
        bFirst action:first.

        bPrev := Button label:(ToolbarIconLibrary back16x16Icon) in:panel.
        bPrev controller beTriggerOnDown.
        bPrev action:prev.
        bPrev disable.
        bPrev autoRepeat:true.

        bNext := Button label:(ToolbarIconLibrary forward16x16Icon) in:panel.
        bNext controller beTriggerOnDown.
        bNext action:next.
        bNext autoRepeat:true.

        bLast := Button label:(ToolbarIconLibrary finish16x16Icon) in:panel.
        bLast action:last.
        bLast disable.
    ].

    rangeLabel := Label label:'RangeStart .. RangeStop' in:panel.

    codePointLabel := Label label:clickLabel in:panel.
    codePointLabel foregroundColor:(Color blue).

    aConsumingView notNil ifTrue:[
        panel add:(CheckBox label:'HTML' model:htmlHolder)
    ].

    update value.
    enable value.

    v selectedCodePointHolder onChangeEvaluate:updateCodePoint.
    v codePageHolder onChangeEvaluate:update.

    w := v preferredWidth max:(panel preferredWidth).
    h := v preferredHeight + (panel preferredHeight).
    top extent:(w @ h).

    aConsumingView notNil ifTrue:[
        top application:(aConsumingView application).
        top beSlave.
    ].
    top open.
    ^ v

    "
     self openOn:(View defaultFont).
     self openOn:(Font family:'courier' face:'medium' style:'roman' size:12 encoding:'iso10646-1').
    "

    "Modified: / 11-10-2006 / 22:30:32 / cg"
! !

!CharacterSetView methodsFor:'accessing'!

codePage
    ^ codePageHolder value
!

codePage:pageNr
    codePageHolder value:pageNr.
!

codePageHolder
    ^ codePageHolder
!

encoder:aCharacterEncoder
    encoderOrNil := aCharacterEncoder
!

selectedCodePoint
    ^ selectedCodePointHolder value
!

selectedCodePointHolder
    ^ selectedCodePointHolder
! !

!CharacterSetView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |newFont|

    something == #font ifTrue:[
        newFont := masterViewOrNil font.
        self font:newFont.
        super characterEncoding:newFont encoding.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject
! !

!CharacterSetView methodsFor:'drawing'!

redraw
    |wCol hRow dY codePage selectedCodePoint|

    codePage := self codePage.
    selectedCodePoint := self selectedCodePoint.

    wCol := width / 16.
    hRow := height / 16.

    dY := (hRow - (gc font height)) // 2 + (gc font ascent).

    0 to:15 do:[:row |
        |y0 y1 y rowBase|

        rowBase := row * 16r10.
        y := y0 := row * hRow.
        y := y rounded asInteger.
        y := y + dY.

        y1 := (row+1) * hRow.
        y1 := y1 rounded asInteger.

        0 to:15 do:[:col |
            |x0 x1 x codePoint decodedCodePoint s|

            codePoint := decodedCodePoint := (codePage * 16r100) + (rowBase + col).
            encoderOrNil notNil ifTrue:[
                [
                    decodedCodePoint := (encoderOrNil decode:codePoint) ? 0
                ] on:DecodingError do:[:ex|
                    decodedCodePoint := ex defaultValue.
                ].
            ].
            s := (Character value:decodedCodePoint) asString.

            x := x0 := (col * wCol) rounded asInteger.
            x := x rounded asInteger.
            x := x + (wCol / 2).
            x := x - ((gc font widthOf:s) // 2).

            x1 := ((col+1) * wCol) rounded asInteger.
            x1 := x1 rounded asInteger.

            codePoint == selectedCodePoint ifTrue:[
                gc paint:(Color red).
                gc fillRectangle:((x0+1)@(y0+1) corner:(x1)@(y1)).
                gc paint:(self whiteColor).
                gc displayString:s x:x y:y.
                gc paint:(self blackColor).
            ] ifFalse:[
                gc displayString:s x:x y:y.
            ].
        ].
    ].

    gc paint:(Color grey).
    0 to:16 do:[:col |
        |x|

        x := (col * wCol) rounded asInteger.
        gc displayLineFromX:x y:0 toX:x y:height-1.
    ].

    0 to:15 do:[:row |
        |y|

        y := (row * hRow) rounded asInteger.
        gc displayLineFromX:0 y:y toX:width y:y.
    ].
    gc paint:(Color black).

    "
     (self extent:300@600) open
    "

    "Modified: / 12-07-2012 / 12:30:21 / cg"
!

sizeChanged:how
    super sizeChanged:how.

    self clear.
    self invalidate.
! !

!CharacterSetView methodsFor:'event handling'!

buttonPress:button x:x y:y
    |wCol hRow row col code|

    wCol := width / 16.
    hRow := height / 16.

    row := y // hRow.
    col := x // wCol.

    code := (self codePage*16r0100) + (row * 16) + col.
    selectedCodePointHolder value:code.
!

codePageChanged
    realized ifTrue:[
        self clear.
        self redraw.
    ].
!

keyPress:key x:x y:y
    <resource: #keyboard (#NextPage #PreviousPage #CursorRight #CursorLeft
                          #CursorDown #CursorUp)>

    |cp ncp|

    key == #NextPage ifTrue:[
        codePageHolder value < 16r100 ifTrue: [
            codePageHolder value:(codePageHolder value + 1).
            selectedCodePointHolder value: nil.
        ].
        ^ self 
    ].
    key == #PreviousPage ifTrue:[  
        codePageHolder value > 0 ifTrue: [
            codePageHolder value:(codePageHolder value - 1).
            selectedCodePointHolder value: nil.
        ].
        ^ self 
    ].

    cp := selectedCodePointHolder value ? 0. 
    key == #CursorRight ifTrue:[
        ncp := (cp + 1).
    ].
    key == #CursorLeft ifTrue:[
        ncp := (cp - 1).
    ].
    key == #CursorDown ifTrue:[
        ncp := (cp + 16).
    ].
    key == #CursorUp ifTrue:[
        ncp := (cp - 16).
    ].
    ncp notNil ifTrue:[
        (ncp between:0 and:16rFFFF) ifTrue:[
            codePageHolder value:(ncp bitShift:-8).
            selectedCodePointHolder value:ncp.
        ].
        ^ self.
    ].

    key isCharacter ifTrue:[
        "/ others are forwarded to the controlled view
        selectedCodePointHolder value:key codePoint.
    ].

    super keyPress:key x:x y:y

    "Modified: / 12-07-2012 / 12:25:50 / cg"
!

selectedCodePointChanged
    realized ifTrue:[
        self clear.
        self redraw.
    ].
! !

!CharacterSetView methodsFor:'initialization & release'!

destroy
    masterViewOrNil notNil ifTrue:[
        masterViewOrNil removeDependent:self.
        masterViewOrNil := nil.
    ].
    super destroy.
!

initialize
    super initialize.
    codePageHolder := 0 asValue.
    codePageHolder onChangeSend:#codePageChanged to:self.

    selectedCodePointHolder := ValueHolder new.
    selectedCodePointHolder onChangeSend:#selectedCodePointChanged to:self.
!

useSameFontAs:aView
    masterViewOrNil := aView.
    masterViewOrNil addDependent:self
! !

!CharacterSetView methodsFor:'queries'!

preferredExtent
    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    ^ ((4 + (gc font widthOf:'W') + 4) * 16)
       @
      ((4 + (gc font heightOf:'W') + 4) * 16)
! !

!CharacterSetView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

