"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

ComponentSpec subclass:#RegionSpec
	instanceVariableNames:'lineWidth regionType backgroundColor foregroundColor isOpaque'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!RegionSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!RegionSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RegionSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Region Basics'
         name: 'Region Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 168)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 164 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 22 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 11 0 5 1.0 33 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Shape:'
                   name: 'shapeLabel'
                   layout: (AlignmentOrigin 100 0 47 0 1 0.5)
                   activeHelpKey: regionType
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'rectangle'
                   name: 'regionTypeCheckBox'
                   layout: (LayoutFrame 100 0 36 0 5 1.0 58 0)
                   activeHelpKey: regionType
                   translateLabel: true
                   tabable: true
                   model: regionType
                   menu: regionTypeList
                 )
                (LabelSpec
                   label: 'Width:'
                   name: 'widthLabel'
                   layout: (AlignmentOrigin 100 0 72 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'widthField'
                   layout: (LayoutFrame 100 0 61 0 140 0 83 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: lineWidth
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (CheckBoxSpec
                   label: 'Opaque'
                   name: 'isOpaqueCheckBox'
                   layout: (Point 10 89)
                   activeHelpKey: isOpaque
                   tabable: true
                   model: isOpaque
                   translateLabel: true
                 )
                )
              
             )
           )
          )
        
       )
     )
!

detailsEditSpec
    ^ DividerSpec detailsEditSpec
! !

!RegionSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        isOpaque
                        initiallyInvisible
                        regionType
                        backgroundColor
                        foregroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        lineWidth
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.

    env at:#regionTypeList put:#(#rectangle #ellipse) asValue.

    "Modified: / 20-03-2012 / 21:17:57 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics  basicsEditSpec)
            (Details detailsEditSpec)
       )

! !

!RegionSpec methodsFor:'accessing'!

isOpaque
    "return the value of the instance variable 'isOpaque' (automatically generated)"

    ^ isOpaque ? true

    "Created: 25.1.1997 / 18:44:59 / cg"
!

isOpaque:something
    "set the value of the instance variable 'isOpaque' (automatically generated)"

    isOpaque := something.

    "Created: 25.1.1997 / 18:44:59 / cg"
!

lineWidth
    "get the border drawing width in pixels
    "
  ^ lineWidth ? 0
!

lineWidth:something
    "set the border drawing width in pixels
    "
    lineWidth := something.
!

regionType
    "get the outline of the region; elliptical or rectangle
    "
  ^ regionType ? #rectangle
!

regionType:something
    "set the outline of the region; elliptical or rectangle
    "
    regionType := something.
! !

!RegionSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor  


!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something


!

foregroundColor
    "return the value of the instance variable 'foregroundColor' (automatically generated)"

    ^ foregroundColor
!

foregroundColor:something
    "set the value of the instance variable 'foregroundColor' (automatically generated)"

    foregroundColor := something.
! !

!RegionSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aView isElliptical:(self regionType ~~ #rectangle).
    aView isOpaque:(self isOpaque).
    aView lineWidth:(self lineWidth).
    self setViewBackgroundAttribute:backgroundColor in:aView with:aBuilder.
    foregroundColor notNil ifTrue:[
        aView borderColor:foregroundColor
    ] ifFalse:[
        aView borderColor:Color black
    ].

"/    visibilityChannel isNil ifTrue:[
"/       self setVisibilityAttribute:(self initiallyInvisible) in:aView.
"/    ].

    "Modified: / 20-03-2012 / 21:23:17 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

"/    visibilityChannel notNil ifTrue:[
"/        aBuilder isEditing ifFalse:[
"/            c := self channel:#visibilityChannel inBuilder:aBuilder.
"/            c notNil ifTrue:[
"/                self setVisibilityChannel:c inView:aView with:aBuilder
"/            ].
"/        ]
"/    ]
"/

    "Modified: / 20-03-2012 / 21:23:24 / cg"
! !

!RegionSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].



!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    isOpaque isNil                ifTrue:[l add:#isOpaque].
    self regionType == #rectangle ifTrue:[l add:#regionType].
    self lineWidth  == 0          ifTrue:[l add:#lineWidth].
"/    visibilityChannel size == 0 ifTrue:[ l add:#visibilityChannel ].
"/    (initiallyInvisible == true) ifFalse:[l add:#initiallyInvisible].

    ^l

    "Modified: / 20-03-2012 / 21:23:29 / cg"
! !

!RegionSpec methodsFor:'parsing a view'!

fromView:aRegion callBack:aBlock
    "extract attributes from aView"

    aRegion isElliptical ifTrue:[regionType := #rectangle]
                        ifFalse:[regionType := #ellipse].

    isOpaque        := aRegion isOpaque.
    lineWidth       := aRegion lineWidth.
    backgroundColor := aRegion backgroundColor.
"/    foregroundColor := aRegion borderColor.
"/    initiallyInvisible := aRegion isHiddenOnRealize.

    super fromView:aRegion callBack:aBlock.

    "Modified: / 20-03-2012 / 21:23:36 / cg"
! !

!RegionSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ VisualRegion


! !

!RegionSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/RegionSpec.st,v 1.31 2017-11-28 18:21:50 cg Exp $'
! !

