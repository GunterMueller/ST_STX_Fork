"{ NameSpace: DB }"

SelectionInListView subclass:#ODBCBrowserTablesView
	instanceVariableNames:'browser popupMenue'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Browser'
!

!ODBCBrowserTablesView class methodsFor:'documentation'!

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
    "Created: 28.9.1996 / 12:24:53 / ah"
! !

!ODBCBrowserTablesView class methodsFor:'instance creation'!

new
    ""
    ^ super new initializeWith: nil.



!

newWith: aInfoView
    ""
    ^ super new initializeWith: aInfoView.



! !

!ODBCBrowserTablesView methodsFor:'change & update'!

updateContents: newContents
    ""

    self setList: OrderedCollection new.
    newContents isNil ifTrue: [
        ^ false.
    ].
    newContents do:[:e|
        self add:(Text string:e emphasis:(#string)).       
    ].

    self redraw.



! !

!ODBCBrowserTablesView methodsFor:'event handling'!

buttonPress:button x:x y:y
    |dsSel sel|

    button == 2 ifTrue: [
        (dsSel := browser dsView selection) isNil ifTrue: [
            ^ false.
        ].
        (browser dataBaseApplication dataSourceConnected: (browser dsView list at: dsSel)) ifTrue: [

            (sel := self selection) notNil ifTrue: [
                "a table is selected in view
                "
                popupMenue disable:#createAction.
                popupMenue enable:#deleteAction.
                popupMenue enable:#editAction.
                popupMenue enable:#showAction.
                popupMenue enable:#setupAction.

            ] ifFalse: [
                "no table selected in view
                "
                popupMenue enable:#createAction.
                popupMenue disable:#deleteAction.
                popupMenue disable:#editAction.
                popupMenue disable:#showAction.
                popupMenue disable:#setupAction.
            ].
            popupMenue showAtPointer.

        ].
    ] ifFalse: [
        super buttonPress:button x:x y:y
    ].

    "Modified: 26.5.1997 / 16:57:07 / cg"
! !

!ODBCBrowserTablesView methodsFor:'initialization'!

initializeWith: aBrowser

     browser := aBrowser.

     popupMenue := PopUpMenu  labels:#('create' 'delete' 'show' 'edit' 'setup')
                           selectors:#(#createAction #deleteAction #showAction #editAction #setupAction)
                            receiver:self. 

     self doubleClickAction:[:s| self deselect].

     ^ super initialize.






! !

!ODBCBrowserTablesView methodsFor:'menue actions'!

createAction
    |aBox answer|

    aBox := YesNoBox title:'Create new table ?'.
    aBox yesAction:[self tableCreate].
    aBox showAtPointer. 




!

deleteAction
    |aBox answer|

    aBox := YesNoBox title:'Delete selected table ?'.
    aBox yesAction:[self tableDelete].
    aBox showAtPointer. 











!

editAction
    |aBox answer|

    aBox := YesNoBox title:'Edit selected table ?'.
    aBox yesAction:[self tableEdit].
    aBox showAtPointer. 






!

setupAction
    |aBox answer|

    aBox := YesNoBox title:'Setup selected table ?'.
    aBox yesAction:[self tableEdit].
    aBox showAtPointer. 





!

showAction
    |aBox answer|

    aBox := YesNoBox title:'Show selected table ?'.
    aBox yesAction:[self tableShow].
    aBox showAtPointer. 










! !

!ODBCBrowserTablesView methodsFor:'private'!

tableCreate
    |table dsSel ds|

    (dsSel := browser dsView selection) isNil ifTrue: [
        ^ false.
    ].
    ds := browser dsView list at: dsSel.

    (table := (browser dataBaseApplication) tableCreate: ds) isNil ifFalse: [
        browser info: ('new table created.').
        self redraw
    ].

    "Modified: 26.5.1997 / 16:57:08 / cg"
!

tableDelete
    browser info: 'deletion of tables not yet implemented !!'. 

!

tableEdit
    browser info: 'edit of tables not yet implemented !!'. 

!

tableSetup
    browser info: 'setup of tables not yet implemented !!'. 

!

tableShow
    |table dsSel ds|

    (dsSel := browser dsView selection) isNil ifTrue: [
        ^ false.
    ].
    ds := browser dsView list at: dsSel.

    (table := (browser dataBaseApplication) tableShow: ds tableName: (self list at: (self selection))) isNil ifFalse: [
        browser info: ('new table created.').
        self redraw
    ].

    "Modified: 26.5.1997 / 16:57:11 / cg"
! !

!ODBCBrowserTablesView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCBrowserTablesView.st,v 1.2 1997-05-26 15:02:58 cg Exp $'
! !
