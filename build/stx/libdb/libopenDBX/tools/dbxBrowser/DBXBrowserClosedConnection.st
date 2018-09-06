"{ Package: 'stx:libdb/libopenDBX/tools/dbxBrowser' }"

Object subclass:#DBXBrowserClosedConnection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXBrowser-Model'
!


!DBXBrowserClosedConnection methodsFor:'accessing'!

childrenForConnectionModel: aConnectionModel
	^#()
! !

!DBXBrowserClosedConnection methodsFor:'glamourBrowser'!

actions
	^{
		(GLMGenericAction action: [:each | each selection open] title: 'Open Connection') icon: FamFamFamSilkIcons new connect16x16.
	}
!

icon
	^FamFamFamSilkIcons new disconnect16x16 asMorph
! !

!DBXBrowserClosedConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserClosedConnection.st,v 1.2 2013-04-15 13:46:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/DBXBrowserClosedConnection.st,v 1.2 2013-04-15 13:46:13 cg Exp $'
! !

