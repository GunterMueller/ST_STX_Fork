"
 COPYRIGHT (c) 2011 by eXept Software AG
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

AbstractSourceCodeManagementSettingsAppl subclass:#StoreSourceCodeManagementSettingsAppl
	instanceVariableNames:'useManager repositoryHolder manager addPerModuleRoot
		perModuleRootModule perModuleRoot selectedPerModuleRoot
		rootsPerModule managerIsCVSSourceCodeManager
		managerIsStoreSourceCodeManager storeLoginEnabled
		storeHostPrototypeList storeHostnameHolder storeUsernameHolder
		storePasswordHolder perStoreModuleHostnameHolder
		perStoreModuleUsernameHolder perStoreModulePasswordHolder
		perStoreModuleRoot perStoreModuleRootModule
		selectedPerStoreModuleRoot storeConnectEnabled
		storeConnectInModuleEnabled perModuleFieldsEnableHolder
		managerIsSmallTeamSourceCodeManager
		perSmallTeamModuleFieldsEnableHolder'
	classVariableNames:'RecentlyUsedStoreHosts LastStoreHost LastStoreUser
		LastStorePassword'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!StoreSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    Store (visualWorks repository access) source code settings - highly experimental and unsupported.  
"
! !

!StoreSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'StoreSourceCodeManagementSettingsAppl class defaultIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BFFH=<AS8@@@@@@@@@@@@@
@@@@@E8=X(!!#T!!0-X@D@@@@@@@@@@@@@@C%%CC@K"B9SUF$QR@@@@@@@@@@@@@A[K00LL@.H]P%SGUUZ@@@@@@@@@@@@R"$<F&P0B8]ONGECQ @@@@@@@@@@
@BX[G7X, T$BIR)(^E @@@@@@@@@@@A?F4T''[F]@XXNDZFYX@@@@@@@@@@@@Z9VU$)I''PFFC!!H.IV@@@@@@@@@@@@IJU%YVU$$@+["P1N$X@@@@@@@@@@IFU
%P"ESQBR^3LTHG&N@@@@@@@@@@BR$9IEI61''PFFC!!F!!VZ @@@@@@@IJR%YRU%"],%4A!! 8Q(G% @@@@@@@@@$)RU$$T''%9^WXXNDQDIX@@@@@@@@@@BR&0<G
%9*Z&Y]]D 9P# @@@@@@@@@@@@AG%9^X%9^WH49AU50@@@@@@@@@%0@@@HA>%9^L#BEF_(@@@@@@@@@@@@BW%9^W%9^P@@@@@@@@@@@@@@@@@@@@@I"W%9^P
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 219 185 65 198 168 74 219 190 79 243 243 243 247 247 247 212 188 103 224 198 109 222 200 122 234 215 144 254 223 141 240 223 165 253 234 173 253 237 183 241 231 193 188 151 42 211 174 48 191 161 59 254 242 210 208 176 66 242 239 229 220 189 76 242 242 242 245 245 245 255 255 255 222 198 111 244 220 117 237 216 141 255 233 149 254 227 155 250 228 170 196 152 26 252 239 190 253 238 192 212 212 212 249 242 210 207 171 55 211 178 65 225 194 72 230 197 74 255 251 236 250 248 244 231 203 98 246 219 105 245 221 117 227 210 143 241 216 146 253 228 154 249 232 171 253 237 182 174 139 37 239 228 192 202 168 50 209 174 52 210 173 51 214 179 60 222 188 68 210 174 70 224 193 81 208 180 89 254 254 254 225 200 105 232 208 118 220 202 138 252 229 143 252 235 160 205 200 181 186 147 30 202 156 27 251 235 189 255 244 201 216 216 216 233 228 211 193 161 65 207 177 72 230 197 73 252 249 237 252 251 244 208 183 100 213 188 101 231 202 112 206 189 131 252 230 145 254 225 148 254 228 160 254 233 176 187 149 35 198 153 27 211 211 211 215 215 215 248 241 209 225 225 225 223 192 70 231 231 231 231 201 81 225 195 86 253 253 253 219 192 114 251 228 125 243 221 145 253 226 149 247 229 168 252 236 180 201 155 26 253 243 195 255 240 196 255 239 199 217 217 217 220 185 61 254 249 224 223 188 69 232 203 81 244 244 244 252 252 252 211 183 100 236 208 111 227 205 125 252 230 144 253 226 148 236 222 171 197 156 25 202 156 26 190 149 32 187 154 48 197 165 54 203 172 59 215 179 59 224 224 224 228 196 72 236 236 236 210 184 89 249 249 249 250 223 100 251 225 111 217 194 122 233 215 148 246 222 149 253 230 161 186 145 25 200 158 27 251 236 189 209 209 209 205 168 48 218 218 218 208 177 64 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@O0@@?<@A?>@A??@A??@A??@A??@A??@A??@C??@C??@O??@G??@C??@@??@D_>@C>@@A<@@@@@@');
                            yourself);
                yourself
        ]
