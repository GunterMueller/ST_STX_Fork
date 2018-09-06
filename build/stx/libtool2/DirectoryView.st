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
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#DirectoryView
	instanceVariableNames:'directory selectedFileFilter readTask monitoring
		monitoringTimeBlock fileDoubleClickAction fileSelectAction
		fileFilterSelectAction fileAttributes'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

Object subclass:#FileRow
	instanceVariableNames:'fileName size modified iconKey imageFromFile group owner
		permissions baseName'
	classVariableNames:'MaxImageFileSize'
	poolDictionaries:''
	privateIn:DirectoryView
!

!DirectoryView class methodsFor:'documentation'!

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
    this is somewhat outdated. However, it is still used by the image editor and
    some other resource editors.
    It has the advantage of showing the file-contents...
    ...but the disadvantage of having an ugly layout and user interface.

    [author:]
        Thomas Zwick
"
! !

!DirectoryView class methodsFor:'instance creation'!

openOnDirectory: aDirectoryString
    "open a DirectoryView for a aDirectoryString"

    ^ (self new directory: aDirectoryString) open

    "
     self openOnDirectory: '/etc'
    "

    "Modified: / 28.1.1998 / 15:44:53 / stefan"
! !

!DirectoryView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DirectoryView andSelector:#windowSpec
     DirectoryView new openInterface:#windowSpec
     DirectoryView open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Directory View'
          #name: 'Directory View'
          #min: #(#Point 10 10)
          #max: #(#Point 1152 900)
          #bounds: #(#Rectangle 13 23 413 323)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#DataSetSpec
              #name: 'filesDataSetView'
              #layout: #(#LayoutFrame 0 0.0 24 0.0 -2 1.0 0 1.0)
              #model: #selectionOfFile
              #menu: #fileListMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #dataList: #listOfFiles
              #useIndex: false
              #has3Dsepartors: false
              #doubleClickSelector: #fileDoubleClicked
              #columnHolder: #fileAttributeColumns
              #valueChangeSelector: #fileSelected
              #verticalSpacing: 1
            )
           #(#ComboBoxSpec
              #name: 'formatComboBox'
              #layout: #(#LayoutFrame 63 0.0 0 0 0 1.0 22 0)
              #model: #selectionOfFileFilter
              #immediateAccept: false
              #acceptOnTab: false
              #acceptOnPointerLeave: false
              #comboList: #listOfFileFilters
            )
           #(#LabelSpec
              #label: 'Filter: '
              #name: 'filterLabel'
              #layout: #(#LayoutFrame 0 0 0 0 62 0 22 0)
              #adjust: #right
            )
           )
         
        )
      )

    "Modified: / 11.2.2000 / 00:11:43 / cg"
! !

!DirectoryView class methodsFor:'list specs'!

tableColumnsForFileAttributes
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:DirectoryView andSelector:#tableColumnsForFileAttributes
    "

    <resource: #tableColumns>


    ^ #(
        #(#DataSetColumnSpec
           #label: ''
           #width: 30
           #height: 22
           #printSelector: #iconOn:
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'File name'
           #labelAlignment: #left
           #minWidth: 150
           #model: #baseName
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'Size'
           #labelAlignment: #left
           #width: 70
           #model: #size
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'Modified'
           #labelAlignment: #left
           #model: #modified
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'Permissions'
           #labelAlignment: #left
           #width: 85
           #model: #permissions
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'Owner'
           #labelAlignment: #left
           #width: 50
           #model: #owner
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: 'Group'
           #labelAlignment: #left
           #width: 50
           #model: #group
           #canSelect: false
       )
     )
! !

!DirectoryView class methodsFor:'menu specs'!

fileListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryView andSelector:#fileListMenu
     (Menu new fromLiteralArrayEncoding:(DirectoryView fileListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Update'
            #translateLabel: true
            #value: #updateFileList
          )
         )
        nil
        nil
      )

    "Created: / 11.2.2000 / 00:11:39 / cg"
! !

!DirectoryView methodsFor:'accessing'!

directory: aDirectory

    directory := aDirectory asFilename asAbsoluteFilename name
!

fileAttributes: anArray

    fileAttributes := anArray
!

fileDoubleClickAction: anActionBlock

    fileDoubleClickAction := anActionBlock
