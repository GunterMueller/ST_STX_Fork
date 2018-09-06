"
 COPYRIGHT (c) 2003 by eXept Software AG
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

ApplicationModel subclass:#FileBrowserV2SettingsDialog
	instanceVariableNames:'settingsDialog settingsAppl'
	classVariableNames:'ApplicationList'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV2SettingsDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FileBrowserV2SettingsDialog class methodsFor:'interface specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowserV2SettingsDialog andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2SettingsDialog mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'File'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Load Settings From...'
                  #itemValue: #loadSettingsFromFile
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: 'Save Settings To...'
                  #itemValue: #saveSettingsIntoFile
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'Exit'
                  #itemValue: #closeRequest
                  #translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2SettingsDialog andSelector:#windowSpec
     FileBrowserV2SettingsDialog new openInterface:#windowSpec
     FileBrowserV2SettingsDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Settings Dialog'
         name: 'Settings Dialog'
         min: (Point 10 10)
         max: (Point 1024 768)
         bounds: (Rectangle 0 0 528 649)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'FileBrowserV2SettingsAppl'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -36 1)
             level: 0
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             majorKey: FileBrowserV2SettingsAppl
             createNewApplication: true
             createNewBuilder: true
             postBuildCallback: postBuildSubCanvas:
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0.0 -36 1 -16 1.0 0 1)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OK'
                   translateLabel: true
                   model: doSave
                   enableChannel: enableButtons
                   extent: (Point 97 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'Apply'
                   name: 'Apply'
                   translateLabel: true
                   model: doApply
                   enableChannel: enableButtons
                   extent: (Point 98 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'Reload'
                   name: 'Reload'
                   translateLabel: true
                   model: doReload
                   enableChannel: enableButtons
                   extent: (Point 97 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Cancel'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 98 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'Help'
                   name: 'Help'
                   visibilityChannel: false
                   translateLabel: true
                   model: help
                   enableChannel: enableButtons
                   extent: (Point 98 32)
                   usePreferredHeight: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!FileBrowserV2SettingsDialog class methodsFor:'resources'!

classResources
    ^ FileBrowserV2 classResources
! !

!FileBrowserV2SettingsDialog methodsFor:'accessing'!

settingsDialog
    ^ settingsDialog
!

settingsDialog:something
    settingsDialog := something.
! !

!FileBrowserV2SettingsDialog methodsFor:'actions'!

doApply
    (settingsAppl saveRequestAsking:false) ifFalse:[
        ^ self
    ].
!

doCancel
    super closeRequest.
!

doReload

    settingsAppl readSettings.
!

doSave

"/    settingsAppl saveRequest.  -- already done in closeRequest.
    (settingsAppl saveRequestAsking:false) ifFalse:[
        ^ self
    ].
    ^ super closeRequest
!

help

    settingsAppl help
! !

!FileBrowserV2SettingsDialog methodsFor:'initialization & release'!

closeRequest
    "This is a hook method generated by the Browser.
     It will be invoked when your app/dialog-window is about to be
     closed (this method has a chance to suppress the close).
     See also #closeDownViews, which is invoked when the close is really done."

    (settingsAppl saveRequestAsking:true) ifFalse:[
        ^ self
    ].
    ^ super closeRequest
!

postBuildSubCanvas:aWidget

    settingsAppl := aWidget client.
    settingsAppl settingsDialog:self settingsDialog.
    aWidget keepClientView:true. 
!

postOpenWith:aWidget

    settingsAppl readSettings.
    super postOpenWith:aWidget. 
! !

!FileBrowserV2SettingsDialog methodsFor:'menu actions'!

loadSettingsFromFile

    "restore settings from a settings-file."

    "a temporary kludge - we need a central systemSettings object for this,
     which can be saved/restored with a single store/read."

    |fileName|

    fileName := Dialog 
        requestFileName:(resources string:'Load Settings From:') 
        default:'settings.stx'
        ok:(resources string:'Load') 
        abort:(resources string:'Cancel') 
        pattern:'*.stx'
        fromDirectory:nil.

    (fileName size == 0) ifTrue:[
        "/ canceled
        ^ self
    ].

    self withWaitCursorDo:[
        Smalltalk fileIn:fileName.
        Transcript current topView model reOpen.
        self doReload.
    ].
!

saveSettingsIntoFile

    |fileName resources|

    resources := self class classResources.

    self doReload.

    fileName := Dialog 
        requestFileName:(resources string:'Save settings in:') 
        default:'settings.stx'
        ok:(resources string:'Save') 
        abort:(resources string:'Cancel') 
        pattern:'*.stx'
        fromDirectory:'.'.

    fileName size ~~ 0 ifTrue:[
        "not canceled"
        UserPreferences current saveIn:fileName.
    ]
! !

!FileBrowserV2SettingsDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

