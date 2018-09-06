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

ViewWithSubcomponentsSpec subclass:#ViewSpec
	instanceVariableNames:'backgroundColor model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ViewSpec class methodsFor:'documentation'!

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

!ViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    ^ self basicsEditSpecWithModelAndViewClass
!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ViewSpec andSelector:#detailsEditSpec
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
         bounds: (Rectangle 0 0 400 171)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 103 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'bgColorLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: backgroundColor
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenu'
                   layout: (LayoutFrame 100 0 8 0 5 1.0 30 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                   allowSymbolicColors: true
                 )
                (LabelSpec
                   label: 'Border:'
                   name: 'borderLabel'
                   layout: (AlignmentOrigin 100 0 50 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'borderWidthField'
                   layout: (LayoutFrame 100 0 39 0 140 0 61 0)
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
                   layout: (AlignmentOrigin 208 0 50 0 1 0.5)
                   activeHelpKey: level
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'levelField'
                   layout: (LayoutFrame 210 0 39 0 250 0 61 0)
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
          (UISubSpecification
             name: 'SubSpecification2'
             layout: (LayoutFrame 1 0 101 0.0 0 1.0 165 0)
             majorKey: ViewSpec
             minorKey: initiallyVisibleSpec
           )
          )
        
       )
     )
!

initiallyVisibleSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ViewSpec andSelector:#initiallyVisibleSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: initiallyVisibleSpec
       window: 
      (WindowSpec
         label: 'View Details'
         name: 'View Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 65)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Init Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 68 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Initially Invisible'
                   name: 'initiallyInvisibleCheckBox'
                   layout: (Point 15 2)
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

!ViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        model
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        backgroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:VerticalPanelViewSpec
        with:HorizontalPanelViewSpec
        with:PanelViewSpec 
        with:VariableVerticalPanelSpec
        with:VariableHorizontalPanelSpec

    "Created: / 13-01-2008 / 00:01:45 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics     basicsEditSpec)
            (Details    detailsEditSpec)
            (Channels   channelsEditSpec)
       )

! !

!ViewSpec methodsFor:'accessing'!

model
    "return the value of the instance variable 'model' (automatically generated)"

    ^ model
!

model:something
    "set the value of the instance variable 'model' (automatically generated)"

    model := something.
!

setModel:aModel
    model := aModel


! !

!ViewSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
! !

!ViewSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    "have to set fixed colors before the channels"
    self setViewBackgroundAttribute:backgroundColor in:aView with:aBuilder.
    model notNil ifTrue:[
        aBuilder isEditing ifFalse:[
            aView model:(self modelInBuilder:aBuilder).
        ]
    ].
    super setAttributesIn:aView with:aBuilder.

    "Modified (comment): / 29-12-2011 / 13:53:27 / cg"
! !

!ViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    backgroundColor isNil ifTrue:[l add:#backgroundColor].

    ^l

! !

!ViewSpec methodsFor:'parsing a view'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    backgroundColor := aView viewBackground.
    backgroundColor = View defaultViewBackgroundColor ifTrue:[
        backgroundColor := nil
    ].
    super fromView:aView callBack:aBlock

! !

!ViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Box'




! !

!ViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitViewSpec:self
! !

!ViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ViewSpec.st,v 1.43 2017-11-28 18:21:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ViewSpec.st,v 1.43 2017-11-28 18:21:51 cg Exp $'
! !

