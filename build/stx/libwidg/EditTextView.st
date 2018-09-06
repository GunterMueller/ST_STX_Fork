"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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

TextView subclass:#EditTextView
	instanceVariableNames:'cursorLine cursorVisibleLine cursorCol cursorShown
		prevCursorState readOnly modifiedChannel fixedSize exceptionBlock
		cursorFgColor cursorBgColor cursorNoFocusFgColor cursorType
		cursorTypeNoFocus typeOfSelection lastAction replacing
		showMatchingParenthesis hasKeyboardFocus acceptAction lockUpdates
		tabMeansNextField autoIndent insertMode editMode trimBlankLines
		wordWrap replacementWordSelectStyle acceptChannel acceptEnabled
		st80Mode disableIfInvisible cursorMovementWhenUpdating learnMode
		learnedMacro cursorLineHolder cursorColHolder tabRequiresControl
		undoSupport lastStringFromReplaceForNextSearch
		lastReplacementInfo completionSupport codeAspectHolder'
	classVariableNames:'DefaultCursorForegroundColor DefaultCursorBackgroundColor
		DefaultCursorType DefaultCursorNoFocusForegroundColor
		DefaultCursorTypeNoFocus LastColumnNumberForSort Macros'
	poolDictionaries:''
	category:'Views-Text'
!

Object subclass:#EditAction
	instanceVariableNames:'userFriendlyInfo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#DeleteRange
	instanceVariableNames:'line1 col1 line2 col2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#DeleteCharacters
	instanceVariableNames:'line col1 col2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

Object subclass:#EditMode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditMode subclass:#InsertAndSelectMode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView::EditMode
!

EditTextView::EditMode subclass:#InsertMode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView::EditMode
!

EditTextView::EditMode subclass:#OverwriteMode
	instanceVariableNames:''
	classVariableNames:'InsertMode OverwriteMode InsertAndSelectMode'
	poolDictionaries:''
	privateIn:EditTextView::EditMode
!

Query subclass:#ExecutingMacroQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

Object subclass:#LastReplacementInfo
	instanceVariableNames:'lastReplacement lastStringToReplace lastReplaceWasMatch
		lastReplaceIgnoredCase stillCollectingInput previousReplacements'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#PasteString
	instanceVariableNames:'line col string selected'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#ReplaceCharacter
	instanceVariableNames:'line col character'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#ReplaceCharacters
	instanceVariableNames:'line col1 col2 characters'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#ReplaceContents
	instanceVariableNames:'text'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#ReplaceLine
	instanceVariableNames:'line text'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#ReplaceLines
	instanceVariableNames:'line text'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

EditTextView::EditAction subclass:#RestoreSelectionAndCursor
	instanceVariableNames:'cursorLine cursorCol selectionStartLine selectionStartCol
		selectionEndLine selectionEndCol'
	classVariableNames:''
	poolDictionaries:''
	privateIn:EditTextView
!

!EditTextView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    a view for editable text - adds editing functionality to TextView
    Also, it adds accept functionality, and defines a new actionBlock:
    acceptAction to be performed for accept

    If used with a model, this is informed by sending it a changeMsg with
    the current contents as argument.
    (however, it is possible to define both changeMsg and acceptAction)

    Please read the historic notice in the ListView class.

    [Instance variables:]

        cursorLine              <Number>        line where cursor sits (1..)

        cursorVisibleLine       <Number>        visible line where cursor sits (1..nLinesShown)

        cursorCol               <Number>        col where cursor sits (1..)

        cursorShown             <Boolean>       true, if cursor is currently shown

        readOnly                <Boolean>       true, if text may not be edited

        modifiedChannel         <ValueHolder>   holding true, if text has been modified.
                                                cleared on accept.

        acceptChannel           <ValueHolder>   holding true, if text has been accepted.

        fixedSize               <Boolean>       true, if no lines may be added/removed

        exceptionBlock          <Block>         block to be evaluated when readonly text is about to be modified
                                                if it returns true, the modification will be done anyway.
                                                if it returns anything else, the modification is not done.

        cursorFgColor           <Color>         color used for cursor drawing
        cursorBgColor           <Color>         color used for cursor drawing

        cursorType              <Symbol>        how the cursor is drawn; currently implemented
                                                are #none, #block (solid-block cursor), #ibeam
                                                (vertical bar at insertion point)
                                                and #caret (caret below insertion-point).
                                                see cursorType: for an up-to-date list.

        cursorTypeNoFocus       <Symbol>        like above, if view has no focus
                                                nil means: hide the cursor.

        undoAction              <Block>         block which undoes last cut, paste or replace
                                                (not yet fully implemented)

        typeOfSelection         <Symbol>        #paste, if selection created by paste, nil otherwise
                                                this affects the next keyPress: if #paste it does not
                                                replace; otherwise it replaces the selection.

        lastCut                 <String>        last cut or replaced string

        lastReplacementInfo     <LastReplacementInfo>        holds the information about the last replace action
                                                             lastStringToReplace is the string to be replaced by lastReplacement
                                                             lastReplacement is the string to replace lastStringToReplace

        lastStringFromReplaceForNextSearch   <String>        string to be taken be the next search action 
                                                             (cleared after a new selection)

        replacing               <Boolean>       true if entered characters replace last selection

        showMatchingParenthesis <Boolean>       if true, shows matching parenthesis
                                                when entering one; this is the default.

        hasKeyboardFocus        <Boolean>       true if this view has the focus

        acceptAction            <Block>         accept action - evaluated passing the contents as
                                                argument

        tabMeansNextField       <Boolean>       if true, Tab is ignored as input and shifts keyboard
                                                focus to the next field. For editTextViews, this is false
                                                by default (i.e. tabs can be entered into the text).
                                                For some subclasses (inputFields), this may be true.

        trimBlankLines          <Boolean>       if true, trailing blanks are
                                                removed when editing.
                                                Also, empty lines are represented as nil in the lines collection.
                                                Default is true.

        wordWrap                <Boolean>       Currently not used.

        lockUpdates             <Boolean>       internal, private

        prevCursorState         <Boolean>       temporary, private

        cursorMovementWhenUpdating
                                <Symbol>        defines where the cursor is to be positioned if the
                                                model changes its value by some outside activity
                                                (i.e. not by user input into the field).
                                                Can be one of:
                                                    #keep / nil     -> stay where it was
                                                    #endOfText      -> cursor to the end
                                                    #endOfLine      -> stay in the line, but move to end
                                                    #beginOfText    -> cursor to the beginning
                                                    #beginOfLine    -> stay in the line, but move to begin
                                                The default is #beginOfText



        dropTarget              <DropTarget|nil> drop operation descriptor or nil (drop disabled)


    userPreference values:
        userPreferences.st80EditMode
                                <Boolean>       if true, cursor positioning is
                                                done as in vi or ST80; i.e.
                                                wysiwyg mode is somewhat relaxed,
                                                in that the cursor cannot be
                                                positioned behind a lines end.
                                                This is not yet completely implemented.
    used globals:

        DeleteHistory           <Text>          last 1000 lines of deleted text
                                                (but only if this variable exists already)

    [styleSheet parameters:]

        textCursorForegroundColor <Color>          cursor fg color; default: text background
        textCursorBackgroundColor <Color>          cursor bg color; default: text foreground
        textCursorNoFocusForegroundColor
                                  <Color>          cursor fg color if no focus; default: cursor fg color
        textCursorType            <Symbol>         cursor type; default:  #block

    [author:]
        Claus Gittinger

    [see also:]
        CodeView Workspace TextView ListView
        EditField
"
!

examples
"
  non MVC operation:

    basic setup:
                                                                        [exBegin]
        |top textView|

        top := StandardSystemView new.
        top extent:300@200.

        textView := EditTextView new.
        textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:textView.

        textView contents:('/etc/hosts' asFilename contentsOfEntireFile).

        top open.
                                                                        [exEnd]


    with vertical scrollbar:
                                                                        [exBegin]
        |top scrollView textView|

        top := StandardSystemView new.
        top extent:300@200.

        scrollView := ScrollableView for:EditTextView.
        textView := scrollView scrolledView.
        scrollView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:scrollView.

        textView contents:('/etc/hosts' asFilename contentsOfEntireFile).

        top open.
                                                                        [exEnd]


    with horizontal & vertical scrollbars:
                                                                        [exBegin]
        |top scrollView textView|

        top := StandardSystemView new.
        top extent:300@200.

        scrollView := HVScrollableView for:EditTextView.
        textView := scrollView scrolledView.
        scrollView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:scrollView.

        textView contents:('/etc/hosts' asFilename contentsOfEntireFile).

        top open.
                                                                        [exEnd]


    set the action for accept:
                                                                        [exBegin]
        |top textView|

        top := StandardSystemView new.
        top extent:300@200.

        textView := EditTextView new.
        textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:textView.

        textView contents:('/etc/hosts' asFilename contentsOfEntireFile).
        textView acceptAction:[:contents |
                                Transcript showCR:'will not overwrite the file with:'.
                                Transcript showCR:contents asString
                              ].
        top open.
                                                                        [exEnd]



    non-string (text) items:
                                                                        [exBegin]
        |top textView list|

        list := '/etc/hosts' asFilename contentsOfEntireFile asStringCollection.
        1 to:list size by:2 do:[:nr |
            list at:nr put:(Text string:(list at:nr)
                                 emphasis:(Array with:#bold with:(#color->Color red)))
        ].

        top := StandardSystemView new.
        top extent:300@200.

        textView := EditTextView new.
        textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:textView.

        textView contents:list.
        top open.
                                                                        [exEnd]



  MVC operation:
    (the examples model here is a plug simulating a real model;
     real world applications would not use a plug ..)
                                                                        [exBegin]
        |top textView model|

        model := Plug new.
        model respondTo:#accepted:
                   with:[:newContents |
                                Transcript showCR:'will not overwrite the file with:'.
                                Transcript showCR:newContents asString
                        ].
        model respondTo:#getList
                   with:['/etc/hosts' asFilename contentsOfEntireFile].


        top := StandardSystemView new.
        top extent:300@200.

        textView := EditTextView new.
        textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top addSubView:textView.

        textView listMessage:#getList;
                 model:model;
                 changeMessage:#accepted:;
                 aspect:#list.
        top open.
                                                                        [exEnd]


    two textViews on the same model:
                                                                        [exBegin]
        |top1 textView1 top2 textView2 model currentContents|

        model := Plug new.
        model respondTo:#accepted:
                   with:[:newContents |
                                Transcript showCR:'accepted:'.
                                Transcript showCR:newContents asString.
                                currentContents := newContents.
                                model changed:#contents
                        ].
        model respondTo:#getList
                   with:[Transcript showCR:'query'.
                         currentContents].


        top1 := StandardSystemView new.
        top1 extent:300@200.

        textView1 := EditTextView new.
        textView1 origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top1 addSubView:textView1.

        textView1 listMessage:#getList;
                  model:model;
                  aspect:#contents;
                  changeMessage:#accepted:.
        top1 open.

        top2 := StandardSystemView new.
        top2 extent:300@200.

        textView2 := EditTextView new.
        textView2 origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        top2 addSubView:textView2.

        textView2 listMessage:#getList;
                  model:model;
                  aspect:#contents;
                  changeMessage:#accepted:.
        top2 open.
                                                                        [exEnd]
"
!

selection_and_cursor_movement
"
Changes done to implement 'standard' behaviour (that's how vast majority of widgets used in todays desktops behaves)
as opposed to 'traditional' which is what how it was in St/X 'ever since'

* Numerous off-by-one bugs

* Extending selection by dragging:
  Scenario:
    1. Select & drag to expand beggining of the selection (i.e., drag from 'end' to 'beggining'
    2. Stop dragging
    3. Press Shift-Left / Shift-Right (to refine selection)

    Traditional ST/X: end of selection is moved
    Standard:  beginning of selection is moved
      (checked on Notepad, Gedit (GTK+), Sublime (Win+Lin), Eclipse, Firefox)

* Extending selection by Shift-Home / Shift-End
  Scenario:
    1. Position cursor in the middle of the line
    2. Press Shift-Home (line for beginning should be selected)
    3. Press Shift-Right (to refine selection)

    Traditional ST/X: end of selection is moved
    Standard:  beginning of selection is moved
      (checked on Notepad, Gedit (GTK+), Sublime (Win+Lin), Eclipse, Firefox)

* Selection flip by Shift-Home / Shift-End
  Scenario A:
    1. Position cursor in the middle of the line to column C
    2. Press Shift-Home (line from beginning should be selected)
    2. Press Shift-End

    Traditional ST/X: end of selection is moved so whole line is selected
    Standard: Selection 'flips' so part of line from column C to the end is selected
      (checked on Notepad, Gedit (GTK+), Sublime (Win+Lin), Eclipse, Firefox)

  Scenario B:
    1. Position cursor in the middle of the line to column C
    2. Press Shift-End (column C to the end of line should be selected)
    2. Press Shift-Home

    Traditional ST/X: beginning of selection is moved so whole line is selected
    Standard: Selection 'flips' so part of line from the beginning to column C is selected
      (checked on Notepad, Gedit (GTK+), Sublime (Win+Lin), Eclipse, Firefox)

  NOTE: This could be controlled by 
    UserPreferences current selectionExtensionMode


* Extending selection with Ctrl-Shift-Left / Ctrl-Shift-Right
  Scenario A:
    1. Position cursor in the middle of the line to column C
    2. Select word
    3. Press Ctrl-Shift-Right, Ctrl-Shift-Right

    Traditional ST/X: nothing happens at all
    Standard: Selection is extended to include a space (first press) and a word right to previously selected one
      (checked on Notepad, Gedit (GTK+), Sublime (Win+Lin), Eclipse, Firefox)

* Indenting selected block with Tab
  Scenario:
    1. Select a block (i.e, make selection that pans multiple lines)
    2. Press Tab

    Traditional St/X: A single 'tab' is inserted
    Standard: all lines in the selection are indented.

"
! !

!EditTextView class methodsFor:'defaults'!

defaultCompletionSupportClass
    ^ nil

    "Created: / 26-09-2013 / 17:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

st80Mode
    "return true, if the st80 editing mode is turned on.
     This setting affects the behavior of the cursor, when positioned
     beyond the end of a line or the end of the text.
     This method is here for backward compatibility, when this flag was stored
     in a class var. It is now in the user's settings.
     Please do not call it, but go to the prefs directly, to make it easier to find those getters."

    ^ UserPreferences current st80EditMode

   "
    EditTextView st80Mode:true
    EditTextView st80Mode:false
   "

    "Modified: / 16.1.1998 / 22:54:57 / cg"
!

st80Mode:aBoolean
    "turns on/off st80 behavior, where the cursor cannot be positioned
     beyond the end of a line or the last line.
     This method is here for backward compatibility, when this flag was stored
     in a class var. It is now in the user's settings.
     Please do not call it, but go to the prefs directly, to make it easier to find those setters."

    UserPreferences current st80EditMode:aBoolean.

   "
    EditTextView st80Mode:true
    EditTextView st80Mode:false
   "

    "Modified: / 16.1.1998 / 22:55:19 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'textCursor.foregroundColor' #'textCursor.backgroundColor'
                       #'textCursor.noFocusForegroundColor'
                       #'textCursor.type'
                       #'textCursor.typeNoFocus'
                       #'editText.st80Mode')>

    DefaultCursorForegroundColor := StyleSheet colorAt:'textCursor.foregroundColor'.
    DefaultCursorBackgroundColor := StyleSheet colorAt:'textCursor.backgroundColor'.
    DefaultCursorNoFocusForegroundColor := StyleSheet colorAt:'textCursor.noFocusForegroundColor'.
    DefaultCursorType := StyleSheet at:'textCursor.type' default:#block.
    DefaultCursorTypeNoFocus := StyleSheet at:'textCursor.typeNoFocus'.

    "
     self updateStyleCache
    "

    "Modified: / 20.5.1998 / 04:27:41 / cg"
! !

!EditTextView class methodsFor:'specs'!

searchReplaceDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DAPASX::ProjectEditorTextView andSelector:#searchReplaceDialogSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: searchReplaceDialogSpec
        window:
       (WindowSpec
          label: 'String Search and Replace'
          name: 'String Search and Replace'
          min: (Point 283 196)
          max: (Point 283 196)
          bounds: (Rectangle 0 0 279 192)
        )
        component:
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Search Pattern:'
              name: 'label'
              layout: (LayoutFrame 1 0.0 3 0 -1 1.0 20 0)
              level: 0
              translateLabel: true
              adjust: left
            )
           (ComboBoxSpec
              name: 'patternComboBox'
              layout: (LayoutFrame 3 0.0 26 0 -3 1.0 48 0)
              tabable: true
              model: searchPattern
              immediateAccept: false
              acceptOnLeave: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
              autoSelectInitialText: true
              comboList: patternList
            )
           (ComboBoxSpec
              name: 'replaceComboBox'
              layout: (LayoutFrame 3 0.0 76 0 -3 1.0 98 0)
              tabable: true
              model: replacePattern
              immediateAccept: false
              acceptOnLeave: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
              autoSelectInitialText: true
              comboList: patternList
            )
           (CheckBoxSpec
              label: 'Ignore Case'
              name: 'ignoreCaseCheckBox'
              layout: (LayoutFrame 3 0.0 107 0 -3 1.0 130 0)
              level: 0
              tabable: true
              model: ignoreCase
              translateLabel: true
            )
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0 -64 1 0 1 -4 1)
              component:
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'HorizontalPanel1'
                    level: 0
                    horizontalLayout: fitSpace
                    verticalLayout: center
                    horizontalSpace: 3
                    verticalSpace: 3
                    ignoreInvisibleComponents: true
                    reverseOrderIfOKAtLeft: true
                    component:
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'Replace'
                          name: 'replaceButton'
                          level: 2
                          translateLabel: true
                          tabable: true
                          model: replaceAction
                          extent: (Point 134 21)
                        )
                       (ActionButtonSpec
                          label: 'Replace All'
                          name: 'replaceAllButton'
                          level: 2
                          borderWidth: 1
                          translateLabel: true
                          tabable: true
                          model: replaceAllAction
                          extent: (Point 134 21)
                        )
                       )

                    )
                  )
                 (HorizontalPanelViewSpec
                    name: 'horizontalPanelView'
                    level: 0
                    horizontalLayout: fitSpace
                    verticalLayout: center
                    horizontalSpace: 3
                    verticalSpace: 3
                    ignoreInvisibleComponents: true
                    reverseOrderIfOKAtLeft: true
                    component:
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'Cancel'
                          name: 'cancelButton'
                          level: 2
                          translateLabel: true
                          tabable: true
                          model: cancel
                          extent: (Point 88 21)
                        )
                       (ActionButtonSpec
                          label: 'Prev'
                          name: 'prevButton'
                          level: 2
                          translateLabel: true
                          tabable: true
                          model: prevAction
                          extent: (Point 89 21)
                        )
                       (ActionButtonSpec
                          label: 'Next'
                          name: 'nextButton'
                          level: 2
                          borderWidth: 1
                          translateLabel: true
                          tabable: true
                          model: nextAction
                          isDefault: true
                          extent: (Point 88 21)
                        )
                       )

                    )
                  )
                 )

              )
              handles: (Any 0.5 1.0)
            )
           (LabelSpec
              label: 'Replace By:'
              name: 'ReplaceLabel'
              layout: (LayoutFrame 1 0.0 53 0 -1 1.0 70 0)
              level: 0
              translateLabel: true
              adjust: left
            )
           )

        )
      )

    "Modified: / 11-10-2006 / 21:05:09 / cg"
! !

!EditTextView methodsFor:'Compatibility-ST80'!

autoAccept:aBoolean
    "ignored for now"

    "Created: / 5.6.1998 / 15:30:32 / cg "
!

continuousAccept:aBoolean
    "ignored for now"

    "Created: / 19.6.1998 / 00:03:49 / cg"
!

cutSelection
    self cut

    "Created: / 31.10.1997 / 03:29:50 / cg"
!

deselect
    "remove the selection"

    ^ self unselect

    "Created: / 19.6.1998 / 02:41:54 / cg"
!

enabled:aBoolean

    self readOnly:aBoolean not

    "Created: / 30.3.1999 / 15:10:23 / stefan"
    "Modified: / 30.3.1999 / 15:10:53 / stefan"
!

find:pattern
    self searchFwd:pattern ifAbsent:nil

    "Created: / 29.1.1999 / 19:09:42 / cg"
    "Modified: / 29.1.1999 / 19:10:12 / cg"
!

insert:aString at:aCharacterPosition
    "insert a string at aCharacterPosition."

    |line col|

    line := self lineOfCharacterPosition:aCharacterPosition.
    col := aCharacterPosition - (self characterPositionOfLine:line col:1) + 1.
    col < 1 ifTrue:[
        col := 1
    ].
    self insertString:aString atLine:line col:col.

    "
     |top v|

     top := StandardSystemView new.
     top extent:300@300.
     v := EditTextView origin:0.0@0.0 corner:1.0@1.0 in:top.
     top openAndWait.
     v contents:'1234567890\1234567890\1234567890\' withCRs.
     v insert:'<- hello there' at:5.
    "

    "Modified: / 5.4.1998 / 17:20:08 / cg"
!

insertAndSelect:aString at:aCharacterPosition
    "insert a selected string at aCharacterPosition."

    |line col|

    line := self lineOfCharacterPosition:aCharacterPosition.
    col := (aCharacterPosition - (self characterPositionOfLine:line col:1) + 1) max:1.
    self insertString:aString atLine:line col:col.
    self selectFromLine:line col:col toLine:line col:col + aString size - 1
    "
     |v|

     v := EditTextView new openAndWait.
     v contents:'1234567890\1234567890\1234567890\' withCRs.
     v insertAndSelect:'<- hello there' at:5.
    "
!

pasteSelection
    self paste

    "Created: / 31.10.1997 / 03:28:53 / cg"
!

replaceSelectionWith:aString
    ^ self replaceSelectionBy:aString

    "Created: / 19.6.1998 / 02:42:32 / cg"
!

selectAt:pos
    "move the cursor before cursorPosition."

    self cursorToCharacterPosition:pos

    "Modified: / 19.6.1998 / 02:41:28 / cg"
    "Created: / 19.6.1998 / 02:43:39 / cg"
!

textHasChanged
    ^ self modified

    "Created: / 19.6.1998 / 00:09:43 / cg"
!

textHasChanged:aBoolean
    "ST-80 compatibility: set/clear the modified flag."

    self modified:aBoolean

    "Created: / 5.2.2000 / 17:07:59 / cg"
! !

!EditTextView methodsFor:'accessing'!

