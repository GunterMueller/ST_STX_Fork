"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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

BrowserList subclass:#LintRuleList
	instanceVariableNames:'listHolder filterHolder modeHolder listSelection listView
		initialSelectionHolder'
	classVariableNames:'LastNameFilter'
	poolDictionaries:''
	category:'Interface-Lint'
!

HierarchicalItem subclass:#ListEntry
	instanceVariableNames:'x rule application'
	classVariableNames:''
	poolDictionaries:''
	privateIn:LintRuleList
!

!LintRuleList class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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
!

documentation
"
    Embeddable list to display a set of SmallLint rules.
    (this is embedded in the browser when showing lint check outcomes)

    Supports 3 modes (controlled by modeHolder)
        #display            - only display given set of rules.
        #displaySelection   - display set of rules and indicate which one is selected
                              by check mark. Does NOT ALLOW to change selection
                              (add remove tools)
        #select             - display set of rules and DO ALLOW to change the selection
                              (add / remove rules) by clicking to check icon     

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::LintRuleList open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!LintRuleList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::LintRuleList andSelector:#windowSpec
     Tools::LintRuleList new openInterface:#windowSpec
     Tools::LintRuleList open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SmallLintRuleList'
         name: 'SmallLintRuleList'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (InputFieldSpec
             name: 'RuleFilter'
             layout: (LayoutFrame 0 0 0 0 0 1 28 0)
             model: filterHolder
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnPointerLeave: true
             emptyFieldReplacementText: 'Search...'
           )
          (SelectionInListModelViewSpec
             name: 'RuleList'
             layout: (LayoutFrame 0 0 28 0 0 1 0 1)
             model: listSelection
             menu: menuHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: listHolder
             multipleSelectOk: true
             useIndex: false
             highlightMode: line
             postBuildCallback: postBuildList:
           )
          )
        
       )
     )
! !

!LintRuleList class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::LintRuleList andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Tools::LintRuleList menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Run this Rule Again'
            itemValue: runRuleAgain
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect Rule'
            itemValue: menuInspectRule
          )
         (MenuItem
            label: 'Browse Rule Class'
            itemValue: menuBrowseRuleClass
          )
         )
        nil
        nil
      )
! !

!LintRuleList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #environmentHolder
        #inGeneratorHolder
        #listSelection
        #modeHolder
        #outGeneratorHolder
        #selectionHolder
      ).

! !

!LintRuleList methodsFor:'accessing'!

mode

    ^self modeHolder value

    "Created: / 25-08-2010 / 11:33:51 / Jan Vrany <enter your email here>"
!

selection

    | sel |
    sel := self selectionHolder value.
    sel ifNil:[sel := Set new].
    ^sel

    "Created: / 25-08-2010 / 13:26:58 / Jan Vrany <enter your email here>"
!

selection: aCollectionOrNil

    | sel |
    sel := aCollectionOrNil 
                ifNil:[Set new]
                ifNotNil:[aCollectionOrNil asSet].
    
    self selectionHolder value: sel.

    "Created: / 25-08-2010 / 13:28:43 / Jan Vrany <enter your email here>"
    "Modified: / 25-08-2010 / 15:29:35 / Jan Vrany <enter your email here>"
    "Modified: / 27-02-2013 / 23:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'aspects'!

filterHolder
    "return/create the 'filterHolder' value holder (automatically generated)"

    filterHolder isNil ifTrue:[
        filterHolder := LastNameFilter asValue.
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

listHolder
    "return/create the 'ruleList' value holder (automatically generated)"
    
    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder
!

listSelection
    "return/create the 'listSelection' value holder (automatically generated)"

    listSelection isNil ifTrue:[
        listSelection := ValueHolder new.
        listSelection addDependent:self.
    ].
    ^ listSelection
!

listSelection:something
    "set the 'listSelection' value holder (automatically generated)"

    |oldValue newValue|

    listSelection notNil ifTrue:[
        oldValue := listSelection value.
        listSelection removeDependent:self.
    ].
    listSelection := something.
    listSelection notNil ifTrue:[
        listSelection addDependent:self.
    ].
    newValue := listSelection value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:listSelection.
    ].
!

