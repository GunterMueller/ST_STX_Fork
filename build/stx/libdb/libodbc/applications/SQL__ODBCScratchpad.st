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

AdaptableApplicationModel subclass:#ODBCScratchpad
	instanceVariableNames:'sqlEditorApplicationHolder sqlResultApplicationHolder infoHolder
		isSetToAutocommitHolder isConnectedHolder updateProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-ODBC-Application'
!

!ODBCScratchpad class methodsFor:'documentation'!

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
!

examples
"
  Starting the application:
                                                                [exBegin]
    SQL::ODBCScratchpad open

                                                                [exEnd]
"
! !

!ODBCScratchpad class methodsFor:'image specs'!

commitSession
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self commitSession inspect
     ImageEditor openOnClass:self andSelector:#commitSession
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCScratchpad class commitSession'
        ifAbsentPut:[(Depth4Image new) width: 18; height: 18; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP
@QDQDP@QDQDP@Q@ADP@QD@DP@QD@DP@Q@ADP@QDP@P@P@QDP@QDQ@@@@DQDP@QDQD@@ADQDP@QDQDP@QDQDP@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 255 0]; yourself]
!

rollbackSession
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rollbackSession inspect
     ImageEditor openOnClass:self andSelector:#rollbackSession
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCScratchpad class rollbackSession'
        ifAbsentPut:[(Depth4Image new) width: 18; height: 18; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@QDQDP@QDQDP@QDQD@@ADQDP@QDQ@@@@DQDP@QDP@P@P@QDP@QD@DP@Q@ADP@Q@ADP@QD@DP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP
@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@QDQDP@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 0 0]; yourself]
! !

!ODBCScratchpad class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCScratchpad andSelector:#windowSpec
     SQL::ODBCScratchpad new openInterface:#windowSpec
     SQL::ODBCScratchpad open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SQL::ODBCScratchpad'
         name: 'SQL::ODBCScratchpad'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 638 610)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0 0 0 0 1 20 0)
             menu: menu
             textDefault: true
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0 20 0 0 1 -30 1)
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'SQL:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         translateLabel: true
                         adjust: left
                       )
                      (SubCanvasSpec
                         name: 'SubCanvas1'
                         layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         clientHolder: sqlEditorApplicationHolder
                         createNewBuilder: false
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'Box2'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Result:'
                         name: 'Label2'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         translateLabel: true
                         adjust: left
                       )
                      (SubCanvasSpec
                         name: 'SubCanvas2'
                         layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         clientHolder: sqlResultApplicationHolder
                         createNewBuilder: false
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (LabelSpec
             label: 'Label'
             name: 'Label3'
             layout: (LayoutFrame 1 0 -29 1 -1 1 -1 1)
             level: -1
             translateLabel: true
             labelChannel: infoHolder
             adjust: left
           )
          )
        
       )
     )
! !

!ODBCScratchpad class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SQL::ODBCScratchpad andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCScratchpad mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'New'
                  itemValue: menuNew
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Open...'
                  itemValue: menuOpen
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save'
                  itemValue: menuSave
                )
               (MenuItem
                  label: 'Save As...'
                  itemValue: menuSaveAs
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Connection'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: isNotConnected
                  label: 'Connect via ODBC...'
                  itemValue: menuConnectODBC
                )
               (MenuItem
                  enabled: isNotConnected
                  label: 'Connect via SQLite...'
                  itemValue: menuConnectSQLite
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isConnected
                  label: 'Disconnect'
                  itemValue: menuDisconnect
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'SQL'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Tables'
                  itemValue: showTables
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Paste Sample Code'
                  itemValue: pasteSampleCode
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Execute Selection'
                  itemValue: menuDoIt
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Debug'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Inspect session'
                  itemValue: inspectSession
                )
               (MenuItem
                  label: 'Inspect New Statement Handle'
                  itemValue: newStatementHandleInspect
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application'
                  itemValue: openAboutThisApplication
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCScratchpad andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCScratchpad menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: isConnectedHolder
            label: 'Doit'
            itemValue: menuDoIt
            translateLabel: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary run16x16Icon)
          )
         (MenuItem
            enabled: isConnectedHolder
            label: 'Commit session'
            itemValue: doCommitSession
            translateLabel: true
            labelImage: (ResourceRetriever #'SQL::ODBCScratchpad' commitSession)
          )
         (MenuItem
            enabled: isConnectedHolder
            label: 'Rollback session'
            itemValue: doRollbackSession
            translateLabel: true
            labelImage: (ResourceRetriever #'SQL::ODBCScratchpad' rollbackSession)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: isConnectedHolder
            label: 'Is set to autocommit'
            itemValue: doToggleAutocommit
            translateLabel: true
            startGroup: right
            hideMenuOnActivated: false
            indication: isSetToAutocommitHolder
            labelImage: (ResourceRetriever SystemBrowser traceIcon)
            choiceValue: false
            showBusyCursorWhilePerforming: true
          )
         )
        nil
        nil
      )
! !

!ODBCScratchpad methodsFor:'actions'!

doCommitSession
    self odbcHandle commit
!

doRollbackSession
    self odbcHandle rollback
!

doToggleAutocommit
    |odbcHandle|
    odbcHandle := self odbcHandle.
    odbcHandle autocommit = 'on' ifTrue:[
        odbcHandle autocommit:'off'.
        ^ self
    ].

    odbcHandle autocommit:'on'.
!

odbcHandle
    ^self sqlEditor odbcHandle
!

