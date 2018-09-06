"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

ApplicationModel subclass:#ParseTreeInspector
	instanceVariableNames:'classHolder selectorHolder methodHolder nodeHolder sourceHolder
		sourceView inspectorView'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface'
!

HierarchicalItem subclass:#ParseTreeItem
	instanceVariableNames:'astNode ivarName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ParseTreeInspector
!

!ParseTreeInspector class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!ParseTreeInspector class methodsFor:'instance creation'!

node: node source: source

    ^self new node: node source: source

    "Created: / 14-09-2011 / 17:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector class methodsFor:'interface opening'!

openOnClass: class selector: selector

    ^self new
        class: class selector: selector;
        open

    "
        SmallSenseParseNodeInspector 
            openOnClass: self
            selector: #openOnClass:selector: 
    "

    "Created: / 26-11-2011 / 12:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openOnNode: node source: source

    ^self new
        node: node source: source;
        open

    "Created: / 25-08-2013 / 10:28:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector class methodsFor:'interface specs'!

inspectorTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ParseNodeInspector andSelector:#inspectorTabSpec
     Tools::ParseNodeInspector new openInterface:#inspectorTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: inspectorTabSpec
        window: 
       (WindowSpec
          label: 'InspectorTab'
          name: 'InspectorTab'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'InspectorView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: nodeInspectorView
            )
           )
         
        )
      )

    "Modified: / 09-04-2014 / 22:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::ParseNodeInspector andSelector:#sourceTabSpec
     SmallSense::ParseNodeInspector new openInterface:#sourceTabSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: sourceTabSpec
       window: 
      (WindowSpec
         label: 'SourceTab'
         name: 'SourceTab'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (TextEditorSpec
             name: 'SourceView'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             model: sourceHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             isReadOnly: true
             showingCode: true
             hasKeyboardFocusInitially: false
             postBuildCallback: postBuildSourceView:
             viewClassName: 'CodeView'
           )
          )
        
       )
     )
!

windowSpec
    ^ self windowSpecWithInspector

    "Modified: / 09-04-2014 / 22:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpecWithInspector
    ^ self windowSpecWithInspectorSplitted

    "Modified: / 26-10-2015 / 11:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpecWithInspectorSplitted
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::ParseTreeInspector andSelector:#windowSpecWithInspectorSplitted
     SmallSense::ParseTreeInspector new openInterface:#windowSpecWithInspectorSplitted
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecWithInspectorSplitted
       window: 
      (WindowSpec
         label: 'Parse Tree Inspector'
         name: 'Parse Tree Inspector'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 630 322)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'QueryTreeAndSourcePanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: both
             handlePosition: right
             component: 
            (SpecCollection
               collection: (
                (HierarchicalListViewSpec
                   name: 'QueryTree'
                   model: selectionHolder
                   menu: queryTreeMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: parseTree
                   useIndex: false
                   highlightMode: line
                   useDefaultIcons: false
                 )
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel1'
                   snapMode: both
                   component: 
                  (SpecCollection
                     collection: (
                      (UISubSpecification
                         name: 'SubSpecification1'
                         minorKey: sourceTabSpec
                       )
                      (UISubSpecification
                         name: 'SubSpecification2'
                         minorKey: inspectorTabSpec
                       )
                      )
                    
                   )
                   handles: (Any 0.6 1.0)
                 )
                )
              
             )
             handles: (Any 0.3 1.0)
           )
          )
        
       )
     )

    "Modified: / 26-10-2015 / 11:35:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpecWithInspectorTabbed
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::ParseNodeInspector andSelector:#windowSpecWithInspector
     SmallSense::ParseNodeInspector new openInterface:#windowSpecWithInspector
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecWithInspector
       window: 
      (WindowSpec
         label: 'Parse Tree Inspector'
         name: 'Parse Tree Inspector'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 630 322)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'QueryTreeAndSourcePanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: both
             handlePosition: right
             component: 
            (SpecCollection
               collection: (
                (HierarchicalListViewSpec
                   name: 'QueryTree'
                   model: selectionHolder
                   menu: queryTreeMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: parseTree
                   useIndex: false
                   highlightMode: line
                   useDefaultIcons: false
                 )
                (NoteBookViewSpec
                   name: 'NoteBook'
                   menu: tabList
                 )
                )
              
             )
             handles: (Any 0.3 1.0)
           )
          )
        
       )
     )

    "Created: / 26-10-2015 / 11:32:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpecWithoutInspector
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSenseParseNodeInspector andSelector:#windowSpec
     SmallSenseParseNodeInspector new openInterface:#windowSpec
     SmallSenseParseNodeInspector open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Parse Tree Inspector'
          name: 'Parse Tree Inspector'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 630 322)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'QueryTreeAndSourcePanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              handlePosition: right
              component: 
             (SpecCollection
                collection: (
                 (HierarchicalListViewSpec
                    name: 'QueryTree'
                    model: selectionHolder
                    menu: queryTreeMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    listModel: parseTree
                    useIndex: false
                    highlightMode: line
                    useDefaultIcons: false
                  )
                 (UISubSpecification
                    name: 'SourceSoec'
                    minorKey: sourceTabSpec
                  )
                 )
               
              )
              handles: (Any 0.3 1.0)
            )
           )
         
        )
      )

    "Created: / 09-04-2014 / 22:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Source'
          minorKey: sourceTabSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Node'
          minorKey: inspectorTabSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!ParseTreeInspector class methodsFor:'menu specs'!

queryTreeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:XQuery::QueryInspectorUI andSelector:#queryTreeMenu
     (Menu new fromLiteralArrayEncoding:(XQuery::QueryInspectorUI queryTreeMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Inspect AST node'
	    itemValue: queryTreeMenuInspectAstNode
	    translateLabel: true
	  )
	 )
	nil
	nil
      )

    "Created: / 12-04-2007 / 11:46:57 / janfrog"
! !

!ParseTreeInspector class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #model
      ).

! !

!ParseTreeInspector methodsFor:'accessing'!

class: class selector: selector
    | mth source node parser |

    mth := class >> selector.
    mth isNil ifTrue:[
        self error:'No such method'.
        ^self.
    ].
    source := mth source.
    parser := Parser parseMethod: source.
    node := parser tree.

    self node: node source: source.

     "
        SmallSenseParseNodeInspector 
            openOnClass: SmallSenseParseNodeInspector
            selector: #class:selector: 
    "

    "Created: / 15-02-2012 / 12:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

node: node source: source

    self nodeHolder value: node.
    self sourceHolder value: source.

    "Created: / 14-09-2011 / 17:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection

    | item |
    (item := self selectionHolder value) notNil ifTrue:[
        ^item
    ] ifFalse:[
        ^nil
    ]

    "Created: / 12-04-2007 / 12:29:08 / janfrog"
    "Created: / 26-11-2011 / 11:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector methodsFor:'aspects'!

nodeHolder
    "return/create the 'nodeHolder' value holder (automatically generated)"

    nodeHolder isNil ifTrue:[
        nodeHolder := ValueHolder new.
    ].
    ^ nodeHolder
!

nodeHolder:something
    "set the 'nodeHolder' value holder (automatically generated)"

    nodeHolder := something.
!

nodeInspectorView

    inspectorView isNil ifTrue:[
        inspectorView := InspectorView new
    ].
    ^ inspectorView

    "Created: / 31-10-2007 / 12:20:02 / janfrog"
    "Created: / 14-09-2011 / 17:24:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseTree

    ^self builder bindings at: #parseTree
        ifAbsentPut:
            [PluggableAdaptor on: self nodeHolder getter:
                [:m|
                | rootAstNodeItem rootAstNode hl |

                rootAstNode := self nodeHolder value.

                rootAstNodeItem := ParseTreeItem new
                                            ivarName: 'AST';
                                            astNode: rootAstNode;
                                            yourself.


                hl := HierarchicalList new
                        root: rootAstNodeItem;
                        showRoot: true;
                        yourself.
                rootAstNodeItem expand.
                hl]]

    "Created: / 28-03-2007 / 15:58:31 / janfrog"
    "Modified: / 31-10-2007 / 12:11:46 / janfrog"
    "Created: / 14-09-2011 / 17:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 10:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionHolder

    ^self builder bindings at: #selectionHolder
        ifAbsentPut:
            [nil asValue
                onChangeSend:#updateSourceViewSelection to:self;
                onChangeSend:#updateInspectorView to:self;
                yourself]

    "Created: / 28-03-2007 / 16:46:30 / janfrog"
    "Modified: / 31-10-2007 / 12:25:54 / janfrog"
    "Created: / 14-09-2011 / 17:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 09:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceHolder
    "return/create the 'sourceHolder' value holder (automatically generated)"

    sourceHolder isNil ifTrue:[
        sourceHolder := ValueHolder new.
    ].
    ^ sourceHolder
!

sourceHolder:something
    "set the 'sourceHolder' value holder (automatically generated)"

    sourceHolder := something.
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
	builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list

    "Created: / 31-10-2007 / 12:21:18 / janfrog"
! !

!ParseTreeInspector methodsFor:'callbacks - post build'!

