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
"{ Package: 'stx:libscm/common' }"

"{ NameSpace: Smalltalk }"

SCMAbstractDialog subclass:#SCMAbstractCommitDialog
	instanceVariableNames:'task messageView messageModifiedHolder fileSelectionHolder
		fileListShowOnlyModifiedHolder fileListHolder fileListView
		enabledHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX-Interface'
!

Object subclass:#FileEntry
	instanceVariableNames:'application entry include includeEditable name icon'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SCMAbstractCommitDialog
!

!SCMAbstractCommitDialog class methodsFor:'documentation'!

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

!SCMAbstractCommitDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::CommitDialog2 andSelector:#contentSpec
     SVN::CommitDialog2 new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Commit...'
          name: 'Commit...'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 698 529)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'VariablePanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'MessageAndInfoPane'
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
                       (ViewSpec
                          name: 'MessagePane'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          component: 
                         (SpecCollection
                            collection: (
                             (LabelSpec
                                label: 'Commit message:'
                                name: 'MessageLabel'
                                layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                                translateLabel: true
                                adjust: left
                              )
                             (TextEditorSpec
                                name: 'Message'
                                layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                                enableChannel: enabledHolder
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                modifiedChannel: messageModifiedHolder
                                hasKeyboardFocusInitially: false
                                postBuildCallback: messageView:
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'FilePane'
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'FilePaneSpec'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          minorKey: filePaneSpec
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )
!

fileListColumnSpec
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SCMAbstractCommitDialog andSelector:#fileListColumnSpec
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Icon'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         width: 22
         minWidth: 22
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: icon
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Check'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: None
         width: 22
         minWidth: 22
         height: heightOfFirstRow
         editorType: CheckToggle
         rendererType: CheckToggle
         model: include
         menuFromApplication: false
         printSelector: include
         selectSelector: includeEditable
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'File'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: pathText
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
!

filePaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SCMAbstractCommitDialog andSelector:#filePaneSpec
     SCMAbstractCommitDialog new openInterface:#filePaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: filePaneSpec
       window: 
      (WindowSpec
         label: 'File List'
         name: 'File List'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 586 403)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Checked files will be commited to repository.'
             name: 'FileListLabel'
             layout: (LayoutFrame 0 0 10 0 0 1 35 0)
             translateLabel: true
             adjust: left
           )
          (DataSetSpec
             name: 'WCEntryTable'
             layout: (LayoutFrame 0 0 35 0 0 1 -30 1)
             enableChannel: enabledHolder
             model: fileSelectionHolder
             menu: fileListMenu
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             dataList: fileListHolder
             useIndex: false
             columnHolder: fileListColumnSpec
             showLabels: false
             postBuildCallback: postBuildFileListView:
           )
          (CheckBoxSpec
             label: 'Show only modified entries'
             name: 'ShowOnlyChanged'
             layout: (LayoutFrame 0 0 -30 1 -170 1 0 1)
             enableChannel: enabledHolder
             model: fileListShowOnlyModifiedHolder
             translateLabel: true
           )
          (LinkButtonSpec
             label: 'Browse working copy'
             name: 'BrowseWC'
             layout: (LayoutFrame -170 1 -30 1 0 1 0 1)
             translateLabel: true
             labelChannel: browseWorkingCopyLabel
             adjust: right
             model: doBrowseWorkingCopy
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
     UIPainter new openOnClass:SCMAbstractCommitDialog andSelector:#windowSpec
     SCMAbstractCommitDialog new openInterface:#windowSpec
     SCMAbstractCommitDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SubVersion: Dialog '
         name: 'SubVersion: Dialog '
         labelChannel: titleHolder
         min: (Point 10 10)
         bounds: (Rectangle 0 0 648 451)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'TitleBox'
             layout: (LayoutFrame 0 0 0 0 0 1 66 0)
             backgroundColor: (Color 100.0 100.0 100.0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'DialogTitle'
                   name: 'DialogTitle'
                   layout: (LayoutFrame 10 0 0 0 -75 1 40 0)
                   style: (FontDescription helvetica medium roman 18 #'iso10646-1')
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: titleHolder
                   adjust: left
                 )
                (LabelSpec
                   label: 'DialogSubtitle'
                   name: 'DialogSubtitle'
                   layout: (LayoutFrame 30 0 40 0 -75 1 66 0)
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: subtitleHolder
                   resizeForLabel: false
                   adjust: left
                 )
                (LabelSpec
                   label: 'Icon'
                   name: 'DialogIcon'
                   layout: (LayoutFrame -157 1 0 0 0 1 66 0)
                   hasCharacterOrientedLabel: false
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: dialogIconAspect
                   adjust: right
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'ContentBox'
             layout: (LayoutFrame 5 0 70 0 -5 1 -50 1)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'Content'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   specHolder: contentSpecHolder
                   createNewBuilder: false
                 )
                )
              
             )
           )
          (DividerSpec
             name: 'Separator'
             layout: (LayoutFrame 5 0 -50 1 -5 1 -30 1)
           )
          (UISubSpecification
             name: 'Buttons'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             minorKey: buttonsSpec
           )
          )
        
       )
     )
