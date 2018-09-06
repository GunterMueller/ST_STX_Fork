"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

VisualPart subclass:#Morph
	instanceVariableNames:'foregroundColor backgroundColor line lineColor lineWidth
		lineStyle fill foregroundColorHolder backgroundColorHolder
		lineColorHolder lineWidthHolder lineStyleHolder fillHolder
		lineHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Display Objects'
!

!Morph class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
    |v m1 m2|

    v := View new extent:200@200.
    v addComponent:(m1 := RectangleMorph new).
    m1 origin:100@100.
    m1 extent:50@50.
    m1 foregroundColor:(Color red).
    m1 fill:true.

    v addComponent:(m2 := SketchMorph new).
    m2 origin:50@50.
    m2 image:((Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') magnifiedTo:50@50).
    v open.
"
! !

!Morph methodsFor:'accessing'!

backgroundColor
    ^ backgroundColorHolder value ? backgroundColor
!

backgroundColor:something
    backgroundColor ~= something ifTrue:[
        backgroundColor := something.
        self invalidate.
    ].
!

backgroundColorHolder
    ^ backgroundColorHolder
!

backgroundColorHolder:something
    backgroundColorHolder removeDependent:self.
    backgroundColorHolder := something.
    backgroundColorHolder notNil ifTrue:[ backgroundColorHolder addDependent:self].
!

fill
    ^ fillHolder value ? fill ? false
!

fill:aBoolean
    fill ~= aBoolean ifTrue:[
        fill := aBoolean.
        self invalidate.
    ].
!

fillHolder
    ^ fillHolder
!

fillHolder:something
    fillHolder removeDependent:self.
    fillHolder := something.
    fillHolder notNil ifTrue:[ fillHolder addDependent:self].
!

foregroundColor
    ^ foregroundColorHolder value ? foregroundColor
!

foregroundColor:something
    foregroundColor ~= something ifTrue:[
        foregroundColor := something.
        self invalidate.
    ].
!

foregroundColorHolder
    ^ foregroundColorHolder
!

foregroundColorHolder:something
    foregroundColorHolder removeDependent:self.
    foregroundColorHolder := something.
    foregroundColorHolder notNil ifTrue:[ foregroundColorHolder addDependent:self].
!

line
    ^ lineHolder value ? line ? false
!

line:aBoolean
    line ~= aBoolean ifTrue:[
        line := aBoolean.
        self invalidate.
    ].
!

lineColor
    ^ lineColorHolder value ? lineColor
!

lineColor:something
    lineColor ~= something ifTrue:[
        lineColor := something.
        self invalidate.
    ].
!

lineColorHolder
    ^ lineColorHolder
!

lineColorHolder:something
    lineColorHolder removeDependent:self.
    lineColorHolder := something.
    lineColorHolder notNil ifTrue:[ lineColorHolder addDependent:self].
!

lineHolder
    ^ lineHolder
!

lineHolder:something
    lineHolder removeDependent:self.
    lineHolder := something.
    lineHolder notNil ifTrue:[ lineHolder addDependent:self].
!

lineStyle
    ^ lineStyleHolder value ? lineStyle ? #solid
!

lineStyle:aSymbol
    lineStyle ~= aSymbol ifTrue:[
        lineStyle := aSymbol.
        self invalidate.
    ].
!

lineStyleHolder
    ^ lineStyleHolder
!

lineStyleHolder:something
    lineStyleHolder removeDependent:self.
    lineStyleHolder := something.
    lineStyleHolder notNil ifTrue:[ lineStyleHolder addDependent:self].
!

lineWidth
    ^ lineWidthHolder value ? lineWidth ? 0
!

lineWidth:anInteger
    lineWidth ~= anInteger ifTrue:[
        lineWidth := anInteger.
        self invalidate.
    ].
!

lineWidthHolder
    ^ lineWidthHolder
!

lineWidthHolder:something
    lineWidthHolder removeDependent:self.
    lineWidthHolder := something.
    lineWidthHolder notNil ifTrue:[ lineWidthHolder addDependent:self].
!

setBackgroundColor:something
    backgroundColor := something.
!

setFill:aBoolean
    fill := aBoolean.
!

setForegroundColor:something
    foregroundColor := something.
!

setLineColor:something
    lineColor := something.
!

setLineStyle:something
    lineStyle := something.
!

setLineWidth:something
    lineWidth := something.
! !

!Morph methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "/ invalidate is always ok - however, it will redraw bg, fg and line
    "/ and therefore may produce flicker (unless double buffering)

    "/ container clearRectangle:(self frame).
    self invalidate.

    super update:something with:aParameter from:changedObject
! !

!Morph methodsFor:'drawing'!

displayBackgroundOn:aGC
    |bg|

    bg := backgroundColorHolder value ? backgroundColor.
    bg notNil ifTrue:[
        aGC paint:bg.
        aGC fillRectangle:frame.
    ].
!

displayInsideOn:aGC
    self subclassResponsibility
!

displayOn:aGC 
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    (aGC isStream or:[aGC == Transcript]) ifTrue:[
        self printOn:aGC.
        ^ self
    ].

    (visibilityHolder value ? true) ifFalse:[ ^ self ].

    self displayBackgroundOn:aGC.
    self displayInsideOn:aGC.
    self displayOutsideOn:aGC.

    "Modified (comment): / 22-02-2017 / 16:53:42 / cg"
!

displayOutsideOn:aGC
    self subclassResponsibility
! !

!Morph methodsFor:'queries'!

specClass
    "fallback - heuristics to get a specClass for some morphClass.
     Based upon my className, look for a corresponding Spec-class."

    |myClass myName cls|

    myClass := self class.

    "/ try: appending 'Spec' to my classes name

    myName := self class name.
    cls := Smalltalk classNamed:(myName , 'Spec').
    cls notNil ifTrue:[
        cls := cls autoload.
        (cls isSubclassOf:UISpecification) ifTrue:[^ cls].
    ].

    "/ fall back for all others
    ^ MorphSpec ? DisplayObjectComponentSpec

    "
     ArcMorph new specClass
     Morph new specClass
    "
! !

!Morph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/Morph.st,v 1.14 2017-02-22 17:58:29 cg Exp $'
! !

