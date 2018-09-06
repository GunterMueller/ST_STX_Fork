"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

NamedSpec subclass:#MeterClackCounterSpec
	instanceVariableNames:'backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MeterClackCounterSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


! !

!MeterClackCounterSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        model
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        backgroundColor
                     )
        to:env 
        for:anInstance 
        channel:aChannel.





!

slices
    "return the slices for the attribute sections in the GUI Painter"
    "each item consists of a label and a window-spec selector"

    ^#(     
        (Basics basicsEditSpec)
        (Details detailsEditSpec)
        (Channels visibilityAndBackgroundChannelEditSpec)
      )           
! !

!MeterClackCounterSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MeterClackCounterSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'UISpecification Basics'
         name: 'UISpecification Basics'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 400 110)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 99 0)
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
                   layout: (LayoutFrame 100 0 6 0 1 1.0 28 0)
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
                   layout: (AlignmentOrigin 100 0 44 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 33 0 1 1.0 55 0)
                   activeHelpKey: id
                   tabable: true
                   model: model
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

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MeterClackCounterSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Details'
         name: 'SequenceView Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 237)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Visual Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 76 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'BG-Color:'
                   name: 'backgroundLabel'
                   layout: (AlignmentOrigin 100 0 22 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (ColorMenuSpec
                   name: 'colorMenuBG'
                   layout: (LayoutFrame 100 0 10 0 2 1.0 32 0)
                   activeHelpKey: backgroundColor
                   model: backgroundColor
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!MeterClackCounterSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
! !

!MeterClackCounterSpec methodsFor:'building'!

setAttributesIn:newView with:aBuilder
    |mc|

    super setAttributesIn:newView with:aBuilder.

    mc := self getBindingIn:aBuilder binding:model.
    newView model:mc.

    backgroundColor notNil ifTrue:[
        newView backgroundColor:backgroundColor
    ].


! !

!MeterClackCounterSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
! !

!MeterClackCounterSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitMeterClackCounterSpec:self
! !

!MeterClackCounterSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/MeterClackCounterSpec.st,v 1.11 2017-11-28 18:21:30 cg Exp $'
! !

