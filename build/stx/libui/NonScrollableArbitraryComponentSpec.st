"
 COPYRIGHT (c) 2004 by eXept Software AG
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

ArbitraryComponentSpec subclass:#NonScrollableArbitraryComponentSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!NonScrollableArbitraryComponentSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!NonScrollableArbitraryComponentSpec class methodsFor:'interface-painter'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NonScrollableArbitraryComponentSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'ArbitraryComponent Basics'
          name: 'ArbitraryComponent Basics'
          min: (Point 10 10)
          max: (Point 1280 1024)
          bounds: (Rectangle 0 0 400 335)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'idModelWindowBoxSubSpec'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 110 0)
              majorKey: ArbitraryComponentSpec
              minorKey: idModelWindowBoxSpec
            )
           (UISubSpecification
              name: 'menuSubSpec'
              layout: (LayoutFrame 0 0.0 110 0 0 1.0 225 0)
              majorKey: UISpecification
              minorKey: menuSubSpec
            )
           )
         
        )
      )
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:ArbitraryComponentSpec

    "Modified (comment): / 05-09-2012 / 19:27:07 / cg"
!

xchannelsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NonScrollableArbitraryComponentSpec andSelector:#xchannelsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: xchannelsEditSpec
       window: 
      (WindowSpec
         label: 'NamedSpec Channels'
         name: 'NamedSpec Channels'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 400 178)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Channels'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 104 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Enable:'
                   name: 'enableLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   activeHelpKey: enableChannel
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'enableField'
                   layout: (LayoutFrame 100 0 9 0 4 1 31 0)
                   activeHelpKey: enableChannel
                   tabable: true
                   model: enableChannel
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Visible:'
                   name: 'visibleLabel'
                   layout: (AlignmentOrigin 100 0 46 0 1 0.5)
                   activeHelpKey: visibilityChannel
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'visibleField'
                   layout: (LayoutFrame 100 0 35 0 4 1 57 0)
                   activeHelpKey: visibilityChannel
                   tabable: true
                   model: visibilityChannel
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'CallBacks'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 105 0 0 1.0 170 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (UISubSpecification
                   name: 'SubSpecification1'
                   layout: (LayoutFrame 0 0.0 0 0.0 4 1.0 30 0)
                   majorKey: UISpecification
                   minorKey: subSpecForPostBuildCallBack
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!NonScrollableArbitraryComponentSpec methodsFor:'building'!

createViewFor:aBuilder in:aView
    |newView cls|

    "/ try hard to get some view (Q: too hard ??)

    (component notNil) ifTrue:[
        cls := Smalltalk resolveName:component inClass:self class.
        cls notNil ifTrue:[
            newView := cls new
        ] ifFalse:[
            newView := aBuilder componentFor:component.
            newView isNil ifTrue:[
                newView := aBuilder aspectFor:component.
            ].
            newView isNil ifTrue:[
                cls := self resolveName:component in:aBuilder.
                cls isNil ifTrue:[
                    aBuilder isEditing ifFalse:[
                        Transcript showCR:'Cannot resolve view: ',component.
                        self halt:'Cannot resolve view: ',component.
                    ].
                    cls := View
                ].
                newView := cls new
            ].
        ].
    ].
    newView isValueModel ifTrue:[
        newView := newView value.
    ].
    newView isNil ifTrue:[
        newView := View new.
    ].
    aView addSubView:newView.
    ^ newView
!

setTabable:aView with:aBuilder
    aView notNil ifTrue:[
        aBuilder makeTabable:aView
    ].
! !

!NonScrollableArbitraryComponentSpec methodsFor:'queries'!

isScrollable
    ^ false
! !

!NonScrollableArbitraryComponentSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/NonScrollableArbitraryComponentSpec.st,v 1.19 2015-11-19 13:51:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/NonScrollableArbitraryComponentSpec.st,v 1.19 2015-11-19 13:51:42 cg Exp $'
! !

