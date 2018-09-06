"{ Encoding: utf8 }"

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

ViewWithSubcomponentsSpec subclass:#ScrollableViewSpec
	instanceVariableNames:'hasHorizontalScrollBar hasVerticalScrollBar
		miniScrollerHorizontal miniScrollerVertical'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ScrollableViewSpec class methodsFor:'documentation'!

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

!ScrollableViewSpec class methodsFor:'interface - painter'!

addBindingsTo:env for:anInstance channel:aChannel 

    super addBindingsTo:env for:anInstance channel:aChannel.

    #(  
        hasHorizontalScrollBar
        hasVerticalScrollBar
        miniScrollerVertical
        miniScrollerHorizontal
    ) do:[:aSymbol|
        env at:aSymbol put:(self adapt:anInstance forAspect:aSymbol channel:aChannel)
    ].

    "Created: 28.2.1997 / 21:50:45 / cg"
    "Modified: 28.2.1997 / 21:52:18 / cg"
! !

!ScrollableViewSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ScrollableViewSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: basicsEditSpec
       window: 
      (WindowSpec
         label: 'ScrollableView Basic'
         name: 'ScrollableView Basic'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 400 168)
       )
       component: 
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Framed Box'
             name: 'FramedBox'
             layout: (LayoutFrame 0 0.0 6 0.0 0 1.0 73 0)
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
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'scrollerSubSpec'
             layout: (LayoutFrame 0 0.0 72 0 0 1.0 166 0)
             majorKey: UISpecification
             minorKey: scrollerSubSpec
           )
          )
        
       )
     )
! !

!ScrollableViewSpec class methodsFor:'parsing a view'!

fromView:aView callBack:aTwoArgCallBackBlock
    |scrolledView specClass spec|

    scrolledView := aView scrolledView.

    "/
    "/ kludge - make it a TextEditorSpec or SequenceViewSpec depending
    "/ on the scrolledViews type.
    "/

    scrolledView notNil ifTrue:[
        ((specClass := scrolledView specClass) ~~ ArbitraryComponentSpec) ifTrue:[
            spec := specClass fromView:scrolledView callBack:aTwoArgCallBackBlock
        ]
    ].

    spec notNil ifTrue:[
        aView isHorizontalScrollable ifTrue:[
           spec hasHorizontalScrollBar:true.
           spec miniScrollerHorizontal:(aView horizontalScrollBar isKindOf:MiniScroller)
        ].
        aView isVerticalScrollable ifTrue:[
            spec hasVerticalScrollBar:true.
            spec miniScrollerVertical:(aView scrollBar isKindOf:MiniScroller).
        ].
        spec layoutFromView:aView.
        ^ spec
    ].

    ^ super fromView:aView callBack:aTwoArgCallBackBlock

    "Modified: 7.4.1997 / 19:15:40 / cg"
! !

!ScrollableViewSpec class methodsFor:'queries'!

canResizeSubComponents
    ^ false

    "Created: 1.3.1997 / 01:41:19 / cg"
!

isLayoutContainer
    ^ true


! !

!ScrollableViewSpec methodsFor:'accessing'!

hasHorizontalScrollBar
    "return the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    ^ hasHorizontalScrollBar ? false

    "Modified: 28.2.1997 / 21:51:32 / cg"
!

hasHorizontalScrollBar:something
    "set the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    hasHorizontalScrollBar := something.
!

hasVerticalScrollBar
    "return the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    ^ hasVerticalScrollBar ? false

    "Modified: 28.2.1997 / 21:51:37 / cg"
!

hasVerticalScrollBar:something
    "set the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    hasVerticalScrollBar := something.
!

miniScrollerHorizontal
    "return the value of the instance variable 'miniScrollerHorizontal' (automatically generated)"

    ^ miniScrollerHorizontal ? false

    "Modified: 28.2.1997 / 21:51:40 / cg"
!

