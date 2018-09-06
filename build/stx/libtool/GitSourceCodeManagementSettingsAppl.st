"
 COPYRIGHT (c) 2012 by eXept Software AG
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

AbstractSourceCodeManagementSettingsAppl subclass:#GitSourceCodeManagementSettingsAppl
	instanceVariableNames:'repositoryHolder workDirectoryHolder manager repository
		repositoryPrototypeList addPerModuleRepository
		removePerModuleRepository perModuleRepository
		defaultRepositoryHolder selectedPerModuleRepository
		repositoriesPerModule perModuleRepositoryModule
		gitBinDirectoryHolder gitExecutableHolder gitCommandTimeoutHolder
		pushURL pushURLPrototypeList selectedPushURL listOfPushURLs'
	classVariableNames:'RecentlyUsedRepositoryURLS'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!GitSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Attention: this will be removed soon - it has been obsoleted by the
    new mercurial support found in libscm/mercurial.

    Git part of the source code settings. 
    This settings app controls the parameters of the GitSourceCodeManager.

    Extracted for pluggability from SourceCodeManagerSettings in the AbstractSettingsApplication.
"
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'defaults'!

defaultRepositoryName

    ^ './gitRepository'

    "Created: / 19-04-2011 / 11:00:11 / cg"
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:GitSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#addPerModuleRoot
'Add this per-module entry'

#addPerPackageManager
'Add a new per-package manager definition'

#browseSourceCache
'Open a file browser on the source cache directory'

#checkPerPackageManager
'Open a window to show which scm-manager is responsible for which package'

#condenseSourceCache
'Cleanup old cached versions from the source cache.\Will keep only the current (newest) version in the cache.\Access to older code versions will be slowed down (compare with old version browser function)'

#cvsCommand
'The command to use for cvs operations\(the path to "cvs"/"cvs.exe"-command. Not needed, if already in the shell''s PATH value)'

#cvsCommandTimeout
'The command timeout.\For slow connections (ssl-tunnel), it may make sense to increase this value'

#cvsRootPerModule
'Specifies per-module CVSROOTs.\This allows for individual projects to be stored in different cvs repositories'

#cvsRootPerModuleModule
'The module for which a specific CVSROOT is defined'

#cvsRootPerModuleRoot
'The CVSROOT for which this specific module is defined'

#defaultManagerType
'The default repository type.\This is used for packages for which no entry matches in the list below'

#editPerPackageManager
'Modify the selected per-package manager definition'

#flushSourceCache
'Remove all files from the source cache.\Access to source code will temporarily be slowed down,\until sources have been refetched from the repository'

#gitAddPushURL
'Add a repository to the push-URL list. A repository-push operation will synchronize your changes with this repository as well'

#gitCheckAccess
'Perform a "git status" command in the default repository to see if the repository is accessible'

#gitCheckAccessPerModuleRoot
'Perform a "git status" command in this module''s repository to see if the repository is accessible'

#gitCommand
'The command to use for git operations\(the path to "git"/"git.exe"-command. Not needed, if already in the shell''s PATH value)'

#gitCommandTimeout
'The command timeout.\For slow connections (ssl-tunnel), it may make sense to increase this value'

#gitInit
'Perform a "git init" command to setup the repository for the very first time'

#gitPushURLs
'The push-URL list. A repository-push operation will send your changes to these repositories as well'

#gitRemovePushURL
'Remove the selected repository from the push-URL list. A repository-push operation will no longer synchronize your changes with this repository'

#gitRootDefault
'The default git repository.\This will be used for all modules which are not listed below'

#gitRootPerModule
'The git repository for which this specific module is defined'

#gitRootPerModuleModule
'The module for which a specific git repository is defined'

#gitRootPerModuleRoot
'The git repository for which this specific module is defined'

#moveManagerDown
'Move the selected entry down in the list.\(The first matching definition is used to determine which repository type is used.)'

#moveManagerUp
'Move the selected entry up in the list.\(The first matching definition is used to determine which repository type is used.)'

#perPackageConfiguration
'Define per-package repository types here.\For any non-matching package-id, the default repository type is used'

#removePerModuleRoot
'Remove this per-module entry'