codeAspect
    | codeAspect app |

    codeAspect := codeAspectHolder value.
    codeAspect notNil ifTrue:[^codeAspect].
    self editedMethod notNil ifTrue:[^SyntaxHighlighter codeAspectMethod].

    "/ Applications should set it explictly, however, to make it behavinh like
    "/ CodeView2, I kept fetching code here for now.
    ^((app := self topView application) notNil and:[app respondsTo: #codeAspect])
        ifTrue:[app codeAspect]
        ifFalse:[nil]

    "Created: / 27-09-2013 / 09:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspect: aSymbol
    codeAspectHolder value: aSymbol

    "Created: / 27-09-2013 / 09:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionSupport
    ^ completionSupport
!

completionSupport:anEditTextViewCompletionSupport
    completionSupport := anEditTextViewCompletionSupport.
!

completionSupportClass
    ^ self class defaultCompletionSupportClass

    "Created: / 26-09-2013 / 17:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedClass
    |cm|

    cm := self editedMethodOrClass.
    cm isBehavior ifTrue:[^ cm].
    cm isMethod ifTrue:[^ cm mclass].
    ^ nil
!

editedLanguage
    ^ nil

    "Created: / 18-09-2013 / 14:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedLanguage: aProgrammingLanguage
    "Sets the edited language. Only defined here to make it polymorph with Workspace"

    "Created: / 27-09-2013 / 10:15:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedMethod
    |cm|

    cm := self editedMethodOrClass.
    cm isMethod ifTrue:[^ cm].
    cm isBehavior ifTrue:[^ nil].
    ^ nil
!

editedMethodOrClass
    ^ nil
!

editedMethodOrClass: methodOrClass
    "Sets the edited method or class. Only defined here to make it polymorph with Workspace"

    "Created: / 27-09-2013 / 10:10:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelectionOrTextInCursorLine
    ^ (self selectionOrTextOfCursorLine:false) notNil
!

selectionOrTextOfCursorLine
    ^ self selectionOrTextOfCursorLine:true
!

selectionOrTextOfCursorLine:doSelect
    |sel lNr line|

    sel := self selectionAsString.
    sel notNil ifTrue:[^ sel].

    lNr := self cursorLine.
    line := self listAt:lNr.
    line notEmptyOrNil ifTrue:[
        doSelect ifTrue:[
            self selectLine:lNr.
        ].
        ^ line
    ].

    ^ nil
! !

!EditTextView methodsFor:'accessing-behavior'!

acceptAction
    "return the action to be performed on accept (or nil)"

    ^ acceptAction
!

acceptAction:aBlock
    "set the action to be performed on accept"

    acceptAction := aBlock
!

acceptChannel
    "return the valueHolder holding true if text was accepted.
     By placing a true into this channel, an accept can also be forced."

    ^ acceptChannel

    "Modified: / 30.1.1998 / 14:17:11 / cg"
!

acceptChannel:aValueHolder
    "set the valueHolder holding true if text was accepted.
     By placing a true into this channel, an accept can also be forced."

    |prev|

    prev := acceptChannel.
    acceptChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev

    "Created: / 30.1.1998 / 14:51:09 / cg"
!

acceptEnabled:aBoolean
    "enable/disable accept. This greys the corresponding item in the menu"

    acceptEnabled := aBoolean

    "Created: 7.3.1997 / 11:04:34 / cg"
!

accepted
    "return true if text was accepted"

    ^ acceptChannel value

    "Created: 14.2.1997 / 16:43:46 / cg"
!

accepted:aBoolean
    "set/clear the accepted flag.
     This may force my current contents to be placed into my model."

    acceptChannel value:aBoolean.

    "Created: / 14.2.1997 / 16:44:01 / cg"
    "Modified: / 30.1.1998 / 14:20:15 / cg"
!

autoIndent:aBoolean
    autoIndent := aBoolean

    "Created: 5.3.1996 / 14:37:50 / cg"
!

codeAspectHolder
    ^ codeAspectHolder
!

codeAspectHolder:something
    codeAspectHolder := something.
!

cursorMovementWhenUpdating
    "return what is be done with the cursor,
     when I get a new text (via the model or the #contents/#list)
     Allowed arguments are:
        #keep / nil     -> stay where it was
        #endOfText      -> position cursor to the end
        #beginOfText    -> position cursor to the beginning
        #endOfLine      -> position cursor to the current lines end
        #beginOfLine    -> position cursor to the current lines start
     The default is #beginOfText.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    ^ cursorMovementWhenUpdating

    "Modified: 16.12.1995 / 16:27:55 / cg"
!

cursorMovementWhenUpdating:aSymbolOrNil
    "define what should be done with the cursor,
     when I get a new text (via the model or the #contents/#list)
     Allowed arguments are:
        #keep / nil     -> stay where it was
        #endOfText      -> position cursor to the end
        #beginOfText    -> position cursor to the beginning
        #endOfLine      -> position cursor to the current lines end
        #beginOfLine    -> position cursor to the current lines start
     The default is #beginOfText.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    cursorMovementWhenUpdating := aSymbolOrNil

    "Modified: 16.12.1995 / 16:27:55 / cg"
!

disableIfInvisible:aBoolean
    disableIfInvisible := aBoolean
!

dontReplaceSelectionOnInput
    "remember that the current selection was created by a paste operation
     (as opposed to an explicit selection by the user).
     This selection will not be replaced by followup user input,
     so multiple pastes will be possible."

    self hasSelection ifTrue:[ 
        typeOfSelection := #paste
    ].

    "Modified: / 02-05-2015 / 21:17:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editModeHolder
    ^ editMode.
!

editModeInsert
    editMode value:EditMode insertMode
!

editModeInsertAndSelect
    editMode value:EditMode insertAndSelectMode
!

editModeOverwrite
    editMode value:EditMode overwriteMode
!

exceptionBlock:aBlock
    "define the action to be triggered when user tries to modify
     readonly text"

    exceptionBlock := aBlock
!

fixedSize
    "make the texts size fixed (no lines may be added).
     OBSOLETE: use readOnly"

    <resource:#obsolete>

    |menu|

    self obsoleteMethodWarning:'use #readOnly:'.
    readOnly == true ifFalse:[
        readOnly := true.
        (menu := self middleButtonMenu) notNil ifTrue:[
            menu disableAll:#(cut paste replace indent)
        ]
    ]

    "Modified: 14.2.1997 / 17:35:24 / cg"
!

generateTextAfterEndHook:aBlock
    "some applications may want to dynamically generate lines below the bottom line,
     when the cursor is moved there.
     For example, disassembly views or memory dumps (hex-dumps),
     which want to automatically generate additional lines lazily,
     but which cannot afford to generate the whole text in advance
     (eg: who wants to disassemble gigabytes?).
     If set, this hook is called whenever the cursor is about to be moved below the
     last line, getting the new lineNr (i.e > contents size) as argument.
     It may generate more text (by setting my contents) and return a new cursor line
     number, into which the cursor should be moved
     (eg. if 10 additional lines are generated, it may want to return oldSize+1,
     to make the cursor end in the last line which was inserted)"

    self setAttribute:#generateTextAfterEndHook to:aBlock
!

generateTextBeforeStartHook:aBlock
    "some applications may want to dynamically generate lines above the top
     line, when the cursor is moved there.
     For example, disassembly views or memory dumps (hex-dumps),
     which want to automatically generate additional lines lazily,
     but which cannot afford to generate the whole text in advance
     (eg: who wants to disassemble gigabytes?).
     If set, this hook is called whenever the cursor is about to be moved above the
     top, getting the new lineNr (i.e < 1) as argument.
     It may generate more text (by setting my contents) and return a new cursor line
     number, into which the cursor should be moved
     (eg. if 10 additional lines are generated, it may want to return 10, to make the
     cursor end in the last line which was inserted)"

    self setAttribute:#generateTextBeforeStartHook to:aBlock
!

insertMode:aBoolean
    editMode value:(aBoolean ifTrue:[EditMode insertMode] ifFalse:[EditMode overwriteMode])

    "Created: 6.3.1996 / 12:24:05 / cg"
!

insertModeHolder
    ^ BlockValue
        with:[:m | m isInsertMode]
        argument:(editMode).

    "Modified: / 08-03-2007 / 22:58:37 / cg"
!

isInInsertMode
    ^ editMode value isInsertMode
!

isNotReadOnly
    "return true, if the text is not readonly."

    ^ self isReadOnly not
!

isReadOnly
    "return true, if the text is readonly."

    ^ readOnly value

    "Modified: 14.2.1997 / 17:35:56 / cg"
!

modeLabelHolder
    "a valueHolder, which contains 'L' (learnMode), I (insertMode) or empty"

    ^ BlockValue
        with:[:e :l |
            self isReadOnly ifTrue:[
                ''
            ] ifFalse:[
                l ifTrue:[ 'L' allBold withColor:#red]
                  ifFalse:[ e infoPrintString]]]
        argument:(self editModeHolder)
        argument:(self learnModeHolder).

    "Modified: / 08-03-2007 / 22:58:59 / cg"
!

modified
    "return true if text was modified"

    ^ modifiedChannel value
!

modified:aBoolean
    "set/clear the modified flag"

    modifiedChannel value:aBoolean

    "Modified: 14.2.1997 / 16:44:05 / cg"
!

modifiedChannel
    "return the valueHolder holding true if text was modified"

    ^ modifiedChannel
!

modifiedChannel:aValueHolder
    "set the valueHolder holding true if text was modified"

    |prev|

    prev := modifiedChannel.
    modifiedChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev

    "Created: / 30.1.1998 / 14:51:32 / cg"
!

readOnly
    "make the text readonly.
     Obsolete because it is obfuscating (looks like a getter)
     - use #readOnly:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #readOnly:'.
    self readOnly:true.

    "Modified: / 14-02-1997 / 17:35:56 / cg"
    "Modified (comment): / 02-08-2013 / 16:46:57 / cg"
!

readOnly:aBoolean
    "make the text readonly (aBoolean == true) or writable (aBoolean == false).
     The argument may also be a valueHolder."

    readOnly := aBoolean

    "Created: 14.2.1997 / 17:35:39 / cg"
!

reallyModifiedChannel
    "return the valueHolder holding true if text was really modified.
     For compatibility with views which use the modified flag for syntax highlighting."

    ^ self modifiedChannel
!

st80EditMode
    "If on, the cursor wraps at the line end (like in vi or st80);
     if off, we have the Rand-editor behavior (random access)"

    ^ st80Mode ? (UserPreferences current st80EditMode)
!

st80EditMode:aBooleanOrNil
    "set/clear the st80Mode flag.
     If on, the cursor wraps at the line end (like in vi or st80);
     if off, we have the Rand-editor behavior (random access)
     if nil, the setting follows the current userPref setting."

    st80Mode := aBooleanOrNil

    "Created: / 09-11-2010 / 13:55:50 / cg"
!

st80Mode:aBooleanOrNil
    <resource: #obsolete>
    self obsoleteMethodWarning.
    self st80EditMode:aBooleanOrNil

    "Created: / 09-11-2010 / 13:55:50 / cg"
!

tabMeansNextField:aBoolean
    "set/clear tabbing to the next field.
     If true, Tab is ignored and shifts the keyboard focus.
     If false, tabs can be entered into the text.
     The default is true for editTextView, false for single-line
     input fields."

    tabMeansNextField := aBoolean
!

tabRequiresControl
    "returns true, if a focus tabbing requires a control-key to be pressed.
     The default is true for editTextView, false for other widgets,
     to allow for easier text entry"

    ^ tabRequiresControl
!

tabRequiresControl:aBoolean
    "controls if a focus tabbing requires a control-key to be pressed.
     The default is true for editTextView, false for other widgets,
     to allow for easier text entry"

    tabRequiresControl := aBoolean
!

trimBlankLines
    "If on, the blank lines are trimmed to zero size;
     if nil, the setting follows the current userPref setting."

    ^ trimBlankLines ? (UserPreferences current trimBlankLines)
!

trimBlankLines:aBooleanOrNil
    "If on, the blank lines are trimmed to zero size;
     if nil, the setting follows the current userPref setting."

    trimBlankLines := aBooleanOrNil.
! !

!EditTextView methodsFor:'accessing-contents'!

at:lineNr basicPut:aLine
    "change a line without change notification.
     this is not undoably, unless you care for yourself"

    (self at:lineNr) = aLine ifFalse:[
        super at:lineNr put:aLine.
    ].
!

at:lineNr put:aLine
    "replace a line by something new.
     this is not undoably, unless you care for yourself"

    |oldLine|

    oldLine := (self at:lineNr) ? ''.
    (oldLine sameStringAndEmphasisAs: (aLine? '')) ifFalse:[
        super at:lineNr put:aLine.
        self textChanged
    ].
!

characterAfterCursor
    "return the character one after the cursor - space if beyond line."

    ^ self characterAtLine:cursorLine col:cursorCol+1
!

characterBeforeCursor
    "return the character to the left of cursor - space if beyond line, nil if at the beginning."

    cursorCol <= 1 ifTrue:[^ nil].

    ^ self characterAtLine:cursorLine col:cursorCol-1

    "Created: / 17.6.1998 / 15:16:41 / cg"
!

characterUnderCursor
    "return the character under the cursor - space if beyond line.
     For non-block cursors, this is the character immediately to the right
     of the insertion-bar or caret. 
     For block cursors, this is the highlighted cursor-character"

    ^ self characterAtLine:cursorLine col:cursorCol
!

contents
    "return the contents as a String or Text (i.e. with emphasis)"

    |numLines|
    
    list isNil ifTrue:[^ ''].    
    self trimBlankLines ifTrue:[
        self removeTrailingBlankLines.
    ] ifFalse:[
        "/ the last line does not count, if the cursor is at
        "/ the begining
        cursorCol == 1 ifTrue:[
            numLines := list size.    
            cursorLine == numLines ifTrue:[
                numLines > 1 ifTrue:[
                    (self listAt:numLines) isEmptyOrNil ifTrue:[
                        list grow:numLines-1.
                    ].    
                ].    
            ].    
        ].    
    ].    
    ^ super contents.

    "Modified: / 04-07-2006 / 19:22:32 / fm"
!

contents:aStringOrStringCollectionOrNil
    "replace the whole contents by something new.
     this is not undoably, unless you care for yourself.
     See replaceContentsWith:newContents for an undoable version of this"

    self contents:aStringOrStringCollectionOrNil keepUndoHistory:false.
!

contents:something keepUndoHistory:keepUndoHistory
    "set the contents and optionally clear the undo history.
     The contents-change is not undoable."

    super contents:something.
    keepUndoHistory ifFalse:[
        undoSupport resetHistories.
    ].
!

contentsAsString
    "return the contents as a String (i.e. without emphasis)"

    list isNil ifTrue:[^ ''].
    self removeTrailingBlankLines.
    ^ (list collect:[:each | each isNil ifTrue:['']
                                        ifFalse:[each string]
                    ]) asStringWithCRs
!

contentsAsStringWithTabs
    "return the contents as a String (i.e. without emphasis)
     and with leading spaces replaced by tab characters
     (i.e. as would be written to a file)"

    list isNil ifTrue:[^ ''].
    self removeTrailingBlankLines.
    ^ (list collect:[:each | 
        each isNil 
            ifTrue:['']
            ifFalse:[each string withTabs]
       ]) asStringWithCRs
!

cursorCol
    "return the cursors col (1..).
     This is the absolute col; NOT the visible col"

    ^ cursorCol
!

cursorColHolder
    "return a valueHolder for the cursors column (1..)."

    ^ cursorColHolder
!

cursorLine
    "return the cursors line (1..).
     This is the absolute line; NOT the visible line"

    ^ cursorLine
!

cursorLineAndColumnLabelHolder
    "return a valueHolder for the cursors line and column as an info string
     of the form 'line : col'. 
     This can be used directly as a model for a GUI label showing the cursor position (eg in the lower right)"

    ^ BlockValue
        with:[:l :c | '%1 : %2' bindWith:l with:c]
        argument:self cursorLineHolder
        argument:self cursorColHolder
!

cursorLineHolder
    "return a valueHolder for the cursors line (1..).
     This is the absolute line; NOT the visible line"

    ^ cursorLineHolder
!

lineStringBeforeCursor
    "return the line's string before the cursor.
     Pad with spaces up to the cursor position if beyond the end of line"

    |line|

    line := ((self at:cursorLine) ? '') string.
    line size < (cursorCol-1) ifTrue:[
        ^ line paddedTo:(cursorCol-1)
    ].
    ^ line copyTo:(cursorCol-1)
!

list:something
    "replace the whole contents by something new.
     this is not undoably, unless you care for yourself.
     position cursor home when setting contents"

    |prevCursorLine prevCursorCol|

    prevCursorLine := cursorLine.
    prevCursorCol := cursorCol.

    super list:something.

    (cursorMovementWhenUpdating == #endOfText
    or:[cursorMovementWhenUpdating == #end]) ifTrue:[
        ^ self cursorToEndOfText
    ].

    (cursorMovementWhenUpdating == #endOfLine) ifTrue:[
        ^ self cursorLine:prevCursorLine col:(self listAt:cursorLine) size + 1.
    ].

    (cursorMovementWhenUpdating == #beginOfText
    or:[cursorMovementWhenUpdating == #begin]) ifTrue:[
        ^ self cursorHome
    ].
    (cursorMovementWhenUpdating == #beginOfLine) ifTrue:[
        ^ self cursorLine:prevCursorLine col:1.
    ].

    "/ default: stay where it was
    "/ self cursorLine:prevCursorLine col:prevCursorCol.
!

setContents:something
    "replace the whole contents by something new 
     AND clear the remembered undo actions"

    |selType|

    undoSupport resetHistories.

    selType := typeOfSelection.
    super setContents:something.
    typeOfSelection := selType.

    "Created: / 31.3.1998 / 23:35:06 / cg"
! !

!EditTextView methodsFor:'accessing-dimensions'!

xOfCursor
    |point|

    cursorVisibleLine isNil ifTrue:[
        "/ take the end of the selection, if any
        (selectionStartLine notNil 
            and:[ self listLineIsVisible:selectionEndLine ])
        ifTrue:[
            ^ self xOfCol:selectionEndCol inVisibleLine:selectionEndLine.
        ].

"/        point := device 
"/                    translatePoint:(device pointerPosition)
"/                    fromView:nil
"/                    toView:self.
"/        ((self bounds) containsPoint:point) ifTrue:[
"/            ^ point x
"/        ].
"/        ^ 0
        ^ nil
    ].
    ^self xOfCol:cursorCol inVisibleLine:cursorVisibleLine.

    "Created: / 27-05-2005 / 07:43:41 / janfrog"
! !

!EditTextView methodsFor:'accessing-look'!

cursorForegroundColor:color1 backgroundColor:color2
    "set both cursor foreground and cursor background colors"

    |wasOn|

    wasOn := self hideCursor.
    cursorFgColor := color1 onDevice:device.
    cursorBgColor := color2 onDevice:device.
    wasOn ifTrue:[self showCursor]
!

cursorType
    "return the style of the text cursor.
     Currently, supported are: #none
                               #block, #frame, #ibeam, #caret, #solidCaret
                               #bigCaret and #bigSolidCaret"

    ^ cursorType

    "Modified: / 5.5.1999 / 14:52:33 / cg"
!

cursorType:aCursorTypeSymbol
    "set the style of the text cursor.
     Currently, supported are: #none
                               #block, #frame, #ibeam, #caret, #solidCaret
                               #bigCaret and #bigSolidCaret"

    cursorType := aCursorTypeSymbol.

    "Created: 21.9.1997 / 13:42:23 / cg"
    "Modified: 21.9.1997 / 13:43:35 / cg"
!

cursorTypeNoFocus
    "return the style of the text cursor when the view has no focus.
     If left unspecified, this is the same as the regular cursorType."

    ^ cursorTypeNoFocus

    "Created: / 5.5.1999 / 14:52:46 / cg"
!

cursorTypeNoFocus:aCursorTypeSymbol
    "set the style of the text cursor when the view has no focus.
     If left unspecified, this is the same as the regular cursorType."

    cursorTypeNoFocus := aCursorTypeSymbol
! !

!EditTextView methodsFor:'accessing-replace'!

lastReplacementInfo
    ^ lastReplacementInfo
!

lastStringToReplace: aString
!

previousReplacements
    "accessor for the code completion"

    ^ lastReplacementInfo previousReplacements
! !

!EditTextView methodsFor:'change & update'!

accept
    "accept the current contents by executing the accept-action and/or
     changeMessage.
     Historically, ST/X used a callBack (acceptAction);
     and ST80/VW used the model, into which the text is stored.
     We support both; if there is a mode, it gets a value: message,
     If there is an acceptAction, it is called."

    acceptEnabled == false ifTrue:[
        self beep.
        ^ self
    ].
    (disableIfInvisible == true and:[self reallyRealized not]) ifTrue:[
        ^ self
    ].

    lockUpdates := true.

    "/
    "/ ST-80 way of doing it
    "/
    model notNil ifTrue:[
        self sendChangeMessage:changeMsg with:self argForChangeMessage.
        acceptChannel notNil ifTrue:[
            acceptChannel value:true withoutNotifying:self.
        ].    
    ].

    "/
    "/ ST/X way of doing things
    "/ as a historic leftover,
    "/ the block is called with a stringCollection
    "/ - not with the actual string
    "/
    acceptAction notNil ifTrue:[
        acceptAction value:self list
    ].

    lockUpdates := false.

    "Modified: / 30.1.1998 / 14:19:00 / cg"
!

argForChangeMessage
    "return the argument to be passed with the change notification.
     Defined as separate method for easier subclassability."

    ^ self contents

    "Modified: 29.4.1996 / 12:42:14 / cg"
!

getListFromModel
    "get my contents from the model.
     Redefined to ignore updates resulting from my own changes
     (i.e. if lockUpdates is true)."

    "
     ignore updates from my own change
    "
    lockUpdates ifTrue:[
        lockUpdates := false.
        ^ self
    ].
    super getListFromModel.
    undoSupport resetHistories.

    "/ validate the cursorLine
    (cursorLine notNil
     and:[ cursorLine > list size ]) ifTrue:[
        self cursorLine:list size + 1 col:1
    ].
!

update:something with:aParameter from:changedObject
    changedObject == acceptChannel ifTrue:[
        acceptChannel value == true ifTrue:[
            self accept.
        ].
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Created: / 30.1.1998 / 14:15:56 / cg"
    "Modified: / 1.2.1998 / 13:15:55 / cg"
! !

!EditTextView methodsFor:'commenting'!

commentFrom:line1 to:line2 commentStrings:commentStrings
    "helper function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col
     (if no eol comment is available, a bracketing comment is used)."

    |eolComment opening closing|

    eolComment := commentStrings at:1.
    eolComment isNil ifTrue:[
        opening := (commentStrings at:2) at:1.
        closing := (commentStrings at:2) at:2.
        (opening isNil or:[closing isNil]) ifTrue:[^ self].
    ].

    line1 to:line2 do:[:lineNr |
        |l|

        l := self listAt:lineNr.
        l isNil ifTrue:[l := ''].
        eolComment notNil ifTrue:[
            l := eolComment , l
        ] ifFalse:[
            l := opening , l , closing
        ].
        self replaceLine:lineNr with:l.
        widthOfWidestLine notNil ifTrue:[
            widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:l).
        ].
    ].
    self textChanged.

    "Created: / 09-11-1997 / 01:05:35 / cg"
    "Modified: / 09-10-2006 / 10:46:44 / cg"
!

commentSelection:commentStrings
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col."

    |e commentPair opening closing|

    (self checkModificationsAllowed) ifFalse:[ ^ self].
    commentStrings isNil ifTrue:[ self beep. ^ self].

    self
        undoableDo:[ 
            selectionStartLine isNil ifTrue:[
                self commentFrom:cursorLine to:cursorLine commentStrings:commentStrings
            ] ifFalse:[
                (selectionStartCol == 1 and:[selectionEndCol == 0]) ifTrue:[
                    self commentFrom:selectionStartLine to:selectionEndLine-1 commentStrings:commentStrings
                ] ifFalse:[
                    commentPair := commentStrings at:2 ifAbsent:nil.
                    commentPair isNil ifTrue:[
                        self beep.
                    ] ifFalse:[
                        opening := commentPair at:1.
                        closing := commentPair at:2.
                        (opening isNil or:[closing isNil]) ifTrue:[^ self].

                        e := selectionEndCol.

                        self insertString:closing atLine:selectionEndLine col:e+1.
                        self insertString:opening atLine:selectionStartLine col:selectionStartCol.

                        selectionStartLine == selectionEndLine ifTrue:[e := e + opening size].
                        self selectFromLine:selectionStartLine col:selectionStartCol
                                     toLine:selectionEndLine col:e+closing size.
                    ]
                ]
            ].    
        ]    
        info:'Comment'.

    "Created: / 9.11.1997 / 01:05:40 / cg"
    "Modified: / 5.4.1998 / 16:52:23 / cg"
!

uncommentFrom:line1 to:line2 commentStrings:commentStrings
    "helper function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col.
     (if no eol comment is available, a bracketing comment is removed)."

    |eolComment opening closing rest|

    eolComment := commentStrings at:1.
    eolComment isNil ifTrue:[
        opening := (commentStrings at:2) at:1.
        closing := (commentStrings at:2) at:2.
        (opening isNil or:[closing isNil]) ifTrue:[^ self].
    ] ifFalse:[
        rest := eolComment size + 1.
    ].

    line1 to:line2 do:[:lineNr |
        |l|

        l := self listAt:lineNr.
        l notNil ifTrue:[
            eolComment notNil ifTrue:[
                (l startsWith:eolComment) ifTrue:[
                    l := l copyFrom:rest
                ] ifFalse:[
                    (l withoutLeadingSeparators startsWith:eolComment) ifTrue:[
                        "/ only for single lines?
                        true "line1 = line2" ifTrue:[
                            |numSpaces|

                            numSpaces := l indexOfNonSeparator - 1.
                            l := l copyFrom:numSpaces+1+rest.
                            l := (String new:numSpaces),l
                        ].    
                    ].    
                ]
            ] ifFalse:[
                ((l startsWith:opening) and:[l endsWith:closing]) ifTrue:[
                    l := l copyFrom:opening size + 1.
                    l := l copyButLast:closing size.
                ].    
            ].
            self replaceLine:lineNr with:l.
        ]
    ].
    
    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.
!

uncommentSelection:commentStrings
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col."

    |e commentPair opening closing sz1 sz2 l1 l2 c1 c2|

    (self checkModificationsAllowed) ifFalse:[ ^ self].
    commentStrings isNil ifTrue:[ self beep. ^ self].

    self
        undoableDo:[
            selectionStartLine isNil ifTrue:[
                self uncommentFrom:cursorLine to:cursorLine commentStrings:commentStrings
            ] ifFalse:[
                (selectionStartCol == 1 and:[selectionEndCol == 0]) ifTrue:[
                    self uncommentFrom:selectionStartLine to:selectionEndLine-1 commentStrings:commentStrings
                ] ifFalse:[
                    commentPair := commentStrings at:2.
                    opening := commentPair at:1.
                    closing := commentPair at:2.
                    (opening isNil or:[closing isNil]) ifTrue:[^ self].

                    sz1 := opening size.
                    sz2 := closing size.

                    ((self
                        stringAtLine:selectionStartLine
                        from:selectionStartCol
                        to:selectionStartCol+sz1 - 1) = opening
                    and:[(self
                        stringAtLine:selectionEndLine
                        from:selectionEndCol - sz2 + 1
                        to:selectionEndCol) = closing ]) ifTrue:[

                        l2 := selectionEndLine.   c2 := selectionEndCol.
                        l1 := selectionStartLine. c1 := selectionStartCol.
                        self deleteCharsAtLine:l2 fromCol:c2-sz2+1 toCol:c2.
                        self deleteCharsAtLine:l1 fromCol:c1 toCol:c1+sz1-1.

                        e := c2 - sz2.
                        l1 == l2 ifTrue:[e := e - sz1].
                        self selectFromLine:l1 col:c1 toLine:l2 col:e.
                    ]
                ]
            ].
        ]   
        info:'Uncomment'.

    "Modified: / 7.1.1997 / 20:13:32 / cg"
    "Created: / 9.11.1997 / 01:05:46 / cg"
! !

!EditTextView methodsFor:'cursor handling'!

basicCursorReturn
    "move cursor to start of next line; scroll if at end of visible text"

    |wasOn|

    self checkForExistingLine:(cursorLine + 1).
    cursorVisibleLine notNil ifTrue:[
        nFullLinesShown notNil ifTrue:[
            (cursorVisibleLine >= nFullLinesShown) ifTrue:[self scrollDown]
        ]
    ].

    wasOn := self hideCursor.
    self setValidatedCursorLine:(cursorLine + 1) col:1.
    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: 22.5.1996 / 18:27:34 / cg"
!

characterPositionOfCursor
    ^ self characterPositionOfLine:cursorLine col:cursorCol
!

cursorBacktab
    "move cursor to prev tabstop"

    self cursorCol:(self prevTabBefore:cursorCol).
!

cursorCol:newCol
    "move cursor to some column in the current line"

    |wasOn|

    (cursorCol == newCol) ifTrue:[^ self].

    wasOn := self hideCursor.
    self setValidatedCursorCol:newCol.
    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: 22.5.1996 / 14:25:53 / cg"
!

cursorDown
    "move cursor down; scroll if at end of visible text;
     beep if at end of physical text."

    |wasOn|

    self cursorDown:1.

    "/ cursor beyond text ?
    cursorLine > list size ifTrue:[
        wasOn := self hideCursor.
        self setValidatedCursorLine:(list size + 1) col:cursorCol.
        self makeCursorVisibleAndShowCursor:wasOn.
        self beep.
    ].

    "Modified: / 10.6.1998 / 17:00:23 / cg"
!

cursorDown:n
    "move cursor down by n lines; scroll if at end of visible text"

    |inLastLine wasOn nv nL cursorColBefore|

    (nL := cursorLine) isNil ifTrue:[
        nL := firstLineShown
    ].

    inLastLine := (nL == list size).

    inLastLine ifTrue:[
        |generateTextAfterEndHook|

        cursorColBefore := cursorCol.
        (generateTextAfterEndHook := self getAttribute:#generateTextAfterEndHook) notNil ifTrue:[
            wasOn := self hideCursor.
            nL := generateTextAfterEndHook value:(nL + n).
            self setValidatedCursorLine:nL col:cursorColBefore.
            self makeCursorVisibleAndShowCursor:wasOn.
            ^ self.
        ].
    ].

    self st80EditMode ifTrue:[
        nL == list size ifTrue:[
            wasOn := self hideCursor.
            self setValidatedCursorLine:nL col:(self listAt:nL) size + 1.
            self makeCursorVisibleAndShowCursor:wasOn.
            self beep.
            ^ self.
        ]
    ].

    cursorVisibleLine notNil ifTrue:[
        wasOn := self hideCursor.
        nv := cursorVisibleLine + n - 1.
        (nv >= nFullLinesShown) ifTrue:[
            self scrollDown:(nv - nFullLinesShown + 1)
        ].
        self setValidatedCursorLine:(cursorLine + n) col:(cursorColBefore ? cursorCol).
        self makeCursorVisibleAndShowCursor:wasOn.
    ] ifFalse:[
        self setValidatedCursorLine:(nL + n) col:(cursorColBefore ? cursorCol).
        self makeCursorVisible.
    ].

    "Modified: / 10.6.1998 / 16:59:17 / cg"
!

cursorHome
    "scroll to top AND move cursor to first line of text."

    self cursorLine:1 col:1

"/    |wasOn|
"/
"/    wasOn := self hideCursor.
"/    self scrollToTop.
"/    cursorLine := cursorVisibleLine := 1.
"/    cursorCol := self validateCursorCol:1 inLine:cursorLine.
"/    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: 22.5.1996 / 18:26:42 / cg"
!

cursorLeft
    "move cursor to left"

    (cursorCol ~~ 1) ifTrue:[
        self cursorCol:(cursorCol - 1)
    ] ifFalse:[
        cursorLine ~~ 1 ifTrue:[
            self st80EditMode ifTrue:[
                self cursorUp.
                self cursorToEndOfLine.
           ]
        ]
    ]

    "Modified: / 23.1.1998 / 12:37:13 / cg"
!

cursorLeft:n
    "move cursor to left"

    n timesRepeat:[
        self cursorLeft
    ].
!

cursorLine:line col:col
    "this positions onto physical - not visible - line"

    self cursorLine:line col:col makeVisible:true
!

cursorLine:line col:col makeVisible:makeVisibleBoolean
    "this positions onto physical - not visible - line"

    |wasOn newCol|

    ((line == cursorLine) and:[col == cursorCol]) ifTrue:[^ self].

    wasOn := self hideCursor.
    self setValidatedCursorLine:line.

    (col < 1) ifTrue:[
        newCol := 1
    ] ifFalse:[
        newCol := col.
    ].
    self st80EditMode ifTrue:[
        (cursorLine == list size
        and:[cursorLine ~~ line]) ifTrue:[
            newCol := (self listAt:(list size)) size + 1.
        ]
    ].
    self setValidatedCursorCol:newCol.
    makeVisibleBoolean ifTrue:[
        self makeCursorVisibleAndShowCursor:wasOn.
    ] ifFalse:[
        wasOn ifTrue:[self showCursor]
    ].

    "Modified: / 20.6.1998 / 18:19:06 / cg"
!

cursorMovementAllowed
    "return true, if the user may move the cursor around
     (via button-click, or cursor-key with selection).
     By default, true is returned, but this may be redefined
     in special subclasses (such as a terminal view), where
     this is not wanted"

    ^ true

    "Created: / 18.6.1998 / 14:11:16 / cg"
!

cursorReturn
    "move cursor to start of next line; scroll if at end of visible text"

    self basicCursorReturn
!

cursorReturn:withPossibleAutoIndent
    "move cursor to start of next line; scroll if at end of visible text"

    self basicCursorReturn
!

cursorRight
    "move cursor to right"

    |l|

    self st80EditMode ifTrue:[
        l := (self listAt:cursorLine).
        cursorCol >= (l size + 1) ifTrue:[
            cursorLine <= list size ifTrue:[
                self cursorReturn:false. "/ no autoindent
            ].
            ^ self
        ]
    ].
    self cursorCol:(cursorCol + 1)

    "Modified: / 20.6.1998 / 18:19:07 / cg"
!

cursorRight:n
    "move cursor to right"

    n timesRepeat:[
        self cursorRight
    ].
!

cursorShown:aBoolean
    "change cursor visibility
     return true if cursor was visible before."

    |oldState|

    aBoolean == cursorShown ifTrue:[
        ^ cursorShown
    ].
    oldState := cursorShown.

    aBoolean ifTrue:[
        self drawCursor.
    ] ifFalse:[
        (cursorShown and:[shown]) ifTrue: [
            self undrawCursor.
        ].
    ].
    cursorShown := aBoolean.

    ^ oldState

    "Modified: / 30.3.1999 / 15:32:43 / stefan"
    "Created: / 30.3.1999 / 15:59:30 / stefan"
!

cursorTab
    "move cursor to next tabstop"

    self cursorCol:(self nextTabAfter:cursorCol).
!

cursorToBeginOfLine
    "move cursor to the start of the current line"

    |textStart l|

    l := self listAt:cursorLine.
    textStart := l isNil ifTrue:[1] ifFalse:[l indexOfNonSeparator].
    cursorCol > textStart ifTrue:[
        self cursorCol:textStart
    ] ifFalse:[
        self cursorCol:1
    ]

    "Created: / 8.8.2004 / 18:51:21 / janfrog"
!

cursorToBottom
    "move cursor to the last line of text (col 1)"

    |wasOn newTop|

    wasOn := self hideCursor.

    newTop := list size - nFullLinesShown.
    (newTop < 1) ifTrue:[
        newTop := 1
    ].
    self scrollToLine:newTop.

    self setValidatedCursorLine:(list size) col:1.

    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: 22.5.1996 / 18:27:45 / cg"
!

cursorToCharacterPosition:pos
    "compute line/col from character position (1..)
     and move the cursor onto that char"

    |line col|

    line := self lineOfCharacterPosition:pos.
    col := pos - (self characterPositionOfLine:line col:1) + 1.
    self cursorLine:line col:col

    "Created: / 15.1.1998 / 21:55:33 / cg"
!

cursorToEnd
    "move cursor down below last line of text"

    |wasOn newTop lineNr line|

    lineNr := list size.

    cursorLine >= lineNr ifTrue:[
        line := self listAt:cursorLine.
        (line isEmptyOrNil) ifTrue:[
            ^ self
        ]
    ].

    wasOn := self hideCursor.

    lineNr := lineNr + 1.
    newTop :=  lineNr - nFullLinesShown.
    (newTop < 1) ifTrue:[
        newTop := 1
    ].
    self scrollToLine:newTop.

    self setValidatedCursorLine:lineNr col:1.

    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: 22.5.1996 / 18:27:53 / cg"
!

cursorToEndOfLine
    "move cursor to end of current line"

    |line|

    line := (self listAt:cursorLine).
    self cursorCol:(line size + 1)

    "Modified: 13.8.1997 / 15:34:02 / cg"
!

cursorToEndOfText
    "move cursor to the end of the text (behind the last character in last line)"

    |wasOn newTop lastLineLength pos|

    wasOn := self hideCursor.

    newTop := list size - nFullLinesShown.
    (newTop < 1) ifTrue:[
        newTop := 1
    ].
    self scrollToLine:newTop.

    self setValidatedCursorLine:list size.
    lastLineLength := (self listAt:cursorLine) size.
    pos := (lastLineLength==0) ifTrue:[0] ifFalse:[lastLineLength+1].
    self setCursorCol:(self validateCursorCol:pos inLine:cursorLine).

    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: / 15-07-2011 / 20:14:43 / cg"
!

cursorToEndOfWord
    "move the cursor to the end of the word"

    (cursorLine > list size) ifTrue:[^ self].

    self wordAtLine:cursorLine col:cursorCol do:[
        :beginLine :beginCol :endLine :endCol :style |

        self cursorLine:endLine col:endCol+1
    ]

    "Created: / 28-06-2006 / 19:16:30 / cg"
!

cursorToFirstVisibleLine
    "place cursor into the first visible line; do not scroll."

    self cursorLine:(self visibleLineToAbsoluteLine:1) col:1
!

cursorToLastVisibleLine
    "place cursor into the first visible line; do not scroll."

    self cursorLine:(self visibleLineToAbsoluteLine:nFullLinesShown) col:1
!

cursorToNextWord
    "move the cursor to the beginning of the next word"

    |col line searching|

    (cursorLine > list size) ifTrue:[^ self].

    self 
        wordAtLine:cursorLine col:cursorCol 
        do:[
            :beginLine :beginCol :endLine :endCol :style |

            line := endLine.
            col := endCol + 1.
            searching := true.
            [searching and:[(self characterAtLine:line col:col) isSeparator]] whileTrue:[
                self wordAtLine:line col:col do:[
                    :beginLine :beginCol :endLine :endCol :style |

                    (line > list size) ifTrue:[
                        "break out"
                        searching := false
                    ] ifFalse:[
                        line := endLine.
                        col := endCol + 1.
                    ]
                ]
            ].
            self cursorLine:line col:col
    ]
!

cursorToPreviousWord
    "move the cursor to the beginning of this or the previous word"

    |col line searching l|

    (cursorLine > list size) ifTrue:[^ self].      "/ this is rubbish

    self wordAtLine:cursorLine col:cursorCol do:[
        :beginLine :beginCol :endLine :endCol :style |

        line := beginLine.
        col := beginCol.
        style == #wordLeft ifTrue:[
            col := col + 1
        ].

        (cursorLine == line
        and:[cursorCol == col]) ifTrue:[
            searching := true.

            col > 1 ifTrue:[
                col := col - 1.
            ].

            [searching] whileTrue:[
                (col == 1) ifTrue:[
                    line == 1 ifTrue:[
                        searching := false
                    ] ifFalse:[
                        line := line - 1.
                        l := list at:line.
                        col := l size + 1.
                    ]
                ] ifFalse:[
                    (self characterAtLine:line col:col) isSeparator ifFalse:[
                        self wordAtLine:line col:col do:[
                            :beginLine :beginCol :endLine :endCol :style |

                            line := beginLine.
                            col := beginCol.
                            style == #wordLeft ifTrue:[
                                col := col + 1
                            ].
                            searching := false.
                        ]
                    ] ifTrue:[
                        col := col - 1
                    ]
                ]
            ]
        ].
        self cursorLine:line col:col
    ]

    "Created: 8.3.1996 / 21:52:48 / cg"
    "Modified: 8.3.1996 / 22:12:45 / cg"
!

cursorToTop
    "move cursor to absolute home"

    self cursorLine:1 col:1
!

cursorUp
    "move cursor up; scroll if at start of visible text"

    self cursorUp:1
!

cursorUp:n
    "move cursor up n lines; scroll if at start of visible text"

    |wasOn nv nl cursorColBefore|

    cursorLine isNil ifTrue:[
        self setCursorLine:(firstLineShown + nFullLinesShown - 1).
    ].
    nl := cursorLine - n.
    nl < 1 ifTrue:[
        |generateTextBeforeStartHook|

        cursorColBefore := cursorCol.
        (generateTextBeforeStartHook := self getAttribute:#generateTextBeforeStartHook) notNil ifTrue:[
            nl := generateTextBeforeStartHook value:nl
        ].
        nl := nl max:1
    ].

    (nl ~~ cursorLine) ifTrue: [
        wasOn := self hideCursor.
        cursorVisibleLine notNil ifTrue:[
            nv := cursorVisibleLine - n.
            nv < 1 ifTrue:[
                self scrollUp:(nv negated + 1)
            ].
        ].
        self setValidatedCursorLine:nl col:(cursorColBefore ? cursorCol).
"/        wasOn ifTrue:[self showCursor].
        self makeCursorVisibleAndShowCursor:wasOn.
    ]

    "Modified: 22.5.1996 / 18:28:11 / cg"
!

cursorVisibleLine:visibleLineNr col:colNr
    "put cursor to visibleline/col"

    |wasOn newCol listLine|

    wasOn := self hideCursor.

    listLine := self visibleLineToAbsoluteLine:visibleLineNr.
    self setValidatedCursorLine:listLine.
    cursorVisibleLine := visibleLineNr.

    newCol := colNr.
    (newCol < 1) ifTrue:[
        newCol := 1
    ].
    self setValidatedCursorCol:newCol.

    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: / 20.6.1998 / 18:40:28 / cg"
!

cursorX:x y:y
    "put cursor to position next to x/y coordinate in view"

    |line col|

    line := self visibleLineOfY:y.
    col := self colOfX:x inVisibleLine:line.
    self cursorVisibleLine:line col:col.
!

drawCursor
    "draw the cursor if shown and cursor is visible.
     (but not, if there is a selection - to avoid confusion)"

    shown ifTrue:[
        cursorVisibleLine notNil ifTrue:[
            self hasSelection ifFalse:[
                self drawCursorCharacter
            ]
        ]
    ]
!

drawCursor:cursorType with:fgColor and:bgColor
    "draw a cursor; the argument cursorType specifies what type
     of cursor should be drawn.
     Currently, supported are: #none, 
                               #block, #frame, #ibeam, #caret, #solidCaret
                               #bigCaret and #bigSolidCaret"

    |x y w char y2 x1 x2 oldPaint oldClip|

    self hasSelection ifTrue:[
        "
         hide cursor, if there is a selection
        "
        ^ super redrawVisibleLine:cursorVisibleLine col:cursorCol.
    ].

    cursorType == #none ifTrue:[
        ^ self
    ].

    cursorType == #block ifTrue:[
        super drawVisibleLine:cursorVisibleLine col:cursorCol with:fgColor and:bgColor.
        ^ self
    ].
    x := (self xOfCol:cursorCol inVisibleLine:cursorVisibleLine) - viewOrigin x.
    y := self yOfVisibleLine:cursorVisibleLine.

    oldPaint := self paint. "/ do not clobber GC
    cursorType == #frame ifTrue:[
        super redrawVisibleLine:cursorVisibleLine col:cursorCol.

        char := self characterUnderCursor asString.
        gc paint:bgColor.
        gc displayRectangleX:x y:y width:(gc font widthOf:char) height:fontHeight-2.
    ] ifFalse:[
        self paint:bgColor.
        cursorType == #ibeam ifTrue:[
            x1 := x - 1.
            y2 := y + fontHeight - lineSpacing - 1.
            gc displayLineFromX:x1 y:y toX:x1 y:y2.
            gc displayLineFromX:x y:y toX:x y:y2.
            ^ self
        ].

        cursorType == #Ibeam ifTrue:[
            x1 := x - 1.
            y := y + 1.
            y2 := y + fontHeight - lineSpacing - 1.
            gc displayLineFromX:x1 y:y toX:x1 y:y2.
            gc displayLineFromX:x y:y toX:x y:y2.
            gc displayLineFromX:x1-2 y:y toX:x+2 y:y.
            gc displayLineFromX:x1-2 y:y2 toX:x+2 y:y2.
            ^ self
        ].

        y := y + fontHeight - 3.
        ((cursorType == #bigCaret) or:[cursorType == #bigSolidCaret]) ifTrue:[
            w := (fontWidth * 2 // 3) max:4.
            y2 := y + w + (w//2).
        ] ifFalse:[
            w := (fontWidth // 2) max:4.
            y2 := y + w.
        ].
        x1 := x - w.
        x2 := x + w.

        oldClip := self clippingBoundsOrNil.
        self clippingBounds:(margin@margin extent:(width-margin) @ (height-margin)).

        cursorType == #caret ifTrue:[
            gc lineWidth:2.
            gc displayLineFromX:x1 y:y2 toX:x y:y.
            gc displayLineFromX:x y:y toX:x2 y:y2.
        ] ifFalse:[
            "anything else: solidCaret"

            gc fillPolygon:(Array with:(x1 @ y2)
                                  with:(x @ y)
                                  with:(x2 @ y2))
        ].

        self clippingBounds:oldClip
    ].
    gc paint:oldPaint.

    "Modified: / 15.12.1999 / 22:24:17 / cg"
!

drawCursorCharacter
    "draw the cursor.
     (i.e. the cursor if no selection)
     - helper for many cursor methods"

    (hasKeyboardFocus
     and:[self enabled
     and:[self isReadOnly not]]) ifTrue:[
        self drawFocusCursor
    ] ifFalse:[
        self drawNoFocusCursor
    ]

    "Modified: / 23.3.1999 / 13:52:48 / cg"
!

drawFocusCursor
    "draw the cursor when the focus is in the view."

    self hasSelection ifTrue:[
        ^ super redrawVisibleLine:cursorVisibleLine col:(cursorCol max:1).
    ].
    cursorType == #none ifTrue:[
        ^ self undrawCursor
    ].
    self drawCursor:cursorType with:cursorFgColor and:cursorBgColor.

    "Modified: 22.9.1997 / 00:16:38 / cg"
!

drawNoFocusCursor
    "draw the cursor for the case when the view has no keyboard focus"

    |cType|

    self hasSelection ifTrue:[
        ^ super redrawVisibleLine:cursorVisibleLine col:cursorCol.
    ].

    cType := cursorTypeNoFocus ? cursorType.
    cType == #none ifTrue:[
        ^ self undrawCursor
    ].

    cType == #block ifTrue:[
        ^ self drawCursor:#frame with:cursorNoFocusFgColor and:cursorBgColor
    ].

    ^ self drawCursor:cType with:cursorNoFocusFgColor and:cursorNoFocusFgColor.

    "Modified: 22.9.1997 / 00:16:13 / cg"
