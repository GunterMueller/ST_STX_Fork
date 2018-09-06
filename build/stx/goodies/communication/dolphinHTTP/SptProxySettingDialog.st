"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

DialogBox subclass:#SptProxySettingDialog
	instanceVariableNames:'useProxyP hostP portP'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptProxySettingDialog class methodsFor:'public'!

defaultModel
	^SptHTTPProxySettings new
!

icon
	^Icon fromId: 18 in: ShellLibrary default
! !

!SptProxySettingDialog methodsFor:'public'!

createComponents
	super createComponents.
	useProxyP := self add: BooleanPresenter new name: 'useProxy'.
	hostP := self add: TextPresenter new name: 'host'.
	portP := self add: TextPresenter new name: 'port'
!

model: aSptHTTPProxySettings
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aSptHTTPProxySettings.
	aspectBuffer := self model.
	useProxyP model: (aspectBuffer aspectValue: #useProxy).
	hostP model: (aspectBuffer aspectValue: #proxyHost).
	portP model: (aspectBuffer aspectValue: #proxyPort)
! !

!SptProxySettingDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptProxySettingDialog.st,v 1.1 2011-09-23 13:44:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptProxySettingDialog.st,v 1.1 2011-09-23 13:44:36 cg Exp $'
! !
