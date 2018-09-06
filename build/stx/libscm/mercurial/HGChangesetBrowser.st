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

ApplicationModel subclass:#HGChangesetBrowser
	instanceVariableNames:'repositoryHolder revsetHolder revsetList revsetErrorHolder
		changesetList changesetHolder showDetailsHolder splitterView
		changesetViewer'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGChangesetBrowser class methodsFor:'documentation'!

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
!

documentation
"
    A browser on Mercurial history.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
    Open history browser on libscm Mercurial repository:
                                                                [exBegin]
    | repo |

    repo := HGRepository on: stx_libscm_mercurial packageDirectory / '..'.
    HGChangesetBrowser openOnRepository: repo.
                                                                [exEnd]
"
! !

!HGChangesetBrowser class methodsFor:'interface opening'!

openOnRepository: anHGRepository 
    ^ self openOnRepository: anHGRepository revset: nil

    "Created: / 24-03-2014 / 11:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openOnRepository: anHGRepository revset: anHGRevset
    ^ self new
        repository: anHGRepository;
        revset: (anHGRevset ? HGRevset new);
        open

    "Created: / 24-03-2014 / 11:33:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetBrowser class methodsFor:'interface specs'!

listAndDetailsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetBrowser andSelector:#listAndDetailsSpec
     HGChangesetBrowser new openInterface:#listAndDetailsSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: listAndDetailsSpec
       window: 
      (WindowSpec
         label: 'HG History Browser'
         name: 'HG History Browser'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 745 697)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VerticalSplitter'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'ChangesetListBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'RevsetEditor'
                         layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: HGRevsetEditor
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: errorHolder
                             aspect: revsetErrorHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: revsetHolder
                             aspect: revsetHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: revsetList
                             aspect: revsetList
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'ChangesetList'
                         layout: (LayoutFrame 0 0 26 0 0 1 0 1)
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: HGChangesetList
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: changesetHolder
                             aspect: changesetHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: changesetList
                             aspect: changesetList
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 1.0)
             postBuildCallback: postBuildVerticalSplitter:
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
     UIPainter new openOnClass:HGChangesetBrowser andSelector:#windowSpec
     HGChangesetBrowser new openInterface:#windowSpec
     HGChangesetBrowser open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'HG History Browser'
         name: 'HG History Browser'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 745 704)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'SubSpecification1'
             layout: (LayoutFrame 0 0 0 0 0 1 -20 1)
             minorKey: listAndDetailsSpec
           )
          (CheckBoxSpec
             label: 'Show details'
             name: 'CheckBox1'
             layout: (LayoutFrame 0 0 -20 1 0 1 0 1)
             model: showDetailsHolder
           )
          )
        
       )
     )
! !

!HGChangesetBrowser class methodsFor:'plugIn spec'!

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
        #repositoryHolder
        #revsetHolder
        #showDetailsHolder
      ).

! !

!HGChangesetBrowser methodsFor:'accessing'!

repository
    ^ self repositoryHolder value

    "Created: / 11-03-2014 / 20:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository: anHGRepository
    self repositoryHolder value: anHGRepository

    "Created: / 11-03-2014 / 20:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revset
    ^ self revsetHolder value

    "Created: / 11-03-2014 / 20:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revset: anHGRevset
    ^ self revsetHolder value: anHGRevset

    "Created: / 11-03-2014 / 20:55:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetBrowser methodsFor:'aspects'!

changesetHolder
    "return/create the 'changesetHolder' value holder (automatically generated)"

    changesetHolder isNil ifTrue:[
        changesetHolder := ValueHolder new.
    ].
    ^ changesetHolder
!

changesetHolder:something
    "set the 'changesetHolder' value holder (automatically generated)"

    changesetHolder := something.
!

changesetList
    "return/create the 'changesetList' value holder (automatically generated)"

    changesetList isNil ifTrue:[
        changesetList := List new.
    ].
    ^ changesetList

    "Modified: / 14-03-2014 / 23:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryHolder
    "return/create the 'repositoryHolder' value holder (automatically generated)"

    repositoryHolder isNil ifTrue:[
        repositoryHolder := ValueHolder new.
        repositoryHolder addDependent:self.
    ].
    ^ repositoryHolder
!

repositoryHolder:something
    "set the 'repositoryHolder' value holder (automatically generated)"

    |oldValue newValue|

    repositoryHolder notNil ifTrue:[
        oldValue := repositoryHolder value.
        repositoryHolder removeDependent:self.
    ].
    repositoryHolder := something.
    repositoryHolder notNil ifTrue:[
        repositoryHolder addDependent:self.
    ].
    newValue := repositoryHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:repositoryHolder.
    ].
!

revsetErrorHolder
    "return/create the 'revsetErrorHolder' value holder (automatically generated)"

    revsetErrorHolder isNil ifTrue:[
        revsetErrorHolder := ValueHolder new.
    ].
    ^ revsetErrorHolder
!

revsetHolder
    "return/create the 'revsetHolder' value holder (automatically generated)"

    revsetHolder isNil ifTrue:[
        revsetHolder := ValueHolder with: (HGRevset fromString:'limit(tip:0, 100)').
        revsetHolder addDependent:self.
    ].
    ^ revsetHolder

    "Modified: / 17-04-2014 / 09:56:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revsetHolder:something
    "set the 'revsetHolder' value holder (automatically generated)"

    |oldValue newValue|

    revsetHolder notNil ifTrue:[
        oldValue := revsetHolder value.
        revsetHolder removeDependent:self.
    ].
    revsetHolder := something.
    revsetHolder notNil ifTrue:[
        revsetHolder addDependent:self.
    ].
    newValue := revsetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:revsetHolder.
    ].