startUpdateProcess
    updateProcess notNil ifTrue:[  
        "need to kill old process"
        self halt.
    ].

    updateProcess := [
        [
            self checkIfAutoconnected.
            Delay waitForSeconds:2.
        ] loop
    ] forkAt:(Processor activePriority - 1).
! !

!ODBCScratchpad methodsFor:'aspects'!

infoHolder
    infoHolder isNil ifTrue:[
        infoHolder := ValueHolder new.
    ].
    ^ infoHolder.
!

isConnected
    ^ self sqlEditor isConnected
!

isConnectedHolder

    isConnectedHolder isNil ifTrue:[
        isConnectedHolder := false asValue.
    ].
    ^ isConnectedHolder
!

isNotConnected
    ^ self sqlEditor isConnected not
!

isSetToAutocommit
    ^ false asValue
!

isSetToAutocommitHolder
    isSetToAutocommitHolder isNil ifTrue:[
        isSetToAutocommitHolder := false asValue
    ].

    ^ isSetToAutocommitHolder
!

sqlEditor
    ^ self sqlEditorApplicationHolder value
!

sqlEditorApplicationHolder
    |editor|

    sqlEditorApplicationHolder isNil ifTrue:[
        sqlEditorApplicationHolder := ValueHolder with:(editor := ODBCSQLScratchpad new).
        editor addDependent:self.
        editor infoHolder:self infoHolder.
    ].
    ^ sqlEditorApplicationHolder.
!

sqlResultApplicationHolder
    sqlResultApplicationHolder isNil ifTrue:[
        sqlResultApplicationHolder := ValueHolder with:(ODBCResultTableTab new).
    ].
    ^ sqlResultApplicationHolder.
! !

!ODBCScratchpad methodsFor:'change & update'!

checkIfAutoconnected
    |odbcHandle|
    odbcHandle := self odbcHandle.
    odbcHandle  isNil ifTrue:[
        self isConnectedHolder value:false.
        ^ self
    ].

    self isConnectedHolder value:true.

    isSetToAutocommitHolder value:(odbcHandle autocommit = 'on').
!

update:something with:aParameter from:changedObject
    something == #activeCursor ifTrue:[
        self sqlResultApplicationHolder value activeCursor:aParameter
    ].

    super update:something with:aParameter from:changedObject
! !

!ODBCScratchpad methodsFor:'initialization & release'!

closeDownViews
    updateProcess terminate.
     super closeDownViews
!

closeRequest
    self hasUnsavedChanges ifTrue:[
        (self confirm:(resources string:'Close without saving ?')) ifFalse:[
            ^ self
        ]
    ].

    ^ super closeRequest
!

hasUnsavedChanges
    ^ self sqlEditor hasUnsavedChanges
!

postOpenWith:aBuilder
    self startUpdateProcess
! !

!ODBCScratchpad methodsFor:'menu actions'!

getSession
    ^ self sqlEditorApplicationHolder value odbcHandle
!

inspectSession
    self getSession inspect.
!

loadFile:fileNameOrString
    |file|

    file := fileNameOrString asFilename.

    [
        |contents editor|

        editor := self sqlEditor.
        contents := file contents.
        editor sqlEditorContents:contents.
        editor defaultFileNameForFileDialog:file pathName.
    ] on:StreamError do:[:ex|
        Dialog warn:(resources stringWithCRs:'Cannot open "%1"\\%2' with:file asString allBold with:ex description).
        ^ self
    ].
!

menuConnect
    self sqlEditor connect.
!

menuConnectODBC
    self sqlEditor connectODBC.
!

menuConnectSQLite
    self sqlEditor connectSQLite.
!

menuDisconnect
    self sqlEditor disconnect.
!

menuDoIt
    self sqlEditor doIt.
    self infoHolder value:'Code evaluated'
!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuOpen
    |file|

    file := Dialog requestFileName:(resources string:'Load SQL Script') default:'file.sql' pattern:'*.sql'.
    file size ~~ 0 ifTrue:[
        self loadFile:file
    ]
!

menuSave
    self sqlEditor save
!

menuSaveAs
    self sqlEditor saveAs
!

newStatementHandleInspect
    ^ self getSession newStatement getHandle inspect
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

pasteSampleCode
    self sqlEditor paste:
'// select a line, and execute via the doIt-menu-function (Cmd-d)

SHOW databases;
SHOW tables;

CREATE table table2(ID integer, NAME varchar(20));
DESCRIBE table2;

INSERT INTO table2 ( ID, NAME ) VALUES (1 , ''Claus'' );
INSERT INTO table2 ( ID, NAME ) VALUES (2 , ''James'' );
INSERT INTO table2 ( ID, NAME ) VALUES (3 , ''Boris'' );
INSERT INTO table2 ( ID, NAME ) VALUES (4 , ''Michael'' );
INSERT INTO table2 ( ID, NAME ) VALUES (5 , ''Betti'' );
INSERT INTO table2 ( ID, NAME ) VALUES (6 , ''Stefan'' );
INSERT INTO table2 ( ID, NAME ) VALUES (7 , ''Jens'' );
INSERT INTO table2 ( ID, NAME ) VALUES (8 , ''Andreas'' );

SELECT * from table2;
SELECT NAME from table2 WHERE ID=3;

CREATE USER username
    [ WITH [ PASSWORD ''password'' ] ] ;

DROP table table2;
'.

    "Modified: / 11-07-2006 / 14:48:50 / cg"
!

showTables
    self sqlEditor showTables.
! !

!ODBCScratchpad class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/SQL__ODBCScratchpad.st,v 1.19 2013-12-01 23:46:22 cg Exp $'
! !

