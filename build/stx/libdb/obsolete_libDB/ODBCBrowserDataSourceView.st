"{ NameSpace: DB }"

SelectionInListView subclass:#ODBCBrowserDataSourceView
	instanceVariableNames:'browser popupMenue'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Browser'
!

!ODBCBrowserDataSourceView class methodsFor:'documentation'!

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
    "Created: 28.9.1996 / 12:29:15 / ah"
! !

!ODBCBrowserDataSourceView class methodsFor:'instance creation'!

new
    ""
    ^ super new initializeWith: nil.

!

newWith: aInfoView
    ""
    ^ super new initializeWith: aInfoView.

! !

!ODBCBrowserDataSourceView methodsFor:'change and update'!

updateContents: newContents
    ""

    self setList: OrderedCollection new.

    newContents do:[:e|
        (browser dataBaseApplication dataSourceConnected: e) ifTrue: [
            self add:(Text string:e emphasis:(#bold)).
        ] ifFalse: [
            self add:(Text string:e emphasis:(#strikeout)).
        ].
    ].

    self redraw.

    "Modified: 26.5.1997 / 16:57:05 / cg"
! !

!ODBCBrowserDataSourceView methodsFor:'event handling'!

buttonPress:button x:x y:y

    |s|

    button == 2 ifFalse: [
        super buttonPress:button x:x y:y.
        browser dataBaseApplication dataSourceSelectionChanged.
        ^ true.
    ].

    (s := self selection) notNil ifTrue: [
        "a datasource is selected in view
        "

        ((browser dataBaseApplication) dataSourceConnected: (self list at: s)) ifTrue: [
            "selected datasource is opened
            "
            popupMenue disable:#openAction.
            popupMenue enable:#closeAction.
            popupMenue enable:#deleteAction.
            popupMenue disable:#createAction.

        ] ifFalse: [
            "selected datasource is closed
            "
            popupMenue enable:#openAction.
            popupMenue disable:#closeAction.
            popupMenue disable:#deleteAction.
            popupMenue disable:#createAction.
        ].

        popupMenue showAtPointer.

    ] ifFalse: [
        "no datasource selected in view
        "
        popupMenue disable:#openAction.
        popupMenue disable:#closeAction.
        popupMenue disable:#deleteAction.
        popupMenue enable:#createAction.

        popupMenue showAtPointer.
    ].

    "Modified: 26.5.1997 / 16:56:52 / cg"
! !

!ODBCBrowserDataSourceView methodsFor:'initialization'!

initializeDataSources

    self setList: OrderedCollection new.

    (browser dataBaseApplication) allDataSourceNames do:[:e|
        self add:(Text string:e emphasis:(#strikeout)).       
    ].

    self redraw.

    "Modified: 26.5.1997 / 16:57:04 / cg"
!

initializeWith: aBrowser

    |oc|

    super initialize.

    browser := aBrowser.

    self list isNil ifTrue: [
        oc := OrderedCollection new.
        self list: oc.
    ].

    self initializeDataSources.

    popupMenue := PopUpMenu  labels:#('open' 'close' 'create' 'delete' 'modify')
                          selectors:#(#openAction #closeAction #createAction #deleteAction #modifyAction)
                           receiver:self.

    self doubleClickAction:[:s| self deselect].

! !

!ODBCBrowserDataSourceView methodsFor:'menue actions'!

closeAction
    |s aBox answer|

    (s := self selection) notNil ifTrue: [
        aBox := YesNoBox title:'Close selected data source ?'.
        aBox yesAction:[self dataSourceClose].
        aBox showAtPointer. 
    ].


!

createAction
    |aBox answer|

    aBox := YesNoBox title:'Create new data source ?'.
    aBox yesAction:[self dataSourceCreate].
    aBox showAtPointer. 
!

deleteAction
    |s aBox answer|

    (s := self selection) notNil ifTrue: [
        aBox := YesNoBox title:'Delete selected data source ?'.
        aBox yesAction:[self dataSourceDelete].
        aBox showAtPointer. 
    ].

!

modifyAction
    |s aBox answer|

    (s := self selection) notNil ifTrue: [
        aBox := YesNoBox title:'Modify selected data source ?'.
        aBox yesAction:[self dataSourceModify].
        aBox showAtPointer. 
    ].

!

openAction
    |s aBox answer|

    (s := self selection) notNil ifTrue: [
        aBox := YesNoBox title:'Open selected data source ?'.
        aBox yesAction:[self dataSourceOpen].
        aBox showAtPointer. 
    ].

! !

!ODBCBrowserDataSourceView methodsFor:'private'!

dataSourceClose
    ""
    (browser dataBaseApplication dataSourceClose: (self list at: self selection)) ifTrue: [
        browser info: ('data source ', ((self list at: (self selection)) string)), ' closed.'.
        (self list at: self selection) emphasizeAllWith:(#strikeout).

        self redraw
    ].

    "Modified: 26.5.1997 / 16:56:54 / cg"
!

dataSourceCreate
    ""
    |dataSource|

    (dataSource := (browser dataBaseApplication) dataSourceCreate) isNil ifFalse: [
        browser info: ('new data source ', dataSource, ' created.').
        self redraw
    ].

    "Modified: 26.5.1997 / 16:56:58 / cg"
!

dataSourceDelete
    | i |

    i := self selection.

    (browser dataBaseApplication dataSourceDelete: (self list at: i)) ifTrue: [
        browser info: ('data source ', ((self list at: i) string), ' deleted.'). 
        self removeIndex: i.

        self redraw
    ].

    "Modified: 26.5.1997 / 16:57:00 / cg"
!

dataSourceModify
    |dataSource|

    (dataSource := (browser dataBaseApplication) dataSourceModify: (self list at: (self selection))) isNil ifFalse: [
        browser info: ('data source ', dataSource, ' definition changed.').
        self redraw
    ].

    "Modified: 26.5.1997 / 16:57:01 / cg"
!

dataSourceOpen

    ((browser dataBaseApplication) dataSourceOpen: (self list at: (self selection))) ifTrue: [
        browser info: ('data source ', ((self list at: (self selection)) string)), ' opened.'.
        (self list at:(self selection)) emphasizeAllWith:(#bold).
        self redraw.

        browser dataBaseApplication dataSourceSelectionChanged.
    ].

    "Modified: 26.5.1997 / 16:57:21 / cg"
! !

!ODBCBrowserDataSourceView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCBrowserDataSourceView.st,v 1.2 1997-05-26 15:02:41 cg Exp $'
! !
