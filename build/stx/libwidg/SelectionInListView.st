"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

ListView subclass:#SelectionInListView
	instanceVariableNames:'selection actionBlock enabled hilightFgColor hilightBgColor
		hilightFgColorNoFocus hilightBgColorNoFocus halfIntensityFgColor
		doubleClickActionBlock listAttributes multipleSelectOk clickLine
		selectMode selectionAtClickTime initialSelectionMsg printItems
		oneItem useIndex hilightLevel hilightFrameColor ignoreReselect
		arrowLevel smallArrow keyActionStyle returnKeyActionStyle
		toggleSelect strikeOut iSearchString items doubleClickMsg
		hilightStyle clickPosition allowDrag dragObjectConverter
		dragIsActive endDragAction dropSource visualBlock
		selectedVisualBlock selectConditionBlock isButtonPressActive'
	classVariableNames:'RightArrowShadowForm RightArrowLightForm RightArrowForm
		SmallRightArrowShadowForm SmallRightArrowLightForm
		DefaultForegroundColor DefaultBackgroundColor
		DefaultHilightForegroundColor DefaultHilightBackgroundColor
		DefaultHilightFrameColor DefaultHilightLevel
		DefaultRightArrowStyle DefaultRightArrowLevel
		DefaultDisabledForegroundColor DefaultShadowColor
		DefaultLightColor DefaultHilightStyle
		DefaultHilightForegroundColorNoFocus
		DefaultHilightBackgroundColorNoFocus'
	poolDictionaries:''
	category:'Views-Lists'
!

!SelectionInListView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this one is a ListView with a selected line (which is shown highlighted)
    If multipleSelectionsOk is true, it is also allowed to shift-click multiple 
    entries.
    If toggleSelect is true, clicking toggles (i.e. click on a seleted item
    will deselect).

    Whenever the selection changes, an action-block is evaluated, passing the 
    current selection as argument.
    Currently, the selection can be nil, aNumber or a collection of numbers; 
    this will change to be either nil or a collection, making selection handling 
    easier in the future. (this stupid behavior is due to the multiple
    select feature being added later - the first implementation used to support
    only single selections).

    The actionBlock is called with the current selection (single number or
    collection of numbers) as argument.

    Also, to support ST-80 MVC-style use, the model (if nonNil) is notified
    by the change mechanism (performs changeMsg) and vice versa, the view
    updates if the model changes (with aspect of either #list or #selectionIndex).

    Before actually adding entries to the selection, a checkBlock (if non-nil) is evaluated 
    passing the number of the entry whch is about to be selected as argument.
    The select change operation is only done if this returns true. This allows
    interception of select, for example to query the user if he/she wants to save
    the old contents before (see uses in SystemBrowser and FileBrowser), or to
    disable individual entries.

    It is also possible to select entries with the keyboard; use the cursor up/
    down keys to select prev/next, Home- and End-keys to select first/last. 
    Use the return key to apply the double-click-action to the current selection.
    Also, alphabetic keys will select the next entry starting with that key.

    The keyboard behavior can be further controlled with the keyActionStyle
    instance variable (see SelectionInListView>>keyActionStyle:).

    Finally, ignoreReselect controls if pressing on an already selected item
    triggers the action or not. For some applications it is useful to allow
    reselects (for example, the SystemBrowsers method-list updates the
    source code in this case).

    Currently, some limited form of line attributes are supported. These
    are kept in the instance variable lineAttributes.
    This may change (using mechanisms similar to MultiColListEntry), so
    be prepared. (don't use the listAttributes instvar directly; if possible,
    use MultiColListEntry or subclasses of it.

    Although currently based on the listAttributes instVar, the implementation of
    text attributes will be changed in the near future (when Text/DisplayText are
    available). 
    However, the protocol will probably be kept for backward compatibility
    (i.e. use #attributeAt: / #attributeAt:put etc. - at least, these are easy to find
    when migrating to the new attributed text handling).

    [Instance variables:]
        selection               <misc>          the current selection. nil, a number or collection of numbers

        actionBlock             <Block>         block to be evaluated on selection changes
                                                (1-arg blocks gets selectionIndex or selectionValue
                                                 as arg - depending upon the useIndex setting)

        useIndex                <Boolean>       if true, the index of a selection is passed to
                                                the actionBlock or stuffed into the selection valueHolder;
                                                if false, the seelction-value is passed.

        enabled                 <Boolean>       true: selection changes allowed; false: ignore clicks

        hilightFgColor
        hilightBgColor          <Color>         how highlighted items are drawn

        halfIntensityColor      <Color>         foreground for disabled items

        selectCondition         <Block>         if non-nil, this block can decide if selection is ok.
                                or              its invoked with the itemNr of the
                                <ValueHolder>   'to-be-selected' item.
                                                If the block returns true, the item is selected
                                                (or added to the selection); if false is returned,
                                                no action is taken.
        selectionChangeCondition
                                <Block>         much like above, but invoked without argument,
                                or              on any change of the selection (i.e. also when items
                                <ValueHolder>   are deselected).
                                                Can return false to suppress change.

        doubleClickActionBlock  <Block>         action to perform on double-click
                                                (1-arg blocks gets selectionIndex or selectionValue
                                                 as arg - depending upon the useIndex setting)

        listAttributes                          dont use - will vanish

        hilightLevel            <Integer>       level to draw selections (i.e. for 3D effect)
        hilightFrameColor       <Color>         rectangle around highlighted items

        multipleSelectOk        <Boolean>       if true, multiple selections (with shift) are ok.
                                                default: false

        ignoreReselect          <Boolean>       if true, selecting same again does not trigger action;
                                                if false, every select triggers it.
                                                default: true

        toggleSelect            <Boolean>       if true, click toggles;
                                                if false, click selects.
                                                default: false

        arrowLevel              <Integer>       level to draw right-arrows (for submenus etc.)
        smallArrow              <Boolean>       if true, uses a small arrow bitmap

        listMsg                                 if non-nil, use ST-80 style (model-access)
        initialSelectionMsg 
        printItems 
        oneItem

        keyActionStyle          <Symbol>        controls how to respond to keyboard selects

        returnKeyActionStyle    <Symbol>        controls how to respond to return key

    written spring/summer 89 by claus
    3D Jan 90 by claus
    multiselect Jun 92 by claus
    keyboard-select jun 94 by claus

    [author:]
        Claus Gittinger
"
!

examples
"
    SelectionInListView can be used both in the ST/X way, using action blocks
    or in the traditional mvc way.
    with actions:

      basic interface:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:#('one' 'two' 'three').
        slv action:[:index | Transcript showCR:'selected ' , index printString].

        top add:slv in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      get element instead of index:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:#('one' 'two' 'three').
        slv action:[:element | Transcript showCR:'selected ' , element printString].
        slv useIndex:false.

        top add:slv in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      concrete example; show filenames:
      (notice: normally, you would use a FileSelectionList)
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | 
            Transcript showCR:'selected ' , index printString.
            Transcript showCR:' the value is: ', slv selectionValue].

        top add:slv in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      add a scrollbar:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      allow reselect
      (clicking on already selected entry 
       triggers action/changeNotification again):
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv ignoreReselect:false.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      allow multiple selections (shift-select):
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:indexList | Transcript showCR:'selected ' , indexList printString].
        slv multipleSelectOk:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      same, not using index:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:indexList | Transcript showCR:'selected ' , indexList printString].
        slv multipleSelectOk:true; useIndex:false.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      strikeout mode (single):
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv strikeOut:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


      strikeout mode (multiple):
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv strikeOut:true; multipleSelectOk:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      toggleSelect mode (clicking on selected entry deselects it):
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv toggleSelect:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      define what to do on double-click:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv doubleClickAction:[:index | Transcript showCR:'doubleclick on ' , index printString].

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      enable / disable:
                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv disable.
        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open.
        Delay waitForSeconds:5. 
        slv enable.
                                                                        [exEnd]

      enable / disable via a channel:
                                                                        [exBegin]
        |top slv enableChannel t|

        enableChannel := true asValue.
        t := Toggle label:'enable'.
        t model:enableChannel.
        t open.

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:(Filename currentDirectory directoryContents).
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv enableChannel:enableChannel.
        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open.
                                                                        [exEnd]

    using a Model:
                                                                        [exBegin]
        |top slv model|

        model := Plug new.
        model respondTo:#getList with:[#('foo' 'bar' 'baz' 'hello')].
        model respondTo:#initial with:[1].
        model respondTo:#setSelection: with:[:arg | Transcript showCR:'model selected:', arg printString].

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView 
                   on:model
                   aspect:#someAspect
                   change:#setSelection:
                   list:#getList
                   initialSelection:#initial.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      notice, that the ST-80 behavaior on reselect is to send a selection change
      with an index of 0.

    same, with useIndex false:
                                                                        [exBegin]
        |top slv model|

        model := Plug new.
        model respondTo:#getList with:[#('foo' 'bar' 'baz' 'hello')].
        model respondTo:#initial with:['bar'].
        model respondTo:#setSelection: with:[:arg | Transcript showCR:'model selected:', arg printString].

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView 
                   on:model
                   aspect:#someAspect
                   change:#setSelection:
                   list:#getList
                   initialSelection:#initial.
        slv useIndex:false.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


    self changing list: 
    (selectionInListView updates itself when button changes initial selection):
                                                                        [exBegin]
        |top slv model sel changeButton|

        sel := 'bar'.
        model := Plug new.
        model respondTo:#getList with:['getList' printNL. #('foo' 'bar' 'baz' 'hello')].
        model respondTo:#initial with:['initial' printNL. sel].
        model respondTo:#setSelection: with:[:arg | ('model selected:', arg) printNL. sel := arg].

        changeButton := Button label:'change selection'.
        changeButton action:[sel := 'foo'. model changed:#initial].
        changeButton open.

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView 
                   on:model
                   aspect:#someAspect
                   change:#setSelection:
                   list:#getList
                   initialSelection:#initial.
        slv useIndex:false.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]


    using a SelectionInList-Model:
    (see how changes in the model (via list:...) are reflected in the view)
                                                                        [exBegin]
        |top slv model|

        model := SelectionInList with:#('foo' 'bar' 'baz' 'hello').
        model selection:'bar'.

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView on:model.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open.

        InspectorView openOn:model monitor:'selectionIndexHolder'
                                                                        [exEnd]


    two selectionInListViews on the same selectionInList model:
                                                                        [exBegin]
        |top1 slv1 top2 slv2 model|

        model := SelectionInList with:#('foo' 'bar' 'baz' 'hello').

        top1 := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv1 := SelectionInListView on:model.

        top1 add:(ScrollableView forView:slv1) in:(0.0@0.0 corner:1.0@1.0).
        top1 open.

        top2 := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv2 := SelectionInListView on:model.

        top2 add:(ScrollableView forView:slv2) in:(0.0@0.0 corner:1.0@1.0).
        top2 open.
                                                                        [exEnd]


    a MultiSelectionInList model:
                                                                        [exBegin]
        |top slv model|

        model := MultiSelectionInList with:#('foo' 'bar' 'baz' 'hello').
        model selection:#('foo' 'bar').

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView on:model.
        slv multipleSelectOk:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open.

        InspectorView openOn:model monitor:'selectionIndexHolder'
                                                                        [exEnd]

    with strikeOut:
                                                                        [exBegin]
        |top slv model|

        model := MultiSelectionInList with:#('foo' 'bar' 'baz' 'hello').
        model selection:#('foo' 'bar').

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView on:model.
        slv multipleSelectOk:true; toggleSelect:true; strikeOut:true.

        top add:(ScrollableView forView:slv) in:(0.0@0.0 corner:1.0@1.0).
        top open.

        InspectorView openOn:model monitor:'selectionIndexHolder'
                                                                        [exEnd]


    two listViews on the same list, but separate selections
                                                                        [exBegin]
        |top top2 lv1 lv2 selInL1 selInL2 listHolder l1 l2|

        top := StandardSystemView new extent:300@300.

        lv1 := SelectionInListView origin:0.0@0.0 corner:1.0@0.5 in:top.
        lv1 level:-1.
        lv1 toggleSelect:true.

        lv2 := SelectionInListView origin:0.0@0.5 corner:1.0@1.0 in:top.
        lv2 level:-1.
        lv2 toggleSelect:true.

        selInL1 := SelectionInList new.
        selInL2 := SelectionInList new.

        listHolder := #('foo' 'bar' 'baz') asValue.

        selInL1 listHolder:listHolder.
        selInL2 listHolder:listHolder.

        lv1 model:selInL1.
        lv2 model:selInL2.

        top open.

        top2 := StandardSystemView new extent:100 @ 30.
        l1 := Label origin:0.0@0.0 corner:0.5@1.0 in:top2.
        l2 := Label origin:0.5@0.0 corner:1.0@1.0 in:top2.

        l1 model:(BlockValue with:[:arg | arg value printString] argument:selInL1 selectionIndexHolder).
        l2 model:(BlockValue with:[:arg | arg value printString] argument:selInL2 selectionIndexHolder).

        l1 labelMessage:#value.
        l2 labelMessage:#value.

        top2 open.

        Delay waitForSeconds:2.
        listHolder value:#('1' '2' '3' '4').
                                                                        [exEnd]
    non-string entries (text)
                                                                        [exBegin]
        |top l slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        l := OrderedCollection new.
        l add:(Text string:'red' emphasis:(#color->Color red)).
        l add:(Text string:'green' emphasis:(#color->Color green)).
        l add:(Text string:'blue' emphasis:(#color->Color blue)).
        slv list:l.
        slv action:[:index | Transcript showCR:'selected ' , index printString].

        top add:slv in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]

      non string entries
                                                                        [exBegin]
        |top slv wrapper l fileImage dirImage m|

        dirImage := Image fromFile:'DirObj.xbm'.
        fileImage := Image fromFile:'FileObj.xbm'.


        l := OrderedCollection new.
        Filename currentDirectory directoryContents do:[:s |
            s asFilename isDirectory ifTrue:[
                l add:(LabelAndIcon icon:dirImage string:s)
            ] ifFalse:[
                l add:(LabelAndIcon icon:fileImage string:s)
            ]
        ].

        m := SelectionInList new.
        m list:l.

        slv := SelectionInListView new.
        slv model:m.
        wrapper := HVScrollableView forView:slv miniScrollerH:true.

        top := StandardSystemView extent:150@200.
        top add:wrapper in:(0.0@0.0 corner:1.0@1.0).
        top open.
                                                                        [exEnd]

                                                                        [exBegin]
        |top slv|

        top := StandardSystemView new
                label:'select';
                minExtent:100@100;
                maxExtent:300@400;
                extent:200@200.

        slv := SelectionInListView new.
        slv list:#('one' 'two' 'three').
        slv action:[:index | Transcript showCR:'selected ' , index printString].
        slv multipleSelectOk:true.
        slv allowDrag:true.

        top add:slv in:(0.0@0.0 corner:1.0@1.0).
        top open
                                                                        [exEnd]
"

    "Modified: 26.10.1995 / 16:42:02 / cg"
! !

!SelectionInListView class methodsFor:'instance creation'!

on:aModel aspect:aspect change:change list:list initialSelection:initial
    ^ self on:aModel
	    printItems:true 
	    oneItem:false 
	    aspect:aspect
	    change:change 
	    list:list 
	    menu:nil 
	    initialSelection:initial 
	    useIndex:true 
!

on:aModel aspect:aspect change:change list:list menu:menu initialSelection:initial
    ^ self on:aModel
	    printItems:true 
	    oneItem:false 
	    aspect:aspect
	    change:change 
	    list:list 
	    menu:menu
	    initialSelection:initial 
	    useIndex:true 
!

on:aModel printItems:print oneItem:one aspect:aspect
	      change:change list:list menu:menu initialSelection:initial

    "for ST-80 compatibility"

    ^ self on:aModel 
	    printItems:print 
	    oneItem:one 
	    aspect:aspect
	    change:change 
	    list:list 
	    menu:menu
	    initialSelection:initial
	    useIndex:false 
!

on:aModel printItems:print oneItem:one aspect:aspect change:change 
		list:list menu:menu initialSelection:initial useIndex:useIndex

    "for ST-80 compatibility"

    ^ (self new) on:aModel 
		 printItems:print 
		 oneItem:one 
		 aspect:aspect
		 change:change 
		 list:list 
		 menu:menu
		 initialSelection:initial
		 useIndex:useIndex
! !

!SelectionInListView class methodsFor:'defaults'!

defaultAspectMessage
    ^ nil
!

defaultBackgroundColor
    ^ DefaultBackgroundColor
!

defaultChangeMessage
    ^ #selectionIndex: 
!

defaultListMessage
    ^ #list 
!

defaultSelectionMessage
    ^ #selectionIndex 
!

rightArrowFormOn:aDevice
    "return the form used for the right arrow (non 3D)"

    <resource: #style (#'selection.rightArrowForm' #'selection.rightArrowFormFile')>

    |f fn bits|

    ((aDevice == Display) and:[RightArrowForm notNil]) ifTrue:[
        ^ RightArrowForm
    ].

    f := self styleSheet at:#'selection.rightArrowForm'.
    f isNil ifTrue:[
        fn := StyleSheet at:#'selection.rightArrowFormFile' default:'RightArrow.xbm'.
        f := Smalltalk imageFromFileNamed:fn forClass:self.
        f notNil ifTrue:[
            f := f onDevice:aDevice.
        ] ifFalse:[
            DefaultRightArrowStyle == #solid ifTrue:[
                bits := #[2r00000000 2r00000000 
                          2r00000000 2r00000000 
                          2r00000000 2r00000000 
                          2r00000010 2r00000000 
                          2r00000011 2r00000000 
                          2r00000011 2r10000000 
                          2r00000011 2r11000000 
                          2r00000011 2r11100000 
                          2r00000011 2r11110000 
                          2r00000011 2r11100000
                          2r00000011 2r11000000 
                          2r00000011 2r10000000 
                          2r00000011 2r00000000
                          2r00000010 2r00000000 
                          2r00000000 2r00000000 
                          2r00000000 2r00000000]
            ] ifFalse:[
                bits := #[2r00000000 2r00000000 
                          2r00000000 2r00000000 
                          2r00000000 2r00000000 
                          2r00000110 2r00000000 
                          2r00000101 2r00000000 
                          2r00000100 2r10000000 
                          2r00000100 2r01000000 
                          2r00000100 2r00100000 
                          2r00000100 2r00010000 
                          2r00000100 2r00100000
                          2r00000100 2r01000000 
                          2r00000100 2r10000000 
                          2r00000101 2r00000000
                          2r00000110 2r00000000 
                          2r00000000 2r00000000 
                          2r00000000 2r00000000]
            ].
            f := Form width:16 height:16 fromArray:bits onDevice:aDevice
        ]
    ].
    (aDevice == Display) ifTrue:[
        RightArrowForm := f
    ].
    ^ f

    "Modified: / 5.8.1998 / 00:04:40 / cg"
!

rightArrowLightFormOn:aDevice
    "return the form used for the right arrow light pixels (3D only)"

    |f|

    ((aDevice == Display) and:[RightArrowLightForm notNil]) ifTrue:[
        ^ RightArrowLightForm
    ].
    f := Smalltalk imageFromFileNamed:'RightArrowLight.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDevice.
    ] ifFalse:[
        f := Form width:16 height:16 fromArray:#[2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000110 2r00000000 
                                                 2r00000101 2r00000000 
                                                 2r00000100 2r10000000 
                                                 2r00000100 2r01000000 
                                                 2r00000100 2r00100000 
                                                 2r00000100 2r00000000 
                                                 2r00000100 2r00000000
                                                 2r00000100 2r00000000 
                                                 2r00000100 2r00000000 
                                                 2r00000100 2r00000000
                                                 2r00000100 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000]
                                              onDevice:aDevice
    ].
    (aDevice == Display) ifTrue:[
        RightArrowLightForm := f
    ].
    ^ f

    "Modified: 1.1.1970 / 14:10:42 / cg"
