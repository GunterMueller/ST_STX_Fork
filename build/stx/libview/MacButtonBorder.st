"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

AbstractBorder subclass:#MacButtonBorder
	instanceVariableNames:'topLeftEdge topRightEdge bottomLeftEdge bottomRightEdge'
	classVariableNames:'TopLeftEdge TopRightEdge BottomLeftEdge BottomRightEdge'
	poolDictionaries:''
	category:'Graphics-Support'
!

!MacButtonBorder class methodsFor:'documentation'!

documentation
"
    an as yet unused and unfinished attempt to provide a mac-osx like
    button border. These will look like mac buttons up to maverick.
    To be continued.
"
!

examples
"
                                                [exBegin]
     |top v b|

     top := StandardSystemView extent:100@100.
     v := View origin:10@10 corner:90@30 in:top.
     top openAndWait.

     b := MacButtonBorder new.
     v border:b.
                                                [exEnd]

                                                [exBegin]
     |top v1 v2 b|

     top := StandardSystemView extent:100@200.
     v1 := View origin:10@10 corner:90@30 in:top.
     v2 := View origin:10@100 corner:90@150 in:top.
     top openAndWait.

     b := MacButtonBorder new.
     v1 border:b.
     v2 border:b.
                                                [exEnd]
"
! !

!MacButtonBorder class methodsFor:'initialization'!

initialize
    "/ self initializeImages. -- done lazy
!

initializeImages
    TopLeftEdge := self topLeftImage.
    TopRightEdge := TopLeftEdge copy flipHorizontal.
    BottomLeftEdge := self bottomLeftImage.
    BottomRightEdge := BottomLeftEdge copy flipHorizontal.
! !

!MacButtonBorder class methodsFor:'image specs'!

bottomLeftImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bottomLeftImage inspect
     ImageEditor openOnClass:self andSelector:#bottomLeftImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacButtonBorder bottomLeftImage'
        ifAbsentPut:[(Depth8Image width:9 height:10) bits:(ByteArray fromPackedString:'EP8WH"H"H"H"F@\VH"H"H"H"G 4R@RH"H"H"H1DFGRH"H"H"I!!0JB2@"H"H"@BPTA 0%H"H"@@@!!DPTCF"H"@@@@HQLI@PPO@@@@@BLYD@ B@@@@@@@&HQ,U
') colorMapFromArray:#[0 0 0 45 45 45 56 56 56 66 66 66 70 70 70 72 72 72 76 76 76 89 89 89 92 92 92 93 93 93 103 103 103 110 110 110 111 111 111 112 112 112 121 121 121 147 147 147 150 150 150 165 165 165 169 169 169 176 176 176 181 181 181 186 186 186 192 192 192 197 197 197 198 198 198 199 199 199 200 200 200 204 204 204 206 206 206 209 209 209 212 212 212 216 216 216 222 222 222 224 224 224 226 226 226 229 229 229 231 231 231 233 233 233 235 235 235] mask:((ImageMask width:9 height:10) bits:(ByteArray fromPackedString:'8G? _>A?<G?8_71?O''<_?0??A?<b'); yourself); yourself]
!

topLeftImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImage inspect
     ImageEditor openOnClass:self andSelector:#topLeftImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacButtonBorder topLeftImage'
        ifAbsentPut:[(Depth8Image width:9 height:10) bits:(ByteArray fromPackedString:'@@@@@@@_G1@C@@@@@A<Q@P,T@@@@G0\DGQ8^@@@_BP _G!!8^@A<OA!!\^G!!8^G1,BD10^G!!8^G08LFQ8^G!!8^GPTRG!!8^G!!8^F@(VG!!8^G!!8^EP4ZG!!8^G!!8^
') colorMapFromArray:#[0 0 0 91 91 91 102 102 102 104 104 104 109 109 109 110 110 110 115 115 115 117 117 117 118 118 118 119 119 119 121 121 121 123 123 123 139 139 139 143 143 143 146 146 146 153 153 153 155 155 155 158 158 158 169 169 169 174 174 174 187 187 187 191 191 191 192 192 192 199 199 199 203 203 203 204 204 204 207 207 207 217 217 217 219 219 219 221 221 221 224 224 224 229 229 229] mask:((ImageMask width:9 height:10) bits:(ByteArray fromPackedString:'A?<O?19?OG=8_?!!?<G? _>A?8G<b'); yourself); yourself]
! !

!MacButtonBorder methodsFor:'accessing'!

backgroundColor1:aColor
!

backgroundColor2:aColor
! !

!MacButtonBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    "display the borders represented by the receiver in the specified rectangle.
     The gc is restored after the draw."

    |left right top bottom savedPaint lw th rw bh|

    left := aRectangle left.
    right := aRectangle right.
    top := aRectangle top.
    bottom := aRectangle bottom.

    savedPaint := aGC paint.

    topLeftEdge isNil ifTrue:[
        self initializeImages
    ].
    
    lw := topLeftEdge width.
    rw := topRightEdge width.
    th := topLeftEdge height.
    bh := bottomLeftEdge height.
    
    aGC paint:(aGC container viewBackground).
    aGC fillRectangleX:left y:top width:5 height:5.
    aGC fillRectangleX:right-5 y:top width:5 height:5.
    aGC fillRectangleX:right-5 y:bottom-5 width:5 height:5.
    aGC fillRectangleX:left y:bottom-5 width:5 height:5.

    topLeftEdge displayOn:aGC x:left y:top.
    aGC paint:(Color redByte:104 greenByte:104 blueByte:104).
    aGC displayLineFromX:left+lw y:top toX:right-rw y:top.
    aGC paint:(Color redByte:186 greenByte:186 blueByte:186).
    aGC displayLineFromX:left+lw y:top+1 toX:right-rw y:top+1.

    topRightEdge displayOn:aGC x:(right-rw) y:top.
    aGC paint:(Color redByte:208 greenByte:208 blueByte:208).
    aGC displayLineFromX:right-3 y:(top+th) toX:right-3 y:(bottom-bh).
    aGC paint:(Color redByte:147 greenByte:147 blueByte:147).
    aGC displayLineFromX:right-2 y:(top+th) toX:right-2 y:(bottom-bh).
    aGC paint:(Color redByte:191 greenByte:191 blueByte:191).
    aGC displayLineFromX:right-1 y:(top+th) toX:right-1 y:(bottom-bh).

    bottomLeftEdge displayOn:aGC x:left y:(bottom-bh).
    aGC paint:(Color redByte:148 greenByte:148 blueByte:148).
    aGC displayLineFromX:left+lw y:bottom-1-2 toX:right-rw y:bottom-1-2.
    aGC paint:(Color redByte:56 greenByte:56 blueByte:56).
    aGC displayLineFromX:left+lw y:bottom-1-1 toX:right-rw y:bottom-1-1.
    aGC paint:(Color redByte:186 greenByte:186 blueByte:186).
    aGC displayLineFromX:left+lw y:bottom-1 toX:right-rw y:bottom-1.

    bottomRightEdge displayOn:aGC x:(right-rw) y:(bottom-bh).
    aGC paint:(Color redByte:186 greenByte:186 blueByte:186).
    aGC displayLineFromX:left y:(top+th) toX:left y:(bottom-bh).
    aGC paint:(Color redByte:121 greenByte:121 blueByte:121).
    aGC displayLineFromX:left+1 y:(top+th) toX:left+1 y:(bottom-bh).

    aGC paint:savedPaint.
!

initializeImages
    TopLeftEdge isNil ifTrue:[
        self class initializeImages
    ].
    
    topLeftEdge := TopLeftEdge copy.
    topRightEdge := TopRightEdge copy.
    bottomLeftEdge := BottomLeftEdge copy.
    bottomRightEdge := BottomRightEdge copy.
! !

!MacButtonBorder methodsFor:'queries'!

margin
    ^ 4
! !

!MacButtonBorder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MacButtonBorder initialize!
