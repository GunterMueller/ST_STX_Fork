"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

BrowserListWithFilter subclass:#ChangeList
	instanceVariableNames:'listHolder showRemovedHolder showSameHolder showTimestampHolder
		allowRemoveHolder allowAcceptHolder scrollToBottom applyAction
		showConflictsOnlyHolder showDefinitionsOnlyHolder'
	classVariableNames:'LastSelectionConditionString'
	poolDictionaries:''
	category:'Interface-Browsers-ChangeSet'
!

HierarchicalItem subclass:#ListEntry
	instanceVariableNames:'change application x'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeList
!

!ChangeList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!ChangeList class methodsFor:'image specs'!

iconEqual
    ^ ToolbarIconLibrary iconEqual12x12

    "Modified: / 31-08-2011 / 10:52:34 / cg"
!

iconEqualGrayed
    ^ ToolbarIconLibrary iconEqualGray12x12

    "Modified: / 31-08-2011 / 10:54:00 / cg"
!

iconExcla
    ^ ToolbarIconLibrary iconExclaRed12x12
!

iconMinus
    ^ ToolbarIconLibrary iconMinusRed12x12

    "Modified: / 24-07-2012 / 16:43:36 / cg"
!

iconMinusGrayed
    ^ ToolbarIconLibrary iconMinusGray12x12

    "Modified: / 31-08-2011 / 10:54:40 / cg"
!

iconNone
    ^ nil

    "Created: / 05-09-2014 / 00:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iconPlus
    ^ ToolbarIconLibrary iconPlusBlue12x12

    "Modified: / 24-07-2012 / 16:43:31 / cg"
!

iconPlusGrayed
    ^ ToolbarIconLibrary iconPlusGray12x12

    "Modified: / 31-08-2011 / 10:54:46 / cg"
! !

!ChangeList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeList andSelector:#windowSpec
     Tools::ChangeList new openInterface:#windowSpec
     Tools::ChangeList open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Change List'
	  name: 'Change List'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (InputFieldSpec
	      name: 'Filter'
	      layout: (LayoutFrame 0 0 0 0 0 1 25 0)
	      initiallyInvisible: true
	      model: filterPatternHolder
	      immediateAccept: true
	      acceptOnLeave: false
	      acceptOnReturn: false
	      acceptOnTab: false
	      acceptOnPointerLeave: false
	      emptyFieldReplacementText: 'Search Filter...'
	      postBuildCallback: postBuildFilterView:
	    )
	   (DataSetSpec
	      name: 'List'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectionHolder
	      menu: menuHolderWithShowFilter
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      dataList: listHolder
	      useIndex: false
	      doubleClickSelector: selectionDoubleclicked
	      columnHolder: listColumns
	      showLabels: false
	      multipleSelectOk: true
	      postBuildCallback: postBuildListView:
	      properties:
	     (PropertyListDictionary
		startDragSelector: nil
		dropObjectSelector: dragObjects:
		canDropSelector: canDrop:
		dropSelector: dropObjects:
	      )
	    )
	   )

	)
      )
! !

!ChangeList class methodsFor:'list specs'!

listColumnSpec
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ChangeList andSelector:#listColumnSpec
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Removed'
         id: 'removed'
         labelButtonType: Button
         width: 20
         minWidth: 20
         height: heightOfFirstRow
         editorType: CheckToggle
         rendererType: CheckToggle
         model: notRemoved
         menuFromApplication: false
         printSelector: notRemoved
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Delta'
         id: 'delta'
         labelButtonType: Button
         width: 20
         minWidth: 20
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: iconDelta
         canSelect: false
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Change'
         id: change
         labelAlignment: left
         labelButtonType: Button
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: label
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Class'
         id: 'className'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         model: className
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Selector'
         id: 'selector'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         model: selector
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Category'
         id: category
         labelAlignment: left
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         model: category
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Time Stamp'
         id: timeStamp
         labelAlignment: left
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         model: timeStamp
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!ChangeList class methodsFor:'menu specs'!

listMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeList andSelector:#listMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeList listMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasChangeSelectedAndNotRemoved
            label: 'Apply'
            itemValue: listMenuApply
            translateLabel: true
            isVisible: allowAcceptHolder
            shortcutKey: Accept
          )
         (MenuItem
            label: 'Apply all'
            itemValue: listMenuApplyAll
            translateLabel: true
            isVisible: allowAcceptHolder
          )
         (MenuItem
            enabled: hasSingleChangeSelectedAndCanBrowse
            label: 'Browse'
            itemValue: listMenuBrowse
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Delete'
            itemValue: listMenuDeleteSelection
            nameKey: Delete
            translateLabel: true
            isVisible: allowRemoveHolder
            shortcutKey: Delete
          )
         (MenuItem
            label: '-'
            isVisible: allowRemoveHolder
          )
         (MenuItem
            label: 'Select...'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Select same'
                  itemValue: listMenuSelectSame
                  translateLabel: true
                )
               (MenuItem
                  label: 'Select conflicts (redefined classes/methods)'
                  itemValue: listMenuSelectConflicts
                  translateLabel: true
                )
               (MenuItem
                  label: 'Select additions (new classes/methods)'
                  itemValue: listMenuSelectAdditions
                  translateLabel: true
                )
               (MenuItem
                  label: 'Select removals'
                  itemValue: listMenuSelectRemovals
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select all'
                  itemValue: listMenuSelectAll
                  translateLabel: true
                )
               (MenuItem
                  label: 'Select none'
                  itemValue: listMenuSelectNone
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select using block'
                  itemValue: listMenuSelectUsingBlock
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show Deleted'
            translateLabel: true
            isVisible: allowRemoveHolder
            indication: showRemovedHolder
          )
         (MenuItem
            label: 'Inspect change'
            itemValue: listMenuInspect
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!ChangeList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        environmentHolder
        #allowAcceptHolder
        #allowRemoveHolder
        #inGeneratorHolder
        #menuHolder
        #outGeneratorHolder
        #selectionHolder
        #showFilterHolder
        #showRemovedHolder
        #showSameHolder
        #showTimestampHolder
        #showConflictsOnlyHolder
        #showDefinitionsOnlyHolder
      ).

    "Modified: / 24-02-2014 / 10:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'accessing'!

acceptEnabled
    ^ self allowAccept

    "Created: / 08-02-2012 / 14:45:12 / cg"
!

allowAccept
    ^ self allowAcceptHolder value

    "Created: / 24-01-2012 / 19:52:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowAccept: aBoolean
    ^ self allowAcceptHolder value: aBoolean

    "Created: / 24-01-2012 / 19:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowRemoved
    ^ self allowRemoveHolder value ? true

    "Created: / 05-12-2009 / 14:28:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applyAction:aBlock
    applyAction := aBlock.

    "Modified (format): / 10-09-2012 / 14:15:30 / cg"
!

list
    ^ listHolder value

    "Created: / 05-12-2009 / 14:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-12-2011 / 14:18:25 / cg"
!