modeHolder
    "the mode - can run in select or in display modes.
     select is to choose a set of rules;
     display for presentation of results (in a browser).
     See documentation for details"
     
    modeHolder isNil ifTrue:[
        modeHolder := ValueHolder with: #display
    ].
    ^modeHolder

    "Modified: / 15-04-2010 / 20:56:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modeHolder:aValueModel
    "the mode - can run in select or in display modes.
     select is to choose a set of rules;
     display for presentation of results (in a browser).
     See documentation for details"

    modeHolder := aValueModel.
!

selectedLintRules
    ^ self selectionHolder

    "Created: / 02-02-2010 / 20:43:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedLintRules: anObject
    ^ self selectionHolder: anObject

    "Created: / 02-02-2010 / 20:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == filterHolder ifTrue:[
       LastNameFilter := filterHolder value.
        self updateList.
        ^ self.
    ].

    (changedObject == listSelection) ifTrue:[
        listValid ifFalse:[
            self updateList.
        ].
        ^ self selectionChanged
    ].

    (changedObject == selectionHolder) ifTrue:[
        listView notNil ifTrue:[
            listView invalidate
        ].
        ^self.            
    ].


    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 26-08-2010 / 11:43:33 / Jan Vrany <enter your email here>"
    "Modified: / 27-02-2013 / 23:40:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enqueueDelayedUpdateList
    super enqueueDelayedUpdateList
!

selectionChanged

    | selection newSelection |

    super selectionChanged.
    self mode == #display ifTrue:[
        selection := self listSelection value.
        selection isEmptyOrNil ifTrue:[
            newSelection := selection
        ] ifFalse:[
            newSelection := selection collect:[:entry|entry rule]
        ].                                 
        self selectionHolder value: newSelection.
"/        listView invalidate
    ].

    "Created: / 05-08-2011 / 00:10:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2014 / 00:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'event processing'!

