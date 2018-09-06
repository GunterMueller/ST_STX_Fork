"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

"{ NameSpace: Smalltalk }"

DrawObject subclass:#DrawText
	instanceVariableNames:'fontFamily fontFace fontStyle fontSize font text cursorLine'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawText class methodsFor:'documentation'!

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
"
!

documentation
"
    I represent text
"
! !

!DrawText class methodsFor:'instance creation'!

family:aFamily face:aFace style:aStyle size:aSize
    |newDText|

    newDText := super new.
    newDText cursorLine:1.
    newDText setFontFamily:aFamily face:aFace style:aStyle size:aSize.
    newDText text:(StringCollection new:1).
    ^ newDText

!

new
    |newDText|

    newDText := super new.
    newDText cursorLine:1.
    newDText setFontFamily:'times' face:'medium' style:'roman' size:12.
    newDText text:(StringCollection new:1).
    ^ newDText
! !

!DrawText class methodsFor:'interface to DrawView'!

hasFixedSize
    ^ true
!

needsKeyboardInput
    ^ true
!

userFriendlyName
    ^ 'text'

    "Created: 23.4.1997 / 12:02:58 / cg"
! !

!DrawText methodsFor:'accessing'!

cursorLine:aNumber
    cursorLine := aNumber
!

font:aFont
    self fontChange:[
        self setFont:aFont.
    ]

    "Modified: / 22-10-2006 / 13:22:31 / cg"
!

fontChange:aBlock
    "adjust origin, to stay on the baseline"

    |oldAscent newAscent oldOrigin|

    oldAscent := (font onDevice:Screen current) ascent.
    oldOrigin := origin.

    aBlock value.

    self getFont.
    self computeBoundingBox.

    newAscent := (font onDevice:Screen current) ascent.

    origin := origin - (0 @ (newAscent - oldAscent)).
    self computeBoundingBox

    "Created: 5.6.1996 / 13:44:40 / cg"
    "Modified: 5.6.1996 / 13:47:58 / cg"
!

fontFace
    ^ fontFace

!

fontFace:aFace
    self fontChange:[ fontFace := aFace ]

    "Modified: 5.6.1996 / 13:45:10 / cg"
!

fontFamily
    ^ fontFamily

!

fontFamily:aFamily
    self fontChange:[ fontFamily := aFamily ]

    "Modified: 5.6.1996 / 13:45:48 / cg"
!

fontFamily:aFamily face:aFace style:aStyle size:aSize
    self fontChange:[
        fontFamily := aFamily.
        fontFace := aFace.
        fontSize := aSize.
        fontStyle := aStyle.
    ]

    "Modified: 5.6.1996 / 13:47:01 / cg"
!

fontSize
    ^ fontSize

!

fontSize:aSize
    self fontChange:[ fontSize := aSize ]

    "Modified: 5.6.1996 / 13:46:04 / cg"
!

fontStyle
    ^ fontStyle

!

fontStyle:aStyle
    self fontChange:[ fontStyle := aStyle ]

    "Modified: 5.6.1996 / 13:46:16 / cg"
!

setFont:aFont
    fontFamily := aFont family.
    fontFace := aFont face.
    fontSize := aFont size.
    fontStyle := aFont style.
    font := aFont.
!

setFontFace:aString
    fontFace := aString.
    self getFont
!

setFontFamily:aString
    fontFamily := aString.
    self getFont
!

setFontFamily:familyString face:faceString style:aStyleString size:aNumber
    fontFamily := familyString.
    fontFace := faceString.
    fontSize := aNumber.
    fontStyle := aStyleString.
    self getFont
!

setFontSize:aNumber
    fontSize := aNumber.
    self getFont
!

setFontStyle:aStyleString
    fontStyle := aStyleString.
    self getFont
!

text
    ^ text
!

text:aText
    text := aText asStringCollection.
    self computeBoundingBox
! !

!DrawText methodsFor:'binary storage'!

readBinaryContentsFrom: stream manager: manager
    "must recreate font"

    super readBinaryContentsFrom: stream manager: manager.
    self getFont
! !

!DrawText methodsFor:'copying'!

copy
    "answer a copy - have to copy the string here"

    |aCopy|

    aCopy := super copy.
    aCopy text:(text deepCopy).
    ^ aCopy
! !

!DrawText methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |r org|
    org := origin + anOffset.

    foreground isNil ifTrue:[
        foreground := Color black.
        background := Color white
    ].

    fillPattern notNil ifTrue:[
        (fillPattern == 1) ifTrue:[
            "solid background"
            "linePattern is also solid, it can be done faster"
            linePattern == 1 ifTrue:[
                aGC paint:foreground on:background.
                self drawTextIn:aGC x:(org x) y:(org y) opaque:true.
                ^ self
            ].
            r := Rectangle origin:org corner:(corner + anOffset).
            aGC paint:background.
            aGC fillRectangle:r
        ] ifFalse:[
            "a real pattern"
            aGC maskOrigin:org.
            r := Rectangle origin:org corner:(corner + anOffset).
            self withFillPatternAsPaintIn:aGC 
                do:[ aGC fillRectangle:r ].
        ]
    ].

    linePattern notNil ifTrue:[
        (linePattern == 1) ifTrue:[
            "solid foreground"
            aGC paint:foreground on:background.
            self drawTextIn:aGC x:(org x) y:(org y) opaque:false
        ] ifFalse:[
            "a real pattern"
            aGC setMaskOriginX:org x y:org y.
            aGC paint:foreground on:background.
            aGC withPattern:linePattern do:[
                self drawTextIn:aGC x:(org x) y:(org y) opaque:false
            ]
        ]
    ]