!

rightArrowShadowFormOn:aDevice
    "return the form used for the right arrow light pixels (3D only)"

    |f|

    ((aDevice == Display) and:[RightArrowShadowForm notNil]) ifTrue:[
        ^ RightArrowShadowForm
    ].
    f := Smalltalk imageFromFileNamed:'RightArrowShadow.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDevice.
    ] ifFalse:[
        f := Form width:16 height:16 fromArray:#[2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00010000 
                                                 2r00000000 2r00100000
                                                 2r00000000 2r01000000 
                                                 2r00000000 2r10000000 
                                                 2r00000001 2r00000000
                                                 2r00000010 2r00000000 
                                                 2r00000000 2r00000000 
                                                 2r00000000 2r00000000]
                                              onDevice:aDevice
    ].
    (aDevice == Display) ifTrue:[
        RightArrowShadowForm := f
    ].
    ^ f

    "Modified: 1.1.1970 / 01:00:00 / cg"
!

smallRightArrowLightFormOn:aDevice
    "return the form used for the small right arrow light pixels (3D only)"

    |f|

    ((aDevice == Display) and:[SmallRightArrowLightForm notNil]) ifTrue:[
        ^ SmallRightArrowLightForm
    ].
    f := Smalltalk imageFromFileNamed:'SmallRightArrowLight.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDevice.
    ] ifFalse:[
        f := Form width:9 height:9 fromArray:#[2r00000000 2r00000000 
                                               2r01100000 2r00000000 
                                               2r01011000 2r00000000 
                                               2r01000110 2r00000000 
                                               2r01000000 2r00000000 
                                               2r01000000 2r00000000 
                                               2r01000000 2r00000000 
                                               2r01000000 2r00000000 
                                               2r00000000 2r00000000]
                                              onDevice:aDevice
    ].
    (aDevice == Display) ifTrue:[
        SmallRightArrowLightForm := f
    ].
    ^ f

    "Modified: 19.12.1996 / 14:10:59 / cg"
!

smallRightArrowShadowFormOn:aDevice
    "return the form used for the small right arrow light pixels (3D only)"

    |f|

    ((aDevice == Display) and:[SmallRightArrowShadowForm notNil]) ifTrue:[
        ^ SmallRightArrowShadowForm
    ].
    f := Smalltalk imageFromFileNamed:'SmallRightArrowShadow.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDevice.
    ] ifFalse:[
        f := Form width:9 height:9 fromArray:#[2r00000000 2r00000000 
                                               2r00000000 2r00000000 
                                               2r00000000 2r00000000 
                                               2r00000000 2r00000000 
                                               2r00000001 2r00000000 
                                               2r00000110 2r00000000 
                                               2r00011000 2r00000000 
                                               2r00100000 2r00000000 
                                               2r00000000 2r00000000]
                                              onDevice:aDevice
    ].
    (aDevice == Display) ifTrue:[
        SmallRightArrowShadowForm := f
    ].
    ^ f

    "Modified: 19.12.1996 / 14:11:10 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'selection.disabledForegroundColor'
                       #'selection.hilightForegroundColor' #'selection.hilightBackgroundColor'
                       #'selection.hilightForegroundColorNoFocus' #'selection.hilightBackgroundColorNoFocus'
                       #'selection.hilightFrameColor' #'selection.hilightLevel'
                       #'selection.rightArrowStyle' #'selection.rightArrowLevel'
                       #'selection.foregroundColor' #'selection.backgroundColor'
                       #'selection.shadowColor' #'selection.lightColor'
                       #'selection.font' #'selection.hilightStyle')>

    DefaultDisabledForegroundColor := StyleSheet colorAt:#'selection.disabledForegroundColor'.
    DefaultHilightForegroundColor := StyleSheet colorAt:#'selection.hilightForegroundColor'.
    DefaultHilightBackgroundColor := StyleSheet colorAt:#'selection.hilightBackgroundColor'.
    DefaultHilightForegroundColorNoFocus := StyleSheet colorAt:#'selection.hilightForegroundColorNoFocus'.
    DefaultHilightBackgroundColorNoFocus := StyleSheet colorAt:#'selection.hilightBackgroundColorNoFocus'.
    DefaultHilightFrameColor := StyleSheet colorAt:#'selection.hilightFrameColor'.
    DefaultHilightLevel := StyleSheet at:#'selection.hilightLevel' default:0.
    DefaultHilightStyle := StyleSheet at:#'selection.hilightStyle' default:(StyleSheet name).
    DefaultRightArrowStyle := StyleSheet at:#'selection.rightArrowStyle'.
    DefaultRightArrowLevel := StyleSheet at:#'selection.rightArrowLevel'.
    DefaultForegroundColor := StyleSheet colorAt:#'selection.foregroundColor'.
    DefaultBackgroundColor := StyleSheet colorAt:#'selection.backgroundColor'.
    DefaultShadowColor := StyleSheet colorAt:#'selection.shadowColor'.
    DefaultLightColor := StyleSheet colorAt:#'selection.lightColor'.
    DefaultFont := StyleSheet fontAt:#'selection.font'.
    RightArrowForm := nil.

    "
     self updateStyleCache
    "

    "Modified: 20.10.1997 / 14:04:26 / cg"
! !

!SelectionInListView methodsFor:'Compatibility-ST80'!

isSingleSelect:aBool
    self multipleSelectOk:aBool not
!

sequence
    "same as #list - for ST80 compatibility"

    ^ self list

    "Created: / 21.6.1998 / 02:46:50 / cg"
!

setValidTargetIndex:index
    "ignored for now - for ST80 compatibility"

    ^ self

    "Created: / 4.2.2000 / 00:07:14 / cg"
!

targetIndex:index
    self selection:index
! !

!SelectionInListView methodsFor:'accessing-actions'!

action
    "return the action block to be performed on select.
     With useIndex==true, the block gets the selectionIndex as arg,
     otherwise, it gets the selectionValue."

    ^ actionBlock
!

action:aBlock
    "set the action block to be performed on select.
     With useIndex==true, the block gets the selectionIndex as arg,
     otherwise, it gets the selectionValue."

    actionBlock := aBlock
!

doubleClickAction:aOneArgBlock
    "set the double click action block.
     If non-nil, that one is evaluated on double click, passing the
     selection-line-number (useIndex==true) or selectionValue (useIndex==false) as argument."

    doubleClickActionBlock := aOneArgBlock

    "Modified: 24.2.1996 / 16:07:28 / cg"
!

keyActionStyle:aSymbol
    "defines how the view should respond to alpha-keys pressed.
     Possible values are:
	#select               -> will select next entry starting with that
				 character and perform the click-action

	#selectAndDoubleclick -> will select next & perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #select
    "

    keyActionStyle := aSymbol
!

returnKeyActionStyle:aSymbol
    "defines how the view should respond to a return key pressed.
     Possible values are:
	#doubleClick          -> perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #doubleClick 
    "

    returnKeyActionStyle := aSymbol
!

selectConditionBlock
    "get the select-conditionBlock; this block is evaluated before 
     any selection change is performed (passing the to-be-changed item index as arg).
     The change will not be done, if the block returns false. 
     For example, this allows confirmation queries in the SystemBrowser"

    ^ selectConditionBlock

    "Created: / 29-07-2011 / 13:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectConditionBlock:aBlock
    "set the select-conditionBlock; this block is evaluated before 
     any selection change is performed (passing the to-be-changed item index as arg).
     The change will not be done, if the block returns false. 
     For example, this allows confirmation queries in the SystemBrowser"

    selectConditionBlock := aBlock
!

useIndex
    "set/clear the useIndex flag. If set, both actionBlock and change-messages
     are passed the index(indices) of the selection as argument. 
     If clear, the value(s) (i.e. the selected string) is passed.
     Default is true."

    ^ useIndex
!

useIndex:aBoolean
    "set/clear the useIndex flag. If set, both actionBlock and change-messages
     are passed the index(indices) of the selection as argument. 
     If clear, the value(s) (i.e. the selected string) is passed.
     Default is true."

    useIndex ~~ aBoolean ifTrue:[
        useIndex := aBoolean.
        useIndex ifTrue:[
            changeMsg == #selection: ifTrue:[
                changeMsg := #selectionIndex:.
                aspectMsg := #selectionIndex.
            ]
        ] ifFalse:[
            changeMsg == #selectionIndex: ifTrue:[
                changeMsg := #selection:.
                aspectMsg := #selection.
            ]
        ].
    ].

