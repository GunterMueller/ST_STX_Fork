'From Smalltalk/X, Version:3.4.8 on 31-aug-1998 at 12:24:00 pm'                 !

"{ NameSpace: Demos }"

ApplicationModel subclass:#ExampleQuery
	instanceVariableNames:'connection dataBaseHolder passwordHolder userNameHolder
		infoLabelHolder resultList columnHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-adabas'
!

!ExampleQuery class methodsFor:'interface specs'!

connectDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples::ExampleQuery andSelector:#connectDialogSpec
     CodingExamples::ExampleQuery new openInterface:#connectDialogSpec
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'ConnectDialog'
              #layout: #(#LayoutFrame 30 0 170 0 325 0 298 0)
              #label: 'ConnectDialog'
              #min: #(#Point 10 10)
              #max: #(#Point 1024 768)
              #bounds: #(#Rectangle 30 170 326 299)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#HorizontalPanelViewSpec
                    #name: 'BUttonPanel'
                    #layout: #(#LayoutFrame 0 0.0 -30 1 0 1.0 0 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ActionButtonSpec
                              #name: 'Button1'
                              #label: 'Cancel'
                              #translateLabel: true
                              #model: #cancel
                              #extent: #(#Point 143 22)
                          )
                           #(#ActionButtonSpec
                              #name: 'Button2'
                              #label: 'OK'
                              #translateLabel: true
                              #model: #accept
                              #extent: #(#Point 144 22)
                          )
                        )
                    )
                    #horizontalLayout: #fitSpace
                    #verticalLayout: #center
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
                 #(#LabelSpec
                    #name: 'Label3'
                    #layout: #(#LayoutFrame 0 0 7 0 0 0.5 29 0)
                    #label: 'DataBase:'
                    #translateLabel: true
                    #adjust: #right
                )
                 #(#InputFieldSpec
                    #name: 'EntryField3'
                    #layout: #(#LayoutFrame 0 0.5 7 0 -2 1.0 29 0)
                    #tabable: true
                    #model: #dataBaseHolder
                    #type: #string
                )
                 #(#LabelSpec
                    #name: 'Label1'
                    #layout: #(#LayoutFrame 0 0 40 0 0 0.5 62 0)
                    #label: 'DB UserName:'
                    #translateLabel: true
                    #adjust: #right
                )
                 #(#InputFieldSpec
                    #name: 'EntryField1'
                    #layout: #(#LayoutFrame 0 0.5 40 0 -2 1.0 62 0)
                    #tabable: true
                    #model: #userNameHolder
                )
                 #(#LabelSpec
                    #name: 'Label2'
                    #layout: #(#LayoutFrame 0 0 68 0 0 0.5 90 0)
                    #label: 'DB Password:'
                    #translateLabel: true
                    #adjust: #right
                )
                 #(#InputFieldSpec
                    #name: 'EntryField2'
                    #layout: #(#LayoutFrame 0 0.5 68 0 -2 1.0 90 0)
                    #tabable: true
                    #model: #passwordHolder
                    #type: #password
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
     UIPainter new openOnClass:CodingExamples::ExampleQuery andSelector:#windowSpec
     CodingExamples::ExampleQuery new openInterface:#windowSpec
     CodingExamples::ExampleQuery open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'CodingExamples::ExampleQuery'
              #layout: #(#LayoutFrame 196 0 100 0 696 0 457 0)
              #label: 'CodingExamples::ExampleQuery'
              #min: #(#Point 10 10)
              #max: #(#Point 1024 768)
              #bounds: #(#Rectangle 196 100 697 458)
              #menu: #mainMenu
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#VariableVerticalPanelSpec
                    #name: 'VariableVerticalPanel1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#WorkspaceSpec
                              #name: 'Workspace'
                              #menu: #queryMenu
                              #hasHorizontalScrollBar: true
                              #hasVerticalScrollBar: true
                              #miniScrollerHorizontal: true
                          )
                           #(#DataSetSpec
                              #name: 'Table1'
                              #hasHorizontalScrollBar: true
                              #hasVerticalScrollBar: true
                              #miniScrollerHorizontal: true
                              #dataList: #resultList
                              #has3Dsepartors: false
                              #columnHolder: #columnHolder
                          )
                        )
                    )
                    #handles: #(#Any 0.313333 1.0)
                )
                 #(#LabelSpec
                    #name: 'InfoLabel'
                    #layout: #(#LayoutFrame 0 0.0 -23 1 0 1.0 0 1.0)
                    #labelChannel: #infoLabelHolder
                    #level: -1
                    #adjust: #left
                )
              )
          )
      )
! !

