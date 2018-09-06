"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

FileSelectionBox subclass:#ImageSelectionBox
	instanceVariableNames:'previewField preview info'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!ImageSelectionBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Like a fileSelectionBox, but adds a little preview field.
    Nice.
"
! !

!ImageSelectionBox methodsFor:'initialization'!

initialize
    |v check lw lh prefY frame previewSize|

    previewSize := 64@64.

    super initialize.

    label := (resources string:'Image dialog').
    labelField label:(resources string:'select an image file:').

    prefY := buttonPanel preferredExtent y.

    check := CheckBox label:(resources string:'preview') in:self.
    check model:(preview := false asValue).
    preview onChangeSend:#showPreview to:self.
    info := Label label:'' in:self.
    info adjust:#left.

    lh := check preferredExtent y.
    lw := check preferredExtent x.

    check
	origin:(0.0 @ 1.0)
	corner:(0.0 @ 1.0).
    check
	topInset:(prefY + ViewSpacing + previewSize y) negated;
	bottomInset:(prefY + ViewSpacing + (previewSize y - check preferredExtent y));
	rightInset:(ViewSpacing + lw) negated.

    info
	origin:(0.0 @ 1.0)
	corner:(1.0 @ 1.0).
    info
	topInset:(prefY + ViewSpacing + info preferredExtent y + ViewSpacing) negated;
	bottomInset:(prefY + ViewSpacing);
	leftInset:ViewSpacing;
	rightInset:(ViewSpacing + previewSize x + ViewSpacing) negated.

    StyleSheet is3D ifTrue:[
	v := View in:self.
	previewField := Label origin:0.0@0.0 corner:1.0@1.0 in:v.
	previewField allInset:ViewSpacing//2.
	frame := v.
	previewField level:-1.
	frame level:1.
    ] ifFalse:[
	previewField := frame := Label in:self.
    ].
    frame
	origin:(1.0 @ 1.0)
	corner:(1.0 @ 1.0).
    frame
	topInset:(prefY + ViewSpacing + previewSize y + (frame borderWidth * 2)) negated;
	bottomInset:(prefY + frame borderWidth + ViewSpacing);
	leftInset:(ViewSpacing + previewSize x + ViewSpacing) negated;
	rightInset:ViewSpacing.
    previewField sizeFixed:true.

    selectionList superView
	bottomInset:(prefY + ViewSpacing + previewSize y + (frame borderWidth * 2) + ViewSpacing).
! !

!ImageSelectionBox methodsFor:'user actions'!

selectionChanged
    "selections in list show the image"

    super selectionChanged.
    self showPreview
!

showPreview
    "show the image as thumbNail"

    |fileNameString fileName image|

    previewField label:nil.
    info label:nil.

    preview value ifFalse:[
	^ self
    ].

    "
     show the image in the previewLabel
    "
    fileNameString := self contents.
    (fileNameString notNil and:[fileNameString notEmpty]) ifTrue:[
	fileName := fileNameString asFilename.
	(fileName exists
	and:[fileName isDirectory not
	and:[fileName isReadable]]) ifTrue:[

	    self topView withWaitCursorDo:[
		image := Image fromFile:fileNameString.
		image notNil ifTrue:[
		    info label:(resources string:'%1 x %2'
					  with:image width printString
					  with:image height printString),
			       (resources string:' Depth:%1'
					    with:image depth printString),
			       (resources string:' (%1)'
					    with:image photometric printString).

		    (image width <= 64 and:[image height <= 64]) ifFalse:[
			image := image magnifiedPreservingRatioTo:64@64.
		    ].
		    "
		     for the thumbNail picture,
		     we can temporarily switch to a rough dither.
		     (this speeds up the thing quite a bit
		    "
		    (image depth > 2
		    and:[device fixColors isNil]) ifTrue:[
			"temporarily go to a 3x3x2 colormap ..."
			Object errorSignal handle:[:ex |
			    'very low resolution colors' infoPrintNL.
			    Object errorSignal handle:[:ex |
				'cannot allocate dither colors' infoPrintNL.
				ex return
			    ] do:[
				Color getColorsRed:2 green:2 blue:2 on:device.
			    ]
			] do:[
			    Color getColorsRed:5 green:5 blue:3 on:device.
			].
			previewField label:image.
			device releaseFixColors.
		    ] ifFalse:[
			previewField label:image.
		    ]
		]
	    ]
	]
    ]

    "Modified: 7.6.1996 / 12:25:19 / cg"
! !

!ImageSelectionBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ImageSelectionBox.st,v 1.6 2006-11-13 16:11:30 cg Exp $'
! !

