"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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

BrowserListWithFilter subclass:#ChangeSetDiffList
	instanceVariableNames:'listHolder listSelectionHolder listEntryLabelGenerator
		listEntryIconGenerator showVersionMethodDiffsHolder
		showCopyrightMethodDiffsHolder highlightConflictsHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

Object subclass:#ListEntry
	instanceVariableNames:'model application'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetDiffList
!

!ChangeSetDiffList class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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

!ChangeSetDiffList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffList andSelector:#windowSpec
     Tools::ChangeSetDiffList new openInterface:#windowSpec
     Tools::ChangeSetDiffList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Diff List'
          name: 'Diff List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (InputFieldSpec
              name: 'Filter'
              layout: (LayoutFrame 0 0 0 0 0 1 22 0)
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
           (SelectionInListModelViewSpec
              name: 'List'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: listSelectionHolder
              menu: menuHolderWithShowFilter
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: listHolder
              multipleSelectOk: true
              useIndex: false
              highlightMode: line
              ignoreReselect: false
              postBuildCallback: postBuildListView:
            )
           )
         
        )
      )
! !

!ChangeSetDiffList class methodsFor:'plugIn spec'!

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
        #highlightConflictsHolder
        #inGeneratorHolder
        #listEntryIconGenerator
        #listEntryLabelGenerator
        #menuHolder
        #outGeneratorHolder
        #showCopyrightMethodDiffsHolder
        #showFilterHolder
        #showVersionMethodDiffsHolder
      ).

    "Modified: / 24-02-2014 / 10:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList methodsFor:'accessing'!

listEntryIconGenerator
    ^ listEntryIconGenerator
!

listEntryIconGenerator:aBlock
    listEntryIconGenerator := aBlock.
!

listEntryLabelGenerator
    ^ listEntryLabelGenerator
!

listEntryLabelGenerator:aBlock
    listEntryLabelGenerator := aBlock.
!

selection: entry
    self updateList.
    self selectionHolder value: (Array with: entry).

    "Created: / 17-01-2013 / 13:41:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 16:37:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList methodsFor:'aspects'!

highlightConflictsHolder
    "return/create the 'highlightConflictsHolder' value holder (automatically generated)"

    highlightConflictsHolder isNil ifTrue:[
        highlightConflictsHolder := ValueHolder new.
        highlightConflictsHolder addDependent:self.
    ].
    ^ highlightConflictsHolder

    "Modified (format): / 03-08-2012 / 14:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightConflictsHolder:something
    "set the 'highlightConflictsHolder' value holder (automatically generated)"

    |oldValue newValue|

    highlightConflictsHolder notNil ifTrue:[
        oldValue := highlightConflictsHolder value.
        highlightConflictsHolder removeDependent:self.
    ].
    highlightConflictsHolder := something.
    highlightConflictsHolder notNil ifTrue:[
        highlightConflictsHolder addDependent:self.
    ].
    newValue := highlightConflictsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:highlightConflictsHolder.
    ].
!

listHolder
    "return/create the 'difflistHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder
!

listSelectionHolder
    "return/create the 'listSelectionHolder' value holder (automatically generated)"

    listSelectionHolder isNil ifTrue:[
        listSelectionHolder := ValueHolder new.
        listSelectionHolder addDependent:self.
    ].
    ^ listSelectionHolder

    "Modified: / 17-01-2013 / 16:51:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCopyrightMethodDiffsHolder
    "return/create the 'showCopyrightMethodDiffsHolder' value holder (automatically generated)"

    showCopyrightMethodDiffsHolder isNil ifTrue:[
        showCopyrightMethodDiffsHolder := ValueHolder new.
        showCopyrightMethodDiffsHolder addDependent:self.
    ].
    ^ showCopyrightMethodDiffsHolder
!

showCopyrightMethodDiffsHolder:something
    "set the 'showCopyrightMethodDiffsHolder' value holder (automatically generated)"

    |oldValue newValue|

    showCopyrightMethodDiffsHolder notNil ifTrue:[
        oldValue := showCopyrightMethodDiffsHolder value.
        showCopyrightMethodDiffsHolder removeDependent:self.
    ].
    showCopyrightMethodDiffsHolder := something.
    showCopyrightMethodDiffsHolder notNil ifTrue:[
        showCopyrightMethodDiffsHolder addDependent:self.
    ].
    newValue := showCopyrightMethodDiffsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showCopyrightMethodDiffsHolder.
    ].
