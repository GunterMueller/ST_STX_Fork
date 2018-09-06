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

AbstractSourceCodeManagementSettingsAppl subclass:#DataBaseSourceCodeManagementSettingsAppl
	instanceVariableNames:'pathPerModule dbNameHolder selectedPerModuleDatabase
		perModuleDatabaseModule perModuleDB dbPerModule'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

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
    This settings app controls the parameters of the DataBaseSourceCodeManager.
"
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'defaults'!

defaultTableName

    ^ 'stx_versions'

    "Created: / 21-12-2011 / 23:43:04 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:DataBaseSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#defaultDBName
'Default database; used for all modules which are not listed below'

#perModuleDB
'Per module database configuration'

#perModuleDBModule
'The module for which a specific database is defined'

#perModuleDBName
'Database for the selected module (scheme:[user[.password]@hostname:databaseName[.tableName]'

)

    "Created: / 25-12-2011 / 13:46:07 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DataBaseSourceCodeManagementSettingsAppl class defaultIcon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BFFH=<AS8@@@@@@@@@@@@@
@@@@@E8=X(!!#T!!0-X@D@@@@@@@@@@@@@@C%%CC@K"B9SUF$QR@@@@@@@@@@@@@A[K00LL@.H]P%SGUUZ@@@@@@@@@@@@R"$<F&P0B8]ONGECQ @@@@@@@@@@
@BX[G7X, T$BIR)(^E @@@@@@@@@@@A?F4T''[F]@XXNDZFYX@@@@@@@@@@@@Z9VU$)I''PFFC!!H.IV@@@@@@@@@@@@IJU%YVU$$@+["P1N$X@@@@@@@@@@IFU
%P"ESQBR^3LTHG&N@@@@@@@@@@BR$9IEI61''PFFC!!F!!VZ @@@@@@@IJR%YRU%"],%4A!! 8Q(G% @@@@@@@@@$)RU$$T''%9^WXXNDQDIX@@@@@@@@@@BR&0<G
%9*Z&Y]]D 9P# @@@@@@@@@@@@AG%9^X%9^WH49AU50@@@@@@@@@%0@@@HA>%9^L#BEF_(@@@@@@@@@@@@BW%9^W%9^P@@@@@@@@@@@@@@@@@@@@@I"W%9^P
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[219 185 65 198 168 74 219 190 79 243 243 243 247 247 247 212 188 103 224 198 109 222 200 122 234 215 144 254 223 141 240 223 165 253 234 173 253 237 183 241 231 193 188 151 42 211 174 48 191 161 59 254 242 210 208 176 66 242 239 229 220 189 76 242 242 242 245 245 245 255 255 255 222 198 111 244 220 117 237 216 141 255 233 149 254 227 155 250 228 170 196 152 26 252 239 190 253 238 192 212 212 212 249 242 210 207 171 55 211 178 65 225 194 72 230 197 74 255 251 236 250 248 244 231 203 98 246 219 105 245 221 117 227 210 143 241 216 146 253 228 154 249 232 171 253 237 182 174 139 37 239 228 192 202 168 50 209 174 52 210 173 51 214 179 60 222 188 68 210 174 70 224 193 81 208 180 89 254 254 254 225 200 105 232 208 118 220 202 138 252 229 143 252 235 160 205 200 181 186 147 30 202 156 27 251 235 189 255 244 201 216 216 216 233 228 211 193 161 65 207 177 72 230 197 73 252 249 237 252 251 244 208 183 100 213 188 101 231 202 112 206 189 131 252 230 145 254 225 148 254 228 160 254 233 176 187 149 35 198 153 27 211 211 211 215 215 215 248 241 209 225 225 225 223 192 70 231 231 231 231 201 81 225 195 86 253 253 253 219 192 114 251 228 125 243 221 145 253 226 149 247 229 168 252 236 180 201 155 26 253 243 195 255 240 196 255 239 199 217 217 217 220 185 61 254 249 224 223 188 69 232 203 81 244 244 244 252 252 252 211 183 100 236 208 111 227 205 125 252 230 144 253 226 148 236 222 171 197 156 25 202 156 26 190 149 32 187 154 48 197 165 54 203 172 59 215 179 59 224 224 224 228 196 72 236 236 236 210 184 89 249 249 249 250 223 100 251 225 111 217 194 122 233 215 148 246 222 149 253 230 161 186 145 25 200 158 27 251 236 189 209 209 209 205 168 48 218 218 218 208 177 64 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@O0@@?<@A?>@A??@A??@A??@A??@A??@A??@C??@C??@O??@G??@C??@@??@D_>@C>@@A<@@@@@@') ; yourself); yourself]
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DataBaseSourceCodeManagementSettingsAppl andSelector:#windowSpec
     DataBaseSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     DataBaseSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'DB SCM Settings'
         name: 'DB SCM Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 724 736)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 20
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Demo Only'
                   name: 'Label10'
                   style: (FontDescription #'Segoe UI' medium roman 16 #'ms-default' nil nil)
                   foregroundColor: (Color 87.0 0.0 0.0)
                   translateLabel: true
                   extent: (Point 724 37)
                 )
                (FramedBoxSpec
                   label: 'Database Source Repository Manager Settings'
                   name: 'FileRepositorySetupBox'
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
                         layout: (LayoutFrame 0 0 43 0 0 1 73 0)
                         activeHelpKey: defaultDBName
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'DB Name:'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                               activeHelpKey: defaultDBName
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'RepositoryPathField2'
                               layout: (LayoutFrame 64 0.25 0 0 0 1 30 0)
                               activeHelpKey: defaultDBName
                               tabable: true
                               model: dbNameHolder
                               immediateAccept: true
                               acceptOnLeave: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: dbPrototypeList
                             )
                            )
                          
                         )
                       )
                      (LabelSpec
                         label: 'DB per Module:'
                         name: 'knownModulesLabel'
                         layout: (LayoutFrame 0 0.0 82 0 60 0.25 112 0)
                         activeHelpKey: perModuleDB
                         translateLabel: true
                         adjust: right
                       )
                      (SequenceViewSpec
                         name: 'List1'
                         layout: (LayoutFrame 64 0.25 82 0 0 1 201 0)
                         activeHelpKey: perModuleDB
                         tabable: true
                         model: selectedPerModuleDatabase
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         useIndex: false
                         sequenceList: listOfModules
                       )
                      (LabelSpec
                         label: 'Module:'
                         name: 'moduleLabel'
                         layout: (LayoutFrame 0 0.0 212 0 60 0.25 242 0)
                         activeHelpKey: perModuleDBModule
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'ComboBox1'
                         layout: (LayoutFrame 64 0.25 210 0 0 1 240 0)
                         activeHelpKey: perModuleDBModule
                         tabable: true
                         model: perModuleDatabaseModule
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: sampleModuleList
                       )
                      (LabelSpec
                         label: 'DB:'
                         name: 'cvsRootLabel'
                         layout: (LayoutFrame 0 0.0 243 0 60 0.25 273 0)
                         activeHelpKey: perModuleDBName
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'perModulePathComboBox'
                         layout: (LayoutFrame 64 0.25 243 0 0 1.0 273 0)
                         activeHelpKey: perModuleDBName
                         tabable: true
                         model: perModuleDB
                         immediateAccept: true
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: dbPrototypeList
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel2'
                         layout: (LayoutFrame 64 0.25 278 0 -1 1 308 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Add/Apply'
                               name: 'addButton'
                               translateLabel: true
                               tabable: true
                               model: addPerModuleDB
                               extent: (Point 143 30)
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'removeButton'
                               translateLabel: true
                               tabable: true
                               model: removePerModuleDB
                               enableChannel: removeEnabled
                               extent: (Point 143 30)
                             )
                            (ViewSpec
                               name: 'Box11'
                               extent: (Point 144 10)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 724 346)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ DataBaseSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    dbPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

addPerModuleDB
    |module db path|

    acceptChannel value:true.    

    module := self perModuleDatabaseModule value.
    db := self perModuleDB value.
    db size > 0 ifTrue:[
        (db startsWith:'sqlite:') ifTrue:[
            path := db copyFrom:'sqlite:' size + 1.        
            self validateDatabaseExistsAndIsWritable:db.
        ].
        self addModule:module withData:{ DataBaseSourceCodeManager . db }.
    ].

    "Created: / 25-12-2011 / 13:18:30 / cg"
!

basicReadSettings
    |infoPerModule|

    self initialize.

    infoPerModule := DataBaseSourceCodeManager repositoryInfoPerModule.
    infoPerModule keysAndValuesDo:[:module :info | 
        dbPerModule at:module put:(Array with:DataBaseSourceCodeManager with:info).
    ].

    self dbNameHolder value:DataBaseSourceCodeManager repositoryName. 

    dbPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:dbPerModule keys asList.
    ].

    self shownInBrowserMenusHolder value:DataBaseSourceCodeManager shownInBrowserMenus.

    "Modified (comment): / 12-01-2012 / 14:00:48 / cg"
