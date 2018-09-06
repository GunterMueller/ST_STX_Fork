"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

DisplayObjectComponentSpec subclass:#ArcMorphSpec
	instanceVariableNames:'startAngle sweepAngle startAngleChannel sweepAngleChannel
		closePath pie closePathChannel pieChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ArcMorphSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ArcMorphSpec class methodsFor:'image specs'!

iconFilled
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconFilled inspect
     ImageEditor openOnClass:self andSelector:#iconFilled
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ArcMorphSpec class iconFilled'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@ @@@@@@@@ADP@@@@@@@@DQDQD@@@@@@HDQDQD@@@@@@ADQDQDP@@@@@ADQDQDP@@@@@HDQDQD@ @@
@@@DQDQD@@@@@@@@ADP@@@@@@@@@H@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 51 153 255 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@>@@A?@@C? @G?0@G?0@G?0@G?0@C? @A?@@@>@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

iconUnfilled
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconUnfilled inspect
     ImageEditor openOnClass:self andSelector:#iconUnfilled
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ArcMorphSpec class iconUnfilled'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@ @@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@>@@A#@@B@ @F@0@D@P@D@P@F@0@B@ @A#@@@>@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!ArcMorphSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        startAngleChannel
                        sweepAngleChannel
                        closePathChannel
                        pieChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        closePath
                        pie
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    env at:#morphSpecificChannelsVisible put:true.
    env at:#pieSettingVisible put:true.
    env at:#closePathSettingVisible put:true.
    "/ env at:#backgroundSettingVisible put:true.
! !

!ArcMorphSpec class methodsFor:'interface specs'!

subSpecForMorphSpecificChannels
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ArcMorphSpec andSelector:#subSpecForMorphSpecificChannels
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMorphSpecificChannels
        window: 
       (WindowSpec
          label: 'BG- and FG-Color SubSpec'
          name: 'BG- and FG-Color SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 78)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (FramedBoxSpec
                    label: 'Arc'
                    name: 'GeometryBox'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'Start Angle'
                          layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                          minorKey: subSpecForStartAngleChannel
                        )
                       (UISubSpecification
                          name: 'Sweep Angle'
                          layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                          minorKey: subSpecForSweepAngleChannel
                        )
                       )
                     
                    )
                    extent: (Point 400 78)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!ArcMorphSpec methodsFor:'accessing'!

closePath
    ^ closePath ? false
!

closePath:aBoolean
    closePath := aBoolean.
!

closePathAspect:aSymbol
    closePathChannel := aSymbol.
!

pie
    ^ pie ? false
!

pie:aBoolean
    pie := aBoolean.
!

pieAspect:aSymbol
    pieChannel := aSymbol.
!

startAngle
    ^ startAngle ? 0
!

startAngle:degrees
    startAngle := degrees.
!

startAngleAspect:aSymbol
    startAngleChannel := aSymbol.
!

sweepAngle
    ^ sweepAngle ? 360
!

sweepAngle:degrees
    sweepAngle := degrees.
!

sweepAngleAspect:aSymbol
    sweepAngleChannel := aSymbol.
! !

!ArcMorphSpec methodsFor:'accessing-channels'!

closePathChannel
    ^ closePathChannel
!

closePathChannel:something
    closePathChannel := something.
!

pieChannel
    ^ pieChannel
!

pieChannel:something
    pieChannel := something.
!

startAngleChannel
    ^ startAngleChannel
!

startAngleChannel:something
    startAngleChannel := something.
!

sweepAngleChannel
    ^ sweepAngleChannel
!

sweepAngleChannel:something
    sweepAngleChannel := something.
! !

!ArcMorphSpec methodsFor:'building'!

basicCreateViewFor:aBuilder in:aParentView
    |component|

    component := ArcMorph new.
    aParentView addComponent:component.
    ^ component
!

setAttributesIn:aComponent with:aBuilder
    "set my attributes to aComponent"

    super setAttributesIn:aComponent with:aBuilder.

    aComponent startAngle:startAngle.
    aComponent sweepAngle:sweepAngle.
    aComponent closePath:closePath.
    aComponent pie:pie.
!

setChannelsIn:aComponent with:aBuilder
    "set channels in aComponent"

    super setChannelsIn:aComponent with:aBuilder.

    startAngleChannel notNil ifTrue:[
        aComponent startAngleHolder:(self channel:#startAngleChannel inBuilder:aBuilder)
    ].
    sweepAngleChannel notNil ifTrue:[
        aComponent sweepAngleHolder:(self channel:#sweepAngleChannel inBuilder:aBuilder)
    ].
    closePathChannel notNil ifTrue:[
        aComponent closePathHolder:(self channel:#closePathChannel inBuilder:aBuilder)
    ].
    pieChannel notNil ifTrue:[
        aComponent pieHolder:(self channel:#pieChannel inBuilder:aBuilder)
    ].
! !

!ArcMorphSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    startAngle isNil ifTrue:[l add:#startAngle].
    sweepAngle isNil ifTrue:[l add:#sweepAngle].
    closePath isNil ifTrue:[l add:#closePath].
    pie isNil ifTrue:[l add:#pie].

    startAngleChannel isNil ifTrue:[l add:#startAngleChannel].
    sweepAngleChannel isNil ifTrue:[l add:#sweepAngleChannel].
    pieChannel isNil ifTrue:[l add:#pieAspect].
    closePathChannel isNil ifTrue:[l add:#closePathChannel].

    ^l

    "Modified: / 20.6.1998 / 13:41:10 / cg"
! !

!ArcMorphSpec methodsFor:'parsing a view'!

fromView:aComponent callBack:aBlock
    "extract attributes from aComponent"

    super fromView:aComponent callBack:aBlock.

    startAngle := aComponent startAngle.
    sweepAngle := aComponent sweepAngle.
    closePath := aComponent closePath.
    pie := aComponent pie.
! !

!ArcMorphSpec methodsFor:'queries-UIPainter'!

icon
    <resource: #programImage>

    fill == true ifTrue:[
        ^ self class iconFilled
    ].
    ^ self class iconUnfilled

    "Modified: / 30-07-2018 / 16:29:47 / Claus Gittinger"
! !

!ArcMorphSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitArcMorphSpec:self
! !

!ArcMorphSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/ArcMorphSpec.st,v 1.20 2018-07-30 15:28:35 cg Exp $'
! !