scrollToBottom:aBoolean
    "If set to true, list will automaticallu scroll to bottom
     ehen the list is updated and clears this flag.

     This is required as the list is updated asynchronously"

    scrollToBottom := aBoolean.

    "Modified (comment): / 30-03-2012 / 17:05:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection

    ^(self selectionHolder value ? #()) reject:[:e|e isNil].

    "Created: / 05-12-2009 / 14:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection: selection

    self selectionHolder value: selection

    "Created: / 30-03-2012 / 12:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIndices
    |sel|

    (sel := self selectionHolder value) isEmptyOrNil ifTrue:[^ #()].
    ^ sel collect:[:each | self list identityIndexOf:each].

    "Created: / 05-12-2009 / 14:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-12-2011 / 10:56:20 / cg"
!

showRemoved

    ^self showRemovedHolder value ? true

    "Created: / 05-12-2009 / 14:28:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'actions'!

selectionDoubleclicked

    self listMenuBrowse
"/    | app |
"/
"/    self selection do:
"/        [:e|e removed: e removed not].
"/    ((app := self masterApplication) respondsTo: #redrawChangeListViews)
"/        ifTrue:[app redrawChangeListViews].

    "Modified: / 24-01-2012 / 22:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'aspects'!

allowAcceptHolder
    "return/create the valueHolder 'acceptEnabledHolder'"

    allowAcceptHolder isNil ifTrue:[
        allowAcceptHolder := ValueHolder with:nil "defaultValue here".
    ].
    ^ allowAcceptHolder

    "Created: / 24-01-2012 / 19:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowAcceptHolder:something
    "set the 'allowAcceptHolder' value holder (automatically generated)"

    allowAcceptHolder := something.
!

allowRemoveHolder
    "return/create the 'allowRemoveHolder' value holder (automatically generated)"
    
    allowRemoveHolder isNil ifTrue:[
        allowRemoveHolder := ValueHolder with:true.
        allowRemoveHolder addDependent:self.
    ].
    ^ allowRemoveHolder

    "Modified (comment): / 24-01-2012 / 19:44:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowRemoveHolder:something 
    "set the 'showRemovedHolder' value holder (automatically generated)"
    
    |oldValue newValue|

    allowRemoveHolder notNil ifTrue:[
        oldValue := allowRemoveHolder value.
        allowRemoveHolder removeDependent:self.
    ].
    allowRemoveHolder := something.
    allowRemoveHolder notNil ifTrue:[
        allowRemoveHolder addDependent:self.
    ].
    newValue := allowRemoveHolder value.
    oldValue ~~ newValue ifTrue:[
        self 
            update:#value
            with:newValue
            from:allowRemoveHolder.
    ].
!

listColumns

    |holder|
    (holder := builder bindingAt:#listColumns) isNil ifTrue:[
	builder aspectAt:#listColumns put:(holder := List new).
	self listColumnShow: #delta.
	self listColumnShow: #change.
    ].
    ^ holder

    "Created: / 26-07-2012 / 18:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listHolder
    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder
!

showConflictsOnlyHolder
    "return/create the 'showConflictsOnlyHolder' value holder (automatically generated)"

    showConflictsOnlyHolder isNil ifTrue:[
        showConflictsOnlyHolder := ValueHolder with: false.
        showConflictsOnlyHolder addDependent: self.
    ].
    ^ showConflictsOnlyHolder

    "Modified: / 05-09-2014 / 00:54:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showConflictsOnlyHolder:something
    "set the 'showConflictsOnlyHolder' value holder (automatically generated)"

    |oldValue newValue|

    showConflictsOnlyHolder notNil ifTrue:[
        oldValue := showConflictsOnlyHolder value.
        showConflictsOnlyHolder removeDependent:self.
    ].
    showConflictsOnlyHolder := something.
    showConflictsOnlyHolder notNil ifTrue:[
        showConflictsOnlyHolder addDependent:self.
    ].
    newValue := showConflictsOnlyHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showConflictsOnlyHolder.
    ].
!

showDefinitionsOnlyHolder
    "return/create the 'showDefinitionsOnlyHolder' value holder (automatically generated)"

    showDefinitionsOnlyHolder isNil ifTrue:[
        showDefinitionsOnlyHolder := ValueHolder with: false.
        showDefinitionsOnlyHolder addDependent: self.
    ].
    ^ showDefinitionsOnlyHolder

    "Modified: / 05-09-2014 / 00:52:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDefinitionsOnlyHolder:something
    "set the 'showDefinitionsOnlyHolder' value holder (automatically generated)"

    |oldValue newValue|

    showDefinitionsOnlyHolder notNil ifTrue:[
        oldValue := showDefinitionsOnlyHolder value.
        showDefinitionsOnlyHolder removeDependent:self.
    ].
    showDefinitionsOnlyHolder := something.
    showDefinitionsOnlyHolder notNil ifTrue:[
        showDefinitionsOnlyHolder addDependent:self.
    ].
    newValue := showDefinitionsOnlyHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showDefinitionsOnlyHolder.
    ].
!

showRemovedHolder
    "return/create the 'showRemovedHolder' value holder (automatically generated)"

    showRemovedHolder isNil ifTrue:[
        showRemovedHolder := ValueHolder with: true.
        showRemovedHolder addDependent: self.
    ].
    ^ showRemovedHolder
!

showRemovedHolder:something
    "set the 'showRemovedHolder' value holder (automatically generated)"

    |oldValue newValue|

    showRemovedHolder notNil ifTrue:[
        oldValue := showRemovedHolder value.
        showRemovedHolder removeDependent:self.
    ].
    showRemovedHolder := something.
    showRemovedHolder notNil ifTrue:[
        showRemovedHolder addDependent:self.
    ].
    newValue := showRemovedHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showRemovedHolder.
    ].
!

showSameHolder
    "return/create the 'showSameHolder' value holder (automatically generated)"

    showSameHolder isNil ifTrue:[
        showSameHolder := ValueHolder with: true.
        showSameHolder addDependent:self.
    ].
    ^ showSameHolder

    "Modified: / 04-08-2011 / 18:39:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSameHolder:something
    "set the 'showSameHolder' value holder (automatically generated)"

    |oldValue newValue|

    showSameHolder notNil ifTrue:[
        oldValue := showSameHolder value.
        showSameHolder removeDependent:self.
    ].
    showSameHolder := something.
    showSameHolder notNil ifTrue:[
        showSameHolder addDependent:self.
    ].
    newValue := showSameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showSameHolder.
    ].
