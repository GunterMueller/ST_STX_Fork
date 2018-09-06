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

"{ NameSpace: Smalltalk }"

SimpleView subclass:#VariablePanel
	instanceVariableNames:'barHeight barWidth barLevel separatingLine shadowForm lightForm
		showHandle showHandleWhenEntered handlePosition handleColor
		handleStyle handleLevel noColor trackLine redrawLocked
		orientation handleLabels knobHeight realRelativeSizes
		snapAdornment'
	classVariableNames:'DefaultShowHandle DefaultHandleStyle DefaultHandlePosition
		DefaultTrackingLine DefaultSeparatingLine DefaultHandleColor
		DefaultHandleLevel DefaultVCursor DefaultHCursor
		DefaultHandleImage DefaultSnapIcons DefaultSnapHandlePosition
		DefaultShowHandleWhenEntered'
	poolDictionaries:''
	category:'Views-Layout'
!

Object subclass:#SnapAdornment
	instanceVariableNames:'level mode selectedLevel enterLevel selectedBgColor enterBgColor
		iconLeftRight iconUpDown iconLeft iconRight iconUp iconDown width
		height'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VariablePanel
!

!VariablePanel class methodsFor:'documentation'!

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
    a View to separate its subviews vertically by a movable bar;
    the size-ratios of the subviews can be changed by moving this bar.

    In order to correctly setup this kind of view, the subviews must
    be created with a relative origin & relative corner.
    The panel does not verify the relative subview bounds; 
    therefore, it is your responsibility to set those relative sizes to fit
    according the orientation (see bad example below).

    The bar-handle is either an exposed knob (style == #motif)
    or the form defined in Scroller (style ~~ #motif)
    or nothing.

    Typically creation is done as:

        p := VariablePanel in:superView.
        p orientation:#vertical.

        v1 := <someViewClass> origin:0.0 @ 0.0
                              corner:1.0 @ 0.5
                                  in:p.
        v2 := <someViewClass> origin:0.0 @ 0.5 
                              corner:1.0 @ 0.8 
                                  in:p.
        v3 := <someViewClass> origin:0.0 @ 0.8 
                              corner:1.0 @ 1.0
                                  in:p.

    The two subclasses VariableHorizontalPanel and VariableVerticalPanel
    preset the orientation. They are a kept for backward compatibility
    (in previous versions, there used to be no common VariablePanel (super-) class).

    Notice: if it is required to insert a fixed-size view in the panel,
    use an extra view & insets, and place the subview into that extra view.
    See examples.

    [instance Variables:]

        barHeight               <Integer>       the height of the bar (for verticalPanels)
        barWidth                <Integer>       the width of the bar  (for horizontalPanels)

        separatingLine          <Boolean>       show a separating line (as in motif style)

        shadowForm              <Image/Form>    form (shadow part) drawn as handle - if nonNil

        lightForm               <Image/Form>    form (light part) drawn as handle - if nonNil

        showHandle              <Boolean>       if false, no handle is drawn

        handlePosition          <Symbol>        where is the handle - one of #left, #center, #right

        handleColor             <Color>         inside color of handle - defaults to viewBackground

        handleStyle             <Symbol>        type of handle; one of #next, #motif or nil

        handleLevel             <Integer>       3D level of handle (only valid if no form is given)

        trackLine               <Boolean>       if true, an inverted line is drawn for tracking;
                                                otherwise, the whole bar is inverted.

        redrawLocked                            internal - locks redraws while tracking

        orientation             <Symbol>        one of #horizontal / #vertical


    [styleSheet values:]
        variablePanel.showHandle        true/false - should a handle be shown (default:true)

        variablePanel.handleStyle       #next / #motif / #iris / #full / nil (special handles)

        variablePanel.handlePosition    #left / #center / #right (default:#right)

        variablePanel.handleLevel       3D level of heandle (default:2)

        variablePanel.trackingLine      when moved, track an inverted line (as in motif)
                                        as opposed to tracking the whole bar (default:false)
                                        (obsoleted by trackingStyle)

        variablePanel.trackingStyle     #solidRectangle / #solidLine / #dashedLine
                                        detailed control over how to draw tracking
                                        (obsoletes trackingLine above)

        variablePanel.separatingLine    draw a separating line in the bar as in motif (default:false)

        variablePanel.handleColor       color of the handle. (default:Black)

        variablePanel.handleEnteredColor 
                                        color of the handle when the pointer is in the bar (default:nil)

    [see also:]
        PanelView
        
    [author:]
        Claus Gittinger
"
!

examples
"
   example (notice that the subviews MUST have relative bounds):
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.

        v1 := View origin:0.0@0.0 corner:1.0@(1/2) in:p.
        v2 := View origin:0.0@(1/2) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   change the handles level:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p handleLevel:-1.

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   change the handles style to nil makes it invisible:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p handleStyle:nil.

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   define your own handle (-bitmap):
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p handleImage:(Image fromFile:'bitmaps/ScrollLt.8.xbm').

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   another handle-bitmap:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p handleImage:(Form width:9
                            height:11
                            fromArray:#(
                                        2r00000000 2r00000000
                                        2r00001000 2r00000000
                                        2r00011100 2r00000000
                                        2r00111110 2r00000000
                                        2r01111111 2r00000000
                                        2r00000000 2r00000000
                                        2r01111111 2r00000000
                                        2r00111110 2r00000000
                                        2r00011100 2r00000000
                                        2r00001000 2r00000000
                                        2r00000000 2r00000000
                                       )
                      ).

        v1 := View origin:0.0@0.0 corner:1.0@(1/3) in:p.
        v2 := View origin:0.0@(1/3) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]

    placing scrolled and unscrolled views into a variablePanel:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.

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

        v2 := TextView origin:0.0 @ 0.5 corner:1.0 @ 0.8 in:p.

        v3 := ScrollableView for:TextView in:p.
        v3 origin:0.0 @ 0.8 corner:1.0 @ 1.0.
        top open
                                                                        [exEnd]


    dynamically adding/removing views:
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
                    v2 realize.
                ] ifFalse:[
                    b label:'show'.
                    v2 destroy.
                    v1 origin:0.0 @ 0.0 corner:1.0 @ 1.0
                ]
            ].

        p := VariablePanel
                origin:0.0 @ 0.0
                corner:1.0 @ 1.0
                in:top.
        p orientation:#vertical.
        p topInset:50.

        v1 := ScrollableView for:EditTextView in:p.
        v1 origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        v1 contents:'some text'.

        top open
                                                                        [exEnd]


    dynamically flipping orientation:
    Notice: you have to change the relative bounds of the subviews first.
                                                                        [exBegin]
        |top p v1 v2 b|

        top := StandardSystemView new.
        top extent:300@300.

        b := Toggle label:'flip' in:top.
        b showLamp:false.
        b origin:0.0 @ 0.0 corner:(1.0 @ 40).
        b action:[:state |
                state ifTrue:[
                    v1 origin:0.0 @ 0.0 corner:0.5 @ 1.0.
                    v2 origin:0.5 @ 0.0 corner:1.0 @ 1.0.
                    p orientation:#horizontal.
                ] ifFalse:[
                    v1 origin:0.0 @ 0.0 corner:1.0 @ 0.5.
                    v2 origin:0.0 @ 0.5 corner:1.0 @ 1.0.
                    p orientation:#vertical.
                ].
            ].

        p := VariablePanel
                origin:0.0 @ 0.0
                corner:1.0 @ 1.0
                in:top.
        p orientation:#vertical.
        p topInset:50.

        v1 := ScrollableView for:EditTextView in:p.
        v1 origin:0.0 @ 0.0 corner:1.0 @ 0.5.
        v1 contents:'some text'.

        v2 := ScrollableView for:EditTextView in:p.
        v2 origin:0.0 @ 0.5 corner:1.0 @ 1.0.
        v2 contents:'another text'.

        top open
                                                                        [exEnd]


   combining fix-size with variable size:
   (need 3 extra frame-views to place the extra labels into)
                                                                        [exBegin]
        |top p v1 l1 v2 l2 v3 l3 f1 f2 f3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        p orientation:#vertical.

        f1 := View origin:0.0@0.0 corner:1.0@0.3 in:p.
        f2 := View origin:0.0@0.3 corner:1.0@0.6 in:p.
        f3 := View origin:0.0@0.6 corner:1.0@1.0 in:p.

        v1 := View origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:f1.
        v2 := View origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:f2.
        v3 := View origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:f3.

        l1 := Label label:'sub1' in:f1.
        l2 := Label label:'sub2' in:f2.
        l3 := Label label:'sub3' in:f3.

        l1 origin:0.0 @ 0.0 corner:1.0 @ 0.0 ; 
           bottomInset:(l1 preferredExtent y negated).
        l2 origin:0.0 @ 0.0 corner:1.0 @ 0.0 ; 
           bottomInset:(l2 preferredExtent y negated).
        l3 origin:0.0 @ 0.0 corner:1.0 @ 0.0 ; 
           bottomInset:(l3 preferredExtent y negated).

        v1 topInset:(l1 preferredExtent y); level:-1.
        v2 topInset:(l2 preferredExtent y); level:-1.
        v3 topInset:(l3 preferredExtent y); level:-1.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]

   VerticalPansels allow a label to be associated with the
   handles; this looks much like the above, but is slightly
   more compact. Notice, no label can be placed above the first 
   view - it has no handle.
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        p orientation:#vertical.
        p handleLabels:#('ignored' 'sub2' 'sub3').

        v1 := View origin:0.0@0.0 corner:1.0@0.3 in:p.
        v2 := View origin:0.0@0.3 corner:1.0@0.6 in:p.
        v3 := View origin:0.0@0.6 corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]

   handle labels can be more than strings ....
   (however, they should have about the same height, since
    the largest defines heights of all bars;
    retry the example below with a larger bitmap image ...)
                                                                        [exBegin]
        |top e p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        p orientation:#vertical.
        e := Array with:#bold
                   with:#color->Color red.

        p handleLabels:(Array with:nil
                              with:('bold and red' asText emphasizeAllWith:e)
                              with:(Image fromFile:'ScrollRt.xbm')).

        v1 := View origin:0.0@0.0 corner:1.0@0.3 in:p.
        v2 := View origin:0.0@0.3 corner:1.0@0.6 in:p.
        v3 := View origin:0.0@0.6 corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]



   BAD EXAMPLE (wrong relative sizes - repaired on handle move):
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.

        v1 := View origin:0.0 @ 0.0   corner:1.0 @ (1/4) in:p.
        v2 := View origin:0.0 @ (1/2) corner:1.0 @ (3/4) in:p.
        v3 := View origin:0.0 @ (3/4) corner:1.0 @ 1.0   in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]

   example with snapMode:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p snapMode:#min.

        v1 := View origin:0.0@0.0 corner:1.0@(1/2) in:p.
        v2 := View origin:0.0@(1/2) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]

   example with redefined handle-image:
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@300.

        p := VariablePanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.
        p orientation:#vertical.
        p handleImage:(ToolbarIconLibrary barResizeVerticalIcon).
        p showHandle:true.

        v1 := View origin:0.0@0.0 corner:1.0@(1/2) in:p.
        v2 := View origin:0.0@(1/2) corner:1.0@(2/3) in:p.
        v3 := View origin:0.0@(2/3) corner:1.0@1.0 in:p.

        v1 viewBackground:(Color red).
        v2 viewBackground:(Color green).
        v3 viewBackground:(Color yellow).

        top open
                                                                        [exEnd]