!

gotoLine:aLineNumber
    "position cursor onto line, aLineNumber.
     Make certain that this line is visible"

    self makeLineVisible:aLineNumber.
    self unselect.
    self cursorLine:aLineNumber col:1
!

hideCursor
    "make cursor invisible if currently invisible"

    ^ self cursorShown:false

    "Modified: / 30.3.1999 / 16:02:28 / stefan"
!

makeCursorVisible
    "scroll text to make cursorline visible
     (i.e. to have cursorLine in visible area)"

    |line col|

    cursorLine notNil ifTrue:[
        line := cursorLine.
        col := cursorCol.
        "
         if there is a selection, its better to
         have its start being visible, instead of the end
        "
        (selectionStartLine notNil
        and:[selectionEndLine notNil]) ifTrue:[
            expandingTop ~~ false ifTrue:[
                line := selectionStartLine.
                col := selectionStartCol.
            ] ifFalse:[
                line := selectionEndLine.
                col := selectionEndCol
            ]
        ].
        self makeLineVisible:line.
        self makeColVisible:col inLine:line
    ]

    "Modified: 6.3.1996 / 13:46:46 / cg"
!

makeCursorVisibleAndShowCursor:flag
    "scroll to make cursorLine visible;
     if flag is true, draw the cursor"

    self makeCursorVisible.
    flag ifTrue:[self showCursor]
!

setCursorCol:colNr
    "strictly private: set the cursorCol"

    cursorCol := (colNr max:1).
    cursorColHolder value:cursorCol.
!

setCursorLine:lineNr
    "strictly private: set the cursorLine"

    "/ self assert:(lineNr notNil).

    cursorLine := (lineNr ? 1).
    cursorLineHolder value:cursorLine.
    self updateCursorVisibleLine.
!

setCursorLine:lineNr col:colNr
    "strictly private: set the cursorLine, col and update the visibleLine"

    self setCursorLine:lineNr.
    self setCursorCol:colNr.
!

setValidatedCursorCol:colNr
    "strictly private: set the cursorCol"

    self setCursorCol:(self validateCursorCol:colNr inLine:cursorLine).
!

setValidatedCursorLine:lineNr
    "strictly private: set the cursorLine and update the visibleLine"

    self setCursorLine:(self validateCursorLine:lineNr).
!

setValidatedCursorLine:lineNr col:colNr
    "strictly private: set the cursorLine, col and update the visibleLine"

    self setValidatedCursorLine:lineNr.
    self setValidatedCursorCol:colNr.
!

showCursor
    "make cursor visible if currently invisible"

    ^ self cursorShown:true

    "Modified: / 30.3.1999 / 16:02:34 / stefan"
!

singleQuoteSelection
    "place single quotes around the selected text"

    |line1 col1 line2 col2|

    line1 := self selectionStartLine.
    col1 := self selectionStartCol.
    line2 := self selectionEndLine.
    col2 := self selectionEndCol.
    (line1 notNil
        and:[ col1 notNil
        and:[ line2 notNil
        and:[ col2 notNil ]]])
    ifTrue:[
        self insertString:Character quote asString atLine:line2 col:col2+1.
        self insertString:Character quote asString atLine:line1 col:col1.
        self selectFromLine:line1 col:col1 toLine:line2 col:col2+2.
    ] ifFalse:[
        self beep.
    ]

    "Created: / 06-06-2016 / 11:03:36 / cg"
!