! !

!SCMAbstractCommitDialog class methodsFor:'menu specs'!

fileListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SCMAbstractCommitDialog andSelector:#fileListMenu
     (Menu new fromLiteralArrayEncoding:(SCMAbstractCommitDialog fileListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canShowDiffsForEntry
            label: 'Show differences'
            itemValue: doShowDiffsForEntry
          )
         (MenuItem
            enabled: canShowDiffsForEntry
            label: 'Show differences (against newest)'
            itemValue: doShowDiffsForEntryAgainstHEAD
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Select All Files'
            itemValue: doSelectAll
          )
         (MenuItem
            label: 'Unselect all Files'
            itemValue: doSelectNone
          )
         )
        nil
        nil
      )
! !

!SCMAbstractCommitDialog methodsFor:'accessing'!

defaultSubtitle
    | t packages|

    t := self task.
    packages := t packages.
    ^packages notEmptyOrNil ifTrue:[
        packages size == 1 ifTrue:[
            'Package: ' , packages anElement name asText allItalic
        ] ifFalse:[ 
            'Packages: ' , ((packages collect:[:e | e name ]) asStringWith: ', ')
        ].
    ] ifFalse:[
        | title |

        title := t temporaryWorkingCopy root pathName , ' [' , t temporaryWorkingCopy branch name , ']'.
        title size > 70 ifTrue:[
            title := '...' , (title copyFrom: title size - 67).
        ].
        title.
    ]

    "Created: / 28-10-2008 / 09:14:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-02-2014 / 23:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileListToCommit
    ^(self fileListHolder value ? #()) 
        select:[:entry|entry include]
        thenCollect:[:entry|entry path].

    "Created: / 08-02-2012 / 18:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message

    ^messageView notNil 
        ifTrue:[messageView contents]
        ifFalse:[nil]

    "Created: / 31-03-2008 / 21:06:28 / janfrog"
    "Modified: / 09-04-2009 / 08:50:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 18:07:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message: aString

    ^messageView contents: aString

    "Created: / 08-04-2009 / 23:27:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 18:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model
    <resource: #obsolete>

    self breakPoint: #jv.
    ^self task

    "Created: / 12-01-2013 / 11:59:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

task

    ^task

    "Created: / 23-03-2009 / 11:49:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-01-2013 / 11:57:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

task: t
    task := t.

    "Created: / 23-03-2009 / 11:49:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-01-2013 / 12:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy

    ^self task workingCopy

    "Created: / 08-02-2012 / 18:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'acessing-views'!

messageView: aView

    messageView := aView scrolledView.
"/    messageView model:
"/        (self class messages
"/            at: self task package
"/            ifAbsent:[self task message])

    "Created: / 08-02-2012 / 17:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'actions'!

doAccept

    self showProgressWhile:[
        self acceptEnabled:false.
        (self task)
            message:self message;
            paths: self fileListToCommit;
            doCommit.
        self accept value:true
    ]

    "Created: / 01-04-2008 / 18:59:12 / janfrog"
    "Modified: / 19-08-2009 / 14:26:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 18:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-11-2012 / 10:12:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doBrowseWorkingCopy
    self task temporaryWorkingCopyRoot browse

    "Modified: / 12-01-2013 / 14:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCommitAllChangedPackages
    | revision packages |

    "/ Collect all changed packages at given revision...    
    revision := task packages revision.
    packages := task packages class new.
    task packages anElement root yourselfAndAllChildrenDo:[:each|
        (each isVirtual not and:[each revision = revision and:[ each hasChanges ]]) ifTrue:[ 
            packages  add: each.
        ].
    ].
    task packages: packages.

    "Created: / 03-03-2014 / 10:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 16:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntry
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

doShowDiffsForEntryAgainstHEAD
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

postBuildFileListView: aScrolledView
    <resource: #uiCallback>

    fileListView := aScrolledView scrolledView.
    "/ Ugly hack to make it working on 6.2.2, sigh.
"/    (ListModelView::TableRenderer canUnderstand: #showItemInAdditionToColumns:) ifTrue:[
"/        fileListView setupTableRenderer
"/            showItemInAdditionToColumns: false;
"/            columnDescriptors: self class fileListColumnSpec.   
"/    ].

    "Modified: / 29-11-2013 / 15:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'aspects'!

acceptButtonTitleAspect

    ^'Commit'

    "Created: / 08-02-2012 / 17:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browseWorkingCopyLabel

    ^'Browse working copy...' asText
        colorizeAllWith: Color blue;
        actionForAll:[ self doBrowseWorkingCopy ];
        yourself

    "Created: / 05-02-2012 / 01:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enabledHolder
    <resource: #uiAspect>

    enabledHolder isNil ifTrue:[
        enabledHolder := true asValue.
    ].
    ^ enabledHolder.

    "Modified (comment): / 11-02-2012 / 23:28:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileListHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileListHolder isNil ifTrue:[
        fileListHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileListHolder addDependent:self.
"/       fileListHolder onChangeSend:#fileListHolderChanged to:self.
    ].
    ^ fileListHolder.

    "Modified: / 08-02-2012 / 18:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileListShowOnlyModifiedHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileListShowOnlyModifiedHolder isNil ifTrue:[
        fileListShowOnlyModifiedHolder := true asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileListShowOnlyModifiedHolder addDependent:self.
       fileListShowOnlyModifiedHolder onChangeSend:#updateFileList to:self.
    ].
    ^ fileListShowOnlyModifiedHolder.

    "Modified: / 08-02-2012 / 18:04:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileSelectionHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileSelectionHolder isNil ifTrue:[
        fileSelectionHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileSelectionHolder addDependent:self.