"
! !

!VariablePanel class methodsFor:'defaults'!

cursorForOrientation:orientation
    "return an appropriate cursor"

    ^ self cursorForOrientation:orientation onDevice:Screen current.

    "Modified: / 30.9.1998 / 18:21:10 / cg"
!

cursorForOrientation:orientation onDevice:device
    "return an appropriate cursor"

    |cursor|

    orientation == #vertical ifTrue:[
        (DefaultVCursor notNil and:[device == Display]) ifTrue:[
            cursor := DefaultVCursor
        ] ifFalse:[
            device isWindowsPlatform ifFalse:[
                cursor := Cursor
                            fromImage:self verticalResizeCursor
                            hotSpot:8@8.
            ].

            "
             if bitmaps are not available or under Win95, 
             use a standard cursor
            "
            cursor isNil ifTrue:[
                "which one looks better ?"
                cursor := Cursor upDownArrow
                "cursor := Cursor upLimitArrow"
            ].
            device == Display ifTrue:[
                DefaultVCursor := cursor.
            ].
        ]
    ] ifFalse:[
        (DefaultHCursor notNil and:[device == Display]) ifTrue:[      
            cursor := DefaultHCursor
        ] ifFalse:[
            device isWindowsPlatform ifFalse:[
                cursor := Cursor
                            fromImage:self horizontalResizeCursor
                            hotSpot:8@8.
            ].
            "
             if bitmaps are not available or under Win95, 
             use a standard cursor
            "
            cursor isNil ifTrue:[
                "which one looks better ?"
                cursor := Cursor leftRightArrow
                "cursor := Cursor leftLimitArrow"
            ].
            device == Display ifTrue:[
                DefaultHCursor := cursor
            ].
        ]
    ].

    ^ cursor

    "
     DefaultVCursor := DefaultHCursor := nil.
    "

    "Created: / 30.9.1998 / 18:20:41 / cg"
    "Modified: / 30.9.1998 / 18:23:07 / cg"
!

lightFormOn:aDisplay
    "use same handle as Scroller"

    ^ Scroller handleLightFormOn:aDisplay
!

shadowFormOn:aDisplay
    "use same handle as Scroller"

    ^ Scroller handleShadowFormOn:aDisplay
!

snapIcons
    "return a dictionary of snapIcons"

    DefaultSnapIcons isNil ifTrue:[
        DefaultSnapIcons := IdentityDictionary new.

        DefaultSnapIcons at:#iconUp    put:self snapIconUp.
        DefaultSnapIcons at:#iconRight put:self snapIconRight.
        DefaultSnapIcons at:#iconDown  put:self snapIconDown.
        DefaultSnapIcons at:#iconLeft  put:self snapIconLeft.

        DefaultSnapIcons at:#iconUpDown    put:self snapIconUpDown.
        DefaultSnapIcons at:#iconLeftRight put:self snapIconLeftRight.
    ].
    ^ DefaultSnapIcons

    "
        DefaultSnapIcons := nil.
        self snapIcons
    "
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'variablePanel.showHandle' 
                       #'variablePanel.handleStyle'
                       #'variablePanel.handleImage'
                       #'variablePanel.handlePosition' 
                       #'variablePanel.handleLevel'
                       #'variablePanel.snapHandlePosition' 
                       #'variablePanel.trackingLine'   
                       #'variablePanel.trackingStyle'
                       #'variablePanel.separatingLine' 
                       #'variablePanel.handleColor')>

    |lineModeBoolean|

    DefaultVCursor := DefaultHCursor := nil.

    DefaultShowHandle := StyleSheet at:#'variablePanel.showHandle' default:true.
    DefaultShowHandleWhenEntered := StyleSheet at:#'variablePanel.showHandleWhenEntered' default:false.
    DefaultHandleStyle := StyleSheet at:#'variablePanel.handleStyle'.
    DefaultHandlePosition := StyleSheet at:#'variablePanel.handlePosition' "default:#right".
    DefaultHandlePosition isNil ifTrue:[
        DefaultHandlePosition := ScrollableView defaultScrollBarPosition.
    ].
    DefaultSnapHandlePosition := StyleSheet at:#'variablePanel.snapHandlePosition' default:DefaultHandlePosition.
    DefaultHandleLevel := StyleSheet at:#'variablePanel.handleLevel' default:2.
    DefaultTrackingLine := StyleSheet at:#'variablePanel.trackingStyle'.
    DefaultTrackingLine isNil ifTrue:[
        lineModeBoolean := StyleSheet at:#'variablePanel.trackingLine' default:false.
        lineModeBoolean ifTrue:[
            DefaultTrackingLine := #solidLine
        ] ifFalse:[
            DefaultTrackingLine := #solidRectangle
        ]
    ].

    DefaultSeparatingLine := StyleSheet at:#'variablePanel.separatingLine' default:false.
    DefaultHandleColor := StyleSheet colorAt:#'variablePanel.handleColor' default:Color black.

    DefaultHandleImage := StyleSheet at:#'variablePanel.handleImage'

    "
     VariablePanel updateStyleCache
    "

    "Modified: / 19-12-2010 / 09:39:50 / cg"
! !

!VariablePanel class methodsFor:'image specs'!

horizontalResizeCursor
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self horizontalResizeCursor inspect
     ImageEditor openOnClass:self andSelector:#horizontalResizeCursor
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VariablePanel horizontalResizeCursor'
        ifAbsentPut:[(Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@X@A @F@@X@!!!!AFHBYC=/0&PDX !!!!@F@@X@A @F@@@@b')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@<@C0@O@X<Y33#/\????????N=133&OF@<@C0@O@@@@b'); yourself); yourself]
!

snapIconDown
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconDown inspect
     ImageEditor openOnClass:self andSelector:#snapIconDown"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconDown'
        ifAbsentPut:[
            (Depth2Image new)
                width:62;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@B(J *F(Z!!*F(Z!!*@@@@@@@!!BDHQ!!FDXQ!!FDXP@@H@@@EPUATEPUATEPUAT@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:62;
                            height:5;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@A?LX1#FLX3>C8)R%JT)R''0GA#FLX1#FN@H@@@@@@@@P@@a');
                            yourself);
                yourself
        ]
!

snapIconLeft
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconLeft inspect
     ImageEditor openOnClass:self andSelector:#snapIconLeft"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconLeft'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:62;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@C @B@@@@@@@@@@@@@@@@@@P@C@)@BD@IP@@@@@BJP@!!@BT@@@@@@B$HHP %@@@@AP@)@BD@IP@@D@T0JP@!!@BT@@@@ED2$@HP@%@@@@AP@)ARDHIP@@@@T@
JP@!!@BT@@A@ELB @HP@E@@@@@C\@@@@@@@@@@@@@@@T@B@@a');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:5;
                            height:62;
                            bits:(ByteArray 
                                        fromPackedString:'@A@0\OA0LA@D@6UPL@@@XE@0@@A TC@@@FAPL@@@XE@0@@A UCLD@FAPL@@@XE@0@@A TC@@DCA0=''T0D@@b');
                            yourself);
                yourself
        ]
