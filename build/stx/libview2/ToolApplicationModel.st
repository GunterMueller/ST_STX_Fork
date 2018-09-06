"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#ToolApplicationModel
	instanceVariableNames:'timeBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

ToolApplicationModel class instanceVariableNames:'history fileHistory clipboard settings showingHelp instances'

"
 The following class instance variables are inherited by this class:

	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

Object subclass:#HistoryEntry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ToolApplicationModel
!

ToolApplicationModel::HistoryEntry subclass:#HistoryEntryForFile
	instanceVariableNames:'filename'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ToolApplicationModel
!

ToolApplicationModel::HistoryEntry subclass:#HistoryEntryForMethod
	instanceVariableNames:'methodClass methodSelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ToolApplicationModel
!

!ToolApplicationModel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    Framework class for tool applications (UIPainter, MenuEditor etc.).
    Provides hooks for modifiedChannels, history management,
    showing help texts, about menu, help menu etc.

    [author:]
        Thomas Zwick, eXept Software AG
"
! !

!ToolApplicationModel class methodsFor:'accessing'!

allToolInstances
    ^ instances ? #()

    "Created: / 4.2.1999 / 15:34:55 / cg"
!

authorLinesForAboutBox
    "extracts the author(s) from the documentation method."

    |firstClassWithDocumentation docMethod src s line lines|

    firstClassWithDocumentation := self class withAllSuperclasses detect:[:metacls| metacls includesSelector:#documentation].
    firstClassWithDocumentation notNil ifTrue:[
        (firstClassWithDocumentation inheritsFrom:ToolApplicationModel class) ifTrue:[
            docMethod := firstClassWithDocumentation compiledMethodAt:#documentation.
            docMethod notNil ifTrue:[
                src := docMethod source.
                src notNil ifTrue:[
                    s := src readStream.
                    s upToAllExcluding:'[author:]'.
                    s nextLine.   "/ skip to end
                    line := s nextLine.   "/ line after [author:]
                    lines := OrderedCollection new.
                    [line notEmptyOrNil] whileTrue:[
                        line := line withoutSeparators.
                        line size > 1 ifTrue:[
                            lines add:line withoutSeparators.
                            line := s nextLine.
                        ] ifFalse:[
                            line := nil
                        ]
                    ].
                    ^ lines.
                ]
            ]
        ]
    ].
    ( #('stx' 'exept') includes:self class package asPackageId module) ifTrue:[
        ^ #('eXept Software AG')
    ].

    ^ #('?')

    "Created: / 01-02-1998 / 15:41:43 / cg"
    "Modified: / 25-10-2006 / 17:29:35 / cg"
!

forgetInstance:anInstance
    instances notNil ifTrue:[
        instances remove:anInstance ifAbsent:[].
        instances := instances asNilIfEmpty.
    ].

    "Modified: / 4.2.1999 / 15:38:49 / cg"
!

label
    "returns the label for the tool instances of this class;
     extracted from the class name;
     can be redefined in subclasses"

    |label|
    label := ''.
    self name do:
    [:c|
        c isUppercase ifTrue: [label := label, $ ].
        label := label, c
    ].
    ^label trimBlanks

    "Modified: / 31.7.1998 / 18:04:18 / cg"
!

rememberInstance:anInstance
    instances isNil ifTrue:[
        instances := WeakIdentitySet new
    ].
    instances add:anInstance

    "Created: / 4.2.1999 / 15:33:43 / cg"
    "Modified: / 4.2.1999 / 15:34:14 / cg"
!

settings
    "returns the settings dictionary"

    settings isNil ifTrue: [settings := IdentityDictionary new].
    ^settings
!

showingHelp
    "returns true if active help is turned on for instances of this class"

    "/ cg: the default is now false - we use flyByHelp now, not the info-area help
    showingHelp isNil ifTrue: [showingHelp := false].
    ^showingHelp

    "
     self withAllSubclassesDo:[:cls | cls showingHelp:false]
     WorkspaceApplication showingHelp
    "

    "Created: / 31-07-1998 / 18:03:38 / cg"
    "Modified (comment): / 06-07-2011 / 18:01:13 / cg"
!

showingHelp: aBoolean
    "enable/disable active help for instances of this class"

    showingHelp := aBoolean

    "
     self withAllSubclassesDo:[:cls | cls showingHelp:false]
    "

    "Modified: / 31-07-1998 / 18:17:14 / cg"
    "Modified (comment): / 06-07-2011 / 17:54:13 / cg"
! !

!ToolApplicationModel class methodsFor:'clipboard'!

clipboard
    "returns the clipboard of this tool class"

    ^clipboard
!

clipboard: anEditObject
    "sets the clipboard for this tool class"

    clipboard := anEditObject
! !

!ToolApplicationModel class methodsFor:'help'!

openAboutSTX
    "opens an about box (on ST/X)"

    |box|

    AboutBox isNil ifTrue:[
        "/ this handles bad installations of ST/X,
        "/ where the AboutBox is missing.
        "/ (May vanish in the future)
        ^ self information:('Smalltalk/X rev.' , Smalltalk versionString)
    ].

    box := AboutBox new.
    box autoHideAfter:10 with:[].
    box showAtCenter
"/    box showAtPointer

    "Modified: / 14.8.1998 / 13:03:58 / cg"
    "Created: / 14.8.1998 / 13:17:43 / cg"
! !

!ToolApplicationModel class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

"/#commitCancel
"/'Cancels'
"/
"/#commitOK
"/'Commit'

#editCopy
'Copy selection'

#editCut
'Cut selection'

#editDelete
'Delete selection'

#editSearch
'Search'

#editMoveDown
'Move Down'

#editMoveIn
'Move Into Next'

#editMoveInAbove
'Move Into Previous'

#editMoveOut
'Move Out'

#editMoveUp
'Move Up'

#editPaste
'Paste'

#editUndo
'Undo'

#fileBrowseClass
'Browse class'

#fileDefineClass
'Define class'

#fileDefineClassAndSelector
'Define class & selector'

#fileExit
'Exit'

#helpShowHelp
'Toggle help'
)
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ToolApplicationModel
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#about
'Info functions'