! !

!StoreSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:StoreSourceCodeManagementSettingsAppl andSelector:#windowSpec
     StoreSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     StoreSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Source Code Manager Settings'
         name: 'Source Code Manager Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 670 514)
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
                   label: 'Experimental (Only for Transport)'
                   name: 'Label10'
                   style: (FontDescription #'Segoe UI' medium roman 16 #'ms-default' nil nil)
                   foregroundColor: (Color 87.0 0.0 0.0)
                   translateLabel: true
                   extent: (Point 670 37)
                 )
                (FramedBoxSpec
                   label: 'Store-DB Source Repository Settings'
                   name: 'StoreSetupBox'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ComboBoxSpec
                         name: 'ComboBox1'
                         layout: (LayoutFrame 44 0.25 222 0 0 1 244 0)
                         tabable: true
                         model: perStoreModuleRoot
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
                         name: 'HostBox'
                         layout: (LayoutFrame 0 0 40 0 0 1 65 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'DB or DB@Host:'
                               name: 'StoreHostLabel'
                               layout: (LayoutFrame 0 0.0 0 0 40 0.25 22 0)
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'StoreHostComboBox'
                               layout: (LayoutFrame 44 0.25 0 0 0 1 22 0)
                               tabable: true
                               model: storeHostnameHolder
                               immediateAccept: true
                               acceptOnLeave: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: storeHostPrototypeList
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'UserBox'
                         layout: (LayoutFrame 0 0.0 67 0 0 1 92 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Username:'
                               name: 'StoreUserLabel'
                               layout: (LayoutFrame 0 0.0 0 0 40 0.25 22 0)
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'StoreUserEntryField'
                               layout: (LayoutFrame 44 0.25 0 0 0 1 22 0)
                               tabable: true
                               model: storeUsernameHolder
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'PasswordBox'
                         layout: (LayoutFrame 0 0.0 94 0 0 1 119 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Password:'
                               name: 'Label7'
                               layout: (LayoutFrame 0 0.0 0 0 40 0.25 22 0)
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'PasswordEntryField'
                               layout: (LayoutFrame 44 0.25 0 0 -130 1 22 0)
                               tabable: true
                               model: storePasswordHolder
                               type: password
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel4'
                         layout: (LayoutFrame -130 1 91 0 0 1 122 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Try to Connect'
                               name: 'TryConnectButton1'
                               translateLabel: true
                               tabable: true
                               model: storeConnect
                               enableChannel: storeConnectEnabled
                               extent: (Point 122 22)
                             )
                            )
                          
                         )
                       )
                      (LabelSpec
                         label: 'DB per Module:'
                         name: 'Label4'
                         layout: (LayoutFrame 0 0.0 122 0 40 0.25 144 0)
                         translateLabel: true
                         adjust: right
                       )
                      (SequenceViewSpec
                         name: 'List2'
                         layout: (LayoutFrame 44 0.25 122 0 0 1 220 0)
                         tabable: true
                         model: selectedPerStoreModuleRoot
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         useIndex: false
                         sequenceList: listOfModules
                       )
                      (LabelSpec
                         label: 'Module:'
                         name: 'perModuleModuleLabel'
                         layout: (LayoutFrame 0 0.0 226 0 40 0.25 243 0)
                         translateLabel: true
                         adjust: right
                       )
                      (LabelSpec
                         label: 'DB:'
                         name: 'perModuleDBLabel'
                         layout: (LayoutFrame 0 0.0 251 0 40 0.25 268 0)
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'perModuleModuleHostComboBox2'
                         layout: (LayoutFrame 44 0.25 247 0 0 1 269 0)
                         tabable: true
                         model: perStoreModuleHostnameHolder
                         immediateAccept: true
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: storeHostPrototypeList
                       )
                      (LabelSpec
                         label: 'User / Password:'
                         name: 'perModuleUserPasswordLabel'
                         layout: (LayoutFrame 0 0.0 276 0 40 0.25 293 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'perModuleUserEntryField'
                         layout: (LayoutFrame 44 0.25 272 0 -2 0.65000000000000013 294 0)
                         tabable: true
                         model: perStoreModuleUsernameHolder
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                       )
                      (InputFieldSpec
                         name: 'perModulePasswordEntryField'
                         layout: (LayoutFrame 5 0.65000000000000013 272 0 0 1 294 0)
                         tabable: true
                         model: perStoreModulePasswordHolder
                         type: password
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel5'
                         layout: (LayoutFrame 44 0.25 298 0 -5 0.65000000000000013 329 0)
                         horizontalLayout: fit
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Add/Apply'
                               name: 'AddButton2'
                               translateLabel: true
                               resizeForLabel: true
                               tabable: true
                               model: addPerStoreModuleDB
                               extent: (Point 97 27)
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'RemoveButton3'
                               translateLabel: true
                               tabable: true
                               model: removePerStoreModuleDB
                               enableChannel: removeEnabled
                               extent: (Point 98 27)
                             )
                            )
                          
                         )
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel6'
                         layout: (LayoutFrame 5 0.65000000000000013 298 0 0 1 329 0)
                         horizontalLayout: fit
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Try Connect'
                               name: 'ConnectPerStoreModuleButton'
                               translateLabel: true
                               tabable: true
                               model: connectPerStoreModuleDB
                               enableChannel: storeConnectInModuleEnabled
                               extent: (Point 103 27)
                             )
                            (ActionButtonSpec
                               label: 'Browse'
                               name: 'BrowsePerStoreModuleButton'
                               translateLabel: true
                               tabable: true
                               model: browsePerStoreModuleDB
                               enableChannel: storeConnectInModuleEnabled
                               extent: (Point 104 27)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 670 365)
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
                               enableChannel: useManager
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
                               enableChannel: useManager
                               extent: (Point 206 22)
                             )
                            (ActionButtonSpec
                               label: 'Condense Cache now'
                               name: 'CondenseCacheNowButton'
                               translateLabel: true
                               tabable: true
                               model: condenseSourceCache
                               enableChannel: useManager
                               extent: (Point 206 22)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 670 95)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!StoreSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ StoreSourceCodeManager

    "Created: / 19-04-2011 / 12:48:57 / cg"
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    rootsPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