!

snapIconLeftRight
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconLeftRight inspect
     ImageEditor openOnClass:self andSelector:#snapIconLeftRight"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconLeftRight'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:62;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@K@AH@@@@@@AX@L@@@@@@(@BD@AQD@B@@FJ#@!!@AT@@@@@@J*@@@@@DP@H@AD*LBD@EP@@@@@@J"\!!B1T@@@@@E"(0HP@U@@@@@@B*$P@H@@X@L@@@
J @!!@AT@@@@@@B(RHP UDP@0@@@@@@@@@@@@I0@K@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:5;
                            height:62;
                            bits:(ByteArray 
                                        fromPackedString:' LC <NK@ @@A@&QPLP@@XE@0@@C<A? A@VAPL@@@XE@0@@A TCL@@O @>@@BXE@0@PY$TCD@@A@0\OA0LAXb');
                            yourself);
                yourself
        ]
!

snapIconRight
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconRight inspect
     ImageEditor openOnClass:self andSelector:#snapIconRight"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconRight'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:62;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@L@@@@@@@@@@@@@@AT@B@@@J@@!!@@T@E@@@@B(QHS@U@AP@@@@*@BD@EP@T@@@@J L!!@AT@E@@@DB(0HP@U@AP@@@@*J"D@EP@T@@@@J @!!B!!TH@@@@@B(@
HP@U@@@@@A@*LBD@EP@@@@@@@@X@@@@@@@@@@@@@@@ @B@@a');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:5;
                            height:62;
                            bits:(ByteArray 
                                        fromPackedString:'@4A \G%2X4@AXE@0@@A TC@E@6AQL@@@XE@0@@A TC@@@6APL@@@XEL0@@A UC\@@VAPL@@@PFA0^''M PP@b');
                            yourself);
                yourself
        ]
!