!

showTimestampHolder
    "return/create the 'showTimestampHolder' value holder (automatically generated)"

    showTimestampHolder isNil ifTrue:[
	showTimestampHolder := ValueHolder new.
	showTimestampHolder addDependent:self.
    ].
    ^ showTimestampHolder
!

showTimestampHolder:something
    "set the 'showTimestampHolder' value holder (automatically generated)"

    |oldValue newValue|

    showTimestampHolder notNil ifTrue:[
	oldValue := showTimestampHolder value.
	showTimestampHolder removeDependent:self.
    ].
    showTimestampHolder := something.
    showTimestampHolder notNil ifTrue:[
	showTimestampHolder addDependent:self.
    ].
    newValue := showTimestampHolder value.
    oldValue ~~ newValue ifTrue:[
	self update:#value with:newValue from:showTimestampHolder.
    ].
! !

!ChangeList methodsFor:'change & update'!

selectionChanged
   super selectionChanged
!

update: aspect with: param from: sender

    sender == allowRemoveHolder ifTrue:[
        self listColumn: #removed visible: allowRemoveHolder value.
        ^self.
    ].

    sender == showTimestampHolder ifTrue:[
        self listColumn: #timeStamp visible: showTimestampHolder value.
        ^self.
    ].


    sender == selectionHolder ifTrue:[
        self selectionChanged.
        ^ self
    ].
    sender == showSameHolder ifTrue:[
        self updateList.
        ^self.
    ].
    sender == showRemovedHolder ifTrue:[
        self updateList
    ].
    sender == showConflictsOnlyHolder ifTrue:[
        self updateList
    ].
    sender == showDefinitionsOnlyHolder ifTrue:[
        self updateList
    ].

    ^super update: aspect with: param from: sender

    "Created: / 24-10-2009 / 19:47:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 14:20:30 / cg"
    "Modified: / 26-07-2012 / 18:44:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'drag & drop'!

canDrop: aDropContext

    ^(self inGeneratorHolder value isKindOf: Iterator) not
	and:[aDropContext dropObjects allSatisfy:[:obj|(obj theObject isKindOf: Change)]].

    "Created: / 01-08-2012 / 17:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dragObjects: aDropSource

    ^self selection collect:[:item|(DropObject new: item change) displayObject: (item labelAndIcon)]

    "Created: / 01-08-2012 / 17:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dropObjects:aDropContext
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    | changes |

    changes := self inGeneratorHolder value.
    aDropContext dropObjects do:[:obj|changes add: obj theObject].
    self inGeneratorHolder changed: #value

    "Modified: / 01-08-2012 / 18:15:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'event processing'!

