"{ Encoding: utf8 }"

"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015-2017 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractDIalog subclass:#AbstractListDialog
	instanceVariableNames:'matchingObjectsView matchingObjectsMultiselect
		matchingObjectsTree matchingObjectsSelectionHolder
		matchingObjectsLabelHolder matchingObjectsUpdateJob
		matchPatternHolder matchPatternView environmentHolder
		filterHolder filter nextSearchStepVisibleHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!AbstractListDialog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015-2017 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!AbstractListDialog class methodsFor:'interface specs-content'!

contentPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::AbstractListDialog andSelector:#contentPaneSpec
     SmallSense::AbstractListDialog new openInterface:#contentPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: contentPaneSpec
       window: 
      (WindowSpec
         label: 'Search...'
         name: 'Search...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 708 404)
         menu: mainMenuSpec
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'Content'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: topSpaceFit
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Enter name prefix or pattern (*):'
                         name: 'PatternLabel'
                         layout: (LayoutFrame 0 0 0 0 -100 1 0 1)
                         translateLabel: true
                         adjust: left
                       )
                      (UISubSpecification
                         name: 'SubSpecification1'
                         layout: (LayoutFrame -100 1 0 0 0 1 0 1)
                         visibilityChannel: hasOptions
                         minorKey: optionsShowHideRightAlignedPaneSpec
                       )
                      )
                    
                   )
                   extent: (Point 708 30)
                 )
                (InputFieldSpec
                   name: 'Pattern'
                   model: matchPatternHolder
                   immediateAccept: true
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnPointerLeave: true
                   entryCompletionBlock: matchPatternCompletionBlock
                   extent: (Point 706 24)
                   usePreferredHeight: true
                   postBuildCallback: postBuildMatchPatternView:
                 )
                (ViewSpec
                   name: 'Box2'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Matching items:'
                         name: 'MatchingLabel'
                         layout: (LayoutFrame 0 0 0 0 -25 1 0 1)
                         translateLabel: true
                         labelChannel: matchingObjectsLabelHolder
                         adjust: left
                       )
                      (LabelSpec
                         label: '->'
                         name: 'Label1'
                         layout: (LayoutFrame -25 1 0 0 0 1 0 1)
                         visibilityChannel: nextSearchStepVisibleHolder
                         translateLabel: true
                         labelChannel: nextSearchStepLabel
                       )
                      )
                    
                   )
                   extent: (Point 708 25)
                 )
                (HierarchicalListViewSpec
                   name: 'HierarchicalListView1'
                   model: matchingObjectsSelectionHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: matchingObjectsTree
                   multipleSelectOk: true
                   useIndex: false
                   highlightMode: line
                   doubleClickSelector: doAcceptByDoubleClick
                   selectConditionSelector: canSelectIndex:
                   showLines: false
                   showIndicators: false
                   showLeftIndicators: false
                   useDefaultIcons: false
                   showRoot: false
                   extent: (Point 708 303)
                   postBuildCallback: postBuildMatchingObjectsView:
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!AbstractListDialog class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractListDialog.
! !

!AbstractListDialog methodsFor:'accessing'!

environment
    ^ self environmentHolder value

    "Created: / 22-04-2014 / 10:45:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment: aJavaClassEnvironment
    ^self environmentHolder value: aJavaClassEnvironment

    "Created: / 22-04-2014 / 10:46:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filter
    ^self filterHolder value.

    "Created: / 11-03-2013 / 17:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filter: aBlock
    self filterHolder value: aBlock

    "Created: / 10-05-2014 / 00:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsSelection
    ^ self matchingObjectsSelectionHolder value

    "Created: / 10-05-2014 / 00:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsSelection: selection
    self matchingObjectsSelectionHolder value: selection withoutNotifying:self.
    self updateAcceptEnabled.

    "Created: / 02-05-2014 / 12:26:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 13:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

multiselect
    ^ matchingObjectsMultiselect

    "Created: / 10-05-2014 / 11:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

multiselect: aBoolean
    matchingObjectsMultiselect := aBoolean.
    matchingObjectsView notNil ifTrue:[
        matchingObjectsView multipleSelectOk: aBoolean
    ].

    "Created: / 10-05-2014 / 11:22:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pattern
    ^self matchPatternHolder value.

    "Created: / 11-03-2013 / 14:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pattern: aString
    ^self matchPatternHolder value: aString

    "Created: / 11-03-2013 / 15:21:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection: selection
    | matchingObjectsSelection |

    matchingObjectsMultiselect ifTrue:[
        matchingObjectsSelection := selection collect:[ :each | matchingObjectsTree root recursiveDetect: [ :po | (po isKindOf: PO) and:[ po subject = each ] ] ].
        matchingObjectsSelection := matchingObjectsSelection reject:[:each | each isNil ].
    ] ifFalse:[
        matchingObjectsSelection := matchingObjectsTree root recursiveDetect: [ :po | (po isKindOf: PO) and:[ po subject = selection ] ]
    ].
    self matchingObjectsSelection: matchingObjectsSelection.

    "Created: / 10-05-2014 / 00:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-01-2015 / 10:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title
    ^ self titleHolder value.

    "Created: / 05-05-2014 / 23:35:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString
    | title |


    title := aString.
    (title includes: Character cr) ifTrue:[
        title := title upTo:Character cr.
    ].
    self titleHolder value: title

    "Created: / 05-05-2014 / 23:36:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2014 / 01:22:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'accessing - private'!

matchingObjectForString: aString
    "Creates a new object from given string. Called only when
     #canCreateMatchingObjectFromString: returns true"

    (self canCreateMatchingObjectFromString:aString) ifFalse:[
        self shouldNeverBeSent
    ] ifTrue:[
        self subclassResponsibility
    ]

    "Created: / 23-06-2014 / 15:20:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'accessing-defaults'!

defaultTitle
    ^ (resources string: 'Search...')

    "Created: / 05-05-2014 / 23:39:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'aspects'!

environmentHolder
    "return/create the 'registryHolder' value holder (automatically generated)"

    environmentHolder isNil ifTrue:[
        environmentHolder := Smalltalk asValue.
        environmentHolder addDependent:self.
    ].
    ^ environmentHolder

    "Created: / 22-04-2014 / 10:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 00:04:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environmentHolder:something
    "set the 'registryHolder' value holder (automatically generated)"

    |oldValue newValue|

    environmentHolder notNil ifTrue:[
        oldValue := environmentHolder value.
        environmentHolder removeDependent:self.
    ].
    environmentHolder := something.
    environmentHolder notNil ifTrue:[
        environmentHolder addDependent:self.
    ].
    newValue := environmentHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:environmentHolder.
    ].

    "Created: / 22-04-2014 / 10:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filterHolder
    "return/create the 'filterHolder' value holder (automatically generated)"

    filterHolder isNil ifTrue:[
        filterHolder := ValueHolder new.
        filterHolder addDependent:self.
    ].
    ^ filterHolder
