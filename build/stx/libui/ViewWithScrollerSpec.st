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

MenuComponentSpec subclass:#ViewWithScrollerSpec
	instanceVariableNames:'hasHorizontalScrollBar hasVerticalScrollBar
		miniScrollerHorizontal miniScrollerVertical foregroundColor
		backgroundColor autoHideScrollBars'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ViewWithScrollerSpec class methodsFor:'documentation'!

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
    specification used only for internal purposes.
    each specification providing scrollers will
    derive from this class

    Not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"



! !

!ViewWithScrollerSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        foregroundColor
                        backgroundColor
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        menuSelector
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    self addScrollBarBindingsTo:env for:inst channel:aChannel.

! !

!ViewWithScrollerSpec methodsFor:'accessing'!

autoHideScrollBars
    "return the value of the instance variable 'autoHideScrollBars' (automatically generated)"

    ^ autoHideScrollBars


!

autoHideScrollBars:aBooleanOrNil
    "set the value of the instance variable 'autoHideScrollBars' (automatically generated)"

    autoHideScrollBars := aBooleanOrNil.


!

hasHorizontalScrollBar
    "return the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    ^ hasHorizontalScrollBar ? false


!

hasHorizontalScrollBar:something
    "set the value of the instance variable 'hasHorizontalScrollBar' (automatically generated)"

    hasHorizontalScrollBar := something.


!

hasVerticalScrollBar
    "return the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    ^ hasVerticalScrollBar ? false


!

hasVerticalScrollBar:something
    "set the value of the instance variable 'hasVerticalScrollBar' (automatically generated)"

    hasVerticalScrollBar := something.


!

miniScrollerHorizontal
    hasHorizontalScrollBar ~~ true ifTrue:[^ false].
    ^ miniScrollerHorizontal ? false
!

miniScrollerHorizontal:something
    "set the value of the instance variable 'miniScrollerHorizontal' (automatically generated)"

    miniScrollerHorizontal := something.
!

miniScrollerVertical
    hasVerticalScrollBar ~~ true ifTrue:[^ false].
    ^ miniScrollerVertical ? false
!

miniScrollerVertical:something
    "set the value of the instance variable 'miniScrollerVertical' (automatically generated)"

    miniScrollerVertical := something.
! !

!ViewWithScrollerSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return backgroundColor"

    ^ backgroundColor
!

backgroundColor: aColor
    "set backgroundColor"

    backgroundColor := aColor

!

foregroundColor
    "return foregroundColor"

    ^ foregroundColor

!

foregroundColor: aColor
    "set foregroundColor"

    foregroundColor := aColor

! !

!ViewWithScrollerSpec methodsFor:'building'!

createScrollableViewFor:aBuilder in:aView
    "helper for some textViews"

    |embeddedView newView|

    embeddedView := self basicCreateViewFor:aBuilder in:nil.

    "/ hack for codeView2, which behaves like a TextView, but has its own
    "/ scrollbars embedded - sigh (an extra load one)
    embeddedView hasOwnScrollbars ifTrue:[
        hasHorizontalScrollBar := hasVerticalScrollBar := false.
    ].
    newView := ScrollableView
        forView:embeddedView
        hasHorizontalScrollBar:(self hasHorizontalScrollBar)
        hasVerticalScrollBar:(self hasVerticalScrollBar)
        miniScrollerH:(self miniScrollerHorizontal) 
        miniScrollerV:(self miniScrollerVertical).

    aView notNil ifTrue:[aView addSubView:newView].
    ^ newView
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |hasScrollBar|

    super setAttributesIn:aView with:aBuilder.

    self isScrollable ifTrue:[
        (hasScrollBar := self hasHorizontalScrollBar) ifTrue:[
            aView horizontalScrollable:true.
            aView horizontalMini:(self miniScrollerHorizontal).
        ] ifFalse:[
            aView horizontalScrollable:false
        ].

        self hasVerticalScrollBar ifTrue:[
            aView verticalScrollable:true.
            aView verticalMini:(self miniScrollerVertical).
            hasScrollBar := true.
        ] ifFalse:[
            aView verticalScrollable:false
        ].

        hasScrollBar ifTrue:[
            autoHideScrollBars notNil ifTrue:[
                aView autoHideScrollBars:autoHideScrollBars
            ].
        ].
    ].
    self setColorAttributesIn:aView with:aBuilder.
!

setColorAttributesIn:aView with:aBuilder
    "apply my color attributes to aView"

    |realView color|

    (aView respondsTo: #scrolledView) ifTrue: [
        realView := aView scrolledView
    ] ifFalse:[
        realView := aView.
    ].
    foregroundColor notNil ifTrue:[
        color := self resolveColor:foregroundColor ifUnknown:[Color red] with:aBuilder.
        realView foregroundColor:color.
    ].
    backgroundColor notNil ifTrue:[
        color := self resolveColor:backgroundColor ifUnknown:[Color yellow] with:aBuilder.
        realView backgroundColor:color.
    ].
!

setTabable:aView with:aBuilder
    |subView|

    "/ kludge for web-building
    subView := aView perform:#scrolledView ifNotUnderstood:aView.
"/    subView := aView scrolledView.
    subView notNil ifTrue:[
        aBuilder makeTabable:subView
    ].

    "Created: / 05-08-1997 / 18:39:00 / cg"
    "Modified: / 15-01-2008 / 11:25:01 / cg"
! !

!ViewWithScrollerSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].

!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l hasScroller|

    l := super skippedInLiteralEncoding asOrderedCollection.

    hasHorizontalScrollBar isNil ifTrue:[
        l add:#hasHorizontalScrollBar.
        l add:#miniScrollerHorizontal.
    ] ifFalse:[
        miniScrollerHorizontal isNil ifTrue:[
            l add:#miniScrollerHorizontal
        ].
    ].

    hasVerticalScrollBar isNil ifTrue:[
        l add:#hasVerticalScrollBar.
        l add:#miniScrollerVertical.
    ] ifFalse:[
        miniScrollerVertical isNil ifTrue:[
            l add:#miniScrollerVertical
        ].
    ].

    autoHideScrollBars isNil ifTrue:[l add:#autoHideScrollBars].
    foregroundColor   isNil ifTrue:[ l add:#foregroundColor ].
    backgroundColor   isNil ifTrue:[ l add:#backgroundColor ].

  ^ l

    "Modified: / 20.6.1998 / 13:41:58 / cg"
! !

!ViewWithScrollerSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    (aView respondsTo:#isHorizontalScrollable) ifTrue:[
        hasHorizontalScrollBar := aView isHorizontalScrollable.
        hasVerticalScrollBar   := aView isVerticalScrollable.
    ].
    super fromView:aView callBack:aBlock.

    foregroundColor := aView foreground.
    backgroundColor := aView background.
! !

!ViewWithScrollerSpec methodsFor:'queries'!

isScrollable
    ^ true
! !

!ViewWithScrollerSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ViewWithScrollerSpec.st,v 1.34 2017-11-28 18:21:41 cg Exp $'
! !

