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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Browser subclass:#RevisionLogBrowser
	instanceVariableNames:'branchHolder pathHolder changedPathSelectionHolder infoPanel'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers'
!

!RevisionLogBrowser class methodsFor:'documentation'!

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
!

example1

    SVN::RevisionLogBrowser new
        branch: self svnRepository branch;
        open
!

example2

    SVN::RevisionLogBrowser new
        open;
        branch: self svnRepository branch
! !

!RevisionLogBrowser class methodsFor:'interface specs'!

changedPathsTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::RevisionLogBrowser andSelector:#changedPathsTabSpec
     SVN::RevisionLogBrowser new openInterface:#changedPathsTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: changedPathsTabSpec
        window: 
       (WindowSpec
          label: 'Changed paths'
          name: 'Changed paths'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SelectionInListModelViewSpec
              name: 'ChangedPaths'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: changedPathSelectionHolder
              menu: changedPathsMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: changedPathsHolder
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )
!

commentTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::RevisionLogBrowser andSelector:#commentTabSpec
     SVN::RevisionLogBrowser new openInterface:#commentTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: commentTabSpec
        window: 
       (WindowSpec
          label: 'Comment'
          name: 'Comment'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'Comment'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: messageHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              hasKeyboardFocusInitially: false
            )
           )
         
        )
      )
!

revisionDetailsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::RevisionLogBrowser andSelector:#revisionDetailsSpec
     SVN::RevisionLogBrowser new openInterface:#revisionDetailsSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: revisionDetailsSpec
        window: 
       (WindowSpec
          label: 'Revision Details'
          name: 'Revision Details'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'EntryDetails'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              menu: entryDetailsTabList
              keepCanvasAlive: true
            )
           )
         
        )
      )
!

revisionListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::RevisionLogBrowser andSelector:#revisionListSpec
     SVN::RevisionLogBrowser new openInterface:#revisionListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: revisionListSpec
        window: 
       (WindowSpec
          label: 'Revision List'
          name: 'Revision List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'RevisionList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              visibilityChannel: workNotInProgressHolder
              model: selectionHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: listHolder
              useIndex: false
              columnHolder: tableColumns
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
     UIPainter new openOnClass:SVN::RevisionLogBrowser andSelector:#windowSpec
     SVN::RevisionLogBrowser new openInterface:#windowSpec
     SVN::RevisionLogBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Revision log browser'
          name: 'Revision log browser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 600)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'InfoPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 40 0)
              level: 0
              initiallyInvisible: true
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: infoPanel
              createNewBuilder: false
            )
           (VariableVerticalPanelSpec
              name: 'RevisionLogPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'RevisionList'
                    minorKey: revisionListSpec
                  )
                 (UISubSpecification
                    name: 'RevisionDetails'
                    minorKey: revisionDetailsSpec
                  )
                 )
               
              )
              handles: (Any 0.7 1.0)
            )
           )
         
        )
      )

    "Modified: / 10-07-2012 / 16:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionLogBrowser class methodsFor:'list specs'!

entryDetailsTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#entryDetailsTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Comment'
          minorKey: commentTabSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Changed paths'
          minorKey: changedPathsTabSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!RevisionLogBrowser class methodsFor:'menu specs'!

changedPathsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::RevisionLogBrowser andSelector:#changedPathsMenu
     (Menu new fromLiteralArrayEncoding:(SVN::RevisionLogBrowser changedPathsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Compare with image'
            itemValue: changedPathCompareWithImage
            translateLabel: true
          )
         (MenuItem
            enabled: false
            label: 'Compare with HEAD'
            itemValue: changedPathCompareWithHead
            translateLabel: true
          )
         (MenuItem
            enabled: false
            label: 'Compare...'
            itemValue: changedPathCompare
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect'
            itemValue: changedPathInspect
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!RevisionLogBrowser class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RevisionLogBrowser class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #branchHolder
        #pathHolder
        #selectionHolder
      ).

! !

!RevisionLogBrowser class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SVN::RevisionSelectionDialog andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Revision'
         activeHelpKey: ''
         labelButtonType: Button
         printSelector: revision
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Author'
         activeHelpKey: ''
         labelButtonType: Button
         printSelector: author
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Date'
         activeHelpKey: ''
         labelButtonType: Button
         printSelector: date
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )

    "Created: / 21-05-2008 / 09:22:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RevisionLogBrowser methodsFor:'accessing'!

branch

    ^self branchHolder value
!

branch: aSVNBranch

    ^self branchHolder value: aSVNBranch
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path

    ^self pathHolder value

    "Created: / 25-06-2010 / 10:04:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path: aString

    ^self pathHolder value: aString

    "Created: / 25-06-2010 / 10:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionLogBrowser methodsFor:'aspects'!