!

filterHolder:something
    "set the 'filterHolder' value holder (automatically generated)"

    |oldValue newValue|

    filterHolder notNil ifTrue:[
        oldValue := filterHolder value.
        filterHolder removeDependent:self.
    ].
    filterHolder := something.
    filterHolder notNil ifTrue:[
        filterHolder addDependent:self.
    ].
    newValue := filterHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:filterHolder.
    ].
!

matchPatternCompletionBlock
    ^ [ :contents :field |
        | completion |
        (contents notEmptyOrNil and:[ matchingObjectsUpdateJob running not]) ifTrue:[
            field topView withCursor:(Cursor questionMark) do:[
                completion := self matchPatternCompletionFor: contents
            ].
        ].
        completion notNil ifTrue:[
            self enqueueDelayedAction:[  
                matchPatternHolder value: completion first withoutNotifying: self.   
                "/ field contents: completion first.
            ].
            completion second size == 1 ifTrue:[
                matchingObjectsMultiselect ifTrue:[
                    self matchingObjectsSelection: completion second asArray
                ] ifFalse:[
                    self matchingObjectsSelection: completion second anElement.
                ].
            ].
        ] ifFalse:[
            matchingObjectsView flash.
        ]
    ]

    "Created: / 28-04-2014 / 22:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2015 / 11:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchPatternHolder
    <resource: #uiAspect>

    matchPatternHolder isNil ifTrue:[
        matchPatternHolder := ValueHolder new.
    ].
    ^ matchPatternHolder.

    "Modified: / 25-11-2014 / 13:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsLabelHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    matchingObjectsLabelHolder isNil ifTrue:[
        matchingObjectsLabelHolder := ValueHolder with:(resources string:'Matching items:').
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       matchingLabelHolder addDependent:self.
"/       matchingLabelHolder onChangeSend:#matchingLabelHolderChanged to:self.
    ].
    ^ matchingObjectsLabelHolder.

    "Created: / 28-04-2014 / 22:29:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsSelectionHolder
    "return/create the 'matchingClassesSelectionHolder' value holder (automatically generated)"

    matchingObjectsSelectionHolder isNil ifTrue:[
        matchingObjectsSelectionHolder := ValueHolder new.
        matchingObjectsSelectionHolder addDependent:self.
    ].
    ^ matchingObjectsSelectionHolder

    "Modified: / 08-03-2013 / 14:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsSelectionHolder:something
    "set the 'matchingClassesSelectionHolder' value holder (automatically generated)"

    matchingObjectsSelectionHolder := something.
