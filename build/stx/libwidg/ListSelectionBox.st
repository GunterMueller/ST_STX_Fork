"
 COPYRIGHT (c) 1990 by Claus Gittinger
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

EnterBox subclass:#ListSelectionBox
	instanceVariableNames:'panel list selectionList selectionChangeCallback useIndex
		searchJob clearEntryFieldOnDeselect'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!ListSelectionBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    this class implements boxes for selection from a list. It offers
    both an ok- and abort-buttons. The ok-button, if pressed will
    evaluate the okAction (see EnterBox>>action).
    see examples for typical uses.

    Notice, for file selections there is a specialized FileSelectionBox,
    which supports matchPatterns, changing directory etc.

    [author:]
        Claus Gittinger
"
!

examples 
"
    simple:
                                                                        [exBegin]
        |box|

        box := ListSelectionBox new.
        box title:'select something:'.
        box list:#('foo' 'bar' 'baz').
        box okAction:[:sel | Transcript show:'the selection was:' ; showCR:sel].
        box showAtPointer
                                                                        [exEnd]

    with index (instead of list-entry) and without an enterField:
                                                                        [exBegin]
        |box|

        box := ListSelectionBox new.
        box title:'select something:'.
        box list:#('foo' 'bar' 'baz').
        box useIndex:true.
        box okAction:[:sel | Transcript show:'the selection was:' ; showCR:sel].
        box showAtPointer
                                                                        [exEnd]


    with a default:
                                                                        [exBegin]
        |box|

        box := ListSelectionBox new.
        box title:'select something:'.
        box list:#('foo' 'bar' 'baz').
        box okAction:[:sel | Transcript show:'the selection was:' ; showCR:sel].
        box initialText:'foo'.
        box showAtPointer
                                                                        [exEnd]


    opening the box modeless (a stand-by box):
    (in this case, the default ok- and abortActions do not hide the box;
     therefore, we have to set those explicitely)
                                                                        [exBegin]
        |box|

        box := ListSelectionBox new.
        box title:'select something:'.
        box list:#('foo' 'bar' 'baz').
        box abortText:'close'.
        box okText:'apply'.
        box okAction:[:sel | Transcript show:'the selection was:' ; showCR:sel].
        box abortAction:[:dummy | box hide].
        box openModeless
                                                                        [exEnd]

    showing fileNames:
                                                                        [exBegin]
        |box|

        box := ListSelectionBox new.
        box title:'select something:'.
        box list:('.' asFilename directoryContents).
        box okAction:[:sel | Transcript show:'the selection was:' ; showCR:sel].
        box showAtPointer
                                                                        [exEnd]


"
! !

!ListSelectionBox class methodsFor:'instance creation'!

title:titleString okText:okText abortText:abortText list:aList action:aBlock
    "create and return a new listSelectionBox with list already defined"

    |newBox|

    newBox := self 
                title:titleString okText:okText abortText:abortText
                action:aBlock.
    newBox list:aList.
    ^ newBox
! !

!ListSelectionBox class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ (Screen current pixelPerMillimeter * (80 @ 100)) rounded

    "Modified: 5.7.1996 / 13:53:46 / cg"
!

listViewType
    "return the type of listView 
     - for easier redefinition in subclasses"

    ^ SelectionInListView
! !

!ListSelectionBox methodsFor:'accessing'!

contents
    "return my contents"

    enterField isNil ifTrue:[
        ^ selectionList selectionValue
    ].
    ^ super contents

    "Created: 26.2.1996 / 20:05:47 / cg"
!

initialSelection:selected
    "select some item in the list"

    
    selectionList selection:selected
!

initialText:someString selected:selected
    "in addition to showing the initial text; optionally also select it in the list"

    super initialText:someString selected:selected.
    selected ifTrue:[
        selectionList setSelectElement:someString
    ].

    "Modified: 26.5.1996 / 15:03:37 / cg"
!

list:aList
    "set the list to be displayed in selection list"

    list := aList.
    selectionList list:aList

    "Modified: / 03-08-2011 / 12:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionChangeCallback:aBlock
    "allows special actions to be hooked in, when the selection changes"

    selectionChangeCallback := aBlock.
!

selectionIndex
    ^ selectionList selection

    "Created: 14.10.1996 / 16:28:50 / cg"