miniScrollerHorizontal:something
    "set the value of the instance variable 'miniScrollerHorizontal' (automatically generated)"

    miniScrollerHorizontal := something.
!

miniScrollerVertical
    "return the value of the instance variable 'miniScrollerVertical' (automatically generated)"

    ^ miniScrollerVertical ? false

    "Modified: 28.2.1997 / 21:51:42 / cg"
!

miniScrollerVertical:something
    "set the value of the instance variable 'miniScrollerVertical' (automatically generated)"

    miniScrollerVertical := something.
! !

!ScrollableViewSpec methodsFor:'building'!

buildComponentFor:aBuilder in:v
    |scrolledViewSpec scrolledView|

    component notNil ifTrue:[
        scrolledViewSpec := component collection first.
        scrolledView := scrolledViewSpec buildViewWithLayoutFor:aBuilder in:nil. 
        v scrolledView:scrolledView
    ].


!

createViewFor:aBuilder in:aView
    "low level create - no attributes are set.
     Can be redefined for special creation (see arbitraryComponentSpec)"

    |cls newView|

    cls := self realViewClassFor:aBuilder.

    newView := cls miniScrollerH:miniScrollerHorizontal miniScrollerV:miniScrollerVertical.
    aView notNil ifTrue:[aView addSubView:newView].
    ^ newView
!

setupInitialLayoutFor:aSubView
    |superView|

    (superView := aSubView superView) removeSubView:aSubView.
    aSubView geometryLayout:nil.
    superView scrolledView:aSubView

    "Modified: 1.3.1997 / 01:49:03 / cg"
! !

!ScrollableViewSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    "redefined to skip flags with default values"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    hasHorizontalScrollBar == false ifTrue:[
        l add:#miniScrollerHorizontal
    ] ifFalse:[
        miniScrollerHorizontal == false ifTrue:[
            l add:#miniScrollerHorizontal
        ].
    ].
    hasVerticalScrollBar == false ifTrue:[
        l add:#miniScrollerVertical
    ] ifFalse:[
        miniScrollerVertical == false ifTrue:[
            l add:#miniScrollerVertical
        ].
    ].

    ^ l

    "Modified (comment): / 09-08-2018 / 17:18:12 / Claus Gittinger"
! !

!ScrollableViewSpec methodsFor:'parsing a view'!

componentFromView:aView callBack:aBlock
    |sub|

    (sub := aView scrolledView) notNil ifTrue:[
        component := SpecCollection new fromViews:(Array with:sub) callBack:aBlock.
        component collection first layout:nil.
    ].
!

fromView:aView callBack:aBlock
    super fromView:aView callBack:aBlock.

    hasHorizontalScrollBar := (aView isMemberOf:HVScrollableView).
    hasVerticalScrollBar := true.

    miniScrollerHorizontal := false.
    hasHorizontalScrollBar ifTrue:[
        miniScrollerHorizontal := aView horizontalScrollBar isKindOf:MiniScroller
    ].

    miniScrollerVertical := false.
    hasVerticalScrollBar ifTrue:[
        miniScrollerVertical := aView scrollBar isKindOf:MiniScroller
    ].

    "Modified: 28.2.1997 / 21:54:21 / cg"
! !

!ScrollableViewSpec methodsFor:'queries'!

defaultModelClassFor:something
    "used by the UIPainters aspectGenerator"

    |subSpec|

    component notNil ifTrue:[
        (subSpec := component collection first) notNil ifTrue:[
            ^ subSpec defaultModelClassFor:something
        ]
    ].
    ^ super defaultModelClassFor:something
!

needsRebuildForAttributes
    ^ true

    "Created: 1.3.1997 / 00:27:15 / cg"
!

viewClass
    hasHorizontalScrollBar ifTrue:[
        ^ HVScrollableView
    ].
    ^ ScrollableView
! !

!ScrollableViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ScrollableViewSpec.st,v 1.26 2018-08-09 15:19:02 cg Exp $'
! !