buttonPress:button x:x y:y view:aView

    | itemIndex item |

    (button == 1 and:[self modeHolder value == #select]) ifFalse:[
        ^ aView buttonPress:button x:x y:y
    ].

    itemIndex := aView yVisibleToLineNr:y.
    itemIndex isNil ifTrue:[^self].
    itemIndex == 0 ifTrue:[^self].
    itemIndex > aView list size ifTrue:[^self].
    item := aView list at: itemIndex.

    ((aView left + x) between: (item x) and: (item x + 16))
        ifFalse:[^aView buttonPress:button x:x y:y].

    item checked: item checked not.
    aView invalidate

    "Created: / 08-12-2009 / 14:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2014 / 18:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesButtonPress:button inView:aView
    ^ listView == aView
        and:[ button == 1 
        and:[ self modeHolder value == #select ] ]

    "Created: / 08-12-2009 / 14:08:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2014 / 09:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'generators'!

makeGenerator

    self modeHolder value == #display ifTrue:[
        ^ Iterator 
            on: [:whatToDo|
                self listSelection value ? #() do:[:each|
                    "/ classes removed (in the meanwhile), but still referenced by name in the lintResults
                    "/ may lead to nil being enumerated here...
                    each failedClasses nonNilElementsDo:whatToDo
                ]
            ]
    ].
    ^ Iterator 
        on: [:whatToDo|
            self selection do:[:rule| whatToDo value: rule]
        ].

    "Modified: / 16-04-2010 / 12:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2010 / 13:39:51 / Jan Vrany <enter your email here>"
! !

!LintRuleList methodsFor:'hooks'!

commonPostOpen
    super commonPostOpen.
    self updateOutputGenerator.

    "Created: / 16-04-2010 / 11:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildList: aView

    listView := aView scrolledView.
    listView delegate: self.

    "Created: / 08-12-2009 / 14:10:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'initialization'!

initialize
    | menu |

    super initialize.
    
    menuHolder := 
        [
            menu := self menuFor: #menu.
            menu isArray ifTrue:[ menu := Menu decodeFromLiteralArray: menu ].
            menu
        ].
    
    "/ self selection: Set new.

    "Modified: / 25-08-2010 / 15:24:45 / Jan Vrany <enter your email here>"
    "Modified: / 24-02-2014 / 12:00:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'menu actions'!

menuBrowseRuleClass
    | selection |

    selection := self listSelection value.
    selection size = 1 ifTrue:[selection anyOne rule class browse].
    selection size > 1 ifTrue:[SystemBrowser 
                                    browseClasses:(selection collect:[:e|e rule class])
                                    label:'Rule classes'].
!

menuInspectRule
    | selection |

    selection := self listSelection value.
    selection size = 1 ifTrue:[selection anyOne rule inspect].
    selection size > 1 ifTrue:[(selection collect:[:e|e rule]) inspect].
!

runRuleAgain
    self selectedLintRules value do:[:eachRule |
        eachRule run.
    ].    
    "/ self updateList.
    self updateOutputGenerator        
! !

!LintRuleList methodsFor:'private'!

listEntryFor: anRBLintRule

    | entry |
    entry := ListEntry new 
                rule: anRBLintRule;
                application: self;
                expand;
                yourself.
    ^entry

    "Created: / 15-04-2010 / 18:59:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2010 / 14:15:46 / Jan Vrany <enter your email here>"
!

makeDependent

    "nothing to do"

    "Created: / 02-02-2010 / 20:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeIndependent

    "nothing to do"

    "Created: / 02-02-2010 / 20:23:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rules: rules includes: rule

    ^rules contains:
        [:each|
        each class == rule class and:
            [each name = rule name]]

    "Created: / 26-08-2010 / 12:04:04 / Jan Vrany <enter your email here>"
!

setListValid:aBoolean
"/    listValid ifTrue:[
"/        aBoolean ifFalse:[self halt].
"/    ].
    listValid := aBoolean.
!

updateList
    |generator filterS newList|

    generator := self inGeneratorHolder value.
    filterS := self filterHolder value.
    filterS notEmptyOrNil ifTrue:[
        (filterS startsWith: $*) ifFalse:[filterS := '*' , filterS].
        (filterS endsWith:   $*) ifFalse:[filterS := filterS , '*']
    ].        
    (generator isNil and:[self mode == #display]) ifTrue:[
        generator := RBCompositeLintRule allRules flattened 
    ].
    newList := OrderedCollection new.
    generator do:[:rule |
        rule flattened do: [:rule|
            (filterS isEmptyOrNil 
                or:[(rule name matches: filterS caseSensitive:false)
                or:[rule class name matches: filterS caseSensitive:false]])
            ifTrue:[
                newList add: (self listEntryFor:rule)
            ]
        ]
    ].
    newList 
        sort:[:a :b |
            |sevA sevB|
            
            sevA := a rule severityAsInteger.
            sevB := b rule severityAsInteger.
            (sevA > sevB) 
            or:[ (sevA == sevB) and:[a rule name < b rule name]].
        ].
    "/ newList sort:[:a :b | a name < b name].
    self listHolder value:newList.
    self setListValid:true.

    "Modified: / 22-07-2009 / 15:58:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-08-2010 / 13:35:58 / Jan Vrany <enter your email here>"
    "Modified: / 07-03-2012 / 18:06:50 / cg"
    "Modified: / 16-10-2014 / 23:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'queries'!

supportsSearch

    ^false

    "Created: / 04-08-2011 / 23:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList methodsFor:'selection'!

selectionAdd: rule

    self selection: 
        (self selection addAll: rule flattened; yourself)

    "Created: / 25-08-2010 / 13:34:57 / Jan Vrany <enter your email here>"
!

selectionIncludes: rule

   ^self rules: self selection includes: rule

    "Created: / 25-08-2010 / 13:30:14 / Jan Vrany <enter your email here>"
    "Modified: / 26-08-2010 / 12:04:19 / Jan Vrany <enter your email here>"
!

selectionRemove: rule

    | sel rules |
    sel := self selection.
    rules := rule flattened.
    sel := sel reject:
                [:each|self rules: rules includes: each].
    self selection: sel

    "Created: / 25-08-2010 / 13:35:08 / Jan Vrany <enter your email here>"
    "Modified: / 26-08-2010 / 12:05:06 / Jan Vrany <enter your email here>"
! !

!LintRuleList::ListEntry class methodsFor:'instance creation'!

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

!LintRuleList::ListEntry methodsFor:'accessing'!

application
    ^ application notNil ifTrue:[application] ifFalse:[super application]

    "Modified: / 28-03-2014 / 10:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

application:anApplicationModel
    application := anApplicationModel.
!

checked

    ^rule isComposite 
        ifTrue:[self children anySatisfy:[:each|each checked]]
        ifFalse:[self application selectionIncludes: rule]

    "Modified: / 15-04-2010 / 20:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2010 / 13:29:33 / Jan Vrany <enter your email here>"
!

checked:aBoolean

    | app |
    app := self application.
    aBoolean 
        ifTrue: [app selectionAdd: rule]
        ifFalse:[app selectionRemove: rule]

    "Modified: / 15-04-2010 / 19:06:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2010 / 13:35:29 / Jan Vrany <enter your email here>"
!

checkedRule

    self checked ifFalse:[^nil].

    rule isComposite 
        ifTrue:
            [^rule copy 
                rules: (self children 
                            collect:[:entry|entry checkedRule] 
                            thenReject:[:rule|rule isNil]);
                yourself]
        ifFalse:
            [^rule]

    "Created: / 16-04-2010 / 12:06:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children
    children ifNil:[
        rule isComposite ifTrue: [
            | app | 

            app := self application.
            children := rule rules collect:[:eachRule | (app listEntryFor:eachRule) parent:self]
        ] ifFalse: [
            children := #()
        ]
    ].

    ^ children

    "Created: / 25-07-2009 / 23:32:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-04-2010 / 20:40:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failedClasses

    ^rule failedClasses

    "Created: / 15-04-2010 / 19:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failedMethods

    ^rule failedMethods

    "Created: / 15-04-2010 / 19:10:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failedMethodsInAnyOf: classes meta: meta

    ^rule failedMethodsInAnyOf: classes meta: meta

    "Created: / 15-04-2010 / 19:11:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    |s severity|
    
    s := rule displayString.
    (severity := rule severity) == #warning ifTrue:[
        ^ s withColor:Color orange.
    ].    
    severity == #error ifTrue:[
        ^ s withColor:Color red.
    ].    
    severity == #information ifFalse:[
        self halt.
    ].    
    ^ s

    "Modified: / 15-04-2010 / 18:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^rule name

    "Created: / 15-04-2010 / 19:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rationale
    ^ rule rationaleWithAnchor

    "Created: / 15-04-2010 / 19:10:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 20:58:50 / cg"