!

showVersionMethodDiffsHolder
    "return/create the 'showVersionMethodDiffsHolder' value holder (automatically generated)"

    showVersionMethodDiffsHolder isNil ifTrue:[
        showVersionMethodDiffsHolder := ValueHolder new.
        showVersionMethodDiffsHolder addDependent:self.
    ].
    ^ showVersionMethodDiffsHolder
!

showVersionMethodDiffsHolder:something
    "set the 'showVersionMethodDiffsHolder' value holder (automatically generated)"

    |oldValue newValue|

    showVersionMethodDiffsHolder notNil ifTrue:[
        oldValue := showVersionMethodDiffsHolder value.
        showVersionMethodDiffsHolder removeDependent:self.
    ].
    showVersionMethodDiffsHolder := something.
    showVersionMethodDiffsHolder notNil ifTrue:[
        showVersionMethodDiffsHolder addDependent:self.
    ].
    newValue := showVersionMethodDiffsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showVersionMethodDiffsHolder.
    ].
! !

!ChangeSetDiffList methodsFor:'change & update'!

enqueueDelayedUpdate:something with:aParameter from:changedObject
    immediateUpdate value ifTrue:[
        self delayedUpdate:something with:aParameter from:changedObject
    ] ifFalse:[
        super enqueueDelayedUpdate:something with:aParameter from:changedObject
    ]

    "Created: / 17-01-2013 / 16:25:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listSelectionChanged
    | lsel |

    lsel := listSelectionHolder value ? #().
    self selectionHolder 
        removeDependent: self;
        value: (lsel collect:[:e | e model ]);
        addDependent: self.
    self enqueueDelayedUpdateOutputGenerator

    "Created: / 17-01-2013 / 14:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 16:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionChanged
    | sel lsel llist |

    listSelectionHolder isNil ifTrue:[ ^ self ].

    listSelectionHolder removeDependent: self.
    sel := (self selectionHolder value) ? #().
    llist := self listHolder value.
    lsel := llist select:[:leach | sel includesIdentical: leach model].
    listSelectionHolder value: lsel.
    listSelectionHolder addDependent: self.

    super selectionChanged.

    "Created: / 17-01-2013 / 14:11:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 16:36:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: aspect with: param from: sender

    aspect == #resolution ifTrue:[^(self componentAt: #List) invalidateRepairNow: true].

    sender == listSelectionHolder ifTrue:[
        self listSelectionChanged.
        ^self
    ].
        
    sender == selectionHolder ifTrue:[
        self selectionChanged.
        ^self.
    ].
    sender == showVersionMethodDiffsHolder ifTrue:[
        ^self updateList.
        self.
    ].

    sender == showCopyrightMethodDiffsHolder ifTrue:[
        ^self updateList.
        self.
    ].

    sender == highlightConflictsHolder ifTrue:[
        listView notNil ifTrue:[
            listView scrolledView invalidate.
        ].
        ^self.
    ].



    super update: aspect with: param from: sender.

    "Modified: / 17-01-2013 / 15:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList methodsFor:'generators'!

makeGenerator

    ^Iterator on:
        [:whatToDo|
        self selectionHolder value do:
            [:each|each notNil ifTrue:[each do: whatToDo]]]

    "Modified: / 17-01-2013 / 17:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ listHolder := nil.
    "/ listSelectionHolder := nil.
    "/ listEntryLabelGenerator := nil.
    "/ listEntryIconGenerator := nil.
    "/ showVersionMethodDiffsHolder := nil.
    "/ showCopyrightMethodDiffsHolder := nil.
    "/ highlightConflictsHolder := nil.

    super initialize.
    immediateUpdate := true asValue.

    "Modified: / 17-01-2013 / 16:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList methodsFor:'private'!

listEntryIconFor:aDiffComponent 
    |a hasA b hasB hasBase|

    aDiffComponent isDiffSet ifTrue:[
        ^ nil
    ].
    hasA := (a := aDiffComponent versionA) notNil and:[a isMethodRemoveChange not].
    hasB := (b := aDiffComponent versionB) notNil and:[b isMethodRemoveChange not].
    hasBase := aDiffComponent versionBase notNil.
    (hasA & hasB & hasBase) ifTrue:[
        ^ ToolbarIconLibrary versionABBase12x12 
    ].
    (hasA & hasB) ifTrue:[
        ^ ToolbarIconLibrary versionAB12x12
    ].
    (hasA & hasBase) ifTrue:[
        ^ ToolbarIconLibrary versionABase12x12
    ].
    (hasA) ifTrue:[
        ^ ToolbarIconLibrary versionA12x12
    ].
    (hasB & hasBase) ifTrue:[
        ^ ToolbarIconLibrary versionBBase12x12
    ].
    (hasB) ifTrue:[
        ^ ToolbarIconLibrary versionB12x12
    ].
    ^ nil

    "Created: / 21-11-2009 / 21:58:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2011 / 08:19:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2011 / 16:38:33 / jv"
