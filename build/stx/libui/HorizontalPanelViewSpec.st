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

PanelViewSpec subclass:#HorizontalPanelViewSpec
	instanceVariableNames:'reverseOrderIfOKAtLeft'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!HorizontalPanelViewSpec class methodsFor:'documentation'!

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

    "Modified: 4.9.1995 / 19:40:01 / claus"
!

documentation
"
    not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

    "Modified: 4.9.1995 / 19:35:11 / claus"
! !

!HorizontalPanelViewSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'HorizontalPanelViewSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PH"H"H"H#@ @PJH"H"H"A@ @PJH"H"H"A@ @PJCL0L3BA@ @PJCL0L3BA@ @PJCL0L3BA@ @PJ@@@@@BA@ @PJH"H"H"A@ @PJH"H"H"A@ @PHQDQDQDQ@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
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

!HorizontalPanelViewSpec class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HorizontalPanelViewSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       uuid: 'd8f59124-2d50-11e8-b14a-b8f6b1108e05'
       window: 
      (WindowSpec
         label: 'Panel Details'
         name: 'Panel Details'
         uuid: 'd8f59444-2d50-11e8-b14a-b8f6b1108e05'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 338)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'subSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 99 0)
             uuid: 'd8f5971e-2d50-11e8-b14a-b8f6b1108e05'
             majorKey: ViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Spacing Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 102 0 0 1.0 260 0)
             uuid: 'd8f59872-2d50-11e8-b14a-b8f6b1108e05'
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
                   uuid: 'd8f59a0c-2d50-11e8-b14a-b8f6b1108e05'
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'horizontalField'
                   layout: (LayoutFrame 100 0 6 0 140 0 28 0)
                   activeHelpKey: horizontalSpace
                   uuid: 'd8f59bd8-2d50-11e8-b14a-b8f6b1108e05'
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
                   uuid: 'd8f59eda-2d50-11e8-b14a-b8f6b1108e05'
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'verticalField'
                   layout: (LayoutFrame 253 0 6 0 293 0 28 0)
                   activeHelpKey: verticalSpace
                   uuid: 'd8f59fde-2d50-11e8-b14a-b8f6b1108e05'
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
                   layout: (LayoutFrame 12 0 39 0 0 1 64 0)
                   activeHelpKey: ignoreInvisibleComponents
                   uuid: 'd8f5a146-2d50-11e8-b14a-b8f6b1108e05'
                   tabable: true
                   model: ignoreInvisibleComponents
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Track sizeChange of components'
                   name: 'componentsChangeSizeLabel'
                   layout: (LayoutFrame 12 0 68 0 0 1 93 0)
                   activeHelpKey: componentsChangeSize
                   uuid: 'd8f5a2d6-2d50-11e8-b14a-b8f6b1108e05'
                   tabable: true
                   model: elementsChangeSize
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Reverse components if viewStyles OK is at left'
                   name: 'reverseIfOKOnLeftCheckBox1'
                   layout: (LayoutFrame 12 0 97 0 0 1.0 122 0)
                   activeHelpKey: reverseOrderIfOKAtLeft
                   uuid: 'd8f5a3bc-2d50-11e8-b14a-b8f6b1108e05'
                   tabable: true
                   model: reverseOrderIfOKAtLeft
                   translateLabel: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 262 0 0 1.0 335 0)
             uuid: 'd8f5a4b6-2d50-11e8-b14a-b8f6b1108e05'
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
                   uuid: 'd8f5a588-2d50-11e8-b14a-b8f6b1108e05'
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

!HorizontalPanelViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        reverseOrderIfOKAtLeft
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    env at:#horizontalLayoutList put:(anInstance viewClass possibleHorizontalLayouts).
    env at:#verticalLayoutList put:(anInstance viewClass possibleVerticalLayouts).   

    "Modified: 17.8.1997 / 15:18:00 / cg"
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:VerticalPanelViewSpec
        with:PanelViewSpec 
        with:VariableHorizontalPanelSpec

    "Created: / 13-01-2008 / 00:00:57 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics     basicsEditSpec)
            (Details    detailsEditSpec)
            (Channels   channelsEditSpec)
       )

! !

!HorizontalPanelViewSpec methodsFor:'accessing'!

reverseOrderIfOKAtLeft
    "return the value of the instance variable 'reverseOrderIfOKAtLeft' (automatically generated)"

    ^ reverseOrderIfOKAtLeft
!

reverseOrderIfOKAtLeft:something
    "set the value of the instance variable 'reverseOrderIfOKAtLeft' (automatically generated)"

    reverseOrderIfOKAtLeft := something.
! !

!HorizontalPanelViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    aBuilder isEditing ifFalse:[
        aView reverseOrderIfOKAtLeft:(reverseOrderIfOKAtLeft ? false).
    ].
    super setAttributesIn:aView with:aBuilder.


! !

!HorizontalPanelViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.
    reverseOrderIfOKAtLeft ~~ true ifTrue:[l add:#reverseOrderIfOKAtLeft].
    ^ l
! !

!HorizontalPanelViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    reverseOrderIfOKAtLeft := aView reverseOrderIfOKAtLeft.
    super fromView:aView callBack:aBlock.



! !

!HorizontalPanelViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Horizontal', super userFriendlyName

! !

!HorizontalPanelViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitHorizontalPanelViewSpec:self
! !

!HorizontalPanelViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/HorizontalPanelViewSpec.st,v 1.28 2018-03-23 11:19:24 cg Exp $'
! !

