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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewSpec subclass:#PanelViewSpec
	instanceVariableNames:'horizontalLayout verticalLayout horizontalSpace verticalSpace
		ignoreInvisibleComponents elementsChangeSize'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!PanelViewSpec class methodsFor:'documentation'!

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
    Not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!PanelViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'PanelViewSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PJH"H"H"A@ @PJCL0L3BA@ @PJCL0L3BA@ @PJ@@@@@BA@ @PJCL0L3BA@ @PJCL0L3BA@ @PJ@@@@@BA@ @PJH"H"H"A@ @PHQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!PanelViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PanelViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Panel Basics'
         name: 'Panel Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 130)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 128 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 6 0 5 1.0 28 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Horizontal:'
                   name: 'horizontalLabel'
                   layout: (AlignmentOrigin 100 0 44 0 1 0.5)
                   activeHelpKey: horizontalLayout
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'popup'
                   name: 'horizontalLayoutPopUpList'
                   layout: (LayoutFrame 100 0 32 0 5 1.0 56 0)
                   activeHelpKey: horizontalLayout
                   translateLabel: true
                   tabable: true
                   model: horizontalLayout
                   menu: horizontalLayoutList
                 )
                (LabelSpec
                   label: 'Vertical:'
                   name: 'verticalLabel'
                   layout: (AlignmentOrigin 100 0 71 0 1 0.5)
                   activeHelpKey: verticalLayout
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'popup'
                   name: 'verticalLayoutPopUpList'
                   layout: (LayoutFrame 100 0 59 0 5 1 83 0)
                   activeHelpKey: verticalLayout
                   translateLabel: true
                   tabable: true
                   model: verticalLayout
                   menu: verticalLayoutList
                 )
                )
              
             )
           )
          )
        
       )
     )
!

basicsEditSpecWithoutAlign
    ^ super basicsEditSpec
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PanelViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Panel Details'
         name: 'Panel Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 425 339)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'subSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 99 0)
             majorKey: ViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Spacing Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 107 0 0 1.0 237 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Horizontal:'
                   name: 'horizontalLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
                   activeHelpKey: horizontalSpace
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'horizontalField'
                   layout: (LayoutFrame 100 0 6 0 140 0 28 0)
                   activeHelpKey: horizontalSpace
                   tabable: true
                   model: horizontalSpace
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Vertical:'
                   name: 'verticalLabel'
                   layout: (AlignmentOrigin 251 0 17 0 1 0.5)
                   activeHelpKey: verticalSpace
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'verticalField'
                   layout: (LayoutFrame 253 0 6 0 293 0 28 0)
                   activeHelpKey: verticalSpace
                   tabable: true
                   model: verticalSpace
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Ignore Invisible Components in Layout'
                   name: 'ignoreInvisibleCheckBox'
                   layout: (Point 12 33)
                   activeHelpKey: ignoreInvisibleComponents
                   tabable: true
                   model: ignoreInvisibleComponents
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Track sizeChange of components'
                   name: 'componentsChangeSizeLabel'
                   layout: (Point 12 64)
                   activeHelpKey: componentsChangeSize
                   tabable: true
                   model: elementsChangeSize
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 240 0 0 1.0 313 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 12 7)
                   activeHelpKey: initiallyInvisible
                   tabable: true
                   model: initiallyInvisible
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!PanelViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        horizontalLayout
                        verticalLayout
                        ignoreInvisibleComponents
                        elementsChangeSize
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        horizontalSpace
                        verticalSpace
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    "Modified: / 18.7.1998 / 13:16:11 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics     basicsEditSpecWithoutAlign)
            (Details    detailsEditSpec)
            (Channels   channelsEditSpec)
       )


! !

!PanelViewSpec class methodsFor:'queries'!

isLayoutContainer
    "answer whether corresponding view instances of the spec class can contain (and arrange) other view"

    ^ true


!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ true


! !

!PanelViewSpec methodsFor:'accessing'!

elementsChangeSize
    "return the value of the instance variable 'elementsChangeSize' (automatically generated)"

    ^ elementsChangeSize ? false
!

elementsChangeSize:aBoolean
    elementsChangeSize := aBoolean.
