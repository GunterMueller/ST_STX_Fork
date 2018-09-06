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

SCMAbstractCommitDialog subclass:#HGCommitDialog
	instanceVariableNames:'remoteHolder remoteListHolder remotePushHolder branchCreateHolder
		branchHolder moreOptionsHolder amendHolder amendLabel
		bookmarkCreateHolder bookmarkHolder commitingNewHeadAcknowledged'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGCommitDialog class methodsFor:'documentation'!

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

!HGCommitDialog class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:HGCommitDialog    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#amendLabelHelp
'Changeset to amend'

#bookmarkCreateHelp
''

#bookmarkHelp
'When checked, commited changeset will be assigned a bookmark.\\Usefull when one uses feature-branch like model.'

)
! !

!HGCommitDialog class methodsFor:'image specs'!

dialogIcon
    ^ HGIconLibrary hgLogo2

    "Created: / 14-11-2012 / 00:14:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 11:01:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGCommitDialog andSelector:#contentSpec
     HGCommitDialog new openInterface:#contentSpec
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
         bounds: (Rectangle 0 0 698 603)
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
                (VerticalPanelViewSpec
                   name: 'VerticalPanel1'
                   horizontalLayout: fit
                   verticalLayout: bottomSpaceFit
                   horizontalSpace: 3
                   verticalSpace: 3
                   elementsChangeSize: true
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
                                  (LinkButtonSpec
                                     label: 'More Options'
                                     name: 'MoreOptions'
                                     layout: (LayoutFrame -100 1 0 0 0 1 30 0)
                                     visibilityChannel: moreOptionsHiddenHolder
                                     translateLabel: true
                                     labelChannel: moreOptionsLabel
                                     adjust: right
                                     model: doShowMoreOptions
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
                         extent: (Point 698 188)
                       )
                      (ViewSpec
                         name: 'AmendBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Amend Commit'
                               name: 'AmendCheckBox'
                               layout: (LayoutFrame 0 0 2 0 0 1 25 0)
                               activeHelpKey: amendLabelHelp
                               visibilityChannel: canAmendHolder
                               model: amendHolder
                               translateLabel: true
                               labelChannel: amendLabel
                             )
                            )
                          
                         )
                         extent: (Point 698 25)
                       )
                      (ViewSpec
                         name: 'BookmarkBox'
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Bookmark'
                               name: 'CheckBox2'
                               layout: (LayoutFrame 0 0 2 0 215 0 25 0)
                               activeHelpKey: bookmarkHelp
                               model: bookmarkCreateHolder
                               translateLabel: true
                             )
                            (ComboBoxSpec
                               name: 'ComboBox1'
                               layout: (LayoutFrame 215 0 0 0 0 1 0 1)
                               activeHelpKey: bookmarkHelp
                               enableChannel: bookmarkCreateHolder
                               model: bookmarkHolder
                               emptyFieldReplacementText: 'Bookmark name'
                               comboList: bookmarkList
                             )
                            )
                          
                         )
                         extent: (Point 698 24)
                       )
                      (ViewSpec
                         name: 'BranchBox'
                         visibilityChannel: moreOptionsVisibleHolder
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Commit into new branch'
                               name: 'BranchCheckBox'
                               layout: (LayoutFrame 0 0 2 0 215 0 25 0)
                               model: branchCreateHolder
                               translateLabel: true
                             )
                            (InputFieldSpec
                               name: 'EntryField1'
                               layout: (LayoutFrame 215 0 0 0 0 1 0 1)
                               enableChannel: branchCreateHolder
                               model: branchHolder
                               emptyFieldReplacementText: 'Branch name'
                             )
                            )
                          
                         )
                         extent: (Point 698 25)
                       )
                      (ViewSpec
                         name: 'PushBox'
                         visibilityChannel: moreOptionsVisibleHolder
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Push to upstream repository'
                               name: 'CheckBox1'
                               layout: (LayoutFrame 0 0 2 0 215 0 25 0)
                               model: remotePushHolder
                               translateLabel: true
                             )
                            (ComboListSpec
                               name: 'ComboList2'
                               layout: (LayoutFrame 215 0 0 0 0 1 0 1)
                               enableChannel: remotePushHolder
                               model: remoteHolder
                               comboList: remoteListHolder
                             )
                            )
                          
                         )
                         extent: (Point 698 25)
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
! !

!HGCommitDialog methodsFor:'accessing'!

task: anHGCommitTask
    super task: anHGCommitTask.
    self updateAmendLabel.

    "Created: / 25-08-2015 / 12:48:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'actions'!