postBuildSourceView: aView

    sourceView := aView scrolledView.
    sourceView cursorLineHolder addDependent: self.
    sourceView cursorColHolder addDependent: self.

    "Created: / 12-04-2007 / 12:28:14 / janfrog"
    "Modified: / 10-04-2014 / 07:55:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    sourceView notNil ifTrue:[
        "/ cursor moved by user...
        ((changedObject == sourceView cursorLineHolder)
        or:[ changedObject == sourceView cursorColHolder ]) ifTrue:[
            self updateSelectionFromCursor.
            ^ self.
        ].

    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 10-04-2014 / 07:57:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateInspectorView

    inspectorView notNil ifTrue:[ 
        | selection |

        selection := self selection.
        inspectorView inspect: (selection isNil ifTrue:[ nil ] ifFalse:[ selection node ])
    ]

    "Created: / 31-10-2007 / 12:25:25 / janfrog"
    "Modified: / 10-04-2014 / 08:34:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelectionFromCursor
    | pos root selection |

    pos := sourceView characterPositionOfCursor.
    root := self parseTree value root.
    selection := root leafNodeAt: pos.
    selection notNil ifTrue:[ 
        | item |

        item := selection.
        [ item notNil ] whileTrue:[ 
            item expand.
            item := item parent.
        ].
        self selectionHolder value: selection

    ].

    "Created: / 10-04-2014 / 07:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSourceViewSelection

    | astNode parseNode startPosition stopPosition |

    sourceView ifNil:[^self].
    (astNode := self selection) ifNil:[^self].
    (parseNode := astNode node) isNil ifTrue:[ ^ self ].

    (startPosition := parseNode startPosition)
        ifNil:[^sourceView unselect].
    (stopPosition := parseNode endPosition)
        ifNil:[^sourceView unselect].

    "/ avoid cyclic update (from changed cursor)
    "/ (which would deselect again)
    sourceView cursorLineHolder withoutUpdating:self do:[
        sourceView cursorColHolder withoutUpdating:self do:[   
            sourceView selectFromCharacterPosition: startPosition to: stopPosition.
            sourceView makeCursorVisible
        ]
    ]
    "Created: / 12-04-2007 / 12:29:42 / janfrog"
    "Modified: / 07-08-2014 / 10:21:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector methodsFor:'menu actions'!

queryTreeMenuInspectAstNode

    ^self selection node inspect

    "Created: / 12-04-2007 / 11:47:48 / janfrog"
    "Modified: / 26-11-2011 / 12:12:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector::ParseTreeItem class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/goodies/smallsense/SmallSense__ParseTreeInspector.st,v 1.2 2015-02-04 09:46:31 cg Exp $'
! !

!ParseTreeInspector::ParseTreeItem methodsFor:'accessing'!

astNode
    ^ astNode

    "Created: / 28-03-2007 / 15:51:49 / janfrog"
!

astNode:anAstNode
    astNode := anAstNode.

    "Created: / 28-03-2007 / 15:51:49 / janfrog"
!

astNodeName

    ^astNode class name

    "Created: / 12-04-2007 / 11:29:57 / janfrog"
    "Modified: / 31-10-2007 / 12:13:34 / janfrog"
    "Modified: / 26-11-2011 / 10:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children

    children isNil ifTrue:[
        children := OrderedCollection new.
        astNode notNil ifTrue:[
            astNode childNamesAndValuesDo:[:ivarName :astNode|
                astNode notNil ifTrue:[
                    children add: (self class new
                                    ivarName: ivarName;
                                    astNode: astNode;
                                    parent: self)
                ]
            ].
        ].
    ].
    ^children

    "Created: / 28-03-2007 / 15:55:24 / janfrog"
    "Modified: / 12-04-2007 / 11:35:24 / janfrog"
    "Modified: / 07-08-2014 / 10:20:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon

    ^nil

    "Created: / 31-10-2007 / 12:14:52 / janfrog"
    "Modified: / 26-11-2011 / 10:47:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ivarName
    ^ ivarName ? '?'

    "Created: / 12-04-2007 / 11:29:28 / janfrog"
!

ivarName:something
    ivarName := something.

    "Created: / 12-04-2007 / 11:29:28 / janfrog"
!

label
    | label start stop optionalSelector |

    astNode isNil ifTrue:[ ^ 'No AST' ].

    start := astNode startPosition.
    stop := astNode endPosition.

    astNode isMessage ifTrue:[
        optionalSelector := ' #',astNode selector allBold.
    ] ifFalse:[
        optionalSelector := ''
    ].
    label := '%1 {%2%5} [%3..%4]' 
                bindWith: self ivarName
                    with: self astNodeName
                    with: start ? '?'
                    with: stop ? '?'
                    with: optionalSelector.

    (start isNil or:[ stop isNil ]) ifTrue:[ 
        label := label asText colorizeAllWith: Color red.
    ].
    ^ label

    "Created: / 28-03-2007 / 15:53:18 / janfrog"
    "Modified: / 12-04-2007 / 11:30:23 / janfrog"
    "Modified: / 07-08-2014 / 10:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leafNodeAt: pos
    | start stop |

    start := astNode startPosition.
    stop := astNode endPosition.
    self children do:[:each | 
        | leaf |
        leaf := each leafNodeAt: pos.            
        leaf notNil ifTrue:[ ^ leaf ].
    ].
    (start notNil and:[stop notNil]) ifTrue:[
        (pos between: start and: stop) ifTrue:[ ^ self ].
    ].
    ^ nil.

    "Created: / 10-04-2014 / 08:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

node
    ^ astNode

    "Created: / 28-03-2007 / 15:51:49 / janfrog"
    "Created: / 26-11-2011 / 11:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/smallsense/SmallSense__ParseTreeInspector.st,v 1.2 2015-02-04 09:46:31 cg Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/smallsense/SmallSense__ParseTreeInspector.st, Version: 1.0, User: cg, Time: 2015-02-04T10:46:56.332+01$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: SmallSense__ParseTreeInspector.st,v 1.2 2015-02-04 09:46:31 cg Exp $'
! !

