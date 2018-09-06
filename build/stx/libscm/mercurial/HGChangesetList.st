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

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#HGChangesetList
	instanceVariableNames:'changesetList changesetHolder entryList entryHolder entryListView'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGChangesetList class methodsFor:'documentation'!

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

!HGChangesetList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetList andSelector:#windowSpec
     HGChangesetList new openInterface:#windowSpec
     HGChangesetList open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'HG Changeset List'
         name: 'HG Changeset List'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SelectionInListModelViewSpec
             name: 'SelectionInListModelView1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             model: entryHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: entryList
             useIndex: false
             highlightMode: line
             postBuildCallback: postBuildEntryListView:
           )
          )
        
       )
     )
! !

!HGChangesetList class methodsFor:'plugIn spec'!

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
        #changesetList
      ).

! !

!HGChangesetList class methodsFor:'tableColumns specs'!

changesetListColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:HGChangesetList2 andSelector:#changesetListColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Revno'
         labelAlignment: right
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: idRevno
       )
      (DataSetColumnSpec
         label: 'Revhash'
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: idHash
       )
      (DataSetColumnSpec
         label: 'Labels'
         labelButtonType: Button
         usePreferredWidth: true
         height: heightOfFirstRow
         menuFromApplication: false
       )
      (DataSetColumnSpec
         label: 'Summary'
         labelButtonType: Button
         width: 1.0
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: summary
       )
      (DataSetColumnSpec
         label: 'Author'
         labelButtonType: Button
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: user
         canSelect: false
       )
      )
    
! !

!HGChangesetList methodsFor:'aspects'!

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
!

changesetList
    changesetList isNil ifTrue:[
        changesetList := List new.
    ].
    ^ changesetList

    "Modified: / 11-03-2014 / 20:26:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetList:aListOrValueModel
    "set the 'changesetList' value holder (automatically generated)"

    |oldValue newValue|

    changesetList notNil ifTrue:[
        oldValue := changesetList value.
        changesetList removeDependent:self.
    ].
    changesetList := aListOrValueModel.
    changesetList notNil ifTrue:[
        changesetList addDependent:self.
    ].
    newValue := changesetList value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changesetList.
    ].
!

entryHolder
    "return/create the 'entryHolder' value holder (automatically generated)"

    entryHolder isNil ifTrue:[
        entryHolder := ValueHolder new.
        entryHolder addDependent:self.
    ].
    ^ entryHolder
!

entryList
    "return/create the 'entryList' value holder (automatically generated)"

    entryList isNil ifTrue:[
        entryList := List new.
    ].
    ^ entryList

    "Modified: / 14-03-2014 / 23:57:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetList methodsFor:'change & update'!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == entryHolder ifTrue:[ 
        self updateAfterEntryHolderChanged.
    ].
    sender == changesetHolder ifTrue:[ 
        self updateAfterChangesetHolderChanged.
    ].
    sender == changesetList ifTrue:[ 
        self updateList.
    ].


    super update:aspect with:param from:sender

    "Modified: / 14-03-2014 / 23:58:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterChangesetHolderChanged
    | entry changeset |

    changeset := changesetHolder value.
    entry  :=(changeset notNil) 
                    ifTrue:[ self entryList detect: [:e | e changeset = changeset ] ifNone:[ nil ] ]
                    ifFalse:[ nil ].
    self entryHolder
        removeDependent: self;
        value: entry;
        addDependent: self.

    "Created: / 11-03-2014 / 20:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterEntryHolderChanged
    | entry  changeset |

    entry := entryHolder value.
    changeset := entry notNil ifTrue:[ entry changeset] ifFalse:[ nil ].
    (self changesetHolder)
        removeDependent:self;
        value:changeset;
        addDependent:self.

    "Created: / 11-03-2014 / 20:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2014 / 00:02:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    | changesets entries |

    changesets := self changesetList value.
    entries := changesets collect:[ :cs | HGChangesetPresenter new changeset: cs ].
    "/ Sort them from newest to oldest..."
    entries notEmpty ifTrue:[
        (entries first changeset timestamp < entries last changeset timestamp) ifTrue:[ 
            entries reverse.
        ].
    ].
    self entryList
        removeAll;
        addAll: entries.

    "Created: / 14-03-2014 / 23:58:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-03-2014 / 23:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetList methodsFor:'help texts'!

flyByHelpTextFor:aView
    aView == entryListView ifTrue:[ 
        | point line item |

        point := entryListView device pointerPosition.
        point := entryListView device translatePointFromRoot:point toView:entryListView.     
        line := entryListView yVisibleToLineNr: point y.
        line notNil ifTrue:[ 
            item := entryListView list at: line ifAbsent:[ nil ].
            item notNil ifTrue:[
              ^ item helpText
            ].
        ].
    ].
    ^ super flyByHelpTextFor:aView

    "Created: / 10-09-2015 / 18:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetList methodsFor:'hooks'!

postBuildEntryListView:aView
    <resource: #uiCallback>
    entryListView := aView scrolledView.

    "Modified: / 15-03-2014 / 15:02:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 10-09-2015 / 09:23:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