!

selectionList

    ^selectionList
! !

!ListSelectionBox methodsFor:'accessing-behavior'!

clearEntryFieldOnDeselect
    "normally, the entryfield's contents is not cleared,
     when the list is deselected.
     This can be changed here."

    ^ clearEntryFieldOnDeselect ? false
!

clearEntryFieldOnDeselect:aBoolean
    "normally, the entryfield's contents is not cleared,
     when the list is deselected.
     This can be changed here."

    clearEntryFieldOnDeselect := aBoolean.
!

useIndex:aBoolean
    aBoolean ifTrue:[
        self noEnterField
    ].
    useIndex := aBoolean
! !

!ListSelectionBox methodsFor:'accessing-components'!

listView
    "return the listView component"

    ^ selectionList

    "Created: 26.10.1995 / 17:08:32 / cg"
!

panelView
    ^ panel

    "Created: / 22-03-2012 / 10:30:16 / cg"
! !

!ListSelectionBox methodsFor:'accessing-look'!

noEnterField
    "suppress the enterField - now only existing items are selectable;
     the default is to present an enterField."

    enterField destroy.
    enterField := nil

    "Created: 26.10.1995 / 17:12:38 / cg"
    "Modified: 12.5.1996 / 21:49:14 / cg"
!

useComboBoxWithList:list
    "change the enterField to be a ComboList"

    self addEnterField:(ComboBoxView new).
    enterField leaveAction:[:key | self okPressed].
    enterField list:list.
! !

!ListSelectionBox methodsFor:'initialization'!

