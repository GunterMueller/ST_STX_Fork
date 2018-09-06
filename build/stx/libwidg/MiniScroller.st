"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Scroller subclass:#MiniScroller
	instanceVariableNames:''
	classVariableNames:'MiniScrollerSize'
	poolDictionaries:''
	category:'Views-Interactors'
!

!MiniScroller class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    like a scroller, but taking less screen space

    [author:]
	Claus Gittinger
"
! !

!MiniScroller class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'miniScroller.size')>

    MiniScrollerSize := StyleSheet at:'miniScroller.size'.

    "
     self updateStyleCache
    "

    "Created: 15.8.1997 / 01:51:38 / cg"
    "Modified: 20.10.1997 / 15:06:36 / cg"
! !

!MiniScroller methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    |style lvl|

    super initStyle.
    style := StyleSheet name.
    style == #iris ifTrue:[
        tallyLevel := tallyMarks := 0.
        thumbEdgeStyle := nil.
        thumbLevel := thumbActiveLevel := 2.
    ].
    ((style ~~ #normal) and:[style ~~ #mswindows]) ifTrue:[
        style == #st80 ifTrue:[
            lvl := 1.
            "/ lvl := 0.
        ] ifFalse:[
            lvl := -1.
        ].
        self level:lvl.
        self borderWidth:0
    ].
    shadowForm := lightForm := nil.
    fixThumbHeight := false.

    thumbImage := nil.

    "Modified: / 12.5.1998 / 20:41:52 / cg"
! !

!MiniScroller methodsFor:'queries'!

isMiniScroller
    ^ true

    "Created: 7.3.1997 / 16:20:22 / cg"
!

preferredExtent
    "return my preferredExtent - make my width very small"

    |defExt w h mm|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    defExt := self class defaultExtent.

    (mm := MiniScrollerSize) isNil ifTrue:[
        mm := (thumbLevel ~~ 0) ifTrue:[1.8] ifFalse:[1.5].
        mm := (thumbLevel ~~ 0) ifTrue:[2.5] ifFalse:[2].
        styleSheet name == #st80 ifTrue:[
            mm := 2
        ].
    ].

    w := defExt x.
    h := defExt y.

    orientation == #vertical ifTrue:[
        w := (device horizontalPixelPerMillimeter asFloat * mm) rounded.
        "/ don't let it become too small for thumb ...
        w := w max:((level abs + thumbLevel) * 2 + 1).
    ] ifFalse:[
        h := (device verticalPixelPerMillimeter asFloat * mm) rounded.
        "/ don't let it become too small for thumb ...
        h := h max:((level abs + thumbLevel) * 2 + 1).
    ].
    preferredExtent := w @ h.
    ^ preferredExtent.

    "Modified: / 08-10-2007 / 17:24:32 / cg"
! !

!MiniScroller class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