basicReadSettings
    self initialize.

    self sourceCacheDir value:(StoreSourceCodeManager cacheDirectoryName).

    "/ StoreSourceCodeManager forgetDisabledModules.
    self storeHostnameHolder value: (StoreSourceCodeManager hostAndDBName).
    self storeUsernameHolder value: (StoreSourceCodeManager userName).
    self storePasswordHolder value: (StoreSourceCodeManager password).
    self shownInBrowserMenusHolder value:StoreSourceCodeManager shownInBrowserMenus. 

    (Array with:StoreSourceCodeManager) "self availableManagers" do:[:eachManager |
        |infoPerModule|

        infoPerModule := eachManager repositoryInfoPerModule.
        infoPerModule keysAndValuesDo:[:module :info | 
            rootsPerModule at:module put:(Array with:eachManager with:info).
        ].
    ].

    "/ self updateSelectedManager.

    rootsPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:rootsPerModule keys asList.
    ].
"/    self selectedPerModuleRootChanged.

    "Modified: / 10-01-2012 / 00:21:13 / cg"
!

basicSaveSettings
    |modules nm fn infoPerModule|

    nm := self sourceCacheDir value.
    nm notEmptyOrNil ifTrue:[
        (fn := nm asFilename) exists ifFalse:[
            (self confirm:('Cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                fn recursiveMakeDirectory; 
                   makeReadableForAll;
                   makeWritableForAll;
                   makeExecutableForAll.
            ]
        ].
        (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
            StoreSourceCodeManager cacheDirectoryName:nm.
        ] ifFalse:[
            self warn:'Invalid sourceCache directory.'
        ]
    ].

    modules := rootsPerModule select:[:entry | entry first == StoreSourceCodeManager].
    infoPerModule := Dictionary new.
    modules keysAndValuesDo:[:module :entry | 
        entry first == StoreSourceCodeManager ifTrue:[
            infoPerModule at:module put:(entry second).
        ].
    ].
    StoreSourceCodeManager repositoryInfoPerModule:infoPerModule.

    StoreSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    self basicSaveStoreSettings.

    self sourceCacheDir value:(StoreSourceCodeManager cacheDirectoryName).

    DebugView newDebugger. "/ ???

    self acceptChannel value.

    "Modified: / 10-01-2012 / 00:22:56 / cg"
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
!

setupSourceCodeManager

   AbstractLauncherApplication::LauncherDialogs cvsConfigurationDialog.
   manager := (Smalltalk at:#SourceCodeManager).
   manager notNil ifTrue:[
        repositoryHolder value: manager repositoryName.
        sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).
   ].

    "Modified: / 16-08-2006 / 11:07:51 / cg"
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'actions - store'!

addPerStoreModuleDB
    |module info|

    acceptChannel value:true.    

    module := self perStoreModuleRoot value.
    info := StoreSourceCodeManager newDBInfo.
    info hostAndDBName:perStoreModuleHostnameHolder value.
    info userName:perStoreModuleUsernameHolder value.
    info password:perStoreModulePasswordHolder value.

    self addModule:module withData:(Array with:StoreSourceCodeManager with:info).

    "Modified: / 08-11-2006 / 19:27:35 / cg"
!

basicSaveStoreSettings
    |storeHost|

    self storeHostnameHolder value notEmptyOrNil ifTrue:[
        StoreSourceCodeManager hostAndDBName:(storeHost := self storeHostnameHolder value withoutSeparators).
        StoreSourceCodeManager userName:(self storeUsernameHolder value withoutSeparators).
        StoreSourceCodeManager password:(self storePasswordHolder value withoutSeparators).
    ].

    storeHost notEmptyOrNil ifTrue:[
        StoreSourceCodeManager connectToDatabase.
    ].

    RecentlyUsedStoreHosts isNil ifTrue:[
        RecentlyUsedStoreHosts := OrderedCollection new.
    ].
    (RecentlyUsedStoreHosts includes:storeHost) ifFalse:[
        RecentlyUsedStoreHosts addFirst:storeHost.
        RecentlyUsedStoreHosts size > 20 ifTrue:[
            RecentlyUsedStoreHosts removeLast.
        ].
    ].

    "Modified: / 10-01-2012 / 00:32:42 / cg"
!

browsePerStoreModuleDB
    |testInfo|

    testInfo := StoreSourceCodeManager newDBInfo.
    testInfo hostAndDBName:(perStoreModuleHostnameHolder value).
    testInfo userName:(perStoreModuleUsernameHolder value).
    testInfo password:(perStoreModulePasswordHolder value).
    self browseStoreDB:testInfo
!

browseStoreDB:dbInfo
    Tools::StoreProjectBrowser openOn:dbInfo
!

connectPerStoreModuleDB
    |testInfo|

    testInfo := StoreSourceCodeManager newDBInfo.
    testInfo hostAndDBName:(perStoreModuleHostnameHolder value).
    testInfo userName:(perStoreModuleUsernameHolder value).
    testInfo password:(perStoreModulePasswordHolder value).

    (self tryToConnectTo:testInfo)
!

storeConnect
    |testInfo|

    testInfo := StoreSourceCodeManager newDBInfo.
    testInfo hostAndDBName:(storeHostnameHolder value).
    testInfo userName:(storeUsernameHolder value).
    testInfo password:(storePasswordHolder value).

    (self tryToConnectTo:testInfo) ifTrue:[
        LastStoreHost := storeHostnameHolder value.
        LastStoreUser := storeUsernameHolder value.
        LastStorePassword := storePasswordHolder value.
    ].
!

tryToConnectTo:dbInfo
    |session|

    SQL::SQLError handle:[:ex |
        self warn:('Failed to connect to Database:\\' withCRs,ex description).
        ^ false.
    ] do:[
        self withWaitCursorDo:[
            session := StoreSourceCodeManager tryToConnectToDatabase:dbInfo.
        ]
    ].
    session isNil ifTrue:[
        self warn:'OOPS - Failed to connect'.
        ^ false.
    ].

    self information:('Successfully connected to ',dbInfo dbName,'.').
    session disconnect.
    ^ true
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.
!

initialListOfModules
    ^ rootsPerModule keys asList sort.

    "Created: / 02-03-2012 / 14:42:39 / cg"
!

managerIsCVSSourceCodeManager
    managerIsCVSSourceCodeManager isNil ifTrue:[
        managerIsCVSSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isCVS]) asValue.
    ].
    ^ managerIsCVSSourceCodeManager.

    "Created: / 16-08-2006 / 10:56:38 / cg"