!

fileFilterSelectAction: anActionBlock

    fileFilterSelectAction := anActionBlock
!

fileSelectAction: anActionBlock

    fileSelectAction := anActionBlock
!

listOfFileFilters: aCollection

    self listOfFileFilters contents: aCollection.
    self selectionOfFileFilter value: (self listOfFileFilters at: 1 ifAbsent: [nil]).
!

monitoring: aBoolean

    aBoolean
    ifTrue:
    [
        monitoringTimeBlock := [self readDirectory].
        self readDirectory.
    ]
    ifFalse:
    [
        monitoring ifTrue:
        [
            Processor removeTimedBlock:monitoringTimeBlock.
            monitoringTimeBlock := nil
        ]
    ].

    monitoring := aBoolean.

! !

!DirectoryView methodsFor:'aspects'!

fileAttributeColumns

    |holder|
    (holder := builder bindingAt:#fileAttributeColumns) isNil ifTrue:[
        |fileAttributeColumns|
        builder aspectAt:#fileAttributeColumns put:(holder := List new).
        fileAttributeColumns := self class tableColumnsForFileAttributes collect: [:i| i decodeAsLiteralArray].
        holder add: fileAttributeColumns first.
        fileAttributeColumns do:
        [:col|
            (fileAttributes includes: col label) ifTrue: [holder add: col]
        ].
        holder do: [:col| col label: ' ', col label]
    ].
    ^ holder
!

listOfFileFilters

    |holder|          
    (holder := builder bindingAt:#listOfFileFilters) isNil ifTrue:[
        builder aspectAt:#listOfFileFilters put:(holder :=  List with: '*').
    ].
    ^ holder
!

listOfFiles

    |holder|
    (holder := builder bindingAt:#listOfFiles) isNil ifTrue:[
        builder aspectAt:#listOfFiles put:(holder :=  List new).
    ].
    ^ holder
!

selectionOfFile

    |holder|
    (holder := builder bindingAt:#selectionOfFile) isNil ifTrue:[
        builder aspectAt:#selectionOfFile put:(holder :=  ValueHolder new).
    ].
    ^ holder

!

