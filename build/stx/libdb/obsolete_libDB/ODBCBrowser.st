
"{ NameSpace: DB }"

ApplicationModel subclass:#ODBCBrowser
	instanceVariableNames:'browserView odbcInterface dataSourcesList dataSources tablesList
		dataSourcesSelectionHolder tablesSelectionHolder
		infoMessageHolder internalDB internalSmalltalkDB'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Browser'
!

!ODBCBrowser class methodsFor:'documentation'!

documentation
"
    documentation to be added.
"
!

examples
"
    ODBCBrowser open.
"
! !

!ODBCBrowser class methodsFor:'interface specs'!

infoViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DB::ODBCBrowser andSelector:#infoViewSpec
     DB::ODBCBrowser new openInterface:#infoViewSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: infoViewSpec
	window:
       (WindowSpec
	  label: 'infoCanvas'
	  name: 'infoCanvas'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (TextEditorSpec
	      name: 'InfoView'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      isReadOnly: true
	      viewClassName: TextCollector
	    )
	   )

	)
      )
!

sqlViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DB::ODBCBrowser andSelector:#sqlViewSpec
     DB::ODBCBrowser new openInterface:#sqlViewSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: sqlViewSpec
	window:
       (WindowSpec
	  label: 'sqlCanvas'
	  name: 'sqlCanvas'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (TextEditorSpec
	      name: 'SQLView'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      isReadOnly: true
	    )
	   )

	)
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DB::ODBCBrowser andSelector:#windowSpec
     DB::ODBCBrowser new openInterface:#windowSpec
     DB::ODBCBrowser open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'ODBC - Database Browser'
	  name: 'ODBC - Database Browser'
	  min: (Point 10 10)
	  max: (Point 1024 768)
	  bounds: (Rectangle 0 0 551 416)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableVerticalPanelSpec
	      name: 'VariableVerticalPanel1'
	      layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
	      snapMode: both
	      component:
	     (SpecCollection
		collection: (
		 (VariableHorizontalPanelSpec
		    name: 'VariableHorizontalPanel1'
		    snapMode: both
		    component:
		   (SpecCollection
		      collection: (
		       (ViewSpec
			  name: 'Box1'
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'DataSources'
				name: 'Label1'
				layout: (LayoutFrame 0 0 0 0 0 1 25 0)
				level: 1
				translateLabel: true
			      )
			     (SequenceViewSpec
				name: 'DataSourcesList'
				layout: (LayoutFrame 0 0 25 0 0 1 0 1)
				model: dataSourcesSelectionHolder
				menu: dataSourcesPopUpMenu
				hasHorizontalScrollBar: true
				hasVerticalScrollBar: true
				valueChangeSelector: dataSourceSelectionChanged
				useIndex: true
				sequenceList: dataSourcesList
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
				label: 'Tables'
				name: 'Label2'
				layout: (LayoutFrame 0 0 0 0 0 1 25 0)
				level: 1
				translateLabel: true
			      )
			     (SequenceViewSpec
				name: 'TablesList'
				layout: (LayoutFrame 0 0 25 0 0 1 0 1)
				model: tablesSelectionHolder
				menu: tablesPopUpMenu
				hasHorizontalScrollBar: true
				hasVerticalScrollBar: true
				useIndex: true
				sequenceList: tablesList
			      )
			     )

			  )
			)
		       )

		    )
		    handles: (Any 0.476667 1.0)
		  )
		 (NoteBookViewSpec
		    name: 'NoteBook1'
		    model: selectedTab
		    menu: tabList
		    useIndex: true
		    keepCanvasAlive: true
		  )
		 )

	      )
	      handles: (Any 0.5 1.0)
	    )
	   (LabelSpec
	      label: 'Label'
	      name: 'InfoLabel'
	      layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
	      level: -1
	      translateLabel: true
	      labelChannel: infoMessageHolder
	      adjust: left
	    )
	   )

	)
      )
! !

