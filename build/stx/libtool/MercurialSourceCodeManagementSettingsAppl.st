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

AbstractSourceCodeManagementSettingsAppl subclass:#MercurialSourceCodeManagementSettingsAppl
	instanceVariableNames:'workDirectoryHolder repositoryHolder manager repository
		repositoryPrototypeList addPerModuleRepository
		removePerModuleRepository perModuleRepository
		defaultRepositoryHolder selectedPerModuleRepository
		hgBinDirectoryHolder hgExecutableHolder hgCommandTimeoutHolder
		repositoriesPerModule perModuleRepositoryModule selectedPushURL
		pushURL pushURLPrototypeList listOfPushURLs'
	classVariableNames:'RecentlyUsedRepositoryURLS'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

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

    Mercurial part of the source code settings. 
    This settings app controls the parameters of the MercurialSourceCodeManager.

    Extracted for pluggability from SourceCodeManagerSettings in the AbstractSettingsApplication.
"
! !

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'defaults'!

defaultRepositoryName

    ^ './hgRepository'

    "Created: / 19-04-2011 / 11:00:11 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MercurialSourceCodeManagementSettingsAppl    
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

#defaultManagerType
'The default repository type.\This is used for packages for which no entry matches in the list below'

#editPerPackageManager
'Modify the selected per-package manager definition'

#flushSourceCache
'Remove all files from the source cache.\Access to source code will temporarily be slowed down,\until sources have been refetched from the repository'

#hgAddPushURL
'Add a repository to the push-URL list.\A repository-push operation will synchronize your changes with this repository as well'

#hgCheckAccess
'Perform a "hg status" command in the default repository\to see if the repository is accessible'

#hgCheckAccessPerModuleRoot
'Perform a "hg status" command in this module''s repository\to see if the repository is accessible'

#hgCommand
'The command to use for mercurial operations\(the path to the "hg" or "hg.exe"-command.\Not needed, if already in the shell''s PATH value)'

#hgCommandTimeout
'The command timeout.\For slow connections (ssl-tunnel), it may make sense to increase this value'

#hgInit
'Perform a "hg init" command to setup the repository for the very first time'

#hgPushURLs
'The push-URL list.\A repository-push operation will send your changes to these repositories as well'

#hgRemovePushURL
'Remove the selected repository from the push-URL list.\A repository-push operation will no longer synchronize your changes with this repository'

#hgRootDefault
'The default mercurial repository.\This will be used for all mercurial modules which are not listed below'

#hgRootPerModule
'The mercurial repository for which this specific module is defined'

#hgRootPerModuleModule
'The module for which a specific mercurial repository is defined.\The module is the first component of the packageID ("module:directoryPath")\by which applications and classes are grouped.'

#hgRootPerModuleRoot
'The mercurial repository for which this specific module is defined.\The module is the first component of the packageID ("module:directoryPath")\by which applications and classes are grouped.'

#hgWorkingDirectory
'The mercurial working directory.\This is used to hold temporary files during mercurial checkin/checkout operations'

#loginPerModuleRoot
'Execute a "cvs login" operation for this CVSROOT'

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

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon3

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
        constantNamed:'MercurialSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<P@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AHC@@@@HP@O@BHIB@ HB@LFH0H@@@@ABQ0@@@@@@@@!!A@@DB@ HCA0OI@8@@@@@@@@@@A\@@@@@@@XDB@ HBP8%I D@