!

matchingObjectsTree
    <resource: #uiAspect>
    matchingObjectsTree isNil ifTrue:[
        matchingObjectsTree := HierarchicalList new.
        matchingObjectsTree showRoot:false.
        matchingObjectsTree root:(HierarchicalItem new).
        matchingObjectsTree application:self.
        self updateNoResults:matchingObjectsTree root.
    ].
    ^ matchingObjectsTree.

    "Created: / 08-03-2013 / 15:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-04-2014 / 23:41:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextSearchStepLabel
    ^ OperatingSystem isUNIXlike ifTrue:[ '→' ] ifFalse:[ '->' ].

    "Created: / 23-01-2015 / 21:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextSearchStepVisibleHolder
    <resource: #uiAspect>

    nextSearchStepVisibleHolder isNil ifTrue:[
        nextSearchStepVisibleHolder := false asValue.
    ].
    ^ nextSearchStepVisibleHolder.

    "Modified: / 23-01-2015 / 22:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'aspects-queries'!

hasFilter
    ^self filterHolder value notNil

    "Created: / 08-03-2013 / 15:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2013 / 17:34:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'change & update'!

enqueueDelayedUpdateMatchingObjectPOs: matchingPOsArg
    self enqueueMessage: #delayedUpdateMatchingObjectPOs: for: self arguments: (Array with: matchingPOsArg)

    "Created: / 21-02-2015 / 08:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == matchPatternHolder ifTrue:[
        matchingObjectsUpdateJob restart.
        self updateAcceptEnabled.
        ^ self.
    ].
    changedObject == matchingObjectsSelectionHolder ifTrue:[
        self updateMatchPatternHolderFromSelection.
        self updateAcceptEnabled.
        ^ self.
    ].
    changedObject == accept ifTrue:[
        accept value ifTrue:[
            self updateAcceptedValue.
        ].
        ^ self.
    ].
    changedObject == filterHolder ifTrue:[
        (filter notNil and:[filter isBlock not and:[(filter isKindOf: MessageSend) not]]) ifTrue:[filter removeDependent: self].
        filter := filterHolder value.
        (filter notNil and:[filter isBlock not and:[(filter isKindOf: MessageSend) not]]) ifTrue:[filter addDependent: self].
        "/ Only do this after window is opened....
        (self builder notNil and:[ self builder window notNil  ]) ifTrue:[
            matchingObjectsUpdateJob restart.
        ].
         ^ self.
    ]    .
    changedObject == filter ifTrue:[
        matchingObjectsUpdateJob restart.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 21-02-2015 / 08:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAcceptEnabled
    self acceptEnabledHolder value:
        (matchingObjectsSelectionHolder value notEmptyOrNil
            or:[ self canCreateMatchingObjectFromString:self matchPatternHolder value ])

    "Created: / 08-03-2013 / 14:06:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-01-2015 / 11:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAcceptedValue
    "Dialog has been accepted (OK pressed). Update accepted value"

    | matchingObjectsSelection |

    matchingObjectsSelection := matchingObjectsSelectionHolder value.
    matchingObjectsMultiselect ifTrue:[ 
        matchingObjectsSelection := matchingObjectsSelection select:[:e | matchingObjectsTree includes: e]
    ] ifFalse:[
        (matchingObjectsTree includes: matchingObjectsSelection) ifFalse:[ 
            matchingObjectsSelection := nil.
        ].
    ].
    matchingObjectsSelection isEmptyOrNil ifTrue:[
        (self canCreateMatchingObjectFromString:matchPatternView contents) ifTrue:[
            acceptedValue := self matchingObjectForString: matchPatternView contents.
            matchingObjectsMultiselect ifTrue:[ 
                acceptedValue := Array with: acceptedValue
            ].
        ].
    ] ifFalse:[
        acceptedValue := matchingObjectsMultiselect
            ifTrue:[ matchingObjectsSelection collect:[:e|e subject] ]
            ifFalse:[ matchingObjectsSelection subject ]
    ].

    "Created: / 19-06-2014 / 11:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2016 / 22:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMatchPatternHolderFromSelection
    | pattern selection |

    "/ Do not update pattern if it contains match characters
    pattern := matchPatternHolder value.
    pattern notEmptyOrNil ifTrue:[
        (pattern first isSeparator or:[pattern includesAny: '*?']) ifTrue:[
            ^self
        ]
    ].
    selection := matchingObjectsSelectionHolder value.
    selection isSequenceable ifTrue:[
        selection size == 1 ifTrue:[
            selection := selection anElement.
        ] ifFalse:[
            selection := nil.
        ]
    ].
    selection notNil ifTrue:[
        matchPatternHolder value: selection label withoutNotifying: self.
        matchPatternView notNil ifTrue:[
            matchPatternView selectAll.
        ]
    ].

    "Created: / 06-10-2014 / 23:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 13:23:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMatchingLabelToNormal
    self matchingObjectsLabelHolder value: (resources string: 'Matching items:').

    "Created: / 18-03-2013 / 14:02:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 22:29:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMatchingLabelToRecentSearches
    self matchingObjectsLabelHolder value: (resources string: 'Recently searched:').

    "Created: / 30-04-2014 / 11:47:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMatchingLabelToSearching
    self matchingObjectsLabelHolder value: (resources string: 'Searching...').

    "Created: / 18-03-2013 / 14:01:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 22:29:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateNoResults: root
    | items |

    items := (Array with: ((HierarchicalItemWithLabel new parent: root; label:((resources string:'No search results...') asText colorizeAllWith: Color gray)))).
    self enqueueDelayedUpdateMatchingObjectPOs: items.

    "Created: / 11-03-2013 / 14:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:58:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'change & update-background'!

updateMatching
    | pattern pos |

    self assert: [ Processor activeProcess == matchingObjectsUpdateJob thread ] message: 'This method can be called only from background update job'.

    self matchPatternHolder value notEmptyOrNil ifTrue:[
        pattern := StringPattern fromString: self matchPatternHolder value.
        pos := self matchingObjectPOsForPattern: pattern.
        self enqueueDelayedUpdateMatchingObjectPOs: pos.
        self updateMatchingLabelToNormal
    ] ifFalse:[
        self updateMatchingIgnorePattern
    ].

    "Created: / 12-12-2014 / 23:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMatchingIgnorePattern

    self assert: [ Processor activeProcess == matchingObjectsUpdateJob thread ] message: 'This method can be called only from background update job'.

    self enqueueDelayedUpdateMatchingObjectPOs: (self matchingObjectPOsForPattern: nil)

    "Created: / 12-12-2014 / 23:39:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'change & update-delayed'!

delayedUpdateMatchingObjectPOs: matchingPOsArg
    | rootPO matchPatternString  |

    rootPO := self matchingObjectsTree root.
    rootPO
        children:matchingPOsArg;
        expand.
    matchPatternString := self matchPatternHolder value.
    matchPatternString isEmptyOrNil ifTrue:[ 
        ^ self.
    ].
    (matchingPOsArg size == 1 and:[ (self canCreateMatchingObjectFromString: self matchPatternHolder value) not ]) ifTrue:[
        matchingObjectsMultiselect ifTrue:[
            self matchingObjectsSelection: matchingPOsArg
        ] ifFalse:[
            self matchingObjectsSelection: matchingPOsArg anElement
        ]
    ].

    "Created: / 12-12-2014 / 23:32:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2015 / 18:41:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'event processing'!

handlesKeyPress: key inView: view
    view == matchingObjectsView ifTrue:[ 
        ^ key == #CursorLeft 
            or:[ key == #CursorRight
            or:[ key == #BackSpace ]]
    ].
    ^ false

    "Created: / 23-01-2015 / 22:35:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-06-2015 / 17:37:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress: key x:x y:y view: view
    view == matchingObjectsView ifTrue:[ 
        (key == #BackSpace) ifTrue:[ 
            ^ self keyPressBackSpaceInMatchingObjectsView.
        ].
        key == #CursorRight ifTrue:[ 
            ^ self keyPressCursorRightInMatchingObjectsView.
        ].
        key == #CursorLeft ifTrue:[ 
            ^ self keyPressCursorLeftInMatchingObjectsView.
        ].
    ].
    ^ false

    "Created: / 23-01-2015 / 22:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-06-2015 / 17:37:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressBackSpaceInMatchingObjectsView
    matchingObjectsView windowGroup focusView:matchPatternView byTab:true.
    matchPatternView keyPress: #BackSpace x: 0 y: 0.
    ^ true

    "Created: / 15-06-2015 / 17:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressCursorDownInPatternView

    matchingObjectsView hasSelection ifFalse:[
        matchingObjectsView selectFirst.
    ] ifTrue:[
        matchingObjectsView selectNext.
    ].
    matchingObjectsView windowGroup focusView:matchingObjectsView byTab:true.

    "Created: / 22-04-2014 / 11:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressCursorLeftInMatchingObjectsView
    matchingObjectsView windowGroup focusView:matchPatternView byTab:true.
    matchPatternView keyPress: #CursorLeft x: 0 y: 0.
    ^ true

    "Created: / 23-01-2015 / 22:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressCursorRightInMatchingObjectsView
    matchingObjectsView windowGroup focusView:matchPatternView byTab:true.
    matchPatternView keyPress: #CursorRight x: 0 y: 0.
    ^ true

    "Created: / 23-01-2015 / 22:41:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'events'!

closeCancel
    "cancel was pressed. close the dialog"

    accept setValue: nil.
    ^ super closeCancel.

    "Created: / 28-04-2014 / 23:56:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'forced actions'!

doAcceptByDoubleClick
    self acceptEnabledHolder value ifTrue:[
        self doAccept
    ].

    "Created: / 08-03-2013 / 14:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAcceptByReturnKey
    self acceptEnabledHolder value ifTrue:[
        super doAcceptByReturnKey
    ].

    "Created: / 08-03-2013 / 14:14:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'hooks'!

commonPostBuild

    matchPatternHolder addDependent:self.
    matchPatternView selectAll.

    matchingObjectsUpdateJob restart:[ self updateMatchingIgnorePattern].
    self updateAcceptEnabled.
    self updateMatchPatternHolderFromSelection.
    super commonPostBuild

    "Created: / 25-11-2014 / 13:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 17:49:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commonPreOpen
    | selection |
    selection := self matchingObjectsSelection.
    selection notEmptyOrNil ifTrue:[ 
        matchingObjectsView makeSelectionVisible
    ].
    super commonPreOpen

    "Created: / 09-01-2015 / 11:09:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildMatchPatternView:aView
    matchPatternView := aView scrolledView.
"/    matchPatternView delegate: self.
    matchPatternView onKey:#CursorDown leaveWith:[ self keyPressCursorDownInPatternView ]

    "Created: / 28-04-2014 / 22:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildMatchingObjectsView:aView
    matchingObjectsView := aView scrolledView.
    matchingObjectsView delegate: self.
    matchingObjectsView multipleSelectOk: matchingObjectsMultiselect

    "Created: / 22-04-2014 / 13:21:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-05-2014 / 11:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.

    "/ please change as required (and remove this comment)
    "/ acceptEnabledHolder := nil.
    "/ allClassesHolder := nil.
    "/ matchingClassesList := nil.
    "/ matchingClassesHolder := nil.
    "/ matchPatternHolder := nil.
    "/ matchingUpdateJob := nil.

    self accept addDependent: self.
    self matchingObjectsTree. "/force its initialization
    matchingObjectsUpdateJob := BackgroundJob named: 'SmallSense search dialog updater' on:[self updateMatching].
    matchingObjectsMultiselect := false.

    "Modified: / 13-12-2014 / 08:46:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'opening-dialogInterface'!

openInterface:aSymbol
    "open a standard interface.
     Redefined to return the acceptedValue"

    super openInterface:aSymbol.
    ^ acceptedValue

    "Created: / 13-03-2017 / 22:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'queries'!

canCreateMatchingObjectFromString:string
    "Return true, a new object can be created with given string value"

    ^ false

    "Created: / 23-06-2014 / 15:14:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSelect: selection
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Modified (format): / 28-04-2014 / 00:11:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSelectIndex: selectionIndex
    (selectionIndex between: 1 and: matchingObjectsTree size) ifTrue:[
        ^ self canSelect: (matchingObjectsTree at: selectionIndex)
    ].
    ^ false

    "Created: / 02-05-2014 / 23:52:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasOptions
    ^ false

    "Created: / 09-05-2014 / 23:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog methodsFor:'searching'!

matchPatternCompletionFor: contents
   | pattern |

   pattern := StringPattern fromString: contents.
   (pattern isKindOf: StringPattern::StartsWith) ifFalse:[ ^ nil ].
   ^ self matchPatternCompletionFor: contents pattern: pattern

    "Created: / 02-05-2014 / 10:50:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchPatternCompletionFor: contents pattern: pattern
    | completionPOs completionPOLabels completion matchingPOs |

    completionPOs := self matchingObjectsTree root
                        recursiveSelect:[:item | (self canSelect: item) and:[ pattern match: item label relax: 1 ] ].
    completionPOLabels := completionPOs collect:[ :each | each label ].
    completion := completionPOLabels longestCommonPrefix.
    completion isEmptyOrNil ifTrue:[ ^ nil ].
    completion = contents ifTrue:[ ^ nil ].
    matchingPOs := OrderedCollection new.
    completionPOs with: completionPOLabels do:[:po :poLabel |
        poLabel = completion ifTrue:[
            matchingPOs add: po.
        ].
    ].
    ^ Array with: completion with: matchingPOs.

    "Created: / 02-05-2014 / 10:58:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2014 / 10:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectPOsForPattern: pattern
    ^ self subclassResponsibility

    "Created: / 13-12-2014 / 08:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractListDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