"/       fileSelectionHolder onChangeSend:#fileSelectionHolderChanged to:self.
    ].
    ^ fileSelectionHolder.
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new.
        infoPanel panelHiddenHolder: self enabledHolder.
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageModifiedHolder
    "return/create the 'messageModifiedHolder' value holder (automatically generated)"

    messageModifiedHolder isNil ifTrue:[
        messageModifiedHolder := ValueHolder with: false.
        messageModifiedHolder onChangeEvaluate:[
            self acceptEnabled: (self message indexOfNonSeparator ~~ 0).
            messageModifiedHolder setValue: false.
        ]
    ].
    ^ messageModifiedHolder

    "Modified: / 08-02-2012 / 18:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'change & update'!

updateFileList
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!SCMAbstractCommitDialog methodsFor:'hooks'!

commonPostBuild

    self window extent: 640@640

    "Created: / 08-02-2012 / 18:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith1: anUIBuilder

    (self task isPackageCommit 
        and:[ self task isSelectiveFileoutTask not
        and:[ self task isCommitingAllChangedPackages not ]]) ifTrue:[ 
        self infoPanel 
            reset;
            beInformation;
            message:(resources string: 'There are more changed packages...');
            addButtonWithLabel: (resources string:'Commit all changed') 
                        action: [ self doCommitAllChangedPackages. self infoPanel hide. self postOpenWith2: anUIBuilder];
            addButtonWithLabel: (resources string:'Continue') 
                        action: [ self infoPanel hide. self postOpenWith2: anUIBuilder];
            show.
        ^ false.
    ].
    ^ true.

    "Created: / 03-03-2014 / 10:00:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 16:03:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith2: anUIBuilder

    self showProgressWhile:[ 
        self doUpdateCode.
        self doRunSanityChecks.
        self doUpdateButtonEnablements.
    ].

    "Created: / 03-03-2014 / 09:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 15:06:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith: anUIBuilder
    (self postOpenWith1: anUIBuilder) ifTrue:[ 
        self postOpenWith2: anUIBuilder   
    ].

    "Created: / 09-02-2012 / 15:23:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2014 / 10:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'menu actions'!