!

managerIsSmallTeamSourceCodeManager
    managerIsSmallTeamSourceCodeManager isNil ifTrue:[
        managerIsSmallTeamSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isSmallTeam]) asValue.
    ].
    ^ managerIsSmallTeamSourceCodeManager.

    "Created: / 09-11-2006 / 14:33:53 / cg"
!

managerIsStoreSourceCodeManager
    managerIsStoreSourceCodeManager isNil ifTrue:[
        managerIsStoreSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isStore]) asValue.
    ].
    ^ managerIsStoreSourceCodeManager.

    "Created: / 16-08-2006 / 10:57:13 / cg"
!

perModuleFieldsEnableHolder

    perModuleFieldsEnableHolder isNil ifTrue:[
        perModuleFieldsEnableHolder := true asValue.
        perModuleFieldsEnableHolder addDependent:self.
    ].
    ^ perModuleFieldsEnableHolder.
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

perStoreModuleFieldsEnableHolder

    perSmallTeamModuleFieldsEnableHolder isNil ifTrue:[
        perSmallTeamModuleFieldsEnableHolder := true asValue.
        perSmallTeamModuleFieldsEnableHolder addDependent:self.
    ].
    ^ perSmallTeamModuleFieldsEnableHolder.
!

perStoreModuleHostnameHolder

    perStoreModuleHostnameHolder isNil ifTrue:[
        perStoreModuleHostnameHolder := '' asValue.
        perStoreModuleHostnameHolder addDependent:self.
    ].
    ^ perStoreModuleHostnameHolder.