!

basicSaveSettings
    |infoPerModule modules|

    DataBaseSourceCodeManager repositoryName:self dbNameHolder value.    

    modules := dbPerModule select:[:entry | entry first == DataBaseSourceCodeManager].
    infoPerModule := Dictionary new.
    modules keysAndValuesDo:[:module :entry | 
        infoPerModule at:module put:(entry second).
    ].
    DataBaseSourceCodeManager repositoryInfoPerModule:infoPerModule.
    DataBaseSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    self acceptChannel value.

    "/ make sure, that the DB libs are present
    Smalltalk loadPackage:'stx:libdb'.
    Smalltalk loadPackage:'stx:libdb/libsqlite'.
    Smalltalk loadPackage:'stx:libdb/libodbc'.

    "Modified (comment): / 12-03-2012 / 11:27:10 / cg"
!

removePerModuleDB
    |module|

    acceptChannel value:true.    

    module := self perModuleDatabaseModule value.
    self listOfModules remove:module ifAbsent:nil.
    dbPerModule removeKey:module ifAbsent:nil.
    self perModuleDatabaseModule value:nil.
    self perModuleDB value:nil.
    self updateModifiedChannel.

    "Created: / 25-12-2011 / 13:19:45 / cg"
!

removePerModulePath
    |module|

    acceptChannel value:true.    

    module := self perModuleDatabaseModule value.
    self listOfModules remove:module ifAbsent:nil.
    dbPerModule removeKey:module ifAbsent:nil.
    self perModuleDatabaseModule value:nil.
    self perModuleDB value:nil.
    self updateModifiedChannel.

    "Created: / 21-12-2011 / 14:26:08 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'aspects'!