snapIconUp
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconUp inspect
     ImageEditor openOnClass:self andSelector:#snapIconUp"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconUp'
        ifAbsentPut:[
            (Depth2Image new)
                width:62;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@J *B(J *B(J (B @@@@@@BEHT!!REHT!!RDHP!!@@@@@@@EPUATEPUATE@TAP@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:62;
                            height:5;
                            bits:(ByteArray 
                                        fromPackedString:'B@@@@@@@@D@\X1#FLX1 8C9R%JT)R%G0_3FLX1#FL? @@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

snapIconUpDown
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapIconUpDown inspect
     ImageEditor openOnClass:self andSelector:#snapIconUpDown
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'VariablePanel class snapIconUpDown'
        ifAbsentPut:[
            (Depth2Image new)
                width:62;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@H@@@@@@ @@@@@@@@@B J@BB J@(@HJ@(@@@@@@@!!BDD !!BDHPBBDHP@@@@@@APE@HAPE@T@ E@T@@@@@@@@@@B@@@@@@H@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:62;
                            height:5;
                            bits:(ByteArray 
                                        fromPackedString:'@@@J@@B @@@PLX)#FJX1?C )R%JT)R#8_A#JLX2#FGC>@@(@@J@@H@@a');
                            yourself);
                yourself
        ]
!

verticalResizeCursor
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self verticalResizeCursor inspect
     ImageEditor openOnClass:self andSelector:#verticalResizeCursor
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VariablePanel verticalResizeCursor'
        ifAbsentPut:[(Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@P@A@@$ AT@C @D@@@C??/?>@@@A@@N@AT@IH@D@@P@b')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@8@[,A?0C>@G0@N@??;??/?>??8C @_@C>@_<A.0@8@b'); yourself); yourself]
! !

!VariablePanel methodsFor:'accessing-look'!

barHeight
    "return the height of the separating bar"

    ^ barHeight
!

barHeight:nPixel
    "set the height of the separating bar"

    |bH|

    "make certain bar is visible and catchable (not smaller than 4 pixels)"
    bH := nPixel max:4.

    "make it even, so spacing is equally spreadable among subviews"
    bH odd ifTrue:[
        bH := bH + 1
    ].
    self setBarHeight:bH

    "Modified: / 28.4.1997 / 14:30:33 / dq"
    "Modified: / 30.1.2000 / 22:31:32 / cg"
!

barLevel:level
    "set the 3D level of the separating bar"

    barLevel ~~ level ifTrue:[
        barLevel := level.
        self redrawIfShown.    
    ]
!

handleImage:aBitmapOrImage
    "define the handles image"

    shadowForm := aBitmapOrImage.
    lightForm := nil.
    self computeBarHeight.

    "Created: 7.11.1996 / 20:21:10 / cg"
    "Modified: 7.11.1996 / 20:27:22 / cg"
!

handleLabels:aCollectionOfLabels
    "define special handle labels - typically a collection of
     bitmap images. Notice, that the first handle is not
     drawn, that is, the first element if the argument is useless."

    orientation == #horizontal ifTrue:[
        self error:'not allowed for horizontal panels'
    ].

    handleLabels := aCollectionOfLabels.
    self computeBarHeight.
    self resizeSubviews.

    "
     |top panel v1 v2|

     top := StandardSystemView new.
     panel := VariableVerticalPanel origin:0.0@0.0 corner:1.0@1.0 in:top.
     panel add:(EditTextView origin:0.0@0.0 corner:1.0@0.5).
     panel add:(EditTextView origin:0.0@0.5 corner:1.0@1.0).
     panel handleStyle:nil.
     panel handleLabels:#('foo' 'bar').
     top open
    "
!

handleLevel:aNumber
    "define the 3D level of the handle (only with some styles).
     Normally, this is defined via styleSheet files, but this entry allows
     individual views to be manipulated."

    handleLevel ~~ aNumber ifTrue:[
        handleLevel := aNumber.
        self redrawIfShown.    
    ]
!

handlePosition
    "return the position of the handle"

    ^ handlePosition
!

handlePosition:aSymbol
    "define the position of the handle; the argument aSymbol
     may be one of #left, #right or #center.
     If never set by the program, the position is controlled by the styleSheet."

    handlePosition ~~ aSymbol ifTrue:[
        handlePosition := aSymbol ? DefaultHandlePosition.
        self redrawIfShown.    
    ]
!

handleShadowImage:shadowImage lightImage:lightImage
    "define the handles image; both shadow and light parts"

    shadowForm := shadowImage.
    lightForm := lightImage.
    self computeBarHeight.

    "Created: 7.11.1996 / 20:21:51 / cg"
    "Modified: 7.11.1996 / 20:27:26 / cg"
!

handleStyle:styleSymbol
    "define the style of the handle;
     styleSymbol may be #motif to draw a little knob or
     anything else to draw scrollBars handleForm.
     Normally, this is defined via styleSheet files, but this entry allows
     individual views to be manipulated."

    (styleSymbol ~~ handleStyle) ifTrue:[
        handleStyle := styleSymbol.
        handleStyle == #next ifTrue:[
            shadowForm := self class shadowFormOn:device.
            lightForm := self class lightFormOn:device.
        ] ifFalse:[
            shadowForm := lightForm := nil
        ].

        shadowForm notNil ifTrue:[
            (self is3D and:[handleStyle ~~ #motif]) ifTrue:[
                self barHeight:(shadowForm height + 2).
                barWidth := shadowForm width
            ]
        ].
        shown ifTrue:[
            self resizeSubviews.
            self redrawIfShown.    
        ]
    ]

    "Created: 24.2.1996 / 19:04:07 / cg"
    "Modified: 29.5.1996 / 16:22:24 / cg"
!

orientation
    "return my orientation; either #horizontal or #vertical"

    ^ orientation

    "Modified: 6.3.1996 / 18:08:45 / cg"
!

orientation:aSymbol
    "change my orientation; aSymbol must be one of #horizontal or #vertical.
     Changing implies a resize of my subViews."

    aSymbol ~~ orientation ifTrue:[
        orientation := aSymbol.
        self initCursor.
        self anyNonRelativeSubviews ifTrue:[
            self setupSubviews
        ].
        shown ifTrue:[
            self cursor:cursor.
            self sizeChanged:nil.
            self redrawIfShown.
        ]
    ]

    "Modified: 29.5.1996 / 16:22:35 / cg"
!

relativeCorners
    "the returned collection gives the corner-fractional value for each component;
     i.e. for a 20-40-40 look, it would be #(0.2 0.6 1.0)"

    ^ self subViews 
        collect:[:eachView | 
                self isHorizontal ifTrue:[
                    eachView relativeCorner x
                ] ifFalse:[
                    eachView relativeCorner y
                ]
        ]
!

relativeCorners:aCollectionOfRelativeCornerPositions
    "the argument gives the corner-fractional value for each component;
     i.e. for a 20-40-40 look, it would be #(0.2 0.6 1.0)"

    |pos|

    aCollectionOfRelativeCornerPositions size == self subViews size ifFalse:[
        'VariablePanel [info]: size mismatch in relativeCorners' infoPrintCR.
        ^ self 
    ].

    pos := 0.0.
    self subViews with:aCollectionOfRelativeCornerPositions 
        do:[:eachView :eachCorner |
            self isHorizontal ifTrue:[
                eachView origin:(pos @ 0.0) corner:(eachCorner @ 1.0)
            ] ifFalse:[
                eachView origin:(0.0 @ pos) corner:(1.0 @ eachCorner)
            ].
            pos := eachCorner
        ].
    self realized ifTrue:[
        self resizeSubviews
    ].
!

setBarHeight:nPixel
    "check whether snap matches to extent of bar otherwise disable snap"

    |newBarHeight|
    
    snapAdornment notNil ifTrue:[
        newBarHeight := nPixel max:(snapAdornment height ? 0)
    ] ifFalse:[
        newBarHeight := nPixel max:0
    ].
    newBarHeight := newBarHeight max:(styleSheet at:#'variablePanel.minBarHeight' default:newBarHeight).
    newBarHeight ~= barHeight ifTrue:[
        barHeight := newBarHeight.
        realized ifTrue:[
            self resizeSubviews
        ]
    ]

    "Modified: / 31-10-2010 / 13:00:06 / cg"
!

showHandle
    "handle-drawing enabled/disable; a Boolean"

    ^ showHandle

    "Modified: / 19-12-2010 / 09:28:31 / cg"
!

showHandle:aBoolean
    "enabled/disable the handle-drawing"

    showHandle ~~ aBoolean ifTrue:[
        showHandle := aBoolean ? DefaultShowHandle.
        self invalidate. "/ redrawIfShown
    ]

    "Modified: / 19-12-2010 / 09:30:49 / cg"
!

showHandleWhenEntered
    "return aBoolean"

    ^ showHandleWhenEntered

    "Created: / 19-12-2010 / 09:27:40 / cg"
!

showHandleWhenEntered:aBoolean
    "enabled/disable the handle-drawing"

    showHandleWhenEntered ~~ aBoolean ifTrue:[
        showHandleWhenEntered := aBoolean ? DefaultShowHandleWhenEntered.
        self invalidate. "/ redrawIfShown
    ]

    "Created: / 19-12-2010 / 09:28:04 / cg"
!

snapHandlePosition
    "return the position of the snap-handle"

    ^ self handlePosition. "/ ^ snapHandlePosition
!

snapHandlePosition:aSymbol
    "define the position of the snap-handle; the argument aSymbol
     may be one of #left, #right or #center.
     If never set by the program, the position is controlled by the styleSheet."

    self handlePosition:aSymbol.

"/    snapHandlePosition := aSymbol.
"/    realized ifTrue:[
"/        self invalidate
"/    ]
!

snapMode
    "allowed modes are:
        nil             no snap

        #max            on press the view is increased to bottom(vertical) or right(horizontal)
        #min            on press the view is decreased to top   (vertical) or left (horizontal)
        #maxMin         on press the view is increased or decreased dependent on its current extent
        #minMax         on press the view is increased or decreased dependent on its current extent
    "
    snapAdornment notNil ifTrue:[
        ^ snapAdornment mode
    ].
    ^ nil

    "Modified: / 31-10-2010 / 13:00:16 / cg"
!

snapMode:aMode
    "allowed modes are:
        nil             no snap

        #max            on press the view is increased to bottom(vertical) or right(horizontal)
        #min            on press the view is decreased to top   (vertical) or left (horizontal)
        #maxMin         on press the view is increased or decreased dependent on its current extent
        #minMax         on press the view is increased or decreased dependent on its current extent
    "
    |oldHeight oldMode|

    aMode notNil ifTrue:[
        ( #( max min maxMin minMax both) includes:aMode) ifFalse:[
            ^ self error:('unknown snapMode: ', aMode printString).
        ]
    ].
    (oldMode := self snapMode) == aMode ifTrue:[^ self].

    (snapAdornment notNil and:[aMode notNil]) ifTrue:[
        "must only redraw"
        snapAdornment mode:aMode
    ] ifFalse:[
        "must recompute barHeight and redraw"

        aMode isNil ifTrue:[
            snapAdornment := nil
        ] ifFalse:[
            self initSnapAdornment.
            snapAdornment mode:aMode.
        ].
        oldHeight := barHeight.

        self computeBarHeight.

        oldHeight ~~ barHeight ifTrue:[
            "must recompute subViews"
"/            realized ifFalse:[
"/                needResize := true.
"/                ^ self.
"/            ].
            self setupSubviews.
            self resizeSubviews.
        ]
    ].
    self redrawIfShown.

    "Modified: / 31-10-2010 / 13:00:39 / cg"
!

style:styleSymbol
    "define the style of the handle;
     styleSymbol may be #motif to draw a little knob or
     anything else to draw scrollBars handleForm.
     Normally, this is defined via styleSheet files, but this entry allows
     individual views to be manipulated."

    self handleStyle:styleSymbol

    "Modified: 24.2.1996 / 19:04:19 / cg"
! !

!VariablePanel methodsFor:'adding & removing components'!

addSubView:aView
    "a view is added; adjust other subviews sizes"

    super addSubView:aView.

    realized ifTrue:[
        self setupSubviews.
        self resizeSubviews.
        aView beVisible.
    ]

    "Created: 17.1.1996 / 22:41:00 / cg"
    "Modified: 24.2.1996 / 19:05:05 / cg"
!

removeSubView:aView
    "a view is removed; adjust other subviews sizes"

    aView beInvisible.
    super removeSubView:aView.
    shown ifTrue:[             
        realized 
        "/ (superView isNil or:[superView shown]) 
        ifTrue:[
            self isBeingDestroyed ifFalse:[
                self setupSubviews.
                self resizeSubviews.
            ]
        ]
    ]
! !

!VariablePanel methodsFor:'drawing'!

clearAndInvalidate
    realized ifTrue:[ self clear ].
    self invalidate.
!

drawHandle:hIndex atX:hx y:hy
    "draw a single handle at hx/hy"

    |h w x y m xm ym lbl maxKnob
     mar           "{ Class: SmallInteger }"
     barWidthInt   "{ Class: SmallInteger }"
     barHeightInt  "{ Class: SmallInteger }" |

    ((handleStyle isNil or:[handleStyle == #none])
    and:[handleLabels isNil]) ifTrue:[^ self].

    mar := margin.
    barHeightInt := barHeight.
    barWidthInt := barWidth.

    shadowForm notNil ifTrue:[
        h := shadowForm height.
        w := shadowForm width .
        maxKnob := h min:barHeightInt.
    ] ifFalse:[
        maxKnob := knobHeight min: barHeightInt.
        maxKnob := maxKnob max:4.
        handleStyle == #full ifTrue:[
            w := h := maxKnob
        ] ifFalse:[
            w := h := maxKnob - 4.
        ]
    ].

    gc paint:viewBackground.
    gc lineStyle:#solid.

    orientation == #vertical ifTrue:[
        gc fillRectangleX:mar y:hy width:(width - mar - mar) height:barHeightInt.
        (handleStyle notNil
        and:[handleStyle ~~ #none]) ifTrue:[
            (handleStyle ~~ #normal 
            and:[handleStyle ~~ #mswindows]) ifTrue:[
                m := (maxKnob - h) // 2.

                shadowForm isNil ifTrue:[

                    y := hy + (barHeightInt // 2).   "/ center of the bar

                    separatingLine ifTrue:[
                        gc paint:shadowColor.
                        gc displayLineFromX:mar y:y toX:(width - mar) y:y.
                        y := y + 1.
                        gc paint:lightColor.
                        gc displayLineFromX:mar y:y toX:(width - mar) y:y.
                        gc paint:viewBackground.
                    ].

                    gc fillRectangleX:(hx - barWidthInt) y:hy 
                       width:(barWidthInt + barWidthInt) height:h.

                    handleStyle == #line ifTrue:[
                        gc paint:handleColor.
                        gc displayLineFromX:hx - barWidthInt y:y toX:hx + barWidthInt y:y
                    ] ifFalse:[
                        y := hy.   
                        handleStyle == #st80 ifTrue:[
                            y := y - 1
                        ].
                        ym := y + m.

                        handleStyle == #full ifTrue:[
                            handleLevel ~~ 0 ifTrue:[
                                self 
                                    drawEdgesForX:0 "/ -(handleLevel abs)
                                    y:ym "/-1
                                    width:width "/+(handleLevel+handleLevel)abs
                                    height:h-2 
                                    level:handleLevel
                                    shadow:shadowColor 
                                    light:lightColor
                                    halfShadow:nil 
                                    halfLight:nil 
                                    style:nil 
                            ]
                        ] ifFalse:[
                            handleLevel ~~ 0 ifTrue:[
                                self drawEdgesForX:(hx - barWidthInt)
                                                 y:ym
                                             width:(barWidthInt + barWidthInt)
                                            height:h 
                                             level:handleLevel.
                            ].

                            handleStyle == #iris ifTrue:[
                                gc paint:handleColor.
                                gc fillDeviceRectangleX:(hx - barWidthInt + 2) y:(ym + 2)
                                   width:(barWidthInt + barWidthInt - 4) height:h - 4
                            ]
                        ]
                    ].
                ] ifFalse:[
                    y := hy.
                    (shadowForm notNil or:[lightForm notNil]) ifTrue:[
                        self drawHandleFormAtX:hx y:(y + m)
                    ]
                ].

                handleStyle == #st80 ifTrue:[
                    y := hy - 1.
                    gc paint:lightColor.
                    gc displayLineFromX:mar y:y toX:(width - mar - mar - 1) y:y.
                    gc displayLineFromX:0 y:hy toX:0 y:(hy + knobHeight - 1).
                    y := hy + knobHeight - 2.
                    gc paint:shadowColor.
                    gc displayLineFromX:mar y:y toX:(width - mar) y:y.
                        "uncomment the -1 if you don't like the notch at the right end"
                        "                            VVV"
                    gc displayLineFromX:width-1 y:hy" "-1" " toX:width-1 y:(hy + knobHeight - 1 - 1).
                ].
            ] ifFalse:[
                y := hy + barHeightInt - 1.
                gc paint:handleColor.
                separatingLine ifTrue:[
                    gc displayLineFromX:0 y:hy+1 toX:width y:hy+1.
                    gc displayLineFromX:0 y:y toX:width y:y.
                ].
                gc fillRectangleX:hx y:hy width:barWidthInt height:barHeightInt.
            ].
        ].
        lbl := self handleLabelAt:hIndex.
        lbl notNil ifTrue:[
            hIndex ~~ 1 ifTrue:[
                gc paint:self blackColor.
                lbl displayOn:self x:mar y:hy + (lbl ascentOn:self)
"/                lbl isImageOrForm ifTrue:[
"/                    lbl displayOn:self x:mar y:hy
"/                ] ifFalse:[
"/                    lbl displayOn:self x:mar y:hy + font ascent + 1
"/                ]
            ]
        ].

    ] ifFalse:[
        gc fillRectangleX:hx y:mar width:barHeightInt height:(height - mar - mar).

        (handleStyle notNil
        and:[handleStyle ~~ #none]) ifTrue:[
            (handleStyle ~~ #normal
            and:[handleStyle ~~ #mswindows]) ifTrue:[
                "/ m := (barHeightInt - w) // 2.
                m := (maxKnob - w) // 2.
                shadowForm isNil ifTrue:[
                    x := hx + (barHeightInt // 2).
                    separatingLine ifTrue:[
                        gc paint:shadowColor.
                        gc displayLineFromX:x y:mar toX:x y:(height - mar).
                        x := x + 1.
                        gc paint:lightColor.
                        gc displayLineFromX:x y:mar toX:x y:(height - mar).
                        gc paint:viewBackground.
                    ].
                    gc fillRectangleX:hx y:(hy - barWidthInt) 
                       width:w height:(barWidthInt + barWidthInt).

                    handleStyle == #line ifTrue:[
                        gc paint:handleColor.
                        gc displayLineFromX:x y:hy - barWidthInt toX:x y:hy + barWidthInt.
                    ] ifFalse:[
                        x := hx.
                        handleStyle == #st80 ifTrue:[
                            x := x - 1.
                        ].
                        xm := x + m.
                        handleStyle == #full ifTrue:[
                            handleLevel ~~ 0 ifTrue:[
                                self 
                                    drawEdgesForX:xm "/-1
                                    y:0 "/ -handleLevel
                                    width:w-2
                                    height:height "/ +handleLevel+handleLevel 
                                    level:handleLevel
                                    shadow:shadowColor 
                                    light:lightColor
                                    halfShadow:nil 
                                    halfLight:nil 
                                    style:nil
                            ]
                        ] ifFalse:[
                            handleLevel ~~ 0 ifTrue:[
                                self drawEdgesForX:xm y:(hy - barWidthInt)
                                     width:w height:(barWidthInt + barWidthInt)
                                     level:handleLevel.
                            ].
                            handleStyle == #iris ifTrue:[
                                gc paint:handleColor.
                                gc fillDeviceRectangleX:(xm + 2) y:(hy - barWidthInt + 2)
                                   width:w - 4 height:(barWidthInt + barWidthInt - 4)
                            ].
                        ].
                    ]
                ] ifFalse:[
                    x := hx.
                    (shadowForm notNil or:[lightForm notNil]) ifTrue:[
                        self drawHandleFormAtX:(x + m) y:hy
                    ]
                ].
                handleStyle == #st80 ifTrue:[
                    x := hx - 1.
                    gc paint:lightColor.
                    gc displayLineFromX:x y:mar toX:x y:(height - mar).
                    gc displayLineFromX:hx y:0 toX:(hx + barHeightInt - 1) y:0.
                    x := hx + barHeightInt - 2.
                    gc paint:shadowColor.
                    gc displayLineFromX:x y:mar toX:x y:(height - mar).
                        "uncomment the -1 if you dont like the notch at the bottom end"
                        "                   VVV"
                    gc displayLineFromX:hx" "-1" " y:height-1 toX:(hx + barHeightInt - 1) y:height-1.
                ].
            ] ifFalse:[
                x := hx + barHeightInt - 1.
                gc paint:handleColor.
                separatingLine ifTrue:[
                    gc displayLineFromX:hx+1 y:0 toX:hx+1 y:height.
                    gc displayLineFromX:x y:0 toX:x y:height.
                ].
                gc fillRectangleX:hx y:hy width:barHeightInt height:barWidthInt
            ]
        ]
    ].

    "Modified: / 29.7.1998 / 22:48:33 / cg"
!

drawHandleFormAtX:hx y:hy
    "draw a handle's bitmap at hx/hy"

    shadowForm notNil ifTrue:[
        gc paint:shadowColor.
        gc displayForm:shadowForm x:hx y:hy.
    ].
    lightForm notNil ifTrue:[
        gc paint:lightColor.
        gc displayForm:lightForm x:hx y:hy.
    ].
    gc paint:viewBackground

    "Modified: 7.11.1996 / 20:25:33 / cg"
!

drawSnapAt:anIndex
    "draw the snap for a handle at an index"

    |snapLayout icon level offLevel paint canChangeExtent
     left   "{ Class:SmallInteger }"
     top    "{ Class:SmallInteger }"
     width  "{ Class:SmallInteger }"
     height "{ Class:SmallInteger }"
     snapMode leftEdge wEdge topEdge hEdge part wPart hPart|

    (snapLayout := self snapLayoutAt:anIndex) isNil ifTrue:[
        "snap disabled"
        ^ self
    ].

    left   := snapLayout left.
    top    := snapLayout top.
    width  := snapLayout width.
    height := snapLayout height.
    snapMode := self snapMode.

    offLevel := level := (snapAdornment level ? 0).

    canChangeExtent := self canChangeExtentOfViewAt:anIndex.
    canChangeExtent ifTrue:[
        (controller isSnapEntered:anIndex) ifTrue:[
            controller isSnapPressed ifTrue:[
                level := snapAdornment selectedLevel ? 0.
                paint := snapAdornment selectedBgColor.
            ] ifFalse:[
                level := snapAdornment enterLevel ? 0.
                paint := snapAdornment enterBgColor.
            ].
        ]
    ].
    paint isNil ifTrue:[
        paint := viewBackground.
    ].

    gc paint:paint.

"/    level == 0 ifTrue:[
"/    ].

    gc fillRectangleX:left+1 y:top+1 width:width-2 height:height-2.

    level ~~ 0 ifTrue:[
        leftEdge := left + 1.
        wEdge := wPart := width - 2.
        topEdge := top + 1.
        hEdge := hPart := height - 2.

        orientation == #vertical ifTrue:[
            wPart := width // 3.
        ] ifFalse:[
            hPart := height // 3.
        ].

        level < 0 ifTrue:[
            part := (self subViews at:anIndex) objectAttributeAt:#snapPart.
            part == #left ifTrue:[
                self drawEdgesForX:leftEdge y:topEdge width:wEdge height:hEdge level:offLevel.
                wPart := wPart + 1.
            ] ifFalse:[
                part == #middle ifTrue:[
                    self drawEdgesForX:leftEdge y:topEdge width:wEdge height:hEdge level:offLevel.
                    orientation == #vertical ifTrue:[
                        leftEdge := leftEdge + wPart.
                    ] ifFalse:[
                        topEdge := topEdge + hPart.
                    ]
                ] ifFalse:[
                    part == #right ifTrue:[
                        self drawEdgesForX:leftEdge y:topEdge width:wEdge height:hEdge level:offLevel.
                        orientation == #vertical ifTrue:[
                            leftEdge := leftEdge + (width - wPart - 1).
                        ] ifFalse:[
                            topEdge := topEdge + (height - hPart - 1).
                        ].
                        wPart := wPart - 1.
                    ]
                ]
            ].
            wEdge := wPart.
            hEdge := hPart.
        ].
        self drawEdgesForX:leftEdge y:topEdge width:wEdge height:hEdge level:level.
    ].

    canChangeExtent ifFalse:[^ self].

    snapMode == #both ifTrue:[
        icon := (orientation == #vertical) 
                    ifTrue:[snapAdornment iconUpDown] 
                    ifFalse:[snapAdornment iconLeftRight]
    ] ifFalse:[
        (self snapAtIndexWillGrow:anIndex) ifTrue:[
            icon := (orientation == #vertical) 
                        ifTrue:[snapAdornment iconDown] 
                        ifFalse:[snapAdornment iconRight]
        ] ifFalse:[
            icon := (orientation == #vertical) 
                        ifTrue:[snapAdornment iconUp]   
                        ifFalse:[snapAdornment iconLeft]
        ].
    ].

    icon displayOn:self x:(left + ((width - icon width) // 2))
                        y:(top  + ((height - icon height) // 2)).

    "Modified: / 31-10-2010 / 12:58:27 / cg"
!

invertHandleBarAtX:hx y:hy
    |doLine oldStyle|

    doLine := (trackLine == #solidLine 
               or:[trackLine == #dashedLine
               or:[trackLine == #dottedLine]]).

    trackLine == #dashedLine ifTrue:[
        oldStyle := gc lineStyle.
        gc lineStyle:#dashed.
    ] ifFalse:[
        trackLine == #dottedLine ifTrue:[
            oldStyle := gc lineStyle.
            gc lineStyle:#dotted.
        ]
    ].

    gc clippedByChildren:false.

    self xoring:[
        |yL xL halfHeight|

        halfHeight := (barHeight // 2) - 1.

        orientation == #vertical ifTrue:[
            yL := hy + halfHeight.
            doLine ifTrue:[
                gc displayLineFromX:0 y:yL toX:width y:yL.
            ] ifFalse:[
                gc fillRectangleX:0 y:hy width:width height:barHeight
            ]
        ] ifFalse:[
            xL := hx + halfHeight.
            doLine ifTrue:[
                gc displayLineFromX:xL y:0 toX:xL y:height.
            ] ifFalse:[
                gc fillRectangleX:hx y:0 width:barHeight height:height
            ]
        ].
    ].
    gc clippedByChildren:true.

    oldStyle notNil ifTrue:[
        gc lineStyle:oldStyle.
    ].

    "Modified: / 28.4.1997 / 14:56:26 / dq"
    "Modified: / 3.5.1999 / 18:49:04 / cg"
!

lockRedraw
    redrawLocked := true
!

redraw
    "redraw all of the handles"

    redrawLocked ~~ true ifTrue:[
        "/ self clear.
        self redrawHandlesFrom:1 to:(self subViews size)
    ]

    "Modified: 28.1.1997 / 17:54:15 / cg"
!

redrawHandlesFrom:start to:stop
    "redraw some handles and snaps"

    subViews size ~~ 0 ifTrue:[
        self handleOriginsWithIndexFrom:start to:stop do:[:hPoint :hIndex |
            |hx hy|

            hx := hPoint x.
            hy := hPoint y.
            barLevel notNil ifTrue:[
                self drawEdgesForX:0 y:hy width:width height:barHeight level:barLevel.
            ].

            "/ do not draw handle, if there is a snapper ...
            self hasSnapHandle ifTrue:[
                self drawSnapAt:hIndex-1
            ] ifFalse:[
                showHandle ifTrue:[
                    self drawHandle:hIndex atX:hx y:hy.
                ].
            ].
        ].
    ].

    "Modified: / 31-10-2010 / 12:43:33 / cg"
!

unlockRedraw
    redrawLocked := false
! !

!VariablePanel methodsFor:'enumerating subviews'!

changeSequenceOrderFor:aSubView to:anIndex
    "change a subview's position in the subviews collection."

    |success|

    success := super changeSequenceOrderFor:aSubView to:anIndex.
    success ifTrue:[
        self setupSubviews.
        self resizeSubviews.
    ].
    ^ success
! !

!VariablePanel methodsFor:'event handling'!

pointerEnter:buttonState x:x y:y
    showHandleWhenEntered == true ifTrue:[
        self showHandle:true
    ].
    super pointerEnter:buttonState x:x y:y.

    "Created: / 19-12-2010 / 09:29:51 / cg"
!

pointerLeave:buttonState
    showHandleWhenEntered == true ifTrue:[
        self showHandle:false
    ].
    super pointerLeave:buttonState.

    "Created: / 19-12-2010 / 09:30:20 / cg"
!

sizeChanged:how
    "my size has changed; resize my subviews"

    realized ifTrue:[
        (how == #smaller) ifTrue:[
            self resizeSubviews
        ] ifFalse:[
            "/
            "/ do it in reverse order, to avoid some redraws
            "/
            self resizeSubviewsFrom:(self subViews size) to:1
        ]
    ].
    self changed:#sizeOfView with:how.
    superView notNil ifTrue:[
        superView subViewChangedSize
    ]

    "Modified: 28.1.1997 / 17:56:30 / cg"
! !

!VariablePanel methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false


! !

!VariablePanel methodsFor:'initialization & release'!

computeBarHeight
    "compute the height if the separating bar from either the
     form or an explicit height given in the styleSheet"

    <resource: #style (#'variablePanel.barHeight'
                       #'variablePanel.barHeightMM')>

    |bH h lvl|

    shadowForm notNil ifTrue:[
        bH := shadowForm height + 2.
    ] ifFalse:[
        bH := styleSheet at:#'variablePanel.barHeight'.
        bH isNil ifTrue:[
            h := styleSheet at:#'variablePanel.barHeightMM' default:2.
            bH := (h * device verticalPixelPerMillimeter) rounded.
        ].
    ].
    lvl := styleSheet at:#'variablePanel.barLevel' default:0.
    lvl ~~ 0 ifTrue:[
        bH := bH + (lvl abs * 2).
    ].

    self barHeight:bH.
    knobHeight := bH.

    handleLabels notNil ifTrue:[
        bH := handleLabels inject:bH into:[:maxSoFar :thisLabel |
                                           thisLabel isNil ifTrue:[
                                                maxSoFar
                                           ] ifFalse:[
                                                maxSoFar max:(thisLabel heightOn:self)
                                           ]
                                          ].
        bH := bH + gc deviceFont descent - 1
    ].

    self barHeight:bH.

    "Modified: / 29.7.1998 / 14:47:21 / cg"
!

defaultControllerClass
    ^ VariablePanelController
!

initCursor
    "set the cursor - a double arrow"

    cursor := self class 
                cursorForOrientation:orientation
                onDevice:device

    "Modified: / 30.9.1998 / 18:20:35 / cg"
!

initStyle
    "setup viewStyle specifics"

    |mm|

    super initStyle.

    handleColor := DefaultHandleColor onDevice:device.

    DefaultHandleStyle isNil ifTrue:[
        handleStyle := styleSheet name
    ] ifFalse:[
        handleStyle := DefaultHandleStyle
    ].

    handleLevel := DefaultHandleLevel.
    showHandle := DefaultShowHandle.
    showHandleWhenEntered := DefaultShowHandleWhenEntered.
    handlePosition := DefaultHandlePosition.
    "/ snapHandlePosition := DefaultSnapHandlePosition.
    trackLine := DefaultTrackingLine.
    separatingLine := DefaultSeparatingLine.

    DefaultHandleImage notNil ifTrue:[
        shadowForm := DefaultHandleImage onDevice:device.
        barWidth := shadowForm width.
    ] ifFalse:[
        handleStyle == #next ifTrue:[
            DefaultHandleImage notNil ifTrue:[
                shadowForm := DefaultHandleImage onDevice:device.
            ] ifFalse:[
                shadowForm := self class shadowFormOn:device.
                lightForm := self class lightFormOn:device.
            ].
            barWidth := shadowForm width.
        ] ifFalse:[
            shadowForm := lightForm := nil.

            mm := device verticalPixelPerMillimeter.
            barWidth := (1.5 * mm) rounded. "motif style width"
        ].
    ].
    barWidth := styleSheet at:#'variablePanel.barWidth' default:barWidth.
    
    self computeBarHeight.

    handleStyle == #mswindows ifTrue:[
        barWidth := (ArrowButton new direction:#up) width + 1 
    ].

    "Modified: / 19-12-2010 / 09:31:29 / cg"
!

initialize
    orientation isNil ifTrue:[orientation := #vertical].
    super initialize.
    self bitGravity:nil.

    
    "Modified: / 29.7.1998 / 16:07:23 / cg"
! !

!VariablePanel methodsFor:'private'!

anyNonRelativeSubviews
    "return true, if any of my subviews has no relative origin/extent"

    self subViews do:[:aComponent |
        aComponent relativeCorner isNil ifTrue:[^ true].
        aComponent relativeOrigin isNil ifTrue:[^ true]
    ].
    ^ false

    "Modified: 28.1.1997 / 17:57:26 / cg"
!

expandSubView:expandedView
    "expand one of my subviews to full size"

    |pos subViews|

    realRelativeSizes notNil ifTrue:[
        "/ already expanded ..
        ^ self
    ].

    pos := 0.0. 
    subViews := self subViews.

    orientation == #vertical ifTrue:[
        realRelativeSizes := subViews collect:[:v | v relativeCorner y - v relativeOrigin y].
    ] ifFalse:[
        realRelativeSizes := subViews collect:[:v | v relativeCorner x - v relativeOrigin x].
    ].

    subViews do:[:aSubView |
        aSubView == expandedView ifTrue:[
            aSubView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
            pos := 1.0
        ] ifFalse:[
            aSubView beInvisible.

            orientation == #vertical ifTrue:[
                aSubView origin:(0.0 @ pos) corner:(1.0 @ pos)
            ] ifFalse:[
                aSubView origin:(pos @ 0.0) corner:(pos @ 1.0)
            ]
        ]
    ].
    self resizeSubviews.

    "Modified: 28.1.1997 / 17:56:20 / cg"
!

handleLabelAt:hIndex
    handleLabels notNil ifTrue:[
        ^ handleLabels at:hIndex ifAbsent:nil
    ].
    ^ nil
!

handleOriginsWithIndexDo:aBlock
    "evaluate the argument block for every handle-origin"

    self handleOriginsWithIndexFrom:1 to:(self subViews size) do:aBlock

    "Modified: 28.1.1997 / 17:53:44 / cg"
!

handleOriginsWithIndexFrom:start to:stop do:aBlock
    "evaluate the argument block for some handle-origins"

    |x y hw hh hDelta vDelta subViews
     first "{ Class: SmallInteger }"
     last  "{ Class: SmallInteger }"|

    (subViews := self subViews) notNil ifTrue:[
        shadowForm notNil ifTrue:[
            hw := shadowForm width.
            hh := shadowForm height.
        ] ifFalse:[
            hw := hh := barWidth
        ].

        (handleStyle ~~ #normal and:[handleStyle ~~ #mswindows]) ifTrue:[
            hDelta := barWidth // 2.
            vDelta := barWidth // 2.
        ] ifFalse:[
            hDelta := vDelta := 0
        ].

        (handlePosition == #left) ifTrue:[
            x := hDelta. 
            y := vDelta.

            orientation == #vertical ifTrue:[
                x := x + barWidth
            ] ifFalse:[
                y := y + barWidth
            ].
            margin ~~ 0 ifTrue:[
                x := x + 2
            ].
        ] ifFalse:[
            (handlePosition == #right) ifTrue:[
                x := width - hw - margin - hDelta.
                y := height - hh - margin - vDelta.
            ] ifFalse:[
                x := width - barWidth // 2.
                y := height - barWidth // 2
            ]
        ].
        first := start + 1.
        last := stop.

        first to:last do:[:index |
            |view|

            view := subViews at:index.
            orientation == #vertical ifTrue:[
                y := view top "origin y" - barHeight + 1.
            ] ifFalse:[
                x := view left "origin x" - barHeight + 1.
            ].
            aBlock value:(x @ y) value:index
        ]
    ]

    "Modified: / 1.11.1997 / 11:53:40 / cg"
!

redrawIfShown
    shown ifTrue:[
        self clear.
    ].
    self invalidate
!

resizeSubViewsTo:relativeSizeList
    "change subviews sizes as defined in the argument list
     (a collection of relative sizes)"

    |pos subViews|

    subViews := self subViews.

    pos := 0.0.
    subViews with:relativeSizeList do:[:aSubView :relSize |
        orientation == #vertical ifTrue:[
            aSubView origin:(0.0 @ pos) corner:(1.0 @ (pos + relSize))
        ] ifFalse:[
            aSubView origin:(pos @ 0.0) corner:((pos + relSize) @ 1.0)
        ].
        pos := pos + relSize.
    ].
    self resizeSubviews.

!

resizeSubviews
    "readjust size of all subviews"

    self resizeSubviewsFrom:1 to:(self subViews size)

    "Modified: 28.1.1997 / 17:54:42 / cg"
    "Modified: 22.3.1997 / 01:01:31 / stefan"
!

resizeSubviewsFrom:start to:stop
    "readjust size of some subviews"

    |step nSubviews subViews bhHalf|

    subViews := self subViews.
    nSubviews := subViews size.
    nSubviews == 0 ifTrue:[ ^ self ].

    bhHalf := barHeight // 2.
    "/ Transcript showCR:barHeight.    
    (start <= stop) ifTrue:[
        step := 1
    ] ifFalse:[
        step := -1
    ].
    start to:stop by:step do:[:index |
        |bw view o1 o2 newOrg newCorner newExt|

        view := subViews at:index.
        bw := view borderWidth.

        index == 1 ifTrue:[
            o1 := 0.
        ] ifFalse:[
            barHeight odd ifTrue:[
                o1 := bhHalf + 1 - bw
            ] ifFalse:[    
                o1 := bhHalf - bw
            ].
        ].
        index == nSubviews ifTrue:[
            o2 := 0.
        ] ifFalse:[
            o2 := (barHeight-bhHalf) - bw
        ].

        newOrg := view computeOrigin.
        "/ Transcript showCR:newOrg.
        newOrg notNil ifTrue:[
            (index ~~ 1) ifTrue:[
                orientation == #vertical ifTrue:[
                    newOrg y:(newOrg y + o1)
                ] ifFalse:[
                    newOrg x:(newOrg x + o1)
                ]
            ].
        ].
        newExt := view computeExtent.
        "/ Transcript show:view layout;show:' -> '.
        "/ Transcript show:view relativeExtent;show:' -> '.
        "/ Transcript showCR:newExt.
        newExt notNil ifTrue:[
            orientation == #vertical ifTrue:[
                newExt y:(newExt y - o2 - o1)
            ] ifFalse:[
                newExt x:(newExt x - o2 - o1)
            ]
        ].
        "/ Transcript showCR:(newOrg extent:newExt).
        view pixelOrigin:newOrg extent:newExt.
    ].
    shown ifTrue:[
        "/ must clear, since handles are copied automatically (by bitGravity)
        "/ self clearAndInvalidate.
        self sensor pushUserEvent:#clearAndInvalidate for:self withArguments:#()
    ]

    "Modified: / 22.3.1997 / 01:02:21 / stefan"
    "Modified: / 23.2.2000 / 18:32:37 / cg"
