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

ScrollerSpec subclass:#SliderSpec
	instanceVariableNames:'keyboardStep'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SliderSpec class methodsFor:'documentation'!

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

!SliderSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SliderSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'Scroller Basics'
         name: 'Scroller Basics'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 400 220)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 226 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 12 0 1 0.5)
                   activeHelpKey: id
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 0 0 5 1.0 22 0)
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
                   layout: (AlignmentOrigin 100 0 37 0 1 0.5)
                   activeHelpKey: model
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 26 0 -15 1 48 0)
                   activeHelpKey: model
                   tabable: true
                   model: model
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   comboList: listOfAspects
                 )
                (ActionButtonSpec
                   label: 'browseActionImage'
                   name: 'Button1'
                   layout: (LayoutFrame -15 1 27 0 5 1 49 0)
                   activeHelpKey: browseAspectMethod
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: doBrowseAspectMethod:
                   actionValue: model
                 )
                (LabelSpec
                   label: 'Min:'
                   name: 'minLabel'
                   layout: (AlignmentOrigin 100 0 63 0 1 0.5)
                   activeHelpKey: start
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'minField'
                   layout: (LayoutFrame 100 0 52 0 5 1 74 0)
                   activeHelpKey: start
                   tabable: true
                   model: start
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Max:'
                   name: 'maxLabel'
                   layout: (AlignmentOrigin 100 0 89 0 1 0.5)
                   activeHelpKey: stop
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'maxField'
                   layout: (LayoutFrame 100 0 78 0 5 1 100 0)
                   activeHelpKey: stop
                   tabable: true
                   model: stop
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Step:'
                   name: 'stepLabel'
                   layout: (AlignmentOrigin 100 0 115 0 1 0.5)
                   activeHelpKey: step
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'stepField'
                   layout: (LayoutFrame 100 0 104 0 5 1 127 0)
                   activeHelpKey: step
                   tabable: true
                   model: step
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'KbdStep:'
                   name: 'keyStepLabel'
                   layout: (AlignmentOrigin 100 0 142 0 1 0.5)
                   activeHelpKey: keyboardStep
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'keyboardStepField'
                   layout: (LayoutFrame 100 0 131 0 5 1 154 0)
                   activeHelpKey: keyboardStep
                   tabable: true
                   model: keyboardStep
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Orientation:'
                   name: 'orientationLabel'
                   layout: (AlignmentOrigin 100 0 170 0 1 0.5)
                   activeHelpKey: orientation
                   translateLabel: true
                   resizeForLabel: true
                 )
                (PopUpListSpec
                   label: 'orientation'
                   name: 'orientationPopUpList'
                   layout: (LayoutFrame 100 0 158 0 5 1.0 182 0)
                   activeHelpKey: orientation
                   translateLabel: true
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
! !

!SliderSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        keyboardStep
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#numberOrNil.


! !

!SliderSpec methodsFor:'accessing'!

keyboardStep
    "return the value of the instance variable 'keyboardStep' (automatically generated)"

    ^ keyboardStep
!

keyboardStep:something
    "set the value of the instance variable 'keyboardStep' (automatically generated)"

    keyboardStep := something.
! !

!SliderSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    keyboardStep notNil ifTrue:[
        aView keyboardStep:keyboardStep
    ].


! !

!SliderSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    keyboardStep isNil ifTrue:[l add:#keyboardStep].
    ^ l
! !

!SliderSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    keyboardStep := aView keyboardStep.
    super fromView:aView callBack:aBlock


! !

!SliderSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SliderSpec.st,v 1.33 2015-11-19 13:53:01 cg Exp $'
! !