dbNameHolder

    dbNameHolder isNil ifTrue:[
        dbNameHolder := DataBaseSourceCodeManager defaultRepositoryName asValue.
        dbNameHolder addDependent:self.
    ].
    ^ dbNameHolder.

    "Created: / 25-12-2011 / 13:14:17 / cg"
!

dbPrototypeList
    ^ #(
            'sqlite:repository.db'
            'odbc:localhost:stxRepository'
            'sqlite:pathname'
            'odbc:user.password@host:table'
        )

    "Created: / 25-12-2011 / 13:13:20 / cg"
!

initialListOfModules
    ^ dbPerModule keys asList sort.

    "Created: / 02-03-2012 / 14:39:53 / cg"
!

perModuleDB
    perModuleDB isNil ifTrue:[
        perModuleDB := ValueHolder new.
    ].
    ^ perModuleDB.

    "Created: / 25-12-2011 / 13:18:55 / cg"
!

perModuleDatabaseModule
    perModuleDatabaseModule isNil ifTrue:[
        perModuleDatabaseModule := ValueHolder new.
    ].
    ^ perModuleDatabaseModule.

    "Created: / 25-12-2011 / 13:16:55 / cg"
!

selectedPerModuleDatabase
    selectedPerModuleDatabase isNil ifTrue:[
        selectedPerModuleDatabase := ValueHolder new.
        selectedPerModuleDatabase addDependent:self.
    ].
    ^ selectedPerModuleDatabase.

    "Created: / 25-12-2011 / 13:15:10 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModuleDatabaseChanged
    |module entry|

    self acceptChannel value:true. 

    module := self selectedPerModuleDatabase value.
    module isNil ifTrue:[ 
        self removeEnabled value:false.
        self perModuleDatabaseModule value:' '.
        self perModuleDB value:''.
        ^ self
    ].

    entry := dbPerModule at:module ifAbsent:#().    
    (entry first = DataBaseSourceCodeManager) ifTrue:[
        self removeEnabled value:true.
        self perModuleDatabaseModule value:module.
        self perModuleDB value:(entry at:2).
    ] ifFalse:[
        self removeEnabled value:false.
        self perModuleDatabaseModule value:module , ' ',('<<use ',entry first managerTypeName,'>>') allBold.
        self perModuleDB value:''.
    ].

    "Created: / 25-12-2011 / 13:15:54 / cg"
!

