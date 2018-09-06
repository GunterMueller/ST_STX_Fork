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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Model subclass:#TabulatorSpecification
	instanceVariableNames:'tabUnit unitReference tabPositions tabTypes'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!TabulatorSpecification class methodsFor:'documentation'!

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
    This is a helper class for table widgets and tabular data in
    lists.
    A tabulatorSpecification keeps track of where the tabs are,
    and how they align. They are to be used in conjunction with
    MultiColumnListEntry or the upcoming TableWidget.
    However, they may also be useful to represent tabs in a
    paragraph of text.


    [author:]
        Claus Gittinger

    [see also:]
        Ruler TabSpecRuler
        ListView
"
!

examples 
"
    Example use (in a ListView):
                                                                        [exBegin]
        |listView tabSpec entry|

        listView := ListView new.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#inch.
        tabSpec positions:#(0     1     2.5    3.5    4       5        ).
        tabSpec align:    #(#left #left #right #right #center #decimal ).

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'left';
              colAt:2 put:'left';
              colAt:3 put:'right';
              colAt:4 put:'right';
              colAt:5 put:'center';
              colAt:6 put:'.decimal'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'col1';
              colAt:2 put:'col2';
              colAt:3 put:'col3';
              colAt:4 put:'col4';
              colAt:5 put:'col5';
              colAt:6 put:'col6.decimal'.

        listView at:2 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'foo';
              colAt:2 put:'fooBar';
              colAt:3 put:'bar';
              colAt:4 put:'barFoo';
              colAt:5 put:'baz';
              colAt:6 put:'1234.56'.

        listView at:3 put:entry.
        (ScrollableView forView:listView) open
                                                                        [exEnd]


    defining field positions in millimeter :
                                                                        [exBegin]
        |listView tabSpec entry|

        listView := ListView new.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#mm.
        tabSpec positions:#(0 10 20 40).
        tabSpec align:    #left.          

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'1';
              colAt:2 put:'2';
              colAt:3 put:'3';
              colAt:4 put:'4'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'aa';
              colAt:2 put:'bb';
              colAt:3 put:'cc';
              colAt:4 put:'dd'.

        listView at:2 put:entry.

        listView open
                                                                        [exEnd]

    defining field widths in millimeter :
                                                                        [exBegin]
        |listView tabSpec entry|

        listView := ListView new.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#mm.
        tabSpec widths:#(10 10 20 10).
        tabSpec align:    #left.        

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'1';
              colAt:2 put:'2';
              colAt:3 put:'3';
              colAt:4 put:'4'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'aa';
              colAt:2 put:'bb';
              colAt:3 put:'cc';
              colAt:4 put:'dd'.

        listView at:2 put:entry.

        listView open
                                                                        [exEnd]

    defining field widths in pixels :
                                                                        [exBegin]
        |listView tabSpec entry|

        listView := ListView new.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#pixel.
        tabSpec widths:#(50 30 30 50).
        tabSpec align:    #left.        

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'1';
              colAt:2 put:'2';
              colAt:3 put:'3';
              colAt:4 put:'4'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'aa';
              colAt:2 put:'bb';
              colAt:3 put:'cc';
              colAt:4 put:'dd'.

        listView at:2 put:entry.

        listView open
                                                                        [exEnd]

  same as first example, but adding a TabSpecRuler to show where
  the tabs are:
                                                                        [exBegin]
        |top ruler listView tabSpec entry|

        top := StandardSystemView extent:300@300.

        ruler := TabSpecRuler origin:0.0@0.0 corner:1.0@20 in:top.
        ruler level:0.
        ruler tabsAreVariable:false.

        listView := ListView in:top.
        listView origin:0.0@0.0 corner:1.0@1.0.
        listView topInset:20.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#inch.
        tabSpec positions:#(0     1     2.5    3.5    4       5        ).
        tabSpec align:    #(#left #left #right #right #center #decimal ).

        ruler tabulatorSpecification:tabSpec.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'left';
              colAt:2 put:'left';
              colAt:3 put:'right';
              colAt:4 put:'right';
              colAt:5 put:'center';
              colAt:6 put:'.decimal'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'col1';
              colAt:2 put:'col2';
              colAt:3 put:'col3';
              colAt:4 put:'col4';
              colAt:5 put:'col5';
              colAt:6 put:'col6.decimal'.

        listView at:2 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'foo';
              colAt:2 put:'fooBar';
              colAt:3 put:'bar';
              colAt:4 put:'barFoo';
              colAt:5 put:'baz';
              colAt:6 put:'1234.56'.

        listView at:3 put:entry.
        top open
                                                                        [exEnd]

  much like previous example, but allow some tab positions to be
  changed (with synchronousOperation):
                                                                        [exBegin]
        |top ruler listView tabSpec entry|

        top := StandardSystemView extent:300@300.

        ruler := TabSpecRuler origin:0.0@0.0 corner:1.0@20 in:top.
        ruler level:0.
        ruler fixedTabs:#(1).
        ruler synchronousOperation:true.

        listView := ListView in:top.
        listView origin:0.0@0.0 corner:1.0@1.0.
        listView topInset:20.

        tabSpec := TabulatorSpecification new.
        tabSpec unit:#inch.
        tabSpec positions:#(0     1     2.5    3.5    4       5        ).
        tabSpec align:    #(#left #left #left #left #left #decimal ).

        ruler tabulatorSpecification:tabSpec.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'left';
              colAt:2 put:'left';
              colAt:3 put:'left';
              colAt:4 put:'left';
              colAt:5 put:'left';
              colAt:6 put:'.decimal'.

        listView at:1 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'col1';
              colAt:2 put:'col2';
              colAt:3 put:'col3';
              colAt:4 put:'col4';
              colAt:5 put:'col5';
              colAt:6 put:'col6'.

        listView at:2 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'foo';
              colAt:2 put:'fooBar';
              colAt:3 put:'bar';
              colAt:4 put:'barFoo';
              colAt:5 put:'baz';
              colAt:6 put:'1234.56'.

        listView at:3 put:entry.

        entry := MultiColListEntry new.
        entry tabulatorSpecification:tabSpec.
        entry colAt:1 put:'hello';
              colAt:2 put:'world';
              colAt:3 put:'how';
              colAt:4 put:'about';
              colAt:5 put:'this';
              colAt:6 put:'0.2345'.
        listView at:4 put:entry.

        tabSpec onChangeSend:#redraw to:listView.
        top open
                                                                        [exEnd]
