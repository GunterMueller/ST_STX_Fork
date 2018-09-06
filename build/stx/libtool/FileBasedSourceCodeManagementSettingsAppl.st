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

AbstractSourceCodeManagementSettingsAppl subclass:#FileBasedSourceCodeManagementSettingsAppl
	instanceVariableNames:'pathPerModule repositoryPathHolder perModulePath
		perModulePathModule selectedPerModulePath'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

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
    This settings app controls the parameters of the simple FileBasedSourceCodeManager.
"
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'defaults'!

defaultRepositoryPath
    ^ FileBasedSourceCodeManager defaultRepositoryPath

    "Created: / 21-12-2011 / 14:55:40 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileBasedSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#defaultRepositoryPath
'The default repository directory used for all modules not listed below'

#perModuleModule
'The module for which a specific directory is defined'

#perModuleRepositoryPath
'The repository directory of this module'

#repositoryPathPerModule
'Module specific repository directories'

)

    "Created: / 25-12-2011 / 14:00:06 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon2

    "Created: / 21-12-2011 / 14:51:12 / cg"
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
        constantNamed:'FileBasedSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B_''92\@@@@@@@@@@@@@@@@@@@@@@B\''9>_''90@@@@@@@@@@@@@@@@@
@@B[''9<@@@@@''@@@@@@@@@@@@@@@@@@@''I6\@@@@@@@@@@@@@@@@@@@@@@B\''I>^'':@@@JD@@@@@@@@@@@@@@@@GA)2^''900LJF!!(S@0LC@0LH1="0@@A2 (
''JT(X:F$)JN!![&9.[&:K#'',@@E((X3M.[*F!!(*F!!(R6U%IBYM&5 @@@!!L:D3N3-KKZF!!EBBS$YZRA ROJ @@HQQK(ZF!!(ZF!!&''Y6D9^WG9]/B9 @@BE3XVF"
(ZF!!&&M#IBP(JC<_YR*X@@AFZ4)QK&8<N3, HB@3L68JO1\*@@@@QUD%W4\ \2@ RD +EAHR]Q(,@@@@@GDUL''P U3EHLT!!UUQPRD''TZK@@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 255 248 200 255 248 24 15 56 160 255 248 88 239 232 240 240 240 240 255 248 152 48 80 176 255 248 96 48 88 176 240 240 248 207 216 240 223 216 224 255 248 48 224 224 232 255 248 176 255 248 248 240 144 24 255 248 136 63 96 184 240 208 24 239 239 224 176 159 111 240 207 96 207 160 127 240 207 111 191 191 160 223 208 175 240 208 111 255 255 239 192 176 175 208 207 176 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@<@@A>@@C!!@@C @@O2@@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
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
        constantNamed:'FileBasedSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8B0,0L@\@@@@@@@@@@@@@@@@@@@@GA!!L$H" 0LC@0LC@0LC@0LH1="0@@A2 (
JB (X6M.[&9.[&9.[&:K#'',@@E((X3M.[#L3N3-[V26U%IBYM&5 @@@!!L5,3N3-KKQP5EBBS$YZRA ROJ @@HQQKKY>_''I0G]''Y6D9^WG9]/B9 @@BE3XY2_
''9>_''FM#IBP(JC<_YR*X@@AFZ9._''68<N3.\HB@3L68JO1\*@@@@QUF\''Y0 \2@ RD +EAHR]Q(,@@@@@I2\''9:_(CEH(T!!UUQPRD''TZK@@@@@@M''I:_''BM*
(ZF!!APUS^T5$M@@@@@@@CWZ\)U%Y(ZR$(:DXOTP7U @@@@@@@@L>WT1L(ZF"(ZF!!VAXQ[@@@@@@@@@A\(TQRPF!!2(ZEAJT$@@@@@@@@@@@@@RTN!!(ZF!!(ZFZ
@@@@@@@@@@@@@@@@@@@@@JJ!!(ZFZ@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 255 248 200 255 248 24 15 56 160 255 248 88 239 232 240 240 240 240 255 248 152 48 80 176 255 248 96 48 88 176 240 240 248 207 216 240 223 216 224 255 248 48 224 224 232 255 248 176 255 248 248 240 144 24 255 248 136 63 96 184 240 208 24 239 239 224 176 159 111 240 207 96 207 160 127 240 207 111 191 191 160 223 208 175 240 208 111 255 255 239 192 176 175 208 207 176 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@O0@@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_<@@C8@@');
                            yourself);
                yourself
        ]
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBasedSourceCodeManagementSettingsAppl andSelector:#windowSpec
     FileBasedSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     FileBasedSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'FileBased SCM Settings'
         name: 'FileBased SCM Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 694 545)
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
                   extent: (Point 694 37)
                 )
                (FramedBoxSpec
                   label: 'File Based Source Repository Manager Settings'
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
                         layout: (LayoutFrame 0 0 38 0 0 1 68 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Repository Path:'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                               activeHelpKey: defaultRepositoryPath
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'RepositoryPathField'
                               layout: (LayoutFrame 64 0.25 0 0 0 1 30 0)
                               activeHelpKey: defaultRepositoryPath
                               tabable: true
                               model: repositoryPathHolder
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      (LabelSpec
                         label: 'Path per Module:'
                         name: 'knownModulesLabel'
                         layout: (LayoutFrame 0 0.0 82 0 60 0.25 112 0)
                         activeHelpKey: repositoryPathPerModule
                         translateLabel: true
                         adjust: right
                       )
                      (SequenceViewSpec
                         name: 'List1'
                         layout: (LayoutFrame 64 0.25 82 0 0 1 201 0)
                         activeHelpKey: repositoryPathPerModule
                         tabable: true
                         model: selectedPerModulePath
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         useIndex: false
                         sequenceList: listOfModules
                       )
                      (LabelSpec
                         label: 'Module:'
                         name: 'moduleLabel'
                         layout: (LayoutFrame 0 0.0 207 0 60 0.25 237 0)
                         activeHelpKey: perModuleModule
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'ComboBox1'
                         layout: (LayoutFrame 64 0.25 207 0 0 1 237 0)
                         activeHelpKey: perModuleModule
                         tabable: true
                         model: perModulePathModule
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: sampleModuleList
                       )
                      (LabelSpec
                         label: 'Path:'
                         name: 'cvsRootLabel'
                         layout: (LayoutFrame 0 0.0 240 0 60 0.25 270 0)
                         activeHelpKey: perModuleRepositoryPath
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'perModulePathComboBox'
                         layout: (LayoutFrame 64 0.25 240 0 0 1.0 270 0)
                         activeHelpKey: perModuleRepositoryPath
                         tabable: true
                         model: perModulePath
                         immediateAccept: true
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         comboList: pathPrototypeList
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel2'
                         layout: (LayoutFrame 64 0.25 274 0 -1 1 304 0)
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
                               model: addPerModulePath
                               extent: (Point 135 30)
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'removeButton'
                               translateLabel: true
                               tabable: true
                               model: removePerModulePath
                               enableChannel: removeEnabled
                               extent: (Point 135 30)
                             )
                            (ViewSpec
                               name: 'Box11'
                               extent: (Point 137 10)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 694 342)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ FileBasedSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    pathPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

addPerModulePath
    |module path|

    acceptChannel value:true.    

    module := self perModulePathModule value.
    path := self perModulePath value.

    path size > 0 ifTrue:[
        self validateDirectoryExistsAndIsWritable:path.
        self addModule:module withData:(Array with:FileBasedSourceCodeManager with:path).
    ].

    "Created: / 21-12-2011 / 14:23:10 / cg"
!

basicReadSettings
    |infoPerModule|

    self initialize.

    infoPerModule := FileBasedSourceCodeManager repositoryInfoPerModule.
    infoPerModule keysAndValuesDo:[:module :info | 
        pathPerModule at:module put:(Array with:FileBasedSourceCodeManager with:info).
    ].

    self repositoryPathHolder value:FileBasedSourceCodeManager repositoryPath ? FileBasedSourceCodeManager defaultRepositoryPath.

    pathPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:pathPerModule keys asList.
    ].

    self shownInBrowserMenusHolder value:FileBasedSourceCodeManager shownInBrowserMenus.

    "Modified: / 10-01-2012 / 00:20:51 / cg"
!

basicSaveSettings
    |infoPerModule modules|

    modules := pathPerModule select:[:entry | entry first == FileBasedSourceCodeManager].
    infoPerModule := Dictionary new.
    modules keysAndValuesDo:[:module :entry | 
        entry first == FileBasedSourceCodeManager ifTrue:[
            infoPerModule at:module put:(entry second).
        ].
    ].

    FileBasedSourceCodeManager repositoryInfoPerModule:infoPerModule.
    FileBasedSourceCodeManager repositoryPath:(self repositoryPathHolder value).
    FileBasedSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 

    self acceptChannel value.

    "Modified: / 10-01-2012 / 00:21:49 / cg"
!

removePerModulePath
    |module|

    acceptChannel value:true.    

    module := self perModulePathModule value.
    self listOfModules remove:module ifAbsent:nil.
    pathPerModule removeKey:module ifAbsent:nil.
    self perModulePathModule value:nil.
    self perModulePath value:nil.
    self updateModifiedChannel.

    "Created: / 21-12-2011 / 14:26:08 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'aspects'!

initialListOfModules
    ^ pathPerModule keys asList sort

    "Created: / 02-03-2012 / 14:40:32 / cg"
!

pathPrototypeList
    ^ #(
            './repository'
        )

    "Created: / 21-12-2011 / 13:13:05 / cg"
!

perModulePath
    perModulePath isNil ifTrue:[
        perModulePath := ValueHolder new.
        perModulePath addDependent:self.
    ].
    ^ perModulePath.

    "Created: / 21-12-2011 / 14:19:03 / cg"
!

perModulePathModule
    perModulePathModule isNil ifTrue:[
        perModulePathModule := ValueHolder new.
    ].
    ^ perModulePathModule.

    "Created: / 21-12-2011 / 14:31:09 / cg"
!

repositoryPathHolder
    repositoryPathHolder isNil ifTrue:[
        repositoryPathHolder := FileBasedSourceCodeManager defaultRepositoryPath asValue.
        repositoryPathHolder addDependent:self.
    ].
    ^ repositoryPathHolder.

    "Created: / 21-12-2011 / 13:11:58 / cg"
!

selectedPerModulePath
    selectedPerModulePath isNil ifTrue:[
        selectedPerModulePath := ValueHolder new.
        selectedPerModulePath addDependent:self.
    ].
    ^ selectedPerModulePath.

    "Created: / 21-12-2011 / 14:35:37 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModulePathChanged
    |module entry|

    self acceptChannel value:true. 

    module := self selectedPerModulePath value.
    module isNil ifTrue:[ 
        self removeEnabled value:false.
        self perModulePathModule value:' '.
        self perModulePath value:''.
        ^ self
    ].

    entry := pathPerModule at:module ifAbsent:#().    
    (entry first = FileBasedSourceCodeManager) ifTrue:[
        self removeEnabled value:true.
        self perModulePathModule value:module.
        self perModulePath value:(entry at:2).
    ] ifFalse:[
        self removeEnabled value:false.
        self perModulePathModule value:module , ' ',('<<use ',entry first managerTypeName,'>>') allBold.
        self perModulePath value:''.
    ].

    "Created: / 21-12-2011 / 14:35:04 / cg"
!

update:something with:aParameter from:changedObject 
    changedObject == selectedPerModulePath ifTrue:[
        self selectedPerModulePathChanged.
        ^ self
    ].
    changedObject == repositoryPathHolder ifTrue:[
        self updateModifiedChannel.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 22-12-2011 / 00:27:48 / cg"
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

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_FileBasedSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/fileBasedRepositorySetup.html'

    "Modified: / 21-12-2011 / 14:36:53 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    pathPerModule := Dictionary new.

    FileBasedSourceCodeManager repositoryInfoPerModule 
        keysAndValuesDo:[:module :info |
            module withoutSeparators ~= module ifTrue:[
                self halt:'should not happen any longer'
            ].
            pathPerModule at:module put:(Array with:FileBasedSourceCodeManager with:info)
        ].

    super initialize.

    "Modified: / 21-12-2011 / 23:50:23 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    |modules|

    (FileBasedSourceCodeManager repositoryPath ? FileBasedSourceCodeManager defaultRepositoryPath) ~= self repositoryPathHolder value    
        ifTrue:[^ true].
    (FileBasedSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    modules := pathPerModule select:[:entry | entry first == FileBasedSourceCodeManager].

    FileBasedSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((modules includesKey:module) and:[info = (modules at:module) second])
        ifFalse:[^ true].
    ].
    modules keysAndValuesDo:[:module :info|
        ((FileBasedSourceCodeManager repositoryInfoPerModule includesKey:module) and:[(FileBasedSourceCodeManager repositoryInfoPerModule at:module) = info second])
        ifFalse:[^ true].
    ].

    ^ false

    "Modified: / 10-01-2012 / 00:31:28 / cg"
! !

!FileBasedSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_FileRepository
    ^ '$Path: stx/libtool/FileBasedSourceCodeManagementSettingsAppl.st, Version: 1$'
! !

