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

DrawObject subclass:#DrawGroup
	instanceVariableNames:'groupedObjects'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!DrawGroup class methodsFor:'documentation'!

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
    this class represents grouped objects
"
! !

!DrawGroup methodsFor:'accessing'!

groupedObjects
    ^ groupedObjects
!

groupedObjects:aCollection
    groupedObjects := aCollection.
    self computeBoundingBox
! !

!DrawGroup methodsFor:'adding objects'!

add:anObject
    groupedObjects isNil ifTrue:[
	groupedObjects := OrderedCollection new.
	lineWidth := 0.
	frame := anObject frame
    ].
    groupedObjects add:anObject.
    origin isNil ifTrue:[
	origin := anObject origin.
	corner := anObject corner
    ] ifFalse:[
	origin := origin min:(anObject origin).
	corner := corner max:(anObject corner)
    ].
    frame := frame merge:(anObject frame).
    lineWidth := lineWidth max:(anObject lineWidth).
    anObject fillPattern notNil ifTrue:[fillPattern := anObject fillPattern].
    anObject linePattern notNil ifTrue:[linePattern := anObject linePattern]
! !

!DrawGroup methodsFor:'changing attributes'!

background:aColor
    groupedObjects do:[:theObject |
	theObject background:aColor
    ]
!

fillPattern:aFormOrNil
    groupedObjects do:[:theObject |
	theObject fillPattern:aFormOrNil
    ].
    fillPattern := aFormOrNil
!

fontFace:aString
    groupedObjects do:[:theObject |
	theObject fontFace:aString
    ]
!

fontFamily:aString
    groupedObjects do:[:theObject |
	theObject fontFamily:aString
    ]
!

fontSize:aNumber
    groupedObjects do:[:theObject |
	theObject fontSize:aNumber
    ]
!

fontStyle:aString
    groupedObjects do:[:theObject |
	theObject fontStyle:aString
    ]
!

foreground:aColor
    groupedObjects do:[:theObject |
	theObject foreground:aColor
    ]
!

linePattern:aFormOrNil
    groupedObjects do:[:theObject |
	theObject linePattern:aFormOrNil
    ].
    linePattern := aFormOrNil
!

lineWidth:aNumber
    groupedObjects do:[:theObject |
	theObject lineWidth:aNumber
    ].
    lineWidth := aNumber
! !

!DrawGroup methodsFor:'copying'!

copy
    "answer a copy - since neither a shallow copy nor a deep copy
     is good here, answer a deep copy of shallow copies"

    |aCopy newGroupedObjects|

    aCopy := super copy.
    newGroupedObjects := groupedObjects collect:[:element | element copy].
    aCopy groupedObjects:newGroupedObjects.
    ^ aCopy
! !

!DrawGroup methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    groupedObjects do:[:object |
	object drawIn:aGC offset:anOffset
    ]
!

drawOutlineIn:aGC offset:anOffset
    groupedObjects do:[:object |
	object drawOutlineIn:aGC offset:anOffset
    ]
! !

!DrawGroup methodsFor:'inside check'!

isHitBy:hitPoint withDelta:hitDelta
    "return true, if object group is hit by point"

    groupedObjects isNil ifTrue:[^ false].

    "quick boundary check"
    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    groupedObjects do:[:object |
	(object isHitBy:hitPoint withDelta:hitDelta) ifTrue:[^ true]
    ].
    ^ false
! !

!DrawGroup methodsFor:'moving and resizing'!

computeBoundingBox
    |f|
    groupedObjects do:[:anObject |
	f isNil ifTrue:[
	    f := anObject frame
	] ifFalse:[
	    f := f merge:(anObject frame)
	]
    ].
    frame := f
!

moveTo:newOrigin
    |delta|

    delta := newOrigin - origin.
    groupedObjects do:[:theObject |
	theObject moveTo:(theObject origin + delta)
    ].
    super moveTo:newOrigin
!

origin:newOrigin corner:newCorner
    |newSize oldSize scaleX scaleY p nx ny nOrigin nCorner|

    scaleX := 1.
    newSize := (newCorner x) - (newOrigin x).
    oldSize := (corner x) - (origin x).
    (oldSize ~= newSize) ifTrue:[
	scaleX := newSize / oldSize
    ].
    scaleY := 1.
    newSize := (newCorner y) - (newOrigin y).
    oldSize := (corner y) - (origin y).
    (oldSize ~= newSize) ifTrue:[
	scaleY := newSize / oldSize
    ].

    (scaleX ~~ 1) ifTrue:[
	(scaleY ~~ 1) ifTrue:[
	    groupedObjects do:[:theObject |
		p := theObject origin.
		nx := p x.
		ny := p y.

		"move to 0@0 - origin"
		nx := nx - origin x.
		ny := ny - origin y.

		"scale to new size"
		nx := (nx * scaleX) asInteger.
		ny := (ny * scaleY) asInteger.

		"move to new - origin"
		nx := nx + newOrigin x.
		ny := ny + newOrigin y.

		nOrigin := nx @ ny.

		p := theObject corner.
		nx := p x.
		ny := p y.

		"move to 0@0 - origin"
		nx := nx - origin x.
		ny := ny - origin y.

		"scale to new size"
		nx := (nx * scaleX) asInteger.
		ny := (ny * scaleY) asInteger.

		"move to new - origin"
		nx := nx + newOrigin x.
		ny := ny + newOrigin y.

		nCorner := nx @ ny.

		theObject origin:nOrigin corner:nCorner
	    ]
	]
    ].
    super origin:newOrigin corner:newCorner
! !

!DrawGroup methodsFor:'queries'!

handlesKeyboardInput
    groupedObjects do:[:theObject |
	theObject handlesKeyboardInput ifTrue:[
	    ^ true
	]
    ].
    ^ false
! !

!DrawGroup methodsFor:'storing'!

storeOn:aStream
    |first|

    first := true.
    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new '.
    groupedObjects notNil ifTrue:[
	groupedObjects do:[:object |
	    first ifTrue:[
		first := false
	    ] ifFalse:[
		aStream nextPutAll:';'.
	    ].
	    aStream nextPutAll:'add:'.
	    object storeOn:aStream
	]
    ].
    aStream nextPut:$)
! !

!DrawGroup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawGroup.st,v 1.8 1996-05-10 13:28:39 cg Exp $'
! !