#aboutSTX
'Info about the running ST/X'

#aboutThisAppliaction
'Info about that applications release and author'

#add
'Add functions'

#addTab
'Add another page (tab)'

#commitCancel
'Cancel changes'

#commitOK
'Commit changes'

#edit
'Edit functions'

#editCopy
'Copy the selected item(s) to the clipboard'

#editCut
'Cut the selected item(s) to the clipboard'

#editDelete
'Delete the selected item(s)'

#editMoveDown
'Move the selected item one step down (in the order list)'

#editMoveIn
'Move the selected item into the next item (as child item)'

#editMoveInAbove
'Move the selected item into the previous item (as child item)'

#editMoveOut
'Move the selected item out of its parent item'

#editMoveUp
'Move the selected item one step up (in the order list)'

#editPaste
'Paste from the clipboard'

#editRedo
'Redo the last undone action'

#editUndo
'Undo the last action'

#file
'File functions'

#fileBrowseClass
'Open a System Browser on the current class'

#fileDefineClass
'Open a dialog to define the current class'

#fileDefineClassAndSelector
'Open a dialog to define the current class and selector'

#fileExit
'Exit this application'

#generate
'Code generation'

#help
'Help functions'

#helpHelpTool
'Show the Help Tools documentation'

#helpShowHelp
'Toggle display of help texts'

#helpTutorial
'Show this applications documentation'

#history
'History functions'

#historyEmptyMenu
'Clear the history'

#historyMenuItem
'Switch to that item'

#settings
'Settings functions'

#test
'Test functions'

)
! !

!ToolApplicationModel class methodsFor:'history'!

getFileHistory
    "returns the file-history for this tool class"

    fileHistory isNil ifTrue: [fileHistory := OrderedCollection new].
    ^ fileHistory
!

getHistory
    "returns the history for this tool class"

    history isNil ifTrue: [history := OrderedCollection new].
    ^history

!

historyMaxSize
    "returns the maximum size for the history of this tool class"

    ^10

! !

!ToolApplicationModel class methodsFor:'image specs'!

desktopIcon
    "returns the icon used for the desktop"

    <resource: #programImage>

    ^Icon
        constantNamed:#'ToolApplicationModel desktopIcon'
        ifAbsentPut:
        [
            |desktopIcon|
            desktopIcon := Icon stxIcon.
            desktopIcon magnifiedBy:Screen current preferredIconSize/desktopIcon extent
        ]

    "Modified: / 24.8.1998 / 21:34:38 / cg"
!

menuIcon
    "returns the icon used for the menu bar"

    <resource: #programImage>

    ^Icon
        constantNamed:#'ToolApplicationModel menuIcon'
        ifAbsentPut:
        [
            |menuIcon|
            menuIcon := Icon stxIcon.
            menuIcon magnifiedBy: (MenuPanel defaultFont heightOn:Screen current)/menuIcon height
        ]

    "Modified: / 24.8.1998 / 21:34:33 / cg"
