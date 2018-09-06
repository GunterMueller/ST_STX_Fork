"
 COPYRIGHT (c) 2006 by eXept Software AG
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

AbstractFileFinderApplicationComponent subclass:#DirectoryDifferenceViewApplication
	instanceVariableNames:'directory1Holder directory2Holder directory1 directory2
		filesOnlyInDirectory1 filesOnlyInDirectory2
		filesWhichAreDifferent directoriesOnlyInDirectory1
		directoriesOnlyInDirectory2 namePatternHolder
		excludedNamePatternHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!DirectoryDifferenceViewApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!DirectoryDifferenceViewApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FindFileApplication    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#namePattern
'Filename(s) to search for. Can be matchPatterns, separated by ";"'

#excludedNamePattern
'Filename(s) to skip. Can be matchPatterns, separated by ";"'

#searchDirectory1
'The first folder, to be compared against folder2'

#searchDirectory2
'The second folder, to be compared against folder1'

)

    "Modified: / 13-01-2012 / 14:41:36 / cg"
! !

!DirectoryDifferenceViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DirectoryDifferenceViewApplication andSelector:#windowSpec
     DirectoryDifferenceViewApplication new openInterface:#windowSpec
     DirectoryDifferenceViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Directory Diff'
          name: 'Directory Diff'
          min: (Point 377 131)
          bounds: (Rectangle 0 0 758 512)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar1'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              level: 0
              menu: searchMenu
              textDefault: true
            )
           (ProgressIndicatorSpec
              name: 'ProgressIndicator1'
              layout: (LayoutFrame 125 0 11 0 231 0 21 0)
              visibilityChannel: enableStop
              backgroundColor: (Color 0.0 66.9993133440146 66.9993133440146)
              showPercentage: false
              isActivityIndicator: true
            )
           (ViewSpec
              name: 'Box1'
              layout: (LayoutFrame 0 0.0 32 0 0 1.0 130 0)
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Directory1:'
                    name: 'DirectoryLabel'
                    layout: (LayoutFrame 2 0 7 0 154 0 24 0)
                    activeHelpKey: searchDirectory1
                    translateLabel: true
                    adjust: right
                  )
                 (FilenameInputFieldSpec
                    name: 'DirectoryEntryField'
                    layout: (LayoutFrame 156 0 4 0 0 1 24 0)
                    activeHelpKey: searchDirectory1
                    model: directory1Holder
                    immediateAccept: true
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Directory2:'
                    name: 'Label2'
                    layout: (LayoutFrame 2 0 31 0 154 0 48 0)
                    activeHelpKey: searchDirectory2
                    translateLabel: true
                    adjust: right
                  )
                 (FilenameInputFieldSpec
                    name: 'FilenameEntryField1'
                    layout: (LayoutFrame 156 0 28 0 0 1 48 0)
                    activeHelpKey: searchDirectory2
                    model: directory2Holder
                    immediateAccept: true
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Compare Files Named:'
                    name: 'FileNameLabel'
                    layout: (LayoutFrame 2 0 55 0 154 0 72 0)
                    activeHelpKey: namePattern
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'FileNameEntryField'
                    layout: (LayoutFrame 156 0 52 0 -315 1 72 0)
                    activeHelpKey: namePattern
                    tabable: true
                    model: namePatternHolder
                    immediateAccept: true
                    acceptOnLeave: false
                    acceptOnPointerLeave: false
                  )
                 (CheckBoxSpec
                    label: 'Ignore Case'
                    name: 'IgnoreCaseInNameCheckBox'
                    layout: (LayoutFrame -169 1 53 0 -4 1 76 0)
                    activeHelpKey: ignoreCase
                    tabable: true
                    model: ignoreCaseInName
                    translateLabel: true
                  )
                 (LabelSpec
                    label: 'But Not Named:'
                    name: 'Label1'
                    layout: (LayoutFrame 2 0 79 0 154 0 96 0)
                    activeHelpKey: excludedNamePattern
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'EntryField1'
                    layout: (LayoutFrame 156 0 76 0 -315 1 96 0)
                    activeHelpKey: excludedNamePattern
                    tabable: true
                    model: excludedNamePatternHolder
                    immediateAccept: true
                    acceptOnLeave: false
                    acceptOnPointerLeave: false
                  )
                 (CheckBoxSpec
                    label: 'Ignore Case'
                    name: 'CheckBox1'
                    layout: (LayoutFrame -169 1 77 0 -4 1 100 0)
                    activeHelpKey: ignoreCase
                    tabable: true
                    model: ignoreCaseInExcludedName
                    translateLabel: true
                  )
                 )
               
              )
            )
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0.0 140 0 0 1.0 0 1)
              component: 
             (SpecCollection
                collection: (
                 (DataSetSpec
                    name: 'Table1'
                    model: selectionHolder
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    dataList: matchedFilesList
                    doubleClickSelector: fileDoubleClick:
                    columnHolder: searchResultTable
                    valueChangeSelector: fileSelected:
                    multipleSelectOk: true
                  )
                 (ArbitraryComponentSpec
                    name: 'DiffTextView'
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    component: DiffTextView
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )

    "Modified: / 13-01-2012 / 14:41:56 / cg"
! !

!DirectoryDifferenceViewApplication class methodsFor:'menu specs'!

searchMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FindFileApplication andSelector:#searchMenu
     (Menu new fromLiteralArrayEncoding:(FindFileApplication searchMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Search'
            itemValue: doSearch
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary searchFileIcon)
          )
         (MenuItem
            enabled: enableStop
            label: 'Stop'
            itemValue: stop
            translateLabel: true
            isButton: true
            isVisible: enableStop
            labelImage: (ResourceRetriever XPToolbarIconLibrary stop22x22Icon)
          )
         (MenuItem
            label: 'Close'
            itemValue: doClose
            translateLabel: true
            isButton: true
            startGroup: right
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!DirectoryDifferenceViewApplication class methodsFor:'tableColumns specs'!

searchResultTable
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:DirectoryDifferenceViewApplication andSelector:#searchResultTable
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Filename'
         id: 'FileName'
         labelButtonType: Button
         model: at:
         menuFromApplication: false
         writeSelector: at:put:
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Diff'
         id: 'Diff'
         labelButtonType: Button
         model: at:
         menuFromApplication: false
         writeSelector: at:put:
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!DirectoryDifferenceViewApplication methodsFor:'accessing'!

directory1:directory1Arg directory2:directory2Arg 
    self directory1Holder value:directory1Arg.
    self directory2Holder value:directory2Arg.

"/    self namePatternHolder value:newPattern.
    self enableStop value:false.
    self enableSearch value:true.
    ^ true.

    "Modified: / 12-01-2012 / 01:36:54 / cg"
!

directory1Holder
    directory1Holder isNil ifTrue:[
        directory1Holder := nil asValue
    ].
    ^ directory1Holder

    "Created: / 12-01-2012 / 01:37:31 / cg"
!

directory2Holder
    directory2Holder isNil ifTrue:[
        directory2Holder := nil asValue
    ].
    ^ directory2Holder

    "Created: / 12-01-2012 / 01:37:41 / cg"
! !

!DirectoryDifferenceViewApplication methodsFor:'actions'!

fileSelected:entries
    |entry file fn1 fn2 text1 text2 differ|

    entries isEmptyOrNil ifTrue:[^ self].

    entry := self shownList at:entries first.
    file := entry first.

    fn1 := self directory1Holder value asFilename construct:file.
    fn2 := self directory2Holder value asFilename construct:file.
    (fn1 exists and:[fn1 isRegularFile]) ifTrue:[
        text1 := fn1 contentsAsString.
    ].
    (fn2 exists and:[fn2 isRegularFile]) ifTrue:[
        text2 := fn2 contentsAsString.
    ].
    differ := builder componentAt:'DiffTextView'.
    differ text1:(text1 ? '') text2:(text2 ? '').

    "Created: / 12-01-2012 / 03:21:52 / cg"
! !

!DirectoryDifferenceViewApplication methodsFor:'aspects'!

excludedNamePatternHolder
    excludedNamePatternHolder isNil ifTrue:[
        excludedNamePatternHolder := '' asValue.
    ].
    ^ excludedNamePatternHolder.

    "Created: / 13-01-2012 / 14:42:47 / cg"
!

namePatternHolder

    namePatternHolder isNil ifTrue:[
        namePatternHolder := '*' asValue.
    ].
    ^ namePatternHolder.

    "Created: / 13-01-2012 / 14:37:28 / cg"
! !

!DirectoryDifferenceViewApplication methodsFor:'comparing'!

doSearch
    |dir1 dir2 namePattern namePatterns excludedNamePattern excludedNamePatterns|

    filesOnlyInDirectory1 := OrderedCollection new.
    filesOnlyInDirectory2 := OrderedCollection new.
    directoriesOnlyInDirectory1 := OrderedCollection new.
    directoriesOnlyInDirectory2 := OrderedCollection new.
    filesWhichAreDifferent := OrderedCollection new.

    dir1 := self directory1Holder value.
    dir1 isNil ifTrue:[^ self].

    dir2 := self directory2Holder value.
    dir2 isNil ifTrue:[^ self].

    dir1 := dir1 asFilename.
    dir2 := dir2 asFilename.

    dir1 pathName = dir2 pathName ifTrue:[
        self notify:('Same folder.' allBold).
        ^ self.
    ].

    namePattern := self namePatternHolder value.
    namePattern notEmptyOrNil ifTrue:[
        namePatterns := namePattern asCollectionOfSubstringsSeparatedByAny:',;'.
        namePatterns := namePatterns collect:[:p | p withoutSeparators ].
    ].
    excludedNamePattern := self excludedNamePatternHolder value.
    excludedNamePattern notEmptyOrNil ifTrue:[
        excludedNamePatterns := excludedNamePattern asCollectionOfSubstringsSeparatedByAny:',;'.
        excludedNamePatterns := excludedNamePatterns collect:[:p | p withoutSeparators ].
    ].
    self matchedFilesList removeAll.
    self windowGroup repairDamage.

    self 
        startSearchTask:[
            self changeInformationTo:'Directory Diff - searching ' toTab:true.

            self shownListHolder valueHolder:(self matchedFilesList).

            dir1 recursiveDirectoryContentsDo:[:relFn1 |
                |fn1 fn2|

                fn1 := dir1 construct:relFn1.
                (namePatterns isNil or:[namePatterns contains:[:p | p match:fn1 baseName]]) ifTrue:[
                    (excludedNamePatterns notNil and:[excludedNamePatterns contains:[:p | p match:fn1 baseName]]) ifFalse:[
                        fn2 := dir2 construct:relFn1.
                        fn1 isDirectory ifTrue:[
                            self notify:('Comparing %1...' bindWith:relFn1 asString allBold).
                            fn2 exists ifFalse:[
                                directoriesOnlyInDirectory1 add:fn1.
                                self matchedFilesList add:{ relFn1 . 'Directory only in directory1' }.
                            ].
                        ] ifFalse:[
                            fn2 exists ifTrue:[
                                (fn1 sameContentsAs:fn2) ifFalse:[
                                    filesWhichAreDifferent add:fn1.
                                    self matchedFilesList add:{ relFn1 . 'Different' }.
                                ].
                            ] ifFalse:[
                                filesOnlyInDirectory1 add:fn1.
                                self matchedFilesList add:{ relFn1 . 'File only in directory1' }.
                            ].
                        ].
                    ]
                ]
            ].
            dir2 recursiveDirectoryContentsDo:[:relFn2 |
                |fn1 fn2|

                fn2 := dir2 construct:relFn2.
                (namePatterns isNil or:[namePatterns contains:[:p | p match:fn2 baseName]]) ifTrue:[
                    (excludedNamePatterns notNil and:[excludedNamePatterns contains:[:p | p match:fn2 baseName]]) ifFalse:[
                        fn1 := dir1 construct:relFn2.
                        fn1 exists ifFalse:[
                            fn1 isDirectory ifTrue:[
                                directoriesOnlyInDirectory1 add:fn1.
                                self matchedFilesList add:{ relFn2 . 'Directory only in directory2' }.
                            ] ifFalse:[
                                filesOnlyInDirectory2 add:fn2.
                                self matchedFilesList add:{ relFn2 . 'File only in directory2' }.
                            ]
                        ].
                    ].
                ]
            ].
            filesOnlyInDirectory1 notEmpty ifTrue:[
                Transcript showCR:('%1 files only in directory1' bindWith:filesOnlyInDirectory1 size).
            ].
            filesOnlyInDirectory2 notEmpty ifTrue:[
                Transcript showCR:('%1 files only in directory2' bindWith:filesOnlyInDirectory2 size).
            ].
            directoriesOnlyInDirectory1 notEmpty ifTrue:[
                Transcript showCR:('%1 directories only in directory1' bindWith:directoriesOnlyInDirectory1 size).
            ].
            directoriesOnlyInDirectory2 notEmpty ifTrue:[
                Transcript showCR:('%1 directories only in directory2' bindWith:directoriesOnlyInDirectory2 size).
            ].
            filesWhichAreDifferent notEmpty ifTrue:[
                Transcript showCR:('%1 files are different' bindWith:filesWhichAreDifferent size).
            ]
        ]
        name:'Directory Diff'.

    "Created: / 12-01-2012 / 01:07:20 / cg"
! !

!DirectoryDifferenceViewApplication methodsFor:'startup & release'!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.
    self doSearch

    "Created: / 12-01-2012 / 01:41:18 / cg"
! !

!DirectoryDifferenceViewApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/DirectoryDifferenceViewApplication.st,v 1.8 2015-02-10 19:05:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/DirectoryDifferenceViewApplication.st,v 1.8 2015-02-10 19:05:44 cg Exp $'
! !

