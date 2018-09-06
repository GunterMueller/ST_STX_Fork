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

NamedSpec subclass:#BarChartWidgetSpec
	instanceVariableNames:'foregroundColor backgroundColor label'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!BarChartWidgetSpec class methodsFor:'documentation'!

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

!BarChartWidgetSpec class methodsFor:'interface - painter'!

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
                        label
                        style
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

!BarChartWidgetSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BarChartWidgetSpec andSelector:#basicsEditSpec
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
         bounds: (Rectangle 0 0 400 143)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0 0 1.0 133 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 23 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 12 0 1 1.0 34 0)
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
                   layout: (AlignmentOrigin 100 0 50 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'modelField'
                   layout: (LayoutFrame 100 0 39 0 1 1.0 61 0)
                   activeHelpKey: chartHolder
                   tabable: true
                   model: model
                   group: inputGroup
                   type: string
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Label:'
                   name: 'Label1'
                   layout: (AlignmentOrigin 100 0 77 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'labelField'
                   layout: (LayoutFrame 100 0 66 0 1 1.0 88 0)
                   activeHelpKey: chartLabel
                   tabable: true
                   model: label
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
     UIPainter new openOnClass:BarChartWidgetSpec andSelector:#detailsEditSpec
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
         bounds: (Rectangle 0 0 400 134)
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
          (LabelSpec
             label: 'Label'
             name: 'Label1'
             layout: (LayoutFrame 15 0 69 0 120 0 91 0)
             translateLabel: true
             adjust: right
           )
          (LabelSpec
             label: 'Value'
             name: 'Label2'
             layout: (LayoutFrame 14 0 98 0 120 0 120 0)
             translateLabel: true
             adjust: right
           )
          )
        
       )
     )
! !

!BarChartWidgetSpec methodsFor:'accessing'!

label
    "return the value of the instance variable 'label' (automatically generated)"

    ^ label
!

label:something
    "set the value of the instance variable 'label' (automatically generated)"

    label := something.
!

style
    "return the value of the instance variable 'style' (automatically generated)"

    ^ style
!

style:something
    "set the value of the instance variable 'style' (automatically generated)"

    style := something.
! !

!BarChartWidgetSpec methodsFor:'accessing-color & font'!

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

!BarChartWidgetSpec methodsFor:'building'!

setAttributesIn:newView with:aBuilder
    |bcw|

    super setAttributesIn:newView with:aBuilder.

    bcw := self getBindingIn:aBuilder binding:model.
    newView model:bcw.
    newView barChartName:label.

    foregroundColor notNil ifTrue:[
        newView foregroundColor:foregroundColor
    ].
    backgroundColor notNil ifTrue:[
        newView backgroundColor:backgroundColor
    ].
    style notNil ifTrue:[
        newView font:(style onDevice:newView device)
    ].

! !

!BarChartWidgetSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
    style notNil ifTrue:[style := style decodeAsLiteralArray].

! !

!BarChartWidgetSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitBarChartWidgetSpec:self

    "Created: / 08-11-2010 / 19:34:47 / cg"
! !

!BarChartWidgetSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChartWidgetSpec.st,v 1.10 2017-11-28 18:21:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChartWidgetSpec.st,v 1.10 2017-11-28 18:21:36 cg Exp $'
! !

