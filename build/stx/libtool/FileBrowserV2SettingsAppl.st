"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractSettingsApplication subclass:#FileBrowserV2SettingsAppl
	instanceVariableNames:'sortDirectoriesBeforeFiles showDirectoryTree sortCaseless
		showHiddenFiles openMultipleApplicationsForType
		toolBarVisibleHolder viewDirectoryDescription
		openAlwaysInTextEditor alwaysUseSmalltalkTools
		viewFilesInDirectoryTree viewDescription viewPreview viewTime
		viewSize viewSizeInBytes viewType viewDetails viewPermissions
		viewGroup viewDirsInContentsBrowser viewOwner
		filenameEntryFieldVisibleHolder viewSizeInKiloBytes
		useCodeView2InTools showDirectoriesOnTop'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV2SettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FileBrowserV2SettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:(self helpPairs)
!

helpPairs
    <resource: #help>

    ^ #(

#autoOpenDirectoryDescription
'When changing directories, automatically show the contents of a README or .dirInfo file if present.'

#openMultipleApplications
'Show new selected files in a new tab, instead of changing the contents of an existing tab'

#textEditorForAllTypes
'Show all files as text, i.e. do not open specialized viewers as per mime type'

#alwaysUseSmalltalkTools
'Always use Smalltalk tools to show/edit documents.\I.e. do not try to start a tool from the operating system on double click'
)
! !

!FileBrowserV2SettingsAppl class methodsFor:'icon'!

defaultIcon
    <resource: #programImage>

    ^ FileBrowserV2 applicationIcon
! !

