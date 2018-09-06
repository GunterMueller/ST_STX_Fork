"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/mercurial' }"

ApplicationModel subclass:#HGChangesetViewer
	instanceVariableNames:'changesetHolder changesetChangeSelectionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

ApplicationModel subclass:#PageChanges
	instanceVariableNames:'changesetHolder changeListHolder changeSelectionHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGChangesetViewer
!

!HGChangesetViewer class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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

!HGChangesetViewer class methodsFor:'interface specs'!

changesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetViewer andSelector:#changesSpec
     HGChangesetViewer new openInterface:#changesSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: changesSpec
       window: 
      (WindowSpec
         label: 'Changeset - Changes'
         name: 'Changeset - Changes'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 593 436)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'SubCanvas1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             majorKey: #'HGChangesetViewer::PageChanges'
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: changesetHolder
                 aspect: changesetHolder
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          )
        
       )
     )
!

metadataSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetViewer andSelector:#metadataSpec
     HGChangesetViewer new openInterface:#metadataSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: metadataSpec
       window: 
      (WindowSpec
         label: 'HG Changeset Details'
         name: 'HG Changeset Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 809 517)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: topSpaceFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box3'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'User:'
                         name: 'Label2'
                         layout: (LayoutFrame 0 0 0 0 120 0 -3 1)
                         translateLabel: true
                         resizeForLabel: false
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'EntryField3'
                         layout: (LayoutFrame 120 0 0 0 0 1 0 1)
                         level: 0
                         model: changesetUserAspect
                         isReadOnly: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         postBuildCallback: postBuildLabelField:
                       )
                      )
                    
                   )
                   extent: (Point 809 22)
                 )
                (ViewSpec
                   name: 'Box5'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Date:'
                         name: 'Label4'
                         layout: (LayoutFrame 0 0 0 0 120 0 -3 1)
                         translateLabel: true
                         resizeForLabel: false
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'EntryField5'
                         layout: (LayoutFrame 120 0 0 0 0 1 0 1)
                         level: 0
                         model: changesetDateAspect
                         isReadOnly: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         postBuildCallback: postBuildLabelField:
                       )
                      )
                    
                   )
                   extent: (Point 809 22)
                 )
                (ViewSpec
                   name: 'Box4'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Parents:'
                         name: 'Label3'
                         layout: (LayoutFrame 0 0 0 0 120 0 -3 0.5)
                         translateLabel: true
                         resizeForLabel: false
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'EntryField6'
                         layout: (LayoutFrame 120 0 0 0 0 1 -1 0.5)
                         level: 0
                         model: changesetP1Aspect
                         isReadOnly: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         postBuildCallback: postBuildLabelField:
                       )
                      (InputFieldSpec
                         name: 'EntryField7'
                         layout: (LayoutFrame 120 0 2 0.5 0 1 0 1)
                         level: 0
                         model: changesetP2Aspect
                         isReadOnly: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         postBuildCallback: postBuildLabelField:
                       )
                      )
                    
                   )
                   extent: (Point 809 47)
                 )
                (ViewSpec
                   name: 'Box6'
                   component: 
                  (SpecCollection
                     collection: (
                      (TextEditorSpec
                         name: 'TextEditor1'
                         layout: (LayoutFrame 120 0 0 0 0 1 0 1)
                         model: changesetMessageAspect
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                       )
                      (LabelSpec
                         label: 'Message:'
                         name: 'Label5'
                         layout: (LayoutFrame 0 0 0 0 120 0 23 0)
                         translateLabel: true
                         resizeForLabel: false
                         adjust: left
                       )
                      )
                    
                   )
                   extent: (Point 809 411)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetViewer andSelector:#windowSpec
     HGChangesetViewer new openInterface:#windowSpec
     HGChangesetViewer open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'HG Changeset Details'
         name: 'HG Changeset Details'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 809 517)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Metadata1'
             layout: (LayoutFrame 0 0 0 0 0 1 22 0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Changeset:'
                   name: 'ChangesetLabel'
                   layout: (LayoutFrame 0 0 0 0 120 0 -3 1)
                   translateLabel: true
                   resizeForLabel: false
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 120 0 0 0 0 1 0 1)
                   level: 0
                   model: changesetIdAspect
                   isReadOnly: true
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnPointerLeave: true
                   postBuildCallback: postBuildLabelField:
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'Metadata2'
             layout: (LayoutFrame 0 0 23 0 0 1 45 0)
             component: 
            (SpecCollection
               collection: (
                (NonScrollableArbitraryComponentSpec
                   name: 'NonScrollableArbitraryComponent1'
                   layout: (LayoutFrame 120 0 0 0 0 1 0 1)
                   model: changesetHolder
                   component: HGChangesetLabelsView
                 )
                )
              
             )
           )
          (NoteBookViewSpec
             name: 'NoteBook'
             layout: (LayoutFrame 0 0 46 0 0 1 0 1)
             level: 0
             menu: detailsTabList
             direction: bottom
             canvasInset: 0
             tabLevel: 0
             tabLabelInset: 5
           )
          )
        
       )
     )