! !

!ToolApplicationModel class methodsFor:'interface specs'!

windowSpecForCommit
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToolApplicationModel andSelector:#windowSpecForCommit
     ToolApplicationModel new openInterface:#windowSpecForCommit
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecForCommit
        #window: 
       #(#WindowSpec
          #label: 'Commit Buttons'
          #name: 'Commit Buttons'
          #min: #(#Point 100 22)
          #max: #(#Point 1152 900)
          #bounds: #(#Rectangle 18 51 318 111)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #horizontalLayout: #fitSpace
              #verticalLayout: #centerMax
              #horizontalSpace: 3
              #verticalSpace: 3
              #reverseOrderIfOKAtLeft: true
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ActionButtonSpec
                    #label: 'Cancel'
                    #name: 'cancelButton'
                    #activeHelpKey: #commitCancel
                    #translateLabel: true
                    "/ #resizeForLabel: true
                    #tabable: true
                    #model: #cancel
                    #enableChannel: #enablingCommitButtonsHolder
                    #useDefaultExtent: true
                  )
                 #(#ActionButtonSpec
                    #label: 'OK'
                    #name: 'okButton'
                    #activeHelpKey: #commitOK
                    #translateLabel: true
                    "/ #resizeForLabel: true
                    #tabable: true
                    #model: #accept
                    #enableChannel: #enablingCommitButtonsHolder
                    #useDefaultExtent: true
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecForCommitWithoutChannels
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToolApplicationModel andSelector:#windowSpecForCommitWithoutChannels
     ToolApplicationModel new openInterface:#windowSpecForCommitWithoutChannels
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpecForCommitWithoutChannels
        window: 
       (WindowSpec
          label: 'Commit Buttons Without Channels'
          name: 'Commit Buttons Without Channels'
          min: (Point 100 22)
          max: (Point 1152 900)
          bounds: (Rectangle 0 0 300 46)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: centerMax
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    activeHelpKey: commitCancel
                    translateLabel: true
                    tabable: true
                    model: cancel
                    useDefaultExtent: true
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    activeHelpKey: commitOK
                    translateLabel: true
                    tabable: true
                    model: accept
                    isDefault: true
                    useDefaultExtent: true
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecForInfoBar
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToolApplicationModel andSelector:#windowSpecForInfoBar
     ToolApplicationModel new openInterface:#windowSpecForInfoBar
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecForInfoBar
        #window: 
       #(#WindowSpec
          #label: 'Info Bar'
          #name: 'Info Bar'
          #min: #(#Point 400 320)
          #max: #(#Point 1152 900)
          #bounds: #(#Rectangle 13 23 513 369)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ViewSpec
              #name: 'infoView'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #name: 'InfoLabel'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                    #level: -1
                    #labelChannel: #infoLabelHolder
                    #resizeForLabel: false
                    #adjust: #left
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecForInfoBarWithClock
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToolApplicationModel andSelector:#windowSpecForInfoBarWithClock
     ToolApplicationModel new openInterface:#windowSpecForInfoBarWithClock
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecForInfoBarWithClock
        #window: 
       #(#WindowSpec
          #label: 'Info Bar'
          #name: 'Info Bar'
          #min: #(#Point 400 320)
          #max: #(#Point 1152 900)
          #bounds: #(#Rectangle 13 23 513 343)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableHorizontalPanelSpec
              #name: 'infoView'
              #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1)
              #barWidth: 2
              #showHandle: false
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #name: 'InfoLabel'
                    #level: -1
                    #labelChannel: #infoLabelHolder
                    #resizeForLabel: false
                    #adjust: #left
                  )
                 #(#LabelSpec
                    #name: 'timeLabel'
                    #level: -1
                    #labelChannel: #timeLabelHolder
                    #resizeForLabel: false
                    #adjust: #rightLeft
                  )
                 )
               
              )
              #handles: #(#Any 0.854 1.0)
            )
           )
         
        )
      )
! !

!ToolApplicationModel class methodsFor:'menu specs'!