!

restoreSubViewRatios
    "restore my subviews sizes to the state before the full-expand"

    |pos|

    realRelativeSizes isNil ifTrue:[
        "/ not expanded - ignore
        ^ self
    ].

    pos := 0.0.
    self subViews with:realRelativeSizes do:[:aSubView :aRelativeSize |
        orientation == #vertical ifTrue:[
            aSubView origin:(0.0 @ pos) corner:(1.0 @ (pos+aRelativeSize))
        ] ifFalse:[
            aSubView origin:(pos @ 0.0) corner:((pos+aRelativeSize) @ 1.0)
        ].
        pos := pos + aRelativeSize.

        aSubView shown ifFalse:[
            aSubView hiddenOnRealize:false.
            shown ifTrue:[aSubView beVisible].
        ].
    ].
    realRelativeSizes := nil.
    self resizeSubviews.

    "Modified: 28.1.1997 / 17:56:20 / cg"
!

setupSubviewOrigins
    "setup subviews origins 
     if we only have relative extents 
     (Variable Panels need relative origins and corners!!) (SV 16.1.95)"

    |x y e eX eY subViews n "{ Class: SmallInteger }"|

    x := y := 0.0.

    subViews := self subViews.
    n := subViews size.
    1 to:n do:[:index |
        |view|

        view := subViews at:index.
        e := view relativeExtent.
        e notNil ifTrue:[
            view relativeExtent:nil.
            eX := e x.
            eY := e y.
            index == n ifTrue:[
                view origin:(x @ y) corner:(1.0 @ 1.0)
            ] ifFalse:[
                orientation == #vertical ifTrue:[
                    view origin:(x @ y) corner:(1.0 @ (y+eY))
                ] ifFalse:[
                    view origin:(x @ y) corner:((x+eX) @ 1.0)
                ].
            ].
            orientation == #vertical ifTrue:[
                y := y + eY.
            ] ifFalse:[    
                x := x + eX.
            ]
        ] ifFalse: [
            view origin:(x @ y).
            orientation == #vertical ifTrue:[
                y := view relativeCorner y.
            ] ifFalse:[
                x := view relativeCorner x.
            ]
        ].
    ]

    "Modified: 21.8.1996 / 10:01:29 / stefan"
    "Modified: 28.1.1997 / 17:55:21 / cg"
