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

MenuComponentSpec subclass:#DisplayObjectComponentSpec
	instanceVariableNames:'foregroundColor backgroundColor line lineWidth lineStyle fill
		lineColor foregroundColorChannel backgroundColorChannel
		lineChannel lineWidthChannel lineStyleChannel fillChannel
		lineColorChannel originChannel extentChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!DisplayObjectComponentSpec class methodsFor:'documentation'!

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

!DisplayObjectComponentSpec class methodsFor:'image specs'!

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
    
    ^ Icon constantNamed:'DisplayObjectComponentSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@ @B@@@@@@@@@DQ@@@@@@@@@QDQDP@@@@@@ QDQDP@@@@@@DQDQDQ@UUT@@DQDQDQ@UUT@@ QDQDPBUUT@@@QDQDPEUUT@@@@DQ@AUUUT@
@@@ @BUUUUT@@@@@@EUUUUT@@@@@@EUUUUT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 51 153 255 107 239 99 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@C8@@G<@@O>@@_?>@_?>@_?>@_?>@O?>@G?>@C?>@@_>@@_>@@_>@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!DisplayObjectComponentSpec class methodsFor:'interface specs'!

basicsEditSpec
    ^ self basicsEditSpecWithoutModelAndViewClass
!

colorsSubSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#colorsSubSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: colorsSubSpec
        window: 
       (WindowSpec
          label: 'BG- and FG-Color SubSpec'
          name: 'BG- and FG-Color SubSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 323)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 0 1 -27 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
              visibilityChannel: lineSettingVisible
                    name: 'LineBox'
                    minorKey: subSpecForLineAttributesBox
                    extent: (Point 400 117)
                  )
                 (UISubSpecification
              visibilityChannel: fillSettingVisible
                    name: 'FillBox'
                    minorKey: subSpecForFillAttributesBox
                    extent: (Point 400 84)
                  )
                 (UISubSpecification
                    visibilityChannel: backgroundSettingVisible
                    name: 'BackgroundBox'
                    minorKey: subSpecForBackgroundAttributesBox
                    extent: (Point 400 64)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

morphChannelEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#morphChannelEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: morphChannelEditSpec
        window: 
       (WindowSpec
          label: 'Morph Channels'
          name: 'Morph Channels'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 382 458)
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
              elementsChangeSize: true
              component: 
             (SpecCollection
                collection: (
                 (FramedBoxSpec
                    label: 'Geometry'
                    name: 'GeometryBox'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'OriginSpecification'
                          layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                          minorKey: subSpecForOriginChannel
                        )
                       (UISubSpecification
                          name: 'ExtentSpecification'
                          layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                          minorKey: subSpecForExtentChannel
                        )
                       )
                     
                    )
                    extent: (Point 382 81)
                  )
                 (UISubSpecification
                    name: 'MorphSpecificSpecification'
                    visibilityChannel: morphSpecificChannelsVisible
                    minorKey: subSpecForMorphSpecificChannels
                    extent: (Point 382 80)
                  )
                 (UISubSpecification
                    visibilityChannel: lineChannelsVisible
                    name: 'LineChannelBox'
                    minorKey: subSpecForMorphLineChannelBox
                    extent: (Point 382 152)
                  )
                 (UISubSpecification
                    visibilityChannel: fillChannelsVisible
                    name: 'FillChannelBox'
                    minorKey: subSpecForMorphFillChannelBox
                    extent: (Point 382 106)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

subSpecForBackgroundAttributesBox
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForBackgroundAttributesBox
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForBackgroundAttributesBox
       window: 
      (WindowSpec
         label: 'Background Attributes SubSpec'
         name: 'Background Attributes SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 64)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Background'
             name: 'BackgroundBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 65 0)
             visibilityChannel: backgroundSettingVisible
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'Label9'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenu1'
                   layout: (LayoutFrame 100 0 5 0 5 1.0 27 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForClosePathChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForClosePathChannel
        window: 
       (WindowSpec
          label: 'Any Component ClosePathChannel'
          name: 'Any Component ClosePathChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'ClosePath Channel:'
              name: 'closePathChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: closePathChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'closePathChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: closePathChannel
                    tabable: true
                    model: closePathChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: closePathChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForExtentChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForExtentChannel
        window: 
       (WindowSpec
          label: 'Any Component ExtentChannel'
          name: 'Any Component ExtentChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Extent Channel:'
              name: 'extentChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: extentChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'extentChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: extentChannel
                    tabable: true
                    model: extentChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: extentChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForFillAttributesBox
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForFillAttributesBox
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForFillAttributesBox
       window: 
      (WindowSpec
         label: 'Fill Attributes SubSpec'
         name: 'Fill Attributes SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 84)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Fill'
             name: 'FillBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 84 0)
             visibilityChannel: fillSettingVisible
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Fill'
                   name: 'CheckBox2'
                   layout: (LayoutFrame 87 0 -4 0 217 0 18 0)
                   model: fill
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Pie'
                   name: 'CheckBox3'
                   layout: (LayoutFrame 239 0 -4 0 369 0 18 0)
                   visibilityChannel: pieSettingVisible
                   model: pie
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Fill-Color:'
                   name: 'foregroundLabel'
                   layout: (AlignmentOrigin 100 0 36 0 1 0.5)
                   activeHelpKey: foregroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuFG'
                   layout: (LayoutFrame 100 0 24 0 5 1.0 46 0)
                   activeHelpKey: foregroundColor
                   model: foregroundColor
                   allowSymbolicColors: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForFillChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForFillChannel
        window: 
       (WindowSpec
          label: 'Any Component FillChannel'
          name: 'Any Component FillChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Fill Channel:'
              name: 'fillChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: fillChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'fillChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: fillChannel
                    tabable: true
                    model: fillChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: fillChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForFillColorChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForFillColorChannel
        window: 
       (WindowSpec
          label: 'Any Component FillColorChannel'
          name: 'Any Component FillColorChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Fill-Color Channel:'
              name: 'fgColorChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: foregroundColorChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'fgColorChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: foregroundCColorhannel
                    tabable: true
                    model: foregroundColorChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: foregroundColorChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForImageChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForImageChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForImageChannel
        window: 
       (WindowSpec
          label: 'Any Component StartAngleChannel'
          name: 'Any Component StartAngleChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Image:'
              name: 'imageChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: startAngleChannel
              translateLabel: true
              resizeForLabel: true
            )
           (ComboBoxSpec
              name: 'imageChannelField'
              layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
              activeHelpKey: startAngleChannel
              tabable: true
              model: imageChannel
              acceptChannel: acceptChannel
              modifiedChannel: modifiedChannel
              comboList: listOfAspects
            )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: imageChannel
            )
           )
         
        )
      )
!

subSpecForLineAttributesBox
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForLineAttributesBox
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: subSpecForLineAttributesBox
       window: 
      (WindowSpec
         label: 'Line Attributes SubSpec'
         name: 'Line Attributes SubSpec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 117)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Line'
             name: 'LineBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 117 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Line'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 87 0 -4 0 217 0 18 0)
                   model: line
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Close Path'
                   name: 'CheckBox4'
                   layout: (LayoutFrame 239 0 -4 0 369 0 18 0)
                   visibilityChannel: closePathSettingVisible
                   model: closePath
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'Line-Color:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 36 0 1 0.5)
                   activeHelpKey: lineColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'ColorMenuLine'
                   layout: (LayoutFrame 100 0 24 0 5 1.0 46 0)
                   activeHelpKey: lineColor
                   model: lineColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Line-Width:'
                   name: 'Label7'
                   layout: (AlignmentOrigin 100 0 66 0 1 0.5)
                   activeHelpKey: lineWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 100 0 55 0 142 0 77 0)
                   activeHelpKey: lineWidth
                   model: lineWidth
                   type: integerInRange
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   numChars: 2
                   minValue: 0
                   maxValue: 99
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: true
                 )
                (LabelSpec
                   label: 'Line-Style:'
                   name: 'Label8'
                   layout: (AlignmentOrigin 250 0 66 0 1 0.5)
                   activeHelpKey: lineStyle
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboListSpec
                   name: 'ComboList1'
                   layout: (LayoutFrame 253 0 56 0 357 0 76 0)
                   activeHelpKey: lineStyle
                   model: lineStyle
                   comboList: possibleLineStyles
                   useIndex: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

subSpecForLineChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForLineChannel
        window: 
       (WindowSpec
          label: 'Any Component LineChannel'
          name: 'Any Component LineChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Line Channel:'
              name: 'lineChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: lineChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'lineChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: lineChannel
                    tabable: true
                    model: lineChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: lineChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForLineColorChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForLineColorChannel
        window: 
       (WindowSpec
          label: 'Any Component LineColorChannel'
          name: 'Any Component LineColorChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Line-Color Channel:'
              name: 'lineColorChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: lineColorChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'lineColorChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: lineColorChannel
                    tabable: true
                    model: lineColorChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: lineColorChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForLineStyleChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForLineStyleChannel
        window: 
       (WindowSpec
          label: 'Any Component LineStyleChannel'
          name: 'Any Component LineStyleChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'LineStyle Channel:'
              name: 'lineStyleChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: lineStyleChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'lineStyleChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: lineStyleChannel
                    tabable: true
                    model: lineStyleChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: lineStyleChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForLineWidthChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForLineWidthChannel
        window: 
       (WindowSpec
          label: 'Any Component LineWidthChannel'
          name: 'Any Component LineWidthChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'LineWidth Channel:'
              name: 'lineWidthChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: lineWidthChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'lineWidthChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: lineWidthChannel
                    tabable: true
                    model: lineWidthChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: lineWidthChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForMorphFillChannelBox
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForMorphFillChannelBox
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMorphFillChannelBox
        window: 
       (WindowSpec
          label: 'Morph Channels'
          name: 'Morph Channels'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 382 106)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Fill'
              name: 'FillBox'
              layout: (LayoutFrame 0 0 0 0 0 1 106 0)
              visibilityChannel: fillSettingVisible
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'FillSpecification'
                    layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                    minorKey: subSpecForFillChannel
                  )
                 (UISubSpecification
                    name: 'FillColorSpecification'
                    layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                    minorKey: subSpecForFillColorChannel
                  )
                 (UISubSpecification
                    name: 'PieSpecification'
                    layout: (LayoutFrame 0 0.0 50 0.0 4 1.0 75 0)
                    visibilityChannel: pieSettingVisible
                    minorKey: subSpecForPieChannel
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

subSpecForMorphLineChannelBox
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DisplayObjectComponentSpec andSelector:#subSpecForMorphLineChannelBox
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForMorphLineChannelBox
        window: 
       (WindowSpec
          label: 'Morph Line Channels'
          name: 'Morph Line Channels'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 382 152)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Line'
              name: 'LineBox'
              layout: (LayoutFrame 0 0 0 0 0 1 152 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'LineSpecification'
                    layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 25 0)
                    minorKey: subSpecForLineChannel
                  )
                 (UISubSpecification
                    name: 'LineColorSpecification'
                    layout: (LayoutFrame 0 0.0 25 0.0 4 1.0 50 0)
                    minorKey: subSpecForLineColorChannel
                  )
                 (UISubSpecification
                    name: 'LineWidthSpecification'
                    layout: (LayoutFrame 0 0.0 50 0.0 4 1.0 75 0)
                    minorKey: subSpecForLineWidthChannel
                  )
                 (UISubSpecification
                    name: 'LineStyleSpecification'
                    layout: (LayoutFrame 0 0.0 75 0.0 4 1.0 100 0)
                    minorKey: subSpecForLineStyleChannel
                  )
                 (UISubSpecification
                    name: 'ClosePathSpecification'
                    layout: (LayoutFrame 0 0.0 100 0.0 4 1.0 125 0)
                    visibilityChannel: closePathSettingVisible
                    minorKey: subSpecForClosePathChannel
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

subSpecForOriginChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForOriginChannel
        window: 
       (WindowSpec
          label: 'Any Component OriginChannel'
          name: 'Any Component OriginChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Origin Channel:'
              name: 'originChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: originChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'originChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: originChannel
                    tabable: true
                    model: originChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: originChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForPieChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForPieChannel
        window: 
       (WindowSpec
          label: 'Any Component PieChannel'
          name: 'Any Component PieChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Pie Channel:'
              name: 'pieChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: pieChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'pieChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: pieChannel
                    tabable: true
                    model: pieChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: pieChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForStartAngleChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForStartAngleChannel
        window: 
       (WindowSpec
          label: 'Any Component StartAngleChannel'
          name: 'Any Component StartAngleChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'StartAngle Channel:'
              name: 'startAngleChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: startAngleChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'startAngleChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: startAngleChannel
                    tabable: true
                    model: startAngleChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: startAngleChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
!

subSpecForSweepAngleChannel
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecification andSelector:#subSpecForFGColorChannel
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: subSpecForSweepAngleChannel
        window: 
       (WindowSpec
          label: 'Any Component SweepAngleChannel'
          name: 'Any Component SweepAngleChannel'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 31)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'SweepAngle Channel:'
              name: 'sweepAngleChannelLabel'
              layout: (AlignmentOrigin 118 0 12 0 1 0.5)
              activeHelpKey: sweepAngleChannel
              translateLabel: true
              resizeForLabel: true
            )
                 (ComboBoxSpec
                    name: 'sweepAngleChannelField'
                    layout: (LayoutFrame 120 0 1 0 -20 1.0 23 0)
                    activeHelpKey: sweepAngleChannel
                    tabable: true
                    model: sweepAngleChannel
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    comboList: listOfAspects
                  )
           (ActionButtonSpec
              label: 'browseActionImage'
              name: 'Button1'
              layout: (LayoutFrame -20 1 1 0 0 1 23 0)
              activeHelpKey: browseAspectMethod
              hasCharacterOrientedLabel: false
              translateLabel: true
              model: doBrowseAspectMethod:
              actionValue: sweepAngleChannel
            )
           )

        )
      )

    "Modified: / 12-01-2008 / 19:24:12 / cg"
! !

!DisplayObjectComponentSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    super addBindingsTo:env for:anInstance channel:aChannel.

    env at:#possibleLineStyles put:#( #solid #dashed dotted ).

    self 
        adaptApects:
                    #(  
                        originChannel
                        extentChannel

                        foregroundColorChannel
                        backgroundColorChannel
                        lineColorChannel
                        fillChannel
                        lineChannel
                        lineWidthChannel
                        lineStyleChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        foregroundColor
                        backgroundColor
                        lineColor
                        lineWidth
                        lineStyle
                        line
                        fill
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    env at:#morphSpecificChannelsVisible put:false.
    env at:#fillChannelsVisible put:true.
    env at:#lineChannelsVisible put:true.
    env at:#geometryChannelsVisible put:true.

    env at:#pieSettingVisible put:false.
    env at:#closePathSettingVisible put:false.
    env at:#backgroundSettingVisible put:false.
!

additionalBasicAttributesSubSpec
    ^ self colorsSubSpec
!

slices
    "return the slices for the attribute sections in the GUI Painter"
    "each item consists of a label and a window-spec selector"

    ^#(     
        (Basics   basicsEditSpec)
        ('Morph' morphChannelEditSpec)
        (Channels channelsEditSpec)
      )
! !

!DisplayObjectComponentSpec methodsFor:'accessing'!

fill
    ^ fill ? true
!

fill:aBoolean
    fill := aBoolean.
!

line
    ^ line ? true
!

line:aBoolean
    line := aBoolean.
!

lineColor
    ^ lineColor 
!

lineColor:aColor
    lineColor := aColor.
!

lineStyle
    "#solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    ^ lineStyle ? #solid
!

lineStyle:aSymbol
    "#solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    lineStyle := aSymbol.
!

lineWidth
    ^ lineWidth ? 0
!

lineWidth:anInteger
    lineWidth := anInteger.
! !

!DisplayObjectComponentSpec methodsFor:'accessing-channels'!

backgroundColorChannel
    ^ backgroundColorChannel
!

backgroundColorChannel:something
    backgroundColorChannel := something.
!

extentChannel
    ^ extentChannel
!

extentChannel:something
    extentChannel := something.
!

fillChannel
    ^ fillChannel
!

fillChannel:something
    fillChannel := something.
!

foregroundColorChannel
    ^ foregroundColorChannel
!

foregroundColorChannel:something
    foregroundColorChannel := something.
!

lineChannel
    ^ lineChannel
!

lineChannel:something
    lineChannel := something.
!

lineColorChannel
    ^ lineColorChannel
!

lineColorChannel:something
    lineColorChannel := something.
!

lineStyleChannel
    ^ lineStyleChannel
!

lineStyleChannel:something
    lineStyleChannel := something.
!

lineWidthChannel
    ^ lineWidthChannel
!

lineWidthChannel:something
    lineWidthChannel := something.
!

originChannel
    ^ originChannel
!

originChannel:something
    originChannel := something.
! !

!DisplayObjectComponentSpec methodsFor:'accessing-color & font'!

backgroundColor
    ^ backgroundColor
!

backgroundColor:aColor
    backgroundColor := aColor.
!

foregroundColor
    ^ foregroundColor 
!

foregroundColor:aColor
    foregroundColor := aColor.
! !

!DisplayObjectComponentSpec methodsFor:'building'!

setAttributesIn:aComponent with:aBuilder
    "set my attributes to anArc (which is a StrokingWrapper"

    super setAttributesIn:aComponent with:aBuilder.

    aComponent line:line.
    aComponent lineColor:lineColor.
    aComponent lineWidth:lineWidth.
    aComponent lineStyle:lineStyle.
    aComponent foregroundColor:foregroundColor.
    aComponent backgroundColor:backgroundColor.
    aComponent fill:fill.
!

setChannelsIn:aComponent with:aBuilder
    "set channels in anArc"

    super setChannelsIn:aComponent with:aBuilder.

    originChannel notNil ifTrue:[
        aComponent originHolder:(self channel:#originChannel inBuilder:aBuilder)
    ].
    extentChannel notNil ifTrue:[
        aComponent extentHolder:(self channel:#extentChannel inBuilder:aBuilder)
    ].

    lineChannel notNil ifTrue:[
        aComponent lineHolder:(self channel:#lineChannel inBuilder:aBuilder)
    ].
    lineColorChannel notNil ifTrue:[
        aComponent lineColorHolder:(self channel:#lineColorChannel inBuilder:aBuilder)
    ].
    foregroundColorChannel notNil ifTrue:[
        aComponent foregroundColorHolder:(self channel:#foregroundColorChannel inBuilder:aBuilder)
    ].
    backgroundColorChannel notNil ifTrue:[
        aComponent backgroundColorHolder:(self channel:#backgroundColorChannel inBuilder:aBuilder)
    ].
    lineWidthChannel notNil ifTrue:[
        aComponent lineWidthHolder:(self channel:#lineWidthChannel inBuilder:aBuilder)
    ].
    lineStyleChannel notNil ifTrue:[
        aComponent lineStyleHolder:(self channel:#lineStyleChannel inBuilder:aBuilder)
    ].
    fillChannel notNil ifTrue:[
        aComponent fillHolder:(self channel:#fillChannel inBuilder:aBuilder)
    ].
! !

!DisplayObjectComponentSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    lineColor notNil ifTrue:[lineColor := lineColor decodeAsLiteralArray].
    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    foregroundColor isNil ifTrue:[l add:#foregroundColor].
    backgroundColor isNil ifTrue:[l add:#backgroundColor].
    line isNil ifTrue:[l add:#line].
    lineColor isNil ifTrue:[l add:#lineColor].
    lineWidth isNil ifTrue:[l add:#lineWidth].
    lineStyle isNil ifTrue:[l add:#lineStyle].
    fill isNil ifTrue:[l add:#fill].

    foregroundColorChannel isNil ifTrue:[l add:#foregroundColorChannel].
    backgroundColorChannel isNil ifTrue:[l add:#backgroundColorChannel].
    lineColorChannel isNil ifTrue:[l add:#lineColorChannel].
    lineWidthChannel isNil ifTrue:[l add:#lineWidthChannel].
    lineStyleChannel isNil ifTrue:[l add:#lineStyleChannel].
    fillChannel isNil ifTrue:[l add:#fillChannel].

    originChannel isNil ifTrue:[l add:#originChannel].
    extentChannel isNil ifTrue:[l add:#extentChannel].

    ^l

    "Modified: / 20.6.1998 / 13:41:10 / cg"
! !

!DisplayObjectComponentSpec methodsFor:'interface-painter'!

documentFileName
    "returns the basename of the file, which contains the html documentation for
     the widget (shown in the UI-Painters widget-doc)."

    ^ 'Morph'
! !

!DisplayObjectComponentSpec methodsFor:'parsing a view'!

fromView:aComponent callBack:aBlock
    "extract attributes from aComponent"

    super fromView:aComponent callBack:aBlock.

    lineColor := aComponent lineColor.
    foregroundColor := aComponent foregroundColor.
    backgroundColor := aComponent backgroundColor.
    lineWidth := aComponent lineWidth.
    lineStyle := aComponent lineStyle.
    fill := aComponent fill.
    line := aComponent line.
! !

!DisplayObjectComponentSpec methodsFor:'queries-UIPainter'!

needsRebuildForAttributes

    ^ false
! !

!DisplayObjectComponentSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/DisplayObjectComponentSpec.st,v 1.19 2017-11-28 18:21:18 cg Exp $'
! !