! !

!SelectionInListView methodsFor:'accessing-attributes'!

attributeAt:index
    "return the line attribute of list line index.
     currently supported are:
         #halfIntensity
         #disabled
         #bold
    "

    listAttributes notNil ifTrue:[
        (index > listAttributes size) ifFalse:[
            ^ listAttributes at:index
        ]
    ].
    ^ nil
!

attributeAt:index add:aSymbolOrCollectionOfSymbols
    "add to a lines attribute(s); 
     currently supported are:
	 #halfIntensity
	 #disabled
	 #bold 
    "

    |current|

    current := self attributeAt:index.
    current isNil ifTrue:[
	current := Set new.
    ] ifFalse:[
	current isSymbol ifTrue:[
	    current == aSymbolOrCollectionOfSymbols ifTrue:[^ self].
	    current := Set with:current
	]
    ].

    aSymbolOrCollectionOfSymbols isSymbol ifTrue:[
	current := current add:aSymbolOrCollectionOfSymbols
    ] ifFalse:[
	(current includes:aSymbolOrCollectionOfSymbols) ifTrue:[^ self].
	current addAll:aSymbolOrCollectionOfSymbols
    ].
    self attributeAt:index put:current
!

attributeAt:index put:aSymbolOrCollectionOfSymbolsOrNil
    "set a lines attribute(s); 
     currently supported are:
         #halfIntensity
         #disabled
         #bold 
    "

    (index > self size) ifFalse:[
        listAttributes isNil ifTrue:[
            listAttributes := OrderedCollection newWithSize:index
        ] ifFalse:[
            listAttributes ensureSizeAtLeast:index.
        ].
        aSymbolOrCollectionOfSymbolsOrNil = (listAttributes at:index) ifFalse:[
            listAttributes at:index put:aSymbolOrCollectionOfSymbolsOrNil.
            self redrawLine:index
        ]
    ]
!

attributeAt:index remove:aSymbolOrCollectionOfSymbols
    "remove a line attribute; 
     currently supported are:
	 #halfIntensity
	 #disabled
	 #bold 
    "

    |current|

    current := self attributeAt:index.
    current isNil ifTrue:[^ self].
    current isSymbol ifTrue:[
	aSymbolOrCollectionOfSymbols isSymbol ifTrue:[
	    current == aSymbolOrCollectionOfSymbols ifTrue:[current := nil]
	] ifFalse:[
	    (aSymbolOrCollectionOfSymbols includes:current) ifTrue:[
		current := nil
	    ]
	]
    ] ifFalse:[
	aSymbolOrCollectionOfSymbols isSymbol ifTrue:[
	    current := current remove:aSymbolOrCollectionOfSymbols ifAbsent:[]
	] ifFalse:[
	    aSymbolOrCollectionOfSymbols removeAll:aSymbolOrCollectionOfSymbols
	]
    ].
    self attributeAt:index put:current
!

line:lineNr hasAttribute:aSymbol
    "return true, if line nr has attribute, aSymbol; 
     currently supported attributes are:
	 #halfIntensity
	 #disabled
	 #bold 
    "

    |attr|

    listAttributes isNil ifTrue:[^ false].
    (lineNr > listAttributes size) ifTrue:[^ false].
    attr := listAttributes at:lineNr.
    attr isNil ifTrue:[^ false].
    attr isSymbol ifTrue:[^ attr == aSymbol].
    ^ (attr includes:aSymbol)
!

setAttributes:aList
    "set the attribute list.
     No redraw is done - the caller should make sure to redraw afterwards
     (or use this only before the view is visible)."

    listAttributes := aList
!

strikeOut:aBoolean
    "turn on/off strikeOut mode"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #strikeout:'.
    strikeOut := aBoolean.
!

strikeout:aBoolean
    "turn on/off strikeOut mode"

    strikeOut := aBoolean.
! !

!SelectionInListView methodsFor:'accessing-behavior'!

dragObjectConverter:aBlock
    "set an optional dragObject converter;
     if non-nil, this one will be evaluated on a drag-start,
     for each dropItem as argument, and supposed
     to convert it into a dragObject and return it.
     If it returns nil, the object will not be dropped.
     Useful, if the receiver view represents fileNames or other
     names of the actual objects to be dragged."

    dragObjectConverter := aBlock

    "Created: 6.4.1997 / 12:16:11 / cg"
    "Modified: 6.4.1997 / 14:12:45 / cg"
!

enabled
   "return true if selections are possible"

   ^ enabled.

    "Created: 29.1.1997 / 12:40:54 / stefan"
!

enabled:aBoolean
    "enable/disable the view - selection changes are allowed/disallowed"

    enabled := aBoolean

    "Modified: / 30.3.1999 / 15:26:10 / stefan"
!

ignoreReselect:aBoolean
    "set/clear the ignoreReselect flag - 
     if set, a click on an already selected entry is ignored.
     Otherwise the notification is done, even if no
     change in the selection occurs.
     (for example, in browser to update a method).
     Setting ignoreReselect to false makes sense if data is shown
     which may change by itself (i.e. without the user doing anything)
     For example, the inspector uses this, and redisplays the value,
     if the selection is the same.
     The default is true, meaning that a click on an already selected
     does not lead to a notification via the actionBlock/change mechanism."

    "note by ca: 
        multiple selection on: the ignoreReselect will have no influence
    "
    ignoreReselect := aBoolean
!

multipleSelectOk
    ^ multipleSelectOk
!

multipleSelectOk:aBoolean
    "allow/disallow multiple selections. If enabled, the
     user may select multiple entries in the list, and the program
     always gets a collection of selected items (indexes if useIndex is true,
     values otherwise). The default is false, for single selections."

    multipleSelectOk := aBoolean.

!

toggleSelect:aBoolean
    "turn on/off toggle select. 
     If true, clicking on a selected entry unselects it and vice versa. 
     The default is false, which means
     that clicking on an already selected entry does not change its
     select status (see also ignoreReselect:, which has higher prio and is checked first)."

    toggleSelect := aBoolean.
! !

!SelectionInListView methodsFor:'accessing-channels'!

listHolder
    ^ listChannel
!

listHolder:aListHolder
    listChannel notNil ifTrue:[
        listChannel removeDependent:self
    ].
    (listChannel := aListHolder) notNil ifTrue:[
        listChannel addDependent:self
    ].
    self getListFromModel
! !

!SelectionInListView methodsFor:'accessing-contents'!

add:aValue beforeIndex:index
    "must recompute our current selections"

    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            selection := selection collect:[ :sel |
                sel >= index ifTrue:[
                    sel + 1
                ] ifFalse:[
                    sel
                ]
            ].
        ] ifFalse:[
            selection >= index ifTrue:[
                selection := selection + 1.
            ].
        ].
    ].
    ^ super add:aValue beforeIndex:index.
!

contents:aCollection
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes.
     No redraw is done - the caller should make sure to redraw afterwards
     (or use this only before the view is visible)."

    selection := nil.
    listAttributes := nil.
    super contents:aCollection.
!

list:aCollection
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes."

    self list:aCollection keepSelection:false 
!

list:aCollection keepSelection:aBoolean
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes."

    |oldSelection|

    "somewhat of a kludge: if selection is first line,
     we have to remove the highlight frame by hand here"

    (shown and:[hilightLevel ~~ 0]) ifTrue:[
        selection == firstLineShown ifTrue:[
           gc paint:bgColor.
           gc fillRectangleX:margin y:margin
              width:(width - (margin * 2)) height:(hilightLevel abs).
        ].
    ].

    aBoolean ifTrue:[
        oldSelection := selection.
        selection := nil.
    ].
    listAttributes := nil.
    self list:aCollection expandTabs:printItems.
    shown ifTrue:[self invalidate].

    useIndex == true ifTrue:[
        scrollWhenUpdating == #keep ifTrue:[
            self selectWithoutScroll:oldSelection
        ] ifFalse:[
            self setSelection:oldSelection. "/ nil if keep is false
        ].
    ] ifFalse:[
        self getSelectionFromModel.
    ].

    selection ~= oldSelection ifTrue:[
        "/ cannot keep the selection (items removed)
        "/ must tell the model if there is one ....
        self selectionChangedFrom:oldSelection
    ].

    "Modified: / 10-01-2007 / 18:21:31 / cg"
!

printItems:aBoolean
    "set/clear the printItems flag. If set, items (as set via #list: or
     as returned from the model) are sent #printString to display them.
     If false, items are assumed to be either strings, or know how to
     display themself in a GC (i.e. they are instances of ListEntry).
     The default is false.
     Caveat: printString seems to be too specialized - I'd rather have
     a definable printSelector or - better - a printConverter.
     This may be added in the future."

    printItems := aBoolean
!

removeFromIndex:startLineNr toIndex:endLineNr
    "must recompute our current selections"

    |oldSelection|

    selection notNil ifTrue:[
        oldSelection := selection copy.

        "/ a kludge - if the first line is in the selection,
        "/ and the selection is drawn with an extra inverted area around,
        "/ we must invalidate the line before as well.
        (hilightFrameColor notNil or:[hilightStyle == #motif]) ifTrue:[
            (self isInSelection:startLineNr) ifTrue:[
                startLineNr > 1 ifTrue:[
                    self invalidateLine:(startLineNr - 1)
                ]
            ].
        ].

        self checkRemovingSelectionFrom:startLineNr to:endLineNr.
        oldSelection ~= selection ifTrue:[
            "/ cannot keep the selection (items removed)
            "/ must tell the model if there is one ....
            model notNil ifTrue:[model removeDependent:self].
            [
                self selectionChangedFrom:oldSelection
            ] ensure:[
                model notNil ifTrue:[model addDependent:self].
            ].
        ].
    ].
    super removeFromIndex:startLineNr toIndex:endLineNr.
!

removeIndexWithoutRedraw:lineNr
    "delete line - no redraw;
     return true, if something was really deleted.
     Redefined since we have to care for selection"

    |oldSelection|

    selection notNil ifTrue:[
        oldSelection := selection copy.
        self checkRemovingSelection:lineNr.
        oldSelection ~= selection ifTrue:[
            "/ cannot keep the selection (items removed)
            "/ must tell the model if there is one ....
            self selectionChangedFrom:oldSelection
        ]
    ].
    ^ super removeIndexWithoutRedraw:lineNr
!

setContents:aCollection
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes.
     No redraw is done - the caller should make sure to redraw afterwards
     (or use this only before the view is visible)."

    selection := nil.
    listAttributes := nil.
    super setContents:aCollection.
!

setList:aCollection
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes.
     No redraw is done - the caller should make sure to redraw afterwards
     (or use this only before the view is visible)."

    selection := nil.
    listAttributes := nil.
    super setList:aCollection.
! !

!SelectionInListView methodsFor:'accessing-look'!

noHighlighting
    "switch off higlighting of selected lines"

    hilightFgColor := fgColor.
    hilightBgColor := bgColor.
    hilightFrameColor := nil.
    hilightFgColorNoFocus := fgColor.
    hilightBgColorNoFocus := bgColor.
!

selectedVisualBlock
    ^ selectedVisualBlock
!

selectedVisualBlock:aBlock
    "ST-80 compatibility: provide a block, which returns a displayObject to be drawn for
     selected items."

    selectedVisualBlock := aBlock

    "Created: / 27.10.1997 / 19:50:58 / cg"
    "Modified: / 21.6.1998 / 02:40:46 / cg"
!

visualBlock
    ^ visualBlock
!

visualBlock:aBlock
    "ST-80 compatibility: provide a block, which returns a displayObject to be drawn for
     unselected items."

    visualBlock := aBlock

    "Modified: / 21.6.1998 / 02:40:57 / cg"
! !

!SelectionInListView methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    "see comment in View>>modelInterface"

    super addModelInterfaceTo:aDictionary.
    aDictionary at:#doubleClickMessage put:doubleClickMsg.
    aDictionary at:#initialSelectionMessage put:initialSelectionMsg.

    "
     SelectionInListView new modelInterface 
    "
!

doubleClick:aSymbol
    "set the symbol with which the model is informed about double-click.
     OBSOLETE: please use #doubleClickMessage:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'please use #doubleClickMessage:'.
    doubleClickMsg := aSymbol
!

doubleClickMessage
    "return the symbol with which the model (if any) is informed about 
     double-click. If nil (which is the default), it is not informed."

    ^ doubleClickMsg
!

doubleClickMessage:aSymbol
    "set the symbol with which the model (if any) is informed about double-click.
     If nil (which is the default), it is not informed."

    doubleClickMsg := aSymbol
!

initialSelectionMessage
    "return the symbol by which the model informes me about a changed
     selectionIndex. This is used both in change notification and to
     actually acquire a new selection value."

    ^ initialSelectionMsg
!

initialSelectionMessage:aSymbol
    "set the symbol by which the model informes me about a changed
     selectionIndex. This is used both in change notification and to
     actually acquire a new selection value."

    initialSelectionMsg := aSymbol
!

on:aModel aspect:aspectSymbol change:changeSymbol list:listSymbol menu:menuSymbol

    "ST-80 compatibility"

    super on:aModel aspect:aspectSymbol change:changeSymbol list:listSymbol menu:menuSymbol.
    initialSelectionMsg := aspectMsg.
!

on:aModel printItems:print oneItem:one aspect:aspectSymbol change:changeSymbol 
		list:listSymbol menu:menuSymbol initialSelection:initialSymbol useIndex:use

    "ST-80 compatibility"

    aspectMsg := aspectSymbol.
    changeMsg := changeSymbol.
    listMsg := listSymbol.
    menuMsg := menuSymbol.
    initialSelectionMsg := initialSymbol.
    printItems := print.
    oneItem := one.
    useIndex := use.
    ignoreReselect := false.    "/ ST80 behavior
    self model:aModel.
! !

!SelectionInListView methodsFor:'accessing-selection'!

addElementToSelection:anObject
    "add the element with the same printstring as the argument, anObject
     to the selection. The entry is searched by comparing printStrings.
     No scrolling is done. Returns true, if ok, false if no such entry
     was found.
     *** No model and/or actionBlock notification is done here."

    |lineNo str|

    str := anObject printString.
    lineNo := list findFirst:[:entry | str = entry printString].
    lineNo ~~ 0 ifTrue:[
        self addToSelection:lineNo.
        ^ true
    ].
    ^ false

    "Modified: 15.11.1996 / 16:59:43 / cg"
!

addToSelection:aNumber
    "add entry, aNumber to the selection. No scrolling is done.
     *** No model and/or actionBlock notification is done here."

    (self isValidSelection:aNumber) ifFalse:[^ self].

    "/ this item selectable ?
    (selectConditionBlock notNil 
     and:[(selectConditionBlock value:aNumber) not]) ifTrue:[^ self].

    selection isNil ifTrue:[^ self selectWithoutScroll:aNumber].
    selection isCollection ifTrue:[
        (selection includes:aNumber) ifTrue:[^ self].

        "/ to enforce the change-message (value is identical to oldValue)
        selection isList ifTrue:[
            selection add:aNumber
        ] ifFalse:[
            selection := selection asOrderedCollection.
            selection := selection copyWith:aNumber.
        ]
    ] ifFalse:[
        (aNumber == selection) ifTrue:[^ self].
        selection := OrderedCollection with:selection with:aNumber
    ].
    self redrawElement:aNumber

    "Modified: / 11.2.2000 / 01:38:45 / cg"
!

removeFromSelection:aNumber
    "remove entry, aNumber from the selection.
     *** No model and/or actionBlock notification is done here."

    selection isNil ifTrue:[^ self].

    self multipleSelectOk ifTrue:[
        (selection includes:aNumber) ifFalse:[^ self].

        selection isList ifTrue:[
            selection remove:aNumber ifAbsent:nil
        ] ifFalse:[
            "/ to enforce the change-message (value is identical to oldValue)
            selection := selection asOrderedCollection.
            selection := selection copyWithout:aNumber
        ].
        selection size == 0 ifTrue:[
            selection := #()
        ]
    ] ifFalse:[
        (aNumber == selection) ifFalse:[^ self].
        selection := nil
    ].
    self redrawElement:aNumber

    "Modified: / 11.2.2000 / 01:41:24 / cg"
! !

!SelectionInListView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |listValue start stop size idx|

    changedObject == model ifTrue:[
        something == aspectMsg ifTrue:[
            listChannel isNil ifTrue:[
                self getListFromModel
            ].
            self getSelectionFromModel.
            ^ self
        ].
        something == listMsg ifTrue:[
            self getListFromModel.
            ^ self
        ].
        something == initialSelectionMsg ifTrue:[
            self getSelectionFromModel.
            ^ self
        ].
        something == #empty ifTrue:[
            self list:nil.
            ^ self
        ].
    ].
    changedObject == listChannel ifFalse:[
        ^ super update:something with:aParameter from:changedObject
    ].

    something == #remove: ifTrue:[
        self removeIndex:aParameter.
        ^ self
    ].
    something == #removeFrom: ifTrue:[
        start := aParameter first.
        stop  := aParameter last.

        (start == 1 and:[stop == self size]) ifTrue:[
            self getListFromModel
        ] ifFalse:[
            self removeFromIndex:start toIndex:stop.
        ].
        ^ self
    ].

    "/ ca's "optimizations" are only correct if we do not have items
    (items isNil or:[printItems not]) ifTrue:[
        listValue := listChannel value.

        something == #at: ifTrue:[
            idx := aParameter isCollection ifTrue:[aParameter at:1]
                                          ifFalse:[aParameter].
            self at:aParameter put:(listValue at:idx).
            ^ self
        ].

        something == #insert: ifTrue:[
            listValue == list ifTrue:[self halt:'should not happen'].
            self add:(listValue at:aParameter) beforeIndex:aParameter.
            ^ self
        ].

        something == #insertCollection: ifTrue:[
            (size := aParameter last) ~~ 0 ifTrue:[
                (self size == 0 or:[size > 50]) ifTrue:[
                    self getListFromModel
                ] ifFalse:[
                    listValue == list ifTrue:[self halt:'should not happen'].
                    start := aParameter first.
                    "/ self addAll:(listValue copyFrom:start to:start+size-1) beforeIndex:start.
                    size timesRepeat:[
                        self add:(listValue at:start) beforeIndex:start.
                        start := start + 1
                    ]
                ]
            ].
            ^ self
        ].

        something == #replace: ifTrue:[
            start := aParameter first.
            stop  := aParameter last.

            list size = listValue size ifTrue:[
                self replaceFrom:start to:stop with:listValue startingAt:start.
                ^ self
            ].
        ].
    ].

    self getListFromModel.

    "Modified: / 30-03-1999 / 14:27:42 / stefan"
    "Modified: / 21-02-2007 / 15:20:44 / cg"