menuAbout
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ToolApplicationModel andSelector:#menuAbout
     (Menu new fromLiteralArrayEncoding:(ToolApplicationModel menuAbout)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'About Smalltalk/X...'
                #translateLabel: true
                #value: #openAbout
                #activeHelpKey: #aboutSTX
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'About this Application...'
                #translateLabel: true
                #value: #openAboutThisApplication
                #activeHelpKey: #aboutThisAppliaction
            )
          ) nil
          nil
      )

    "Modified: / 19.5.1998 / 21:44:09 / cg"
!

menuHelp
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ToolApplicationModel andSelector:#menuHelp
     (Menu new fromLiteralArrayEncoding:(ToolApplicationModel menuHelp)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Documentation'
                #translateLabel: true
                #value: #openDocumentation
                #activeHelpKey: #helpTutorial
                #enabled: #havingDocumentationHolder
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Show Help Texts'
                #translateLabel: true
                #activeHelpKey: #helpShowHelp
                #indication: #showingHelp:
            )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application...'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                          #activeHelpKey: #aboutThisAppliaction
                      )
          ) nil
          nil
      )

    "Modified: / 31.7.1998 / 18:19:42 / cg"
!

xxxmenuFont
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ToolApplicationModel andSelector:#menuFont
     (Menu new fromLiteralArrayEncoding:(ToolApplicationModel menuFont)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Label...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Label Font'
            )
             #(#MenuItem
                #label: 'Button...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Button Font'
            )
             #(#MenuItem
                #label: 'Edit...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Edit Font'
            )
             #(#MenuItem
                #label: 'List...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'List Font'
            )
             #(#MenuItem
                #label: 'Tree List...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Tree List Font'
            )
             #(#MenuItem
                #label: 'Note Book...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Note Book Font'
            )
             #(#MenuItem
                #label: 'Framed Box...'
                #translateLabel: true
                #value: #chooseFont:
                #argument: 'Framed Box Font'
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Reset'
                #translateLabel: true
                #value: #resetFonts
            )
          ) nil
          nil
      )

    "Modified: / 31.7.1998 / 18:55:34 / cg"
! !

!ToolApplicationModel class methodsFor:'queries'!

isAbstract
    ^ self == ToolApplicationModel 
! !

!ToolApplicationModel class methodsFor:'startup & release'!

preSnapshot
    "removes the clipboard before snap shoting"

    clipboard := nil
!

uninitialize
    "resets the class instance variables"

    settings := instances := showingHelp := history := fileHistory := clipboard := nil

    "
     self withAllSubclasses do:[:c | c uninitialize]
    "

    "Modified: / 4.2.1999 / 15:37:43 / cg"
! !

!ToolApplicationModel methodsFor:'aspects'!

acceptChannel
    "returns a valueHolder which can be set to true to force all inputFields
     to accept their value."

    |holder|

    (holder := builder bindingAt:#acceptChannel) isNil ifTrue:[
        builder aspectAt:#acceptChannel put:(holder :=  ValueHolder with:false).
    ].
    ^ holder

    "Modified: / 21.5.1998 / 03:39:49 / cg"
!

canCopyHolder
    "returns whether can copy as value holder"

    ^ self builder booleanValueAspectFor:#valueOfCanCopy
!

canCutHolder
    "returns whether can cut as value holder"

    ^ builder booleanValueAspectFor:#valueOfCanCut
!

canPasteHolder
    "returns whether can paste as value holder"

    ^ builder booleanValueAspectFor:#valueOfCanPaste
!

canUndoHolder
    "returns whether can undo as value holder"

    ^ builder booleanValueAspectFor:#valueOfCanUndo
!

enablingCommitButtonsHolder
    "returns the enabling of the commit of this tool as value holder"

    ^ builder booleanValueAspectFor:#valueOfEnablingCommitButtons
!

