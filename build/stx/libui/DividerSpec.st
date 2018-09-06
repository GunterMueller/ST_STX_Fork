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

ComponentSpec subclass:#DividerSpec
	instanceVariableNames:'orientation foregroundColor backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!DividerSpec class methodsFor:'documentation'!

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

!DividerSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'DividerSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@,UUUUU01????>@GC???8@\''???"Q2_??>BGI0@C8D\''J*'' A2_UU^EGI???8,\''???"A2_??>@G5???8\_???? C*****H@@@@@@@b');
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

!DividerSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DividerSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'Divider Basics'
          name: 'Divider Basics'
          min: (Point 10 10)
          max: (Point 1280 1024)
          bounds: (Rectangle 0 0 400 103)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Basic Attributes'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 101 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'ID:'
                    name: 'nameLabel'
                    layout: (AlignmentOrigin 101 0 24 0 1 0.5)
                    activeHelpKey: id
                    translateLabel: true
                    resizeForLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'nameField'
                    layout: (LayoutFrame 104 0 13 0 5 1.0 35 0)
                    activeHelpKey: id
                    tabable: true
                    model: name
                    group: inputGroup
                    acceptOnLeave: true
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: true
                  )
                 (LabelSpec
                    label: 'Orientation:'
                    name: 'orientationLabel'
                    layout: (AlignmentOrigin 103 0 51 0 1 0.5)
                    activeHelpKey: orientation
                    translateLabel: true
                    resizeForLabel: true
                  )
                 (PopUpListSpec
                    label: 'Orientation'
                    name: 'orientationPopUpList'
                    layout: (LayoutFrame 104 0 39 0 5 1.0 63 0)
                    activeHelpKey: orientation
                    tabable: true
                    model: orientation
                    menu: orientationList
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

channelsEditSpec
    ^ self visibilityAndBackgroundChannelEditSpec
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DividerSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'View Details'
         name: 'View Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 190)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'colorSubSpec'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 106 0)
             majorKey: UISpecification
             minorKey: colorSubSpec
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 110 0 0 1.0 180 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 10 4)
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

!DividerSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        initiallyInvisible
                        orientation
                        foregroundColor
                        backgroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    env at:#orientationList put:#(horizontal vertical)

    "Modified: / 20-03-2012 / 21:17:52 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics  basicsEditSpec)
            (Details detailsEditSpec)
            (Channels channelsEditSpec)
       )
! !

!DividerSpec methodsFor:'accessing'!

orientation
    "return the value of the instance variable 'orientation' (automatically generated)"

    ^ orientation ? #horizontal

    "Modified: 28.2.1997 / 21:22:30 / cg"
!

orientation:something
    "set the value of the instance variable 'orientation' (automatically generated)"

    orientation := something.
! !

!DividerSpec methodsFor:'accessing-color & font'!

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

    foregroundColor := something

! !

!DividerSpec methodsFor:'building'!

layout:aLayout for:aView
    |lyt|

    (layout isNil or:[aLayout isAssociation]) ifTrue:[
        ^ super layout:aLayout for:aView
    ].
    lyt := aLayout copy.

    aLayout isRectangle ifTrue:[
        self orientation == #horizontal ifTrue:[
           "/ lyt top:(lyt top + (lyt height//2) - 2).
            lyt height:3.
        ] ifFalse:[
           "/ lyt left:(lyt left + (lyt width//2) - 2).
            lyt width:3.
        ]
    ].
    aView geometryLayout:lyt.
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |styleSheet|

    super setAttributesIn:aView with:aBuilder.

    orientation notNil ifTrue:[aView orientation:orientation].

    styleSheet := self viewClass styleSheet.    "/ cg: why not the instances styleSheet ?
    aView lightColor: foregroundColor ? (styleSheet colorAt:#lightColor)  ? Color white.
    aView shadowColor:backgroundColor ? (styleSheet colorAt:#shadowColor) ? Color black.
"/    visibilityChannel isNil ifTrue:[
"/       self setVisibilityAttribute:(self initiallyInvisible) in:aView.
"/    ].

    aBuilder isEditing ifTrue: [aView invalidate]

    "Modified: / 20-03-2012 / 21:21:40 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

"/    aBuilder isEditing ifFalse:[
"/        visibilityChannel notNil ifTrue:[
"/            c := self channel:#visibilityChannel inBuilder:aBuilder.
"/            c notNil ifTrue:[
"/                self setVisibilityChannel:c inView:aView with:aBuilder
"/            ].
"/        ].
"/        backgroundChannel notNil ifTrue:[
"/            c := self channel:#backgroundChannel inBuilder:aBuilder.
"/            c notNil ifTrue:[aView backgroundChannel:c].
"/        ].
"/    ]

    "Modified: / 20-03-2012 / 21:21:54 / cg"
! !

!DividerSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].        
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].


!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    self orientation == #horizontal ifTrue:[l add:#orientation].
"/    visibilityChannel size == 0 ifTrue:[ l add:#visibilityChannel ].
"/    (initiallyInvisible == true) ifFalse:[l add:#initiallyInvisible].

    ^ l

    "Modified: / 20-03-2012 / 21:22:10 / cg"
! !

!DividerSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    orientation := aView orientation ? #horizontal.
    (aView respondsTo:#lightColor) ifTrue:[
        foregroundColor := aView lightColor.
    ].
    (aView respondsTo:#shadowColor) ifTrue:[
        backgroundColor := aView shadowColor.
    ].
"/    initiallyInvisible := aView isHiddenOnRealize.
    super fromView:aView callBack:aBlock

    "Modified: / 20-03-2012 / 21:22:16 / cg"
! !

!DividerSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Separator'



!

viewClass
    "return the corresponding view class of the spec"

    ^ Separator


! !

!DividerSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitDividerSpec:self
! !

!DividerSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/DividerSpec.st,v 1.53 2017-11-28 18:21:19 cg Exp $'
! !