!

perStoreModulePasswordHolder

    perStoreModulePasswordHolder isNil ifTrue:[
        perStoreModulePasswordHolder := '' asValue.
        perStoreModulePasswordHolder addDependent:self.
    ].
    ^ perStoreModulePasswordHolder.
!

perStoreModuleRoot
    perStoreModuleRoot isNil ifTrue:[
        perStoreModuleRoot := ValueHolder new.
        perStoreModuleRoot addDependent:self.
    ].
    ^ perStoreModuleRoot.
!

perStoreModuleRootModule
    perStoreModuleRootModule isNil ifTrue:[
        perStoreModuleRootModule := ValueHolder new.
    ].
    ^ perStoreModuleRootModule.
!

perStoreModuleUsernameHolder

    perStoreModuleUsernameHolder isNil ifTrue:[
        perStoreModuleUsernameHolder := '' asValue.
        perStoreModuleUsernameHolder addDependent:self.
    ].
    ^ perStoreModuleUsernameHolder.
!

selectedPerModuleRoot
    selectedPerModuleRoot isNil ifTrue:[
        selectedPerModuleRoot := ValueHolder new.
        selectedPerModuleRoot addDependent:self.
    ].
    ^ selectedPerModuleRoot.
!

selectedPerStoreModuleRoot
    selectedPerStoreModuleRoot isNil ifTrue:[
        selectedPerStoreModuleRoot := ValueHolder new.
        selectedPerStoreModuleRoot addDependent:self.
    ].
    ^ selectedPerStoreModuleRoot.
