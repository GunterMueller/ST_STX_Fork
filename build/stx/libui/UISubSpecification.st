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

ComponentSpec subclass:#UISubSpecification
	instanceVariableNames:'majorKey minorKey'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!UISubSpecification class methodsFor:'documentation'!

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

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"





! !

!UISubSpecification class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISubSpecification andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'UISubSpecification Basics'
         name: 'UISubSpecification Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 152)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 151 0)
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
                   label: 'Class:'
                   name: 'classLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   activeHelpKey: majorKey
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'classField'
                   layout: (LayoutFrame 100 0 31 0 5 1 53 0)
                   activeHelpKey: majorKey
                   tabable: true
                   model: majorKey
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Selector:'
                   name: 'selectorLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   activeHelpKey: minorKey
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'selectorField'
                   layout: (LayoutFrame 100 0 56 0 5 1 78 0)
                   activeHelpKey: minorKey
                   tabable: true
                   model: minorKey
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (ActionButtonSpec
                   label: 'Browser'
                   name: 'Button1'
                   layout: (LayoutFrame -310 1 83 0 -152 1 107 0)
                   activeHelpKey: openSubSpecGuiHelp
                   translateLabel: true
                   tabable: true
                   model: openSubSpecBrowser
                 )
                (ActionButtonSpec
                   label: 'GUI Painter'
                   name: 'guiForSubspecButton'
                   layout: (LayoutFrame -150 1 83 0 5 1 107 0)
                   activeHelpKey: openSubSpecGuiHelp
                   translateLabel: true
                   tabable: true
                   model: openSubSpecGUIPainter
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
     UIPainter new openOnClass:UISubSpecification andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'UISubSpecification Details'
         name: 'UISubSpecification Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 217)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 75 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Border:'
                   name: 'borderLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'borderWidthField'
                   layout: (LayoutFrame 100 0 9 0 140 0 31 0)
                   activeHelpKey: borderWidth
                   tabable: true
                   model: borderWidth
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Level:'
                   name: 'LevelLabel'
                   layout: (AlignmentOrigin 208 0 20 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 210 0 9 0 250 0 31 0)
                   activeHelpKey: level
                   tabable: true
                   model: level
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 104 0 0 1.0 177 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 15 6)
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

!UISubSpecification class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        majorKey
                        minorKey
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.


!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(
            (Basics   basicsEditSpec)
            (Details  detailsEditSpec)
            (Channels   channelsEditSpec)
      )
! !

!UISubSpecification class methodsFor:'queries'!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ false


! !

!UISubSpecification methodsFor:'accessing'!

majorKey
    "get the classname providing the specification; on default my class and
     base classes are serached for the specification
    "
    ^ majorKey
!

majorKey:something
    "set the classname providing the specification; on default my class and
     base classes are serached for the specification
    "
    majorKey := something.
!

minorKey
    "get the selector to be called to access the sub specification
    "
    ^ minorKey
!

minorKey:something
    "set the selector to be called to access the sub specification
    "
    minorKey := something.
! !

!UISubSpecification methodsFor:'building'!

addView:aView toMappingOfBuilder:aBuilder
    "intentionally left blank - we want the embedded spec to be stored in the mapping for the view;
     not my frames-spec"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |spec builder|

    super setAttributesIn:aView with:aBuilder.

    aView isView ifTrue:[
        aView destroySubViews.
    ].
    spec := self specificationFor:aView with:aBuilder.

    spec isNil ifTrue:[
        ^ self
    ].

    aBuilder isEditing ifTrue:[
        builder := aBuilder newSubBuilder.
    ] ifFalse:[
        builder := aBuilder
    ].

    spec := UISpecification from:spec.
    builder buildViewForSpec:spec in:aView.
    spec postCreateView:aView for:builder.

    self useDefaultExtent ifTrue:[
       aView extent:spec window bounds extent.
    ].

"/
"/ before re-enabling this, ask timo or cg;
"/ and in any case make it depending on a flag
"/ (recursiveForceBackground) as done in WindowSpec
"/
"/    aView allViewBackground: 
"/        (aBuilder isEditing 
"/            ifTrue: [
"/                aView class defaultViewBackgroundColor
"/            ] ifFalse: [
"/                aView superView notNil ifTrue:[
"/                    aView superView viewBackground
"/                ] ifFalse: [
"/                    aView class defaultViewBackgroundColor
"/                ]
"/            ]
"/        ).
    aView isView ifTrue:[
        aView realized ifTrue:[
            aView realizeAllSubViews
        ].
    ].
    ^ spec
!

setupInitialLayoutFor:aView

    |layout|

    layout := LayoutOrigin fromPoint:aView bounds origin.
    aView geometryLayout:layout

! !

!UISubSpecification methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    majorKey isNil        ifTrue:[l add:#majorKey].
    initiallyInvisible ~~ true ifTrue:[ l add:#initiallyInvisible ].

    ^l

    "Modified: / 20.6.1998 / 13:41:47 / cg"
! !

!UISubSpecification methodsFor:'private'!

specificationFor:aView with:aBuilder
    "fetch the subSpecification"

    |spec|

    minorKey isNil ifTrue:[
        ^ nil
    ].

    "/ retrieve specifications with the same mechanism than subcanvases
    spec := aBuilder subCanvasAt:majorKey at:minorKey.
    spec isNil ifTrue:[
        minorKey isArray ifTrue:[
            spec := minorKey
        ].
    ].

    ^ spec

    "Created: / 4.2.1998 / 23:13:07 / stefan"
    "Modified: / 5.2.1998 / 12:02:38 / stefan"
! !

!UISubSpecification methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'SubSpecification'

!

viewClass
    "return the corresponding view class of the spec"

    ^ View
! !

!UISubSpecification methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitUISubSpecification:self

    "Created: / 22-08-2011 / 15:40:06 / cg"
! !

!UISubSpecification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UISubSpecification.st,v 1.50 2015-11-19 13:52:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/UISubSpecification.st,v 1.50 2015-11-19 13:52:13 cg Exp $'
! !