! !

!SelectionInListView methodsFor:'drag & drop'!

allowDrag:aBoolean
    "enable/disable dragging support"

    allowDrag := aBoolean

    "Created: 14.11.1996 / 15:12:58 / cg"
!

canDrag
    "returns true if dragging is enabled"

    ^ (allowDrag or:[dropSource notNil])
!

dragAutoScroll:aDropContext
    "called by the DragAndDropManager to scroll during a drag/drop operation
     if required (decided by the widget itself); 
     If a scroll is done, return true otherwise false (used to restore the background)"

    |point y dist visLnNr absLnNr nLines scrollUp|

    point := aDropContext targetPoint.
    y := point y.
    visLnNr := self visibleLineOfY:y.
    absLnNr := self visibleLineToAbsoluteLine: visLnNr.

    visLnNr == 1 ifTrue:[
        scrollUp := true.
        absLnNr == 1 ifTrue:[ ^ false ].
        dist := y.
    ] ifFalse:[
        scrollUp := false.
        absLnNr < self size ifFalse:[ ^ false ].
        (self lineIsFullyVisible: absLnNr + 1) ifTrue:[ ^ false ].
        dist := height-y.
    ].
    aDropContext contentsWillChange.

    nLines := 1.

    #(2 4 8) do:[:fraction |
        dist <= (fontHeight / fraction) ifTrue:[
            nLines := fraction.
        ]
    ].

    scrollUp ifTrue:[ 
        self scrollUp:nLines 
    ] ifFalse:[ 
        self scrollDown:nLines 
    ].

    ^ true
!

dropSource
    "returns the dropSource or nil"

    ^ dropSource
!

dropSource:aDropSourceOrNil
    "set the dropSource or nil"

    dropSource := aDropSourceOrNil.
!

startDragAt:aPoint 
    dropSource isNil ifTrue:[
        dragIsActive := true.
        DragAndDropManager 
            startDrag:(self collectionOfDragObjects)
            from:self
            offset:0 @ 0
            atEnd:endDragAction
            display:(self selectionValue).
    ] ifFalse:[
        dropSource startDragIn:self at:aPoint
    ]
! !

!SelectionInListView methodsFor:'drawing'!

drawRightArrowInVisibleLine:visLineNr
    "draw a right arrow (for submenus).
     This method is not used here, but provided for subclasses such
     as menus or file-lists."

    |y x form form2 topLeftColor botRightColor t itemHeight listLine item|

    x := width - 16.
    y := (self yOfVisibleLine:visLineNr).

    listLine := self visibleLineToListLine:visLineNr.
    item := self at:listLine.
    item isNil ifTrue:[
        itemHeight := fontHeight
    ] ifFalse:[
        itemHeight := item heightOn:self.
    ].

    (device depth == 1 or:[arrowLevel == 0]) ifTrue:[
        form := self class rightArrowFormOn:device.
        form notNil ifTrue:[
            y := y + ((itemHeight - form height) // 2).
            self foreground:(
                    (self isInSelection:listLine) 
                        ifTrue:[hilightFgColor] 
                        ifFalse:[fgColor]).
            self displayForm:form x:x y:y.
        ]
    ] ifFalse:[
        smallArrow ifTrue:[
            form := self class smallRightArrowLightFormOn:device.
            form2 := self class smallRightArrowShadowFormOn:device.
        ] ifFalse:[
            form := self class rightArrowLightFormOn:device.
            form2 := self class rightArrowShadowFormOn:device.
        ].
        (form isNil or:[form2 isNil]) ifTrue:[
            "/ very bad conditions
            ^ self
        ].
        y := y + ((itemHeight - form height) // 2).

        topLeftColor := lightColor.
        botRightColor := shadowColor. 

        "openwin arrow stays down"
        styleSheet name ~~ #openwin ifTrue:[
            (self isInSelection:listLine) ifTrue:[
                t := topLeftColor.
                topLeftColor := botRightColor.
                botRightColor := t.
            ]
        ].
        arrowLevel < 0 ifTrue:[
            t := topLeftColor.
            topLeftColor := botRightColor.
            botRightColor := t.
        ].

"/        self foreground:topLeftColor.
self paint:topLeftColor.
        self displayForm:form x:x y:y.
"/        self foreground:botRightColor.
self paint:botRightColor.
        self displayForm:form2 x:x y:y.
    ]
!

drawSelectionHighlightFrameForItemAtY:yLine with:fg
    |wEdge y y2|

    y := yLine - (lineSpacing//2).
    hilightFrameColor notNil ifTrue:[
        hilightLevel == 0 ifTrue:[
            "
             a line above and below
            "
            gc paint:hilightFrameColor.
            gc displayLineFromX:0 y:y toX:width y:y.
            y2 := y + fontHeight - 1.
            gc displayLineFromX:0 y:y2 toX:width y:y2.
            ^ self
        ]
    ] ifFalse:[
        hilightStyle == #motif ifTrue:[
            "/ an additional line, inset by one pixel
            gc paint:fg.
            gc displayLineFromX:0 y:y+1 toX:width y:y+1.
            y2 := y + fontHeight - 1 - 1.
            gc displayLineFromX:0 y:y2 toX:width y:y2.
        ] ifFalse:[
            hilightStyle == #macosx ifTrue:[
                "/ an additional line, at the bottom
                gc paint:viewBackground.
                y2 := y + fontHeight - 1.
                gc displayLineFromX:0 y:y2 toX:width y:y2.
            ]
        ].
    ].

    "
     an edge it around
    "
    (hilightLevel ~~ 0) ifTrue:[
        "
         let edge start at left, extending to the full width
         XXX: widthOfContents should be cached in ListView
              (instead of recomputing all over)
        "
        wEdge := width-(2 * margin).
        includesNonStrings ifFalse:[
            wEdge := wEdge max:(self widthOfContents).
        ].
        self drawEdgesForX:(margin - viewOrigin x) y:y 
                     width:wEdge+viewOrigin x height:fontHeight 
                     level:hilightLevel.
    ].
!

drawVisibleLineSelected:visLineNr
    "redraw a single line as selected."

    |fg bg|

    self hasFocus ifTrue:[
        fg := hilightFgColor.
        bg := hilightBgColor.
    ] ifFalse:[
        fg := hilightFgColorNoFocus.
        bg := hilightBgColorNoFocus.
    ].
    self drawVisibleLineSelected:visLineNr with:fg and:bg

    "Modified: / 31.8.1995 / 19:24:09 / claus"
    "Modified: / 21.6.1998 / 03:12:56 / cg"
!

