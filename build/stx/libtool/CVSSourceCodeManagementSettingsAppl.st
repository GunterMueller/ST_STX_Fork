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

AbstractSourceCodeManagementSettingsAppl subclass:#CVSSourceCodeManagementSettingsAppl
	instanceVariableNames:'repositoryHolder manager repository cvsRootPrototypeList
		addPerModuleRoot perModuleRootModule removePerModuleRoot
		perModuleRoot cvsRootHolder selectedPerModuleRoot
		cvsBinDirectoryHolder cvsExecutableHolder cvsCommandTimeoutHolder
		rootsPerModule cvsLoginInModuleEnabled cvsLoginEnabled
		cvsInitInModuleEnabled'
	classVariableNames:'RecentlyUsedCVSRoots'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!CVSSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

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
!

documentation
"
    CVS part of the source code settings. 
    This settings app controls the parameters of the CVSSourceCodeManager.

    Extracted for pluggability from SourceCodeManagerSettings in the AbstractSettingsApplication.
"
! !

!CVSSourceCodeManagementSettingsAppl class methodsFor:'defaults'!

defaultRepositoryName

    ^ '/cvs/stx'

    "Created: / 19-04-2011 / 11:00:11 / cg"
! !

!CVSSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:CVSSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#addPerModuleRoot
'Add this module-CVSRoot combination or update the corresponding per-module entry'

#addPerPackageManager
'Add a new per-package manager definition'

#addPublicExeptRepository
'Add an entry to access stx''s sources from the public exept repository'

#browseSourceCache
'Open a file browser on the source cache directory'

#checkClassesWhenCheckingIn
'Before checking into the repository, check classes for leftover halt and breakpoint code'

#checkPerPackageManager
'Open a window to show which scm-manager is responsible for which package'

#condenseSourceCache
'Cleanup old cached versions from the source cache.\Will keep only the current (newest) version in the cache.\Access to older code versions will be slowed down (compare with old version browser function)'

#cvsCommand
'The command to use for cvs operations\(the path to "cvs"/"cvs.exe"-command. Not needed, if already in the shell''s PATH value)'

#cvsCommandTimeout
'The command timeout.\For slow connections (ssl-tunnel), it may make sense to increase this value'

#cvsLogin
'Perform a "cvs login" operation for the default CVSROOT'

#cvsRootDefault
'The default CVSROOT.\This will be used for all modules which are not listed below'

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

#initPerModuleRoot
'Execute a "cvs init" operation for this CVSROOT (enabled if a new local repository is selected)'

#keepMethodSourceInImage
'After first file access, keep the method sources in the image itself.\All following text search operations will be much faster.\Grows the image over time (but who cares, these days)'

#loginPerModuleRoot
'Execute a "cvs login" operation for this CVSROOT (enabled when a remote repository is selected)'

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

!CVSSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon2

    "Created: / 22-12-2011 / 13:47:11 / cg"
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'CVSSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@DB@@@@@@@@@@@@@@@@@@@@@@@@@@LDAPLFA0 I@@@@@@@@@@@@@@@@@@@@@@(KC@0MC <D@@@@@@@@@@@@@@@@@@@CB04LD@DAA@8C@ D@@@@@
@@@@@@@@@@@OC 4HDP(IBAHND0 @@@@@@@@@@@@@@@@EE@PU@@@@APLV@0@@@@@@@@@@@@@@@@LVC!!\E@@@@@@PXA  Y@@@@@@@@@@@@@@PVEA$Z@@@@@@P[
A!!0]@@@@@@@@@@@@@@@EEAXW@@@@APL[G @@@@@@@@@@@@@@@@@SD!!P_DB@JHQ8FD0 @@@@@@@@@@@@@@@@]BRHTF2L$IRX''D0 @@PH@@@@@@@@@@@@@JBD)
J",,KR$!!@0PE@0XGB@$@@@@@@@@@@B8!!F"4-F"D.B ,LC@4NC0P@@@@@@@@@@@@@@A\]@@LKCP0P@PDDC LB@P@@@@@@@@@@@@@@@@<NCP QB $HD 8SB@@@
@@@@@@@@@@@@@@TTAAT@@@@E@1XC@@@@@@@@@@@@@@@@@1XNE0T@@@@@AA FBA$@@@@@@@@@@@@@AAXTFQ(@@@@@AA,FGA4@@@@@@@@@@@@@@@TTE!!\@@@@E
@1,^@@@@@@@@@@@@@@@@@ALREA<PH@(!!G XSB@@@@@@@@@@@@@@@@A4IH!!P[H2P%I"\SB@@@@@@@@@@@@@@@@@@(HR$*J20-JRD@@@@@@@@@@@@@@@@@@@@@
K"DZKR4ZHR8@@@@@@@@@@@@@@@@@@@@@@@@@E14@@@@@@@@@') ; colorMapFromArray:#[0 0 0 160 176 200 176 192 210 176 200 220 192 208 220 224 232 240 176 208 220 208 224 220 144 168 180 192 200 220 208 216 220 208 224 240 224 232 250 224 240 250 208 232 240 160 192 210 176 184 180 128 136 140 192 216 220 160 184 210 208 240 250 144 144 160 192 224 240 160 168 180 192 232 240 160 176 180 224 224 220 192 232 250 144 168 200 176 184 200 160 200 220 192 216 240 176 192 200 160 184 200 192 224 220 176 224 250 176 216 250 160 208 240 144 192 250 144 176 210 255 248 250 160 192 220 144 184 210 160 200 240 160 192 240 128 160 180 128 152 180]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@X@@C?@@C?@@O?0@O?0@OG @_C8@_C8@OG @O?0@O?6@G??0C??0@[?<@C?<@C18@G0>@G0>@C18@C?<@C?<@A?0@@?0@@F@') ; yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'CVSSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@DB@@@@@@@@@@@@@@@@@@@@@@@@@@LDAPLFA0 I@@@@@@@@@@@@@@@@@@@@@@(KC@0MC <D@@@@@@@@@@@@@@@@@@@CB04LD@DAA@8C@ D@@@@@
@@@@@@@@@@@OC 4HDP(IBAHND0 @@@@@@@@@@@@@@@@EE@PU@@@@APLV@0@@@@@@@@@@@@@@@@LVC!!\E@@@@@@PXA  Y@@@@@@@@@@@@@@PVEA$Z@@@@@@P[
A!!0]@@@@@@@@@@@@@@@EEAXW@@@@APL[G @@@@@@@@@@@@@@@@@SD!!P_DB@JHQ8FD0 @@@@@@@@@@@@@@@@]BRHTF2L$IRX''D0 @@PH@@@@@@@@@@@@@JBD)
J",,KR$!!@0PE@0XGB@$@@@@@@@@@@B83L3@0F"D.B ,LC@4NC0P@@@@@@@@@@C@3L3L3L@LKCP0P@PDDC LB@P@@@@@@K3L3@@@@@C@NCP QB $HD 8SB@@@
@@@@LCD0@@@@@@TTAAT@@@@E@1XC@@@@@C@0L3H3M@@@MQXNE0T@@@@@AA FBA$@@@@0L#L0@@@5MSTTFQ(@@@@@AA,FGA4@@@@@LC$@@CT8NC\5E!!\@@@@E
@1,^@@@@@@@@@@@@MST6MST5EA<PH@(!!G XSB@@@@@@5@@@@@@@5MQ4IH!!P[H2P%I"\SB@@@@@@@MST5MST5@@@(HR$*J20-JRD@@@@@@@@@@CX5MST@@@@@
K"DZKR4ZHR8@@@@@@@@@@@@@@@@@@@@@@@@@E14@@@@@@@@@') ; colorMapFromArray:#[0 0 0 160 176 200 176 192 210 176 200 220 192 208 220 224 232 240 176 208 220 208 224 220 144 168 180 192 200 220 208 216 220 208 224 240 224 232 250 224 240 250 208 232 240 160 192 210 176 184 180 128 136 140 192 216 220 160 184 210 208 240 250 144 144 160 192 224 240 160 168 180 192 232 240 160 176 180 224 224 220 192 232 250 144 168 200 176 184 200 160 200 220 192 216 240 176 192 200 160 184 200 192 224 220 176 224 250 176 216 250 160 208 240 144 192 250 144 176 210 255 248 250 160 192 220 144 184 210 160 200 240 160 192 240 128 160 180 128 152 180 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@X@@C?@@C?@@O?0@O?0@OG @_C8@_C8@OG @O?0@O?6@G??0C??0C??<GC?<GC18_''0>OO0>F_18@??<HO?<G=?0C8?0@@F@') ; yourself); yourself]
! !

!CVSSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CVSSourceCodeManagementSettingsAppl andSelector:#windowSpec
     CVSSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     CVSSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'CVS Settings'
         name: 'CVS Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 764 589)
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
                (ViewSpec
                   name: 'ManagerSetupBoxx'
                   component: 
                  (SpecCollection
                     collection: (
                      (FramedBoxSpec
                         label: 'CVS Sourcecode Manager Settings'
                         name: 'CVSSetupBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         labelPosition: topLeft
                         translateLabel: true
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Show in Browser Menus'
                               name: 'CheckBox1'
                               layout: (LayoutFrame 0 0 5 0 0 1 35 0)
                               activeHelpKey: shownInBrowserMenus
                               model: shownInBrowserMenusHolder
                               translateLabel: true
                             )
                            (ViewSpec
                               name: 'Box1'
                               layout: (LayoutFrame 0 0 35 0 0 1 65 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'CVS Command:'
                                     name: 'Label1'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                                     activeHelpKey: cvsCommand
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'CVSExecutableField'
                                     layout: (LayoutFrame 64 0.25 0 0 -1 1 30 0)
                                     activeHelpKey: cvsCommand
                                     tabable: true
                                     model: cvsExecutableHolder
                                     acceptChannel: acceptChannel
                                     acceptOnPointerLeave: true
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'Box12'
                               layout: (LayoutFrame 0 0 69 0 0 1 99 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Command Timeout:'
                                     name: 'Label2'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                                     activeHelpKey: cvsCommandTimeout
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     layout: (LayoutFrame 64 0.25 0 0 152 0.25 30 0)
                                     activeHelpKey: cvsCommandTimeout
                                     tabable: true
                                     model: cvsCommandTimeoutHolder
                                     type: timeDuration
                                     acceptChannel: acceptChannel
                                     acceptOnPointerLeave: true
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'Box7'
                               layout: (LayoutFrame 0 0.0 104 0 0 1 134 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'CVSRoot default:'
                                     name: 'defaultCvsRootLabel'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                                     activeHelpKey: cvsRootDefault
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (ComboBoxSpec
                                     name: 'cvsRootComboBox'
                                     layout: (LayoutFrame 64 0.25 0 0 -1 1 30 0)
                                     activeHelpKey: cvsRootDefault
                                     tabable: true
                                     model: cvsRootHolder
                                     immediateAccept: true
                                     acceptOnLeave: true
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptChannel: acceptChannel
                                     acceptOnPointerLeave: true
                                     comboList: cvsRootPrototypeList
                                   )
                                  )
                                
                               )
                             )
                            (ActionButtonSpec
                               label: 'CVS-Login'
                               name: 'Button1'
                               layout: (LayoutFrame -117 1 137 0 0 1 167 0)
                               activeHelpKey: cvsLogin
                               translateLabel: true
                               tabable: true
                               model: loginCVSRoot
                               enableChannel: cvsLoginEnabled
                             )
                            (LabelSpec
                               label: 'CVSRoot per Module:'
                               name: 'knownModulesLabel'
                               layout: (LayoutFrame 0 0.0 171 0 60 0.25 201 0)
                               activeHelpKey: cvsRootPerModule
                               translateLabel: true
                               adjust: right
                             )
                            (SequenceViewSpec
                               name: 'List1'
                               layout: (LayoutFrame 64 0.25 171 0 0 1 290 0)
                               activeHelpKey: cvsRootPerModule
                               tabable: true
                               model: selectedPerModuleRoot
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               miniScrollerHorizontal: true
                               useIndex: false
                               sequenceList: listOfModules
                             )
                            (LabelSpec
                               label: 'Module:'
                               name: 'moduleLabel'
                               layout: (LayoutFrame 0 0.0 300 0 60 0.25 330 0)
                               activeHelpKey: cvsRootPerModuleModule
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'ComboBox1'
                               layout: (LayoutFrame 64 0.25 300 0 0 1 330 0)
                               activeHelpKey: cvsRootPerModuleModule
                               tabable: true
                               model: perModuleRootModule
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: sampleModuleList
                             )
                            (LabelSpec
                               label: 'CVSRoot:'
                               name: 'cvsRootLabel'
                               layout: (LayoutFrame 0 0.0 333 0 60 0.25 363 0)
                               activeHelpKey: cvsRootPerModuleRoot
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'perModuleRootComboBox'
                               layout: (LayoutFrame 64 0.25 333 0 0 1.0 363 0)
                               activeHelpKey: cvsRootPerModuleRoot
                               tabable: true
                               model: perModuleRoot
                               immediateAccept: true
                               acceptOnLeave: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: cvsRootPrototypeList
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel2'
                               layout: (LayoutFrame 0 0 369 0 -1 1 400 0)
                               horizontalLayout: rightSpaceMax
                               verticalLayout: fit
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
                                     resizeForLabel: true
                                     tabable: true
                                     model: addPerModuleRoot
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Remove'
                                     name: 'removeButton'
                                     activeHelpKey: removePerModuleRoot
                                     translateLabel: true
                                     resizeForLabel: true
                                     tabable: true
                                     model: removePerModuleRoot
                                     enableChannel: removeEnabled
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Init'
                                     name: 'loginButton2'
                                     activeHelpKey: initPerModuleRoot
                                     translateLabel: true
                                     resizeForLabel: true
                                     tabable: true
                                     model: initPerModuleRoot
                                     enableChannel: cvsInitInModuleEnabled
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Login'
                                     name: 'Button3'
                                     activeHelpKey: loginPerModuleRoot
                                     translateLabel: true
                                     resizeForLabel: true
                                     tabable: true
                                     model: loginPerModuleRoot
                                     enableChannel: cvsLoginInModuleEnabled
                                     useDefaultExtent: true
                                   )
                                  )
                                
                               )
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel3'
                               layout: (LayoutFrame 64 0.25 403 0 -1 1 436 0)
                               horizontalLayout: right
                               verticalLayout: center
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Add eXept''s Public Repository'
                                     name: 'Button2'
                                     activeHelpKey: addPublicExeptRepository
                                     translateLabel: true
                                     resizeForLabel: true
                                     adjust: right
                                     tabable: true
                                     model: addPublicExeptRepository
                                     extent: (Point 272 32)
                                     usePreferredWidth: true
                                     useDynamicPreferredHeight: true
                                     usePreferredHeight: true
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 764 474)
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
                         layout: (LayoutFrame 0 0 0 0 -1 1 30 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Source Cache Dir:'
                               name: 'SourceCacheDirLabel'
                               layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'SourceCacheDirEntryField'
                               layout: (LayoutFrame 64 0.25 0 0 -1 1 30 0)
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
                         layout: (LayoutFrame 44 0.25 33 0 -1 1 63 0)
                         horizontalLayout: rightMax
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
                               extent: (Point 227 30)
                             )
                            (ActionButtonSpec
                               label: 'Condense Cache now'
                               name: 'CondenseCacheNowButton'
                               translateLabel: true
                               tabable: true
                               model: condenseSourceCache
                               extent: (Point 227 30)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 764 101)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!CVSSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ CVSSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    rootsPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

addPublicExeptRepository
    self addModule:'stx' withData:{ CVSSourceCodeManager . (CVSSourceCodeManager exeptsPublicSTXRepositoryModuleRoot) }.
!

basicReadSettings
    |infoPerModule|

    self initialize.

    self sourceCacheDir value:(CVSSourceCodeManager cacheDirectoryName).

    CVSSourceCodeManager forgetDisabledModules.
    repository := CVSSourceCodeManager repositoryName.
    repositoryHolder := (repository ? '') asValue.

    infoPerModule := CVSSourceCodeManager repositoryInfoPerModule.
    infoPerModule keysAndValuesDo:[:module :info | 
        rootsPerModule at:module put:(Array with:CVSSourceCodeManager with:info).
    ].

    self cvsRootHolder value:CVSSourceCodeManager repositoryName ? self class defaultRepositoryName.
    self cvsExecutableHolder value:CVSSourceCodeManager cvsExecutable.
    self cvsCommandTimeoutHolder value:CVSSourceCodeManager cvsCommandTimeout.
    self verboseSourceCodeAccess value:CVSSourceCodeManager verboseSourceCodeAccess. 
    self shownInBrowserMenusHolder value:CVSSourceCodeManager shownInBrowserMenus. 

    rootsPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:rootsPerModule keys asList.
    ].
"/    self selectedPerModuleRootChanged.

    "Modified: / 10-01-2012 / 00:17:09 / cg"
!

basicSaveSettings
    |modules nm fn|

    nm := self sourceCacheDir value.
    nm notEmptyOrNil ifTrue:[
        (fn := nm asFilename) exists ifFalse:[
            (self confirm:('CVS cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                fn recursiveMakeDirectory; 
                   makeReadableForAll;
                   makeWritableForAll;
                   makeExecutableForAll.
            ]
        ].
        (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
            CVSSourceCodeManager cacheDirectoryName:nm.
        ] ifFalse:[
            self warn:'Invalid sourceCache directory.'
        ]
    ].

    CVSSourceCodeManager cvsCommandTimeout:(self cvsCommandTimeoutHolder value).

    (Array with:CVSSourceCodeManager) "self availableManagers" do:[:eachManager |
        |infoPerModule|

        modules := rootsPerModule select:[:entry | entry first == eachManager].
        infoPerModule := Dictionary new.
        modules keysAndValuesDo:[:module :entry | 
            entry first == eachManager ifTrue:[
                infoPerModule at:module put:(entry second).
            ].
        ].
        eachManager repositoryInfoPerModule:infoPerModule.
    ].

    self basicSaveCVSSettings.

    self sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).

    DebugView newDebugger. "/ ???

    self acceptChannel value.

    "Modified: / 08-01-2012 / 18:59:58 / cg"
!

removePerModuleRoot
    |module|

    acceptChannel value:true.    
    module := self perModuleRootModule value.
    self listOfModules remove:module ifAbsent:nil.
    rootsPerModule removeKey:module ifAbsent:nil.
    self perModuleRootModule value:nil.
    self perModuleRoot value:nil.
    self updateModifiedChannel.

    "Modified (format): / 21-12-2011 / 14:25:29 / cg"
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'actions - cvs'!

addPerModuleRoot
    |module cvsRoot|

    acceptChannel value:true.    

    module := self perModuleRootModule value.
    cvsRoot := self perModuleRoot value.

    cvsRoot size > 0 ifTrue:[
        self addModule:module withData:(Array with:CVSSourceCodeManager with:cvsRoot).
    ].

    "Modified: / 08-11-2006 / 19:27:39 / cg"
!

basicSaveCVSSettings
    |cvsRoot|

    repositoryHolder notNil ifTrue:[
        repositoryHolder value size > 0 ifTrue:[
            manager notNil ifTrue:[
                manager initializeForRepository:repositoryHolder value.
            ]
        ].
    ].
    CVSSourceCodeManager cvsExecutable:((self cvsExecutableHolder value ? '') withoutSeparators).
    CVSSourceCodeManager initializeForRepository:(cvsRoot := self cvsRootHolder value).
    CVSSourceCodeManager verboseSourceCodeAccess: verboseSourceCodeAccess value. 
    CVSSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    RecentlyUsedCVSRoots isNil ifTrue:[
        RecentlyUsedCVSRoots := OrderedCollection new.
    ].
    (RecentlyUsedCVSRoots includes:cvsRoot) ifFalse:[
        RecentlyUsedCVSRoots addFirst:cvsRoot.
        RecentlyUsedCVSRoots size > 20 ifTrue:[
            RecentlyUsedCVSRoots removeLast.
        ].
    ].

    "Modified: / 10-01-2012 / 00:18:15 / cg"
!

cvsInit:cvsRoot
    |terminalEmulatorClass cmd term rootLocal|

    terminalEmulatorClass := "VT100TerminalView ?" TerminalView.
    terminalEmulatorClass isNil ifTrue:[
        self warn:'Function not available (missing terminal emulation class)'.
        ^ self.
    ].

    term := terminalEmulatorClass open.
    term topView 
        label:'CVS init for ' , cvsRoot;
        waitUntilVisible.
    term shellTerminateAction:[
        "/ term topView destroy
    ].

    rootLocal := cvsRoot withoutPrefix:':local:'.
    rootLocal := rootLocal asFilename asAbsoluteFilename pathName.
"/ self halt.
    term showCR:(('Close this terminal window, when finished') withColor:#red).
    term showCR:''.
    term endEntry.

    Delay waitForSeconds:1.
    cmd := 'md "%1"' bindWith:rootLocal.
    term sendLine:cmd.
    "/ cmd := 'set CVSROOT="%1"' bindWith:rootLocal.
    "/ term sendLine:cmd.
    cmd := 'cvs -d "%1" init' bindWith:rootLocal.
    term sendLine:cmd.
    cmd := 'exit'.
    term sendLine:cmd.

    "
     self basicNew cvsInit:':local:c:\users\exept\cvs'
    "

    "Modified: / 31-07-2013 / 18:29:19 / cg"
!

cvsLogin:cvsRoot
    |terminalEmulatorClass cmd term|

    terminalEmulatorClass := "VT100TerminalView ?" TerminalView.
    terminalEmulatorClass isNil ifTrue:[
        self warn:'Function not available (missing terminal emulation class)'.
        ^ self.
    ].

    term := terminalEmulatorClass open.
    term topView 
        label:'CVS Login for ' , cvsRoot;
        waitUntilVisible.
    term shellTerminateAction:[
        "/ term topView destroy
    ].

    term showCR:(('Please enter the CVS-password then close this terminal window.') withColor:#red).
    term showCR:''.
    term endEntry.

    Delay waitForSeconds:1.
    cmd := 'cvs -d "%1" login' bindWith:cvsRoot.
    term sendLine:cmd.
    cmd := 'exit'.
    term sendLine:cmd.

    "
     self basicNew cvsLogin:':pserver:stx@exept.eu.org:/stx'
    "

    "Modified: / 25-08-2010 / 23:03:19 / cg"
!

initPerModuleRoot
    self cvsInit:perModuleRoot value.
!

loginCVSRoot
    self cvsLogin:cvsRootHolder value.
!

loginPerModuleRoot
    self cvsLogin:perModuleRoot value.
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'aspects'!

cvsCommandTimeoutHolder
    cvsCommandTimeoutHolder isNil ifTrue:[
        cvsCommandTimeoutHolder := ValueHolder new.
        cvsCommandTimeoutHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ cvsCommandTimeoutHolder.

    "Created: / 08-01-2012 / 18:57:05 / cg"
!

cvsExecutableHolder
    cvsExecutableHolder isNil ifTrue:[
        cvsExecutableHolder := ValueHolder new.
        cvsExecutableHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ cvsExecutableHolder.

    "Created: / 21-09-2006 / 15:37:06 / cg"
!

cvsInitInModuleEnabled
    cvsInitInModuleEnabled isNil ifTrue:[
        cvsInitInModuleEnabled := false asValue.
    ].
    ^ cvsInitInModuleEnabled.
!

cvsLoginEnabled
    cvsLoginEnabled isNil ifTrue:[
        cvsLoginEnabled := false asValue.
    ].
    ^ cvsLoginEnabled.
!

cvsLoginInModuleEnabled
    cvsLoginInModuleEnabled isNil ifTrue:[
        cvsLoginInModuleEnabled := false asValue.
    ].
    ^ cvsLoginInModuleEnabled.
!

cvsRootHolder

    cvsRootHolder isNil ifTrue:[
        cvsRootHolder := self cvsRootFromCVSRootFileOrNil asValue.
        cvsRootHolder addDependent:self.
    ].
    ^ cvsRootHolder.
!

cvsRootPrototypeList
    |cvsRoot prototypeList|

    cvsRootPrototypeList isNil ifTrue:[
        prototypeList := OrderedSet new.

        cvsRoot := self cvsRootFromCVSRootFileOrNil.
        cvsRoot notNil ifTrue:[
            prototypeList add:cvsRoot    
        ].

        prototypeList add:(':pserver:cvs@cvs.smalltalk-x.de:/cvs/stx').

        OperatingSystem getDomainName = 'bh.exept.de' ifTrue:[
            prototypeList add:(':pserver:' , OperatingSystem getLoginName , '@cvs.bh.exept.de:/cvs/stx')
        ] ifFalse:[
            prototypeList add:(':pserver:' , OperatingSystem getLoginName , '@CVSHOST:/cvs/stx').
        ].

        OperatingSystem isUNIXlike ifTrue:[
            prototypeList add:(':local:',OperatingSystem getHomeDirectory,'/cvs').
            prototypeList add:':local:/cvs/stx'.
        ] ifFalse:[
            OperatingSystem isMSDOSlike ifTrue:[
                prototypeList add:(':local:',OperatingSystem getHomeDirectory asLowercase,'\cvs').
                prototypeList add:':local:c:\cvs\stx'.
            ] ifFalse:[
                "there might be more here in the future"
            ]
        ].

        cvsRootPrototypeList := prototypeList asOrderedCollection.
    ].
    ^ cvsRootPrototypeList.

    "Modified: / 20-01-2012 / 16:17:35 / cg"
!

initialListOfModules
    ^ rootsPerModule keys asList sort.

    "Created: / 02-03-2012 / 14:39:15 / cg"
!

perModuleRoot
    perModuleRoot isNil ifTrue:[
        perModuleRoot := ValueHolder new.
        perModuleRoot addDependent:self.
    ].
    ^ perModuleRoot.
!

perModuleRootModule
    perModuleRootModule isNil ifTrue:[
        perModuleRootModule := ValueHolder new.
    ].
    ^ perModuleRootModule.
!

selectedPerModuleRoot
    selectedPerModuleRoot isNil ifTrue:[
        selectedPerModuleRoot := ValueHolder new.
        selectedPerModuleRoot addDependent:self.
    ].
    ^ selectedPerModuleRoot.
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModuleRootChanged
    |module entry|

    self acceptChannel value:true.    
    module := self selectedPerModuleRoot value.
    module isNil ifTrue:[ 
        self removeEnabled value:false.
        self perModuleRootModule value:' '.
        self perModuleRoot value:''.
        ^ self
    ].

    entry := rootsPerModule at:module ifAbsent:#().    
    (entry first = CVSSourceCodeManager) ifTrue:[
        self removeEnabled value:true.
        self perModuleRootModule value:module.
        self perModuleRoot value:(entry at:2).
    ] ifFalse:[
        self removeEnabled value:false.
        self perModuleRootModule value:module , ' ',('<<use ',entry first managerTypeName,'>>') allBold.
        self perModuleRoot value:''.
    ].
!

update:something with:aParameter from:changedObject 

    "/ cvs
    changedObject == cvsRootHolder ifTrue:[
        self updateModifiedChannel.
        self updateLoginEnableHolders.
        ^ self
    ].
    changedObject == perModuleRoot ifTrue:[
        self updateLoginEnableHolders.
        self updateInitEnableHolders.
        ^ self
    ].
    changedObject == selectedPerModuleRoot ifTrue:[
        self selectedPerModuleRootChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 18-04-2011 / 18:18:04 / cg"
!

updateInitEnableHolders
    |cvsRoot rootDir hasLocalRepository isAlreadyInitialized|

    isAlreadyInitialized := false.
    cvsRoot := (perModuleRoot value ? '').
    (hasLocalRepository := (cvsRoot startsWith:':local:')) ifTrue:[
        rootDir := (cvsRoot withoutPrefix:':local:') asFilename.
        isAlreadyInitialized := rootDir exists
                                and:[ (rootDir / 'CVSROOT') exists].
    ].
    self cvsInitInModuleEnabled value:isAlreadyInitialized not.
!

updateLoginEnableHolders
    self cvsLoginEnabled value:((cvsRootHolder value ? '') startsWith:':pserver:').
    self cvsLoginInModuleEnabled value:((perModuleRoot value ? '') startsWith:':pserver:').
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_CVSSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/cvsSetup.html'
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    repositoryHolder := '' asValue.
    rootsPerModule := Dictionary new.

    CVSSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            rootsPerModule at:module put:(Array with:CVSSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 14-01-2012 / 20:28:00 / cg"
! !

!CVSSourceCodeManagementSettingsAppl methodsFor:'queries'!

cvsRootFromCVSRootFileOrNil
    "see if there is a local CVS directory; if so, extract a default CVSRoot from it"

    |cvsDir cvsRootFile cvsRoot|

    cvsDir := 'CVS' asFilename.
    cvsDir isDirectory ifFalse:[ ^ nil ].

    cvsRootFile := cvsDir construct:'Root'.
    cvsRootFile isReadable ifTrue:[
        cvsRoot := cvsRootFile contents firstIfEmpty:nil.
    ].
    ^ cvsRoot

    "Modified: / 22-12-2011 / 00:12:42 / cg"
    "Modified (comment): / 14-01-2012 / 20:29:11 / cg"
!

hasUnsavedChanges
    |modules|

    ((CVSSourceCodeManager cacheDirectoryName ? '') ~= (self sourceCacheDir value ? '')) ifTrue:[^ true].

    modules := rootsPerModule select:[:entry | entry first == CVSSourceCodeManager].

    CVSSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((modules includesKey:module) and:[info = (modules at:module) second])
        ifFalse:[^ true].
    ].
    modules keysAndValuesDo:[:module :info|
        ((CVSSourceCodeManager repositoryInfoPerModule includesKey:module) and:[(CVSSourceCodeManager repositoryInfoPerModule at:module) = info second])
        ifFalse:[^ true].
    ].
    (CVSSourceCodeManager cvsCommandTimeout ~= self cvsCommandTimeoutHolder value)
        ifTrue:[^ true].

    ((CVSSourceCodeManager cvsExecutable ? '') ~= (self cvsExecutableHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].

    (CVSSourceCodeManager repositoryName ? self class defaultRepositoryName ~= self cvsRootHolder value)    
        ifTrue:[^ true].

    (CVSSourceCodeManager verboseSourceCodeAccess ~= self verboseSourceCodeAccess value) 
        ifTrue:[^ true].

    (CVSSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    ^ false

    "Modified: / 22-01-2012 / 11:25:53 / cg"
! !

!CVSSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