!

drawOutlineIn:aGC offset:anOffset
    |org x y|

    org := origin + anOffset.
    x := org x.
    y := org y.

"/    fillPattern notNil ifTrue:[
"/         aGC displayRectangle:(Rectangle
"/                                 origin:org
"/                                 corner:(corner + anOffset))
"/    ].
    self drawTextIn:aGC x:x y:y opaque:false.
    self drawFrameIn:aGC offset:anOffset.

    "Modified: 4.6.1996 / 15:38:52 / cg"
!

drawTextIn:aGC x:x y:y opaque:opaque
    |ypos delta|

    text notNil ifTrue:[
        font := font onDevice:aGC device.
        ypos := y + font ascent.
        delta := font height.
        aGC font:font.

        text do:[:line |

            line notNil ifTrue:[
                opaque ifTrue:[
                    aGC displayOpaqueString:line x:x y:ypos
                ] ifFalse:[
                    aGC displayString:line x:x y:ypos
                ]
            ].
            ypos := ypos + delta
        ]
    ]

    "Modified: / 22-10-2006 / 14:12:06 / cg"
! !

!DrawText methodsFor:'editing'!

handlesKeyboardInput
    "return true, if this objects is interested in keyboard input"

    ^ true
!

keyInput:key
    |line|
    (key == #Return) ifTrue: [
         text grow:(text size + 1).
         cursorLine := cursorLine + 1
    ] ifFalse: [
        line := text at:cursorLine.
        (key == #BackSpace or:[key == #Delete]) ifTrue:[
            (line notNil and:[line size > 0]) ifTrue:[
                line size == 1 ifTrue:[
                    text at:cursorLine put:nil
                ] ifFalse:[
                    text at:cursorLine put:(line copyFrom:1 to:(line size - 1))
                ]
            ] ifFalse:[
                cursorLine > 1 ifTrue:[
                    cursorLine := cursorLine - 1.
                    text removeLast.
                ]
            ]
        ] ifFalse:[
            (key isMemberOf:Character) ifFalse:[^ self].
            line isNil ifTrue:[
                text at:cursorLine put:(key asString)
            ] ifFalse:[
                text at:cursorLine put:(line , (key asString))
            ]
        ]
    ].
    self computeBoundingBox
! !

!DrawText methodsFor:'frame computation'!

computeBoundingBox
    |maxLen thisLen|

    origin isNil ifTrue:[^ self].

    font isNil ifTrue:[
        corner := origin
    ] ifFalse:[
        maxLen := 0.
        text do:[:line |
            line notNil ifTrue:[
                thisLen := font widthOf:line.
                (thisLen > maxLen) ifTrue:[maxLen := thisLen]
            ]
        ].
        (maxLen == 0) ifTrue:[
            corner := origin
        ] ifFalse:[
            corner := (origin + (maxLen @ (text size * font maxHeight)))
        ]
    ].
    frame := Rectangle origin:origin corner:corner

    "Modified: 5.6.1996 / 13:48:43 / cg"
! !

!DrawText methodsFor:'handles'!

handlesDo:aBlock
    "evaluate the argument, aBlock for every handle"

    self cornerHandlesDo:aBlock

    "Created: 5.6.1996 / 13:21:25 / cg"
! !

!DrawText methodsFor:'moving'!

bottomLeft:newBottomLeft
    origin := newBottomLeft - (0 @ self frame height).
    self computeBoundingBox

    "Created: 5.6.1996 / 13:29:47 / cg"
!

corner:newCorner
    origin := newCorner - (self frame extent).
    self computeBoundingBox

    "Created: 5.6.1996 / 13:30:24 / cg"
!

origin:newOrigin
    origin := newOrigin.
    self computeBoundingBox

    "Created: 5.6.1996 / 13:25:29 / cg"
!

topRight:newTopRight
    origin := newTopRight - (self frame width @ 0).
    self computeBoundingBox

    "Created: 5.6.1996 / 13:30:53 / cg"
! !

!DrawText methodsFor:'private'!

getFont
    font := Font family:fontFamily face:fontFace style:fontStyle size:fontSize.

    font notNil ifTrue:[
        font := font onDevice:Screen current.
    ].

    "Modified: / 22-10-2006 / 13:21:40 / cg"
! !

!DrawText methodsFor:'storing'!

storeInstvarsOn:aStream
    super storeInstvarsOn:aStream.
    aStream nextPutAll:'; setFontFamily:'. fontFamily storeOn:aStream.
    aStream nextPutAll:' face:'. fontFace storeOn:aStream.
    aStream nextPutAll:' style:'. fontStyle storeOn:aStream.
    aStream nextPutAll:' size:'. fontSize storeOn:aStream.
    aStream nextPutAll:'; text:('. text storeOn:aStream.  aStream nextPutAll:')'
! !

!DrawText methodsFor:'testing'!

isTextObject
    ^ true
! !

!DrawText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawText.st,v 1.24 2016-05-13 00:23:56 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawText.st,v 1.24 2016-05-13 00:23:56 mawalch Exp $'
! !