!

setupSubviews
    "setup subviews sizes (in case of non-relative sizes)"

    |pos delta subViews nSubViews "{ Class: SmallInteger }"|

    "/ setup all subviews to spread evenly ...

    subViews := self subViews.
    nSubViews := subViews size.
    nSubViews == 0 ifTrue:[^ self].

    pos := 0.0. 
    delta := 1.0 / nSubViews.

    1 to:nSubViews do:[:index |
        |view org corn|

        view := subViews at:index.
        orientation == #vertical ifTrue:[
            org := (0.0 @ pos). 
            index == subViews size ifTrue:[
                corn := (1.0 @ 1.0)
            ] ifFalse:[
                corn := (1.0 @ (pos + delta))
            ].
        ] ifFalse:[
            org := (pos @ 0.0).
            index == subViews size ifTrue:[
                corn := (1.0 @ 1.0)
            ] ifFalse:[
                corn := ((pos + delta) @ 1.0)
            ].
        ].
        view origin:org corner:corn.
        pos := pos + delta
    ]

    "Modified: / 23.2.2000 / 18:14:01 / cg"
! !

!VariablePanel methodsFor:'private-snap queries'!

canChangeExtentOfViewAt:anIndex
    "returns true if extent at an index is changable
    "
    |view|

    view := subViews at:anIndex ifAbsent:[^ false].

    orientation == #vertical ifTrue:[
        view height > 2 ifFalse:[
            view := subViews at:(anIndex + 1) ifAbsent:[^ false].
            ^ view height > 2
        ].
        ^ true
    ].

    view width > 2 ifFalse:[
        view := subViews at:(anIndex + 1) ifAbsent:[^ false].
        ^ view width > 2
    ].
    ^ true
