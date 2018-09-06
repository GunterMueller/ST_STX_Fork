"{ NameSpace: DB }"

Object subclass:#ODBCInterface
	instanceVariableNames:'dataSources connections resourceFile sqlErrorInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Interface'
!

!ODBCInterface class methodsFor:'documentation'!

documentation
"
    documentation to be added.
"
!

examples
"
    examples to be added.
"
!

history
    "Created: 3.8.1996 / 12:00:18 / ah"
! !

!ODBCInterface class methodsFor:'instance creation'!

new
   "create new odbc interface"

   ^ super new initialize.                   
! !

!ODBCInterface methodsFor:'accessing'!

resourceFile
    ""

    ^ resourceFile.



!

resourceFileBaseName

    self resourceFile isNil ifTrue: [
        ^ nil.
    ].

    ^ (self resourceFile asFilename) baseName.
! !

!ODBCInterface methodsFor:'cleanup'!

destroy
    ""

   dataSources do: [:ds |
       ds driverInst notNil ifTrue: [
           ds driverInst sqlDisconnect: ds handle.
       ].
   ].

! !

!ODBCInterface methodsFor:'debugging'!

driverDebugOff

    dataSources do:[ :ds |
        ds driverInst notNil ifTrue: [
            ds driverInst sqlDebugOff.
        ].
    ].

!

driverDebugOn

    dataSources do:[ :ds |
        ds driverInst notNil ifTrue: [
            ds driverInst sqlDebugOn.
        ].
    ].

! !

!ODBCInterface methodsFor:'dialogs'!

createTableDialog
    "
    "
    | box scr v table col tabSpec p tableName queryString label field hPanel
      row rowNo|

    '
     the data ...
    '.
    table := (1 to: 2) collect:[ :n |
        | d |
        d := Dictionary new.
        d at:#ColumnName     put:'example'.
        d at:#ColumnDataType put:'char'.
        d at:#ColumnDataSize put:10.
        d
    ].


    '
     the table specification object ...    '.
    tabSpec := TableSpecification new.
    tabSpec numberOfStableColumns: 2.
    tabSpec contents:table.
    tabSpec elementClass:Dictionary.

    '
     the top row, with handles to change relative sizes
    '.
    tabSpec add:(TableRowHandle numbers:true).

    '
     the columns ...
    '.
    col := TableColumnSpecification new.
    col width:100.
    col title:#ColumnName.
"/    col leaveCheckBlock:[ :row :value | 
"/        (Object errorSignal handle:[:ex | ex returnWith:2000] do:[value asInteger]) < 1000.
"/    ].
    tabSpec add: col.

    '
     a special column - does not have an entryField, but a popUpList instead
    '.
    p := PopUpList label:'data type of field ?'.
    p list:#('char' 'int' 'real').
    p sizeFixed:true.

    col := TableColumnSpecification new.
    col width:70.
    col title:#ColumnDataType.
    col interactorView:p.
    tabSpec add: col.

    col := TableColumnSpecification new.
    col width:70.
    col title:#ColumnDataSize.
    tabSpec add: col.

    '
     a topView,
    '.
    box := DialogBox new.
    box label:'Table Definition Dialog'.

    hPanel := HorizontalPanelView new.
    hPanel layout: #left.

    label := Label in:hPanel.
    label label:' table name : '.

    field := EditField origin:0.0@((label width) + 5) in: hPanel.
    field width:1.0.         

    box addComponent: hPanel.
    '
     create the tableView and a scroller around ...
    '.
    v := TableView tableSpecification:tabSpec.
"/    scr := ScrollableView extent:(1.0 @ 200).
    scr := ScrollableView new.
    scr scrolledView:v.
    scr scrollBar asynchronousOperation.

    box addComponent:scr  withExtent:(395 @ 120).

    box addAbortButton.
    box addOkButton.

    box minExtent: (400 @ 190).
    box maxExtent: (400 @ 190).

