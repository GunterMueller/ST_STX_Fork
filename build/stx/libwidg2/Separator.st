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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#Separator
	instanceVariableNames:'orientation'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!Separator class methodsFor:'documentation'!

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
    a simple widget for a separating line. 
    To be placed between groups of other widgets.

    See examples.

    [See also:] 
        FramedBox VariableVerticalPanel VariableHorizontalPanel

    [author:]
        Claus Gittinger
"
!

examples
"
  a separator between two button-panels:
                                                                        [exBegin]
    |top p1 p2 sep|

    top := StandardSystemView new.
    top extent:300@300.

    p1 := VerticalPanelView origin:0.0@0.0 corner:1.0@0.5 in:top.
    p1 bottomInset:5; borderWidth:0.
    p2 := VerticalPanelView origin:0.0@0.5 corner:1.0@1.0 in:top.
    p2 topInset:5; borderWidth:0.

    (Button label:'one' in:p1) width:0.2.
    (Button label:'two' in:p1) width:0.2.
    (Button label:'three' in:p1) width:0.2.

    sep := Separator in:top.
    sep orientation:#horizontal.
    sep origin:0.0@0.5 extent:1.0@10.
    sep topInset:-5; bottomInset:-5.

    (Button label:'four' in:p2) width:0.2.
    (Button label:'five' in:p2) width:0.2.
    (Button label:'six' in:p2) width:0.2.

    top open
                                                                        [exEnd]


  vertical:
                                                                        [exBegin]
    |top p1 p2 sep|

    top := StandardSystemView new.
    top extent:300@300.

    p1 := VerticalPanelView origin:0.0@0.0 corner:0.5@1.0 in:top.
    p1 rightInset:5; borderWidth:0.
    p2 := VerticalPanelView origin:0.5@0.0 corner:1.0@1.0 in:top.
    p2 leftInset:5; borderWidth:0.

    (Button label:'one' in:p1) width:0.4.
    (Button label:'two' in:p1) width:0.4.
    (Button label:'three' in:p1) width:0.4.

    sep := Separator in:top.
    sep orientation:#vertical.
    sep origin:0.5@0.0 extent:10@1.0.
    sep leftInset:-5; rightInset:-5.

    (Button label:'four' in:p2) width:0.4.
    (Button label:'five' in:p2) width:0.4.
    (Button label:'six' in:p2) width:0.4.

    top open
                                                                        [exEnd]


  with multiple horizontal seps in a panel:
                                                                        [exBegin]
    |top p sep|

    top := StandardSystemView new.
    top extent:300@300.

    p := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
    p verticalLayout:#spreadSpace.
    p horizontalLayout:#center.

    (Button label:'one' in:p).
    (Button label:'two' in:p).
    (Button label:'three' in:p).

    sep := Separator in:p.
    sep orientation:#horizontal.
    sep extent:0.9@10.

    (Button label:'four' in:p).
    (Button label:'five' in:p).

    sep := Separator in:p.
    sep orientation:#horizontal.
    sep extent:0.9@10.

    (Button label:'six' in:p).

    top open
                                                                        [exEnd]
"
! !

!Separator methodsFor:'accessing'!

orientation
    "return the orientation (one of #horizontal or #vertical)"

    ^ orientation
!

orientation:aSymbol
    "set the orientation to one of #horizontal or #vertical"

    orientation := aSymbol.
    self invalidate

    "Modified: 28.2.1997 / 21:24:38 / cg"
! !

!Separator methodsFor:'drawing'!

redrawX:x y:y width:w height:h
    |vCenter hCenter is3D bgColor|

    (shown and:[superView notNil]) ifFalse:[^ self].

    bgColor := superView viewBackground.

    bgColor isColor ifTrue:[
        gc paint:(superView viewBackground).
        gc fillRectangleX:x y:y width:w height:h.
    ] ifFalse:[
        gc clearRectangleX:x y:y width:w height:h.
    ].
    is3D := styleSheet is3D.

    gc paint:shadowColor.
    orientation == #vertical ifTrue:[
        hCenter := self width // 2.
        gc displayLineFromX:hCenter y:0 toX:hCenter y:height-1.
        is3D ifTrue:[
            gc paint:lightColor.
            gc displayLineFromX:hCenter+1 y:0 toX:hCenter+1 y:height-1.
        ]
    ] ifFalse:[
        vCenter := self height // 2.
        gc displayLineFromX:0 y:vCenter toX:width-1 y:vCenter.
        is3D ifTrue:[
            gc paint:lightColor.
            gc displayLineFromX:0 y:vCenter+1 toX:width-1 y:vCenter+1.
        ]
    ]
!

sizeChanged:how
    super sizeChanged:how.
    self invalidate

    "Created: / 18.4.1998 / 02:36:42 / cg"
    "Modified: / 18.4.1998 / 14:10:05 / cg"
! !

!Separator methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false


! !

!Separator methodsFor:'initialization'!

initialize
    super initialize.
    self borderWidth:0.
    orientation := #horizontal.

    "Modified: 28.2.1997 / 21:23:02 / cg"
! !

!Separator methodsFor:'queries'!

preferredExtent
    |e|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    e := super preferredExtent.
    orientation == #horizontal ifTrue:[
        ^ e x @ 5
    ].
    ^ 5 @ e y

    "Created: 17.3.1997 / 10:37:42 / cg"
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not SeparatorSpec)"

    self class == Separator ifTrue:[^ DividerSpec].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:48:40 / cg"
! !

!Separator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