!

initSnapAdornment
    |num icon level enterLevel selectedLevel color|

    snapAdornment isNil ifTrue:[

        snapAdornment := SnapAdornment "IdentityDictionary" new.

        level         := styleSheet at:#'variablePanel.snapLevel'      default:1.
        enterLevel    := styleSheet at:#'variablePanel.snapEnterLevel' default:level.
        selectedLevel := styleSheet at:#'variablePanel.selectedLevel'  default:(level negated).

        snapAdornment level:level.
        snapAdornment enterLevel:enterLevel.
        snapAdornment selectedLevel:selectedLevel.
        snapAdornment mode:#min.

        color := styleSheet 
                    colorAt:#'variablePanel.snapSelectedBgColor'
                    default:(StyleSheet colorAt:#'button.activeBackgroundColor').
        color notNil ifTrue:[
            snapAdornment selectedBgColor:(color onDevice:device)
        ].

        color := StyleSheet 
                    colorAt:#'variablePanel.snapEnterBgColor'
                    default:(StyleSheet colorAt:#'button.enteredBackgroundColor').
        color notNil ifTrue:[
            snapAdornment enterBgColor:(color onDevice:device)
        ].

        self class snapIcons keysAndValuesDo:[:aKey :anIcon|
            anIcon device == device ifTrue:[
                icon := anIcon
            ] ifFalse:[
                icon := anIcon copy onDevice:device.
                device == Display ifTrue:[
                    self class snapIcons at:aKey put:icon.
                ]
            ].
            snapAdornment at:aKey put:icon
        ].
        "compute required snap extent including level and margins ..."

        num  := level abs max:(enterLevel abs).
        num  := num max:(selectedLevel abs).
        num  := (num + 2) "margin into handle := 1" * 2.
        icon := snapAdornment iconUp.

        snapAdornment height:(icon height + num).
        snapAdornment width:(icon width  + num).
    ].

    ^ snapAdornment

    "Modified: / 31-10-2010 / 12:59:39 / cg"
!

snapAtIndexWillGrow:anIndex
    "returns true if the view assigned to the snap at an index will grow
     if pressing the snap
    "
    |view mode|

    (mode := self snapMode) notNil ifTrue:[
        (mode == #max or:[mode == #maxMin]) ifTrue:[
            "on press the view is increased to bottom(vertical) or right(horizontal)"
            view := subViews at:(anIndex + 1) ifAbsent:[^ false].
            ^ orientation == #vertical ifTrue:[view height > 2] ifFalse:[view width  > 2]
        ].    

        (mode == #min or:[mode == #minMax]) ifTrue:[
            "on press the view is decreased to top(vertical) or left (horizontal)"
            view := subViews at:anIndex ifAbsent:[^ false].
            ^ orientation == #vertical ifTrue:[view height <= 2] ifFalse:[view width  <= 2]
        ].

        self error:'unexepected snapMode state'.
    ].    
    ^ false     "snap is disabled"
!

snapLayoutAt:anIndex
    "returns the layout of the snap at an index
     or nil if snaps are disabled
    "
    |v1 v2 left top right bot w snapX snapY|

    self hasSnapHandle ifFalse:[^ nil].         "snap disabled"

    v1 := subViews at:anIndex     ifAbsent:[^ nil].
    v2 := subViews at:anIndex + 1 ifAbsent:[^ nil].
    w  := snapAdornment width ? 0.

    handlePosition "snapHandlePosition" == #left ifTrue:[
        snapX := snapY := margin. "/ ViewSpacing.
    ] ifFalse:[
        handlePosition "snapHandlePosition" == #right ifTrue:[
            snapX := width - w.
            snapY := height - w.
        ] ifFalse:[
            snapX := (width - w) // 2.
            snapY := (height - w) // 2.
        ].
    ].

    orientation == #vertical ifTrue:[
        left := snapX. "/ v1 width - w // 2.
        top := v1 bottom + 1.
        right := left + w.
        bot := v2 top.
    ] ifFalse:[
        top := snapY. "/ v1 height - w // 2.
        left := v1 right + 1.
        right := v2 left.
        bot := top + w.
    ].
    ^ Rectangle left:left top:top right:right bottom:bot

    "Modified: / 31-10-2010 / 12:47:16 / cg"