update:something with:aParameter from:changedObject 
    changedObject == selectedPerModuleDatabase ifTrue:[
        self selectedPerModuleDatabaseChanged.
        ^ self
    ].
    changedObject == dbNameHolder ifTrue:[
        self updateModifiedChannel.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 26-12-2011 / 01:11:59 / cg"
!

validateDatabaseExistsAndIsWritable:dbPath
    |nm fn|

    (dbPath startsWith:'sqlite:') ifFalse:[
        (DataBaseSourceCodeManager openDB:dbPath) close.
        ^ true
    ].

    fn := dbPath asFilename.
    nm := fn baseName.

    fn exists ifFalse:[
        (self confirm:(resources 
                            stringWithCRs:'Database "%1" does not exist.\Create ?'
                            with:nm)
        ) ifFalse:[
            ^ false.
        ].
        fn directory exists ifFalse:[
            fn directory
                recursiveMakeDirectory; 
                makeReadableForAll;
                makeWritableForAll;
                makeExecutableForAll.
        ].
        (DataBaseSourceCodeManager openDB:dbPath) close.
        ^ true.
    ].

    (fn isDirectory) ifTrue:[
        self warn:(resources 
                            stringWithCRs:'"%1" exists but is a directory'
                            with:nm).
        ^ false.
    ].

    (fn isWritable and:[fn isReadable]) ifFalse:[
        (self confirm:(resources 
                            stringWithCRs:'"%1" is not both readable and writable.\Change ?'
                            with:nm)
        ) ifFalse:[
            ^ false.
        ].
        fn
            makeReadable;
            makeWritable.
        (fn isWritable and:[fn isReadable]) ifFalse:[
            self warn:(resources 
                                stringWithCRs:'"%1" cannot be made both readable and writable.'
                                with:nm).
            ^ false.
        ].
    ].

    ^ true

    "Created: / 21-12-2011 / 14:43:11 / cg"
!

validateDirectoryExistsAndIsWritable:aDirectory
    |nm fn|

    fn := aDirectory asFilename.
    nm := fn baseName.

    fn exists ifFalse:[
        (self confirm:(resources 
                            stringWithCRs:'Directory "%1" does not exist.\Create ?'
                            with:nm)
        ) ifFalse:[
            ^ false.
        ].
        fn 
            recursiveMakeDirectory; 
            makeReadableForAll;
            makeWritableForAll;
            makeExecutableForAll.
        ^ true.
    ].

    (fn isDirectory) ifFalse:[
        self warn:(resources 
                            stringWithCRs:'Not a directory: "%1"'
                            with:nm).
        ^ false.
    ].

    (fn isWritableDirectory and:[fn isReadable]) ifFalse:[
        (self confirm:(resources 
                            stringWithCRs:'Directory "%1" is not both readable and writable.\Change ?'
                            with:nm)
        ) ifFalse:[
            ^ false.
        ].
        fn
            makeReadableForAll;
            makeWritableForAll;
            makeExecutableForAll.
        (fn isWritableDirectory and:[fn isReadable]) ifFalse:[
            self warn:(resources 
                                stringWithCRs:'Directory "%1" cannot be made both readable and writable.'
                                with:nm).
            ^ false.
        ].
    ].

    ^ true

    "Created: / 21-12-2011 / 14:43:11 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_DataBaseSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/dataBaseRepositorySetup.html'

    "Modified: / 12-01-2012 / 14:03:04 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    dbPerModule := Dictionary new.

    DataBaseSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            dbPerModule at:module put:(Array with:DataBaseSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 25-12-2011 / 13:23:44 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl methodsFor:'queries'!

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

hasUnsavedChanges
    |modules|

    (DataBaseSourceCodeManager repositoryName) ~= self dbNameHolder value    
        ifTrue:[^ true].
    (DataBaseSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    modules := dbPerModule select:[:entry | entry first == DataBaseSourceCodeManager].

    DataBaseSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((modules includesKey:module) and:[info = (modules at:module) second])
        ifFalse:[^ true].
    ].
    modules keysAndValuesDo:[:module :info|
        ((DataBaseSourceCodeManager repositoryInfoPerModule includesKey:module) and:[(DataBaseSourceCodeManager repositoryInfoPerModule at:module) = info second])
        ifFalse:[^ true].
    ].

    ^ false

    "Modified: / 10-01-2012 / 00:31:19 / cg"
! !

!DataBaseSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