"/    box sizeFixed: true.

    box open.

    box accepted ifTrue:[
        rowNo := 1.
        (tableName := field contents) isEmpty ifTrue: [
            ^ nil.
        ].

        queryString := 'create table ', tableName, '('.
        [rowNo ~~ (v size + 1)] whileTrue: [
            row notNil ifTrue: [
                queryString := queryString, ', '.
            ].
            row := v at: rowNo.
            rowNo := rowNo + 1.
            queryString := queryString, (row at: #ColumnName), ' '.
            ((row at: #ColumnDataType) = 'char') ifTrue: [
                queryString :=  queryString, 
                                (row at: #ColumnDataType), 
                                '('.
                queryString :=  queryString, 
                                (row at: #ColumnDataSize) printString,
                                ')'.
            ] ifFalse: [
                queryString := queryString, (row at: #ColumnDataType).
            ].
        ].
        queryString := queryString, ')'.

    ].

    ^ queryString.

    " 
    ODBCInterface new createTableDialog
    "
!

enterQueryDialog
    "
    "
    | box infoView query|

    box := DialogBox new.

    box addTextLabel: 'Enter SQL query:'.
    box addHorizontalLine.

    infoView := EditTextView new.
    infoView backgroundColor:Color blue.
    infoView foregroundColor:Color white.

    box addComponent:infoView indent:10 withExtent: 200 @ 80. 

    box addHorizontalLine.

    box addAbortButton.
    box addOkButton.

    box open.

    box accepted ifTrue:[
        query := ''.
        (infoView contents asCollectionOfLines) do: [:l|
            query := query, l withoutSeparators.
        ].

        ^ query.
    ] ifFalse: [
        ^ nil.
    ].

"
create table bubble (
        name char(15),
        num int
)

"
!

showTableDialog: aTableDescr withContents: aTableCont
    "
    "
    | box scr v table col tabSpec p tableName queryString label field hPanel
      row rowNo|

    '
     the description
    '.

    table := (1 to: aTableDescr size) collect:[ :n |
        | d c |
        c := aTableDescr at: n.
        d := Dictionary new.
        d at:#ColumnName     put:(c at: 2).
        d at:#ColumnDataType put:(c at: 1).
        d at:#ColumnDataSize put:10.
        d
    ].

    '
     the table specification object ...    '.
    tabSpec := TableSpecification new.
    tabSpec numberOfStableColumns: 2.
    tabSpec contents:table.
    tabSpec elementClass:Dictionary.

    '
     the top row, with handles to change relative sizes
    '.
    tabSpec add:(TableRowHandle numbers:true).

    '
     the columns ...
    '.
    self halt.

    ^ false.
    col := TableColumnSpecification new.
    col width:100.
    col title:#ColumnName.
"/    col leaveCheckBlock:[ :row :value | 
"/        (Object errorSignal handle:[:ex | ex returnWith:2000] do:[value asInteger]) < 1000.
"/    ].
    tabSpec add: col.

    '
     a special column - does not have an entryField, but a popUpList instead
    '.
    p := PopUpList label:'data type of field ?'.
    p list:#('char' 'int' 'real').
    p sizeFixed:true.

    col := TableColumnSpecification new.
    col width:70.
    col title:#ColumnDataType.
    col interactorView:p.
    tabSpec add: col.

    col := TableColumnSpecification new.
    col width:70.
    col title:#ColumnDataSize.
    tabSpec add: col.

    '
     a topView,
    '.
    box := DialogBox new.
    box label:'Table Definition Dialog'.

    hPanel := HorizontalPanelView new.
    hPanel layout: #left.

    label := Label in:hPanel.
    label label:' table name : '.

    field := EditField origin:0.0@((label width) + 5) in: hPanel.
    field width:1.0.         

    box addComponent: hPanel.
    '
     create the tableView and a scroller around ...
    '.
    v := TableView tableSpecification:tabSpec.
"/    scr := ScrollableView extent:(1.0 @ 200).
    scr := ScrollableView new.
    scr scrolledView:v.
    scr scrollBar asynchronousOperation.

    box addComponent:scr  withExtent:(395 @ 120).

    box addAbortButton.
    box addOkButton.

    box minExtent: (400 @ 190).
    box maxExtent: (400 @ 190).

"/    box sizeFixed: true.

    box open.

    box accepted ifTrue:[

    ].

    self halt.
! !

!ODBCInterface methodsFor:'initialization'!

initialize
    ""

    dataSources := OrderedCollection new.
    connections := Dictionary new.
! !

!ODBCInterface methodsFor:'private'!

isResourceFileValid: aFileNameString
    aFileNameString isNil ifTrue: [
        ^ false.
    ].

    ^ ((aFileNameString asFilename suffix) = 'dsrc').
! !

!ODBCInterface methodsFor:'private accessing'!

resourceFile:something
    "set resourceFile"

    resourceFile := something.!

sqlErrorInfo: aErrorInfo
    "set sqlErrorInfo"

    sqlErrorInfo := aErrorInfo.
! !

!ODBCInterface methodsFor:'private data source handling'!

createDataSource
   "create new data source"

    ^ self setupDatasourceDialog: nil




!

deleteDataSource: aDataSource
    "delete a dataSource"
    |driver|
    dataSources do: [:ds|
        (ds name = aDataSource string) ifTrue: [

            (driver := ds driverInst) isNil ifTrue: [
                ^ false.
            ].

            (driver sqlDropDB: (ds name) onService: (ds handle)) ifFalse: [
                     ^ false.    
            ].

             driver sqlClose: ds handle.

             dataSources remove: ds 
                       ifAbsent: [].
             ^ true.
        ]
    ].

    ^ false.




!

deselectDataSource: aDataSource
    "deselect a dataSource"

    |driver handle|

    dataSources do: [:ds |
        (ds name = aDataSource string) ifTrue: [

            (driver := ds driverInst) isNil ifTrue: [
                ^ nil.
            ].

            (driver sqlClose: ds handle) ifTrue: [
                ^ nil.    
            ].
        ].
    ].

    ^ nil.





!

selectDataSource: aDataSource
    "select a dataSource and return a ODBC 
     database handle or nil"

    |driver handle error|

    dataSources do: [:ds |
        (ds name = aDataSource string) ifTrue: [

            (driver := ds driverInst) isNil ifTrue: [
                ^ nil.
            ].

            (handle := driver sqlConnect: ds host) = -1 ifTrue: [
                ^ nil.    
            ].

            ds handle: handle.

            (driver sqlSelectDB: (ds name) onStream: handle) ifFalse: [
                (driver sqlCreateDB: (ds name) onService: handle) ifFalse: [    
                     driver sqlClose: handle.
                     ^ nil.    
                ].
            ].

            ^ handle.
        ].
    ].

    ^ nil.


!

setupDataSource: aDataSource
   " setup a existant data source"

    aDataSource isNil ifTrue: [
         ^ self setupDatasourceDialog: aDataSource.
    ].

    dataSources do: [:ds|
        (ds name = aDataSource string) ifTrue: [
            ^ self setupDatasourceDialog: ds.
        ].
    ].

    ^ nil.
!

setupDataSource: aDataSource fromLine: aLine
    |key attribute idxEnd idxStart|

    idxEnd := 1.
    key := nil.

    [(idxStart := aLine indexOfNonSeparatorStartingAt:idxEnd) ~~ 0] whileTrue: [
         (idxEnd := aLine indexOfSeparatorStartingAt:idxStart) == 0 ifTrue: [
             idxEnd := aLine size + 1.   
         ].
         key := (aLine copyFrom:idxStart to:idxEnd -1).

         [(idxStart := aLine indexOfNonSeparatorStartingAt:idxEnd) ~~ 0] whileTrue: [
             (idxEnd := aLine indexOfSeparatorStartingAt:idxStart) == 0 ifTrue: [
                 idxEnd := aLine size + 1.   
             ].
             attribute := (aLine copyFrom:idxStart to:idxEnd -1).
             (key = 'dataSourceName:') ifTrue: [
                 aDataSource name: attribute.
             ].
             (key = 'driver:') ifTrue: [
                 aDataSource driver: attribute.
             ].
             (key = 'hostname:') ifTrue: [
                 aDataSource host: attribute.
             ].
             (key = 'dataBaseId:') ifTrue: [
                 aDataSource databaseId: attribute.
             ].
             (key = 'description:') ifTrue: [
                 aDataSource description: attribute.
             ].
         ].
    ].

! !

!ODBCInterface methodsFor:'private dialogs'!

selectResourceFileDialog
    |box|

    box := FileSelectionBox new.
    box title:'Select Resource File ?'.
    box pattern:'*.dsrc'.
    box open.

    box accepted ifTrue:[
        ^ box fileName
    ].

    ^ nil.

!

setupDatasourceDialog: aDataSource
    "
    "
    | box dataSourceHolder driverHolder hostnameHolder 
     dataBaseIdHolder descriptionHolder ds |

    aDataSource notNil ifTrue: [
        dataSourceHolder  := aDataSource name asValue.
        driverHolder      := aDataSource driver asValue.
        hostnameHolder    := aDataSource host asValue.
        dataBaseIdHolder  := aDataSource databaseId asValue.
        descriptionHolder := aDataSource description asValue.
    ] ifFalse: [
        dataSourceHolder  := '' asValue.
        driverHolder      := '' asValue.
        hostnameHolder    := '' asValue.
        dataBaseIdHolder  := '' asValue.
        descriptionHolder := '' asValue.
    ].

    box := DialogBox new.
    box 
        addLabelledInputField:'Data Source Name:'
        adjust:#right
        on:dataSourceHolder
        tabable:true
        separateAtX:0.4.

    box 
        addLabelledInputField:'Driver Name:'
        adjust:#right
        on:driverHolder
        tabable:true
        separateAtX:0.4.

    box 
        addLabelledInputField:'Host Name:'
        adjust:#right
        on:hostnameHolder
        tabable:true
        separateAtX:0.4.

    box 
        addLabelledInputField:'Database ID:'
        adjust:#right
        on:dataBaseIdHolder
        tabable:true
        separateAtX:0.4.

    box 
        addLabelledInputField:'Description:'
        adjust:#right
        on:descriptionHolder
        tabable:true
        separateAtX:0.4.

    box addAbortButton.
    box addOkButton.
    box open.

    box accepted ifTrue:[
        aDataSource notNil ifTrue: [
            (aDataSource name = dataSourceHolder value) ifTrue: [
                aDataSource driver:      driverHolder value.
                aDataSource host:        hostnameHolder value.
                aDataSource databaseId:  dataBaseIdHolder value.
                aDataSource description: descriptionHolder value.
                ^ nil.
            ].

            ds := ODBCDataSource new.

            ds name:        dataSourceHolder value.
            ds driver:      driverHolder value.
            ds host:        hostnameHolder value.
            ds databaseId:  dataBaseIdHolder value.
            ds description: descriptionHolder value.

            dataSources add: ds.
        ].
    ] ifFalse: [
        ^ nil.
    ].

    ^ dataSourceHolder value
! !

!ODBCInterface methodsFor:'private resource file handling'!

readSetupFromFile

    |stream line key ds idxEnd idxStart|

    resourceFile isNil ifTrue: [
        ^ false.
    ].

    (stream := FileStream readonlyFileNamed: resourceFile) isNil ifTrue: [
        ^ false.
    ].

    dataSources := OrderedCollection new.

    [stream atEnd] whileFalse: [
        line := stream nextLine.

        "/ a line starting with # is a comment

        (line startsWith: '#') ifFalse: [
            (line startsWith: 'DataSourceDefinitionStart') ifTrue: [
                ds := ODBCDataSource new.
            ] ifFalse: [
                (line startsWith: 'DataSourceDefinitionStop') ifTrue: [
                    dataSources add: ds.
                ] ifFalse: [
                    self setupDataSource: ds fromLine: line.
                ]
            ].
        ].
    ].

    stream close.

    ^ true.
!

saveSetupToFile

    |stream|

    resourceFile isNil ifTrue: [
        ^ false.
    ].

    (stream := FileStream fileNamed: resourceFile) isNil ifTrue: [
        ^ false.
    ].

    dataSources do: [:ds |
        ds printToStream: stream.
    ].

    stream close.

    ^ true.
!

saveSetupToNewFile

    |stream box file|

    box := FileSelectionBox new.
    box title:'Save to Resource File ?'.
    box pattern:'*.dsrc'.
    box open.
    box accepted ifTrue:[
        (self isResourceFileValid: box fileName) ifFalse: [
             ^ false.
        ].

        file := box fileName.
    ] ifFalse: [
        ^ false.
    ].

    (stream := FileStream fileNamed: file) isNil ifTrue: [
        ^ false.
    ].

    dataSources do: [:ds |
        ds printToStream: stream.
    ].

    stream close.

    ^ true.
! !

!ODBCInterface methodsFor:'queries'!

dataSourceConnected: aDataSourceName

    ^ (connections includesKey: aDataSourceName string).
! !

!ODBCInterface methodsFor:'sql'!

sqlAllocConnect: aDataSourceName
    ""
    self sqlErrorInfo: nil.

    aDataSourceName isNil ifTrue: [
        self sqlErrorInfo: ('Datasource name is nil.').

        ^ false.
    ].

    dataSources do: [:ds|
        (ds name = aDataSourceName string) ifTrue: [

            ds driver = 'mSQL' ifTrue: [
                ds driverInst: ODBCInterfaceMSQL new.
                ^ true.
            ].
        ].
    ].

    self sqlErrorInfo: ('Datasource ', aDataSourceName string, ' not valid').

    ^ false.
!

sqlAllocEnv: aResourceFileName
    ""
    | file |

    self sqlErrorInfo: nil.

    self resourceFile isNil ifFalse: [
        self sqlErrorInfo: ('Resource is not unloaded, please unload first.').
        ^ false.
    ].

    aResourceFileName isNil ifTrue: [
        file := self selectResourceFileDialog.
    ] ifFalse: [
        file := aResourceFileName.
    ].

    (self isResourceFileValid: file) ifFalse: [
        file isNil ifFalse: [
            self sqlErrorInfo: ('Resource filename ',
                               file asFilename baseName,
                               ' is not valid.').
        ].
        ^ false.
    ].

    self resourceFile: file.

    (self readSetupFromFile) ifFalse: [
        self sqlErrorInfo: ('Resource filename ',
                           file asFilename baseName,
                           ' corrupted.').
        ^ false.
    ].

    ^ true.
!

sqlConfigDataSource: aDataSourceName
    " "
    ^ self setupDataSource: aDataSourceName

!

sqlConnect: aDataSourceName
    ""
    |handle|

    self sqlErrorInfo: nil.

    aDataSourceName isNil ifTrue: [
        self sqlErrorInfo: ('Datasource name is nil.').

        ^ false.
    ].

    dataSources do: [:ds|
        (ds name = aDataSourceName string) ifTrue: [
            (connections includesKey: ds name) ifTrue: [
                self sqlErrorInfo: ('dataSource is currently connected.').
                ^ false.
            ].

            ((handle := ds driverInst sqlConnect: ds host) ~~ -1) ifTrue: [
                (ds driverInst sqlSelectDB: (ds databaseId) onService: handle) ifFalse: [
                    (ds driverInst sqlCreateDB: (ds databaseId) onService: handle) ifFalse: [
                        self halt.
                        ds driverInst sqlDisconnect: handle.
                        ^ false.
                    ].
                ].

                connections at: (ds name) put: ds.
                ds handle: handle.
                ^ true.
            ] ifFalse: [
                ^ false.
            ].
        ].
    ].

    self sqlErrorInfo: ('Datasource ', aDataSourceName string, ' not valid').

    ^ false.
!

sqlDataSources
    "return a collection of the defined data source names"
    |col|

    col := OrderedCollection new.

    dataSources do: [:ds |
        col add: (ds name).
   ].

    ^ col.
!

sqlDisconnect: aDataSourceName
    ""
    |ds|

    aDataSourceName isNil ifTrue: [
        self sqlErrorInfo: ('Datasource name is nil.').

        ^ false.
    ].

    (ds := connections at: aDataSourceName string) isNil ifFalse: [
        (ds driverInst sqlDisconnect: ds handle) ifTrue: [
            ^ true.
        ].
        self sqlErrorInfo: ('Can`t disconnect dataSource ',
                            ds name,
                            '.').
        ^ false.
    ].

    self sqlErrorInfo: ('dataSource is not connected.').

    ^ false.
!

sqlError
    ""
    ^ sqlErrorInfo.
!

sqlExecDirect: aDataSourceName query: aQueryString
    ""
    |handle ds|

    self sqlErrorInfo: nil.

    aDataSourceName isNil ifTrue: [
        self sqlErrorInfo: ('DataSource is nil.').

        ^ false.
    ].

    aQueryString isNil ifTrue: [
        self sqlErrorInfo: ('QueryString is nil.').

        ^ false.
    ].

    (ds := connections at: aDataSourceName string) isNil ifFalse: [

        (ds driverInst sqlQuery: aQueryString onService: ds handle) ifFalse: [
            self sqlErrorInfo: ('execution of query ', 
                                aQueryString, 
                                ' failed.',
                                (ds driverInst sqlErrMsg)).
            ^ false.
        ].
    ].

    ds driverInst sqlStoreResult. 

    ^ true.
!

sqlFetchField: aDataSourceName
    ""
    |ds|
    (ds := connections at: aDataSourceName string) isNil ifFalse: [
        ^ ds driverInst sqlFetchField. 
    ].

    ^ nil.
!

sqlFetchRow: aDataSourceName
    ""
    |ds|
    (ds := connections at: aDataSourceName string) isNil ifFalse: [
        ^ ds driverInst sqlFetchRow. 
    ].

    ^ nil
!

sqlFieldSeek: aDataSourceName offset: aOffset
    ""
    |ds|
    (ds := connections at: aDataSourceName string) isNil ifFalse: [
        ^ ds driverInst sqlFieldSeek: aOffset. 
    ].

    ^ nil.
!

sqlFreeConnect: aDataSourceName
    ""

    sqlErrorInfo := nil.

    connections removeKey:( aDataSourceName string) ifAbsent: [].

    ^ true.
!

sqlFreeEnv
    ""

    sqlErrorInfo := nil.

    self resourceFile: nil.

    dataSources := OrderedCollection new.
    connections := Dictionary new.

    ^ true.
!

sqlListFields: aDataSourceName table: aTable
    ""
    |handle ds tL fieldCol fieldDescr|

    self sqlErrorInfo: nil.

    fieldCol := OrderedCollection new.

    aDataSourceName isNil ifTrue: [
        ^ fieldCol.
    ].

    (ds := connections at: aDataSourceName string) isNil ifFalse: [

        (ds driverInst sqlListFields: ds handle inTable: (aTable string)) ifFalse: [
            self sqlErrorInfo: ds driverInst sqlErrMsg.
            ^ nil.
        ] ifTrue: [

            [(fieldDescr := self sqlFetchField: aDataSourceName) isNil] whileFalse: [
                fieldCol add: fieldDescr.
            ].

            ^ fieldCol.
        ].
    ].

    ^ fieldCol.
!

sqlListTables: aDataSourceName
    ""
    |handle ds tL tabCol row|

    self sqlErrorInfo: nil.

    tabCol := OrderedCollection new.

    aDataSourceName isNil ifTrue: [
        ^ tabCol.
    ].

    (connections includesKey: aDataSourceName string) ifFalse: [
        ^ tabCol.
    ].

    (ds := connections at: aDataSourceName string) isNil ifFalse: [

        (ds driverInst sqlListTables: ds handle) ifFalse: [
            self sqlErrorInfo: ds driverInst sqlErrMsg.
            ^ tabCol.
        ] ifTrue: [

            [(row := self sqlFetchRow: aDataSourceName) isNil] whileFalse: [
                tabCol add: row.
            ].

            ^ tabCol.
        ].
    ].

    ^ tabCol.
!

sqlSaveEnv: aResourceFileName
    ""

    sqlErrorInfo := nil.

    aResourceFileName isNil ifTrue: [
        ^ self saveSetupToNewFile.
    ].

    ^ self saveSetupToFile.
! !

!ODBCInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCInterface.st,v 1.1 1997-01-13 17:53:19 ah Exp $'
! !