! !

!VariablePanel methodsFor:'queries'!

hasSnapHandle
    ^ snapAdornment notNil

    "Created: / 31-10-2010 / 12:43:21 / cg"
!

isHorizontal
    ^ orientation == #horizontal
!

isLayoutWrapper
    "answer true, if this view defines the layout of it's subviews"

    ^ true
! !

!VariablePanel methodsFor:'realization'!

fixSize 
    super fixSize.
    self extentChangedFlag ifTrue:[
        self resizeSubviews
    ].

    "Modified: 22.3.1997 / 01:19:55 / stefan"
!

realize
    super realize.
    self anyNonRelativeSubviews ifTrue:[
        self setupSubviews.
        self sizeChanged:nil.   "/ force recomputation of subviews
    ].
! !

!VariablePanel::SnapAdornment methodsFor:'accessing'!

enterBgColor
    ^ enterBgColor
!

enterBgColor:something
    enterBgColor := something.
!

enterLevel
    ^ enterLevel
!

enterLevel:something
    enterLevel := something.
!

height
    ^ height
!

height:something
    height := something.
!

iconDown
    ^ iconDown
!

iconDown:something
    iconDown := something.
!

iconLeft
    ^ iconLeft
!

iconLeft:something
    iconLeft := something.
!

iconLeftRight
    ^ iconLeftRight
!

iconLeftRight:something
    iconLeftRight := something.
!

iconRight
    ^ iconRight
!

iconRight:something
    iconRight := something.
!

iconUp
    ^ iconUp
!

iconUp:something
    iconUp := something.
!

iconUpDown
    ^ iconUpDown
!

iconUpDown:something
    iconUpDown := something.
!

level
    ^ level
!

level:something
    level := something.
!

mode
    ^ mode
!

mode:something
    mode := something.
!

selectedBgColor
    ^ selectedBgColor
!

selectedBgColor:something
    selectedBgColor := something.
!

selectedLevel
    ^ selectedLevel
!

selectedLevel:something
    selectedLevel := something.
!

width
    ^ width
!

width:something
    width := something.
! !

!VariablePanel::SnapAdornment methodsFor:'backward compatibility'!

at:key 
    ^ self perform:key

    "Created: / 31-10-2010 / 12:38:58 / cg"
!

at:key ifAbsent:default
    |value|

    value := self perform:key.
    ^ value ? default

    "Created: / 31-10-2010 / 12:41:10 / cg"
!

at:key put:aValue
    self perform:key asMutator with:aValue

    "Created: / 31-10-2010 / 12:38:48 / cg"
! !

!VariablePanel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