#removePerPackageManager
'Remove the selected per-package manager definition'

#sourceCache
'After checkout, keep the sourcefile in a local file (to avoid repeated checkout of the same file)'

#useLocalSources
'If present, use the local source files (from the development system''s tree).\If checkout fails, these will always be tried as second chance'

#useManager
'Enable source code management.\If off, all queries for sourcecode are resolved by local files (offline operation)'

#verboseSourceCodeAccess
'Output debugging messages on the Transcript\(mostly traces of the underlying scm mechanism, such as cvs commands)'

)
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon2

    "Created: / 22-12-2011 / 13:47:11 / cg"
!

defaultIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GitSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CT5MST5MP@5MST5MST@MST5MST5MP@@@CT5MST5MP@5MST5MST@MST5MST5MP@@@CT5MST5MP@5MST5
MST@MST5MST5@@@@@CT5MST5MP@5MST5MST@MST5MST5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@CX6M#X6M @6M#X6M#X@M#X6M#X6M @@
@CX6M#X6M @6M#X6M#X@M#X6M#X6M @@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 192 0 0 0 128 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@_/78_/78@@@@@@@@@@@@FCA FCA _/78_/78FCA FCA @@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GitSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP4@CP4MCP4@CP4MCP4@@@@@@@@@C 8NC 8@C 8NC 8@
C 8NC 8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,B@@@@@@,B@@@@@@,B@@@@@@@@@@@@@@,BB0,@
@@,BB0,@@@,BB0,@@@@@@@@@@ HB@ H@@ HB@ H@@ HB@ H@@@@@@@@@B0,BB0H@B0,BB0H@B0,BB0H@@@@@@@@@B0,BB0@@B0,BB0@@B0,BB0@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HB@TEC0@@@@@@@@@@@@@@@@@@@@@@@@THB@ HAP@@@@@@@@@@@@@@@@@@@@@@@P H@@<@@@T@@@@@@@@@@@@@@@@@
@@@@AP,E@@@@@@@@@@@@@@@@@@@@@@@@@@TEB@\HA @@BP@@@@@@@@@@@@@@@@@@@@@EA0 E@@@IBP$@@@@@@@@@@@@@@@@@@@@@APP@@@$C@00I@@@@@@@@
@@@@@@@@@@@@@@@@@@@JBP$I@@@@@@@@@@@@@@@@@@@I@@<@@@@IBP@@@@@@@@@@@@@@@@@@@@@@BP$IBP$I@@@@@@@@@@@@@@@@@@@@@@@@@@(IBP$@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 64 0 0 128 0 32 32 32 32 64 32 32 96 32 32 128 32 32 128 64 32 160 64 64 64 64 96 96 96 96 192 128 128 128 128 192 0 0 209 87 87 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@>>>@>>>@@@@@@@@@XXX@^^^@>>>@<<<@LLL@@@@A<@@C<@@GR@@G@@@_$@@ON@@F_@@@O@@JL@@G<@@C8@@@@@@');
                            yourself);
                yourself
        ]
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GitSourceCodeManagementSettingsAppl andSelector:#windowSpec
     GitSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     GitSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Git Settings'
          name: 'Git Settings'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 811 734)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel3'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topSpace
              horizontalSpace: 3
              verticalSpace: 4
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Unfinished & Experimental'
                    name: 'Label10'
                    style: (FontDescription #'Segoe UI' medium roman 16 #'ms-default')
                    foregroundColor: (Color 86.9993133440147 0.0 0.0)
                    translateLabel: true
                    extent: (Point 811 37)
                  )
                 (ViewSpec
                    name: 'ManagerSetupBoxx'
                    component: 
                   (SpecCollection
                      collection: (
                       (FramedBoxSpec
                          label: 'Git Sourcecode Manager Settings'
                          name: 'GitSetupBox'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          labelPosition: topLeft
                          translateLabel: true
                          component: 
                         (SpecCollection
                            collection: (
                             (ComboBoxSpec
                                name: 'ComboBox3'
                                layout: (LayoutFrame 64 0.25 309 0 0 1 331 0)
                                activeHelpKey: gitRootPerModuleModule
                                tabable: true
                                model: perModuleRepositoryModule
                                acceptChannel: acceptChannel
                                acceptOnPointerLeave: true
                                comboList: sampleModuleList
                              )
                             (CheckBoxSpec
                                label: 'Show in Browser Menus'
                                name: 'CheckBox1'
                                layout: (LayoutFrame 0 0 5 0 0 1 27 0)
                                activeHelpKey: shownInBrowserMenus
                                model: shownInBrowserMenusHolder
                                translateLabel: true
                              )
                             (ViewSpec
                                name: 'CommandBox'
                                layout: (LayoutFrame 0 0 35 0 0 1 60 0)
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Git Command or Path:'
                                      name: 'Label1'
                                      layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                      activeHelpKey: gitCommand
                                      level: 0
                                      translateLabel: true
                                      adjust: right
                                    )
                                   (InputFieldSpec
                                      name: 'GitExecutableField'
                                      layout: (LayoutFrame 64 0.25 0 0 0 1 22 0)
                                      activeHelpKey: gitCommand
                                      tabable: true
                                      model: gitExecutableHolder
                                      acceptChannel: acceptChannel
                                      acceptOnPointerLeave: true
                                    )
                                   )
                                 
                                )
                              )
                             (ViewSpec
                                name: 'TimeoutBox'
                                layout: (LayoutFrame 0 0 61 0 0 1 86 0)
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Git Command Timeout:'
                                      name: 'Label2'
                                      layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                      activeHelpKey: gitCommandTimeout
                                      level: 0
                                      translateLabel: true
                                      adjust: right
                                    )
                                   (InputFieldSpec
                                      name: 'EntryField1'
                                      layout: (LayoutFrame 64 0.25 0 0 168 0.25 22 0)
                                      activeHelpKey: gitCommandTimeout
                                      tabable: true
                                      model: gitCommandTimeoutHolder
                                      type: timeDuration
                                      acceptChannel: acceptChannel
                                      acceptOnPointerLeave: true
                                    )
                                   )
                                 
                                )
                              )
                             (ViewSpec
                                name: 'WorkingDirBox'
                                layout: (LayoutFrame 0 0 87 0 0 1 112 0)
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Working Directory:'
                                      name: 'Label9'
                                      layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                      activeHelpKey: workDirectory
                                      level: 0
                                      translateLabel: true
                                      adjust: right
                                    )
                                   (InputFieldSpec
                                      name: 'EntryField2'
                                      layout: (LayoutFrame 64 0.25 0 0 0 1 22 0)
                                      activeHelpKey: workDirectory
                                      tabable: true
                                      model: workDirectoryHolder
                                      type: string
                                      acceptChannel: acceptChannel
                                      acceptOnPointerLeave: true
                                    )
                                   )
                                 
                                )
                              )
                             (ViewSpec
                                name: 'DefaultRepositoryBox7'
                                layout: (LayoutFrame 0 0.0 118 0 0 1 143 0)
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Default Repository:'
                                      name: 'defaultCvsRootLabel'
                                      layout: (LayoutFrame 0 0.0 2 0 60 0.25 24 0)
                                      activeHelpKey: gitRootDefault
                                      level: 0
                                      translateLabel: true
                                      adjust: right
                                    )
                                   (ComboBoxSpec
                                      name: 'RepositoryComboBox'
                                      layout: (LayoutFrame 64 0.25 2 0 0 1 24 0)
                                      activeHelpKey: gitRootDefault
                                      tabable: true
                                      model: repositoryHolder
                                      immediateAccept: true
                                      acceptOnLeave: true
                                      acceptOnReturn: true
                                      acceptOnTab: true
                                      acceptOnLostFocus: true
                                      acceptChannel: acceptChannel
                                      acceptOnPointerLeave: true
                                      comboList: repositoryPrototypeList
                                    )
                                   )
                                 
                                )
                              )
                             (ActionButtonSpec
                                label: 'Init'
                                name: 'Button2'
                                layout: (LayoutFrame -201 1 148 0 -101 1 170 0)
                                activeHelpKey: gitInit
                                translateLabel: true
                                tabable: true
                                model: initializeRepository
                                enableChannel: cvsLoginEnabled
                              )
                             (ActionButtonSpec
                                label: 'Check Access'
                                name: 'Button1'
                                layout: (LayoutFrame -100 1 148 0 0 1 170 0)
                                activeHelpKey: gitCheckAccess
                                translateLabel: true
                                tabable: true
                                model: checkAccess
                                enableChannel: cvsLoginEnabled
                              )
                             (LabelSpec
                                label: 'Repository per Module:'
                                name: 'knownModulesLabel'
                                layout: (LayoutFrame 0 0.0 184 0 60 0.25 206 0)
                                activeHelpKey: gitRootPerModule
                                translateLabel: true
                                adjust: right
                              )
                             (SequenceViewSpec
                                name: 'List1'
                                layout: (LayoutFrame 64 0.25 184 0 0 1 303 0)
                                activeHelpKey: gitRootPerModule
                                tabable: true
                                model: selectedPerModuleRepository
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                miniScrollerHorizontal: true
                                useIndex: false
                                sequenceList: listOfModules
                              )
                             (LabelSpec
                                label: 'Module:'
                                name: 'moduleLabel'
                                layout: (LayoutFrame 0 0.0 313 0 60 0.25 330 0)
                                activeHelpKey: gitRootPerModuleModule
                                translateLabel: true
                                adjust: right
                              )
                             (LabelSpec
                                label: 'Git Repository:'
                                name: 'gitRepository'
                                layout: (LayoutFrame 0 0.0 338 0 60 0.25 355 0)
                                activeHelpKey: gitRootPerModuleRoot
                                translateLabel: true
                                adjust: right
                              )
                             (ComboBoxSpec
                                name: 'perModuleRepositoryComboBox'
                                layout: (LayoutFrame 64 0.25 334 0 0 1.0 356 0)
                                activeHelpKey: gitRootPerModuleRoot
                                tabable: true
                                model: perModuleRepository
                                immediateAccept: true
                                acceptOnLeave: true
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptChannel: acceptChannel
                                acceptOnPointerLeave: true
                                comboList: gitRepositoryPrototypeList
                              )
                             (HorizontalPanelViewSpec
                                name: 'PerModuleButtonHorizontalPanel'
                                layout: (LayoutFrame 64 0.25 361 0 -1 1 386 0)
                                horizontalLayout: right
                                verticalLayout: center
                                horizontalSpace: 3
                                verticalSpace: 3
                                component: 
                               (SpecCollection
                                  collection: (
                                   (ActionButtonSpec
                                      label: 'Add/Apply'
                                      name: 'addButton'
                                      activeHelpKey: addPerModuleRoot
                                      translateLabel: true
                                      tabable: true
                                      model: addPerModuleRoot
                                      extent: (Point 100 22)
                                    )
                                   (ActionButtonSpec
                                      label: 'Remove'
                                      name: 'removeButton'
                                      activeHelpKey: removePerModuleRoot
                                      translateLabel: true
                                      tabable: true
                                      model: removePerModuleRoot
                                      enableChannel: removeEnabled
                                      extent: (Point 100 22)
                                    )
                                   (ViewSpec
                                      name: 'Box11'
                                      extent: (Point 100 10)
                                    )
                                   (ActionButtonSpec
                                      label: 'Init'
                                      name: 'Button3'
                                      activeHelpKey: gitLoginPerModuleRoot
                                      translateLabel: true
                                      tabable: true
                                      model: initializePerModuleRepository
                                      enableChannel: cvsLoginEnabled
                                      extent: (Point 100 22)
                                    )
                                   (ActionButtonSpec
                                      label: 'Check Access'
                                      name: 'checkButton2'
                                      activeHelpKey: gitCheckAccessPerModuleRoot
                                      translateLabel: true
                                      tabable: true
                                      model: checkAccessPerModuleRepository
                                      enableChannel: cvsLoginInModuleEnabled
                                      extent: (Point 100 22)
                                    )
                                   )
                                 
                                )
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    extent: (Point 811 418)
                  )
                 (FramedBoxSpec
                    label: 'Push URLs'
                    name: 'FramedBox2'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'URL to Push To:'
                          name: 'Label6'
                          layout: (LayoutFrame 0 0.0 14 0 60 0.25 36 0)
                          activeHelpKey: gitPushURLs
                          translateLabel: true
                          adjust: right
                        )
                       (SequenceViewSpec
                          name: 'List2'
                          layout: (LayoutFrame 64 0.25 14 0 0 1 90 0)
                          activeHelpKey: gitPushURLs
                          tabable: true
                          model: selectedPushURL
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          useIndex: false
                          sequenceList: listOfPushURLs
                        )
                       (LabelSpec
                          label: 'URL:'
                          name: 'Label8'
                          layout: (LayoutFrame 0 0.0 101 0 60 0.25 118 0)
                          activeHelpKey: gitAddPushURL
                          translateLabel: true
                          adjust: right
                        )
                       (ComboBoxSpec
                          name: 'ComboBox2'
                          layout: (LayoutFrame 64 0.25 97 0 0 1.0 119 0)
                          activeHelpKey: gitAddPushURL
                          tabable: true
                          model: pushURL
                          immediateAccept: true
                          acceptOnLeave: true
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnLostFocus: true
                          acceptChannel: acceptChannel
                          acceptOnPointerLeave: true
                          comboList: gitPushURLPrototypeList
                        )
                       (HorizontalPanelViewSpec
                          name: 'HorizontalPanel3'
                          layout: (LayoutFrame 64 0.25 125 0 -1 1 150 0)
                          horizontalLayout: right
                          verticalLayout: center
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (ActionButtonSpec
                                label: 'Add/Apply'
                                name: 'Button6'
                                activeHelpKey: gitAddPushURL
                                translateLabel: true
                                tabable: true
                                model: addPushURL
                                extent: (Point 100 22)
                              )
                             (ActionButtonSpec
                                label: 'Remove'
                                name: 'Button7'
                                activeHelpKey: gitRemovePushURL
                                translateLabel: true
                                tabable: true
                                model: removePushURL
                                enableChannel: removeEnabled
                                extent: (Point 100 22)
                              )
                             (ViewSpec
                                name: 'Box17'
                                extent: (Point 100 10)
                              )
                             (ViewSpec
                                name: 'Box18'
                                extent: (Point 100 10)
                              )
                             (ViewSpec
                                name: 'Box19'
                                extent: (Point 99 9)
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    extent: (Point 811 181)
                  )
                 (FramedBoxSpec
                    label: 'Source Cache'
                    name: 'FramedBox1'
                    visibilityChannel: false
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: 'SourceCacheDirBox'
                          layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                          component: 
                         (SpecCollection
                            collection: (
                             (LabelSpec
                                label: 'Source Cache Dir:'
                                name: 'SourceCacheDirLabel'
                                layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                translateLabel: true
                                adjust: right
                              )
                             (InputFieldSpec
                                name: 'SourceCacheDirEntryField'
                                layout: (LayoutFrame 64 0.25 0 0 0 1 22 0)
                                model: sourceCacheDir
                                immediateAccept: false
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: true
                              )
                             )
                           
                          )
                        )
                       (HorizontalPanelViewSpec
                          name: 'CacheActionsHorizontalPanel'
                          layout: (LayoutFrame 44 0.25 33 0 0 1 67 0)
                          horizontalLayout: fitSpace
                          verticalLayout: center
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (ActionButtonSpec
                                label: 'Flush Cache now'
                                name: 'FlushCacheNowButton'
                                translateLabel: true
                                tabable: true
                                model: flushSourceCache
                                extent: (Point 265 22)
                              )
                             (ActionButtonSpec
                                label: 'Condense Cache now'
                                name: 'CondenseCacheNowButton'
                                translateLabel: true
                                tabable: true
                                model: condenseSourceCache
                                extent: (Point 265 22)
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    extent: (Point 811 95)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ GitSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    repositoriesPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

basicReadSettings
    |infoPerModule|

    self initialize.

    self sourceCacheDir value:(GitSourceCodeManager cacheDirectoryName).

    repository := GitSourceCodeManager repositoryName.
    self repositoryHolder value:(repository ? '') asValue.
    self workDirectoryHolder value:GitSourceCodeManager workDirectory.

    infoPerModule := GitSourceCodeManager repositoryInfoPerModule.
    infoPerModule keysAndValuesDo:[:module :info | 
        repositoriesPerModule at:module put:(Array with:GitSourceCodeManager with:info).
    ].

    self repositoryHolder value:GitSourceCodeManager repositoryName ? self class defaultRepositoryName.
    self gitExecutableHolder value:GitSourceCodeManager gitExecutable.
    self gitCommandTimeoutHolder value:GitSourceCodeManager gitCommandTimeout.
    self verboseSourceCodeAccess value:GitSourceCodeManager verboseSourceCodeAccess. 
    self shownInBrowserMenusHolder value:GitSourceCodeManager shownInBrowserMenus. 

    repositoriesPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:repositoriesPerModule keys asList.
    ].
"/    self selectedPerModuleRootChanged.

    "Modified: / 03-03-2012 / 11:08:11 / cg"
!

basicSaveSettings
    |modules nm fn infoPerModule|

    nm := self sourceCacheDir value.
    nm notEmptyOrNil ifTrue:[
        (fn := nm asFilename) exists ifFalse:[
            (self confirm:('Git cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                fn recursiveMakeDirectory; 
                   makeReadableForAll;
                   makeWritableForAll;
                   makeExecutableForAll.
            ]
        ].
        (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
            GitSourceCodeManager cacheDirectoryName:nm.
        ] ifFalse:[
            self warn:'Invalid sourceCache directory.'
        ]
    ].

    GitSourceCodeManager gitCommandTimeout:(self gitCommandTimeoutHolder value).

    modules := repositoriesPerModule select:[:entry | entry first == GitSourceCodeManager].
    infoPerModule := Dictionary new.
    modules keysAndValuesDo:[:module :entry | 
        entry first == GitSourceCodeManager ifTrue:[
            infoPerModule at:module put:(entry second).
        ].
    ].
    GitSourceCodeManager repositoryInfoPerModule:infoPerModule.
    GitSourceCodeManager workDirectory:self workDirectoryHolder value.

    self basicSaveGitSettings.

    self sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).

    DebugView newDebugger. "/ ???

    self acceptChannel value.

    "Modified: / 23-07-2012 / 13:18:38 / cg"
!

removePerModuleRoot
    |module|

    acceptChannel value:true.    
    module := self perModuleRepositoryModule value.
    self listOfModules remove:module ifAbsent:nil.
    repositoriesPerModule removeKey:module ifAbsent:nil.
    self perModuleRepositoryModule value:nil.
    self perModuleRepository value:nil.
    self updateModifiedChannel.

    "Modified: / 26-01-2012 / 13:50:08 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'actions - git'!

addPerModuleRoot
    |module gitRepository|

    acceptChannel value:true.    

    module := self perModuleRepositoryModule value.
    gitRepository := self perModuleRepository value.

    gitRepository size > 0 ifTrue:[
        self addModule:module withData:(Array with:GitSourceCodeManager with:gitRepository).
    ].

    "Modified (format): / 02-03-2012 / 15:22:41 / cg"
!

basicSaveGitSettings
    |gitRepository|

    repositoryHolder notNil ifTrue:[
        repositoryHolder value size > 0 ifTrue:[
            manager notNil ifTrue:[
                manager initializeForRepository:repositoryHolder value.
            ]
        ].
    ].
    GitSourceCodeManager gitExecutable:((self gitExecutableHolder value ? '') withoutSeparators).
    self repositoryHolder value isEmptyOrNil ifTrue:[
        Dialog information:'You must specify a valid gitRepository directory'.
        ^ self.
    ].
    GitSourceCodeManager initializeForRepository:(gitRepository := self repositoryHolder value).
    GitSourceCodeManager verboseSourceCodeAccess: verboseSourceCodeAccess value. 
    GitSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    RecentlyUsedRepositoryURLS isNil ifTrue:[
        RecentlyUsedRepositoryURLS := OrderedCollection new.
    ].
    (RecentlyUsedRepositoryURLS includes:gitRepository) ifFalse:[
        RecentlyUsedRepositoryURLS addFirst:gitRepository.
        RecentlyUsedRepositoryURLS size > 20 ifTrue:[
            RecentlyUsedRepositoryURLS removeLast.
        ].
    ].

    "Created: / 02-03-2012 / 15:19:22 / cg"
!

checkAccess
    self halt:'unimplemented feature'

    "Created: / 17-01-2012 / 17:34:53 / cg"
!

initializeRepository
    |repository|

    repository := self repositoryHolder value.
    repository isEmptyOrNil ifTrue:[
        Dialog warn:(resources string:'No default repository defined.').
        ^ self.
    ].
    GitSourceCodeManager initializeForRepository:repository

    "Created: / 17-01-2012 / 17:42:27 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'aspects'!

gitCommandTimeoutHolder
    gitCommandTimeoutHolder isNil ifTrue:[
        gitCommandTimeoutHolder := ValueHolder new.
        gitCommandTimeoutHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ gitCommandTimeoutHolder.

    "Created: / 02-03-2012 / 15:22:11 / cg"
!

gitExecutableHolder
    gitExecutableHolder isNil ifTrue:[
        gitExecutableHolder := ValueHolder new.
        gitExecutableHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ gitExecutableHolder.

    "Created: / 02-03-2012 / 15:22:18 / cg"
!

initialListOfModules
    ^ repositoriesPerModule keys asList sort.

    "Created: / 02-03-2012 / 14:41:07 / cg"
!

listOfPushURLs

    listOfPushURLs isNil ifTrue:[
        listOfPushURLs := List new.
    ].
    ^ listOfPushURLs.

    "Created: / 02-03-2012 / 16:22:25 / cg"
!

perModuleRepository
    perModuleRepository isNil ifTrue:[
        perModuleRepository := ValueHolder new.
        perModuleRepository addDependent:self.
    ].
    ^ perModuleRepository.

    "Created: / 14-01-2012 / 20:18:59 / cg"
!

perModuleRepositoryModule
    perModuleRepositoryModule isNil ifTrue:[
        perModuleRepositoryModule := ValueHolder new.
    ].
    ^ perModuleRepositoryModule.

    "Created: / 14-01-2012 / 20:19:51 / cg"
!

pushURL
    pushURL isNil ifTrue:[
        pushURL := ValueHolder new.
        pushURL addDependent:self.
    ].
    ^ pushURL.

    "Created: / 02-03-2012 / 15:53:11 / cg"
!

pushURLPrototypeList
    |prototypeList|

    pushURLPrototypeList isNil ifTrue:[
        prototypeList := OrderedSet new.

"/        cvsRoot := self cvsRootFromCVSRootFileOrNil.
"/        cvsRoot notNil ifTrue:[
"/            prototypeList add:cvsRoot    
"/        ].

        prototypeList add:('https://inst.kilnhg.com/Repo/Foo/Bar/Baz').
        "/ prototypeList add:('https://inst.kilnhg.com/Repo/Dino-VM/Group/Dino-VM').
        pushURLPrototypeList := prototypeList asOrderedCollection.
    ].
    ^ pushURLPrototypeList.

    "Created: / 02-03-2012 / 15:53:58 / cg"
!

repositoryHolder

    repositoryHolder isNil ifTrue:[
        repositoryHolder := self class defaultRepositoryName asValue.
        repositoryHolder addDependent:self.
    ].
    ^ repositoryHolder.

    "Created: / 14-01-2012 / 20:03:00 / cg"
!

repositoryPrototypeList
    |prototypeList|

    repositoryPrototypeList isNil ifTrue:[
        prototypeList := OrderedSet new.

"/        cvsRoot := self cvsRootFromCVSRootFileOrNil.
"/        cvsRoot notNil ifTrue:[
"/            prototypeList add:cvsRoot    
"/        ].

        prototypeList add:(OperatingSystem getHomeDirectory asFilename construct:'.smalltalk/gitRepository') pathName.
        prototypeList add:(OperatingSystem getHomeDirectory asFilename construct:'gitRepository') pathName.
        prototypeList add:('./gitRepository').
        prototypeList add:('https://github.com/smalltalkX/<project>/').
        "/ prototypeList add:('https://inst.kilnhg.com/Repo/Dino-VM/Group/Dino-VM').
        repositoryPrototypeList := prototypeList asOrderedCollection.
    ].
    ^ repositoryPrototypeList.

    "Created: / 14-01-2012 / 20:13:43 / cg"
!

selectedPerModuleRepository
    selectedPerModuleRepository isNil ifTrue:[
        selectedPerModuleRepository := ValueHolder new.
        selectedPerModuleRepository addDependent:self.
    ].
    ^ selectedPerModuleRepository.

    "Created: / 14-01-2012 / 20:14:04 / cg"
!

selectedPushURL
    selectedPushURL isNil ifTrue:[
        selectedPushURL := ValueHolder new.
        selectedPushURL addDependent:self.
    ].
    ^ selectedPushURL.

    "Created: / 02-03-2012 / 16:20:21 / cg"
!

workDirectoryHolder
    workDirectoryHolder isNil ifTrue:[
        workDirectoryHolder := ValueHolder new.
        workDirectoryHolder addDependent:self.
    ].
    ^ workDirectoryHolder.

    "Created: / 03-03-2012 / 10:34:19 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModuleRepositoryChanged
    |repository entry|

    self acceptChannel value:true.    
    repository := self selectedPerModuleRepository value.
    repository isNil ifTrue:[ 
        self removeEnabled value:false.
        self perModuleRepositoryModule value:' '.
        self perModuleRepository value:''.
        ^ self
    ].

    entry := repositoriesPerModule at:repository ifAbsent:#().    
    (entry first = GitSourceCodeManager) ifTrue:[
        self removeEnabled value:true.
        self perModuleRepositoryModule value:repository.
        self perModuleRepository value:(entry at:2).
    ] ifFalse:[
        self removeEnabled value:false.
        self perModuleRepositoryModule value:repository , ' ',('<<use ',entry first managerTypeName,'>>') allBold.
        self perModuleRepository value:''.
    ].

    "Created: / 14-01-2012 / 20:24:57 / cg"
!

update:something with:aParameter from:changedObject 

    "/ cvs
    changedObject == repositoryHolder ifTrue:[
        self updateModifiedChannel.
        "/ self updateLoginEnableHolders.
        ^ self
    ].
"/    changedObject == perModuleRepository ifTrue:[
"/        self updateLoginEnableHolders.
"/        ^ self
"/    ].
    changedObject == selectedPerModuleRepository ifTrue:[
        self selectedPerModuleRepositoryChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 14-01-2012 / 20:26:51 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_GITSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/gitSetup.html'

    "Modified: / 02-03-2012 / 15:20:09 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    repositoriesPerModule := Dictionary new.

    GitSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            repositoriesPerModule at:module put:(Array with:GitSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 02-03-2012 / 15:20:19 / cg"
! !

!GitSourceCodeManagementSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    |modules|

    ((GitSourceCodeManager cacheDirectoryName ? '') ~= (self sourceCacheDir value ? '')) ifTrue:[^ true].

    modules := repositoriesPerModule select:[:entry | entry first == GitSourceCodeManager].

    GitSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((modules includesKey:module) and:[info = (modules at:module) second])
        ifFalse:[^ true].
    ].   
    modules keysAndValuesDo:[:module :info|
        ((GitSourceCodeManager repositoryInfoPerModule includesKey:module) 
            and:[(GitSourceCodeManager repositoryInfoPerModule at:module) = info second])
        ifFalse:[^ true].
    ].
    (GitSourceCodeManager gitCommandTimeout ~= gitCommandTimeoutHolder value)
        ifTrue:[^ true].

    ((GitSourceCodeManager gitExecutable ? '') ~= (self gitExecutableHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].

    (GitSourceCodeManager repositoryName ? self class defaultRepositoryName ~= self repositoryHolder value)    
        ifTrue:[^ true].

    (GitSourceCodeManager verboseSourceCodeAccess ~= self verboseSourceCodeAccess value) 
        ifTrue:[^ true].

    (GitSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    ^ false

    "Modified: / 02-03-2012 / 15:20:03 / cg"
! !

!GitSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

