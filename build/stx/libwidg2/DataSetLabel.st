"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Object subclass:#DataSetLabel
	instanceVariableNames:'label selector argument adjust font fgColor bgColor
		preferredHeight preferredWidth description'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DataSet'
!

!DataSetLabel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    This class keeps some info about a label.

    [author:]
        Claus Atzkern
"
! !

!DataSetLabel class methodsFor:'image specs'!

sortIndicator
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortIndicator inspect
     ImageEditor openOnClass:self andSelector:#sortIndicator
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'DataSetLabel class sortIndicator'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@B@0 @a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'?''08D@@a');
                            yourself);
                yourself
        ]
!

sortIndicatorGrey
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortIndicatorGrey inspect
     ImageEditor openOnClass:self andSelector:#sortIndicatorGrey
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'DataSetLabel class sortIndicatorGrey'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:5;
                            bits:(ByteArray fromPackedString:'@A@(UJ(b');
                            yourself);
                yourself
        ]
!

sortIndicatorGreyIcon
    ^ ToolbarIconLibrary sortIndicatorGreyIcon
!

sortIndicatorIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortIndicatorIcon inspect
     ImageEditor openOnClass:self andSelector:#sortIndicatorIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'DataSetLabel class sortIndicatorIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@B@0 @a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'?''08D@@a');
                            yourself);
                yourself
        ]
!

sortReverseIndicator
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicator inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicator
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'DataSetLabel class sortReverseIndicator'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'0(@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'DC!!<? @a');
                            yourself);
                yourself
        ]
!

sortReverseIndicatorGrey
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicatorGrey inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicatorGrey
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'DataSetLabel class sortReverseIndicatorGrey'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:5;
                            bits:(ByteArray fromPackedString:'*%P(D@@b');
                            yourself);
                yourself
        ]
!

sortReverseIndicatorGreyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicatorGreyIcon inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicatorGreyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'DataSetLabel class sortReverseIndicatorGreyIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:5;
                            bits:(ByteArray fromPackedString:'*%P(D@@b');
                            yourself);
                yourself
        ]
!

sortReverseIndicatorIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicatorIcon inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicatorIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'DataSetLabel class sortReverseIndicatorIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#[1]);
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'0(@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'DC!!<? @a');
                            yourself);
                yourself
        ]
! !

!DataSetLabel methodsFor:'accessing-colors'!

backgroundColor
    "returns the background color or nil
    "
    ^ bgColor


!

backgroundColor:aColor
    "set the background color or nil
    "
    bgColor := aColor
!

foregroundColor
    "returns the foreground color or nil
    "
    ^ fgColor

!

foregroundColor:aColor
    "set the foreground color or nil
    "
    fgColor := aColor
! !

!DataSetLabel methodsFor:'accessing-dimensions'!

preferredHeight
    "returns my preferred height
    "
    ^ preferredHeight
!

preferredWidth
    "returns my preferred width
    "
    ^ preferredWidth
! !

!DataSetLabel methodsFor:'drawing'!

redrawX:xLeft w:width h:height inset:inset on:aLabelView
    "redraw the label; the background is cleared and the paint is set
    "
    |y0 x iconOffset gcFont labelWidth 
     netWidth goodLookingVerticalSpacing colNr sortIcon|

    label isNil ifTrue:[ ^ self ].

    font notNil ifTrue:[
        gcFont := aLabelView font.    "save original font"
        aLabelView font:font.
    ].

    y0 := (height - preferredHeight) // 2.
    goodLookingVerticalSpacing := ((aLabelView font descent) - 2) max:2.
    y0 := y0 + goodLookingVerticalSpacing.

    netWidth := width-inset-inset.

    iconOffset := 0.
    description isSortable ifTrue:[
        iconOffset := 12.
        colNr := aLabelView columnIndexOfDescription:description.
        colNr == aLabelView indexOfSortColumn ifTrue:[
            aLabelView reverseSort ifTrue:[
                sortIcon := ToolbarIconLibrary sortIndicatorGreyIcon
            ] ifFalse:[
                sortIcon := ToolbarIconLibrary sortReverseIndicatorGreyIcon
            ].
            sortIcon displayOn:aLabelView x:xLeft+inset y:y0.
        ].
    ].

    label do:[:eachLabelLine|
        |restWidth xOffset shownLabel mustUndoClip prevClip|

        shownLabel := eachLabelLine.

        mustUndoClip := false.
        labelWidth := shownLabel widthOn:aLabelView.
        labelWidth > netWidth ifTrue:[
            shownLabel := DataSetColumn shortenedStringFor:eachLabelLine on:aLabelView maxWidth:netWidth.
            labelWidth := shownLabel widthOn:aLabelView.
        ].

        adjust == #left ifTrue:[
            x := xLeft + iconOffset + inset.
        ] ifFalse:[
            restWidth := width - labelWidth - iconOffset.

            adjust == #right ifTrue:[
                xOffset := restWidth - inset
            ] ifFalse:[
                xOffset := restWidth // 2.    "/ center
            ].
            x := xLeft + xOffset.

           "/ cg: must clip left, if string is too large
            x < xLeft ifTrue:[
                "/ must clip ...
                prevClip := aLabelView clippingRectangleOrNil.
                mustUndoClip := true.
                aLabelView clippingBounds:(Rectangle 
                                    left:xLeft top:y0 
                                    width:width height:height).
            ].
        ].

        shownLabel displayOn:aLabelView x:x y:y0 + (shownLabel ascentOn:aLabelView).
        y0 := y0 + (shownLabel heightOn:aLabelView) + goodLookingVerticalSpacing.

        mustUndoClip == true ifTrue:[
            aLabelView clippingBounds:prevClip
        ].
    ].

    gcFont notNil ifTrue:[
        aLabelView font:gcFont     "/ restore font
    ].       