"
! !

!TabulatorSpecification class methodsFor:'instance creation'!

unit:unit positions:positions
    ^ (self new) unit:unit; positions:positions

    "
     TabulatorSpecification unit:#inch positions:#(0 3)
    "

    "Modified: 30.8.1995 / 16:37:50 / claus"
! !

!TabulatorSpecification methodsFor:'accessing'!

align
    "return the align-vector"

    ^ tabTypes
!

align:types
    "
     an array of tab-types; each one is
	#left
	#right
	#center
	#decimal
     or a symbol which gives align of all tabs

    "
    tabTypes := types
!

moveTabAtIndex:index to:unitPosition
    "set an individual position"

    tabPositions at:index put:unitPosition.
    self changed:#tabPosition with:index

    "Modified: 28.3.1997 / 14:55:27 / cg"
!

positions
    "return the position-vector"

    ^ tabPositions
!

positions:tabs
    "set the position-vector"

    tabPositions := tabs
!

size
    "return the number of tabs in this spec"

    ^ tabPositions size
!

unit
    "return the unit"

    ^ tabUnit
!

unit:aSymbol
    "set the unit.
     allowed are: #inch, #mm, #cm, #pixel and #col"

    tabUnit := aSymbol
!

unitRelativeTo:someObject
    "set for a relative unit. someObject should return its width
     and the tabs are set fraction-relative to this number (in pixel)."

    tabUnit := #relative.
    unitReference := someObject
!

widths
    "return a width-vector"

    |prev|

    prev := 0.
    ^ tabPositions collect:[:p | |w| w := p - prev. prev := p. w].

    "
     |spec|

     spec := TabulatorSpecification new.
     spec unit:#inch.
     spec positions:#(0     1     2.5    3.5    4       5        ).
     spec align:    #(#left #left #right #right #center #decimal ).
     spec widths
    "
!

widths:fieldWidths
    "set the position-vector from a vector of field widths"

    |pos|

    pos := 0.
    tabPositions := fieldWidths collect:[:w | 
					    |p|

					    p := pos.
					    pos := pos + w.
					    p].
! !

!TabulatorSpecification methodsFor:'queries'!

pixelsPerUnitOn:aGC
    "return the number of device pixels one unit of my tabs
     takes on aGC"

    |gcDevice mm|

    tabUnit isNil ifTrue:[
        tabUnit := #col
    ].
    tabUnit == #relative ifTrue:[
        ^ unitReference width
    ].
    tabUnit == #col ifTrue:[
        ^ aGC font width
    ].
    gcDevice := aGC graphicsDevice.
    tabUnit == #inch ifTrue:[
        ^ gcDevice horizontalPixelPerInch
    ].
    mm := gcDevice horizontalPixelPerMillimeter.
    tabUnit == #mm ifTrue:[
        ^ mm
    ].
    tabUnit == #cm ifTrue:[
        ^ mm * 10
    ].
    "
     assume pixels
    "
    ^ 1.

    "Modified: 28.3.1997 / 14:52:12 / cg"
!

positionOfTab:index forString:aString on:aGC
    "return the position (in device units) of the string to be drawn
     at position index."

    |pos type idx left|

    pos := self positionOfTab:index on:aGC.
    pos isNil ifTrue:[^ nil].

    type := self typeOfTab:index.

    type == #right ifTrue:[
	^ pos - (aGC font widthOf:aString).
    ].
    type == #center ifTrue:[
	^ pos - ((aGC font widthOf:aString) // 2).
    ].
    type == #decimal ifTrue:[
	idx := aString indexOf:$..
	idx == 0 ifTrue:[
	     ^ pos - (aGC font widthOf:aString).
	].
	left := aString copyTo:(idx-1).
	^ pos - (aGC font widthOf:left).
    ].
    "default is left"
    ^ pos
!

positionOfTab:index on:aGC
    "return the position (in device units) of the tab at index"

    |unit pos|

    tabPositions isNil ifTrue:[^ nil].

    unit := self pixelsPerUnitOn:aGC.
    pos := ((tabPositions at:index) * unit) asInteger.
    ^ pos
!

typeOfTab:index
    "return the type of the tab at position index."

    tabPositions isNil ifTrue:[^ #left].
    tabTypes notNil ifTrue:[
	(tabTypes isMemberOf:Symbol) ifTrue:[
	    ^ tabTypes
	].
	^ tabTypes at:index.
    ].
    "default is left"
    ^ #left
!

unitsPerPixelOn:aGC
    "return the number of units that one device pixels 
     takes on aGC"

    ^ 1 / (self pixelsPerUnitOn:aGC)

    "Modified: 28.3.1997 / 14:52:01 / cg"
! !

!TabulatorSpecification class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