!ExampleQuery class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples::ExampleQuery andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples::ExampleQuery mainMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Database'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Connect'
                          #translateLabel: true
                          #isVisible: #hasNoConnection
                          #value: #doConnectDialog
                      )
                       #(#MenuItem
                          #label: 'Disconnect'
                          #translateLabel: true
                          #isVisible: #hasConnection
                          #value: #doDisconnect
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Help'
                #translateLabel: true
                #startGroup: #right
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

queryMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples::ExampleQuery andSelector:#queryMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples::ExampleQuery queryMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Copy'
                #translateLabel: true
                #value: #copySelection
            )
             #(#MenuItem
                #label: 'Cut'
                #translateLabel: true
                #value: #cutSelection
            )
             #(#MenuItem
                #label: 'Paste'
                #translateLabel: true
                #value: #pasteSelection
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Do Query'
                #translateLabel: true
                #value: #doQuery
            )
          ) nil
          nil
      )
! !

!ExampleQuery methodsFor:'actions'!

doConnectDialog
    |accepted|

    accepted := self openDialogInterface:#connectDialogSpec.
    accepted ifTrue:[
        self connectToDatabase
    ]
!

doDisconnect
    self disconnectFromDatabase

! !

!ExampleQuery methodsFor:'aspects'!

columnHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    columnHolder isNil ifTrue:[
        columnHolder :=  ValueHolder new.
    ].
    ^ columnHolder.
!

dataBaseHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    dataBaseHolder isNil ifTrue:[
        dataBaseHolder :=  ':MYDB' asValue.
    ].
    ^ dataBaseHolder.
!

hasConnection
    ^ [ connection notNil ]
!

hasNoConnection
    ^ [ connection isNil ]
!

infoLabelHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    infoLabelHolder isNil ifTrue:[
        infoLabelHolder :=  ValueHolder new.
    ].
    ^ infoLabelHolder.
!

passwordHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    passwordHolder isNil ifTrue:[
        passwordHolder :=  ValueHolder new.
    ].
    ^ passwordHolder.
!

resultList
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    resultList isNil ifTrue:[
        resultList :=  List new.
    ].
    ^ resultList.
!

userNameHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    userNameHolder isNil ifTrue:[
        userNameHolder :=  ValueHolder new.
    ].
    ^ userNameHolder.
! !

!ExampleQuery methodsFor:'database functions'!

connectToDatabase
    connection := OdbcConnection open.
    connection 
        connect:(dataBaseHolder value) 
        userId:(userNameHolder value) password:(passwordHolder value).
    connection hasError ifFalse:[
        self info:'Connected.'
    ] ifTrue:[
        self info:'Cannot connect.'
    ]
!

databaseQuery:query
    "perform an sql query"

    |statement rowSet rowHeader resultRows numOfRows columns|

    self withCursor:Cursor execute do:[
        self info:'Executing...'.

        statement := connection newStatement.
        statement setStatementOption:#SQL_ROWSET_SIZE vParam:2500.
        statement executeDirect:query.
        statement hasError ifTrue:[
           self info:'Error in executeDirect'.
           ^ self
        ].
        statement bindColumnsToDefault.

        resultList removeAll.
        [statement noDataFound] whileFalse:[
            numOfRows := statement extendedFetch:#SQL_FETCH_NEXT irow:1.
            statement noDataFound ifFalse:[
                rowSet := statement rowset:numOfRows.
                rowHeader isNil ifTrue:[
                    rowHeader := rowSet columnNames.

                    "/ setup DSV for new column spec

                    columns := OrderedCollection new.
                    rowHeader columnNames do:[:colNm | |spec|
                        spec := DataSetColumnSpec new.
                        spec label:colNm.
                        spec readSelector:#at:.
                        spec writeSelector:#at:put:.
                        spec editorType:#None.
                        columns add:spec.
                    ].
                    self columnHolder value:columns.
                ].
                resultList addAll:rowSet.
                self info:('Executing (retrieved %1 rows so far)...' bindWith:(resultList size printString)).
            ].
        ].

        statement drop.

        "/
        "/ got the info; rowHeader contains the field infos;
        "/ resultRows the individual rows.
        "/
        self info:('Found %1 rows.' bindWith:(resultList size printString)).

    ]
!

disconnectFromDatabase
    connection disconnect.
    connection free.
    self info:'Disconnected.'

! !

!ExampleQuery methodsFor:'private'!

info:aMessage
    self infoLabelHolder value:aMessage

!

workspace
    ^ self builder componentAt:#Workspace
! !

!ExampleQuery methodsFor:'workspace actions'!

copySelection
    self workspace copySelection
!

cutSelection
    self workspace cutSelection
!

doQuery
    |query|

    query := self workspace contents asString.
    self databaseQuery:query
!

pasteSelection
    self workspace pasteSelection
! !