doSelectAll
    self doSelectAllMatching: [ :file | true ]

    "Modified: / 19-01-2015 / 10:01:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectAllMatching: block
    (self fileListHolder value ? #()) do:[:each | 
        each include: (block value: each entry)
    ].
    fileListView invalidate

    "Created: / 19-01-2015 / 10:00:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectNone
    self doSelectAllMatching: [ :file | false ]

    "Created: / 19-01-2015 / 10:00:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'private'!

doRunSanityChecks

    | checker problems anyError |

    self task isPackageCommit ifFalse:[
        ^self.
    ].

    ActivityNotification notify: (self resources string:'Checking code...').
    checker := self task doSanityChecks.
    "/ #doSanityChecks may return nil if the ProjectChecker is not available
    "/ (like in St/X 6.2.2)
    (checker isNil or:[(problems := checker problems) isEmptyOrNil]) ifTrue:[
        self doUpdateWorkingCopy.
        ^self.
    ].

    anyError := problems anySatisfy:[:problem|problem severity == #error].
    self infoPanel 
        reset;
        beWarning;
        message: 
            (problems size == 1 
                ifTrue:[self resources string:'A problem has been found in the code']
                ifFalse:[problems size printString , (self resources string:' problems has been found in the code')]);

        addButtonWithLabel: (self resources string:'Show')
                    action: [
                        Tools::ProjectCheckerBrowser new projectChecker: checker; open. self doCancel 
                    ];

        addButton:((Button label: (self resources string:'OK') 
                    action: [
                        self infoPanel beProgress.
                        self doUpdateWorkingCopy.
                        self infoPanel hide
                    ]) enabled: anyError not; yourself);

        addButtonWithLabel: (self resources string:'Cancel') 
                    action:[self doCancel];

        show.
    ^anyError not

    "Created: / 10-05-2012 / 17:24:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-06-2013 / 12:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-02-2014 / 23:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateButtonEnablements
    self messageModifiedHolder changed:#value.

    "Created: / 26-03-2014 / 15:06:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateCode
    self task doPrepareWorkingCopy1

    "Created: / 10-05-2012 / 17:24:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateWorkingCopy

    self task doPrepareWorkingCopy2.
    self message: self task message.
    self messageModifiedHolder changed:#value.
    self updateFileList.

    "Created: / 10-05-2012 / 17:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog methodsFor:'queries'!

canShowDiffsForEntry
    ^self fileSelectionHolder value notEmptyOrNil

    "Created: / 11-07-2013 / 01:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog::FileEntry class methodsFor:'instance creation'!

application:applicationArg entry:entryArg name: nameArg 

    ^self new application:applicationArg entry:entryArg name: nameArg

    "Created: / 15-11-2012 / 01:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog::FileEntry methodsFor:'accessing'!

author
    ^entry author

    "Created: / 09-02-2012 / 14:36:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

date
    ^entry date

    "Created: / 09-02-2012 / 14:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

entry
    ^ entry
!

icon
    ^ icon

    "Created: / 29-11-2013 / 14:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon: anImage
    icon := anImage

    "Created: / 29-11-2013 / 14:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

include
    ^ include
!

include:aBoolean
    include := aBoolean.
!

includeEditable
    ^ includeEditable
!

includeEditable:something
    includeEditable := something.
!

path
    ^entry pathName

    "Created: / 09-02-2012 / 14:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 01:36:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathText
    ^name

    "Created: / 09-02-2012 / 14:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 01:36:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^entry revision

    "Created: / 09-02-2012 / 14:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statusIcon
    ^nil

    "Created: / 09-02-2012 / 14:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 01:30:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog::FileEntry methodsFor:'initialization'!

application:applicationArg entry:entryArg name: nameArg 
    application := applicationArg.
    entry := entryArg.
    include := true.
    includeEditable := true.
    name := nameArg.

    "Created: / 15-11-2012 / 01:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 13:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractCommitDialog class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