!

revsetList
    "return/create the 'revsetList' value holder (automatically generated)"

    revsetList isNil ifTrue:[
        revsetList := ValueHolder new.
    ].
    ^ revsetList
!

showDetailsHolder
    "return/create the 'showDetailsHolder' value holder (automatically generated)"

    showDetailsHolder isNil ifTrue:[
        showDetailsHolder := ValueHolder with: true.
        showDetailsHolder addDependent:self.
    ].
    ^ showDetailsHolder

    "Modified: / 24-03-2014 / 11:04:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDetailsHolder:something
    "set the 'showDetailsHolder' value holder (automatically generated)"

    |oldValue newValue|

    showDetailsHolder notNil ifTrue:[
        oldValue := showDetailsHolder value.
        showDetailsHolder removeDependent:self.
    ].
    showDetailsHolder := something.
    showDetailsHolder notNil ifTrue:[
        showDetailsHolder addDependent:self.
    ].
    newValue := showDetailsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showDetailsHolder.
    ].
! !

!HGChangesetBrowser methodsFor:'change & update'!

delayedUpdate: aspect with: param from: sender 

    sender == repositoryHolder ifTrue:[
        self updateRevsets.
        self updateList.
    ].

    sender == revsetHolder ifTrue:[ 
        self updateList.
    ].
    super delayedUpdate:aspect with:param from:sender

    "Created: / 11-03-2014 / 20:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-03-2014 / 21:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == repositoryHolder ifTrue:[ 
        self delayedUpdate: aspect with: param from: sender 
    ].
    sender == revsetHolder ifTrue:[ 
        self delayedUpdate: aspect with: param from: sender 
    ].
    sender == showDetailsHolder ifTrue:[ 
        self updateDetailsVisibility.
    ].

    super update:aspect with:param from:sender

    "Created: / 14-03-2014 / 23:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-03-2014 / 10:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateDetailsVisibility
    "raise an error: this method should be implemented (TODO)"

    | showDetails |

    splitterView isNil ifTrue:[ ^ self ].
    showDetails := self showDetailsHolder value.
    showDetails ifTrue:[ 
        splitterView subViews size == 1 ifTrue:[ 
            | changesetView |

            changesetView := ApplicationSubView new.
            changesetViewer isNil ifTrue:[    
                changesetViewer := HGChangesetViewer new.
                changesetViewer createBuilder.
                changesetViewer changesetHolder: self changesetHolder.
            ].
            changesetViewer window: changesetView.
            changesetView client: changesetViewer.
            splitterView addSubView: changesetView.
        ].
    ] ifFalse:[ 
        splitterView subViews size == 2 ifTrue:[ 
            splitterView removeSubView: splitterView subViews second.
        ]
    ].

    "Created: / 24-03-2014 / 10:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    self changesetList removeAll.
    self updateList1.

    "Created: / 11-03-2014 / 20:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList1
    self updateListWithLimit: 10.
    self revsetErrorHolder value isNil ifTrue:[
        self window isNil ifTrue:[ 
            self updateList2
        ] ifFalse:[
            self window sensor pushUserEvent: #updateList2 for: self.
        ].
    ].

    "Created: / 11-03-2014 / 20:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2014 / 02:13:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList2
    self updateListWithLimit: nil

    "Created: / 11-03-2014 / 20:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListWithLimit:limitOrNil
    | repository revset changesets |

    repository := self repositoryHolder value.
    repository isNil ifTrue:[
        ^ self.
    ].
    revset := self revsetHolder value.
    revset isNil ifTrue:[ 
        ^ self.
    ].
    [
        changesets := repository log: revset reverse limit: limitOrNil.
        self revsetErrorHolder value: nil.
    ] on: HGUnknownRevisionError do:[:ex |
        changesets := #().
        self revsetErrorHolder value: ex.
    ].
    self changesetList. "/ make sure it's initialized.

    (changesets size > changesetList size and:[changesets startsWith: changesetList]) ifTrue:[ 
        changesetList addAll: changesets from: changesetList size + 1 to: changesets size beforeIndex: changesetList size + 1
    ] ifFalse:[ 
        changesetList notEmpty ifTrue:[ 
            changesetList removeAll.
        ].
        changesetList addAll: changesets from: 1 to: changesets size beforeIndex: 1
    ].

    "Created: / 11-03-2014 / 20:37:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2014 / 02:10:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateRevsets
    | repo revsets |

    revsets := OrderedCollection new.
    repo := self repositoryHolder value.
    repo branches do:[:branch | 
        branch isClosed ifFalse:[
            revsets add:(HGRevset expression:('branch(%1)' bindWith: branch name) comment:(resources string: 'revisions in branch %1' with: branch name)).
        ].
    ].
    revsets add: (HGRevset expression:('head()') comment:(resources string: 'repository heads')).
    revsets add: (HGRevset expression:('bookmark()') comment:(resources string: 'bookmarked revisions')).
    self revsetList value: revsets.

    "Created: / 24-03-2014 / 21:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetBrowser methodsFor:'hooks'!

commonPostBuild
    self updateDetailsVisibility.

    "Created: / 24-03-2014 / 10:21:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildVerticalSplitter: aVariableVerticalPanel
    <resource: #uiCallback>

    splitterView := aVariableVerticalPanel.

    "Modified (format): / 24-03-2014 / 10:14:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