doAccept
    self task amend: self amendHolder value.

    self remotePushHolder value 
        ifTrue:[self task remote: self remoteHolder value] 
        ifFalse:[self task remote: nil].
    self branchCreateHolder value 
        ifTrue:[self task branch: self branchHolder value] 
        ifFalse:[self task branch: nil].
    self bookmarkCreateHolder value notEmptyOrNil
        ifTrue:[ self task bookmark: self bookmarkHolder value ]
        ifFalse:[ self task bookmark: nil ].
    [
        super doAccept.
    ] on: HGPushWouldCreateNewHeadError do:[:ex|
        self infoPanel 
                reset;
                beWarning;
                message: (self resources string:'Push to upstream would create a new head. Changes were not pushed.');
                addButtonOK;
                show.
    ]

    "Created: / 10-12-2012 / 01:46:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-06-2016 / 18:12:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEditUserConfig
    HGSourceCodeManagementSettingsAppl new doEditHGRC.
    self doCancel.

    "Created: / 07-12-2012 / 16:08:02 / jv"
    "Modified: / 18-02-2014 / 10:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntry
    | selection |

    selection := self fileSelectionHolder value.
    selection isNil ifTrue:[ ^ self ].        
    selection isCollection ifTrue:[
        selection do:[:each|
            self doShowDiffsForEntry: each entry against: each entry changeset  
        ]
    ] ifFalse:[
        self doShowDiffsForEntry: selection entry against: selection entry changeset  
    ].

    "Created: / 09-02-2012 / 14:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2013 / 02:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntry: wcentry against: rev
    |wc wcChangeSet repoentry repoChangeSet diffset |

    wc := self task temporaryWorkingCopy.
    repoentry := nil.
    rev id isNull ifFalse:[
        [ 
            repoentry := rev / wcentry pathNameRelativeSlashed 
        ] on: HGError do: [
            "/ No such file in given revision...
        ].
    ].

    wcentry suffix = SmalltalkLanguage instance sourceFileSuffix ifTrue:[
        wcentry exists ifTrue:[ 
            wcChangeSet := ChangeSet fromFile: wcentry.
        ] ifFalse:[ 
            wcChangeSet := ChangeSet new.
        ].
        wcChangeSet name: wcentry baseName, (resources string: ' (working copy - to be commited)').
        repoentry notNil ifTrue:[
            repoChangeSet := ChangeSet fromStream: repoentry contents asString readStream.
        ] ifFalse:[ 
            repoChangeSet := ChangeSet new.
        ].
        repoChangeSet name: wcentry baseName,  ' (revision ' , rev id printString , ')'.
        diffset := ChangeSetDiff versionA:wcChangeSet versionB:repoChangeSet.
        (Tools::ChangeSetDiffTool new)
            beSingleColumn;
            diffset:diffset;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: wcentry pathNameRelative with: rev id printString);
            showVersionMethodDiffs: false;
            open
    ] ifFalse:[
        | text1 text2 |

        wcentry exists ifTrue:[
            text1 := wcentry contents asString.
        ] ifFalse:[ 
            text1 := ''.
        ].
        repoentry notNil ifTrue:[
            text2 := repoentry contents asString.
        ] ifFalse:[ 
            text2 := ''.
        ].
        "/Argh...backward compatibility..."
        (Tools::TextDiff2Tool ? Tools::TextDiffTool) new
            labelA: 'Working copy';
            labelB: ('Revision %1' bindWith: rev id printString);
            textA: text1; textB: text2;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: wcentry pathNameRelative with: rev id printString);
            open
    ]

    "Created: / 09-02-2012 / 14:53:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 14:44:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowDiffsForEntryAgainstHEAD
    | selection |

    selection := self fileSelectionHolder value.
    selection isNil ifTrue:[ ^ self ].        
    selection isCollection ifTrue:[
        selection do:[:each|
            self doShowDiffsForEntry: each entry against: self workingCopy heads anElement 
        ]
    ] ifFalse:[
        self doShowDiffsForEntry: selection entry against: self workingCopy heads anElement  
    ].

    "Created: / 10-02-2012 / 10:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2013 / 02:06:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowMoreOptions
    self moreOptionsHolder value: true

    "Created: / 10-12-2012 / 11:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateLogicalRevisionTo: revision 
    self task doUpdateLogicalRevisionTo: revision

    "Created: / 09-02-2018 / 09:01:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'aspects'!

amendHolder
    <resource: #uiAspect>

    amendHolder isNil ifTrue:[
        amendHolder := false asValue.
        amendHolder addDependent:self.
    ].
    ^ amendHolder.

    "Modified: / 25-08-2015 / 11:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

