"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

DisplayObjectComponentSpec subclass:#LineSegmentMorphSpec
	instanceVariableNames:'startPoint endPoint showArrow arrowStyle arrowPosition
		startPointChannel endPointChannel showArrowChannel
		arrowStyleChannel arrowPositionChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!


!LineSegmentMorphSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'LineSegmentMorphSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@B@@@C@@@C @G?0@@C @@C@@@B@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconArrow
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconArrow inspect
     ImageEditor openOnClass:self andSelector:#iconArrow
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'LineSegmentMorphSpec class iconArrow'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@B@@@C@@@C @G?0@@C @@C@@@B@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconLine
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconLine inspect
     ImageEditor openOnClass:self andSelector:#iconLine
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'LineSegmentMorphSpec class iconLine'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!LineSegmentMorphSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    super addBindingsTo:env for:anInstance channel:aChannel.

    env at:#pieSettingVisible put:false.
    env at:#closePathSettingVisible put:false.
    env at:#backgroundSettingVisible put:false.
    env at:#fillSettingVisible put:false.
! !

!LineSegmentMorphSpec methodsFor:'accessing'!

arrowPosition
    ^ arrowPosition
!

arrowPosition:something
    arrowPosition := something.
!

arrowStyle
    ^ arrowStyle
!

arrowStyle:something
    arrowStyle := something.
!

endPoint
    ^ endPoint
!

endPoint:something
    endPoint := something.
!

showArrow
    ^ showArrow
!

showArrow:something
    showArrow := something.
!

startPoint
    ^ startPoint
!

startPoint:something
    startPoint := something.
! !

!LineSegmentMorphSpec methodsFor:'accessing-channels'!

arrowPositionChannel
    ^ arrowPositionChannel
!

arrowPositionChannel:something
    arrowPositionChannel := something.
!

arrowStyleChannel
    ^ arrowStyleChannel
!

arrowStyleChannel:something
    arrowStyleChannel := something.
!

endPointChannel
    ^ endPointChannel
!

endPointChannel:something
    endPointChannel := something.
!

showArrowChannel
    ^ showArrowChannel
!

showArrowChannel:something
    showArrowChannel := something.
!

startPointChannel
    ^ startPointChannel
!

startPointChannel:something
    startPointChannel := something.
! !

!LineSegmentMorphSpec methodsFor:'blocked'!

geometryLayout
    ^ nil
!

geometryLayout:aLayout
    "/ ignored.
!

layout
    ^ nil
!

layout:aLayout
    "/ ignored.
! !

!LineSegmentMorphSpec methodsFor:'building'!

basicCreateViewFor:aBuilder in:aParentView
    |component|

    component := LineSegmentMorph new.
    aParentView addComponent:component.
    ^ component
!

setAttributesIn:aComponent with:aBuilder
    "set my attributes to aComponent"

    super setAttributesIn:aComponent with:aBuilder.

    aComponent startPoint:startPoint.
    aComponent endPoint:endPoint.
    aComponent showArrow:showArrow.
    aComponent arrowStyle:arrowStyle.
    aComponent arrowPosition:arrowPosition.
!

setChannelsIn:aComponent with:aBuilder
    "set channels in aComponent"

    super setChannelsIn:aComponent with:aBuilder.

    startPointChannel notNil ifTrue:[
        aComponent startPointHolder:(self channel:#startPointAspect inBuilder:aBuilder)
    ].
    endPointChannel notNil ifTrue:[
        aComponent endPointHolder:(self channel:#endPointAspect inBuilder:aBuilder)
    ].
    showArrowChannel notNil ifTrue:[
        aComponent showArrowHolder:(self channel:#showArrowAspect inBuilder:aBuilder)
    ].
    arrowStyleChannel notNil ifTrue:[
        aComponent arrowStyleHolder:(self channel:#arrowStyleAspect inBuilder:aBuilder)
    ].
    arrowPositionChannel notNil ifTrue:[
        aComponent arrowPositionHolder:(self channel:#arrowPositionAspect inBuilder:aBuilder)
    ].
! !

!LineSegmentMorphSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    startPoint notNil ifTrue:[startPoint := startPoint decodeAsLiteralArray].
    endPoint notNil ifTrue:[endPoint := endPoint decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    startPoint isNil ifTrue:[l add:#startPoint].
    endPoint isNil ifTrue:[l add:#endPoint].
    showArrow isNil ifTrue:[l add:#showArrow].
    arrowStyle isNil ifTrue:[l add:#arrowStyle].
    arrowPosition isNil ifTrue:[l add:#arrowPosition].

    startPointChannel isNil ifTrue:[l add:#startPointAspect].
    endPointChannel isNil ifTrue:[l add:#endPointAspect].

    ^l
! !

!LineSegmentMorphSpec methodsFor:'parsing a view'!

fromView:aComponent callBack:aBlock
    "extract attributes from aComponent"

    super fromView:aComponent callBack:aBlock.

    startPoint := aComponent startPoint.
    endPoint := aComponent endPoint.
    arrowStyle := aComponent arrowStyle.
    arrowPosition := aComponent arrowPosition.
    showArrow := aComponent showArrow.
!

layoutFromView:aView
    startPoint := aView startPoint.
    endPoint := aView endPoint.
! !

!LineSegmentMorphSpec methodsFor:'queries-UIPainter'!

hasLayout
    "return true, if my view/component optionally has a layout. 
     All Views and Components except for the lineSegment, spline and polygons, do
     support layouts. The other are defined by a set of controlling points."

    ^ false
!

icon
    showArrow == true ifTrue:[
        ^ self class iconArrow
    ].
    ^ self class iconLine
! !

!LineSegmentMorphSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitLineSegmentMorphSpec:self
! !

!LineSegmentMorphSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/LineSegmentMorphSpec.st,v 1.11 2017-11-28 18:21:35 cg Exp $'
! !