!

listEntryLabelFor:diff 

    ^listEntryLabelGenerator isNil 
           ifTrue:[ diff name ]
           ifFalse:[ listEntryLabelGenerator value:diff ]

    "Modified: / 16-11-2015 / 11:57:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeDependent

    "Nothing to do"
!

makeIndependent

    "Nothing to do"
!

shouldDisplayDiff: aDiffCompoment
    "Return true if given diff component should be displayed"

    (showVersionMethodDiffsHolder value not and:[aDiffCompoment isForVersionMethod])
        ifTrue:[ ^ false ].

    (showCopyrightMethodDiffsHolder value not and:[aDiffCompoment isForCopyrightMethod])
        ifTrue:[ ^ false ].

    aDiffCompoment isDiffSet 
        ifTrue:[ ^ aDiffCompoment diffs anySatisfy:[:diff|self shouldDisplayDiff: diff]].

    ^true

    "Created: / 03-08-2012 / 14:38:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    "Superclass Tools::BrowserList says that I am responsible to implement this method"
    
    | newDiffs newList |
    self listHolder value ? #() do: [:entry|entry model removeDependent: self].

    newDiffs := self inGeneratorHolder value ? #().
    (newDiffs isKindOf: ChangeSetDiffComponent) ifTrue:
        [newDiffs := newDiffs diffs].
    newDiffs := self filterList: newDiffs.
    newList := OrderedCollection new.    
    newDiffs do: [:item|
        (self shouldDisplayDiff: item) ifTrue:[
            newList add:(ListEntry model: item application: self).
            item addDependent: self
        ].
    ].

    newList sort:[:a :b|a label < b label].
    self listHolder value:newList

    "Modified: / 07-07-2011 / 14:17:26 / jv"
    "Modified: / 30-07-2013 / 19:30:18 / cg"
    "Modified: / 11-11-2013 / 11:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList::ListEntry class methodsFor:'instance creation'!

model: model application: application

    ^self new
        model: model;
        application: application

    "Created: / 24-11-2009 / 18:29:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList::ListEntry methodsFor:'accessing'!

application
    ^ application
!

application:aDiffList
    application := aDiffList.
!

icon

    ^application 
        ifNotNil:[application listEntryIconFor: model]
        ifNil:[nil]

    "Created: / 24-11-2009 / 18:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^application isNil 
           ifTrue:[ model displayString ]
           ifFalse:[ application listEntryLabelFor:model ]

    "Created: / 24-11-2009 / 18:26:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2015 / 11:55:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model
    ^ model
!

model:aDiffComponent
    model := aDiffComponent.
! !

!ChangeSetDiffList::ListEntry methodsFor:'displaying'!

displayOn: aGC x: x y: y opaque: opaque

    | label icon oldPaint |
    label := self label.
"/    ((application topApplication askFor:#isMerge) and:[model isMerged not]) ifTrue:[
    (application highlightConflictsHolder value and:[model "isConflict"isMerged not]) ifTrue:[
        oldPaint := aGC paint.
        aGC paint: TextDiff3Tool colorConflict.
        '!!' displayOn: aGC x: x  y:y opaque: opaque.
        aGC paint: oldPaint.
        label := label asText allBold"/; colorizeAllWith: Color red darker.
    ].
    (icon := self icon) notNil ifTrue:[icon displayOn: aGC x: x + 10 y: y - icon height opaque: opaque].
    label displayOn: aGC x: x + 10 + 16 y:y opaque: opaque

    "Created: / 24-11-2009 / 18:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 11:35:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffList class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ChangeSetDiffList.st,v 1.10 2014-03-05 18:30:16 vrany Exp $'
!

version_SVN
    ^ '$Id: Tools__ChangeSetDiffList.st,v 1.10 2014-03-05 18:30:16 vrany Exp $'
! !

