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

NoteBookViewSpec subclass:#UIGalleryViewSpec
	instanceVariableNames:'majorKey minorKeys clientSpec raiseMenu'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!UIGalleryViewSpec class methodsFor:'documentation'!

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

!UIGalleryViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIGalleryViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Gallery Basics'
         name: 'Gallery Basics'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 241)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 123 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 17 0 1 0.5)
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
                   label: 'Model:'
                   name: 'modelLabel'
                   layout: (AlignmentOrigin 100 0 42 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 31 0 5 1.0 53 0)
                   activeHelpKey: galleryModel
                   tabable: true
                   model: model
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Labels:'
                   name: 'labelsLabel'
                   layout: (AlignmentOrigin 100 0 67 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'labelsField'
                   layout: (LayoutFrame 100 0 56 0 5 1 78 0)
                   activeHelpKey: tabLabels
                   tabable: true
                   model: menu
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Window Specifications'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 122 0 0 1.0 239 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'From Class:'
                   name: 'fromClassLabel'
                   layout: (AlignmentOrigin 100 0 19 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'classField'
                   layout: (LayoutFrame 100 0 8 0 5 1 30 0)
                   activeHelpKey: majorKey
                   tabable: true
                   model: majorKey
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Selector List:'
                   name: 'selectorListLabel'
                   layout: (AlignmentOrigin 100 0 44 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'minorKeysField'
                   layout: (LayoutFrame 100 0 33 0 5 1 55 0)
                   activeHelpKey: gallerySelectors
                   tabable: true
                   model: minorKeys
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Select. Spec:'
                   name: 'selectionLabel'
                   layout: (AlignmentOrigin 100 0 69 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'selectionField'
                   layout: (LayoutFrame 100 0 58 0 5 1 80 0)
                   activeHelpKey: gallerySelection
                   tabable: true
                   model: clientSpec
                   group: inputGroup
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

channelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIGalleryViewSpec andSelector:#channelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: channelsEditSpec
       window: 
      (WindowSpec
         label: 'Gallery Misc'
         name: 'Gallery Misc'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 397 307)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 102 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification2'
                   layout: (LayoutFrame 0 0.0 7 0.0 4 1.0 32 0)
                   majorKey: UISpecification
                   minorKey: subSpecForVisibilityChannel
                 )
                (UISubSpecification
                   name: 'SubSpecification3'
                   layout: (LayoutFrame 0 0.0 34 0.0 4 1.0 59 0)
                   majorKey: UISpecification
                   minorKey: subSpecForEnableChannel
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 101 0 0 1.0 260 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 57 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                (LabelSpec
                   label: 'Select Condition:'
                   name: 'selectConditionLabel'
                   layout: (AlignmentOrigin 200 0 78 0 1 0.5)
                   activeHelpKey: selectConditionSelector
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'selectConditionField'
                   layout: (LayoutFrame 200 0 65 0 5 1 87 0)
                   activeHelpKey: selectConditionSelector
                   tabable: true
                   model: selectConditionBlock
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Middle Button Pressed:'
                   name: 'pressedLabel'
                   layout: (AlignmentOrigin 200 0 105 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'pressedField'
                   layout: (LayoutFrame 200 0 93 0 5 1 115 0)
                   activeHelpKey: middleButtonPressed
                   tabable: true
                   model: raiseMenu
                   group: inputGroup
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
! !

!UIGalleryViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:#(
                        majorKey
                        minorKeys
                        clientSpec
                        raiseMenu
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 26.10.1997 / 03:22:04 / cg"
! !

!UIGalleryViewSpec methodsFor:'accessing'!

clientSpec
    "return the value of the instance variable 'clientSpec' (automatically generated)"

    ^ clientSpec
!

clientSpec:something
    "set the value of the instance variable 'clientSpec' (automatically generated)"

    clientSpec := something.
!

majorKey
    "return the value of the instance variable 'majorKey' (automatically generated)"

    ^ majorKey
!

majorKey:something
    "set the value of the instance variable 'majorKey' (automatically generated)"

    majorKey := something.
!

minorKeys
    "return the value of the instance variable 'minorKeys' (automatically generated)"

    ^ minorKeys
!

minorKeys:something
    "set the value of the instance variable 'minorKeys' (automatically generated)"

    minorKeys := something.
!

raiseMenu
    "return the value of the instance variable 'raiseMenu' (automatically generated)"

    ^ raiseMenu
!

raiseMenu:something
    "set the value of the instance variable 'raiseMenu' (automatically generated)"

    raiseMenu := something.
! !

!UIGalleryViewSpec methodsFor:'building'!

setAttributesIn:aGallery with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aGallery with:aBuilder.

    aBuilder isEditing ifFalse:[
        aGallery majorKey:majorKey.
        aGallery minorKeysHolder:(self getBindingIn:aBuilder binding:minorKeys).
        aGallery clientSpecHolder:(self getBindingIn:aBuilder binding:clientSpec).
        aGallery menuSelector:raiseMenu.
    ]
! !

!UIGalleryViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    majorKey   isNil ifTrue:[l add:#majorKey].
    minorKeys  isNil ifTrue:[l add:#minorKeys].
    clientSpec isNil ifTrue:[l add:#clientSpec].
    raiseMenu  isNil ifTrue:[l add:#raiseMenu].

  ^ l

    "Modified: / 20.6.1998 / 13:41:40 / cg"
! !

!UIGalleryViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'Gallery'

! !

!UIGalleryViewSpec methodsFor:'queries-UIDefiner'!

actionSelectors
    "add more action selectors (these generate callBack stub methods in the definer)"

    |more|

    more := super actionSelectors.
    raiseMenu notNil ifTrue:[more add:raiseMenu].
    ^ more

    "Modified: / 10.2.2000 / 01:26:11 / cg"
!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    minorKeys  notNil ifTrue:[more add:minorKeys].
    clientSpec notNil ifTrue:[more add:clientSpec].

    ^ more

    "Modified: / 10.2.2000 / 01:24:28 / cg"
! !

!UIGalleryViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UIGalleryViewSpec.st,v 1.34 2015-11-19 13:51:59 cg Exp $'
! !