!ODBCBrowser class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
	  label: 'Info'
	  createNewBuilder: false
	  minorKey: infoViewSpec
	)
       (TabItem
	  label: 'SQL'
	  createNewBuilder: false
	  minorKey: sqlViewSpec
	)
       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!ODBCBrowser class methodsFor:'menu specs'!

dataSourcesPopUpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DB::ODBCBrowser andSelector:#dataSourcesPopUpMenu
     (Menu new fromLiteralArrayEncoding:(DB::ODBCBrowser dataSourcesPopUpMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Open'
	    itemValue: dataSourceOpenAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Close'
	    itemValue: dataSourceCloseAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Create'
	    itemValue: dataSourceCreateAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Delete'
	    itemValue: dataSourceDeleteAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Modify'
	    itemValue: dataSourceModifyAction
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DB::ODBCBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(DB::ODBCBrowser mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'File'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Exit'
		  itemValue: closeRequest
		  translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Resource'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Info'
		  itemValue: resourceInfo
		  translateLabel: true
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Load'
		  itemValue: resourceLoad
		  translateLabel: true
		)
	       (MenuItem
		  label: 'Unload'
		  itemValue: resourceUnload
		  translateLabel: true
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Save'
		  itemValue: resourceSave
		  translateLabel: true
		)
	       (MenuItem
		  label: 'Save As...'
		  itemValue: resourceSaveToNewFile
		  translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Debug'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Driver Debug On'
		  itemValue: driverDebugOn
		  translateLabel: true
		)
	       (MenuItem
		  label: 'Driver Debug Off'
		  itemValue: driverDebugOff
		  translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Help'
	    translateLabel: true
	    startGroup: right
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Documentation'
		  itemValue: openDocumentation
		  translateLabel: true
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'About this Application'
		  itemValue: openAboutThisApplication
		  translateLabel: true
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

tablesPopUpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DB::ODBCBrowser andSelector:#tablesPopUpMenu
     (Menu new fromLiteralArrayEncoding:(DB::ODBCBrowser tablesPopUpMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Create'
	    itemValue: tableCreateAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Delete'
	    itemValue: tableDeleteAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Show'
	    itemValue: tableShowAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Edit'
	    itemValue: tableEditAction
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Setup'
	    itemValue: tableSetupAction
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!ODBCBrowser methodsFor:'accessing'!

infoView
    ^ self builder componentAt:#'InfoView'
!

odbcInterface
    "return odbcInterface"

    ^ odbcInterface
!

odbcInterface:something
    "set odbcInterface"

    odbcInterface := something.
!

sqlView
    ^ self builder componentAt:#'SQLView'
! !

!ODBCBrowser methodsFor:'aspects'!

dataSourcesList
    dataSourcesList isNil ifTrue:[
	dataSourcesList := List new.
	self initializeDataSources.
    ].
    ^ dataSourcesList.
!

dataSourcesSelection
    ^ self dataSourcesSelectionHolder value
!

dataSourcesSelectionHolder
    dataSourcesSelectionHolder isNil ifTrue:[
	dataSourcesSelectionHolder := ValueHolder new.
    ].
    ^ dataSourcesSelectionHolder.
!

getNotebookView:x
self halt.
!

infoMessageHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    infoMessageHolder isNil ifTrue:[
	infoMessageHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       infoMessageHolder addDependent:self.
"/       infoMessageHolder onChangeSend:#infoMessageHolderChanged to:self.
    ].
    ^ infoMessageHolder.
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
	builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list
!

tablesList
    tablesList isNil ifTrue:[
	tablesList := List new.
    ].
    ^ tablesList.
!

tablesSelection
    ^ self tablesSelectionHolder value
!

tablesSelectionHolder
    tablesSelectionHolder isNil ifTrue:[
	tablesSelectionHolder := ValueHolder new.
    ].
    ^ tablesSelectionHolder.
! !

!ODBCBrowser methodsFor:'initialize & release'!

initialize
    super initialize.
    odbcInterface := SQL::ODBCEnvironment new.
    dataSources := Dictionary new.
!

initializeDataSources
    dataSourcesList removeAll.

    odbcInterface dataSourceNames do:[:e|
	dataSourcesList add:(Text string:e emphasis:(#strikeout)).
    ].

    SQLDatabase notNil ifTrue:[
	internalDB := SQLDatabase new.
	internalSmalltalkDB := SQLSmalltalkDatabase new.
	dataSourcesList add:'INTERNAL-DB'.
	dataSourcesList add:'INTERNAL-ST'.
    ].
!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.
    [
      Delay waitForSeconds:1.
      self infoCR:'Welcome to the ODBC Browser Application'.
    ] fork.
!

release
    dataSources do:[:eachSession | eachSession disconnect].
    odbcInterface release.
    super release.
! !

!ODBCBrowser methodsFor:'menu actions'!

dataSourceClose: aDataSource
    ""
    odbcInterface sqlDisconnect: aDataSource.
    self infoCR: odbcInterface sqlError.

    odbcInterface sqlFreeConnect: aDataSource.
    self infoCR: odbcInterface sqlError.

    ^ true.
!

dataSourceCreate
    |ds|
    (ds := odbcInterface sqlConfigDataSource: nil) isNil ifFalse: [
	self infoCR: odbcInterface sqlError.
	self updateDataSourceView: odbcInterface sqlDataSources.
	^ ds.
    ].

    self infoCR: odbcInterface sqlError.

    ^ nil.
!

dataSourceDelete: aDataSource
!

dataSourceModify: aDataSource
    |ds|

    (ds := odbcInterface sqlConfigDataSource: aDataSource) isNil ifFalse: [
	self infoCR: odbcInterface sqlError.
	self updataDataSourceView: odbcInterface sqlDataSources.
	^ ds.
    ].

    self infoCR: odbcInterface sqlError.

    ^ nil.
!

dataSourceOpen: aDataSource

    (odbcInterface sqlAllocConnect: aDataSource) ifTrue: [
	self infoCR: odbcInterface sqlError.
	(odbcInterface sqlConnect: aDataSource) ifTrue: [
	    self info: odbcInterface sqlError.
	    ^ true.
	].
    ].

    self infoCR: odbcInterface sqlError.

    ^ false.
!

driverDebugOff

    odbcInterface driverDebugOff.

!

driverDebugOn

    odbcInterface driverDebugOn.
!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuOpen
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'open' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''open'' available.'.
!

menuSave
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''save'' available.'.
!

menuSaveAs
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'saveAs' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''saveAs'' available.'.
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

resourceLoad

    (odbcInterface sqlAllocEnv: nil) ifTrue: [
	self infoCR: odbcInterface sqlError.
	self updateDataSourceView: odbcInterface sqlDataSources.
	self infoCR: ('resource file: ',
			    odbcInterface resourceFileBaseName,
			    ' loaded.').
	^ true.
    ].

    self infoCR: odbcInterface sqlError.

    ^ false.
!

resourceSave
    (odbcInterface sqlSaveEnv: odbcInterface resourceFile) ifTrue: [
	self infoCR: odbcInterface sqlError.
	self infoCR: ('resource file: ',
			    odbcInterface resourceFileBaseName,
			    ' saved').
	^ true.
    ].

    self infoCR: odbcInterface sqlError.

    ^ false.
!

resourceSaveToNewFile: aNewResourceFileName
    (odbcInterface sqlSaveEnv: aNewResourceFileName) ifTrue: [
	self infoCR: odbcInterface sqlError.
	self infoCR: ('resource file: ',
			    odbcInterface resourceFileBaseName,
			    ' saved').
	^ true.
    ].

    self infoCR: odbcInterface sqlError.

    ^ false.
!

resourceUnload
    |file|

    (file := odbcInterface resourceFileBaseName) isNil ifTrue: [
	^ false.
    ].

    (odbcInterface sqlFreeEnv) ifTrue: [
	self infoCR: odbcInterface sqlError.
	self updateDataSourceView: odbcInterface sqlDataSources.
	self infoCR: ('resource file: ', file, ' unloaded.').
	^ true.
    ].

    self infoCR: odbcInterface sqlError.

    ^ false
!

tableCreate
    |table dsSel ds|

    (dsSel := self dataSourcesSelection) isNil ifTrue: [
	^ self.
    ].

    ds := dataSourcesList at: dsSel.
    (table := self tableCreate: ds) notNil ifTrue: [
	self infoCR: ('New Table Created.').
    ].

    "Modified: 26.5.1997 / 16:57:08 / cg"
!

tableCreate: aDataSource
    (odbcInterface sqlExecDirect: aDataSource query: odbcInterface createTableDialog) ifTrue: [
	self infoCR: odbcInterface sqlError.
	^ true.
    ].

    self infoCR: odbcInterface sqlError.

    ^ false.
!

tableCreateAction
    (Dialog confirm:('Create New Table ?')) ifTrue:[
	self tableCreate
    ].
!

tableShow: aDataSource tableName: table
    |tableDescr tableCont row fld c|

    (tableDescr := odbcInterface sqlListFields: aDataSource table: table) isNil ifTrue: [
	self infoCR: odbcInterface sqlError.
	^ false.
    ].
    self halt.
    (odbcInterface sqlExecDirect: aDataSource query: 'SELECT * FROM ', (table string)) ifTrue: [
	[(row := odbcInterface sqlFetchRow: aDataSource) isNil] whileFalse: [
	    tableCont isNil ifTrue: [
		tableCont := OrderedCollection new.
		c := OrderedCollection new.
	    ].

	    odbcInterface sqlFieldSeek: aDataSource offset: 0.

	    [(fld := odbcInterface sqlFetchField: aDataSource) isNil] whileFalse: [
		c add: fld.
	    ].

	    tableCont add: c.
	].
    ].

    odbcInterface showTableDialog: tableDescr withContents: tableCont.

    ^ true.
! !

!ODBCBrowser methodsFor:'private'!

info: anInfoString
    |v|

    anInfoString isNil ifTrue: [
	^ self.
    ].

    v := self infoView scrolledView.
    v show:anInfoString.
    v endEntry
!

infoCR: anInfoString
    |v|

    anInfoString isNil ifTrue: [
	^ self.
    ].

    v := self infoView scrolledView.
v inspect.
self halt.
    v showCR:anInfoString.
    v endEntry
! !

!ODBCBrowser methodsFor:'queries'!

allDataSourceNames

   ^ odbcInterface sqlDataSources.
!

dataSourceConnected: aDataSourceName

   ^ odbcInterface dataSourceConnected: aDataSourceName.
! !

!ODBCBrowser methodsFor:'user actions'!

dataSourceSelectionChanged
    |sel dataSourceName session tables user password|

    sel := self dataSourcesSelection.
    sel isNil ifTrue:[ ^ self ].

    dataSourceName := self dataSourcesList at:sel.
    dataSourceName isNil ifTrue:[ ^ self ].

    dataSourceName := dataSourceName string.

    dataSourceName = 'INTERNAL-DB' ifTrue:[
	tables := internalDB sqlListTables
    ] ifFalse:[
	dataSourceName = 'INTERNAL-ST' ifTrue:[
	    tables := internalSmalltalkDB sqlListTables
	] ifFalse:[
	    session := dataSources at:dataSourceName ifAbsent:nil.
	    session isNil ifTrue:[
		user := Dialog request:'User:' initialAnswer:'test'.
		password := Dialog request:'Password:' initialAnswer:'test'.
		session := odbcInterface newSession connectWithUsername:user password:password dbname:dataSourceName.
		dataSources at:dataSourceName put:session.
	    ].
	    tables := session tables
	]
    ].
    self tablesList contents:tables.
! !

!ODBCBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCBrowser.st,v 1.8 2006-08-24 08:36:28 cg Exp $'
! !