@@@@@@@BA@$D@P@@@@8IB@ LC P''C0@@@@@@@@DIB@ HBQ0@@@8LA@XA@Q<Y@0@@@@@@@@PLB@ DA@@@@@PCB" JC2T[@@@@@@@@@@PLB@PPBP@@@@P)JB$I
J!!HA@@@@@@@@@B,LBQXCKB,@A XACQP-F0L@@@@@@@@@@@(RK"T,D0@@BA,/LCD@L @@@@@@@@@@@@@@@ $!!@@@@@QTTC@ 3@@@@@@@@@@@@@@@@@@@@@@@@
@CP\L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_G?>NA?>@P_>A<_<C>_<C>_8C>_8C>?0C<? @8?@@@\@@@@@');
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
        constantNamed:'MercurialSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<P@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AH:N#\7HP@O@BHIB@ HB@LFH0H@@@@ABS\:N#(:M0@!!A@@DB@ HCA0OI@8@@@@@M#(:@A\@@C\@@@XDB@ HBP8%I D@
@@@@M3 7A@$D@P@@@@8IB@ LC P''C0@@@C\7N#$:N0 HHA0@@@8LA@XA@Q<Y@0@@@@@7NS(7B@  HB@@@@PCB" JC2T[@@@@@@@@M34LBB@<OAP @@P)JB$I
J!!HA@@@@@@@@@B,LHB@YHB@ A XACQP-F0L@@@@@@@@ @@(RK"T H@@@BA,/LCD@L @@@@@@@@@@HB@ HB@ MP@@@QTTC@ 3@@@@@@@@@@@@@A$ HB@5@@@@
@CP\L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_??>O=?>GR_>G<_<_>_<O>_8G?_8C??0K<? G<?@C8\@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon3
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'MercurialSourceCodeManagementSettingsAppl class defaultIcon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<P@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AH:N#\7HP@O@BHIB@ HB@LFH0H@@@@ABS\:N#(:M0@!!A@@DB@ HCA0OI@8@@@@@M#(:@A\@@C\@@@XDB@ HBP8%I D@
@@@@M3 7A@$D@P@@@@8IB@ LC P''C0@@@C\7N#$:N0 HOA0@@@8LA@XA@Q<Y@0@@@@@7NS(7B@ <OC0@@@PCB" JC2T[@@@@@@@@M4@LBC0?O38<@@P)JB$I
J!!HA@@@@@@@@@B,LOC0=OC0<A XACQP-F0L@@@@@@@@<@@(RK"T<O@@@BA,/LCD@L @@@@@@@@@@OC0<OC0<MP@@@QTTC@ 3@@@@@@@@@@@@@C4<OC05@@@@
@CP\L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 174 169 169 255 255 255 233 233 230 216 216 216 213 209 209 214 209 209 232 229 229 229 223 223 191 187 181 197 197 197 255 255 255 233 230 230 194 189 194 247 244 245 251 250 250 177 177 177 255 255 255 194 189 194 155 149 149 175 175 169 157 157 157 136 128 128 251 251 251 255 255 255 117 108 108 118 118 118 97 89 98 139 139 147 240 240 242 255 255 255 137 128 118 98 98 98 79 79 79 255 255 255 156 149 156 38 30 30 39 39 30 97 89 79 79 69 69 58 49 49 255 255 255 255 255 255 77 59 59 229 226 223 137 137 128 79 79 69 77 69 69 59 59 59 59 49 59 154 140 147 199 199 204 251 251 251 255 255 255 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_??>O=?>GR_>G<_<_>_<O>_8G?_8C??0K<? G<?@C8\@@@@@');
                            yourself);
                yourself
        ]
! !

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MercurialSourceCodeManagementSettingsAppl andSelector:#windowSpec
     MercurialSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     MercurialSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Mercurial Settings'
         name: 'Mercurial Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 807 720)
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
                   style: (FontDescription #'Segoe UI' medium roman 16 #'ms-default' nil nil)
                   initiallyInvisible: true
                   foregroundColor: (Color 87.0 0.0 0.0)
                   translateLabel: true
                   extent: (Point 807 37)
                 )
                (ViewSpec
                   name: 'ManagerSetupBoxx'
                   component: 
                  (SpecCollection
                     collection: (
                      (FramedBoxSpec
                         label: 'Mercurial Sourcecode Manager Settings'
                         name: 'HGSetupBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         labelPosition: topLeft
                         translateLabel: true
                         component: 
                        (SpecCollection
                           collection: (
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
                                     label: 'HG Command:'
                                     name: 'Label1'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                     activeHelpKey: hgCommand
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'HGExecutableField'
                                     layout: (LayoutFrame 64 0.25 0 0 0 1 22 0)
                                     activeHelpKey: hgCommand
                                     tabable: true
                                     model: hgExecutableHolder
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
                                     label: 'Command Timeout:'
                                     name: 'Label2'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 22 0)
                                     activeHelpKey: hgCommandTimeout
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     layout: (LayoutFrame 64 0.25 0 0 168 0.25 22 0)
                                     activeHelpKey: hgCommandTimeout
                                     tabable: true
                                     model: hgCommandTimeoutHolder
                                     type: timeDuration
                                     acceptChannel: acceptChannel
                                     acceptOnPointerLeave: true
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'WorkDirectoryBox'
                               layout: (LayoutFrame 0 0.0 85 0 0 1 110 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (InputFieldSpec
                                     name: 'EntryField2'
                                     layout: (LayoutFrame 64 0.25 2 0 0 1 24 0)
                                     activeHelpKey: hgWorkingDirectory
                                     tabable: true
                                     model: workDirectoryHolder
                                     immediateAccept: true
                                     acceptOnLeave: true
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptChannel: acceptChannel
                                     acceptOnPointerLeave: true
                                   )
                                  (LabelSpec
                                     label: 'Working Directory:'
                                     name: 'Label9'
                                     layout: (LayoutFrame 0 0.0 2 0 60 0.25 24 0)
                                     activeHelpKey: hgWorkingDirectory
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'RepositoryBox'
                               layout: (LayoutFrame 0 0.0 120 0 0 1 145 0)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Default Repository:'
                                     name: 'defaultCvsRootLabel'
                                     layout: (LayoutFrame 0 0.0 2 0 60 0.25 24 0)
                                     activeHelpKey: hgRootDefault
                                     level: 0
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (ComboBoxSpec
                                     name: 'RepositoryComboBox'
                                     layout: (LayoutFrame 64 0.25 2 0 0 1 24 0)
                                     activeHelpKey: hgRootDefault
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
                               layout: (LayoutFrame -201 1 150 0 -101 1 172 0)
                               activeHelpKey: hgInit
                               translateLabel: true
                               tabable: true
                               model: initializeRepository
                               enableChannel: cvsLoginEnabled
                             )
                            (ActionButtonSpec
                               label: 'Check Access'
                               name: 'Button1'
                               layout: (LayoutFrame -100 1 150 0 0 1 172 0)
                               activeHelpKey: hgCheckAccess
                               translateLabel: true
                               tabable: true
                               model: checkAccess
                               enableChannel: cvsLoginEnabled
                             )
                            (LabelSpec
                               label: 'Repository per Module:'
                               name: 'knownModulesLabel'
                               layout: (LayoutFrame 0 0.0 178 0 60 0.25 200 0)
                               activeHelpKey: hgRootPerModule
                               translateLabel: true
                               adjust: right
                             )
                            (SequenceViewSpec
                               name: 'List1'
                               layout: (LayoutFrame 64 0.25 178 0 0 1 262 0)
                               activeHelpKey: hgRootPerModule
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
                               layout: (LayoutFrame 0 0.0 275 0 60 0.25 292 0)
                               activeHelpKey: hgRootPerModuleModule
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'ComboBox3'
                               layout: (LayoutFrame 64 0.25 271 0 0 1 293 0)
                               activeHelpKey: hgRootPerModuleModule
                               tabable: true
                               model: perModuleRepositoryModule
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: sampleModuleList
                             )
                            (LabelSpec
                               label: 'Mercurial Repository:'
                               name: 'hgRepository'
                               layout: (LayoutFrame 0 0.0 300 0 60 0.25 317 0)
                               activeHelpKey: hgRootPerModuleRoot
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'perModuleRepositoryComboBox'
                               layout: (LayoutFrame 64 0.25 296 0 0 1.0 318 0)
                               activeHelpKey: hgRootPerModuleRoot
                               tabable: true
                               model: perModuleRepository
                               immediateAccept: true
                               acceptOnLeave: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: repositoryPrototypeList
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel2'
                               layout: (LayoutFrame 0 0.0 323 0 0 1.0 348 0)
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
                                     activeHelpKey: hgLoginPerModuleRoot
                                     translateLabel: true
                                     tabable: true
                                     model: initializePerModuleRepository
                                     enableChannel: cvsLoginEnabled
                                     extent: (Point 100 22)
                                   )
                                  (ActionButtonSpec
                                     label: 'Check Access'
                                     name: 'checkButton2'
                                     activeHelpKey: hgCheckAccessPerModuleRoot
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
                   extent: (Point 807 384)
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
                         layout: (LayoutFrame 0 0.0 7 0 60 0.25 29 0)
                         activeHelpKey: hgPushURLs
                         translateLabel: true
                         adjust: right
                       )
                      (SequenceViewSpec
                         name: 'List2'
                         layout: (LayoutFrame 64 0.25 7 0 0 1 65 0)
                         activeHelpKey: hgPushURLs
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
                         layout: (LayoutFrame 0 0.0 79 0 60 0.25 96 0)
                         activeHelpKey: hgAddPushURL
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'ComboBox2'
                         layout: (LayoutFrame 64 0.25 75 0 0 1.0 97 0)
                         activeHelpKey: hgAddPushURL
                         tabable: true
                         model: pushURL
                         immediateAccept: true
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: pushURLPrototypeList
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel3'
                         layout: (LayoutFrame 64 0.25 103 0 -1 1 128 0)
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
                               activeHelpKey: hgAddPushURL
                               translateLabel: true
                               tabable: true
                               model: addPushURL
                               extent: (Point 100 22)
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'Button7'
                               activeHelpKey: hgRemovePushURL
                               translateLabel: true
                               tabable: true
                               model: removePushURL
                               enableChannel: removePushURLEnabled
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
                   extent: (Point 807 170)
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
                               extent: (Point 259 22)
                             )
                            (ActionButtonSpec
                               label: 'Condense Cache now'
                               name: 'CondenseCacheNowButton'
                               translateLabel: true
                               tabable: true
                               model: condenseSourceCache
                               extent: (Point 259 22)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 807 95)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ MercurialSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl methodsFor:'actions'!

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

    self sourceCacheDir value:(MercurialSourceCodeManager cacheDirectoryName).

    repository := MercurialSourceCodeManager repositoryName.
    self repositoryHolder value:(repository ? '') asValue.
    self workDirectoryHolder value:MercurialSourceCodeManager workDirectory.

    infoPerModule := MercurialSourceCodeManager repositoryInfoPerModule.
    infoPerModule keysAndValuesDo:[:module :info | 
        repositoriesPerModule at:module put:(Array with:MercurialSourceCodeManager with:info).
    ].

    self repositoryHolder value:MercurialSourceCodeManager repositoryName ? self class defaultRepositoryName.
    self hgExecutableHolder value:MercurialSourceCodeManager hgExecutable.
    self hgCommandTimeoutHolder value:MercurialSourceCodeManager hgCommandTimeout.
    self verboseSourceCodeAccess value:MercurialSourceCodeManager verboseSourceCodeAccess. 
    self shownInBrowserMenusHolder value:MercurialSourceCodeManager shownInBrowserMenus. 

    repositoriesPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:repositoriesPerModule keys asList.
    ].
"/    self selectedPerModuleRootChanged.

    "Modified: / 03-03-2012 / 11:11:54 / cg"
!

basicSaveSettings
    |modules nm fn infoPerModule|

    nm := self sourceCacheDir value.
    nm notEmptyOrNil ifTrue:[
        (fn := nm asFilename) exists ifFalse:[
            (self confirm:('Mercurial cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                fn recursiveMakeDirectory; 
                   makeReadableForAll;
                   makeWritableForAll;
                   makeExecutableForAll.
            ]
        ].
        (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
            MercurialSourceCodeManager cacheDirectoryName:nm.
        ] ifFalse:[
            self warn:'Invalid sourceCache directory.'
        ]
    ].

    MercurialSourceCodeManager hgCommandTimeout:(self hgCommandTimeoutHolder value).

    modules := repositoriesPerModule select:[:entry | entry first == MercurialSourceCodeManager].
    infoPerModule := Dictionary new.
    modules keysAndValuesDo:[:module :entry | 
        entry first == MercurialSourceCodeManager ifTrue:[
            infoPerModule at:module put:(entry second).
        ].
    ].
    MercurialSourceCodeManager repositoryInfoPerModule:infoPerModule.
    MercurialSourceCodeManager workDirectory:self workDirectoryHolder value.

    self basicSaveMercurialSettings.

    self sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).

    DebugView newDebugger. "/ ???

    self acceptChannel value.

    "Modified: / 03-03-2012 / 11:24:56 / cg"
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

!MercurialSourceCodeManagementSettingsAppl methodsFor:'actions - mercurial'!

addPerModuleRoot
    |module hgRepository|

    acceptChannel value:true.    

    module := self perModuleRepositoryModule value.
    hgRepository := self perModuleRepository value.

    hgRepository size > 0 ifTrue:[
        self addModule:module withData:(Array with:MercurialSourceCodeManager with:hgRepository).
    ].

    "Modified: / 26-01-2012 / 12:29:36 / cg"
!

basicSaveMercurialSettings
    |hgRepository|

    repositoryHolder notNil ifTrue:[
        repositoryHolder value size > 0 ifTrue:[
            manager notNil ifTrue:[
                manager initializeForRepository:repositoryHolder value.
            ]
        ].
    ].
    MercurialSourceCodeManager hgExecutable:((self hgExecutableHolder value ? '') withoutSeparators).
    MercurialSourceCodeManager initializeForRepository:(hgRepository := self repositoryHolder value).
    MercurialSourceCodeManager verboseSourceCodeAccess: verboseSourceCodeAccess value. 
    MercurialSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    RecentlyUsedRepositoryURLS isNil ifTrue:[
        RecentlyUsedRepositoryURLS := OrderedCollection new.
    ].
    (RecentlyUsedRepositoryURLS includes:hgRepository) ifFalse:[
        RecentlyUsedRepositoryURLS addFirst:hgRepository.
        RecentlyUsedRepositoryURLS size > 20 ifTrue:[
            RecentlyUsedRepositoryURLS removeLast.
        ].
    ].

    "Modified: / 10-01-2012 / 00:18:15 / cg"
    "Created: / 14-01-2012 / 20:01:47 / cg"
!

checkAccess
    self halt:'unimplemented feature'

    "Created: / 17-01-2012 / 17:34:53 / cg"
!

initializePerModuleRepository
    |directory|

    directory := perModuleRepository value.
    directory asFilename exists ifFalse:[
        directory asFilename recursiveMakeDirectory.
    ].
    OperatingSystem executeCommand:'hg init' inDirectory:directory onError:[self halt].
    self halt:'unimplemented feature'

    "Created: / 31-07-2013 / 19:12:08 / cg"
!

initializeRepository
    self halt:'unimplemented feature'

    "Created: / 17-01-2012 / 17:42:27 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl methodsFor:'aspects'!

hgCommandTimeoutHolder
    hgCommandTimeoutHolder isNil ifTrue:[
        hgCommandTimeoutHolder := ValueHolder new.
        hgCommandTimeoutHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ hgCommandTimeoutHolder.

    "Created: / 14-01-2012 / 20:02:13 / cg"
!

hgExecutableHolder
    hgExecutableHolder isNil ifTrue:[
        hgExecutableHolder := ValueHolder new.
        hgExecutableHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ hgExecutableHolder.

    "Created: / 14-01-2012 / 20:02:22 / cg"
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

    "Created: / 02-03-2012 / 16:22:13 / cg"
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

        prototypeList add:(Filename currentDirectory / 'hgRepository') name.
        prototypeList add:(Filename currentDirectory / '.hgRepository') name.
        prototypeList add:(OperatingSystem getHomeDirectory asFilename / 'hgRepository') pathName.
        prototypeList add:(OperatingSystem getHomeDirectory asFilename / '.smalltalk' / 'hgRepository') pathName.
        prototypeList add:('https://inst.kilnhg.com/Repo/Foo/Bar/Baz').
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

    "Created: / 02-03-2012 / 15:52:09 / cg"
!

workDirectoryHolder
    workDirectoryHolder isNil ifTrue:[
        workDirectoryHolder := ValueHolder new.
        workDirectoryHolder addDependent:self.
    ].
    ^ workDirectoryHolder.

    "Created: / 03-03-2012 / 10:34:19 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl methodsFor:'change & update'!

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
    (entry first = MercurialSourceCodeManager) ifTrue:[
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

!MercurialSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_MercurialSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/mercurialRepositorySetup.html'

    "Modified: / 31-07-2013 / 19:39:17 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    repositoriesPerModule := Dictionary new.

    MercurialSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            repositoriesPerModule at:module put:(Array with:MercurialSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 17-01-2012 / 17:39:13 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    |modules|

    ((MercurialSourceCodeManager cacheDirectoryName ? '') ~= (self sourceCacheDir value ? '')) ifTrue:[^ true].

    modules := repositoriesPerModule select:[:entry | entry first == MercurialSourceCodeManager].

    MercurialSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((modules includesKey:module) and:[info = (modules at:module) second])
        ifFalse:[^ true].
    ].   
    modules keysAndValuesDo:[:module :info|
        ((MercurialSourceCodeManager repositoryInfoPerModule includesKey:module) 
            and:[(MercurialSourceCodeManager repositoryInfoPerModule at:module) = info second])
        ifFalse:[^ true].
    ].
    (MercurialSourceCodeManager hgCommandTimeout ~= hgCommandTimeoutHolder value)
        ifTrue:[^ true].

    ((MercurialSourceCodeManager hgExecutable ? '') ~= (self hgExecutableHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].

    (MercurialSourceCodeManager repositoryName ? self class defaultRepositoryName ~= self repositoryHolder value)    
        ifTrue:[^ true].

    (MercurialSourceCodeManager verboseSourceCodeAccess ~= self verboseSourceCodeAccess value) 
        ifTrue:[^ true].

    (MercurialSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    ^ false

    "Modified: / 14-01-2012 / 23:41:33 / cg"
! !

!MercurialSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

