"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libodbc/applications' }"

"{ NameSpace: SQL }"

AdaptableApplicationModel subclass:#ODBCSQLScratchpad
	instanceVariableNames:'odbcHandle sqLiteHandle connectionInformationApp sqlEditorView
		activeCursor infoHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-ODBC-Application'
!

!ODBCSQLScratchpad class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    documentation to be added.

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ODBCSQLScratchpad class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCSQLScratchpad andSelector:#windowSpec
     SQL::ODBCSQLScratchpad new openInterface:#windowSpec
     SQL::ODBCSQLScratchpad open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SQL::ODBCScratchPad'
          name: 'SQL::ODBCScratchPad'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 300 300)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (WorkspaceSpec
              name: 'SQLEditor'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              postBuildCallback: postBuildSQLEditor:
            )
           )
         
        )
      )
! !

!ODBCSQLScratchpad methodsFor:'accessing'!

connectionInformationApp
    ^ connectionInformationApp
!

connectionInformationApp:something
    connectionInformationApp := something.
!

defaultFileNameForFileDialog:aPath
     sqlEditorView defaultFileNameForFileDialog:aPath
!

getConnectionOrNil
    sqLiteHandle notNil ifTrue:[^ sqLiteHandle].
    odbcHandle notNil ifTrue:[^ odbcHandle].

    ^ self getODBCConnectionOrNil
!

getODBCConnectionOrNil
    odbcHandle notNil ifTrue:[ ^ odbcHandle ].

    sqLiteHandle notNil ifTrue:[
        self disconnect
    ].
    connectionInformationApp:= GetConnectionInformation new.
    (connectionInformationApp open) ifFalse:[^ nil].

    odbcHandle := connectionInformationApp getConnection.
    infoHolder value:'connected with DB "',connectionInformationApp datasource,'".'.
    ^ odbcHandle
!

getSQLiteConnectionOrNil
    |fn|

    sqLiteHandle notNil ifTrue:[ ^ sqLiteHandle ].

    odbcHandle notNil ifTrue:[
        self disconnect
    ].

    fn := Dialog requestFileName:'SQLite Database File:'.
    fn isEmptyOrNil ifTrue:[^ nil].

    sqLiteHandle := SQLiteConnection fileNamed:fn.
    sqLiteHandle open.
    infoHolder value:'connected with SQLite "',fn,'".'.
    ^ sqLiteHandle
!

infoHolder:something
    infoHolder := something.
!

odbcHandle
    ^ odbcHandle
!

odbcHandle:something
    odbcHandle := something.
!

sqlEditorContents:aString
     sqlEditorView contents:aString
! !

!ODBCSQLScratchpad methodsFor:'actions'!

connect
    ^ self getConnectionOrNil
!

connectODBC
    ^ self getODBCConnectionOrNil
!

connectSQLite
    ^ self getSQLiteConnectionOrNil
!

disconnect
    |handle|

    handle := sqLiteHandle ? odbcHandle.
    handle notNil ifTrue:[
        handle disconnect.
        odbcHandle := sqLiteHandle := nil.
        infoHolder value:'disconnected.'
    ].
!

showTables
    |connection tables tableNames tableNamesAsString|

    connection := self getConnectionOrNil.
    connection isNil ifTrue:[^ self].

    self withReadCursorDo:[
        tables := connection tables.
    ].
    tableNames := tables map:#name.
    tableNamesAsString := tableNames asStringCollection asString.

    sqlEditorView showCR:'List of Tables:'.
    sqlEditorView showCR:tableNamesAsString.

    "/ self information:tableNamesAsString.

    "Modified: / 29-11-2013 / 21:47:12 / cg"
! !

!ODBCSQLScratchpad methodsFor:'postBuild'!

postBuildSQLEditor:aScrolledView
    sqlEditorView := aScrolledView scrolledView.

    sqlEditorView acceptAction:[:aList |  self sqlEditorAccept:aList].
    sqlEditorView doItAction:[:aSelection | self sqlEditorDoIt:aSelection].
    sqlEditorView contentsWasSaved:true.
! !

!ODBCSQLScratchpad methodsFor:'queries'!

hasUnsavedChanges
    ^ sqlEditorView contentsWasSaved not
!

isConnected
    ^ odbcHandle notNil or:[sqLiteHandle notNil]
! !

!ODBCSQLScratchpad methodsFor:'sqlEditorActions'!

doIt
    |selection|

    selection := sqlEditorView selectionAsString.
    selection notEmptyOrNil ifTrue:[
        self sqlEditorDoIt:selection
    ]
!

executeSQL:aSQLString 
    |connection stmt cursor |

    connection := self getConnectionOrNil.
    connection isNil ifTrue:[^ nil].

    SQL::SQLError handle:[:ex |
        self warn:ex errorString
    ] do:[
        stmt := connection newStatementFor: aSQLString. 
        cursor := stmt execute.
        ^ cursor
    ].

    ^ nil
!

paste:aString
    sqlEditorView paste:aString
!

save
    sqlEditorView defaultFileNameForFileDialog notNil ifTrue:[
        sqlEditorView saveAs:sqlEditorView defaultFileNameForFileDialog
    ] ifFalse:[
        sqlEditorView save.
    ]
!

saveAs
    sqlEditorView save.
!

sqlEditorAccept:arg
    self save
!

sqlEditorDoIt:aString
    |doItString |

    doItString := aString withoutSeparators.

    "try smalltalk"
    Error handle:[:ex |
        "do nothing"   
    ] do:[
        ^ Parser evaluate:doItString in:thisContext receiver:self notifying:nil logged:nil ifFail:nil compile:false
    ].

    "try SQL"
    activeCursor := self executeSQL:doItString.
    activeCursor isNil ifTrue:[^ nil].
    self changed:#activeCursor with:activeCursor.

    ^ activeCursor
! !

!ODBCSQLScratchpad class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/SQL__ODBCSQLScratchpad.st,v 1.14 2013-11-29 20:47:34 cg Exp $'
! !