drawVisibleLineSelected:visLineNr with:fg and:bg
    "redraw a single line as selected."

    |listLine 
     y  "{ Class: SmallInteger }" 
     dObj item t|

    listLine := self visibleLineToListLine:visLineNr.
    listLine isNil ifTrue:[
        super drawVisibleLine:visLineNr with:fg and:bg.
        ^ self.
    ].

    y := self yOfVisibleLine:visLineNr.

    "/ if an explicit drawing block has been defined - let it do it.
    selectedVisualBlock notNil ifTrue:[
        backgroundAlreadyClearedColor == bg ifFalse:[
            gc paint:bg.
            gc fillRectangleX:margin y:y - (lineSpacing//2)
                          width:(width - (2 * margin)) 
                         height:fontHeight.
        ].

        dObj := selectedVisualBlock value:self value:listLine.
        gc paint:fg on:bg.
        dObj displayOn:self x:(textStartLeft-viewOrigin x) y:y + gc font ascent opaque:true.
        
        self drawSelectionHighlightFrameForItemAtY:y with:fg.
        ^ self.
    ].

    strikeOut ifTrue:[
        self drawVisibleLine:visLineNr with:fgColor and:bgColor.

        gc paint:fgColor.
        y := y + (fontHeight // 2).
        gc displayLineFromX:0 y:y toX:width y:y.
        ^ self
    ].

    "/ kludge:
    "/ care for text objects with a color
    "/ if the contrast between the fg-color and the selection-bg is too small,
    "/ the item is not readable anymore ...
    item := list at:listLine.
    (item isText and:[item hasChangeOfEmphasis]) ifTrue:[
        t := Text string:item string emphasisCollection:item emphasis asArray.
        t emphasisAllRemove:#color.
        self
            drawLine:t 
            atX:(textStartLeft - viewOrigin x) 
            inVisible:visLineNr 
            with:fg and:bg
    ] ifFalse:[ 
        (item class == LabelAndIcon
        and:[(t := item string) notNil
        and:[(t isText and:[t hasChangeOfEmphasis])]]) ifTrue:[
            t := Text string:t string emphasisCollection:t emphasis asArray.
            t emphasisAllRemove:#color.
            t := LabelAndIcon icon:item icon string:t.
            t image:(item image).
            t gap:(item gap).
            t offset: (item offset).
            self
                drawLine:t 
                atX:(textStartLeft - viewOrigin x) 
                inVisible:visLineNr 
                with:fg and:bg
        ] ifFalse:[
            self drawVisibleLine:visLineNr with:fg and:bg.
        ]
    ].

    self drawSelectionHighlightFrameForItemAtY:y with:fg.
!

invalidateLine:aLineNr
    |visibleLine y|

    visibleLine := self listLineToVisibleLine:aLineNr.
    visibleLine notNil ifTrue:[
        y := self yOfVisibleLine:visibleLine.
        self invalidate:(Rectangle origin:(0@y-(lineSpacing//2)) extent:(width@fontHeight+lineSpacing))
    ].
!

invalidateSelection
    "invalidate (force async redraw) the current selection"

    shown ifTrue:[
        self selectionDo:[:lineNr| self invalidateLine:lineNr ].
    ].
! !

!SelectionInListView methodsFor:'event handling'!

buttonControlPress:button x:x y:y
    "if multipleSelectOk: add to the selection; 
     otherwise, behave like normal select"

    |oldSelection listLineNr|

    (button == 1) ifTrue:[
"/        toggleSelect ifTrue:[
"/           ^ self buttonPress:button x:x y:y
"/        ].
        selectionAtClickTime := nil.

        enabled ifTrue:[
            listLineNr := self lineAtY:y. "/ self visibleLineToListLine:(self visibleLineOfY:y).
            listLineNr notNil ifTrue:[
                (self lineIsEnabled:listLineNr) ifFalse:[^ self].
            ].
            oldSelection := selection copy.
            listLineNr notNil ifTrue: [
                "/ this item selectable ?
                (selectConditionBlock notNil 
                 and:[(selectConditionBlock value:listLineNr) not]) ifTrue:[^ self].

                self multipleSelectOk ifTrue:[
                    (self isInSelection:listLineNr) ifTrue:[
                        self removeFromSelection:listLineNr.
                        selectMode := false.
                    ] ifFalse:[
                        self addToSelection:listLineNr.
                        selectMode := true.
                    ]
                ] ifFalse:[
                    self selectWithoutScroll:listLineNr
                ]
            ].
            ((ignoreReselect not and:[selection notNil])
             or:[selection ~= oldSelection]) ifTrue:[
                self selectionChangedFrom:oldSelection.
            ].
            clickLine := listLineNr.
        ]
    ] ifFalse:[
        super buttonPress:button x:x y:y
    ]

    "Created: / 14.11.1996 / 15:51:41 / cg"
    "Modified: / 8.8.1998 / 03:24:03 / cg"
!

buttonMotion:buttonState x:x y:y
    "mouse-move while button was pressed - handle selection changes"

    (enabled not or:[dragIsActive]) ifTrue:[
        ^ self
    ].

    "is it the select or 1-button ?"
    buttonState == 0 ifTrue:[^ self].
    self sensor leftButtonPressed ifFalse:[^ self].

    clickLine isNil ifTrue:[^ self].

    self canDrag ifTrue:[
"/        UserPreferences current expandSelectionOnMouseMoveWithButtonPressed not ifTrue:[
"/            clickPosition isNil ifTrue:[
"/                clickPosition := x@y
"/            ]
"/        ].

        (clickPosition notNil) ifTrue:[     "mouse pressed but not released"
            (clickPosition dist:(x@y)) > (UserPreferences current motionDistanceToStartDrag) ifTrue:[
                ^ self startDragAt:clickPosition
            ].
            ^ self
        ]
    ].

    "if moved outside of view, start autoscroll"
    (y < 0) ifTrue:[
        self compressMotionEvents:false.
        self startAutoScrollUp:y.
        ^ self
    ].
    (y > height) ifTrue:[
        self compressMotionEvents:false.
        self startAutoScrollDown:(y - height).
        ^ self
    ].

    (self canDrag 
    and:[x < -5 or:[x > (width+5)]]) ifTrue:[           "visible and out of view"
        ^ self startDragAt:(0 @ y)
    ].

    "move inside - stop autoscroll if any"
    self stopAutoScroll.

    UserPreferences current expandSelectionOnMouseMoveWithButtonPressed ifTrue:[
        (self sensor hasButtonMotionEventFor:self) ifFalse:[
            self expandSelectionToX:x y:y.
        ].
    ].

    "Modified: / 29.1.1997 / 12:15:31 / stefan"
    "Modified: / 23.2.2000 / 12:03:35 / cg"
!

buttonMultiPress:button x:x y:y
    (button == 1) ifTrue:[
"/        doubleClickActionBlock isNil ifTrue:[
"/            self buttonPress:button x:x y:y
"/        ].
        enabled ifFalse:[
            ^ self
        ].
        self doubleClicked.
    ] ifFalse:[
        super buttonMultiPress:button x:x y:y
    ]

    "Modified: / 26.10.1997 / 18:50:58 / cg"
!

buttonPress:button x:x y:y
    |sensor lineNr|

    (button == 1) ifFalse:[
        (button == 2) ifTrue:[
            UserPreferences current selectOnRightClick ifTrue:[
                self selectOrToggleAtX:x y:y forRightClickMenu:true.
                UserPreferences current showRightButtonMenuOnRelease ifFalse:[
                    self pushEvent:#activateMenu.
                ].
                ^ self.
            ].
        ].
        ^ super buttonPress:button x:x y:y
    ].

    selectionAtClickTime := nil.
    enabled ifFalse:[
        ^ self
    ].

    dragIsActive        := false.
    clickPosition       := nil.
    isButtonPressActive := true.

    sensor := self sensor.
    sensor ctrlDown ifTrue:[
        ^ self buttonControlPress:button x:x y:y
    ].
    sensor shiftDown ifTrue:[
        ^ self expandSelectionToX:x y:y
    ].

    self canDrag ifTrue:[
        "/ clicked into the selection ?

        lineNr := self lineAtY:y. "/ self visibleLineToListLine:(self visibleLineOfY:y).

        (self isInSelection:lineNr) ifTrue:[
            "wait for release button
            "
            clickPosition := x@y.
            clickLine     := lineNr.
            ^ self
        ]
    ].
    self selectOrToggleAtX:x y:y

    "Modified: / 7.5.1998 / 02:02:20 / cg"
!

buttonRelease:button x:x y:y
    "stop any autoscroll"

    selectionAtClickTime := nil.
    self stopAutoScroll.

    button == 2 ifTrue:[
        super buttonRelease:button x:x y:y.
        ^ self.
    ].

    dragIsActive ifTrue:[
        dragIsActive := false
    ] ifFalse:[
        clickPosition notNil ifTrue:[
            enabled ifFalse:[
                ^ self
            ].
            self selectOrToggleAtX:(clickPosition x) y:(clickPosition y).
        ]
    ].
    clickPosition := nil.

    isButtonPressActive ifTrue:[
        isButtonPressActive := false.
        self hasSelection ifTrue:[
            self makeSelectionVisible.
        ].
    ].

    "Modified: / 26.10.1997 / 18:51:14 / cg"
!

buttonShiftPress:button x:x y:y
    "expand selection
    "
    self halt:'obsolete method called'.      "/ never called

    self expandSelectionToX:x y:y

    "Modified: 17.6.1997 / 18:03:24 / cg"
!

doubleClicked
    |actionArg|

    clickLine := nil.
    selectionAtClickTime := nil.

    enabled ifFalse:[
        ^ self
    ].
    selection isNil ifTrue:[
        "/ can only happen if claus modifies the selection within
        "/ the selectAction ....
        ^ self
    ].

    actionArg := self argForChangeMessage.

    "/
    "/ the ST-80 way of notifying the model
    "/
    (model notNil and:[doubleClickMsg notNil]) ifTrue:[
        self sendChangeMessage:doubleClickMsg with:actionArg.
    ].

    "/
    "/ ST/X action blocks
    "/
    doubleClickActionBlock notNil ifTrue:[
        doubleClickActionBlock valueWithOptionalArgument:actionArg
    ].

    "Modified: / 26.10.1997 / 18:51:39 / cg"
!

key:key select:index x:x y:y shifted:shifted
    "select an entry by a keyboard action.
     This is treated like a doubleClick on that entry,
     except if shift is down, and multiple selections are
     allowed, this adds/removes the new item to the selection."

    |oldSelection|

    enabled ifFalse:[
        ^ false
    ].

    keyActionStyle isNil ifTrue:[^ false].
    
    "/ this item selectable ?
    (selectConditionBlock notNil 
     and:[(selectConditionBlock value:index) not]) ifTrue:[^ false].

    keyActionStyle == #pass ifTrue:[
        super keyPress:key x:x y:y.
        ^ false.
    ].

    (self multipleSelectOk and:[shifted]) ifTrue:[
        oldSelection := selection copy.
        (self isInSelection:index) ifTrue:[
            self removeFromSelection:index
        ] ifFalse:[
            self addToSelection:index.
            self makeLineVisible:index.
        ].
        (selection ~= oldSelection) ifTrue:[
            self selectionChangedFrom:oldSelection.
        ].
    ] ifFalse:[
        self multipleSelectOk ifTrue:[
            self selection:(OrderedCollection with:index)
        ] ifFalse:[
            self selection:index.
        ].    
        keyActionStyle == #selectAndDoubleClick ifTrue:[
            self doubleClicked
        ]
    ].
    ^ true

    "Modified: / 4.2.2000 / 14:51:25 / cg"
!

keyPress:key x:x y:y
    "handle keyboard input"

    <resource: #keyboard ( #CursorUp #CursorDown #BeginOfText #EndOfText
                           #BeginOfLine #EndOfLine
                           #Return ) >

    |index       
     searchIndex "{Class: SmallInteger}"
     startSearch "{Class: SmallInteger}"
     backSearch searchPrefix shifted
     mySize sensor s index0 stillSearching|

    enabled ifFalse:[
        ^ self
    ].
    sensor := self sensor.
    shifted := sensor notNil and:[sensor shiftDown].

    (key == #CursorUp) ifTrue:[
        index0 := self firstInSelection.
        index := self previousSelectableBefore:selection.
        stillSearching := true.
        [stillSearching
         and:[selectConditionBlock notNil 
              and:[(selectConditionBlock value:index) not]]] whileTrue:[
            index := self previousSelectableBefore:index.
            stillSearching := index0 notNil and:[index ~= index0]
        ].
        (index0 notNil and:[index isNil or:[index > index0]]) ifTrue:[
            UserPreferences current beepInEditor ifTrue:[                
                self beep      "/ wrapped
            ].  
        ].   
        self key:key select:index x:x y:y shifted:shifted.
        ^ self
    ].
    (key == #CursorDown) ifTrue:[
        index0 := self lastInSelection.
        index := self nextSelectableAfter:selection.
        stillSearching := true.
        [stillSearching
         and:[selectConditionBlock notNil 
              and:[(selectConditionBlock value:index) not]]] whileTrue:[
            index := self nextSelectableAfter:index.
            stillSearching := index0 notNil and:[index ~= index0]
        ].
        (index0 notNil and:[index isNil or:[index < index0]]) ifTrue:[
            UserPreferences current beepInEditor ifTrue:[                
                self beep      "/ wrapped
            ].  
        ].  
        self key:key select:index x:x y:y shifted:shifted.
        ^ self
    ].
    "/
    "/ stupid: Home and End are caught in ScrollableView
    "/ we normally do not get them ...
    "/ (need to call handlesKey: from there ...
    "/  ... and implement it here)
    "/
    ((key == #BeginOfText) or:[key == #BeginOfLine]) ifTrue:[
        self key:key select:1 x:x y:y shifted:shifted.
        ^ self
    ].
    ((key == #EndOfText) or:[key == #EndOfLine]) ifTrue:[
        index := self size.
        self key:key select:index x:x y:y shifted:shifted.
        ^ self
    ].
    key == #Return ifTrue:[
        returnKeyActionStyle == #doubleClick ifTrue:[
            selection notNil ifTrue:[
                self doubleClicked
            ].
            ^ self
        ].
        returnKeyActionStyle ~~ #pass ifTrue:[
            ^ self
        ].
    ].
    (key == #SelectAll) ifTrue:[
        self multipleSelectOk ifTrue:[
            self selectAll. 
        ].
        ^ self
    ].

    mySize := self size.

    "
     alphabetic keys: search for next entry
     starting with key's character. If shift is pressed, search backward
    "
    (mySize > 0
    and:[key isCharacter
    and:[key isLetter]]) ifTrue:[
        keyActionStyle isNil ifTrue:[^ self].
"/        self multipleSelectOk ifTrue:[^ self].

        keyActionStyle == #pass ifFalse:[
            searchPrefix := key asLowercase asString.

"/            ... isISearch... ifFalse:[
"/                iSearchString := ''
"/            ] ifTrue:[
"/                iSearchString := iSearchString , searchPrefix.
"/                searchPrefix := iSearchString
"/            ].

            backSearch := shifted.
            backSearch ifTrue:[
                selection notNil ifTrue:[
                    startSearch := self firstInSelection - 1.
"/                    selection size > 0 ifTrue:[
"/                        startSearch := selection first - 1
"/                    ] ifFalse:[
"/                        selection isCollection ifTrue:[
"/                            startSearch := mySize
"/                        ] ifFalse:[
"/                            startSearch := selection - 1
"/                        ]
"/                    ]
                ] ifFalse:[
                    startSearch := mySize
                ].
                startSearch < 1 ifTrue:[
                    startSearch := mySize.
                ].
            ] ifFalse:[    
                selection notNil ifTrue:[
                    startSearch := self lastInSelection + 1.
"/                    selection size > 0 ifTrue:[
"/                        startSearch := selection last + 1
"/                    ] ifFalse:[
"/                        selection isCollection ifTrue:[
"/                            startSearch := 1
"/                        ] ifFalse:[
"/                            startSearch := selection + 1
"/                        ]
"/                    ]
                ] ifFalse:[
                    startSearch := 1
                ].
                startSearch > self size ifTrue:[
                    startSearch := 1.
                ].
            ].
            searchIndex := startSearch.
            [true] whileTrue:[
                s := self characterSearchItemStringAt:searchIndex.
                s notNil ifTrue:[
                    (s string withoutSeparators asLowercase startsWith:searchPrefix) ifTrue:[
                        |selectable didAskInteractively|
                        
                        searchIndex = selection ifTrue:[^ self].
                        Dialog aboutToOpenBoxNotificationSignal
                            handle:[:ex |
                                didAskInteractively := true.
                                selectable := false.
                            ] do:[    
                                didAskInteractively := false.
                                selectable := selectConditionBlock isNil or:[(selectConditionBlock value:searchIndex)].
                            ].
                            
                        selectable ifTrue:[
                            ^ self key:key select:searchIndex x:x y:y shifted:false
                        ].
                        didAskInteractively ifTrue:[^ self]. "/ ignore
                    ].
                ].
                backSearch ifTrue:[
                    searchIndex := searchIndex - 1.
                    searchIndex < 1 ifTrue:[searchIndex := mySize]
                ] ifFalse:[
                    searchIndex := searchIndex + 1.
                    searchIndex > mySize ifTrue:[searchIndex := 1].
                ].
                searchIndex == startSearch ifTrue:[
                    |prefix|

                    "/ none found.
                    searchPrefix size == 1 ifTrue:[
                        "/ if all start with the same prefix, use the char after the prefix
                        prefix := (self list collect:[:l | (l ? '')string]) longestCommonPrefixCaseSensitive:false.
                        prefix isEmptyOrNil ifTrue:[
                            ^ self
                        ].
                        searchPrefix := prefix , searchPrefix.
                    ] ifFalse:[
                        ^ self
                    ]
                ]
            ]
        ].
    ].
    ^ super keyPress:key x:x y:y

    "Modified: / 15.9.1998 / 18:22:31 / cg"
!

sizeChanged:how
    self sizeChanged:how from:nil
!

sizeChanged:how from:oldExtent
    "if there is a selection, make certain, it is visible
     after the sizechange."

    |first wasAtEnd selectionWasVisible oldFirst|

    widthOfWidestLine := nil.
    oldFirst := firstLineShown.
    wasAtEnd := (nFullLinesShown < list size) and:[ (firstLineShown + nFullLinesShown) >= list size ].

    selectionWasVisible := false.
    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            first := selection firstIfEmpty:nil
        ] ifFalse:[
            first := selection
        ].
        first notNil ifTrue:[
            selectionWasVisible := (first between:firstLineShown and:(firstLineShown + nFullLinesShown)).
        ]
    ].

    super sizeChanged:how.

    oldFirst ~~ firstLineShown ifTrue:[
        "/ super did scroll already
        ^ self
    ].

    shown ifTrue:[
        (oldExtent isNil or:[oldExtent y ~= height]) ifTrue:[
            selection size > 0 ifTrue:[
                selectionWasVisible ifTrue:[
                    self multipleSelectOk ifTrue:[
                        first := selection firstIfEmpty:nil
                    ] ifFalse:[
                        first := selection
                    ].
                    first notNil ifTrue:[self makeLineVisible:first]
                ]
            ] ifFalse:[
                "
                 if we were at the end before, move to the end again.
                 Still to be seen, if this is better in real life ...
                "
                wasAtEnd ifTrue:[
                    "at end"
                    self scrollToBottom
                ]
            ]
        ]
    ]

    "Modified: / 1.12.1998 / 23:27:27 / cg"
