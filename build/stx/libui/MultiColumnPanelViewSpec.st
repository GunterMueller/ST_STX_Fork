"
 COPYRIGHT (c) 2007 by Claus Gittinger
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

PanelViewSpec subclass:#MultiColumnPanelViewSpec
	instanceVariableNames:'columnWidths'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MultiColumnPanelViewSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by Claus Gittinger
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
        Claus Gittinger

    [see also:]
        UIBuilder
        UIPainter
"
! !

!MultiColumnPanelViewSpec class methodsFor:'image specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MultiColumnPanelViewSpec andSelector:#basicsEditSpec
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
         bounds: (Rectangle 0 0 400 160)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 152 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 5 0 5 1.0 27 0)
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
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   activeHelpKey: horizontalLayout
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'popup'
                   name: 'horizontalLayoutPopUpList'
                   layout: (LayoutFrame 100 0 31 0 5 1.0 55 0)
                   activeHelpKey: horizontalLayout
                   translateLabel: true
                   tabable: true
                   model: horizontalLayout
                   menu: horizontalLayoutList
                 )
                (LabelSpec
                   label: 'Vertical:'
                   name: 'verticalLabel'
                   layout: (LayoutFrame 0 0 62 0 100 0 78 0)
                   activeHelpKey: verticalLayout
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'popup'
                   name: 'verticalLayoutPopUpList'
                   layout: (LayoutFrame 100 0 58 0 5 1 82 0)
                   activeHelpKey: verticalLayout
                   translateLabel: true
                   tabable: true
                   model: verticalLayout
                   menu: verticalLayoutList
                 )
                (LabelSpec
                   label: 'Nr. of Columns:'
                   name: 'numColLabel'
                   layout: (LayoutFrame -5 0 90 0 150 0 106 0)
                   activeHelpKey: verticalLayout
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 150 0 87 0 190 0 109 0)
                   activeHelpKey: id
                   tabable: true
                   model: numberOfColumns
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

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
    
    ^ Icon constantNamed:#'MultiColumnPanelViewSpec class icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@QDQDQDQDQD0@P@@@@@@@@@ @PL3L0L3L3@ @PL3L0L3L3@ @P@@@@@@@@@ @PL3L0L3L3@ @PL3L0L3L3@ @P@@@@@@@@@ @PL3L0L3L3@ 
@PL3L0L3L3@ @P@@@@L3L3@ @PL3L3L3L3@ @P@@@@@@@@@ @2H"H"H"H"H @@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!MultiColumnPanelViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    env at:#horizontalLayoutList
       put:#(
                #left
"/                #leftSpace
"/                #center
"/                #right
"/                #rightSpace
                #fit
"/                #fitSpace
"/                #leftMax
"/                #leftSpaceMax
"/                #centerMax
"/                #rightMax
"/                #rightSpaceMax
            ) asValue.

    env at:#verticalLayoutList
       put:#(
                #top
"/                #topSpace
"/                #bottom
"/                #bottomSpace
"/                #center
"/                #spread
"/                #spreadSpace
"/                #fit
"/                #fitSpace
"/                #topFit
"/                #topSpaceFit
"/                #bottomFit
"/                #bottomSpaceFit
            ) asValue.

    self 
        adaptApects:
                    #(  
                        numberOfColumns
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    "Modified: / 18.7.1998 / 13:16:11 / cg"
    "Modified: / 26.10.1997 / 02:56:47 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics     basicsEditSpec)
            (Details    detailsEditSpec)
            (Channels   channelsEditSpec)
       )

! !

!MultiColumnPanelViewSpec methodsFor:'accessing'!

columnWidths
    ^ columnWidths ? #(1)
!

columnWidths:aCollection
    columnWidths := aCollection
!

horizontalLayout
    "return horizontalLayout"

    ^ horizontalLayout ? #fit

    "Modified: 5.9.1995 / 17:39:08 / claus"
!

numberOfColumns 
    ^ columnWidths size max:1
!

numberOfColumns:n
    columnWidths := Array new:n withAll:(1.0 / n)
!

verticalLayout
    "return verticalLayout"

    ^ verticalLayout ? #top

    "Modified: 5.9.1995 / 17:39:08 / claus"
! !

!MultiColumnPanelViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    aView columnWidths:(self columnWidths).
    super setAttributesIn:aView with:aBuilder
! !

!MultiColumnPanelViewSpec methodsFor:'parsing a view'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    columnWidths notNil ifTrue:[
        columnWidths := columnWidths asOrderedCollection.
        columnWidths removeFirst.
    ].
!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    columnWidths := aView columnWidths.

    super fromView:aView callBack:aBlock.

    "Modified: / 20.7.1998 / 14:10:16 / cg"
! !

!MultiColumnPanelViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Row-Table', super userFriendlyName
! !

!MultiColumnPanelViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/MultiColumnPanelViewSpec.st,v 1.4 2015-11-19 13:52:27 cg Exp $'
! !