havingDocumentationHolder
    "returns the enabling of having documentation for this tool as value holder"

    ^ (builder booleanValueAspectFor:#valueOfHavingDocumentation) value: (self class includesSelector: #openDocumentation)
!

infoLabelHolder
    "returns the info label as value holder"

    ^ builder nilValueAspectFor:#valueOfInfoLabel
!

infoLabelHolder:aValueHolder
    builder aspectAt:#useAlienInfoLabelHolder put:true.
    builder aspectAt:#valueOfInfoLabel put:aValueHolder.
!

modifiedChannel
    "returns a valueHolder which is set to true, whenever any of
     my editfields is modified - this is hooked to
     the enablingCommitButtonsHolder channel"

    |holder|

    (holder := builder bindingAt:#modifiedChannel) isNil ifTrue:[
        builder aspectAt:#modifiedChannel put:(holder :=  ValueHolder with:false).
        holder 
            onChangeEvaluate:[
                holder value ifTrue:[
                    self enablingCommitButtonsHolder value:true.
                ]
               ]
    ].
    ^ holder

    "Modified: / 21.5.1998 / 03:39:49 / cg"
!

timeLabelHolder
    "returns the time label as value holder"

    ^ builder nilValueAspectFor:#valueOfTimeLabel
!

valueOfCanCopy
    <resource: #obsolete>
    "returns whether can copy as value holder"

    self obsoleteMethodWarning:'stupid name - use #canCopyHolder'.
    ^ self canCopyHolder
!

valueOfCanCut
    <resource: #obsolete>
    "returns whether can paste as value holder"

    self obsoleteMethodWarning:'stupid name - use #canCutHolder'.
    ^ self canCutHolder

    "Modified: / 21.5.1998 / 03:39:13 / cg"
!

valueOfCanPaste
    <resource: #obsolete>
    "returns whether can paste as value holder"

    self obsoleteMethodWarning:'stupid name - use #canPasteHolder'.
    ^ self canPasteHolder
!

valueOfCanUndo
    <resource: #obsolete>
    "returns whether can undo as value holder"

    self obsoleteMethodWarning:'stupid name - use #canUndoHolder'.
    ^ self canUndoHolder

    "Modified: / 21.5.1998 / 03:39:31 / cg"
!

valueOfEnablingCommitButtons
    <resource: #obsolete>
    "returns the enabling of the commit of this tool as value holder"

    self obsoleteMethodWarning:'stupid name - use #enablingCommitButtonsHolder'.
    ^ self enablingCommitButtonsHolder

    "Modified: / 21.5.1998 / 03:39:49 / cg"
!

valueOfHavingDocumentation
    <resource: #obsolete>
    "returns the enabling of having documentation for this tool as value holder"

    self obsoleteMethodWarning:'stupid name - use havingDocumentationHolder'.
    ^ self havingDocumentationHolder
!

valueOfInfoLabel
    <resource: #obsolete>
    "returns the info label as value holder"

    self obsoleteMethodWarning:'stupid name - use infoLabelHolder'.
    ^ self infoLabelHolder

    "Modified: / 21.5.1998 / 03:40:34 / cg"
!

valueOfTimeLabel
    <resource: #obsolete>
    "returns the time label as value holder"

    self obsoleteMethodWarning:'stupid name - use timeLabelHolder'.
    ^ self timeLabelHolder

    "Modified: / 21.5.1998 / 03:40:42 / cg"
! !

!ToolApplicationModel methodsFor:'clipboard'!

clipboard
    "returns the clipboard"

    ^self class clipboard
!

clipboard:anEditObject
    "sets the clipboard and the value holder for can pasting"

    self class clipboard: anEditObject.

    self canPasteHolder value: anEditObject notNil
! !

!ToolApplicationModel methodsFor:'clock handling'!

startClock
    "/ start the time-block
    self startClockOnTimedBlock:[self updateTime]. 
!

startClockOnTimedBlock: aBlock
    "sets and starts the (optional) time block"

    timeBlock := aBlock.
    aBlock value.

    "Modified: / 31.7.1998 / 18:46:28 / cg"
!

stopClock
    "/ stop the time-block

    timeBlock notNil ifTrue:[
        Processor removeTimedBlock:timeBlock.
        timeBlock := nil.
    ].
    self timeLabelHolder value:''
!

updateTime
    "update my time-field"

    |now hours minutes suffix|

    now := Time now.

    hours := now hours.
    minutes := now minutes printString.
    suffix := ' '.

    (resources string:'TIME_FORMAT' default:12) == 12 ifTrue:[
        suffix := ' am '.  
        hours > 12 ifTrue: [hours := hours - 12. suffix := ' pm '].
    ].

    minutes size = 1 ifTrue: [minutes := '0', minutes].

    self timeLabelHolder value:(hours printString, ':', minutes, suffix).

    timeBlock notNil ifTrue:[
        Processor removeTimedBlock:timeBlock.
        Processor addTimedBlock:timeBlock afterSeconds:5
    ]
! !

!ToolApplicationModel methodsFor:'defaults'!

aboutImage
    "the image to be displayed in my about-box;
     If nil is returned, thhe ST/X default image is used."

    ^ self class defaultIcon

    "Created: / 25.7.1998 / 20:33:50 / cg"
! !

!ToolApplicationModel methodsFor:'help'!

aboutThisApplicationText
    "text for an about box for this application.
     Extracts some common info (i.e. class revision, author etc.) from
     the classes documentation."

    |rev myClass clsRev msg|

    rev := ''.
    myClass := (self class topOwningClass) ? self class.

    (clsRev := myClass revision) notNil ifTrue: [
        rev := '  (rev: ', clsRev printString, ')'
    ].

    msg := '\The application\\' withCRs
        , myClass name allBold, rev
        , '\\has been designed and implemented by: \' withCRs
        , ((self class authorLinesForAboutBox collect:[:l | '    ' , l]) asStringWith:$\) withCRs
        , '\\' withCRs.
    msg := msg withTabsExpanded.
    ^msg

    "Created: / 13-11-2001 / 12:34:19 / cg"
    "Modified: / 27-10-2006 / 16:13:35 / cg"
!

defaultInfoLabel
    "returns the default info label; here an empty string"

    ^ ''

    "Modified: / 31.7.1998 / 18:44:55 / cg"
!

openAbout
    "opens an about box (on ST/X)"

    self class openAboutSTX

    "Modified: / 14.8.1998 / 13:17:57 / cg"
!

openHTMLDocument: aHTMLFilename
    "opens a HTML browser on aHTMLFilename"

    HTMLDocumentView openFullOnDocumentationFile: aHTMLFilename
!

showHelp:aHelpText for:view
    "displays aHelpText in the info label.
     Only text up to '.' is shown"

"/    masterApplication notNil ifTrue:[
"/        ^ masterApplication showHelp:aHelpText for:view
"/    ].
"/
    |lines|
    
    aHelpText isNil ifTrue:[
        self updateInfoLabel
    ] ifFalse: [
        |text|
        
        lines := aHelpText asString asStringCollection.
        self infoLabelHolder value:lines first 
    ].
!

showingHelp
    "returns true, if automatic display of help is enabled for this
     application; false otherwise"

    |currentActiveHelp|

    currentActiveHelp := ActiveHelp currentHelpListener.

    ^ self class showingHelp 
      and: [currentActiveHelp notNil 
      and: [ currentActiveHelp interestedIn: self window]]

"/    ^ self class showingHelp 
"/      and: [currentActiveHelp notNil and: [masterApplication notNil 
"/                ifFalse: [currentActiveHelp interestedIn: self window]
"/                ifTrue:  [currentActiveHelp interestedIn: masterApplication window]]]

    "Created: / 31-07-1998 / 17:57:03 / cg"
    "Modified: / 22-08-1998 / 00:06:38 / cg"
    "Modified (format): / 06-07-2011 / 17:47:51 / cg"
!

showingHelp: aValue
    "toggles showing help for this application"

    aValue "(self class showingHelp: aValue)"
        ifTrue:  [ActiveHelp startFor:self]
        ifFalse: [ActiveHelp stopFor:self. self updateInfoLabel]

    "Created: / 31-07-1998 / 18:20:44 / cg"
    "Modified: / 06-07-2011 / 18:02:48 / cg"
!

updateInfoLabel
    "updates the info label at the bottom of this application"

    self infoLabelHolder value: self defaultInfoLabel

    "Modified: / 31.7.1998 / 18:44:46 / cg"
!

xxopenAboutThisApplication
    "opens an about box for this application.
     Extracts some common info (i.e. class revision, author etc. from
     the classes documentation."

    |rev box myClass clsRev image msg|

    rev := ''.
    myClass := self class.

    (clsRev := myClass revision) notNil ifTrue: [rev := '  (rev: ', clsRev printString, ')'].

    msg := '\The application\\' withCRs
        , myClass name allBold, rev
        , '\\has been designed and implemented by: \' withCRs
        , ((self class authorLinesForAboutBox collect:[:l | '- ' , l]) asStringWith:$\) withCRs
        , '\\' withCRs.
    msg := msg withTabsExpanded.

    AboutBox isNil ifTrue:[
        "/ this handles bad installations of ST/X,
        "/ where the AboutBox is missing.
        "/ (May vanish in the future)
        ^ self information:msg
    ].

    box := AboutBox title:msg.

    image := self aboutImage.
    image notNil ifTrue:[
        box image:image
    ].
    box   label:(resources string:self aboutThisApplicationLabel).
    box   autoHideAfter:10 with:[].
    box   showAtPointer.

    "Modified: / 13.11.2001 / 12:31:28 / cg"
    "Created: / 13.11.2001 / 12:34:27 / cg"
! !

!ToolApplicationModel methodsFor:'history'!

add:aHistoryEntry toHistory:aHistory
    "adds aHistoryEntry (format: loadMessage -> evalString) at the top of aHistory,
     and checks for maximum size of the history"

    aHistory remove:aHistoryEntry ifAbsent:nil.
    aHistory addFirst: aHistoryEntry.
    [aHistory size > self class historyMaxSize] whileTrue: [aHistory removeLast]
!

addHistoryEntryForClass:classToAdd selector:selectorToAdd
    "adds aHistoryEntry (format: loadMessage -> evalString) at the top of the history,
     and checks for maximum size of the history"

    |entry|

    self assert:(classToAdd isBehavior).
    entry := HistoryEntryForMethod class:classToAdd selector:selectorToAdd.
    self addToHistory:entry
!

addHistoryEntryForFile:fileName
    |entry|

    entry := HistoryEntryForFile filename:fileName.
    self addToHistory:entry
!

addToFileHistory: aHistoryEntry
    "adds aHistoryEntry (format: loadMessage -> evalString) at the top of the file-history,
     and checks for maximum size of the history"

    self add:aHistoryEntry toHistory:self fileHistory
!

addToHistory: aHistoryEntry
    "adds aHistoryEntry (format: loadMessage -> evalString) at the top of the history,
     and checks for maximum size of the history"

    self add:aHistoryEntry toHistory:self history
!

emptyFileHistory
    "removes all history entries"

    ^ self fileHistory removeAll
!

emptyHistory
    "removes all history entries"

    ^self history removeAll
!

fileHistory
    "returns the file-history from tool class"

    ^ self class getFileHistory
!

history
    "returns the history from tool class"

    ^ self class getHistory
!

menuHistory
    "returns a dynamic history submenu"

    <resource: #programMenu >

    |menu anyItem clearItem|

    menu := Menu new receiver: self.
    anyItem := false.

    ((self history 
        collect: [:histEntry| histEntry class] as:Set) 
            asSortedCollection:[:a :b | a name < b name]) 
                do:
                    [:historyEntryType|    
                        menu addItemGroup:
                                (self history 
                                    select: [:histEntry| 
                                        histEntry class = historyEntryType] 
                                    thenCollect: [:histEntry|
                                        anyItem := true.
                                        MenuItem new 
                                            label: histEntry printStringInMenu 
                                            itemValue: #loadFromHistoryEntry: argument: histEntry; 
                                            activeHelpKey: #historyMenuItem]).
                    ]. 

    clearItem := MenuItem label: 'Clear History' itemValue: #emptyHistory enabled:anyItem. 
    clearItem activeHelpKey: #historyEmptyMenu.
    menu addItem: clearItem.

    menu findGuiResourcesIn:self.
    ^menu

    "Modified: / 09-09-2012 / 13:10:38 / cg"
!

remove:aHistoryEntry fromHistory: aHistory
    "removes aHistoryEntry from the history"

    aHistory remove: (aHistory detect: [:histEntry| histEntry key = aHistoryEntry key] ifNone: nil) ifAbsent: nil.
    [aHistory size > self class historyMaxSize] whileTrue: [aHistory removeLast]
!

removeFromHistory:aHistoryEntry
    "removes aHistoryEntry from the history"

    self remove:aHistoryEntry fromHistory: self history.
! !

!ToolApplicationModel methodsFor:'initialization'!

initialize
    super initialize.
    self createBuilder

    "Created: / 20.6.1998 / 14:51:29 / cg"
! !

!ToolApplicationModel methodsFor:'misc'!

clearModifiedFlag
    "clear the modifiedChannel.
     That one is hooked to components in the right noteBook,
     and will be set, when any value is modified.
     (to enable OK and cancel buttons)"

    self modifiedChannel value:false
! !

!ToolApplicationModel methodsFor:'queries'!

allToolInstances
    "returns all instances of this tool class"

    ^ self class allToolInstances

    "Modified: / 4.2.1999 / 15:34:58 / cg"
!

preferredExtent
    "preferred extent of my window; top/main menu and top toolbar (named by 'menuToolbarView')
     will be considered"

    |window menu menuToolbarView preferredExtentOfWindow maxExtent|

    window          := self builder window. 
    menu            := window subViews first.
    menuToolbarView := builder componentAt: #menuToolbarView.

    preferredExtentOfWindow := window extent max:window minExtent.
    menu class == MenuPanel ifTrue:[
        preferredExtentOfWindow := preferredExtentOfWindow max:menu preferredExtent
    ].
    menuToolbarView notNil ifTrue:[
        preferredExtentOfWindow := preferredExtentOfWindow max:menuToolbarView preferredExtent
    ].

    maxExtent := window maxExtent.
    maxExtent notNil ifTrue:[
        preferredExtentOfWindow := preferredExtentOfWindow min:maxExtent.
    ].

    ^ preferredExtentOfWindow.
! !

!ToolApplicationModel methodsFor:'startup & release'!

closeDownViews
    "uninitializes and closes this tool"

    self uninitialize.
    super closeDownViews
!

loadFromHistoryEntry:aHistoryEntry
    aHistoryEntry forceLoadIn:self
!

postOpenWith:aBuilder
    "starts the active help for this tool (if turned on in the settings)
     and updates the info label and the font's (from the settings)"

    super postOpenWith:aBuilder.

    self updateInfoLabel.
"/    self updateFonts.
    self showingHelp:true.

    "Modified: / 31.7.1998 / 18:17:34 / cg"
!

restarted
    "sent by my windowGroup, when restarted from an image.
     restart timed block if defined.
    "
    timeBlock notNil ifTrue:[
        Processor removeTimedBlock:timeBlock.
        self startClockOnTimedBlock:timeBlock.
    ].
    super restarted.
!

uninitialize
    "stops active help for this tool and (if defined) removes the time block"

    self showingHelp ifTrue: [ActiveHelp stopFor: self].
    timeBlock notNil ifTrue: [Processor removeTimedBlock:timeBlock. timeBlock := nil].

    "Modified: / 31.7.1998 / 18:46:21 / cg"
! !

!ToolApplicationModel::HistoryEntry class methodsFor:'documentation'!

documentation
"
    common support code for navigation history entries,
    for fileBrowser (visited file history) and systemBrowser (visited method history). 
"
! !

!ToolApplicationModel::HistoryEntry methodsFor:'comparing'!

sameAsHistoryEntryForFile:aHistoryEntryForFile
    ^ false
!

sameAsHistoryEntryForMethod:aHistoryEntryForMethod
    ^ false
! !

!ToolApplicationModel::HistoryEntryForFile class methodsFor:'instance creation'!

filename:arg
    ^ self new filename:arg
! !

!ToolApplicationModel::HistoryEntryForFile methodsFor:'accessing'!

filename
    ^ filename
!

filename:something
    filename := something.
! !

!ToolApplicationModel::HistoryEntryForFile methodsFor:'comparing'!

= aHistoryEntry
    ^ aHistoryEntry sameAsHistoryEntryForFile:self
!

sameAsHistoryEntryForFile:aHistoryEntryForFile
    ^ aHistoryEntryForFile filename = filename
! !

!ToolApplicationModel::HistoryEntryForFile methodsFor:'loading'!

forceLoadIn:anEditor
    anEditor loadFromFile:filename
! !

!ToolApplicationModel::HistoryEntryForFile methodsFor:'printing'!

printStringInMenu
    ^ filename
! !

!ToolApplicationModel::HistoryEntryForMethod class methodsFor:'instance creation'!

class:classToAdd selector:selectorToAdd
    ^ self new class:classToAdd selector:selectorToAdd
! !

!ToolApplicationModel::HistoryEntryForMethod methodsFor:'accessing'!

class:aClass selector:aSelector
    methodClass := aClass.
    methodSelector := aSelector
!

methodClass
    ^ methodClass
!

methodSelector
    ^ methodSelector
! !

!ToolApplicationModel::HistoryEntryForMethod methodsFor:'comparing'!

= aHistoryEntry
    ^ aHistoryEntry sameAsHistoryEntryForMethod:self
!

sameAsHistoryEntryForMethod:aHistoryEntryForMethod
    ^ aHistoryEntryForMethod methodClass = methodClass
    and:[ aHistoryEntryForMethod methodSelector = methodSelector ]
! !

!ToolApplicationModel::HistoryEntryForMethod methodsFor:'loading'!

forceLoadIn:anEditor
    anEditor loadFromClass:methodClass andSelector:methodSelector
! !

!ToolApplicationModel::HistoryEntryForMethod methodsFor:'printing'!

printStringInMenu
    ^ methodClass name , ' » ' , (methodSelector?'?')

    "Modified: / 11-07-2006 / 13:53:40 / fm"
! !

!ToolApplicationModel class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