! !

!SelectionInListView methodsFor:'focus handling'!

showFocus:explicit
    self invalidateSelection.
    super showFocus:explicit
!

showNoFocus:explicit
    self invalidateSelection.
    super showNoFocus:explicit
!

wantsFocusWithPointerEnter
    "return true, if I want the focus when
     the mouse pointer enters"

    (UserPreferences current focusFollowsMouse ~~ false
    and:[(styleSheet at:#'selection.requestFocusOnPointerEnter' default:true)
    ]) ifTrue:[
        list size > 0 ifTrue:[
            ^ true
        ]
    ].

    ^ false
! !

!SelectionInListView methodsFor:'help'!

flyByHelpTextAt:aPoint
    |lineNr len|

    lineNr := self lineAtY:aPoint y.
    lineNr notNil ifTrue:[
        len := self widthOfLine:lineNr.
        len > width ifTrue:[
            ^ (self listAt:lineNr) string collect:[:ch | ch isSeparator ifTrue:[$ ] ifFalse:[ch]]  
        ].      
    ].
    ^ nil
! !

!SelectionInListView methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    |graphicsDevice|

    super fetchDeviceResources.
    graphicsDevice := device.

    hilightFgColor notNil ifTrue:[hilightFgColor := hilightFgColor onDevice:graphicsDevice].
    hilightBgColor notNil ifTrue:[hilightBgColor := hilightBgColor onDevice:graphicsDevice].

    halfIntensityFgColor notNil ifTrue:[halfIntensityFgColor := halfIntensityFgColor onDevice:graphicsDevice].
    hilightFrameColor    notNil ifTrue:[hilightFrameColor := hilightFrameColor onDevice:graphicsDevice].

    hilightFgColorNoFocus notNil ifTrue:[hilightFgColorNoFocus := hilightFgColorNoFocus onDevice:graphicsDevice].
    hilightBgColorNoFocus notNil ifTrue:[hilightBgColorNoFocus := hilightBgColorNoFocus onDevice:graphicsDevice].
!

initCursor
    "set the cursor - a hand"

    cursor := Cursor hand
!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    bgColor := viewBackground.
    hilightFrameColor := nil.
    hilightLevel := 0.
    hilightStyle := DefaultHilightStyle.
    arrowLevel := 1.
    smallArrow := false.

    device hasGrayscales ifTrue:[
        "
         must get rid of these hard codings
        "
        (hilightStyle == #next) ifTrue:[
            hilightFgColor := fgColor.
            hilightBgColor := self whiteColor.
            hilightFrameColor := fgColor
        ] ifFalse:[
            (hilightStyle == #motif) ifTrue:[
                fgColor := self whiteColor.
                bgColor := Grey.
                viewBackground := bgColor.
                hilightFgColor := bgColor  "fgColor" "self whiteColor".
                hilightBgColor := fgColor "bgColor lightened" "darkened".
            ] ifFalse:[
                (hilightStyle == #openwin) ifTrue:[
                    hilightFgColor := fgColor.
                    hilightBgColor := Color gray.
                    smallArrow := true.
                ] ifFalse:[
                    (hilightStyle == #win95) ifTrue:[
                        smallArrow := true.
                    ]
                ]
            ]
        ]
    ].

    hilightFgColor isNil ifTrue:[
        hilightFgColor := bgColor.
    ].
    hilightBgColor isNil ifTrue:[
        hilightBgColor := fgColor.
    ].
    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor
    ].
    DefaultBackgroundColor notNil ifTrue:[
        bgColor := viewBackground := DefaultBackgroundColor
    ].
    DefaultHilightForegroundColor notNil ifTrue:[
        hilightFgColor := DefaultHilightForegroundColor
    ].
    DefaultHilightBackgroundColor notNil ifTrue:[
        hilightBgColor := DefaultHilightBackgroundColor
    ].
    DefaultHilightFrameColor notNil ifTrue:[
        hilightFrameColor := DefaultHilightFrameColor
    ].
    DefaultHilightLevel notNil ifTrue:[
        hilightLevel := DefaultHilightLevel
    ].
    DefaultRightArrowLevel notNil ifTrue:[
        arrowLevel := DefaultRightArrowLevel
    ].

    DefaultShadowColor notNil ifTrue:[
        shadowColor := DefaultShadowColor
    ].
    DefaultLightColor notNil ifTrue:[
        lightColor := DefaultLightColor
    ].

    (hilightLevel abs > 0) ifTrue:[
        lineSpacing := 3
    ] ifFalse:[
        lineSpacing := 2
    ].
    #hack.
    "/ q&d temporary hack.
    "/ X11 fonts are currently so ugly... add more spacing.
    device platformName == #X11 ifTrue:[
        lineSpacing := lineSpacing + 3.
    ].
    hilightFgColor isNil ifTrue:[
        hilightFgColor := bgColor.
        hilightBgColor := fgColor
    ].

    DefaultDisabledForegroundColor notNil ifTrue:[
        halfIntensityFgColor := DefaultDisabledForegroundColor
    ] ifFalse:[
        halfIntensityFgColor := Color darkGray.
    ].

    hilightFgColorNoFocus := DefaultHilightForegroundColorNoFocus.
    hilightFgColorNoFocus isNil ifTrue:[
        hilightFgColorNoFocus := hilightFgColor slightlyLightened.
    ].
    hilightBgColorNoFocus := DefaultHilightBackgroundColorNoFocus.
    hilightBgColorNoFocus isNil ifTrue:[
        hilightBgColorNoFocus := hilightBgColor slightlyLightened.
    ]

    "Modified: / 05-08-1998 / 00:00:00 / cg"
    "Modified (comment): / 05-10-2011 / 15:50:50 / az"
!

initialize
    super initialize.

    isButtonPressActive := false.
    "/ fontHeight := font height + lineSpacing.
    enabled := true.
    ignoreReselect := true.
    multipleSelectOk := toggleSelect := strikeOut := printItems := false.
    useIndex := true.
    dragIsActive := allowDrag := false.

    keyActionStyle := #select.
    returnKeyActionStyle := #doubleClick.

    listMsg := self class defaultListMessage.
    initialSelectionMsg := self class defaultSelectionMessage.

    "Modified: 14.11.1996 / 15:12:33 / cg"
!

realize
    super realize.

    model notNil ifTrue:[
        self getSelectionFromModel.
    ].

    selection notNil ifTrue:[
        selection isCollection ifTrue:[
            selection notEmpty ifTrue:[
                self makeLineVisible:selection first
            ]
        ] ifFalse:[
            self makeLineVisible:selection
        ]
    ].

    "Modified: 27.2.1997 / 14:23:40 / cg"
! !

!SelectionInListView methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    ^ #SelectionInListView
! !

!SelectionInListView methodsFor:'private'!

argForChangeMessage
    "return the argument for a selectionChange;
     depending on the setting of useIndex, this is either the numeric
     index of the selection or the value (i.e. the string)"

    useIndex ~~ false ifTrue:[  "/ i.e. everything except false
        self multipleSelectOk ifTrue:[
            selection isNil ifTrue:[
                ^ #() 
            ].
        ].
        ^ selection
    ].

    printItems ifFalse:[
        ^ self selectionValue
    ].

    items notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            ^ selection collect:[:nr | items at:nr]
        ].
        ^ items at:selection
    ].

    ^ nil       "/ cannot happen

    "Modified: 26.10.1995 / 16:28:13 / cg"
!

characterSearchItemStringAt:lineNr
    "for first-character search:
     return a lines item-string.
     For multi-col items, this may be different from the actual string"

    |item s|

    item := self at:lineNr.
    item isNil ifTrue:[^ nil].
    (Error catch:[
       s := item asString
    ]) ifTrue:[
       s := item displayString
    ].
    ^ s
!

checkRemovingSelection:lineNr
    "when a line is removed, we have to adjust selection"

    self checkRemovingSelectionFrom:lineNr to:lineNr
!

checkRemovingSelectionFrom:startNr to:endNr
    "when a range of lines is removed, we have to adjust the selection"

    |newSelection|

    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            newSelection := OrderedCollection new.
            selection do:[:sel |
                sel < startNr ifTrue:[
                    newSelection add:sel
                ] ifFalse:[
                    sel > endNr ifTrue:[
                        newSelection add:(sel - 1)
                    ]
                    "otherwise remove it from the selection"
                ]
            ].
            newSelection size == 0 ifTrue:[
                selection := nil
            ] ifFalse:[
                selection := newSelection
            ]
        ] ifFalse:[
            (selection between:startNr and:endNr) ifTrue:[
                selection := nil
            ] ifFalse:[
                selection > endNr ifTrue:[
                    selection := selection - 1
                ]
            ]
        ]
    ]
!

getListFromModel
    "if I have a model, get my list from it using the listMessage.
     If listMessage is nil, try aspectMessage for backward compatibilty."

    |text msg|

    listChannel notNil ifTrue:[
        items := listChannel value copy
    ] ifFalse:[
        (model isNil or:[(msg := listMsg) isNil and:[(msg := aspectMsg) isNil]]) ifTrue:[
            ^ self
        ].
        items := model perform:msg.
    ].
    items notNil ifTrue:[
        printItems ifTrue:[
            text := items collect:[:element | element printString]
        ] ifFalse:[
            text := items.
            items := nil.
        ].
        text notNil ifTrue:[
            text isSequenceable ifFalse:[
                text := text asOrderedCollection
            ]
        ]
    ].
    self list:text keepSelection:true. "/ expandTabs:false

    "Modified: / 29-06-2010 / 16:14:14 / sr"
!

getSelectionFromModel
    "if I have a model and an initialSelectionMsg, get my selection from it"

    |sel|

    model notNil ifTrue:[
        listChannel notNil ifTrue:[
            sel := model value.
            sel isNil ifTrue:[
                self deselect.
                ^ self
            ]
        ] ifFalse:[
            initialSelectionMsg isNil ifTrue:[^ self].
            sel := model perform:initialSelectionMsg.
        ].
        (useIndex or:[sel isNumber]) ifTrue:[
            self setSelection:sel 
        ] ifFalse:[
            self setSelectElement:sel.
        ]
    ].

    "Modified: / 08-11-2006 / 19:46:33 / cg"
!

highlightLineSpacing
    "true if the spacing between lines is to be drawn with selected color,
     false if it remains white.
     false for selection in list views; true for edit/text views"

    ^ false
!

isValidSelection:aNumberOrCollection
    "return true, if aNumber is ok as a selection index"

    |sz|

    aNumberOrCollection isNil ifTrue:[^ false].

    sz := self size.
    (aNumberOrCollection isCollection) ifTrue:[
        self multipleSelectOk ifFalse:[^ false].
        aNumberOrCollection do:[:index |
            (index between:1 and:sz) ifFalse:[^ false].
            (self lineIsEnabled:index) ifFalse:[^ false].
        ].
    ] ifFalse:[
        (aNumberOrCollection between:1 and:sz) ifFalse:[^ false].
        (self lineIsEnabled:aNumberOrCollection) ifFalse:[^ false].
    ].
    ^ true.

    "Modified: / 8.8.1998 / 03:34:27 / cg"
!