undrawCursor
    "undraw the cursor (i.e. redraw the character(s) under the cursor)"

    |prevCol line oldClip x y e1 e2 e3|

    cursorVisibleLine notNil ifTrue:[
        prevCol := cursorCol - 1.

        "/ if there is any italic stuff in the cursor line,
        "/ redraw it completely (because characters overlap).
        cursorCol > 1 ifTrue:[
            (line := self listAt:cursorLine) notNil ifTrue:[
                line hasChangeOfEmphasis ifTrue:[
                    line size >= (cursorCol-1) ifTrue:[
                        e1 := Text extractEmphasis:#italic from:(line emphasisAt:cursorCol-1).
                        line size >= (cursorCol) ifTrue:[
                            e2 := Text extractEmphasis:#italic from:(line emphasisAt:cursorCol).
                            line size >= (cursorCol+1) ifTrue:[
                                e3 := Text extractEmphasis:#italic from:(line emphasisAt:cursorCol+1)
                            ].
                        ].
                    ].
                    (e1 notNil or:[e2 notNil or:[e3 notNil]]) ifTrue:[
                        ^ super redrawVisibleLine:cursorVisibleLine
                    ]
                ]
            ]
        ].

        ((cursorType == #caret)
         or:[cursorType == #solidCaret
         or:[cursorType == #bigSolidCaret
         or:[cursorType == #bigCaret
         or:[cursorType == #Ibeam]]]]) ifTrue:[
            "caret-cursor touches 4 characters"
            ((cursorCol > 1) and:[fontIsFixedWidth]) ifTrue:[
                super redrawVisibleLine:cursorVisibleLine-1 from:prevCol to:cursorCol.
                super redrawVisibleLine:cursorVisibleLine from:prevCol to:cursorCol.
                super redrawVisibleLine:cursorVisibleLine+1 from:prevCol to:cursorCol.
            ] ifFalse:[
                "care for left margin"
                super redrawVisibleLine:cursorVisibleLine; redrawVisibleLine:cursorVisibleLine+1.
            ].
            ^ self
        ].

        cursorType == #ibeam ifTrue:[
            "ibeam-cursor touches 2 characters"
            cursorCol > 1 ifTrue:[
                super redrawVisibleLine:cursorVisibleLine from:prevCol to:cursorCol.
            ] ifFalse:[
                "care for left margin"
                super redrawVisibleLine:cursorVisibleLine.
            ].
            ^ self
        ].

        "block cursor is simple - just one character under cursor"

        "/ however, if italic characters are involved, we must care
        "/ for the chars before/after the cursor.
        "/ We redraw the part of the previous character which got
        "/ detroyed by the block cursor.
        "/ (must change the clip, to avoid destroying the prev-prev character)

        line := self visibleAt:cursorVisibleLine.
        (line notNil and:[line isText]) ifTrue:[
            cursorCol > 1 ifTrue:[
                oldClip := self clippingBoundsOrNil.
                x := (self xOfCol:cursorCol inVisibleLine:cursorVisibleLine) - viewOrigin x.
                y := self yOfVisibleLine:cursorVisibleLine.
                self clippingBounds:(x@y extent:((gc font width * 2) @ fontHeight)).
                super redrawVisibleLine:cursorVisibleLine from:cursorCol-1 to:cursorCol.
                self clippingBounds:oldClip.
                ^ self.
            ].
        ].
        super redrawVisibleLine:cursorVisibleLine col:cursorCol
    ]

    "Modified: / 15.12.1999 / 22:25:59 / cg"
!

updateCursorVisibleLine
    "strictly private: set the visibleLine from the cursorLine.
     notice: visibleLine will be set to nil if the cursor is not visible"

    cursorVisibleLine := self listLineToVisibleLine:cursorLine.
!

validateCursorCol:col inLine:line
    "check of col is a valid cursor position; return a new col-nr if not.
     Here, no limits are enforced (and col is returned),
     but it may be redefined in EditFields or views which don't like the
     cursor to be positioned behind the end of a textLine (vi/st-80 behavior)"

    |l max|

    "/ in ST80 mode,
    "/ the cursor may not be positioned beyond the
    "/ end of a line or beyond the last line of the text

    self st80EditMode ifTrue:[
        l := (self listAt:line).
        max := l size + 1.
        col > max ifTrue:[
            ^ max
        ]
    ].
    ^ col

    "Created: / 22.5.1996 / 14:25:30 / cg"
    "Modified: / 20.6.1998 / 18:19:24 / cg"
!

validateCursorLine:line
    "check of line is a valid cursor line; return a fixed line-nr if not.
     Here, no limits are enforced (and line is returned), but it may be
     redefined in views which don't like the cursor to be positioned
     behind the end of the text (vi/st-80 behavior), or want to
     skip reserved regions"

    "/
    "/ in st80Mode, the cursor may not be positioned
    "/ beyond the last line 
    "/ (but it must be posible to place it on one line below the last one 
    "/ - otherwise deleteSelection and some others fail to delete from previousToLastLine)
    "/
    self st80EditMode ifTrue:[
        ^ (line min:(list size + 1)) max:1
    ].
    ^ line

    "Created: / 22.5.1996 / 18:22:23 / cg"
    "Modified: / 20.6.1998 / 18:19:26 / cg"
!

withCursorOffDo:aBlock
    "evaluate aBlock with cursor off; turn it on afterwards."

    (shown not or:[cursorShown not]) ifTrue:[
        ^ aBlock value
    ].
    self hideCursor.
    aBlock ensure:[
        self showCursor
    ]
! !

!EditTextView methodsFor:'drag & drop'!

allowDrop:aBoolean
    "enable/disable drop support"

    aBoolean ifFalse:[
        dropTarget := nil.
    ] ifTrue:[
        dropTarget isNil ifTrue:[
            dropTarget := DropTarget 
                                receiver:self
                                argument:nil
                                dropSelector:#'drop:'
                                canDropSelector:#'canDrop:'
        ]
    ].
!

canDrop:aDropContext
    "public from d&d.
     I accept textObjects and fileObjects only."

    "/ cg: disabled to avoid unintended drop (is same as copy-past, anyway)
    aDropContext sourceWidget == self ifTrue:[^ false].
    ^ self canDropObjects:aDropContext dropObjects

    "Modified: / 13-10-2006 / 17:41:09 / cg"
!

canDropObjects:aCollectionOfDropObjects
    "public from d&d.
     I accept textObjects and fileObjects only."

    self checkModificationsAllowed ifFalse:[^ false].

    aCollectionOfDropObjects isEmpty ifTrue:[ ^ false ].
    ^ aCollectionOfDropObjects conform:[:obj| (obj isTextObject or:[obj isFileObject])]

    "Created: / 13-10-2006 / 15:56:57 / cg"
    "Modified: / 13-10-2006 / 17:41:14 / cg"
!

drop:aDropContext
    "public from d&d.
     drop objects (new API)"

    self dropObjects:(aDropContext dropObjects)

    "Modified: / 13-10-2006 / 17:41:19 / cg"
!

dropFileObject:aDropObject
    "drop objects
     For bw. compatibility, also collections of drop objects are handled (may vanish)"

    |answer text fn pasteWhat sensor dontAskAgainHolder enforcedDropMode app|

    pasteWhat := #name.

    fn := aDropObject asFilename.
    (fn exists and:[fn isRegularFile]) ifTrue:[
        enforcedDropMode := UserPreferences current enforcedDropModeForFiles.
        (enforcedDropMode notNil 
        and:[enforcedDropMode ~~ #name or:[fn fileSize <= (1024*1024)]]) ifTrue:[
            pasteWhat := enforcedDropMode.
        ] ifFalse:[
            sensor := self sensor.
            (sensor shiftDown or:[sensor ctrlDown]) ifTrue:[
                pasteWhat := #name.
            ] ifFalse:[
                (sensor metaDown) ifTrue:[
                    pasteWhat := #contents.
                ] ifFalse:[
                    dontAskAgainHolder := false asValue.
                    answer := Dialog
                        confirmWithCancel:(resources
                                            stringWithCRs:'Drop the Filename (%1)\or its Contents ?\\Hint: bypass this dialog by pressing SHIFT/CTRL or ALT during the next drop.\SHIFT/CTRL to drop the name, ALT for the contents.'
                                            with:fn name allBold)
                        labels:#( 'Cancel' 'Name' 'Contents' )
                        values:#( nil #name #contents )
                        default:#contents
                        check:(resources string:'Do not ask again; instead, always paste the contents of small files.') on:dontAskAgainHolder
                        title:(resources string:'Drop What').
                    answer isNil ifTrue:[ ^ self ].

                    dontAskAgainHolder value ifTrue:[
                        UserPreferences current enforcedDropModeForFiles:#contents
                    ].
                    pasteWhat := answer.
                ]
            ]
        ].
    ].

    pasteWhat == #name ifTrue:[
        text := fn pathName
    ] ifFalse:[
        self withWaitCursorDo:[
            text := fn contentsAsString
        ].
        (app := self application) notNil ifTrue:[
            app droppedFile:fn in:self
        ].
    ].

    self 
        undoablePaste:text 
        info:'Drop File'.

    "Created: / 13-10-2006 / 17:38:31 / cg"
    "Modified: / 28-07-2007 / 13:27:09 / cg"
!

dropObject:aDropObject
    "drop objects
     For bw. compatibility, also collections of drop objects are handled (may vanish)"

    |text|

    (aDropObject isFileObject) ifTrue:[
        self dropFileObject:aDropObject
    ] ifFalse:[
        aDropObject isTextObject ifTrue:[
            text := aDropObject theObject.
            text isStringCollection ifTrue:[
                text := text asStringWithoutFinalCR
            ].
        ] ifFalse:[
            text := aDropObject theObject asString
        ].
        self 
            undoablePaste:text 
            info:'Drop'.
    ].

    "Created: / 13-10-2006 / 17:37:05 / cg"
    "Modified: / 28-07-2007 / 13:26:53 / cg"
!

dropObjects:aCollectionOfDropObjects
    "public from d&d.
     drop objects (old API)"

    aCollectionOfDropObjects do:[:el |
        self dropObject:el
    ].

    "Created: / 13-10-2006 / 15:59:40 / cg"
    "Modified: / 13-10-2006 / 17:41:23 / cg"
! !

!EditTextView methodsFor:'editing'!

applyConverterToSelection:converter
    "apply a converter to the selected text"

    |line1 line2|

    line1 := self selectionStartLine.
    line2 := self selectionEndLine.
    line1 isNil ifTrue:[
        line1 := self perform:#cursorLine ifNotUnderstood:nil.
        line1 notNil ifTrue:[
            line2 := line1
        ]
    ].
    line1 notNil ifTrue:[
        line1 to:line2 do:[:lineNr |
            |line col1 col2 newLine|

            line := (self listAt:lineNr) copy.
            line size > 0 ifTrue:[
                lineNr == line1 ifTrue:[
                    col1 := selectionStartCol.
                ] ifFalse:[
                    col1 := 1.
                ].
                lineNr == line2 ifTrue:[
                    col2 := selectionEndCol.
                ] ifFalse:[
                    col2 := (self listAt:lineNr) size.
                ].
                newLine := converter value:line value:lineNr value:col1 value:col2.
                self withoutRedrawAt:lineNr put:newLine.
                self invalidateLine:lineNr.
            ].
        ].
    ]

    "Created: / 06-06-2016 / 10:53:17 / cg"
!

convertSelectionToLowercase
    "to-lower selected text"

    self applyConverterToSelection:[:line :lnr :col1 :col2 |
        col1 to:col2 do:[:col |
            |ch|

            ch := line at:col.
            line at:col put:ch asLowercase.
        ].
        line.        
    ].

    "Created: / 06-06-2016 / 10:50:28 / cg"
!

convertSelectionToLowercaseOrUppercaseOrUppercaseFirst
    "toLower/toUppercaseFirst/toUpper selected text"

    self applyConverterToSelection:[:line :lineNr :col1 :col2 |
        |isAllLower isLowerFirst isAllUpper isUpperFirst
         makeLowercase makeUppercase makeUppercaseFirst makeLowercaseFirst|

        isAllLower := isAllUpper := isUpperFirst := isLowerFirst := true.
        col1 to:col2 do:[:col |
            |ch|

            ch := line at:col.
            ch isUppercase ifTrue:[
                isAllLower := false.
                col == col1 ifTrue:[
                    isLowerFirst := false.
                ].
            ] ifFalse:[
                ch isLowercase ifTrue:[
                    isAllUpper := false.
                    col == col1 ifTrue:[
                        isUpperFirst := false.
                    ].
                ]
            ].
        ].

        makeLowercase := makeUppercase := makeUppercaseFirst := makeLowercaseFirst := false.
        isLowerFirst ifTrue:[
            makeUppercaseFirst := true.
        ] ifFalse:[
            "/ must remember where we come from - otherwise, we end up
            "/ in upperFirst - lowerFirst cycle.
            "/ think about a good place to store this state
            false "(isUpperFirst and:[isAllUpper not])" ifTrue:[
                makeLowercaseFirst := true.
             ] ifFalse:[
                isAllUpper ifTrue:[
                    makeLowercase := true.
                ] ifFalse:[
                    makeUppercase := true.
                ]
            ]
        ].
        makeUppercaseFirst ifTrue:[
            line at:col1 put:(line at:col1) asUppercase.
        ] ifFalse:[
            makeLowercaseFirst ifTrue:[
                line at:col1 put:(line at:col1) asLowercase.
            ] ifFalse:[
                col1 to:col2 do:[:col |
                    |ch|

                    ch := line at:col.
                    ch := makeLowercase
                            ifTrue:[ ch asLowercase ]
                            ifFalse:[
                                makeUppercase
                                    ifTrue:[ ch asUppercase ]
                                    ifFalse:[
                                        col == col1
                                            ifTrue:[ ch asUppercase ]
                                            ifFalse:[ ch asLowercase ]
                                    ]
                            ].
                    line at:col put:ch.
                ].
            ].
        ].
        line
    ]

    "Created: / 14-07-2011 / 11:40:26 / cg"
    "Modified: / 06-06-2016 / 10:57:15 / cg"
!

convertSelectionToUppercase
    "to-upper selected text"

    self applyConverterToSelection:[:line :lnr :col1 :col2 |
        col1 to:col2 do:[:col |
            |ch|

            ch := line at:col.
            line at:col put:ch asUppercase.
        ].
        line.        
    ].

    "Created: / 06-06-2016 / 11:09:04 / cg"
!

convertSelectionToUppercaseFirst
    "to-upperFirst selected text"

    self applyConverterToSelection:[:line :lnr :col1 :col2 |
        |state|

        state := #first.
        col1 to:col2 do:[:col |
            |ch|

            ch := line at:col.
            ch isSeparator ifFalse:[
                state == #first ifTrue:[
                    line at:col put:ch asUppercase.
                    state := #skipRest
                ]
            ] ifTrue:[
                state := #first
            ]
        ].
        line.        
    ].

    "Created: / 06-06-2016 / 10:50:52 / cg"
!

copyAndDeleteSelection
    "copy the selection into the pastBuffer and delete it"

    selectionStartLine notNil ifTrue:[
        self setClipboardText:(self selection).
        self deleteSelection.
    ].

    "Created: 27.1.1996 / 16:23:28 / cg"
!

deleteCharAtCursor
    "delete single character under cursor; does not merge lines"

    |wasOn|

    wasOn := self hideCursor.
    self deleteCharAtLine:cursorLine col:cursorCol.
    wasOn ifTrue:[self showCursor]
!

deleteCharAtLine:lineNr col:colNr
    "delete a single character at colNr in line lineNr"

    self st80EditMode ifTrue:[
        (self listAt:cursorLine) size + 1 = colNr ifTrue:[
            | wasOn |
            wasOn := self hideCursor.
            self
                cursorReturn;
                cursorCol:1;
                deleteCharBeforeCursor.
            wasOn ifTrue:[ self showCursor].
            ^ self.
        ].
    ].

    self deleteCharsAtLine:lineNr fromCol:colNr toCol:colNr
!

deleteCharBeforeCursor
    "delete single character to the left of cursor and move cursor to left"

    |soCol wasOn lineNrAboveCursor ln originalLine prevTab|

    list isEmptyOrNil ifTrue:[^ self]. "/ there is nothing to delete.
    
    wasOn := self hideCursor.

    "JV@2012-01-06: Do not play with autoindent iff cursor is at the very beginning of the line"
    (autoIndent 
    and:[cursorCol ~~ 1
    and:[ (tabPositions includes:cursorCol) 
    ]]) ifTrue:[
        prevTab := (self prevTabBefore:cursorCol) max:1.
        "JV@2011-12-10: The list can be shorter than cursorLine,
         trailing because empty lines are not physically in the list."
        (list size >= cursorLine) ifTrue:[
            ln := originalLine := (list at:cursorLine) ? ''.
        ] ifFalse:[        
            ln := originalLine := ''.
        ].    
        ln size < prevTab ifTrue:[
            ln := ln , (String new:prevTab withAll:Character space).
        ].
        (ln copyTo:prevTab) isBlank ifTrue:[
            (ln copyFrom:prevTab+1) isBlank ifTrue:[
                cursorCol > prevTab ifTrue:[
                    self st80EditMode ifTrue:[
                        "/ ensure that there is no conflict here: st80EditMode will
                        "/ not allow a cursor position beyond the end of line,
                        "/ so avoid that cursorLine:col: will force us to the beginning of the line
                        originalLine size < prevTab ifTrue:[
                            self checkForExistingLine:cursorLine.
                            self basicListAt:cursorLine put:ln
                        ]
                    ].
                    self cursorLine:cursorLine col:prevTab.
                    wasOn ifTrue:[ self showCursor ].
                    ^  self
                ].
            ] ifFalse:[
                "/ cg: this is ugly behavior; deleting multiple chars at the beginning
                "/ is annoying.
                "/ therefore, only do it, if there are only blanks after the cursor
"/                (ln copyFrom:prevTab+1 to:((cursorCol-1) min:ln size)) isBlank ifTrue:[
"/                    self deleteFromLine:cursorLine col:prevTab toLine:cursorLine col:cursorCol-1.
"/                    self cursorLine:cursorLine col:prevTab.
"/                    wasOn ifTrue:[ self showCursor ].
"/                    ^  self.
"/                ]
            ]
        ].
    ].

"/        (autoIndent
"/    and:[cursorCol  ~~ 1
"/    and:[cursorLine <= (list size)]])
"/     ifTrue:[
"/        soCol := (self leftIndentForLine:cursorLine) + 1.
"/
"/        (cursorCol == soCol and:[soCol > 1]) ifTrue:[
"/            ln := list at:cursorLine.
"/            (ln notNil and:[(ln indexOfNonSeparatorStartingAt:1) < soCol]) ifTrue:[
"/                soCol := 1
"/            ]
"/        ]
"/    ] ifFalse:[
        soCol := 1.
"/    ].

    (cursorCol ~~ soCol and:[cursorCol ~~ 1]) ifTrue:[
        "
         somewhere in the middle of a line
        "
        self cursorLeft.
        self deleteCharAtLine:cursorLine col:cursorCol.
    ] ifFalse:[
        "
         at begin of line - merge with previous line;
         except for the very first line.
        "
        (cursorLine == 1) ifFalse:[
            lineNrAboveCursor := self validateCursorLine:(cursorLine - 1).
            lineNrAboveCursor < cursorLine ifTrue:[
                (lineNrAboveCursor > 0 and:[lineNrAboveCursor > list size]) ifTrue:[
                    "/ we are beyond the end of the text.
                    "/ move the cursor to the previous line.
                    self cursorLine:lineNrAboveCursor col:1.
                ] ifFalse:[
                    self mergeLine:lineNrAboveCursor removeBlanks:false.
                ]
            ]
        ]
    ].
    wasOn ifTrue:[ self showCursor ]

    "Modified: / 16-01-1998 / 22:33:04 / cg"
    "Modified: / 12-01-2017 / 22:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 13-01-2017 / 22:10:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deleteCharsAtLine:lineNr fromCol:colNr
    "delete characters from colNr up to the end in line lineNr"

    |line|

    (line := self listAt:lineNr) notNil ifTrue:[
        self deleteCharsAtLine:lineNr fromCol:colNr toCol:(line size)
    ]

!

deleteCharsAtLine:lineNr fromCol:startCol toCol:endCol
    "delete characters from startCol to endCol in line lineNr"

    |deleted|

    deleted := self textFromLine:lineNr col:startCol toLine:lineNr col:endCol.
    self basicDeleteCharsAtLine:lineNr fromCol:startCol toCol:endCol.
    self addUndo:(PasteString line:lineNr col:startCol string:deleted info:'delete').
!

deleteCharsAtLine:lineNr toCol:colNr
    "delete characters from start up to colNr in line lineNr"

    self deleteCharsAtLine:lineNr fromCol:1 toCol:colNr


!

deleteCursorLine
    "delete the line where the cursor sits"

    self deleteLine:cursorLine
!

deleteFromCharacterPosition:charPos1 to:charPos2
    "delete a substring at a character position"

    |line1 col1 line2 col2|

    line1 := self lineOfCharacterPosition:charPos1.
    col1 := charPos1 - (self characterPositionOfLine:line1 col:1) + 1.
    col1 == 0 ifTrue:[
        line1 := line1 - 1.
        col1 := (self listAt:line1) size + 1.
    ].

    line2 := self lineOfCharacterPosition:charPos2.
    col2 := charPos2 - (self characterPositionOfLine:line2 col:1) + 1.

    self deleteFromLine:line1 col:col1 toLine:line2 col:col2.
!

deleteFromLine:startLine col:startCol toLine:endLine col:endCol
    "delete all text from startLine/startCol to endLine/endCol -
     joining lines if nescessary"

    |line newLine lineSize nMore|

    self checkModificationsAllowed ifFalse:[ ^ self].
    list isNil ifTrue:[^ self].
    startLine > list size ifTrue:[ ^ self]. "/ deleted space below text

    (startLine == endLine) ifTrue:[
        "/ delete chars within a line
        self deleteCharsAtLine:startLine fromCol:startCol toCol:endCol.
        ^ self
    ].

    ((startCol == 1) and:[endCol == 0]) ifTrue:[
        "/ delete full lines only
        endLine > startLine ifTrue:[
            self deleteFromLine:startLine toLine:(endLine - 1)
        ].
        ^ self
    ].

    "/ delete right rest of 1st line
    self deleteCharsAtLine:startLine fromCol:(startCol max:1).

    "/ delete the inner lines ...
    endLine > (startLine + 1) ifTrue:[
        self deleteFromLine:(startLine + 1) toLine:(endLine - 1)
    ].

    (endCol ~~ 0) ifTrue:[
        "/ delete the left rest of the last line

        self deleteCharsAtLine:(startLine + 1) toCol:endCol.

        "/ must add blanks, if startCol lies beyond end of startLine
        startLine <= list size ifTrue:[
            line := list at:startLine.
            lineSize := line size.
            (startCol > lineSize) ifTrue:[
                newLine := line.
                line isNil ifTrue:[
                    newLine := String new:(startCol - 1)
                ] ifFalse:[
                    nMore := startCol - 1 - lineSize.
                    nMore > 0 ifTrue:[
                        newLine := line , (line species new:nMore)
                    ]
                ].
                newLine ~~ line ifTrue:[
                    self basicListAt:startLine put:newLine.
                ].
                "/ TODO: remember old maxwidth of linerange,
                "/ only clear widthOfWidestLine, if this max
                "/ length was (one of) the longest.
                "/ avoids slow delete with huge texts.
                widthOfWidestLine := nil. "/ i.e. unknown
                self textChanged.
            ]
        ]
    ].

    "/ merge the left rest of 1st line with right rest of last line into one
    self mergeLine:startLine removeBlanks:false

    "Modified: / 10-11-1998 / 23:52:59 / cg"
    "Modified: / 18-03-2011 / 18:25:01 / az"
!

deleteFromLine:startLineNr toLine:endLineNr
    "delete some lines"

    |deleted|

    deleted := self textFromLine:startLineNr col:1 toLine:endLineNr+1 col:0.
    self basicDeleteFromLine:startLineNr toLine:endLineNr.
    self addUndo:(PasteString line:startLineNr col:1 string:deleted info:'delete').
!

deleteLine:lineNr
    "delete line"

    self deleteFromLine:lineNr toLine:lineNr


!

deleteLineWithoutRedraw:lineNr
    "delete line - no redraw;
     return true, if something was really deleted"

    |deleted ret|

    deleted := self textFromLine:lineNr col:1 toLine:lineNr+1 col:0.
    ret := self basicDeleteLineWithoutRedraw:lineNr.
    self addUndo:(PasteString line:lineNr col:1 string:deleted info:'delete').
    ^ ret.
!

deleteLinesWithoutRedrawFrom:startLine to:endLine
    "delete lines - no redraw;
     return true, if something was really deleted"

    |lastLine|

    self checkModificationsAllowed ifFalse:[^ false].

    (list isNil or:[startLine > list size]) ifTrue:[^ false].
    (endLine > list size) ifTrue:[
        lastLine := list size
    ] ifFalse:[
        lastLine := endLine
    ].
    self basicListRemoveFromIndex:startLine toIndex:lastLine.
    "/ TODO: remember old maxwidth of linerange,
    "/ only clear widthOfWidestLine, if this max
    "/ length was (one of) the longest.
    "/ avoids slow delete with huge texts.
    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.
    ^ true

    "Modified: / 10.11.1998 / 23:55:29 / cg"
!

deleteSelection
    "delete the selection"

    |wasOn startLine startCol endLine endCol|

    self checkModificationsAllowed ifFalse:[ ^ self].

    selectionStartLine notNil ifTrue:[
        wasOn := self hideCursor.

        startLine := selectionStartLine.
        startCol := selectionStartCol.
        endLine := selectionEndLine.
        endCol := selectionEndCol.
        self unselectWithoutRedraw.
        self deleteFromLine:startLine col:startCol toLine:endLine col:endCol.
        self setCursorLine:startLine col:startCol.

        self makeCursorVisibleAndShowCursor:wasOn
    ]
!

deleteWordBeforeCursor
    "delete the word to the left of cursor and move cursor to left"

    |wasOn beginCol beginLine endCol endLine|

    self checkModificationsAllowed ifFalse:[ ^ self].
    cursorCol <= 1 ifTrue:[
        self deleteCharBeforeCursor.
        ^ self 
    ].

    wasOn := self hideCursor.
    self 
        undoableDo:[
            endCol := cursorCol-1.
            endLine := cursorLine.
            self cursorToPreviousWord.
            beginCol := cursorCol.
            beginLine := cursorLine.
            self deleteFromLine:beginLine col:beginCol toLine:endLine col:endCol.
            self cursorLine:cursorLine col:beginCol.
        ] 
        info:'Delete Word'.
    wasOn ifTrue:[ self showCursor ].

    "Modified: / 22.2.2000 / 23:59:04 / cg"
!

indentSelectionBy1
    "indent selected line-range
     by 1 space (i.e. to the right)"

    self indentBy:1

    "Created: / 06-06-2016 / 10:58:19 / cg"
!

insert:aCharacter atLine:lineNr col:colNr
    "insert a single character at lineNr/colNr;
     set emphasis to character at current position"

    self basicInsert:aCharacter atLine:lineNr col:colNr.
    aCharacter ~~ Character cr ifTrue:[
        self addUndo:(DeleteCharacters line:lineNr col:colNr info:'insert').
    ]
!

insertCharAtCursor:aCharacter
    "insert a single character at cursor-position - advance cursor."

    |wasOn|

    wasOn := self hideCursor.
    aCharacter == Character tab ifTrue:[
        "/ needs special care to advance cursor correctly
        self insertTabAtCursor
    ] ifFalse:[
        self insert:aCharacter atLine:cursorLine col:cursorCol.
        aCharacter == (Character cr) ifTrue:[
            self basicCursorReturn
        ] ifFalse:[
            self cursorRight.
        ].
    ].
    self makeCursorVisibleAndShowCursor:wasOn.

    "Modified: / 12.6.1998 / 21:50:20 / cg"
!

insertLine:aString before:lineNr
    "insert the line aString before line lineNr"

    ^ self insertLines:(Array with:aString) from:1 to:1  before:lineNr.

    "Modified: 14.5.1996 / 13:42:54 / cg"
!

insertLines:aStringCollection before:lineNr
    "insert a bunch before line lineNr"

    self insertLines:aStringCollection from:1 to:aStringCollection size before:lineNr

    "Modified: 6.9.1995 / 20:51:03 / claus"
!

insertLines:someText from:start to:end before:lineNr
    "insert a bunch of lines before line lineNr.
     The cursor position is left unchanged."

    |text indent visLine w nLines "{ Class: SmallInteger }"
     srcY "{ Class: SmallInteger }"
     dstY "{ Class: SmallInteger }" |

    "wrong when pasting multiple lines"
    false "autoIndent" ifTrue:[
        indent := self leftIndentForLine:lineNr.

        text := someText 
            collect:[:ln||line|
                ln notNil ifTrue:[
                    line := ln withoutLeadingSeparators.
                    (line isEmpty or:[indent == 0]) ifFalse:[
                        line := (String new:indent), line
                    ].
                    line
                ] ifFalse:[
                    nil
                ]
            ].
    ] ifFalse:[
        text := someText
    ].

    visLine := self listLineToVisibleLine:lineNr.
    (shown not or:[visLine isNil]) ifTrue:[
        self withoutRedrawInsertLines:text
             from:start to:end
             before:lineNr.
    ] ifFalse:[
        nLines := end - start + 1.
        ((visLine + nLines) >= nLinesShown) ifTrue:[
            self withoutRedrawInsertLines:text
                 from:start to:end
                 before:lineNr.
            self redrawFromVisibleLine:visLine to:nLinesShown
        ] ifFalse:[
            w := self widthForScrollBetween:(lineNr + nLines)
                                        and:(firstLineShown + nLines + nLinesShown).
            srcY := topMargin + ((visLine - 1) * fontHeight).
            dstY := srcY + (nLines * fontHeight).

            "/
            "/ scroll ...
            "/
            "
             stupid: must catchExpose before inserting new
             stuff - since catchExpose may perform redraws
            "
            self catchExpose.
            self withoutRedrawInsertLines:text
                 from:start to:end
                 before:lineNr.
            self
                copyFrom:self
                x:textStartLeft y:srcY
                toX:textStartLeft y:dstY
                width:w
                height:(height - dstY)
                async:true.
            self redrawFromVisibleLine:visLine to:(visLine + nLines - 1).
            self waitForExpose
        ].
    ].
    widthOfWidestLine notNil ifTrue:[
        text do:[:line |
            widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:line).
        ]
    ].
    self textChanged.

    "Modified: 29.1.1997 / 13:02:39 / cg"
!

insertLines:lines withCR:withCr
    "insert a bunch of lines at cursor position.
     Cursor is moved behind insertion.
     If withCr is true, append cr after last line"

    |start end nLines wasOn|

    lines notNil ifTrue:[
        nLines := lines size.
        (nLines == 1) ifTrue:[
            self insertStringAtCursor:(lines at:1).
            withCr ifTrue:[
                self insertCharAtCursor:(Character cr)
            ]
        ] ifFalse:[
            (cursorCol ~~ 1) ifTrue:[
                self insertStringAtCursor:(lines at:1).
                self insertCharAtCursor:(Character cr).
                start := 2
            ] ifFalse:[
                start := 1
            ].
            withCr ifTrue:[
                end := nLines
            ] ifFalse:[
                end := nLines - 1
            ].
            (start <= nLines) ifTrue:[
                (end >= start) ifTrue:[
                    wasOn := self hideCursor.
                    self insertLines:lines from:start to:end before:cursorLine.
                    self setCursorLine:(cursorLine + (end - start + 1)).
                    wasOn ifTrue:[self showCursor].
                ]
            ].
            withCr ifFalse:[
                "last line without cr"
                self insertStringAtCursor:(lines at:nLines)
            ]
        ]
    ]

    "Created: / 18.5.1996 / 15:32:06 / cg"
    "Modified: / 12.6.1998 / 21:51:16 / cg"
!

insertLines:lines withCr:withCr
    "insert a bunch of lines at cursor position. Cursor
     is moved behind insertion.
     If withCr is true, append cr after last line"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #insertLines:withCR:'.
    self insertLines:lines withCR:withCr.

    "Modified: 31.7.1997 / 23:07:22 / cg"
!

insertSelectedStringAtCursor:aString
    "insert the argument, aString at cursor position and select it"

    |startLine startCol|

    startLine := cursorLine.
    startCol := cursorCol.
    self insertStringAtCursor:aString.
    self selectFromLine:startLine col:startCol
                 toLine:cursorLine col:(cursorCol - 1).
    self makeSelectionVisible.
!

insertString:aString atCharacterPosition:charPos
    "insert the argument, aString at a character position"

    |line col|

    line := self lineOfCharacterPosition:charPos.
    col := charPos - (self characterPositionOfLine:line col:1) + 1.
    col == 0 ifTrue:[
        line > 1 ifTrue:[
            line := line - 1. 
            col := (self listAt:line) size + 1. 
        ] ifFalse:[
            col := 1.
        ]
    ].
    self insertString:aString atLine:line col:col
!

insertString:aString atLine:lineNr col:colNr
    "insert the string, aString at line/col;
     handle cr's correctly"

    |start           "{ Class: SmallInteger }"
     stop            "{ Class: SmallInteger }"
     end             "{ Class: SmallInteger }"
     subString c
     l               "{ Class: SmallInteger }" |

    aString isNil ifTrue:[^ self].
    (aString includes:(Character cr)) ifFalse:[
        ^ self insertStringWithoutCRs:aString atLine:lineNr col:colNr
    ].

    l := lineNr.
    c := colNr.
    start := 1.
    end := aString size.
    [start <= end] whileTrue:[
        stop := aString indexOf:(Character cr) startingAt:start.
        stop == 0 ifTrue:[
            stop := end + 1
        ].
        subString := aString copyFrom:start to:(stop - 1).
        self insertStringWithoutCRs:subString atLine:l col:c.
        (stop <= end) ifTrue:[
            c := c + subString size.
            self insert:(Character cr) atLine:l col:c.
            l := l + 1.
            c := 1
        ].
        start := stop + 1
    ]

    "Modified: / 10.6.1998 / 19:03:59 / cg"
!

insertStringAtCursor:aString
    "insert the argument, aString at cursor position
     handle cr's correctly. A nil argument is interpreted as an empty line."

    aString isNil ifTrue:[
        "new:"
        self insertCharAtCursor:(Character cr).
        ^ self
    ].
    (aString includes:(Character cr)) ifFalse:[
        ^ self insertStringWithoutCRsAtCursor:aString
    ].

    self insertLines:aString asStringCollection withCR:false.

    "Modified: / 10.6.1998 / 19:03:21 / cg"
!

insertStringWithoutCRs:aString atLine:lineNr col:colNr
    "insert aString (which has no crs) at lineNr/colNr"

    self withoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr.
    shown ifTrue:[
        gc font hasOverlappingCharacters ifTrue:[
            self invalidateLine:lineNr.
        ] ifFalse:[
            self redrawLine:lineNr from:colNr
        ]
    ]

    "Modified: / 09-11-2010 / 13:43:03 / cg"
!

insertStringWithoutCRsAtCursor:aString
    "insert a string (which has no crs) at cursor position
     - advance cursor"

    |wasOn oldLen newLen deltaLen|

    aString size > 0 ifTrue:[
        wasOn := self hideCursor.
        (aString includes:Character tab) ifTrue:[
            self checkForExistingLine:cursorLine.
            oldLen := (list at:cursorLine) size.
            self insertString:aString atLine:cursorLine col:cursorCol.
            newLen := (list at:cursorLine) size.
            deltaLen := newLen - oldLen.
        ] ifFalse:[
            self insertString:aString atLine:(cursorLine ? 1) col:cursorCol.
            deltaLen := aString size.
        ].
        self setCursorCol:(cursorCol + deltaLen).
        wasOn ifTrue:[self showCursor]
    ]

    "Modified: / 10.6.1998 / 20:43:52 / cg"
!

insertTabAtCursor
    "insert spaces to next tab"

    |wasOn nextTab|

    wasOn := self hideCursor.
    nextTab := self nextTabAfter:cursorCol.
    self insertStringAtCursor:(String new:(nextTab - cursorCol)).
    self makeCursorVisibleAndShowCursor:wasOn.
!

joinLines
    "join lines (remove line-break)"

    self checkModificationsAllowed ifFalse:[ ^ self].

    self
        undoableDo:[
            |line col lineLen|

            line := cursorLine.
            col := cursorCol.
            lineLen := (list at:line) size.
            col > lineLen ifTrue:[
                self insertString:(String new:col-lineLen) atLine:line col:col+1.
            ] ifFalse:[
                self deleteCharsAtLine:line fromCol:col toCol:lineLen.
            ].
            self mergeLine:line removeBlanks:true.
            self cursorLine:line col:col.
        ]
        info:'Join'
!

mergeLine:lineNr
    "merge line lineNr with line lineNr+1"

    self mergeLine:lineNr removeBlanks:true

    "Modified: 9.9.1997 / 09:28:03 / cg"
!

mergeLine:lineNr removeBlanks:removeBlanks
    "merge line lineNr with line lineNr+1"

    |len|

    self checkModificationsAllowed ifFalse:[ ^ self].

    len := (self listAt:lineNr) size.
    self nonUndoableDo:[
        self basicMergeLine:lineNr removeBlanks:removeBlanks.
    ].
    self addUndo:(PasteString new line:lineNr col:len+1 string:(Character cr asString) selected:false).
!

parenthizeSelection
    "place parenthesis around the selected text.
     if already parenthized, de-parenthize it"

    self parenthizeSelectionWith:$( and:$)

    "Created: / 06-06-2016 / 10:59:05 / cg"
!

parenthizeSelectionWith:openingCharacter and:closingCharacter
    "if already parenthized, de-parenthize it"

    |newSelectionEnd startLine endLine startCol endCol|

    self hasSelection ifFalse:[^ self].
    startLine := selectionStartLine.
    endLine := selectionEndLine.
    startCol := selectionStartCol.
    endCol := selectionEndCol.
    
    newSelectionEnd := endCol.
    
    (self characterAtLine:startLine col:startCol) == openingCharacter ifTrue:[
        (self characterAtLine:endLine col:endCol) == closingCharacter ifTrue:[
            self deleteCharAtLine:endLine col:endCol.
            newSelectionEnd := newSelectionEnd-1.
        ].
        self deleteCharAtLine:startLine col:startCol.
        startLine == endLine ifTrue:[
            newSelectionEnd := newSelectionEnd-1.
        ]
    ] ifFalse:[
        self insert:closingCharacter atLine:endLine col:endCol+1.
        newSelectionEnd := newSelectionEnd+1.
        self insert:openingCharacter atLine:startLine col:startCol.
        startLine == endLine ifTrue:[
            newSelectionEnd := newSelectionEnd+1.
        ]
    ].
    self
        selectFromLine:startLine col:startCol
        toLine:endLine col:newSelectionEnd.

    "Modified (comment): / 06-06-2016 / 11:00:37 / cg"
!

removeTrailingBlankLines
    "remove all blank lines at end of text"

    |lastLine "{ Class: SmallInteger }"
     line finished|

    NoModificationError handle:[:ex |
        ^ self
    ] do:[
        lastLine := list size.
        finished := false.
        [finished] whileFalse:[
            (lastLine <= 1) ifTrue:[
                finished := true
            ] ifFalse:[
                line := list at:lastLine.
                line notNil ifTrue:[
                    line isBlank ifTrue:[
                        self basicListAt:lastLine put:nil.
                        line := nil
                    ]
                ].
                line notNil ifTrue:[
                    finished := true
                ] ifFalse:[
                    lastLine := lastLine - 1
                ]
            ]
        ].
        (lastLine ~~ list size) ifTrue:[
            list grow:lastLine.
            "/ self textChanged
        ]
    ].
!

replace:aCharacter atLine:lineNr col:colNr
    "replace a single character at lineNr/colNr"

    |originalChar|

    originalChar := self characterAtLine:lineNr col:colNr.
    self basicReplace:aCharacter atLine:lineNr col:colNr.
    self addUndo:(ReplaceCharacters line:lineNr col:colNr character:originalChar info:'replace').
!

replace:patternArg by:replacePatternArg all:all ignoreCase:ignoreCase
    |pattern replacePattern|

    pattern := patternArg string.
    replacePattern := replacePatternArg string.
    (pattern notEmpty and:[ replacePattern notEmpty ]) ifTrue:[
        self rememberSearchPattern:pattern.
        self rememberSearchPattern:replacePattern.
        LastSearchIgnoredCase := ignoreCase.
        self
            undoableDo:[
                all ifTrue:[
                    self
                        replaceString:pattern
                        to:replacePattern
                        ignoreCase:ignoreCase
                ] ifFalse:[
                    (self selectionAsString notNil
                        and:[ self selectionAsString sameAs:pattern caseSensitive:ignoreCase not ])
                            ifTrue:[
                                self replaceSelectionBy:replacePattern.
                                self
                                    search:pattern
                                    ignoreCase:ignoreCase
                                    forward:(lastSearchDirection = #forward).
                            ].
                ]
            ]
            info:'Replace'
    ]

    "Created: / 11-07-2006 / 11:19:57 / fm"
!

replaceCharAtCursor:aCharacter
    "undoably replace a single character at cursor-position - advance cursor"

    |wasOn|

    wasOn := self hideCursor.
    aCharacter == (Character cr) ifTrue:[
        self cursorReturn
    ] ifFalse:[
        self replace:aCharacter atLine:cursorLine col:cursorCol.
        self cursorRight.
    ].
    self makeCursorVisibleAndShowCursor:wasOn.

    "Created: 6.3.1996 / 12:27:42 / cg"
!

replaceContentsWith:newContents
    "undoably replace everything"

    |originalContents|

    originalContents := self contents.
    self contents:newContents keepUndoHistory:true.
    self addUndo:(ReplaceContents text:originalContents info:'replace').
!

replaceFromCharacterPosition:charPos1 to:charPos2 with:newString
    "undoably replace a substring at a character position"

    "/ sigh - insert first, to avoid trouble due to shifing-in virtual line ends
    self insertString:newString atCharacterPosition:charPos1.
    self deleteFromCharacterPosition:charPos1+newString size to:charPos2+newString size.
!

replaceLine:lineNr with:newText
    "undoably replace a line at lineNr"

    |originalLine|

    originalLine := self listAt:lineNr.
    originalLine isNil ifTrue:[
        self checkForExistingLine:lineNr
    ].
    self list at:lineNr put:newText.
    self addUndo:(ReplaceLine line:lineNr string:originalLine info:'replace').
    self invalidateLine:lineNr.

    "Modified: / 12-04-2007 / 09:31:33 / cg"
!

replaceLines:lines withCR:withCr
    "undoably a bunch of lines at cursor position. Cursor
     is moved behind replacement.
     If withCr is true, move to the beginning of the next line
     after the last line"

    |line col nLines wasOn|

    lines notNil ifTrue:[
        wasOn := self hideCursor.
        nLines := lines size.
        line := cursorLine.
        col := cursorCol.
        lines keysAndValuesDo:[:i :l |
            self replaceString:(l ? '') atLine:line col:col.
            (i ~~ nLines or:[withCr]) ifTrue:[
                line := line + 1.
                col := 1.
            ] ifFalse:[
                col := col + (l size).
            ]
        ].
        self cursorLine:line col:col.
        self makeCursorVisibleAndShowCursor:wasOn.
        "/ wasOn ifTrue:[self showCursor].
    ]

    "Created: / 18-05-1996 / 15:32:06 / cg"
    "Modified: / 25-07-2013 / 17:00:53 / cg"
!

replaceSelectionBy:something
    "undoably delete the selection (if any) and insert something, a character or string;
     leave cursor after insertion"

    self replaceSelectionBy:something keepCursor:false select:false
!

replaceSelectionBy:something keepCursor:keep
    "undoably delete the selection (if any) and insert something, a character or string;
     leave cursor after insertion or leave it, depending on keep"

    self replaceSelectionBy:something keepCursor:keep select:false

    "Modified: 9.10.1996 / 16:14:35 / cg"
!

replaceSelectionBy:something keepCursor:keep select:selectNewText
    "undoably delete the selection (if any) and insert something, a character or string;
     leave cursor after insertion or leave it, depending on keep.
     If selectNewText is true, select the new text; otherwise deselect"

    |sel l c selStartLine selStartCol|

    l := cursorLine.
    c := cursorCol.

    sel := self selectionAsString.
    sel isNil ifTrue:[
        selStartLine := l.
        selStartCol := c.
    ] ifFalse:[
        selStartLine := selectionStartLine.
        selStartCol := selectionStartCol.

        self setLastStringToReplace: sel.

        self deleteSelection.
        replacing := true.
        lastReplacementInfo rememberReplacement.
        lastReplacementInfo lastReplacement: ''.
        lastReplacementInfo stillCollectingInput:true.
        undoSupport actionInfo:'replace'.
    ].

    something isCharacter ifTrue:[
        lastReplacementInfo lastReplacement notNil ifTrue:[
            lastReplacementInfo stillCollectingInput ifTrue:[
                lastReplacementInfo lastReplacement: (lastReplacementInfo lastReplacement copyWith:something).
            ].
        ].
        self isInInsertMode ifTrue:[
            self insertCharAtCursor:something
        ] ifFalse:[
            self replaceCharAtCursor:something
        ]
    ] ifFalse:[
        something isString ifTrue:[
            lastReplacementInfo lastReplacement: something.
            self isInInsertMode ifTrue:[
                self insertStringAtCursor:something
            ] ifFalse:[
                self replaceStringAtCursor:something
            ]
        ] ifFalse:[
            Transcript showCR:'EditTextView: non String-or-Character in replace'.
        ].
    ].
    keep ifTrue:[
        self cursorLine:l col:c
    ].
    selectNewText ifTrue:[
        self selectFromLine:selStartLine col:selStartCol toLine:cursorLine col:cursorCol-1
    ]

    "Modified: 9.10.1996 / 16:14:35 / cg"
!

replaceString:aString atLine:lineNr col:colNr
    "undoably replace multiple characters starting at lineNr/colNr.
     This is not prepared to encounter special chars (except TAB) in the string."

    |originalString|

    self checkModificationsAllowed ifFalse:[ ^ self].

    originalString := self textFromLine:lineNr col:colNr toLine:lineNr col:colNr+aString size-1.

    self basicReplaceString:aString atLine:lineNr col:colNr.
    self addUndo:(ReplaceCharacters line:lineNr col:colNr characters:originalString info:'replace').
!

replaceString:aString to:aNewString ignoreCase:ignoreCase
    |continue count|

    self cursorToTop.
    self selectFromBeginning.
    count := 0.
    continue := true.
    [ continue ] whileTrue:[
        (self selectionAsString notNil
        and:[ self selectionAsString sameAs:aString caseSensitive:ignoreCase not ])
            ifTrue:[
                self replaceSelectionBy:aNewString.
                count := count + 1.
            ].
        self
            searchFwd:aString
            ignoreCase:ignoreCase
            ifAbsent:[
                Dialog information:('%1 has been replaced by %2 %3 times' 
                                    bindWith:aString with:aNewString with:count).
                continue := false.
            ].
    ].

    "Created: / 10-07-2006 / 16:42:48 / fm"
!

replaceStringAtCursor:aString
    "replace multiple characters at cursor-position - advance cursor"

    |wasOn i1 i2|

    wasOn := self hideCursor.
    (aString includes:Character tab) ifTrue:[
        "/ need special care for TAB (to move cursor correctly)
        i1 := 1.
        [i1 ~~ 0] whileTrue:[
            i2 := aString indexOf:Character tab startingAt:i1.
            i2 ~~ 0 ifTrue:[
                i1 ~~ i2 ifTrue:[
                    self replaceString:(aString copyFrom:i1 to:i2-1) atLine:cursorLine col:cursorCol.
                    self cursorCol:(cursorCol + (i2 - i1)).
                ].
                self replaceTABAtCursor.
                i2 := i2 + 1.
            ] ifFalse:[
                self replaceString:(aString copyFrom:i1) atLine:cursorLine col:cursorCol.
                self cursorCol:(cursorCol + (aString size - i1 + 1)).
            ].
            i1 := i2.
        ]
    ] ifFalse:[
        self replaceString:aString atLine:cursorLine col:cursorCol.
        self setValidatedCursorCol:(cursorCol + aString size).
        "/ self cursorCol:(cursorCol + aString size).
    ].
    wasOn ifTrue:[
        self sensor pushUserEvent:#makeCursorVisibleAndShowCursor: for:self withArguments:{ wasOn } 
        "/ self makeCursorVisibleAndShowCursor:wasOn.
    ].

    "Created: / 9.6.1998 / 20:33:20 / cg"
    "Modified: / 20.6.1998 / 19:41:02 / cg"
!

replaceTABAtCursor
    "replace a single character at cursor-position by a TAB character"

    |wasOn nextTab|

    wasOn := self hideCursor.
    nextTab := self nextTabAfter:cursorCol.
    self replaceStringAtCursor:(String new:(nextTab - cursorCol)).
    self makeCursorVisibleAndShowCursor:wasOn.

    "Created: / 12.6.1998 / 21:53:23 / cg"
!

selectWordBeforeCursor
    "select the word to the left of cursor"

    |savCursorLine savCursorCol  beginCol beginLine endCol endLine|

    savCursorLine := cursorLine.
    savCursorCol := cursorCol.

    endCol := cursorCol-1.
    endLine := cursorLine.
    self cursorToPreviousWord.
    beginCol := cursorCol.     
    beginLine := cursorLine.
    self cursorLine:savCursorLine col:savCursorCol.
    self selectFromLine:beginLine col:beginCol toLine:endLine col:endCol.

    "Created: / 14-06-2011 / 14:46:35 / cg"
!

splitLine:lineNr before:colNr
    "split the line linNr before colNr; the right part (from colNr)
     is cut off and inserted after lineNr; the view is redrawn"

    self basicSplitLine:lineNr before:colNr.
    self addUndo:(DeleteRange line1:lineNr col1:colNr line2:lineNr+1 col2:0 info:'split').
!

toggleTabSetting
    "toggle between 4-col
     and 8-col tabs"

    (tabPositions == self class tab4Positions)
         ifTrue:[self setTab8]
         ifFalse:[self setTab4]

    "Created: / 06-06-2016 / 11:02:07 / cg"
!

undentSelectionBy1
    "undent selected line-range
     by 1 space (i.e. to the left)"

    self undentBy:1

    "Created: / 06-06-2016 / 10:49:51 / cg"
!

withAutoIndent:aBoolean do:aBlock
    |sav|

    sav := autoIndent.
    autoIndent := aBoolean.
    aBlock ensure:[ autoIndent := sav ].
!

withoutRedrawAt:lineNr put:aString
    "replace a line at lineNr"

    |originalLine|

    originalLine := self listAt:lineNr.
    self addUndo:(ReplaceLine line:lineNr string:originalLine info:'replace').
    super withoutRedrawAt:lineNr put:aString.
!

withoutRedrawInsertLine:aString before:lineNr
    "insert the argument, aString before line lineNr; the string
     becomes line lineNr; everything else is moved down; the view
     is not redrawn"

    self basicWithoutRedrawInsertLines:{ aString } from:1 to:1 before:lineNr.
    self addUndo:(DeleteRange line1:lineNr col1:1 line2:lineNr+1 col2:0 info:'insert').
!

withoutRedrawInsertLines:lines from:start to:end before:lineNr
    "insert a bunch of lines before line lineNr; the view is not redrawn"

    self basicWithoutRedrawInsertLines:lines from:start to:end before:lineNr.
    self isReadOnly ifFalse:[
        self addUndo:(DeleteRange line1:lineNr col1:1 line2:lineNr+end-start+1 col2:0 info:'insert').
    ].
!

withoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr
    "insert aString (which has no crs) at lineNr/colNr"

    self basicWithoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr.
    self addUndo:(DeleteRange line1:lineNr col1:colNr line2:lineNr col2:colNr+aString size-1 info:'insert').
!

wrapLines
    "wrap lines (insert line-break)"

    |lineLength answerString string|

    self checkModificationsAllowed ifFalse:[ ^ self].

    self hasSelection ifFalse:[
        self selectLine:cursorLine.
    ].
    string := self selectionAsString.
    string isEmptyOrNil ifTrue:[
        Dialog information:(resources string:'Nothing selected.').
        ^ self.
    ].

    answerString := Dialog request:(resources string:'Line length (wrap after how many chars)?') initialAnswer:80.
    lineLength := Number readFrom:answerString onError:nil.
    lineLength isNil ifTrue:[^ self].
    lineLength < 1 ifTrue:[
        lineLength := 1.
    ].

    self
        undoableDo:[
            |inStream line col lineLen lastGoodCol lastStartCol word|

            line := selectionStartLine.
            col := selectionStartCol.

            self cutSelection.
            self cursorLine:line col:col.

            lastGoodCol := col.

            inStream := string readStream.
            [ inStream atEnd ] whileFalse:[
                [inStream atEnd not and:[inStream peek isSeparator]] whileTrue:[ inStream next ].
                word := WriteStream on:(String new:10).
                [inStream atEnd not and:[inStream peek isSeparator not]] whileTrue:[ word nextPut:inStream next ].
                (col + 1 + word size > lineLength) ifTrue:[
                    self insertCharAtCursor:(Character cr).
                    col := 1.
                ] ifFalse:[
                    col ~~ 1 ifTrue:[ 
                        self insertStringAtCursor:' '.
                        col := col + 1.
                    ]    
               ].
               self insertStringAtCursor:word contents.
               col := col + word size.
            ].
        ]
        info:'Wrap'

    "Modified: / 01-03-2012 / 19:56:22 / cg"
! !

!EditTextView methodsFor:'editing-basic'!

basicDeleteCharsAtLine:lineNr fromCol:startCol toCol:endCol
    "delete characters from startCol to endCol in line lineNr"

    |line lineSize newLine start stop prevWidth newWidth|

    self unselect.

    cursorLine == lineNr ifTrue:[
        cursorCol >= startCol ifTrue:[
            cursorCol >= endCol ifTrue:[
                cursorCol := startCol.
            ] ifFalse:[
                cursorCol := cursorCol - (endCol - startCol + 1).
                "/ self assert:(cursorCol >= 0).
                cursorCol := cursorCol max:1.
            ]
        ].
    ].

    line := self listAt:lineNr.

    (self checkModificationsAllowed and:[line notNil]) ifFalse:[^ self].

    lineSize := line size.

    startCol == 0 ifFalse:[ start := startCol ] ifTrue:[ start := 1 ].
    endCol > lineSize ifFalse:[ stop  := endCol ] ifTrue:[ stop  := lineSize ].

    stop >= start ifTrue:[
        start ~~ 1 ifTrue:[ newLine := line copyFrom:1 to:(start-1) ]
                  ifFalse:[ newLine := '' ].

        stop == lineSize ifFalse:[
            line bitsPerCharacter > newLine bitsPerCharacter ifTrue:[
                newLine := line string species fromString:newLine.
            ].
            newLine := newLine, (line copyFrom:(stop + 1) to:lineSize)
        ].

        (self trimBlankLines and:[newLine isBlank]) ifTrue:[
            newLine := nil
        ].

        prevWidth := self widthOfLine:lineNr.

        self basicListAt:lineNr put:newLine.

        (prevWidth = widthOfWidestLine) ifTrue:[
            "/ remember old width of this line,
            "/ only clear widthOfWidestLine, if this lines
            "/ length was (one of) the longest.
            "/ avoids slow delete with huge texts.
            widthOfWidestLine := nil.   "i.e. unknown"

            "/ scroll left if reqiured
            viewOrigin x > 0 ifTrue:[
                newWidth := self widthOfLine:lineNr.
                newWidth < (viewOrigin x + width) ifTrue:[
                    self scrollHorizontalTo:(newWidth
                                             - width
                                             + margin + margin
                                             + (gc font widthOf:'  '))
                ]
            ].
            self textChanged.
        ] ifFalse:[
            self textChanged "/ textChangedButNoSizeChange
        ].
        gc font hasOverlappingCharacters ifTrue:[
            self invalidateLine:lineNr.
        ] ifFalse:[
            self redrawLine:lineNr from:start.
        ].
    ].

    "Modified: / 09-11-2010 / 13:42:45 / cg"
!

basicDeleteFromLine:startLineNr toLine:endLineNr
    "delete some lines"

    |wasOn nLines|

    self checkModificationsAllowed ifFalse:[ ^ self].
    list isNil ifTrue:[^ self].

    wasOn := self hideCursor.

    "/ isnt this the same as:
    "/ self deleteLinesWithoutRedrawFrom:startLineNr to:endLineNr.
    startLineNr <= list size ifTrue:[
        self basicListRemoveFromIndex:startLineNr toIndex:(endLineNr min:list size).
    ].
    "/ TODO: remember old maxwidth of linerange,
    "/ only clear widthOfWidestLine, if this max
    "/ length was (one of) the longest.
    "/ avoids slow delete with huge texts.
    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.

    self redrawFromLine:startLineNr.

    nLines := list size.
    (firstLineShown >= nLines) ifTrue:[
        self makeLineVisible:nLines
    ].
    wasOn ifTrue:[self showCursor].

    "Modified: / 10-11-1998 / 23:55:05 / cg"
    "Modified: / 18-03-2011 / 18:26:23 / az"
!

basicDeleteLineWithoutRedraw:lineNr
    "delete line - no redraw;
     return true, if something was really deleted"

    self checkModificationsAllowed ifFalse:[ ^ false].

    (list isNil or:[lineNr > list size]) ifTrue:[^ false].
    list removeIndex:lineNr.
    "/ TODO: remember old maxwidth of linerange,
    "/ only clear widthOfWidestLine, if this max
    "/ length was (one of) the longest.
    "/ avoids slow delete with huge texts.
    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.
    ^ true

    "Modified: / 10.11.1998 / 23:53:24 / cg"
!

basicInsert:aCharacter atLine:lineNr col:colNr
    "insert a single character at lineNr/colNr;
     set emphasis to character at current position"

    |line lineSize newLine drawCharacterOnly attribute oldClip x y|

    self checkModificationsAllowed ifFalse:[ ^ self].

    aCharacter == (Character cr) ifTrue:[
        self splitLine:lineNr before:colNr.
        ^ self
    ].

    drawCharacterOnly := false.
    self checkForExistingLine:lineNr.
    line := list at:lineNr.
    lineSize := line size.

    self st80EditMode ifFalse:[
        (self trimBlankLines
        and:[colNr > lineSize
        and:[aCharacter == Character space]]) ifTrue:[
            ^ self
        ]
    ].

    (lineSize == 0) ifTrue:[
        newLine := aCharacter asString species new:colNr.
        drawCharacterOnly := true
    ] ifFalse: [
        (colNr > lineSize) ifTrue: [
            colNr == (lineSize +1) ifTrue:[
                attribute := line emphasisAt:lineSize
            ].
            newLine := line species new:colNr.
            newLine replaceFrom:1 to:lineSize with:line startingAt:1.
            drawCharacterOnly := true
        ] ifFalse: [
            attribute := line emphasisAt:colNr.
            newLine   := line species new:(lineSize + 1).

            newLine replaceFrom:1 to:(colNr - 1) with:line startingAt:1.
            newLine replaceFrom:(colNr + 1) to:(lineSize + 1) with:line startingAt:colNr
        ]
    ].

    aCharacter asString bitsPerCharacter > newLine bitsPerCharacter ifTrue:[
        newLine := aCharacter asString species fromString:newLine.
        line isText ifTrue:[
            newLine := newLine asText
        ]
    ].
    newLine at:colNr put:aCharacter.

    attribute notNil ifTrue:[
        newLine emphasisAt:colNr put:attribute.
    ].

    aCharacter == (Character tab) ifTrue:[
        newLine := self withTabsExpanded:newLine.
        drawCharacterOnly := false
    ].

    self basicListAt:lineNr put:(newLine ifNil:[newLine] ifNotNil:[newLine asSingleByteStringIfPossible]).
    widthOfWidestLine notNil ifTrue:[
        widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:newLine).
    ].
    self textChanged.
    shown ifTrue:[
        "/ care for italic text - in this case, we must also
        "/ redraw the character before the insertion in order
        "/ to fix the slanted piece of the character.
        "/ (but we must clip, to avoid destoying the character before)
        (newLine notNil and:[newLine isText]) ifTrue:[
            colNr > 1 ifTrue:[
                cursorVisibleLine notNil ifTrue:[
                    oldClip := self clippingBoundsOrNil.
                    x := (self xOfCol:colNr-1 inVisibleLine:cursorVisibleLine) - viewOrigin x.
                    y := self yOfVisibleLine:cursorVisibleLine.

                    gc font hasOverlappingCharacters ifTrue:[
                        self invalidateLine:lineNr.
                    ] ifFalse:[
                        drawCharacterOnly ifTrue:[
                            self clippingBounds:(x@y extent:((gc font width * 2) @ fontHeight)).
                            self redrawLine:lineNr from:colNr-1 to:colNr
                        ] ifFalse:[
                            self clippingBounds:(x@y extent:((width - x) @ fontHeight)).
                            self redrawLine:lineNr from:colNr-1
                        ].
                        self clippingBounds:oldClip.
                    ].
                ].
                ^ self.
            ].
        ].
        gc font hasOverlappingCharacters ifTrue:[
            self invalidateLine:lineNr.
        ] ifFalse:[
            drawCharacterOnly ifTrue:[
                self redrawLine:lineNr col:colNr
            ] ifFalse:[
                self redrawLine:lineNr from:colNr
            ]
        ]
    ]

    "Modified: / 09-11-2010 / 13:43:18 / cg"
!

basicListAt:lineNr put:newLine
    "redefinable for special subclasses (with virtual list)"

    list at:lineNr put:newLine.
!

basicListRemoveFromIndex:startLineNr toIndex:endLineNr
    "redefinable for special subclasses (with virtual list)"

    list removeFromIndex:startLineNr toIndex:(endLineNr min:list size).
!

basicMergeLine:lineNr removeBlanks:removeBlanks
    "merge line lineNr with line lineNr+1"

    |leftPart rightPart bothParts nextLineNr i|

    (list notNil and:[(list size) >= lineNr]) ifFalse:[
        "/ empty list or beyond end of text
        ^ self
    ].
    leftPart := self listAt:lineNr.

    leftPart isNil ifTrue:[
        leftPart := ''.
        autoIndent ifTrue:[
            (i := self leftIndentForLine:cursorLine) == 0 ifFalse:[
                leftPart := String new:i
            ]
        ]
    ].
    self cursorLine:lineNr col:((leftPart size) + 1).
    nextLineNr := self validateCursorLine:(lineNr + 1).

    nextLineNr > (list size) ifFalse:[
        (rightPart := self listAt:nextLineNr) isNil ifTrue:[
            rightPart := ''
        ] ifFalse:[
            removeBlanks ifTrue:[
                rightPart := rightPart withoutLeadingSeparators.
            ]
        ].

        bothParts := leftPart , rightPart.
        (self trimBlankLines and:[bothParts isBlank]) ifTrue:[bothParts := nil].
        self basicListAt:lineNr put:bothParts.
        self redrawLine:lineNr.
        self deleteLine:nextLineNr
    ]

    "Created: 9.9.1997 / 09:27:38 / cg"
    "Modified: 9.9.1997 / 09:28:27 / cg"
!

basicReplace:aCharacter atLine:lineNr col:colNr
    "replace a single character at lineNr/colNr"

    |line lineSize newLineSpecies newLine drawCharacterOnly|

    self checkModificationsAllowed ifFalse:[ ^ self].

    aCharacter == (Character cr) ifTrue:[
        ^ self
    ].

    drawCharacterOnly := true.
    self checkForExistingLine:lineNr.
    line := list at:lineNr.
    lineSize := line size.

    (self trimBlankLines
    and:[colNr > lineSize
    and:[aCharacter == Character space]]) ifTrue:[
        ^ self
    ].

    (lineSize == 0) ifTrue:[
        newLine := aCharacter asString species new:colNr.
    ] ifFalse: [
        (aCharacter bitsPerCharacter > line bitsPerCharacter) ifTrue:[ 
            newLineSpecies := aCharacter stringSpecies
        ] ifFalse:[
            newLineSpecies := line species
        ].
        newLine := newLineSpecies new:(colNr max:lineSize).
        newLine replaceFrom:1 to:lineSize with:line startingAt:1.
    ].
    newLine at:colNr put:aCharacter.
    aCharacter == (Character tab) ifTrue:[
        newLine := self withTabsExpanded:newLine.
        drawCharacterOnly := false
    ].
    self basicListAt:lineNr put:(newLine ifNil:[newLine] ifNotNil:[newLine asSingleByteStringIfPossible]).
    widthOfWidestLine notNil ifTrue:[
        widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:newLine).
    ].
    self textChanged.
    shown ifTrue:[
        gc font hasOverlappingCharacters ifTrue:[
            self invalidateLine:lineNr.
        ] ifFalse:[
            drawCharacterOnly ifTrue:[
                self redrawLine:lineNr col:colNr
            ] ifFalse:[
                self redrawLine:lineNr from:colNr
            ]
        ]
    ]

    "Created: / 06-03-1996 / 12:29:20 / cg"
    "Modified: / 09-11-2010 / 13:42:54 / cg"
!

basicReplaceString:aString atLine:lineNr col:colNr
    "replace multiple characters starting at lineNr/colNr.
     This is not prepared to encounter special chars (except TAB)
     in the string."

    |line lineSize newLine newLineSpecies endCol|

    self checkModificationsAllowed ifFalse:[ ^ self].

    self checkForExistingLine:lineNr.
    line := list at:lineNr.
    lineSize := line size.

    endCol := colNr + aString size - 1.
    (lineSize == 0) ifTrue:[
        newLine := aString species new:endCol.
    ] ifFalse: [
        (aString bitsPerCharacter > line bitsPerCharacter) ifTrue:[ 
            newLineSpecies := aString stringSpecies
        ] ifFalse:[
            newLineSpecies := line species
        ].

        newLine := newLineSpecies new:(endCol max:lineSize).
        newLine replaceFrom:1 to:lineSize with:line startingAt:1.
    ].
    newLine replaceFrom:colNr with:aString.
    (aString includes:(Character tab)) ifTrue:[
        newLine := self withTabsExpanded:newLine.
    ].
    self basicListAt:lineNr put:(newLine ifNil:[newLine] ifNotNil:[newLine asSingleByteStringIfPossible]).
    widthOfWidestLine notNil ifTrue:[
        widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:newLine).
    ].
    self textChanged.
    shown ifTrue:[
        gc font hasOverlappingCharacters ifTrue:[
            self invalidateLine:lineNr.
        ] ifFalse:[
            self redrawLine:lineNr from:colNr
        ]
    ]

    "Created: / 11-06-1998 / 10:38:32 / cg"
    "Modified: / 09-11-2010 / 13:42:56 / cg"
