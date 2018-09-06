"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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

ScrollableView subclass:#DataSetView
	instanceVariableNames:'labelView rememberedTopOffsetOfScrolledView'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DataSet'
!

!DataSetView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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
    This class implements a selection list view based on rows and columns.
    Instances are wrapping a DSVLabelView and a DSVCompumnView.
    It allows for the dynamic editing of this information.

    This is a replacement for the obsolete TableView.

    [author:]
        Claus Atzkern

    [see also:]
        DataSetColumnSpec
        DataSetColumn
        DSVColumnView
"
!

examples
"
  example 1: list with valid rows of type Array
                                                                                [exBegin]
    |top scr columns rows bool rdWtSel|

    top  := StandardSystemView new label:'Simple Test'; extent:700@440.
    scr  := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.

    columns := OrderedCollection new.
    rows    := OrderedCollection new.
    bool    := true.
    rdWtSel := #( #at: #at:put: ).

    1 to:1000 do:[:i||n|
        n := i printString.
        rows add:(Array with:('text: ', n) with:('input: ', n) with:bool with:(i==20)).
        bool := bool not.
    ].

    columns add:(DataSetColumnSpec label:'Text'   editorType:#None        selector:rdWtSel).
    columns add:(DataSetColumnSpec label:'Input'  editorType:#InputField  selector:rdWtSel).
    columns add:(DataSetColumnSpec label:'Toggle' editorType:#CheckToggle selector:rdWtSel).
    columns add:(DataSetColumnSpec label:'Radio'  editorType:#RadioButton selector:rdWtSel).

    scr columnDescriptors:columns.
    scr list:rows.
    top open.
                                                                                [exEnd]



  example 2: list with none valid rows; defining #rowIfAbsent: block
                                                                                [exBegin]
    |top scr columns bool rdWtSel|

    top  := StandardSystemView new label:'Row Is Absent'; extent:700@440.
    scr  := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.

    columns := OrderedCollection new.
    bool    := true.
    rdWtSel := #( #at: #at:put: ).

    columns add:(DataSetColumnSpec label:'Text'   editorType:#None        selector:rdWtSel).
    columns add:(DataSetColumnSpec label:'Input'  editorType:#InputField  selector:rdWtSel).
    columns add:(DataSetColumnSpec label:'Toggle' editorType:#CheckToggle selector:rdWtSel).

    scr rowIfAbsent:[:i|
        bool := bool not.
        Array with:('text: ', i printString) with:('input: ') with:bool
    ].

    scr columnDescriptors:columns.
    scr list:(Array new:1000).
    top open.
                                                                                [exEnd]



  example 3: list with valid rows of type Structure
                                                                                [exBegin]
    |top scr clDc rows slct list idx bool|

    top  := StandardSystemView new label:'Editors'; extent:700@440.
    scr  := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.

    clDc := OrderedCollection new.
    rows := OrderedCollection new.
    list := #( 'Text ' 'Field ' 'C-Box ' 'C-List ' true    #( 'foo' 'bar' 'baz' ) ).
    slct := #( #text   #field   #cbox    #clist    #toggle #choices               ).
    idx  := 11.
    bool := true.

    20 timesRepeat:[ |values|
        values := list collect:[:n|
            n isString ifTrue:[n, idx printString]
                      ifFalse:[n == true ifTrue:[bool] ifFalse:[n]]
        ].
        rows add:(Structure newWith:slct values:values).
        bool := bool not.
        idx  := idx + 1.
    ].
    clDc add:( DataSetColumnSpec label:'Text'   editorType:#None        selector:#text ).
    clDc add:( DataSetColumnSpec label:'Text'   editorType:#None        selector:#text ).
    clDc add:( DataSetColumnSpec label:'Field'  editorType:#InputField  selector:#field ).
    clDc add:( DataSetColumnSpec label:'C-Box'  editorType:#ComboBox    selector:#cbox ).
    clDc last choices:#choices.
    clDc add:( DataSetColumnSpec label:'C-List' editorType:#ComboList   selector:#clist ).
    clDc last choices:#choices.
    clDc add:( DataSetColumnSpec label:'Toggle' editorType:#CheckToggle selector:#toggle ).

    scr has3Dseparators:true.
    scr columnDescriptors:clDc.
    scr list:rows.
    top open.
                                                                                [exEnd]




  example 4: table includes a row selector and multiple select is enabled
                                                                                [exBegin]
    |top scr clDc rows slct list idx bool|

    top  := StandardSystemView new label:'Multiple Select'; extent:700@440.
    scr  := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.

    clDc := OrderedCollection new.
    rows := OrderedCollection new.
    list := #( 'Text ' 'Field ' 'C-Box ' 'C-List ' true    #( 'foo' 'bar' 'baz' ) ).
    slct := #( #text   #field   #cbox    #clist    #toggle #choices               ).
    idx  := 11.
    bool := true.

    20 timesRepeat:[ |values|
        values := list collect:[:n|
            n isString ifTrue:[n, idx printString]
                      ifFalse:[n == true ifTrue:[bool] ifFalse:[n]]
        ].
        rows add:(Structure newWith:slct values:values).
        bool := bool not.
        idx  := idx + 1.
    ].
    clDc add:( DataSetColumnSpec rowSelector ).
    clDc add:( DataSetColumnSpec label:'Text'   editorType:#None        selector:#text ).
    clDc add:( DataSetColumnSpec label:'Text'   editorType:#None        selector:#text ).
    clDc add:( DataSetColumnSpec label:'Field'  editorType:#InputField  selector:#field ).
    clDc add:( DataSetColumnSpec label:'C-Box'  editorType:#ComboBox    selector:#cbox ).
    clDc last choices:#choices.
    clDc add:( DataSetColumnSpec label:'C-List' editorType:#ComboList   selector:#clist ).
    clDc last choices:#choices.
    clDc add:( DataSetColumnSpec label:'Toggle' editorType:#CheckToggle selector:#toggle ).

    scr has3Dseparators:true.
    scr columnDescriptors:clDc.
    scr multipleSelectOk:true.
    scr list:rows.
    top open.
                                                                                [exEnd]


  example 5: Images and Layout
                                                                                [exBegin]
    |top scr columns rows colDesc image text|

    text := 'Text'.
    rows := Array new:1000.

    1 to:(rows size) do:[:i|
        rows at:i put:(Array with:('Id: ', i printString) with:text with:text)
    ].

    columns := OrderedCollection new.
    image   := Image fromFile:('xpmBitmaps/misc_tools/box_full.xpm' ).

    colDesc := DataSetColumnSpec label:(LabelAndIcon icon:image string:'Left') selector:#at:.
    colDesc labelAlignment:#left.
    colDesc columnAlignment:#left.
    columns add:colDesc.

    colDesc := DataSetColumnSpec label:(LabelAndIcon icon:image string:'Right') selector:#at:.
    colDesc labelAlignment:#right.
    colDesc columnAlignment:#right.
    columns add:colDesc.

    colDesc := DataSetColumnSpec label:(LabelAndIcon icon:image string:'Center') selector:#at:.
    colDesc labelAlignment:#center.
    colDesc columnAlignment:#center.
    columns add:colDesc.

    columns do:[:el|el labelActionSelector:#dummy].

    top := StandardSystemView new label:'Layout'; extent:500@500.
    scr := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr has3Dseparators:true.
    scr columnDescriptors:columns.
    scr list:rows.

    top open
                                                                                [exEnd]



  example 6: adding and removing
                                                                                [exBegin]
    |top scr list|

    top  := StandardSystemView new label:'Adding & Removing'; extent:600@440.
    scr  := DataSetView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.

    scr columnDescriptors:( Array with:(DataSetColumnSpec label:'FOO' selector:#at:)
                                  with:(DataSetColumnSpec label:'BAR' selector:#at:)
                                  with:(DataSetColumnSpec label:'BAZ' selector:#at:)
                          ).

    scr has3Dseparators:true.
    scr listHolder:(list := List new).
    top openAndWait.

    1 to:32 do:[:i| |pid|
        pid := i printString.
        list add:(Array with:('foo: ', pid) with:('bar: ', pid) with:('baz: ', pid)).
        i even ifTrue:[
            list removeFirst
        ].       
        Delay waitForSeconds:0.1.
    ].
                                                                                [exEnd]


"
! !

!DataSetView methodsFor:'accessing'!

columnView
    ^ scrolledView
!

ignoreReselect: aBoolean
    "Defined here to make it polymorph with SelectionInListView"

    "Created: / 28-06-2013 / 11:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelView
    ^ labelView
! !

!DataSetView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == labelView ifTrue:[
        ((something == #columnLayout) 
        or:[something == #visibility]) ifTrue:[
            self recomputeLayouts.
            ^ self
        ].
    ].

    super update:something with:aParameter from:changedObject
! !

!DataSetView methodsFor:'initialization & release'!

initialize
    "set column area
    "
    |columnView|

    "/ preset flags to avoid creation and later destruction of scrollBars ...
    self setVertical:true mini:false horizontal:true mini:true.
    super initialize.

    self setupVertical:true mini:false horizontal:true mini:true.

    labelView := DSVLabelView in:self.
    columnView := DSVColumnView new.
    columnView labelView:labelView.

    "/ columnView addDependent:self.
    labelView addDependent:self.

    self scrolledView:columnView.
! !

!DataSetView methodsFor:'layout computation'!

recomputeLayouts
    |columnView columnViewLayout newOffset|

    columnView := self scrolledView.
    columnView isNil ifTrue:[^ self].
    (columnViewLayout := columnView layout) isNil ifTrue:[^ self].

    labelView isVisible ifFalse:[
        newOffset := scrolledViewLayout topOffset.
    ] ifTrue:[
        newOffset := scrolledViewLayout topOffset + (columnView preferredLabelViewHeight).
    ].

    newOffset ~~ columnViewLayout topOffset ifTrue:[
        columnViewLayout topOffset:newOffset.
"/        columnView realized ifTrue:[
            columnView containerChangedSize.
"/        ]
    ].
    labelView containerChangedSize.
!

scrolledViewLayout:aLayout
    "invoked by superclasses setLayout method, whenever the scrolled views
     layout changes (due to added/removed scrollbars)."

    |modifiedLayout originalTopOffset labelViewLayout newLeft newRight|

    "/ always copy - since layout it destructively modified in #recomputeLayouts
    modifiedLayout := aLayout copy.    

    originalTopOffset := scrolledViewLayout topOffset.
    labelView isVisible ifTrue:[
        modifiedLayout topOffset:(originalTopOffset + labelView height).
    ].

    newLeft := aLayout leftOffset.
    newRight := aLayout rightOffset.

    (scrolledView level == 0
    and:[self level < 0 
    and:[labelView level == 0]]) ifTrue:[
        newRight := (newRight + 1) min:0.
        modifiedLayout rightOffset:newRight.
    ].

    labelViewLayout := labelView layout.
    labelViewLayout topOffset:originalTopOffset.
    labelViewLayout 
        leftOffset:newLeft 
        rightOffset:newRight.

    labelView isVisible ifTrue:[
        labelView containerChangedSize.
    ].
    super scrolledViewLayout:modifiedLayout
!

verticalScrollBarLayout:aLayout
    "redefined to care for the label view, 
     which is at the top and NOT scrolled.
     It covers the top areay of myself, so we have to make the vertical
     scrollbar a little smaller."

    labelView notNil ifTrue:[
        aLayout topOffset:(aLayout topOffset + labelView height).
    ].    
    super verticalScrollBarLayout:aLayout
! !

!DataSetView methodsFor:'queries'!

canTab
    ^ labelView notNil and:[labelView enabled]
!

preferredExtent
    "return my preferredExtent from the scrolledViews prefExtent
     plus the size of the scrollBar"

    |preferred|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    preferred := super preferredExtent.
    ^ (preferred x) @ (preferred y + labelView preferredHeight).

    "Created: 6.3.1997 / 18:06:24 / cg"
    "Modified: 6.3.1997 / 22:34:09 / cg"
!

specClass
    "returns my spec class
    "
    ^ DataSetSpec
! !

!DataSetView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