lineIsEnabled:lineNr
    ^ (self line:lineNr hasAttribute:#disabled) not

    "Modified: / 8.8.1998 / 03:22:50 / cg"
!

positionToSelectionX:x y:y
    "given a click position, return the selection lineNo"

    (x between:0 and:width) ifTrue:[
        (y between:0 and:height) ifTrue:[
            ^ self lineAtY:y
            "/ ^ self visibleLineToListLine:(self visibleLineOfY:y)
        ]
    ].
    ^ nil
!

scrollSelectDown
    "auto scroll action; scroll and reinstall timed-block"

    self scrollDown.
    Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT.

    "Modified: / 3.2.2000 / 22:41:59 / cg"
!

scrollSelectUp
    "auto scroll action; scroll and reinstall timed-block"

    self scrollUp.
    Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT.
!

selectOrToggleAtX:x y:y
    self selectOrToggleAtX:x y:y forRightClickMenu:false
!

selectOrToggleAtX:x y:y forRightClickMenu:forRightClickMenu
    |oldSelection listLineNr|

    selectMode := nil.
    listLineNr := self lineAtY:y. "/ self visibleLineToListLine:(self visibleLineOfY:y).
    listLineNr notNil ifTrue:[
        "/ this item selectable ?
        (selectConditionBlock notNil 
         and:[(selectConditionBlock value:listLineNr) not]) ifTrue:[^ false].

        oldSelection := selection copy.

        forRightClickMenu ifTrue:[
            (self isInSelection:listLineNr) ifFalse:[
                self selectWithoutScroll:listLineNr.
                selectMode := false.
                (selection ~= oldSelection) ifTrue:[
                    self selectionChangedFrom:oldSelection.
                ].
            ].
        ] ifFalse:[
            (toggleSelect and:[self isInSelection:listLineNr]) ifTrue:[
                self removeFromSelection:listLineNr.
                selectMode := false.
            ] ifFalse:[
                (self lineIsEnabled:listLineNr) ifFalse:[^ true].

                (toggleSelect and:[self multipleSelectOk]) ifTrue:[
                    self addToSelection:listLineNr
                ] ifFalse:[
                    self selectWithoutScroll:listLineNr.
                ].
                selectMode := true.
            ].
            ((ignoreReselect not and:[selection notNil])
             or:[selection ~= oldSelection]) ifTrue:[
                self selectionChangedFrom:oldSelection.
            ].
        ].
        clickLine := listLineNr
    ].
    ^ true

    "Created: / 14.11.1996 / 16:27:17 / cg"
    "Modified: / 8.8.1998 / 03:22:26 / cg"
!

visibleLineNeedsSpecialCare:visLineNr
    |listLine|

    listLine := self visibleLineToListLine:visLineNr.
    listLine isNil ifTrue:[^ false].
    (self isInSelection:listLine) ifTrue:[^ true].
    visualBlock notNil ifTrue:[^true].
    listAttributes notNil ifTrue:[
        (listLine <= listAttributes size) ifTrue:[
            ^ (listAttributes at:listLine) notNil
        ]
    ].
    ^ false

    "Modified: / 21.6.1998 / 02:43:02 / cg"
!

widthForScrollBetween:start and:end
    "has to be redefined since WHOLE line is inverted/modified sometimes"

    | anySelectionInRange |

    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            anySelectionInRange := false.
            selection do:[:s |
                (s between:start and:end) ifTrue:[
                    anySelectionInRange := true
                ]
            ]
        ] ifFalse:[
            anySelectionInRange := selection between:start and:end
        ]
    ] ifFalse:[
        anySelectionInRange := false
    ].

    anySelectionInRange ifTrue:[
        ^ width
"
        self is3D ifFalse:[
            ^ width 
        ].
        ( #(next openwin) includes:styleSheet name) ifTrue:[
            ^ width 
        ].
        viewBackground = background ifFalse:[
            ^ width 
        ]
"
    ].
    ^ super widthForScrollBetween:start and:end
! !

!SelectionInListView methodsFor:'private-drag and drop'!

collectionOfDragObjects
    "returns collection of dragable objects assigned to selection
     Here, by default, a collection of text-dragObjects is generated;
     however, if a dragObjectConverter is defined, that one gets a chance
     to convert as appropriate."

    |collection indices converted|

    collection := OrderedCollection new.
    indices := OrderedCollection new.      

    self selectionDo:[:aNumber| 
        |text|

        text := self at:aNumber.
        collection add:(DropObject newText:text).
        indices add:aNumber.
    ].
    dragObjectConverter notNil ifTrue:[
        converted := OrderedCollection new.
        collection with:indices do:[:o :idx | 
            |convertedObject|

            convertedObject := dragObjectConverter value:o optionalArgument:idx.
            convertedObject notNil ifTrue:[
                converted add:convertedObject
            ]
        ].
        collection := converted
    ].
    ^ collection.

    "Modified: 6.4.1997 / 14:14:30 / cg"
! !

!SelectionInListView methodsFor:'queries'!

isCursorKeyConsumer
    "return true, if the receiver can be controlled by cursor keys;
     i.e. it can handle some keyboard input,
     isCursorKeyConsumer are potential candidates for getting the keyboard
     focus initially within dialogBoxes, or when the focus-follows-pointer
     mode is off."

    ^ true
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not SelectionInListSpec)"

    self class == SelectionInListView ifTrue:[^ SequenceViewSpec].
    ^ super specClass

    "Modified: / 5.9.1995 / 23:05:53 / claus"
    "Modified: / 31.10.1997 / 19:48:44 / cg"
! !

!SelectionInListView methodsFor:'redrawing'!

redrawElement:aNumber
    "redraw an individual element"

    ^ self redrawLine:aNumber
!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    "redraw a range of lines.
     Must check, if any is in the selection and handle this case.
     Otherwise draw it en-bloque using supers method."

    |special sel
     l1 "{ Class: SmallInteger }"
     l2 "{ Class: SmallInteger }"
     selNo "{ Class: SmallInteger }" |

    ((selection isCollection) 
    or:[listAttributes notNil
    or:[visualBlock notNil
    or:[selectedVisualBlock notNil]]]) ifTrue:[
        "/ cannot do bulk-redraw ...
        l1 := startVisLineNr.
        l2 := endVisLineNr. 
        l1 to:l2 do:[:visLine |
            self redrawVisibleLine:visLine
        ].
        ^ self
    ].

"XXX only if -1/+1"
"/    hilightLevel ~~ 0 ifTrue:[
"/     self paint:bgColor.
"/     self fillRectangleX:0 y:(self yOfVisibleLine:startVisLineNr)-1 width:width height:1
"/  ].
    special := true.
    selection isNil ifTrue:[
        special := false
    ] ifFalse:[
        sel := self listLineToVisibleLine:selection.
        sel isNil ifTrue:[
            special := false
        ] ifFalse:[
            special := (sel between:startVisLineNr and:endVisLineNr)
        ]
    ].
    special ifFalse:[
      ^ super redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    ].

    selNo := sel.
    selNo > startVisLineNr ifTrue:[
        super redrawFromVisibleLine:startVisLineNr to:(selNo - 1)
    ].
    self redrawVisibleLine:selNo.
    selNo < endVisLineNr ifTrue:[
        super redrawFromVisibleLine:(selNo + 1) to:endVisLineNr
    ]

    "Modified: / 21.6.1998 / 02:42:17 / cg"
!

redrawVisibleLine:visLineNr
    "redraw a single line.
     Must check, if any is in the selection and handle this case.
     Otherwise draw using supers method."

    |listLine fg bg newFont oldFont id dObj y|

    fg := fgColor.
    bg := bgColor.
    listLine := self visibleLineToListLine:visLineNr.
    listLine notNil ifTrue:[
        (self isInSelection:listLine) ifTrue:[
            ^ self drawVisibleLineSelected:visLineNr
        ].

        visualBlock notNil ifTrue:[
            y := self yOfVisibleLine:visLineNr.

            backgroundAlreadyClearedColor == bg ifFalse:[
                gc paint:bg.
                gc fillRectangleX:margin y:y - (lineSpacing//2)
                              width:(width - (2 * margin)) 
                             height:fontHeight.
            ].

            dObj := visualBlock value:self value:listLine.
            gc paint:fg on:bg.
            dObj displayOn:self x:(textStartLeft - viewOrigin) x y:y + gc font ascent opaque:true.
            ^ self
        ].

        listAttributes notNil ifTrue:[
            ((self line:listLine hasAttribute:#halfIntensity) 
            or:[ (self lineIsEnabled:listLine) not ]) ifTrue:[
                fg := halfIntensityFgColor
            ].
            (self line:listLine hasAttribute:#bold) ifTrue:[
                newFont := gc font asBold.
                (gc font bold 
                or:[id := (newFont onDevice:gc device) fontId.
                    id isNil]) 
                ifTrue:[
                    "
                     mhmh - what can be done, if the font is already bold ?
                     or no such font is available   
                    "
                    fgColor brightness > 0.5 ifTrue:[
                        fg := fgColor darkened "darkened". 
                    ] ifFalse:[
                        fg := fgColor lightened "lightened"
                    ].
                    (fg brightness - bg brightness) abs < 0.25 ifTrue:[
                        bgColor brightness > 0.5 ifTrue:[
                            fg := fg darkened. 
                        ] ifFalse:[
                            fg := fg lightened
                        ].
                    ]
                ].
                id notNil ifTrue:[
                    oldFont := gc font.
                    self basicFont:newFont.
                    self drawVisibleLine:visLineNr with:fg and:bg.
                    self basicFont:oldFont.
                ] ifFalse:[
                    self drawVisibleLine:visLineNr with:fg and:bg.
                ].
                ^ self
            ]
        ]
    ].
    ^ self drawVisibleLine:visLineNr with:fg and:bg

    "Modified: / 08-08-1998 / 03:42:13 / cg"
    "Modified: / 29-06-2010 / 16:16:03 / sr"
!

redrawVisibleLine:visLineNr col:colNr
    "redraw a single character.
     Must check, if its in the selection and handle this case."

    (self visibleLineNeedsSpecialCare:visLineNr) ifTrue:[
	^ self redrawVisibleLine:visLineNr
    ].
    super redrawVisibleLine:visLineNr col:colNr
!

redrawVisibleLine:visLineNr from:startCol
    "redraw from a col to the right end.
     Must check, if its in the selection and handle this case."

    (self visibleLineNeedsSpecialCare:visLineNr) ifTrue:[
	^ self redrawVisibleLine:visLineNr
    ].
    super redrawVisibleLine:visLineNr from:startCol
!

redrawVisibleLine:visLineNr from:startCol to:endCol
    "redraw from a startCol to endCol.
     Must check, if its in the selection and handle this case."

    (self visibleLineNeedsSpecialCare:visLineNr) ifTrue:[
	^ self redrawVisibleLine:visLineNr
    ].
    super redrawVisibleLine:visLineNr from:startCol to:endCol
! !

!SelectionInListView methodsFor:'selections'!

deselect
    "deselect; Model or actionBlock notifications are made.
     To deselect without notifications, use #setSelection:nil."

    self selection:nil

    "Modified: 25.5.1996 / 13:03:47 / cg"
!

deselectWithoutRedraw
    "deselect without redraw or notifications.
     No model or actionBlock notifications are made."

    selection := nil

    "Modified: 25.5.1996 / 13:04:14 / cg"
!

expandSelectionToX:x y:y
    "used with button-motion and shift-press;
     expand the selection to include all items from the clicked one,
     up to the one under the mouse pointer"

    |movedLine delta newSelection|

    self multipleSelectOk ifFalse:[^ self].
    "D120784 - WB when invoked without any selection"
    selection size == 0 ifTrue:[^ self].

    movedLine := self visibleLineToAbsoluteLine:(self visibleLineOfY:y).

    clickLine isNil ifTrue:[
        selection size == 1 ifTrue:[
            clickLine := selection first.
        ] ifFalse:[
            movedLine > selection max ifTrue:[
                clickLine := selection max
            ] ifFalse:[
                movedLine < selection min ifTrue:[
                    clickLine := selection min
                ].
            ]
        ].
        clickLine isNil ifTrue:[
            ^ self
        ].
    ].

    selectionAtClickTime isNil ifTrue:[
        selectionAtClickTime := selection copy.
    ].

    newSelection := selectionAtClickTime copy.
    newSelection isNil ifTrue:[
        newSelection := OrderedCollection new.
    ] ifFalse:[
        newSelection := newSelection asOrderedCollection.
    ].    

    "/ compute new selection
    delta  := (clickLine < movedLine) ifTrue:[1] ifFalse:[-1].
    clickLine to:movedLine by:delta do:[:ln |
        |isSelected doSelect doUnselect|

        doSelect := doUnselect := false.

        isSelected := self is:ln inSelection:selectionAtClickTime.
        (selectMode ? true) == true ifTrue:[
            doSelect := isSelected not
        ] ifFalse:[
            selectMode == false ifTrue:[
                doUnselect := isSelected
            ] ifFalse:[
                selectMode == #toggle ifTrue:[
                    doUnselect := isSelected.
                    doSelect := doUnselect not.
                ]
            ]
        ].

        doSelect ifTrue:[
            newSelection add:ln.
        ] ifFalse:[
            doUnselect ifTrue:[
                newSelection remove:ln.
            ]
        ]
    ].

    newSelection ~= selection ifTrue:[
        self selection:newSelection.
    ].

    "Created: / 14.11.1996 / 15:48:10 / cg"
    "Modified: / 3.2.2000 / 22:13:50 / cg"
!

firstInSelection
    "return the index of the first selected line - nil if there is no selection"

    selection isNil ifTrue:[^ nil].
    selection isCollection ifTrue:[
        selection isEmpty ifTrue:[
            ^ nil
        ].
        ^ selection min
    ].
    ^ selection
!

hasSelection
    "return true, if the view has a selection"

    self multipleSelectOk ifTrue:[
        ^ selection size > 0
    ].
    ^ selection notNil 
!

is:aNumber inSelection:aSelection
    "return true, if line, aNumber is in the selection"

    aSelection isNil ifTrue:[^ false].
    self multipleSelectOk ifTrue:[
        ^ (aSelection includes:aNumber)
    ].
    ^ (aNumber == aSelection)
!

isInSelection:aNumber
    "return true, if line, aNumber is in the selection"

    selection isNil ifTrue:[^ false].
    self multipleSelectOk ifTrue:[
        ^ (selection includes:aNumber)
    ].
    ^ (aNumber == selection)
!

lastInSelection
    "return the index of the last selected line - nil if there is no selection"

    selection isNil ifTrue:[^ nil].
    selection isCollection ifTrue:[
        selection size == 0 ifTrue:[
            ^ nil
        ].
        ^ selection max
    ].
    ^ selection
!

makeSelectionVisible
    "scroll to make the selection line visible"

    |line|

    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            selection isEmpty ifTrue:[^ self].
            "/ don't move, if any in the selection isVisible
            selection do:[:aSelectedLine |
                (self lineIsFullyVisible:aSelectedLine) ifTrue:[
                    ^ self
                ]
            ].
            line := selection first.
        ] ifFalse:[
            line := selection
        ].
        self makeLineVisible:line 
    ]

    "Modified: / 24.2.2000 / 17:48:00 / cg"
