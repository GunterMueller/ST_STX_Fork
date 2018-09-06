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

AdaptableApplicationModel subclass:#ODBCResultTableTab
	instanceVariableNames:'canvasHolder tabListHolder selectedTabIndexHolder tabApplications
		class'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-ODBC-Application'
!

!ODBCResultTableTab class methodsFor:'documentation'!

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

!ODBCResultTableTab class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCResultTableTab andSelector:#windowSpec
     SQL::ODBCResultTableTab new openInterface:#windowSpec
     SQL::ODBCResultTableTab open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SQL::TabbedApplication'
         name: 'SQL::TabbedApplication'
         min: (Point 10 10)
         max: (Point 1024 768)
         bounds: (Rectangle 0 0 300 300)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (NoteBookViewSpec
             name: 'NoteBook1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             model: selectedTabIndexHolder
             menu: tabListHolder
             useIndex: true
             fitLastRow: false
             accessTabMenuAction: tabMenuAt:
             destroyTabAction: destroyTabAt:
             canvas: canvasHolder
             keepCanvasAlive: true
           )
          )
        
       )
     )
! !

!ODBCResultTableTab class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCResultTableTab andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCResultTableTab mainMenu)) startUp
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
                  label: 'Save'
                  itemValue: menuSave
                  translateLabel: true
                )
               (MenuItem
                  label: 'Save As...'
                  itemValue: menuSaveAs
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

tabMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCResultTableTab andSelector:#tabMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCResultTableTab tabMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Remove Tab'
            itemValue: removeTab
            translateLabel: true
          )
         (MenuItem
            label: 'Remove All Other Tabs'
            itemValue: removeAllOtherTabs
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!ODBCResultTableTab methodsFor:'accessing'!

activeCursor:aCursor 
    |newIndex newApp newTabName|
    aCursor numberOfColumns == 0 ifTrue:[
        ^ self "no result"
    ].
    newIndex := self tabApplicationsList size + 1.
    newTabName := 'tab', newIndex printString.
    newApp := self addTabNamed:newTabName.
    newApp activeCursor:aCursor.
    self selectedTabIndex:newIndex
!

class
    ^ class
!

class:something
    class := something.
!

tabClass
    ^ class ? (SQL::ODBCResultTable dataSetViewClass)

    "Modified: / 06-07-2006 / 18:32:33 / cg"
! !

!ODBCResultTableTab methodsFor:'factory'!

addTabNamed:aNameString 
    | newInstance aBuilder canvas|

    self tabListHolder add:aNameString.

    newInstance := self tabClass new.
    newInstance masterApplication:self.

    aBuilder := UIBuilder new.
    aBuilder application:newInstance.
    newInstance builder:aBuilder.
    canvas := ApplicationSubView new.
    canvas client:newInstance spec:#windowSpec builder:aBuilder.
    newInstance postOpenWith:aBuilder.
    self tabApplicationsList add:newInstance.
    ^ newInstance
!

canvasHolder
    canvasHolder isNil ifTrue:[
        canvasHolder := ValueHolder with:(SubCanvas new) .
    ].
    ^ canvasHolder.
!

instanceAtTabIndex:aNumber 
    ^ self tabApplicationsList at:aNumber
!

selectedTabIndex
    ^ selectedTabIndexHolder value
!

selectedTabIndex:aNumber
    ^ self selectedTabIndexHolder value:aNumber
!

selectedTabIndexHolder
    selectedTabIndexHolder isNil ifTrue:[
        selectedTabIndexHolder := ValueHolder new.
        selectedTabIndexHolder onChangeSend:#selectedTabIndexHolderChanged to:self.
    ].
    ^ selectedTabIndexHolder.
!

selectedTabIndexHolderChanged
    | instance selTabIndex |            

    selTabIndex := self selectedTabIndex.
    (selTabIndex == 0) ifTrue:[ 
        self canvasHolder value:nil.
        ^ self.
    ].
    instance := self instanceAtTabIndex:selTabIndex.
    instance ifNil:[
        self canvasHolder value:nil.
        ^ self
    ].
    self canvasHolder value:(instance window).
!

tabApplicationsList
    "return the value of the instance variable 'tabApplications' (automatically generated)"

    tabApplications ifNil:[
        tabApplications := List new
    ].
    ^ tabApplications
!

tabListHolder
    "holds the names of the tab in a tabList"
    tabListHolder isNil ifTrue:[
        tabListHolder := List new.
    ].
    ^ tabListHolder.
! !

!ODBCResultTableTab methodsFor:'menu'!

tabMenuAt:tabIndex
    ^ self class tabMenu
! !

!ODBCResultTableTab methodsFor:'menu actions'!

destroyTabAt:tabIndex
    |nextTabIndex|

    nextTabIndex := self selectedTabIndexHolder value.

    (tabApplications at:tabIndex) window destroy.
    (tabApplications at:tabIndex) release.
    tabApplications removeIndex:tabIndex.
    tabListHolder removeIndex:tabIndex.

    tabIndex > tabApplications size ifTrue:[
        nextTabIndex := tabApplications size.
    ].
    self selectedTabIndex:0.
    self selectedTabIndex:nextTabIndex.

    "Created: / 29-11-2013 / 18:52:00 / cg"
!

removeAllOtherTabs
    |tabIndex nextTabIndex|

    tabIndex := nextTabIndex := self selectedTabIndexHolder value.
    tabApplications doWithIndex:[:app :idx | idx ~~ tabIndex ifTrue:[
                                                app window destroy.
                                                app release.
                                             ]
                                ].

    tabApplications contents:(Array with:(tabApplications at:tabIndex)).
    tabListHolder contents:(Array with:(tabListHolder at:tabIndex)).

    self selectedTabIndex:1.
!

removeTab
    |tabIndex|

    tabIndex := self selectedTabIndexHolder value.
    self destroyTabAt:tabIndex.

    "Modified: / 29-11-2013 / 18:52:40 / cg"
! !

!ODBCResultTableTab class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/SQL__ODBCResultTableTab.st,v 1.12 2013-11-29 17:54:03 cg Exp $'
! !

