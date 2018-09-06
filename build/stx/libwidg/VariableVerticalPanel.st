"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

VariablePanel subclass:#VariableVerticalPanel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!VariableVerticalPanel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    This class is only here for backward compatibility;
    all functionality is now in VariablePanel. Its orientation can now
    be changed dynamically.

    A View to separate its subviews vertically by a movable bar;
    the size-ratios of the subviews can be changed by moving this bar.

    The bar-handle is either an exposed knob (style == #motif)
    or the forms defined in Scroller (style ~~ #motif)
    or nothing.

    The subvies dimensions MUST be given as relative sizes;
    typically creation is done as:

        p := VariableVerticalPanel in:superView.
        v1 := <someViewClass> origin:0.0 @ 0.0
                              corner:1.0 @ 0.5
                                  in:p.
        v2 := <someViewClass> origin:0.0 @ 0.5 
                              corner:1.0 @ 0.8 
                                  in:p.
        v3 := <someViewClass> origin:0.0 @ 0.8 
                              corner:1.0 @ 1.0
                                  in:p.


    [see also:]
        VariableHorizontalPanel
        VerticalPanelView HorizontalPanelView PanelView

    [author:]
        Claus Gittinger
"
!

examples
"
   VariableVerticalPanel is simply setting its orientation
   to #vertical. See more examples there.

   example:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariableVerticalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   example:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariableVerticalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p handleLevel:-1.

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]


    example:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariableVerticalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := ScrollableView for:SelectionInListView in:p.
        v1 origin:0.0 @ 0.0 corner:1.0 @ 0.5.
        v1 list:(FileDirectory directoryNamed:'/etc') contents.
        v1 action:[:selNr |
                |fullName stream text|
                fullName := '/etc/' , v1 selectionValue.
                stream := fullName asFilename readStream.
                stream notNil ifTrue:[
                    text := stream contents.
                    v2 contents:text.
                    v3 contents:text
                ]
        ].

        v2 := TextView 
                 origin:0.0 @ 0.5 corner:1.0 @ 0.8 in:p.

        v3 := ScrollableView 
                 for:TextView 
                 in:p.
        v3 origin:0.0 @ 0.8 corner:1.0 @ 1.0.
        top open
                                                                        [exEnd]

    example: (dynamically adding/removing views):
                                                                        [exBegin]
        |top p v1 v2 b|

        top := StandardSystemView new.
        top extent:300@300.

        b := Toggle label:'show' in:top.
        b showLamp:false.
        b origin:0.0 @ 0.0 corner:(1.0 @ 40).
        b action:[:state |
                state ifTrue:[
                    b label:'hide'.
                    v1 origin:0.0 @ 0.0 corner:1.0 @ 0.5.
                    v2 := ScrollableView for:EditTextView.
                    v2 origin:0.0 @ 0.5 corner:1.0 @ 1.0.
                    v2 contents:'another text'.
                    p addSubView:v2.
                ] ifFalse:[
                    b label:'show'.
                    v2 destroy.
                    v1 origin:0.0 @ 0.0 corner:1.0 @ 1.0
                ]
            ].

        p := VariableVerticalPanel
                origin:0.0 @ 0.0
                corner:1.0 @ 1.0
                in:top.
        p topInset:50.

        v1 := ScrollableView for:EditTextView in:p.
        v1 origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        v1 contents:'some text'.

        top open
                                                                        [exEnd]
"
! !

!VariableVerticalPanel methodsFor:'initialization'!

initialize
    orientation := #vertical.
    super initialize.
! !

!VariableVerticalPanel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/VariableVerticalPanel.st,v 1.31 2011-09-29 11:20:04 cg Exp $'
! !
