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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewWithScrollerSpec subclass:#ListModelViewSpec
	instanceVariableNames:'listModel hasKeyboardFocusInitially'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ListModelViewSpec class methodsFor:'documentation'!

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

!ListModelViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ListModelViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'SequenceView Basics'
         name: 'SequenceView Basics'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 386 323)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Basic Attributes'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 101 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'ID:'
                   name: 'nameLabel'
                   layout: (AlignmentOrigin 100 0 20 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'nameField'
                   layout: (LayoutFrame 100 0 9 0 5 1.0 31 0)
                   activeHelpKey: id
                   tabable: true
                   model: name
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'List:'
                   name: 'listLabel'
                   layout: (AlignmentOrigin 100 0 49 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'listField'
                   layout: (LayoutFrame 100 0.0 38 0 4 1.0 60 0)
                   activeHelpKey: listHolder
                   tabable: true
                   model: listModel
                   group: inputGroup
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'menuSubSpec'
             layout: (LayoutFrame 0 0.0 102 0 0 1.0 217 0)
             majorKey: UISpecification
             minorKey: menuSubSpec
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 221 0 0 1.0 324 0)
             majorKey: UISpecification
             minorKey: scrollerSubSpec
           )
          )
        
       )
     )
!

details2EditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ListModelViewSpec andSelector:#details2EditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: details2EditSpec
       window: 
      (WindowSpec
         label: 'ListDetails2'
         name: 'ListDetails2'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 428 169)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'detailsInitSubSpec'
             layout: (LayoutFrame 0 0.0 7 0 0 1.0 83 0)
             majorKey: UISpecification
             minorKey: detailsInitSubSpec
           )
          (FramedBoxSpec
             label: 'Keyboard Attributes'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 79 0 0 1.0 166 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Can Tab'
                   name: 'tabableCheckBox'
                   layout: (Point 10 -1)
                   activeHelpKey: tabable
                   tabable: true
                   model: tabable
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Has Initial Focus'
                   name: 'hasInitialFocusCheckBox'
                   layout: (LayoutFrame 10 0 26 0 175 0 53 0)
                   activeHelpKey: hasKeyboardFocusInitially
                   tabable: true
                   model: hasKeyboardFocusInitially
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
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ListModelViewSpec andSelector:#detailsEditSpec
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
          bounds: (Rectangle 14 46 408 216)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'detailsInitSubSpec'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 161 0)
              majorKey: UISpecification
              minorKey: fontColorBorderSubSpec
            )
           )
         
        )
      )
! !

!ListModelViewSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self
        adaptApects:
                    #(
                        hasKeyboardFocusInitially
                     )
        to:env
        for:inst
        channel:aChannel.

    self 
        adaptApects:#( 
                        listModel 
                    )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:DataSetSpec
        with:HierarchicalListViewSpec

    "Modified (comment): / 05-09-2012 / 19:27:04 / cg"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^ #(
            (Basics             basicsEditSpec)
            (Details1           detailsEditSpec)
            (Details2           details2EditSpec)
       )
! !

!ListModelViewSpec methodsFor:'accessing'!

hasKeyboardFocusInitially
    ^ hasKeyboardFocusInitially ? false
!

hasKeyboardFocusInitially:aBoolean
    hasKeyboardFocusInitially := aBoolean.
!

listModel
    "return the value of the instance variable 'listModel' (automatically generated)"

    ^ listModel

!

listModel:something
    "set the value of the instance variable 'listModel' (automatically generated)"

    listModel := something.

! !

!ListModelViewSpec methodsFor:'building'!

createViewFor:aBuilder in:aView
    "low level create - no attributes are set."

    ^ self createScrollableViewFor:aBuilder in:aView
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"
    |model|

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        model := self getBindingIn:aBuilder binding:(self listModel).

        model notNil ifTrue:[
            model isValueModel ifTrue:[aView listHolder:model]
                              ifFalse:[aView list:model]
        ].
        self setMenuIn:aView with:aBuilder.
    ].

! !

!ListModelViewSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    "/in ST-80, the default is true

    hasHorizontalScrollBar isNil ifTrue:[
        hasHorizontalScrollBar := true.
        miniScrollerHorizontal := true.
    ].
    hasVerticalScrollBar isNil ifTrue:[
        hasVerticalScrollBar := true
    ].


!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    listModel isNil ifTrue:[ l add:#listModel].
    hasKeyboardFocusInitially ~~ true   ifTrue:[l add:#hasKeyboardFocusInitially].
    ^ l
! !

!ListModelViewSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    super fromView:aView callBack:aBlock



! !

!ListModelViewSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^ self viewClass name

! !

!ListModelViewSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    listModel notNil ifTrue:[more add:listModel].
    ^ more

    "Modified: / 10.2.2000 / 01:24:57 / cg"
!

defaultModelClassFor:someAspect
    "used by the UIPainters aspectGenerator
    "
    ^ someAspect == listModel ifTrue:[List]
                             ifFalse:[super defaultModelClassFor:someAspect]


! !

!ListModelViewSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitListModelViewSpec:self
! !

!ListModelViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ListModelViewSpec.st,v 1.20 2015-11-19 13:50:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ListModelViewSpec.st,v 1.20 2015-11-19 13:50:55 cg Exp $'
! !

