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

Browser subclass:#WorkingCopyBrowser
	instanceVariableNames:'workingCopyEntriesHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers'
!

!WorkingCopyBrowser class methodsFor:'documentation'!

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

!WorkingCopyBrowser class methodsFor:'instance creation'!

on: aWorkingCopy

    ^self new workingCopy: aWorkingCopy
! !

!WorkingCopyBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::WorkingCopyBrowser andSelector:#windowSpec
     SVN::WorkingCopyBrowser new openInterface:#windowSpec
     SVN::WorkingCopyBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Working Copy Status'
          name: 'Working Copy Status'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 586 403)
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'WCEntryTable'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              model: selectionHolder
              menu: entryMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: workingCopyEntriesHolder
              useIndex: false
              columnHolder: wcEntryTableColumns
              showLabels: false
            )
           (CheckBoxSpec
              label: 'Show only modified entries'
              name: 'ShowOnlyChanged'
              layout: (LayoutFrame 0 0 -30 1 -170 1 0 1)
              model: showOnlyChanged
              translateLabel: true
            )
           (LinkButtonSpec
              label: 'Browse working copy'
              name: 'BrowseWC'
              layout: (LayoutFrame -170 1 -30 1 0 1 0 1)
              translateLabel: true
              labelChannel: browseWorkingCopyLabel
              adjust: right
              model: browseWorkingCopy
            )
           )
         
        )
      )
! !

!WorkingCopyBrowser class methodsFor:'menu specs'!

entryMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::WorkingCopyBrowser andSelector:#entryMenu
     (Menu new fromLiteralArrayEncoding:(SVN::WorkingCopyBrowser entryMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Show changes'
            itemValue: entryMenuShowChanges
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' compare 'Show changes')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Revert'
            itemValue: entryMenuRevert
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' revert 'Revert')
          )
         )
        nil
        nil
      )
! !

!WorkingCopyBrowser class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WorkingCopyBrowser class methodsFor:'plugIn spec'!

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

!WorkingCopyBrowser class methodsFor:'tableColumns specs'!

wcEntryTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SVN::WorkingCopyBrowser andSelector:#wcEntryTableColumns
    "

    <resource: #tableColumns>

    ^#(
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
    
! !

!WorkingCopyBrowser methodsFor:'accessing'!

workingCopy

    ^self model

    "Created: / 11-04-2008 / 10:20:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-04-2008 / 21:02:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopy: aWorkingCopy

    self model: aWorkingCopy

    "Created: / 11-04-2008 / 10:20:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-04-2008 / 21:02:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopyBrowser methodsFor:'actions'!

browseWorkingCopy

    ^UserPreferences current fileBrowserClass 
        openOnDirectory: self workingCopy path

    "Created: / 05-02-2012 / 01:23:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browseWorkingCopyLabel

    ^'Browse working copy...' asText
        colorizeAllWith: Color blue;
        actionForAll:[ self browseWorkingCopy ];
        yourself

    "Created: / 05-02-2012 / 01:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopyBrowser methodsFor:'aspects'!

showOnlyChanged

    |holder|

    (holder := builder bindingAt:#showOnlyChanged) isNil ifTrue:[
        holder := true asValue.
        holder onChangeSend: #updateWorkingCopyEntries to: self.
        builder aspectAt:#showOnlyChanged put:holder.
    ].
    ^ holder.

    "Created: / 21-10-2008 / 18:53:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 00:43:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyEntriesHolder
    "return/create the 'workingCopyEntriesHolder' value holder (automatically generated)"

    workingCopyEntriesHolder isNil ifTrue:[
        workingCopyEntriesHolder := ValueHolder new.
    ].
    ^ workingCopyEntriesHolder

    "Modified: / 08-02-2012 / 00:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyEntriesHolder:something
    "set the 'workingCopyEntriesHolder' value holder (automatically generated)"

    workingCopyEntriesHolder := something.
! !

!WorkingCopyBrowser methodsFor:'change & update'!

updateWorkingCopyEntries
    | entries |

    entries := self model status.
    self showOnlyChanged value  ifTrue: [  
        entries := entries reject: [:entry | entry status isNormal ] 
    ].

    self workingCopyEntriesHolder value: entries

    "Created: / 08-02-2012 / 00:43:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopyBrowser methodsFor:'hooks'!

commonPostBuild

    self updateWorkingCopyEntries.
    self modelHolder onChangeSend: #updateWorkingCopyEntries to: self.

    "Created: / 11-04-2008 / 10:33:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-04-2008 / 21:05:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 00:47:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopyBrowser methodsFor:'menu actions'!

entryMenuRevert

    | entry |
    entry := self selection.
    entry ifNotNil:[entry revert]

    "Modified: / 09-10-2008 / 20:30:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 05-12-2009 / 20:10:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

entryMenuShowChanges
    self entryMenuShowChangesAgainst:SVN::Revision head

    "Modified: / 09-10-2008 / 20:30:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 05-12-2009 / 20:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

entryMenuShowChangesAgainst:rev 
    |wc entry wcChangeSet repoChangeSet diffset lang |
    wc := self model.
    entry := self selection.
    lang := entry programmingLanguage.
    (lang notNil and: [lang isSmalltalk]) ifTrue:[
        wcChangeSet := wc changeSetForContainer:entry path.
        wcChangeSet name: wcChangeSet name, ' (working copy)'.
        repoChangeSet := wc branch changeSetForContainer:entry path revision:rev.
        diffset := ChangeSetDiff versionA:wcChangeSet versionB:repoChangeSet.
        (Tools::ChangeSetDiffTool new)
            beSingleColumn;
            diffset:diffset;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: entry path with: rev printString);
            open
    ] ifFalse:[
        | text1 text2 |
        text1 := (wc containerReadStreamFor: entry path) contents asString.
        text2 := wc branch cat: entry path.
        (Tools::TextDiffTool new)
            labelA: 'Working copy';
            labelB: ('r %1' bindWith: rev printString);
            textA: text1; textB: text2;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: entry path with: rev printString);
            open
    ]

    "Created: / 09-10-2008 / 20:14:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 14:14:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2011 / 23:09:09 / jv"
    "Modified: / 01-09-2011 / 12:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkingCopyBrowser methodsFor:'private'!

workingCopyEntries
    | status |

    status := self model status.
    ^ self showOnlyChanged value 
        ifTrue: [ status reject: [:entry | entry status isNormal ] ]
        ifFalse: [ status ]

    "Created: / 21-10-2008 / 18:55:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-08-2009 / 09:12:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WorkingCopyBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WorkingCopyBrowser.st 367 2011-09-01 11:32:31Z vranyj1 §'
! !
