
"{ NameSpace: DB }"

StandardSystemView subclass:#ODBCBrowserView
	instanceVariableNames:'appl dsView tabView infoView resourceLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Browser'
!

!ODBCBrowserView class methodsFor:'documentation'!

documentation
"
    documentation to be added.
"
!

history
    "Created: 28.9.1996 / 08:20:20 / ah"
! !

!ODBCBrowserView class methodsFor:'instance creation'!

newWithApplication: aApplication
    ""
    ^ super new initialize: aApplication.
! !

!ODBCBrowserView methodsFor:'accessing'!

infoView
    "return infoView"

    ^ infoView
!

infoView:something
    "set infoView"

    infoView := something.
! !

!ODBCBrowserView methodsFor:'change and update'!

updateDataSourceView: newContents
    ""

    ^ dsView updateContents: newContents
!

updateTableView: newContents
    ""

    ^ tabView updateContents: newContents
! !

!ODBCBrowserView methodsFor:'initialization'!

initialize: aApplication
    "initialize databaseBrowser"
    | vPanelView hPanelView menueView labelView dsTopView tabTopView colTopView l m s|

    appl := aApplication.

    self extent: 420 @ 270.
    self label: 'ODBC - Database Browser'.
    self minExtent: 340 @ 210.

    menueView := PullDownMenu  origin:0.0 @ 0.0 corner:1.0 @ 25 in: self.
    menueView labels:#('Browser' 'Resource' 'Debug').
    menueView selectors:#(Browser Resource Debug).

    menueView   at:#Browser
	 putLabels:#('snapshot ...' 'snapshot & exit ...' 'exit Browser ...')
	 selectors:#(browserSnapshot browserSnapshotAndExit browserExit)
	  receiver:self.

    menueView   at:#Resource
	 putLabels:#('info' 'load' 'unload' 'save' 'saveTo')
	 selectors:#(resourceInfo resourceLoad resourceUnload resourceSave resourceSaveToNewFile)
	  receiver:self.

    menueView   at:#Debug
	 putLabels:#('driver debug on' 'driver debug off')
	 selectors:#(driverDebugOn driverDebugOff)
	  receiver:self.

    labelView := PanelView origin:0.0 @ 25
			   corner:1.0 @ 1.0
			       in: self.

    resourceLabel := Label in:labelView.
    resourceLabel level:1.
    resourceLabel label: ''.
    resourceLabel adjust:#left.
    resourceLabel origin:0.0@0.0.
    resourceLabel width:1.0.

    vPanelView := VariableVerticalPanel  origin:0.0 @ 45
					 corner:1.0 @ 1.0
					     in: self.

    hPanelView := VariableHorizontalPanel origin:0.0 @ 0.0
					  corner:1.0 @ 0.5
					      in:vPanelView.


    infoView := HVScrollableView for:TextView miniScrollerH:true in:vPanelView.
    infoView origin:0.0@0.5 corner:1.0@1.0.
    infoView scrolledView backgroundColor:Color blue.
    infoView scrolledView foregroundColor:Color white.

"=====================================
initialize datasource view and elements"

    dsTopView := PanelView  origin:0.0 @ 0.0 corner:0.5 @ 1.0 in:hPanelView.

    l := Label in:dsTopView.
    l level:-1.
    l label:'Datasources'.
    l origin:0.0@0.0.
    l width:1.0.

    dsView := ODBCBrowserDataSourceView newWith: self.

    s := ScrollableView forView:dsView.
    s origin:0.0 @ 20 corner:1.0 @ 1.0.

    dsTopView addSubView:s after: l.

"==================================
initialize table view and elements"

    tabTopView := PanelView  origin:0.5 @ 0.0  corner:1.0 @ 1.0 in:hPanelView.

    l := Label in:tabTopView.
    l level:-1.
    l label:'Tables'.
    l origin:0.0@0.0.
    l width:1.0.

    tabView := DB::ODBCBrowserTablesView newWith: self.

    s := ScrollableView forView:tabView.
    s origin:0.0 @ 20 corner:1.0 @ 1.0.

    tabTopView addSubView:s after: l.

"================
realize browser"

     self openModeless.

    "Modified: 26.5.1997 / 16:59:49 / cg"
! !

!ODBCBrowserView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCBrowserView.st,v 1.4 2006-08-24 08:36:01 cg Exp $'
! !