!

basicSplitLine:lineNr before:colNr
    "split the line linNr before colNr; the right part (from colNr)
     is cut off and inserted after lineNr; the view is redrawn"

    |line lineSize leftRest rightRest visLine w h mustWait
     srcY    "{ Class: SmallInteger }" |

    list isNil ifTrue:[ ^ self ].
    lineNr > (list size) ifTrue:[ ^ self ].

    (colNr == 1) ifTrue:[
        self nonUndoableDo:[
            self insertLine:nil before:lineNr.
        ].
        ^ self
    ].

    line := list at:lineNr.
    line notNil ifTrue:[
        lineSize := line size.
        (colNr <= lineSize) ifTrue:[
            rightRest := line copyFrom:colNr to:lineSize.
            (colNr > 1) ifTrue:[
                leftRest := line copyTo:(colNr - 1)
            ]
        ] ifFalse:[
            leftRest := line
        ]
    ].
    leftRest notNil ifTrue:[
        (self trimBlankLines and:[leftRest isBlank]) ifTrue:[leftRest := nil]
    ].
    self basicListAt:lineNr put:leftRest.
    self nonUndoableDo:[
        self withoutRedrawInsertLine:rightRest before:(lineNr + 1).
    ].
    visLine := self listLineToVisibleLine:(lineNr).
    visLine notNil ifTrue:[
        w := self widthForScrollBetween:lineNr
                                    and:(firstLineShown + nLinesShown).
        srcY := topMargin + (visLine * fontHeight).
        h := ((nLinesShown - visLine - 1) * fontHeight).
        (mustWait := (w > 0 and:[h > 0])) ifTrue:[
            self catchExpose.
            self
                copyFrom:self
                x:textStartLeft y:srcY
                toX:textStartLeft y:(srcY + fontHeight)
                width:w
                height:((nLinesShown - visLine - 1) * fontHeight)
                async:true.
        ].
        self redrawLine:lineNr.
        self redrawLine:(lineNr + 1).
        mustWait ifTrue:[self waitForExpose]
    ].
    widthOfWidestLine := nil. "/ unknown
    self textChanged.

    "Modified: / 06-12-2010 / 13:12:55 / cg"
!

