"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

ModelListEntry subclass:#LabelAndIcon
	instanceVariableNames:'icon gap image offset'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!LabelAndIcon class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    an icon, an optional additional image and a string, all by side (from left to right).
    Each may be nil (i.e. with a nil image, it's a Label-and-Icon proper (icon to the left of the string).

    Usable as list entries in a listView (a fileList), as
    popUpMenuItems or as Label/Button image.

    Notice:
        This is different from ST-80's LabelAndIcon class, which
        inherits from Label. Therefore, things may change in the future.

    [author:]
        Claus Gittinger

    [see also:]
        ListEntry Text String Icon
        ListView SelectionInListView
"
!

examples
"
  in a listView:
                                                                        [exBegin]
    |top slv wrapper l fileImage dirImage|

    fileImage := Image 
                   width:16 
                   height:16
                   depth:1
                   fromArray:#[2r00000000 2r00000000
                               2r00000000 2r00000000
                               2r00011111 2r11100000
                               2r00010000 2r00100000
                               2r00010000 2r00011000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00010000 2r00001000
                               2r00011111 2r11111000
                               2r00000000 2r00000000
                               2r00000000 2r00000000].
    fileImage photometric:#whiteIs0.

    dirImage := Image 
                   width:16 
                   height:16
                   depth:1
                   fromArray:#[2r00000000 2r00000000
                               2r00000000 2r00000000
                               2r00000000 2r00000000
                               2r01111111 2r11110000
                               2r01000000 2r00001000
                               2r01000000 2r00000100
                               2r01000000 2r00000010
                               2r01000000 2r00000010
                               2r01000000 2r00000010
                               2r01000000 2r00000010
                               2r01000000 2r00000010
                               2r01000000 2r00000010
                               2r01111111 2r11111110
                               2r00000000 2r00000000
                               2r00000000 2r00000000
                               2r00000000 2r00000000].
    dirImage photometric:#whiteIs0.


    l := OrderedCollection new.
    Filename currentDirectory directoryContents do:[:s |
        s asFilename isDirectory ifTrue:[
            l add:(LabelAndIcon icon:dirImage string:s)
        ] ifFalse:[
            l add:(LabelAndIcon icon:fileImage string:s)
        ]
    ].

    slv := SelectionInListView new.
    slv list:l.
    wrapper := HVScrollableView forView:slv miniScrollerH:true.

    top := StandardSystemView extent:150@200.
    top add:wrapper in:(0.0@0.0 corner:1.0@1.0).
    top open.
                                                                        [exEnd]
  in a selectionInListView:
                                                                        [exBegin]
    |top slv wrapper l fileImage dirImage|

    dirImage := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/document_images/file_dir.xpm'.
    fileImage := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/document_images/file_text.xpm'.


    l := OrderedCollection new.
    Filename currentDirectory directoryContents do:[:s |
        s asFilename isDirectory ifTrue:[
            l add:(LabelAndIcon icon:dirImage string:s)
        ] ifFalse:[
            l add:(LabelAndIcon icon:fileImage string:s)
        ]
    ].

    slv := SelectionInListView new.
    slv list:l.
    wrapper := HVScrollableView forView:slv miniScrollerH:true.

    top := StandardSystemView extent:150@200.
    top add:wrapper in:(0.0@0.0 corner:1.0@1.0).
    top open.
                                                                        [exEnd]
  in a menu:
                                                                        [exBegin]
    |top l image1 image2|

    image1 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/argentina.xpm'.
    image2 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/germany.xpm'.

    l := OrderedCollection new.
    l add:(LabelAndIcon icon:image1 string:'argentina').
    l add:(LabelAndIcon icon:image2 string:'germany').

    top := StandardSystemView new.
    top middleButtonMenu:(PopUpMenu 
                        labels:l
                        selectors:#(foo bar)).
    top label:'Try the right-button menu'.
    top extent:300@300.
    top open.
                                                                        [exEnd]
  in a button/label:
                                                                        [exBegin]
    |top l image|

    image := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/brazil.xpm'.
    l := (LabelAndIcon icon:image string:'brazil').

    top := Button label:l.
    top open.
                                                                        [exEnd]
  two images in a button/label:
                                                                        [exBegin]
    |top l image1 image2|

    image1 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/brazil.xpm'.
    image2 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/germany.xpm'.
    l := (LabelAndIcon form:image1 image:image2 string:'directory').

    top := Button label:l.
    top open.
                                                                        [exEnd]
"
! !

!LabelAndIcon class methodsFor:'instance creation'!

form:aForm image:anImage
    "return an instance consisting of a form and an icon (on the left)"

    ^self new form:aForm image:anImage string:''
!

form:aForm image:anImage string:aString
    "return an instance consisting of two images (both on the left) and a string"

    ^self new form:aForm image:anImage string:aString
!

icon:anIcon string:aString
    "return an instance consisting of a label-string and an icon (on the left)"

    ^ self new icon:anIcon string:aString

    "Created: 12.5.1996 / 20:00:58 / cg"
!

label:aString icon:anIcon
    "return an instance consisting of a label-string and an icon (on the left)"

    ^ self new icon:anIcon string:aString
!

new
    ^ self basicNew initialize

    "Created: 12.5.1996 / 20:00:58 / cg"
!

string:aString
    "return an instance consisting of a string only"

    ^ self new icon:nil string:aString

    "Created: / 21.6.1998 / 04:57:28 / cg"
!

string:aString image:image
    "return an instance consisting of a label-string and an image (on the right)"

    ^ self new form:nil image:image string:aString
! !

!LabelAndIcon methodsFor:'accessing'!

beCheckMark
    "/ self icon:(CheckToggle checkFormOn:Screen current)
    self icon:((CheckToggle smallCheckImageForStyle:#borderedFatcross) onDevice:Screen current)

    "Created: / 21.6.1998 / 05:01:01 / cg"
    "Modified: / 21.6.1998 / 05:03:23 / cg"
!

form:aForm image:anImage string:aString

    icon := aForm.
    image:= anImage.
    string := aString. 
!

gap
    "return the spacing between the icon and the labelString.
     The default is 4"

    ^ gap
!

gap:pixels
    "set the spacing between the icon and the labelString.
     The default is 4."

    gap := pixels.

    "Created: 12.5.1996 / 20:00:52 / cg"
!

icon
    "return my icon part"

    ^ icon
!

icon:anIcon
    "set the icon image"

    icon := anIcon.

    "Created: 12.5.1996 / 20:00:52 / cg"
!

icon:anIcon string:aString
    "set both iconImage and the labelString"

    icon := anIcon.
    string := aString

    "Created: 12.5.1996 / 20:00:52 / cg"
!

image
    "return my image"

    ^ image
!

image:anImage
    "set the image"

    image := anImage
!

offset
    "set the left offset (i.e. spacing to the left of the icon).
     The default is 0."

    ^ offset
!

offset:pixels
    "set the left offset (i.e. spacing to the left of the icon).
     The default is 0."

    offset := pixels.

    "Created: / 21.6.1998 / 03:11:03 / cg"
!

xOfString
    "returns the x position of the string"

    |x img|

    x := offset.

    (img := icon value) notNil ifTrue:[
        x := x + img width + gap
    ].
    (img := image value) notNil ifTrue:[
        x := x + img width + gap
    ].
    ^ x
! !

!LabelAndIcon methodsFor:'comparing'!

= aStringOrLabelAndIcon

    aStringOrLabelAndIcon isNil ifTrue:[^ false].

    self hasIcon == aStringOrLabelAndIcon hasIcon ifFalse:[^ false].
    aStringOrLabelAndIcon hasIcon ifTrue:[
        icon = aStringOrLabelAndIcon icon ifFalse:[^ false].
    ].
    self hasImage == aStringOrLabelAndIcon hasImage ifFalse:[^ false].
    aStringOrLabelAndIcon hasImage ifTrue:[
        image = aStringOrLabelAndIcon image ifFalse:[^ false].
    ].
    ^ super = aStringOrLabelAndIcon
!

sameStringAndEmphasisAs:someStringOrLabelAndIcon
    someStringOrLabelAndIcon class == self class ifTrue:[
        icon = someStringOrLabelAndIcon icon ifFalse:[^ false].
        image = someStringOrLabelAndIcon image ifFalse:[^ false].
        (string sameStringAndEmphasisAs:someStringOrLabelAndIcon string) ifFalse:[ ^ false].
        ^ true.        
    ].

    (string sameStringAndEmphasisAs:someStringOrLabelAndIcon) ifFalse:[ ^ false].
    (icon isNil and:[image isNil]) ifTrue:[^ true].
    ^ false
! !

!LabelAndIcon methodsFor:'displaying'!

displayOn:aGC x:x y:y opaque:opaque
    "display the receiver on a GC"

    |y1 x1 iconValue imageValue stringHeight maxHeight|

    iconValue := icon value.
    imageValue := image value.

    "/ gapY := (device pixelPerMillimeter x) rounded.
    "/ maxHeight := ((iconHeight max: imageHeight) + gapY) max: stringHeight.
    maxHeight := self heightOn:aGC.

    x1 := x + offset.

    iconValue notNil ifTrue:[
        y1 := y - aGC font ascent + ((maxHeight - iconValue height + 1) // 2).
        icon := iconValue onDevice:aGC device.
        (opaque and:[iconValue mask isNil]) ifTrue:[aGC displayOpaqueForm:iconValue x:x1 y:y1]
                                            ifFalse:[aGC displayForm:iconValue x:x1 y:y1].
        x1 := x1 + iconValue width + gap.
    ].

    imageValue notNil ifTrue:[
        y1 := y - aGC font ascent + ((maxHeight - imageValue height + 1) // 2).
        image := imageValue onDevice:aGC device.
        (opaque and:[imageValue mask isNil]) ifTrue:[aGC displayOpaqueForm:imageValue x:x1 y:y1]
                                             ifFalse:[aGC displayForm:imageValue x:x1 y:y1].
        x1 := x1 + imageValue width + gap.
    ].

    stringHeight := string size ~~ 0 ifTrue:[string heightOn:aGC] ifFalse:[0].
    stringHeight ~~ 0 ifTrue:[
        y1 := y + ((maxHeight - stringHeight + 1) // 2).
        string displayOn:aGC x:x1 y:y1 opaque:opaque
    ]

    "Modified: / 21.6.1998 / 03:52:12 / cg"
!

on:aDevice
    <resource: #obsolete>

    self obsoleteFeatureWarning:'use onDevice:'.
    ^ self onDevice:aDevice
!

onDevice:aDevice
    "return with both icon and image onDevice:aDevice"

    |form img|

    aDevice isNil ifTrue:[^ self].
    icon  notNil ifTrue:[form := icon  onDevice:aDevice].
    image notNil ifTrue:[img  := image onDevice:aDevice].
    (icon == form and:[image == img]) ifTrue:[
        "nothing changed"
        ^ self.
    ].

    ^ LabelAndIcon form:form image:img string:string
! !

!LabelAndIcon methodsFor:'initialization'!

initialize
    gap := 4.
    offset := 0.

    "Modified: / 21.6.1998 / 03:10:19 / cg"
! !

!LabelAndIcon methodsFor:'queries'!

hasIcon
    ^ icon notNil
!

hasImage
    ^ image notNil
!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    |iconHeight imageHeight stringHeight oneMillimeter|

    "/oneMillimeter := aGC device isNil ifTrue:[2] ifFalse:[aGC horizontalIntegerPixelPerMillimeter].
    oneMillimeter := 0.

    icon notNil ifTrue:[
        iconHeight := icon value height + oneMillimeter
    ] ifFalse:[
        iconHeight := 0
    ].
    image notNil ifTrue:[
        imageHeight := image value height + oneMillimeter
    ] ifFalse:[
        imageHeight := 0   
    ].
    string size ~~ 0 ifTrue:[
        stringHeight := string heightOn:aGC
    ] ifFalse:[
        stringHeight := 0   
    ].
    ^ (iconHeight max: imageHeight) max: stringHeight

    "Modified: / 02-06-2015 / 14:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    |width|

    width := offset.
    icon notNil ifTrue:[
        width := width + icon value width
    ].
    image notNil ifTrue:[
        width := width + gap + image value width
    ].
    string size ~~ 0 ifTrue:[
        width := width + gap + (string widthOn:aGC)
    ].  
    ^width

    "Modified: / 21.6.1998 / 03:11:14 / cg"
! !

!LabelAndIcon methodsFor:'testing'!

isLabelAndIcon
    ^ true
! !

!LabelAndIcon methodsFor:'text compatibility'!

withoutAnyColorEmphasis
    ^ self shallowCopy string:(string withoutAnyColorEmphasis)
!

withoutBackgroundColorEmphasis
    ^ self shallowCopy string:(string withoutBackgroundColorEmphasis)
!

withoutForegroundColorEmphasis
    ^ self shallowCopy string:(string withoutForegroundColorEmphasis)
! !

!LabelAndIcon class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