! !

!DataSetLabel methodsFor:'instance creation'!

description:aDescription builder:aBuilder on:aGC
    |device gcFont verticalSpace|

    description := aDescription.

    "/ stupid code - could simply access things via the description.
    "/ I leave it here for subclasses which depend on it (for a while).
    label           := self resolveLabelFromDescription:aDescription withBuilder:aBuilder.
    selector        := aDescription  labelActionSelector.
    argument        := (aDescription labelActionArgument) ? label.
    adjust          := (aDescription labelAlignment) ? #left.
    device          := aGC graphicsDevice.
    fgColor         := aDescription labelForegroundColor.
    bgColor         := aDescription labelBackgroundColor.

    fgColor notNil ifTrue:[ fgColor := fgColor onDevice:device ].
    bgColor notNil ifTrue:[ bgColor := bgColor onDevice:device ].

    preferredHeight := preferredWidth := 0.

    (label isEmptyOrNil) ifTrue:[
        label := nil.
        ^ self
    ].

    font := aDescription labelFont.
    font notNil ifTrue:[
        font := aBuilder resolveFont:font.
        font notNil ifTrue:[
            gcFont := aGC font.
            gcFont = font ifTrue:[
                font := nil
            ] ifFalse:[
                font := font onDevice:device.
                aGC font:font.
            ].
        ].
    ].

    label isNonByteCollection ifFalse:[
        label := Array with:label.
    ].

    verticalSpace := aGC font descent. "/ goodLookingVerticalSpacing
    label := label 
                collect:[:el|
                    |lbl|

                    lbl := self label:el on:device.
                    preferredWidth  := (lbl widthOn:aGC) max:preferredWidth.
                    preferredHeight := preferredHeight + verticalSpace + (lbl heightOn:aGC).
                    lbl
                ].
    font notNil ifTrue:[aGC font:gcFont].       "/ restore font
! !

!DataSetLabel methodsFor:'private'!

label:aLabel on:aDevice
    "returns registered label on a device"

    aLabel isNil ifTrue:[^ ''].

    (aLabel isImageOrForm or:[aLabel isLabelAndIcon]) ifTrue:[
        ^ aLabel onDevice:aDevice
    ].
    ^ aLabel
!

resolveLabelFromDescription:aDescription withBuilder:aBuilder
    "the rawLabel can be a string, icon, labelAndIcon or collection of strings.
     if labelIsImage is true, the string is actually the appModel-labelFor-access key"

    |rawLabel appl resources lbl|

    aBuilder isNil ifTrue:[
        rawLabel := aDescription rawLabel.
    ] ifFalse:[
        rawLabel := aDescription label.
        rawLabel isNil ifTrue:[^ nil ].

        aBuilder isEditing ifFalse:[
            appl := aBuilder application.
            appl notNil ifTrue:[ resources := appl resources ].
        ].

        rawLabel isString ifTrue:[
            aDescription labelIsImage ifTrue:[
                (aBuilder isEditing or:[(rawLabel := aBuilder labelFor:(rawLabel asSymbol)) isNil]) ifTrue:[
                    rawLabel := aDescription class defaultIcon
                ].
                ^ rawLabel
            ] ifFalse:[
                aDescription translateLabel == true ifTrue:[
                    lbl := (aBuilder labelAt:(rawLabel asSymbol)) value.
                    lbl isNil ifTrue:[
                        lbl := (aBuilder aspectAt:(rawLabel asSymbol)) value.
                    ].
                    (lbl isNil and:[resources notNil]) ifTrue:[
                        lbl := resources string:rawLabel default:nil.
                    ].
                    lbl notNil ifTrue:[ rawLabel := lbl ].
                ].
            ].
        ] ifFalse:[
            (rawLabel isKindOf:LabelAndIcon) ifTrue:[
                rawLabel := rawLabel copy string:(resources string:rawLabel string).
            ].

            rawLabel isSequenceable ifFalse:[^ rawLabel].
            rawLabel isEmptyOrNil ifTrue:[^ nil ].

            resources notNil ifTrue:[
                lbl := resources string:rawLabel default:nil.

                lbl notNil ifTrue:[
                    rawLabel := lbl.
                ] ifFalse:[
                    lbl := resources array:rawLabel.
                    lbl notEmptyOrNil ifTrue:[
                        lbl size == 1 ifTrue:[ rawLabel := lbl first ]
                                     ifFalse:[ rawLabel := lbl ].
                    ].
                ].
            ].
        ].
    ].

    rawLabel isString ifTrue:[
        rawLabel isEmpty ifTrue:[ ^ nil ].
        lbl := rawLabel asStringCollection.
        lbl size > 1 ifTrue:[^ lbl ].
    ].
    ^ rawLabel
! !

!DataSetLabel methodsFor:'queries'!

hasSeparator
    |l|

    label size == 1 ifTrue:[
"/        ^ (label at:1) ~= 'Alarm'
        ^ (label at:1) ~= 'Area'
    ].
    ^ true
!

isSelectable
    "returns true if the item is selectable; a valid selector
     to notify the receiver for a release button event exists
    "
    ^ selector notNil


!

isSortable
    ^ description isSortable
! !

!DataSetLabel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

