"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowser
	instanceVariableNames:'browser browserModel'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-UI'
!


!DBXBrowser class methodsFor:'world-menu'!

menuCommandOn: aBuilder  
	<worldMenu>
	(aBuilder group: #MostUsedTools)
		withSeparatorAfter;
		order: 1;
		with: [	(aBuilder item: #'DBXTalk - Neptuno')
					target: self;
					action: [DBXBrowser new open.]; 
					icon: GLMUIThemeExtraIcons glamorousSearch.
			]
! !

!DBXBrowser methodsFor:'display'!

open
	"DBXBrowser new open"
	browser := GLMTabulator new.
	browser title: 'Neptuno - The DBXTalk Browser'.
	browser row: [ :r | r 
			column: #connections span: 0.2;
			column: #mainPanel ].
	self addConectionsPanel.
	self addMainPanel.
	(browser openOn: browserModel) maximize.
! !

!DBXBrowser methodsFor:'initialize-view'!

actionsForTable
	^ OrderedCollection 
			with: (GLMGenericAction action: [:each | each selection generateCreateTable ] title: 'Create Table Script')
			with: (GLMGenericAction action: [:each | each selection generateDropTable ] title: 'Drop Table Script')
!

addConectionsPanel
        browser transmit to:#connections; andShow: [ :a |
                a tree
                        title: 'Connections';
                        act: [browser entity onCreateConnection] icon: FamFamFamSilkIcons new databaseAdd16x16 entitled: 'New Connection';
                        dynamicActionsOnSelection: [:list | |conn| conn := list selection. conn notNil ifTrue: [ conn actions] ifFalse: [ #() ] ];
                        display: [ :model | model connections ];
                        icon: [ :model | model icon ];
                        format: [ :connection | connection displayString ];
                        children: [ :selectedItem | selectedItem children ];
                        updateOn: DBXConnectionAdded from: [ DBXBrowserModel uniqueAnnouncer ];
                        updateOn: DBXConnectionRemoved  from: [ DBXBrowserModel uniqueAnnouncer ];
                        updateOn: DBXConnectionStatusChanged from: [ DBXBrowserModel uniqueAnnouncer ].
        ].
!

addMainPanel
	| actionList connectionPanel |
	browser transmit
		"from: #connections;"
		to: #mainPanel;
		andShow: [ :a |
"			a dynamic
				title: 'Object View';
				display: [ :model | model glamourPresentation ]."
			a dynamic
				title: 'Query Panel';
				presentation: [ :some :element | some custom: (self queryPanel startOn: browserModel) ]
		].

!

announcer
	"We use only one announcer to refresh all the windows. because we share connections"
	^DBXBrowserModel uniqueAnnouncer
!

initialize 
	super initialize.
	browserModel := DBXBrowserModel new
!

queryPanel
	| table resultset queryPanel |
	queryPanel := GLMTabulator new.
	queryPanel
		row: [ :r | r column: #label span: 0.2; column: #connection span: 0.6; column: #actions span: 0.2] size: 25;
		row: #query span: 0.5; 
		row: #results span: 0.2.
	queryPanel transmit 
		to: #label; andShow: [ :a | 
		a label 
			display: 'Connection:'
		].
	queryPanel transmit to: #connection; andShow: [ :a |
		a dropDownList
			display: [ :model | (model connections select: [ :c | c isOpen ]) asArray ];
			format: [ :connection | connection name ].
		].
	queryPanel transmit 
		from: #connection;
		to: #actions; andShow: [ :a |
		a label
			act: [ :item :connection | connection startTransaction ] icon: FamFamFamSilkIcons new bookOpen16x16 on: $s entitled: 'Begin Transaction';
			act: [ :item :connection | connection commit ] icon: FamFamFamSilkIcons new bookGo16x16 on: $c entitled: 'Commit Transaction';
			act: [ :item :connection | connection rollback ] icon: FamFamFamSilkIcons new bookDelete16x16 on: $r entitled: 'Rollback Transaction'.

		].
	queryPanel transmit 
		to: #query; andShow: [ :a | 
		a text
			display: #query;
			populate: #executeQuery 
				icon: GLMUIThemeExtraIcons glamorousAccept 
				on: $s 
				entitled: 'Accept' 
				with: [:textbox | textbox selectedText asString ifEmpty: [ textbox text asString ] ]
	].
		
	queryPanel transmit 
		to: #results;
		from: #connection;
		from: #query port: #executeQuery;
		andShow: [ :a | 
			a dynamic
				title: 'Results';
				display: [ :entity :query | (entity connection execute: query) ]
			].
	^queryPanel
! !

!DBXBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowser.st,v 1.3 2013-04-15 13:51:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowser.st,v 1.3 2013-04-15 13:51:54 cg Exp $'
! !