amendLabel
    <resource: #uiAspect>

    amendLabel isNil ifTrue:[
        amendLabel := ValueHolder with: (resources string: 'Amend Previous Commit').
    ].
    ^ amendLabel.

    "Modified: / 25-08-2015 / 12:47:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkCreateHolder
    <resource: #uiAspect>

    bookmarkCreateHolder isNil ifTrue:[
        bookmarkCreateHolder := false asValue.
    ].
    ^ bookmarkCreateHolder.

    "Modified: / 27-06-2016 / 12:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    bookmarkHolder isNil ifTrue:[
        bookmarkHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       bookmarkHolder addDependent:self.
"/       bookmarkHolder onChangeSend:#bookmarkHolderChanged to:self.
    ].
    ^ bookmarkHolder.
!

bookmarkList
    <resource: #uiAspect>

    ^ self task repository bookmarks

    "Created: / 27-06-2016 / 12:16:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchCreateHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    branchCreateHolder isNil ifTrue:[
        branchCreateHolder := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       branchCreateHolder addDependent:self.
"/       branchCreateHolder onChangeSend:#branchCreateHolderChanged to:self.
    ].
    ^ branchCreateHolder.

    "Modified: / 10-12-2012 / 02:54:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    branchHolder isNil ifTrue:[
        branchHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       branchHolder addDependent:self.
"/       branchHolder onChangeSend:#branchHolderChanged to:self.
    ].
    ^ branchHolder.
!

canAmendHolder
    ^ self task isAmendable

    "Created: / 25-08-2015 / 11:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2015 / 18:16:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreOptionsHiddenHolder
    ^BlockValue forLogicalNot: self moreOptionsVisibleHolder

    "Created: / 10-12-2012 / 11:37:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreOptionsHolder
    "return/create the 'moreOptionsHolder' value holder (automatically generated)"

    moreOptionsHolder isNil ifTrue:[
        moreOptionsHolder := false asValue
    ].
    ^ moreOptionsHolder

    "Modified: / 10-12-2012 / 11:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreOptionsLabel

    ^(resources string: 'More Options') asText
        colorizeAllWith: Color blue;
        actionForAll:[ self doShowMoreOptions ];
        yourself

    "Created: / 10-12-2012 / 11:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreOptionsVisibleHolder
    ^self moreOptionsHolder

    "Created: / 10-12-2012 / 11:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remoteHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    remoteHolder isNil ifTrue:[
        | remote |

        remote := self task isPackageCommit ifTrue:[self task repository remoteDefault] ifFalse:[nil].
        remoteHolder := remote asValue.
    ].
    ^ remoteHolder.

    "Modified: / 22-02-2014 / 23:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remoteListHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    remoteListHolder isNil ifTrue:[
        | remoteList |

        remoteList := self task isPackageCommit ifTrue:[self task repository remotes] ifFalse:[nil].
        remoteListHolder := remoteList asValue
    ].
    ^ remoteListHolder.

    "Modified: / 22-02-2014 / 23:47:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remotePushHolder
    <resource: #uiAspect>
    "automatically generated by UIPainter ..."
    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"
    
    remotePushHolder isNil ifTrue:[
        remotePushHolder := UserPreferences current hgAutopush asValue.
        
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       pushHolder addDependent:self.
"/       pushHolder onChangeSend:#pushHolderChanged to:self.
    ].
    ^ remotePushHolder.

    "Modified: / 10-12-2012 / 01:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'change & update'!