!

nextAfterSelection
    "return the index of the next selectable entry after the selection.
     Wrap at end."

    ^ self nextSelectableAfter:selection
!

nextSelectableAfter:indexOrIndexCollection
    "return the index of the next selectable entry after the indexOrIndexCollection.
     Wrap at end."

    |next sz|

    indexOrIndexCollection isNil ifTrue:[
        next := firstLineShown
    ] ifFalse:[
        indexOrIndexCollection isCollection ifTrue:[
            indexOrIndexCollection size == 0 ifTrue:[
                next := firstLineShown
            ] ifFalse:[
                next := indexOrIndexCollection max + 1
            ]
        ] ifFalse:[
            next := indexOrIndexCollection + 1
        ].
    ].

    (self isValidSelection:next) ifFalse:[
        sz := self size.
        next > sz ifTrue:[
            next := 1.
        ] ifFalse:[
            [next <= sz
             and:[(self isValidSelection:next) not ]] whileTrue:[
                next := next + 1
            ].
        ].
    ].

    (self isValidSelection:next) ifFalse:[
        next := nil
    ].
    ^ next

    "Modified: / 8.8.1998 / 03:36:55 / cg"
!

numberOfSelections
    "return the number of selected entries"

    |sz|

    selection isNil ifTrue:[^ 0].
    sz := selection size.
    sz > 0 ifTrue:[^ sz].
    ^ 1
!

previousBeforeSelection
    "return the index of the previous selectable entry before the selection.
     Wrap at beginning."

    ^ self previousSelectableBefore:selection

!

previousSelectableBefore:indexOrIndexCollection
    "return the index of the previous selectable entry before the indexOrIndexCollection.
     Wrap at beginning."

    |prev|

    indexOrIndexCollection isNil ifTrue:[
        prev := firstLineShown - 1 
    ] ifFalse:[
        indexOrIndexCollection isCollection ifTrue:[
            indexOrIndexCollection size == 0 ifTrue:[
                prev := firstLineShown - 1
            ] ifFalse:[
                prev := indexOrIndexCollection min - 1
            ]
        ] ifFalse:[
            prev := indexOrIndexCollection - 1
        ].
    ].
    (self isValidSelection:prev) ifFalse:[
        prev < 1 ifTrue:[
            prev := self size.
        ] ifFalse:[
            [prev >= 1
             and:[(self isValidSelection:prev) not]] whileTrue:[
                prev := prev - 1
            ].
        ].
    ].
    (self isValidSelection:prev) ifFalse:[
        prev := nil
    ].
    ^ prev

!

selectAll
    "select all entries. 
     Model and/or actionBlock notification IS done."

    |oldSelection|

    self multipleSelectOk ifTrue:[
        oldSelection := selection.
        selection := OrderedCollection withAll:(1 to:self size).
        self invalidate.
        self selectionChangedFrom:oldSelection.
    ]

    "Modified: 15.11.1996 / 17:00:26 / cg"
!

selectElement:anObject
    "select the element with same printString as the argument, anObject.
     Scroll to make the new selection visible.
     Model and/or actionBlock notification IS done."

    |lineNo|

    list notNil ifTrue:[
        items notNil ifTrue:[
            lineNo := items indexOf:anObject ifAbsent:nil
        ] ifFalse:[
            lineNo := list indexOf:(anObject printString) ifAbsent:nil.
        ].
        lineNo notNil ifTrue:[self selection:lineNo]
    ]

    "Modified: 15.11.1996 / 17:01:05 / cg"
!

selectElementWithoutScroll:anObject
    "select the element with same printString as the argument, anObject.
     Do not scroll.
     *** No model and/or actionBlock notification is done here."

    |lineNo|

    list notNil ifTrue:[
        items notNil ifTrue:[
            lineNo := items indexOf:anObject ifAbsent:nil
        ] ifFalse:[
            lineNo := list indexOf:(anObject printString) ifAbsent:nil.
        ].
        lineNo notNil ifTrue:[self selectWithoutScroll:lineNo]
    ]

    "Modified: 15.11.1996 / 17:01:17 / cg"
!

selectFirst
    "select the first selectable element.
     Model and/or actionBlock notification IS done."

    self selection:(self nextSelectableAfter:0)
!

selectFirstVisibleLine
    "select the first selectable element.
     Model and/or actionBlock notification IS done."

    self selection:(self nextSelectableAfter:self firstLineShown -1)
!

selectLast
    "select the last selectable element.
     Model and/or actionBlock notification IS done."

    self selection:(self previousSelectableBefore:list size + 1)
!

selectNext
    "select next line or first visible if there is currrently no selection.
     Wrap at end. 
     Model and/or actionBlock notification IS done."

    self selection:(self nextAfterSelection)

    "Modified: 15.11.1996 / 17:01:27 / cg"
!

selectPrevious
    "select previous line or previous visible if there is currently no selection.
     Wrap at beginning. 
     Model and/or actionBlock notification IS done."

    self selection:(self previousBeforeSelection).

    "Modified: 26.9.1995 / 09:41:16 / stefan"
    "Modified: 15.11.1996 / 17:01:34 / cg"
!

selectWithoutScroll:aNumberOrNilOrCollection
    "select line, aNumber or deselect if argument is nil.
     *** No model and/or actionBlock notification is done here."

    |newSelection multipleSelectOk oldItems newItems addedItems removedItems|

    multipleSelectOk := self multipleSelectOk.

    newSelection := aNumberOrNilOrCollection.
    multipleSelectOk ifTrue:[
        newSelection notNil ifTrue:[
            newSelection isNumber ifTrue:[
                newSelection := OrderedCollection with:newSelection
            ].

            newSelection := newSelection select:[:each | each notNil].
            newSelection size == 0 ifTrue:[newSelection := nil].
        ].
    ].

    newSelection notNil ifTrue:[
        (self isValidSelection:newSelection) ifFalse:[
            multipleSelectOk ifTrue:[
                newSelection := newSelection select:[:each | self isValidSelection:each].
            ] ifFalse:[
                newSelection := nil.
            ].
        ].
        newSelection == 0 ifTrue:[
            newSelection := nil
        ] ifFalse:[
            (newSelection isCollection
            and:[newSelection size == 0]) ifTrue:[
                newSelection := nil
            ]
        ].

        newSelection notNil ifTrue:[
            multipleSelectOk ifTrue:[
                newSelection isCollection ifFalse:[
                    newSelection := OrderedCollection with:newSelection
                ]
            ]
        ].
    ].

    (newSelection = selection) ifTrue: [^ self].

    multipleSelectOk ifTrue:[
        oldItems := selection ? #().
        newItems := newSelection ? #().
    ] ifFalse:[
        (selection isNil or:[selection == 0]) ifTrue:[
            oldItems := #()
        ] ifFalse:[
            oldItems := Array with:selection
        ].
        (newSelection isNil or:[newSelection == 0]) ifTrue:[
            newItems := #()
        ] ifFalse:[
            newItems := Array with:newSelection
        ].
    ].

    addedItems := newItems reject:[:item | (oldItems includes:item)].    
    removedItems := oldItems reject:[:item | (newItems includes:item)].    

    selection := newSelection.

    addedItems do:[:line |
        self redrawElement:line
    ].
    removedItems do:[:line |
        self redrawElement:line
    ].

"/    "
"/     redraw old selection unhighlighted
"/    "
"/    selection notnil iftrue: [
"/        prevselection := selection.
"/        selection := nil.
"/        multipleselectok iftrue:[
"/            prevselection do:[:line |
"/                self redrawelement:line
"/            ]
"/        ] iffalse:[
"/            self redrawelement:prevselection
"/        ]
"/    ].
"/
"/    selection := newSelection.
"/
"/    "
"/     redraw new selection unhighlighted
"/    "
"/    newSelection notNil ifTrue:[
"/        multipleSelectOk ifTrue:[
"/"/            newSelection isCollection ifFalse:[
"/"/                selection := OrderedCollection with:newSelection.
"/"/            ].
"/            selection do:[:line |
"/                self redrawElement:line
"/            ]
"/        ] ifFalse:[
"/            self redrawElement:selection
"/        ]
"/    ]

    "Modified: 15.11.1996 / 16:58:46 / cg"
!

selection
    "return the selection index or collection of indices (if multipleSelect is on)"

    ^ selection
!

selection:aNumberOrNilOrCollection
    "select line, aNumber or deselect if argument is nil;
     scroll to make the selected line visible.
     The model and/or actionBlock IS notified."

    |oldSelection|

    oldSelection := selection.
    self setSelection:aNumberOrNilOrCollection.
    selection ~= oldSelection ifTrue:[
        self selectionChangedFrom:oldSelection
    ]

    "Modified: / 7.8.1998 / 13:36:34 / cg"
!

selectionAsCollection
    "return the selection as a collection of line numbers.
     This allows users of this class to enumerate independent of
     the multipleSelect style."

    selection isNil ifTrue:[^ #()].

"/    self multipleSelectOk ifTrue:[
"/        ^ (OrderedCollection new) add:selection; yourself.
"/    ].
    self multipleSelectOk ifFalse:[
        ^ (OrderedCollection new) add:selection; yourself.
    ].
    ^ selection
!

selectionChangedFrom:oldSelection
    "selection has changed. Call actionblock and/or send changeMessage if defined"

    |changeArg actionArg|

    changeArg := actionArg := self argForChangeMessage.

    "/
    "/ the MVC way of doing things - notify model via changeMsg
    "/
    self multipleSelectOk ifFalse:[
        "/ ST80 sends 0 as index, if the same selection is reselected ...
        selection == oldSelection ifTrue:[
            changeArg := 0
        ].
    ].

    "/ must take care, if model is == to the selection-collection
    "/ in this case, we must force a change on the model
    "/ (valueHolder would not send a change in the == case)
    "/ Q: should this be done in #sendChangeMessage ?
    model isValueModel ifTrue:[
        model value == changeArg ifTrue:[
            model setValue:nil.
        ]
    ].
    self sendChangeMessageWith:changeArg.

    "/
    "/ the ST/X way of doing things - perform the actionBlock
    "/
    actionBlock notNil ifTrue:[
        actionBlock valueWithOptionalArgument:actionArg
    ].

    "Modified: 14.2.1997 / 16:49:09 / cg"
!

selectionDo:aBlock
    "perform aBlock for each nr in the selection.
     For single selection, it is called once for the items nr.
     For multiple selections, it is called for each."

    selection notNil ifTrue:[
        self multipleSelectOk ifTrue:[
            selection do:aBlock
        ] ifFalse:[
            aBlock value:selection
        ].
    ].
!

selectionValue
    "return the selection value i.e. the text in the selected line.
     For multiple selections a collection containing the entries is returned."

    self multipleSelectOk ifTrue:[
        selection isNil ifTrue:[^ #()].
        ^ selection collect:[:nr | self at:nr]
    ].
    selection isNil ifTrue:[^ nil].
    ^ self at:selection
!

selectionValueAsCollection
    "return the selection values as a collection - allows selectionValues to
     be enumerated independent of the multiSelect settings"

    selection isNil ifTrue:[^ #()].
    self multipleSelectOk ifTrue:[
        ^ selection collect:[:nr | self at:nr]
    ].
    ^ Array with:(self at:selection)
!

setSelectElement:anObject 
    "select the element with same printString as the argument, anObject.
     Scroll to make the new selection visible.
     *** No model and/or actionBlock notification is done here."

    |size lineNo coll s|

    list isNil ifTrue:[
        ^ self
    ].
    self multipleSelectOk ifTrue:[
        (size := anObject size) == 0 ifTrue:[
            ^ self setSelection:nil
        ].
        coll := OrderedCollection new:size.
        anObject do:[:o | 
            items notNil ifTrue:[
                lineNo := items indexOf:o
            ] ifFalse:[
                lineNo := list findFirst:[:el | (o ? '') string = (el ? '') string]
            ].
            lineNo ~~ 0 ifTrue:[
                coll add:lineNo
            ]
        ].
        ^ self setSelection:coll
    ].
    anObject isNil ifTrue:[
        ^ self setSelection:nil
    ].

    items notNil ifTrue:[
        lineNo := items findFirst:[:el | anObject = el]
    ] ifFalse:[
        lineNo := list indexOf:anObject ifAbsent:[nil].
        lineNo isNil ifTrue:[
            s := anObject string.
            lineNo := list findFirst:[:el | s = el string]
        ].
    ].
    lineNo ~~ 0 ifTrue:[
        self setSelection:lineNo
    ]
!

setSelection:aNumberOrNilOrCollection
    "select line, aNumber or deselect if argument is nil;
     scroll to make the selected line visible.
     *** No model and/or actionBlock notification is done here."

    self selectWithoutScroll:aNumberOrNilOrCollection.

    "/ makeSelectionVisible handled in #buttonRelease
    isButtonPressActive ifTrue:[^ self ].
    
    self hasSelection ifTrue:[
        self makeSelectionVisible
    ].

    "Created: / 25.5.1996 / 12:23:18 / cg"
    "Modified: / 7.8.1998 / 13:36:42 / cg"
!

toggleSelection:aNumber
    "toggle selection-state of entry, aNumber.
     *** No model and/or actionBlock notification is done here."

    (self isInSelection:aNumber) ifTrue:[
        self removeFromSelection:aNumber
    ] ifFalse:[
        self addToSelection:aNumber
    ]

    "Modified: 15.11.1996 / 17:02:08 / cg"
!

valueIsInSelection:someString
    "return true, if someString is in the selection"

    |sel|

    selection isNil ifTrue:[^ false].
    sel := self selectionValue.
    self numberOfSelections > 1 ifTrue:[
	^ (sel includes:someString)
    ].
    ^ (someString = sel)
! !

!SelectionInListView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