!

horizontalLayout
    "return horizontalLayout"

    ^ horizontalLayout ? #fitSpace

    "Modified: 5.9.1995 / 17:39:08 / claus"
!

horizontalLayout:something
    "set horizontalLayout"

    something isNil ifTrue:[
        horizontalLayout := nil
    ] ifFalse:[
        horizontalLayout := something asSymbol
    ]
!

horizontalSpace
    "return the value of the instance variable 'horizontalSpace' (automatically generated)"

    ^ horizontalSpace
!

horizontalSpace:something
    "set the value of the instance variable 'horizontalSpace' (automatically generated)"

    horizontalSpace := something.
!

ignoreInvisibleComponents
    "return the value of the instance variable 'ignoreInvisibleComponents' (automatically generated)"

    ^ ignoreInvisibleComponents ? true

    "Created: / 18.7.1998 / 13:14:35 / cg"
    "Modified: / 20.7.1998 / 14:09:52 / cg"
!

ignoreInvisibleComponents:something
    "set the value of the instance variable 'ignoreInvisibleComponents' (automatically generated)"

    ignoreInvisibleComponents := something.

    "Created: / 18.7.1998 / 13:14:35 / cg"
!

verticalLayout
    "return verticalLayout"

    ^ verticalLayout ? #fitSpace

    "Modified: 5.9.1995 / 17:39:08 / claus"
!

verticalLayout:something
    "set verticalLayout"

    something isNil ifTrue:[
        verticalLayout := nil
    ] ifFalse:[
        verticalLayout := something asSymbol
    ]
!

verticalSpace
    "return the value of the instance variable 'verticalSpace' (automatically generated)"

    ^ verticalSpace
!

verticalSpace:something
    "set the value of the instance variable 'verticalSpace' (automatically generated)"

    verticalSpace := something.
! !

!PanelViewSpec methodsFor:'building'!

buildViewWithLayoutFor:aBuilder in:aView
    |newView|

    newView := super buildViewWithLayoutFor:aBuilder in:aView.
    layout isNil ifTrue:[ 
        "/ must recompute preferredExtent AFTER we have added the children.
        "/ (the computation which was done at view-creation time was wrong,
        "/  as it was based on an empty children collection)
        newView forceResize
    ].
    ^ newView
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    horizontalLayout notNil ifTrue:[aView horizontalLayout:horizontalLayout].
    verticalLayout notNil   ifTrue:[aView verticalLayout:verticalLayout].

    horizontalSpace notNil  ifTrue:[aView horizontalSpace:horizontalSpace].
    verticalSpace notNil    ifTrue:[aView verticalSpace:verticalSpace].

    ignoreInvisibleComponents notNil ifTrue:[aView ignoreInvisibleComponents:ignoreInvisibleComponents].
    elementsChangeSize notNil ifTrue:[aView elementsChangeSize:elementsChangeSize].

    super setAttributesIn:aView with:aBuilder.

    "Modified: / 20.7.1998 / 14:10:11 / cg"
!

setupInitialLayoutFor:aView
    aView extent:(aView computeExtent).
    aView geometryLayout:nil.
    aView superView shown ifTrue:[
        aView superView setChildPositions.
    ]

! !

!PanelViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    ignoreInvisibleComponents isNil ifTrue:[l add:#ignoreInvisibleComponents].
    elementsChangeSize ~~ true ifTrue:[l add:#elementsChangeSize].
    ^ l

    "Created: / 20.7.1998 / 14:10:56 / cg"
! !

!PanelViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    horizontalLayout := aView horizontalLayout.
    verticalLayout   := aView verticalLayout.
    horizontalSpace  := aView horizontalSpace.
    verticalSpace    := aView verticalSpace.
    ignoreInvisibleComponents := aView ignoreInvisibleComponents.
    elementsChangeSize := aView elementsChangeSize.

    super fromView:aView callBack:aBlock.

    "Modified: / 20.7.1998 / 14:10:16 / cg"
! !

!PanelViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Panel'



! !

!PanelViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/PanelViewSpec.st,v 1.54 2015-11-19 13:53:22 cg Exp $'
! !

