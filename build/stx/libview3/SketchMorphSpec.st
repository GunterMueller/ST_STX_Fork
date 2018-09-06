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

DisplayObjectComponentSpec subclass:#SketchMorphSpec
	instanceVariableNames:'imageChannel image'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SketchMorphSpec class methodsFor:'documentation'!

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

!SketchMorphSpec class methodsFor:'image specs'!

icon
    <resource: #programImage>

    ^ self icon3

    "Modified: / 28-07-2018 / 09:53:13 / Claus Gittinger"
!

icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self icon1 inspect
     ImageEditor openOnClass:self andSelector:#icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SketchMorphSpec class icon1'
        ifAbsentPut:[(Depth24Image new) width: 16; height: 16; photometric:(#rgb); bitsPerSample:(#[8 8 8]); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@@H$@@L8@@L8@+-+&+-+&+-+&
+-+&+-+&+-+&@L8@@L8@@L8@@L8@@H$@@L8@@L8@@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@
+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@@L8@@H$@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@H$@@L8@@L8@@L8@
@L8@@L8@+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@H$@@L8@@L8@@L8@@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@@L8@
@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&@L8@@L8@@L8@@L8@
@L8@@L8@@L8@@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&@L8@!!S0$!!S0$!!S0$!!S0$@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&@L8@
@L8@!!S0$!!S0$@L8@@L8@+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&!!S0$!!S0$+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&
+-+&+-+&+-+&!!S0$!!S0$+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&+-+&@H$@!!S0$!!S0$@H$@+-+&@H$@+-+&+-+&+-+&+-+&+-+&+-+&
+-+&+-+&@H$@@H$@@H$@@H$@@H$@@H$@@H$@@H$@@H$@@H$@+-+&+-+&+-+&+-+&') ; yourself]
!

icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon2 inspect
     ImageEditor openOnClass:self andSelector:#icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SketchMorphSpec class icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@DQ@@@@@@@@DSDQD@@@@@D1DQDQ@@@@@QDQD1D@@@@ADQLQDP@@@@DSDQDQ@@@@@QDQDSD@@@@ALQD1DP@@@@DQDQDP@@@@@A@@@P@@@@@@
@P@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@0L@@@@@L3L3L3L@@b');
                colorMapFromArray:#[ 133 60 36 0 206 0 174 218 230 0 137 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@G@@? G?@_<A?0G?@_<A?0G>@O0@^@@0@C@@^ G? b');
                            yourself);
                yourself
        ]
!

icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon3 inspect
     ImageEditor openOnClass:self andSelector:#icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SketchMorphSpec class icon3'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QDQDQDQDQDQBH"H"H"H"IDH"H!!TQH"H$P"H%DQDRH"QBH"DQDUD"IDH"DQEQDRH$P"HQDQDUH"QBH!!TQEQD"IDH"DQDQDRH$P"H!!D@DRH"QBH"HP@RH"IDH"
H"@BH"H$P"H"H@H"H"QBH#L0@2L"IDH3L3L3L3L$QDQDQDQDQDPb');
                colorMapFromArray:#[ 133 60 36 0 206 0 174 218 230 0 137 0 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??????????????????????????????????????????<b');
                            yourself);
                yourself
        ]
! !

!SketchMorphSpec class methodsFor:'interface specs'!

additionalBasicAttributesSubSpec
    ^ self imageSubSpec
!

basicsEditSpec
    ^ self basicsEditSpecWithoutModelAndViewClass
!

imageSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SketchMorphSpec andSelector:#imageSubSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: imageSubSpec
       window: 
      (WindowSpec
         label: 'BG- and FG-Color SubSpec'
         name: 'BG- and FG-Color SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 300)
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
                   label: 'Image'
                   name: 'ImageBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Image:'
                         name: 'imageLabel'
                         layout: (LayoutFrame 0 0 2 0 100 0 24 0)
                         activeHelpKey: image
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'imageField'
                         layout: (LayoutFrame 100 0 2 0 5 1 24 0)
                         activeHelpKey: image
                         tabable: true
                         model: image
                         group: inputGroup
                         acceptChannel: acceptChannel
                         modifiedChannel: modifiedChannel
                         acceptOnPointerLeave: false
                       )
                      )
                    
                   )
                   extent: (Point 400 64)
                 )
                (FramedBoxSpec
                   label: 'Background'
                   name: 'BackgroundBox'
                   visibilityChannel: backgroundSettingVisible
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'BG-Color:'
                         name: 'Label9'
                         layout: (AlignmentOrigin 100 0 18 0 1 0.5)
                         activeHelpKey: backgroundColor
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                       )
                      (ColorMenuSpec
                         name: 'ColorMenu1'
                         layout: (LayoutFrame 100 0 6 0 5 1.0 28 0)
                         activeHelpKey: backgroundColor
                         model: backgroundColor
                         allowSymbolicColors: true
                       )
                      )
                    
                   )
                   extent: (Point 400 66)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForMorphSpecificChannels
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SketchMorphSpec andSelector:#subSpecForMorphSpecificChannels
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMorphSpecificChannels
        window: 
       (WindowSpec
          label: 'Image Channel SubSpec'
          name: 'Image Channel SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 58)
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
                    label: 'Image'
                    name: 'GeometryBox'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'Image'
                          layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                          minorKey: subSpecForImageChannel
                        )
                       )
                     
                    )
                    extent: (Point 400 57)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!SketchMorphSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        imageChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        image
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    "/ env at:#morphSpecificChannelsVisible put:false.
    env at:#fillChannelsVisible put:false.
    env at:#lineChannelsVisible put:false.
! !

!SketchMorphSpec methodsFor:'accessing'!

image
    ^ image
!

image:something
    image := something.
! !

!SketchMorphSpec methodsFor:'accessing-channels'!

imageChannel
    ^ imageChannel
!

imageChannel:aspectSymbol
    imageChannel := aspectSymbol.
! !

!SketchMorphSpec methodsFor:'accessing-color & font'!

backgroundColor
    ^ nil
! !

!SketchMorphSpec methodsFor:'building'!

basicCreateViewFor:aBuilder in:aParentView
    |component|

    component := SketchMorph new.
    aParentView addComponent:component.
    ^ component
!

setAttributesIn:aComponent with:aBuilder
    super setAttributesIn:aComponent with:aBuilder.

    image notNil ifTrue:[aComponent image:(aBuilder visualFor:image)].
!

setChannelsIn:aComponent with:aBuilder
    "set channels in aComponent"

    super setChannelsIn:aComponent with:aBuilder.

    imageChannel notNil ifTrue:[
        aComponent imageHolder:(self channel:#imageChannel inBuilder:aBuilder)
    ].
! !

!SketchMorphSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    image isNil ifTrue:[l add:#image].
    imageChannel isNil ifTrue:[l add:#imageChannel].
    ^l
! !

!SketchMorphSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    super fromView:aView callBack:aBlock.
! !

!SketchMorphSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/SketchMorphSpec.st,v 1.9 2018-07-28 08:07:29 cg Exp $'
! !

