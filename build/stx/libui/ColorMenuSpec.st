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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

NamedSpec subclass:#ColorMenuSpec
	instanceVariableNames:'labelsAreColored allowSymbolicColors allowNilColor
		useDefaultToggleVisible'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ColorMenuSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    Notice:
        used by UISpecifications to add a color menu

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"



! !

!ColorMenuSpec class methodsFor:'image specs'!

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
    
    ^ Icon constantNamed:'ColorMenuSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PIDQDUUUQ@ @PIDQDUUUQ@ @PIDQDUUUQ@ @PIDQDUUUQ@ @PI&Y&]7]1@ @PI&Y&]7]1@ 
@PI&Y&]7]1@ @PI&Y&]7]1@ @PLQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 255 183 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!ColorMenuSpec class methodsFor:'interface specs'!

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ColorMenuSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: channelsEditSpec
        window: 
       (WindowSpec
          label: 'ActionButton Channels'
          name: 'ActionButton Channels'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 413 157)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Channels'
              name: 'ChannelsBox'
              layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 94 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'VisibilityChannelSubSpecification'
                    layout: (LayoutFrame 0 0.0 3 0.0 4 1.0 28 0)
                    majorKey: UISpecification
                    minorKey: subSpecForVisibilityChannel
                  )
                 (UISubSpecification
                    name: 'EnableChannelSubSpecification'
                    layout: (LayoutFrame 0 0.0 29 0.0 4 1.0 54 0)
                    majorKey: UISpecification
                    minorKey: subSpecForEnableChannel
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'CallBacks'
              name: 'CallBacksBox'
              layout: (LayoutFrame 0 0 96 0 0 1 153 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'SubSpecification5'
                    layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 28 0)
                    majorKey: UISpecification
                    minorKey: subSpecForPostBuildCallBack
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ColorMenuSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'InputField Details'
         name: 'InputField Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 414 202)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Details'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Allow Symbolic Colors'
                         name: 'CheckBox1'
                         layout: (Point 10 -1)
                         activeHelpKey: allowSymbolicColors
                         tabable: true
                         model: allowSymbolicColors
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Allow Nil'
                         name: 'CheckBox4'
                         layout: (Point 10 21)
                         activeHelpKey: allowNilColor
                         tabable: true
                         model: allowNilColor
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Labels are Colored'
                         name: 'CheckBox2'
                         layout: (Point 10 43)
                         activeHelpKey: labelsAreColored
                         tabable: true
                         model: labelsAreColored
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: '"Use Default" Toggle Visible'
                         name: 'CheckBox3'
                         layout: (Point 10 65)
                         activeHelpKey: showUseDefaultToggle
                         tabable: true
                         model: useDefaultToggleVisible
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 414 132)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Attributes'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Can Tab'
                         name: 'tabableCheckBox'
                         layout: (Point 10 -2)
                         activeHelpKey: tabable
                         tabable: true
                         model: tabable
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 414 64)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ColorMenuSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        labelsAreColored
                        allowNilColor
                        allowSymbolicColors
                        useDefaultToggleVisible
                     )
        to:env 
        for:inst 
        channel:aChannel.

    "Modified: / 24-01-2011 / 10:13:50 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels channelsEditSpec)
      )
! !

!ColorMenuSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ false



! !

!ColorMenuSpec methodsFor:'accessing'!

allowNilColor
    ^ allowNilColor

    "Created: / 24-01-2011 / 10:14:13 / cg"
!

allowNilColor:aBoolean
    allowNilColor := aBoolean.

    "Created: / 24-01-2011 / 10:14:17 / cg"
!

allowSymbolicColors
    ^ allowSymbolicColors
!

allowSymbolicColors:aBoolean
    allowSymbolicColors := aBoolean.

    "Modified: / 23-01-2011 / 12:30:25 / cg"
!

labelsAreColored
    "gets whether labels or their backgrounds will be colored."

    ^labelsAreColored
!

labelsAreColored:aBoolean
    "sets whether labels or their backgrounds will be colored."

    labelsAreColored := aBoolean.

    "Modified: / 23-01-2011 / 12:30:33 / cg"
!

useDefaultToggleVisible
    ^ useDefaultToggleVisible

    "Created: / 23-01-2011 / 12:32:41 / cg"
!

useDefaultToggleVisible:aBoolean
    useDefaultToggleVisible := aBoolean.

    "Created: / 23-01-2011 / 12:32:45 / cg"
! !

!ColorMenuSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aView labelsAreColored: labelsAreColored.
    aView allowSymbolicColors: allowSymbolicColors.
    aView allowNilColor: allowNilColor.
    aView useDefaultColorToggleVisibleHolder value:useDefaultToggleVisible.

    aBuilder isEditing ifFalse:[
        aView model:(self modelInBuilder:aBuilder).
    ].

    "Modified: / 24-01-2011 / 10:14:32 / cg"
! !

!ColorMenuSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    allowSymbolicColors ifFalse:[l add:#allowSymbolicColors].
    self allowNilColor ifFalse:[l add:#allowNilColor].
    labelsAreColored ifFalse:[l add:#labelsAreColored].
    useDefaultToggleVisible ifTrue:[l add:#useDefaultToggleVisible].

    ^ l

    "Modified: / 24-01-2011 / 10:23:29 / cg"
! !

!ColorMenuSpec methodsFor:'initialization'!

initialize
    super initialize.
    labelsAreColored := false.
    allowSymbolicColors := false.
    allowNilColor := false.
    useDefaultToggleVisible := true.

    "Modified: / 24-01-2011 / 10:23:46 / cg"
! !

!ColorMenuSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitColorMenuSpec:self
! !

!ColorMenuSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ColorMenuSpec.st,v 1.25 2015-11-19 13:52:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ColorMenuSpec.st,v 1.25 2015-11-19 13:52:55 cg Exp $'
! !

