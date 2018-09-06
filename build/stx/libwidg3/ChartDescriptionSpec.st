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

NamedSpec subclass:#ChartDescriptionSpec
	instanceVariableNames:'label1 foregroundColor backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ChartDescriptionSpec class methodsFor:'documentation'!

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

!ChartDescriptionSpec class methodsFor:'interface - painter'!

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
                        foregroundColor
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
      )


! !

!ChartDescriptionSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ChartDescriptionSpec andSelector:#basicsEditSpec
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
                   layout: (AlignmentOrigin 100 0 16 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 5 0 1 1.0 27 0)
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
                   layout: (AlignmentOrigin 100 0 43 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 32 0 1 1.0 54 0)
                   activeHelpKey: chartHolder
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
     UIPainter new openOnClass:ChartDescriptionSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'InputField Details'
         name: 'InputField Details'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 403 148)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'fontColorSubSpec'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 126 0)
             majorKey: UISpecification
             minorKey: fontColorSubSpec
           )
          )
        
       )
     )
! !

!ChartDescriptionSpec methodsFor:'accessing'!

label1
    "return the value of the instance variable 'label1' (automatically generated)"

    ^ label1
!

label1:something
    "set the value of the instance variable 'label1' (automatically generated)"

    label1 := something.
! !

!ChartDescriptionSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
!

foregroundColor
    "return the value of the instance variable 'foregroundColor' (automatically generated)"

    ^ foregroundColor
!

foregroundColor:something
    "set the value of the instance variable 'foregroundColor' (automatically generated)"

    foregroundColor := something.
! !

!ChartDescriptionSpec methodsFor:'building'!

setAttributesIn:newView with:aBuilder
    |cd|

    super setAttributesIn:newView with:aBuilder.

    cd := self getBindingIn:aBuilder binding:model.
    newView model:cd.

    foregroundColor notNil ifTrue:[
        newView foregroundColor:foregroundColor
    ].
    backgroundColor notNil ifTrue:[
        newView backgroundColor:backgroundColor
    ].


! !

!ChartDescriptionSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
! !

!ChartDescriptionSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ChartDescriptionSpec.st,v 1.8 2017-11-28 18:21:31 cg Exp $'
! !

