"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserOpenedConnection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserOpenedConnection methodsFor:'accessing'!

childrenForConnectionModel: aConnectionModel
	^aConnectionModel fetchSchemas
! !

!DBXBrowserOpenedConnection methodsFor:'glamourBrowser'!

actions
	^{
		(GLMGenericAction action: [:each :x :y :z | each selection invalidateCache] title: 'Refresh') icon: FamFamFamSilkIcons new databaseRefresh16x16.
		(GLMGenericAction action: [:each | each selection close] title: 'Close Connection') icon: FamFamFamSilkIcons new disconnect16x16.
	}
!

icon
	^FamFamFamSilkIcons new connect16x16 asMorph
! !

!DBXBrowserOpenedConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserOpenedConnection.st,v 1.2 2013-04-15 13:46:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserOpenedConnection.st,v 1.2 2013-04-15 13:46:16 cg Exp $'
! !