beLiveSearchBox
    #todo. "/ Jan, please comment what it does and who needs it

    enterField delegate:(
        KeyboardForwarder 
            toView:selectionList 
            condition:[:type :key :view|(key == #CursorUp) or:[key == #CursorDown]]
            filter:[:key | (key == #CursorUp) or:[key == #CursorDown]]
        ).

    searchJob := BackgroundJob 
                named: 'List Selection Box Search Job'
                on: [self filterList].

    enterField immediateAccept: true.
    enterField model: ValueHolder new.
    enterField model onChangeSend: #restart to: searchJob.

    "Created: / 03-08-2011 / 12:27:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    |space2 halfSpace v vbw|

    super initialize.

    useIndex := false.
    "/ label := resources string:'Select or Enter'.
    label := resources string:'Please Select'.

    "need more space than an enterBox"

    "self height:(height + (font height * 5)).  "

    space2 := 2 * ViewSpacing.
    halfSpace := ViewSpacing // 2.

    panel := VerticalPanelView in:self.
    panel horizontalLayout:#fit.
    panel verticalLayout:#topFit.

    v := HVScrollableView for:(self class listViewType) in:panel.
    v horizontalScrollable:true; horizontalMini:true; autoHideHorizontalScrollBar:true.

"/ old:
"/    v origin:[0.0
"/              @
"/              (enterField origin y + enterField height + ViewSpacing)]
"/      extent:[1.0
"/              @ 
"/              (height
"/               - ViewSpacing - labelField heightIncludingBorder
"/               - ViewSpacing - enterField heightIncludingBorder
"/               - buttonPanel heightIncludingBorder - ViewSpacing
"/               - space2)
"/             ].

"/ new:
    panel origin:[enterField notNil ifTrue:[
                0.0 @ (enterField origin y + enterField height + ViewSpacing)
              ] ifFalse:[
                0.0 @ (labelField origin y + labelField height + ViewSpacing)
              ]
             ]
      corner:(1.0 @ 1.0).
    panel bottomInset:(buttonPanel preferredHeight + ViewSpacing).

    vbw := v borderWidth.
    v
        leftInset:halfSpace+vbw;
        rightInset:halfSpace+vbw.

    selectionList := v scrolledView.
    self makeTabable:selectionList.

    "self updateList."

    "I am interested in what is done in the selectionList
     (could also create a SelectionInList-model and catch its changes ...)"
    selectionList action:[:lineNr | self selectionChanged].
    selectionList doubleClickAction:[:lineNr | self doubleClick].

    selectionList doNotRequestFocusOnPointerEnter:true.

    enterField removeDependent:self. "don't want preferredExtent-changes"

    enterField immediateAccept:true.
    enterField acceptAction:
                    [:text | |string index|
                        enterField notNil ifTrue:[
                            string := enterField contents.
                            string notEmptyOrNil ifTrue:[
                                "/ find the first list-entry, starting with entered text
                                index := (selectionList list ? #()) findFirst:[:line | (line ? '') string startsWith:string string].
                                index ~~ 0 ifTrue:[
                                    selectionList scrollToLine:index "/ makeLineVisible:index.
                                ].
                            ].
                        ].
                    ].

    "
     mhm: the lists keyboard functions are disabled,
     and input passed to the enterfield (except cursor keys)
    "
    selectionList delegate:(
        KeyboardForwarder 
            toView:enterField 
            condition:#noFocus
            filter:[:key | (key ~~ #CursorUp) and:[key ~~ #CursorDown]]
        )

    "Modified (format): / 22-03-2012 / 10:30:03 / cg"
!

postRealize
    "update the list now.
     This was not done in #initialize to allow settings to be changed before,
     in case list-updating is a slow operation - such as reading a directory"

    super postRealize.
    self updateList.
    self setupEditfieldToMoveToListOnCursorDown.
    
    "Modified: 12.5.1996 / 21:50:50 / cg"
    "Created: 24.7.1997 / 18:22:19 / cg"
!

setupEditfieldToMoveToListOnCursorDown
    |inputField|

    (inputField := self enterField) isNil ifTrue:[^ self].
    inputField
        onKey:#CursorDown 
        leaveWith:[
            |listView|

            listView := self listView.
            listView windowGroup focusView:listView byTab:true.
            listView hasSelection ifFalse:[
                listView selectFirst
            ] ifTrue:[
                listView selectNext
            ].
        ].
!

updateList
    "setup contents of list; 
     nothing done here but typically redefined in subclasses."

    ^ self

    "Modified: 12.5.1996 / 21:51:10 / cg"
! !

!ListSelectionBox methodsFor:'private'!

filterList

    | pattern filteredList |

    pattern := enterField model value.
    pattern isEmptyOrNil ifTrue:[
        filteredList := list.        
    ] ifFalse:[
        filteredList := list select:[:each|each asString startsWith: pattern].
    ].
    self sensor pushUserEvent: #list: for: selectionList withArgument: filteredList

    "Created: / 03-08-2011 / 12:27:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListSelectionBox methodsFor:'queries'!

preferredExtent
    "return my preferred extent 
     - that's the minimum size I like to have, to make everything visible"

    |wWanted hWanted eH mm bw|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    mm := ViewSpacing.

    wWanted := mm + labelField width + mm.
    (wWanted > width) ifFalse:[
        wWanted := width
    ].
    bw := buttonPanel preferredWidth.
    bw > wWanted ifTrue:[
        wWanted := bw.
    ].

    enterField notNil ifTrue:[
        eH := enterField height + mm
    ] ifFalse:[
        eH := 0
    ].
    hWanted := mm + labelField height +
               eH +
               mm + selectionList height +
               mm + buttonPanel preferredHeight +
               mm - (mm * 2).

    (hWanted < height) ifTrue:[
        hWanted := height
    ].
    ^ (wWanted @ hWanted)

    "Modified: 19.7.1996 / 20:44:52 / cg"
! !

!ListSelectionBox methodsFor:'user actions'!

actionArgument
    useIndex ifTrue:[
        ^self selectionIndex.
    ].
    ^ super actionArgument
!

doubleClick
    "doubleClick on an entry is select & ok"

    enterField notNil ifTrue:[
        enterField contents:(selectionList selectionValue).
    ].
    self okPressed

    "Modified: 26.2.1996 / 20:05:45 / cg"
!

selectionChanged
    "selections in list get forwarded to enterfield"

    enterField notNil ifTrue:[
        |val|
        
        val := selectionList selectionValue.
        (val notEmptyOrNil or:[self clearEntryFieldOnDeselect]) ifTrue:[
            enterField contents:val
        ].    
    ].
    selectionChangeCallback notNil ifTrue:[
        selectionChangeCallback value:selectionList selection
    ].

    "Modified: 26.10.1995 / 17:20:06 / cg"
! !

!ListSelectionBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