update:aspect with:param from:sender
    sender == amendHolder ifTrue:[
        self updateMessage.
        self doCheckHead.
        ^ self.
    ].
    super update:aspect with:param from:sender

    "Modified: / 12-02-2018 / 19:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAmendLabel
    | rev cs |
    self task isAmendable ifTrue:[
        cs := self task temporaryWorkingCopy parent1 .
        self amendLabel value: (resources string: 'Amend %1' with: (cs id printStringWithoutNumber , ' ' , cs summary) asText allBold)
    ].

    "Created: / 25-08-2015 / 12:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2016 / 08:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateFileList
    | wcroot statuses entries wcrootPathNameRelative wcrootPathNameRelativeLen notMerge |

    "HACK..."

    wcroot := self task temporaryWorkingCopyRoot.
    wcrootPathNameRelative := wcroot pathNameRelative.
    wcrootPathNameRelativeLen := wcrootPathNameRelative size.

    notMerge := self task isMergeCommit not.

    statuses := self task temporaryWorkingCopy repository execute:
                    (HGCommand status
                        workingDirectory: wcroot pathName;
                        yourself).

    entries := OrderedCollection new: statuses size.
    statuses do:[:statusAndPath|
        (fileListShowOnlyModifiedHolder value not
            or:[statusAndPath first isCleanOrIgnoredOrNotTracked not]) ifTrue:[
            | nm status entry |

            (statusAndPath second startsWith: wcrootPathNameRelative) ifTrue:[
                status := statusAndPath first.
                nm := statusAndPath second.
                wcrootPathNameRelativeLen ~~ 0 ifTrue:[
                    nm := nm copyFrom:wcrootPathNameRelativeLen + 2.
                ].
                entry := SCMAbstractCommitDialog::FileEntry application: self entry: wcroot / nm name: nm.
                entry includeEditable: notMerge.
                entry icon: status icon.
                entries add: entry
            ].
        ].
    ].
    self fileListHolder value: entries

    "Created: / 08-02-2012 / 18:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2013 / 15:14:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMessage
    | rev prevMsg |
    rev := self task temporaryWorkingCopy parent1Id.
    prevMsg := (self task repository @ rev) message.
    self amendHolder value ifTrue:[
        (self message includesSubstring: prevMsg) ifFalse:[
            self message isEmpty ifTrue:[ 
                self message: prevMsg
            ] ifFalse:[ 
                self message: self message , Character cr , '---' ,  Character cr , prevMsg.
            ].
        ].
        self doUpdateButtonEnablements
    ].

    "Created: / 25-08-2015 / 11:58:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2016 / 09:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'help texts'!

flyByHelpTextForKey:key
    key == #amendLabelHelp ifTrue:[ 
        | cs |
        self task isAmendable ifTrue:[
            cs :=  self task temporaryWorkingCopy parent1 .
            ^ cs helpText
        ]
    ]. 
    ^ super flyByHelpTextForKey:key

    "Created: / 10-09-2015 / 18:49:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2016 / 09:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'hooks'!

postOpenWith: anUIBuilder
    self task isPackageLogicalRevisonObsolete ifTrue:[
        | successors |

        successors := self task changesetSuccessors.    
        self infoPanel 
                reset;
                beWarning;
                message:(resources string: 'The current revision is obsolete' ).
        successors size == 1 ifTrue:[ 
            self infoPanel 
                addButtonWithLabel: (resources string:'Reconcile') 
                            action: [ self doUpdateLogicalRevisionTo: successors anyOne id. self infoPanel hide. super postOpenWith: anUIBuilder]
        ].
        self infoPanel show.
        ^ self.        
    ].
    super postOpenWith: anUIBuilder

    "Created: / 09-02-2018 / 08:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'initialization'!

initialize
    super initialize.
    commitingNewHeadAcknowledged := false.

    "Created: / 12-02-2018 / 19:09:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitDialog methodsFor:'private'!

doCheckAuthor
    "Checks whether commit author is defined"

    | author |

    author := self task author.

    "/ Check for lazy users which only uncomment the line and
    "/ does not bother with filling in proper values. See
    "/ HGConfig userConfigFileTemplate
    (author isNil or:[author = 'FirstName LastName <Email>']) ifTrue:[
        self infoPanel 
            reset;
            beWarning;
            message: 'Commit author signature not configured';
            addButtonWithLabel: (self resources string:'Edit')
                action: [self doEditUserConfig];
            addButtonWithLabel: (self resources string:'Cancel')
                action: [self doCancel].
        self acceptEnabled:false. 
        ^self.
    ].
    self doCheckHead.

    "Created: / 07-12-2012 / 15:56:36 / jv"
    "Modified: / 18-02-2014 / 11:33:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCheckHead
    "Checks whether commit would create a new head"

    commitingNewHeadAcknowledged ifTrue:[ ^ self ].

    (self amendHolder value not and:[self task isCommitingNewHead]) ifTrue:[
        self infoPanel 
            reset;
            beInformation;
            message: (self resources string:'Comitting a new head.');
            addButtonWithLabel: (self resources string:'Proceed') action: [ commitingNewHeadAcknowledged := true. self infoPanel hide];
            "/addButtonWithLabel: (self resources string:'Cancel') action:[self doCancel];
            show.
    ] ifFalse:[ 
        self infoPanel hide.
    ].

    "Created: / 07-12-2012 / 15:52:18 / jv"
    "Modified: / 12-02-2018 / 19:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRunSanityChecks
    self task isPackageCommit ifFalse:[
        self updateFileList.
        self message: self task message.
    ].
    super doRunSanityChecks.

    "Created: / 01-04-2013 / 12:08:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 13:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateWorkingCopy
    super doUpdateWorkingCopy.
    self doCheckAuthor.

    "Created: / 27-11-2012 / 23:36:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 00:49:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-12-2012 / 15:53:43 / jv"
! !

!HGCommitDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