branchHolder
    "return/create the 'branchHolder' value holder (automatically generated)"

    branchHolder isNil ifTrue:[
        branchHolder := ValueHolder new.
        branchHolder addDependent:self.
    ].
    ^ branchHolder
!

branchHolder:something
    "set the 'branchHolder' value holder (automatically generated)"

    |oldValue newValue|

    branchHolder notNil ifTrue:[
        oldValue := branchHolder value.
        branchHolder removeDependent:self.
    ].
    branchHolder := something.
    branchHolder notNil ifTrue:[
        branchHolder addDependent:self.
    ].
    newValue := branchHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:branchHolder.
    ].
!

changedPathSelectionHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    changedPathSelectionHolder isNil ifTrue:[
        changedPathSelectionHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       changedPathSelectionHolder addDependent:self.
"/       changedPathSelectionHolder onChangeSend:#changedPathSelectionHolderChanged to:self.
    ].
    ^ changedPathSelectionHolder.
!

changedPathsHolder

    ^(AspectAdaptor forAspect:#changedPaths)
        subjectChannel: self selectionHolder
!

hasRevisionSelectedHolder

    ^(AspectAdaptor forAspect:#notNil)
        subjectChannel: self selectionHolder
!

messageHolder

    ^(AspectAdaptor forAspect:#message)
        subjectChannel: self selectionHolder
!

pathHolder
    "return/create the 'pathHolder' value holder (automatically generated)"

    pathHolder isNil ifTrue:[
        pathHolder := ValueHolder new.
        pathHolder addDependent:self.
    ].
    ^ pathHolder
!

pathHolder:something
    "set the 'pathHolder' value holder (automatically generated)"

    |oldValue newValue|

    pathHolder notNil ifTrue:[
        oldValue := pathHolder value.
        pathHolder removeDependent:self.
    ].
    pathHolder := something.
    pathHolder notNil ifTrue:[
        pathHolder addDependent:self.
    ].
    newValue := pathHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:pathHolder.
    ].
! !

!RevisionLogBrowser methodsFor:'change & update'!

update: aspect with: param from: sender

    (sender = branchHolder or:[sender = pathHolder])
        ifTrue:[self updateList]
! !

!RevisionLogBrowser methodsFor:'hooks'!

postOpenWith: anUIBuilder

    self updateList
! !

!RevisionLogBrowser methodsFor:'menu actions'!

changedPathCompare
    "automatically generated by UIEditor ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be added ..."

    Transcript showCR:self class name, ': action for #changedPathCompare ...'.
!

changedPathCompareWithHead
    "automatically generated by UIEditor ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be added ..."

    Transcript showCR:self class name, ': action for #changedPathCompareWithHead ...'.
!

changedPathCompareWithImage

    | action entry |
    action := self changedPathSelectionHolder value.
    action ifNil:[^self].
    entry := action entry.
    entry programmingLanguage isSmalltalk ifTrue:[                  
        | rev imageChangeSet revChangeSet diff |
        rev := self selectionHolder value revision.
        imageChangeSet := (entry path = 'extensions.st') 
            ifTrue: [ChangeSet forExistingMethods: (self branch repository packageExtensions)]
            ifFalse:[ChangeSet forExistingClass: (Repository classFromContainerName: entry path)].
        revChangeSet := ChangeSet fromStream: (self entryContents: entry path atRevision: rev) readStream.
        diff :=  (ChangeSetDiff versionA: imageChangeSet versionB: revChangeSet)
                    name: entry path;
                    versionALabel: 'Current (in image)';
                    versionBLabel: rev printString.
        Tools::ChangeSetDiffTool new
            beTwoColumn:false;
            diffset:diff;
            open
    ] ifFalse:[
        self breakPoint: #jv.
        Dialog warn: 'Not yet implemented'
    ].

    "Modified: / 25-06-2010 / 11:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 23:08:27 / jv"
!

changedPathInspect

    changedPathSelectionHolder value inspect

    "Modified: / 25-06-2010 / 10:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionLogBrowser methodsFor:'private'!

entryContents: entry atRevision: rev

    ^self branch cat: entry revision: rev

    "Created: / 25-06-2010 / 11:08:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList

    | panel |

    (masterApplication respondsTo: #infoPanel) ifTrue:[
        panel := masterApplication infoPanel
    ] ifFalse:[
        panel := self infoPanel.
    ].

    panel showProgressLabeled: (resources string: 'Reading revision log') while:[
        | branch path |
        self listHolder value: #().
        branch := self branchHolder value.
        branch isNil ifTrue:[ ^self ].
        path := self pathHolder value ? ''.
        self listHolder value:(branch log: path)
    ]

    "Modified: / 10-07-2012 / 16:03:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionLogBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RevisionLogBrowser.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