!

storeConnectEnabled
    storeConnectEnabled isNil ifTrue:[
        storeConnectEnabled := false asValue.
    ].
    ^ storeConnectEnabled.
!

storeConnectInModuleEnabled
    storeConnectInModuleEnabled isNil ifTrue:[
        storeConnectInModuleEnabled := false asValue.
    ].
    ^ storeConnectInModuleEnabled.
!

storeHostPrototypeList
    |prototypeList|

    storeHostPrototypeList isNil ifTrue:[
        prototypeList := OrderedSet new.

        prototypeList add:('public@store.smalltalk-x.de:5432').
        prototypeList add:('public').
        prototypeList add:('stx').

        OperatingSystem getLoginName = 'cg' ifTrue:[
            prototypeList add:('oyster@store.smalltalk-x.de:5432').
            prototypeList add:('oyster').
        ].

        OperatingSystem getDomainName = 'exept.de' ifTrue:[
            prototypeList add:('stx@exept.exept.de:5432').
        ] ifFalse:[
            prototypeList add:('db@host').
            prototypeList add:('db@host:port').
        ].
        storeHostPrototypeList := prototypeList asOrderedCollection.
    ].
    ^ storeHostPrototypeList.
!

storeHostnameHolder

    storeHostnameHolder isNil ifTrue:[
        storeHostnameHolder := ("LastStoreHost ?" '') asValue.
        storeHostnameHolder addDependent:self.
    ].
    ^ storeHostnameHolder.
!

storeLoginEnabled
    storeLoginEnabled isNil ifTrue:[
        storeLoginEnabled := false asValue.
    ].
    ^ storeLoginEnabled.

    "Created: / 16-08-2006 / 11:11:15 / cg"
!

storePasswordHolder

    storePasswordHolder isNil ifTrue:[
        storePasswordHolder := ("LastStorePassword ?" '') asValue.
        storePasswordHolder addDependent:self.
    ].
    ^ storePasswordHolder.
!

storeUsernameHolder

    storeUsernameHolder isNil ifTrue:[
        storeUsernameHolder := ("LastStoreUser ?" '') asValue.
        storeUsernameHolder addDependent:self.
    ].
    ^ storeUsernameHolder.
!