!

rationaleWithAnchor
    ^ rule rationaleWithAnchor

    "Created: / 15-04-2010 / 19:10:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 20:58:50 / cg"
    "Created: / 02-03-2012 / 01:04:40 / cg"
!

rule
    ^ rule
!

rule:anRBLintRule
    rule := anRBLintRule.
!

x
    ^ x ? 0

    "Modified: / 15-04-2010 / 20:48:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList::ListEntry methodsFor:'displaying'!

displayLabel:aLabel h:lH on:aGC x:newX y:y h:h 
    self displayLabel:aLabel h:lH on:aGC x:newX y:y h:h isHighlightedAsSelected:false
!

displayLabel:aLabel h:lH on:aGC x:newX y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    | cx icon app mode |

    cx := x := newX.
    app := self application.
    mode := app mode.
    mode ~~ #display ifTrue:[
        mode == #select ifTrue:[        
            icon := self checked 
                        ifTrue:[app class checkedIcon] 
                        ifFalse:[app class uncheckedIcon].
        ] ifFalse:[ 
            icon := self checked 
                        ifTrue:[app class checkedIconDisabled] 
                        ifFalse:[app class uncheckedIconDisabled].
        ].
        icon displayOn: aGC x: cx y: y + (h / 2) - (icon height / 2).
        cx := cx + 22."experimental value - this looks good"
    ].

    super displayLabel:aLabel h:lH on:aGC x:cx y:y h:h isHighlightedAsSelected:isHighlightedAsSelected

    "Modified (format): / 07-03-2012 / 20:08:02 / cg"
    "Modified: / 08-10-2014 / 22:56:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    rule displayOn:aGCOrStream

    "Created: / 15-04-2010 / 19:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2013 / 12:59:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