selectionOfFileFilter

    |holder|
    (holder := builder bindingAt:#selectionOfFileFilter) isNil ifTrue:[
        builder aspectAt:#selectionOfFileFilter put:
        (holder := AspectAdaptor new subject:self; forAspect:#selectedFileFilter).
        selectedFileFilter := '*'.
    ].
    ^ holder
! !

!DirectoryView methodsFor:'callbacks'!

fileDoubleClicked
      
    (fileDoubleClickAction notNil and: [self selectionOfFile value notNil]) 
    ifTrue: 
    [
        fileDoubleClickAction numArgs = 0
        ifTrue:
        [
            fileDoubleClickAction value
        ].
        fileDoubleClickAction numArgs = 1
        ifTrue:
        [                
            fileDoubleClickAction value: (directory asFilename construct: self selectionOfFile value baseName) name
        ]
    ]
!

fileSelected
      
    (fileSelectAction notNil and: [self selectionOfFile value notNil]) 
    ifTrue: 
    [
        fileSelectAction numArgs = 0
        ifTrue:
        [
            fileSelectAction value
        ].
        fileSelectAction numArgs = 1
        ifTrue:
        [
            fileSelectAction value: (directory asFilename construct: self selectionOfFile value baseName) name
        ]
    ]
! !

!DirectoryView methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder.

    directory :=  (directory ? '.') asFilename asAbsoluteFilename directoryName.
    monitoring := false.
    fileAttributes := #('File name' 'Size' 'Modified').
    self selectionOfFileFilter value: (self listOfFileFilters at: 1 ifAbsent: [nil]).

    "Modified: / 20.6.1998 / 14:46:10 / cg"
! !

!DirectoryView methodsFor:'initialize-release'!

release

    monitoring ifTrue:
    [
        Processor removeTimedBlock:monitoringTimeBlock.
        monitoringTimeBlock := nil
    ].

    super release

! !

!DirectoryView methodsFor:'menu actions'!

updateFileList
    DirectoryContents flushCache.
    self readDirectory

    "Created: / 11.2.2000 / 00:12:46 / cg"
    "Modified: / 11.2.2000 / 00:14:32 / cg"
! !

!DirectoryView methodsFor:'private'!

readDirectory
    |allDirectories allFiles foundFiles filterList dir newContents|    

    allFiles := OrderedCollection new.
    allDirectories := OrderedCollection new.
    foundFiles := OrderedCollection new.
    "/ filterList := self listOfFileFilters value.
    filterList := self selectedFileFilter asCollectionOfSubstringsSeparatedBy:$;.
    filterList := filterList collect:[:pattern | pattern withoutSeparators].

    self withCursor:Cursor read do:[ 
        (dir := DirectoryContents directoryNamed: directory) notNil ifTrue:[
"/            dir filesAndBasenamesDo:[:file :name|      
"/                filterList do:[:filter|
"/                    ((filter match:name) and:[(foundFiles includes: name) not])
"/                    ifTrue:[
"/                        foundFiles add: name
"/                    ].
"/                ].
"/            ].
            dir filesAndBasenamesDo:[:file :name|      
                allFiles add: name
            ].
            dir directoriesAndBasenamesDo:[:file :name|      
                allDirectories add: name
            ].

            Filename isCaseSensitive ifFalse:[
                filterList do:[:filter|
                    |lcFilter|

                    lcFilter := filter asLowercase.
                    foundFiles
                        addAll:(allFiles 
                                    select:[:name | lcFilter match:name asLowercase]
                                ).
                ]
            ] ifTrue:[
                filterList do:[:filter|
                    foundFiles
                        addAll:(allFiles 
                                    select:[:name | filter match:name]
                                ).
                ]
            ].

            foundFiles sort.
            allDirectories sort.

            dir := directory asFilename.

            newContents := OrderedCollection new.
            newContents addAll:(allDirectories collect:[:name| FileRow new fileName:(dir construct:name)]).
            newContents addAll:(foundFiles collect:[:name| FileRow new fileName:(dir construct:name)]).

            self listOfFiles contents:newContents
        ]
    ]

    "Modified: / 23.9.1998 / 17:00:42 / cg"
!

readMonitoringDirectory
    "this is a very ugly piece of code - 
     left in as a bad example of how to make ST look slow...
     DO NOT USE IT, but read to learn"
     
    |readBlock|

    readTask notNil ifTrue: [readTask terminate].
    readBlock :=
        [
            |dir currentFilenames oldListOfFiles listOfFiles|

            dir := directory asFilename.
            currentFilenames := OrderedCollection new.
            (dir isReadable and:[dir isExecutable]) ifTrue: [
                self listOfFileFilters value do:
                [:filter|
                    (dir filesMatchingWithoutDotDirs: filter) do: [:aFileName|
                        |file|
                        (file := dir construct: aFileName) isDirectory ifFalse: [
                            currentFilenames add: file
                        ]
                    ].
                ].
            ].
            listOfFiles := self listOfFiles.
            
            oldListOfFiles := listOfFiles copy.
            (currentFilenames asSortedCollection: [:f1 :f2| f1 baseName < f2 baseName]) asSet 
                do: [:fileName| 
                    (oldListOfFiles contains:[:fileRow | fileRow fileName = fileName ])
                    ifFalse: [
                        |nearestFileRow newRow r|
                        
                        newRow := FileRow new fileName: fileName asFilename.
                        "/ cg: how stupid is that?
                        nearestFileRow := listOfFiles indexOf: (listOfFiles detect: [:fileRow| fileRow baseName > fileName baseName] ifNone: nil).
                        "/ nearestFileRow := listOfFiles findFirst:[:fileRow | fileRow baseName > fileName baseName].
                        nearestFileRow = 0
                            ifTrue: [listOfFiles add: newRow]
                            ifFalse: [listOfFiles add: newRow beforeIndex: nearestFileRow].
                        monitoring ifTrue: [self selectionOfFile value: r].
                    ]
                ].
                
            listOfFiles 
                reverseDo: [:fileRow|
                    (currentFilenames includes: fileRow fileName)
                    ifFalse: [listOfFiles remove: fileRow]
                ]
        ].

    monitoring ifTrue: [
        readTask := readBlock forkAt: Processor userBackgroundPriority.
        Processor addTimedBlock: monitoringTimeBlock afterSeconds: 1
    ] ifFalse: [
        Cursor wait showWhile: [readBlock value]
    ]

    "Modified: / 19-11-2016 / 20:34:14 / cg"
! !

!DirectoryView methodsFor:'selection'!

selectedFileFilter

    ^selectedFileFilter

!

selectedFileFilter:aString
    "change the file filter"

    |listOfFileFilters nArgs|

    aString = selectedFileFilter ifTrue:[^ self].

    listOfFileFilters := self listOfFileFilters.

    "/ what is this for ?
    aString size == 0 ifTrue: [
        listOfFileFilters remove: selectedFileFilter ifAbsent: nil
    ].
    selectedFileFilter := aString.

    ((listOfFileFilters includes: selectedFileFilter) not
    and:[selectedFileFilter notEmpty])
    ifTrue: [
        listOfFileFilters addFirst: selectedFileFilter
    ].
    ((listOfFileFilters includes: selectedFileFilter)
    and:[fileFilterSelectAction notNil]) 
    ifTrue: [
        (nArgs := fileFilterSelectAction numArgs) == 0
        ifTrue: [
            fileFilterSelectAction value
        ] ifFalse:[
            nArgs == 1 ifTrue:[
                fileFilterSelectAction value: selectedFileFilter
            ] ifFalse:[
                self error:'bad numArgs of fileFilter action block'
            ]
        ]
    ].       
    self readDirectory.

    "Modified: / 23.9.1998 / 16:53:05 / cg"
! !

!DirectoryView methodsFor:'startup & release'!

closeRequest

    self release.

    super closeRequest

! !

!DirectoryView::FileRow class methodsFor:'resources'!

HFileIcon

    ^self hFileIcon
!

MakefileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self MakefileIcon inspect
     ImageEditor openOnClass:self andSelector:#MakefileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow MakefileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 @@0 @@0 @@0)IV0/U$0)]&0)UT;)UV4 @@0 @@0???0???0')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

binaryFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self binaryFileIcon inspect
     ImageEditor openOnClass:self andSelector:#binaryFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow binaryFileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???3 @_7 @W4#&S0&6Q0&6_3&6O5&6@0#&@9 @@0&\@2&6@0&6@0&6@1&6@8&\@0 @@0???0???1')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

cFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cFileIcon inspect
     ImageEditor openOnClass:self andSelector:#cFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow cFileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 @@0 @@0 \@0 "@0  @0  @0&"@;&\@4 @@0 @@0???0???0')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

exeFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self exeFileIcon inspect
     ImageEditor openOnClass:self andSelector:#exeFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow exeFileIcon'
        ifAbsentPut:[(Depth2Image width:20 height:19) bits:(ByteArray fromPackedString:'UUUUUUU@@@@UUT@@@AEUP@@@DEU@@@@PET@@@AUUQUUUP@UF**)@ATUUUT@EQ???P@UG??=@AT_??4@EQ???P@UG??=@AT_??4@EQUUUP@U@@@@@AUUUUUUU
UUUUUUTb')
            colorMapFromArray:#[255 255 255 0 0 0 0 127 127 170 170 170]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

fileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#fileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow fileIcon'
        ifAbsentPut:[(Depth1Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 @@0 @@0 @@0 @@0 @@0 @@0 @@; @@4 @@0 @@0???0???0') ; colorMap:((OrderedCollection new add:(Color white); add:(Color black); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0') ; yourself); yourself]
!

hFileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#hFileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow hFileIcon'
        ifAbsentPut:[(Depth1Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8  @0  @0 ,@0 2@0 "@0 "@0&"@;&"@4 @@0 @@0???0???0'); colorMap:((OrderedCollection new add:(Color white); add:(Color black); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

htmlFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self htmlFileIcon inspect
     ImageEditor openOnClass:self andSelector:#htmlFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow htmlFileIcon'
        ifAbsentPut:[(Depth4Image width:20 height:19) bits:(ByteArray fromPackedString:'
DQDQDQDQDQDQDQ????????DQDQD_???????1@QDQG???L3L3<P@QDQ??L3=DL3D@@QD_?3L?P3L1DQDQG?L3MCP3L1DQDQ?3QCQCMCP??1D_<4P4QDL4O?<Q
G?L4QDL3MD??DQ?3L3QCL3S??1D_<3L4QDL4O?<QG?<3QDQCMO??DQ??L4QDP4S??1D_??=D??S???<QG???????????DQ???????????1DQDQDQDQDQDQDQ
DQDQDQDQDQDQDP@a')
            colorMapFromArray:#[255 255 255 0 0 0 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

imageFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageFileIcon inspect
     ImageEditor openOnClass:self andSelector:#imageFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow imageFileIcon'
        ifAbsentPut:[(Depth4Image width:20 height:19) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@DQDQDQDQ@@@@@ADQDQDQDPD@@@@QDQDQDQDAD@@@DQDQDQDQ@QD@@ADQDQDQDP@@@@@TQG]4)G50@@@@EDQ7^$+W4QDP@AQD]7R$_WDQD@
@SL6Y#$61!!DQ@@D3M&ZS''F0QDP@AL3Y&NS[FDQD@@RH%UR %-QDQ@@D"IUVB"5,QDP@AH"UUJBV5DQD@@QDQDQDQDQDQ@@DQDQDQDQDQDP@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

imgFileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#imgFileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow imgFileIcon'
        ifAbsentPut:[(Depth1Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8  @0 @@0!!-F0 **0 **0 **0&**;&*&4 @B0 @N0???0???0'); colorMap:((OrderedCollection new add:(Color white); add:(Color black); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

linkedFileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#linkedFileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow linkedFileIcon'
        ifAbsentPut:[(Depth2Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'UUUUUUU@@@@UUT@@@AEUP@@@DEU@@@@PET@@@AUUP@@@AUU@@@@@AT@@@@ EP@@@B U@@@**!!T@@J**EP@B B UB*(@HATJ*@@@EP@@@@@U@@@@@AUUUUUUUUUUUUUTb') ; colorMap:((OrderedCollection new add:(Color white); add:(Color black); add:(Color red:0.0 green:0.0 blue:100.0); add:(Color red:100.0 green:0.0 blue:0.0); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0') ; yourself); yourself]
!

lockedFileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#lockedFileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow lockedFileIcon'
        ifAbsentPut:[(Depth2Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'UUUUUUU(@@@UUT(@@AEUP(@@DEU@(@@PET@(@IUUP@(B!!UU@@((@AT@@*@@EP@B(@@U@@((@AT@J@(@EPB @(@U@(@@(ATJ@@@(ER @@@(U(@@@@)UUUUUUUUUUUUUTb') ; colorMap:((OrderedCollection new add:(Color white); add:(Color black); add:(Color red:100.0 green:0.0 blue:0.0); add:(Color red:0.0 green:100.0 blue:0.0); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0') ; yourself); yourself]
!

protoFileIcon

    ^self MakefileIcon
!

rcFileIcon
    "Generated by the Image Editor"
    "
    ImageEditor openOnClass:self andSelector:#rcFileIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'DirectoryView::FileRow rcFileIcon'
        ifAbsentPut:[(Depth1Image new) width: 20; height: 19; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 @@0 @@0 ) 0 2P0 "@0 "@0&"P;&!! 4 @@0 @@0???0???0') ; colorMap:((OrderedCollection new add:(Color white); add:(Color black); yourself)); mask:((ImageMask new) width: 20; height: 19; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0') ; yourself); yourself]
!

sFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sFileIcon inspect
     ImageEditor openOnClass:self andSelector:#sFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow sFileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 @@0 @@0 X@0  @0 0@0 X@0&H@;&0@4 @@0 @@0???0???0')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

stFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stFileIcon inspect
     ImageEditor openOnClass:self andSelector:#stFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow stFileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 A@0 A@0 [00 !!@0 1@0 Y@0&I@;&004 @@0 @@0???0???0')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
!

stcFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stcFileIcon inspect
     ImageEditor openOnClass:self andSelector:#stcFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryView::FileRow stcFileIcon'
        ifAbsentPut:[(Depth1Image width:20 height:19) bits:(ByteArray fromPackedString:'???9 @_0 @W2 @S0 @Q0 @_0 @O8 B@0 B@0 _L0 "R0 2P0 ZP0&JR;&3L4 @@0 @@0???0???0')
            colorMapFromArray:#[255 255 255 0 0 0]
            mask:((ImageMask width:20 height:19) bits:(ByteArray fromPackedString:'??0@??8@??<@??>@???@??? ???0???0???0???0???0???0???0???0???0???0???0???0_??0'); yourself); yourself]
! !

!DirectoryView::FileRow methodsFor:'accessing'!

baseName

    ^baseName ? (baseName := fileName baseName)







!

fileName

    ^fileName
!

fileName: aFileName

    fileName := aFileName
!

group

    ^group
!

iconOn:aGC

    |icon|
    iconKey isNil 
    ifTrue: 
    [
        self validateAttributes.
        (imageFromFile isNil and: [iconKey == #imageFileIcon])
            ifTrue:  [icon := self retrieveImageFromFileAndRegisterOn: aGC]
    ].
    imageFromFile == true
        ifFalse: [icon := aGC registerImage: (self class perform: iconKey) key: iconKey]
        ifTrue:  [icon := aGC registeredImageAt: iconKey].
    ^icon

    "Modified: / 18.2.1998 / 18:01:52 / cg"
!

modified

    ^modified
!

owner

    ^owner
!

permissions

    ^permissions
!

retrieveImageFromFileAndRegisterOn: aGC
    "retrieve a bitmap image - but only if it is smaller than some limit (currently 20k)"

    |image maxImageFileSize|

    maxImageFileSize := MaxImageFileSize ? 20000.

    imageFromFile := false.       
    (image := aGC registeredImageAt: fileName name asSymbol) isNil
    ifTrue:[            
        size < maxImageFileSize ifTrue:[     
            Error handle: [:ex|]
            do:[   
                (image := Image fromFile: fileName name) notNil ifTrue:[
                    image extent y > 22 ifTrue:[         
                        image := image magnifiedBy: 22/image extent y
                    ].
                    image := aGC registerImage: image key: fileName name asSymbol.
                ]
            ] 
        ].
    ].
    image notNil ifTrue: [imageFromFile := true. iconKey := fileName name asSymbol].
    ^image
!

size
    size isNumber ifFalse:[^ size].
    size < 1000        ifTrue: [^ size printString].
    size < (100*1024)  ifTrue: [^(((size/1024) * 10) asInteger/10) asFloat printString, ' Kb'].
    size < (1000*1024) ifTrue: [^(((size/1024)) asInteger) printString, ' Kb'].
    ^(((size/1048576) * 10) asInteger/10) asFloat printString, ' Mb'

    "Modified: / 6.2.1998 / 03:38:45 / cg"
! !

!DirectoryView::FileRow methodsFor:'private'!

validateAttributes
    |info mode suffix| 

    permissions := '---------' copy.

    (info := fileName info) isNil ifTrue:[
        iconKey := #lockedFileIcon.
        size    := owner := group := '?'.
        ^ self
    ].        
    size   := info size.
    modified := info modificationTime printString.
    owner  := OperatingSystem getUserNameFromID: info uid.
    group  := OperatingSystem getGroupNameFromID: info gid.
    mode   := info mode.

    1 to:9 by:3 do:[:i|
        #((0 $x) (1 $w) (2 $r)) do:
        [:m|
            (mode bitAt:i + m first) == 1 ifTrue:[permissions at: 10 - m first - i put: m last]
        ]
    ].

    fileName isReadable ifFalse:[
        ^ iconKey := #lockedFileIcon
    ].
    info type == #symbolicLink ifTrue:[
        ^ iconKey := #linkedFileIcon
    ].
    suffix := fileName suffix.

    ((self class respondsTo:(iconKey := (suffix, 'FileIcon') asSymbol))
        or: [self class respondsTo: (iconKey := (fileName baseName, 'Icon') asSymbol)]
    ) ifFalse:[
        iconKey := #fileIcon.
        ((suffix = 'o') or:[suffix = 'so']) ifTrue: [
            ^ iconKey := #binaryFileIcon
        ].
        (Image isImageFileSuffix:suffix) ifTrue: [
            ^ iconKey := #imageFileIcon
        ].

        fileName isExecutableProgram ifTrue:[
            ^ iconKey := #exeFileIcon
        ]
    ]
! !

!DirectoryView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

