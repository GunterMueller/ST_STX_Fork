"
 COPYRIGHT (c) 2015 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

SimpleBorder subclass:#RoundedBorder
	instanceVariableNames:'imgTopLeft imgTopRight imgBottomRight imgBottomLeft'
	classVariableNames:'TemplateTopLeft TemplateTopRight TemplateBottomRight
		TemplateBottomLeft'
	poolDictionaries:''
	category:'Graphics-Support'
!

!RoundedBorder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by eXept Software AG
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
    a rounded border as in modern yosemite and new adwaita

    [see also:]
        Border

    [author:]
        Claus Gittinger
"
!

examples
"
                                                        [exBegin]
     |v b|

     v := StandardSystemView extent:200@100.
     v openAndWait.
         
     b := RoundedBorder width:5 color:Color red.
     b displayOn:v forDisplayBox:(0@0 extent:100@100).
                                                        [exEnd]

                                                        [exBegin]
     |t v b|

     t := StandardSystemView extent:200@100.
     t viewBackground:Color green.
     v := View in:t.
     v viewBackground:Color red.
     v origin:10@10 corner:90@90.
     t openAndWait.

     b := RoundedBorder width:10 color:Color red.
     v border:b
                                                        [exEnd]
"
! !

!RoundedBorder class methodsFor:'image specs'!

templateBottomLeftImage
    TemplateBottomLeft isNil ifTrue:[
        TemplateBottomLeft := self templateBottomRightImage rotated:90
    ].    
    ^ TemplateBottomLeft

    "
     self templateBottomLeftImage
    "
!

templateBottomRightImage
    TemplateBottomRight isNil ifTrue:[
        TemplateBottomRight := self templateTopRightImage rotated:90
    ].    
    ^ TemplateBottomRight

    "
     self templateBottomRightImage
    "
!

templateTopLeftImage    
    TemplateTopLeft isNil ifTrue:[
        TemplateTopLeft := self topLeftImageUnfilledMasked4
    ].    
    ^ TemplateTopLeft

    "
     TemplateTopLeft := TemplateTopRight := nil.
     TemplateBottomLeft := TemplateBottomRight := nil.
    "
!

templateTopRightImage
    TemplateTopRight isNil ifTrue:[
        TemplateTopRight := self templateTopLeftImage rotated:90
    ].    
    ^ TemplateTopRight

    "
     self templateTopRightImage
    "
!

topLeftImageUnfilledMasked
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RoundedBorder topLeftImageUnfilledMasked'
        ifAbsentPut:[(Depth1Image width:4 height:4) bits:(ByteArray fromPackedString:'@@@@@@@a') colorMapFromArray:#[0 0 0] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'8LB@@@@a'); yourself); yourself]
!

topLeftImageUnfilledMasked2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked2 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RoundedBorder topLeftImageUnfilledMasked2'
        ifAbsentPut:[(Depth1Image width:4 height:4) bits:(ByteArray fromPackedString:'@@@@@@@a') colorMapFromArray:#[0 0 0] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'<LB@ @@a'); yourself); yourself]
!

topLeftImageUnfilledMasked3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked3 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RoundedBorder topLeftImageUnfilledMasked3'
        ifAbsentPut:[(Depth1Image width:4 height:4) bits:(ByteArray fromPackedString:'DFA@ @@a') colorMapFromArray:#[0 0 0 127 127 127] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'<NC@ @@a'); yourself); yourself]
!

topLeftImageUnfilledMasked4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked4 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RoundedBorder topLeftImageUnfilledMasked4'
        ifAbsentPut:[(Depth1Image width:4 height:4) bits:(ByteArray fromPackedString:'LDB@ @@a') colorMapFromArray:#[0 0 0 127 127 127] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'<LB@ @@a'); yourself); yourself]
! !

!RoundedBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    |imgDim boxLeft boxRight boxTop boxBottom boxWidth boxHeight|

    color isNil ifTrue:[ ^ self].

    super displayOn:aGC forDisplayBox:aRectangle.

    imgTopLeft isNil ifTrue:[
        self makeImages.
        imgTopLeft isNil ifTrue:[
            ^ self
        ].    
    ].    

    imgDim :=4.

    boxLeft := aRectangle left + width.
    boxTop := aRectangle top + width.
    boxWidth := aRectangle width.
    boxHeight := aRectangle height.

    boxRight := boxLeft + boxWidth - width - 1.
    boxBottom := boxTop + boxHeight - width - 1.
    
    aGC displayImage:imgTopLeft x:boxLeft y:boxTop.
    aGC displayImage:imgTopRight x:boxRight-imgDim-imgDim y:boxTop.
    aGC displayImage:imgBottomRight x:boxRight-imgDim-imgDim y:boxBottom-imgDim-imgDim.
    aGC displayImage:imgBottomLeft x:boxLeft y:boxBottom-imgDim-imgDim.
! !

!RoundedBorder methodsFor:'private'!

makeImages
    |lightColor|
    
    imgTopLeft := self class templateTopLeftImage copy.
    imgTopRight := self class templateTopRightImage copy.
    imgBottomLeft := self class templateBottomLeftImage copy.
    imgBottomRight := self class templateBottomRightImage copy.

    lightColor := color lightened.
    
    imgTopLeft colorMap 
        at:1 put:color; at:2 put:lightColor.
    imgTopRight colorMap 
        at:1 put:color; at:2 put:lightColor.
    imgBottomLeft colorMap 
        at:1 put:color; at:2 put:lightColor.
    imgBottomRight colorMap 
        at:1 put:color; at:2 put:lightColor.
! !

!RoundedBorder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