useManager
    useManager isNil ifTrue:[
        useManager := ValueHolder new.
        useManager onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useManager.
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'change & update'!

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

selectedPerStoreModuleRootChanged
    |module entry|

    self acceptChannel value:true.    

    module := self selectedPerStoreModuleRoot value.
    module isNil ifTrue:[ 
        self removeEnabled value:false.
        self perStoreModuleRoot value:''.
        self perStoreModuleHostnameHolder value:''.
        self perStoreModuleUsernameHolder value:''.
        self perStoreModulePasswordHolder value:''.
        ^ self
    ].

    entry := rootsPerModule at:module ifAbsent:#().    
    (entry first = StoreSourceCodeManager) ifTrue:[
        self removeEnabled value:true.
        self perStoreModuleRoot value:module.
        self perStoreModuleHostnameHolder value:(entry at:2) hostAndDBName.
        self perStoreModuleUsernameHolder value:(entry at:2) userName.
        self perStoreModulePasswordHolder value:(entry at:2) password.
    ] ifFalse:[
        self removeEnabled value:false.
        self perStoreModuleRoot value:module , ' ',('<<use ',entry first managerTypeName,'>>') allBold.
        self perStoreModuleHostnameHolder value:''.
        self perStoreModuleUsernameHolder value:''.
        self perStoreModulePasswordHolder value:''.
    ].
!

update:something with:aParameter from:changedObject 
    "/ store
    changedObject == storeHostnameHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == storeUsernameHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == storePasswordHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == perStoreModuleRoot ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == perStoreModuleHostnameHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == perStoreModuleUsernameHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == perStoreModulePasswordHolder ifTrue:[
        self updateConnectEnableHolders.
        ^ self
    ].
    changedObject == selectedPerStoreModuleRoot ifTrue:[
        self selectedPerStoreModuleRootChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 24-07-2012 / 15:45:26 / cg"
!

updateConnectEnableHolders
    self storeConnectEnabled 
        value:(storeHostnameHolder value notEmptyOrNil
               and:[ storeUsernameHolder value notEmptyOrNil
               and:[ storePasswordHolder value notEmptyOrNil ]]).

    self storeConnectInModuleEnabled 
        value:(perStoreModuleHostnameHolder value notEmptyOrNil
               and:[ perStoreModuleUsernameHolder value notEmptyOrNil
               and:[ perStoreModulePasswordHolder value notEmptyOrNil ]]).
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_StoreDBSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/storeDBSetup.html'

    "Modified: / 05-08-2011 / 09:20:28 / cg"
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    useManager := false asValue.
    useManager onChangeSend:#updateModifiedChannel to:self.

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    repositoryHolder := '' asValue.
    rootsPerModule := Dictionary new.

    StoreSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            rootsPerModule at:module put:(Array with:StoreSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 14-01-2012 / 20:28:30 / cg"
! !

!StoreSourceCodeManagementSettingsAppl methodsFor:'queries'!

cvsRootFromCVSRootFileOrNil
    |cvsDir cvsRootFile cvsRoot|

    cvsDir := 'CVS' asFilename.
    cvsDir isDirectory ifTrue:[
        cvsRootFile := cvsDir construct:'Root'.
        cvsRootFile isReadable ifTrue:[
            cvsRoot := cvsRootFile contents firstIfEmpty:nil.
        ].
    ].
    ^ cvsRoot
!

hasManager
    "true if ANY source code management class is available"

    ^ AbstractSourceCodeManager notNil and:[AbstractSourceCodeManager isLoaded]
!

hasUnsavedChanges
    ((StoreSourceCodeManager cacheDirectoryName ? '') ~= (self sourceCacheDir value ? '')) ifTrue:[^ true].

    (StoreSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    (Array with:StoreSourceCodeManager) "self availableManagers" do:[:mgr |
        |modules|

        modules := rootsPerModule select:[:entry | entry first == mgr].

        mgr repositoryInfoPerModule keysAndValuesDo:[:module :info |
            ((modules includesKey:module) and:[info = (modules at:module) second])
            ifFalse:[^ true].
        ].
        modules keysAndValuesDo:[:module :info|
            ((mgr repositoryInfoPerModule includesKey:module) and:[(mgr repositoryInfoPerModule at:module) = info second])
            ifFalse:[^ true].
        ].
    ].

    ((StoreSourceCodeManager hostAndDBName ? '') ~= (self storeHostnameHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].
    ((StoreSourceCodeManager userName ? '') ~= (self storeUsernameHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].
    ((StoreSourceCodeManager password ? '') ~= (self storePasswordHolder value ? '') withoutSeparators)  
        ifTrue:[^ true].
            
    ^ false

    "Modified: / 10-01-2012 / 00:31:49 / cg"
! !

!StoreSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