basicWithoutRedrawInsertLines:lines from:start to:end before:lineNr
    "insert a bunch of lines before line lineNr; the view is not redrawn.
     Tabs are expanded here with a tab=8 setting (independent of any editor-setting,
     because the text might have been pasted from an alien view."

    |newLine newLines nLines|

    nLines := end - start + 1.
    newLines := Array new:(lines size).
    start to:end do:[:index |
        newLine := lines at:index.
        newLine notNil ifTrue:[
            newLine isString ifTrue:[
                newLine isBlank ifTrue:[
                    newLine := nil
                ] ifFalse:[
                    (newLine includes:(Character tab)) ifTrue:[
                        newLine := self withTabs:(ListView tab8Positions) expand:newLine
                    ]
                ]
            ]
        ].
        newLines at:index put:newLine
    ].
    list isNil ifTrue: [
        list := StringCollection new:(lineNr + nLines + 1)
    ] ifFalse: [
        list grow:((list size + nLines) max:(lineNr + nLines - 1))
    ].

    "I have changed 'replaceFrom:to:with:startingAt:' to correctly handle
     overlapping copy - if it didn't, we had to use:"
"
    index := list size.
    [index > lineNr] whileTrue: [
        pIndex := index - 1.
        list at:index put:(list at:pIndex).
        index := pIndex
    ].
"
    list replaceFrom:(lineNr + nLines) to:(list size) with:list startingAt:lineNr.
    list replaceFrom:lineNr to:(lineNr + nLines - 1) with:newLines startingAt:start.
    self contentsChanged

    "Modified: / 07-10-2011 / 15:55:18 / cg"
!

basicWithoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr
    "insert aString (which has no crs) at lineNr/colNr.
     Tabs are expanded here with a tab=8 setting (independent of any editor-setting,
     because the text might have been pasted from an alien view."

    |isText strLen line lineSize newLine stringType sz lineCharWidth stringCharWidth|

    (aString isNil) ifTrue:[ ^ self].

    strLen := aString size.
    self checkForExistingLine:lineNr.

    stringType := aString string species.
    isText     := aString isText.
    line       := list at:lineNr.

    line notNil ifTrue:[
        lineSize := line size.
        line isString ifFalse:[
            stringType := line species
        ] ifTrue:[
            lineCharWidth := line bitsPerCharacter.
            stringCharWidth := aString bitsPerCharacter.
            lineCharWidth > stringCharWidth ifTrue:[
                stringType := line string species
            ] ifFalse:[
                stringCharWidth > lineCharWidth ifTrue:[
                    stringType := aString string species
                ]
            ].
            line isText ifTrue:[ isText := true ]
        ].
    ] ifFalse:[
        lineSize := 0
    ].

    ((colNr == 1) and:[lineSize == 0]) ifTrue: [
        newLine := aString
    ] ifFalse:[
        (lineSize == 0 or:[colNr > lineSize]) ifTrue: [
            sz := colNr + strLen - 1
        ] ifFalse:[
            sz := lineSize + strLen
        ].

        newLine := stringType new:sz.
        isText ifTrue:[
            newLine := Text string:newLine
        ].

        (lineSize ~~ 0) ifTrue: [
            (colNr > lineSize) ifTrue: [
                newLine replaceFrom:1 to:lineSize with:line startingAt:1
            ] ifFalse: [
                newLine replaceFrom:1 to:(colNr - 1) with:line startingAt:1.
                newLine replaceFrom:(colNr + strLen) to:(lineSize + strLen) with:line startingAt:colNr
            ]
        ].
        newLine replaceFrom:(colNr max:1) to:(colNr + strLen - 1) with:aString startingAt:1
    ].

    (aString includes:(Character tab)) ifTrue:[
        newLine := self withTabs:(ListView tab8Positions) expand:newLine
    ].

    self basicListAt:lineNr put:(newLine ifNil:[newLine] ifNotNil:[newLine asSingleByteStringIfPossible]).
    widthOfWidestLine notNil ifTrue:[
        widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:newLine).
    ].
    self textChanged.

    "Modified: / 25-01-2012 / 00:37:29 / cg"
! !

!EditTextView methodsFor:'event handling'!

buttonPress:button x:x y:y
    "hide the cursor when button is activated"

    hasKeyboardFocus := true.   "/ cg: why is this needed?
    dragIsActive := false.

    completionSupport notNil ifTrue:[ 
        "/ also give that guy a chance to close its popup view
        completionSupport buttonPress:button x:x y:y
    ].

    cursorShown ifTrue: [
        self drawCursor
    ].

    "On X11, be nice and paste PRIMARY when middle click. 
     Note, that middle button on X11 is translated to button
     128 in Smalltalk/X - see XWorkstation class>>initializeConstants"
    (button == #paste and:[device platformName == #X11]) ifTrue:[
        self undoableDo:[
            self paste: (self getClipboardText:#selection).
        ].
        ^self.
    ].

    (button == 1) ifTrue:[
        self hideCursor
    ].
"/ some very old code from times, when a right-click was a paste in X11
"/
"/    (button == #paste) ifTrue:[
"/        self pasteOrReplace.
"/        ^ self
"/    ].
    super buttonPress:button x:x y:y

    "Modified: / 23-03-1999 / 13:51:40 / cg"
    "Modified (comment): / 17-04-2012 / 21:02:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttonRelease:button x:x y:y
    "move the cursor to the click-position of previous button press"

    |x1 x2 x2_3 newCursorCol|

    (button == 1) ifTrue:[
        typeOfSelection := nil.

        dragIsActive ifTrue:[
            self unselect
        ].
        selectionStartLine isNil ifTrue:[
            clickCol notNil ifTrue:[
                self cursorMovementAllowed ifTrue:[
                    newCursorCol := clickCol.

                    cursorType ~~ #block ifTrue:[
                        clickPos notNil ifTrue:[
                            "/ we do something special, if the text-cursor's type is not a block-cursor
                            "/ (i.e. if its an ibeam).
                            "/ adjust clickCol if the user clicked in the right third of a character.
                            x1 := self xOfCol:clickCol inVisibleLine:clickLine.  
                            x2 := self xOfCol:clickCol+1 inVisibleLine:clickLine.
                            x2_3 := x1 + ((x2-x1) * (2/3)).
                            (clickPos x >= x2_3) ifTrue:[ newCursorCol := clickCol+1 ].
                        ].
                    ].
                    "/ the following fixes the ugly select behavior when double clicking on
                    "/ a partially visible last line (where the first click used to
                    "/ scroll the text so that the second click was handled on another
                    "/ line. An alternative (possibly better) solution would be to
                    "/ remember the last click position and adjust in the double click
                    "/ event handling (i.e. subtract the number of scrolled lines in between)
                    "/ Time will show, if this hack works.
                    clickLine >= (self lastLineShown -1 ) ifTrue:[
                        self cursorLine:clickLine col:newCursorCol makeVisible:false.
                        Processor 
                            addTimedBlock:[self sensor pushUserEvent:#makeCursorVisible for:self]
                            after:0.3 seconds.
                    ] ifFalse:[
                        self cursorLine:clickLine col:newCursorCol.
                    ].
                ].
                true "self hadSelectionBeforeClick not" ifTrue:[
                    list notEmptyOrNil ifTrue:[
                        UserPreferences current selectAllWhenClickingBeyondEnd ifTrue:[
                            (clickLine >= list size) ifTrue:[
                                (clickLine > (self list size + 2) 
                                or:[ clickCol > (list last size + 5) ]) ifTrue:[
                                    self selectAll
                                ].
                            ].
                        ]
                    ]
                ]
            ]
        ] ifFalse:[
            lastStringFromReplaceForNextSearch := nil.  "new selection invalidates remembered string"
        ].
        self showCursor
    ].
    super buttonRelease:button x:x y:y

    "Modified: / 07-03-2012 / 18:48:37 / cg"
!

cursorKeyPress:key shifted:shifted
    <resource: #keyboard (#CursorRight #CursorDown #CursorUp #CursorDown)>

    | n oldTypeOfSelection |

    oldTypeOfSelection := typeOfSelection.

    self changeTypeOfSelectionTo:nil.

    (key == #CursorRight) ifTrue:[
        (shifted and:[selectionStartLine isNil]) ifTrue:[
            selectionStartLine := selectionEndLine := clickStartLine := cursorLine.
            selectionStartCol := selectionEndCol := clickStartCol := cursorCol.
            cursorCol := cursorCol + 1.
            expandingTop := false.
            self validateNewSelection.
            self setPrimarySelection.
            self selectionChanged.
            self redrawLine:selectionStartLine.
            ^ self.
        ].

        self cursorMovementAllowed ifTrue:[
            shifted ifTrue:[
                self addToSelectionAfter:[ self cursorRight ]
            ] ifFalse:[
                "/ Compensate for Claus paste-cursordown-paste feature.
                "/ Right after paste the cursor is at the beginning of the
                "/ selection. But if immediately after paste user moves cursor right
                "/ (but without shift!!!!!!), she probably wants to move past the 
                "/ pasted text, not into it. This is how every other editor behaves.
                oldTypeOfSelection == #paste ifTrue:[
                    cursorLine := selectionEndLine.
                    cursorCol := selectionEndCol + 1.
                ].

                "/ If there's selection, unselect and move cursor
                "/ to the end of selection.
                self hasSelection ifTrue:[ 
                    self setCursorLine: selectionEndLine.
                    self setCursorCol: selectionEndCol + 1.
                    self unselect; makeCursorVisible.
                    ^ self.
                ].
                self unselect; makeCursorVisible.
                self cursorRight.
            ].
        ].
        ^ self
    ].
    (key == #CursorDown) ifTrue:[
        (shifted and:[selectionStartLine isNil]) ifTrue:[
            selectionStartLine := clickStartLine := cursorLine. selectionEndLine := cursorLine + 1.
            selectionStartCol := clickStartCol := cursorCol.
            selectionEndCol := cursorCol - 1.
"/            selectionEndCol == 1 ifTrue:[
"/                selectionEndCol := 0.
"/            ].
            self setCursorLine: cursorLine + 1.
            self validateNewSelection.
            self selectionChanged.
            self redrawLine:selectionStartLine.
            expandingTop := false.
            self redrawLine:selectionEndLine.
            ^ self
        ].

        selectionStartLine notNil ifTrue:[
            self cursorMovementAllowed ifTrue:[
                "/
                "/ treat the whole selection as cursor
                "/
"/                self setCursorLine:(selectionEndLine ? selectionStartLine).
"/                self setCursorCol:selectionStartCol.
"/                (cursorCol == 0 or:[selectionEndCol == 0]) ifTrue:[
"/                    self setCursorCol:1.
"/                    self setCursorLine:(cursorLine - 1).
"/                ].
"/                self makeCursorVisible.
"/
"/                shifted ifTrue:[
"/                    clickLine := cursorLine.
"/                    clickCol := cursorCol.
"/                    self setCursorLine: cursorLine + 1.
"/                    self expandSelectionDown.
"/                    ^ self
"/                ].
"/                self unselect.
            ].
        ].
        self cursorMovementAllowed ifTrue:[
            n := 1 + (self sensor compressKeyPressEventsWithKey:#CursorDown).
            shifted ifTrue:[
                self addToSelectionAfter:[ self cursorDown:n ]
            ] ifFalse:[
                "/ If there's selection, unselect and move cursor
                "/ one line below last selection line but at the
                "/ selectionStartCol column. This behavior is
                "/ useful when pasting...
                self hasSelection ifTrue:[ 
                    self setCursorLine: selectionEndLine.
                    self setCursorCol: selectionStartCol.
                ].    
                self unselect; makeCursorVisible.
                self cursorDown:n.
            ].  
            "/
            "/ flush keyboard to avoid runaway cursor
            "/
            self sensor flushKeyboardFor:self.
        ].
        ^ self
    ].
    (key == #CursorLeft or:[key == #CursorUp]) ifTrue:[
        (shifted and:[selectionStartLine isNil]) ifTrue:[
            expandingTop := true.
            key == #CursorLeft ifTrue:[
                cursorCol > 1 ifTrue:[
                    selectionStartLine := selectionEndLine := clickStartLine := cursorLine.
                    selectionEndCol := clickStartCol := cursorCol-1.
                    selectionStartCol := cursorCol-1.
                    self setCursorCol: cursorCol-1.
                    self validateNewSelection.
                    self selectionChanged.
                    self redrawLine:selectionStartLine.
                    ^ self
                ]
            ] ifFalse:[
                cursorLine > 1 ifTrue:[
                    selectionEndLine := clickStartLine := cursorLine.
                    selectionStartCol := clickStartCol := cursorCol.
                    selectionEndCol := cursorCol - 1.
                    selectionStartLine := cursorLine - 1.
                    selectionEndCol == 1 ifTrue:[
                        selectionEndCol := 0.
                    ].
                    self validateNewSelection.
                    self selectionChanged.
                    self redrawFromLine:selectionStartLine to:cursorLine.
                    self setCursorLine: cursorLine - 1.  
                    ^ self
                ]
            ]
        ].

        self hasSelection ifTrue:[
            self cursorMovementAllowed ifTrue:[
                "/
                "/ treat the whole selection as cursor
                "/
"/                self setCursorLine:selectionStartLine.
"/                self setCursorCol:selectionStartCol.
"/                self makeCursorVisible.
"/
"/                shifted ifFalse:[
"/                    self unselect.
"/                ]
            ].
        ].
        (key == #CursorLeft) ifTrue:[
            shifted ifTrue:[
                self addToSelectionAfter:[self cursorLeft].
            ] ifFalse:[
                "/ If there's selection, unselect and move cursor
                "/ to the end of selection.   
                self hasSelection ifTrue:[ 
                    self setCursorLine:selectionStartLine.
                    self setCursorCol:selectionStartCol.
                    self unselect; makeCursorVisible.                    
                    ^ self.
                ].
                self unselect; makeCursorVisible.
                self cursorLeft. 
            ].
            ^self
        ].
        (key == #CursorUp)        ifTrue:[
            n := 1 + (self sensor compressKeyPressEventsWithKey:#CursorUp).
            shifted ifTrue:[
                self addToSelectionAfter: [ self cursorUp:n ]
            ] ifFalse:[
                "/ If there's selection, unselect and move cursor
                "/ to the beggining of selection.   
                self hasSelection ifTrue:[ 
                    self setCursorLine:selectionStartLine.
                    self setCursorCol:selectionStartCol.
                ].    
                self unselect; makeCursorVisible.
                self cursorUp:n.
            ].
            "/
            "/ flush keyboard to avoid runaway cursor
            "/
            self sensor flushKeyboardFor:self.
            ^ self
        ].
    ].

    "Modified: / 28-03-2014 / 12:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doKeyPress:key x:x y:y
    "handle keyboard input"

    <resource: #keyboard (#Paste #Insert #PasteFromHistory #Cut #Again #AgainForAll
                          #Replace #Undo #Redo #Accept
                          #Delete #BasicDelete #BackSpace #BasicBackspace
                          #DeleteSpaces #Join
                          #SearchMatchingParent #SelectMatchingParents
                          #SelectWord #ExpandSelectionByWord
                          #SelectToEnd #SelectFromBeginning
                          #SelectLine #ExpandSelectionByLine
                          #BeginOfLine #EndOfLine #NextWord #PreviousWord
                          #CursorRight #CursorDown #CursorLeft #CursorUp
                          #Return #Tab #BackTab #NonInsertingTab #Escape
                          #GotoLine #BeginOfText #EndOfText
                          #InsertLine #DeleteLine
                          #SelectLineFromBeginning
                          #LearnKeyboardMacro #ExecuteKeyboardMacro #ToggleInsertMode
                          #OpenSpecialCharacterWindow #InsertUUID
                          #'F*' #'f*')>

    |fKeyMacros shiftPressed ctrlPressed i event immediateCompletion currentUserPrefs rawKey|

    currentUserPrefs := UserPreferences current.

    "/ experimental
    immediateCompletion := currentUserPrefs immediateCodeCompletion.
    (immediateCompletion 
    or:[currentUserPrefs codeCompletionOnControlKey
    or:[currentUserPrefs codeCompletionOnTabKey]]) ifTrue:[
        completionSupport isNil ifTrue:[
            self initializeCompletionSupport.
        ].
    ].
    
    "/ JV: why setting it to nil here?
"/    ifFalse:[
"/        completionService := nil
"/    ].
    completionSupport notNil ifTrue:[
        completionSupport stopCompletionProcess.
        (completionSupport handleKeyPress:key x:x y:y) ifTrue:["eaten" ^ self].
    ].

    key isSymbol ifTrue:[
        (device modifierKeys includes:key) ifFalse:[
            lastReplacementInfo stillCollectingInput:false.
        ]
    ].
    (key == #LearnKeyboardMacro) ifTrue:[
        lastReplacementInfo stillCollectingInput:false.
        self toggleLearnMode.
        ^ self
    ].
    (key == #ExecuteKeyboardMacro) ifTrue:[
        lastReplacementInfo stillCollectingInput:false.
        self executeLearnedKeyboardMacro.
        ^ self.
    ].
    (key == #Undo) ifTrue:[self undo. ^self].
    (key == #Redo) ifTrue:[self redo. ^self].

    self learnMode ifTrue:[
        event := WindowGroup lastEventQuerySignal query.
        learnedMacro add:event.
    ].

    (self executekeyboardMacroNamed:key) ifTrue:[
        "the macro named key exists"
        ^ self
    ].

    key isSymbol ifFalse:[
        "the usual case: key is a character, but maybe a string also (in X11)"
        self handleNonCommandKey:key.
        ^ self
    ].

    event isNil ifTrue:[
        event := WindowGroup lastEventQuerySignal query.
    ].
    shiftPressed := event hasShift.
    ctrlPressed := event hasCtrl and:[(event rawKey asString startsWith:'Ctrl') not].
    rawKey := event rawKey.

    key == #InsertUUID ifTrue:[
        self insertUUID.
        ^ self.
    ].

    (key == #DeleteWordBeforeCursor) ifTrue:[
        self deleteWordBeforeCursor.
        ^ self.
    ].

    (rawKey == #BackSpace or:[key == #BasicBackspace]) ifTrue:[
        selectionStartLine notNil ifTrue:[
            ((key == #BasicBackspace)
            or:[ currentUserPrefs deleteSetsClipboardText not ])
            ifTrue:[
                self deleteSelection.
            ] ifFalse: [
                self copyAndDeleteSelection.
            ].
        ] ifFalse:[
            self makeCursorVisible.
"/          (shiftPressed and:[ ctrlPressed ]) ifTrue:[
"/            self deleteWordBeforeCursor.
"/          ] ifFalse:[
            self deleteCharBeforeCursor.
"/          ].
        ].
        true "immediateCompletion" ifTrue:[ 
            completionSupport notNil ifTrue:[ 
                completionSupport postKeyPress:key
            ].
        ].
        ^ self
    ].

    (key == #ToggleAutoIndent) ifTrue:[
        self autoIndent:(autoIndent not).
        ^ self.
    ].

    key == #ToggleInsertMode ifTrue:[
        self insertMode:(editMode value == EditMode insertMode) not.
        ^ self.
    ].

    key == #OpenSpecialCharacterWindow ifTrue:[
        CharacterSetView notNil ifTrue:[
            self specialCharacters.
            ^ self.
        ]        
    ].

    replacing := false.

    "
     Fn      pastes a key-sequence (but only if not overlayed with
             another function in the keyboard map)

     see TextView>>:x:y
    "
    (key at:1) asLowercase == $f ifTrue:[
        (('[fF][0-9]' match:key)
        or:['[fF][0-9][0-9]' match:key]) ifTrue:[
            shiftPressed ifFalse:[
                fKeyMacros := currentUserPrefs functionKeySequences.
                fKeyMacros notNil ifTrue:[
                    (fKeyMacros includesKey:key) ifTrue:[
                        self pasteOrReplace:(fKeyMacros at:key) asStringCollection.
                        ^ self
                    ]
                ]
            ]
        ].
    ].

    (key == #'Ctrl8' or:[key == #'Ctrl9']) ifTrue:[
        self parenthizeSelectionWith:$( and:$).
        ^ self.
    ].
    (key == #'Ctrl2') ifTrue:[
        self parenthizeSelectionWith:$" and:$".
        ^ self.
    ].
    (key == #'Ctrl#') ifTrue:[
        self parenthizeSelectionWith:$' and:$'.
        ^ self.
    ].
    (key == #'ConvertSelectionToLowercaseOrUppercaseOrUppercaseFirst') ifTrue:[
        self convertSelectionToLowercaseOrUppercaseOrUppercaseFirst.
        ^ self.
    ].

    (key == #Accept)  ifTrue:[^ self accept].
    (key == #PasteFromHistory) ifTrue:[self pasteOrReplaceFromHistory. ^self].
    (key == #Paste or:[key == #Insert]) ifTrue:[self pasteOrReplaceByKeyPress. ^self].
    (key == #Cut) ifTrue:[self cut. ^self].
    (key == #Again) ifTrue:[self again. ^self].
    (key == #AgainForAll) ifTrue:[self multipleAgain. ^self].

    (key == #Join) ifTrue:[self joinLines. ^self].
    (key == #Replace) ifTrue:[self replace. ^self].
    (key == #ExpandSelectionByWord) ifTrue:[
        self makeCursorVisible.
        self findNextWordAfterSelectionAndAddToSelection.
        ^ self
    ].
    (key == #SelectWord) ifTrue:[
        self makeCursorVisible.
        self selectWordUnderCursor.
        ^ self
    ].

    (key == #SearchMatchingParent) ifTrue:[self searchForMatchingParenthesis. ^ self].
    (key == #SelectMatchingParents) ifTrue:[self searchForAndSelectMatchingParenthesis. ^ self].
    (key == #SelectToEnd) ifTrue:[self selectUpToEnd. ^ self].
    (key == #SelectFromBeginning) ifTrue:[self selectFromBeginning. ^ self].

" disabled - nobody liked it ...
  and if you like it, its better done in the keymap.

    (key == #Ctrlb) ifTrue:[self unselect. self cursorLeft. ^ self].
    (key == #Ctrlf) ifTrue:[self unselect. self cursorRight. ^ self].
    (key == #Ctrln) ifTrue:[self unselect. self cursorDown. ^ self].
    (key == #Ctrlp) ifTrue:[self unselect. self cursorUp. ^ self].
"

    (key == #BeginOfLine) ifTrue:[
        shiftPressed ifTrue: [
            "/ "Original St/X code - now use Ctrl modifier"
            "/ self unselect.
            "/ self cursorHome.
            "Jan's modification"
            self addToSelectionAfter:[ self cursorToBeginOfLine ].
            "/ Jan's modification modified by his own request ;-))
            "/ JV: Well, does not work correctly. Better to fix addToSelectionAfter: 
            "/ self selectFromBeginOfLine.
        ] ifFalse: [
            self unselect.
            ctrlPressed ifTrue:[
                self cursorHome.
            ] ifFalse:[
                self cursorToBeginOfLine.
            ]
        ].
        ^ self
    ].
    (key == #EndOfLine) ifTrue:[
        shiftPressed ifTrue:[
            "/ "Original St/X code - now use Ctrl modifier"
            "/ self unselect.
            "/ self cursorToBottom
            " Jan's modification"
            self addToSelectionAfter:[ self cursorToEndOfLine ] .
            "/ Jan's modification modified by his own request ;-))
            "/ JV: Well, does not work correctly. Better to fix addToSelectionAfter:
            "/  self selectToEndOfLine.
        ] ifFalse:[
            self unselect.
            ctrlPressed ifTrue:[
                self cursorToBottom
            ] ifFalse:[
                self cursorToEndOfLine.
            ]
        ].
        ^ self
    ].
    (key == #NextWord) ifTrue:[
        shiftPressed ifTrue:[
            self addToSelectionAfter:[  
                self cursorToNextWord. 
            ]
        ] ifFalse:[ 
            self cursorToNextWord
        ].
        ^self
    ].
    (key == #EndOfWord) ifTrue:[self cursorToEndOfWord. ^self].
    (key == #PreviousWord) ifTrue:[
        shiftPressed ifTrue:[
            self addToSelectionAfter:[      
                self cursorToPreviousWord. 
            ]
        ] ifFalse:[ 
            self cursorToPreviousWord.                                
        ].
        ^self
    ].
    (key == #GotoLine) ifTrue:[self gotoLine. ^self].

    (rawKey == #CursorRight
    or:[rawKey == #CursorDown
    or:[rawKey == #CursorLeft
    or:[rawKey == #CursorUp]]]) ifTrue:[
        self cursorKeyPress:rawKey shifted:shiftPressed.
        ^ self.
    ].

    (key == #ShiftReturn or:[key == #NonInsertingReturn]) ifTrue:[
        self unselect. self cursorReturn.
        ^ self
    ].

    (key == #Return) ifTrue:[
        shiftPressed ifTrue:[
            self unselect. self cursorReturn.
            ^ self
        ].

        self isReadOnly ifTrue:[
            self unselect; makeCursorVisible.
            self cursorReturn
        ] ifFalse:[
            self isInInsertMode ifFalse:[
                self cursorReturn:true.
                autoIndent == true ifTrue:[
                    i := self leftIndentForLine:(cursorLine + 1).
                    (self listAt:cursorLine) isEmptyOrNil ifTrue:[
                        self cursorCol:(i+1 max:1)
                    ]
                ]
            ] ifTrue:[
                |left right oldIndent|

                "/ old version just unselected ...
                "/ self unselect; makeCursorVisible.

                "/ new version deletes ...
                typeOfSelection == #paste ifTrue:[
                    self unselect; makeCursorVisible.
                ] ifFalse:[
                    self copyAndDeleteSelection.
                ].
                left := (self listAt:cursorLine to:cursorCol-1) ? ''.
                right := (self listAt:cursorLine from:cursorCol) ? ''.
                self insertCharAtCursor:(Character cr).

                autoIndent == true ifTrue:[
                    (right isEmpty and:[cursorCol ~~ 1]) ifTrue:[
                        "/ nothing to do.
                    ] ifFalse:[
                        ((self listAt:cursorLine) isEmptyOrNil 
                        or:[ false "cursorCol == 1" ]) ifTrue:[
                            i := (self leftIndentForLine:cursorLine).
                            left := left withoutSeparators.
                            right := right withoutSeparators.
                            (left endsWith:'[') ifTrue:[
"/                                i := i + 4.
                            ] ifFalse:[
                                (false "(left endsWith:']')" or:[(right startsWith:']')]) ifTrue:[
                                    i := i - 4.
                                ].
                            ].
                            oldIndent := self leftIndentOfLine:cursorLine.
                            self indentFromLine:cursorLine toLine:cursorLine by:(i-oldIndent).
                            self st80EditMode ifTrue:[
                                (self listAt:cursorLine) size < i ifTrue:[
                                    self insertStringAtCursor:(String new:((i-oldIndent) max:0)).
                                ].
                            ].
                            self cursorCol:(i+1 max:1)
                        ].
                    ]
                ].
            ].
        ].
        ^ self
    ].

    (key == #NonInsertingTab) ifTrue:[
        self unselect. self cursorTab.
        ^ self
    ].
    ((key == #BackTab) or:[(key == #Tab)]) ifTrue:[
        self tabMeansNextField ifTrue:[^ super keyPress:key x:x y:y].
        (self hasSelection and:[selectionStartLine ~~ selectionEndLine]) ifTrue:[
            ((key == #Tab) and:[shiftPressed not]) ifTrue:[
                self indentByTab.
            ] ifFalse:[
                self undentByTab.
            ].
            ^ self.
        ].

        self unselect.
        (key == #Tab) ifTrue:[
            (shiftPressed or:[self isInInsertMode not]) ifTrue:[
                self cursorTab.
                ^ self
            ].
            self insertTabAtCursor.
            ^ self
        ].
        self cursorBacktab.
        ^ self
    ].

    "/ key == #DeleteSpaces ifTrue:[
    (rawKey == #Delete) ifTrue:[
        shiftPressed ifTrue:[
            [(cursorCol <= (self listAt:cursorLine) size)
             and:[self characterUnderCursor isSeparator]] whileTrue:[
             self makeCursorVisible.
                self deleteCharAtCursor.
            ].
            ^ self
        ]
    ].

    (rawKey == #Delete
     or:[key == #BasicDelete]) ifTrue:[
        selectionStartLine notNil ifTrue:[  
"/          Again function is not supporting Delete action (on purpose, to avoid replacing the next search string)
"/          To remove text repetetively, use Cut instead.
"/            self setLastStringToReplace: self selection asStringWithoutFinalCR.
"/            lastReplacementInfo lastReplacement: nil.
            ((key == #BasicDelete)
            or:[currentUserPrefs deleteSetsClipboardText not]) ifTrue:[
                self deleteSelection.
            ] ifFalse:[
                self copyAndDeleteSelection.
            ].
            ^ self
        ].
        self makeCursorVisible.
        self deleteCharAtCursor.
        ^ self
    ].

    (key == #BeginOfText) ifTrue:[     "i.e. HOME"
        self unselect.
        cursorVisibleLine == 1 ifTrue:[
            self cursorHome.
        ] ifFalse:[
            self cursorToFirstVisibleLine
        ].
        ^ self
    ].
    (key == #EndOfText) ifTrue:[       "i.e. END"
        self unselect.
        cursorVisibleLine == nFullLinesShown ifTrue:[
            self cursorToBottom.
        ] ifFalse:[
            self cursorToLastVisibleLine
        ].
        ^ self
    ].
    ((key == #Escape)
    or:[key == #SelectLineFromBeginning]) ifTrue:[
        self makeCursorVisible.
        self unselect. self selectCursorLineFromBeginning.
        ^ self
    ].
    (key == #SelectLine) ifTrue:[
        self makeCursorVisible.
        self unselect. self selectCursorLine.
        ^ self
    ].
    (key == #ExpandSelectionByLine) ifTrue:[
        "/ self makeCursorVisible.
        self selectExpandCursorLine.
        ^ self
    ].
    (key == #DeleteLine) ifTrue:[
        self makeCursorVisible.
        self unselect. self deleteCursorLine.
        ^ self
    ].
    (key == #InsertLine) ifTrue:[
        self makeCursorVisible.
        self unselect. self insertLine:nil before:cursorLine.
        ^ self
    ].

    super keyPress:key x:x y:y

    "Modified: / 06-02-1998 / 11:59:59 / stefan"
    "Modified: / 14-07-2011 / 12:08:28 / cg"
    "Modified: / 11-10-2017 / 23:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeKeyboardMacro:cmdMacro
    Error handle:[:ex |
        self warn:'Error in keyboard macro: ' , ex description.
        ex return.
    ] do:[
        AbortOperationRequest handle:[:ex |
            self warn:'Keyboard macro aborted'.
            ex return.
        ] do:[
            Parser
                evaluate:cmdMacro asString
                receiver:self
                notifying:nil
                compile:false.
        ].
    ].
!

extendSelectionToX:x y:y setPrimarySelection:aBoolean
    | movedVisibleLine movedLine movedCol movedUp |

    movedVisibleLine := self visibleLineOfY:y.
    movedLine := self visibleLineToAbsoluteLine:movedVisibleLine.

    (x < leftMargin) ifTrue:[
        movedCol := 0
    ] ifFalse:[
        movedCol := self colOfX:x inVisibleLine:movedVisibleLine
    ].

    "find out if we are before or after initial click"
    movedUp := false.
    (movedLine < (clickStartLine ? movedLine)) ifTrue:[
        movedUp := true
    ] ifFalse:[
        (movedLine == (clickStartLine ? movedLine)) ifTrue:[
            (movedCol < (clickStartCol ? movedCol)) ifTrue:[
                movedUp := true
            ]
        ]
    ].

    self hasSelection ifTrue:[ 
        movedUp ifTrue:[
            "/ Set cursor to selection start
            self setCursorLine: selectionStartLine col: selectionStartCol
        ] ifFalse:[ 
            "/ Set cursor to selection end
            self setCursorLine: selectionEndLine col: selectionEndCol + 1
        ].
    ].



    super extendSelectionToX:x y:y setPrimarySelection:aBoolean.

    "Created: / 02-05-2015 / 07:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleNonCommandKey:keyArg
    |selStartLineBefore selStartColBefore selEndLineBefore selEndColBefore key|

    self isReadOnly ifTrue:[
        self flashReadOnly.
        ^ self.
    ].

    key := keyArg.

    typeOfSelection == #paste ifTrue:[
        "Pasted selection will NOT be replaced by keystroke (non-standard, St/X feature)"

        "/ After paste, the cursor is at the beginning to support
        "/ paste-cursordown-paste. Compensate for this here - we want
        "/ to continue editing after the end of the selection.
        "/ This is
        cursorLine := selectionEndLine.
        cursorCol := selectionEndCol + 1.

        "/ Cursor position set, we can unselect.
        self unselect.
    ].

    selStartLineBefore := selectionStartLine.
    selStartColBefore := self selectionStartCol.
    selEndLineBefore := selectionEndLine.
    selEndColBefore := self selectionEndCol.

    (gc characterEncoding ? #'iso10646-1') ~~ #'iso10646-1' ifTrue:[
        key isCharacter ifTrue:[
            key := CharacterEncoder encode:key from:#'iso10646-1' into:gc characterEncoding.
        ] ifFalse:[
            key := CharacterEncoder encodeString:key from:#'iso10646-1' into:gc characterEncoding.
        ].
    ].

    "replace selection by what is typed in -
     if word was selected with a space, keep it.
     if there was no selection, the key's character is inserted"

    editMode value isInsertAndSelectMode ifTrue:[
        selectionStartLine := selectionStartCol := selectionEndLine := selectionEndCol := nil.
    ].

    (selectStyle == #wordLeft) ifTrue:[
        self replaceSelectionBy:(' ' , key asString)
    ] ifFalse:[
        (selectStyle == #wordRight) ifTrue:[
            self replaceSelectionBy:(key asString , ' ').
            self cursorLeft
        ] ifFalse:[
            self replaceSelectionBy:key
        ]
    ].
    selectStyle := nil.

    editMode value isInsertAndSelectMode ifTrue:[
        selectionStartLine := selStartLineBefore.
        selectionStartCol := selStartColBefore.
        selectionEndLine := selEndLineBefore.
        selectionEndCol := selEndColBefore.
    ].

    showMatchingParenthesis ifTrue:[
        "emacs style parenthesis shower"
      (ExecutingMacroQuery query ? false) ifFalse:[
        "claus: only do it for closing parenthesis -
                otherwise its too anoying.
        "
"
        ('()[]{}' includes:key) ifTrue:[
"
        (')]}' includes:key) ifTrue:[
        self
            searchForMatchingParenthesisFromLine:cursorLine col:(cursorCol - 1)
            ifFound:[:line :col |
                         |savLine savCol sensor|

                         self withCursor:Cursor eye do:[
                             savLine := cursorLine.
                             savCol := cursorCol.
                             self cursorLine:line col:col.
                             self flush.

                             "/ want to wait 200ms, but not if another keyPress
                             "/ arrives in the meantime ...

                             sensor := self sensor.
                             5 timesRepeat:[
                                 (sensor hasKeyPressEventFor:self) ifFalse:[
                                     Processor activeProcess millisecondDelay:40.
                                 ]
                             ].
                             self cursorLine:savLine col:savCol
                         ]
                    ]
            ifNotFound:[self showNotFound]
            onError:[self beep]
        ].
      ]
    ].

"/    true "autoExpandWhileTyping" ifTrue:[
"/        self wordAtLine:cursorLine col:cursorCol-1 do:[
"/            :beginLine :beginCol :endLine :endCol :style |
"/
"/            self selectFromLine:beginLine col:beginCol toLine:endLine col:endCol.
"/            self selection.
"/            typeOfSelection := #paste.
"/        ].
"/    ].
    editMode value isInsertAndSelectMode ifTrue:[
        selectionStartLine isNil ifTrue:[
            self selectFromLine:cursorLine col:cursorCol-1 toLine:cursorLine col:cursorCol-1.
        ] ifFalse:[
            self selectFromLine:selectionStartLine col:selectionStartCol toLine:cursorLine col:cursorCol-1.
        ].
    ].
    completionSupport notNil ifTrue:[ completionSupport postKeyPress:keyArg ].

    "Modified (comment): / 25-01-2012 / 00:30:11 / cg"
    "Modified: / 30-08-2013 / 20:10:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y
    "handle keyboard input"

    |wasOn|

    wasOn := cursorShown.

    NoModificationError 
        handle:[:ex |
            self flashReadOnly.
            (cursorShown not and:[wasOn]) ifTrue:[
                self makeCursorVisibleAndShowCursor:wasOn.
            ].
        ] 
        do:[
            self undoableDo:[
                self doKeyPress:key x:x y:y
            ].
        ].

    self repairDamage

    "Modified: / 18-04-2011 / 21:35:27 / cg"
    "Modified (format): / 30-04-2016 / 20:45:52 / cg"
!

mapped
    "view was made visible"

    super mapped.
    self updateCursorVisibleLine.
!

requestAutoAccept
    "request to accept: this is invoked when a dialog closes via accept or cancel.
     This forces my value to be accepted into my model.
     Any widget may suppress the ok/cancel, by returning false."

    acceptEnabled == false ifTrue:[
        "/ nope -
        ^ false
    ].
    "/ cg: only do this if modified.
    "/ otherwise, users would have to make sure that the contents is
    "/ always correct (which they don't). If you change this back,
    "/ please check the expecco file-save or file-reimport dialog,
    "/ which has a problem with that behavior.
    self modified ifTrue:[
        self accept.
    ].
    ^ true.
!

sizeChanged:how
    "make certain, cursor is visible after the sizechange"

    |cv|

    cv := cursorVisibleLine.
    super sizeChanged:how.
    cv notNil ifTrue:[
        self makeLineVisible:cursorLine
    ]
!

unmapped
    super unmapped.

    completionSupport notNil ifTrue:[
        completionSupport release.
    ].
! !

!EditTextView methodsFor:'focus handling'!

focusOut
    super focusOut.

    completionSupport notNil ifTrue:[
        completionSupport release.
    ].
!

hasKeyboardFocus:aBoolean
    "sent by the windowGroup, a delegate or myself to make me show a block cursor
     (otherwise, I would not know about this)"

    hasKeyboardFocus := aBoolean.

    (cursorShown
    and:[self enabled
    and:[self isReadOnly not]]) ifTrue:[
        self drawCursor
    ].

    hasKeyboardFocus ifFalse:[
        completionSupport notNil ifTrue:[
            "/ this is a hack for Windows:
            "/ on windows, an activate:false event is first sent to my textView,
            "/ then an activate is sent to the completion popup.
            "/ this is done BEFORE the buttonPress event is delivered.
            "/ therefore, allow for the activate of the completionMenu and its button event to be processed.
            "/ before forcing it to be closed...
            completionSupport startTimeoutForEditViewLostFocus.
        ].
    ].

    "Modified (format): / 06-11-2013 / 15:37:31 / cg"
!

showFocus:explicit
    "in addition to however my superclass thinks how a focusView is to be
     displayed, show the cursor when I got the focus"

    self hasKeyboardFocus:true.
    self showCursor.
    super showFocus:explicit

    "Modified: 11.12.1996 / 16:56:54 / cg"
!

showNoFocus:explicit
    "the view lost the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    super showNoFocus:explicit.

    "/ cg: only do this for an explicit change (i.e. by tabbing),
    "/ not when the focus is lost normally (because this also happens when
    "/ the completion-menu is clicked on), and we don't want to kill the
    "/ completer. Otherwise, completion does not work when clocking into the list.
    explicit ifTrue:[
        completionSupport notNil ifTrue:[
            completionSupport editViewLostFocus.
        ].
    ].

    "Modified: / 15-12-2017 / 00:30:27 / jv"
!

wantsFocusWithPointerEnter
    "return true, if I want the focus when
     the mouse pointer enters"

    (UserPreferences current focusFollowsMouse ~~ false
     and:[(styleSheet at:#'editText.requestFocusOnPointerEnter' default:true)
     and:[self enabled
     and:[true "self isReadOnly not"]]]
    ) ifTrue:[
        ^ true
    ].

    ^ false
! !

!EditTextView methodsFor:'formatting'!

executekeyboardMacroNamed:macroName
    "try to execute the keyboard macro; 
     return true if that worked, false otherwise"

    |cmdMacro|

    cmdMacro := UserPreferences current functionKeySequences at:macroName ifAbsent:[^ false].
    self
        undoableDo:[ self executeKeyboardMacro:cmdMacro ]
        info: macroName.
    ^ true

    "
      EditTextView open
                contents:'bla';
                selectAll;
                executekeyboardMacroNamed:#IndentBy4.
      EditTextView open
                contents:'bla';
                selectAll;
                executekeyboardMacroNamed:#blabla.
    "

    "Modified: / 14-02-2012 / 11:17:27 / cg"
!

indent
    "indent a line-range - this is done by searching for the
     last non-empty line before the selection, and changing the indent
     of the selected line-range based on that line's indent."

    |start end|

    selectionStartLine isNil ifTrue:[^ self].

    start := selectionStartLine.
    end := selectionEndLine.
    (selectionEndCol == 0) ifTrue:[
        end := end - 1
    ].
    self unselect.
    self
        undoableDo:[self indentFromLine:start toLine:end]
        info:'Indent'
!

indentBy4
    self indentBy:4. "/ self executekeyboardMacroNamed:#IndentBy4.

    "Modified: / 06-04-2011 / 18:52:40 / cg"
!

indentBy8
    self indentBy:8. "/ self executekeyboardMacroNamed:#IndentBy4.

    "Modified: / 06-04-2011 / 18:52:40 / cg"
!

indentBy:n
    |line1 line2|

    line1 := self selectionStartLine.
    line2 := self selectionEndLine.
    line1 isNil ifTrue:[
        line1 := self cursorLine.
        line1 notNil ifTrue:[
            line2 := line1
        ]
    ] ifFalse:[
        line2 notNil ifTrue:[
            self selectionEndCol == 0 ifTrue:[ line2 := line2 - 1 ].
        ].                
    ].                
    line1 notNil ifTrue:[
        self indentFromLine:line1 toLine:line2 by:n.
    ]
!

indentByTab
    self indentBy:((tabPositions == self class tab4Positions) ifTrue:4 ifFalse:8)
!

indentFromLine:start toLine:end
    "indent a line-range - this is done by searching for the
     last non-empty line before start, and change the indent
     of the selected line-range based on that line's indent."

    |leftStart delta|

    leftStart := self leftIndentForLine:start.
    (leftStart == 0) ifTrue:[^ self].

    delta := leftStart - (self leftIndentOfLine:start).
    (delta == 0) ifTrue:[^ self].
    self indentFromLine:start toLine:end by:delta
!

indentFromLine:start toLine:end by:delta
    "indent a line-range - this is done by searching for the
     last non-empty line before start, and change the indent
     of the selected line-range based on that line's indent."

    |d line spaces anyChange|

    (delta == 0) ifTrue:[^ self].
    (delta > 0) ifTrue:[
        spaces := String new:delta
    ].

    anyChange := false.
    start to:end do:[:lineNr |
        line := self listAt:lineNr.
        line notNil ifTrue:[
            line isBlank ifTrue:[
                self basicListAt:lineNr put:nil
            ] ifFalse:[
                (delta > 0) ifTrue:[
                    line := spaces , line.
                    widthOfWidestLine notNil ifTrue:[
                        widthOfWidestLine := widthOfWidestLine max:(self widthOfLineString:line).
                    ]
                ] ifFalse:[
                    "check if deletion is ok"
                    d := delta negated + 1.

                    line size > d ifTrue:[
                        (line copyTo:(d - 1)) withoutSeparators isEmpty ifTrue:[
                            line := line copyFrom:d
                        ]
                    ].
                    widthOfWidestLine := nil
                ].
                self replaceLine:lineNr with:line.
                anyChange := true.
            ]
        ]
    ].
    "/ Update the selection, if not whole-lines...
    (selectionStartLine == start and:[ selectionStartCol ~~ 1]) ifTrue:[ 
        selectionStartCol := (selectionStartCol + delta) max: 1.
    ].
    (selectionEndLine == end and:[ selectionEndCol ~~ 0]) ifTrue:[ 
        selectionEndCol := (selectionEndCol + delta) max: 1.
    ].

    anyChange ifTrue:[ self textChanged ].

    "/ self redrawFromLine:start to:end

    "Modified: / 05-03-1996 / 14:59:18 / cg"
    "Modified: / 11-10-2017 / 23:22:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leftIndentForLine:lineNr
    "find an appropriate indent for a line.
     this is done by searching for the last non-empty line before it
     and returning its indent.
     cg: changed: only look for the single previous line."

    "SHOULD GO TO ListView"

    |line lnr indent|

    lnr := lineNr.

    "/ [lnr ~~ 1] whileTrue:[
    (lnr ~~ 1) ifTrue:[
        lnr  := lnr - 1.
        line := self listAt:lnr.

        line notNil ifTrue:[
            indent := line indexOfNonSeparatorStartingAt:1.
            indent ~~ 0 ifTrue:[
                (line endsWith:$[) ifTrue:[
                    ^ indent + 4 - 1
                ].
                ^ indent - 1
            ]
        ]
    ].
    ^ 0

    "Created: 5.3.1996 / 14:58:53 / cg"
!

undentBy4
    self undentBy:4. "/ self executekeyboardMacroNamed:#UndentBy4.

    "Modified: / 06-04-2011 / 18:52:49 / cg"
!

undentBy8
    self undentBy:8. "/ self executekeyboardMacroNamed:#UndentBy4.

    "Modified: / 06-04-2011 / 18:52:49 / cg"
!

undentBy:n
    self indentBy:(n negated)
!

undentByTab
    self undentBy:((tabPositions == self class tab4Positions) ifTrue:4 ifFalse:8).
! !

!EditTextView methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    cursorFgColor notNil ifTrue:[cursorFgColor := cursorFgColor onDevice:device].
    cursorBgColor notNil ifTrue:[cursorBgColor := cursorBgColor onDevice:device].
    cursorNoFocusFgColor notNil ifTrue:[cursorNoFocusFgColor := cursorNoFocusFgColor onDevice:device].

    "Created: 14.1.1997 / 00:15:24 / cg"
    "Modified: 18.2.1997 / 15:02:46 / cg"
!

initEvents
    "enable enter/leave events in addition"

    super initEvents.
    self enableEnterLeaveEvents
!

initStyle
    "initialize style specific stuff"

    super initStyle.
    "/ lineSpacing := 2.       "/ for underwave - also looks better
    lockUpdates := false.

    cursorFgColor := DefaultCursorForegroundColor.
    cursorFgColor isNil ifTrue:[cursorFgColor := bgColor].
    cursorBgColor := DefaultCursorBackgroundColor.
    cursorBgColor isNil ifTrue:[cursorBgColor := fgColor].
    cursorType isNil ifTrue:[cursorType := DefaultCursorType].
    cursorTypeNoFocus isNil ifTrue:[
        cursorTypeNoFocus := cursorType.
        DefaultCursorTypeNoFocus notNil ifTrue:[
            cursorTypeNoFocus := DefaultCursorTypeNoFocus.
        ]
    ].
    cursorNoFocusFgColor := DefaultCursorNoFocusForegroundColor.
    cursorNoFocusFgColor isNil ifTrue:[
        cursorType ~~ #block ifTrue:[
            cursorNoFocusFgColor := cursorBgColor
        ] ifFalse:[
            cursorNoFocusFgColor := cursorFgColor
        ]
    ].

    "Modified: / 15.12.1999 / 22:27:45 / cg"
!

initialize
    "initialize a new EditTextView;
     setup some instance variables"

    super initialize.

    self level:-1.
    readOnly := false.
    fixedSize := false.
    exceptionBlock := [:errorText | ].
    cursorShown := prevCursorState := true.
    cursorLine := 1.
    cursorVisibleLine := 1.
    cursorCol := 1.
    cursorLineHolder := ValueHolder with:1.
    cursorColHolder := ValueHolder with:1.
    modifiedChannel := ValueHolder with:false.
    acceptChannel := ValueHolder with:false.
    acceptChannel addDependent:self.
    showMatchingParenthesis := false.
    hasKeyboardFocus := false.
    tabMeansNextField := false.
    "/ autoIndent := UserPreferences current autoIndentInCodeView.
    autoIndent := false.
    editMode := ValueHolder with:EditMode insertMode.
    learnMode := ValueHolder with:false.
    cursorMovementWhenUpdating := #beginOfText.
    lastReplacementInfo := LastReplacementInfo new.

    "/ enable drop by default
    self allowDrop:true.        "/ readOnly tested in #canDrop:

    undoSupport := UndoSupport for:self.
    codeAspectHolder := ValueHolder with:nil.

    "Modified: / 27-09-2013 / 09:41:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeCompletionSupport
    |supportClass|

    completionSupport isNil ifTrue:[
        (supportClass := self completionSupportClass) notNil ifTrue:[
            completionSupport := supportClass for:self.            
        ].
    ].

    "Created: / 26-09-2013 / 17:51:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    completionSupport notNil ifTrue:[
        completionSupport release
    ].
    super release
! !

!EditTextView methodsFor:'macros'!

executeLearnedKeyboardMacro
    "replay the characters as learned previously"

    (self learnMode not and:[learnedMacro size > 0]) ifTrue:[
        ExecutingMacroQuery 
            answer:true
            do:[
                learnedMacro do:[:event |
                            WindowGroup lastEventQuerySignal answer:event
                            do:[
                                self
                                    dispatchEvent:event
                                    withFocusOn:nil
                                    delegate:false
                            ]
                ]
            ].
    ] ifFalse:[
        self flash:'no macro'.
    ].
!

learnMode
    "true if currently learning"

    ^ (learnMode value ? false).
!

learnMode:aBoolean
    "toggle the learn-mode"

    |fg bg|

    self learnModeHolder value:aBoolean.

    aBoolean ifTrue:[
        learnedMacro := OrderedCollection new.
        fg := self whiteColor.
        bg := self blackColor.
    ] ifFalse:[
        cursorFgColor := fg := (DefaultCursorForegroundColor ? bgColor).
        cursorBgColor := bg := (DefaultCursorBackgroundColor ? fgColor).
    ].
    self cursorForegroundColor:fg backgroundColor:bg.
!

learnModeHolder
    "a holder returning true, if in learn mode"

    learnMode isNil ifTrue:[
        learnMode := ValueHolder with:false
    ].
    ^ learnMode
!

rememberLearnedMacroAs: nameString
    Macros isNil ifTrue:[
        Macros := Dictionary new.
    ].
    Macros at:nameString put:learnedMacro
!

toggleLearnMode
    "toggle the learn-mode"

    self learnMode:(self learnMode not).
! !

!EditTextView methodsFor:'menu & menu actions'!

babelFishTranslate:fromToModeString
    "translate the selected text and paste it after the selection.
     This is now obsolete, as that web service no longer exists (sigh)"

    |original translated|

    original := self selectionAsString.
    original size == 0 ifTrue:[^ self].

    self withWaitCursorDo:[
        (HostNameLookupError , SOAP::SoapImplError) handle:[:ex |
            Dialog warn:('Translation failed - WEB Service error:\\%1.' bindWith:ex description allBold) withCRs
        ] do:[
            translated := SOAP::BabelFishClient new 
                            translate:original mode:fromToModeString.
        ]
    ].

    "/ v pasteOrReplace:translated
    self cursorLine:(self selectionEndLine) col:(self selectionEndCol + 1).
    self unselect.
    self 
        undoablePaste:translated 
        info:'Translate'

    "Modified: / 28-07-2007 / 13:27:21 / cg"
!

compareWithClipboard
    "compare the selection against the clipboard contents"

    |t1 t2|

    t2 := self getClipboardText.
    t2 isEmptyOrNil ifTrue:[
        Dialog information:'Clipboard is empty.'.
        ^ self.
    ].

    self hasSelection ifTrue:[
        t1 := self selectionAsString.
    ] ifFalse:[
        t1 := self contents asString
    ].
    t1 := t1 string.

    t1 = t2 ifTrue:[
        Dialog information:'Strings are equal.'.
        ^ self.
    ].
    DiffTextView
        openOn:t1 label:'Editor'
        and:t2 label:'Clipboard'
!

compareWithFile
    "compare the selection or the whole text against the contents of a file"

    |fn t1 t2|

    fn := Dialog requestFileName:'Compare against file:' default:defaultFileNameForFileDialog.
    fn isEmptyOrNil ifTrue:[^ self].

    t2 := fn asFilename contentsOfEntireFile.
    t2 isEmptyOrNil ifTrue:[
        Dialog information:'File is empty.'.
        ^ self.
    ].

    self hasSelection ifTrue:[
        t1 := self selectionAsString.
    ] ifFalse:[
        t1 := self contents asString
    ].
    t1 := t1 string.

    t1 = t2 ifTrue:[
        Dialog information:'Same contents.'.
        ^ self.
    ].
    DiffTextView
        openOn:t1 label:'Editor'
        and:t2 label:'File'
!

copySelection
    "copy contents into smalltalk copybuffer.
     Redefined to move the (currently hidden cursor) to the selection's end"

    self hasSelection ifTrue:[
        self setCursorLine:selectionEndLine col:selectionEndCol+1
    ].
    super copySelection.

    "Created: / 30-04-2016 / 21:07:10 / cg"
!

cut
    "cut selection into copybuffer"

    self deleteCopyToClipboard:true
!

defaultForGotoLine
    "return a default value to show in the gotoLine box"

    cursorLine notNil ifTrue:[
        ^ cursorLine
    ].
    ^ super defaultForGotoLine
!

deleteCopyToClipboard:toClipboard
    "cut selection into copybuffer"

    |line col history sel |

    (self checkModificationsAllowed) ifFalse:[
        self flashReadOnly.
        ^ self
    ].

    sel := self selection.
    sel notNil ifTrue:[
        self setLastStringToReplace: sel.

        line := selectionStartLine.
        col := selectionStartCol.

        toClipboard ifTrue:[
            "
             remember in CopyBuffer
            "
            self setClipboardText:sel. "/ lastString.
        ].

        "
         append to DeleteHistory (if there is one)
        "
        history := Smalltalk at:#DeleteHistory.
        history notNil ifTrue:[
            history addAll:(sel asStringCollection).
            history size > 1000 ifTrue:[
                history := history copyFrom:(history size - 1000)
            ].
        ].

        "
         now, delete it
        "
        self 
            undoableDo:[self deleteSelection] 
            info:'Delete'.
        lastReplacementInfo lastReplacement: nil
    ] ifFalse:[
        "
         a cut without selection will search&cut again
        "
        self undoableDo:[
            self again
        ]
    ]

    "Modified: / 5.4.1998 / 16:51:53 / cg"
!

editMenu
    "return the view's middleButtonMenu"

    <resource: #keyboard (#Again #AgainForAll #Copy #Cut #Paste #Accept 
                          #Find #GotoLine #SaveAs #Print
                          #PasteFromHistory #Join #Wrap #Undo #Redo 
                          #ToggleAutoIndent #ToggleInsertMode 
                          #LearnKeyboardMacro #ExecuteKeyboardMacro )>
    <resource: #programMenu>

    |items m sub translateItems sortItems miscItems toolItems subSub toolSub
     transSub sortSub what undoIdx redoIdx sensor main mainItems|

    items := #(
                    ('Redo'             redo           Redo        )
                    ('Again (for All)'  multipleAgain  AgainForAll )
                    ('-'                                        )
                    ('Search...'        search         Find     )
                    ('Goto Line...'     gotoLine       GotoLine )
                    ('-'                                        )
                    ('Tools'            tools                   )
                    ('Font...'           changeFont             )
                    ('Insert Unicode...' insertUnicode )
            ).
    CharacterSetView notNil ifTrue:[
        items := items ,
                    #(
                        ('Special Characters...'    specialCharacters  OpenSpecialCharacterWindow )
                    ).
    ].
    items := items , #(
                    ('-'                                        )
                    ('Save As...'       save           SaveAs   )
                    ('Print'            doPrint        Print    )
                    ('='                                        )
                    ('Misc'             misc           ShiftCtrl) ).

    miscItems := #(
                    ('AutoIndent \c'    autoIndent:                  ToggleAutoIndent )
                    ('InsertMode \c'    insertMode:                  ToggleInsertMode )
                    ('-'                                        )
                    ('Paste Previous...'   pasteOrReplaceFromHistory PasteFromHistory )
                    ('Join Lines'       joinLines                    Join )
                    ('Wrap Lines...'    wrapLines                    Wrap )
                    ('-'                                        )
                    ('Learn Macro'      learnMode:                   LearnKeyboardMacro)
                    ('Execute Macro'    executeLearnedKeyboardMacro  ExecuteKeyboardMacro )
                    ('-'                                        )
                    ('Insert File...'           insertFile          )
                    ('Insert URL Contents...'   insertURL           )
                    ('Insert new UUID'      insertUUID          )
                    ('Insert Date && Time'  insertDateAndTime   )
                    ('-'                                        )
                    ('Insert File as String Literal...' insertFileAsStringLiteral  )
                    ('Paste as String Literal'          pasteAsStringLiteral       )
                ).
"/    CharacterSetView notNil ifTrue:[
"/        miscItems := miscItems ,
"/                    #(
"/                        ('-'                                        )
"/                        ('Special Characters...'    specialCharacters  OpenSpecialCharacterWindow )
"/                        ('Font...'                  changeFont              )
"/                    ).
"/    ] ifFalse:[
"/        miscItems := miscItems ,
"/                #(
"/                    ('Font...'                  changeFont              )
"/"/                    ('Encoding...'      changeEncoding          )
"/                ).
"/    ]. 

    translateItems := #(
                    ('English -> German'      (babelFishTranslate: 'en_de')   )
                    ('English -> French'      (babelFishTranslate: 'en_fr')   )
                    ('English -> Italian'     (babelFishTranslate: 'en_it')   )
                    ('English -> Spanish'     (babelFishTranslate: 'en_es')   )
                    ('English -> Portuguese'  (babelFishTranslate: 'en_pt')   )
                    ('-'                                        )
                    ('German -> English'      (babelFishTranslate: 'de_en')   )
                    ('French -> English'      (babelFishTranslate: 'fr_en')   )
                    ('Italian -> English'     (babelFishTranslate: 'it_en')   )
                    ('Spanish -> English'     (babelFishTranslate: 'es_en')   )
                    ('Portuguese -> English'  (babelFishTranslate: 'pt_en')   )
              ).

    sortItems := #(
                    ('Lines'                            (sortSelection:ignoreCase: #lines false)        )
                    ('Lines by First Word'              (sortSelection:ignoreCase: #linesByFirstWord false)     )
                    ('Lines by n''th Word'              (sortSelection:ignoreCase: #linesByNthWord false)       )
                    ('Lines by n''th Number'            (sortSelection:ignoreCase: #linesByNthNumber false)     )
                    ('Lines by n''th Hex Number'        (sortSelection:ignoreCase: #linesByNthHexNumber false)     )
                    ('Words'                            (sortSelection:ignoreCase: #words false)        )
                    ('-'                                                      )
                    ('Lines (ignore case)'               (sortSelection:ignoreCase: #lines true)         )
                    ('Lines by First Word (ignore case)' (sortSelection:ignoreCase: #linesByFirstWord true)      )
                    ('Lines by n''th Word (ignore case)' (sortSelection:ignoreCase: #linesByNthWord true)        )
                    ('Words (ignore case)'               (sortSelection:ignoreCase: #words true)         )
                    ('-'                                                      )
                    ('By Line Length'                    (sortSelection:ignoreCase: #linesByLength nil)         )
                    ('Reverse'                           (sortSelection:ignoreCase: #reverse       nil)         )
              ).

    toolItems := #(
                    ('Indent'                      indent                     )
                    ('Toggle Case'      convertSelectionToLowercaseOrUppercaseOrUppercaseFirst   ConvertSelectionToLowercaseOrUppercaseOrUppercaseFirst)
                    ('Sort'                        sort                       )
                    ('Split...'                    splitLinesAtCharacterOrString )
                    ('-'                                                      )
                    ('Google Spell Check'          googleSpellingSuggestion   )
                    ('Builtin Spell Check'         internalSpellingSuggestion   )
                    ('Translate'                   babelFishTranslate         )
                    ('Compare with Clipboard...'   compareWithClipboard       )
                    ('Compare with File...'        compareWithFile            )
              ).

    Smalltalk isStandAloneApp ifFalse:[
        toolItems := toolItems , #(
                        ('-'                                                      )
                        ('Open FileBrowser on It'      openFileBrowserOnIt        )
                        ('Open Workspace with It'      openWorkspaceWithIt        )
                        ('Inspect Selected String'     inspectSelectedString      )
                  ).
    ].

    sub := PopUpMenu itemList:items resources:resources performer:model.
    sub receiver:self.

    toolSub := PopUpMenu itemList:toolItems resources:resources performer:model.
    toolSub receiver:self.
    sub subMenuAt:#tools put:toolSub.

    transSub := PopUpMenu itemList:translateItems resources:resources performer:model.
    transSub receiver:self.
    toolSub subMenuAt:#babelFishTranslate put:transSub.

    sortSub := PopUpMenu itemList:sortItems resources:resources performer:model.
    sortSub receiver:self.
    toolSub subMenuAt:#sort put:sortSub.

    subSub := PopUpMenu itemList:miscItems resources:resources performer:model.
    subSub receiver:self.
    subSub checkToggleAt:#autoIndent: put:autoIndent.
    subSub checkToggleAt:#insertMode: put:(self isInInsertMode).
    subSub checkToggleAt:#learnMode: put:(self learnModeHolder value).

    sub subMenuAt:#misc put:subSub.

    mainItems := #(
                    ('Undo'    undo             Undo   )
                    ('Again'   again            Again  )
                    ('-'                               )
                    ('Cut'     cut              Cut    )
                    ('Copy'    copySelection    Copy   )
                    ('Paste'   pasteOrReplace   Paste  )
                    ('-'                               )
                    ('Accept'  accept           Accept )
                    ('='                               )
                    ('More'    others           Ctrl   )
              ).
    main := PopUpMenu itemList:mainItems resources:resources.
    main subMenuAt:#others put:sub.

    sensor := self sensor.
    (sensor notNil and:[sensor ctrlDown]) ifTrue:[
       sensor shiftDown ifTrue:[
            m := subSub
        ] ifFalse:[
            m := sub
        ]
    ] ifFalse:[
        m := main
    ].

    "/ the 'Smalltalk at:' code is here to
    "/ avoid making the SOAP package a prerequisite for this package (libwidg)
    (Smalltalk at:#'SOAP::GoogleClient') isNil ifTrue:[
        "/ GoogleClient new spellingSuggestionOf: 'Smmalltlaak and Soaap'.
        m disable:#googleSpellingSuggestion
    ].
    (Smalltalk at:#'RBSpellChecker') isNil ifTrue:[
        m disable:#internalSpellingSuggestion
    ].

    HTTPInterface isNil ifTrue:[
        m disableAll:#(insertURL)
    ].

    self isReadOnly ifTrue:[
        m disableAll:#(accept undo again multipleAgain redo
                       paste pasteOrReplace pasteOrReplaceFromHistory
                       cut indent autoIndent: insertMode:
                       insertFile insertFileAsStringLiteral insertURL
                       babelFishTranslate googleSpellingSuggestion sort
                       convertSelectionToLowercaseOrUppercaseOrUppercaseFirst 
                       joinLines wrapLines insertUUID insertDateAndTime pasteAsStringLiteral
                       insertUnicode specialCharacters)
    ].
    self hasSelectionForCopy ifFalse:[
        m disable:#copySelection.
    ].
    self hasSelection ifFalse:[
        m disableAll:#(cut googleSpellingSuggestion babelFishTranslate openFileBrowserOnIt 
                       openWorkspaceWithIt sort indent splitLinesAtCharacterOrString inspectSelectedString).
    ] ifTrue:[
        (Error handle:[:ex |
            ex return:false
        ] do:[
            |fn|
            fn := self selectionAsString.
            fn asFilename exists or:[ fn withoutSeparators withoutQuotes asFilename exists ]
        ]) ifFalse:[
            m disableAll:#(openFileBrowserOnIt).
        ]
    ].
    self hasUndoAction ifFalse:[
        m disable:#undo.
    ] ifTrue:[
        what := undoSupport undoActionInfo.
        what notNil ifTrue:[
            undoIdx := m indexOf:#undo.
            m labelAt:undoIdx put:(resources string:'Undo (%1)' with:what).
        ]
    ].
    self hasRedoAction ifFalse:[
        sub disable:#redo.
    ] ifTrue:[
        what := undoSupport redoActionInfo.
        what notNil ifTrue:[
            redoIdx := sub indexOf:#redo.
            sub labelAt:redoIdx put:(resources string:'Redo (%1)' with:what).
        ]
    ].
    self canAccept ifFalse:[
        m disable:#accept
    ].
    ^ m.

    "Modified: / 01-03-2012 / 19:56:58 / cg"
!

getTextSelectionFromHistory
    |sel list box history|

    history := device getCopyBufferHistory copy.
    list := history collect:[:entry |
                |text shown|

                text := entry asString string asCollectionOfLines.
                shown := text detect:[:line| line notEmptyOrNil] ifNone:['      '].
                text size > 1 ifTrue:[
                    shown := shown,(resources string:' ... [%1 lines]' with:text size).
                ].
                shown
            ].

    box := ListSelectionBox
                title:(resources string:'Clipboard History')
                okText:(resources string:'Paste')
                abortText:(resources string:'Cancel')
                list:list
                action:[:idx | idx notNil ifTrue:[sel := history at:idx]].
    box label:(resources string:'Select Previous Copybuffer String').
    box useIndex:true.
    box show.
    ^ sel.

    "Modified: / 25-08-2010 / 22:02:14 / cg"
!

getTextSelectionOrTextSelectionFromHistory

    self sensor shiftDown ifTrue:[
        ^ self getTextSelectionFromHistory
    ].

    "/ return either the (xterm-) selection or the clipBoard depending on
    "/ the Ctrl-Key state.

    "/ ouch - this used to be ok for ALT-c / ALT-v,
    "/ but no longer works with CTRL-c / CTRL-v.
    ^ self getClipboardText:#clipboard

"/    ^ self
"/        getClipboardText:(self sensor ctrlDown
"/                            ifTrue:[#selection]
"/                            ifFalse:[#clipboard])

    "Modified: / 13-07-2011 / 14:55:58 / cg"
!

googleSpellingSuggestion
    "insert the google-spelling suggestion for the selected text.
     Requires that the SOAP stuff is loaded and working."

    |text suggestion|

    self withWaitCursorDo:[
        text := self selection asString string withoutSeparators.
        text size == 0 ifTrue:[^ self].

        "/ the 'Smalltalk at:' code is here to
        "/ avoid making the SOAP package a prerequisite for this package (libwidg)
        (Smalltalk at:#'SOAP::SoapImplError') handle:[:ex |
            Dialog warn:('Spelling correction failed - WEB Service error:\\%1.' bindWith:ex description allBold) withCRs.
            ^ self.
        ] do:[
            suggestion := (Smalltalk at:#'SOAP::GoogleClient') new spellingSuggestionOf:text.
        ].
        suggestion size == 0 ifTrue:[
            self information:('No spelling suggestion from Google for: ' , text).
            Transcript showCR:('No spelling suggestion from Google for: ' , text).
            ^ self.
        ].
    ].
    self 
        undoablePaste:suggestion 
        info:'Spelling Suggestion'.

    "Modified: / 28-07-2007 / 13:25:10 / cg"
!

insertDateAndTime
    "insert the curent date and time string"

    typeOfSelection := nil.
    self
        undoableDo:[ self pasteOrReplace:(Timestamp now printStringRFC1123Format)]
        info:'Paste Date and Time'
!

insertFile
    "insert contents of a file
     - ask user for filename using a fileSelectionBox."

    self insertFileAsStringLiteral:false
!

insertFileAsStringLiteral
    "insert a file's contents as a string literal.
     Almost the same as the insert file, but single-quotes are doubled,
     to make it a legal string literal"

    self insertFileAsStringLiteral:true
!

insertFileAsStringLiteral:asStringLiteral
    "insert contents of a file; either as-is or as a string literal.
     - ask user for filename using a fileSelectionBox."

    |sel selFn file text ok initial|

    ((sel := self selectionAsString) notEmptyOrNil
    and:[ (selFn := sel asFilename) exists
    and:[ selFn isRegularFile ]])
    ifTrue:[
        initial := selFn pathName.
    ].

    [
        |why|

        file := Dialog
            requestFileName:(resources string:'Insert Contents Of:')
            default:initial
            ok:(resources string:'Insert')
            abort:(resources string:'Cancel')
            pattern:nil
            fromDirectory:directoryForFileDialog.
        file isNil ifTrue:[
            "cancel"
            ^ self.
        ].
        file := file asFilename.
        directoryForFileDialog := file.

        ok := file isReadable and:[file isDirectory not].
        ok ifFalse:[
            file isReadable ifFalse:[
                why := '%1 is unreadable.\\Please try again.'
            ] ifTrue:[
                why := '%1 is a directory.\\Please try again.'
            ].
            Dialog warn:(resources stringWithCRs:why with:file pathName).
        ].
    ] doUntil:[ok].

    text := file contentsAsString.
    self
        undoableDo:[ self paste:(asStringLiteral ifTrue:[text storeString] ifFalse:[text]) ]
        info:'Paste File'

    "Modified: / 28-07-2007 / 13:23:32 / cg"
!

insertURL
    "insert contents of a URL
     - ask user for URL using a dialog."

    self insertURLAsStringLiteral:false
!

insertURLAsStringLiteral:asStringLiteral
    "insert contents of a file; either as-is or as a string literal.
     - ask user for filename using a fileSelectionBox."

    |sel url text response initial|

    (sel := self selectionAsString) notEmptyOrNil
    ifTrue:[
        initial := sel.
    ].

    url := Dialog
        request:(resources string:'Insert Contents of URL:')
        initialAnswer:initial
        okLabel:(resources string:'Insert')
        title:(resources string:'URL').
    url isNil ifTrue:[
        "cancel"
        ^ self.
    ].
    response := HTTPInterface get:url.
    response isErrorResponse ifTrue:[
        Dialog warn:(resources string:'Could not fetch the document: %1' with:url).
        ^ self.
    ].
    text := response data asString.

    self
        undoableDo:[ 
            self paste:(asStringLiteral ifTrue:[text storeString] ifFalse:[text]) 
        ]
        info:'Insert Contents of URL'
!

insertUUID
    "insert a new UUID's string"

    typeOfSelection := nil.
    self
        undoableDo:[ self pasteOrReplace:(UUID genUUID printString)]
        info:'Paste New UUID'

    "Created: / 28-07-2007 / 13:01:16 / cg"
!

insertUnicode
    "open a Dialog requesting an integer value and insert it as unicode character"

    |unicodePoint unicodeChar unicodeString|

    unicodeString := Dialog request:(resources string:'Enter Unicode (U+01FF or Decimal Number):').
    unicodeString size < 2 ifTrue:[
        ^ self.
    ].
    (unicodeString second = $+ and:['Uu' includes:unicodeString first]) ifTrue:[
        unicodePoint := Integer readFrom:(unicodeString copyFrom:3) radix:16 onError:[^ self].
    ] ifFalse:[
        unicodePoint := Integer readFrom:unicodeString onError:[^ self].
    ].
        
    unicodeChar := Character value:unicodePoint.
    self keyPress:unicodeChar x:0 y:0.
    self keyRelease:unicodeChar x:0 y:0.
!

inspectSelectedString
    "inspect the selected text"

    self selectionAsString inspect.
!

internalSpellingSuggestion
    "insert the internal-spelling suggestion for the selected text.
     Requires that the RefactoryBrowser/line/spelCheck stuff is loaded."

    |text suggestions best|

    self withWaitCursorDo:[
        text := self selection asString string withoutSeparators.
        text size == 0 ifTrue:[^ self].

        suggestions := RBSpellChecker default bestMatchesFor:text.
        suggestions size == 0 ifTrue:[
            self information:('No spelling suggestion from builtin checker for: ' , text).
            Transcript showCR:('No spelling suggestion from builtin checker for: ' , text).
            ^ self.
        ].
        Transcript showCR:suggestions.
        best := suggestions first.
    ].
    self 
        undoablePaste:best 
        info:'Spelling Suggestion'.
!

openFileBrowserOnFileNamed:fileNameString
    "open a fileBrowser on the given fileNameString"

    |fn|

    fn := fileNameString asFilename.
    fn exists ifFalse:[
        fn := fileNameString withoutSeparators withoutQuotes asFilename.
        fn exists ifFalse:[
            ^ self warn:(resources 
                            string:'Sorry - file "%1" was not found in directory "%2"' 
                            with:fn baseName allBold
                            with:fn directory baseName allBold).
        ].
    ].
    UserPreferences fileBrowserClass openOn:fn

    "Modified: / 06-09-2012 / 14:47:22 / cg"
!

openFileBrowserOnIt
    "open a fileBrowser on the selected fileName"

    |fileNameString|

    fileNameString := self selectionAsString.
    self openFileBrowserOnFileNamed:fileNameString

    "Modified: / 06-09-2012 / 14:47:22 / cg"
!

openWorkspaceWithIt
    "open a workspace containing the selected text"

    |text|

    text := self selectionAsString.
    WorkspaceApplication openWith:text selected:true

    "Created: / 26-05-2007 / 06:05:22 / cg"
!

paste
    "paste the copybuffer; if there is a selection, unselect first.
     Then paste at cursor position."

    self checkModificationsAllowed ifTrue:[
        self withSelfAndTextForPasteDo:[:me :text |
            me unselect.
            me undoablePaste:text
        ]
    ]
!

paste:someText
    "paste someText at cursor"

    self paste:someText withCR:false
!

paste:someText withCR:withCR
    "paste someText at cursor"

    |s nLines startLine startCol l1 l2 c1 c2 codingErrorReported|

    self checkModificationsAllowed ifFalse:[^ self].
    someText isNil ifTrue:[^ self].

    s := someText.
    codingErrorReported := false.
    CharacterEncoderError handle:[:ex |
        |code msg|

        code := ex parameter.
        codingErrorReported ifFalse:[
            msg := 'Cannot represent pasted string in this Views encoding (',gc characterEncoding,').'.
            code notNil ifTrue:[
                msg := msg , '\\Reason: No representation for ' , (code radixPrintStringRadix:16).
            ].
            Dialog warn:(resources stringWithCRs:msg).
            codingErrorReported := true.
        ].
        ex proceedWith:ex defaultValue
    ] do:[
        s isString ifTrue:[
            s encoding ~~ gc characterEncoding ifTrue:[
                s := s encodeFrom:(s encoding) into:gc characterEncoding.
            ].

            s := s asStringCollection.
            (someText endsWith:Character cr) ifTrue:[
                "/ s := s copyWith:nil.
                s := s copyWith:'' "/ an empty line at the end

            ]
        ] ifFalse:[
            s isStringCollection ifTrue:[
                s := s encodeFrom:(s encoding) into:gc characterEncoding.
            ] ifFalse:[
                (self
                    confirm:(resources
                        stringWithCRs:'Selection (%1) is not convertable to Text.\\Paste storeString ?'
                        with:s class name)) ifFalse:[^ self].
                s := StringCollection with:s storeString .
                "/ ^ self
            ].
        ].
    ].

    (nLines := s size) == 0 ifTrue:[^ self].
    (nLines == 1 and:[(s at:1) size == 0]) ifTrue:[^ self].

    typeOfSelection := #paste.

    startLine := l1 := cursorLine.
    startCol := c1 := cursorCol.

    "do not autoindent here. 
     It does make things very ugly, in the inspector 
     (try inspecting a multiline string)..."
    self withAutoIndent:false do:[
        "do not expand tabs into spaces here -
         they get expanded in basicWithoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr.
         Some Subviews want to paste with unexpanded tabs!!"

        self insertLines:s withCR:withCR.
    ].
    l2 := cursorLine.
    c2 := (cursorCol - 1).
    self selectFromLine:l1 col:c1 toLine:l2 col:c2.
    typeOfSelection := #paste. "/ sigh - cleared by #selectFromLine:
    "/ For Claus to support paste-cursordown-paste :-)
    "/ Move cursor the the beggining of the selection so subsequent
    "/ cursor move will start there.
    self setCursorLine: l1.
    self setCursorCol: c1.

    "Modified: / 14-02-1996 / 11:14:14 / stefan"
    "Modified: / 25-01-2012 / 00:31:30 / cg"
    "Modified: / 30-08-2013 / 00:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pasteAsStringLiteral
    "insert clipboard string as a string literal.
     Almost the same as a normal paste, but single-quotes are doubled,
     to make it a legal string literal"

    typeOfSelection := nil.
    self
        undoableDo:[ self pasteOrReplace:(self getClipboardText asString string storeString) ]
        info:'Paste as String Literal'
!

pasteOrReplace
    "paste the copybuffer; if there is a selection, replace it.
     otherwise paste at cursor position.
     Replace is not done for selections which were created by a paste,
     to allow multiple paste operations in a row."

    self withSelfAndTextForPasteDo:[:me :text | me pasteOrReplace:text]
!

pasteOrReplace:someText
    "paste someText; if there is a selection, replace it.
     otherwise paste at cursor position. Replace is not done
     for originating by a paste, to allow multiple
     paste."

    self checkModificationsAllowed ifFalse:[^ self].

    self undoableDo:[
        ((self hasSelection == true) and:[typeOfSelection ~~ #paste]) ifTrue:[
            self replace:someText
        ] ifFalse:[
            self paste:someText.
        ]
    ] info:'Paste/Replace'.

    "Modified: / 30.1.2000 / 02:33:00 / cg"
!

pasteOrReplaceByKeyPress
    "paste a previous item from the copybuffer history.
     (i.e. repaste some previously deleted or copied text)"

    |text|

    self checkModificationsAllowed ifFalse:[
        self flashReadOnly.
        ^ self
    ].
    text := self getClipboardText:#clipboard.
    text notNil ifTrue:[
        self pasteOrReplace:text
    ]
!

pasteOrReplaceFromHistory
    "paste a previous item from the copybuffer history.
     (i.e. repaste some previously deleted or copied text)"

    |text|

    self checkModificationsAllowed ifFalse:[
        self flashReadOnly.
        ^ self
    ].
    text := self getTextSelectionFromHistory.
    text notNil ifTrue:[
        self pasteOrReplace:text
    ]
!

replace
    "replace the selection by the contents of the copybuffer"

    self hasSelection ifFalse:[^ self].
    self checkModificationsAllowed ifFalse:[^ self].

    self withSelfAndTextForPasteDo:[:me :text |
        me undoableDo:[ me replace:text ]
        info:'Replace'
    ]
!

replace:someText
    "replace the selection by someText"

    |selected selectedString
     selStartLine selStartCol selEndLine selEndCol|

    self checkModificationsAllowed ifFalse:[^ self].

    self undoableDo:[
        selected := self selection.
        selected isNil ifTrue:[
            ^ self paste:someText
        ].

        self deleteSelection.

        "take care, if we replace a selection without space by a word selected
         with one - in this case we usually do not want the space.
         But, if we replace a word-selected selection by something without a
         space, we DO want the space added."

        selected size == 1 ifTrue:[
            selectedString := selected at:1.
        ].

        someText size == 1 ifTrue:[
            |cutOffSpace addSpace replacement replacementString|

            cutOffSpace := false.
            addSpace := false.
            replacement := someText copyFrom:1.

            selectedString notNil ifTrue:[
                ((selectedString startsWith:' ') or:[selectedString endsWith:' ']) ifFalse:[
                   "selection has no space"

                    ((selectStyle == #wordleft) or:[selectStyle == #wordRight]) ifTrue:[
                        cutOffSpace := true
                    ]
                ] ifTrue:[
                    addSpace := true
                ]
            ].
            replacementString := replacement at:1.
            cutOffSpace ifTrue:[
                (replacementString startsWith:' ') ifTrue:[
                    replacementString := replacementString withoutSpaces
                ].
            ] ifFalse:[
                selectStyle == #wordLeft ifTrue:[
                    "want a space at left"
                    (replacementString startsWith:' ') ifFalse:[
                        replacementString := replacementString withoutSpaces.
                        replacementString := ' ' , replacementString
                    ]
                ].
                selectStyle == #wordRight ifTrue:[
                    "want a space at right"

                    (replacementString endsWith:' ') ifFalse:[
                        replacementString := replacementString withoutSpaces.
                        replacementString := replacementString , ' '
                    ]
                ].
            ].
            replacement at:1 put: replacementString.
            self paste:replacement.
        ] ifFalse:[
            self paste:someText
        ].
        self setLastStringToReplace: selectedString.

        lastReplacementInfo lastReplacement: someText.

        selStartLine := selectionStartLine.
        selStartCol := self selectionStartCol.
        selEndLine := selectionEndLine.
        selEndCol := self selectionEndCol.
    ]
    info:'Replace'

    "Modified: / 14.2.1996 / 10:37:02 / stefan"
    "Modified: / 5.4.1998 / 16:55:28 / cg"
!

searchReplace
    "search for a string - show a box to enter searchpattern
     replace for the found searchpattern or replace all searchpattern found to a new pattern - show  a box to enter replacepattern
     - currently no regular expressions are handled."

    |searchBox patternHolder replacePatternHolder caseHolder flag ign initialString bindings bldr search modal replace action|

    modal := false "(UserPreferences current searchDialogIsModal)".
    lastSearchDirection := #forward.
    ign := lastSearchIgnoredCase ? LastSearchIgnoredCase ? true.
    caseHolder := ValueHolder with:ign.
    patternHolder := ValueHolder with:''.
    replacePatternHolder := ValueHolder with:''.
    lastSearchPattern notNil ifTrue:[
        initialString := lastSearchPattern
    ].
    self hasSelectionWithinSingleLine ifTrue:[
        initialString := self selectionAsString
    ].
    initialString isNil ifTrue:[
        LastSearchPatterns size > 0 ifTrue:[
            initialString := LastSearchPatterns first
        ]
    ].
    initialString notNil ifTrue:[
        patternHolder value:initialString.
        replacePatternHolder value:initialString.
    ].
    flag := true.
    search := [:fwd |
            self
                search:patternHolder value
                ignoreCase:caseHolder value
                forward:fwd.
        ].
    replace := [:all |
            self
                replace:patternHolder value
                by:replacePatternHolder value
                all:all
                ignoreCase:caseHolder value
        ].
    bindings := IdentityDictionary new.
    bindings at:#searchPattern put:patternHolder.
    bindings at:#replacePattern put:replacePatternHolder.
    modal ifTrue:[
        bindings at:#nextAction
            put:[
                flag := true.
                action := search.
                searchBox doAccept.
            ].
        bindings at:#prevAction
            put:[
                flag := false.
                action := search.
                searchBox doAccept.
            ].
        bindings at:#replaceAction
            put:[
                flag := false.
                action := replace.
                searchBox doAccept.
            ].
        bindings at:#replaceAllAction
            put:[
                flag := true.
                action := replace.
                searchBox doAccept.
            ].
    ] ifFalse:[
        bindings at:#nextAction put:[ search value:true. ].
        bindings at:#prevAction put:[ search value:false. ].
        bindings at:#replaceAction put:[ replace value:false. ].
        bindings at:#replaceAllAction put:[ replace value:true. ].
    ].
    bindings at:#ignoreCase put:caseHolder.
    bindings at:#patternList put:LastSearchPatterns.
    modal ifTrue:[
        searchBox := SimpleDialog new.
    ] ifFalse:[
        searchBox := ApplicationModel new.
        searchBox createBuilder.
    ].
    searchBox resources:(self resources).
    bldr := searchBox builder.
    bldr addBindings:bindings.
    searchBox allButOpenFrom:(self class searchReplaceDialogSpec).
    (bldr componentAt:#nextButton) cursor:(Cursor thumbsUp).
    (bldr componentAt:#prevButton) cursor:(Cursor thumbsUp).
    (bldr componentAt:#cancelButton) cursor:(Cursor thumbsDown).
    modal ifTrue:[
        searchBox openDialog.
        searchBox accepted ifTrue:[
            action value:flag
        ].
    ] ifFalse:[
        (bldr componentAt:#nextButton) isReturnButton:false.
        (bldr componentAt:#cancelButton)
            label:(resources string:'Close');
            action:[ searchBox closeRequest ].

        "/ searchBox masterApplication:self application.

        self topView beMaster.
        (searchBox window)
            beSlave;
            openInGroup:(self windowGroup).

        "/ searchBox window open.

        searchBox window assignKeyboardFocusToFirstKeyboardConsumer.
    ]

    "Modified: / 11-07-2006 / 11:20:06 / fm"
!

showDeleted
    "open a readonly editor on all deleted text"

    |v|

    v := EditTextView openWith:(Smalltalk at:#DeleteHistory).
    v readOnly:true.
    v topView label:'deleted text'.
!

sort:how ignoreCase:ignoreCase fromLine:start toLine:end
    "sort/reorder the selected lines.
     how:
        #lines
        #linesByFirstWord
        #linesByNthWord
        #linesByNthNumber
        #linesByNthHexNumber
        #words
        #linesByLength
        #reverse
    "

    |lines extractor innerExtractor fetcher operation lineWise nStr n s words|

    lineWise := true.

    how == #reverse ifTrue:[
        operation := [:lines | lines reverse].
    ] ifFalse:[
        operation := [:linesOrWords |
                        linesOrWords sort:[:item1 :item2 | (fetcher value:item1) < (fetcher value:item2)]
                     ].

        how == #linesByLength ifTrue:[
            fetcher := [:l | l size].
        ] ifFalse:[
            how == #lines ifTrue:[
                extractor := [:l | l withoutLeadingSeparators].
            ] ifFalse:[ 
                how == #linesByFirstWord ifTrue:[
                    extractor := [:l | ((l asCollectionOfWords select:[:w | w isEmpty or:[w first isLetterOrDigit]]) at:1 ifAbsent:'')].
                ] ifFalse:[ 
                    ((how == #linesByNthWord) or:[ how == #linesByNthNumber  or:[ how == #linesByNthHexNumber]]) ifTrue:[
                        nStr := Dialog request:'Word/Column (1..)' initialAnswer:(LastColumnNumberForSort ? 2).
                        nStr isEmptyOrNil ifTrue:[^ self].
                        n := Integer readFrom:nStr onError:[^ self].
                        LastColumnNumberForSort := n.
                        extractor := [:l | ((l string asCollectionOfWords) at:n ifAbsent:'')].
                        how == #linesByNthNumber ifTrue:[
                            innerExtractor := extractor.
                            extractor := [:l | Integer readFrom:(innerExtractor value:l) onError:0]
                        ] ifFalse:[
                            how == #linesByNthHexNumber ifTrue:[
                                innerExtractor := extractor.
                                extractor := [:l | 
                                    |s|                                 
                                    s := innerExtractor value:l.
                                    (s startsWith:'16r') ifTrue:[
                                        (Integer readSmalltalkSyntaxFrom:s) ? 0
                                    ] ifFalse:[
                                        Integer readFrom:s radix:16 onError:[ 0 ]
                                    ]
                                ]
                            ]
                        ].
                    ] ifFalse:[ 
                        how == #words ifTrue:[
                            lineWise := false.
                            extractor := [:w | w].
                        ] ifFalse:[
                            self error:'unknown sort criteria: ', how printString.
                        ]
                    ]
                ]
            ].
            ignoreCase ifTrue:[
                fetcher := [:l | (extractor value:l) asLowercase].
            ] ifFalse:[
                fetcher := extractor.
            ].
        ].
    ].

    lineWise ifTrue:[
        "process the lines of the selection (aka a collection of lines)"
        start == end ifTrue:[^ self ].
        lines := (start to:end) collect:[:lineNr | (self listAt:lineNr) ? ''].
        lines := operation value:lines.
        (start to:end) with:lines do:[:lineNr :line | self replaceLine:lineNr with:line].
    ] ifFalse:[
        "process the whole selection as a string"
        s := self selectionAsString.
        words := s asCollectionOfWords.
        words := operation value:words.
        s := words asStringCollection asStringWith:Character space.
        self replace:s.
    ].
    self textChanged.

    "Modified: / 31-03-2012 / 10:59:28 / cg"
!

sortSelection:how ignoreCase:ignoreCase
    "sort the selected lines"

    |start end|

    selectionStartLine isNil ifTrue:[^ self].

    start := selectionStartLine.
    end := selectionEndLine.
    (selectionEndCol == 0) ifTrue:[
        end := end - 1
    ].

    self
        undoableDo:[ 
            self sort:how ignoreCase:ignoreCase fromLine:start toLine:end 
        ]
        info:'Sort'

    "Modified (format): / 15-02-2012 / 16:52:53 / cg"
!

specialCharacters
    CharacterSetView
        openAsInputFor:self
        label:'Special Character Input'
        clickLabel:'Click to Insert Character'.
!

splitLinesAtCharacterOrString
    "ask user for the character and split after it"

    |sel in out separator record|

    selectionStartLine isNil ifTrue:[^ self].

    separator := Dialog request:(resources string:'Split selected lines after which separator character or string:').
    separator isEmptyOrNil ifTrue:[^ self].

    sel := self selectionAsString.
    in := sel readStream.
    out := CharacterWriteStream on:''.
    [in atEnd] whileFalse:[
        record := in throughAll:separator.
        out nextPutLine:record.
    ].
    self
        undoableDo:[ 
            self replaceSelectionBy:(out contents).
        ]
        info:'Split Selection'
!

undoablePaste:someText
    self undoablePaste:someText info:nil.

    "Modified: / 28-07-2007 / 13:25:46 / cg"
!

undoablePaste:someText info:infoOrNil
    self
        undoableDo:[
            self paste:someText.
        ]
        info:infoOrNil

    "Created: / 28-07-2007 / 13:25:30 / cg"
!

undoablePasteOrReplace:someText info:infoOrNil
    self
        undoableDo:[
            self pasteOrReplace:someText.
        ]
        info:infoOrNil

    "Created: / 28-07-2007 / 13:26:16 / cg"
!

undoablePasteReplacingAll:someText info:infoOrNil
    self
        undoableDo:[
            self selectAll.
            self pasteOrReplace:someText.
        ]
        info:infoOrNil

    "Created: / 28-07-2007 / 13:25:30 / cg"
!

withSelfAndTextForPasteDo:aBlock
    "common code for paste/replace of the copybuffer"

    |sel|

    self checkModificationsAllowed ifFalse:[
        self flashReadOnly.
        ^ self
    ].

    sel := self getTextSelectionOrTextSelectionFromHistory.
    sel notNil ifTrue:[
        aBlock value:self value:sel.
    ]
! !

!EditTextView methodsFor:'private'!

beep
    "output an audible beep or bell on my screen device"

    UserPreferences current beepInEditor ifTrue:[                
        super beep
    ]
!

checkModificationsAllowed
    "check if the text can be modified (i.e. is not readOnly).
     evaluate the exceptionBlock if not.
     This block should be provided by the application or user of the textView,
     and may show a warnBox or whatever."

    self isReadOnly ifTrue: [
        exceptionBlock isNil ifTrue:[
            ^ false
        ].

        (exceptionBlock value:'Text may not be modified') ~~ true ifTrue:[
            ^ false
        ]
    ].
    ^ true

    "Modified: / 17.6.1998 / 15:51:10 / cg"
!

currentSelectionBgColor
    typeOfSelection == #paste ifTrue:[
        ^ DefaultAlternativeSelectionBackgroundColor ? selectionBgColor
    ].
    "/ hasKeyboardFocus ifFalse:[^ Color lightGrey]. 
    ^ super currentSelectionBgColor

    "
     DefaultAlternativeSelectionBackgroundColor := Color yellow blendWith:Color green
    "
!

currentSelectionFgColor
    typeOfSelection == #paste ifTrue:[
        ^ DefaultAlternativeSelectionForegroundColor ? selectionFgColor
    ].
    ^ super currentSelectionFgColor
!

resetVariablesBeforeNewSearch
    "clear the autosearch action, when the first pattern is searched for"

    super resetVariablesBeforeNewSearch.

    "/ new search invalidates remembered string
    lastStringFromReplaceForNextSearch := nil.

    "Modified (comment): / 07-03-2012 / 23:21:06 / cg"
!

setLastStringToReplace: aString

    "This method will set the information coming from the last replace into the replacementInfo"

    |lastReplaceIgnoredCase|

    "/ The searchAction is mantained until a cut/replace or a search with a user selection is done
    self clearSearchAction.

    lastReplacementInfo lastStringToReplace: aString.
    lastStringFromReplaceForNextSearch := aString.

    "If the replace came after a search, the next replace will have the ignored case from that search action"
    lastReplaceIgnoredCase := (typeOfSelection == #search) 
                                ifTrue: [lastSearchIgnoredCase] 
                                ifFalse: [nil].
    lastReplacementInfo lastReplaceIgnoredCase: lastReplaceIgnoredCase.
!

suppressEmphasisInSelection
    "selection is shown without emphasis"

    ^ true
!

textChanged
    "my text was modified (internally).
     Sent whenever text has been edited (not to confuse with
     contentsChanged, which is triggered when the size has changed, and
     is used to notify scrollers, other views etc.).

     As some authors of this code have been very sloppy in the past
     (not sending contentsChanged, but textChanged),
     we do it here despite what is written above, to ensure that scrollers update correctly."

    self contentsChanged.
    self modified:true.
    dependents notNil ifTrue:[ self changed:#textChanged ].
    contentsWasSaved := false

    "Modified: 14.2.1997 / 16:58:38 / cg"
!

textChangedButNoSizeChange
    "my text was modified (internally).
     Sent whenever text has been edited (not to confuse with
     contentsChanged, which is triggered when the size has changed, and
     is used to notify scrollers, other views etc.)"

    self modified:true.
    contentsWasSaved := false

    "Modified: 14.2.1997 / 16:58:38 / cg"
! !

!EditTextView methodsFor:'queries'!

canAccept
    "true if text can be accepted.
     Used to disable the menu if there is nothing selector or the text is readonly"

    ^ acceptEnabled ~~ false and:[ self isReadOnly not ]

    "Modified: / 06-02-2018 / 15:32:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canCut
    "true if there is a selection possibly to be cut.
     Used to disable the menu if there is nothing selector or the text is readonly"

    self isReadOnly ifTrue:[ ^ false ].
    ^ self hasSelection
!

canDoAgain
    "true if there is a possible repeat last edit operation.
     Used to disable the menu if there is nothing"

    self isReadOnly ifTrue:[ ^ false ].
    ^ lastReplacementInfo lastStringToReplace notNil

    "Modified: / 19-11-2016 / 20:19:02 / cg"
!

currentLine
    "the current line (for relative gotos)"

    ^ cursorLine

    "Created: / 17.5.1998 / 20:07:52 / cg"
!

hasLanguage
    "Returns `true` if the editor has a langiage associated, `false` otherwise.
     Used to disable language-specific menu items items if there's no language."

    ^ self editedLanguage notNil

    "Created: / 06-02-2018 / 15:45:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasLanguageToolbox
    "Returns `true` if the editor has a langiage that has a 'toolbox', `false` otherwise.
     Used to disable language-specific menu items if there's no `toolbox`."

    | lang |

    lang := self editedLanguage.
    ^lang notNil and:[ lang toolbox notNil ]

    "Created: / 06-02-2018 / 20:08:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSearchActionSelection

    ^ typeOfSelection == #searchAction
!

isKeyboardConsumer
    "return true, if the receiver is a keyboard consumer;
     Return true here if not readOnly, redefined from SimpleView."

    ^ self isReadOnly not
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not EditTextSpec)"

    self class == EditTextView ifTrue:[^ TextEditorSpec].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:48:19 / cg"
!

tabMeansNextField
    "return true, if a Tab character should shift focus."

    "if not readOnly, I want my tab keys ..."

    ^ self isReadOnly or:[tabMeansNextField]

    "Created: 7.2.1996 / 19:15:31 / cg"
!

widthOfContents
    "return the width of the contents in pixels
     Redefined to add the size of a space (for the cursor).
     this enables us to scroll one position further than the longest
     line (and possibly see the cursor behind the line)"

    |w dev|

    w := super widthOfContents.
    (dev := device ) isNil ifTrue:[
        "/ really don't know ...
        dev := Screen current
    ].
    ^ w + (gc font widthOn:dev)

    "Modified: 28.5.1996 / 19:32:25 / cg"
! !

!EditTextView methodsFor:'realization'!

realize
    "make the view visible - scroll to make the cursor visible."

    super realize.

    self makeCursorVisible.
    cursorFgColor := cursorFgColor onDevice:device.
    cursorBgColor := cursorBgColor onDevice:device.

    "Modified: 20.12.1996 / 14:16:05 / cg"
    "Created: 24.7.1997 / 18:24:12 / cg"
! !

!EditTextView methodsFor:'redrawing'!

redrawCursorIfBetweenVisibleLine:startVisLine and:endVisLine
    "redraw the cursor, if it sits in a line range"

    cursorShown ifTrue:[
        cursorVisibleLine notNil ifTrue:[
            (cursorVisibleLine between:startVisLine and:endVisLine) ifTrue:[
                self drawCursorCharacter
            ]
        ]
    ]
!

redrawCursorIfInVisibleLine:visLine
    "redraw the cursor, if it sits in visible line"

    cursorShown ifTrue:[
        (visLine == cursorVisibleLine) ifTrue:[
            self drawCursorCharacter
        ]
    ]
!

redrawFromVisibleLine:startVisLine to:endVisLine
    "redraw a visible line range"

    super redrawFromVisibleLine:startVisLine to:endVisLine.
    self redrawCursorIfBetweenVisibleLine:startVisLine and:endVisLine
!

redrawVisibleLine:visLine
    "redraw a visible line"

    super redrawVisibleLine:visLine.
    self redrawCursorIfInVisibleLine:visLine
!

redrawVisibleLine:visLine col:colNr
    "redraw the single character in visibleline at colNr"

    super redrawVisibleLine:visLine col:colNr.
    cursorShown ifTrue:[
        (visLine == cursorVisibleLine) ifTrue:[
            (colNr == cursorCol) ifTrue:[
                self drawCursorCharacter.
                ^ self
            ]
        ]
    ].

    "Modified: / 05-11-2007 / 17:35:53 / cg"
!

redrawVisibleLine:visLine from:startCol
    "redraw a visible line from startCol to the end of line"

    super redrawVisibleLine:visLine from:startCol.
    cursorShown ifTrue:[
        self redrawCursorIfInVisibleLine:visLine
    ]
!

redrawVisibleLine:visLine from:startCol to:endCol
    "redraw a visible line from startCol to endCol"

    super redrawVisibleLine:visLine from:startCol to:endCol.
    self redrawCursorIfInVisibleLine:visLine
! !

!EditTextView methodsFor:'scrolling'!

additionalMarginForHorizontalScroll
    "return the number of pixels by which we may scroll more than the actual
     width of the document would allow.
     This is redefined by editable textViews, to allo for the cursor
     to be visible if it is positioned right behind the longest line of text.
     The default returned here is 10 pixels, which should be ok for most cursors"

    ^ 10 max:gc font width
!

halfPageDown
    "half a page down - to keep cursor on same visible line, it has to be moved
     within the real text  "

    |prevCursorLine|

    prevCursorLine := cursorVisibleLine.
    super halfPageDown.
    self cursorVisibleLine:prevCursorLine col:cursorCol
!

halfPageUp
    "half a page up - to keep cursor on same visible line, it has to be moved
     within the real text  "

    |prevCursorLine|

    prevCursorLine := cursorVisibleLine.
    super halfPageUp.
    self cursorVisibleLine:prevCursorLine col:cursorCol
!

originChanged:delta
    "sent after scrolling - have to show the cursor if it was on before"

    super originChanged:delta.
    "
     should we move the cursor with the scroll - or leave it ?
    "
    self updateCursorVisibleLine.
    prevCursorState ifTrue:[
        self showCursor
    ]

    "Modified: / 17.6.1998 / 16:13:24 / cg"
!

originWillChange
    "sent before scrolling - have to hide the cursor"

    prevCursorState := cursorShown.
    "/ cursorShown := false.
    cursorShown ifTrue:[
        self hideCursor
    ]

    "Modified: / 6.7.1998 / 13:07:23 / cg"
!

pageDown
    "page down - to keep cursor on same visible line, it has to be moved
     within the real text  "

    |prevCursorLine|

    prevCursorLine := cursorVisibleLine.
    super pageDown.
    self cursorVisibleLine:prevCursorLine col:cursorCol
!

pageUp
    "page up - to keep cursor on same visible line, it has to be moved
     within the real text  "

    |prevCursorLine|

    prevCursorLine := cursorVisibleLine.
    super pageUp.
    self cursorVisibleLine:prevCursorLine col:cursorCol
! !

!EditTextView methodsFor:'searching'!

searchBwd:pattern ifAbsent:aBlock
    "do a backward search"

    self searchBwd:pattern ignoreCase:false ifAbsent:aBlock
!

searchBwd:pattern ignoreCase:ign ifAbsent:aBlock
    "do a backward search"

    cursorLine isNil ifTrue:[^ self].
    super searchBwd:pattern ignoreCase:ign ifAbsent:aBlock
!

searchBwd:pattern ignoreCase:ign startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a backward search"

    cursorLine isNil ifTrue:[^ self].

    self
        searchBackwardFor:pattern
        ignoreCase:ign
        startingAtLine:startLine col:startCol
        ifFound:[:line :col :endColOrNil |
            self cursorMovementAllowed ifTrue:[
                self cursorLine:line col:col.
            ].
            self showMatch:pattern isMatch:false atLine:line col:col endCol:endColOrNil.
"/            self makeLineVisible:cursorLine
            typeOfSelection := #search]
        ifAbsent:aBlock

    "Modified: 9.10.1997 / 13:02:13 / cg"
!

searchForAndSelectMatchingParenthesis
    "select characters enclosed by matching parenthesis if one is under cusor"

    self searchForAndSelectMatchingParenthesisFromLine:cursorLine col:cursorCol
!

searchForMatchingParenthesis
    "search for a matching parenthesis starting at cursor position.
     Search for the corresponding character is done forward if its an opening,
     backwards if its a closing parenthesis.
     Positions the cursor if found, peeps if not"

    self cursorMovementAllowed ifFalse:[^ self].

    self
        searchForMatchingParenthesisFromLine:cursorLine col:cursorCol
        ifFound:[:line :col | self cursorLine:line col:col]
        ifNotFound:[self showNotFound]
        onError:[self beep]

    "Modified: 9.10.1997 / 12:56:30 / cg"
!

searchFwd:pattern ignoreCase:ign match: match startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a forward search"

    cursorLine isNil ifTrue:[^ self].
    self 
        searchForwardFor:pattern 
        ignoreCase:ign
        match: match
        startingAtLine:startLine col:startCol
        ifFound:[:line :col :endColOrNil|
            self cursorMovementAllowed ifTrue:[
                self cursorLine:line col:col.
            ].
            self showMatch:pattern isMatch:match atLine:line col:col endCol:endColOrNil.
"/            self makeLineVisible:cursorLine
            typeOfSelection := #search
        ]
        ifAbsent:aBlock

    "Modified: 9.10.1997 / 12:57:47 / cg"
    "Created: 9.10.1997 / 13:01:12 / cg"
!

searchFwd:pattern ignoreCase:ign startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a forward search"

    self searchFwd:pattern ignoreCase:ign match: false startingAtLine:startLine col:startCol ifAbsent:aBlock
!

searchFwd:pattern startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a forward search"

    self searchFwd:pattern ignoreCase:false startingAtLine:startLine col:startCol ifAbsent:aBlock
!

searchPatternForSearchBar

    "Returns the next searchPattern from the user selection or from the autoSearch"

    |searchPattern|

    searchPattern := self searchPatternFromUserSelectionOrReplace.
    searchPattern isNil 
        ifTrue: [searchPattern := lastSearchPattern]
        ifFalse: [lastSearchPattern := searchPattern].
    ^ searchPattern
!

setSearchPatternWithMatchEscapes: match
    "set the searchpattern from the selection if there is one, and position
     cursor to start of pattern"

    |sel|

    "/
    "/ if the last operation was a replace, set pattern to last
    "/ original string (for search after again)
    "/ for cut or delete actions allow lastReplacement with nil
    "/
"/    (lastStringFromReplaceForNextSearch notNil
"/     and:[typeOfSelection ~~ #search]) ifTrue:[
"/        lastStringFromReplaceForNextSearch isString ifTrue:[
"/            lastSearchPattern := lastStringFromReplaceForNextSearch.
"/        ] ifFalse:[
"/            lastSearchPattern := lastStringFromReplaceForNextSearch asStringWithoutFinalCR.
"/        ].
"/        ^ self
"/    ].

    "/
    "/ if there is a selection:
    "/    if there was no previous search, take it as search pattern.
    "/    if there was a previous search, only take the selection if
    "/    it did not result from a paste or from the last search itself.
    "/    (to allow search-paste to be repeated)
    "/
    sel := self selection.
    sel notNil ifTrue:[
        (lastSearchPattern isNil
        or:[typeOfSelection ~~ #paste and:[typeOfSelection ~~ #search]]
        ) ifTrue:[
            self cursorLine:selectionStartLine col:selectionStartCol.
            lastSearchPattern := sel asStringWithoutFinalCR.
            match ifTrue:[lastSearchPattern := lastSearchPattern withMatchEscapes].
        ]
    ]

    "Modified: / 07-05-2011 / 17:25:59 / cg"
!

showMatch:pattern isMatch:isMatch atLine:line col:col endCol:encColOrNil
    super showMatch:pattern isMatch:isMatch atLine:line col:col endCol:encColOrNil.
    typeOfSelection := #search.
!

startPositionForSearchBackward
    ^ self startPositionForSearchBackwardBasedOnCursorOrSelection
!

startPositionForSearchBackwardBasedOnCursorOrSelection
    |startLine startCol|

    selectionStartLine notNil ifTrue:[
        startLine := selectionStartLine.
        startCol := selectionStartCol
    ] ifFalse:[
        cursorLine isNil ifTrue:[
            startLine := list size.
            startCol := self listAt:startLine size.
        ] ifFalse:[
            startLine := cursorLine min:list size.
            startCol := cursorCol
        ]
    ].

    ^ startCol @ cursorLine
!

startPositionForSearchForward
    ^ self startPositionForSearchForwardBasedOnCursorOrSelection
!

startPositionForSearchForwardBasedOnCursorOrSelection
    |startCol|

    "/ if there is no selection and the cursor is at the origin,
    "/ assume its the first search and do not skip the very first match
    startCol := cursorCol.
    self hasSelection ifTrue:[
        ^ selectionEndCol @ selectionEndLine.
    ] ifFalse:[
        (cursorLine == 1 and:[cursorCol == 1]) ifTrue:[
            startCol := 0
        ].
        startCol := startCol min:(self at:cursorLine) size
    ].

    ^ startCol @ cursorLine

    "Modified (format): / 24-05-2012 / 13:58:37 / cg"
! !

!EditTextView methodsFor:'selections'!

addToSelectionAfter:aBlock 
    "Extends the selection accroding to cursor position
     after evaluation of `aBlock`. Used to implement
     Shift-Up/Down/Left/Right, Shift-Home & Shift-End."

    "/ Following comment is in czech and thus now very useful.
    "/ However I (JV) kept it here as this is one of the very
    "/ first fix/hack we made to Smalltalk/X ages ago, if not
    "/ the very first one. Actually, this method and comment was 
    "/ written by Martin Dvorak. Yeah, being bit nostalgic...

    "Pokud existuje selekce, upravi ji
     podle aktualni pozice kurzoru a pozice
     po provedeni blocku.
     Urceno k implementaci Shift-Home a Shift-End
     Nejak nevim, jak to presneji popsat :-)"

    | startLine startCol endLine endCol curLine curCol cursorAtTheBeginning cursorAtTheEnd cursorWasShown flip extModeStandard |

    curLine := cursorLine.
    curCol := cursorCol.

    self hasSelection ifTrue: [
        startLine := selectionStartLine.
        startCol := selectionStartCol.
        endLine := selectionEndLine.
        endCol := selectionEndCol.
    ] ifFalse:[
        startLine := endLine := curLine.
        startCol := curCol.
        endCol := curCol - 1.
    ].

    cursorAtTheBeginning := (startLine == curLine) and:[startCol == curCol].
    cursorAtTheEnd := (endLine == curLine) and:[endCol == (curCol - 1)]. 
    self assert: cursorAtTheBeginning | cursorAtTheEnd.


    cursorWasShown := self hideCursor.
    aBlock value.

    cursorAtTheBeginning ifTrue:[
        (cursorCol == (endCol + 1) and:[cursorLine == endLine]) ifTrue:[
                self unselect; showCursor.
                ^self
        ].

        flip := cursorLine == endLine and:[cursorCol > endCol].
        flip ifTrue:[ 
            extModeStandard := UserPreferences current selectionExtensionMode == #standard.
        ].
        (cursorLine > endLine or:[flip]) ifTrue:[
            (flip and:[ extModeStandard ]) ifTrue:[
                startLine := endLine.
                startCol := endCol + 1.
            ].
            endLine := cursorLine.
            endCol := cursorCol - 1
        ] ifFalse:[
            startLine := cursorLine.
            startCol := cursorCol.
        ]
    ] ifFalse:[
        cursorAtTheEnd ifTrue:[
            (cursorCol == startCol and:[cursorLine == startLine]) ifTrue:[
                self unselect; showCursor.
                ^self
            ].
            flip := cursorLine == startLine and:[cursorCol < startCol].
            flip ifTrue:[ 
                extModeStandard := UserPreferences current selectionExtensionMode == #standard.
            ].  
            (cursorLine < startLine or:[flip]) ifTrue:[
                (flip and:[ extModeStandard ]) ifTrue:[
                    endLine := startLine.
                    endCol := startCol - 1.
                ].
                startLine := cursorLine.
                startCol := cursorCol
            ] ifFalse:[
                endLine := cursorLine.
                endCol := cursorCol - 1.
            ]
        ].
    ].
    self selectFromLine:startLine col:startCol toLine: endLine col:endCol .
    cursorWasShown ifTrue:[self showCursor].

    "Modified: / 27-03-2014 / 10:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-03-2014 / 17:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

autoMoveCursorToEndOfSelection
    "return true, if the cursor should be automatically moved to the
     end of a selection.
     Redefined to return false in terminalViews, where the cursor should
     not be affected by selecting"

    ^ true
!

changeTypeOfSelectionTo:newType
    typeOfSelection ~~ newType ifTrue:[
        typeOfSelection := newType.
        selectionStartLine notNil ifTrue:[
            self
                redrawFromLine:selectionStartLine col:selectionStartCol
                toLine:selectionEndLine col:selectionEndCol
        ].
    ].
!

findNextWordAfterSelectionAndAddToSelection
    |selStartCol selStartLine selEndCol selEndLine|

    selectionStartCol isNil ifTrue:[
        self selectWordUnderCursor.
        ^ self
    ].

    selStartCol := selectionStartCol.
    selEndCol := selectionEndCol.
    selStartLine := selectionStartLine.
    selEndLine := selectionEndLine.

    self cursorToNextWord.
    self selectWordUnderCursor.

    self selectFromLine:selStartLine col:selStartCol toLine:selectionEndLine col:selectionEndCol.
!

searchPatternFromUserSelectionOrReplace

    |sel searchPattern|

    "/
    "/ if the last operation was a replace, set pattern to last
    "/ original string (for search after again)
    "/
    (lastStringFromReplaceForNextSearch notNil
     and:[typeOfSelection ~~ #search]) ifTrue:[
        lastStringFromReplaceForNextSearch isString ifTrue:[
            searchPattern := lastStringFromReplaceForNextSearch.
        ] ifFalse:[
            searchPattern := lastStringFromReplaceForNextSearch asStringWithoutFinalCR.
        ].
        ^ searchPattern
    ].

    "/
    "/ if there is a selection:
    "/    if there was no previous search, take it as search pattern.
    "/    if there was a previous search, only take the selection if
    "/    it did not result from a paste.
    "/    (to allow search-paste to be repeated)
    "/
    sel := self selection.
    sel notNil ifTrue:[
        typeOfSelection ~~ #search ifTrue:[
            typeOfSelection ~~ #paste ifTrue:[
                self cursorLine:selectionStartLine col:selectionStartCol.
                searchPattern := sel asStringWithoutFinalCR.
            ]
        ].
    ].

    ^ searchPattern
!

selectAll
    "select the whole text.
     redefined to send super selectFrom... since we don't want the
     cursor to be moved in this case."

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        super selectFromLine:1 col:1 toLine:(list size + 1) col:0.
        typeOfSelection := nil
    ]

    "Modified: 28.2.1997 / 19:14:54 / cg"
!

selectAllInitially
    "select the whole text. This is called only once during the initialization
     for editFields which are shown in a table or tree.
     The selectAll is called via this method to allow for easier redefinition and
     to distinguish auto-select from user-initiated selects."

    self selectAll
!

selectCursorLine
    "select cursorline"

    self selectFromLine:cursorLine col:1 toLine:cursorLine+1 col:0
!

selectCursorLineFromBeginning
    "select cursorline up to cursor position"

    cursorCol > 1 ifTrue:[
        self selectFromLine:cursorLine col:1
                     toLine:cursorLine col:(cursorCol-1)
    ]

    "Modified: 16.8.1996 / 19:14:14 / cg"
!

selectExpandCursorLine
    "expand selection by one line or select cursorline"

    selectionStartLine isNil ifTrue:[
        self selectCursorLine
    ] ifFalse:[
        self selectFromLine:selectionStartLine col:selectionStartCol
                     toLine:cursorLine+1 col:0.
        self makeLineVisible:selectionEndLine
    ]
!

selectFromBeginOfLine
    "select the text from the beginning of the current line to the current cursor position."

    | newCursorCol ln |

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        cursorCol > 1 ifTrue:[
            ln := list at: cursorLine.
            newCursorCol := ln notEmptyOrNil ifTrue:[ln indexOfNonSeparator] ifFalse:[1].
            self selectFromLine:cursorLine col:newCursorCol toLine:cursorLine col:cursorCol-1.
            cursorCol := newCursorCol.
            typeOfSelection := nil
        ]
    ]

    "Created: / 28-06-2011 / 22:47:04 / cg"
    "Modified: / 18-07-2012 / 17:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectFromBeginning
    "select the text from the beginning to the current cursor position."

    |col|

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        cursorCol == 0 ifTrue:[
            col := 0
        ] ifFalse:[
            col := cursorCol - 1
        ].
        super selectFromLine:1 col:1 toLine:cursorLine col:col.
        typeOfSelection := nil
    ]
!

selectFromLine:startLine col:startCol toLine:endLine col:endCol

    super selectFromLine:startLine col:startCol toLine:endLine col:endCol.
    "JV: That's actually rubbish as then you loose the original positon
     and if user wants to extend/shring the selection further, you don't know
     from which end to do it!!"
"/    (selectionEndLine notNil and:[self autoMoveCursorToEndOfSelection]) ifTrue:[
"/        self cursorLine:selectionEndLine col:(selectionEndCol + 1).
"/    ].
    typeOfSelection := nil

    "Modified: / 27-08-2013 / 13:28:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-08-2013 / 15:58:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectToEndOfLine
    "select the text from the current cursor position to the end of the current line"

    | newCursorCol line |

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        cursorCol >= 1 ifTrue:[
            line := list at: cursorLine.
            newCursorCol := line size.
            [ newCursorCol > 1 and:[(line at:newCursorCol) isSeparator] ]      
                whileTrue:[newCursorCol := newCursorCol - 1].

            self selectFromLine:cursorLine col:cursorCol toLine:cursorLine col: newCursorCol.
            cursorCol := newCursorCol.
            typeOfSelection := nil
        ]
    ]

    "Created: / 28-06-2011 / 23:07:07 / cg"
    "Modified: / 30-06-2011 / 19:51:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectUpToEnd
    "select the text from the current cursor position to the end."

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        super selectFromLine:cursorLine col:cursorCol toLine:(list size + 1) col:0.
        typeOfSelection := nil
    ]
!

selectWordAtLine:line col:col
    "select the word at given line/col"
    super selectWordAtLine:line col:col.
    cursorLine := selectionEndLine.
    cursorCol := selectionEndCol + 1.

    "Created: / 16-03-2017 / 23:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectWordUnderCursor
    "select the word under the cursor"

    self selectWordAtLine:cursorLine col:cursorCol
!

unselect
    "forget and unhilight selection - must take care of cursor here"

    |wasOn|

    wasOn := self hideCursor.
    super unselect.
    typeOfSelection := nil.
    wasOn ifTrue:[self showCursor]
! !

!EditTextView methodsFor:'undo & again'!

addUndo:action
    ^ undoSupport addUndo:action.
!

again
    "repeat the last action (which was a cut or replace).
     If current selection is not last string, search forward to
     next occurrence of it before repeating the last operation."

    |s l c sel savedSelectStyle startColForSearch 
     lastStringToReplace lastReplaceIgnoredCase lastReplaceWasMatch|

    lastStringToReplace := lastReplacementInfo lastStringToReplace.
    lastStringToReplace isNil ifTrue:[
        ^ false
    ].
    lastReplaceIgnoredCase := lastReplacementInfo lastReplaceIgnoredCase.
    lastReplaceWasMatch := lastReplacementInfo lastReplaceWasMatch.

    self undoableDo:[
        s := lastStringToReplace asString.
        "remove final cr"
        (s endsWith:Character cr) ifTrue:[s := s copyButLast:1].
    "/        s := s withoutSpaces.        "XXX - replacing text with spaces ..."

        "set lastStringToReplace as the next search string 
         and set lastReplaceIgnoredCase as the next search ignored case flag"
        lastStringFromReplaceForNextSearch := s.
        lastSearchIgnoredCase := lastReplaceIgnoredCase.

        savedSelectStyle := selectStyle.
        selectStyle := nil.

        sel := self selection.

        "if we are already there (after a find), ommit search"

        (sel notNil and:[sel asString withoutSeparators = s]) ifTrue:[
            l := selectionStartLine "cursorLine".
            c := selectionStartCol "cursorCol".
            self deleteSelection.
            lastReplacementInfo lastReplacement notNil ifTrue:[
                self insertLines:lastReplacementInfo lastReplacement asStringCollection withCR:false.
                self selectFromLine:l col:c toLine:cursorLine col:(cursorCol - 1).
                typeOfSelection := #paste
            ].
            selectStyle := savedSelectStyle.
            ^ true
        ].

        sel isEmptyOrNil ifTrue:[
            startColForSearch := cursorCol - 1
        ] ifFalse:[
            startColForSearch := selectionEndCol ? (cursorCol - 1)
        ].
        self 
            searchForwardFor:s
            ignoreCase: lastReplaceIgnoredCase 
            match: lastReplaceWasMatch 
            startingAtLine:cursorLine col:startColForSearch
            ifFound:
                [
                    :line :col |

                    |repl|

                    self selectFromLine:line col:col
                                 toLine:line col:(col + s size - 1).
                    self makeLineVisible:line.

                    self deleteSelection.
                    lastReplacementInfo lastReplacement notNil ifTrue:[
                        lastReplacementInfo lastReplacement isString ifFalse:[
                            repl := lastReplacementInfo lastReplacement asString "withoutSpaces"
                        ] ifTrue:[
                            repl := lastReplacementInfo lastReplacement "withoutSpaces".
                        ].
                        self insertLines:repl asStringCollection withCR:false.
                        self selectFromLine:line col:col toLine:cursorLine col:(cursorCol - 1).
                        undoSupport actionInfo:'replace'.
                    ].
                    selectStyle := savedSelectStyle.
                    typeOfSelection := #paste.
                    ^ true
                ]
            ifAbsent:
                [
                    self sensor compressKeyPressEventsWithKey:#Again.
                    self showNotFound.
                    selectStyle := savedSelectStyle.
                    ^ false
                ].
    ].

    ^ true.

    "Modified: 9.10.1996 / 16:14:11 / cg"
!

hasRedoAction
    ^ undoSupport hasRedoAction.
!

hasUndoAction
    ^ undoSupport hasUndoAction.
!

multipleAgain
    "repeat the last action (which was a cut or replace) until search fails"

    [self again] whileTrue:[]
!

nonUndoableDo:aBlock
    undoSupport nonUndoableDo:aBlock.
!

redo
    "undo the last undo"

    undoSupport hasRedoAction ifFalse:[
        self beep
    ] ifTrue:[
        undoSupport redo.
    ]
!

undo
    "undo the last edit operation"

    undoSupport hasUndoAction ifFalse:[
        self beep
    ] ifTrue:[
        undoSupport undo.
        self makeSelectionVisible.
        self makeCursorVisible.
    ]
!

undoableDo:aBlock
    self undoableDo:aBlock info:nil.

    "Modified: / 28-07-2007 / 13:20:14 / cg"
!

undoableDo:aBlock info:aString
    |selectionRestore|

    self checkModificationsAllowed ifFalse:[
        "/ will trigger an error-dialog there (no need for undo-carekeeping)
        aBlock value.
    ] ifTrue:[
        undoSupport isInTransaction ifFalse:[
            selectionRestore := RestoreSelectionAndCursor new 
                                    cursorLine:cursorLine cursorCol:cursorCol
                                    selectionStartLine:selectionStartLine selectionStartCol:selectionStartCol
                                    selectionEndLine:selectionEndLine selectionEndCol:selectionEndCol
                                    info:nil.
        ].
        undoSupport 
            undoableDo:[
                aBlock value.
                selectionRestore notNil ifTrue:[
                    undoSupport transactionNotEmpty ifTrue:[
                        undoSupport addUndoFirst:selectionRestore 
                    ].
                ].
            ]
            info:aString.
    ].

    "Modified: / 30-04-2016 / 21:08:30 / cg"
! !

!EditTextView::EditAction class methodsFor:'instance creation'!

line1:arg1 col1:arg2 line2:arg3 col2:arg4
    ^ self new line1:arg1 col1:arg2 line2:arg3 col2:arg4
!

line1:arg1 col1:arg2 line2:arg3 col2:arg4 info:info
    ^ (self new line1:arg1 col1:arg2 line2:arg3 col2:arg4) info:info
!

line:arg1 col:arg2 character:arg3
    ^ self new line:arg1 col:arg2 character:arg3
!

line:arg1 col:arg2 character:arg3 info:info
    ^ (self new line:arg1 col:arg2 character:arg3) info:info
!

line:arg1 col:arg2 characters:arg3 info:info
    ^ (self new line:arg1 col:arg2 characters:arg3) info:info
!

line:arg1 col:arg2 info:arg3
    ^ self new line:arg1 col:arg2 info:arg3
!

line:arg1 col:arg2 string:arg3
    ^ self new line:arg1 col:arg2 string:arg3
!

line:arg1 col:arg2 string:arg3 info:info
    ^ (self new line:arg1 col:arg2 string:arg3) info:info
!

line:arg1 string:arg3 info:info
    ^ (self new line:arg1 string:arg3) info:info
!

text:arg info:info
    ^ (self new text:arg) info:info
! !

!EditTextView::EditAction methodsFor:'accessing'!

info
    ^ userFriendlyInfo
!

info:aString
    userFriendlyInfo := aString
! !

!EditTextView::EditAction methodsFor:'combining'!

canCombineWithPreviousPasteStringAction: aPasteStringAction
    ^ false.

    "Created: / 25-09-2006 / 12:16:25 / cg"
! !

!EditTextView::EditAction methodsFor:'queries'!

canCombineWithNext:nextAction
    ^ false
!

isRestoreSelectionAndCursor
    ^ false
! !

!EditTextView::DeleteRange methodsFor:'accessing'!

line1:line1Arg col1:col1Arg line2:line2Arg col2:col2Arg
    "set instance variables (automatically generated)"

    self assert:(line1Arg notNil).
    self assert:(col1Arg notNil).
    self assert:(line2Arg notNil).
    self assert:(col2Arg notNil).

    line1 := line1Arg.
    col1 := col1Arg.
    line2 := line2Arg.
    col2 := col2Arg.
! !

!EditTextView::DeleteRange methodsFor:'execution'!

executeIn:editor
    editor unselect.
    editor
        deleteFromLine:line1
        col:col1
        toLine:line2
        col:col2.
    editor cursorLine:line1 col:col1.
! !

!EditTextView::DeleteCharacters methodsFor:'accessing'!

col1
    ^ col1
!

col2
    ^ col2
!

line
    ^ line
!

line:lineArg col1:col1Arg col2:col2Arg
    "set instance variables (automatically generated)"

    self assert:(lineArg notNil).
    self assert:(col1Arg notNil).
    self assert:(col2Arg notNil).

    line := lineArg.
    col1 := col1Arg.
    col2 := col2Arg.
!

line:lineArg col:colArg info:infoArg
    self assert:(lineArg notNil).
    self assert:(colArg notNil).

    line := lineArg.
    col1 := col2 := colArg.
    self info:infoArg.
! !

!EditTextView::DeleteCharacters methodsFor:'combining'!

canCombineWithNext:anotherAction
    ^ anotherAction perform:#canCombineWithPreviousDeleteCharactersAction: with:self ifNotUnderstood:false
!

canCombineWithPreviousDeleteCharactersAction:previousDeleteAction
    "I will combine only if we both are single character deletes,
     and my col-to-delete is the next after anotherDeleteActions col-to-delete.
     (i.e. single-character typing)"

    previousDeleteAction line == line ifTrue:[
        previousDeleteAction col2 == (col1-1) ifTrue:[
            ^ true
        ].
    ].

    ^ false
!

combineWithNext:nextDeleteAction
    self assert:(line == nextDeleteAction line).
    self assert:(col2 == (nextDeleteAction col1 - 1)).

    col2 := nextDeleteAction col2.
    userFriendlyInfo := 'insert ' , (col2 - col1 + 1) printString
! !

!EditTextView::DeleteCharacters methodsFor:'execution'!

executeIn:editor
    editor unselect.
    editor
        deleteFromLine:line
        col:col1
        toLine:line
        col:col2.
    editor cursorLine:line col:col1.
! !

!EditTextView::EditMode class methodsFor:'constants'!

insertAndSelectMode
    ^ InsertAndSelectMode
!

insertMode
    ^ InsertMode
!

overwriteMode
    ^ OverwriteMode
! !

!EditTextView::EditMode class methodsFor:'queries'!

isInsertAndSelectMode
    ^ false
!

isInsertMode
    ^ false
!

symbolicName
    self subclassResponsibility
! !

!EditTextView::EditMode::InsertAndSelectMode class methodsFor:'info'!

infoPrintString
    ^ 'IS'
! !

!EditTextView::EditMode::InsertAndSelectMode class methodsFor:'queries'!

isInsertAndSelectMode
    ^ true
!

isInsertMode
    ^ true
! !

!EditTextView::EditMode::InsertMode class methodsFor:'info'!

infoPrintString
    ^ 'I'
! !

!EditTextView::EditMode::InsertMode class methodsFor:'queries'!

isInsertMode
    ^ true
! !

!EditTextView::EditMode::OverwriteMode class methodsFor:'info'!

infoPrintString
    ^ 'O'
! !

!EditTextView::LastReplacementInfo methodsFor:'accessing'!

lastReplaceIgnoredCase
    ^ lastReplaceIgnoredCase ? false
!

lastReplaceIgnoredCase:something
    lastReplaceIgnoredCase := something.
!

lastReplaceWasMatch
    ^ lastReplaceWasMatch ? false
!

lastReplaceWasMatch:something
    lastReplaceWasMatch := something.
!

lastReplacement
    ^ lastReplacement
!

lastReplacement:something
"/Transcript showCR: 'lastReplacement:', something printString.
    lastReplacement := something.
!

lastStringToReplace
    ^ lastStringToReplace
!

lastStringToReplace:something
    lastStringToReplace := something.
!

previousReplacements
    ^ previousReplacements ? #()
!

stillCollectingInput
    ^ stillCollectingInput
!

stillCollectingInput:aBoolean
    stillCollectingInput := aBoolean.
! !

!EditTextView::LastReplacementInfo methodsFor:'history'!

rememberReplacement
    "remember the previous replacement (called when a new one appears).
     Mostly for the benefit of the code completion..."

    |oldString newString|

    oldString := lastStringToReplace.
    newString := lastReplacement.
    (oldString notEmptyOrNil and:[newString notEmptyOrNil]) ifTrue:[
        previousReplacements isNil ifTrue:[
            previousReplacements := OrderedCollection new.
        ].
        previousReplacements := previousReplacements reject:[:entry | entry key = oldString].
        previousReplacements addFirst:(oldString -> newString).
        previousReplacements size > 20 ifTrue:[
            previousReplacements removeLast.
        ]
    ].
! !

!EditTextView::PasteString methodsFor:'accessing'!

col
    ^ col

    "Created: / 25-09-2006 / 12:19:59 / cg"
!

col2
    ^ col + string size - 1

    "Created: / 25-09-2006 / 12:20:18 / cg"
!

line
    ^ line

    "Created: / 25-09-2006 / 12:21:08 / cg"
!

line:lineArg col:colArg string:stringArg
    self assert:(lineArg notNil).
    self assert:(colArg notNil).
    self assert:(stringArg notNil).

    line := lineArg.
    col := colArg.
    string := stringArg.
!

line:lineArg col:colArg string:stringArg selected:selectedArg
    self assert:(lineArg notNil).
    self assert:(colArg notNil).
    self assert:(stringArg notNil).

    line := lineArg.
    col := colArg.
    string := stringArg.
    selected := selectedArg.
!

string
    ^ string

    "Created: / 25-09-2006 / 12:25:59 / cg"
! !

!EditTextView::PasteString methodsFor:'combining'!

canCombineWithNext:anotherAction
    ^ anotherAction canCombineWithPreviousPasteStringAction:self

    "Created: / 25-09-2006 / 12:15:59 / cg"
!

canCombineWithPreviousPasteStringAction: previousPasteAction
    "I will combine only if we both are single character inserts,
     and my col-to-insert is the next after anotherInsertActions end-col.
     (i.e. single-character deletes)"

    previousPasteAction line == line ifTrue:[
        previousPasteAction col == (self col2+1) ifTrue:[
            ^ true
        ].
    ].

    ^ false

    "Modified: / 25-09-2006 / 12:22:21 / cg"
!

combineWithNext:nextPasteAction
    |s1 s2|

    self assert:(line == nextPasteAction line).
    self assert:((col - 1) == (nextPasteAction col2)).

    s1 := nextPasteAction string.
    s1 isString ifFalse:[s1 := s1 asStringWith:nil].
    s2 := string.
    s2 isString ifFalse:[s2 := s2 asStringWith:nil].

    string := s1, s2.
    col := nextPasteAction col.
    userFriendlyInfo := 'delete ' , string size printString

    "Created: / 25-09-2006 / 12:24:10 / cg"
! !

!EditTextView::PasteString methodsFor:'execution'!

executeIn:editor
    editor cursorLine:line col:col.
    editor paste:string.
    selected ~~ true ifTrue:[
        editor unselect
    ].
! !

!EditTextView::ReplaceCharacter methodsFor:'accessing'!

col
    ^ col
!

col1
    ^ col
!

col2
    ^ col
!

line
    ^ line
!

line:lineArg col:colArg character:characterArg
    line := lineArg.
    col := colArg.
    character := characterArg.
! !

!EditTextView::ReplaceCharacter methodsFor:'execution'!

executeIn:editor
    editor
        replace:character
        atLine:line
        col:col.
    editor cursorLine:line col:col.
! !

!EditTextView::ReplaceCharacters methodsFor:'accessing'!

characters
    ^ characters
!

col1
    ^ col1
!

col2
    ^ col2
!

line
    ^ line
!

line:lineArg col:colArg character:characterArg
    line := lineArg.
    col1 := col2 := colArg.
    characters := characterArg asString.
!

line:lineArg col:colArg characters:charactersArg
    line := lineArg.
    col1 := colArg.
    characters := charactersArg asString.
    col2 := col1 + charactersArg size - 1
! !

!EditTextView::ReplaceCharacters methodsFor:'combining'!

canCombineWithNext:anotherAction
    ^ anotherAction perform:#canCombineWithPreviousReplaceCharactersAction: with:self ifNotUnderstood:false
!

canCombineWithPreviousReplaceCharactersAction:previousReplaceAction
    "I will combine only if we both are single character deletes,
     and my col-to-delete is the next after anotherDeleteActions col-to-delete.
     (i.e. single-character typing)"

    previousReplaceAction line == line ifTrue:[
        previousReplaceAction col2 == (col1-1) ifTrue:[
            ^ true
        ].
    ].

    ^ false
!

combineWithNext:nextReplaceAction
    self assert:(line == nextReplaceAction line).
    self assert:(self col2 == (nextReplaceAction col1 - 1)).

    col2 := nextReplaceAction col2.
    userFriendlyInfo := 'replace ' , (col2 - col1 + 1) printString.
    characters := characters , nextReplaceAction characters.
! !

!EditTextView::ReplaceCharacters methodsFor:'execution'!

executeIn:editor
    editor
        replaceString:characters
        atLine:line
        col:col1.
    editor cursorLine:line col:col1.
! !

!EditTextView::ReplaceContents methodsFor:'accessing'!

text:something
    text := something.
! !

!EditTextView::ReplaceContents methodsFor:'execution'!

executeIn:editor
    editor contents:text
! !

!EditTextView::ReplaceLine methodsFor:'accessing'!

line:lineArg string:stringArg
    line := lineArg.
    text := stringArg.
! !

!EditTextView::ReplaceLine methodsFor:'execution'!

executeIn:editor
    editor list at:line put:text.
    editor invalidateLine:line
! !

!EditTextView::ReplaceLines methodsFor:'accessing'!

line:lineArg lines:lineCollectionArg
    line := lineArg.
    text := lineCollectionArg.

    "Created: / 09-10-2006 / 10:35:22 / cg"
! !

!EditTextView::ReplaceLines methodsFor:'execution'!

executeIn:editor
    |lnr|

    lnr := line.
    text do:[:eachLine |
        editor list at:lnr put:eachLine.
        editor invalidateLine:lnr.
        lnr := lnr + 1.
    ].

    "Modified: / 09-10-2006 / 10:39:16 / cg"
! !

!EditTextView::RestoreSelectionAndCursor methodsFor:'accessing'!

cursorLine:cursorLineArg cursorCol:cursorColArg selectionStartLine:selectionStartLineArg selectionStartCol:selectionStartColArg selectionEndLine:selectionEndLineArg selectionEndCol:selectionEndColArg 
    cursorLine := cursorLineArg.
    cursorCol := cursorColArg.
    selectionStartLine := selectionStartLineArg.
    selectionStartCol := selectionStartColArg.
    selectionEndLine := selectionEndLineArg.
    selectionEndCol := selectionEndColArg.
!

cursorLine:cursorLineArg cursorCol:cursorColArg 
        selectionStartLine:selectionStartLineArg selectionStartCol:selectionStartColArg 
        selectionEndLine:selectionEndLineArg selectionEndCol:selectionEndColArg
        info:info

    cursorLine := cursorLineArg.
    cursorCol := cursorColArg.
    selectionStartLine := selectionStartLineArg.
    selectionStartCol := selectionStartColArg.
    selectionEndLine := selectionEndLineArg.
    selectionEndCol := selectionEndColArg.
    userFriendlyInfo := info.

    "Created: / 30-04-2016 / 20:21:18 / cg"
! !

!EditTextView::RestoreSelectionAndCursor methodsFor:'execution'!

executeIn:editor
    (selectionStartLine notNil and:[selectionEndLine notNil
    and:[selectionStartCol notNil and:[selectionEndCol notNil]]]) ifTrue:[
        editor setCursorLine:cursorLine col:cursorCol.
        editor selectFromLine:selectionStartLine col:selectionStartCol toLine:selectionEndLine col:selectionEndCol
    ] ifFalse:[
        editor cursorLine:cursorLine col:cursorCol.
    ].

    "Created: / 30-04-2016 / 20:14:55 / cg"
! !

!EditTextView::RestoreSelectionAndCursor methodsFor:'queries'!

isRestoreSelectionAndCursor
    ^ true
! !

!EditTextView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