handlesKeyPress:key inView:aView
    <resource: #keyboard (#Accept #Ctrls)>

    ^ (super handlesKeyPress:key inView:aView)
        or:[(key == #Accept or:[ key == #Ctrls]) 
                and:[ listView scrolledView == aView ]]

    "Created: / 08-02-2012 / 14:43:11 / cg"
    "Modified: / 24-04-2015 / 01:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view:aView
    (key == #Accept or:[ key == #Ctrls]) ifTrue:[
        self listMenuApply.
        ^ true
    ]. 

    ^ super keyPress:key x:x y:y view:aView

    "Created: / 08-02-2012 / 14:42:18 / cg"
    "Modified: / 24-04-2015 / 01:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'generators'!

makeGenerator
    "Superclass Tools::BrowserList says that I am responsible to implement this method"

    ^Iterator on:
        [:whatToDo|

        (selectionHolder value ? #()) do:
            [:changeListItem| | change |
            change := changeListItem change.
            change isCompositeChange ifTrue:
                [change changes do: whatToDo]]].

    "Modified: / 24-07-2009 / 23:00:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 20:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'hooks'!

postBuildListView: aView

    super postBuildListView: aView.
    aView scrolledView delegate: self.

    "Created: / 29-11-2011 / 14:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 11:29:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'initialization'!

initialize

    super initialize.
    menuHolder := [self menuFor: #listMenu].
    scrollToBottom := false.
    applyAction isNil ifTrue:[
	applyAction := [:change | change apply ].
    ].

    "Created: / 29-10-2010 / 12:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'menu actions'!

listMenuApply
    |sel list idx selectionHolder|

    self acceptEnabled ifFalse:[^self].
    selectionHolder := self selectionHolder.

    (sel := selectionHolder value) do:[:e| applyAction value:e change].
    sel size == 1 ifTrue:[
        list := self listHolder value. 
        idx := list indexOf:(sel first). 
        idx < list size ifTrue:[
            selectionHolder value:(Array with:(list at:idx+1))
        ] ifFalse:[
            selectionHolder value:#()
        ].
    ].

    "Modified: / 24-10-2009 / 22:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-09-2012 / 13:57:46 / cg"
!

listMenuApplyAll

    self acceptEnabled ifFalse:[^self].

    self selection value do:
        [:e|e removed ifFalse:[applyAction value:e change]].

    "Created: / 05-12-2009 / 14:53:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-09-2012 / 13:57:58 / cg"
!

listMenuBrowse

    self listMenuBrowseChanges:
        ((self selectionHolder value ? #()) collect:[:e|e change])

    "Modified: / 24-01-2012 / 22:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuBrowseChanges: changes
    | collectChanges classes methods methodsOnly browserClass|

    classes := Set new.
    methods := Set new.
    methodsOnly := true.

    collectChanges := 
        [:each |
            (each isClassChange and:[each changeClass notNil]) ifTrue:[
                classes add: each  changeClass.
                each isMethodCodeChange ifTrue:[
                    each changeMethod notNil ifTrue: [methods add:each changeMethod]
                ] ifFalse:[
                    methodsOnly := false
                ]
            ] ifFalse:[
                each isCompositeChange ifTrue:[
                    each changes do:collectChanges
                ]
            ]
        ].
    changes do: collectChanges.

    browserClass := environment browserClass.
    methodsOnly 
        ifTrue:
            [methods size = 1 
                ifTrue:[ browserClass openInMethod: methods anyOne]
                ifFalse:[ browserClass browseMethods: methods asArray title: 'Selected methods from changeset' sort: true]]
        ifFalse:
            [classes size = 1
                ifTrue:[ browserClass browseClass: classes anyOne]
                ifFalse:[ browserClass browseClasses: classes]]

    "Modified: / 24-10-2009 / 22:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 24-01-2012 / 22:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuDeleteSelection

    self selectionHolder value do:
        [:each|each removed: true].
    self updateList
!

listMenuInspect

    | selection |

    selection := self selectionHolder value collect:[:e|e change].
    selection size = 1
        ifTrue:[selection anyOne inspect]
        ifFalse:[selection inspect].

    "Modified: / 24-10-2009 / 22:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuSelectAdditions

    self listMenuSelectAllSuchThat:[:change|change delta = #+]
!

listMenuSelectAll

    self listMenuSelectAllSuchThat:[:change|true]
!

listMenuSelectAllSuchThat:conditionBlock 
    |newSelection|

    newSelection := self listHolder value 
                select:[:entry | conditionBlock value:entry change ].
    self selectionHolder value:newSelection
!

listMenuSelectNone

    self listMenuSelectAllSuchThat:[:change|false]
!

listMenuSelectRemovals

    self listMenuSelectAllSuchThat:[:change|change delta = #-]
!

listMenuSelectSame

    self listMenuSelectAllSuchThat:[:change|change delta = #=]
!

listMenuSelectUsingBlock

    |conditionBlockString conditionBlock dialog textHolder template|

    template :=
'[:change|
     "/ Define condition for selection below:
     "/ change is an instance of Change
     "/ change will be selected if and only if block returns true

    
     true"/always select the change
]
'.

    LastSelectionConditionString isNil ifTrue:[
        LastSelectionConditionString := template.
    ].


    textHolder := ValueHolder new.
    dialog := Dialog
                 forRequestText:(resources string:'Enter condition for selection')
                 lines:20
                 columns:70
                 initialAnswer:LastSelectionConditionString
                 model:textHolder.
    dialog addButton:(Button label:'Template' action:[textHolder value:template. textHolder changed:#value.]).
    dialog open.
    dialog accepted ifFalse:[^ self].

    conditionBlockString := textHolder value.
    LastSelectionConditionString := conditionBlockString.

    conditionBlock := Parser evaluate:conditionBlockString.
    conditionBlock isBlock ifFalse:[
        self error:'Bad selection block (syntax error?)'.
        ^ self
    ].

    self listMenuSelectAllSuchThat: conditionBlock
!

listMenuUndeleteSelection

    self selectionHolder value do:
        [:each|each removed: false].
    self updateList
! !

!ChangeList methodsFor:'private'!

application

    ^self

    "Created: / 05-12-2009 / 14:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browserNameList

    ^'Change list'

    "Modified: / 24-07-2009 / 22:06:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

iconSelectorForChange:change
    | delta sym selectorOrNil |

    masterApplication notNil ifTrue:[
        selectorOrNil := masterApplication iconSelectorForChange:change.
        selectorOrNil notNil ifTrue:[ ^ selectorOrNil ].
    ].
    delta := change deltaDetail.
    sym := delta shortDeltaSymbol.
    sym = #+ ifTrue:[^#iconPlus].
    sym = #- ifTrue:[^#iconMinus].
    sym = #= ifTrue:[^#iconEqual].
    "/ different.
    ^ nil.
!

listColumn: columnId visible: visible
    visible ifTrue:[
        self listColumnShow: columnId
    ] ifFalse:[
        self listColumnHide: columnId
    ]

    "Created: / 26-07-2012 / 18:20:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listColumnHide: columnId
    self listColumns do:[:spec|
	spec id = columnId ifTrue:[
	    self listColumns remove: spec.
	    listView notNil ifTrue:[
		listView invalidate.
	    ].
	    ^self
	].
    ]

    "Created: / 26-07-2012 / 18:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listColumnShow: columnId

    | columns |
    columns := self listColumns.

    columns do:[:spec|
	spec id = columnId ifTrue:[
	    ^self.
	]
    ].

    self class listColumnSpec do:[:specArray|
	| spec |

	spec := specArray decodeAsLiteralArray.
	spec id = columnId ifTrue:[
	    columnId == #removed ifTrue:[
		columns addFirst: spec.
	    ] ifFalse:[
		columns add: spec.
	    ].
	    listView notNil ifTrue:[
		listView invalidate.
	    ].
	    ^self.
	]

    ].

    "Created: / 26-07-2012 / 17:56:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listEntryFor:chg 
    ^ListEntry change:chg application: self

    "Modified: / 05-12-2009 / 14:39:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent

    "Modified: / 24-07-2009 / 22:06:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

makeIndependent

    "Modified: / 24-07-2009 / 22:06:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parentOrModel

    ^self

    "Created: / 05-12-2009 / 14:14:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawList
    listView notNil ifTrue:[ 
        listView columnView invalidate.
    ].

    "Created: / 24-04-2015 / 00:50:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2015 / 22:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawListItem: item
    | index |

    listView notNil ifTrue:[ 
        index := listView list identityIndexOf: item.
        self redrawListItemAt: index.  
    ]

    "Created: / 25-04-2015 / 22:12:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2015 / 16:19:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawListItemAt: index
    listView notNil ifTrue:[ 
        index ~~ 0 ifTrue:[ 
            listView columnView invalidateRowAt: index.  
         ].
    ]

    "Created: / 25-04-2015 / 22:17:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    |inGenerator changeset firstLineShown oldSel newList newSel|

    self withWaitCursorDo:[
        inGenerator := self inGeneratorHolder value.
        listView notNil ifTrue:[
            ((listView isKindOf: ScrollableView) not or:[listView scrolledView notNil]) ifTrue:[
                firstLineShown := listView firstLineShown
            ].
        ].
        oldSel := self selection.

        changeset := inGenerator isNil ifTrue:[ #() ] ifFalse:[ inGenerator ].
        self showDefinitionsOnlyHolder value ifTrue:[
            newList := changeset select: [:chg | chg isOrContainsClassDefinitionChange ].
        ] ifFalse:[
            self showConflictsOnlyHolder value ifTrue:[
                newList := changeset select: [:chg | chg isConflict ].
            ] ifFalse:[
                | showRemoved showSame |

                showRemoved := self showRemovedHolder value.
                showSame := self showSameHolder value.

                newList := changeset select: [:chg | 
                               (showRemoved or:[ chg removed not ])
                                   and:[showSame or:[chg delta ~~ #=]]
                           ].
            ].
        ].
"/ OLD CODE
"/        newList := changeset
"/                    select:
"/                        [:chg |
"/                        (self showRemovedHolder value or:[ chg removed not ])
"/                            and:[self showSameHolder value or:[chg delta ~~ #=]]
"/                        ].
        newList := self filterList: newList.
        newList := newList collect:[:chg | self listEntryFor:chg ].
        self listHolder value ~= newList ifTrue:[
            self listHolder value: newList.
            ((newList size ~~ 0) and:[scrollToBottom]) ifTrue:[
                self selection: { newList last }
            ] ifFalse:[
                oldSel notEmptyOrNil ifTrue:[
                    newSel := OrderedCollection new: oldSel size.
                    oldSel := oldSel reject:[:e|e isNil].
                    oldSel := oldSel collect:[:e|e change].
                    newList do:[:e|(oldSel includes:e change) ifTrue:[newSel add:e]].
                    self selection: newSel.
                ].
                (listView notNil and:[firstLineShown notNil]) ifTrue:[
                    listView scrollToLine: (newList size min: firstLineShown).
                ].
            ].
            scrollToBottom := false.

        ]
    ]

    "Modified: / 28-12-2011 / 15:46:15 / cg"
    "Modified: / 12-02-2014 / 17:15:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList methodsFor:'queries'!

hasChangeSelected

    ^self selectionHolder value size > 0
!

hasChangeSelectedAndNotRemoved
    | selection |

    selection := self selectionHolder value ? #().
    ^selection size > 0 and: [selection conform:[:e|e removed not]].
!

hasSingleChangeSelected

    ^self selectionHolder value size = 1
!

hasSingleChangeSelectedAndCanBrowse
    self selectionHolder value ? #() do: [:each |
        |chg|

        chg := each change.
        chg isClassChange ifTrue:[
            (chg isMethodChange not or:[chg isMethodCodeChange]) ifFalse:[^ false]
        ].
    ].
    ^ true
!

showColumn: columnSymbol

    ^self showColumnSpecHolder value includes: columnSymbol.

    "Created: / 03-04-2012 / 11:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList::ListEntry class methodsFor:'instance creation'!

change: aChange

    ^self new change: aChange

    "Created: / 24-07-2009 / 22:43:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

change: aChange application: anApplicationModel

    ^self new change: aChange; application: anApplicationModel

    "Created: / 05-12-2009 / 14:16:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

change: aChange parent: aChangeList

    ^self new change: aChange; parent: aChangeList

    "Created: / 25-07-2009 / 23:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ChangeList::ListEntry methodsFor:'accessing'!

application
    ^ application ifNil:[super application]

    "Modified: / 05-12-2009 / 14:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

application:anApplicationModel
    application := anApplicationModel.

    "Modified: / 05-12-2009 / 14:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

change
    ^ change
!

change:aChange
    self assert: ((aChange isKindOf: Change) or:[aChange isKindOf: RefactoryChange]).
    change := aChange.

    "Modified: / 25-07-2009 / 23:40:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 04-12-2011 / 14:58:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeClass

    ^change changeClass
!

changeSource
    "the changes source"

    "/ Hack to make sure code is displayed in similar way
    "/ (i.e., with no namespace pragma)
    ^ (change isClassDefinitionChange and:[change isPrivateClassDefinitionChange]) ifTrue:[
        change definitionStringInNamespace: nil.
    ] ifFalse:[
        change changeSource.
    ].

    "Created: / 19-07-2011 / 12:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-07-2012 / 17:39:39 / cg"
    "Modified: / 14-11-2013 / 14:55:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children
    |app addIf showRemoved showSame|

    children isNil ifTrue:[
        change isCompositeChange ifTrue:[
            app := self application.

            children := OrderedCollection new: change changes size.
            app showDefinitionsOnlyHolder value ifTrue:[
                addIf := [:chg | chg isOrContainsClassDefinitionChange].
            ] ifFalse:[
                app showConflictsOnlyHolder value ifTrue:[
                    addIf := [:chg | chg isConflict].
                ] ifFalse:[
                    showRemoved := app showRemovedHolder value.
                    showSame := app showSameHolder value.

                    addIf := [:chg | 
                                ((showRemoved or:[ chg removed not ])
                                and:[showSame or:[chg delta ~~ #=]])
                             ].
                ]
            ].
            change changes do:[:chg|
                (addIf value:chg) ifTrue:[
                    children add: ((app listEntryFor: chg) parent: self)
                ]
            ].
        ] ifFalse:[
            children :=  #()
        ]
    ].
    ^children

    "Created: / 25-07-2009 / 23:32:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:56:25 / cg"
    "Modified: / 04-12-2011 / 15:08:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delta
    "/ obsolete: please use deltaDetail

    ^change delta

    "Created: / 29-10-2010 / 14:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-08-2011 / 10:30:02 / cg"
!

deltaDetail

    ^change deltaDetail

    "Created: / 29-10-2010 / 14:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 31-08-2011 / 10:29:21 / cg"
!

imageSource
    "return the source for the in-image version of the change"

    ^ change imageSource

    "Created: / 19-07-2011 / 12:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-07-2012 / 17:38:57 / cg"
!

label
    | label |

    label := change displayString.

    "Hack: if the printString contains multiple lines, then
     if there are just 2 lines, then merge them, otherwise add
     ... to the first line"
    (label includes: Character cr) ifTrue:[
        | firstCR secondCR |
        firstCR := label indexOf: Character cr.
        firstCR ~~ label size ifTrue:[
            secondCR := label indexOf: Character cr startingAt: firstCR + 1.
        ].
        secondCR isNil ifTrue:[
            "/2 lines only
            label := label copy at: firstCR put: Character space.
        ] ifFalse:[
            label := (label copyTo: firstCR - 1) , '...'
        ].
    ].
    self removed ifTrue:[label := label withColor: Color gray].
    ^label

    "Created: / 05-11-2008 / 08:20:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-07-2009 / 23:43:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-12-2009 / 14:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:26:34 / cg"
!

labelAndIcon
    ^(LabelAndIcon label: self label icon: self iconDelta)

    "Created: / 01-08-2012 / 18:14:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notRemoved
    ^ self removed not

    "Created: / 26-07-2012 / 18:31:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notRemoved: aBoolean
    ^ self removed: aBoolean not

    "Created: / 26-07-2012 / 18:31:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removed
    ^ change removed == true

    "Modified: / 26-07-2012 / 18:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removed:aBoolean
    change removed: aBoolean.
    self redraw.

    "Modified: / 25-04-2015 / 22:13:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source

    ^change source
!

timeStamp
    ^change timeOfChangeIfKnown

    "Created: / 26-07-2012 / 18:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

x
    ^ x
! !

!ChangeList::ListEntry methodsFor:'displaying'!

displayLabel:aLabel h:lH on:aGC x:newX y:y h:h
    self displayLabel:aLabel h:lH on:aGC x:newX y:y h:h isHighlightedAsSelected:false
!

displayLabel:aLabel h:lH on:aGC x:newX y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    | list cx icon |

    list := self application.
    cx := x := newX.
    (list allowRemoveHolder value and:[list showRemovedHolder value]) ifTrue: [
        (icon := self iconRemoved) notNil ifTrue:[
            icon displayOn: aGC x: cx y: y + (h / 2) - (icon height / 2)
        ].
        cx := cx + 22."experimental value - this looks good"
    ].
    (icon := self iconDelta) notNil ifTrue:[
        icon displayOn: aGC x: cx y: y + (h / 2) - (icon height / 2)
    ].
    cx := cx + 16."12 + 2px gap"

    super displayLabel:aLabel h:lH on:aGC x:cx y:y h:h isHighlightedAsSelected:isHighlightedAsSelected.

"/    "Now, display additional columns..."
"/    (list showColumn: #timestamp) ifTrue:[
"/        cx := cx + (aLabel widthOn: aGC) + 5."px - padding"
"/        colS := change timeOfChangeIfKnown notNil
"/                    ifTrue:[change timeOfChangeIfKnown printString]
"/                    ifFalse:['???'].
"/        [ (colW := colS widthOn: aGC) > (aGC width - cx - 5) ] whileTrue:[
"/            colS = '...' ifTrue:[ ^ self ].
"/            colS := '...' , (colS copyFrom: 6).
"/        ].
"/        super displayLabel:colS h:lH on:aGC x: (aGC width - 5 - colW) y:y h:h.
"/    ].

    "Modified: / 27-07-2012 / 17:13:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iconDelta
    | iconSelector |

    iconSelector := self iconSelector.
    iconSelector isNil ifTrue:[^nil].
    self removed ifTrue:[iconSelector := iconSelector , #Grayed].
    ^self application class perform: iconSelector asSymbol.

    "Created: / 05-12-2009 / 14:11:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:56:33 / cg"
!

iconRemoved
    |appClass|

    appClass := self application class.
    ^self removed 
        ifTrue: [appClass uncheckedIcon ]
        ifFalse:[appClass checkedIcon ]

    "Created: / 05-12-2009 / 14:11:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iconSelector
    ^ application iconSelectorForChange:change
! !

!ChangeList::ListEntry methodsFor:'protocol-queries'!

hasChildren
    ^ change isCompositeChange and:[change changes notEmptyOrNil ].

    "Created: / 04-12-2011 / 14:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:25:34 / cg"
! !

!ChangeList::ListEntry methodsFor:'redrawing'!

redraw
    "Trigger redraw of reciver."
    application redrawListItem: self

    "Created: / 25-04-2015 / 22:10:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

