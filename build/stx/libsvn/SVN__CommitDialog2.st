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

Dialog subclass:#CommitDialog2
	instanceVariableNames:'task messageView messageModifiedHolder fileSelectionHolder
		fileListShowOnlyModifiedHolder fileListHolder enabledHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

Object subclass:#FileEntry
	instanceVariableNames:'application entry include'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CommitDialog2
!

!CommitDialog2 class methodsFor:'documentation'!

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

!CommitDialog2 class methodsFor:'interface specs'!

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
     DataSetBuilder new openOnClass:SVN::CommitDialog2 andSelector:#fileListColumnSpec
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: ''
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: None
         width: 22
         minWidth: 22
         editorType: CheckToggle
         rendererType: CheckToggle
         model: include
         menuFromApplication: false
         printSelector: include
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: ''
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         width: 22
         minWidth: 22
         menuFromApplication: false
         printSelector: statusIcon
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Container'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         menuFromApplication: false
         printSelector: pathText
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Rev'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         usePreferredWidth: true
         menuFromApplication: false
         printSelector: revision
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Author'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         usePreferredWidth: true
         menuFromApplication: false
         printSelector: author
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Date'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         usePreferredWidth: true
         menuFromApplication: false
         printSelector: date
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
     UIPainter new openOnClass:SVN::CommitDialog2 andSelector:#filePaneSpec
     SVN::CommitDialog2 new openInterface:#filePaneSpec
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
              multipleSelectOk: true
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
     UIPainter new openOnClass:SVN::Dialog andSelector:#windowSpec
     SVN::Dialog new openInterface:#windowSpec
     SVN::Dialog open
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
                    label: 'SVN Dialog'
                    name: 'DialogTitle'
                    layout: (LayoutFrame 10 0 0 0 -75 1 40 0)
                    style: (FontDescription helvetica medium roman 18 #'iso10646-1')
                    backgroundColor: (Color 100.0 100.0 100.0)
                    translateLabel: true
                    labelChannel: titleHolder
                    adjust: left
                  )
                 (LabelSpec
                    label: 'SVN Dialog Subtitle'
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
                    layout: (LayoutFrame -75 1 0 0 0 1 66 0)
                    hasCharacterOrientedLabel: false
                    backgroundColor: (Color 100.0 100.0 100.0)
                    translateLabel: true
                    labelChannel: dialogIconAspect
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
              layout: (LayoutFrame 130 0 -30 1 0 1 0 1)
              minorKey: buttonsSpec
            )
           (LinkButtonSpec
              label: 'Help'
              name: 'Help'
              layout: (LayoutFrame 30 0 -30 1 130 0 0 1)
              style: (FontDescription helvetica medium roman 12 #'iso10646-1')
              initiallyInvisible: true
              foregroundColor: (Color 0.0 0.0 86.9993133440147)
              translateLabel: true
              model: doHelp
            )
           (MenuPanelSpec
              name: 'More'
              layout: (LayoutFrame 0 0 -30 1 30 0 -50 1)
              level: 0
              model: doInspect
              menu: actionsMenu
            )
           )

        )
      )

    "Created: / 17-07-2012 / 18:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 class methodsFor:'menu specs'!

fileListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SVN::CommitDialog2 andSelector:#fileListMenu
     (Menu new fromLiteralArrayEncoding:(SVN::CommitDialog2 fileListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Show differences'
            itemValue: doShowDiffsForEntry
            translateLabel: true
          )
         (MenuItem
            label: 'Show differences (against HEAD)'
            itemValue: doShowDiffsForEntryAgainstHEAD
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!CommitDialog2 methodsFor:'accessing'!

defaultSubtitle
    | t |

    t := self task.
    ^t package notNil ifTrue:[
        'Package: ' , t package asText allItalic
    ] ifFalse:[
        t workingCopy branch url asText allItalic
    ]

    "Created: / 28-10-2008 / 09:14:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 18:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

task

    ^self model

    "Created: / 23-03-2009 / 11:49:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

task: aTask

    ^self model: aTask

    "Created: / 23-03-2009 / 11:49:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopy

    ^self task workingCopy

    "Created: / 08-02-2012 / 18:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 methodsFor:'acessing-views'!

messageView: aView

    messageView := aView scrolledView.
"/    messageView model:
"/        (self class messages
"/            at: self task package
"/            ifAbsent:[self task message])

    "Created: / 08-02-2012 / 17:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 methodsFor:'actions'!

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
!

doBrowseWorkingCopy
    self workingCopy browse

    "Modified: / 04-02-2012 / 17:15:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntry

    self fileSelectionHolder value do:[:each|
        self doShowDiffsForEntry: each entry against: Revision base
    ].

    "Created: / 09-02-2012 / 14:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntry: entry against: rev
    |wc wcChangeSet repoChangeSet diffset lang |

    wc := self task workingCopy.
    lang := entry programmingLanguage.
    (lang notNil and: [lang isSmalltalk]) ifTrue:[
        wcChangeSet := wc changeSetForContainer:entry path.
        wcChangeSet name: wcChangeSet name, (resources string: ' (working copy - to be commited)').
        repoChangeSet := wc changeSetForContainer:entry path revision:rev.
        diffset := ChangeSetDiff versionA:wcChangeSet versionB:repoChangeSet.
        (Tools::ChangeSetDiffTool new)
            beSingleColumn;
            diffset:diffset;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: entry path with: rev printString);
            showVersionMethodDiffs: false;
            open
    ] ifFalse:[
        | text1 text2 |
        text1 := (wc containerReadStreamFor: entry path) contents asString.
        text2 := wc cat: entry path revision: rev.
        "/Argh...backward compatibility..."
        (Tools::TextDiff2Tool ? Tools::TextDiffTool) new
            labelA: 'Working copy';
            labelB: ('r %1' bindWith: rev printString);
            textA: text1; textB: text2;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: entry path with: rev printString);
            open
    ]

    "Created: / 09-02-2012 / 14:53:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntryAgainstHEAD

    self fileSelectionHolder value do:[:each|
        self doShowDiffsForEntry: each entry against: Revision head
    ].

    "Created: / 10-02-2012 / 10:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 methodsFor:'aspects'!

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

!CommitDialog2 methodsFor:'change & update'!

updateFileList
    | entries showOnlyModified |

    showOnlyModified := fileListShowOnlyModifiedHolder value.
    entries := self workingCopy status.
    entries := entries reject:
        [:e|
        e status isUnversionedOrIgnoredOrMissing or:
            [
                fileListShowOnlyModifiedHolder value and:[ e status isNormal ]
            ]].
    entries := entries collect:[:entry|FileEntry application: self entry: entry].
    self fileListHolder value: entries

    "Created: / 08-02-2012 / 18:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 methodsFor:'hooks'!

commonPostBuild

    self window extent: 640@640

    "Created: / 08-02-2012 / 18:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith: anUIBuilder

    self showProgressWhile:[ 
        self doUpdateCode.
        self doRunSanityChecks
    ].

    "Created: / 09-02-2012 / 15:23:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 methodsFor:'private'!

doRunSanityChecks

    | checker problems anyError |

    self task isPackageCommit ifFalse:[
        self doUpdateWorkingCopy.
        ^self.
    ].

    ActivityNotification notify: (self resources string:'Checking code...').
    problems := (checker := self task doSanityChecks) problems.
    problems isEmptyOrNil ifTrue:[ 
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
!

showProgressWhile:aBlock 

    self infoPanel progress: 'Preparing working copy...' while: aBlock.

    "Created: / 21-10-2008 / 12:07:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:28:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-02-2012 / 23:03:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2::FileEntry class methodsFor:'instance creation'!

application:applicationArg entry:entryArg 

    ^self new application:applicationArg entry:entryArg

    "Created: / 09-02-2012 / 14:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2::FileEntry methodsFor:'accessing'!

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

include
    ^ include
!

include:aBoolean
    include := aBoolean.
!

path
    ^entry path

    "Created: / 09-02-2012 / 14:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathText
    ^entry pathText

    "Created: / 09-02-2012 / 14:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^entry revision

    "Created: / 09-02-2012 / 14:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statusIcon
    ^entry statusIcon

    "Created: / 09-02-2012 / 14:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2::FileEntry methodsFor:'initialization'!

application:applicationArg entry:entryArg 
    application := applicationArg.
    entry := entryArg.
    include := true

    "Modified: / 09-02-2012 / 14:35:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitDialog2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