!FileBrowserV2SettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2SettingsAppl andSelector:#windowSpec
     FileBrowserV2SettingsAppl new openInterface:#windowSpec
     FileBrowserV2SettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Settings'
         name: 'Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 625 766)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Show'
                   name: 'ShowBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Hidden Files'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 0 0.0 7 0 0 1.0 37 0)
                         model: showHiddenFiles
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Directory Tree'
                         name: 'CheckBox2'
                         layout: (LayoutFrame 0 0.0 37 0 0 1.0 67 0)
                         model: showDirectoryTree
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Regular Files in TreeView (Left)'
                         name: 'CheckBox3'
                         layout: (LayoutFrame 20 0 67 0 0 1.0 97 0)
                         model: viewFilesInDirectoryTree
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Directories in ContentsView (Right)'
                         name: 'CheckBox4'
                         layout: (LayoutFrame 0 0.0 97 0 0 1.0 127 0)
                         model: viewDirsInContentsBrowser
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Directories on Top'
                         name: 'CheckBox26'
                         layout: (LayoutFrame 20 0.0 127 0 0 1.0 157 0)
                         enableChannel: viewDirsInContentsBrowser
                         model: showDirectoriesOnTop
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Toolbar'
                         name: 'CheckBox11'
                         layout: (LayoutFrame 0 0.0 155 0 0 1.0 185 0)
                         model: toolBarVisibleHolder
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Path Entry && Filter'
                         name: 'CheckBox12'
                         layout: (LayoutFrame 0 0.0 185 0 0 1.0 215 0)
                         model: filenameEntryFieldVisibleHolder
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 625 250)
                 )
                (FramedBoxSpec
                   label: 'Sort'
                   name: 'SortBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Ignore Case'
                         name: 'CheckBox6'
                         layout: (LayoutFrame 0 0.0 7 0 0 1.0 37 0)
                         model: sortCaseless
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Directories before Files'
                         name: 'CheckBox7'
                         layout: (LayoutFrame 0 0.0 37 0 0 1.0 67 0)
                         model: sortDirectoriesBeforeFiles
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 625 101)
                 )
                (FramedBoxSpec
                   label: 'Columns in Filelist'
                   name: 'ColumnsBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Details'
                         name: 'CheckBox22'
                         layout: (LayoutFrame 0 0.0 7 0 0 1.0 37 0)
                         model: viewDetails
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Suffix'
                         name: 'CheckBox13'
                         layout: (LayoutFrame 20 0.0 37 0 170 0 67 0)
                         enableChannel: viewDetails
                         model: viewType
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Permissions'
                         name: 'CheckBox21'
                         layout: (LayoutFrame 170 0.0 37 0 -5 1 67 0)
                         enableChannel: viewDetails
                         model: viewPermissions
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Owner'
                         name: 'CheckBox14'
                         layout: (LayoutFrame 20 0.0 67 0 170 0 97 0)
                         enableChannel: viewDetails
                         model: viewOwner
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Group'
                         name: 'CheckBox18'
                         layout: (LayoutFrame 170 0.0 67 0 -5 1 97 0)
                         enableChannel: viewDetails
                         model: viewGroup
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Size'
                         name: 'CheckBox15'
                         layout: (LayoutFrame 20 0.0 97 0 170 0 127 0)
                         enableChannel: viewDetails
                         model: viewSize
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Date && Time'
                         name: 'CheckBox19'
                         layout: (LayoutFrame 170 0.0 97 0 -5 1 127 0)
                         enableChannel: viewDetails
                         model: viewTime
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Size (Byte)'
                         name: 'CheckBox16'
                         layout: (LayoutFrame 20 0.0 127 0 170 0 157 0)
                         enableChannel: viewDetails
                         model: viewSizeInBytes
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Size (KByte)'
                         name: 'CheckBox20'
                         layout: (LayoutFrame 170 0.0 127 0 -5 1 157 0)
                         enableChannel: viewDetails
                         model: viewSizeInKiloBytes
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'File Info'
                         name: 'CheckBox23'
                         layout: (LayoutFrame 20 0.0 157 0 170 0 187 0)
                         enableChannel: viewDetails
                         model: viewDescription
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Preview'
                         name: 'CheckBox24'
                         layout: (LayoutFrame 170 0.0 157 0 -5 1 187 0)
                         enableChannel: viewDetails
                         model: viewPreview
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 625 224)
                 )
                (FramedBoxSpec
                   label: 'Application Notebook'
                   name: 'ApplicationBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel3'
                         layout: (LayoutFrame 0 0 5 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Text Editor for all Types'
                               name: 'CheckBox25'
                               activeHelpKey: textEditorForAllTypes
                               model: openAlwaysInTextEditor
                               translateLabel: true
                               extent: (Point 435 30)
                             )
                            (CheckBoxSpec
                               label: 'Always use Smalltalk Tools'
                               name: 'CheckBox27'
                               activeHelpKey: alwaysUseSmalltalkTools
                               model: alwaysUseSmalltalkTools
                               translateLabel: true
                               extent: (Point 435 30)
                             )
                            (CheckBoxSpec
                               label: 'Open Multiple Applications'
                               name: 'CheckBox9'
                               activeHelpKey: openMultipleApplications
                               model: openMultipleApplicationsForType
                               translateLabel: true
                               extent: (Point 435 30)
                             )
                            (CheckBoxSpec
                               label: 'Auto Open Directory Description (README)'
                               name: 'CheckBox10'
                               activeHelpKey: autoOpenDirectoryDescription
                               model: viewDirectoryDescription
                               translateLabel: true
                               extent: (Point 435 30)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 625 170)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FileBrowserV2SettingsAppl class methodsFor:'resources'!

classResources
    ^ FileBrowserV2 classResources
! !

!FileBrowserV2SettingsAppl methodsFor:'accessing'!

requestor
    "return the value of the instance variable 'requestor' (automatically generated)"

    | masterApplication |
    masterApplication := self masterApplication.
    masterApplication notNil ifTrue:[
        ^ masterApplication requestor.
    ].
    ^ nil
! !

!FileBrowserV2SettingsAppl methodsFor:'actions'!

basicSaveSettings
    |aspectList writeToCurrentFileBrowser|

    aspectList := AbstractFileBrowser userPreferencesAspectList.

    writeToCurrentFileBrowser := (settingsDialog notNil and:[settingsDialog isKindOf:AbstractFileBrowser]).
    aspectList keysDo:[ :anAspect | |value|
        value := (self perform:anAspect) value.
        (currentUserPrefs perform:(anAspect asString asMutator) with:value).
        writeToCurrentFileBrowser ifTrue:[
            (settingsDialog perform:anAspect) value:value.
        ].
    ].

    "Modified: / 15-10-2010 / 10:29:28 / cg"
!

helpFilename
    ^ 'FileBrowserV2/settings.html'
!

readSettings
    |receiver aspectList|

    receiver := (settingsDialog notNil and:[settingsDialog isKindOf:AbstractFileBrowser]) ifTrue:[
                settingsDialog
            ] ifFalse:[
                currentUserPrefs
            ].
    aspectList := AbstractFileBrowser userPreferencesAspectList.
    aspectList keysDo:[:anAspect |
        |value|
        value := (receiver perform:anAspect) value.
        (self perform:anAspect) value:value
    ].
    self modifiedChannel value:false

    "Modified: / 03-04-2007 / 08:45:12 / cg"
! !

!FileBrowserV2SettingsAppl methodsFor:'aspects'!

alwaysUseSmalltalkTools
    alwaysUseSmalltalkTools isNil ifTrue:[
        alwaysUseSmalltalkTools := ValueHolder with:true.
        alwaysUseSmalltalkTools onChangeSend:#updateModifiedChannel to:self
    ].
    ^ alwaysUseSmalltalkTools
!

filenameEntryFieldVisibleHolder
    filenameEntryFieldVisibleHolder isNil ifTrue:[
        filenameEntryFieldVisibleHolder := ValueHolder with:true.
        filenameEntryFieldVisibleHolder onChangeSend:#updateModifiedChannel
            to:self
    ].
    ^ filenameEntryFieldVisibleHolder
!

openAlwaysInTextEditor
    openAlwaysInTextEditor isNil ifTrue:[
        openAlwaysInTextEditor := ValueHolder with:true.
        openAlwaysInTextEditor onChangeSend:#updateModifiedChannel to:self
    ].
    ^ openAlwaysInTextEditor
!

openMultipleApplicationsForType
    openMultipleApplicationsForType isNil ifTrue:[
        openMultipleApplicationsForType := ValueHolder with:true.
        openMultipleApplicationsForType onChangeSend:#updateModifiedChannel
            to:self
    ].
    ^ openMultipleApplicationsForType
!

showDirectoriesOnTop
    showDirectoriesOnTop isNil ifTrue:[
        showDirectoriesOnTop := ValueHolder with:true.
        showDirectoriesOnTop onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showDirectoriesOnTop

    "Created: / 12-08-2014 / 13:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDirectoryTree
    showDirectoryTree isNil ifTrue:[
        showDirectoryTree := ValueHolder with:true.
        showDirectoryTree onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showDirectoryTree
!

showHiddenFiles
    showHiddenFiles isNil ifTrue:[
        showHiddenFiles := ValueHolder with:true.
        showHiddenFiles onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showHiddenFiles

    "Modified: / 15-10-2010 / 10:28:07 / cg"
!

sortCaseless
    sortCaseless isNil ifTrue:[
        sortCaseless := ValueHolder with:true.
        sortCaseless onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sortCaseless
!

sortDirectoriesBeforeFiles
    sortDirectoriesBeforeFiles isNil ifTrue:[
        sortDirectoriesBeforeFiles := ValueHolder with:true.
        sortDirectoriesBeforeFiles onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sortDirectoriesBeforeFiles
!

toolBarVisibleHolder
    toolBarVisibleHolder isNil ifTrue:[
        toolBarVisibleHolder := ValueHolder with:true.
        toolBarVisibleHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ toolBarVisibleHolder
!

useCodeView2InTools
    "/ obsolete - will vanish
    useCodeView2InTools isNil ifTrue:[
        useCodeView2InTools := ValueHolder with:true.
        useCodeView2InTools onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useCodeView2InTools

    "Created: / 06-10-2011 / 11:30:42 / cg"
!

viewDescription
    viewDescription isNil ifTrue:[
        viewDescription := ValueHolder with:false.
        viewDescription onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewDescription
!

viewDetails
    viewDetails isNil ifTrue:[
        viewDetails := ValueHolder with:true.
        viewDetails onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewDetails
!

viewDirectoryDescription
    viewDirectoryDescription isNil ifTrue:[
        viewDirectoryDescription := ValueHolder with:true.
        viewDirectoryDescription onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewDirectoryDescription
!

viewDirsInContentsBrowser
    viewDirsInContentsBrowser isNil ifTrue:[
        viewDirsInContentsBrowser := ValueHolder with:true.
        viewDirsInContentsBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewDirsInContentsBrowser
!

viewFilesInDirectoryTree
    viewFilesInDirectoryTree isNil ifTrue:[
        viewFilesInDirectoryTree := ValueHolder with:true.
        viewFilesInDirectoryTree onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewFilesInDirectoryTree
!

viewGroup
    viewGroup isNil ifTrue:[
        viewGroup := ValueHolder with:true.
        viewGroup onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewGroup
!

viewOwner
    viewOwner isNil ifTrue:[
        viewOwner := ValueHolder with:true.
        viewOwner onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewOwner
!

viewPermissions
    viewPermissions isNil ifTrue:[
        viewPermissions := ValueHolder with:true.
        viewPermissions onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewPermissions
!

viewPreview
    viewPreview isNil ifTrue:[
        viewPreview := ValueHolder with:true.
        viewPreview onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewPreview
!

viewSize
    viewSize isNil ifTrue:[
        viewSize := ValueHolder with:true.
        viewSize onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewSize
!

viewSizeInBytes
    viewSizeInBytes isNil ifTrue:[
        viewSizeInBytes := ValueHolder with:false.
        viewSizeInBytes onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewSizeInBytes
!

viewSizeInKiloBytes
    viewSizeInKiloBytes isNil ifTrue:[
        viewSizeInKiloBytes := ValueHolder with:false.
        viewSizeInKiloBytes onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewSizeInKiloBytes
!

viewTime
    viewTime isNil ifTrue:[
        viewTime := ValueHolder with:true.
        viewTime onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewTime
!

viewType
    viewType isNil ifTrue:[
        viewType := ValueHolder with:true.
        viewType onChangeSend:#updateModifiedChannel to:self
    ].
    ^ viewType
! !

!FileBrowserV2SettingsAppl methodsFor:'queries'!

hasUnsavedChanges

    |aspectList receiver|

    receiver := (settingsDialog notNil 
                and:[settingsDialog isKindOf:AbstractFileBrowser]) 
                    ifTrue:[ settingsDialog ] 
                    ifFalse:[ currentUserPrefs ].

    aspectList := AbstractFileBrowser userPreferencesAspectList.
    aspectList keysDo:[:anAspect |
        (self perform:anAspect) value ~= (receiver perform:anAspect) value ifTrue:[ 
            ^ true
        ]
    ].
    ^ false

    "Modified: / 03-04-2007 / 08:45:27 / cg"
    "Modified (format): / 25-11-2011 / 15:24:25 / cg"
! !

!FileBrowserV2SettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