! !

!HGChangesetViewer class methodsFor:'list specs'!

detailsTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#detailsTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Details'
          translateLabel: true
          minorKey: metadataSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Changes'
          translateLabel: true
          minorKey: changesSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!HGChangesetViewer class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #changesetHolder
      ).

! !

!HGChangesetViewer methodsFor:'accessing'!

changeset
    ^ self changesetHolder value

    "Created: / 25-03-2014 / 01:53:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset: anHGChangeset
    self changesetHolder value: anHGChangeset

    "Created: / 25-03-2014 / 01:53:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer methodsFor:'actions'!

postBuildLabelField: anEditField
    anEditField background: Label defaultBackgroundColor

    "Modified (format): / 15-03-2014 / 01:16:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer methodsFor:'aspects'!

changesetBranchesAspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | model value notNil ifTrue:[(model value branches collect:[:e|e name]) asStringWith: '. '] ifFalse:[ nil ]]

    "Created: / 15-03-2014 / 01:06:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetChangeSelectionHolder
    "return/create the 'changesetChangeSelectionHolder' value holder (automatically generated)"

    changesetChangeSelectionHolder isNil ifTrue:[
        changesetChangeSelectionHolder := ValueHolder new.
        changesetChangeSelectionHolder addDependent:self.
    ].
    ^ changesetChangeSelectionHolder
!

changesetChangeSelectionHolder:something
    "set the 'changesetChangeSelectionHolder' value holder (automatically generated)"

    |oldValue newValue|

    changesetChangeSelectionHolder notNil ifTrue:[
        oldValue := changesetChangeSelectionHolder value.
        changesetChangeSelectionHolder removeDependent:self.
    ].
    changesetChangeSelectionHolder := something.
    changesetChangeSelectionHolder notNil ifTrue:[
        changesetChangeSelectionHolder addDependent:self.
    ].
    newValue := changesetChangeSelectionHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changesetChangeSelectionHolder.
    ].
!

changesetDateAspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | model value notNil 
                    ifTrue:[ (model value timestamp printString) ] 
                    ifFalse:[ nil ]]

    "Created: / 15-03-2014 / 01:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetHolder
    "return/create the 'changesetHolder' value holder (automatically generated)"

    changesetHolder isNil ifTrue:[
        changesetHolder := ValueHolder new.
        changesetHolder addDependent:self.
    ].
    ^ changesetHolder

    "Modified (format): / 15-03-2014 / 00:57:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetHolder:something
    "set the 'changesetHolder' value holder (automatically generated)"

    |oldValue newValue|

    changesetHolder notNil ifTrue:[
        oldValue := changesetHolder value.
        changesetHolder removeDependent:self.
    ].
    changesetHolder := something.
    changesetHolder notNil ifTrue:[
        changesetHolder addDependent:self.
    ].
    newValue := changesetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changesetHolder.
    ].
!

changesetIdAspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | model value notNil 
                    ifTrue:[model value displayString] 
                    ifFalse:[ nil ]]

    "Created: / 15-03-2014 / 00:59:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMessageAspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | model value notNil 
                    ifTrue:[model value message] 
                    ifFalse:[ nil ]]

    "Created: / 18-03-2014 / 00:15:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetP1Aspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | 
            model value isNil ifTrue:[ 
                ''
            ] ifFalse:[ 
                | p1 |

                p1 := model value parent1.
                p1 isNil ifTrue:[ '' ] ifFalse:[ p1 displayString ]
            ]
        ]

    "Created: / 15-03-2014 / 15:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-03-2014 / 23:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetP2Aspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | 
            model value isNil ifTrue:[ 
                ''
            ] ifFalse:[ 
                | p2 |

                p2 := model value parent2.
                p2 isNil ifTrue:[ '' ] ifFalse:[ p2 displayString ]
            ]
        ]

    "Created: / 15-03-2014 / 15:15:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-03-2014 / 23:37:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetUserAspect
    ^ PluggableAdaptor 
        on: self changesetHolder
        getter: [ :model | model value notNil ifTrue:[model value author ] ifFalse:[ nil ]]

    "Created: / 15-03-2014 / 01:06:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

detailsTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#detailsTabList) isNil ifTrue:[
        builder aspectAt:#detailsTabList put:(list := self class detailsTabList).
    ].
    ^ list
! !

!HGChangesetViewer methodsFor:'hooks'!

postOpenWith: anUIBuilder
    self changesetHolder value isNil ifTrue:[ 
        self changesetHolder value: HGChangeset anyInstance
    ].

    "Created: / 15-03-2014 / 00:57:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer::PageChanges class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetViewer andSelector:#changesSpec
     HGChangesetViewer new openInterface:#changesSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: changesSpec
       window: 
      (WindowSpec
         label: 'Changeset - Changes'
         name: 'Changeset - Changes'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 593 436)
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'changesToolBarMenu'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             textDefault: true
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0 30 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (SelectionInListModelViewSpec
                   name: 'ChangesList'
                   model: changeSelectionHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: changeListHolder
                   useIndex: false
                   highlightMode: line
                 )
                )

             )
             handles: (Any 1.0)
           )
          )

       )
     )

    "Created: / 18-03-2014 / 11:16:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer::PageChanges class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #changesetHolder
      ).

    "Created: / 18-03-2014 / 11:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer::PageChanges methodsFor:'aspects'!

changeListHolder
    "return/create the 'changeListHolder' value holder (automatically generated)"

    changeListHolder isNil ifTrue:[
        changeListHolder := ValueHolder new.
    ].
    ^ changeListHolder
!

changeSelectionHolder
    "return/create the 'changeSelectionHolder' value holder (automatically generated)"

    changeSelectionHolder isNil ifTrue:[
        changeSelectionHolder := ValueHolder new.
    ].
    ^ changeSelectionHolder
!

changesetHolder
    "return/create the 'changesetHolder' value holder (automatically generated)"

    changesetHolder isNil ifTrue:[
        changesetHolder := ValueHolder new.
        changesetHolder addDependent:self.
    ].
    ^ changesetHolder
!

changesetHolder:something
    "set the 'changesetHolder' value holder (automatically generated)"

    |oldValue newValue|

    changesetHolder notNil ifTrue:[
        oldValue := changesetHolder value.
        changesetHolder removeDependent:self.
    ].
    changesetHolder := something.
    changesetHolder notNil ifTrue:[
        changesetHolder addDependent:self.
    ].
    newValue := changesetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changesetHolder.
    ].
! !

!HGChangesetViewer::PageChanges methodsFor:'change & update'!

update:aspect with:param from:changedObject
    "Invoked when an object that I depend upon sends a change notification."


    changedObject == changedObject ifTrue:[
        self updateAfterChangesetHolderChanged.
        ^ self.
    ].
    super update:aspect with:param from:changedObject

    "Modified: / 18-03-2014 / 11:04:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterChangesetHolderChanged
    | changeset |

    changeset := self changesetHolder value.
    self changeSelectionHolder value: nil.
    changeset isNil ifTrue:[ 
        self changeListHolder value: #().
    ] ifFalse:[ 
        self changeListHolder value: changeset changes.
    ].

    "Created: / 18-03-2014 / 11:04:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetViewer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

